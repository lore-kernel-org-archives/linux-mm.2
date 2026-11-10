Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E82560A260D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oA7y27wc
Received: by kanga.kvack.org (Postfix)
	id A42426B00EF; Tue, 10 Nov 2026 09:15:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19B76B05B8; Tue, 10 Nov 2026 09:15:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922C46B05BA; Tue, 10 Nov 2026 09:15:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B69D6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:15:54 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67D08C08AE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:15:53 +0000 (UTC)
X-FDA: 85419408186.30.C600548
Received: from mta1.migadu.com (out-104.mta1.migadu.com [95.215.58.104])
	by imf11.hostedemail.com (Postfix) with ESMTP id 07AB840013
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:15:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oA7y27wc;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.104 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794320151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ds7kNgZUPfXWm6W3cqj/9lr9L7V5tdvs1wli0L1Uyho=;
	b=Jcf8mnJR446uU8ix7zJs4Wo0l7CTBP/F2gyXJwKAS6BBQQN4cl+u1J668G7segKNWGMToN
	CVI3K3EaZJsf9JHXCd8GWcudjdEflSKw5eXRAsWgFGKKWyoTJlsL1WFh1MzCLEEsiOTtws
	hKSh2Q2XUG9vBOHVvLMfPiSWM3HzwcI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794320151;
	b=bHNWy0iayCmMIxlfWpGkVDE/gxXVi0pXqemMHC0TXAmMDbbOjyNh1YX9TlEiBCeJ7kY/xR
	T4woMLJGdAI8wpNBu8B7tDaT31LXu35QwaGTwEo3XZ0lYfiGQVm/l3m9q9RIoX92BeaWgP
	KC+nYeW+PteDCQyBpylelpVW8ZGy+j4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oA7y27wc;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.104 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nbIdV6Ekrwky+WTmgp4OyxXE9Kai2xeE0z34n5bAiq4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794320149; v=1; x=1794924949;
 b=oA7y27wcHOORrMchFx1gImknWxCyRBj4zZOzjxhpduQBTjb9Y8dCA3MSvBMq4+0s57v/3jnZ
 qIp76t1EzxXvxr3G7ov2JoE3oEnfVmLgeA3gPJLODOh2jMo5S4QOGMm2qDjFr53Logq2MWvLRKG
 ALCbDYbHOLwbfqWXONSMqu9g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3f650de13b867266;
	Tue, 10 Nov 2026 14:15:49 +0000
X-Mizu-Trace-ID: 3f650de13b867266
X-Migadu-Flow: FLOW_OUT
Message-ID: <323e1f32-4127-4121-a1d1-3a7e43ca5ce6@linux.dev>
Date: Tue, 10 Nov 2026 22:15:27 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Miguel Ojeda <ojeda@kernel.org>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>,
 Suren Baghdasaryan <surenb@google.com>, Danilo Krummrich <dakr@kernel.org>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Tamir Duberstein <tamird@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, Daniel Almeida
 <daniel.almeida@collabora.com>, Andreas Hindborg <a.hindborg@kernel.org>,
 Benno Lossin <lossin@kernel.org>
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 07AB840013
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 19qqwtzswh675hkpgn5n1izu813m395o
X-Rspam-User: 
X-HE-Tag: 1794320150-926884
X-HE-Meta: U2FsdGVkX1+VKwRyYbzoXsfUrv+RqqG47kOP5aj4eNxF9LWQ4wO+QfacmxnsVC+YbZWNSKTqsvlqtQUHhlo+2j9OBAD/oZ/es2Ucw1DbmO6/N5m5WTVv1Ql9jcV9aVbHMcOUU2gFhPVv6wI61BmuqhrDv7Hw85m3o06xRdZByF3fuQd74avI6+RTNS6vIHVMZK35uFg9ek9DW/CFyZjp0tzbzGfQ5YrPft3XmgnnLaRCDHLuBx8gZL1KG1W4XOI/pF3rG/QkKDwvOi7KaFjyhtMCgFp/KE1WjHvucPDvY5wG+Ifr++M10t7K0cpDIomHPOXGpwlhm6PuLQhNCEVuxOmIk29pPJaiB/1kKZsdOkRUCsKa+3x8w/KChlzSMeUZUAYnhGjimYYfZKs8HeY4r/FSt+q86ngbZoQxew1j4LH+tZw1f5stEzdgcHfJpec+TmxQCjhtza5plORzA6Z2Ac+5uzNNI2LEhIERqP9nqAOg+9pxBY9HRsB2MdEgbtI2sFm/PFgh8xar+6no/enSXq6+YDr2kqHcizOmiRX6VHUmpb7sfNF5eYERp2Q9SpD+m7IVjkXZXK8YdB5DEydh5Hu63O1WMctYPGF+UuWkEk1SLRI+IV5MqhBdUhojIl54fKDSgcKKrcIwpoCp62eHzsjbJ0kxzeMS2bZhYGWssahUNsfo82P82lCJ4OARnTtUorN7fzQ+edgMKQAgr+aQV6+4pnAi72l1TAqTIoX3AQDZbEDz883Tv2gtczE/NdXxeuqRmIJfQBgLrAvjVcZMNMBFrHXGBeKKRm1GTt4TIltTI0Mxj2EsavZLf6wgnHrJszp4CxkdkoFAj+ab7bct5IQAPOMFCoVCLmwrUhn5sdEQaezNDJSZMx09/MHc6WXwYr5W1kmT9VKQ7DTOrq72vcdBnJuuMAJrE93r5wbsUtqkB6MwqUavQEn/rkxiZgox1+v038sT3VLcdxleYI0
 GuECgM5N
 Gb7gVouISSsmX6A2XCpOTGWzAORQMF3XwM4kQbkUbwni59f1i2cD3tRCWeXMhYLMDwRVr8sg7X7QG5UJMRQJNeceeZ/JpD9PNfsvvv6tzNh25FvIbBu59sUofrm+SO51ztNqfeZGdDbixjSFnpeZ+4UDGN9deDABZpeMh5f8rlIKtaEmTJ9XzOL2OWnNBczjPM1sMyL0LY8E9q8wr77WUpMplwB7j+uufKveMT8mdkVNjDA15wbQpFOs4Vmp6Ai2DKS+jMLzuaIPvTkgKivRXPc5kAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/10 20:03, Lorenzo Stoakes (ARM) wrote:
> Given the current throughput in the kernel resulting from AI-generated
> series, I unfortunately lack the bandwidth to generally be able to offer
> review except in those areas I maintain.

yep, with the AI flood these days, inbox zero just isn't happening :(

> I have separated the patches into areas maintained by David, Andrew, and
> Alice + Danilo, so each can take the patches relevant to the subsystems,
> for convenience.
> 
> Apologies for doing this, but given the current trends I'd like to do
> something to make my inbox a little more manageable :)
> 
> Also add a CREDITS entry for THP, as, since Zi's rightful and well-earned
> appointment as co-maintainer there, I have no fear of needing to step in
> there, and so would like to record my time in that role.

Thanks, for real, you've done a ton for THP, and it shows :D

Acked-by: Lance Yang <lance.yang@linux.dev>

