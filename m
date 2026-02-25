Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A246BFD375E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37E426B0092; Wed, 25 Feb 2026 08:33:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DBC6B0093; Wed, 25 Feb 2026 08:33:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A886B0095; Wed, 25 Feb 2026 08:33:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 025DB6B0092
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:33:01 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA0AF1603BF
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:33:01 +0000 (UTC)
X-FDA: 84483069762.12.A2EDD61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BEB29140010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:32:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ijl35Uv4;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772026379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RLyub06dxMv/HXr6PBW6fi9xoiyAjt5/R2WK6fgEsA=;
	b=SHqLOr8WpmkuxMRfO7jJFj1gEuLLTq7H0JQ0TjagUkDy98A99hjx11T99VM58cZOeySm8X
	AoFGX4rrZ/Qwr+j2HuHJod5yaqN+sgiQGSH5L0FeTbiwd8H2pA5J6+J9XLV5QoP2jqEQYC
	cmWN1iPo6MMRt8L3gotyHt22/YB1PuQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ijl35Uv4;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772026379; a=rsa-sha256;
	cv=none;
	b=p3FhUyFw2tO3O/2CRN+HfZKLkHSHRurXzyiYIskHqoPI1kxf9L0KvSp5NON8D1Xjze5Brp
	Ussaj1B9A0EnM+Ug6JYF+F0oHPv1jToxZGbJHHVDLUHlJgjtDlHhCBAVfLt08JXo/SKvcE
	mUfk5mmUgH/NXu201oWu1EleEVgIv0M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE08A40A60;
	Wed, 25 Feb 2026 13:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50A0C116D0;
	Wed, 25 Feb 2026 13:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772026378;
	bh=wmr6bT8akEtpLi1oziJGuiLkNQ2Ie8LcCOaUZTc1XwE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ijl35Uv4hx6aBfx51WTjt9zLWon7TP2CTtDIUj/BWvpN5xkoWHsfV0LUtP4CuSdpR
	 Sjpgg82MHS+X/gqDJ8sdXqQOAiQiXQGJEaoyv/vtwkTcL6Maoie3h49U95yj4td8z0
	 KBfyp3TIgn7qE96b5c6SAtKYZhnM2+4L9svf1PyC2kjWbnk4AzOpb8sETykEjxwqZf
	 OlAYJtNwnUEbO0PhU30jHgRJWuKC9CwWcB6d7cUyAkA+cyVOfikDYe+Zt5t4kglS3Y
	 Om9uJezjM8DwfDkfJ8p37Pv0mi0LrJuJtv45QHWCEbsNfqNGsYGm0MQhrh0L6a8FXH
	 2Jgw4GeyLD6jA==
Message-ID: <923f69f8-7841-47ae-94a0-e624153732e2@kernel.org>
Date: Wed, 25 Feb 2026 14:32:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] arm64: gcs: Use the new common vm_mmap_shadow_stack()
 helper
To: Catalin Marinas <catalin.marinas@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mark Brown <broonie@kernel.org>,
 Deepak Gupta <debug@rivosinc.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Will Deacon <will@kernel.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-mm@kvack.org
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
 <20260224175800.2500729-3-catalin.marinas@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260224175800.2500729-3-catalin.marinas@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: br7bs9js8kywsqw1d7ot171xqpbtr6sn
X-Rspam-User: 
X-Rspamd-Queue-Id: BEB29140010
X-Rspamd-Server: rspam01
X-HE-Tag: 1772026379-465688
X-HE-Meta: U2FsdGVkX1+uBVaHl2SnzOYRBA16g+Zh+LTB9ckJSofhEYbMTrNIZMqtihUqFVo+tDdiJZdjSAM3LanRUyCLTrmnjZWLtq4AT9e4Uu5V5rp08hSGc3EtQ7AnxIghAqVhwP78DMuzc1JdTwSsnccE0dqTldx1/miWaoRTayTyMaweAvgoR4EBtMBRKF0kf27pZN4cJff8GWFkKJQiM0nVMaQjuShHNCxKUPENkujnZ5m8skjIE0+ysK5CSv9rMggJlKGW9F3dkZk2PNQwJhmq0Uc2k736KMhM/2aV/f+xsS29eCXQ0am5tIdprJrIIb9PD/MEWt+5dQ97pgk4Fw+ihfPByXdG+mN7gikJINE9tfxd5Av8t7oyX21EBUqsjNNlwYOOcLAKk9myi2Fg0xKCY6EPB9bBl6RvsnVz6X5vvMe8oReXe5AEZbt3WDzLuHiRi1iAcnWfFp1sjfDdt0Tk2OHrnLgbfi2WHy6hz7tmdOZobeuYPR//5v0Y7A949mcNUzpzihit08U2AgAFx7W7trdh+itXoi8K/YOupsMd/sehrPRq6iTd31STbpB0S7mAfZPJWPNS1RHAX9FBwXhanlYtWKYGafdBXoi9rhdIpVpwerkGslyQU08yefNJ4YXgpoHJ8v9k/6gaQ9EGkByWAMNiaJXnJE2EqelKSf5ZygyAW/p8PhcUdv9mosvNgKUn6i+ERQIrOnDCjJofTFj+W0JyXAiI5g2QZegYMtgNXkMu8RbYUTKYdb5SemfGAdp9rVfhAj4TQte21FpMkveo5vNyIOmL0Ujn/l9I0X5CDYAVP2yRzHAM8TGE5CQm7fvg/bumi43oz4YNfkyxnpYOEgOXxPbbu1sHDrmZCGEB+BIvFZEzMpsjvj/qcWt9F0LzOzb7W6r1N1C5UcYM996rariDh+fLyW6MHH1v9PigGZkBabT8GU9EkIXn53odeyfN2pZPNW0nZ9RN90WwaVe
 6GOISYjc
 XfgHwgrjRZzPIxs7Ch5LSF1gaHcpqdW9HhN6eN02cjCJzQfQ2IUUsNshG2E3uoliI6JC2cMVBve9Cd9oJMGMtHznA61puq7Hz+bTg5fAv5QSAArvMewZ0cRgc/gXWabJ9pXDs4dYD5PkmR+hNOgJPvlxADrP0Y+K2Uw42mUQYRrp+BEahRoCveg58oyAtk3pBBOsjy1YWhSXx1j9d2FPkevfI2CpsjCzuov1SD753bXB04rjWPRx3QuxBXtG4rWZwIVrIyqrnHt4RFpQL3XfPALVSp+REvIaAnlwfRK5TCocCj+TPU7iSvKbpsRKaX3GWXml4dEg5JpCwL7QTE5pvWah2nmgD4DGs5xvtS5q/Icg+g4BmJMwBIGOLZZ31nxdq0YrW3RtsBqhBD2w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 18:57, Catalin Marinas wrote:
> Replace the arm64 map_shadow_stack() content with a call to
> vm_mmap_shadow_stack().
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

