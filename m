Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 885C0F3C992
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1BF6B0089; Tue, 24 Feb 2026 10:04:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62F56B008A; Tue, 24 Feb 2026 10:04:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65096B008C; Tue, 24 Feb 2026 10:04:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED1A6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:04:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C4AEC0BA8
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:04:18 +0000 (UTC)
X-FDA: 84479670996.16.303E6D7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F7A74001C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:04:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="EFKkjQU/";
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771945456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YGCn0wuimJh7qA5Slw0RYrtFU95xbVHX8rxHtCGa/Eg=;
	b=tVpjv0izAHx+drc4+oKheor/5hu9dNVss5YbZTp8RszMYUXD9Z1Gy1hr0LCZrDH0gd01cP
	ezv/R7/CnkWnzsJaMa7kl7D8cZ/skgR7O3aseCG7//0S7AZHEopRkPLvjDScQDvdY9GkA8
	xC83V2+WIxr08K7jAg0U1H4Jqlpnr60=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="EFKkjQU/";
	spf=pass (imf12.hostedemail.com: domain of dave.hansen@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771945456; a=rsa-sha256;
	cv=none;
	b=DvmXKszRzhyMEbeCw1mVJZWnDQeQjOnd0PfRnvB5v/pinzyA3b0UfdEfgQDzmSefzdS690
	/Yj0xT7vXF5AKWE96FbXQVaIxbs2OsRbP5ekYP+qxc2Yv6Ds13dBVX8JPZD/AaUL1rwPJ0
	DBXdKIbKpX5FF5qV8s2FywsS4Uag4LY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771945454; x=1803481454;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=z/jf03sDuM+aLmtAS2IPqspByq2IXQxOxu8sCxuWR2U=;
  b=EFKkjQU/TV+XjBxsfJOYqahOCtP2EInYOP5PPvh60z7F4LokNXLUFJqO
   rXB2ykHMKMC1V2bdssS4rITRdKRV9K1Tcq9tDoQAvPqAyUK19HP/KEqp2
   aggn+dbu3rA8athzS7sNYnWRHs1Yz2C1CNdDqPuj32hSvsvNjBoWiruEv
   tQF7vjFQAKKQtp9M4PtDfepdDu3tmRfkJH5kHWfBzQn4KB5tSBLameWfF
   Zugr1s5KsSjKwsPNYgEuiPNHoiMO8Nm5ySOCYxG82x7pk+/J+ZKEzOMNR
   WNdfoRUE2Pe9QmXbu8c+BSq668prYKrog4CQGmU/PSMZ6TEkNavJf/9PF
   w==;
X-CSE-ConnectionGUID: +yofWxBHQRyJDGPGbwYyPQ==
X-CSE-MsgGUID: wzau2yDiTcOjeJAY8ApGfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="72865529"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="72865529"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 07:04:11 -0800
X-CSE-ConnectionGUID: dRHuQAc+RVCWEUEFFqIq3w==
X-CSE-MsgGUID: XmJNjA2GSgeSBLo9G/u1dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="213159563"
Received: from gabaabhi-mobl2.amr.corp.intel.com (HELO [10.125.110.247]) ([10.125.110.247])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 07:04:10 -0800
Message-ID: <95c65dab-8a48-4449-aa96-3928f035b07b@intel.com>
Date: Tue, 24 Feb 2026 07:04:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
To: Peter Zijlstra <peterz@infradead.org>, Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260224030700.35857-1-lance.yang@linux.dev>
 <20260224114152.GX1395266@noisy.programming.kicks-ass.net>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20260224114152.GX1395266@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3F7A74001C
X-Stat-Signature: jzinn71eu69918dfwudm96fsjgapx1xg
X-HE-Tag: 1771945452-166545
X-HE-Meta: U2FsdGVkX1/kSbhprRTxYgb7/5vRiYSCyJRpesYZ8uuSB399WtJlL3YMspxcV7TSIzTRtZd6so0OcupB9a4cu7Lro7EoWFiveVelUrBEAy2DQUIfamwi2pwJjxoPfgriTM3T7oibNyegI1S7woZkQNoT8lcD7VjfXjC+VbbuyIqL3wurMftPl9Fr98vs/kd3yBLyThSmKBq1iCeZVGck6shzFE4cLsTIET971WHKkoY4lI0lBM+f2LZzq6SeAOpcEmZpbUm+WkHVjPFjV/HjKilC4GZ9HdsB5m53J1nh/MSddX1KJuioSUkzZ9SgylTi+hqVibCR104jvlldSB+SDOhKdNVh0ZmHO8XiXcCwcfAGqns2dmHK5GG3SoyYhOn/nhVzYGXA6VD0knFIUzAEsjUEpu7bJ0NMaK9ToEnZMt8rWymP65Mg41y9CkKaylNZVPRYNDUrF0KLin9QIOsAXYmbBI1A0mZJcHRhWJn25DBMOZwIBA2hnHz626SarsUgcpi9y8W881P8awj8Raee5oksGjjoURDxWy7z+80iGt+SfkrDRRCUqgDckCsF71j3MlWcA3eIaQN9NV5NJ0Gqh9xbI6tSI1z+A2ifmCWlBNa36iwwID2VmzlX5wfVQHzyJxmstUBtw8+9jltL3BvWyBkiLY6a8NFqOl/YBdPx+783ZC8/N/gy9aod28vL0km+X3nGwANpnkW75K09ljhZNjFfebCFaCkjqdUpEM3b5e+X2vmz/Cwr40UuB+rGC2HIU1MXNJtB92I28nYjAH4vsOcoxFSR36mssdiIpmQOmhRanJijS/rZpH8U3PsuwpUTyZUfSs2yl2xQ32OAVy9osgc3M3NK05WHOXl5M74UxwtKFrat8szG65x9KoNxg0T1lw63lXoGa5xl2OpO5NV9lb5rS0BV5w2YqwmBU8RlJ5G+oOx9D+GH/XTirNxcw79XCRHITrlWLMpLdF9lGj9
 NaWovrR0
 6H+m8mMw941QhJ5qVi9wqghkLe9iAdvCi/52vH1J6uaQYQj3qYUm6Fy8vrg9HziZo/5cEyMotfGAaoj4zacCYxxIGr8MsLejyYO8t0QKpNvFwxzBlOSMtAc/FTGLMRFcVnEhOTEF4l15cPQsYgurwFT4iEsCExSGMwyaXGT72BNSnw6EZybgFrJzOKcSgK/jRyoohPgR1B5RUOz5trmEBXT/cXMRORkBtIjTMlKUAQmG96Pmy/proU3dSqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 03:41, Peter Zijlstra wrote:
>> +void tlb_remove_table_sync_rcu(void)
>> +{
>> +	might_sleep();
>> +	synchronize_rcu();
> synchronize_rcu() should end up in a might_sleep() at some point if it
> blocks (which it typically will).

FWIW, I do prefer the explicit might_sleep() rather than leaving it to
just the documentation. It just makes it easier to find bugs. I'm sure
there's some crazy RCU variant that doesn't often sleep in
synchronize_rcu(). ;)

If it's worth adding a line of comment, it's worth adding a line of code
to actually keep folks honest. This is also going to be a pretty darn
slow path so it shouldn't bloat anything too much.

