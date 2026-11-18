Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49A03606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=IhyowP8W;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=XspdH3+7
Received: by kanga.kvack.org (Postfix)
	id 9B8686B05B7; Tue, 17 Nov 2026 23:29:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98F9F6B05B8; Tue, 17 Nov 2026 23:29:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E896B05B9; Tue, 17 Nov 2026 23:29:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3226B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:19 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C16E8C061C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:18 +0000 (UTC)
X-FDA: 85446960396.28.D8B79AA
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5298A40005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=IhyowP8W;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=XspdH3+7;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794976156;
	b=flhFYiyjprADn2hQB2GsTPVOdZcw9sMXZXYMvCDDPRwALx4uCK4S0vZPAaQ2KPs7/mSM2G
	EydtWAab2yZKXTE7AccG6qo4BjqD0pVzxSA3EaEt9DbThBpDyoFEN9tFVRSaet9C6MfDLA
	FpNgKEfv8MJF1DPOISaYEzt16W6KibM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=IhyowP8W;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=XspdH3+7;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794976156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDdKei2vMEAeXLILC50Im1ZDZfx8CAWqdgs4l23ZWvU=;
	b=ewxxlZcSyXfPAwqiB+DpTCfcagDfwv1/y7rdaE+8swpL+x+iod61bAlQZ8PClwPXeX0Nn9
	+pd++Y2+JiaOxWbYU4iQTXGRKxAwwmdiEsx4L7l261edUHN5GF+u9OdhFbeicLTG2zbYmZ
	mD8foZ8f40x5dNEe0uF6mZPGcXmhiNQ=
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI1XUgU2951637
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=zDdK
	ei2vMEAeXLILC50Im1ZDZfx8CAWqdgs4l23ZWvU=; b=IhyowP8WjhewUHW8kP1w
	6j0tcSqtPM8vC2Cj5KBA7d77bsmlffEPsKJQC6zFhGIrApcn9DJS8tyJANelTpow
	hj91jIPmLHO2iAhHswNyqVqzb51t+CyA6VEq3XSyZuNgNspymfxqup/lMdMkkNxU
	NH0MOXW2OWhalTUqMcK8UWIwPzknWnbIZujsabmgAfmMetEZGodmQ6ed08hcg2//
	MFrYcaGBD9iuSwEePvRhxNIUdk+lTJ+iTsSN1Qd6ZYJHjG0E+qbFs6P3+ztx/wym
	VUXWnM7xNr7Wzy+7CziaYbd8HcMv6s4avpd2/cynD2Ube4udXBQp1bja69/uHKzq
	rA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j0yu5sfbp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:15 -0500 (EST)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-94961511b61so123798485a.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794976155; x=1795580955; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zDdKei2vMEAeXLILC50Im1ZDZfx8CAWqdgs4l23ZWvU=;
        b=XspdH3+7vMdlCa6jLnG1iu9qnC7aJyIbsYfcUAkla27wcwj2fwV2Ke68xV0bBvUSSL
         OgXRHmH08o7TdTAmObzg7lbCZoQ8DveV/t0ubN/0UZqOCD3hWsnr1JMLtx+WUHQqPL86
         441GgGU6nUWzLvUBCr/9vM7IIIW8MklMbOYR5J0oFG3swzRjVr1oyb6gSqosq+vzC0aa
         m2bwC45h0Wsbw3tZOCBejY7j1r42NDWm8aeGU2/RoB035gFEA0mS+4mGPh6YGeDQNK4v
         Ufnw5hex4/KXLMlMeNBJ7Jo4MVoxg/PNqNk4yUbzc1SMQl4sphwrHpcvITAdpi4T/bGz
         TgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794976155; x=1795580955;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zDdKei2vMEAeXLILC50Im1ZDZfx8CAWqdgs4l23ZWvU=;
        b=CYeZdrdf1gWtFaqplZDb0QmOzEbDdXr6jxR7RzGZGKsF18S9qfoP5+hO6vIRoOyWiH
         BgCyfXxXbbNCkVpE3Il4Ao3nuL3Ojx76lB6ORlDATmVY9PC0fAtQZQ+baHb/b6XrRRAD
         QNjL15+sfRhwwceKnPGgsPiRxtW8iRCV5gWtSsUV0anBni7X0Oy6kj+3s00CcWctsv6F
         NHpuQWmQPc0UnE5U5OvbXf8Ny5/NwUeYKeECa9GFxkr7NJnMAmG+lUDy9JxIHX/dsxYV
         oeXKWF8MS54VCJz0bN+XjFes4g/O6/Fvs+dAkoj0i806llIGemFxkap3VRJnKM9fIndr
         R7Fw==
