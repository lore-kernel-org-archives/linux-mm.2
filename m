Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D7FFF60EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBFD36B0096; Tue, 31 Mar 2026 05:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93696B00A0; Tue, 31 Mar 2026 05:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA92D6B00A1; Tue, 31 Mar 2026 05:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8DAA6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:42:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 528D01B902D
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:42:25 +0000 (UTC)
X-FDA: 84605867850.03.EADFEA1
Received: from mail179-37.suw41.mandrillapp.com (mail179-37.suw41.mandrillapp.com [198.2.179.37])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2AC1F180004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:42:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=mandrillapp.com header.s=mte1 header.b=B0ihCzW9;
	dkim=pass header.d=vates.tech header.s=mte1 header.b=0Ot2jyQv;
	spf=pass (imf16.hostedemail.com: domain of bounce-md_30504962.69cb96fd.v1-c29e0e3cd1a3492e896802e2984a8243@bounce.vates.tech designates 198.2.179.37 as permitted sender) smtp.mailfrom=bounce-md_30504962.69cb96fd.v1-c29e0e3cd1a3492e896802e2984a8243@bounce.vates.tech;
	dmarc=pass (policy=none) header.from=vates.tech
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774950143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3QgvblZRN6364QSNdN+5EIl2FiHO33eGJxLYGl+92ks=;
	b=iKX48PwQtlDxtNmidjjvEVNZe1hDw3Wqgc2mdqYxpGIN23oOVEJ0OP65MwGyLZ6nsDGvpb
	KbfN5aDvrl1t1Rmj28hOFLX9l3LbIegGy5EfuBC8RkD0rjSy9vnnkgQbRNseHX8Uhqmu+e
	l4P4WcErODR5puVyvcpUm2dP5cKe8S4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=mandrillapp.com header.s=mte1 header.b=B0ihCzW9;
	dkim=pass header.d=vates.tech header.s=mte1 header.b=0Ot2jyQv;
	spf=pass (imf16.hostedemail.com: domain of bounce-md_30504962.69cb96fd.v1-c29e0e3cd1a3492e896802e2984a8243@bounce.vates.tech designates 198.2.179.37 as permitted sender) smtp.mailfrom=bounce-md_30504962.69cb96fd.v1-c29e0e3cd1a3492e896802e2984a8243@bounce.vates.tech;
	dmarc=pass (policy=none) header.from=vates.tech
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774950143; a=rsa-sha256;
	cv=none;
	b=SWJyoyIQjJ47Y7z4r3MeciAmmy2gUcnAufXYZD/YnprDxt6I/gSKFHxhFSu8Z1NXeBpKg3
	NkzWzJkKLkLyl2ci6C/xAUcye9B793PwkJ54oUGVa3jJdoo50gpIz5TUEqe7N+0gO32gf2
	KGg8Brhtwdvo7zjHWVEZXKDfUPxWBU4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1774950142; x=1775220142;
	bh=3QgvblZRN6364QSNdN+5EIl2FiHO33eGJxLYGl+92ks=;
	h=From:Subject:Message-Id:To:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=B0ihCzW9FPhO6hnV40y2eS1TNUiqQwdoVl/MqAGoTmEsromi3BhfWC3DXP0uvNLnF
	 C64CS3O2QShKZRRSaE7hYLA5SaCPPtuIYIrNSe4g6x7H8QFP8ttI+lsX8Mks/rCsm6
	 FXF2pMh0iAqmx/19jCXH3dtcjrdtHo+yZaaAInJ1uKGVaQu7sU5i1lykJUm8mE2vKu
	 FgPamq9SBVoRJK/hlb9427Z28Kt5C289+4kHenbprTgT+wrHSBVG7n1tGgzPytDaCR
	 HiVhzVHIVt+LuJkjz/GaOLVqxYSsCH9MREArlCxZv2Lx8TH+AQx/3IyPRcXZjgit0V
	 RS9HLfeiB5wGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1774950142; x=1775210642; i=teddy.astie@vates.tech;
	bh=3QgvblZRN6364QSNdN+5EIl2FiHO33eGJxLYGl+92ks=;
	h=From:Subject:Message-Id:To:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=0Ot2jyQvrXWCzcJb+Eh9Mo6B5p7Ia1UDzrdnxAARfcZzyZSkDk68uBc5Asea7RkN9
	 QM+4d7qDygBsVyRlqmTT+uQmE4R3/3QsqMLEmV36WU3H753FfUMlWDZyGPV+Tac/MY
	 qxCgtDvS+enreE6fT6HEe5kT8FmfWESuJaA1+ZqPF/JijKT6uWf0QXfds3xuMz/0sM
	 9h7p1MqpaZD5QAI/mQtLGKITGLOalcZtUHB5/+m7QWiO8mx2dRBlWOzMnQXYmQV8Ez
	 XzQIyMPK2c56zCw4P6Iq77NnaAtmV2IEWgq+6cKccGBjjPxkAg3hd1oOvPQHvRwhSo
	 +pWJw5hbSPs5w==
