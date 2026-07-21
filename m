Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC3D8C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B4A6B009B; Tue, 21 Jul 2026 09:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA546B009D; Tue, 21 Jul 2026 09:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695466B009E; Tue, 21 Jul 2026 09:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B4B26B009B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:54:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92279160184
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:54:16 +0000 (UTC)
X-FDA: 85012928112.23.C9D8E97
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3576A4000F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:54:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=YBD+2Dal;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of "prvs=5662d1cd31=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=5662d1cd31=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784642054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUQl8w/tCNZUmL6ORH+1PSjLkxbMu0iDqkOMcb+z7d0=;
	b=DNTCWrYLQ3vJiL8gvvJ5KjK4U1NzWulRPJ4j6XgBFW5tZykYOMYoXztwAVUucHk0hlKZS8
	eW72YZmc+gjd3f8LVOEVh0dk2th1O0tlioNCC32gemFpZWnY8R5jNth0+Z1xgY/eVV3MRo
	oPcoq5dqcud04w/4LFTxVY6N9yEY9AA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=YBD+2Dal;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of "prvs=5662d1cd31=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=5662d1cd31=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784642054;
	b=8LoWl+WekGrnZMjEt/4YWI5QFjDImIW0n/qKwpxLSJO6RfkUDTfkqqZJ1EJ7xnnlFyRUUZ
	mZdXYfbqHwGe16+ep7LLhhRWicOJ0QL58usBoHFfyEokL0fxgttbXFvdczsa5hO8goDmJj
	M/q4uPqz/o+AFZKKNCqI0EEEKIRb35o=
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LDkmM3868722
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:54:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=LUQl8w/tCNZUmL6ORH+1PSjLkxbMu0iDqkOMcb+z7d0=; b=YBD+2DalN3fz
	5/kGwOBxcA62V2lOVTTPZWAE0381NX+BmCWKGpqrFlz4AUru9T5bpCpH5J3XhYZV
	nQ9WNhhLv8qGmjpYEx9Z48/y1cruBOlbsQEnj0/YAPiNBAEjx5OZrrnsYg06kOVh
	YgTR/klJD1Yxq+pR3+66ivQyp90Ynyo9hdLENOd5HYKGZ+oxQ1MdUd/lLg5b6wDV
	MghHOpSNu6LFQAtKkj30kJ1F1V7B44m0z64NPV0Hs4UlYYEy6gz/nIB+5xRGxeIc
	hRAyTWP3vsLTUclgdkqISWAvPU0D7WYUaQtyOCzCaKFK+wyvh3tgfhaOrMFvsRgX
	NPboe9Ajxw==
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fgu4dn8yw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:54:13 -0700 (PDT)
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-69c20d12deaso8067029a12.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:54:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784642052; cv=none;
        d=google.com; s=arc-20260327;
        b=JJ3h7IZpuOdRJAXmE7MYZo6t7Q2CJHBWeN+BNVwJoGUHDKyrhMCdKYrUTEy7qw1+xp
         NqAhS+QV890Zx9tmDeRU/JSeuV9Usjx/Yim+5YQC0sYJ2kCwZ9AAEpBuxB1vTSAmliOO
         /ekvRfzARXQSUJMlQp0vD3R53KoioeWB5Rpd2fPm2mDFMecY1mWdY1d/KACO4wwOimWf
         /SBHusjqI6646LTu2AZiD3vhV0lIZRlb2u4dyE6etOYfaEzz99yK6t81f5WWxRGLSQDh
         StrTUPSyxXA968NH+hVCohXCSH3LVfPPLKEW6mlfDFd6SWAXEv7DY5sL3vYhcgu5nakF
         FdHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=nIDL80KtD6wnmPSqCXrQiaALT37Hkoclb/wbnqMQCZA=;
        fh=EihGocHNR5DVUsijVgOTkrpizJmVl5onnOD1MSpKSzY=;
        b=Iv0TnqrBDAAfOVOwHYNQue2ZNGQM4awfsfHciC/ai/B+15wGd7GYV7crhA+Z/IuG9t
         SFFxVKv8eH/7k8fCLDBuLxB7gEnzmHU63miFnEP1uE1VcdJsOkYk6mi48EEk3ohFnS38
         JRGeg9xcFM63qIvY37TM59CeY103OUwviu+ntnLPP0ux/fy7cHqmK/0QkPRmjEH1WsSn
         EqweLBQsDfih56g/QL/Z3NKiaM4np+uG0qGKn1uKOVEIbOL18EqkkSB9HjquqPNtUgjD
         mhbZC6d3VHrjkP4PQHpTX1haAJcIyDP4fodwPBpnohcXKmAJ3cBBXDFMowrEpLr6eme3
         sjcA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784642052; x=1785246852;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nIDL80KtD6wnmPSqCXrQiaALT37Hkoclb/wbnqMQCZA=;
        b=qT8aH1FvIn2Gtfwx4wQ7OJ0z+hvGRUFEkAhgXWN8iaUilbDNA14wu3WweTylvKpyGX
         C/gSm9xz4pHNBTXXc8yvxnWB0BQlhiaB3KE/a7i1axhD6EQCkbwMYT3/c/JMFnPIqx5d
         H6tQD6a8hbpi0ijy8KKMpj7vFYVTLLyGzYuvjFhfCV5aZiYJ9QBoRC3pmFZ74NTxqrkQ
         p7cE44Brw/pKo9UI6HQ2ytiRgrHnSPrj9j7CpatSOucMmIsepri+TEyXRcPCgPN7CAWb
         zFswzTabfKYjL1DEpRcRfKhFzl2uny35hASiZEEt4Z/pwX8cs8HnZr3rPq0EHsC3yth3
         Nkcg==
