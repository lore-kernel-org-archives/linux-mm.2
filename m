Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D8EFCDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 13:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94486B0092; Thu, 25 Jun 2026 09:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B44FA6B0093; Thu, 25 Jun 2026 09:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5C0D6B0095; Thu, 25 Jun 2026 09:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 81AD66B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 09:12:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 109F0A0613
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:12:20 +0000 (UTC)
X-FDA: 84918473640.03.8599822
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7469820016
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 13:12:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTLDowH5;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782393138;
	b=TT1uoeuNRVSM74B+NkMVhRdNSmtkV5eGDXfGJyHE5mqGs8nY4zc6BswprjBLDmsxUaoNEY
	TnmkX+9idTUiyziqGpaf6RA1nxbRUT/G1XmtRPB32XSD3dV3YGdh8MJczCTJZbVWFf7L7I
	itCzpXVtdDfyyZfmB+YjcDa9D/vYxUM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782393138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KaJcGnJ6r8JBco2fM1Z0ek6EnjCHDlGc6nEznvNC2CE=;
	b=aYozOXRcJsqE5EmGbAKkioJRhLhzEt/yf5wp3nMu+xdoIT0xZEuRUI7df677us6YqM+v95
	AFjtgWWjJRXSi6PoK2MxrCagnIRrc6iiVJu/wKCxtiG1hyjKnCj5ub6620fHdfCYLJktHS
	tmm8SfqCp7RCxBcI3bZ4u688trLhd7k=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTLDowH5;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C42B660018;
	Thu, 25 Jun 2026 13:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402091F00A3A;
	Thu, 25 Jun 2026 13:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782393137;
	bh=KaJcGnJ6r8JBco2fM1Z0ek6EnjCHDlGc6nEznvNC2CE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fTLDowH5PeF4TSMdSHX04kELKtpk2BBEbgHYeRXXnckqD9mJLpoCmxZNT6fkvzv22
	 N8EdfCekYiMkfyoUBQPyChzQzuAKsiIwTG30lScYPSUol2+G1unZd6mSIs1kD5UvXd
	 6zlSbgHwWz7NYiH1ZwtfC2jV9+rjIk6Qc6quFegBJq5anXxsthlY9AwgiQeOTKx1uw
	 rIaEg5jCt85UwzkEnYQ6tcOXnFC9CTxzh1wJiVT1oI3i7LONqxXEJ2e5qDdosLSY0x
	 AcZYmfS/FP7RSOdxCpA5QMaaIv0n9WovpRhn4GZGNfIpUtjumsRbzWttpBeArzSfu+
	 X/6diao8kdIwA==
Date: Thu, 25 Jun 2026 14:12:09 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: richard.weiyang@gmail.com, akpm@linux-foundation.org, david@kernel.org, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, ziy@nvidia.com, sj@kernel.org, balbirs@nvidia.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [Patch mm-hotfixes v4] mm/page_vma_mapped: fix device-private
 PMD handling
Message-ID: <aj0nl4001L9zMxFG@lucifer>
References: <20260624065353.1622-1-richard.weiyang@gmail.com>
 <20260624085756.6598-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624085756.6598-1-lance.yang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7469820016
