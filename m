Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E20BC5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 23:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B12A6B08C4; Sun, 16 Aug 2026 19:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462926B08C5; Sun, 16 Aug 2026 19:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39F3E6B08C6; Sun, 16 Aug 2026 19:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10D226B08C4
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 19:32:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4605160606
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:32:18 +0000 (UTC)
X-FDA: 85108733556.21.B8C566F
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id BCEB040004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:32:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=lA2Klji7;
	spf=pass (imf04.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.160.179 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786923136;
	b=jxUPoU7Ss5Yb55EIxXmOUCbfy+WCALL+pRFOzcNzzvgCy8Qn4CQz9IldkjIWQDtlvzgMpr
	gMQJArmOAjP/H3pWaGD4Zxxrj/kbYFptJGuJbz5wN+Cz0Ot3P8zh+BG7QcOD5WvZuo8PWW
	ZrM4cMgb1Mth9qeztkeZX/+LffXW+m8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b=lA2Klji7;
	spf=pass (imf04.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.160.179 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786923136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BioqsUd1GnS7GvqtNJ5JnjYlksYkVofgrlCf+OKGs8k=;
	b=6CvxnSsCjFWHy2ZUVaS2u5N8w606B48B+zHg9XnRI3f3CTfuiaKduo7XKXijRWxM5yrruK
	L3oZPZ4dhk/uU29ZejTkeHLKrAHzyuHmDhFfikhpjC3GXV7XEYxG+vcATac1C9uqQ46cck
	bytf1Dps3/tbOMll+8YyjHITBu0BqCU=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51a868b6962so28867701cf.2
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 16:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1786923136; x=1787527936; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BioqsUd1GnS7GvqtNJ5JnjYlksYkVofgrlCf+OKGs8k=;
        b=lA2Klji7Z/RihNNH/6Lr/fwQfgIfGF4C4QqGnt3b01LAM9GH11EvxWPPh4sEAElIei
         1tEDLo/EFT8bV5Z6V3sIFcTihaBUpe9nW2QTy+W7Pqu13VvKHxAXnjjNWzB2syupjCEW
         p/2gF1A94vw++HMgXABTrROo+CdG79nguMQwkL9LI5+IT6+jbDTiVhMDJ6s//Nv2nVjJ
         GnpuAfjoOSrzqFeR5TqhI2SZ8GKpyp8pTCg+t2vK5lLwPPSP65HpwhUJC60oeA3mSKYD
         MzHdjS2ZPUmlGEYFIGRjkXz09j5jYx0Qvrdd+4P6/Eu1hLraFt5xLqU9YtxXY5JdLdkY
         40Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786923136; x=1787527936;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BioqsUd1GnS7GvqtNJ5JnjYlksYkVofgrlCf+OKGs8k=;
        b=DfK0aH0ugKJgdSHe3fDK/KjIhMcqI27Y7I0+MRLzkmDcktdew0KF8ua96sfP2qTi5u
         muICvvVhv6NCjUG6BeN/DB8UJ93Yy3uPQ0t4aYcXpvRse2fvAi0UM012+7h5rk/eZekX
         p8PKVoTB43lUdQuEejbXotMX6r7GLJeIoWZADkO4iCdJzHs3/W5n4ILcWYOWfD9EC5oB
         rjS2E2mdY7QoM+tXHKlSPYqKf/Bfq9+SjVlCG1La+REDWjual7i9elbAGEa2CZzZustG
         81jxoxDMAF2B+hvlZk3x5uQMB9ienvcfZzStLIz0foGoPCKyYpHYFoexxadsj2mKEl7F
         miAQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp6tUnx0O7hXMMJByNsbfWqATJggBzLNrykliy5iInr2RhDJM65+pHL2ZUdSQq6htdZWvji4Swnkw==@kvack.org
X-Gm-Message-State: AOJu0YwSGwask/LHhBm++Za3pIHrvKL0Wxkib3c8gHwOrVJCHrPpkGMt
	Olqe5e7IkoE7mxc0dR2CqgmRw3+EbaTAduvX2rUGS7XV1ko3npw5MlyPaUWznc7TeQ==
X-Gm-Gg: AR+sD10NxuDpPBLMxA6aKrWyyeR3moD1oXimKdVy2+pRUGLaETdzhyGcGF97wmU3os+
	i3AbXy3xZHP1LBNYQUf7+mV17uK7HJU5L/ujQkF+jHUblfGhy+/wnCPNXnLTAZkSQ3QhfkIZdgT
	JbTk/11bIPHtaaoYtgUkibsFXbfh0Hu4sWq4WGHRudxDqYPAcj5zejRJnubB6iFYGRp4pBBvRM2
	sdZfdmRsiuqrycKXg4VulxOWgiC2EhHuoRmhJZ30VU+dEIR8i0gZbeEWVP3iwqL+KfkL1Jyk94o
	PY8XT0y29ot14lh/0luup27aUCkTSPuVCMRvnaMQKLvlUJIDXJkXqWOnA5cqz4mwZdVWvasmGYz
	x6s0lrt1qNGGDnldhdwDIZ7uuKCx8+kVGCGpHlSQdaTLQaJRRl6wbmvFgbmU3pJqVTNjh+DxM1J
	VTwvVzf2JMGsn2Vk4CygS+SQ51iBiRqY7FqBbrssfp2zB1oOQke6Yb2RFgv8TSHQ==
X-Received: by 2002:a05:622a:292:b0:517:6d82:ceff with SMTP id d75a77b69052e-52d853cbab0mr225176651cf.13.1786923135671;
        Sun, 16 Aug 2026 16:32:15 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::dfd8])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a9350678esm68674476d6.26.2026.08.16.16.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 16:32:15 -0700 (PDT)
