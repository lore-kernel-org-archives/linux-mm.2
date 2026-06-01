Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA6C5CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 20:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72F16B0179; Mon,  1 Jun 2026 16:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4AF96B01F4; Mon,  1 Jun 2026 16:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89346B0199; Mon,  1 Jun 2026 16:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A66B36B04B4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:03:03 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3CC32C2760
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:03:03 +0000 (UTC)
X-FDA: 84832417446.03.BA20AC1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 780EF18000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 20:03:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DCoLN5+0;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780344181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAqQ33Zmo2XOpsCnN70itqavnjXkkjUWiyAHthdaBDQ=;
	b=fsoxF2INs0g9dxCqmmT7KCMcxy8eu6oT4RdB2j175XPV0HWlw3r+qIcoI2WZx+L2Q6FN4H
	evVUaBK6GSqz5mZkPlK2i91p++Tv9IcAJr1M8pEd3SqlOv+xZw2s6UDeR3JcStQbkYG6WL
	X9CC+/M/JpcP63THrCCWQ7QROcHKA5g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780344181;
	b=2hgmWhuF5dul9tcJNUKhEt5e3eY2FLLtGK7McPTBwJfeJgXWo0OfcwUWbnXOZfQBumzA9l
	OrYd3pOTvD3h1Co+BVblNgFg1AkpgXJO/ZlwLeVgQIFo3jVSQYeoQEm6TEeRnfhptD7Gdi
	0Joq7a2kRyke0jXs95nrOBuwHsMiXG4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DCoLN5+0;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0483601E5;
	Mon,  1 Jun 2026 20:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4161C1F00893;
	Mon,  1 Jun 2026 20:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780344180;
	bh=iAqQ33Zmo2XOpsCnN70itqavnjXkkjUWiyAHthdaBDQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DCoLN5+02nCJr5BvocelbIKKk9IhUD63ylOM/juDBrNeOAfHccgRu6RMEM2NHgzys
	 tboDZvVVjfSecEGqevxps79znmAHa7Ba+zJyGmv+ANI544RT2y62nKVcKied18g0Ni
	 HzpjzV4PJKDmWgiCk0xrVI48O7aBt+7OxYLCsnlE=
Date: Mon, 1 Jun 2026 13:02:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oscar Salvador <osalvador@suse.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Borislav Petkov
 <bp@alien8.de>, Karsten Desler <kdesler@soohrt.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] arch,x86: Skip setting align_offset for hugetlb
 mappings
