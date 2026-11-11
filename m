Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524ED606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=EYfIkMhO;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=Sg4mRLe7
Received: by kanga.kvack.org (Postfix)
	id 331D26B05D1; Wed, 11 Nov 2026 12:56:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2A46B05D2; Wed, 11 Nov 2026 12:56:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 135946B05D3; Wed, 11 Nov 2026 12:56:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E55416B05D1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:09 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 898C5160384
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:09 +0000 (UTC)
X-FDA: 85423592058.06.291FB71
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2162A1C000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=EYfIkMhO;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Sg4mRLe7;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xK1JRZtgXWaa2FgKeCEv1Nghpv+3jJNSaRA4T6QK0EE=;
	b=i6aw6snbOfo4x02gs6YKtcLCy05qip1EJlCtL9cpYksppM/i2/U7G+eS3AlDO1o//D1qNZ
	ZcWo6TcMxCqFSHxZmT9sul+DiHNQ4w9PewqoFTiPK4ZaRPuynMCh9XmPVdcqh7OpWXVtdn
	ryzHldq97qwfcL/oVhsyA45AaqgEw0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419767;
	b=UcjEEsZQ2cb/s9qt/mT+fT5zRXMy1cVnU5N+uAP1I0qF2GXaT5bvSsUhF0NDzk6NHIWp75
	d1gNC6wGEuHUsrM/uEXSSyyx+IzKXTgsHQqIlP0LrmQawomvb0JG6GvQwKvIQvTlHLuD8l
	xnD8d0nYE7PaCYL734eoPNLrUwiBiZ0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=EYfIkMhO;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=Sg4mRLe7;
	spf=pass (imf18.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYPjr1914948
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=xK1J
	RZtgXWaa2FgKeCEv1Nghpv+3jJNSaRA4T6QK0EE=; b=EYfIkMhOUzHR3RlVdqR+
	LK7AY/CQQNrJGT7M9ircFaSma9tEBP9VUpryAtXfZfhY6Sfp0zTN+4gcb7BUlgmJ
	rrsUnABiz9jHvVVnUCYGup1lWI7DO7bnTaaeniHsgr9F5CxMJwZVYCd7icZ8UF1M
	nZVtlanzV4QM0ZheH1jJIqbxZOkncduo5Kd98R+L/JiivbLec8wN4+brsNGH9lDt
	mGYyJdAeCLG6xd9v6cmtPuBdBjK3n5AKPFuJ0nhe2daxt0EbYqgDQaanAVppQmD4
	mvOOqtEjcrkXHlhxsvZztl0YF+1QgnD/mHq9L0aSbyYMtMlKmR1JrAxfZ6FAth47
	ew==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvvaqghas-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:05 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5339739b343so69255011cf.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419765; x=1795024565; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xK1JRZtgXWaa2FgKeCEv1Nghpv+3jJNSaRA4T6QK0EE=;
        b=Sg4mRLe7OoCc9liOO3WxCmPoi05rjdXDOCd5V0w8VIZ2vnyAm3mddb3NcFyT2uuU7z
         KREZnAi6lLjUuuOQGY3ZI98qwuqO0CIov80VfWD730SB/sp9XmQ6uu6bkGylVd8+UpDO
         tuDDptNV044HT9o7YuGG0x/pD7Xp6KkwJg2694TdZoDdtEHoeWI6KYRtY3LCr3XY7ay5
         Ay4ZZV0IjsVllIgVYGLwEaUWDsNHK1mlBfa0gkF5ISzL/+HtQtcrXQZn6J9u2nKMfKtM
         gfcVHTaKpbfrt1HBoTHb2lHtPHo5+S9Abfv8f03J5Nv+C1jtnSHRLiotDZdRx5aLC/vn
         5WmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419765; x=1795024565;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xK1JRZtgXWaa2FgKeCEv1Nghpv+3jJNSaRA4T6QK0EE=;
        b=iHE/ngyWFQLw6lHopTgKsIjjYtINnx1MyWN1mictny8wHlSS1itaTm7/eu/iYnz7ME
         HyHB8b2orwVfMzzyJ+/wswn56PqEfqrtEBYp8R4UkXBAtLf7EgLDchPAePKbTrabs2wl
         WJrlp8EWfGyLTi7M4z35ITPVBN9xYfkvoFgyP3YGE0bVeiUXl13K0NFspvyZUPFeIbT8
         R1eNVZpb7LulJGGF2q8un7uFGt9rtNjKeYy4VGSWwugU4EKLBc9ibZX8K/uXEhfOYaLI
         w6hnwB8l9IrzIsr13Huygc6nUrDXQucvLlg/hPVlhbo9skoCFpDCSCOLI53rW81laYlH
         6URA==
X-Gm-Message-State: APuU4Z9iy6AVlKUrta2kovguK0BBhMMEeSutago0TiNUKuYRoUFfRcSh
	XA/XkwMpNA+OHAZiMc5oLeYgJtlhMFMGcXTRHhXrCTKvap/4z7uX3he1J4efdbwwt3B/HI+GVSh
	uPxazcSw5OhXeQ1zpoMdIMdF4K3Cnu2WTSlF5Ctvs3K0L9dMa
X-Gm-Gg: AYBFou3xw70eLCc/RX6DHhm8+0tVWy41GF7um5E8B/qR3PhJ7VYfPRxRu7NfOrfcr2j
	m37ufOBQl5hbeSqhtlkt0Z+RQxV5SuM0uZzWNZhIB40VSKwM0eYRuhGitw+ke5JSmdhIdZdwq6D
	7NtOCisgeZyJv9J1Nx199uPQBlYayZgb7KwDHHM3xMG3iJI+0dOcjzkewql6yGNnhVXMFrBO0NQ
	heOcJ6qXe7LKKT96sjypNItLsnFMoCWMlnJGdcWPThoMEauwvaMiZape6T5ISzIe9aj6v/rcetn
	mHCgbgGvpeYPTqmUVQ35yOgwLuoZB7ZmsQvZ25c/L1FXK3DQUOvyLxulb140jv8rWOWaWT3qu9f
	e6XhE0FXZ8Majn8kL048KY+tWiDHHiubCb1SkBuWGf0PmWCcjkjLlczagwaffYEiHcvKD/F6M+M
	Kh6+3EZZU8N757UN6SXQ==
X-Received: by 2002:a05:622a:e2c7:10b0:533:7a4c:d8ec with SMTP id d75a77b69052e-5574febf6damr27451271cf.43.1794419765314;
        Wed, 11 Nov 2026 09:56:05 -0800 (PST)
X-Received: by 2002:a05:622a:e2c7:10b0:533:7a4c:d8ec with SMTP id d75a77b69052e-5574febf6damr27450671cf.43.1794419764443;
        Wed, 11 Nov 2026 09:56:04 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:56:03 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Nov 2026 12:55:16 -0500
Subject: [PATCH 08/12] mm/migrate_device: do not migrate a uffd-protected
 zero page
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-uffd-state-fixes-v1-8-00713d368976@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=3818;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=QD3fhak7hRiHJFtRv0X1hOI2rf0YRP0tq/Cu+tCY/Qg=;
 b=5bcXHOtBf5tgUNJ6jIVkTFe8b9rYlsTbht1Oh4swvTCyob8c77wH08VFBs9uslgFSrvMdWn1h
 Dr5xMwTt8FhDT8OTtNB6bxF5dW5590n2RAkVoPQg1c4mOnOYnzjpyXq
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=FraQbGrq c=1 sm=1 tr=0 ts=6af4ac36 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=vkV22ByPkaTMGWZSKNYA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfX3ZwT9fxTGR8r
 zCyN+pB/f9lJOa6QmDotgVLicKeUr3ys8uopijKJMmfK7H/LSHNJKE8nLpLLQ+Y1Iggf67b/YEm
 YFhSLXic6vAhIfMCDvBwheB8Cm/GTuKIt4JJzo3Y8q8ScvAn1u3Bt4aTbbmuVUikipePtaC+xu9
 /DvzYcfAB4t0cBaIV9lMDvr7XzfAB/Z8aKfDwrNW9squGOq5UF/bXXnwMDKRIfOoBrbjX6MU5wE
 IgqRFZLevortVxCByX1oOM7vzyxhcOV/Dvj4t7Kz6Ex9FEN6GUOT3otalszw4tHjxwUrwWXKL0y
 2XA3TXnC7sfiBHxz6FLY19gF6d9GPilUzSldZ1v9+OckXIRIty3VLerbMqKr6sndwuXPi2/PbXi
 BAf5vvBginMLlfsU7lWhLg0m/BapOjleD6uAtSOCVVBr7l0uRJU64vdeLEjGXoE7fZpcaT2o+dy
 FdAE9q1zVvx7lbYdhAg==
X-Proofpoint-ORIG-GUID: ModA2pcSjP4nlXjbS7RA_2Ujb4KzB1rP
X-Proofpoint-GUID: ModA2pcSjP4nlXjbS7RA_2Ujb4KzB1rP
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfXzD1ZP9SKwE1l
 297oktjcKIEOgnB5znDmV66vpU1E/DgApPIZU8mbzndiR6T81LapDhWOiVvHnLtZqb/amnE/W8o
 q6WV3rKurXxvv0I3LO08PTj5x+0vTBxUOemXylHPxSjLyR7lvQd0
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 spamscore=0 lowpriorityscore=10 bulkscore=10
 clxscore=1015 priorityscore=1501 impostorscore=10 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110071
X-Rspamd-Server: rspam06
X-Stat-Signature: jiax46ywxor336f4r95turthee3a4t1o
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2162A1C000B
X-Rspam-User: 
X-HE-Tag: 1794419766-802957
X-HE-Meta: U2FsdGVkX1/oDpdpLft/DwXrA3tPxcAe9llmNBUh98GbNhNJSPDbBN5b0gvQvA99b091ytzMiZYbDV6mTtgJ6rgLgigzwXNP/42cFTsY2BLiTAZeRjQUOYDph8zJa4r03NcMyIvyr39VTdzSkhFvrX3CehS/2+FQ3hHRb57/NGW3J1tg80kLpjI19YA7CA45GzdcYIv9YL1BB8m9yN3aK4jxwbLBrvfOyq60dtYXV3jKPJ8gi3wrcG1+jwLJ2Zd7t48Bc+QlTfb2nY5sbaNxmm4AtkG/wqR4oKgjErjGAvzuO2uFKodSCfqBOSG5li5AhPeOdrJYOQ6TL/XWRG2lfPVLhOGDR3wrUhbVztUnlZis6Y4n7dU68omFFurR91YHLuakJivkWAya7PrUWkpK9RPe6MQ+jyBfaOGWwkAqGwL4cAO0eLuYgQcaZfEewBlDgR8psC+ybYkfty/ucpM1QnLa2Hz4XHMplB69QYcCSayEFcQsnzY4kJuxqJX0eDt6feI4zBzrvHOmPpcdOphmfcx5hSyl5S4Rj1grtKnT2PwhGpIXPLhf5URb6h5eDouQK4zfIPeiKfa7oT2FHN4je83FZwZ6hQad4GHXtgKeu2KAIr8tRlw1XRQOt9/w76tD1TveXvtXGpbS/yYRNBFH+xqUvMOdWCXTv3eyzGoL/TcMmwkdE8vgTeh4i2SeYZ8+eDF1hUMB1cgDeld9w1SrcFTDaWhhBurhWIL1aeM/DzFRdIWRkwMpZNeZNOp5Tad4/cPsEs8dvnX17Lkw0tRkMnSzgM6NEn+EGlxqPnkA4tszt13pEg9DrFAitA87+ZgbfwJt89e3+r8JTBmmPHKItQuGiZ6hLZuBr7VB7COCXrusSxWOc+oud2oPiaJLZEhATy9oAlFGjDqvVIvh7MdNpl1ov4yxxaFCYBlh5Gq2WjYV/KJlNC+b8BwyDe/w5W6UyxFZelrZZDdWs2NyHf1
 Bh/3aQn2
 6h12t0wChMHOsN/+RdoPlvXcBLqHztE0nAs1daZ1XgZM/j3g3nfrA74uFV7pfzIjp0hukoxn9dibzAxD/eaOBZFzE47bPq9uHqcKmXi5lIQT+YwPRuUmPJ/CBZuYZUswmjtDePL6TlsYwvQz00xeTmKcdCbkKeiivbYRyTe5XCynIQH/wcjbuepS7zBkvu4WLA9HbN+UzycJEHu36pJV1MhK+wkNnBMEZKt6W3K7j3lraegD1wpwSiQhh01dlJNyIRLBh2484/2pQLQGGufvbMPV6fukf1GG7s7mldszhxaa9W1OpxhnnQLon3BU9KuSZ3LSEnu/5NnAY/VVYJyr9HfHjrwk6OO8hc5FrduSJ3/6hmxBebMxkncuoHwjnAbRcueZzk7UE8uoCua5ZpDLVPWZExlmpwnVeS0LMMtGiHS7whSSooSh5eB1Xkea2CIkwZev08r9zA8eV4HuDmfn9tJsRIvROLFZY8TXS+rXcx/fz9vFPzNz2ZHkajg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

migrate_vma_setup() installs a migration entry for each page it
collects, which carries the uffd bit over to the new PTE. However, a PTE
that maps the zero page is left in place without a migration entry.
migrate_vma_insert_page() later overwrites it with a new PTE that is
built only from the VMA flags, so the uffd-wp bit or the RWP PAGE_NONE
protection of the old PTE is lost. The same applies to the huge zero
PMD.

Once a driver has migrated such a zero page, writes and accesses to it
no longer fault into userfaultfd, so the manager misses them. With async
tracking, PAGEMAP_SCAN unconditionally reports the page as written or
accessed.

This requires a driver that migrates memory to a device.

To fix it, do not mark a zero page for migration if its entry has the
uffd bit set in a VMA registered for WP or RWP. The driver sees an
address that was not migrated, which drivers already have to deal with.

The uffd bit can also be set after the zero page was collected, as
write-protecting only takes the mmap lock for read. So check again under
the page table lock in migrate_vma_insert_page() and
migrate_vma_insert_huge_pmd_page().

The alternative would be to carry the uffd state over in
migrate_vma_insert_page() and migrate_vma_insert_huge_pmd_page(). Not
migrating the zero page is simpler, and a zero page that is protected by
userfaultfd in a range that a driver migrates should be rare.

Fixes: 292924b26024 ("userfaultfd: wp: apply _PAGE_UFFD_WP bit")
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/migrate_device.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 7919e04abc1c..ace216ea834c 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -159,7 +159,16 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 
 		folio = pmd_folio(*pmdp);
 		if (is_huge_zero_folio(folio)) {
+			/*
+			 * Nothing carries the uffd state of the zero page
+			 * over, so skip it if its uffd bit is set.
+			 */
+			bool protected = userfaultfd_protected(walk->vma) &&
+					 pmd_uffd(*pmdp);
+
 			spin_unlock(ptl);
+			if (protected)
+				return migrate_vma_collect_skip(start, end, walk);
 			return migrate_vma_collect_hole(start, end, -1, walk);
 		}
 		if (pmd_write(*pmdp))
@@ -337,6 +346,9 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
 			pfn = pte_pfn(pte);
 			if (is_zero_pfn(pfn) &&
 			    (migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
+				/* See migrate_vma_collect_huge_pmd(). */
+				if (userfaultfd_protected(vma) && pte_uffd(pte))
+					goto next;
 				mpfn = MIGRATE_PFN_MIGRATE;
 				migrate->cpages++;
 				goto next;
@@ -878,10 +890,14 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 	if (userfaultfd_missing(vma))
 		goto unlock_abort;
 
-	if (is_huge_zero_pmd(*pmdp))
+	if (is_huge_zero_pmd(*pmdp)) {
+		/* The uffd bit can have been set since the collection. */
+		if (userfaultfd_protected(vma) && pmd_uffd(*pmdp))
+			goto unlock_abort;
 		flush = true;
-	else if (!pmd_none(*pmdp))
+	} else if (!pmd_none(*pmdp)) {
 		goto unlock_abort;
+	}
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
@@ -1081,6 +1097,9 @@ static void migrate_vma_insert_page(struct migrate_vma *migrate,
 
 		if (!is_zero_pfn(pfn))
 			goto unlock_abort;
+		/* The uffd bit can have been set since the collection. */
+		if (userfaultfd_protected(vma) && pte_uffd(orig_pte))
+			goto unlock_abort;
 		flush = true;
 	} else if (!pte_none(orig_pte))
 		goto unlock_abort;

-- 
2.39.5


