Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4AB8606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 16:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jo7t7EHN
Received: by kanga.kvack.org (Postfix)
	id 5FB126B05B0; Sun, 22 Nov 2026 11:29:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB426B05B3; Sun, 22 Nov 2026 11:29:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0EC6B05B4; Sun, 22 Nov 2026 11:29:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1367A6B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 11:29:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 599431206ED
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:29:03 +0000 (UTC)
X-FDA: 85463289366.27.8C7FFD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9012780007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 16:29:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jo7t7EHN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795364941;
	b=b/VphwdEVdmfm4INHQ8Qq/XTGDE6APtmYNF+VusOVIltn3mA2k+q4Vj+R3hK0S/jILHYnF
	7MR/0hyT9dDWZLeWtaXRfw7ZElHYF+j0cqBtzXPMI8cBui9NQEkm/52E7n2y9E1Nvmy6NL
	eBtWZtyPGPpChdShh5aoomFDvsEwZ6Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795364941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxP8OOhPlU3E52h/c7HsGP6acikMmgnMKkZh4h9TOUA=;
	b=f8y68RuAUs4xKi3pSvxyr+NojVp4W4+iSWruoL1DVnHikwq/QJyvLXHyxJaGqCAGRcsGsY
	JjcqvU9rEwrXdMIzymV4xlknUuWVMJ3fwZCT0/Y7KTnVW6flc36WRiWc4dP6N5bZQm3MSy
	iO0mWe9iCkPTatALhGR0C2DWOam6Nd0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jo7t7EHN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B03D60E4A;
	Sun, 22 Nov 2026 16:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA351F000CA;
	Sun, 22 Nov 2026 16:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795364940;
	bh=XxP8OOhPlU3E52h/c7HsGP6acikMmgnMKkZh4h9TOUA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Jo7t7EHNKyqF53k60Wo4LFD7+0c8CuLJn8wSP2453MHDj3L4IyCSGu11HHw6s0LBA
	 5ovCAOXqS1mqN+Q6c8setMKLBd3X++qACWM0zstTFYDH15hEItZQ7oxkG7Obehu1Z1
	 7CgR+OSM/JopTMPDxQjmlYN2N4IiZ5Hz3pFFXavtrxzsAnFszhRGc2pxsAJfyHidJJ
	 3GqsAxmbOpGvDuVvkQ+P1zuwd+WhgGgWAsxNsVrx5WwcMlFW1praNbcyPYKREBQYA6
	 cDs36ydEoBBR8omgcSy7yZt8/NO0A/frw+WSEhgCqNaTYm7vuKkwhg9jDPatIn93Z+
	 poeF3M0ypS/mw==
Message-ID: <aaed2661-8dfe-4b72-84f1-3fe9f4a962e9@kernel.org>
Date: Sun, 22 Nov 2026 17:28:45 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] mm: make folio_walk_start()'s locking asserts
 scalable
To: xu.xin@linux.dev
Cc: acme@kernel.org, adrian.hunter@intel.com, agordeev@linux.ibm.com,
 akpm@linux-foundation.org, alexander.shishkin@linux.intel.com,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 borntraeger@linux.ibm.com, byungchul@sk.com, chengming.zhou@linux.dev,
 dev.jain@arm.com, gerald.schaefer@linux.ibm.com, gor@linux.ibm.com,
 gourry@gourry.net, harry@kernel.org, hca@linux.ibm.com, irogers@google.com,
 james.clark@linaro.org, jannh@google.com, jolsa@kernel.org,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org, ljs@kernel.org, mark.rutland@arm.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 mingo@redhat.com, namhyung@kernel.org, nico.pache@linux.dev,
 oleg@redhat.com, peterz@infradead.org, riel@surriel.com, rppt@kernel.org,
 ryan.roberts@arm.com, surenb@google.com, svens@linux.ibm.com,
 usama.arif@linux.dev, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, xialonglong2025@163.com
References: <20261102132416.300084-1-xu.xin@linux.dev>
 <20261102132927.301921-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261102132927.301921-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9012780007
