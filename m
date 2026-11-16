Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50ACA606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=gaBvCVkU;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=MZmZ4FgO
Received: by kanga.kvack.org (Postfix)
	id 0FE976B05B0; Mon, 16 Nov 2026 15:04:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AF306B05B6; Mon, 16 Nov 2026 15:04:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E928B6B05B7; Mon, 16 Nov 2026 15:04:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B13CA6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB790C011F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:30 +0000 (UTC)
X-FDA: 85442059500.28.9DED3EC
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 54C1F14000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=gaBvCVkU;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=MZmZ4FgO;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859468;
	b=BDND6GED/FqMvfBFeKIJzhsZH4TwQRiV1iFVK/8t+gKmTfubocyeHn8NKNMgDT6gx+Itum
	iYY9YSzHwuqOzAX8DgBYDKAiLRr7U+BDljydE7l1wv+HR8cAZD6B2lCiljVrnirKU4WSdX
	xNLA4AlKOoy0fMOJDtmlKI44abtYG1I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=gaBvCVkU;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=MZmZ4FgO;
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pCrvciRru9far+96jdSprril95F4Tc/yf/SqoSxM80=;
	b=nkjdswYXzGPGtcXKX4fiMqA4jUMLyd/N/G53UNp/nGtURqWjZXq0HsiU2HwaS3g1Vz986c
	eNYpv6EKMCnyUMIa7ZepZUc3yqN5PrYpw0oCn7Hj9FludZp8I9JHy2ZY+mkRfNrXG8tsDZ
	IsHs1GStY4+/VQjkGv6uyA7eYdC6QjE=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXSGJ2979205
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=2pCr
	vciRru9far+96jdSprril95F4Tc/yf/SqoSxM80=; b=gaBvCVkUaPYrP9nkf0+Y
	CfazgRl0zQMGC/xzRLmb+PR4eDFygVmlDT2eKTskq9kNYGGvTgf59hl4FOIIxK8R
	lHhrfVVbRvRMZ+dULXsyB9cgK+ciiRyoxD2ZGMjzowc0evibBitvY5W+baeptKtx
	B0w05BH564VGyryNxzB4+mvUc33BDujLcR5AZdwAnjJmAcXCMF5iMSRlxRie0L5T
	zfNHum9+PxaSBmXaQjLgIYcr6mZeye6lEWUDBUScSQLnXW6UL/4Rg2miOwjb/VN6
	zDtrn/eaZw9TqpTu+E+1IovRyKliJaWPvJVqVMtFItYmGGzEU0+Fs/wT6jrXgTr0
	kg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j059sa2j2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:26 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-55d2bde4c78so27415511cf.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794859465; x=1795464265; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2pCrvciRru9far+96jdSprril95F4Tc/yf/SqoSxM80=;
        b=MZmZ4FgOfqmlwmWwD2HhkiD85YBLZiTFiLjnaly5DM/uKWWf/9L+3ojRGa4eYD/UnQ
         S72sViSTro7r+RjtdrU4AIfPfdTX/dK2Wqw7+dlfhUv34Z1N7RXYLpH91MMWRGvuyELU
         6oBW3BqrO5RE+1IJUxIW1G9fdQ2Y/0DnujBDfC7OGyE1ysfgSJS+Fm8bBHssIGyeItcH
         D93ieAv6mTMfNo4kz2RiS/H2lJzfNBR6kCGYsFzZydaLdO2/x2fb34DJyDbsZmn71gHR
         W2J62hrF9PpnreTqN49amSRwAg7KnZYO0e8XPvpMXWCfseuGpBjc6K99xK1F4l8/GB4d
         7GJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859465; x=1795464265;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2pCrvciRru9far+96jdSprril95F4Tc/yf/SqoSxM80=;
        b=0Vah5JHOBfdIn+4MpW1BSjoXkywaxzjMl5krxtGkapo65op3zUwaFftGOvQayA63Kz
         mbYjEFItUkAQDhlA0jFtSgMCPIiKKpuGxqqObyj5aDpmQlsizB02mbRTHrAYPoW45n8Q
         Dm3IZqwez9q3picqCUBRG8O+L5qcbEUrV87ly2nGbrrdHMUX3rdCqdfvzip8igYNAigK
         eEL/cmYABumzmDN4pw5X2ByQARCFT9FpIjAzr0UjI2gjebYtNFEpZKcKoCnkLDPYWxMy
         7mtiOPRvVXmsmT15LX/9HqptJusp4SjRoyjte14MDEsKt9J07Add3V+WYEBAlQuOPG1H
         kaKg==
