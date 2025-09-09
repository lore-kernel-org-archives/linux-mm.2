Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02032CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 12:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37A148E0016; Tue,  9 Sep 2025 08:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32AA88E0001; Tue,  9 Sep 2025 08:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 219658E0016; Tue,  9 Sep 2025 08:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA4D8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 08:29:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2EA311A337
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:29:34 +0000 (UTC)
X-FDA: 83869642668.21.6106748
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id D6C5810000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:29:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RbkMNyTs;
	spf=pass (imf14.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757420972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sP14GaO9hh/AViIMu35gYGXTB37uSd6BGzGkZYr487c=;
	b=GgPfWU5b9qVG1Wr9vPs2UHlMP5LWKEHMiUNS1Q5zunZz44K8nGCz/SXZ1mxeunv4/GNB0F
	phxZnLdpJHPznDDqouA5wCRnr/1sMhojZ9ya2t6IsjrXwV8gm2dVXHxbRBSVnyjHwJ2Ir6
	Ay7yGFjAgKp3kxiz2s2VPIM41z1leLA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757420972; a=rsa-sha256;
	cv=none;
	b=EKDvkgb8za3cXDn0ZlKtbeCcQf6yGCckZpJgUTIaTxxhvCQe+sXnp6c3USF1eYWpH0rwUM
	KVjI/QFN2MeOeKBiS9rtsgaq8h8ODxfn+RHpq6TdXqAjRfZOqqGkNl6wq8NJ7zJl3+jL+H
	GQWX46m+s1kSldzdwtINhNRWn8QLi/E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RbkMNyTs;
	spf=pass (imf14.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b5229007f31so1838996a12.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 05:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757420971; x=1758025771; darn=kvack.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sP14GaO9hh/AViIMu35gYGXTB37uSd6BGzGkZYr487c=;
        b=RbkMNyTsMipDa6P4Wyrp06JGXUoFqrL7HbO8BhClRMSppH/IDhSrkXKvkGpfp75yJE
         MuCOlwxDA62fGaGbtAUKW4eFXKs9Gb4BS8WrFrs1G/3Gt2S1mz1utW4NR6taLvRWdKUz
         i5CarlhmZfR/A2y73Etxvvudgc/5q+2F3m0HQ8shRa6d7/XShsFz8LNtVlULz8zc1fBO
         xXTGjFk1thOlVCwwLwxiMvpQTunkKhDO8LUQNWP4C/nE6x9hifnyWT0YdrTLOMJ1FFwv
         xZKqadQaTmppkXZEwnips0zZdCOZoiLfagqUnPamqc+9lMh8wcWaujoAUySbSu3IOPE1
         3nsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757420971; x=1758025771;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sP14GaO9hh/AViIMu35gYGXTB37uSd6BGzGkZYr487c=;
        b=iB5RxnVV9ou2zxkr5Ds/cscXfjhQMAYzjuQZ3A8V+LC9zaGt5Og3gMPtG9E2laDHDv
         mttuk+aFY2DfvDJLdHrN1XMABeRqTKK/Pg/XIC6M5bV7byJ314INlraX+jDGrOqN5Ehs
         b94pWzz4XQeDiXUEI7wB7IrqAtmSZUVdxmx/AGrh8Tm9K05sYCABKPq+0nRft9snkgNf
         8hNmGxCQ+GpeFyCd6q7QR+XZ3VwWWJiBoQSlyjBANTVIJo1fUfTvriN+PQRFQO6uz0go
         eWnmnSlfe4OYF3ju/SQSWtTUSyXzLuJaoT6zeIfho6ZcOkubeMRbVZgjiqOCnfaJTfY3
         9t5g==
X-Forwarded-Encrypted: i=1; AJvYcCXF3fhkRcILPZVtvgl3R94QMRBkbZeNSPaojXwGpT/f0IBIb5owFlffEz8R3b6wQRQhMBOsuUL2Jw==@kvack.org
X-Gm-Message-State: AOJu0YzrgV7lA/hLzEztmU3fGBC2WOiJfskN0g+KWZ2+zczv8Vl8Gcqi
	SYO4P7AXTWSBWpplp425H9lJWOAU9qqPV1xIp5owAiC3PMjpodr7u3lM
X-Gm-Gg: ASbGncuqoYWjlkDqlJ1Coiig04SNjMVXTv+0dYqioh9pwYiPZPv41fLLzRhkrtTnT7J
	ATRNuaRPG3IHMQ0EwmMt41a9XZbBY5IdrYPINoF1QwaFnHM8b8WFeeBq+cWqkIMjfZxxFSgkQDs
	Wrett9zGy2lQ+K1zAi9NFTHpkkqW1ENlTrmYYL+6uJjycgePZcf19Cl4Qt5gctydM5C0Fws+cCr
	F/xhk2L5OF9ABTWvBFEZaCeAIPrec137+4hGZzzNjuuTQzuSJkIG+cXJB4XtaoTZImBuBPEdbTX
	lemgNkNPzyXKoOPyi/SgeLzdbM4gA7f3GN6E16HnuXgvZGraObBLw65HyJLPaC6AyfIuXp8Nu67
	Wy/hSQEtz4O+4rc0avXNdbW4hgXTlTBiF3vIEfTZ5
X-Google-Smtp-Source: AGHT+IFW338xaoGXmgeJuL5dLdv0vvtEaqjETaGyLvB3JHkac4awC+VJGJGYIiRnKQBTZkkp6c8LVA==
X-Received: by 2002:a17:90a:c10e:b0:32b:9595:ea58 with SMTP id 98e67ed59e1d1-32d43f8e9e4mr12819259a91.34.1757420971319;
        Tue, 09 Sep 2025 05:29:31 -0700 (PDT)
Received: from smtpclient.apple ([185.220.238.221])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32d7d4074b4sm6703233a91.4.2025.09.09.05.29.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Sep 2025 05:29:30 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] mm: shmem: fix too little space for tmpfs only fallback
 4KB
From: Vernon Yang <vernon2gm@gmail.com>
In-Reply-To: <c245dbb5-2e2b-4308-a296-f711b74002eb@linux.alibaba.com>
Date: Tue, 9 Sep 2025 20:29:14 +0800
Cc: Vernon Yang <vernon2gm@gmail.com>,
 hughd@google.com,
 akpm@linux-foundation.org,
 da.gomez@samsung.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <3349E5A6-BCDC-47B9-956B-CB0D0BC02D84@gmail.com>
References: <20250908123128.900254-1-vernon2gm@gmail.com>
 <c245dbb5-2e2b-4308-a296-f711b74002eb@linux.alibaba.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
X-Mailer: Apple Mail (2.3826.700.81)
X-Rspamd-Queue-Id: D6C5810000A
X-Stat-Signature: wg5cxfpoty83eswr8k6rdw6r3x5ymx3g
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757420972-58899
X-HE-Meta: U2FsdGVkX19NF5J9i/7cSYq5qOKfKLb2knrlIV50l1FDZaWYdLl+y5nzSsA8c7WDviaeUItzmKh+ZSlcZjz3exhaZG/an90AywC1FkV2RGiDbnK3lV2/xo/2BoUYtoloxgJ7OVz4WH1WSeey2Ad1qYHueNTFC/nXQA9zAadD6+djYW1wFrTtLJqn7TtxJ8PVZs9jliJIK5H47M6s4oDZ0BRmmWfPHtsnwO0XiiHZJpq/ByChoyap4caLdrfywzQVM1Yg5bDdj5UJhwS07CoGj7ZNMSpO2FSnmjfnxzlpFNCSO/RB9jo9L2Ap+Gt5QgAyidcophipAGZxOdcnEVvmEVmwg7ylCBoJIszeT847LnjVEraHJ6HKrnqCqILF27/KzijTvXR3q93kRR/LVDx2l/JXISG0+4PM8FNvPuxQT/cs3Hhkc33LL1HSsNk3OdQdjhxIP67ZcMOJwHPb/4Xjl3e52LEzNu+5boLsT5mwTIK8eN+exg2F+2h8oTJgogNb5jAk10v4YoIK8kzgORk8JcAsEqhorMTKwe3yWfORTnoRuI8/3RsMLIov9grkaDcNTsrssHK9JDNwTsgzA/B90r06LcGrNxD4QN6gELKnVl2Ae3bYTCQhPeDBmEKWefNMfA65s7unwyAPVZrLnh438S6+T77Byej3TK1kyHg6MNb66h2mMEFzQYkrNvMUSkdy2Ptny1JAqffhrVyWHjQxWM5VLvmUrdaFWpfc6twSNtptjj990RfZSd85VBJnjLvUPJ3a0RQkBpJFY6DyRXvGkupuQvW+d8RhlnjNX2wWbeZ0Wkk3qWpmD7ORcIhu4RUBIAoWBy/Z0WcjE7unkf/lwMi9kQ1ZWky5BK3hVPva+8lKRPLgbbxlZh9SIuOdGjcPx5p0albRI1e0KnQCpiW3IK4C7RUlFbY+0M4iKoyVyid2bQ1SWUHcPlMj2jT4iuOe04gRAfm/3+OBdnExS5s
 wwaxR7OC
 5Egznhpu3ZEwX1pLYihMiuUVoArr+18JipK/YbLZWdPOWay4YyAo3RC2oMj7lxJnHiBWo7VBBN3UatHeoW9feLeC3OpQ9kkG4pTy/0WO/TB5MnY+dmGlv3rPNeilo3Qe0i/Ng9lQFC1/DnoZcxflEcQOXnRn8+wUbobF/stzuBxqZJVpq0bjhCDj9TTq1sH54TNuxYfNH6g+srpgJaYUHdnNdmjsuYDXsyHyxxNL7eNgF/+jHIHJVhIBktS0DhAQuZv/YafqQuFTpJueKwNkBQXUVa51hEmEH/iteRnwwPOTrIEJlZQ31axKgnoZ09AkIa5FsiixNGmNUaNKJtc2hh/osT7aUshNESLvZrUS8a1Vp29mc3veluntgeZzZHwkB4USvQXTqVyqqBMhKizszk8xDBDP6SK4Su3mo/g0j84OEacaRp+DJKXEDBsefduByZ5yF0PaYtJ10zFCk3A7WtK1gQC6jGCemCGdqUkLbUne03c4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 9, 2025, at 13:58, Baolin Wang <baolin.wang@linux.alibaba.com> =
wrote:
>=20
>=20
>=20
> On 2025/9/8 20:31, Vernon Yang wrote:
>> From: Vernon Yang <yanglincheng@kylinos.cn>
>> When the system memory is sufficient, allocating memory is always
>> successful, but when tmpfs size is low (e.g. 1MB), it falls back
>> directly from 2MB to 4KB, and other small granularity (8KB ~ 1024KB)
>> will not be tried.
>> Therefore add check whether the remaining space of tmpfs is =
sufficient
>> for allocation. If there is too little space left, try smaller large
>> folio.
>=20
> I don't think so.
>=20
> For a tmpfs mount with 'huge=3Dwithin_size' and 'size=3D1M', if you =
try to write 1M data, it will allocate an order 8 large folio and will =
not fallback to order 0.
>=20
> For a tmpfs mount with 'huge=3Dalways' and 'size=3D1M', if you try to =
write 1M data, it will not completely fallback to order 0 either, =
instead, it will still allocate some order 1 to order 7 large folios.
>=20
> I'm not sure if this is your actual user scenario. If your files are =
small and you are concerned about not getting large folio allocations, I =
recommend using the 'huge=3Dwithin_size' mount option.
>=20

No, this is not my user scenario.

Based on your previous patch [1], this scenario can be easily reproduced =
as=20
follows.

$ mount -t tmpfs -o size=3D1024K,huge=3Dalways tmpfs /xxx/test
$ echo hello > /xxx/test/README
$ df -h
tmpfs            1.0M  4.0K 1020K   1% /xxx/test

The code logic is as follows:

shmem_get_folio_gfp()
    orders =3D shmem_allowable_huge_orders()
    shmem_alloc_and_add_folio(orders) return -ENOSPC;
        shmem_alloc_folio() alloc 2MB
        shmem_inode_acct_blocks()
            percpu_counter_limited_add() goto unacct;
        filemap_remove_folio()
    shmem_alloc_and_add_folio(order =3D 0)


As long as the tmpfs remaining space is too little and the system can =
allocate=20
memory 2MB, the above path will be triggered.=20

[1] =
https://lore.kernel.org/linux-mm/10e7ac6cebe6535c137c064d5c5a235643eebb4a.=
1756888965.git.baolin.wang@linux.alibaba.com/

>> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
>=20
> No, this doesn't fix anything.
>=20
>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>> ---
>>  mm/shmem.c | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 8c592c6db2a0..b20affd57b23 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1820,6 +1820,7 @@ static unsigned long =
shmem_suitable_orders(struct inode *inode, struct vm_fault
>>     unsigned long orders)
>>  {
>>   struct vm_area_struct *vma =3D vmf ? vmf->vma : NULL;
>> + struct shmem_sb_info *sbinfo =3D SHMEM_SB(inode->i_sb);
>>   pgoff_t aligned_index;
>>   unsigned long pages;
>>   int order;
>> @@ -1835,6 +1836,18 @@ static unsigned long =
shmem_suitable_orders(struct inode *inode, struct vm_fault
>>   while (orders) {
>>   pages =3D 1UL << order;
>>   aligned_index =3D round_down(index, pages);
>> +
>> + /*
>> + * Check whether the remaining space of tmpfs is sufficient for
>> + * allocation. If there is too little space left, try smaller
>> + * large folio.
>> + */
>> + if (sbinfo->max_blocks && percpu_counter_read(&sbinfo->used_blocks)
>> + + pages > sbinfo->max_blocks) {
>> + order =3D next_order(&orders, order);
>> + continue;
>> + }
>> +
>>   /*
>>   * Check for conflict before waiting on a huge allocation.
>>   * Conflict might be that a huge page has just been allocated
>=20


