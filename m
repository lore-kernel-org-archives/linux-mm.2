Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C999CCD98DA
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 20:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E7428E000F; Thu, 13 Nov 2025 15:29:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE6A8E0003; Thu, 13 Nov 2025 15:29:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FC348E000F; Thu, 13 Nov 2025 15:29:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5168E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:29:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9933585857
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:29:03 +0000 (UTC)
X-FDA: 84106722966.11.6D1F74F
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id BD1654000F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:29:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Q/k9OO3h";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763065742; a=rsa-sha256;
	cv=none;
	b=jubyVamejUywp7CSlYWE3jQw6DCgr7VoiYaqzRUeInNk45ZIh38l+moSy2v3QBm6nufyce
	Z68kPjBHGgeuuBhK/EMtCvDmENXuSrUaVckp67M9hOubxI3D5iV7IrRayTcjuOZ+64+IXn
	PhvClD1LUpXtBHoUsmwYe7gPOqAPpNk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Q/k9OO3h";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763065741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afgZLvoRPRdV/uLRfyJlQxQwB+pZpdtXmSYXDn8K350=;
	b=s0mzoBKWBlSxT07x/I/gaiP7f71b20gC/JDghWHevXiEN/UB1+LUuszu8R8wA7Yaq8vfEg
	P3RHVbP+6w5Ryy5GFPOl89VLvnh9LCtYm6bOhZm474+yH4dvpP9/F+jt/Oh4pjYYmEAGPF
	9OC6Lrp7ofA/t7wJrH5UHfOnEopf74A=
Message-ID: <90d5e140-b2a5-4e7e-addb-c4f75912526e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763065739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=afgZLvoRPRdV/uLRfyJlQxQwB+pZpdtXmSYXDn8K350=;
	b=Q/k9OO3h2UzYaNYh9XPXo+5JV55ef6V28Qp/4OzYJUxeNlCMcvh/YfWaG6q0Q1eUWT67HO
	IXSnJ+qalmjNfrhf3lDEdD+uK9jCdBWesmteXEmVvDYkQ20UUdyFtcjOVfL6aGWg4O1Mxi
	LozeCODbc6HMeh2lP+4beKkZQu3jd4M=
Date: Thu, 13 Nov 2025 12:28:48 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v9 1/9] kho: make debugfs interface optional
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org,
 brauner@kernel.org, corbet@lwn.net, graf@amazon.com, jgg@ziepe.ca,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
 rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org
References: <20251101142325.1326536-1-pasha.tatashin@soleen.com>
 <20251101142325.1326536-2-pasha.tatashin@soleen.com>
 <d7651272-f979-4972-ae41-bab2faa8473a@linux.dev>
 <CA+CK2bDSvtuwrrXGOC07Rj42yGFHWR4Sse7Q5z1z8f1ZFHWQ2Q@mail.gmail.com>
 <CA+CK2bC_+repP-q183hjAuYYB2-Yx7fr_U3zr2cxysAWx5hzpg@mail.gmail.com>
 <029090cf-9a4d-4f79-b857-04c3ada83323@linux.dev>
 <CA+CK2bByYPJXSNOh6R3swqFrGsS02m3Dfh=ZU7YhNjNX6siyqg@mail.gmail.com>
 <442fa82e-16ef-4bde-84eb-743450222468@linux.dev>
 <mafs0qzu69gei.fsf@kernel.org>
 <CA+CK2bBEe16x0em1gRxQD3jhfV9t3QA2vx5ifk2pKb_WEoMTeg@mail.gmail.com>
 <0735e1ef-2b65-4a54-b4d5-964fb875cd09@linux.dev>
 <CA+CK2bBnnGyQ-N8-XS3W3tnSRwvFbstOdo0oDSdkF70KP1AVxw@mail.gmail.com>
 <9e144e21-a5e7-4c12-b8b0-07172787ab37@linux.dev>
 <CA+CK2bBQxB7ihmhBa76vJbdD988B+8PBrV4arDSNqjv_VB4DVw@mail.gmail.com>
 <CA+CK2bCUN6SH7x=DnTFvCgEYGKoyOrCMzwQjHCY0LK35Hd-_zA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <CA+CK2bCUN6SH7x=DnTFvCgEYGKoyOrCMzwQjHCY0LK35Hd-_zA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD1654000F
