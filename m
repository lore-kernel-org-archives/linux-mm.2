Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4336606A327
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=Cl2qQFTv
Received: by kanga.kvack.org (Postfix)
	id D86306B05D2; Fri, 27 Nov 2026 04:39:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10736B05D4; Fri, 27 Nov 2026 04:39:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB0D36B05D6; Fri, 27 Nov 2026 04:39:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 922106B05D2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:39:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1AA7120256
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:39:35 +0000 (UTC)
X-FDA: 85480401510.04.9E674FA
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id 301A740008
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:39:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=Cl2qQFTv;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf17.hostedemail.com: domain of "prvs=9791c87d15=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=9791c87d15=alexghiti@meta.com"
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1795772373;
	b=W7UFVg0DDZlx13ucqdlx5iL6pj6iNPIduvmizvIpP5wZnlBHokfGMB8KDkH6Zs4Ek6NpOO
	IGll/yHiLY07AlBNm/Vp5+jpTEHRZNR660sJdmlRYF28yf2GHhRWtnRqSDHftr5UDIo1C8
	XS5aS1/y4x0KcFvflR8aM4XOrcwHbNk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795772373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0z9LEZHumUAUHG3YdMFAeVsWg1NsvibU7Iun+HCcQE=;
	b=3CV3p0TJ7u8uBGoYUq0A25tcXIAHGonmQTm33ze2VMzyokTF0++bkrr6VtdODw1jUFPBwr
	egSKT18/P5mmSUXtwGj61JwatmAXA1KNlQOBEhvsNsdm7suGmewATa/dEAOTPAlneGoSSa
	30lJROEmdKgZnkLzt0gOj96Bu6pkc9k=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=meta.com header.s=pps82601-s2048-2026-q3 header.b=Cl2qQFTv;
	arc=reject ("signature check failed: fail, {[1] = sig:google.com:reject}");
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf17.hostedemail.com: domain of "prvs=9791c87d15=alexghiti@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=9791c87d15=alexghiti@meta.com"
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AR7H39L1064294
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:39:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=K0z9LEZHumUAUHG3YdMFAeVsWg1NsvibU7Iun
	+HCcQE=; b=Cl2qQFTvVltL2w23IhkdmlXjtl4mRblSIYOUrodH8uXBikuOyaPfn
	AwM34clYsLNxslN91njKCZR4h6K/HVDqMuRAgtZ4Zk59P3LKSkDQVTwk/vPEUm4D
	+VwkcfQajLtb/HBD8BWP7z6lSuyw/PsNbm911CXaYdf4kTJT4COVo4cDzuttG19X
	F1nwCmyLf1HyikDpTlGEvcGiftlaNiE7yKQ48qT96k73Dya5sEUwqeLxHRpO4NU5
	cZE7xohkfaFDJj4jowDSz4bgmkDAHvu5gCNYOsePuO2NuUcdwVBL2IW07q//387o
	g6lfNRkD/nwxz6Xg7hiEnYNPaZxoQ2Cpw==
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j5x6b3fm7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:39:31 -0800 (PST)
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b57668479aso1672659a12.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:39:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795772370; cv=none;
        d=google.com; s=arc-20260327;
        b=X49IOXpBD5CKfXhPb+CrTM/qZ4AMGH/8vlRSPGVUFWI1TRWeWMewaGzrpyh1Czb7sM
         4znOBCGlkRuFTGM2pjvDDMXE1qmXLLjh+ejjWjCHE3dx52HoBuUkHuyAfiHCmVwnpsPY
         Q0zarrekxHtYj5ikwSZuY4qBhR2OP6yk0i0WTgdd74FXE8L2GnbXjfCPWL5EBGh5Ql9c
         YDkedcaT2NdhmlFTQGFoOoWoZaG67VRM9xpNjbfDjgtU6E/fc3EE9YhaiQOn5N/4QrqR
         2/Yf5IQs0zN5mgV3EoF6qiwQMMMB37qClncGfSqm1ThGIg924YgkotPK+qBWAyrpKjz7
         F8Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version;
        bh=8zFqGbpLQ4kLiiFXncahL4YN57S9NI9BXavbvixV9aU=;
        fh=E+7M3a9uRC4/fJzLiyggKLcmDDDE4V+Y1xV9OjA/s1I=;
        b=O4Ze3NaCerGvFlVdDu4EEjGVfEdwySlqkKxn9Nf4CmaZGKIdsE+QpdVsN9zZBAsvpb
         sv7+q/U/CdT5sGoQgDX6jl6bRtuwg6VUw/Rr33YP4nOTlMXbXMdcOiM37a6hiRmqHC09
         EsgUQFzi/MI/GfIFNUUQcSTMzh+lraJd8mS33bYR72me2ql49v+T2abqPpX0iFOcRPwA
         VZH2qj3OonyT6zgv9L2qaeU5jOfXxSB2tssJ2ev4w2VXODqbuKTPSVyJmOAHXeXdB8F5
         pqwGVbOjcw2O2T59vn2O+E802tbeVxIKdExoAidCmgrfL/2IzRw2VvgkMCy8VJQP44wp
         CK6g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795772370; x=1796377170;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8zFqGbpLQ4kLiiFXncahL4YN57S9NI9BXavbvixV9aU=;
        b=2iHINgyNcfgQppGsXlUipOEs1McsSISFqrFlSGortQn3bux6pKAq7Sl7oMdFp0wgNp
         uUOyFWc0DDfMo7MLmFbQAChzKgY/d1nm40/OamZUS6PZp4b+od+joVCDiZ17ODrFcmE8
         d8eGcuRtazjtGU8nALvqPvYdlGD8bZa3dAOtZtiEEvroggTduARUyp7VJTfgGkiSrsQJ
         G8LQM6siYCCaOUfdRMAcUE0w4gXUSljA8RJ0gg/FXmMAjLrH1puvAYmaNWBS57iPWhqG
         iW3ygmuZ6gWV+f6Kah/sGjMFt8Hb4s1vdN4+YsJz3n9QOCxWsRUrDmXz5x9fF0VjJbbi
         m2UQ==
