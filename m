Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7393F606A31A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 03:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mhgKRNXi
Received: by kanga.kvack.org (Postfix)
	id 3707E6B05B2; Sat,  7 Nov 2026 22:07:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321186B05B3; Sat,  7 Nov 2026 22:07:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216B26B05B4; Sat,  7 Nov 2026 22:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0F3F6B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:07:48 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4DF3340142
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:07:48 +0000 (UTC)
X-FDA: 85410467016.13.93BC097
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id AA046140003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 03:07:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhgKRNXi;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794107266;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsA+XNV3UQmLWrXrSm6XA6b7HU+WRkrFAf7QBdme5jA=;
	b=LB/sVRB85tfmuttVcUpEWN86B1Fy9AC1I6ADgZ6XlP8vC/ulvobJGSisVYA8R5B6IhILsb
	0fH7jOKv33mTzkOG1KW21XtdKcuYsDP4vW7e0MidHVC0OUfX/94sYFo3Ty6Ma8vLipxmxV
	o79Xqe277BksXHDYnkjiOvqCAzxj0To=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794107266;
	b=xHi19gZGZLMas4mN7o+vIYd+0dy32Gcdzc5d6nftoFb4gOAKhFT7Maiic3n3zy/k30YsHs
	Ba8SsVVYVbuW2SvIssxQ9bn5d01hIT0VvbBu55Aga3crWW2fmKW/UxXvqew5gMKe5OClsL
	Y7MNrFXI+AYqxCYhmpsabl4EPFW4tqM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhgKRNXi;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FCA760A52;
	Sun,  8 Nov 2026 03:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5286D1F0089F;
	Sun,  8 Nov 2026 03:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794107265;
	bh=hsA+XNV3UQmLWrXrSm6XA6b7HU+WRkrFAf7QBdme5jA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mhgKRNXihg1J1gwUC9/qkpc5fuETt/EDQ8wC1O3ljReKE3XcM2ZVqnKx8+RqYhKDj
	 nR7RFsrfdW5Ke7UXbDgh5i3T1jBduvdQXot2NmsHsPfaS9jSfHqCCglG6DapQR8Y/Z
	 DhKVxehNZQjzOyAr7+NeRUv0U9noS/m0Bpx/1vn+h0SMt+Dq7aB3pcP0xsiMVDOhTR
	 rYnGbw7hVBpX9lbcK8yXRrv8YV3mcSs8r8xH/5FAkC83VBPW0NhQKLgZ4N9qsWM42D
	 FuBH8IeuHQiTUgV22u9C+L8cU6k1OMngEPlSB+UJej4NhJicRxvBElThj7345uzH51
	 9qiDr+FeWt+xw==
Message-ID: <sashiko-outbox-203536@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: mm/mremap: F_SEAL_FUTURE_WRITE can be bypassed via mremap() VMA
 expansion/duplication
Reply-To: sashiko-reviews@lists.linux.dev
To: "Junyoung Jang" <graypanda.inzag@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Liam
 R . Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Hugh
 Dickins" <hughd@google.com>, "David Hildenbrand" <david@kernel.org>
Cc: "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, "Pedro
 Falcato" <pfalcato@suse.de>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org
