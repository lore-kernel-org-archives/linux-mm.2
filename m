Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CAFE106B53A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 13:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DCFE6B008C; Wed, 25 Mar 2026 09:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3F66B0092; Wed, 25 Mar 2026 09:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1696B0093; Wed, 25 Mar 2026 09:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1C96B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:43:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A62FE0BFC
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:43:30 +0000 (UTC)
X-FDA: 84584702580.07.D3E5BEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5BF0080011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:43:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ODtAzKp5;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774446208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otF+zn0d3trZmX9ZyaUJIk8/upV26fxV92Ye+ApGpqw=;
	b=bo1uLBCLOq2aLEOlzE702Rr1FcMRQULTxWWRgfHZwzt9hOF3nxO9tiJQ0cXl39CqyNj3Pj
	OXFqL1OYPkbM0hw0ZI59rlf2hvbG2RD+n38x4G86rS0AKK0i6gQsNAqJxGfgX/cdZsT9Ti
	yO/DEXHpNByKIfo3LNIwGyaztIO97P8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774446208; a=rsa-sha256;
	cv=none;
	b=eomGO0FV3zY6YNddP+TyzwX+/w674e1yg/HtDme4Tyzg1mj4sZCoLV8UNHt3zlNtJu2weF
	bjVeoFymjjzaqWIr+HjuJkS1UP4RZPdkjEFZ7Q59vqIgg2TpApqaUG6gz+d8Za1ATAghfc
	9XqBNDD6ONwe9r0HSBl7Qv6oHiEct4k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ODtAzKp5;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ADF8E600AC;
	Wed, 25 Mar 2026 13:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A6BBC4CEF7;
	Wed, 25 Mar 2026 13:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774446207;
	bh=qxevTlxq6Ql+gdnUMuEobyzjtUWmEQEM7p+9cyL1w4Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ODtAzKp5cU4HDdomvw7sjdSs8IHMAYOOSxEs2h/rRrufXoBx4l+v61cnqidyuTOjR
	 iyslCByJgqr+gYe1bpcw+qjFkLYUy2aJBCrTv7KOx+rg/9hq5C1zQTvm6a8/0OKmDp
	 xXjVE9RyRH1deEzegZ4TCsOnQVxdwZsSvAa9CCFcC5wjmHDMcU8HW+oBbiOik87SmN
	 OLN8n4X7Jmzw1dtixKYNu9Iz2DUe+Au4CZmOQDmiYIkAkcjqZj1Bh791LYOoWgopPm
	 B4loXaMgr7w3ShZ9dyeuoE2TY9qrf2WGjX+ihaHCV+KkYfXDhqdALgObvmO/DiuGm3
	 oZal5k+Xpk1qA==
