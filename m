Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8010DD1BDD9
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 20:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01DF6B0024; Wed,  3 Dec 2025 15:09:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD92C6B0027; Wed,  3 Dec 2025 15:09:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEFE16B0028; Wed,  3 Dec 2025 15:09:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0756B0024
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 15:09:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 512518AB0E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:09:58 +0000 (UTC)
X-FDA: 84179250876.09.5F5E42B
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7DE9940006
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:09:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GPnzo3dW;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764792596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dM9kmvuGcf01lAd6S+2H7PL5yiWV5TtpfoTgVCJUhlU=;
	b=T2Ot2bDJSVu/0lL5A5PPTKMwYyB1vBfYSQXEQrv/bl3fxVr37frQ+s/qs6fDxKz7EcZYu1
	dbp73J5oaX1nszSOhfmFDbAC3oJM15EXcWeYn9JAMzPjs/XfqcaAuLp5oc/asEnZInAc5g
	5oQsCS6Wn0Wq1+f2Q+c2Tqy25KnZjYw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764792596; a=rsa-sha256;
	cv=none;
	b=adg+POlHtFgrcPWhVESUcFNIka+ZL98QRksye5TXvMezZZ8gnANN6PD5x5DDvzqvZkdae4
	IFPty20N4EKg7gyherhhsyIra0o5sEIZY+n1Q8i1CQj1j+RBMeEmoxXZRNukOzvXbage+X
	0P9UsEZcDx8GXEdv0Khk4lky4UADaxo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GPnzo3dW;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.169 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4ee0ce50b95so11610671cf.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 12:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764792595; x=1765397395; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dM9kmvuGcf01lAd6S+2H7PL5yiWV5TtpfoTgVCJUhlU=;
        b=GPnzo3dW7MZfhKiyGpID5LPNzQKn281EWIp+ORbmqmWoEOct5ln2WtW3Oxjkh+Mg9Z
         JaOSAZ9LsWBsb696xFKWyRBPwX3r2gSrPEdHtJH0HLGq+lBvD1V/rz7q2oiwA59DO8ei
         pL84U/pvfjPKMcBtYNQ6vVhKWtwD+f8wpT7P0n8BI+QMfTfedmGXDEJHppblinaRpgqp
         OmdiqvrpU8q1l2gmotKPWxFIsPta4fr6art53sOsyloYhSx0HIYzN8PpF6bp7PL42yN1
         9CAGKjDjG+nhpZmtHd8XImYuqry4Tih0BGVo6m5Lma1DKgv6MHAs6IZe49+lOQ4DBjlD
         /c8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764792595; x=1765397395;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dM9kmvuGcf01lAd6S+2H7PL5yiWV5TtpfoTgVCJUhlU=;
        b=VjqCZRFcB6SJeU0BAGR7ifQw3d4HqI1TllMmVGD4XyFic3cOl+klQUyQEfhjtuDdlT
         RC4I9sNUX60V1bCrMo4mqwBnN8hbJB6NH8OlOzozFT4iWEAz5HmNJcMkZbX3gF1LK0zT
         0BWWTKS+Mzw0T4zheH5tJB/JQFEmXy59TMN6bBYbll8CbTD8cP1LM7JVm8Ul70yqEVod
         2rmr9qxmQhDQND0A2RXGjQc0eXLL2phnubdcZBeqPCY7wDXY8pOkJ3SzXvXsaFmSjMXD
         DbIp6XnZ+Ly1cRRzi5C/y6ySHOCMYUw6Bu5RnHaPGLFysxIILmX9Hy+AMFT5iFx8pYBf
         2AEw==
X-Forwarded-Encrypted: i=1; AJvYcCU8xpewnts21GKFNWhkwtCMjVTYU+hTjuDkQYc46jwJ0yUH+YcqEj3U0H892vwUtSl2uUoFku84AA==@kvack.org
X-Gm-Message-State: AOJu0Yz9RT7g9Y9t3744mwE/QxhHpPWg6BQrj+dY6NawLTlgY7GScC2e
	7smNgUA1rotFTUcjD611KqF9F+Wll7ic5wAlxfYdPdiBFtVtBAwRsdk4sYTQ6AG+qwUT4KryBxT
	CSgQe
