Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 803B9CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A3F6B00AC; Mon, 28 Sep 2026 13:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA556B00AD; Mon, 28 Sep 2026 13:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792F96B00AE; Mon, 28 Sep 2026 13:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5365E6B00AC
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:22:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97F251402B1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:22:10 +0000 (UTC)
X-FDA: 85263839220.16.0F1FD32
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9CDAD4000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:22:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b=q7z5dYxX;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="d Z/YLy7";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zqJEIjrQ6DEH0bzBdPreQIaAqWO4ZFFKb5xRcMeISvk=;
	b=5J8ya0RvDHqrcbjq118dtnFKgJePFd/Yx+zp1aflgKeJnuRUBDnjWRLwlDDIuoWd9YfhS2
	RaN6/6HBuNz4lvqQVSht3AjMW8hApx4I2m+YiKHhKb2el04/xjkNw7tDynp7oA3PQNp5+u
	ajONWqXFfncsm6IY0AyH6S8SFYqFAgE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm1 header.b=q7z5dYxX;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="d Z/YLy7";
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of linux@jaseg.de designates 103.168.172.137 as permitted sender) smtp.mailfrom=linux@jaseg.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616128;
	b=pvLH6ubu3+EDPs/3tYcZIqoTk+PgF2/6TmH1op7WYdMo5xfqrbvFwHjjOTxSF3kTqla2uM
	TLRiP6xNlxfIHmvClGi4FpRpR7Nuarumx2TveFmuGHhI/zva+W38rwQg4qEF9VShzZP55X
	+PsY0NT2vEqo19EXwkMsMvPGA795wKA=
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailflow.phl.internal (Postfix) with ESMTP id 2C9221380062;
	Mon, 28 Sep 2026 13:22:08 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Mon, 28 Sep 2026 13:22:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790616128;
	 x=1790623328; bh=zqJEIjrQ6DEH0bzBdPreQIaAqWO4ZFFKb5xRcMeISvk=; b=
	q7z5dYxXSS4OwQH4P09MZ8skwf0ROZIKytD4K9WTJOvcqGAKaQVY7LV9kjaTFa8/
	b+6vIN2M0ako8I4F3rqI7bFCuFfzFXz9sPCu8Yb95ioGvyo2SoDHZldeZK7lWl2g
	BoI5CXirTjOxUef/egKr8pnDiMaE9PlXhWeA7YX0CumdZ0GfMdCgwhOC4pewwVUy
	sOqPL9ukoEXlG6qqHF17Zrr6poP44Hgi8pjwuyczT6zkJcZ321YuJyaoBsk6CG+9
	BTG84DJqa74zda0Qw34TcOED12pTUAYr4rK+pd+Q3f5QoosgeTJb+K1UQHT0O/uR
	YEE0N+Zaxtmpv6lQIb7wVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790616128; x=
	1790623328; bh=zqJEIjrQ6DEH0bzBdPreQIaAqWO4ZFFKb5xRcMeISvk=; b=d
	Z/YLy7KA1cNMiKNGi9JOv+g8awM9GxK36+H4d85rwWj78m4ZIGXh6F5mngicmceT
	zicIWQanyZtA6DoH0zmmMhnOMKhhUlRl2lLUO6sklFLc6teqskrnTf4JaEMgEOSB
	GvPPeRimmAybmADqeWuSY6X7be7+EEiAGLrsPM3YugMd+ULTX6W92KRdr13O9RME
	8E+03M5IWHuYmWADzlQx92ij8Uq9/3K9pg7Yvzu9N5UanSgQsR+6xrv1l39Gzav3
	sHqfILaBgzPtNZPpO9CHLKoMI5p3SPr+IQ17hc8ZDhnSLZfTiUlwakdkr9if9usI
	3LVZr0CSZyZaGEkrlJz+w==
X-ME-Sender: <xms:P6K6ajJAOBbTGHjN0v1f302S5TEF0O-JC0mxIcWzL1d1RmXDXVTTUA>
    <xme:P6K6aqmfmb4yk7d0nJAUxfDbYKbiQrVhNwJBr1pvDBMM_ljUHlCqyZiYYhy6lwBfL
    1XC3fkUf-A89UcfKSUOyNonQC_zUDPyKoHxo0onKAkUVxlj6HoYzmA>
