Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E81E606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=XcKb/MaK;
	dkim=pass (2048-bit key, unprotected) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=wSR10lry
Received: by kanga.kvack.org (Postfix)
	id C02366B05B0; Tue, 17 Nov 2026 23:29:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2E16B05B2; Tue, 17 Nov 2026 23:29:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A246B05B3; Tue, 17 Nov 2026 23:29:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 764816B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6FBAA82C3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:13 +0000 (UTC)
X-FDA: 85446960186.06.58FDCA4
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id DBAF1C0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="XcKb/MaK";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=wSR10lry;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794976151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rqAEWub6b+VNUKauWaWsmC6HlMEYDyZPR4KLlxu12zc=;
	b=Jtrlt4E7aP2PgRIHqFo55v5/qX4y/NanFMoZnoVKc6xLttOMdtpKpcap/iDJVQsDekTGsN
	KRhNLM96fnqE0nZE2W+/Jxjm5waQaWuNyBwlXkPj+MIHkijubFzlACtmAc0R9DORkmtwQC
	1r2K+7bk5baOkvxuS1w6fuMw7OqagdM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794976151;
	b=i2crjrLaTPefNKqa4d8KD7dJna/SJHk2taYfZcB4nXiAM29+J2D8RV3AYiqoN9gfAaHyC8
	ZQ4lKCa/DJ82AsqAo4/EFCPocncofYjP7A+8fI8npUjrOMJWw/EATb0mAXOLLijcd6qHyL
	b/tlFcKNvZerTVpvva21+Vg8sogiTj8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="XcKb/MaK";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=wSR10lry;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167073.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI1XQuR3394976
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=rqAEWub6b+VNUKauWaWsmC6HlM
	EYDyZPR4KLlxu12zc=; b=XcKb/MaK0eyLn/5OAfV8yBM2KRS2M6b5kR5SMr6EFm
	CWnmQAF2vdwVgdMUDq9LQ0B1kytwzgnyCHTWOs93YThc0KuTvsQ7CyIyQ6JAqsTV
	Vo6jACRz1trjeOQMhdWiAi67KSg8HHnKjoHZxfXLgexeC7XX/nXfNR5TghfdcWs9
	82JWEd7BocL6iqzZD8yUP0rTVLepl/bIT6esC2voCKjI4lBaTYN6n5inDvO5NPKj
	On7x8D2GIiZH7BRMNehP59V5pbtScQPMsHQW9s4RMZ2FMmTPuhdw5wwBdi3nvERz
	AUrzScQCknu8WiqXoILhp7DXNRWCD+iuhydQEqmBaQaw==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j0yu5sf1f-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:09 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-948d83322f6so105437585a.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794976149; x=1795580949; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=rqAEWub6b+VNUKauWaWsmC6HlMEYDyZPR4KLlxu12zc=;
        b=wSR10lry2DoDsIuvKadPECVKe0rR6TmOr5DMSaVrD1gSK92kZJLCJBxOTgkumvgE3e
         l1p4vMcOo4oubLz+1w1MweTc6MZk5NYwUc+3NWWi8/nQhiVXU4/vj4OrH1r0hlzKHxe7
         GHL5C+5RCnEt7U16y04CCTRtgftiFTxKHHvkoarji/bRZeRLsTTDDI0pbE6ZnORChdgj
         w8ZEsN2IdtbvsBsjNzICUOf/g4I6TdszM2knOXkTVAeK+oIqyBgOgNUIcNhdBrXYO2Jn
         483xAwRhTmmWM+jRV6LeHHNfpv4bp7YgRm3NXWE6Qj/pHZ9fLKJzdb8+5UylENcn54kh
         5uhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794976149; x=1795580949;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rqAEWub6b+VNUKauWaWsmC6HlMEYDyZPR4KLlxu12zc=;
        b=GAgJazDfUTt+KOH16+b5bCryV7uGdA4J+dgHOaFT3FPlRfAAibOIHgmXBCBNb5cC7N
         MmJHcclkJ4veRSvkXsyHNiNfIKEhedXXly8hJagfYb2O57csGoHX0M8g1CJmc2Dzx9xO
         CVryFrr/fpjfilZWCs8Oc3NRLTexvt8CBNJ4TntP+xEhz0cXGzPygvhAyGn7EHvKQR3f
         ZGQjnaQQkM0NVAYxdgdQwb090J0zC8/FTz910YKXrnjNUBiZuuoYzbQrX6ojmCCxt/yd
         Db51GQ0tl1S9juQw2CRVUGUcNearVgTWy9gcjqYmQS2lRlOCh/JCiPzOcM2ZzA68Erdi
         UwAQ==