Received: from pmta12.mandrill.prod.suw01.rsglab.com (localhost [127.0.0.1])
	by mail179-37.suw41.mandrillapp.com (Mailchimp) with ESMTP id 4flNSZ07vvzG0CBMb
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:42:22 +0000 (GMT)
From: "Teddy Astie" <teddy.astie@vates.tech>
Subject: =?utf-8?Q?Re:=20Why=20memory=20lending=20is=20needed=20for=20GPU=20acceleration?=
Received: from [37.26.189.201] by mandrillapp.com id c29e0e3cd1a3492e896802e2984a8243; Tue, 31 Mar 2026 09:42:21 +0000
X-Bm-Disclaimer: Yes
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1774950140736
Message-Id: <1de15ce0-9f7e-4253-80a7-ecd94caa4325@vates.tech>
To: "Val Packett" <val@invisiblethingslab.com>, "Demi Marie Obenour" <demiobenour@gmail.com>, "Xen developer discussion" <xen-devel@lists.xenproject.org>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, "Ariadne Conill" <ariadne@ariadne.space>
References: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com> <c38387fe-beef-4f50-b928-74f96b881b7a@gmail.com> <0bbf0349-1006-485f-a2db-6c8b795b4242@invisiblethingslab.com>
In-Reply-To: <0bbf0349-1006-485f-a2db-6c8b795b4242@invisiblethingslab.com>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.c29e0e3cd1a3492e896802e2984a8243?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20260331:md
Date: Tue, 31 Mar 2026 09:42:21 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2AC1F180004
X-Stat-Signature: 7o68qfdkh3hzerrzxy4ubexcpng7o65j
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774950142-966103
X-HE-Meta: U2FsdGVkX19rXeyXqfvk6n7VUVIYdwjjpYQE324NBAmRT0Fak2XGsDktmMJZ2FYKR56zzpJaBfYBK97Z0awZkEgB3QpWE04APfX7ZLjlBEbDq+GualkK2DEN1mZSAPDTpN75J38/m0Bz3hZKfxYZHbA5yMbIl1+hMIVnCcJmAhCvx16dfdtOdERfFgcrQUX6n4QCSyPt+VsHLUe3u616ihg7ypZcr3luaK2RtQXlgJmuH+xMruZXued2/BtG0fE68rzAzEGKescUNN1CdUl/EhsJ4cmB8gLmX9pMxekF3DiNwJVFITt5wQ5k2OiP5O0PvMidFhZozKfFRp9/E1eXZ0jO+RUXJQQOmUMRo952Gfx0FIHJpGZIT7Zn6S6RhWFk9f6uaFymZmPSWMlHHFS4hefskBexjvZs49jLyKJDI6EH+/DS5Bl4XSxsjZG/9d9uxpuNWF5syZG2P97xzOTVTCZGsYxnyasD6XRhgsbtuZj0GYyPkCy1ZRHepdGcgAUGdriPrCK3FX6Kg4oKRKY7dcs8rltzNgKF46d96Mj1TWRjevMD3vy4d3r0W2P6vWZCekUYj94Y21500HMM4ZnMDNauTA61Fa4EwKVkaKK+JbRqH536Io5BbhE5Sju8xWtMmN+/tLa9P/TQQL6YNzp0E++05pf0NWRk6Hm0VLcPFT0JEpORyjPC6DDBvnDM/SRDo5Un2M3zOJ16LZ2F9y2kQ060kKd+mEjK8Qii2LhFFvb9AfDBuJP5rg9GMszErkydAGE+bBPzLi5tFeRCEUlf9yrfYfECHY7d5PAzM70gvtJ5pm3VoJS/MBN5kHyp1l32gWjIcS+//pCCKd7ujc0s+pihfDbzTVfYhSyavdR5dz28NAurI4IUcK2yWYcECMQMYvtjPOAo3n8C7YEEkdZOUcTX9mMhYWFGVXsoqY0+0buRX9oCA8I4v7gmZ3WsCC9OuG745yLNhSGWUWI16Iv
 7RV35Rqz
 GpQ9XSWrw6tktaqLZ6QN1cktP++Z7Mhr+Ms5yFO7P/6qc809Lo/hqWSGjCukcYBtLfGYZtJUvH86Edhu1BJbUHH/Y5AnunhcJdNhq5smNrmqnwBHn0END57HDNUrqHKkd6VKYA+YpzaxuE+3QW8udBKNkYxkoLlY3ZpNWWSTPha+IpQNSdwiCavL8rabA/2eA4jZ6G7rLTwqHhA6BJYIr7Fdw8SC0SzlrCx/WgbHs/4CMeNvNS6BKIuM4sapQtoPQErVclNUupbTLcY81sVj1ADANnYnsQxL01H4oz3bNjc2XnN5VVHnklpvJoKAFbTgKXFhL0CWPuG8UFXhyfgOSSx0X3rF3DCYBlQ3VjdvCamMtT2ziLoI03vmjeGvDpZakDCBnzVR3+tIwjncehoWHm92ohdClpcTmqazU2B/LfNigXkEHYnWt6bffA+5aiJPACdBbxuWrq+ycJ1A/wovW9QdsB3iL4RkbgZq7XXNxA6CbI4+QmlenqNyrmGdIMCPDykaKrl1UlRR8qrsJunhWalB3MKKwKKOlWgoQqAq8QlhZES/PfIXTxL3MWqjfB1jEIE9+a50NZpUAffppumv2aUxKyvi3PIzScYrKc80v+iIcB3w7elurKkevl86KkoVLZv8JCLnDqt/iKtqz794rdtUmKkcUdDGanvVyNSMF9nE+1nzoy1mCDIbeg7ejiLPaxRiHFJGC7lfv/1ig6GHyU8Jm0L+G0M2ERfl5WdP/bgoHwgsquh2p0CqRhISmBVGkYxdiGr1tZsSCJAwRzH6n1+YhgJtY+IPmc/s8ZlKS+tdvvyvy/93+t2u22InopfwuL4HHvx3ug9TmY9oa61uS3CF2uius+CR6vq/fUpleqTxu7wKSWqRQ0TVa8GJOKOTew1uC7E2d7JEYTWfD3yq9RlgrbVCYqYOVB8Hz8MazTaHEljkh1Cp+QOuIpM5W1PoIVTPtKm57C/rH0OHiEgTg6Dalxm4q
 rrOXXQiK
 OrxYjE9ix6SihklxbUtxYHbTCP18RJidJztQlrS6sCfdtDdfZIuI4yx4CmvtBjCwz1pDXscxJXjCLhj5Zfy5iV/vzlhADDw1Z8oiwvv2l5MHUG1UJPFFmsJYQ/XsDvZ6MV3eOyW0yf0fgnCtGPRoLv/bO49+7glQIAaKVXF/c9V24CnkmQpO+G6evSZ1q+CODncKF3hF5+JHWhJttI5g7JW+3lamVZM06VgNIVUcThxlj1d5mGXXzhZm7uWHGqACUPADJKu0YB/67GSRR1KPRBt7QLz5AYJYa0RKMOyfnF99fdXwkqsKk06/juP3+duDP1I1u+Rd4+CCutPJaIiDmVcSTjIG0MI1pMHHjuDwRu5B+C8D+mONYD2WGYhDvVvF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le 30/03/2026 =C3=A0 22:13, Val Packett a =C3=A9crit=C2=A0:
