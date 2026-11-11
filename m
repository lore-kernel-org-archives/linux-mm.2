Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A111160A6F65
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=SxdzbLS4;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=xOYMBD/Z
Received: by kanga.kvack.org (Postfix)
	id 5F0B36B05CA; Wed, 11 Nov 2026 12:56:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B176B05CB; Wed, 11 Nov 2026 12:56:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3D26B05CC; Wed, 11 Nov 2026 12:56:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 145216B05CA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:56:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 991C2403A9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:56:02 +0000 (UTC)
X-FDA: 85423591764.25.9F87A50
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id CDAC6140005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:55:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=SxdzbLS4;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="xOYMBD/Z";
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A7PIp2Su3GVSOwbPaxAMtmcR8wjprP5YambQK0BRZCI=;
	b=T8Nnnic/WXcg1YrOOQWxEcZsA7O5fDapIl0pHOgxRJ87LaRdOhF7pS8n2t9ykOxV+jLnkc
	opr7HGckSucmbtXfUcDZ1kXA8+S16jzp2sMi3dx0jzo74iivSF8XLdWN0WBzU3qcaw3EPU
	e2a3vq9CVv8O4TtDy6JO1w8F2eIGTYw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419760;
	b=xDUek7KiRgrSC5RwQ8WAkdh6n4TMIuahg8ioE22wxM6BHW6PoBa7UbrrcWIzFuxK94zDLI
	yUfFYgERh5UcKnBFjxQ0/3m1hOSeQ5hvCrVOzOeiOz1ye67nSTnl6ebG1Z6O6NXapZ3/1v
	2hzR4spSIwKDh+2SyBHRuSBH+509Xw0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=SxdzbLS4;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b="xOYMBD/Z";
	spf=pass (imf09.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167074.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ABHYXST826286
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:55:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=A7PI
	p2Su3GVSOwbPaxAMtmcR8wjprP5YambQK0BRZCI=; b=SxdzbLS4pNUW/TTa4eJm
	dvNUC1nq0hG8ZW6AdBLvA9HLGsvEggmNCU2pwQ4ac/YyjGbN86KE5KPqFqiFdrdj
	ZV69lvwigClyapAsoae1GW4D9k8iQqMwxMoO4FTIZnWuuqpUEIbSwCv3z8HM3QAp
	RPnbN95u8IU4jxPeQyl4g060zeT5TAKcTq3JJxWaabdmn2smv6PtAY1PpxqLhm26
	bU6tdELtcs4DSzS3OMj3jUl0uVFle9qq99mEHFJF7mvUOaOEEeYLDP3f6AJDFH9X
	C75LewDiwRU7EKuBSTVNNnQQ+BZnJzbKnD/214HJfjFSWMWTzB1AivEbf/EEre/V
	Yw==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hvvaqrhfw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:55:58 -0500 (EST)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-536778a8137so66129741cf.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794419758; x=1795024558; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A7PIp2Su3GVSOwbPaxAMtmcR8wjprP5YambQK0BRZCI=;
        b=xOYMBD/ZqK3nzRC766z5z5Viqa/SwLM4V0V9a6FTZpVobb2FJup7fKMb0bRPwW2WF9
         uC5tBDsoUOxMOS+TG6Z1PqpNiRmgTwr4fWfA7M6YWxC1wjUAR1aMi/DZbTUgszMoL1+3
         KEn6jJjdBQApre9hXvxG6tBmIL/sAz71Gh2GXuTDcg+apxtJC/LOYDkR13Rk0KZ+tbx8
         LJsWVbzLfE13WyCba8sODRuBbYzyPoF47HaEXxnUDHORJ7USJDTDql1EP/z7CMVgcUn6
         7CsF2u0FF2EuHEaGiAl70UY0OlCTNdmJ3h0TppnBTM6JjVGYjh+zg2ZsF5m2df2Nh7Bx
         yF8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794419758; x=1795024558;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A7PIp2Su3GVSOwbPaxAMtmcR8wjprP5YambQK0BRZCI=;
        b=AxwtohG4g6dtpnUXYy1rxibKqzbyMdyJAuLyxkOzdnmqPiwl1VObOkXVFZW4rg9na2
         avNYAAt7B85ivfHRzjELUMBf4VpuFVk0atBHZaVvuma6+w5rBzrouPTkIxI9FlShZl6F
         0Goa3jy1gJ7R5XnzcpXZN1QD33V5gf1xeEEpwALASOHdzU3o17D9yFzV8FWJv47Kphnc
         vgzK4oij3zIGeiB1K0/yZtvAVhkSqUi/eNo/+vU19cS+nQqPM4Tv2A335jAMPXHgzlC0
         8xJ7+c31C37vfn6ZA0G5WBAGs4zv/Gdjf2e3bLzZZ+JgyohaVOQBX+7h5Pdgn9Q8qmPc
         jsqw==
X-Gm-Message-State: APuU4Z9mwW8lhCQPtP1ZGcqSX+lBNVqQsyK3VakBaFF5FvZe5rONHWF5
	1+Mx7rRxV5wPA7S9EIMu3Pc6IW4aaRqfiUmNEwcvpDS+9c6nkcFQZVIoFcOibFp/0CzLYBL8w4W
	gl/ZgnhIg7ox8moR0CPfcbsKNO+36IMNEDwIjggLG7YDRuGrd
X-Gm-Gg: AYBFou1zwwxXrK0UO0kqzqxSNTTDxhJij3aMa9adrqKM7wKgjs0iOF4Y1YNaJAei3pn
	gXGIgN63k1TW0PRga53p+63iqB19SeFLyclFbQ1O/F4x6FmwMhE103/vgipAWJFJQT3rRgEZeoK
	VHPA/wA07x1iLmz1FkbihWHBJIwTp1oG3LMj62ThJgCIHLqqV3bqSX5ECGMKVddCLHBToeSlTLD
	AiTGj11AlagD8AO6NU/EADLLwpLyA6Or03sj0BfSaejnEElMFrPmdHAeAFvI/ZRRYJ6T6jjFJdB
	env4wd+MU0LgVQJbgnFFGqPXq8qUr68FdH7rt0nvE4Ehf9vwDpnUq36tiE2Z/0LFQiK1ZlHg5ML
	dA2JrIAmYn7L+g8e1BAWXSjVL2aEVWpQFWOYj4bhVaGVtioT+Yya8Nr6meZBWpg9Kpy+tXqdUH0
	vu1+OVNPZhca81y9HoOg==
X-Received: by 2002:a05:622a:5592:b0:536:7c84:be60 with SMTP id d75a77b69052e-556c177114emr47916841cf.65.1794419757843;
        Wed, 11 Nov 2026 09:55:57 -0800 (PST)
X-Received: by 2002:a05:622a:5592:b0:536:7c84:be60 with SMTP id d75a77b69052e-556c177114emr47916261cf.65.1794419757226;
        Wed, 11 Nov 2026 09:55:57 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5550b93ee00sm54974231cf.16.2026.11.11.09.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 09:55:56 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 11 Nov 2026 12:55:11 -0500
Subject: [PATCH 03/12] fs/proc/task_mmu: downgrade writable migration
 entries in PAGEMAP_SCAN write-protect
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-uffd-state-fixes-v1-3-00713d368976@columbia.edu>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794419750; l=4502;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=CmziNLSgpRPr6xpV0ob+23DUmSuzGkcGrlWyUdxd3eQ=;
 b=Rni1CSCL/up+hUsSi3ClQqRFM7waADYPJyNCw/C6x1CM2LwrTPTaPEjbnEPjHgq8p8ijn+k1m
 PXpu1mmb3KZAfplhneYwAK5yNeUMY86/01Y3PQNM5QX7QhS0VKP/iJl
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: mroa_x_DTZ0Xg0VTthkWr9uAal8nAs4i
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfXyHu6pbdJUC3y
 VhOyD3HrAWKFBLuPmNWoxR+uzoeQJPNXvktpTC4hZxm9x4l/XMLxQOAT3+Pcx8kmCfV/gg7a/m3
 pI93ktY+cdeOF5AwCn8eRiKfHoCMCX9dIOs4AuPTsst/XBBzRf2W
X-Proofpoint-ORIG-GUID: mroa_x_DTZ0Xg0VTthkWr9uAal8nAs4i
X-Authority-Analysis: v=2.4 cv=dqFOmFg4 c=1 sm=1 tr=0 ts=6af4ac2e cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=azVShVRs0zEubeQ0wG0L:22
 a=V3FC_PkR7xI6twvvc-cA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTExMDA3MSBTYWx0ZWRfXxigMtBOphhOl
 NgEX0SEg/VNO7uLXzGFoZQTQPIgpNsTYgFFXqTkTbzD/cmoMChg3AiDmH7O59vGQDoeIyQwvTHD
 x03uadE4BD8Xw1uRE53D8eBaD6yNlyDM716GvO0533JrgJWof9mXVPgrLGANW5L8zpuPW4+tLRG
 N5B3IeXU+saDfBjsSBUvauHZn/bioswRJSfpHL9zXdq9tWFwpv5CCplQ+xPo2EgbNmH5euRbPfJ
 XP4bBLQ0raU+Po3zEjX2Us2ghI5BEWsSafV0N++IeHcdRoeb/1HJdl90lv1GegFG2Y89B8IAjmJ
 iu/28ImgsdR9zUGMezgs6FL36aVc/gDRf5qBzn6FCW25qv3apNbV56gcQv8Vk+lCmLDHKpE3os2
 xzyELwBvAGWJWb5tWh5rVw0fiXOHmcAeWJkqzzt0ygumrcEajl+r+lu6dbVHGjYdONzN6IGQlev
 kXJjbKPZSYgZLK9Oi2w==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11963
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 phishscore=0 bulkscore=10
 clxscore=1015 lowpriorityscore=10 impostorscore=10 priorityscore=1501
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611110071
X-Rspamd-Server: rspam06
X-Stat-Signature: 77h68ywpti1kpjqrcnqiw8xeb3ohx4ao
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CDAC6140005
X-Rspam-User: 
X-HE-Tag: 1794419759-318738
X-HE-Meta: U2FsdGVkX1/Mh0De/p347nRrk+fQIGuDTvmNtMg1ZP8j0mLvWfGWJiLZy+I3aRpfKloXAbpWQmsYL5USeiPgRO1eanyb3k9Im3hx+/5fIaAYVVKoU7KRDiOT4U28Q1x0234mhrQyv94DBWxvaaRDomQMkIx5VBACMLgj0WPIARmJBOFysCajwtvoX89l0CHFEcPp3jEof/Bdh4t6YLoeSXngH6D3JzofBQoc+SmXoxphVyxV6KxI3Zvgug4NnjyuubU+2MlCAf4df9R5zN+OkjpcghB3yJ/37g7aUnY4wTSwKWgKyS+bJ4ARhTS2AIYee5QhvGi3r4rRi1y0SawhnHnxxXaOyVYsyilr5mvQ2qrX3m3g/tYDv5w0wqnWobcZyyzyNuDDnm+VaOKShqzkYcL+VrV3nCiqE/lYoprlM0I16EB1Ie2KDv8ccPfvWu4+BD59Qa8KuF6kKwWzC7cGiIHfucZ4QrPecM8wyMmnp8TZXAqbTNr8l6dK63CV5S3rdtT5MY4V8FRdvdB6tx3grJ/FjiRl4vtmhbWAyKlIShVXOS/oe2ZzbQX7EXpZUh5d58fuTiR3Gcql1kfAqwd2eS9BsQ+FYPowF5Ow+m21jJcAkr/hOIvrfzYrotsHoUweogBOwaAVPj6klQFmMzMFydswvmAleCu1sGiAgvVYo2vilox3mcTb65DDClDEf3M23lp6CC62D1OJCfwyMsCItQCVvuAwPXIKIqxf7imisxkAAyKwU2lTLQEZCticaeMeNybE9WWgOQxnND+y3G9B+XZdC5yb+AYwZ24/NWLhBPNsvtDXlOyKTpr26DF6yBTSslTQ6sv4jv3DGLlFl4Lj3ZlfVlNoihQ9o23KAGJL+VN4kav1NQO6Ecw9OX/0aG1j320vYiFF8KkmZe7Vt9Xgv3Kx9O/m3z0Dh/jFmCAdN/uFonQY+d3FvR5DAzgYgEIooM68q4Q0lEUyPbh/rl3
 nFy9W9Js
 rIGN+T8bEyTfmEo6e9mVQuWGca+arDbCLl1XL+vQqh9gfHp54fIvC0VIrQ7oCPP1nS/CImo5SwitnI+9Yc1LLAgVtpjhDOCmbaJwJ4+LUal3WCwtdmbWa5Hb86yJxvkik8WUdkphLjihnmkgQBdsuv2myd4xVqVN3L8gosl97A1K7fQ8M1jFoqXLLtnXjkp+Zellg/+x1s2O76SwS60Lr1bbmb2V9Hv+NyUXd8aR1xm7qDm3pw+YN+bNvxeHXbpX7gVLI0DWMZEHhQ/v5KCbnvFLKT1NpxsBtiemurcRjX4mllVuD0IfAZh68c63Ry3XBkNaWQyEuw8ZdT3C9iv85E2PCiJPiXm68m3UTryNH5TOQmsLWiS1ey8TZiyZrJaG1zhdkzSnO5Nic9yVxTIeiiBGhESOtEveS4uIx6qF3XiK0YFZ+5bz+isIkMXvWMnfNx9GpnxEhYr/jgU8IdqtqAb8ul7ISe91qmGwanO+1P9Y1z3z5Jfc05gWLHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects pages in a VMA
registered for async uffd-wp, and sets the uffd bit on non-present
entries as they are. An entry with the uffd bit set must not be
writable, so that the page is write-protected once it is mapped again.
change_protection() therefore downgrades writable migration and
device-private entries to readable ones first, but PAGEMAP_SCAN does
not.

For a writable migration entry at the PTE level,
remove_migration_pte() restores a writable PTE without the uffd bit. So
if a page is under migration while PAGEMAP_SCAN write-protects it, the
write protection is lost. A user tracking writes with async uffd-wp
sees the page reported as written on the next scan although nothing
wrote to it.

With CONFIG_PAGE_TABLE_CHECK, setting the uffd bit on a writable
non-present PTE or PMD also triggers a warning.

To fix it, downgrade writable migration and device-private entries
before setting the uffd bit, as change_protection() does, at the PTE,
PMD, and hugetlb levels.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/proc/task_mmu.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 51 insertions(+), 3 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 22361607020d..53780a454432 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2395,6 +2395,38 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
 	return categories;
 }
 
