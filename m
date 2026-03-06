Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 551D9F01835
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 13:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 956E26B0005; Fri,  6 Mar 2026 08:28:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4476B0089; Fri,  6 Mar 2026 08:28:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5D26B008A; Fri,  6 Mar 2026 08:28:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71CE56B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:28:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D904B9B55
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:28:04 +0000 (UTC)
X-FDA: 84515716488.17.86F4B7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 68A9DC0007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:28:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=klmrVagm;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772803682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsq2LzVtMcyu9YHrqs4HAX1iAq7nMfeZ48dssBJyd2g=;
	b=2hfBy5i3kf9TAI0m5on6sbmXRqvHQP/tTFiWGgc5Hq+BwcGRdASBI597ZilOISnZ1vk5zn
	BVppk0fyFramsggXDmsV+f+7Vj/Di+hBGrlV35mhy2dEubZ1p0ik3Z3T1t5tIrzjg9qMsu
	dVUiLDT1Yp0p1b89bVQHTMmqL+DkUCs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=klmrVagm;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772803682; a=rsa-sha256;
	cv=none;
	b=hpy7kMfvh1R0XQ2rPUTEv+mJKm4oOWcGxn6gXZPAd1KX0bvbvmAiLtWuNRVMt3DUvRAmHu
	Vdy4cXNfuYV8eJ3NnV7BjNgJ/NkJwvUrrG/ntxLclfhI07MXYTucH+vo1ao4dQfrcSro8w
	VvvQ/Qdmc546gvc0VMaVy2ehIVymh5g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B6A0860018;
	Fri,  6 Mar 2026 13:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA26C2BC87;
	Fri,  6 Mar 2026 13:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772803681;
	bh=b4U3xjNeltKbkeNzgWxFljW210JkNn6MPbdzC3gSIjo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=klmrVagmasGkU+kD2JWGkZJzLXk2A3iawm5yGVjyge88NXEO5dK6ETi83DLBMIQj8
	 IU1UuibEG3O/0jt7pcj7Tpv9p1dB55yDQWvU1M48LvqcGNQ1+BapOUW12vjO8BJke7
	 AfQmhLTWukPTM5c08VI/1rbVNNSeWhHW0EhnoiPDixqrHYb7H/bEez+PPiHAsQzVyX
	 9d9ap2BiUXv4akVNqPdCzR/FlxEJrOzc2MA8tmp1l1w1bnpC8Fwf7Nl1ju9Y4t71IS
	 p/8s5sAr7sTpi8tB7sCYlqH1aruOYy7cfTMN+/pOuwZu1DcjBJASyAM01aEm1RGFfd
	 vEav6Fj4utRhQ==
Message-ID: <7c74ea71-cf5a-4167-a2ff-26a424271007@kernel.org>
Date: Fri, 6 Mar 2026 14:27:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/4] KVM: remove hugetlb.h inclusion
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
References: <20260306101600.57355-1-david@kernel.org>
 <20260306101600.57355-4-david@kernel.org>
 <305a98f5-0a28-4eb9-a647-a30716e61cb4@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <305a98f5-0a28-4eb9-a647-a30716e61cb4@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 68A9DC0007
X-Rspamd-Server: rspam07
X-Stat-Signature: b77zhgmk5qn8mm7w6sufyreup3qre6rh
X-Rspam-User: 
X-HE-Tag: 1772803682-99695
X-HE-Meta: U2FsdGVkX1+6LRibnVCBVD7jeNO3Asy9B4pBixK+RABFkTBbHxv09DdW30BwA2NPdII9dFvVBqDFpTLm6SBKpOmtwM2IaJBOIUE8mW3nLUFtA7YVq5S8hc7kdL/rQL6a01S96/sIGh0x0XHLxyh76YMhR5rY2h2lCu+f18lyWiIVj43lrc9tVlqHPC878LQCXbYyV5J4W9tfZbrtSWkdLRcTmYuZcl1D+AQ/9PLxP3XJhZsHhi7tNyOXTbm6UAJE2QPTYHukNgTia9CNtN24hwZrCmrvw3P2ZvAdcQ0+iZ3VuWSa274JRLhL8Yai8XybeESEM9NsqVFFcB9sAhIl01hn5PkZFu0xD7d1MdS6dg8wF4eVwRN0octK+Cu2Zqg4cPYc7RSbiycgdlqcJrEUDNjqCqKtZ+qlcCkUViaf46gd66bslkOwurS6Q2GM0xTCUB8Jo2C6ZKPei2vyRljuf8mUYr4zxN/TNSZ0/7qQ3YAhpae8sSCCD1QqrQ4gut6vm3Bc+R4eQ/bO3mVFua5JsHCwcT6AFnDOLGlnvIxRhmrbHcexccCTbZ1z//ktCZ8lEzBx23r90vOKDIwDEaobAreAwvqPLAi+DkNkJncx3hDq7WQGsCcIQ6E+4fQ9Ma4XfMxdsWt0k3Yu298rIZbC1twBkokKy207u70GS4RJHYZBvs3G7q0HvmV2oiUqJODO6elKTMX/7uPZUp8jiKlm9e9E/eqp8hWe4AolMPXtHHLm1qjGToJWoeKRpMzPe5dKJp1LlrL46inY7QHNUzXka9h1Tcjt7BO0FIqi1AIS7dwxORn353f21z/8+pZOb70r7tFVs3M+VUR231bWr5DtXa8deUJfFH8YWcemmAuQJxFIMYnKNNh/us8c1mNarXnJ4gQ2ybe22QtD0WlRuh/WrSeM1vRp6I4z6Y+Y7AgTAn6n8wtc9wQzVtbMQ7u7YcPsD+QUWrolSv33ECGNMpA
 JSKrVwRj
 6f+MNPORhFwW4LVeHLEBKbaVeyKW++nBzsrJg3Mld7YYL900N1MUpDYj+grD0qJzk3nEuxj9nXbVe/om3DsyV5ga3la9tWXiB2Aa4l8yHfoItk0r4VNyqngwClQ88xxoVOuBIA5u4Z5VCZ78AWxNbzS+BHCoDkxVPAS+iLii1Jko1966e1qICxA0T4HffCYzn8rVlMhr9j9DDmK7XEck1/xNpupReqlsoAFUp4WUmHHXhBDaQZ9DIzh0Y8EsKcFswSMnqPKGy/lR67EGfx5nVjc9F0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 12:11, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 06, 2026 at 11:15:59AM +0100, David Hildenbrand (Arm) wrote:
>> hugetlb.h is no longer required now that we moved vma_kernel_pagesize()
>> to mm.h.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Aww this is the tiniest cutest patch evah!

It's a very smol patch! :)

-- 
Cheers,

David