X-Gm-Message-State: APuU4Z8ikGAPUfd15e/nSp175VCqfQBZtMCj+ZX8DbEOKAX6oHjz/o79
	dls/3CYo5LxdDvH+aUW6wocIQ/DfHOYS/zGUILhJZYSBbbXLspg8qRb/62659tfo16HFpX8wEQo
	f6dX27K5L460Y6AeURS8qgdkFExc4osvrvNrc/FyPuirmLOLo
X-Gm-Gg: AYBFou3JVWMpE43hYAJYn6JdCvA8Oxu66IU1HvAz3YNjX7LpLk1qrUJJ+zPko5606Xg
	SrVv487AzZFsYRrU4W4b+VVVeOmpKKTs4Nm4WfKdXU8YmvbLPiv2crORuoKw2XL04F1HgbUlrMG
	Ujmc6cqgMMtEllyzowbrNcaK+jfw/n9ghLIayFuWsuFzsAQmT4xUPoo6B3pjfGJEukSz0sdV+td
	JlLlws6P94AeBn5wmvlPOYSt+vkvXOBu9Sirf54A6XFcbkHsA7oYTQp4HGoznQDufXhCU/lm1FL
	uKh9IZViNebFkFLtgj4LfKrRhbQw6vHmcIETpy8DkWadoNLOjyO0FuliZshyln+RKJ9fetPSitG
	YBfoFhnOembJRFvoVxOaOlp4LVxuulUGV2a0hX6UyrOb2eue/Uz8dbPHKRT4b+PE63UDOc/mHBq
	Q1U4w47Ij07zqzsHAT6A==
X-Received: by 2002:a05:620a:462c:b0:949:6655:1dc6 with SMTP id af79cd13be357-949995581e2mr304665185a.1.1794976149060;
        Tue, 17 Nov 2026 20:29:09 -0800 (PST)
X-Received: by 2002:a05:620a:462c:b0:949:6655:1dc6 with SMTP id af79cd13be357-949995581e2mr304662385a.1.1794976148573;
        Tue, 17 Nov 2026 20:29:08 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b743a8bsm89678085a.17.2026.11.17.20.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:29:08 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v3 0/9] userfaultfd: assorted fixes (part 1)
Date: Tue, 17 Nov 2026 23:28:40 -0500
Message-Id: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHgp/WoC/22OQQ7CIBBFr9KwFsNAA8WV9zAuaJlajLamUKJpe
 nehujDq8mX+f39m4nF06MmumMmI0Xk39AnEpiBNZ/oTUmcTE864BGCSTm1rqQ8mIG3dHT21HAC
 Qm9qWFUm124jrIbUOxxf7qT5jE7InJzrnwzA+1s0IOffWA/zqI1BGGVMgrJCVVnLfDJfpWjuzR
 TuRvBD5p+PPi5EnRym0Mgy0LJX+cizL8gQt+SI3CQEAAA==
