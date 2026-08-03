Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45000C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDAE6B00CF; Mon,  3 Aug 2026 09:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AE196B00D7; Mon,  3 Aug 2026 09:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39D9A6B00D8; Mon,  3 Aug 2026 09:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AFC46B00CF
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:38:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF6AF806E4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:38:07 +0000 (UTC)
X-FDA: 85060061814.29.5B581E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C0EBB100010
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:38:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gCf9PmKi;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764285;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Kq8ToLqLqaTKHgwLbY2Nj6Q9i4/31CSrR7uoBfHgsDI=;
	b=J0zITTKFIPXTkyZA99XoFDdPeoRBRAztj0QP60O0cV5ygfSD9wHyBmdCHQCn5Tz1Yt4MHA
	P/GEhkihavWx4DvKY/buOnvUtsOUroXudZglTJi916AzegSonaUyYgbt5ZH4g5nD0XpMhW
	QF1amiuydk5HLly0EQn7GltyzDZQPSk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gCf9PmKi;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764285;
	b=jnvjhUcV8bf0U+A2kftu14U9iX9xyFJQVO2FsmCDEzzzZEF9K0di8ouswONLDOTgRh0OKK
	qhiAvSEaDIQ7oM6JXDPdwQwr2ZDJ3rGcSY4EMV0hSbKPBUF8tn55J3KeDYv3C3iAvh1l6d
	0Q24MHj1RgRStJPZBT8FxGLCsXoyXYI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5358C60A78;
	Mon,  3 Aug 2026 13:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB9D2C2BCB9;
	Mon,  3 Aug 2026 13:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785764285;
	bh=F8YOycuO3n9pyOBJlzGLYA0VTNzGJrpqDpl6r2YRxhs=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=gCf9PmKi8G1OQFBRkRY9re6zJsu30F0xbUisBQV6WBtpTFFZv6R8/fSBBQdhit4E6
	 8Jchvayxp5U/+6krIUnS8CwY2IzDWbqZ4kL3kM/A8XXxetACYlm8LRodbG6+qXqHhb
	 VsdmQZGQHntRur/8SXiCbepHgbszQ9DxfIDxW0MiS3+u9hb7fAPq6Td39A4zfvFXwD
	 E9j0/tDW8pP1uDkjv30yxmxLxzYr1UvYiF8YP7DCwlbVw+4CPl9Kmv2bO7DFIlRvZA
	 T3LVlwSm0yBDMrPcMoQvIk3GMmblP+WhCzHkcnIA3+6fYMIU/ZuWOfmxLz49f2jO0Y
	 nyElCfi62Tj1Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21E9C55184;
	Mon,  3 Aug 2026 13:38:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH v5 0/3] Consolidate memory policy interpretation in
 alloc_hugetlb_folio()
Date: Mon, 03 Aug 2026 06:37:57 -0700
Message-Id: <20260803-hugetlb-mpol-interpretation-v5-0-af2b7089f8a9@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALaZcGoC/x2MSQqAMAwAvyI5G4jWDb8iHlyiBrRKW0UQ/27wO
 AwzD3h2wh7q6AHHl3jZrUIeRzAsnZ0ZZVSGlNKCKjK4nDOHtcft2FcUG9gdjkMXtMNkKBImQ6X
 pM9CDmknu/9607/sBe6OuEm0AAAA=
