Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE5BCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA448E0005; Wed, 10 Sep 2025 22:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B25C8E0001; Wed, 10 Sep 2025 22:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF228E0005; Wed, 10 Sep 2025 22:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 310358E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:39:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF687588EA
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:39:07 +0000 (UTC)
X-FDA: 83875412334.03.DCE07E7
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id D5AB440007
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:39:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HwUiZZ57;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757558346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e9PPyv7+boNGUzzOupoHa1DOIH/TVj7FBAqrgegDDTk=;
	b=6sgugWnS8eCWcrcMlXH8ej4l65nHvo7MhfSrWqfyJGpjKX28itlfto91PjDpJ/2qFAO2F6
	WznoY6BeCQGZm6juFtNxTogLTNtkKkr3BhhBmEz7eFG6G5c8xI2pV4ZgQKds3NOrGmrxia
	x9ABkPxsLeC+mwvdXTBAxU8BTYALzkE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HwUiZZ57;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757558346; a=rsa-sha256;
	cv=none;
	b=bKEm4SKBtIXjoNYuGONB1KRbFTTb1+qRHLBUSlHAMSvpm67x0ZdLMhS7UJZLzyYgCqHwUe
	X5mrxv059b4pe/rjO0Im00z+jH6KRYQpRxEjTaadvyz89lSAxBUBWpHR5uMLQkfhIBFpuN
	G767nYJIOQhNxidWMpGlJUPtKXyMwpY=
Message-ID: <da274606-1064-45cd-9ebf-ec906e9d9f74@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757558343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e9PPyv7+boNGUzzOupoHa1DOIH/TVj7FBAqrgegDDTk=;
	b=HwUiZZ57ysrOi/yC8M8PEPM+a14G6LPukDNNBb/FpNvZAeOa4OnZOQRwi++L8v57aklnVP
	1mK7E+u3sr8fTszO/Jkkv2bbrq7uWUD/4vaAgRN9UoY5++oQACtNvOK6McSq5DscH6HyfU
	O4287UNc+udxnHUrbXtrALhrZNFyB6I=
Date: Thu, 11 Sep 2025 10:38:45 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from
 khugepaged_mm_slot
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, Lance Yang <ioworker0@gmail.com>,
 akpm@linux-foundation.org, gutierrez.asier@huawei-partners.com,
 rientjes@google.com, andrii@kernel.org, david@redhat.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ameryhung@gmail.com,
 ryan.roberts@arm.com, lorenzo.stoakes@oracle.com, usamaarif642@gmail.com,
 willy@infradead.org, corbet@lwn.net, npache@redhat.com, dev.jain@arm.com,
 21cnbao@gmail.com, shakeel.butt@linux.dev, ast@kernel.org,
 daniel@iogearbox.net, hannes@cmpxchg.org, kernel test robot <lkp@intel.com>
References: <20250910024447.64788-2-laoar.shao@gmail.com>
 <202509110109.PSgSHb31-lkp@intel.com>
 <49b70945-7483-4af1-95ba-e128eb9f6d7e@linux.dev>
 <DF4CA2C0-25AF-462B-A6D2-888DB20E0DFA@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <DF4CA2C0-25AF-462B-A6D2-888DB20E0DFA@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D5AB440007
