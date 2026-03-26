Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE8110A1E63
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 10:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6AA6B013A; Thu, 26 Mar 2026 06:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCED66B013B; Thu, 26 Mar 2026 06:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B0E6B013C; Thu, 26 Mar 2026 06:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE626B013A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:44:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 537755C45D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:44:58 +0000 (UTC)
X-FDA: 84587881476.09.E7F0DB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id AA1004000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:44:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oZaElY+x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774521896; a=rsa-sha256;
	cv=none;
	b=Wh7AW4CUpX7w6tQorz4ddEBtewDrTx3KMb+wy/w6wx3Rg9fXEJVjNBHYQR4rOP9lzz1yjg
	TDzkSHsWX5SuENTiv6MG1GZh6HR/xurOXjfGGGCPamR96w9uGGTzHvxEtODs8t6LdYk3ny
	VbP62jQulwbFui4cMveX4oCvrDmuC9M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oZaElY+x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774521896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bo2WuRtmRS8Z86c0o/7IVvpIgFBSmwSYlo7KDlda+NI=;
	b=YdqeuqabZtzMj2SANoBwCFWo4e5g1hpiPJtQeEl1ZUMMuriTNM9vuzg7W8G6pLqE/TECgm
	UXAOD5nCg3tgCYA6iOCqLuKjT+vLIHIDn2dD2EC5oMkiG+HBvaqJh3bfqx11JzkInMF0qs
	B+pVzW0ojHotkLhi8WoCkmzCzqIujpo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 21E9D60103;
	Thu, 26 Mar 2026 10:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3B6C116C6;
	Thu, 26 Mar 2026 10:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774521895;
	bh=RpHr2+xHkvht2/Kh3sSH7GYvx2wP6yqls3YE2NUO0rs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oZaElY+xwfixyAcqHZhLjm1kzqhHtlPlUH7GKOTLKXANwHDqMaG1z6XwK+kEQeLOE
	 SYtBHHg37QOb54eq+UD8GrKX9hQ+eyixSzkh57jRU/1t5ChhlFDoLNFrhlvAUfv7T6
	 sZWCKLLb7jN89LctiPPnWlgN5y78Qjx+/QHgsyWC0CQN+IMFUPMFgtvHlpiyUt+V5w
	 LeoibiKN4Zw4L9hawiOfwt1apacVFOXRxXyuXI0ZqDVTae+0tk1tn7+8FIAI0IkO+2
	 USwrP2P6UszCTljgKzyfk42RQc6SWYWgX+jwYahwV6HqPPop4F/WNeF9Jm9BcDKhq/
	 SWL3RmCPKNuZQ==
Message-ID: <0b479256-1266-4c9c-a565-6e2a68573ddd@kernel.org>
Date: Thu, 26 Mar 2026 11:44:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 20/21] mm: add mmap_action_map_kernel_pages[_full]()
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
 <926ac961690d856e67ec847bee2370ab3c6b9046.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <926ac961690d856e67ec847bee2370ab3c6b9046.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AA1004000F
X-Stat-Signature: oj5568sj5zj44rgws51mjdjp5gzftunc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774521896-224869
X-HE-Meta: U2FsdGVkX18eiHB9VbTd+kxb3p2PGXcTOWa5S83DHaQZcNG0XQ1iNnSfya8e8TzvMpN1wieQbYHSyftEjdYTxharvERqoSIyIxgvjyk5wjlEjoVzu4wjojgw/9LxoYxceTVi0iL6TOIxFAUrOxv7/b8jxWwiH3xOILxJlv9ef63MZ6zHcrjb/T6Tr/Tj8/XzyG1Yz2c2uj848OkDl5RPoCrffDZ6NdOmspWlFYKpZ/Q8FQIkIWpYqtQRARhP5XGQ0d6OF6MRkOtz/aI6dr27TP8SsOzNptR3qvLimfle0UeQqdXzxiohRlplRUf/hEtiuC15coay/MAWnHBfqhkG0gUzeAdNuO9osF3ZRzYITdAciT9el01BMt/y18KWEhKPlETYkbLZfPOy5pYB5a6C4HMnOojcA1HCG/gxauzP6mh/PJjojbHH70DylrwlhR62M9uoJ50XR6Tfx2rbzBQdBd/JwS4E1atdow9D85xtj5SmNatH3IpBKnLwsI0oNE7MxyhxLG4RFc5MWDlF6GQYFtH0tCMXb7EBkUKlDXG1p6U75wrgw7N2Xg/Qqv+QbzNbI2ooDR/tgkpZHp3f1OlWBk42MN7K5RkCcZzSPUXz3RxHrhr3NCu8ViVbU+4o0hWn9pcMHDSLNZlxrNrC7qLr+zvUpMrQWcRVJLvK+wxisLKFhQAAvWlj7TtMiFss0jabNzCI7/9iFSJv6EfWcH/JSaWC1nZayPWOIsqCG4BSkmpt8bVT+h1feqzzPDc7UCt8t+J036chGbFQ3/ktnFb2GnsBj+Vc+WuCc3gH2m6wagC4VdCiu8WGQiB+41gOtzzSYlmFDgb2rVhsiHiYLE3jKOpN9wDaqoGf35ly0C8+FJ/BFgV2Yenxc9sn77CufZHOvWQR7fpXWp3XSTzMQmx8IoswxMQdbz7yEPXxoQ1dJ2LVZtXYZoMgVgslQO1Fc4qbGZNIA7y7aiRKnxs7miw
 ek3wog/Z
 zm+Fqd5wPKq0BNUm6PH6uGnHi9RZ8XzFtouza7aMFaqP0KVISDtEHQtdRgfCf7SmVi/IwBbNSyEP1lqc3mwS6NmVxPuaH4dnhVNM8hiBZ1Zd8yU6j4HudEJXt9CbKUD+dhWEDuW8PRBBJubzXxl4tdFQlwq2Uc9U3k7ma3pfxC/Rxl1TgaWu7RtHi6ZhCeeqH9tOl3lnm5z9VYH2RX6gPFL0ZkZQUBejYalYd1EapXYmyT2DTi4q6Tr3Kk0svshiWKWgpH1g4B/equ1IVHtH6/I3oYRhLzQbGcaAOTqPGJl2tGzBVfrUeJsyYePk0XoOH58iP+daYhheJ12dz3oMXIZIwfhEzNDUqmsxIlUD/ZwcXVPUasjn8k+elFNNQsTBLfT4UVZlI84MVmbTjSmlXlZw8Q51E6pDWbQg5gakQIgUfiao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> A user can invoke mmap_action_map_kernel_pages() to specify that the
> mapping should map kernel pages starting from desc->start of a specified
> number of pages specified in an array.
> 
> In order to implement this, adjust mmap_action_prepare() to be able to
> return an error code, as it makes sense to assert that the specified
> parameters are valid as quickly as possible as well as updating the VMA
> flags to include VMA_MIXEDMAP_BIT as necessary.
> 
> This provides an mmap_prepare equivalent of vm_insert_pages().  We
> additionally update the existing vm_insert_pages() code to use
> range_in_vma() and add a new range_in_vma_desc() helper function for the
> mmap_prepare case, sharing the code between the two in range_is_subset().
> 
> We add both mmap_action_map_kernel_pages() and
> mmap_action_map_kernel_pages_full() to allow for both partial and full VMA
> mappings.
> 
> We update the documentation to reflect the new features.
> 
> Finally, we update the VMA tests accordingly to reflect the changes.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


