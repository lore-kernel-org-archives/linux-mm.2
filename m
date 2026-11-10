Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0DD3606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 07:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uX/FQNF4
Received: by kanga.kvack.org (Postfix)
	id BE2236B05B5; Tue, 10 Nov 2026 02:05:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65C76B05B6; Tue, 10 Nov 2026 02:05:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2FDA6B05B7; Tue, 10 Nov 2026 02:05:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 811AD6B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:05:51 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D684F808D0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:05:50 +0000 (UTC)
X-FDA: 85418324460.26.CDC529E
Received: from mta1.migadu.com (out-116.mta1.migadu.com [95.215.58.116])
	by imf10.hostedemail.com (Postfix) with ESMTP id 359CDC0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:05:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uX/FQNF4";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.116 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794294349;
	b=L/U26+08gDgJSo7NXAb9+tUDNSJPaAt23IX+OpW80PfFdegtfoiGUcEBprISFmzWJogWRG
	amlSMDzMwC5qUzX3sll9wGGIvFzZjUMSYrFot1IMAJuvnv22mmr6YUOJL3gARr00xjoa5w
	EwTYxKSTiupdMyuwt96c4arBdFjz4e4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794294349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZk3SsVUMy8xoTgawAV8jGI3OOcRbHbKMzszzz5dC0s=;
	b=8eLKmC34xZRsH+6yR+2EWinXr9BKVm4EgM3B9Z8YxB8tkMZVwpK3u4x4iRzZWqc4B9AGw1
	KYG5wUOgkA/IPXkDoWAk4fcqohta0jP94u1Rto1xpsb2vZ7DFqZZ7xVYKycOhmkOwcDnol
	MCKyt6nniMd3jGfbgVvuG5HSd/ARFfI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="uX/FQNF4";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.116 as permitted sender) smtp.mailfrom=hao.li@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PDz+qwYH/e/DPGEx5k9eJgKdIlMjdKtiXOXsonysk0k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794294345; v=1; x=1794899145;
 b=uX/FQNF40xr/pIkkUgsE2UNKnZG75Tt6NWSf5BNLlae16iQAeBMtFrIU9GhpOqq/Euhb5aXY
 euuyrcGDewk+jI62Yq7+p2mLv6DqABEtEDLGNMGy3wNBO17j1cUZsBPTnCsrB6BUimiEtWjhrgZ
 mESlCW1ciTfPNgA3w+DJiY/8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6dea8860f641d184;
	Tue, 10 Nov 2026 07:05:27 +0000
X-Mizu-Trace-ID: 6dea8860f641d184
X-Migadu-Flow: FLOW_OUT
Date: Tue, 10 Nov 2026 15:05:14 +0800
From: Hao Li <hao.li@linux.dev>
To: Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	loongarch@lists.linux.dev, bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: Genericize x86-specific cmpxchg16b comment
Message-ID: <avK8RqLl69zIkVY2@fedora>
References: <20261109035906.10857-1-yangtiezhu@loongson.cn>
 <DMQW32TTNOPX.24GN6Q7VI6QJR@gmail.com>
 <145c23ea-bc4d-b235-c822-df94b00a647a@loongson.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <145c23ea-bc4d-b235-c822-df94b00a647a@loongson.cn>
