Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CCC8C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 14:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B26890009A; Wed, 13 Aug 2025 10:49:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26306900088; Wed, 13 Aug 2025 10:49:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC7890009A; Wed, 13 Aug 2025 10:49:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC82F900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:49:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9312D1A03F1
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:49:36 +0000 (UTC)
X-FDA: 83772017952.26.E622A8A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id AD1EB140004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:49:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of ada.coupriediaz@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ada.coupriediaz@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755096574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0tb+++lwvt7o4dnuA540qtPzkugVZMdbKd++k8Qh7w8=;
	b=VeNu7cgTjcyamVpcb7LR1pJngC4rlAa68TvJO/lColxGA/zuppWiFhFjLP6zHIev3MICN4
	5moMDML8/5JfsxbUIRjXKHJAOgP5VxHhSlVkCEdrUzVp83UKu1eNpP4fVtFmQ0GuAPaXIw
	C0sDeBaS7oL9BggemSchuLajW/gSRnI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of ada.coupriediaz@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ada.coupriediaz@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755096574; a=rsa-sha256;
	cv=none;
	b=ir9XrMrH0JeZpqd61O1LfZZcn7+tAt4ggsaZX6N7H10ZWrGKo0s0/J5qZS2abagA5zzHgv
	saVuMM8ZyL/Wn1t5yzUVgh+CyWuoXkfzqrCOu0PmZqAZguZh4/wc7MqnWlxJ9fM5eMqNXn
	2z+YcIBj+3OoNhtf67yBccWGldQkQUw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A16EF14BF;
	Wed, 13 Aug 2025 07:49:25 -0700 (PDT)
Received: from [10.57.1.244] (unknown [10.57.1.244])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CB263F5A1;
	Wed, 13 Aug 2025 07:49:17 -0700 (PDT)
Message-ID: <31bac00f-7903-46f7-a5a0-1e8f5fd8b9ab@arm.com>
Date: Wed, 13 Aug 2025 15:49:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/18] kasan: arm64: x86: Handle int3 for inline KASAN
 reports
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: nathan@kernel.org, arnd@arndb.de, broonie@kernel.org,
 Liam.Howlett@oracle.com, urezki@gmail.com, will@kernel.org,
 kaleshsingh@google.com, rppt@kernel.org, leitao@debian.org, coxu@redhat.com,
 surenb@google.com, akpm@linux-foundation.org, luto@kernel.org,
 jpoimboe@kernel.org, changyuanl@google.com, hpa@zytor.com,
 dvyukov@google.com, kas@kernel.org, corbet@lwn.net,
 vincenzo.frascino@arm.com, smostafa@google.com,
 nick.desaulniers+lkml@gmail.com, morbo@google.com, andreyknvl@gmail.com,
 alexander.shishkin@linux.intel.com, thiago.bauermann@linaro.org,
 catalin.marinas@arm.com, ryabinin.a.a@gmail.com, jan.kiszka@siemens.com,
 jbohac@suse.cz, dan.j.williams@intel.com, joel.granados@kernel.org,
 baohua@kernel.org, kevin.brodsky@arm.com, nicolas.schier@linux.dev,
 pcc@google.com, andriy.shevchenko@linux.intel.com, wei.liu@kernel.org,
 bp@alien8.de, xin@zytor.com, pankaj.gupta@amd.com, vbabka@suse.cz,
 glider@google.com, jgross@suse.com, kees@kernel.org, jhubbard@nvidia.com,
 joey.gouly@arm.com, ardb@kernel.org, thuth@redhat.com,
 pasha.tatashin@soleen.com, kristina.martsenko@arm.com,
 bigeasy@linutronix.de, lorenzo.stoakes@oracle.com, jason.andryuk@amd.com,
 david@redhat.com, graf@amazon.com, wangkefeng.wang@huawei.com,
 ziy@nvidia.com, mark.rutland@arm.com, dave.hansen@linux.intel.com,
 samuel.holland@sifive.com, kbingham@kernel.org, trintaeoitogc@gmail.com,
 scott@os.amperecomputing.com, justinstitt@google.com,
 kuan-ying.lee@canonical.com, maz@kernel.org, tglx@linutronix.de,
 samitolvanen@google.com, mhocko@suse.com, nunodasneves@linux.microsoft.com,
 brgerst@gmail.com, willy@infradead.org, ubizjak@gmail.com,
 peterz@infradead.org, mingo@redhat.com, sohil.mehta@intel.com,
 linux-mm@kvack.org, linux-kbuild@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, x86@kernel.org, llvm@lists.linux.dev,
 kasan-dev@googlegroups.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ada Couprie Diaz <ada.coupriediaz@arm.com>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
 <9030d5a35eb5a3831319881cb8cb040aad65b7b6.1755004923.git.maciej.wieczor-retman@intel.com>
