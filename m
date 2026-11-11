Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB219606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 02:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=LHeyEr6e
Received: by kanga.kvack.org (Postfix)
	id 006576B05B0; Tue, 10 Nov 2026 21:05:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1BF6B05B1; Tue, 10 Nov 2026 21:05:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D99CD6B05B2; Tue, 10 Nov 2026 21:05:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B39896B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:05:55 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43D2F401C4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:05:55 +0000 (UTC)
X-FDA: 85421197470.08.FFCF139
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7C6631C0007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:05:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LHeyEr6e;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794362753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lmv/70XmZ5QtKUV5v1eVzqkSiZ/xwdge4U+mRBx/gEw=;
	b=HJMqXkxzTNO/KYnh9CFK3YSlkDET3Bf89JBwXG5+8bzcFHPcGsHwHQ2FbLDn45Ya8qHbya
	ytJ/hdtalhV02SSsMqIcm15SBt5cXuY5VQ3PNGKBJJxNiI3/jlLGgeLWVXX2lvXRhLVSix
	vVToVCceGz5inUTbnM/nj/7WELX6kRE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794362753;
	b=Z3pMno0ru/TsqcCCtFdgzDPLM3WLmRTlXk25KQF5CQG7RIt1BrQt2HLFj2lqf2/cmxzSBm
	leSSRhKHEOXWSvXUup6S7QgZ2IbNHMUtPhzXUxUGXMu0k+pKfsWFPOuLNTmts9tRRAGUHU
	uc9n7P3dV2ojmmMxJUHJHrNEMl5tSaU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LHeyEr6e;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794362749; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Lmv/70XmZ5QtKUV5v1eVzqkSiZ/xwdge4U+mRBx/gEw=;
	b=LHeyEr6eErX/jtn6fQ8cO+PBrYRq4kmQGb62yBIk+U6s/vWR/6q0JRntSgqGsTgQ5AWwa/wFaWW/UB4ryb31oURi6A7kVDnVBN/UNuOJ0XRvtsIqd+7tQtseSi3IPtzPRz96x5h32/fzURKC7KxtrRVn0/ED/EqtVb2anCNdfao=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0XEXG5Nt_1794362745;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEXG5Nt_1794362745 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 10:05:47 +0800
Message-ID: <d5067ae5-ebc7-466e-abe4-ae205b8dda43@linux.alibaba.com>
Date: Wed, 11 Nov 2026 10:05:44 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>,
 Trevor Gross <tmgross@umich.edu>,
 Daniel Almeida <daniel.almeida@collabora.com>,
 Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot
 <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Uladzislau Rezki <urezki@gmail.com>,
 Zi Yan <ziy@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7C6631C0007
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: hwqg1pj5z9jrr1ouqczukjpinchgcipy
X-Rspam-User: 
X-HE-Tag: 1794362751-868873
X-HE-Meta: U2FsdGVkX1+At9Ew8H+Zz7tbQee9CHhYu2wMRm/oIkU+H+X7hEGBZ8MpLiQijzglHduoUn2e+vhozeW7tWdSSsD4s4lnYyizNCWPwdZ4jusNWmw7CruvghvYOYv+AYkm9sYmJYrf3yL/QfakUOjyWRjKb6btZCFRFIATEGUorTY4c4m8oWk8M7tVNmkkY1IVIqARdK7yEDRVl2eKKRdfxHR9NRNvy7WUChuX/fIK3ZjqusBK5QVnzPjbq9tHYVoOfHVhv56zuoh7yJmVI591wc8AT9gmAnqxb1sKccFwZuSAcgYRYso2CFCMf+PbpUnmUXv5wRQ6Y2nso+54mjJ+DSZcuXsP/LZHmanEosirpN9CoSLrlMjfWccFr8L3RzcNF4NOsVvGdTeOf5X97/nFl1satXRYougRlLno5ccaywykOMM2lYqZnCWRtXqUdIKKieRwVu4aCvGe4Nz/XWx252aonQJWg68Fja+Nm3PKSrqer7eto0PDTKx14UfxStcNwupt8SHU8EvbOAHnQ0Jjyg07xrUTpgZbAhy1kYdF9IpmmBX6SKp32Q/p2fz4hR3qR6qdCbJ+snniJj5cKrG8HkeCBhIxjA2tWOO3bc+N5lYcs+xhH8OfbxFf7QkhyYh6XXyK2cglLnri7W2M2QjRP4enAcOy7jkfqZSs2hzE3TXci488LNVwM2GyXYWXXIyU9msu/s/KaOyo6uH1+la/4H/2UyaBqxgHq7wH8DyCnMyNLTOwcnlZgWxp09NTRBNcXP5v4afsCTYdWrzco6IOXvDKDe2TNSZxGqa4ON0/U+L3ESqM6F2n+SKpmuuV961IFsS3d0ePiKWhTC8I4NShOo85i2FdT9nks03WA88YQ/eDW0Tu6O6+uLDWGWQwORF3uaBLdPVxfHBavwqwwNU6usunFaYET4YWqQhpDMxOoxfeoD0E5GjlOpWu18MPuiri43gsIdPzvmQ5ksIv0Vh
 uofba3Ig
 Z0iExEIsX8KpCtDzgLpGj0GPX6dLJ3u/vox21z1GVOnDK/D394hf6a21S/tUPVW6kxzn0EzG9djFV+o3f7o7C1d70TBThguXDOLLEP4Iv4tiiUSkuVYX0nI+1FlQPIr2WjsCojuK9f/Q7HDQltPsCry8s5/+1WIiaro8OwutZs85qbz4y1/2RaAOSL5ISjc0trnviL0aXFl9q2BVGyp8/eIOkcfpILB5apAzMlV+pyaYnA9STtEPkMWbRsA6BKivw5EXp2xu/OCGP6KKWza47wg9mO5RCL/zsKG2xxrLh7/Si/NzHzp2+ehmaIM/bNRg2nCFhw8xpQsXzv0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/10/26 8:03 PM, Lorenzo Stoakes (ARM) wrote:
> Given the current throughput in the kernel resulting from AI-generated
> series, I unfortunately lack the bandwidth to generally be able to offer
> review except in those areas I maintain.
> 
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
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Lorenzo Stoakes (ARM) (4):
>        MAINTAINERS: Remove myself from MM core reviewership
>        MAINTAINERS: Remove myself from MM misc, reclaim reviewership
>        MAINTAINERS: Remove myself from MM rust reviewerships
>        CREDITS: add entry for THP maintenance

Thank you for your excellent work.

Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>

