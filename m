Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72246C88E7D
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 16:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2D36B0092; Tue, 15 Sep 2026 12:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A4816B0093; Tue, 15 Sep 2026 12:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9556B0095; Tue, 15 Sep 2026 12:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 193B06B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 12:34:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8652DA04BB
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:34:53 +0000 (UTC)
X-FDA: 85216545666.23.35E4DBD
Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2A55D1C0008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:34:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vmoHqFJ8;
	spf=pass (imf20.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789490091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aO69uljBBfoMgGRXncDrHuXECY1i4hzCknJjmm8zYHU=;
	b=EIppy5MEJbAz21BYF/FPn6AoJuHNg3bGVtqgz8jOu+gV3hbXNJytQTaRzWY6mu6vzDtqb7
	ofKzNwlMqx32NDw/jgasYWSpCqt86sLJTJSgIgQsJfOe9BmW8/v2vztU/I/DCdkx6b2mFL
	PCWr5h945jAkLIPyy1LYAoyyTaSTsuE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vmoHqFJ8;
	spf=pass (imf20.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789490091;
	b=Q5zv3CTvQooKLus1nWX/LaqX4I/y5SpGWFR334oleUM0C+S16FeB0zUBx2efLjNbeetgRQ
	gsUgKPeJdytKoHbssOUVII6Pyh7jxDnxazCBe4DTOOZ5HExEdQ23RT+GUrNDf6Eymv2KKd
	WHhpgCYXvpL/WEtEzZFbZicCN3n/WfE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=B0tzIgaG6JGKZCjr1ffoCRr52KAPNSy6oO2D1sP8PJ0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789490089; v=1; x=1790094889;
 b=vmoHqFJ8p3xZuDW5RmkgyPLujGc8Ppw5O4CFq2EyiGgqNj9AjYpl7l1YBoZt5WYhxSKVZ8FT
 sTeSUP7jLzLni0+PjMsc6Jy0t1DXJgKxSWRGOsbBgxCerj2but0ZZ5V/TmoilC4xDffEjjT++dv
 R4F3dni6CeYMnuQLOMkcSt+8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 456883709b6d14ba;
	Tue, 15 Sep 2026 16:34:49 +0000
X-Mizu-Trace-ID: 456883709b6d14ba
X-Migadu-Flow: FLOW_OUT
Message-ID: <a6f41d17-62f0-4ba6-a8f0-bc18866d2784@linux.dev>
Date: Tue, 15 Sep 2026 09:34:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] x86/cpu: Initialize boot CPU cpuinfo defaults
 early
To: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar
 <mingo@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, "H . Peter Anvin"
 <hpa@zytor.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org, bpf@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, kernel-team@meta.com
References: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
 <20260814235134.3461435-3-ihor.solodrai@linux.dev>
 <20260915023115.GFaqit8zcWHGkAdHD5@fat_crate.local>
Content-Language: en-US
From: Ihor Solodrai <ihor.solodrai@linux.dev>
In-Reply-To: <20260915023115.GFaqit8zcWHGkAdHD5@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2A55D1C0008
X-Stat-Signature: sccceeemodxy7d1dfcos3gnbf98gwios
X-Rspam-User: 
X-HE-Tag: 1789490090-976557
X-HE-Meta: U2FsdGVkX19bWlQ/zsXlwdh0OvKtq+Dw9rgQ4d0VNkp2NXdzMutA/Jf+c2wraVikCGEEEiTT312XpiV7MfYfjScTJGFcM7jMm0QiX41f8wDdf+vieQDykJqb1BGo/nLJP0GAM8CdSsJHnAnPKcNhcbEPUInt4YP06r5jwV0kIDghapjNf7nj1QYZqO6s9UdVMnRxEpCbGyRsLrm6ej8dJnM7ZdcMgT0sTYcE9jzJ5FIYzjE5tVqWjVrI3PYWxY94fnUSQhuOFi5Dr1a7Aou3tp6sriOzyF/LXwSya43gHJFNtClognBfJQsSFq8RFkfs2zZc4nYmzhO/FY7KuJYYXj8IYYoFwD0OPdJu80N+ge6IQgWz4ey76bHJqjd3r7urV4S8b2q15GTSZ+dVxtSXPDQQMGZ8cEzHXdnmTUjf37lyYatnL6K5x8uW+dtDiJlS1qM6SlQoChygSVaFQURmZKRCT0G7SXuvIOvpLV/sXKbfOLsJGvHuHZqlwXCKJBAOb8q4fBYip9QGtMMFFCVuBseh4YFHyjaq7ctfQLlo/AZVy+rw4PX1I0TNblLP2dxndSJVKPlQULVW2fxmHO9CSNf0yh4qBQDZlEkwDRBc20ua3SXn2D7R2p2Me8v/+WxY2W1iIcFrlgUHayTuaNoABvHFWyrCRuqeOyODgV7vpem377bzwNFrE7ExSJruT8shm01YqSZYEMZ1xnYLf0eFudEIapRc89vJWH8W2sqroqWzw+5DTRil3Xd/c7hPXY4wVPeqEasE4Bk/JE/LvErF+KcCfLx1dfr43xnjLQLGqCzVnyans8A746tw7tyrxCZRqPkS1aw/fLA7tKS7OPC+zl5FyMoxvW2SJ4Zb45Qt+Epk57e8/4ZhNlFgUc6VGkX5fhKecAoDKJJVzzIpguKDJK8YHDlAV1wGGdYylqZxoaYHhKbAba4WFJ74qq4Dcf8d2CDBOwO3s5dAXH4g4Qh
 Q3PiT7id
 z0vcj/236scLUMAXZV9IGmV1+xTc8JVZ/gVV3u4o034sspWDEXHwzfu1sksmPFUL0ID7wP4OzeOCcrg4JUD3w60q/IYPDsCQp5GWVDKUA2k8wgXzEydmz8gXZJPL2kFDWiu4hzG4Z3AMSFgtwOdqJJfpcdlOAl+/d0nseErzS5udEZx5uITwwZ9OVcc0gqmNYL5DavCUxOcHTBhgQijKBs8Z8VxNlIUeqmPwLJxNhBJduCqTz0nW+uMlJSpv8ZQDHpO3Yl65hQiw8xjyB5TmG5Id/jzBb29P8IFyAt+FJ4goT1BSyvojdzUDkaKes9vsyT4negIQv1XFgRGCqtjwsgQU1BkULsn9blbXF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 7:31 PM, Borislav Petkov wrote:
> On Fri, Aug 14, 2026 at 04:51:31PM -0700, Ihor Solodrai wrote:
>> early_identify_cpu() clears the capability array, the CPUID table and
>> extended_cpuid_level, but the architectural defaults for the rest of
>> struct cpuinfo_x86 are set only later, in identify_cpu().
> 
> And I would've stopped here. I don't think we care too much about a CPU which
> doesn't enumerate CLFLUSH. Or is there an aspect I am missing.
> 
> I mean, you can say something along the lines that now things like
> ->x86_cache_alignment are more correct but I don't think you need to go that
> much into detail.

Ok. I don't think you're missing anything.

Should I respin with fixed up messages?


> 
>> [...]
> 


