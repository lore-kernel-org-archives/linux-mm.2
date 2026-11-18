Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9335606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=Z2b5fLvD;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=Yh9n7dPI
Received: by kanga.kvack.org (Postfix)
	id 6D3C06B05BB; Tue, 17 Nov 2026 23:29:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF1A6B05BE; Tue, 17 Nov 2026 23:29:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48D9A6B05BB; Tue, 17 Nov 2026 23:29:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17B546B05BB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A3E54063F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:21 +0000 (UTC)
X-FDA: 85446960522.04.51973D5
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id F0AD21C0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Z2b5fLvD;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Yh9n7dPI;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794976159;
	b=QCsjagokxO86zu8KXYA1yTd9pB4D7RtvNTpQe4Lx12oz+OX8T2if9TJNlPTTOEej64+lXR
	tn3uQSAUq+46FBlFABtBmErOi9NmD0UnuEBPZ2R/2oJywP/wX+Uhx9U5z9MHXOsXyVzMo1
	7yxXdJKg6Ed63Vo5SX2vhtQSSCX47AE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Z2b5fLvD;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Yh9n7dPI;
	spf=pass (imf21.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794976159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rc5CZiGD7tyh48F4lxL78ysIlC6P7Il9CJaGLWhqpm8=;
	b=GvZ7XoNiFWkzfOJCuV9uIjGPC1595q93z6gZ8RWjcCH6OZxO6ZQkQMxAOMOubbmBqXCD9L
	bDhA63Jf/hMMBF82PZ1mh/9UvbBDE1m0DJEG/UmOsg3W0t85h5ZU0XcRiDtxn/yZfc+xW3
	UrcMkuEgfwMVrHrkfwtrQnLBrc7P7U8=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI1XZGH3627310
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=rc5C
	ZiGD7tyh48F4lxL78ysIlC6P7Il9CJaGLWhqpm8=; b=Z2b5fLvDdtaRtLT5sxpo
	rB8Si0+hsuAxEnDqVRyAuE5KIbZhsldSqcxjM7VWUSDeVwwKZQUQwbxkS1zecQlu
	7oD7jcKcr3LqzTwFIXBIbSRPoxdXu9BXM4DjQ+uK1YVz+x/QOWe3Mr3sbpavw4A9
	uL9HQZzybTXLdYLC6BabHENLdt0O/t+tpsZxoHGIlTIK5xtqLe/2v6mz25D099Pw
	RjuBPlqQOjMLaiesL9biJ/pz+UscxZHNvJZLLgn5nJcPoPd9Z4Ba7pqzMKeflg//
	yJplaT2/E7DUKCyOkHJUtc1iIme3CggFz+sq7it6xunXRDF8wxjAfceYqn473RxW
	pg==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j0yu79gdx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:18 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-94967c6d4f4so75242085a.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794976157; x=1795580957; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rc5CZiGD7tyh48F4lxL78ysIlC6P7Il9CJaGLWhqpm8=;
        b=Yh9n7dPIaWaaXGGwzHsjXQrplEoC+qdkj5Jj+o5vf3gpqjCgHgLsZ4yaY6cmVmEg1T
         Q5e1XVyDB+SQ09YlKamgLHFfW6hEHqvKYtLlgB34730qguGiJhsoq4c3zAxqNcPGYX7F
         B26Zbbse7F+ybHoJY2EuYs44lbpx4X+hCH390NB4BBPFaBnH3mn/IfovB6tiPkZ218r9
         IZey/lz/0WfgIDQBlhSDH0gy4QbyoG6HCSW+QT9IaAqyiSyBFKptpz3a3yTxd//fXZIt
         /pUtWRPckhyBI953ma/k1k2UdJwVh/L3wbsB92GLHj2BFEdn20d7jQAVJxqiZ1Yl4ISc
         AhoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794976157; x=1795580957;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rc5CZiGD7tyh48F4lxL78ysIlC6P7Il9CJaGLWhqpm8=;
        b=YxJ9xcufDhPOWP/h9DHwIKY+GMOGgo00YoYf5+njWNC9qYAt96PlaHQwliRl9z7TbD
         h9jvB8KCbfdgc2l7xA0P7DTEq318fH8Agi04iYFI9ppOBIWNA2CyCAvzAuDSJJxy4RZS
         +oQjQTEEGse8BRyADJMk929ngdCHrAI/LKy0mgcBQUkLGtdKYhOU281tcWRnNOh0tRwV
         UWFzvneSGe8UcHM/2HKFTJL7HHA6OIR+uRW+vVYXwFYgzSKVCcZ8T6FyhJaZEZexSZGm
         Hb/wap7nFmwQFYn5JwIb+YNR0rR5EKtj9b/Wc+MLfLQ1RYWsqNMiUQwf4Tp4ROhSwhl8
         9s3w==
X-Gm-Message-State: APuU4Z+y0iPOKkT6b6LoGImP8u2nsa6D9X9IsPBYUx2AQNqHIAGROog1
	Shv5vgkZ9nSXqKKNBbXpE+Gqy1WbeDlbSUrCuasdWzPbmUMMwy9L8thSYxQn/UTBY+T7hTnUHfy
	gwRaosd0mQC3fQHDJhM5LN3DanMoaJLeGRjMsb8mXW0rn9pg1
X-Gm-Gg: AYBFou1wWvJj2NWpDWI2NuHnGMpGkhZNlohD0X3ImNXOat6DK5v4SwcmVSBd0epuLfr
	bGpvSMjG7ZSF1By7DP37wTYIsCi7+2X3Jy+EekUu2kORA1nt2WSUHsBr/3KAx1dxPK4EgeZzxSY
	gWXOeDs+O2e5rmWOOMqYgmgfnyq9XJtFiN9tPQsQ4PVkZaZ4WtJBXOTEOd9lx3vo7hE6vcm8Awm
	HT2SdnrZIXdVfJO0i8ed+FbNCUsh3L7AdSA45NYa0TkP/cYTpWecoJxy0YUhCx4pBL2craS4Ryh
	ecG0y+BqwZHRc4hjhGw8ABOu4DxvVGP1AtBo31dles0YfxelEf2g3vFpe0VxH5CEuC6XP5RD+3C
	Xe1PuKz8spxOHvP8hggH/S0Uxm831f03QeFmh0GHyw5uev0gDppVtQHgrwRaj+Nqz3g2YqthfoF
	50NHp2SeXj/5FaH+/fdA==
X-Received: by 2002:a05:620a:710b:b0:93e:c12c:fbcd with SMTP id af79cd13be357-949996676d3mr314674985a.73.1794976157556;
        Tue, 17 Nov 2026 20:29:17 -0800 (PST)
X-Received: by 2002:a05:620a:710b:b0:93e:c12c:fbcd with SMTP id af79cd13be357-949996676d3mr314671185a.73.1794976156873;
        Tue, 17 Nov 2026 20:29:16 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b743a8bsm89678085a.17.2026.11.17.20.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:29:16 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 17 Nov 2026 23:28:46 -0500
Subject: [PATCH v3 6/9] mm/huge_memory: build the moved huge zero PMD from
 the destination VMA
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-state-fixes-v3-6-b617009d1a4a@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794976146; l=2219;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=QxwfrdfeAZDvxUgLWWnt4K6ra8Mm3m9n0/IIOemncrc=;
 b=Yg+dHnTso+62HA6AwoBYf3rsd8BxbMnxwO9j1plFZMR96k4L5mkWJL/htZVANnb7stvo5K34B
 Y10CwAlkHPqAoHI2SbhOwt/MyAT3gFejZ1/OcrHBeXzZFS7jBY7ybYA
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=LvgHWXdc c=1 sm=1 tr=0 ts=6afd299e cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=VwQbUJbxAAAA:8 a=tHa68p0SAAAA:8 a=t9wnRcJLD9wLKarOqGUA:9 a=QEXdDO2ut3YA:10
 a=NFOGd7dJGGMPyQGDc5-O:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-ORIG-GUID: tYyqxKL5BI8jeyOpgu2nRpL66-BcZHsV
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX+1wqvz8pQQ8C
 PBlM0cOKyn8FR3yrqlBwVUxmu3ILauQjXslGJyS2ybLyyg9t9GLIMEmyFkR2tL8OdvqczN0njHX
 9C4NHtUmIyRq/Qj2A4mk0v45/m+rL22ykAj2JUut60epkQHa4lc6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX1mkIj3byrIAq
 BE831xN/mUACr6/PxmWiWf8XFYGxsIPFLrLj8UCGYJl8Ar38sdHOkV5jz4zjrxiskeCqwXV4mwH
 kpc1LIR0P1cT6xgnmcC1yQmJRgnnzGkw6al/Dy1t2Q62Yu426OdB2cqBMxQpmwB6hD2HzfY9PTL
 t7/fkfJPXNN3c9pzJezFxahdWzW/lNdrvSmOwkllTKELWcH6YMsWkKAXdKB98Ib11EPCDm8inEn
 OQjauz/Swj3mT5Cx5uHa2b/Gzq9F5Bvz9wOJPIIhHQn4BPSPeryPuX2d9cyAbaH9Ly/aKVvoFW+
 MxfpSfYlsuJVJhq3As7q8QoUmizNERurBdrew7qDpQgk5DAuwYE4sJi3z9g0IjlKQxURzzX5Zq0
 SqFPWSGY4/Hz7lL1/d9/Et/I3qFQkuP6JPJHBnabc+aWA9Ra4YRYLbyV1zdL3cWZcnlMmsV9HCy
 yxlPq6uKc9bKGIOYv4Q==
X-Proofpoint-GUID: tYyqxKL5BI8jeyOpgu2nRpL66-BcZHsV
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11969
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 malwarescore=0 phishscore=0 lowpriorityscore=10
 priorityscore=1501 adultscore=0 bulkscore=10 suspectscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611180017
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F0AD21C0004
X-Stat-Signature: hirpda9sg1jgp6i4rm3kkxdjxsdzbxm9
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794976158-790013
X-HE-Meta: U2FsdGVkX1+16eewglehsugYmpZ9HkVSkVJmHezFHVlW54ya9Np9xiDxVQoDLes6SoQOpVqgCPZCOp0nwbsOml5m34knk+NKjgqwM8qcdJiuMfxGL/KOhRxCQTjGJuP1q9flAoUe6D/lynMEcjG3oc0GywkOcCf2JNcX+rroMuWbLoyZFsYRtc1yGdonGl/QvOCq49OJRUdFiCNgeOTuZ3lUw7huS7qETg0JG0texYeZwpLE/T082oC0xKY+b5wOYyeq7SzPKtKaUDgmmpzlo9uGCM5hU0eiD+jq+fcBIDTbkR45IEWL2xgMAobIm8TlfgL8O9oaMuS9oxdbkEHWrO4ZtasnvoJWJucbXmJlufqNCZ+1gNhx/pxz34fsW5OVNAxxiFMGghrtVNw3q90jMLV9h4ogkcpTfQ/Nj3114NFqeYg+hiQC0yQHKY2+CTNOvu9ZCuWQGmiuZ/jVzOycyzS2G60rBd3g2S8FRt+7aPh+cO85xyiV/tN7yPHlhSHglkmRcTtC4P/yyCUWAppedxc83RvBQmgp4m13VGHw/maotY0rdkLOHLOaeRFCOoMScPf5MjxV5pQOmYrjcRml0HKWDEPRDgiYRHMgw4F6wZ3O1pAiiK4weTt/5ToMpZ2+65SXI44P3TEOh2dAwNIBh/9E53Dq0QLCPnOhS7UUJjiHzB7+af6oDF7uIWYeBoYUHLNZojGyqJNaV4bv9R2aSLv3biOt9VBIr/VUuglOyVOm2XgeaZ/EMQ+O9nDc680CjYcx1ikChfckkGtlH/E5p8veFPqMBW64dQXov8eWu9RmWBny3EevvjuDGoToa0tQ77DfhvyRa3WqoRDJVyt+vG9xYVabbV1tT8WLLmjKz6KUg6CPDH10UA9YYbf24SkGWd/0NR1fOx3F5EJFVKxN78eiU5uLECOfJmjHnqS8oJzm40gy/Upxrh+g0aL7jgObdhEy4GVtJbCryhH6rHg
 U3JzPd1V
 Ga3wmPGw0BQ4XzKD2clepy7C3cVUa47f5xcQSGorQjkwvQVgPK9FyQ9JeGpmAFoQccMpM4yvSCZVAjcQ+2NcMGAjwdJQRK0xiPMgsA1vR2fLGNOwaban13NVGhcdBYP0SbSxYA3P1XOH6r9Abu7z/ql93RZXhm6vCbLeW85ZqV8PuGmjyjTQxlXNoIqF26o154eHWfOdxR3qZIqonUyjtSdEnbhjI33oiMybx66ld93I4swnPAcQ1iCICUrEgnWHoVQyuygOsLLUQmJGRspF5nIEGVbz7EC+qzAHKXG/KjDMKINNmAFvFxt9n6lkx2kVfsukYPuRhNxytsAh2kEkvw8qijHzg+UIplX4HtkWNVIFocaMs6ZXw8JFuIRkfjNk0T8Lf3CZdP6bBdTJLtKZuouBiSRX/KitEdulNvJ94bPQCGQyHOlTtt23g0XaryIR9FN1WWTG4BsADNbmNiJw030QCR1sNu0NY99IlGLdKNZCUH2DtqSDqMqNxXZY5sEyvPdMkhye5Up3UinhRW8JeZ99Zw2Nxc07iTygitLa0QkUdsLUaWfVsbU9S00vu72KsPr5AHjq1uBIktqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_pages_huge_pmd() builds the destination PMD for the huge zero page
by copying the source PMD and clearing its uffd bit, so the destination
keeps the protection of the source.

A source VMA registered for RWP can map the huge zero page with a
PAGE_NONE PMD, and UFFDIO_MOVE does not check how the source is
registered. The destination then gets a PAGE_NONE PMD without the uffd
bit, although nothing asked for that in the destination VMA.

The next access fixes it up through the NUMA hinting fault path. Until
then, the first access to the destination takes a spurious fault and GUP
has to take the fault path. The impact on userspace is small.

The moved entry must have the protection of the destination VMA. To fix
it, build the entry from the vm_page_prot of the destination VMA, as
move_zeropage_pte() does for the small zero page, and keep marking it
soft-dirty. A destination VMA registered for RWP still gets its PMD
re-armed afterwards.

Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/huge_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4a4e187ae3b1..bb7fe695a615 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2981,9 +2981,9 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
 		/* Follow mremap() behavior and treat the entry dirty after the move */
 		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
 	} else {
-		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
-		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
-		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);
+		pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
+		_dst_pmd = folio_mk_pmd(huge_zero_folio, dst_vma->vm_page_prot);
+		_dst_pmd = move_soft_dirty_pmd(pmd_mkspecial(_dst_pmd));
 	}
 
 	/* Re-arm RWP on the moved PMD if dst_vma is RWP-registered. */

-- 
2.39.5