X-Gm-Message-State: APuU4Z/8OTowHVMtVnHM/6eCdBOnTbivDGPMuNppuBgX+LTSVLL5eIc1
	hVs0uK57f+6WdmCIKVilHwTfkTvR1VqBGk/wn/jJUfoNQDNp4Pew4hxtk7vV73KTmYHkpTMJGoo
	xsefVdOzRtGZSQ0zlUdd2kiNWPyUUvMmyLNPSIovJCUoFga0z
X-Gm-Gg: AYBFou36s/FX3JrLf1iKYDaBfKhTwBn7w6kw1D5qas2b+Luy5NPBQeiVK6/EArslqSN
	FJkmGK1DwSapkc7yvQ4foaFvFzFLgFnjc4pFIAhfUQQUHqn5jFG+MZft/cTOBpWmVZ4h0CqOCCp
	GlGVDxxrDo3g4jAbga1qv1Wh/4Q0LNC3QDD2zfcYk8q0sxK1Vew6GUqHVvtl7XOIf3BWs8UzhTL
	WPvFq6WP00JSNEaIkXR9ITVZEEN4jN98jQ1AHnoDI/DVYlaAWcy9yTuqomXXJ05sUEyB7Wwzl0t
	FVI3W0AiiCWZczz66j5nlT5Vme96XlbLToVb67BjxihortJT6BJwlQT50t0h7wl967GqpQuUwDe
	D3/d0+py+9DAUCvkqrrh3g95LdsVzxRcaC3VIhlyARianQ+J4j8A01PCIzOkEV2c1WQZoO/ghB4
	1eWFjfxRwj2dOi/K++Lw==
X-Received: by 2002:a05:620a:6cc5:b0:939:6dea:4f1b with SMTP id af79cd13be357-949997683b6mr310409185a.49.1794976154761;
        Tue, 17 Nov 2026 20:29:14 -0800 (PST)
X-Received: by 2002:a05:620a:6cc5:b0:939:6dea:4f1b with SMTP id af79cd13be357-949997683b6mr310403485a.49.1794976154331;
        Tue, 17 Nov 2026 20:29:14 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b743a8bsm89678085a.17.2026.11.17.20.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:29:13 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 17 Nov 2026 23:28:44 -0500
