Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0878E60A2603
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IRknnUZY
Received: by kanga.kvack.org (Postfix)
	id 632B36B05B1; Mon,  2 Nov 2026 05:18:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BBCE6B05B2; Mon,  2 Nov 2026 05:18:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40EFC6B05B3; Mon,  2 Nov 2026 05:18:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1116B05B1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:18:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9267C40C7B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:40 +0000 (UTC)
X-FDA: 85389780000.17.ACF34AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id E61EC140007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:18:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IRknnUZY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793614718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7IUJhNhxhhzwfLlR3ygV5Jof/W3+MUpoySHAqOWKyA=;
	b=P4DVXD/c0SPaY/7CVkBtZM5MWTLa4R77v6HnEe+G+v/LlQDJ87wWLukoll62GjDIYAWDd9
	PxVTH5antUUgf1WPmnu2iOp1ocvJKLPZqnJszwDn3aLEJycpGaRpL73+Z2Y/tFC6HvdtX+
	a8t/E53ikk1JGONcdTlBaPlma6Jz2Sw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IRknnUZY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793614718;
	b=t9juF/m8s276l0yA29yoTLxCwRoaZsaKP2EnBgn1JBOirjrBMP2D87tZ49HGW3nd9JSYp5
	bp9QTwZqHNf2xYWolIsFZeeOfkpm4iBc52c1mPQ+lph8BbbEwzfwihLA21tWMavkCg1fHK
	9XwrMqWL79Wq/TB6ANzr2z60VZMRdFE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67C2F60F1F;
	Mon,  2 Nov 2026 10:18:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5651F000C1;
	Mon,  2 Nov 2026 10:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793614718;
	bh=t7IUJhNhxhhzwfLlR3ygV5Jof/W3+MUpoySHAqOWKyA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=IRknnUZYiFYPxfe79PW1lclwilUSf2HndJ+nFLmOsfKXjYmxDdKlwxHtuiqKteqDu
	 doWDqgILUEAiH8UOh5zQ8lIq5AcpVZXUogkZmtR048UqpaCJwyzHRtHm9EGSPf6Ar/
	 xVUfKPG/boaqSO0UNeIYC1pbm/m2j4/Sc/cwtXHj9XwZBYIo1TKIeR770RuKToas7a
	 2FdY1irPaY9EA8t2MTqZuxAD/mTUdQ6Cwqduen/c/s+DcWma+jreGgS2Jt8KiPlAZ2
	 rBfMIQhU9Ou9yS7t07qbst+VPM5+kSRW4Cs2OcwyyoyrBEnLaCbPB8fSm3PEkPoEJW
	 +8B8Ej+ENaHGA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 01/12] mm: hugetlb_vmemmap: remove HugeTLB-specific
 vmemmap optimization macros
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261102032525.3597743-2-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
 <20261102032525.3597743-2-songmuchun@bytedance.com>
Date: Mon, 02 Nov 2026 12:18:31 +0200
Message-Id: <179361471103.1337633.7688636981103619415.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Queue-Id: E61EC140007
X-Stat-Signature: ghwnhttoo5j8s7hafqikij4zd6w8rg1p
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793614718-96743
X-HE-Meta: U2FsdGVkX1/z3aGUaU0+uIIwgbjfrH7vmFvFlZyGLTViBSBQ+Gmt8cEjGIE21b5kZaaSXqMFdFDpGSRtpTiBorJInqfCP6VknCaT0TdnW1nu95wxUax3jzRfUe4mR1Z+WK5mOAogyELrlGia0snwIv3Dxo/1uEz6+enBJffkto1O7bZLM9PSDnGJ08/BI8xjqaPas3izPrVwMno9vgKThCbgUpkS+TRqpfKRLw1ZVoHlocNF0w2xccIlHzc2LUEynBRxC7I/8RDccR0vKud1ILOwSMCubVZvXl78u6vT4XrdaVL7IMdYLJAgHeZUffmkT1B6huDgfQyosugrvyPXf20qLwJHo1YpSXmzmmN9sGMUfVvRhLFvkDk7YzGoGsbb66qfI0ljzgc/RB/T2Nn7rFN+ocUzDoupWcUJ6/OfKvPHEbjg/Rm1/J7xShvLNLyhupkyB7nkxCAImdtlnkA+dDJQ1sGQTikcL2z0It/g69aCxVneSK0C29WNtd3LvgwRDyR75vZuHe/SJWvGtm9w0h+XUPp7W8QclVS7IdqbnXeiJUiww9ha3XRD3Imj7LkubGAdjyIgDmBxlItSvAFlfXLFkMKwKwm/n8c568LYd8LDB6MBZKLTCHqxMx0jyquqfR7In536ONsnrNR2Qxx5M9IY3/394Vc1GpFdR2Dx+fyyOKE5NiaYJ7I31m0UpH77rQBECbabDvtV5/arqp+BMlE6RdZ55f0KpheGdBmD4tMMaMtLuuruaf1Ky1rtytGOMo3VZxcrQVHjy6KCr3aVmpJN6FJuXVN0GNXfx/8KLHVzg8iFBDBoQBOdxuWZNiQPfFSw4BZUmIB4NoogCak7cJ3VS90mBB/0T8D/FsnVx6hQWQnz3eRWxS4C8NsoB4OOp+X2FxjrabANFdnQCFO0Ta3W6ceuL73X7OuAaj+ftY66lGuYl3EPIJJJq/02cIjbijpS/Odja/qmcw5u0Td
 ve5zQLLO
 7RExvx2dYccYGnBBqbE/VPycGO7FhklY1ns2yysrlSvHIIOVMAdS2nCkEoNb/bOSLnpF6TvRNmiEJxQ0YoRLiHXgbD00GxabOiP9INVQnlqBx8Qozc39hLXsuKTuJ2yIzl+kEcmF89FzDU7SxwwloogyOm8kOZZ4kR6eVsfTkVr2XKI56FQRfiWarm1nc7Mi4Rc9N9B/WJKSCF+IFtISp59XgUppJqSbSZlNd9NKnpm83nJiuvNXBfoklu6UMYMCpRckt/aaCCIFCQIfSAtqbW8YBcfBmZyTiCfzcovLa84t8P95P+PRyJ+k/tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 11:25:14 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Vmemmap optimization is no longer HugeTLB-specific, so the remaining
> HugeTLB-local reserve macros are redundant.
> 
> Replace them with the generic definitions to remove duplication and keep
> the HugeTLB vmemmap code aligned with the common optimization macros.
> 
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


