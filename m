Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98DEDC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCF16B009F; Wed,  2 Sep 2026 15:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1E46B00A1; Wed,  2 Sep 2026 15:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9248A6B00A1; Wed,  2 Sep 2026 15:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 688156B009E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:28:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E4901A034A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:28 +0000 (UTC)
X-FDA: 85169808696.03.8DD7CF4
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 60B6B80006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:28:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cyp4TDkJ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=symUgFq+;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788377305;
	b=puJ7vr1E5pB1faUTbhsz5otjs1lIGb6vXxBTn9NvCOLJGGOgkOwyP85I+QnEGf2BUBwAww
	Gqca7O2X8E9OG+6JVYWdEeSQfPuEfbQ5apw4IWShSWSrlasJBQ4WwVZjXDoY3Zt/y+yltT
	mnf3VVxi4C7MnkVjvrRu1pfhPovHwhQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=cyp4TDkJ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=symUgFq+;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788377305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
	b=0C/vQ9ebhrqaukTEGPAKjJvYgh5TA+VivF98mw97XMYfaeAP1nRlsHIuBq1eCmhLEFSn4/
	vzjvOycSF2n6kwIOcUjdLar39qxHvs7bshkhc3CplBc0I8Hlh5YO42RW6Nm76xl1K9qNEi
	1Fv795xbRX8UxOvgVYTaFXukxnCBo9U=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682J6iXY805155
	for <linux-mm@kvack.org>; Wed, 2 Sep 2026 15:28:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=W+SY
	Tc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=; b=cyp4TDkJ/oQOm+m66PZI
	il+NOHHVuNNz2gQNwdXPGNEWWpTrOs1GBJhDaoSJv8d72xfPywp+rtCgZ57E69YW
	gboVG3IA8fyYSTjVKaA3c/AWVKakwWikrxM3emur4TII9I5G4yDWyieQNZUWBtkx
	dtkvRHE5BvLIf22UUryNiYdFZWjfUm860IfIf3COFuAkZJfU3Rw1B6j9jS1s6w5p
	Kr639PsuoUn5LjYTk00BKLQIY1PDzVoMZ5RELLqMAryoDlj6dLBH+v3rFriRTY/L
	XF7B/9GHbhjZNds+5S2FCxe0COjjolet0Xc6UzeL0getQ8U+v1IYvq+MafORGNrY
	Ng==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4gesp0g54d-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:28:24 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90e7db8d191so27012886d6.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788377304; x=1788982104; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
        b=symUgFq+jh2EOzEXXud4G78tWXH5UnK2yC0lDOqQRQP9+9nSqcVwCg6mV8PNZhwkfP
         aRzWXmLGosZPRS73ut+LvS+2nmRbTjPTK97tI0Hd4YOuDYB9MwXyOheW5WdeRChpcOmX
         6ti2mzJxncAYu83M43osLxGnRMNLQgwgpcFIEgiTc4MThDq6WDWx9PLpzUIiHWBOFJks
         mKl2CZ+xz+mJcIzVi+p7zTXbmunrI+iWH3ChoLHtrKShvf15jQZqY6FumkofoKyxHNsH
         8LrwcDF3UxboRu403j4t1z6AHKuSz8a8cskoRilvy9B5ESn1LnRcvCeRxrxJ/+i4w+5w
         zW5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377304; x=1788982104;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=W+SYTc9YgTwbyvQtPG0l4mF2QbsfRfThQCH4AEEmni8=;
        b=i8NpvBjJZJZh5ySJBdn/eDIIzZF+eNTsfIZCq0tF2zqUfFP5XzRJZRxN3xY3FVv41A
         Jw/6ZLRF6JKXtmX7esMYDVv0vG0E6NtDvocRxacoCImCKRPMUvnLnzD7uYKPzQm0VMdJ
         ON1oiOev69qB4Ro5f+1iXtGuTZnpCW8dso9suX6aiKCusr3xoN/k+gWDvqc/YqK7Yr57
         IUEbxdu5WytAlFqEMRNc4Za16G7WTVVFTCo16PCYSOVFMs+4Uxzu24zsv2AQF3QWvnIN
         LkHs289shHuK819HQUJ+iNAn2dRMpRhQnLZbyEzJoW4Fj5nDYzfYfhf46QOcSKAo84EX
         951A==
X-Forwarded-Encrypted: i=1; AKwUvByw+xjFVxqcOk+ftL1RpSz4rPbQegb7CZ5yZomHfHyNZXzICoAW3YVDeqBJWIvBVnrBs25RgLl2FQ==@kvack.org
X-Gm-Message-State: AFuF++n91XVJI+rJuCg40kW0EZAKZk1JCfRQO6rZoBh7PkM1Drjgoyjb
	Gohk8HoXA9N+MDlC/gLicBNPELmcS7wQfAfNB70VJd3WGtft/0JZOXHroB3MLCLsNW9IALB6Olo
	wLb/yFVjf+htWuG1XpgHYBc25ZyqE3kTtrd7m8EqqVdfXZXqM
