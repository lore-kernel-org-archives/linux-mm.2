Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E62CBC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 17:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86776B0093; Wed,  5 Aug 2026 13:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36CA6B0095; Wed,  5 Aug 2026 13:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C741B6B0096; Wed,  5 Aug 2026 13:22:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A51C96B0093
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:22:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3079C40551
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:22:55 +0000 (UTC)
X-FDA: 85067885910.20.FB09ADC
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 60B61140018
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:22:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sYPHyWKI;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785950573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dy/CNBOqcKFUjchmAdIYo5sPodHd+JUZpILf5uw/+yY=;
	b=Jo3jfNHdfadliGffz2Z4KKS4Rmxbvv4aoaj0BBXAHSVPXBkXayUiwfrT8M/dJval2W87R8
	eGSucYfE7mqd8/hH7B0FhhFQ5KZIeAPVFzf+UK3nMsnNrbwvtuUBCt21IECCWGELgx3/uq
	v4wg1tTmjLi4gdsxJv+KLBDHdm+se9s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785950573;
	b=u/9dK56IG63RVijgxBsXXFnxNsgifWZg/+ae+VOrmhqseqyK5elxJzUeIbU5IGCnyyLA00
	Qpbuxmmm2esucuhpVW9jgpC6bJegPMDduZ6mXr33SoVHuyVyViZ/oxyTAWX2bP6Ez8qAnC
	BrgV0SViz6hy7HsCLbt4vmZ/JdcBE3w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sYPHyWKI;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 5 Aug 2026 10:22:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785950571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dy/CNBOqcKFUjchmAdIYo5sPodHd+JUZpILf5uw/+yY=;
	b=sYPHyWKIm4d/FYXyH6ZwuNq4kRuydrm2LDu31SsD2Bv8mG23+8S0tguoa3DqIR6jiogVRW
	OaGgs8QqxUDCp9AvwiKSw5btQMsEFf9nvb+i+MGTogNi8vYQ6kUXS/vvyd2uQ2mdKDbnBf
	pOLPP/KSZC3Ec5wIO4CjQTlIy0hQwZw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Erik Hofseth <karl.e.hofseth@opoint.com>, linux-mm@kvack.org, 
	qi.zheng@linux.dev, kasong@tencent.com, baohua@kernel.org, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, ljs@kernel.org, 
	cgroups@vger.kernel.org, regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mm/memcg: folio/lruvec mismatch after cgroup
 offline: lru_size underflow and list_del corruption (7.1)
Message-ID: <anNxSMBgNeLytWOu@linux.dev>
References: <anMmd1ADrDVwMO6v@work>
 <20260805093522.e3ba46aca3a143207d68a65e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805093522.e3ba46aca3a143207d68a65e@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 60B61140018
X-Stat-Signature: u6zuh9kmjbpzyitmow3cz1hrsskrkcrp
X-HE-Tag: 1785950573-367512
X-HE-Meta: U2FsdGVkX1/dS4N4DmDZCqk6YurDd7YCPBWdVRbRqb4zqV3Hon7AjgeKV7a2ZLP1dqkTgkHZVoXom6XYnlGljL3xoKm6ePRPvPINgn6bYtD1WZ3WK2zzLT5BbhLDvNrwauXzixbqHdX9rve6b6pfxM31CGpA/niykmKGY3KBldf13Csqp/CmYEqTqWIOaj/iWJ9ZNlOm4i3NGraRjii9bHPEJAVgHLHhW0bcpELiVTjbPvg4Uzs+kYau7YKd5Y2HjAk2Indas06ydw+zF4IcFfiOQ/cS9mZufIUb53imAsDneQ+M/YndiUo0L3QsfEDJyP+t+YQPtgEPa2K9QnSLgDfOIHCNPFhlhJVKUSNUfKdOaA3cAdkYxo80W+e+UNV15PF4QLNKoCOWAefQBFng5gNdkwbiQmVRctsM/uK5CVZttk+jihD0uAzwmCyI29oTyiITLlLQHc0zYiY+BX5HNk8r9fQdOZo9dUFZhdEvw6KVN9YE7Odu3uy+qYdZn48nlEfHQwaIoCpvCXamX/q6GZBvNvi3bjpoc/GEkgWQmFFIWgePsW0/xcHvcGL+y5b+q8j7cIIN3+CKSiAVSzc3cPCv2K1JXw7GOPWqzHVUOQcg/zQd1Xu93bNLped68Bpi9fN/O0Yy8tPMdbgjYcuA85j1fM1+xUSv/SyrvMWczT4eEYvsQdvRZlke8QRc7N/hF4gZHoP00ssTxTSWDIDpygtU9kB4BLZJbg0vJnynsglJt8GUQhtoPFsP7DmrTj7dDGdhjSJw7DwifDOmHsJ+dNOmkBrmGc8QcCETn8U5qtN6S7AKnapC927Ao638KKRh4JBygcYhEH7krFQU98Op1L6wp4kfH4md1qgWHBmTM4wDJIfNpszwXsDBK87un/tm4iQVPgD5gEe4G5B6KCZasjiCOkAemQvBdjcJz+Oba6i+wVLdEU+9SRRDJFFJ/C0CzGbA6WGmgBIKZc+rzB9
 m26WvEj4
 6Tt5Ao+8k3+rZrH+o+Xc5OiozAQADHCNs2QxOp2hcdpETBvn6Dr1iD4jr98iD1vv8mEk5P/9T5nrJhjmLhJhSP3ic4EVBdMGsftNSvZdlq1Ql6IU15zfI+Ejc3IJ9+YYAVlhcU0pYs+lTSF78nKvhAfs3CjzJ2xXTi//qmyCa7jxWZpWGotQzl519NOliZxU7QYuukZxUbxdkkbXv6y9rIKFLIqHtULRRzDCN37Vb88A1x1XYd+XGkVow0AxTNupnVGlE680aFgGX0cuPACuscqpyEWHqIpmZXmwAe8z1U1yTSRLHqwScMUtYICpYatOb2qOQn4YgJlcy/wAgdYH2ctIKCE9QkcpqsrEsoVfaV/gBSURFR/3VRjU/8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 05, 2026 at 09:35:22AM -0700, Andrew Morton wrote:
> On Wed, 05 Aug 2026 14:03:03 +0200 (CEST) Karl Erik Hofseth <karl.e.hofseth@opoint.com> wrote:
> 
> > The following KASAN slab-use-after-free comes from a Fedora debug kernel
> > build of 7.1.6 with de4660898b7a applied on top, provoked with the
> > attached script. Further down are OOPSes generated by workloads in
> > production on stock Fedora kernels. MGLRU on/off makes no difference.
> 
> Thanks.  It does appear to be a race between migration and memcg
> removal.
> 
> Gemini provides some thoughts, although I've found these AI crash
> interpretations to be a bit unreliable.
> 
> 	https://share.gemini.google/Y6dMvOlHIFuV

I am looking into the issue and will report back.