X-Rspamd-Queue-Id: 359CDC0006
X-Rspamd-Server: rspam12
X-Stat-Signature: mbtjx8gb53is8mdhaz1d3mbkyw74dzq3
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794294346-459184
X-HE-Meta: U2FsdGVkX1/HEn9uCjFzZswCVtiDgfvEtrUdOhSRk39gZelJPuGrmk1KvEmd27Ehm6X0V4H/KXQGexmkHivziedEOI75oxR9M8l6SXuuMau+9Nol7GDbKpjQOs9Z40Mt9EZoBQai8JvYHZ9bdgU3IKerk+hB2Z5swLR4bLeQkjArTwqNIYtI10QTkrmQJ3YkHLvHS5JhIzsi2bUSSOJinuQ5MlwUgR+vcU6fwFgJ5iYwupJ2hLtlGBJsIWwO7Bc0+x40AtpoOTlzy2hZPDlV1E7/Dk7Ip2jFCyGqtg1oKEn8ucyQvuaWLrqvmQa8mGWnCxGP8+Xq5v9qs00FlJ+G2bUXfVVZA2DvAiBT9MhDTNL6fM4RCjxCLTncyjCt+Qnv2BIRoKToV6/KmDS7s1enp76ZJnwPxqGDzud5ti0/2l8x9/edFZ/S3HFjwR6oF2pquDE6HZdO43IKQmvx7G1KM7kVlHPtxRpKoafqZdw8MI0AS3RjsoPHotv2vUirbNvNIwVqTo8yyE2QGF8hGJuVdGOiY6Syf8wqrGeGtPj97sxlY4Wxu/k1HpCXcSSWk/3UWV5rPzstEAC4rEn2pm5OwbDJSWnH4oNM/jqax0PkLZMTgBMQd2CtDCGZ2hm+aa15Yd7zuq8Y2HoDGZAl7sTMpEt+18cKOxWULMYQHLSdloEvx6ymIvhNvw0lhpWcLSaV8Im3Z+evKn7NGQbOVywO2ZBhvUSHK1oN0c5+LFDef7UyHiqqnA+AqxjiCv1iWo+EMY7UBWK/feDbih+0nl7tUklyDNj1MzSNYOmL/Rap2bKop8K/e3sxPcU9X81PKdFaI4EsCTzfTzTz1S9JGX/Cpd8YYltsrxfezh/ELQYc8h3wxBELvyQ4eZG0/dTvcQnSa7zpcx6CK6akr1bUBmx0moLQJWEO/o0xZ7X1ccIoYu2v2u6myttUjS1AsRtJJqQKOhwe9G2xndMwHDbflhh
 3FRk5sNG
 InqaSBpt4PuXHabaka2SR5PUFcafOHKRORCbCsTfw9CL/R4jMz/y9b7fTwH5Jbu/s9oJF91pX0r70lAv2rnWnLR3DCwKl/fK694/BVy846QDbifxy1OG5duaKnxUI5Rp6z96e27ZNPgpZhDjbmmTQyW48Q7lvLWIWlGshu239kdEU9O03jaU4JzwHkCfu1JwF8e1KN44oyoorIIVnYSq/p3SPtn7osRmKeiU3tQoy9qeqF29duxEs6FL280bm+kTj3U4526c36IF6qCFbB9bZcEuIk1EMDr9YQ/DCy0JlJn3UKLbYXPIlm999siVSkJeVJJ8LcarwAEltc4jFAJd5KKJYsMQh28DLgZT5+XfLONt4xmzEGJDWt31+0byOGS2O70wdri9LzK2tofX5vB77yaLEv+DHahpXmxnYxRaHrosZrj+wSCgF6S9/JtEvhPuVA4gyOlvpWHAWw6ju2GPckpVn2hvsZpNtA9vrRx0d3mCORSvetLuX6/B6CvFAQX6xgYT25PUnH31Q4+HNAmfvS2Eo8STGK6+bdocMKdf/vkFkwXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 09:29:04AM +0800, Tiezhu Yang wrote:
> On 11/10/26 2:25 AM, Alexei Starovoitov wrote:
> > On Sun, Nov 08, 2026 at 07:59 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
> > > atomic primitive is satisfied by different hardware implementations:
> > > (1) arm64: satisfies it via LSE atomics ('casp' instruction)
> > [...]
> > > Update the comment to "double-width atomic cmpxchg", which provides the
> > > following advantages:
> > > (1) Accurately describes the cross-platform hardware invariant.
> > 
> > You ignored Hao's point about shorter commit logs.
> 
> If the following shorter commit message is preferred:
> 
>   mm/slub: Genericize x86-specific cmpxchg16b comment
> 
>   In __kmalloc_nolock_noprof(), update the comment from x86-specific
>   "cmpxchg16b" to generic "double-width atomic cmpxchg".

Ok, LGTM.

> 
> I will wait for a while for more feedback from mm maintainers and send
> v3 if necessary.
> 
> Thanks,
> Tiezhu
> 

