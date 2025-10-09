Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95C00CCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 15:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF48F8E008C; Thu,  9 Oct 2025 11:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4A08E0008; Thu,  9 Oct 2025 11:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D93D98E008C; Thu,  9 Oct 2025 11:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C54C48E0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 11:35:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 508B11A0880
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:35:15 +0000 (UTC)
X-FDA: 83978974590.25.D1FC710
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 898E5C0014
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 15:35:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QqWq1/bD";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760024113; a=rsa-sha256;
	cv=none;
	b=GWj7c28YogKXr4UzibuP5kIUbUEy7lVu3rOGo3VvxzQRxmtlMXLTpYlfcSCK/ove7JJpIQ
	GKB+jrdy9cHqZPT2ZmUZwTLJ0CI0QLmIQJzZgRdMMqQnCQov0uLlQGUkXOh+6LZfA3D76H
	4gVtWNpPjGW3Cx/TYNzJ4qh2BCGZjts=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QqWq1/bD";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of yanjun.zhu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760024113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yFgQ+7gYZsvROerfNe0yh1z4oSCTjP80VqQTNRlYmQE=;
	b=VcGYxDFjESPiqgtT4jYlxev9eD9fSYYASsj5HA5+Y8+5A/P/VPZZgwWyIn/ZZrEMgEwp1b
	Y9+wZzTHsgERab1jz3JShnXv0X/wJNUtsdwXGD4AOxI5rR6PAfgh6Fvcq0yFDaxXapW3I4
	5emd6GY6H6P/I+rSEgrIPf7YH30VIhU=
Message-ID: <dc71808c-c6a4-434a-aee9-b97601814c92@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760024108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yFgQ+7gYZsvROerfNe0yh1z4oSCTjP80VqQTNRlYmQE=;
	b=QqWq1/bDCQ9wrcuY1e4iXNgAoOLqxLWvI/2t1eY4xJDbCp7+DH9xa/5TFEjwt5ubuVgWgJ
	MGhj34pZv8qeKmjQKwN2cQNbV1e4c2EUQfGpdEf9KG6vXuv1Bxy1j2IIAxxpkXwWURmbXD
	sXd3/hCh+JpQpcRffrQU8OvwFU18vsI=
Date: Thu, 9 Oct 2025 08:34:50 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v3 19/30] liveupdate: luo_sysfs: add sysfs state
 monitoring
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
 rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
 rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
 kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
 masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
 yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
 chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
 jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
 dan.j.williams@intel.com, david@redhat.com, joel.granados@kernel.org,
 rostedt@goodmis.org, anna.schumaker@oracle.com, song@kernel.org,
 zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org,
 cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com,
 Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
 aleksander.lobakin@intel.com, ira.weiny@intel.com,
 andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
 bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
 stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
 ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
 leonro@nvidia.com, witu@nvidia.com
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-20-pasha.tatashin@soleen.com>
 <a27f9f8f-dc03-441b-8aa7-7daeff6c82ae@linux.dev>
 <mafs0qzvcmje2.fsf@kernel.org>
 <CA+CK2bCx=kTVORq9dRE2h3Z4QQ-ggxanY2tDPRy13_ARhc+TqA@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <CA+CK2bCx=kTVORq9dRE2h3Z4QQ-ggxanY2tDPRy13_ARhc+TqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ofg5bwqbejrkemrght761dpaihyfectg
