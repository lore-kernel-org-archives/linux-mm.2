Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C2C2CEACCC
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 21:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BCC98E0009; Fri, 14 Nov 2025 16:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CEA8E0005; Fri, 14 Nov 2025 16:37:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45C168E0009; Fri, 14 Nov 2025 16:37:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 305E58E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:37:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C389013A878
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:37:24 +0000 (UTC)
X-FDA: 84110524008.10.B033450
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E357DA0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:37:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YWpmgr6F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763156243; a=rsa-sha256;
	cv=none;
	b=6ifjaDKEEcsVaxfEte/SmmCjV7FyEz81Q7VME5rvONF2ZpvjXPvH4yxH/UGZ99AR8O/bfz
	CGXrPgIYTGtk9ZAdjD7yddfC8LDBUwx0djL3eqBgwx4ocVOKvFEyQg8mgePz2xkQydb/eP
	5jKHjfZpT26dg99dORd6kwImTpJjUsg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YWpmgr6F;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763156243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sSvOH+KEbo6eWuuWM3tJc+ORZh6TtJUmTBZnjyCLf4s=;
	b=d1jX8+u7YNg/VQfR8E1wgtPoB0JwiBHLS0qXby04NYhQk4aIxUojv+a5aPZnycOBOhmQjb
	G01FTr+uhQ2RoiWXPWxFyR3fs3QX+1cg5rJsIPQRipL2XwFY4wbUol9cNFvrKYl1oHdv9p
	QFYr5Oq1lTZQZPPR1aZyv8Z50xrKZhA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5B9343CEC;
	Fri, 14 Nov 2025 21:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A533C4CEF1;
	Fri, 14 Nov 2025 21:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763156241;
	bh=p2PaaE4qNapim90sAx+ok6tRDh5qKA1VIjCfbABRA5o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YWpmgr6F8/RqO+TG+ExgFsKIqwU2jK/1MuM4h0lj44jVzcDpbGaBYf9Gt8KuYPhyg
	 J+QUj1iUuhF5aCUuU+etXWwDT/p64coRtYH+MvjSygH7bt+np/ydqYkOzkjwTjfcBB
	 gAacq0OrjE+9uCawPsTUOHa9nHNp4uzVwvLMOgwf0oifM5ptMCCAidA2fz5A8fD4MM
	 oJS7GBpiUyY6/Qugx8VaB14yQ+BSJ0caWCvBiNz6NK1rprEN9VdkvmhumWbVX7iyyC
	 OFMUBl1gVIAnAIEzZkAyLNZKIqxoOAioYYZKoVlEiXW9Bz9jp8TeP0ZH3OaZ2kRwlg
	 C/4vEz09ymByA==
Message-ID: <0e0fb943-1d42-4b4b-a4e4-32e95a0dbe6a@kernel.org>
Date: Fri, 14 Nov 2025 22:37:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] Remove the "FOLL_TOUCH" test code from gup_test.c.
To: John Hubbard <jhubbard@nvidia.com>, peng8420.li@gmail.com,
 linux-mm@kvack.org, akpm@linux-foundation.org
Cc: osalvador@suse.de, jgg@ziepe.ca, peterx@redhat.com,
 linux-kernel@vger.kernel.org, dan.j.williams@intel.com
References: <20251114161127.193707-1-peng8420.li@gmail.com>
 <6869aee5-0093-489d-bac7-fa718bdcb362@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <6869aee5-0093-489d-bac7-fa718bdcb362@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E357DA0006
