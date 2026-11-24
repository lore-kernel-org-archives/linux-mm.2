Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40695606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 05:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=M8czc+eo
Received: by kanga.kvack.org (Postfix)
	id 239E46B05F0; Tue, 24 Nov 2026 00:06:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB546B05F1; Tue, 24 Nov 2026 00:06:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1024A6B05F2; Tue, 24 Nov 2026 00:06:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7E4C6B05F0
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:06:22 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44AE6140AA9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:06:22 +0000 (UTC)
X-FDA: 85468826604.25.917D06A
Received: from mta0.migadu.com (out-13.mta0.migadu.com [91.218.175.13])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3ACEB180002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:06:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M8czc+eo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.13 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795496780;
	b=H1KrDXaUKVBpvbD9v9Be9LtjhwtBVUgZmu0hfCgtWdqrxP+P1F3Ri3QMskuCGePgNhUIrr
	kcE4Nu9T1VgVZPnSa19ACuaxYc3maytQkf35/jES7sbaoOV4XIUn2TiGssNZSAsn4rpekG
	K+y1SY1L+BwFQI4tDU99E0NUvFFbbxY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795496780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0zcWmLpq2+VJjU2IE5YvJW7Ci7lT4X/Bx8XXzsNsos=;
	b=z7N73pZKtWLoXdKXlEM4smvS8DVJZrRcOD99TYyJGDHMWrN5RYEd9hvV8J7pxoA+EJh2IP
	io6g0f5rwwsuMqTLghD+tILHXaDgknN8RwbHgb0sg6CY4JYI5hv5x5kyU+qjURrxysljS8
	m+WAc/al3EP4Jm/6lu+UNv+NOEuW3cA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=M8czc+eo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.13 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=J0zcWmLpq2+VJjU2IE5YvJW7Ci7lT4X/Bx8XXzsNsos=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795496769; v=1; x=1796101569;
 b=M8czc+eoL15+12l1kv0xYs4fE+EV9OS6lbHbh0H5YIiUzJ/Rr3Lr+qJ4m4KvvhfMUQJoT1n6
 wh4i1KEM59iQ1TW7Nmm8HYlR+lcfjPz5OErCoP6Z39PaFLBjffrN8Nceb5ha+txhWwmTRw8tVOQ
 Ju1e2NwmUHul5QnHRsTQPbbM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2fa56c1e683eee65;
	Tue, 24 Nov 2026 05:06:08 +0000
X-Mizu-Trace-ID: 2fa56c1e683eee65
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] mm/hugetlb: fix NR_HUGETLB accounting for kept surplus
 folios
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261124-for-gather-surplus-v1-1-231e5660f3d8@kylinos.cn>
Date: Tue, 24 Nov 2026 13:05:49 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org,
 Hongfu Li <lihongfu@kylinos.cn>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C0E550B1-1E30-4F44-A25B-0351A42BAE6E@linux.dev>
