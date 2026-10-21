Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9601606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 22:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=collabora.com header.i=deborah.brouwer@collabora.com header.a=rsa-sha256 header.s=zohomail header.b=OfOoJvBW
Received: by kanga.kvack.org (Postfix)
	id E81E06B07E0; Wed, 21 Oct 2026 18:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E120E6B07E2; Wed, 21 Oct 2026 18:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD28F6B07E3; Wed, 21 Oct 2026 18:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FDF96B07E0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:59:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0E13A8305
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:59:57 +0000 (UTC)
X-FDA: 85348152834.29.3775959
Received: from sender5-op-o11.zoho.com (sender5-op-o11.zoho.com [165.173.182.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id DF590180005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:59:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=OfOoJvBW;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf06.hostedemail.com: domain of deborah.brouwer@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792623596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o0uJl9SaCMTX22dhBn+kimrcYeaap+l2h4VH/HTX/Bw=;
	b=QZEJGOGYmqXJ+z5BYXZbTRinmo9O/31pwuTmsB4XqEVzJSP6ZCDU/2Jz5Tfpxr5yDqTPF4
	R7oMbsRRvc1ozVCtuAD0iStrp/4D/LsFgpVi9UzhS5Sz3CaQOQNFedzWkitBrtnydVPAP3
	QoVli8sSaFNBYuFNZlEfFSwIE9hEb0w=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=OfOoJvBW;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf06.hostedemail.com: domain of deborah.brouwer@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792623596;
	b=DSjPUbpVOWP1voows/Ww+LYt9QCV3JrIhLiX95H4YjRCiwyjqOutBJ2ELYD3UeV9lBe2IK
	JqK+HJlz6MLKqjefOZQEFV2OHpjaxWwi6l0IIMuJO4kLN/f/LcM7PtybakqAeZ0mJccdn6
	3fNcWylJA8aQ0IGWxqj0uiMtOVoyvBE=
ARC-Seal: i=1; a=rsa-sha256; t=1792623577; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=YxVBf2r3nDwKMI/w4Cfj6wBPEhOJrYrOvgbHQuNF1ywKWQm7TKXl1BxN0MCzVhGnVPMmrOcH6Y7vwHRpSGH/RcyW4o/9bbNlAwDyJXiUXdg5ErkLkwoq1J2TXCQPoltJqCXeE7TykTIHOmTKyvOGdSm6I7BjWVq1/ZLJ0hXuUmw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1792623577; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=o0uJl9SaCMTX22dhBn+kimrcYeaap+l2h4VH/HTX/Bw=; 
	b=khUxgC7K6Dump7HNsU+T7sITG0K+jmATCHUoast6WPDxWHGGdTDBC0/QIMUIlIBg2Ki/G7lkO1OKQptby+w0tcfAj8SqJX6EGe78xbKaBP5tEaQXn0e3LAwEtnAJ4oJ2vyHWOXNz8bzWJ2c4vg/iUCx6qvZl2sHz8MuJup+spKc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792623577;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=o0uJl9SaCMTX22dhBn+kimrcYeaap+l2h4VH/HTX/Bw=;
	b=OfOoJvBWtQLZeQ1qUOZGpKI9LGZH2kuAFdLAMNQV3geS/kzBnYy8rznRYzbMbVBM
	HFcT0dwlhYAlcWgqtInVd0oIjVSrKah+jST9FZrq3K24sTSH9+BXxBAmWKElb0bJ6GL
	HYDwBvjQDUlcmMPboCn0WDmQXXbUEACnRUzHCU1w=
Received: by smtp.zohomail.com with SMTPS id 1792623575793141.6930617524606;
	Wed, 21 Oct 2026 15:59:35 -0700 (PDT)
Date: Wed, 21 Oct 2026 15:59:34 -0700
From: Deborah Brouwer <deborah.brouwer@collabora.com>
To: Ke Sun <sunke@kylinos.cn>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
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
	Simona Vetter <simona@ffwll.ch>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org, Alvin Sun <alvin.sun@linux.dev>
Subject: Re: [PATCH v4 04/11] drm/tyr: add per-file VM pool
Message-ID: <atlD1jzWqQhKE3w5@um790>
References: <20261020-tyr-ioctls-v4-0-704de77da223@kylinos.cn>
 <20261020-tyr-ioctls-v4-4-704de77da223@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261020-tyr-ioctls-v4-4-704de77da223@kylinos.cn>
X-Zoho-Virus-Status: 1
X-Zoho-AV-Stamp: zmail-av-0.2.13.1.5.4/292.612.36
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DF590180005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: d81hxq18miib1m9i6icwy1hobendgrne
X-HE-Tag: 1792623595-224844
X-HE-Meta: U2FsdGVkX1/Uvj5TqgyaVMxyQAo8zaNljLer7Bt4kRulLZ3Gud8L7PxFjL7ToC0dfSAjQLXrgySvQcYLMmSeDeE3O3YbXCwc59N+TA7BpbFlfqadNySFlwBXTIvNxmL6K+bdbS7YrYBj3aODr2hoIsKvNgjfqt2JEgnWLe1iyirAosmN1L/N9cnZ4xAFfFw2L6BEWM5dCZQM0ig+XrHLcEZOsZXXA+ivKPKSSX9zx6lUCnx6LbUFa2Wh+loXeAza/HQ+8w8+8YfT1Pf0Qk4kmqY0d9EMqDQhGjoPsjqvC7Oy7bOJ5ZbZwfty4KEARe9my7IMoze7OdtCkNgRi6tXS5OtQQx73cegAICfHM0C8KXnOHh8Y7T5dgEFO7z3kK0QTy+aNrDOI+kEn3RoS1QbuSZKTmkNgmVNEcg9MfqHstZyCZ/aVOB0ydyJpMfK6q69W+Y1ip4+IazJqrF9DSPL0pHsa22x/LH9pQ6sjKxcue5yN+zJwJZkqq2Ok+pvdtkQyzvPZbwN7jJAFBNfq5s7P5uafNBNZ4asmD8OpvSJ6VqY1VboJXh95SpHTlxUOmfJGOGjSap/YYZPKVHym5CY6CCFbhPHCcgv8iwjC6Z8JTqbzAhU0xwVyNaDKH9/7QgwsNEkZ8CTShI16r0Ch/yYhrXtEWu0f9wULYi9uVBTvQ4ra3SxXU08ibZ0Mq/m44Ss/WP97tZV37b4iO6ai2IKGkioeHREFwjO8ku0RGwh0t8K3xbJPPyFxh0n5YS2uAutifYp6vSxmsSDUxOZUMgrwdp132zJxyDLzinf2sf10XijsD4Ec3b/TkgaEsTsOZt3cHTH3quQ8YS5Yl1Uu6+X0u1rpg76uzDA3Ybs51DZ56MK9GdANoIgD8x9PivyTCUfKB7iW+CEWkXC0PC19NOZuUdz1MF0QHESxLShN5kz9wTTg4XVM7OIk29cQhyPK/9rbOLIVY5XYEcyvzBReKd
 v9ODPIE+
 iXbl/RBRLDtn45YVdBejil2NZPwKZDBUFuE1vHbuvg3Un4QFjIJFhxmDYQbQAbs2UvPzBuiDWtCEQKPbLVN10HRx67CK57UnLL/xkfMVPGLakQpRm9BK2FuynFZTyDIHVdbz0G+K0h+NNn1tc9kjai4S3wdGhUb1LlJKrk2fgnsIIWpXVeJlIwXU+LR0QxzECv1XHOUscr0Wb5xoy1znRhr4SrDJtf2DZXdGTPoZhvhyhWkNfoDOzmF5YhfSy8pD3fCb8u7UftUobz688kQbo7wTcO8D+MXfxGLz0yk+PIkqASK0pZHYgLA6/tatgeLoHtpT7V1czZp5hUao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 04:25:21PM +0800, Ke Sun wrote:
> From: Alvin Sun <alvin.sun@linux.dev>
> 
> Userspace needs multiple independent GPU address spaces per file,
> addressed by ID through the VM ioctls as in panthor. Store them in an
> IdPool (capped at 32 for panthor parity) plus an XArray. On a failed
> insertion the caller tears the VM down through the returned error, so
> an aborted creation never leaks a VM. The pool kills every VM still
> stored when the file closes.
> 
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
>  drivers/gpu/drm/tyr/vm.rs | 138 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 137 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
> index c5e307b1e2416..6935e4db667b9 100644
> --- a/drivers/gpu/drm/tyr/vm.rs
> +++ b/drivers/gpu/drm/tyr/vm.rs
> @@ -33,6 +33,7 @@
>          }, //
>      },
>      fmt,
> +    id_pool::IdPool,
>      impl_flags,
>      io::PhysAddr,
>      iommu::pgtable::{
> @@ -53,7 +54,11 @@
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
> @@ -948,3 +953,134 @@ fn pt_unmap(dev: &Device, pt: &IoPageTable<'_, ARM64LPAES1>, range: Range<u64>)
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
> +    /// Parent device, for error reporting.
> +    dev: &'drm Device<Bound>,
> +    #[pin]
> +    ids: Mutex<IdPool>,
> +    #[pin]
> +    vms: XArray<Arc<Vm<'drm>>>,
> +}
> +
> +/// Error returned when a VM cannot be added to the pool. The caller
> +/// owns the teardown of the VM in [`AddError::vm`].
> +pub(crate) struct AddError<'drm> {
> +    pub(crate) error: Error,
> +    pub(crate) vm: Arc<Vm<'drm>>,
> +}

