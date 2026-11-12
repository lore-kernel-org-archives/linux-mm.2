Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CC8E606A333
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=OuK0lMhi
Received: by kanga.kvack.org (Postfix)
	id 0CB3C6B05C2; Thu, 12 Nov 2026 06:44:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A3A16B05C3; Thu, 12 Nov 2026 06:44:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5126B05CA; Thu, 12 Nov 2026 06:44:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C291D6B05C2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:44:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE7341A0598
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:44:02 +0000 (UTC)
X-FDA: 85426283124.08.9408A27
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id C46AC120004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:44:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OuK0lMhi;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794483841;
	b=MPdRYVk4t8wkHnKMYS9Bh/fiJTSH0F7oAitBpryrllOghIIPDI/RF/SOlinpL8Hr/GXZsN
	Gwwek9FV9xrSVLySFVE9Zxzeksy0oEfSi2+tZQ6iBSynzColkXGwct+Sh8li4FTCENYVDj
	wxioVvtWc03DpiFqqzoRIuuaM4KmDoY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794483841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ha0beh8JKKzYfv/K+pKtKWX8urpG8eLvtCtoo4UumEo=;
	b=ZLjcAd3BdK2nemYrHSLXpFltRfkqS3SMw57OddQ/T2rzaqM8u/t1i45rk6zO3KNGDRihr/
	PyJq1h82jOEuL5K28Nb1go07mJxBberKdzrg6MF4Gmit6sRXeIi9Etw88Th9jxnbONUyKz
	40KpTd6+XQRIXVXBjBm9dYZJnfNTs2k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OuK0lMhi;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-492fcbfaa88so2798091f8f.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794483839; x=1795088639; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ha0beh8JKKzYfv/K+pKtKWX8urpG8eLvtCtoo4UumEo=;
        b=OuK0lMhiTC0brHarBKGBlxzOyN5YlImLYEwpOMaRWrEfRauSF4iVSPXAG/LSeu3cco
         TnydHMdtUWXk3kHFRHX5pkpSfgwPMawDQUYaZ8k0khMHRa8CVGmQ2WibeHwX1agXzy/p
         LmYkloyBSE0pbwyw/13afZ5aV3jwzkphg6s0rYKCMvu/C/rPjiiSDOPc8VXpsbjSu5tq
         /XTo9H+kmLi5Xp5j2tCg9aCU27kNkKadGXVOnI4P8R2wJ83gIs5O1XyYlTCXcAIBqS7A
         Y5ghELdvt1jjB9mo8i1OOPdZiLB4X1iLLBgOgjCLGikNBnsltt7JTgtAndQ8VI7rIeKW
         izqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794483839; x=1795088639;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ha0beh8JKKzYfv/K+pKtKWX8urpG8eLvtCtoo4UumEo=;
        b=UxkgQTd00OJ4Sf9qIFJ7dsAlYuFEK6AQzkvjQFsz+nlHmSIt5/+r31B1T2y5bYX+Gd
         qz2lyX8nkIJwzir8ksU97mFg4VSqZG5rpPvo9XBr8aajT19xJbzhKLU34YDUSAt68WWi
         JTsfe+2xWeyR0z1bDizGsxByytUR4frM0SvYo0sBo+guN1/EGMFyI7eT+tJByLOeQhpL
         BEBWkmbyiWfJmT+fumjOYDoSxtP7FO/plTX3g5ddhwqah59EqfZ9bkG8XZTJxHclg8ex
         4pRE2kjXB/OGVCnsL5oJQ3rSD3pRokWbTDMYLPspJuekvaPkr5/PDTIctTrfcObQ/dbe
         MfWw==
X-Forwarded-Encrypted: i=1; AL+hErFuH2CCrlbIVpkh+eUjWo797P9T/9bbVObuTgccXdIOzFM2rDuaGgBUIcMh/CwbqvuuAHWA5BIgIA==@kvack.org
X-Gm-Message-State: APuU4Z9V4I0zE8uFguX22XqTSTib55gIkT+plEOFCXcL11e/GbklMWLP
	eHcLoscP67hRxZ0fhtl27r/vC5nCKI2lBeIHLu6QZ2kcxMhwuP0d1/aw+7GfDeBHY/I=
