Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D572CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 20:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C666B008C; Tue, 23 Jun 2026 16:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35B86B0092; Tue, 23 Jun 2026 16:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4BDE6B0093; Tue, 23 Jun 2026 16:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5C5D6B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:06:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 078FB165249
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:06:54 +0000 (UTC)
X-FDA: 84912260748.02.EAAC4A5
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 941BBA0015
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:06:44 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782245204;
	b=Q55TJ6TiUMV7equ6Rdkn3VrEU8SBv6bph1o+7NNGnAzVmco+jdy2N+awVDbyvWFCmmWaXz
	3Qfvct7xgfnIay7jnBY1mYRqhMtr60km1WJ22GTdRLn191aXaHnm6Bh9SMS+VNHG9mbiJx
	GUffe5UKZ0Zsx84dlDLgqSPw02cIlMI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782245204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYPy5Kp/eciXGU33EP09NXjsbX2uzzGfRHxirk+T+0A=;
	b=cyYlrqNMO1wgMWnMdshrRBjyiiCuPqezHwTJsb8g16+FckjFy+/ivhUH7eZ19xYUReYrMm
	KfL4Iw7wbt75eCWxlxCvBv6lmmgrCCyHI/NSj7x6Jyppe+IEG7M7RqLCVtgQrZAxmQ02+l
	c22iSuyB9jDEC+Djftk9o4b7+0Qh6PU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="F+efduP/";
	spf=pass (imf25.hostedemail.com: domain of 3Uuc6agkKCGUWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3Uuc6agkKCGUWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-697498c701eso146758a12.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782245203; x=1782850003; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kYPy5Kp/eciXGU33EP09NXjsbX2uzzGfRHxirk+T+0A=;
        b=F+efduP/3Q/apV3YZzQzu3zPWPrUo1UwGvrZnbE23Cj7HBhh818xQ5BiCaOll8nfqv
         mFhp6L4EeHuVa49BF1pHfJSw6IYH9VAdchxPu+4AQQHUobSBcpIYkakc6BuqjBm6SfdR
         fyEfyez5n+UA8YwHh+7QISbfEk912n86lvxk2hCqIZ1JWyTR/buK5IXUw5raLZlujMyB
         zRiM33Vl6uFu4rCUy7H1caj5x3oMVHl7SwJD4EH0bmOnOtUoZsLh6QaiTXdcatEbIPBZ
         dPHBhE4nvlVDVGOJZ0+Y51hEeNyG8T2d0LaYnPkTF254OytckIhBmje8PCGHeSObfU7k
         nVUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782245203; x=1782850003;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kYPy5Kp/eciXGU33EP09NXjsbX2uzzGfRHxirk+T+0A=;
        b=PZBn+Qdl3p++gXqBdRnE799wwCM9ysfeGXMNtcLlSKBQdHA4BohaRsA6ba6PKHVAIt
         llBnj0e+nl+h1CmT28II707CteVWt3BrIndpLig/WxMTB+AWK2V28SOcOF2GgH3xs2Fl
         ge5YzTXUM6WUfqtUAC65C1OF+gz/KQ6vqYgVEXGy+WfMD2vSMeXYz3ENuML7r86O8f58
         8TJ4z2qpPIvknv1K18ltrefjlX3RuIdC0tGJVYiaKRhlUmXJ/8XA62BVMY4OmgQUcrAz
         ZLQxEFE6r+5wj1D6JdPT3mgVGsra8jhqJeel1QeRNG16uPqKzRxo6PZ6G0cFpP+qxsJJ
         gV0w==
X-Forwarded-Encrypted: i=1; AFNElJ9twvVLnqDCSGlwdO2exks4fblZCJkkI0GZZJVQh7UEIq5DiVhy+yg1wV2wedQWqXSmYIGCx7TlcQ==@kvack.org
X-Gm-Message-State: AOJu0YwX30XRPGpeT1hWG8HHtYqCkjWMAsVOe2VXR93MH20xinWxzKCm
	Y6wj+fdtdvkqMQXLcFN69D8rSpPMJ8w4jfZoTyRkoxYl9AP3tTw/vuskSaH3ixoMjiocsHUTU7T
	nhxH9f/rvaEj3EJzwtw==
X-Received: from edyc13.prod.google.com ([2002:aa7:df0d:0:b0:697:e99f:d111])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3554:b0:691:b5aa:5a7a with SMTP id 4fb4d7f45d1cf-697f3adf4a5mr19296a12.21.1782245202451;
 Tue, 23 Jun 2026 13:06:42 -0700 (PDT)
Date: Tue, 23 Jun 2026 20:06:41 +0000
In-Reply-To: <2vxz8q85mdyh.fsf@kernel.org>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com> <48777f4749fa43d5648085dbb2037aa99c144a88.1780676742.git.tarunsahu@google.com>
 <CAEvNRgFEHciT3T9y+qEYRvXhDwfrggoU7Rm=f9hT3OrV+wgpNQ@mail.gmail.com>
 <9huztsqtmihs.fsf@tarunix.c.googlers.com> <2vxz8q85mdyh.fsf@kernel.org>
Message-ID: <9huzv7b910oe.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 06/10] kvm: guest_memfd: Add support for freezing
 and unfreezing mappings
