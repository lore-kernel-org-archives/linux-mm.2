Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE83A60A2605
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 13:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=htGvWvY7
Received: by kanga.kvack.org (Postfix)
	id ED03A6B04BB; Tue, 20 Oct 2026 09:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA70E6B04BD; Tue, 20 Oct 2026 09:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC866B04BE; Tue, 20 Oct 2026 09:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B31706B04BB
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:00:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4D5B880140
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:00:12 +0000 (UTC)
X-FDA: 85343012664.02.F2965A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66D0DC0009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:00:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=htGvWvY7;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792501210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SlxZ5UQXu81xsFhH9I1ceqg/5A7Zf9sbax9KJqUchU=;
	b=v5GoiyC2oSyMJciccc0kwiJqnucYaNMqiIUmIkv6ltWSuxW3CnySqC9HoZuzHzPbRK1ayo
	N40sy2dQOJeqLOk9fjiotv6oDafptvjgkefym21fic7Aq1KNO33GuT0luSu2lgjrTvN2Mi
	r+PXtQ7Jb2TgEzD87Utw85gbX5Y8Dkc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=htGvWvY7;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792501210;
	b=HLXg0+1UsvSnMfnEzSGdSODUT61xcgQno3DdSLmWrW+88u9v9ZUrFitOZ+02xkKgztzWSV
	fSY9tV5k24Mu3my1wGioKjk3J11jPf//INKvr7R2BRtKxBehwJFDibXxxpxk/9aROSK722
	nf3C0MpH6Nu1mrLs/OdfJ34pBQb7MiY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA8DD444F7;
	Tue, 20 Oct 2026 13:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877C71F000CA;
	Tue, 20 Oct 2026 13:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792501209;
	bh=0SlxZ5UQXu81xsFhH9I1ceqg/5A7Zf9sbax9KJqUchU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=htGvWvY70hcOTpY92QXwy8gTYzLILBSSisBX8mhP1sRKfYjNS6z09IxQOvQBMZm7Z
	 HaiPFoXiUlsj7EF2GdaS3DckfqOcJlBx5eAZmOR8drqfoFb1OWgj9srtF825m7IO+G
	 2Eaa29YIujwB+KexjanWX0jOM/ig/GHCHk1O6MUJy129SfiOabCY5J6Lon+eKe8DrT
	 sBmXMH+3Uvvj+ga2A8kvkYsvuv9M9lWU91nP0W7O5WrUUcq2Tdle92kI5GZ3TTrE5n
	 ZHCbpxm/cqjOqbaze53ai+CDC6++u7Q2WEtyGk8SYfmQdNa1RRwiF/MTjbhIAWLfTz
	 2KkdmVuPKPb7A==
Message-ID: <3c80ab1a-d86d-4986-bfae-d513734a0d90@kernel.org>
Date: Tue, 20 Oct 2026 15:00:07 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] mm: userfaultfd RWP drops a populated shmem PMD
To: shaos <shawnq1@163.com>, akpm@linux-foundation.org
Cc: Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261020110759.960089-1-shawnq1@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261020110759.960089-1-shawnq1@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 66D0DC0009
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: pesrzhp7n5hyh8u85yo1ods39tbesoy4
X-HE-Tag: 1792501210-708995
X-HE-Meta: U2FsdGVkX188RebxsDYTRI2hcGrnQzaSeA5jJefDPcSKpqmWTpg7fKRyPlIpQavzmKJh3o95rmT9xoZdjDMw7qUIt84IZdS0VZWUoUAW+FOgMtpSfBgGAakmKDLzE5ZO12Es373AxNM371jBYX4w0H6++ErA3qtVCmoS8nHIzqQ1k+noU9WKgHvjG6n0Wa9OYqkBbbQmF1Kakar8D7+pqPkZfHbNdNgzsEWQ3OHeOO6RUlF7LvpBHzt6SB3ZgUVjDIhkyhtqEnhgF9+8vAbu2dzDDkb2CvlalZHv9o2nTN6pxaNNq84TTvAOzFoqG0Z8ddbZwmE4Yg72c1JExAajYcj4odM0RF825TksWDkaZAluRz+a2UOW+pzkjl58qbgcdXe1SWXi1saT2ZaOIkedRcDmbgRcksT3JiD+coQr2XFqBLCEHXTpxHElYkVoiIs3wGpG7D/QfND0LW7Ga5BqIsqjp2BiLD5VlclAbKyalArDVrO7UibUCm2lCWtE0oq+SulCCdVUuix/Qf1LZmXKcu/d021sHUSKYkRUcIXe0Kjg0Jan64HyBkOQkveFvjGA5ESDvG5dDXmhEzPIMvQA+hthOn7fVFg5NPL1eRcK3U501ml1LlxcJA6IIRzoCIj8TM/7B8YVMgsSsNiZmQ7kPTurOZliOM0Ab0Dtbp1rCkNaiNclhmLBQ/8zoI31oNf6FJ1u4CXfWxefCqBaXZUZKqO9l+WqtVOEXn4dbSS+48FFEzT6apGVRSiAtGvRkyE1H61WcHnQaOc9u0j5HI9zWp79JN/oj7+KMrizRcre5zw6qBMWWxh/KLvM4eBpRuvXDpUOGJiMUHPTrBcrzYLiY6po1fVLNWW4J7e3pp+YwJ7eLwGqjX/09zeedV4r08HDn3vqEfmUXkUgeJVmgnUjjVb7UWyw94or5VixVW91R847T790XkBS0g1m5N9dRrpW4iMk5vPef4DLAlhGw6n
 fFLoe+Tf
 JO0JppiseG6gZS1FZ4aTxDuGs2XKU+aGefZ1Ny4PmjzC88rC0+x8gyBwc6l3h2hbw7KGlI+WSU8dqcvghIMHuaslGFXR2xIjqnujYDr27JvUT324Sauichd1teHUaKtVjEIN0GyzDIWnrLk8/Q7GZ41PuWfVa7hYbzTuIvGw+NfhEh2nm8y7KYIb5MhNYea0XZl0MAlb8ETKfxBTfmpUU20Da2uffzWi267I1Ty4pnpVqxyvDjPcIDLeB6x1rVZnmeksBWSG40/vq+O+AFAzLSIW5bdNIRhpaQSnyoXwcGrmdXG8LOv7SCn+xyLW/6xjwHZq93PqvI2EiOWtiP9t8HGTejUjnzRhvK0RuXFoh3YOxnNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 13:07, shaos wrote:
