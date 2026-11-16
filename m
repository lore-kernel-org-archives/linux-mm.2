Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB5F60A2605
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=KAnwt9fk;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=OHzHkhIB
Received: by kanga.kvack.org (Postfix)
	id 40BB56B05BB; Mon, 16 Nov 2026 15:04:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E37C6B05BC; Mon, 16 Nov 2026 15:04:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D21A6B05BD; Mon, 16 Nov 2026 15:04:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3A6B6B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E684A76BC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:36 +0000 (UTC)
X-FDA: 85442059752.24.B2C7948
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id E232840006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:04:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=KAnwt9fk;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=OHzHkhIB;
	spf=pass (imf04.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQkHPjvXTTfeJYiMDE7iqXQPlSmcQWagnsIUKGmFjtY=;
	b=tGlSDjYp8MRHEbqTj/XIHQEhbnx7RTQuwhNpfdiNaiHHsLX4oyU/A8C1W+o2zmB/1FxDbs
	t+c/OxrH+e49HS9gnfULb1CrFfa48BTa2i4EIBcwjXRBmtX3ohdbGPNjy2BM3BVa7s7mS5
	n35iDJUFqR/u6i1cjReQ8gibfJZNz4g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859474;
	b=PmnZ5/5syX4uVainlIt0t34ffchyVaVOt8qVuL5Hjy8c26sfeRKr1f6XcCt2rIkHVsgJYi
	hmx0+i8egfMVhNgD3x+qTSTZtTD13knvcpSLUuMb7rydZJjZ9BAaGydyytk2Lgm4qKxrOZ
	7nVuwbvCwaJLN6bAts6Faw+1/X+28+w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=KAnwt9fk;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=OHzHkhIB;
	spf=pass (imf04.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGJXQvU2058223
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=CQkH
	PjvXTTfeJYiMDE7iqXQPlSmcQWagnsIUKGmFjtY=; b=KAnwt9fksP0cEvD3SzpN
	9AHr1JD8YwIZZF7LgL34k+/R6ExO5rgOpJUVstzTUm3dJ4FA3uvt7DqyIbplzF2f
	Qbyr4yt+DO3jQvpkf5GuJBfPa7QjJuhiXKlJmkylAWNLQlXTkXd0qXCKm/S33A4P
	R/e28+69oSVVV1TkO/OCPmTh6bKgFR9BezPq1Zg/ebPl6xQ34+Vl1eRO/xJyv8mp
	wpeZTs5qT5F3ut1t1JQz+4YL4reEX7etf8mk+c7HcTyjSyFgzg/kxGlIpRaen5ib
	4O17GeTpbLBgeQ38VvM+3Fcl0TK7hH1BjriAXPGOM7HYLZOLyvwuvStQZYnxA6YD
	PQ==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j0583j3gb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:04:32 -0500 (EST)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-91f2b449480so67891606d6.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794859471; x=1795464271; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CQkHPjvXTTfeJYiMDE7iqXQPlSmcQWagnsIUKGmFjtY=;
        b=OHzHkhIBRKiLRI3hfdEHHsrRHQL05DFJ1zDYfT0xPm4q1hRxCCp9dfTCGZvfvHPPRP
         Ll2/MR1n5NoCooEHUXBLR3ApezyB3xTw02yQbpOQa113jcd3Kf4yG8/2NYQhg/SQl+Zy
         gdou0Npv39o2Xaw1HzE/vswDHDMKzfCWlq+jIgH9UODmsNVLf8QDOoTbsTWKfk8AZIll
         ZD3R/KkqpBJvDDWLfPrsVnnDS6qH59t/beaCeRmtGX9x+J3XYvCrhjvp/s4GFz9EJYB8
         HniL+Q6Nys9efKh5Q+QVnC2XurmWSugeYOyMN7DwlcxWN0Ez8g1eYSf0c7zbRTg4dChU
         tDeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794859471; x=1795464271;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CQkHPjvXTTfeJYiMDE7iqXQPlSmcQWagnsIUKGmFjtY=;
        b=lt2ruzx4b57ao5gyr65jRG9hPFs2a43QEWFoWJYmPsqcWmCAT2FiKEXkDlM4bX0mWc
         iSlp22rrdFLIxf/FiUKwAPRnse1ON5i1o5Y4VVN/U4S6cFY4gMTNteOlRn6NfeWQ7OLQ
         +diVE/5ghVWvSIGveNdkIKZ1ydsnZFhn/Db5kZYyB2ER3LSLMs7p2dmHXBhQuOEW7Nif
         5qfDwKopD/egA39x+ZQ2RVV7LmdfRwsALjaHDesH5M9jFY+0MG3wCX5FbPCk8BqVGkSE
         8FBq5SC97+VEMYwGfICVSWSOLj/4PdJcyp+YvXz+3OkSm8thGXxO2wflLBGCjjOHnP72
         YnNg==
X-Gm-Message-State: APuU4Z945UB+KDh1TJBJkE+oGK4r13J8/48FwB1waCCkwhG5UZNhyY3F
	6scOwAb5VQfdBcTg2Mx/Rr+QDEzjfBEiwEnHEQewLMojmhkT6txRBSGuZ9kKWp5elbvhi8uXx7Z
	RdGazTTWZccUfV4+1Zw40zTxmTCT450euOYMVmM90duXV8Vex
X-Gm-Gg: AZFdTZcup2SmLgOfO9MW3INhgBmuv5JI9zo/rq9ppIQK/e2QUfSorM0rwuV6ub+Og1e
	1w4AOWwxbuPOK7lDp+Mu9XnaAwdNtoaCZ+HvZYZ9a8dD015DoMOiTP/kwFSVMqsFgnnvJPBQmao
	uXaSm4YMecYRb39WIVnUJ0ZdxyaOpuloipO9gZl1m/afJgIdUesEwEU1uPk3Mj1NusBk9w8YOV4
	wWdaaZ/Alr63YLkbOHD3UTGmzPoZ7aEEHRtEEPYZDLwlUVOUmIKCh5cd/o5hHomO+sO6FKheI1t
	r4Xy7rlb1hJjsbM0eaPFXZALyGSpYjxvh/guRloczsQybZs+9LmQFSNJBRS0je2DUb0hciTCydy
	J8k59HA9+LLWWKkYhtlxhj7wGoF1xKu85hLWb1c3KfnZ7zpkfYluwnJRRmfHdJ+QDTaEOW98kIF
	gnPupmRmfONfKiFSQSPY1R
X-Received: by 2002:a05:6214:1c0a:b0:91c:359a:3263 with SMTP id 6a1803df08f44-91f24025642mr190254506d6.7.1794859471113;
        Mon, 16 Nov 2026 12:04:31 -0800 (PST)
X-Received: by 2002:a05:6214:1c0a:b0:91c:359a:3263 with SMTP id 6a1803df08f44-91f24025642mr190253756d6.7.1794859470498;
        Mon, 16 Nov 2026 12:04:30 -0800 (PST)
Received: from [127.0.1.1] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23efa2edsm93065426d6.15.2026.11.16.12.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 12:04:30 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 16 Nov 2026 15:02:47 -0500
Subject: [PATCH v2 5/9] fs/proc/task_mmu: write-protect device-private THPs
 in PAGEMAP_SCAN
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-uffd-state-fixes-v2-5-4397a0196479@columbia.edu>
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
        linux-fsdevel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794859460; l=1714;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=DVXYKxTIAEZp+EXI/8oQ0I7+4ALNcq1SSndANYXncjE=;
 b=6+ELPvQGdStv4nKd8pN8sVCMbZBLqnzKv/qqOoM+QS9mkKkH9crx080ucQzM33gtlLJ8mzVNp
 0+Vap0ml9QVA7VLHR+Fr+p7Ra3EaXSyU+Vivwbom+Y1nClSCxWJsRg+
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: 2-tvZQM03bFVsrwToClnxxToupMbHW9v
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfX2GDAGAjwXg67
 Ui5L39oLGa9HhVU1l7X8UrASqdI7lbcv2Gmo/sGpEXJiCxBe05psmTrbzyH4p83b6dU2+qNdFvg
 bhqTkM/c3eBXpHeHXVG/SemA2TVwc2qWNtcZ+NwU5xqALnZchsJY
X-Authority-Analysis: v=2.4 cv=QfjzLcbv c=1 sm=1 tr=0 ts=6afb61d0 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=tHa68p0SAAAA:8 a=RyLRxA_qM0uo8G8YelwA:9 a=QEXdDO2ut3YA:10
 a=iYH6xdkBrDN1Jqds4HTS:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-ORIG-GUID: 2-tvZQM03bFVsrwToClnxxToupMbHW9v
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA4MCBTYWx0ZWRfXznpNn2h1ZEGf
 cgas5sN17cYCFP0OXCxh2F155aAVcskWCg5QLbqTbZAcY3pt9eHDOB9xZqSb0EM5epYLxb6+YMl
 ISJ8OkmAcnC8mFTKr6z5roDAnZvn1i4myucA2wPJeOrOjSyll1HPv+gupFztjHvyszBvtjXE42s
 DkV4Iuvw51DV8ANokN4BnCGIkkqMzexR4TbbNLj1MBnOTtlJrJt3Xuhph+JEGgu952VJs6fnggr
 3R4EtWy8RCIZc9cZrRkMutgSFIlwGE5afeWi5FaLkBe/usB11N4khQNAVNr2QM6Q0jOiAC+qIWj
 eLRmkhsFx9bIpsGXYfFguxxg4QGtTvldAafcjlBl5adkPzKewL105LwwIvz/5KZRwiO7UCh8Njh
 oiiF0Ih8VX1qaNHRH/71EWr1S71iRoJMwY4ePoFu7URsq7RZewBjZBdXoPA9Jtc/ghLjmyobAqD
 4W4a1gQQ4mzDYbettWw==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=10 suspectscore=0
 impostorscore=10 adultscore=0 lowpriorityscore=10 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160080
X-Stat-Signature: tfags6irehih6cbmx7gu58eso4ik1nns
X-Rspam-User: 
X-Rspamd-Queue-Id: E232840006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794859473-823988
X-HE-Meta: U2FsdGVkX18ZxLJIutIkwP8ydg8x5A5SPB7TE8Ypg42F8vHZ7Pea+Hd4w0xIr0MXmW7kjxyAPGiIea0+oUeDqYXvD2l3GAPgTTH94H39rkeFxOhSQyBxf3ak62iFazefcyL5EjgWwKYH7dusZt6l3+GK2b1VL1J1m7tzszRMTw4KQ1xePs7PF4FihnpQs+H1nMeyjEnktOG5+BNCe0fbch3++wlB6kNkr9w1GyLpwwlx04gAsPsHmwLFaNEOktv/uJ0OEd8547QrlPgCWAgeptaj1a/5H0hWKQef2gOIbLL8F8j4vnHAHjsViiNX76rimAjAkDh50WPOV+6FuAO0lMVfwmu4bnUms5M0hlUmqKyM6jp8FYdocjEydlB+NR1DXVFb/rx9gIr8snubER0fOe1ldq5M/YsdBfrkkeYuVbwuzzeCrgZboxiqaIFkT7SOl2h0eP7ZrRNswtUyY6BeDALyIera80q8VvcasDXPBsV6nReypH4jgEmy3UlYh716DoLaxCSzxCZmdNlE69HGxjOtkcj4+95ofZnlq2Hzo7tSCmj0yUg4jzau4YAlsaXoFWkinOp3YCog+334+FTq+s7M1Q0fNi8FW6kOy3Zyfq6L4kPEFyJEvO2qMAPE3HzDFdbrSq67p/FLOWSuBdhenoVd2p3uSVAnIZt5fDOUVO7isQLtckxkLPT/6fJJDOpYcdht4jiSAZcpfaWLjHtmjY4WmIRQ3Np982zcbwBVKre7xVocpAAPvZiUBUhkwy5jFCykGbdgx4blLDnorwDdM3ECE9d0+4FqVMyH3ogiL6VufF8kdqNX1Q3V21yGuRxwf0V5ycG2bU8wAZpFA8cR9JofVtBe/BZM73kV4j0o/ltanWxT9+dE2ALzW7s2cAeZUIPyG3YsLMnsgzH0d6/0XFVZqSSZyn2UUuuvjghctCBfQLl3Bj9wAiPhFacccLd642SLiezAcFvyLRI9wlx
 ahGQar3V
 8W9ylkKxlcP/15chVq0N4OapRrgZV303coXQWKpA5PR9++I+bCwNd8+Qz/90uUbTjKI/Hg8kTjAskq0Gi1AOvvddLZHiRG7P9As8zxVnQQnspoW7mTht9IjDf9c2vrl3a6e1yigec6jLvMjaPoMNvjcCWfZ1PrY8i/RBtG0UrFYjBlbysUq0Z22mCc6ZooUV/MsP+ZntENX6AVEdh6RsEQLYiHid8j8tD3ufCV3o73RsgOsQMekDoRqGwWbVOWkNYK1g7GgGBnqpqIMxTjH+wKD+ZFk7+XGLmN/Rb72r+mRRCzpNg3+lCFTsY9aqVLYcei2ENSWjZTBjPSpcTLu2cz89KkS1Slzdv+o2RMwYiM/7N7jT/gWd4S6Ny+p/r2UzPeh+K/Q9sswmvI17k7AIAw7XJNwaiIQan8dlfR27RV13aQHWFGQPCnyYFTfQ/XHN7+yIcJ3zJ1n4e40g2CQvvquTwbkV5oQQHAndIWuRigPJrwuTRcNuutHrkTd3PtnuAlhj4rRyCRJxWCp5l+rxYjRR4pi94pKoJbtD849BhIzgmf3Uqk5nnC67zIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects a huge PMD through
make_uffd_wp_pmd(), which handles a present THP and a migration entry
but does nothing for a device-private THP. The PMD never gets the uffd
bit.

pagemap_thp_category() reports a non-present PMD without the uffd bit as
written. A user tracking writes with async uffd-wp therefore sees every
page of a device-private THP as written on every scan, whether it was
written to or not. This requires a driver that migrates THPs to device
memory.

A device-private PMD must be write-protected like any other huge PMD. To
fix it, pass any valid PMD softleaf entry to set_uffd_wp_softleaf_pmd(),
not only a migration entry. It downgrades a writable entry and sets the
uffd bit. When the THP migrates back, set_pmd_migration_entry() carries
the uffd bit over to the migration entry, so the write protection is
kept.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/proc/task_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index ee7f509d376e..013eeea7d1a3 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2520,7 +2520,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 		old = pmdp_invalidate_ad(vma, addr, pmdp);
 		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
-	} else if (pmd_is_migration_entry(pmd)) {
+	} else if (pmd_is_valid_softleaf(pmd)) {
 		pmd = set_uffd_wp_softleaf_pmd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}

-- 
2.39.5


