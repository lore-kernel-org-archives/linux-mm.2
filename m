Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A321010D14A4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134736B0098; Mon, 30 Mar 2026 08:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E6306B0099; Mon, 30 Mar 2026 08:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16D66B009D; Mon, 30 Mar 2026 08:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC5CD6B0098
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:13:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8734FC159F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:13:57 +0000 (UTC)
X-FDA: 84602620914.28.80E8AB5
Received: from mail179-37.suw41.mandrillapp.com (mail179-37.suw41.mandrillapp.com [198.2.179.37])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5FEF78000F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:13:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=mandrillapp.com header.s=mte1 header.b=RSV7sX3W;
	dkim=pass header.d=vates.tech header.s=mte1 header.b=FjfHojRP;
	dmarc=pass (policy=none) header.from=vates.tech;
	spf=pass (imf02.hostedemail.com: domain of bounce-md_30504962.69ca6902.v1-b606c005141b44aea04ad3543f6b3aa5@bounce.vates.tech designates 198.2.179.37 as permitted sender) smtp.mailfrom=bounce-md_30504962.69ca6902.v1-b606c005141b44aea04ad3543f6b3aa5@bounce.vates.tech
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774872835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/UEoCpZgSsa/b7GuIF8NEs0PMrAel8kk9xZN9ljZb4=;
	b=7pyesRl5L/uxrr8TXVge09W+GJbiSPuq4gPJk58bwzFLTe4MMzNETi2dnaW5iIrfnXlLPH
	QNRAW0iiHE4e8z3639B/yMm3JeIzu2Y84IzR8fKIw8hnIbYUfpOsuwUazpyWInCsp1opAx
	pCyhf7c2ExufP80lynPIwXMnVi4gReo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774872835; a=rsa-sha256;
	cv=none;
	b=1+QrJSYSaUKCJnTuyexWcO6o0JkHaoZgXPMT/lOrbd2bRPlcX3mGGC7TX983GUI2auEDyR
	WbzAGitIS3IGc2Aru0rd2/hWGxR0Wnl65kDopOMZYjewUXgDVshlVa3eqJhMQVoqoEOaR3
	C270zMapTTAQZH0/PoVm/ON3w+wEhOU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=mandrillapp.com header.s=mte1 header.b=RSV7sX3W;
	dkim=pass header.d=vates.tech header.s=mte1 header.b=FjfHojRP;
	dmarc=pass (policy=none) header.from=vates.tech;
	spf=pass (imf02.hostedemail.com: domain of bounce-md_30504962.69ca6902.v1-b606c005141b44aea04ad3543f6b3aa5@bounce.vates.tech designates 198.2.179.37 as permitted sender) smtp.mailfrom=bounce-md_30504962.69ca6902.v1-b606c005141b44aea04ad3543f6b3aa5@bounce.vates.tech
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mandrillapp.com;
	s=mte1; t=1774872834; x=1775142834;
	bh=8/UEoCpZgSsa/b7GuIF8NEs0PMrAel8kk9xZN9ljZb4=;
	h=From:Subject:Message-Id:To:References:Cc:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=RSV7sX3WkfWGHnsfyQghtG8deP1aTV1h9tcowxjf/4kdRwGvFCNyiNNBOq1XQlwRT
	 Gp+8lqEcpcYn4Eyy/GVpTJtHjDLnGmfYkRafyXnInywCazCCQ+mwNIWGKiBACdsUlx
	 tP7h6LjCy4UP8EOKnGqRL1oej9eeUw3OgdN/p2KQc2dP5azlnNQ5Q5A+hDrbxG1AOj
	 3WZsYJ8LyfweLDncqqJ1kepSuMI/snqj2D7mD1QxkfJhViyHkEgApKN+RryitqtXu3
	 dnnw2m9Jeo9iH4I62zdVxYj70UEWPvLJ7fDr0wCnUkF8jR4CKiPdAuvvsVXWNdOb2V
	 XTtKfch6Tt+Lw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vates.tech; s=mte1;
	t=1774872834; x=1775133334; i=teddy.astie@vates.tech;
	bh=8/UEoCpZgSsa/b7GuIF8NEs0PMrAel8kk9xZN9ljZb4=;
	h=From:Subject:Message-Id:To:References:Cc:In-Reply-To:Feedback-ID:
	 Date:MIME-Version:Content-Type:Content-Transfer-Encoding:CC:Date:
	 Subject:From;
	b=FjfHojRPHKxVbVOirgIkXCEiz3LY3QjJRReQeqIf7oU0QS3mAaQeIGjS4pHxeqApm
	 Xd+OZorH7atLW/vSfNqZEhGlC71mEy/v4h+7Gr4TkT+fwKUKsZvFaJc+2etaLlTkjY
	 JEvaj/sPe+qYBCmVXaVUlqJRrBc1WlUdttYQNvlDKVj+FfMvDdDMAED7cSF9QKGnTf
	 KZwaHjbUxWTK/rLKIYE3Ifb4GFIdKic/5DIUqCNqy569dbOFjHplrvLcKPLlHHSYIx
	 1hDS1quLmMHiJ0az4t14q7R++yc61vt7b9v0VICMtxPsaqmqncC/UtzgxmLc2ZgpuD
	 xZLrOlnuCxDGA==