> Hi,
> 
> On 3/29/26 2:32 PM, Demi Marie Obenour wrote:
>> On 3/24/26 10:17, Demi Marie Obenour wrote:
>>> Here is a proposed design document for supporting mapping GPU VRAM
>>> and/or file-backed memory into other domains.=C2=A0 It's not in the for=
m of
>>> a patch because the leading + characters would just make it harder to
>>> read for no particular gain, and because this is still RFC right now.
>>> Once it is ready to merge, I'll send a proper patch.=C2=A0 Nevertheless=
,
>>> you can consider this to be
>>>
>>> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
>>>
>>> This approach is very different from the "frontend-allocates"
>>> approach used elsewhere in Xen.=C2=A0 It is very much Linux-centric,
>>> rather than Xen-centric.=C2=A0 In fact, MMU notifiers were invented for
>>> KVM, and this approach is exactly the same as the one KVM implements.
>>> However, to the best of my understanding, the design described here is
>>> the only viable one.=C2=A0 Linux MM and GPU drivers require it, and cha=
nges
>>> to either to relax this requirement will not be accepted upstream.
>> Teddy Astie (CCd) proposed a couple of alternatives on Matrix:
>>
>> 1. Create dma-bufs for guest pages and import them into the host.
>>
>> =C2=A0=C2=A0=C2=A0 This is a win not only for Xen, but also for KVM.=C2=
=A0 Right now, shared
>> =C2=A0=C2=A0=C2=A0 (CPU) memory buffers must be copied from the guest to=
 the host,
