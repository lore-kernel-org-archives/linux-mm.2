Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26CA606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 04:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=ifCaGtTp;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=Blpd/KJm
Received: by kanga.kvack.org (Postfix)
	id B656C6B05BF; Tue, 17 Nov 2026 23:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B174D6B05C0; Tue, 17 Nov 2026 23:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05CE6B05C1; Tue, 17 Nov 2026 23:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6ACD56B05BF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED8884065F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:25 +0000 (UTC)
X-FDA: 85446960690.04.2CD26E5
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id 892FB160004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:29:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ifCaGtTp;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="Blpd/KJm";
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794976163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5zpFBIp+1LdT2GGZLD5EjnwLjNrouTOus3Kut6TC8c=;
	b=DRLLUmUfm5tqvwe0+LvhWEdviJcGcS3Yw+/gjFuKbrtNaxk/58wysu9FgdEowPJB09JY5D
	hS94pqBh3H33gejlQORUUqtYQxMC7a+XA3uZ0Yd95C4NNkranPTmu16X+u4Ch1EbAjqc8W
	dugNZwK5e0Sb8LgX1StGXz367P6Zd7o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794976163;
	b=fR3buKTQZYUslwyIjF3+nHk//7f5Im+Ou9Mf0B9Q8uLEE6kLxQhAKNDVdu/xC1rwvC5nRK
	HScdUV1Z1UzXidOtQaDxOHkI20Ex5XG9fpFN3PieGrzawaw2FdG16MYSR8TG3yz4KrejVW
	N0my93i94q1/I7iz8aRSIIQW5vin/PI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=ifCaGtTp;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="Blpd/KJm";
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167077.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI1XZA32951663
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=i5zp
	FBIp+1LdT2GGZLD5EjnwLjNrouTOus3Kut6TC8c=; b=ifCaGtTp+RHPKmxjiwYp
	EhQqRIfb8+M4e/v9xIOPeSPRLvrH6ccqH/QNbR5MXC0mG2x2/ZQml4DTHdtqMm6G
	EnyUsKTHmA+jYG+kmv2zphD/5Qnaz5S7sd1SPPkFKG6J6Urpsyd1kI/FBRP/KjS+
	ZTdBbzic85Gnqwst3K67EvTlgRIAkXAieYWf+WRTQ7f85JXSFZ3GGJT4AoZbf4w4
	QQc+ElIVfaNenz2v8OIodjgk76SpCThp6OCF4C3kHZI11dzm8sLwTYXlO4QvNuve
	z99CdSGJlN7fVewyRMoNqh2J92GGgpSCEG6PCSuHq4nacnXY2iZ1fBiG638z5Sjt
	EQ==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j0yu5sfcu-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:29:22 -0500 (EST)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-9495876f8beso103273585a.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:29:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794976162; x=1795580962; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i5zpFBIp+1LdT2GGZLD5EjnwLjNrouTOus3Kut6TC8c=;
        b=Blpd/KJmULfbVjVPuxe2r5bJ7Dwd7E44nkbeJJ1WnpycA1jVFxPjWQj9Mi1BVfCtAk
         Dy0hp8n704eTA4n671vVhI7rL+oUR46HPjzC2VPlL7RGXsrFyZQTSxfq3VnGroHtEzCL
         H8aD5TYB3q+MsNPBM3jUdxN421Scrjjzi810ZFKUUDGnF6bVhwhUjVNR5F7y/6pbFxiF
         CIP4tq8yIw/AbmEIbJY2mlKylZbbkYhhtoMpmkFQxxGTvmFrcWKa7n3n8UJiw62He4dt
         ILuhSPnv60ZkIqUgtad2Iny00QvopWSzaNyZR0eAXDnTbW2VViEhxrZ2L8PJ5MZ7X/Xg
         bAoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794976162; x=1795580962;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i5zpFBIp+1LdT2GGZLD5EjnwLjNrouTOus3Kut6TC8c=;
        b=0/kXAKLYpMee245s6f7uwWKUrzyErSxIIrC4hCctVvzX0QnF1ECQAHMtZ5YtiYahX0
         J2BlmTd9lOq+b9OJwDni6/szkywhronDo3Et2v6JqwlF1VjXUyWi+TqkyzFaP4Z9GeU0
         X6hO1UZ+AvAL3fF9VlIZQIxPD/Odu5lOaQWr3I+Koazs2ewV01DXJJI634GCiivuq91n
         DuJwHbPJCXluNAGkRDqxGBWsIN6eHS9XwcLTh/7DwDtOkJRVLfelF/PBv9u5d0tGrCZm
         siBZsjshzVnaNXBLAxrtdhCABRhVCPIsY46jgyhOEgHrygzQgy23YQADy5G/ce6JMYI4
         sTtg==
