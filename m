Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 020E9CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F806B0010; Tue,  2 Sep 2025 10:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F00D6B0011; Tue,  2 Sep 2025 10:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4061F6B0022; Tue,  2 Sep 2025 10:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CF1B6B0010
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:47:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFECD1181A1
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:47:03 +0000 (UTC)
X-FDA: 83844587526.10.D159110
Received: from silver.cherry.relay.mailchannels.net (silver.cherry.relay.mailchannels.net [23.83.223.166])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5773240003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:47:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=ahFuXh6T;
	spf=pass (imf12.hostedemail.com: domain of dave@stgolabs.net designates 23.83.223.166 as permitted sender) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756824421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRZMJhVX4LzPqmwkjT3d+FOTiKORmaj3h8jd47mnvis=;
	b=E5sw+81OzKCV33IOo7xEzPKMFvy1mgbc3JlRogLFlsCkSeUa+sDd1BILuAXIyexp9JfZtV
	IGLx9HWJifVHDywSdxPfCFIsakstB2bM7VTv/kKbRwHmKaWtU0r+Pui+WGQCLfJSGHrpmg
	Z+LkoouJHSR88ZocsGHnEbyXFLDA3Ns=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=ahFuXh6T;
	spf=pass (imf12.hostedemail.com: domain of dave@stgolabs.net designates 23.83.223.166 as permitted sender) smtp.mailfrom=dave@stgolabs.net;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756824421; a=rsa-sha256;
	cv=pass;
	b=0mc3TBrABRnPRY+1kW2kglm95pFq/udNf+LZStgQAMZHymDAGS7/u6PRDr4MKAUAzejyGE
	yNp3bY0C4k/R/k5STl6LotNmItjrFPm8XBnwqQXjaJpz06a+y7MRZn5DxekwUrhbsvE0Qb
	kKwDMKmVYVuFPYHqXIf7lLsqYtpH1tA=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id CB6D48533F;
	Tue,  2 Sep 2025 14:46:59 +0000 (UTC)
Received: from pdx1-sub0-mail-a218.dreamhost.com (100-102-100-57.trex-nlb.outbound.svc.cluster.local [100.102.100.57])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 26FB484F45;
	Tue,  2 Sep 2025 14:46:59 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1756824419; a=rsa-sha256;
	cv=none;
	b=d4SI0fkmOUSX2SGsH3tGmzA5T7O38Rb2zp3OVz0EZyQd+gAfR0U6gz/TCQIvNw0eilrIYR
	j7fSHsvtLaaG7qTJOzWy+AN7n0Jw6VTr+vT7pwwhmdV5nN3Yi1fNgUHDkw8+MnyqYROENf
	TJwiaFLP5hqiwdMDUubbK4NelDCbWRQTkabhZH4zgcPiz3s4cNx8LP2O+DOQTNF3ozgfqf
	vCh6LTaH3zgwqM+rj6h5YOGNEXHMDn2Y+kE77q1f7Mfu3GQUQnPlmnGN+PN+KyACX8z38m
	K6bT1bLpB7G1Sjc80nSsLE6hc41Fo6hAbnkakKgGmyZOVc17FTaQme+NZM+a+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1756824419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DRZMJhVX4LzPqmwkjT3d+FOTiKORmaj3h8jd47mnvis=;
	b=blLyN6tNLXUZo4Qn8DwbQL+wqTwSMr2D8fftXutauH3fR0J9UeDxnlzJ9Gozn2t8Yh+MnI
	WoYkDYLHDyeY5oH4D8Uo2yPE6/S8H9n5wyW7Ran/gboLRHdAkTFeId3jJ/8z7CQuB101r1
	c5sngHBottpeXNUq7RlAhTf38guMBoIQ6A5g8OFpkGDi+5HSVvYBBK1AU/TpkykGLcd7HM
	Ht5JM1EWmp1GW+kj7NQ2UkNyVEJ4uutBY5gBcRsuyYE6DXNuNUcdzk+PWLlPoHAdjyU5NM
	On7H2AYc0rLCFzXBgAtyoRfKNylmEAoh3Oi00Vg3D9Ck5lM47CRn5ftS8qhWAA==
ARC-Authentication-Results: i=1;
	rspamd-7b4c58cfff-wm9q6;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-White-Thoughtful: 6dfc35c35855886b_1756824419657_1353450583