X-ME-Received: <xmr:P6K6an-teYipzq79MnIzGrPyJjl6OUslkMzliuh6yALBvx1YNJCr6YsTTHsfJ32q>
X-ME-Proxy-Cause: dmFkZTFVchM+bTT1PKuZ7CN10fxXJIikNoVdUVFHA1eqyKMgAAVr8P6ONf1Qg916JwGLA/
    UIAM5uyklkVrDRDmXBCinnisDlXug/Uvz0CnXEuy4xZlY+Q3iKI5V68dUZbqn8FCfsIN95
    6KfV8L2bBYYMAysjIpjjTtDvr59SlVXR0rT3rsZ8OOWBdCzi2fs/qRsgGZhcNemn8sEAcR
    7gOuIxy/+2FBe7o4KglohLGCDym2m4zsXZ2bZO1r7mHjauIXUwmWu2ruzm3DMO6W6IP24K
    Wr2E/Zfjs4QhZp1KylseoV5Uqh0JkwjuRMQihg5e/hXKn9gV8Cjo7+1dG47k97NaaXBvAl
    uBMp3yG7hqMpY6cR72TbbPzb4WDL4DwgP7Zo3tV4PW3EOMINqzVjPRxnhlRCR2Y81wlk4+
    ZXESSP30YPIfpM771/o9ZNkbVg/dZxlwRIpz9oOZ0s1wg/mXdIciWHQWrmkL4H7eqvPZQb
    Tk9YWXDslywLGvByrVpZBBzANl5Y65rqjjm3c3mDQHmIBNQ5pmqJvhvGbMuiD6rC7n0t6H
    8HB71TW8JGWEV4Xt/nwJ4nBpYoZyBlgApR8qnm1eih6RoOheGF138AUQlTP7flnkNqkJsT
    FbeZw9rnZyEXgcb05ZlFPSrfJBW0eQBLqsfqyjZixpKoGFx+VWiOTm6jZLUQ
X-ME-Proxy: <xmx:P6K6alaoEGY1cX8M1TQRE9rIBRrjD_xsn9XyjAIsKq6rz5VRgCPyVg>
    <xmx:P6K6akeWJ59dOSO97F1Z-FLzG9xeI6y3qrunvQXvy9dkEia3-SEQsQ>
    <xmx:P6K6atF7sbX717xyW9Dzzz1j7Wux4dsj7mQCBMHfn8uBc2NdfsjQZw>
    <xmx:P6K6avMPot1tr1t-Gc6S6MP68kYdoFLaIIDjEoVNkJ5VcLM2Wr4AAA>
    <xmx:QKK6ajYh0U5SE_u3mouBLcuAd9yYFXduZ3oEXOBhbfX7rv73dCYfyv_T>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 13:21:52 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Mon, 28 Sep 2026 19:18:00 +0200
Subject: [PATCH v3 12/12] kexec: Expose the crash memaction bitmap in
 debugfs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260928-crash-memaction-upstream-20260921-v3-12-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
To: Jonathan Corbet <corbet@lwn.net>,
  Shuah Khan <skhan@linuxfoundation.org>,
  Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh@kernel.org>,
  Saravana Kannan <saravanak@kernel.org>,
  Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
  "Rafael J. Wysocki" <rafael@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
  David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
  Brendan Jackman <brendan.jackman@linux.dev>,
  Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  Mark Rutland <mark.rutland@arm.com>,
 Alasdair Kergon <agk@redhat.com>,  Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>,
  Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Mimi Zohar <zohar@linux.ibm.com>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>,  "Serge E. Hallyn" <serge@hallyn.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,  Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,  Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>,  Lance Yang <lance.yang@linux.dev>,
  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
  Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
  Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
  Matthew Brost <matthew.brost@intel.com>,
  Joshua Hahn <joshua.hahnjy@gmail.com>,
 Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Ying Huang <ying.huang@linux.alibaba.com>,
  Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>,
  Arnd Bergmann <arnd@arndb.de>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, 
 kexec@lists.infradead.org, driver-core@lists.linux.dev, linux-mm@kvack.org, 
 linux-arm-kernel@lists.infradead.org, dm-devel@lists.linux.dev, 
 linux-crypto@vger.kernel.org, linux-integrity@vger.kernel.org, 
 keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2