X-Forwarded-Encrypted: i=1; AL+hErGvNbRuod3wlhcF9yCao4GVrE6kY3JQyHiJnbNvq5eaEeKRSq8wDr06l3N0IIPSepswBwsmUxz8NA==@kvack.org
X-Gm-Message-State: APuU4Z8timUW97GwhPEaFlYV0cmJti1vwcC2g+chJxTp4iXFbyK4uylF
	gMKa2WH3BdhUTRbRmt9+NAPei+fTK1jfAP5cM//wrT8BVjenpPL3wdEDrk/6p0YRSHdboZ2Tgr/
	3l/KlJyEe6TJCmPw4vD095+lPT/VvtxqUF/pqhQHsFRqpCODYom/09PDAR8Yks8yeeSSYhvUZFI
	rTcDkJCDFxt/LjYwXQ3T2+1kZvrA==
X-Gm-Gg: AZFdTZcK7es/FieLHkG0NlDhSFnDVpc3jSbnA89rvinUdbaRJG/Jw/KF0YjXl2KStls
	zgR3eOk7HbTalM/vie7VLM61f156RmPQhJCIZYApTPIPo0kDwqjzX9GBIEp63+BT94rgyYv07vt
	CfGjIH3LJyWxAQmwmnh9p/0WJ/oGplfiDXcK87GKGw552LGfJI8xAQs4w6RDQFW3qPmc2Iy1JV/
	JOLgRsUaKda0b8GKA==
X-Received: by 2002:a05:6402:450c:b0:6bb:64cc:b969 with SMTP id 4fb4d7f45d1cf-6bb64ccbb08mr2777497a12.10.1795772370428;
        Fri, 27 Nov 2026 01:39:30 -0800 (PST)
X-Received: by 2002:a05:6402:450c:b0:6bb:64cc:b969 with SMTP id
 4fb4d7f45d1cf-6bb64ccbb08mr2777469a12.10.1795772369944; Fri, 27 Nov 2026
 01:39:29 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261126094318.244973-1-alex@ghiti.fr> <98fecdf0-6409-4499-90e4-63996f33db90@kernel.org>
 <CAEmasaXWwWeuQnMbA+g8OyvNwe721Dro+1h+5pfTpzLuV6dx3g@mail.gmail.com> <0b7e81a8-d291-4cbf-8da0-e65e9a0b40a0@kernel.org>