X-Stat-Signature: ukd59p4s8fwbabyarz8m18zaryy7ox88
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795364941-111221
X-HE-Meta: U2FsdGVkX1+5KwbS1yxM5+7ljoUL1omwNDHZO3++2E+CcadShdUGumVAbxRg7Cc6PrCPHQkAmHXUT2oFrKFgcVqGRThJHf1KSSzT/cYltLY1ANbCFPuDBA5AeoNz6eGWHQFV9IjNouNCD6SvdTJ6lVusmoktHDmmWGANcRZjrCMRhf0hlJ/p5AkuimUm9UFj3jxO5vzWfVhH82pdudCntAmK4VwKzPHOa6dTODBsUW4wSRKsMYhpAr9KYe27a/0GG7gHqpfU/S3FYJ8y7cpI8b25QlSG68SL38IWLHHmNcs5xbiqUi8OqEIjIuhhXkbOVDD6GqO0R6Gs3TfGcRDex9K+GK31mkoeFHFzvGPQBn5INF8pgJSFW/QIEWJQCc2JHIHfh9YT70iHvab2eeEpFoeSWVgUbjP9WsGHWwy3TjcNcg6+0dVYumPebX8BWl2achVy79mOFwPOmnv8DwGzwGuQs/GUujDXOHfEnY4mwv937o5Sqvi8oSKTG32r9nkXtUv1t2yjkESCPGYXECQdWlXRnSA5CTyN5Xvz4baIiMgqGg8gJx15dyBCCbQBzatgb08N6AUVI1jWwPF7CFyFJ4tXB/q2j2axiPuN3CHlKDKwkaM9o6XUEDBubAqp0g/L8PbhIMiyt1kTITGB2McuOXr06GXEAQG+WCi1JZjEbD80mwNJu9/DKUZauoRsvjdh2L+56UK6OKq+R6hiW/EQl9+1acMoWEPHkLa+EC60TBZoldFLYq2cxoccr2HrKBWOEjNt8T7HBUlXsLXzVI3iI1eyAjcFHohn+Nk7EZ1JrB17kLVb5NSE7xGNzyG6WKMnIpmUZda0TjJzIgc8DqnXzcpTQYguOR7wGV3SThhau/AWsFptZvQgsi220o3oQ2fSM2BFWNadCcoD9GfMR33dWAxXrMHRFn2vY1AWo1bq71DJRecztJL/NT64dsuvn7yGqOxz2U8EPXMapw32Mdv
 0/HX2bUx
 oxau6oqs4OsMgcGpdHk7/OUMXI1DJPWZms7H25vKpCW+u3Kza+xMnRP9AtAcwKPn+BmkYq1/uRSZfkqAUlGqk4PiGai6jlIoDDJ8SooaVa38w8KlnlAONgMiP3QK7hL8/Q2UAi90PLbZR6mgtfmcKizyqdbIRiU8ulnOSUsFrWf6nXc7/fWerBj3sHbH+2e6We4a+iB9XcaejgB6eUrbV7M7VKkWSvNd56XA5ELyzAQgmsSkudR6/13KU7L571ZI4RdZsMCCwdP4quTI8PyGFEnGchkfRzy4YXTKC3WJ0f0LrdNpvsz6eRvtqqjUvPPb5xXLjru6cwAX5XDGq3awy473POC5yJfy2TWanpkYOJ1ThT+HtlWzYXElaJDiq0+B/FJjIH5atYkVHrf19TiaLNBtAqeTWDq2Fbo2E67/jKDsdWGMlWAqCbNfBQ5t9J1DynjTfR2fHdHCudzuyBllVDXCAiWCjC4idIcU+YZ4vzdlsbBePAqPz+s1rreSlmr6jV/wSGCQPoAmgltKvpSe8dq0kSmpf0az7XaZJUtoRer/LFBOFNcdn04lY4iKIPq+TarTtBKqQie2XkmdPpQCA/nMU8U3VCcj9+ecC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 14:29, xu.xin@linux.dev wrote:
> From: Xu Xin <xu.xin@linux.dev>
> 
> Add an additional member 'walk_lock' to folio_walk to indicate
> locking requirements for the walk. Similar to commit 49b0638502da0
> ("mm: enable page walking API to lock vmas during the walk").
> But no change is made on any existing locking behavior,
> all existing folio_walk_start() callers are currently still
> under mmap_read_lock() protection.
> 
> This change is prepared for the later patch to enable VMA locking
> asserts. folio_walk_start now operate under write-locked mmap_lock.
> With introduction of vma locks at the next patch, the vmas have to
> be locked as well during such walks to prevent concurrent page
> faults in these areas.
> 
> No functional change intended.
> 
> Signed-off-by: Xu Xin <xu.xin@linux.dev>
> ---
>  arch/s390/mm/fault.c     |  4 +++-
>  include/linux/pagewalk.h |  1 +
>  kernel/events/uprobes.c  |  4 +++-
>  mm/huge_memory.c         |  4 +++-
>  mm/ksm.c                 |  4 +++-
>  mm/migrate.c             |  8 ++++++--
>  mm/pagewalk.c            | 10 +++++++++-
>  mm/rmap.c                |  4 +++-
>  8 files changed, 31 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index 46d828926009..968f128a5232 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -412,7 +412,9 @@ __context_unsafe(/* folio_walk_end() not instrumented */)
>  	unsigned long addr = get_fault_address(regs);
>  	struct mm_struct *mm = current->mm;
>  	struct vm_area_struct *vma;
> -	struct folio_walk fw;
> +	struct folio_walk fw = {
> +		.walk_lock  = PGWALK_RDLOCK,
> +	};
>  	struct folio *folio;
>  	int rc;
>  
> diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
> index 1c397be0d092..455428eaf1fc 100644
> --- a/include/linux/pagewalk.h
> +++ b/include/linux/pagewalk.h
> @@ -184,6 +184,7 @@ struct folio_walk {
>  	};
>  	/* private */
>  	spinlock_t *ptl;

Ah, Sashiko is right here that this belongs into the public part and should get
kerneldoc.

But, "struct folio_walk" is currently filled out exclusively by
folio_walk_start(), and I'd like to keep it like that.

Also, I don't enjoy that we are reusing PGWALK_* stuff here.

Why not add a second function variant that targets the per-vma lock and branches
internally to a common helper?

diff --git a/include/linux/pagewalk.h b/include/linux/pagewalk.h
index b41d7265c01bc..13f911e1db5d2 100644
--- a/include/linux/pagewalk.h
+++ b/include/linux/pagewalk.h
@@ -191,6 +191,10 @@ struct folio *folio_walk_start(struct folio_walk *fw,
                struct vm_area_struct *vma, unsigned long addr,
                folio_walk_flags_t flags);

+struct folio *folio_walk_start_vma_rdlock(struct folio_walk *fw,
+               struct vm_area_struct *vma, unsigned long addr,
+               folio_walk_flags_t flags);
+

Or something like that.

That also means that we don't have to touch any existing helpers and we won't
even have to store that type.


But now I wonder: do we need that *at all* ? It's effectively a parameter just
to do safety checks.

I'd just document locking requirements (mmap lock or per-vma read lock must be
held) and call it a day.

-- 
Cheers,

David

