Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CFDDC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B966B00F4; Mon, 17 Aug 2026 12:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803706B00F5; Mon, 17 Aug 2026 12:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A0F6B00F6; Mon, 17 Aug 2026 12:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE4F6B00F4
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:24:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC6D6807DF
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:24:57 +0000 (UTC)
X-FDA: 85111285434.10.F49A9E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2DFF818000F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:24:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJVzTsn8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786983896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c5CU30hf+MXBRHB8OXc7DblMS9Myra57RuQWaqX120Y=;
	b=SH4OfZn3lt+i+FuPH7mqzFk3FKdN22b2lgqWsFDK3UhGqhrnMOHJHL36kViFZ2lpqZpUig
	4r3xFZhtb4MbrRvKQa7ONd24zyLVydP8JWU11FTYacv6CyfK4bYKyw+XcxeDqib6TC8SRD
	3EVKi522gqJjfTRKGnIjFC0r6TTKYxY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PJVzTsn8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786983896;
	b=UgXlFIHVv51nrpWSvgXP+3ImYMY2Hi52OrdYhokET/qKqlyIVg9nlusb2hJfjj8eCAWbee
	uulkAhTAJcRrRotvMAtKQQHnmvFfoUorwujj5aZu4ObyknTcO8xZdzUB8h6CEZB4i/fHWL
	L82A3FQ3gjqF+/m6NQCejhfFhfZrrHc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A21B8601E0;
	Mon, 17 Aug 2026 16:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5831F000E9;
	Mon, 17 Aug 2026 16:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786983895;
	bh=c5CU30hf+MXBRHB8OXc7DblMS9Myra57RuQWaqX120Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PJVzTsn8qnM3BwB9BgTg/LvNeYXnPQsvVcU4MYqNHmq5qkQ/tReJgUdUVK8iKBhp3
	 BB2ZgNzWfwWT2Ah3uFVhvN4MXQw12bRYLVnmEdxiwds4bVH/Hkgmn9bmAMWsEHepNs
	 7hZ6ZCHYhd9ZhXd4V3CYlTk0QpLlEtLYNfw+EEiIgOIXTRFy/wXgoYyjyazHF0dvfy
	 3sh8QjuJ9obb5Cx5Hrb2neGzGKSQeVrEQfedVClEs848shDPB3jOXRceOQMlkOTg+U
	 XIOq8EvqmpRZI5HQ4M6JrItRfJ9Hhp4LBw7rrZI26T/QBkueevkdYjHiEF56DBH/7R
	 H6J0ZFZMvFFvw==
Date: Mon, 17 Aug 2026 17:24:36 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, usama.arif@linux.dev, zokeefe@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Vernon Yang <yanglincheng@kylinos.cn>, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mm: khugepaged: fix swap entry value to
 folio_pfn()
Message-ID: <aoM1kq6fWvCFXobj@lucifer>
References: <20260815051924.194810-1-vernon2gm@gmail.com>
 <20260815051924.194810-2-vernon2gm@gmail.com>
 <aoMs79VDCnYvA9S7@lucifer>
 <cf1d271c-f002-427a-a843-00a1fbc59251@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf1d271c-f002-427a-a843-00a1fbc59251@kernel.org>
X-Rspam-User: 
X-Stat-Signature: bwzay6uhdhpmfkkojk9983myy4c5obiy
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2DFF818000F
X-HE-Tag: 1786983896-836797
X-HE-Meta: U2FsdGVkX19NQco/ZkapDfKtNz8xZbjAgoEi4dOrQnbhoPVvIqsEBa6yrBUfevPobsC7bgrEpaOmLPBHfgmV8CduNYV6lHcf/Pk8GSUlt7AIQ3lPuvOWO7FW8SIKn38i3uzqjhufrAyTOFVeC1YYg3JS82ztiwKUZh4Bt+Gk7VmgafbhQiAidKovcl62aIwF5OU+K3ncXQEfyv/ttUVvzXfFqlXYAtJE0nKKvnwtUUiNlDjZ3FqYGK2zsqYAQU3hJLIxzRCuccANm9msCoLKOm1i0c5bh3T9vd8ln3CG3zq85vFHRKJJtuFQ8pfX7HeAqUAb0CT9RDLh0fXyxcug+dkjgJyDspIcGeNQatjU+rY0e98Mo8pPABqQAajgQaKZvTnAzfwYtxK8R8I7gY603HVW0ualqrHNuETSwejIBnzCkK0m6+J8kweHF/8tKlEmimqzgDpLVBtuaHgj41s1vmImzITTHV7hYqDfXFKcZHQTuqe7oPfo6b50B6pkty/bQcqEsfpLLPqvaaxuQpqhpzH4C06EOV50hzIud45LsTMfjfT7MtDGUuUst0nnHoroYcbzj8OTsgj0Cx3bMNGFXfC0cswa/mbGrimMGnC7oeYNF4VFmslo6AHT4NIuykD0JzQ7agNwHK/vW1keG8m8BCesYmeij/Fp5TpU+R71njpQqkcxt0sKUF80bd8rfttLkUOEg2qMCyKjDHQmf0zFPPHgPw8vQCera3KzfUxeYpcAJ23cbXB2iYcJ/Ab0qRVRrIjEgGf3/4cJGiNmghMRz3JZjHyVxNWgt5t+6ijpqQWSdRGfzeISXDjGk/hIgnWNvthYk4Bf7DEFUm68DMcTbmpW4iu3wmr+fecXxTzuTbsAKpYSlFzkgWEQuXpbCtKgjanbb129PiMU6/lsaRWAmR1Gex38N5uE/mbM/6BgYNZgCakN52k44pmbFoF5PPbSzfP3PXtVWHuwx6JHx7P
 ox5/j9GJ
 Cj11WgVAyYq0Mcs7pKQPlDMZay/EfD4SilQuB5gyDAuhbVzUZsIv1lt+35IeqlP74mVobmAtwzOtddFBqvnTmNoqUkMxgKcrGvsNEyqzWZdwAxjrjr3GaFTk9Ssr9cFaSP0k3xIR8IGGQmIqlbMOuHBRCGGaxYEhV31BHSsiSwzBhW42da4VbUk8VWMpybyYg++n3Fb2NZNuivB3uYLC6ofi3S6App+fF/s+c0GHiVoMuWET1alV0cHkn1ud95U1mGpbpqFHoxxdoIVojRhYtZartiXB1nexgjtJfLcKpAC2t8qI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 06:19:16PM +0200, David Hildenbrand (Arm) wrote:
>
> > I mean maybe better to just reduce this to something like:
> >
> > 	/* folio is NULL unless exited early. */
> > 	trace_mm_khugepaged_scan_file(mm,
> > 			(!folio || xa_is_value(folio)) ? -1 : folio_pfn(folio),
> > 			file, present, swap, result);
> >
> > As the least invasive way of fixing the trace + limiting the contageon?
>
> I raised that using a folio after dropping relevant refs+locks is in general an
> anti-pattern (IOW wrong if folios can just get split afterwards and are suddenly
> no longer folios).
>
> I'd like us to avoid that where possible (and suspect Willy will thank us later ;) )
>
> Isn't there some minimal way to just calculate the pfn once we obtain a folio? I
> was assuming that there should be an easier way to do that.

See my reply-to-self. My initial reply was wrong because parisc + mips do
actually do classic sparsemem (sigh).

I suggest what you're saying here basically.

(Moving folio_put()'s for the break cases out of the loop is nasty)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

