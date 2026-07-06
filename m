Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C28EDC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2E06B00AC; Mon,  6 Jul 2026 05:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63AA6B0102; Mon,  6 Jul 2026 05:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906896B011F; Mon,  6 Jul 2026 05:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E59D6B00AC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:07:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E28CC1A033C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:07:25 +0000 (UTC)
X-FDA: 84957773250.22.804EA85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 344A21C000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:07:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ab51Wrex;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783328844;
	b=6tnceWMDlLKSCA0qKJKIamGJa5NvZyhNNwkIQc4p7T9c6Bbw7qcLLGW6hF3DdNnviMUb6Q
	TLfrn2ojJQf/WQVo76my8DuScsfUPu7Co/OlOHjYyJpHEtQy4N2df2ZMFGrk8xNocanQWq
	E9VgYW32A6z+sU0UgkIKiQiTLBJ6FcY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ab51Wrex;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783328844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSfJQt1JiqAr2xj8Wd+P7V4byeDYrtLPRI5xJpeSUP0=;
	b=4hUUTCml/yTxIVdmzEIDZ4piHkYMQgA8655aua+VyywDAOQLXx2Km1O82xaHMVQ95YG3W4
	2Zm8tWS6MVs0HPj8fetqVBT1ZaiBEyW0lBgHqNRRj+cjZ0rXk+8woiwjh33hmOen4YY5qN
	ZkGTe+QKR9owxNjEKIagM0lHVJoOpjg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAF5360018;
	Mon,  6 Jul 2026 09:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69031F000E9;
	Mon,  6 Jul 2026 09:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783328843;
	bh=vSfJQt1JiqAr2xj8Wd+P7V4byeDYrtLPRI5xJpeSUP0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ab51WrexuNkUaU0YN/LGfyHuikKjcjzTdYrZgkt4SeXddGjqYHhrvgDbj45Q6pM6L
	 mdd3L3gatNt1KH1s/74Fp+cuwVU186o21mKvpPxRcTXR+x0d9MGcErh+A6a7umIO/n
	 ccUc3lA6KZ25pVDkr56Q+SlNFhhZKToOFx/YeT5db/NZCCHPWERmXwwPUfY2RRMrMY
	 rVh7cPUjiCoS+48edRJUxufhITHyYF57Fv92/jLlERKdOOjO4QOBPfYdsKqI2JPSo9
	 70Um1vEdvCGmvYAaOwKlDGkzM6081GLnkDG1FeFllfzw34Ku31Yivi1pJb66/XUX2X
	 1Z1/qJ72ZJl8w==
Message-ID: <16516aae-d233-4756-a378-14ead66de36f@kernel.org>
Date: Mon, 6 Jul 2026 11:07:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: avoid shadowing global mem_map in
 sparse_init_one_section()
To: Mike Rapoport <rppt@kernel.org>, Anuradha Weeraman <anuradha@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <aklP82yPNq5lA2Na@riviera.anuradha.dev>
 <akohFqkKncFzoupL@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <akohFqkKncFzoupL@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 344A21C000B
X-Rspam-User: 
X-Stat-Signature: b3ofnuwtd5wb7m9nh4u9pzjduic95ajp
X-Rspamd-Server: rspam03
X-HE-Tag: 1783328844-570228
X-HE-Meta: U2FsdGVkX18mw0M/vGlyZMSOJFjik1+jzjHCusFHQzz1XUPhys1owiB47psffG5pX/zfFYozBXU8yCix9v6cFXiDpQigwljmey4ZNOM285LMjfPk+okKkYwY0YuFxwy2d38iji+n9snRCFyy0YybX4qJU05ujMgqEo138v904gXsn29TeabniPaTZnMJ1RXqqsYiffhm/jAydgMTn0S4fc5r/U2iEcoSxKsZ0Ylk0CUcQwTYKDQ3BW8ShXlVjXvN0FhDBob95KpNJngPGF4HTqG6YS7EZtXolfC7D3YC++nvFjsKAI1ZC07H42NpSNskgMTRynw9vEhUHTR1eP/XJATzetgZzz4fl6lFnOVnvcw3i2VceNSFSUBbj2WjD/g7qw3xLBbkT79zQ19UwDMSzWfT51J9L/oSnzKZ5zdm1dgYWAIxBxOnKoaKIkVHmFmKbbFAn55clM9he/A5Xb8ZGZj97dfBxPGIFsnttB8K6+liiCsE7l+WloYgf6VOQWtJ5yMjmn8qjr6opjM3hGa2Bwyr/Dns8sA/8mhvI/2gKmFHF0S9pmIY97G4pOCqdZpUHrBfl4rSCF98QlwbrGds7RAsHgfRO9qqehVNDw9+fUp9ROjfTqbuGET8jvQN48uiw14yLySb6G1CCy8zWjbihdYp7eAPA97J80irREtO5ORwTjORVvsrziDIU76KViBY07e1xeq2JNiY61BBkLzRZKjdWvkMzjsFM0zh4m5JQG4Fq3zzucb+dKv5bqu7gvBlczi+ZWQIq4U7rkPjBmi0b1qptnCRQ5LB4bEJLUBm3ht10LQxcSgVn+svT8S2pGNFIWgknNewTF8QyRFLQyG2mmH2ZIro+xfrP5/a4GNpD09C3AAmTQDmxT71kbEsT4R0+G/BQxXswDUY8HtgOei1FUjE6vJTuFQnlbokJm9Sk5ZDIpZY1UjpFpySZkShO6aqAVNPEzfLiIlSrdauwj1
 T0zkS7hA
 RUAhO62uJ4madsnNfD+jtTVDtLyHfb05fcYvlz5pXD+amnKtPEqCUbiU7QOPzDbQnSfmnmrqy1QGQ88bxcykdel4vmKqe4QaU+FQCB5pvmX5F8V7iuLKaaEjz39n5PJxnHJa/Ql+zIUEkKRbm3Ef0hbKHqPO1mKx+KLQeH2BdpdA9IDtJl8lgKIT2ENlSlaS32y+Ac7+UOnhJQj6ZjlXjmVony9HjTWA95pINC3cHVoQk/5G75fKKXzpabz3+/Ti4p749AmFh2OnYJViBctx2D7bLVH2B6Tab6eiFd9GzQWUbRyQbshSRPioo/voiAWg2MvSSWa/Qm5np5e8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/5/26 11:17, Mike Rapoport wrote:
> On Sat, Jul 04, 2026 at 11:54:51PM +0530, Anuradha Weeraman wrote:
>> With W=2, sparse_init_one_section() warns because its mem_map parameter
>> shadows the global mem_map declaration in linux/mmzone.h.
>>
>> Rename it to section_mem_map to make that scope explicit and avoid the
>> shadowing warning.
> 
> I suspect that the comment in mmzone.h saying that mem_map is must be
> declared for SPARSEMEM is stale and it can be guarded by #ifdef
> CONFIG_FLATMEM which will be a more correct fix.
>  

Unrelated to that, I thought we don't particularly care about W=2 stuff unless
it uncovers a real bug?

-- 
Cheers,

David

