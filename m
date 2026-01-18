Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E479CD4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 06:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E539D6B0005; Sun, 18 Jan 2026 01:12:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7B56B0089; Sun, 18 Jan 2026 01:12:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE2F26B008A; Sun, 18 Jan 2026 01:12:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD1B76B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 01:12:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21813D1E6C
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 06:12:03 +0000 (UTC)
X-FDA: 84344064126.21.5269CE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8718B140002
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 06:12:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XX41RY4R;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768716721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sWl5QjqvWJPA+2RtM9E5Vgtjj6RUa3Da5X+vwMAaGdY=;
	b=oVWgzjT22V+W22I859ZWmxO2NYApAxg3tRlaEpRrq0Y1+B5RyRCmPAjAvfQ9PQrr+vT+RP
	KR1MQ3si+k1CEa5djSxztDDdmYsLBpyTmAt8Qcd8UejK7uakB8h9iUsY6x4OWLL7ZUL9eR
	SID6CflLOOeqRvTfaSLrNURvEs7hC+w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XX41RY4R;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768716721; a=rsa-sha256;
	cv=none;
	b=BBVLNrcMrgXfKPDvyaYxcXJx2XM2xRJyMJSfnN1bkM8Kh8x9T+WFLaQ9OpqilI2PReHWEJ
	akbn6wqKR0+xVJsRs8hGwALc52vE87+HzuHcODBJvvtvuJqBtwCUTN/ZjKauKVkbzjfXp5
	2pEJIRm7HOTqSJgiblqlyEXaGQk6IJA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 872356000A;
	Sun, 18 Jan 2026 06:12:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C92C116D0;
	Sun, 18 Jan 2026 06:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768716720;
	bh=XQZz9Nu+u7TdwrpS5yQTxTW/ej0dkCDpS+WPtv5Iudo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XX41RY4RMG0ZGtak6oOJ8ro7GjFQKoOTEGax7hbBjl5C/AdiAvlmAyQWb2RhVkmXL
	 whCApzlt6RghCmL2BW7E4KC8L2C+ANNlMiddN6jW+afgjxv2oQa6WQTZq9WpfJbiu/
	 SE1IVwdtIMLB4i9RnrD5nCTuUODRXiXw9C/2+s1+ty4rWJJExgOzZjkM3c1aFBRbkP
	 oXGmkvAqB/1+Eor9pzWjrBDHh1DbT1DVnxKgkRPyFqRyWrg8WxK2AIi1HN+CgU+LAt
	 vZWZ3NM7ey7xCLr6yTX7dOtSGIO/xW1VENnaUVRoDjmXacnBYfZjk5QLFeLFLtaaMJ
	 NvFQLWabs2iUw==
Date: Sun, 18 Jan 2026 08:11:52 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Breno Leitao <leitao@debian.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	akpm@linux-foundation.org, graf@amazon.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, ricardo.neri-calderon@linux.intel.com,
	kernel-team@meta.com
Subject: Re: [PATCH v4] kho: validate preserved memory map during population
Message-ID: <aWx5qHHYEXJXNuXm@kernel.org>
References: <20251223140140.2090337-1-pasha.tatashin@soleen.com>
 <jixxiqeajngwox3nh2u3pwf2rivhmqxxmpyttqxu32pixshyde@4jdn5jvg5hvk>
 <2vxzo6mt7cl3.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzo6mt7cl3.fsf@kernel.org>
