Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35351C53200
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31E66B008A; Fri, 24 Jul 2026 12:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE33B6B008C; Fri, 24 Jul 2026 12:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB036B0092; Fri, 24 Jul 2026 12:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 863C76B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:45:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14BEC4044B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:45:56 +0000 (UTC)
X-FDA: 85024247112.27.AF34BF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7599318000A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:45:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oBmJQ1r5;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784911554;
	b=F8Si5jgptEhIFdv8pTQN+4dHUrJFd1RftydgUW1gwMb5txSOqAdxovW8Zgyf4szd2062FS
	EznqBHOKsC5Yy8Z8EQIpzh4eZhVcWp/3FifGx7nByxuwQK7qe1/JWYbvTE5tQSkmw8Hizf
	GPqdkAuZhx4eubTkVqXtqBkLTiLQUXs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oBmJQ1r5;
	spf=pass (imf16.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784911554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GkpDhp8VBPqI8hSRT9Mbj+h0fN5D/FDUMTkVMZamhDA=;
	b=kWvwU5hSgvrLXkBcd++hRnk7uhzl/Z238E+TDICb0bnrviPUsHKsSRCZrYGYsJeTUZ9slh
	Tt6y9Tx95HlnAsn3tqx194wD3EepQ8qfIdlmopMBbcvqBzHAulvqiXPUtX1psKeZrz4mD2
	Sl3f5lsTcZw5pIcAkv8NRTrAyPTvxdg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 517F04373E;
	Fri, 24 Jul 2026 16:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113D11F000E9;
	Fri, 24 Jul 2026 16:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784911553;
	bh=GkpDhp8VBPqI8hSRT9Mbj+h0fN5D/FDUMTkVMZamhDA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=oBmJQ1r5odw77YxBFbXOhrNSqncb51aVfrP6sjGnmxKA3dGrkLb8j9UiJUtE39I23
	 su3F0AF5cF3LEtk190eRP9gbWvgXoe0ztuzda3vX6XTRL+jpzZEy6o48nvj5NWnwKV
	 StsTlJ2ztUbZXhz6Fu734svC8GWjmQqYX1WUoKo6Dhpf6DxHllvKNTBiCBkc2nTyfC
	 xWWWjfbct9acr0HVc6d+M5oCSk8TE2Vk+0yHaW47waiJ8BrYrDZc16zQKvThOBWKcF
	 7NpGdzrrgLGsjpsMWwszuj0nlJxMG276KVmJEMWpuNOFvZNiDG0MX3wWmF2N1e3oEv
	 qgAuC53iR4cfA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,  Muchun
 Song <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Jason Miu <jasonmiu@google.com>,  Jork
 Loeser <jloeser@linux.microsoft.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 04/21] kho: return virtual address of mem_map
In-Reply-To: <178410811938.820181.15709073379301681705.b4-review@b4> (Mike
	Rapoport's message of "Wed, 15 Jul 2026 12:35:19 +0300")
References: <20260709173821.429921-1-pratyush@kernel.org>
	<20260709173821.429921-5-pratyush@kernel.org>
	<178410811938.820181.15709073379301681705.b4-review@b4>
Date: Fri, 24 Jul 2026 18:45:49 +0200
Message-ID: <2vxzse58gwua.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7599318000A
X-Stat-Signature: p5fhabmqj4brdr3riy51xa53qs3nksdo
X-Rspam-User: 
X-HE-Tag: 1784911554-176749
X-HE-Meta: U2FsdGVkX18RJBWy6yWmDySiH5pQkHQFjZ8jJbOfKfe8DTMs4iUtbh5yWvDq9Rjn5lCJIfxVLpj0RFiSN+/18kT9xYOK+YTCqdhyFERvEwqT7cCUFTczsDXgd+iPnAa4Pv1yTMkfOXvAiR7xPVkZ7Zrt+orA1bX4vmWu/qo7T2rVz0/5v5x/tBmQ9b/8vFJ3hBVb2KRTZM59ICTlG0wqaRaRiICbUbYHPFnbWm//VcQkR29AfqyEvhSRsQQc9h/fpcLUIqND16M/Y8hUr67BDW7smnBAIJWruYHlm8N45GDEL5z06IkIEWvgJPNccFliwNHjCDkhpX55TfUqEf0sCQo0hm8DOHY039OeDvKOKhvisNVBbE3VN84RStfVDrfzvxM6G8hJF86cKbzAdCjTK3IwQQSDnuEI26A18cLkxu60g/0yJ6Iu2wIIXLZXWnxqvJrP0I/h7VK5wlWB87jc92cQiyOeyqRcNgFZ7qtKngyzWGhUBDwBTeTI3PwPusK/a/C+rv5zMeEdTjWsG4wQQFKmVPjXgeBq4zN3RpLIb2fIEGJsTB5A0WO64nsq58VMDErV4g03anFg8GVlsBN2CNn5K0x+nTCNyOVx/7p3V3pPcxAbQZE3otawyThi+4W4WdJwxzoH8sWs9tQZdV32Vj4Ws+NKLDUTU7iA+4mhDR8WeZwUXl4JLC/87wUMFOUw89gQbBLzG98TYL7oUIiU2ldUKiGNSpJX3HCK/FB2uzmHUMUFdU+cmjz7jCA7+69YLxUXErjHYPDXSRz598ku56nwz73hIhcRRpG9AOcGlDPw/L41mR3rUG4iDKJYp/9uFMzoDUWAvThf6/i8v8qYqKjmIYp0q9WxPBwGjFAuyiSgU4OUlOwqtVdyDJeHw6VG1BCrd2ViP6lAjdXxEzQPsNDbKoY02ogbGGdTCGKUdEZStcCia+AHp+n35B1cF6RIWSK+ghiSAkIc8RhV5e5
 FfXMLrpl
 WuTmCe6BpK4a6fTIF/9n5LI9YSFqZtwappka9KrKgg7Mip4NHc0WA3c9KVXjwBD1TMLVYn64Yrwdy7VWLNkm290bbvBvCemwAGhvMasjy6BcdGL5svVuJzm0J6ce8Ye7JHSy6TtB8FrWYlZZZzDBzjCg+NgES3/POUhXttBFjb5rgIFwV72o1TYHC+1q0fMQy9XoNzGYgk4Ff55txVSs0NpQsntgBcWoaBKJnUYagq/1CWlRaop6jIGTLyucQtk56CT8b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15 2026, Mike Rapoport wrote:

>> kho: return virtual address of mem_map
>
> It's not really clear from where ...
>
>> Currently it is only used by kho_populate(), which doesn't care whether
>
> ... and where it is used ;-)

Here's what I changed the whole thing to:

    kho: return virtual address of mem_map from kho_get_mem_map()

    Currently the preserved memory map address is returned by
    kho_get_mem_map_phys(). It is only used by kho_populate().
    kho_populate() doesn't use the actual value. It only cares that the
    address exists and is valid.

    In coming patches, more callers will be added, all of which will need
    the virtual address of the preserved memory map. Since kho_populate()
    doesn't care about the actual value and only cares about validity, it
    can also use the virtual address returned by kho_get_mem_map(). It only
    needs to make sure the returned value is not NULL.

    Rename kho_get_mem_map_phys() to kho_get_mem_map() and return the
    virtual address of the preserved memory map.

-- 
Regards,
Pratyush Yadav

