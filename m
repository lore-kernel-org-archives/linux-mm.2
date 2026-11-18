Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19C9606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=UWX+cXEQ;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=xbe/5n8G
Received: by kanga.kvack.org (Postfix)
	id 991376B05BC; Tue, 17 Nov 2026 23:29:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9694E6B05BD; Tue, 17 Nov 2026 23:29:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA7D6B05BF; Tue, 17 Nov 2026 23:29:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40C9D6B05BC
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:23 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB9691A0653
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:22 +0000 (UTC)
X-FDA: 85446960564.20.334D344
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3B47C80003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UWX+cXEQ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="xbe/5n8G";
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794976160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HgXEz4EEUSF3chOzr46ucSIK2kqpqdPsjmd0V+NKYGo=;
	b=StD7+DumOXqE3wrn57NW+DOqsavE/7aebsxMUe5mV2v9XPEY0mowrjdnPLckE9o05cuJdM
	Pfam+d4ko6H5rp/2QUWSZf8hqyQUDg0rsKe+Sz3MYhPbAkEeuD8DmC6Br8U5ypZ0rXMQum
	OO/NSNiRVTnR6mZtGrVcqbrWBlcc0BI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794976160;
	b=Q3KAfnS6oS4EHoU98awwnlYYBeUhYgLTKWfbO0THwhfPu3KYoZo6oHFsVVJ5gXrnsTcjay
	rCpgV+LNJFuaebO4m7A6ctyBFcrMh8Ar/bYzbh61/ds11JNr8J2UUQmGQQDdOONT3gy32d
	MT8yfrefd2dY/DiBQPOYQf0T5+op9HI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=UWX+cXEQ;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="xbe/5n8G";
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI1XqfZ3627768
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=HgXE
	z4EEUSF3chOzr46ucSIK2kqpqdPsjmd0V+NKYGo=; b=UWX+cXEQpyyGP4xDyBvZ
	qX1ZB/APqCUrs26COMPtlfXk5V7PDsB89t5hQD4138KeHj59e0sEZyKi6XsGS1On
	wD9MWPNjDCxZMR/AiC6hHAyxIZfartyrp7LzGcRCeSkS2I+5GikHUepeCyoUAUCx
	mBkvLFAb2VUbSOqBYsZs5iUbkJwVxXyy32wrbC+cWVHiQt74c7g+LjfK/n+OWT8k
	JjZ6TSCS2R27FzKdniSORbwRQxlVsqbQvw0phyc0+rPPBRYuvE3PrTfTyIwRpPNx
	3mefc/U2j0+vcmQyiZBU/wc5qyiumLwD8Lym/PE5v+8ks3mgBWVTVgqjNmQ2CE5j
	NA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j0yu79geb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:19 -0500 (EST)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93cb7f9bb86so128637985a.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794976159; x=1795580959; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HgXEz4EEUSF3chOzr46ucSIK2kqpqdPsjmd0V+NKYGo=;
        b=xbe/5n8GQvDiTXZZBSWhkWC0lkQqTP376VIQjAUuo8KTHGbr+f1LLGkcLCFMYHIbW3
         MsOvrKeJBagKuNdDpyf4a2UdW+mPMy+WkFBU0cyZ9npgAsVNUc3GxdtGdcp+UlKZVjTi
         j7TXZYejpZMa0llWXe8B4yBcv3gAApOqxzt293eENIAdvgMJC7rhrGkNu2L0WpTurU8h
         hL4K4zLWfNPzF+yYC3WkH34qjMHSMh/FoVOKzBzyaQ4tiEj/jlSGFeHECPhZTd32Y5yA
         rKm1EzETShkPadNOpLPXtg0GWpGFtY4o1WZO7KnHtpApWJnhf4GTE+v3dG0IxzLbelU3
         qHiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794976159; x=1795580959;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HgXEz4EEUSF3chOzr46ucSIK2kqpqdPsjmd0V+NKYGo=;
        b=03QbMhOB1i933n2G7HJ3EE/GxgCF2m/0Z1c/bINr+Jp1/p3Vvj83QCIe2FNBGl9jcV
         1r2yT99OZMdOdjaHaFoXsrviwz3SyTZE30io7ODlHs6ClVKAjv+s55H1nZe0tF2HXA1c
         Eu0xRufeJ9fwBvj4p35w4JioZyQF03vTmUWOb28Eeo3gML5YLJ7oklSnKvweg9vFg3Fm
         ecSwym+DzJfw7MzghZl2Ah9awnpzRAev+LTYfHDroK8UdfSYj23W48g6Chx5YB+aWOSw
         cituoBezpQl36e6BzYDa+a6+D3GMuazNRTyV2gEGtTvmH63Dg8AHtyq/CFcQ0Sam7uF+
         GAtA==