X-Gm-Message-State: APuU4Z/n6urY3i/FQNmcVdpV/Si4HefPQIRpWmLtBnfUD3Z2etNFn/7N
	az3kj7iH6odT6wdvDQiYqIugv2tG8c451sxKXa5LoCBHRGrtF4JDC38YYDWqvfqmkrWBrGiGLBl
	QY7UeiLM0PPYNl89KJ3PL0YtvGGMBgYmNvAO/ujROiOvg1HZN
X-Gm-Gg: AYBFou24ivfuzsCeeyI97ZYh0D69r+Lx7Bwd92ONr6BqNm5nfb93UNVdzz7Nx4CxmeI
	OuuOQopIAYNg256weii0xx8xY23XM7qgKft+Gph+gkanaLwEIU0q0IfcPQNJw6X/6vXyo7/kdDC
	nREK2xaSY6Cra2rl/En6yj0B63GJv7yO08ow1H3oFb3zS1VkdEdWvCFfLuIpcQCkGBeguahA7Tb
	sDxyZ3S00fAbGnj2UPxRKW4UaOsE8EW3M22UW4dLSoy9hZxMYKo/o+T+MMWjcsgTiZiL+Nq6zBv
	aB47yR55e2YWmAA12Bfpgqb6r8qqxHSMQRdPpu/zdJm3mKaDDQd9rPnKvIA2ESBUc4SrRl3QkVt
	ybUgqgB+S0pA2+rCf3x2Xk86CaKvPFgJBREpWBVLFv4d8n5BpDkw//aPaLJpj6eseYWt357EqFC
	+Tnjr5PSycOtXPHV3RR1Zz
X-Received: by 2002:a05:622a:581a:b0:536:5a78:6b13 with SMTP id d75a77b69052e-55ac8880f3amr188261591cf.57.1794859465151;
        Mon, 16 Nov 2026 12:04:25 -0800 (PST)
X-Received: by 2002:a05:622a:581a:b0:536:5a78:6b13 with SMTP id d75a77b69052e-55ac8880f3amr188261071cf.57.1794859464655;
        Mon, 16 Nov 2026 12:04:24 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23efa2edsm93065426d6.15.2026.11.16.12.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:04:24 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 16 Nov 2026 15:02:43 -0500
Subject: [PATCH v2 1/9] userfaultfd: use anonymous memory for
 UFFDIO_ZEROPAGE on private file mappings
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-uffd-state-fixes-v2-1-4397a0196479@columbia.edu>
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
In-Reply-To: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794859460; l=5357;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=gBVSnTZ3qsV69B4gqQcTBCEDewrjMXk5AC+DfvYSL8g=;
 b=GSOjaB1MTsgs5EwXWExu/mb6uuQFlX5gvMC/W50tTKHT+E8WJeRXUZRGB9CfN8X+Jyh9i/MYs
 akVq5xaSShPDq2cx74ysos2PCDaUbKtJgSPqrHNGHGAyRi3dq+F3eiF
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX0KwZmOKgxH7W
 bhxkQPdatSZ7GithvEbqoTEd8R9CSSZeXBaPOzNDT+z8ZS6OgoW5j9cjWaqSji7WYZDMQbhj4Ma
 QModeRM9bhs3K8iYTC88qq1COddnAuksC5PoyMVKIc5YVQRTrEH16SYwzIRHsveWPVDhT53amr9
 Pt+ylIUOs+rv+rgETKkHr4upYlZkTgPEP3bTnJzN6bFLfPMdJOOBhTyRA0f5Zp7K03S2m6Wr43K
 4773xKTHrRZDRelYIpQkHYdEitC6sWsVyQj7AZyUh8moMhU0FYTe0Cd4P09Vn/Tk3bUZfcLNuvK
 yMWm0HsZIjceP6+YRIbmo0VQ44Gp9K+zBMa47FCkWfjpIXjWnQvCDYBaClY1aHJEQjeF2IF70fi
 i3XDm0RcbTlfJ3OSV5xuX5FiXCU35DP6bH9xIDRpfmkOIRO3pkyMQr5dqbCWmmLSqPHz5unx2l1
 38a7A8xMwfcpkSFXXBQ==
