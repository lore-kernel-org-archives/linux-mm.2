Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1055CCD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47BD56B00AE; Fri, 22 May 2026 20:18:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD7A6B00AF; Fri, 22 May 2026 20:18:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B926B00B0; Fri, 22 May 2026 20:18:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 017616B00AE
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5C03140902
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:12 +0000 (UTC)
X-FDA: 84796772424.01.782AA84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B6B8B120008
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t+s5jEHX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495490;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SufSaK/M7dxM2oaqd60F+3o6LhXryf1VhlkfYApVko=;
	b=BagYsU0T0CSmbwLcRJDninRZx6Iy7to9T+W6tNmbvkQSeYjqUAUerqKylnkujznpOH9X/Y
	AWpBg9930lIK+afcTKJyy+86fzzA7NP8SH59XcTw/GJqXtBAVQbsUZj6wjwLSkelB8Dw3d
	xxp4Rcip1wMnrw+9o45+xM0ra9Zx9Po=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t+s5jEHX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495490; a=rsa-sha256;
	cv=none;
	b=cyTWPMzcWnD+YrPD1TvUIqqBvxmc+mxLmfZv3C+SUwB6+GS3FwKgY4Y8y71ismdhG3xcow
	1OquV5DUWc+t6TWoE1G1ZJTfj3cxZezyBbQjZE+Hx1dpzHu4gS583cxWxuZYM1ivpdM3dz
	Qe/ov67OIAu+pGSeSV+9HlhFZT/fUYI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 11785446C2;
	Sat, 23 May 2026 00:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4F9BC4AF19;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495484;
	bh=uanLLPiIlhpaco9yHPFpbm9KOBBf7xcr00hgA8gE9Tg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=t+s5jEHXQVV11yDWPN2lvljf9tkwuMR6WDfadwBNHIVL3Xpj96SZC0407NbjOtDVK
	 OzX5Cq0fAqg9PR/4pFrEoNq3mm0ER9cGwTFu0vV7kvLHIVhcGUgWbv0EvZThZ0JfEy
	 Emhl90NuaSKn3FELOdBJlwzIYsPHHYHXTA8CmmVhzSN0xebnBFqhLFCNUDgYD/wMgw
	 JrO58p2MxdAVOQKHHrtgK3xR032wAWo4VttEfE50Us7gdguFhohcrmw/irdMPFUnkb
	 aoIJnnHfZjMoWRn6ux85jL127P5id2yDbftMjlo6gSDouX2rizYg78RoSrsnh5WQJc
	 qp5nqgee7ZXig==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2676CD4F3D;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:59 -0700
