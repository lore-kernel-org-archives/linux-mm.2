Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F417ACA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 23:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72B038E0003; Tue, 19 Aug 2025 19:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DB3D8E0001; Tue, 19 Aug 2025 19:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA298E0003; Tue, 19 Aug 2025 19:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 427BB8E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:23:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0E1FC02AC
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:23:47 +0000 (UTC)
X-FDA: 83795086494.14.2DE0075
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	by imf25.hostedemail.com (Postfix) with ESMTP id E0FF3A0010
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 23:23:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=XsxzScub;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf25.hostedemail.com: domain of "prvs=31909943d=epetron@amazon.de" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=31909943d=epetron@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755645826; a=rsa-sha256;
	cv=none;
	b=mlcC22n2cIvpehRFMF0RDJERvTOIiMjUw8rbhnQVOJnXSgmo5Z4Qh3OFRsTeaN6e5FjDm/
	hZFb7ifl3YyjWGDR/fhkoTA7sDUretDx47AVLt+63fBJHMPhbc1C2lNIkbbvUqs4l1oxOX
	8wBMrz8fqwt8lNchiHOqL7o6tR1OSxc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=XsxzScub;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf25.hostedemail.com: domain of "prvs=31909943d=epetron@amazon.de" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=31909943d=epetron@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755645826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JrfIpk3vI2iEZnlCjBatj++PBwaKwr0n+7Op9hx7NqM=;
	b=D+IREXdvym4DEY9Cy7yZlcVqjLJVNlvAj/tQ/lOp61+oNW6dBR8LLk1vyBTGuJTqtwPqhy
	97Z6cwZ0VneqdZYp5RghA6pXslJ8HTONHVxW+1m+kUb61AzaPfemZ6TuV8d0L6CFCfD7Te
	8sbCOAJ0h0PW6fLcvxGI+aOaGi2g4Do=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1755645825; x=1787181825;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JrfIpk3vI2iEZnlCjBatj++PBwaKwr0n+7Op9hx7NqM=;
  b=XsxzScubOO6PcrQSBN7v5MFhoVYDOK3W9MKN40kkm2BDl8knCcuz27n6
   n4ibqZEX9qFvlkjwCvCQoc4E+GtT4uNIp9V7loniF/XDnS9HVPVg1JM0y
   X4Hgfru9IzJqEe/lU4rUCOc0AMfv0hAKZO3BlLqwJ4AI3S6EmaQJhxQhM
   ZPepp4KUJyIJh8E8wFJIEzW4kxYaAOCqf86FLwkJAqd0VguNNNZa8oPow
   HD357cL0I0z7DIbRwc5ZCTfg0Ovy4TrpA1grX26RZZcqcU/YPXqlYychJ
   NqNHiENwLNphogOFcSWVYXv/vU38YXkpvsyX9GTROLs0ZgVMli1dADVvW
   w==;
X-CSE-ConnectionGUID: A3CnChY0S4G6zO7ySKE+3w==
X-CSE-MsgGUID: rIVmzT6GRpyTTXD+abL8SA==
X-IronPort-AV: E=Sophos;i="6.16,202,1744070400"; 
   d="scan'208";a="1404456"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 23:23:42 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.21.151:23645]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.41.67:2525] with esmtp (Farcaster)
 id 28c909b1-13a1-425e-9469-766521fc37e4; Tue, 19 Aug 2025 23:23:42 +0000 (UTC)
X-Farcaster-Flow-ID: 28c909b1-13a1-425e-9469-766521fc37e4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Tue, 19 Aug 2025 23:23:42 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17; Tue, 19 Aug 2025
 23:23:40 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Ard Biesheuvel <ardb@kernel.org>, Mike Rapoport <rppt@kernel.org>
CC: Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf
	<graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nh-open-source@amazon.com>
