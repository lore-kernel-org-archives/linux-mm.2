Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F68DC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 14:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66ED16B0092; Fri, 25 Sep 2026 10:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61DFC6B0093; Fri, 25 Sep 2026 10:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8F06B0095; Fri, 25 Sep 2026 10:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18EEE6B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:03:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A9CEA683E
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:03:58 +0000 (UTC)
X-FDA: 85252453356.25.F7709ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id BAF06100009
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:03:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jVWp1HYs;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790345036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=moEJ5DD1kCJ2wQs0dyY2lmQMFAV3DitHCHfCeQeaslY=;
	b=xvk/U2T9CV0grPyza9GJ4sL3Erqz79IOngGbPL6MorDPSg4tuwECSDtF39vuWSKVNgsnXX
	u7PRBLpOqDbmp+vz8YMzujg9mU0lwliA9uFbidMHtGmqkT3jdeBqeNNdKYlyC8IZD9ctW4
	KoO1G4REtkcXRJ2LUIT+c+5yFvufWqU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790345036;
	b=v1bA9Yqdw35oHxULxvuRxsk6+ynAwn83jkKEQYkoEnVXV7cw4T7N8FWDm5OOCmhf5G1Y9l
	aTfxmvbPAIJ6cEzvkgvGZlXBnyMfOMrVQRGDio13bUMO/Ay+G8uAlClDH82mMT7JSQh377
	QuV31tZtJ9tWMpKwbH9iye3xhdoqLWQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jVWp1HYs;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE64A4394A;
	Fri, 25 Sep 2026 14:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41FF1F00899;
	Fri, 25 Sep 2026 14:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790345035;
	bh=moEJ5DD1kCJ2wQs0dyY2lmQMFAV3DitHCHfCeQeaslY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jVWp1HYskHLauwnYvlaUdGxmSJA0e4Ng6vPNyBJltu9Um+fny4d/P9Ar2HgcIM6I8
	 UEmr4uxjBX8GbrfIXH20gvdTaPzYS9l4DAph/19rnVtTHzbjg+uC5eKKMTcIWqUC2L
	 ljfZowz4e8o/1+42IEqak7WBI3tgVSrDeoJsvv/PSfuEML/oRcyFn8ZZYRKkpQEt57
	 U5jIUeXr8tVbGEQz8Qlc29zuO/TDS6ywutxvBmWZrd2qLj8IhzN3K8jJ3am+rS7SZV
	 q2l/Qk0abhXjp0zD1YTgHwCtuI0zt+RX8kRo00b1sGI47Z04YZP+jcAnNRVip5TAQk
	 pqOqj32xOf01A==
Message-ID: <52e41c9f-c91c-42f9-8238-f8c7ff3e8b21@kernel.org>
Date: Fri, 25 Sep 2026 16:03:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/44] guest_memfd: In-place conversion support
To: Ackerley Tng <ackerleytng@google.com>,
 Sean Christopherson <seanjc@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260910-gmem-inplace-conversion-v13-0-dd6fbf94f4e1@google.com>
 <179028368162.2007072.12117327378679658047.b4-ty@b4>
 <CAEvNRgFpMwduvHPGJ5fLoVPr_iGn=ELzY4AcMGHESC6CkMyeTw@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAEvNRgFpMwduvHPGJ5fLoVPr_iGn=ELzY4AcMGHESC6CkMyeTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BAF06100009
X-Stat-Signature: sqidzcho7yaszozb1cmmy84b3rsby5uw
X-HE-Tag: 1790345036-542987
X-HE-Meta: U2FsdGVkX19qJzyOvnG+YbArEE56XRohTBMStk3aGvtv+6c7IB+dr+3DMXBloYciqtX14j0n6Hiak4pzkicUn4JgK8xj9tuwW0tKZ4n5MWBlFukzGAX6481rThD2Jh63X0HqUKBuCY80gxcuNwEXnVND0/APeOfc/ZDQKPyApiQAZ5S163GvjKGqJUr8oP3e4QFrV3jzAE/eNbI6DlVRfcWgt7B+36g8Bao/dIrqvw9Dom5LDHaatAcs0r/6tqkU+pCttCEB/Lia43H95hi4AheNFFgGyTIAsl4s2IkJBJIbV9h2bExqVUi87NgCeV8okjHRLlpqMW0w5H7nm9o+gWiiRBvxS37KeY1h8mlYxhqARZEfwzJCvsDb5zRoZvaxqzQymCLEIuvZrCezvlFddWbHmEDVxdEG6PgmCfnABaHgnIGnusAGtMEWLEvfCfTyBbcPQ+UcnQXv2dxFY2gMOlfdQqnyM111R2AMvtjgdBNWKLSszThM3e8WY6bEKN0sU9JQQDl0oIQp+221UfWduSy1EmBOcv6rjy2oNx2a1zzNuUmc2IiJEfzu+k8isQD1Dd1J+LjU7jaRVKAWE2USZmcK4JeYNobNalhE28qgrdzWZ/oFcHNZcUgFAwiH6c+SXVfNwSsRXsD0c0p89kg4YVibJ5K98XEuRZXWPtp47HgkGh12d2VJpGQBPNS45UTVgV3j6YKAKaJpMsNXzpWyM1yb9dJVVd1F65XODcU1pkszI0XMzT+OmxLBLR0gBCQGTas7h4+J0/kZ67+C0nLWiulmcSmVjg8qHBUj4lpXEqRR6/ZJI0RHEg8dZc2Z6QyNDth7QU8NU0JO3+Jz4nReob/vcaPPw0M5X+qP1PbHAhYbG8jcYe1fhLCSDWinUV2+8c0oMQMdvzK1kRlndpmH1SCPkbj2tZBagN8zjIZIy3jzaDbdmRItxxPAm+1Y3GNPwFrCP7gQYJ6/pejYTgP
 KWh/D7ub
 mtpt+fwCY2YqvefLpvDtIDJJTocYHqadnfZjEuWNGKJmaJui/G90sfKj4JmH73DaTk2h75LVpHlZBYPMcIrfyjcpq9bveEr71q3M5wXipTF9Gin5XwaIGagffKV/4LLKuGGQn9bU0Q6uhHZyV1Pg9Z9FE2OQGi3bWhduJ2oiZ37joohwDGTNgp6sSxvuc1nQXbaZIZQXT9eSKAd3TOhp+cKBxDxI7GxgcNXJ4KjtUEzjIAMRHNYb+syJWQvuIz37XWVROdqcQ/nVil6YBlB2AjL74t5SmNBv5oR17iQ0JWVpnxOFke3KnTdZx+oiMUz8usq2hyXjqiodS9ns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 00:31, Ackerley Tng wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
>> On Thu, 10 Sep 2026 16:55:26 -0700, Ackerley Tng wrote:
>>> Here's v13. Thanks everyone for the comments and fast responses!
>>> We're now at ~3 weeks to soft-close at 7.3-rc5.
>>>
>>> v13 is based on 7.3-rc2 and:
>>>
>>> + Hugh's patch to export lru_cache_drain_for_folio()
>>> + Another series [1], which makes kvm_gmem_get_pfn() NOT return a
>>>   refcounted page to KVM.
>>>
>>> [...]
>>
>> Applied to kvm-x86 coco.  A *huge* thanks to everyone who helped with this!
>>
> 
> Thank you so much everyone!

Nice, a big milestone!

Well, let's cross fingers that it will end up upstream! ;)

-- 
Cheers,

David

