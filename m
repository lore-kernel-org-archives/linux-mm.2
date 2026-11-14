Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8BAB606A331
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O19UBMrA
Received: by kanga.kvack.org (Postfix)
	id 0F56C6B05BA; Sat, 14 Nov 2026 12:33:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CD556B05BB; Sat, 14 Nov 2026 12:33:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A3C6B05BC; Sat, 14 Nov 2026 12:33:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAA4D6B05BA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:33:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7EC7FA7BD4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:33:39 +0000 (UTC)
X-FDA: 85434421758.22.DBA623F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D8E7580006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:33:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O19UBMrA;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794677618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMjHeqkDRZE8dhy1hqRxTcDbSg1/bFbdQHaCHWsCozw=;
	b=5fQSZltUFwe5aEX91jBPJiNcsqOPuFPw0dUJllku0iipMCC0ZsfsWe5V6Cv/Ga32GBALii
	DvqZmBWB7HQZDUm+faDZeCz7YvFyQbhvS65D1sg7ugRDGYs5nuw4daW7thOo3hFS1LH3bQ
	rxDPIvkhfXUqfMPcIafiStczjRExzfE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794677618;
	b=uyjU6ww5uhQfigTDdTxpdOPdo4s9evUNAUnwc4XJn4VdFS9QTa+Hfn6OeGgnYY8G5bgHWc
	qSzygV8EXx4AC/6y2516/ch4yXzRuoGcdoU6zib3dH5n5WYSPwtCRKEA8LLVoLRz+8Wjef
	Ci8zsqulC0AmGmb9W8MmMenelWFEknc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O19UBMrA;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1908E406E8;
	Sat, 14 Nov 2026 17:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3003A1F000C4;
	Sat, 14 Nov 2026 17:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794677617;
	bh=VMjHeqkDRZE8dhy1hqRxTcDbSg1/bFbdQHaCHWsCozw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O19UBMrAXkSoqPs2prqibtCjHeT2ADtnsEqYx5CwN2Oz2VgZ9KcZRHMdcNCOcdfgl
	 ORgZffaPijVySmPmQ6Je7Leyt7vh8GDA4rqz4FakWw97AhfpzssLYjZupsgOQAZAAw
	 rrsUb2D6bnRPbSgcp7Mrwd6/5MT3vLYsIs/m6OqPkVV7klRQMXXJtEbufp2JLV7xVv
	 TH2lNKIi9KMJpq7YRLpHUuP6l7p+aka9NtHOoaViwLbdxP37X/QZV3kntbmTcqYy8e
	 13Nj1AwEP17GmyWaTaNOEZA9ckwfLaHcaYngHulFXkulfjPwlvUstfQTsIBdPOscFI
	 Lz6Ogx5In6jug==
Date: Sat, 14 Nov 2026 17:33:32 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: shao.mingyin@zte.com.cn
Cc: akpm@linux-foundation.org, rppt@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/execmem: check execmem_restore_rox() failure in
 execmem_cache_free()
