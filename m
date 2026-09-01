Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18764C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68406B0095; Tue,  1 Sep 2026 04:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D193D6B00A1; Tue,  1 Sep 2026 04:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2EF66B00A5; Tue,  1 Sep 2026 04:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9634A6B0095
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:35:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F10411602E7
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:35:03 +0000 (UTC)
X-FDA: 85164533286.04.356D87E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4BF4640003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:35:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uYgRFuVQ;
	spf=pass (imf07.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788251702;
	b=ul/mTGFvZy3h8P0mKM1pEeR2ih8U4K6E3VQwHKwP6I5HXNzOxLvwbR6OIDcmG4h2sU6zir
	oSfqvV8INig8+n6iYaOcjnRjRkgZqg/uRaY9joCRTreKuO2adGXEHmp1njbg5ebCgnO1Sx
	tpMAOcmfgTmmV6S6Sswf3FNf9++U61c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788251702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UPTuIQ8stL79uXzsKP8rRyu1dtmrmdDexhTYWlIJE4k=;
	b=H1vXa0pSZnfYcRkXIEOPgGmDr1rJS/NXUW/POjFWxSQNy/ZBaIYFCcoGKU0LLnQH3PHV2H
	ZeKAdcwvYam77I2MxbfCoPZUZ0P4eSPVYKSrY2sEaGUCfvN3MUsK8V99ILLEuc1NuKlf4f
	lCt+HLoYWkaGHtJqt55AbNB1keBBQ1g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uYgRFuVQ;
	spf=pass (imf07.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84065143D;
	Tue,  1 Sep 2026 01:34:57 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A204D3F882;
	Tue,  1 Sep 2026 01:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788251701; bh=ETkI6KJwrnZVt7KfNbAKEIpYILxfFfSNE/VjjwuUITY=;
	h=From:To:Cc:Subject:Date:From;
	b=uYgRFuVQUMgMQG7UwlgbJDgKFs5OSgi9I/EkkKtaj90JAbxq3XDpY9tqH0aOMPn+W
	 9sqS2bUvRH6RmFm/7qXLqUpah8AQ9CneKlG0kiw4UyqxUryDzee2ftGbFmSI4qqVPQ
	 vTlavXRxVp3pLtfLhXQRZjgKiooAj+MIVuhuJ1ss=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v3 0/2] mm/gup_test: prevent overflow and report actual pinned bytes
Date: Tue,  1 Sep 2026 14:04:50 +0530
Message-ID: <20260901083452.115365-1-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4BF4640003
X-Stat-Signature: w8nb8psx48fqo3u3za4axsmaijd8qe4i
X-HE-Tag: 1788251702-383612
X-HE-Meta: U2FsdGVkX1+coh7ft1GWHVUzzRRvxB6bJ78NLJvGR1Imsf+WsvSY7X1XT/p3U0yGhCtYbOqvEf3MrKyWeUmFtiaIRqPlpD/kNmbn0/kgHMWlmbljt8nnlhnwEObZ/GBqMEJ/cldZMw6/1esqM53oevVNwlskUlShV5nAhc0e0toL/lGCQ8/iP3yOyVg/oflsKajiMIQgmSLt3mRRW32llwhMnNTWPXlihjQGm4g/HUSxcxzZuANQsQqWriiYl8hNpKI37l9fynvK/owATcKW3rU5zr2/9Sjy6eBH3lWFMOgMsNnETMq/W/EmTxmxF4OHvMBK+zzsPYPVFyzeBUZghO6r7xKWfopmX5CE6pj1AyPrwgSXUkX/2iaHFVZ3LzMvDFpEq4hn/IFl4CcT0Z1T8RYsna1JypdM0kJ03F0M80HNDfOcjTNzaUARMHzCvPwT2o+BBAeQC57MBVW+7wLiQxQ3FfwsK+XugchTKsWLCATZKF/AkwW1/MK5T5kjUCE/qDAejdEMI9jn/cEvQLHvB+foy0MAmME4XhSWW2JQ7DC3r7vjWk/kEa34iKitIUrb/ARGaZM1aJT4ssC7jYcH/66MsUhFHlniyPy8G3SiNqEUgY/zY9XMTrUXE8pP4a6SXHFsU7T0kIFQhVNq9FHuPD2a0iddJkJyq1eJRHP7YehYOeApyWNXgOeYut+xuetPa0RAAdTXONzNf4BNQWciGe54/jGeadlJ2GWdJl+iso1MwGA02c+orEWnop/L+SEksX0eSeQbL0dFsBXeTCEIM4JAX/5HOsrofHi2pCUiIFBB+yVVrt+mqm5ioBf55UoSRSPatcRaU7cw6Lcw43KwJuZabJmeAQ/8fb92zzyrHlOCJuvNS1SnWtYZzZfmZTCftNT0Lwww6fHT08466Okz1xYx1rbBZYKySBolv3eh+ic4HXrO7+kw1/YS9JSefYQzA/H1b4UQ99MNzznIi4q
 z8psBs4a
 hgScGjmx6yJsHoMip820HdilZEx03/AoVXfUfheS85rEQdV6fC5mwVwbOEHoDq4pSmuMHxmfHglOd4o5ZUhqqM6U6GxzyI7J0tXWNAzC+vtTF4G4NGGyIWJj6Z+ZqlOncolJDDHaw9AkqwnpvQLsPvX/sWiYxXMYRLU3YWMp0q/yb09fpNpgtlmY1GK9EQ/1O42+9koJKkxffqQK1g0800Mphwh3nxA14I1krJiLFup3pPh4MfL8iPPLYqi8ky53jys9GV5Twia11pLcmTgM8oA8k8UZZjU/TiTm4moLSbYj6fBvbaXitEAeUjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__gup_test_ioctl() accepts the number of pages per call from userspace. Its
batch end calculation can overflow and wrap around, bypassing the existing
check. This can cause GUP to write beyond the allocated pages array. This
issue was reported by Sashiko.

Also, gup->size is calculated from address difference instead of the actual
pages pinned. This can report partial pages pinned as covering the whole
requested range.

Prevent overflow by clamping each batch before calculating next and
report the actual bytes pinned.

Changes in v3:
- Add a new patch to prevent overflow in GUP batch calculation

Changes in v2:
- Fix a typo in the commit message

Previous versions:
v2: https://lore.kernel.org/all/20260831101304.162867-1-sarthak.sharma@arm.com/
v1: https://lore.kernel.org/all/20260831064808.77768-1-sarthak.sharma@arm.com/

Sarthak Sharma (2):
  mm/gup_test: prevent overflow in GUP batch calculation
  mm/gup_test: report actual pinned bytes

 mm/gup_test.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
2.53.0


