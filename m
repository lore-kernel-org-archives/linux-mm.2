Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B561606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0vDZfee7
Received: by kanga.kvack.org (Postfix)
	id 8D4BF6B05C3; Sun, 22 Nov 2026 13:03:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ABEC6B05C4; Sun, 22 Nov 2026 13:03:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7739D6B05C5; Sun, 22 Nov 2026 13:03:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C02A6B05C3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:03:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B2182806E5
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:03:46 +0000 (UTC)
X-FDA: 85463528052.21.987EC86
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id C04AF40005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:03:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0vDZfee7;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795370624;
	b=Iu2jCFX80bXKZszaRw75Jm/DvWveIVmJDoWMlJFvianpapLXuTbM+wdsziZc+WGJd72ScM
	16zy0Z41JWicOrOhFVq/5EQJqXe2kwJ90UsQrT2E+2xEQEom5a73A3+ftDyK5LvQo/UpUT
	sYCTxi5n4FhLmhKB9SSjXtKUBFVSiII=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795370624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mu4XfoxbNIitLNaNoA9rOQZrx6f9uvt25KWkgZS+7H8=;
	b=Zb4JByXWAD/mTt7wwH0cYZNgE1EpSZkg7EDYIwgOGjeMbEeagT78p/t2SeBdLSAYYGtX+D
	rDFuha6QWfD1W5aiIMLpWo94HXksqcYq0DmgLlgAHhZ/fkXIVFTfPWd5kikBN4fw3s7/V+
	lp5qbFccUQX47Y7vZ1RbK8iok91t/BY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0vDZfee7;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a00so19112915e9.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795370623; x=1795975423; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mu4XfoxbNIitLNaNoA9rOQZrx6f9uvt25KWkgZS+7H8=;
        b=0vDZfee7MkN1gRGPGn+zSQfEvvMIehGgoDAI9mQX+Ql7W+sADbgoD9T5JrNINLj/CQ
         ++AvfqAgsHbQlkT2aWItjYYfGpOCKHw7OhW3AMIudTK9N6KcWECo4n4khA9UeMOtIVb+
         b+oDTfUrCMvJpkH/fQWMS1AoaH864RhPRojhcP9XDB6OHCeK0mibu3/Iv9fHs8Hiv/Ls
         BZPkR4c7KqAqE+ap58DfXAfziyZb0WbUNJXLyHbW84lujX7BzwojqRqdPYVbWJRqBW/7
         /Ro3yXMTd+WBT2S0eFxMWWbMMxdrD9UziFFmrTZ2IHTy/0iPMN33HKQf16XJH3zGy3OE
         p4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795370623; x=1795975423;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mu4XfoxbNIitLNaNoA9rOQZrx6f9uvt25KWkgZS+7H8=;
        b=kSnHKPqeFHEHRIvHdrcYTc7dc8FZLfZBQ7Uge8lGoccmKGo6LqvwlUS2ouED7qUV2m
         NGJBSyy/VC8MC/YS2ctZ6BARXhp56Mi/HbnIMm+rHtjN9gNwJ08NoMhf0C3BReKExus2
         J+1Ew82DWH5FxlL4M8CmMc50kaYjPwGX9m0hq0eFZHOvVnM9vNExIZwnLNsGD2Z+Jam5
         AWvORZwPMx/e0stsSxe4C+9z27Zm3Y7gGIU4Nr/qR77fjCI18fbaXgbufJwO/WrrGtb0
         deNy6h6KSw1wIIxMZz3gsYnVXnEjjHhqHOJ452z5G+ClETcvcYkhiCLpDefWRyB1D4lN
         8gng==
X-Gm-Message-State: APuU4Z874dKfSIJ7tMNKMVU4+ptIvfrUJlJ2JEP/UWNZCJ1fxVKB3sKt
	ulnraunVVqfp3h4r0ZnEoNR8ywOSLK6/0L6fvw1xV0KT43/Kv8Ausxy5
