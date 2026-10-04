Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A240ACA5FEC
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 20:55:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34556B0088; Sun,  4 Oct 2026 16:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6196B008C; Sun,  4 Oct 2026 16:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB436B0092; Sun,  4 Oct 2026 16:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 687836B0088
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 16:55:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E72CB40C06
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 20:55:37 +0000 (UTC)
X-FDA: 85286149914.14.3B210B8
Received: from mail-wr2-f11.google.com (mail-wr2-f11.google.com [74.125.225.75])
	by imf21.hostedemail.com (Postfix) with ESMTP id 415B91C0003
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 20:55:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UW6piJOh;
	spf=pass (imf21.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.75 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791147336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UzFidq+NXBj47/Ep/6RIWkRxXs+9tuu6zEHYY1jeWcY=;
	b=Go3uB6oDvGDLhGO7Ex1Y7AdYCnw3Mfs2Q9jy1sgveTdONIAmkcUg3UU+TKpZ35mqMkzh8N
	zWQl9mDnP8GlKFK0Xzi0c0EJdc3MWgaIJSZuzT2yZU8wF9w8cOrJV32uGtt/fhm3L+fOYx
	Ex+KYMsuNiyYULPN85/92uSFtFlyBo8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UW6piJOh;
	spf=pass (imf21.hostedemail.com: domain of jaeyeon.lee.dev@gmail.com designates 74.125.225.75 as permitted sender) smtp.mailfrom=jaeyeon.lee.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791147336;
	b=s0ZGjAzsC732ymARteW9EbkX3jfU9fwYacugFQa4kNs5DR6IvCRtJboTpz/s2zaazEQn/t
	5pbbtT1VJHwOgXfy9Ggsm4UvG6nbx2DrOFeaJTznd9r9PqmoIqN1aJnkOduXPjKTbd/J05
	6IkAmnigKwP0R7zBsSAjFfidbbB+leo=
Received: by mail-wr2-f11.google.com with SMTP id ffacd0b85a97d-48b05d75172so689135f8f.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 13:55:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791147335; x=1791752135; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UzFidq+NXBj47/Ep/6RIWkRxXs+9tuu6zEHYY1jeWcY=;
        b=UW6piJOhKpQM4MHjwHc1vGv0s0jVdjwy85KK9cG9m2A6uDKBf5JveEu19LthWly93S
         BaJEJ4vKyUW38V+rMBUuLSEiZpkyxdYEq4xrF04dVBOII0MEIuPPSSBD2Y/oqzmjUiXy
         DVirHFO6k0GXSukHT6TGajjUF9qqdJMjpDNdY+DnA73+caAr0qxN7IliaUq7eAc2L/Du
         /Z9A7yYgqNUIJk/22Kvre/YHdEZvXTW2AtngyL5ny8q3pVTmkq2XW4NKXaTH+xjUFiF0
         kSUOF0HrmATm5S2Dbyu7b21zLo0cbT0BlWIrKh30dzA4Bzc1RGEWMp0VTp4/0qHM+msG
         Dimw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791147335; x=1791752135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UzFidq+NXBj47/Ep/6RIWkRxXs+9tuu6zEHYY1jeWcY=;
        b=x7eZksou9UdruOyhWRSrAdcdzRH2N+YZylh42DcsXh+KgNgzoLalY7uZAnQzC7UR61
         yMST1l5cMNSPl82NnxOOkZett+vytUI5sNxJeyHPqpIRbkxd6IsmLg2LUSabgLdM4I6S
         T9mXd/0yRGV1vyEu7KpICS3d/A0awAhhgUTZ3v5MPHs8zpX2GBq7sMk8YYT6fUNfvL/V
         j3Dft1CdZ8w0PE5nULClexy6I8P/NbaXMgYP0D3IgxljxwthwKwHQrE5HUr515yCT3xy
         5jLg8t9J3FEooRZDhmtz3xQeK4maCE9CxUWwzrV7TLfGpZKxQptxvJddotyLAwpVuq52
         hFbg==
X-Forwarded-Encrypted: i=1; AKwUvBzrDAMhAPcyMtXF2FpIS/UynjVaM63gye3GvBt7tBf6L4E5ZNWPinTzz0Ub/PCIbSVqFX7VoXCEcQ==@kvack.org
X-Gm-Message-State: AFq9FYLGsfGbuqt0AI3sgVt2IJcFoH2Ntb70jTXoRS4pebXZjTDIrudB
	KWneX3z4d+kPyPXzoMw7RKCXgx52jlKhXG1ic5ZifJS2Pn/XT3XHXw7C
X-Gm-Gg: AYBFou0smAJ2EpdC/HxwR17c83XsSqD+VHV3nXTJZERh9GU8nqXOPdiU6CUK3lVDac9
	dMhZfEBKhDOHexTtLYhuTY9KtnN4Hmq+YVkzciTcpi+uk+ywV5zlqfEGq5Tca2UY/edSgFssccu
	isXSfaOVPvVFsnK+fQ7bzVYbeqlyArpFSTalRcMGNPLnvKenU+2d7wHkEFld3UceqGRSopn50JL
	J7nmNd22/WeF2yH1uRYrOHrfdF8h7oQhPEX6rjQy1WICDdYMRQJwK/SER9VbrjRkqkcVM5Vgnij
	6rM5z9r//pX+ZqzU6+TN2qC1iIz83PKU/bOV0TCTdS0ManYJe1oJp41HRd0f0WrBYpBCCBgEySf
	bSd/96ri43YfXgFLjRFUAdeKkDEoV9ndc4QsYS3uW1Q/5Xv7XjK7Y5okuRT4kiMQVJYZb0lOAei
	DJWeKnSOujkBovCBULqV/rcbJTov8+bIIcBYa+9DcJC0Tb7YdDxY0tF6Bugj0jZKyFFd+/SFNjE
	/eYt9K+ypfSlAtfjBGjd5n9SX+3kP8lyQltr1DPZePm8irQzX9K8gEpq7J1Ykumu7VbY+gb0eSV
	DvhSbWJsEY6GF27/NiL1D8s12YUDshjJzg==
X-Received: by 2002:a05:6000:2586:b0:486:f3c0:c26b with SMTP id ffacd0b85a97d-48c4803032dmr9225013f8f.57.1791147334624;
        Sun, 04 Oct 2026 13:55:34 -0700 (PDT)
Received: from lima-kernel.telekom.ip (84-115-220-212.cable.dynamic.surfer.at. [84.115.220.212])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380f0ab7sm20855638f8f.7.2026.10.04.13.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 13:55:34 -0700 (PDT)
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: [PATCH] selftests/mm: hugetlb-read-hwpoison: add setup of HugeTLB pages
Date: Sun,  4 Oct 2026 22:54:58 +0200
Message-ID: <20261004205458.119608-1-jaeyeon.lee.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 874tp67e148nddazyn4ct363s6h5unt8
X-Rspamd-Queue-Id: 415B91C0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791147336-392140
X-HE-Meta: U2FsdGVkX18zZGaPI4JeQHXZJK7WDPgZAI0Cb5rcZiXgfxONbwGIIuNSj9kKGucZVQ0z6m6Z03qOSeN4cp3EYqBWGiEQ1wKcHpqHkONCoNd+JB386H6C7lknjHNEN2YFvZWSLgMMEqoAMSBoVuWfySJ4Z4muZ6/81OLzoKX7ELGpQEeA5/JFrTrlxWsXl0/MOaq3zSyfOWj3c+PBwcvQoP8vstRF5CC1wgWSL5VJMdMy12uWlsO00UMIz0LHSWI4k7TCc709XakEoGwIPAsA+LTIhc5f19w4kurw6IcZZrMQpvHYSRJQPAr2NmMnqhrAzZ3J8Ww1vMUHyinZ9AziGycKw0xelpRtYvUCmlD2FkShNkfDJKYTe0mpjDLBBKf5Yn1Va2bx1p/fHK7tzgoeHxqJt1kwtL4jV/t8AjinPacTSMucaGEWunj5de7iGaw4AvjRNX8cAivY1p1T6TTuRoV6fcHDufNuvLtt4r5JI3HwylVf+sIsTs5haHbs4pjBwxVCrdF5VGhG12TETAFaPYsJ4GreDeimW7SvsrFPgmE4yLhzpekOrBk5P1aPuDqiecHwu7kYbUvI1y8sbNT7+20xLkLgfLPDPU0PGeLiNHnMkdpp8BIjKocb7Q+ZgkJryqYPIpXVLgszR0nn09w6lqkLAAxUqZYUjCZlEKKvKJIDGf6PC4ijFUOlKtGc1YlA/NwsbGY9T+xUGhKIV/j+w1aJ/MkD74Vi2RW6s9Mr3oGKO5vPMLPSljJyC6cJFAoX/EVmE99TlCxWMBWWZc1Sl41b5DNHQjWEvxu9w8TiPYb2ZhCStWw36WKO0KuTWi+aTfARquZHoJza3FkNhNTBlJXLDzvgdEfl43OW06XikxJ7mbXVklI5adEyAUkT+M8GVkuBuXolR7Xn4An6xsUflFo+wUu0ySk/9FePf+1edg0+s6A9HIcNa51wh1hs+Bk1WcpBoVXQkSf7hxAB677
 Alx7klTz
 aYgDo+dHJfNf2+eVhWCXU9d01aT+OV+TXbYYTWewxod811QhHcf6WneaFjrAuLjjwrQCgDupX94PJNWaQ+FVdmqUJY7bEmnOn2BNv7eFXEre6Tt55//uMm+JXwAaCVWxxBby5X4T0MCAH3Mq/3tFDbmlUGotHGE7v7klpOlhlA2U8fH/NjuZtBwUQ61wbuz78MiNnyhlYAa/r4y1kgyDxhOLptlPqpIBitA0B8psFD64GfJF6uxjqZr7VibvzITIV7nJvzaSeS38XjcL0JghSlw8R3rMDCAGnsgmxgKSwmGzs14ZplV3y/sQI++FzHrua5459PQjKoO8k/s0nQlmMuhyL0Y4IVETRbvrpvwyQqDQk4cf+dMMFLeXyQzC+BH4AmtP+pAO4BnISuPy3E4GKHeSZdKYioifrxGlXXhQefEXBTElNEtPpiW0a0RkgteBACgwv+vex/Mn/+fA/DwiVa+9GFnGff3Eotg2Qjc4VxjHEpOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every test is expected to reserve the HugeTLB pages it needs.
hugetlb-read-hwpoison was not converted, so on a system without
pre-reserved huge pages the MAP_POPULATE mmap() fails with ENOMEM and
every test case is skipped.

Reserve the pages with hugetlb_setup_default(). Each chunk size runs two
HWPOISON tests and a poisoned huge page can't be reused, so reserve two
pages per chunk size. The pool size is restored on exit. The poisoned
pages remain allocated until reboot.

With the patch, all 12 cases pass on a system with no huge pages
reserved (tested on Fedora, x86_64, CONFIG_MEMORY_FAILURE=y).

Assisted-by: LLM
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
---
 tools/testing/selftests/mm/hugetlb-read-hwpoison.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
index 70b24e3660c4..31748a24448f 100644
--- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
+++ b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
@@ -13,6 +13,7 @@
 #include <signal.h>
 
 #include "kselftest.h"
+#include "vm_util.h"
 
 #define MAX_WRITE_READ_CHUNK_SIZE (getpagesize() * 16)
 #define MAX(a, b) (((a) > (b)) ? (a) : (b))
@@ -281,6 +282,13 @@ int main(void)
 	size_t i;
 
 	ksft_print_header();
+
+	if (!hugetlb_available())
+		ksft_exit_skip("HugeTLB is not available\n");
+
+	if (!hugetlb_setup_default(ARRAY_SIZE(wr_chunk_sizes) * 2))
+		ksft_exit_skip("Not enough free huge pages\n");
+
 	ksft_set_plan(ARRAY_SIZE(wr_chunk_sizes) * 3);
 
 	signal(SIGBUS, sigbus_handler);
-- 
2.43.0


