Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3419F606A338
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=Avi6yR7y;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=IBI3kFoJ
Received: by kanga.kvack.org (Postfix)
	id 591966B05B6; Mon, 16 Nov 2026 15:04:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569706B05B8; Mon, 16 Nov 2026 15:04:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 458416B05B9; Mon, 16 Nov 2026 15:04:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFF226B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:32 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 372F21C2217
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:32 +0000 (UTC)
X-FDA: 85442059584.04.26F7EE4
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 747DF1C0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Avi6yR7y;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=IBI3kFoJ;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCwhlg799dXefZN6g30kX8e7Dd77LrYQ4Kv/DAwnaW8=;
	b=uGIH1f5oFuXnG9+SKWQ+8Nq06uOOWZGesWNezWzhkWxxU8fJLvhjrQio6OFD2qWiMwtmaG
	/L4cDCtm8hiW6piy3mWiOfOP1mT7Fw+4/6dEJTBBHZColTroKZA07bgc0yPOgW1rwKRXfc
	1Rz5OeHKFWUgucnvAigA6CTnzEzDVUQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Avi6yR7y;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=IBI3kFoJ;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf20.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859469;
	b=omBw4w5RWmWaLQtepVyikMviXYywDaBs2eW/+EBCBTiVb1p3App0+NZz0FViSB8YQYG8U/
	xANVGSnlpRAJqm8VvJH2HqF3nKP1LVfdyPGVmngldhjDxM9tNNIUGKVImQPwOuYemdwEGl
	wdTqRnV5A3j1gt5ZiB5n2SCX9fbgH9c=
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXP2X2058204
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=ZCwh
	lg799dXefZN6g30kX8e7Dd77LrYQ4Kv/DAwnaW8=; b=Avi6yR7yJt5dxX4uim8f
	lZi5WkIGIa3WzKo8VWyn5yiY+9+QwBYGcFKkPG8Ll2bij05Tf/KmSHeosGVQEr0X
	vINu9OTxuHu+hMC8PrrSPH5E/xOI6rMUoMxPgyOWBkp2pV7hanccM7QxZzHJzxIH
	CJlhMYH6KmezeavezmwnNu3eu2xN+bBfGoFjsyRJnU8y7LnshG2MLp4qmcaRl7me
	/TDiOV/WbXgQaJ66MCjoqwqjmdjS3ibjEjpDsrJ+zOyGTYk6zpDPfuPR068ujrFO
	1iHPISMUXlqAF/djUPb8KgpHAfEW2FI80JP/8HOVxpFJzS/45igtuTLNBqPRtJ+G
	Kw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j0583j3f6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:27 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-5363b06bcb2so33642591cf.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794859467; x=1795464267; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZCwhlg799dXefZN6g30kX8e7Dd77LrYQ4Kv/DAwnaW8=;
        b=IBI3kFoJiGNg3KNOfw+ve1QzKqv4QGnp5C2dB7oiTj0lGm5OkA/ya9sAQfkx/46fnv
         Ukqbsd6ABuXh7xcgOhKgNlUQWtXfHazKFZFvqzXvMLLPQx+9ghVYd/SXfjq8vTWW0Vso
         bDKrb0cFiQCgSYxX3VsFEEGyDX1QK5nYn3QELEThac7ZZCYaHeRCUxbaWT6YoKCXZQK/
         EQchp4ZEiMGZhXlcezgJsMKJNgyylL+XtGG2Jy+A+ezkaZbwYhQHsx/0iJt6N8sDECdi
         lms7Vdk8jQCJys4UoYgHRMqj3f9eKCJ85LqDsIu4AvgNE4g170QSMrOmP941fdVuY0c7
         I+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859467; x=1795464267;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZCwhlg799dXefZN6g30kX8e7Dd77LrYQ4Kv/DAwnaW8=;
        b=lajM5oOV9a8UpxUyCbVxuAWTVM7MH0NDHLTwDYvMxLD6BIXv7hv8iPlx6bsYVN1f1v
         D9rdKZwh6wesFPH4Xoo3SF8X6sW/dk7164KdwmSEfkOFPgYa5z7I6GWGzq08CyaNnnR7
         Y9QTaQ3yui9tPhJ/bFvlGVChaMD0jwy0InfMJbYPNuNByfmJVtCqIf84SYjOihLaixhu
         WWYgqndRORKvyLX8sQZ6PaVP2JsEfD/fPi3vYzApcW7rtrYkZXj7YF3ReCuQQgOTZMhy
         tW23kLmbZGD3Ws13Awv7c0GYM1iGmwUNRr2mMbDtwy4e+u8gCifQoApxn50EGTDCxX8H
         4pww==
