Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61811606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=HGicbANG;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=uvzVfnCL
Received: by kanga.kvack.org (Postfix)
	id 7BF026B05BD; Fri, 13 Nov 2026 17:27:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796DB6B05BE; Fri, 13 Nov 2026 17:27:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 661CD6B05C3; Fri, 13 Nov 2026 17:27:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 326AD6B05BD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:27:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A113EA02D2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:27:06 +0000 (UTC)
X-FDA: 85431532452.27.A8C5C4C
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2D487120005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:27:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HGicbANG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=uvzVfnCL;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794608824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3ajvUnUKvbfDkC0sZyMQAhOCqZi8Pjte/39RE1cKJ8=;
	b=UEOZKN2qUeESYwJ78W+aRUWMokptQWtET7qHeawptGWGhNzNoL++nQ1c4PoXhvwI0ak1P1
	MUvJ6EttTciMDN+oRdWj8e0PGN922dkj5Zm0EsCrgx/oJUzCOc/bhGXb1wJLXeDjWGNPKm
	yKyyNRrNc0r1jcpSCQTcFD3tecJSVgg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=HGicbANG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=uvzVfnCL;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf29.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794608824;
	b=AdaBrtWbgszY896w4E2ZjZ8yzvitdqwAJjB0vE/WTJ6DpDv6p8QSNqhvDRSbB5CS47pIEH
	8/+TTwMrB5Wj59gKzAcnHLIf5atC9Yk3aho7QW0GeX2whHoNahlIzoYBJqZsRncHJgRvED
	QVsY1aKbPPbAjQffurC8eOv2qdYS3gM=
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ADLmmcE3550220
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:27:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=d3aj
	vUnUKvbfDkC0sZyMQAhOCqZi8Pjte/39RE1cKJ8=; b=HGicbANGO9fUbtt/aiBn
	O0sACCFk6E8cmIzgCKsA6nhZEdR0F7t9f2sulpxbXAbF/IKZuu/jWZ3k1aHAMYl5
	Gyzsr6ysglkRCuVhPwS0miRm3Jc69PfXSLEEw0dUQD0DyScKj225DNGi7R7gEFH6
	TW9XgQgXErQ+NRu6TcRjYquK5cRK/B656dBLMGr0L3iUfXE3Rt9siZxNJzWSSmBp
	l0DbMRJvG/SyMolN8iAnTNIsXWNZQnRoIU2TYs5MHLlwvvlSyXx58IBELc6AlaZb
	pG1aBzZYZSS7kZrJ6b5exQE9kIATQ80gcBS2/hSSkq+YnAnjo6KL8ZZAHA0U5tVt
	sA==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hx6n82tj1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:27:02 -0500 (EST)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91c046843f1so24645136d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794608822; x=1795213622; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d3ajvUnUKvbfDkC0sZyMQAhOCqZi8Pjte/39RE1cKJ8=;
        b=uvzVfnCLOwBpMIjzbqXnNBJml3kgEosS+mhnexHmwbid/QW5Mk/xsylg2iM5MhSFuO
         ucCJz3Y1qcm4YSCYFMPMZr04QjcvWNtWuF0cuUAlDg/fjOpwgxNW3r3QxwD+9EvD6bcW
         uKPpEplEXAexXUztECAoGAW31fj0QV2B+S4W77sI2crpaOWZAtMg0gC3EExTT54xZJz+
         AuqrU0hTRF/FG8T40sLs2Fur+6cIq+bS8PfqsDB7pPpvaZd+NtdsJ64q4W8FFzy5Sq/0
         WoQ4P3vVCKGGXFz7pqeNGuDB3GllJ8xIPeXMuLOHAOuSJ03lROyXlzDu31CrMD0H9kil
         4fYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794608822; x=1795213622;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d3ajvUnUKvbfDkC0sZyMQAhOCqZi8Pjte/39RE1cKJ8=;
        b=1rtSId8H1H9of8MKJz8/OYo/SJ6lmWeDJPCpoz6l/cxTObpk73oenJtvhQJhAFmi6+
         HQxJECSiuVQqMljb6l5i6wiDtzryv4Q7cjVITxULQJpKvipKmcctabWeOivYtriI96Uz
         zAAQFX5Upb9Q6kHBt9FoNvpNwjohWy3xJAuA51BPDB7wZQSWRchySPfLnGjosPS7hmj2
         Or/L+P2hdlz+Mlo6glOwZJHf977smE+1SeT9S0BOtHpKEOTV4AugfvTyu+8OKEYR2szi
         IfnK1BgZFcb8h4bU79oT2aLLm2n1M6akVCBD8x5E/Luw2udvIe4xbNThjXeNV3mf0VKn
         Z0PA==
