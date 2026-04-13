Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FDBF34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 12:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EEAA6B008A; Mon, 13 Apr 2026 08:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F406B0092; Mon, 13 Apr 2026 08:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D2D6B0093; Mon, 13 Apr 2026 08:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6683E6B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:53:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE6AEE0D9B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:53:11 +0000 (UTC)
X-FDA: 84653522982.29.F838011
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 823E9140005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:53:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AibREVVx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776084789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KMCu5pbyxAUFkOL001PQr0awj8BCaZ0FmQ5uDJ5p4j8=;
	b=8T6WYfyuzzdACIcTuI40eQvUV3hSArrWKzUy7zIRfFpR3ErhW4B0KsbiQF4ThXVrZ9/1jP
	ZRviWtmqPYKdn2b76DMIaMvJK1YSJ94dqK8kqEUHw5qCgCMt8yLejLidSufYqo/oBvFLxB
	l7rvwwRliTiwxBQSdm78jTO+94tEXMM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776084789; a=rsa-sha256;
	cv=none;
	b=XYrcf+WAmLl4RGQT+TYgzmTJiafL7JrcSJG5ksxOccqq5MZJs18BYtOiRDBr4qdz6VBsR3
	x+fxmsgSv6/dNETcC9jnvgGjZLXosC1mjEBtrI+1BMnMgrjPDuRLcDwRC7emCfANzL1YSC
	8ZnuVNSoMl+TeYgXFZWK/P6cB0qZ9m8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AibREVVx;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776084788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KMCu5pbyxAUFkOL001PQr0awj8BCaZ0FmQ5uDJ5p4j8=;
	b=AibREVVxdyBeoXI5oJNtP2H01olnE/2ffRr5wI1oGaQ5eu7Rc0Sp6rJrPUPHUyOjPvsR4U
	152RkruyBQIouqcxZ7+EG9Y/NDyuXXUpI0WWD917+U8Q3V3wICxqSDlyC3j7lB2K47tWao
	ONSWKSlQukktffgydqnNt8J0Wm/JT0o=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-301-3jRHYeizOGSreIdDD7IqiA-1; Mon, 13 Apr 2026 08:53:07 -0400
X-MC-Unique: 3jRHYeizOGSreIdDD7IqiA-1
X-Mimecast-MFC-AGG-ID: 3jRHYeizOGSreIdDD7IqiA_1776084787
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cfcf23c0e1so841789785a.2
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:53:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776084787; x=1776689587;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KMCu5pbyxAUFkOL001PQr0awj8BCaZ0FmQ5uDJ5p4j8=;
        b=Jhfwm4pYsoONc9n52uGiYXVPzB2zvAHPvYAD6JsckHQGJ5YbnlPUgkkeVC1PyQUB/x
         FObww3xlX1uwIZht9CdPPE/JZ/DH9MJk3p5rQRieXFubNcVY0OlKH6jW7bXEw5+stqsh
         cloJrOacUdDK277QwXTbgIm/len9QYjsqv3iHF+lfiG3Bu7P0ke+le0CVX4/MK4OVt6X
         nC6DHVGO46Vcjmoj/RZVzr2Pxc9wdQf2Fl4xY0LeiUWRI+xz8pzPp8PWv7MQCb5Yhu0X
         DrIN3Yj380gQZ1v7u0u9HCwjTGtsUXOs+RWhsmoXPLDQOtMV8rrNOvaTuojhze2TpaF+
         OARw==
X-Forwarded-Encrypted: i=1; AFNElJ/Jxm3h1NpVG6mKcx/arhkDfk4IXexSH1UpESfD4372xzT6itV9VtZmvaFMlAtl1EfUAgiimWlr0w==@kvack.org
X-Gm-Message-State: AOJu0Yxqf7PwM73lwFCei9Ay6Kk6dvhhden0JrJoQR52WOf+6ABxgO6m
	KBBjW6bgqeuBG50ZjgGUH+02v35280CegKQQ96A/BLz+qqpo2KmDGzlKf7TAMxC7zDm8EykAmNG
	jO4//+0/dIkGDc0i3aTbi4rE5cS2MYkD3eeXtDsR1DnUFsZVeSmPPL5+9ZXGX
