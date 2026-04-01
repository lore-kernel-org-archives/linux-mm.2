Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2604810FCAE8
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 22:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30376B0088; Wed,  1 Apr 2026 18:38:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1956B0089; Wed,  1 Apr 2026 18:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0216B008A; Wed,  1 Apr 2026 18:38:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD1E86B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 18:38:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FA361B6EC8
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:38:17 +0000 (UTC)
X-FDA: 84611451834.22.1F16D1F
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 72C2C20004
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:38:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ecHDv55q;
	spf=pass (imf13.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ecHDv55q;
	spf=pass (imf13.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775083095; a=rsa-sha256;
	cv=pass;
	b=iYl9z2NfZjx7VbhmI4T3znSuS2n+EUqG1RssxrQqrU+UohC8hRvDKPBSXp9cAxvN35pCAp
	VSh8HbF1+Vp5cqZMF5Y2MXLUIPO/B5Mb/N/hg4+VH+0UK52xP+/mzK882tL9GwI6Ed3LxW
	Jb6gTk0L6/aE4mDOCWM6pkrnbB229M0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775083095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=euITMSp/xJeCQhYA18f4lx9pM8JTP5ZhaaxCuXCtMTI=;
	b=hQxDjjrwaloAwA/0U+5MqD6GcA7yWs/Ql/0MZ+UmY2JXcrudlne3eZEJP9BNmxJi0/uRCD
	gmVLj3jk0MkQEOHR9ctkyB8QSk0aSoTEwFxlFdSHEQjBy7W4onFa/Wu6rPI7sF1CsS267H
	gkCIMrhA3qjGUO+Kq9STa5BqFd+qQjk=
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-5ffe9a5b128so62234137.2
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 15:38:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775083094; cv=none;
        d=google.com; s=arc-20240605;
        b=AdlqZWt30oiFSz1bPFKJN4mqxKD7PeU57i04iTHjFKTmqazqhGr4mdK9C+Uj2FW58Y
         CdKmz06T3f9XHb1UYMmgFt3PI275uhKVMARBoxhyR/n64ObnVmPNk4YtZy90Sdf5X/UZ
         AtlgHqiqqlQzALkSoZ4wP54+2JIuZ8WWNxkhJGYVdzRoDgGpFrymI9CkRRvh5UpFFeFD
         6wxvJYaoed32Mdrek3kDVWtO17Wc+p+n5xcPgurs5cMAavMNDLzsn1TR6cShYFVV9Cnq
         VVReZoprcOCFjjJia6/IJ8c9iDyFSmKg1997gabYApAIQsrzJdkCiM+wzDFkwGJzfNwy
         Ge6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=euITMSp/xJeCQhYA18f4lx9pM8JTP5ZhaaxCuXCtMTI=;
        fh=Bw9oi5xPIBY90ZeS39jX6zrFiIb6SuFPvJpW5DEhHwE=;
        b=hKIIyrMAnMsVIiMPosC51JjUPVVrAEfdDs0/7kPF0Lpik8nc2tp3XKhq+5Kv07zP3k
         lUQIkfhXVhsL2FzvJFlxpmZLEuSDMJmjR/f0aIyeG/GL9HrQWHtbfSlnJ7kb5cT+oOwq
         t7GUh2SjKPtp7zAhXfsjaOKmYRqHGtQJNcu5vEvBhhWVzzJRZODLLitgIi5FPwYkSJww
         YGKvYBWxO49B9jdTnPBLG9xipnlnhXCJvQ0iYFR+i/ewNwM/7Me2GXmiupL3QpVAGdc9
         jh3xcRZ9PG9OeUGIASN8Ln+nWhU10vFNRczsombWDZt/Ihbq1uYwPpxjHxH6FAmxzduQ
         POxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775083094; x=1775687894; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=euITMSp/xJeCQhYA18f4lx9pM8JTP5ZhaaxCuXCtMTI=;
        b=ecHDv55q3n1OUf+TOQhbjH/lDptYhK8SenN0MPQmZ3wBxRDRJn5D0AD9RTUv1//THS
         M3F/MezMwBpRqVe20FRt/xdOcj1z0rcT7e7ESUeAv8AVREulGLGnoVb6bPKhIDSS4opT
         UncAMssqziCHuWuDDphgaBrzJhM+2Zk/OiiRvQjELRbrgZtD4ty/+PycvWe9yOgiDYw8
         rqLoO0IjPJ2RkwbVW6SqGctLULtrPcUNoeCfz5xzmAmcmBoXibmy2uIfEMiuoksY0Yq4
         XKIRfA+hmaAvGisl5ElW4xsjDTL/45DR9Twno+d12rZski+b38om/TNsgb2KNFGuuiOa
         2Mkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775083094; x=1775687894;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=euITMSp/xJeCQhYA18f4lx9pM8JTP5ZhaaxCuXCtMTI=;
        b=DxyJzUAnI4ouHiLWTey+xUTKk9zD70hrK4nH9kuniGcy8nuEwvnYSEcUEIlUc5cKQJ
         GulbHMjj28b7juKQzsgZGLI/4rBWY0cVqSUopkEEvx5DF8MqlJ9+m8AuVhxXkRtSfHPU
         afH7LFSLnfkrunpU2RPY8+hkm/URov8VYSTXyl4wxiOEiCrA3hSicCt+Wu+fjH/fPJEz
         VppG4XAdoxkF3XPOfFD8igSmCtkEnu0AE8wqnSOzZnf5P/Azmsv0VGCgvS1d/eYUbR6l
         JMBgvv5tavmVfg552OEv7i4l9naicfmIypIBjcyoeG1HcP+2nc1HlnJYM6flIlK6CZZz
         eQmQ==
X-Forwarded-Encrypted: i=1; AJvYcCX4D5q+JgHv/vqcnSe+IpJ6qwJ5BCW8nHJ88Ysg5rQg6nz1c+iQ40CGSN+ipeVeSALXsKGbznUggw==@kvack.org
X-Gm-Message-State: AOJu0YwaTcNzzObm8TBqN36IKnpOSBGidj7nS5JpSoGz6C8AihKXymgC
	cZkW/ebcGHW6FgYAoJRS5NeNRt+r6dI0u81Mj5DavUBiaKVhb7+9u7G/4Wots9KHHgba68/pHBI
	GgTISuomiw9jUFKSQ8nyAoAHAHk5aV66DWi8BXP6K
X-Gm-Gg: ATEYQzxIIVqFpmDpcSnWzysIobEUft/KAmnYGRCdc1BRAmieev7tKTYgDIgFZyI+XAr
	5mNZ8YJNCiYXQS/0eIRg0OrJl/CHG7VLcS9xXEGYGr4vkaefNHw7Q70oocpy/z9ULGttbSS5rzw
	zU5ezYi+uExQuyAmFkdOdrSoWjsqMD9Cf4tZJcPQZ7CA6UZ5VmLV932vV4HYY21JmaqhJ0gKBmN
	B3pQcTGKiS+oNcARBysXswa8sN5WQvWptf1CfmufOsMwA+udjt6BJT3Oc14jMl0g03mp3r8EnUC
	Zziie1h+hgO0nw0RO/ArFrErFrf3BKw0IfaZxzV6nymzjCzn2ClgAD4oJ7P9KWjIZPTDmQ==
X-Received: by 2002:a05:6102:cd0:b0:5f5:40ab:2d65 with SMTP id
 ada2fe7eead31-60583fb718fmr487325137.22.1775083093776; Wed, 01 Apr 2026
 15:38:13 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 1 Apr 2026 15:38:13 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 1 Apr 2026 15:38:12 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com> <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
MIME-Version: 1.0
Date: Wed, 1 Apr 2026 15:38:12 -0700
X-Gm-Features: AQROBzCNhmfEK8q5oXqVxD-E8d6K5nvB8FmwqZKQD4ACNG80cfTfNWvs3WVsxNc
Message-ID: <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: Michael Roth <michael.roth@amd.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	shivankg@amd.com, steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 72C2C20004
X-Stat-Signature: ook76t887agu9gj1h7xz59ydzbenha9j
X-Rspam-User: 
X-HE-Tag: 1775083095-713311
X-HE-Meta: U2FsdGVkX1+pdVdY5Dka4jdwYnUdAx6NtBtlFGK3ZtGnyZvRH8BYLxNs4Z2A7TiZCRM81XLrVbV2FdcTL8O6qEy9AtSxXwfdIbLoP6A13Kk9FkMf+76Wv0h3CTHCakBLe8Td/6OGg2RQ7wDPItyjfnwkz+ZVJX4lUZGHZgI7eNlhMq31irRbmFeFIkGBKOY8Epnn9p2UW+6AkVOi/fUU0rzmQOMQYJ3/UltQxDmGdkP1U1Qh0ZUJ5eLgd7nYz9rtygAw0LnBgpp5RsB5j5VOXmsxXKp9lSwm28kYZnycyY5dsr6euvULQfXBZ5WVgxANFa0qII6AYXcJyx3a+xIFysfnag4RLUF4yKLnRAAp6KY23O0ejYAfZWDTlFpJ19oEA2F1cae/N95P5Wv83f6NGoKfN74Z7S0CpS9zJmrKaATFr+UdtpVSF9WRtJmURUKF3uhKJ63UG3CTeiTDGWpS31O0xmOr68xfWeh9qmpxpwgsyxozbQ+cniG55pHFfuRywnV1oivK59qNWsF6g/RI0BKfFJf20FzEX814plPzFNFuHsHud4UkFMU9f/t1r7BtuzRtdqi53Usv3O2Ru4cARnTo4fTZwjMNrUxyFGk6/7YEPExpfFn7SDo70FjYR7qcX9OhDsqFV6Hoq+C/n+HQpw+AeOp2fiHFSLplP269VKGrU4f0wZDyA0aQNyYafoQYPa5euUAckrllH8ChSxf5e6/dcvNG1+JEYeziQy3DlOWB6F4LdTv+U2PbbJJXBBqbtfDagkZVQIHXhiyEeeo0092+iM/AYLqAVc4SkUYsO6r4aLYsJZLQIcnQQoTqDwVgHJky05eJXyjUFvKYwb/Da7Wj9epJtz8E4/id+XhqOMAKrK8Z9afUiMcV/PCLuBWl5ViSe3U9xpsFJSVkHkPEgsTq7o3R+Z5mUm3xVTaajU3KA8uo7C0uuAKPQnYLpQonHOTM7mdo0DCQeMa/TkH
 RBLvuVVd
 Dyu15zNeq4p7Q+Ynd+E9iEqnw1EADUCGzqziEVx9eQfZO8ZAzc1jfKiUADVIlQkou67Dm1/66EbmQ2PbkllQM2nyT5UYmiSeClFZp2t27dpaV2lURls20rEiUYMzGnneE/ExiYzd+4CYz/Hr/qr/txAIL4W4pSDirqXjOliOHR9vFz5JA4yhSl9LcaXdpxUfTFZB/tL3OZK/uk5dvERUIb7VMhySFII7sbk9KafgNHDkly/L4YloeBmh5pQqd36VCxUBSXczo5NpH0GtITcxrg1iFkqOmrWtJ5E/8WDy19nf/NTiZkNqPqjJd5qDcx+bLest3KgkmfSuv1p1XIUzwbCQcUU5P/j+J7vfuorqpV66C9OqkPIjTPeSF+7ynO/uv/5wev5S2N5Bi++8CgFQP+3Lvhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michael Roth <michael.roth@amd.com> writes:

>
> [...snip...]
>
>>  static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
>>  {
>> @@ -2635,6 +2625,8 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
>>  		return -EINVAL;
>>  	if (!PAGE_ALIGNED(attrs->address) || !PAGE_ALIGNED(attrs->size))
>>  		return -EINVAL;
>> +	if (attrs->error_offset)
>> +		return -EINVAL;
>>  	for (i = 0; i < ARRAY_SIZE(attrs->reserved); i++) {
>>  		if (attrs->reserved[i])
>>  			return -EINVAL;
>> @@ -4983,6 +4975,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>>  		return 1;
>>  	case KVM_CAP_GUEST_MEMFD_FLAGS:
>>  		return kvm_gmem_get_supported_flags(kvm);
>> +	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
>> +		if (vm_memory_attributes)
>> +			return 0;
>> +
>> +		return kvm_supported_mem_attributes(kvm);
>
> Based on the discussion from the PUCK call this morning,

Thanks for copying the discussion here, I'll start attending PUCK to
catch those discussions too :)

> it sounds like it
> would be a good idea to limit kvm_supported_mem_attributes() to only
> reporting KVM_MEMORY_ATTRIBUTE_PRIVATE if the underlying CoCo
> implementation has all the necessary enablement to support in-place
> conversion via guest_memfd. In the case of SNP, there is a
> documentation/parameter check in snp_launch_update() that needs to be
> relaxed in order for userspace to be able to pass in a NULL 'src'
> parameter (since, for in-place conversion, it would be initialized in place
> as shared memory prior to the call, since by the time kvm_gmem_poulate()
> it will have been set to private and therefore cannot be faulted in via
> GUP (and if it could, we'd be unecessarily copying the src back on top
> of itself since src/dst are the same).

Could this be a separate thing? If I'm understanding you correctly, it's
not strictly a requirement for snp_launch_update() to first support a
NULL 'src' parameter before this series lands.

Without this series, the startup procedure is to have memory set up in
non-guest_memfd shared memory, and then snp_launch_update()-ed into
guest_memfd private memory.

With this series, it is a little troublesome, but the startup procedure
can still set up memory in guest_memfd shared memory, then copy
everything out to some temporary memory, then set guest_memfd memory to
private, then snp_launch_update() the temporary memory into guest_memfd
private memory.

We would be unnecessarily copying the src (now in some temporary memory)
back onto itself. Can that be a separate patch series?

Btw, if snp_launch_update() is going to accept a NULL src parameter and
launch-update the src in-place:

+ Will userspace have to set that memory to private before calling launch
  update?
    + If yes, then would we need some other mode of conversion that is
      not ZERO and not quite PRESERVE (since PRESERVE is defined as that
      the guest will see what the host wrote post-encryption, but it
      sounds like launch update is doing the encryption)
+ Or should launch update be called when that memory is shared? Will
  launch update then also set that memory to private in guest_memfd?

>
> So maybe there should be an arch hook to check a whitelist of VM types
> that support KVM_MEMORY_ATTRIBUTE_PRIVATE when vm_memory_attributes=0,
> and if we decide to enable it for SNP as part of this series you could
> include the 1-2 patches needed there, or I could enable the SNP support
> separately as a small series and I guess that would then become a prereq
> for the SNP self-tests?
>
> Not sure if additional enablement is needed for TDX or not before
> KVM_MEMORY_ATTRIBUTE_PRIVATE would be advertised, but similar
> considerations there.
>
> -Mike
>
>>  #endif
>>  	default:
>>  		break;
>>
>> --
>> 2.53.0.1018.g2bb0e51243-goog
>>