X-Change-ID: 20261106-uffd-state-fixes-d2111e2abd48
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@suse.com>,
        =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>, Breno Leitao <leitao@debian.org>,
        =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
        Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, amd-gfx@lists.freedesktop.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794976146; l=5552;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=bXJ7iH6e45hLHohGwDiKQ9KsP+1zcP933ybsR6EgSrU=;
 b=dqh64GH8I96mPK7VNluwWf3s4AmFQRkzSpniRlUIwEYtg3kFz4EHguoBj2QLxVBG1mkCZeBug
 0LRNUk3kmaPDIqzhQnW/BSVWhwsMA7urrdIkuDWhgi5/FPZBC9tkQ3O
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-ORIG-GUID: i76egLQNuSj05a_KG6bdVFqKHpTTn5QG
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfXxC5yt5dNxhZp
 GZh255CX5FB2j6w41Uu1Ar1snH2n2FfdivwGS5n9DbbRX4Rs9LHlED2q+QpBEJUmYsbZYqXPyLi
 iQ/mxIoyRBJtZVWBZddrI0RiyqqbGjWnzqNjbd4BIdpYJ8B5Wcrv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX9plrd7d258G4
 E2CA0Rp6AuChQn1dEglw6vMmWfgTBr2zeSAdCOTd6z5YDmHT+k6ZE758UZSDannCzOIPNa19x7E
 b3eOz3EHceo6FzOZreWnkFoGmi2HDwq7G5Uym7iXGnR3Ea9vDamEXB3Aw3SX7Sy0JktkOE6ArfE
 o4WfBRdbltGsKcr51gC9KyUi8jkJUBZ+D54C4ROLf70C5vCGhxSFfMHKgvKcVMi4cS8lrHvabhv
 wnHIcDrUdfwtpx5ve6/6nWG136Dvo3DqXZ0ZTsEVKrjGt+1aq5LThXMWrE713BC4c6ztpYCF32q
 MxLHTgSSCoajU+F9SQN1BgSPAVAsvii0zDPe9QAfI27QrZ0SuOV49q4Y5yqyNhmdXJjdSZjMA5M
 uzNqSQVjY0wqJZoWrlPOB5l1hbjDHymwp0va5OL7fQkD7TXAkZDoBYtKwI/vRKSTuC7ARfHlu8n
 /N2vXa3jMOkCgrIaBtg==
