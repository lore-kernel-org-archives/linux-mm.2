Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50732CA6018
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FC116B0096; Fri,  9 Oct 2026 07:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3616B00A3; Fri,  9 Oct 2026 07:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411366B00A4; Fri,  9 Oct 2026 07:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7C86B0096
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:31:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8EF72C0332
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:31:39 +0000 (UTC)
X-FDA: 85302872718.28.0BB318B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 09ECBA0012
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:31:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nGmJi/3W";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791545498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TDFEYy/Q/xEYECc94YNGYpg4Q/2TeXJxyRpR1xMyR2s=;
	b=uU3Z/27cg9GDhHJd6cpIgYqUfHnYZ5YI57eUeLV4gcNhOYfrs2h+LUMGNMKKjWUHWxUhvx
	/7ODaVat4y/f/VVduld7V0TPBu2Jp2sq37BLLOxZMOGmxNCUcx36do8p9YAxNZ2AF0z3Br
	wgxEkA3VJK6gZishGNXLXA5d+pLQzGs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="nGmJi/3W";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791545498;
	b=CwntCP06JWF/m10/uWuCi/NUf9YgU3CzF8ljdcteEs4djLP2Ta/V8IPwAaCoaQBwLrCK/t
	FLsYr8gjLWG9Ovwl60C8V6/Jmr9H2c7piJLgwUeqkbcNOL4tlGuQ6Bq6/6EnM16YG1DB+B
	ytCCiIO3k6brUQbPGqqX17sGkhpSwSM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC14660DBD;
	Fri,  9 Oct 2026 11:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45301F000FF;
	Fri,  9 Oct 2026 11:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791545496;
	bh=TDFEYy/Q/xEYECc94YNGYpg4Q/2TeXJxyRpR1xMyR2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nGmJi/3WdIz7DcgX/GzMzaKt92xgA+x5e3sBci9m0VGBd/McpS1+zBtQtpexkXfqf
	 2wwDbDcF4Njq7OWB+Re+dEgCoqLHwLHyluOv5vx78XvCULP8LQYXWXKtIcTsk5nUVM
	 aSlrq+CrpoCriHIbaxYmPRq1g4gV7DIpLKoZe2xTI4wPsIOc0DYlMt59n8TziUK99z
	 n2BxSleErFa5kIaXl5M1uuTqD2VNRgaebUU3I5yFNMpWt6t/OG+ihrwnq/41zK3X7r
	 euuZabEg7p1XBGUVufxdtvrFJAQD2Yz1nxGOo+lcPzizOBE2yuW+Q+/RwwxDnfiOS9
	 8AyLe1iNvrsDg==
Date: Fri, 9 Oct 2026 12:31:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH v2] mm/vma: keep the unlinked VMA off the file across
 unmap on mmap hook failure
Message-ID: <asjQQF_Ok1TZPm1M@gremlin>
References: <20261007101800.58d50b1b20a10738e630bfd5@linux-foundation.org>
 <20261007194708.2009-1-okerixx@gmail.com>
 <e139339c-1e55-438b-86bf-0960ad4029f1@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e139339c-1e55-438b-86bf-0960ad4029f1@linux.dev>
X-Stat-Signature: 4qa4e147j5w8e4amjkd85s459g4zukxj
X-Rspam-User: 
X-Rspamd-Queue-Id: 09ECBA0012
X-Rspamd-Server: rspam08
X-HE-Tag: 1791545497-467685
X-HE-Meta: U2FsdGVkX1/PTxUwUaJW21bZDNwz130fJrlAvqvM0ix3ZzWflW8SrccHPObW+dxHlROHVAf6QVSKhFOJKiM8iuinIDF8z+/O6SYJt21WjsqeCxByFwlHcx3J6W9UfCIt1SMq6mG2YDKCJjcKjMP76MivXWlG2/LEo4O5iJhx6MnMDo78FKMwn5OT02bxlsvm1BlzFBV32cn2lHGu0SVKN01wanPweQptGE8RjsR8YrRpJiE6NanNdPkYzxYr9rR8A/KtpSk4nZ/lcqGX98Uk5RGGLw+CAPU+1WLemjUB71I29h6h2mByGEKojGyK4YsOeistZhVnGa1i+UmMeGdhnJlHs2D8W7tA9o+nVr9a/56M9Ar0congkrrtZpdvLtCSog3P0VX7da9XxJzjrawhiq2iF/zNcYk/ijvaz3Pp5OiyEKeMofJcDOEw92ajUdneOTwa7pSZSxv/iuKHgzwZF+dpNb0vdgYA8b9zWPWoovpVeZ3507lRSAYHmnbtymepxn6SF7lcGs22LM9DfCf2lfQwjAoaGtrq5THYvUyh6pEKv5Gmd+WkrQ8dGaWDifZpq0mTUG5v7cOhwfekiPzLheZYzpytlpF10gNC9QvaDqY2++gzRJV1An8wrZliMPlVxtctB+3B3zBsxAPEXZGIZUwNjKjDwqNZz8iBnLOioWogDnSKJTiltUG3CKo5e4H0NIumsZvQXsreoLFPTIbmd2fOlu1BPjqDjkCigGtfXOOTAueWEn/H6lHeiMKDIea752xsV6vG4v6rg1X7WYNdKlyYORjwwpIc5lN3AtkVImirErQLg4Cq03Ael7DXspTa++43bYnRQmTCIa9DfoJNAw5ic4HqFlAUT4uwwMMqbv+8IXE0zZRh597OMzJQGNicuqFFwKT3aNlGltCw7b4RpaVCwWnXEqA7Vp1PfCBALo0vJPxBQzQMBCa6tnPLHnQdHQxdUO4xWqH1H2iFRrL
 7TrMktm2
 kgKZwS7LSuJN0UpGYcwlu2IrBEdOEty+FQnEshwZYjC4e7B69n4kHlm9a16x9AsuUnRizpizt7R/Hl0ejq1eOfNf70UlICWZOyBuyZRreoWp5hUBXVW1MQLn/MsBFin8eF7bKvASH6QcKZTE0Pk0s17v4IqG+Mtaoe5eLfq1w2a9RA1mmRIxLit69wtCZGTr5/7pgF/rvemET3e6U08k1QbuhAX1Lyl8sdZ0PQF1y7tR596UTei1/gM07Q8nFB8DZWSMgBsGOcb36kcAOoMvVKYcEQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

-cc slopper

On Thu, Oct 08, 2026 at 02:48:07PM -0700, Ihor Solodrai wrote:
> BPF CI caught this bug on linux-next as well:
> https://github.com/kernel-patches/bpf/actions/runs/37736351874

Nice that it caught it!

Is there a way to automatically notify patch author that when it happens? Does
it bisect, etc. or just green/red?

--
Cheers, Lorenzo

