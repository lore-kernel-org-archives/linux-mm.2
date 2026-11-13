Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12325606A33D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 20:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EfCt/jkE
Received: by kanga.kvack.org (Postfix)
	id 01C8C6B05B2; Fri, 13 Nov 2026 15:59:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F10916B05B3; Fri, 13 Nov 2026 15:59:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4CE46B05B8; Fri, 13 Nov 2026 15:59:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD9146B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:59:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E781801F1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:59:51 +0000 (UTC)
X-FDA: 85431312582.18.2F38C12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id AABAB140005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 20:59:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EfCt/jkE";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794603589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVxBLZX6lQzckB6AIbX2pQJru5dIfjw9YVDcZIdu890=;
	b=uRb7w/HAly8sFNN0ppMDkwT4YyTCw/hZm/P7o6FEXj2HHOOM++jb/VWNy+9r+SL/7JUUiJ
	D7Ntetj+/srrDS60XmaT9MaIyXK50CW/y8f+flamNTL5Lg8pNiQ1Fopqbqp7qPVj5Keema
	0ZeQAzmUl86uTdgMSxOughFPRn55eKU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794603589;
	b=XZbKgQG7Mf3sL/AJKVN+uIIrjtZsjBHNIVQ6yhW2kz4GH1YvyhRvHe2w1ahf7DagrMxX9J
	MF7OQoN0KdyscQoSkudNz4Y4fKA8MAKka/QTkq8wC8VDJUEnauq2TV4JeGpKCQ7Z41P7+t
	XyDCgsAZwdVjDomx+h6qHyDHfl72ebc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EfCt/jkE";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9465A448B2;
	Fri, 13 Nov 2026 20:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F951F000C5;
	Fri, 13 Nov 2026 20:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794603588;
	bh=gVxBLZX6lQzckB6AIbX2pQJru5dIfjw9YVDcZIdu890=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EfCt/jkEInFzOANdOTJJt6IXsNytJX76wHVHRjNrF88Xjw3qp6MqJvxVq0PDoGQid
	 HqvdYMbEdN2obhqGDYDFJojlub4fnNPZJ9U6j8sGvuMtgJAcJYJFKs2Qz44cw4RLcI
	 o3RbslRdMuWZOtId3qgp6zZyQESV4Se91+5ZGEBshlKorXhB8sG6T+/l44w7rZME58
	 0e/97s29kipqBUVU+icJTEC19aN6eGp44UBq0S/kxYuXWjwxzXQZldSIhlPYj5G+y0
	 oV0hi0WdohvhJftm39HJNM/uH2AUVFNv4JQ/P5qHhRkj/03UVRKTtC7bn/zMsPkp2q
	 MRBAcCm7m0NGg==
Date: Fri, 13 Nov 2026 20:59:41 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org, seanjc@google.com, 
	pbonzini@redhat.com, akpm@linux-foundation.org, david@kernel.org, peterx@redhat.com, 
	imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Subject: Re: [PATCH v3 0/9] KVM: don't zap secondary MMU on permission upgrade
Message-ID: <avd4MOhiTCw0I_e1@gremlin>
References: <20261112142039.907090-2-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112142039.907090-2-clopez@suse.de>
X-Rspamd-Server: rspam06
X-Stat-Signature: 1qtsg4rgn54s3tbx9rdfdr5pzcd3negh
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AABAB140005
X-Rspam-User: 
X-HE-Tag: 1794603589-494952
X-HE-Meta: U2FsdGVkX19oIRxgajfJZqxrd4/CjkdGFmmVrEqA/XqAeKKAeqAOrvw0/hfkFHyc7wqVslXYV0wGgSRiYZvsS1raEWoMWfkzOwCeFA65XKWZCB8hDUC5rQaxB8Rj1l8LLTY65AgJeo0xJX++hPyuMNCQuUibeLnXNvcYt6dr4PU3jIsJ8FexQYXANFuYye+Y974/f0zr6sD42MXg+QjufODwNHAeIdtju6d4oMBEaRd+NDxfqJXYMFBrQsjEigqlLs1z/WSV+yNFtYYOweUERSBv/zQGoHmjzoh9UIsD6h30IsKr9vcB0MyILAmM3fI4GT4YsL3+F0IHBxPe5hAOa6I9PGgJ1XEQqOXUabW5Mqn0ENCiTAV74/PlfjxFJ7xfNm684zrErxeR4yBF4b/Iii7jtB7mKPSZXLjQphst9JGR9O5rXeigH+oVgs+x8uDvZLA+OHnz6Bu7QXjantPcs4wOvys8s9SKgc4rVzzE2Is9Cr9tx0Oe7AhkEjet8cHaaHku20vuU70PyrErI92jwi0M5UbVJ2Gg4D3ssQcOvyXt5YkmBhOcfX01UeVpf8cRaipAJIaXyitRS34DeWLfJ0cW0rAFSBlpq01w8UNpK50Keti4l/yVvh1Ba9sF5geKqh92XMaoAKN7br9yBkrhX4WuVWvGpATboTauD5QpQpPR0crus3Faj8ur3/ROhrzo34lJYbPHADB2YSpzxb2YQ+sqr3w/S5xQfLF3KGAYHhoChHl/G+y+cBaRF5vOTZLzwHAvSJEF+1WJGzj3cR8EC7jaCyi2VvRKOrAWxYr50n9gsKJ46a3IHca2zs4Hol1TuIgCdsd782QBgakTPvepoE1/7kmDGxPLpoDmmv1ieHi3Lc7YSbDR+qHwEjum7jObzTLUVr9eHDMroyMD3K26Ao3PKNcRTT2kjzQqw4Ld63E49GTJZBTRQPb0ni7od+Xzsats3nKiCtSJYUSk0cG
 r5XQ5XCe
 +XiQnXf6RxvOl3tzmvLojfsUSGu4HoZ8mx9LtaCu8HpY7r71pczrI+RnnzPUfD2AFYcVbv0/3BrnM6jLi0JYOHW5Bv2YJ9VHZjtprwUQK4XPCID+vv9WeWplU0VE5PVfYkLE3AQzN/46ku/wrd/z+9rhEWe3X/65BE2uKGjs87OKPZtHqbyT6dfsDR5Sd+j6VVUHGnCn+3NKUzbBbatBwOZGFt5R9/xUwLov54tdUyVvS5Zs/9anvKXK3g6YzuVxQCNFhOKB6pMR3tZqUhmDJCWnFfRWBbBJrF9XPz2GzCrQetOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Sorry but as I said to David I really question what you're doing with this
series on the mm side, and I wonder whether we should even consider it for
this cycle, frankly, given [0].

And, myself being the fool who is engaged in the Sisyphean task of
converting VMA flags everywhere, you can imagine my delight when I saw that
you (seemingly quite knowingly!) chose to abuse that API, writing code that
I'll personally have to rewrite later.

Don't do that please :)

Please also do not keep respinning based on sashiko feedback. FIRST get a
clear understanding of what maintainers want.

Sashiko is a bug finder, not a reviewer.

And see [1]:

"Wait for a minimum of one week before resubmitting or pinging reviewers -
possibly longer during busy times like merge windows."

Please only respin once a week at the minimum.

--
Cheers, Lorenzo

[0]: https://lore.kernel.org/linux-mm/a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org/
[1]:https://docs.kernel.org/process/submitting-patches.html#don-t-get-discouraged-or-impatient

