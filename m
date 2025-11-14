Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 803A2CEACD2
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 21:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C796A8E000C; Fri, 14 Nov 2025 16:39:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51058E0005; Fri, 14 Nov 2025 16:39:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8DA18E000C; Fri, 14 Nov 2025 16:39:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A90928E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:39:40 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A831312E57F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:39:39 +0000 (UTC)
X-FDA: 84110529678.22.E429825
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id DBA0F40015
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:39:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iTkj1d7L;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763156378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUdtZTocKVmEDOOa/rvnXi6/2ebT6zwe4Vtw0yfLdss=;
	b=WYX4D6pxq+bJ0y4OWX+1WkGKVpaNKzQ+e+mlYLweqXhiG24qSzpqf2iuLh9M7xJTg5Ocjy
	OQLprn2wWz3NOo19t3jHwqsFAPiR6waxgYr+A3EB/npOaX8mK1CYqT13aUoSbU8tnMOIHg
	BlR3HSyxVrFaSPP1kmcL4qaGiDqK97I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iTkj1d7L;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763156378; a=rsa-sha256;
	cv=none;
	b=6D1wEnE3wHIV+sZesRbcvSw2ksOjTkglHAmlfG+TxtKcw51Z+XVsqQkS1mYHbjVmF/jN9u
	+l+Hiz4Ra+YCEDRzBrlHvmsFbP1Hf6lv7L2rjeUvDqz8wFFIuTKjZAT6e80/9Tj7vS2CCK
	/MTLhSQ3D4qZebbwB7CUeGBU6Pu/OsQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1B354400B;
	Fri, 14 Nov 2025 21:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF97C4CEF5;
	Fri, 14 Nov 2025 21:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763156376;
	bh=+CpQ+UMnmBXgdQjJo6/hU2rUsL4j7qOY0MVx7GNiZU0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iTkj1d7LUUOTcKpGB1JvfX/zdGa2H/zujUHfxtRKx1uSMr9Q9IkIrF+U68PTv4sAA
	 93vtvLyvRNnp1ub/gRaZ83s/mY2S1VU/b1lRD9UKLqPwmtBrcbbnBGomJ8KL6sji0l
	 Dg1Gct9hh5r5zPbB3JVZT3B7y4YAMB76IUQMgn1kAUmkStk3XZISpnfROqiDsrLZjf
	 xDvisWSacEwbQqDaxLeMCoXLcWToJSBK4XlXV8udnsSWVUAGwg9rSajOuc6ov7UWZS
	 JhhpfGW3VhjT26cHNi7tBDE22VIFtM7EbiavJqL8RF3YjlO3n/2ew2eoQroU432kbJ
	 RrmtEZ3hmVP0Q==
Message-ID: <de65f1c5-8547-40fa-91e8-6acb06faa163@kernel.org>
Date: Fri, 14 Nov 2025 22:39:32 +0100
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DBA0F40015
X-Stat-Signature: 5hiot961cfg8444ii4btmbzif3rcrxpa
X-Rspam-User: 
X-HE-Tag: 1763156377-595366
X-HE-Meta: U2FsdGVkX18U9ZCc67HcOP8KQzRkYN3xq04v45MQNxOj94d1BmtLGAYGB0VecHFH+yIrYUqLF2+jOFzsSb2tNCkTphQs7zMBrP3X+MPLdI/btFTA+xxn4GhW2K/bi0xbmcZVtxybJjoYD9tkQEhAs5nXce1Qumn+J7m6mweNDMdwDZDhRPEUqbyVTn/D8cexm89Pjg/xD//XuLq9vxHNFSzMwCHGd47Kwsj2kw7UY5JU16W7zqst3Y4jJ3m+8knbO8dE9I4+BtnDOLt5MnZte546SCBLyIZcF0X350JWDFqGOgLzBms5xM5AvlBPoiPHAg2uEoaG/Zx54chN6A8M92wZhpgf9uOHZxkDFGBgZoRvq9CpMDL+08JtinEs5Qkuj1dSjk9X8+dT4Oo9xA1CHTHODSu77olyUniDD9J9WkUHB+uRx7gPdroldjvQOZUcHbLrOaybWgteTnI73cjYkd62YZYB1ER1X3V0DBntxOdKLtlUMyG60+cbjomx1UJNC8CUNhfXKIc1DlfORRgUvNG7Cc235Lr+4XD8CoOri0WMv2oqIM/NLcHxWy2q4lN+cOn2EwGAwkygGd9AAyujxbUlVkDr7bk/Xjsyhss2xktJ2bhVp26YER+0pkB86Q/WimU2OxCCeGx7CI7eOWzRX4WOhtetb+UWeMwfmQyXao6vqJ8Lkoamoa0cvJ4xa5UAekDMMZ57TCFfK8VmpQ8KtTG1HevghJSSHjPp/30uwikPuscR3ZeLxwITAK6LFi972F0VXkl25m+oWkEY/eL0uQHkUYOcPAWrngE7kq81YSPF+XGgJpb+ca1Ft/RNeyLD7v3epQLypUAZ5qiZMRB3HC/9bfS0+dCstJgpxUssS0Skucz19C83JSrGxVgj7zUdQ7+ObnzpDSnRCUn1dP+gEyUzMXRNh+zU07s/ONraR4emGJ6k+y4uFggm6OYUUCLVN3/i3+n/50hiGauPZHf
 kcGplYcw
 BgpWkODZ48fFIuBgItwFCdQU3wNEqp4BYFV27g+aJOaVsBIcz3CFDZ29RNuzTsGw/AoPonAulGw6zuSIV1Y4egdy1VF5kPDu/ITyhF/iVYEnzGdrj0cMFoLMJTOBW40Ntl9ul22uojMDBjahidAF/Xb5SHSOx9azAp5GKj9cXgSc0Nk0wvjYapO4+7P5V1eFUsE8iWJZPVLLhIaLSFQyFE935B8x4iRNK64flt1R0DUtW8JthnVZstgtUP3SA1E5vpBb3aVNrR4QI/vvDWDvihhYo477SVqxkAo3V0X2Y+v5RSUcUTpa2OtXF9sRwac8VaPsORJc8Vto7AldxNhe49TUPe1h3bcuNOE6780dpYrX0Ll1+ed9gBlB74KN1Be6r23RA8+XWiWrxWxtiKj4z/onTpVwCQMEn+c+y3nIXYxUxd5mDTHz+fpfZcQTHqBJSy8mI
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

Oh, one thing, subject should be something like

"selftests/mm: gup_test: stop testing FOLL_TOUCH"

-- 
Cheers

David

