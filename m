Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26999CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 06:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E62D6B0093; Wed,  3 Jun 2026 02:49:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5116B0095; Wed,  3 Jun 2026 02:49:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E28A6B0096; Wed,  3 Jun 2026 02:49:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0936B0093
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:49:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 06921C107C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:49:42 +0000 (UTC)
X-FDA: 84837675804.23.D1D8B6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 599691C0004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:49:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N6Nv8rIK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780469380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=crii+t0f5mzLnKlzu0e4yXBuyqmERcK5UbHB2D3ZF4g=;
	b=lT+O2isWFcQ8PEG4JrHHNJik4Vq9oYMMLtXU5tFlZIblHHNBMWnnjGterB9zQT86u8cOjM
	3hArTiGB45kZFH4X7p/yjRaJaWa5Z8fjaYfRyQgoDolOVbkRYW3hZlt5+iXGaZiOVP21uY
	+6QNNEhM6QbB0guR77m16sRsQdACpuU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N6Nv8rIK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780469380;
	b=nylDZQmqcAGOq3no8l7jsUM2XY3fJZ3A9I2DBVKDfRhtRnfCxWctoAZfU3+ahSRgyiqSks
	8Ajoe4tIBn3+BBbNF40R6p7VNEVskahCbpVk6HPfVGahB0U9T8UmidllLcrkB4TJzoikFr
	ufZQEP+aPbV+/QL3fLbzNk1fodzvyqw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63BAC41B66;
	Wed,  3 Jun 2026 06:49:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3CC71F00893;
	Wed,  3 Jun 2026 06:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780469379;
	bh=crii+t0f5mzLnKlzu0e4yXBuyqmERcK5UbHB2D3ZF4g=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=N6Nv8rIKWJBny+CHLiEfswo8B9CE6GjbB4f082oZIvjQ8x4U2vZ6xI4MHdiYNadWW
	 aRJI/wiJ0z7XfcH80+ROET0WcWq8NGYl4RDxly+Pb1XHHCQiqM5qEaHxFfuRQYnfqV
	 ki/xPPZvgT5zld1kiNumyNIi9YhUw3Lg+LEpb1RvGlu3YCPPXEtyVmtd+a/V0TiD3E
	 Jfh0HQAtBZZMBw6fQsXQfV3NbrknaVB7bySHC9TNM6ZlwDHNQetxeSGTD8D45ewtUr
	 vIZaa3Mb1KveYE3YbiZLbvohTU30lsNDXy2+sBISlTbxMq6UogIcfLWQcCN61tq8HA
	 x2Lfj7vA5Kiog==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 07/13] kho: add support for linked-block
 serialization
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
 akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
 dmatlack@google.com, kexec@lists.infradead.org, pratyush@kernel.org, 
 skhawaja@google.com, graf@amazon.com
In-Reply-To: <20260603032905.344462-8-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
 <20260603032905.344462-8-pasha.tatashin@soleen.com>
