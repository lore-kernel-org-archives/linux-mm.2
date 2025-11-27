Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87C89CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D736B0011; Thu, 27 Nov 2025 05:03:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C34AB6B0012; Thu, 27 Nov 2025 05:03:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A896B0024; Thu, 27 Nov 2025 05:03:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3506B0011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:03:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 488F9131BB6
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:03:11 +0000 (UTC)
X-FDA: 84155948982.02.58200F1
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1BB50C0007
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:03:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764237789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=nsN/ErRcukLShuxW5UnDNxnfwEfdTDdADITQ8K5jsRE=;
	b=oTu8LyTpWOq04jDGnFHRhTTWGsjsUjffaq2dbAjE4a1N9FtWHCTlvGrYARZEGj4/W4Gb+n
	1vwMA5aNkMfQZvjEgS+LCGJZY//Ikr9WkEyMnopKJQxEny0ZIc1lw4IKtHHWqrQcReequM
	dnyImT328ms517qbR14ojqdm1mKhrcY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764237789; a=rsa-sha256;
	cv=none;
	b=adrUH8VyXg0t+EaOvPmJCo+WrYjIHgIAjqPmdQi3sZOurlzndNu49++OncyK+FIJzEuwEE
	yZ4b/RRXil6OKVIisvJyKYpRbLYXtX/6ugU87dOWlut2gDrMHJSwipydIKbUOwzJnLp+5h
	IC0KAkq/WfheZjpwfRgUSkTeIK8Gbyw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 27 Nov 2025 19:03:04 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	youngjun.park@lge.com
Subject: [PATCH v2 0/2] mm/swapfile: fix and cleanup swap list iterations
Date: Thu, 27 Nov 2025 19:03:01 +0900
Message-Id: <20251127100303.783198-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BB50C0007
X-Stat-Signature: ac5u6y6t4qmps6nh7h5ix36wdpac1hau
X-HE-Tag: 1764237787-498819
X-HE-Meta: U2FsdGVkX1+QLLDyZNDJ4PRplq3AJf+NvtvgfAxJ58fUF11h4tCwPNFkgP4Fh0Pr+Z0qwX4Dw0mZg9OnV4GQuWXN6Gal6oCSn5yWkC2jAZ1YhKN9c24Tb7lQIspa3cec3oxYIo0tQHktSB0QsEUhPSGBtvzNnvqGPXqaHQWh4SKv64sM3fifRr9fVK05NeqilrdjwszfbHEUUZ3hXvcR/W757ypS2jE77G4DEG5vQtO6YX1Lf4rSfYvz7HsRKxEgrRZE7gHm/RwqTzE1cajMW0zWT2ErB0ZtHDQRB7WfcGt8ZbBucsYraJXffPYJjJh4iUuoNM+7eyurLJ749Joee4UnkZlT1bl3QTbQduPmNjWyWjGkXpwDlVDqxddrjS+A0slVL9b+5iyhPrZe+h4GgbZvNbygo//OEntRQPVsQiD3qjLAK8El0v6lZO+CXnKWuSzfLPKzjss7Wora/Gga9BWfnyea7sN11k+7UWVgPn4/jCLv5ijOeQm0K98vTlDcHGGxwGOGyTP5LJCMxhTX3a2slFpVBeOt5P1Y7W8auRMOozZK2/Jd1zthZLNOrvAS93OdgKVVda4LTKEgNlVnqGGcNjm9nhhu29EInwPM6RtEJRhCAcoaWMGJlgZIZO2tWYyBmXy3lke4Z2ZZAPbkX7vupBXH3x2YMBbt8UfTKkyUUBq/Yb77D7GrLua3hXyBZeD4ejP0EeZK9Dj4t0k5PNIB8ONekeB9lIf5nYtBJTUWaA4rwURbcS2a7X1exlg/1sIHo5YwEXW6sZV+VPbGrDHvVflNLxWUXd5jm2t2Kg/mkZsdG2Fc4aJtCX5C3LU2xYEreDCuR/iuI7h9oWFguZfLpDOf01RC5+0FlgPOrbcWfLcAnOdg/5/gOkRTe73LYWZQ68/YCOcbBRPnzX7vy5lttZFStPOe3m3vjw17Tan/DqpRt4afj/uiBIhFxqyc1g1QHHFiymV1Tb3E/Na
 uJI360Kg
 48+/Up9pX8UP44l81h0ihNmuyjeghridxiZ2alOKLYuMy4cGvzW5aQA0BVloQHLcOrARRKsgb+Opf4cIWNjWrb6OmiwFOx1Jd6lifNUEAa8qD2VsTKTAk+PKxU4NI5bPkwFsMvGTc4PnuAPqwR6DDogJO1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes a potential list iteration issue in swap_sync_discard()
when devices are removed, and includes a cleanup for
__folio_throttle_swaprate().

v2 -> v1:
- Keep the original return value style. (Thank you Kairui)
- Clarified commit message based on discussion. (Thank you Baoquan He)
- Collect tags.
- Updated only patch [1/2], base commit unchanged. (minor fix only).

Link v1: https://lore.kernel.org/linux-mm/aSfkrpV7T7g5mhpI@yjaykim-PowerEdge-T330/T/#m101dc552904259e26d6595f91d9cbee37b6da7ac

Youngjun Park (2):
  mm/swapfile: fix list iteration when next node is removed during
    discard
  mm/swapfile: use plist_for_each_entry in __folio_throttle_swaprate

 mm/swapfile.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

-- 
base-commit: 624c4d7b8fac3fdf9894a5f89f84709771db4dbb
2.34.1

Best regards,
--
Youngjun Park