X-Rspamd-Server: rspam07
X-Stat-Signature: yakkokftu3os8quxpsp8fb95y84r3115
X-Rspam-User: 
X-HE-Tag: 1763156242-561536
X-HE-Meta: U2FsdGVkX1//DaO+J9nnJkWfzJDt1dmRLb3rynuoy+jytdPaHeGvEROYjjVu89/maBKWOBvU552eBxRkl2OpdS07H7eFrCCxzz0DZXDSdCN8jfonjh00U8FqD3UwDOJbA33uM0+hxi1Bza12g2QJEOFU/33zuwDyIEjXNwyt84cNTpPUQuR1xE+jifPV80a9APZW2baxna/ZPP1N/De41jdl+Gh74g11JjqGnjRm8/PF3HwzYWGLtUzlL0t1gyWDZN5M0qTd+MAaySO04Bw+XQilRw5tTem5V3n1KEIPTWcpp2BT7vIJFut+gUYGFGtP/DXpMyj2g7WHbnRyE8kETI6Rl4Ow9kczdOdzdMqZEGqMMnriNhKLtU+rMRk3uH5GSUQKtd72AxqlpIzZ/NBfFDjdeFr3apWFpJzsqyCVhI0pQ0+wou28TejUNobBmpKYZ96yhQFXrV8w2l0tjIWqJNOmEHUTU+gEjP3JBnDnrBwH3zSaVdpSbUYXGVDTIjnGSorudi1na87AFg8MMX8Qo4tClXj8tPy2/g8jWWALDzCJISFmDwu2Y85T94OIeFjcjcN0HpgBSd+n6E7uVgAdt+I+dxHjw+XF4aYe/Jp9AmpQrfhp9Yok7vhWqzBBpTJYOoNJDsLY79wpaiTzMRMXlSfJaYR6mOdId4I0D3/osYSTAVZOzTbjg2r0PmATO1Fhul/HSO2LBqwxWEWcNmOFRAlfZhUQjiGkz51ttWpU756kaegIgm1q8vbs/uOQBiePjokOOnqEfwoy5fA+9iMpOw6l3iKVK96lqxi0QAwFlT9PigztkblkKnoSoaHCE8Tj2JMZmlXhjTE2B/W0brGJENaTL1nLaA8Hp/2AAfzueHLVjRHlv+fwPp/h0m7YE5yIzPx3oT4YGOeQUgmuUadIi7+4pZI7rWNsms6GPxcnyB3Ky1wlMNPs+YFavSyewNKaI8SiYBXbvykB5IGRQ7J
 z6gd0VyQ
 0yoEypwPLOiOYlJPD5nOhmYgkf77h+chodC98u6dvDLbGYkit5SofHOiOnmfS0trXQR7ho9k98hrqjecZumEotXuwzv7aMQEPdOoh8WujYlgOM9F936xp503+8dXk+6iC94As/gTxemyspq/4NX7fC67O8vudQ3JFTvuiiORxhKjBS4bm+NyHMuLfuuQOsXTVvbrqXEuamPyGZxnp47tnm5AqFDk9KZjokonDlLtPTb4s1TAEJZ2ChxX36wXBj8If5NQFvvf9DHWoFPCRwQiFGUjXL/jltFUPQOIMltaFS225H+ifGgVn77FP2Hnmbvb+/JUDJ/pN/9Q8I8cvoXMHoDLxLI31P4iSgNm5+g7dUhw3AJ6amc3zqnzL6j+Cba7I9+bUrWvxKuVJknadGv3kGzEPcnKd1nI9EX6GVrHjqLy0EdowhFjXca3O22Dwf6A7SQj+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 21:24, John Hubbard wrote:
