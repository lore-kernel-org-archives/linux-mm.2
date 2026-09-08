Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A95C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00E466B0098; Tue,  8 Sep 2026 10:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01986B0099; Tue,  8 Sep 2026 10:25:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E153A6B009B; Tue,  8 Sep 2026 10:25:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C07FD6B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:25:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5DC881A0735
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:25:22 +0000 (UTC)
X-FDA: 85190817684.23.63FEEDE
Received: from mta0.migadu.com (out-92.mta0.migadu.com [91.218.175.92])
	by imf02.hostedemail.com (Postfix) with ESMTP id D35A080012
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:25:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BLHTkZWw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of alvin.sun@linux.dev designates 91.218.175.92 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788877520;
	b=jl3D/YKDtYJVhZiCv0qCklevJzc73DDkDCaCZYen6urWN/mo14n4Why5mvtStsmMbjP4Ba
	vmyJp30ZiX4atXbd98NEli2j/voVnfVP1dzn76yiC96alcfQ/27uO5GtqoY7ApWjyV3kPJ
	mO+3/ArVnZBF5IR6CrH3iVxEvspEAxs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BLHTkZWw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of alvin.sun@linux.dev designates 91.218.175.92 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788877520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qokz/QcV8DzkxVx83Y6c5zpNsWPK5pLg6OumoBI4uHE=;
	b=Yv/CkP3zedSs/g/MgauG8tZ7WNeV52bQjQBNxgnwqxE9obZTtdkhz6vZCcpBHLyC45hGzn
	EPBZ0M/uJga0MO1DesRXg2JWUD9MhoR2a/tuyvJWpxPQ8DbKpeTXgiBIxr3Q9RK65vxoOx
	+aDbLxm941qOqa8sZNCcVmshluLhPU0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lB6ADInmwINs9qRDDS5D7SYp9+41Judvy+epNhkXocs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788877517; v=1; x=1789482317;
 b=BLHTkZWwAZnMFO/Ffsr6aTHz9ppgqAFccjizxrvZ8R0VjfJOVpULT+KUAGGUwRN0Pbaby88J
 eBq1d6as6h0pGO351r7455XjQTGfQxexFO+MFUVlFF+ju2/W8Vjgyorz/Ack1FrRqD8dvqdVK98
 sJGeycY2cGzbD19Pu4SVDvns=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a2bb85ab9f24cd7b;
	Tue, 08 Sep 2026 14:25:16 +0000
X-Mizu-Trace-ID: a2bb85ab9f24cd7b
X-Migadu-Flow: FLOW_OUT
Message-ID: <cbe03927-afdb-4558-9196-e57d899b8d01@linux.dev>
Date: Tue, 8 Sep 2026 22:24:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 9/9] drm/tyr: add BO-related ioctls
To: Daniel Almeida <daniel.almeida@collabora.com>, sunke@kylinos.cn
Cc: rust-for-linux@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, Tamir Duberstein <tamird@kernel.org>,
 Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?=
 <work@onurozkan.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lyude Paul <lyude@redhat.com>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
 <20260902-tyr-ioctls-v1-9-e0fdbf8bd108@kylinos.cn>
 <FDEDAB25-FBF2-438C-9C1C-F72DC851E88C@collabora.com>
