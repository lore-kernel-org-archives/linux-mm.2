Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184EBCCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73A8C8E00BA; Mon,  3 Nov 2025 13:05:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712628E00B8; Mon,  3 Nov 2025 13:05:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 650138E00BA; Mon,  3 Nov 2025 13:05:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 557858E00B8
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:05:56 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7B19140257
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:05:55 +0000 (UTC)
X-FDA: 84070074270.29.85E792B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 20FD218001B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:05:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P0Q6iZmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762193154; a=rsa-sha256;
	cv=none;
	b=LuZ/9xcApLkDNDMF59Ot+X5RnPgbhj/PzR+SRBibbyPPXMb/IaUG8Nu7ieNY0lGp2n0kQU
	eGmuAIIe8lnFx5yh2ZEy3sK4+4T9H1OjveVo60OJvVtJyDwMJLcnBCX2Z8jgJk+rYR9NHv
	bI0GfGHh2rCenUz5je2aoSs63GU6BC4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P0Q6iZmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762193154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6seromeMTWTBbWW3qSVoSk/BB+DI+NhvBkE7gi6VJg=;
	b=GKvSsqsS8f6pLf5O2D92aWEGRwwa1Kx32YGosASmiLiDKE3xOlDQxShPYamPdChz1QfDJt
	6fVuhTIaWIng9t3H8i0j6jTt3iOCzVKcIJLVVl+dcStudetcY0/mji3wpAHBgXyxiq/H8l
	6G35+M2DohbsAI9vQAr+0gDO5HiMDdI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2680043D52;
	Mon,  3 Nov 2025 18:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB36C4CEE7;
	Mon,  3 Nov 2025 18:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762193153;
	bh=+64iKrvV3aelQ+MDxd4Vv/MtBZ3N2qzpU9GTaRPio/U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=P0Q6iZmJK/NA+gbfeQInwBVD+j/Mn4E1i/RYRGFSSkO9j48VXUBSt4qX7JDbU9/sh
	 oQaUywp3A+5CnhS2iXAStJ0jiuKL+Iz79AezYdKAOdkZHlIlnXylhHGjX+X6iqj+IF
	 n6QlkUu4/grO0RvSCHPixVuKjT1yJPWqvv9s+/q1qzlfKkH/iNA1Tqe55xboZrNhm1
	 LKekEXOUMr07Yqs22nUM1noYOwUY6u3H1N1Zz1ZLfekCtPCeFvHjyRJJ3G2jxZ6raM
	 Gsh6bOPS3mkh2oaFKdjmn7dcQlkMDUwbWf+FxdzN1FWZHRr4dNx82XokKVxrHSed4T
	 0zF60vTlv8V8g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org,
  yanjun.zhu@linux.dev
Subject: Re: [PATCH v9 3/9] kho: add interfaces to unpreserve folios, page
 ranges, and vmalloc
In-Reply-To: <20251101142325.1326536-4-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Sat, 1 Nov 2025 10:23:19 -0400")
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
	<20251101142325.1326536-4-pasha.tatashin@soleen.com>
Date: Mon, 03 Nov 2025 19:05:49 +0100
Message-ID: <mafs08qgnc7pe.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 20FD218001B
X-Stat-Signature: y7qsddo7sgp5dze4z34194jozccgi58w
X-HE-Tag: 1762193153-188034
X-HE-Meta: U2FsdGVkX1+5BCrYmk2dd01K9zkR4hFIc2g6CuAp6t5wJRCv+PsktqexLJAjNbBj8QXUVI9t2WfEQQw7oFPslz4hvlr7rhBAY8pUZ6v8WMK6n2ABQpQXtO+gdYfbBxW+98qninWkWu8EvOL4RJRWEPo3/FuL4zR4+np4RlooHK72+BuktxzmjLeET1LfZpbE8z6QCnWI7QDCtqHgaJbcKV4MAc4ZtmyvEgGwWT0eE+F7adJ/ScgJ6GUrfyiOwGKe5cqlCdYev71aE9nH37VtoKbF4oZ4MNPfgUTWsUJmGZ4OajeWoIAjioAMLg54yU7KuzndWRXTi71NNc3XrgSOE0SAoHbdKAxJxWk4W+FQn5gEuOzvRnOW4UHoubJRe8M+MrrVB7EfADmCyJ0JgmFPEND+CkFgsrFxfSUjL/Z64PqMNRdg355vh7lVdIRMk40qCAwEBOelkUM/vfe0PO7HMS3n8rkXmQ6b87696ihMJE9I2Ftx5C96A//p+AbhfC2ARBJS4qeJJrdXhi9GOpOmuqcP0b4JpvA83xss6DUjZbIKHW3kU4FpbA9xLWWrHclaXUQUYxl+JUjF7W4o49RzKwnuhJAmU2wva3+6lrmMBCitblrpHYFfr/7VqNJa6As/bASCKHHMA1jMnqaKOTc3kc4/AIonVYXf+JMJGKN+aDPVOpvCaR6z80FXrgM8ep8IyQj81iKeeigUr1pb8oWwAWV9ouPMKdrKrNaEesLCHjvLnDk9CPbet/kxcc6luKBBeuMmBocyOQ6qkYqMxqPY2RTMS30n0ESh2CUX2vvIyAdBpSjrQetVaYrg7iGnJekyJvddM4gHxNBOq7NHLzE00AVosQ1OPQXy6TozlHcMcIRdxPq7l5rJ4MZvEZ74fXdbokO+nCWfL1Nh9sLl/l/BhPAdgPBR4siYnbq/iHmIaRWISxWAZgpVNllSaQHhmz74UtpRJW2AH5w0Xb85SRC
 YqQ6em/C
 J1DdFVXZsFPmLIK6JOsYyZBFecpTI5/zDBTBgf2YSWv4Ppj5p+GYtEyvdKQ0cJ33lPMaRhJNRNZYOabWyvb9L6P+dXIFVP3eYENR1ARALOuEh9bb982YVN7N+/9S1i9INP2jBC/VdFDNNiO1uzMS++3/x0+RJywa8DGe7sbBWHR9JaUlKTGnuDK2hQvrbdespq1egQdO4safxfiRCxQPYN3qwV3OmUzR0p7DbIKMZBfUALNj9cYPTHFqXX4pphNxUREZ8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pasha,

On Sat, Nov 01 2025, Pasha Tatashin wrote:

> Allow users of KHO to cancel the previous preservation by adding the
> necessary interfaces to unpreserve folio, pages, and vmallocs.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
[...]
> +/**
> + * kho_unpreserve_vmalloc - unpreserve memory allocated with vmalloc()
> + * @preservation: preservation metadata returned by kho_preserve_vmalloc()
> + *
> + * Instructs KHO to unpreserve the area in vmalloc address space that was
> + * previously preserved with kho_preserve_vmalloc().
> + *
> + * Return: 0 on success, error code on failure
> + */
> +int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
> +{
> +	if (kho_out.finalized)
> +		return -EBUSY;
> +
> +	kho_vmalloc_free_chunks(preservation);

When reviewing this patch, I spotted that kho_vmalloc_free_chunks() is
broken. Well it happens to work if all pages are 0-order, but breaks on
higher-order allocations.

I have sent a separate patch [0] to fix this on top of mm-stable. It
doesn't have a conflict with this patch so it shouldn't cause trouble.
And I **don't** think it should block this patch either. This is mostly
a heads up.

[0] https://lore.kernel.org/linux-mm/20251103180235.71409-2-pratyush@kernel.org/T/#u

-- 
Regards,
Pratyush Yadav

