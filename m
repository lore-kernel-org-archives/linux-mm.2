Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0FEC10A88FD
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337926B008A; Thu, 26 Mar 2026 14:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8796B008C; Thu, 26 Mar 2026 14:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FDFC6B0092; Thu, 26 Mar 2026 14:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E72C6B008A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:26:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CAF1A1B95AB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:26:52 +0000 (UTC)
X-FDA: 84589045464.16.9815DBC
Received: from mail132-14.atl131.mandrillapp.com (mail132-14.atl131.mandrillapp.com [198.2.132.14])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5C69DC000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:26:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=mandrillapp.com header.s=mte1 header.b=vEsv4QQs;
	dkim=pass header.d=vates.tech header.s=mte1 header.b="l8JHY/Te";
	dmarc=pass (policy=none) header.from=vates.tech;
	spf=pass (imf22.hostedemail.com: domain of bounce-md_30504962.69c57a69.v1-24dd957112574930804b1ad5f7d29c91@bounce.vates.tech designates 198.2.132.14 as permitted sender) smtp.mailfrom=bounce-md_30504962.69c57a69.v1-24dd957112574930804b1ad5f7d29c91@bounce.vates.tech
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774549610; a=rsa-sha256;
	cv=none;
	b=YU4za+5iU2shX1wZysfvYSpD/+kRPdWtMtbElZ264Xb65+ibVRLehJaU4zt2mmezkouV4x
	KBEkjfUN3CBY4RjG04lv4PNtyKojTfj5Ycu/8bdrZQ7KCtCN9ogXDbOU0eMYZEdhA8xNAw
	r4vKmlT0JO7lax2DiSQsxB3+S5CJI7Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=mandrillapp.com header.s=mte1 header.b=vEsv4QQs;
	dkim=pass header.d=vates.tech header.s=mte1 header.b="l8JHY/Te";
	dmarc=pass (policy=none) header.from=vates.tech;
	spf=pass (imf22.hostedemail.com: domain of bounce-md_30504962.69c57a69.v1-24dd957112574930804b1ad5f7d29c91@bounce.vates.tech designates 198.2.132.14 as permitted sender) smtp.mailfrom=bounce-md_30504962.69c57a69.v1-24dd957112574930804b1ad5f7d29c91@bounce.vates.tech
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774549610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AD6XtpInmedqkHt3lklQZZmmP5HZmKfK2sFPcPiL8Q=;
	b=dTTNMO3B8AYaQIDjSakX30G/jDOMO/oHTGpqV6Ca6ZBIiMQhVH2ziLUOWbuJCYWPHBssmV
	jFIoOEKR8+lFAh5xebK99KP85Zt1FW3TSaW1/Fj5fPi4GHpPS5lRwpYNw++jknT+1f99Qh
	dx3jmNAf+mHPcTA4pZcCyIF68cyl7As=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1774549609; x=1774819609;
	bh=1AD6XtpInmedqkHt3lklQZZmmP5HZmKfK2sFPcPiL8Q=;
	h=From:Subject:Message-Id:To:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=vEsv4QQsazjAHRM3hDgnHJS/DV6TE2qRjFuL1KhzeJEGCPdaWKlZPr6GPJY8sd6Lw
	 DZbmBwgTTq5yuaPvSCCKPsOI6uX2VDeZ4cIxWKN2g8+e3cQnaHllnigRL447kxoEs6
	 y/YoG1nYUFel6p0+ipkWJz8SeNBs8+HM9Stb+fk9Bog5M6eoUo5e4gPumDYRZbPDgy
	 V1oIXg50UiDsBtspuPVmZwNkXymBPS2yKgqdIrNnE5dRjSFLPIilbAUGnUud8evcBP
	 2kbvHboKx2habjDMpda3HioZuqiWVkllMSer9+izacIc6QWMyYD6orGVNHYpw7ipka
	 /uw4MohVwXkLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1774549609; x=1774810109; i=teddy.astie@vates.tech;
	bh=1AD6XtpInmedqkHt3lklQZZmmP5HZmKfK2sFPcPiL8Q=;
	h=From:Subject:Message-Id:To:References:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=l8JHY/Tea6yBGHD1sI4FsunVDPU7/Y++mbqvOpZSJoQBLtQfgCYHF2QDpq3fUF0G5
	 ZOJNfuLl/mrRjHZIfkczqwaAAGxKopAkS+iAB/75GKxEACbuTACL7DEj4EFtSQa5fs
	 0WuDayNMs/82LGffSVpuHGz91NrlfQSQlqakKSfNY86YFvMegVGZ+eQoOxjs5+X8q0
	 lNWw2MZRVQPeQzjGf0eYFqALRkbag1S7yGwyvJmoO8ZkAbAxAoAA9itHVNLTgPWImw
	 8lITpTTpOP3FDfQFiM6Xdaj0AZ12vLBF70kI7ILOUaOHnMuRl6/GC7/iB+ZlW+EcHc
	 5urfVUKW3eWCg==
