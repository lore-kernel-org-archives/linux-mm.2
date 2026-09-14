Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6452CC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 23:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207916B0088; Mon, 14 Sep 2026 19:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA0D6B008C; Mon, 14 Sep 2026 19:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A94B6B0092; Mon, 14 Sep 2026 19:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D0FC26B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:35:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B467E1A0280
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:35:24 +0000 (UTC)
X-FDA: 85213976568.24.ED1DB97
Received: from sender5-op-o11.zoho.com (sender5-op-o11.zoho.com [165.173.182.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id 95D9440002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:35:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=OoTfsuDy;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf17.hostedemail.com: domain of deborah.brouwer@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789428922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1+bLayvqBv4MV0slcJVabg6OUZ/SWSBRrrghbeWpKs=;
	b=8AoIYL+Z4WtIDd7zV8fQPdJXfOO/ildg6anEf5ZKTDZbWv1Sqmdfpwwor1Mw+k9koMwgrw
	Xd8hqonS8vJe1RzZTozDyzG97e6xKtUtmmiRE1+4Z66NlxzKOn5KWR7E2cOoeSQTDQk6PQ
	U738+LU/CoUXY5wOaAhYXW+Bk2hezLQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789428922;
	b=Mzw2qCE5SM9W7e1OyY4YIN3Zd5BTm+fmvhWyWCie12St1L1Ft7Nk2InOG1utoGCxF58IUB
	L184vyzvY923+me5clF+4NQVpyOyt5Ks4VNLZfT28Z+z7TyNanoMxYY6Vno4lZ2xi9DPxc
	wupvPUBXOrSjL37mZTzp6DgOlZDzr+Y=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=OoTfsuDy;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf17.hostedemail.com: domain of deborah.brouwer@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1789428910; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=LSHS6BC3dWP6eznSoy8j1egaGsjlnPjSD1CJWZPB1QTh5jo8u4sbqEAJHkWlVwcgcED4VIyaSv9+45ierbl/unAW41XYCTLl1IOsljqozUJ2sr4Gh94Pcb8T6MDKmKLsGcx7+HPLEVAYlN+xQOndiKvToWguhQ3B5IyOYte668E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1789428910; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=y1+bLayvqBv4MV0slcJVabg6OUZ/SWSBRrrghbeWpKs=; 
	b=AKAehefUruhp86yYje3KCs5BomHQQV1+06HOzveEtvLRv8LG902jy+qTWBeHuwzPhM6qHgPDGx4C4ppOdLf4wKs723Mnem+wq8Z9aj5dxkOiDYq/y68witiyEOZaGjCBecDkre/Ol3Z4mpbl2vEmjaJYE0TWQvA8VOH/fkshzNk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1789428910;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=y1+bLayvqBv4MV0slcJVabg6OUZ/SWSBRrrghbeWpKs=;
	b=OoTfsuDyiU/DVuXFCmHz9FBK+XcPRr4Rosl/MjgpL9zhdGyy7I+UrOGVY/bQ/GG1
	r4lsUOpP/39wqktSwm82B/ZmH6p2KCsPCnIt4fee/O+cPeAhS3wuJ+15q2c9xPyRvus
	rcCVmAeI6ytYJ2wNJQq/gPQRfu9hU8nECKoTrltE=
Received: by mx.zohomail.com with SMTPS id 1789428909278665.3306979354372;
	Mon, 14 Sep 2026 16:35:09 -0700 (PDT)
Date: Mon, 14 Sep 2026 16:35:07 -0700
From: Deborah Brouwer <deborah.brouwer@collabora.com>
To: Ke Sun <sunke@kylinos.cn>
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org,
	Alvin Sun <alvin.sun@linux.dev>
Subject: Re: [PATCH v2 4/9] drm/tyr: add per-file VM pool
Message-ID: <aqiEqzhZy6_AwSvS@um790>
References: <20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn>
 <20260908-tyr-ioctls-v2-4-88bea777df67@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908-tyr-ioctls-v2-4-88bea777df67@kylinos.cn>
X-Zoho-Virus-Status: 1
X-Zoho-AV-Stamp: zmail-av-0.2.13.1.5.4/289.404.0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 95D9440002
X-Stat-Signature: kyoddkfig98otig6n9stussbub7rzwh9
X-HE-Tag: 1789428922-781632
X-HE-Meta: U2FsdGVkX1/v4ULcyCzSOgieh3B4wE3r/QxMxZKGdbimNG3RhsYtxnjv/nITY9KsIkgnzg1CQnPLpWI0GFP5XYP8HWHJBeJlDxuIx1c4jKsuWLfwuO3Xpfv/6SjzJf1HH/8z/XcFOXbrltqIY5bIoar/K+q2JNtZrYUy6l2H78yI5y/e/DWRI8IyewlCk7XrmhhBATYbT3zAgPG2uijpX3IuPPuHurPS4wKuEvGS5FrWWy9qDZoQcwKzPQk67Tlw8d18wogO1XeROyyGl6SiwfgmUmLTYYPeJEeWMqItW1UI7MNA6alqCPbWP4y6Z4T4By0wx8v8tvC92x23Kfku4ZUngyk2yF953+2Q4VIxG6u/JPNAiodnWZLo1Yc4FG0COGDXlI1Wp1fmF+VPY/MTHOsoqsAsQ4mNHgEXxvTvlG7AAogEVmDeWtbd8gia7Ffjw2TpcBjN8paQmynhPOk+K0A24B5jLOP9zU1MXbyknHGPutVXjwyuN2xXWzFO/vpN1TMpq+XIDKi19eX2ZtMp20CjyUTGT7FmNAtMr06z+Y64mlGZxFh1SqYH2zw4Qlgf+A4OjriWZk5e4/fe8kkVbcFLe6TQhTgS613upSheXWRGADyo1pyOrnBlG7/2ND0OgG0YH/DZI819Gjap+bmKfYPXqjE2TfAxmKcN3OHZrWV/bBn2/CFkhjwkouOap5j7mow7WQB+FBXBRUJRO2mzg44zw/939b6YuAfp40g+NUqZc9U3afyX+SX7pNrBmFy9lLUQez2SHEfkZdaElKfVEfcE/zpktzG1PBZFedW+2rPH4RGbSO6q33PZK9maLCbon27gkunU7UmdKZtjTpSk3eWFxp9bWy/8bAOvO0cclfILclFtiaw44OTiXKzCPwjDl/WLacd39JGKrz/hvCEu5lz18qhU+e+1UC7/hr2MVjnLus5GTWC9Z+uMF8Ufi7LP3HG62KcoMmniwUzwiK3
 +Ohdz1ot
 mHyQEWMfuJSnGnhJ+inSFAEM5JwGNrrNfabDIqNPxoxXL1pKTyEMkW481QDcQj+/tzHMrJkQyAp1NkARYAHgZSdVXnzEKC8aJqS032pNJIbkr9fsceRT9OAz+O45Ou+zCOK2vocgj93hfxwBZWekoQ9ndW/TKeG2GCzoSs55D9h6Y51mKsTvI/HgCaZCGMiPv63ouKuxe0QOiFoetWf2ErvQrHWiYyZ1awdHMJxrGxE/zB2K4ZZhe/Z/LkvwJiqxy6M2waSoRBxnClnC13xgocKZquGdc9Ipu3WwQIyOHFslv3rGeTMTU8C0Mht6DkGDu5uuwM9ewnQjmPJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 12:47:51AM +0800, Ke Sun wrote:
> From: Alvin Sun <alvin.sun@linux.dev>
> 
> Userspace needs multiple independent GPU address spaces per file,
> addressed by ID through the VM ioctls as in panthor. Store them in an
> IdPool (capped at 32 for panthor parity) plus an XArray. Each VM is
> stored with its VmOwner, so it is killed exactly once - on destroy or
> file close - regardless of remaining shared references.
> 
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
>  drivers/gpu/drm/tyr/vm.rs | 157 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 156 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
> index c5e307b1e2416..ae58135eeffdc 100644
> --- a/drivers/gpu/drm/tyr/vm.rs
> +++ b/drivers/gpu/drm/tyr/vm.rs
> @@ -8,6 +8,7 @@
>  //! mapped into hardware address space (AS) slots for GPU execution.
>  
>  use core::marker::PhantomData;
> +use core::mem::ManuallyDrop;
>  use core::ops::Range;
>  
>  use kernel::{
> @@ -33,6 +34,7 @@
>          }, //
>      },
>      fmt,
> +    id_pool::IdPool,
>      impl_flags,
>      io::PhysAddr,
>      iommu::pgtable::{
> @@ -53,7 +55,11 @@
>          ArcBorrow,
>          Mutex, //
>      },
> -    uapi, //
> +    uapi,
> +    xarray::{
> +        AllocKind,
> +        XArray, //
> +    }, //
>  };
>  
>  use crate::{
> @@ -154,6 +160,57 @@ fn try_from(value: u32) -> Result<Self, Self::Error> {
>      }
>  }
>  
> +/// Owns a [`Vm`]'s destruction: the VM is killed exactly once, when this
> +/// value is dropped, regardless of how many `Arc<Vm>` references remain.
> +///
> +/// Callers that only need to use the VM take an `Arc<Vm>` via
> +/// [`VmOwner::get()`], which keeps it alive but does not kill it.
> +pub(crate) struct VmOwner<'drm>(ManuallyDrop<Arc<Vm<'drm>>>);
> +
> +impl<'drm> VmOwner<'drm> {
> +    /// A reference for callers that want to use the VM, not own it.
> +    #[expect(dead_code)]
> +    pub(crate) fn get(&self) -> Arc<Vm<'drm>> {
> +        Arc::clone(&self.0)
> +    }
> +
> +    /// Transfers the VM to the pool without killing it, leaving only the
> +    /// shared reference. The pool reconstructs the owner with
> +    /// [`VmOwner::from_shared()`] when the VM is removed.
> +    fn into_shared(mut self) -> Arc<Vm<'drm>> {
> +        // SAFETY: `self.0` is initialized, and `forget(self)` below prevents
> +        // the outer wrapper from being dropped, so the taken `Arc` is moved
> +        // out exactly once and nothing is leaked or double-dropped.
> +        let vm = unsafe { ManuallyDrop::take(&mut self.0) };
> +        core::mem::forget(self);