X-Gm-Gg: AZFdTZeIqfj/2r/KOyUtdDjd1JN0mcpUHhvOD4HYn+FDyd+pvHaiJzGUvDELvz6uNs3
	LgDkfndRX0ELzWTWUNLCkx15q3aCJeeV+aHs+LkKjqxYXHRI9I40o4oc1dyKwfREk8aRW+LLcQR
	drWY2vorbp3W4RBZY2ib/i4oDtbnvXx54ZyWUMX+4lx04ypySGIEDFpRRw71X4cco/G7xtsWqvx
	rj8oFGS6E4pvcRAChz9focJ0ArRzIKqv7aXto7v55G3xwlQRyGGXryiKNsuZGiXrPKuG1xk0qxb
	nEt5xk1FXnBuy0+SOmyyOvL5taxUXhfb3LP8VJgZqPAik5Eze4sFL73iJ6+baGMNdlLCA0w/zTL
	m/vAeTRyFeof2I9nwNsKW8U35ZI4P0S/OYhATga5OKRQRZZIR7MzLnpnK5mqKr+BrN2DR4bb6Cr
	8MhaqxXwY3c3oIETpnSsJ1zIrTVD8LUwT6ioF5NPu3U5gGzPqtFirzdFQbuY5guZr6DrH6Xi70i
	0vi/G8OABvLmjwXqJZzOksEnSZnztLIg83TTKtFCdkV6PtQSEIQwgqlt3yr36r/F4gDp5mkJvFL
	O8twKpWo3WLAQa3P0sVK/qUFvCL6jV5m8SNNyykjsEH+mg==
X-Received: by 2002:a05:600c:6298:b0:4bb:6375:aa41 with SMTP id 5b1f17b1804b1-4bb88934652mr177769535e9.27.1795370623445;
        Sun, 22 Nov 2026 10:03:43 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b216esm319512105e9.12.2026.11.22.10.03.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 10:03:43 -0800 (PST)
Message-ID: <9e6c20ce-fa40-469f-adbf-82d87b9790f8@gmail.com>
Date: Sun, 22 Nov 2026 19:03:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] mm/vma: make brk mappings non-executable under MDWE
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Kees Cook
 <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-7-236e925d9b64@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261121-some-more-ai-fixes-v1-7-236e925d9b64@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: C04AF40005