Received: from pmta09.mandrill.prod.atl01.rsglab.com (localhost [127.0.0.1])
	by mail132-14.atl131.mandrillapp.com (Mailchimp) with ESMTP id 4fhXL13Q6Yz8XRwk7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:26:49 +0000 (GMT)
From: "Teddy Astie" <teddy.astie@vates.tech>
Subject: =?utf-8?Q?Re:=20Mapping=20non-pinned=20memory=20from=20one=20Xen=20domain=20into=20another?=
Received: from [37.26.189.201] by mandrillapp.com id 24dd957112574930804b1ad5f7d29c91; Thu, 26 Mar 2026 18:26:49 +0000
X-Bm-Disclaimer: Yes
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1774549607657
Message-Id: <df6194cf-1fc4-4a20-ad46-6eeab1d920a2@vates.tech>
To: "Demi Marie Obenour" <demiobenour@gmail.com>, "Xen developer discussion" <xen-devel@lists.xenproject.org>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, "Jan Beulich" <jbeulich@suse.com>, "Val Packett" <val@invisiblethingslab.com>, "Ariadne Conill" <ariadne@ariadne.space>, "Andrew Cooper" <andrew.cooper3@citrix.com>, "Juergen Gross" <jgross@suse.com>
References: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com> <5123c11c-3b8a-4633-809f-16c24418a4ce@vates.tech> <4f201188-31ac-4dac-9cc6-79c4283486e5@gmail.com>
In-Reply-To: <4f201188-31ac-4dac-9cc6-79c4283486e5@gmail.com>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.24dd957112574930804b1ad5f7d29c91?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20260326:md
Date: Thu, 26 Mar 2026 18:26:49 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ge1s1q6ec6iyausertr5urcx4m6p4f6x
X-Rspamd-Queue-Id: 5C69DC000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774549610-179127
X-HE-Meta: U2FsdGVkX18PigDgOaFf6v12efVnLZgMU677H5wkUV0+lgVovBNqdbi0RiqcZhj3PyLbqHhZ+eG54IMu8UpnAybRb/5DYDKhgVeCS23VOerkIdP37uLdgmhCo4oi+oqPNCK75AE9mdqLQfME4UsiaQu9ippofkrswwRJBuF9rvFkqKWpxXl8yTUuTKaeZs4S1YYGxfNaIsxpEE8DyOkpQGyLObXpTjgooHFC7dYbKvpuyFkQ/z0gtY1FhImDcn7QHY9+sapdtbdbXYjhEzToaMwfnnyxYuBxwXF+dN03oUF8oIPAr8QMM5Pg4QaZ1fs1klD0jynE4zfNML64xdamomABDLtdVkdip8SxqAn49ZxmAFu3/gvXgRsE8vsU8kvA3metQvJIy0K8ZGzTb8sODMSZJfVCRvzPJZukDn/lAxGjhN2kp5CTyMERD8/mi9NCWYkzwO89CBBVNyqCoyGtLGadC2B+mWrGs3omU4cth25ZpZM0ri8JKmOwg2qB4Pk4ocIocs0YNquUViRvr8i6MYsCYlCss4I4fRoxVTdyaxkvCueBTzWystnuAUzgP+elP6Vig7yJmYsy5EcDOuu2hiAaWuUjkuo2mdEziSoQv6KmuuEzrtm+0oMj3TMD+wyFGFaE0NtDo64jyYWndkoiYd9+nn8a4bzsTDjHPsR2A2eClzRZa0wcrJR/hYe2foj3la6TOZ9/XjEAzgn+fkxUGkhZv4q0AShohdlsGy+3X4vAmndY9FlD/Spv9h0UZRDu22epB9pmLkgwN0AZzYr3V3ZSLSuvZ1MMaBezPnm5ABjm1QAR8d7suEnWYYvonWLrxU3mU2yj4V2w3zyHitj3qkBxUnx3yV7WpuEBIO7Kr5GsXc/g0p7B0UUYg7EC6EhUys1jE9BUKJ+qL2SZB1cYjeQ+9Gen5RkuwDvgzTr7yX+HW9SY5jOsr4Az2jRmFmmkUmpQ0jrzOj+zVh/Q+fS
 PYS66z7p
 7nebMQHYmHNt3XKMcz0F8UUXNIfjwhTQt+xpHgeL5vW2XFWlqHYJTK5dnX7mczAgRqWGhD3QFpj43EF0l3k4XW58Dpvcp7C4j9A/u1GfSkWuFTcrXk1fvkp4vDGv8KUT10ZvpOhcRkmqLpSmOUMGtecsY5wjIgfgx3SKQeg5Abe7S4fkvY8bImdRiDx4fhrttmyR1tV3uxNSsSpMYgENZbPuHVFcapl+jEPcEomCOU9YJMoF+atCYKQBNBSctRsIdC8hvQIH40itha+3BBLXA4klkjvQuhMxtK+81Auah0ye0B4LAfARXu4xDuRHxUUSirsmkmFi2i0wX9Xs9ZBdMfqrlCcapyiQ1h9DXwHUr6QDXvr8w+287sYmoQdeTEKveWAsD+7KKRC2euQg2+bvB0fNBQ5IbGn4gK0QX0tQbD/4Mhu83CDGBSom5IWsZSN+M3/o0uJqS6v9ITq9yLlNhHeRDsQt2fb1Pv3kIxJL1R9BbdCqIQipND+vmAYpsY+sSFgEZ9fDCo28XpJ6eIb6ay8MydTOPxi9cfUANHCyVNoTuwC4qFB3kWXhftnL3kFd0tFww/eEPE+RmKRSGYrZFSBnuGHleABSjF84cp9DbMqLN6NIosSFcb2yUqnrl4m5aZAxskiRz4QvABDVnia6T1Wja1LIOgYYO0wW+YPvY+OVSWFd9GAulty4eIAoyDWTCfnd8/NwYZ2zc4dRZWwpb6Ymr0kAlQ3tTVHze7HOZMU7XTadX78z+Sp1nHaOcwJSCGe6AMgYXyIB2hgdr+nXMlAcUytpqujme1dGpYqI5ahVTqKLMWWRpQPUNkZrLsj2XXCwyTdWczAm8wPSltOi80ofKpp8bw3iTxLAXJJms19wC/7afVeVik8xslLdeL7dRnWPmoOYLg9IQ13YGVIq1+WVIEYXKIN7cxtmGIGS4mvQKs/j3QXZg21IUHmT5kE2KmqV6MRmltKaln5Ge++G8Ys0fdXDF
 C9QwYx66
 gxD/m6fS9CzKPHqOtUXAX1ICKFpDeyK4yL5kere2uq4SzCvtWJ5uS5vbblDc6rM3hPV3FxDDFAE/BbDvvO8UUETMFy7EEKNIU9tcLilWQo7ZKiDeC77tR+Oe4A/HS0M6YMxphX4dTv/HWYGqGaE9EMx0TntENyPiYe+YbyISIvWhjT+33RO1c185CcZKeeZOWEBoPVKhs0AEiS8lsE4jC3LYM9r1LO0hvMQ/nNqLirLR0n2BdQKo1FBVsdjdEOVY/1t0NXg210U8mFct9aa7sQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le 26/03/2026 =C3=A0 18:18, Demi Marie Obenour a =C3=A9crit=C2=A0:
> On 3/24/26 14:00, Teddy Astie wrote:
>>> ## Restrictions on lent memory>>
>>> Lent memory is still considered to belong to the lending domain.
>>> The borrowing domain can only access it via its p2m.  Hypercalls made
>>> by the borrowing domain act as if the borrowed memory was not present.
>>> This includes, but is not limited to:
>>>
>>> - Using pointers to borrowed memory in hypercall arguments.
>>> - Granting borrowed memory to other VMs.
>>> - Any other operation that depends on whether a page is accessible
>>>     by a domain.
>>
>> What about emulated instructions that refers to this memory ?
> 
> This would be allowed if (and only if) it can trigger paging as you
> wrote above.
> 
>>> Furthermore:
>>>
>>> - Borrowed memory isn't mapped into the IOMMU of any PCIe devices
>>>     the guest has attached, because IOTLB faults generally are not
>>>     replayable.
>>>
>>
>> Given that (as written bellow) Borrowed memory is a part of some form of
>> emulated BAR or special region, there is no guarantee that DMA will work
>> properly anyway (unless P2P DMA support is advertised).
>>
>> Splitting the IOMMU side from the P2M is not a good idea as it rules out
>> the "IOMMU HAP PT Share" optimization.
> 
> If the pages are mapped in the IOMMU, paging them out requires an
> IOTLB invalidation.  My understanding is that these are far too slow.
> 

