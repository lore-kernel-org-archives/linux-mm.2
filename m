Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11AEB606A322
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=RZ5IEUFm
Received: by kanga.kvack.org (Postfix)
	id 397776B06D7; Tue, 24 Nov 2026 08:24:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36BE26B06D9; Tue, 24 Nov 2026 08:24:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2337F6B06DA; Tue, 24 Nov 2026 08:24:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9D8A6B06D7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:24:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7968B140B86
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:24:27 +0000 (UTC)
X-FDA: 85470081774.16.F924A22
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F53440007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:24:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RZ5IEUFm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795526665;
	b=VDSsVCRoN54VTK4zg+I/LyNd/Hcukc0hEgSjJD95h18LRcmxLgCfbhVURzy3ld9XrWSH1r
	3MFobhLur1tWMPvAdpLFA0Wo/+MPmpgOk8LmPdjc2Rs+Fw5eTJdRDZEm9J/GOHxEw7L/1w
	FGCjCZCTx2y1e1dt2u7Buuyx8XZ0X2I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795526665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j2lGOfpuqWA9c5CeS3NsQ/3TJJfRuyj6wTBADsS42iU=;
	b=1IxGVpKNB7hQTh9o4S+8jyNOJhuConitqmMXycM/fL9ErrAeomUGeYm8RHB4l3gBu8z8HM
	jWTwIpfQTAOc9945iXlptEOeGqfgnGV+bAuQ0aEjTgYBvlzYZgSUYA6HIoRG6dZrS18per
	KnjE6orw4WOJBvHut76RelDhffKvR5Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=RZ5IEUFm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb9d8e8e90so16232605e9.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795526664; x=1796131464; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j2lGOfpuqWA9c5CeS3NsQ/3TJJfRuyj6wTBADsS42iU=;
        b=RZ5IEUFm660XU5GoZPdOs47bz6mTpWdtaW/khwnK2YF2MDRkKHSQVLGyYk7As1XeJh
         u5d4qFEvC8zy8D79tM8DIhRrjoYHVwUk9krDy4e2OenCQtAzJHDgPqX8bDG/qzWHQ1i4
         /vwtwxpN7oMyjLPCH+SOpTbedlJvwKtTnw3yRu3RIM+owS7m0ZNuyI6tAZBgXTV1JG9U
         1CZ/53Cc7Rn0gsa73p4s31HFnmm1XNvrCjV3jSH255GIwOUUPXo/T2RWraYeA2EH1BNQ
         S377Kvd0VTlcv7Edbqedb4CMgb3aJbmPMS9vYHYrT3IkzSO+ihnW2TwCKhhEVJmdmWQh
         205w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795526664; x=1796131464;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j2lGOfpuqWA9c5CeS3NsQ/3TJJfRuyj6wTBADsS42iU=;
        b=tJ0Wa1i4t45b986aHKM2MweKz4q51mh9oSocDkC2vH6p1Noh37pdV6lWQZfp3bunBX
         FlwW700O67bqsPUzhtunFKvqxNkaetmJ3IK02j8xH9eE18jir6AMU27voYFR6gQR/f14
         QY3qIzSopmjnX/82DTJaNd8FwQDSHB2iUC9MLVakaMDuJIGmRuUvpPJrGFPxF0OMKDZw
         dYWUnrPKb2iY//ztB9Wt7O0vvADtFyZAmC3gr8OhjUpc+DzJVctA9NyIMA/XISDVni/G
         Fy9RyycsaIhWRaNg+U3XQRpNxhqok0iOSNBMx/Kj6bwH5xJrCCtmmCbPzXrKwvJzFrIY
         GdQQ==
X-Gm-Message-State: APuU4Z8fjPLzGwYZ/32yD0QI7lioZhsfeDOQcLG6XTmQDB4I74tTqzc/
	AYawn0Dx7GE3O/lFuijdX+mrTMBpu/pyAPG+lZQKfX+m50A0hP7uwKwf