>> =C2=A0=C2=A0=C2=A0 which is pointless.=C2=A0 So fixing that is a good th=
ing!=C2=A0 That said,
>> =C2=A0=C2=A0=C2=A0 I'm still concerned about triggering GPU driver code-=
paths that
>> =C2=A0=C2=A0=C2=A0 are not tested on bare metal.
> 
> To expand on this: the reason cross-domain Wayland proxies have been 
> doing this SHM copy dance was a deficiency in Linux UAPI. Basically, 
> applications allocate shared memory using local mechanisms like memfd 
> (and good old unlink-of-regular-file, ugh) which weren't compatible with 
> cross-VM sharing. However udmabuf should basically solve it, at least 
> for memfds. (I haven't yet investigated what happens with "unlinked 
> regular files" yet but I don't expect anything good there, welp.)
> 
> But I have landed a patch in Linux that removes a silly restriction that 
> tied dmabuf import into virtgpu to KMS-only mode:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/ 
> commit/?id=3Ddf4dc947c46bb9f80038f52c6e38cb2d40c10e50
> 
> And I have experimented with it and got a KVM-based VMM to successfully 
> access and print guest memfd contents that were passed to the host via 
> this mechanism. (Time to actually properly implement it into the full 
> system..)
> 
>> 2. Use PASID and 2-stage translation so that the GPU can operate in
>> =C2=A0=C2=A0=C2=A0 guest physical memory.
>> =C2=A0=C2=A0=C2=A0 This is also a win.=C2=A0 AMD XDNA absolutely require=
s PASID support,
>> =C2=A0=C2=A0=C2=A0 and apparently AMD GPUs can also use PASID.=C2=A0 So =
being able to use
>> =C2=A0=C2=A0=C2=A0 PASID is certainly helpful.
>>
>> However, I don't think either approach is sufficient for two reasons.
>>
>> First, discrete GPUs have dedicated VRAM, which Xen knows nothing about.
>> Only dom0's GPU drivers can manage VRAM, and they will insist on being
>> able to migrate it between the CPU and the GPU.=C2=A0 Furthermore, VRAM
>> can only be allocated using GPU driver ioctls, which will allocate
>> it from dom0-owned memory.
>>
>> Second, Certain Wayland protocols, such as screencapture, require 
>> programs
>> to be able to import dmabufs.=C2=A0 Both of the above solutions would
>> require that the pages be pinned.=C2=A0 I don't think this is an option,
>> as IIUC pin_user_pages() fails on mappings of these dmabufs.=C2=A0 It's =
why
>> direct I/O to dmabufs doesn't work.
>>
>> To the best of my knowledge, these problems mean that lending memory
>> is the only way to get robust GPU acceleration for both graphics and
>> compute workloads under Xen.=C2=A0 Simpler approaches might work for pur=
e
>> compute workloads, for iGPUs, or for drivers that have Xen-specific
>> changes.=C2=A0 None of them, however, support graphics workloads on dGPU=
s
>> while using the GPU driver the same way bare metal workloads do.
>> [=E2=80=A6]
> To recap, how virtio-gpu Host3d memory currently works with KVM is:
> 
> - the VMM/virtgpu receives a dmabuf over a socket (Wayland/D-Bus/ 
> whatever) and registers it internally with some resource ID that's 
> passed to the guest;
> - When the guest imports that resource, it calls 
> VIRTIO_GPU_CMD_RESOURCE_MAP_BLOB to get a PRIME buffer that can be 
> turned into a dmabuf fd;
> - the VMM's handler for VIRTIO_GPU_CMD_RESOURCE_MAP_BLOB (referencing 
> libkrun here) literally just calls mmap() on the host dmabuf, using the 
> MAP_FIXED flag to place it correctly inside of the VMM process's guest- 
> exposed VA region (configured via KVM_SET_USER_MEMORY_REGION);
> - so any resource imported by the guest, even before guest userspace 
> does mmap(), is mapped (as VM_PFNMAP|VM_IO) until the guest releases it.
> 
> So the generic kernel MM is out of the way, these mappings can't be 
> paged out to swap etc. But accessing them may fault, as the comment for 
> drm_gem_mmap_obj says:
> 
>  =C2=A0* Depending on their requirements, GEM objects can either
>  =C2=A0* provide a fault handler in their vm_ops (in which case any acces=
ses to
>  =C2=A0* the object will be trapped, to perform migration, GTT binding, s=
urface
>  =C2=A0* register allocation, or performance monitoring), or mmap the buf=
fer 
> memory
>  =C2=A0* synchronously after calling drm_gem_mmap_obj
> 
> It all "just works" in KVM because KVM's resolution of the guest's 
> memory accesses tries to be literally equivalent to what's mapped into 
> the userspace VMM process: hva_to_pfn_remapped explicitly calls 
> fixup_user_fault and eventually gets to the GPU driver's fault handler.
> 
> Now for Xen this would be=E2=80=A6 painful,
> 

