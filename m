Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4AFB606A887
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=YJpH2nzn
Received: by kanga.kvack.org (Postfix)
	id 905EB6B05B8; Thu, 12 Nov 2026 11:37:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE526B05B9; Thu, 12 Nov 2026 11:37:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CDE56B05BA; Thu, 12 Nov 2026 11:37:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44A726B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:37:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCA7AA8139
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:37:40 +0000 (UTC)
X-FDA: 85427023080.23.16DA0AE
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8996940006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:37:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YJpH2nzn;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794501459;
	b=TOuhsH2XWxeC8kfBXqOs64XSoaC8wlc4LF4Kp8HNbZsXtS6XI4VUrsR8QdXXPhpd4s4T9G
	3BY84CdQHiHaoXsucW+7k2iE/u2bkRtdtJLAFx0TyJ45KDzK+qGI19MmmyZWmQLFpwQV8n
	zml9rnHczsucznqzV7K7fEGibxr7wV8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794501459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NR5Eep1LUhJlSTDXQHVSks9fTKnm7uJPdvevn9dGzuo=;
	b=s1QasSgH/0eT+TRKNpZ11Bn3oKbQpEoeWlikFlW8TOKAeKQb96R0eRCESBAeZqyX3LyjBV
	eGwAnLF7Xpc24G9eV2z2pEdLo0kOwLf7RePRpzHX0HPtk8A6wIJAOhGyRH0q0/IuwDedJ8
	4Y9BFfd86RweUp/HRXsJ3G3Tfp9NUCg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YJpH2nzn;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b37c7d767aso496237b3.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794501457; x=1795106257; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NR5Eep1LUhJlSTDXQHVSks9fTKnm7uJPdvevn9dGzuo=;
        b=YJpH2nznAX/DXt7AzA1+OGXyS8bxYhJ9MTqMktBDxv1h0mcC6mldBMTtOcCAFRvo57
         7AcTL+R/ZH7rD3DxLudArGjuTu/gzBuIOV2QPa+0EawqeFNpXCF9ylzBxuMidMEbornI
         0RFVM7uiyZJkgyGciQky+FIiKL+fBDe1/un275+Xsiujj9u4n999MIODvHyOEzoGY5h5
         b3MKHWX8GajM62QGq3XD/1SizFqjukDgqKdo4eyp9Mk2pQYPqMOhRa9ubISY7jS4rmsV
         Xi3qSKRchbE2H/I7HCdkpY84T2+Prg+6EnwVE2TzRJJulzo8HKHBXTit45O0dgi+leCb
         8uSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794501457; x=1795106257;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NR5Eep1LUhJlSTDXQHVSks9fTKnm7uJPdvevn9dGzuo=;
        b=FnsqHdfsiuPe8MuejuIhFwbWnaJTrogDTn6lub3EjQMWr50LVhNk2BTCL5ZLGGZt2r
         C1cTbI10UzrYtEzTrsuaURiwBLeb8FJRpJGWchOd6zc/KFQU8Thx8Aq7OFL8gL2veXXM
         K9mz/C36vQXsq5EQAESeR50MoIU6kEt0txGAYgJpTyLm9ScyFZfjOr+UTpptm4qxnKF/
         fATH85NBPPEDvvMnAy8EhGldURzCOeHeAsrxqn7e1nOVXPmS6R8HwBHc01MIHnSlz6Ts
         Vt+yD5jzJQYby601RE05mNfTcZCMKlOVfGom3VpkU9Em4p03jGFydI6z7c6j+deByEcX
         rNMQ==
X-Forwarded-Encrypted: i=1; AL+hErE6zmjexbABwnsCpaTNUh5FBnsQrGja4NdkmazgDHwEbsvbPGTKpcQ76Q5G4YzuG0FlR7QWv71GVA==@kvack.org
X-Gm-Message-State: APuU4Z+mnvUC9iEdS2DK28x5UYN0gQnDI2YhZSPSUEEPzUbBS2W0b67P
	9Y414W4nAhnctHSGyP9TovKYWQVzx2aj5PYNWaUd3/934jf4FfsMUMPJYjwQKyAPhAM=
