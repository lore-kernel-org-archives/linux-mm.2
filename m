Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7FEACD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 18:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F272E6B008A; Mon,  8 Jun 2026 14:12:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8996B008C; Mon,  8 Jun 2026 14:12:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDF66B0092; Mon,  8 Jun 2026 14:12:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D096A6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:12:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC50112024A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:12:00 +0000 (UTC)
X-FDA: 84857539200.01.E42EDBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E644518000E
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:11:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N9+AtIrL;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780942319;
	b=WyJ8mbooTlNLVqlEBc1WcsHTrXqurVTJ+big+ts6RU/pnQplkTi3jmkDnvaZvyp5fFylNV
	ldWV7jwy7wH9EAROrph3fJZK7uPjo2axcv7Jx4XXMYJrqFrekKBCgxNCKrjMsFW5OvFS2x
	lIy/H/1kFkkMwiAkCjpdBXFeLZUrWb4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N9+AtIrL;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780942319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nXMkgjQY8cbSjj7UUHQBkhIgTYx0L9j6jxNKCSfRR/8=;
	b=qgP+wBPTxOKVpXHP6mECl5B1d0idSlFWZOIy89GxZSrxuziMKDME6dv1LfAWHdqI2WdOMC
	sa0T6pheWkoJFrS+K8/8N0oo7GI6/mYBUPGVqQTasS+vXtPCjHkGqtWIR/x3Hv9dhlcDvE
	Hn378LG6lTG85eeirJzsB3Tt8cpaIP8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7975443A4;
	Mon,  8 Jun 2026 18:11:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1171F00893;
	Mon,  8 Jun 2026 18:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780942317;
	bh=nXMkgjQY8cbSjj7UUHQBkhIgTYx0L9j6jxNKCSfRR/8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N9+AtIrLVQpdc7MYuoue+QqGfo5pWl788/MHNHc6lOM1bD+gv64RDVH+TxAKvSbxd
	 YoNHx3+wVkZZyLTaOmcRplnw41gXKBAib1vmW94Y2TNA/2Tk+WIe0N4RwfUYliKrgx
	 7MaDHa/wyLC8WjeDldPVh1plY1PRvZgTmKK1b+Hyu9Z99LjNvEwXhldXxtbaDMyLwo
	 KQlOpSqNDbXH2EMqN+/mqB4b3XjF8F469+PJCReqy6MKcmWtMuOnC4u43FzetLriwU
	 4R+NN8OPZHpInZG0LaX0/Kzam7F1FkaEYSxSscKPwloEHf7GWBAlfBF1d1TDnIKYqW
	 pTC14H2pJewFA==
Date: Mon, 8 Jun 2026 21:11:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, shuah@kernel.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	jasonmiu@google.com, linux-kernel@vger.kernel.org, corbet@lwn.net,
	ran.xiaokai@zte.com.cn, kexec@lists.infradead.org,
	pratyush@kernel.org, graf@amazon.com, rppt@kernel.org
Subject: Re: [RFC v1 0/9] kho: granular compatibility and header decoupling
Message-ID: <aicF5Sa11B4ujfSa@kernel.org>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
 <178083348872.1648214.17778188633648887952.b4-review@b4>
 <aiVp5RlbWRz5VnPB@plex>
 <178091437240.1648214.10761111570005003901.b4-reply@b4>
 <aibYJvzQQnpoN6YW@plex>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aibYJvzQQnpoN6YW@plex>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E644518000E
