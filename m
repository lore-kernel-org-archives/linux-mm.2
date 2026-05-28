Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59E5BCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 16:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929EB6B008A; Thu, 28 May 2026 12:50:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA736B008C; Thu, 28 May 2026 12:50:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EFC06B0092; Thu, 28 May 2026 12:50:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD906B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:50:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DF591620BE
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:50:24 +0000 (UTC)
X-FDA: 84817416768.02.FD15451
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0375B20007
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:50:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vjPIq6ZD;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779987022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yzlo3xmXqUYFotfdaId9HTkqzJoOffcAET7WuagY9zo=;
	b=LFUq5MI6QfUbBv3zBcMHoR8B4TmRrGoUtTum4qQ2inedwFNaVghPV8O2Jwxi2q3xx1t+0O
	XNEnDDWbBN/gWA2nbwzw72SW4bq9LMVysYd6tLrRwi9ezohRWspMupxx+oN0CBBTxbf5dR
	Djv86Z/Fm2gCbh9K5B9zKv84j/+O4O4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vjPIq6ZD;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779987022; a=rsa-sha256;
	cv=none;
	b=OvlPFt9836txkNJKRXbhgotpjSziC7RvWpBI1ZUtacc2XyXIbUymoinBn6L4Vs9MF96QhX
	9GX9UfdRFbVeST2f3X3gP1jGZPIIgfiL/X0Ocrx6RpLSzR6MNgdmErQntnAEzaPw9Ragbb
	JP5kXYD42VUDAQF5mOqDB3QKztynpnA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E811922EE;
	Thu, 28 May 2026 09:50:15 -0700 (PDT)
Received: from [10.163.163.35] (unknown [10.163.163.35])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F9863F905;
	Thu, 28 May 2026 09:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779987020; bh=yzlo3xmXqUYFotfdaId9HTkqzJoOffcAET7WuagY9zo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vjPIq6ZDu7S+lXbMMtbiAQqjvZhkELukdEvuZFJQjnXp/y97U/1n/LcWMAeS0FZng
	 SWQhjYd2EqRs0YnPPesizRKGwqpQoEZJ9//BO6jwsQ13NqkIkYawgnPIwaYF0U31B2
	 JJAQAvP+JDgsvU27Ur3+iwU81Yb5NwYpOCzMEtX4=
Message-ID: <f8d10097-95d9-446c-bf9b-6590c543370c@arm.com>
Date: Thu, 28 May 2026 22:20:02 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/12] Optimize anonymous large folio unmapping
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0375B20007
X-Stat-Signature: 85e5j873tb4dd4inzue83m5xxkm4s6ut
X-Rspam-User: 
X-HE-Tag: 1779987021-718461
X-HE-Meta: U2FsdGVkX19AHc2KdDqMHXv/7PLar93lKJ7EIUs198stSA74LXv70lFLeqp0aWJVJIB4jzsWJ7roNfWA2S+CBVWBfKlCM3okRIwUOYlHPNjSIoV7jFzQlimD4/hNdg1uC+9gFyhKBfzvk3SgHh8wzRc0NTBXD9lA+4bf0c8L3oRm4LiXzZ1dSRYJexTII4+Z69vWMt8M62Q5a6tRQZ7SmXZw94ILLoUThhpaNQniCAICWPHIlEIsr8LGWejM8Y6cvkmt4VKBLHSC7uQsntnpUAUUXDjoerDGiK+sEhe4jsl7q4INjEqc/ROP0/awfkIzlySuTHi9ZM6UAt3d3TOeyOyIiW6R3bueo2GAtgMRx/ItblXHBbOTfUIPb9fDoL4BxEfoMBdN61DOloK595eNNAAhoo3Qc9S0RmoUmHGtV5ymqtuQYswnCejxr7felYb2vGipFelfiESQsx7SSM9ATFTTodjjxaauFRDKysxfsOTg/OVurlfaRGGXoG0hIg74ZllDFwRvJYXwg2MFWLKw6GGn4IZ4hF/T/4xkLYOOaOatUuHDT1W7xfdyMLkVDfggG8J5dyra0sdxRXWTRjQyfDmWQ4QWhwnemm8rSaCzTbnosxKoz9H+hw6rZaVXkly58tGsr9E/iUZG/pw/0LnvOzeUWIb1yc2W7cBworis79+KSTTJUGDoMtPh1IadqGmdrEqyIvpu3FwHGNuQF/ivFkqNVShgIQ4rnyZIhE+L7Y5abdUIoB+m2ndJtaVCqv87ZA3Hu5oXwDJVSvL0wVRBsIO2zmxoZRmKUzChawYrM9JcSdAgQFdp6Nfm4V1ebafALiiYnTlZ2wNIwrmDGb7fPbqOIVeyZYsVVlUvOGDqoXOROubcY43F5PZ0FOL2DvZE5VWJbfLQErj6F1Ro2EyZRLbzuJx5iswUX096Avxp3TeS6E2ff0C6rmduGmtpXGCahrK0C8CXSKq4g0xblKR
 4w2MhOgX
 VrXs0zxjJsWewGiQXOkCRSuGxuwEiUKLUxfq+pY6gbOKamexhoKNKmMaYLQP+fFGkbd17GWwKlA/8lIMILOFUmSFUh8qOp+HUiYMCWpYoWmjxPrfsUjzfs7i7ISdRYW6zQfDNqpStwYfHp3+NvS4UXaKMSEJB6PYEKwVLaLgTWYaOiV4tF26i8PMcxKROhdnDMVf4gktbCLfmmF5MJ45AYrnmLOTtwAx5lrlb87WB250C0FM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko:

Patch 9:

About anon-exclusivity: At this point, the batched helper is not
called with nr_pages > 1. Later, anon-exclusive uniformity is
handled.

On PUD folio: that is never passed to folio_try_share_anon_rmap.
I was following the pattern followed elsewhere, given that
PUD THP is not supported yet. Although there is no harm in
changing the check to (level != PGTABLE_LEVEL_PTE).

On hugetlb folio: that is never passed.


Patch 11:

Existing bug: doesn't look like it. uffd-wp is not there for
a migration-writable softleaf entry.

Patch 12:

ABout sparc64: Yep I'll change this to #ifdef or something. Apparently
is_defined() doesn't work in case the macro doesn't have a value.

About dirty young and uffd-wp bits: we don't care about dirty and young
bits since we are converting to swap ptes. uff-wp uniformity is preserved
through folio_pte_batch.

About stale nr_pages: The patch initializing nr_pages = 1 at the start of
the loop is already in mm-hotfixes.

About O(N): Yes I will update this to retain the nr_pages == folio_nr_pages()
early bail out.



