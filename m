Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F35C6C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 17:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92D046B07E2; Sat, 15 Aug 2026 13:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD766B07E3; Sat, 15 Aug 2026 13:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CB816B07E4; Sat, 15 Aug 2026 13:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2FF6B07E2
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 13:45:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47F6BA040F
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 17:44:58 +0000 (UTC)
X-FDA: 85104229476.11.6AC5AD6
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	by imf31.hostedemail.com (Postfix) with ESMTP id AED5C20002
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 17:44:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l03mVUsI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786815896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avPeZm5/T510jKkZ9/tRUIvDLKwmbUPM18DoG4CWRaM=;
	b=8dfHhIWvfo3CZS1Qwx2t940Y0XOl8G1zGhw1OYks6Ka/1KZ5kN44kzpFpIhvX87XYBX82q
	FGEJx5upi1Mk2w40UqH09W4pSpMC04IZJf8y1z48Bfdp14WgbLl2j1XzooPEMjHT/iZ1Lu
	hqxnWQwQKvX+SJebeOvatlvo8C4Z5i0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=l03mVUsI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786815896;
	b=DVPamDPXMJqOjIczOTaNo6rla6iiym9/o+KGROx93yT4TUEFXz+PSAWbgiXDg771U9FLyd
	g5rrSE8ZAFOv4iaFpP3u2wH543YCens3p1F+9IhHxYAPzoj+OgqeST+iWgRvC0hgKEpTHr
	WTn1e5YOMQcGBHCYyWywhtc+n/E//+0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=avPeZm5/T510jKkZ9/tRUIvDLKwmbUPM18DoG4CWRaM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786815893; v=1; x=1787420693;
 b=l03mVUsIYUY2BcNsooZ5LGtaOnitHBJ7niiREo2uQrR7KR5L8rNFfPYMR7nCZSH78D2LZKVV
 FWeT7zPUGbiVcg091lF1RZ9aj19m0zFyvK0B1w9QZKhlKX8UzKpzPD67xanz3Xr9/Xp5qMk3yD8
 9aJ8IALZfLtgq1zoDfL1Q4Qk=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 3174625ea40415ed;
	Sat, 15 Aug 2026 17:44:53 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: vernon2gm@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 0/3] mm: khugepaged: fix tracepoint UAF
Date: Sun, 16 Aug 2026 01:44:44 +0800
Message-Id: <20260815174444.4164-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260815051924.194810-1-vernon2gm@gmail.com>
References: <20260815051924.194810-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AED5C20002
X-Stat-Signature: au6ejuwp7ce9xrcy59qcgejt87y6qd7f
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786815895-866147
X-HE-Meta: U2FsdGVkX19X+2VsU7qdh8fV8sKs7KFhwxkn3ncNFqt4EXUoYAgxPXBtmlfJdxbkt3/ks669KHJsTCqQJ7BQ5XVgrIG3vORCmbulFx4ZbuIkkKRe9gxmRkEr+q7sCmA0Dn/j2dR7s5Yz47fZslf5tQLNwnqrae7H/TbYrwzHH0k5AA8+PYDfHghnVbueZ0MLiC4oBSiHgI1M6XNjl+Hv04LO0kHuUd4mUU/iNNDQMX3N2xpP/k5NjI6yWceY7bNbqIXn1uAmi5FJ/Pd20H2zXh+dm72CEqmG2nKJpUFG0p6N4lO7TqIQcfeYqtYUg0xuQ2eLKr6V3dScIlKZt+2JIQ3eroB6pqF0714jv4FRJUBrME47uKZeO2awktQ3xXe/AlsskWUEQ+T6DwfknRUXZ2s4FI/7+3rVUTBAAzVKStfACV8XtbaEgiqWSuyxETts/WP/lXuw7gTSOGi2ib4xv/byuvbIn9w8G3apOHKrFsPsRF1QVNHmnsSJWhQwen0OZv3v9x9973FBCbRfNlI0aLXpbT1DMTKn+zEq9g8NeY3jvJL804xmxODKRs9N0eUxrZDaVmtjbFAKhYAPEAeKvNR5stDwGb3GxOhVzsDDsRF7H5xxKhALt1I19t6qoh6wAjened9uhHOv8BzEiK/7WBqqtungDOgiLQwDYttdXh12WWLy3acm/6ZBlLbAFmwqL5c5g9OURLIwoYrKFfUy+tallXwNUWFhoM3ZtOG5bBvcbZX0LR07gMXusW7W87gANqH4Y9Sxoa4Bg218m+3NbI/MMz0yfaxmymrFkzzfrln/D4qXSqPJEiD+Fxs/18P/RvRNc4J5qXva2/1x4ptEbioVYofvdtFbmkb0nm6tcs0QZvpj6ns2/Bf+YqJtDWxYDCDukXTzIKjkqo+vtRYnT9zdUZ5eaxs4455STL/afCsI4F72HxkzsQoOHObjuBBPB/exssiMWdHhN2xkhQo
 4Bkmlk1Z
 BAktZiREzct3EXZ3fGrQGoV+LoANtEdyjkitBIzrS2OWNXnl7F83RyP+vJ5sNXG88rrtiOxvaO3vryI7b3CDSQRArqCKI8ybP1atBUiNzXyf90P4Tpu6Yh1BmeNNGvkstcKpbMJIylYyCjv+3BaWYHCwp4jUhveIH8FQgWyDOAG160hGcDj9hIV/ALhlmE93ZHxUk9lIaqozDSrEu7i3wxT93N3KmNrNQiN49Os0rI4igGZNj8DjhZbWL2xItHA9TvuTfyd2KUR9jNqcrKAQ2am9EvRhL4RN3mjdZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, Aug 15, 2026 at 01:19:21PM +0800, Vernon Yang wrote:
>From: Vernon Yang <yanglincheng@kylinos.cn>
>
>The khugepaged tracepoints take a folio pointer and call folio_pfn(),
>but by then the folio may no longer be valid: freed after folio_put(),
>folio_unlock() or pte_unmap_unlock(), or not a folio at all but an
>xarray-encoded swap entry. On classic SPARSEMEM, dereferencing it oopses
>khugepaged as soon as the trace event is enabled; on other memory models
>it merely prints a bogus pfn.
>
>Pass the pfn to the tracepoints directly, captured while the folio is
>still pinned, closing the use-after-free windows in
>mm_khugepaged_scan_file(), mm_khugepaged_scan_pmd() and
>mm_khugepaged_collapse_file().

Well spotted!

Gave the series a run on x86_64 (KVM), all good (only classic SPARSEMEM
untested) :)

Tested-by: Lance Yang <lance.yang@linux.dev>

