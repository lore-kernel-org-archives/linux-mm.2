Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066D4108B8E7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DA606B0088; Fri, 20 Mar 2026 06:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1806B0089; Fri, 20 Mar 2026 06:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C8AD6B008A; Fri, 20 Mar 2026 06:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EB186B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:03:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA9831A0145
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:03:02 +0000 (UTC)
X-FDA: 84566003004.06.7B50D18
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F87D140005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:03:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oUy4Hb5+;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774000981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVJElhSzPSicKKu2s9NgUTcNAotHNyEzrk5YEGoouv8=;
	b=2PEMfXiCm6+bO7JbtMMQF24hF8jgPaAH85NbBzh+wUMJDDW4ujAXiCUilNeSs6JH5XYOWK
	SHKSN9j6gShlhzakTB/q/IJzKElMVZfL/b0vcCN7onDmxH8PvyrkCnm9j833tPckgZyDXF
	o14Hg1hH+jcgobvcDFAehskBsXsJG24=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oUy4Hb5+;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774000981; a=rsa-sha256;
	cv=none;
	b=lHFWlHc1uPuaWyQ5X9EFNc5nsmga1m/H66PLOy/tZsbxc9kt2aP9Phg/mKFmrIWSrDdbhW
	a9xpkFBHnmJHT7Q7JcMTBevuy5hsioKG+FHrhW/gxUKDTaz9ijZ34wfuZABw8GduM9DUN5
	WHYt8CapIqA4MnTd63xJUnwjuA6OCjk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4359E443A9;
	Fri, 20 Mar 2026 10:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F705C4CEF7;
	Fri, 20 Mar 2026 10:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774000980;
	bh=biwiaMzX/KeICnsebZ6pl4sMZMlXYFRAJ83TtXxoqV8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oUy4Hb5+/P8MX/PrlvRLQVq8G2rjpxqY9PXgxaJx8GMWTufvB36jG2M//fkYsl3vw
	 tF2XSVIwtNHSP1rfDrvKvjU8ASrWo9oTvrCOmk69sEm+vSSn9Jfn60GqytYviA3fur
	 E/0/TrwbHZe6gQxqDQWFE99h53YiQYuhap7EQqE+L543eA/Ji9/xC//wZR5heo25Kj
	 HC8J08N1mMcPoiMNpiob9oJXsFSGAiSUJ0byFR+1bZuyUKweQJCl3po0dK12XTfShP
	 0tQnXYuNv+IqS7zZYSPpAVASYn0HPUClCemJ5HevF29fArmGQvk6qT3eVCWGS2U3qR
	 P7hwWo9eP+NDg==
Message-ID: <a68497d7-7541-4587-a9fe-74ca680f820c@kernel.org>
Date: Fri, 20 Mar 2026 11:02:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko
 <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan
 <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Harry Yoo <harry.yoo@oracle.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
 <abwqq28hWXMLqa5P@casper.infradead.org>
 <DH6Z95PTZYVF.3K64RCJC06GEJ@google.com>
 <abxs9k__wWWLL2hb@casper.infradead.org>
 <DH7IJRSKJFFH.36UW4MCZXCYWC@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <DH7IJRSKJFFH.36UW4MCZXCYWC@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1F87D140005