X-Gm-Gg: AZFdTZdLrx6oltto8Qy3W/kVE/bsfoiJ+4+v2ahAmbQgNiSTO/+IELU0WJiOfRdySaZ
	p3JD3sptr0cWuh1LL0AKw0RtJEntBdZhcNVYfP2GaRgiX/0pFzVd5UE3XpeKa9esjmccsrBaI4U
	zlq0vDW8MZ8JzSBRbY6/IZuJAaPLvafXo4zBy3ph/FhAKzXlsjGJUi4Z3oTzD4uzSm/Z28DOPmw
	F2upOOHn1IiyoWip/C9ctjHviUrhsDpGAuvqeq/AnIPtE5bBVKED3u9ROnAU47H4bU9S8Jialtf
	18SB+Kuo1AGzhF8ks+m8nKfDv+OXoItW/rKSnaDp/nw/ixsLStB+3ngxqoAGQk8P8AZF+Uweona
	oiDtChG23GMiQn0mXExZehE6KnTXZMIq0xf2ztBBhlgmBvw7MKKbB3otv9TNhZsCNLxHJSaLRd3
	Ev0uRUiwhmNYcnBuUlDK1W0jZ/t4PuYD4Ml9eA9qEYv9gtQ14YWUVWiACO/jp7x/IFs32WycBm1
	U5MBlZ25jzBSx9io3blyxi3ufkNHurtDjve4L1Av9VzohT3hYVAUbxjKPtyEgOZivzIt6g+T41B
	9saUpf1/OxXRFduxjFuBvYO31Wn8/0eQ25YjSHyKaarfyg==
X-Received: by 2002:a05:600c:64c6:b0:4a3:598e:e7a8 with SMTP id 5b1f17b1804b1-4bb887c2c98mr274938815e9.4.1795526663725;
        Tue, 24 Nov 2026 05:24:23 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab6a67f281sm26298695f8f.22.2026.11.24.05.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 05:24:23 -0800 (PST)
Message-ID: <7465de57-8d97-4952-9daf-d95bdb4b7e78@gmail.com>
Date: Tue, 24 Nov 2026 14:24:20 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm: fix deadlock on the folio lock when migrating
 and splitting folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Johannes Weiner <hannes@cmpxchg.org>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>, Chris Down <chris@chrisdown.name>
References: <20261124-migrate_reclaim_deadlock-v2-0-03cc147e1e36@kernel.org>
 <66e5f9e3-17d4-4635-8919-c67ed562f9f0@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <66e5f9e3-17d4-4635-8919-c67ed562f9f0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: o4nynw419oobxrc1ic51i7cmf9a558mx
