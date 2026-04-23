Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD14FDEE3F
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 19:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631296B0088; Thu, 23 Apr 2026 15:25:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607E56B008A; Thu, 23 Apr 2026 15:25:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E576B008C; Thu, 23 Apr 2026 15:25:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4212E6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:25:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFDEEA035B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:25:40 +0000 (UTC)
X-FDA: 84690800040.23.B34C01E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EE16640017
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:25:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FVX7LR5V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776972339; a=rsa-sha256;
	cv=none;
	b=yT9JoLA/wCYW1Pvw5jo8b+UVMqKvPJEHLaOaHhkqsBQ0Mo8o6zTmWaWUMOWkfM0iGKRysH
	vOcUqOv/EWAV0bv7S10bcePlxeBnhPSPo+HgXWo5SWh4wn9hzruXvvwky2D8bAUFRWA6P0
	QM5z1Yv80dtE285ObQh9KEEjSR+Gji8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FVX7LR5V;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776972339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enbskP1Wr8MSKLZfmzCeLIVxZaEVj7jBjVJ+H2o3mm0=;
	b=V+4muwjSRonD2Ha5MbzaMUEOWIVE7GjX4qjqhlzEeNofsIvMtMuoEG/nZYRCWWC0/NzIZN
	L+9xulOwrPGTIHZZdW8Ey781w2SL4C0FVRtvYTsAoZlDGRbpJcFzWN1LvgpYYTemb2Ywdz
	3CUC1Y4MtuELTtLoCgYxA+sTtFNAzR0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C68AB4347B;
	Thu, 23 Apr 2026 19:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4E7C2BCAF;
	Thu, 23 Apr 2026 19:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776972337;
	bh=mEhSNzw438eFSo2SttGbiPSYg2mHMQZBVE1dKmzNCRM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FVX7LR5VfT9r+KDdUIYNaKW4g1qbwcNTMrf1WWtlqrxX2N6+4OFX2vTsYp1PuTRpn
	 mveZ91DqGnBIL7zSKFKil5s5fMsAEY5uHjZ+eXPw5qMGJyxWJbHz6fJXEK0E5czucz
	 O2wxGgqwuGJnt88RUqCa5l4hRyybxiGh0U+sxVJpxmLvatbj0FwdWzl3o2KZYl0OVj
	 JhRVlG9Xr6AMize3o3Bbpikvp+LKEg5E1NQHZykdlqvZ509ULoXZ/H85A5eYVLRt+I
	 r0AOAmna18dl5Es84/sYgSuoBB8GoR7vPYRr7NvfgjlQbhkdk2GNqhrPQQNgY6vTgh
	 ctogcTdfyfZZg==
Message-ID: <17b0dc02-eee3-46d6-9afb-5f81a3a20216@kernel.org>
Date: Thu, 23 Apr 2026 21:25:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM guest
 memory
To: Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org
References: <aeFCuLJXT8VOkzH7@thinkstation>
 <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
 <aeImfRrrvr3UoKtL@thinkstation> <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
 <b77d559b-215e-460a-a268-e63b8273ef42@kernel.org>
 <aeorZMvKwu8zKX5i@thinkstation> <aeoxnuGKO3uqS2kG@x1.local>
 <aeo5IPpQi7onyjTF@thinkstation> <aeprnnccJeyHB2rt@x1.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aeprnnccJeyHB2rt@x1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EE16640017
X-Rspamd-Server: rspam12
X-Stat-Signature: bomud8jt39xy7o13sz6yuwk5ag1urja8
X-Rspam-User: 
X-HE-Tag: 1776972338-60800
X-HE-Meta: U2FsdGVkX1/yV1NFp+eqTsTlz1yYl1SwYvw1jcpUF0EpUju8y4fMua5PC2Oyfyh1Q2WqBOyGnnxMC/RuH6CedC6mX+xrQwxFZC3XHDvbpqD0HdwsLk+xr9qQDxRQ1C/v4tDPqhNQaO9+wYnkKv4SgjfUpDC4aIrg1FUe26FrU/9YTsGUq+xycchWwQLI2wDm5uzjMjextW/W1Xq2ZzERunGawScw8mb7hd2dnDqofN9zlUWVbIKpMFvaAb2IYdd48EtAX7yUv7AbbJOv2TV+miA2OMGGtSVvYpcRBKesOQRPSFyLg83NgW4yVD2uDVErMI28bvLeCxdwxdshktAdaYFpnvTuf72RIe87IGIyrYkQE7RZnGcTmO6aslrCOSS+AJ4XdAJT/F7wXJQ5jPx2Y8qJQYmU9CLr5Gkr5qqzhyGSjhxPJPYITyaAcoZouXdUQwCvP1QSl+caYZFV96lXlcXGflDeb1LUS5vl8weoEwG6k69fPq8arlBKpThYZZT1cGJ5JIWnhoLMS2vq49t4U7FT9POoe5nV/2DXkO6urBvGYinYZyKXTPjbFQg5rdjyT6sXapEJkRaKvasvs6jrx3ykss/9C6rdNl0RFWfZdDjIZlmOW0CS66hh938PXoG8UCQHeqjFP7gkmYMfMiJMra92dqw/7sXTwSfAChVAabW/kfe2PfvyH72TNX9BJpo4pBGrgZBLF3S38RZn9FbExkM+9ZSAPgMGSL257GLIc+Yr3MsxPTFljJNqzaR813HqKd0GwDuqv+obrTEhNlHcOf64WVHUR5zIfXqfsAtdJ8MqjjJEZY82y6IiwfKQeBx9J+yLQI2Mfg4fkXcFfcOQvuGOBlkjuvauPoJFdYv5DCeZ12x7kCRUTNVoAesu5aP44oqyfjhEPdZqtgrvcNHp44V83TDuU4lPNYgTbvZOPohtwkKJxZOlB1SMHV/fKOSrqnNEGnOcIwEVUOse+WR
 3CfZWNiZ
 tPsGTBL2RBeO7sc2FgRVAVhYFxI0zKt369+0QsieOzSVYQCbk94QHIzN3B4n8BAAU0JOPI9Vo0THP/iAuiDyCybT00qul2Ecgj3kMeEAlz6ideLAxfZ8w0t/3u6Bg/ed2qlMJtNBtfT/+qsOSv/1dv1+cxVHFH0nD3DTED+A6u1Hr8WAAjqHn+CPtYx8QRCfpUZvtzXM/hsrZeNwMvwqtRTLsSTL8n/ZpqsNmdmTt8TOLS8eVni/VtAEAR91HuCevxP2GIZws3zA/1CRlPsSgnrwvMk06Z0m8DZtl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
> The other thing is, as I mentioned in the other email, I still don't know
> how the current RW protection would work for anonymous.  I don't yet think
> the user swapper can read the anon page with RW-protected pgtables.  So far
> my understanding is maybe you only care about shmem so it's fine, but it'll
> always be great to confirm with you.

I wonder if uffdio_move could be used for a swapper implementation instead?

If we ever have to read from a protnone page, maybe we could teach ptrace access
to do it, or have something that can read from prot_none areas -- like
uffdio_copy, which can write to prot-none areas.

-- 
Cheers,

David

