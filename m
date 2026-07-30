Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CA0FC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD1846B0088; Thu, 30 Jul 2026 04:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82476B008A; Thu, 30 Jul 2026 04:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70CD6B0093; Thu, 30 Jul 2026 04:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE406B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:24:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D0A01208F4
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:24:24 +0000 (UTC)
X-FDA: 85044756048.20.7C06D08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 77C391C0007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:24:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ChBSdYm3;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785399862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXQZIQoVKxftmgxSpsfIIxOpHqOtOFC0MrEElaZfb68=;
	b=xxtdJ45zuOs/877AX+77ClQv1Gu5F/6cHT0C6P4JVw3nOL1FmiB+ouO8QX263gmE4U6l3H
	TCAQDagTVXXn8gW51uPBSL4grOXnXgfWMZIpkT+wG3g3rDKnsMG/xA/5s8rNyN5jeqq7UZ
	kxGjWmzlie/Ht//wJtjfK9plF9cKf0U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ChBSdYm3;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785399862;
	b=6bXNOdtkWDLDRsxUF4IvcbjbGG9y1clVaz02F2SfijzJXbuS1UdNrx56s0CHeBi2xeDBKi
	sFC+j8SBRJ/qJDqYeBBaJSTtwWhMgzb4Kymn7KVCH7hqNNmVe+msnRAPKRDVLhTfORxB1y
	KZj4lA0lls3FUc4Sp4P5MB6doriPQE0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C48B40862;
	Thu, 30 Jul 2026 08:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDFE1F000E9;
	Thu, 30 Jul 2026 08:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785399861;
	bh=VXQZIQoVKxftmgxSpsfIIxOpHqOtOFC0MrEElaZfb68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ChBSdYm3VX7ZR8sCoLMTJcd3DQNuh7j0CXjLFvbLn+a+u1rJQcv051pGJ3Gh7onak
	 EjI4HcBfmFntcRanNhQ7fX1sACnhGJlyFu7xRwX8y13yNrOrxknwpaS7HbyRjgDZCR
	 EuIX5Czn+o72EjyfAMLyCKqWXb8M6Tn17jc7Lk2j7QaObnD42gQxrLhW+tl4HnaZNK
	 6v7pTRi0VcQDJFd1/QJDvwH7CdFCl8nCBLqt7cuow2NyHpCW/yWFM1i+MVQTBZBxrv
	 EgWn5f/ieaBn+l6gNk0KXMinAIZqPDl/bhZHxtyME403gUTL3pBcp5S9lWsO64aazr
	 DXS5f/gwAp32w==
Date: Thu, 30 Jul 2026 09:24:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Tejun Heo <tj@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Bjorn Helgaas <helgaas@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Baoquan He <baoquan.he@linux.dev>, Pratyush Yadav <pratyush@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Simona Vetter <simona.vetter@ffwll.ch>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Dave Young <ruirui.yang@linux.dev>, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, kexec@lists.infradead.org, 
	driver-core@lists.linux.dev
Subject: Re: [PATCH v2 0/3] mm,kernfs,proc: Unmap mmaps of removed files via
 file->f_mapping
Message-ID: <amsJ_T3qTJ-TJcwk@lucifer>
References: <20260725210549.3716546-1-kwilczynski@kernel.org>
 <20260725143737.daa698b50289257fbaa9c6f1@linux-foundation.org>
 <20260726001049.GA2219014@rocinante>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260726001049.GA2219014@rocinante>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 77C391C0007
X-Stat-Signature: nj8eoendoxxzfh13wjk6s14p5ofb6zef
X-HE-Tag: 1785399862-269061
X-HE-Meta: U2FsdGVkX1+Oesoe2r4+xcfaqiQQoOdYX3fc5s2/fBG5kRhW22f98jTsyzjO1ptCnG9OIsxaZpgzTQf6WEMFUsV1G3xV7keyV5NMBShgassbu11dFR7WshD0qNJXYHkHh5eZzfAPiGFlCFwQ8uRTuuC1wVgebbwTnia1Rz5B96oShHhWtoVk8Ag4Gvep8qILczDwRxTuspDZFo59+TfpAZXAvQtTRdhi8qL3oZUmnuZWwxya2ANCLWAdZVS+DJxaX89xKvshRcbICZeoGAkzbwcYNsq4eOm9D6CiiZm88JDecXJcyWPbxnlKRx4SkchGN8w4Ykt2aur/F40W9dvG37bli3h6RsHsiarX7BLDNc4kI46TOP2/QmDCDxolKYz5/QLS6Wkl6y8lgh3IxZj0ukgu3U3/KxYGLbm0fNwKLTglNYq11YUgdiGVqNYPWvCape4zIcCJPwscyhLQd+83ZXgtLmdLNWj6ksq97/tHsbajFLeR+czo5qnZsLfqNsBnbzSUP9+J7Ecmo0xnV3NqA9Bv083i5L24Z5VW2bC5BHUttELse77S9i29aI0CimK3F5yk0ipWdB/P4ENabSQsOVJ5+HTt16ZCFXUNPFKSRffasCsBDm0Du8EBxjKIxlZqgUg1bs0rkYNG5oYIzXryEGKXS9ltFOTUpzAtbt6YvRbyCFYZwrmWKLN7es9YjZc5qjPjw+3cdTwH2j/SyMaLLDgWyaYgqwAP9HpVMlKjy6H7Ih66dptfI/fyo9X8y8FZ703PSeiWiB1fsJe1GDeLhTo6fEBj3cX5kokh+KrN9EyI+a/ilQYd9B3/pMT0a292hvTYW4Y26Wil0Xo5ygDyhquEX467V2n8iAZLJtzJnXuQHKJhWNUiq6TDUooTKYDOJHzrguL19y+cQPsmDd7gGOFUcpcjfd16bLre495ETdXP0HSPXtlESlI/gNKEXa9rvuA+1JJsiyZR6i5KGiv
 78vTV2+C
 HCR5vzrnOiF7k1gQGg1yeKkVC8Gdqon1Lw5bXxId+q0mieyHUKYEPSQlQZlIvLL/eswFmI2e//rjsTsRhYGa+RZM+pymQN8/jTVoZQgVvn983aEoLmnYNSVOHUpXEaz2fN5xLMyoRrWJw67JygrDSb7NqTmlNOWTNwRwn9yS0gf62V4EUqWgFDAnuJSaCKGNOaXR1BT+eeNkFdf5dWQFr50PXzWlf/SgRvJFCUD+Bx+cewtfGp5iHxQoJIhWwGYPf/VFrAvWQH7fPRBM21Xc7LaPDS7oy9RELXSJVtiQSpNOK+FA4yh34dxigjdI236ZqwqLwZnAWNWp0RfEi0GXnwcP+Y/CvVWUB51zGmcmd/zKQM6JAqOLKVMl2V5Js5GQ5sRJA4nedFYH9Bk5Qe0zHkh1b78p9wlyclqRo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:52AM +0900, Krzysztof Wilczyński wrote:
> Hello,
>
> > > The PCI resource files in sysfs and the /proc/bus/pci device files swap
> > > their f_mapping to the shared iomem address space at open time, so that
> > > revoke_iomem() can unmap userspace mappings when a driver claims a
> > > region, see commit 636b21b50152 ("PCI: Revoke mappings like devmem").
> > >
> > > Their VMAs are therefore attached to the shared address space, which
> > > neither removal path reaches: kernfs_drain_open_files() unmaps the
> > > sysfs inode's own mapping, which contains none of them, and
> > > proc_entry_rundown() does not unmap anything at all.
> > >
> > > As a result, userspace mappings of PCI BARs survive device removal,
> > > and also survive a BAR resize on the sysfs side, keeping stale PTEs
> > > into physical address space that the kernel may have reassigned since.
> > > A mapping made before the device is removed still returns the previous
> > > register value after the device has been released, through both
> > > interfaces.
> >
> > Thanks.  Can we please have full description of the userspace-visible
> > effects of this?
>
> Definitely.  From the PCI side, to put this into perspective:
>
> Without this series, a process that maps a BAR keeps a fully working
> mapping after the device is removed or its VFs torn down.  The same
> applies when a BAR is resized, as the resize removes and recreates the
> resource groups.  Nothing faults, so the process cannot tell the device
> has gone.  A read returns the register contents as they were, because
> removal clears Bus Master but leaves Memory Space Enable set, so the
> device still decodes its BARs, and, as these attributes are writable,
> a write is still accepted and reaches it.  Those addresses are released
> on removal and can be assigned to another device, which a BAR resize
> does explicitly, and the mapping then reaches whatever occupies them.
>
> On the sysfs side this most likely has been a regression as the
> kernfs_drain_open_files() unmapped these mappings correctly until
> commit 636b21b50152 ("PCI: Revoke mappings like devmem") swapped
> f_mapping to the shared iomem address space, after which the drain
> walked an interval tree the VMAs were no longer on.  The procfs side
> never unmapped anything, so there the behaviour is new.
>
> A read here returns another device's register contents, and as read to
> clear registers are common, it can also acknowledge an interrupt or clear
> an error the owning driver has not seen.  A write can be worse, as an
> offset that was a control register on the old device may be a doorbell,
> a reset bit or a DMA descriptor address on the new one.
>
> With this series the mapping is torn down as part of the removal, and
> the next access raises SIGBUS, so userspace gets an error instead of
> silently reading stale or unrelated registers.  Both interfaces behave
> the same way afterwards.
>
> Tested on 7.2-rc1 with and without the series applied.  In each case
> the file is mmap'd, the device is removed while the mapping is held,
> and the mapping is then accessed:
>
>   - sysfs resource read after removal:
>        before: returns 0x18140241, the value read before the removal
>        after:  SIGBUS
>
>    - sysfs resource written after removal:
>        before: the write is accepted and reads back 0x00000000
>        after:  SIGBUS on the write
>
>    - sysfs resource mmap, fd closed, then read after removal:
>        before: returns 0x18140241
>        after:  SIGBUS
>
>    - sysfs resource mmap, moved with mremap and split with munmap, then forked, both read after removal:
>        before: parent and child both return 0x18140241
>        after:  SIGBUS in both
>
>    - two sysfs resources of different devices mmap, one device removed, both read:
>        before: neither is unmapped, both return their values
>        after:  the removed device raises SIGBUS, the other still returns 0x48140240
>
>    - /proc/bus/pci used to mmap resource, read after removal:
>        before: returns 0x18140241
>        after:  SIGBUS
>
> I hope this helps!
>
> > AI review might have found a few things:
> > 	https://sashiko.dev/#/patchset/20260725210549.3716546-1-kwilczynski@kernel.org
>
> I have seen the reviews.  Will reply to each.
>
> Thank you!
>
> 	Krzysztof

Thanks for the details, be good to put this concisely in the cover
letter/relevant commit messages on respin.

Cheers, Lorenzo