X-Gm-Message-State: APuU4Z+s6sgmPNhbNb5PfMmSuIjm8wGPr21oN5+hwBmkKqxeGlZFTw32
	iNv9dZndaUVTRx4bZUDhNlrACO9BeY0nODVGhFalvUlfnpLq2Pp5/HOqmZ+Z9TtllZxrx8fmEe6
	Xi4ro7CVLqZsLo3inoPK+Z3bNmLa0xDTX0FcKCVb2AYFLp4nv
X-Gm-Gg: AYBFou35U4z4NFzwFfhwhPnv1Ky08v+FaU2FhVm7UBk+dwnBVSGYsSR/lwfS8GPbrgE
	ebcFBwW3fEzknn1Y56uPDx9n9gk739c0rILE0i40TJ+fQpFRAEvGeYNn9a7fAN4YV8Jqx+j71Lc
	nIEreYthAgtxTtPz9dVRAHc1T6S14+RMucls3BfWg2CpYgAqd1bPSScx6pYIyttYio4z83cCUEs
	KqfXYZmy8Vs0D9pHqjxBwflzBoprDYEXtrGucJVfJzywq/siiJcYFQzmc29HSfnsmPh/DKyoRg2
	M6sHCWTDb1U6/3V58uANggMcqQkO8oxbaJMqO/gbtADeM1X4dYvP9xctbLlD6cahJPFcB1Rrvh6
	YSxpuf2LCicJBxsxX9IHNdQnN25FQMYCd4UIQ/jAgZaMKlWT/+YM0VYLJANC/MCc4uCU8Svjt4d
	PRlRpDg/UTPqrVRMeXRw==
X-Received: by 2002:a05:620a:2906:b0:945:fcd7:7823 with SMTP id af79cd13be357-949995ee5bdmr310935085a.63.1794976162029;
        Tue, 17 Nov 2026 20:29:22 -0800 (PST)
X-Received: by 2002:a05:620a:2906:b0:945:fcd7:7823 with SMTP id af79cd13be357-949995ee5bdmr310928285a.63.1794976161125;
        Tue, 17 Nov 2026 20:29:21 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b743a8bsm89678085a.17.2026.11.17.20.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 20:29:20 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 17 Nov 2026 23:28:49 -0500
Subject: [PATCH v3 9/9] mm/userfaultfd: check the hugetlb alignment of
 every VMA in the pre-scan
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-uffd-state-fixes-v3-9-b617009d1a4a@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794976146; l=4876;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=EAxjBdGKjmNBZwoH8jlh/pcqgFCSerjkNK/wjow3uGE=;
 b=KUR+7ad8tDe+EylRan8+qSxOeisLzBXY9hPHmeOwVFnG4dxe7Ag2XQ64KOhMu4e5hqw3d5kCe
 +LFkOdORmnhCXD+Pe/H5JBozZJ60NMLg61evwFPO4+4kCv/tJJ5n0m1
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=Ir6L47/g c=1 sm=1 tr=0 ts=6afd29a2 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=sktC-jyAyf29sAdH:21 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10
 a=A0y_DWxS2BwA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22
 a=QOCMdifcju39GKoXhKua:22 a=VwQbUJbxAAAA:8 a=9qlVvB6YTzTb8WvwRWkA:9
 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-ORIG-GUID: LNJ-QSVupVY1xGtZxfQkqos8c1hjBR5b
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX47aky+wtUecE
 Zdox8y/Jli4y6bOi5kRZyP+9HGXzzlyi2Oxl3xeX0HW81uvHd5BVFAESx/BsXP4i9HYxzhn0xcy
 5nSmNLrzfhAI4QS/S3afOHGraQzy1yIDb5jqBZ4xecANMZHj/P7E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAxNyBTYWx0ZWRfX45jF2yLQQuUA
 uNAWuzC66ndnTso1vp64Ijb+zYvSCblCFPMeonyMwAxBvvBmRHI+vvsSTACGLxKhxiWeC1Dxnui
 3yKQ12nGJxPdnxgxLvtO1+XTTeI7oiME8CdiDeDMqf0CveL41rNR9THOBsMV9vYXBbc3cC5/3Vx
 GJycgPownKW6zlaIWgC427Aod8Chg6FFCJGVOSnavVu8GBoOLxMLfp9VMN/Y4r0ioul6cve2tNY
 aV4tVqfDykdk5M5Fre6Lifk46a/3sntpyNwuejN3sJK53tmQSMhsBfr4U/KQ0mh91O11tsuV6/v
 keIDbFHmdT4qxJ6L00kiCGyZOnBNqVUlUkHHrkd4Z7HrscpJJynJTMnDFASMqVtOLn2OZ6qrNk4
 lQd7Z/uBqvnngd0ImqDQRFHtIr6alSDTE1n9O6EEYd5HT7NsNPoH+AwAEQGOfeuO4O4/DPdyWwh
 DushhHmZNk8xhJF3O/g==