X-Forwarded-Encrypted: i=1; AHgh+RrOWbqHL6PqRvqjEOfy+80J2hgYHMgdnETwU0IgbyWq9ampYNMI+dyOVziDShaNAr5jARq1gvzoZg==@kvack.org
X-Gm-Message-State: AOJu0YwBI4Pi2xN6+buSM8HtyifQKruxB4XF5JWHI+UlKiUbn+y+mNF7
	pt8tbgi0EbLjAOf2UEDyTiRp7doMLIjDSfpDgHfSbC0nX5bpxhKb6wYlAWIzU1XGujr2M6WGG7K
	+R3/oKMHgueIdCG58QSvtXdfDgGDFh9EjgGRNpCOWzu7M+cgb7kqHys1xeunS34uGXkxa8BzGjm
	Jw+j5MFNCQDYvVVSYv1472pXvQwQ==
X-Gm-Gg: AR+sD10uq9/Ly5058u6vWRhU17F+ZYSwv4ZcBBtcfKuDRh19OnL0QyK/0uScaPkJMsR
	yZE1UQNrN4nGNTUDhIqaIyzrPOhUO90SLQ4R7wzY18AsfBsa/mZfXBWMkx8dy5xVNXs5AvWEcFm
	He00OmUssNf7t4lhy3UIwZpMqz0jzGBGEw0ROxStuD/J5/ou7IkaPMJuVSouYVSZakJh5me8Zg
X-Received: by 2002:a05:6402:20d1:10b0:698:4857:da53 with SMTP id 4fb4d7f45d1cf-69e38d60f85mr6616492a12.17.1784642051925;
        Tue, 21 Jul 2026 06:54:11 -0700 (PDT)
X-Received: by 2002:a05:6402:20d1:10b0:698:4857:da53 with SMTP id
 4fb4d7f45d1cf-69e38d60f85mr6616475a12.17.1784642051593; Tue, 21 Jul 2026
 06:54:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260718093723.153324-1-alex@ghiti.fr> <CAO9r8zM9SQR97cAJ2wLuJKjgi4oYatPP=3B6j=-hUhNFiGHDFA@mail.gmail.com>