Received: from pmta12.mandrill.prod.suw01.rsglab.com (localhost [127.0.0.1])
	by mail179-37.suw41.mandrillapp.com (Mailchimp) with ESMTP id 4fkqst2VWgzG0CBNB
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:13:54 +0000 (GMT)
From: "Teddy Astie" <teddy.astie@vates.tech>
Subject: =?utf-8?Q?Re:=20Mapping=20non-pinned=20memory=20from=20one=20Xen=20domain=20into=20another?=
Received: from [37.26.189.201] by mandrillapp.com id b606c005141b44aea04ad3543f6b3aa5; Mon, 30 Mar 2026 12:13:54 +0000
X-Bm-Disclaimer: Yes
X-Bm-Milter-Handled: 4ffbd6c1-ee69-4e1b-aabd-f977039bd3e2
X-Bm-Transport-Timestamp: 1774872833084
Message-Id: <bd136f57-3d16-482a-9014-be44183bc86f@vates.tech>
To: "Demi Marie Obenour" <demiobenour@gmail.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, "Val Packett" <val@invisiblethingslab.com>, "Ariadne Conill" <ariadne@ariadne.space>
References: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com>
Cc: "Xen developer discussion" <xen-devel@lists.xenproject.org>
In-Reply-To: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com>
X-Native-Encoded: 1
X-Report-Abuse: =?UTF-8?Q?Please=20forward=20a=20copy=20of=20this=20message,=20including=20all=20headers,=20to=20abuse@mandrill.com.=20You=20can=20also=20report=20abuse=20here:=20https://mandrillapp.com/contact/abuse=3Fid=3D30504962.b606c005141b44aea04ad3543f6b3aa5?=
X-Mandrill-User: md_30504962
Feedback-ID: 30504962:30504962.20260330:md
Date: Mon, 30 Mar 2026 12:13:54 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5FEF78000F
X-Stat-Signature: zok7crdg8jz31ezk3je9h7fmuckz4ztp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774872835-669013
X-HE-Meta: U2FsdGVkX1/fydwffmOOC4Vh8cvXAIL4DrnnjSqnoMb0GIJLPA7pfNuhMlvcl/qPKrKEYEukIn5KrEPpSerM0lPxtbIL/e2p8gNhShL5xLgd7v/0BHP14dUq7nZ+vmLfwAJMqLujoB7jJ4Y2bPEU3qSKNajAHthO0aa/GaIrkxGjJwJ32vdZjiE56x+34cmsOvABoZrdqLmvotUgdWtwgFzJGdPJisKi89Wjs4KDc4qQRXPrySffLakt0fVp5HEunTW8nPHvR5wFDsnEr8gyh1X6nRyTCD0QqfQC+HrjeuBByq77M6JJUduI4XjCQr+qESn1xlKbDzHMFMetFYnZjXhJGT2FAgmBttK2fRbO+O5sqJslCJ6zfPdXKf9GUEdkRNTx0AAGWSM6qhU1PYpCElj4jbLjjmpzaiiy74h7vppLb1GR6YHf3WKFQbL33EqG1pti1IsWkL9tqdXQnzF2YXg/ajFYs+ar92NzFRDGaLuwarKiA+D38bgMS8mpl4hqMwGkGP35xdh/hP0wQnpC0ajEufDxSg00/EPWRdTiBrawWDG/9tyMDXQRSfrz4UvJWwRxcJfnHju2zlOK+xIpcKGaFfRS5CBYLv4y9Lc8/GdpuINn1hcTozup1Pgbi1VFmEWQqCvcn3GhHTK9p47ew72OXJgXsyiQ1aIE1RuE1V7Fuv9802k4EJuwIG6XFW0JW6Bda+bFiRqrjnPvsuulSW6jN/OXwNUdUSBanxlLQWJJI621zSGd+iEMNedg0LxuEDppOKSlSR/+35sXGKTdp8iShPEtNOklWnSlfbJiYSy+BUOREnKCYMl8dWcl3CjUnR/0zBlwZJn9OGs8KP+GelZSPV1KqSejS3nIBHOO7iflGva7kddVTsddPSjvUvO0RFtw8eCokLh8yQ5eV4A2/A4gbe1osyq5a6ezh+QPuPjIzIsZzlZ/RjicygLLc24RNtLVXev6KOSM+ZA5WPG
 R05gNDTH
 2Hx4J0cLwA3IRlAaMNUvAPD1kf2uj2y/GCGXCIIBfbBHSS3vHeUsQPVxXheMD7ZF+Wn1h7vHxnuyG5cgDMXbbH7EyZfkOwmS1xeJ5kLd3sRyg2rSW48uxOKC92uTZzpk0PzjSpixbh4+/V80qv+iid/WYvvYoMmJH+EPLs4JQora9yvnk7RiFLYRg/w5p9iH49VSmCKbzVYH194inDp9IfLTxxmq6OU8yWiiFFSmP+qSVEZWovb5axi39u8HyPk3uT/LVacAsiUkLe7ZxHY2gqrszQKGq8/7Em9On67Zk5CBGf+D8Ij/lOrzh6tamaDfYTpJl94gQvfgLdCMtdjEoU/LXMA/Vs2xX1C2G5MiQEo0MQRp8PWewAwVRIAefBRUmqpbnfrq6qVFiWLmILHrZQDr1jF1GVKwv2fPdP6Oke8D9M7Fxgs9VvF9u3gV0Z6/v/N3UjoyPQR8zpSZdzVzmAoSliEzK496OijgLXrsrRqo8BseQ2riuaufQ6uIEpDpH2l9/VBYKZaOFfgEbgRq5eya25yF/jjk+KWByvVGrqLUsPb/V2vmt9W65STYoBGCpxNgHH95fI8P5B8Atfa3AXTh0FTeWIwyA2QICYN4oM3xS5kWujg4FyBQx5dJtg9jleFvEi9FMTsG+1vrAxbRSgNoOPw7sagYh3fpCBSl77UGCtD6yYE6GPwSwEZETSl1ZBRD5RFvbO6rMuVuQr/XwKZ7TvSPl4jW4m3K6qUlpCgYVEMxrYTPXroJLW93qinBcf9iekpNXmw97Tpk7HlxlTICwJFcK+ess3gbgzuT0R/q5jnKrKo2cK7ZESRVqR25Vbw8pQUUTVw44YUrBCP+MHeUflW9rUi2P21IhRKBrUdZfQ3HikI0IymKXi4rKAE3tR9irk82esA4oFQWMVLJjK6fAA5B1sMdhbPCNNkA0Gy+cdS0SqOtK+5rhhCpqQSptdhsh6cgVM+ydSphRg11P/T8dxewF
 CQbaD9tr
 KfC/W/MG1gjoiQ9BJyBwmWgKdVjROLVA9zCzKzezTcyVRXi9zCweV7vRiPG42fY04DPwmZXhe/Q7avV7JO4kLSfVRNC8MJQKX8zpeKwNEkmpoGxpAKjKqZ8bZlcKFiqlQshaIstirs/n7bBpjX4gYd39HDC3qFuIV8FFPSclutQJW7vmfjHViDWzBeirUlxNk+lLqgFQxz6OKs0U47jatSDGudH+37BVSrlFm/zOZ/Cz6tIz/aswRyGXKHIxxHQEP6LNUL6pOvLfB1cXBNtUpp5CzrvfTGsdOSglEbs9ydg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(back to the original problem)

