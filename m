Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C3C606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AidKf5Oi
Received: by kanga.kvack.org (Postfix)
	id AA1696B05F1; Fri, 20 Nov 2026 03:57:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52706B05F3; Fri, 20 Nov 2026 03:57:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967B16B05F4; Fri, 20 Nov 2026 03:57:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 719CD6B05F1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:57:37 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11ED940D5C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:57:37 +0000 (UTC)
X-FDA: 85454894154.15.AD0CB87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 56CEF40006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:57:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AidKf5Oi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795165055;
	b=BBRBE06atD95eMwtqJdd0sDXV/WJoFRI1o+1vWrWO+h3L+bDMVgj6+Crs9NC8ytxrRH9Qu
	PpS3p+M1p30ynRcmcWuaxY6qKiS52K6BaTwyY5E6UtGEO8bcUzgdcOwwEJXk0SCxBeaXj/
	ghv7q+CseWia+zfwm9YjCYHi7QDww2g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795165055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xymtrGcTx2O+sumJ1mfHsHPYfbzzq3PCVcjjBtb8a1w=;
	b=wmgdaS85HPctus2ksjUdThGeWaN8h1TB98rPiOipIzSeM3Cw78L2UX4IurZAnsNeXsAB58
	w4ogwVAXvbfZFtPcHGNsUqjmQZjXkY5qjDdrmhBx2O04wxc1Ft1mF59iKv8ge4Xrf58Rdz
	4GKNgjso3rWtIaPwYH4PtpUEYIubCH0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AidKf5Oi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C63660D10;
	Fri, 20 Nov 2026 08:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D311F000CA;
	Fri, 20 Nov 2026 08:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795165054;
	bh=xymtrGcTx2O+sumJ1mfHsHPYfbzzq3PCVcjjBtb8a1w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AidKf5Oio20NMvG5F0VbG/mFQgb29hTdOmocLK9PTyntDsWlNaCbyKTp604nL8oPS
	 +f1BKqLFqQIzr+KlfkcJMH/UOA4nSZ1L5lVECQZ+meak99aYNSvtWrA0DwQVE6VNHz
	 S2k7Ay6gLPTvL4hszopo728gUmtj8xIO+fZ0TlYPoDSDj1cslEPBo6cls+Q6f9oy61
	 N993uEI6e0K1graLrmV3eTLH77dO59whIPGOglD51aqyzwc5n/eGnYdfm8Nvf+5Jv1
	 rl8lb33mw4EOhYhO9U9UMTPZcglXOaeJBSaEkbnCnRTqHqObXvCr2uoS4cIS2iW3O6
	 seZIStiqkY9bA==
Message-ID: <4ed0eeda-22bd-4489-ad18-d522b36d22be@kernel.org>
Date: Fri, 20 Nov 2026 09:57:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] mm: alloc__by: create a function for allocate pages in
 small microsseconds in boards no-MMU