X-MC-Loop-Signature: 1756824419657:4042092830
X-MC-Ingress-Time: 1756824419657
Received: from pdx1-sub0-mail-a218.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.102.100.57 (trex/7.1.3);
	Tue, 02 Sep 2025 14:46:59 +0000
Received: from offworld (syn-076-167-199-067.res.spectrum.com [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a218.dreamhost.com (Postfix) with ESMTPSA id 4cGT8y0brxz5x;
	Tue,  2 Sep 2025 07:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1756824419;
	bh=DRZMJhVX4LzPqmwkjT3d+FOTiKORmaj3h8jd47mnvis=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=ahFuXh6TLfV1SNfdspKZSAUyRRCEMTayPVRx7ctfIpGBahfb0Dp/YnYNoWAl/2nci
	 ED7kWBbA884J1CmHlDqoolEsxeLcGz1xNnbHoDXyjfMEOOjAQ5fWQbK0eiRExb1jwZ
	 r3njvCgIJuU/KHBqHKbD26Ra3FupmSiZ2oBtXnvd+PbF50gWUH4xvCOfiWkgO20Xv0
	 Pn7cu4FaKJUDP53K20BbVlOyA8K9AKlEuadnFFmy4/I/dbtzrYCrbH0Mc3IQRITR8I
	 oJvxhxZV2ueEMqbkRYKQR5Kyuo0N1S5o9VIF0erx5qJi+L7aDHi6pehxfM3fZ94MAz
	 nLjRGrHw1V41Q==
Date: Tue, 2 Sep 2025 07:46:55 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: syzbot <syzbot+cba6270878c89ed64a2d@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, frank.li@vivo.com,
	glaubitz@physik.fu-berlin.de, jack@suse.cz,
	jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org,
	shaggy@kernel.org, slava@dubeyko.com,
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [syzbot] [hfs?] INFO: task hung in deactivate_super (3)
Message-ID: <20250902144655.5em4trxkeks7nwgx@offworld>
Mail-Followup-To: syzbot <syzbot+cba6270878c89ed64a2d@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, brauner@kernel.org, frank.li@vivo.com,
	glaubitz@physik.fu-berlin.de, jack@suse.cz,
	jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mcgrof@kernel.org,
	shaggy@kernel.org, slava@dubeyko.com,
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
	willy@infradead.org
References: <00000000000091e466061cee5be7@google.com>
 <68b55245.050a0220.3db4df.01bc.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <68b55245.050a0220.3db4df.01bc.GAE@google.com>
User-Agent: NeoMutt/20220429
X-Stat-Signature: wdm8nyr4zqxnrymxewdemg7cz85jafmo
X-Rspam-User: 
X-Rspamd-Queue-Id: 5773240003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756824421-760021
X-HE-Meta: U2FsdGVkX1+OXQF5+Pi49tLAFMZrqqSI4Ql8o/8U7lrxeOW/AXPuab+d1jG8/G1CK/Pb2lDZh63ORriRyBAIfAfZer6tXbueuOgIYJWFnEZYEunEZbeHs/Rk1+xKkvWN+FVv4YgT27dzX+SnE2Lx+gxCqN2j8/SZ4phbxw+OTNoZSMnV8R3e4gPhteVdB5GL9VRii32gz2Dxxv+TwolzN2kM10l2HCN+vYn5DfLreUmgOAUgnjHLlmDiehHon8zMeg2Dz9whBr0/XjsiHR6wlRPtEtruxisjcwumSn+KMk5GNYR4l7F23P2I1SKweAkZtoHtRP/BwG4nzS6dtwdX+UtiTIMP8eoBtP/X+pWFsBxO92HcuK2oRAvL0kaJD8uZGyuJ2YaIQ3+1pIjKZP/u4BbUnk7Cduea5u8bcicv7lhl0E1XjK9GbynmaOJmSeVHGdLyLiHbxbWKokAmojzfYEmMtblITKzwSYWWi+Spli3U+0VCy+O9FltRdd2+yUS53hAEZ+oj4SUkZo2CRjIsRZcjBIQyq57lamk4p56+6JhsVmVd+ge17IuRH+r9/Yc3EICnKUgdUvtf8u1/WGsfsJ7tDAGvpLCB9Qx6tRYz8y3BkkEg/URbuJa1Rtp0d9FckpMEoVFsASkEWIXo1RM0PFUyuucMpqJ1L6Hb0rwsqS2QRQNdRcIWK1LrN3vvkYoW0x6yvP6uGekB3mjwb0vRkFA+GeV6knWBdhfWKsi8DmYHfw2fTv6gSVjqCbfNkcGGV64M3ieGqt2OHZZjHddaiichgp96zN/7MKxPku/GwoM4co+3Lcucxj/Ws8csjTJTIxY9H6Byb+x2ZBd6XFSx2yQyKSHDi1eSG12lB3CSM1QUsnX6KvaG+J9/bp1jJsMjUjAT5ILvLdNAcbCBop1ctK+NAiDMxzABWAM/nEKBWB10Y1llx5Gorl6eEQ04slQgSVb3oR/dpy8og+bP4R2
 DCyKvgDM
 phxRXZeY3hmCDbHc4O8QRSv954ojX50Wf1R0ZP+J6OIVvUY7LchpTXdWLCGVBQeM+pfLBzl+urns8vY8pO7j8lkKb1BnE3SowQdy3ndmnpKNbu0GZ6XKXQNtl9x9NC5fFXq5IDvGLjE94XRuSUXpdzT7Rup7sP/GaO8X/KM21enX76UNFvT4Zl7Mc9/GHD87nnJgYORcD2OBrB1C4Elr0DYbCR7UT6Uw3D3zzjbbiE6yed+RUVLDZIGjPbGAJajcx0Hwn0Xq0u5nIQ10C5CX6ZVhVDYj5U9vUAYUq6BIaOJkxDH7hCHRDMP4SkSk30Ns5lA6IruSPSi+HqYrYcjVckHnFEHsAZ8f7VJV4PzVockkebNyyGITz1x2rJmALBbAi7v8U9N+3LbUw9Ss+D9Kr4gXXhcXMrplvO3opTl9r3msqWeZs39dHY9Tz1HWZZ+W85sInOiUzrTuyVf64Yj+zlAiBtwwF3lSCBY6m2pH7NvIeWjK5kMS6pc5+J8x9TEU0GLCXXKPZFULYxLF0Zk3tHA6434dx6tXG/Doc1ZgJ+zBDxB0ZQzF1KqdfNvxxyC9u/Vklg1ZSHf8eyFGdfNM8BW1if9GpFo6rBSoH9idktGIma5cdrqQwj5fbBm9PFMysHrHvA1F46l7lNK3MekM63urTllkL5Akse96omvGMGxZsIFN9WVSFuSgaV+2CseHTN/7ZGg5eBL7aLk1z/MNfLmGE68oEqMr24k1y1A5Tas+9sqyhEXEQribRbr1roRZW9fWuCmBsPqqW1w0GC4oDZXr0/FFVm3Cv4dkkkP1INCw7u8Poc7BRGK4qsXpdIm4jgdHlrezhrmTQIS/XImWUKKmgY4W643P0fj2Kuii2JOL852msYN1hn8HSyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 01 Sep 2025, syzbot wrote:

>syzbot has bisected this issue to:
>
>commit 5b67d43976828dea2394eae2556b369bb7a61f64
>Author: Davidlohr Bueso <dave@stgolabs.net>
>Date:   Fri Apr 18 01:59:17 2025 +0000
>
>    fs/buffer: use sleeping version of __find_get_block()

I don't think this bisection is right, considering this issue was first
triggered last year (per the dashboard).

Thanks,
Davidlohr

>
>bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=101ba1f0580000
>start commit:   c8bc81a52d5a Merge tag 'arm64-fixes' of git://git.kernel.o..
>git tree:       upstream
>final oops:     https://syzkaller.appspot.com/x/report.txt?x=121ba1f0580000
>console output: https://syzkaller.appspot.com/x/log.txt?x=141ba1f0580000
>kernel config:  https://syzkaller.appspot.com/x/.config?x=bd9738e00c1bbfb4
>dashboard link: https://syzkaller.appspot.com/bug?extid=cba6270878c89ed64a2d
>syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10857a62580000
>C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14f5ce34580000
>
>Reported-by: syzbot+cba6270878c89ed64a2d@syzkaller.appspotmail.com
>Fixes: 5b67d4397682 ("fs/buffer: use sleeping version of __find_get_block()")
>
>For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>

