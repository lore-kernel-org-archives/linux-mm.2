Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D7E6CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 15:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490276B0093; Tue, 29 Sep 2026 11:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4408E6B0095; Tue, 29 Sep 2026 11:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356556B0096; Tue, 29 Sep 2026 11:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB3E6B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 11:35:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A50D120564
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:35:18 +0000 (UTC)
X-FDA: 85267198716.18.B511EE7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5B9A28000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 15:35:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BvDyLXUQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aGjaaqRn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OCgd65Hc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rUuRO2JE;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790696116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgCIe29fZ+5xH49B4VEfi+E+Krs4iRnCTa3+DRXXnsU=;
	b=pAOolzA7EPb8cAbYYYiUapUgNabd9Zgk4KgbN/IS7zoIFwapKoxARQb04MfP6NqGVRbLgU
	5jF1vuIUYUshj5vE4U84uxsCqN/DtAw/TH1p8eojK9Qb1Xi+evadk9Kt0wVIpIXr+pnDYk
	CZyM9ylBw7z9D92nsPUuO+Kz8nh8yG0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BvDyLXUQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aGjaaqRn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=OCgd65Hc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rUuRO2JE;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790696116;
	b=PemQw0rr9FB1jO51LFuXXWj1ecLTTF6hLRESz4yLNGfnoRamv33nHkCbisejMlarvHs5pG
	IFSSKKpyMffVanCOIRz9F8WD6xMCY82+7tYENTAWiQjvk3+p+uGpurHx//UyggCCVm68oF
	YVFwbV9I4vNiXvAF5CM2ynyRDqiM6g4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BE74A21DA4;
	Tue, 29 Sep 2026 15:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790696110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgCIe29fZ+5xH49B4VEfi+E+Krs4iRnCTa3+DRXXnsU=;
	b=BvDyLXUQEKOGEmmc7ABTO2Ab1MeHkFQs6eRhvrTo2mv+85vXvxQbPIupfN0klUfeud27z/
	n1ict7cfP4H/beOYMkLPc5TrpLEkL+99h39AD8XQCVTLSkJ/vcR4WD8tvD+9hpJomelbcB
	+HpvYhMtG7ZSj7dCN79u8sc+crSfJng=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790696110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgCIe29fZ+5xH49B4VEfi+E+Krs4iRnCTa3+DRXXnsU=;
	b=aGjaaqRnIbkSxibQRfUrlU77mFAX5Hu9yUsfgBrzXQeh6DyqajLxiKuwE8ISV9Wbe3rFwz
	GaCR+oaHprWFqICQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790696106; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgCIe29fZ+5xH49B4VEfi+E+Krs4iRnCTa3+DRXXnsU=;
	b=OCgd65HcH9IRQ4saD6ZiSUkH+3eIak1dcIu4ZXAvMIaW/smQjsPBeCoEd1XpdDtaXvrgbD
	OA9KmHtVLkQZCeVS6nNDaV+JL0yG90ZGjOlZMbvcYP5XzegSWPiE5GSEt496LWwItpoESH
	MScSlPFhlwi+KzHY9gkQajObTK9ulT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790696106;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgCIe29fZ+5xH49B4VEfi+E+Krs4iRnCTa3+DRXXnsU=;
	b=rUuRO2JEncH5woRLbU/2tZDBOq1hmwYAJhQJW9r+6UUcj5ToyWB/02Y0cCarpr5067pN5u
	tCBYKQerH33UJkDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4BF61136E4;
	Tue, 29 Sep 2026 15:35:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gN/3BKrau2oKKAAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 29 Sep 2026 15:35:06 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>, Hugh Dickins
 <hughd@google.com>, Daniel Tang <danielzgtg.opensource@gmail.com>,
 linux-ext4@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
 linux-unionfs@vger.kernel.org, linux-mm@kvack.org, Chuck Lever
 <cel@kernel.org>, Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Subject: Re: [PATCH 4/4] ovl: Expose the filesystem encoding through sysfs
In-Reply-To: <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
Organization: SUSE
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-5-krisman@suse.de>
 <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
