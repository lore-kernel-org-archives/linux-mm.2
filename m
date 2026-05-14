Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85675CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E026B00C0; Thu, 14 May 2026 10:35:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C25496B00C1; Thu, 14 May 2026 10:35:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3B2A6B00C2; Thu, 14 May 2026 10:35:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A11786B00C0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:35:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49D771205B9
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:35:49 +0000 (UTC)
X-FDA: 84766274418.27.0EA6AA3
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2DAC4A0009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:35:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YLAdDbRH;
	spf=pass (imf15.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778769347;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTI62x+Er1nj1TIupC3QumbIb31i/Q56jB/+lk1fIrE=;
	b=QCJ+S/3UA0TnUYyd0vn42X5yAL/bAuBx2dKv79O8W1FW/OstTSxsbdHMMjrdnI4QmZ72MN
	OAoC3YL64pMVDIZk1fPRfs5wceuglXRO0piSl9iQU79AMv8Qz0s45RY1HULMPMPIHvNZdn
	Pe3DJ0SoYu11+bXzGtG5mohZ5/pSarY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YLAdDbRH;
	spf=pass (imf15.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778769347; a=rsa-sha256;
	cv=none;
	b=bpWKlFTRVQj6m6/3MxEjAJo+lRKNw7WVSK9ujrEm0dEEwZNItHae2OLTUbKLyj+zxTFcrp
	uEnxtcyUFSwKeMjRExoeNOEC+kmmpfQYxC2mSld+g4I9AELRiCCLmMYxCBEApmmWUZb4Do
	v2tBNlr59kOfJOtusX8UOu3nNXTvxoA=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43d7645adbdso4434766f8f.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 07:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778769345; x=1779374145; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTI62x+Er1nj1TIupC3QumbIb31i/Q56jB/+lk1fIrE=;
        b=YLAdDbRHOn5gbJWDiUi2dinuwJZnwLeOB7SaLW+aNoAE9sAhMinIQ2CFytrnXh48n7
         lOtegEe17yXdn/lwBf77qRgjI61JE6mqYbQdV1huGoIQgSHap2OGb//Dc6WmBXWuyI+j
         7s9brQHM6/p2wbR+DhZEwImWshJLwRZzDJQWkUPDB82YUmxRr7/ObrQxItBLrPQMuRFm
         knma12ptOUBoQ4D2Ft0a+zbungoNcqLRav6G/oFNKv56Tkk+2rJGxge9w1eEkjJBlNH0
         hfDu5kjdl2hbtZZwvTuEcxD7f48hdl6LbKd7kUzVE+mBteSefoKkzV8HacEay/tnUYAq
         uYoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778769345; x=1779374145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zTI62x+Er1nj1TIupC3QumbIb31i/Q56jB/+lk1fIrE=;
        b=M1MjVgO8s18IL67HG2maKbwD7txdaoJA+sh7H+fIfG3+KANO/10vyL8swIE4rs37CT
         0Kvn4pj4AbroCIahW24jzvLizoOR+m3K4hsQu4bev7SD7Qd0uLcYAcY5e26BDeJVCZy+
         PcMzzeENNiNgsf8a8ZxeASc3mT9jLnz7G8kxSjAi9ptAsFunIFjAKl/u2hP0L8v6Mk94
         9VL77j2GilrmPRn62BsUkixMVg/1ikwgY7skguIBiyWKypsFJv0V5DKWcseYSMijeIJu
         eu7jXWlCmNrYh1TKqd05zF0V69paX+cemoqsn5CxgMmSf3FUWZmCuNQh78DjrPgCIgTv
         WbAA==
X-Forwarded-Encrypted: i=1; AFNElJ9QQ76XovkWU+RGNyD4tJcdyJ3hsOUzyjoTbT/9gFOK5QDEGqB/OHPSt3M8rTp4LiWDI7hBlWJwYg==@kvack.org
X-Gm-Message-State: AOJu0YzjPhBcAhXH/no548R0sqladDhAeyZ//DQ+XGj9goeXNvGyzyFX
	lZFoThQr+nFs28tKb8RmKEROd0TIH71Y2hlqyo97wtJFuvxR9XtE+zyY
X-Gm-Gg: Acq92OFSeIvx/OAU1MgPIQM/FH2wOFXA1gBlH19ttVd2s7oX3E0Adtw5VJfdMGY2fmL
	32Hu+1bhwyIOmWFDqXAYZKrHBrIuHJAqe/djstv9M44dBaHMMW+fSwEjGCx1AW5j8D/a9UlcYf/
	jn1rL/udqMh1Ez+zqqjyf8RwYbKHdYLSWrgJZ0P0NQzDOYDPgzZlxkia114PzCaU6wYCkpN3GPf
	BqdI9iWvKhxhmBqNFXAT/BF0WA/ZdZTXzLl31eRfU5EyQmTH6PTdRIhs2MBq/pIhY2vuRIX5Y2D
	3ATOSiT0u1j/rEQuhkyINEAR0SEZmL+hH3cwM6R9QyUE1gmUhMx3Qdl7rq0bFp9atDAudz/TFvA
	/JuPRr6QC2uQ7b1j42DZ6iJautS/FwaA3PmLZPfIp1IBTjZQw+8xL9FcbYDCKZLJ7yeIpM2H+FO
	WFZ2+Wo/BUNUQ0b1Gn0wiaDsGjjrxpaQkIXPU=
X-Received: by 2002:a5d:5f45:0:b0:44f:d9da:2c40 with SMTP id ffacd0b85a97d-45c5a1a8b66mr12863131f8f.21.1778769345395;
        Thu, 14 May 2026 07:35:45 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b093:bb00::bc35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe13a7sm7694530f8f.29.2026.05.14.07.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:35:44 -0700 (PDT)
From: Alban Crequy <alban.crequy@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Peter Xu <peterx@redhat.com>,
	Willy Tarreau <w@1wt.eu>,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org,
	Usama Arif <usama.arif@linux.dev>,
	David Laight <david.laight.linux@gmail.com>
Subject: Re: [PATCH v3 1/2] mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev
Date: Thu, 14 May 2026 16:34:15 +0200
Message-ID: <20260514143415.266045-1-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <8b29da5b-e260-4b77-a640-8abb447291d1@kernel.org>
References: <20260428122826.339550-1-alban.crequy@gmail.com> <20260428122826.339550-2-alban.crequy@gmail.com> <8b29da5b-e260-4b77-a640-8abb447291d1@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ftoxqrj8mxgo7goedkqwjnidzyau41qw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2DAC4A0009
X-Rspam-User: 
X-HE-Tag: 1778769346-425354
X-HE-Meta: U2FsdGVkX1/qJlja9Mz66//XmvPm3dPn2f5sMM8RlrcV1luJlChw+e9pzDYePn9Sh+Zjw6a2n4kkcg5e+IREI9k5doXqtO87/Qe2itSBBCgUg40ZhT5+yEYK50dWRfTfljVyhA0cw05kA/hIiPM7ipLjd2PIme1OX4g5eqAap0gtBC4qHuGyltDpvUsOZEn8spjCCMQlqtNJ+Q3yQ6yV3IXVjiDnMUJYvv2+rIHr0jtRA47X1QybgA6g53xEqyhKcUQqSJ8Xiiyg2B/FPLPseq66ay+3pJpqiIgmm/HFHLMJSn1wz1DIbOGk7WlHrshraHq6eoQIxKCbow70/Q+CeNZAFelTG1n48q91a42amGEdd6P5yiDHT779AlBjW4YWODSB3XNvg2JmuxbLXkOrkCVaCn20El4EByL9qM1ZmYGw0j6eqglD6N0e1b7EpPq2kpgfIPyEUkyU1s6LS1YAZRag1LIZLRrjDlpGv8gBuXa8wMKfJB/wiWr/V6QRxfGYq04snOMLh89rZxkyq76ht+otNeibYAKs+SyKAgQxzXh7pQzc5evn+DRs0gMchvMSKXwhOM+GZKWnzAjWS6mF+zK9EFGMjosuNZebYq99oyfxD76EMIz0gvE5s0f50yocbNF9ixgCQKpmKlmdGyrI5I8xSL3mmqFanJBjOQxJFXZD9eqqts8ApmJjNiO20MqFKT45xpTj8WYhv388ZoagycbSKjtFj221ZkpktaMUAuW5wGG21gEkh58OAGfohXzlhWxG60xhaQxVlBAFrMDtAsPPuw8zG7gLCHyukbkho3wjhf+L2+yDCZ6Rrob38XPqviOn4mXTVez+5kcevigIo1mO9QGCFHemTbDm/th9E+jtq+tkYLXlnf25L8Z7J3vhIoCCmP5ltYlDoZnuNGwI3vVa5BFbt4rnTbq3qStBdSZg1iNasIpjxhDx2vNwI40akDtc5Xpgskd1AIvIb1x
 kfYuHyH1
 OstrvA6xV8y6lkIG+jj6AzHeOCRl/GwUEZNERSDYhSIn8izICR7+QTcwYVNW5+ZQVmFTnmraEd7MmpLGFObo23dnNfZLN9usNvuja8W1TPI7mDqBJCqyOJhU16taAtMLAHghX775jgdb+WXik3Kzl7rrSERM3ssODly+Q6kmQ0pNPw1LF8FM1KzaGqAc/OXyKl2MiN1SSqqKW5my3Co6KMD9PSgYHGgD1orhdVNyMDf7nJzsTPcW3TaRvCOLJ82XhqyNXM4Rcgyt+n2OrzJOo1DH/ilw7gWh2/jiE/i7SlCldgvp5jK/zlHoPuxAC+QWrHaPPnUiagfYkCasykBVBvKChFhnIOlZC4nTtOqZ7pHHDZPxQjKVof2jonqhNgKYgFHPYFedKmrUiVmead3DgPtTGj1Y79h7Gibl0vuBDIOxrKbE79V5Gtuj0yEnpjZksWUGNbk124h1XcP3tFvG4Y7NIMYZI/ak68ID6km3Lmo94hxNUrwYs3oJKrRE0dzzeKn4mO3omo1CQav7Zw2hLirmktcaQQ5Tk++dTvog2LNdwAPvOOjriGpT+LPtxIg2iQwkM4yWpRhWhcGDBclacSa8Oolw1QWqwlw98UU/SX3LJ0NE0VdH5eBeNYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,=0D
=0D
(Apologies for the earlier HTML email =E2=80=94 resending in plain text.)=0D
=0D
Thanks for the review. I'm addressing all your comments in v4.=0D
=0D
> What is the expected return value to user space if we run into this case?=
=0D
=0D
If the first page is not resident and PROCESS_VM_NOWAIT is set, it returns =
-1=0D
with errno EFAULT.=0D
=0D
Note that Sashiko suggested to return errno EAGAIN to distinguish=0D
invalid addresses from unpaged memory. I haven't done that to avoid=0D
adding more code tweaking errnos; let me know if you would like me to do=0D
that.=0D
https://sashiko.dev/#/patchset/20260428122826.339550-1-alban.crequy%40gmail=
.com=0D
=0D
It can also return a short read, meaning it returns the number of bytes=0D
successfully transferred from pages prior to the fault.=0D
=0D
This is the same partial-read behavior as a regular=0D
process_vm_readv when hitting an unmapped page =E2=80=94 NOWAIT just change=
s=0D
when the fault fails (immediately instead of blocking).=0D
=0D
I've documented this in the updated commit message in v4 (I will send it=0D
shortly). I also added two selftests that verify partial reads across a=0D
resident and a non-resident page (with both single iovec and two iovecs).=0D
=0D
Interestingly, while writing these tests, I found that the current=0D
process_vm_readv(2) man page incorrectly claims that partial transfers=0D
apply at iovec-element granularity. In practice, the kernel returns=0D
partial reads at page granularity within a single remote iovec element.=0D
I've sent a separate fix for that to linux-man@:=0D
https://lore.kernel.org/linux-man/20260514083659.139971-1-alban.crequy@gmai=
l.com/T/#u=0D
=0D
> And in the same context: Will you send a man page update? :)=0D
=0D
I've included a suggested man page update in the commit message of v4 patch=
=0D
1/2, ready for the man-pages maintainer to pick up. I'll also send a separa=
te=0D
patch to linux-man@ once the kernel patches are merged and available in a n=
ew=0D
Linux release.=0D
=0D
> We try to sort this alphabetically.=0D
=0D
Fixed in v4 =E2=80=94 moved the include/uapi line to the correct position.=
=0D
=0D
> Thinking out loud: the c file is called "process_vm_access.c", should=0D
> we name the header like that as well?=0D
=0D
Good idea =E2=80=94 renamed to include/uapi/linux/process_vm_access.h in v4=
.=0D
=0D
> Should we use BIT here?=0D
=0D
As noted in the v2/v3 changelog: BIT() is defined in vdso/bits.h which is n=
ot=0D
exported to userspace. UAPI headers using BIT() (like tcp.h) work in-kernel=
 but=0D
break for userspace programs that include these headers directly. In practi=
ce,=0D
BIT() in tcp.h is only used by TCP_ACCECN_* flags, so merely including tcp.=
h in=0D
userspace programs won't break them unless they use those flags. Those flag=
s=0D
were moved from kernel-only headers to UAPI headers in commit 4fa4ac5e5848=
=0D
("tcp: accecn: add tcpi_ecn_mode and tcpi_option2 in tcp_info"), which appe=
ared=0D
in Linux v7.0-rc1 (not yet in a release). So userspace programs don't yet u=
se=0D
those macros.=0D
=0D
So I think (1UL << N) is the correct choice for UAPI.=0D
=0D
> This could return -EBADF or -ESRCH. We should document both in the=0D
> man page. (or decide to always return -ESRCH, dunno)=0D
=0D
Agreed with Christian's reply =E2=80=94 keeping the actual errno from=0D
pidfd_get_task() is useful information for userspace. Both EBADF=0D
and ESRCH are documented in the suggested man page update text in v4.=0D
=0D
Thanks,=0D
Alban=0D