Le 24/03/2026 =C3=A0 15:17, Demi Marie Obenour a =C3=A9crit=C2=A0:
> Here is a proposed design document for supporting mapping GPU VRAM
> and/or file-backed memory into other domains.  It's not in the form of
> a patch because the leading + characters would just make it harder to
> read for no particular gain, and because this is still RFC right now.
> Once it is ready to merge, I'll send a proper patch.  Nevertheless,
> you can consider this to be
> 
> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
> 
> This approach is very different from the "frontend-allocates"
> approach used elsewhere in Xen.  It is very much Linux-centric,
> rather than Xen-centric.  In fact, MMU notifiers were invented for
> KVM, and this approach is exactly the same as the one KVM implements.
> However, to the best of my understanding, the design described here is
> the only viable one.  Linux MM and GPU drivers require it, and changes
> to either to relax this requirement will not be accepted upstream.
> ---
> # Memory lending: Mapping pageable memory, such as GPU VRAM, from one Xen=
 domain into another
> 

(...)

> ## Informing drivers that they must stop using memory: MMU notifiers
> 
> Kernel drivers, such as xen_privcmd, in the same domain that has
> the GPU (the "host") may map GPU memory buffers.  However, they must
> register an *MMU notifier*.  This is a callback that Linux core memory
> management code ("MM") uses to tell the driver that it must stop
> all accesses to the memory.  Once the memory is no longer accessed,
> Linux assumes it can do whatever it wants with this memory:
> 
> - The GPU driver can move it from VRAM to system RAM or visa versa,
>    move it within VRAM or system RAM, or it temporarily inaccessible
>    so that other VRAM can be accessed.
> - MM can swap the page out to disk/zram/etc.
> - MM can move the page in system RAM to create huge pages.
> - MM can write the pages out to their backing files and then free them.
> - Anything else in Linux can do whatever it wants with the memory.
> 
> Suspending access to memory is not allowed to block indefinitely.
> It can sleep, but it must finish in finite time regardless of what
> userspace (or other VMs) do.  Otherwise, bad things (which I believe
> includes deadlocks) may result.  I believe it can fail temporarily,
> but permanent failure is also not allowed.  Once the MMU notifier
> has succeeded, userspace or other domains **must not be allowed to
> access the memory**.  This would be an exploitable use-after-free
> vulnerability.
> 
> Due to these requirements, MMU notifier callbacks must not require
> cooperation from other guests.  This means that they are not allowed to
> wait for memory that has been granted to another guest to no longer
> be mapped by that guest.  Therefore, MMU notifiers and the use of
> grant tables are inherently incompatible.
> 
> ## Memory lending: A different approach
> 
> Instead, xen_privcmd must use a different hypercall to _lend_ memory to
> another domain (the "guest").  When MM triggers the guest MMU notifier,
> xen_privcmd _tells_ Xen (via hypercall) to revoke the guest's access
> to the memory.  This hypercall _must succeed in bounded time_ even
> if the guest is malicious.
> 
> Since the other guests are not aware this has happened, they will
> continue to access the memory.  This will cause p2m faults, which
> trap to Xen.  Xen normally kills the guest in this situation which is
> obviously not desired behavior.  Instead, Xen must pause the guest
> and inform the host's kernel.  xen_privcmd will have registered a
> handler for such events, so it will be informed when this happens.
> 
> When xen_privcmd is told that a guest wants to access the revoked
> page, it will ask core MM to make the page available.  Once the page
> _is_ available, core MM will inform xen_privcmd, which will in turn
> provide a page to Xen that will be mapped into the guest's stage 2
> translation tables.  This page will generally be different than the
> one that was originally lent.
> 
> Requesting a new page can fail.  This is usually due to rare errors,
> such as a GPU being hot-unplugged or an I/O error faulting pages
> from disk.  In these cases, the old content of the page is lost.
> 
> When this happens, xen_privcmd can do one of two things:
> 
> 1. It can provide a page that is filled with zeros.
> 2. It can tell Xen that it is unable to fulfill the request.
> 
> Which choice it makes is under userspace control.  If userspace
> chooses the second option, Xen injects a fault into the guest.
> It is up to the guest to handle the fault correctly.
> 

