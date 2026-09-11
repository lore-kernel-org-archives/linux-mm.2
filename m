Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F787C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14E2D6B00A0; Fri, 11 Sep 2026 11:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FF756B00A1; Fri, 11 Sep 2026 11:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F312E6B00A2; Fri, 11 Sep 2026 11:02:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7E9C6B00A0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:02:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A91A802A1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:02:28 +0000 (UTC)
X-FDA: 85201797576.19.D43E3C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D591A0013
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:02:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VZh6a5er;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789138946;
	b=2neyg182s6Ci4BLndV0h74y9OkQvL+rlbFX0U1t5W75g5h6J6cxvgZOJbGQm2P2g556pDe
	v59ZD2l0iASopQVokXNbaQZTuUbKih3HUd/fXdhP567dveyHsY2WcM9ToV9oEnPTw2NJnr
	GC9fpKdza3lPN4cAvsuYRFlA+JE4V2A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VZh6a5er;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789138946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1PTWyg4n3qpD4y/aa8UvIgM/ayJsqmzhh3ejIEE3QXI=;
	b=EuPslchMebxeuSjt9qT+eSWBTBUAP0UJ9o0XDxYaUePLacfeO5MMOEO6V009xmgsfeQ+LH
	6Bg91wHuNQYWbpvDjJMpyuPEUxpSDDCheAtU5tTemFEakvW9cHtAo3wjy1StMpScOr9O1r
	qRG33QfLWKZDQH8OJaxcH27Y3PcNTBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28DFC6020C;
	Fri, 11 Sep 2026 15:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138301F000FF;
	Fri, 11 Sep 2026 15:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789138945;
	bh=1PTWyg4n3qpD4y/aa8UvIgM/ayJsqmzhh3ejIEE3QXI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VZh6a5erCAhSab9ROCtz8BS6g7MI1jzhVXl1TxFBYM68Z+fltaZm1xEx6OLItP15Z
	 nZmBVnNP1V+0/DmEZx6SzFV84s9DU1Cqc3gJdZgKEuLrXE8ZBhvx4UTF2zsQJmzQrU
	 1ESbS6pHuZFLaLsWPyN7kq3K9C94jNU3KLadDp0qGGPb0YqI8SxZOaAh8rd/J0rPK5
	 N7z3J3PXvkWkYOSJwSDPZrWHYbCcf4HyZ5juLbh027S7qlmCWyKCaa/zsagr+fkbEo
	 rjY7sSzeoe/K7U4vNDmzPmvaXdunSPEXnnKxmE3D1cRrG2OGu0oUCAh5OqIXCJVYCC
	 jemxJj67wfX/Q==
Message-ID: <62160d6e-5409-4249-814b-cdc33b7d29df@kernel.org>
Date: Fri, 11 Sep 2026 17:02:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] kselftest: mm: fix potential failure for merged VMA in
 guard-regions
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20260911142904.1825452-1-yeoreum.yun@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260911142904.1825452-1-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9D591A0013
X-Rspam-User: 
X-Stat-Signature: c7iaa58nox1mn3ipotsckhf3arwn5yje
X-HE-Tag: 1789138946-199652
X-HE-Meta: U2FsdGVkX18q9AYn2ZX2CB4qAF9FXqbYDGZJ7bBxacS6Bx6Km4csji1UpOGkkZ6dWnQco9znVnjJfKw3mofJTpxPiQejaXV4EPthFnf9R+bN3L6vPEqZH/lR/9s2iiCArCS9rR00gz40+k0bmWJ6z4T3d9nCY4M5tOkb2JFax9hXSL+8MMKOK7d8GHbcYz3STLB1+W8BBxs4PUnvP2HDfdBRgBePkS+CjEKkSIQhqdgIWotz0cXfXf7OxWujQepgGg4do93znA6hPI1kFs1xGjctPZrjk1aUPq3wq3gpxrC1cTG4VHLh12GSTMI+zLNd5UWWT3edyO5HH1TIjRkSN8tB2uiyIbjKhqtw3Id08NpUQsFawMvQfXkbEyfpTbj3bqMUIkfuaL0cMTQDWtJPzBakHaUW144kHOsMnZWoERKfxoLLUxhZsIOn+NMpW8bL8Of5ne7w36+reZRXzdklLyrFEiSztsTfayAZkpXHbCZVURCa1Fa/4aJMX96a7IqmGGpgOnOOh+tik/RxQGtHOuoe7yJ6Z+wjkLQfMpW8RGRIpvkcAaFDMJ4ZalFMY95NMOMg9rzM2KKpnM33eQTmlhE91/zDpLjd98/+RpNhoHa39/FP9uMZR+4b72yq4TdnzUKCb4NDt0kVmx5otD3xoDxkUxbO7jJSvRn6j/wMUPX65rRV2IClA6wozE88hAb0o5cXMGIvwhK9dxFklVXafyDY3o3K5l9WA/ouQs5mcWcmViqSGrKxzg13VSSqfDry7gUqkNR4QXN7diDIKT35uaadhr3K5ZkLy44sHzTsQgQnmFJds6DhC/CPM7Ik5MgrlFACizmloTrOg5dT6VYgao1vvjglZRex+lQFXPyskOWqKkh7AcH9FlITvD9FVUXmHkR27ScPTWMiwT6v+xWbp0NTfeEhx1IwcevGGmOlqwCAoAPLkrHsxxkBmC5trZeqQXyPqGlFPooJYJqChQm
 +jufscrz
 ccuZurECBPtlTVCTC0TCZFNNeabmClmqp9xt8HM4TX8EXCceqRbRc7Gm8FkEfCUHIWNhMAJI6Sab67ORG04Is9NfR5NuYU3FXzBr5hrDa8T3NjfZaHBGn5BzXftyb8EHaRjMNPp8wGO2O67HTDzGFtrMmie1cu4ZXUmhiLdKdjIB31y0fgOIdpy/gD3cNPCpGjKXTl96lzKn4HNpzxzJXB4k8kJFP8E823cOQ4xBRnxTXrPuuS3Nz/JGAv9hgTJuWmyvX5rT2mOT18NSkZyHjacF7OqNeC9DINi3mgQ1a+XW5SDytIlVvZRFaSI90/LRd+bX39B9s8R2xiBxYX3p6D9CxQvWfXByjPBLEtKPQF9LX//A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/11/26 16:29, Yeoreum Yun wrote:
> check_vmflag_guard() uses /proc/self/smaps to retrieve the VMA flags,
> but this can fail if the mapping is merged with an adjacent VMA.
> 
> To avoid this potential failure, first allocate a temporary region with
> extra pages at both ends, unmap it, and then map the test region within
> the temporary address range, leaving an unmapped page on each side to
> prevent VMA merging.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