In-Reply-To: <CAO9r8zM9SQR97cAJ2wLuJKjgi4oYatPP=3B6j=-hUhNFiGHDFA@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 21 Jul 2026 15:54:00 +0200
X-Gm-Features: AUfX_mwOdaiucsoBFvADdhFUV559YASJcxIW5cGawfUdA2jp8KNiQTFQmXojK88
Message-ID: <CAEmasaUxAy1LTtWwOvTurevGiGW5L4GHqDksiOT-XPN6_s=rjQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] mm: zswap: free cold writeback folios promptly
To: Yosry Ahmed <yosry@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
        Nhat Pham <nphamcs@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-GUID: VJTLzum4zYQ7jOusGDyzdg_q_QTYf9px
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE0NyBTYWx0ZWRfX26rJKJ6+U0Oo
 fnT/N82gr7AP/7dQe0GBkhgg1aFOMf3fjFY2cE7RSGE5qI78nq9k/ETtGKLpfHTAQOEXDdX9m19
 Rg3pQ7rqbRdnalFi0hFOm5Jza6UfJvW17omYCDLTueqa9o6Qu6c3wDJjxG1fRB0FX4M2vKnvui7
 CQ0pRJSOaKzS4bn39/X+tX8jaj8KsG6f9bXp6oiHOLBgn3T1ykVrVtyFgcDvgbi0tDk0sVgm5CL
 gDCIFwIS3mgL/LT7r9uSdVNcw9ITQLh+cG4tE2+ytP+k4G6AY2tzQGXJT4gFvXGjU0NCdDWz/yd
 c3aUJCMtN+5N5vCEawLmnWmsPByWJWOYhGJLB4uQNb1mFV1eV9MpJT+YJKpvI4v8+2dN29dw34e
 MHmZvBDwlaVxDfImwIZmI/mwcnz425uKijwvVkso48z7oKhqNgS2Nb4ps2xl5VjXmQKTXP0ZZk4
 mR+ua8tptjhxzoE3vHA==
X-Proofpoint-ORIG-GUID: VJTLzum4zYQ7jOusGDyzdg_q_QTYf9px
X-Authority-Analysis: v=2.4 cv=NOrlPU6g c=1 sm=1 tr=0 ts=6a5f7a05 cx=c_pps
 a=CYpx6mtW7qE8U/l5VCnCPQ==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=GbPsI2Ihf5RTnMjR_gZv:22
 a=VwQbUJbxAAAA:8 a=2e1iedC-D93VWRQiADEA:9 a=QEXdDO2ut3YA:10
 a=22KAYETGZJnyhCxlFjxL:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE0NyBTYWx0ZWRfX/ayrClkGyQai
 RStJm0T2hUAx4SR0oi7Ow3NEpW3O6FKG5HPxssQDmpOZFpI4p7TdfdCgbNw3ocfWTIwqBXhtKeA
 JiZHjV7IZeesXcWF2RsYYbRXZvnbQ/I=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-20_03,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3576A4000F