Subject: [PATCH v3 4/9] mm/migrate: warn on a writable migration entry with
 the uffd bit set
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-state-fixes-v3-4-b617009d1a4a@columbia.edu>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
In-Reply-To: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
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
        linux-fsdevel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794976146; l=2256;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=iVphMSJ7Urh2fIXcYVatrMOzIkJtjyML23OJSADW9gA=;
 b=ufH6wJASUrwLe+a2SyLTMf7lQHuEBbZ7mTnTLAFziy7DuvjbLfMCP59gSJiwfXv3bKRlnt5EK
 RqrfDVkmiExBSNfYuxADHn5NDFZ2h9wOlHN/h1lWWBjjh5ZZDmfFBMS
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Ir6L47/g c=1 sm=1 tr=0 ts=6afd299b cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=Le39LiMa9jTJABa3:21 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10
 a=A0y_DWxS2BwA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22
 a=QOCMdifcju39GKoXhKua:22 a=LFElCxfDvO3_aldaUb0A:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: 7ady77qhpCiyP9fXBjyAqVtO8MQ4Hfwk
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX+t3uTkwMYTvJ
 vRxBukt0k8QzDvJzAVVZ9Qd9OwS+4ca4tALNGX883PKsH2/yzRajYG65FcL3xvCU8/QCRWg8V6A
 gXvgMv9K1G/DmwEGIa+8RxyEqsqjbLRS6doi/j+JAkIWRmv40gtb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfXwwpyE9pqKjUD
 6Bynalj28FX9Rm5JEeNx9Dsfcnhc9pZhTt/GgR4jBOHeM60nCbn8WVGvpE81/SjtmICfKHbzbsT
 58YGtEDHl/gROI9juOAaQWeCXK8ZXHmZeDAMxysEFISWdBIIbRgSxJI3Ar8dTFLYnBqNG1ET+Ly
 v+n44Xi2VQp8sSJ75cqAWw/hBvIC863JxmRIsX8L1boSO/cxHUDSRarT/X+FS6ivMLYz6iYTkwI
 /pgDyMW/ihrAahGhUTMbVaU3/ITqER5yANNO1yNFfpX66Mp+0mtBXb2lQ+eXSar5M24UZ1zb6GW
 P7tcaOz4cSuwXin5mbWVoHsQIPpXutH7OSlgrZY9ffvtTktW+scdG2Wm+xu5Knm5u4OCiH5F/fT
 db0vZsrbkdOPw8EXMMdp49YwsagE6oAb5f9NwiNnhIpJdJmn0ru8C9HsunQyUGUDYhTRkTt4+uS
 /uGZ9pBBqzhdK/aHZ+Q==
X-Proofpoint-GUID: 7ady77qhpCiyP9fXBjyAqVtO8MQ4Hfwk
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11969
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 lowpriorityscore=10
 malwarescore=0 clxscore=1015 suspectscore=0 impostorscore=10 bulkscore=10
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611180017
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5298A40005
X-Stat-Signature: 3fdn76juua3gpwxs8p55uf3rznzjzhzo
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794976156-572493
X-HE-Meta: U2FsdGVkX1/OKEvgzhC6omgPAfL5Jszbjk6HQENj4CxL6PvTe7S8LlgwCb0WCKl3urSIDdFqXWCDbzSxfc0LcIIh1kU0ytx2S/n4eru8CpJVKzgJOsQ66TavCjWXzVwkovs8au0eN4NyBptYFip2m9+Regk7ztr4FQgjKwGVPCAGHltUNr4hkzBSJr1YscL58kB0tQyNd4B/sPZ9940ZtbzdXC9FtaVqtM8Ek5QzssdwTTt7zJ8aMc5SsbMNlwDU6nSx+LcWBDU2ZWAfqH0BytiMyz3cEuVd5onr4AD+e8Rzl5QyEr7KG+rcPomRTIwbMsNao+yClGPXlq7YIfYlJsReTFieWJn8I7PB94PhoF9coOpnG+yzc0NKX83FGUla+xneVEX74BV2KZrjEmlIabKXZQLW0J1BLVZLoYBnW9lqPRhSt8tzEoullY+L/9RUPjYI5ATC9SYOjOc5mMkCyMgqVLypjCvR2YFmKhxQeMmQcsfc/PXvdIQqFXOEKlXPROqRVNs8n2V1bNTbXK3fHS7bZpO1/yQgbbdvQ93i6/285V7i+1cdLMjnzS91nh9K1E2iTIOJ6LStjqRoObTYj3+xubJbLFzQhz4UDypiKD+syQkn8wAwxbQtrVEUcMgHXNBu+tsLs3pckGO9aLxAsn5HAnSUsEwW5y9R4qtD8nb1xH9ZMpLiom2i4xzq8rXkZ635ejZ7JeT/TUPygonrG5ynUytbiyXp6X2vnFX91BDlqWOzG0npfHmcOfwUphjyTPecBmcmUZc+VMlwDSJMnWdZDxe+xi6OvYW4cGDMxMvaCRG9/AAI1bWteE5CSnK7YZC0TDvUWnWH3nLmM+WKcdNYDc2imM03+vecAizzEZbV7tjBEICMN1mI5e5PJDVnyItiByraO/6vV/YRAmWXWmAtsn04Ut3bbPZQ3AInp4l/19fVYtIe5i4Xr0p71qysY31/ZQNKHkBHsonfkfw
 GFhGPoBB
 qbkGoBRE2LmtGWCV3TIHXokzBe0DZr5Hzm97DJ1XPPeohYh5Z9uIEOOndQs+NNh+bYjKa4K9/+Wqr+7CtrR4sk6E/7FEpzmbNdiHAFvEdZqcc9Lv3GI3lM74aj05dI+9Yrn8XOuq8VThDBVwLybhJGji03JSCwbpOGe4du3+B6OeYhY9p9EE98RHA95AXTtUuyq9+HPrYmLdhdZzv0F6gcVIm2thYEjC3vkMHYft4eVuuqmCkyYReSpXCgSrloXm6b1nZow6+XKDUxbe6nb0nWiY/Q1bSCnXFpTb52ktGiA0tUoOHkv6UmhsTgPCde1xpITPl4P/9Jmj9Sq5yjrcIGy5irlrIS9LJ1+g1jjVHUDaRGXOn7HCKrAM3KWD7lPnR9JeDEw6Qk/QEC9o7nT6Xpjugd8y2CXcSBPTERxXzzPDF9La9c0qqWtCyAp1/rJpBoPfYVQhPlaNNNR/BkTbN4vJPZ/DuH+jWPncOFHUbI83NRrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A writable migration entry must not have the uffd bit set. Every path
