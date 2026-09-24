Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5494C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8126B008A; Thu, 24 Sep 2026 05:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99926B0093; Thu, 24 Sep 2026 05:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9609A6B0095; Thu, 24 Sep 2026 05:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67DDB6B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:19:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE55940290
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:19:35 +0000 (UTC)
X-FDA: 85248107910.05.BED25F6
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf25.hostedemail.com (Postfix) with ESMTP id 783F3A0004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:19:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=kWkkaWuc;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of "prvs=7727f07d68=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=7727f07d68=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790241573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=roxXU6Z74sF8nlaUP7Fv2tRIYGBB8OvYLUyAoWfgdYo=;
	b=fftg5ZbgNgX5a/aKbU/NLniwavyrNs+jFYDeR9FcQqU0FRqXJNivrxs0O9+wLqaW/OxJGz
	cprOlZvJyPG9rOZV4kk5xW1uNc8oPtVAPWhX0nujJYoygS1XHK38XiBmAquAlNyN4nUD61
	Ir4gcgBbZeq8ayG7aGPAec3OSbGpOSs=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=kWkkaWuc;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of "prvs=7727f07d68=alexghiti@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=7727f07d68=alexghiti@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1790241573;
	b=I02xs0pLVOdHJorfbl4ZTN2yJwiKSmpmmtyx/jf2zh4Gr1oGjG+ldQeSQy47OSdgWA/eOn
	G9LsRKV7oLei4f1SmJ2lsXWXNBbGCuo+5LtNNjgH4LyveX6ljITJiX4Rssi0jVbH0rIlbv
	mIIiju3ZUhu6eR6ZIh2y+6fG9Ga9UDs=
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68O5gHHZ3701522
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:19:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=roxXU6Z74sF8nlaUP7Fv2tRIYGBB8OvYLUyAo
	WfgdYo=; b=kWkkaWucyhVMYiRXWzHqqmBWBbtttD9KKpWrxiT25wt0v5edCwCyW
	yqwX6JcMNoSjyGD1TnxKqoY2HL4MOzdDGbv8/JVadZUf/lH5F2U/z/zPguz+2WvI
	PRmqIvk6iGjC5E+Gq9Ji0jMxWRJprVpk3eNHNp3Vo3WezYtNHKObxgCDUNHLlCG+
	274GyykPwxtiI1gS/lViAxKEKmOr8M72J4TMB5P891fVFBcifU/osustQu+HnHUX
	BE3ysvRpPKJk56v0pyISvMJbcVyjEpYttySp01KEq0TAohAOu9GC8ryOBCaz8tdx
	a16ZV1FUx4+zusTtAGbyTnZvU+4HIwCkQ==
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4gv4uy4729-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:19:32 -0700 (PDT)
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c25501f4aa2so97642566b.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:19:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790241571; cv=none;
        d=google.com; s=arc-20260327;
        b=SRSVIIvDOhUIFjqfuTE/3fW0paE7j/lfoL62JU7IFgmfVflTwb62aoFmPoJJnGscGm
         lJB9YlzdcjGE65JViRLxx6WnC9Pd6AqwYbMo76VezAqBwkP+AUb++vrh9mKF+SmrLver
         aA+2iohaU0PqwtmuijAvOU7oX2iF+dVQ7JCmqZnUeluhotyjtqnJVSyKJYJI4EOLO79d
         qpTVI7UfePFORUqgV/4W1wKEoFZqLgpjKZnWe1/opKEmeHLEm47yRw9mzAL/N6R+nHhF
         PPMs9+rYJrZYLPd4QcUpLbQ8rnaCeB8VtWrV660lXk0GZODrV+teDMoblBwdTv3RjtNZ
         GBug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=YoGK7sXAdEPoXHsQQP3OSq8CcOrGesthSuPxxba+GjY=;
        fh=KO4TPwRiIMYwitYHycfRUZByxlSqamx7jOw8iJsDSug=;
        b=DK5tULz89cTXa/sunVnMgp8mpQq30V5UeTlbonSKDCPmVkdb87rXy/HUrduGvfzoTR
         mroDpG5TxQRQmJiSpBDwTJpPyB/+V8rYo2g3cnqvpHrIFUksqhyerDcLTaRJceug2iIG
         CR/wn5s3xrgGfHh4PNCSurKLLS1jkCqigme/4VaJwcImQMivERH0omlrLxqiYhCuuHmP
         tmdscw8wu8aOam4brk0QkbyLQ5qG4QS1PQnOerkx90H8IGifIqA8oxxg1NA/9L/1THJG
         RynZmmYVH4WINhfgTwyDQPqS/FQy9SbZUlKppKxmdEWYWaH0Eqf24SgWXQrnc8ENnOAN
         +VIA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790241571; x=1790846371;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YoGK7sXAdEPoXHsQQP3OSq8CcOrGesthSuPxxba+GjY=;
        b=uwyGhUTK0EPbXEqlH5vQKkPgboyLUHyZM70F+kbfzrnf4U6/p0tTLUh9m6LdQpe1oJ
         neCVDZhuR6I8GMDXFC9UuLy+4YPAz2HmV9jPhqMX01aAFVtB6YCGMlZ6z/klwTJobSJH
         O/9dnn6casmmh4NHiDnIvi7chvu7ykhG7t0wHajnfDiEYxdPSmYu6/INOgYBLwsBkYmU
         Ta/Bpn77Oszwbaf+LsB4WOSUCNZwgcFVUIV8g8zvfc+x9fAS1Jw4VMveXNJruX5ZQGTE
         SoIRgzjki49yfftFK5XSitNMsAbp2OmMCe9oLpTZ1NKx5TDyw/+Zk57MiMK5uE+M/MXV
         whKg==