X-Stat-Signature: nyxxuxx5aynrj8hf1e5urfdkcie7o3bs
X-HE-Tag: 1784642054-813765
X-HE-Meta: U2FsdGVkX1/0nZF0nUVU2w2l2ww0EUJjXXyWRLruGozXNfJ6mH4QbqrvZkeb9n01pzi+psdcKTmejmMRmue4pAY7X3RqOu8mpQrWKvLbMwX6c21YMka7WrmSt2vB/HhfA6IRceiteByeQk3PdGxZOU0ckxsyiNje65Wq0vt5rgBES1L/U+7x30p04LAVQoVd1cwau59wz8d646BtVTQsXNAyQ69PKswHtszka5qILDD2dXff4lH49LosuctvrPlBHFS+hzmOL3A07PmqWdpn/KiIDOK2Y90FKlFnzefSktZnWp0FLkQc0X+N1oC5ghLG7RtwTfE+7fivrIBprR2R732z5JFRrONT72lbS1i7VQXCU2aojwRtxCakFlBljDRHG6FKY/sikWlmeFE+vM1PbbAA4W8efR/eHk+ZiqzF91lQE04AL5AAo5TXjek2CfwP4PPnyaR5jB69DHXPdHWq//4RHNWJZT/mHOghs64lEw4hJtyqfmFRYQ2+RWbZZeueFsGMT5zb6LkE05UoUb6YMUpDRGnHZi7/3IjMKj6vgeoeFmx0hsKmtvZBlFCvR4qViuGzGYqcr07mg+xaD2MY70muYDNTqpqrxXw4y+lumnJQ9pge5oKpEmfwnJSHcKP8AqNSU7tkCTY2irXkH0T/Ed7llb9ia7lT+Ad06eZfjgOZ9GxK32s4jWtbcBi28++xvCq3Qq79sQnn3397AHiAGwtB/S6LigrLMMVs8DNibwfBk3BpkBI+ybuu1olgwG6vkocFD7irFyKVP7U678S5l7TWMEd8HWeF3AxE1ZIy7Q7O2GDmcdgTqiWpd6Qwo/PwvVryPjVR7xjZXKieqtaX/oTcNQ9Inp3UkAbMBjbzxJOdXCQ1phZShQqqTfJtbi5vD25pgEqWWDRIbXQqG9kMgggqrpDBaX1SDL5SRfy+MYS4pjvL76LxfUnwCN9zx0PAEJZLe7CJ9dKGNS/iUF9
 ywSb21b5
 yPdPxcFVPeranN+q/oc43BlMUQtpWuD2Ir9QOphOPecglO+31D3hkMnUehvVOjGhSFWKEwTiPUzzgTjWehRtvPgf5XGAxCxz9I9H8r4soQztyhPbIeVbJsTtaXFjMyszTjeMgF+ZQH8XV+99NGnIkiuomJdt4WNCa856eSvVkJnWSaBT0qnz+EUkPoZjIC5QYih7k/ViD0iC8e2F8DeTxGk/CkDH8yIo2Lz0sGiimTWIdne7ggDeMDA5WIASS6z3bYE7nStdmLFQBcb7NQbx7TsuTrt6E6QP8kvc0k9tJ5Vjpaf3BEIT5jrHn94uklcgPWrbdGZerj8tTNsSwAjljSvkQzd+H5hl1BsYbPsrHpnGYueT1YUpE/pHSB/x0D3RGjtW2/AWYEqSfl7SO19qUyAhMu/bkT+BbjQ3rmjQ8mUIjLXzcQsqOmp+yjxSU+B7p4nLgVSLiX/ZP9EK0RRjt7p1M8zUk5QegFKwDTLGP6j5JoPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yosry,

On Mon, Jul 20, 2026 at 8:26=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> >
> On Sat, Jul 18, 2026 at 2:37=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > When zswap writes an entry back, it allocates an order-0 swap cache fol=
io,
> > decompresses into it, and issues the write. The folio is cold by
> > construction, yet today it is left on the LRU for page reclaim to find =
and
> > free later. That wastes a reclaim scan and keeps cold memory resident
> > longer than necessary.
> >
> > Free the folio as soon as writeback completes instead:
> >
> >   Patch 1 - synchronous-IO devices (zram, brd, pmem, ...) complete writ=
eback
> >             in the calling context, so the folio is freed directly ther=
e.
> >
> >   Patch 2 - asynchronous block devices and filesystem-backed swap compl=
ete
> >             writeback in IRQ/softirq context, where the folio cannot be
> >             freed (that needs the folio and swap cluster locks and may
> >             sleep). Allocate the folio off the LRU and defer the free t=
o a
> >             workqueue, which folio_end_writeback() hands it off to.
>
> I took a quick look through the patches and the implementation seems
> too zswap-specific.
>
> I am not super familiar with how the drop-behind mechanism works in
> general, but it seems like it's currently intended for file pages and
> not swap-backed pages. From a high-level perspective, it seems like we
> should add support for swap dropbehind in general first (regardless of
> zswap), e.g. by making folio_end_dropbehind() properly handle them,
> and then have zswap opt into this?
>
> I guess one of the challenges is that folio_end_dropbehind() only
> frees folios in task context while we need to support interrupt
> context, but this also doesn't seem like something that should be
> handled in zswap.
>
> In theory, there may be a use case for doing dropbehind for swap in
> general, right?
>

Yes, you're right, I have been focused on zswap here but that should
be extended to swap in general.

I only have performance numbers for zswap though, so I need to verify
the impact on swap in general first.

Thanks,

Alex

