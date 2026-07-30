Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E789DC5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 18:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E316B008A; Thu, 30 Jul 2026 14:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05346B0092; Thu, 30 Jul 2026 14:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B806B0093; Thu, 30 Jul 2026 14:09:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 789C26B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:09:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 060761C03F2
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:09:04 +0000 (UTC)
X-FDA: 85046229408.13.B084A12
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id D75CB80008
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:09:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=W2jMvS4m;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785434942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0g23j5vj8+Bp2V9fp4RzYHbi9Ap6ZcD0KhlvvGNkHEE=;
	b=mtbD0ylIrXTVfTCcs71MCyPcVcTaLt5KK2sI17D5IYn2Q8k4sd53rBbFkCjfTjBk9j7vTZ
	bB/lyCqFqTNSv+380TIu5qDCcxqkzZQxCDQKi7bQoF3t5owv5ymTsT5SZlE31B+LHZTQW2
	4RjjYc4mfyYXoHyAWG9vFb4VaDfH1Z0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=W2jMvS4m;
	spf=pass (imf02.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785434942;
	b=FPuf0CpGXMnP9ln1F/UxOm5hmmkvyvQMNJPRWqlBEkjrZU8/mTDbBU7mKsH6yJ3IwkaQFx
	f6zkRZNEvlQEYdaO3z7lfr2PQau8pDAh+OVQfEHvaZUi/StjcXDTK9RVT1gi8PLYlZ6Msf
	3dL8dB46xXP+PSEl/BhVL8ADHyYFits=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e533aacf2so8447385a.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785434941; x=1786039741; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0g23j5vj8+Bp2V9fp4RzYHbi9Ap6ZcD0KhlvvGNkHEE=;
        b=W2jMvS4m2hJ1oLknPUME4CFoLsAMfzn+gJaUPqNYBfizqjx/siJZhA3a4TCdTqFpsH
         uiFL7akZeb/A1zufh4zFh6KRIxLG+8Y2pnclVGNZzGVElCgqIhnD0Fg3xdFNiRtzQ+4p
         fpebN1QdFJSxWYqqIOrONi1Yi5gjc9R+Dv19ZnLDUK/PbkzAJ/un8mEtqcb/XLyY6J0A
         Y6yTj6aFQ8wVJIjyZ4NLVEXFOtT5rzCTa1tFCTPl/2pT72SD+Qnhrk39f9+oaL7y3HcP
         HTcasDAycMyyNAj2jnCAIEqX5oW9VHqT5KP4LV/77Qkpolhep+gIwkxTB9NkNH8wBu+3
         zHTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785434941; x=1786039741;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0g23j5vj8+Bp2V9fp4RzYHbi9Ap6ZcD0KhlvvGNkHEE=;
        b=F5qVU4d1qVBpIcUMqtjWTKDG6tFu+n/Um9pacDf5MEGcH04lo6ESJcBlY5MReYA90R
         H/2SbldAePMkyGoqtmd5bgVf6MMjUhUR70eH/0sMfejoDHCtTMKhWxxa66DKfjsFMHWs
         aAfBdEobku/WAChBscMJG+RfxVbUzbFR9n8Zx50Y9bfOmerEclsmUk/BOS/lv/iZgRPZ
         4rXQoG0pZ9Y8azusZgU/iwUbehHZ0HDJ4ortOpjdOwWq56mxLZ55juQu011tcUUUARSp
         Q7PBqTZdcwy8Mt2lP5dA5Zsv3E3+uU6DA36ki52UhJ6ZXlmNKAXfH/ztb4gTomZHS0oA
         6mIA==
X-Forwarded-Encrypted: i=1; AHgh+RrMx7YGaUkC0OBe8GYePqy8bfOVufGwxZXV2YRXDVuNyldtXiY1JBVwPE+/7lo+VvQGbbiqLvQ7UQ==@kvack.org
X-Gm-Message-State: AOJu0YwL0bnL/nCYShbS7pY0WJA6kvLjSjX0yMlAfdAmuXM2mfrt4QeH
	ssDCfipc48wKyXebLWiC364WITC3BHzYyvM8zIPft26zejd9VI1Dn4Xo9MHrhqAbQ80=
X-Gm-Gg: AR+sD10WbgG3aG+cbIJoaJqPZg5VYyokrkkzii30EBQgkAhEr7QckTQrG7Vi52l85om
	Haerr0tB6tFBU6nX+AZ4kzxJgsJ6fytwIpxNPMgVEz0kmbZ68SCBNBodYCzUxfItd5wAYphFNBh
	OQFMzLqMoI4jab4bW44BxIktn+08i6s7HeU++/vgtF5rP+DC8lNdlTzMiIAcJG4NKXtLgOfS50m
	NtJi0G+qK7Q/L3GyTeoNYTfBYCWSRPX+wttw+VAvPki1ReAn3t869/pFUl/s5vHXFdADGwl/Ocr
	QHXXDIdEFivFuxopENtpnR/RRL+PtMlsZCrJloohEmEz0bY2DHyw99sKoY4QmiwewKtmQEe2eWZ
	Owbt9aYuk4Ma+lZU8PsdyWI9vOzPdGKWPzJRyNEUv5doZCI8h/StVg6oYKYc6hXWU9H3YUAIIvG
	cn+sLF3hs8PEb3eXOLXYl1kdyCSIJiTMHN7afEn2AfrSrG1yCGNnsEnqN3Zxs=
X-Received: by 2002:a05:620a:260f:b0:92a:1b20:fe0c with SMTP id af79cd13be357-93485fa518dmr413028985a.17.1785434940796;
        Thu, 30 Jul 2026 11:09:00 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933d3264577sm464848585a.17.2026.07.30.11.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 11:09:00 -0700 (PDT)
Date: Thu, 30 Jul 2026 14:08:56 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Frank van der Linden <fvdl@google.com>
Cc: Gregory Price <gourry@gourry.net>,
	Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	David Rientjes <rientjes@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Raghavendra K T <rkodsara@amd.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	SeongJae Park <sj@kernel.org>, Wei Xu <weixugc@google.com>,
	Xuezheng Chu <xuezhengchu@huawei.com>,
	Yiannis Nikolakopoulos <yiannis@zptcorp.com>, dimitrios@palyvos.net,
	Ryan Roberts <ryan.roberts@arm.com>,
	Huan Nguyen <nhuhuan@google.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nfs@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Alirad Malek <alirad.malek@zptcorp.com>
Subject: Re: [PATCH RFC v2 0/3] Demote to lower tier using non-temporal stores
Message-ID: <amuTOC7qxWHVyZcO@cmpxchg.org>
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
 <amuJbBrTW9W6_sx8@gourry-fedora-PF4VCD3F>
 <CAPTztWatWbsF4KQwD-_nib-vrZ6uvrhMYcOc1mkWu-7DzN95AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPTztWatWbsF4KQwD-_nib-vrZ6uvrhMYcOc1mkWu-7DzN95AQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D75CB80008
X-Stat-Signature: ci5dnxwenubi1zwpkjh4zu6ikuhwad66
X-HE-Tag: 1785434941-863996
X-HE-Meta: U2FsdGVkX18SnHh5RITFDDojrGeWOO0rAEZTA2zhT+eWZg5IG7Dp6fBPZl4YFcv9zPGE0uqz+KfMWXkMO0hvU+IFQItZ9BRMhmKTttfFaz6/g421IW83AJpSZ+x5TpcaqdnGunqE2UbiTV8/cOYObfKE8CSly5nBm7Oak+vuevlglDqnPN//YlcmeWxcdpyYt/Zh1+93Ajp+8mXpIXAHra7CIyQ6KwMw50ETNpKljLpinL+5yt5DbezcJtXPXyiMO45O3W5U9NbRjMFrbq4Jqw9QAD5SptRE2Dn3mqVCQg3swiNVJULz/uO3xMXMsHif6YXv8EoxGgMVNH4SDRwDaXetMD8aG2bgGOuVzGNRo9Gz5TL973htkDq4TOMgEPHGt5gjGn5Kn4Z96/cRP/TN/3x5COeOzkDDv4O4q9+4Vfezsn1ZjsyAsdlNSDSG40xtCb/fVmga7kh+z912CryPjUjyA4lIWKTs3emsRFhWjIUH1ncJWbmfHse5MVcpG2v5bxn/OTAsyC+WjBabgzfMlX5nojilnojFquQnVv+g/w0z7cHWDiyMOJWrlzuaj3CfH+3tv9c+Hfwd179xey0Vh7liZogLZ/LtTjAApZfVnvoXXfhVFPCt0oOyU5oQcPT5DeLpEGuLmxuwDXJY17SQIC0d+fSXHkiIF3PAY6KrSPETx29/BAtB/e7RD9tiTz+bAxRxRp60KST/2q1ERZtsyhO86gR9lm1FSJ3NbYHcbIPiIuTByBXFZ/fLOli1vxV7VEidl/wMMDon/aMyT1H5/R6xIlTD8v5sFa21AC8nLxLiK/Fmox1f6Mgfno9x3cJfTz6bcVZnfm2rt86QN4rFA0v21NC0pGhshSZb3HHzF0Xzhx4IK07RD1qqOt2pShLfxuqbmKgJsqBiJ6q0kGgmW499kEaaboKtUPg7mzhxKe8PHENmDLoIVNaErc4g8mEPSY5c8Dh0Ks6f4y5i9i5
 hAE5jmYo
 RdgeN295PrjyQV7nHplY4VzJ+5bLO8of02Wqv+ovs3UvBZmAUCmctgz12aBBfLoUBgrD9gzzrXLC0ceq3QEDOAC15PRxZcbvyO3xpuDfLB7aTS/61q0FR6m1jNgJIQK1zMhbe+nWocfFMZ4zHAbJJokEIFFTI2A7PNZy8P3mnroV1N/UBd9/id6fcDOOvZ5WfeV+/GS0syUIE/GbvZ6hFBmy36sy2czbZBRLVrSXvsnbHqz2cda+IJQpucGCjTIaFhWk11lcRheIPwjYj20psTn1dfUKTDjBKFsbVGEkph3n2BlEQWVPFKSQ2mBT5jx+V28ZH59917wI1cASA2sdn/mvmMOgoJ80EQGO72f5BNd5GtyjL47psAIjV4Pz8hoBC+JgZRHxJuTIR13hUcad7Dx8U6lW3ru7kvns/720iJ+8MvU9tGN6I8GB4IOUe72fOSO83YeDu+ePcw09dfIVPl2JWi1yVnrzzJ+kXEIOb0zx3NPVNQAygUYfSzazDD9/Ab7OPSdCQyYkXlPfLoGl5FLKeE1zmbAE84gycLqjO8SLW+1NOxmp6vJQIDMqFWhTE8BGx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:40:32AM -0700, Frank van der Linden wrote:
> On Thu, Jul 30, 2026 at 10:30 AM Gregory Price <gourry@gourry.net> wrote:
> >
> > On Thu, Jul 30, 2026 at 05:02:56PM +0200, Yiannis Nikolakopoulos wrote:
> > > In most memory tiering scenarios, the memory to be demoted is expected
> > > to be cold and most likely out of the node's last-level cache (as well
> > > as target pages in the target node). Using non-temporal stores instead
> > > of a standard memcpy path can reduce the cache pollution in the local
> > > node and the bandwidth overhead to the target node. Furthermore, for
> > > certain types of CXL devices that support in-line memory compression,
> > > the last-level cache eviction patterns can negatively affect the
> > > bandwidth of the device. Non-temporal stores can mitigate this.
> > >
> > > This patch-set introduces a new migrate_mode flag for using non-temporal
> > > stores that is used only in the demotion path. Patch 1 adds some helpers in
> > > x86 and mm to bring non-temporal stores support to a respective folio_copy
> > > function. Patch 2 adds the new flag and necessary changes for compatibility
> > > with the existing behavior. Patch 3 uses the new flag for demotions.
> > >
> > > Experimental data: in a CXL system with 1 memory expander, a microbenchmark
> > > that allocates N=64 GB memory in the local node and then triggers demotion
> > > using memory.reclaim, shows a practically complete elimination of read
> > > traffic on the device, i.e. write traffic is N GB with and without the
> > > patch, while read traffic drops from N to almost 0 with the patch.
> > >
> > > Opens:
> > > 1. There is some "duplication" in the x86 tree and a bit in mm. Can we do
> > >    something better there? As it is now in copy_mc_to_kernel_nt we
> > > duplicate the machine check functionality, which if available will override
> > > the non-temporal. We were not sure how to prioritize these two and what's
> > > the best approach here. Can we completely skip the machine checked for this
> > > path? Huan Nguyen has some ideas here that we will align for the next
> > > version.
> > > 2. I am not sure how this should be structured so that it is easily
> > > adopted in other architecture trees (e.g. aarch64). We rely on
> > > memcpy_flushcache for x86_64 but this does not use non temporal stores
> > > in ARM. ARM support is currently out of our scope but any input is
> > > appreciated.
> > >
> >
> > I'm still a bit confused why using NT Stores needs to be an explicit
> > option - rather than the default behavior if NT Store is available.
> >
> > Lets assume we did this for all ASYNC requests, is there a negative
> > effect? A positive effect? Why the new ASYNC type? Is there a
> > correctness issue?
> >
> > ~Gregory
> 
> Yes, this is a good discussion to have. I believe that the initial
> reason for using a separate mode here was to be non-invasive, e.g.
> "don't break anything else".
> 
> But why not use non-temporal stores for everything? I don't know. I
> suppose one argument might be that if you know that the destination
> will be used immediately, NT stores might be a slight performance hit.

do_numa_page() -> migrate_misplaced_folio() is such a case. It happens
literally in the access path to that data. MIGRATE_ASYNC just means
don't block, fail fast, because waiting for an IO-bound lock to avoid
a remote NUMA access would be a bad idea.

Compaction on the other hand does use MIGRATE_SYNC* and it's touching
data in PFN order, completely out of execution sequence. That could be
a good candidate for NT stores.

> arm64 already seems to use stores with NT hints by default.
> 
> In general, though, I agree that for ASYNC requests, just always using
> NT seems fine.
> 
> Maybe the mode and reason should be folded in to one variable, so
> that, further down the stack, a decision can be made as to what type
> of copy to use? E.g. if the mode is !MIGRATE_ASYNC and the reason is
> MR_DEMOTION, then non-temporal is still a good choice. If the mode is
> MIGRATE_ASYNC, NT is still a good idea. If you wanted to get fancy,
> any mode with folio_test_waiters(folio) == true should not use NT,
> since a task is waiting to use the data, so caching it is better.
> Maybe that's overthinking it.

Agree. `reason' seems like a much stronger signal.