This looks a bit more complicated than what Daniel suggested.
But also I am concerned that the ioctl series might not be the right place to
rework the whole VM ownership/lifetime model. I definitely think it's
worth looking at but I wonder if you could send the ioctl series first
without changing VM ownership, and then follow up with a series proposing
these kinds of changes. It is a significant change that deserves its own
scrutiny.

> +        vm
> +    }
> +
> +    /// Reconstructs an owner from a shared reference.
> +    ///
> +    /// The caller must currently own the VM's destruction.
> +    fn from_shared(vm: Arc<Vm<'drm>>) -> Self {
> +        Self(ManuallyDrop::new(vm))
> +    }
> +}
> +
> +impl<'drm> core::ops::Deref for VmOwner<'drm> {
> +    type Target = Vm<'drm>;
> +
> +    fn deref(&self) -> &Vm<'drm> {
> +        &self.0
> +    }
> +}
> +
> +impl Drop for VmOwner<'_> {
> +    fn drop(&mut self) {
> +        self.0.kill();
> +        // SAFETY: `self.0` is initialized and we are in `drop`, so it is safe
> +        // to drop the inner `Arc` now that the VM has been killed.
> +        unsafe { ManuallyDrop::drop(&mut self.0) };
> +    }
> +}
> +
>  /// Arguments for a virtual memory map operation.
>  struct VmMapArgs<'drm> {
>      /// Access permissions and caching behavior for the mapping.
> @@ -948,3 +1005,101 @@ fn pt_unmap(dev: &Device, pt: &IoPageTable<'_, ARM64LPAES1>, range: Range<u64>)
>  
>      Ok(())
>  }
> +
> +/// Maximum number of VMs a single file may hold, matching panthor's
> +/// `PANTHOR_MAX_VMS_PER_FILE`.
> +const MAX_VMS_PER_FILE: usize = 32;
> +
> +/// Per-open-file pool of VMs.
> +#[pin_data(PinnedDrop)]
> +pub(crate) struct VmPool<'drm> {
> +    #[pin]
> +    ids: Mutex<IdPool>,
> +    #[pin]
> +    vms: XArray<Arc<Vm<'drm>>>,
> +}
> +
> +impl<'drm> VmPool<'drm> {
> +    /// Creates a new [`VmPool`].
> +    #[expect(dead_code)]
> +    pub(crate) fn new() -> impl PinInit<Self> {
> +        let ids = IdPool::new();
> +        pin_init!(Self {
> +            ids <- new_mutex!(ids),
> +            vms <- XArray::new(AllocKind::Alloc),
> +        })
> +    }
> +
> +    /// Takes ownership of `vm` and stores it, returning the allocated ID.
> +    ///
> +    /// On failure - ID space exhausted or store failure - the VM is killed
> +    /// here and only the error is returned.
> +    // TODO: allocate IDs with the XArray directly (once it grows range
> +    // allocation, the equivalent of C's `XA_LIMIT`) and drop the IdPool.
> +    #[expect(dead_code)]
> +    pub(crate) fn add(&self, vm: VmOwner<'drm>) -> Result<u32> {
> +        let id = {
> +            let mut ids = self.ids.lock();
> +            let unused = ids.find_unused_id(1).ok_or(ENOSPC)?;
> +            if unused.as_usize() > MAX_VMS_PER_FILE {
> +                return Err(ENOSPC);
> +            }
> +            unused.acquire()
> +        };
> +
> +        let vm = vm.into_shared();
> +        let mut vms = self.vms.lock();
> +        match vms.store(id, vm, GFP_KERNEL) {
> +            Ok(prev_vm) => {
> +                drop(prev_vm);
> +                Ok(id as u32)
> +            }
> +            Err(err) => {
> +                // Drop the XArray spinlock before acquiring the `ids` mutex.
> +                drop(vms);
> +                // Kill the VM and release the pooled id before returning.
> +                drop(VmOwner::from_shared(err.value));
> +                self.ids.lock().release_id(id);
> +                Err(err.error)
> +            }
> +        }
> +    }
> +
> +    /// Removes the VM with the given ID, handing back its owner.
> +    ///
> +    /// Dropping the returned [`VmOwner`] kills the VM immediately.
> +    #[expect(dead_code)]
> +    pub(crate) fn remove(&self, id: u32) -> Result<VmOwner<'drm>> {
> +        let mut vms = self.vms.lock();
> +        match vms.remove(id as usize) {
> +            Some(vm) => {
> +                drop(vms);
> +                self.ids.lock().release_id(id as usize);
> +                Ok(VmOwner::from_shared(vm))
> +            }
> +            None => Err(EINVAL),
> +        }
> +    }
> +
> +    /// Gets a shared reference to the VM with the given ID.
> +    #[expect(dead_code)]
> +    pub(crate) fn get(&self, id: u32) -> Option<Arc<Vm<'drm>>> {
> +        let vms = self.vms.lock();
> +        let borrow = vms.get(id as usize)?;
> +        Some(Arc::from(borrow))
> +    }
> +}
> +
> +#[pinned_drop]
> +impl PinnedDrop for VmPool<'_> {
> +    fn drop(self: Pin<&mut Self>) {
> +        let this = self.project();
> +        // Kill every VM still owned by the pool. The ID range is bounded by
> +        // `MAX_VMS_PER_FILE`, so this loop is cheap and runs at file close.
> +        for id in 1..=MAX_VMS_PER_FILE {
> +            // Release the XArray lock guard before killing: `kill()` may sleep.
> +            let vm = this.vms.lock().remove(id);
> +            drop(vm.map(VmOwner::from_shared));
> +        }
> +    }
> +}
> 
> -- 
> 2.43.0
> 

