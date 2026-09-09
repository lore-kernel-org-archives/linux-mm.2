Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4C24C79FBF
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7826B009B; Wed,  9 Sep 2026 11:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87B66B009D; Wed,  9 Sep 2026 11:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50CB6B009E; Wed,  9 Sep 2026 11:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 921D76B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:54:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E11FF40259
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:54:40 +0000 (UTC)
X-FDA: 85194671520.06.1FD58F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1DDC716000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:54:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bo/nwc6d";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o582C2XKLMWHOHeMahz3iW/6hgf1cGSAiI6ze6eSDVo=;
	b=kXq21jUp62zjvSKZT5vHdRbEMlmzQ7MjH7rlHD0/OgWwRmimhpPXZ4Z1YsPAUpSA9Si73j
	5aOlMwidpw7cIAExFHS0PFzmQ7XHkkTsgzp7Ov+2FaBkhUXMmuawXe5nFl0OvBlmtXYFyA
	CvbDchJvtrYHPsiS4dlZCyURFBaoG8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969279;
	b=N1DLRzyAFHtAaf4J+0UnwzKpzt/vYkPSBjki5FI9x0k4ZdISFekp98mhQ4+x9m7dV1J5PG
	WGZ9XKL3Rjhx2WEEv+c5Rjnh9yoWNGirLei5Cb2OGEKqvld0APqWpsSeIyetBsNWFYw68z
	CXqqz9E0gFOlv8CZQHSLUKdX/yrE+5c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bo/nwc6d";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DC8F4391D;
	Wed,  9 Sep 2026 15:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE9E1F00A3A;
	Wed,  9 Sep 2026 15:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788969278;
	bh=o582C2XKLMWHOHeMahz3iW/6hgf1cGSAiI6ze6eSDVo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bo/nwc6dS99ISeSpfGwn+iPwXI9V9uwQ4onbV0KtT2I/oMD4xZ5Xgd6icDQxHE53D
	 1QHdm7AwvJw6FLfmN0QtUcnvlAQnsrS2d6N/8pJmkKUJ/XHHMKVJaSAgDG5IIXnzi7
	 sbV/X8VlO7038kF1MC9CnN+7QRmws3kfAtkYR/08G4TRQnrrHmbhkQsKrATTir9Hdv
	 6Jx8KDhSTrH7DWq9IU1lCWsur9ORkdIT8FIovsCuu53xEHAZbQINr7dQ4jBN480huT
	 X1ZNDPsTpIsDY3dJcV8Z7usILLGTfa24PnjkNL6g9aIUrKBbUO+RGYolago2/t5buD
	 1Di4Pnhtbw5bQ==
Message-ID: <b6b5e12a-c3aa-4e73-9fc0-d7200141e0e0@kernel.org>
Date: Wed, 9 Sep 2026 17:54:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 17/45] KVM: guest_memfd: Return early if range already
 has requested attributes
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
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
 Randy Dunlap <rdunlap@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260830-gmem-inplace-conversion-v12-0-85e5fd25252a@google.com>
 <20260830-gmem-inplace-conversion-v12-17-85e5fd25252a@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260830-gmem-inplace-conversion-v12-17-85e5fd25252a@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3mu7ic6kodtzsexnge4hk36b3f74e1px
X-Rspam-User: 
X-Rspamd-Queue-Id: 1DDC716000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1788969278-514067
X-HE-Meta: U2FsdGVkX19oAINDxqg+10oZwLWlBCtuUsA/VS7ykEj8guMgvIa0TZUROcxifzxBIY0N3mfh2miKm8fjna46J9pBg9jKKG9b3BqB3OSvMRRWP+OKsgUoPTGy0KJR9DJ8fLbeqbgYAPogT2QcdQA0LqlEZARncgRP8mrsAO8mM6mhzn+XwfqTjQlQbH9IDxWCL0S0iCjrLh5wnWZ0WCOrw+x7qfVwQXxsflej9wBLK4Li0CnbXbPrlo8PCYuMIHXqgZlYO6U+/wYFXLBwejHp2oW7SxL3BTC/s38IkI/z+p4+aLr21u/7hFm8RgBW2rs6QtjDRnDj/rpljNPbOwLSJX2WOkbTn9yJPYm80uGilfbOSUhjx8UD4oQRDVHXb73Nn7eWhQ7D3wI07bfHb+wj3Yxmmw0nItebZTKwIxVH4GO1PbejpYCd2aOwVs7vqCtramGRfqcgXtIjPyPL9wzKTh5YdGVra+/b3KsUaGxcEJQ/9wTjYniMnqnqTogEPMdfT7zcMkL7KI4mqBtTFBrix/WIWVhFoMFpoU4JOO46khdyrNLk+m7ueXdjkB13lpuOWaobUDkVT0UrAOcOM2ADef0E1pAf3K1z/RyDKJCnn6/YJCCmMvEICGZAYjqNHwmsrfhU1VeLAGBTTdUUpkg80ZLOgI5IpbvVPyMexFYRDpLmuXFz+uFEPEb8JAovoYF7aJObCZh8nJiFNix2M1vEF822GgvEsci2wN42O8S2t5v63mWhoBxb+W3q30qqazbV7BXcd4s93kr3lP+HKtAVpS9PJsAACZn9jqyc/ZYPdHgo28ErzkdMHnVS4bADgkgIMkNslgy13hsG43KdTaUvd/ebuDOM/nH6qmL0LOT1r6IpDzkkr4IncajF49CZ2l+5RA1YC+HkSKIvSyqBlWfiBWy1ZWwolR+FmFZE8uc/HeiV5Dgv2gw30Gcs98QXscJ+2ST7W5XUUV3JFJABR/w
 d7xsekIC
 rtTKC6WHa/fbYqyMdTYxe1qq68ZJoMLAohF5DqxB1y9YgZCfNLGoR/GZ6BP6TZQWnHTrDy500qvajvee1hhXDleRAZCNOF+lKWzsLK5aKIbKKtzhRQxCSSLk/0O56nQhISNYIbWmSxDydfVaS5LgbE5LV1y+eTo6Jb8FFrtsPXyWmnBqbMsOKS5SMLgjAsdSZQ398AdpSUQrzveWaYp1ASg5QbAFJMkCx9jZ9eFirgeobarU6CiShJW2I/58HDTF3rIOYhNAY19ywlxje44FU2zoBrNdWA2qYmpJc8ygzopbuyaEKIpcUcGUAFxSc71OdZ5bmoKgYDLHQM7eBBzBr3yGCdZUQpGVXVU1ZzJ9pIltaVl+TP/vSUyFczbF5DvAmWqgnF9r6pzY465WvXnY2sLUm0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 02:25, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Provide a function to check that a range has given attributes.
> 
> Optimize setting memory attributes by returning early if all pages in the
> requested range already have the requested attributes.
> 
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  virt/kvm/guest_memfd.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index d14a7024bdc7b..ac8e0c6d6e942 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -98,6 +98,24 @@ static bool kvm_gmem_is_shared_mem(struct inode *inode, pgoff_t index)
>  	return !kvm_gmem_is_private_mem(inode, index);
>  }
>  
> +static bool kvm_gmem_range_has_attributes(struct inode *inode,
> +					  pgoff_t index, size_t nr_pages,
> +					  u64 attributes)

"has_attributes" could be confused with "has any attributes", not "has exactly
these matching attributes and no others".

Anyhow, I'm out of puff for naming suggestions today and this gets the hob done
;) (kvm_gmem_range_has_matching_attributes is a bit mouthful)

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

