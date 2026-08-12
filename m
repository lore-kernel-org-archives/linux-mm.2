Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07ADFC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00176B00BC; Wed, 12 Aug 2026 05:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB14E6B00C4; Wed, 12 Aug 2026 05:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEF3B6B00C5; Wed, 12 Aug 2026 05:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B663B6B00BC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:40:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AF5780131
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:40:12 +0000 (UTC)
X-FDA: 85092121464.02.5492583
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5D4591C0007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:40:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=g5NrxuZj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786527610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lptC3+bsQe9OhVLLZL0xbRgWdtc0K4Ssdaz+LY7bq7Y=;
	b=xGp7QxWXLIzDUyAbl66rdirOjrQso/f1s4G1rk4zTzamVDfRBKAcmGR3UWH+Q1YE96G1Lj
	pf/ejRcc7PqOJvDUqP8bJjA+wRbnjx8GGp6CRCW4PWguQpFwB6lepSB60a1fSl1j+JX6hz
	Hdygk66EIppJt5itt2mZic490PQUlN8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=g5NrxuZj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786527610;
	b=CyhwwjvsCGI0L9RlI3Vwx4eRwKfXg8iXREyEaIJ8mULcU9UQvEl9iJAAbzcdTlQDNuPKSU
	505vQ9qwihHA2LfWLQy1mzBDH9pHPviY6cCelr9Oe8B8AR3dA5rD027yZ/T9kcqugU2LU/
	nZpP9u+qoAtf3SmMLWsPPpitZOBJ2LE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A6351596;
	Wed, 12 Aug 2026 02:40:05 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 006FC3F632;
	Wed, 12 Aug 2026 02:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786527609; bh=ev4glunJmddrTbzF7PCDcRN30WkcDAddJrAQqh48rWk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g5NrxuZjQB9klOoODQiv4fCwQUmouyRDYnWJYKgnQvLAZQvGQOHbZuEoc9wMKuLTI
	 fe7n3tELw0qqiEZ5cnlxStDf+6caqQnLspdbRG1hoDuQIzrsgEY2wLf8/h9SPuVGZ+
	 wJLWh0JpvefPu/DqptOFEqpeS6i8LJSjr3L/qwCc=
Date: Wed, 12 Aug 2026 10:40:04 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 4/4] selftests: mm: test kmemleak's N-consecutive-scan
 leak confirmation
Message-ID: <anw_dDAEPUMvuVJL@arm.com>
References: <20260713-catalin_pto-v1-0-5b93b1131089@debian.org>
 <20260713-catalin_pto-v1-4-5b93b1131089@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713-catalin_pto-v1-4-5b93b1131089@debian.org>
X-Rspamd-Queue-Id: 5D4591C0007
X-Stat-Signature: h1c6putwxdkz4g36xjkmwfqc8kcjjygq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786527610-294668
X-HE-Meta: U2FsdGVkX18qv23/k0HiubPiBMCDDZVDaLWF5itZKBH4KyCRhLrBGDzuhiStBO46kaNKMaz6+xl+kk86ph0VbGOUkLK2rtjqWVtJWQQ8eOU+4ryvqn1AKsgw3AHov0JagYt7j6uxzucdOOpi1quHnkdErSY/QtcfMurFIBVHG+JSUpQLelnohzP/w71/mldTyP5aBMHPAztSXF/IUN2adSbT5z0dkUCBskL0zBGNz0kYeJp3dh0hF8J3B9kFT178eAf8xFFeLfIcT/j/IN5uGItpfEb/CRYO5NQxbjXF5LENM8kCctuCwfEGNm9WINMSiq7UZgElT0KGkg3YbUUP8VFwuDRG9zsoA1viUbOWz57aSAobm2KpkefZxFkmPrt9rT1bWmyB2/WAN7ySpOl3MU4AO+eKOGQGonEn9CYyioCPgVRuRQ+VUqdScRXCK0nMgPEjOHhMpLxYcMMtCRI32fhFSamNLHDTsjIE5B/oLuU20D8Ee8yiz2MJC+IhvwSOI+oAW1olVCqPiMub846hEGk7nyI3w087VpbLTLhtA4zP3Q3/qLacuK4muAFSbPQqCwx+LbtACGxTHIPguxU1B1qBeWER3IToclNtUkBdY2fovk3CrTcnYuVAJW2oAlIi+aPkMBMSBe7cSPvgPeVHKN5V2dhRtUaL0pyol1Gnmk4ATTyKUAUVRb+7LGfr9FSJoZkoK/1/KTdkbtEXHwLW7/Lb4XYRmNgVSzJf4jD0UsM8p1VKUFjUF7G9W+tZY/2N20Doolsa1D1JyBp6Lr3PBM61zzibI1GdxLVnrF/XB2ZVsPHIaJxI6CCDM0gezdO2Y934/K3bD+y/F1GAsi3EJbIGRAoZ0aWqd+PBh9jDadfRUaQ3bY8ksouRT9hp43Gaj3XRfMtZuhBTLYSuoefofgLhxlApqlartpkwUBMOimiIFEeCNqTh8OTSnf46DmhnmVA1H8ovc4ygzxmAnF8
 GGm8WtiL
 TcOIPeMHqpLbpQOYbfKdIfVwu5wNIHMWWsOIGb7jxTYCv9JMiElsgX85juo0qpgTPeg18XlkdHg5Z2mQqj7Ax+yJi8P2Lv4HUim8Y9uneArlxUookVIHJXtsJ/EvdTfgIW5V0tLaNqAL4HS+zrZez0zSWvwuExiz68jsMVwRpyW4ZDlCDaWr0RhSW1/04c7Ss9KiEicnMzNhWovysp5arge6gcx2iLD+Z+f8Wb0Ja5FiJ6xKLVTnYIzilwKpd0Adl7J0jgMzD9KpyX+Zi11Z0ie1d2GAuDazOjB1A8G82CeKrsSahEm20t3+WOYTOKwex03nI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 04:48:07AM -0700, Breno Leitao wrote:
> Add a functional test for the min_unref_scans kmemleak module parameter.
> Using samples/kmemleak's helper module it checks that min_unref_scans=1
> reports an orphan on the first scan, min_unref_scans=2 reports nothing on
> the first scan but does on the second, and that the parameter reads back
> what was written.
> 
> It counts only the helper module's own orphans (matched by their
> [kmemleak_test] backtrace, with the module kept loaded so the symbols
> resolve) so unrelated leaks already present on the system do not perturb
> the result. The test skips when run as non-root, without
> CONFIG_DEBUG_KMEMLEAK / CONFIG_SAMPLE_KMEMLEAK, on a kernel without the
> parameter, or when the helper yields no detectable orphan.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

