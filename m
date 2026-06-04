Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C20ACD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D013A6B0005; Thu,  4 Jun 2026 15:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8B96B0088; Thu,  4 Jun 2026 15:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF0D6B008A; Thu,  4 Jun 2026 15:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEC4B6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:33:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54F6940271
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:33:36 +0000 (UTC)
X-FDA: 84843229632.04.5416F25
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4FA64C0012
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:33:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WIZh2DVy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qbCYaYtt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WIZh2DVy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qbCYaYtt;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780601614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=17A0fGLj3810t+Y/YXXQUqyaPr5NJ91ZX0M+6IS2/zE=;
	b=nk4tlpnp7ugKLok/iSFM7YMAJWs5MvoQ4DURAliDd0/pR1Q6Ye9wUOCFQxE3DF6VtpDofs
	KOLzY/pDPolio49Uus1CXIpCsIodVtoV3oU2ZxuJ91UVii3q7dsZAFOkiU8g+uoQ8gwFKu
	iFEGNhnGjqDXqDru/9bi2mBgZwQO8rw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780601614;
	b=p2Jz0LGhmgutE8H5b3nqQWJorlLZ4z3EefXOGT+5InhhYqCgO6yLcg3n8iOqud8swGm8MH
	UFIlzQkjzkBRk3sGVbYzK7PIIps6QIhNjiyZNUfcjb+/I84mYTH1OH6SFOdaBQlLPblfoV
	u+jOMGOtEsRKQglDALT/mpM4oDTRWT0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WIZh2DVy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qbCYaYtt;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WIZh2DVy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qbCYaYtt;
	spf=pass (imf22.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 121786B070;
	Thu,  4 Jun 2026 19:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780601613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=17A0fGLj3810t+Y/YXXQUqyaPr5NJ91ZX0M+6IS2/zE=;
	b=WIZh2DVyNF+J88p0RUcOfFrQZtq1yBCwnN3RA6FJxULVMT6skJVz+LwPJjurOLVHJMDP/r
	Mga0TWzFCLlmQhvU2G6x6zAk7kpocfztQRzWKvVwrafWSvgUbUyL6yxtjLMaBZp1KhYnd4
	dNaZQkQ+SxY2xtISp2dgVttb2GqYPIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780601613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=17A0fGLj3810t+Y/YXXQUqyaPr5NJ91ZX0M+6IS2/zE=;
	b=qbCYaYttIPyQ8PjOpFOnhqBob8yWUW3rtX5CfN6zNOJm7Cn8y46bqT9urzlCUp+NvpZ3TF
	r/rERYsIDHeu9RBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780601613; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=17A0fGLj3810t+Y/YXXQUqyaPr5NJ91ZX0M+6IS2/zE=;
	b=WIZh2DVyNF+J88p0RUcOfFrQZtq1yBCwnN3RA6FJxULVMT6skJVz+LwPJjurOLVHJMDP/r
	Mga0TWzFCLlmQhvU2G6x6zAk7kpocfztQRzWKvVwrafWSvgUbUyL6yxtjLMaBZp1KhYnd4
	dNaZQkQ+SxY2xtISp2dgVttb2GqYPIs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780601613;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=17A0fGLj3810t+Y/YXXQUqyaPr5NJ91ZX0M+6IS2/zE=;
	b=qbCYaYttIPyQ8PjOpFOnhqBob8yWUW3rtX5CfN6zNOJm7Cn8y46bqT9urzlCUp+NvpZ3TF
	r/rERYsIDHeu9RBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08564779A8;
	Thu,  4 Jun 2026 19:33:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 10u7OAnTIWo3EwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 04 Jun 2026 19:33:29 +0000
Date: Thu, 4 Jun 2026 20:33:23 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	willy@infradead.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc, jack@suse.cz, 
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com, dev.jain@arm.com, 
	kees@kernel.org, kevin.brodsky@arm.com, lance.yang@linux.dev, 
	"Liam R. Howlett" <liam@infradead.org>, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com, 
	npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com, 
	rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Al Viro <viro@zeniv.linux.org.uk>, ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, 
	shakeel.butt@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v7 2/2] mm: use mapping_max_folio_order() for
 force_thp_readahead order
Message-ID: <aiHSt1uK3ESOU-2O@pedro-suse>
References: <20260601102205.3985788-1-usama.arif@linux.dev>
 <20260601102205.3985788-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601102205.3985788-3-usama.arif@linux.dev>
