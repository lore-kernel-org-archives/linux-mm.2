Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E34CEFD16
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2292A6B0098; Tue,  6 Jan 2026 16:52:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D30A6B009E; Tue,  6 Jan 2026 16:52:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080856B009F; Tue,  6 Jan 2026 16:52:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E618C6B0098
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:52:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75FEC5D544
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:52:32 +0000 (UTC)
X-FDA: 84302888544.26.A56ACAF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2722420005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:52:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1uwYOfE1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JPYE1q2g;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1uwYOfE1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JPYE1q2g;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767736350; a=rsa-sha256;
	cv=none;
	b=iQi7Hhe7RKBPOftWlosCobJeYL9bVPtifEfqBcWiyHjpI+c7s3m6I06KAWxlDWFLxTFyH7
	DxloOtbkjAH5is/pUBEEzg38k3HI3AkM9YGA2cVD6SyjubMkwDu5OQynZkzEyeK9cihEiQ
	iQZv83OsSbwCE8Ns5sZDJKFT+AAnw2M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1uwYOfE1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JPYE1q2g;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1uwYOfE1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JPYE1q2g;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767736350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhfcYuntLo/0K/I5/LJIlPz4iiF0QOoGlUFbzP41ypk=;
	b=EDLyIlxferzdZlmmu59WLOjVKoX4fvMlFhmoa91PV+rbKgosEEdwF2lRHOR93OsdzLoAWG
	HrWKdBfNJsFmvnec0sgOsUlHrUPY3P58rstYhFt8PlbgUvJfw4j7DHoufn1aJOWWnSTjKA
	m/GLWVNuS7VWRZN9kOoUdgwwTbzr8/o=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4219433EDF;
	Tue,  6 Jan 2026 21:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767736348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KhfcYuntLo/0K/I5/LJIlPz4iiF0QOoGlUFbzP41ypk=;
	b=1uwYOfE1IbbFYBumW3FpqbgfTw68MJn4HcKT5dzZBq5uCqwNb/Be0WRQENYzwAhOzDZ/g2
	OlKbHHRRRW2Pl0zK3lZapeiOYkQc+056bVHMHdjH3rdkQxfDghsUL2E06HnOhDtoXzJoWj
	7Ce+3At/Ogb6mutvVHl4ls2/b/4SbVY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767736348;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KhfcYuntLo/0K/I5/LJIlPz4iiF0QOoGlUFbzP41ypk=;
	b=JPYE1q2gl6jhMpzAlZnqo8dfLZuHI+eI4WCjmihTkKD6YAizT2kmQOETKYBNkXJWQb0dH7
	wa4F6A/8LXwgAGDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767736348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KhfcYuntLo/0K/I5/LJIlPz4iiF0QOoGlUFbzP41ypk=;
	b=1uwYOfE1IbbFYBumW3FpqbgfTw68MJn4HcKT5dzZBq5uCqwNb/Be0WRQENYzwAhOzDZ/g2
	OlKbHHRRRW2Pl0zK3lZapeiOYkQc+056bVHMHdjH3rdkQxfDghsUL2E06HnOhDtoXzJoWj
	7Ce+3At/Ogb6mutvVHl4ls2/b/4SbVY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767736348;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KhfcYuntLo/0K/I5/LJIlPz4iiF0QOoGlUFbzP41ypk=;
	b=JPYE1q2gl6jhMpzAlZnqo8dfLZuHI+eI4WCjmihTkKD6YAizT2kmQOETKYBNkXJWQb0dH7
	wa4F6A/8LXwgAGDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1F603EA63;
	Tue,  6 Jan 2026 21:52:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id STtTIxuEXWlnCAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 06 Jan 2026 21:52:27 +0000
Date: Tue, 6 Jan 2026 21:52:25 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Alex Deucher <alexander.deucher@amd.com>, Mikulas Patocka <mpatocka@redhat.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Hildenbrand <david@redhat.com>, 
	amd-gfx@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] fix AMDGPU failure with periodic signal
Message-ID: <f6pged4wdv2qrpwn6uiqeampyi4m64xoey26eudw56k3txu6oi@3uwgwbyfrlwm>
References: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
 <61c3d41d-602d-4dfc-872a-873acf653b6d@lucifer.local>
 <20260106101249.be7514e75c09a928c6fa71ef@linux-foundation.org>
 <52bffed4-d9b0-4ec9-85a6-ba70e22106f3@lucifer.local>
 <20260106125912.a4975dd1919c913c22fd5101@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106125912.a4975dd1919c913c22fd5101@linux-foundation.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 2722420005
