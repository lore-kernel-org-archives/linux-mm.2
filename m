Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76AA9606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 05:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RxH4NkQQ
Received: by kanga.kvack.org (Postfix)
	id 621D96B05B7; Wed, 11 Nov 2026 00:56:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D5B16B05B8; Wed, 11 Nov 2026 00:56:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425A36B05B9; Wed, 11 Nov 2026 00:56:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0558D6B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:56:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6666CA017B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:56:44 +0000 (UTC)
X-FDA: 85421779128.29.CE5703F
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 875E71A0007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:56:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RxH4NkQQ;
	spf=pass (imf19.hostedemail.com: domain of rohithmatham@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=rohithmatham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794376602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SVdC4NoqsEAb0xjeu4zg9bcnEb0TfO6Tqq8G+6Aa5+w=;
	b=Y5sn85wMtVA5oy9Jvf7sltTEIhqjks29xsEsV/JUPuXgZuLFfbZnS4NHBezC84iOCzSc+I
	RCfQ2T92PHyv2Wgf6b60c9p023+zvJjL8yedO6tBAK+k/WlwM+P45CZFSIxbW/W0lAywGV
	3qMCuhbm39jjBXuwzKHjbbLDMOKso4M=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794376602;
	b=c8JwxUyxwPZUn6dY9b4QHlmfVx789zjipmrJ5U4ocvQ3wPcvF4wDYKjTQZ4nkK0d8wQQnR
	C079Vx0ZS24klm6Ynud/mXfDplFf1KPrSJOCV6dkCfga3AT84cBECMWCpnXwb5Ptb4Zbi7
	aUjDuj+MMZgHDZt4+JcgxWAmdUbq0RQ=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RxH4NkQQ;
	spf=pass (imf19.hostedemail.com: domain of rohithmatham@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=rohithmatham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-43bf9548df4so2816060fac.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:56:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794376601; cv=none;
        d=google.com; s=arc-20260327;
        b=WViRvRTe3rsFtCNv5NoQbtTvgUpwwK0Cp7MhbH98BYov9IxJcPN45TwiIeSsEcGCiK
         BJBi0bkhN529jY+VsafXl1f8prckxGt5GInvXIevC70uHlNIFs3nNvpjhzkcb1fUiyDj
         zNYViozFGK8FkhcIUjQTWSOajYc/EcVwaZZUXZ9ibKmWR6krIPqr7rDJ/Hzxp3N5dHBd
         yZap+eV/AnP8buNj4r0m4a5BE1aZTI1/pYwS5wQjOR1x4+lS8EqUSBBU9ppFYod5GSxo
         ySEBKmm8K67kDIB4ixpDChuP3BdDRbGONdqKRXaY8EByZAEmdGVJIdKMnRVQzCk1SbmD
         m1gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SVdC4NoqsEAb0xjeu4zg9bcnEb0TfO6Tqq8G+6Aa5+w=;
        fh=itf26aBEox5NaoM+gPfQ1b4y6Y5BIO8k7qWL7uE6XS4=;
        b=KPOFBVWznf0u/jN0jxi+td4KU69djwXLUxEVS5DwsDNW/5lTnrMN86phfDALnKygLM
         JJluqYUzMQwFWnaBlIOHQb/dK5bTHDSotXyDL0Cuj62SeUAlOdUebsZ4vave13V2/yaB
         RhlWuVDDyD/71qv1HP/R8YPyHtZ/bWgV1ryvvivUW3F5MHMWmQeeSBwTSXSL1chjFr7H
         vDAK/fCi3zcdcZ/0gIQBAZvxJXIeKqB4L6cqY2d9scfm58R9sC87RFgxVn/l4uk9JJx2
         qMW0PoBnT4IRpccy83WeUDCicQTBc+Z+EdEaHbVZBfrNCMkvcQleDDB+OIsq2R+ZG7bI
         AeRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794376601; x=1794981401; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SVdC4NoqsEAb0xjeu4zg9bcnEb0TfO6Tqq8G+6Aa5+w=;
        b=RxH4NkQQgexftCYHcrB5Q3qVVzzu83GvZ8rJjRtoTSocM7Ip6YrlA0Azj53J2dbhW6
         ChqBdJ53XaYrvEVUH4rKtZHbRbK3gNMBIJaZGI/zimBpq7+nWmraC8BMrEi73s8f+B5M
         t/uybRyV/2efjnKYmCK7Z8AwwgO8T2b7eE7KMEL7bOhAUbYQsfZVywFfTW8e/I5TDW3i
         e1wKP3drpxG3SDf4w4QFuT9gfgHC9Ohdf/jnpsGZD/SjfqVvkTrCCAssdQp+doEagwTI
         A+O8Tu4NkfGVd8lKO301sW/n3B6OgNeplwwYssQ7TcxYZR+K8/MWN29GixuerytrG+j3
         xNjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794376601; x=1794981401;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SVdC4NoqsEAb0xjeu4zg9bcnEb0TfO6Tqq8G+6Aa5+w=;
        b=ZZqxocgfwfVSL7B9t2TNw/T3gZY6V2ngpFMh1P2lWhAkchZi8ZkAXLx6GDRO5zsNHT
         GmwFnZRw+ZQKZmhffkIdL9Wxu+qM35bMK9Rl26XDX2BNdKdFp9m6K7m6kJ3KArT7jth/
         Psedy8IR+YfMghkjHvE7mFmDLdc09YlQj5ucOWQSpwhwg1EJvitVvCh7hsQ9E8tylGPL
         rys9N9yvsZCfyGnlneGAj1aXtXZhMGRf2THiOdn7QuDdj3Za+LiI0JxvWUhbn+xhhLu0
         u9BJ9I3iDIawzgm2zVB0Ck8ZGqRh13jeG/6BuutyloR1mK+3ppYs0upSsqE8YKBAMt9j
         EwZw==
X-Forwarded-Encrypted: i=1; AL+hErF1WMYxqdp1cZj5B5r07Xwfs/kxvaXF2J8UtMyB8TmN8sswcDc7NxDHaCPlgKlBvYrpZ18YnJvqQg==@kvack.org
X-Gm-Message-State: APuU4Z+jaoRlbzzyFJ16RcRbv0c4lkfsq8scK2gWRKc6gYOX+3jr3qbr
	+YzBxkcJLfL5oERiqE2uANmh9/5KecQTS/ZJvZ5ZSm7+Z92pYhCUkQMWw0+HR4UDTAILggbT1Ov
	Yq3yTLc8g9NSr7fAo5TrblwMjW64dn/8=
X-Gm-Gg: AYBFou04IJK5k+s3wzF8gFCTxetVCAY+5U3N0PXlfb1xESR8ksXSXOBdmxLKHlBYTUf
	H5E0y00mnkinJTwsN7Vb/gAP9CDVh0Lr4DnU9KsmrbVnu5TAZhiL5H9QwVTJR7HNk0sx2DBxRDv
	Iw06FY9DF16Bb3UhOHIsJZtsTloveU3XesQmf0Xe6r+IjaHrWTUO2+TfeCJnrEXqafhpz8I7kqA
	/IBz4VpO/vMbppqcsntdqAz98aMsEneCxauu/64MwiopiuRB4CJNsFC+dShOlW31Zo04dZvZTul
	2UjSgcHOaa0c90lvU00zIfthp2dVCkwhaaktesH1cnEEC+5l4+LB4bBVSCNtdjvjsAcJmEvMExR
	xhh5MrC/EQBBbghlJ8uD3PpSUCGMgv+MJXigfIcDw7+FZA4xeqCvVxCpuR3F8q0ZeKKciXPHdm7
	cqzgFXnDIeEZB8mUG5tXhtV7o7YCndAihZH1m+h1T1AUPezE7qhOk=
X-Received: by 2002:a05:6808:4f23:b0:53a:e153:e901 with SMTP id
 5614622812f47-56b932504ffmr1277212b6e.2.1794376601509; Tue, 10 Nov 2026
 21:56:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <6ae09458.f0fe5aea.79aa1.008e.GAE@google.com> <20261027101009.18e9136537144533915008e4@linux-foundation.org>
In-Reply-To: <20261027101009.18e9136537144533915008e4@linux-foundation.org>
From: Rohith Matam <rohithmatham@gmail.com>
Date: Tue, 10 Nov 2026 21:56:30 -0800
X-Gm-Features: AclHuK-vbFkZZTGrimsL-YTV39zkF7VzvFxaCKkhVtRTZJlOUBJ0WGB_WgVtgM8
Message-ID: <CA+FtcErvvvg8EQUpgravNPTib4_CnFb3W20PY-xMYSTdDH4=4A@mail.gmail.com>
Subject: Re: [syzbot] [mm?] [usb?] WARNING in corrupted (4)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot <syzbot+9fe09db3795456e0b442@syzkaller.appspotmail.com>, cl@gentwo.org, 
	hao.li@linux.dev, harry@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-usb@vger.kernel.org, rientjes@google.com, 
	roman.gushchin@linux.dev, syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	mchehab@kernel.org, hverkuil@kernel.org, duoming@zju.edu.cn, 
	linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: 3n6o5195oknfxq14wh7975zku6ckupgb
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 875E71A0007
X-Rspam-User: 
X-HE-Tag: 1794376602-379024
X-HE-Meta: U2FsdGVkX18Xl7vb7pc/aLJMSna8CHUs3f8LIN/rHeX13W9l/TlnlmtebfD97qlVLtJGLc4R0gfavstVJCzDXpGW+RHt2W7YWAloXObIuVuEbFREFjh5PuLwLAi8Bwyy4uuAlaiSo9TEIa+80lC+jva30pvPWc1VKgv9HKtNGKaWKjx23f51BjA0BMclBAAD+irVJelKqRl44tGes8+ov7PKHNxFZ1wK1mcZ1E/UGVYTOjCn4KxOYHLgkt6GdMxHxPhePdBY20Gh8N3j9/RMwCJYLOjbsQqRfsQIxKocz+Q9P12wkiJjqcVs8a9UpHiy2Xk3CVcJFW61R7AprcftGSB0DXtf16NotsmQwUGDRn2nl+wzLf2RZQsbJUMQopcVFWaBOzsJSUkmfm/q0ggCcL01DAyw7y0Mp+y71jiZbZ/wFshf44i6hxdqPSsJ07APbs2VS8VzSQRSBoWjzA04Ru4COUAGuzq/lEt1AeV130Kcj3o8Y2tef2nXUt/Fg0I0hn/LQLaOAdnmyqDYrrIEuyF6LjlaDRN1WKK117z0qq1tpnpKhc4C7orAbLkLpMsVUwjTS5htStaE82xW+hdcrGg9cBEpY//JNr89h6Xq0vLOL/28FzpcTxap/t/6LkUKsPIAkaZxNzsLro1Oh5x2+oEAHtNBdqkeN/8zY+1igsQTX3OD0UqkogzN4BdU6PfOvjr3MPXCqyp4YM/2F+e8FA1qsqjNOwz3HeSMij95x9OXPN+v75oOc1yzQ1DmxDFtfexFFTeAbUB1NhP7n2UlPatFl7weCpuIFQ3TaekcxEV44Oc8XpF3VsiDa4ZXssZQLhYJUxfBIq23KHa/P7B2qpCUH8dl7ikYjGcmTo3kHF08bCwYgYM1Ueu5o+3oEyqiQSiIqG7wo0/dqgVF1V0eBaahAALHU/MM6GLheMGHzFgJBwy/kLoY5d9N/Jc4cr2NiVntoNYGeLns290P0Vf
 O0evUiMH
 y0ZLqb0qZhCur5/3CJ4r9cWJ1LPNBV/FCilt5HRiPBC8S3HfQ9kHXvL+ZGUSri3RqBlr5mxXYwqQH8ItNhiiQ70V1fYGIQgt55Bu8W5u2gJg1TP80txy70wsA23h8vzaHWuoiZ1XBpKocgnREirUIJ5LChKwamyCgVsgta7RTJE5PHzsfCiWhvE3DMScLR8oOuiFtnYPxM0Fa61OIqmTd9CmuVdIh5VnkDVDd3iMI6Wwb7gfsbVN/w6fIeSsWMPEXtXG4f36k0ZF2zSQFaSBsOVqRuJIvCB0rtpF5did4IlPSldk2dvBdBr2boL4zpDEKKh4HCS/O3MRHTM14q2YbfsfI9DhVLBSQR4kFZ/F4tSMGiri7PjaS63FYAK8OBzfBNfeI+pvPrJh+ve1s+mvBHX9GgDXyk2of6RhSQm/dyG2TioVtQUCNbQwv4Tcs6imPCLAY0hnPp5jL+pJrD0zm4yS5q57RGlNA2NWLQMsW7jyVsZ4RV84nKwsdhrMUJUur5biP9EGB2uKjSNxp36WacFKud6xI7g02NwuerbER926YVn8Z9dRj964AyCGDsi26Zvbhv5/UtgmjHR93e7yd4xoUFpEmRPFTiTK/QnRT2X6kOF6rjT39eIR5L/rHYa/8D3WgJe0KvPHBJTvZGJtS+SZTReIh8JZWzKOOeQqkpX5sZzIroe062H/RdM3bdUURuMZO7gxpWuLXMPIna2uJCh3MhjpYwke5/CzW3CpJBZadlYEh455WdoWeAyHsl0yA1x+rCuFupibjsMqqWIKLlqgCL5VpyyVNFfoxH2iYqTbV19opt6lKCfoOsprgKc8Thhm6vQ4qKKbne5Mwj80fcmo1qfpSesvQRPX4Ewfm/OfwQuS/SNS2TUalpAkSzF50uMxAgOh/t23smCRaCUV2xIoIjoFdLO5P/heVd602uITD6vHjyY01rfplTA1KGtb4r3JnmQ0qaCAG8dQlQ+vg0/6M5sTn
 Uxbqgsqx
 qS/vp3V2GPT4s70EP49piIlmtF/ZvIx0lcSrRqUt8E/LAprRKfp3pXrfnSI6JbY851Pfsk3C8d0jkVMM7xUEBEloOWtP4Df90b4hkMo4omLwpk2HcykVMYXMQQxHo+T2gqVsP+FpOSOhHHqhRw9sOrDxwlzFR0NcIPnUOagzaT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

I retested my v6 patch against the October reproducer, and syzbot
reported the patch test as OK.

The patch removes URB_FREE_BUFFER from the Siano-owned buffer and also
fixes the related work initialization and teardown ordering.

Patch:
https://lore.kernel.org/r/20260601201639.63171-1-rohithmatham@gmail.com

Mauro, Hans, could you please take another look at v6 for inclusion?

Thanks,
Rohith


On Tue, 27 Oct 2026 at 10:10, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Tue, 27 Oct 2026 05:08:56 -0700 syzbot <syzbot+9fe09db3795456e0b442@syzkaller.appspotmail.com> wrote:
>
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    5b0764a53235 Merge tag 'drm-next-2026-10-21' of https://gi..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13739fc9580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=fd1433abd362f255
> > dashboard link: https://syzkaller.appspot.com/bug?extid=9fe09db3795456e0b442
> > compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> > userspace arch: i386
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11cb9b0d580000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/05ac8658d211/disk-5b0764a5.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/9cfb73243216/vmlinux-5b0764a5.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/fc45c7faf785/bzImage-5b0764a5.xz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+9fe09db3795456e0b442@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > !PageLargeKmalloc(page)
> > WARNING: mm/slub.c:6855 at free_large_kmalloc+0x97/0x110 mm/slub.c:6855, CPU#0: kworker/0:1/10
> >
>
> Thanks.
>
> > This report is generated by a bot.
>
> So is this report ;)
>
> This looks like a double free in the Siano USB media driver, rather
> than an MM bug.
>
> The failure occurs during USB probe error recovery. The allocation
> comes from smscore_register_device(), and the page-owner records show
> that smscore_unregister_device() has already freed it. The USB core
> can then attempt to free the same memory because smsusb_submit_urb()
> sets URB_FREE_BUFFER on a buffer owned by the Siano core.
>
> Rohith Matam posted a patch in June which removes URB_FREE_BUFFER
> and fixes several related URB teardown races:
>
> https://lore.kernel.org/r/20260601201639.63171-1-rohithmatham@gmail.com
>
> I don't know why that patch hasn't resolved this problem, but it
> would be worth revisiting before developing another fix.
>
> This doesn't appear to need any MM changes.