X-Rspamd-Queue-Id: 4FA64C0012
X-Rspam-User: 
X-Stat-Signature: b63ce4xfg7p3cyj1beqbntkr4e4afx8c
X-Rspamd-Server: rspam08
X-HE-Tag: 1780601614-987486
X-HE-Meta: U2FsdGVkX18Dy9qmYdljf0W/EW44M9J7E+Qh+CXixUY+c8JiDIYADFqUEKMtpLI0GtfPXbGx3rTpiAvnXfUDPJnqOjVIbP4p7xDeHpBMbvEKO/HxWeQ3rVzto18IB475GLJu5erIn75uYNboqMz6TgAjUKCUoHDzfGcGUAjaEN6yXMGhaepN8SwMGBDU/EiQNVFsfkRWMuC0cLjPWQkSaKn3TBWU9pEGgFsoVDIxMzELBQfdUtkel1PDRsPubYIE/zxKDMVdExVXY+U1cFnBoIvxnQkZu8wFL1KPZbrT8/Tq0tD618QxA27XmdJWGx3nJ+SEJsjJVLk/P48AW2k/hDmHp54ZkFFMmG/HrLfuQb3udvwLxoprf+/yY8TbXL1GAwKGZwB2+QoBpYdStay+ZcxCzgemOGeZns8CFwldJKArhIive0F4tnS/NA3l93/VCYPGTAGQnZZCyzvPaBPOY17/+Jr5ixJvYstEyqW0jZRy38AUg6OZ/PlG4ScN9WXyJ2Djlm7xsI18JRyzJfnTqjtHHp0TINgLT6E3gsEoRw7r5ZzLIA/63gBnMY9zbW1EE10lGi7KkPSrxy1N9SnCijI98KclVMixt+OvHqwq6BsWQC6qLU31iuc22Caov0DK6QyG67AmKD5O7Ijwl3b+kSYPD63TexoWIMkcpeFJRJr8vaDH1pZuoZLIFT5pDv2k3ZFV8lh6NuoULV2J0RzUs4h9KfPzRJ5S4gz78VdcisEQW97yHGIQqKT/cKGAsaBKKp0A+T9ocqQ2LgKN27IAgP3cHuJdbSEj70P4HCovnO4LoQicjPJOBbG98rV4HXR5ieH40imBmRufULzoycMfXtFHdxo6xKROyFm7Pa7gAlND/xc0mOeB5ENcZDpiu/WEq85UXDQpy41fllm4VKa9KXYCONZ726OC9wmiCTYvS13QOHrWjKPZc5sSQO4cr/cooyvxX4w4Jn0VGfli7fL
 RP0xu7eb
 46VIAXlTqLGwq+LJqXRy24pg6Gaw2V5m8ljIV+Cm4cyaErXR2g4a9kHd6jL9vee7bAMG8BsWXkt2nMsV+ODKC5oeC15id3ETb9439YATRmbl6A1oY8hYJPXvLvyOyIuKP6XV7SNM3t8V93Q+v9A6NJ1aeFpb4vk8vPdS9id5JAF/g2rJCIQpqmTipPMEQGaY5yoczhUO9gdYqdWsJT2JpZYXtjKAmPM0x2KrP+owPA/zRbeEc4j38pj6vJJ+EFUXEbUlw/2QFChio1WvTItS9W03EU2hxaG9eTEAd4EXYEirKt9c8rCRHGqmgCBRkaLeLLadexvSZaspR8mp1e6JwLnuQ/RZJEKoxSL2H7mVB0vRTFvHAs99ANoMOtxGVOEme0PX2lPZwMkUVBWNsj/HY/QWqP/oxKs0+fJbujcHZ37GZhaAe+kkOPWfclu458ab5sR0TT4Ui18AxXgyJC4Y1Vrf0XQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 03:21:18AM -0700, Usama Arif wrote:
> The force_thp_readahead path in do_sync_mmap_readahead() is gated on
> HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always requests
> HPAGE_PMD_ORDER / HPAGE_PMD_NR. On configurations where HPAGE_PMD_ORDER
> exceeds MAX_PAGECACHE_ORDER, notably arm64 with a 64K base page size,
> VM_HUGEPAGE mappings cannot use this path and fall back to the non-forced
> mmap readahead path even when the mapping supports useful large folios.
> 
> Enable forced readahead for mappings that support large folios and request
> the max folio order supported by the mapping, capped at 2M.
> 2MB is chosen as the cap because it matches the PMD size on x86_64
> and on arm64 with 4K base pages, so the size/memory-pressure tradeoff
> for folios of that size is already well understood. On arm64 with 16K
> and 64K base page sizes, 2MB is also the contiguous-PTE (contpte)
> block size, so the resulting folios coalesce into a single TLB entry
> and reduce TLB pressure on the readahead path. This will result
> in 32M folios not being faulted in with 16K base page size for arm64,
> but with contpte, the performance difference should be negligible.
> 
> The final allocation order may still be clamped by page_cache_ra_order()
> to the mapping and request geometry, but this gives VM_HUGEPAGE mappings
> on such configurations a large-folio readahead request instead of
> dropping back to base-page readahead.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Overall LGTM. Lets see if performance doesn't degrade.

/me hides in cover

-- 
Pedro