X-Forwarded-Encrypted: i=1; AL+hErEzJvl56dpVp8wWFyBA9qhBmXGKhF7uNUgEoyvdvoLpBwvmI4QoJJjYFiOCO4EVWPVLnKAgIMijEQ==@kvack.org
X-Gm-Message-State: APuU4Z+tSUs3VY3ps+xPOe3t/zHu4jANB+a5LFBopYrWlr8eFZCO6iXr
	38nPSsCP2e+ptBGAWEjrLkRTv8H4X4mDiMjYnG93EdU/wRiAPolS5rjI7twwTu+g2bAXCsl37ED
	0uhy+FAGePgmTlHjmkXRh3unqTjVI/BPwwe4aRckoM8ADijXM
X-Gm-Gg: AYBFou278UoOPWD2QuyolRoWn2KA/oG/wepl+QZ4YjpTAkk0B/JTyTcgdF9eW5fBXP4
	82Sduj0pOZga4dNEEOejzuXEzQLo3KOHy7hLr8/GxK7SN4scUsT5//I1+Vn4vV5jdED/oO/W/sq
	ghLWwSrblQ7VLepkxKx0rSMZVP6FPfPmMzlD4qXcJQvZBLirQz6YURkgeK5wbkAND6LZdB74HoR
	MiypkZFrIzYYFq3ImuAqG8o3/n/Uyb2unkmEGuGoRKNIcW/e9ZC/XoWuw35dfs3MhnTq61WuJjc
	qEXY6nP8QO5HgwenvQud6nh+5YntQ2XXBcHYCppUm7deRzgjd6G8KTPcN3fa16jYs2S12ZeZoi7
	eijRWJ9fPHlQ85a6q5BQ7usUIGoBDbH5y1w83QTgAy7teYdVQ8bsHgrhtNuLlzJmSOO/kNo5ZOy
	Lgc8l6WoRb2xlij8BvUy9WHkNc0tE=
X-Received: by 2002:a05:6214:8093:b0:91f:26f7:281b with SMTP id 6a1803df08f44-91f26f72946mr45436876d6.43.1794608822136;
        Fri, 13 Nov 2026 14:27:02 -0800 (PST)
X-Received: by 2002:a05:6214:8093:b0:91f:26f7:281b with SMTP id 6a1803df08f44-91f26f72946mr45436426d6.43.1794608821604;
        Fri, 13 Nov 2026 14:27:01 -0800 (PST)
Received: from [10.207.116.169] (nat-128-59-178-153.net.columbia.edu. [128.59.178.153])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d73258sm30148506d6.24.2026.11.13.14.27.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 14:27:01 -0800 (PST)
Message-ID: <c3a51a9c-083d-4c76-9a62-b7a6fe69a121@columbia.edu>
Date: Fri, 13 Nov 2026 17:26:59 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/12] mm/migrate_device: do not migrate a uffd-protected
 zero page
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport
 <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?=
 <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
        Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-8-00713d368976@columbia.edu>
 <179454988585.482102.2051616940227067987.b4-reply@b4>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <179454988585.482102.2051616940227067987.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: eb7riRhITgicBsGGxHbvZdCmgcr3cS8Z
