Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02DB4CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 15:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA3B8E0010; Tue, 23 Sep 2025 11:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2468E0001; Tue, 23 Sep 2025 11:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B1858E0010; Tue, 23 Sep 2025 11:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 03DDE8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:31:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6A5A593DB
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:31:18 +0000 (UTC)
X-FDA: 83920903836.20.9913116
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8E55C2001B
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:31:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="g b1AVmr";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="FVWinC/x";
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758641476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjdVUNHhjUNJuLMxy6/eU24vJDAL9EcE5N2rfPXMzKk=;
	b=JKRGBgLV+lTvGnSIUN/4L1eZy2SgJ2QHffSaDosj542ikluzYGMTQwhr8mF8whVN9Eg8f2
	7rX/IH/toaZGH8bhCBRqYkxfGjTSnrwkXeC1mqn5E891Hj+4hbmPxnVxjtcAY5UBxFzrSm
	aQddD30VLMY3CC3zvK42lZQ/T7LbajE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758641476; a=rsa-sha256;
	cv=none;
	b=ofOPydXz8z7PSpZzG6tzB4elyWsjP27iP/Sb4iB18M6hKU/S/Bi4Q4HtQLCSxTT8lvqaTt
	rhZQKZ3QYgOdjrrfuYNKuPGUIXC3bjVXJQFLTfLbzHaZ9BVQSHMneBipt6QKAgdKUimaLy
	rsWHfVIpgiTV+1OcRfRSQU7N4/w70hc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="g b1AVmr";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="FVWinC/x";
	spf=pass (imf13.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.159 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D0C47140006F;
	Tue, 23 Sep 2025 11:31:15 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Tue, 23 Sep 2025 11:31:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1758641475; x=
	1758727875; bh=XjdVUNHhjUNJuLMxy6/eU24vJDAL9EcE5N2rfPXMzKk=; b=g
	b1AVmroCn+2rfsbRriNmCmDOVFlTOPdTDnsjLcHC5uQ9OFnV1GgR0HQFK3zZBXwz
	7AGtu2vkEsua6S8kB1iQp7mQRAO02Kazp+imCfj6hfO5QOcl7T8BSdFwwX2jCBr2
	dDhR6+tZ4vSkzaBfQHza/kR43K521Z1FZRIk8tb5CtZjng9oMwsTJVuy0Dqlgkka
	2If1JTbRdFN83/mF4m/2idqFcBxlTqf0xdfx8Fq3t9PEV+ipQwFMAoeSA8zGmVio
	dFq8MpLXn6xc2OPDoB8El3o82kvuI6sjDJ0ods2oS0WmjuQsw38UXOWRM0MQp7Xn
	vKu/i6mb4/nQUDmirCdgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1758641475; x=1758727875; bh=XjdVUNHhjUNJuLMxy6/eU24vJDAL9EcE5N2
	rfPXMzKk=; b=FVWinC/xm6uIyyO93qjO5gJEEhslP9QG/uw5LTrmSX4FNWPEfGR
	5T90Q6kyF4ZcvlS9i04pmQ0vLfnvFDhK+ie70bnd+JwcgtN73Xw4rAXpU9Jfr2Fj
	dOJQFnXtS7uRUjixHBsbd1JU+eNF57mMaBT4YiDCTw3P6EY/kVfAr0r58SPz7Cc+
	gjcPuiO0g85nXPs4+9q6o/byTsJUsUSbj4Kq2IhyYHVrX9r01Gn/7ttJGHom733/
	62URewWXKVhbsHgJchFRCtYbvNyEGzsstIYbtFR9RbRzDYQL2HUOwmMGzGDTXJpS
	3nXCX61mMTuW51kbo41/fld3WVnQq8ZKy3w==
X-ME-Sender: <xms:Q73SaMr6xipkrf2d7TJG5aBm39HMFAkXy_oYpuB2dKpcmWlHFAJcTQ>
    <xme:Q73SaB58-H7HiksjTfjdaG6ewtAoXcytRAjpa_uSyASTLxOO9_7J4hVHjP3L3FUYW
    5Z8Ywta222gJ8hH9Rek01yo71XGXbPrjpF7PGp2WlhUbD9yJ6bY3g>
X-ME-Received: <xmr:Q73SaEDBVtnJ1tZvxrN73cV7Gbq9TB0NES8XQLDds1jB1BZ-M7-r2QZmi-3nhQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeiuddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepvddt
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtg
    homhdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtth
    hopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohep
    lhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplh
    hirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehvsggrsghk
    rgesshhushgvrdgtiidprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:Q73SaLafYZ_Rd5imKIkhXzZtlS446ECKgBXFbC1LXClJQbVaoADQ6Q>
    <xmx:Q73SaALNItVAy2bpeWr1rZTkPblVnqnAjalRNswmsgq1Rmh_d7pfwA>
    <xmx:Q73SaMBk3JkSWDZ31fK9J9h6XyQP4nrJeRtOCxhRKpCXSB1hAcCriQ>
    <xmx:Q73SaMNMb-8iwwrMA_NQ-keguP4w-N3uMLlIUI1xXgpTB3XkfW8cEA>
    <xmx:Q73SaKn1zdYmVp0Eu68ibPCIeku12Sj7KNBIHik8pRllD3MQ6LEmcius>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Sep 2025 11:31:15 -0400 (EDT)
Date: Tue, 23 Sep 2025 16:31:12 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v1] mm: convert folio_page() back to a macro
Message-ID: <oaitxb74dpz6gdxoxrqcru3gz2w55r2afpow6vb226xu2elnrk@zqcn2yh4a4eg>
References: <20250923140058.2020023-1-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923140058.2020023-1-david@redhat.com>
X-Stat-Signature: 76g6gpjycaq51okcaoq9ukta8f8gdwtz
X-Rspamd-Queue-Id: 8E55C2001B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758641476-948836
X-HE-Meta: U2FsdGVkX19FSrNAQJdbvP5oF9lleZwRlBmT8aGQzBpJk6cFMJzT1V4vxhM7sMiz61gvxtJYhRNQJkkK9oliDZvzST4RtGi8babB99lkEkC4oyB5VrDLSAW4/I1FOHbMSsP5M+fyqLg5lvOpq6bVxsGr4zec4tJcBOUPqR4jJqnnbPGGd6j6bWy2E+iBVwajrqJRtCdusiie25Mf22fYzAGVGkZCV+I7Bw0byEueKtEuxXkFhvV/7tThX8CoLXyTq7YPkmWXUgjBjMThWZ28tQFCPvad7lfgfJhAuQmegw9elFCPI3yxU4O2RZjtvRIlGDtu8SsqivmvMFiVTMKPOec9oy4OtHf9KqIxYWEX3wSjWhMCylBInuqgFADJTVnBNRQ5caZompSYIe0wFzhLIzBn5GI6cgf+QwyRmGQE2MJh0w2d1ZqnKh1FyI4/4MnQgf3ipL4rLyzr7FpKV5DlI8Q0+GBcSqddFwYmK7JGRKoSao+bbU/mN3dwW6zJevixQzA2LwdDobe61778nfEzFkdQkvHyZCqNd0UQlJhSMUkC9INj2eq5/kstoXaRz3zIC+AG+lCBLbX6yyTfCFFE+ehqu5lOAFakEk9QQI3H6/SzcZB3fcHfIz9d0JwyDUEbvL+I2u66mlT804xCCj0AEzKk4Z0M+5FluWlCQWI0To57qWnPYjbhML4oH7ZUjIlnfo2L7kPZPWy8KqtSYFj805fde8URujOFbqTnl8/hUTUJK9afeKgtMGXv5b841nrC5c8QIFQvOh7kh0QQm44YAeJs5h0ouz6URZlJL3OfkSm3R8enb7InOTqXVX4eZNVrxX+6//cvllnxLpY18tRNA7IqW0ZUiB841rGdBYpylcHlt9sx/V9rWkz0QOfhWkkQTPtss9O6aypwlA9jRk5hveC8ctj4cmlnPFARqu/88cWWJrY3yldtr0RJeYMTd+900QMVCvbkfPHdFQuWUIr
 F77q8GlS
 ZCV34WnXnzM0wd6cZg9fCtjf207WdO7edCOqE5pE/lcdToV4qV+nwf6ebrr0NQFmPXZIqO9rnmgVvuJfqUBeGhULu1INFFPYKfmbVNaNMGRD7U9EZiz84/RGZ05Lc8SvFKTNkOUyZNlhh19O3pOvMiFaosJMWlQkfhR3fi6DIKL2QFhwyHSGzK6PzUjopEITq5/jBEkh0/O4sSidoVvghsQ4JvJ7FJbkAzQ0VNbdj97rGVgYj4DSw8tFRFySZIjEKVaymWtrHR2eM2Ost9Fer5icXOe2xKU8ewDD+e9H+OFF5FZw1xY8RD0vPAN/chjPDPQFuobXA5gBV59CN0wwMTnUopd93YOBNURgHSVogysuUyrZXKujXKs1COyizd/uHDAnVGxQiw56UA+JsQXTig0QwFr7FB2EN+Pyboa5aV10Aq+zCL1vAiK0L8L7KWhfHNtzqw9SK/Bi+f9q7pHHrblZhRtwQufHVmFkEtFZddZq18zrh7iHX09Cv2ZnWDlPhAsl5jarc1XpAV+e5YV8M/MnQIfYVxWkAaLXLx1IHA9kiORk5hER3FcdoaPs66cxvcNGF2kbartihzLXQDTIoF3aYVoVhYE1G/CGInL72OX0JE8lfUx7kd5USiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 04:00:58PM +0200, David Hildenbrand wrote:
> In commit 73b3294b1152 ("mm: simplify folio_page() and folio_page_idx()")
> we converted folio_page() into a static inline function. However
> briefly afterwards in commit a847b17009ec ("mm: constify highmem related
> functions for improved const-correctness") we had to add some nasty
> const-away casting to make the compiler happy when checking const
> correctness.
> 
> So let's just convert it back to a simple macro so the compiler can
> check const correctness properly. There is the alternative of
> using a _Generic() similar to page_folio(), but there is not a lot of
> benefit compared to just using a simple macro.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

