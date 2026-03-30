Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9689E1061B1F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 20:07:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B286B008C; Mon, 30 Mar 2026 16:07:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE5366B0095; Mon, 30 Mar 2026 16:07:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85FD6B0096; Mon, 30 Mar 2026 16:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B02566B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:07:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F79613BB66
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:07:50 +0000 (UTC)
X-FDA: 84603815100.21.25C6F67
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8270E14000E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:07:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=invisiblethingslab.com header.s=fm1 header.b=J98PO7Uc;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=f6ATStt5;
	spf=pass (imf26.hostedemail.com: domain of val@invisiblethingslab.com designates 103.168.172.152 as permitted sender) smtp.mailfrom=val@invisiblethingslab.com;
	dmarc=pass (policy=none) header.from=invisiblethingslab.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774901268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BOoZ4+1vDCorDNqLh55ozbf1TI816t8IDrbHJQudFlc=;
	b=unA01oCD7S9/9DTRQ1UA1UclfwGbEeE1ug7gxMcaPrkRd9gueeYPpgcEb1b/iFj9fUqCzA
	zwfDtwKs2lB2l/6AgICHbCVVnFz9DglCJoAAJ7PmHZwQA1EH+TQGTIKRDslVPZLpXQYLqy
	BtyShZulf8Fbp2MUkmSuHB9x0uAnlbw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=invisiblethingslab.com header.s=fm1 header.b=J98PO7Uc;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=f6ATStt5;
	spf=pass (imf26.hostedemail.com: domain of val@invisiblethingslab.com designates 103.168.172.152 as permitted sender) smtp.mailfrom=val@invisiblethingslab.com;
	dmarc=pass (policy=none) header.from=invisiblethingslab.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774901268; a=rsa-sha256;
	cv=none;
	b=zxYwdth9HLX+4tOMekoBBYdOZebwu+Ne4ySr96yfrkg8OMZXNqgKJ1mXDchQuSdvGmtZ63
	/5EyiEog96t4KUIB8XW9AcRI+N4EHoPFSUa+RKDQfoS7I6DpRHA33QraZo3l8G1rt6Jy8K
	qyJlGPkh0gtGqubZB+7A4z2LYA6Ijz8=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D98F41400237;
	Mon, 30 Mar 2026 16:07:47 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 30 Mar 2026 16:07:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:content-transfer-encoding
	:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1774901267; x=1774987667; bh=BOoZ4+1vDC
	orDNqLh55ozbf1TI816t8IDrbHJQudFlc=; b=J98PO7UciOPuDlbFOLxVr8brvv
	avsxrKqh5I5dda792C57PqhOrTwi6yElbJ6EcGm6wy2pv+yYzvHsrVWiZohtlWP7
	Q8sxa6C1khaJRaSGkalK0Zq1EUXWvg95zEi0HQnththWFTd8ZsgfstZDKhCLDLK+
	G8wHDCqmqyOg1twg4UXO6ehYjIgPuy4Frt0iWEvf3Xubtq2OgrS0qdDygs8NHaX+
	Eds3U+Qkq1anBmPAzIj/rtjU7C6F4mzo04VvwekrW+Bgq6gICNn2VaXWqqetcnOD
	jLzkvw/u0GKOyP8gcaym9P7nD4TihwS7XgiQEeNgO+o/0rNiat5WDqDvxa6Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1774901267; x=1774987667; bh=B
	OoZ4+1vDCorDNqLh55ozbf1TI816t8IDrbHJQudFlc=; b=f6ATStt55tAUXaiSF
	G7gf0ZjnYIGctHHHVSD+wkoL7MKPEth5YQ0Doy7AcTT4OWfL8y7hIkgWwm4I27OI
	PIhRCeZq778Gxx+SkPlKpblZdwcWsurEZlHpNoDD2J9RxbF5+pUUjYbXwFcei7Oh
	LxNh/qRLYAOqFQxzmtH13+JlH/UNd9LHjUrHBDkrTUC2HG5dltlZqNo1/Kl02/Ys
	0n26SXd8tzGisEaOsaxt90BTAIdIXLhDN4UuXBdywgWUvVX69SKsfUq5GSdWGjuA
	xiRdn2hP1c8fA/rAUQb091He9SPvb38KOSV3x2mzd6PgXOrjwFBjdzk41iV43lT+
	7FUmQ==
X-ME-Sender: <xms:E9jKaYdbX1Lkdh2HQfOiqiKutYDNC5y91lnSAJC_MrLXLeXq09rmIg>
    <xme:E9jKafL31T4Oqi-rZyw4LL92u3ErK_rjphXpqK3xVBzTayP44M9oBnJEbfcupUHyT
    5OdfooOcIfwRtL5IeskskbyCFEWAz5lnb791JdxOUpboSKTRF8>