X-Gm-Message-State: APuU4Z8kwubJjV1jOsVKdBaTRvbo3ZwVV9xCXIOES1+I13jWl9eVFZxm
	c8G7heYMnCN5uI87c7DKkcw/HB1E8dqR4gzKnFbw74Jhq+pUGPZwTYtFEu78c19Kkszewmf/qwQ
	INt2PuWSZJ+PRgx3WmsegDaIXhY54nVq/felEzGlKez5X4guN
X-Gm-Gg: AYBFou1WCNyx3SKhKcbkL+Z8qeh9GA5MVtN+Lxlth1BGOnAB+gECTd+GoVzatMvJokq
	C1fEQsJJUIPI6HNV6NBVf29o4YjFtf8YOp8eVS3omxk60q/xrigMctvTHHiJ7uXrRGjc2Q8PyTs
	ndYn8xAUsdHwRCnUJSsU24EhwCtQx/i2z/992OSNkL9hjnwvWOrg4TKrHi7jvGsigT5vXmNiiXp
	I00xJebtTFCEsbXCy/KJOeuAWP7LqzPfZRBKaLVJTw1ZxyQc48C1WDxU92H7LLLPuYc9LP9dJ9P
	9dsR3zTgUOfcwQblx/DctIJXObt8t1LcB4iRR8zocbEljYE6tb939GztSQ/ClwgSrhJWvOri2O6
	+ZcL/t636jV2RhrZ78eIGqz/5oHKq3Wdkw4uqLdpJQCVs7gwLXMf/sVk3OqfVmvj5nqvsdd2HA2
	vd3/S1bA1iDVatJy5S7Q==
X-Received: by 2002:a05:620a:262a:b0:949:75f1:e5fe with SMTP id af79cd13be357-9499962bba7mr272721485a.73.1794976158654;
        Tue, 17 Nov 2026 20:29:18 -0800 (PST)
X-Received: by 2002:a05:620a:262a:b0:949:75f1:e5fe with SMTP id af79cd13be357-9499962bba7mr272718885a.73.1794976158229;
        Tue, 17 Nov 2026 20:29:18 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b743a8bsm89678085a.17.2026.11.17.20.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:29:17 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 17 Nov 2026 23:28:47 -0500
Subject: [PATCH v3 7/9] mm/mremap: resolve uffd state when the context is
 dropped, not during the move
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-state-fixes-v3-7-b617009d1a4a@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794976146; l=8609;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=b8KcwT4NcH+jLWQ8CssF6BrCCWtvjmBXZMyQ5uv2afg=;
 b=TV3Rmxo28It39xV50wxFOJ9bcVl2vqG3UXWrYKJoVYvCGv6FoZvZnUL6te/z7WqOI/UKBBZOU
 y55fKXTbvSKCAUzDcKn3oRTzcYMIf0ecqqoaK1H9HLRfxEdLg4eGFSB
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=LvgHWXdc c=1 sm=1 tr=0 ts=6afd299f cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=VwQbUJbxAAAA:8 a=tHa68p0SAAAA:8 a=FFitksWucw0zMzmll4cA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=ufIsyHvWW7FwcMbVRpPq:22
X-Proofpoint-ORIG-GUID: _pE0E_n8dJ7lNqrdp5JY9kfsL_WwZN-Y
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfXxMc7cXJvdwjt
 fc/NiFC2+qUcrF1/8x8bhz+THFxa5zxv7VbdFESQcX1J34AsobuPtnQI+mbNCL8JibrUifVZxs0
 2fCIbfct6U6PkhHXNPuaDd3CxSO4rLCxMbYViQ0Mbrru4UPGRDas
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX1imRl6SZ2iiy
 AGnS3iaFNhUhiDwqa+aJi3O7IzipN85sjOe6XarBddRCZr6L0Mms1YbBc7T0GuxMQPAJJe/IPg6
 mi46Vnnma916v0/LHVpog1xBjSABe64y8RtaH6EFxB2HxA9WsfqKQsstbqcwyj3oFcqOpG7RmmN
 gW+wDMdgbJjhidn6GMeULptxFXYEMivQ0M5Dz70c2ai9mHpEYWpYnHR2k0KjjflK9W2J3wGR2ng
 YcvOj1ofW4vrqXWEub3+rzZvTI8hrQyoto7CH3nArZtffx9oWVQYmAHVzfCuCSh/y7mKjwD9l+W
 1ak2EPLfcoFOdunJtyfLTGXwsPic36S5JZ/T977h0pGjpL6Vk7cMNTFyo+2VmUj7z2JXPToSuCw
 jJL7pJWpstF7rZlzEmI0nxV0YmuuzNRS3kC4pcM+tMKqZbYcEEdHUDsTcNstN1hei+KqG1qzZ6q
 wGIh2pbIH/Rbhoswl+w==
