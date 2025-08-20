Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CDDCA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E1C8E001B; Tue, 19 Aug 2025 21:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 855EC8E0011; Tue, 19 Aug 2025 21:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792AB8E001B; Tue, 19 Aug 2025 21:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 699BC8E0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:56:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37B221402BF
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:56:13 +0000 (UTC)
X-FDA: 83795470626.12.F815914
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 536DD14000A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:56:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kwbjZqVD;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755654971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+sb60WMq9s+elk6LLcRRaUDEvLIfQYZTGy2RixZQEM=;
	b=a6ahVDBElla49vDLiADMFJ9uhCB6KI8N/fbatb+ZEgLPE92iSHSLFhL4cIKDQBo8W39yL+
	lQjL8orj7PFTMmV0H3l1rHolW4N6MNyCwNYS2G14LADxuWtVYrAO8NEr5fQcAfcuRNMhMb
	H+ucMVrJKegsuc5efp+wby9+croGTKI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kwbjZqVD;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755654971; a=rsa-sha256;
	cv=none;
	b=yjZhjHwMbsYBf7scbt31gxfrO/xj9m1QvHfgTHE4GWJOiVUu3TRU6enkCVR2iw/uL+k9px
	NjbEj2OFZzsJ1mR1kExZz/HmusOHZdxdGMr1Jj+K/Y7e//jcn5ksgxvdj7RFfjXQX9+w9p
	cZGvviqCjTTZeqszQtvAPmiBF1gGd64=
Message-ID: <33a897b4-7d9a-4641-9c7a-07c19bb9cb6f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755654969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T+sb60WMq9s+elk6LLcRRaUDEvLIfQYZTGy2RixZQEM=;
	b=kwbjZqVDNzhxhfdfPer2yb389B+y86OOTxcjkR3Z5WdIxZK5hxajSVjDJ6DOZKC+gG1Vaw
	74SgsC1UPpikSliYOCg9ZZBnKIM984GAx1V4aMf1ks2uDUlsh0gjdgLwbSGJFjILDvSgN9
	p52u73u9TPzDj9GN5/1Td8o5eilfKMc=
Date: Wed, 20 Aug 2025 09:56:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] panic: Clean up message about deprecated 'panic_print'
 parameter
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: kernel test robot <lkp@intel.com>, Petr Mladek <pmladek@suse.com>,
 Feng Tang <feng.tang@linux.alibaba.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Steven Rostedt <rostedt@goodmis.org>, Jonathan Corbet <corbet@lwn.net>,
 linux-kernel@vger.kernel.org, paulmck@kernel.org, john.ogness@linutronix.de
References: <aKRJKZHgcxyNF3y7@pathway.suse.cz>
 <202508200907.PsZ3geub-lkp@intel.com>
 <ae9bb2ea-c6e5-4a4b-ae25-aea1d6fe084d@linux.dev>
