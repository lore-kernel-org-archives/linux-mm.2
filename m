Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECC2DCF2561
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 22:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106496B002D; Tue, 18 Nov 2025 17:44:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7956B0089; Tue, 18 Nov 2025 17:44:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8A76B008C; Tue, 18 Nov 2025 17:44:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9F056B002D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:44:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 413FC1A0215
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 22:44:58 +0000 (UTC)
X-FDA: 84125209476.29.D79F354
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7D405160009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 22:44:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JLTGDx4j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763505896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHC+YY7yp72sM6fpU4gihGsF2YhBrsRzUBisprz+Z0o=;
	b=APWmir3eSppVWfWX3Hd1FTjX/4vk7yXaIQEyRSqv7t/hQ2mB7Uiyjbx+2rlZJQTT6orLDX
	eM/9aDPSISwffqona30iIl9sKbOkAd7Udcr4fcHk3sGH8OPeHcYVyNDWPGow/YKKMSrCoD
	tigvGVgoGonPBXBRC1Go3zoPtbAjJJU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763505896; a=rsa-sha256;
	cv=none;
	b=CL1enM5De7xq35EIuI+jZPjzq6KNvTsOS7a8pJ2yjhk9I2Rw61NklVP8UT2fEp3lPxmZXU
	GDaTUd8Xs04ScRDwWJJEwied4iJgvgZqnv/K/pg2ITrT8+ZxDy9mQ5/aSy8/OVLyI8TYAO
	ulYCOdeCNplBKkAGFxoPXARHZjuez0c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JLTGDx4j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of nathan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=nathan@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FCC741B5F;
	Tue, 18 Nov 2025 22:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3A7C2BCAF;
	Tue, 18 Nov 2025 22:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763505894;
	bh=KvM4sw5d11P00xzno+X5e9UaJIpcGEJfE9v6laupK1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JLTGDx4jkYO6rCsLPTkfwcGiYcDeLR7/nVDsghDGniU+c6haoY7REaiN1wy3sBlq9
	 S1Nx/SQUNHYJzFYW4DRllsixtoyyp/z5EwPSAfaxytqjmLjM5Dyz9qZOt9GuNlhP9S
	 CEDQmNM5EHH2448doM3f0Cx8X+uz/iUSnP+Ojva/p3O6299cR8zioP7BcoYWpmAUo2
	 8TrFbVfbFfqiy5367kLCW+wwOTigWd0zQxJceJ5lXZ+N1IwOPma7GgW0fQskrRVRo2
	 PPso+aj/XoqEE0emE98JGMwkcULoKFxl0uhcw0ahNwqCoY4uoeT7hW5MCZUSasVRxk
	 Uc9tZlxit/BCg==
Date: Tue, 18 Nov 2025 15:44:48 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
Message-ID: <20251118224448.GA998046@ax162>
References: <20251117173530.43293-1-vishal.moola@gmail.com>
 <20251117173530.43293-2-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117173530.43293-2-vishal.moola@gmail.com>
