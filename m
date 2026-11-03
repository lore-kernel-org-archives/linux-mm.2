Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60273606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CtNTYGWH
Received: by kanga.kvack.org (Postfix)
	id 802236B05B4; Tue,  3 Nov 2026 11:50:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3236B05B6; Tue,  3 Nov 2026 11:50:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A22D6B05B8; Tue,  3 Nov 2026 11:50:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 469A96B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:50:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1011A04BF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:50:56 +0000 (UTC)
X-FDA: 85394397312.30.192ACC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 206C920003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:50:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CtNTYGWH;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793724655;
	b=U/GDGHM8Un6ER07rtNCIcK8jYhbLhr5T858uBMDhts3sbBI7LvFbS1DdP2zv8ANX7JlNLn
	QkE6a/6kfgiQN5LvXF4urVhNgIjuWc3l8sCMl4Ic1lLRJg+u/qqEvphOdohWeLEmd42kNx
	G8RUpRFBqpkIH7pnBQErhifdDTKLqs4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CtNTYGWH;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793724655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtsuxpFaru5bCJVGsaTDOqLmkcEo7AgKuEWc5zgUH/c=;
	b=WBHwTdH811KfNyHqJWHhzggaI4YP4tnqC6Ivly+cqv7F3faSXSKO8DnX3YdTuOBUMfehmV
	hEghCDsDl1q1SiD3iTLaoX5pi1L8r5axjMypUSxSF6pNpN3Mh0oDW5RXkYt6SQm0nlflql
	kHVN27hcNATqlR5QOzOb6TzA6DHH3I4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A017B609F9;
	Tue,  3 Nov 2026 16:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345BB1F0093A;
	Tue,  3 Nov 2026 16:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793724654;
	bh=EtsuxpFaru5bCJVGsaTDOqLmkcEo7AgKuEWc5zgUH/c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CtNTYGWHPzRk14MitXVi1MzDjUGP5Rm6vsULElGy6l1XszG9eoY0hvO0ia8qJ+ERk
	 hSoD0pQy+xuQeJvsDmlwJYaaot8dr1g69hDk/GtieK9SrkIuy6KbRU66IWza+63otD
	 lURNrr8tHaShaZCvhubnoBBJG65sTdXacUiePyf+KTLieywfDCUNw3Rkkrx0HgYWz1
	 /DQmm+heyD/iiwWLhBiilBhitBm3zwfIfW0lXVd7fG+qFMw98S/CTHPmLEgNPibZTA
	 Y5xal+/1KVYPL3unucuzubdyh6mvUQYJnXW+CnYS+CbIFUsH76brKuClXLSPxtynvK
	 t849VHMquTSsg==
Message-ID: <bf910739-a85e-44aa-9f13-481e5b6c3336@kernel.org>
Date: Tue, 3 Nov 2026 17:50:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/mempolicy: recompute automatic interleave weights
 on memory hotplug
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ziy@nvidia.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, ying.huang@linux.alibaba.com, harry@kernel.org,
 stable@vger.kernel.org