X-ME-Received: <xmr:E9jKadwtdu5y-FQLqNnBEsQ2QCyVajtKhqYBrz_7y49NGbO7MZ-x8Oq472UpyMMSSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeffeelledtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepkfffgggfuffvfhfhjggtgfesthekredttddvjeenucfhrhhomhepgggrlhcurfgr
    tghkvghtthcuoehvrghlsehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomheqne
    cuggftrfgrthhtvghrnhepvdevgeevheehtefggeehjefhfeetjeekgfejkeettdejkeeh
    heekvdffvdfhtefgnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehvrghlsehinhhvihhsihgs
    lhgvthhhihhnghhslhgrsgdrtghomhdpnhgspghrtghpthhtohepledpmhhouggvpehsmh
    htphhouhhtpdhrtghpthhtohepuggvmhhiohgsvghnohhurhesghhmrghilhdrtghomhdp
    rhgtphhtthhopeigvghnqdguvghvvghlsehlihhsthhsrdigvghnphhrohhjvggtthdroh
    hrghdprhgtphhtthhopegurhhiqdguvghvvghlsehlihhsthhsrdhfrhgvvgguvghskhht
    ohhprdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtg
    hpthhtohepjhgsvghulhhitghhsehsuhhsvgdrtghomhdprhgtphhtthhopegrrhhirggu
    nhgvsegrrhhirggunhgvrdhsphgrtggvpdhrtghpthhtoheprghnughrvgifrdgtohhoph
    gvrhefsegtihhtrhhigidrtghomhdprhgtphhtthhopehjghhrohhsshesshhushgvrdgt
    ohhmpdhrtghpthhtohepthgvugguhidrrghsthhivgesvhgrthgvshdrthgvtghh
X-ME-Proxy: <xmx:E9jKadvk9tVbPIOJQo4UeUVAQqSW7D2yY69AzUbtpFCI47-zJ3TCSA>
    <xmx:E9jKaYAvp5ix4VXM8jtMTbOsl_5ciZfxEnmdwGmJVh_TaP22M5DTIw>
    <xmx:E9jKaXEgqHXU-zFlDd2o0DVAUDMkXdWg07uN2uBOaVkUBRVF3Y1ZjA>
    <xmx:E9jKaQCPjX_A0J4GXRS9f2EBu6KWzLYfYdftFprmCRXw3YArMqivNw>
    <xmx:E9jKaalk8FuQiVBwWWtayCwYnIELz1NFCF-M3O0m8g8l8GfazkJ8Jwnn>
Feedback-ID: i001e48d0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 30 Mar 2026 16:07:45 -0400 (EDT)
Message-ID: <0bbf0349-1006-485f-a2db-6c8b795b4242@invisiblethingslab.com>
Date: Mon, 30 Mar 2026 17:07:42 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Why memory lending is needed for GPU acceleration
To: Demi Marie Obenour <demiobenour@gmail.com>,
 Xen developer discussion <xen-devel@lists.xenproject.org>,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 Jan Beulich <jbeulich@suse.com>, Ariadne Conill <ariadne@ariadne.space>,
 Andrew Cooper <andrew.cooper3@citrix.com>, Juergen Gross <jgross@suse.com>,
 Teddy Astie <teddy.astie@vates.tech>
References: <84462c4b-7813-4ad1-aeb2-862ae4f3a627@gmail.com>
 <c38387fe-beef-4f50-b928-74f96b881b7a@gmail.com>
Content-Language: en-US
From: Val Packett <val@invisiblethingslab.com>
Autocrypt: addr=val@invisiblethingslab.com; keydata=
 xm8EaFTEiRMFK4EEACIDAwQ+qzawvLuE95iu+QkRqp8P9z6XvFopWtYOaEnYf/nE8KWCnsCD
 jz82tdbKBpmVOdR6ViLD9tzHvaZ1NqZ9mbrszMXq09VfefoCfZp8jnA2yCT8Y4ykmv6902Ne
 NnlkVwrNKFZhbCBQYWNrZXR0IDx2YWxAaW52aXNpYmxldGhpbmdzbGFiLmNvbT7CswQTEwkA
 OxYhBAFMrro+oMGIFPc7Uc87uZxqzalRBQJoVMSJAhsDBQsJCAcCAiICBhUKCQgLAgQWAgMB
 Ah4HAheAAAoJEM87uZxqzalRlIIBf0cujzfSLhvib9iY8LBh8Tirgypm+hJHoY563xhP0YRS
 pmqZ6goIuSGpEKcW5mV3egF/TLLAOjsfroWae4giImTVOJvLOsUycxAP4O5b1Qiy+cCGsHKA
 nCRzrvqnPkyf4OeRznMEaFTEiRIFK4EEACIDAwSffe3tlMmmg3eKVp7SJ+CNZLN0M5qzHSCV
 dBBkIVvEJo+8SDg4jrx/832rxpvMCz2+x7+OHaeBHKafhOWUccYBLKqV/3nBftxCkbzXDbfY
 d02BY9H4wBIn0Y3GnwoIXRgDAQkJwpgEGBMJACAWIQQBTK66PqDBiBT3O1HPO7mcas2pUQUC
 aFTEiQIbDAAKCRDPO7mcas2pUaptAX9f7yUJLGU4C6XjMJvXd8Sz6cGTyxkngPtUyFiNqtad
 /GXBi3vHKYNfSrdqJ8wmZ8MBgOqWaaa1wE4/3qZU8d4RNR8mF7O40WYK/wdf1ycq1uGad8PN
 UDOwAqdfvuF3w8QMPw==
