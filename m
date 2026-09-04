Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87EEFC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 18:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735AF6B0088; Fri,  4 Sep 2026 14:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5E96B008A; Fri,  4 Sep 2026 14:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AEB26B008C; Fri,  4 Sep 2026 14:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD7E6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:44:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B09414019E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:44:57 +0000 (UTC)
X-FDA: 85176956634.29.FBE37C3
Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	by imf07.hostedemail.com (Postfix) with ESMTP id EC37140003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:44:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=U4So7Wg1;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf07.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788547495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dE7pREUfzev8uemGZUZt9V+KKsWE0wgVX3zi6MBDmlo=;
	b=4HMNrZ43/UDrEA4e0bywOX4WS8NEn5ZENbBb09VVUkzj0UsKgJDfqu04meETJOPbSbEdfL
	kzApcvObvnxyab6c1RXDmLji6EPwiAog2+G9PpHdF1zYwdpwlvTrcNKymRMs428nNYxZOW
	EcfOvo2YLorQF81DkuzBMXQ6+rzISTE=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=U4So7Wg1;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf07.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788547495;
	b=dnx5grNiweCq1WmXbK3TpV49OosOQcD8ZRiVQz8TU3n4QXAPav3LU+mSttYXExzCsMZZL4
	NboU13FI7n6x0Vxmgn+Wmrq8lgxekQktj8fFLKVui3kSbkxCqvnkDml3dYyb/7IjiZBOWX
	Us6nYohyoJUsMn/rIampiRF7+cva7Ms=
ARC-Seal: i=1; a=rsa-sha256; t=1788547481; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=QWXMic1L7w2NkX1noOXqUfSBOAcpOuqV28IBoXLNHEHdMXAqp9dmfcl5n6J3AExPN4kS8wn4nCyQWLlwJ0Xi+EJxwKe0NO7+v3JeTuyJASOMLD/7Lxb6TaDt8jxr9I+VwmSmqdqK4noP0rIhahz0PD0r4O49knzY6kAxWPOdfCU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1788547481; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=dE7pREUfzev8uemGZUZt9V+KKsWE0wgVX3zi6MBDmlo=; 
	b=oBvcvyZTGF2T+5LI9fIMSwsg4DgknbLQq4r5Dd0jqqSDybpiNW0VcyKuZDecZ6RQsCJpoVO3MDephYhC+MjTn4f9bYPV2Qi2bCONq+3zpB9daHPmrTZvdXLhaJgLzbjgC/f00VDBxQbxLoHzcYenboxbHcKMFuxiBdz+/e6vWXA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1788547481;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=dE7pREUfzev8uemGZUZt9V+KKsWE0wgVX3zi6MBDmlo=;
	b=U4So7Wg1xSvd/Gqn9qxvXdAN8b48po41jwXUv1CG2dj6j4CkK3jznf7h33zDwEoM
	v+HUztwpD6SReO7vSkXkBgl3evB3eLilAxwA9gvqd5HGBGZgdciKIOpvnzA2OBx5Z6C
	SpikAeWptczBA69dGqqJRDVoi9cy/AVSKVEd8mq4=