X-Stat-Signature: 8dynxted8muuqrjb18jrwf4a1spgiaap
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9CDAD4000B
X-HE-Tag: 1790616128-23409
X-HE-Meta: U2FsdGVkX1/6l+JE/Kt+USoHKv6VP2odxGWB5YPcMRppeeZEctCXOeE6vvP0yk4OEHeXM/CjsDFaRDQNVK48OplhHcU3h5aLT2IWaPFsmCqWCHw7Nj49qLd7BO+Sho3eTXfE26q6yhTQXno6hULRGVgagveXj9xn7KfLyawLYdKTY9us09/4uzc9mdgmMQhpQVnGe8j5dldWTuvmotO9/co1wOIKSs80mNeYpoPW0pRSJUyI4D+6cJOUReH6E+MOTXIlTnBld1DzmDO2jpbkPVbkkammcM4MF7wSS0jRMciEwVzbsQycTlDukJFnYoyFPyhyCGyWFaha7XKdjA2WI+IiK81ZNyKi1iUEyklBG23f4JBwT8FDhuXrrp9r8GWkKZ8YIZZtbv3U83vHMnY30WPHOfoYmXWLMbiOuCF606j1IF0q5F/jMbBgoE4yAohe2oiBB+J8irSld5C2FtCSymF50MQ5PbXIJYDoQtFU/dXP2iZqDw/r4jfMTQu7s9o7U4mdUGiU+A/aRBx3wnSjPfFRPiKfRBUOxHeiyeveFKmWX56KdR2B+mMSs5BdS0IZhoSL4aD3/OV2tGpe/O18WwKdQXr4vp30NBux6Ct/t3I4renEGl0UomAastoAvAdIb+7ZtXlme8PoqGr8e33yjwGJGd4fVjgVRq8v7/3SyfQiZQZmT+LDONphTgtBvZBS07I8xf3nySLR9Y9WzkrMDhwwVijgPWfxK4ZZyRhYt52T+izQ1pYuotIjrJjpHx0hKHeM/gU+WG2Otu6Vt+6ws2jq+ltBt90/H/2fk75TGhqovvl4F7PI6KP9ZoPc9IK4b7/pidAbAA74W6u8fxJkLEaOXF8lgzMp3Rfg5QwvV4Q0CHF+AxppMEad0glGUcw1cYIlG4dYCzio7Tevu9H7s1g+wH/u7fMw1dpdarw6eSLpMGaBjAxNKwzz/zzgZnfy1kPq9+Q923ly9fyjcIQ
 kF2y/3Nv
 C20AQD6ATCmv1wsWoj3qPH2wptDKebts82o5xpp/LVKRL9H35z7H7fE+P9zJL4ix6FIGvuy/Om2bXb7mdQHXEcpExDZyxGL+fzU7BlH3IGZQa3kJM4EPNuo2xereKtdOY3I9ZFdoa3KXAXBD4M/BLj8yb5Szz8HERwLEOT5D1q/f8Cg54YkGmIyFwXBF8GiQj4TspGBlTmxaQQH6dWvXl3VDr2xU1gq9UrEI2LYzqu7KTkT4sP566Gea/7WMavS8t4DNRNTsjMmIYGfXjODf1WXy+oPDOWqAgqbVHEuLVXtHVDizuN1nT+0t9JDt+0AmhmTh77GmVcDj1LhgR3XyEnhlbEYGYWH5UlANUi2cqc5jnT6SKBH1Mbupp2gCafco+3gDaDhveWqb6EjVvBHRaVpv5XTl3y8hdFcWAUzxvYkp57bOlg0R0ir+0r07b16+EgwAoeAY4pC0wYR0eerroAa0/tduJFTEhFj85
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add two files under /sys/kernel/debug/crash_memaction/. "regions" lists
the physical ranges the bits describe and their offset and length in the
bitmap. "bitmap" shows the raw bits as a single blob with all ranges
concatenated. The files are root only and behind
CONFIG_CRASH_MEMACTION_DEBUGFS.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
Assisted-by: Claude Opus 5 <noreply@anthropic.com>
---
 Documentation/mm/crash_memaction.rst |  9 ++++++
 kernel/Kconfig.kexec                 | 14 +++++++++
 kernel/crash_core.c                  | 59 ++++++++++++++++++++++++++++++++++++
 3 files changed, 82 insertions(+)

diff --git a/Documentation/mm/crash_memaction.rst b/Documentation/mm/crash_memaction.rst
index 3658bff7693c..eacda046477e 100644
--- a/Documentation/mm/crash_memaction.rst
+++ b/Documentation/mm/crash_memaction.rst
@@ -57,3 +57,12 @@ Limitations
   trying to mark smaller objects, use lib/secret_pool or a similar mechanism.
 * Memory hotplug is not supported at this time. When memory is hotplugged, the
   newly hotplugged memory will not be included in the bitmap.