X-Forwarded-Encrypted: i=1; AKwUvBw3FL7XCZ1pnJrDNazqiPhZ5dHa+KiZzXhsHMEcX1Ofe7Y+jlQYxZLrUCkhHilCKdHwCIAsXFYPbw==@kvack.org
X-Gm-Message-State: AFuF++kZlizBuYdeKp5Oa1BVJGdguppBgl01IcgTcsaVBB8Q43b0CyF4
	VvGqyV723aB6zQuWgr9xhWooPbYUkAWOyjcpcQj7TYahVGGECGs3ujNZjVEtdA1ki7X0wpKjQdC
	ibqVtiO9KjsqEMGAonzqIwI27gljpz1u13+f9fvXygJAacmwPizpRqCK2jegiZdXxJgZ3AfdPGS
	r0hEFrVcRp053dAbmwKVElB//I7w==
X-Gm-Gg: AYBFou2+4btTcpi2TxHxtfxBi5dt6gUIMYHyBIJuAtdIiLsOIztXd+y1W+a3EB8sYcl
	Lq/gVRmMtN6EguGk66PnSjuG22+NazaHj3vaCz1umUiK8Mal8yrSeFKH911OYQz8dpNILUsyoPH
	aoaMkxAk38qEGbc0xsVWOx9cwY/Jk6kVE8yfg13pf3WFjEb9gr8qZZNGfWH3lHTrlBUgd8FzZj6
	IWkUKf5h+JiNtRoeQ==
X-Received: by 2002:a17:906:6312:b0:c29:40d1:5108 with SMTP id a640c23a62f3a-c2ac235cc72mr142732666b.19.1790241571054;
        Thu, 24 Sep 2026 02:19:31 -0700 (PDT)
X-Received: by 2002:a17:906:6312:b0:c29:40d1:5108 with SMTP id
 a640c23a62f3a-c2ac235cc72mr142730166b.19.1790241570673; Thu, 24 Sep 2026
 02:19:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260921152449.629486-1-alex@ghiti.fr> <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
 <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
 <108487b7-0529-4282-b5f4-355804b4c0cf@kernel.org> <CAGsJ_4zGmGh70QtRBpnhueev3qt_bgB4ZiE9fkW-hgNjAVhv+w@mail.gmail.com>
 <2e695c8a-4212-42b5-bb51-fbe1aa162e1d@kernel.org> <CAGsJ_4z2nakqBCKd_uAn4bfub99r3NJt2spOUx-K0M7bHW3_-w@mail.gmail.com>
 <4c7c6ea0-84a7-45f6-989c-d1502b90694c@kernel.org> <CAMgjq7DeYsJxG_VCf2KnViV5nd10m-PPYzXRD1fi8QcGWwD0qw@mail.gmail.com>
 <d9a77381-cf88-4726-9223-c16a5c6608c2@kernel.org> <CAMgjq7CLGyLHi7Lb8WF_m9bWUHpMRp_uDrqYNRQsH2GkuVQ=Ng@mail.gmail.com>
 <CAN_Opa_PrLP7mpF7gRjQUKfoCJGP7KvZMB-23bPUG269QASHpg@mail.gmail.com>
