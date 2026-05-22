Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8861CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC5B6B009B; Fri, 22 May 2026 18:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9D736B009F; Fri, 22 May 2026 18:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8FC06B00A0; Fri, 22 May 2026 18:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C70326B009B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:21:53 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79A65929F8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:21:53 +0000 (UTC)
X-FDA: 84796479306.19.7EDC397
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9C060C000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:21:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z9J6HGmM;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779488511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmz+nisYrqpfd5vV01F2uPfJKuQwyCauBtng8ciiouM=;
	b=hG0NRRh2j2oQoadLw23Fna37JHutx5djHxBimeIIgSklf65WoB3dplB9yt4D1Zxp9lW2QP
	jPsdvCjmSl4facL2GTt7yu0ixwcgz2qzC0fljVdpvC2hM0pJDP0R/MigVTBYric1iql6lW
	dFZq0eTbvss/IXt0wmBOxxh/Gi/M8p0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z9J6HGmM;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779488511; a=rsa-sha256;
	cv=none;
	b=65K1tqUKsjAEIq8xOuDrZ6cXTH5bXrak6FntWMlg8yGslo7RHEoiMvr7qmG+JlcqOGBCk4
	UAJMvufkdBbIAqNrKrF5s7h3A18cfzgCo9e/kD2S/prHOMaPF3Dp5+yrAFTsLQwpHaibmY
	6nQhcWtHiMwHbcEfPD4bHO7dtGTrxqY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCE804028D;
	Fri, 22 May 2026 22:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF4C1F000E9;
	Fri, 22 May 2026 22:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779488510;
	bh=rmz+nisYrqpfd5vV01F2uPfJKuQwyCauBtng8ciiouM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z9J6HGmMchHtfbmAoeGyamdJcaRTywGlNTmAkdT6xSlC+PppDQS6Lbps1IVieZfpJ
	 xV6c3gse/oSnwd+rd91x9EahmJ0TWpyXGV7qSErrBlxluFP07eG4p+mTfc+sSub/eI
	 hWbe8Fziu8H4V+nuZepkaOsuNxZ+WWgNxjR1Rpuv3GYPFwNJSqfEqjg8NyaTo8PPFf
	 b0e6rMeVc7EeD5F9NJLU+2q54bI3AijFOJxaN/CiLOeyPIreQTyDs7/75H+4hCSkhl
	 bDhIO+afF3QpWOBbaG+hUUuiJywcK19FigkA70yipThGjPgUp4VKjAeSauJm8HkvTi
	 clEMHXQ3zaMvQ==
Message-ID: <a4441fd8-f847-4e76-bf26-7cd6b935cef9@kernel.org>
Date: Sat, 23 May 2026 00:21:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 2/4] exec: introduce struct task_exec_state
To: "Christian Brauner (Amutable)" <brauner@kernel.org>,
 Jann Horn <jannh@google.com>, Linus Torvalds <torvalds@linuxfoundation.org>,
 Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Qualys Security Advisory <qsa@qualys.com>, Kees Cook <kees@kernel.org>,
 Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
References: <20260520-work-task_exec_state-v3-0-69f895bc1385@kernel.org>
 <20260520-work-task_exec_state-v3-2-69f895bc1385@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260520-work-task_exec_state-v3-2-69f895bc1385@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C060C000E
