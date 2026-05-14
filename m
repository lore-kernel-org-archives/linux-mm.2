Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70FA7CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:39:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959886B0088; Thu, 14 May 2026 05:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930DC6B008A; Thu, 14 May 2026 05:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E436B008C; Thu, 14 May 2026 05:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77B2A6B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:39:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 286DA1C05CD
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:39:58 +0000 (UTC)
X-FDA: 84765528876.16.C36EE32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6F22A100003
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:39:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DrHn2EdG;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778751596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+68SWaFab2wzOytNkix4Y8TPRq4mk+W+6+KM87RuIFo=;
	b=GbZZZfP4mSPNloJHvVJFFCyWpxSyOinR2obqviF3TWYduSTjNDSfsqK7QJf6nj5X73/pi+
	KIgWQLqRLOvq89fMC2mfKPIQMTK6Jou3cby69lpNCsmg3eZ0JFzlybToYxpqTlZvlI+muK
	Eue51j5Y7tV+3oJSANQON2EHzls9FSM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DrHn2EdG;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778751596; a=rsa-sha256;
	cv=none;
	b=T+OkPgbRwzCsW76bNXAHuzOaKdD+QJYnIN2hDdeWp+vQeYxowKC27JBp+HllOk/gtzy+qD
	Ewwqr8kI6vBRqArteIiQuEyrwOmOjyafGd5ib8cDPDojMGRD88u5l5vMkGJ/WROTXnCBT2
	O0QxlYevo8VWlYTNl0KsjS2YcVnOV94=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC42C60008;
	Thu, 14 May 2026 09:39:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A8FC2BCB3;
	Thu, 14 May 2026 09:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778751595;
	bh=DHcx3aovbP+JoCVxu3/iNaP1b/668QSCA4X5z26cpnk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DrHn2EdGsspMBh2RrrWhrLAljxmtslTNgsHeSXvJBMB18gfDiPJ9Td2Y2IK4xZhQA
	 qE5HLJfeiXZvmedFAy3Xq0KzPIhPda8LnVsrr2x+oleaVOD3e1VqvoznttLj6HwRg8
	 QU003yTYN8bFfcxsrtXob/WbfqeQ4Rm38L9bqcgYyL/us3X7VzjJM/82HhNjEyuVe7
	 +DEQH+q8xgTwYiVN7VanG2hA2bbJ6amG6GUexo1H371Qohsk44afdjzfT9gI8y0flM
	 8zWpEk8CyFmyc7xp/Qj1jOdUCe2fcZmFnPjKt/+z17RAEa6kmUdrTmErS2C32d2Lfs
	 mS3Ia8T0nivgQ==
Message-ID: <be7a2a06-cd81-446c-9875-fafb198caf78@kernel.org>
Date: Thu, 14 May 2026 11:39:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: kmalloc_nolock() follow-ups, including kfree_rcu_nolock()
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>, Levi Zim <i@kxxt.dev>
Cc: linux-mm@kvack.org, rcu@vger.kernel.org, bpf@vger.kernel.org,
 Hao Li <hao.li@linux.dev>, "Paul E. McKenney" <paulmck@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Joel Fernandes <joelagnelf@nvidia.com>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Amery Hung <ameryhung@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>
References: <esepccfhqg7m6jo76ns2znj2cnuaepx2xvw5zaygtwohq4psma@563ypprp6rr3>
 <9bea1536-534a-4a59-9b5f-92389fb05688@kxxt.dev>
 <6wvjo33urd5i4jvbf6rwp7kwe3ppn3ktgmjk663hq2jxax65gm@kxljf3hkqs5e>
 <1315d145-49ee-412f-ad91-0f6c61c4c2c9@kxxt.dev>
 <2dhbxmhg4l35gupk3wgwtufsf735rnk4czmcoyspzckvexie3z@nswohkoipx44>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <2dhbxmhg4l35gupk3wgwtufsf735rnk4czmcoyspzckvexie3z@nswohkoipx44>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6F22A100003
