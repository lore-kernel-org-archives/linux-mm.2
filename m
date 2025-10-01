Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68170CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 04:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF49C8E0005; Wed,  1 Oct 2025 00:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3888E0002; Wed,  1 Oct 2025 00:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE0718E0005; Wed,  1 Oct 2025 00:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4728E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 00:34:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BA3211B0D9
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:34:54 +0000 (UTC)
X-FDA: 83948280108.11.C0C358D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6787816000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:34:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GA5avzjc;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759293292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AksJYMjR0EFY5Pbn6MonfRRHjJ3TUgaXL+VXE3PlcCg=;
	b=n+/rULklo0RhBwuAKXM/5DvnEA+qDe6GGUogmNL0QADKnAgeJHDr8PhvdXhFUjw/N9BceO
	/7bScF8AdT5J9tTbVrkmWQZPMLdqhmzFEZhHmzIGEo66GQyInvKpMkg4j0d0j+5xWxv2hu
	FD1Lqs4a1rnicEc/Y4WF1A54rcoWfuI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GA5avzjc;
	spf=pass (imf08.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759293292; a=rsa-sha256;
	cv=none;
	b=25cOOmV84VxO32GbCUahRv4Yb2uAaVhpBKpBmsKg57kSZbk7NFfcYlmqGtKjWrb+ecZjBb
	YbSl5YJKq9uLdyv0oPRj8WLhxiV6T6VdXzIaMVNjLYhjQD7Ezfs4rQzErtT8wqItbamKnN
	1+rDexuISUBXBOb10gj2ozIZWZqpruI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759293291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AksJYMjR0EFY5Pbn6MonfRRHjJ3TUgaXL+VXE3PlcCg=;
	b=GA5avzjcO6Zmfng0OIjDJ5m8faIEhIL05Jb2VcKLHd2tiqXCeiBW3pO12AeWiVmWkiicQQ
	Bh//Ka2OTIKP8wzWAO1qaUasIaQDCrGIb/sI8wV8iEezhQ7lQs48RyBLE72nI6RbgGDgGa
	T8zQMCbLa/LKyOxWMGYcnzY9l0VThkQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-435-XIF_mvPRPVupgzKcuQMmyw-1; Wed,
 01 Oct 2025 00:34:47 -0400
X-MC-Unique: XIF_mvPRPVupgzKcuQMmyw-1
X-Mimecast-MFC-AGG-ID: XIF_mvPRPVupgzKcuQMmyw_1759293286
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B898619560BB;
	Wed,  1 Oct 2025 04:34:45 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.116.46])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5FBD1180035E;
	Wed,  1 Oct 2025 04:34:40 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 0/3] mm/swap: remove plist swap_active_head