+
+Inspecting the bitmap
+=====================
+
+With ``CONFIG_CRASH_MEMACTION_DEBUGFS`` the bitmap can be read through debugfs::
+
+	# types 0x3000 page_shift 12 nr_regions 1
+	# start_pfn nr_pages offset bytes paddr
+	0x0000000000000001 0x0000000000800000 0x0 0x100000 0x0000000040000000
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 3cdc8d459ac0..b5380e16bfaf 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -204,4 +204,18 @@ config CRASH_MEMACTION
 
 	  If unsure, say N.
 
+config CRASH_MEMACTION_DEBUGFS
+	bool "Expose the crash memaction bitmap in debugfs"
+	depends on CRASH_MEMACTION && DEBUG_FS
+	help
+	  Allow reading the live crash_memaction bitmap through
+      /sys/kernel/debug/crash_memaction/. The bitmap is used when
+      CRASH_MEMACTION is set and when a crash_memaction cmdline param is present
+      to tell an eventual kdump kernel about the use of certain memory pages.
+
+      Note that this is a debug interface only that gives no guarantees
+      whatsoever on memory consistency.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 6bb2f5645ca6..5eb5a5ada8e0 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -28,9 +28,11 @@
 #include <linux/atomic.h>
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
+#include <linux/debugfs.h>
 #include <linux/jump_label.h>
 #include <linux/overflow.h>
 #include <linux/pfn.h>
+#include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/sysfs.h>
@@ -66,6 +68,10 @@ static struct crash_memaction_region *crash_memaction_regions __ro_after_init;
 static unsigned int crash_memaction_nr_regions __ro_after_init;
 static size_t crash_memaction_note_bytes __ro_after_init;
 
+/* The one allocation all of the bitmaps above were carved out of. */
+static void *crash_ma_bitmap_base __ro_after_init;
+static size_t crash_ma_bitmap_size __ro_after_init;
+
 static struct crash_memaction_note *crash_memaction_desc __ro_after_init;
 static size_t crash_memaction_desc_bytes __ro_after_init;
 
@@ -148,6 +154,8 @@ void __init crash_memaction_init(void)
 	if (!bits)
 		goto nomem;
 
+	crash_ma_bitmap_base = bits;
+	crash_ma_bitmap_size = total_bytes;
 	for (i = 0; i < nr; i++) {
 		regions[i].bits = bits;
 		bits += bitmap_size(regions[i].nr_pages);
@@ -341,6 +349,57 @@ void crash_memaction_unmark(void *addr, size_t size)
 }
 EXPORT_SYMBOL_GPL(crash_memaction_unmark);
 
+#ifdef CONFIG_CRASH_MEMACTION_DEBUGFS
+
+static struct debugfs_blob_wrapper crash_ma_bitmap_blob;
+
+/* @paddr is what the note gives, so a vmcore can be matched to a live one. */
+static int crash_memaction_regions_show(struct seq_file *m, void *v)
+{
+	unsigned long offset = 0;
+	unsigned int i;
+
+	seq_printf(m, "# types 0x%x page_shift %u nr_regions %u\n",
+		   crash_memaction_type_mask, PAGE_SHIFT,
+		   crash_memaction_nr_regions);
+	seq_puts(m, "# start_pfn nr_pages offset bytes paddr\n");
+
+	for (i = 0; i < crash_memaction_nr_regions; i++) {
+		struct crash_memaction_region *reg = &crash_memaction_regions[i];
+		size_t bytes = bitmap_size(reg->nr_pages);
+		phys_addr_t paddr = __pa(reg->bits);
+
+		seq_printf(m, "0x%016lx 0x%016lx 0x%016lx 0x%016zx %pa\n",
+			   reg->start_pfn, reg->nr_pages, offset, bytes, &paddr);
+		offset += bytes;
+	}
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(crash_memaction_regions);
+
+static int __init crash_memaction_debugfs_init(void)
+{
+	struct dentry *dir;
+
+	if (!crash_memaction_nr_regions)
+		return 0;
+
+	dir = debugfs_create_dir("crash_memaction", NULL);
+
+	debugfs_create_file("regions", 0400, dir, NULL,
+			    &crash_memaction_regions_fops);
+
+	crash_ma_bitmap_blob.data = crash_ma_bitmap_base;
+	crash_ma_bitmap_blob.size = crash_ma_bitmap_size;
+	debugfs_create_blob("bitmap", 0400, dir, &crash_ma_bitmap_blob);
+
+	return 0;
+}
+fs_initcall(crash_memaction_debugfs_init);
+
+#endif /* CONFIG_CRASH_MEMACTION_DEBUGFS */
+
 int crash_load_memaction(struct kimage *image)
 {
 	unsigned long nr_pages, i;

-- 
2.55.0