To: dev12124 <joaoanandalima@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: vbabka@suse.cz, hch@lst.de
References: <1ee9b247-6758-c146-2d03-0acea98db33f@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1ee9b247-6758-c146-2d03-0acea98db33f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: x7zynip8rjfyp9csjkeigyfpe1qr83nr
X-Rspamd-Queue-Id: 56CEF40006
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795165055-514737
X-HE-Meta: U2FsdGVkX1/WZ362jH1ebDqnCoBtC5a09PKwBQghsQm6Tyfl3snDjdCduVEdB/J3AHnlYADQnPjZFGfHWMRx5Ci8xo7LRGH6h8PxI4lpMpE3AJ3MAXvG1e456nSsl/VYUrDURGCvz5PzFXTQfhmYYwBgZiiPOqw2xsLgnXBXACFNqV+/oZK/IMBBItCqj6u/BZdFtIAKJYxqyPK2xIFMPFCI+2z1w88VnjYbCYnCJfXqO1TiSF1Kc9w13LlRcSK59w5lvbvM6MI1/C7aTgS+0mpCjFPXuR5Pr3xl63Q8YgJ++9daYP0f2xvweqpcsuKqjOnd+dyP/pyOLVLKLIDayiOws96e/w4LPKDsS+wJED82Mkwy272MdKaSTEexEIso3ibY2DcpXyRZXKPsZItbQKPxe5LC0NUPzSv40aY4LeK4d/uwJUtDaco6S0zb32b/OhJC0kt4sLAR+X0dXnra1svYC9krDgZlNJAZ+uC6+xRrqA2IB9hNqHpusD1pyvcdEKTwluDlhwtrAsmcXVX1Bsy35FWex9YQu0VHdESERlp7bXNaGnQFifFzvYBk8AWtlcr0kycFFNhIvTWn1c6ptiQU+3L+sS6Gw54QSsd4elg0jBj8QBW1bXqetZj+cSO+Fp73mtiKjYdEzXroHWZVKYkGUQESnZViSCtdfjo1TeTvkYa7ZM/gcWNCiMF1G7rF3gkHP9mRP/sDmiUS0qZu9nbpyknFnNPsp3/asK4jJq/JZ9EuHUO3PH9X9Io9uHvJTAY5KUH1IzAO7rmYVnWHmIoDewN6DQUwr0W1XkwPoz+t3b4muEgr97H7Mtg0T4wmRVJKK7jCjqhGQkZPdZaIwKjYlusc8T1YDvkUm2CbkvrVBE6DVDHTUy48pPIoAQDpXVKsc7o8tJhiBcP58VMVERdmk+tIeHWehaljipeuj4h490sBTCyhItS4gmS7ZsJFNuL+MI0vOyfuKl19BdB
 CbF1h5E0
 jDEmjQgjrmGP6OqGSeV56A0NkdaIsj7wj5UIm6aqXhr9D/ijbNhcj8sqWZg2m+Sw/vnC3hK0xzheAFtlh45iV0jC6vhjXBNRGtQ1MQ4/vVYfyuB6+XlNLbG9Coibd+kOBgEGgNN5eZzWsBFCcB/cJFm3jkHdYLlGbMJST7F4fGfHpzyBN9LKJHTKZC5SgMWgnuCD+2V249WXWbjHbLcyuOdI2zo1oSk3oHXG5YBesOrJgX2LhnQQ709JWz6FPA5toMib/z7S/qR5gVKvd/vAVwj22jDkbknlflQSmIk/9hIqUNO9kOJSFexwe+qaXFJcOAF/h/IOm+W6YjiBW0ldl+qNxxprBm/F7r2NFfuYGHOA0Am1K0w5OP6JyJxXcBOnjTWFB/U2Hg2FIr1WibwLJ9/SituISEm7W3kRE+/3H6hIXDxkTJUCsEM5gVai9KwwNr1ZzLETA2j3MvJnub1UqMS/SlZEqbhaXpACXPTLGtxxheo8++iRoLq+o2VeV5o8zybWOA61+LFy+OLgzAXRqfEJlSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 07:08, dev12124 wrote:
> 
> Hi memory subsystem,
> 
> Actually, boards no-MMU do not have an integrated MMU to translate 
> physical to virtual addresses or support hardware paging and; for this, a 
> few points:
> 
> I. Requirement for Contiguous Memory
> Without an MMU, the kernel cannot combine scattered physical blocks to 
> simulate a continuous space, making the search for and allocation of 
> larger blocks very slow due to fragmentation.
> 
> II. Demand Paging
> The system cannot defer physical allocation via page faults; instead, it 
> must reserve entire blocks in advance.
> 
> III. Use of simplified allocators
> such as SLUB_TINY or linear free-list scans (instead of the standard 
> SLUB); it saves space by 
> scanning simple lists of blocks, but it performs very slowly during 
> allocation.
> 
> IV. Proposed approach
> The function alloc_by(size, address_initial, flag) haves:
> * pre-reserved pool per size order;
> * cache fast-path no global lock;
> * bitmap O(1) of free contiguous blocks.
> This bitmap, more specifically the blocks, have the pre-reserved pool (per 
> size order)and the pool have word 2:
> * Word 1: The initial address (starts in cache fast-path)
> * Word 2: The final address.
> For example, a Program allocates 277 bytes, the alloc_by() enter and 
> verify the bitmap -> viewing the request is 277 bytes, the aproximated 
> size is 512 bytes and alloc_by alloc 512 bytes.

Hi,

I think we are much rather looking into removing NOMMU then optimizing it :)

-- 
Cheers,

David

