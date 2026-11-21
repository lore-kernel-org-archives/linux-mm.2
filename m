Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96224606A33C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 22:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Wp6Y68ZR
Received: by kanga.kvack.org (Postfix)
	id BFFDB6B05B1; Sat, 21 Nov 2026 17:18:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF7C6B05B2; Sat, 21 Nov 2026 17:18:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8E66B05B3; Sat, 21 Nov 2026 17:18:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88B0B6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 17:18:31 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8F5B01C3ED0
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:18:29 +0000 (UTC)
X-FDA: 85460541138.07.1D0F6FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 20AD280004
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 22:18:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Wp6Y68ZR;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795299508;
	b=qveVylnddo+QPJYh4wIYLrBIK7BO8QT4h+teOiLQ23xx9+7WsCiHYesybYs8Qwtt1S34Tt
	cLFG5ddKYwWfnQwo8q4qDnj6kntM/wPfuEGV+AmxkhHoaTWOLqZu/hA+FikimgT1RP6kNa
	uPgQiSiSx04dmARnO12Fbbk6gpvwecU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795299508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=N0YfuE5S7TLOtCEMAv+z9+LjiAnSl4zyEz39ZHosAkI=;
	b=JLLQ/9uAu2TjwtGPtuEex7qyDrgk4UhIY1ondxhzykP1HRdFR7WCM0MhbWLa8BI7Ar7YAg
	/P3Lu8wkETkhYm/s6Mat51ED7pAxCjZYYDf/yJvaiWjxgGJRD8Z/8AHM8g/7oYqNCavDph
	DNpuGVekxh0Wv/XA8hyZJBH/Z8Wvxus=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Wp6Y68ZR;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5928043278;
	Sat, 21 Nov 2026 22:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8311F000C0;
	Sat, 21 Nov 2026 22:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795299507;
	bh=N0YfuE5S7TLOtCEMAv+z9+LjiAnSl4zyEz39ZHosAkI=;
	h=Date:To:Cc:From:Subject;
	b=Wp6Y68ZR+OCI+WL8RDgWWBzIGteS8FphxmBiCZy/21zFlQ/k23FRiLZiK1iB07qUI
	 lihHS9CNc50XF0+y4fj+K2O28wgDvXeHvU65gQPNtBzRL5ymwAThGUqOtS67NBrpud
	 88Jc2W1EphYLz+eKyKQMruJzLJA7eKCJkk6UnvMc=
Date: Sat, 21 Nov 2026 14:18:26 -0800
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Nickolai Zeldovich <nickolai@csail.mit.edu>,
 Baoli Zhang <baoli.zhang@intel.com>,
 syzbot+73641b60a3bc11dfca8c@syzkaller.appspotmail.com, stable@vger.kernel.org
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <08ceefcb212e4dda9767389fe7f162a8.0@linux-foundation.org>
Subject: [PATCH v2 0/2] xarray: initialise the offset of a new root node
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 20AD280004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 15oi7kq1apqtiknazo64mm1hhoh1z7jq
X-HE-Tag: 1795299507-443740
X-HE-Meta: U2FsdGVkX1+6ElrFkOYuHZ5jJzG1sGFY2Zn7wJO47l/OpJp5FcXPfQAKsIC/VwdzRwsUB/kttLWKgx10UMnSbZFqL7NaGunVC3OllZ33kq9jqPvS+ruljA8Bchjn0Anm/AxWHKKcGpXVjfCTlcYsaNawcE2ZN4IXBIx2SjDRjUAHVNotzS43Oal9ZBNaHmrLs79G87DGPTxzU7Nv9cVHQEZ2UPNpjX52F4bIHqRfV58Z131hNiBgHSw6qpTgQnWBf0wvrvSQWj1USisyNm1UukIgMOcjVddk1DOgTfcw16ds0eD1HPFkI+Skj9cL0baf5MilZPkvqvf+rnFiEH/fQD2P2cDDtrMgoqwIfjLKP2DCIYeuZNBxMs+4ydN1vKw4LCTI5S9QfhT3SLQx1zfWiiS6rLIyfvrkCMqnvRf/gL6TimNOHN+iY9eWHwxfGl2IHrcoMTQbnE4ZuNhIefleXHCKkdhDL+yG2z5GSIlgiopHaRVu/cdIYgSsvnSnWRWIZMNpXwW5ot/YwQTJDXxaLYce+5NwGRckq/wiRsWWqaPZkqsExSDZnkZX3cuZAegXmVHvq8MDvbrzbTNNPrOlhXbg0Yr59AimvTVS9gHksdOsb5NmlGdDWOyIXwivla1ZdEf8JBjKo/EeNz5iYAwmDRIWb9vTXYDZ7ly746AnpHO7H1Vipk/xpf/pl9BdedUoYGc51+Dj03cCj5n2zkVmdHsxTPPbay2zMHEscVY/Wg4z4XKEwfEQKpi8vYAoexw32TSp1fDwsFQzCdv8wORfafjBB+3y2DTdtHM+QfieXqf4r+naGFW6wSoGTa9yXr9AjnNlS9MJijTDNF1UpLtp7wpvkmJjMPj5RpZqOUtzf47sGed3AiqpEl8PZaLVtkgKGLWeiZfhQNEGh63JRZN1mByuLwJP3CvKgthWwSJcHjxbwRIvHQgZzPH7TBpVe+t70OQrJzn0UwtAaEsTmU2
 xrKWiuC5
 Kc2jxqsZEbJnEMyprpSrGRfBvYTl1Xr0v6ShyyMeGbQA+w56vrDZ//3tRTyxZzChugrdIrtEkYV9Lpag4fvgRIytmyh9Vj1DtYHzud+Oeh565mGszGYgqO4HWWNZfW+w8kDUiiLqrNlQILD/LOsljwp49UEc7vu73HkEnsQFPnu5JJDxTa5JL43I9U6U//70pe0OFv5gKibTFxrnQBXbKvz9tbMP9pzrFt4vh3R/kkSGl1oE9Byq0PtAeOGDZd43NMf2vXD3BLEFGYxvNxicpLB+EqvsVgfmeb45y04spJ48JsyQYDneoRBCu8WAKnNdZFuYVyi9PHrzxs9m9kjFNVd0EFJjfoCjPrm0wTEyKEJUOKibKv4lY80TXoP9HnFOrk80A7xbsAkwWMoLJxRRJkQ9+ADIKvvKgTJPZJZCHVqEpXX5ESHVuMVV4jkinLp77tmEh5Z2DaD6lEgxVfyoxhKL9uyFBgyGt17icqvBkpRX0P/WjoCkNmiShKLP1jq00d+FIRZmDjxQqZwcb3JglryjgsC3U72e665x53pl4EJPLfkqoBS/bNCjhmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

An RCU XArray walker can read a stale root offset just before another
thread grows the tree and links that root beneath a new one.  The walker
can then return an entry with the wrong index or skip entries.  Check the
root offset after slab reuse and initialize it on allocation.

Nickolai Zeldovich (2):
  lib/test_xarray: check the offset of new root nodes
  xarray: initialise the offset of a new root node

 lib/test_xarray.c | 33 +++++++++++++++++++++++++++++++++
 lib/xarray.c      |  6 +++---
 2 files changed, 36 insertions(+), 3 deletions(-)

