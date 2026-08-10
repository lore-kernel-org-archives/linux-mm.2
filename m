Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D5EC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 651986B008C; Mon, 10 Aug 2026 05:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DADF6B0093; Mon, 10 Aug 2026 05:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47BCB6B0095; Mon, 10 Aug 2026 05:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12A656B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:28:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 764F9A2872
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:28:03 +0000 (UTC)
X-FDA: 85084833246.30.5D62B64
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 794C8C0007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:28:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fQ7asZA9;
	spf=pass (imf22.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786354081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXrhNLOP0QWj8G05d1BynIra2SbBy/KkqEEevp0uEuI=;
	b=qMvNhdSibjkblUMy5E5iesAjuGgQ1yEkH0mVSl9r3KDYW4MvXZJVvl0mT/F3TxqqxaWPVI
	UctivJady4IirLbTN2G510EACYETmgd+yau4wHDwa5tUa44WTqOmsJ+v+lTiv+zb7ql4Oc
	zmNLaXfoQKooLuZRcPsTrUdXAuip5PE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786354081;
	b=BP8Eo6V1J6Ypjhwqi99P8EQPfa7LyNjhEItgdXK4Sbqi0UV8K/X9YYNcsRPruN4H6r0/PA
	SBGvMrWYOgZ4I+X9vziqywRWUSF3uIXxnnAOg3ER8q1gXE0eubDFk0/im7dsZztRdgye0Q
	t81gYe+Zv9v6qUJPjxUYVmiCLOEVd9s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fQ7asZA9;
	spf=pass (imf22.hostedemail.com: domain of suzuki.poulose@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=suzuki.poulose@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 52C4A14BF;
	Mon, 10 Aug 2026 02:27:56 -0700 (PDT)
Received: from [10.57.41.8] (unknown [10.57.41.8])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 61A663F632;
	Mon, 10 Aug 2026 02:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786354080; bh=qoA3XI8F3Cxg2eTG6eSEWkySa1FEqeP1PJP9e6aPetY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fQ7asZA9TSR7rlnnqyFO3tF9naXEDqkDPBAG48dXb9rvJJsp5voGcLR8/+ng8tsD1
	 ySkAhmHrgrqAdTfgQyMCw/7Qy0Uoc6JGZMxmsHW0nqrXYvU1rJ42hbzZdNXGdkjVMj
	 e+ACXCwdWeOFkiApz5x4o8ppB8Nedq0yuR5JI29M=
Message-ID: <cbf5f7ca-a960-4fb8-a760-2d2794eb6864@arm.com>
Date: Mon, 10 Aug 2026 10:27:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 09/41] KVM: guest_memfd: Filter both shared and
 private when invalidating
Content-Language: en-GB
To: "David Hildenbrand (Arm)" <david@kernel.org>, ackerleytng@google.com,
 aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com,
 brauner@kernel.org, chao.p.peng@linux.intel.com, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
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
 linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-9-2fc18ee6d3ba@google.com>
 <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <13ca60c6-e154-4397-8092-09f861e90fe0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 794C8C0007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ochmj6w3o1s9meu7hepcopgjnwrucx76
X-HE-Tag: 1786354081-598140
X-HE-Meta: U2FsdGVkX18cNsgEdlIZQDTA0rdTw9jxSyfSdtJuKDrL9qDBpqmuzPoAS0Ku8eAPJDwgOvf1XlvlCdfqw8htwOT1IRDEwNCvshjubhdttW8ULE7GKv+SsomD8xke5W/MfTP3xY0X1poh3Gk7qObAIdGsfBN3+j3YIM/3xDJ/lD4dTrls2P3B46VCR0i4PCIeRl5vH6Qb+iMX85pDvUEjJrRB1zlTXu803axaquVdqAcnYVoh+Q8763NQCeQqxKWFZGjmi9iBanIYBBiuQMP6aWoOnEhXGfgI2n51ebksMHtVeu/hLh/iFbGoge54qm1Pk6l7793BE6nNePFjG/i0ej7LrPi921IkTtqnEwZj42/hhdkWd1b/SDsMF+ncwmBeBK4rxv2NLGiYxzHt2xEH64JriGCx6QqxmQbOM7n7VgDtu8mtOoa4NhpvOcGTztXoDncLnQt3J3Yo4c5OohTmhcZTYH+DV9aUN0l9cH1JfdgzG4zre4J1/CM6hGcxwmMilY4bdJ5H3iOhlQ/4oXyBkfRig8kqpCSRudhY4zljlnuCCTB3pQXdUCvY6OuwNs4ws06X2KiO7bM3flGBfmEUETi48dX6dSfsNs+OsGxfD0HEbYI4hHmrcd410E+vVXkp63oCz6+mvuX8MOM6fn3q5zHpjhctpAVo0Kzzi6NFflF2f100UW2cSDRfv58ahxv5kT55qe5ZdM9OHPDehIH8BjqwEk6ZqbSvqyNlYR1xu6ne0ts8ZCCAyUdZ3PneP81Y3nzR4e6HPp96C8HDUJstEFIBpuKkhJ63+Pp/PX0T7Ub2jJYWLhoEYq4aiZg7nFp2/CFHionq/BTsZkx5P9547es2vDr5K+9oInm/NTKBMBuIXldJgZw9WkAEFBkoA08YU7VHRyP/xP9w4pi5lbjtS2ZVEwwgFQSC/BrjPe1/arDAQRvwc82lZ1Lt84hpog4IUOwc2burOnAlGzQNwnR
 nNaGAPyk
 GhjhmrqhdZpn94mC9KvV8coIf5Yd59RqD03yaHuk+62AVWMNPyIWhIn77+u67cZNLZNCbwFxhJOjc7RST1XH6oeOB9C9yx2gUfV+B2da3Y5vYbDuJPy0vhKsiEqfqDxpD7g8kfK5x6VcoznwzbgKDDBW+bu2soICV2wSGYaStWzx6Pxheyd9+/Uv5PPH7zHL1qDN+Z4zgDv7QDPYiDADootqjDEGQnFeHlCEcd95aC0Lwkva7j/D7cLeN3FeLz6zG0BNcLVqNT5Hp5hEFrDF5lBSKWszo19KP/WcJjYZOxYC9cQv3AmiU//SLRN48lbhDEEzGqhNldL0KydTor7x5KG2Ws+wp8TCnuFrNkC5wOzBRMWpHPMrfS0RTQkbl48y7qg2O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/08/2026 10:06, David Hildenbrand (Arm) wrote:
> On 8/7/26 23:52, Ackerley Tng via B4 Relay wrote:
>> From: Ackerley Tng <ackerleytng@google.com>
>>
>> Before conversion, a guest_memfd could be either all shared, or all
> 
> You mean "in-place conversion support" ?

Not necessarily. This is supposed to be :

"At creation, ...

> 
>> private, configured at creation time using the INIT_SHARED flag. Hence,
>> when zapping pages from stage 2 page tables, guest_memfd can filter which
>> to zap based on the initial shared/private state.
>>
>> With conversion, guest_memfd tracks shared/private state on a per-page
> 
> Same here.
> 
>> level, so a range can contain both private and shared pages. Zap both
>> private and shared pages for simplicity.
>>
>> An alternative would be to iterate guest_memfd attributes and only zap both
>> if shared and private pages exist within the range. Setting both the shared
>> and private filters lets the zapping logic do that iteration instead.
> 
> I mean, we just want to zap anything that belongs to guest_memfd, independent of
> shared vs. private, really?
> 
> IOW, it's not about shared vs. private, but really about zapping anything that
> belongs to guest_memfd.

Correct. But we want to control what we "zap" (invalidate range) when we
do the "conversion". e.g., if some ranges are already private, we don't
want to zap those pages, as they might have some data "populated" by the
VMM. For more context:

https://lore.kernel.org/all/114e2488-97ed-4740-a8e8-1edd991f26c5@arm.com

Suzuki


> 
> So, couldn't there just be a KVM_FILTER_GMEM thingy instead?
> 
> But I didn't quite digest how these filters are used.
> 
> I can see that kvm_gfn_range_filter_to_root_types() does some magic to them, but
> I am not a KVM MMU expert to know what KVM_MIRROR_ROOTS would mean.
> 