X-Stat-Signature: ijrzuguqhx7rnrbnx4u9iypfkpgmxcud
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795370624-321199
X-HE-Meta: U2FsdGVkX18N90WyzbH2n+lyG3uy5yFyzc9aL8n6G8zIQeY8Ml+uGMnxNc0Bczdgodlugc7tGKozYbt/aPfC0T4cGyKT24FoFHptaPdv3lGdQQdgeYZFK+q5grU1dgvrNLcM40o5y3mi403iaZ+EMPsi5Cx3kB3WJoFDxLmQ116GP2QcQi/tu1+mcGIapCerVB8VVT8tf78ua+5xj1InHZo2mFNKFbdEdDqHG5ZY8d6yDv0b0smyGolejejDXnA0R8hDtm4prgRGbhwjmutCkpImNwhX1n0zIsbexNLKGkpOLp2QFF5C22J+hIrEQRIQWF56aSPNsgIyMf0DVOP/oiNZUqxYOzl1Q+WASsGyZeHKK5mlzCJ9aFx9AlzmRywJZslnlVsPMyCu8AhyLi+YIgrxZT9tpRsLp3ZR9VQS+JHTfjEEAYq3ohvVPo6usUuK2uq+DZlyA19b/izYHyHB5/1zLz+3X3iYMstK/QHW7KGu3RDdjLwexVfykiFwMB+4vr4TuLzUV4lN42pd9iKmmvwSSlgIzm1pbXSRLkOHS1/XtgYB618kHZBnkgZokl7ijlAf/4wFJM6sqnsLZ/kvM7lzpGgK5gM1a72gVnQixuwdI/YXtPwxG+UiP7lv2p6Ql920nYbmHNHDVWLF+j+bqwNHW5qu1DlHPP496Nl+wrWpiioC6BWx+oByKUL+ggLEydAJ39d1j4k1sN/SIno3ProWXIfqgC3gbHS1FwgIc63Hw/v9iBuCWYAO8a2W5d6ZjRldhps/wCCZ05P5vLxAiqrxtuut16GGViuLrEA+RjhEuwKrhvc6D/KKuYWyN1yu3xyVmeYxWjk/3eDfPS6FFWSqgb+22h7fXszkWVtd2Q0ImOiPcGTlIYnrYK4ZM+FfBff/Ax3X6bMPZS8seoa0bPYICpndrar1QJVcIJPWjFcfJ4o5FCnLfe18hSlqyG4ITZ50XRRSU7KNBwLZ+aF
 MV/jCXt2
 muo8gpuFuyHUG/p/xMjMjyYH0P3JQX8f5npW9AnCNz5SopJmAjs1NGaTOA766UGs029yEY/Nbq8MEWCf7NtKrmpa2ap2zGhmfokz14hBGtifLTE7neEIh6I5FX4MfxBquescbRxkqUS9g3sxhF87Sv3am8T4Mt+ziAbolpBrX3OS/s88zu31DjBkmgNX4oNaCa2+mnUU55RXCo05HFhOcGThPvYrDmMJZOpY1vz/p4bQovPoppANqe113PryMFgkTnuXirDEGBR+QLoYMsZlBy06TayOqVpXJaRtPd0w5D5EIrHBuWNGWCi6aG6VESiyjkOzE9PpSq2AdR1Qp9hHDUxkjdkkQ1Qgf5/B0qYPPqhwqJdgzNuvbvF8q6t6C4ZlBp414ndFu8xHmxOqTGEl+kKPvwBNC5ILLLVpHC81fG73DWGUPUM3FeKCm4gMsy89Ah4uliTa7nnLGoYJpPzs7Dvvn5LdjF+/H9YE/+UIEyhKspbVTbE4rdR1HOBN4peAJmjmnr/n6aKXecUK7IdEzCNKi/gqiuwCFdM2sIT/CITaANDgBvdkfQtFF9yEr+lRPF2Y9WQfLp2BazfC2s0wXknUAOgluzdLXy8HsYY89ImlEBcL+UOuSssk2Qu89dmaBVP2NCSmbdDqD2BfoCMYLDepoxENodVmJ9U6RjMVnDhHS6+KSGX1mN4Cp2kQO+T2tgF5XkMurLtW8yfpKtYdk70tpz4CTi74CFaOpM3+3i6vE/UE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/21/26 5:02 PM, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> With PR_SET_MDWE in effect, brk() and the ELF loader can still create
> anonymous mappings that are both writable and executable.
> 
> MDWE only holds if every path that decides the flags of a VMA asks
> map_deny_write_exec(). mmap_region() and do_mprotect_pkey() do, but
> do_brk_flags() does not. It always sets VMA_WRITE_BIT, and it gets
> VMA_EXEC_BIT in any of these cases:
> 
>     VMA_DATA_DEFAULT_FLAGS is
>       VMA_DATA_FLAGS_TSK_EXEC    the personality has READ_IMPLIES_EXEC
>                                  (e.g. x86, arm, arm64, mips)
>       VMA_DATA_FLAGS_EXEC        always
>                                  (the default, e.g. m68k, sh, sparc)
>     vm_brk_flags(is_exec)        elf_load() of a PT_LOAD with PF_X and
>                                  p_memsz > p_filesz
> 
> Fix the issue by dropping VMA_EXEC_BIT if MDWE is in effect, so that
> brk() and execve() keep working where the bit is only a default.
> 
> Under MDWE, a task that runs code from its heap, or from the part of an
> executable PT_LOAD beyond p_filesz, now gets SIGSEGV in the cases above.
> 
> mprotect(PROT_READ | PROT_EXEC) on these mappings now fails with
> -EACCES. While the personality has READ_IMPLIES_EXEC, so does
> mprotect(PROT_READ), as on any other anonymous mapping that is not
> executable.
> 
> Fixes: b507808ebce2 ("mm: implement memory-deny-write-execute as a prctl")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: switched to MMF_HAS_MDWE test, tweaked commit msg ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

