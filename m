Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA2AEC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E942A6B0088; Tue, 15 Sep 2026 19:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48226B008C; Tue, 15 Sep 2026 19:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D340E6B0092; Tue, 15 Sep 2026 19:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD73B6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D96D1205A1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:31 +0000 (UTC)
X-FDA: 85217567862.08.F5764CE
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 125F9C0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:20:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lav8+JiM;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=oetW9t8i;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789514428;
	b=wsePVnD27uusfMwmmUK8yqDUGxns6NQ4+rDmVKGgrqGte/ZB/VkThMlYfBa3QJO4Om2eHZ
	EudbncTWvIQLYB4gDYd5iPZ8RR+Ej4hfgQBNlEbrZKgKRvI4QUpqM470iUoOd9K6oLcC1b
	C8v+X6DIujITT4RNm0LmrKBUEkmlo5s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=lav8+JiM;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=oetW9t8i;
	spf=pass (imf10.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789514428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QWwaDMx47FvPA0K/+SVrw7qA3B/CVOWD7eNhZlTng+o=;
	b=FsXkzEY/yFaupNiWGcnTSQMdvj1ey72KMCfjd+L6R1chZB3KKd/DCFzRdDl5hXDsPyoOen
	hHhnTGAlWXHW9YCtP9gY2nTVXDP+f6DfdlEjvxem2ltKDSQ+z4rowokrQnY2DYNRtGxnGD
	P9cOZq3nhm5SuODyo5739Kg52ZJBKhg=
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMbWjb3384135
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=QWwaDMx47FvPA0K/+SVrw7qA3B
	/CVOWD7eNhZlTng+o=; b=lav8+JiMyMkKi9wR9Dww7nF594s5bZDigLUeYTG+z7
	XGiio/3e6DVGS4XhOrCK1Hv7tVy3wuqisMGIOheolIcwOzuFunyIqgcgRWQRgAZW
	TxAPWuNWkQ2rvufrVgf6gSZ2c2vtq5s/x8cMNek8H945TYQdNLsrwdgVku2THdK/
	5SilvzzX4by/UbX/9q3eRLFp6bwar58ce5p5u5blhdLRQslAP7Kvx+HFIlUDvqYm
	AQ1EenPAJGNjv58pRWEs5wv3WNiDRXVSKv8mejPI6f0XP1R+gfC/0C40PDF/mqNE
	sJNyFRaQ/uRomqFBnl6eAv2TBV/XNKjLIBUNluy8TVTg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbjfad6q-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:20:26 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-939d6c515deso1014795985a.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789514426; x=1790119226; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QWwaDMx47FvPA0K/+SVrw7qA3B/CVOWD7eNhZlTng+o=;
        b=oetW9t8imaSH9NG+4A9uBR95L4Ss50MgzxkU0+grs+6UxBMr16989uhw02qS1BHrz0
         c4HVUTDX8ZeanAsYVXsm2ksYw0N8Mt/RVWqGjJFW6yS5XB1k0FeAXqiMTdJbIazxV0lr
         ASJ4UmKq1jFP3XFmu9h/4KRm7Qup6Lg21K6JwzXbtOCq8IWcR5ntyCJugZpSMX50A1K1
         v3p91F4I570TSrHp6xBs9MJeTadwvSEkU5Ib2qjptbIjgxkDxt/SIxJmdXdTwIJXRBpq
         T+J2dgN9UjFu1qz0tNwScB3VOFmbUB4P5cuhrpyD3zPtHV0SiFlISRPz3Wyvr1ysJhzS
         P1UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789514426; x=1790119226;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QWwaDMx47FvPA0K/+SVrw7qA3B/CVOWD7eNhZlTng+o=;
        b=o26jIbehbw1TVqLRmcIQHAR2M0zc4fPbiWOPmE6C542RfIIcNsdF2bRcAM1bI7HY6o
         XecZHN1kuUGrTjGjNEBHl5NV+FOiePXotEQCEQmIVMWklCzgYuCT3mFBi1Q7cgC8P0vn
         65WxXqon4XI8a6h6NU2+wmIskA+Aa0E+lXe69x4ol9RJn94nNTR/FzLNDdHot6hpNmZo
         H2JNrmHd1uTJASxv7F4bL48x0zqOzg0LZyegpzUY8hvaG2eroe4vsVW/rx0iF4K3UxdH
         OTTzA+P/VfOkMhaYRkNhx2+Dj4WeBwD0oxv5Gq3xaBzRAhQYRTj1GnZlRQcV/sMXBE3P
         4EFg==
X-Forwarded-Encrypted: i=1; AKwUvByUl7nOD1BaeizrsaS/kPa7XHt8vXEFEIRsmaKximObJeHMj+wxiv+PLJCHD6UYxyriRbKDQ1UDdg==@kvack.org
X-Gm-Message-State: AFuF++lX0l/bCc2GqS34RA31hw0f0eEcEGwENQfJqWmbo2JHdWCUIzbZ
	qAsqJvdErRAhCRcFWUVq/8BkLYykky9f0wIYTRTa+kYJ2hoiCO8zTuj+C5nuGZzGf5WCeaTevYY
	NM/MK2hA6g+rzqx1LUdFUFmT1s4VU5/l1EzuRYzPVMKSVHD9O
X-Gm-Gg: AYBFou2s5P8o0JzAKGqYU1h+OqY6jtuNINc//CqaaM+gVDf3FTBB0161eezzG9VvUGX
	iN4oqpWeTrn5TvSrNu1aUWBckv3w2FO3dIoB/k+8LTaeLD9rl2PnXOdq0WPXrJJHa/tn8dSYLW8
	xagZcggCBZGa6TxIXk+X7vwWFVK7OD6+CQSfsxXvUocW5bF69oYKBEvOv+Z5r/ui15t9TDBynol
	JIq+Rbbc+Ts8Dl0B7ufUYDJKoidDUHu5wKJ6Q3/ykuq+C+LNO/465006wgmDXwtdEFi+OyJ0OiS
	pP8YY12t1H02QdNhbaKcWv1iKR+tpcRFseGRryeaT3NMt3Y2H9uqNYA2ZtStdaUPtWpZc71LYep
	PhiCf2Y3WGAWgHhnemAs4Z9pjvcAD73+r4bYgeGILpU72h/B4
X-Received: by 2002:a05:620a:17a3:b0:939:8905:ce9b with SMTP id af79cd13be357-93bb77461a9mr62666485a.17.1789514425632;
        Tue, 15 Sep 2026 16:20:25 -0700 (PDT)
X-Received: by 2002:a05:620a:17a3:b0:939:8905:ce9b with SMTP id af79cd13be357-93bb77461a9mr62660985a.17.1789514425107;
        Tue, 15 Sep 2026 16:20:25 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93b781dfde3sm77151085a.12.2026.09.15.16.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:20:24 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Subject: [PATCH v3 00/11] mm: memcontrol: constify the read side of the
 memcg API
Date: Tue, 15 Sep 2026 19:20:04 -0400
Message-Id: <20260915-folio_memcg-const-v3-0-c239a6010b58@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKXSqWoC/23NzQ6CMBAE4FcxPVvTLhWKJ9/DGAPtAmuAGgqNh
 vDu8nMxhuMkM9+MzGNH6NnlMLIOA3ly7Ryi44GZKmtL5GTnzEBALLRIeOFqco8GG1Ny41rfc5X
 FCSphlT7nbN69OizovZq3+5b9kD/R9Au0NCryves+62mQS2/zUwE7fpBccAQjbQYAKrZX4+qhy
 Sk7oR3YchHgF9F7CMyIlhLTQqlIifQPmabpC25Hi/wMAQAA
X-Change-ID: 20260807-folio_memcg-const-4a67e40d485b
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
        Barry Song <baohua@kernel.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Baoquan He <baoquan.he@linux.dev>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
        Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789514423; l=2734;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=kVidRnCSLCRIDy0LcPsGCW6n4LV3v1+7iiJ/4lJYABM=;
 b=IUUOAnE370UfZHmbfJ+hzfZc13IWrSCvHO1T7L1Q8AxoiMiDM9A+vJqtBHulacRIVh0hjFl35
 /GfS9f4r1csDMdmNpv3fw4T4amusHZrD7r/pgt+UN2gUz0GBkO0L+Lo
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=fNCsTpae c=1 sm=1 tr=0 ts=6aa9d2ba cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=bC-a23v3AAAA:8 a=b6ln72opZJ-VCPk_GP8A:9
 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-GUID: zAJ6-SZTnNqFonG2dHAm0NeiPYAnpVcm
X-Proofpoint-ORIG-GUID: zAJ6-SZTnNqFonG2dHAm0NeiPYAnpVcm
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX3qUKDcw1kX4s
 6/bfQSGYmS60sh+R1ciJXG1Qw+nttFJne7RKI3KTWo5hSrFaJSdqPQKjOkam8UrKTNvhMFvDot5
 Nide04ilvqrjFMzcShRGUfnpr9a2Oak8DrxjCrWldDvFalhyPaCb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0MSBTYWx0ZWRfX+RvLSbttRnVU
 SzBP7kzYqTy9L2FVZqnGJvJlDAGdiHBsqSRme/NUpLz3PWNjAmx/o4crM4v/xayHyzT4zBNMEiz
 hZH6AvxNbhvtJG7hG+jKkjho9H/YT87SAGhrVrAFNZ8pR8+4DWJvrYg0HdMDURhNkKjVKccnJ2k
 jO+FZxsi9aPES1iKReSkgOjRJh5VXvf9AfoOY3mX5Wmp2rKnROTO6dcwZeJE0p8cnXGu5YnFT6r
 NXETOGFQHQlf2yB7HpaOHaoOFcBCNjV+mMXEh7dF8etKadHkOaMTXpF6SqpoaQ18O1kdJJ94vSZ
 ep0aIXFgXTgzG5/8QDkHBgbbYFXYwLrAg6zs0MWtyfrNF2cL511dF405FxFM2kXihXHj5aRjoB0
 gxSEsQ5QEDqQM85yfIJJrX+PrLyDYHwSe5mZBwtVb8OK5Co/9Yw5oD1etrclks8V+kmeKyb0sra
 hh4RtUP/5K2qauXVgWg==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 impostorscore=10 adultscore=0 spamscore=0
 clxscore=1015 phishscore=0 malwarescore=0 bulkscore=10 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150341
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 125F9C0005
X-Rspam-User: 
X-Stat-Signature: s1fnc1jdnwtzw6yknemtd5fu4zx877fk
X-HE-Tag: 1789514427-982296
X-HE-Meta: U2FsdGVkX1/UVUNYgpxLwOwSnxpglc5It/lnJH/UUPdKR3kdE9thu4a4UYQnFuGU/NUmbeqKk5THBvDdWpJUGzMhx4ZRAqLHbryeVIpEog/3Z522jRFWnVaL66IxtE98zRHrQWphjPwnIRE9wb2XePDHye9aqoOkpU7MiJZ4mVBwawQqO77RRqLtKnidPOf5ZTyjIwon57bORtf9lvyuNMZsomddnqOc1fNqOFufvNd8semvRFInNkM5TBntZ9Z0AEj79MQNdVJm6kC1ZkuhoX64U0E6ymU0KRXjMCOLcp0DjITguiL6RUwTdVNhQ07GN04nsqSXdm0ytkCk0Un50RiMkvVyIEJOYyKA1DMjELCo/5JHvDZkmk48BmFJqnOL7mEw+Junm+wQcXK3DlQJfnrGjfKi8VlFA17cbFmHeYPYi/1+cza85kXDnHlKDdgzeZQ7Hd+NxJ6qCP6F1SqF054zRXOSJTQ0hER8h5SakQvOgWWllFhyBDiMLM1C3lTmXZcfE5mNq5oifsnGlWvCvgDHNJkzIlfAlkcf/Jfo+M4FeUsxLBUI67teJw87+tofWXjGD8B0pd8Ff4Tq9Pz64wRZHNNwfxTXji78VEqwoik7OR9iHkacF+fWhRilvD9uwqvH122t5J7iqBrLU2j2f5xrERFdrtaQX037KQtu3YwI4tUavjXnhePJ9L7hSBj5A+J0rvt8Ai7NqvCf7rDW0w9Wi95mgC78sg2PkKR1qDV69yvJNj4QhoGBmVGrmZdJh9H9PZ56EtL7l6bJR11OkKE8uVyIvt20rP3zdanqJiTTu3pHZw1o9sa9M3PJV6G8l2gcWlFEmYNX9ZHf0hexw8mwrUP0MJaYHB4sMJI6pa/fCJ6kPr7K50Sa5pKmLfn5wH4ja/6mgYuzPayBMA3flOD9sOM9kFm2IGN6GyMPevq/NXNvfGYedn500EgwhXdKZNbNcHSNrNpPowAw2v5
 KTWzZ9L2
 YAaj7kniy+5LtKv+scnudZovo2E4gjuFuoyzhH1gDH5d8HEbg7+c+4vBj9EW9SdUEzQvJjHrEoMYyKnyBfXqk/n49953SIz+Nua7bl/zy6nNjngIZh9m1zYzYhvD+du05KGhth3uq6gQEIf+oFeNuN2beRPMfYQlJA37pVbb3w+kBHvRI6gvBBnIzAPwQvRb5+0qn1QwRRjRBfrp49jNwZdAXQZ4Idad6miSbJXjzGim23HuQEHhcQb/BtIzhk79pO6U+hT3bmhOfYWzwrtS7PvBjEfTcXa9Nan2NUcS4QX43+kbSAiutxvOzzyf45L3saqAlXwsXTd52zZhqy4nBWYiwU8Tf3TdydOXj6lcTprwiSQbUhhxyzTceqTSK1Ys8Ys0mFfy3ctFuMDEyc21lUBRR3zRVFfDGrINF4EsQiwD+R9dMtAhPjQeZQ+QVMLBlOZmeOZ4Sn+KqE5skBqj2H+LyzSmuRNfGH/+MEvx2+kIjPMhpsmq82UTJy7j0YjO2WDcD6NyskhGJh6PgLB94nXQv4ikFHIOEJz3e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memcg accessors, lruvec helpers, and stat readers only read from
the memcg, folio, or lruvec they are given, but take non-const
pointers. Constify them, along with the page_counter readers and the
swap I/O blkg helpers along the way.

This started as a follow-up to [1] that quickly grew in proportions :)