Received: by mx.zohomail.com with SMTPS id 178854747883791.00347300645615;
	Fri, 4 Sep 2026 11:44:38 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH 8/9] drm/tyr: add VM-related ioctls
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260902-tyr-ioctls-v1-8-e0fdbf8bd108@kylinos.cn>
Date: Fri, 4 Sep 2026 15:44:18 -0300
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
Message-Id: <C59E65EF-33E6-449A-B109-307231B49057@collabora.com>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260902-tyr-ioctls-v1-8-e0fdbf8bd108@kylinos.cn>
To: sunke@kylinos.cn
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC37140003
X-Stat-Signature: ghfiatw8cbztrefqcibbwkkt485p4a4k
X-Rspam-User: 
X-HE-Tag: 1788547494-362821
X-HE-Meta: U2FsdGVkX1+eEAb/6z3bN0IC4w9TETiaQdZeJ8TGvAZ68g/IUb2MtSfedSnHI5Ze0tEC3XeDrpFl18xhD53sUW0YJzw6vE8j4KkteTLdLCojwJ6dsMC6aOvioNtlC7YTAMPoZaKiCIiGNLsDNAZ06rFJAqwSVWwhGQyp08ritIL1M0R5XX/wAijUFHfMrtiL2ChV40EqFPXzRlXlg1fyjYGR5Boj8slSzMLbQvfqS6+vpPBwA3HhaUXDlE74WGRHb1Qj/DEABxoYGgzGGXOqljFo+fjYnsJ7tYqpWpSA3dqIYJKb6pkWpoEZPcAXV6pSyvfeQ5hQTCYCN/vFOvuoRvUkRcC6I+ENuVt1Gb6f0jKt2gOP/hQMB2A4mLpnVxiUlb55hurdWy8JdK0IibFSGE8RRQ/SBJxg8GHRuK4ZbmI1TR1/5gf7lrjsH/iCw1snTzKEtlJaAma8dGmngGxyR2m6jjAtNGjoNxLYVlcJ4ip6jWbD0d/Vbx4duRJGvwSyCdT3gAiuACFJmbug7jCpIif88vQdIflU8FfHE+Od97QEGFIOpV2nM2xFAxrG8kNpnoE7uZ4g24CeHuQu3K4PFX06xzVtUNlEc9oc09hVKfvAqDRU+JkDZJJ2DsaFm3xOMrY4N3tkI6l5hjEWC639zC+mlBgWzqbv9eTUwKpNShQ+jSxtuoDi7iXKScQOA+xCWYsOJ6zYDW/YYP82phXPVm474qH85CjGO9JpsQ4rDmbMU8dq7YwXN0sZYyPKM51aORshtlOTyOHyFPLZycx6ygfHlDzwEfsZHWo4JC0D/opVd3XxFM91nVnU1hzctEpQApFLwWUOFqjnVCAt7C2FTlE8IR6V+eZpQHLcQ1kwBpqig8BRaujAt/WIjl90/+6AA7QEBypmCcKRuKfigfl4Y0XISW6yUcY9eJkgFuhryTyDZ1D1K+DZvqO4BEezWfjtt2rzEtGBLfzfSwik4TV
 N44b+/UL
 8bKQFBRh6RojaWgV3ybQbpxqMXU/Rx08J7Pdwt1SzQNTwZWbGbCI8UvtqrvXVw+BgZ17iNmQMlczaPOb1qlSv8EwXAhtFrx6mHRA+SLQ/TXj8en/rrLjwi4OTYsiVw/E8pbwnaCYdBwTyOfOEUo6rvUiPyXW2A/vPq+g7ojeiSYDribAKKhISow+JPNLz4aeAB+9kLazQOHf2n5TMUYA723oTPACXuxPOUCMVXTCqvOZ8dW8JTVZpQD+6p1Q8AnLxOm4GSjXAuB5uaarQQDAgNSdo2pTxjaaKXJniABW4tDb0D1X9KRJqNtvld5I22Lg0l6sIlBCSslRDVbQWM49ELg9NTH8ij4nMuhECK3Ygpw9In2xI2aLqoE2vD147e1xpILwfmcKsl/7OKJfBooDzsIlsKQ==
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
> Manage per-file user VMs.
>=20
> - VM_CREATE creates a user VM and returns its ID.
> - VM_DESTROY destroys the VM identified by the given ID.
> - VM_BIND maps or unmaps BO ranges in the VM's user VA space.
> - VM_GET_STATE reports whether the VM is usable or unusable.

Same comment as the previous patches