> Hi,
> 
> The diffs look good, but the commit log and your replies have many minor
> issues that add up. So you'll want to avoid them in the future, and with
> that in mind, I've listed all of them, along with suggested alternatives.
> 
> On 11/14/25 8:11 AM, peng8420.li@gmail.com wrote:
>> From: "peng8420.li" <peng8420.li@gmail.com>
>   
> This should be your real name, such as (my first guess)
> "Peng Li" <peng8420.li@gmail.com>.
> 
> Also, if you are sending from the same email address as your "From:",
> then the "From:" item shouldn't normally show up (it's harmless here,
> but could be cleaner without it). Check your .gitconfig send-email
> options and you can make it go away.
> 
> Also, when replying, your email client is apparently using HTML, please
> fix it to use text only!
> 
> Please read the patch submitter guidelines, too:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submit-checklist.rst
> 
>> Ever since commit 0f20bba1688b ("mm/gup: explicitly define and check
>> internal GUP flags, disallow FOLL_TOUCH") we marked FOLL_TOUCH as a GUP-internal flag.
> 
> Not "ever since", but simply:
> 
> commit 0f20bba1688b ("mm/gup: explicitly define and check internal GUP
> flags, disallow FOLL_TOUCH") marked FOLL_TOUCH as a GUP-internal flag.
> 
> Also, it's best to keep the line length within about 72 columns for
> commit messages.
> 
>>
>> Therefore, remove the "FOLL_TOUCH" test code from gup_test.c;
> 
> Trailing semicolon. Should be a period.
> 
>>
>> Otherwise, executing the test command "./gup_test -L -r 100 -z" will report the following warning log:
>> TAP version 13
>> 1..1
>> ENCHMARK: Time: [   39.363371] WARNING: CPU: 1 PID: 117 at mm/gup.c:2512 is_valid_gup_args+0x66/0x8c
>> get:2818 put:46 [   39.364043] Modules linked in:
>> us# , truncated [   39.364311] CPU: 1 UID: 0 PID: 117 Comm: gup_test Not tainted 6.18.0-rc5-00324-gd09eaf415c87 #29 NONE
>> (size: 0)#
>> [   39.364434] Hardware name: riscv-virtio,qemu (DT)
>> [   39.364546] epc : is_valid_gup_args+0x66/0x8c
>> [   39.364596]  ra : pin_user_pages+0x38/0x78
>> [   39.364630] epc : ffffffff802079e6 ra : ffffffff8020c214 sp : ff2000000041bd20
>> [   39.364650]  gp : ffffffff81a26068 tp : ff60000080b3b000 t0 : ff2000000041bdf8
>> [   39.364678]  t1 : 000000000000001e t2 : 0000000000000000 s0 : ff2000000041bd30
>> [   39.364697]  s1 : ff60000081300000 a0 : ff60000081300000 a1 : 0000000000000000
>> [   39.364714]  a2 : ff2000000041bd3c a3 : 0000000000080000 a4 : 0000000000000001
>> [   39.364731]  a5 : 0000000000010101 a6 : 0000000000000001 a7 : 0000000000000000
>> [   39.364747]  s2 : 00007fff7eeed000 s3 : 0000000000000001 s4 : 00007fff7eeee000
>> [   39.364761]  s5 : 00007fff7eeeb838 s6 : 0000000000000000 s7 : 00007fff7eeed000
>> [   39.364825]  s8 : ff60000081300000 s9 : 0000000000000000 s10: 0000000000000002
>> [   39.364842]  s11: 000000092869bfdc t3 : 2152ffffffffffc0 t4 : 00000000001fffff
>> [   39.364855]  t5 : ffffffffffffffff t6 : 0000000000000000
>> [   39.364867] status: 0000000200000120 badaddr: ffffffff802079e6 cause: 0000000000000003
>> [   39.364949] [<ffffffff802079e6>] is_valid_gup_args+0x66/0x8c
>> [   39.365036] [<ffffffff8020c214>] pin_user_pages+0x38/0x78
>> [   39.365049] [<ffffffff80278f78>] gup_test_ioctl+0x2b4/0xc08
>> [   39.365060] [<ffffffff80297da6>] __riscv_sys_ioctl+0xba/0xc4
>> [   39.365072] [<ffffffff80b93f96>] do_trap_ecall_u+0x296/0x370
>> [   39.365093] [<ffffffff80b9ef06>] handle_exception+0x146/0x152
>> [   39.365220] ---[ end trace 0000000000000000 ]---
>>
> 
> We don't need all of this output for such a simple case. Just the
> warning will suffice, and even that is optional for this patch.
> 
> 
>> Signed-off-by: peng8420.li <peng8420.li@gmail.com>
> 
> Same rules for the Signed-off-by: real name needed here.
> 
> Combining all of that, your commit message would look like this:
> 
> 
> From: "Peng Li" <peng8420.li@gmail.com>
> 
> commit 0f20bba1688b ("mm/gup: explicitly define and check internal GUP
> flags, disallow FOLL_TOUCH") marked FOLL_TOUCH as a GUP-internal flag.
> 
> This causes a warning to fire when running gup_test, for example:
> 
>      $ ./gup_test -L -r 100 -z
> 
> dmesg:
>      WARNING: CPU: 1 PID: 117 at mm/gup.c:2512 is_valid_gup_args+0x66/0x8c
> 
> Therefore, remove the "FOLL_TOUCH" test code from gup_test.c.
> 
> Signed-off-by: Peng Li <peng8420.li@gmail.com>
> 
> With the commit log fixed up, please feel free to add:
> 
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>

Thanks John!

With that

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

