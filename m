Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 999D2FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 10:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBDF26B0092; Tue, 28 Apr 2026 06:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E956F6B0093; Tue, 28 Apr 2026 06:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DABBB6B0095; Tue, 28 Apr 2026 06:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9F7A6B0092
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:34:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79E94A05CA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:34:52 +0000 (UTC)
X-FDA: 84707606424.30.519BD6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C18EA1A0012
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:34:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BeF7ZIEb;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777372490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SO/Xu3YsiqUqhGUi7eSq6WkolR58T48Mp70jwGUoWqs=;
	b=3d7rXhvwmoKPz5gFLWbdQItmRLHl0k9sN2idMfQ9eDQdF4aWlfbAJhCd3DYCgifKqHX3bd
	PASgaB/GOO8WAszc69AGW3ZXskbmxZsJfdp4vtGGxDB+wIrBU8qfTEfsSgObKiuUQht6ku
	nTIQuzKNsRxiyzcUpkIeMRypr0QCZDE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BeF7ZIEb;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777372490; a=rsa-sha256;
	cv=none;
	b=aT9GDl/ejZg8iaYD4fxOLodqjUukXnaVBl9CQPlPhtax/WD5vD6P0wmeQ7XMxoWUXs5uqn
	1wb54A9Mfx3TJ3HdU5fa58OcWSi+SeXlymOaxBM7Kje6H4TD+chiXK8JB1yZZv+0U+CYYQ
	QugQuW2NcWVZJKTG66vkIrk3gez9LLI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 37D5360142;
	Tue, 28 Apr 2026 10:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267AEC2BCB5;
	Tue, 28 Apr 2026 10:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372489;
	bh=b072BzhiuqAmE/8aKQg8EVxPqTvDJy75WhKYXf9p4jg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BeF7ZIEbDy55gHBZnKOQbKPchkjyYL9n8fWf0CU1G8DDwV6RsWsQ1IAgw2dC+2E8d
	 wj7L06wtFaoKR7KWFqdJ3Z9gc/9E4SDUouBVp++onqmJYyrbIlUWiXgsRaMIiVMaUK
	 NIZeuKN5JW1Juk+xle+9cLxBklOnpmdTQvK/mHtwpbRvDGl8IOfrnBUuXe3fTikIdX
	 v1mV6IRD3zRxjrP3inay+TCT6ejdaLXtDN6eRJ9ArAb/3/6+Z521EcVPkmK7C2gsMP
	 P+BHrOChMIMsb+v9ndLtLL1rzHpND/Rpj14es2FD0Ry9GkYIOYDYhtm6HEb6SkoQg7
	 Bhiju1yhXmJ0w==
Message-ID: <5148463f-5100-478e-a9dc-01ef3dce4c6c@kernel.org>
Date: Tue, 28 Apr 2026 12:34:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: fix freeing of PMD-sized vmemmap pages
To: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Mike Rapoport (Microsoft)"
 <rppt@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
References: <20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260428-vmemmap-v1-1-b2aa1e6db2c0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C18EA1A0012
X-Rspam-User: 
X-Stat-Signature: w66p7wrphfs3xzqptfc7sqjz89pzqp4t
X-HE-Tag: 1777372490-58210
X-HE-Meta: U2FsdGVkX1/nyvzZp9U10y3uTmbnrw6IoMKjKGCIiakn+yhz1YXi8+IKGTjsoUi5HH1MVhnZC591Fo9mXo+J4s2zOeJjjuJEjQlAWWkM1HsWMV1aOmBgTa/NrnVDbnFzzt8iWJ2Qh0Y8QKRxZbq5lKobvxlxOg6ycjLivUn2lZAN6yPVsaqcZzOanUqsBOZIubNMlIXSqVxxVQj7llSUXa/EnDHqk5unOSsHRQ8UDYvZRKZXp1Nmsm2d1gITPmokRYs2RppTkO6MERzuYUd+i6KIfdLZLapC9Ap0Ng60fW5Z98r0IwIGKm+NO3OT9Q7bA+plTiK5JnnTseJ/1hZmAr6kZ/Xk8f9Kz0jK52HZIceyUxBr6PdK6dVfIDnSrldtULAhS8eSB8sNQ/sVwKAKAG128Qqa64R7vsJHrx+uDS4f+7Tz0SIW5MYcJK1dqZGxLHEN39RHggNWVMJGSgrM8HwKElDMiBdGDOF2wkhBFKrx4va/QfZiHSF4stN/5rAil5xWILE4tgvOJJ+gvXgEFVMCSq2b4rwmVXQa7x7RHM0Rmzji3ieB0w9JUjVm+fKCfEQxqTUjoF85hKSkf9P0onldbD+zDlWPondTzggPjkL4HYCMN9y+b27WUXbDylBYhNsLUR93s8eUwAkjLSZosmspewuINtSQeyPYUvOWmWWws6bB/WytMCdzsvvhYccIKKRHOthMDq+s/seLBMNrhjwMTo4v3y+oxgj7r2k+2m/JKnSBRXSidPkF/DZ6k3KjIw2f03E3KeeY6/fYpx4FDdY7S6Kp1dIiCagCgo1uIpmZwV3m7NxeMjchxJJKDu9viFPqQ5FKwsNWA90Nf3lq745jaU264JZ1dNy8k1EphgYA7EfHyUzJH8pgC6xSRfCZbFMYFVmnJB9+IEJRRwo/7vC6Ls3d7Y1fzLr+5wodh9vwKaUJd2sZrL5A/yMh3IYLN/qSrn2uVnCUY0YVgrr
 S3fSYLvg
 +AIFXU+230BEDKBZLNJxvaHADmqzA0frPUS4pABQ7WhgVpOinVmNzZNo2UV5llvTaj8BSLmBHNATLcil4w13nUZ+k/8WidNcYox+W0ogGWXbEi+RXeGu2vHVTQxVtag8IkzKZbNedq7D49VjQFVeuoHMWAKrUnKo2YBVrHeMIsQiz/zpHnNenq/jYVcn9ZaUXVZxEiWVoowXMVOzsok4twycNMl+iFW8vYGzxuKAhrSO5Vn8DWLJyD/xwneZ/fLC9/oQe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  
> -static void __meminit free_hugepage_table(struct page *page,
> +static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
>  		struct vmem_altmap *altmap)
>  {
> -	if (altmap)
> -		vmem_altmap_free(altmap, PMD_SIZE / PAGE_SIZE);
> -	else
> -		free_pagetable(page, get_order(PMD_SIZE));
> +	if (altmap) {
> +		vmem_altmap_free(altmap, 1u << order);
> +	} else if (PageReserved(page)) {
> +		unsigned long nr_pages = 1 << order;

Staring at this code again, I should move that up so I can reuse it in the
vmem_altmap_free() call.

-- 
Cheers,

David

