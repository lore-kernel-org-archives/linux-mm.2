Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75B13606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RGkwUZO4
Received: by kanga.kvack.org (Postfix)
	id 6F32F6B05B5; Thu, 29 Oct 2026 15:28:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3A86B05B6; Thu, 29 Oct 2026 15:28:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5936C6B05B8; Thu, 29 Oct 2026 15:28:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 349566B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:28:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5025F404C6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:28:32 +0000 (UTC)
X-FDA: 85376650464.30.B5FDEFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 26DC214000E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:28:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RGkwUZO4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793302110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0+5ubFd1J4lsWZ084UYpuCIbDZPJCuWoPpCJ9/g/fE=;
	b=kIlK9g1OAQWmTcIjFwI9t45WHnLDuugBBpA677rg0hxjyFMxHvCwhBHaQxtBTNuxe6u9uw
	vncXYWdk+FpEIoEH/8tml0LSxzTqrUrpphutNbmOXSmDunvgngvTjfySn8DdSqvjsX4TKu
	YoyWpZgtKi/a3EQewVoL49eZZeqnemI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RGkwUZO4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793302110;
	b=R7F75YYQnVozMIy8HdERb6zYwzV100XkVZvmpn5vQA+ElTa7ryD2kAb4HifIIJE7c4QG7W
	iz1s89RW7+ttcKqehAagFYhGAHqVsMncHHRF5/kz/ggCTOAgXjrn1qlLWbEpgi0aY5pW1E
	45ltDYJKMemzySwLS2hy0ZczJA5maH0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22A8643BBC;
	Thu, 29 Oct 2026 19:28:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 274F21F01816;
	Thu, 29 Oct 2026 19:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793302108;
	bh=l0+5ubFd1J4lsWZ084UYpuCIbDZPJCuWoPpCJ9/g/fE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=RGkwUZO4lk0dRv+GCt6hx+Fa3JOBxQ5LpFilAhtlj+7EgNtaLZsNIsmN7bBZoimWF
	 mbYVmeEC6H8Wal5rW6OFzXmN8XqQHluMk/wmMoiH7gkBHSF8eJ0ss1U8W/vFZnIjY0
	 J9etYb5B/EbNd0+VKAQdCBGYywn3pjsITdP8ljx0ZZjnWMLsh/h0q2Xmya5JARAT/e
	 G/03IGzogJXIVC6ACnxCg2WckjZFCOVBszefNj4FOk0Kp3mOnXAtdZz/E2F9FSisRn
	 k/+IkAHFs4FpgJkfprKkYtiyXUKTuK6I+YkkcS8nHysmEKvq/kQ9WUkcGsmDERCUYJ
	 yxpeOhPFPCKQA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 84372198003A;
	Thu, 29 Oct 2026 15:28:25 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 29 Oct 2026 15:28:25 -0400
X-ME-Sender: <xms:Vp7japqDDH7MTBpj2o1_0HawlWVyvY0FOU7D8Nd9IguEUhdaix0NLg>
    <xme:Vp7jamc4F6MAAJVzCkF6_bNAJ-7k-8SOvhUA7n3HuyFOvMyH0BMFlNP5K3bDlVkmU
    _MmSSbFPwfBRpUeSAyALsDRKfHwP5svjvMMMnJX_-T0oDwT3xHlOQ>
X-ME-Proxy-Cause: dmFkZTEUgvLRPruJWwMD4Akvs3ZiKwYmL4oDztPDoA8hrr5wiy3BkBr/L+J8ffIc495+a8
    sVhiVVtwPIuNAOKAlOpndG4mY3OFBA0yxH/iDkko4Iw92VWlZpDVx91SpbqSTdnJwCsCmq
    fNWy+5fryrK9SVPiry0Lo1zBi6buqOp0lcoqLNhSe+EeqeBh3swNKQj473ROSt/e3Q3YzT
    Y6Vqe3oHE7LWnGQ7fdLxgfCMkC2+Mben6NfQDOT8lpSGnMgUR7e0byjD60bSFe5B3Hne7U
    w5Gfiok6+D9TuVISthJHKLQtTSjEFU84bn3lh0P6LFT1Swa09hrw4mNbqBD5zejN/EOIVm
    llqnU5WA+hypRMru22igAtp2EarCpc/fa5olztzEdkS0JpQS4cjmX6GqUrUxqz7IITIK4z
    K3yxyQbcBGMl04ZmpOqisSGPU9G/2asCSPnYRTSQLv5jInUHP/+yzOxTPG2wbvC9GhIS8Z
    nwAjnIxctRgMiScIn7m6OoJIyndLKBXCkesgX55ummn8NiOto5buDBM9zYGYlz6iHP3oCs
    7guFdH0nVF56k6/788zHoqITj7rHth1rQqq8VphlCPUZPp0f0Tf2V7S+aum5FfPDPzLsPo
    sw2J/w3694XUXfHo/Js1a6n736sSGucGslN4UA8hN96a5+o4rLIesRyiQSiw
