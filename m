Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EC6ECA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 389856B00AA; Fri,  2 Oct 2026 05:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E96A6B00AB; Fri,  2 Oct 2026 05:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3B66B00AC; Fri,  2 Oct 2026 05:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF7C16B00AA
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:56:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84BFA1A0686
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:33 +0000 (UTC)
X-FDA: 85277231466.22.5726F1E
Received: from mta1.migadu.com (out-218.mta1.migadu.com [95.215.58.218])
	by imf23.hostedemail.com (Postfix) with ESMTP id 87FF1140006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b5oyFE+f;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934991;
	b=f6yoSc1xWr6o/LqK5CCSdP93xTmy3uL3Komc8au3IBQfKOEeCNpKz4E//5rG1Ij6MCsuFK
	Sidujt4r3jxr3yzoqGPvgz50qIeVWXcHWR6d9hExpail7PO+390O1E2ylJwj0nRnbyhovk
	DqDUmA6r/zLXXp2qmpnCC45BUvX4cns=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b5oyFE+f;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KeIuA3EyfSkc4nK1H15Udp0lGgN4kp1NiVylQ1VmLtk=;
	b=RJU5zPuOblHMqKHy1UaY8giJbJEkWmmeBotdcTWIc8kFF7cRicnNTkIwXDx1dXiY+fxpBi
	Qy/FTj5vRnfyU0RIoKEB6uEEPna8mqPFUwt/FauSnXiUxfdHhQ+H6qLGetXEMOBG7VIZXF
	lJw3eFXGCBRmXEg05J38tw3r3FF7WYU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=92W4VZCSKNhkkdED6V3xajazvmttQRmFoqQ3AYY4EWM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934990; v=1; x=1791539790;
 b=b5oyFE+fGttIayEVYegFIhQNE6Q6KsL6uTfFMJ/T9zt5G5ZFHRvH/KsoDFxHQd5/bVIibyp5
 UhxfVEFdRSjdlr0EgVGTpfK4a4at6JZxHxmQRJqlWqk38F1mEj3M0MwkAhbhuqB/PTdL2ae2Pmn
 zV6G043MEUypvzZjhpIwNsrM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5ac8ebf340b273e0;
	Fri, 02 Oct 2026 09:56:30 +0000
