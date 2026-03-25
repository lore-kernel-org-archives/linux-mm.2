Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8015FEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38E2B6B008A; Wed, 25 Mar 2026 05:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365A36B0092; Wed, 25 Mar 2026 05:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2436B0099; Wed, 25 Mar 2026 05:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 197026B008A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:06:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC3468C47D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:06:27 +0000 (UTC)
X-FDA: 84584004414.05.7162BF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 11F211A0016
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:06:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B/pXGWqx";
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5MEwpolUsVqDZFrL2ms2b43O01KTVFde67xSj4RB2Q=;
	b=3ZH8ODkDZowaZaiezRfR/B8+w04R3rriP9bHhmvmgTgsrs0264yOBECj0vRcYGVsLGDogE
	l5TjeS+qS1TLvIscCsOJmntG8jexhBF3qaQgdBuAZkN/npM74DZVIYV67amZnpzfEZjhC3
	tvxKUmyPG3zNiYcCgS7KptbfYaG/RLg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B/pXGWqx";
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429586; a=rsa-sha256;
	cv=none;
	b=jK6RL6kH1aolGdsVpaa7DyaIvbCJY1uwKs4Gk10WC+/7v9Tat6mYCbTzanGzC9iG2/MMwn
	JmRoeLlFf2R7EulN3ILVy6nb5gUWYGWm8lPZRh1rhEEKcS2s8HMxZzH7Kp47REqNaCUMqu
	+GIMQIL1RZU/mFKwppSau6TPkeFFAlM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 73617600AC;
	Wed, 25 Mar 2026 09:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F5A1C4CEF7;
	Wed, 25 Mar 2026 09:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774429585;
	bh=TGeHJllmZaOU480qUtXeb/jUm42/azepnhJdaLl9P5A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B/pXGWqxkc77H/QNjcNN4hXFs+1yWtOO/K6ZlFDqfhgwHp4yHtUXBY1gINF1N/v7H
	 Swoeh/4pl25iEnor6XcK93/xaSpBQCXea/x0tJWaU2vmaO0gQrTCNvrvDCRgFprVKV
	 1KqlwKP+22aqYID5Rc4LF4kA7w+kAFXYTzDiwCQpdMmDJrHF9HDz+HIU9m1OkF3LTb
	 /jwCEhab+UIAPA9vKX7zWI8lclKZJMoZ3e82DcRkAVWva3ZfDqkkW0tKKWs9g8wCY/
	 xPGCmHA6G5g4E8Zs8WC6hluY2t54Kvjz8OpvZWbU1RkOlOvI5O2Nk6MOymHovUB97F
	 cRXNnffbCU5+g==
Message-ID: <e9e9c3a3-26fb-4ca5-af27-158f4860a810@kernel.org>
Date: Wed, 25 Mar 2026 10:06:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/21] fs: afs: revert mmap_prepare() change
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
 <08804c94e39d9102a3a8fbd12385e8aa079ba1d3.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <08804c94e39d9102a3a8fbd12385e8aa079ba1d3.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11F211A0016
