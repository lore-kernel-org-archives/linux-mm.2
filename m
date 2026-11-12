Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C50BC606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=dINdNlOf
Received: by kanga.kvack.org (Postfix)
	id D23E96B05B6; Thu, 12 Nov 2026 11:15:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5536B05B7; Thu, 12 Nov 2026 11:15:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6FE6B05B8; Thu, 12 Nov 2026 11:15:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 984AB6B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:15:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 232A180613
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:15:47 +0000 (UTC)
X-FDA: 85426967934.28.25F114C
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 11A69C000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:15:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dINdNlOf;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794500145;
	b=rHSLQAPtoGPHJSrUft2cITC+Y6HFD1wfS8K4e0RWVR9au10E5qCNN64Fvd5fHK4F2jfi0g
	ESgOtcrM1d2cfEAUmJojt434v7eP1/0thojG5K/P9wL4mtRF9LJQG7h3zMLPX5E+wdKoC0
	DlsGYqXUTl5bfqWpe/jpF6tguyJIBe8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dINdNlOf;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.43 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794500145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VnUBdoc3KTMUe7EeR2rhTTEffXeqsYq/yZz8D3wwCd8=;
	b=yNUTuUItjLcqCNYrw3yaXKeyRtelo0q284hFtJtxNL5nJiZ5V+UEaQKk17IkDRkcZaHFsG
	QxosBYqddcUPHQUOg8M4wCyPAm8DdNmAsxdkopgMpWZ8h+o2bYoAIuKscOyvlaVCNyAE5z
	XgvHts4iKbIbXeUT9R0Z/FhCEcVEPis=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-67c246c0c60so1110570d50.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:15:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1794500144; x=1795104944; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VnUBdoc3KTMUe7EeR2rhTTEffXeqsYq/yZz8D3wwCd8=;
        b=dINdNlOfK3vkyO1GVcSstOME5k7gsCPBF+ltm7NKVpdI3An2AYwPCR8pdnJQnZuON4
         TlsTWURtwE+nMHnDJUwLLYnxr7RA9zBtP+4TyPoVDL7t2eiwxla99sTVzbI9SXVLDwLa
         hjf9wuj68Srx+6Qtjqw7UFpoIJ8Cq7krQUnI13uJbiLSuziy4A5jtRSoGJ13COjEBvkl
         Ts6tBxOGnZd9L4mJxoLlAev5nDPmd+rpCueUsnDaC1oP0NJhZFIAucEQfQ3jIWdYsYTM
         wMFE6hwUAisyWmDzFdyohtbtxPSMbHYtfyff/hxXzEbQyTQudpO49EI1zFAilYdxzuk0
         k7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794500144; x=1795104944;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VnUBdoc3KTMUe7EeR2rhTTEffXeqsYq/yZz8D3wwCd8=;
        b=zGqQ24mNMhs2bjptN5FxnWEZgY2uj5ATc02Fc488FdNLjM0LihOyfK+lE1pnRkvS1r
         V53R38mlvQHOxuoX+DkbMETAxs0tXK1T9AfxPpnkrQGLLQIftVFeMPcNHjwZyZMK+NZ9
         GAzXeaco4fA8WFtIVJdcGIEuq6ebQZF6ACr7gc55GwDa42+Di+5TBvAFWXx5Mz5FHaMt
         Lyvz9Bw+XJ4KTUwioxUTNiEdvr8DaRfsdbBZOT3NjR6M9E1tF+rLbDSZdeILhQVxqrMC
         acdX46rQXKCEwtjdnQ/IOA/OEr/+ChaPVuHo/yBa+HltuBvX86/VQfUTQOL0BN/CLbuQ
         NIvA==