X-Proofpoint-GUID: LNJ-QSVupVY1xGtZxfQkqos8c1hjBR5b
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11969
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 lowpriorityscore=10
 malwarescore=0 clxscore=1015 suspectscore=0 impostorscore=10 bulkscore=10
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611180017
X-Stat-Signature: pzz3zfd73fjrfwtoak9uj6dac5wgy6gy
X-Rspam-User: 
X-Rspamd-Queue-Id: 892FB160004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794976163-951703
X-HE-Meta: U2FsdGVkX19r4AIfBMxFDUMK1GyS8XCx+QRVzTDyi/q+xSToittH+rqKxJVidy/OliFfH4YcwOel2joiEGoR8/4TnD0uDn2YD08XNtqVuN+pNM7ZTgPwVKuGgn4iBZEL5A6Em7zTmh4fbGTtXzpxNarEkgofZ7uWxscGfom0qhNKi8yy5SR0FK0X6cFYeIazWGIbsPlw54RK4oK+L9dYO4TFNN6ua2fWmbN18GjDVhl7s3a47Efqrsc99ziCAC5VazXJ0Ld9t5yo9ui8i+Q1nA49vZs4mWA9sHc1pFO0YyYtzPOfVhdIFeCT9OqB9SFvViUkV8n7l4UwiHbg/JnG/dwZutvcc/W1wrG+iDJ6WB1dbVgVDkGGTBoCMsZydCdypqNxaSp9n8EWwDnWPtg9Wj+BKT7/5NksL8GrpfaOs25O953z38C0fP+jdMJQpsDl75dlARz1JphoJ+0fmIVQ3ff2vFc27nUJ9EPItiNN+ov/4eAuBgKSSUwNChbyO9Afp/48E6rNURZOALEqeZEjcU7UQF9WQbcf7KaSuSRZdutkey/5DdvXaec8otIEw94g8w47O2HRbSrhUZ6IbWkF47arp6cLovET9ZLOcYO4CpmpoC0sRrFvckDuI9dU+dyHVAkY/hKFFUY56dp/RhUq0kj5jJQM5CMPfS3fcfWcKxmRAZ+wKkYZ6Bz9mu3mSru37QmT4r2bF2xYHCsfq5yTaKAXg225s1NOm4ucgIaWPmXd9mYOf/A88s0XYZIshP1DS9NLlXAfSusmpBlYW90d/Khye7mHUxab+kxbR+/cVfo7xQiACXpRm3lQdmyR6DhW6avLbsTEwFMMQrQfh+S4VZMFIBSxK7zgH8VoUE9OYDUvQrZzLo0Z1gLtEyHhfaPtDJJ7tZLNfvzyxDxHN1+X25QQJvlvVQuxYWwmJEUohxP/mwNGWAZ9hS6MCDfJyYeGLsZO8B4Eys+NYcu0uD7
 iI4xB/O3
 GvKQ7EahGQgmeXOvRlAO9WGyvI8piDfGDmZziDZCOEioOCs5K6OF2Pj+yQyz4fNtvKqsbF07CIyDQkk6+Z523MO9ayDUiqqbN1m6XX9BPdmpdSYgechqCOpn6r5P8DIs/0ggP6n3jIWLBc6MezGLwmYNOriW1LgJsGZQTVYO5OnM0nCQnbcsuGU64zDn0W9uvtFHIHVzTnUX7Tn0YuBWpdP9Zp22C7eoNVdZzHODxYCiN61m5cG4cDqLDn6eNePL80WPm70Q7andarGUb9FZqpaG8EMqrOlu5G+uZ22tYoMieY7Jo3mzLFC4JgJQOIU/PCPx7KNkXPoUBiqFlnIEzAWh+6/cN/DG1CfuOUNGB39NFGFn7NivN3rNBcf9Pcc+Ra/aNVP+cXzT1BTjg3++GHho7KlikhEH0S2Q37jICoKyzzDRzB0grrS1lyoQJcV2bD2RfSTaxbMuhPd677ybokCQjecPbU3AWRz4kCQrEFsgSDNQpBaW9OX+1HybikGzV1V88
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