+/* Downgrade a writable migration or device-private entry to a readable one. */
+static softleaf_t make_readable_softleaf(softleaf_t entry)
+{
+	if (softleaf_is_device_private_write(entry))
+		return make_readable_device_private_entry(swp_offset(entry));
+	if (!softleaf_is_migration_write(entry))
+		return entry;
+	if (folio_test_anon(softleaf_to_folio(entry)))
+		return make_readable_exclusive_migration_entry(swp_offset(entry));
+	return make_readable_migration_entry(swp_offset(entry));
+}
+
+/*
+ * An armed entry must not come back writable, so downgrade a writable
+ * migration or device-private entry before giving it the bit, as
+ * change_softleaf_pte() does.
+ */
+static pte_t set_uffd_wp_swp_pte(pte_t pte)
+{
+	softleaf_t entry = softleaf_from_pte(pte);
+	pte_t newpte;
+
+	if (!softleaf_is_migration_write(entry) &&
+	    !softleaf_is_device_private_write(entry))
+		return pte_swp_mkuffd(pte);
+
+	newpte = softleaf_to_pte(make_readable_softleaf(entry));
+	if (pte_swp_soft_dirty(pte))
+		newpte = pte_swp_mksoft_dirty(newpte);
+	return pte_swp_mkuffd(newpte);
+}
+
 static void make_uffd_wp_pte(struct vm_area_struct *vma,
 			     unsigned long addr, pte_t *pte, pte_t ptent)
 {
@@ -2408,7 +2440,7 @@ static void make_uffd_wp_pte(struct vm_area_struct *vma,
 		set_pte_at(vma->vm_mm, addr, pte,
 			   make_pte_marker(PTE_MARKER_UFFD_WP));
 	} else {
-		ptent = pte_swp_mkuffd(ptent);
+		ptent = set_uffd_wp_swp_pte(ptent);
 		set_pte_at(vma->vm_mm, addr, pte, ptent);
 	}
 }