Date: Tue, 29 Sep 2026 11:35:04 -0400
Message-ID: <87mrt0xe8n.fsf@mailhost.krisman.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: pz54e4jzfxyguydxo8136p8rurzcsq5y
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B9A28000B
X-HE-Tag: 1790696116-644836
X-HE-Meta: U2FsdGVkX19ZdhYEVxaoYJ4q59Xni2ashIQbq8lC/+1L/2WXEhIx8pOP7AkdltnV+pRW8RCy5IBDnfmf24GrnbUZ0CaMj7CFe73F5uJXCbH0O5kU4e4sAqMh8aBCw1zpQdsbRYP0jtK1l5FZx4HhSEpTGkBUqIYVbgKq3X3TfAghkYKMLww3JMMX8YI0/S/IXbVHcr9jr7npZsh1unmvtvUOGVPikHj/syDDBY0kA+a8Bej+1FxwmI0MEtJJGwr6TI+7SRIkz2Re7Hhztd/hY74IRWIuxQOgpmli/mAMBKAoumneE3vHUfGLDuicviyrD6TO6YoNLthIUcdxMt9YHumjfC2qx/BR49ZeOOsvfB6uobN2nz+96UcE1reO4yvExu6D8fHyi/9Xyd03ybYNgGzqIUQCGOi3uXZGJWptGiDO9vkHfVjTb9yecZkeoAZk+0ckPh81EwdjyBJKxWm0oLJl9+F6tZuQbi9sU+48hlnQKOUowDbgZ/ymHe9nd29IElQcxLrC/G53ga2qDieSBWeq5bgdXcO0VbL2Xi4YAZM8T2zkwssHrsBwgmUj2i0H9Bcn3xhV/iVs04IRK7k/OCs51tT7EfyTfEbq4yTMqVcSMvpbOUnOBWG5FfZ8j63epfXb1pso87r/RxVWaYq6xmtHTInWed1N5sS7G/W5M9BUer0gKBgpKl+WpqPTUvgCV5yVn6HHw64NAd3w67W5U8Z2Evxh7GFZiCTioemAa0W8B4zRlLbBcCN6Fnu7tBkyMDfsgecyyq4XdeJkk9dyzQ8m3GRM5m/4HF44L9CGx8p3Y5Jaypgthybrxz3N2iF3HbkDChZiwMytxF93pSafRFH7xi4yus3LM2eee6knwLsfvQmownJA7TuyNnXRSUddsIQMs0E395LVz8ZOgGKSP9rMCMspSI5meI/SX3gaqSewK+7h381HBdYbpq3owG4L88SS4wRn7CThLompE/K
 rbNOErNX
 kVeiIHPWEIUyg9i3DQVy53FvUHcMjvNK271NySO4TQFK0muafuw6m+fFJoMcdgWRLpbw8nCpqDWmiRI1cFKGQ3VMNHV+zVNuWPffaFOx4SJDQapJL9qq4PV6RjUu0r6icfDYHXFHZvzTpByjwPHVXR5oFUsaL9IInlMRKdPWphFqbuFLrdn6Sz/ob4sG/y9WL5e+6guNsIR9m1l30Lpm6D4OPKaqAHClPv/kUcexxYKpQ2rDNyo9jygtODbAMdvU6a4N1Vj8gMmlM1674sqsOFdbo5DDNiY5B7q5Y/EH4p6PZJ97YilnOzg12qD5RXUeiqKp6DQ3ZLZdTlYyqqWonC75YNJswHFDh3Hjdt7JHKXqHKVtSn0HhikAbNb6b8TwQ8jbZFTPDMd78tgjsg/OVJVRnp0JPj/Uc09vZLZBzJu2g5fDZwLbp1hcRu/G3bOKxG6wj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Amir Goldstein <amir73il@gmail.com> writes:

> On Mon, Sep 28, 2026 at 11:32=E2=80=AFPM Gabriel Krisman Bertazi
> <krisman@suse.de> wrote:

> I am not ok with this API.
> It is wrong in several ways.
> It is not generic, we have already file_getattr() to get casefold status.
> There was a suggestion by Pali [1] to get the supported xflags - statx st=
yle,
> which can be a way to say if a fs could return FS_XFLAG_CASEFOLD.
> In Chuck's v2 [2] FILEATTR_CASEFOLD_TYPE was already suggested
> as an extension to file_getattr(). I think we can still do that if we inc=
lude
> proper versioning in the casefold type.

Ok. I'm not fond of the overlay part of this series at all, in
particular due to the major:minor design.  I was looking for an
alternative way to do it and didn't find it, thus /sys/fs.

> TBH, I don't think anyone requested this - you only mentioned
> the need to know if tmpfs was mounted with casefold on and that
> doesn't mean that etx4/ovl patches are justified, but ext4 can decide
> for themselves.

There is a need for a proper probing API when deciding to fallback to
userspace casefolding workarounds, and that is not shmem specific at
all.  I'm sure the Wine folks that right now use ext4/overlayfs will
also benefit from a smarter way to fetch the information.

> The point is that this sysfs is not going to be the standard for all the
> fs that can return the FS_XFLAG_CASEFOLD, so I see no reason
> to add this sysfs interface to ovl.

Ack.  I'll drop patches 3 and 4 and wait on ext4 people to see if they want
patch 2 to match f2fs. Will also keep an eye on FS_XFLAG_CASEFOLD.

> Thanks,
> Amir.
>
> [1] https://lore.kernel.org/linux-fsdevel/20250216164029.20673-4-pali@ker=
nel.org/
> [2] https://lore.kernel.org/linux-fsdevel/20251211152116.480799-2-cel@ker=
nel.org/

--=20
Gabriel Krisman Bertazi

