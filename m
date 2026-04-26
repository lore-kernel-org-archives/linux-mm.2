Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E23E5FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 12:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8D336B0005; Sun, 26 Apr 2026 08:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D226B008A; Sun, 26 Apr 2026 08:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2CCF6B008C; Sun, 26 Apr 2026 08:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90C056B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:57:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E253214054C
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:57:32 +0000 (UTC)
X-FDA: 84700708344.04.26E4F8C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9D0D7140004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 12:57:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h0rm4Z6b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=U1tA5pdS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h0rm4Z6b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=U1tA5pdS;
	spf=pass (imf26.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777208251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnoxjfjkKVSJe2eLO2Hw3mw/Um7iKDumFSQ77+m9y28=;
	b=sW5/Uu7rYxdylSqjWh2OdCWo1Zk5pR3E+7n8kF6v42zKV8VK4HJmNoGCX+Fp6D2iNGWtNL
	4H2Im17vI3fxI8NqyBH37C8FMaa9V1m4QVt/ip4V8I4C4LJ5zHzm6ZuoyGj7xxGJ5ebsCG
	aPY4k89txG9aAXHSW4Qo68wabeNiE00=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h0rm4Z6b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=U1tA5pdS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=h0rm4Z6b;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=U1tA5pdS;
	spf=pass (imf26.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777208251; a=rsa-sha256;
	cv=none;
	b=0VBNURSKKQ4Jn97mgJqUelgT5sD/2eq8GbOh1t+A3PFpF8ly+0yMjhHnklpZjgFCwx/Kg5
	GKJ1IOyg9M3XB4AlPpWgfq2fVniuycLLtIV9o0KLx47ZHXaWdObBDZA5dlDYKqQjcbhn75
	g8HGKEHPbyQWkXiK6mxrCta4E2tU5uE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C87995BCF6;
	Sun, 26 Apr 2026 12:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777208248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hnoxjfjkKVSJe2eLO2Hw3mw/Um7iKDumFSQ77+m9y28=;
	b=h0rm4Z6blOcNrnmvq2xKH44XizFMfBTLPDf2GKXWBrkzkgV7eLvgQPBxNNAOCz4rQXh1GJ
	G5JxxMM0PowvZQAnsEOufZqfmhA641jT+d9NDh3uhYlW/Z/Rz75186r8Hs0zKTZla0wAPo
	8p+oIfbdTTRnpwP5qD0U3qGJQrX5tL4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777208248;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hnoxjfjkKVSJe2eLO2Hw3mw/Um7iKDumFSQ77+m9y28=;
	b=U1tA5pdSgJwDlU9jNU8VIbfVP/zpz5/jNgMb9Hn9731/tDLO9ih88MIHIrynlmZNfuMbAu
	RqELmCsdKAHoY5CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1777208248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hnoxjfjkKVSJe2eLO2Hw3mw/Um7iKDumFSQ77+m9y28=;
	b=h0rm4Z6blOcNrnmvq2xKH44XizFMfBTLPDf2GKXWBrkzkgV7eLvgQPBxNNAOCz4rQXh1GJ
	G5JxxMM0PowvZQAnsEOufZqfmhA641jT+d9NDh3uhYlW/Z/Rz75186r8Hs0zKTZla0wAPo
	8p+oIfbdTTRnpwP5qD0U3qGJQrX5tL4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1777208248;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hnoxjfjkKVSJe2eLO2Hw3mw/Um7iKDumFSQ77+m9y28=;
	b=U1tA5pdSgJwDlU9jNU8VIbfVP/zpz5/jNgMb9Hn9731/tDLO9ih88MIHIrynlmZNfuMbAu
	RqELmCsdKAHoY5CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 44983593B0;
	Sun, 26 Apr 2026 12:57:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4QNoDbgL7mlDRAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sun, 26 Apr 2026 12:57:28 +0000
Date: Sun, 26 Apr 2026 14:57:26 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/7] Implement a new generic pagewalk API
Message-ID: <ae4LtjAAOQ_2H8Z2@localhost.localdomain>
References: <20260412174244.133715-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260412174244.133715-1-osalvador@suse.de>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9D0D7140004
X-Stat-Signature: p9okjrmt86sjt94c6ixubfoai7ogf45y
X-HE-Tag: 1777208250-120669
X-HE-Meta: U2FsdGVkX19s4XBOV8MMuF3k1CHctnQrLY0AkbbSkWcNDYnYOSCEOIVkCQYS4iC2NhXhfeuKJtPhhQntB9t1ZBOCylt728r6zJH5xr9/Z1p2ZkeL2Jkt7Fd0A861FQZ3kKAl5wDZ0AoFUOHJPzniabrz6M8S31TZaYynK6/dn0tnf2Va9x9R+f9BUkLyIjyMx+yV+BNNxZRTd+BgBU6pXeOYidSMyN4Jh8BJbB1Ve9Qg1RcaEDPY+pVEaYchnkSX82pIsMkhEHD4qwLUmtK6NOgYK/wQXd8cM+KIY5rp6HrCpzeg1muXbCLLkDINEXOchsXsTv8oFBE2FCjq3nbpjDXUBlcSkRnhzAinFNLEWdHG11x8YeGgC2caqkeLwXdhSW7tOAvY326PKOOzp9tQqaD66YiJ6V+OLJp/fHeRzzdqCBe6Kf7iGhdvyrsUw7qi9DdGIgs3TqkiS85TgvBfTlnZn6vcs6E/wV4VVZ+SEVe9Ahqr9oKahsOsTG4KSe/eV6Py170IG2z845tSAAUJqXFOiOrbG+wOA/VOPjn8ImZgdh1XVLWxluoKHyNrYGElZUEurzeZbabsMT9jIA43y2ne/jsO5a8EeEOW7dhfP/yl44RlGhKs6b48Qyag5vSB6xcsD2SkdpMDAwnTvFr1mm+JkC7PSNa0JKq+KKtMeoj8kh+hz2hRRuTtfN3yDi0HyB37qEKNQxPpXApEbPtEnol7/U4SDy75mlJvz3Xvxqi3tDQ4raAa0+PXQV0PnIVKj5aSQg+/0FLdq9c7rxkvPzDhZ5TfjGAfbiW9rxGdqJm3+JcUYAxlItdxJGJcx8bCwDGH1goW33HCq1/GpkgwTR5WrbcqOHtbKFeRVB24OKFbY9Yo1E5fbdsVm0y2uPRgrE+BVxWc+XP0U4VEWmrNSudTO4mBe9rmz7eRXCJgxIiFoLLHK2RcHb5byr5UNzxJiWRooqENzh1jbVblHl+
 jIeroHZQ
 DCKzcYMPnRPQ/EKn5X0gSw2XxBpIT+pppIpz6/CITnZ2xDjNZ0I0EXEbEr0gq1XKSuPFCJM/whjukA3UCExDG1zUe1a7bdR6kYmqun4zc97+Y15W+dVXsJCwDmIh4YrX+WJjDw5ibfkNu7G+8Pc1sE4tyLcZ3ElcaCALCT6badU1ubwsqxlh9GIZvZ4jF0P7rApjBh/QlPOJeM2DQFaQkkzEvDoC6gKZGUOr83FxDHVaTnPBfOpkO8QZI1aBNSPRdiFRTwpxF/7krLkA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 12, 2026 at 07:42:37PM +0200, Oscar Salvador wrote:
> [WARNING]
> 
> This is not yet fully complete, but before investing more time into it I would like
> to know whether 1) this is heading into the right direction and 2) this is something
> we are still interested in.

Please, disregard this version.
I have been fixing issues to the point where tools/mm/page-types.c and
tools/testing/selftests/mm/pagemap_ioctl.c pass (mostly for the latter).
So, there is no need to waste time looking here.

I will post RFC v2 shortly.
 

-- 
Oscar Salvador
SUSE Labs

