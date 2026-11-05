Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDCCC606EE8A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 02:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=j2sTp789
Received: by kanga.kvack.org (Postfix)
	id E00626B05B1; Wed,  4 Nov 2026 21:14:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD8556B05B2; Wed,  4 Nov 2026 21:14:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16916B05B4; Wed,  4 Nov 2026 21:14:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9EF1C6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:14:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09DA51408E3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:14:07 +0000 (UTC)
X-FDA: 85399445376.13.9871DBE
Received: from mta1.migadu.com (out-118.mta1.migadu.com [95.215.58.118])
	by imf05.hostedemail.com (Postfix) with ESMTP id B4174100005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:14:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j2sTp789;
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.118 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793844846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXeq94tKXH8bHOz1amsH5XRU51n2PYOOTkgxfF1PjyI=;
	b=zA2JMHIwhTHcWCmwJExyHaZUfFsMsOE4UOEEAnR0NcQ4Iyumf+nGyk2azSUlt5KnFu0qM8
	i6WjOt6ZLFR2/V+yXg07S3le/VkR371kIefZEy44JXHin5eHKKhUNT9WsRnTzDEao8sruQ
	3yUasQpvVibh5/c02mBQpam3J3K0LGw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793844846;
	b=caMS79eWf/9CixbJbKdxd0Vk6iIerKUezRKCze0mQ+E9MpLPIl4qRLp/c4o38JNVzwFGfr
	YpEHqM1NQCwuteRph5AtEt2MnDru03n3pyu/6TTV+hICUABd8kHYABaswKxTsiZNVTAbyU
	vp4LN7oU8Xer4AEUPQHXZ/rHDElaS5k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j2sTp789;
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.118 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=l5hRS8qgzR0WOCPLF0tQbQ+of37lp1oZsgw+XUQqwhg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793844844; v=1; x=1794449644;
 b=j2sTp789TAzH4+lGZ7lYWfaDwj4tzc9cwnz9VymVYz+93eIx1j2P1wIewQP0NcIfVbJQKLyf
 0DO8NIIghKzDouBSBnDym1wAnQyGpqJsD9irj2dQSZrGObeDZJB96QtjMGxheDIwPErfv1cfpzT
 zdnAQ3fG/Xx2Ge3hDWonFfXo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7ce234fbb2517b84;
	Thu, 05 Nov 2026 02:14:03 +0000
X-Mizu-Trace-ID: 7ce234fbb2517b84
X-Migadu-Flow: FLOW_OUT
Message-ID: <fc4939cc-84ec-4c5c-88a7-658ca800377d@linux.dev>
Date: Thu, 5 Nov 2026 10:15:13 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v2 01/51] alloc_tag: don't remove /proc/allocinfo
 under the codetag module lock
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>,
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
 Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados
 <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>,
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>,
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 coreteam@netfilter.org, kexec@lists.infradead.org,
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org,
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net,
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org,
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org,
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org,
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>,
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org,
 linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>,
 stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Suren Baghdasaryan <surenb@google.com>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
 <20261104-work-procfs-bugfixes-v2-1-021c84d852e0@kernel.org>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-1-021c84d852e0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: q8uxx939chphq64syss6or1kmhkgbq9r