>=20
> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> ---
> drivers/gpu/drm/tyr/driver.rs |  12 +-
> drivers/gpu/drm/tyr/file.rs   | 324 =
++++++++++++++++++++++++++++++++++++++++--
> drivers/gpu/drm/tyr/vm.rs     |  24 +++-
> 3 files changed, 346 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/tyr/driver.rs =
b/drivers/gpu/drm/tyr/driver.rs
> index 94bc85635725e..b3145526ada06 100644
> --- a/drivers/gpu/drm/tyr/driver.rs
> +++ b/drivers/gpu/drm/tyr/driver.rs
> @@ -33,7 +33,7 @@
>         Mutex, //
>     },
>     time,
> -    types::CovariantForLt, //
> +    types::ForLt, //
> };
>=20
> use crate::{
> @@ -72,6 +72,9 @@ pub(crate) struct TyrDrmRegistrationData<'drm> {
>     /// Firmware sections.
>     pub(crate) fw: Firmware<'drm>,
>=20
> +    /// Memory management unit for address space slots.
> +    pub(crate) mmu: Arc<Mmu<'drm>>,
> +
>     #[pin]
>     clks: Mutex<Clocks>,
>=20
> @@ -164,6 +167,7 @@ fn probe<'bound>(
>         let reg_data =3D pin_init!(TyrDrmRegistrationData {
>                 pdev,
>                 fw: firmware,
> +                mmu,
>                 clks <- new_mutex!(Clocks {
>                     core: core_clk,
>                     stacks: stacks_clk,
> @@ -207,7 +211,7 @@ fn drop(self: Pin<&mut Self>) {}
> impl drm::Driver for TyrDrmDriver {
>     type Data =3D ();
>     type RegistrationData<'drm> =3D TyrDrmRegistrationData<'drm>;
> -    type File =3D CovariantForLt!(TyrDrmFileData);
> +    type File =3D ForLt!(TyrDrmFileData<'_>);
>     type Object =3D Bo;
>     type ParentDevice<Ctx: DeviceContext> =3D platform::Device<Ctx>;
>=20
> @@ -216,6 +220,10 @@ impl drm::Driver for TyrDrmDriver {
>=20
>     kernel::declare_drm_ioctls! {
>         (PANTHOR_DEV_QUERY, drm_panthor_dev_query, =
ioctl::RENDER_ALLOW, TyrDrmFileData::dev_query),
> +        (PANTHOR_VM_CREATE, drm_panthor_vm_create, =
ioctl::RENDER_ALLOW, TyrDrmFileData::vm_create),
> +        (PANTHOR_VM_DESTROY, drm_panthor_vm_destroy, =
ioctl::RENDER_ALLOW, TyrDrmFileData::vm_destroy),
> +        (PANTHOR_VM_BIND, drm_panthor_vm_bind, ioctl::RENDER_ALLOW, =
TyrDrmFileData::vm_bind),
> +        (PANTHOR_VM_GET_STATE, drm_panthor_vm_get_state, =
ioctl::RENDER_ALLOW, TyrDrmFileData::vm_get_state),
>     }
> }
>=20
> diff --git a/drivers/gpu/drm/tyr/file.rs b/drivers/gpu/drm/tyr/file.rs
> index 933a365cb016e..157bc40e1cac4 100644
> --- a/drivers/gpu/drm/tyr/file.rs
> +++ b/drivers/gpu/drm/tyr/file.rs
> @@ -3,37 +3,70 @@
> use kernel::{
>     drm::{
>         self,
> +        gem::BaseObject,
>         Registered, //
>     },
>     prelude::*,
> -    uaccess::UserSlice,
> +    sizes::SizeConstants,
> +    transmute::FromBytes,
> +    uaccess::{
> +        UserSlice,
> +        UserSliceReader, //
> +    },
>     uapi, //
> };
>=20
> -use crate::driver::{
> -    TyrDrmDevice,
> -    TyrDrmDriver,
> -    TyrDrmRegistrationData, //
> +use crate::{
> +    driver::{
> +        TyrDrmDevice,
> +        TyrDrmDriver,
> +        TyrDrmRegistrationData, //
> +    },
> +    pool::VmPool,
> +    vm::{
> +        UserVaRequest,
> +        Vm,
> +        VmMapFlags,
> +        VmSpec, //
> +    }, //
> };
>=20
> -#[pin_data]
> -pub(crate) struct TyrDrmFileData {}
> +#[pin_data(PinnedDrop)]
> +pub(crate) struct TyrDrmFileData<'a> {
> +    reg: &'a TyrDrmRegistrationData<'a>,
> +
> +    #[pin]
> +    vm_pool: VmPool<'a>,
> +}
>=20
> /// Convenience type alias for our DRM `File` type.
> pub(crate) type TyrDrmFile =3D drm::file::File<TyrDrmDriver>;
>=20
> -impl drm::file::DriverFile<'_> for TyrDrmFileData {
> +impl<'a> drm::file::DriverFile<'a> for TyrDrmFileData<'a> {
>     type Driver =3D TyrDrmDriver;
>=20
>     fn open(
>         _device: &TyrDrmDevice<Registered>,
> -        _reg_data: &TyrDrmRegistrationData<'_>,
> +        reg_data: &'a TyrDrmRegistrationData<'a>,
>     ) -> impl PinInit<Self, Error> {
> -        Ok(Self {})
> +        try_pin_init!(Self {
> +            reg: reg_data,
> +            vm_pool <- VmPool::new()?,
> +        })
>     }
> }
>=20
> -impl TyrDrmFileData {
> +#[pinned_drop]
> +impl PinnedDrop for TyrDrmFileData<'_> {
> +    fn drop(self: Pin<&mut Self>) {
> +        let proj =3D self.project();
> +        while let Some(vm) =3D proj.vm_pool.pop_first() {
> +            vm.kill();
> +        }
> +    }
> +}
> +
> +impl TyrDrmFileData<'_> {
>     pub(crate) fn dev_query(
>         _ddev: &TyrDrmDevice<Registered>,
>         reg_data: &TyrDrmRegistrationData<'_>,
> @@ -65,4 +98,273 @@ pub(crate) fn dev_query(
>             }
>         }
>     }
> +
> +    pub(crate) fn vm_create(
> +        ddev: &TyrDrmDevice<Registered>,
> +        _reg_data: &TyrDrmRegistrationData<'_>,
> +        vmcreate: &mut uapi::drm_panthor_vm_create,
> +        file: &TyrDrmFile,
> +    ) -> Result<u32> {
> +        if vmcreate.flags !=3D 0 {
> +            dev_err!(
> +                ddev.as_ref(),
> +                "Invalid VM create flags: {:#x}\n",
> +                vmcreate.flags
> +            );
> +            return Err(EINVAL);
> +        }
> +
> +        let ret: Result<u32, Error> =3D file.inner_with(|fd| {
> +            let vm =3D Vm::new(
> +                fd.reg.pdev.as_ref(),
> +                ddev,
> +                fd.reg.mmu.as_arc_borrow(),
> +                &fd.reg.gpu_info,
> +                VmSpec::User {
> +                    user_va: =
UserVaRequest::from_uapi(vmcreate.user_va_range),
> +                },
> +            )?;
> +            vmcreate.user_va_range =3D vm.layout.user.end;
> +
> +            let id =3D =
fd.vm_pool.add(vm.as_arc_borrow()).inspect_err(|_| {
> +                vm.kill();
> +            })?;

I think we can improve this, because currently we depend on kill() to =
not leak
resources. I propose the following:

/// The unique right to tear a VM down.
///
/// `Vm::new()` hands one of these back, so a VM is owned from the =
moment it
/// exists and any early return tears it down. Whoever ends up holding =
it (the
/// per-file pool) owns the teardown; everyone else takes an `Arc<Vm>` =
via
/// `VmOwner::get()`, which keeps the object alive but carries no such =
duty.
pub(crate) struct VmOwner<'drm>(Arc<Vm<'drm>>);

impl<'drm> VmOwner<'drm> {
    /// A reference for callers that want to use the VM, not own it.
    pub(crate) fn get(&self) -> Arc<Vm<'drm>> {
        self.0.clone()
    }
}

impl<'drm> core::ops::Deref for VmOwner<'drm> {
    type Target =3D Vm<'drm>;
    fn deref(&self) -> &Vm<'drm> { &self.0 }
}

impl Drop for VmOwner<'_> {
    fn drop(&mut self) {
        self.0.kill();
    }
}

Where Vm::new() would be adapted to return VmOwner, instead of Arc<Vm>, =
so this
API cannot be circumvented. Also, kill() would be changed to private, =
such that
only VmOwner would be able to call it (since it will live in vm.rs).



> +            vmcreate.id =3D id;
> +
> +            Ok(0)
> +        });
> +        ret
> +    }
> +
> +    pub(crate) fn vm_destroy(
> +        ddev: &TyrDrmDevice<Registered>,
> +        _reg_data: &TyrDrmRegistrationData<'_>,
> +        vmdestroy: &mut uapi::drm_panthor_vm_destroy,
> +        file: &TyrDrmFile,
> +    ) -> Result<u32> {
> +        if vmdestroy.pad !=3D 0 {
> +            dev_err!(
> +                ddev.as_ref(),
> +                "Invalid VM destroy pad: {:#x}\n",
> +                vmdestroy.pad
> +            );
> +            return Err(EINVAL);
> +        }
> +
> +        let ret: Result<u32, Error> =3D file.inner_with(|fd| {
> +            let vm =3D fd.vm_pool.remove(vmdestroy.id)?;
> +            vm.kill();
> +            Ok(0)
> +        });
> +        ret
> +    }
> +
> +    pub(crate) fn vm_bind(
> +        ddev: &TyrDrmDevice<Registered>,
> +        _reg_data: &TyrDrmRegistrationData<'_>,
> +        vmbind: &mut uapi::drm_panthor_vm_bind,
> +        file: &TyrDrmFile,
> +    ) -> Result<u32> {
> +        let async_flag =3D =
uapi::drm_panthor_vm_bind_flags_DRM_PANTHOR_VM_BIND_ASYNC;
> +
> +        if vmbind.flags & !async_flag !=3D 0 {
> +            dev_err!(
> +                ddev.as_ref(),
> +                "Invalid VM_BIND flags: {:#x}\n",
> +                vmbind.flags
> +            );
> +            return Err(EINVAL);
> +        }
> +
> +        if vmbind.flags & async_flag !=3D 0 {
> +            dev_err!(ddev.as_ref(), "Async VM_BIND not supported\n");
> +            return Err(ENOTSUPP);
> +        }
> +
> +        let count =3D vmbind.ops.count as usize;
> +        if count =3D=3D 0 {
> +            return Ok(0);
> +        }
> +
> +        let size_of_op =3D size_of::<VmBindOp>();
> +        // Stride versions the UAPI struct: reject only undersized =
strides.
> +        if size_of_op > vmbind.ops.stride as usize {
> +            dev_err!(
> +                ddev.as_ref(),
> +                "Invalid VM_BIND op stride {}\n",
> +                vmbind.ops.stride
> +            );
> +            return Err(EINVAL);
> +        }
> +        let stride =3D vmbind.ops.stride as usize;
> +
> +        let total_len =3D stride.checked_mul(count).ok_or_else(|| {
> +            dev_err!(ddev.as_ref(), "VM_BIND ops length overflow\n");
> +            EINVAL
> +        })?;
> +        let mut reader =3D
> +            UserSlice::new(UserPtr::from_addr(vmbind.ops.array as =
usize), total_len).reader();
> +        let mut ops =3D KVec::new();
> +        for _ in 0..count {
> +            ops.push(reader.read::<VmBindOp>()?, GFP_KERNEL)?;
> +            read_padding_zero(&mut reader, stride - size_of_op)?;
> +        }
> +
> +        let ret: Result<u32, Error> =3D file.inner_with(|fd| {
> +            let vm =3D fd.vm_pool.get(vmbind.vm_id).ok_or_else(|| {
> +                dev_err!(ddev.as_ref(), "Invalid VM_BIND vm_id: =
{}\n", vmbind.vm_id);
> +                EINVAL
> +            })?;
> +
> +            for (i, op) in ops.iter().enumerate() {
> +                if let Err(e) =3D vm_bind_exec_op(&vm, file, op) {
> +                    dev_dbg!(ddev.as_ref(), "VM_BIND op {} failed: =
{:?}\n", i, e);
> +                    vmbind.ops.count =3D i as u32;
> +                    return Err(e);
> +                }
> +            }
> +
> +            Ok(0)
> +        });
> +        ret
> +    }
> +
> +    pub(crate) fn vm_get_state(
> +        ddev: &TyrDrmDevice<Registered>,
> +        _reg_data: &TyrDrmRegistrationData<'_>,
> +        vmgetstate: &mut uapi::drm_panthor_vm_get_state,
> +        file: &TyrDrmFile,
> +    ) -> Result<u32> {
> +        file.inner_with(|fd| {
> +            let vm =3D fd.vm_pool.get(vmgetstate.vm_id).ok_or_else(|| =
{
> +                dev_err!(
> +                    ddev.as_ref(),
> +                    "Invalid VM_GET_STATE vm_id: {}\n",
> +                    vmgetstate.vm_id
> +                );
> +                EINVAL
> +            })?;
> +            vmgetstate.state =3D if vm.is_unusable() {
> +                =
uapi::drm_panthor_vm_state_DRM_PANTHOR_VM_STATE_UNUSABLE
> +            } else {
> +                =
uapi::drm_panthor_vm_state_DRM_PANTHOR_VM_STATE_USABLE
> +            };
> +            Ok(0)
> +        })
> +    }
> +}
> +
> +fn vm_bind_exec_op(vm: &Vm<'_>, file: &TyrDrmFile, op: &VmBindOp) -> =
Result {
> +    if vm.is_unusable() {
> +        dev_err!(vm.dev(), "VM_BIND on destroyed VM\n");
> +        return Err(EINVAL);
> +    }
> +
> +    if op.size =3D=3D 0 {
> +        return Ok(());
> +    }
> +
> +    if op.syncs.count !=3D 0 {
> +        dev_err!(vm.dev(), "VM_BIND op syncs not supported\n");
> +        return Err(EINVAL);
> +    }
> +
> +    let end =3D match op.va.checked_add(op.size) {
> +        Some(end) =3D> end,
> +        None =3D> {
> +            dev_err!(vm.dev(), "VM_BIND op VA range overflow\n");
> +            return Err(EINVAL);
> +        }
> +    };
> +    if op.va < vm.layout.user.start || end > vm.layout.user.end {
> +        dev_err!(
> +            vm.dev(),
> +            "VM_BIND op VA range {:#x}..{:#x} outside user range\n",
> +            op.va,
> +            end
> +        );
> +        return Err(EINVAL);
> +    }
> +
> +    if (op.va | op.size | op.bo_offset) & (u64::SZ_4K - 1) !=3D 0 {
> +        dev_err!(vm.dev(), "VM_BIND op not GPU-page-aligned\n");
> +        return Err(EINVAL);
> +    }
> +
> +    const TYPE_MASK: u32 =3D
> +        =
uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_MASK as =
u32;
> +    const TYPE_MAP: u32 =3D =
uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_MAP as =
u32;
> +    const TYPE_UNMAP: u32 =3D
> +        =
uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_UNMAP as =
u32;

How about:

/// Operation type, packed into the top nibble of
/// `drm_panthor_vm_bind_op::flags`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(crate) enum VmBindOpType {
    /// Map a BO range into the VM.
    Map,
    /// Unmap a VA range.
    Unmap,
}

impl TryFrom<u32> for VmBindOpType {
    type Error =3D Error;

    fn try_from(flags: u32) -> Result<Self, Self::Error> {
        const MAP: u32 =3D =
uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_MAP as =
u32;
        const UNMAP: u32 =3D
            =
uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_UNMAP as =
u32;

        match flags & Self::MASK {
            MAP =3D> Ok(Self::Map),
            UNMAP =3D> Ok(Self::Unmap),
            _ =3D> Err(EINVAL),
        }
    }
}

impl VmBindOpType {
    /// Bits occupied by the op type in `drm_panthor_vm_bind_op::flags`.
    pub(crate) const MASK: u32 =3D
        =
uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_MASK as =
u32;
}

> +
> +    match op.flags & TYPE_MASK {
> +        TYPE_MAP =3D> {
> +            let map_flags =3D match VmMapFlags::try_from(op.flags & =
!TYPE_MASK) {
> +                Ok(flags) =3D> flags,
> +                Err(_) =3D> {
> +                    dev_err!(vm.dev(), "VM_BIND op invalid map flags =
{:#x}\n", op.flags);
> +                    return Err(EINVAL);
> +                }
> +            };
> +            let bo =3D crate::gem::lookup_handle(file, =
op.bo_handle).map_err(|_| {
> +                dev_err!(vm.dev(), "VM_BIND op invalid BO handle =
{}\n", op.bo_handle);
> +                EINVAL
> +            })?;
> +            // Validate the BO window before mapping.
> +            let bo_size =3D bo.size() as u64;
> +            if op.size > bo_size || op.bo_offset > bo_size - op.size =
{
> +                dev_err!(vm.dev(), "VM_BIND op BO range out of =
bounds\n");
> +                return Err(EINVAL);
> +            }
> +            vm.map_bo_range(&bo, op.bo_offset, op.size, op.va, =
map_flags)
> +        }
> +        TYPE_UNMAP =3D> {
> +            // Unmap must not carry map-specific flags or BO =
references.
> +            if op.flags & !TYPE_MASK !=3D 0 || op.bo_handle !=3D 0 || =
op.bo_offset !=3D 0 {
> +                dev_err!(
> +                    vm.dev(),
> +                    "VM_BIND UNMAP carries flags/BO refs: flags=3D{:#x}=
 bo_handle=3D{} bo_offset=3D{}\n",
> +                    op.flags,
> +                    op.bo_handle,
> +                    op.bo_offset
> +                );
> +                return Err(EINVAL);
> +            }
> +            vm.unmap_range(op.va, op.size)
> +        }
> +        _ =3D> {
> +            dev_err!(vm.dev(), "VM_BIND op type {:#x} not =
supported\n", op.flags);
> +            Err(EINVAL)
> +        }
> +    }
> }
> +
> +/// Reads `len` bytes of array padding, rejecting any nonzero byte =
with `E2BIG`.
> +fn read_padding_zero(reader: &mut UserSliceReader, len: usize) -> =
Result {
> +    let mut buf =3D [0u8; 64];
> +    let mut remaining =3D len;
> +    while remaining > 0 {
> +        let chunk =3D remaining.min(buf.len());
> +        reader.read_slice(&mut buf[..chunk])?;
> +        if buf[..chunk].iter().any(|&b| b !=3D 0) {
> +            return Err(E2BIG);
> +        }
> +        remaining -=3D chunk;
> +    }
> +    Ok(())
> +}
> +
> +#[repr(transparent)]
> +struct VmBindOp(uapi::drm_panthor_vm_bind_op);
> +
> +impl core::ops::Deref for VmBindOp {
> +    type Target =3D uapi::drm_panthor_vm_bind_op;
> +
> +    fn deref(&self) -> &Self::Target {
> +        &self.0
> +    }
> +}
> +
> +// SAFETY: `VmBindOp` contains only integers, so any bit pattern is =
valid;
> +// the `#[repr(transparent)]` wrapper has the same layout as the UAPI =
struct.
> +unsafe impl FromBytes for VmBindOp {}
> diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
> index 76c3d60bb2fe2..610bab69c1a55 100644
> --- a/drivers/gpu/drm/tyr/vm.rs
> +++ b/drivers/gpu/drm/tyr/vm.rs
> @@ -10,6 +10,10 @@
> use core::marker::PhantomData;
> use core::num::NonZeroU64;
> use core::ops::Range;
> +use core::sync::atomic::{
> +    AtomicBool,
> +    Ordering, //
> +};
>=20
> use kernel::{
>     device::{
> @@ -437,6 +441,8 @@ pub(crate) struct Vm<'drm> {
>     gpuvm: ARef<GpuVm<GpuVmData<'drm>>>,
>     /// VA layout for this VM.
>     pub(crate) layout: VmLayout,
> +    /// Whether the VM is unusable.
> +    unusable: AtomicBool,

Atomic<bool>

> }
>=20
> impl<'drm> Vm<'drm> {
> @@ -496,6 +502,7 @@ pub(crate) fn new(
>                 gpuvm,
>                 gpuvm_unique <- new_mutex!(gpuvm_unique),
>                 layout,
> +                unusable: AtomicBool::new(false),
>             }),
>             GFP_KERNEL,
>         )?;
> @@ -526,7 +533,7 @@ fn deactivate(&self) -> Result {
>=20
>     /// Kills the VM by deactivating it and unmapping all regions.
>     pub(crate) fn kill(&self) {
> -        // TODO: Turn the VM into a state where it can't be used.
> +        self.mark_unusable();
>         let _ =3D self.deactivate();
>         let _ =3D self
>             .unmap_range(
> @@ -538,6 +545,15 @@ pub(crate) fn kill(&self) {
>             });
>     }
>=20
> +    /// Marks the VM unusable.
> +    pub(crate) fn mark_unusable(&self) {
> +        self.unusable.store(true, Ordering::Release);
> +    }
> +
> +    pub(crate) fn is_unusable(&self) -> bool {
> +        self.unusable.load(Ordering::Acquire)
> +    }
> +
>     /// Executes a virtual memory operation.
>     ///
>     /// This handles both map and unmap operations by coordinating =
between the
> @@ -649,6 +665,12 @@ pub(crate) fn map_bo_range(
>         };
>         let result =3D {
>             let mut gpuvm_unique =3D self.gpuvm_unique.lock();
> +            // Check under the GPUVM lock so a concurrent =
`mark_unusable()`
> +            // teardown cannot race with this operation.
> +            if self.is_unusable() {
> +                dev_err!(self.dev, "Cannot map on unusable VM\n");

Can you improve the wording a bit on these messages?

> +                return Err(EINVAL);
> +            }
>             self.exec_op(gpuvm_unique.as_mut().get_mut(), req, &mut =
resources)
>         };
>         // We flush the defer cleanup list now. Things will be =
different in
>=20
> --=20
> 2.43.0
>=20
>=20


