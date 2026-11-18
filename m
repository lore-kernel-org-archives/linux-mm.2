Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80325606A895
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=aX/azDTm;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=UaaAL+cc
Received: by kanga.kvack.org (Postfix)
	id 43B5C6B05B2; Tue, 17 Nov 2026 23:29:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412106B05B3; Tue, 17 Nov 2026 23:29:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300036B05B4; Tue, 17 Nov 2026 23:29:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1DF16B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4129880696
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:15 +0000 (UTC)
X-FDA: 85446960270.19.66B551F
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 48E801A0003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="aX/azDTm";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=UaaAL+cc;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794976152;
	b=H2ZKreytLz9GIQx6Bm2qcia2tdM6uyvwGoYG4ufjKklulRsKgq9eDbdAdjvdwMauKaBERc
	GJra4NPq2VDuxeruQgRJZleq/pb/xAveiN2p2rXM8shNzyGw0p5+zfgmMBJwgqK731YAY4
	kDPMVyDfzAY7No8C7RE8+tukFvwnd5A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="aX/azDTm";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=UaaAL+cc;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794976152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1pZTPbPLpqcipBn+gCe+PHsN8BLdvgf8n1ZHU7b2omk=;
	b=7FC1R9z4L0eBMLSqycUPh2pWa2fg54bvEhV3uS9xpQlEFwr2uXHVnB5A3+LwIW+Kr991eY
	L+CjPrWB+ZyGhRGVQb1JTJHqPqNCCzetPTI7kjw6fM/D2ML3Zei3yn3DObgNE2U3L3B6wl
	HRQOoD05R/A4oqQHEG2jM7WM8L6Gz5s=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI1XUkT465135
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=1pZT
	PbPLpqcipBn+gCe+PHsN8BLdvgf8n1ZHU7b2omk=; b=aX/azDTmf2h7yR5Vjear
	bS0xksh+kHycMdXrf/MUt+2nFXKp0T2HZ+HWyNb74fEMpBg9UsypYlm6i4/5vsGS
	sNqllSzxTvQidwjQ89pJEkl6MA2N4MUW8BxEaa1GrF9uVWAkHsvze3mE7C46rrJl
	rhDaXEZxcLTtduVc9J1TlNMb/bQ+5GOuws3gqjwzcTPyCcPmKhQXbSiAAVTz18tm
	s7kJvLJjB1Zo4G0i7xfR+giX/dC58Y9Jvve2SxJdJY0ofVST9yrVnPQFhGKftuFz
	dZuj/YLYrjaCZ1AyPps7NOdlPQEQJe7Yc4UB/bTrLZNi6uAvGr1I87pFiorfmgv6
	mw==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j0yu61g4y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:11 -0500 (EST)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f33438950so121112985a.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794976150; x=1795580950; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1pZTPbPLpqcipBn+gCe+PHsN8BLdvgf8n1ZHU7b2omk=;
        b=UaaAL+ccyVASSAlkfEvC7I1CUY+FonsIJXjtLzThODs8luFh3Bnx1Is8pMehNyWiOH
         ojai/LKhdc0Z00h01G0elQOi0INXzIJuSd/PnBcnaaUXNSJLxpvOl4Mtmkf/bm9SFfBa
         JiK+RsdKL5UuFkrVGTYwkGHIRw1EjRsTvXWFjxDmPb+Hp4XkhIIh9t5F6g0+u0TH2XQu
         bSh+IQqRUN/Nve+PlO4g+5wsr4zjwltY4Rx7V0zd4RqFpSz8mOCzfFh4sV55vfixpesd
         t65L8UBP+aUUjwrLHrBDd3m6tj+QUz9GUWfHtJQFrGIatmahl2eyYHYBJ/ps764pNa4T
         Z1PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794976150; x=1795580950;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1pZTPbPLpqcipBn+gCe+PHsN8BLdvgf8n1ZHU7b2omk=;
        b=ml1KXknPdcFkiVEAGP9AcZU5kDSFuIYw5xBwyuIuphhRwCtUTWN6UviqrHem0nm9SC
         3/S8T4/CithlZYLnLaudy9qA5peRHBiz8AQsXhjXjac/TqTjAueWoYLwBQK2LYAZWgTr
         cGhcHPiAg/u+By0XCjsc3FRBl/qthxCcp5HSBiW6fTueT0MhPSU0RwuKjf4fXMGPw1gh
         O8ioE70aq4Wescy9Ek8hASnaVjfWPkkpPAUgxJrYOyfvUEZpY+Y7WfqSfvAzBGzIWIfA
         hY4Mjil6jxelY8T2VHxzcpkVYfOnPYV67qW1LNDxJKGFaTPwNu0TQ+l5cAMwN3jEdfOJ
         T9hA==