X-Rspamd-Queue-Id: 898E5C0014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760024113-387293
X-HE-Meta: U2FsdGVkX19KKz70/0KgfebpKBdb81SEXvwjpV+6IWxbnsnz3w5DFbWm0s/9dlbugrIfLbEF7S99jAXzBzrM5H5//HEdVB4hMX9UGaH0QOwl3/mLROArshwpQlt1qg3dz5SU9TJDIHAa+VE5pfrKypgCeZFPLd1JCh1xqUjPOeSgfAxOQ1d8kMjPFwhUJPCzVV6/68OfQoPR++GS9TDVE5aJXMS6XaoAyO/h6YwWpRouuQNuTDqI2N4/6o5HNeNrcU0tC/FT/VRHz6tY8I4PWB046n4hpbEas7l/jOE1mz5xi5hbjGR5QScBJbi5WKy/Pz7hLOdq/9dTTbPSXc5JB7G7EtUCq2J2rDszCFrfYKvlxiCuiznWj8xs1LI11WWhWYqwCwLt9jSIL5cok9SHOD6qix4r4ywiPcDGI0YUQzAPRPwNDuNw+PD9mB9SObjlawpi4Oxl3pI9yZnb5pQQ1FGdbGkXg80UkSx15w5fzg4cTJSjP9ZgDB3XqyWNERMqgbuvBP943fr+g0zdHiMirY+dUNuWYCnL1tF6GVz9wnQwax4ilVNVvia6wRCASV+dycUce32Li3FFoSnaoOv0HKJEymjm5A/HBqr/7XHi/MolF8fxBZ6bANqd8yqOnXYCSFFjxzSK1Ow1+SGR2pFk8LEQ86F4BxtuGtgAVFvDIDpmQmePatM7JJb8YwMQmTLnyxXJV0dlt1ZFdA3ebNZ/QLSo9to+RzmIdM158o3rrJeD7nMgTJeaB4OuIruUnP0pPx9324/xMVwcgDeshVXrBRvLLEgv03vmeOwSIsPO+NhN884077owI4D2LzzTJIkT7iL7M+fwbfVcfYHkUv8/Rir3YyfW+8Xy487b/ExufGEhSVNQlB+rhK1XgdJGsg49weOnh+z+vgJfcBbeAwKqRSSUoLfIAizeRpA7+fOG71GMmcoN6/8aO9kkjpmJyM7akF237r+OjMH8etFpSR2
 Bn1uYV+e
 BqyOX+xyB3BsHsVBKp3S7Yg8vr/Vj9VG/Lp9vmWmosN68ztASljqcI5VZTdRMDEzt4IVh21O6BTSxY+/iNHMqFgRKxFJsUZ/Xhc62wpnYBHE0+G2SwTGHUTtwJY0B29S07b/wm/V3d3Gje6GXuqTwl/xu3vRX7z0M01pK5h0UmIV/RQ/IuM4s3uTLjjsf+ks9lUglX2gPprS9Tzx/c2q/cZak/MuN617Z6xN0QcMuHKYLzkg7PeU9n5RDwsd+P9bg4d/vkz1vkmSXOPXgtzkaZGVe5MPzIY6SmxtFowwcSwhUI0+KZ9N7ZMminV/GYSenMdmIh5U5r8Aa+C1q8zgcmdOT8voZB+S6tTRV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/10/9 5:01, Pasha Tatashin 写道:
>>> Because the window of kernel live update is short, it is difficult to statistics
>>> how many times the kernel is live updated.
>>>
>>> Is it possible to add a variable to statistics the times that the kernel is live
>>> updated?
>> The kernel doesn't do the live update on its own. The process is driven
>> and sequenced by userspace. So if you want to keep statistics, you
>> should do it from your userspace (luod maybe?). I don't see any need for
>> this in the kernel.
>>
> One use case I can think of is including information in kdump or the
> backtrace warning/panic messages about how many times this machine has
> been live-updated. In the past, I've seen bugs (related to memory
> corruption) that occurred only after several kexecs, not on the first
> one. With live updates, especially while the code is being stabilized,
> I imagine we might have a similar situation. For that reason, it could
> be useful to have a count in the dmesg logs showing how many times
> this machine has been live-updated. While this information is also
> available in userspace, it would be simpler for kernel developers
> triaging these issues if everything were in one place.
I’m considering this issue from a system security perspective. After the 
kernel is automatically updated, user-space applications are usually 
unaware of the change. In one possible scenario, an attacker could 
replace the kernel with a compromised version, while user-space 
applications remain unaware of it — which poses a potential security risk.

To mitigate this, it would be useful to expose the number of kernel 
updates through a sysfs interface, so that we can detect whether the 
kernel has been updated and then collect information about the new 
kernel to check for possible security issues.

Of course, there are other ways to detect kernel updates — for example, 
by using ftrace to monitor functions involved in live kernel updates — 
but such approaches tend to have a higher performance overhead. In 
contrast, adding a simple update counter to track live kernel updates 
would provide similar monitoring capability with minimal overhead.

Yanjun.Zhu

>
> Pasha

-- 
Best Regards,
Yanjun.Zhu


