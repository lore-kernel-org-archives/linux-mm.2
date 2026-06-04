Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B98CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 06:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724196B0005; Thu,  4 Jun 2026 02:15:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4E36B0088; Thu,  4 Jun 2026 02:15:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EAC86B008A; Thu,  4 Jun 2026 02:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB4A6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:15:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9AC71405DD
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:15:11 +0000 (UTC)
X-FDA: 84841217622.21.C6BA6E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 50D5D1C0002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 06:15:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YZdzENTk;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780553710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=maKYg38a30VxIX8QCcSBujTuAdCuRyvh3rWBPMbaTa8=;
	b=Dk4Iqonle24Ep3DnDJPDa3T0ki6GJ0LOnfdU/zHGrqdN5UuNDM9D20L7rT+tvAZzvgzQx5
	KxmuIk7BH8fhF0vJkgHcMQ+xlF2oD+11lPJeXS/AXzBKV5sWQaU9adTzU6L64R4KIh7ukc
	Cr1JF7N8l1UqlbHXvCm+J6izYB7BeBs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YZdzENTk;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780553710;
	b=vjfRUQ8TwxYEjOMTNyW28a7L5Ppsi6Kp8DilpE4r2Svzmu3wwda7sayH8ZyRbvLk1rXIy8
	gr82nEgnCjhQvfoN9MrJUgKU4nRbg7xMLNB5h1Ma2XSX3ITJGlBmXFSD8b4AeF5VC7itzB
	1oHZOSdsv27UXzlqOFW2v20NgAcdne8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69B134398B;
	Thu,  4 Jun 2026 06:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6611F00893;
	Thu,  4 Jun 2026 06:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780553709;
	bh=maKYg38a30VxIX8QCcSBujTuAdCuRyvh3rWBPMbaTa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YZdzENTkOazs5XSTumSTfKjNe97Bx1gIjbWPEe0rEOYizlJ+PG3Skn0hS26Ux74Jl
	 AXCvUF5ahoFRq9So4PlOjS3IWyCIq5NTGNUoudm5MMRDdJhNBKN1LdgBDErw0LtVFd
	 jzKhcofKN8uPI1V71amXjFQlau+IKLTXzAiqIsn/g+sTxSoMC/LouWT+HEHb+idjuI
	 8F/5ZnoIZWEz4pT/Oim/JLh5w98h2ycR5nXmcdy58o4NERbYl1r+Hpa7rpblTquRvP
	 owmPxKztmOlhAuoaO/iNyxsWnpCrb8pm0xA6MdS2Qr/cnlFMvHA1Yq1Qntrgg1OIwG
	 JJVS4xnu2W56g==
Date: Thu, 4 Jun 2026 09:14:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Theodore Tso <tytso@mit.edu>
Cc: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dave Kleikamp <shaggy@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <aiEX4UTxEnBTjVKo@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
 <yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yfzx3jgzwesernofl7mzixa2mhjfii5v3o7yapghtmozixrpfu@6bsh7iixyiov>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 50D5D1C0002