X-Gm-Gg: AYBFou0ao/DJOA0WbcwWy8zFH/R0+/+EWr7BjWqmeMhwcskTS/sNiXSic+Fc6ErI+6I
	uym85PrlRxgeESV3Lqjoi36rB8u88aJHVzq3/QP7h5/GI+8FwijJK7jLh+0C6alcj+5NgahfO8A
	yHbfC4ii0T0nEcvvpJ2+n6Eo2fYcqkeSvgJfjPNX331EB47IbBh+XnnznHtMhFbsnRTWdUNbyEC
	LF5wVyEdkoJLmXB6opU+7l0mhgfs8RILCNlp4xaL74xedVgYUFjv0dxI7exYFzo6UBAThi95p07
	s4BdrE0pjQwGnQ2yRqsWEnLUv88rmlRHfsaRqPPkUweuXDQo7pHnp/kUtRMAc2W7mRlUcUv6ZvD
	3Snnc1vLVuSwdj0acygkoHnxwOChFCEje4QnBxMGb/ahOEV2ugMQsy+b4cpr9sTEXgngQzYf2l9
	utiZta9IHbkoICvFx7o/Yt+kVAy3cctTFmWiF9PL8EUpmamxPwaH+pibSy+IWq/fNnFz+9CIV/Y
	mMf8Ig9hSwkDuXpaAEZaaMtSNLDCGVvBmYXyaRIqYsBdouq+zUbyW0OpfyfkZ1JWBw63J+XMJhT
	6PjVqyr8zZrVpsgks+RVtSPce1qFb6xjURomPsfpy1xql4hD+H0LKrUzDenEXOxv
X-Received: by 2002:a05:6000:4a1e:b0:48e:7470:9eb9 with SMTP id ffacd0b85a97d-499c89861b0mr10174390f8f.43.1794483839022;
        Thu, 12 Nov 2026 03:43:59 -0800 (PST)
Received: from localhost (109-81-94-245.rct.o2.cz. [109.81.94.245])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498366c4e07sm15559590f8f.49.2026.11.12.03.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 03:43:58 -0800 (PST)
Date: Thu, 12 Nov 2026 12:43:57 +0100
From: Michal Hocko <mhocko@suse.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
	Balbir Singh <balbirs@nvidia.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, Peng Fan <peng.fan@nxp.com>,
	Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
