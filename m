Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5916CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 08:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F936B0088; Fri, 29 May 2026 04:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30476B008A; Fri, 29 May 2026 04:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B47006B008C; Fri, 29 May 2026 04:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A35986B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 04:02:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36AA5120D6B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:02 +0000 (UTC)
X-FDA: 84819714084.05.D0CCCDD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 80BB718000C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:02:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z9jlv3FS;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780041720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cAaDqI2zr/NsZh7zrThKMK+Xc1VkxdGSSOf6qqTnqvQ=;
	b=Cdx70433l2tb11GQQJaFxz6Ygy5X3Lo3bPHZcKWNwt+x4LV9CAaWROMdA7wXMx4Q59ccqv
	5ZDdFfuKzc5lRQ0i1rlX/0Nq+Un7xR96XRTKXuSvSM6LeACJZCspB9Q5LltoR6xaTPp9rq
	+a5RWxsHMBN9tEnf+NhYGbN0Ohb0oPs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z9jlv3FS;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780041720; a=rsa-sha256;
	cv=none;
	b=CJdpV/sW+XWgp3bF1SgIxriElKTSCDurZ6Tks4fZxaGyufwdpSRc5XxUx3QxFy2fNkla4y
	JLyKEw14cqupHpyVtD30+gQOGBsQ9MTLYNwWy9KgaW7DKtRq7vt4SszYW3fW3aadCffjFs
	y4mEQ/T+TV87uk4vgQvSfdmr7olWc7w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB59C60564;
	Fri, 29 May 2026 08:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B981F00893;
	Fri, 29 May 2026 08:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780041719;
	bh=cAaDqI2zr/NsZh7zrThKMK+Xc1VkxdGSSOf6qqTnqvQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z9jlv3FSkLeCraf2nT/sJcuupNZ8Q+vdrtqMJXWjz6ymQKi0TRqvhqgPwvjsRbg81
	 vW8/893uGdOQ/Qmmzvbval3v5yv7xBxzO6BbLsBJTpZhJ4uMFnKlaisFDBkbntKkp1
	 IXzDV4/1ptDPMzs0DzPry3D1ofjUdp+LxkrfIrDkqw+kr0vuzQs2TxIcMW75NBL+it
	 640xyQRPcvdCaomc5Suwi0eVgAE670rHB9/FiA6Loa8lk1kkMAZheMb3eTF8q4Ja+T
	 xwCnUALvuH78hgM74QQp34m8WTEi0sDNVUhBoC/7xzH80PXo6aJ2p4vhqoaUiB3g30
	 uZ/IzXmCMKUYQ==
Message-ID: <007d77f9-f189-47ac-b19f-0a2c19d99274@kernel.org>
Date: Fri, 29 May 2026 10:01:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] mm/slub: batch partial slab list operations
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, harry@kernel.org, akpm@linux-foundation.org
Cc: cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260529035120.81304-1-hao.li@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260529035120.81304-1-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80BB718000C
X-Stat-Signature: 4meuwzgwaidq3hgj88bi8d4q8o5fc8zy
X-HE-Tag: 1780041720-800175
X-HE-Meta: U2FsdGVkX1/+7Z08xKTznDc1klvugz/tW+A5wXWwMw7hwZzndjBidQ03sEuq/pr0cqolYANjew6cyWPIIMLD15Y+wU1mXekwYfJ/0k7LAK3EdsjcyRW1xjCgX/BfRnpJvwSBK2ZxAz75U7aV/hXOcScvA0TPGSA31jTdbiQaoXr2H2RoTYga/vszKE1eOjRoMsHFOy0CEeBj+AVKXQ8gtG30HmthTAeR20DiDQTMWyzlc+U1GmXVbekP/cnPix+4gSgNf/aZ4uEGrCRZvOHyl7XX1BvNq3OeLEyiqQWjQ02A6UHw32TxLBlhNJ0mRErELb27gimOjrerrKSBDnOM19kieJuAH4i4L5+KeH9/CuPhHuvCPEdufwG0CmEcx2uNv/kb6PPSEU6N8vPl8nevTOxv5T9ShexD083A2s5nypMxzQU7jz6otcum4K9AsP9fRqzChhEZOz7BFlKH7wo5cFtwAdOb1wIYaSCOx4j8AF9yhA69Xty7/OPgqNj5jNvqGLi4pa6xJGcqBYKNUEuehM2EPq1eq9RT/USb3d5PanE4DAwl8Laj6PtQs6VR7V12Vnp3Dfh92flTtLFORPFHeDn7LZChJIQSp8CugMMJE7BpD92BQ7Qe2ELiI6H+Eo5+d/ZjHq4wFjfkNK5HBwvhnX7DBEvjbwgcIvpuBokREso0B8lNP2yKoe9lkdtKfWpqkdK3Gg8AQ9mfigaNxkXRL6bq6YmofKesRdK95gcmS+eY1DgNRvGDsojNEteNf9inoY/Ko3MEwGqSGuML6rkxN0wo81tBctmYItk4jEQgmHFJlMcNZO/XZPiPwSzBqhanItK+uoBmIu7/fS3nm1tavQTeaipvjQ2BTOOfoMsoT1ds2aCbD7a/eiw2cJOSoKeL23U9DpX6gTL1wCkAWoZzgWYX7kKuju4STj1s9xIOOlhrSCfy0s1EroiixF17Da1FKtPhF+lohDWah6kbopU
 ho34iUBs
 +2dJB/FqrPeTSWa5vsMd1scESpuIkZUDfj81kxGY9po8i3h/zQm51sjgK8EStZ9GZMWEzEpdBJVWJx50vWMw/07EayOa+jBA8n3hyI4+Q8718smp1oqmO5hAawI82LGOpdVGMdZQp41R8Exf8ufyHqWK63uy856m4iyAykb+XYN28Q9+1KVwO/aqqwIOPHNfzWUhjnymSJuW0M3Hb2WNpMifYC+QEGv5EIi4MyevQFf2rrKxm3FNqQ61S0KN23ILxBThq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/29/26 05:50, Hao Li wrote:
> The loops in get_partial_node_bulk() and __refill_objects_node() perform
> individual list operations for each slab. This patchset optimize this.
> 
> Patch 1 is a cleanup patch that wraps duplicated code into helper
> functions.
> 
> Patch 2 reduces the number of list operations by processing slabs in
> batches, thereby minimizing the time spent inside the critical section.
> 
> Changes in v3:
> - Reorder the two patches for better logical flow. (Thanks Vlastimil)
> - Introduce set_node_partial_state for symmetry. (Thanks Vlastimil)
> 
> Changes in v2:
> - Patch 1 applies the same optimization to __refill_objects_node. (Thanks
>   Harry and Vlastimil)
> - Patch 2 introduces a helper to wraps duplicated code. (Thanks Harry)
> 
> Hao Li (2):
>   mm/slub: introduce helpers for node partial slab state
>   mm/slub: detach and reattach partial slabs in batch
> 
>  mm/slub.c | 51 +++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 37 insertions(+), 14 deletions(-)

Applied to slab/for-next, thanks!

> base-commit: 6b41dc6749232c14f3e069f8115084a7bbeee402


