Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE976CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 08:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40BD46B00BD; Mon, 18 Aug 2025 04:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3957D6B00C0; Mon, 18 Aug 2025 04:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2354F6B00BE; Mon, 18 Aug 2025 04:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2BC6B00BA
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:12:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E3BB139069
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:12:32 +0000 (UTC)
X-FDA: 83789161344.24.A486C07
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id E52E140007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:12:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755504751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CN6XG4uuIHF4W8Irdw+nTi/wMcYkYvFzKNumSMVxm4U=;
	b=O2vVmHMy/83QTR/Fa7ILvLIj45HYxm8yAhixGMz+HFPpdXbayYGSzHsVwEJAiXernqx43R
	rlv4ZBqK7qtlTXdwN8H6e3OdtYUy/SsbzPSb8wAFMVjZU4+iyHYtuYLPzaG7jeYNeXGc2K
	VwjUemW2Im1VoBL4lWQdmO72UTZyUA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755504751; a=rsa-sha256;
	cv=none;
	b=a3IEuHzjsIvEhKcKBWlV5uLNsUdwOwFk9sWmtJ1qPdv5XlrpDSa+SuoKfa5idL/qNDu84E
	MMXRS3IbpsI4hUwpo/ZsPETrTMZ+nrYVw9a1Zk50DrvoD9qUNujdon4TOem2O4kXEz0JFw
	ghBnTDqH/mUA5Zmi1CB0sDg25vO/ZZU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 028561762;
	Mon, 18 Aug 2025 01:12:22 -0700 (PDT)
Received: from [10.57.58.12] (unknown [10.57.58.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A60AF3F63F;
	Mon, 18 Aug 2025 01:12:24 -0700 (PDT)
Message-ID: <28d7d186-5068-4546-90af-f9a9a0147f21@arm.com>
Date: Mon, 18 Aug 2025 10:12:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/8] selftests/mm: protection_keys: Fix dead code
To: Muhammad Usama Anjum <usama.anjum@collabora.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, Shuah Khan <shuah@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: kernel@collabora.com
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
 <20250731160132.1795351-3-usama.anjum@collabora.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <20250731160132.1795351-3-usama.anjum@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E52E140007
X-Stat-Signature: t7g1jgjce4exjm7iys8yksz4btgixq4a
X-Rspam-User: 
X-HE-Tag: 1755504750-139410
X-HE-Meta: U2FsdGVkX1+ij33SLRtc6I7dqEN7lYrhkm5Afi4t9ZSfYetTiHCEWIC8cR6xP3bQ62NTgFYFRP6v0wUrwcxBLaX2+qCbS1o9yP/DwU4GKguXKdkwO4OuwPru8oH1Xqm4A1E940s/5HLqR3RKuI+xzQYfmf8qAfFkeRWEk+H+UCGVPbf8tVKX8UNEJQ8v6EA+A5KV1zfnUngMJUxUgiNdoMpMo7+0/OMkugTsefh57gJYav3/E6WSwbDhCGZj1vRKdXg8yDx1ZsSoBLn1nueag9QXjjNuLY7CZ94igL71e0qqfKwmet+85GyhZxFL9muqk0TwEURfCmcbFvnuAdMRn12W4SYjGINJr9OGMuEMASEsNXHut71MfXT68rBbNZj6JE8UTtoLik78dJ8OkRnQq4/xKe+VCt2h35oWm8IPjzUuliGOQ5uHbAfmfjUN6wrKAfhokmoeghtxbU7DbK3Ne95ZvRfDKWm3W5Ln9jN+t9uujAFqRqJEm+cv2KBseoAa5teaiGDyWKvsR0Or7Su7J3iAblLf58FKdndnNNxH02AdH3SQVm5UC9GHBXnp3tv2EJVnL0MduG2GQ424LTKhVVSPB6P/SDJuFjdd/6ATTvVF/bAyzx17uPtdzTUCj6067ck5SxLd0gRFL4qQKjpcvRBdDpEPpVCuKpobG5w7p3TnEYaohpe6xrZgnR+kH4P+g1g/omrAj6dYxSyqujndThH+AmgtyRO9mJBmsbwAu8hVZlkjq9eMJOC3RPexx0TvZ9RxeO9LuXaGUM6q7eP5oOFHpi++EU2ARo3ej+zfABq5t9boE/nxL+iV7+FKlI0Gq939Pi/vIxiZNOnuFfvZFGqJr+nQQoWfyJu5Tvj9HTrhE0djVHI9QVBUvew3oi9C+tqs9+vig9mVdBX5dOhCBORyfKQwJP/NfwNOfWdmGAZrgfFWwwER1bu5TcixF9IbtBefi/QPQl3JHX6jvae
 0caEuMBZ
 YwfvbLBADW8Kq68lvEZ9pOKRhyvs+1Jv8b3ip70rdNPlsbqJMjXeTGhvGBci4vr/zLLDpqF4cdIT/FtQtPG9o7CEpPo6TMtkkNqWMUoBh27ivqps+YR+VrMi/OIDWeNPMapjKBT2KmJNVDCgijzpAext/87abkxFfQpElsC8Oga3E0V1SIidoA+d+2r4BTBk8hkaB+H6jhvwPVpMxe6+KrjzA1O3AeXhUx4GOvRO+aCS00IbRdRRjFGA2fc7dSC7FHgXomSyZFt9HdxdqwUoau6jX51OZyxI+YzB3XAOmrfd87lI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Dave Hansen

On 31/07/2025 18:01, Muhammad Usama Anjum wrote:
> The while loop doesn't execute and following warning gets generated:
>
> protection_keys.c:561:15: warning: code will never be executed
> [-Wunreachable-code]
>                 int rpkey = alloc_random_pkey();
>
> Let's enable the while loop such that it gets executed nr_iterations
> times. Simplify the code a bit as well.
>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
>  tools/testing/selftests/mm/protection_keys.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
> index 23ebec367015f..6281d4c61b50e 100644
> --- a/tools/testing/selftests/mm/protection_keys.c
> +++ b/tools/testing/selftests/mm/protection_keys.c
> @@ -557,13 +557,11 @@ int mprotect_pkey(void *ptr, size_t size, unsigned long orig_prot,
>  	int nr_iterations = random() % 100;
>  	int ret;
>  
> -	while (0) {
> +	while (nr_iterations-- >= 0) {

Now that is a good catch! I had never realised this whole loop was dead
code...

The question is whether we really want it. This code looked exactly this
way when it was merged [1] so it has never been run. It looks
suspiciously like debug code.

Dave, should we just remove this?

- Kevin

[1]
https://lore.kernel.org/all/20160729163024.FC5A0C2D@viggo.jf.intel.com/T/#u

>  		int rpkey = alloc_random_pkey();
>  		ret = sys_mprotect_pkey(ptr, size, orig_prot, pkey);
>  		dprintf1("sys_mprotect_pkey(%p, %zx, prot=0x%lx, pkey=%ld) ret: %d\n",
>  				ptr, size, orig_prot, pkey, ret);
> -		if (nr_iterations-- < 0)
> -			break;
>  
>  		dprintf1("%s()::%d, ret: %d pkey_reg: 0x%016llx"
>  			" shadow: 0x%016llx\n",