X-Rspamd-Server: rspam05
X-Stat-Signature: pzgphs76khnipxphfhcyn4yin3rixjc5
X-Rspam-User: 
X-HE-Tag: 1757558345-865327
X-HE-Meta: U2FsdGVkX1/f2kuQEIZea21k3OQVFuUW774/LetnCj4BPhFBvonrMXSHg4vTeFhu8uKBnQg6bd5ZuzSiHbHV1WzwLQ+uIlcOa39WheH3QPC/wqr4yYwHvG2yTZ9LERAcCaY0dyQpq81d/rgco/0Rzs/+0tmmMq3+0gIis+2SB15mk2J0arnfbEe1ULP5XKEKkB/kZxYoGZzdTod7QCoLxeME6c5S0mKFF1XT++0WftUOwnT0xQTudUV4mkSEOJIx0macRiL6pibgDHVCqPw2amPSuayXdKmItzmGnqXFQ4q23G1jVwqxmD0oVa3KSAgBIk9Ll8q1gJksyBXm3GI5+vy5xiW59JEkNkudzCroTHARHLjNmxduRk4JGFFVDWO1FKp8DkMz2fLKQD5XmoxcYUj1Z+gG8o+W032wlUF4HuBvpmvlNLDAibU8xpu+dp7pi4sarmfU6jle2UodxsOT2xWOhshglYxAkPLeKxBo69H5V/ARbWqS/O6FyJfEA6t0zH/2S4Gjtc1hchUw6diHZ0pySKQWbB9UFNsfCwqAvnOYmYOUx2P3z+3PETOrt65b+k7B9w5pvyWC1j7sGzBddGeLew2jcpkuZcFpT+U0hWL6EvsMScujseGAq6wvGCYZWXm+/hRm0M+sz9iLzbggvDHw/3QqqKx4NykFcBk7n0cdWrTjMA4+MyAauF0Z2+oFfKzFB9Zb5P2o3OZc/cdRaioHmtFzzoynSq9aU/ycn+wJB7z9SJxsBjrD3hCEn5ADsALeO+K1tQT9DMU8GDhRTNo6iViGoTg7FkVO1up1eAM+HBsPffnfK5csyKuQMCNo1x5AP2MX/W+QDr7zyv/5NXsyPSFVrsM62hw3a8KyC2mTMt8e75leudCqNEX8YqnEX4Um8qlC1qYSD0xwmmtGTlOKNMQpuddmBKtVpCEhiPlKYfy37RIKqor5y7m1ppdkzDH0W3yysKNlcbf50p4
 pV0Pw+In
 gwq82BQsa5d7cEK7EKBuDOn5BDY//6J+6Yz2fg4cPY1q0R4mc2Ai6NvvrYITLwTMFyFw8sDKrpAemTLIIavsp6fZ2cRgW65HANDzuLyLeoPEBFLlqFDU09lEhfd3KPLOh9efyFu/xghHIiN6USJGyBSZkQryn2CcVzIsdluskh5C9gejBheGIl5ymKqlAAtt6QujPPBgRRUCxGJh78ryufaOxQQ47TJw4KpjLo4/01N0bhgSuNVwYVOzt122v5bOfr//8zXzPf7SNUQT6gUf/2V9b8xi5fE0pI+4WXT5h4O535wFVfu1ChakHZFZSGnwT8zknotVMMeoGjC+AXiOdCthK6bBSLVUt25UQEduhpji1efpZvGLohXQQDs7wb/pqP5id+xLbsbhkHF/lNuGJ5xPwhKtyQ9VsfIaHnpPqof0Gc0QTIr/aB00FHNZxZ1JNcqE9c05KUlm/Yth31RtxXHn4bKM3QFRH0PQY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/11 10:28, Zi Yan wrote:
> On 10 Sep 2025, at 22:12, Lance Yang wrote:
> 
>> Hi Yafang,
>>
>> On 2025/9/11 01:27, kernel test robot wrote:
>>> Hi Yafang,
>>>
>>> kernel test robot noticed the following build errors:
>>>
>>> [auto build test ERROR on akpm-mm/mm-everything]
>>>
>>> url:    https://github.com/intel-lab-lkp/linux/commits/Yafang-Shao/mm-thp-remove-disabled-task-from-khugepaged_mm_slot/20250910-144850
>>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
>>> patch link:    https://lore.kernel.org/r/20250910024447.64788-2-laoar.shao%40gmail.com
>>> patch subject: [PATCH v7 mm-new 01/10] mm: thp: remove disabled task from khugepaged_mm_slot
>>> config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20250911/202509110109.PSgSHb31-lkp@intel.com/config)
>>> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
>>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250911/202509110109.PSgSHb31-lkp@intel.com/reproduce)
>>>
>>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>>> the same patch/commit), kindly add following tags
>>> | Reported-by: kernel test robot <lkp@intel.com>
>>> | Closes: https://lore.kernel.org/oe-kbuild-all/202509110109.PSgSHb31-lkp@intel.com/
>>>
>>> All errors (new ones prefixed by >>):
>>>
>>>>> kernel/sys.c:2500:6: error: call to undeclared function 'hugepage_pmd_enabled'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>>>       2500 |             hugepage_pmd_enabled())
>>>            |             ^
>>>>> kernel/sys.c:2501:3: error: call to undeclared function '__khugepaged_enter'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>>>       2501 |                 __khugepaged_enter(mm);
>>>            |                 ^
>>>      2 errors generated.
>>
>> Oops, seems like hugepage_pmd_enabled() and __khugepaged_enter() are only
>> available when CONFIG_TRANSPARENT_HUGEPAGE is enabled ;)
>>
>>>
>>>
>>> vim +/hugepage_pmd_enabled +2500 kernel/sys.c
>>>
>>>     2471	
>>>     2472	static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
>>>     2473					 unsigned long arg4, unsigned long arg5)
>>>     2474	{
>>>     2475		struct mm_struct *mm = current->mm;
>>>     2476	
>>>     2477		if (arg4 || arg5)
>>>     2478			return -EINVAL;
>>>     2479	
>>>     2480		/* Flags are only allowed when disabling. */
>>>     2481		if ((!thp_disable && flags) || (flags & ~PR_THP_DISABLE_EXCEPT_ADVISED))
>>>     2482			return -EINVAL;
>>>     2483		if (mmap_write_lock_killable(current->mm))
>>>     2484			return -EINTR;
>>>     2485		if (thp_disable) {
>>>     2486			if (flags & PR_THP_DISABLE_EXCEPT_ADVISED) {
>>>     2487				mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
>>>     2488				mm_flags_set(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>>>     2489			} else {
>>>     2490				mm_flags_set(MMF_DISABLE_THP_COMPLETELY, mm);
>>>     2491				mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>>>     2492			}
>>>     2493		} else {
>>>     2494			mm_flags_clear(MMF_DISABLE_THP_COMPLETELY, mm);
>>>     2495			mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>>>     2496		}
>>>     2497	
>>>     2498		if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
>>>     2499		    !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
>>>> 2500		    hugepage_pmd_enabled())
>>>> 2501			__khugepaged_enter(mm);
>>>     2502		mmap_write_unlock(current->mm);
>>>     2503		return 0;
>>>     2504	}
>>>     2505	
>>
>> So, let's wrap the new logic in an #ifdef CONFIG_TRANSPARENT_HUGEPAGE block.
>>
>> diff --git a/kernel/sys.c b/kernel/sys.c
>> index a1c1e8007f2d..c8600e017933 100644
>> --- a/kernel/sys.c
>> +++ b/kernel/sys.c
>> @@ -2495,10 +2495,13 @@ static int prctl_set_thp_disable(bool thp_disable, unsigned long flags,
>>                  mm_flags_clear(MMF_DISABLE_THP_EXCEPT_ADVISED, mm);
>>          }
>>
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>          if (!mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) &&
>>              !mm_flags_test(MMF_VM_HUGEPAGE, mm) &&
>>              hugepage_pmd_enabled())
>>                  __khugepaged_enter(mm);
>> +#endif
>> +
>>          mmap_write_unlock(current->mm);
>>          return 0;
>>   }
> 
> Or in the header file,
> 
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> ...
> #else
> bool hugepage_pmd_enabled()
> {
> 	return false;
> }
> 
> int __khugepaged_enter(struct mm_struct *mm)
> {
> 	return 0;
> }
> #endif

Nice. That's a much better approach.