X-Mizu-Trace-ID: 5ac8ebf340b273e0
X-Migadu-Flow: FLOW_OUT
Message-ID: <90811f7b-1751-49cb-bf0b-3d5ee7f10e45@linux.dev>
Date: Fri, 2 Oct 2026 17:55:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/40] drivers/usb/mon: update to use mmap_prepare +
 map kernel pages
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Paul Moore <paul@paul-moore.com>,
 Leon Romanovsky <leon@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Jaroslav Kysela <perex@perex.cz>, Jason Gunthorpe <jgg@ziepe.ca>,
 Thomas Gleixner <tglx@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Daniel Borkmann <daniel@iogearbox.net>, Eduard Zingerman
 <eddyz87@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Nico Pache <nico.pache@linux.dev>, Namhyung Kim <namhyung@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, x86@kernel.org,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>, "Martin K. Petersen" <mkp@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Simona Vetter <simona@ffwll.ch>, Peter Xu <peterx@redhat.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Sebastian Reichel <sre@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Harry Yoo <harry@kernel.org>, Rik van Riel <riel@surriel.com>,
 Peter Zijlstra <peterz@infradead.org>, Helge Deller <deller@gmx.de>,
 Mark Rutland <mark.rutland@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Thomas Zimmermann <tzimmermann@suse.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Nhat Pham <nphamcs@gmail.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Maxime Ripard <mripard@kernel.org>, Nick Piggin <npiggin@gmail.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>, Paul Walmsley <pjw@kernel.org>,
 Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Vasily Gorbik <gor@linux.ibm.com>,
 Baoquan He <baoquan.he@linux.dev>, Andreas Larsson <andreas@gaisler.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Gregory Price <gourry@gourry.net>,
 Rakie Kim <rakie.kim@sk.com>, Christian Brauner <brauner@kernel.org>,
 Alistair Popple <apopple@nvidia.com>,
 Axel Rasmussen <axelrasmussen@google.com>, linux-doc@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Matthew Brost <matthew.brost@intel.com>,
 Ying Huang <ying.huang@linux.alibaba.com>, Byungchul Park
 <byungchul@sk.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Xu Xin <xu.xin@linux.dev>, Chris Li <chrisl@kernel.org>,
 linux-usb@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>,
 Yuanchu Xie <yuanchu@google.com>, linux-rdma@vger.kernel.org,
 selinux@vger.kernel.org, Youngjun Park <youngjun.park@lge.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, Wei Xu <weixugc@google.com>,
 Miklos Szeredi <miklos@szeredi.hu>, linux-sound@vger.kernel.org
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-10-4583d8a23bca@kernel.org>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-10-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: nn5ggogthoietepix8dybiedqgi7fbc8
X-Rspam-User: 
X-Rspamd-Queue-Id: 87FF1140006
X-HE-Tag: 1790934991-212911
X-HE-Meta: U2FsdGVkX1+O/jGcpM946xTMufnesXAyXhPwoJAvB8TmWm4HtadiH4l4otEM2XdTIrv6tTK7HTCWOO3dY9wX/ebtDnIH2jemw/rGYNcqdx0ywMqnBgNryDU4BMyJeUBr2BvujYwuST0SmRO1YK47uJG9RhlgSWkpU92OCyl0F1ms4YHZOu/1E49Yl/xZc7FeHMSAj5zyN9yr2bhhLR0xkXupmP3qsOSH+y7E1lhqR9njcPwlY7ZkTLjUu8hr5rAbiLHpy4bN61DVyP8NBjv1X0W43gqmk3KbnE7gAD3HtzYRVp3UqnEesF+UywL0kqiNVzYE9hAi4uoUnBYbixIQBldC/iR7T8tJpYdX+V6AOUc/0YA5G3Ff2A9Cb8jmZsLW0XmIfIbcrj5pDA103BV0STgmRBSC7CVtg1lvvcNguXuVW1XNLgK0pgcJO86HbrujcOb2kWPGWiwWuBHWAjfHGKkgPumlESNGhuhpfK+nDGkjcjrwBPl3N8m98rx00DTNvKQAF512Kvtv/lhVkIPY6HdbY2co0o3/U+IW1k5uuTMltBRE/sScjEYdTXEzEGN7zHOZX34ZlJJOGj/3PMI5Ke0C7awmc9V9JF3XB8kDCtXjDzEQoTId2Ik/e1spWnDjI++0VFrYbSH7YxaWt6uLnfEVW+smV4EPvuSMuH/x9p6SRBJcH5ilDN5Pqm1DKYNF/eNPeG9IyYezuEAa2WiZHUyH0cgYhhgIXopQRWrTXwCUZ4QoIbzTBge9T8meWx6oKcx7KVqe1B2vSkl6MkFLJiV+67yuwdG7QOGWL414g4kcK/ZoQMVv3QZ/4pYZRAL4+9diW6/mIJlao/EqK8RRe4VB1ZzAHPzWR4mtTL64ClIIccCCulAFCjz469Y0GDDg7iuMvDY1ouxKJSh9soPTiXl5diUyG0Sp6en0eWV7013XkUoKWKdxixIsPtlwfJ1uuRAvZW3OrSKHpeonTdw
 PSR375RK
 HPUA92Cw019giMbrVf28CkQiuX6p/ZsmxvFSJ36bDyRv7WAXfSShkpHDVL9QqSwIz3gj6LuLsuDrZYuR61IUVl9wKpAY31+KdA728PLVfHw3Nsa1z+09P262gnWJ5z0lozZNqN3bxaNnaNq2yL7y/au0aSfjxdur9iswFvifBJGUPJtfvOl+5rPSbyJZn+jpPIvFGd7aLkqj8DjWocSBTxTK5KuVUy6M7LuSHZkhdBr13Hy5vH3SI8g6AdtG5v2/JeNwKmuNUtNRSm7sjkuN8O8NH/JZvQAelI0iO+CIHsdEfbBYvqpCOX7qvmhL+E1KuQb+nkNtY8inx9z5whvdsnRMdDbKWOz0pW1zXts8SDjUUjjQqdEWUWs7KlzvyocydRe8OvjQMjQXFvQw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/18 00:22, Lorenzo Stoakes (ARM) wrote:
[...]
> +static int mon_bin_discontig_init(void *vm_private_data, void **private)
> +{
> +	struct mon_reader_bin *rp = vm_private_data;
> +
> +	/* Dropped by mon_bin_vma_close() on unmap, including on error. */
> +	__mon_bin_vma_open(rp);

Em ... If Coda uses a usbmon container and the first page insertion fails
(e.g. -ENOMEM when allocating a page table) after mon_bin_discontig_init(),
where is mmap_active decremented?

mmap_action_finish() returns the error when is_compat is true, and
mmap_file() then replaces vm_ops with dummy ops.

Am i missing something?

> +	return 0;
> +}

Cheers, Lance

[...]

