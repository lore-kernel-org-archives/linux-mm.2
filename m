Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 547DE606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=MWmswE93
Received: by kanga.kvack.org (Postfix)
	id 7D4006B00EF; Wed, 11 Nov 2026 05:26:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC346B05B0; Wed, 11 Nov 2026 05:26:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C29A6B05B7; Wed, 11 Nov 2026 05:26:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 529166B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:26:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD08012025E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:26:52 +0000 (UTC)
X-FDA: 85422459864.05.8ED8C8D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0787C80004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:26:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MWmswE93;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794392811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5V9jRlyh7Ihg0NTQ3+KjZaPOqstTGKiqiBozrCfwUxY=;
	b=x8W0DBEEj/3xom4MIOMtc8z6eieSEl/Woa2n6+uWEile1wlBRHTtIWP80B6z0YQa8p+Q94
	fKaYScVHws+lqtStFiZpoe29p43hnOBXj/OYDq5GK6lVlrjfgbZjCPKFOmtbRnC20zVu5m
	LVcunCuFMKQEZBQ2vzEvpBbRBnfLw1A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MWmswE93;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794392811;
	b=fsBgMCUiYPfW9xEcOcMMx8CHIVvmJt4dxzpqnNql8t4df3dI8xdkRVMPDQFbdz82k92QVJ
	C7HNgIZ9xwBkFsRE1XFvpuuiK9/7cimBN67gdhJ7tF5a6OOOo4iUnBd5rvufrZuMjRS2q/
	ad5wYXefRUdc3Nv4AUSUe3WONdx3KG0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EBED2F;
	Wed, 11 Nov 2026 02:26:47 -0800 (PST)
Received: from [10.57.63.24] (unknown [10.57.63.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9770F3F632;
	Wed, 11 Nov 2026 02:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794392810; bh=5p/zP+v+C50UsZoAhPNAyBGrgi2Vxw0z5RAhgrPcN0k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MWmswE93spZbG2V0obRVIKBymfeULcFqEbj2cVnHxFaY5kyeW/5QiG+uLZDVflVGi
	 2C77Gaqu/MzBzW/w8VmfSod584m9JMJoYwQ5iuh3UEd4+jjlIHFkwwezDCHM5pGV6p
	 M+ch4d/6NeEOTwtoO+eqNyC1tAY1uTMp8qcFSlgM=
Message-ID: <45b19233-741e-46c8-a6c1-28775c4d646d@arm.com>
Date: Wed, 11 Nov 2026 11:26:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 04/22] arm64: Implement asm/kpkeys.h using POE
To: Mark Brown <broonie@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Ard Biesheuvel <ardb+git@google.com>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org,
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-4-aa6c4d9603bc@arm.com>
 <07b55bf9-e116-4731-9f84-49cd1b55fa50@sirena.org.uk>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <07b55bf9-e116-4731-9f84-49cd1b55fa50@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tzaegng95ictkr7awtunsixz547kqfjq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0787C80004
X-HE-Tag: 1794392810-355725
X-HE-Meta: U2FsdGVkX1+FvIecQHqX3sg/zQNdGB8+ELnRyqCoyq/Lu5WEpegdTKWr1qoJk23nwy9Xmz8+Pyd7BgDtaVa+MWs0JFh7YejAPzTGzf820ZxevRAve138iVylaJFFWMTCCUHuE9gYJ5dn8O5eVla3wxwPJDizO9c8lJ5DekQWQrRo94XlAjH3pVhdG77HA4O+Am6ONnAI+K61JXJqYUgD55Tuyx8zRQfe+6uJPR2f+bDdJbUDpfXJlJAe4quZqTDCIIL6mQa5KvM8CF7x6O17S8+MmNWByY2sJiIKhiH05JI4k1hfRV9OIt5dtBXqz8yHVrGie0U2PrtI1aMA6ZCdKc3x7Cx6x0M5dzIDaGn9yf/e+W+oF53kuelTA48p3gEo+jAAzq0Ce3Q/YcihUfWbCPcFF82qWKOdshQicVh1LbWI3YsjgCX1k3CuTVqKz6MQzoohh62DDV2hTDD+VY8bvyH2dIEh/EanY/9450gCACUCAH0Ciaku++G35zaesCEYiQNnwu9KBH4xEhp4KFzBBYathWkEPrKkdY6WMW9l8hlEvATHcNz4oudDcHKz0wBH/o2YCNxfX3v3nJO2mPwyalSEuZ3ldNZB+tJW7gdT8GBzO5CAoi/wIeUyFgjtHm2Ih6xk3nN6ShQsFUs1Zzzy4i7SvTYPTJF0I8368NJEJm3WtWM8xnl0FrPnNq/+KOZ4L8aelUVwXzFWnMnULQZb6OFuA6A2agr9Xcrrno94SUxaDywehAsH17gO1oqkTzXINsMOwMGtZeHlSm1kWVCATNUDMkObZDnAaoEmm7dzn/qZd/ePQP3Nyf+ARo+Tm3uxkB8iVXhKdRwNkqHkACiosa7sigKzQMbBp5ZnHZuwZ4eWMv4/bjevPvpVt+dNzBlgqR5rMuqEc5HQIrosNRbg+h+qLQY/xGv5VefIUfdCv1Z40L1iPXhLsdpbA3/FBORy7Yv1OVfExwkcNBJNFXu
 TFGBua53
 pEhnwMfjtrsFAQBRaHzNUBpOh5QqxHhwVMFCP5DsztMr8rS/kGUbqxfyY45sPmmuTEhMRsIZ88+5YmGxzC6u76julGdNcptje/d0i+X/X5iJ7X60GkpdxsYJuEoLidk9ZWtQwXY6kPkqK5mKy177nJncXNm7xsKO/TMTbHMBwmzZKq30+eJMQ/SZtpvkdL9aimtBRyGAiEe0YrdWl4sshMsYkNH5TCsbgc/7ob1H+hcpRL2UhToBDU+g9yTEDJrnk12CIdwErUPfrjnXnW+BmZ8ZidFkJu6+5KwhDkIuK+0gF4UYDjsgcHBPZTb3+Jn9isoUFi5QS4y0J2iWQNRA6sIWfP+u/UgeSStFu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/11/2026 15:19, Mark Brown wrote:
> On Mon, Nov 09, 2026 at 03:58:29PM +0000, Kevin Brodsky wrote:
>
>> +#define POR_EL1_INIT	POR_ELx_PERM_PREP(0, POE_RWX)
>> +
>> +#ifndef __ASSEMBLY__
> Everything else in arch/arm64 was converted to __ASSEMBLER__.

Good catch, copy/pasted the wrong one when I first wrote this!

- Kevin