Message-Id: <20260601130259.08e03bd738cf40dfcd9744d5@linux-foundation.org>
In-Reply-To: <20260601125015.216110-1-osalvador@suse.de>
References: <20260601125015.216110-1-osalvador@suse.de>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 780EF18000B
X-Stat-Signature: xiq715jxno6nizabz7xz7rsqsujpxd81
X-HE-Tag: 1780344181-17114
X-HE-Meta: U2FsdGVkX18WaJhTajuN4zUDsmakvK+eu4lWsm71JZ1rifzWSr0mhgl7hJ9eNG1SmYoxT98NROcy42ntjKBvXS3cNlAnnmEGkjMf8nWDEwvioNuqP11c5arODQHNXi/66zw/Sbi4AE6AGCdDidfFVlHgK725FlfaT5bq/Xot62oxOCFnFv+CnPVYmvKanfg1bf2KqfBJeR5T5wj5reZNUDHtABDYLyDaYuOBa+p6rMPn8XNGTUf/ixG77sBDDwWhL6W7CPVPOeIFB0UT8d4BwRXvINTRBw0S+07yh4mtwLzwmZe+ocx87uu6Xw11I4ZYIpd4it3vtWy/6+4Topant2Q/VJgYCYxx+0aQAfWM5AUbx5qH1HM7ioG1KV6DZ/rH688xUd9KchO5YQ7XIC8u7uhN73XKV0rKoY3i/eDBWaHNA/IKrHYpe7b9QvZTkVJiONj6cOTsA4PgOtvrYgNBsSehfkPK1z01eInHkbPdJKQmqKwoOPAOU1/LUt0IV45stHQJ/FTJRXOQcStI6XcpqNYrq+UFCVNkJiBa7gY2W0ghJ4lNkxgruSbWk0psfPW3ng/tEJ0qJb+5coLIdNhvkX6vqbu8r/3ADiXjhbhpC97yywnRmIdMB1umDXgDnGooAY2JP0CTTYg1pfI9vK/HjHMclybw/cI1yhC+0KyLRv6e8aCPJySUKkco835h85Pj0dNj2wcCEng89QdHHVKAELc+RpjdePxHKGlyHE5YlqGmcvTSPawIF5UlMqsiKalY73QZ0/6Bu/Jxndn+eD2hWXGsyPVKCU/nRpXWXPjwZm2iI1ePAkLl5zEiYcSda+2RAJtTpSwHDD60VcFqMomci9oamtdTirvxLTdAMic2xotDBL1UxMpIwGSENJ8GwGgEeJdKNWR0K+tTJCZAzFqXiuRHzwn09G5vHOAkEhCKp7CnaN51olBkcmCa09fuIiyhnRupl/vNT4v/k0wgw/b
 VGMp8KLI
 Cpi8jCYc3lynySz5QGanewR3XE913X0rU2WrPjcscUSMF8umvet06cYO+jpNTxSEIo5h+D4oLZiBTZm6jT/TpPCbELN8qBlZIfZtZb280Y4qfpUyFYXzkmVHsoMeKG0cn3KWV/l0F3pqvNNB5AaaCvoihq9y9bgLoqAR6qTk8DUkCxmrPjqRn3oWFWvlnhx+RMW3TcujVLwJDty6zAJGpGSZAja0QaFRdVC2YhaWAAvRAijiRLy6T9/k00r65+dTkrJf2uAzk9nmJpWXZstqC8fXd0UMr79VUWXdHbGhj1nJxn/Az9BRyZMIL9uM6CdX4IfLjPEHY9LyaE75x+dOYBJ8cEBv2Qw5MvbTlDHXMZL+Vz8px8dGWCgI5Vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 14:50:15 +0200 Oscar Salvador <osalvador@suse.de> wrote:

> On x86, arch_get_unmapped_area{_topdown} set align_offset in order to avoid
> cache aliasing on I$ on AMD family 15h when 'align_va_addr' is enabled.
> Prior to commit 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags"),
> we did not have to worry about that because hugetlb specific code did not set
> align_offset, but above commit got rid of hugetlb specific code and started to route
> hugetlb mappings through the generic interface.
> Doing that has the effect of handling non-aligned hugetlb mappings to userspace,
> which is plain wrong.
> 
> So, skip setting align_offset if we are dealing with a hugetlb mapping.

Cool.

> Fixes: 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags")
> Reported-by: Karsten Desler <kdesler@soohrt.org>
> Closes: https://lore.kernel.org/linux-mm/20260527143643.GO31091@soohrt.org/

Ah, there it is.  "the kernel later BUGs".  We'd prefer it not do that so I'll cc:stable.

Thanks for including the link.  And thanks Karsten for reporting and
testing.

> So, let me say two things:
> 1) Karsten tested below patch and reported it was working fine for him.
>    Did not stamp his Tested-by though, because it was not explicitly provided.

This often happens - testers (well, confirmers) don't formally add the
tag.  Often these people aren't regular kernel developers and simply
don't know the conventions.  But if I see that email, I'll add the
Tested-by: because that's what happened.

> 2) This is a hack, I know, and I should probably be flagellated for this but
>    since this is a regression, I went for the quick/easy-to-apply fix, so it can
>    be easily backported.

That works (the patch, not the flagellation).

>    Having said that, I already made my mind to fix this in a better way, which would
>    involve getting rid of hugetlb-specific code and do the masking off as we do for
>    THP, but for that I need to refactor the code and that would not be so easy
>    to backported. Just so you understand the reasoning behind.

Great, thanks, flagellation is excused.