To fix it, move the alignment checks into vma_uffd_range_aligned() and
call it for every VMA in the pre-scan of both ioctls. UFFDIO_UNREGISTER
still returns -EINVAL for such a range, but no longer unregisters the
VMAs before the misaligned one first.

Checking every VMA the same way also changes the following:

- UFFDIO_UNREGISTER now returns -EINVAL if the end is not huge page
  aligned in a hugetlb VMA that is not registered. It used to skip that
  VMA and succeed.

- Both ioctls now accept a start that is not huge page aligned if it is
  not inside any VMA and the first VMA of the range is a hugetlb one.
  They used to return -EINVAL, although such a range covers that VMA
  from its start, which is always huge page aligned.

- UFFDIO_REGISTER now returns -EINVAL rather than -EPERM if the end is
  not huge page aligned in a hugetlb VMA without VM_MAYWRITE.

Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/userfaultfd.c | 54 ++++++++++++++++++------------------------------------
 1 file changed, 18 insertions(+), 36 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index ada841a9cb2a..b80bcc1e03d0 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -3692,6 +3692,20 @@ static __always_inline int validate_range(struct mm_struct *mm,
 	return validate_unaligned_range(mm, start, len);
 }
 
+static bool vma_uffd_range_aligned(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end)
+{
+	unsigned long size;
+
+	if (!vma_is_hugetlb(vma))
+		return true;
+
+	/* A hugetlb VMA can only be split at a huge page boundary. */
+	size = huge_page_size(hstate_vma(vma));
+	return IS_ALIGNED(max(start, vma->vm_start), size) &&
+	       IS_ALIGNED(min(end, vma->vm_end), size);
+}
+
 static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 				unsigned long arg)
 {
@@ -3770,17 +3784,6 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	if (!vma)
 		goto out_unlock;
 
-	/*
-	 * If the first vma contains huge pages, make sure start address
-	 * is aligned to huge page size.
-	 */
-	if (vma_is_hugetlb(vma)) {
-		unsigned long vma_hpagesize = vma_kernel_pagesize(vma);
-
-		if (start & (vma_hpagesize - 1))
-			goto out_unlock;
-	}
-
 	/*
 	 * Search for not compatible vmas.
 	 */
@@ -3797,6 +3800,8 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		ret = -EINVAL;
 		if (!vma_can_userfault(cur, vm_flags, wp_async))
 			goto out_unlock;
+		if (!vma_uffd_range_aligned(cur, start, end))
+			goto out_unlock;
 
 		/*
 		 * RWP uses protnone as an access-tracking marker. PROT_NONE
@@ -3820,20 +3825,6 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		ret = -EPERM;
 		if (unlikely(!(cur->vm_flags & VM_MAYWRITE)))
 			goto out_unlock;
-
-		/*
-		 * If this vma contains ending address, and huge pages
-		 * check alignment.
-		 */
-		if (vma_is_hugetlb(cur) && end <= cur->vm_end &&
-		    end > cur->vm_start) {
-			unsigned long vma_hpagesize = vma_kernel_pagesize(cur);
-
-			ret = -EINVAL;
-
-			if (end & (vma_hpagesize - 1))
-				goto out_unlock;
-		}
 		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
 			goto out_unlock;
 
@@ -3943,17 +3934,6 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 	if (!vma)
 		goto out_unlock;
 
-	/*
-	 * If the first vma contains huge pages, make sure start address
-	 * is aligned to huge page size.
-	 */
-	if (vma_is_hugetlb(vma)) {
-		unsigned long vma_hpagesize = vma_kernel_pagesize(vma);
-
-		if (start & (vma_hpagesize - 1))
-			goto out_unlock;
-	}
-
 	/*
 	 * Search for not compatible vmas.
 	 */
@@ -3982,6 +3962,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 		 */
 		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
 			goto out_unlock;
+		if (!vma_uffd_range_aligned(cur, start, end))
+			goto out_unlock;
 
 		found = true;
 	} for_each_vma_range(vmi, cur, end);

-- 
2.39.5


