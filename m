Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A10D29FEE
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBF316B0089; Wed, 14 Jan 2026 06:14:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0276B008C; Wed, 14 Jan 2026 06:14:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC6F6B0092; Wed, 14 Jan 2026 06:14:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 998F46B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:14:50 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5712BC1D85
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:14:50 +0000 (UTC)
X-FDA: 84330311940.15.482069C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B6950A000E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:14:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcnZFRw+;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768389288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VQN3TbbaoG5AGNaGLOpHUO2qtjj/Nq61z53cDOs+0Mg=;
	b=FU/dQDvGZjhYAze7RzlXiEuNqyAQe4a+GxVaNJDNCkX8aUY7jLEeRUhivMoWJk/ZlbU6RR
	Jon+iZ0IPwayDCEQiPVkRZF5sDGdQAmf6NVxXB5EvflGyMIu/KrAadkOQaTXwRTBfsirMP
	zm3b+XtZ/OPwcDkXFTdqmvAQSHuoTkI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcnZFRw+;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768389288; a=rsa-sha256;
	cv=none;
	b=hU2BMTi97sGC+N3aD4EZv6mDdhnezUlxvCrDTUEOb/MqDFHabrgNFhSdTS+IMqZfzHaLE2
	bbRy/U/zNtI2ca2zNGkADMi0CwgTpKlJNDzTApr2k9SLKu69Ragt/+UjmQBuit38/gCxk2
	ASopc3JfpI3uvC6gPVOAPLS6CPF0oc4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BB8D6001D;
	Wed, 14 Jan 2026 11:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C92FC4CEF7;
	Wed, 14 Jan 2026 11:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768389288;
	bh=l+5wlrp0jYxNQOqBaU6nlefHrlSNjYjWSsYitXtpAv4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dcnZFRw+cbJrDxYJFMr5mgj8kXqvSSa1VIr5LTnBjZQEy0DVHrN/4VWgX4+NfgEjG
	 +cL+7K4tRYZu2W0QsbNiDJAZ44zaSQv/FQJsc8f2yaTduI5xb1VcjLb9MXmE9AlUAf
	 dkUBkj5QOqoK2suJkmymaGeJcazZQUTh31uVZCfU0jOgp0m/Ls+q3qAyBBdqd0tCCi
	 Ggk/cFZ3/FBcTBig+blaqW/vgD27pe6mE0mukRh6NlF7NKlQMY1BzxpkcnXcXRpV3L
	 JsJlUPOLmyzGD8Lvf6koD9M6fvYaOVurf9vyLlQ6B9zRFTvNq1CLD1BSd8Wcl0RLk1
	 z3KmgLiQqI0YQ==
Message-ID: <9b43a8ca-e6fb-49f2-9a95-b5088c6d3352@kernel.org>
Date: Wed, 14 Jan 2026 12:14:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm: do not copy page tables unnecessarily for
 VM_UFFD_WP
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <clm@meta.com>
References: <20260114110006.1047071-1-lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260114110006.1047071-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B6950A000E
X-Stat-Signature: jr6mhqt4bghz4cmi76eiz5m7qnhgunsm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768389288-688597
X-HE-Meta: U2FsdGVkX1+SnvW3MB+xtrMYYtpbaWqk0eOTVm+akShUQyOBYSB9q4B+G0/oDKDdEq7F7JfjikXusUq7rLXu/Je389DWqUgbtvkpWj5nIkhMouZbVUUne3aM+lfUFB3NEQZb3R0cZVSzH2PGns7mw7nQJ6LyC0sHi8alNPS5l+ZfaFMtfTNnczP86Gwv8xKNpSX3wecOmEcKGjn10o8V/srNuE+D7cfFfd4wX5ofrJjqBQ6sWoFk94VVEiMTElfiX5Q2mTLMSGlXHdVyc5VRmuNfMBRmzLa8PTMWvfzVPcL0krkL52koGM6k08NM24dru5fsKRrGXwlQ5e0bJAJKQAT3geMHVbeQk0Jmct6Dr+yhwiwvaw0m5jS8kWdtKR/uENcotev52DjhIH3yZC/u6vVdVR/FuxkX6p1umr3jGzUdyv01tv++4LOKUTcpRiKateKhC8rF0YIRj6ncJpsHUIPO5H5v/Rw0jEOcBppQ87acEN6zO9Gc4uOhitB1rMJJVbzOwdD5OdZwy2KGi7Rla1QqWuAU3jJPmmimhW56FH4pLCt3kiSDPrivsTQwDwItV+7YErDQfMuCvmho2QsQjq2aZ+f7DiItRztsJWAQBaB2dG2b5EVIXl0MG+mA/UTXszi80AKYZ5MtGsVLoQawP+dK8J5gGcESX0RM1lJXFi5q3ExP6ffhBx7+aTQRKfkUfiThQFBhb9JjZeeVDA3JEGa3gZq86WlIsta4q1Un2qJ1D2LsSWUlKFrwhjCMrTO3eHNkDXQPyCqY5naCk4P54ypyHePL9LZtYmT9XiPR+fuKakOa2WL0s4tyhK2HZ/TPEkHACm/DnTnqnUqZb4UiIjJ8PpZRwSvD4R5P17Z/Inu3Fjzfz0muaZktjZncukTDOI3octAfaJKEou95H9A0+pKBCKjH3wEmoRUpFuZhEGhWfKNRFUXrTAxVhz/FDYhCs8dJ3wo3kf9DjtqeGBd
 WhN7Mmb+
 ee2CD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 12:00, Lorenzo Stoakes wrote:
> Commit ab04b530e7e8 ("mm: introduce copy-on-fork VMAs and make
> VM_MAYBE_GUARD one") aggregates flags checks in vma_needs_copy(), including
> VM_UFFD_WP.
> 
> However in doing so, it incorrectly performed this check against
> src_vma. This check was done on the assumption that all relevant flags are
> copied upon fork.
> 
> However the userfaultfd logic is very innovative in that it implements
> custom logic on fork in dup_userfaultfd(), including a rather well hidden
> case where lacking UFFD_FEATURE_EVENT_FORK causes VM_UFFD_WP to not be
> propagated to the destination VMA.
> 
> And indeed, vma_needs_copy(), prior to this patch, did check this property
> on dst_vma, not src_vma.
> 
> Since all the other relevant flags are copied on fork, we can simply fix
> this by checking against dst_vma.
> 
> While we're here, we fix a comment against VM_COPY_ON_FORK (noting that it
> did indeed already reference dst_vma) to make it abundantly clear that we
> must check against the destination VMA.
> 
> Reported-by: Chris Mason <clm@meta.com>
> Closes: https://lore.kernel.org/all/20260113231257.3002271-1-clm@meta.com/
> Fixes: ab04b530e7e8 ("mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one")
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