Message-ID: <avibYdE9NJKchXM-@gremlin>
References: <20261115004704544fuMEkcx0F4A1sNBAzz46-@zte.com.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115004704544fuMEkcx0F4A1sNBAzz46-@zte.com.cn>
X-Rspamd-Server: rspam06
X-Stat-Signature: tfzi3qfi4omkt4wgmizsuqtmx9wuc951
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D8E7580006
X-Rspam-User: 
X-HE-Tag: 1794677617-667643
X-HE-Meta: U2FsdGVkX18aBIkrxpzpIrEElAY9T6ggjIqQ9xTwLnUxIIYX4p15/LY95DtEwLma39ZtHuer5nWQh9hlWJm5rAkKYqlP/Xwq6U2qpA5GX/VtaETaxF1W9DeafjGgBbEVf8W9f/3gyuTHxiJWIWIju7WFTmwVXEL5N8F0Mme7vntONtBfdvFry90CDlmFGTP9zczTcWxI/1szQnr0bMCRJFBRkWSrIhabirX8BmNrJsc49AIZSht4EpECQuS13TwLeldvwXot0E+sJeFkyZoSKvVGDeLzcmm3A6MSiNr9mNCllxT4GIXs4041kyyYxpRuAbd8uUa+xeYXHJhjugL+HSVK+ye1ejd9RTQSgRSURjR0wnedHcsLTN+dIgJCcMv9wxtwA08clxM0c/EDddidgStB1aelydFqIAPLdWG3nZQaZCJ1T1wCZD2IS5P2nf3FD9G00cEG6P5ou1onvc8vlfUZtQ9LBNP8Ykof1MsoArWuhfc6r64dEQlqVJ3MLSLOp/pu6QO2HvPR7M97a/Y9u2R2NmGoZkgMfqoZTOh9Z2ZgQa7gIjil/5947qoUMu9xZVd/2ccRNt27sOYgwMHZ6ZxtHwiC4HndoTy0PsoZNiMncnmkMOPbDDZZNvqO9CvGDPNEvyH6exiDKhGT5Dxf8Ogu8X/JfDS28e8IcBWMNTHeahNFXGgJwKAFimWlLqToVMRQNATa5ILABlGF5aXybiVnr3vmqrpEn1yp1VdCN3GJaCCWxaHg5waQgNoWXJD2O4Un9iGxWmVLseUGJGXDZQMT3SMlSfOG9BZRgQ73MokXYtJR9LAKrFt7PkJ4lLTu/p/kBn7S2dX6wyMS5U89Xj8uwgpYNcNfRVeqpxDUxkM+ikZs25b26G2ULYj/YlPTk1c8f8KxQIontjzXUdI7LQUTzbq5ffAu4wrtpnuO4+uVOjihlJqiPjw1zqiBJOZn8UMiY5JSus+kdwKd76E
 eT2XBF0O
 MNLtreqVVKKr1qZt9/NvucHHbcujUGb2NgFbM9orRMvZ1MpttusGABRuuTfPGE8xBKpyZUei0NNBBSPBmsekRqk0GV8KpslDLZglEvFuD8x4iVJk1dTk24QBwwWufIHp46XXyccpWrvIsVyt6Hl7kA5gR6MUPGFP22ymxLAEv8Y7ky78PDE8+551QsgyeNG72dtfaAdcIzFFguE45D+ekazU955Iq05kttN4I5a0XQcDjsxTBB+dLVkcoz0AtS+eDqLDcjVASjQnndrCe80uk/BeNsOhxW6uM14k6IaEnzRWyuNFpMJl0aHYRhaRYkG+aTVBwsL2o+nlLIwMVLQaczB3uyxO9sLm6eUF/M0YgwFcUIW6kXRTQBZV8F2nkHK9qZ7FF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 12:47:04AM +0800, shao.mingyin@zte.com.cn wrote:
> From: Shao Mingyin <shao.mingyin@zte.com.cn>
>
> mm/execmem: check execmem_restore_rox() failure in execmem_cache_free()
>
> __execmem_cache_free() checks execmem_force_rw(), but ignores the
> matching execmem_restore_rox() result before adding the block to the
> free ROX cache. A failed restore can leave permissions only partially
> updated, so a later cache allocation can return memory that is not ROX.
> The cache allocation path does not reapply permissions.
>
> Check the restore result and return the error. The existing callers keep
> failed frees pending and retry them through delayed work. This prevents
> a block whose ROX restoration failed from entering the free cache, and
> matches the error handling in execmem_vmalloc_rox().
>
> Fixes: 187fd8521dd8 ("execmem: rework execmem_cache_free()")
> Cc: stable@vger.kernel.org # 6.17
> Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>

NAK.

this is generated by some AI slopper's script, spamming the kernel. The
patches I looked at were wrong/broken, so no to anything from this person.

They've sent 300 mails in under four weeks spanniing: ata, scsi, target,
ufs, nvme/nvmet, ubifs, ublk, zloop, dm, md, mmc, virtio-blk, mfd, gpio,
pwm, spi, PCI, ASoC, ACPI, net, vfs mount, block partitions, and now mm.

and 17 series across 7 subsystems over the past 23 hours.

We need a way to ban emails from people like this...

--
Cheers, Lorenzo

