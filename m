Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5296C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42C96B0099; Wed,  9 Sep 2026 06:15:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E138F6B009D; Wed,  9 Sep 2026 06:15:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D299A6B00A4; Wed,  9 Sep 2026 06:15:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9C346B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:15:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AA0E1A0179
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:15:38 +0000 (UTC)
X-FDA: 85193817156.25.27765D7
Received: from flow-a4-smtp.messagingengine.com (flow-a4-smtp.messagingengine.com [103.168.172.139])
	by imf21.hostedemail.com (Postfix) with ESMTP id 433F81C0003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:15:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="E Mk86vK";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=xdqi4c4T;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="E Mk86vK";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=xdqi4c4T;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788948936;
	b=w+9euAruuqgnpxO3EFL9yJse/ViHJpdhxNnAV6LPsjAFpfGPwglYxSq/TFPQ0s/Z2T0iLe
	rs0LlxltKu0PK91IUbcjamKVuNl0uxdRQy6AHn55N62m4I49G7klKqK/R2+d0li7v0dwba
	X67yxcMiIopYKQ0aiMtV1bxucdzExz4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788948936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0bA2UOwepFFOmS/bv5Uzc5Fj7QM31mNBWzJWBJpT/A=;
	b=Q9oCTr+YNuGSrQ5QoZQ0J8B6i2CiDwuMnhev2yhBWTqyiVF/Oaj/hwoEFmObjoX1bJU1oD
	uWE37+4hrP+Be4v1r/Joe/iKC/5abLVPzdw2cTzc3ojiJhphdteQ8gkzTxQCa5uoQblk62
	aQ2Fvo3TJIkKwJ2OGk9F/A3Fa791SVk=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.phl.internal (Postfix) with ESMTP id C315C138023A;
	Wed,  9 Sep 2026 06:15:35 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 09 Sep 2026 06:15:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788948935; x=
	1788956135; bh=l0bA2UOwepFFOmS/bv5Uzc5Fj7QM31mNBWzJWBJpT/A=; b=E
	Mk86vK/XwrtS9J37WZuFfmJ5SVpJDHDZ6hEJ8/IXG30fs2WD+B0ufH5VZFUTp292
	jMOuh/xKSUtcqZ8hiBLpOyvteE1BuGHOG9HvywMlI0hwEgaDKys2a9XzQ+sEkqHO
	M/+cZ7LVwJlZceL0cUnyGzzcwnYBvfy5fJ/D8GTLBmRcLfG3+Ke4EVFZcSZs0JXk
	/8ANZYCWLjLkbXkfZrFoXWcY1Bakady40rjSUvlJjLPsnPDnTF6F+XewmrE9LrHK
	YY6yyOgfO5sIcvhdh7BMc4wPd65vHXtSLOG3WGiV6Gzobzei7naXe2nLiNybLrgW
	O+G0HaVbH/9HzzShnYDtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1788948935; x=1788956135; bh=l0bA2UOwepFFOmS/bv5Uzc5Fj7QM31mNBWz
	JWBJpT/A=; b=xdqi4c4TC2EKOMc6mxGpNWM+fvaddmCXeGS11XeaRuRt7M2BDEW
	BuJchR8oIjLZm3fGlpVcP9diLG3tV9CGFpJUFy35p/wAFFZiQ5YyDfSM+7FzSsbD
	VjYTsKfRLJJC54Tgip8/mqeGmVdqEy1bCKlIDw6FcxcTx3q83FF17sWqbWu1EB7H
	JtrtZ00WLoSx9PFCyg35BDGSfOBmNm36KL8mrMnZ0Y7PhhxmkCQBQPLzW0DZc1IA
	TIF6kHMha7NNegTal9MhKFzn0xYe2yfjC/q3Hb70tKT9TKu3EvL1QPZvdFV5x0EM
	tsb6RDHlagupN5u+hXBiXeP6HVmNNaD8d9g==
X-ME-Sender: <xms:xzGhatUAaFDvmvipLNsi9G-JyJiuqY3hJG3-0yKVcQbeJrZNbNeNFQ>
    <xme:xzGhavk_0CYEIW7IMPC9Dy57zl-oCd9JwmD5wyz6D8b95RYoVoa9Se2ks43X-sgAw
    AkOCsABGQCHUeD8YSuKjkolVLIps1hhCe4m2tkpToPzIk6xcbc-9MM9Fg>