References: <20261124-for-gather-surplus-v1-1-231e5660f3d8@kylinos.cn>
To: Hongfu Li <hongfu.li@linux.dev>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 3ACEB180002
X-Stat-Signature: zyonx159in7u19xcsxjyackofmtai7qk
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795496778-24487
X-HE-Meta: U2FsdGVkX1/jtpmRRrBy8u5nZpujZ5/jZrkJ8yIngEwHLBq018S8z8QFf8WbFkYr+r0aczRslDndCabKVyowxjZOwXbD5XvX1C2zZQMktWZcGhA6EEL1rQHgLtEaLwTnkVphw9M27YQZTYBd1oXYsQ9kHve04RDlBtpkgEATwnYAD/ornRlr3IAl9nf6VlF+7iMWjIAmWWAUYnXZa4uc/fYPFossExDIPHwsSWEGxwxsX1xxbevJ9g1LRoqQ7m7X/24aoRaHwEJ5hsnuIy9AazpuDaq1c7ovfYRtc+gW39RvAzNGk4LxbpLESu0IAbDTNVednd//bBn1t51iWglgknj/N/OvEx9SdXJ7OlsXLixJxqqOSaKFJr5UBP+3a93qAZ2Sy2eUXHo+BqiKE3+emR0cViWDJufdzBhlkRpqP1Hp22JkT54ZHtfVEJyvdTbz/cgwj4syEOXWsAnl+Z9DtMIdY4nMzYck8KQ/4nkXMVE/+N6Suq8UW5kiO+92zrCj+L8+q2Q+3/GOs78bwuuqQqapAfBXC/4+m+keom9WfJv9VVGuLfXnCv6uAG+G2kDLobdsrGFwt7n/iB4wwTGJC8Bz8LkWeO0DT3oPZpQ9wvZ45DZsjX0IWq3Ume4vrfdss8nJgjjajtxkAZs4PofWShFPaCUTSLd6xIfbvS0jswOZ4VM0LkK6lrK6ZLXUqLtHs+M7CY8tFNoTxE2YoRE/RVApscw0OhOIyxPWE/dZ36Q2NAa+gtjppiyJlnopbocLhx6+OpJKx/fHltcwFVA+jEKltDa8CFbp86zVkDlXAxiTbPz31fMUQNYkwYb7oZXGJaAb3RBjkm4yDem2uRDHi2VvTt87nWMpk4zlynmt8gC5fsSBgsUUT4y6cv0hGv0ovr736vjZqgtveV1b23hWkiK1WQOUqlMhjyrq1WicmhVoOty/3v02IeFoS7O3NU/dThos6fYOiOPu+FoA+7a
 XTHFG7kj
 SOzH46lySnqBSst0Fs8VHJZu+6GigrMoAg1h1cLDlUxyB/AGNrFk22qQObiVf30vCLCDUANZAQk+8g1kT4PpGw8eYwZnQwORoO/P0BBedz95LwMjYHYi98y66COnuHGKGKRGTyslRoGleE9LJoZpq5tVC5d5WwJrf6eW2T1iAfopxmwLZY/LmjjKTu2TLtH9ZLM0VcjWd3pFv5ZLYT90fBubP6r5CVEc48ZX/fOzqZdHZGrmsUMZ8lQOIGM4S5lhIkUwMheKGvlEeRVxF9P6WBNV8Cxcl4Vg0Sw/45IRomDa4WFgjM5waQllp4iGsyPb3YoOtTEslnKfYCsVRCuTdW3u+3oVtJkMKUdzFhk5jIcfbX/iaHt3nfBIqIaGI+w9viTq2VTrBdWzhlNeah5glh1eAylp/umGPTQwtsi7mQdHaSCR0BgEuodjKzsGCjf8l6lsua9YPTMuAedV1HVLZAhQwDB+booOkAU88YcdAlg35UJIDMfNi+CrirsAESaqJnOGGUd9jFQ6XL9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 24, 2026, at 12:41, Hongfu Li <hongfu.li@linux.dev> wrote:
>=20
> From: Hongfu Li <lihongfu@kylinos.cn>
>=20
> Commit a11a13ebbc5d ("mm/hugetlb: account restored reservations before
> freeing folios") reworked the free path of gather_surplus_pages(): =
when
> the pool was resized concurrently, folios that are no longer surplus
> are kept and enqueued directly instead of being freed.
>=20
> However, folios on the surplus list are accounted in NR_HUGETLB when
> allocated in alloc_surplus_hugetlb_folio(), and every other path that
> returns an already accounted folio to the free list decrements
> NR_HUGETLB first, as folios on the free list must not be counted. The
> new enqueue branch skips that decrement, so the folio remains counted
> while on the free list, leaving NR_HUGETLB permanently overcounted by
> pages_per_huge_page for each kept folio. Nothing corrects that later,
> whichever path the folio takes next.
>=20
> Fix this by decrementing NR_HUGETLB before enqueueing the folio, as
> done in the other enqueue paths.
>=20
> Fixes: a11a13ebbc5d ("mm/hugetlb: account restored reservations before =
freeing folios")
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

Thanks