yes (aside specific cases like with paravirtualized IOMMU), but only if 
you have a device in the guest.

The problem is that that would force us to modify the ABI to have 
"non-DMA-able" memory in the guest, which doesn't exist yet aside 
specific cases like grants in PV.

> How important is sharing the HAP and IOMMU page tables?
> 
>>> - Foreign mapping hypercalls that reference lent memory will fail.
>>>     Otherwise, the domain making the foreign mapping hypercall could
>>>     continue to access the borrowed memory after the lease had been
>>>     revoked.  This is true even if the domain performing the foreign
>>>     mapping is an all-powerful dom0.  Otherwise, an emulated device
>>>     could access memory whose lease had been revoked.
>>>
>>> This also means that live migration of a domain that has borrowed
>>> memory requires cooperation from the lending domain.  For now, it
>>> will be considered out of scope.  Live migration is typically used
>>> with server workloads, and accelerators for server hardware often
>>> support SR-IOV.
>>>
>>> ## Where will lent memory appear in a guest's address space?
>>>
>>> Typically, lent memory will be an emulated PCI BAR.  It may be emulated
>>> by dom0 or an alternate ioreq server.  However, it is not *required*
>>> to be a PCI BAR.
>>>
>>
>> ---
>>
>> While the design could work (albeit the implied complexity), I'm not a
>> big fan of it, or at least, it needs to consider some constraints for
>> having reasonable performance.
>> One of the big issue is that a performance-sensitive system (virtualized
>> GPU) is interlocking with several "hard to optimize" subsystem like P2M
>> or Dom0 having to process a paging event.
>>
>> Modifying the P2M (especially removing entries) is a fairly expensive
>> operation as it sometimes requires pausing all the vCPUs each time it's
>> done.
> 
> Not every GPU supports recoverable page faults.  Even when they
> are supported, they are extremely expensive.  Each of them involves
> a round-trip from the GPU to the CPU and back, which means that a
> potentially very large number of GPU cores are blocked until the
> CPU can respond.  Therefore, GPU driver developers avoid relying on
> GPU page faults whenever possible.  Instead, data is moved in large
> chunks using a dedicated DMA engine in the GPU.
> As a result, I'm not too concerned with the cost of P2M manipulation.
> Anything that requires making a GPU buffer temporarily inaccessible
> is already an expensive process, and driver developers have strong
> incentives to keep the time the buffer is unmapped as short as
> possible.
> If performance turns out to be a problem, something like KVM's
> asynchronous page faults might be a better solution.
> 

Asynchronous page fault looks like a interesting and potentially easier 
to implement.

IIUC, the idea is to make the pages disappears on the guest behalf, and 
the guest would have to deal with the eventual page fault. Currently in 
Xen, a unhandled #NPF is fatal, but that could be tuned down for 
specific regions and transformed into a #PF or another exception for the 
guest to handle.

We have actually a similar need for SEV-ES MMIO handling, as we need to 
distinguish "MMIO-related NPF" (to paravirtualize through GHCB) to the 
other NPF; which needs to be configured in advance in page-tables (so 
that the CPU choose between #VC and VMEXIT#NPF).

It would also need some form of para-virtualization coming from virtio 
or a new Xen PV driver for the guest to be made aware of this mechanism.
I also assume that the guest handles properly that kind of event.

>> If it's done at 4k granularity, it would also lack superpage support,
>> which wouldn't help either. (doing things at the 2M+ scale would help,
>> but I don't know enough how MMU notifier does things.
>>
>> While I agree that grants is not a adequate mechanism for this (for
>> multiples reasons), I'm not fully convinced of the proposal.
>> I would prefer a strategy where we map a fixed amount of RAM+VRAM as a
>> blob, along with some form of cooperative hotplug mechanism to
>> dynamically provision the amount.
> 
> I asked the GPU driver developers about pinning VRAM like this a couple
> years ago or so.  The response I got was that it isn't supported.
> I suspect that anyone needing VRAM pinning for graphics workloads is
> using non-upstreamable hacks, most likely specific to a single driver.
> 
> More generally, the entire graphics stack receives essentially no
> testing under Xen.  There have been bugs that have affected Qubes OS
> users for months or more, and they went unfixed because they couldn't
> be reproduced outside of Xen.  To the upstream graphics developers,
> Xen might as well not exist.  This means that any solution that
> requires changing the graphics stack is not a practical option,
> and I do not expect this to change in the foreseeable future.


--
Teddy Astie | Vates XCP-ng Developer

XCP-ng & Xen Orchestra - Vates solutions

web: https://vates.tech