In-Reply-To: <c38387fe-beef-4f50-b928-74f96b881b7a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8270E14000E
X-Stat-Signature: 8m8z4mqbiycf6bts458e3x95mmatkcqd
X-Rspam-User: 
X-HE-Tag: 1774901268-989853
X-HE-Meta: U2FsdGVkX1+0jw7HTtYHG+eIoMYOv4zvynXbmQvHVQXjlVFEtHLnnxS+40BUqlWg8U53FC56ounQV+646tKFCAIKIy0pSWcb8UvtLf+sUNgHzov9e1ryKkNxJzLTOOIhkqJJ//E0IaOUOhfzFj9kZumx4pkVUa8kZujsTTAirYSEQRqXzS4JIYQ6KZJe6h4abCWF4DxlYf0lde8R5u7aeulB6r2wEAJoThoS2FeQReJhmv30JgrtpTi6Y+N/MPa/bUh7KbN6fadnn03CwDpEKCMfq1cIppW9tRElYJWC0WEd8OHAq1oMfbgkK0tofjcs787QaBlvi9dVh6pH+ClXl7PDWGL+yV+xW+n3+Hfc5Shh4pIKrlBoYkHpNECWbs8w3qBg7e2VnR9+OMhOy9wLlPKVS7HZcpooULZjwDCZkfLPwKYQOlD+/pW/z13fKu5BxYb9e/GfiaHbhDNerWwmItJKxGUmV8NPc5wJ5X1rndK1rjuriA1DIvN28gF3w25ZyxRg8SA90BieNW5zWND8H3JosbBDmwRNmp9iZZXmNf5CsUIQtoJDbNeAbphF+HXsVPqFxsI8UFJ9QFBJmKaMRyERS0f9t2+gCQ3i374eiN/Js7YSkftnpxA9jZHjFP5u5PsUzM6IPOiRCBT0ml4jnGq9tkRmiq0/iMd5GWxKjaSir/ffgbp0BhmM8x2cJKsKkppHKoOuavYy/fO66FrwuaIwqpeld1ccRyDzzgOSB0dNcMJC++WZJoNOEQj43tLQ8Jp7kkVuixifkj5bgKTdgdaFsn0oquTJjQKkHrGtSGVNyH7uP712KdfSsZisZDzz7p1M3X82ONmLGnVW3edrfaKiE/Hiaio+jI4hcGNIKT/uXNFqdncTuqIcCnBO2yWRDOqJpDglh076fCQhqfQ+YN7daJ3cDlEI/KuxeVauv7IQi3k5t9Uxl05bp+YDeesqWey3tb3BWGHbjSWKrGI
 2Io5GuDs
 vb4lmLZkCixOBkH/Xnr9fFZlGronw+neMV+mqKRrKP6Gq0i7PvcW6hCI43tKzYUdMy2J5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 3/29/26 2:32 PM, Demi Marie Obenour wrote:
> On 3/24/26 10:17, Demi Marie Obenour wrote:
>> Here is a proposed design document for supporting mapping GPU VRAM
>> and/or file-backed memory into other domains.  It's not in the form of
>> a patch because the leading + characters would just make it harder to
>> read for no particular gain, and because this is still RFC right now.
>> Once it is ready to merge, I'll send a proper patch.  Nevertheless,
>> you can consider this to be
>>
>> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
>>
>> This approach is very different from the "frontend-allocates"
>> approach used elsewhere in Xen.  It is very much Linux-centric,
>> rather than Xen-centric.  In fact, MMU notifiers were invented for
>> KVM, and this approach is exactly the same as the one KVM implements.
>> However, to the best of my understanding, the design described here is
>> the only viable one.  Linux MM and GPU drivers require it, and changes
>> to either to relax this requirement will not be accepted upstream.
> Teddy Astie (CCd) proposed a couple of alternatives on Matrix:
>
> 1. Create dma-bufs for guest pages and import them into the host.
>
>     This is a win not only for Xen, but also for KVM.  Right now, shared
>     (CPU) memory buffers must be copied from the guest to the host,
>     which is pointless.  So fixing that is a good thing!  That said,
>     I'm still concerned about triggering GPU driver code-paths that
>     are not tested on bare metal.