X-Forwarded-Encrypted: i=1; AL+hErHPgMoaYLPeurAHeom5+JCB6G1Cobe9NzGNOy4O2QN+1t2kzOum3su7pIzJj5v05PXqu+lusvWDZQ==@kvack.org
X-Gm-Message-State: APuU4Z+TJ/TnK8EqBnjiogWJJrtR5fP7KNsHUF2kmV4m/dT1cbS93824
	po8tDlG8G14VBvDKqYXy0DwnM5oro8O2S/M+FylhqRBY+XAx48TcxiySFEKSYm6Deq0=
X-Gm-Gg: AYBFou1eW6zmLQTc8G8wODnCdZg1Po3Hgy0V2nQANsSximKsxJC+koYEwLkuKLJN5T9
	hWpLD0QbiW4sM0cgKb+CnvbAz43a08mUAIuis+fqjvNCAjdHfq1s4P/+vjX2Lmwvsvx/OxaWqVL
	hsv4YR82Aha1x7uLxKw98fMGEEfoxgxC1VRKrcyjmD52iUtXqTWnQH0a1kei4x8DdcfaxeoNt7n
	NiMWWLinQP6Ny8arC1rgoHG5OrQvDNThDU2XqTRKFCjYdJF4yhVxhjub87FLVTL9jKTml1TjfdJ
	8Xz9Mo7UJz3/o2jhvujauJxu7z3P2huk1dwvmNhDO/klQfSvd2ah0Ks1kV92Bjq3fN/HVb1fyoR
	iIJB3+IjRTnQ3x7DA6kDPmOh8q/odHdCEIkWoAA90L679RJyWXdHFePNaHCZVEMIjzN7j2Jm1ng
	kKCHTltwf1YogZUorNLUxN5vQCc6C761LjlrPEy1EB2YT7RqJWAjM9GG4YKHs45yLwkwA36CL5b
	YiI2uapi8A/Ao604nCqrmbg6X8P507qGbUZOwZOv/4KxgMar7UZB74MJ7sWVnUzTblKNyXT85/r
	P2XtJaNuj0Zz8dg/5pkjz7vHeJq2
X-Received: by 2002:a05:690c:97:b0:8aa:e4e7:c5a with SMTP id 00721157ae682-8b3badcc919mr23037017b3.5.1794500143784;
        Thu, 12 Nov 2026 08:15:43 -0800 (PST)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3933d4317sm73615477b3.21.2026.11.12.08.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 08:15:42 -0800 (PST)