X-Rspamd-Queue-Id: 8718B140002
X-Stat-Signature: e4zhcakumgwmcf1ry9ygiu1st3f9mww5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768716721-741907
X-HE-Meta: U2FsdGVkX19VJE4iB4fHAoQIqKCf7oqmUnBLtf3zcuTaBqcvC45OKJWjp4vzFxOpg+AMOBK9VQnMLH+LEBAj56IdRy0e1UrRw6eJJT223vWs3qnAoLx/aw/fUyQDM/xjq0BQvLEdl0FMeb/8mmcI/Z2Nn0Drr9ZEvfcEMaG/kzMYLOn/QI2Nxs+j2/i7HL4aQShwy/ACXaE/eafG7Uv/RkxwLfek+E6C53cU0js/ex4Ge0wdgPNtAOv7kQrfOS+TIoth0Jh2K7zT2h40ukB47Fl/gZnwSt+pcw3FzDPGbe4cXzD0TVx7gzpvJjES1mjZnPhhpU7Ng9mJJwWPDyfyPRWDP3kMrknyjNIkuyVYZLXYcj0IpROtGnuAi0FsokB6R8prIBVRmV/FnubQpznuGBKm15YZUyTotxB+JzE4JPr7mNNOPRfnWDk0QvTUX92z915mSD/KW69EYBVYir3nJGl475i9PCx3TbaCyI9LuLHBWb/BytHm1KOQtgtJWzlPHLPU29mp5FUUwbtbPZCHR0fyrxtSEf/YZ4g5IsH7jlsKY//UFxNg96a6wYhcz3cC0Dl6l9EuWX2RnyY7oojzGZRjrSs5VqQMqR7LDEcl9z9g8URvf1s/FtimMLwel9tvyKk8G1vMciEuhhj83fu45C+bOJlhCSRywo4P8YxpkeGZag/JKCzxc6kq3Gnt9NpFOV0liAWScFxsvoPDsWryZ/9roGmsC3hPhHtFqFIx1VpaaTS3ZgIhMk3UbRvkc7vZm0gcsZBtlZI9Fxd6/lI+ffKqsYHjiUrMMGKla8nx+wOgykVBivAgJFivOKEH2hKbkgkrA8Z7awWek/H5Rg8qbIaShZAfRNT+W9gBSymkR42awPEdyQbnhECiQs2gZP1zHFiTVcE8N0IdFWrowoYIG5rlDQ4RkbHRNS/UKoPEJ3ubQRnm8xV6/ihwJkG2Kny4oZS0st8KPbycUGdzF8a
 2rjs1KIe
 moTj1absb+yxyqGRswOyll9gANW+1rZjh0/T8t4BgfwXSshd/OouLDzF5X0/Bh7EC17dlgCAYkalIWyHcTYShAyDKn5OKeC3V2EDviE8mi0Dx3/Hr1jIgZxOddZi0UrtdjOHwKvFaCXUF+x5CLRXs8537VTT4NcDxE98mV5OXlvd5Fyn/LRbzVe6DF0+Jm8fZ5rbLDaLMkdWfSjILVJDvl745GzIoCbj4sAi3/nX01b7/2mnQ+Qq2Q/hzY8muE4iatDstu6VTXHgTSx9QNH+rvKlP9CQqAtegcwKYrWP2uA2htmA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 04:21:28PM +0000, Pratyush Yadav wrote:
> Hi Breno,
> 
> On Thu, Jan 08 2026, Breno Leitao wrote:
> 
> > Hello Pasha,
> >
> > On Tue, Dec 23, 2025 at 09:01:40AM -0500, Pasha Tatashin wrote:
> >> If the previous kernel enabled KHO but did not call kho_finalize()
> >> (e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
> >> the 'preserved-memory-map' property in the FDT remains empty/zero.
> >> 
> >> Previously, kho_populate() would succeed regardless of the memory map's
> >> state, reserving the incoming scratch regions in memblock. However,
> >> kho_memory_init() would later fail to deserialize the empty map. By that
> >> time, the scratch regions were already registered, leading to partial
> >> initialization and subsequent list corruption (freeing scratch area
> >> twice) during kho_init().
> >
> > While trying my new patchset [0] on top of this patch, I got the
> > following issue:
> >
> > 	[    0.000000] KHO: disabling KHO revival: -2
> >
> > Trying to solve it, I come up with a change in kho_get_mem_map_phys() to
> > distinguish no memory and error, see the patch attached later.
> >
> > This is what I used to test [0] on top of linux-next. Is this useful?
> >
> > Link: https://lore.kernel.org/all/20260108-kho-v3-1-b1d6b7a89342@debian.org/ [0]
> >
> > thanks
> > --breno
> >
> > commit 5d7855fede8110d74942e1b67056ba589a1cb54a
> > Author: Breno Leitao <leitao@debian.org>
> > Date:   Thu Jan 8 07:44:08 2026 -0800
> >
> >     kho: allow KHO to work when no memory is preserved
> >     
> >     Fix KHO initialization failing when no memory pages were preserved by
> >     the previous kernel.
> >     
> >     Commit eda79a683a0a ("kho: validate preserved memory map during
> >     population") introduced kho_get_mem_map_phys() which returns the physical
> >     address of the preserved memory map directly as its return value. The
> >     caller then validates it with:
> >     
> >         mem_map_phys = kho_get_mem_map_phys(fdt);
> >         if (!mem_map_phys) {
> >             err = -ENOENT;
> >             goto out;
> >         }
> >     
> >     This creates an ambiguity: physical address 0 is used both as an error
> >     indicator (property missing/malformed) and as a valid value (property
> >     exists with value 0, meaning no memory was preserved).
> >     
> >     "No memory preserved" is a legitimate state. KHO provides features beyond
> >     memory page preservation, such as previous kernel version tracking and
> >     kexec count tracking. When the previous kernel enables KHO but doesn't
> >     preserve any memory pages, it sets 'preserved-memory-map' to 0. This is
> >     semantically different from "KHO not initialized" - it means "KHO is
> >     active, there's just nothing in the memory map."
> 
> This isn't true. If you hand over _any_ state, you will at least need
> the KHO FDT. And the KHO FDT is preserved memory (see the
> kho_alloc_preserve() call in kho_init()). So I don't see how you can
> ever have valid KHO with no memory.
> 
> mem_map_phys _can_ be 0, but only when KHO was enabled but not used. And
> that is of course also a valid use case.
> 
> We want to treat mem_map_phys == 0 the same as the error path, just
> without the error print. This lets us discard all previous scratch areas
> since they don't have anything useful anyway, and have a fresh start.
> 
> So while you are seeing this error message, I don't think it should
> break anything and KHO should still be working fine. You can
> double-check this by inspecting /sys/kernel/debug/kho/out.
> 
> So I think the patch is certainly a useful fix, it just needs some
> re-wording and fixups.
> 
> Some comments on the code below.
> 
> >     
> >     Before eda79a683a0a, the code handled this gracefully in
> >     kho_mem_deserialize():
> >     
> >         chunk = mem ? phys_to_virt(mem) : NULL;
> >         if (!chunk)
> >             return false;  // No pages, but KHO could still work
> >     
> >     After eda79a683a0a, the early validation conflated "no property" with
> >     "property value is 0", causing KHO to be completely disabled in both
> >     cases.
> >     
> >     Fix this by changing kho_get_mem_map_phys() to return an error code and
> >     pass the physical address via pointer. This allows distinguishing between:
> >      - Property missing/malformed: return -ENOENT (KHO fails)
> >      - Property exists with value 0: return 0 (KHO succeeds, no memory to
> >        restore)
> >     
> >     Fixes: eda79a683a0a ("kho: validate preserved memory map during population")
> >     Signed-off-by: Breno Leitao <leitao@debian.org>
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> > index 271d90198a08..3cf2dc6840c9 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -471,8 +471,8 @@ static void __init deserialize_bitmap(unsigned int order,
> >  	}
> >  }
> >  
> > -/* Returns physical address of the preserved memory map from FDT */
> > -static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
> > +/* Returns 0 on success and stores physical address in *phys_out */
> > +static int __init kho_get_mem_map_phys(const void *fdt, phys_addr_t *phys_out)
> >  {
> >  	const void *mem_ptr;
> >  	int len;
> > @@ -480,10 +480,11 @@ static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
> >  	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
> >  	if (!mem_ptr || len != sizeof(u64)) {
> >  		pr_err("failed to get preserved memory bitmaps\n");
> > -		return 0;
> > +		return -ENOENT;
> >  	}
> >  
> > -	return get_unaligned((const u64 *)mem_ptr);
> > +	*phys_out = get_unaligned((const u64 *)mem_ptr);
> > +	return 0;
> >  }
> >  
> >  static void __init kho_mem_deserialize(struct khoser_mem_chunk *chunk)
> > @@ -1439,7 +1440,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
> >  			 phys_addr_t scratch_phys, u64 scratch_len)
> >  {
> >  	struct kho_scratch *scratch = NULL;
> > -	phys_addr_t mem_map_phys;
> > +	phys_addr_t mem_map_phys = 0;
> >  	void *fdt = NULL;
> >  	int err = 0;
> >  	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
> > @@ -1466,11 +1467,9 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
> >  		goto out;
> >  	}
> >  
> > -	mem_map_phys = kho_get_mem_map_phys(fdt);
> > -	if (!mem_map_phys) {
> > -		err = -ENOENT;
> > +	err = kho_get_mem_map_phys(fdt, &mem_map_phys);
> > +	if (err)
> 
> This will break when mem_map_phys == 0. As I explained earlier, when
> that happens we want to discard all previous scratch info and start with
> a clean slate.
> 
> Making this if (err || !mem_map_phys) should do the trick. The if (err)
> check before the print should make sure the error message is not printed
> when we have a valid property but its value is 0.

While we are on it, I'd suggest to change kho_populate() error handling to
use goto, (i.e like below)
Then a simple if (err) will do and that's much clearer.

Another thing I noticed it that assigning err to -EFAULT or -EINVAL after
printks is completely redundant, since we anyway report what went wrong, so
printing the error value in the end just not needed.

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index feffeafa51b7..2bba111149c4 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1453,27 +1453,27 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	if (!fdt) {
 		pr_warn("setup: failed to memremap FDT (0x%llx)\n", fdt_phys);
 		err = -EFAULT;
-		goto out;
+		goto err_report;
 	}
 	err = fdt_check_header(fdt);
 	if (err) {
 		pr_warn("setup: handover FDT (0x%llx) is invalid: %d\n",
 			fdt_phys, err);
 		err = -EINVAL;
-		goto out;
+		goto err_unmap_fdt;
 	}
 	err = fdt_node_check_compatible(fdt, 0, KHO_FDT_COMPATIBLE);
 	if (err) {
 		pr_warn("setup: handover FDT (0x%llx) is incompatible with '%s': %d\n",
 			fdt_phys, KHO_FDT_COMPATIBLE, err);
 		err = -EINVAL;
-		goto out;
+		goto err_unmap_fdt;
 	}
 
 	mem_map_phys = kho_get_mem_map_phys(fdt);
 	if (!mem_map_phys) {
 		err = -ENOENT;
-		goto out;
+		goto err_unmap_fdt;
 	}
 
 	scratch = early_memremap(scratch_phys, scratch_len);
@@ -1481,7 +1481,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
 			scratch_phys, scratch_len);
 		err = -EFAULT;
-		goto out;
+		goto err_unmap_scratch;
 	}
 
 	/*
@@ -1498,7 +1498,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		if (WARN_ON(err)) {
 			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
-			goto out;
+			goto err_unmap_scratch;
 		}
 		pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &size);
 	}
@@ -1520,13 +1520,14 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	kho_scratch_cnt = scratch_cnt;
 	pr_info("found kexec handover data.\n");
 
-out:
-	if (fdt)
-		early_memunmap(fdt, fdt_len);
-	if (scratch)
-		early_memunmap(scratch, scratch_len);
-	if (err)
-		pr_warn("disabling KHO revival: %d\n", err);
+	return;
+
+err_unmap_scratch:
+	early_memunmap(scratch, scratch_len);
+err_unmap_fdt:
+	early_memunmap(fdt, fdt_len);
+err_report:
+	pr_warn("disabling KHO revival: %d\n", err);
 }
 
 /* Helper functions for kexec_file_load */
 
> >  		goto out;
> > -	}
> >  
> >  	scratch = early_memremap(scratch_phys, scratch_len);
> >  	if (!scratch) {
> 
> -- 
> Regards,
> Pratyush Yadav

-- 
Sincerely yours,
Mike.