X-Rspam-User: 
X-Stat-Signature: kfknix1rkmxe51fi69b1pogouksabd5g
X-HE-Tag: 1780942318-461019
X-HE-Meta: U2FsdGVkX198w2tB56TqMQsCcV4JN/rFT0z+PqHBtDyCjcpR4/00PDvhwJHnPNQIr+Ua7cC2YZDGCVfRnKC5rxBrPvLbmnDU5EP3+5eXuJBqomiMKS0idHFmh4c3iohixqFkUYSR5eEZiivUehBHYXVys8RnrJkQoYKejIc5qmcfJgLrFxMRUW8+aLZm2Swfaj35ecUc+yzxz+S5iigLn6r2wrvB966yGetakmFTk8oDUCv9Ms1j3FRLgQXmdldvU6ksl7RGiExov1WtCH1/ixYqJ+U2c7b+mqwZZ1zvCJMBpTiyaM4dB08lNl0mY9je3K3/WW0+rrP9gpLm1qsaHK8UKsQZcGTUWb5QFwcxrvmPTdqxQ8l3o+Ez0ssYSOIj386F9D/JETv3B6kfIRaYJruL+RkTJUlKqGZkOWqnUYMn4EnUW22MvimB5LVvjo7o0NMaqPDQ3Qldn8kw3uDy0N1WaDkXf3wHX8IraDDsxM2WTVCFAO1rGJWulrgvTbFiTx3YY+V2S5PEVIExQWcdgi/GMk7OS5jvVs7LeczGSnLD3sAhPjgzWezvZSpHJBBntROYpwbUPLLliLbCfMqAMiwOh5oAjiH/U1PbGH/MytpVTJRp3Dx6B168RK1jPRuguMddTJ/uY8axEjKy9hL4LNUvAsEw0cKkkFKUYPZYkOGcI11HsyNE7IbrawJaL3N5tf60nQ+P/xB/XthIjmd0aWPGucWnmYURHfAD7OcbrfCcEL9D62eISQk/XoEK1z1czljjvUL2ZJPCNG0FXiDNK1r12tvz7jIJ+nruat3t2QnvgHSduFEt4DCb/12jbBRRrb20wygBN1J4YurFYDlRNtMwbjxN6ZH18ypZrH1EKAmW5TwNLXk8IwDO9qVzssV6yoZBnAWifL4YLZN9LH1fepcFdvZlLJVEZTjYJa1MbqCV2hodl/LZ0N91dm+ezy8qMZ8hTSVECIxofIAE2fR
 9nLWmoze
 hh4MXuKcHiSjl+OWAYbiK0veuOHKGihEo+qOREQpICv7PJdDppFbBXoriSzECRrjC7HtYD433/QT6W8+8jOBFcn23keyvQCpfrxwSSe3wU812Qdlk/QL/G4elJWPGxtZwDYOg0OcPgbN8yYDw7bgtUBQl4SEk9XbUXXn994osZOAB4i97LmVnPihXODSn4Zx9PeY3RvJP2d72KszopyWGj8okI0RoKmlsPIgy3vt8J+Dp+oVPDvggM58q3zgyKULpbm/vq1IL/Kr4LGklQmlom5hDzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:12:56PM +0000, Pasha Tatashin wrote:
> On 06-08 13:26, Mike Rapoport wrote:
> > On 2026-06-07 13:43:09+00:00, Pasha Tatashin wrote:
>
> Keeping all of that in a single KHO file is the wrong approach and goes 
> against how other logically separated subsystems in Linux are organized 
> (e.g., mm/vmap.c, mm/vmalloc.c, etc.). Yes, there are some messier 
> places in the kernel as well, but keeping this in its own dedicated 
> kho_vmalloc.c file makes complete sense to me.

Either I hallucinated or b4 ate a paragraph from my reply ;)

Regarding the code movement
- splitting radix tree makes perfect sense to me, just the documentation
  part needs more care than mechanical move
- I'm fine with abi/vmalloc.h, presuming KHOSER_PTR() is not part of it
- I can live with kho_vmalloc.c although I still consider it unnecessary
  churn
- I'm against moving vmalloc APIs from kexec_handover.h because they are
  very close in nature to folio and pages. I don't see core KHO as
  responsible for preserving physically contiguous ranges but rather as
  preserving allocations. Not sure we'll ever support kmalloc(), but still.

> However, overall enforcing the use of KHOSER is unrelated to this work. 
> I have my own thoughts on this, and perhaps with proper versioning, 
> using KHOSER_PTR everywhere would be appropriate, but let's keep that as 
> a separate work.

This is a separate work, indeed. But regardless of the versioning it's
already better than plain u64 because it provides type safety.

> > Actually FDT "compatible" handles versioning nicer than composite strings
> > You can have
> > 
> > 	compatible="kho-v4", "vmalloc-v1", "radix-v1", "block-v2";
> > 
> > and check fdt_node_check_compatible("vmalloc-v1") for vmalloc and
> > fdt_node_check_compatible("block-v2") for block.
> 
> That is actually very similar to what I am proposing—individual version 
> tokens (which in my current series are concatenated into a composite 
> compatibility string separated by ';').

Yes, you reinvented the wheel :-P

The difference between FDT-compatible and the composite strings is that the
strings are all or nothing while FDT is "any of".
But that's only a side note, we're not going to use fdt-compatible.

> But let's not get too fixated on the composite string formatting. I 
> actually really like what you are proposing: using integers for versions 
> and having each registered component carry its own "NAME" and version 
> number in the KHO FDT.

Yeah, something like that.

> Pasha

-- 
Sincerely yours,
Mike.

