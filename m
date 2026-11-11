Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3EA6606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=skMHD/yh;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=GaBsCDPF
Received: by kanga.kvack.org (Postfix)
	id 135EB6B05B4; Wed, 11 Nov 2026 12:56:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1B46B05D7; Wed, 11 Nov 2026 12:56:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2826B05D9; Wed, 11 Nov 2026 12:56:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BBFE06B05D7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42A0CA024B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:15 +0000 (UTC)
X-FDA: 85423592310.06.A06F50C
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id B9FE7140004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="skMHD/yh";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=GaBsCDPF;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419772;
	b=hA5PPc0KsoB8vrrQ1o7xS1fWxRot2YSiZcI4YRNfeBHn1A3XvMhqPvKl5vvMjI0xW/naYs
	DKp98bwIcCS1AmbVoqdSfE80n/vkcFH+SDRydh3Okb4Wl+WAfSBVQkM6UMNQThbm+oZcSc
	QkgFmuf+38wt8+nsfPWEUvi8YTiQZg0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b="skMHD/yh";
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=GaBsCDPF;
	spf=pass (imf26.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WBv+J2+tviBYV2q/dbnc2XjYzZXGIYwmkmp3zIEQAQE=;
	b=IJ59UHMBeiog+hhKDqj0OH9zcopdeJaM0b8jdyNsbfe8ZEbhn3RO7J9NjuWRASKbHC55ER
	8k9bwgaR16NzKLYSCF4JvKIMA8/J1xxIQC2pXTXUQKw9xNSt9BPlkt8xGTfsV8Yk0j1k2e
	OW2EJ1fvqCbQcXbyY7r/GQb7u9BeuYc=
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYJ7k1158262
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=WBv+
	J2+tviBYV2q/dbnc2XjYzZXGIYwmkmp3zIEQAQE=; b=skMHD/yhL0b+juEJ8bBK
	90FcKnwvgP8LdEjYM2BRa1GRJTrlcBRieIWB4kzjmnCpkBVxTbhCNDYIYB4klSJJ
	YedlfPhnksj9gcQti+pbHdP8cgojvWXOB3E2cR96cKFyGgLqI3EhqgMKRbzF92yX
	T3S4vpxqYLDUmEngcjdZ5+3ZhE15dd9QBwqsrJP3y5ipFjacGhFz+Vm0c3jZ8hLq
	8tpgl6/Ne85jUccPfzKgKPRfhCCiqsNNRrFzxRiYxIsOHzTg2qvM8J8aNwiKDdJX
	XJoT0wH6bXFE8EpnwMEbMmqag6mh6aF7ICAjuWFR+zTuuCDkv7Z4djkZ+a6yVdig
	qw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvhnsc4cj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:11 -0500 (EST)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-536720195ebso68804461cf.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419771; x=1795024571; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WBv+J2+tviBYV2q/dbnc2XjYzZXGIYwmkmp3zIEQAQE=;
        b=GaBsCDPFT8zwfYIGKNBjZzaDVNiUSDBgeYxDpeZ29SGFIH93Ywx4Ww+0DlA4A3Vl8v
         CgBnoh5FXbQSugPwI4YkY2zSYgS1gJfo7H5hDnbqpYn0GSvN1T/pcaRDBuROJDCxq8Be
         NWk65rSo2AFqNNCF0Acg1sBQHONdb4lXgQ6YakScVZhmAZZaQ4KZ1lUcX38/jjIbxlDa
         2g+PpEFUPfpcdD6W0hs+Oxf5+7UlOpQD84QbJQrcVnbDF6Emgz3lMwIysjrEyAldD77O
         ZHpwTisY88UBf1Ep67PXsosJT4xuDF32T7MXH+AASbO48DdBFLIldn5qYEyKhyk29N8a
         hTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419771; x=1795024571;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WBv+J2+tviBYV2q/dbnc2XjYzZXGIYwmkmp3zIEQAQE=;
        b=HkWl9w4zqoqhVT28xStGC1+d5BrVjEB8yPcDowsYM2QLHGfwBgUJp9k0OYLr1c+Ic1
         fiXA+DyHOYYgtMpEz6YvzUrwXFdNvRpupLcOBdihbbZLEfgyy2uOFeorW1GDnkinSMBV
         IFelghMEzHNRhjF/RZtddBbCUevloeNuUda5UZcYzcLOoW8Es+S3cExGVyof9tgdFlYO
         Xr7AxolrXR2Dzalw0WVyNIBOj196ojrxAPEQheHm+8taarKNFGRG2Sc2SynC/dmK7MYx
         xNJDDXHYK91rKfmevjXrvKMU9GsRZh+oMPcOJ25u8zI4kCdG9ZtmWEtDTnUrmGTqsqTw
         yA6A==
X-Gm-Message-State: APuU4Z8vVyu+cUNkPVHgDE6Te1HGKUlXtuI2TlGIncarxV2vsd8mDM1a
	P5fqLwcUe8T5AtR+mfwO/MGwpK7MYAbAdiUfSsgaGQei20yRw//6AqluOhuJ8ggFU5ztMRv0tqn
	OcQU/esZjKjWxkCJAL6uXT8d0BxhXxQrOTSHFMlmapBXcN7PQ
X-Gm-Gg: AYBFou0YtqIVK52Z5v1oG4rbQgYgmALdREJqGGLUP8pdeLOgagjsDTfvNRfrUKF+RZs
	9IGiGmqK8D/TPXetVEEw27mIFaWYdRiRnD8TJEP9urccHCg/HJUyffpvipr/d0a81zRrIaHgwMT
	ovRN8ZROoTQY4m7tJcnNymxu6koSMqeLQnExrsh15fynpcw2vRE+xzuXFBWvIIPoQWgZSO0meBz
	lxfoxkFEB1FDskt5Se0XFapVgvtRDWg18EmYjSgF+I9EQKi4siX12sJlcPFfAySu1Y2OkHu4v6l
	ZTfZwVohLGQ/zwT38jDKVD+KgfgI046o/LZFa1JIgrED0L5IEkKY5gPpuovGLO6LXmX1eNBZPuA
	ZHYlZF7oAfu4q0MLymzfrkVqLb3l8As77hkRwcBt2VTOEj/YlQ4ZEdVzkzCa8SsI01p7ecYq0BH
	L9t8o4kFCpgyNTDEXN7Q==
X-Received: by 2002:a05:622a:1e12:b0:535:e5f1:393b with SMTP id d75a77b69052e-556bd706e96mr49217251cf.4.1794419771188;
        Wed, 11 Nov 2026 09:56:11 -0800 (PST)
X-Received: by 2002:a05:622a:1e12:b0:535:e5f1:393b with SMTP id d75a77b69052e-556bd706e96mr49216611cf.4.1794419770601;
        Wed, 11 Nov 2026 09:56:10 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:56:10 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Nov 2026 12:55:20 -0500
Subject: [PATCH 12/12] mm/userfaultfd: check hugetlb end alignment in
 UFFDIO_UNREGISTER pre-scan
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-uffd-state-fixes-v1-12-00713d368976@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=1887;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=QGRuzGiLMk3zkcIfTBxvpb0tKHGNzURyYH72Y9LpGSs=;
 b=zVrcDEAYCH1s+r2j/3K7D7hrzgJ9Hgjn07fWepfXvMyGJykQMyQ0cut1ptQLRa/2G6lrMYLxp
 U4bYjKscjxOBW72PsQrrASnKTsMaN+w3XHxLnxfIErs+DEg3ZfUkktl
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=S9lMU4sP c=1 sm=1 tr=0 ts=6af4ac3b cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=w5LpOudGytjZGezDRloA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-GUID: mFaTK88VVGhLSbcRDTbn8R01zsHrLm6I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX1wnTYZvrjlGE
 PZ2v+UkhotVgRqtgOzg8erP3rOmzkmGG4lAvPhxUZ8DwW8KvyS1ZrNQB4YFp+FuqlL0rCcirOYZ
 iRxykiA00wMETJWwYTE8vFK+/2fvjq/zNB63WCsiXOvGS9OZp6UmrDaWfTO1QclPauPfA8LpzZQ
 FNZkKSx30gPMDMTmwA2EK9WK4zWZOhdBMwvvg4PoeyYbAXrgUunISzdO9hz0FCMHJVnBJ7s0J4Z
 UbFbk2HOzbjJhv/6aMpvf/Y0N0IwJzhbICCnxM8gM1bp0OtmT3nvchR0s4CrF9IcNP2tkVMYg60
 uOIqcaZFlitkuz14qAyy+1V+rMquUEq5ktshx6fN/svvVqKOfsZxbI5gZHma6kmuIX98M4q3MHY
 hzuVGQNHFEGlYvcCrUP/2dEWzgKFe2v0Xxd38MStTkbMDu6dmbgLnV33t13KvPidIHEUeHYsywm
 V3kqn7pBBn/5uoAmkRw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX01OImXa3Bs03
 ajkF/BRNwLrw0p64g+YDQmaPAbB+TWibGSwcDYH2ry4X9KNCZ0HSkPWAfOgaBwnTE4Y1tK4NviT
 I0kbAsWFFLi51J3vuYeomYYBHSBBd7uNriPyeVnRha2olUxydBem
X-Proofpoint-ORIG-GUID: mFaTK88VVGhLSbcRDTbn8R01zsHrLm6I
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=10 adultscore=0
 bulkscore=10 phishscore=0 malwarescore=0 impostorscore=10 spamscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110071
X-Stat-Signature: 88yuge8ns37hgijhku661moyyeorrtsi
X-Rspamd-Queue-Id: B9FE7140004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794419772-979509
X-HE-Meta: U2FsdGVkX18oaYt2WUEVwV+6FWWWkaPLPBI0jVjCzbfI9e9e6sUE0vBmYmZCAeb+aYl9JZiMeZ5Wf5SJWeVZXxR+og4XeTd3stTmdEFrJBrf0oROvAw2Z1gRvyJAdY8aLiFtudmzjlOcHnbivjGRNA2BI8Yc4ALCaYJ9sHPt5q2HDuaWDcpwMzugH54vR7qxBfUISgph5bLXVte8mDiGvS9JlO3hfEw6ej01zJRSLDlSi1Job3plfXOC3C8vN0AuPBwuTvmTVtGdkb+pqd4XFSH5zVnnbFlJTWatvedXoxvKTXB8z0lE4w8O8nMXcRcRLnx+hGI3tY6I7zOsaIvSVllct+cRxz8rpGkGfcZRF3BtwWsEjBSs/zXtcGfTsCydDtDyfIFDjlRuawB700He4EGVI2K3zHJ2tUow/YNTw0gie3DfCmvjSsDf4Wsw8ThHdKlkP+uOpi0+9CF8KwiVNsy6edFPc6DQ4WlYOu832Luv/1GHMKkRmoRWIRUv1+1r+gjsD5Uctn3l9NW2uBkAg/+wFiSAu1jSkEDrEc4IYpxxYsxdwp97MYTh5AxKRThZvSr66ra3g6uerae3TTF5SuwQMR1BWE2H31lEuo2/2KVD4mkXVZ0al+LuCXIzctCup1NBljZc9e3G42miod8nmUXQBhD41XaCPVL5Z9ThGuPrmQcU3Zhp6urqQNjmgNcmRbPhtVJqZ9325jnE2ru/HBt5r402pgdB5AVERnVPODIxlmOJ/RTK3u0aq6ilBk8x5JkTdvtHM2IdwgqCNJ9QDMnPr4dZTbE0SnbVS+T0UsfOJU5YMytP10C11WldVkfmFfUWoDJROPoNdu0S+Yw6KB5NKnodpXKgdapaBuT21fiKI+jzMSO1eokenddr53ycvbanw5BM5YpZBoyyIsRibR1d4Vc2frvC+xI2hGkzWEZoxLGOeJSRkJ6728Kmgn7pCRiNcf+MbCM+5YDsDHb
 v0/b/+fk
 50J8rk/pqruRBIB22qEprLKunypwCD9hxy44Xt2n2vUDAwiaaM/zvKbKif1wACT+iPRyePRmgo8Hf/3Tzign+ejhG1Q5r5aYYFLAWDEjnXxoCv5invGjtjOxuTXGoSOdeF2BSKfO7kiYW8inPBEyaC8etLxe1/pVyDTRlZ/BnJYf9zFj2wLXwFCQBslI0aIlfBcbwrXgl5HSfKzyl4CtSxGK5CZHFt22X4VLSIz3y6zGomiR1P6eIKvZqdcSluliAxyTW/cvVGuIsrzrN5qPwkPvsP8cPccsgs+I/8mJQfrGxV8CeWoUcOv/aocc7F45+1ilPsyxQLvnY76ENqqE4ISG0hlI/ZPMD3e5BNtEtHGgzlZv3dtaM3u21Vo/Oo/qu9nFQPQd/pvliXQHMvYoAmSH1WML04FRM3cMBLzna/XO4QQmANfzKh7m/5Nk/oJw0nVLaxjbuI6/c/bVG9SDUFDrFsQvYN75KWv5e+E0TAtgzcbwhW1ikCDHd6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

UFFDIO_REGISTER and UFFDIO_UNREGISTER both scan the VMAs of the range
before changing anything. For a hugetlb VMA, userfaultfd_register()
rejects a range whose start or end is not huge page aligned there.
However, userfaultfd_unregister() only checks the start.

An unaligned end only fails later, when vma_modify_flags_uffd() cannot
split the VMA there. At that point, userfaultfd_clear_vma() already
cleared the WP or RWP protection. The ioctl returns -EINVAL and the VMA
stays registered, but accesses to its pages are no longer reported. This
requires a caller passing a misaligned range.

To fix it, check the end of a registered VMA in the pre-scan as well.
The ioctl still returns -EINVAL, but no longer unregisters the VMAs
before the misaligned one first.

Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/userfaultfd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index bf42fabb5afd..c0076c8b4e9d 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -3983,6 +3983,18 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
 			goto out_unlock;
 
+		/*
+		 * A range ending inside a registered hugetlb vma must end
+		 * huge page aligned, as in userfaultfd_register().
+		 */
+		if (cur->vm_userfaultfd_ctx.ctx && vma_is_hugetlb(cur) &&
+		    end <= cur->vm_end && end > cur->vm_start) {
+			unsigned long vma_hpagesize = vma_kernel_pagesize(cur);
+
+			if (end & (vma_hpagesize - 1))
+				goto out_unlock;
+		}
+
 		found = true;
 	} for_each_vma_range(vmi, cur, end);
 	VM_WARN_ON_ONCE(!found);

-- 
2.39.5


