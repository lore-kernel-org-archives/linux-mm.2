Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B46F0CA9EC1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 17:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC666B0088; Sat, 10 Oct 2026 13:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166CA6B008A; Sat, 10 Oct 2026 13:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02E196B008C; Sat, 10 Oct 2026 13:15:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B46C26B0088
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 13:15:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F09D1606AB
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 17:15:30 +0000 (UTC)
X-FDA: 85307368020.29.14E64FE
Received: from sender5-op-o11.zoho.com (sender5-op-o11.zoho.com [165.173.182.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7E5631C0005
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 17:15:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=UWF39N5g;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf20.hostedemail.com: domain of deborah.brouwer@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791652527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MMtFq9bWQpg384y3j6kqCOJ4Ggxs0ul2wtk4vIuRyU=;
	b=59Qb+SOvTBHSFCQmqycn54IwDW/TJ//U/28hgAvJWlLjR5FBgD4x/VYSg7csMcCLxtVxlS
	iqFACoUsSmu78XjQoOJaJGW8o8nMd5r0WSxKIhX6W277RWvoitoSaBq7IHoqiW8CasjvSD
	dWwpCL84ZVV6qwHJoA1HUvSH8tT1LT0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=UWF39N5g;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf20.hostedemail.com: domain of deborah.brouwer@collabora.com designates 165.173.182.11 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791652527;
	b=u8LPucQ6OD+32cH8Dkpke1QAl/uebpKGBNtjtQNceE0AymnL71Km/YpVPMBZ3NnpmEwL15
	AebjOm/2BtPsk7PJ3iTr45Y0iZu9tUADkfF3Bgiwm0ch88LHCS7YaR6xUuQYCo6uSNnYd1
	7ibmqPgvLOIF0+7anA2WLtWM4s7MxwU=
ARC-Seal: i=1; a=rsa-sha256; t=1791652515; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=GJt8Jlj4aSFDLARvtH9UMtj7oHXhlxMrKHK1R1T9StWb3yjQIds5nLzllEKnQNtfNC3OL70T2koIqw/ko3VdJ12MnXDcFv32qLbOEDa1KTLQeUg/kITyGzN3o2sqbTVmZ7WAFZlyuK4FGZ5iOcj9MGpeovCqJzHDOlxEV3xS6DU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1791652515; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7MMtFq9bWQpg384y3j6kqCOJ4Ggxs0ul2wtk4vIuRyU=; 
	b=kDIXixZzC34nZkFZHY0JRU2E5AVDk7LKG/icsmTQsE6w3pLKOR2a/0II/q3gKVi7nxW62/1TrlgS6ATr3LRJNnroZz7zvQEAEBP7r0zcU9aYfWKIK4VvtWgRfAiDduLl8yrILT0bF8+ZbEyFYM4doKmDWsiWrriFW77NS5YvYdA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1791652515;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=7MMtFq9bWQpg384y3j6kqCOJ4Ggxs0ul2wtk4vIuRyU=;
	b=UWF39N5goNwTREAL92v+w3Trj29+VzSkP101iksdFcgHVmTSPVQ3llNIsJbPcsUv
	3ZWNCOhTrL+sFXLimQTLvAtzoOXVHJlkkbK8ZvFQWLJD0vrDRGiSvcV7Ccs5yPXXxR5
	bBpnuZ/r11wBq5TNdGZpoboIJznput+8ecBDz/9c=
Received: by smtp.zohomail.com with SMTPS id 1791652513640895.151050249423;
	Sat, 10 Oct 2026 10:15:13 -0700 (PDT)
Date: Sat, 10 Oct 2026 10:15:12 -0700
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
	Alvin Sun <alvin.sun@linux.dev>
Subject: Re: [PATCH v3 04/11] drm/tyr: add per-file VM pool
Message-ID: <aspyoBHaSaJpMxJv@um790>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
 <20260929-tyr-ioctls-v3-4-26955fb111d5@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929-tyr-ioctls-v3-4-26955fb111d5@kylinos.cn>
X-Zoho-Virus-Status: 1
X-Zoho-AV-Stamp: zmail-av-0.2.13.1.5.4/291.643.73
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7E5631C0005
X-Stat-Signature: jbgs9b1oxsuqsxjf3mqgkfaub1b47a8d
X-HE-Tag: 1791652527-678769
X-HE-Meta: U2FsdGVkX1+PH41apl9HDrw3IYSBIAZ5G684jBRpKbVpvnrrzSCA865/BrZ5wrpseB8ROzrcRwwwLasOW9hH41PCOAKzvfxRdz27/qmGcgupZ7ZWqH2x0ufoXrQtoVxNhVD9O3uxwEP5H0EVuTSoER4GSe94hBQRDu6cE08xwXxAWOY/i6uK6ap9s+6kaVvFl/dHfwX8GR1eRa9hLj2vJHTbJvS98+MOM5lEnfDTAyHJfFHVYcKUGhKOf9qfdEWIMzNR87oVK/5rXd0MKK857kFLgDoWfhyIMoq5VwgQn9vfZWA4qxMbh9UNN/L7KzGG7YGbQ45nEJ6b09AS/ZSIuDi1LUr/xclUsbJ30r6Wevmv/sTrnVNgeR2FrwhUENBVo4s1bhPfaLX4q0FpttCDoA2zCESMH0ZiKoiBGTgWTGr4W8hSy6Y3vskUOyabJZGz8WLxLWSFwZgW+7NCcVL5El4DGaQmIr/svJir8XJKdehSmX5QdDOPlvmtMZYPG0dafdvMEGTD1InuZFs8TY0iwkOwHqW54rOY8+SJMwo+d+Df1rQH4xBX1XoDq31Chxeo9X1jFk3Ia+Gi6Idxa7RWwdDELa16x+eYlg7InpSevO+AjVPbHFcqjO/brCb+MzMTT/0+LoHXwwuoEkxK+4LE2faOz61JH4PiTHqwhwlkI4mcDcQTY7A+C1OI6OoPESsqy3y9woDTzFLU1ZmISLrMA/zX4Udp6flezin95cvuIe1cbsEVHxkr3j3hI/FqjYS2nhMUy9OCKvITyC+YHAsvl6EN2Q4P5aL4Gphm1jKZVzsgvp/VWpVqqO4aAxbG3pRZLq0Kj9uVr1wNcVjt7d3l3oydq06z6vGt7Ngh/zkYYGcbooEwqrhoYOvdC/i2K4WaYEWsB08+SZsiMU+4AvShPIOPRw26QTgZwvpE7xF2zfYUm27itKGdm0EE0PzI9bbCFNdG5iwmh+mUxS4X8JK
 wsfOrd5R
 gdoDbpwZtwENKy719cR8Mzv0+2D2B83rojWv7cs3Ks+H3RLWgO/S1oaRSF3n6u127hli5gkRhoiiIiGQ23DUsB2I6/cW+BkLaJhAXau74cpx2JFpk+YhwJXe3JwvMOs3ngkeWe5hU1HInL2zIW20yNfEDF9kz4FNOuZKvWYWf9BaxMPR9J2e/EkUT5aWa62vILl/qkBE+/9UGMBbJfYi8/bFYPBvGdl0ccnoRSFvnsjbAuewaudJeM8grR8IXrl90UmmbaV0bZqxish3GabhqAbAKKf66TK2SkqHLTp6Ar9jvrOSs+aptbsxOTZtU6cG4JMhVzGujpUv43LI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 10:15:54AM +0800, Ke Sun wrote:
> From: Alvin Sun <alvin.sun@linux.dev>
> 
> Userspace needs multiple independent GPU address spaces per file,
> addressed by ID through the VM ioctls as in panthor. Store them in an
> IdPool (capped at 32 for panthor parity) plus an XArray. A failed
> insertion kills the VM before returning the error, and the pool kills
> every VM still stored when the file closes.
> 
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
>  drivers/gpu/drm/tyr/vm.rs | 106 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 105 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
> index c5e307b1e2416..a2857820570cf 100644
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
> @@ -948,3 +953,102 @@ fn pt_unmap(dev: &Device, pt: &IoPageTable<'_, ARM64LPAES1>, range: Range<u64>)
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
> +    /// Stores the VM and returns the allocated ID.
> +    ///
> +    /// On failure - ID space exhausted or store failure - the VM is killed
> +    /// here and only the error is returned.
> +    // TODO: allocate IDs with the XArray directly (once it grows range
> +    // allocation, the equivalent of C's `XA_LIMIT`) and drop the IdPool.
> +    #[expect(dead_code)]
> +    pub(crate) fn add(&self, vm: Arc<Vm<'drm>>) -> Result<u32> {

Should we kill the vm for both instances of ENOSPC too?
There is no type guarantee that this function will only work with
a newly created/unmapped vm, so we should probably kill the vm.
Also change the documentation so the vm is killed for all failures.

> +        let id = {
> +            let mut ids = self.ids.lock();
> +            let unused = ids.find_unused_id(1).ok_or(ENOSPC)?;
> +            if unused.as_usize() > MAX_VMS_PER_FILE {
> +                return Err(ENOSPC);
> +            }
> +            unused.acquire()
> +        };
> +
> +        let mut vms = self.vms.lock();

Before storing the vm in the pool, let's check first if we found 
an existing vm in this spot. If prev_vm exists then our id pool is
out of sync with our xarray and this is a big screw up. So let's
kill and drop both the prev_vm and the current vm and error out.
Obviously, this will be better in the future when we
can stop using the IdPool.


> +        match vms.store(id, vm, GFP_KERNEL) {
> +            Ok(prev_vm) => {
> +                drop(prev_vm);
> +                Ok(id as u32)
> +            }
> +            Err(err) => {
> +                // Drop the XArray spinlock before acquiring the `ids` mutex.
> +                drop(vms);
> +                // Kill the VM and release the pooled id before returning.
> +                err.value.kill();
> +                self.ids.lock().release_id(id);
> +                Err(err.error)
> +            }
> +        }
> +    }
> +
> +    /// Removes the VM with the given ID.
> +    ///
> +    /// The caller is responsible for killing the returned VM.
> +    #[expect(dead_code)]
> +    pub(crate) fn remove(&self, id: u32) -> Result<Arc<Vm<'drm>>> {
> +        let mut vms = self.vms.lock();
> +        match vms.remove(id as usize) {
> +            Some(vm) => {
> +                drop(vms);

Why not just kill the vm here rather than making the caller responsible
for killing it? Not only does this prevent a potential bug if someone
forgets to kill the vm, but also it would make sure that the vm is
unavailable before releasing that id again for reuse.
Also you wouldn't have to return the vm from this function so it
could just drop.

> +                self.ids.lock().release_id(id as usize);
> +                Ok(vm)
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