X-Stat-Signature: fmh1d33wqr7617pqmitunj9dmeax4mmb
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D405160009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763505896-393543
X-HE-Meta: U2FsdGVkX18rB+K+aFAF2bdlJEsnpTzS7zr929El462245in4T1yBxo+Cs0GiNC/Pds71i5kDieZntOzO+FY5UFGTWtAov+jbOruczMkyKK+AC4H95k6lWAr53/8K0fJrwZjqZvfCNKdHH3dMR/oWroIFbYbtDhetlyKyetG6+IPgeC6DvClbKcZwsMpHt4V/C8tJf6cGRXZD4B/Hhg747VFmCTzRnSfeED5GD8lFZu8j4G2VFTOz9FB/5dch7kEasiRgKeoZ9uNIWjdD7Ohai0M0HIckYcAlpG54V0nayvHP7GvwhQRs/d233FugjwWNSMev/vRdbhOB/5cl2+OpK89wWDyiqa0rr/RNfRZV5/mbmVVLEZ++CWQM4Z/rgQ4stNJ+ZU0kA76XLYG5UlgNpWbJvjYSAYG7fjeHnKX+eiVHUU8R2xS8wH4v1yUVtxHePuXvyJ3UmtuPTtHSJAXSBoxNNXmR9Hb5V3u1VjbJxXxqUqAhSd4rhFWVR3PJJ7EqoxTxPtWVKETRUL1QfNTurnsvzqx8NPzryW1/bZyQnJn6RvvtKVES9cSINl0lO20ra5kFqPf6z/wyGMStYYAG/70wsP02KD1j7GlR121Cd/HjhG8YiON2g/AHW4pMTQeDcbFiPBCZESf7RWyIwlbyYVl5cnp9QVHjy2LJVhMRN/Vic9t7j+WG2NtEuiIRBHbgp3CPEX4uWypSrRwqq0xPFh3vBbBofe3SHCr/AOaL+O6wB1/t+QzyNsDbyTlg7v2Gx7nRqDwcWWCJ1p44zNbiIAg9SsH7JxoKK4AddJlGc/9MpxrOCccj5dwg5Kv7asvIWidRjvlsjkAKYFwGBUOYCXW5EEO0AtxUwV8llqIcBtPZMMZUUVVXdJHrD1JXIbIU0cAM68knJ6Rsx1fL/RrA0TMBL9gyxIN6oTy4knPCW51+6mCgV/f/uMI1d1BczoWK1hJoxjOPR1sYXjsns7
 h26p+PfZ
 A04tJqW8IV42RUiyFPNqXYoXGRdH4BI5Y3k8do9UtZMBat+FH9KditkEZsCvVOY0ZKcmdCzsmHJgReC+RDBPrtmJO4hCJa194Yn8r7H/jekrOzcArHEBlJM4jFhtWjM61eWx0b0jJwcDr9AXPJ33LBjPZP00AlvUbtYkWJB1kyfs15YsMVakFy79s+77AeAKvPC4b17wTKvNo90WiCwbzdX58/F+okx7KMdlOuhtsH7/TuJqtjw1rsvdP8IA1LQIBOO/23CZy1SOcIcrlBD7dM+KTSPlvg4W1SNp3ulVf/zTzT7jg+y/fxGexYpv9GoOcplco8Hn+oqVsBOhlQGcacspIdpIy9vq9REFIhmbF0TuRkCqi31d+FCPGF9Ew834N1VIeISzR6kstwCr3+NDOqYeA4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Vishal,

On Mon, Nov 17, 2025 at 09:35:27AM -0800, Vishal Moola (Oracle) wrote:
> Vmalloc explicitly supports a list of flags, but we never enforce them.
> vmalloc has been trying to handle unsupported flags by clearing and
> setting flags wherever necessary. This is messy and makes the code
> harder to understand, when we could simply check for a supported input
> immediately instead.
> 
> Define a helper mask and function telling callers they have passed in
> invalid flags, and clear those unsupported vmalloc flags.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/vmalloc.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0832f944544c..5dc467c6cab4 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3911,6 +3911,28 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  	return NULL;
>  }
>  
> +/*
> + * See __vmalloc_node_range() for a clear list of supported vmalloc flags.
> + * This gfp lists all flags currently passed through vmalloc. Currently,
> + * __GFP_ZERO is used by BPF and __GFP_NORETRY is used by percpu. Both drm
> + * and BPF also use GFP_USER. Additionally, various users pass
> + * GFP_KERNEL_ACCOUNT.
> + */
> +#define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> +				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> +				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> +				GFP_USER)
> +
> +static gfp_t vmalloc_fix_flags(gfp_t flags)
> +{
> +	gfp_t invalid_mask = flags & ~GFP_VMALLOC_SUPPORTED;
> +
> +	flags &= GFP_VMALLOC_SUPPORTED;
> +	WARN(1, "Unexpected gfp: %#x (%pGg). Fixing up to gfp: %#x (%pGg). Fix your code!\n",
> +			invalid_mask, &invalid_mask, flags, &flags);
> +	return flags;
> +}