X-Change-ID: 20260803-hugetlb-mpol-interpretation-1c61e03073b4
To: Alistair Popple <apopple@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Byungchul Park <byungchul@sk.com>, David Hildenbrand <david@kernel.org>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Zi Yan <ziy@nvidia.com>, erdemaktas@google.com, fvdl@google.com, 
 jiaqiyan@google.com, jthoughton@google.com, mhocko@kernel.org, 
 michael.roth@amd.com, pasha.tatashin@soleen.com, pbonzini@redhat.com, 
 peterx@redhat.com, pratyush@kernel.org, rick.p.edgecombe@intel.com, 
 rientjes@google.com, roman.gushchin@linux.dev, seanjc@google.com, 
 shakeel.butt@linux.dev, shivankg@amd.com, vannapurve@google.com, 
 yan.y.zhao@intel.com, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785764284; l=2055;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=F8YOycuO3n9pyOBJlzGLYA0VTNzGJrpqDpl6r2YRxhs=;
 b=/81mVPLrmqdt8S3FtL95+RIaQasW+MEisG4xehIhpdk2HXO5eFPXLPMjy5Uwdv433hzfM/vc/
 892yhYS4rbuDoLrWjmm5vw+7DS7oD3htmhFX7j4Oo4nPApGYQQ8G4U5
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C0EBB100010
X-Stat-Signature: cym57sz1ceb3gu1p1dzjieodk6nghtxj
X-HE-Tag: 1785764285-658329
X-HE-Meta: U2FsdGVkX18S4zMd8o+JZPnK8+h3z8fZoydS8zbdeOrXf8K4H29frFZ/Qi/2vobuOYcBk3j3GGTzyEtBGHe645TDfhik1KFX/7SCs8NyUAygZlCCR1Q7KFLdl2A5M4V9vXsc4CtLmtuWbQPISoylJPE/POOFG8x+vQJHNmjhjBfMu3cMcQ9VEsOqDLHw06IgPqkhm1V7EZVYNzJntCBmJEA8mC8TKL57ufo+kT1yI1C/ImjdhBqi/ndUwHegAm+97aD3nesQvM2CGzq1ph4APA3UDpIDoiAsgOcX1iO1p2UduRNOxVV8RzHK+AxyDZi+owMuHGzFOFnjT7C77va3lADXGIdEF212F5LfvDSFQj1d1zUL92aooQNcmNsGzAXgyo/XtGfJC1tw64DOMgSKao0SOl9Hr7IAYshxENrtnwoQd5DzeLesWhNZ8aWypYCqsy76ySn13gIwAigDWsZ60E0gPAPKSzXwPY3kILoEdBPbkaTVZR6T22Y0zRQy1x9TCcRsaRNA4581nDEHa63MgnnPuKPVANrMzffSCOZ7vW7WO7dthBivETaw8TfqBGzwFwugfhOnbm7YAMru9OdPEvN9fKVIYx8v9lvq+855636gThrja0jJNWE3AZ+HeK36duQQITsnfds+UCahCW+5QZ7cN6+Q9CFQ0evS92AriUqxBKrfWcof+Pd71WWhXs1DWxoJgqnfuwUM8nNL7DTXovAQACZEkH4L2N/HTlNPQN0vciRibMSKm8ILQ6RraJHSjlN1eFmP4yAtNN4qqhS3m951lrI4WnIBA8LG7UuDg5xTLCJ5ZWFBYw9naV9XBzS06/ALwKvew4jEzHueUJI9C2wW2nJPTpL3M2CIzeBIDQNZbuxJ22aWzSA33bwcF5cyEG0xxg86JaUoBKT9cW7SzJyPcfukNViFOhH6B6M/f6GNroJ+Aaz5eQI2UVfe2yx4MDm0D3kX0tA9G78jb1b
 XTk7CT95
 saMJonPgzXapGS6XHnNt4sS18h+D0X08BgUexuuJfnK1lQSSKufX5Y3wUKktkeswUj0C/mwXPxm+RBXpPs0WGEayK7Cp9XVgtgYcsIshDtRTdRnzep+h3maZa4ZW+n1w0im3nNYQWtZvTpd5j3PT5CU52H9PHXDx+7W4BF00lSOZVZDLnsGfF6hNcb3hEC2M+hDfHqSzvoMsgLCqZFzFJ+zLDYuMCekBkzT0GMiCyJ9HFC3bTSZpTODi719IEQTycr6O2DcDEC8oJZb6B1dDYYlUUUsvyuJ9s4kFqpGHBmoROmHGQpQRTdAmBS+979e5SHo+b9+Jt7KbmX3rbc3GBPzdf4+pb0+3V1HsviIB8W8kM3SMvc5fDmEHcK9Begdxrd3g/6Fs1ex07e0Vf/8vTinOTzKG3xavU6seN+1j/YD9Z/jol+zMQH3B1Bdk0J5y55/ohwR9eEtlZah1Hd6i87jBjC80PFTxQwf4gyiaCocHejWPQSZP4ZITtxEp/UnDSuBk5wJKnRdI8xbLqQGNmqvHAGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series is the first 3 patches, split out from "Open HugeTLB
allocation routine for more generic use" [1].

I'm splitting these 3 patches into this separate series, and continuing as
v5 from [1] to avoid being blocked on addressing pre-existing
bugs. (Sashiko's reviews on [1] revealed quite a few pre-existing bugs,
which is separately being addressed in [2].)

These 3 patches have been reviewed and can be merged first. (Thank you
Andrew!) The other 3 patches in [1] will probably build on [2], so I'd like
to leave those to later.

In this v5, the only change is to the first patch - I improved the wording
of the comment just above the call to dequeue_hugetlb_folio_vma() in
alloc_hugetlb_folio().

[1] https://lore.kernel.org/all/20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com/T/
[2] https://lore.kernel.org/all/20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com/T/

Testing:

+ libhugetlbfs tests pass
+ tools/testing/selftests/mm/ksft_hugetlb.sh passes

RFC v1: https://lore.kernel.org/all/bb35a69a-5be9-45f5-a557-1902487a1bc2@linux.dev/
v2: https://lore.kernel.org/r/20260506-hugetlb-open-up-v2-0-826a0c5f28fc@google.com
v3: https://lore.kernel.org/r/20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com
v4: https://lore.kernel.org/r/20260702-hugetlb-open-up-v4-0-d53cefcccf34@google.com

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (3):
      mm: hugetlb: Consolidate interpretation of gbl_chg within alloc_hugetlb_folio()
      mm: hugetlb: Move mpol interpretation out of alloc_buddy_hugetlb_folio_with_mpol()
      mm: hugetlb: Move mpol interpretation out of dequeue_hugetlb_folio_vma()

 include/uapi/linux/mempolicy.h |   2 +-
 mm/hugetlb.c                   | 110 +++++++++++++++++++++++------------------
 2 files changed, 62 insertions(+), 50 deletions(-)
---
base-commit: 075b74841bd0065a3bda3440873c747938e69b68
change-id: 20260803-hugetlb-mpol-interpretation-1c61e03073b4

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



