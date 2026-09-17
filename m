Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05254C88E72
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 387DC6B0098; Thu, 17 Sep 2026 19:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 310516B0099; Thu, 17 Sep 2026 19:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8A66B009B; Thu, 17 Sep 2026 19:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC1396B0098
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:49:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F9D240488
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:49:53 +0000 (UTC)
X-FDA: 85224899466.04.7BC6045
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BDC1CC0008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:49:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ne6BMIa0;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789688991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nsN+MnObPE5JbQyZhJ55IeEN7t8dHWyJ3zY4el12zro=;
	b=sd5W+9cPE5HVFLWx7YdMU6RVOrEIgVcXjL9ZIWJF7inO7M7cpuaCKvN+KJT3hSaerWuLz8
	F/pASQkA3/R8kpx5gW7VEVZ9htLe4klEYb74VRRdw/5ELysUZGzLXoT/5xcim+FWDvSQz0
	wlfgipqzFMCNr4sDct1SpIKu6pdIWZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789688991;
	b=3pYvMbM8kUV77F6u60wZzIOGgnYidjjAnLxx6Sbka9l4XWaVbaS2ybhc7jixo14A+TxpBc
	SB0pq73afRSIkaJvy4iQ+lz7wLzZghZvgQCl3X8ipOok5Hy/uWFsii0Zz51Sq6hlGR+Cfk
	z2sD50Fbpw1+acY7E7bJHFMMZp5+rz8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ne6BMIa0;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B20A437D9;
	Thu, 17 Sep 2026 23:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B79A1F00898;
	Thu, 17 Sep 2026 23:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789688991;
	bh=nsN+MnObPE5JbQyZhJ55IeEN7t8dHWyJ3zY4el12zro=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=ne6BMIa06ffN5Tenqt0HBivViNRKdOfLaF8X5KH8sC5XJ8mVtY6bZAbd89npXJ2T/
	 /+oUcFit7bW8xokVXmqABd0XicBaDXvN0ypu7JrRCq3/8/23BxM9Ppf2ZG4NNKLVKe
	 gJZ9Ow831svvJNL9Il22We2TMYVsnVgpnhIRpccX/vyo14jr7bjd0MxPqSt4kbWaVS
	 GRuqf08jr1pHuo81ULgrjlwFMVwY7xprk3nNqUyzJq+UdnZRbyVVaPeoqQxYFrKAy3
	 VHyapLZAyoIyE6fA46A9XFnrzhKuaoAqImwyq4xw0z3abaeb9mxIZbwLpKsINDzH1a
	 UVFS8hQdhhJSg==