X-Gm-Gg: AYBFou1bd6+OSlAr+lUeQJo9MUo61451YmAGqMkVTivVfBZ6tqzPQGScC3pcW7KiZFK
	CDySL3zWBUByHFIxBP6spnOAAX6NoLZf8kgvToz0ybgbdGf11OrpNrWORK9yU6/PJAqRGmSB0+f
	+MtUUHl4Ar51XK3TqQPibX3ts1VglTLBvCvP5hZ/OEncEMAgRDF2GUQSONMmFGwG6j+lkpdarUV
	fvsAgdySb2Kd4Mbzllqg9ktZv79H6WXOdm+Vq+rf6O6e9HP7SrFE1L/l1oG36OPVJynhYe+ISEW
	CksH7by41nLHXjtCgc7GsAtRhcDZbQOT3TvbFjRcKLRRdcOOLw+/I9qiILFx02MNnSoonuDztvf
	NSLHKoGLmkGF3fYvC0OVwmpfm2R7UjssWrEkEg1bdcgUsqvVagS5YHg==
X-Received: by 2002:a05:6214:5098:b0:910:345b:4c5e with SMTP id 6a1803df08f44-9103475047emr16906876d6.37.1788377303495;
        Wed, 02 Sep 2026 12:28:23 -0700 (PDT)
X-Received: by 2002:a05:6214:5098:b0:910:345b:4c5e with SMTP id 6a1803df08f44-9103475047emr16906256d6.37.1788377302941;
        Wed, 02 Sep 2026 12:28:22 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-178-193.net.columbia.edu. [128.59.178.193])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec85a0sm25420936d6.29.2026.09.02.12.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:28:22 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 02 Sep 2026 15:27:50 -0400
Subject: [PATCH 04/11] mm/page_io: take a const folio in
 bio_associate_blkg_from_folio()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-folio_memcg-const-v1-4-e2c1da22246d@columbia.edu>
References: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
In-Reply-To: <20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
        Youngjun Park <youngjun.park@lge.com>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788377294; l=1933;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=puRmIXD1Ve7ElQt9KP4DSIyIaDfy+iHVy11lX8uUHlg=;
 b=A79pQGpgugQaXZD+f5+rppwy1Fv88nCcpGb/S1P2ZfVpepR1h1m5T9Di6kxQiDuaJ1FmnPSw3
 +1svIpVjpKoBJsZ2VcU6UrLXchG5TP4f1m+DgNt8wfr2isRQsjzGTdP
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: IVsg2bOoTceflxL8X62B0qpd95MheOvl
X-Authority-Analysis: v=2.4 cv=PqejqQM3 c=1 sm=1 tr=0 ts=6a9878d8 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=XwBYxoxBwSosfWEfMcqm5A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=4JVmFDg4bpWGYAirTr4A:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX02LJkPxzmly3
 9NZgo0yDGSy7a3fYnGIJm8Y+BRS2zFAt2JizOoFvPcJt0lUAhuc2r86ip1y+F2yun2ufCqSGfgM
 nVWIZONaNhNx3cuulryJy6SOtpYEumj12uhT3NZRq5g44C7UaMY6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDE3MiBTYWx0ZWRfX+uBEfXM79FU4
 NsIuzmeSgj+u0ttvkH1VjiJ1GYzN62Q8+wWc3+a+sTeRu13ujeTmCmkkPMULU2Cs4wOYeHDqSXi
 eBmBg7J/RqBv/y7RhzYKIkq9k0xmlApPAyJ9+drGuoOYJqwAZoSgpQ8QFJgL/AO1K8ry4Ml0EB1
 QPAcU2yNHHzbXzZDrTqhQf+d9QJb7qBmRpSEhSQZFGoXIuL7aEOsCy+CklgArWtfIqm+swQSqGq
 Zwi1lLDmx/xaBot+j5EWgra5wERZNzZ8CbWsz6f06Kl2gbovQUhqAnUD9wBoW3vTXFdgptNAd7l
 qXma/ILesB+AorDugRs62P14RqXjG56KLIV2zJgWwAfKlC8IjClMU4IeVZPVURSUhxRLKI/QxSX
 hDaSO1UaG6XZAQrJLsqvxdSkXVTmY1QJ/nbDs5WeEN9EVGEoTjFfOwQ2v0/bABreE9FxrLhbbnQ
 HgTQVs/sY3ezQEoZjpQ==