X-Gm-Message-State: APuU4Z/focqY5KA+i9S/+ykTYmV3YQy3Y2j19CMGrD6hgycV3Uy98rX+
	ldCvfrctS4iFsbHjz0qnxNrlbd496/DpwCWtsKAd2nX3fL6aus1kAsGx5v/wVIIGj7txOXQ+RKO
	CDpC1nvyaTyq0RkTuOIRKIoBy3R8QndnvzO2yz19K2BSn401z
X-Gm-Gg: AYBFou3IPZNaboYEczmm0YRdYm/G/nvfXxaaqlja3GYPtoyhrSWDTeX4PCvYPBKexT0
	oPe4hSf9Cy77MplsOh42XEAFWgQogNz994APR/qoDsUqA3s2mJG1GjLNVniNvCBMfmgmMwKOKC0
	/7fRoxJAtYqdSihRI0TBf0gbmwWLHCdhTm36tbbNa76fluOq1AD7Yy9ChexjG2ODlbz4VkyI1j5
	mWooVbi/Dd4csL1AVFe39mVblyn9HULzaT06/ApYnNXYzFw6AikFQpRgHcfE+fKV7YfuinRjWr6
	ckn6IBPr+jEm5KRch+KJ7A1HbAj8aMj/cFNWFxJBEaVSsnnHf6/9I0TIwPsCZS2/0+PMAD3EESW
	TSM6y7daT8tSDOfTGi6jxXyk8i7zrp6W6Nz0xCZg6ss2psLNgMMhJekAxoo4Vn/5M+q/0fNa4Nn
	+utM0vlbyOhHuvi2PeTQ==
X-Received: by 2002:a05:620a:2b46:b0:949:73f3:843 with SMTP id af79cd13be357-94999631b1dmr290181985a.74.1794976150531;
        Tue, 17 Nov 2026 20:29:10 -0800 (PST)
X-Received: by 2002:a05:620a:2b46:b0:949:73f3:843 with SMTP id af79cd13be357-94999631b1dmr290176785a.74.1794976149985;
        Tue, 17 Nov 2026 20:29:09 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b743a8bsm89678085a.17.2026.11.17.20.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:29:09 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 17 Nov 2026 23:28:41 -0500
Subject: [PATCH v3 1/9] userfaultfd: use anonymous memory for
 UFFDIO_ZEROPAGE on private file mappings
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-state-fixes-v3-1-b617009d1a4a@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794976146; l=5479;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=D1dw78bimKL+d/luxdZ7meDrQ3j5/UFW8Z8ACLLeFmI=;
 b=RfkD2DVfsR3kFo46MpyYEDOjmciIMWeEGcVQFwYVPUGxT1EM+lXv9ORRuj/jFjXbmxhIYk4TD
 rjKTtksjKS0B4mjB4HplBkLm6jtCZgqq8RPGFYZO9QYNFVL1tJIoIsB
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=NItAaE6g c=1 sm=1 tr=0 ts=6afd2997 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=VwQbUJbxAAAA:8 a=a5NvJi0EDLanwwYVvGMA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX1uTJ0Gaa+HIt
 1Ooflv0zmcm9e0HDIDqwSkLaIaXZJqwujGKRAVpM23weg9kgetVdT+upp3TUNMxEthQ9/mhDXXi
 d4iSm+KSk4sHqJmgEtkVXr/srqVmno8Ll7UVIeEzgoC1XUs6nKpn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX3qfciNPY0Dbl
 wNWrFtITAAoIH5tQDx79s5ilkYoYAmzm+ayx7aH0/vAxIcFD8hDEGMeU3FMEM8yxLNCXIrTT8l0
 +Ip/tqw+QxHz+HgCHbwqaT5UzZH+nNOBmZ3vauLIt2OhJ38MrwmLHK6DBtvnxB5XBZr16Vkeu6h
 S2oBEn12F18QDtx6otZgSeGhoNwZi9a3BH6tYfTy00DadICWKWml0Zp/s394D72VrUnG1ImPcS0
 8jKq3Uq7qqmGDN1JpAY/Q+jrnlcWEfjaCgh2RX3V++5I2okJEV/L9yZFQBQjI8hzChjMCmaoC1v
 CY2SRIsWAtPaqcMHGx5haRkbaDZTahkCYbTEUJIZWh9b/YcafcAwM8m5Ih2Lg1G/JFyKc8AU0ai
 ZL7c4aIKOy2Ldriulsm6hUnRg8V83JvOln+WnwYt8bfX+pGsxATxdOOcf2Mwt6Uek6k1YhlGw/A
 Ih1ZwqIW5ieWjlAuElg==
