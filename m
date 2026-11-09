Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A87606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UL182Ymp
Received: by kanga.kvack.org (Postfix)
	id B482C6B05B1; Sun,  8 Nov 2026 22:44:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA016B05B2; Sun,  8 Nov 2026 22:44:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8556B05B3; Sun,  8 Nov 2026 22:44:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 797236B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:44:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBDB2C058A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:44:32 +0000 (UTC)
X-FDA: 85414188384.14.8FFCE8A
Received: from mta1.migadu.com (out-136.mta1.migadu.com [95.215.58.136])
	by imf17.hostedemail.com (Postfix) with ESMTP id DF45D40005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:44:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UL182Ymp;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.136 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794195871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JTiv2GRYKop7vCx/gXindWSFmU7+GmHnHjp+oJDyjUQ=;
	b=wxrTsMns6AnfTaIcCpiUMkPlGUz9UgsKg5pbCfG0mdKYeNDGtRsZRlAoAHev4A8C0L/mgR
	xc1sJ9jiXFUTuddYLCZFEL4gl/UrIUXDQuljZ6xWtYjWbLvB3dO69PQ3p7DZSNYF++wlcP
	qh6dCxhUto6YF/psJuZR4yLWfaOjddA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UL182Ymp;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.136 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794195871;
	b=tn7QSKJZ3dgrA+sdobiPj68xYCTd36yL9s0w83KV65+TBS+7h5G5jxJ6vzMIRChHNwwMiK
	UWenlpKTtjG6ns5Kp38x9agDF6QeL3FVybzEvfStf99HFT8hEY5t1+W/+kwi7YRsfnbWdv
	TnwhUJP0L/Re9MRRooCFICe1/UmS4ao=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JTiv2GRYKop7vCx/gXindWSFmU7+GmHnHjp+oJDyjUQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794195869; v=1; x=1794800669;
 b=UL182YmpeSX6nFVbBsJ7y8S/IyQUXmitlzi+JbC5w2Ptgjh/cWL19fCg1j4IPVm2/p8G8A3e
 Zz3G2ydotNN5QvKRbPqEHUQIojBNTXxOPc1QrQFTI7OMGbxmf1kuKdNvyTzu1IW2fadxFyJ1+Lw
 bRnzGF/XbnueIjXLpDOd5JWI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id b7f753fb76ab6eb5;
	Mon, 09 Nov 2026 03:44:29 +0000
X-Mizu-Trace-ID: b7f753fb76ab6eb5
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] x86/mm: Tear down the direct map when memory hot add
 fails
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <au_l5MRyDbYfsUVe@chrisdown.name>
Date: Mon, 9 Nov 2026 11:44:11 +0800
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org,
 linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <681A0C48-AA5C-4337-8CD0-57FCB21D8D63@linux.dev>
References: <au_l5MRyDbYfsUVe@chrisdown.name>
To: Chris Down <chris@chrisdown.name>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Stat-Signature: 8hzjdpkeicfh616eqjq5y8bedxc4gfsw
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: DF45D40005
X-HE-Tag: 1794195870-799239
X-HE-Meta: U2FsdGVkX191dSyTfiOqsX+qmAvdNNvCzaIMk0NOiWBg14sRjIcjJItLM3LGplRrzgM+IS5pvXwMtp8f316opuoMIRVYynRah0WYjvxqYuF1Z4ARwtuY/G8D488uFFJVci2ZMy3mGR6hPuk7wnda7rFpG5ONPwNvph/IMvgUdH3ADlIG5oGhB6LCbo3BiWLhyskhahwYZyn2rLxu8OWGuQk7zNs1z1jh+7xRUS0pvfAQgcWj+5bo8MhMIcU68vcTmn7NQSiJXaxzbfWS9C13ubcp1XPOAFMmGHtoMY9+m21nFH/Skc+qfHKDMwpO+qjoh54RmHcx665hAk/YR0Cb5DxNFjbFIvyOEJrEvaOt2hCktXSkIvKWnczh77PPp5JzQSTgAtUsMuwBHdEOSYD3S2/5tWyCdOEEkK4nCz/f5daXBIp/tsBSQpABUX0MS0E3QK7LMvD1IGpIld6q4XN4mGbN6FvcyeH7JKnaxj+pQemwV38qTevHsQ7EUkOL0GpZ2Z6ZomnKbTqkjq6DXxJ28YlI/HoMuHOKVvd8rgXG30fUXixbSg+kQWvARLqQtHmuuwqI/y1nQZTqSQhgLcI8561ZNu92Ekv+y42UnPLCwAb3IzTV1UTpiBo9PoxZ+r3+X6iZ4Lpwc8Yw+lk9LiQiWbcTv8PoIDHG/h02axiZlRhTcEmDgIyddVkoPPUQX40vfBAhAcjK7HmArX9Td2n/h2S5r/4ihRAG56rD+xKXFKtKzrX6mh3jed6a6iT5n26xYNGh0MylSl+ADsYCrx6pSqauiuiao/gxN86IFMSX7rQyS8WPq+6bsEs3MPN+yMGLx/wp+GLQkuYM7dI4Uw/W9JcsSAeduswBf9d9qYQePWMTD4bxtRTaQIUGsTJfbUcyk//ifVF5W4dYFGot2Z6CTMeXR1r7NPN4BqcIgsuXEfeYADcB4LFeFoqkc6gxAWgOg4y5koTsM+TwN/lzZx5
 8uFzAPI0
 yVBJjxhqYQPRJwREQ+i5OCYAAKpF2JHrfrBmTDI4O4vEjQ+IAvSIErV+rL+lMBE5V53g7uIgvxzqNg7jAGCIKX1CO92EiEpuv2O/6zwXOPgA/Yz06Nof9kOceIrWRlIb65aD/tQsyMw+h8+6Asd7RnLxVDtBJIk9aRgqsZAOGfzxDHPwDLiePsPROjBrDLTOvzwcZemy7+Ehc90fwu/jZWEdKWiux7gCPJi+CKizUfTA/kSVyQ5rjB9ChIix80ijWmuTKPJHUWNF0K60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 8, 2026, at 11:00, Chris Down <chris@chrisdown.name> wrote:
>=20
> arch_add_memory() sets up the direct map before calling add_pages().
> If add_pages() fails, the range stays mapped and any page tables
> allocated for it are leaked. A later hot add can reuse the stale
> mapping.
>=20
> Remove the direct mapping on failure.
>=20
> Fixes: 45e0b78b0532 ("[PATCH] hot-add-mem x86_64: use =
CONFIG_MEMORY_HOTPLUG_RESERVE")
> Signed-off-by: Chris Down <chris@chrisdown.name>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