Subject: [PATCH v7 17/42] KVM: Move KVM_VM_MEMORY_ATTRIBUTES config
 definition to x86
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-17-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=1849;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=PUYI3jndy3F862UCORrQdb4FGWu8g5DuPsjX5atXPro=;
 b=Iz2yHAfyZD8KXHbrv1HtHnbVe4gWjhWvpRiY/iU9XcBeiErgnnnwJm2aOQr/W2exDGOYryktK
 b/bPj1ZB8awCy8ZOomyQbPec4xoRxIPJ1jLa+27qztC6AiBZCWCfHiO
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: ui4ny7dc7g8o85uopqrnq8h5qcri1fpa
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B6B8B120008
X-Rspam-User: 
X-HE-Tag: 1779495490-962609
X-HE-Meta: U2FsdGVkX19aELZmqd9cbwNRbx2fGOgWkLnapsqk5v/A7gTEJl5iX1o2ykaaodlUWCMUZZDvlAhmor2D3T7+JBLpaAjjQRnEYqaQKJvJDdZrGaiGTozFkqqCuO0HpF5S+C9m2Q+ogrwXmWvQzseRqX/MsxwYYksDAz+lRZXrXpoh7yXzB2kfbcei7i1ELTYFCkQOigHMkxy42ERHiHlK4SKoBHth4h5gdqesDhIiUXSdGErQt8p78sQgOFtnRM+k5b9r5xuwinbhYoBtUC7JPeopMvdnDwTux8XnooYlcIIhfdjV2nJ83reamuVsbESfHR10lFgYfKT0McR8iYgKpLHE9+EpTjF0LpNzt3OSy/bnR0Vk8RJ4AQB1ptFpnicO9VjnnZqITOyS26AWFF13jYmDRnHzwaCJUshUzmGK9qtgkM2daA9yTejcDQca48Cuv7CVEIrPgBFx1F2xAq0sCQSkln9N2nbo5hESSXoFt9QiythXIZJmGIS7qbIPH8qDiWxBwxaPdTHmEz2GKvyEDbAAYya6QxpPoD96i0AAglIrzGPx9h8GUovIWHDnzeVXhwXVRKx15oJZwbxbaSf/a/UvB8aSi/pJPEHKCTp7YF26dXmAKc084VScQUhkoSDnGE1gYQreN4B0madlCtUBfHuYBzHmrbmFpBm5U537OPug6l+p0wTiClh1IfV4lzImzqOMhrZQ3bhJ7vbcFTTBKUwq41kjiUjwrSM0yGIO4evn3SSicDfOrNzkCuWildVX2zFGoK2fYw/OT0WTnzXCJtc7wVmKSIUIznURsE+w0QfMud0eojpkGH8OyGfZB2b8bvwCyXW/foPb15gq/PJV4s4wa2syPVI1NQb59rcewGuurwmqoe9nVHO25au5Dy80cskUnMObz0BJukrnMDA2PeqJkzhdOir4NWFHsOTkLNXXWCWe5TVDVHqpnZrezZu7a30UTpd+wK4d+RbR558
 LGD6pxNm
 yBygwXDeLSkxEGDSOPhOXwwPp9X80HD0xz7pPLpVIECf4aGnElVuk2BC0Yslyimm4AYP8TvOvMgutzFHU7rcg8FG5yIvpr+/rBsPhXl3uz7ettqEug5yxwbo6aGaRxOFgF0GcGvFUnDz3s37b+j3OFl+8WUYseeCUMrGgdJ4MZNEsb/E4LX7awIdeA66eqiAW26x12oVp9esagBbrGMXv2gkB7QJAwR+RMdhepFhZuLw1c7PRu6J4dfJOFIVeGDHaiv1CLZxBCEeKlGk7d6Ye0FD64yr1eGrBL+/N/88pW34OIyyaqRbUZedzFlcJ/JAlnqZS76k9SXDjf7d6rd9+tHkRD+LuzZvvVuzYqeIWa9JEWUZFkVA1QRgL2AuZTng/Euon8oLYlazg2vC0GNIsw/ENPv1Ngo5VoYBWinFHEnnt+6EKg7YmA8NvCcJwLzXezbd2rrD46kZEeBiRjJYA8y7zjd0cZzLEfc6I1YKFaXYg9Ov8aYURXmAPHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sean Christopherson <seanjc@google.com>

Bury KVM_VM_MEMORY_ATTRIBUTES in x86 to discourage other architectures
from adding support for per-VM memory attributes, because tracking private
vs. shared memory on a per-VM basis is now deprecated in favor of tracking
on a per-guest_memfd basis, and no other memory attributes are on the
horizon.

This will also allow modifying KVM_VM_MEMORY_ATTRIBUTES to be
user-selectable (in x86) without creating weirdness in KVM's Kconfigs.
Now that guest_memfd support memory attributes, it's entirely possible to
run x86 CoCo VMs without support for KVM_VM_MEMORY_ATTRIBUTES.

Leave the code itself in common KVM so that it's trivial to undo this
change if new per-VM attributes do come along.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 arch/x86/kvm/Kconfig | 4 ++++
 virt/kvm/Kconfig     | 4 ----
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 26f6afd51bbdc..b6d65ee664d0f 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -80,6 +80,10 @@ config KVM_WERROR
 
 	  If in doubt, say "N".
 
+config KVM_VM_MEMORY_ATTRIBUTES
+	select KVM_MEMORY_ATTRIBUTES
+	bool
+
 config KVM_SW_PROTECTED_VM
 	bool "Enable support for KVM software-protected VMs"
 	depends on EXPERT
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index e371e079e2c50..663de6421eda2 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -103,10 +103,6 @@ config KVM_MMU_LOCKLESS_AGING
 config KVM_MEMORY_ATTRIBUTES
        bool
 
-config KVM_VM_MEMORY_ATTRIBUTES
-       select KVM_MEMORY_ATTRIBUTES
-       bool
-
 config KVM_GUEST_MEMFD
        select XARRAY_MULTI
        select KVM_MEMORY_ATTRIBUTES

-- 
2.54.0.794.g4f17f83d09-goog