X-Proofpoint-ORIG-GUID: MyG9D1h7zf_qfW1VcZxC0UHpLWctLcs7
X-Proofpoint-GUID: MyG9D1h7zf_qfW1VcZxC0UHpLWctLcs7
X-Authority-Analysis: v=2.4 cv=D63SufRj c=1 sm=1 tr=0 ts=6afb61ca cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=VwQbUJbxAAAA:8 a=a5NvJi0EDLanwwYVvGMA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX4wzytkfooaj5
 jDiqheGjQcYd+2Fed9KmERO0iDeQeksHzB9EPbzPljSR5tVtDG9Ei709EL9ruXsV0WahwCkSKFR
 mzjU5ZdMyIZLbsIUUrpFKuf2pRsYq9Wp3Ey2g7nfpH0/N+5PCbRr
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 priorityscore=1501 clxscore=1015 lowpriorityscore=10
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611160080
X-Stat-Signature: abmos73xcnkq1997sk9a378oxb3caboh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54C1F14000F
X-HE-Tag: 1794859468-206409
X-HE-Meta: U2FsdGVkX1/0U2pYt7x0z7C57Cf1ngGaEsoolPVZGfyhLpHWNJHegqcAHh6Po31ED7ukWI6lumkFCthRvuDSiRuvhoA6ZPvYsluEaRck800DxcBYAxNd1/2MID7j1Y1AKWAH5kzmlmNdLUv+6qMOb/tHHj0dczAa5pgOslFP/8HGyY3vqHBDFwPgy6QbKiEviH+pFGYuazLkHCsK1JRUJGChJ/s5HQZjJEAXHIYX+D2d4+QCS7kETGEyQ52uHPvU9X/WokABRrA2cnei0VeRAi8nb9CxSsTHR3WpJzIHVNp6k3mBF/Ey30S/lcBZAEMGdARKRChbFMe/YxnMYftoOn7UWT/aa5S78R5zrvFIMSXnx76rF4qKwO5O4xeIJenFtdv2kwB0QNuYiSjzatz30AESUDxPxhOlQ4DnA3YeOdf+8I7EjY9I//cYM/aJQBRPIgEYTjk1HboY9eeve7QiVDQwO+0yaV9r1uU7a4ws+1zlWHPPYiC0Aiv6If5/dPlBw5x5Mdx3a0WzHlcp3cvoTib0zFuaVu4jCik52pz2ywp3mz4+Wokk3x74Sc2EAxwZH9CBoW3NQSK/OTgi2Z8Z0Qt+DjVLkfsx4z743sdJ2/7e2wFUh6SXDSGDafULfcJjVmDh2OlbofwiZlCK4ifjcmeoMfPKtdT44k5BsknN5mjlUciMFai6DHZ9YLRAmNnafscCsKeikm92MyoieHNhEHTiWawl2SAuICl6k0nen+97uLLZds2k5HfeubFCOM6WnFMOwOEzlcAQtU2La5mefGJeWGVRRHvcyCW8SqbFIz4bVMmqrf4cLBGI6KKcG6ZSZ5X5SY4x1JWS1jhD4MP9o3RcFSovutwx50Ozd5uxTcRfERlR5qpZE6UXpsZbvhVbvk/Co77pNjgbQ5XlAjJTlczbvjvd05//cJH40LF/+3ymOGYmhiWNFBInYTDBnUyV0A36EzK4i3rIn4MkHr/
 Vx1Swx7+
 GkILzWgNASDs1lpBcaRNPbllXsThFFM796xWH+6NmKA21vA1YoG/btzzJFUD350OsJPwAOZwbniDUAO4i4IvJutIT5Ks9SMwqnl9Gw3JOQZEezMp51pGGsEA1a49nKbyYBeifysR9KL8GazIqN23FpQShJyPZp+K1A7o3cesH5PW6vc6ZxuRIMvBqZ2u5Qbz3srRjUMs9wZilLBg2+QkXAgGIjn5T19667xCIfWSuutErocd/awNrI3WzlwbSve6vCeoQudHnmXihFCvGJLrAYeTGP0UlfTAECBhRgG9SoIH8BjUdLqkDzls8Kp7Jnb7BCxfFr0ZmzM5qlKPoHiKZKOoC/TG9oyhQSYtsGB5jpN2JXfx/RuU3q+mnXs4Pav7kr/3PhRkLPoyYYnLaI6/mmciJ6dcX4EhMoo33IGeKIfZnt5M6bvZ5PBjitVKqOLifJOtnw5Iz+iWpMW0tSWj2qDTnSLNnsMpsRvyLbPOLNpPbEAmskZFzxPahwCRHt92iJ3Yc4WIebjFN9EwoeZ83Nms6eQ==
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

UFFDIO_ZEROPAGE no longer modifies the file, and only fails with -EEXIST
if something is already mapped at the destination address.

Fixes: f74991b4e383 ("shmem, userfaultfd: implement shmem uffd operations using vm_uffd_ops")
Cc: stable@vger.kernel.org
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/userfaultfd.c | 46 ++++++++++++++++------------------------------
 1 file changed, 16 insertions(+), 30 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d65184d9a480..61a712e1f9f5 100644
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
+	if (!(state->vma->vm_flags & VM_SHARED))
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


