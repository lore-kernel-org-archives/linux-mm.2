Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7534E111224A
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF96E6B0088; Wed,  1 Apr 2026 21:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAA5B6B0089; Wed,  1 Apr 2026 21:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998F96B008A; Wed,  1 Apr 2026 21:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83F286B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:24:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AC4113A5EF
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:24:25 +0000 (UTC)
X-FDA: 84611870490.27.244FF5A
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id F16CB4000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:24:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EgvnvX4x;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775093063; a=rsa-sha256;
	cv=pass;
	b=VH0d+QetpG7yqC/BPxRf9dVF8MZtek8StpC+h2jcso+6/wA5f9FWfw0HHDdu4KG6QR/sM+
	1EZKvjrPd7cVYdk07JewIncW8kz1Cy4CcOlWyNwJuc/1W5Ol0Qr5BTBIox/RLj/8k2Vjmb
	VAz09UYpdWAwnY0EMggTZoxRfh4tIXY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EgvnvX4x;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775093063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7ra+u3TlfOgeZlAAT4yfsMYCpyqTLL7DQZc241he+c=;
	b=xV4cxq2hsKhqboHcv52JgtaxWpADt2aT4nIe934rD+CJQeh3O9/3f2tAqZfKmb3rAdmV28
	VXadU7eWUp/4qYOw48XmK/ak+77XTbRGwyEAha+rIjUNtOPy8rZ2zCB+kyQKD8DNn8ZkUR
	RmyBtjBVWxq9LhCuYwf7wUajuKwjf2o=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b93698bb57aso71053966b.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 18:24:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775093061; cv=none;
        d=google.com; s=arc-20240605;
        b=EHjmOeoPzdVDNP/K5XMpWVZTbtj5eN3vbkWuJyHyMPauqv/5IRTfBfYdB1WmAVosvb
         6WuXn80y6wRVOuM2itpaLzS/js8SqAcoDs9qp8ZSv7rKzxt6/9h8D5rYofcqqZaMY/oS
         3F1+R0wjtT6dMohNwOHIPlB+PCLMnDTpR8QDBOcqYLm4oNwb200E/W079BaUtcfpinWF
         Gaeu3kagKPOzKz99vwlwD7NY0Jil6llfXLYMfmcFVcJo+Y+K4DOpQ1isdtotXoSMetk+
         z9NpD0Z5T5exWdgbAV4DCH1vp1yzQKVTFOtWEQiZQhiG3qQU8phu6MSBPWiD9O2/41vl
         giew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=W7ra+u3TlfOgeZlAAT4yfsMYCpyqTLL7DQZc241he+c=;
        fh=B/aRUqN/x02Fd80qYLW/2Br0wmGSeqTArqH4+hJW3P0=;
        b=lSynedkdAqu3EeE//usnBCdLbaA1V5qoU8Y78cR/Apm3Fx1bmV9CowUm8d5mrJe9VG
         /gOOamvZ2knOn4+sqJJYbnQtf1n+5USMXeF2tmKt8+89WtvosOLKxbtpYFGTNGjQ5O4h
         2ZLp5OJjO/xb0SYZAu8k7sF70Q0ASvTJj5hWrQp/WiLPLAWzp3UtGVV0adxENXjGhTbu
         zGvJlrBpGOSvVntHFWXzS3b7NL6Q1FbhnMPahcml9pFk9Zya/Cc88A2MPFA+/13vOCS6
         HLYOcOx/sT7J2wKAIesOCdExthtkxIdMOT8uKONA/itgdYZWGUTQBAGyHFaAvwdSYptm
         y7FA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1775093061; x=1775697861; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W7ra+u3TlfOgeZlAAT4yfsMYCpyqTLL7DQZc241he+c=;
        b=EgvnvX4xJNgN02lGW70jFPquIBJoTbx7jOYSmjbL1yQhhF/9KpZ1As5SSZUq7Bt6q+
         qSnGvtVk7ecKE23XZOi2uD0MJz48kAefRcT4CmWZjEg7FshXJG+auI6hr+JYztEc3z0e
         c7Js4DVN4awkASGtqw/WJdXr7Irh4Iqv0g4vpiO79A1d1TGMfBuDTiuCYoKuDcZnkWAt
         uUCqMU80NLmERqUqc0K2X3lW55QBZ3MB0euFxgcdtjQhO/SzodfWUkIdWNKNIKUqZ4vb
         iTMqI29g34lP81kZQrdKjljVCFqOMjlWu9p5nj1YovXeRWTQxogLhEh0tY9dfv67P9QA
         HmVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775093061; x=1775697861;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W7ra+u3TlfOgeZlAAT4yfsMYCpyqTLL7DQZc241he+c=;
        b=ORQFxOLqBVK0hyCsPF8L3/Rc/DzuyMVRRdbqo3TvBvL7b01GE8JARqRdzoSIZuq1pL
         gPKe5jhnTIcNPj77L5RVEItjBmYnm7bKrBRZQ1ztnvlQlA2iFF7cYAMuhC7FHRQI2VW7
         xemmNYUlnUrgYSjl1SH8FYDU0bRXMHyrBLhgTjpO43wHEPo2SW+gZ5SG15ruCTMF+KIV
         VQwfUsqabHTNFKB4qArqwbjY1XOekAtErQNh0K+Ynhze6sk9K8lWHsEGhEwCJTWVVHxe
         9PWXiKw9oGEKJulMrOZLtd/1Diyy/V0hu1x41bN/94hRLVU8hoS+b7Mbngww6bbXFhnj
         XiIg==