In-Reply-To: <0b7e81a8-d291-4cbf-8da0-e65e9a0b40a0@kernel.org>
From: Alexandre Ghiti <alexghiti@meta.com>
Date: Fri, 27 Nov 2026 10:39:18 +0100
X-Gm-Features: Aa3M54qX-_pqmJg9C5gzk0ism0i4jtfnK4izYtYrn72d6ijUNYhsMgGVj8eDvTE
Message-ID: <CAEmasaXR8nP+jGF9XHOr1Bibo253wLgVh5D9Bjw_2Tjy8RFp-w@mail.gmail.com>
Subject: Re: [PATCH] mm: free the swap slot of a dirty swapin folio
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>,
        Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Baoquan He <baoquan.he@linux.dev>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Youngjun Park <youngjun.park@lge.com>,
        "Liam R . Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-ORIG-GUID: TtKu2mejzS1vBI-IpijD8WomkXn2GPu4
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI3MDAzOCBTYWx0ZWRfX5Y35W8bmFUwT
 O9z2rQBA7sM9+lW335Rc2Ai9ltWd4wQE5zdi8douVdLEaw9S+6yLiqvBvvUfxC+s9BmTzfnvX1V
 Akac62HdaG2IPbeuAeHtL1LRL+CyK9g=
X-Proofpoint-GUID: TtKu2mejzS1vBI-IpijD8WomkXn2GPu4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI3MDAzOCBTYWx0ZWRfX3FvrTaVsJI5K
 5cY2dHu6kmqSButQE3h2h5r867/Wd+O9OO8nT970IzdDWxaa0H30125+zZmx2/xs0Ww2nhHUA8q
 9PBGrWfDWxp0g4g9x2VS26Kwc+gDS0gvJu1i7Nl3LZFC5wbDFqyHXbsN9huC51xOMLDM3KhSjdi
 uFMc76hvqgnk3I/780EIPDWZjy5RgzChZhxurkkoKTrHRaF8thnmHeDr/yvA7qb64KFCrA0no76
 whu1yjS25WDTDdhMiZm3u69qDS/xJqzcjpemzjso29pKFkSC+WQwAeY12atWQzqE/Q7gl3T/PF0
 7NRby4CI816K8SSIj8prDunpJWYW98RSdw1tmkTCRY3HSXpy5n8qv6E1jMAGmvP/GfRLUlC3rpd
 FEW2c/rzO6egWsYvTemdxm0c8cvX3F6cl36GiGNEXRzW4/5MsgFIeStfvg/tveuZDyH4uYdFSc5
 jlKJTVEmFBI8EcUv1Mg==