@@ -2467,6 +2499,22 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
 	return categories;
 }
 
+/* Same as set_uffd_wp_swp_pte(), for a non-present PMD. */
+static pmd_t set_uffd_wp_swp_pmd(pmd_t pmd)
+{
+	softleaf_t entry = softleaf_from_pmd(pmd);
+	pmd_t newpmd;
+
+	if (!softleaf_is_migration_write(entry) &&
+	    !softleaf_is_device_private_write(entry))
+		return pmd_swp_mkuffd(pmd);
+
+	newpmd = softleaf_to_pmd(make_readable_softleaf(entry));
+	if (pmd_swp_soft_dirty(pmd))
+		newpmd = pmd_swp_mksoft_dirty(newpmd);
+	return pmd_swp_mkuffd(newpmd);
+}
+
 static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 			     unsigned long addr, pmd_t *pmdp)
 {
@@ -2477,7 +2525,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
 		pmd = pmd_mkuffd(old);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	} else if (pmd_is_migration_entry(pmd)) {
-		pmd = pmd_swp_mkuffd(pmd);
+		pmd = set_uffd_wp_swp_pmd(pmd);
 		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
 	}
 }
@@ -2547,7 +2595,7 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
 
 	if (softleaf_is_migration(entry)) {
 		set_huge_pte_at(vma->vm_mm, addr, ptep,
-				pte_swp_mkuffd(ptent), psize);
+				set_uffd_wp_swp_pte(ptent), psize);
 	} else {
 		pte_t old_pte, new_pte;
 

-- 
2.39.5


