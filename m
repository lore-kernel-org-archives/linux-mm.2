Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94BF0C531D0
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 01:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9C86B007B; Sat, 25 Jul 2026 21:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37B1C6B0088; Sat, 25 Jul 2026 21:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 244AF6B008A; Sat, 25 Jul 2026 21:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9E346B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:22:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DEAF80429
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:22:57 +0000 (UTC)
X-FDA: 85029178794.17.19ED37A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9D5E040004
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:22:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jz8cmKZz;
	spf=pass (imf11.hostedemail.com: domain of kwilczynski@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785028975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyTCZAktriT+3XjiU8QSnJdULFe900yJhuf5hFur5jE=;
	b=M0CJBi7D/vxXh9LqKEHxKRsvmQG1Qs9D4M+DD/lgISdAgkpPJS3/WnMPYHtTZ3hEcjYHUa
	nHwmBnF7Kn3w+FvF2RlpAMb3AVXbDR7j7gkGHAG+GmmKdSerdx/2hJQL/+z8b3mv/K2q7O
	DGU99M1QTFLINT7iQJb+H5FJc2PcbvM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785028975;
	b=PpQ4OW0SOJsesChOa9mWmo42ICSeblcAI5Ll91DKNq2Djjq5wD7QB4xoImwRVl2/OiewQ4
	VoNKTjH/k9SmzRQCOa3sbS0jbM7OgkPdIoxySnzjf8jjcO5EydiuouMGjSM8964eECEFoa
	z41L0Wk4i4sFQx6Y5KI5/0eB82yXuuA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jz8cmKZz;
	spf=pass (imf11.hostedemail.com: domain of kwilczynski@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kwilczynski@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 76FDD40911;
	Sun, 26 Jul 2026 01:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D977A1F000E9;
	Sun, 26 Jul 2026 01:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785028974;
	bh=kyTCZAktriT+3XjiU8QSnJdULFe900yJhuf5hFur5jE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Jz8cmKZz9LtgeRolgwPoA+JT8I76PS1lGeJwazDa5NfE8jd+NbIiX8Ts8CIQ88atn
	 MiEzihC/mqruRUyJ5Gj0gKWm3FqxpbUNjDtjshh99mRvGGOqpDyMeGdpuKTZDRmXTV
	 nd9CyQrFjxAfNtkkMtKt3RCZq2jyUVkbcHCYQ+GhoftDKQ0WMNYbg980pLty8AJzw/
	 R448SRFS0ej86PJ6sVlGek7XjITi+oFAm5HmMIkkm6ABEsF8CKPthna5LdfPv6z9H4
	 8osFUyiMr+R9A7FdmwRMrE7b4tewj4yQn0Y2fy/1A//toM+xXdhx5vUEpth8TN7BI5
	 9EYruvy6mibaQ==
Date: Sun, 26 Jul 2026 10:22:52 +0900
From: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Baoquan He <baoquan.he@linux.dev>, Pratyush Yadav <pratyush@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Simona Vetter <simona.vetter@ffwll.ch>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Dave Young <ruirui.yang@linux.dev>, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, kexec@lists.infradead.org, 
	driver-core@lists.linux.dev
Subject: Re: [PATCH v2 0/3] mm,kernfs,proc: Unmap mmaps of removed files via
 file->f_mapping
Message-ID: <20260726001049.GA2219014@rocinante>
References: <20260725210549.3716546-1-kwilczynski@kernel.org>
 <20260725143737.daa698b50289257fbaa9c6f1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260725143737.daa698b50289257fbaa9c6f1@linux-foundation.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9D5E040004
X-Stat-Signature: 7c4cxuyna9n9aaryqmheum3hsnzpeqat
X-Rspam-User: 
X-HE-Tag: 1785028975-174289
X-HE-Meta: U2FsdGVkX1/YJyWuOPR1n/X1Lws5YztgglI8iBEKRIBOWqy9/AqzUq2fIgX9c8BNTH7dF67Ry4Kg6rZ1ioT9rzsYYAEzwG7qRuYMZMEbUtd5aThg1FPIMkGPprGjKkKcA8xvIX4CYhCjZe4ET18gyXMAWyJCibqeg74KKm0mElDZPfRZ1H3EVzV9270BJ86D7ULl6wTL+pcN6YOfmUjLfuuwWp2Bcxz3rLsVdWivWuUpVAaoFzd7R6T+8fiGQqiCwaBIOmIVdphS1zf0z7qVWqVaQ9RGYxwU+z4EyaNrSl1j6q1zC9QDNhEHdPRfim9cJM8FOAsy4aegkneTnrF2iCnPGZ3I2Tc5rGSn1B/9aJ5fumOl15Wm/RBvaHXjTCvu/k6rMVkISxGDQd5QZWl7O6g67cw2qwDG8+HlAD3qU7hTvJDtxviT3k/nP13Pls57bSgCWN56PzBXxFu9FP8X5NbDrAeck9yn8blEFYcEiCXm89UZy+Ge4V3i/oyDnCS6bDtGXVccuCxi7xsAfpTi4Mxb+ukqr/0kOvWec2tv5oyrxR8bgJI180eRvCkRvk4LUDrU6v8E3dMtOIiCjJ8fT13PN3HlgWPm8egqAqr7QlX6zx6TcFVk+uh436gD5BWVauB0McYOKh/ZwXz6PubaaDVr87Ee93XjwDfDksTqRwH3iREcFIISl2+i/g9lDqUZqG++hFlozXJXWfqBK96aAdKR0+SAASzhRhSEPjLKvIyXFN7ENr5apgGSAEtSXjuBSvvT1HdKObkJdHbIQQrY7+Hea3b7ProQGEFMB1SB0olsQhpuANKxTfYu/M+k3NoYrEpB/AuyVnr9fIcYx60FgVOYn+3obEpp+Co/yURdpe4cnjttM3MbTrI0TLnqD10swsl6jABiubeIDCNkPntHoJpQHltyxGUVwy5gAM1tHNYVORRgIOoe+K7rme+upJKivXc5R2TkNQ7SMRmhbJe
 ANNqN3Sr
 36DmKJjLC6M+LfOpaviFWJmqfs1IJ0bAlKiZuNFMXrC7xYkZiEEvazgeU3AoOQFWb0H4SlJAJyoiZo3D3+pauNklz6c5xS9Mkv9n0WsveqwY2lDKiCJeeuxoYoWMNBoW692FBmrW8srUGT8nTCnTcrAz1ed1lR0AaeRvIAJiFdLQ2yX60RmJI6sc/m6epCo3ptXjnw8CTKshrR/7jKIDk0U60BJKNEnTzCM3vOoEkHP2AydHNxFUvBVws8PdsSekRbyOix/2zGYOOlmkoaxpnsZ8xboCZHTrXLtPMZ2cgHlqyj5xXH8GrxvhnLCIrkbLHmFn9PtLbWgM2kzMAZUPGPMbUXk/WFJIR0ejbBTxheA+qvd7mlrU4baGEErpeqDgVU324NaabiCShsEcaneJlpRlEIB8T10gE6/4W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

> > The PCI resource files in sysfs and the /proc/bus/pci device files swap
> > their f_mapping to the shared iomem address space at open time, so that
> > revoke_iomem() can unmap userspace mappings when a driver claims a
> > region, see commit 636b21b50152 ("PCI: Revoke mappings like devmem").
> > 
> > Their VMAs are therefore attached to the shared address space, which
> > neither removal path reaches: kernfs_drain_open_files() unmaps the
> > sysfs inode's own mapping, which contains none of them, and
> > proc_entry_rundown() does not unmap anything at all.
> > 
> > As a result, userspace mappings of PCI BARs survive device removal,
> > and also survive a BAR resize on the sysfs side, keeping stale PTEs
> > into physical address space that the kernel may have reassigned since.
> > A mapping made before the device is removed still returns the previous
> > register value after the device has been released, through both
> > interfaces.
> 
> Thanks.  Can we please have full description of the userspace-visible
> effects of this?

Definitely.  From the PCI side, to put this into perspective:

Without this series, a process that maps a BAR keeps a fully working
mapping after the device is removed or its VFs torn down.  The same
applies when a BAR is resized, as the resize removes and recreates the
resource groups.  Nothing faults, so the process cannot tell the device
has gone.  A read returns the register contents as they were, because
removal clears Bus Master but leaves Memory Space Enable set, so the
device still decodes its BARs, and, as these attributes are writable,
a write is still accepted and reaches it.  Those addresses are released
on removal and can be assigned to another device, which a BAR resize
does explicitly, and the mapping then reaches whatever occupies them.

On the sysfs side this most likely has been a regression as the
kernfs_drain_open_files() unmapped these mappings correctly until
commit 636b21b50152 ("PCI: Revoke mappings like devmem") swapped
f_mapping to the shared iomem address space, after which the drain
walked an interval tree the VMAs were no longer on.  The procfs side
never unmapped anything, so there the behaviour is new.

A read here returns another device's register contents, and as read to
clear registers are common, it can also acknowledge an interrupt or clear
an error the owning driver has not seen.  A write can be worse, as an
offset that was a control register on the old device may be a doorbell,
a reset bit or a DMA descriptor address on the new one.

With this series the mapping is torn down as part of the removal, and
the next access raises SIGBUS, so userspace gets an error instead of
silently reading stale or unrelated registers.  Both interfaces behave
the same way afterwards.

Tested on 7.2-rc1 with and without the series applied.  In each case
the file is mmap'd, the device is removed while the mapping is held,
and the mapping is then accessed:

  - sysfs resource read after removal:
       before: returns 0x18140241, the value read before the removal
       after:  SIGBUS

   - sysfs resource written after removal:
       before: the write is accepted and reads back 0x00000000
       after:  SIGBUS on the write

   - sysfs resource mmap, fd closed, then read after removal:
       before: returns 0x18140241
       after:  SIGBUS

   - sysfs resource mmap, moved with mremap and split with munmap, then forked, both read after removal:
       before: parent and child both return 0x18140241
       after:  SIGBUS in both

   - two sysfs resources of different devices mmap, one device removed, both read:
       before: neither is unmapped, both return their values
       after:  the removed device raises SIGBUS, the other still returns 0x48140240

   - /proc/bus/pci used to mmap resource, read after removal:
       before: returns 0x18140241
       after:  SIGBUS

I hope this helps!

> AI review might have found a few things:
> 	https://sashiko.dev/#/patchset/20260725210549.3716546-1-kwilczynski@kernel.org

I have seen the reviews.  Will reply to each.

Thank you!

	Krzysztof

