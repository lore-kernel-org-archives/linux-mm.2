Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF7DC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 08:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1C46B007B; Mon, 10 Aug 2026 04:15:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88F76B008A; Mon, 10 Aug 2026 04:15:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76716B0095; Mon, 10 Aug 2026 04:15:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 882B46B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:15:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E4E78160341
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:15:39 +0000 (UTC)
X-FDA: 85084650798.16.E008AD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3863A80005
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:15:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DBanxYJA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786349738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+Zgr0IR0+qdoeJYyafoaY4SMWyH81vw1JCyiRYTceY=;
	b=ceFEsMDdTtjHFzrA5YG/XT+LOGBt2AfV9PEpZP5dE/YNyxP8wvA31Qe1eXhLaCkaiN9sNo
	rXipTpcx1EB6QsJCC0YoWHAdJuH9Kt0mePPxqFCm9gDY/l0cNw5hxqnf6ry8kL8xTGFbLk
	Sq+ZPZ71H4mnOGv7eJmTnamvUUJbU3Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DBanxYJA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786349738;
	b=wRK+3YK0PDsP0XxorLBNw2KcB/eFtackOoHhJ8496b6HYQEYaP4OVmwKbS27lVgWjfTeMa
	crGXbDQ2hN+V+Jo1gvRHl9Pv47DfH4oZNAtsb2Jr3YkLIFd99OumwCG30rDHucGvOVRgM3
	IsKJIY3Wr/+Ic2y3sQQFyGMAPmkEhVo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1878600AB;
	Mon, 10 Aug 2026 08:15:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9931F000E9;
	Mon, 10 Aug 2026 08:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786349737;
	bh=r+Zgr0IR0+qdoeJYyafoaY4SMWyH81vw1JCyiRYTceY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DBanxYJA7lovar94EsiwPth3eNumrx9nWGHwUz4ZFay3VZX83X6uRaiihbaPt1/Pe
	 dGim3yzhdWb2H/rg6R3uVY4LfD4xTpBdOdSYPhaK9lZ/ySfYK/O2Tt/DpUzo3aNRRc
	 eF1B8JSgeegXFwuMDjfLPzaKewDfRo43ytRr+xRiAqS3vyQ8uYN8bsaidcdfa7qMP2
	 PkCGe6OJ5VwpAb66t9vC+AXD9jF3OQxJrOmL2JqKXc2d+z8+RMGGETTH9VsZDzaGgi
	 mi+I/pQUZciW8dZTql7nU/gkwcT/19C9c0Y76e3e4cH+lGBJNId1PCr7XiJmJ4amaC
	 /jWic+PreoCOQ==
Message-ID: <091debe7-d740-4652-885a-1f22e8006ce7@kernel.org>
Date: Mon, 10 Aug 2026 10:15:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/41] KVM: Provide generic interface for checking
 memory private/shared status
To: ackerleytng@google.com, aik@amd.com, andrew.jones@linux.dev,
 binbin.wu@linux.intel.com, brauner@kernel.org, chao.p.peng@linux.intel.com,
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com,
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com,
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com,
 steven.price@arm.com, tabba@google.com, willy@infradead.org,
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com,
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org,
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
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
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev, Xiaoyao Li <xiaoyao.li@intel.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-5-35f9aec2aed2@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260728-gmem-inplace-conversion-v9-5-35f9aec2aed2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: dqg9zgo13hocnztx4b18ot3ii9xmr5uk
X-Rspamd-Queue-Id: 3863A80005
X-HE-Tag: 1786349738-532212
X-HE-Meta: U2FsdGVkX1+0kshs6iHvSPbhUxukO3VB8n6ZGsViCQ18vCzYqqYdoXoDYrdb6prLb7GNjNUsAY1GXf0qx7IWqnPH17Ipzeo1VQ7lVwVE6sc4tSnY3tQIGTvwMkLOPWQUjze6r3q/dZA/28UPyv3mE0ysxrsXuiy6DmuGPHqcAOfWhKzZ3XAtch37oXRKuWxqAuxn2pEb9k32V3gvxZSSXiBx03YQahX9rCSezOS51ODJfjw/0TNq04I28gZxmiZTRgG/LbekFOL/2/sp3Ypbmvx7WymPVUJ9sqyn+P5eEHL3Lz5dQCnJwd6a0y4B24hj3O1/kZy7gQIfmGXKKBMSIdDlR6CZfvEsWH8gxjvnGSHj1tYHvw5gIGaHSoz78znvepilNxac+buVUNUL6HEXjQubhtbNCoe1lU8f4sjpP+tuU2+oQB/XsCrT+Y7yGEjJOVbxbc9FQddhiPsl4Jm1UFZDTlGZ74UpIFTq23u0jVRBxDv7SOpwjhvPw1C6OR7GH0twwNXUVU8mDeDg2A10sx0hVa8RKb2LpfL+FEsKb6UsqFC1eG8WvmI4CQcjeZATokQxwpJyUTptmHTFBMwyQjFGyQMWhNA/R70Kc6Bh9WDDr7cj7hmomPIM6hfNzTJQVypcbNiHNbDvHSs/6J6yKNWCY+KMW2bG0Nl9BSFeKRcERGq94IlHnbbg6wZyOhrC8IXKyjaIxuh7E2CnRu/i5QekUMZJKyRbpi+hJb+crdte8QurjBk+TQGTlC5jCN3pE83LUoZMfqBvCOwyhO76jfkZKVA3MRf02viGQBSsOpb4drlHsFsLEttyx0B+rrwAOkMIi7YArRfZG9alivWjup1exr2o7b+NhfkvcpLce/FGvWee0/L/ZOYCcdktAPloU77+Q1GoMOSVNmNxilJBf6JWH/nWROUkgYOpZPFX7hJF9E4wSQrWzQbmoTzgStVf/e1giG6ELlF0vU1JTuR
 IQLl3NCG
 b0kRC96+2t9tAHEvb14FtNX0G/NtzF8NQ8ZgJ8u9ZsSBYhZynSAk5aj5sCFDX2vTJrHbTCHe4EdRWwtcALE9yze5JUzybkc7AcP8Zr/MkVAq8jlLAA4gKq5uZRLMJIuIhOg0XB/cflge2jYvRm/NFpZCxSAbx6uUBK00c+o4MEuL+YGd5P0HPRFVhtsa5N2h3K2vjvUHySXpwCqJHNVyMPm58uWx/CqVFtyIyoJioTV+voRJw8sueq3rFMCvARrEn2zhcsXlRMFU4ws4tkF7a7tBUDXEHdEB5dND2BJNftSuDnOck2EO9+wZ/aoapVBJpbBJuwPC6MMlsaapoYDkJTz2xxg7Do8ZmCjYNgRtk8X7F6R6CB7hMZTNOIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 02:35, Ackerley Tng via B4 Relay wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Introduce a generic kvm_mem_is_private() interface using a static call to
> determine if a GFN is private. This allows the implementation for checking
> a GFN's private/shared status to be set at runtime.
> 
> In preparation for choosing implementations between a guest_memfd lookup
> and the existing VM attribute lookup, rename the existing
> VM-attribute-based check to kvm_vm_mem_is_private to emphasize that it
> looks up VM attributes.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Fuad Tabba <tabba@google.com>
> Tested-by: Shivank Garg <shivankg@amd.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

