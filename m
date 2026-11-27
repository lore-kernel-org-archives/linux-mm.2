Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75157606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Q4rI4c0n
Received: by kanga.kvack.org (Postfix)
	id 5AF706B05CA; Fri, 27 Nov 2026 15:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F1C6B05CB; Fri, 27 Nov 2026 15:14:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400796B05CC; Fri, 27 Nov 2026 15:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08F136B05CA
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:14:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F0131404B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:14:35 +0000 (UTC)
X-FDA: 85482001710.20.2BCEE1C
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9227B14000E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:14:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Q4rI4c0n;
	spf=pass (imf26.hostedemail.com: domain of takano32@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=takano32@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810473;
	b=5P91A1hjJnupEluYvRB2OGTc/cl9jZPXFQ/qA2nBjoxIXqRf6az4YaFTXKPZPBIQKaRu25
	ScZQa08qYCpjks1RUscP8g6O/UAPfnkaaDuYNJd+iHu/F0gcvoUE7z8c2TxhqL2AmnDd3w
	Vwc2YtSkEgxzeySyUuLRV7mgf1hau/g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2tL8owTw2PwzoEHxqPksYuP4hbl3MRd9EfCtfzCRkZU=;
	b=ouP5rYr7uOjSofJvtz60oo6KbHIECwmkaHQkg1j+o1niIQOK9B57UfISoKO+oGsCieTWk7
	q65np+/QkYdKlNz05DSd++BeXZ0uPMkWxik1Z0GzYe1qaDPALSUT1HiNX0aR4U1ZAmPEy5
	ErWvxQbQXulc6NcbWxbrLqXnwzUwe2k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Q4rI4c0n;
	spf=pass (imf26.hostedemail.com: domain of takano32@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=takano32@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-386c336eab8so4921850eec.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:14:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795810472; x=1796415272; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2tL8owTw2PwzoEHxqPksYuP4hbl3MRd9EfCtfzCRkZU=;
        b=Q4rI4c0n5WEIiLYMsmDjgrhYI90BOlqH3l9e8aLDLHcuc/GmUPVIT2/JEa70rQzfyv
         f/Oji4+PqT6v2xTLJNQyPa0SkjyLh7XPq3qVdLc2w/2bsBqHirlP1sj/3CKfTfQAmuoM
         JOI+sAnOLHOTpCeI21Q7R1ZwcJToXYYhmjulddEyG4oxCjDR3yBkos3KLVAcSGrkJgeb
         IhUjWkUcXtNejYjAWVlm4BspYd8h9ZakpYysj9SduuDE7RyJobthzEErd5FwyzYtxEmF
         4VBY+J4XLlIwo02En7IEU5EvkR0yFuj7Hh+2t6o5fQe+DCgOx56zn5zzRjDQ5t1pbDuG
         rajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795810472; x=1796415272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2tL8owTw2PwzoEHxqPksYuP4hbl3MRd9EfCtfzCRkZU=;
        b=FfRuRW66ruD0BJ/VZl+c8u3n1BgVbvZuGNYlRIABi56negYEhVVPmRNetgexHSvCTH
         ydq1iTt5scCd4DURZdSW4XOpYFbuafED6/SZNABAlgNpKiPV23Bi/TXhy7K86Cjj886B
         UpdPKhzXhEeui0O7/g/aC0oHzriD7OsJe+NOL67NWEkYlFpl2Z0W3mHzeMQ5iJ8XRT2u
         TkeyNlc+Uq/fg29UWq+2A2mGy+vaGt7rd6v+OHw9I7ac1ysk32G5WtcUziRfsYFkU3cL
         qA7VLZ5dfhSpsXRVoLSB3xNXpchEAXjanQVqX6L9eoCyJR0QSny0M6leBUX4E1zqfBa3
         V6EQ==
X-Forwarded-Encrypted: i=1; AL+hErHop7vLbrKlypuQE0bX2KpYwr+y9xWGaiSsvjkP5VvbOd+EMoPjcUW7W4io3B0fUUuE+b3DLrvAFA==@kvack.org
X-Gm-Message-State: APuU4Z/QPzBaxoX64MnPB/cFizyPgNVoQ3qLSbWWaXHU1NGmVb+DRhsO
	vvZ9MVi4HPUsOZnIsY2J1E8jraR1ybgalps0ex+jT2mIn87MrN/xZ3wy
X-Gm-Gg: AZFdTZci6TczGLiboy4olYhZBK7x6cfVVc+s6MhHCBdstjpGRyYB0V0aF+Jw8U/cTA/
	1YN/9aKlmZi+6noW0PMMNSRvuSYQyYXPvdOCt3+UVvbQ/UUeaPk+zy4HpyzXBuV9n+yj/cC0ThM
	JcRX2LiTW/DwYOrA8ukQ791e7T2tiTs/IkJ3jx3GtwAI2HkMZv9JZasmkZK32WcB/G57w55aFYM
	hYVDk0+2b9mlMQn0f+3Yc/GhKyCoOEYeZ0o8Q+k98pRmhvexkWepQkFrohDIEDW+luhNuip1w2J
	B8T+nHDpbm0n6Ff8or5mIHW89myppUbCcev9P1e0ZIOxGodMUHngnwPONIZ80zLkD1VEyT0jw29
	jBtDpiQRKYdFyS6AT74zoB9PP/xmE2YhWP3OC4L0PctbPEhT9XbiBwg31AHEwtE72A10hw7qyB5
	B0Z8NMzT6PNMiPMPtcCy/TtizI+12n/yWicaAgk4YzuxWT3R22JVuT5myW+L4NWdzWOJHWe5Lf2
	TAHMuKQmc8w8a59t9At7lpzbOudDS35VC3nfkrpPk4psT8uPggENjoh6yEwBYb3OmQ0ms8kv+3R
	JnIdiO/zArqCXCLAAL4/fsQSxp7AaRdLo0JMWf77IA==
X-Received: by 2002:a05:7301:d804:b0:386:b076:a940 with SMTP id 5a478bee46e88-386b076a9e4mr16325542eec.26.1795810472092;
        Fri, 27 Nov 2026 12:14:32 -0800 (PST)
Received: from a1-free ([2603:c021:8021:f000:0:1865:8c38:18fc])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385f68bc0adsm70396821eec.13.2026.11.27.12.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 12:14:31 -0800 (PST)
From: TAKANO Mitsuhiro <takano32@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	TAKANO Mitsuhiro <takano32@gmail.com>
Subject: [PATCH v3] docs: Name the memory hotplug online type configs that exist
Date: Fri, 27 Nov 2026 20:14:28 +0000
Message-ID: <20261127201428.293257-1-takano32@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127190207.245175-1-takano32@gmail.com>
References: <20261127190207.245175-1-takano32@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9227B14000E
X-Stat-Signature: poc8npmjg4h71qbgzt3scymognwif4fa
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795810473-712808
X-HE-Meta: U2FsdGVkX1/ObSeD8p9RY2lthm5dVJOdzXuZEAk3BTkjuug+SIeS/81GQfnTJgtGT9y1JAxZ6S1kLpJeT5+UHpm5k+DS/j1gJB6crgFjzxUM9AshU4wVgXby3oebIGaDn2ACoxSTT0/VRJB9IoYxQztjQriMECD3MBx17SwaZu3FpBmUL1Dj3JjJ0A1guYb/u0ZGa1/cNsKqKYPZho5Xz76f4oG+sJv0eRCGsEAavsCzKQgbBTZhSf+PhjO7eXB1qlp3C4vYIidBqeZkKaaCDZjsRJjfMOwWm5Sz1GCUiyeQbTQQBTjiJ7UWtYInalXSuYzVs73bgAnOc+i9Su/m4oHA1nlzkQ1CwTs4Rg0PKiuLylaWLQebgE1yWILpeqxmh14ASzoKWK484VwBb0/LNzx+JGCjkV0dn6RTxlUaqfqX00YcqjEHUAvNEc+E9gmuOrSGjf1rMc1R/p9cd3Iu+plLjfjkWIU2pSEBoNGBlMLTwZQi7uP2FbK9AoqkvKF7h4JrAbMlt+XbA4+6+sZYBwykEUnV967EeQr0d0zumSXT7YyOYSRrikOqE+C8qK7E11STf8nUuXpL5vIASLLd0STiKwz2qk+izDw2dElldCOoiD8TNS0ANKkNw2AjRm1Akv+JUDnMz0S2anX2h5mLHtcUUGYwsmdAJG5oKD8233pjE50cIF5Bmz8t+LJ0hIrKRwmA7glVk2MSUrDQFIqDkz3B/sDaeqfJw93AC5s40FfT2pkk9l7qKq7B7Ctfpb0yK4aWe8jRSO7d5DuYP6oUaFfmp5oqYXrKpaPwrT+PCbXqwt7tZfLqXqWA4U2lUAk090jooTSEZ5k6BqKvTKSqLirOpbyQ3bUIQskznaJEoMJaC3LuK4DO9rLAEqiq7SFupwLAyWMjql+tW6SqgPYBKt+9Vhr8UxtAmN76BEx8f8k75MeGZhq/6Dp4jihXhsn+8hLVc8/L4DnP7JSDFhC
 IhcYrZv/
 Ej3V6Kk7hMFWAnP0GGzD3OSVcmgIvRr3EsIIkAcedQhaoyKfdAQuDjN144P63VhxbqkJZeSabT/tjtbCmCa5svGXcEmTR347mPpi+2j28ez1kkUvnBYm7iEiPz+SQze8fx8iz3bNjAbZX9vSXKZikaxk3WtfPZdOAUb7lKWLKGAt00CXDLcWwfe9B5qEJm8zXGAeXHFXqz2a/LncAfA8rKiom++zPukBocxQobFBiFIAxQf0CTtZ0nE9NiNmuHYuhEJyKOWcInjy/0a1rTzH4MAp+7lnA4ZBK/eZ+Ugpl8xsSW13JUcrMuF5CWOpoLJtFe5P1IQ2Su/2HALrybGlmbNUbWOHkIeNnpXfgT8dmO4i7j9+zqg5uha+1HfWWvnCRrxUW/LFSFRM6SWt4khOxVyT3DyLJ2vYUzGRqkKhO/9d66ZxDYwMicKynFXYskbMbDG90Hma4RDWpFQfT0Ze095CvSlcoSarA7JUkH30CvoPZ/0s7ItGL9MnQToZsKmPqNx3ZdvLUCpA4uDoDPEh3ybjeEUzr3fH5wn0sIExJulegMha8hTCyRHCoZ3nGmbx87cIBdAvxxYWWh9XmsW4ZZs373syDULg3QsfgbXlgUENlxTbWD7OaWTVNiO2zO1LdWIwy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The default online type is a Kconfig choice, so the symbols it defines are
CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE, _ONLINE_AUTO, _ONLINE_KERNEL and
_ONLINE_MOVABLE.  There is no CONFIG_MHP_DEFAULT_ONLINE_TYPE symbol, but
five files name one.

Where a file lists the config, name the family with a trailing _*.  Where
it names a choice value, spell the whole symbol out: early-boot.rst gave
the zone choices as _NORMAL and _MOVABLE, which are not suffixes, and it
left _ONLINE_AUTO out of the list of values.

Verification: a build of the tree defines
CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE and no bare
CONFIG_MHP_DEFAULT_ONLINE_TYPE in include/generated/autoconf.h, and grep
finds no reference to the bare symbol under Documentation/ afterwards.

Signed-off-by: TAKANO Mitsuhiro <takano32@gmail.com>
---
v3: Add CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_AUTO, which v2 dropped when it
    spelled the values out, and write the kernel zone as "a zone that can
    hold kernel data (usually ZONE_NORMAL)" since the choice can land in
    ZONE_DMA or ZONE_DMA32.

v2: Spell the full config names in early-boot.rst.  David Hildenbrand pointed
    out that CONFIG_MHP_DEFAULT_ONLINE_TYPE_* with _ONLINE_KERNEL appended
    does not parse.  The other four files keep the _* form because they list
    the config, not one of its values.

    Written with Hermes Agent, an LLM assistant; the author reviewed the
    wording and the diff.

 Documentation/admin-guide/kernel-parameters.txt   |  2 +-
 Documentation/admin-guide/mm/memory-hotplug.rst   |  2 +-
 Documentation/driver-api/cxl/linux/early-boot.rst | 15 ++++++++++-----
 .../driver-api/cxl/linux/memory-hotplug.rst       |  2 +-
 Documentation/driver-api/cxl/linux/overview.rst   |  2 +-
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 176648941aec..8580099b98c1 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -3948,7 +3948,7 @@ Kernel parameters
 			[KNL] Set the initial state for the memory hotplug
 			onlining policy. If not specified, the default value is
 			set according to the
-			CONFIG_MHP_DEFAULT_ONLINE_TYPE kernel config
+			CONFIG_MHP_DEFAULT_ONLINE_TYPE_* kernel config
 			options.
 			See Documentation/admin-guide/mm/memory-hotplug.rst.
 
diff --git a/Documentation/admin-guide/mm/memory-hotplug.rst b/Documentation/admin-guide/mm/memory-hotplug.rst
index 0207f8725142..c7de458a962f 100644
--- a/Documentation/admin-guide/mm/memory-hotplug.rst
+++ b/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -280,7 +280,7 @@ The following files are currently defined:
 		       blocks; configure auto-onlining.
 
 		       The default value depends on the
-		       CONFIG_MHP_DEFAULT_ONLINE_TYPE kernel configuration
+		       CONFIG_MHP_DEFAULT_ONLINE_TYPE_* kernel configuration
 		       options.
 
 		       See the ``state`` property of memory blocks for details.
diff --git a/Documentation/driver-api/cxl/linux/early-boot.rst b/Documentation/driver-api/cxl/linux/early-boot.rst
index 414481f33819..7118f3372596 100644
--- a/Documentation/driver-api/cxl/linux/early-boot.rst
+++ b/Documentation/driver-api/cxl/linux/early-boot.rst
@@ -34,7 +34,7 @@ which dictate how memory will be managed by Linux during early boot.
   * Linux Build config option that dictates whether the kernel supports
     Specific Purpose memory.
 
-* CONFIG_MHP_DEFAULT_ONLINE_TYPE
+* CONFIG_MHP_DEFAULT_ONLINE_TYPE_*
 
   * Linux Build config that dictates whether and how Specific Purpose memory
     converted to a dax device should be managed (left as DAX or onlined as
@@ -58,10 +58,15 @@ SystemRAM.  This will expose the memory to the kernel page allocator in
 :code:`ZONE_NORMAL`, making it available for use for most allocations (including
 :code:`struct page` and page tables).
 
-If `Specific Purpose` is set and supported, :code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_*`
-dictates whether the memory is onlined by default (:code:`_OFFLINE` or
-:code:`_ONLINE_*`), and if online which zone to online this memory to by default
-(:code:`_NORMAL` or :code:`_MOVABLE`).
+If `Specific Purpose` is set and supported, the default online type decides
+what happens to the memory:
+:code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_OFFLINE` leaves it offline,
+:code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_AUTO` onlines it to whichever zone
+the kernel picks,
+:code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_KERNEL` onlines it to a zone that
+can hold kernel data (usually :code:`ZONE_NORMAL`), and
+:code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE` onlines it to
+:code:`ZONE_MOVABLE`.
 
 If placed in :code:`ZONE_MOVABLE`, the memory will not be available for most
 kernel allocations (such as :code:`struct page` or page tables).  This may
diff --git a/Documentation/driver-api/cxl/linux/memory-hotplug.rst b/Documentation/driver-api/cxl/linux/memory-hotplug.rst
index af368c2bc9cf..df27520b193f 100644
--- a/Documentation/driver-api/cxl/linux/memory-hotplug.rst
+++ b/Documentation/driver-api/cxl/linux/memory-hotplug.rst
@@ -19,7 +19,7 @@ Default Online Behavior
 The default-online behavior of hotplug memory is dictated by the following,
 in order of precedence:
 
-- :code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE` Build Configuration
+- :code:`CONFIG_MHP_DEFAULT_ONLINE_TYPE_*` Build Configuration
 - :code:`memhp_default_state` Boot parameter
 - :code:`/sys/devices/system/memory/auto_online_blocks` value
 
diff --git a/Documentation/driver-api/cxl/linux/overview.rst b/Documentation/driver-api/cxl/linux/overview.rst
index 648beb2c8c83..d567353e1dab 100644
--- a/Documentation/driver-api/cxl/linux/overview.rst
+++ b/Documentation/driver-api/cxl/linux/overview.rst
@@ -17,7 +17,7 @@ are generated.
 
     i) EFI_MEMORY_SP
     ii) CONFIG_EFI_SOFT_RESERVE
-    iii) CONFIG_MHP_DEFAULT_ONLINE_TYPE
+    iii) CONFIG_MHP_DEFAULT_ONLINE_TYPE_*
     iv) nosoftreserve
 
   b) Memory Map Creation

base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
2.53.0


