Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95B1BC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4EE46B009D; Mon,  3 Aug 2026 08:49:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26756B009E; Mon,  3 Aug 2026 08:49:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF3A6B009F; Mon,  3 Aug 2026 08:49:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 634B16B009D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:49:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38E38806AD
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:14:25 +0000 (UTC)
X-FDA: 85059850890.01.63A36F4
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id E6EBB140003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:14:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FzYjT2I4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ruirui.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ruirui.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785759263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xri95HxWWHQhvW9BuZBsF19Q6k7n+JZ6FN4+B6v5Sz0=;
	b=v8ClrGuK+aYTsagPKQeqF5kYXi6XR6dUmDezDiO6JIysSyUbaXW+BjNb4Ky0KF6kfsRqyM
	yWCSu/m2qweHQgasZnY3+MFj4VBhapOqMrGpBAbLoJuOCs1HG0QRQfNAdZDOtVBA/R9q+4
	Mj2byN4EmKRXDgeHLzC5U+uyvL6PNRY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FzYjT2I4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of ruirui.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=ruirui.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785759263;
	b=5RND+wjxg1RK4h2/Gq52W8yi3JTILkXOkqh1gcOt07qMrhS+3plS8F3VDRthN9L8ZSpgIu
	CjkmIV6c/UEPXJ4ZsJZFKL8Seo0A2PZEfQ8dNhyNMu3CP5y0MQsKLMDyi+nf6UQfxxMjX9
	sQqSYszrM86G0UfK3trkmHMPqPSFc5o=
Message-ID: <ab46b71a-9f8d-48c4-89be-e15ce50aa8c6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785759260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xri95HxWWHQhvW9BuZBsF19Q6k7n+JZ6FN4+B6v5Sz0=;
	b=FzYjT2I44jBLuUUeCvzQl6e0VW3AvRXowFAr+gnT7aMEJCzMo7XlqdR/xiXXtBVzlHsj3X
	HOYYUxckQSsYo5h102eGGFKinriCQDXOFbvZZMQ7wigLm2B2WMl2CTQCNW7hALBadhCIcx
	E/q3ddOqn8GXb0/C5uHmuxpiuU35fPo=
Date: Mon, 3 Aug 2026 20:12:46 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] CRASH_ZEROIZE: Wipe secrets before kdump
To: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <contact@jaseg.de>,
 Baoquan He <baoquan.he@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport
 <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Mimi Zohar <zohar@linux.ibm.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Rob Herring <robh@kernel.org>, Saravana Kannan <saravanak@kernel.org>,
 Coiby Xu <coxu@redhat.com>, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 keyrings@vger.kernel.org, linux-mm@kvack.org,
 linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org,
 Tao Liu <ltao@redhat.com>
References: <20260731154608.153258-1-linux@jaseg.de>
 <am38qk60mpVFuJRi@MiWiFi-R3L-srv>
 <74625f78-15ea-439f-b9f0-939d2976fa7f@jaseg.de>
 <79610b53-5201-4af3-913a-0c4dcbb6f9d6@linux.dev>
 <e9523b5a-6623-49ea-9ba3-cddae1a9ce7e@jaseg.de>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dave Young <ruirui.yang@linux.dev>
In-Reply-To: <e9523b5a-6623-49ea-9ba3-cddae1a9ce7e@jaseg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6EBB140003
X-Rspam-User: 
X-Stat-Signature: zc1y91sxscq3gupbxycz911oj8p4t48u
X-HE-Tag: 1785759262-592422
X-HE-Meta: U2FsdGVkX196939Wdoy6sx+iC8WkWE6Wtiig0P5gLheMiJyWTL7mXfSMo6jEBnfrh/BlV+whY6MFUbWJHVxD0SvMXkgP/Cgch4U0dZfkJ66EMXOqqaSQZjHp9laDPyFthLGBtyIpobLMQwuG4YnzTY1HZa+Y3bb/o1FhW0L0sxoc9pkK0AY5rBrkV96+ghshC64E85xU1zifMEYjDfKhoFQItbpKTGn3fLSrxvQF7BAl/rX4wBAuugj3nT1a3ZXWcO1ZxqACZ3cTmaifKdawyzEP0ESVTwZNKQ2rYhi7Lx5KrDy3oMuDvQgRJHi6+qdyDh3XOBmvvILEjYQSGxhMjNXixTd8RfKAwHFQJu0BzkWTIO/18HW0kzN0xeWuUhd0yXXPc42phAQvZ13TfnOuprpAW3HCruQmpnek0tGBNofo3V81HZiN9mdYSywygzN1DsdGflc2N6cDuWHAoV2b+AmA7mCnEcRwt3TKMM8eJ9Jjp3KEOwp7zx8EnOY8BKhONZcDAfmLxJblvnG3vL8HRvrXfjLtHIqSYLPfN1bNwxDzMdXLzRwXZVI8CEntB4ZAo/Sg0fnfuBeOlsy/2gVJcknQoPeKRzOWhHn2DvV4qQ30zi0wfWZL6p/Fumch22b3lLmDzfqZa0VEc+KCAvwOHVqhG+2sYMXcLttuDXbhrv07TAsl6VhI2VheEcxPfpFniTmPnpDK0vhUPA7TwMrO0pQRbwwj13qBXjr+DwvMr3SpKEEq2hSne8m9ipQ4C2wx9N0qrHFHHG/JFau+Q3Wk4SUGp/Q0HLN+6/iFWIrZG6WzIqratGy7SEO2R6Xjf9+z1u4LprFXkswocEVvxBlNhG1Q21ZXWHdj0j0Gffh/VgPzwtaG+ZC7l5Ss8vV50EVDY/+eaHpOWzpoiifIIhHrslzwLwxiS71Hg+WstZNMD70s+iFOQmQlWTwXGM4hgJTkrNS9IJSe2UpYBVOu6V1
 KBSotz8I
 c4gTKKUriVsv8X8OU17BlPO1/CD7UXSICIPT4DPD6Q6i1UMhyn5f2i6ftqVHcHPGIoo9TbPZ2SMxszNMW6q+c1+Ro0jziUamco4WjwGVNxGW5sZfjFGrx4L/xNuq/xTK++vI7l+rw+cwxUIfU26w/rBuShQxoU8luibgNAYmPxFubPzvR+L6vGa9Ona79qfm0+WoUKjjP///AsczqSCrTmv9jyULYRf7kNZShYo1Lc1YqTV8240Hl7bWCdlMdZp1ZLxPO9huNxUd5lMXfcqeLJzTpvA2OLhkBSUz22uV2q5JgqK1zzasUR3vqD/576qFMRcJEa00T8MzPmvAb7yBayjIRa4+A4PD3uKJ5cwTH1YZm/JQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/2/26 6:20 PM, Jan Sebastian Götte wrote:
> On 8/2/26 07:08, Dave Young wrote:
>> On 8/2/26 12:31 AM, Jan Sebastian Götte wrote:
>>> On 8/1/26 16:03, Baoquan He wrote:
>>>> Note that we usually dont' want to run a lot of work after panic and
>>>> before jumping into kdump kernel.
>>>
>>> I understand. For this reason, I think it's best to keep this default-off. As-is, the notifier list call is timed and on the (slow) ARM64 target I'm using, it takes about 3-5 ms to run. I took the "try lock, skip if locked" approach to keep the risk of this code crashing during panic minimal. In my application, the kdump payload is code that then does a full wipe, taking a couple hundred milliseconds.
>>
>> Not only about the time used, the panicked kernel is not reliable, any more extra logic can make it even not reliable, any pre-kdump extra logic is not a good idea unless it is a must to ensure kdump working.
>>
>> Cleaning up secret data can be done with makedumpfile + eppic scripts (see the manual of makedumpfile), or it is even possible to do so in kdump kernel with Tao Liu's improvments for makedumpfile previously  (I don't know the status, probably dropped for the time being, but it is possible, cced him).
> 
> Thank you for the pointer!
> 
> There's two scenarios worth considering. First, in the standard scenario where you enable this option, then drop into a standard kdump kernel, I don't think it makes a big difference *when* you do this cleanup since someone is going to have to dereference these pointers. IMHO a good reason to do it in the old kernel is that there, the code knows about the layout of all the data structures. To retroactively do this in the kdump kernel is much more complicated, since there you have to reconstruct the structure layouts from symbols or hardcoded struct layouts, and you have to keep this symbol/layout information perfectly in sync with the running kernel.


I know that this is the usual reason people want to do things in 1st
kernel :)   Like the crash_kexec_post_notifiers which was introduced for
people to use at their own risk.  Is it doable for your case to use
crash_kexec_post_notifiers?


> 
> The second scenario is what I'm working on here: I'm not using a normal kdump kernel, but instead a custom payload that wipes all RAM from start to end. This payload will wipe all these keys too, but my critical concern is speed: On the embedded SoCs I'm targeting, the full memory wipe takes too long (hundreds of ms) for an HSM application, so I want to do a targeted wipe of just the keys first. The old kernel I think is the natural place to do this. Adding to that, in my scenario the most likely trigger of a panic is not something like memory corruption, but a trigger of the system's tamper alarms, which would leave the old kernel relatively stable during panic.
> 
> I can imagine several possible mitigations for the stability concerns beyond the default off config option:
> 
> * Since the wipe handlers are all really simple, it would be possible to manually guard every memory access there to ensure they can't fail and that they don't write to sensitive areas like the dump kernel or the remaining panic'ing stack. Doing that would only rely on information (more or less intact stack pointer, kdump kernel area boundaries) that would be necessary for kdump to succeed anyway.
> 
> * And/Or I could extend the patchset to include a mechanism similar to that in Bradley Morgan's patchset that catches segfaults during wipe, and then skips the handler causing the fault.
> 
> * A last option would be to have the alive kernel prepare some kind of "wipe this first" structure in its memory during normal operation that the dump kernel then can pick up to do the actual dirty work. I disfavor that since it adds double bookkeeping to a lot of places, some of which could be performance critical.
> 
> I've also picked up that I should remove the timing logic since that could cause instability.
> 
> Thanks,
> Jan Sebastian