Date: Wed,  1 Oct 2025 12:34:33 +0800
Message-ID: <20251001043436.41338-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ub63ItWysZXuHg91t48yS7Oddh2xpinSdFRkXzt941k_1759293286
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6787816000A
X-Rspamd-Server: rspam05
X-Stat-Signature: 18c71769zpt4bn4s65grh7hnq6t4cfxa
X-Rspam-User: 
X-HE-Tag: 1759293292-264050
X-HE-Meta: U2FsdGVkX1/oNB1qA+9Zutt8hZCvZfAJHHcq6U3RHBjX4GNn81akPODEKrJ9FktycIsp4i9VrMTTtrhDKijL5gtd+KN5tNV1WCBqOWZnqIg0oiRdIYk2T7vOb4kdSc7LnswYIFWfpv5mB5s0HcaS5gwhROPyYpEtPW1HPYvHEOr0Iz6MftblEi9ygrh38CqrjQiPsjVwSHaDygm08MYky+8CAMSdYjY93NG5rYFLnjO9CAF6uSNKHTwvBevvEKJNI71BgUIuQg+ZoZAf6QoIKQQYpJ+6nUKLINq0KpyzlkVAAwbpqkXvfZO8ZoYqyg0x6zpRRGBN9J5+HMw3iHHkXGJyUs7nrA5YEU+zuFkeZPeNWEXSbmZ+6+hsA7RtcHX/MuP8gL91yfOGVvjWA+KkUzCKQ5Q5HbDXRumq+Lq8q5EYgyG8JX7kIZX/xagIbeT3P1ClTF16SCZ6pJab4GMyTNZQ3LlosVAIrBVom8cbRcohOeqJZ8P2PI6cZ52z3tYdgLqh1PYa2bzMeySFvtGVMl/eyAS0JPkdpCaPuc70p7PmcanVhesuHkn5rCspaXila4jwgMqzHAe8KOh+ugjdaVuc7Q3G4X2aRRXg1cIHvjJWvW22apzf+WGGDLU6aKt9yU4mgb4u2EQcXfcchW9mEvSaZbJj8vTbTirIfn8NXlx9zGgT2Wfiq90qsO1+pdIlnxZI19v6lcF7gyUFh4d9+j7Qf8l1EfYrNdl0euYVNQqusb+8SU2axuGLwx/biCO0PwAdtPIvs8Lwy+5EwwVsTxMWW8kHAvbWhBhdcXMw79Qa6embG8HFWYUcbLVUjV3YD3REcylKHs15yZVCB7dMgpBJNcwCCIpB5JzNEEMB8PlE7AsR17GD/h2EoQujZeD4INDfKivf6C26eg5gXu/MPwNx2BHAswDW3q6aLlpAA2fBkM6KmlwpNSaqQSZS93wdcA2PPGIMEbU/XpgcPOe
 ksdHUD7D
 T+Y8SGNPPgfiqfhH/U2tjGUbqkY5kXgm2iAjORTLCDb6gQKPeL3rbkaokHPKajqa+24fHajAbsnzFD4h9ff2TrF2vNNls1ikZhu7QikQEv2Opo8VxXOEea7PQcDHqgsZhVIly1/62qNFOcVhcupZCVLO4y7Hzo58IEehcnH3JF0EWrR7+uC1gu2/CwiIfpWPdsn5TDjGKF6zWJXRzIaxljIUN20PJSHW4rUYLgf6tPTLd5iCxcGUJvDTzfRj4n1TTNaEYuALHJP78/3I19qSf6PxnCMrITH2w6JYpWuxR3HszCc2XesddWjbb5B64nd5lxLqcE2vRgDZOpAWD4eP5bhfKwp6fn+4Daz2QyFJNfcRuDaq3uAV+1vpStvgH2NXTQ4C+ZWJbRAdh8In13FR9yA91/SnbuEY46II2z+xE0L5tuNQGxkj0zeQ3Vcw2ykiXxHCZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mm/swapfile.c, there are two plist variables, swap_active_head and
swap_avail_head. swap_avail_head contains all available (active, not full)
swap_info_structs orderred by priority. While swap_active_head contains
all active swap_info_structs (active, nor full and full) orderred by
priority. Earlier, it serves three purposes:

1) When swapoff one swap device in the middle, swap devices of priority
   lower than the swapped off swap device will be promoted up value one,
   e.g, I swapped off zram1 of priority '-3', then zram2 promoted to
   have priority '-3', zram3 has priority '-4'. This is done via plist 
   swap_active_head.
   - This code has been taken off in 
     - [PATCH v3 0/2] mm/swapfile.c: select the swap device with default priority round robin

# swapon
NAME       TYPE      SIZE USED PRIO
/dev/zram0 partition  16G   0B   -2
/dev/zram1 partition  16G   0B   -3
/dev/zram2 partition  16G   0B   -4
/dev/zram3 partition  16G   0B   -5
# swapoff /dev/zram1
# swapon
NAME       TYPE      SIZE USED PRIO
/dev/zram0 partition  16G   0B   -2
/dev/zram2 partition  16G   0B   -3
/dev/zram3 partition  16G   0B   -4

2) Find a swap device in swap_active_head when swap off.
   - This can be done through iterating swap_info[] instead. Change is
     done in patch 2.

3) Judge if there's any active swap device via __has_usable_swap().
   - This can be done by checking total_swap_pages instead. Change is
     done in patch 1.

Among them, the purpose 1) is the most important, while it has been
taken off in below patchset. So this patchset removing swap_active_head
sits on top of it.
- [PATCH v3 0/2] mm/swapfile.c: select the swap device with default priority round robin
  - https://lore.kernel.org/all/20250930063311.14126-1-bhe@redhat.com/T/#u

Baoquan He (3):
  mm/swapfile.c: remove __has_usable_swap()
  mm/swapfile.c: use swap_info[] to find the swap device
  mm/swap: remove unneeded swap_active_head

 include/linux/swap.h |  1 -
 mm/swapfile.c        | 31 ++++++++-----------------------
 2 files changed, 8 insertions(+), 24 deletions(-)

-- 
2.41.0


