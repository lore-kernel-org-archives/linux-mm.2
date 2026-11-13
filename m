Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2B5606A88E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 04:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=LomucHzO
Received: by kanga.kvack.org (Postfix)
	id 134066B0622; Thu, 12 Nov 2026 23:59:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10B9D6B0623; Thu, 12 Nov 2026 23:59:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3C666B0629; Thu, 12 Nov 2026 23:59:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE14E6B0622
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:59:16 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5825B803BA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:59:16 +0000 (UTC)
X-FDA: 85428891912.15.F440ED9
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 70ABB40004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:59:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LomucHzO;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794545954;
	b=LlElxgwsQmdoXXv453aW8uq/IOHVMplioQr26YDJ5YW2r6qFuM7HVEHBMY14YR+wYA4tjj
	NyOTwv8cnI6ojlEXGsd9l99vr7tl/wMiwFOVUClg7/96Bq9abbcGvjxoPryHUNKUY7eKxM
	BSz0p5HxXtTXICaCfLiUveRbSZns164=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=LomucHzO;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794545954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GLmBItbP4RM0lDvur+G85T4jZR5s6nwsiM+d+TbTnSA=;
	b=uahc3tt7PE7+VukKfoFThGj9hZDET/dTPngyOs9zR1y9MdF4PES1yFjP13E15vo3Mnqphn
	BoYq+lMU667tj3kPvLc2iUSaD24RzDYkSFx1veuPPjA73neCIuwve4MFn9dhBAs4qZZ6b9
	EANxkrmChV5BJiM6kOXRDCDao1OEFg0=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-94937a33cfbso86191785a.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:59:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794545953; x=1795150753; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GLmBItbP4RM0lDvur+G85T4jZR5s6nwsiM+d+TbTnSA=;
        b=LomucHzOSv8bVJY4eYPel/8ofToSCuMB40IoXogg788DAvBfef4xGXL+BJ9g7V/5ll
         GfkNv2+PEaeh1oGq71FIvuwg7iauE4Hg3mKFV4ug3ogHZvINZXvVgl1b2bL4J3Akqo4g
         68p/LYfrnttzw/9XbQVrmfrk9T1krZVHfbQxACEmsJVNacz2JVA0+fXN8Cro00/FeVCJ
         V8uRAzkxRhJQsmPhNcdoZE40wbb9rlghlKKRjRUmjDdL4emEGgUpJFn+WsyfBAgxecBC
         RCGZzZrXGMEqhJbQud4vm91BzMNywADePNP1avwrfqibKmzYQZ9K4PGIo4NKI34ewdjC
         VnYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794545953; x=1795150753;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GLmBItbP4RM0lDvur+G85T4jZR5s6nwsiM+d+TbTnSA=;
        b=Q3TKOi5lPL95w41tf+qD0udrLHp8M4+sWcPyg8bS4fb37L0joX9NJg88j+6kRjTR5h
         VmBPWuEU4AkCrNfZVSG4MI37LEjAPx5zu3+TZSHl+dflroIpuZcx2POS/9qhJX9s1EhQ
         GZrzX2kLu4tdaqSJr6AFSEVThiojwYb0Z3riG4OHD+6FT1Vw9ZUpY2oJaZNmQPdCN6l8
         r0uKh9NZSkgMEa0gBaEaTe2yOCpRT3ckHQHzI0iqOKs93+lkAOjfRMM/3mRQ9Q0EFBcx
         zgRZIB3jvCUtcjVUZyzsoz0OGgEurSq6Qk1nk3yJOGap/54VJWzm3olGniqnSHAu3DO2
         4WfA==
X-Forwarded-Encrypted: i=1; AL+hErEwjY5OaBHwelNPkvcdqOeo7Cz9LMJ9gtihLuKbtDiNcDTmqsQo/FihiAmZayq04GUWL/rQAzK6dw==@kvack.org
X-Gm-Message-State: APuU4Z+pAlAD0sFdp+LLEPJK6qf0uqwr6V9T2eJwPZzpdH18Uk8aLe5h
	Am2yO7XTVKNldoR4pL39mJ2c74nisqE0sOGQnRPBzmAKwMw2eszGkFruetYq1lkUtK8=
X-Gm-Gg: AYBFou2SyRWhcdD2YVGmwnEshvUYKIpHtHGMBRglmrfnbQhmR8+EUCHSyLzCiGAPETt
	vKSZTjiza2neCybxunbYLtx5k8feZjQMW4MdGg10nXVbMafMICmgFO6IWNvuno30479+d1E3p+B
	dsMWiMAuMFt9oNmemAaLgkhZNb9VKRW1v+I5wF/EGzQhseG1tfcJht6u+o9ajYXfc3A6tzOI6cQ
	q6pEVjH0wCCv1Ds9gYsFhb82mcKc4KA3ETQMfsU3BUPoC9f/QA/BHyZvNHZ2BSWTSJsnFcYZo1o
	lA64NnYSBYeFbuImUSfcP9wIJEY/SC4CxwgMmQlY4LvVrI29ACdv3mBrD+/1KoWFMR2dQ/rFtz0
	A4u8RcQHzGJCXJbygSjSVJ0OuvQMV3QpL31Dvg9CDRtROYzKiGdHx/Ndav9GGVMFD7lyDEK3YZi
	Ny4DNqCPi6ChNNb8RLOCr8nIsVyiTWGx66iqsNUg2gX3q+TrXsk3rZRfYhZO6aFGrxc3b+A1qJJ
	wXdTgPqk9iEn6/3GGa2K3+Q1xra04p1nW3wANuJEsuJcgKo7OUzdM7ki3DY8dEW3rzYl4iB0uui
	S+rhkQXeq44kayXRoEOIccdj/RE5WAHnrgs+zippfO8oHcqqE1Nns2du+ku5IyLhzsAU0y3PrKW
	JHW7Lqdg=
