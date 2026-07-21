Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9DAC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02C2F6B009D; Tue, 21 Jul 2026 09:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 003276B009E; Tue, 21 Jul 2026 09:54:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34D26B009F; Tue, 21 Jul 2026 09:54:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA4FD6B009D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:54:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 453BAA00BA
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:54:46 +0000 (UTC)
X-FDA: 85012929372.13.ABCE4A7
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf21.hostedemail.com (Postfix) with ESMTP id D567A1C0007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:54:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=S7EOLnm6;
	spf=pass (imf21.hostedemail.com: domain of "prvs=5662d1cd31=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=5662d1cd31=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784642083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sx7+Wpg1cuNhbLRjLTJbDwoqoDdkVIIIbVtBxTNNKe8=;
	b=YblTfkHuyf4gKHUC4onV6PmATcYeZlUhHAU0Ww1R1woXDGtuIZgbLkzB/F/rtNiBIIFIqk
	wpim0eUk3hURymwCHITrc6TbDI+iOzuH7dP2IQhQpR3NMXFuGrgxnpDsqaE881fZqEUfTH
	wPYZqPhAv6sI0B5DbiYgkN5bJ7l+PKg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784642083;
	b=VwV4CmxDWaZN/6Cj0jN6ACG8e6I0cYv8jGaRgYn3Goad97fVRtnZ/MEQL3CBqmrZg100w7
	/EzE0a8sA168AIBLx/kKWQuaVFCwu/gHLCmxg7dzkr5DIySXFdVs85ZZctDrCnAtWu4K/B
	r+irf3jufUQV2rMSnt48y7pEOT1FvE4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=S7EOLnm6;
	spf=pass (imf21.hostedemail.com: domain of "prvs=5662d1cd31=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=5662d1cd31=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}")
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66LDkrXh903270
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:54:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=sx7+Wpg1cuNhbLRjLTJbDwoqoDdkVIIIbVtBxTNNKe8=; b=S7EOLnm63S4m
	IuPxTC/+11L3Zrj+hS0WSPIHDl/IdtjqJ4HBhMExfWAJqkqQSMFt4l5xrnsnS5Ca
	+mZCQN3U0iD/y/dcTu+JS4kkrVcP4LWfG1YoArC7j9vuuohn3Hmnc4cFBfPNxYdw
	vYQaWuyHhA0z8sBkTJjzq6As/iio1eNAAvSbCDdOSnTEFcK85VP9J/xfLXID8DA7
	xek81ORaffO1S3MBnkpzPJFHUkxnbtylM5f7+5G66oxeGZBRnuURXl1GHnra7Pa0
	KoAAmT62XYETf0BQz6kh7/qJqMFAPUM32JAHPscmW3Fl0gpRR8bgRpN20lwzD8ES
	X2GkwgNOsw==
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4fj8cn8k2n-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:54:42 -0700 (PDT)
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6986557937eso6733401a12.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:54:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784642082; cv=none;
        d=google.com; s=arc-20260327;
        b=KOELrKfAqg+b30XalH8XZWv6s1tKaGmCazqVseIIuQL8OG3U+izlqBACEEdh/LvDH1
         GwLmYIdVxwheg4FTE7jp/22JlBLPGIAy7PJ/cc/NTIm7856MxEUskYtevhvlbfLwuP1y
         Gnq80ZKa/QtK6prQapOZeKvms/vu5J1c6/3fC4DgnDG50PnhVXrHFVoPbjBoYyskmXfO
         w5EXfXjfB0Dr13aE1/rm4JYy/UWON0vbWAGimns+OOB4IHpsxvs65oZfjFOpU30d1o0u
         NSpKM457trVR7y050eaDpOwSQtlm0WQTJJRmXKIKkGT18gCGvflIEOh6KPFQmcOKbiRt
         e4Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=QXi2y4Ma+bwgvWfji+09XbTWAna/luqe3unBFGrfieI=;
        fh=qut5gkAjGo1Jq9mqbALQXmkWK9mCKm1tFQtpfQNcR5Y=;
        b=Ogu/gg5lpLBK/OuBAJry2GVOoiR9Sbbzn2OuS/VpRmYnfjplAS7fXVQ+LtEI+34yIR
         695SK1Ir1pDWtVb8WNInR2Z1Dndzzjk3Et3XRVs1RDmaUhtXvlYVmipXRVjBJ0bpdFj5
         YvgbxH5rya9jHnAbwFmigzUgZYvoZOEW/g4lJQBhO3wYuE60MT3V0vmPZL7uyBbppEKT
         E+R6lx+Wg75UVy2ggLTTZNK9KHG+MbZSsIEV0l3S4UdXRuPF+G0j1VhP8ZIxNM8qDZPL
         OaCraEF39tDvhqWNVmsFzlMMTZVYCjt8E9Agg5i3c5lX1NjmkFlNtFrNe6zsMlPMpAej
         PlBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784642082; x=1785246882;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QXi2y4Ma+bwgvWfji+09XbTWAna/luqe3unBFGrfieI=;
        b=g0gd93jXbXneOgDe1mufPDb9G/132HrsFdbpJwUh535mnEGYO1mdNzm5Bh/hjUZkwo
         q5+OhSgUNqPGBqwhFjuLBxdA3j1e4XYhtm+PnEv/MP1gWQDWa6Vim5pBBcKXo7S948au
         AlKvfHvyNyVLi810LcWRuZ3YD7yIEQ09fKoRivUpMvnlCfoKVwlduwNHEaVxCbeW4Il1
         r2wd/YKYc+xBvDwccSbuiqpLU8ta1mvS3zw4DyNTxN/JF36Ahct3BFfvMlIH3N3crEQG
         KAlFolwPytlhbiaSu7TOdHivwObNk5J5a7zbbVLkUkl7oW3MMGpupqhACf5kndPS7Kdb
         RaWg==
X-Forwarded-Encrypted: i=1; AHgh+RrrODbjyxXrV5+xBgZfIDr3yXDb8p6jrhA2lHae0Oy4QPctQr0DGezSr8I8wEIf/h8A8ChVMDNRwA==@kvack.org
X-Gm-Message-State: AOJu0YxZ/JZKLKOJ5qS7nyX7wj10s0HKoCjR0IkaqlnT+tf3iUk3oRHF
	TjtI8wOvjVp1IoPtzRseRYc1Bjj9N9SfVy4ZL7hHxJGI6aFE1x6gXmSsftI+tFKibNd4r7rjg9g
	lxKlaSXscUeFwsewtts7nfxNoFkFmhWkmhdSjxre/9YNhneizDImcQoBoxOp4yi4hPRitaXIaIB
	RY4wIalPPOw9d6aPOYiUT6PHNf2Q==
X-Gm-Gg: AR+sD11S7tOpPlnm9MR7GBK+BRrnDVAO3c1Cg/gZ0h6HTIF2VEK1ODcg/JPHINnRZGo
	g4N40Mt1R8i7jsKc/h/boe+hcgqomv2fS1ATdw3YY+0zw16PGJCIH6DAHPLtX3xofKX4up3yPpD
	TcbWiT2cyWvK4JYn7kMxDs7Vd7ZX0eYAPzZGp6Tp2RZAY6lgYwXYfGx+TlHf7dMUcgmh7obR5/
X-Received: by 2002:a05:6402:5194:b0:698:4d33:b191 with SMTP id 4fb4d7f45d1cf-69e6525b70dmr6983593a12.9.1784642081544;
        Tue, 21 Jul 2026 06:54:41 -0700 (PDT)
X-Received: by 2002:a05:6402:5194:b0:698:4d33:b191 with SMTP id
 4fb4d7f45d1cf-69e6525b70dmr6983585a12.9.1784642081172; Tue, 21 Jul 2026
 06:54:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260718093723.153324-1-alex@ghiti.fr> <20260718093723.153324-3-alex@ghiti.fr>
 <CAKEwX=NY=Uvcfm2BT-HGqu8B3OaoC0eePW1M7fW1qH4wpjQ8gw@mail.gmail.com>
In-Reply-To: <CAKEwX=NY=Uvcfm2BT-HGqu8B3OaoC0eePW1M7fW1qH4wpjQ8gw@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Tue, 21 Jul 2026 15:54:30 +0200
X-Gm-Features: AUfX_mwF5Q9JVRQNfWQ5TsioDFCzg2oqxuYB2oNNQsm7BN-0LsnY5Qv5zLzHpko
Message-ID: <CAEmasaUs-1oHnnbP77hBt_02pZChjf5E5vt4nAQQsSY1BYZb9w@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: zswap: deferred dropbehind free of writeback folios
To: Nhat Pham <nphamcs@gmail.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Johannes Weiner <hannes@cmpxchg.org>,
        Yosry Ahmed <yosry@kernel.org>,
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIxMDE0NyBTYWx0ZWRfXztzXV7hvEmpZ
 sMUCBjVjRYic4e9tIO5PCPbRuQKSfv6+kaljC1YUZ+WAe5inNQe7v9/9PAYmqLimzaVYNi6IpPg
 0lGrC7Z8+yQXFJpKbejxPr1aatXG2oQ=
X-Authority-Analysis: v=2.4 cv=dLeWXuZb c=1 sm=1 tr=0 ts=6a5f7a22 cx=c_pps
 a=9KvDgq78n9V61H3VJbnhTw==:117 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=wpfVPzegXHpEFt3DAXn9:22
 a=pGLkceISAAAA:8 a=ufHFDILaAAAA:8 a=rBto2jfJFEA7NFfjjzUA:9 a=QEXdDO2ut3YA:10
 a=j5kO0B45gQVIxiUYEfTy:22 a=ZmIg1sZ3JBWsdXgziEIF:22
X-Proofpoint-ORIG-GUID: 3-jICpL49I8uIMQ_aLJf3HYa4lYlV0LQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIxMDE0NyBTYWx0ZWRfX2VL/plQfsdZ+
 wot1/SKTHQeu+9nKM7icoj0FcKsjaBtaAU37+eWf2urbJY3T/YS9CSpgTNOBM4f1ls/ySih1xTy
 /tUuzLkKLxppqBZeU85prb7uN49ns6ft8+LrJ6IgM+ORMNV0lpmxFt/tUhlFY/e/6kwY7yW7hIx
 vl7ZJ9gzNnNrL3QCUIiHpDUjL/d2MSeZ1Nk368omLMD9AKJfIIuXbHivPmTIslRgOGHL5tbHHJz
 f0rDY3gT6r/h2x92B11Fh7HCc9Nr9ackzZH4iXpeAJi/obaXjrMydUuqR9g/cmSI6i2C6UpzD1x
 3EH8Zb8+4S2rM8TyEbS1acF7Bq66WK6wBC4peOkvxXJx/C0gcRMrbm/t/0Vkz9feyuLE8PQcRg5
 Xz7oZUaAy5IVomvK/mVLFYKHl3BrNDxKCNEWxrZvInLreo3x69FtU3q7g8hIU49WT/XRcpqH0vi
 wPtvalT/6/F61ELAGAQ==
X-Proofpoint-GUID: 3-jICpL49I8uIMQ_aLJf3HYa4lYlV0LQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-21_03,2026-07-20_03,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D567A1C0007
X-Stat-Signature: 4dgjyezpci45ogscmxic1n45bhfw9f9d
X-HE-Tag: 1784642083-907959
X-HE-Meta: U2FsdGVkX19EHjkIUK8kh5Jqzvi08pgAVTgFeN9QeWW4d1SEEgU56837dgAF0aJWvaeYljLyVVX+f0q1fcFp1hUNhyXSjqyRuBF6AYgJu09Q/f3edN12B4imtt1QuVIphebWm5hF3g/0AQWEQC1lXtLCgd5m2lgwBrFMBCwVKRmvh/EdjqKJc34Agmp1HtUxJgPZOm4M/sPRhFTU7FyYjNhz5NbdDS70pfXzOwdMDxEp4lJyezPQGsk5FGAKwOS1mp0pjHo3Vb3l9BGgYtSgN2zOflfDBx1RZZKIv12TmjY26C5cGxl7GSY06F8VH2NeBkU0wLv57CPVU46fqffwtFLqJagFgy79vNy+/7+clKGFmVEsCXuA1smpQrcTfsogAg70Pg+lXBiGG1qBTxv3DDJuqPXPcZns9Ig3ao2Rz+29Os+3GXcaUBSG8eSDyA0N/0dC9m0hCFjuoFppTqAel6Xv+h7E5hxmADmP63dBEU5k7BRtpb7M1GTZ3lnWnaMioE9jaOk0B7sUIP/++7FBhH6clKWdmx5xT5luP+oie25hKBVUx6i9O828CsgcW/QWV+m4Ogw/IAiKsSalaswK5oNu7HwsZTyH6jNZoO1+NmFExFw6gvXTerYyCi3lDwPRgfqWlN3uA42I7wCX3oJnGTvFTrmUiPXEUriRcw7UIeHwmk1GepDfTBjDsArCGDPUuIWCqlHydQn/2GySJlfhHxAbLEfuiWKY0eobSnzzAsnMMPEu9joxXVAYAc6R6N75ER3YIwG2nK02E6lmD2WTUYEyyiB0puiatTqjTD9GcVtMSdOoOoJOYhLGSumDE71WJ17vTqOHp4XQnLN9/baRyueiKDSROnNXTemEWME1pBm+hl7DpOnEuQloG5doqPVwSKEp0qWkpqnhPGZPoL3BsXXB8vSZaHzuh5KSuq9gjx1Zt9rkk5M+9eVLR+U4tXIcQws1iDR+uybN+JZOwUE
 0el6PJol
 UzJz80gGAh1NhC1BXzpot+1aggyHI3y6W6xekjSQUPYm7WWlrXZ0d2jzowgytqNwYAT8DqmzgrbvZmDYA/x4hNwClaR4xMe4/SHvStFkJI04W7arOPS9ciyfVEsut22GmCQqCP7k4RB8nF5x2ELadaXu/kqu1krXl15fyEuarEsLlB3d17Po3McuuJxwoPbkPaRIpbSWWcEgfQmbzMcMUo1HWPIrthaxJHFAr3tnrYNPtaGmvRenOnqTbakUio76EyDl3YDgfe8S5Ix2AOnnRWelKV3htKaHGKBPEWJUriZK/+z5o+V4bYyQUQYjCrQGVCVpfAVMr2FybiXIyxz9NIAExZcK8hXCNbd5Qm087ileVPBmxFPZZ3tzcKvBqt8B/X4lDE7zAiy7MZqid3yJTeVws+3yGxf2Y/qV2eABDZJ3IIUNI8LVh6X92PIhe5aQEorPhCA2SUsEYNlFho5AT0dr3f/Gp/6m0EYrTWc9KCAczRi1kfzNII9p6xn1QYOqa/n485HJiFI3F5cpDydaVr1Y9ox40kApxYaugRpMECUw0tiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

On Mon, Jul 20, 2026 at 5:57=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>
> >
> On Sat, Jul 18, 2026 at 2:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> w=
rote:
> >
> > The previous change frees zswap writeback folios promptly for
> > synchronous-IO swap, where writeback completes in the calling context.
> > Asynchronous block devices and filesystem-backed swap complete
> > writeback in interrupt context, where the folio cannot be freed, so
> > those cold folios are still left on the LRU for reclaim to clean up
> > later.
> >
> > Free them promptly as well by deferring the work to a workqueue that
> > runs once writeback has completed.
> >
> > Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> > Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>
> No Suggested-by for poor Nhat? :(
>
> Just kidding, of course - thanks for working on this cool idea :)

Oh man I'm sorry, here is the story: while working on the large folio
zswapin, I noticed the swapcache was getting huge when the shrinker
was enabled. I mentioned this to Johannes, who suggested dropbehind
(this was the first time I heard about it). And then you told me you
had already tried it yourself!

>
> > ---
> >  include/linux/zswap.h |  2 ++
> >  mm/filemap.c          | 20 ++++++++++++++++++++
> >  mm/zswap.c            | 34 +++++++++++++++++++++++++++++++---
> >  3 files changed, 53 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> > index 30c193a1207e..23dcde274964 100644
> > --- a/include/linux/zswap.h
> > +++ b/include/linux/zswap.h
> > @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
> >  void zswap_folio_swapin(struct folio *folio);
> >  bool zswap_is_enabled(void);
> >  bool zswap_never_enabled(void);
> > +void zswap_writeback_dropbehind_folio(struct folio *folio);
> >  #else
> >
> >  struct zswap_lruvec_state {};
> > @@ -58,6 +59,7 @@ static inline void zswap_swapoff(int type) {}
> >  static inline void zswap_memcg_offline_cleanup(struct mem_cgroup *memc=
g) {}
> >  static inline void zswap_lruvec_state_init(struct lruvec *lruvec) {}
> >  static inline void zswap_folio_swapin(struct folio *folio) {}
> > +static inline void zswap_writeback_dropbehind_folio(struct folio *foli=
o) {}
> >
> >  static inline bool zswap_is_enabled(void)
> >  {
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index dc3a0e960b9f..548e465b5b9a 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -21,6 +21,7 @@
> >  #include <linux/gfp.h>
> >  #include <linux/mm.h>
> >  #include <linux/swap.h>
> > +#include <linux/zswap.h>
> >  #include <linux/leafops.h>
> >  #include <linux/syscalls.h>
> >  #include <linux/mman.h>
> > @@ -1680,6 +1681,8 @@ EXPORT_SYMBOL_GPL(folio_end_writeback_no_dropbehi=
nd);
> >   */
> >  void folio_end_writeback(struct folio *folio)
> >  {
> > +       bool swap_dropbehind;
> > +
> >         VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
> >
> >         /*
> > @@ -1689,7 +1692,24 @@ void folio_end_writeback(struct folio *folio)
> >          * reused before the folio_wake_bit().
> >          */
> >         folio_get(folio);
> > +
> > +       /*
> > +        * zswap writeback folios are off-LRU, so we must prevent a rac=
ing
> > +        * swapin from removing the folio from the swap cache and keepi=
ng it
> > +        * off-LRU: the writeback flag allows that. Afterwards a swapin=
 may win
> > +        * the race, but the folio is already queued and the worker put=
s it back
> > +        * on the LRU in that case.
> > +        */
> > +       swap_dropbehind =3D folio_test_swapcache(folio) &&
> > +                         folio_test_dropbehind(folio);
> > +
> >         folio_end_writeback_no_dropbehind(folio);
> > +
> > +       if (swap_dropbehind) {
> > +               zswap_writeback_dropbehind_folio(folio);
> > +               return;
> > +       }
> > +
> >         folio_end_dropbehind(folio);
> >         folio_put(folio);
> >  }
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 3c494c5a671c..d185da85bb68 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -34,6 +34,7 @@
> >  #include <linux/writeback.h>
> >  #include <linux/pagemap.h>
> >  #include <linux/workqueue.h>
> > +#include <linux/llist.h>
> >  #include <linux/list_lru.h>
> >  #include <linux/zsmalloc.h>
> >
> > @@ -990,12 +991,39 @@ static void zswap_writeback_free_folio(struct fol=
io *folio)
> >                 goto out;
> >
> >         /* Raced: the folio is now owned by the swapin; put it back on =
the LRU. */
> > +       folio_clear_dropbehind(folio);
> >         folio_add_lru(folio);
> >  out:
> >         folio_unlock(folio);
> >         folio_put(folio);
> >  }
> >
> > +static DEFINE_PER_CPU(struct llist_head, zswap_dropbehind_llist);
> > +
> > +static void zswap_dropbehind_workfn(struct work_struct *work)
> > +{
> > +       struct llist_node *pos, *next;
> > +       int cpu;
> > +
> > +       for_each_possible_cpu(cpu) {
> > +               pos =3D llist_del_all(per_cpu_ptr(&zswap_dropbehind_lli=
st, cpu));
> > +               llist_for_each_safe(pos, next, pos) {
> > +                       struct folio *folio =3D container_of((struct li=
st_head *)pos,
> > +                                                          struct folio=
, lru);
> > +                       zswap_writeback_free_folio(folio);
>
> nit: I wonder if it's worth doing some batching here for the free step.
>
> i.e, after remove_mapping() succeeds for a folio, we can just add the
> folio to a batch, then call folios_put_refs() in the entire batch :-?

Did not think of that, I'll do!

Thanks,

Alex