X-Gm-Gg: ASbGncuztZwF2tDi/OAgly8W3GzJPVpxu891BCcOlhHGpR07AKP67Aik40qc1L1BZuq
	j2vHkTBAMoRFYrgNi3UyRZxJAXTiL0XhVNIDIlxqBNSdgBHNrie5/q31dr1PYlbcW0Rh0kR6xQT
	ENOKSZsik0ShIy+zA11TGbXfSAgAJtYX19Eq0QbQ4PVDUL2YNpJt7wb+YUNBLOzYaeVfVZSiRsE
	EZstPSDn+sF6mHdD2KsHqNg10yQB8cxxLr/zcKiNHLjXM6CM8+0MY+Y+mrjm1JC5wL4CQ7r7Var
	zLr2fuAFeEhnqKvS8nSE9iM7kNEUNMMHdgOav+9yRmvwQPycIaEL5HQNLAfMZ9KtXjY6y/h//6w
	c3mL0vO60ehKrRxIdmzHRvvWjCXADKDj+2eyN/8pTJTGwMOR1K7ERA86+nGTJlJer0C5ofYKqoW
	cYyzJH5N2flgXwugca//V8uVBHrGj93OV8ndRPWlhGbBoXXV6uIbrqn1NWlCCgHXBN5WLPoA==
X-Google-Smtp-Source: AGHT+IFswzoLbYyAnTaGWHaVOhoPJRdayisLZnLjNLq2Lu7DRCXUfj9vN9FAKPL4xYFJA51ycMkLVg==
X-Received: by 2002:ac8:574c:0:b0:4e6:df3e:2abe with SMTP id d75a77b69052e-4f023085a27mr12255981cf.9.1764792595536;
        Wed, 03 Dec 2025 12:09:55 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b8fcbesm133694426d6.54.2025.12.03.12.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 12:09:54 -0800 (PST)
Date: Wed, 3 Dec 2025 15:09:53 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	kas@kernel.org, dave.hansen@linux.intel.com,
	rick.p.edgecombe@intel.com, muchun.song@linux.dev,
	osalvador@suse.de, x86@kernel.org, linux-coco@lists.linux.dev,
	kvm@vger.kernel.org, Wei Yang <richard.weiyang@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v4] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <aTCZEcJqcgGv8Zir@gourry-fedora-PF4VCD3F>
References: <20251203063004.185182-1-gourry@gourry.net>
 <20251203173209.GA478168@cmpxchg.org>
 <aTB5CJ0oFfPjavGx@gourry-fedora-PF4VCD3F>
 <CAPTztWar1KqLyUOknkf0XVnO9JOBbMxov6pHZjEm4Ou0wtSJTA@mail.gmail.com>
 <b5a925c5-523e-41e1-a3ce-0bb51ce0e995@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5a925c5-523e-41e1-a3ce-0bb51ce0e995@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7DE9940006
