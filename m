Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C365460A3822
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=e6VbgxFx;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=Vdqd5UFD
Received: by kanga.kvack.org (Postfix)
	id 3EC006B05B3; Tue, 17 Nov 2026 23:29:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2E56B05B5; Tue, 17 Nov 2026 23:29:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28A966B05B6; Tue, 17 Nov 2026 23:29:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD5126B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36E43A82FF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:16 +0000 (UTC)
X-FDA: 85446960312.19.D753F7D
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id BCFC640009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=e6VbgxFx;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Vdqd5UFD;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794976153;
	b=74JfPh2RVXa6jpBqMOEV0QRlcCE5TqX3OODa7Z/gTDUTxlNq/PG5TFlc0d5VDV+/1+amCd
	rslydkG4MOMrfP8V1Wun5FjeFQdvxPf1QVkGJ9xyvGA7YI/nWDXafpcbvDEugPtQa7gMC6
	+EXkf0oAmCUorWIW0u6Ia15CaImYZVA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=e6VbgxFx;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Vdqd5UFD;
	spf=pass (imf27.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794976153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHyaJQrkTMphdYzmc+rshzaiZTp40YbulP0xbtW1OI8=;
	b=I6ohJ4Dlng7p5YoDyDNQh4XH0vpuUVDr4IAfIWR3bOnXrNS6nTWLL5IEwkBZWdIIM6RGvI
	iMv/v7el/e0BrX6MC41QUahydNDCrEKRWKAx7d0XrjWnJgN5W8D1Nphspz135jDk+JaxkM
	C48wGl9ya5kmT034JTCFu6pJySQbl9g=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI1XpFA465991
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=PHya
	JQrkTMphdYzmc+rshzaiZTp40YbulP0xbtW1OI8=; b=e6VbgxFxU5xDgnwjTkyK
	mwCjKCZI4ZsVkmuD7cqvdFDXWAgu4q5AjhaA4EJICcEKHypx6gTHmbMUVg/gLv0D
	Hg7x50aBkgdQGzBDP2O+KxmDhN2DhFLrcjqYparniyVSi5bZtKD/Grx57h759o3K
	GdAVvgPrB6+38IDtfj8ErFkeYRn2XRH30u5vhZV5IFmlPT078iKuOuFJ89DcXwNF
	/C4Gst59vVkKp3UiIhxTCAsVctl651ffqcG7h34RnVHg+32iyW7bZCCM31FjmyBW
	Gtdaj9h+qqfYMfG8nWwMP8Bv+PS569l7RtMcisTZyz85UMKILg7UVn3K5qKBMrDL
	lQ==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j0yu61g54-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:12 -0500 (EST)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-947a607ec40so65931485a.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794976152; x=1795580952; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PHyaJQrkTMphdYzmc+rshzaiZTp40YbulP0xbtW1OI8=;
        b=Vdqd5UFDQnwFrkaeQhDfltyPCv31M6Ck/DUPW+Jmw2gXMfugZn2of+jTWNPOQyZKCe
         DF9DIl6W5Ibykykq6jHk3j8Pew2bkcEKOzX5+E9vx1URRHD6NaLksVj9H50rdnsAREQO
         knvwWBdj+tYfCA/pV6dAbHIL4YhTTH49b6cGB0lBQJ8auNym3GqNbP2HOpmVtzFtX/NL
         T6r4nVQzuuod4j2L3anbhzXBidlwq6qqHI4TgppR1mdIDT329mb9PYymdcbHD2umbkot
         6T1BnpRFXwww+6Jrkb78YRT7CDctKgrFV8cJolMF0U8Lv1wG9xRSf9PRljxyoYQuDODL
         DWsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794976152; x=1795580952;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PHyaJQrkTMphdYzmc+rshzaiZTp40YbulP0xbtW1OI8=;
        b=EqKTAje0fXRQXsIAYXIEtZAtqwAvjNhuoIOvKiy4s1oxdAbQjszkaN0iaHfJSM47tZ
         s/mEqosyaI2CUOjZTiRNjzqxEfCt1+NdpEOt/lLRecJMac1NwddKIw2zsFkrj9XY95bD
         vOWSc0B+f5oabLcLPbfF9cHvKkkuiJ79JEV63qQ8kvSApYjE7iy17YX+DURYTImOeKJH
         ZWGDmji9zS1/QR3CnpiGMhgdEcP7VmTWBKiznrwgdElmNpHcZ55kPHKiKRXxgYRQGmJJ
         RFXjWUYJJVXjrVfpeSWo0lgtWku9zCfQVmlTPuA+1rxMB09PmP0Qhhz+3s9c1EQ5ghLs
         01PQ==
X-Gm-Message-State: APuU4Z8KdqlJ9M2dbw+ULmQGDFEonfbzT5bM68+l4byCvPaV9SPkl91m
	MfCIDPd0+sTLU4whkx5u0ia1F5AG3sEZa1wShvRLXulr1xXjbZGw1fQGJdvhSOGzF8qmt5tb877
	im2YT2PQ57KNykUFC8u1GcxHHA/y4Cso3u5qNWZNhw2jWhkFq
X-Gm-Gg: AYBFou13RCCqej59/53GaPgloD9BEJ4swVz6rb2gbKgxM5VzP145U1QEniyMD+d5C18
	ra9ZdkoXhcXO/h7yt/QJVnwvLyJ2jybBNXsFO4OVl0V8oEVHSsGcigtToB1XwVhldepf1/j0ya9
	Z38HWRHLggELmJXVV90NK37oZ7ZsoBovHLA+Ws8HGlvzXqHiIV/OfdQMNLZuFNnATcNgGGT2Oe3
	k/kRmeHoQnu/rChJpgpAIM/IjW3Vrig2cnpUDETN+5vzaBIVmDjTzgLkcjZDHdkzPldfRq1uxfQ
	7ecv8Q0+G64aE7trS/1aUSI7kHKeKa8v2MwzUuaPqjdipRGM1dD5PdTncBSMphlMyJQlxyH6Ocu
	qtIpQO4GSFfadkdj3XuSgO16SEYEcMDWV58nev2DA96UZIWkM74SwY7/upO1qWbBCJxz1y4UZ3j
	1j+9qJ01VKMOJYBR5LlQ==
X-Received: by 2002:a05:620a:460b:b0:949:7781:6a2a with SMTP id af79cd13be357-9499963337bmr333454585a.63.1794976152024;
        Tue, 17 Nov 2026 20:29:12 -0800 (PST)
X-Received: by 2002:a05:620a:460b:b0:949:7781:6a2a with SMTP id af79cd13be357-9499963337bmr333450685a.63.1794976151524;
        Tue, 17 Nov 2026 20:29:11 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b743a8bsm89678085a.17.2026.11.17.20.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:29:11 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 17 Nov 2026 23:28:42 -0500
Subject: [PATCH v3 2/9] userfaultfd: refuse UFFDIO_MOVE into a non-present
 huge destination PMD
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-state-fixes-v3-2-b617009d1a4a@columbia.edu>
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
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794976146; l=2698;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=K0o38pzaMy6QRMMEYRQIJRke0A/nk0J4G+lixSN+sNs=;
 b=340uovLCj4ITRL89ZbsJjjWvkIqBwYm45eDArEoJS/iGZuCtoRxnsfUX1Y97twSamX4VEReXZ
 wqarjnM1+4PBdX8UCgZ5F+jzKyJeOHcxUfjhSKWfMjTuYQYnGIpzg6A
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=NItAaE6g c=1 sm=1 tr=0 ts=6afd2998 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=VwQbUJbxAAAA:8 a=tHa68p0SAAAA:8 a=n7zxJ9EK30Z5vFJJ7y0A:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfXyLAqvcf7vH2f
 sD82fQVbYXo5kanLoA6Jgnt/QOjcIQ1U6gYKIW/HQYDltq3sjNegRMcFF3iknmRztbHpsJzN2r0
 bOxo8X0ngvs0myhb+x3lgwoRbIfEPCs0C1p4spQpxEsQy6yBMRZg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX9jJX2OrZD+vK
 lHoLdxD8yz7k6iH1Ut0BxQrGa21cLJJCZzryiRFXF2QiK6rFkxE3O9u6ZcrFRrE2BRn5MWJtSmd
 2baqIyWbBNXwe00PfOLHaPBRtx7r/RM5mmWnLM6L9fWXjq3jhdfjoAW63fv+nmtQBLKS/sYIY0a
 GExJbrFcC44MRcjw1/7adGCUs65r2FN595Y4HL+zysGxaR1toHURME/T9pL8vmW6oik5oq6grJG
 k2OP7xDS5XxMYo+Vd8m1StgyLXqMZlI8bFKWhh0vH6ASD/tslzp6g/pJ8WNZLWRtPhkHYiKdW9w
 /z0keKlIrmrpJasXj4eBiT2J6AGr0eScljE7/99KSKwm9if6J6soHY39sknReo29vDdFOOtrqLO
 HFmPEHwBrJgFQenYG6b6+tvyPuqDxeB1qZ7miXP1iSLtCn3f7vLTSYFCwsA1aIvN2XTEJXSNiL5
 Qj6XMmYqFG54ka02yBg==
X-Proofpoint-GUID: A38BE0RV8_SG-W5o2UoVYh3ZQK_BJInl
X-Proofpoint-ORIG-GUID: A38BE0RV8_SG-W5o2UoVYh3ZQK_BJInl
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11969
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 malwarescore=0 phishscore=0 spamscore=0 lowpriorityscore=10
 clxscore=1015 priorityscore=1501 impostorscore=10 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180017
X-Rspam-User: 
X-Rspamd-Queue-Id: BCFC640009
X-Stat-Signature: gqmepnuf8kak9j9trsx58c9fwu3jhrdf
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794976153-413472
X-HE-Meta: U2FsdGVkX18KMjhLESNacGCPg34zjYOeLc28kRxjocEQLz7TukKrg9vFMjB0ypMR+5nyyQz+zl3EoECArwrB6ZbYO0icc9JntqbWCwOG+rbbcuZoatiJOsDq5ES8AZwGUFfykIxs1Z4Mq/XeU1bqAf9VjkCdDJsaU7KlcxVdAoBHlv5hwTMGe/aAiUwIgqDHmsCYU0GQ7Zhe4G2bmOa0+vfnjiMdGiL+rdGmw6rRpgjusLKLkNm1BzJF/ZCcgxQM7zMN5ej1etmYg1nCVuv4YIZnh0MlEzrM8xns+N3VYNgyJQ2rufM/vRidpL/9MDSjrvmyWCMD2Gxs9f//M/uPL2U9EYwCM5eofVtUdqRRl0uM1KN1FDdCXifDSxacB8d2DgVETtmcC2hBHURVfxicIUOUcOMl0IekhmsRxE8WU109NmzBR1A+wgvbXDpu5DzUQ4SoU1UkPwTt+I/lATG/eP4rP3hTvZVj7Qg6n5sd2yk4zj8WIG8VBEGFwDcTeKFpBcLIf6VFdB5Mwr10V6K6Wizj63TAF1l2OSibIJajmKIO/fvLmrU+UbvrTp8ZU5U9U8kTGJCH4QbYrQogTvmJKWDRelBcmp8viTrnHMMbZxs5ltEVdax8hJDeSJz7VGMAMJVsqThzIbRP3afiNMzLybimUBWRJo1atpsEjnc4JccGpJMvVtVlUtZ5TJCaiLeai3zg2E85lUVugqjIVqN3ZbZBD/+Kt1nXvPxlLfcKwgW94NcEDAor3MNIBKlaGpQivezL6Ony7F6f4NDukfM9WhKd8b+S6Uf/l8/LtxQAQz/u7HXTs6vXMKfm3GTWfmAy1SI1aKMVaM4m7GkqS37sI5GxcOfMvosDorlPkbhWNarptH7qjT99EQeMO/7jBPGyRtYXatsUB/4XM9XE22bzDOdPxyhFM4X2tyslHxrcZ3vNSujln3001Ybge02EUolzqebXXmw56H9KzhdPUOX
 zzNM7Cjf
 DcJOg+TphmV8jmEEXXEEFiFUaYKjvgTkB8MgtVWPyaZRNCCMXtc1AlqeyZydp+JJoeGyFhEe7ly3quW/WqmJXmqJ+EnCKpgE/AaSHDgJuy9KSLCyQ0QcXB8nJpmeFgLMm0qWK6lwHZT8rQ+P5zVa1OIZQ71I5klS8xoseYoQllQmosk/3Cb0/fez5iihdj11kfeC53X5gpW/yd0JAD9eQ3Nvpz2+LqB3mh+ENMcgYQfzmbQGMcM5f710QPqpG5/IuLzP0KXV5QgHF16JoivUkDKpJAUH0uxhP0rRGU6N0OpTvPij38VRcHp7NjYlddeVymIn8wetRv4wjEnJWW24EghLB3LBkNuD8CKLOylpYlEHNlgEIYIYOOdAQLRCPRGhAVdVc8PB9we5Xw2PG7rXF5I6l1nJiqWWniaapd/dCf8ss7M3kezsF33EWjFIqI662G3lWtcSw7jCfUNBA46fSWmosowl7yNVQSX7w4XQbD1D5VhFAvK6IiKYFHx47ikMpFzSJ4c9zZQwhK1sTup9MJ4MSrI/XLYppFlTXn7ghG7E7Q4p3WjUcPlzqGGumCkU9lNy5EDpZdAXAswk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_pages() refuses to move into a destination PMD that already maps a
THP, but checks for that with pmd_trans_huge(), which is only true for a
present THP. A device-private THP or a THP under migration is a PMD
softleaf entry and is not refused.

The destination PMD is then treated as if it pointed to a PTE table. It
is not empty, so pte_alloc() leaves it alone, and move_pages_ptes()
fails to map a PTE table from it and returns -EAGAIN. move_pages()
retries on -EAGAIN, with both VMA read locks held. If the source is a
THP, it is split first for nothing.

For a THP under migration, the loop ends once the migration finishes.
A device-private THP can remain in device memory indefinitely, so the
caller of UFFDIO_MOVE hangs until it receives a fatal signal, and
anything in the mm that needs to write-lock one of the VMAs blocks along
with it. This requires a driver that migrates THPs to device memory.

To fix it, check the destination with pmd_is_huge(), which is true for
a present THP and for a PMD softleaf entry. UFFDIO_MOVE now fails with
-EEXIST in these cases, as it already does for a present THP.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/userfaultfd.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e787e9a3ea29..0435ceafe750 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2021,12 +2021,13 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 
 		dst_pmdval = pmdp_get_lockless(dst_pmd);
 		/*
-		 * If the dst_pmd is mapped as THP don't override it and just
-		 * be strict. If dst_pmd changes into TPH after this check, the
-		 * move_pages_huge_pmd() will detect the change and retry
-		 * while move_pages_pte() will detect the change and fail.
+		 * If the dst_pmd is a huge leaf, present or not, don't
+		 * override it and just be strict. If dst_pmd changes into a
+		 * leaf after this check, move_pages_huge_pmd() will detect the
+		 * change and retry while move_pages_ptes() will fail to map
+		 * the PTE table and the next iteration will see the leaf.
 		 */
-		if (unlikely(pmd_trans_huge(dst_pmdval))) {
+		if (unlikely(pmd_is_huge(dst_pmdval))) {
 			err = -EEXIST;
 			break;
 		}

-- 
2.39.5