To me there are multiples problems :
- mapping a host-owned page into the guest
- make such mapping "non-persistent", i.e letting Linux discard it
- tracking guest access to such "non-existent mappings" (to remap it)

All problems could be mixed into a single solution, but I don't think 
it's a good idea, that means various kind of MM events for Linux could 
originate from Xen. There is also the "process disappeared" situation 
that could cause of lof of problems for the kernel. In KVM, the guest 
existence is tied to the process by construction but with Xen, things 
are different.
But I think at least for the virtio-gpu use-case, these can be separated.

Here is a approach (multiples parties) :

The first 2 problems can be solved in a "simple" way, just make a 
"reverse foreign map" with a MMU notifier attached to it. If Linux wants 
to discard the mapping, the remote mapping in the guest is unmapped.
(something still needs to be done for doing that for VRAM)

The 3rd one is a bit trickier. It's mostly a result of the 2nd problem 
e.g swap or RAM/VRAM migration. The page has disappeared in the guest. 
That could be dealt with a slightly modified ioreq server, but instead 
of responding to read/writes, it would just act on "accesses" (it's 
mostly to avoid having to emulate the read/writes in the device model).

So overall, pages are mapped but "may disappears" (by kernel) and device 
model (e.g QEMU) would need to remap them explicitly if that happens and 
guest needs it.

