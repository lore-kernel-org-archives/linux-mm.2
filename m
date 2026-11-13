Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD68B606A89E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T46WN0Z8
Received: by kanga.kvack.org (Postfix)
	id BA6AA6B0668; Fri, 13 Nov 2026 05:22:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B55936B069B; Fri, 13 Nov 2026 05:22:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A452F6B06A1; Fri, 13 Nov 2026 05:22:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EFE36B0668
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:22:59 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1571240607
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:22:59 +0000 (UTC)
X-FDA: 85429707678.23.DEBDD0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3EA09A0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:22:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T46WN0Z8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794565377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jYbK8zGv/smh1139rBIQRgoOqW6RYvBzJhzngA59N4c=;
	b=j5Wfq9ZMARRK/mSvvNzK+e2l+Hx7o9ldg63f1dQGsdrvfXhnpfEVJ8drUM65G1xsAr9SlZ
	JCdQ01bfUWaZplUgxjpqOrzIZWnURAsuYJwe/oxyBJJxHJWFCutN9isiulz4eI4AtKribz
	pzxgoghc7cp+9jPDvfK+yqiF8mXWrWI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T46WN0Z8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794565377;
	b=FaE62aYrbA2nld3AC9A9CPhL13VDuTQgi4voozes2Ab6UICOJ8ymwtfewahnOoL9xrol/H
	MguZR0E87wOFaqHCPOKDVzwAiTLh6zem0oBsSec2kKXDhOS2VtVLqZj2nyhopANPEsNOZm
	viXx+bnlfW3F0XS5O1EfcpF/OfT1Oi8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 335A6455BD;
	Fri, 13 Nov 2026 10:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E071F000C6;
	Fri, 13 Nov 2026 10:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794565376;
	bh=jYbK8zGv/smh1139rBIQRgoOqW6RYvBzJhzngA59N4c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=T46WN0Z8iHHHZQxDdN2GymffdKdqNuYZxD0dQwxnaw+Sma3T9vWZioz965zwmTVVC
	 hHz8Bw6Vt/myHKlr3RfRwkMySWlEfA3VfbgevmpaW1859tNcEAPt/YWioLHEJ2ntLU
	 vAJRgFYvQwJZoUzbOtjaFn9/hDyopzoTxwipITopJENJHGeseYnwdJ36t0hPtyd9Sq
	 2QepK5Qqec3CPATRuEaz93eFKW+z/MMUfQ4bfa4FuWz5y/0629x1jewhm5c5IRp5bJ
	 fQcTOvou1Gb5r7FEeFjzzxiB0uW3jSl6xc6HdKQMS/e3w11PQQZ1THRM/akGpuDxFt
	 XxhvuQ7XdeLXQ==
Message-ID: <45a80a9e-06be-4e94-80e5-25692c4c9988@kernel.org>
Date: Fri, 13 Nov 2026 11:22:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate: improve mlock tracking for PTE-mapped
 large folios
To: Wandun Chen <chenwandun1@gmail.com>, kas@kernel.org, hughd@google.com,
 akpm@linux-foundation.org
Cc: ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261113083927.2727599-1-chenwandun1@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113083927.2727599-1-chenwandun1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3EA09A0006
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: drdofzfcehts4ecich3ymr9s598cd7qa
X-HE-Tag: 1794565377-185292
X-HE-Meta: U2FsdGVkX18l9kcmVAFjdKXK05T+dFoJSx01prVz4bLKJg8bfWxEZ2v0hPFNrRqYvIUChaQMpspnzj5V1He7L4qHdhEYBOgG4+uLWGdmsQLFywSmWTkdjB0M0q96ytmXfil/5cslqnGKllJIPw2qsBgblgF+w/1gAO+jY1yfEOg1H+ZRsYS15bZAVp95KqnUp6/IMR6e/vVG5M2RJa8EX1i1Z4u2ffzZXm+9TH9H8DV06APjByIkufiC9+/38YfBgX6hfVUjEOtIhmwjwyc+TfXvUdcfpQDyJMAvJigkzW+E4xmhfpPExPfRwdc2B7qzTHNExCJwDvVZ+LYSHyLfEd3uqkUgxeH6v9S6bNUF+VlQ1LfX72b6bWq75sFRPOZRTrabC6RqUSiePsVZOtslT/PSyPWwExT06cuoLJzyLBHYJMLbD41CzWjbjmN5Z92X3wov0DlZT2z5USKAyhr/FKe4fQD9W4F4Ny/lzRZn00ie75MFQxGNY2Qkr4uY6+qN35NVkT0kFCMsrz1l4bwwen3RIu5KWwO6o5+kjIbiVhbXFjm4bAdZRm+jI5CTg8f8DYQDg5SkWKWEmbvHK6Njpci88GB59KjA59Sgh1xclSnfQ8qFMVpcvozaslazjLqtNA97utgWDo/2Y9mtFU5nl71Apr5RlNymeZGeUCKY6B4HJXH26cw7MgY6Kiiiv1i4+yy5uIdiiyshJUz+GnCP+mHK3nBbR4peh1cYbSJw4l9bB67i7Q70e+0DpvZFUEMFTlFgwNP3dCibuEKVvxcQCPdiOpgpL51dGZ+RHbGm2Y1MJa4TEgzsBRXDNhVnbaotuc67oeSJnBXAjfm8d5Vi+wZT692/W81M0G1FDQTHCOjBKN24c4kfcg84j3BZUzSuSpfq9wH4bEj84ixNBxsKuQsG8NRn273TcGheOZ+KPHcakPZCsnk6+qLnHnhHE++iU6o72XKSS6v79x+WJQ3
 myNWhm0v
 zd8YcZOi0smtU23m45PJtvKnhUCTc2y85dCRiJuQMMd2TUSqqtwW7G0fjpYDKUOmP0RzUYc2CNL7qrMPBVL8Bh5TseHlZSGyPKjQ6JmQd68FAq96u1CD7zGIKBREUfDixLFmP8uXAAQLluzMS5Ded7swlZ5FZwXBTQTchurV5Mna/Gb8TmBxEe3np45DH/idFiLV40iQ+kBLe27KKMGM6KozF+GkTiwEbWWdMFFijJIq3IxKfeZC3RpJbQ8OHGQMzbJQK3JTNIlSwizFSBbCvDFMysvD92CyyL9kVxT3tLCYrlHXtuvMXzUdlyOGCDdJD7JUnOSwurIhVzGI3F0oPJv0DarKK38KnlSC1GaKgKGr4mbrPzxwRoutAZJL0oZ4KYODHlQ4UyuGiaV3jOu4qMVtS99PnmWuiqstBEjdZcx9tMgrBIuk4/hEraac+th5wVByB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 09:39, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> Commit ab521b4142aa ("mm/rmap: improve mlock tracking for large folios")
> mlocks a large folio when all its pages are added in one rmap operation.
> However, when a PTE-mapped large folio is migrated, remove_migration_pte()
> restores PTEs individually, passing nr_pages = 1 to the rmap helpers. As a
> result, PG_mlocked is not set on the destination folio.
> 
> Reclaim can restore mlock in try_to_unmap(), but Mlocked in /proc/meminfo
> remains undercounted until that scan occurs.
> 
> Restore mlock once the full mapping has been restored in a locked VMA
> under one page table lock, rather than waiting for try_to_unmap() to
> restore the mlock state.
> 
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