In-Reply-To: <CAN_Opa_PrLP7mpF7gRjQUKfoCJGP7KvZMB-23bPUG269QASHpg@mail.gmail.com>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Thu, 24 Sep 2026 11:19:18 +0200
X-Gm-Features: AclHuK_fFa8d65bD0Ky2JUPx_6IS1uipfriABR0dPRad5IHn5nWDjOjzkhYFNFQ
Message-ID: <CAEmasaVnJEaSRFAZn7ZCUH=dbocUjXvEy=ot8qGpCy_TAiMCFQ@mail.gmail.com>
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback completion
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>,
        "David Hildenbrand (Arm)" <david@kernel.org>,
        Barry Song <baohua@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
        akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz,
        liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
        jannh@google.com, chrisl@kernel.org, shikemeng@huaweicloud.com,
        nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com,
        qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com,
        yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
        mhocko@kernel.org, yosry@kernel.org, chengming.zhou@linux.dev,
        tz2294@columbia.edu, hch@lst.de, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=HpXjiETS c=1 sm=1 tr=0 ts=6ab4eb24 cx=c_pps
 a=Ak8bExYEjeps3Jj0Zi+cTQ==:117 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=GbPsI2Ihf5RTnMjR_gZv:22
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Nuu0otnvvFxtlZZjwoAA:9 a=QEXdDO2ut3YA:10
 a=IIT_bRn7abC_HnDGr_W6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI0MDAzOCBTYWx0ZWRfX4mTA0Vbqkk45
 Le/3o22cvMUKFfbbrkISnysHLDGHqHvWprr+t7gRYVI0rtFZJIIOARHqSckUyBg8HEO4BoB2OZe
 O8gGevQb+vo+CxadihzEXL6yNDWhsPU=