Message-ID: <avWmfXu39vtp0DM9@tiehlicka>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
X-Rspamd-Queue-Id: C46AC120004
X-Rspamd-Server: rspam12
X-Stat-Signature: gb6gh9diozw3xs8hqtek6f8gg5ero3un
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794483840-720127
X-HE-Meta: U2FsdGVkX1+rrvayUisaGyy5QvHPTpn+ZRLH9aqX9IcCQQfn24/sKFOYISP9GTv5WjX2KiulQXaMIwrn2bjHR6zZtiAu8+T11TMno81/LQexjurfBkD2QGk+camYa6t+FgoVumD10ahm6rlT2gDPaTdDJxd5+PT2hL5GxFnb1RN09fPFC3albrLlPhz0Ag9XDD0QxY9I6jinltxjKRvQLKPdAuS5Pnlekom4noONU+JaG7DAn4UrmNocL4Km2qZG8zlxAzcIhjgD+ApLq49d8B1OTUoGX5rI0XOty0Bz97RmTFqYNjj/C0DjWkaouCon5l7BZCcttketdPHiUP23CmFlpgU0AcoH5faQg105y1bnVnzma5uRf7KDqipTEXssLo4TKDVfMOrxTIvT1kDL4Zv/M4LzycswqObcERJDeJHAbNpWBoxdoJKOQNbwF+bz9YxW7o/bJLd523wmRAybTG62ODg0wRZVxxn2HzaphZO8NaWL9Ead15Z+Y7CfDC3k1xxK0rghBKD72HUtCGUteB9qmZ8GTjiQvNW1HuFmvZqQK2UVskzUSfKLu9+xxpBIf0J3mDPToRzYvTyDvzOR/7SqD/Hg+mjFB9qR0mCes8P0YGWtpkAAqseCIZwidI7G1qDpb6lMPPn5sIRm+wUUMZtgIKE+AqTcI+1ZAn1ipyFPV3WOgYh5xVXSZrypy9PecTeAkTGjKyqlOrqEy4ZiT2XLdv/rtqHbWFC+nq1NSC34QM8ivadLcMGXw5SH6z0RV5Zqd+OKJRrUad77jqzsxXhTcPt20IG2BGCi6SvgzfS2ZyThWNaY9nQ87Y4ZwPLw1X+JWhWlDM/XaJHuAqqrBZlYwDw5cYVuAgvQgQ8mmkDioNrx37fKMs33Lnv/z2Ku8uWhB3xjCXoBKiyiXsOsye7E0zDtmREYchS445f/Tce6Vn3CCOSrESCkD250hpS5Lee/DLZvZw6YaBsVp17
 iM0V/YUw
 90VbFhqPpzYXY2OcAzhZbGP/T4HnOgLcVldqpqn6QpvMs/UEseLf+6BjcuqSIU8R5okkYcbSYDrEZMueophNkL7jnU9UAJCl5TgAgv+vRrNhe2yY8w+/6xD8q0vlBHsOmgMfSbIE6GQoPrM4Z17UBDwmEWLM7/qidEcquX3jn6YJcdPf29Sucd4BcGEuibmD9NL0R3JV4NNG9lf1nWyva+zRQhK3kn3U13tpXtDLSmnBmDQITcKnwJTwfHw/LmNmrXkwmXQPBI1QBcKjIGobzFYEG+Bw6u4yHOrSwE55OdqjTbi5EJ8odp9MJL7ps/YTnHjMVfelqYF5K38yUFTq0P7agBQHHfu3S1va2jPk9oRRXFWToPd9z8Wsy7jG2tPGGKBPUZQ6w+zHUZuK7fBkLQ/t7wEzks9cfYls5HcCgH3VleY/xIMj1R+59uNJAaSyMw2dIN74sor7Bk3drdI9SH9w6itfZK5LjZHWZtZXKBjfZJMsBdqkm8fAmOykWlE3Hlbf1PCYxVvDk5dcnboU5+kKfIeS/3zRXUgupzRnAaZG2ng8+sGOWuoGnoYIFTMs25c1xjOjBAD6VTaIJAWUdE015KOA/v8gO1BFZRBZeanbv10E2FZldobh9uajVlXX8wINu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 11-11-26 18:13:15, Lorenzo Stoakes (ARM) wrote:
> The OOM killer can quickly trigger again after having selected a
> victim. That victim might not have freed its memory yet, but its mm will
> be marked MMF_OOM_SKIP by this point, so the OOM killer will ignore it.
>
> This can cause the OOM killer to kill an innocent process when the first
> might have freed enough memory to relieve the memory pressure.
> 
> Fix the issue by freeing the memory before marking the mm MMF_OOM_SKIP.
> 
> Note that the task which calls mmput() might not be the victim - if it
> took a reference on the mm (e.g. ptrace), it may hold the last reference
> and release it when it calls mmput().

I do not follow the reasoning here. MMF_OOM_SKIP is called after the
address space has been unmapped either by the last mmput or the
oom_reaper (or both when they are racing). Now all your patch does is to
call tlb_flush_mmu which I suspect is to release batched pages. But why
is that needed only for the oom victim and why there was no final flush
in unmap_vmas?

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7618e72766a5..4cb18b217048 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1313,11 +1313,18 @@ void exit_mmap(struct mm_struct *mm)
>  	/* update_hiwater_rss(mm) here? but nobody should be looking */
>  	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
>  	unmap_vmas(&tlb, &unmap);
> +
> +	/*
> +	 * Free the memory before marking MMF_OOM_SKIP so a re-triggered OOM
> +	 * killer will only skip this mm if it's already freed all it can.
> +	 */
> +	if (mm_is_oom_victim(mm))
> +		tlb_flush_mmu(&tlb);
>  	mmap_read_unlock(mm);
>  
>  	/*
>  	 * Set MMF_OOM_SKIP to hide this task from the oom killer/reaper
> -	 * because the memory has been already freed.
> +	 * because the memory has been already unmapped.
>  	 */
>  	mm_flags_set(MMF_OOM_SKIP, mm);
>  	mmap_write_lock(mm);

-- 
Michal Hocko
SUSE Labs