X-Gm-Gg: AYBFou3rTBn0ctwbCZgpM9SO1SEiYcbJZVz5WzWVCkxeF5GbtP/d+IWpnzjNoyAu8oQ
	1lfhPkn4vB1g4YE9HpTPo4Spf/vbUlmxYyPI+tLlY3px/jJNKZLzMEm0IlZFFDLAQDHDtLiRuRm
	UKQFpXyduE8uLS0/iV+mF0QDAWI/Q8tYTu8+Z0qEdSHk7BrVhwQ+NGI08+VS1h82HCp0ALQqEj4
	PRN1A7mtF0J/qsfkCboGPcVBLQoeQzFRC4NTMvUnCCRR1M9pibcTFRUPvyhj0JgM6KlFYd4sa3V
	L0nwx/TENkcxPKbIkJR1AChzdNzQ7iLhX4ZwQSUnLzVGHK99AZ1PLPmdqimEmYq52n8S5MB1p6t
	KwBO585iNA6GtN+2vSERfMgMUgH2TeBdibnNZL+mJr+uwKkupaVg7obTWmc/+MayXTbj/gNLBdb
	VNhgscuxz9ggSF1Uhn8pF5eilQVoB8xUA3LS535LbPAcPv/VynUpgSciKprxjdLGw2k5c+A/971
	CCF3ZKbSZv58d32d6c5AsVwwArv7DRZjcwkoXLojXY8KoVO454bcBMAYqg2DLCqmXW9Ga+AThsb
	BdEsgA90TVpGgKNI5Eufk8jZD1kX
X-Received: by 2002:a05:690c:c50d:b0:8a9:e801:231c with SMTP id 00721157ae682-8b4aa23ff6dmr726747b3.20.1794501457648;
        Thu, 12 Nov 2026 08:37:37 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b39340e374sm73746277b3.28.2026.11.12.08.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:37:35 -0800 (PST)
Date: Thu, 12 Nov 2026 11:37:31 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Gregory Price <gourry@gourry.net>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/page_alloc: only skip kswapd nodes below their
 kswapd watermark
Message-ID: <avXrS168bjq0Ilgy@cmpxchg.org>
References: <20261110224432.2347606-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110224432.2347606-1-joshua.hahnjy@gmail.com>
X-Rspamd-Queue-Id: 8996940006
X-Rspamd-Server: rspam12
X-Stat-Signature: dm6amdoro7597wgj9ou7jc9oothwsh3s
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794501458-4413
X-HE-Meta: U2FsdGVkX18eYTUCfnMLGg0vaNIXSqdzCm/6JVuhPSbR/wXCHC4ju1KvA1bmNcSKCZgDuowcGhHq982oNDA4As2JTvOD+S67RunFbugOCiPrL1rwBP1DvAcZAHSK97qNe1jnYhZdiHIX+wB1TgdUBcWDzmvestMOAOlKPvGZFc5mLX8GvhDcSHA1zMMhe3f7UvauBNggPLn+4BnGJb8d6Ys6n4zOIX7lXTP24ky26FQbMAWhhckK8ZUIVBL2PkwfJjCCxoAbS/pF5sDl1HZ+jHXyfXhgVHvBRzbsa8Vk5FHJcMaiBcposIVHNhdj5xK/2kGjh3/ssIXKEfuZy3oWSKzxiSA4sNAi2MhzMQH7BWny8DSEYOs16/UhVTdoPMgmFR2PXcamVK1ODP5+qoyvhJY221ZUtmJ09YAdFEYLyddDoYaBXTBuG/BK9SkEHDbDLelehqn6CFwsYXhUblkxRT1LBCB5LLMDOURTgMKUlHwNjpxOXaA4BaN4I5hp7RwGpfzjhjXmdqghWhjSWSQOLARdLp+StiV+IMA/MucrVtZzlnSr4qBp1un+RF1HYLvt0JUTR9YqGsr2rvxth5y+Lg51JQZ9ZPZxtsCeYxmxi1Q7g6RykK5+u47T0eBASzXSpfQGi0PsXd1WAGYhjHkiWEq6bguMEyCMuaPxisj71W8WOTjKqUme/i/Syed/AbJV8Z3P3h6qhadazeXxL2rwZt8mIElrB4eW+53w3tggKeT35ebD0ldAAcTPZvjG4omWOeUHHVI1w58l1gCeWQXNKSpxPIsUOJQDMyN3h/EE9Dbm12rHmQy/Do7PGN4pU2GCnxpHhEg35JyT7ptENOCDVZBr+f8CCUSXTcSIeu72xThCuexPFSLI94ydajAjXPCPWG9iJ7b5vN9wqO+VPevnAIj0G3h7XLaIg/VDKOlssYpCY4LPsEO6SUmlFDwWLrra6ppvD5cc5dA9glLA+xw
 bJO+aDfK
 kr/CHyQ9OxN3RvEHEF9uKtm51qWDwxjv3ROhF63CpsLcGmdd7Bwq2lkB+2C4g/xEMYwels6NeH/53INue1A5fLB/vGcNBKxS5qQxkGGPfNF3RfSmVbaSMGVmpuTSsGhNDs73X5hIM6rYgDPahzTDMLEUwTbACccXY/NivRD15RLl3Gxlu9lVV8YWLiOw8FcVD4V1b4TTGUIIXLOG1URqDYF6brBxQ60y+0B1ZU+6ecLBih25PCtC083uCJO3BI3Y3mu1xaIH58E8o4nNkp36Hqkc2W98M1DgJ5jSXoOCpg17C+zHeg1+DC1owZIG1l4/+cLKQ5NEPFd8VdkKUIEwKtFVXZ+dUatCK51Uth0hcliLeHawiDbR9lfkVx5pkWRVcds6aTb9+vnwJlVcGP0viO9T/q9kjnwy/mW3053Pe9zVinPoY6m+b1/DnsRLQw03lYnDtWqdYfGsu1+hSSTc5C9CfCLzluRXlHu72LDWgFgpX3lt8yySE7ESp+J0NhNr7OjUQecN1QZB8iu/FxjTVn+1H6ZkvKzZ0NRuS8lElCYwmI4loKK5gab4t3KCkPEE3ktTajkGdQHHpdbfI/AxlmbHvySkLDp4NvSQuvoCuP4K5Nk2mrMY07Fs2/Xk1WCMJWJs7PslFiSbIzR6JlMgO/OzDT/qLvl1ZmoLoI5pva+251eQ6BRILgc5YdOtygngF5mVxkkKUXhuI5PwfW92qn0Q5mHckwi8Duy6//K/oGzXE9E21a3V3DMile3JjUeohgxhCY4pP+hiBW7hLeJSds4DV/RtIqSvTKyUDqeYVxur6VTwbmBRhUySV5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:44:31PM -0800, Joshua Hahn wrote:
> Commit 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to
> NUMA restrictions") makes get_page_from_freelist() skip any node with an
> active kswapd on the first pass through the zonelist, so unrestricted
> allocations don't immediately consume the memory kswapd is freeing.
> 
> But kswapd is also woken for high-order requests. With THP defrag set to
> defer, each THP fault that fails on a fragmented node wakes kswapd at
> PMD order. kswapd reclaims a batch, wakes kcompactd, and sleeps until
> the next failed fault, so it stays awake much of the time even on a node
> with plenty of free order-0 memory. This means those order-0 allocations
> get directed elsewhere.
> 
> This was observed on some Meta production workloads running on 2-NUMA
> systems, where processes with a preference for node0 allocations
> continuously allocated order-0 pages on node1, despite node0 having
> hundreds of GB of free memory.
> 
> Only skip a zone with an active kswapd if it is also below kswapd's
> target watermark.
> 
> On a 2-NUMA VM with a 60G node0 and a 20G node1, with THP enabled=always
> and defrag=defer, I ran a process that prefers allocating on node0.
> With a fragmented node0:
> - Before the patch, 68% of pages were served from node0
> - After the patch, 100% of pages were served from node0
> 
> One remaining gap is that since this uses kswapd's own threshold,
> unrestricted allocations can take what kswapd frees above the target
> watermark. The current code already lets such allocations drain from the
> high to the low watermark while kswapd sleeps.
> 
> One potential solution, as hinted by Johannes in the discussion from the
> original fix [1] is to add some kind of fudge factor (for instance,
> wmark_pages + high_wmark_pages - low_wmark_pages).
> 
> But in tests that I ran in a VM where the allocation demand outpaces
> kswapd, about 4% more pages landed on the busy node and kswapd reclaimed
> about 15% more, but kswapd still finished and slept. So let's hold off
> on the fudge factor until it becomes an observable issue in workloads.
> 
> [1] https://lore.kernel.org/linux-mm/20251001164131.GB1597553@cmpxchg.org/
> 
> Fixes: 19c5fb83f2a4 ("mm: page_alloc: avoid kswapd thrashing due to NUMA restrictions")
> Suggested-by: Daniel Hodges <hodgesd@meta.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

This makes sense to me. I agree with Gregory on changelog brevity, but
the fix looks good.

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