X-Proofpoint-GUID: e-ksPh02Og7xCTxZzYjK3VHbYNCIDA9B
X-Proofpoint-ORIG-GUID: e-ksPh02Og7xCTxZzYjK3VHbYNCIDA9B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI0MDAzOCBTYWx0ZWRfX9OgHUIFmkXoB
 svG4fgVmVk75zRb1rvtXIQmeUgLGrTtCGZrKEwVs8ahenAK0ErPw3WNPnet0QQWMggPXs1LzRbV
 5QJMGUHShEhIweRXEHiBMF6r+c3/7T0ZEWtyaHyn9hcwmc6z82uyIym5Fyx9xT6wU4PyyIJ5Mbp
 q7WY21scIuqEX5U7+gHlV4VYOBjRX/YA9iWCODbG5sDu4T8argGc1pQfKlROW5OOw2Nbf48DyW1
 kdv3Sg0LmkA/BvRTMmIsr//BCWe4zC8VecIHglE1HUirf2rBhi7Kv243jY6+cKw9I7uCQgBBf9/
 IuRsrySd1BzBlDmh4EJee2K6usj7QhxIwEqSPZcQG+f0CD7+QtnIDL5at0KryTMWPtxqlgPXU8R
 QJf3d6iY2/VIxrdFCz2G66iB1CvIKWxyvJM46jjPqsEqIej3ZPgdZoUloRvurF0bht9lnELHqlX
 IZfxMw41Y+aSR13iICw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-24_02,2026-09-21_02,2025-10-01_01
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 783F3A0004
X-Stat-Signature: ogt7of8jk1zcuenfq8egan7bhw3yo9xm
X-HE-Tag: 1790241573-436675
X-HE-Meta: U2FsdGVkX19tP5WWcwrBADZBRYTPjit7idZ9WwOKJWJOA4VPxD/ty4ETzWYySVj5FvP72PQBkbjMHCZkKCRur2pMxN+TULQjnyHfB9cvHQm4OgYNbRh86AgEzZdYGQTaiV+P/Eakm4LEF/IfeiRVyTOAhFUMklP/kb4+Mm/emrfesAKIPGZ3H2I4lHIleaLIFONcpYs64hLoYLxiLYK5agP6sLapPPIw72AiNLX4rbO6o8HiHwoGCF2WTc5YJmb0jMTAWD7xPUmlY96vtnICvBUL/tWRntP+zzkwF54hUJOyC4BbgItqYuaYTcH6rTj02tpF/Ku7QEt1QTwqqijhMqz/ksrJHpGR1c2VU3TRnvIMpT4IFf9QF9TUYPoiFXHqjhAuzOpRLuE4n3ITMGMPc6NTQJ+eE9krga/DNz7NEfW+vCTpQn+75GIpVmbux1M3gWAlkY6GNLDuzIg0K6nMyuOHS0mGGRCP7MboGSXZS3DbcgIsb0g6IIBOPSHI1Lbhs67dea4YVCEM/uYd9VgqvNAKwX5/B70eZL524DdigzsBtmjUP6exQZcEkVCPwKoqbthZmFhpTwBslwlfv/TT5MzgNaQ5dLB4R000PpBEJP7OYTcgjV+HcbbbOIJYEHNzBcMGbVEoNXtcrZoSRpBxyLUV/eCMdC8DP/YJPtIa8kO0q2LbaV1t5E7v1TS0nrOvXfvGrLIwRwByLb2fKFQjsL0OGj7BPldTsw9U3+xfQ0t2nO5wzskmZG45T7j7Njg14JXfujsfc8/PnipgNL/SuWM00Q3zc993jy3lgKI0ilcVamS7Uyw4puhneRtms0dUDCfMAPD5ygEvQPQNmoiIAiJf5OLGS+JtdczJ0crgSqlgXec93iOYrFmm88eLkT1qbwnG0a+uy9Dgb1lD5DOskJv/xQRjE8vxbnWhVGRHtHVKy08r8MUhi5M75UfppG857hT73ST+XDWar07BnLe
 f6LJfUYf
 Gd3xJFTymr0GilB6Y2rKVfmd8m5as9/hVksFRkJQOTAxbyD4xi4rqHxAEm2n30D2Gn7cyCGYHN17k9REKg2ZNaKW+31fGHecTPK/mPTjLZlBx/wupm+myksDAVZulwLkk+AewIrs3Ng7sp3CdMXi8BXO39Fn0PbWi2fxjheMCZOzAj2tsjlsOSgcrxmutcvdW+Vffm/d/vEeKqu0jmMu4ejfZq5NX8GxJKuOS7NJ+dYahiUOidKJ0cnz5JbRkg7987DZ6IooOS/CLl6ZQrUFgoRvYt3Uy+DtLuWLDz0S5r1iaLpLyCHN6s4JMvMRIkOzJ5mqiRXS2G5lwosLc5kpgW+AYwDaFD9PN2u1WSUFfEbsAyW575DihOKPCBCy94p3ZLe9OvTId+c3PDQd/w+hVeSnoG2wDCf91O2iz9nkYKykojpblG8/TfZ3ckhy7Q8N6aEpt3XROY+YrR6ZtWL4LUEdWj9+xgymc6JevBQixpVRM8xFKrRAput1p1xtg4z9uxmsSDHz47EryAJh1HEisWnFkOgsS+qfifgFeeaofnOF824lT0FMqfWAuNAhjVbdhVJQ6oJ/wes/b9HH9WZhAqF40lI32owXloyTMTRiw5STFD5PNSjqe2w2TUy6FvKEQl8zZ5XVxImI17R7PCqHoC8EM/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi KunWu,

On Wed, Sep 23, 2026 at 6:22=E2=80=AFPM KunWu Chan <kunwu.chan@gmail.com> w=
rote:
>
> >
> On Wed, Sep 23, 2026 at 6:15=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > On Wed, Sep 23, 2026 at 11:47=E2=80=AFAM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> > >
> > > On 9/23/26 11:35, Kairui Song wrote:
> > > > On Wed, Sep 23, 2026 at 10:46=E2=80=AFAM David Hildenbrand (Arm)
> > > > <david@kernel.org> wrote:
> > > >>
> > > >> On 9/22/26 22:55, Barry Song wrote:
> > > >>> On Tue, Sep 22, 2026 at 7:26=E2=80=AFPM David Hildenbrand (Arm)
> > > >>> <david@kernel.org> wrote:
> > > >>>
> > > >>> I guess that's because the LRU is not always accurate. There are =
cases
> > > >>> where our prediction of future access patterns may be wrong, resu=
lting
> > > >>> in refaults?
> > > >
> > > > Hi All,
> > > >
> > > >>
> > > >> Right. But these would happen in both the SYNC and the ASYNC case.=
 Which seems
