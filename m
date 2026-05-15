Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBE4ECD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 15:52:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1823F6B0088; Fri, 15 May 2026 11:52:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D6C6B0096; Fri, 15 May 2026 11:52:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17766B0098; Fri, 15 May 2026 11:52:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC4D16B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:52:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9EBF0140131
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:52:05 +0000 (UTC)
X-FDA: 84770095410.30.719B9B2
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id A36F52000F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:52:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=j8ErRF32;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778860323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYFOyMeTYplTKwOs2+O9r9ySgVaMin9+w0Ig6h6MeP8=;
	b=WBj1D+nbUDRE3OqtF9HBvN2KegM2CmbelbfHiVsn62ubS2Ne1VfqUuHnA9X9N8PbkJK69O
	PBsYneieo9U6tHTy8F4mHJC07TLLnpSvJ9tb9Mqv+7gBGTBx2B4OSmnatY3d8M2Dq2AhSE
	uF8rzVCais1Fw9XjewHNT5fddoJNxUI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778860323; a=rsa-sha256;
	cv=none;
	b=Fuibrb5prBxROdbhDs5+jFKmk8bFN+vxInvlHihv+X1URVo5gfV/EWvBXdskbF2sLwgIpM
	qmNON7h6KU0Qd/RsYPLD4uNH5OEovF8YV/U4korxwsqZnaAeqsrVaSH68IW6fXiDR8yKhv
	J2P+APPET89gN/CS4EUf/RalUtO9Mh8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=j8ErRF32;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.50 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8b3fe2f19a4so89729716d6.2
        for <linux-mm@kvack.org>; Fri, 15 May 2026 08:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778860323; x=1779465123; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PYFOyMeTYplTKwOs2+O9r9ySgVaMin9+w0Ig6h6MeP8=;
        b=j8ErRF32MZbFn5IXMdIKHmYXCmaH2W/d3GHPcZNxVA8jS/iCO/Vm8jom1h30awN5q7
         1YQ5qmkKSvaoKn7S9W3ytBUts3j6SL8fzi9pw2lW9h7UiiYCVmMGKdxNfpPyZiIFKWkK
         iyxHRSe6kl3Nz6byoRMUVtrW8tP4WTnnNCmt9t80NWvMSuOHpVYHaDX9Sf4MhBBthzqh
         VRs3n03rTeCUx+rdQnfqEt4UKKLs8AVw+OmujMRYpZueGIUcZkEG3RKUj5LbrIstI5/E
         QskPjVe13ZYaLul50aBM3cOmZc/OEng46J9NNQA6PK/hiF7tJwtAGM1buiLj5VMan0Db
         lbww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778860323; x=1779465123;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PYFOyMeTYplTKwOs2+O9r9ySgVaMin9+w0Ig6h6MeP8=;
        b=V6SEn3deMtyNBbCznJc2whh6pcKYdxu1n1iPzq6n5RKjiO1H5SLY/PG/X38nTgPVh2
         Uh+P/FBcx0dD4f/xn+0dWvGbi32sGH2IQPTf2OetQJ9Sjs8auAHdnBlB6F7OpFfP1EWO
         blHINrGBzQ/o0o/HOTUX+Tbhf+g7enCfrHQ5rDi9Z754vAWRYegly9ROUbFKBZCvkls7
         Dk41fRGqWDiDlZKpLzENYI7l9LOOadyQrtm/L2us1Px5tWqC2tJezZPn+557U0Y9shdo
         4FVZ7wjyXhndtO5BvWpciKyuWFUEQYrdpb9jqJYF6aIyW7YRfdfx1+r2kUHqfgUORl0P
         5jsA==
X-Forwarded-Encrypted: i=1; AFNElJ8BY28SwshWlcgAVdZ7rK3/VkMwbHzalXOwj0dSAtMSp/c2+RMjZ3SFDjWsJIGbpXR6uvrHYpKnmg==@kvack.org
X-Gm-Message-State: AOJu0Yx/I9Q5SQCrN58YLgooDUtzb0560NquWDI84RqZfG2oDIXlsN//
	gfdAaJu6aNuBgZREaCwONp2OVEhJLSlnXA3FyTGOq5z0Aigp7Yshjxj8ljj/IKEEORE=
X-Gm-Gg: Acq92OFKuthx6e1Xk3F6kl+FbUjEKXa4kNolcHUEfzDYadq4TZTT9qRBOpA+GnYHIYp
	1v79ygCgYgyBMVPubHeXtv6/GI5NK24yztuUrjS+HH8mcwrC6kQN5txivWp7eZqhV5Ja+pNNMfK
	4UQCSwfMjiUUlFYK3vqejnkTrVy6NWS0jzv45awWGgYpCXT02DzfDmz07PZUQm3uzb8c6xnHTUe
	5czewrCSqQ9UfZK5zIHQqdq2TcqcOACr1dCLLE+8eo49eGA6J8+iuw+sW8on7S9wof3r+bmqjk2
	mwUpLi+WxxJs8gxxUv5A20oJ0GZx+nz7SYoZaijCOgZDfYosLNECZB8uk4hf7uEEQ6+XFEU1ZYr
	/yS0y288gmLeGsyC9eXkExyOkAzogQaP6akE+GbDT6GmIPmyQJU8WkPK+0v0BPID5z692zcrDmy
	ztwE5fyZlVWBZfTzFwfleRFo+W6qmYJEEzfbw5sklZ4kpLXEpa/PxJJIAGjbOcBsaOux19Vr3sS
	vaCX0Iq+7LN