X-Stat-Signature: pb63c8o7srup7915ip9bjoszgbeuqbwp
X-HE-Tag: 1782393138-602507
X-HE-Meta: U2FsdGVkX190tXaVSa8UkXnKy05akT/SdQH9n7q/OHIGwDsb//B/tTgm2R2TiCXQG7wfii32VRyY0O9NXoZhDaVOsKx8pUZjydqiznBbnEjTwyAONwtnivBqc4y0VrepMGmTF8uREtbu2VAymX2VPqA7hb+nOFYGB7AiV4EY7OVj3TK7NxlqiwZ4a6mNzlQdXOR/srEBGCeO9GF8bLuQ7bEn3KCk96yRm2b/YacIb7XCjxglagwJkQmGpK8GzPIDYAZV05uLBrBdyxhiSabzSi+DZiFNflBRHNkoXzyD9s5Qh10A2GVwmDt4d/dyCGrSrfmSShYcAAkYUZIHL2CbHYU7bend9FLsSfyAPyJ5ZXN6nQaMcXoZjxsolmukOk0vKq+Dq1vVWLLUR0n1OaWj3yEqw9bzKj++m9pwjwxmeMt9fwJ1o7E2IaJs8jnY3wLIyHZGZTSMZN6/luKomU6F6LV0nJpnAemEv6Ykwjx7pxnFmnYayXRItPT4P1t6QOKhtIXsbd3zAdmyZM1nMpT7Dd9uL+iQBb6jzfaCf/LG4pvS87SDsZ9fpR/obe4AuVP834iCDzARwgi9b5ID5JzZO55nhqYrdFU4i9KBsu1U50cJLv+UxwUAhtQVbqZuv9wZLwt9duVP7odjht4VGheGwwiXJf22fSma98eLfdUtgxhvw6uM4t6pRhfxqLNbbEY13HUP5HfpYsmmWVYAHn8brep3KaRw/JSdMLrqw6HJzsqxcFHShOjHOSRQT4NN0RDfYhC5yYv2Zl4rih4fx2kdkYRjPyQyS7d5uodAPo2Ufg5TXlrRfVZKSYTQGnLpZGQge4hhsOIP8+WeV4/EyWwHLcP9Oc6oJwPibLBhOmqAV/+dpULB8EKYdPNMmid2XY+mdt/kD9ll90q/uSN12f+kl/bBG1Zq7Jw8YIVxZWEBqwvCX2oIy9OZDly6cMiX7HnOFsOI9Oz3fstI8J8wkLC
 zdO2l5qB
 +NtiSO5DrQHDfEy3nnKT/rxD5ah5boGK+uw/yD8HFrWYCxjqqn4FOVIgBFH+iN9l8T/U8cusduk3TlmsKnxH5qa0KM4lQ32ESwD+kiMHsRGrhrPkXlAUdIYdNlmR5tCKacyatLgv+Rs4qIXiJ9AlY5ctHfnjfMMEfpM6HDrouuxbvykviDBKFEhvyOyYqMy6SYQ8LDpsZsDMBRGbFHuEgLemdrFwXvsqFQC0niVoRf7wTE1IUUDswsBSFhRxd9j1n9FEXzc/BW5N6WdHFrXrzmKQ44ZOqHA6gVLUIRdfhkPtt3Tqxr/ZK/nbPaQwJDX+eVL7I/3GKdjGqc/IrJOktDwxcrWnNTnXEJJlLZlZsBpjD1SMo3FTz0qFtsJxbbXZDr9wD97Je+6KKT5h1IQYwVoVEnCl/MCuQFcQ7mhn9XpGOQLI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 04:57:56PM +0800, Lance Yang wrote:
>
> On Wed, Jun 24, 2026 at 06:53:53AM +0000, Wei Yang wrote:
> >Commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration support
> >device-private entries") introduced the concept of device-private
> >PMD entries, but did not correctly update the rmap walk code to
> >account for them.
> >
> >As a result, when page_vma_mapped_walk() encounters device-private
> >PMD entries, it takes no action other than to acquire the PMD lock
> >and exit.
> >
> >However this is highly problematic for two reasons - firstly,
> >device private entries possess a PFN so check_pmd() needs to be
> >called to ensure an overlapping PFN range.
> >
> >Secondly, and more importantly, if PVMW_MIGRATION is set the
> >caller assumes the returned entry is a migration entry, resulting
> >in memory corruption when the caller tries to interpret the device
> >private entry as such.
> >
> >In addition, commit 146287290023 ("mm/huge_memory: implement
> >device-private THP splitting") allowed device private PMDs to be
> >split like THP mappings, but again did not update this code path.
> >
> >As a result, we might race a PMD split prior to acquiring the PMD
> >lock.
> >
> >This patch addresses all of these issues by invoking check_pmd(),
> >ensuring PMVW_MIGRATION is not set and checks whether a split raced
> >us we do for PMD THP and migration entries.
> >
> >Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
> >Cc: <stable@vger.kernel.org>
> >Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >Suggested-by: David Hildenbrand <david@kernel.org>
>
> Shouldn't we add
>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
>
> as well?
>
> v4 mostly follows Lorenzo's comments, code bits included. Feels only fair.

Thanks Lance :)

I'm kinda indifferent about it really, I'm really keen to ensure people sending
patches get the credit for their work, so if I send a patch in reply as a
shorthand for 'I think this might work better', I don't expect/require any
credit at all, it's just sometimes a quicker way of responding!

But if Wei wants to add a S-b that's fine by me also! :)

Cheers, Lorenzo

