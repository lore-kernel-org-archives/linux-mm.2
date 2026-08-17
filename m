Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A63C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 09:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37D246B0929; Mon, 17 Aug 2026 05:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354346B092B; Mon, 17 Aug 2026 05:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A076B092C; Mon, 17 Aug 2026 05:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E17556B0929
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:15:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7AB8A160676
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:15:44 +0000 (UTC)
X-FDA: 85110203808.10.715A44F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 943041C0005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:15:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X2wo0EqG;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786958142;
	b=BUSmwGsOEcPZstckV+C5aBD/F2Z2VmqDJ+Vu/G4alzQEsyth0wITKNnPI3trkBQ7Lqf6bS
	I0mGsr0jrckWOwFt2oP/FC7IgGdPO9dW8A6d9ZRnvTIC6uqmDt7qrF2jFeQFSnDSdfvU/c
	wVWi8lbtYF/OarzWutaxU3r+I3QK8Q0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X2wo0EqG;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786958142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9jm7nE+72OxJlRILZ3KDGXzGVb6MqFq8JwjpfeAmYE=;
	b=dwAyl8QveibI2AHpPNA+AoNjbTrzsfEAurgQXsrns/fiiokDByP7s4cZST7O5/50kbeZc5
	qehbKcHzTxJJXiY/qDt84KPWqATait3prOA8mzY4Li/iXRqGR4WDZFNcWdW0apx5AzGnRb
	M/DOGADABvww94zdvWHeO7gzdQtwzgU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC40F41AB0;
	Mon, 17 Aug 2026 09:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BA61F000E9;
	Mon, 17 Aug 2026 09:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786958141;
	bh=n9jm7nE+72OxJlRILZ3KDGXzGVb6MqFq8JwjpfeAmYE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=X2wo0EqGs5RjqnGB89rtFjzKK8w0JntqVFiM2OgPKQ2PRuF5REQNaZuYkKDJkhrhY
	 I70NB75bFxsNlA+4hqOyNxYB9XKiHs3fi3hVBt7YIkVdjqu0+wYxWFySzi2gTETqGX
	 2qwjV8ylR/zdA0b/kyqwBVDEhcJZzSUsSEGH6sbmNepbEzv6q5/0sqrYcXzy62pJaz
	 LGOVRJJmZx6aWyUbZupzgRfsr4pmEc8oy2D9nafip5whrbjOXhNNtTxgL1/yI9mQCB
	 0fOS/CNfCgB1n2fn/gOmN5OkrI7sfW5VtwPY8SFbUS4AoZqKl5OK8Ae4mduQLFG3y9
	 FAE9l3uICQSWA==
Message-ID: <18529aed-9bb9-4771-9799-ba35fa0c657a@kernel.org>
Date: Mon, 17 Aug 2026 11:15:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 20/41] KVM: Let userspace disable per-VM mem
 attributes, enable per-gmem attributes
To: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-20-2fc18ee6d3ba@google.com>
 <82ded1ea-e0f6-48d9-8bcb-38a6bc5e9176@kernel.org>
 <CAEvNRgHpy52iynKfXeEkyCixhhu0_Hnu5jSNT8i+BNxvEoG7Cg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgHpy52iynKfXeEkyCixhhu0_Hnu5jSNT8i+BNxvEoG7Cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 943041C0005