What do you think ?

> ## Restrictions on lent memory
> 
> Lent memory is still considered to belong to the lending domain.
> The borrowing domain can only access it via its p2m.  Hypercalls made
> by the borrowing domain act as if the borrowed memory was not present.
> This includes, but is not limited to:
> 
> - Using pointers to borrowed memory in hypercall arguments.
> - Granting borrowed memory to other VMs.
> - Any other operation that depends on whether a page is accessible
>    by a domain.
> 
> Furthermore:
> 
> - Borrowed memory isn't mapped into the IOMMU of any PCIe devices
>    the guest has attached, because IOTLB faults generally are not
>    replayable.
> 
> - Foreign mapping hypercalls that reference lent memory will fail.
>    Otherwise, the domain making the foreign mapping hypercall could
>    continue to access the borrowed memory after the lease had been
>    revoked.  This is true even if the domain performing the foreign
>    mapping is an all-powerful dom0.  Otherwise, an emulated device
>    could access memory whose lease had been revoked.
> 
> This also means that live migration of a domain that has borrowed
> memory requires cooperation from the lending domain.  For now, it
> will be considered out of scope.  Live migration is typically used
> with server workloads, and accelerators for server hardware often
> support SR-IOV.
> 
> ## Where will lent memory appear in a guest's address space?
> 
> Typically, lent memory will be an emulated PCI BAR.  It may be emulated
> by dom0 or an alternate ioreq server.  However, it is not *required*
> to be a PCI BAR.
> 
> ## Privileges required for memory lending
> 
> For obvious reasons, the domain lending the memory must be privileged
> over the domain borrowing it.  The lending domain does not inherently
> need to be privileged over the whole system.  However, supporting
> situations where the providing domain is not dom0 will require
> extensions to Xen's permission model, except for the case where the
> providing domain only serves a single VM.
> 
> Memory lending hypercalls are not subject to the restrictions of
> XSA-77.  They may safely be delegated to VMs other than dom0.
> 
> ## Userspace API
> 
> To the extent possible, the memory lending API should be similar
> to KVM's uAPI.  Ideally, userspace should be able to abstract over
> the differences.  Using the API should not require root privileges
> or be equivalent to root on the host.  It should only require a file
> descriptor that only allows controlling a single domain.
> 
> ## Future directions: Creating & running Xen VMs without special privileg=
es
> 
> With the exception of a single page used for hypercalls, it is
> possible for a Xen domain to *only* have borrowed memory.  Such a
> domain can be managed by an entirely unprivileged userspace process,
> just like it would manage a KVM VM.  Since the "host" in this scenario
> only needs privilege over a domain it itself created, it is possible
> (once a subset of XSA-77 restrictions are lifted) for this domain
> to not actually be dom0.
> 
> Even with XSA-77, the domain could still request dom0 to create and
> destroy the domain on its behalf.  Qubes OS already allows unprivileged
> guests to cause domain creation and destruction, so this does not
> introduce any new Xen attack surface.
> 
> This could allow unprivileged processes in a domU to create and manage
> sub-domUs, just as if the domU had nested virtualization support and
> KVM was used.  However, this should provide significantly better
> performance than nested virtualization.



--
Teddy Astie | Vates XCP-ng Developer

XCP-ng & Xen Orchestra - Vates solutions

web: https://vates.tech



