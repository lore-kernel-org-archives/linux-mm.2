Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFB21C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8871F6B0088; Mon, 28 Sep 2026 07:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838786B008A; Mon, 28 Sep 2026 07:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727CF6B008C; Mon, 28 Sep 2026 07:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2056B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:29:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CAF7DC011D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:29:51 +0000 (UTC)
X-FDA: 85262951382.26.F7AF96C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1F0FC4000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:29:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EqAdE900;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790594990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CJ5kjINHhTvLlIC4gUldiEPrQ0Od5Df/IMR+FjoeiVI=;
	b=aulbp0vW0G+e2JRMeypXR1ctxbhKq0C3FjgV/kCW186SykhKpksSsDGCGl4u7YQNR0GZ9S
	1ZYMtel9z/aDPABn1OmaZUDEzqZ+OHiN5V4Cbf84PBX0J/kR5RJ5OMLf06ds9Fjj6AsIBW
	3saGcLio9oEfC/aiTobjXP9lNun3w9Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EqAdE900;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790594990;
	b=PyXWYNulqNdeP6jB2a7k63Y9xEYqbMsZvaVgICJm70ocMkY1BiE7fjNgBHLGaDL1DGwSUp
	QgZA6QDS8wWovOSKiP4rsXotuVFPYEp67KRsc/ap23Ia9332/fbRxOQL5czUYOqbd5h486
	bpTxFu5sfvqixTROG8x2qxjj+9txmyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 632CC600D1;
	Mon, 28 Sep 2026 11:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4761F00893;
	Mon, 28 Sep 2026 11:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790594989;
	bh=CJ5kjINHhTvLlIC4gUldiEPrQ0Od5Df/IMR+FjoeiVI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EqAdE900qssN5xhvsE5kU1fwGiZv1o0KIbKETkKrd3+I1Tyfgc1URQb7S/ef/Jo/i
	 kSvCfqBYS1+uYNMMOTwRMJ3wsgo4piEcLKsDUNJFh/o1JFb3SEQ7PF0LNO3STqv6zJ
	 VpEaTsyDB0EsOy+Vnv2ssm8aUbMYc5jXOvcbyynrxRyexqLCgxImcprt4hhv8X7Arg
	 5T6DK2hjVkmBorT6UvpGIo83Td5UbQvJm0BQRMHsf5zusn0XdC5FvMuovC3LkR00km
	 m2XnhFljMXw/YYnfdgmYOQvEH59y2JXCpiK+WizjKF73suR+8FyqWgxyaEHubD/7D0
	 bh3TdJn8Sx9hQ==
Message-ID: <7ebe4591-2306-4b5c-b83e-6a2e34b52bd8@kernel.org>
Date: Mon, 28 Sep 2026 13:29:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] madvise: best-effort deferred writeback for shared file
 mappings
