Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FCE1E68172
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 12:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEAB96B0089; Tue, 17 Feb 2026 07:09:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95546B008A; Tue, 17 Feb 2026 07:09:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2AE6B008C; Tue, 17 Feb 2026 07:09:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB5066B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 07:09:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CC80140145
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:09:54 +0000 (UTC)
X-FDA: 84453829908.21.E7363DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id A862BC000D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:09:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p4u74F0P;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771330192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2os0qpogUwB/586XJ8r+5Xq6E3I48Z5gBFg3QuVGWis=;
	b=L1ireOOf/HmkFShtK/EbudOvGLznIEZ9fBIv4+fSKVGES2gpF4ApVLQ1OkYEcShdyfnL7U
	oaY9sr/jS083p4V/uCNH6PLNzrMXrs6ngUpKMl9orwyfMO6BJV0ozpjVZLgwkIZ4c+rfMN
	l4xE+qfJYKkp4KWbeoQXTXZdUhSBwB0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p4u74F0P;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771330192; a=rsa-sha256;
	cv=none;
	b=Wm9BhsU+w+tiyrhsS5F6B1PHw4vxjROZPq3NWyUPVholMeE+UAHamjSZqZI+4FspjJA/VT
	LCNOEQAk0DUPa7uQ8q+bPSBWNFR/Q/0DX8kwlsPTLpAPliQ2F6F0I1O8bj3zTEWgGaOlvy
	ZuwgtL2vABZIJg7c0jWGgP6YpoTvApM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1293061334;
	Tue, 17 Feb 2026 12:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4440C19424;
	Tue, 17 Feb 2026 12:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771330191;
	bh=+dDmsgNTxJ4xXTywjhKRtMBQjRXfDi/GXnhG2R1uzpk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p4u74F0P/z9HalXrm+ZixCxZNji6V6YooDDD5uK35jvkP46JJtGnvBx4yaiI6EHMk
	 md3+r4ms/xzWet1PaiK6q991NEZYvXNaBfObeUDUwPfFu3Lsda2xnpwOp1pUthOIKd
	 9OLHmc60NI36GALylCAAaXFHhYdbI07CrlLwVeSGM56eSNDPPawPkoNqHEaWk7qL4W
	 +/xyEviB4zlY16qq1mWwYnFoo2aFY5mIoiCcjHoGamILeQXpfwoEL+waJRQKUBlls+
	 fR6ORgECOWZxyAa5dM0CC8h7WErlFPiHmZS59GHgz75MGoXJFq6kpPGg3ZpC807dks
	 l1bTGgNJjKbmg==
Date: Tue, 17 Feb 2026 14:09:44 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Moritz Sanft <ms@edgeless.systems>
Subject: Re: [PATCHv2 0/2] efi: Fix alignenment issues in unaccepted memory
 code
Message-ID: <aZRaiCidlfNtPG17@kernel.org>
References: <20260217104957.249340-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217104957.249340-1-kas@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: A862BC000D
X-Rspamd-Server: rspam02
X-Stat-Signature: 5eft1m7xrqic76pgummdqjcacf9uw1o3
X-HE-Tag: 1771330192-611936
X-HE-Meta: U2FsdGVkX18hcTZ4ORjYzjkBtA0j5dB7RHS2CpWpjNlKjsln5q+YFB0bDDjC+wg6h/8pEgcQFHuLfap4Erk7a0bckT1624cdOjYt6IFFhUgcOL76iei/3tA3aoFHXkgtg2z2sRV1AXSEd/e7dEBLbOCt8Vz1S92/ey/XdZy19AHVdbGVncn1dndBLM5sbcUEbZ+A3QJgZif2PLcUr51LPOCuyIAUE42YAz6nLCEU+DYu4etGIqdcSxQs5Eqv7N3DskyJZ2tDr+Iq3sImn3/BpuWqRzcyxq868S9Rysuo9ipWZw9GSD3FkDkWkBk2WwWya4f9vmbVD7IYjiP+O8/zZC7K+9On9ZhEJM8xLUhEkcc7zHCjNlvcvoDzA0lzpdyhypxb152zSo8XbyXVq7uKobkH0+ezV2sqVxjMqH/p9GTDns1+sWz/3lL91X1SZpNFRT5ZWKltpl02ynoDmi9dCWiFOIDiTtxuS57D9Owxa8P4ItIWsklbIveCRVQ4z7ysudk6EgFV6rFYH7L7D42vIFoODgudirZCJkiryc91NqB5hC+BXlKYrhVY6LfQmOaplu0iaw5eTe6yZonDe2ESaoyzrvW/0J/3myxWTPrztm7CwY9V3PcvVbY0C7bNFVWUcOJgWCbNwph32Yug3Z8IbtsP+sYhKRUWymNgnDiKbLsNwRCli2lBOYbyPGRs48mPb1X+C/IJe726lemjz1C5Gk1mNyTcSi/JocJagSF0ueGBEF1kGhzaEe8FP4JJBRqwtJovP/YBN0YO9hvq8KkhZXQiWfY+i0LR8XBw+sOdZfAmBDRPj7eriY5N7lsE0E+5e92hLzjuBIO0pxjyAdnBOS/SHNm6KwHgeUGFpcH4FvmjONSFUBmFrY9vaOtH2qCj8GFostEBMc82pkgbFVOvHsZ7hvog5kcuuj/S87zUE3u8wJOZKdzKJV60sTBk5eJx2FNtKip5cvLZxxZHxCu
 DWhEr/7d
 Bige6xc0jO3nTyOxP1Qf6xEgCgtjT9KcjPkuroA3GvVInvRJB7C3OGvZFSGJl0sShVOJ8rF8+eFeqmQpMxtt5g+IV9ckLbqm8gunY5uf/E83DlroFtn48bRgIjRk08/7adt98oXicNsl8zVutmc+jWrt5xxpzIa1yF0B8qiSYb0iTeP67bLF+BbJo2tbsc96OUTPcB9hFuv/hVUn492o+5wogeBuLkcR051cu9h9aRE2KHdYTF7dce5euGbhag/mmjhx0FAO/sSsfx3S7+YKWOgU5UQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:49:55AM +0000, Kiryl Shutsemau (Meta) wrote:
> This series addresses two issues related to unaligned physical addresses
> and sizes when handling EFI unaccepted memory. These issues were
> identified as potential sources of kernel panics in Intel TDX
> environments due to incomplete memory reservation or missing "guard page"
> extensions.
> 
> The first patch fixes the reservation of the unaccepted memory table
> itself in efi_config_parse_tables(). It ensures the entire page range
> covering the table is reserved even if the table doesn't start on a
> page boundary.
> 
> The second patch ensures that memory acceptance requests in
> accept_memory() and range_contains_unaccepted_memory() are page-aligned
> before performing the unit_size alignment check. This prevents skipping
> the necessary "guard page" extension for unaligned ranges, which is
> required to avoid crashes with load_unaligned_zeropad().
> 
> v2:
>  - Fix 'end' calculation in the second patch (Tom)
> 
> Kiryl Shutsemau (Meta) (2):
>   efi: Fix reservation of unaccepted memory table
>   efi: Align unaccepted memory range to page boundary

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
 
>  drivers/firmware/efi/efi.c               |  8 ++++----
>  drivers/firmware/efi/unaccepted_memory.c | 10 ++++++++--
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> -- 
> 2.51.2
> 

-- 
Sincerely yours,
Mike.