X-Proofpoint-GUID: _pE0E_n8dJ7lNqrdp5JY9kfsL_WwZN-Y
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11969
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 malwarescore=0 phishscore=0 lowpriorityscore=10
 priorityscore=1501 adultscore=0 bulkscore=10 suspectscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611180017
X-Stat-Signature: 6yrb1p5axo8ku773eapptp7ems4chfpx
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B47C80003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794976160-175557
X-HE-Meta: U2FsdGVkX1+Q/0rgSC0fHeF0fF1Ei0nDi1MLZ+7LNGp6+e1Ivb6VBc551QJOui4/i7zDbhh1zBvLk3i0szdxKQjjfJjroS/S35AgIUmbF1Htj3M1kYjqGy94rqTRVEMldjMMdxiOWVB9NTiZyRUY+ZR8lXFlK0pbfkCW1HFXvlfYMmtmPWZ9/ZEHChdxqyodl1Avx3SPM0XAUWYwTLtDc0xhy20T0hSkxvJwct+ZA6liNRI1FnHT+mZZ1o95cQ1AN2hNjVYOTxwbl6ECTS1G2v2RrdiMr+aenDvUTVwj4gCo+6LM8Y1Kd6tkQy4J8ylczvYGIdMtp2nCCF6EGCq5W4Evz064nmL9gKnhkmQdIIY12WJCN15xmQ41ZLb0cM7tXf7tv85/XBkI0YpojE0asZ27feCIt20iDi5QjF/sap+5S9ESa2C/H900x92wRVFS3/pS/v3KLlanai7Ze9wqFyue+DOfPnJeahWspFgy/40GGz+bZrGEBpyfCIWKCMSWT6SPeVUAgzZAgjknl/jGBEhCOpt+nAPfmQFhersFX/M356ZedIb4pOilyQt6T5ri72soRPHlmF7bdM9n5ECy3TSME8qiWDqYGdzF5JgmfcHse4TVQ4bzTliYcEH5vLfqSexxkDa3/T0lNt2i893AUdv/9J+kYitCbHNf0dp+kuONAiyK90e/b+YY0jIN3MoYQTrt3nWCG9ebK2x7AUyoxu0zmyGdjq9h88p4dLl2oocRmgQYkJcbl41VGNa+LIjRzCanvS+YIZWmeLZswnE55mQRikwgeMZu0cViL5qMCm+uLYKP0WoNYi6asQOUrGFz6cPFrEd+gDSbx0GzJFHJmmWnSmiBRBWVsnUT8AqT1TGAjffDAwMvLYBTtpO5eZu81VSpXkDiOjGLGP85bnxvLuG6nfSOZOi6rzTfc7xfCzIkmUEk2Juz06/rN/TS00Z0u+mZxtGSLEyreU2tuxn
 Mq4NB8oz
 DDr4f0u0OkkV7t8hlbfYgAJt6GtKg+ld2iVy0goufkTeB6d8T8kOBP4ozu9r6LkrwIT03tlEBQQYyhQVH7QRwoBD82AvE6rgWoMO28MbScPbaV9aHx3dCcdx6rDcy8e2sLsGQNnx3bDDt+9WJ8fNLYgISj7xoSJMCyO9NzptFrPCVhBeA/MR4sAxMrih0A4Oz786wAe8JZVzgwJokc7QKYoLN+r+BeBtp35cU7qxcVDxt1dO6QahOy++kbfgI+UpQVzQ857wLpB2w1J8ECfP4ucYO7+YO/ZZhfdlXqU4i/F3Tln3gMG0FvLEUayFM5joQhHgW4D9hW86T6NoTyvyht3rxcCFQjggrx9g5ZP02CP+w/VlBiI6naVggnnpJXB+TtIJAIUSDghSd21R5m8o1a8F8Jpk9l3l6Ry1YMEpfVajH+Y4H60htyFkXGD2ObnkSauzRL7GD57NfKK828NYXFgVvmdKDdSkkW3dH6pd0reK0YS4BQK23bUfXvtLdnNy5H9zUgiAxeI7Lyw4GfDEF8yVgOqxTsNhckkQf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Without UFFD_FEATURE_EVENT_REMAP, the new VMA of an mremap() is not