Content-Type: multipart/mixed; boundary="===============9216955143622942885=="
MIME-Version: 1.0
Message-Id: <e7ff3f8ea537dfb920e2eb4b8a10c729d4e40014cb801472f4be848eab69da2c@mail.kernel.org>
In-Reply-To: <20260916195203.1099646-3-ihor.solodrai@linux.dev>
References: <20260916195203.1099646-3-ihor.solodrai@linux.dev>
Subject: Re: [PATCH v3 2/5] x86/cpu: Initialize boot CPU cpuinfo defaults early
From: bot+bpf-ci@kernel.org
To: ihor.solodrai@linux.dev,bp@alien8.de,dave.hansen@linux.intel.com,mingo@redhat.com,tglx@kernel.org
Cc: ast@kernel.org,andrii@kernel.org,ryabinin.a.a@gmail.com,akpm@linux-foundation.org,hpa@zytor.com,andreyknvl@gmail.com,linux-kernel@vger.kernel.org,x86@kernel.org,bpf@vger.kernel.org,kasan-dev@googlegroups.com,linux-mm@kvack.org,kernel-team@meta.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Thu, 17 Sep 2026 23:49:50 +0000 (UTC)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BDC1CC0008
X-Stat-Signature: cj38qcqqpd469766bfdo4fq1irnn7s8t
X-Rspam-User: 
X-HE-Tag: 1789688991-638575
X-HE-Meta: U2FsdGVkX1/wYWjtK0QwtV2Dpjw52n5uMhU+DvFScrbCW1kYWlVq1XsOfQMRAIj8cYv71U9Vk87pIXKe4s2bXnBR0+qpVwsK9ARVuT1hdx67Wjn8T+IK3z16FJuyWF4fK37i33HKQYWGmbZbjIk5s9yAJ75NTNbBLb2ZbEDeqXheONcD0DugBPz8COCvsl1RHjqs+CFDGlDKAo1g+hrI6ud3JP4uD1X4R3eFyr2U5OsT8k/vqr01B2RBUGV6PiGdwbL0eUyh9RkEKlGUU1jq3YZ7EzcMwlFcL8SojO6Sanys/wQBLB7f7ziorE7hHDpiKVG+6HkjNutdFoiIlxLDLXdpPBIePgX9qcsj3hwD5rz68XYkg4XZKgPnUoWp2pPMkl5ikYPVzeUDW3sSgG9vYWi3u9caO8gYkbcpT37cfuXpBNL66/4nZ+x+NTPzoWANA+Z4Rp69SH30QlFjbabNemKl1UEKFkiXUNq93FsBlRo+528F5lJoSFTTP4n1NIBTWRv9z1jW2LYaSD0SyOFjcQub/lDaH1B+CqR0jC5ZrW+Oicin9qZzZV1u7iRvRURuf4Bt1cDKpBC1TrRSbsezHOi2kp4uvA4n3x2ZA5CaAK7hBPVPWDIDqc6cfu4eDvEcb01i5SngRdqTa2X5Q+0OjbkeWEgxcOu1DJVEafvUSrXnBnazAsTVwUVhwAkIowqjesXMwJrR+SsXwXD1jTNNqiRYn2/poEf/Z9yxQ5y9D9sb5MohI8O3boJFrhNpNb2itmf9qrQpkVTykc+CmZBGCuKKXAIyES1lRaSogPF99P+yX8DNhBtPIh6M1znT6EwzTwK4kjMtWTZcDezeXOYPNoGbuFGHKgFfe8GmaKOtTLTg75ANujWR/chM2BYem2BY0opprOItTRCRHPK46T7piooJXE7OvElBIZ+1QfG0u1MSDGMicD19s4OJmn0TtJrVn2kuxQZHjqMfFTfhyk7
 Ajqmy1sB
 izkZSIMoC4S8hhrM4wgVkEYlimfw9e4Ax9sN9DAO7B9cxGobihLgIe5SpyHHmu16BT99koPA9Of/Acyi/4BuCjRmOXGTvITfW16F1b/y1W0Fl8OhsAfiXA3yUBr24kvr+iXzaT2bQfntnJzXdL6JsLSGWfQs0vfAOR44hx+SegAUjzXTGLIvN754fr1jsrmYwjkxq6FoLdH+ACIRbJdCFfatE6oL50xJehvU9qy0GH7jE4Os18NK6+fSdsB6HRn60XJa0CR+zQDxLmyzhklas7K0LXFviUVvT20mr/0abgGqKuz2+/WIP6YR2MS4LtDnj/qU7kX4eN9tX60TPly++vMMW1x1ScX96io8+zh1OFSfAzvbwC0HS0Binim6RZKclJJWxZxU6xrCo3IYuONgo6hJ1fYEZAm8U3tRd0OfA+hlTOmY0vXi0kwdkQRZlw4dGCXlATTzLVVqfrfSzhqorU5yjLiJAflBU786CW+KM+MP8eeM0658vfLVWEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============9216955143622942885==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index c3dce89ba5904..66695addbdf33 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1812,16 +1812,15 @@ static void init_cpu_info(struct cpuinfo_x86 *c)
>   * Do minimum CPU detection early.
>   * Fields really needed: vendor, cpuid_level, family, model, mask,
>   * cache alignment.
> - * The others are not touched to avoid unwanted side effects.
> + * The others are reset to their defaults here and only filled in later,
> + * by identify_cpu().
                         ^^

Does this comment match what the code does? The comment says fields
outside the "really needed" list are only reset here and filled in later
by identify_cpu(), but early_identify_cpu() itself fills in most of those
fields before it returns.

After init_cpu_info() resets the fields, early_identify_cpu() continues
to call:

  cpuid_scan_cpu(c);         /* re-populates c->cpuid */
  cpu_detect(c);             /* x86_clflush_size, x86_cache_alignment */
  get_cpu_cap(c);            /* x86_capability[], extended_cpuid_level */
  get_cpu_address_sizes(c);  /* x86_phys_bits, x86_virt_bits,
                                x86_cache_alignment */

Of the twelve fields init_cpu_info() resets, only three (x86_cache_size,
x86_model_id and, under CONFIG_X86_VMX_FEATURE_NAMES, vmx_capability) are
left for identify_cpu(); the capability array, the CPUID table,
extended_cpuid_level and the address sizes are all re-established in this
function.

The sentence also contradicts the line immediately above it, which already
lists "cache alignment" among the fields early detection does produce.

This matters more than a normal comment nit because the very next paragraph
is a WARNING about what may and may not be added to this function: a reader
who believes the non-essential fields are untouched until identify_cpu()
would draw the wrong conclusion about what state is valid at this point in
boot.

Could the comment say that the architectural defaults for the remaining
fields are established here, and that only the cache size, model string
(and VMX capabilities) are filled in later by identify_cpu()?

>   *
>   * WARNING: this function is only called on the boot CPU.  Don't add code
>   * here that is supposed to run on all CPUs.
>   */
>  static void __init early_identify_cpu(struct cpuinfo_x86 *c)
>  {
> -	memset(&c->x86_capability, 0, sizeof(c->x86_capability));
> -	memset(&c->cpuid, 0, sizeof(c->cpuid));
> -	c->extended_cpuid_level = 0;
> +	init_cpu_info(c);
>
>  	if (!cpuid_feature())
>  		identify_cpu_without_cpuid(c);


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35285131592
--===============9216955143622942885==--