X-Proofpoint-ORIG-GUID: eb7riRhITgicBsGGxHbvZdCmgcr3cS8Z
X-Authority-Analysis: v=2.4 cv=bpLZl0ai c=1 sm=1 tr=0 ts=6af78eb6 cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=Y+j3KQtDOE8TDC6EXH/Ajw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=zVEXuFSi5soEGCQpuH4A:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEzMDA4OSBTYWx0ZWRfXysq+gzlgga6L
 sKBShs+HZlqyOYBtRwxMNNyXDmT/TMjjd7C3UYDw1pq91YYZ63h4/FpmOgBqlcysIfkl1Y7DtkJ
 tp3IxH0TV+G2zXIYeV3fOOATCp6jRqof/iFkvjBbw/MTU391zTBKtAtX1gKfJErUmGXlFhOoY0T
 AUEXiAF3VQJSKzt74SHQvVg6TD/YqDemlej6VEeGCtV1iSLRIotyXvSJl6STq4+FT2TAtCDZdQr
 aZ2ZLXspjsjpwjWrK2ndI6uoxORqF/DK0vlTfjVEpy/P71w9M+9EYlfz9ir/g4jzYHNEEUGb737
 7YeFc6c88qHhkR9eoR9cVzWvlHJag1WUPSeYO3PkDfIQ2p5oajr1748Vo1claq2kjifC3s9t9Fy
 Y2SeLgSzP8OpXCQYeh5prO0nlx0IH7nTtoi9sNSDJ/mdjEjWADLB3djRzR1BE9hNHt2qeMyZI6I
 d1xKea/7jorCkvPIvgw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEzMDA4OSBTYWx0ZWRfX6KXOKy14p38x
 rpEwbVtkaSfzJHOW5YIJ9Hebus2UOge6Nj47u8qFuYCA1T2ASEu5EYsLiO/wgjL1mvTJfDsjM9X
 g3JyLgOB/AZHkx/0vdzjN2Ol2g/P9aj8VoxZre5spxPjwEC/pNH/
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11965
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=10 phishscore=0 priorityscore=1501 spamscore=0
 bulkscore=10 lowpriorityscore=10 adultscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611130089
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2D487120005
X-Stat-Signature: d98hkauen7se439nay9ptg39bu8sdjxb
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794608824-684222
X-HE-Meta: U2FsdGVkX1+6oqHhWnzhEbQ/XHlcKiE8qplNM1fLn7T6BwQrHITuixPDoBJB/W57dBXN0JqWrLf1zmkRU7M8Vy6rJkR+qtHbN8P+3yKuuRbr9pkyBV/a7M7otbaZuNCi4rzOxNkccIslezbmbDcJJ2EDj6Tovsfx2hKEGC3TIlN4Jh6NdtqzgE7d5kqR0c6KWw0aJqt6pgfG5K287wtsAUDo9+bBLgoTrWM2ZlUR5GJ51jyhsZksdn3pL4CV5ohg8tH9hMrBfC1dcwipuvNqQSkpWE+Bt49rjUsmGOVBVhzomLXjL8zXyJ8ffp5rlsEl1OBYf6eZtn91WQedOSMpH50KjN1s/z2l6+1LGUD0+8+eecYZCUboN8oRROt928wVJAn1ATkGED2rfHBtitzKSEOb7MB6+OwbzLBLY7ZleISZahyQypOvFmTKyWN3w/eDEZpyHaZ2BnjuVqhdVfKdQ/nYm2z5AmbnDeUObD3Cq75jMyi74MHTVZQrTUxbWzj5AZhWYRSflHscUil5rrnrSULRwOCA51mYO0DlP/HBnylNhh9jXfphnikLx5IwL3zuyDy9rPBwSyBB7TdKCLL87TIHVC1JNpemo3YikEm/TtcqrzoEDOKOzb3oAIM4zPftShVAHKpofc13AI/6mmFH/hHi1LiARZ3EIyG+yqRPFk3pUJVu+Lks2fsfrFSe0EOfvyZISsCgyG5XodHXsS9uYwHEUzANBNDhWM6KpwNuqEUBTK3MVs2MW6LvCOzWeGT9dKJUVKIOg/ehZgHlvovguzKapcv4idpQ1UAF6yyCdSv95CT3yxPqsYUCYyCKJWS///CBF9uV5FBFVJWXlfBt+WX8x0ho5gLIZa8je41oWg1jaJsqOaAekbI06wgAi9FkSp18FUDj6l9lqwnMO+kZIdVs908o1pghfpcz5KHzHbkGsT3M7PCG5ul+TsdrMqbkbg4XNittC+rN5csFyZ1
 0qrhcOuf
 0JyQkBBZPVARhnkAU4fqsRQucFo/GGVtjeiVvwkRWZ4dKmMPlyAGxtc4TUbbjOV43Kdo3QD3vYpP4brA1raUUoY/6gm7PeXWVJed3eVl+YtX830uocXWXToN3y1oZ5/35xvmYcmLBtpFp/oWkELCuqb0t8JIuyX2C3ed5MDmi/8IARO5r+Elitfn11NaE47ulvPWDxyBZjJPuPo5jf2D5m4+TQMMb5rDrmMrM4AKiN1MQ+4FyPLjpRalA4JycerYt/f4rpQqtTTyxJsMiJIJfUdfUOXTnEkErE0P1mBRvO3dQ0BYs1MlVFEW4AR6tE+z+3id8ym2OfXB3Gei5pbmP4c/wFBfA0x7BK1UTQ13tGP65bzvd9PqC6p2M+QV7e5IbFIbtA+CFpvyk8Vt0eWeX5ImLpY5yXd8hGAc072uk8qlW+65RnXOmV+JHiRlvI9fjfYkAcCi1BI5xEwy+Oiy1AaoP/7cy8wkIfRnF1i27iqeh1zWsGiJhVfebGyE7CYMGSnc1aGiDD/ABQa/x7nEEYvryA3lVbWoKzh6O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 1:04 AM, Gregory Price (Meta) wrote:
> On 2026-11-11 12:55 -0500, Tal Zussman wrote:
>> migrate_vma_setup() installs a migration entry for each page it
>> collects, which carries the uffd bit over to the new PTE. However, a PTE
>> that maps the zero page is left in place without a migration entry.
>> migrate_vma_insert_page() later overwrites it with a new PTE that is
>> built only from the VMA flags, so the uffd-wp bit or the RWP PAGE_NONE
>> protection of the old PTE is lost. The same applies to the huge zero
>> PMD.
>> 
>> Once a driver has migrated such a zero page, writes and accesses to it
>> no longer fault into userfaultfd, so the manager misses them. With async
>> tracking, PAGEMAP_SCAN unconditionally reports the page as written or
>> accessed.
>> 
>> This requires a driver that migrates memory to a device.
>> 
>> To fix it, do not mark a zero page for migration if its entry has the
>> uffd bit set in a VMA registered for WP or RWP. The driver sees an
>> address that was not migrated, which drivers already have to deal with.
>> 
>> The uffd bit can also be set after the zero page was collected, as
>> write-protecting only takes the mmap lock for read. So check again under
>> the page table lock in migrate_vma_insert_page() and
>> migrate_vma_insert_huge_pmd_page().
>> 
> 
> Similar to last patch, this changelog could be improved.  My best
> attempt at summarizing:
> 
> """
> Device migration replaces a zero-page mapping with a fresh entry,
> losing its userfaultfd WP or RWP protection.
> 
> Don't migrate the uffd-protected zero pages.
> 
> Skip protected zero pages during collection. Check again under the
> page-table lock before insertion, because another thread can apply
> protection after collection finishes.
> 
> The alternative ...
> """
> 

Thanks, I'll trim it along these lines.

> I have concerns with this:
> 
>> The alternative would be to carry the uffd state over in
>> migrate_vma_insert_page() and migrate_vma_insert_huge_pmd_page(). Not
>> migrating the zero page is simpler, and a zero page that is protected by
>> userfaultfd in a range that a driver migrates should be rare.
> 
> This basically force-fails a migration of a uffd protected zero page.
> 
> Wouldn't we expect this to cause drivers to fail to make progress if
> they require that page to be resident on the device?  Not sure we want
> to force drivers to try to handle this special case (if they even can).
> 
> We'll need some input from the migrate_device/GPU folks.
> 

Yeah, makes sense. I can implement the alternative approach, but testing
for this is a little tricky without the right devices... I might drop this
patch and send it separately with the GPU folks on Cc.

> -- 
> ~Gregory
> 