X-ME-Received: <xmr:xzGhatun6zlTZCxkwaSgC4dgy4Obno20MG8dP9UM38mxvYOpl5WVmqvP3Q0>
X-ME-Proxy-Cause: dmFkZTEUqK0n663bU8dHG/gXAim5or8IDZuAMT9spUIRS7o1wQxh4f32BZUUt41uBSxvbY
    DWEH4wBzf4fX/tU6Fe9b/UvDQQ0roIkvnNsTesZI9aPxwEDI8S2XaBrAFOz/JVvzPWk4GF
    0W/CnzpEgT1GukTwvX2x5EynFNHqZa91yCXtlA6py88ymBFZ0qGpBPmnBWEroBPrxOoZ6J
    PqxtX3nPwiTYzSUIvS++f61uroxeRxzzZwFRBYthF8hRDAgYghR75AEnzTZbKrjRQCYzoK
    UupKJGVHx02xDqQX/sBTbIoAS8d0ijH6w/AR1PW2zkt8ss3DkUpKKE6dfOB3tro1rsAmBf
    uHeBeKkb7LoD3Po4skHeQe3Uspt+l3Gq1VlrJ5a6fnnbHxbUcjlKfrCAKqxE9l418CYF5J
    HQs0518a8Aoh8vHgCOZY7J6rYFMHe6HIBNE5Dl4MUNHCPW473nmVgiIW8SyUqM2YYkMiOf
    mLjR+f4JylidrCUHOGtjuAgJAPK+CsuC/1dSGLw9TfW2GGosMYDNHuzQw7SIsjb/70JD/5
    EJqKYT+G60OzjQ2RhQsUxYnlrJQrsIT2h2yFJvKMD18gPCH5dM9Mtc6XusEacbzsurMclR
    rq2n8fJ2FFEHXk9Zhzcu1t9gDC2A0BWbL6yHfCHptYj/aZGmSLMR8s6FE7nA
X-ME-Proxy: <xmx:xzGhaohW7Svp05zxtpu383xfOj-Pvk0PxIihb73lf-TLnh53Z-dxsA>
    <xmx:xzGhahS9zW_QrY6EM3-A7DeAA5QdQkwfNHnGvMKkU5VmfsTMFFKGkw>
    <xmx:xzGhao8sGJPohqw-JMDg1l0cmRId1NX0HquDq7G5V6woFP4IOUBRPA>
    <xmx:xzGhatJXlaFAqYw5pHoqdjpnQwXwaSHjo69R-pUidKf5nnXBAvar9w>
    <xmx:xzGhaoByYJea67cl2E40ENZtIHPA_Y36Cmd5EhNgYpInH2bg06n7cfBf>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 9 Sep 2026 06:15:34 -0400 (EDT)
Date: Wed, 9 Sep 2026 11:15:33 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Usama Arif <usama.arif@linux.dev>
Cc: akpm@linux-foundation.org, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J. Wong" <djwong@kernel.org>, 
	Carlos Maiolino <cem@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [RFC PATCH 0/5] mm: sub-folio dirty tracking for PTE-mapped mmap
 writes
Message-ID: <aqEwlUNIYYUEfdje@thinkstation>
References: <20260903182943.662461-1-kirill@shutemov.name>
 <20260909100240.635595-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909100240.635595-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 433F81C0003