registered with userfaultfd, so the uffd state of its entries is cleared
while they are moved. If the move fails halfway, the entries are moved
back into the old VMA, which is still registered, without their uffd
state. Writes and accesses to them are then no longer reported.

To fix it, leave the entries alone during the move and clear the uffd
state of the new VMA in mremap_userfaultfd_prep(), right before dropping
the context, like unregistering does. This walks the page tables of the
new VMA a second time.

This is done with userfaultfd_clear_ptes(), which also makes the PTEs
writable again where that is safe. That removes a spurious write fault
per protected page on private anonymous memory, but adds spurious write
faults on shmem and hugetlb, as change_protection() makes writable pages
that were never protected read-only. UFFDIO_UNREGISTER and
UFFDIO_WRITEPROTECT already behave this way. This will be fixed in
change_protection() separately.

The entries no longer need per-entry handling during the move, so drop
uffd_supports_page_table_move() and clear_uffd_wp_pmd(). Whole page
tables of these VMAs can be moved again.

Fixes: 0cef0bb836e3 ("mm: clear uffd-wp PTE/PMD state on mremap()")
Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/huge_memory.c | 25 -------------------------
 mm/hugetlb.c     | 27 +--------------------------
 mm/mremap.c      | 46 +---------------------------------------------
 mm/userfaultfd.c |  1 +
 4 files changed, 3 insertions(+), 96 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bb7fe695a615..13050a5c0c0f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2616,18 +2616,6 @@ static pmd_t move_soft_dirty_pmd(pmd_t pmd)
 	return pmd;
 }
 
-static pmd_t clear_uffd_wp_pmd(pmd_t pmd)
-{
-	if (pmd_none(pmd))
-		return pmd;
-	if (pmd_present(pmd))
-		pmd = pmd_clear_uffd(pmd);
-	else
-		pmd = pmd_swp_clear_uffd(pmd);
-
-	return pmd;
-}
-
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 		  unsigned long new_addr, pmd_t *old_pmd, pmd_t *new_pmd)
 {
@@ -2663,19 +2651,6 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 			pgtable_trans_huge_deposit(mm, new_pmd, pgtable);
 		}
 		pmd = move_soft_dirty_pmd(pmd);
-		if (vma_has_uffd_without_event_remap(vma)) {
-			/*
-			 * See __copy_present_ptes(): normalise the RWP marker
-			 * so the destination starts accessible instead of
-			 * taking a numa-hinting fault on first access. Only the
-			 * marker (protnone + uffd) needs it; leave other present
-			 * PMDs in the VMA untouched.
-			 */
-			if (pmd_present(pmd) && userfaultfd_rwp(vma) &&
-			    pmd_uffd(pmd))
-				pmd = pmd_modify(pmd, vma->vm_page_prot);
-			pmd = clear_uffd_wp_pmd(pmd);
-		}
 		set_pmd_at(mm, new_addr, new_pmd, pmd);
 		if (force_flush)
 			flush_pmd_tlb_range(vma, old_addr, old_addr + PMD_SIZE);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3b7b94012c01..c3d4fdd56647 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5245,7 +5245,6 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 			  unsigned long new_addr, pte_t *src_pte, pte_t *dst_pte,
 			  unsigned long sz)
 {
-	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	spinlock_t *src_ptl, *dst_ptl;
@@ -5256,31 +5255,7 @@ static void move_huge_pte(struct vm_area_struct *vma, unsigned long old_addr,
 	double_pt_lock(dst_ptl, src_ptl);
 
 	pte = huge_ptep_get_and_clear(mm, old_addr, src_pte, sz);
-
-	if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte)) {
-		huge_pte_clear(mm, new_addr, dst_pte, sz);
-	} else {
-		if (need_clear_uffd_wp) {
-			if (pte_present(pte)) {
-				/*
-				 * See __copy_present_ptes(): normalise the RWP
-				 * marker so the destination starts accessible
-				 * instead of taking a numa-hinting fault on
-				 * first access. Only the marker (protnone + uffd)
-				 * needs it; leave other present PTEs untouched.
-				 */
-				if (userfaultfd_rwp(vma) && huge_pte_uffd(pte)) {
-					pte = huge_pte_modify(pte, vma->vm_page_prot);
-					pte = arch_make_huge_pte(pte, huge_page_shift(h),
-								 vma->vm_flags);
-				}
-				pte = huge_pte_clear_uffd(pte);
-			} else {
-				pte = pte_swp_clear_uffd(pte);
-			}
-		}
-		set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
-	}
+	set_huge_pte_at(mm, new_addr, dst_pte, pte, sz);
 
 	double_pt_unlock(dst_ptl, src_ptl);
 }
