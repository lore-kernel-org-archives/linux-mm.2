Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A938B606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9WnOT/l
Received: by kanga.kvack.org (Postfix)
	id 33A0C6B0723; Tue, 24 Nov 2026 09:11:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3D96B0725; Tue, 24 Nov 2026 09:11:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B826B0726; Tue, 24 Nov 2026 09:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA6376B0723
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:11:53 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8EC11A7DFE
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:11:53 +0000 (UTC)
X-FDA: 85470201306.17.F9BB0EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6F12120011
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:11:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="t9WnOT/l";
	dmarc=pass (policy=quarantine) header.from=linuxfoundation.org;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795529512;
	b=Slqkr0Oqy/x9c59BOxYODrL0TZn1zhdHWHog1kOZTY6NNN7pyOF9LOFy6W9JLU4DHyIb0X
	ByOTXZJ4YivuFfMnwpFM0NehTDHmaLSU3N0sFociNIGOh228Z4sk4sXjInnpusM/ZXQML2
	KT4ZuQ87njyPyYPUZf2ChWr7jcgm8N8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795529512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rdhE7rZLDvGkNusxDbiDfsrpFeB7AZZOY+HkmAjee4I=;
	b=Axt6+WhLsHS1gMDcLvoaD5tWAdjlVjknqLsHWBtNl/mOyI0RyMzqNUoqyM2i+P1adVWf90
	TtgTj0tc/9mpsXY4TGFGT2Qnqt1Xk/Pagxg/ErvCAC8yw7uSsfIKltoAxkqDH9gxIBwWbk
	XzBCQL2WCB8BDHy69Q8GIclAKXd9arU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="t9WnOT/l";
	dmarc=pass (policy=quarantine) header.from=linuxfoundation.org;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E0F2741A87;
	Tue, 24 Nov 2026 14:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59C61F000D4;
	Tue, 24 Nov 2026 14:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795529510;
	bh=rdhE7rZLDvGkNusxDbiDfsrpFeB7AZZOY+HkmAjee4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=t9WnOT/lpp3Ut2M0J1XMz9tDKU9Z4D7OycyFFXgwDMy+IwRJq29FXuH4yLomyNA4o
	 HANE+JYrQrzclYZiEbZHGTyx2wGFk3tl5cpNcXEYXA9aybIPID426k8dXdsC0tXoXW
	 4zWD6cpHbUWiiv/WDFVzJt+vpyXilPRECrLEFz9M=
Date: Tue, 24 Nov 2026 15:12:11 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Eliav Farber <farbere@amazon.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] uio: implement huge_fault support for physical
 mappings
Message-ID: <2026112459-oversold-suitor-c527@gregkh>
References: <20261124131510.38745-1-farbere@amazon.com>
 <20261124131510.38745-6-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124131510.38745-6-farbere@amazon.com>