I am seeing this warning trigger when starting a VM on one of my arm64
boxes.

  [ 6345.145795] ------------[ cut here ]------------
  [ 6345.145803] Unexpected gfp: 0x2 (__GFP_HIGHMEM). Fixing up to gfp: 0x400dc0 (GFP_KERNEL_ACCOUNT|__GFP_ZERO). Fix your code!
  [ 6345.145819] WARNING: mm/vmalloc.c:3940 at vmalloc_fix_flags+0x60/0x90, CPU#32: qemu-system-aar/4325
  [ 6345.176990] Modules linked in: ...
  [ 6345.254421] CPU: 32 UID: 1000 PID: 4325 Comm: qemu-system-aar Not tainted 6.18.0-rc6-next-20251118-00002-g2331e73a4769 #1 PREEMPT(voluntary)
  [ 6345.267101] Hardware name: To be filled by O.E.M Ampere Altra Developer Platform/Ampere Altra Developer Platform, BIOS TianoCore 2.10.100.02 (SYS: 2.10.20
  [ 6345.280907] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  [ 6345.287856] pc : vmalloc_fix_flags+0x60/0x90
  [ 6345.292115] lr : vmalloc_fix_flags+0x58/0x90
  [ 6345.296374] sp : ffff80008d5b3a10
  [ 6345.299676] x29: ffff80008d5b3a20 x28: ffff07ff8a148000 x27: 0000000000000000
  [ 6345.306800] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
  [ 6345.313923] x23: 000000000000000b x22: 000000000000ae01 x21: 0000000000000028
  [ 6345.321047] x20: ffffc682ea643fbc x19: 0000000000001040 x18: ffff800083465050
  [ 6345.328170] x17: 00000000d949c370 x16: 00000000d949c370 x15: 0000000000000004
  [ 6345.335294] x14: 0000000000000002 x13: 0000000000000002 x12: 0000000000000000
  [ 6345.342417] x11: 0000000000000001 x10: ffffc682ec577744 x9 : bf6a46a6bf3b7900
  [ 6345.349541] x8 : bf6a46a6bf3b7900 x7 : 65646f632072756f x6 : 7920786946202e29
  [ 6345.356664] x5 : ffff081f6fcdc678 x4 : 0000000000000000 x3 : ffff80008d5b3688
  [ 6345.363788] x2 : 0000000000000021 x1 : 0000000000000000 x0 : 000000000000006f
  [ 6345.370911] Call trace:
  [ 6345.373346]  vmalloc_fix_flags+0x60/0x90 (P)
  [ 6345.377606]  __vmalloc_noprof+0xa0/0xb0
  [ 6345.381431]  kvm_arch_alloc_vm+0x64/0x70
  [ 6345.385344]  kvm_dev_ioctl+0x9c/0x58c
  [ 6345.388997]  __arm64_sys_ioctl+0xb0/0x100
  [ 6345.392995]  invoke_syscall+0x84/0xf4
  [ 6345.396648]  el0_svc_common.llvm.4390888008543260363+0x90/0xf4
  [ 6345.402469]  do_el0_svc+0x2c/0x3c
  [ 6345.405773]  el0_svc+0x54/0x2a8
  [ 6345.408905]  el0t_64_sync_handler+0x88/0x134
  [ 6345.413164]  el0t_64_sync+0x1b8/0x1bc
  [ 6345.416815] ---[ end trace 0000000000000000 ]---

where kvm_arch_alloc_vm() from arch/arm64/kvm/arm.c is

  struct kvm *kvm_arch_alloc_vm(void)
  {
      size_t sz = sizeof(struct kvm);

      if (!has_vhe())
          return kzalloc(sz, GFP_KERNEL_ACCOUNT);

      return __vmalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_HIGHMEM | __GFP_ZERO);
  }

Should __GFP_HIGHMEM be dropped from the call to __vmalloc? It looks
like it was added by commit 115bae923ac8 ("KVM: arm64: Add memcg
accounting to KVM allocations") back in 5.16.

Cheers,
Nathan

