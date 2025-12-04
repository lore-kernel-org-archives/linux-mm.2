Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31FEBD1F9B7
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 10:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F8A06B0026; Thu,  4 Dec 2025 05:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D04D6B0028; Thu,  4 Dec 2025 05:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D426B0029; Thu,  4 Dec 2025 05:55:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 735E16B0026
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:55:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F21AB1332D5
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:55:20 +0000 (UTC)
X-FDA: 84181482000.16.235E7D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6A701100002
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:55:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O9/F9Nfv";
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764845719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCdwGY0R8AwBwgeyCk+HhVFrQ1l6YXzir7EPddR504M=;
	b=WiezeUuGCSelBwyBgjX4BbVM4iUlEd9zRQ9hhdg6afgt2gXQ3DjRLgIy1u0gva26jmbSk8
	gIEjKkld5ffSMU5XnI2Np9EQuYCpeWJ/jFPDhy67zGh8xyDbdMf3Qfrb8WOPXwYYDGuq/K
	Xl3WnUWCerPngxlG+m5D4VPf+ZoNPBM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764845719; a=rsa-sha256;
	cv=none;
	b=fWz7v55sb4QQOPoVAd/Og7S54d+HsXA3htYLfP2NVRMgRf4xlsWykTBkb/c/57/poaENdA
	aaVpV2FoKbl06ZLEyrQO4BUK5lydqBOEKPJtccuYENRnW47VYYkyZCP7IpyI+ctkELLX7g
	hxx6VQpNpgJbUQGI673yQuTxU4Y5DXQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O9/F9Nfv";
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BB3760197;
	Thu,  4 Dec 2025 10:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DD0C4CEFB;
	Thu,  4 Dec 2025 10:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764845718;
	bh=7Dsi44OL6986BCsrNs/dEnIGMujSmD0SLBP7kqki3wo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O9/F9Nfvabkdx+TVxTXKQECnQQkoHJqg3GhzVPQndm7LPIDHeoSG0Q2BKbYI6SYQ7
	 +pvTYHFbARYdl9w8v6bakU26fWXPiB2UfbFRFs4Sma6WnkROOrgikJrNi0GUaQJU9X
	 qHB7p3Oc7Wa8+6QXf5/Q/bMJhi/lDp/Zv7t9JHLVhlcE8DraD5r6Ilmk+AC+rTsQd+
	 YziAX5HrBBq39c8pO1kYtKuVkVfT+8nZhPcv/XYU8g/W1B/3wCkT1/0RitvZ14qRnJ
	 Qx9TQaCSUCWGgP9md5nGufkNfeBY90FRjVnCkf1vgTUBGRhRyiI6ZO1BGuF0QkJL39
	 KirNZPazUghsQ==
Date: Thu, 4 Dec 2025 12:55:09 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Arnd Bergmann <arnd@kernel.org>, Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Guo Weikang <guoweikang.kernel@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] mm: shmem: avoid build warning for CONFIG_SHMEM=n
Message-ID: <aTFojchpaTywDh1D@kernel.org>
References: <20251204102905.1048000-1-arnd@kernel.org>
 <93782526-c198-4590-b96b-c4f630b8ecbb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93782526-c198-4590-b96b-c4f630b8ecbb@kernel.org>
X-Rspamd-Queue-Id: 6A701100002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 4iwmjkf3mae91xr3ir99af4174ghfkns
X-HE-Tag: 1764845719-105163
X-HE-Meta: U2FsdGVkX19lTPBNtG1rNYAYziv1uwve+8pdUaoP5Tu5G9PdUrHIJmA1uBJUOnR1hPAm+TvC0zRM8yzf1Km937Xdfkuw2ay+TKxfAspjgOrMv3kDWeLO+DfShu8XMp7xAXSsIIZwn9992nGf7DFFDlMHKMlTaWIbL+EACZUKsj2uaFbV4jZA5uguqX27TiqiuZHpJ5xVn/3ZWpUk+bfO3j8zGXOlusdxwPf6+RbYq1YlnYtwcAsnq7MqypFOHcinmR/aLPob2ftsMlFOGVUXpZp/+rMxhMwpPbL625tXy4/rAuxNaPIhI6BDiJ1BRTNBwOzngQyZZ1uY5YmZ0YYg2FT5UPgOSLQgMZn9Zg4GfvE+mDav18bencgx+bYzKEeTRAtaP9xDVE/otFjYvcv1JMsNNc2NUtyqfV7fDYOJFX26ZfWeAFFztAhtpqXbvMgnxP2s2OYJldKCDihjNj+wEm/PsDQ9io/e04rKr9PAULr8vaFSsGctLxGFu1z5w55PGCyt79GpaPvhrbKQYi2vhAOSHPh4Jv6/GGYSBRP6FNuLvawFuKOjjrw/IwFh8M7XPS1aaJByMLFTQJDwWH46/I7d2DxPEmSQQ6CU9bHPl74AFetifClHbLYLa/bspiozVyiP0kOoYw6Z/vlKTdNf6iKcCN+LMOU5lEf0zrX3fHM0ziUhM73JveLA2ioxX9aLbt+vOq4hDwjUsi0M4UTDZ4bkREvbL/qG/dEb/T1LM5WPAoSMkoHR3dP4PPuVt9iVQc4fKoqyabVzlwlDR7r5vXlX1sznM6PO0dTpwiUn7kcYA2oZVTNLEpIyMzhIo5lPyTA/rhXmd9H3KsIFlO4c7Dzaji6Lrbwhk75kkNeuDdd7k9/x7iab7bqsfTUeKqcz5YGjwUFBM+ytRrz6IPvflQEyodcHAvVL/OSAKVRNHoIkFAfmyN3kZQu0CngHfClJ45iLJDO63ZWorNNvadK
 3X6JYL3+
 SPhXdtQcZYaqrZ0EbDvvfre215fc0OVJnFEd7cpMzEL82ja32Kc9lS6HbJVuz4bBfj8ZqvZFn/OdBa26Pbi4NPjdOmd7Uk9JGpCTLY1kU5aACEeY2zhzeVH7O1BGxSQybP31C0TYWcQjqB3Vm5uaS4IL7y0UGELYfuzdXPXs2DEwDsgSW1bgwBTj49Ffu46jTuwIOjtluYTWVzJzMG02xPpLxiZ+4TVARwfqtVqGoIjdZ0dQfgbwOmLopq0AoOKdJ9yh7qkYvE2QRevd5rWmAX0IMEF6qMzgCsr8Tk4LdqHVOQxoP87U19zrwo1xanIEXWlSD5yazRrgNrjNoXmiDPjiE5BLQTnHbBVlv7w9o0et0nQNgZbfkeOss6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 11:34:24AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/4/25 11:28, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > The newly added 'flags' variable is unused and causes a warning if
> > CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
> > into does nothing:
> > 
> > mm/shmem.c: In function '__shmem_file_setup':
> > mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=unused-variable]
> >   5816 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
> >        |                       ^~~~~
> > 
> > Replace the two macros with equivalent inline functions tto get the
> > argument checking.
> > 
> > Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flags")
> 
> That's still not upstream, right?
> 
> $ git tag --contains 6ff1610ced56
> mm-everything-2025-11-29-19-43
> mm-everything-2025-12-03-23-49
> next-20251201
> next-20251203
> next-20251204
> 
> So we can likely just squash it into the problematic commit before
> proceeding with it?

It's mm-nonmm-stable, I don't think fixups can go there.
 
> Thanks Arnd!
> 
> -- 
> Cheers
> 
> David

-- 
Sincerely yours,
Mike.