X-Received: by 2002:a05:6214:5182:b0:8ca:1eb5:eaa3 with SMTP id 6a1803df08f44-8ca1eb5edb6mr9357586d6.27.1778860322577;
        Fri, 15 May 2026 08:52:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c90b2dc4besm54238296d6.32.2026.05.15.08.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 08:52:02 -0700 (PDT)
Date: Fri, 15 May 2026 11:52:00 -0400
From: Gregory Price <gourry@gourry.net>
To: Brendan Jackman <jackmanb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, rppt@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com,
	reijiw@google.com, Will Deacon <will@kernel.org>,
	rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v2 18/22] mm/page_alloc: introduce ALLOC_NOBLOCK
Message-ID: <agdBIDPhJGRpket2@gourry-fedora-PF4VCD3F>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-18-28bf1bd54f41@google.com>
 <d5972a1d-42cd-4510-b734-c47b927af501@kernel.org>
 <DIJAH8TVP33G.2YWJ4Z0KO0PZJ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DIJAH8TVP33G.2YWJ4Z0KO0PZJ@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A36F52000F
X-Stat-Signature: gjzu73dr9d6adcjk8oety84f8mo74bsg
X-Rspam-User: 
X-HE-Tag: 1778860323-235967
X-HE-Meta: U2FsdGVkX197RYLjViet+YZDaYLHxyV4PKGEP5OE1a10JfxnAB9NQMJnv9Rv7no3SpYZ4nLmHXLOMRkRQ1mRhFMnq57i60uLt6OvvtdeTv+6bR3fBdQgwgrdt3JnAfe77L8A8TxgKC/3rEK0CTLJF7h0YffQ6eeVPVSiMDgMYI+sXtuJycOf/ZG1UbXjYBeH9wefYbQaeoZSge1LEIb5m0Efi9rIQx1LffklWELvipqQUwJ/3aV5yKdw/7pr93QtBdanDxL9ZcWkHx7gCusxbSIGUgb1E3RjAmI515JbWrbEvbExO2g6LIeeSK1o8mUTZBACjJUv91vUp1aawNwXseST9g6DRF7vFFqs0GmkJymljL6uWJFzOW8exoA5c1sgvlKReIipri/5l9CC/xxFtGU5VCj130ffG3BfiOAsiWTq6Vw68ekLKmu0cxChl2rYE4SLYkrzvUdFs+GzEV6bS/Bok+8Pwg2Rp/hVf08YQUDNqeA9Cq5SN7XsCyTZkcJNSrc/CqtXuvxbmpt4nDx4X8usKa0fNrsNcl4OpVFb6WtnQZ3svdaO+2Z2Wqq1ymS/p9biY/QEqZxL6XFs65i16saLj9LXQX+6ytU9fByYNBDJglNzng+eDIgDuSCA61hst3lHG64TJo+cVeEw9cUjLUfnphanQyxAZ8pKrj+imAGVkRhwWGLesIJ+f7DL3Ic3yptLoihPuSd/ZxtV+204J6COD5kGqRnIoKGZMG/Dp14oEyszYMwJDxuYp1VdZSQoScEwAkUjRQgydvJkrXgvzDcvOZDqYVcLcPj/dMKSG56AIkNsVaOJJKALGd5Gk7bM6Zx7Y16LlyRmMPeXL7QdxdmXKX/Ur20QecYRD0qB95Rnq8pVbqr2Kzso3tnbdvDKgyhHY7PVEpA0wgZVihy9zSvCUjL16TkQoxAPyegzMS1ycDFDZ/FljEqHqA/0vyYAbnP393pgegYZuKhVODA
 scGcSsRU
 w18qsK7qI/BK4J/M72eigHlDpAbk2znztExBAD4fHzqnAzfe7Xq/f9xgkETVQ8tWtgU5jnmU5xWhfB7EqQUwsXynxXBGDZcIpjUf3e3WhgfQS9Ad2D0/vtKW7yIPvWRiFjuEUtHqpa5+U8UZ6Lq8Kx0m5LMwWIgoL3iMVki9WM+Ma5PuLIgEfGfqX74EHEepSXiqAa9ysTwF/1pwrzvfz47s8ngrIQ0HrHtfaeW5DPM4ASjDCt6mO5TKCfWV2PQ3LgGoZ5ToKacG8XmnQok+fwDWYAGIJ27U3duWMc8EA0eD76V8WXvJfljju8K9Y+YWxCIUGJwJt3oZHSVi1Cyq+Na3srF8ZralECb/ytlyLUCqLNy8HyhDwD76imw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 01:36:43PM +0000, Brendan Jackman wrote:
> On Wed May 13, 2026 at 9:43 AM UTC, Vlastimil Babka (SUSE) wrote:
> >
> > Is it safe to just combine them? You come with ALLOC_WMARK_LOW and combine
> > with ALLOC_WMARK_MIN from gfp_to_alloc_flags() but these are not bit flags,
> > I think you end up with ALLOC_WMARK_LOW effectively.
> 
> Ah, thanks, I do remember thinking about this and deciding that it was
> safe but I probably just misunderstood the watermark code.
> 
> This makes me a bit more attracted to the idea of a struct like Gregory
> suggested in [1]. Then this could be captured in the type system.
> 

This might actually be a good precursor before pulling alloc_context any
further out.  Since there's multiple paths into the lower layers with
alloc_context, maybe there should already be a sanity check of the alloc
flags anyway.

~Gregory