To: =?UTF-8?B?5aSp54u8?= <rockeet@gmail.com>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, "Lorenzo Stoakes (Arm)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
References: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1F0FC4000B
X-Rspam-User: 
X-Stat-Signature: mzer5x8npshei36rke3qam9167mr469u
X-HE-Tag: 1790594989-231266
X-HE-Meta: U2FsdGVkX19AJAGdw9QbvkyZNiFoILKElvzgFppGfT8HFOzRmtvz9Dh+iwK0rJXPg9rZ3uuccFttErzcv1YsQzyfX/8QYRFyvjE4CMJlN6dlcMZF/417M36XrX4/ZcKeGiFAAxdocLszJBcEG3qZP9In2CkjBDF7BEX3q5lFbf8oLAErpZN74T15P9DZWYTGqbGn4ENvccH5CB/rGesSZahzElB2SXYt+AgrfBXNRfdk+rdUwMpRPi0qB703pYEwYX1kdGNLiBaz4k1UeX4N4oQYgibJsSna4+h2xIUhquQG6JCRRN1y1wm3U41aKmFDC+CnxnWX3+BaBbJpqd5R1tRzYPTIROfdJzD53N0WD8TzBH+eiPB3mjKbHZU9NqGtpaDbYEyU8tleFvuXFBxqk42e4VP49/O8oX2qMeRmPhY5S1BEAXB3e/m/VQCkIDrUYiLJOusVCbUciE2lRtviNJgXqeQOrxUsvexUNEnERm2RNNrfe8C85IRX9cQR3OLDZOE6Drngv7kkK3SshZhtKdjKSPf/Tpp08ji/cdRcTMSVDYmsJTcJhyQlbwJAssXqi1/WHs+wGfFKQAwJSyP+UmPZ+EP+mN1QT7e/ujFx6zpR2kDaMz0slD0hWjg5+x1XOpEb4gmhgVgrwT6wZbFgXgunOSy5bIzvKt4nFnGWfreeQGxiY3oJHyO3ErdtMGZ6AyPyWbKqESMajhzvNY9G4AV2US0jBcPFHrnuABqILe009KgcEoJzVlNO+p6xixEgeBN/capK3x1tUXeLN59F+bDEPScS7JvzUpuL8YkRkFrdk/HtFYeW32tRYsNj983VdIl7yU0ccNYzrgQuzdMmjkmQSrZNNmvgZLJQ11zevf7NMG6u/40lp39taBlSxEceFXv8L0YP43ApqLNJJ7gitKT01noQ7vo/4OspwUkgMaArX5JBUHsbo4l6HrEmqUHSC2/ez2IvI9DJQL9MNVW
 tpwWmk0w
 EEhS+ddKYQmUHFo18df7NuerhZb2Z3JFRNeExzFaKUjJNkEwhViA+IS2bGIcqTH2nwM9dshq/jgZashDp3XGFoYndyHNz3T2UCgsKLh9sYjFXNS7Y11h1IVFip6qd/DlFjPGKt4xmduMQ8kXIr0w3/60EBSjD+IcX83sDzXFPKFbx35gM+EpDADlHqnuxols3w5ThewaRzPshYRlKxkY2lu5CGQS5WSVM5uBMIzPL9QkPiM6W+UJHO7Ki+RsZaO8IpJ5AIhknPLyhAX4a5T16b8m9rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 09:07, 天狼 wrote:
> Hello,

Hi,

> 
> I would like to request feedback on a mapping-scoped, best-effort hint
> to defer background writeback while an application is still constructing
> data in a writable MAP_SHARED mapping of a regular disk-backed file.
> This is a feature request, not a patch submission or a benchmark report.
> 
> Motivation
> ----------
> 
> Consider an application building a large data structure, for example
> 10 GiB, through multiple passes that repeatedly modify the same pages.
> After construction, it persists the file and publishes it for other
> processes to mmap and read.

Is it an option to just construct the data using anonymous memory and then
write()'in it once ready in one operation?

Why exactly are you using writable MAP_SHARED mappings?

> 
> Building directly in MAP_SHARED keeps the data in the file's page cache,
> which also serves the consumers. However, background writeback can write
> intermediate contents that subsequent construction passes dirty again.
> The application knows when construction ends, but cannot express that
> knowledge as a mapping-local writeback scheduling hint.
> 
> Building in private memory and then doing buffered writes adds a bulk
> copy into the file's page cache. Direct I/O does not itself populate that
> cache for subsequent file-mapped consumers. A memfd can share the build
> buffer, but requires a separate object for persistence and changes the
> consumer interface. Global dirty/writeback tuning is broader than this
> particular mapping and construction phase.
> 
> Proposed interface and behavior
> -------------------------------
> 
> Tentatively, a pair of madvise operations could express this:
> 
>     madvise(addr, len, MADV_DEFER_WRITEBACK);
>     /* Construct and repeatedly update the shared file mapping. */
>     madvise(addr, len, MADV_ALLOW_WRITEBACK);
>     /* Use existing synchronization calls if durability is required. */
> 
> The names are placeholders for discussion, not existing constants.

I don't think this behavior should be part of madvise. Way too specific.

-- 
Cheers,

David

