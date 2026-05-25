Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C038CCD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 16:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D0B6B0098; Mon, 25 May 2026 12:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34D16B0099; Mon, 25 May 2026 12:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4A8D6B009B; Mon, 25 May 2026 12:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C64866B0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:24:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A8F21A0197
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:24:25 +0000 (UTC)
X-FDA: 84806464890.26.A55B2C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id E5BA21C0003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 16:24:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e6XDvUQs;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779726263; a=rsa-sha256;
	cv=none;
	b=D8xqwB7mC4kQuVGh3DlBmowzQ3gOnBJM+w0WBgH1nyrJlS/xsaSs1qR0f3VgJv/09kcEiH
	bnbQ+ebSmRDIoHRNhI5foQchbYQUTJV3qS5JTM0q6Czbftkfp56W+FDBmz6RRycW1JX8R3
	lL/CZ9uijDj6U65piNes2wSebDyJ11c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e6XDvUQs;
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779726263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/uYM7Uc7JRbhfGHHhf03rXJodyqFN96ymQHCiubqvk=;
	b=emavll0+8EjHTBqrzUSJLzUNHB/UOBn5NkpgBD4fugedvnqbYFGm/M0ZQcIxXiC1AeV5bo
	iPbXKY4vS4OX7dcYNJe1lp+b/pp576EiB9hmcX1upYHnDHw8VE7i2EVsM0+j4Jr0+0AmDp
	WeHchNSEUqHwaPAAGd7cYRAzgUKBx4Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 547876008A;
	Mon, 25 May 2026 16:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0731F000E9;
	Mon, 25 May 2026 16:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779726263;
	bh=z/uYM7Uc7JRbhfGHHhf03rXJodyqFN96ymQHCiubqvk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=e6XDvUQsx2eTcRuCA1irVbXIxaLJohA8c4vcRWz1eC76UVWyXAyC7fbfnNjlrutj7
	 gju+RUO0DX6Wdxv2wd45akCscpQbUFeYuR/iT89vvfZ8OYMZp/G9bWDrglUvOussLH
	 UVEDKAAa8qgS3ng+sx5vcKgs8AWPvPfN8D+YCccc+GtIlf9jAwvUPx7Z6yE5ogsqAd
	 /gtJeqsN/8BUsHFqXyiqFi8IpZKZvDotnuqL9hrRO4+DCbp6o6fGmQn8b+JjzqXuNv
	 c+qkFRmCkpe9v5zFgQAEGcKqIrs1VjFpUsZ1iO/1m/wxCVgRrBbzEwcdrw/eyWiHib
	 /0Uo9hBFqHCfA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v2 01/10] liveupdate: centralize state management into
 struct luo_ser
In-Reply-To: <20260514222628.931312-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Thu, 14 May 2026 22:26:19 +0000")
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
	<20260514222628.931312-2-pasha.tatashin@soleen.com>
Date: Mon, 25 May 2026 18:24:19 +0200
Message-ID: <2vxz7bor78zw.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E5BA21C0003
X-Stat-Signature: g94njzfbxc1d363iy6hzhiyp3pc4n5wz
X-HE-Tag: 1779726263-960961
X-HE-Meta: U2FsdGVkX19yPF1hLnKVjuezdrCZzmi4F+3J+I14d0P1bY+EgYnALcxOi0Xk3wO5tjOjH//Qxa0JlS26Lq00eio6smWnHaSk6S0PoNdEoF4n3g3/9n/iStK3kk085GExjRSing1gpNDuGKdTaXGZBkVrPvsmIQJ/aWGXZ8AFHjSX991rFwNEPHvpplyJN5teHjQDBIukSykDUuyUQFzsK+/HAz1U8l0rS0yBDklEUKH/phCf5dVvZwXwvWeV8xgvQdTLaFCkvZD/nt4P2lk02blCUL3dRn0K0NbjDYrhWlV+Xt8mQl254c1dBiB5Dd+LIY9Glhowe40DRRANS/yGPOPe/Smxu1FwC3mpOxVfwJiM99P3zXcCbKBHSaXchDjOALHUBs5CRw9fmQgn/h6Hw6YZ2vKitIvofqGEEXmUfMzZ5384KlbEyxedQC2ClqnbZ52FcDIKn3UycbhRkmApl3EocH8DShoqql1aFDim1BRYsB21+sw3CW8j83RtV02G4ppXVr0Zm2BCuZhFx48XE5ezslOEofdT34z3vSYn1GaIcgLSaDy+tZkMWw0nL1bK9+u+x3hJYInuMkOqnLrUWXLtCO6FuQQNdw7D9aIgBCj1BXF9jlEZ4Cdl7hULukHHKceiUK96MaVvF72SG70SG/oCAgusqFE0snIe9wsmKQr8F6WRUJ9/55uSffWtGcaNP1+meQWUdDO2ASJgrGg5DcoGyfaizzBNT0MldUWwoCUTdXsIYabx/p7pCJ/z0ptJk5R9V85GgmkHwT4Z3GbzDXzcPSoWefGh70+/naw34cufhWeeaga6zAThgfmLmr3tI4KD3zPA/VmNel2WQJq30zVOMTTCAFwupiIwWpMzPZUV/XWzx3OS52DfAYNHSSNEQFNl/YAaxWi+MiOPXSZammdvMRCd1gVgNDh+v+lb8JsX29cYf7TpIIgLtJA1CAc6xqo4A5Oa44WFA95TFQ/
 9F/nEirf
 flh0625VyTFjm+TTxqsjKI06FWoyD5TFp5ITiMYhMy8RfCMjB5D/P9blJEo5F9/hIxwfr5v9dOOQyOSJjRGDOnu1ufq4FTrT/47NgIT8DlPFTMULXTfd2MHPjODsGOjdRDhVloFBA2Gibgxr0a2ZcB/XTL+dibYxE7ZdS7qC51cOk92/8GT/z/JK6pCqKuBk2RTLV2ovfhELtHS6xS2E0+Em12BsKyseF+OwwkM6hpfG1Ord+u0ZGQSfWIrbsbMVjDZBTxHGY5pcw882CoIPUmdbmENkWzwCUKnS4Krxep8X1Ut1AXcj6bqdoBt+ql6xZDspR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 14 2026, Pasha Tatashin wrote:

> Transition the LUO to ABI v2, which centralizes state management into a
> single struct luo_ser header.
>
> Previously, LUO state was spread across multiple FDT properties and
> subnodes. ABI v2 simplifies this by placing all core state, including
> the liveupdate number and physical addresses for sessions and FLB
> headers into a centralized struct luo_ser.

Makes a lot of sense I think.

But nit: this brings about a semantic difference: now sessions and FLB
serialization format is no longer independent of LUO. I think that makes
sense but can you please spell that out in the commit message.

>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kho/abi/luo.h      | 91 +++++++++++---------------------
>  kernel/liveupdate/luo_core.c     | 59 ++++++++++++++-------
>  kernel/liveupdate/luo_flb.c      | 65 ++++-------------------
>  kernel/liveupdate/luo_internal.h |  8 +--
>  kernel/liveupdate/luo_session.c  | 57 +++-----------------
>  5 files changed, 93 insertions(+), 187 deletions(-)
>
> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
> index 46750a0ddf88..1b2f865a771a 100644
> --- a/include/linux/kho/abi/luo.h
> +++ b/include/linux/kho/abi/luo.h
> @@ -30,52 +30,25 @@
>   *   .. code-block:: none
>   *
>   *     / {
> - *         compatible = "luo-v1";
> - *         liveupdate-number = <...>;
> - *
> - *         luo-session {
> - *             compatible = "luo-session-v1";
> - *             luo-session-header = <phys_addr_of_session_header_ser>;
> - *         };
> - *
> - *         luo-flb {
> - *             compatible = "luo-flb-v1";
> - *             luo-flb-header = <phys_addr_of_flb_header_ser>;
> - *         };
> + *         compatible = "luo-v2";
> + *         luo-abi-header = <phys_addr_of_luo_ser>;

While you are at it, perhaps also get rid of the LUO FDT entirely? With
this change it only holds the compatible and a pointer to a blob. Might
as well move the compatible string to the blob and use it directly. Do
you see any benefits of sticking with the FDT here? We have already
removed it from memfd for example (and AFAIK the upcoming PCI and VFIO
patches also do not use it).

>   *     };
>   *
>   * Main LUO Node (/):
>   *
> - *   - compatible: "luo-v1"
> + *   - compatible: "luo-v2"
>   *     Identifies the overall LUO ABI version.
> - *   - liveupdate-number: u64
> - *     A counter tracking the number of successful live updates performed.
> @@ -109,13 +82,26 @@
>  
>  /*
>   * The LUO FDT hooks all LUO state for sessions, fds, etc.
> - * In the root it also carries "liveupdate-number" 64-bit property that
> - * corresponds to the number of live-updates performed on this machine.
>   */
>  #define LUO_FDT_SIZE		PAGE_SIZE
>  #define LUO_FDT_KHO_ENTRY_NAME	"LUO"
> -#define LUO_FDT_COMPATIBLE	"luo-v1"
> -#define LUO_FDT_LIVEUPDATE_NUM	"liveupdate-number"
> +#define LUO_FDT_COMPATIBLE	"luo-v2"
> +#define LUO_FDT_ABI_HEADER	"luo-abi-header"

Nit: If we do go with FDT, I suppose "luo-ser-pa" (or "luo-ser"?) would
be more descriptive?

