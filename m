Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3028DCCF9F8
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 19:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69D268E0119; Fri, 31 Oct 2025 15:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674AF8E0068; Fri, 31 Oct 2025 15:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58A718E0119; Fri, 31 Oct 2025 15:48:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4718D8E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 15:48:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A2C6C05BF
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:48:19 +0000 (UTC)
X-FDA: 84059445918.22.DED1EC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 60ACC40007
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 19:48:17 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jhLrkMJ1;
	spf=pass (imf12.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761940097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOk5Yemoj/EUtBmuSqLXUFCB0md9XGn6wz8XL6oGqeo=;
	b=esyfrgnKCy7yeniBqvnDjURipTL3Ram/ouifyeNuadGnNzvhLoSI8E6Vky8vXKf6eVW/ll
	HOcHVAyiy0PcTX8seLAuK4acl2WvMN93N5IN8iHwQAh651D+amBK6PZxordMIVeB3How+v
	OhRjIETZ3ZnfYwtUut81RnHA1vnI8hM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jhLrkMJ1;
	spf=pass (imf12.hostedemail.com: domain of pjw@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pjw@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761940097; a=rsa-sha256;
	cv=none;
	b=NmQrOYkm5P37Gl9y/v3gkAd+h1U8MoQ4EU9wGU2LsC9EcpxdGH7aupTV1qCv53Zx3XPSrh
	HhkBfrabeVN5YlodcdJ6gEoULM0Bhd4BASxST9WXNUTI18pbnz8sEcwQFzGWH36i7TVJF2
	gFa5ABtwY9WBJ2SnEtKnorAQkIzlwcM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30BF343F38;
	Fri, 31 Oct 2025 19:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39D8C4CEE7;
	Fri, 31 Oct 2025 19:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761940096;
	bh=3XMdMiV5/Fkf0a0hQ2bHKVTveLYXM6aobfgWUzIzlyM=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=jhLrkMJ1Xr02uFTfEx/frXtknVpDmVQfc9O4keDaTkipOQ9UC1Zl+VCqb/XHpjJHh
	 lQQVWqtGbfmN+B56AGTydSbzItiFwivMka5zoMEb7wi2z26fZoRbHzGZY8u4dld9Od
	 XVUCpBVPQH2+rCLmX2+N8eUbM4jMy9/KcKhLJMKbkftUEMt3kMETRqJ8HDQPt3XMdS
	 hg6CyFsDb3ZDPaxbBhzVHVkM7RzbaYxsYNDtsNKPDiRl1ijnkAdS/KwKr8uh9QTXm8
	 Rcpa0l5VB5wzJfKbLCJBlJ3G4CL7pI1J6FfYAXpE44Jurnor7XhX5BjXzbIDDZf5uy
	 4J5wAbgnhUBeg==
Date: Fri, 31 Oct 2025 13:48:10 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Deepak Gupta <debug@rivosinc.com>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
    Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
    x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, 
    Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
    Paul Walmsley <paul.walmsley@sifive.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
    Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
    Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
    Christian Brauner <brauner@kernel.org>, 
    Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
    Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
    Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
    Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
    Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
    Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
    =?ISO-8859-15?Q?Bj=F6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
    Andreas Hindborg <a.hindborg@kernel.org>, 
    Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
    Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
    linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
    linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
    linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
    richard.henderson@linaro.org, jim.shu@sifive.com, andybnac@gmail.com, 
    kito.cheng@sifive.com, charlie@rivosinc.com, atishp@rivosinc.com, 
    evan@rivosinc.com, cleger@rivosinc.com, alexghiti@rivosinc.com, 
    samitolvanen@google.com, broonie@kernel.org, rick.p.edgecombe@intel.com, 
    rust-for-linux@vger.kernel.org, Zong Li <zong.li@sifive.com>
Subject: Re: [PATCH v22 10/28] riscv/mm: Implement map_shadow_stack()
 syscall
In-Reply-To: <20251023-v5_user_cfi_series-v22-10-1935270f7636@rivosinc.com>
Message-ID: <020e2f6e-9c1b-648e-3017-31eb8a89c493@kernel.org>
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com> <20251023-v5_user_cfi_series-v22-10-1935270f7636@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 9ct6fuh3cr3k6ogfysjsrhmu9o1hrp16
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 60ACC40007
X-HE-Tag: 1761940097-348133
X-HE-Meta: U2FsdGVkX19hKxIuZh3uu4CeSKAe9Qtzpy7tkCcD7a81akoQfUR/JqnbWdwoGpzrSYfBKVoczusTM8XaRq+iKaqWYfN0gCBLWGQfGH6TNy0CDdWlzHbxlq85Jnr3KdOqdMbFGk39gHJLJBJkfdVFe+cNGYK8x/XlsWXrlnIqYORU6nMrAGGnCeLclJpJ+w7mpZGNpBYzxP+Em54xcP7JYqCuCidmGEO2TVrBdE1RW5lzj8Hylzs/JgtzD7Rcb+1HD0VPbIsSWiHMhacTsQmx7egtjbLxOeiYHlWofsYv+KvAcLAmUSUcf02QsfT3Ih9QX94DYD/abOyYMEuFOWBA0GLPqz28OC4XjN81w8CdyMRIp2dqJA/GHU6WrbYm/yOM3UrJBrzMNF6Yu21EOlfLJi+WkhVsiccYidFxNTvEzY1Sm4QEgOF/1IfKbvwbKAmdy/B4gEbCF9xQtKFWgCFBmUY8HndUjlKnUN74dPF0i2b192d3cJ2x8f8LtKfH25rQPl4VYX+DfRC01maJ8Ymr0RhrT5e68Mgk6TzYTVDuGGoC8ki82gZv5Uf8+Q6wVToO7qzJ1RqHm4VuYMgmwAQzggTKCaDlChwCnzGb1ExX+IU8Hy3GbDB9Ash9VQ9UctJTRVygIkqQ8MKtu8iQlS0bIylFdOiH6oQmnibrjO0AWwfLQXiLgwTS7QE/FhL/fQ43QJkL5H2G8J5/dKLMyEV8wn6mTwCw9XmklRhodlCejd/8plGCu5mwydymWN3buZkGvwAb+qPREOZ1V8Dnj05Yg+EQCeLJsutM7mHwUaXpR3St4g0cmQA6xndpH+Mc2FdSl6lBsNzkjHDDGShndcxpO+88oKp3CJM26ogn9sFnR4z6uI5DDBkhfadPmJRsvOKArWPGYY42voHfXUjDz7UOkS0/SUsN+x2BZxRkRolbIObTf2t9lGiGqWMvDBCqjEDss+OEio6F/A+/+1g3amZ
 ejySc4zq
 JyllbwDOTvFKSI+FRWoXB/SJQznAPKgvs49sAWwUXCbK2fF3g9YmGtg0oShyQQon3DOvJsHNILNIEbEoP7n8TTkzQGVqOJrWovPih0z5L+94IUXh88HIrAEnsa/eozWMHYFVT8nVqnW3pv/bPKHNWPzK12ZuKzTMArtvi3CD+hUVzeNjMnLWOwEvJilI76DXklEOgHk9uk7baxsj5WwPfmEv3CdSZFPVQxCmEtvn86/5NUJsfw8er0CdVyXU0IN61JYYRgBDijg08a3rr2SdZWCD8nO21L7ez9AYBFjVhfrAZ537i39z02MZufyid2/rhIaRAkiNJx9ONyWL0V76rXn8jx9ZyMZn2b6SIBfSTEXiskNtTeNwk4JZzE6yCa9O9jNxvyRq5JnjwSe7kvMbkgo8grLQOjrLEUlAzGVCdtfbmKhiEFRJZPGqnN62IafgrKVuDIFRztM41l25EexUMTXpGhloKbKM3tay+xJU/7EjNpRo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025, Deepak Gupta via B4 Relay wrote:

> From: Deepak Gupta <debug@rivosinc.com>
> 
> As discussed extensively in the changelog for the addition of this
> syscall on x86 ("x86/shstk: Introduce map_shadow_stack syscall") the
> existing mmap() and madvise() syscalls do not map entirely well onto the
> security requirements for shadow stack memory since they lead to windows
> where memory is allocated but not yet protected or stacks which are not
> properly and safely initialised. Instead a new syscall map_shadow_stack()
> has been defined which allocates and initialises a shadow stack page.
> 
> This patch implements this syscall for riscv. riscv doesn't require token
> to be setup by kernel because user mode can do that by itself. However to
> provide compatibility and portability with other architectues, user mode
> can specify token set flag.
> 
> Reviewed-by: Zong Li <zong.li@sifive.com>
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>

This patch introduces a 'checkpatch.pl --strict' message:

CHECK: Lines should not end with a '('
#78: FILE: arch/riscv/kernel/usercfi.c:36:
+	asm goto(

I'll fix it up here in the event that v22 goes in, but please do the same 
on your side in case a new version is needed.


thanks,

- Paul