To expand on this: the reason cross-domain Wayland proxies have been 
doing this SHM copy dance was a deficiency in Linux UAPI. Basically, 
applications allocate shared memory using local mechanisms like memfd 
(and good old unlink-of-regular-file, ugh) which weren't compatible with 
cross-VM sharing. However udmabuf should basically solve it, at least 
for memfds. (I haven't yet investigated what happens with "unlinked 
regular files" yet but I don't expect anything good there, welp.)

But I have landed a patch in Linux that removes a silly restriction that 
tied dmabuf import into virtgpu to KMS-only mode:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=df4dc947c46bb9f80038f52c6e38cb2d40c10e50

And I have experimented with it and got a KVM-based VMM to successfully 
access and print guest memfd contents that were passed to the host via 
this mechanism. (Time to actually properly implement it into the full 
system..)

> 2. Use PASID and 2-stage translation so that the GPU can operate in
>     guest physical memory.
>     
>     This is also a win.  AMD XDNA absolutely requires PASID support,
>     and apparently AMD GPUs can also use PASID.  So being able to use
>     PASID is certainly helpful.
>
> However, I don't think either approach is sufficient for two reasons.
>
> First, discrete GPUs have dedicated VRAM, which Xen knows nothing about.
> Only dom0's GPU drivers can manage VRAM, and they will insist on being
> able to migrate it between the CPU and the GPU.  Furthermore, VRAM
> can only be allocated using GPU driver ioctls, which will allocate
> it from dom0-owned memory.
>
> Second, Certain Wayland protocols, such as screencapture, require programs
> to be able to import dmabufs.  Both of the above solutions would
> require that the pages be pinned.  I don't think this is an option,
> as IIUC pin_user_pages() fails on mappings of these dmabufs.  It's why
> direct I/O to dmabufs doesn't work.
>
> To the best of my knowledge, these problems mean that lending memory
> is the only way to get robust GPU acceleration for both graphics and
> compute workloads under Xen.  Simpler approaches might work for pure
> compute workloads, for iGPUs, or for drivers that have Xen-specific
> changes.  None of them, however, support graphics workloads on dGPUs
> while using the GPU driver the same way bare metal workloads do.
> […]
To recap, how virtio-gpu Host3d memory currently works with KVM is:

- the VMM/virtgpu receives a dmabuf over a socket 
(Wayland/D-Bus/whatever) and registers it internally with some resource 
ID that's passed to the guest;
- When the guest imports that resource, it calls 
VIRTIO_GPU_CMD_RESOURCE_MAP_BLOB to get a PRIME buffer that can be 
turned into a dmabuf fd;
- the VMM's handler for VIRTIO_GPU_CMD_RESOURCE_MAP_BLOB (referencing 
libkrun here) literally just calls mmap() on the host dmabuf, using the 
MAP_FIXED flag to place it correctly inside of the VMM process's 
guest-exposed VA region (configured via KVM_SET_USER_MEMORY_REGION);
- so any resource imported by the guest, even before guest userspace 
does mmap(), is mapped (as VM_PFNMAP|VM_IO) until the guest releases it.

So the generic kernel MM is out of the way, these mappings can't be 
paged out to swap etc. But accessing them may fault, as the comment for 
drm_gem_mmap_obj says:

  * Depending on their requirements, GEM objects can either
  * provide a fault handler in their vm_ops (in which case any accesses to
  * the object will be trapped, to perform migration, GTT binding, surface
  * register allocation, or performance monitoring), or mmap the buffer 
memory
  * synchronously after calling drm_gem_mmap_obj

It all "just works" in KVM because KVM's resolution of the guest's 
memory accesses tries to be literally equivalent to what's mapped into 
the userspace VMM process: hva_to_pfn_remapped explicitly calls 
fixup_user_fault and eventually gets to the GPU driver's fault handler.

Now for Xen this would be… painful,

but,

we have no need to replicate what KVM does. That's far from the only 
thing that can be done with a dmabuf.

The import-export machinery on the other hand actually does pin the 
buffers on the driver level, importers are not obligated to support 
movable buffers (move_notify in dma_buf_attach_ops is entirely optional).

Interestingly, there is already XEN_GNTDEV_DMABUF…

Wait, do we even have any reason at all to suspect 
that XEN_GNTDEV_DMABUF doesn't already satisfy all of our buffer-sharing 
requirements?


Thanks,
~val

P.S. while I have everyone's attention, can I get some eyes on:
https://lore.kernel.org/all/20251126062124.117425-1-val@invisiblethingslab.com/ 
?