X-Rspamd-Server: rspam10
X-Stat-Signature: 6a4g5o1bd4uyhnyrkgwxhm3mgsr1ojtz
X-HE-Tag: 1767736349-252342
X-HE-Meta: U2FsdGVkX1+2aCkNjUwPwK1PMlVBwxslgwVy9hBTrkQXk0C4YBFWTKRnR24W6yfzzLwxgW/u+BO11LWOshuAJhlHTR8q1UHcr8cDWNamzlhVQrnfTUO9V/abpcIx0hcvmtNoJxz/YYqFAGDIABvNRRB3IQw4MxqFtjWubOx42kzSKjj/MoQptHWwmx82KwSoQjvK9fgKYBtDBksXfgedJ7wvfiDz2WgImfDZQ7rHlzV5puHjqbhwF5e/3rc41og5fY34NeCdUmZbazcoaG7n1Dq+52cKr6isDEncTZCgFUzvoKyoeEpNnxkMTQW3iMmZBkHVay83wom7X/XRhycfVDF/6t2kGombzhWYRwnoHtc8dIiHLBGqegBNYCYN2sDGHbgj3PH3MUhnkiQZQ67HXqcZaq2Gbr2crRemcIi/L8AXssZ1bOVrs9aeyiHP+oqds/qjDIwIe8g77NgXHSKyhJs2M+g6Jo0o/DY+XqXS7PbaW7Va5aHeZfqGGyCVteYuYlrTcfvCJ4Yl8W/ng8lNyA9tnYFbkGms2QniVSAjouN/roR1S301ZlH6FHd1YKzVXUsBM6PmRdOSbofd0H0r2hrXsnHDjhodJoV7N8a5ySoFeae1XMN6PPimy0MaI2SE2TfBTdVTXvDqKL5dSPmpdJLII1TH+SpUcGfwsivqsg2jy41gcpDve9lv9F4i6R+iDDT58RqfPsfkM/zep/EcEHUAcUnOYNf717Pfc2R0vRn84ci0fNbVIDsVeLym54QCZDWtyTNuYd+9SQreAdbmGkKtxCQfMXtX6FiXYuByDrwA4bzMMsv2d6Xm9+9Zxecca1+axsZNGbdr8dDIkYErqs2+xgzOnu5P3M4sbHKc6hn+uvMzdHqkqcCYWWpub4cX6J2FCXbJ/+F9+UREq57ME7+hMmVlGF3/V46NDHnWfq0mQC3THIh464LKYoK7eUAgJ4QE1HbAL6mi2koi1zS
 NIx/nT2d
 fex2ImGFmNklvh+7/rEe/gaxf4jSEITI14b/4H2KasWaOei65PI7eMMp68S3LhiICPbEdAq7nIGD8FpbylqGkA2UE3NLuTCJd2wXNwqqg4SPOqjXdOTJwLbxRX1thdpALByC1BPcdH4rHRh8ECYyhGo4UVlpKoB2OfXlvUOmb/+MTm8TE8jv+IvKZIwtasT0tt5UpwBxfGXljksE/y+ZzktNbzhHbAYCIlmyr7rjBiJwduEcGkRsazzpL4oh3xrt8uv/eSMKLyBZ2rIf9lXLcH1npgj2fE5BslfvCvSrIEfSzTKVJ/owvSpK24MAMddCVcJ/3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 12:59:12PM -0800, Andrew Morton wrote:
> On Tue, 6 Jan 2026 18:24:10 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> 
> > On Tue, Jan 06, 2026 at 10:12:49AM -0800, Andrew Morton wrote:
> > > On Tue, 6 Jan 2026 11:51:49 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > > I'm not sure if the git repos are lagging vs. quilt, but as reported this
> > > > patch breaks the VMA tests, and the tests are _still_ broken.
> > > >
> > > > Yet it's still in mm-new, mm-unstable, and even mm-hotfixes-unstable.
> > > >
> > > > This is interfering with my work, can we please drop this.
> > > >
> > > > Also the v3 is currently being debated, so surely should have been dropped
> > > > until we have this resolved?
> > >
> > > Well.  I don't drop fixes unless it's decided to be a non-issue or
> > > unless a better fix is available.
> > 
> > Even if it breaks the build and that's been reported on-list?
> 
> I addressed that.
> 
> > >
> > > I've done this for ever - I've held onto "wrong" fixes for *years*.
> > > View this as a weird issue-tracking system for a project which has no
> > > issue-tracking system.  It's to prevent issues from falling through
> > > cracks and getting lost.
> > 
> > I think a lot of the issue is these processes seem to work to you but those
> > on the ground are finding them not to work.
> > 
> > The kernel today is not the same as the kernel X years ago, esp. in terms
> > of sheer volume.
> > 
> > Having a patch that none of the relevant maintainers/reviewers have seen
> > land in an -rc out of the blue is a really serious problem.
> 
> It isn't in -rc.  It's in mm-hotfixes-unstable and it's marked "acks?",
> which means not to go upstream without further consideration.
> 
> > Also it was taken 2 months after it was submitted, so nobody could have
> > _possibly_ picked this up by reading the list. This is why I am really
> > underlining this case.
> 
> That's why I grabbed it.  Had I not done so, this issue would have been
> lost.  What I do *worked*.
> 
> > >
> > > It's unfortunate that this one causes disruption so I guess I'll loudly
> > > comment it out and track the issue that way.
> > >
> > 
> > I think we need a better approach, yes.
> > 
> > We in mm are really very responsive compared to most, I think asking people
> > to wait and resend if somehow it got missed is considerably saner than
> > 'well I'll take any patch purporting to be a fix from anyone so we keep
> > track of stuff'.
> 
> If someone wants to step up and be MM issue tracking person then great.
> I don't want to be that person.
> 
> And let me reiterate: had I not done this, the issue Mikulas identified
> would have remained unaddressed.
> 

I understand your point. I don't think anyone wants to see patches falling
through the cracks. But we also don't want patches to get applied without
any review.

Perhaps it's time to deploy something like Patchwork to help track
outstanding patches?

-- 
Pedro

