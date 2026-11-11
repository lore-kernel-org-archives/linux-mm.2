Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49B9C606A333
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=IoXq6FFr;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=etAiFUGC
Received: by kanga.kvack.org (Postfix)
	id C33036B05D3; Wed, 11 Nov 2026 12:56:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9D56B05D4; Wed, 11 Nov 2026 12:56:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A10B06B05D5; Wed, 11 Nov 2026 12:56:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9BF6B05D3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDCE6120116
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:10 +0000 (UTC)
X-FDA: 85423592100.16.6FE1F3E
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 624AA10000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=IoXq6FFr;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=etAiFUGC;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1m96XzjKc63D1pxDC9K5iULQuRZ3Lw0ONUHaz7lxYvw=;
	b=Mkj9yYzm7CQOgFQMhlvnHnUKwL659YelnsZg+I20V7Xc0Ze3Fd/l3u+ZJkuu+roRUNNEpH
	tHbuwh0SEqDJETptlzTkBgHWOQN2QOSCm/DywTWkSzk75qBei0voXRcd+RgxIXDYpKoWl9
	pth2R4ipj/Kv1Kt9wTi5LySVixOH5oE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419768;
	b=ew/PpjfxMl9GXiI9T4Bpx7xkpYd2pRgaCRL0EE7v2FTV+PKYIun+VcvIz0SyaFAbVUl027
	Qk1NtPzjua4U4QrDcHjmsepIZSe+m8skR8vNRt7Lxdv6+gdG8nw3ZJiqQLj8Hd5nH1GvZF
	QAL5/B0gPp8sNmyIEmmsCaSH3BivuiI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=IoXq6FFr;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=etAiFUGC;
	spf=pass (imf05.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYElC256714
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=1m96
	XzjKc63D1pxDC9K5iULQuRZ3Lw0ONUHaz7lxYvw=; b=IoXq6FFrSN+/unNVsz5+
	2Hs3pEW0KIUhrP0QX5XPG4CTvatRl9NSOyvjksHELdcaza9rY7Y7Nbppy1C3nkz/
	CcA5j7A4Bc1X6pknSbbIQLQ9uxpw0LvpDFzvxWx9+MhniCBhp23HqinWZWjykycU
	pCiIqK0isdwNcj1pCW1HjkUcqrHJZLvgF2yFZcowQX7Tu+G3wCUylS9VvSgyiais
	uDySWBgXKNEHkl+M73KWj9a1/eDKUtQQX7yDE8hcPLFI3FTcGaDVQpRKttvF3EI6
	ULCK0IVlrIkvF0XB91wEG9zJkl5SaY5jA0Ah+xuZ1N9VLk88+iHaSMuguwF+yP1h
	7A==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvdfs55y6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:07 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-53661e036a2so69205051cf.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419767; x=1795024567; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1m96XzjKc63D1pxDC9K5iULQuRZ3Lw0ONUHaz7lxYvw=;
        b=etAiFUGCcEzRToEZo9EhHNgBs0O5bEMTuKhQKjytXyjoYo7b/snCaicVAgqf0rkUAa
         oyDzPBcsr3VSuGxoK9OMjutn5qDDen8Yb2w1KHIDvhRDseYH773q6g+yIvYrcGNwGs0l
         9lxkxS1HL2DDPAbA4ZRRqaXH81Rxj2tAf+ZyxgQA6J0o7nvF13C2uJC06LELAC8N7GRp
         7gqgeWyMzn3qcLIgZgzipWV8RexPXRor+J73bikSHlcCRn/rJkjClSeJPQ9X9Dxmxjk9
         4r8ahU6aIy11MckG5ch0x5rrAA70rjjB4xqn/fA9VgoRoMPmId7v0OiP4/a/wBs9ok5s
         BCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419767; x=1795024567;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1m96XzjKc63D1pxDC9K5iULQuRZ3Lw0ONUHaz7lxYvw=;
        b=xWsDrd1S3cTZK7VIBmoe604ILiAs/jKA7FBpVY8JjiFyTrY+NA0PYZa4xkgfankPT5
         PfjCvYySOYCf0WtphTcIkNFY5KRjYw/03Ye01LYTyZ3T9i0IPSUn+9hmmq4wBgY9R9kC
         MSkVJcACPf98YVAgTqGHxGGkKT5hNJvZVhT/85FbirOHFKnPmLBOpzFkrDWPVo8MXd3g
         g0+IUcJMunR3J8KeRZAM7doQlL/9hKkchoOQguvEeEvBriGcE2mk7dSTpjH/remebtRE
         Ju0TFXstYDFcuzSzBRsb6RWOgbVHktWs6gZi7LDaRmzMFq4ELxm38rXsWuT0+OmPy0dI
         SyKA==
X-Gm-Message-State: APuU4Z+/S4gVN0PfBmv6P54xxRT6s80T7k1hzG+h2yhrfTLMQasRvM0I
	lECbt01YbgW5kBEv5tS158T/ChAK+Mac46zd4jr3FmVjx1Obtb68CegCLzTJHJv4jh74zbD/amW
	4FPtEQrbXVTORd+kf2RRrNfkpywQv++WdOqx4iVNRoH15Vz+0
X-Gm-Gg: AYBFou0523XSHOm2+1tm4mCPcV3NVjka0CRu7EA/ve5lR8Q1w3sCKrC8VgI6SFurfEg
	N1dvMgY32+22E5WssFnaZZRwxvsybb5+1U10J+c0kM0S31EGBX8qMHOPPK0JkEGXfr+0x59iXW4
	n2KeAPxC9HHyVuFJRQUV5VrolQ98flbYhhhVC8XjOgPhPPsm3iR4KfhsqPZyhZ0BZ62pGfzGg71
	YEol4zlOAIXn5tFODMhp9hXIhFLQ+j61jMMqxfu8E6U0TT1XTqO8h8EqpIOnr0KIe9D84oGzNpf
	iQbatSdqvbjtuPBtQZSoPHDy4lucQDCFa3QwoC6i3fEsoF9rupDzLDvhwBAaaCwO2mAbZ1KjNSy
	Yex5v8NdT+m3g/cBNPxwDrMzH6jT2RWZKMN5ARUr6nUc99D+2l27kD5w4Od44jO/aP+L8O17RkH
	4sKQAxVpp6VGgc8QUKfQ==
X-Received: by 2002:a05:622a:1f88:b0:535:2794:851c with SMTP id d75a77b69052e-556c0bc230emr39978481cf.39.1794419766495;
        Wed, 11 Nov 2026 09:56:06 -0800 (PST)
X-Received: by 2002:a05:622a:1f88:b0:535:2794:851c with SMTP id d75a77b69052e-556c0bc230emr39978111cf.39.1794419765960;
        Wed, 11 Nov 2026 09:56:05 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:56:05 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Nov 2026 12:55:17 -0500
Subject: [PATCH 09/12] mm/madvise: let a guard marker carry the uffd-wp bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-uffd-state-fixes-v1-9-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
In-Reply-To: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
        Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
        Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=5358;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=yTu2S1wVIskSQmMr6++Ol3X1oAvYN0En5MUMkhISqr4=;
 b=tF6bHpiOSjDbkZSVUdJQfZcIPbwo3OAGDdUQX3vCXlP6lp7hhoSIAVpEWFKwdmHTKwsJttJYB
 xqu6iE/QaX0ApuabdUF7rkfy9FinxabHI5pcGslbVjJvQWJcG1etnN5
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: BJjda7QjH2aUX8bUthe771Mbo05d7Obn
X-Authority-Analysis: v=2.4 cv=AaokjHXG c=1 sm=1 tr=0 ts=6af4ac37 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=QOCMdifcju39GKoXhKua:22
 a=TbFgO4Jl7eDgA8pY8pUA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX4CMEEgnFNCSB
 MYhgGl5SSgL9cRVlaTWg+ERk1xZsfSGn1Pb2E9v/KXiliMMbK/9sLATC2ALgE1dLSl1q9OKyWLh
 C7qtFgq6Ar2RznDM/uFqNMDIIPSSLnuHTrfaLt4q8OPadnhf7mxh
X-Proofpoint-ORIG-GUID: BJjda7QjH2aUX8bUthe771Mbo05d7Obn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX9HdHXAyJnKaa
 xgeLY0o+8xQJeKEJBg2rHG2Pu3Qdf21g/mlmm43HwgQ1iCql3/WleOIbK9r7EaYPTqEC4GEQcPv
 jyRaqJh1NLkViGT3boP676qKLkdiTgvYN2cjummdMHfCpf6y1zefil5qgqsHK7Y10mlUS2OpzFq
 DdcPplX4ZRBX7hrm38tJON+fXjvRGI5xdX2StDsmVFQpPiSuIA9hSA7EP/XfAytYWr4/K+qCizR
 731yHiDD2QgEXq6jhxfgoH+AXqF4U7vUaOczJKWZGx+zICIrph1i7gHcGZ/13LBrS9LHDnGFG6K
 Jc6hxODXaGkVZz2zwyf1mTSiACofweZqkpa8JQD9l9OmhLCJ2GqwPyLYk30+IRf61Klq9r3AQpU
 70yCOe8PmZC2+CRr5Z6qXkG2mPnj0GTi0bfH5haV0+MceIb2H+d2jsmXVZbJU5U0F3nW2wk8W9K
 dMJWP1KckFoU0ExKLZA==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 lowpriorityscore=10 spamscore=0
 impostorscore=10 bulkscore=10 adultscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611110071
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 624AA10000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kdcuineur5ws5nmboxcmdazxrd8i9k9p
X-Rspam-User: 
X-HE-Tag: 1794419768-638333
X-HE-Meta: U2FsdGVkX1/+xLD/yvcVXh52BoQ6QIQAF9k1dunA8jdg583aT9apwL+eUeysCpVmOOj/uvoQxvRxl1xwrjESigAGYSgjd77Ux5sXkqmcK1i9IPrc7rCpwx8N9uc21PiRyF32lvUnrlJ7EJ9dVLjiyWzq392C9z4CSG6u7qOmvog6JqXBTSxdGPJYVbNHo0qVY3NBj4bss7eB2H2zgD+sE9qGfT8Qnk06QjVroUIch7CTmKJ5NFWzxdRz0rirmOeVUUUByuPvaM45RL6oQ2VMW1SXkwHLtKQ0/MgeIfzKYt77odqHIDNOeSrGXTmQzJ+F8HROKhofIDuEqlO/FSmi2pVV7Pffb0Yfb+qz8OIHUyR4N8YCNnB3WQ62NIObCARpI721negBnSQy6f7aTjt59TNOVaJDi2CGdRbEQ5Te42KGiPLcJtfg5Az6ovNOq/DU0V5CNIGjefnge6PS4wt3Yg3fUF7e2hXeP3JrseahxUUpqDU6smZR044q/7LNrcPbXwebvTU9LGHv72akgyaZLQ6jDmB52cYcBoEiORgJxoqHZ/IAwO81vJ6BoQNQvh1/gUzxVXECZrOyp8v/UiGNe4/gB8YRjTcPsIUHlSUg33xlTF7TOTlScm0+hr8epD1ovndmHUvp6XAMm083lIqSuTCaBPytHZyrsYk4rXCunjJzU5aai4D+0DiXB1afWx4v9dgnTmrRgU1SvArIrZeDDSBTGH8ZbT9QtWvBmy5Sy8vPVIp2L9TeYXRxdRr60lIpydGz4ZzIuvtr/5kUfLkCLlG71pe2nmFj51BmrdfOGCYWy/5GjSxmXjj+Foyk3dhPeaZ5zt/Ecq8HmHin6pqsu39FzRWlLz0lSTSI9kPIH0LLei1qw3UZsq4nxq2OuBX4wUBhMBg12CMmodSVEvH++apWocjVHUoG1YNanlVLQI1RAZvOoJZDedU1MPCigA7agAbLxMfRfpTVolotWG2
 JZnJYgNY
 yE9Px+TGQj3+idnq4IWgfT+rjDoVJHPwyqxgeCxr6MLFeGXX5NnITwCSLVgZX8BQ0qN1rbZKKYbMMJO3i8sbbGr7xJXWLB3XIqjg2zLwiSQks4QhFcPAQum5ZImAsXEST11+r6Jb5BS/1c5XAu0hxQtRSzGitE1cW/76mAEVjuimec0ktqJYa0LTA8QQyxbn6qG/iFgbZ0iQ5V4oGP0Zr2HXl9RWzkqaLXVGl0z+VXrvv3draRPf9yPqjU2TKvsCQDc3aBrPZg6wYQbSnSsUWazWpTz7+IhzSkb5zXfKDUmDIHjO2uHksxhcsiQcksMHUk8jdrzzDcVHe7bJfslTGFng30lDFDr/LSwohovA5MtqgA/EyfuRNOko0JWgbGUu+x5zYOr6wOaSxbK04/OLbHicySp8NNmN0wUpO/vyQ+yyIHOO+1CwsCVT8efI7b4bP0WB1ItDfFntoSHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MADV_GUARD_INSTALL can only install guard markers in a range without
populated entries. It zaps the range and retries, restarting the syscall
if the range still isn't clear. On a file-backed VMA registered for
uffd-wp, the zap keeps uffd-wp markers and converts write-protected PTEs
into new markers, as the pages are still in the page cache and must stay
write-protected. The range never becomes clear, and installing a guard
region in write-protected shmem keeps restarting the madvise() call.
Signal handlers still run, but the call does not return until the task
is killed.

An entry that is write-protected must stay write-protected while a guard
is installed on it and after the guard is removed. PTE markers are a bit
mask, so a marker can be a guard marker and a uffd-wp marker at the same
time. To fix it, let a guard marker carry the uffd-wp bit:

 - guard install adds the guard bit to an existing uffd-wp marker
 - guard removal clears only the guard bit
 - unprotecting or unregistering clears the uffd-wp bit of a guard
   marker

The fault path, zap, fork, and pagemap already handle a marker with both
bits set. However, pte_is_uffd_marker() would let UFFDIO_COPY overwrite
the guard, so make it ignore guard markers. Anonymous VMAs drop uffd-wp
markers on zap and never get the combined marker.

MADV_GUARD_INSTALL on a uffd-wp shmem range now succeeds instead of
hanging. When the guard region is removed again, its pages are still
write-protected. While the guard is in place, pagemap reports both
PM_GUARD_REGION and PM_UFFD_WP for them.

There are two simpler alternatives, but neither works. Zapping with
ZAP_FLAG_DROP_MARKER fixes the hang but drops the write protection: the
page is still in the page cache once the guard is removed, and writes to
it are not reported. Refusing guard install on uffd-wp file VMAs in
is_valid_guard_vma() would break a combination that works on anonymous
memory, by adding a new -EINVAL for it.

Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/leafops.h |  4 ++++
 mm/madvise.c            | 28 ++++++++++++++++++++++++++--
 mm/mprotect.c           | 23 +++++++++++++++++++++--
 3 files changed, 51 insertions(+), 4 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 4c1476ae3234..add4968ded44 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -578,6 +578,10 @@ static inline bool pte_is_uffd_marker(pte_t pte)
 	if (!softleaf_is_marker(entry))
 		return false;
 
+	/* A guard marker stays a guard, even with the uffd-wp bit set. */
+	if (softleaf_is_guard_marker(entry))
+		return false;
+
 	/* UFFD WP, poisoned swap entries are UFFD-handled. */
 	if (softleaf_is_uffd_wp_marker(entry))
 		return true;
diff --git a/mm/madvise.c b/mm/madvise.c
index 0214efd2a014..e2c6b0f26672 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1123,6 +1123,23 @@ static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
 		return 0;
 	}
 