X-Stat-Signature: qxg9dfaki9j1zmabtdx3ac94sk14pftj
X-HE-Tag: 1763065741-676465
X-HE-Meta: U2FsdGVkX18zkB52soHolOF3X1h49cdxQgHmaxL6nFk9pcSgm+k2avhhEV+amr/YrlM8Vv9GOhcEHzp67VJw4k7cBClPeTd9a70Uc363f9iYe4pzU0oc/4Cw4ph9/xqbnddKGe1m3/woAxxivlcYnkR7aOqBknKGc3CKPoebyXDAdyt/Bq96DBZJx1WzAH/ZEGLTWxHuu+OcZq2cNCt28iWvL9xBF3Ay8OGJ25emHodk6K6iGjid2xlroF+gePx6U6jdLDOU+E2ORl1XlZ3/jo9AA+oB+7aDxFGGKPAKe3slRLfGpPHzPt9FluqQ22wLX/wX9tOkir1jVX48efV5e+7cH8TUvjKCWG+fIV7i6P3QfktT/vTuVCQnd9rLBC9A59EM58YMfYrfIQXGbJRK0bcbQAJeBmw/8pdsvMvd2lc3kangiAUY0AUpVls3pwyNoWklRq2FYCYuHXub5fn3fGd3jtBf2sZGgU1e6fa2ZFzWx1nWRy/MDIqYZWCWbA2v83cKDfIIn7JcvbQaiAHMtTcbiJghSsZBwc6Qr/PP7A4i+IkEY44bkssheH0sHrQtanwReqtevbDF5uP7qALdklJo/nQDrTZ/nZ0w4FOZCbvYfiZ3MvCalyuiVJiJ4spF4ee0HpeP9A7x/Ha2nJ3HHoEJu3Sr2NQFDSnF9tJDs5+5N3dYjumoca9QymIS/i5eaxc9cV7wYNUzhEn89L61F1neW+puUsdwAn3kp/7eR8xIBeaDwUdr391o1b1cx3LZeMQKDzElb0gO+BEJaziDV5gj4qg5bUrTPr4TnLK8sOtDLx5URmK+lLoukZg/Ens5cna+oNeItoGqehjR1W7FLIKOclA3JqOYbV9ZW8ULIvhogoDz048KX72j8kqdV+uZgGoHZ6VYPnDKT51ImMPD9hWWlqBjcxw7kLbq9kFDaECVm49w/05/IqGO/dYis//AfeE9OkFBk/oxYnFRx9u
 5pYZbmdz
 Z7Hh3em5umyuUaGa7bA9Yv5CMcncu1QwOS/nJYGj+uApdtc2F0Gat+L3AZVdCLSSB4JMk0e/65/ALbrc09hTkTWrN8v4yzJcA5C88waOmtArv+ZX2plbTXOG7L/J5AB+Gs/fLlwrtcCJ/l7Y4P0CaRt6B7bz1ImdQxXrtOHQbxWIISGggj0iyTVwJtZsmzKRIygdd9uH27WfyhtQwJu9YK4A75R13TnHFc6Vc7iRJlOSA8NKUytPVnI09MvcookB/V2uY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/13/25 12:13 PM, Pasha Tatashin wrote:
> On Thu, Nov 13, 2025 at 3:10 PM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
>>>    set -e
>>>
>>> -kexec -l -s --reuse-cmdline /boot/bzImage
>>> +kexec -l -s --reuse-cmdline /boot/bzImage --initrd
>>> /boot/initramfs-`uname -r`.img
>> Thank you for your suggestion, in the next version, I am going to add
>> initramfs optionally, I am thinking to update script to something like
> Optionally, because in some environments (like in mine), it is built
> into bzImage.

In my test hosts, the bzImage is vmlinuz-xxx. But with the help of "ln 
-sf ... ...",

this change can work well in my test environments, including x86_64 and 
arm64 hosts.

Br,

Yanjun.Zhu

>
>> this:
>>
>> #!/bin/sh
>> # SPDX-License-Identifier: GPL-2.0
>> set -e
>>
>> # Use $KERNEL and $INITRAMFS to pass custom Kernel and optional initramfs
>>
>> KERNEL="${KERNEL:-/boot/bzImage}"
>> set -- -l -s --reuse-cmdline "$KERNEL"
>>
>> INITRAMFS="${INITRAMFS:-/boot/initramfs}"
>> if [ -f "$INITRAMFS" ]; then
>>      set -- "$@" --initrd="$INITRAMFS"
>> fi
>>
>> kexec "$@"
>> kexec -e