X-Proofpoint-GUID: i76egLQNuSj05a_KG6bdVFqKHpTTn5QG
X-Authority-Analysis: v=2.4 cv=e7ST2qp/ c=1 sm=1 tr=0 ts=6afd2995 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=jHxIr1HyPKZ_Q5_91PL3:22
 a=bC-a23v3AAAA:8 a=28s7c6AVXC2H7J1PSfAA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11969
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=10 bulkscore=10 clxscore=1015 priorityscore=1501
 impostorscore=10 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180017
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DBAF1C0004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: egs1d46uocqayrs1ctuor8n6wapkyen3
X-HE-Tag: 1794976150-327651
X-HE-Meta: U2FsdGVkX18YOqto00utaSJJY31PZaLlLgaESOp3UY7pmbSA2PEMyhkeFKCVr/4FjsSm4H4h4Y3kTD7iKz62CwrOgo6lRvt7DjAqBHRM27AqBn6jDNoWXcIRm9GhuIwh4c5wtoq3QDL+I5ZtbC34HZ00wAMX4ycpaCk+E4lq85kVLa+OfatygxiG1DAUae6vOmjiSJnTgWAPBZrPbLNxiLhXnS09f51MJbntHQ/a/UpDkTiGD075K/6yJ/NgU9bG98MA+XwHoS5HJt6Fczejye1NDDAcTJaa30j563hBD3A+jBbRrsT6vEtCUWdM+uISX/7Uh7NiBTy34edL+igvgn9WqQ1dAWo3L5qBjvTkzTT9Pkc45P9Cm6WNftrTmjlEQ5HfW45+RJ+eLcSKIp3a6eCZ6DPfukXtu7sdj/raknb3RwPPzO47dMaivEIcB+KgpGryaLdVAKbbcRJe/u7LjJweVFbhlj7+67QyyGdnQMUa816eiMzDn7bsu3AtXPJOcfgqQaafwR6EOacSykMNuaQzB9N+W9yGhjtIlP2UYXXIMMdtGNmW7u9gi51e9UNFPrqBXs7FEaiuFAM0F0bmMxHXta+xYPrl2/PhMKo29EETf+4I3w7ZDZq29Zb596BYknaFI7VMRDJqcqb0HtEewFaLDMeBKrin7loLxfomf62kUyRBSGDqiPAnLauqclz1/GaCrWj3NM71zc1Gefg8FwzyjWUYRUVx2Mzyk17+B9qNdUwDY530IbjnFMXB/3IOdlTx8nzizmxSnKtuDm+Z0+1tY3oiiXU3XckYjJjffZ2g9ZQ6lrtNLTu793QTQ3baHz73ctqkbVDuf7ZyDq84cjFmvpmSGYq1TGrmXmj//CO+Er9W+YhXRI5qODwlw4dZNDtYbf7cQNMlY/uJ1oMtlV6mmN/pZtVv7U3fICrp+DijaHAtY5879zKt1VD2L5xwpPzPzuvp2FhOitpVNGq
 RfH6/0zX
 EVL/1Xv25dO7zA9xjZOAfhsk1hNGOETX/q4pl7JXDzI1zb8acKj9TKrl4oSxEqR4yZVK4VBfTc1+yynOeqIrEvYdL8A4tgfdty+GshEdNY+MxIyX4PTnkOt1kZ3vAlME/PfyvZ7spHVbmEhC+ALn/zTuslvcmRa/YP0glDq/+z5rzZag85pfa1pJ1LCpFXCz51jTR186KrFur7Hoy3LQoTGnNkUbnT/c2WpFGQ8GWZGtgpuqjqkGLWccyjoyhy6bVzhkkkoWWCieWn8iNkjSaQ7HBJQ2MatYGArFrwB4zdFxJLjXZZFSmEuC1iDVhCQiCRWHgoyo0YSAjwRxDJYQE+/85YUVqFZLZMvDgxg6K/sfabZ+mpvbdrHr5qeaVNi3GioiP/xQj32Jsj23G++27Fp3auI/v0+B35ZLz9n4MDtO5bn9cIJgzyxumXE1xotubSCvSCcGlkXslbmrtEmJ94G2mL1ojFCVkcSOGu8WoFxShpgkh20faJB4Qw8iDf+hr1HvXQtW1e2NrziA6SqnRD6op+wai6vDHi4b+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is a first batch of userfaultfd fixes, with more to come.

These were found by a mix of regular old LLM review and by having an LLM
write a TLA+ model of uffd interactions with PTE bits and other state
and seeing what issues fell out.

Most of these fix places where mm code loses uffd-wp or RWP protection
while moving or migrating an entry. Userspace then either misses writes
and accesses, or gets pages reported that nobody touched.
There is also a hang in UFFDIO_MOVE, and UFFDIO_ZEROPAGE modifying a
file through a private mapping.

Patches 1-2:   UFFDIO_ZEROPAGE and UFFDIO_MOVE fixes, cc stable
Patch 3:       PAGEMAP_SCAN write-protect vs. writable migration
               entries, cc stable
Patch 4:       warn on a writable migration entry with the uffd bit set
Patch 5:       PAGEMAP_SCAN write-protect vs. device-private THPs
Patch 6:       UFFDIO_MOVE of the huge zero page from an RWP source
Patch 7:       mremap() losing uffd state when a move fails halfway
Patch 8:       migrate_vma losing uffd state of a zero page
Patch 9:       hugetlb alignment checks in UFFDIO_REGISTER and
               UFFDIO_UNREGISTER

A few of the fixes change what userspace sees:

 - UFFDIO_ZEROPAGE on a private file mapping no longer fails with
   -EEXIST where the file already has a page, on an mm that cannot use
   the zero page (patch 1)
 - UFFDIO_MOVE returns -EEXIST for any huge destination PMD, not only
   for a present THP (patch 2)
 - UFFDIO_UNREGISTER with a misaligned hugetlb end fails before
   unregistering anything, also if that hugetlb VMA is not registered
   (patch 9)
 - UFFDIO_REGISTER and UFFDIO_UNREGISTER accept a misaligned start that
   lies in a gap before the first hugetlb VMA of the range (patch 9)
 - UFFDIO_REGISTER returns -EINVAL rather than -EPERM for a misaligned
   end in a hugetlb VMA without VM_MAYWRITE (patch 9)