X-Rspamd-Queue-Id: B4174100005
X-Rspam-User: 
X-HE-Tag: 1793844845-269127
X-HE-Meta: U2FsdGVkX1/yry6S8+ig6u01oDhaqJ9pCnXYL6lzSvF9vuVAzoLqY6NFnMoU1Qa28WE3J4UBe9vmd15Cf44md7ZwhhiQJ7WcoHFvt58Ccids7nTV3iug4XMnGm5aAlqSPSTStjbaiRQDbszhruFWKAwiqt9/tHiZ6jKFYann7teYHin/Zy2Ilo/Oc3DC5NVnmd6tI6gXcil+DOVixN6q+6Zz5CUkom1K2ONKr/FpdT8aNbRr20ZT/NwOdAJf2KKFUPUIAD6J2iqqA0DD1Q2ADp8XGKpI9sYa6521KjGZAdAVfKQGPeMSpCfY5JiqlbenMpI52LaCsZNiO+o7v+I7IHNmi5YIsNa3nAkI05hvU3wSgKsXtUw08r6NxGuYks8A3xNnx/9hpGwyoctOHHnQW85yUTc3aSTtVHfnjCyxJX70fXZckGCwt48ct5PkgYtzyx6W8QqpTFx+9jYyS4HhU/LjVV41/N87L/slPtGWa8DarV397+zcCsMAlc6hWSimCanlmcHyLxeMMM//yJYC4LrWkKn9HMfmHqyuEAG4MBAB8D4xvoVkynwYZ3A3ILImxENVunCWjLY2MPJX6CDNaB8zIlt+AYl7/gF8EsNddF9wnFwbqkBAt0fFLMXwYwcY5yjgPFlHENhR4aeB0hImmcDXvYSA1GOTzhx24pvjLfCVulShLiahLhmvS4/ePYTOZksis/C8g0AwcbKkGPT9xUc/jYg79rEnM3PdjtDqsqsmjWgcau2EQGI16aTPyEOLSda8QmM+C1MO2h7Adc8NRkqpe4Bvo1wqrOng9Cv8U+AIxpZ/Bj6OgQXdW1jLxXzs/tPhJQgGJyg0GXPF/lZ4HNpMVuua9sZCry5z1XEEIMJg9lwPkGLLSJrwzl/OyWa0X0Y07WJNuZRJgeIVe1VajUWsRXtg8gexVUZ57c9qwR2Hg1C9NU3NrPk8aBjjWd0p1cy9LJ8exdZwlQKu/gr
 xuR2FvBL
 odN8Iy975C6Szem08gO4j+pre8XjVTebbRhRSKBqYrWuoShmeR4R3vTnCzqz/XhK6nD0STDUOmiwwf47QbnPp+r8auY6W5CY0MtPznI7ZynRclusBGidl965+LfpKvlFFUDpNMTIrqERJbY5Nur9LKpNCgyKswPUzBFlCZBpYw9TgfpZppFnPXxWp3Doj+cW3KI44h1fFxjupIY74TwqYWWot/d2JfY4kfGFV2O7BL6wB9Pc1woymyglika3hxBntoT3OSSFARhwalq+vjZsOkNNwuiXB/GaGCwIErl7LUfhiKEhbW5s8WVi3a3pNxkoLiK0CRKX9VvRX1nOEcgWMMQhX52dmY4a0abbPiDPoJFerGWBA8mqtabpf0Z/0Nil61klrxmqnU9pFGoOcbCBw9e3206c4mKvdkMsbefMM7mIozWNvcRB/AQDtqeh90h8Pnxbd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Cc Suren

Hi Christian

On 2026/11/5 03:06, Christian Brauner wrote:
> codetag_alloc_module_section() takes the codetag type's mod_lock for
> writing and calls reserve_module_tags() with it held. When that can't
> reserve the tags, because the section's alignment doesn't fit, because
> there are too many tags for the page flag bits or because the memory
> for them can't be allocated, it shuts memory allocation profiling down
> and removes /proc/allocinfo, still with mod_lock held.
> 
> remove_proc_entry() waits until every reader of the entry has let go of
> it, and a reader of /proc/allocinfo takes mod_lock for reading in
> allocinfo_start() while it holds the entry. So a module load that hits
> one of those paths while /proc/allocinfo is being read waits for the
> reader and the reader waits for the module load, for good.
> 
> Let a work item remove the entry in that case. The profiling is shut
> down right away like before, the file just goes a moment later.
> 
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Thanks.

is this a problem you have hit in practice?
Sashiko discovered this issue earlier and reported it as follows:

> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 2070e682fe106..112a014d4b890 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -950,10 +950,12 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
>  		int grow_res;
>  
>  		module_tags.size = offset + size;
> -		if (mem_alloc_profiling_enabled() && !tags_addressable()) {
> +		if (!tags_addressable()) {
>  			shutdown_mem_profiling(true);
This is a pre-existing issue, but does this shutdown_mem_profiling(true) call
introduce an AB-BA deadlock between /proc/allocinfo file readers (pde->in_use)
and module loading (cttype->mod_lock)?
A user reading /proc/allocinfo acquires the procfs in_use reference in
use_pde(), then blocks on down_read(&alloc_tag_cttype->mod_lock) in
allocinfo_start().
Concurrently, if a module loads and tags_addressable() fails,
codetag_alloc_module_section() holds down_write(&cttype->mod_lock) and calls
shutdown_mem_profiling(true), which removes the proc entry. This removal waits
indefinitely for the in_use reference to drop to zero, hanging both procfs
reads and module loading.
> -			pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
> -				mod->name, NR_UNUSED_PAGEFLAG_BITS);
> +			pr_warn_once("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
> +				     mod->name, NR_UNUSED_PAGEFLAG_BITS);
> +			release_module_tags(mod, false);
> +			return ERR_PTR(-EAGAIN);
>  		}
>  
>  		grow_res = vm_module_tags_populate();

I previously sent a patch with a comparable idea, though Sashiko remained unconvinced.

[patch]: https://lore.kernel.org/all/20260817062726.106511-3-hao.ge@linux.dev/

[Sashiko's objections]: https://sashiko.dev/#/patchset/20260817062726.106511-1-hao.ge@linux.dev

Could this patch perhaps wait for mine? No worries if this is inconvenient.

Best regards                                                                                                                                                                                                                                                                  
Hao

> ---
>  mm/alloc_tag.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 82e2c3448dcf..7d7ad6704953 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -15,6 +15,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/string_choices.h>
>  #include <linux/vmalloc.h>
> +#include <linux/workqueue.h>
>  #include <linux/kmemleak.h>
>  #include <uapi/linux/alloc_tag.h>
>  
> @@ -604,6 +605,26 @@ static void shutdown_mem_profiling(bool remove_file)
>  	mem_profiling_support = false;
>  }
>  
> +static void remove_allocinfo_file(struct work_struct *work)
> +{
> +	remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> +}
> +static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
> +
> +/*
> + * A module's tags are reserved with the codetag module lock held for
> + * writing, and a reader of /proc/allocinfo takes that lock with the entry
> + * pinned. Removing the entry there would wait for that reader for good, so
> + * let a work item do it.
> + */
> +static void shutdown_mem_profiling_async(void)
> +{
> +	if (!mem_profiling_support)
> +		return;
> +	shutdown_mem_profiling(false);
> +	schedule_work(&remove_allocinfo_work);
> +}
> +
>  void __init alloc_tag_sec_init(void)
>  {
>  	struct alloc_tag *last_codetag;
> @@ -855,7 +876,7 @@ static void *reserve_module_tags(struct module *mod, unsigned long size,
>  		align = 1;
>  
>  	if (!ensure_alignment(align, &prepend)) {
> -		shutdown_mem_profiling(true);
> +		shutdown_mem_profiling_async();
>  		pr_err("%s: alignment %lu is incompatible with allocation tag indexing. Memory allocation profiling is disabled!\n",
>  			mod->name, align);
>  		return ERR_PTR(-EINVAL);
> @@ -905,14 +926,14 @@ unlock:
>  
>  		module_tags.size = offset + size;
>  		if (mem_alloc_profiling_enabled() && !tags_addressable()) {
> -			shutdown_mem_profiling(true);
> +			shutdown_mem_profiling_async();
>  			pr_warn("With module %s there are too many tags to fit in %d page flag bits. Memory allocation profiling is disabled!\n",
>  				mod->name, NR_UNUSED_PAGEFLAG_BITS);
>  		}
>  
>  		grow_res = vm_module_tags_populate();
>  		if (grow_res) {
> -			shutdown_mem_profiling(true);
> +			shutdown_mem_profiling_async();
>  			pr_err("Failed to allocate memory for allocation tags in the module %s. Memory allocation profiling is disabled!\n",
>  			       mod->name);
>  			return ERR_PTR(grow_res);
> 

