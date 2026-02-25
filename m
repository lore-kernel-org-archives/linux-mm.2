Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8978FD45F9
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27ABC6B0088; Wed, 25 Feb 2026 17:39:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2290C6B0089; Wed, 25 Feb 2026 17:39:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A696B008A; Wed, 25 Feb 2026 17:39:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDE956B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:39:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EEF41A074F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:39:05 +0000 (UTC)
X-FDA: 84484445850.19.68A2018
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9B5DCC000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:39:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WiiQd9vs;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772059143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=67P+JH09J2cm5qxmBeSmD51+Qk6Cs1f/aDxhT8sdTsA=;
	b=d6QT1dUHXHxHye1+W+KFh1/c1GIIbSrND+lUdFc48b+JfCqS7Ig0szC4V02raNZJAoqbkY
	FJXkUwfNp+BE2ZZtJlLZyDL4BTxehawtKsbgG2ZRCr7eyHO2CGwl3dr/QboQIRSU+0UGuh
	krcFd5cgbHal3g079afw21vKg6fWSvc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772059143; a=rsa-sha256;
	cv=none;
	b=pZYDH+7nUOBU9R+K0qnM/TGVzEClvHYRV6guOwt+szoJvgL5MU6cKOXA2EDsIftgNJ/UjX
	/Mrh/Q/E6YJcS2QT6sirIA/vQeCw9YDNPLM+39VxeHFqDZodFxnUilSYG5/m3a3Ygv6hKV
	ItCl1ANJstFObbZqNBOvAvrKc1gT58g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WiiQd9vs;
	spf=pass (imf10.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-79868eae536so1823647b3.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1772059142; x=1772663942; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=67P+JH09J2cm5qxmBeSmD51+Qk6Cs1f/aDxhT8sdTsA=;
        b=WiiQd9vsRbPqk6frIP1DZFRy4WmhwjziPEQThBnI7Au7t2blwN1BP0fxQUF2ubp40Y
         xOtbs2rO1r50gK1drxWsW0UkrPh2Bcg3H1raddJv5YiLj6URkR2vIpIKZ9HG1YveOxaL
         7ECPu8AX86ISyZD4ZpMfFtwAeJLJ6MfNFxtkSwW7M6FHB62tSHatZ6lTEaGjDNOY7+Kv
         ky+0fwVv8/h6AQfwderk0Ck7LF6fG3BsTi5ExjbqCgSBzcn/tf0k2bESaB0HO0ZlBzG1
         3NRXRBPvGDUHDkVe2iEIwf0BlegKanW1kfGIASWaTRKL2CwzHlWaxVIc38SScbZSiIID
         kqKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772059142; x=1772663942;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=67P+JH09J2cm5qxmBeSmD51+Qk6Cs1f/aDxhT8sdTsA=;
        b=rjBLmHd6acQZ2MqmW3dUX/c9dtrZCQj5uS1DLp9xB3zZaUIe839mBlV4UOcKrTHcbv
         Ls4e01YmaNPpw/G8DgHnpQZjG/XRGlEzBk3P03ijsnRjuJP0m1CqcJZdUBfE28jJYZnn
         Hr9bp8J1fdibRNjtp5wIE9vZWhddDt0DXGVyJGfjftmxjYOlfu31xXUeHfiWepkpReB0
         Cb9/92TzfLeRZqqJkqovDykfkNcyQAQkF23JN1imtAoakCD1iteFm30i+WB0Q2LUjxoz
         mAJhHY4NtQoCR++gmZrOBovIXlEtz52opYerepUvosOflw/pbR4y+qhzmSfPradXBJub
         cTGw==
X-Forwarded-Encrypted: i=1; AJvYcCXpgv66FfSNy/a66z7vcKKeGInCdclNypP5tfKqiKb6JAkRUwSBWFUUCCtZa5IxjXj1/LkGrr+40w==@kvack.org
X-Gm-Message-State: AOJu0YxuZSWnrDW9vbBfyGDpaaHgrjOJqJ6AkT8n65a7QOzh/nFhHELu
	ly7ZkInx+YrNXyn3ATnThc1l791zQXOLaXnUXF3Ic2aGRTGhj/Z/H7UK7e8WXsBFVNI=
X-Gm-Gg: ATEYQzxr7P6IwM9Q7Xl7qz41ZFHcYmi63WcZoCiCOPO8a/Ofw+XSFoQm8HPESen0Sw/
	9g//6KsGW0iOfl0cmdKtziBrvlcfyvcQfzA5/wgP7H9dsOQKqncudZ4g6cLzyaZckzW1lVbUuC0
	Fspq/41RdBaDhpA2FIOSproz3y+Yk8qF4dlhkN0IU8zB6feFkcDKOGTFmivhLt9swaXkKi9GP4w
	MgWA8+QEathO+5qKV1hKaA1JcTGhaLK8H/zt1B2ozw4pu7naNvsqWGsSbG824841/4XOlZqXvIr
	QDRuywj9UAaKVawUbUtxvR3svEBOSLuHweio9v/VEjJzcQ4iCUjZ+T7DN4MHcUiMuUL7TC0iAns
	qTHeoxzVuEUgmtDLnxsA8gZDqmQwVGOV6h6kyfzGR1XjAKSGg2Ra7GU96fjQnHL5lJg7hrxoEwq
	dUfaCF3x2zGugjcqa+ZC09W5hhKPc0J/A2tRARlXylr4DIKnV9ejEB/GlGJRApdY0rDx/TShh4Z
	1bFBmh6ZjV8yQWN+rq3uVo/mT+hVIJV+YcARlVWYgZeWRRi/Q==
X-Received: by 2002:a05:690c:dd3:b0:793:bc67:da0a with SMTP id 00721157ae682-79876df6923mr1779657b3.47.1772059142639;
        Wed, 25 Feb 2026 14:39:02 -0800 (PST)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79876c992b9sm918297b3.50.2026.02.25.14.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:39:02 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	urezki@gmail.com
Subject: [PATCH v1 0/2] Fix KASAN support for KHO restored vmalloc regions
Date: Wed, 25 Feb 2026 17:38:55 -0500
Message-ID: <20260225223857.1714801-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7xphmw1s8eg45w9op348duetkssuokyr
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B5DCC000B
X-HE-Tag: 1772059143-142537
X-HE-Meta: U2FsdGVkX1+2r1AoZhcZka/iGwgzijQiJ4pr6V9GrrbU5MjooyI2soWdyPweO7tnsakIdp0StW5DRI5fH7Nhwl6gt7XjeO2b8fgi6Y98rUDC31T96FvNbXvXL/V3vjUsln79HR0yr2UwJojGoxEChPJVmnSF4rsJoYIpRjLyLG2NHwRUiBB3HELpgNHeBAkCnblwU6HasrmdBQ4mTzwzo7H8LKa29n8qhZnuFAHoOszHO0FPPzwaYtCfeeLnb/kc2qaE+epGoFEDHYvMcrHN79X3zBmTpkQuGvv+4xMyodEgdsPHO5zlmtMdfdYvoWa0/bftBA7Ij3f5c/rS2I2rEfmZ6Ysj7K3TEckaO0wN9HpjcrduChETDLlC3j1gRYV7QDqMpoNJFTXpZmh1T6aTbsLBXfoQlGuSX5tw4sHX1NhIbudb0dBd3Suyslef3wN9KnSX16z5+z7Wjq7M22TkPutyg+Nm/p3FRAgqoRq3ZRpkDOTYFJHKPri8xehSCJ+gTs9xcCMq9yipOB032t9JjbkRqVIyoLUEmhrYKYP7GbIVYGqbEMfDgXFva9DikbysiDfOFjSnrjkXNKUb8uSrgNfRe3yE18sUOC27dYCXxFJeMjomdi/r5/gaIllXcREj6xBu+zQ402RqZ9BmDvvxhS3Ro2U8aZC/2oe+GiQThNyyg/7yPN3FuLMVf0VPLQnScFxERjFyTT27MbDvQn0NmElzoRrZxnKQISpigp8+VCtu6iFzYFTgZBR3Vkio3XyyahHyzG3KLL0PwNhsXfCsCI9CXyjg1xJTwiTPZZhk4ePheMFd7SzgvVMYw5i7KA3LHJ4hKZiZ7FSJJpPkGio3Q9afsqOxRqWYMBPdyVW7a8LRbesuWYM2RX6yJMXj07vmE6mRB1bJ9Z4y1xW8mjfe1d/eyIWHvSm1QRUETwOqPeh9K9VTbIlngg5d8Ruo5HfkFAX9Eu38SZ1yC6mA+Gv
 Fm+FK6lt
 vYzrVX7t12sJOeA9Q55u0yE3BpK/n8NsdTvXSmSaPZOT1D4qiWdN9Gb9VjQQRfWVbbWhOIu5LusuHV3mfZOpV0PKBi4ucQWJTnhLObK4nlkhOne5EUiZvA/qdcF/HDe/aU/2e+nTgynRCGvkkvLSv4eRV4HO+MksTsXP1BFFqPNT0sPx5kv6Mz7suahwDUPCVnqPpXW3jstAViYIJtVVNZH9U6VuVTCgLSfmeWGTU/EYyfgXMYE4GRddY0lkjZlsf3MOReV9SZlyX2QtivuLloHyKNt6VcGYzvnOjM1uMgHr69mE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When KHO restores a vmalloc area, it maps existing physical pages into a
newly allocated virtual memory area. However, because these areas were not
properly unpoisoned, KASAN would treat any access to the restored region
as out-of-bounds, as seen in the following trace:

BUG: KASAN: vmalloc-out-of-bounds in kho_test_restore_data.isra.0+0x17b/0x2cd
Read of size 8 at addr ffffc90000025000 by task swapper/0/1
[...]
Call Trace:
[...]
kasan_report+0xe8/0x120
kho_test_restore_data.isra.0+0x17b/0x2cd
kho_test_init+0x15a/0x1f0
do_one_initcall+0xd5/0x4b0

The fix involves deferring KASAN's default poisoning by using the
VM_UNINITIALIZED flag during allocation, manually unpoisoning the
memory once it is correctly mapped, and then clearing the uninitialized
flag using a newly exported helper.

Pasha Tatashin (2):
  mm/vmalloc: export clear_vm_uninitialized_flag()
  kho: fix KASAN support for restored vmalloc regions

 kernel/liveupdate/kexec_handover.c | 12 +++++++++++-
 mm/internal.h                      |  2 ++
 mm/vmalloc.c                       |  2 +-
 3 files changed, 14 insertions(+), 2 deletions(-)

-- 
2.53.0.414.gf7e9f6c205-goog