X-Gm-Gg: AeBDiet+v8ufrcuEFxvkB7uzR/XYM0ByC/7Z00KR7FJkR6VAQPXPhe+rzPZXdf3vZPs
	m0q0iyA21tWtliZs9nlWzmmc/3fqq9bW+PuDuNFv3+aNMX7HqjyL5xa+HGn/XARJWU9ft4rAeuS
	BIdVr09LmswND8I6kNbZtm63AW5JZdL03yA54YoWihWVmOZ/PL0Hw0mBhTk0inYPuSXc7OVAmHQ
	mX6KTaryvz3SOWhKAxnmOS/R+bYLk3XwxjjnNbLEjebIMlrbt0QQIFtMDAtrJQYwXUoCHIa7Qq0
	zFCDM6DvtKykhr0OBEP/d9qTSkY7jHMrN2FicOX9HZSKxtPOnLa6KJbJpPiRo7T3W7qIF5R/xLt
	tox3Jjkk8rSX9/6+0g8gj4Pn2RckU9Ms0oYBSk5HspRGUZgg=
X-Received: by 2002:a05:620a:4082:b0:8d3:a311:927b with SMTP id af79cd13be357-8ddcecbd791mr1802658485a.31.1776084786701;
        Mon, 13 Apr 2026 05:53:06 -0700 (PDT)
X-Received: by 2002:a05:620a:4082:b0:8d3:a311:927b with SMTP id af79cd13be357-8ddcecbd791mr1802651285a.31.1776084785872;
        Mon, 13 Apr 2026 05:53:05 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb8d6dd41sm864313685a.25.2026.04.13.05.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 05:53:04 -0700 (PDT)
Date: Mon, 13 Apr 2026 08:53:03 -0400
From: Peter Xu <peterx@redhat.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: David CARLIER <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4] mm/userfaultfd: detect VMA replacement after copy
 retry in mfill_copy_folio_retry()
Message-ID: <adznL0B3vCSBoL7h@x1.local>
References: <20260331134158.622084-1-devnexen@gmail.com>
 <20260331200148.cc0c95deaf070579a68af041@linux-foundation.org>
 <aczOCqrCx7Xd5HIF@kernel.org>
 <CA+XhMqzdQLZD4YWzyZfTwd_+sDnLqj24APqBRgum97_=8EcM2Q@mail.gmail.com>
 <ac3paYh6sPHr3EJd@kernel.org>
 <ac5yKatsMxNp4G2g@x1.local>
 <adeOIvNXFLTCXMcv@kernel.org>
 <adkWv9xdsyLMn9qd@x1.local>
 <adu-ScPEF5saZekk@kernel.org>