X-Authority-Analysis: v=2.4 cv=GOCdgeNK c=1 sm=1 tr=0 ts=6b094fd3 cx=c_pps
 a=Tczdrg5if7+wQeIJmxD/XA==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22 a=03ozwUkBphtHgyqjj1sw:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=BHRAutx6adPIF07HuA8A:9 a=QEXdDO2ut3YA:10
 a=1oAhN8tkTtOBK6_UvoHx:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-27_01,2026-11-26_02,2025-10-01_01
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 301A740008
X-Stat-Signature: 7u3ctksfpmpmmp9x41j6et5yxnt9dkzz
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795772372-596274
X-HE-Meta: U2FsdGVkX19zGbIDyG2JA2S0SieLu1uHPnFt3PQhz8F2ymefZYkVlg7CH29sDZ3PtRAUPqXLTQEvCZfpW0l7pE9fbUflBy7rPsRzcBxLz1BB0Kc9NYiLJP0fUqPK45eL/vT1YWOtjipQO7rtkqs3rdtqyB90SgdjcIf4xVvksLn31BuCZjSdZ8Cmt/w11jhTF8tKXSaLpG2LNY4ad95T1uWdRCielmXFHcYN6o/s3ngBGqyq5itcLzXg9RAonhQLQiPgUSseg+dIms42Ugcjf8zJbkUlIBPutZqGWzWhgIJV7aPCijgJ8brAOJ1zxBhYEcuGvHIWxJPAvfPx62NYV1UUbalRJuU9QHfnRhLPrC10LRGppE8PDuN25MJtxuYnQfzsIP2uiS5nMW/At9DvS6ebKCe2anQ5Lxke4KvkBpTOaCUvpZnr9i83nB7XBjLRLoVIsm5JKtkudBiPBF1FpdVX9Hkq4DJcTitYN8TA8NJkvkqQH6WqBs/Xc3zFAv7qVoPpLSOwFlsCKnyz45HBXvJipCI3NEsgXvX3EQnvrT67q28iNVTKTllm1+lNgaE3oC581RDdh69/RReeJSfl0bNjPIUFmoGS3yGuAQhnTCyh2JxbxQiYjin2irf18XEm2bmu5qsGaSU1y5DodUUy5W3AZVAp6pUR/EYvTbgyw64jfcec0aRxWWvFtB23XVV5Q0hqaWIc0KD0fOWB7QhoZ5mGe3kARzalqqvtYIa64vLD53BZw3lky3/yCrXr+MthAev5b+PZOc97i9jyAJCRbtsME/0vEgO/8p333GdhnR5U+Zo2+JHCrVEhpAt7DC6iagtnToFfdmT8dSzAdh3uWlXjPuPhKyFckTF9N7NTz/xfPPvpkXm/FtSVaZEhAixvylVF8cmegT7Gg49rhvJfQ3p9EbGtbIA1oidjoit4PzhMvI/L/jkMOlHgf2/QqhXdZYUHEa1htQ3kQe+VxuS
 F9rc5iyS
 Du0gBUclq3ziAT7w6lDayp0eSoi/Wqs6KLn6j0nIPfbJi+/uNoM3h2k+XT53jFKptGgdOIqTIgnezj0KxL43w5obECpP08A6oPl3hNOIGjZcQp0MgpWHGkz5zDJPVlVvms7jsmyrvBzut7xAsoijNTAdu42ti9ITbz5NC1eoynm8BR1yqp3WAohPMMtDSS4M8/8LqavGUzhXb1MJ+bcWWQ8rtMSNsNlRN5ES3nKRnbQjdJIEbdnce/2U7SKn5e70CT3rwbVqW5uy/eODJJuI8Hchf6MKpivKbFppB/CRLC9ApiNPtUroYn028SeAZm5uckH+LYZ/kFvQYrJ2iNaC0NsW9VgB7fGvuIft9jwdUvlcBJFyBCpeM1lbUwTw0N90FxyVfkHftpAQpaxqk+/Nh8632oRX5/HHq/teWyaW6216AIH9oOHIYAfzE01DZgTqM84JTb+qIQMbZXdMH37W9udy81N56X9EHTmRz56jj+JehAhKjW4f3iRkUkzu17axFDYVSiGR3HTn5SkpHv2lknCkgK5kEGVj2Z7JoSxyKKbARNtzU4FYMdcyxuNp6VnfDwBrvuf3TUpFfWxJ5DmuxZ6jxseLNpaoA9oKFGZ864FwfSWBeWCcTmPWFnOd+fOqzYVb8g5fAebzFHXRkr+kk6n3UHEKvPSV9bgIpnpNe8k68dYL7UjofMEZJb5O0jizbmkw6UeDoqcCS4qrqfz4gelhhBfzjCs4nLs46FnAMbFNBEA46+fBZ+RNaRz9s3y/bIU57
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 5:20=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> >
> On 11/26/26 16:01, Alexandre Ghiti wrote:
> > Hi David,
> >
> > On Thu, Nov 26, 2026 at 1:54=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >>>
> >> On 11/26/26 10:42, Alexandre Ghiti wrote:
> >>> do_swap_page() frees the swap cache of an exclusive folio on a write
> >>> fault only. A folio loaded from zswap is dirty: zswap drops its copy =
on
> >>> load, so the slot no longer holds the data and only reserves swap spa=
ce
> >>> until the folio is reclaimed again or its owner exits.
> >>>
> >>> Such folios add up, and they are expensive to free at exit: on a large
> >>> production workload, the exit time doubled when zswap was enabled. A
> >>> third of the increase comes from the folios left in the swap cache,
> >>> each costing about 3x a resident page to tear down; the rest comes fr=
om
> >>> freeing the zswap entries.
> >>>
> >>> So free the swap cache of an exclusive dirty folio as well, so that t=
he
> >>> slot is released at swapin, as is already done on an exclusive write
> >>> fault. The folio is dirty, so it would get written out again anyway:
> >>> the only cost is a new slot allocation on its next reclaim, which wri=
te
> >>> faults already pay.
> >>>
> >>> On the production workload, this patch removed that third: the exit t=
ime
> >>> decreased by about 15%. On a simple microbenchmark, 4 GiB of anonymous
> >>> memory in a memcg pushed to swap, read back, then SIGKILLed in a QEMU
> >>> guest (mean +- stddev of 9 runs):
> >>>
> >>>                      base            patched
> >>>   exit time    989 +- 24 ms       502 +- 28 ms   (-49%)
> >>>
> >>> The cost is paid by folios that keep cycling between zswap and memory:
> >>> each reclaim allocates a new slot and adds the folio to the swap cache
> >>> again. On a kernel build in a 600 MiB memcg (-j4, defconfig), this is
> >>> not measurable (mean +- stddev of 5 runs on bare metal):
> >>>
> >>>                        base            patched
> >>>   time (s)        592.4 +- 1.1      592.4 +- 0.9    (+0.0%)
> >>>   sys (s)         256.6 +- 1.5      257.5 +- 1.4    (+0.3%)
> >>>
> >>> In the worst case, random reads over 4 GiB of anonymous memory in a
> >>> 3 GiB memcg, so that half the reads are zswap read faults and the task
> >>> spends all its time in the kernel, throughput drops by 1.1-1.4%
> >>> (mean +- stddev of 5 runs on bare metal):
> >>>
> >>>                        base            patched
> >>>   reads/s, 1 thread   37310 +- 182     36889 +- 77     (-1.1%)
> >>>   reads/s, 8 threads 291937 +- 802    287954 +- 373    (-1.4%)
> >>>
> >>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> >>> ---
> >>>
> >>> Notes:
> >>>     Previous discussion:
> >>>     https://lore.kernel.org/all/CAGsJ_4xBtKGqXFP4zvp+Qn+tb4X7aCvXn+wq=
Dqot_cXR92DjhQ@mail.gmail.com/
> >>>
> >>>  mm/memory.c | 9 ++++++---
> >>>  1 file changed, 6 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/mm/memory.c b/mm/memory.c
> >>> index d477a4f986bc..dac0f0a24bc7 100644
> >>> --- a/mm/memory.c
> >>> +++ b/mm/memory.c
> >>> @@ -4711,10 +4711,13 @@ static inline bool should_try_to_free_swap(st=
ruct swap_info_struct *si,
> >>>               return true;
> >>>
> >>>       /*
> >>> -      * Free the swapcache only if we are the exclusive user and
> >>> -      * this is a write fault.
> >>> +      * Free the swapcache only if we are the exclusive user and thi=
s is a
> >>> +      * write fault, or the folio is dirty: its copy in the swap slo=
t is
> >>> +      * stale then (zswap loads are exclusive and dirty the folio), =
so the
> >>> +      * slot only holds swap space.
> >>>        */
> >>> -     return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
> >>> +     return exclusive && ((fault_flags & FAULT_FLAG_WRITE) ||
> >>> +                          folio_test_dirty(folio));
> >>
> >> Why not more readable as
> >>
> >> if (!exclusive)
> >>         return false;
> >> return (fault_flags & FAULT_FLAG_WRITE) || folio_test_dirty(folio);
> >
> > Agree, I'll change that for v2.
> >
> >>
> >> But ... isn't this zswap specific? Why do we have zswap specific stuff=
 in this
> >> common code?
> >>
> >> The comment already gives away that something is not quite right here.
> >
> > I am mostly interested in the zswap benefits, but nothing is zswap
> > specific here: do_swap_page() can also find a dirty folio in the swap
> > cache when reclaim bailed out before writeout, or when the swap write
> > failed. In all those cases, the copy in the slot is stale, so the slot
> > only reserves swap space. zswap is simply the common case, since
> > zswap_load() dirties the folio.
> >
> > What do you think?
>
> If it's generic, then the comment shouldn't mention zswap in the comment =
:)
>
> And the patch description should be all about zswap.

Ok, will change that in v2.

>
> And we should measure the effect without zswap.

It should be very very small since do_swap_page() only finds a dirty
folio in the swap cache when reclaim bailed out or when swap write
fails, which should be very rare.

>
> So, folio dirty -> We'd need another writeback because the content on dis=
k is stale.
>
> If we reclaim swap, the next reclaim run will have to re-allocate one.
>
>
> But why is this "is dirty" linked to exclusive?
>
> What if we did
>
> /*
>  * Free the swapcache if the folio is already dirty, or if we will dirty =
it
>  * immediately afterwards by writing to it.
>  */
> if (folio_test_dirty(folio))
>         return true;
> return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
>

I had missed that folio_free_swap() checked the swap count as Nhat
noticed, in that case, I agree the exclusive check is useless, I'll
remove it in v2.

Thanks,

Alex

> --
> Cheers,
>
> David