X-Rspam-User: 
X-Stat-Signature: fqkeji1enrbh4s4qsoi7x8at1o8fkeqr
X-HE-Tag: 1778751596-981378
X-HE-Meta: U2FsdGVkX190e5U13BbaFpUvhLPXq7H1dQKrJDrKtowPpjFUDOhVMZICkkx/hRWkGGNkCokceRE0GlZBtQ6QS3yp0SuPJ95RkhggMn5zhFaUhaHufmqCA3z1HG+F0O9RprhYrWAkQ8ypHeymqaf/PcLowmyRqu3thVDFVz6mXe6D7orqTWOhcIrqXnBIKyrSdszU0fH0fcJljOm3pS3yNQQU88bVA36aNakmLBY9Qc7xWc1ROKtRG4b3TukcHpm/SQgcVj+ACh/gn9f7GGjzJ+dxfjMjlgNlRdcFFHU871kgorM71KvUWEXwRLVBVVhWBV9VZe6wHyxubzkJFZsDUaSBksAKtu5ENSByeRLUb9P/zU3Kbw86Jf2vH/jLcdoHAoZ4C8pCqRV0cPfIrqEwm/mHkZnU9W04qvvgv4KdDcuWcXYOSOWuOSiKj676eY/WUQeUtbwhAtUb5n9ahnsyskyAPbntKjzGcqQ0YWHJHe28lWaUr/Ds+wK1yrWOmE0dVomPh9JjMrkAYFyb7MXctPf1dQxH0X8T3hQ0qCH+rkbgrQt38mZmiXGpz+tyrCslPpfPOXrUDQb46zjgHem/GGkdluCrbE/jLQTL4G0c0wnjBgyCAslPqm9zRXZPtkgKM7Lz7CqboNF3cVFZo7S3obpvg2pun2f9qgJFR6Ni/pTZpUACkLtSmwEJsJoMahOj3uzPf22+SrhipGlpz/DxrLMja0mjn65cipA1jysC9vs6WxXkYl6mp5G9PmO1lwEg68Wqz6HAuLqEHLPHyeAvPbTQuMMUAUHzIA90NVbHfOUbZeHhaswv2KR1oi+Lfg9uGab6tQPsdvjhaTUpT8DFrkhcNQulwD1Eg+ejok9vv3pF32sVKA8L6PwL907j/OgZ26O3bg13VdBAak56SxStzFA/GJ1rEM/6QlqU/lc69928kGWwF6pS8epMbr1yD6Uf12d+SB5kw9SqNOy3aLt
 AnNVfkK+
 7I+Vou6WukoYhQXAEvWV8vxOubQvfazLpscIeFS9oP0rtERI4QiJzPCglyEhs2sfAwDYC+1bVLGdd3LSDLEEpiR1O62mZmmIEWgTaLLRaadxDr7nxPo4FcGSDWyKdt+M+k+UfXJaUx7oJltNCBqUTiuJnibe8VMpgnVDRLkAH2e8Qo8wEqUnbYqIQ091wMhkILFrSFQpcmxRW5qjDX19YfOtbs8b6trbm9HMWeO6Wt8iY5ZLJqWwzKFUV1seZA5GpT3RunV8RIaeX1DX40DOx3NUHBEbC9hssDI1eDPOqLmyigfXTqNNdk6cmJCj2nBNhVN9J/yrqbb2/Pe0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/14/26 11:25, Harry Yoo (Oracle) wrote:
> On Wed, May 13, 2026 at 09:34:01PM +0800, Levi Zim wrote:
>> On 5/13/26 9:42 AM, Harry Yoo (Oracle) wrote:
>> > On Tue, May 12, 2026 at 09:46:33PM +0800, Levi Zim wrote:
>> >> I don't know how could we fix it otherwise after removing BPF memory allocator completely.
>> >> Could we find a path to move forward without causing regressions on architectures without HAVE_CMPXCHG_DOUBLE?
>> > 
>> > Probably we can. Could you please see if this works for you?
>> > 
>> > https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=slab-kmalloc-nolock-without-cmpxchg-double-rfc-v1r1-wip
>> 
>> Thanks a lot! I tested it and could confirm that it could fix the failure of
>> bpf_task_storage_get(BPF_LOCAL_STORAGE_GET_F_CREATE) on riscv64.
> 
> Thanks for confirming!
> 
> I will add this to TODO and post them and Cc you when submitting it to
> the mailing list.
> 
>> The commit message says that the allocation may still fail if the slab lock
>> acquisition fails upon the first try.
> 
> kmalloc_nolock() can always fail, unfortunately.
> We can only make it less likely to fail.

There's still the fallback to the larger bucket, right?
That pretty much guarantees that if we fail due to a local lock in one
bucket (due to preempting its holder), a local lock in another bucket won't
be locked at the same time.
However if local sheaves are exhausted, we might need a shared lock (barn,
list_lock, slab bit lock when no double cmpxchg) and that might be held by
another cpu in both buckets. But should be very rare.

>> But this is still a great improvement
>> compared to the previous always failing code.
> 
> Yup. Thanks!
> 