Date: Thu, 12 Nov 2026 11:15:41 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
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
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 03/13] mm: cachestat: restart the walk after each entry
Message-ID: <avXmLaznzWy27g5K@cmpxchg.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-3-3d2454362e8d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-3-3d2454362e8d@kernel.org>
X-Stat-Signature: gne3r6w9apfpx8ut7gn3g9fxgyj767t8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11A69C000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794500144-181382
X-HE-Meta: U2FsdGVkX186Af7DyStheuPEp0OmL4V7TEu+nzzAuasViDeHqEimQe0m50FmmzBNA7/ExwHzhKys+IwapcFbBISM3lKqoeefyEGKygrNJLXqD1TUu3JqTYMSYVnhepXDvnsnqE6x3yepg9iYLUC/AP4inLkPLHvbMI8QPQa2JQ1dpVjtZm/bnlQeJZ6YgCklQ5sEjYlftfWaEudkl1rbDczufKVH0ZUUCRcMChEmpWDxDclbm0WiBxUF8u3qb9fnjwMsltSipV7qW8F0u51PbmjyRkmCpExPcAnKsnlwEQl7bu1Dl/wyP8M1mvD7mY0WOy5h93vMyW/KkFNai2LehKlEK7BLIAvbxnRJZBXHx0RH5TPvEiO4dqYyicDwsl8a1+sANNuRHLfzQ9azuCep1g47k8B8gwwiSPkm2BqUezjbm8Gydw5CpBCyejMpqfrduC/tDWWmemNm2H+CQ+/AFHlS3Kta9Z7r16DWJxOAH2BEvm4oVSPQgjuIEJ1PPr0hHdm2e12bH+ozeLk6kv4wKMYUjneDOzcFP0JuXVAwpoChmENwZ0WRDT2KTXJS/34WHXQzXFfiHqgQQFgjYCcmqgKbneIs1kMH1lNE/IIHmsgE+uqTGxg2tTWj2Ua87ui/hmB1l59eDbENdUtlS6+LaQANSFITPyodHbMXgKCY+MX9TmoXz4+dmp1oMOf/FtNHIXou8QonJ94mWmoMIGpd8DWoe8Chum4jiLhlD+PNA69N5XTHQuTs7v5Jz0tmbNb3EOOUJRW4rUBMLWu6ijAL32JWN8//GlDsFvDULEAOrW9j14Zac0WU+piboMJx5CdumOiVbqIOd1wh+yHb6a1fhN365sXIC5RlWt7rXx+u346eSuSwsNuYoW/k/WSwyQos9S/x27Z4i6DPCReQnnJEG84B1saofcIC2YM0nt3w5WO+USprS+LHdJT02nDICGmAhIExgO3u0hFbv0CkzU1
 ZffTqo6P
 PnnVJKYI0HmLWsyQ7tA50W9c+8gkF5RUtoucs/Ib0uRZL5u9q4flA/PJOthHVUQx6lzz6tCyWnOchWy7Tl8AC3AQpkuLtX/nISvM9sgmcUf4+TRMy89a9gtYiYbRhfsRv5hbGJ6/PFztVV9oBFQNJNbtj/0WP09crviA+Vu0zBNnxd9aTkfRuvY2oHd/c1Z7D0AF8lkyv3Ea7dIrfZgkzpPHVUkmeKV933GZxi3L51hP0PklzecHPwR9VxcNCi4j3VBBZpbbQ/VIvAT0tfkI/gHgPQB+J7hJUM988JavwSnTsgJclH911fwBuBdzYud5LJXUmmFGqHBn1MDZ60h38ziiOCgDsvtqvG45uajgOFiay22gF7H4eqar0pY232LMyobv6nM/twDHt+SmuIwHYF1Svg1s37IDXyWN6Fw8lbGgV6K3T73anrF3/IlNXuMnATQJGnyHy0t7S2P9XLGs5vidCG9gyCpTzCETRyNYjCRgR633IPuBRNotSAs3ROUyvcVwHMPeStHpzJALaMpuBRusdqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 06:13:17PM +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> cachestat() can leave cached pages out of its counts. This happens if
> the entry that the call has just counted is replaced by a larger folio
> that starts in the same XArray slot.
> 
> The issue is that filemap_cachestat() walks the page cache under the RCU
> read lock, so racing concurrent collapse/split is possible.
> 
> Thus, an entry can be replaced immediately after the walk has returned
> it. When that happens, the next xas_find() skips the sibling entries that
> point to the slot of that entry, since ordinarily they belong to that
> entry.
> 
> However a concurrent collapse_file() or __filemap_add_folio() (when
> replacing a shadow entry) can store a larger folio in the slot, in which
> case the sibling entries belong to the new folio and the walk still skips
> them.
> 
> Consider:
> 
>     cachestat                         collapse
>     =========                         ========
>     count a 64-page folio in slot 8
>                                       store a 512-page folio in slot 8,
>                                       with sibling entries in slots 9-15
>     xas_find() starts at slot 8
>     and skips slots 9-15
>       /* 448 pages are never counted */
> 
> Also consider:
> 
>     filemap_cachestat()                  __filemap_add_folio()
>     ===================                  =====================
>     counts the shadow entry in slot 0
>                                          slot 0: a folio of 32 pages
>                                          slots 1-31: siblings of slot 0
>     xas_find() skips slots 1-31
>       /* 31 pages are never counted */
> 
> Essentially the fact that large folios might be present means we cannot
> safely continue the XArray walk, and must reset the iterator each time.
> 
> Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: squashed 2 commits, fixed up comment in code, and commit message ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