From: tarunsahu@google.com
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>, Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	fvdl@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, aneesh.kumar@kernel.org, 
	skhawaja@google.com, vipinsh@google.com, Pratyush Yadav <pratyush@kernel.org>, 
	david@redhat.com, dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com, linux-kselftest@vger.kernel.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-HE-Tag: 1782245204-624749
X-HE-Meta: U2FsdGVkX1+dcyfRNY75S9jmitAkBPCGZxCjCuRbmY+CjKu7vG9tP0UHXEmUotCxsj/Z1l7gfEePIsFUSlVyIPgRniho3uaS09BzObW8h+Z35s2FRNKl5i5vk3Rw3QcR/jcTGqip3zOS8+QBxIk6m6QlSePfo2i3eQLIX9tddfLJTdR9L5Dsp/FT9dfr198JEKwl1CzpkGfwwsuGkavNgDdVBkBp4Z0cnp30C6sT7uK7Z180BnRFBfIsNETQmlODTaRayeYlOEMsNxO3cFbKPfZtBBkY8acQub1R0LhVqQIVQVEzGEIAujDRyg8ESdcOaZLxsaS9XC1V3W0uqs7OMcfm878R1bfVeK7M3KguIRm9wPf063jp8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pratyush Yadav <pratyush@kernel.org> writes:

> On Tue, Jun 23 2026, tarunsahu@google.com wrote:
>
>> Ackerley Tng <ackerleytng@google.com> writes:
>>
>>> Tarun Sahu <tarunsahu@google.com> writes:
>>>
>>>>  static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>>>>  			       loff_t len)
>>>>  {
>>>> +	struct inode *inode = file_inode(file);
>>>>  	int ret;
>>>> +	int idx;
>>>>
>>>> -	if (!(mode & FALLOC_FL_KEEP_SIZE))
>>>> -		return -EOPNOTSUPP;
>>>> +	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
>>>> +	if (kvm_gmem_is_frozen(inode)) {
>>>> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>>>> +		return -EPERM;
>>>> +	}
>>>
>>> fallocate may eventually go to kvm_gmem_get_folio(), so that would check
>>> kvm_gmem_is_frozen() twice. Is this meant to catch the punch hole case?
>
> Yeah, I reckon you can get away with doing this check only in
> kvm_gmem_get_folio(). Normally you'd like to fail early, but as of now I
> don't see much of a problem. If you drop the check here and fail in
> kvm_gmem_get_folio() you'd end up taking and releasing the mapping
> invalidate_lock, but this isn't a fast path anyway so I don't think it
> should matter much.

No, Don't agree.
kvm_gmem_get_folios already have the is_frozen check. which blocks the
kvm_gmem_allocate. But not kvm_gmem_punch_hole. Your argument is correct
for kvm_gmem_allocate only. So is_frozen check in fallocate is to
block the punch hole as well. What ackerley said is correct.

>
> I think either way can work just as fine...
>
>>>
>>>>
>>>> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>>>> -		return -EOPNOTSUPP;
>>>> +	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
>>>> +		ret = -EOPNOTSUPP;
>>>> +		goto out;
>>>> +	}
>>>>
>>>> -	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
>>>> -		return -EINVAL;
>>>> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) {
>>>> +		ret = -EOPNOTSUPP;
>>>> +		goto out;
>>>> +	}
>>>> +
>>>> +	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len)) {
>>>> +		ret = -EINVAL;
>>>> +		goto out;
>>>> +	}
>>>
>>> There's some reordering here. Why not let the validation happen like
>>> before, then check kvm_gmem_is_frozen()?
>
> There is no reordering, if I am reading the diff correctly. The diff is
> somewhat misleading. The kvm_gmem_is_frozen() call is added at the top
> of the function, and then all the later checks are in the same place but
> get a goto out (and hence a full body to the if block). So the diff
> reads like reordering, but there is none.
>

That is right. I thought Ackerley was asking why not add the check after
the all the if condition and before the kvm_gmem_punch_hole/allocate calls.

> It would be very neat if scru had a cleanup.h style scope-based locking
> function, but on a quick glance I can't see one.
>
>>
>> To align with design. "stop the fallocate call if inode is frozen, No
>> need to go further". I dont have strict opinion on this. I am fine with
>> taking it across punch hole as well to make it more fine grained. But it
>> will no longer claims stop the fallocate call (allocation one is stopped
>> in separate path: fault path) , though functionally it does the same
>> thing.
>>
>> WDYT?
>>
>> ~Tarun
>
> -- 
> Regards,
> Pratyush Yadav

