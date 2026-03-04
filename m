Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5533DEB7ED0
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 11:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965B06B0088; Wed,  4 Mar 2026 06:54:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912676B0089; Wed,  4 Mar 2026 06:54:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849006B008A; Wed,  4 Mar 2026 06:54:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 765AD6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:54:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E6D313B2B0
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:54:09 +0000 (UTC)
X-FDA: 84508222218.15.6F8F7DD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6FC7A1C0002
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:54:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="UtNhpP9/"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772625247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XyeYmlSBVFh6Us1p6vuGnch71Qpsd6kwji2Os7MZ4r4=;
	b=M04/8eqW08Zfg93TbSs3wrWbkztBLVcoA039MSN12hIJye+MR2IyQJSBdniVCBGaPkh+RK
	/4gNzAgvbzRyP6N5bG5VUnKik1JINEutug+7s1vTEbkz+bJSZHAmv5Djza9SITlD82ONa/
	8JTn/ewQSNkEbrHeishE1NK488V2sj0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="UtNhpP9/";
	spf=none (imf21.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772625247; a=rsa-sha256;
	cv=none;
	b=iiVwbQelmaHQCkJHSa1z/+iOvGRC1FIx4ViVc7NBUcDVEMOoN9h1xnB6kz/tcWrRVSToOV
	n02KJ4XaZq5t7+xEmZwqWUSk56BPrli6Bq69/1557lXttOvKTw2PEVCCX1eVDLJJYnqmPg
	hpuCGTZf3vYfaDlBCKZrGlHZjRzbzP4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XyeYmlSBVFh6Us1p6vuGnch71Qpsd6kwji2Os7MZ4r4=; b=UtNhpP9/VGOjDVBNnLguF8mXmF
	dqlOnAI+BDMUKohF5M7VZoFeX66BZWvHAxqMBLbmSs0lF+64BWbDHcmZQBMITSReRiQJQD+7WkczJ
	ztlizWWhiUBakPXl4ItoHOO5PNZUlNj4H3LVQmuMt1Wg7Ee5Nj1Z9oBrXMmW5aD2C1F2FMFFMX6j5
	5hx+ykQulwgmcp2+c29bPWOSPpxyaD9Ru3rSMq7Wkv+E6o2/P9Gad1yzfTa91Qbgj206uaYxTqjDX
	ACS9Cr2Eei+Q37aJlJSR44ZOcEyA60OKXLolZWMQwiHtxYqBVh4WT45fiBZVay/NI4yyPp2Xu4YuK
	dpbFo2Lw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vxknO-00Fw0L-0O; Wed, 04 Mar 2026 11:53:42 +0000
Date: Wed, 4 Mar 2026 03:53:31 -0800
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kernel-team@meta.com
Subject: Re: [PATCH 0/2] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
Message-ID: <aagcZuis17x96L7e@gmail.com>
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
 <aagSrIwiFM7GaL1m@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aagSrIwiFM7GaL1m@thinkstation>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 6FC7A1C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: 9re5doadon9dw514feu3xzgycajd9eob
X-Rspam-User: 
X-HE-Tag: 1772625247-585807
X-HE-Meta: U2FsdGVkX1/SJX6I9/JseZYplFaMNs0CJCGXM1jQUkwKtk+AlsKA29JBn3l3NjrLM8PVMC4I4nom0qRCrMosV7RexgI5+TY9HmAZBdcA8HIyE6ZO7yT7ecZ0h7RPIW9uLcgJ4sqfy6kf8C0YRd3IdHkRUX6MN5J9ZOfRgtShlwDzwIwSBVvpmtpuWLtOsfOz9yYmOMioLWnjv0PwGQr6crpf+uYvmGQCnDrDYFl0wZQVZ1AlVjJ5CUeNH92BwNR9kgrJlZc9+mNT999qYUGvXPRJfwE6Xcz775BZkjhRWkpyphUZmyI7JcGUq2yfbVBEnBej7HcMKNelSCP5nqIEnzmxHuFRjbJcODdnP38qT9Y+0v2I2EORM/ClQN2YWB8mbP0mge7x9eMS5av55BHJDZotSxeLjcrufpTn0IMUthL1aYRUGiUzggiahr8DRliQOiS9aqa/5rzxcovrwdGf7xUIbiIcACSKd7dsbzeInQM21pV4k7eQLuDW1qJ3XXKmmFSZaFiPgJAfbljNzgd+VLpeZk6I0ShLt8U7393DTMlGCe9cB7uzx8ggHBWMTo82nN3gcyM1v3EUYOhvbYtjNegq+qQVF6/YtEifV413bm+78nxqNC4VBSvDy3IVauEFvQBlPptb37StpwnN5w2Wq8eRvJsKsXB6hdwHr2AfE628moIS2FVSDEeGonIkhebfF51ZljKCss6sQ8Shn4SiqxzGrKlM4m4AXECWp6LawLCsyNuBJZSxlxprxHkRXmHIzJRgoAuEC6lk30ufmuIXutvYH9WMToW3bS6hMIV1D6lsHEJpTIpSqSTr6zNfYuq+Ow466b9yX8FmETFpDMjF9N821mduVpq/b61lmYquWTAXhv2w2maZfAD7DfQnYKeOfUQ2w0I0vb8VFEO5PXRrWpmaqpLfWdM3jAy90ctUf43umDfOhWTc9Z/hAA2hoMlteda9qBaEjafXh3ERaDR
 ct5GdCix
 VxBlBFy/S7Jm9qTSWHfOrkLPYQSTmYhqStX9g+XCYfS2zk88vYCwjxYSmkJpeoHgc/Qa6Inayus3aiVJEpLdl2Wpx8CV6v0qdYVQy0D/hbmGo2pnKFceNkpBfgYh18EbXqVw343d+UKB6vWgTJvQGh8NIPyDUUuLgm8nIfh6YXUHKZLsNSp1OmZxIQA/recxoXc1n+99HluuiJjHuKTfDfEdF+pop5IBkCVITwzZa+21CHVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Kiryl,

On Wed, Mar 04, 2026 at 11:18:37AM +0000, Kiryl Shutsemau wrote:
> On Wed, Mar 04, 2026 at 02:22:32AM -0800, Breno Leitao wrote:
> > Breno Leitao (2):
> >       mm: thp: avoid calling start_stop_khugepaged() in anon_enabled_store()
> >       mm: thp: avoid calling start_stop_khugepaged() in enabled_store()
>
> I think the same can be achieved cleaner from within start_stop_khugepaged().

Thanks for the review.

I considered this approach as well. From my limited experience, the preference
is to return early in the _store() callbacks when the operation is a no-op,
rather than pushing that logic deeper into nested code.

Handling it at the _store() level results in more changes overall, but it is
arguably more straightforward to reason about (!?).

That said, I am no MM subsystem expert, and I am happy to go either way.

--breno