Patch 6 has little user impact on its own. It is included because,
together with patch 7, it allows removing clear_uffd_wp_pmd().

Patch 7 adds spurious write faults on shmem and hugetlb after mremap():
when dropping uffd protection there, change_protection() makes writable
pages that were never protected read-only. UFFDIO_UNREGISTER and
UFFDIO_WRITEPROTECT already behave this way and lead to the same
spurious faults. This will be fixed in change_protection() in a separate
series.

Based on mm-new.

---
Changes in v3:
- Collect tags (Thanks David!)
- Patch 1: use vma_is_cow_mapping(), per David
- Patch 4: warn on a writable migration entry with the uffd bit set, and
  make the PMD path match the PTE path, per David.
- Patch 4: Drop the Fixes: tag and the review tags due to changes
- Patch 8: add helpers and read the PMD once with pmdp_get(), per
  David
- Patch 9: move the hugetlb alignment checks into a helper and use it in
  both ioctls, per David
- Link to v2: https://patch.msgid.link/20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu

Changes in v2:
- Collect tags (Thanks Kiryl, Lorenzo, Gregory, Alistair!)
- Patch 2: say "softleaf entry" in the commit message, per Lorenzo
- Patch 3: add softleaf_is_writable() and softleaf_mkreadable() to
  leafops.h and rename the helpers to say softleaf, per Lorenzo
- Patch 3: add Reported-by and Closes for Breno's report, and cc stable
- Patch 4: explain in the commit message how PAGEMAP_SCAN set the uffd
  bit on writable migration entries, per Lorenzo
- Patch 5: use pmd_is_valid_softleaf() rather than open-coding it, per
  Lorenzo
- Patch 7: say "write faults" rather than "minor faults" in the commit
  message, per Kiryl
- Patch 7: trim the commit message, per Lorenzo and Gregory
- Patch 8: trim the commit message, per Gregory
- Patch 8: Cc the GPU driver maintainers and lists, per Gregory and
  Alistair
- Patch 9: use IS_ALIGNED() and a local variable for the VMA's ctx, and
  shorten the comment, per Lorenzo
- Drop the three guard region patches, per Lorenzo
- Link to v1: https://patch.msgid.link/20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu

---
Tal Zussman (9):
      userfaultfd: use anonymous memory for UFFDIO_ZEROPAGE on private file mappings
      userfaultfd: refuse UFFDIO_MOVE into a non-present huge destination PMD
      fs/proc/task_mmu: downgrade writable migration entries in PAGEMAP_SCAN write-protect
      mm/migrate: warn on a writable migration entry with the uffd bit set
      fs/proc/task_mmu: write-protect device-private THPs in PAGEMAP_SCAN
      mm/huge_memory: build the moved huge zero PMD from the destination VMA
      mm/mremap: resolve uffd state when the context is dropped, not during the move
      mm/migrate_device: do not migrate a uffd-protected zero page
      mm/userfaultfd: check the hugetlb alignment of every VMA in the pre-scan

 fs/proc/task_mmu.c            |  42 ++++++++++++++--
 include/linux/leafops.h       |  51 +++++++++++++++++++
 include/linux/userfaultfd_k.h |  24 +++++++++
 mm/huge_memory.c              |  38 +++-----------
 mm/hugetlb.c                  |  27 +---------
 mm/migrate.c                  |   7 ++-
 mm/migrate_device.c           |  34 ++++++++++---
 mm/mremap.c                   |  46 +----------------
 mm/userfaultfd.c              | 112 ++++++++++++++++--------------------------
 9 files changed, 195 insertions(+), 186 deletions(-)
---
base-commit: 25fee5b1762b8799dd8b72c2f6d666eb01680cc7
change-id: 20261106-uffd-state-fixes-d2111e2abd48

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