References: <20261030161234.1505367-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261030161234.1505367-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 206C920003
X-Stat-Signature: srh7qfqgtwhz1c1oct43bj48ss9eci7d
X-Rspam-User: 
X-HE-Tag: 1793724654-223364
X-HE-Meta: U2FsdGVkX1+KSlboIbDezwhuB0SLMQYZHjggjj7INJpEZVFlI9pXyoRE7xx+8dOwGYwxz0dNgBlpO1qwXi7xJNJgynJ8wgC1CQgDvKYFuW7Vl3EQZ4qCsLL7P7fB3XmajG1N1/WsrG8LX9WTOOHcseJ4TFq2Q1KPWHIQQtVaCZNQCrZ9oh45wG2/Nrb4UAe/q/B0LCvqKqWphPHV2Z5zggdZ6J8vC3B0E8dyNQhp8EqZ2U6mGSCP61eUUuWn05Rng4l0TMLCJRYhpwL674q6r68frvDwy4MTfe0joaYE36WfEYFG/pVsel/omtdXGnttU5dHJu/BKy7Ddw+107ZRv2aonS+bZgwmIF7+Y7RZpJPhfjuIu1JMh0OqmvMmGkUBfVxqewZ8nvl9ZuEaHu3zeDhuyWo8cGCm585GSkm7GK8NrYUfc2VFAbbjA/pmG6WCREjr/FEMbU8X8bHAl0vJYdB2yhbbRY3zAKvXyqP9a3mchp6SoDwvwaMRj0ND4hqUXNfl7NRRzjCDHeHRkSuzto7icUD/SWkVS1sJ6fI8C5wx37a5CQkp7m2+KN5vqRdyaPx7G9F6TTsDjlt0qqrc6077gJUkcJVunGfsd8+GYfEuE+MaXBfV8THFEGOWg06WO0is+cvK3c1KfH/PHaaNdAxZuflW87/BlUvLcW+o2v/+p6IJja9qAMnWoQTdhGI3KF2FzNugYLuZvYqssjTttjujIZTP6XgZ0lQum7ndsOZrWL4BMjwiUyc7xy7UKymR4B8S4LIoHtU165r2C7EPKND7FthHA+SUp4uZJwcrw6tF1xKgdQsU/ytS3FulIjlQ8m1ztEXSvK3xXlF9/IvGXsDhvV0HL3XeNVFkRDtqOX9ogrEM90SCdDTEyL0bFg9Z5JczGeqpDWbz+Pd49PMlCBFQd4KRvJqoDnqcKN33onmuqxcoFI59Rt60r7/TnlfPYtNz4gFd9oN9MaS4tJF
 VJT9T4xT
 AaLv+7J0HnBmvdEvkH9eLb4+d3cZAzZSApSWQB430MhrO76V2p9Me0DidtgEXHyOOgIrUpuVQ7EsCbT+nlp1+cCe6azddTeJk35j/vhkxWljs7wdSdP0Pojpqns+8/x8qiYxA4aPO3NxXtaRDq1bhwdvfrcMIqMK0u+pYwsbJ3LeaETED8nBuNKMQ6rvgKJgFvPwqnFpdpebwnWnmtOPXJzMwdLLaM5itunRv60CIXOadKKvvIZXWFCkOrjlKMP1jV8Eh5bnSR/hzfeLa+ULLblXFGnCpx8WELWjfgL8EtG8LWhknyxVKWaBMbnKLxH6vB7JkC1ZbM+Ork/TQqfjQSVgyBQErTG2SbHUmZUxqFJag95yqd3yFpaoDVLNeatftvVPNlksvv5Qll6Zj6atqVcE8InQF5FxvhTCa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 17:12, Gregory Price (Meta) wrote:
> In auto mode, weighted interleave derives each node's weight from its
> bandwidth, reduced over the nodes in N_MEMORY. HMAT and CXL report a
> node's bandwidth once, when the node first gains memory, and nothing
> else on the hotplug path recomputes the weights.
> 
> This can result in a major skew in distribution and overload tiers
> with more data than their respective bandwidth can support, resulting
> in a performance regression.
> 
> With HMAT bandwidths of 100G for nodes 0-3, and 50G and 25G for kmem
> nodes 4 and 5, weighted_interleave/nodeN reads:
> 
>   event             node 0-3   node 4   node 5
>   node 4 online         7         3        -
>   node 4 removed        7         -        -
>   node 5 online         7         -        1
>   node 4 back           7         1        1
>   Expected:             6         3        1
> 
> Toggling auto off and on generates the correct result, but we should
> detect this and fix it during hotplug. Recompute the weights from the
> recorded bandwidth whenever a node gains/loses its first/last memory.
> 
> The notifier cannot fail the hotplug, which has already happened, so
> warn once if the new weights cannot be allocated. The next recompute
> starts from the full bandwidth table and corrects them.
> 
> mempolicy_set_node_perf() now only records the bandwidth and calls the
> same helper, so the bandwidth is kept even if allocating the new weights
> fails. wi_state_lock is dropped between the two steps, which should be
> safe because racing writer simply causes it to run with newer state.
> 
> Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---

It's a good idea to spell out what changed (and why) to make review easier ;)

@Andrew I can pick this for the next merge window, or do you want to merge this
through your tree?


-- 
Cheers,

David