X-Stat-Signature: op6f55wgfuqngksp9o51b3dejfs7buon
X-Rspamd-Server: rspam01
X-HE-Tag: 1788948936-236209
X-HE-Meta: U2FsdGVkX1+YCUT6D68dqY2hT7eXe/DpjQgkFUR+y9nGrw4Wu0Z+XgG5jkypXW9mi7pBQVakHG+hiwd4CzyPxw9ag/tzfXMb+yQ1sMoY6icB/Psxk77fyLLuSpKjvHue1NFoiWIpy4TwqsqgP25fe1FmA61RrgPzGU1w1Su061ofRIKqFWE1iqq8Huifs7At61ZgCn5Qzv8Sk3a+Q/kgJ+PtsaU7PuxnyUu/tNLmAFJe9pevkoiTAgC13PdzfxdCf6tUSMRlF2091aWBAOu+w4M9K9RQyqCXXj+y5rFI11NqlsULrHSsizv0IEUJyRz9xKgKGyELyxu0iEZfJ7MEgl4Hy2vX/jU2JVMbrKXQGabywF72rVksCoRbp9A+TlbkHngk1UGlO9/rr4khnAfrxOAGNaQZOxImfznSwzZXlwZBU0PmxDtot6ekWsRILK20ytCivRiQXJ4l/+jpNvGdQrygtPnSuUDGuyT6yBmktJgzFtztrNpCChPY3EOds39aSsQ+BbyFTq+EjAE9AelGTmjvsCVQgd3ns96UFz7a5U6I1UP3t0+d1535My5fR5gZLFvIzrARoohQDDTUc6CgBdybuVQ5hM+plcGXM2myvHzgUt11PbOYM/lARIH9t3x1wLBivwwT9NrHtosEK3yWNgBLCIen9i1ftTS2S9deY2qCwiWdB20Ff+vam1CBRcccEEXog4x369nAuQNcH1VwhRhTkNBB3asxI8bxmCXjCHfHGJwsU94jAGwgg9pg1I06pvqOFSaLjylCX+Ij3bz2uu/RB0QhK7Ff5UcKhapVuAace5Hiv9oEYBII4Alhy0sOVZTvDeQRE/RRuUJPc/1Rfsu3S9tHoXEhsn6oBXhGngBExjvAl6tlQzixgnpLFzZ3ZE8iiWgRqDphoCL/kcQMNnovepGrw6sTSTUaRqDsaxxaMs0/zgXsGK6XatsGRIROPKvnSlLo1QRx912YJsK
 Je7EEvix
 NA36oTutealryAW0/zrHjhTG4V8s4ZzEI3TLoiLGLKTBz712++cl7UELnOc8cNY75my8TGnrf2a7YE6qaxTIQIPIiNN2ViKOhmlEiwiK+ucUDBGZlZplK9AxKMSR63H54aOEBk6rV94ywRJgLoL3bBA9yti+USAav68wpxScfykG88YKO36Xburhl3HaxVDCNsGgS0kDdmpp8ncf2gLjNnzz87uU1XPZIO5Nk2e4dSICR5SFi7pWL0ucfllK/R2bnSDMr0iI4KWnxESmMbNsgHQTM6xwlMeM6IMF13+6E57l8PsBM8VHGiQkf820lQUCIDIGFyuqCNBXn1UfSQXW1g4XlmQ50bkjiqbTxEuradbDjCZTTXzDftnAFPShH1SV/UzitwMUytLiSSV0faJbJ3XwaWXtTPSFgmI3PQtCDphHHGbBqX6zDWEdEFq3OJrALJFBjN3TEvGhd31f3xrWONtnJ3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:02:39AM -0700, Usama Arif wrote:
> On Thu,  3 Sep 2026 19:29:38 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > 
> > A store through a shared file mapping dirties the whole folio. With large
> > page cache folios that turns a 4K store into 2M of writeback: one dirty
> > bit per folio, and writeback has no way to know which part changed.
> > 
> > XFS already knows better. iomap tracks dirty state per block and
> > iomap_writeback_folio() submits only the dirty ranges, and the buffered
> > write path sets just the range it copied. Only the mmap path throws that
> > away, because iomap_dirty_folio() covers the whole folio.
> > 
> > Narrowing the dirtying at page_mkwrite() time does not work on its own:
> > set_pte_range() batch-maps a whole folio writable on the first shared
> > write fault, so the stores that follow never fault and never reach the
> > filesystem.
> > 
> > So harvest the hardware instead. folio_clear_dirty_for_io() already calls
> > folio_mkclean(), whose rmap walk reads pte_dirty() for every entry of the
> > folio and throws it away. Those bits are the only record of which parts
> > of a large folio were written through a mapping. Collect them there and
> > hand the filesystem the runs that were dirty, through a new
> > a_ops->dirty_folio_range().
> > 
> > All of this is about PTE-mapped folios. A PMD-mapped folio has a single
> > dirty bit for the 2M it maps, so there is nothing finer to harvest, and
> > it keeps writing back whole. Keeping shared write faults off PMDs is a
> > separate patch and not part of this posting.
> > 
> > On a 512M file in 2M folios on XFS, storing one byte per folio and
> > calling msync() wrote 512M before and writes 1M after, with identical
> > minor fault counts.
> 
> Hi Kiryl,
> 
> The motivation makes sense to me. I will look into the patches.
> 
> Just wanted to check, the above xfs example, is that on an ARM host?

No, that was x86. But the math is the same on any arch with 2M THP/mTHP
in page cache and 4k PAGE_SIZE.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