Date: Wed, 03 Jun 2026 09:49:31 +0300
Message-Id: <178046937151.468621.13398573538792303093.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 599691C0004
X-Stat-Signature: nwbterfns7iaofk9b7tr3wpkankkjqw1
X-Rspam-User: 
X-HE-Tag: 1780469380-409150
X-HE-Meta: U2FsdGVkX19cUqkuQDBAcnHD7lYmZv45XmvAfxr7HnCk8pRnQbaeGdB5MHVphg80WUIoXuBzpIiEBnQVar32lzs8e4Iog+2uCdAKvspokJ0xgUiezK7sAv3uGxjI8yuLhKn2pg/eaDwxU0N0EH3XMLOD5IsJBKaX0aXBxQOOLVCCGwQ7sP7Xy4fsWqyg9ayAP4UjOCqEH7E6nFjTvINmdgjYhaKSPrukUr7iZPkjVn+pSbi0zWh2qKpnThpCyhEtENw3D3XnCNHrjWof4IDdyYdKO4Jyrg47GpZjPyvq9VyXIAuXnF6r6O9Vf2Gew5kbbI2VEV7YoptRG3XxRm6ZjYWDzs88+9FPTc1/2B6sUTnocm1tUBlC4uSN/CAnUWUUSIsyNMB+77xp0caPkSNB99K942kW0q/DCJDz8ogQGwP73JAvICGL4Rs8fLRYde/RVbGx40us0Om1uaW9I6Nl8JJn6sSCSwQrXZfik8L+EKPQpgzzu/Tp8iw3lyoH2/E0nib2hHB70CH1wDx/vmIwwHRwbHX7ODsN9WEjuz/FgNkniAPaLISsrYGHPZLhzudJ57TOWa2J/Bjox6hivZvQoYuHAIHw4SJZdiiWUAl9AiQRpU5dHykddLsksE5/JXNHnqGnjFeMnTsQPxNco4cNwKn7CI83KIRnSSu1tpRek9WNfVIq3JWd4+/Ip2hhDQsLWAKq2CMNhOh2UDtUYrYCsb+Aa1pEXJuQ+kdh7icvC/E99O+NyzgLxPpRNH1GIK5GPF1nu5Mn494mRPGEzWTZej+JVmmAFROx2p3GpJeviNZjqBs/uqGiz/fmoUKy3tc0wCbuwb5IPQ0EHZx6OqBUxSqR8yKVdx4NHFaAknz1PrM7OnHyCZXqnSwhGlLhxT0Vwcbt8ApOTotm78BhO+KguzhrREggBlnLH1DuP7jAnN3LDrn5Qt8okeSI9aVSWN4ytKPCDwGS6PrpTXp5bvo
 dzMvo0Ee
 Bphimvd5SmKsIm4IQPvOo9dx+PaxToX75CuPeN/QJ+eMVMzmksk1sVizc7LlYiTrvTOchJubTmovuM4kBDb/qemQgf3TX0VIqKCXV2MH1yTLqdWEhZiQvvbAhKSOfe9lMXCDQxzXe0555sWOCSXutE7WQq5NPa316coWp2XUn9hUi025WRVYNyb5909a/fD7OUhvpqtUmqiZI8e+UWA03xDbNiR0VKeUT6cvPz1YCYZEzEfMk8xow7nOHPUioHFbIFoiFUIK27aGQfRua1DDCzVrtOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 03 Jun 2026 03:28:58 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> diff --git a/include/linux/kho/abi/block.h b/include/linux/kho/abi/block.h
> new file mode 100644
> index 000000000000..8641c20b379b
> --- /dev/null
> +++ b/include/linux/kho/abi/block.h
> @@ -0,0 +1,56 @@
> [ ... skip 25 lines ... ]
> +#define _LINUX_KHO_ABI_BLOCK_H
> +
> +#include <asm/page.h>
> +#include <linux/types.h>
> +
> +#define KHO_BLOCK_ABI_COMPATIBLE	"kho-block-v1"

It's never used by block set and after looking at the following patches I
found that it's appended to LUO compatible string.

While this works for LUO, I think it should be kho_block_set_restore()
responsibility to verify the compatibility.

>
> diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
> new file mode 100644
> index 000000000000..4f147c308e6b
> --- /dev/null
> +++ b/kernel/liveupdate/kho_block.c
> @@ -0,0 +1,411 @@
> [ ... skip 121 lines ... ]
> +/**
> + * kho_block_set_grow - Expand the block set to accommodate the target count.
> + * @bs:    The block set.
> + * @count: The target number of valid entries to accommodate.
> + *
> + * Acts as a runtime notifier when new resources (such as files or sessions)

Not sure I understand what "runtime notifier" means in this context.

> [ ... skip 11 lines ... ]
> +
> +	while (count > bs->nblocks * bs->count_per_block) {
> +		int err = kho_block_set_grow_one(bs);
> +
> +		if (err)
> +			return err;

This leaks memory if more than one block is added.

> [ ... skip 31 lines ... ]
> + * unregistered, allowing the block set to release and unallocate redundant
> + * preserved memory blocks. Checks if the last block in the set can be removed
> + * because the remaining entry count is fully accommodated by the preceding blocks.
> + *
> + * Note: It is the caller's responsibility to ensure that entries are removed
> + * in LIFO (last-in, first-out) order (the reverse order of their insertion).

I think "in LIFO order" is sufficient :)

> [ ... skip 173 lines ... ]
> +		it->i = 0;
> +	}
> +
> +	entry = kho_block_entry(it, it->i++);
> +	it->block->ser->count = it->i;
> +	return entry;

This looks way better than the previous version :)
Thanks!

-- 
Sincerely yours,
Mike.