X-Forwarded-Encrypted: i=1; AJvYcCVMm4F2Vmka/DjmPqlMISJoG7qMic/unxoW2vM2s8Hvalw3pOlM/hnDlpqlTcu6erDGggleY9/2lQ==@kvack.org
X-Gm-Message-State: AOJu0YzpWxZchWybHl+tJcM8iDjPNF7WYBgladDjnuorTLgrYewQkN6A
	SkmecRmDDJp+ow1wpcBT1xAABD7BZYScwZWMsKa4a2JUgBR3FeiB3eugnK+4V0/8XSBE5bYDJXi
	vZ+tSxIri+fiYa0c6zNxFkGY4MZeVaufE/NpMRj1s6g==
X-Gm-Gg: ATEYQzyVI6gVrvnDUjjb1Vp2jg508tVapc+2p+wkd0tDgRyfa9tlllHiJ22aZYBTJoT
	QpK7K4frkFSayWvFQ5HT4juoXx1UR6wm0lrIPkLvf7Yk7JJNv8UgTkwjf35S+L/uD3nyckIjR1t
	fB5GmLUif4vpOtOV16gd6d02LqOxOa9yBOlla1u9kyQYwxdrJ+N2TDGQDbhhX7aSe3ZPBCfSHe1
	qhxOrY5TKWWHP2ds532ENUO+bVjmPaoQwMw6w248PPixbkoa2n7hePSS5nxHaF+fXxRhV8BI85d
	d3eU9zeZgoOftfRJwEplc9FpCNAK6PxqPRoWRg==
X-Received: by 2002:a17:907:6ea4:b0:b9c:11ee:3c2f with SMTP id
 a640c23a62f3a-b9c46de6752mr20619666b.1.1775093060834; Wed, 01 Apr 2026
 18:24:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260326084727.118437-1-duanchenghao@kylinos.cn> <20260326084727.118437-2-duanchenghao@kylinos.cn>