X-Stat-Signature: htt5mebo9f74bxa5qu1i848jthecpwnb
X-HE-Tag: 1786958142-204803
X-HE-Meta: U2FsdGVkX18HWW8rgK4E2WvfFrfuEPqEy2oEvWmHOqbt8d3ZEjdliH/K1LywfClsh96q1BmpspkfcAPUPmfwYhskyCYOXsMlqeEZBHsawSPG5lo9qABY5wauK+C5oIMiB6KzH1C3ayLi7+krQLEdEL0ftgSbGlVv02nupHgJvAm64N7s2Cqhz1CD57Zo4IYMeboO3Qq56ZU/wlzMf/rCerb2crWUNSJlMmmwfp8fZ7K9U+VL9J5gJwq3ks4Ye9mM3rzQyhDJg7s9blAnhiy5SBWU90Kpvycfgv5MX172LQHJBgq9QKm+XvPuVRgVbrLTE5LhAjje5t5lCWludaF2t1X/v6u71vIWUkCzLJdO7XssknNhKw4oFL0NQe6WlkyMxAMUx0f2h75RnWaWXT06cTANPG5hTDS6Q0syUkq9HyfS/D+m7twlOPWe3DpdabN1j0K1SR0E4b8rdubnG1XIBZHANGNr8N21GJho8gqmCK0gdaNQhjTiCxniqzyLw1Ie5PYWP8gQQfTGnJV1DPL709Ne2cnQIyYmJO1nmyxj6Gd2XTr+etJu51p9OAsHx8k/Kz5dJq4DqrJwX4OceZMj3XwgjSwr59Ec+4h8j36uK4CdobPWCeoW2zIYCMh17N5/iUeofr/LXo+MtruAAafl/hBPAWDkmyFGJabsaOAhUilhHHzmuWjV/LvQCo94sqO6QSbwHOUQPdW0HhiV/yu5PcWpaejCvxW3V8mtReDFmvJnmqhvy1GqHqtL3YjEdHxcSFxgl3eiOQhKubYt0PTJ/ynA8bJTB64nuBsAD2Be/qF2yLi/FGfxmWRXt6f+OdLF2wH4LhlHMMmCCcOM9FMRI8414p77sIsAUyOlP2lnBghXhOYP+4/ZHpgK61KeOHWuS6I80bUFu6ny+kVIr+eG35AM3zTyPgN60Bwa4ij1ueimQULIOBs86iP0w7fvbZGerVBByClZZugL6zTOTX0
 znz5BQc8
 VeD6JOVqHqiRxOO7vX9tSXXoZ2ce689yw+G1OXuVYAOR/Hb8jRrABGOUfwNYRaEwB/aUbKBZ5GD0X+2Rxw2LHVkBXfC0QM0Kjb59iqV6I5SbKon4gsVWP/s6GKtc3BmiVChOF7+1tUrHDnBVOgfDhsWmpYYoa6wic1BI/s82/sKFl0hssLkQ3AlRi7SvKMHNw3YdODcD5Vgfo+/2bUiNaOsy1cp826Nbppy4TToSPWoS+SU6eyKUPbdIPMBuALBYmQpxFWCz5cJ23tjUMbfzk5uuauNdEaHw7WKJ1PSgh3Pg9JQZcxKVhFxUGYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 23:23, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
>>> From: Ackerley Tng <ackerleytng@google.com>
>>>
>>>
>>> [...snip...]
>>>
>>> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
>>> index abb108886733a..2c3c22aeafa54 100644
>>> --- a/arch/x86/kvm/Kconfig
>>> +++ b/arch/x86/kvm/Kconfig
>>> @@ -81,13 +81,21 @@ config KVM_WERROR
>>>  	  If in doubt, say "N".
>>>
>>>  config KVM_VM_MEMORY_ATTRIBUTES
>>> -	bool
>>> +	bool "Enable per-VM PRIVATE vs. SHARED attributes (for CoCo VMs)"
>>> +	depends on KVM_SW_PROTECTED_VM || KVM_INTEL_TDX || KVM_AMD_SEV
>>> +	help
>>> +	  Enable support for tracking PRIVATE vs. SHARED memory using per-VM
>>> +	  memory attributes.  Using per-VM attributes is deprecated in favor of
>>> +	  tracking PRIVATE state in guest_memfd.  Select this if you need to run
>>> +	  CoCo VMs using a VMM that doesn't support guest_memfd memory
>>> +	  attributes.
>>> +
>>> +	  If unsure, say N.
>>
>> Hm, does that imply that a distribution that must support both, cannot ship a
>> single kernel?
>>
> 
> Did you mean this as a documentation comment? Should the above read:

No, I was trying to understand the impact :)

IIUC, a distribution that would have to support both would simply enable
CONFIG_KVM_VM_MEMORY_ATTRIBUTES, and the module parameter would have to be used
to select the mode of operation.

I guess that's good enough!

> 
> 	help
> 	  Enable support for tracking PRIVATE vs. SHARED memory using per-VM
> 	  memory attributes.  Using per-VM attributes is deprecated in favor of
> 	  tracking PRIVATE state in guest_memfd.  Select this if you need to run
> 	  CoCo VMs using a VMM that doesn't support guest_memfd memory
> -	  attributes.
> +	  attributes. Select this to defer selection of where PRIVATE vs. SHARED
> +	  attributes are tracked to KVM module load time, where
> +	  gmem_in_place_conversion can be specified as a module parameter.
> 
> 	  If unsure, say N.
> 
> I think we should do _without_ the above clarification since using VM
> memory attributes for shared/private status is intended to be
> deprecated.
> 
> Is it fair to say distributions should not support both, and if they
> _must_ support both, they need to read code to figure this out?

Yeah, I don't think we need a doc update.

-- 
Cheers,

David

