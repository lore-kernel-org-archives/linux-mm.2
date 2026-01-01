Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 769AFEEB575
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 01:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A3C6B0005; Wed, 31 Dec 2025 20:05:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947B56B0089; Wed, 31 Dec 2025 20:05:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829B36B008A; Wed, 31 Dec 2025 20:05:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7338C6B0005
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 20:05:14 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CB7EBE97D
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:05:14 +0000 (UTC)
X-FDA: 84281601348.04.89E7A5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 734A0C0003
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 01:05:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SKQ0IkXP;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767229512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IT4veayX7A6cLpljY9kKusWi2z0Y5eleGFMJRwiwj7I=;
	b=BK8+CGg/aiqEuB/l1rdmX0lTE/260AQaXKXEGQ/Jwyfrntn213j+zcg0cJ8PS7Dl7+FG8M
	Jk0cY7/7B51hz6XCvYY78U/jEQJJUgZ+6GalhHsBpk9DFvgtK5BP6sq98NNj4asxxSyyJh
	6ccK0qdsdxYHvAVO4KvLo2sGFHQERus=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SKQ0IkXP;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767229512; a=rsa-sha256;
	cv=none;
	b=P+hY9EVGS7lnECWyECO0HfUlG0f9gf54vCHEl1pRKYWOjrw9rqthzwT3e7Fz5cXbjxZ4KT
	mgUnL3eQrjZ8kg2qdxkJI1jkAjG7DygsEWWnYGUNoAsxOtpAXMBIfS52ho6MBdOdTGVcFa
	EkS3MN4RR0quFxjFnqrXfwBSQXp7Clo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 399E343D2A;
	Thu,  1 Jan 2026 01:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A57C113D0;
	Thu,  1 Jan 2026 01:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767229511;
	bh=BPnj4T9ezcGeciKpRCEssGdjB2J5IjLkKcXB0gzCt48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKQ0IkXPS1+4xia5qTFMgU/zwNrJL31INeZqMym7gLHyadq/P2k5+JcDZGrsRpZDA
	 3lPq/29xdqE93fTkaSrD5Zw4R3y/0SSl1ThKL386zTmoHKWU0aBllZgfdb0MDJaMXC
	 hGMYDP5SBjTDTdf/BCuGKeHgJkmmV3EcTrClhFQSJqC54qAabcqonL1Y0dZ/ZcQ8Ea
	 KwWh+6QYbHee9wYnQGUR1PXnzFb6HIpx6TsYeothdFciXze49lI3hhecIfmrum3oOk
	 EmnsBMKIm9Pz8AZnZZyqP+u65wWq/N7qjif2vk3YgMiUacqWg6PFpGlVPpq42LM5+j
	 VpCTf9PrmOQvQ==
From: SeongJae Park <sj@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	akpm@linux-foundation.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	arnd@arndb.de,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: Re: [PATCH] mm/mmu_gather: remove @delay_remap of __tlb_remove_page_size()
Date: Wed, 31 Dec 2025 17:05:02 -0800
Message-ID: <20260101010503.87598-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251231030026.15938-1-richard.weiyang@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 734A0C0003
X-Stat-Signature: iihfzzqfaguaugr3kpnfehad447w68pn
X-HE-Tag: 1767229512-785857
X-HE-Meta: U2FsdGVkX19P8PRWF/+clFJy50wMn6RrhwsfmdNHBgAnI66rYR836Mrbml/L/taRg4ue0BiyRoG0V0p93Bs1m1QiuQvtYlNRnxPUSO+vScN2SkCjt59lOX/2tJWzhrJeXpDH8NmI0MXvxskw6vrDLHI3PyUmknAhNnn/CHVMJrB03QXz88BtGxlXfKoLvxsJdNRAm73atvSVq1kxchvOA32G9laotRrJ/MH6taU6Jc3PmPG5IHdX0nj7eG+cOs63+kGHQdzrcOD9S2v+8kwZaaEH73df1GCPKNafS1E1UVwQDVh3txtDUbDecTzv5ZP8AOGa5RweWd2cTqU5VMfaPxy+BajRvvFRe22GBu4Jb29Aa2Ens3k40drq3XOj1Sg/B3TffR0P3opAZbkYCsGk4RG8ZmHF9vfOHt+8eHkZwHOWtASPnkS489qP9vl6aQCtJF/Ts1OGGyhufcEn4ao+FefCx2tjLyXVx9srkv6kulmZTKgXFAdNKjgU6N3yB2jhT5j2f6K+bh7A8VsnHzmc8x3uenFBwg17eQpNAtT+ikUHl0kN8jGAqtLI/V6titqZykX6D0v0nxgkirYOB93LOrdq5vgGoR8tRlnN9hkW1UbU3v0zMewKYFKv3+ZyPWJ8BDsgGsivoPtKg55plvlPaZ9lK6S51VqDmkgb7KD6icigWo+Uem07ZKkS3dtbVwaF7z2wwycsqB3PiFC3yOR4hK/PsVm/pA1ORecgFtfX4TdBaIFCh/aSOy2QmB2luR44iZQ3H8e8I9y3F3i6lJ3KWqZcJ3MNpOYL3wEz4CyUxeIsBGgcVOkgId32KmRZtZOGAd1miIDCkq6Gt9hjcNl0uyeO+uS1VhyG+wcsU/GAJGynu2FH0gbq6FqsnEL4rYE8kwhk6Aki9FAvm3bWpAH6w8hfvOV0lcRKcDs/XkYRdYdp8lFu24UiQC+Pz9x45KtTrYS8q+QcLlTErZqYIQ3
 hun31Don
 QX0ngDLLrNBxDjwK3rqInAXFMxtCAiOGvl+3PB1ifrC94AdHQwYgV0U1sd6x1MswJHbv/67dM/tuLtLLBGTSTGiCJEiatUfoJjL+UdK8kuOHaXsitoowN1yEQy0+anNXYvj3veoGhPv1vNj7JFEQ+NMHS4IP7wJVlcI7H73P13zEf9ORlIKydgyXoLna0+U04urfDnyMubA1v10bfISFDYj28l4m6WLB02Q71jAfRCocveAUt53GdwMJX0m57gS7d615m4ugaikLfHaX5gmQF1QTIqXRpnsfwff/21K8kIrjJgrcod+29wyVhAmTBFfEoLG73/rgYSBozS7SaEnJTj++OWk6xm60WkZbWYITWUeJ/nXhhnCwW/Z4k5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 31 Dec 2025 03:00:26 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> Functioin __tlb_remove_page_size() is only used in
> tlb_remove_page_size() with @delay_remap set to false and it is passed
> directly to __tlb_remove_folio_pages_size().
> 
> Remove @delay_remap of __tlb_remove_page_size() and call
> __tlb_remove_folio_pages_size() with false @delay_remap.

Makes sense to me.

> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

