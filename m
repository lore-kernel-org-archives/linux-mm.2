Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 775FCD3ABD6
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 01:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 978CA6B00BB; Fri,  5 Dec 2025 20:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9295B6B00BD; Fri,  5 Dec 2025 20:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83E446B00BE; Fri,  5 Dec 2025 20:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 728E76B00BB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 20:14:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D4041A0351
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 01:14:23 +0000 (UTC)
X-FDA: 84187275606.21.3C8C0E6
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2DE951C0004
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 01:14:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=pIFhq44v;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764983661;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFglSonZ7YxPo3VRt1KcGMtrxiomR8dgNDoQ6a4aYpo=;
	b=tSPVoCsXDjRuWBeD5K4HLE5iVWraepfe5ZIQITtM43o6b6JpN6ga4faUNqm4UCIrCxqdMi
	DjUzJLgal9HhYVRi6LyGcPcNPdFv7E8aQ6L6Gc8moikISFmO+E1KPbtwWGfD8J7Nl8/P0N
	nYUbYX0IjyuJ1l9N46dRtDfWsY6IXg8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=pIFhq44v;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764983661; a=rsa-sha256;
	cv=none;
	b=PDtl7xtX4tgRgjrzX7bK63ENMPDZaTAFpkILkMuhKRHOQgldf0wX+a5T0kw1oEyHnW+6mO
	ygGW1ezO88FkWwMERhKxef6xOGHJsqfGDp1O1Y1kpzNQy5rpZR6wKiB8eHI4Ba/cYkXQY5
	+E8z+sd7u+1TbL8F3M5d1/IMjiwgcHY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JFglSonZ7YxPo3VRt1KcGMtrxiomR8dgNDoQ6a4aYpo=; b=pIFhq44vqodCt8SjmE1bmMLqDH
	sw/i9MjfSnzBvRq551S7WyLZ7WpZK/+4+Uc91Y6TtqNJlCy/jF9dLdUAIARA53nQcT5/HAIz3GTQ7
	YKGPWKIDOJwZuAvd5h0NdJsSh7xUmo3dD8ZIgdbcwWDUqmNH2qvkyYbPGm85TtgyArNtAd845GKs9
	PrS7WHSo1gXniWkZ567QJmeL0YKuPOgzvspw5QgUeViMxAZ3jiGXqLZFIjWMLUSQI0egs+BSsj0b+
	lX1OexNykLC6IHcQXw3WyM5zJxmyozP46LNa8WjYZRIQ0wt+2YPiES6pPOPvw2gGbIW5vjVMdHpfp
	SyzdI3Jg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vRgsd-00000003sZU-0kc6;
	Sat, 06 Dec 2025 01:14:35 +0000
Date: Sat, 6 Dec 2025 01:14:35 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
Message-ID: <20251206011435.GM1712166@ZenIV>
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
X-Stat-Signature: c651ud84bqxni9mt3f6q888cah3g4cdz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2DE951C0004
X-HE-Tag: 1764983660-179917
X-HE-Meta: U2FsdGVkX192oBl+j/ovTM7+BhByvN9XvBZtuDzuu1rH3F967HlDNjC3YgQJRM7I90pKtRhTbWuEWkkEpG/jo2H7NNIIxvEwrB8sDaFbjQcdji02ysFUg3b9oqwPiSOGyqf9NrVExkWO5hi7Rnrpf9O9UHuQer+W4gA+iRzGcH+5W8iAgiJMforP0l5a+2sHWG1CRD+YIUWIHTv4uvM5YLlzKI904CVYfVi7WwWN2HhhDOaoks38GCgw75XLNcrpvoEPpP1yVNPLQkydnRpI9ryrz7C/OMugcMm603bBiYKdjXOB+d2d4HtxbSwzWF1zFdsKIY1Sx0qqUjDnO2G9IpCqvzdOgGnlKjoLWKaEw8rAAQ9rQhw787NOSIkTzg+H6NWkyLebn5Ugx3vvs0q3fQf+OYjSzNhOehugXOUmQpwZzOzsBG0vLwSehTOW0Lc2EKv8k4BV1A1Kp+KQJkyjrFomm9heeeOt36uo33dQJVf9TZ0XiQKbLDJ1M1RbLmdxFrwEL1UTxuzTRGcbUkPBLu2Ge3UMOSPT5oovNvjHs6IyqUkJTPsxvnEclHVXsSLJZAYURQ9aq3GqUxrlOkRwIOH40gu5HyrFzW30CuLN7qwwpGoKpFpH4nH+0o9cxxrD2t5ERFgyDQGlToi2F+f4odB582v/zXX3Mu6YQScGQHDLVw64nxgqrJDc8fArMl3a7VF7V1XxE3GoJnQIDASac+YtsYhWZI5QK6L0d6y+ojf2VLqf3Tnkyv8oRip654Nb0P08JRvGWscEAKfLec9UnWAkNx6BVDLZ6y7BGanxlnufGS7J9gceHeJ/0ADplx1DtfgA+4WpKhyBj45lsyhmt/Aknmp8rBR586gC8WJX6xg1xrvmysJeDxD3gQ3XdunSxfo7ftLLBGdiQCHC1OkJFzmVXSUe7gjvfinQecgGCOogGeS4P6FUCf33fLBJyRRnBSMooKOhseX0xTNJuRE
 IBSAID6m
 RVoohm6e2B3GqK/9EJUd5zWgJ1ZxFPT3FF6cz3EMbaW1WWu8SeskdUKfIQ06vAKALOR0tI6ysxQXhSih36d7WwO3G12a8uaxVnAlbEqGzIUwBpX2yqBatFmlpSw24zpYfjVy65Wa9dJ3QMLUZfvtxaJGx+lekqyssWBWHQKnCdWQjEcFq8WQTXH8xF2HpTwDlhBQRnsMgR/GPQrU1vwMxYuIWBDdKlgsg6d2u0WqK2ObFyU9D61icdVPIMDj2QLJ/Boj3FOF1N0wbKfrMEnvabd3Ma1Mfew03y4xFbrT8WJepGBfNp4eBz6/+UCrNrB6iwR2rB+OjqaS+6NGaBf/RH+BtoI9qAnBgL5L5GpmYuxX8xT0wizEWfT9HUzd7YuzTtRinSwVUGFnnYQiTeWX0Ef81bajWU3Vl+pzfGUL7Uhsr9CITBH1z9MM67vZ8u2BpMBQy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 05:50:37PM +0000, Lorenzo Stoakes wrote:
> Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly changed
> how VMA flags are declared, utilising an enum of VMA bit values and
> ifdef-fery VM_xxx flag declarations via macro.
> 
> As part of this change, it uses INIT_VM_FLAG() to define VM_xxx flags from
> the newly introduced VMA bit numbers.
> 
> However, use of this macro results in apparently unfortunate macro
> expansion and resulted in a performance degradation.This appears to be due
> to the (__force int), which is required for the sparse typechecking to
> work.

> -#define INIT_VM_FLAG(name) BIT((__force int) VMA_ ## name ## _BIT)
> +#define INIT_VM_FLAG(name) (1UL << (__force int)(VMA_ ## name ## _BIT))

What the hell is __bitwise doing on these enum values?
Could we please get rid of that ridiculous cargo-culting?

Bitwise operations on BIT NUMBERS make no sense whatsoever; why are those
declared __bitwise?