+	/*
+	 * Zapping keeps uffd-wp markers on file-backed VMAs, so add the guard
+	 * to the marker instead. The slot stays write-protected once the guard
+	 * is removed.
+	 */
+	if (!vma_is_anonymous(walk->vma) && pte_is_uffd_wp_marker(pteval)) {
+		const softleaf_t entry = softleaf_from_pte(pteval);
+
+		set_pte_at(walk->mm, addr, pte,
+			   make_pte_marker(softleaf_to_marker(entry) |
+					   PTE_MARKER_GUARD));
+		update_mmu_cache(walk->vma, addr, pte);
+		(*nr_pages)++;
+
+		return 0;
+	}
+
 	/* If populated return >0 so we abort the operation + zap. */
 	return 1;
 }
@@ -1259,8 +1276,15 @@ static int guard_remove_pte_entry(pte_t *pte, unsigned long addr,
 	pte_t ptent = ptep_get(pte);
 
 	if (is_guard_pte_marker(ptent)) {
-		/* Simply clear the PTE marker. */
-		pte_clear(walk->mm, addr, pte);
+		const softleaf_t entry = softleaf_from_pte(ptent);
+		const pte_marker marker = softleaf_to_marker(entry) &
+					  ~PTE_MARKER_GUARD;
+
+		/* Clear the guard bit and keep the uffd-wp bit, if set. */
+		if (marker)
+			set_pte_at(walk->mm, addr, pte, make_pte_marker(marker));
+		else
+			pte_clear(walk->mm, addr, pte);
 		update_mmu_cache(walk->vma, addr, pte);
 	}
 
diff --git a/mm/mprotect.c b/mm/mprotect.c
index ef4e7188e24d..6cc5b99b4185 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -249,9 +249,28 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
 		 * because any access should sigbus/sigsegv
 		 * anyway.
 		 */
-		if (softleaf_is_poison_marker(entry) ||
-		    softleaf_is_guard_marker(entry))
+		if (softleaf_is_poison_marker(entry))
 			return 0;
+
+		/*
+		 * A guard marker on a file-backed VMA carries the
+		 * uffd-wp state of the slot for when the guard is
+		 * removed.
+		 */
+		if (softleaf_is_guard_marker(entry)) {
+			const pte_marker old = softleaf_to_marker(entry);
+			pte_marker marker = old;
+
+			if (uffd_prot_resolve)
+				marker &= ~PTE_MARKER_UFFD_WP;
+
+			if (marker == old)
+				return 0;
+			set_pte_at(vma->vm_mm, addr, pte,
+				   make_pte_marker(marker));
+			return 1;
+		}
+
 		/*
 		 * If this is uffd-wp pte marker and we'd like
 		 * to unprotect it, drop it; the next page

-- 
2.39.5