X-Stat-Signature: 1dczxwk4g8i9ks4bqxtboxfuam9cdngt
X-Rspam-User: 
X-HE-Tag: 1774000980-345135
X-HE-Meta: U2FsdGVkX19nomTGvQLdK0x2IY/WIHZYn1uGrodRtui9okcd79zN8PgpbdLX0tW3cWI6Ejf9FtNGSzEyFJ0Mo4kLmoe6Ro5rVBL5LuNEmQ7Nxgz0pkGKkm51Lax5Nva7bY27nHXCxECAUBX83aF4X17xOwUsHHN9HxIi7CwuieQBPUtZ+5vbJsjmrOA8V7rWB/H0MZpYuhLCgggWAVu50i0dKrxQNtR9gZ9sqGrE7M4FWmShpu0TA5lCYdpUdRLl9FTcnJntMQxhlT7tl9ZLRZIjyEsO3s6KRk4PUsAQQ4RLXFT65ruEPUWfReEH49E4TEuVKRzKyoEnuSghIU/2q6Y2bDaLFTNxKDMxjuR3YXpWk2YTnOZO51yzfTUoFSJoiymD6D3AiJlLpfru+9meQyE1E5uVXXdg6LEUc1X68fiwMdSH+3l1OQw9hnJf1BoyGVx8qcvX1muLpKYmRFKCe/b0lw75LpP5Oq1VHgOFWR/bHSCCa2JQHLjLdquzJ5vEpTkAS7rCxweUnkih8E8BzUlurOunAF2nimZxnKs84Z8NJXFuoJBfgLlLVby0I0nQJbes0FS600QZgS1QGx3x0zEjwUOBTJMPKBz6stUaB0SBYm9c7Ihxfs75cIWGaMfpsIqj0K8BCtip3B6PxovUkjs6mQE5jH1GGvwneRvwYgl1FJQGBRK9IplZJ3sdicHtLUHFbtFU6bnmQcSxUSWCXqviQxoua1L9pMM8vvur2x6PSkY4Pm0THPtOWr8c1GV8T4cJyccfByVDm509rYvvW//CaWQVoMRefb7C7TCpPctsD0XI9VVycougzds5ERXL+Soz6HGBjoB3pmn5rIOsusYvEBkBJnrStUscZ54VyBr4qXo4/xK28J5wHs721TpI6gzmvi/W6Is7qQjaXuB0u2t+W9SzC5SM76CKoS/7J36cZYQBBuhTFlT1h01oH6mDSLTTgyvvjE8rqOUdu4Q
 aLtLUggg
 Qu1Nrr6/8UP4Oow30vxeU8ziefLx5nVcExdXD3nJpTylQtOgJ0JabjmZETGOiRK8ckNYvRCPQeINc7l4ooA3NuuwVF1+waxTpjhNtRmkOmlnBEdtLuOXrMzqBdZmybV62hJ5SOLyBWkTkB0SJZKiyEWoVOQtXvj47qjoE384aP1Z6QCa4b9MTKNOhuLYZa55XupqbxiaO/LCmlp5AsOmv46ncgBwhYNZ3h9pTrSbGpqK0qKYKWSoHFMJ9pwnlpZYmR1s79zNd8JCavPl541iwrCXtD+EHU/HNumJfCJNm6ZQqdydR9oPAzSUYrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 10:48, Brendan Jackman wrote:
> On Thu Mar 19, 2026 at 9:39 PM UTC, Matthew Wilcox wrote:
>> On Thu, Mar 19, 2026 at 06:40:59PM +0000, Brendan Jackman wrote:
>>> I will paste the diff at the bottom. I _think_ all the problematic
>>> expansions are downstream of struct xarray, but it's quite likely my
>>> sense for problematic struct expansions is weak.
>>
>> Urgh, no, it's not all xarray.  There's one in address_space which we're
>> trying to shrink, not grow.  
> 
> Oh sorry I just assumed that one was xa_flags.
> 
>> There's one in struct sock too.
> 
> Huh, I suspect I am embarassing myself with this question, but why are
> we sensitive to the size of struct sock? It's currently 784 bytes in my
> build. Are the adjacent fields very hot, and we need to look up the GFP
> flags from hot paths?
> 
>> I don't think this idea is worth it.  There are other projects of greater
>> or lesser churniess which will give us some flags back.  For example,
>> we could finish the GFP_NOFS and GFP_NOIO removal.  We could finish the
>> radix_tree -> XArray removal and get back three bits.  That's five bits
>> without even starting new projects, just finishing old ones.
> 
> Anyway, this also makes sense. But, Vlastimil, I guess you had an
> ulterior motive for this suggestion?

Partially. After seeing various issues with kmalloc_nolock() relying on lack
of __GFP_KSWAPD_RECLAIM to indicate the nolock, it would be great to just
add another gfp flag for it, but with only few left, I didn't dare.

But I'll admit it wasn't well thought idea out wrt consequences. Sorry that
nobody shot it down before you actually tried to implement it.