X-Received: by 2002:a05:620a:1729:b0:93f:33a8:8e84 with SMTP id af79cd13be357-9494bca3482mr231345485a.56.1794545953581;
        Thu, 12 Nov 2026 20:59:13 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c8399f7sm102246085a.24.2026.11.12.20.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 20:59:13 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 04/12] mm/migrate: keep the uffd bit when restoring a
 writable migration entry
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 James Houghton <jthoughton@google.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Andrei Vagin <avagin@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Arnd Bergmann <arnd@arndb.de>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>, 
 Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20261111-uffd-state-fixes-v1-4-00713d368976@columbia.edu>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-4-00713d368976@columbia.edu>
Date: Thu, 12 Nov 2026 23:59:12 -0500
Message-Id: <179454595216.482102.14752706183169554544.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 3qxjhne9hghefw58hf57ujt8gc4qdoh8
X-Rspamd-Queue-Id: 70ABB40004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794545954-568041
X-HE-Meta: U2FsdGVkX1/UbOo+8o3G080bSaHHgxaTEa5C+h2KQN3NOkJ8+Ewlx3KfGzwNGRgwSMDP+9889FdVLgi1FH7EE3qKx+c/o3NTKTcKNzx2cTMUdtUSslwwTiH87MPPIDezKiBKdmX/7UFelqJr9OkOPAe077Ifor/+KPBFyg8EzyhxZstrdVGr63zgm/iVpKDRxTShCE564x7eOQHKZhfXOxPQsmcqHjMlldGCtFOgGzBAC1bCJh67/JPYFYmiXxXRibITdREPslszdJdGhc0VxYUBvC5tGKMAKEHohSRuEmO3rHfQ/zOwSDaRJ21yEmKlCNZJQWibQ4PLRgT8UmZy5Yva1VodzUUSLfTqlw85gXz5dUpWTiIdP2ER/oXPNopmbuOxF5/zVtSzKblHLaLIcXA54pxp7DAj3xrLboJnwTVLMzS87B6xDbt2UZm7eELZysmw4qDK7ou82ifYhtj4K2kwOnDNEx1+t01a1sFpJ13jox2T4RUN/PPSWGha9VkrG9MSpuyXL1XSCFyjT0TTqswXYoGhTs6C2+lDWBz9vHXRLUAeFIqYdyv958jLLZZgrgwl/k++muOQ+xFeaLvpsEboK23PpXGq7fYoNzLpAqR7qhWGQCmg7KBwloZUWFCWqPKj9/mAX47FGmuvb+ZIWYO6iiMB8eVz79o/Rt3OPr56GVp+yi3Fmzt4TQqeXJz1DvFnj2JJevbnxjJqMf8KI22v1r57XwBEOaL9Lq9J0mmAZvGROLxbLLqgtO3jvGddrYxcBzxP1JZaIlRQA/LHMabBzVTyrcUQ+8XL2Jh5Bhf3IeOFuMU3Y55LbD9VAH6QyqPmlsiwjmAL+9wwTiBChEg2OZsCtYT8sHonChBNQPKqkwZF2qpA+O223HvEbe3rCnb+cr+mTZ927czyCkG+s8T4AZN1gsgoOHMSnQEAoTEp77wMBgJAdkcAPD198+pvwwBj/PpGwy32MkedF5f
 0AGeneWZ
 /I+C65+5PlYU07Tji4TAxXot0O71UbZ4+8oLQVF0s4snyhObmBewtLtHA3qJyfuVY7Aa7xj9kccX+QwajELwOpf8MIf9wHJx+X6X21jcHf0940sY84xxwiF0AcGcUg/2LtnfG1TzYsUKogjAWwuJ1hqjo2chGxG14RBQLuRom/MiQwg/42WF76QvjlwNxGR33yvqHJTFHQavSRkqSTcQ0rtHQrkyrZxubSbNhmqJFBx49sTXoCdVrjL+lc6ETebZdpsdAy20Mi0gm55PbECon9Q9P84lq19XL/6LrDXukQmBDo9py6z7tqAy+I9NL2kClEl2fMhovqQr/L7FcQR5X+ruaFWyfRpL6elh/AwtSDFrBPhaDR1zp3q5aJqEeq4PHanwg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-11 12:55 -0500, Tal Zussman wrote:
> remove_migration_pte() makes the restored PTE writable for a writable
> migration entry, and only looks at the uffd bit of the entry otherwise.
> A writable migration entry that has the uffd bit set is therefore
> restored as a writable PTE without the uffd bit, and the page is no
> longer write-protected.
> 
> An entry with the uffd bit set must be restored write-protected, whether
> the entry is writable or not. remove_migration_pmd() gets this right: it
> makes the PMD writable and sets the uffd bit as two independent steps,
> and pmd_mkuffd() write-protects the result. To fix it, do the same at
> the PTE level, where pte_mkuffd() write-protects the PTE as well.
> 
> The only known path that created such entries is PAGEMAP_SCAN. Now that
> PAGEMAP_SCAN downgrades them like change_protection() does, we should no
> longer see them, so this change alone should not be visible to
> userspace. If another path ever creates a writable migration entry with
> the uffd bit set, the page now stays write-protected instead of losing
> the uffd bit.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

yeesh, agreed with Lorenzo, this is painful.

I wonder if we can fix this abstraction somehow or if we're stuck with
it forever.  The nuance here suggests we're going to find more of these
corner conditions over time.

I reproduced the issue and showed this patch also closed the problem by
itself (without the prior patch).

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


