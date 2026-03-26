Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8259410A62CA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 13:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF7286B0005; Thu, 26 Mar 2026 09:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7D06B008C; Thu, 26 Mar 2026 09:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABDB16B0092; Thu, 26 Mar 2026 09:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5476B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:22:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4230A160B50
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:22:06 +0000 (UTC)
X-FDA: 84588277452.12.8184D21
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf27.hostedemail.com (Postfix) with ESMTP id E73D940015
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:22:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h0EIdrTA;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774531324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7kEkchvazcsGs35ThyHSvMh3kjT1N0Pp0rpILZyG9Y4=;
	b=W00m2DFA3oecZG6gEwW7u4q+G4G2+1+SBAanx/fjunr3hKwtCg4f5N/U1eWlKWfc5xIIZ5
	YM6RRU9xs3YXvRoy6c2wRNiY5nbgsKyWf/TqsaTLpopVRSbJj/0qgsL3//hBl9tqfOPTvW
	vh+L8X2Wmj08bHVUJvSyeS/z96myo98=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h0EIdrTA;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774531324; a=rsa-sha256;
	cv=none;
	b=45NPgwA2xhZKyLzZZMdxs7ksF29UcYSONHONpOGOA3HHyH4n4D+AaC/sG6/SPXQd3Wevkf
	GDTQVQVfeCLOZn9tR3Zbb0FMnDWC9cz1dvRYSzkKeuH99g70Ep0xYcNvFgFjBLWdOBemOd
	TfG4uJD6RgfBrL+MCaiGuHf3FC/gNBY=
Date: Thu, 26 Mar 2026 06:21:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774531321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7kEkchvazcsGs35ThyHSvMh3kjT1N0Pp0rpILZyG9Y4=;
	b=h0EIdrTAKnJzT+1v/qT86u21TaY0qsvEnymktOBVOaDiDhSyEVXlTGEmWqT+decQ/iKCA7
	By+oFvK6smxPXJP02S0+FzFJlfBB0mt0a+q4VXFFGtWGPEUgoTfFU/A8PtvMfJLSKPoE2V
	c7rpnN3LB71UlPV/WY/WNdwuiOwzO0o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lsf-pc@lists.linux-foundation.org, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Chen Ridong <chenridong@huaweicloud.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Kairui Song <ryncsn@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>, 
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>, 
	Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>, 
	"T . J . Mercier" <tjmercier@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Suren Baghdasaryan <surenb@google.com>, Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <acUxJpJDzA7Bibob@linux.dev>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 7e9oihuhxboeu5xw93kebuqpyoqqdj39
X-Rspamd-Queue-Id: E73D940015
X-Rspamd-Server: rspam09
X-HE-Tag: 1774531323-772853
X-HE-Meta: U2FsdGVkX18weOmUcCDX78wl4VdTwhe73CKHaseQhf1pjjrvWvMDIlm2Ba2vWJ5fuWbxRMkcJ/hbnEWRg96HjLEsz+EVAjB/7Vb3vwKZzaoYyx1R/aEW82eqmpZd3IfnoW1Hq1ztHLA6vw2vg/qeF5QNCE8fCdQN2fmAva2fCDuRb6yszejUWZuuP+DOPQ21X53u0MUqkgUo3iCEgCrzZs42LhPoFphgvoCNavWBhIhOOJ85bUQpNtseOzuPuOXBJ+3jLjxrcIEF4DyEj1gM8O7DIls7JdY32vimudujfeb4fS1+EK8rtHQb7YaQOZhpiLnc6/MkOFQt3TJY8Xsdoh8xmhiR6hnAOwbUnZcqJH9vTx/z44CJ3lrN9C4isT+Vf37U4t6aRdF/WBKaVvmYrfVSRxKZq1fuM1KIdGEWprMqw4ERpzYWzmJytIMG77HFn77GNun+3jeLxhX/uNWEZ+TZ7/BZ7+DBCelS3pv5gkYBahDulM2Rvts5vUoXO/ZrkJvIT/WO8AotUHyTRMA3YIY82medNdiAUpvvDS7VzOsFCPlwdCMMz5dJKyuYZnT7yIm2PcDUHrVqAsfoXU96jWLKMiiupDevembZ7tSi9ueLts9pQf8Vc3ObNhtc/jVRZ/2bQ4NJlMSQxVpgFFoY0ZeAsRuwZO7rHyIipxlVoEg2f15qGOpX9XOkcgtVnvL+nI7pMEDPnScZb4ls86az46piVLIs9GtWLYkr5uZv7JaHqvANvBSMr1s6TsFzkzbNS6nJpNeKW3JD/xuNK47wtb/jqHwTvQ3Ya8eHkSYemaUDg7dKsIvbs/5r02u0tE6bOE11wSsH+2rWWBjxRfY4WhNdgc6+Cw0W94OOG/O5SJX0wkZhfxnaRg+zmDVytAGRh9Ymw8Bbba2MP0DHcZMTZ1m2rZpBLpusF/aIXLR8NyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 07:05:47PM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > We should unify both algorithms into a single code path. 
> 
> I'm here to ask the questions which others fear will sound dumb.
> 
> Is it indeed the plan to maintain both implementations?  

I think in general the plan/wish was to have one implementation but the current
state shows that we are far from where we wish to be.

> I thought the
> long-term ambition was to knock MGLRU into shape and to drop the legacy LRU?

That might be the ambition but I don't think there was an agreement and there
weren't any efforts to do so. Traditional LRU has been battle tested for decades
and thus there were concerns/skepticisms about this ambition as well.

To me, the right way is to take step-by-step approach with clear evaluations and
comparison on unifying or selecting a component from one over the other.

