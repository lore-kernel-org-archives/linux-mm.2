Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 464D6CD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 11:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C1346B0088; Fri, 19 Jun 2026 07:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372E46B008A; Fri, 19 Jun 2026 07:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260BF6B008C; Fri, 19 Jun 2026 07:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 034876B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:40:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60F00A03FA
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:40:07 +0000 (UTC)
X-FDA: 84896468454.15.7A1AC51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A76E140010
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:40:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mcWSJyJ8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781869205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/CMueLUvoBZCpnV+APlbTSOQx1t+T8PMTKYxqJksQY=;
	b=0z1GyMBwUoEhJAV0/Tl/RGRpe7Ow2492+mFxCUznHt5nQBz6yiXFVk5v9uCj5rMXfPWavH
	t5rRnCBEIrzgMU9KP2B8EggdVeg0Apr9hrnoZ+v7yqx8VFYHqnfYU4RCkWQzq+5wX5upmA
	qvMOhFfktmrENyKrqLSq1kxPujXkvpU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781869205;
	b=sHBSgbwvH7PQQ8RZgD8uIw/0b5QOJUPPA9K03m+i+/TqiQX2mCHJDP+gcwiFFqkXdurAyU
	U9LUXrK+09Oupf3zmedPRp7KELyMn/DmP0AjLsF9i7JZ4Si2U5fViwjlEA51ujHSYbsQY7
	gXg7xMPdFKIyq5cZpcV5LudGdRUT8s8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mcWSJyJ8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22B9B601E1;
	Fri, 19 Jun 2026 11:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49FF1F000E9;
	Fri, 19 Jun 2026 11:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781869204;
	bh=w/CMueLUvoBZCpnV+APlbTSOQx1t+T8PMTKYxqJksQY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mcWSJyJ8F4DyIgD5jaNgEe5f3mve2YsB2obCKAUuzdlROxWKzqKBg+8x/fChr3rce
	 TexRqWk05HivtuYtfFUT0LXSW7oFTPmRGV9t87NgXSKzoH20G/EZNQt+/Dce5kXAv7
	 Wjye439wckr6o/+qD1K7vQlW8OKStazLQ9lC4q8x9qYTOLmL2/ZD8wqydvvaC+OKsJ
	 WqbVW+iSJC3AOaWb6fi0vGeanhbknp9qLPlezcl8u9Ntr7mqZb3SdgA4jywzEz5n5t
	 PFKwBHhqOAuvd8toU1HjE8OKBJA3wV5LNzut25gNC1SOUmIWyBvaI4E+h7JDDjVQ6L
	 AxAEEdyDMYnLg==
Message-ID: <a92d0118-eacc-469d-9667-050193d11f51@kernel.org>
Date: Fri, 19 Jun 2026 13:40:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead to
 VMA boundaries"
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Frederick Mayle <fmayle@google.com>, Kalesh Singh
 <kaleshsingh@google.com>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260619112852.104213-1-ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260619112852.104213-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A76E140010
X-Stat-Signature: cog3dz3jf5gsbdy5gzozbfqut8tnpe9y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781869205-320892
X-HE-Meta: U2FsdGVkX18xK0tuLs+8yio4soPIDxdb+llufUkg76NryD8RJ6qkx+q6a/RxdXdhJz6+c+Utqh2pwMt5ayERgirr0hPe6pxTf1DRWm4MXZoT9DehczLMF6waH6zK3kYQTGzN/ALGZs2j+E3RVVnT1Z5NvZq1HxuXunO1Xp2DUQIB8BroPMRlTgUT/xxALLJIC3Orric6dRY0uvM6H75WyCwF+mEUOUFLoxNiOiXiKTFiSXlGTnTzILdlUdzbP07DN6GwqXPTEapIwRNSm2adcqXTYrIJGC4OvjkzZvF4D2gIyqILdflhSx4YHTwoklR20vEDpyAM3ypFIXFvi0Jo5wCX+x90Ixn4wQsSLINuKtJxjG7K6AVijqRoqaBhKIMDTosv6tN7pINw+BJlCrh1q0rVZHOxToQL0hZKsPNGWD8YTEN9lCgo0mUQeNl3CS6o1Sc/jznHQL6KD5KZi/W8K0f0qzKMcrtGpMqv5EjC9vHuhEfvADmyHaOc3P+PG51XuxWBkDVi+TkYFlwaxXnrlB7tU+zsp5L5u4FGqrYOVybTBytDjutIez1NdfrMaJi+I+ay9cksCjGTaTey6BvDTk2z4nfxX/RWLnXc25Eo0u2zKeOnSRbGATHGwRZdLwL4Fp+5p5nxK2abgOsaezD97Cl7UdWfV+q0sVm0j+gp1yyF1p/gO1fbO94DSs19fVHjDF6j7WFH7ye/71+62m87EKhVCvXTEG+VNhqavZekJHmHHND7Ajvyzo4f0A1F0o6mQqaiSq7mZlSb7wwj1QLXoG+ByuH7ihyroyUTwyzDc6mGZ9UrhkYr70ngQnP0vBQD9q6S5iYaKD9NHqmI3fEnD8eO6MVyFStBV/ZOFiW4qwOht7bOCCawUu/8T2mlTcLIHC9kZ51EynKSsVywD0U0iVZae/w4l/vQHgT++FYR58GtLSu6xBcC7fO3bhgRLq3M/SysvMrKhyxmGlhmrIf
 w40YWA5/
 +i9EwFPE4hWHFwd35UGWZt8pEjnV1Dgzj0s4ys5pLY0P2plMhhMF6W58AmiQg/bvIHMcdt4G/QUS4cPyRuF/lG2uveAXeX70RT5TBmQPWOvUDoCi+NjVhcel6XDKypEoFWvmNOauJ6t3MH6m3zKjcTaF8Yug/rKcYI0CdJohmY1sopywny5ZPv70scplHiJdRCYtnoddX2RS9bsCMAIltepzewRFxFS3/a07VmVIYasJ9bgaJLlACqPwhbLdMtB9bQOFhnONq7WrC6GbgtoEcCZSSNSG3mrG789QCV5bmiIV0UN/Wkx1m3fMzgR70c/1puzmCAz6jn1yxcpAjUzqJLQOyGfPG3v/Tb0ioXQUDW9cTTikngeYVq36skA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/19/26 13:28, Lorenzo Stoakes wrote:
> This reverts commit 7b32f64bc512b40b268776c5ac4d354b325b3197.
> 
> This patch caused a significant performance regression, so revert it, and
> we can determine whether the approach is sensible or not moving forwards,
> and if so how to avoid this.
> 
> There was a merge conflict with commit de97ae6222c1 ("mm/readahead: no
> PG_readahead on EOF"), care was taken to ensure that the revert retained the
> behaviour of this patch and cleanly reverts commit 7b32f64bc512 ("mm: limit
> filemap_fault readahead to VMA boundaries") only.
> 
> Fixes: 7b32f64bc512 ("mm: limit filemap_fault readahead to VMA boundaries")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202606181547.617a6967-lkp@intel.com
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