X-Rspam-User: 
X-Stat-Signature: befxn7bjeg9ix4n6tyabkr6fqwhn7cf6
X-HE-Tag: 1779488511-347980
X-HE-Meta: U2FsdGVkX18Gf1OnZviRdQX5wwaDCGEypC0nkfZjXds3egVLcG9KsyWbgO0C05R7m07x4fMVEvINIeF7Y/Y1+N4Daofw9VP8YfJ7krsoi3VrXam3QXl0uGifnCc+XnHLDUl5w9eZODOD0AJ78KLulzrpJJqDj+7iUY1XJlc7Y4xue9KJF625nvFTgWVNto/ADXKl0yYuolKnoVSSmje/YSSfW/oFxO3Ol8xLVo7/od53lyGSRk1drogVizxNrGvraFeH5IrgPadnwJCRVfeHuqG+PClBfjUJH7IoKj+jmAGEbOFtCC8uywO93K+5W1X+/CFjK6wcsxEWkLxdnv2wFQ3H2mVpV3o8NU4bO/j7Yxtu1ABGGNFY9bOq899wc/kon/fFF3gbHcMI8OFxkv8Wp0dC7q6Qi+LynRpq2pRhNrDly6W/+00NbciE4xZFIvGPukIzMmmBOEvdxPbmgasI9d1haz0uyyU+j5Wi3c/8kVl9ckd6hAHA+b1IZ0wNpQ77lcWwUOJo4UwwPHvknQ0ESA9Scs5KQMnoUX37uAlyrOs+stUJZVniifF2nn/3X7f+t7aUAxnrvlYmwldI7GSwH5Zxx06f4TvEc8ZZwYvWNTCTn+Ab00wuryPB/mXqPDG/SZfCT8uVwSn8eMq6xU0hAdlaISWNXVGECv+5hqgHlgnU0c8pz9B1cRPNxilT7DL2ebC63vRMpumGlxu/rSM/we3g/KGZ5e97BQahK4mcCniArBNC1Vp8BGnnzBXGptEs/ol3gtkanAq/++Gdqubj6Ap49YSwrIVT9frVrHyxIxmSfCI6F+8O+iajqlkN7VfDwPQsfUN6vR+ojFPgOCDfZXzk1IUjKZFXJbrzipZngtqoXZydaGEblEOH9Ke08fC99U4wybhuC9nUIitIgvBBiKshFlixfJnu/iiOAUR42WpiljvAmBOKFyt405CTXVLqoCELH6YE+XDTBRLRkSx
 GidmZ8rG
 AMyjbTxx3tL1hGYFsOZOTaYlMs+Bam7mkukDWKBVMqKUt8WfMsCPtMREBugUKRksozj7pGqzI1mkMaOkxGYlf+tGCxjWadKlSdtoOWS9jUj4KmZUm/3VOteQNHGmylNNkeQN1w0yLc3Fwojyk/yXjUQI3bGxYWzTEOO4S5GBmpn67NiVJNNv6oJpPebDIyJJCX7iK6gtyK4gOzMTUoJX7A6M7b81EIUszaS+QpEpWYjURYFRsWUTZN93iiek/0RuPfoRU/UDBLx6+m8OvNNoZVYwcs096WI20pDvVag0U/6KOeDYVltKUP6LTPYKrgCUaCVhmThspD3hgjOrolY6bXDrCqVafLNmAlBRs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 23:48, Christian Brauner (Amutable) wrote:
> Introduce struct task_exec_state, a per-task RCU-protected structure
> that holds the dumpable mode 

... and the user namespace, and ...

> and stays attached to the task for its
> full lifetime.
> 
> task_exec_state_rcu() is the canonical reader: asserts RCU or
> task_lock is held, WARNs on a NULL state, returns the
> rcu_dereference()'d pointer.
> 
> Reviewed-by: Jann Horn <jannh@google.com>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---

[...]

> +
> +/*
> + * Store TASK_DUMPABLE_* on current->exec_state.  All callers
> + * (commit_creds, begin_new_exec, prctl(PR_SET_DUMPABLE)) act on the
> + * running task, which guarantees ->exec_state is allocated and cannot
> + * be replaced under us.
> + */
> +void task_exec_state_set_dumpable(enum task_dumpable value)
> +{
> +	struct task_exec_state *exec_state;
> +
> +	if (WARN_ON(value > TASK_DUMPABLE_ROOT))

WARN_ON_ONCE() ? Not that I think this would really trigger ;)

> +		value = TASK_DUMPABLE_OFF;
> +
> +	exec_state = rcu_dereference_protected(current->exec_state, true);
> +	WRITE_ONCE(exec_state->dumpable, value);
> +}
> +
Nothing jumped at me ... but it's just after midnight ... :)

-- 
Cheers,

David

