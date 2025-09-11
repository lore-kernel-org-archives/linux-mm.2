Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E56CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 08:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207668E0008; Thu, 11 Sep 2025 04:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8858E0001; Thu, 11 Sep 2025 04:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07F708E0008; Thu, 11 Sep 2025 04:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E7D948E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 04:55:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0E57B9559
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:55:51 +0000 (UTC)
X-FDA: 83876361702.13.3C13F22
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7F289C0013
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:55:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H06dORKL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0iIQ+Ipq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H06dORKL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0iIQ+Ipq;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757580949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+JbXqJwzf7cOodAKH9xqcseUyaAMBde80ixVE0ZgKU=;
	b=7JjHIamgf2CZ6X2tUSElc2Xh9u5b6dfciYKfYzfRelKFzaAfonTr6hC/JB/tPNtXmqIwVB
	rAdrryIDK3XUMZT5cKUvmPvMjcQF/Va2Pws3+FIF41UD1FLnmZ/0goW4AkqH3N22fchpoJ
	8FhuHR8cG/fg2KjEWQAYD2s8oMHkmlc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H06dORKL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0iIQ+Ipq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=H06dORKL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0iIQ+Ipq;
	spf=pass (imf28.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757580949; a=rsa-sha256;
	cv=none;
	b=oopH0jbNVoSW2yL0AH5XbDwuYL+nbKVzz86yziKpHzcJGYp5gEu8qgYvscHzQWuun7aCX1
	GzQ2EuO4F8LyXg/CquFkMGBRY0azziPQSfHdE5ZgTEvvL24N+XcwdNS0UV+Mxdc34S71mz
	HGJJSglEzQM/uqHdNIx1TcLFqdZ2hQQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B730E68010;
	Thu, 11 Sep 2025 08:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757580946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+JbXqJwzf7cOodAKH9xqcseUyaAMBde80ixVE0ZgKU=;
	b=H06dORKLeqy9oLKCwBAyy8KbyMMgBGmw2umEdwRHB5t4//gwrPu6p/UqepgBh+cqtCMGYj
	gu16/N0MH0OUE8I2dmmLR/foB3LQlqym6FvW7Qq9xnnjWKvZeFtm5D+PPNO1HxnjqxADHx
	R9Jg+XWpXeRhDFWLoByfZA9usPYkdhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757580946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+JbXqJwzf7cOodAKH9xqcseUyaAMBde80ixVE0ZgKU=;
	b=0iIQ+Ipqu9W5Px/nULTByH8LjK8QRRM8NgGXedpdy+DrzCu/JG3h5fU1YWI+FWRaeWdOMk
	PDTOzamFaGTIDVCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757580946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+JbXqJwzf7cOodAKH9xqcseUyaAMBde80ixVE0ZgKU=;
	b=H06dORKLeqy9oLKCwBAyy8KbyMMgBGmw2umEdwRHB5t4//gwrPu6p/UqepgBh+cqtCMGYj
	gu16/N0MH0OUE8I2dmmLR/foB3LQlqym6FvW7Qq9xnnjWKvZeFtm5D+PPNO1HxnjqxADHx
	R9Jg+XWpXeRhDFWLoByfZA9usPYkdhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757580946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g+JbXqJwzf7cOodAKH9xqcseUyaAMBde80ixVE0ZgKU=;
	b=0iIQ+Ipqu9W5Px/nULTByH8LjK8QRRM8NgGXedpdy+DrzCu/JG3h5fU1YWI+FWRaeWdOMk
	PDTOzamFaGTIDVCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A7DA113301;
	Thu, 11 Sep 2025 08:55:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pmj1KJKOwmjpeAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 11 Sep 2025 08:55:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 5F916A0A2D; Thu, 11 Sep 2025 10:55:42 +0200 (CEST)
Date: Thu, 11 Sep 2025 10:55:42 +0200
From: Jan Kara <jack@suse.cz>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Guo Ren <guoren@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, "David S . Miller" <davem@davemloft.net>, 
	Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org, 
	ntfs3@lists.linux.dev, kexec@lists.infradead.org, kasan-dev@googlegroups.com, 
	Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 09/16] doc: update porting, vfs documentation for
 mmap_prepare actions