X-ME-Proxy: <xmx:WZ7jam3_6jP7JYZKi7_ncq2u7jb1GraqdICHIIEXhUjfDVgazjJ8Gw>
    <xmx:WZ7javjQ0EQPb0oalPZ_Y84GSb9fuBCm5hcsd0-_BmBh8nf4QJ4h4A>
    <xmx:WZ7jasZ9VmdjIbSXaeztyyyt16GVwnJztwEObzWgR8yzA6LOMR-XqA>
    <xmx:WZ7jagN_FdpPrbKtzGVUnXth4ieCquH3vlgtCHvjBwW2p6cxqSnNgQ>
    <xmx:WZ7jaoR32XkuWPNxMvWbVBj2VFK7d4bzjxxEq1WJNsRrSY-uXsbr36X4>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id F28D7F80093; Thu, 29 Oct 2026 15:28:21 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 29 Oct 2026 20:28:01 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "George Guo" <dongtai.guo@linux.dev>, "Mike Rapoport" <rppt@kernel.org>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>,
 "Pratyush Yadav" <pratyush@kernel.org>,
 "Huacai Chen" <chenhuacai@kernel.org>, shuah@kernel.org
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, baoquan.he@linux.dev,
 ruirui.yang@linux.dev, guodongtai@kylinos.cn,
 "WANG Xuerui" <kernel@xen0n.name>, "Alexander Graf" <graf@amazon.com>,
 liukexin@kylinos.cn, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-efi@vger.kernel.org
Message-Id: <2382a0ee-cb6d-4572-be6e-ce3cf4d006e5@app.fastmail.com>
In-Reply-To: <20261029172956.20791-2-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
 <20261029172956.20791-2-dongtai.guo@linux.dev>
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a configuration
 table
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 26DC214000E
X-Rspam-User: 
X-Stat-Signature: d73o1hhwxb593xnf7q5q7ut3gaazngg6
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793302110-322073
X-HE-Meta: U2FsdGVkX1+WmHJpMcC8STQ6lbuvow6AZ0uWOm0sQVIsZu5XGghreZNVDA382BZm6seI0Djc9Fl9+bpS5rYcKPSaM1U3sCZJZEjlIVVhndKTWPp5aB/CJa9imuOIHvFceQLHogpu5VMlsUj3w+JdOShN71qPrS+SJhRH2/nXw5Iw2SRStqPft0EL6z/Z9F5ZW67dtMxgwxf1n1CF9c/z5ANruVIzXOLDlqSwqYYvp3eTUj/3CvYRNH6FwofrJ04UX5iJakh2hhnDcqkXxnQ+AIkEhKLV6UKsddG+zo96l3JyvgozG/zdLPV/e6geRGrGdlOQV9lpFeOywqx6MwRwOJnY0wMJInyqSyl1soq+MT9Q9V05KQ07D5iPVx2sbfqVTOq0DkjC0juBLzprp+mDGHKJTLF2oQgrVsJsc5B1rGgFzzwMOXwTTsmrWDdm+O2dV79k2Ppaa6bqecHJCYX7mYbaaLCHnnJav3AaXsy1X5M040TJhvqTg/LH6UHAN5qpbZ/nzg6TKknnK3nj8ZcPLdVBifjz6QpFHsiNbngk9OciIQRAOKOZh3XzE9nb3IvwYea3nbJUIjbzWifLN7xz7cRto1LgcnIMRFnz6hJX4tSKw2/CbjwyD3SWkheThmaHC0XtlGHI1ttd06nLgXAS5ByKyoI7cc4X07dPCkPST0rrgMh4F4OQvJxnNnXgAaj+19knZWEr/WbKZ03B/hpZRGBzCzkJGg4DaAtHv407JzGMIQMLFN2GrVNshY5OpO9uCFxzIqpbYVNbUnxYw6qjrrwuyo7IGbo/3PAhWY5aACZmUSXuAcFXMrZX3HStv/bRJUequMVkxGy/kdwcRshFcjsYVaOL2j+S6Hp5/6/aQRQzbTKbGu/jyWMoB/qyWVD4lmmBUUQ07/NcEl7JWQ92F/TLEkwK/lyuagYjIc9aEdBtBMAA+wbiGWznxWhZcWSgZukrny/qHvYcoAs9gqn
 k7U4cWyO
 c+I8wUzU1FdIH5BFAQhooWgNiqEQ5lqsizqnNHcguWueZjj3D49iIllsDlX/EO+X+1YgQS7U3pTXobXN9ndoQ8SIiYDhq9Xgu1HDULbf/3bmS+Z833Qat6jW9G+DxUIdBBbl5FABCXpB7ngtFuq+T9/Ejfjbh+KNiU1vlfmpRt/hAFNLaGUuE85eTX3qVZuqh6+sJ2OjMbqNsdwbmeyqIlt4PLY4xYpSra/Ol
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, 29 Oct 2026, at 18:29, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
>
> KHO has to give the next kernel two addresses: the KHO FDT and the
> bootmem area list. arm64 and riscv put them under /chosen in the boot
> FDT. LoongArch systems booting with EFI and ACPI do not require a boot
> FDT, so KHO needs another way to pass this information.
>
> Add a Linux EFI configuration table for them, under
> LINUX_EFI_KEXEC_HANDOVER_GUID. It points to a struct linux_efi_kho_data.
>
>   - On a cold boot, the LoongArch EFI stub installs the table, zeroed.
>     Each kexec'd kernel is given the same EFI system table, so it finds
>     the same table.
>
>   - In early boot, efi_config_parse_tables() reserves the table so
>     neither the page allocator nor kexec segments use it, and calls
>     kho_populate() if the table holds KHO state.
>
>   - Provide efi_kho_update() to update the table before kexec. Map the
>     table during boot so updates do not require allocation or mapping
>     at panic time.
>
>   - efi_kho_table_found() tells architecture code whether the table was
>     found at boot, so it can turn KHO off when the table is missing.
>
> Only the LoongArch stub installs the table, and only with
> CONFIG_KEXEC_HANDOVER. Elsewhere there is no table and this code does
> nothing.
>

Can we handle this as an arch table then, and handle everything in
the LoongArch arch code?