Message-ID: <bd916c05-504f-4d81-8020-45c5a563a2d8@kernel.org>
Date: Wed, 25 Mar 2026 14:43:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 17/21] mm: allow handling of stacked mmap_prepare hooks
 in more drivers
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <24aac3019dd34740e788d169fccbe3c62781e648.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <24aac3019dd34740e788d169fccbe3c62781e648.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: d95japwf8uyaq7ssddftcmuj3njb9cq8
X-Rspamd-Queue-Id: 5BF0080011
X-Rspam-User: 
X-HE-Tag: 1774446208-7306
X-HE-Meta: U2FsdGVkX1/V+X8swl0SB4YyTGCyJryFmvYkT8U4dloblVAx016ITRt0oqBITcp8/8O+o7OEBAVzeKFEvhP5CnYxiJiuxhf54btz53eY6Adw5GYcmLnpLJZoZ/CzDx4L4xgkbei9jF2fXFObRf9ewnc3mvYBOUWt438rueRhwM2btm+qQJmK6WxmDcBay8r5G0gwm2Hexd2jMAFBn+tiGO8JVsw3C0G7+mbfB5lvC2jATMwUx51qVhku+H5tT/5sAmD/y1hPczOcAt+Gi75dq47t1/VizGN5jw8CiOdPhKTCdX0Z+Bt724FnavA1y5IXMn1AgvtFQ89fDUJ9YJYMRQ+76+VZaXx53kR/+2odCRuj6Pzs2flzdhr07fiFz+9C1tdL9SmIjO/rPnTQh6kxPEX3WELO0WV2LlN2Mjp646j0EuLKeFoAZkQu/GA/hp6acpXZYW/aMEhkqaX2B1Bim/NyrIsmK4NZ92yo9ygGaqg4+gU40tEbRVrgzPMR5AKLdoc4mQypbNv0+i4wA5pM3GLzU0kgaFZ9EQwoRK+iJ5BkDGopO6uG8JmxdArM07ZBiBWYt85mky1rPZ/alCahTFRQTrfPr3w1tuzCiTnOAjHVRxijhMILPyVMxWZN/Lth7Ou+XmAvgPrhgn+iI3NpJ6b/LwfyVkXWuW+jX6LgUI+Y18qQC1JRwWoxbvSPbIPK+4Ysw2G9Tfd5KPokjsabM85xYGnndmpItFHZrnRHtoQNhgmrGgNTEmlEDMU3pf8tdNHpFjxfYNkbdJXkpy8sqJmMfVOa483xpG5zURHcJPGskcNv1HUsYhh7EE5qAQmfa6S8hIFmxzwFasbE+ed6nVtRJEkD2st1DhbaQgJ28wfBQ34yrvboT8unkUWccFYw9v4k53C/PIMg0MQWe2Y9dGA+VzxVgN8ASxMJCJUIreilmUA0KhStQc5Emi6Nsc7NmuHRDUsyplztFCYgap/
 5Zfb0Je8
 /+Gi7h1N/80XA0+yFiFoxE+E1mPV014zg8XnvUyprexY2Y/dJJciwQ0+FNuudbkMXpsOyCZHTHowsLOZAZ0GuM9WCPZ4KFZO9Q1z6QnXKpcmbkUrIxacHCIXGQuvublWEthqEqguQ9ja7nbJh5iRSBz8tFpf18sQ3f7zeMkZeKOCUbEz15rBloKcD0S9SfbbwM6haLky2tJGH0fSRy56uE7/1sNsjqiZKLMfCXgEGK3DKKAuSflpjc+5yfaaZDMDRSAip++eqztnMgr8FHVMT20dg2Dr+9iUsKMq1ME+T84KcqWMxFGucS3sTFncg+viAxkGodSW+cYxov89cSi8rtGN0+IHLpvs5RxeMHbSgzcwXxyT1/kpGHxRyxulRSlzzBlWLOr4Oikn/eYwmyS3RdJguKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> While the conversion of mmap hooks to mmap_prepare is underway, we will
> encounter situations where mmap hooks need to invoke nested mmap_prepare
> hooks.
> 
> The nesting of mmap hooks is termed 'stacking'.  In order to flexibly
> facilitate the conversion of custom mmap hooks in drivers which stack, we
> must split up the existing __compat_vma_mmap() function into two separate
> functions:
> 
> * compat_set_desc_from_vma() - This allows the setting of a vm_area_desc
>   object's fields to the relevant fields of a VMA.
> 
> * __compat_vma_mmap() - Once an mmap_prepare hook has been executed upon a
>   vm_area_desc object, this function performs any mmap actions specified by
>   the mmap_prepare hook and then invokes its vm_ops->mapped() hook if any
>   were specified.
> 
> In ordinary cases, where a file's f_op->mmap_prepare() hook simply needs
> to be invoked in a stacked mmap() hook, compat_vma_mmap() can be used.
> 
> However some drivers define their own nested hooks, which are invoked in
> turn by another hook.
> 
> A concrete example is vmbus_channel->mmap_ring_buffer(), which is invoked
> in turn by bin_attribute->mmap():
> 
> vmbus_channel->mmap_ring_buffer() has a signature of:
> 
> int (*mmap_ring_buffer)(struct vmbus_channel *channel,
> 			struct vm_area_struct *vma);
> 
> And bin_attribute->mmap() has a signature of:
> 
> 	int (*mmap)(struct file *, struct kobject *,
> 		    const struct bin_attribute *attr,
> 		    struct vm_area_struct *vma);
> 
> And so compat_vma_mmap() cannot be used here for incremental conversion of
> hooks from mmap() to mmap_prepare().
> 
> There are many such instances like this, where conversion to mmap_prepare
> would otherwise cascade to a huge change set due to nesting of this kind.
> 
> The changes in this patch mean we could now instead convert
> vmbus_channel->mmap_ring_buffer() to
> vmbus_channel->mmap_prepare_ring_buffer(), and implement something like:
> 
> 	struct vm_area_desc desc;
> 	int err;
> 
> 	compat_set_desc_from_vma(&desc, file, vma);
> 	err = channel->mmap_prepare_ring_buffer(channel, &desc);
> 	if (err)
> 		return err;
> 
> 	return __compat_vma_mmap(&desc, vma);
> 
> Allowing us to incrementally update this logic, and other logic like it.
> 
> Unfortunately, as part of this change, we need to be able to flexibly
> assign to the VMA descriptor, so have to remove some of the const
> declarations within the structure.
> 
> Also update the VMA tests to reflect the changes.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>