In-Reply-To: <ae9bb2ea-c6e5-4a4b-ae25-aea1d6fe084d@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 536DD14000A
X-Stat-Signature: wpnnsmwu78poqudhcdbndsdcmkusabax
X-Rspam-User: 
X-HE-Tag: 1755654971-420591
X-HE-Meta: U2FsdGVkX19GDwm5KpjYmnXHlzy/q0ye5yTYorNyHJZvahGvNnwxmD1S/g9MeAUJZUYu9Z4yCowr1rpZdbb3XEL3vkVAZ050alH3DpFbCGusAtFfVO0PNdLzEccWWx2OmE69I3gprdiYVJ8sn00DC0v2SNaeXJ1hOnVoqoEFYcCR5TtBzL9ixsIPanLyBDWoy1ernxrqFL+mMDcb0XDMpznYt+GA3aGWD1xVi35KPRAeV3POxEuEAbzVexrKsrTOAw/Bfce0ViWUG/xgIzptd4gF7Ly+aGJDmrmv9MLwHjpt28aOLT7X3Ftoryd9V7UU/i2au1gTmVNohUZdW7dOWL6NakVjtjAa0A+ojtvM4zPmwrS4ru31zHhuQT/kt1GbWpwSR2VaiRdhrXY91iXMWjYOVj+K1MPICLwwMXpN8UcPU9mdQ7TssSaXJnFrsrwg0ZGMG/PKc1UI4l9Umtrls2Jp16mMjVX5uu8ggorLsmLf/w3u18NtguNvvSoE0L6P4Y7mYgpKflgaFxSiu80/yRlns7PgXLh0H/fU1IsdYbeuH6qlefosj4v8ARfzBdPdpyW9GcY85KKNt+sjlhan8j/Er76fikGcZ4BW+4NpW4z1s9XTyaCZcA7IFvpV8PEgWj0R3/yEk+2KCWOiHY4dJ1JCDD24VRhTRdblzcri0Ewhlic+89XfaIS0aMx5o4B5lPjQG/ypGrhM8JI0+uoDKmvj/k/0JieJpXDAkInx9hxVzAQcnWvkq/WLQArm7BxN6jEtNxCqnesCNwpDN91/2uoV4VKfo6a9iOTsBexB/9orxzUmMXA3F3Ikf3Ocnc8Z7oHZWSitZfA7I6Jahrnc6WOgl4Sd7u/XyQwadsvCde18lctOTxer3NxxrxKONYo5Bn9cYD+mdIoy1GMqY5A40ViwmWTO+ujrX21hmoylh4OusIz6QIudx0vwkX58YUUply2zicoIVU+fzTam3rM
 VuRuHYJo
 4t4QUb0DvIdZdo0p+Apo7ny+kFzFMFIPD2DoTDbQYhty4YeEUf3OcuyfRB19Vci77tuWfqyr2wocjgVGlZG+C6Pw4x5MBv+wihR48LN4Os8lQUr8KlnRuckn+ld5kcxe9n8kkOxrKeryWNLmfjdN3Nw0ZCtU88Yb3PmUi/sNQLcwg/xKR5Cab409CECTd0UWUcR6KoTbyb6DbR4BOKqMan9Wv8yuYNj8Fgdf9/hRwU0q78NIAFnlpFmGWTYufKjKO69K+lSJvWx6IuZn5kT2Gv/etwLKtuPJR37Y3AGrOCn2BwfonNvQr1scybFGnhl62aCOx+eq499MDDp8EqCNO2WRa3d0L7MVT/fzo+IGvj2nXraA04EB6nr+kMYaHwWU1Lyn2EY6pycxTr+TvqilI5FpTelBaQvXm17InWfXEXMgtkcrgtgkkouMDAMx7uUaiGRwu1nAZvqczZ65GA/lX08lzer2H8Q/V6qR9KWKMdQxZ6kZp5jIORaUCgG1kT15SAYbmFjItO//5XwaK/J+7HUCdPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/20 09:54, Lance Yang wrote:
> 
> 
> On 2025/8/20 09:31, kernel test robot wrote:
>> Hi Petr,
>>
>> kernel test robot noticed the following build errors:
>>
>>
>>
>> url:    https://github.com/intel-lab-lkp/linux/commits/ 
>> UPDATE-20250819-180717/Feng-Tang/lib-sys_info-handle-sys_info_mask-0- 
>> case/20250815-152131
>> base:   the 3th patch of https://lore.kernel.org/ 
>> r/20250815071428.98041-4-feng.tang%40linux.alibaba.com
>> patch link:    https://lore.kernel.org/r/ 
>> aKRJKZHgcxyNF3y7%40pathway.suse.cz
>> patch subject: [PATCH] panic: Clean up message about deprecated 
>> 'panic_print' parameter
>> config: i386-buildonly-randconfig-004-20250820 (https:// 
>> download.01.org/0day-ci/archive/20250820/202508200907.PsZ3geub- 
>> lkp@intel.com/config)
>> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 
>> 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/ 
>> archive/20250820/202508200907.PsZ3geub-lkp@intel.com/reproduce)
>>
>> If you fix the issue in a separate patch/commit (i.e. not just a new 
>> version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202508200907.PsZ3geub- 
>> lkp@intel.com/
>>
>> All errors (new ones prefixed by >>):
>>
>>>> kernel/panic.c:952:2: error: call to undeclared function 
>>>> 'panic_print_deprecated'; ISO C99 and later do not support implicit 
>>>> function declarations [-Wimplicit-function-declaration]
>>       952 |         panic_print_deprecated();
>>           |         ^
>>     kernel/panic.c:958:2: error: call to undeclared function 
>> 'panic_print_deprecated'; ISO C99 and later do not support implicit 
>> function declarations [-Wimplicit-function-declaration]
>>       958 |         panic_print_deprecated();
>>           |         ^
>>     2 errors generated.
> 
> 
> Oops, panic_print_deprecated() is defined within the #ifdef
> CONFIG_PROC_SYSCTL block, but it's also called from panic_print_set()

Correction:

CONFIG_SYSCTL block - sorry ;(

> and panic_print_get(), which are outside of that block.
> 
> So, we need to move the definition out of the block to a common
> scope where all its callers can see it. @Petr wdyt?
> 
> Thanks,
> Lance
> 
>>
>>
>> vim +/panic_print_deprecated +952 kernel/panic.c
>>
>>     949
>>     950    static int panic_print_set(const char *val, const struct 
>> kernel_param *kp)
>>     951    {
>>   > 952        panic_print_deprecated();
>>     953        return  param_set_ulong(val, kp);
>>     954    }
>>     955
>>
> 


