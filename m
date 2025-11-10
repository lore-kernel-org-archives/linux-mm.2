Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9113DCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:29:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E613B8E0025; Mon, 10 Nov 2025 09:29:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E386D8E0022; Mon, 10 Nov 2025 09:29:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75B38E0025; Mon, 10 Nov 2025 09:29:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C65B28E0022
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:29:06 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C2B384016
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:29:06 +0000 (UTC)
X-FDA: 84094929492.19.A1B5FCA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id D5BE3C000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:29:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="eslnmnK/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0bFMfSQmAiR4R7u4OGiTL9L+yOue9pBltZEhnqo38w=;
	b=kyGMFGTLpgMoM5AeaG3YZW9qmGlkfV0fuueFOegmTVjXHgYt7TjheUDRkZIwcg/DhukyrP
	NztVwEBMOvrYIPEok5IyhQNJnsqx671i24vfjdLeXYcYcIqPwCa4wDK43uByqelox2TSeG
	X6icO8qCSAC9UluxWDO+AviiEoc4Ll4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784944; a=rsa-sha256;
	cv=none;
	b=hA1tQUke34+tZkVqSY9FKVl9m1/hL5SUwDAukHZumYUiT3bwgFj3UQHJoKR3uU9Pqfd6dv
	4DIujyQCO5b087J2DNprk0prNrwD4H6bA1MgktP3ojpK2iHXKfaGe4jQHTjtXFXkWZBryD
	NkYykGGMMh4xx004+BBdSSXGckBQKDU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="eslnmnK/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=R0bFMfSQmAiR4R7u4OGiTL9L+yOue9pBltZEhnqo38w=; b=eslnmnK/Fby0VR4zb1/mKeZCLZ
	DOjph/Dw0u5GrkDwKqHSBRXk1gceTtuqJYg4BDmZaKQCemaA5q0mDDEEc0+JCXIzY0tvf2mGzrDO0
	3Hyvbw9h7V76gWnjonOCZ+T/KSmylsVj55R45EOXCYKgzjv7M1bGuJi1ntSJxMYABxdZMUUriUtiH
	hJVShixpS42kQYAQTcMKciFVE5lwxWfYKZcx6WyY8z8WJCl4h6JJ/XcMrQR+QBhYZgOz/bCH6lP82
	iWMr0TVqTcigKcg5e2r2HuFrxa/gAlk2iaFbO4JCzkjnaAq/Zr4THB3ALb6JakqPzz7ojZm3F5WV7
	Hmk61tOg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vISt3-0000000HFKB-2W7K;
	Mon, 10 Nov 2025 14:28:53 +0000
Date: Mon, 10 Nov 2025 14:28:53 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Message-ID: <aRH2pdhMBQ-20IC9@casper.infradead.org>
References: <20251110113254.77822-1-shivankg@amd.com>
 <aRHs3pA2kOr_uD3k@casper.infradead.org>
 <b7313a45-c36e-4390-a0b8-46f412474f86@lucifer.local>
 <39c8a4ed-53b5-48e3-baea-f67cc1e8be4f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39c8a4ed-53b5-48e3-baea-f67cc1e8be4f@amd.com>
X-Stat-Signature: cnk36co1hxpy4fa73qz4554aomsokah9
X-Rspam-User: 
X-Rspamd-Queue-Id: D5BE3C000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1762784944-557710
X-HE-Meta: U2FsdGVkX18cl6HB/XNxvom3Q+KX7Aq1zJ/sQVhWKHIT6Pidkt0Gao1KESy7tzxt2Cj80XWTjX0R21S7OylDuENHt+Q3Nb2+Wr8hFE9NnoLwMgAZ2PdcyJ+hnXOgCW5Q58LjxLYN7tExYwRtBWUoUdCtG5vnH3tyB/vfPTYmLuOWWGTR24wkVDGrgMjh0B9Lhx+xO8yQuvNLZZe2WSk9RD+vzGyoNAZjlky4I0Vo6FLGdBgRdSnp4bl2RxDVbbskvw6RU6TtbwuMbRdinpdvzgECgD4WlUrIaGfJpcN4qwQa4BQs6jKmoBev5HVuYFVTs/R3/VC3BVUrzTGWx3wmB7BlHncW6uMRIoNdZ2qG6pmrpWUDZO4hHsWbUUYXqQ1u6IYNlCrz24IHC6U2iZEh+gaJ7AlfF+um3ZBTAR8OWJDiUF001ExiVKaiU+uyNKzY+mUXZUE5G1h4c4dG1WK5LHzVzLf6gvy8feyTicPuNUld5TcKEYZoaTiwUcFjCZDgQgvNaEPg9D8QnR0oc1TPOi335mtACzW6Vl9tDl2A1dMxRtM5WKC1UrsOhNwrTtbFABrfliPSPz8Waeog/nSgz/tcs9BEqGW2UbyGoR/h5ZUimKiN7vf0Qci77/hGkqO72i5pO+9+E5O+WLvQO9q5Op/Ds3EIDJBBa1kgAbPHw+CiBtzaSbk6hk7XLIU/FCAKhklhdCA85sFVxa0o78VgtIpuCwGlwjSQoVxU2OgJlULP9N7pgY9JB0zzYkVp0oaDHejumMRCseSEkbHH/9OmojNpz6Gn6odKJEyjltGzv0Iq9TSddYtxoAPvmXZrg0jXIWyiyiK3UhOFzl0JJAn/bkkWdwnz2JR3tLKAnY8oOE8Z+qbHW/RJk/2QHIsZ2w7Ws5LzftUxpEBaaECSK0arHxv4do2SumJKviHcCr1D1F0oDfRCJfAP3OlAV7v44WaEhvuw6IkezWp60yROPfE
 hOJyi8Q9
 97DkD3GWY1KoqMwn6Zzvs+iMiJrD9+wjhWqAAACtqW+19XxYhzoyQWKfPNCgKryZpu69K0ui9HrS2tqynQ263qkLbOrGPSRHt6zC0BgY7UqBarxWKoSxgCjoC1ZS5kEFhOghoGDPfFGigaIhrOfZKHm5HkOp7fZR3XO8hE+WApvHve3beGc5P67mBnLcqhD8cQ68iP/1op86DuCZJtikr1XK9X1aU91LIQcxDyXEIwd4BoYwWKCvq5h4JmMZXHyDY2QwyyCSPnwWa5pBW+SAvGJMi8xBlKbqZjjDxXGi7471QnlY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 07:50:17PM +0530, Garg, Shivank wrote:
> The issue is copying those binary to a freshly mounted filesystem.
> The page cache folios remain dirty until background writeback completes.
> 
> Reproduces 100% for me: fresh XFS/EXT4 mount -> copy binary -> execute -> MADV_COLLAPSE fails.

Yes, but this is an uncommon thing to do.  Really, it's the kind of
thing you do when you're testing something (like, whether ext4 supports
large folios, and whether that yields a performance improvement).
It's more reasonable to change userspace than the kernel to solve this
problem you're having.