X-Rspamd-Queue-Id: 8F53440007
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795526665-49510
X-HE-Meta: U2FsdGVkX18YnkUvNjt7GgLB2Ty5Ym4NGxB8G+/F/o3kynGXiIgMChPKXfAuNGbRCBwRsgisuWlrRgNAW+ugJxc0PxRtuzQMT2/bat4L8Nvf+ecpNbiZVfHB658iburT2Qx0kE/9z05bzWEsBljtcNUMDw7mX55y0dXDnPnoj+abpYijqZLSDlOE37aUanBRjS4IaT2im0fINGOXWhY09fo99BCPR7kVA6k6dHvAMkOdta1mYQYxt62HueRxjGAGZrWjyow0fA8WTmfpwI6+m6Yt8+V9Wm52BLFl8ItsPSLgf86DcIZFinBkEq/kZrHehKL2F98Ty5rGLP7K+pmoV2MNiyGTAAv1aLbXZxfo4Kz2HUZSYBZS6mjNLOBOafWtrT5Gl6EnWLBRFQWYh6y2OHe5/a5oqVzsS2VmetibQaIYU6SRid3VmlqQpJXKH09EY+GXzigSl4GQrz2mo9u9ZX6nZUuBBj7R4K/Bq7Bjg5aD/tAPte32oCn/vLzMtV800k1mfQ/C3UMInLQ9P1hHNA+unqhYdxWJlw0Yb8224CTkAoqR26qLn9shKcsYs8CMEhFtACchj15yTZbQdpxufwlKPBvsQvbfXsqL1r/cKbG/FRq1AF8qQgd22aXps2pm622XpUx9txRQ07JEEAscbPSXtEf/6PthdFX+63EEJ1S0W/98CSnspveat+wRd7XWp1fQ8vb8ADHQXorip47VDkU1fcOSLdIuqO8Pq8gjdFIegsIJwiejDuLgSqE5ELQg+hchWIeCT83lFd1UHSjHuGvPhZTmvTJegE2ZC2IVGBkPSAJg0JnSj5m+ecvYYzck3gMLDjVh3po2ygLNkNkBM77XnTZJVzB37crcX3soJ7GlM/aLdLn/QFXFe3OOf8pScI6NmVKR7Mp2ydVlMCMaj0nweQRdvyOlr29fKRYy+lY8Mm4K6twh32IIX7XI6/b6k3s04COa9ozReSrwdbs
 V1kYoa14
 P5WCecLXvAUSiS6JRK72hvbsfj7oVVU1iJL36bDAn6SgxbUzG1+ZBzHkFR0fZkG7Bgbw0AbEFj0VEcfR8hG/uvVrLKz1lz6mmmaYV1PtoG0rLfBTLX5SVPuoL7lcfeyiSkYIka/N3spvOkDCIAan5uvY60Xy7PW7pncaMH5+vfY+TukTm1zBofI8wUtobqX5eKPar++F6HKoetfMF7EcOfng7+ohK11z85wm9MMjOl8nbKWTSLUZSnH4c9J6KE/kEuSicpWFI45w6EiN3RnCMbUAztiYsUhqHSJA5Sov2v/0ukiuG01Xaihh3SldMUzrdcaQymdP8mJW20dZWJ+1cHswJqBP5rk019K/EzocVOdBLXGOptWo3OwwxzYBk/uGbSqCfEP4fN+MFvwLPhIM1kwHFon1cq8SUqYjOl61Ld+UaKTnIW/rk+KxQ3nR1yKWi3KIhthAYdrNrWdX4zt3byyQEoO0XiXDtbkLR6EJNll/ug4Dt/lKFm/K8rnC8q477wAZ1xWjaj1HMpxY9+My4wC/gBOEuk0C5uu51VUkKD8SNMzVzkpK7ssXWm+/cPFdfe/sgcmBkMCpCIUjpyYNqEI3sRi3L8FPd1+VJaKL7Hye7ljHEgv3/XjnKG/v2XKtoM1zs7N+Zi+RMomJ3Y6A91HB0C/OQ25FkoP+2K228JfnDszzAvFnvCawVcDjwpZC0Fxqyy1yFhIcUG5/GrcDjJ067J9yS1I7ZlMLMUBzM3Nk+D60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 10:47 AM, David Hildenbrand (Arm) wrote:
> On 11/24/26 08:56, David Hildenbrand (Arm) wrote:
>> Whenever we allocate memory with __GFP_FS while holding folio locks, we
>> can deadlock on the folio lock when triggering direct reclaim or
>> compaction.
>>
>> For example, evicting inodes with a populated page cache takes folio
>> locks, and if we happen to need one of the folio locks we already hold,
>> we'll deadlock.
>>
>> FUSE makes this example easier to trigger, because it evicts inodes on
>> the last reference. A similar deadlock with FUSE was recently fixed in
>> FUSE [1].
>>
>> Let's handle folio splitting by simply running in NOFS context. We only
>> perform small allocations, so it doesn't really make a difference.
>> Interestingly, this also fixes one of a handful of possible memcg v1
>> deadlocks.
>>
>> For page migration, change the code to allocate destination folios
>> without holding folio locks, which is in any case the right thing to do
>> to reduce folio lock holding times.
>>
>> Some of this might also be fixable using Jan's work on deferred inode
>> reclaim [2]. However, that is not stable material, and not allocating
>> folios while holding other folio locks is an improvement on its own.
>>
>> Unprivileged users can trigger this deadlock with FUSE and
>> mbind()/migrate_pages(); however, it requires multiple NUMA nodes and
>> quite some luck.
>>
>> I reproduced the original deadlocks with FUSE and made sure they can no
>> longer be triggered with these fixes. Further, I ran the usual migration
>> and folio splitting selftests.
> 
> @Jose, could you find and fix other cases where we allocate under the folio lock
> with __GFP_FS (and direct reclaim enabled?).
> 
> I think at least do_set_pmd() might have a problem when allocating a page table
> through pte_alloc_one(). And I'm sure there's more.
> 

sure, I'll look into it :)

-- 
cheers,
jose a. p-a