[1]: https://lore.kernel.org/linux-mm/anYqSDnC2BbJXv1h@casper.infradead.org/

---
Changes in v3:
- Patch 1: Constify get_obj_cgroup_from_folio() as well, per Sashiko
- Patch 3: Use container_of_const() in mem_cgroup_get_zone_lru_size(),
  per Sashiko
- Patch 3: Note that lruvec_pgdat() still returns a non-const pgdat and
  does not use container_of_const()
- Patch 8: Constify the local memcg stat readers as well, per Sashiko
- Link to v2: https://patch.msgid.link/20260908-folio_memcg-const-v2-0-811e9f443409@columbia.edu

Changes in v2:
- Patch 3: Constify the folio argument of folio_lruvec_relock_irq() and
  folio_lruvec_relock_irqsave() as well, per Sashiko
- Patch 3: Note that mem_cgroup_lruvec() updates lruvec->pgdat in the
  per-node structure, not the memcg, per Sashiko
- Patches 3 and 8: Use container_of_const() in lruvec_memcg() and the
  lruvec_page_state() family, per Sashiko
- Link to v1: https://patch.msgid.link/20260902-folio_memcg-const-v1-0-e2c1da22246d@columbia.edu

---
Tal Zussman (11):
      mm: memcontrol: take a const folio in folio_memcg() and friends
      mm: memcontrol: constify obj_cgroup_memcg() and friends
      mm: memcontrol: constify the lruvec helpers
      mm/page_io: take a const folio in bio_associate_blkg_from_folio()
      mm: memcontrol: constify the mem_cgroup accessors
      mm: page_counter: constify page_counter_read() and page_counter_margin()
      mm: memcontrol: constify the reclaim protection helpers
      mm: memcontrol: constify the memcg and lruvec stat readers
      mm: memcontrol: constify the swap accounting helpers
      mm: memcontrol: constify mem_cgroup_swappiness() and mem_cgroup_get_max()
      mm: memcontrol: constify the zswap and socket pressure helpers

 include/linux/memcontrol.h   | 212 ++++++++++++++++++++++---------------------
 include/linux/mmzone.h       |   2 +-
 include/linux/page_counter.h |   4 +-
 include/linux/swap.h         |  12 +--
 mm/memcontrol-v1.h           |   6 +-
 mm/memcontrol.c              |  57 ++++++------
 mm/page_counter.c            |   2 +-
 mm/page_io.c                 |  14 ++-
 mm/swap.h                    |   2 +-
 9 files changed, 159 insertions(+), 152 deletions(-)
---
base-commit: b08a65b93426d86e3f354d655d6225397b591877
change-id: 20260807-folio_memcg-const-4a67e40d485b

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