X-Stat-Signature: 4toeo5ceu54i318ainjyq8e58ge6ynym
X-Rspam-User: 
X-HE-Tag: 1764792596-743686
X-HE-Meta: U2FsdGVkX1/V5UEwtpRhyFBd+ariHcx0XcQuofJ2BkhApG5Oc/KS7jGXRe1MTzljZZKlm3SmgGNVfyXI57S8YnFZdCHM/D8FvQjM/5i8lKy2MbJFyHtHYW/joKFD44+wAUc0NtzafIStAoIoRoo0WjuPZb43PdLMhV3NqXfWeBRO4NO3+kIWzsC5SRgnXKk4E4meT6hQ+GP2ZJs1lBhe3l1Rzs9q2bSQxar7L4tU9LTwiXI+W8o7d9ZBcaf8xSKh3eeU6CVcDi7cO5uHuiP8B0Z6gyklGSexCWHM2H0uAgR5qZ4y7tPpPeQeHKf2XNBqh62oa5Y4TyrWApEsvxx10COsxUHZKLuEayDT3u7apRwrCAB/5OdVVvISOF4eVv8+naJSbLJ53XUF5dhXggHDlmYCmIQsJcOdmykmagRFAZOZe8soBp9WFojZ7DpBCVvkt/GgQOGHiGSRuErIurqAgnQmTK17FBKwEWFlzn6zCrQ5O+wSMyg4WQLbumqPT8NRv5poauo7X0HoDkaB0u0STCd3bpPgpVCq6wNzURNB9A+cVp+H4hXwivNMLiiNg9smyiFYFvCe+Ub+Px34oPVZ1Hc+nsl6YTtglknfY5MKpUdSRs8tQlQ3jENGcwOAjbwzZ5gd1cqwF2zbzWUsO7l7HeobO+TWw3GvGvXbry+FDWK8DbByJBWybu5R3RYQ8ZL8sMuz06TsLjW7PB/E3SLuBke5zzv8g+SqKN1Z+KW9M9XIIah/chz8iUi4q/qJyu4pCruI54YGhfBcRAofo9NQBp+wyPYhegp/nPFlS23n/PXRryXOXV4fijrIFHbXhMgRz0FxR09uX+VavfCEzkLx1RI/ZFLhjKSqeBNrppVtOFgcqujh04Xh15sLl6Eg/QIKEYZJz7OtZ8qcJWE2bpJuQJaqXxmhtGQtlLUiBzE/+ltWWtDrSU6xgjyrDqP7wAbcHDJVUqtEL949z4vhR0W
 NE6z67U6
 5mZMwdu3UR2NBvGxfAH4u/MaZ3f5hvvyDVhLzAiK0ZVxOTAFDw5vdN36uFCWtqMlMMhCflf1kJAi4hxs7Ry+kahlJXSR8Tq+OxVHVBf929yIjSLr1VVKido/gPaVird1BE235wiYJfVzDmA/18i2/WFcDtA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 08:43:29PM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/3/25 19:01, Frank van der Linden wrote:
> > 
> > The PageHuge() check seems a bit out of place there, if you just
> > removed it altogether you'd get the same results, right? The isolation
> > code will deal with it. But sure, it does potentially avoid doing some
> > unnecessary work.
> 
> commit 4d73ba5fa710fe7d432e0b271e6fecd252aef66e
> Author: Mel Gorman <mgorman@techsingularity.net>
> Date:   Fri Apr 14 15:14:29 2023 +0100
> 
>     mm: page_alloc: skip regions with hugetlbfs pages when allocating 1G pages
>     A bug was reported by Yuanxi Liu where allocating 1G pages at runtime is
>     taking an excessive amount of time for large amounts of memory.  Further
>     testing allocating huge pages that the cost is linear i.e.  if allocating
>     1G pages in batches of 10 then the time to allocate nr_hugepages from
>     10->20->30->etc increases linearly even though 10 pages are allocated at
>     each step.  Profiles indicated that much of the time is spent checking the
>     validity within already existing huge pages and then attempting a
>     migration that fails after isolating the range, draining pages and a whole
>     lot of other useless work.
>     Commit eb14d4eefdc4 ("mm,page_alloc: drop unnecessary checks from
>     pfn_range_valid_contig") removed two checks, one which ignored huge pages
>     for contiguous allocations as huge pages can sometimes migrate.  While
>     there may be value on migrating a 2M page to satisfy a 1G allocation, it's
>     potentially expensive if the 1G allocation fails and it's pointless to try
>     moving a 1G page for a new 1G allocation or scan the tail pages for valid
>     PFNs.
>     Reintroduce the PageHuge check and assume any contiguous region with
>     hugetlbfs pages is unsuitable for a new 1G allocation.
> 

Worth noting that because this check really only applies to gigantic
page *reservation* (not faulting), this isn't necessarily incurred in a
time critical path.  So, maybe i'm biased here, the reliability increase
feels like a win even if the operation can take a very long time under
memory pressure scenarios (which seems like an outliar anyway).

~Gregory