Date: Sun, 16 Aug 2026 19:32:12 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com>,
	apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
	gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	matthew.brost@intel.com, rakie.kim@sk.com,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org
Subject: Re: [syzbot] [mm?] WARNING in ep_write_iter
Message-ID: <02c2e5c7-0d78-4763-90ff-75fa87105fcb@rowland.harvard.edu>
References: <6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com>
 <20260816135201.98590b17b526dda8c4ec9105@linux-foundation.org>
 <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKQP5QC9XTDJ.3MI016NP0NPFY@nvidia.com>
X-Rspamd-Queue-Id: BCEB040004
X-Rspam-User: 
X-Stat-Signature: ucswuu41ethj1sjxm9zi8ffxd589db1i
X-Rspamd-Server: rspam06
X-HE-Tag: 1786923136-673632
X-HE-Meta: U2FsdGVkX19m7QIiAFLMpL/vHiUDq8NMHA+O/55Wa3f1cu9isqq0TlS3UHeyDm+B1XT+0Tv+jm8ns3RK/XhEXAAoLmdJSqqAkHLFxnhGByr2eb2qmP77LmyUf+HvaOvQUihSF/m/3K3KWa8ONIghWR8MBGK4Cu/BiqJ3acnCcLzN/VOg8AUYXzBSiaqZdDtH/30QFkDWM5jr/AvQKTTy42pHS0GzK+Boh3pPEmMkBP82uQrkrTGKo+ideF1eMxaOxjNnZPCkHBC13a/+piOhpUEogvvO0k5nmbO1e8DTLfaQKLMR7sU4pUp4WeiaMKLHiLVlLx4Y79YyMdAkMcT/wWbu4dDhmZanG2UUeqdWmkhogKNnhCpuaMJCShqkwNEP+bdjNaJvXeqojegILsJet8K8bP0rYNbnpHO3r7GTfzA7lGpJr12Gy6CYQEeH+BAdS138bwjXRFAWyfx7M3yuEmbGVAgomRJ3utrt9ibQclPTKnUsE1bKnMboC1A6XgY0j3vw46PyQdTdNcwN6VKJZyiEDlAjz9CTG3ARR8Hk5rtxpPpUpGVLz0TV2YB/3TrvXZlc/d+eNgzhSvN9ix89+vEB9H/uarv/USyJFPxkiHQnl6eH5Ai+i2iG30QykjkyJ26fXEM8AQTS4Qon4JrVQehmQ0tttNTULXSEzOKoLT9UiR2t8VQ+NTStLK5F/YHh/vtj9CaJzXLaSQhD/KvQdbQMR42wtmWUv+CdoYI4nQGyc8Uo7XX3huvUKxM33WSHBlc7EFZdgF1N12TuwLG6ANrgGcpAWrz0qnLshC+HwGajKCoJAlPNjE6vr6J1PrDJWDfTE72jw88htQGM6IeOl0T1eE3z3HY0/iUOLIFgarHvFkvfjTcd7zg4/ub/eZfKC7fXcx50SByBgUKf8P7Mf1/yZSr14tBPPCj5y7RQutFKDTpDrRDJ/knVKNAG3eEvVsAr0xQQUtojl2UN3V8
 5ZqQia1Q
 3XosuO53edulKZegDuBVH6f2jYWscnM03cLprqNp8N6ji44Wo4fW6m5NQgowJv6iNrV2rBLTHXs2msgwaJksHVZI2+I2HNvwO1gRE8LkR8h5c4YkJ4P2aDzEsTbR/aFjKvwohTQ9jtsOYd9DomqheCBHnGtJIe7AYdOD1hLBYRxMKBaB9I4kXY5YwAGSawtPcb+5RMMLQ56oFA58fFlMKIRPTx+P5XW4B7xCxZBCsTNK0X6CqYkFq4387MYVrh8YXxAkHISqDNnytLghukbfGB0XAUvVof2hmh59Yzqkz9haa6svu5xHl/5G4oWemtXPxu4sBCpxPAE7rd95rCD5TRseSKriq/2YTK3nbxr+RwJ0LFsWZTXhmNImnlfY2uPJUHSGHXjUTKhNWcA3xNh10fvR4U99IKNjqkHYFKRWapOWaWXmw2nEKWlAoKGlmGg0QDr47GQ69jiIYCOxPxIrjNSlJwUZvNMfVhiKwFXcu+bwaveGR5zQpaf3Ukfbv0CRMGpIPtQZOBwZ4YPFKdjXTbXTiOQRaGLAvk0C+W20T9QUoy90Pv7Y6dBATdcT6IVywB1B5iyc5CRnLK0sUUk/kjZM8UX5DylJCwN+gRZeWh+PU4/1QlYXIIL7bXHPr6hV3KEJFvA1HcXas7xC+F/gksU1TQedmz38JnEGzqA58XA2gBeXcWDndKEOVZN0xaMPFaQbwYmXWnvpcCY2Y+WgLSc6ycgUzL7+Mf/OEYdQaxKY9WhXp/DenJbvubSpV1R+/6AA+aghCLB7xZjtYexU21qumgxNMR3A/uYwbvKiPpirpqVddMjCLxrYroxrRSgkMQR32G45doMgdDZ1WnNWA1Sw1C3uavDln8YDRJjUVmnRALiSefbvAHAm5gl8oP9EYBlQWGYFdKfw2wybIEmwXZVIjCyD557mi1U2c3a3tBN5IG6E6/LFYWBVgXEys6tmPbr3uS3Oa7QWiJXd2CBCn7yPodGrf
 K1NwGyUR
 lRn8EAJE0N3ubeMYR1+aUTkBZa3xpfTR6TCD+c4A/WawZt3Xz00G0BcXmJS02cOZqUVjwPQSWiDplEDoMR8IFir9+3FCfRxfiS3dLtSR3SwB0ukw3a6NsHU99bw+hEuK+9Hxy79nWW9p865m/NZ8Xv2/cWFzmdw0H5gaoJmuFrBM6KMCEAWu7EpFdMy0AzMKvZJRABMpIsvSQUXY/BeIjMhAdimJD/9w2nanaDePhMkcoDTQi3hMvWI1IXjkJ1VtwWzHbP7mPjFzpBoHgNxXh41LInPVeQ7+z6RANCAO4T/I3aR14uIvCOXXz/wo8mvlaeM0y9brEV3ulKJRBD7pYO7y7lOt9wF4TJncm7vZhBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 05:47:34PM -0400, Zi Yan wrote:
