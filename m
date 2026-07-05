Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED7BAC43602
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 08:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E5B76B00A0; Sun,  5 Jul 2026 04:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C30F6B00A1; Sun,  5 Jul 2026 04:40:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FAD76B00A2; Sun,  5 Jul 2026 04:40:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6075B6B00A0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 04:40:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC2BB120662
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:40:00 +0000 (UTC)
X-FDA: 84954075360.04.FA76477
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C5A5D100002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:39:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pTEETO77;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783240799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YFdQjwdHm8s+vHN/5MHawb3/x/oHy6pumzw7hVOvzHg=;
	b=ahnTtezAlVp4DNqIueffY0qTwzPFvWLOrtD76ZwQPTIguNzJ5MaZRET174SRtg4xG9vVwb
	ffySGa+rAIRJdXbEpDIae5DMEM2Jx0jq9zChhga1O0xDLEglKuydpTyNNaRtYD/MCzu32D
	cbg0RR9N513R0ysUuqAbMgLo81q5YdQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pTEETO77;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783240799;
	b=HhDoAvaE/or7GBjf9Rx0tpburY3cmpFq0coDTA25aWbNNOOcCI7VrLxD4o6AolBylVHOgP
	4575mMSaMaSDp9YySU/Ko5E6OvyDKjOQSAcjAjNvCFtZYDddugyD83E5IzjegSVQXR7IzF
	/NgX7NGpJe49vek5Ba8kFhhtMSfo3Sw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B03F441B41;
	Sun,  5 Jul 2026 08:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C981F000E9;
	Sun,  5 Jul 2026 08:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783240797;
	bh=YFdQjwdHm8s+vHN/5MHawb3/x/oHy6pumzw7hVOvzHg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pTEETO77aHcDFsjbd4iTtSYUfUth2BiGf8su0ImDVfmrn8KQnSQaH2CQywMLI9xun
	 16o+SZpaD6rjwVLFpN4P3ebQoVIVqtcRO0GDs5wWKhgc2p6fQOC7oQC6ChavHrZ9CH
	 GGeo7d9SP40VOLPuVttlb+UU01s5BeA4YNC1h/N8=
Date: Sun, 5 Jul 2026 01:39:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)"
 <david@kernel.org>, Gregory Price <gourry@gourry.net>, Zi Yan
 <ziy@nvidia.com>, Pankaj Gupta <pankaj.gupta@amd.com>, Jason Wang
 <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio
 =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexander
 Duyck <alexander.h.duyck@linux.intel.com>, virtualization@lists.linux.dev,
 linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: page_reporting: allow driver to set batch
 capacity
Message-Id: <20260705013956.36f649b5cb13409d9088838a@linux-foundation.org>
In-Reply-To: <20260705042313-mutt-send-email-mst@kernel.org>
References: <444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com>
	<20260705011635.9974cac7f0defec9961e85c4@linux-foundation.org>
	<20260705042313-mutt-send-email-mst@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C5A5D100002
X-Stat-Signature: ob96btiaz6nw5mc1b59349tcjumbmrc4
X-Rspam-User: 
X-HE-Tag: 1783240798-675653
X-HE-Meta: U2FsdGVkX18Mi1iFiqLVIOARV4njO5k1Lsm69UG4v2YSznhMum7JDnQxxXeB+Q3IVxOm0mu/5Tfz8HeOH4cf3WIgH/rItFGkJe6Sgvw+VD7KG623C2DhzobxeGTgXAm7U65CLXZfa7cU6vs1H9WwYzhf9YLv+DZSYncI8phM2l3eqdNyDuFwaCnNOvrdspwx2qS4QkH5f81MuepIAapBpp7ne1gKYYy7wUa8ZUbQkZh/SB/5E2JV+iRh45KEnsur6rXntIToko9HCKXPr/6sYEKdLlWY3yb7emJKomoWgOP6pGYKusR1u/pcbUMlFfJyckJxH1YNTxs6Jq4UWJ7Jpi1legl3LKkTZbK1yETOJKNgPBRkvZ+XhRJj8Wc3OAPLkFy1+rqrmmColJwkxDk6SM7gD3f4k+GyAnImqS0M+xc/BPb1RN0u4u0F16NdvPx4K0W3TgZhnt/uzQasnpwIF7YVL2uaN/58mL6W0TLlMaJ1qcm+WvMHOPgzMJkZVSxkyE0+6bYjndbAKL8VTsUEffg8fZR3UMk3btyIKc38CYDU07sE+qWJVwwFCBnuGCcJk5kQm5zz+NDMnApXgM3E7bOWxCOFfdITFOuSyrJDlD+glUhDCcbFs+ocl99mSbsEHpkb1KVWEQs9tg9wk7A0pNvvuAUCU2bw2eD0pFlOIMwYqAfae/QMMgpwa/eI9jTHiW8yhrC2TUZeJhTYSjnJ5gJcbpJ+xL+98LQR0gKkCY96OWd0W/WH/3zFAOcGs711QZQQeK/L4nflsjDMzHVwNYCt1NJhKD3W4DWoZvBDAovYvfxOVLpWNPH7J84SG9GGVm1UtLeWL523L9HcHPG8HiMMWcbLc6xiSa4Pi5rAg0HwzMYYrmgI7h3P0RzesZWvALpD5mJjRqmn8SSRFlEnCYOVfF7Cj27s/Ho+2LSu9YrvLxjby+yHiuhjgEo33fgLmS+zJXbwqBuir19+F6v
 PkbNYISs
 B7u1nCblZbnf4t8aBNbPn4OCeJ8yhtk2rTx/uFgj7+ZdF9U467e/jNnYOGmeovFpGs2rqeuIEKmJX99s++fXacDcMzh4I656Np1Qtepc/YIn3KFBGhP4bjXcJCMCeshswmXXAfM2/9V9ym2c5lK6h2hdhKgrKl+LPkhlkLZHm0tkX1mR4gszWw8+NNfpno5IXiN2V+LENWm6c/fxPsV53dObUW60VF+eFBVmDWtXgXnjCa3CSEDSpj/bhSbnPbgMPaGf9yTI1L4STAFmpFy9e0nICkLiGQWgyP+cf95KdGdpQtZdT8BYJZYz+MKIa289L+wv3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 5 Jul 2026 04:25:53 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:

> > > If capacity is 0 or exceeds PAGE_REPORTING_CAPACITY, it defaults
> > > to PAGE_REPORTING_CAPACITY.  The 0 check and the clamping is done in
> > > page_reporting_register(), before the reporting work is scheduled,
> > > so we never get division by 0.
> > 
> > Thanks.  What's the priority here?  Should we fix 7.2?  Earlier?
> 
> If possible, I'd like it in 7.2, have a setup like this (small
> queue is useful for perf testing).
> It's very early in the cycle and the code seems straight forward...
> I judge the chances of breaking anything is tiny because
> it just failed probe previously.

No probs, I moved this to the the mm-hotfixes-unstable queue.  No cc:stable.