indeed

> but,
> 
> we have no need to replicate what KVM does. That's far from the only 
> thing that can be done with a dmabuf.
> 
> The import-export machinery on the other hand actually does pin the 
> buffers on the driver level, importers are not obligated to support 
> movable buffers (move_notify in dma_buf_attach_ops=C2=A0is entirely optio=
nal).
> 

dma-buf is by concept non-movable if actively used (otherwise, it would 
break DMA). It's just a foreign buffer, and from device standpoint, just 
plain RAM that needs to be mapped.

> Interestingly, there is already XEN_GNTDEV_DMABUF=E2=80=A6
> 
> Wait, do we even have any reason at all to suspect 
> that=C2=A0XEN_GNTDEV_DMABUF doesn't already satisfy all of our buffer-sha=
ring 
> requirements?
> 

XEN_GNTDEV_DMABUF has been designed for GPU use-cases, and more 
precisely for paravirtualizing a display. The only issue I would have 
with it is that grants are not scalable for GPU 3D use cases (with 
hundreds of MB to share).
But we can still keep the concept of a structured guest-owned memory 
that is shared with Dom0 (but for larger quantities), I have some ideas 
regarding improving that area in Xen.

The only issue with changing the memory sharing model is that you would 
need to adjust the virtio-gpu aspect, but the rest can stay the same.

The biggest concern regarding driver compatibility is more about :
- can dma-buf be used as general buffers : probably yes (even with 
OpenGL/Vulkan); exception may be proprietary Nvidia drivers that lacks 
the feature; maybe very old hardware may struggle more with it
- can guest UMD work without access to vram : yes (apparently), AMDGPU 
has a special case where VRAM is not visible (e.g too small PCI BAR), 
there is vram size vs "vram visible size" (which could be 0); you could 
fallback vram-guest-visible with ram mapped on device
- can it be defined in Vulkan terms (from driver) : You can have 
device_local memory without having it host-visible (i.e memory exists, 
but can't be added in the guest). You would probably just lose some 
zero-copy paths with VRAM. Though you still have RAM shared with GPU 
(GTT in AMDGPU) if that matters.

Worth noting that if you're on integration graphics, you don't have VRAM 
and everything is RAM anyway.

> 
> Thanks,
> ~val
> 
> P.S. while I have everyone's attention, can I get some eyes on:
> https://lore.kernel.org/all/20251126062124.117425-1- 
> val@invisiblethingslab.com/ ?
> 
> 



--
Teddy Astie | Vates XCP-ng Developer

XCP-ng & Xen Orchestra - Vates solutions

web: https://vates.tech