> On Sun Aug 16, 2026 at 4:52 PM EDT, Andrew Morton wrote:
> > On Sun, 16 Aug 2026 12:25:48 -0700 syzbot <syzbot+805630f1453e490427fa@syzkaller.appspotmail.com> wrote:
> >
> >> Hello,
> >> 
> >> syzbot found the following issue on:
> >> 
> >> HEAD commit:    3d6d817622b0 Merge tag 'scsi-fixes' of git://git.kernel.or..
> >> git tree:       upstream
> >> console output: https://syzkaller.appspot.com/x/log.txt?x=15927479580000
> >> kernel config:  https://syzkaller.appspot.com/x/.config?x=a59830cba91a1981
> >> dashboard link: https://syzkaller.appspot.com/bug?extid=805630f1453e490427fa
> >> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> >> 
> >> Unfortunately, I don't have any reproducer for this issue yet.
> >> 
> >> Downloadable assets:
> >> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-3d6d8176.raw.xz
> >> vmlinux: https://storage.googleapis.com/syzbot-assets/d19e0514c02a/vmlinux-3d6d8176.xz
> >> kernel image: https://storage.googleapis.com/syzbot-assets/f6da706811f4/bzImage-3d6d8176.xz
> >> 
> >> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> >> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> >> 
> >> gadgetfs: bound to dummy_udc driver
> >> ------------[ cut here ]------------
> >> 1
> >> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280, CPU#0: syz.0.0/5319
> >
> > Thanks.  drivers/usb/gadget is the offender.
> >
> > Gemini sums it up well.  "ep_write_iter() needs a bounds check prior to
> > memory allocation".  https://share.gemini.google/5NzjyttO0ULc
> >
> > I expect an easy fix would be
> 
> Maybe it is better to stop asking kmalloc for unreasonable len:
> 
> 
> diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
> index d87a8ab515107..20905f254968f 100644
> --- a/drivers/usb/gadget/legacy/inode.c
> +++ b/drivers/usb/gadget/legacy/inode.c
> @@ -645,6 +645,9 @@ ep_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  	ssize_t value;
>  	char *buf;
>  
> +	if (len > KMALLOC_MAX_SIZE)
> +		return -EINVAL;

Is there any reason to think that KMALLOC_MAX_SIZE is a good limit?  The 
allocation could still fail, and you'd still get a WARNing.

I prefer Andrew's first suggestion.  If the user asks the kernel to copy 
too much data, just fail -- with no warning.

Alan Stern