From: Alvin Sun <alvin.sun@linux.dev>
In-Reply-To: <FDEDAB25-FBF2-438C-9C1C-F72DC851E88C@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D35A080012
X-Stat-Signature: ky81f1sjc61ihdt331w5szg9nqefsgdo
X-HE-Tag: 1788877519-104346
X-HE-Meta: U2FsdGVkX18Ii/jnWBqw06iBSAy1G8KdQ0jt2ppovdQm+3i3Xi8HMjX8Tf5TzuVvn7NfB8V4cYWws/dtUK5BLGp6UPfTyg+nONsi2TXm5SvxF49qvh+WQD+nwdiqImhMsny3r1VYPPDC87dIg9yn0Y/rtYTD/tchKhVyax0Z7/XojHcjX5s4YHDJXDuxTNCjWP1L8NuyJTa+MbhVp6V+2qTS+QC7eWT96P+u4rA0DgXesNneZ14uPt0wrfW36fMP9R7uYv9+iAUL3CMrJGyUhhcN+xuzFjW3C5++jw5ZjzQTEM7S02uTBuyI7D35aaQjvImp9FTrHXN1Qv1U3J7M1UJXmOi/B/6oAECWbv1Iq1E0WeGSpuqM/2AmQAmToBIGKF6yvr0uP2D1DoCTXmOfElDWEcTNleBPUheDuFB9WmiwlZ11y4a57oBtMFvbXrP5TsLJmnQ3EIEA4qImTh/y0vunuTJXBclzwO1Xuzp5fDXfmqNyI6Bj1afxr+4rDIfEfJo/o7MiMY/v9DtncxhAY9TMV79JqKBiY2klb3yVObwFP4Jj8impjvF9jH1IoRW0Djvzb8XDbAL9/PtEIX4by/dZfZxUhB56XjUbCNMbO6KeqaX2YAk6z02t6Cp3xaucUsfazHMEowVOl2IR7rgpKKfI0a4ReoFJ1fvzCfkAc/SCbDbQFgZXSZ65TGHJN2rJDH2XsTh7FMMpt+FAT3GzusvTu3twcSIi2dEGkcqsdI1ajzCIvqhxjUJEMonKYofKnwdY1P33vSfs2Vh2/MGRQ+1QPhbggUR1ALol7mNl9+zY4V4l7M5yE/+IYV+Q5L+2xXR4KCoeDvNPlJGWv2q1N3QZIF5Vxf/ZLiQNRGnhTHtZucd0jPQj6KCJLbZDA+/2c+RT3+KIXTIiCABwn6MpDExpcOvq8uO5Hprgd/5wnEstPmfmJs1Q7y13ehQ4sI4PX7G0TxhR+X+6ESYZfen
 aXTZHiFk
 JUfk51xdA2Wstngr17arMWACPCpur2s7yScH5cr1ff5Qt0SDw/olWONsJwYjZjuVlmLfEvVBucehcg2c9zG4v8+L9uMkdHoRaM6214a4wCC02sPxcfzHepyl2Efi6/g5Vv2ayreqw+0cOww5lBVZ6QETMZxrPBSOdKeGUC9/OgDFrtwoFHng17tvqtxEmd0SOQmc0WAO2sa0H2rpOQoOMJrqjPULLJVDcAAwNacuRxyCBwX3oJZAt1Nxkl7Ykb5QBViyZOfRBat/0XWjxGg7O3J74C3Ayd3kkPf0/pnIG657lJt66haspxDJTY8dBuduH1n5B2nXVrodEivhnbZUvTgmjuLCQxGkn4mZqVm5YaPEh8nsW2uXkq4Fzh3Hb+rrh7ziL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/5/26 04:35, Daniel Almeida wrote:
>
>> On 1 Sep 2026, at 13:09, Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org> wrote:
>>
>> From: Alvin Sun <alvin.sun@linux.dev>
>>
>> Expose buffer creation and BO mmap offset retrieval.
>>
>> - BO_CREATE page-aligns the size and returns a handle with
>>   write-combined mapping.
>> - BO_MMAP_OFFSET provides the offset for the DRM generic mmap
>>   path, rejecting NO_MMAP objects and non-zero pad.
>>
>> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> Same comment as the previous patches, please write a few
> more things here about why the changes are needed.
>
> With that addressed,
>
> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>

Hi Daniel,

Thanks for the review — your comments on patches 7 and 9 (the 
conditional Reviewed-bys) are addressed in v2:

https://lore.kernel.org/all/20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn

Best regards,
Alvin


