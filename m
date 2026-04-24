Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AAB2FED3C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A15306B009E; Fri, 24 Apr 2026 09:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8396B00A0; Fri, 24 Apr 2026 09:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DD926B00A2; Fri, 24 Apr 2026 09:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7016B009E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:53:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2AFFB14015F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:53:29 +0000 (UTC)
X-FDA: 84693591738.15.EE631C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7575F140002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:53:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BVr1vvQf;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777038807; a=rsa-sha256;
	cv=none;
	b=JvV587s0M428reqD2RfI52nBUNp8RI9Zn1L3+DBr2Ja90v7gSYBPjsYG5KVt0iGchQqMBm
	7dE76XUa66/SjKVPyXCAdWhp3ykQt07rWePINIn3bPLGySgNXqIhSyrAqu55rDLV35xlQt
	7UV95Y4k31urMKPP09hvDFW5dO7Fy/s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BVr1vvQf;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777038807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXyLa7EtcjXa4QtGj8bL7aVeJHcW+Ut25/6nEAEOz80=;
	b=oeBLCzmP+NZ0SdBRVSAJuiUtvohOJm539NPkkul6zFUD22ZZfWSj+QXkDSZU23D5Ssus8t
	tgY+i8jdGRgJWz2dfHXaYbDlKr4i7XVEtTEEsWoUd8cJJoz/pP7p2WUMtNZ9wE2jntw+wG
	iV6vNDBPZJ8kwMtAmYH7jCo/ZjcQpCs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 737FE6001A;
	Fri, 24 Apr 2026 13:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F99C19425;
	Fri, 24 Apr 2026 13:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777038806;
	bh=SmelVMfR0lIT8feBbjzKlmYGOWieazPUWxP+anpPpOE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BVr1vvQfL1f9TtXGB75geSK6oFBdMswSbOe57cvHGXKeu50nA18hCinr25LHx9ZLn
	 T9MtaGzQAzj1CwQ76SxHhuOzj6gVlKHFePd5nUP+t5UKZRdLKxi6sY/lzJV4GBd6sH
	 lsgYTCTZBOgxRYvieyx+yth0vF1iVR/Hp2KI/rVA=
Date: Fri, 24 Apr 2026 06:53:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/2] mm/kmemleak: dedupe verbose scan output
Message-Id: <20260424065325.d9643671feedb0f27297cc94@linux-foundation.org>
In-Reply-To: <20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org>
References: <20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7575F140002
X-Stat-Signature: usu5zihyok4esy1d3hu3d6k56owpb5rf
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777038807-987520
X-HE-Meta: U2FsdGVkX1+3TQ/u6+JLpqZYUonIC1VrPkng6eGtf6mqmgkFG0NqHdKMc9zVsxd5H5t7eUTzny/P/OyPx9WceGbsiB0NAXLq/vrH1E5dszlGvmVuNltTxNcfb7sn5xOAaXWdEeco/JpJkKCQdXvJoVjQVNP9NJxwSyWsPW1jzj4yyFgJ28+3/UUwHVhiJh0qR85kt584wt7nLUhWVEmaIPJUaxe2Ib9T4yMX0yMOfNfirL5c6OA211IU5snZaJNLZu9sixNfaW6qpVy3HrnH/AYoztkpMrKSCzId2kfJjNA6176IJOeWtkyR+2uHGFLM89keJuA6CK6xLkF1C7SEIPvjdR3v4/Z37E39OzjF97GN2uemwR3nQn87XS8RLCqA478k9BoPUMP/Qy79sgpt8dgKZskV9uQpQsFa9FYMdZY1KtEZPz5PSyKg4wxFrjG62kOaCin+eTzHZGMsvVvfYXVh1AfD3bB9uuwLPJUiPCEXieeM0o5/5IwaOI3VREj6lPRW2StU8hpEujVJEj/9F/tAI20lO5pTpaaWrMXGESvYjhLPbdVxyWVR0i8O2B4qZIACnKEwMUOSowZmEwRYNOZcs47fsajNGHT1GhS86hTdhkOubx34e5pZrDnFrOX/Iaq1UquCzpB+2UQVt/58qabvN3/MOgHK8iviouSvC054olFWbDTFj34hoFCZqFdy1Bza3EtpNDKQOEILeIBkTWiD3A8ul4m3paTt4UDOXDSUTHEykukEXWzLzlKMl5Lve6pnENVC1MyN2RyUq7lISCR0M9KG8YtwV8+Cn145UQgw0sd6h0mJOIi41NwKlRtGxBI5pe+SUQ9NeMXKafIA0duhTjZ6BZFN/qlxerxSBZzDUnrTSyRcJUJAD+E4vL9iA6t3/GVA5Yb576ajRKX2p7TpuSiLC+S2Oh6aYo2NKN5YuVTm/w6RJf6YJA3/GKTFodC50AGsX30xCup5jmO
 DQRFfK7R
 0p2nP4YqipGC51+axCJAfjSuaytr2ZdkqBbXbQOzra0siT5pJeWJxaz1lo88Bgj7L9rvvvgrnoU/4d84q9gtRjTjoHvJQCabQLRBqJU4IP1OxtWAmr5EokNduplm5bRqeydgfm+OZ/KbYvfBiZZnYJmj4NkPMTuuybCCF6BQzZMsy6l2GvLNk0Wg5XrktY9wZ/vZkaDw0LizdWk8RT9mcioTL7lWjyzcXJRCYSoef2fk+RaytAc27ruoV/pRLoaQGJ0/1q670YVRB5JGGO0tOGuyBl8wcd/jlQBlEdcQRS2Q4MH7g4pj5PyJU5tW+w0LF0rP0IuWfR8iYBQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Apr 2026 06:45:03 -0700 Breno Leitao <leitao@debian.org> wrote:

> I am starting to run with kmemleak in verbose enabled in some "probe
> points" across the my employers fleet so that suspected leaks land in
> dmesg without needing a separate read of /sys/kernel/debug/kmemleak.
> 
> The downside is that workloads which leak many objects from a single
> allocation site flood the console with byte-for-byte identical
> backtraces. Hundreds of duplicates per scan are common, drowning out
> distinct leaks and unrelated kernel messages, while adding no signal
> beyond the first occurrence.
> 
> This series collapses those duplicates inside kmemleak itself. Each
> unique stackdepot trace_handle prints once per scan, followed by a
> short summary line when more than one object shares it:

AI review:
	https://sashiko.dev/#/patchset/20260421-kmemleak_dedup-v1-0-65e31c6cdf0c@debian.org