> Hello,
> 
> UFFDIO_RWPROTECT_MODE_RWP can return success for a present shmem THP mapping while dropping the PMD mapping instead of leaving the populated page resident and write-protected. The next read refaults the page and completes without a UFFD_PAGEFAULT_FLAG_RWP event.
> 
> The PoC verifies ShmemPmdMapped=2048 kB immediately before the ioctl. After the successful ioctl, smaps reports Rss=0 and ShmemPmdMapped=0; the read completes with the original byte and no event. Re-arming the refaulted PTE and a separate 4 KiB shmem control both produce the expected RWP event. The observed issue is loss of the mapping and protection tracking, not corruption of the file contents.
> 
> The source path splits and clears the non-anonymous PMD for MM_CP_UFFD_RWP, but the retry does not repopulate a PTE table because pgtable_populate_needed() only recognizes MM_CP_UFFD_WP. The ioctl nevertheless returns success.
> 
> HEAD commit:    24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
> source version: Linux 7.3.0-rc7
> architecture:   x86-64
> compiler:       gcc 11.4.0, GNU ld 2.38
> QEMU:           6.2.0
> 
> console output: https://gist.githubusercontent.com/shaos26/3c336ea98e1e8fe09b5270c3a82ca268/raw/da13df3db0c05df09952f74bedb457f57c53b78b/console-output.txt
> kernel config: https://gist.githubusercontent.com/shaos26/3c336ea98e1e8fe09b5270c3a82ca268/raw/baa5ee61ce748667104c480560ab5116a100e3fd/kernel-config.txt
> reproducer: https://gist.githubusercontent.com/shaos26/3c336ea98e1e8fe09b5270c3a82ca268/raw/420975783e9d5dd88bc4a69190d8ef194faf5fdc/poc.c
> 
> Build the kernel from the revision above with the attached config. Build the static PoC and initramfs from poc.c; the program is /init and creates the shmem mapping itself. A fresh-boot run used:
> 
>     timeout 300 qemu-system-x86_64 -m 2G -smp 2 \
>         -kernel build/arch/x86/boot/bzImage -initrd initramfs.cpio.gz \
>         -append "console=ttyS0 panic=1 oops=panic loglevel=7 kfence.sample_interval=0" \
>         -nographic -no-reboot -monitor none
> 
> Two fresh boots reported RESULT=RWP_SHMEM_PMD_BYPASS_CONFIRMED and exited cleanly. The affected code appears unchanged in upstream master f47d223627f8; I have only reproduced it on v7.3-rc7. No privilege escalation, memory corruption, or guest escape is claimed.
> 
> Thanks,
> 
> shaos
> 

https://lore.kernel.org/all/20261019010934.697895-1-samarth.colleges@gmail.com/

-- 
Cheers,

David