X-Gm-Message-State: APuU4Z8NQJSzV3h89hc4xcp9ui5qfM3wHFnmv6nINAGKyHNKfxhOPKwE
	U8MmXzjSTIqA6VkTkln8HvvOLW3FGdAswPNLFi/eh7hluDwxSpC64pAp/c5FCBD9fp0XWjv9Tcm
	8bo1OIyw+sje2kUOvnP5yl/yKljqv/HOIo9itrKsmKCa/hRE2
X-Gm-Gg: AYBFou1wUoJc43lP0EFlhMcDVEaBPK6mGXGLAtyHm0qNvfieFLD/YsylKbSN7t3cHhX
	UJA8j4asZCfY6IAY5S1bNjyaSdO+s+a4RoFrYxbhaYweep3fVF/ukAwNs7cTo/Fv0uds9TzBe5X
	xq13eVsxfS20P0aVz1aughduqyHkXFoS3kOUiK2m8SicF/z6eWLPoHm5ofY16+C/7sRM+iQ/nI/
	zZOZtCPdvGB4t9VIdV+lCryHykWY15JBj8r9Kq0tVNUrbLQYSf9Rjq8r8/iwru+mjWKPvtRc3Z1
	7YoWU8181ZtadXoZGBH72MZdKdfZodqauIDmOZ8eInNnMEdBZxIVTAmUs9T6PTlde8j8Pa6VrGx
	zaMEuG1RbP7PcokrizMVByflSe2QV8oQIN9gCYmO+5p+yEThhvyXc0taMVYa6cWt5uNLViNjdd9
	zVVCpNMH/1dl5Cyiq+htRl
X-Received: by 2002:a05:622a:1e11:b0:536:61d4:cc6d with SMTP id d75a77b69052e-55ac847c073mr171631781cf.53.1794859466744;
        Mon, 16 Nov 2026 12:04:26 -0800 (PST)
X-Received: by 2002:a05:622a:1e11:b0:536:61d4:cc6d with SMTP id d75a77b69052e-55ac847c073mr171630841cf.53.1794859466077;
        Mon, 16 Nov 2026 12:04:26 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23efa2edsm93065426d6.15.2026.11.16.12.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:04:25 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 16 Nov 2026 15:02:44 -0500
Subject: [PATCH v2 2/9] userfaultfd: refuse UFFDIO_MOVE into a non-present
 huge destination PMD
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-uffd-state-fixes-v2-2-4397a0196479@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794859460; l=2644;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=BudFHF5389gq/6rY8jRzvPbsYx2vICBEg7pYFFrBViE=;
 b=t3sAieLSS+OXzq7B52aEUhbXT4G+5zwO4OVck5koZlutX8gDRlKpXN98AOcvX/w8IcqgKUbPD
 QyCfUeDhDxpD1EXJZMVer+LooTq+cx3UW2MMtCDD9f0yNIK3ut+s1Qv
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: OGJ_s60dR1DP9E_ox4gmdUj89MlDmV2b
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfXxJe9+tEWvfZo
 fSNfaNMpEF0T3UP0IsBun6h5nhO3ugENkeFjF/xVgq/Ft76CtTXzCPMRW3N9iuJ9aorTwhMVRQ6
 VYLSJQd0QMdvehGW6q0opXzZ4h53X3A4eJ5fB1zMwaXuuYyloIzj
X-Authority-Analysis: v=2.4 cv=QfjzLcbv c=1 sm=1 tr=0 ts=6afb61cc cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=VwQbUJbxAAAA:8 a=tHa68p0SAAAA:8 a=n7zxJ9EK30Z5vFJJ7y0A:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-ORIG-GUID: OGJ_s60dR1DP9E_ox4gmdUj89MlDmV2b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX71SjZfyS01OZ
 TrMZeXQx87tmfgy0nBIlJSSJyZqRh8BOmBfASSU+R37czl8OHoBk2suZDso+xDXmdJ2aHgKv5vu
 lkmerqXKOfXRXND3HW3HtFTRLvFhO3bqrP9c0vsxjxi1N43VdTCo+8/PG/SAxKWWcHIbXSlajje
 BgQEZ6Lc4NaeXo/w8qmvKHXNe6rnVGnNpmNMxMX2AdWOg1HNfwBquYU5P1SEK3oWlNm9jXRHyoN
 +VTUAYcmEPVPCoRea3GLVOxc0WCrhVm8SqQivljtsayk3hhqUxOpjrk2Ww19ArmKFglJyoDkqHp
 4qHPsHKphvMuDVOpdtA1czE1TVyeb3MbjJtXoedGWm9WQHisLi/HNvobeO/wrWzLdbQnUpXbXn3
 5Di0hbrEusIl6F1uN0aucUqpA4Dfo2Uiv1tYHL4ccz9wnIsBJZXyTM4h+uD4UDprK759CxW1+Ro
 vxIrAWFMxn2ekPVUHqQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=10 suspectscore=0
 impostorscore=10 adultscore=0 lowpriorityscore=10 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160080
