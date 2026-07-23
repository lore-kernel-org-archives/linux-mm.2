Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0073EC531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 11:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3BB56B0096; Thu, 23 Jul 2026 07:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13526B0099; Thu, 23 Jul 2026 07:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C516E6B009B; Thu, 23 Jul 2026 07:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB0E6B0096
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:32:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 30111140469
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:32:41 +0000 (UTC)
X-FDA: 85019828922.25.87A4DCE
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8327610000E
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:32:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M8EU4Cgi;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784806359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iUNsv6F3BRPV+HsqzTlYvS5WqAvohT5slA1cbOMhU4U=;
	b=2zt0OQIwd5hVHPgDAAv9BLAOHUbo2RKH5Ael8oCRLaJujPCCTp2/v/waELzRTaSbVmZu8Y
	FzhEilo1ej02V7bI7KSEbpzX2/jEEBP09gtiA71o5Nik6TjSs7UqLoZq2v3S8wg+geCUzg
	6uMgs/ItnI44OSzwRQyWdeYP6geBz+c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784806359;
	b=GMXdBFwEFQ8FNl0pcpIAyJGvNC5+7TJdPw7oAi9OYkjpZ/Een65E/A1mXWTuf7BuPlvR/I
	Jp4G2iYg2wX6mRJXOAu/gRplLziu42+jyb7BKWu00PH8wtHUPBkwx9jLQ7apEfNFim3BUS
	IXH5QDlp0M42oV/auPtL4BXtUT4CjmA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M8EU4Cgi;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 23 Jul 2026 19:32:21 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784806358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iUNsv6F3BRPV+HsqzTlYvS5WqAvohT5slA1cbOMhU4U=;
	b=M8EU4CgijEd5DCerVoGnYh+RGtbQdjnraBJPaghjurMDVh2IzLzv9YfWhsgRGwAgegVrde
	G/HUYHHc1xzsB/JupdlLmAJGa5/pljUpwi84RyKtfVCfQE75DJlkc5gNow3rt/6abL8Vbo
	baUINkUifWh+dm94p7eBnhyOwlIDHyw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 07/13] mm/slab: abstract slabobj_ext.ref access
Message-ID: <amH7u3qrEBZ5jREH@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-7-2fa7c6f60dbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-7-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8327610000E
X-Stat-Signature: mds6bx1478p9u73sar64df35ygqrm8d6
X-Rspam-User: 
X-HE-Tag: 1784806359-887978
X-HE-Meta: U2FsdGVkX198i1eJtIyb5dfbz0hoc72hCljNNW8lAvrKnQw1GxYmCMceRfPjT0DeE2ed9SpI4Nn9og3jw/Ugy0Iaz0JdVy+R0PubJpuPCYohnrGb+ZnYKRM21VQE6LqO4RSzy0ScsFYQGCr9diqFubdIRAs6R1jYgTLoT8LC2r0628stJXauWna5GOhrP/+YdzBE19YqcVY1FmrVPAd28jOCRroqdAzFp+XrmVXQ/W/m8vDOiZoZNDX/TivS6R01f2BeQNuBeAg487WtAyW/0Nr8+yFSvGbb/2LZzXQhczZM3giMkDZ/wkFq9FRgpT4tJVSJwViYtXoTHVt7WPz7VZ/GY3FWaaoLHPDtkLvBit7GNGwA0gLoBYCHxyHupfYQDwGAzHcKdwoq1JQi6DRpHT3qnzv9T8FwDA3+1wJoWUrKuA39yrtAlpcabazwvLoJvKy38BA4F8qKURadxi4RcIx5cNJNBEz2Cdx1u8UWch5fxKKP/D/HVLal8VPXyJxTciEEJTDvG7APYVCNCpFYphHcqb9Tvc3FjnXVecXTDN79HecMvYFNl6+I7EXbycZJpTajIvS23l0hQD2aGAAd6lvEj+zyjK4qV+08aak+W3aossJajNfRz855sop4bF9k4GQqX/RAsC6LoBTINfs/Nc3msY+LZGWqzZRfl/GAYmHTNPycx+SungKbTVZWCaDKdDT4X3tJOwNVYiT7Z9v7le61pu83Jt+Oz4FqcxP6DWyYmXcdBs32DsL8zVm3JNR0xeH63pF7eMdYLyZBDWQOBT7u/7lsB2kjRY24angTTMIFbr2FsHXHKys/cDZvD3St+VfPA/GtCtnopSR/y0A75sIHqSInzRqxW/KFoqU0Hi7xmc+Ri7+L4bEDKy+3BcBZajnhpODPHXbLnM8umTOZoew3D9k+D/oZlK5376Nm9AbTKOJA7Af3GDWNvoQvJHXQ6NaIjsmgj3Tck2go7LJ
 LZXe+lkI
 qGHwANI1K4qixYk5sntXXQIoPp0jOGHZgTvQ8uapnRSYJJRXJkHLN42KBYJgb6dKPEr5AbdG4YrsoEj+g6XuRuh5pKdEwMccQ2ffEz1LA4jxpA1eVkKbaASJJIb8xGFZoBQ3+pW3hI0Y8StlrawgvglxEQZHFIMlNNmvrYN7+5goJ7wmJLESi9L3+5CE2Bqwy4tFki6NXUS9NYPpGXkgarynTRTgmGTzritTa0dogC77aGbcOsFQ9JxAPknHvXpCNUCwT0dn6SZERWgrXQxgmj8XcIifMGU1jI3V1Hg7NTdFnPpD7CAEi9ALbMX4QujcCCN90PVH3yT9X5oE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:16:21PM +0200, Vlastimil Babka (SUSE) wrote:
> In preparation for changes to the structure, abstract access to the ref
> field with a slab_obj_ext_codetag_ref() function. Rename the field to
> _ctref to make an unexpected direct access a compile error.
> 
> No functional change intended.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

