Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E15E83EF9
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 09:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7578E6B00AF; Wed,  4 Feb 2026 04:02:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7375C6B00B0; Wed,  4 Feb 2026 04:02:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6819D6B00B1; Wed,  4 Feb 2026 04:02:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 54DAC6B00AF
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:02:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04152C282B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:02:28 +0000 (UTC)
X-FDA: 84406183218.22.0D34F08
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8DE1B1C0010
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:02:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770195747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GS07NpniJJnO1A2dWw9pIOa4Sx158SLcA5jFTrGUeW4=;
	b=jowjn1E7aI+UhakNlatjAYvFr2oQqRR0GOb5FeG39nVl/NYnsKuBO1ss0WOdMs7LWOJVgc
	RtVr/tZQIiqeZCgiqiP+F8pfW4LkNLt3BQfFDY15a/Z5sl4d8Wi3pJO8syw0Zt6gCM0QWg
	OXn/xFKNfZ/WAM6FcT0fIl7MIRLkTQw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770195747; a=rsa-sha256;
	cv=none;
	b=nXkVygCN/Ivvc0Ol9nYyQQQI6nkSAxputYt0Mm8vFWEFTARGeAtsvcj5A7hN6Pbv7Wb/FY
	YzYSHr53t85p22EAEmNWCK+VqQChlyMgK8DTZQLR1vH5UlUwG5xNG26b5QOKo5PS3df8qz
	sr7RUR2LT5t+lTqG3ZMgPCkV/xxnR18=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61492DaN3715156;
	Wed, 4 Feb 2026 03:02:14 -0600
Message-ID: <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Date: Wed, 04 Feb 2026 20:02:13 +1100
In-Reply-To: <aYL3zxuTLT8N7C8-@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <aYJBBs17B-SQXFqq@kernel.org>
	 <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
	 <aYL3zxuTLT8N7C8-@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 8DE1B1C0010
X-Stat-Signature: mfpmbb9tenmhpq9fqbmg5emazcgjfcxu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770195745-382992
X-HE-Meta: U2FsdGVkX19JOP/bIokNchutb49tSP9dbfOO6pORXvzjiQaOmDJsd5yLbU5xt8toIsRTNbI4Rf/8ROIHTI6QeJrhva68PqK9RCFm5iVYwAv9ovgdrAbxeBZAdAI9a6cqhHhubNZZivdeRXmj4WMcF9Q6ZiuJHuLkIiZM0m5PXlV1GI+WgHsZDB0YqKw3ntyEz9NiMNezZ2lGqwc07vDKe+euG12c8uy1ZHi5KbLYTDFTWEGkZBcuS6KkmqeOEjnvyeQdqHQFFa3fxG8y1RXSOZR/NDQxw1fWF8VtpWXEt3sMi/FjEWLxnHheHKUyZHN/l25uWrRPBKwlv5SZyaCbU3s6fpnLqqqgClq2U8XbxU0RE6Ievss5Q3PzBF0rkwziTQpt4DQOw60RJq9VhJOvVcvyowOXN5VGtvDIVifQdPi7MU6r5EnFeGd9/VSIfd6PuF8xBYQD6mXi0QtNp9JBxp51HspO0SCEjtQw0pp4T1xI/qSmqaO0l7ECNI1WBNlYi0DSCAODbxEiF8SaDtNnW5VGd+hgAvyNZTMJXa/b6nAf+gdVPxZLq/b4oGroDX7eH4RrbwDpIQVNbTjyHFefSjJ3+IfJXOtP//dFtSuOYeEYb6EF5hPYQRJie+uzkVUI2i1yFC7THAuQFdRUjBGWyRwoEknhOd/HiRv05MYnK2WwqCTwa6nH6JKRqvWwz8YoeZbMeXHNASd6l00zWHyQQES+/hDxxw5z29cacxv+f0kskKmOvn8vDKy3zCuHoLs49U6qrR1BgwDI4hDW7if/ERU6KcxI4HELS/37wqsy2dlJKkqlAoAP/ZjzJdslm/hT43auRNcd85sUFE8tdyuhBgPUMAPTl1hvmA7c9FNb1ns0X7YIsSXI8fVDoJHEPE6C5WdNWeHOVChFZvZXUnx2exq889Mx6SizUaCE+8FNT+EU85SPDkYB4/rUt91elbFzJv58U0MGhRQCyTsb/QW
 62ZXC0Uw
 1Pz3YD6f9aCoYw3rwneuajQ4+em852zCaX72T3plVoNb3Aq9/rcXB1mteY3xLF8cajI0r9oQahDTmN2G65zWNymifg/2Gc1BdcHWfORUiDJE0GwFvPUiePGMxxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-02-04 at 09:39 +0200, Mike Rapoport wrote:
> > I might be missing something but I don't see what would restrict
> > this
> > to the early pre-initialized struct pages other than that
> > early_page_initialised() test, so we can't rely on anything in
> > struct
> > page inside memblock_free_pages().
>=20
> Right, we can't rely on PG_Reserved being cleared for uninitialized
> pages :/
>=20
> But I overlooked an easier and actually reliable way: use
> free_reserved_area() instead of memblock_free_late().

You mean replace all callers of memblock_free_late() and kill it ? Or
make memblock_free_late() use free_reserved_area() instead of
memblock_free_pages() ? :-)

The former misses:
 - totalram_pages_inc() and kmemleak_free_part_phys() in
memblock_free_late()

They also both miss as far as I can tell:

	if (!kmsan_memblock_free_pages(page, order)) {
		/* KMSAN will take care of these pages. */
		return;
	}

But I don't know if that matters, I don't know anything about kmsan :-)

There are other subtle differences between the two implementations
which probably boil down to the same thing but it's been a while and I
don't have time today to dig into the gory details :-)

ie, one does

	clear_page_tag_ref(page);
	__free_pages_core(page, order, MEMINIT_EARLY);

ie, clear_page_tag_ref() is done once for the whole "order" (though in
the memblock_free_late() order is always 0), then __free_pages_core()
which kind-of hard resets count to 0 etc...

The other one ends up setting the count to 1 then __free_page() which=20
does a LOT more "stuff" that is new to me since last I looked (such as
the pcp stuff), ie a lot more convoluted code path, but I don't know if
it differs practically for that use case :-)

I assume that the right approach here is to make memblock_free_late()
call free_reserved_area() instead of memblock_free_pages() so we
preserve totalram_pages_inc() and kmemleak_free_part_phys() but I might
be missing something (and I don't know about KMSAN).

Cheers,
Ben.