X-Proofpoint-GUID: JuUs1jXrIU0wg-zkxrp5tez8mHJU-HVQ
X-Proofpoint-ORIG-GUID: JuUs1jXrIU0wg-zkxrp5tez8mHJU-HVQ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11969
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=10 malwarescore=0 phishscore=0 spamscore=0 lowpriorityscore=10
 clxscore=1015 priorityscore=1501 impostorscore=10 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180017
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48E801A0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cs9e48hkj73ns9k1weo1d699auydggf8
X-Rspam-User: 
X-HE-Tag: 1794976152-798238
X-HE-Meta: U2FsdGVkX19r7qncaJVKEi0rVUR9bEfDD3/JLJVpDRrR7Wo5xGVaQlUVazsBg1Jt+MJWgTO9nJPfXN//9v2gp5go9RwQb7oUhk12tnMKTKMD+RfQ1wkmlx+JNtzXxtTO4M7ISYoENekf7x9zV0CntTQ1tejcgd0XtHOzEBm9UdD5tAVBQV/LNAYhGfkaCv2eBMp28fcXNG4qZNBipKTgt4wkfg9341RaJZOdWz0KFun2NLW1u2cgWo4tum6cAGK8ic+DK0uTxp8VRzsbDYQKTmVceXbEPZTNVxU5K005E2LZg/W38vhbGbZiT0men27Y52rbZ2de2HEX0hcuHd6YgFeDb53EzFKwoieVPhy0jBIW+OjXeJjo3zv9qVLVM+NHrqSZwww7v1QB/1qkXRtw2FJVbbYqEzZ7uZetK9Ya5zTZXlbM6wrC4/YADHGe4aIRQdkyW2/1h6QDFa1KnzhtiOjm3cKWwcw4b6609mV8Ccc+gZ7tPLy4+d3hKCBGpKQfp/qiKHp1VuraTUzMNmfZaMxibyT3l7XjIMbuYgg16XSx9LLUedivgihC1gmroW/FvioMhAucNQ3gh1uZCellT1IM3KtnKp40HWQGQySXjDf9bavRAWa8i+x1iAOybfNJWbXHgQLI79CR0EK/CTx16av4dS+f1VQcYXc/v3f4mnVN3ftAwFlmTZ8GIUT8DPrelCgocutKTc/I44hnm0ffESTSALAQPIGOF0sNEXaaS9Rx5dSN5IAwnBV4xruWGFMh7YFy54yN+bvAWSxcHH6m/H86McwYkeDbXqKkZRFDnmU/OOuNEnUOZXToFRQHJ+nN7ygfU2KbfYDSMEdXusjk0XlVgQN5DE02F+YZxrR4/B19JmcPolzLkUCWHEnLIjDFn7Im06EfuWbhdujvHkgsh7nkNVIELzkTkLx7TPRDxg8dKK+6ByZmmblS8vvPYKM3TghvElyiggdCpnlnyTn
 +M9heith
 UK9aPoqSM9yVa1XB+0W6Qpx3ZFD64DBjQKVqp5vVkr2l0qDA3kaqLf79CwmD7wx4ys5h/6vwUHrJPnsyJKQ9PsAJLVwKZZOHBbuomwdBc1pGYuFT6MAeF1GrRX/HhD7curFQDar3AhtSiyrokc/Ozlc9Xge6CnmbQuk/kt5yGN3j9S4pmRqmklIUECXXQ4ziiGKEdrUjHQZUcPj+GM/LxqF/r5G1bSntwr1V336XLS3KlsapTokIzm9sgljupNw4LucL0tUZ0yuSdEEwx+iIg68B4LGve0UGa2Ki5FlOcIg2ryeKF6N9kL/C7q/wJdO8RcETA+yGrSy9SaRfxxwR5Z/kQ34iHgmk2XTZluIRCia3rJWaoBJz7FxU++pvpOcih7YCNRol16QWl9iC9eS/J5pU2RZ2FKMaFpn3ILX+qGyhpdfROXVsd90vg4htT+uH5BXXuuZYBzkm/u7K2CQ3Ti9Rme1pqYDk36fBVOmgsEgwcyPHw3i3ffwzsgppuKMsAVTmgXqR5Zjx17HcCkN/QNj2uIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If the mm cannot map the shared zero page, UFFDIO_ZEROPAGE falls back to
mfill_atomic_pte_zeroed_folio(), which allocates a zeroed folio and
installs it through vma_uffd_ops(), no matter what kind of mapping it
is. An s390 KVM guest with storage keys or protected virtualization is
such an mm.

For a MAP_PRIVATE shmem mapping, that adds the zeroed folio to the page
cache of the file. That is wrong: a private mapping must never modify
the file it maps, and the file might even be mapped from a read-only fd.