X-Rspamd-Queue-Id: 747DF1C0006
X-Stat-Signature: xk5sqg55ygoe8ienz3pcdwd759m6thdf
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794859469-734491
X-HE-Meta: U2FsdGVkX19PzBi9dNt3Syk9D+eTEp9iKaQ+yeEyEa3sFiu4y81xM4UKauqdsni1bImpLQWoYGzc+FtoBRH/q6rdKsU7JFtFwlF6te9jcCIfIahma18SO6Z6W5+cBmWceoG6EKqOP1D5zoSMO1Ujhz/l6CILpmd6HIzHvLo111ILS274CR2tBnG0sND/u3aZqVBE4bFbzvjQd0ITZHs7oo0QRl+4tTNLn07g/AEUMvybMJNMEo905KYZtfaC8ReIc0TFgGUpwlBR1tZlzl9NnEbO859NrVlmtKRCGBpsQiVSads7stX8Wn2DcbINRgBVSEIk/hGs7vtk1JMHQFPPIYvzRgVlANb0GyP8NYfdgaRbwx0oTXh0bOauMdSPD5e37cRd0NkBMp1BQd8GrbhmYZrYzvKydzB11zTSJQKONedQBlU92IYp2irpyW5xCAFV6eaxdhX31HoxHseChHJQYneLzx/veausKduDFoMwhTjMc0Ir5HUnyaV8Y6/pSoQx6SMKVS5dT6weV9HU9oJB/5MbTGzjSXoUqAFo3qjEvRgWIubkag3M86UwSI1AE+Y4iXn5kX4q7q1ndrXaflN984PyZpb6bn7XuDBqyCp01G3ch06fRHDQ+ejS0KP1NYBYIrASc+LtfyGz6kjB/SWYWvhpYDtjuzBJpoUEp2f/jY2Wn2daAku1aDpNmrfHqC0OtlwbflbaqKgxR4hAatjklPjSrjRdajrr7uV6Agkn4FKVtDX3N8IBLp5wteG8FKgZBWKCqPF3MYz0nHJx7W3xA97GyI1koQLSI1bED8DMsB/vA4GiY2V7/BPaEWSHX+6LpgE4dWELGj88RTYNCRRLCB/9s9udaegbcAU1fex4CAcGJcAAqWHdA2JXa7U0889i63zu4M26u87BCp/sm45itl/hPy7utdFdKEZU/JADkWfUh7EfIUD/uusXUfnGBe4c2m18bPxwjocewvk610B
 /hJBVlMh
 zVWv3wNKmVewuQjsEnClK0vPOArL2++2KkAPEolPvh6duujOh7EmDuBFY27iUgcapr6YvPZSwY6h3mFskdVPJP3UbUGkKt6uRE7q9uUFPCwyAt8lCDdCBhgxjE9YaPvd3npGG29QzU97sMkFX6wEx7zNZ1X7q2iPvymMW0n0XelYlaSayHQ2Qoj8vbiM38ZOW7VDHs2ZhUXEqdyvtzoayhtqcGqHShtemnkl3zV2kcfp7npgXlkA3LUUgNPnN4Vj1oa7tXi9sycmlogaYae+oMOdBDxNk+xtYhmq1qR5xoAJ99kuPuaTQnD2KM5I6VElzTH4HBa9gS53lBfgJO+z19W7Ska9YtzRIQYl5bwXk1Y8iDy3hsIWw/UwlefUiJJ4f/bbYmmpE+w+JhCRp5KOM7ynpK9Y6Dl0qLZ2UkXZeGDmWDr/0+Atna6sEsqRnk0jkhpXLYTh4Xyf7JxVYmX6ZCoS/JLNxsvk9OOJXIk/viUAmu49kDCXylsCpsOzbcE/Zeq1mg4aS2h2J6oVgNOlW1ijz6+0Vw/sqThBokX49jFL64st5uBjgYiblLnom9rLZnA/zwFDv62IJeNE=
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
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/userfaultfd.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 61a712e1f9f5..ad9d243dc64b 100644
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


