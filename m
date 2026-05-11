Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B823CD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 17:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718D66B00A2; Mon, 11 May 2026 13:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0B06B00A4; Mon, 11 May 2026 13:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62D5D6B00A9; Mon, 11 May 2026 13:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 515806B00A2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:34:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E16FD1A0200
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:34:47 +0000 (UTC)
X-FDA: 84755839014.15.7B1CF5D
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2C8D4100006
	for <linux-mm@kvack.org>; Mon, 11 May 2026 17:34:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bhuQRKt2;
	spf=pass (imf05.hostedemail.com: domain of 3NBMCagcKCLkoqZslZkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--pratmal.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3NBMCagcKCLkoqZslZkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778520886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=u4Kov9/dGvAf6qm0HsBF/ljzhn82MvaUJ7qqTw/jn+I=;
	b=Wi5OCYXLOw0Y++Di7N0amzhAjUGOqyHDpxu/s9KFQO39NmObCq2+AxoDeueWMhW/tN6wb7
	xHfzT9Bkknxv1D8g8GMpD0NsaS71aI6YZyR8ldZJWK3ehjSfWYBBnxvbm3FLJGS4xekOmQ
	psPzkzUMumsnmU3SbZjvJ4F4ma0vCUU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bhuQRKt2;
	spf=pass (imf05.hostedemail.com: domain of 3NBMCagcKCLkoqZslZkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--pratmal.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3NBMCagcKCLkoqZslZkfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--pratmal.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778520886; a=rsa-sha256;
	cv=none;
	b=KE6evn+nixB9M4djiTjDlznqNRIyO3L+eX23T4awjzjevjh+RHZLA63QiZoQKVEc5+quMe
	WFCbtIN+twaPxpiPvW+24lZA1SalUruDyjCqiRoQmTPzb51arguGDvLVOmYPpXfzXBUz2K
	zgH8esrZ7TGEAvYq/jBuxtKr4E3B2L4=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2f2d983d109so4327907eec.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 10:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778520885; x=1779125685; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=u4Kov9/dGvAf6qm0HsBF/ljzhn82MvaUJ7qqTw/jn+I=;
        b=bhuQRKt2wJIxlpG2jKOwt99xYBb1uFvaSgUZvI5acLJbOfKiKtxXrBeX8du4J86AOJ
         w5c1sBqLGkTiBs4hSmWJl0BSfvg+BteJWT+SevI9GB0Cer/k/igf7Yda1g7JBt+DfM/d
         zcgyQcDJThfsjsnXvD97upmZTzjhkl2eubBHxPMwM354SDQcOlDOk08S+13WCgrGlYy5
         5cfjbNH17sMs3uqTUYLEI4sU7ImYFRFt2r3TO6MBuBQt4Qh6KHAftTG0kvtu3r5oRfez
         xkMNsHQgqV/FZLh6EMla0XEM7+rDQ83SbtjqQsB0YWgZyI1elLLh8HgQAeMv8lS2XujO
         bq7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778520885; x=1779125685;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u4Kov9/dGvAf6qm0HsBF/ljzhn82MvaUJ7qqTw/jn+I=;
        b=mTHA6IqYoWT6umVcsX2dQ0JyGf8Q/XN/CU4q+vghgNJr/d7o1qv/cp25ALxt99ZEhB
         XUGNFu5gzP7u0Uu24Sb4EvL7JD2uiSI5PXHreT6kmllajwPrO1Mnth7nGrMEzHno6+hy
         vn8LM5oQWPnbs6RkjxbqZ2kOoddzecuOukmWC7N9EgNKtoQLJUWNuARKztHTFpkXkXyH
         nUILasXtJprmPCLPeRJjDQEUrlG7oxJlkR5oTDMuPJVuyZiv+cJ2YM3ZL1Dna5GPI3TC
         Pag7jhluv2eZeEPglhgi9nK8f6id1mteVIN6IHmWFiQS370LoLjGqX81+VxAt/GUA7kt
         FhQw==
X-Forwarded-Encrypted: i=1; AFNElJ+h2GO11iMsbUBhkBpK05K2IBPm8DmSeBFrZrqIs75M8HLP4oN2ibCEBu1j9e0IGhKaJlGmugz9cg==@kvack.org
X-Gm-Message-State: AOJu0YycYbjtgd6Tbx+rTMQb0dozaKPcvhD6f5SIxLgkhcZz0SJhRq6p
	2kfrIjdxNmQUA7Bkn55ot3nMwiCCHYba0wgZ4UQRWwEHpKwR0OdB/RBRR0ilBnFwrVPhUODFyVC
	1wYz8317+5Q==
X-Received: from dyz23.prod.google.com ([2002:a05:693c:4097:b0:2da:2525:9f3])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:3207:b0:2c5:60d0:701e
 with SMTP id 5a478bee46e88-2f85bb73083mr7323594eec.3.1778520884334; Mon, 11
 May 2026 10:34:44 -0700 (PDT)
Date: Mon, 11 May 2026 17:34:09 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260511173411.267628-1-pratmal@google.com>
Subject: [PATCH v3 0/2] selftests/mm: use pattern matching in .gitignore
From: pratmal@google.com
To: akpm@linux-foundation.org, shuah@kernel.org
Cc: yosry@kernel.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pratyush Mallick <pratmal@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C8D4100006
X-Rspamd-Server: rspam06
X-Stat-Signature: 34o9dgqf6d8iwteqjdg7uzxgzxeng9oi
X-HE-Tag: 1778520885-24332
X-HE-Meta: U2FsdGVkX18kkquc0IOPjpzRFLfHSvlpgu1hfJt1TGELjMwdGQmX6NyHSqAhYp4Wl+Byp4XXgNnjn2X+BSS8wElwyA5sO2GVl5e6HBGVCvhj2rmjXmgPWF+u8ABsPy1Kl18Lt5hQo+5z+v3yacDpJMYmKgGtogcpb1wEmW5gKbV0QXaWSdCPQ4bGWikUkjAmk+19UvXAGP0bgQLyRKKM3AbSdD1Bkvv1LMo5sd9pCOHRFAJe5M2dto3Lswkm+DkAeg17f4UmbwEM31g/khymmU+A/yPDLmDa4HZq5lVdNm+/Gz3xpfMfW0LdBdz/5G36PICq777oGiPqb3R36RNUvWp0cVF9SkYEB+4zajxFcideuWtlNZwpG3fkid8NX7VawcDX7c71nOY7pLlyhidDtljExu9lq/bmVAyh20FgReRUEQSZQxfEXJGGOnrSQGfRhhtmL95ecSza3iAdH51JEu5OVlMXeudqRhJAM40Y/pW3gx4KkUKKi+s3fNb9uXeQcQdzJD5ti2yP7W4Eo+1CKj7OOCDXGrf20/RNKwGonRigHqGspa0g4oRtX362iADmjbO6wi1iBOWJRfBRhcDf6Oh8A5dHamR2uLpTJDXr1VqWnyaY0c3icpXuHlPa5OTDXAJ04owW36WSTAUtP+2l0PyaQHfawlRINI54gtXU2nww1RO61sULlX8ahsNWB3HVEMfNXOBzWKKSHJDD6NxspRqo2zQc8/HcOVS5TNLABJgPyiCC0k8Vg1x2phOddEKsfnAC1Elk9fTwfz/yqk8fyCvFVn94TSiCHzXMN7sNLuJz5IRYsmH7CNi+IV4d7UgttcTEXw8up0LgxQo1oZRggLAEtA8/lE5h+x+mdR3yV/O+EgRbku4/zNSRG3Pns+VHFlAU3y+pc4lXQo5A5XsCmUSeMbjL49LMbcm8vySDOJnJ7A/+8pc6Dvd1RF8dGU43VZOEls5PNThFYFHdFX1
 3nTyhu6K
 T8bcsQXQt4N6m2YyhhVTRQgqtqge6ghEKRfMDuUQTkGTVVKR1e8U5if85nf1qAi+6K1H562E//jGPsHVfrxghP7B1POMCevusrtiRdsaqw13ZboU7Lvsq+CwgaM35oUZlr1DjPuoT9e3ge35+kRl9ql3lyC8D0dDZS3NdHP1D+rICKlaO2snKtfApiplHfkRloQkVvIqnnNHF3cSfK3ePYbkqdBR9joH1mL6tnxX1+GzATWB4jbKoAsn46aSmjOVJ8uwrI3OdVEGyc1jiUa+gc9eTOYgtt0H1v8Tyexv3dJC0eE7tvU4vz0fVXS1dQpesxkuYnrkTiAfPoEi1p2lJFTCNp9qUUMgYY/k+qRouJd0Q7XNrbOZn+MVoKl/d4sd2nqsnYIZHAUBt4Hx6Q7Lux3nwtro4Uk+I11XzNBiEDJYxZO5IIj+fr4os48aM9hPAXNniOu45qQQoU+U3ioG7Vtnkl4TVCqFN2xI1wpg7Cavt40y1KH4ncXjhBA0sj6LRR9PP9cjNg9XZAsV4sVCHY1BYLrWJlrkaajOVY77OpSD4tYUJ00j9ydkL3bWZFZzM2uRnbPE+22Vy7V4KPYQBr16sIqBwX66PbLD84+LpyUcQR243yFPzu3F2iGOaYckeciip
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Mallick <pratmal@google.com>

The current selftests/mm/.gitignore hardcodes each generated test binary
by name, which requires manual updates every time a new test is added.

This series switches to a pattern-matching approach (similar to KVM
selftests), ignoring everything by default and allowing specific source
extensions. To accommodate this without tracking generated headers,
local_config.h is renamed to local_config.h_gen.

Changelog since v2:
- Split the changes into two separate patches (header rename and
  .gitignore update)
- Added Suggested-by for David Hildenbrand for the header rename approach.
- Dropped David's and Yosry's Reviewed-by tags.
- Kept Lorenzo Stoakes's Reviewed-by and added Mike Rapoport's Acked-by.

Changelog since v1 (RFC):
- Renamed local_config.h to local_config.h_gen to avoid conflict with !*.h.
- Updated Makefile, check_config.sh, and affected .c files for the rename.
- Removed *.mod.c as it was unnecessary.

Pratyush Mallick (2):
  selftests/mm: use pattern matching in .gitignore
  selftests/mm: rename local_config.h to local_config.h_gen

 tools/testing/selftests/mm/.gitignore      | 71 +++-------------------
 tools/testing/selftests/mm/Makefile        |  6 +-
 tools/testing/selftests/mm/check_config.sh |  2 +-
 tools/testing/selftests/mm/cow.c           |  2 +-
 tools/testing/selftests/mm/gup_longterm.c  |  2 +-
 5 files changed, 15 insertions(+), 68 deletions(-)

-- 
2.54.0.563.g4f69b47b94-goog