Subject: [PATCH v2 0/2] efi: Fix EFI boot with kexec handover (KHO)
Date: Tue, 19 Aug 2025 23:22:44 +0000
Message-ID: <cover.1755643201.git.epetron@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D038UWC003.ant.amazon.com (10.13.139.209) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E0FF3A0010
X-Stat-Signature: y97dsu4fsm6eyfgha95wkuc1fy4czqgp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755645825-38342
X-HE-Meta: U2FsdGVkX1/WUIC5X0pNvGQjCmuvBbJbOrz9LXznDc4qti2xPNbkt7gtvUOavpngF4HCFSA+LG2xJM4fDm6gspWUpT2XHgCO1tPmnOTL8s+0VXxC0E7fd7qOqPZhr4Lc4CK9NlPpXxrZFJEy+9Kq/MUFLyjIa+j3RwUp2+Y5vb4hRiQGu25ynB39SUyz/RnUMj9F7tywgtFBfnOEvPJWEZCiGlRLw+9eKtYgrx+Tvt0Sq8eo6grt+UuvGv56O+BqRf7th+EaJ6ehe+WWN5ajI170Hy8k4QyN5CPkWlyn0a3BIrwVOjDTTyqQ0opuK0X0BowPjENzZS0YcexYVbThCIefAcY6/hPPMh9Tg6KluiWNub9wORla6Hny1xW3siFHHRmmhsGkHSB6mKTLmg74d3uD+ZCs2+iFKhSfc8AinLwO55tHC9+tnf/q5ACCCMhrNfpETE3shhQ7PzxXRPR0djKNBac87SHNhJQNYv/Wfy2AevlB19BA315CfoWjcJHoaf46x0ijjo3fG2wg1I+ZSmbjxYruwDY9hSi36IrL+adh0Y5tioKcUy8uTgm7w7AFvNaGPywXU5SmWya9W6aptC3wzoTnwdj4uh5CD/VL8YZyS5rELpcngaReH2T8lYP2UomHJF5CXcG0zngHPOerZWYYOC9ozqk3TFaC1E9nuVEG/1Z1biw+0KLq8yo3IW+Lff1U6+evFp63fltFalpFZJlfIqHTWLJB2CK2xLQFkwuGxI9UreamBTCNGxvMBj30zs4z3NpeSHP5BvdM958+S9i2iwaW2tdK6sBUwlst3M0D0LWQ/arWy1dAao3w8JAQNJOVLOGjAHRxeeIqVBY67w+fObkCxQufvjrDOIuUlHnj/2A0dP2wqoPxQjlerdf+103jsOpFDK7OQAhr2NyKCgk0AAe5ESpl1Ij54xxnYbVOQQi1dLtLT0WuYyOWPDDpz1F6GK/0h9RAu+R9PLr
 H84AXoGR
 Fw96q0MfAAIG4NqTYMpJg/9q9JO5y8MXTzbG2zRooSCSCGeOlFHY61PJTm/0bRimWkt2gtzsSj1eSX4WXS5T6C0uIGBeTIgph6Iliz2g5SUBQkp7+b3VS2CCdJ76bg2oOrTLLIcGw7ozs51we1C+tkqkTAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series fixes a kernel panic that occurs when booting with
both EFI and KHO (Kexec HandOver) enabled.

The issue arises because EFI's `reserve_regions()` clears all memory
regions with `memblock_remove(0, PHYS_ADDR_MAX)` before rebuilding them
from EFI data. This destroys KHO scratch regions that were set up early
during device tree scanning, causing a panic as the kernel has no valid
memory regions for early allocations.

The first patch introduces `is_kho_boot()` to allow early boot
components to reliably detect if the kernel was booted via KHO-enabled
kexec. The existing `kho_is_enabled()` only checks the command line and
doesn't verify if an actual KHO FDT was passed.

The second patch modifies EFI's `reserve_regions()` to selectively
remove only non-KHO memory regions when KHO is active, preserving the
critical scratch regions while still allowing EFI to rebuild its memory
map.

The patchset was developed/tested on arm64.

On a side note, I have noticed that `kho_populate()` calls
`memblock_set_kho_scratch_only()`, but the `kho` cmdline option is
not checked until much later. Therefore, memblock will use only the
scratch regions that were passed from the outgoing kernel, even if the
incoming kernel doesn't explicitly want that. I am not sure if this is
done on purpose, but in any case we can discuss this in another patch,
as it is orthogonal to this one.

Main Changes in v2 (smaller changes can be found in individual patches):
    - Introduce is_kho_boot()
    - Replaced manual loop with for_each_mem_region macro

Evangelos Petrongonas (2):
  kexec: introduce is_kho_boot()
  efi: Support booting with kexec handover (KHO)

 drivers/firmware/efi/efi-init.c | 28 ++++++++++++++++++++++++----
 include/linux/kexec_handover.h  |  6 ++++++
 kernel/kexec_handover.c         | 20 ++++++++++++++++++++
 3 files changed, 50 insertions(+), 4 deletions(-)

-- 
2.47.3



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