diff --git a/mm/mremap.c b/mm/mremap.c
index fff0465f5e06..4564416a6994 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -198,7 +198,6 @@ static int move_ptes(struct pagetable_move_control *pmc,
 		unsigned long extent, pmd_t *old_pmd, pmd_t *new_pmd)
 {
 	struct vm_area_struct *vma = pmc->old;
-	bool need_clear_uffd_wp = vma_has_uffd_without_event_remap(vma);
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_ptep, *new_ptep;
 	pte_t old_pte, pte;
@@ -290,27 +289,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
 		pte = move_pte(pte, old_addr, new_addr);
 		pte = move_soft_dirty_pte(pte);
-
-		if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte))
-			pte_clear(mm, new_addr, new_ptep);
-		else {
-			if (need_clear_uffd_wp) {
-				if (pte_present(pte)) {
-					/*
-					 * See __copy_present_ptes(): normalise
-					 * RWP PTEs so the destination starts
-					 * accessible instead of taking a
-					 * numa-hinting fault on first access.
-					 */
-					if (userfaultfd_rwp(vma) && pte_uffd(pte))
-						pte = pte_modify(pte, vma->vm_page_prot);
-					pte = pte_clear_uffd(pte);
-				} else {
-					pte = pte_swp_clear_uffd(pte);
-				}
-			}
-			set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
-		}
+		set_ptes(mm, new_addr, new_ptep, pte, nr_ptes);
 	}
 
 	lazy_mmu_mode_disable();
@@ -334,25 +313,6 @@ static inline bool arch_supports_page_table_move(void)
 }
 #endif
 
-static inline bool uffd_supports_page_table_move(struct pagetable_move_control *pmc)
-{
-	/*
-	 * If we are moving a VMA that has uffd-wp registered but with
-	 * remap events disabled (new VMA will not be registered with uffd), we
-	 * need to ensure that the uffd-wp state is cleared from all pgtables.
-	 * This means recursing into lower page tables in move_page_tables().
-	 *
-	 * We might get called with VMAs reversed when recovering from a
-	 * failed page table move. In that case, the
-	 * "old"-but-actually-"originally new" VMA during recovery will not have
-	 * a uffd context. Recursing into lower page tables during the original
-	 * move but not during the recovery move will cause trouble, because we
-	 * run into already-existing page tables. So check both VMAs.
-	 */
-	return !vma_has_uffd_without_event_remap(pmc->old) &&
-	       !vma_has_uffd_without_event_remap(pmc->new);
-}
-
 #ifdef CONFIG_HAVE_MOVE_PMD
 static bool move_normal_pmd(struct pagetable_move_control *pmc,
 			pmd_t *old_pmd, pmd_t *new_pmd)
@@ -365,8 +325,6 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
 
 	if (!arch_supports_page_table_move())
 		return false;
-	if (!uffd_supports_page_table_move(pmc))
-		return false;
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have released it.
@@ -434,8 +392,6 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
 
 	if (!arch_supports_page_table_move())
 		return false;
-	if (!uffd_supports_page_table_move(pmc))
-		return false;
 	/*
 	 * The destination pud shouldn't be established, free_pgtables()
 	 * should have released it.
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 0435ceafe750..ada841a9cb2a 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -3161,6 +3161,7 @@ void mremap_userfaultfd_prep(struct vm_area_struct *vma,
 		up_write(&ctx->map_changing_lock);
 	} else {
 		/* Drop uffd context if remap feature not enabled */
+		userfaultfd_clear_ptes(vma, vma->vm_start, vma->vm_end);
 		userfaultfd_reset_ctx(vma);
 	}
 }

-- 
2.39.5


