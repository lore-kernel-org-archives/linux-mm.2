Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 247EFC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 10:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3406B013D; Thu, 22 Jan 2026 05:32:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590256B013F; Thu, 22 Jan 2026 05:32:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD1B6B0140; Thu, 22 Jan 2026 05:32:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA496B013D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 05:32:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A753616022E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:32:42 +0000 (UTC)
X-FDA: 84359236164.27.C0C89AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 017D62000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:32:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GopdvMk2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769077961; a=rsa-sha256;
	cv=none;
	b=tgYiShgF3s5oaGD6DLMCayFTcKYRryDT8qUQyVw2Xo7+aFsRMb0WUUsYxDAY9DlqzqGzo1
	QBgLpbyrIl7ByQdL9r3/z4CYKfpcJUMC5kY0GKxm/l3sMkJJnvcNI7xgADG7LOPKGtQZBT
	3voVlYdmUoofi1w9RC2fObeWCJewDns=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GopdvMk2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769077961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HqOPvqEYpE0y5jBZN7+kzBoOLCQmJv/OzZ0AwEKxX+U=;
	b=j6bFLltgS6y0k2WV5vW2QcJYtqweLTYuYbEMYm9gqcOqrBf1cYGtuEEXMlahZFqT3Uo3o3
	WBYh7jjj0xpWRnbtTONOXlX472PuBd8C7+hOO8/tCnryJt+5gKlnIHKVgDtSqTEv4lWkZE
	NsfhppY4S1riqWtRQktWXQw3k1lBkj4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C423B43BA2;
	Thu, 22 Jan 2026 10:32:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2B7C116C6;
	Thu, 22 Jan 2026 10:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769077959;
	bh=k3wigtvvgitXmNYhbQcxlAS/1cAtiw6JShYdcjcXWgc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GopdvMk22g+PZk/+/gUQU104GzpyK2EYIiA29AMbxC2zw/km9FvXh2j6Wwf+5R7EU
	 GVJrokrOqoyf3QR+LRdBhzHYw3dPOIhQNC7/p8/dE7D9Mi104IHeY60jxfIDeh13Dr
	 Ig+dNeto7UTGbRxsfgvwVELVyV9QZL4HO4/Cmr3Bpv/3G8fOu9pBOF3r3jBQkdPa2v
	 3BU/s7RNByAuVom5DcJG9fOYkurclVkanfm0pYRZ0vY8llNN/zotKZkINO2Qdv6mHG
	 Wkn51FhVSxbxkLI6qCah1VxDfNUwlAMCHy9Ha68mAB7cNdF2MOhnja04L79Fe2mENi
	 WqcVLIaxCP2vg==
Date: Thu, 22 Jan 2026 12:32:33 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Alexander Potapenko <glider@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 06/13] mm/execmem: Untag addresses in EXECMEM_ROX
 related pointer arithmetic
Message-ID: <aXH8wQbyjFqlueNS@kernel.org>
References: <cover.1768845098.git.m.wieczorretman@pm.me>
 <50701245bae3d2c543f518d206539ba71367075c.1768845098.git.m.wieczorretman@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50701245bae3d2c543f518d206539ba71367075c.1768845098.git.m.wieczorretman@pm.me>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 017D62000B
X-Stat-Signature: p7iukaqjcxs4u5tqkf1b71omxakztusg
X-HE-Tag: 1769077960-279847
X-HE-Meta: U2FsdGVkX1/O1YnAv7EZBnbLCOPi/AJhn2NnoJuVsfOr8N7Xkvj9tpA43dCP/1v12hZLcazAr+lonGeWB58OC6LRWba+dhdPXlt+BPWT6JYjY5Kz+s66AL0XwBbXztAz2MwpcUSHMvQWQ6L6VBHCq8mJU7m9+u3ZlepH1ORl1KkyfOtZq6jfnnnCElYd9C8yvgcmD7OnN75KQqCIu57BeyxbHQhCE4EtEzG/7p7kkitHsjOBmmNROd9dfpwCqLV3TiTclZbKbF7dYj7fu8WkhfuIPCsvnJe1i5zlq9hBPw6FZOGJ3ow5+E1cL++JYNKbj2PJAlmfm4Ub2Pr8P2ZzL0H1ocQ9QPvQBftsEgBVZH/mmD020xP2kRg1urclNzwQNCIqylpxgxSBRDHB86Nh58X6w6BcusPa+OkcWud+NP1XYmTqrPrvHCXEUGiCXGqmMMBugG/KGsL0IRmyuc8MpcRNtgUP9McBVfbjVKekQECyNGVgTOtj0aHWdRkjZjxl4x0NeqgAWb5p9aQOObqPmcSFb9NaV4qt+6q0HmD5CW7TpXqUBZZWdfL0cuCoz2Bxd6fdOVfybU+ZILQLjqKY17P4/eK/v2edZBFZod7maOcREQjqBYSJQl5c4kk0ohcu4P92x3VlihC6VeqaWc5jIQ/XZj2UiFtMrWWwSJR5AlQ+X/t493N44hX6G4V2+jRYef/UZmnffC7bke3TVO0/bkHmtod+8UsLt2xYyxLCN8weHZJ4Nl5a3R4nLQwCX59FHSvQoA6ituam4j8vCZ3CSBbuMRfLJh3OUt/H1SZA14D4ttVvmfqHZK5YlpFflsTFb4WGLRgUGEWc72vG/0oe1EZ6+DPqyGZqW7ARgliXFicm58I7mUs0NPqcW8TvW8CGMsCL+qnrguWpAaCJrNK2EYrTbmqn7Bi83MXnGw5oaWYEKpFXLwFQhG4mF9njjdZ6Ek7WjTMyvAhCmViK0nY
 Pofh/VsB
 oSRSm1pqjcJAadScqWEZ2wie+2Xy3ZsbwEeEhWyuufOc/BAllE5c3M4jkkm3FcXMG0lLIGcH3PTspPABGqDvEmadYkIoI2FwBOsL1bLsyRsC5ivxanepKScjDEgwH9SvzDfEaOP8R4ONWyt0alEuoEaekBY/il/QmC8qFZgTHVxUFyEfYNiSynBls1jrENDyVqmwYBcvgv4Al70Skc+0wTTpyu0kdpFQW3VXVG2Z1q+Yl9I6aqRZy6hdgqkiNVne9XvRBOChoIK89YwXmP+fanFyjFggZL+tvtYm8T04rfL/HZ5vp4YaBC1j+vmhDq/xWTBLkxm+zLBX2chnYOYmggPmKHk5no+SyE6nK55VUV5X0XdTSUJYFfvLV7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 02:41:43PM +0000, Maciej Wieczor-Retman wrote:
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> 
> ARCH_HAS_EXECMEM_ROX was re-enabled in x86 at Linux 6.14 release.
> vm_reset_perms() calculates range's start and end addresses using min()
> and max() functions. To do that it compares pointers but, with KASAN
> software tags mode enabled, some are tagged - addr variable is, while
> start and end variables aren't. This can cause the wrong address to be
> chosen and result in various errors in different places.
> 
> Reset tags in the address used as function argument in min(), max().
> 
> execmem_cache_add() adds tagged pointers to a maple tree structure,
> which then are incorrectly compared when walking the tree. That results
> in different pointers being returned later and page permission violation
> errors panicking the kernel.
> 
> Reset tag of the address range inserted into the maple tree inside
> execmem_vmalloc() which then gets propagated to execmem_cache_add().
> 
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Acked-by: Alexander Potapenko <glider@google.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