> > > >> to indicate that making the SYNC case behave like the ASYNC case (=
keep in
> > > >> swapcache before evicting) could actually improve performance?
> > > >>
> > > >> Or is the SYNC case in general so fast that it is not a problem an=
d the
> > > >> swapcache is just not a good use?
> > > >
> > > > I think the problem is not LRU being inaccurate, but ASYNC case cou=
ld
> > > > overshoot the anon reclaim very easily. File folios can be simply
> > > > dropped, and increase nr_reclaimed, but anon writeback (swap) can't=
 be
> > > > done durig the reclaim iteration so nr_reclaimed never increase dur=
ing
> > > > the scan iteration. So the scan tries hard to scan and reclaim more
> > > > anon folios, more than it really needed.
> > > >
> > > > I think the real fix is some kind of different watermark, throttlin=
g,
> > > > or a different counter to limit the scan of async swap. I mentioned
> > > > this at LSFMM this year but I guess I presented too much at the same
> > > > time so few people remembered it :D.
> > >
> > > :D
> > >
> > > >
> > > >>
> > > >>>
> > > >>> Even on Android, which uses zram with very fast synchronous swap-=
out,
> > > >>> I can still hit the swapcache from time to time. So perhaps with a
> > > >>> slower device, such as an HDD, keeping the swapcache around for l=
onger
> > > >>> could allow applications to hit it more often?
> > > >>
> > > >> Why is that specific for HDD? It's the exact same app behavior ind=
ependent of
> > > >> the underlying swap technology.
> > > >
> > > > If you have a shared folio, you must use swap cache, and even for
> > > > single used folios swap cache is the way to do synchronization,
> > > > regardless of the device.
> > > >
> > > >>>
> > > >>> I don't know. Maybe Alexandre can share more details about this
> > > >>> benchmark. I'm also a little surprised by the 15% regression in
> > > >>> Sysbench OLTP. My initial feeling was the same as yours: we should
> > > >>> release the memory immediately after writeback completes, for both
> > > >>> synchronous and asynchronous I/O.
> > > >>
> > > >> Right. And see if we can identify why we are swapping out the wron=
g things :)
> > > >
> > > > I think we are not? It's about over-reclaim. In the worst case we
> > > > might put every anon folio under writeback, while no folio is
> > > > reclaimed, if the device is super slow.
> > > Ah, that hints at the real problem then? How confident are we that th=
at's what's
> > > happening?
> >
> > Given the fact that ZRAM/ZSWAP doesn't suffer from this, I think this
> > is the cause: the main difference is that ZRAM/ZSWAP frees the folios
> > after pageout() so nr_reclaimed is increased (reclaim loop just keeps
> > comparing nr_reclaimed to nr_to_reclaim), other swap devices keep the
> > folios under writeback, and continue reclaiming unless they hit enough
> > clean folios to drop.
> >
> > I can't say I'm 100% sure, and it's hard to verify but I think we need
> > to try fixing this instead. It's not hard to construct a case where
> > all anon folios are put under writeback due to very slight pressure,
> > e.g. a dm-delay (e.g. 500ms?), 1G anon in one memcg, very slight
> > memorey pressure could easily put nearly all anon folios under
> > writeback.
>
> Alex, One question about the `nr_reclaimed` accounting.
>
> `PAGE_DROPBEHIND` increments `nr_reclaimed` when the write is
> submitted, while the folio may still be under writeback and is only
> actually removed from the swap cache when writeback completes.
>
> Kairui pointed out that async swap can over-reclaim because
> `nr_reclaimed` does not increase while anon folios remain under
> writeback. Does the early accounting for `PAGE_DROPBEHIND` address
> that over-reclaim mechanism for this `MADV_PAGEOUT` path?

Unvoluntarily yes :)

>
> It might also be useful to check this with a delayed swap device, such
> as the `dm-delay` case Kairui mentioned.

Yes, I'm setting up a new experiment to check everything mentioned in
this thread.

Thanks,

Alex

>
> Thanks,
> Kunwu
>

