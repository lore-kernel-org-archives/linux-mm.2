Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F2EC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 21:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2B456B0088; Tue, 11 Aug 2026 17:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03196B008A; Tue, 11 Aug 2026 17:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B18946B0093; Tue, 11 Aug 2026 17:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90F176B0088
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:05:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07902A0E61
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:05:44 +0000 (UTC)
X-FDA: 85090220250.12.C61AF42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5A63140006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:05:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRTp5jGh;
	spf=pass (imf07.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786482343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZSOao2joRqEJx20atrUPtXJqFpwjWr2KvKcNUSXZR8=;
	b=0nOudq5Nub0uLGfYjV/rtZSMlAxIA4SUU9uGoBjGPsigrVlNhNPaSGPDOtgSrHDcyFRsAv
	kyCdzXY9z2koxP9YJSyC18+ZdUvBordVXUGdzUGUshfWEx+30OPrL79J0JBVCnTkkSR3oZ
	B5p17fSlLOAW1YrNIL9N/JhsBLOvHGE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRTp5jGh;
	spf=pass (imf07.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786482343;
	b=dbo8lQwrxo7VpFB5lE/RkoStaPq/pThe6WdZBGOlrNGKT/wNATSHVl2It1d+dRFtzpUTEL
	9gL+ouX3DIn8ct4I1avHElc4exCVqzIuKO4+yWwO6DbvvWerobWenRHCEo97iEPPUrTOmn
	giGrWA/+yCpBptZtd1LUhALnjL6NHAM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1DEC600AE;
	Tue, 11 Aug 2026 21:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF541F000E9;
	Tue, 11 Aug 2026 21:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786482342;
	bh=PZSOao2joRqEJx20atrUPtXJqFpwjWr2KvKcNUSXZR8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dRTp5jGhcZrq3PiQy+mU2PFhEvyD397sOWwAGjACMvNOEFdJOOFreM8hJb67HYvmj
	 n5HW4ngMZxjeSyOCzOHNDuUue4vqyT0jlDR+PHWbmNTdVJXj/l2ROK+XeLuKBOGDA0
	 tvr24D5P793D4lebhFWsnO/kQkThIbvj0DYdjnRYChObpXg43n4p0a1jfpOc3/C/Im
	 2Z2hMLe9GcwvNi3tlaF4Nm2en3gaZA/efCFyU7eZcTJDfKhNwJsGifVxdFFDq/c+qD
	 3VUHRNqnbyQDd7pNMln8npaQQCsbLKSSsY8kSj/3/juPDgdQhWyngfAxR6qSuyEfxs
	 DtAEGUTNBM9Tw==
Date: Tue, 11 Aug 2026 14:03:38 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 2/3] mm: support fallible mempool_alloc_bulk()
Message-ID: <20260811210338.GB1905@sol>
References: <20260806221031.79050-1-ebiggers@kernel.org>
 <20260806221031.79050-3-ebiggers@kernel.org>
 <ann1i5VjTmgChjs7@infradead.org>
 <20260810161404.GA1930@sol>
 <anoIiy0V-m-05yZc@infradead.org>
 <20260810182215.GA270444@google.com>
 <anuCcb-Cma6JOAb0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anuCcb-Cma6JOAb0@infradead.org>
X-Stat-Signature: yhz39oqcxkbzkbu3zpwgfzxsxfn1rhi9
X-Rspamd-Queue-Id: 5A63140006
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786482343-365316
X-HE-Meta: U2FsdGVkX1/O7CXQd3ji8WxSs0/kmVbttWRvea6yW63YTVxSS+BdQtm3j6ygG416IrXBcFe7vrhvRuwbTJxkkzsm/PSQvTi3OwIJBXoVSLh/BJAVv/VhJ2AGSeWdfO32dsa1szFwihz/kc3AI/6+QJMO553/h4cL0mSlkxjfERH897NWOJR8gGWc8XU5LcHXGGm9zR70LfY8wqt5aqluonU3WbmOlccF3fLdkY6+QijWiUfeXkgwF4ZX/KekqQqk9MfY5cCWCe1wCJHoc6qa8SKy1IDtYW5cUylYvcWViHnY9Ds2KGwClOBvFujJLSOP9LYyXjvL9GdtRzgf1YL2GxAzTqv9lXZzK39ZHAwyXyQ1vWFcKztyzuzJSfKAQzEW2g/Q7bofE+zABkQp2cfjD79ERi/P+l2No8rkTT8Ji2cu/Jf/+V6tg1tq5dR8IHK0p3MRmNNymzqdi5//MWK8K80vadp2opr1dQiJJ/s+kH6eLoESLDTgd5S/c4GUzsEkU/XLgtJltGOon5vGcs6bdje9wO++2TJmD2dxCMZF59j29Go1HZYbreq3JQ2DP4Ba6/uwbNHm6XaGB1aQtrsmT3vEu+QlnmBEkhdhkEm71+7W9P//cAoG8RnSYSDx1uIwGuOGFXHd+EHky4Z2BwJYvAfGzAjPk+WCDNhmUk5jVUYhZOvFDHO4gFuh9IsWFqH17L/oMRY7zi0MdG1L8N2yb0GGxxEV+XmwuMXVayBUNdQStYot0kAs2puKsLyYh5yO/v9pjKMRpViwdlqX4DCFnofVr6l0Of7n9Dhql2qLqmzipTHITEdLU8EcEIfjPzt4Cy5qotOSSGgPoctLm0XZUsTQt+EKvHD3VfMBFWDVK+8Vz7LdpYhhywmCA9kHl1RkyQnKAoiRYJhEc0Z0tykvIqbczv7LfAd0yl1xyVs65Ud+soLPP2DyzQNmuhBHxsmPogsgnkC73fCqKV0gIrs
 bx4xoSvF
 yPtsvOCIxBvVS99kmFLF3r1YECFd/3oG1Z/jwKKUY6ZF5rER430NLWjzGgz859ybLTpMG1S5Yk/FjHA6hqhRwsiCNhEmKQ+kIG+61jYoXUpLGAS82VK8ASL4XwXyohqe+JrrtsMsDQXD4nhCSFq7Hm+KX00c47drKaY+ineR0rjkiMx1apXv4gzkh8ydVkTq+bH+2whidYP9kC8IDj0rBTQYA9MEeV41iDPkiYlF3PqxAq/9p2leqg3bTlayfcS9YW5d4b8JOoKax3nr4Fhxz9VSV3pFBBxgViYf0iZc4bETtPmc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 01:13:37PM -0700, Christoph Hellwig wrote:
> What is actually efficient is do skip the mempool entirely from the
> original submission context and do a non-mempool GFP_NOIO allocation,
> and only in the extremely unlikely case that this fails fall back to
> the rescruer thread.

It definitely is *not* more efficient to fall back to a kworker for a
small task (removing elements from a mempool that has them available)
that could just be done synchronously.  Scheduling overhead is a huge
problem for kernel features doing I/O pre or post-processing.  The idea
that scheduling a kworker is lightweight compared to the actual I/O is
quite outdated.

Sure, this case triggers only when the regular allocations fail anyway.
So it shouldn't be a big deal, and I'll send a patch that implements it
the less efficient way that you prefer.  But it's a little unfortunate
that you're not going to allow it to be implemented properly.

- Eric

