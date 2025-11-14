Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A0DDCE7A96
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 09:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AED138E0013; Fri, 14 Nov 2025 04:06:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9DD58E0011; Fri, 14 Nov 2025 04:06:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B3488E0013; Fri, 14 Nov 2025 04:06:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AF218E0011
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:06:58 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2703887D6A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:06:58 +0000 (UTC)
X-FDA: 84108632916.19.4107438
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E9694000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:06:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aJmU7D90;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763111216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wg0potO2m5v6oXBfIXmlvWrMNWrRqqdkTc/Rp+NQ/o=;
	b=R9zs/GCD/T7Fs9AfGVl+1JicnM0ea3zjZ0Fee86EFjDXi/BmBU8tHx1rhgA6YFaF/02RH/
	6cDbcfusTnx7pWs0SXEFVIMf08pLGp8K7XOmRdAbJQIqz822wWks3agLZeOfaB8o9BKU5U
	NOIXWiILMoFJOkbk6SlqnBV2bmXsV7A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763111216; a=rsa-sha256;
	cv=none;
	b=V/nAk9Yw9My/i7a6Jl9xaDhIK5hsXEQdGjrqq19+9owlTLUt1wRCroyg2k4ldEeEfywK38
	VN9cplGaGJ1ZcU0iXYDSZ7i15ZVMr+uTth7RbAInFb26E7qG+O3cMjEO4KKAzdZqaf92xr
	lsDpHRw+wTnqSqp1EV2juFSI2WYeaak=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aJmU7D90;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5ACEF4054A;
	Fri, 14 Nov 2025 09:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E93FC4CEF1;
	Fri, 14 Nov 2025 09:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763111215;
	bh=qsV+HCbv7VLcG4YR++E7I2jRabBKbnj46aXS2Ru+c/U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aJmU7D907gIQOowwYqh+AhNkcSDe+ZsooO3peE2t5xQdC/J2LmysdS0aPWlNRGvoU
	 /HG/u6c2tJDI/yLPsmxIcguM6UJvHesUZItJ+kxMoUvoVWl4a7KYoTOpWwA6BA4a22
	 5d66fQ17UcPWUoa0Hyz9Ck+hbB02Zxua/mmWAcXe2huVCNWkhJ7fDQNegU+t10mWP4
	 PHW+wPwy/OzdxmhH72TfIJCrbUTXHkgNolvQFC2jnjlj7LEPPeXe+z01BYT8Kxcv+p
	 2bSksdXtkmvQIqK3I0c9DGUKwDIUtsDubkYcMnLWBCxJya6TKLVvDOpSsi18emWNpC
	 btYDfzv5mp/NQ==
Message-ID: <e5c930a6-f10d-4715-aa80-64152b30d96e@kernel.org>
Date: Fri, 14 Nov 2025 10:06:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] Remove the "FOLL_TOUCH" test code from gup_test.c.
To: peng8420.li@gmail.com, linux-mm@kvack.org, akpm@linux-foundation.org
Cc: osalvador@suse.de, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 linux-kernel@vger.kernel.org, dan.j.williams@intel.com
References: <20251114085038.191031-1-peng8420.li@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114085038.191031-1-peng8420.li@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5E9694000E
X-Stat-Signature: y74awc156e71177jbzxhn6471qd8s4uz
X-Rspam-User: 
X-HE-Tag: 1763111216-965269
X-HE-Meta: U2FsdGVkX19L1QBAotsQ06L7/UhpYMcjqB2D2bIqcr8s5r/Ymywj07pwbnSJDk9W11nnD37TUDrOkqxyWJPbdNn5rPk83+cB9iJcj3vmeGVic22S5zUa6zpdUDf1Mmns8YoFoS/uVNzM84l695MaZCSpvnO1FXcYLLP8EXwJbpuuuMwgKdoQBPbL6NocnybfCpsPBp4LmzzKK0mk06a62SGlChHFAWpHwxVfMU68rSzvIJn5itEOaSbWkYCBDffwv3mN84LZ4bH914wpxHo95j+HoYwrRH4k+l6VJdxE5gQV9635Bm/+mWDFxPOrt9W8XFgId/fDExOARqjIO4pugqIIRBBmBd10PcCSoYJbe+kktBJjSfhfzeXIEB+RW6AwbrePz8BAn41XUmz6BHbgS+CeFO1TrzRY+R41RpuEjCz3+lLvFcADRJZ1/IU0ZNzG1kRCilzR40V3U1nyzcqxhgBFr0YyjsVqn8M3kM9zYMUBNrn3wOCOwmDhTY6qDisCYkVzoKbiefIaKeyQ8fguIlnnRll6APVnbGK7BWo6g9rZGAodE7HexCbtsVAbG6hLIooZqIveIPY+2FQmMZfQXHqOFjQkIfrHaYNTQDRTMlIMKUV5c4xWTJHsVNtEnK+i+OkPMbm9WNicu+g6vSY3YXnoYt1VccHLIIOmCaQ+J2h85HpDoIY0P7zTzibSCH6nWAksVAevlxjMuUeMJljklZJZPXLyuvMQhdC0uLyOUTgFoOznAJHjG5tnhL20fZHAmfmVBpBI58t4qB/ie4k4zd4mz48E6xH4MUYIYen9ViEo5Jtoo5FSQiWIJi56qokiSsgrqX/sN0szz0RweGv8u4UcEQjqJ/KsZbQsbKrJJdMZU0Zk0BeIj7Ksf3qR81AL/JxRW937EJotGmfOywoVtLo0i0wm8aDmoZK+MuaL16FCp/Z/4ZYhVeYWyEEqAIyykjntbaoDa/tFMG3q7z7
 SOoNVsQv
 c71j77pAttCKrWHQujHLP8b4bPYvzk+KM4saeYd7gT2ADf2a58CaGbbhrrvpMF81KEvc5zN43tcmr6mI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 09:50, peng8420.li@gmail.com wrote:
> From: "peng8420.li" <peng8420.li@gmail.com>
> 
>  From submission 0f20bba1688bdf3b32df0162511a67d4eda15790, we know that "FOLL_TOUCH" is only for internal scope use;

That is not the proper way to cite commit IDs. Likely checkpatch.pl would complain here.

"Ever since commit 0f20bba1688b ("mm/gup: explicitly define and check
internal GUP flags, disallow FOLL_TOUCH") we marked FOLL_TOUCH as a GUP-internal flag."

> 
> Therefore, remove the "FOLL_TOUCH" test code from gup_test.c;
> 
> Otherwise, executing the test command "./gup_test -L -r 100 -z" will report the following warning log:
> TAP version 13
> 1..1
> ENCHMARK: Time: [   39.363371] WARNING: CPU: 1 PID: 117 at mm/gup.c:2512 is_valid_gup_args+0x66/0x8c
> get:2818 put:46 [   39.364043] Modules linked in:
> us# , truncated [   39.364311] CPU: 1 UID: 0 PID: 117 Comm: gup_test Not tainted 6.18.0-rc5-00324-gd09eaf415c87 #29 NONE
> (size: 0)#
> [   39.364434] Hardware name: riscv-virtio,qemu (DT)
> [   39.364546] epc : is_valid_gup_args+0x66/0x8c
> [   39.364596]  ra : pin_user_pages+0x38/0x78
> [   39.364630] epc : ffffffff802079e6 ra : ffffffff8020c214 sp : ff2000000041bd20
> [   39.364650]  gp : ffffffff81a26068 tp : ff60000080b3b000 t0 : ff2000000041bdf8
> [   39.364678]  t1 : 000000000000001e t2 : 0000000000000000 s0 : ff2000000041bd30
> [   39.364697]  s1 : ff60000081300000 a0 : ff60000081300000 a1 : 0000000000000000
> [   39.364714]  a2 : ff2000000041bd3c a3 : 0000000000080000 a4 : 0000000000000001
> [   39.364731]  a5 : 0000000000010101 a6 : 0000000000000001 a7 : 0000000000000000
> [   39.364747]  s2 : 00007fff7eeed000 s3 : 0000000000000001 s4 : 00007fff7eeee000
> [   39.364761]  s5 : 00007fff7eeeb838 s6 : 0000000000000000 s7 : 00007fff7eeed000
> [   39.364825]  s8 : ff60000081300000 s9 : 0000000000000000 s10: 0000000000000002
> [   39.364842]  s11: 000000092869bfdc t3 : 2152ffffffffffc0 t4 : 00000000001fffff
> [   39.364855]  t5 : ffffffffffffffff t6 : 0000000000000000
> [   39.364867] status: 0000000200000120 badaddr: ffffffff802079e6 cause: 0000000000000003
> [   39.364949] [<ffffffff802079e6>] is_valid_gup_args+0x66/0x8c
> [   39.365036] [<ffffffff8020c214>] pin_user_pages+0x38/0x78
> [   39.365049] [<ffffffff80278f78>] gup_test_ioctl+0x2b4/0xc08
> [   39.365060] [<ffffffff80297da6>] __riscv_sys_ioctl+0xba/0xc4
> [   39.365072] [<ffffffff80b93f96>] do_trap_ecall_u+0x296/0x370
> [   39.365093] [<ffffffff80b9ef06>] handle_exception+0x146/0x152
> [   39.365220] ---[ end trace 0000000000000000 ]---
> ok 1 ioctl status 0

Right, gup_tests simply forward any flags we pass in. I wonder if we would
want to filter them for ones we expect to test?


I guess we should add

Fixes: 0f20bba1688b ("mm/gup: explicitly define and check internal GUP flags, disallow FOLL_TOUCH")

Although it's a bit complicated with gup_tests.

> 
> Signed-off-by: peng8420.li <peng8420.li@gmail.com>
> ---
>   tools/testing/selftests/mm/gup_test.c | 22 ++++------------------
>   1 file changed, 4 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
> index 8900b840c17a..75f7134d529d 100644
> --- a/tools/testing/selftests/mm/gup_test.c
> +++ b/tools/testing/selftests/mm/gup_test.c
> @@ -19,7 +19,6 @@
>   
>   /* Just the flags we need, copied from mm.h: */
>   #define FOLL_WRITE	0x01	/* check pte is writable */
> -#define FOLL_TOUCH	0x02	/* mark page accessed */
>   
>   #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
>   
> @@ -93,7 +92,7 @@ int main(int argc, char **argv)
>   {
>   	struct gup_test gup = { 0 };
>   	int filed, i, opt, nr_pages = 1, thp = -1, write = 1, nthreads = 1, ret;
> -	int flags = MAP_PRIVATE, touch = 0;
> +	int flags = MAP_PRIVATE;
>   	char *file = "/dev/zero";
>   	pthread_t *tid;
>   	char *p;
> @@ -170,10 +169,6 @@ int main(int argc, char **argv)
>   		case 'H':
>   			flags |= (MAP_HUGETLB | MAP_ANONYMOUS);
>   			break;
> -		case 'z':
> -			/* fault pages in gup, do not fault in userland */
> -			touch = 1;
> -			break;

AFAIKT, run_vmtests.sh does not set that flag, so dropping it should be fine.

-- 
Cheers

David