X-Proofpoint-ORIG-GUID: IVsg2bOoTceflxL8X62B0qpd95MheOvl
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11894
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 impostorscore=10 priorityscore=1501 malwarescore=0
 lowpriorityscore=10 bulkscore=10 suspectscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020172
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 60B6B80006
X-Stat-Signature: g3hj9disme9bfjumyqj8j4z785cqom7o
X-HE-Tag: 1788377305-977464
X-HE-Meta: U2FsdGVkX1+dx8+T6DWR4Pew+fSnGhBshkxkIvEsGVYcS1Utsn5qyMmyr70uXisRVciWq1EXTF1mT35AoXNiqfGj0hotiwda1UyiMJclNNq5SBC/mkmIuYZQXclaTbt6zzqgVjd9a3XhqQyfgaf9g/GTkpOp7rKBSPNiA1+xdx75/TuBVOcsE70WN9b41jnujutkgrXb0yE1HYD6eiY+G/5XIbroMTVQsXBl/omkUAyryrKlueoqRL52ntsZ3WN93zTF/tzAetn9UfeYbiNSQDo12B7yN46hZbo+emVtM285aGulNTW7EFvRCNeaCy8Gmm6kyrfNyB61NHSzVN8bjqgIB+f7bYnaVa4aT/Nwfj1Rp/0lU413bE4AYGc5aK6KNkAEN8BqRM/XH/luWFevAAEC7nEW0731PmNwzMWO127pSc6M+hJWHveR3klITdfIs+G07BB48XTMNUB0a+7PjI6vyEx6BaOM1CVKG5RtVzx0kEPKpbB+f05xd5O23PGx5Pbrrvy/DSJXc4Bnj5AAbEC79/Yp9q+lnLoQ4asXsj2rNpE9rDsZqI/I12EdJPJ07dei6UqZ1fV25kOS3igGUeMTtZyQgOi/VIx8CPys+kfBzK9CIwXsGZm901mEvPGCvCAsPxjyuS+c0n2xKL75iBFVvZHKKNBe27swScEgijzeMZcdqg1QuyfMvE0pTM08+/g/AidaKSPLF0SNcbvLXKoXKEQDGGw9PjKjVRGU1zuEulotj4Crv6t/AxCLBEkCF7LhuMcE71K2KliDpVZ+0zxEC40zYiZGiYPxNuDFq6H7ly8dzekKXey+alyOr5TgtSVt2fy5WQngSYluSmSt8Gl6fnvS2X0gS8rvwNKE7RtlWRBAsVbELzHtLOl6ABt2KDZnJIxOY0pX/ItQY7w0UdIFojE4alrlHUAFwzMD6pP5ekFwvEYFZQElbNjOzBnVdPdgkXpNuT4p0VR+pPs
 mk61x6f6
 51uFEEylY3yJ2EjJvq4YAMjg9AUPFscrYk6WJfC19AoAQfp2lKh+PMV4fn3KaeEygPtkOg9V4MIBzDfNjXm/HXLHS2x99hmT59cm4cZ8Uyfa2OGLhWQwy/ovAc8H4L0zAx9oV4cDZlgtB6RoaWtHUj2zmGq5/sikIMa6nYoRLwRVjZEsLjd5TEhYK9PPclsv00H6mX5eQvJKDqldyeIuHz0Ux5RtNfwCEW7oHWWn09sl/sQCKwVdXgUc/3iI4xJNzEOd+F9Uj5HniH+u8JhSs0hSEJl+HjuHf4zm2Cta0+0yHxkU30EeU7lBl26e2Weymm9eaQNKNxACIwAXMvEArhn3L12SWL4IFBpyaMaBQ3LC0IQRYS/DEmdguHOnDt/BeK1l4z1vbhDRDRAY5K/+wICkpQsJ15CW1bzVZI5smYqpDeRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bio_associate_blkg_from_folio() and its helpers only read from the
folio. Constify their folio arguments.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/page_io.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index 1da4ff484f09..5f7756e370f7 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -256,12 +256,13 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 }
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
-static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
+static struct cgroup_subsys_state *folio_memcg_blkg_css(const struct folio *folio)
 {
 	return cgroup_e_css(folio_memcg(folio)->css.cgroup, &io_cgrp_subsys);
 }
 
-static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+static bool folio_blkg_can_merge(const struct folio *folio,
+				 const struct folio *prev_folio)
 {
 	bool can_merge = true;
 
@@ -277,7 +278,8 @@ static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
 	return can_merge;
 }
 
-static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio,
+					  const struct folio *folio)
 {
 	struct cgroup_subsys_state *css;
 
@@ -294,11 +296,13 @@ static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
 		css_put(css);
 }
 #else
-static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
+static bool folio_blkg_can_merge(const struct folio *folio,
+				 const struct folio *prev_folio)
 {
 	return true;
 }
-static void bio_associate_blkg_from_folio(struct bio *bio, struct folio *folio)
+static void bio_associate_blkg_from_folio(struct bio *bio,
+					  const struct folio *folio)
 {
 }
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */

-- 
2.39.5