When I try to compile just this patch i get an error about
this being unused so better annotate it with #[expect(dead_code)]
like the others.

> +
> +impl<'drm> VmPool<'drm> {
> +    /// Creates a new [`VmPool`].
> +    #[expect(dead_code)]
> +    pub(crate) fn new(dev: &'drm Device<Bound>) -> impl PinInit<Self> {
> +        let ids = IdPool::new();
> +        pin_init!(Self {
> +            dev,
> +            ids <- new_mutex!(ids),
> +            vms <- XArray::new(AllocKind::Alloc),
> +        })
> +    }
> +
> +    /// Stores the VM and returns the allocated ID.
> +    ///
> +    /// On failure - ID space exhausted or a store failure - the VM is
> +    /// returned in an [`AddError`] so the caller owns the teardown.
> +    // TODO: allocate IDs with the XArray directly (once it grows range
> +    // allocation, the equivalent of C's `XA_LIMIT`) and drop the IdPool.
> +    #[expect(dead_code)]
> +    pub(crate) fn add(&self, vm: Arc<Vm<'drm>>) -> Result<u32, AddError<'drm>> {
> +        let id = (|| {
> +            let mut ids = self.ids.lock();
> +            let unused = ids.find_unused_id(1).ok_or(ENOSPC)?;
> +            if unused.as_usize() > MAX_VMS_PER_FILE {
> +                return Err(ENOSPC);
> +            }
> +            Ok(unused.acquire())
> +        })();
> +        let id = match id {
> +            Ok(id) => id,
> +            Err(error) => return Err(AddError { error, vm }),
> +        };
> +
> +        let mut vms = self.vms.lock();
> +        match vms.store(id, vm, GFP_KERNEL) {
> +            Ok(prev_vm) => {
> +                if let Some(prev_vm) = prev_vm {
> +                    // An existing VM at the freshly allocated slot means the
> +                    // IdPool and the XArray are out of sync: the stored VM is
> +                    // a pool entry, so the pool kills it and the caller's VM
> +                    // is handed back for the caller to kill.
> +                    let stored = vms.remove(id);
> +                    drop(vms);
> +                    prev_vm.kill();
> +                    self.ids.lock().release_id(id);
> +                    dev_err!(
> +                        self.dev,
> +                        "IdPool/XArray out of sync at VM pool id {id} (stored VM conflict)"
> +                    );
> +                    return Err(AddError {
> +                        error: EBUSY,
> +                        vm: stored.expect("VM was just stored"),

Since the rust for linux coding guidlines say:
    panicking should be very rare and used only with a good reason.
    In almost all cases, a fallible approach should be used, typically returning a Result.

I'm wondering if there is a way to avoid this expect().
For example, you could store a vm.clone() in the xarray and keep the vm
that was passed to this function so that it can be returned on error.
And on success, the vm would just drop so the overall ref count wouldn't
be incremented.

> +                    });
> +                }
> +                Ok(id as u32)
> +            }
> +            Err(err) => {
> +                // Drop the XArray spinlock before acquiring the `ids` mutex.
> +                drop(vms);
> +                // Release the pooled id; the VM never entered the pool, so it
> +                // is returned to the caller for teardown.
> +                self.ids.lock().release_id(id);
> +                Err(AddError { error: err.error, vm: err.value })

When i run rustfmt on this patch it reformats this line, can you double
check you ran rustfmt?


> +            }
> +        }
> +    }
> +
> +    /// Removes and kills the VM with the given ID.
> +    #[expect(dead_code)]
> +    pub(crate) fn remove(&self, id: u32) -> Result<()> {
> +        let mut vms = self.vms.lock();
> +        let vm = match vms.remove(id as usize) {
> +            Some(vm) => vm,
> +            None => return Err(EINVAL),
> +        };
> +        // Drop the XArray spinlock before killing, since `kill()` may sleep.
> +        drop(vms);
> +        // Kill the VM before handing the id back to the pool, so a VM is
> +        // never reusable while still alive.
> +        vm.kill();
> +        self.ids.lock().release_id(id as usize);

Since i just learned about this myself, I should mention that you can
now use num::casts::FromSafeCast and then write
usize::from_safe_cast(id).

> +        Ok(())
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

I don't think you need to project the VmPool here because we only
need a shared ref to the pool, and the vms guard gives us the interior
mutability we need to modify the xarray anyway.

> +        // Kill every VM left in the pool. The ID range is bounded by
> +        // `MAX_VMS_PER_FILE`, so this loop is cheap and runs at file close.
> +        for id in 1..=MAX_VMS_PER_FILE {
> +            // Release the XArray lock guard before killing: `kill()` may sleep.
> +            let vm = this.vms.lock().remove(id);
> +            if let Some(vm) = vm {
> +                vm.kill();
> +            }
> +        }
> +    }
> +}
> 
> -- 
> 2.43.0
> 