MIME-Version: 1.0
In-Reply-To: <adu-ScPEF5saZekk@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EpiTneu66U9vaWhknmmXL8JrmQOEjipwYzfiKNr1B9o_1776084787
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: 823E9140005
X-Stat-Signature: frxb8yz9p15drqc4fbzxy6u53o711ypz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776084789-22019
X-HE-Meta: U2FsdGVkX189vUaaswaYG3RVTE5u6e/E4p+Fo2x+rT5SkYxCTrBql6q71UwefssEiLnMIrjsHWS0qIpDbXBbZx6Y84rPe4U40W1BlqaABuHmOQLqP0IXM1HeDxWgTwX4cakyS2fJ5O9KtSO+A8bl2PD3QbaYIJ5Rk9e9a10Luw2FsXpNNJRyZVyDGoOu5nz0Ms/FBitxt9FBweIDbvtLm82+96jB0ts8et35Qi6jmTGgZnb41QGY0eRKNWkrxQ1FCgK03V/pWY8lSn5zaenApc2+olDBVGUbmnFwe7++MbW9+aXklKXylNp1agoXOpb4RIjkUoxvucsh+W0d74vBjO7ZHwtDsLss24sxqgB4ojPG92pkj3g6XzaKHuM1Bmwikb5q2S2SpXRjwfChwia49f5VOLX/qsq3TQpxzHI/WlZ2A/NEddznSXKypqxcIg63fE+eSQVjUeVzj69pnbTEskoEzpnblikAPgs9WM+AjUjPj/jX4KCMmm/csUP6hDrlpstzMhWQv+9ns/a+eMf8S/1PQshB6SeImL0IOCtGNHCiAfBTE1K6iFqgrQcPkwLfRqExXeTiuxkWk/0wA/FvulFskM0ujH+/Qf4BJAzH0PEofOJwX6F9rY1H0BhmqA2v9RbtwGHspV0AMSefMpUexbnt4aDfi5LpSeNPmtWS0BrdOhKhGOzyp0O+To8hjztCd+YO4H6d7dJOlOgS/Qmv8n+38WJIdx70vWw0D4icutonAUjVvlAxumI3igMaVW2ycimY48eD4RHK508ktgSgEx+yRJKsR9aRZFgQQI58YyOFBRSZmR2Kf2zGBkmkM5WhQyPUmHpGKEQAdpPWCkiyI85iqutDYwg2km55F1vHANoRQDsvulE6OCC1CvjZFAkGovwvpcd69PQNysfjgQ3nez/abnJx/lK26cxP2ZpqsbAQ/r2OD+8W6XNEgKK1LrFpBVIBtsknVrtoeT/psbZ
 XRI8lxYg
 hxeJvq2jGB/EyTvno8q+CtaIw6TBcCp+80PhyN1BEfM+K1bB6NaRan69PFzajc6JcJ+H7eCGiq1+1By0ebv/kcxlVfkSTck+5ZQGuSE/lqIMtL262+SBrsNxUIE1CaUz73LyJBmguiUWDdF5XVObTMDA8I+f5Vw5q47TCD+JJU9Q821dyEBO/82lVRQUf0A03xZcsxN8iA6djA7CEOYBd3kY4w9AX1k7QdcE+Z3bV9mVFeFQS6VAnQHMBveyZK6loBvTUsmCEQ+7tJd/dH8qccJeyXY0V7hPQ6GNz33Ur41vRs0nVPRQ8WzbnwXOPLxYScDfJN9rbmqvjMBzafoPlqyTIB47UYxkf//3tDE1Iaqn2+exzFxjHqGV7D4aYm8oFAKJMCHIsuwd4scq+bLy24qDKextU0LXvzxXAOA6NnXctFu/neoo5a0djRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 12, 2026 at 06:46:17PM +0300, Mike Rapoport wrote:
> > Personally this is least of a concern to me. Hugetlbfs is so specially
> > managed in userapps, so it is even less likely to trigger the same bug with
> > VM_SOFTDIRTY changes or other ways.
>  
> I'm not sure I follow you here. How changes of VM_SOFTDIRTY can crash the
> kernel in UFFDIO_COPY?

It was confusing indeed that I used as example, sorry. SOFTDIRTY only case
isn't a bug, even if it'll also be captured by "vma changes" when we detect
that.

I just wanted to say I concerned much less on arbitrary hugetlbfs vmas
appearing than most of the rest, where it can crash the kernel even after
the change (e.g. mapped one shmem inode, remapped to another different
shmem inode, or SHARED->PRIVATE, as others pointed out elsewhere).

> 
> > Again, I'm open to any suggestion on replacing the vma snapshot logic as
> > long as all possible issues got reported will be properly fixed, especially
> > in the latest mainline. I don't worry much on backporting yet; if this bug
> > existed for 10 years and nobody yet reported, to me we can always evaluate
> > the effort to backport or skip.  However, a proper fix in mainline is IMHO
> > more important.
> 
> Totally agree, a fix in mainline is much more important than backporting.

Thanks,

-- 
Peter Xu