X-Stat-Signature: 7rsht9e7dqo5qgji1n59qjweo3gok9pn
X-Rspam-User: 
X-HE-Tag: 1774429585-730787
X-HE-Meta: U2FsdGVkX1/AgLaqWAuWnTib4ocAKcjSP6qezxQDoQJKIKT3aoR97Ym6T65/UshG3nAN9ct+PCYIgGEPtbOiLQqNhO2hsgZ4vqTQdRjbGQ76okbx9DEv+/6/GoYiFf2s53ngQ+cDI6r3GAOd7LhdevRiVaxbdRDRDUyhg7g8E2sLcVq3WyeQwTaa0Yvrwm0YRdi3PBUu316ICTbSaji37tbfKZUl6h2ezn4KgXDuXJ+uy7YdGKZtgPq39fIjvKOqeYuR7aZZbylFnBvq0quS1OeQH4bbFZs5cGFQ53kHAkolKF0fWzF19zwI4uOv7hx3vBKrFfJKjdQ6K9dV0CYXZWfa+yDJPyz6Yo4lQINMOn7cRjkb+5TFnQNPZOdnkVJbZ5Zgxf3MO2mJ8FNqeXWAOhWC9P7wFPdqTbn7Y9a/yT6DLYBCNUHEUHUTUhMsZ+nllZnfT2a/+ul6pkgpOqF22z5s97W3b5F26PlJ23oLVZBM93gLvJSBVP8loqxBiRiw6Hpak6O/kJ61oip7+3axagENVjJMF/jP9bZQrHs1XUHQbfSY4ZhszjZggq3bgpunJaR9HvodnTrTgmquGYp028Rs255jXtaS9TOfa1yX5PfH6py+VxlR1IFrNyP79Uu4SWZIkpk6h9tuEUSD2iiJmmktaYXB44QJxpdCBv3GqB0gdzX6ilTb2DbkkUr6GjoI9HoyL0yH3ocAqahItRPrMyv7v6FQjHq5GrIeDWGtDNVGmxYwwBGFlcttz3VzbwcBqqs/IwSkZj3TSuBfSTIAqk7CWPKNH5GHWlYo+izmq7l6huSBI6BQU7G7bI2bx+6DBXwiEr52MeYNlKTOiISotqMLk2jnD8CLgsLvtyC4XWY+Re2TFc0iUHwT1vwsc5z83SeaymTr7ls8w6it/B18fWmaXJIB3J0/mPFgejWt1MgCIq49/SHJ9rYvMwz3v//w+QK31qMKHc/xux1j17v
 SPaxhEK/
 d2k+2R472So69vqD79DPGtnH016QLGWUk/LI0wooM/j0tcEi6E4AHTytJeR2Uc9gt2u9XdoIqiA1Byg6UIlIXQ3txhCs6Yq+fy+wqqK7L4/TJ3T+X4YnbgsWjI/uD0I+1SYP2T9V+T6p5DHc/rmrBa/FOhHNpJ9m26PQj/0dD60N2nMokr7Dtar0giT3knnpOW+rzgUK5g0WZJHqAWFsno17qJPFiDTt2tn+pBrWFpKmeb/sAnS2In41UUXIEwwQMjn9R+4L8zzBb/h1wH1fwPsLgvheHSzsd9x5YixRoFEGq1mPLlaKh9882zVyIwd2V9tGQumWr4w7wSh4Cu7Hqh4FvFosvL/z01nSnr8Mw+zjRM6bjqfCFQQm7MTKxdqyeMog8ieAGqm33GPahJFPqdOhKvmZFhDdG2PjzRwr1HLazgaB9u+8zUgIM2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> Partially reverts commit 9d5403b1036c ("fs: convert most other
> generic_file_*mmap() users to .mmap_prepare()").
> 
> This is because the .mmap invocation establishes a refcount, but
> .mmap_prepare is called at a point where a merge or an allocation failure
> might happen after the call, which would leak the refcount increment.
> 
> Functionality is being added to permit the use of .mmap_prepare in this
> case, but in the interim, we need to fix this.
> 
> Fixes: 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to .mmap_prepare()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  fs/afs/file.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/afs/file.c b/fs/afs/file.c
> index f609366fd2ac..74d04af51ff4 100644
> --- a/fs/afs/file.c
> +++ b/fs/afs/file.c
> @@ -19,7 +19,7 @@
>  #include <trace/events/netfs.h>
>  #include "internal.h"
>  
> -static int afs_file_mmap_prepare(struct vm_area_desc *desc);
> +static int afs_file_mmap(struct file *file, struct vm_area_struct *vma);
>  
>  static ssize_t afs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter);
>  static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
> @@ -35,7 +35,7 @@ const struct file_operations afs_file_operations = {
>  	.llseek		= generic_file_llseek,
>  	.read_iter	= afs_file_read_iter,
>  	.write_iter	= netfs_file_write_iter,
> -	.mmap_prepare	= afs_file_mmap_prepare,
> +	.mmap		= afs_file_mmap,
>  	.splice_read	= afs_file_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.fsync		= afs_fsync,
> @@ -492,16 +492,16 @@ static void afs_drop_open_mmap(struct afs_vnode *vnode)
>  /*
>   * Handle setting up a memory mapping on an AFS file.
>   */
> -static int afs_file_mmap_prepare(struct vm_area_desc *desc)
> +static int afs_file_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> -	struct afs_vnode *vnode = AFS_FS_I(file_inode(desc->file));
> +	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
>  	int ret;
>  
>  	afs_add_open_mmap(vnode);
>  
> -	ret = generic_file_mmap_prepare(desc);
> +	ret = generic_file_mmap(file, vma);
>  	if (ret == 0)
> -		desc->vm_ops = &afs_vm_ops;
> +		vma->vm_ops = &afs_vm_ops;
>  	else
>  		afs_drop_open_mmap(vnode);
>  	return ret;


