Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08701606C356
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ETjTwNqL
Received: by kanga.kvack.org (Postfix)
	id 290086B05B3; Thu, 12 Nov 2026 12:35:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267D76B05BD; Thu, 12 Nov 2026 12:35:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F216B05BE; Thu, 12 Nov 2026 12:35:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E41896B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:35:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D4F6A82E2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:35:30 +0000 (UTC)
X-FDA: 85427168820.26.35FC61C
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6D6B114000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:35:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ETjTwNqL;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794504928;
	b=YugM9+gL2YlQR5CjCPbm8pbvM1ZEtkujc+hJKMznq30rcPcvKbmfk8wp0lMrd8Ipv4d3RL
	TMDExs82cN7PjU8XVyoV0Xl+lsbMrLHw7VfvLP3bWSP69lKZZ+tKuJI/zIgC6++EOQbS9M
	FvE0LMsYXFy65IvpTu7BF0sqTUqoAdQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794504928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wY/udgzoTMSU7LblXILhhflOgeGfM9mMJ7q98JCWr+4=;
	b=K4nxRNUM1t/mmv2Iez8Ow0Tbn4BD52MQ9Zo+S1gXtIHxhZg/yehAnGgvooZgo0kzrWGiI9
	ZzpjanbHT9AGM4u61jF7B/un9YLWDLOvgyaT8D9Erz0kP8IKNlqMtZVft/w+je1ufaX7MH
	YwlyWF3Mr+iFpoc1GpG3eX8nrCUZ/Ao=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ETjTwNqL;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-53664b4860bso44105291cf.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794504927; x=1795109727; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wY/udgzoTMSU7LblXILhhflOgeGfM9mMJ7q98JCWr+4=;
        b=ETjTwNqLUOKpQG3O5/JHRK5KQ91Nnr1Jvc6HbwZ4IgSEeYdDGmPQczJvmpd42/xj3S
         OcHV/JFMh3UHAUz355KJhtAYti54gMsTH6ZMWkYnOpNi55UXUzfXgy36QiCyTjlys9c3
         wG9MaiYNL6NEF7+G7viIBWwAS8+9YLXKO0Wr/eXOeYqoqe6PS1lL4dLveiOimx736EZq
         vt6/b1tU8eOtCJ6Lp9Q4ceKMJrfxzNlFiM9OhEEO7oa82YijIW9/9Uxus9XYijFNCxAW
         oou/NNAbCLecw5D/UMPcJml36CcBwQAhkbRylRT16soe0pDFuZuOsLREZQ8/S7S/JpNx
         DT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794504927; x=1795109727;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wY/udgzoTMSU7LblXILhhflOgeGfM9mMJ7q98JCWr+4=;
        b=Jh5fATAULcFcI4KvbRgfpnGXGs4463kI6BAuAQP/tCyOwXjR4Ea2TUnHlwq6YzEvVG
         AZrZqNVlpj2nFxGr+j91x6FPMtsm4a8JfgmsKSgakdfW2Xfwouf6iJgB1aEyE4yRfXDE
         EfSy1nzSiE1WXen4J3maY2L87BX6CVqgDXEIjZppKaxh+MoirqwLliEG6F5yA8nY4pmH
         ksz979lSRxsh3tkdI2Y+vHGrP4ahITScuRv1buy4eG6gF7IkxhSX1BXyh6LTWA/DONGg
         CfTPcW9mBzHlI/tpoIZ9XzBwvbGRfHOiofhwf6NBFQFi4+wOnIbPtJFSPycRpohlzMgz
         hA0Q==
X-Forwarded-Encrypted: i=1; AL+hErHZ+Ie/ZVe/n9HR82NzIMeJ/Q7J+BPyz538FhRjo0yGXyUWXziMAx3xw1K9JB5HNlN7Dtu2xrWLXg==@kvack.org
X-Gm-Message-State: APuU4Z/cTRqZirCgvBjvSd4nJSlGqWUT86r6CyGgpxNRESOzNUVOft7c
	e3DKcR0d4DzrcQ0XMJbT+iGe67mmZ+owMtvHTRJExkGWf+kXoKs3CzIuo4SeaQi0pXo=
X-Gm-Gg: AYBFou12bB92NZB4VG+ffgCILYDM7Y1/0Smq2gU0/vbSCq3QPaK2dgww7bASXc8pqww
	GXqvlzGFsmmtDVwBn2NgOpAD0gm1VPKaCTGqwIGiOm+Lp+f5XCgOrD7ueetM4zJca5K8iOSrTSd
	hQLWqIh/euZjmVhmzEGolsr4QcwZr3LeVIrnCcTP6dtM0xiA0Iy8w6tJUQOk/DNAQuXCv9GKjgS
	ZmzsBDVl8zSnhqkIzHI9YyTLGSfdIup0WlSrtUpBHXBXyTP7Lpj7jfsILSOJ1PSj8PQwiUpB2YD
	LQapuw2b8DFmmAZrWmuGD+BWAZaV02lRYyl933Jxpnb2J6+KdvW7YuVygzqiaxWMCx3g0Zwjn5N
	bGZFxJI5NYRLoqYezGeLFzUdsQO6U3DNOsgPPkeSZh7o1kHFvKbIOix3kKeWLXJpx3ci1VtAzEw
	/vgz7RQMkjx/DF1DO0qd1UE6gvKLzcyTCIRTdszX7CBYgS6soGYxWsV8ndfOOU1IU9fPNSoKyCR
	0AJdNenFDmOGjUH0wx1CgCFsTWX8svl4llrvQfNSMFGVYNQVPCdqIaq4CtxEI52yYEwFoGAnhsi
	4dzmo6KvR68uwRNbMMAqnTcmdQySCY42QpxKrCQcUXPp4CszYPjzxWu9c23H30Nc/h5aTUgpHLo
	kzqmQK+4=