In-Reply-To: <20261107030708.1031977-1-graypanda.inzag@gmail.com>
References: <20261107030708.1031977-1-graypanda.inzag@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 03:07:44 +0000
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 3irrq6i5m6th55totzykgdw5oy6qyc63
X-Rspamd-Queue-Id: AA046140003
X-Rspam-User: 
X-HE-Tag: 1794107266-167613
X-HE-Meta: U2FsdGVkX1+7xRqHwQVkWhS/hVI4I8LCzliKFA9ICQgm3rJo6HqNmuud2mRdc4fxh8zatk4mEFkx2g+HbY/FiitsOK4BjulEIwahqJs+JGVAQe/RhL5qG8wmKxA1QjzEurXUQuWnp+aRykkNkqB5lBGWXH/Z7nqMVOSPeqNEJCsyTfSQd9YnAEs7hMdzRsmAV1xYs9kx6R7kOQH9Pu/UBMohDH+rgm1HYSQtZWfPZ1PtDKpjL9upvxBDTnURBoCAoOD1T2SJ4iTk2T6eRcJ8EOOC//nAGUdYSEsuLKXY7FSB0a8h2VTe0hlZowyPgjcbySWZzNCtkALIBSFrea8MQRl4EL6XJxO9RWdbXLqJLC5Ls8kIHrbMIkxqFjduGArDdQWy8obvfO1hTW1k0lwgKwTzS/Cfa5aLOQhtXyAUSncqKbzX5+T/N4TVzPTw7t09QFTgfxmp115OfpuNM9HUwOB2jE97R94h9pJ0olcs0uy1NOOIPSR5W2lU/dOJabI5JrKkUWuYpVHYs30Xl7veSLfzkgZRr9OmeG21ERCilRb9bfMllYf/3jCHnZoFHLCWBx/5b/57lqZURfe8BE2F/WobSxyFe/FvncIGIGe77eRXylEF2mGMSY0+ogJuv2cFZWe/mTcDARnJLLX9mOd6Zma36KHnKcWcpuNGKOu87JmemtBngzYYAuboPoFoNQ2sCOObJmaqdH8/vDnXz+Ai3BXtf9JEwj93yH+xikxqum0rIvA9GD+jCGj/Jq0QyP1NqMY2IizIvQlnoXhoquBmK6GzFIGu6AqAdh7ITEyYyPOenuEhQstmlygVQpLWDwKqNbGMaUd8HyHfkMgz+dzwvwT9P6Pq/5Fyi3JKQLzSgs9WVlBY/ICXd1q6VQpEPnDK16TMgBO36l6FgS3pj1nYfpOV3BPocdSo0V13wVxzR84uQr1jatvI3sZsvTNtvvShhQszKUqogQnSYL3QMj5
 TpFqMXYT
 gjUueKePgdLVfoCH465Nn+uwPfcUQ6LudQWmnFSTl0V3VzJIjUfstmSpTI44gma/7kGZ/BRoOQFoAf5cDocysZcHeJVrUEUFPm3Y6PaKxdgkFeM8NYqqfV/nNbSD17lLXpH0+jZuGri3kLPIWdP8kuM8l3iY6Amm4AZ6jvi2oYKdlT9LzCo5Szgp9MSAOqs1KTr5bsUytTEkIoJdmbxD4zCDpIDfh+JK3yaEPfabiVJ4J8tFgCD9tFscdWa+sm5GZHkqG7goDjfwGOluXAQ1hcKjqTEfid2lMiQQ0cyA9PclU9IWX+8DXok0vbRSgYYSl5mcXuVNw9+eSlhIdXeXs1qZilNlMFE8EoPVaro8Zz6ofDRehTNBNGVF3WtAzB2NYQ7Kin0EJG5WbSzPvR/m7PDDBNUTPOYabkZbLpseaweX9Lhxzgd6Tb7HXzae/sFkFpZoRv4DDT17FLqs63nr7N7MR7JA4NV+1eaYU1LEJduwta91xhi5owqaMwB4LRPmMZHAbRi+nK9jelR2Xbi4xyRdP84r+L6EWluFGRldQiU4gdTTxfSQ8RkR+a+1nFD0XvzHb7LiMH6ZxeXcbGYTN9FvWGgpk/IGEVnZ6ysOPTzMdnj+e+EXSDk6BdiTAY7k7EA4BDDpJep2qtSGAwVX3d9l8n+jbODicLak9BtFwYCJBQq6R0rcFsJSbsk16/P8VSTQ5sBUNl1aQVSI59c7m9Qzu+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Low] mm/mremap: check_prep_vma() checks memfd seals before VMA bounds
- [Low] mm/mremap: check_prep_vma() open-codes vma_is_shared_maywrite()
- [Low] mm/mremap: commit message is a raw bug report and lacks trailers
--