The ioctl can also fail where it should succeed. A missing fault is only
delivered for a hole in the file, but UFFDIO_ZEROPAGE can be called on
an address that did not fault, or can race with a write to the file. If
the file has a page at that offset by then, inserting the zeroed folio
fails and the ioctl returns -EEXIST although nothing is mapped at the
destination address.

What we want is what UFFDIO_ZEROPAGE does on a private mapping when the
shared zero page can be used, and what UFFDIO_COPY does: only check that
nothing is mapped at the destination address, map zeroed memory there,
and leave the page cache alone. The zeroed folio path did that before it
was moved to vm_uffd_ops.

To fix it, pick the ops in the common folio path, as
mfill_atomic_pte_copy() did for UFFDIO_COPY: anon_uffd_ops for a private
mapping, the ops of the VMA otherwise. That makes
mfill_atomic_pte_copy() and mfill_atomic_pte_zeroed_folio() redundant,
so remove them and rename __mfill_atomic_pte() to
mfill_atomic_pte_folio().

While at it, use vma_is_cow_mapping() to check for a private mapping.

UFFDIO_ZEROPAGE no longer modifies the file, and only fails with -EEXIST
if something is already mapped at the destination address.

Fixes: f74991b4e383 ("shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops")
Cc: stable@vger.kernel.org
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/userfaultfd.c | 46 ++++++++++++++++------------------------------
 1 file changed, 16 insertions(+), 30 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d65184d9a480..e787e9a3ea29 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -531,15 +531,27 @@ static int mfill_copy_folio_retry(struct mfill_state *mfill_state,
 	return 0;
 }
 
-static int __mfill_atomic_pte(struct mfill_state *state,
-			      const struct vm_uffd_ops *ops)
+static int mfill_atomic_pte_folio(struct mfill_state *state)
 {
+	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
 	unsigned long dst_addr = state->dst_addr;
 	unsigned long src_addr = state->src_addr;
 	uffd_flags_t flags = state->flags;
 	struct folio *folio;
 	int ret;
 
+	/*
+	 * The normal page fault path for a MAP_PRIVATE mapping in a
+	 * file-backed VMA will invoke the fault, fill the hole in the file and
+	 * COW it right away. The result generates plain anonymous memory.
+	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
+	 * generate anonymous memory directly without actually filling the
+	 * hole. For the MAP_PRIVATE case the robustness check only happens in
+	 * the pagetable (to verify it's still none) and not in the page cache.
+	 */
+	if (vma_is_cow_mapping(state->vma))
+		ops = &anon_uffd_ops;
+
 	if (!ops) {
 		VM_WARN_ONCE(1, "UFFDIO_COPY for unsupported VMA");
 		return -EOPNOTSUPP;
@@ -597,32 +609,6 @@ static int __mfill_atomic_pte(struct mfill_state *state,
 	return ret;
 }
 
-static int mfill_atomic_pte_copy(struct mfill_state *state)
-{
-	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
-
-	/*
-	 * The normal page fault path for a MAP_PRIVATE mapping in a
-	 * file-backed VMA will invoke the fault, fill the hole in the file and
-	 * COW it right away. The result generates plain anonymous memory.
-	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
-	 * generate anonymous memory directly without actually filling the
-	 * hole. For the MAP_PRIVATE case the robustness check only happens in
-	 * the pagetable (to verify it's still none) and not in the page cache.
-	 */
-	if (!(state->vma->vm_flags & VM_SHARED))
-		ops = &anon_uffd_ops;
-
-	return __mfill_atomic_pte(state, ops);
-}
-
-static int mfill_atomic_pte_zeroed_folio(struct mfill_state *state)
-{
-	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
-
-	return __mfill_atomic_pte(state, ops);
-}
-
 static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 {
 	struct vm_area_struct *dst_vma = state->vma;
@@ -634,7 +620,7 @@ static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 
 	if (mm_forbids_zeropage(dst_vma->vm_mm) ||
 	    (dst_vma->vm_flags & VM_SHARED))
-		return mfill_atomic_pte_zeroed_folio(state);
+		return mfill_atomic_pte_folio(state);
 
 	_dst_pte = pte_mkspecial(pfn_pte(zero_pfn(dst_addr),
 					 dst_vma->vm_page_prot));
@@ -927,7 +913,7 @@ static __always_inline ssize_t mfill_atomic_pte(struct mfill_state *state)
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
 		return mfill_atomic_pte_poison(state);
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
-		return mfill_atomic_pte_copy(state);
+		return mfill_atomic_pte_folio(state);
 	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE))
 		return mfill_atomic_pte_zeropage(state);
 

-- 
2.39.5