Message-ID: <xbz56k25ftkjbjpjpslqad5b77klaxg3ganckhbnwe3mf6vtpy@3ytagvaq4gk5>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <e50e91a6f6173f81addb838c5049bed2833f7b0d.1757534913.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e50e91a6f6173f81addb838c5049bed2833f7b0d.1757534913.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 7F289C0013
X-Rspamd-Server: rspam05
X-Stat-Signature: poyqjhcbaasaxgf4xsjhzbrg6hrr3nxm
X-Rspam-User: 
X-HE-Tag: 1757580949-949308
X-HE-Meta: U2FsdGVkX1+8EMrfFgj9t40u9C3zyqCf5VnDsorR4kEOAwQOg5BU3W8EWRkJEmU1cvbFiCkSdnk3+Ci+3LbfBN4rvSli6UgEQJk97sZFqdxgOMUEx2BPgptEWsIT+vDv9WhBkMAc1GlE11ZYZp9ytskwxdflNWbIVnUIUpAkyDPLImtZJoOcc9Yyysfi0UJRNloWLxgx8xvLH5uVIqJ6kNQg/cQ/PS7zomjIJ4cs5uQgPn4ohuNBwpoPxrLziuiDxJbP6+GNzf4b2C8TKizTlSzkKbTYSN7BF5suwoj56mY/OgfkhLUdo7P6jNDkxooQhjyoWv1NBg3X/HLB36mhh4WursvVPxGQkP+1Bqvk05h+eCCoAnpTkLLRDcpEX7VTiAxnqXKUvAhel0k26FpHQkc5jNOAr7tv3uFF/uYS6dOra15KEDViyUYbL/GyEsXRNM2PphXzFvWQfZ32MrwtmQqLnI9xPDbX1IwJG0rOA5KOHLba+b//nRHE79D6PtaX/DgyWzbyaMLdpXYwRI1SUY1SqByUqoZHPWsPm3gL+0qn0gnWJvSLClyorTHguIZiDF3KOGh0ZoPpofgo13p3ew4hLQEy0dqibGh4S3B+zsFwZ+MbjuZ8B1knnyvPOytNFNwbZ6kPl+9f7ked9K+zl0HgQ/43ttCsWBSutzW6BtdwyHJDaC3WncUCUdQOEu3+EdotyUUlwgWIchtSwQPUmJ9Q4ya1eAh47GYwYODCX3LC0qjQLJBRFjrSPUBidmWbRxA0kSsXwPNkCSE1DW35blqnFR50MB44cz9MJsxOOCNmyXBaLkl3b0Rup1bisUaLY+LGD+W25kDVY0oyxYg3TBz9rOpfB0ZjQJQcXp0eou6rRFZGbpVgNbU0M8BCaT+Mc+Zs7PP8FzE/pG1OR3mFl0NbiGHHNnwBxthlJFjKVuvrJIhywtXoJJwK+3E+ZitEL5Yt1FOM+P0R8SxfrXa
 rq+aMGYO
 kTr/4SDBwwIATCKh3zdFdNosKl03SrmwTZ9zQyIq8c4woMo+MyMxAXvpvxPUy9zqPatzUUzbDYVcVhA4fR74E9XwmRkJXKiCodpd4m+01jOJzrrUWhVUy3eBWw8CalDotEyvNtmCViRZxnJBzJIZnu8Ozv8X0nanieQRZJC5ONlyI2YqVPdS83ZjdyKul5ePkM+N2gUviXZpycmTQsuQpQnN92+MnTgLVa+qoDybWvxxjXZu2aAuyqAxjUlQYB0G+msg+vQTA2TdRk4F4A0vItgY03oiU8u6iqZl0G/gJDu6DRDCG3GwuloAcScrJFq//t9+Klm+OpO+yNCEFKSWJ9wW11U7KmwWNT0n0tYxHwVtYSucvQ1raxpKaCxBlyrX3x/KYX1EQJQUUXOpG0hfz/t+IiRz7MfxPDPoZFla6SzozJbWiT7Vf3aTTYavu4MPd5gOx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 10-09-25 21:22:04, Lorenzo Stoakes wrote:
> Now we have introduced the ability to specify that actions should be taken
> after a VMA is established via the vm_area_desc->action field as specified
> in mmap_prepare, update both the VFS documentation and the porting guide to
> describe this.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  Documentation/filesystems/porting.rst | 5 +++++
>  Documentation/filesystems/vfs.rst     | 4 ++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
> index 85f590254f07..6743ed0b9112 100644
> --- a/Documentation/filesystems/porting.rst
> +++ b/Documentation/filesystems/porting.rst
> @@ -1285,3 +1285,8 @@ rather than a VMA, as the VMA at this stage is not yet valid.
>  The vm_area_desc provides the minimum required information for a filesystem
>  to initialise state upon memory mapping of a file-backed region, and output
>  parameters for the file system to set this state.
> +
> +In nearly all cases, this is all that is required for a filesystem. However, if
> +a filesystem needs to perform an operation such a pre-population of page tables,
> +then that action can be specified in the vm_area_desc->action field, which can
> +be configured using the mmap_action_*() helpers.
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 486a91633474..9e96c46ee10e 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -1236,6 +1236,10 @@ otherwise noted.
>  	file-backed memory mapping, most notably establishing relevant
>  	private state and VMA callbacks.
>  
> +	If further action such as pre-population of page tables is required,
> +	this can be specified by the vm_area_desc->action field and related
> +	parameters.
> +
>  Note that the file operations are implemented by the specific
>  filesystem in which the inode resides.  When opening a device node
>  (character or block special) most filesystems will call special
> -- 
> 2.51.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