commit cc4a27e7580c449c0e2b8a3507c3d641a688a645
Author: Junyoung Jang <graypanda.inzag@gmail.com>

> mm/mremap: F_SEAL_FUTURE_WRITE can be bypassed via mremap() VMA expansion=
/duplication
>
> Hello,
>
> I found a reproducible F_SEAL_FUTURE_WRITE seal-policy bypass. A process
> holding a one-page shared writable memfd mapping created before the seal =
can
> use mremap() after the seal to gain writable access to additional file pa=
ges.
>
> In the accompanying two-UID reproducer, the second page belongs to a memfd
> created by a different unprivileged user. While a new writable mmap() and
> pwrite() to that second page both fail with -EPERM, the mremap() path
> succeeds and modifies the page's contents.
>
> Affected tree tested:
>
> - Linux 7.4.0-rc1-gd48723711bae, built directly from upstream commit
>   d48723711bae9b8cdc56719c448ba42fef28cbee using x86_64_defconfig.
> - A second image built from the same commit with the proposed mm/mremap.c
>   diff, reported by uname as 7.4.0-rc1-gd48723711bae-dirty.
> - Each before/after pair was booted in QEMU with the same statically
>   linked C PoC.
>
> Root cause:
>
> The missing seal check is in mm/mremap.c:check_prep_vma() (lines 1808-1872
> of the tested commit). mmap() calls memfd_check_seals_mmap() at
> mm/mmap.c:499; for F_SEAL_FUTURE_WRITE, mm/memfd.c:384-385 rejects a
> new shared writable mapping with EPERM. check_prep_vma() has no equivalent
> check before it permits a larger mapping.
>
> For the PoC's old_len=3D0 call, this condition at mm/mremap.c:1819 only
> rejects duplication of a non-shared VMA:
>
>     if (!old_len && !vma_test_any(vma, VMA_SHARED_BIT, VMA_MAYSHARE_BIT))=
 {
>
> It is false for the PoC's MAP_SHARED VMA. check_prep_vma() then checks
> VMA bounds and expansion limits and returns 0 at mm/mremap.c:1872 without
> checking vma->vm_file for write seals. For this zero-length call,
> expand_vma() moves the VMA and reaches copy_vma_and_data(), which calls
> copy_vma() with the larger new_len (mm/mremap.c:1293-1295):
>
>     new_vma =3D copy_vma(&vma, vrm->new_addr, vrm->new_len, new_pgoff,
>                        new_anon_pgoff, &pmc.need_rmap_locks,
>                        vrm->flags & MREMAP_DONTUNMAP);
>
> copy_vma() can duplicate the original VMA and extend its range
> (mm/vma.c:2052-2055), retaining VM_WRITE and VM_MAYWRITE. The newly
> covered second memfd page is writable despite F_SEAL_FUTURE_WRITE.
> Ordinary expansion with old_len=3Done page also succeeded on the unpatched
> kernel. A read-only shared mapping with VM_MAYWRITE can likewise be
> expanded and then changed to PROT_WRITE with mprotect().
>
> Impact:
>
> This allows a process to write to file pages outside its pre-seal mapping
> across a UID boundary, affecting scenarios where a memfd owner grants
> limited writable access to a specific range before sealing and relies on
> F_SEAL_FUTURE_WRITE to prevent future writable mappings of other pages.
>
> Reproducer summary:
>
> 1. Start as root only to set up two distinct unprivileged UIDs (10002 for
>    the owner, 10001 for the writer); both drop all capabilities.
> 2. UID 10002 creates a two-page memfd and initializes page two to 'A'.
> 3. UID 10002 passes the fd to UID 10001 via SCM_RIGHTS.
> 4. UID 10001 maps only page one with MAP_SHARED and PROT_WRITE.
> 5. UID 10002 adds F_SEAL_FUTURE_WRITE.
> 6. UID 10001 confirms a fresh writable mmap() of page two and pwrite() to=
 it
>    both fail with -EPERM.
> 7. UID 10001 calls mremap(old_addr, 0, 2 * page_size, MREMAP_MAYMOVE),
>    writes 'Z' through the expanded mapping, and UID 10002 reads 'Z' back
>    from the second file page.
>
> Build and run:
>   $ cc -O0 -g -Wall -Wextra -Werror -static memfd_future_write_mremap_poc=
.c -o poc
>   $ sudo ./poc
>   writer uid=3D10001; mmap=3DEPERM; pwrite=3DEPERM; mremap write=3DZ; res=
ult=3D63
>   owner uid=3D10002; file page 2=3DZ; size=3D8192; result=3D255
>
> Suggested fix direction:
>
> I believe mremap() needs to check the memfd write seal before duplicating
> (old_len=3D0) or expanding (new_len > old_len) a shared VMA that has
> VM_MAYWRITE.
>
> I tested the rough diff below in check_prep_vma() on the same commit and
> confirmed that it blocks the reproducer (mremap fails with -EPERM). Howev=
er,
> I am sending this as a bug report rather than a formal [PATCH] because I =
am
> unsure about potential side effects:
>
> 1. Because a PROT_READ shared mapping with VM_MAYWRITE could be expanded =
and
>    later made writable via mprotect(), the diff temporarily sets VMA_WRIT=
E_BIT
>    on a local flags copy to force memfd_check_seals_mmap() to return -EPE=
RM.
>    However, this rejects legitimate read-only mremap() expansions outrigh=
t,
>    whereas mmap() would normally allow a read-only mapping and simply cle=
ar
>    VM_MAYWRITE.
> 2. I am not certain whether check_prep_vma() is the right place regarding
>    locking/synchronization against a concurrent F_ADD_SEALS call.
>
> I would appreciate your guidance on the proper way to handle this, or feel
> free to take it from here:

[Severity: Low]
The commit message is formatted as a conversational bug report rather than
a kernel changelog and is missing a Signed-off-by: trailer.  It should also
include:

  Fixes: ab3948f58ff8 ("mm/memfd: add an F_SEAL_FUTURE_WRITE seal to memfd")

> diff --git a/mm/mremap.c b/mm/mremap.c
> index 19398d5fca585..cc24716120d20 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
[ ... ]
> @@ -1829,6 +1830,17 @@ static int check_prep_vma(struct vma_remap_struct =
*vrm)
> =20
>  	old_len =3D vrm->old_len;
>  	new_len =3D vrm->new_len;
> +	if (new_len > old_len && vma->vm_file &&
> +	    vma_test_all(vma, VMA_SHARED_BIT, VMA_MAYWRITE_BIT)) {
> +		vma_flags_t flags =3D vma->flags;
> +		int err;
> +
> +		/* A larger VMA could become writable via mprotect(). */
> +		vma_flags_set(&flags, VMA_WRITE_BIT);
> +		err =3D memfd_check_seals_mmap(vma->vm_file, &flags);
> +		if (err)
> +			return err;
> +	}

[Severity: Low]
Should this check be placed in the expansion section of check_prep_vma()
after the VMA bounds check?

Running it here causes mremap() with an out-of-bounds old_len
(old_len > vma->vm_end - addr) and new_len > old_len on a write-sealed
shared memfd mapping to return -EPERM instead of -EFAULT.  Moving it past
the old_len =3D=3D new_len early return also avoids duplicating the
new_len > old_len check.

[Severity: Low]
This isn't a bug, but vma_test_all(vma, VMA_SHARED_BIT, VMA_MAYWRITE_BIT)
open-codes the existing vma_is_shared_maywrite(vma) helper.  In addition,
memfd_check_seals_mmap() is meant to mutate a new VMA's flags during
mmap(), so copying vma->flags and setting a dummy VMA_WRITE_BIT just to
trigger its -EPERM branch is awkward compared to a dedicated memfd helper.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107030708.1031=
977-1-graypanda.inzag@gmail.com?part=3D1