X-Rspamd-Queue-Id: B6F12120011
X-Stat-Signature: ykwtjyb5otmhrmx4uo6y35uh7p3u9p85
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795529511-644221
X-HE-Meta: U2FsdGVkX19pGTAM9eqZq9s2ZddbYCW/PmxqJvLM43VcYmHqmwm107lQLazE/c50UVmiZ+bIqvW/faONk0W58MlkyaeIq7kqgmkyhiMF1S2Vb1Z7FgXDCegekZ3BiqyGei1cyrgHWClvE/kV0+AP9Pnn8FvXje3SmPxQPMM4aQlTC0MYQOxWByjgVGw5yAYtR2UJ0xXCWdkoMgTQZ0cWJ9CByoaak6v18jOotM7u3LS7Bd56/2Zd4Tiy3WblLpQFG3VLBlze93U1WxHZZS5o0W/hMM4Oh/rPh1puLIi0tUwL0dfIWuUUsLSd8SSaDEjx8fBIC+z6oYxIRkhDnckw4B4Y2BfcSlhpIrpLyAvPyw1NPYdtOwI062M2Q5xiuKwy/umNtp/XvlCdpYHB0G3pc2rSusqLu1gdeOQdmzt2SMjO9cHldZkHMJJpa+ZWsVDxSblKfgbQ86o2WwovqcwEP8ZWBQ9g6rQprzlh/bATcQ5U0JG0HgKsb6iNvq3D9qAasoFNWD6td6fByKSh8Z3uOjU1T8aaHjKJj0npieFJiAbKGjDeY4kowrLoc/VJ/zkoK2iz+Ig2LsP5LyDthhUg6RLHPnJNlHzlM0Mn9JbgLNOHZ7KKdDIaWxoewlKzHqNLRpvuGZGBge9GBmAo1cZSrr+WHVZ9An4CTukHy+CbCl32VkcVdaxYs6g5NsbhmjzAG4rAMxLeZ6wzyVv4QAoP7jHl94wxsWWzySuIZLwsVgO4xEXAIr8fyDXAU2P1EZN7S8WBwVfZcfGB0jkftpe2+QBuUyUNsDLK924cwgMN32sMSc4eqrG79/B91zkLwQcHUhRRz6sB/ceout9R9ga561RxD0AW81MfOnvhnD4w3zRIsJQhhtP6i/GF3L9kbISHkkxWeNqPam1y/WYfIu6tgNVyfdiFFaK9i+cPBehjidg3fN0+Zn3UUhpOaw9H/4O7FESNeJ6Hd5Yj1QMQggz
 GjIUAEPp
 m9DUTT6sVJXgnq0JDK4JLB90SF+Z8MTKwVEsfVYXSciLIvuz2/gsXRM73jGWV6oVPRQRFecjqJpzDorqxlbzOooCMjwZeWSI0VjHr+SU/K6st63OoIIL6EDJ/5CISOvy8eCMWC3+c3zJzCfKW1qqKfbAASHIkueQ3b0vxtINMSrOhSTkhImuJr60oGISZ24bUIVY6RgIz8byNJIU1ytY/u5rHh2eeJ+pDjpK/TIj2Pktfhh5IwQpHwdUNytgqHIXt3N07l+MiDz9IG8EM4pM9TsLpGL3zXP4k5CTIQLlrJfDiGtw94hT3fCqsafHG2EgDfk4vz+vWSajbvxPC6oMlouPI4NlwjnTBt+BAiQWt8pyCXDnRp1Vv1BXgibaLmOoOysk6rd0mvdMS7AtJ+Vji5arIwpqw3sI+VCPOWTF6BJtc+9yxkOho6PXWv/1so5aCq/8AjhnzHqUCxciMzSPXwR3LIb5HpEoH7tRtscqWSlyJBqc3Ak8Yq78sPBXtMAbwNPlEN9k7oyoqaaTtNRkoxqb0OoFW1OOBx6zbHyVCaf+lLRdL9SOppQocqQpyRI4H8msvYaN787h/Yt89L+QOVAZtf71rrEJl6eNr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 01:15:10PM +0000, Eliav Farber wrote:
> uio_mmap_physical() maps UIO_MEM_PHYS and UIO_MEM_IOVA regions at mmap()
> time with 4KiB PTEs, however large and aligned they are. Populate on
> fault instead, as vfio-pci does since commit f9e54c3a2f5b ("vfio/pci:
> implement huge_fault support"): call track_pfn_range() rather than
> remap_pfn_range(), and add ->fault and ->huge_fault handlers using
> vmf_insert_pfn_order(). A large enough aligned region is then mapped with
> PMD or PUD entries.
> 
> Like uio_vma_fault(), both handlers take idev->info_lock and fail with
> SIGBUS once the device is gone. COW mappings keep the eager remap.
> 
> The fault handler needs the base pfn, so vm_pgoff now holds that instead
> of the map index, as remap_pfn_range() does for COW mappings.
> /proc/pid/maps reports it as the offset of these mappings.
> 
> Once the device is unregistered, an untouched page gets SIGBUS. The
> eager remap used to keep it mapped. A remote read through ptrace or
> /proc/pid/mem of a mapping with no VM_READ now fails too, where the
> eager remap used to leave a present pte.

Why in the world are you using UIO for this?  Why not do the right thing
and put your driver in the kernel in the kernel itself if it needs to
access large mappings like this instead of hacking around the
"limitations" of /dev/mem and uio?

Do it right please.

thanks,

greg k-h