>
>> ---
>> drivers/gpu/drm/tyr/driver.rs |  2 ++
>> drivers/gpu/drm/tyr/file.rs   | 70 +++++++++++++++++++++++++++++++++++++++++++
>> drivers/gpu/drm/tyr/gem.rs    |  7 +++++
>> 3 files changed, 79 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
>> index b3145526ada06..fc8d11c9ba1ca 100644
>> --- a/drivers/gpu/drm/tyr/driver.rs
>> +++ b/drivers/gpu/drm/tyr/driver.rs
>> @@ -224,6 +224,8 @@ impl drm::Driver for TyrDrmDriver {
>>          (PANTHOR_VM_DESTROY, drm_panthor_vm_destroy, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_destroy),
>>          (PANTHOR_VM_BIND, drm_panthor_vm_bind, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_bind),
>>          (PANTHOR_VM_GET_STATE, drm_panthor_vm_get_state, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_get_state),
>> +        (PANTHOR_BO_CREATE, drm_panthor_bo_create, ioctl::RENDER_ALLOW, TyrDrmFileData::bo_create),
>> +        (PANTHOR_BO_MMAP_OFFSET, drm_panthor_bo_mmap_offset, ioctl::RENDER_ALLOW, TyrDrmFileData::bo_mmap_offset),
>>      }
>> }
>>
>> diff --git a/drivers/gpu/drm/tyr/file.rs b/drivers/gpu/drm/tyr/file.rs
>> index 157bc40e1cac4..16abf2968299c 100644
>> --- a/drivers/gpu/drm/tyr/file.rs
>> +++ b/drivers/gpu/drm/tyr/file.rs
>> @@ -252,6 +252,76 @@ pub(crate) fn vm_get_state(
>>              Ok(0)
>>          })
>>      }
>> +
>> +    pub(crate) fn bo_create(
>> +        ddev: &TyrDrmDevice<Registered>,
>> +        _reg_data: &TyrDrmRegistrationData<'_>,
>> +        bocreate: &mut uapi::drm_panthor_bo_create,
>> +        file: &TyrDrmFile,
>> +    ) -> Result<u32> {
>> +        if bocreate.size == 0
>> +            || bocreate.pad != 0
>> +            || bocreate.flags & !uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_NO_MMAP != 0
>> +            || bocreate.exclusive_vm_id != 0
>> +        {
>> +            dev_err!(
>> +                ddev.as_ref(),
>> +                "Invalid BO_CREATE params: size={}, pad={}, flags={:#x}, exclusive_vm_id={}\n",
>> +                bocreate.size,
>> +                bocreate.pad,
>> +                bocreate.flags,
>> +                bocreate.exclusive_vm_id
>> +            );
>> +            return Err(EINVAL);
>> +        }
>> +
>> +        let size = usize::try_from(bocreate.size).map_err(|_| {
>> +            dev_err!(
>> +                ddev.as_ref(),
>> +                "BO_CREATE size {:#x} too large\n",
>> +                bocreate.size
>> +            );
>> +            EINVAL
>> +        })?;
>> +        let bo = crate::gem::new_object(ddev, size, bocreate.flags)?;
>> +        bocreate.handle = bo.create_handle(file)?;
>> +        bocreate.size = bo.size() as u64;
>> +
>> +        Ok(0)
>> +    }
>> +
>> +    pub(crate) fn bo_mmap_offset(
>> +        ddev: &TyrDrmDevice<Registered>,
>> +        _reg_data: &TyrDrmRegistrationData<'_>,
>> +        bommap: &mut uapi::drm_panthor_bo_mmap_offset,
>> +        file: &TyrDrmFile,
>> +    ) -> Result<u32> {
>> +        if bommap.pad != 0 {
>> +            dev_err!(
>> +                ddev.as_ref(),
>> +                "BO mmap offset pad not zero: {}\n",
>> +                bommap.pad
>> +            );
>> +            return Err(EINVAL);
>> +        }
>> +
>> +        let bo = crate::gem::lookup_handle(file, bommap.handle).inspect_err(|_| {
>> +            dev_err!(ddev.as_ref(), "Invalid BO mmap handle: {}\n", bommap.handle);
>> +        })?;
>> +        if bo.create_flags() & uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_NO_MMAP != 0 {
>> +            dev_err!(ddev.as_ref(), "BO mmap offset on NO_MMAP object\n");
>> +            return Err(EPERM);
>> +        }
>> +        bommap.offset = bo.create_mmap_offset().inspect_err(|_| {
>> +            dev_err!(
>> +                ddev.as_ref(),
>> +                "Failed to create mmap offset for handle {}\n",
>> +                bommap.handle
>> +            );
>> +        })?;
>> +
>> +        Ok(0)
>> +    }
>> }
>>
>> fn vm_bind_exec_op(vm: &Vm<'_>, file: &TyrDrmFile, op: &VmBindOp) -> Result {
>> diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
>> index d9ddcb287f52b..f404139f54f32 100644
>> --- a/drivers/gpu/drm/tyr/gem.rs
>> +++ b/drivers/gpu/drm/tyr/gem.rs
>> @@ -38,6 +38,13 @@ pub(crate) struct BoData {
>>      flags: u32,
>> }
>>
>> +impl BoData {
>> +    /// Returns the flags the BO was created with.
>> +    pub(crate) fn create_flags(&self) -> u32 {
> I would prefer flags() instead of create_flags(), which reads a bit more like a constructor.
>
>> +        self.flags
>> +    }
>> +}
>> +
>> /// Provides a way to pass arguments when creating BoData
>> /// as required by the gem::DriverObject trait.
>> pub(crate) struct BoCreateArgs {
>>
>> -- 
>> 2.43.0
>>
>>
>>

