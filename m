Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 152C6C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145306B009F; Fri, 31 Jul 2026 14:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F68C6B00A0; Fri, 31 Jul 2026 14:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B9E6B00A2; Fri, 31 Jul 2026 14:15:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D62296B009F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:15:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E5E31204EA
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:15:11 +0000 (UTC)
X-FDA: 85049873622.17.5F4F9D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 934371A0004
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:15:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v59wuXay;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785521709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TYjCuGD0pO2ANa5DVGnegL9SjFstEyINvHwzqN4rDkE=;
	b=bY8BSqKRHBbCkuYZi0LaKTG1PIgCLvj6fvcEMgKexYtS3C3NDMIJ3nasWkbABiN2ghgeJC
	8DqBR+Z7jg0swN9CnA8tjCJZ0ZmGCQBOf6G/9SD8TELBP5Fd/jP6ZHdeHlyCIbJxnUSarK
	lD+1o9ZEyLKcP/rPEH/cX5/O6YXwPME=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785521709;
	b=QxV+2q5qvtQVJc09xCnNRu0RCcidms7vnbSbyV9jO5ZJO0Drw4UEKKfSR8ri8ws3VSuixo
	+F+YzOl87eA++1LR83q9sI/DFb0ecqXUb8WjbZNIEcOV0TB87cMVujXCg+dx1+F8g4Zqrq
	7ZWe5EeZg4++YuAqIOfJFyu++4hit8w=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v59wuXay;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D922843582;
	Fri, 31 Jul 2026 18:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AD01F00ACA;
	Fri, 31 Jul 2026 18:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785521707;
	bh=TYjCuGD0pO2ANa5DVGnegL9SjFstEyINvHwzqN4rDkE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=v59wuXay31zPspTTf4mm9ubsz+mm7aYDP0gWzG+bxn+oDvKn48xSkU3q8+yL0ihY6
	 Y7aREg0tzLTwDSUTXFsT7akakk87yUUrBuj/2E3CU9RklXGLiaJhtq3cssoQAP42bF
	 U5dqnnZgRNhDOK0pWy8g18iApifRPIiBBu+VC3Jc=
Date: Fri, 31 Jul 2026 11:15:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH] mm/sparse: correct init section annotations
Message-Id: <20260731111506.ed0bc4b98228e4a9e5bf283a@linux-foundation.org>
In-Reply-To: <20260731164758.1210668-1-ekffu200098@gmail.com>
References: <20260731164758.1210668-1-ekffu200098@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 934371A0004
X-Stat-Signature: zt8re3fftonoqb6r9z839nq49ks7niqh
X-Rspam-User: 
X-HE-Tag: 1785521709-741564
X-HE-Meta: U2FsdGVkX1+Jkfvcoo3ugD+knvtUf3WEYVCXriPqsi2TRt8CBCIielK3Q6JfkM/W1gz+dexIIZQEmn8cLcFG+ENUVKtU6FMR6cx/7JX4gcQy30sFKptkMDEEw8CjyKjsh66MKFOmrzxxUbF74svFwGx3Gk4jn6w4rPNfCRZ3Cma/IYTZxcLGyw75lsxxGbuOg59STqiCf5mUAnMaTBoHXMtT6zfaXpUIVz4bSVdR57fN78comk3DkJo6+QS8PiAIqlBNnZgSGFmvMfdhHykGJY7k4upD32l0bdMAF9BB3KaSMX7y2xmi33VIPb8J5XDtCV291EL8s0TFhiq5bx9+QntIL6pIy2D0FVgMNL04ww2QVJ0B+nYqrTG2b1y2sCA3g+DvYgGEQR/BxyTu/IxOoobd7R8DXuLZUFgXi4SxbH5StNiksLm5UrMeZMBOUZuvvKPl2MqRlHFinSo7mYr1TBixLDZVgeMpGG1TuHcuGDX+ZKKeykI4SdIQ8BXnlPNRN91Uzk63Ms7kzpGvtOyodXEcDFqwAhBzptEZ+e33MtxKCWULo2LgGJjhzcFVQRBSYZ2dPXWJEBRUSSJpYI8U7qphDjezN78JkFGcYkl+s64mmluhggXsJhgzKq6hgBX10DTTLak2cPVIszX2snTLKwFYWpBBGx7REvu0PglCqhG1lPnf0IkhBy+3H5Gk/K4wTjW/+X7wcBwdoLRqqGflBHVF5NlIr8jIrZ0YaqlADx5HrzdS4s7H1CFeO87PojPzYVNdJl9glbJTVkCzeQlOqdMze5rGFbiPS3cRxKYy4rERyvc4Or9bxjRyAYTEcVwVqUfpRYXOfrUByyECQ0xK6AMI0HudGi0pMs+qoJ3vSJ+vW4nOeqvCOgkc9zAgJdMquNBozHYwIc/Yd0Udz2su3ZLj5tO/bsbqPIotF+A/BRNKvKgLIP0GkwY+SFGLQ+ZvtMvmHma+L03OrEQ0de8
 zQscUduj
 vOuLqSupU1ODGaT0TuQzAbY3bYYr3A9geOFXoub8NqorBlNFuGsogu5m0rtX/wwEcxzki1EGfJ9FAxOLPgQXuvSkm0K+EXKsHfAJYjcdiBHZhSHsqgmNauiOdfVUDX4E3ngbyzI0aybP2xNEltGqpRHAaZDOug7hNFm5Paay0KfE4bg+W3+ZiwXWW7e8n4hFyWXjM/tuNkrFsY+ynaVt9x0lgvhyA32+UJjF1wLJk6a3CvFHux1vdHv1aZAa8bKELsiN6fTKKylDAbPrSQpppC1vnzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  1 Aug 2026 01:47:55 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> The !SPARSEMEM_EXTREME stub of sparse_index_init() has no annotation
> but the SPARSEMEM_EXTREME variant is __meminit. So mark the stub
> __meminit too.
> 
> mminit_validate_memmodel_limits() is only called by memory_present(),
> which is __init. So mark it __init.
> 
> sparse_usagebuf and sparse_usagebuf_end are only used by
> sparse_init_early_section(), sparse_usage_init() and sparse_usage_fini(),
> which are all __init. So mark them __initdata.
> 

lgtm, thanks.

> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -104,7 +104,7 @@ int __meminit sparse_index_init(unsigned long section_nr, int nid)
>  	return 0;
>  }
>  #else /* !SPARSEMEM_EXTREME */
> -int sparse_index_init(unsigned long section_nr, int nid)
> +int __meminit sparse_index_init(unsigned long section_nr, int nid)
>  {
>  	return 0;
>  }

We could make this

#ifndef CONFIG_SPARSEMEM_EXTREME
static inline int __meminit sparse_index_init(unsigned long section_nr, int nid)
{
	return 0;
}
#endif

in a header and make it go away altogether.