> +
> +/**
> + * struct luo_ser - Centralized LUO ABI header.
> diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
> index 8f5c5dd01cd0..7ccc59981297 100644
> --- a/kernel/liveupdate/luo_flb.c
> +++ b/kernel/liveupdate/luo_flb.c
> @@ -159,8 +159,8 @@ static void luo_flb_file_unpreserve_one(struct liveupdate_flb *flb)
>  
>  static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
>  {
> -	struct luo_flb_private *private = luo_flb_get_private(flb);
>  	struct luo_flb_header *fh = &luo_flb_global.incoming;
> +	struct luo_flb_private *private = luo_flb_get_private(flb);

Nit: this doesn't seem to do anything. Is this a stray change?

>  	struct liveupdate_flb_op_args args = {0};
>  	bool found = false;
>  	int err;

> -int __init luo_flb_setup_incoming(void *fdt_in)
> +void __init luo_flb_setup_incoming(u64 flbs_pa)
>  {
>  	struct luo_flb_header_ser *header_ser;
> -	int err, header_size, offset;
> -	const void *ptr;
> -	u64 header_ser_pa;
> -
> -	offset = fdt_subnode_offset(fdt_in, 0, LUO_FDT_FLB_NODE_NAME);
> -	if (offset < 0) {
> -		pr_err("Unable to get FLB node [%s]\n", LUO_FDT_FLB_NODE_NAME);
>  
> -		return -ENOENT;
> +	if (flbs_pa) {
> +		header_ser = phys_to_virt(flbs_pa);
> +		luo_flb_global.incoming.header_ser = header_ser;
> +		luo_flb_global.incoming.ser = (void *)(header_ser + 1);
> +		luo_flb_global.incoming.active = true;

Nit: Not getting FLB data resulted in a error print. I suppose we should
keep that here as well.

>  	}
> -
> -	err = fdt_node_check_compatible(fdt_in, offset,
> -					LUO_FDT_FLB_COMPATIBLE);
> -	if (err) {
> -		pr_err("FLB node is incompatible with '%s' [%d]\n",
> -		       LUO_FDT_FLB_COMPATIBLE, err);
> -
> -		return -EINVAL;
> -	}
> -
> -	header_size = 0;
> -	ptr = fdt_getprop(fdt_in, offset, LUO_FDT_FLB_HEADER, &header_size);
> -	if (!ptr || header_size != sizeof(u64)) {
> -		pr_err("Unable to get FLB header property '%s' [%d]\n",
> -		       LUO_FDT_FLB_HEADER, header_size);
> -
> -		return -EINVAL;
> -	}
> -
> -	header_ser_pa = get_unaligned((u64 *)ptr);
> -	header_ser = phys_to_virt(header_ser_pa);
> -
> -	luo_flb_global.incoming.header_ser = header_ser;
> -	luo_flb_global.incoming.ser = (void *)(header_ser + 1);
> -	luo_flb_global.incoming.active = true;
> -
> -	return 0;
>  }
>  
>  /**

> -int __init luo_session_setup_incoming(void *fdt_in)
> +int __init luo_session_setup_incoming(u64 sessions_pa)
>  {
>  	struct luo_session_header_ser *header_ser;
> -	int err, header_size, offset;
> -	u64 header_ser_pa;
> -	const void *ptr;
> -
> -	offset = fdt_subnode_offset(fdt_in, 0, LUO_FDT_SESSION_NODE_NAME);
> -	if (offset < 0) {
> -		pr_err("Unable to get session node: [%s]\n",
> -		       LUO_FDT_SESSION_NODE_NAME);
> -		return -EINVAL;
> -	}
>  
> -	err = fdt_node_check_compatible(fdt_in, offset,
> -					LUO_FDT_SESSION_COMPATIBLE);
> -	if (err) {
> -		pr_err("Session node incompatible [%s]\n",
> -		       LUO_FDT_SESSION_COMPATIBLE);
> -		return -EINVAL;
> -	}
> -
> -	header_size = 0;
> -	ptr = fdt_getprop(fdt_in, offset, LUO_FDT_SESSION_HEADER, &header_size);
> -	if (!ptr || header_size != sizeof(u64)) {
> -		pr_err("Unable to get session header '%s' [%d]\n",
> -		       LUO_FDT_SESSION_HEADER, header_size);
> -		return -EINVAL;
> +	if (sessions_pa) {

Nit: same thing about the error print here.

> +		header_ser = phys_to_virt(sessions_pa);
> +		luo_session_global.incoming.header_ser = header_ser;
> +		luo_session_global.incoming.ser = (void *)(header_ser + 1);
> +		luo_session_global.incoming.active = true;
>  	}
>  
> -	header_ser_pa = get_unaligned((u64 *)ptr);
> -	header_ser = phys_to_virt(header_ser_pa);
> -
> -	luo_session_global.incoming.header_ser = header_ser;
> -	luo_session_global.incoming.ser = (void *)(header_ser + 1);
> -	luo_session_global.incoming.active = true;
> -
>  	return 0;
>  }

-- 
Regards,
Pratyush Yadav