X-Received: by 2002:ac8:5a0f:0:b0:535:a5f9:752c with SMTP id d75a77b69052e-55ac95894d0mr1164321cf.75.1794504927563;
        Thu, 12 Nov 2026 09:35:27 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d5e579sm847456d6.17.2026.11.12.09.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 09:35:25 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 07/13] mm/migrate_device: look up fault folio after a
 split
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-7-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-7-3d2454362e8d@kernel.org>
Date: Thu, 12 Nov 2026 12:35:23 -0500
Message-Id: <179450492332.482102.8905567682196853763.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 6D6B114000A
X-Rspamd-Server: rspam12
X-Stat-Signature: mojg614xfd8d45g1t9tdbtct4s9zescg
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794504928-969620
X-HE-Meta: U2FsdGVkX1+FdCyNcAWDtwCj9zdwFzJKIqmL9mzrRov4iGW7yIlaANsxXKSAUV4ntGifWjl6yc4FG4MaqbEo3a0xfvLw4hQAyRubBnETsR29O4sJi1imJJinLWY5N+B7E0LR7he0JPf48UftIPW76CMc4K+R+X8cz3QxDUqe4Uno123TN34I6Zn/LWebWGnnjEqxG+1QW0swj1TiTsiJutENlMVgQTkShhC/9AXUtQOTIAZvMR/RvpjW4vbdHBkFaMDJvAIJX4xBq1opUc6MryEnKkxDdytT2zIbVUwE991tnW5YMTsFh2REMzFaeIX/SeMc+Bwg3QR+PTEjzre2ZYLe9Am5EgmwvpvA1yHwMH427uELIXoHgGY55q9Z0YEMbSeJLkW9tfqE8dh5liypG07iOy4gkSn35Ux0M0mq9AcefqjNnZ9GwduodNyWgJXZnLSMfXHST18JG3KN5itET/EkNHuKAcqou7ZTOm7cDQN3HQgPia5PEUmF5TP4JHigSrVem3Ec3NT3qx3hgiePYRY4KLjJrB8nv9IyTXg3YOjHaMiScceGJZxs4nX7M1XmbVDWVRH5e0hO1/yx27yDZkzcllaVHxtkh9oNSvGViTSis3xJPoun6E4PANrAJvxPl8CK9RtOppBS089gzx+UyQtX3pbt2qKN6PtLA2LyUBmWMU3ontQ3w1coYvURD9bFs6+3I25p5EAZAfjKkX2GIpfTnMfoVRfzVee120Z+eLvf8WyUFQsi2p1HlrMG69yOcuCHIB/ZLo9/L+zsiEUZ7R665Hxngx2Ym3kgx5N4k030Vcp1lg8+YVIX7a2EHz6ADPmEp4YYxlOQLi+ft2EcxQIhQjrNFKvAV/GfJDril87zASZIM8k/Bk3qMPibMT3RB1c9FpC9Yq6ocb+CBTBmgRklfk/kjWcAg2SbQlUltolThyAirCt7vcypw4hc2E9QmDyBCNak8OmEHBL4Amk
 CgTjmxzV
 K1u67TwyGBNtlDWsO/3TovbKjcKY8R1N+UogCLt6gALbgvD4osKh8C0si6ATiGKGATC6yzsaOJ2AN0+yf6oRROMia5DPjXIlm3qzYWOPIUY2FB55xclH0Ed80EUdYyY8deGKP645sRBn7Fz+QN1rIZ8QWF2bL1qIfm1WbPomcxhfhot6rSQstwPfHuK0xmBT/R6dH2REDuzE5RdpP5w9DPAgp/5in19ERBDGvO0yty9gFPJ3/IDDiluEqjs4pAD6mJquKSSEWmDgQKmtE7kEk17sh3rSVNYRg5GF1oD2gXsJAFWPs/TXDA8exyocNoxxp+uJLbD460gCC+tZIlhWxgc6hOwQ/JvNMCRFy2pDn+KW2RDvYOs/PzMBH7IeFo/nZo4TBLMkOM1VWrAQZd6BeMdKoAGyhshKw06XCyJUNRA1OJTwmfYh10vom116Y2BIzOkSC0KVKI/uLflzLp6wb7nBfXPgmu8PVb2QMpo6aVoDsiKC9CBvTtv6/Pr/oIGQ2keptAp/PeEzXW/y8hJ1yBHwQFL9Vl0rhv8tjNGixyINGcZQ+AmOpbHYihImtD2yZ9X1Vp/lpkdiPfR/Z9IxiH7X3BDXOvozy+hoFHscgLFnYgoevuTz8VXSELQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 18:13 +0000, Lorenzo Stoakes (ARM) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> migrate_vma_collect_pmd() looks up the folio of migrate->fault_page once,
> when it is entered, at which point the folio is locked.
> 
> The fault folio is assumed not to change after this, however if
> migrate_vma_split_folio() splits a PTE-mapped large folio which contains
> the fault page, the fault page ends up in a different folio.
> 
> Resolve the issue by looking up fault_folio again after each restart of the
> walk.
> 
> Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ ljs: pared down commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Was able to reproduce this, and i think this also reveals (and fixes)
another bug in Nouveau (memory leak).  I think the Nouveau driver still
needs a patch, but this otherwise looks correct.

Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


