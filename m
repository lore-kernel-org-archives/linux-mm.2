Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0453FCA6015
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 21:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974D96B008A; Thu,  8 Oct 2026 17:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925D66B008C; Thu,  8 Oct 2026 17:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83BCD6B0092; Thu,  8 Oct 2026 17:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62CDB6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 17:48:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 56F391A0198
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 21:48:18 +0000 (UTC)
X-FDA: 85300797876.28.45D0D98
Received: from mta0.migadu.com (out-234.mta0.migadu.com [91.218.175.234])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1D1DE20004
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 21:48:15 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xkSnrgLF;
	spf=pass (imf31.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.234 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791496096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7zvavZgDX6AiohH2AmJnsY/6PzyHvVHjel8MaMFA8s=;
	b=fWKtDvQL7upU2r4k1cVxjaxAQG9vHFXF4QEFwOI/Yz8JE8fT84y8XEQsykKH/QKsPK6cgN
	1E5/Md2ksimRgZcpcr6bxrQpPLAglGaTtXzjW1B1mZe0fY4gzMdK/JJ7D/ACT8UjG87aoN
	IspVs5tvSNnmq2ij916dSHvrcztzpg0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791496096;
	b=XfZN7GIG6DD8hyYrSyrKJ/9334bZYbgL1hsePvS+NPJmKtStr7P/iWEZ3gh9jb4LrT17KB
	0HAB/wPOlgRc068h5E3y9AlAozj/IjBlbXWqgcX6uRzmQrjdC+hcv0AytuhCvZKBe3IPkk
	SLrE1SrKOum9c+709JzDv8j33rl5n6I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xkSnrgLF;
	spf=pass (imf31.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.234 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JHSucTSg3QijIyFlRiljDu/KhLUuZiBG3coap6ISBt0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791496094; v=1; x=1792100894;
 b=xkSnrgLF/dlsQEamjwaapG2CON4B1Vul0chudMCXr48T0B1DYxYi5112t+61hanWqqLcBiRl
 Ntcfo/4UsCEC2WpdrOneHifKEpPnrOh6RVwMLRfjv1CiNvEIKzyPf4gF+6BjVQab5/WpXOUohtw
 LDnAMeGBO703HZYExiav+loQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 871702971b78ecae;
	Thu, 08 Oct 2026 21:48:14 +0000
X-Mizu-Trace-ID: 871702971b78ecae
X-Migadu-Flow: FLOW_OUT
Message-ID: <e139339c-1e55-438b-86bf-0960ad4029f1@linux.dev>
Date: Thu, 8 Oct 2026 14:48:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vma: keep the unlinked VMA off the file across
 unmap on mmap hook failure
To: Oleg Keri <okerixx@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>
References: <20261007101800.58d50b1b20a10738e630bfd5@linux-foundation.org>
 <20261007194708.2009-1-okerixx@gmail.com>
Content-Language: en-US
From: Ihor Solodrai <ihor.solodrai@linux.dev>
In-Reply-To: <20261007194708.2009-1-okerixx@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1D1DE20004
X-Rspam-User: 
X-Stat-Signature: gewzdpim94p3ihgxfmap55sgnhz17stx
X-HE-Tag: 1791496095-967404
X-HE-Meta: U2FsdGVkX1/hpq/Y+QCiAXg1KGInIrwJsXSQ2T//f+pcQS4I8L7sf0CKqdW2sZkzM6YBPLPB8R19AV6zxh+QApFWz9wCVWR7P6YkkOKLUXOJbosRInXiJfDnHbduPsb269Ebb5LbeOQmyP6+I9+wwtXoFzLu9zCtejKYEeCVLHXkDTr1b7fTIB/Fo65A/b8y5ejxC0JdUj87vEJznpoD/vpkfoKTJEb5uXvTc+bp2tYj1aIgkKYUDFZrEpwoR/lSVbOihIbYLAfFCJvAOVMyI48JPa8y+Z/+oiRBWmGwdgUcApZDGkaum+CSrDKghkDx/BDn+MaO0faeCKNYWrfsSeAzkbg6Sl10FE8y6FNJ76O5fQh+DyOMJYg0VZD8OTlFhNaTtKYB/tpdh79J+71meIM286EBvsfAAT0104jNeg91WbENwsupamsQXfvmKnCyWKbzvqiZWxvIAHuKbZYSzzx0Zi67c1dAmZaOIG3uxR6O5QG1UKg81GpfeG/oz+9nu5LmdK7jVHKRba2HcuLzCSgnmd5ph8+6Aquc6KvJ+ZK4IfIWGq2CrRv9zzAs/Bhai+ngZb48re0aKTxNy0fWFDXoCmLGHIq0XO9ORTlLNkCLNA7v/Z1Xbjf9kYz4ZPtfr1Xu7cimYfvD0MjCINzGlxVyWpA3TLNIIk/arTWcClPimXyXtMxwSJyuKS78wj27+SaesdGJeRovRKuwyIKpKVlxtn+eGgI8HLA60yFK0YEewNh9RRVmQrfFmx4R/muYXjjjk91rjpaSBxrcRgZWYjHvd0+grjMr4uosXrWWfNxp2GX4Hj9PNd/g7BAEaxCbW8AOr2rnL2SQHltfUAkpQ5r1txkhCh+VpQH8LBpRhxBfqIN5UqKPLiKQfbCF8bCwAhxzWda7LQXdrcDG4Z1271J2gjZEejmN17hRGL33dv9PytqMxebheoaZ3k9zsP/qo1tnK5jSDby6TrDDJFw
 P0P99pJ4
 RRZ6fKWH+H399LqA+D7ELFeca04azD7RK8g2Al8ChykzHGzB0eCP++V8yAuCpYOfHt2Pk6VmPgxRf5wwuqcppKB24z37/ptqttEnPtysfumfGylXrRHKixBv8atXo80/N4pnLN11gyCLSayJ5nYirSmVMjb7l+4zsH43OaE9R2n/Ob2cCINVmtbpxEfd5X5pV/6bnav5E7m2AA/08WcUyTwEKLtNUDSn4UguqjeB7HOm1K1rcSdTEsTuMdXdd+OncumrmUGSzGgZEifu3nnauC9E/LTQ4jrUMzKTEWf+iDaYJIxjKkrjEwOwuLD0+peylhses
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/7/26 12:47 PM, Oleg Keri wrote:
> Since commit 2ceb21171dd9 ("mm: consistently validate VMA state after
> mmap[_prepare] hooks"), the mmap error path clears vma->vm_file only
> after unmap_region(), so free_pgtables() unlinks the never-linked VMA
> and drops i_mmap_writable. Once it goes negative, every later shared
> writable mmap of that file fails with -EPERM until reboot.
> 
> Clear vm_file across unmap_region() only, so that free_pgtables() does
> not unlink a VMA that was never linked to the file, and restore it for
> vma_close(): when the hook succeeded and the validation failed, the
> driver's close() still runs and may use vma->vm_file.
> 
> Fixes: 2ceb21171dd9 ("mm: consistently validate VMA state after mmap[_prepare] hooks")
> Signed-off-by: Oleg Keri <okerixx@gmail.com>

Tested-by: Ihor Solodrai <ihor.solodrai@linux.dev>

BPF CI caught this bug on linux-next as well:
https://github.com/kernel-patches/bpf/actions/runs/37736351874

The patch fixes it:
https://github.com/kernel-patches/bpf/actions/runs/37829434215


> ---
> v2: keep vm_file for vma_close(): with the hook succeeded and the
> validation failed the driver's close() still runs. Reported by Sashiko
> via Andrew.
> 
> Seen on next-20261006: one refused PCM mmap probe from alsa-lib left the
> device unmappable, so PipeWire could not play anything.
> 
>  mm/vma.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/vma.c b/mm/vma.c
> index dfa45c64222c..531e4f53fdd7 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2616,12 +2616,15 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>  	map->vm_file = vma->vm_file;
>  
>  	if (error) {
> +		struct file *file = vma->vm_file;
>  		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
>  			    map->prev, map->next);
>  
> +		vma->vm_file = NULL;
>  		vma_iter_set(vmi, vma->vm_end);
>  		/* Undo any partial mapping done by a device driver. */
>  		unmap_region(&unmap);
> +		vma->vm_file = file;
>  		/* Only safe once unmapped. */
>  		vma_close(vma);
>  