From: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Content-Language: en-US
Organization: Arm Ltd.
In-Reply-To: <9030d5a35eb5a3831319881cb8cb040aad65b7b6.1755004923.git.maciej.wieczor-retman@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AD1EB140004
X-Rspam-User: 
X-Stat-Signature: zz8r17kwgenwniesbpczb5qn5kpncgfo
X-Rspamd-Server: rspam09
X-HE-Tag: 1755096574-252028
X-HE-Meta: U2FsdGVkX1/1otMJcawDt3HZjBxFvw0EcN3Nv/LkvWlYYchQh688tLErw1cq25A/1uQyQKB1sl/5pkxa97P5pJzNrz2htMYPEXR6MnXGNixVPQslzIHg1dtq3Gp0DV/MrIUdcKS21evkAzx89OJ5cBhbvtE5eQIsu9md0gbUp9PpsR2IHOi5mn6ct2LAYFT/N4RlApB7sUBy457EQecdTt+BvYciKe6r4l7tmstzfPU6zX2jjY+hpK6jzUZ9E6LEEXzJqTtOTWFdy9ePvk/IyfrGD5tWa6RizBiCtp3UefKTqgwa5Rme602HY6Tpwf8bd0DQEytM9qOFORwpBed3s1dkE7SxM4QRKk3lXDFkELxXDNK5blZrdsmA7+/tyn5nVLcYUsAI1LgljZ35tQF9YKGCdBItS8Fk3864fy0tp+DQNjquYLZcJTmQ40w0MZPMDk+tAAg0CV3yl5lb0rs5FsSUzu/xr3Y/E74YviqqHa6abUzzFjL66PWr1AnitcnLCCcwzbpuZrjg2zXkKkD7XEDxc/iKnm4tYn6Qjxl4kZMNqko3JCsxNU7gbHQh8eNDlwGvsP+ipqHyIDtnDpFRSXSFCpC008pYxtwzWiYUxqVFik0xEVqQTYD7/H2hn96GTt4oPdWCuZHu2BoN4BMQehc32qaBd7wsitz69/TaZHI+T5L56ADEmHcwFmr20aatK/qXkxYoK9NyV1wYuwjrLiXYA2UWyqe0kYnlWwFNbGHZHSrz7o1neSJNmsAD5hzQWV15kR1XNZZVJ0i8zKd+W3+psb1WzBMGgUXvlAex3BWiL7cnkM4wDTlAKMwkEG7bq0F+652NhakCxSeZck//vAC8VM4uw7biZmwwYhzB28UV16jQCA8VuJp6Fame7EuHGJiSBHd522LNfSGW13DffaHDhwyaofldgrqZykoRlcJkWADtlmdFHYCn22A83X4v9GNA9s186N2sYYFI+HQ
 BjB1XPkZ
 IE+nbpyckp/o59wg1quI5tuKLIAQ9BaDZA8qyDuHjXJRzUaiqUh83X9sLnkDBQkOFxLgdUfc6sMEvlU8ruQ3hB+ZDFlu2OeCC2V6+TG7ELzRt4kC7+qNSXd81US8zwByc5SPtC8/z/CcllM1NKOlXCpzLYYnYflH5RPr5nRToTWZ3zuBC52czjo47x1PXxwHqqUWVJGBiaDf91JcHxpxfDTgNenefCt360q9pOQH7kfNBN8OFMO/tqQ3GfJg/ry/7JIdBy/42kxHeWvottyW++4QJYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 12/08/2025 14:23, Maciej Wieczor-Retman wrote:
> [...]
>
> Make part of that hook - which decides whether to die or recover from a
> tag mismatch - arch independent to avoid duplicating a long comment on
> both x86 and arm64 architectures.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> [...]
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index f528b6041f6a..b9bdabc14ad1 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -1068,22 +1068,7 @@ int kasan_brk_handler(struct pt_regs *regs, unsigned long esr)
>   
>   	kasan_report(addr, size, write, pc);
>   
> -	/*
> -	 * The instrumentation allows to control whether we can proceed after
> -	 * a crash was detected. This is done by passing the -recover flag to
> -	 * the compiler. Disabling recovery allows to generate more compact
> -	 * code.
> -	 *
> -	 * Unfortunately disabling recovery doesn't work for the kernel right
> -	 * now. KASAN reporting is disabled in some contexts (for example when
> -	 * the allocator accesses slab object metadata; this is controlled by
> -	 * current->kasan_depth). All these accesses are detected by the tool,
> -	 * even though the reports for them are not printed.
> -	 *
> -	 * This is something that might be fixed at some point in the future.
> -	 */
> -	if (!recover)
> -		die("Oops - KASAN", regs, esr);
> +	kasan_inline_recover(recover, "Oops - KASAN", regs, esr);
It seems that `die` is missing as the last argument, otherwise
CONFIG_KASAN_SW_TAGS will not build on arm64.
With the fix, it builds fully without further issues.

Thanks,
Ada

