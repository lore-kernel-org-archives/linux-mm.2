Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AD91C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 17:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A096B0092; Thu,  3 Sep 2026 13:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F17E6B0095; Thu,  3 Sep 2026 13:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607156B0096; Thu,  3 Sep 2026 13:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 38E336B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:52:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41635A05F3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:52:17 +0000 (UTC)
X-FDA: 85173195114.21.CFAD9EF
Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3CA19C0008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:52:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Mj6Cp+V5;
	spf=pass (imf22.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788457935;
	b=w0mbSEnkM3lSSfnDgSdjm+6uimTS1xb2EgSyNDqDqTwwb6HGl0RDOJQ0ftVxPDmR8LSwIg
	45ine72lK6E4X9PEgrfvlFi1d+q20V7OSb5jDZbFZSdRIWhF9vjPtb/WL9Sjn1JIqZZRn2
	1nMzjxfYPC6NpashCGrVl2vuqZ+TT54=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788457935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGLdaPIPtIV6poVR9G2Ip8+hPdKw2Q5nu6oGk++2sp4=;
	b=O01i/BCKU4a/k8ED2r2Zc+77b6FqmarTZ9s1HEAwEwFXf/NwGM7G2pE+teTU0tY8M84KNC
	bTmLSFzEKC0CB5Ry5uD6B26PE+4NBg/9n97AA3HjAOFc709gEFCRAFeR5LMr61MC9wOR2Q
	TrkdU4MW9TYkctS0ruSezNg9G5rSHHE=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Mj6Cp+V5;
	spf=pass (imf22.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1788457926; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=WvqhDW8vLrQTi/1zVi+ANIXOdEP89reRwMqVrgEaCZai0kMUS+IuQHbV2TOAYLMBYZSBnjMYFl/BeuS0B3pWmGtDqt5nNP3Lg2sodGASkSKJic5AhtGdE+7Mbmo/rowjprfZJRi33WRuGftC2pykNUlWHeCR7Xjs/J4/k9fmBRw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1788457926; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=QGLdaPIPtIV6poVR9G2Ip8+hPdKw2Q5nu6oGk++2sp4=; 
	b=IaKIDYgszPMfg3l9RpwCj/PcPF/NvBc/04vLIuUoD0B+n0aPbIx2VKpBlp68iEgE06tUN4FrW4aFZpYQudg3BsHYknvObaYHdJLkajTlk/6sZyeDacBqV3MfqTM/RrCW95idTNQY/33BWMSV9ZOfeLdJWOjysgqLYSPBOILqkSU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788457926;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=QGLdaPIPtIV6poVR9G2Ip8+hPdKw2Q5nu6oGk++2sp4=;
	b=Mj6Cp+V5uwGRJQelXLn1Ix2yBczSbA0BTl9vsX4GRBGcGjx9ZJF6X6Fzw2M6CAHb
	dEoYi9ddBmm8cKG/Xgre2fGKq3jmSPs9Ai/fnfx9ItIleRm5M7H+n0UJMzBUC2iRzmB
	TmdvlisIU0UAK240k9PM8FW7OfXvONafdWk8V5HY=
Received: by mx.zohomail.com with SMTPS id 1788457924738374.8144591285119;
	Thu, 3 Sep 2026 10:52:04 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH 4/9] drm/tyr: add per-file VM pool
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260902-tyr-ioctls-v1-4-e0fdbf8bd108@kylinos.cn>
Date: Thu, 3 Sep 2026 14:51:44 -0300
Cc: rust-for-linux@vger.kernel.org,
 Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>,
 =?utf-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lyude Paul <lyude@redhat.com>,
 David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org,
 Alvin Sun <alvin.sun@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <4277C681-AD91-4809-9212-012C8A6FDCBF@collabora.com>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260902-tyr-ioctls-v1-4-e0fdbf8bd108@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3CA19C0008
X-Stat-Signature: 95omrir8xg7r8up9etpzf7y4t9dmrdj8
X-HE-Tag: 1788457934-321613
X-HE-Meta: U2FsdGVkX195RmWVw70cQtbcJhJ8uBBnHA6AG7SFkQRr08lw9ZhriQEKCr1/6DCx/wEt6IMf6gjbkxmQn9CnP0zUTVBjLQqoaGnoQNUAZMTRgZTCkrseYDAB3NbZYQ1ZHpBEc6B4d3BoZLKsLh0+tdtYlmBUoAyDejueI/Fbf20EtgA2N8wRg6ftPAfxoR2xoi5JqCMEUNKiSVTNoSgw8KHNQFso7U1Kk9PuhsR+QzAVsH8QL084vT7gUECcn2m/v9MvCE6XGQnFRV3auwenYg8IW5R0XmU9skqs8trTJmM7/V8zuCDuT1e8PqgJL2QImKLG7Mx5tKvRAmOd+nkhyyQ3JYYyvADMsZiZRP80QJTVTtIAt8mdDG1jOBVja5peHT2u3vB/kNnbOGJvIsezYyY4VhavdRRKC5lW2JmwmA355P6+4FUW3Tr2Dnzo/gqfPxqzCZ5GLw5IICLhXbgU9w7RR5dW8+mKcdFDEmP59zbtSqfiDRQrNkv/Q8VcnuB0VzQ45ypeXtmBkV98PmJLUZP4kvMljgjax9QbQ1QpeKFoIwlD8nrACpIX03Gobxp/HUNFXNgGONDHUMaVl7iRUNjuWPKhq2KbYmzm5LAyKkNlMxL2LsLBeiTL4bTexHXGp/jTmSSR7Kzm5XgshpL9AnPKafAmlqXf8myyhD5/LXFC/0MX9RoaAQ52cHa2c7lVXdQebRW7f98ileGub6rNgbngONgj3+WwVGnoTh7JFGpZ0bCBHOPMO+Cn38w2AfeDdyboT3lkyMQ8yd2R/P4McoRDbH7v+LAQMx3PuOoBPfB6XOkmmySVS2cPaaVL0DxnNfeeQG7rGIJFI1BnYtAbIHoix0ZtEVOoEdjjuRovemwiVjQJY03JUurqQDEYRqKDI3lRdBhmbU7ntRZvS8TeniQIqqIvNBJU477/5RN7hO0P08mI6CpN7WIjUkZ/zij0Gz8zvXxAsyge4pg1WgD
 o9BWdOes
 vaICl2YwAS2gN5E9JxKR53JgFVvlLUTzpBkqV80rgXCgrqtKg92Yk8aBcLJ1klCr0YvbZEPUHTcUmjfA02UDe8u+ciuHhGFGq+RO753wgo6OI4qT/Yh0vdBZU7FUQ/3ncZ3IW6aQkWKlVhMBghNSUh5FiXB2s3TxYwm04WV88uFFKisl5J9jol2VBIxyKT+IFTn1OvWoqIhIFhXc2BrMZgXvRSz6RG7SIWYQ9EMCS+CvhnH6katI68Omf2atB8Z18pnWnQVg0oQjpsM52Tn1sH/9yiaucRgDUSstP6m5A0bCzVzR221Mg1weGlQqR7Gs8RIW9Cxx4uAKJzVN4IQnDnYuVjxxj6me8d7RAd7aGG2L8/3GsIzjbpK32ZpHB7BGJmD9xAH598aXtqAyxZ3DoT1j6QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 1 Sep 2026, at 13:09, Ke Sun via B4 Relay =
<devnull+sunke.kylinos.cn@kernel.org> wrote:
>=20
> From: Alvin Sun <alvin.sun@linux.dev>
>=20
> Add a per-file VM pool using the IdPool for ID allocation
> and an XArray for VM storage.

Can you say a few more words here? You don=E2=80=99t need to =
over-explain, but I
don=E2=80=99t think this alone says _why_ your change is needed for the =
community
at large.

>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
> drivers/gpu/drm/tyr/pool.rs | 102 =
++++++++++++++++++++++++++++++++++++++++++++
> drivers/gpu/drm/tyr/tyr.rs  |   1 +
> 2 files changed, 103 insertions(+)
>=20
> diff --git a/drivers/gpu/drm/tyr/pool.rs b/drivers/gpu/drm/tyr/pool.rs
> new file mode 100644
> index 0000000000000..1745116930c3e
> --- /dev/null
> +++ b/drivers/gpu/drm/tyr/pool.rs
> @@ -0,0 +1,102 @@
> +// SPDX-License-Identifier: GPL-2.0 or MIT
> +
> +//! Per-drm-file VM id pool.
> +
> +use kernel::{
> +    id_pool::IdPool,
> +    new_mutex,
> +    prelude::*,
> +    sync::{
> +        Arc,
> +        ArcBorrow,
> +        Mutex, //
> +    },
> +    xarray::{
> +        AllocKind,
> +        XArray, //
> +    }, //
> +};
> +
> +use crate::vm::Vm;
> +
> +/// Maximum number of VMs per open file. Matches panthor's
> +/// `PANTHOR_MAX_VMS_PER_FILE`.
> +pub(crate) const PANTHOR_MAX_VMS_PER_FILE: u32 =3D 32;
> +
> +/// Per-open-file pool of VMs.
> +#[pin_data]
> +pub(crate) struct VmPool<'drm> {

I agree with Deborah that this should be in vm.rs itself.

> +    #[pin]
> +    ids: Mutex<IdPool>,

Can you add a todo here so we use the XArray directly in the future?

> +    #[pin]
> +    vms: XArray<Arc<Vm<'drm>>>,
> +}
> +
> +impl<'drm> VmPool<'drm> {
> +    /// Creates a new [`VmPool`] with capacity for =
[`PANTHOR_MAX_VMS_PER_FILE`] VMs.
> +    pub(crate) fn new() -> Result<impl PinInit<Self>> {
> +        let ids =3D IdPool::with_capacity(PANTHOR_MAX_VMS_PER_FILE as =
usize, GFP_KERNEL)?;
> +        Ok(pin_init!(Self {
> +            ids <- new_mutex!(ids),
> +            vms <- XArray::new(AllocKind::Alloc),
> +        }))
> +    }
> +
> +    /// Inserts a VM into the pool, returning the allocated ID.
> +    pub(crate) fn add(&self, vm: ArcBorrow<'_, Vm<'drm>>) -> =
Result<u32> {
> +        let id =3D {
> +            let mut ids =3D self.ids.lock();
> +            ids.find_unused_id(1).ok_or(ENOSPC)?.acquire()
> +        };
> +
> +        let vm: Arc<Vm<'drm>> =3D vm.into();
> +        let mut vms =3D self.vms.lock();
> +        match vms.store(id, vm, GFP_KERNEL) {
> +            Ok(previous) =3D> {
> +                // Drop the previous entry (expected `None`).
> +                drop(previous);
> +                Ok(id as u32)
> +            }
> +            Err(err) =3D> {
> +                // Drop the XArray spinlock before acquiring the =
`ids` mutex.
> +                drop(vms);
> +                // Release the stored entry and the pooled id.
> +                drop(err.value);
> +                let mut ids =3D self.ids.lock();
> +                ids.release_id(id);
> +                Err(err.error)
> +            }
> +        }
> +    }
> +
> +    /// Removes the VM with the given ID.
> +    pub(crate) fn remove(&self, id: u32) -> Result<Arc<Vm<'drm>>> {
> +        let mut vms =3D self.vms.lock();
> +        match vms.remove(id as usize) {
> +            Some(vm) =3D> {
> +                drop(vms);
> +                let mut ids =3D self.ids.lock();
> +                ids.release_id(id as usize);
> +                Ok(vm)
> +            }
> +            None =3D> Err(EINVAL),
> +        }
> +    }
> +
> +    /// Gets the VM with the given ID.
> +    pub(crate) fn get(&self, id: u32) -> Option<Arc<Vm<'drm>>> {
> +        let vms =3D self.vms.lock();
> +        let borrow =3D vms.get(id as usize)?;
> +        Some(Arc::from(borrow))
> +    }
> +
> +    /// Removes and returns the first VM in the pool.
> +    pub(crate) fn pop_first(&self) -> Option<Arc<Vm<'drm>>> {
> +        for id in 0..PANTHOR_MAX_VMS_PER_FILE {

This should be inclusive, i.e. =E2=80=9C..=3D=E2=80=9C instead of =
=E2=80=9C..=E2=80=9D. But a
better solution is to do:

for id in 0..self.ids.lock().capacity() {
  ..
}


> +            if let Ok(vm) =3D self.remove(id) {
> +                return Some(vm);
> +            }
> +        }
> +        None
> +    }
> +}
> diff --git a/drivers/gpu/drm/tyr/tyr.rs b/drivers/gpu/drm/tyr/tyr.rs
> index e7ec450bdc9c0..8c0c18c1a970b 100644
> --- a/drivers/gpu/drm/tyr/tyr.rs
> +++ b/drivers/gpu/drm/tyr/tyr.rs
> @@ -13,6 +13,7 @@
> mod gem;
> mod gpu;
> mod mmu;
> +mod pool;
> mod regs;
> mod slot;
> mod vm;
>=20
> --=20
> 2.43.0
>=20
>=20