In-Reply-To: <20260326084727.118437-2-duanchenghao@kylinos.cn>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 1 Apr 2026 21:23:43 -0400
X-Gm-Features: AQROBzBQev2b3aMzYREBWkZ-rH-xOsd0fsiXT1xY1YD3JCunSWuEFkNfDGsMwoY
Message-ID: <CA+CK2bDPeT-PruiqiBG3EOY1gMQ7DPaW5vapfh9=f2+pk8Aq4A@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] mm/memfd: use folio_nr_pages() for shmem inode accounting
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: rppt@kernel.org, pratyush@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, jianghaoran@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F16CB4000A
X-Stat-Signature: 5rracb813btwykzhzdc5h16tsad85gac
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775093062-270268
X-HE-Meta: U2FsdGVkX18ewP5VjAFn/6eJiUfX/b081wmiNhzWqlN+aMNNHK1P5hLfKz/EYz0VsXMYe8cOVyq9L966uaqQsvmlIAoai9ZVmZN96Nm+yOFeM9UVAhHBHFAeFG1bxS7Osp+4J62Vg1aynV/1ksxnEb27nydMaNVVoHMR41pAKhimJ8FnRJcx9ooNjM5qCGqsPPOlikQsGA5C1Is3/iv7+IJcDRD+DYt31ei3Axg4IpLsdcI33CxHzNTlrk/dAfLwTlalbZyM22bASyTpVm2NZK9duw/9BVkVZjsM6ThgXFABHxC8m058PfNfr3nUxjdJwFMRMQRjNeczuuy/pB3yPxAPZYdvigpqpPf6uSJW5evsBWu8V5o9+G6gtgi3YGdAcfvsy62k/wjj7x8Tref7iA4eMhU/EtvhYZeue2X6HuBaea8v/QF7lJFSmn4UuL7XbH+HWOvtvnqlUK2EryK61cl6krO/8q5xmZg6/iNkfJVuxivP6deC4ztOudarDEE1RLe0lf4i767d4Ro8ahD1SpZn5JO4CTGhL0VwxPAQcbL7zoXRcFERNflcgWbBw5ZFQpXn4XFLy6qL1PCMOLlJXUDspInYR01ehnhkVtp0JIPTFpzihCEIy3yntkEzlHex2/NanZQWdeqTKO8F4TbJkRmqQCp1tR/DrqR1bWlrRBnb6OxdjDhsDqkdqOIr5jw6fqvZYbHaOX+xcvWTVhvkv/r8oxkhrvoU8sgMpYGhLatp7ciNBB4UEj4i2oVwenUTw4RVX5NwkhHWqZJ0DoDmtymbjpTyNKQyBtw1aTvgx/aeNVeQbdii16EluBQriU3p0oAZly6TLt8r9/5uMIp1lRrduncoShAfrBA30aVFowO2450KniUPq/FaCoiK2aBVY5ABUBdpOUpgDZZQnJM+YjbdAlgru1vtyILBsmNHJnCrvMpOG/SMQzG6Oj3rPEeNFDeqFlxp9dfAnDXftEr
 3Pci+rTK
 22DKddSXhffCQk3OOhGu3XcLOKriU5tHDtZ44x/CCKgTdWr5ZdGjpZb/Mne0e2Ann3F8PVuYwYnYhOWZiPRphOjJiKeGH9HVeT7iEcWnmVmsSJfrwe+LA+pXV7aq/E0nIe+3p5DkcJlIMjZsDU05o6JnIoJzoXwEiiRmuYCiED3oO+n7dOa6EvSRyq5yv3mnNm5JE3EjrCXK9lcsBeUCj1jhP2j93YAOwhBFfJfAo7JOewC+eZLM/T1IVr17sRpgG4Vc61/usRYCTqxTX1yrzBMxXpuCwpMO4gU31gTaG8CcMEVDKufRIX9noE6yYkxlJbyaBMQ1J5/0d08LBAGRYPPgrYSibKhwxXLX2jp6lwkRqsLCABh3/3o1OxEpOc4Can/cT+tOS4i7RnpzRvpMDEa27ETnVWOONRJngsqua/+iDJdEj3ALNA76NKZ19wV2X30Lzz/crjr6I47A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> memfd_luo_retrieve_folios() called shmem_inode_acct_blocks() and
> shmem_recalc_inode() with hardcoded 1 instead of the actual folio
> page count.  memfd may use large folios (THP/hugepages), causing
> quota/limit under-accounting and incorrect stat output.
>
> Fix by using folio_nr_pages(folio) for both functions.
>
> Issue found by AI review and suggested by Pratyush Yadav <pratyush@kernel.org>.
> https://sashiko.dev/#/patchset/20260319012845.29570-1-duanchenghao%40kylinos.cn
>
> Suggested-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