X-Stat-Signature: tt3wci7jambywubbect7gesbarhckx1b
X-Rspam-User: 
X-HE-Tag: 1780553710-421568
X-HE-Meta: U2FsdGVkX1+PDKNzAV9iR01uTPLgfuTpkJhoUsoylVL2oGoncybLBdwj/KMmguRT9ch063OSsL7zwWMqFBzYMBFxhzEZ+6Fo6XpKM7q6lRCbg8mCi+fgA+hXMSxG73sXDQuSIB9Sf+K+UNegSEhvB95d0NBuTt6UQSNoSgrn3P6GYm7l8icNCueRdo7N1sqMHqeNENW5NY+8V5X65dcc6yNIBiUc3a1NVf14Q6cpltBXTEF8tloTV07Y4vReAtRNex/PWSABncWEBuZgtXZUk2Lv7+dpSQrSwR8Byuh+Vc4k4ZjitAqgSy8w9vKGHBLx24SCjS9sF8ve5SxBe7PWM56GT3dvWwn1WvVPBuHir3HE9yvUoAO8gEoUyAOLSa6jm8P4AwEE5GwfPZHKM1X2ppUvMk/XTZiLqYk/G5JiNbULSnCnh3SnTM27xhlzwx5GMC16excHiGhta/KNV8wQ8qjB97e1cQpOyG9jQMduCMcIBb2tEZCj+Ab67PjLpgr7Cz4xXI2HDam044KRUWFt51faYVw871yPvp+XZvGqR2F4ZrL6opaxCqHbUC8I4lGtwbFy/IQDRRQe4diCcQXUaL+8rHCOig78BtDwVhipLGrhZe58H5pT9OULm4YU+uHtEWo5xwIDWkEWbNcXiibalXb6R4Loym9tSMIYL8MqhaTjwXR3PhdmCeuM7KJ+jKTZKhASywmc1iPQRJQsUuegR/eoHkZqCudhPNBWwwS/hrovKmD+n/pU/ZJfLVceUfg47yD1saEW7dc9xZ0Jbw/pU/Nn83UhYffszuR8jTOyQvhyp4lO85qfe96S2v6H9iGp8XbFTWDwLj4ph/GcdOjcF4iZPneRVgs3V+Ji99NJNQUx/URNE5z6AW5OQxGnEs9tq/YZxkKvjCh4TUKQR39aU83ZRmigYn0Nz796XAULCdeGQi706Aw2utM+BCq9zxBeikIKhV2aQwrprVZjLE7
 Jg8vdcfw
 GIzPuo0aO1WjLqGuauwHes1hueicjciYlGobq/ds/5kNWtkVhsgYHIu1lhnfPLWZzKSpNoub2YnBqjRn1xUamig5s3IGCesCb8YpvA+uifxf396tFTEKGE8WWP8v9mlFVnEjw64kyflNflLx/O7YxHa5vVxMW6T0BLHDKeht9Ty4ZomOBmhvdRhiQp6hxLJ+umbaCIvb8x/xIrfQwp9fzTfAmLWYZNY6ox0dkGRr8sCpir1KY66t/RKlBsL2j9+iVhPZCUsQIi2VFvXtsBZpJayqQGF5474uutSegwy55jypB8wbVfaFK2QyGgpxqIhfKBfovH+S/l7s6MQaCuFOQWtVgf/sHyfTVftTNx+uGDIk/NEk2/KdRXXQEWCFqaiIZ+2rMEOevEXo4I4R7uziX74RkBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ted,

On Wed, Jun 03, 2026 at 09:50:15AM -0400, Theodore Tso wrote:
> On Sat, May 23, 2026 at 08:54:22PM +0300, Mike Rapoport (Microsoft) wrote:
> > jbd2_alloc() falls back from kmem_cache_alloc() to __get_free_pages() for
> > allocations larger than PAGE_SIZE.
> > But kmalloc() can handle such cases with essentially the same fallback.
> > 
> > Replace use of __get_free_pages() with kmalloc() and simplify
> > jbd2_free() as both kmem_cache_alloc() and kmalloc() allocations can be
> > freed with kfree().
> > 
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> So historically __get_free_pages() was more efficient than kmalloc
> since previously the kmalloc overhead meant that a single 4k
> allocation would take two pages instead of one.  I'm guessing that has
> since changed?

Today there's no memory overhead for kmalloc(PAGE_SIZE). Cache refill takes
more pages of course, but they will be handed over to the next
kmalloc(PAGE_SIZE).
 
> Can you explain to someone who hasn't been tracking the changes in
> kmalloc over time:
> 
>   * How does the efficiency of kmalloc compare to __get_free_page when
>     order == 1?  What is the overhead in terms of memory overhead?
>     I'm a bit less concerned about CPU overhead, but it would be good
>     to know that?

There's no memory overhead when order == 1.
As for the CPU overhead, the difference for the fast path allocations is
not measurable and for the slow path it is anyway determined by the amount
of reclaim involved rather than by what allocator is used.
 
>   * What does kmalloc() do when a size > PAGE_SIZE is passed?  Will it
>     return contiguous memory, or return an error or worse, BUG?  And
>     same question as above; what is the overhead of kmalloc() when
>     size is 2*PAGE_SIZE?  8*PAGE_SIZE?

For size >= PAGE_SIZE kmalloc() always returns contiguous page aligned
memory.

Larger allocations (> PAGE_SIZE * 2) go straight to the page allocator. 

> Thanks,
> 
> 						- Ted

-- 
Sincerely yours,
Mike.

