Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B4D2EC01A4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704CD6B0005; Mon, 23 Mar 2026 05:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68E0C6B0088; Mon, 23 Mar 2026 05:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555AD6B0089; Mon, 23 Mar 2026 05:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4027B6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:13:11 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E9CB45BDDF
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:13:10 +0000 (UTC)
X-FDA: 84576763740.01.F7A7006
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 69E5940008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:13:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=joSxwlsp;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774257189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50lipdLdy0rn0ZzFb+/og0BjrVfYMthBF9lHaKHPaS8=;
	b=CMGjMki2HO+Zh7KhbKz42pi72bPJ6TnMdFCaUxNE8HrYaYr5IQbQ6Mx++qYYyqUq04fpQE
	IfjAzVrbgrbivuekYvYH4Qx7dUgGRIqhDv25ltqQi/mleoESu9stjmGGlIZ138iQUxe+cF
	V3gmFjgmBAPNo+UtirGXo4pdAhBLndU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=joSxwlsp;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774257189; a=rsa-sha256;
	cv=none;
	b=w4sfW+O4abTEWDMZloUsLjrIvLSMTD/xCUg9P/Zs7wlzDYld3Kls9fdN1aDLmJLtZYFgYv
	6S4AyPVZk5TmoybO7MEs7gYFNtVhhOzCyQgZYfC/jIoYIdHZtK/5DlUli2Xw8ZNI99hjSQ
	2VQCrCzsF30z37tRVFx/4UD+LsBAiUc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E411D600C4;
	Mon, 23 Mar 2026 09:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06702C4CEF7;
	Mon, 23 Mar 2026 09:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774257188;
	bh=wzMrqKx3Jtzn/TAs56FycVP5WjxG7mSofPlph6puuTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=joSxwlspVhKYcgE4zizMzEupkVxH7zBoRt16ItgpGqtktF8hLPrEEOTxfgh4aRR46
	 H0U9alpLsA83SdovjY4NjT0S8IVfoGCFHfdV08wBojK7QatPitGsHroy+nurmzIUo5
	 9LTrYrheRCty7XcM5Hdcd35jJVYk4YzX2FwqnAgbFVPaee1S/zk0OOYbb6dWKe54SV
	 Qejn61X7CFhOqRsAbeUsXpGiEPrzUHGPx8hpLYNbDN7Ghgx9DVL33kddcsAYc4j5Sz
	 AmCzqaip3eo7Xnd8PbIQkYXGzXvvJm8fegMwy8XoqhfyH8Ytxfa3hUrWvBicIE9Bu0
	 C1NjdvWhW+Gjw==
Date: Mon, 23 Mar 2026 09:13:06 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Michael Kelley <mhklinux@outlook.com>
Cc: Long Li <longli@microsoft.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, 
	"linux-stm32@st-md-mailman.stormreply.com" <linux-stm32@st-md-mailman.stormreply.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, 
	"linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v4 18/21] drivers: hv: vmbus: replace deprecated mmap
 hook with mmap_prepare
Message-ID: <409ff1b0-43ff-4b1d-ad07-7624e0817640@lucifer.local>
References: <cover.1774045440.git.ljs@kernel.org>
 <05467cb62267d750e5c770147517d4df0246cda6.1774045440.git.ljs@kernel.org>
 <SN6PR02MB41573DF211DA2469D7FFE892D44BA@SN6PR02MB4157.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR02MB41573DF211DA2469D7FFE892D44BA@SN6PR02MB4157.namprd02.prod.outlook.com>
X-Stat-Signature: wxa4b5tw9zmseh3c5sqkgqbmydbz5an3
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 69E5940008
X-HE-Tag: 1774257189-506501
X-HE-Meta: U2FsdGVkX18bHYLer1wjiZLcKyvGkZsBFHBG1AjEa3CQ4FW8F0tHgzm4dhL7u4xKlQqQll0fzdTmWE9naNSynLbbIMYEx1ru4mSksk/X4RagwA87ARVIqONBuhzZbOiP5I74tyMP6F7i5p8lfSxpwQRgeN1vvk4vNg/MX/2v9l33Ow7RrNFs+tb0DKiN7YcuZuo5YkA6FoM2emBmsYSdK73hTry5pgEXtnoF+OLC3yTB0xCFYfSEWzlVNoX1HQigdKX0Jcj0TU6HtjRYaAutZDxNSWMnWuvTgQFQJnd3TduHXUt+rauzb6uSHVylcifzH4gVAKZ+uH6ztplHWrX8ByEI5xDG7Qc3sIWvMWesU/COVWRR4fgJpyd5fgxQwDHx0GRiYDRnBm5mFlmhTTx4Uta3krrG12Xeif0Bb+lrEowUkao0gF0pq+blIiUZQzWebjw86266SChOTnZE8fsTYcZk7vHARZXCjG00dlFtfOEZyxwrFEoI9Zw/xfkJIMpsj0IDt2C12eiLAKVT67g4hhBd4NXwuZxQb4QmoFQUROIjJx/3GIe3hQ+boKit/7Rn8yzo2vJYfUryJXbijm73h2Fyj2s6rLufvHUoLchFQPZZf89+y7AKjbf2yNIGGycR9Ag5AwD95TXuZTbTEoUdgwX9xWXYhxZmLKdG95aV3Rrx8as3KXzzWhbvAk9Up5S3A+X/uFoSqGfHL5ranVTWj+E+L8o2XBWsdj+al6xQIRSdLV2m0XDje+ud3h3E+nLYUE6KZpLn5eInXyzGenahZ+3dIug13hH96UIcDQuVrbb4kOFpcQ2pZWqvjKOWF3w6TFbMXS7tgiYuKa/Xo0I0NL76FXkAxNgZfRMjx0CEgE1L/cjJy52+wC2/m08rKXs4aaonj+X602pYIo4jn2AlBP9vf9MLi2QTmEFJos3tOa1ogLkRbFaRdJ8SzrK7kW//wsR674Ztk2E+R4j8l/H
 51o10em3
 hPBjgnW7X6uyyz3nN0cUKb91mJTWZSramnsCYQYPBf+ZHj6mypZqWX1FHl6SoiUXtkjpgTjFSU6ABGBpJ7wczh4ZAPb4kA3hFnyNrjfWntQ82Kbj9OmpD5oM42eB7/lpPQNgFSX472UIgskaV1RlEjZ1Y+FYOFbXoNRDGxk++dL7Ivp1UYTGpkNWIvJaXwwvQ3SPmo4qKj7T020DmZe+U3JmX4r8YUjW0fn9fTl981oi2NmBXTfikcE6ihM2OyqNSSxrlB34HBDTUHeNg+DBYYHtYl65t9hjYX4t03SSKD/tczy1uWx9RxZk0WeiKbBocfk5sALxE6UxydWMijkcg6XxyEjkbhXn+dmVNiK2g0NqZDcmLFn+Xn8CsFyw1v7NQL7ltR4grnemAxsDhT1fdB2YHk0TfIg+GCL2F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 04:16:20AM +0000, Michael Kelley wrote:
> From: Lorenzo Stoakes (Oracle) <ljs@kernel.org> Sent: Friday, March 20, 2026 3:40 PM
> >
> > The f_op->mmap interface is deprecated, so update the vmbus driver to use
> > its successor, mmap_prepare.
> >
> > This updates all callbacks which referenced the function pointer
> > hv_mmap_ring_buffer to instead reference hv_mmap_prepare_ring_buffer,
> > utilising the newly introduced compat_set_desc_from_vma() and
> > __compat_vma_mmap() to be able to implement this change.
> >
> > The UIO HV generic driver is the only user of hv_create_ring_sysfs(),
> > which is the only function which references
> > vmbus_channel->mmap_prepare_ring_buffer which, in turn, is the only
> > external interface to hv_mmap_prepare_ring_buffer.
> >
> > This patch therefore updates this caller to use mmap_prepare instead,
> > which also previously used vm_iomap_memory(), so this change replaces it
> > with its mmap_prepare equivalent, mmap_action_simple_ioremap().
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  drivers/hv/hyperv_vmbus.h    |  4 ++--
> >  drivers/hv/vmbus_drv.c       | 31 +++++++++++++++++++------------
> >  drivers/uio/uio_hv_generic.c | 11 ++++++-----
> >  include/linux/hyperv.h       |  4 ++--
> >  4 files changed, 29 insertions(+), 21 deletions(-)
> >
>
> There are two mmap() code paths in the Hyper-V UIO code. One path is
> to mmap() the file descriptor for /dev/uio<n>, and the other is to mmap()
> the "ring" entry under /sys/devices/vmbus/devices/<uuid>. The former is
> done by uio_mmap(), and the latter by hv_uio_ring_mmap_prepare().
>
> I tested both these paths using a combination of two methods in a
> x86/x64 VM on Hyper-V:
>
> 1) Using the fcopy daemon, which maps the ring buffer for the primary
> channel and sends/receives messages with the Hyper-V host. This
> method tests only the 1st path because the fcopy daemon doesn't create
> any subchannels that would use the "ring" entry.
>
> 2) Using a custom-built test program. This program doesn't communicate
> with the Hyper-V host, but allows mostly verifying both code paths for the
> primary channel. As a sanity check, it verifies that the two mmaps are
> mapping the same memory, as expected.
>
> As such,
>
> Reviewed-by: Michael Kelley <mhklinux@outlook.com>
> Tested-by: Michael Kelley <mhklinux@outlook.com>

Perfect, thanks so much for this!

It is tricky for me to test these, beyond fairly exhaustive logical
confirmation of equivalence, so this is _hugely_ helpful.

>
> The most robust test would be to run DPDK networking against
> UIO, as it would communicate with the Hyper-V host and use
> multiple subchannels that resulting in mmap'ing the "ring"
> entry under /sys.
>
> @Long Li -- I'll leave it to your discretion as to whether you want
> to test DPDK against these mmap() changes.

Thanks in advance for taking a look on this also!

>
> I've noted one minor issue below.
>
> [snip]
>
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -1015,8 +1015,8 @@ struct vmbus_channel {
>  	/* The max size of a packet on this channel */
>  	u32 max_pkt_size;
>
> -	/* function to mmap ring buffer memory to the channel's sysfs ring attribute */
> -	int (*mmap_ring_buffer)(struct vmbus_channel *channel, struct vm_area_struct *vma);
> +	/* function to mmap_prepare ring buffer memory to the channel's sysfs ring attribute */
>
> Changing the comment from "mmap ring buffer" to "mmap_prepare ring buffer"
> produces awkward wording since "mmap" is used here as a verb.  It might be better
> to just leave the comment unchanged.

Sure am happy with that of course, I think Sashiko moaned about this but
it's obviously fine either way.

Andrew - do you mind restoring the comment to its original form above? Thanks!

>
> Michael
>
>
> +	int (*mmap_prepare_ring_buffer)(struct vmbus_channel *channel, struct vm_area_desc *desc);
>
>  	/* boolean to control visibility of sysfs for ring buffer */
>  	bool ring_sysfs_visible;

Cheers, Lorenzo

