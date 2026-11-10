Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE883606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=sgOUj6jQ
Received: by kanga.kvack.org (Postfix)
	id DAD486B05B3; Tue, 10 Nov 2026 13:54:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84956B05B4; Tue, 10 Nov 2026 13:54:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D8A6B05B5; Tue, 10 Nov 2026 13:54:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4D3A6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:54:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4211FA87D0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:54:35 +0000 (UTC)
X-FDA: 85420110510.09.FC3BF15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 787FA1C000D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:54:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sgOUj6jQ;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794336873;
	b=HMvtCflEfSln2fDBQ9o1KcMm2PQpX48e5dRM8STFhM67nmCgzwYwnZ9zy2qpK81Q06ifgV
	mI47lNlwnoH/hem3h0iwsoyA2DoL/r6iH+FcnLfIzBNeyT01JL1JhZiC1Sk4qDkou1mvGt
	qzpy6/gp9nEFnIlmr5uAM8qqhKeCOgg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sgOUj6jQ;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794336873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8WybN0jXEvfuCjeNoU/0kdSxu89Svl0EaLSggB3TsY=;
	b=qxkC6cQJ2m6lqFUI8UHwoxiIIp2seV3SHiLZdPj1iC/RZLibKMCGLZhWufJrJzpcMOy7oI
	RdhIyfBV/sU93JqguW2XuybnIbxcOj/VY9875TjXrfDbwVg4XBnMydPWD+L8cevCcokOFO
	o8rujTU35rg6xuG7eliheFagP2t1Kwk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A773063B26;
	Tue, 10 Nov 2026 18:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492831F008A2;
	Tue, 10 Nov 2026 18:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794336872;
	bh=S8WybN0jXEvfuCjeNoU/0kdSxu89Svl0EaLSggB3TsY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=sgOUj6jQ+prHKEVm07+3Sq1KThuQ51hD224Xh9LVBf0qlfg+StxnR4qb4izGEjFO2
	 oO2PUINbgjgpADfix5rc/mWDWUxEBhV6VH/sgVcRmwyi3Q3cTK5rbe3M0VXcElYqWi
	 zRvEScLVPmhHPWIOtzlB/E/ercg3AP6LaXazHuJg=
Date: Tue, 10 Nov 2026 10:54:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?ISO-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>, Tamir
 Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?ISO-8859-1?Q?=D6zkan?= <work@onurozkan.dev>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng
 <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Uladzislau
 Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
Message-Id: <20261110105430.54c7a914e163250222151d69@linux-foundation.org>
In-Reply-To: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: w7giephrbzjkutzyku1ufp5161mmje69
X-Rspamd-Queue-Id: 787FA1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794336873-995533
X-HE-Meta: U2FsdGVkX18wXahv9MQlePnlFfIR3nnTNtneJsMlr1Y6SzIaHVyBVdIgO7XM0icHLk4X7NsWQZkxYD+SCM/i4Wt4CvppRMdHh5p7E8w9PqgDcUBD69uFxW1jSWieI89F5taaca8+/CLpm9kniUoIbi3v39sPtsTSmmlKsxvEy1mERepB6/SCde9MkY7vGlqdTN2NIy/9acL/qd6uwCb7/5XcszfukyfYa+xT1KfIAB9UmbOWNaGh1SWADNonIWVg+R/qSDxE6ksYRrrycVXQ4DwrD3p5Hgd7mG3jrcRzAlDRUnk9TsuhBSCOEtMy4ubnNRyDhMOXuYh21Jp9R2sFzh1svMqc6MRzssSn9TT16aWu9e/LrtbjvwonNx7ExgNllPd7HRG1bAtGLS7TJkPsbDzk9iTTwS2INJe57jjZeiQb7X59kuUH1IsDbcAnaItCM7NBLx8KxUJHpeSIKIHkzy3CvXVg2FuGclEZeQ3vnfZijqxUtvNdJtEFjswXFrLN/+vOozPDlrLEbFpzorBVupehv8mLJfMgnFCvm3djmX2XzSaHdBBUqNGcftXtSLwlPArs0d6XXsKA88y2yuqhkITww/wDFAeoJ4Dgmxc2bCSz64YvBVqGmp0wtLDvzjQthGiefBEg6q8CYAig9Jmt43qPQhUzyHJEXcfPDW9afBVl0Wec28dZyzI2r3PbLPk7bUX+YuJtezaSRbW/YtlRU5ASXa1al+tZURzCprDH8GXTJOuqHeaDOxm0I0rAz0UllKZ4mHkvSGqSli968pyxGOtMx3dHRcdC3fPRvM+sorDb3x5AC3E8C/FfMW/KN1Pcq6beR3aeo96h5VoKJfeD6Kxpe/h8Irr/kz44rQl5H61HJqa74osRXt+5GJH493T2CcyHPb11d7JwqR5JLVXncCY/WUK4M8QD6vHS6jrc3QNsQElWc+pdhHlIuz8FZWaN5PTlNyKKkzoc3sjmBop
 ptewK8lF
 ZaKE5I0YBdJgdWPSoCAZ96KiVohjnROdv6x6oX6hrFCfLs4msdMyPInn6KTa81lMYKRSODVj+vjRbao2lbvFLErorkyZiQS7nqD4ghJB3JNglmQ44bRpPXar4QWuY9MdQf3LLuKGCNGsRGmGCl6MqY09ic5J+4bf/eXzsFY2eI2EUO//kH++2b6jfrB3BBWgz9liJR8FgFO1zkMWtyp3oakj8vKSxq64OWbgMxmaADC3aSYM4MfVLatc1Y25a/jW+lHEdIbFU604haCOmo5jjDriVrOjk/GeHqf5OnPOMC0BOMcD+dJyU8jhGy3FvY/T4L32FaG/GyblyVNU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 12:03:06 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Given the current throughput in the kernel resulting from AI-generated
> series, I unfortunately lack the bandwidth to generally be able to offer
> review except in those areas I maintain.

Sigh.  Is

	Nacked-by: Andrew Morton <akpm@linux-foundation.org>

allowed?

Thanks, hang in there.