that sets the bit on a migration entry makes the entry read-only first.
PAGEMAP_SCAN was the one path that did not, and it now does as well.

remove_migration_pte() restores such an entry writable and drops the
uffd bit, while remove_migration_pmd() sets the bit and write-protects
the PMD.

Warn in both paths on a writable entry with the uffd bit set. Also make
the PMD path only set the uffd bit for a read-only entry, like the PTE
path, so that the two behave the same, as this should never happen.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/huge_memory.c | 7 +++++--
 mm/migrate.c     | 7 +++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0d589be136d2..4a4e187ae3b1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -5225,10 +5225,13 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct folio *folio
 
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
-	if (softleaf_is_migration_write(entry))
+	if (softleaf_is_migration_write(entry)) {
+		/* Setting the uffd bit must make the entry read-only. */
+		VM_WARN_ON_ONCE(pmd_swp_uffd(*pvmw->pmd));
 		pmde = pmd_mkwrite(pmde, vma);
-	if (pmd_swp_uffd(*pvmw->pmd))
+	} else if (pmd_swp_uffd(*pvmw->pmd)) {
 		pmde = pmd_mkuffd(pmde);
+	}
 
 	/* See do_swap_page(): restore PAGE_NONE for RWP */
 	if (pmd_swp_uffd(*pvmw->pmd) && userfaultfd_rwp(vma))
diff --git a/mm/migrate.c b/mm/migrate.c
index 28a8d7734735..c5b0f57343ab 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -397,10 +397,13 @@ static bool remove_migration_pte(struct folio *folio,
 		else
 			pte = pte_clear_soft_dirty(pte);
 
-		if (softleaf_is_migration_write(entry))
+		if (softleaf_is_migration_write(entry)) {
+			/* Setting the uffd bit must make the entry read-only. */
+			VM_WARN_ON_ONCE(pte_swp_uffd(old_pte));
 			pte = pte_mkwrite(pte, vma);
-		else if (pte_swp_uffd(old_pte))
+		} else if (pte_swp_uffd(old_pte)) {
 			pte = pte_mkuffd(pte);
+		}
 
 		/* See do_swap_page(): restore PAGE_NONE for RWP */
 		if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))

-- 
2.39.5


