Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3503CA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C19BE6B0088; Tue,  6 Oct 2026 02:41:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1426B008C; Tue,  6 Oct 2026 02:41:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABADD6B0092; Tue,  6 Oct 2026 02:41:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83A006B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:41:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECF53805B0
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:41:27 +0000 (UTC)
X-FDA: 85291255014.06.56924BA
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3BB5080005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:41:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WapF+qD2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791268886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uvuUL0ruNpfCRzWzTraH9ZiEVbkwKooQDWiuyseC2V4=;
	b=sis+4sUzRQ4iAoEh9PSgkiPTZZ/HAPV6QN27WReOzUe4+dR89yaVB9jISRkQeHhSjlffFs
	tGRM4yBx7EfPmj2MGyrjj8lBKPNbNASWWvpN6vtwgo37A9MnUgao1R7bZ94ZQCYM7y2zRx
	W0HOlA38976S37/5ASrtK+0ngFxc3zU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WapF+qD2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791268886;
	b=jOfjC0PHpwaA6NHgc3p65g2AwSj6+3sqgIYOeON6EzLZ06475MIwB3ah/z/hH6Bxo2T48z
	nRuRRzYcjoKZGjWyrAOumMBydyglXmCeBJsW00bmwNIrDACofyVc7bzQdmWb06wHO2ImGV
	iwxIBvl3YjNhhtxeCjz7Ax1HMfoinQg=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48bbb06e746so1212944f8f.3
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 23:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791268885; x=1791873685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uvuUL0ruNpfCRzWzTraH9ZiEVbkwKooQDWiuyseC2V4=;
        b=WapF+qD2Ejk41W+6eHrZC/AzcHzSGoFWVqwGIU3gOz5494JrnYcipnDKR38gq3cYcf
         FuvhMr8lR+DXqVFCbGDKY2x06L+JhbupUoKXOqgZoUXFD3D7vJnDKDwS4scoGFAaNsxG
         n7x6VHuE4GTbHgOF34u13XoAuN9/rFUuQoFMn8pWHFz6NE2mgVtpMD3fOBp0DHy/001A
         jjfljdpTaHdg5/uMpZIMjU3YjZ4ZLYB5Fmhg0BY9Doc+VzFshX/jZZO3v2ezUD9tpJgu
         MpJFufKuwbPsPeJocOvC71VmsejvfT+ICmKHEpAFh93gJJryrPPeWNiZn+dGR4yU2SDq
         Vqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791268885; x=1791873685;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uvuUL0ruNpfCRzWzTraH9ZiEVbkwKooQDWiuyseC2V4=;
        b=Abn9PxhUGi5dnhHLEBjzKE+jtMVLR6fMNed2O0huwtyyPAQK1UodUl4kCKX0zLU7gL
         Lf3h/GlNBLoWeS8ZzGlmNwz8uH3hnavbXGZ0xvmOqfsS+pi5mJaZISR0pxGZ46NCh6Ri
         sTz/cUy63TxQTuxvchLz//mGmFHnaHGcLzJb25SAlSherVyJ+RzMrMzCAV7JALCE7iUX
         jKp0t6XEDWSzGsPUYFZgYB5IASMEY1oQ8Vs01MJAoboq4SeDuTiVsG6c5eTK29hc9xwF
         Mnrk4rYIsj7jQ4CFk502ZsCJIv4W+VgdSV/pyFbTfRzn4G3qEQvEexJMCUjJiILQMyGo
         N+Kw==
X-Forwarded-Encrypted: i=1; AKwUvBw5WUo3OtmgSmzLve5pBBOc7HUAIjTmqyL5Za+tXUUKqFGfFa6KxjXBZ1wkYmYWI4UmUyctNDsxUQ==@kvack.org
X-Gm-Message-State: AFq9FYJ5p6KnFJYQsL9BwjiQFPdsonZ+5GYCpvkup+4mTHcuf6UNhhWx
	1dsmlpg0va6LY1TrCamkZ8ytumRAHPQ+A5Yn0YGJAa/0vH2oxVO3jHW3
X-Gm-Gg: AYBFou1kGj+dB6Y5WxZnSDqsF9lH4Mhbk1vqpfAd/Qm8OPS6PDpwmkTlSc1+aepDEOG
	tP8SA+gmi6PBBNr3dsIl0+cYAG14Li/4cdHqHaXL3OA6pWcxWp+HQyUeiBShb2chjMEi2P8aqNY
	zx9djfwyIr9qI1Upeq8eFJysyVIKEHc+Df1baVaAkcAfUo4AEHMeVUIq9b7Sm+ewA1+55cRZj0z
	chkFPnQosVAvAx3M0FZdVnn3oyqEW3zNdRfur/fQZNPlz9z/rxkp668UUUMKQ0LhUlphkTzhkF4
	5qfoE6q1OTcMIK/Q5TUa0OxHcPm//7dr08JTFwKSSgjwsxlyyRbFBKdDf4JXq/JiYdAErsuQa20
	qaK0Wubb+QgdEiVfjdAijpc+gh+/vV7oS39mIOqvjTCeVOOPApox/o0nIAqB1xKaGWsyNMu482n
	XRCT7lBGlkJwQ7l+rjgnR3YTFvCg8x+1QRCK3fhzihC8fv9mRqbmo0yh0=
X-Received: by 2002:a05:6000:4911:b0:48c:4272:86b2 with SMTP id ffacd0b85a97d-48c47fc924emr14855342f8f.11.1791268884519;
        Mon, 05 Oct 2026 23:41:24 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c6726238fsm4847856f8f.16.2026.10.05.23.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 23:41:23 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] selftests/mm: check MREMAP_DONTUNMAP mlock accounting
Date: Tue,  6 Oct 2026 08:39:01 +0200
Message-ID: <20261006064120.6796-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3BB5080005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: drkwpcp3yrfp5nijeqx99swdhhk15t5c
X-HE-Tag: 1791268886-723454
X-HE-Meta: U2FsdGVkX198HZ7i9TDuUJTYWi7ckyepmAB6hZnETd98Lw/yPYoYJ6ILh4bLGz7gvr9UzKeF/iS0/QZNKk8BnyGFGjlmU2YPNN/seNIbDKlPQH/5Rb3V0Y05WMO5tQIxwZ+CUA5eKShl2Kwbv4s4tL0IkXzI7LO+fBFWx2PPnK4rJgkqkbS3qxJGWqSChtKAtJAz2wR2dr2CKWi/sfY3FaqvORCSDxoF2URv2tpXfCWhPlrq6bgO+V/bRHrowPfYcrrF+fSJ74i0ab/VAcdCEiMHKBUgwQaKadJOO0k1wnvmjjW0hG19Gl6nVYE1hQfED9YBbPLot7h+Y3nJ9zUSuiiem89A1975sTR1+QbZrVUWxod09/ov+ackSIvcGzKmzgD02TcwGPWjIE2SuT8Y0L8GhnuQ5Qf5E/ciQext7V4lGGtLlLv/sAOjbfhLgJ8szh4QwchVRiuGzNMGfpnhL8vXYa4hUI0NvGwDtBro7r4BKALX0AW8zuz6+h39Kgw2DUSTWH8V69TzYxR1gQBIrGeFjWP9UyHaZcm9ohPulwIHcLYIMpnwTXKvsvgg+x06TT7FML8kZBBT9vufsx4AAjskI7GdwBp0ht/3p6F9wymF0cVc0OxG2VWITrQmU/Ckzx4aAQbCh8pNHo0uEqYYSET5sEGDlFJYMSz9H4VBKKNaSUnoxCZgOlaALFyBDy9au2o0BTiU8Pu54T/AAaMHzLeV3HxDTI7w1eCvrok9tMNLSNElnnnGMu0ZrCr/E66xELTrmEyaxkX3KPSEi0rVmXMuXkxtSAV+r/RIxaTF+NzQvJgmgACJ/viST2a6UuJCReUZLcXDD9aN1eVTY+DZGtIk6k6dkAbpJEEsm0yCrG/sx6gC4czxbW/fCBZmpj9+RjtTy9RkyQMNX3ojc3E52r8qzadYeut1WEDFimaNNnC2uCrST+rsluNOF4aA+a3EXH7Wvp65mbAvn6z4RBN
 WCPP4ETu
 ukXMbbRTznp21VKRvGwuvM+S//dR++Pn+e3qVmYzZPW2FRO/1n5XCDQIhN52McBqI0+6Onev7i59333Ql1qzQTRN7KQwhp0C0AbHgoXdGYtDp0ndblFLPPlKc5EuvZDPHKu5Q5uOpyQfLTCA7ltp4sLVA/N5Sx0Q8A06MJpDQgRzwI4CfOSwh7iU4uZLKpXdId68g4r15F2BrnWfCXgFM6YQ2xogfWgfMupuddDiFB5LN4PS2ZiZzr5Q+J1JeYkxy2ltYqGOnKKGT5CzfaKVRwOXrZzr8IMfNpIqhD9nrmX2aY1BPTthKCVUY4Rrd9EGger3h0Adw9Trpv/RRO2MJmlrwoEe6bjGV5uHH5KWauNdBd40KVa6c07Gwn3UdIeBJVIxSymAwvf1dzJp6VFh6ZauG3ibeFN5yHLj+rPmDd/8eVWB0SqbaK7+3Gk8EF1TDzKPd3G/wh/cuIyZ94xol8KvkVW7sGuJ3yKzeoENsKWG9dtI8ipH+SVtaBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MREMAP_DONTUNMAP keeps the source VMA in place, but clears its mlock flags
while setting them on the destination VMA.  The "mm/mremap: fix two issues
with MREMAP_DONTUNMAP" series fixed two cases where this leaked
mm->locked_vm:

 - an unfaulted mlock-on-fault VMA moved behind itself self-merges, so the
   single resulting VMA loses the flags without the accounting being
   dropped;

 - a partial mremap() moves only part of the range, leaving the pages which
   are not moved accounted as locked in a VMA whose flags were cleared.

Add a test which mlock2()s a source mapping, moves all or part of it with
MREMAP_DONTUNMAP, unmaps everything and checks that VmLck is back to its
value from before, and run it for the self-merge case and for a partial
move with and without MLOCK_ONFAULT.

Verified on x86_64: the three cases fail on mm-unstable with the two fixes
reverted and pass with them applied.

Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
v2:
 - Reduce the churn (David): fold the three cases into one parameterised
   test and drop the child process per case, comparing VmLck against its
   value before each case instead.
 - Use the file's BUG_ON() for setup failures and vm_util's
   check_for_pattern() to read VmLck, call mlock2() directly.
 - Verify against mm-unstable with the two fixes reverted rather than an
   older -rc, now that the series is applied.

 tools/testing/selftests/mm/mremap_dontunmap.c | 63 ++++++++++++++++++-
 1 file changed, 62 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_dontunmap.c b/tools/testing/selftests/mm/mremap_dontunmap.c
index 96ba537facf7..5ca33d9d42af 100644
--- a/tools/testing/selftests/mm/mremap_dontunmap.c
+++ b/tools/testing/selftests/mm/mremap_dontunmap.c
@@ -7,6 +7,7 @@
  */
 #define _GNU_SOURCE
 #include <sys/mman.h>
+#include <sys/syscall.h>
 #include <linux/mman.h>
 #include <errno.h>
 #include <stdio.h>
@@ -15,6 +16,7 @@
 #include <unistd.h>

 #include "kselftest.h"
+#include "vm_util.h"

 unsigned long page_size;
 char *page_buffer;
@@ -335,6 +337,62 @@ static void mremap_dontunmap_partial_mapping_overwrite(void)
 	ksft_test_result_pass("%s\n", __func__);
 }

+/* VmLck from /proc/self/status, which is mm->locked_vm in kB. */
+static unsigned long locked_vm_kb(void)
+{
+	unsigned long kb;
+	char buf[256];
+	FILE *fp;
+
+	fp = fopen("/proc/self/status", "r");
+	BUG_ON(!fp, "unable to open /proc/self/status");
+	BUG_ON(!check_for_pattern(fp, "VmLck:", buf, sizeof(buf)) ||
+	       sscanf(buf, "VmLck: %lu kB", &kb) != 1, "unable to read VmLck");
+	fclose(fp);
+
+	return kb;
+}
+
+/*
+ * MREMAP_DONTUNMAP clears the mlock flags of the source VMA and sets them on
+ * the destination, and mm->locked_vm has to follow.  mlock2() a source of
+ * num_pages and move its first move_pages to gap pages past its end:
+ *
+ *  |------ source ------|... gap ...|-- dest --|
+ *
+ * then unmap everything and check that VmLck is back where it started.  With
+ * no gap the destination is adjacent to the source and could merge with it,
+ * otherwise the gap is left PROT_NONE so that it cannot.
+ */
+static void mremap_dontunmap_mlock(const char *desc, unsigned long num_pages,
+				   unsigned long move_pages, unsigned long gap,
+				   int mlock_flags)
+{
+	unsigned long size = (num_pages + gap + move_pages) * page_size;
+	unsigned long locked = locked_vm_kb();
+	void *source, *dest;
+
+	source = mmap(NULL, size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	BUG_ON(source == MAP_FAILED, "mmap");
+	BUG_ON(mprotect(source, num_pages * page_size,
+			PROT_READ | PROT_WRITE) == -1, "mprotect");
+	dest = source + (num_pages + gap) * page_size;
+
+	if (syscall(__NR_mlock2, source, num_pages * page_size, mlock_flags)) {
+		ksft_test_result_skip("%s: %s: mlock2: %s\n", __func__, desc,
+				      strerror(errno));
+		BUG_ON(munmap(source, size) == -1, "unable to unmap mappings");
+		return;
+	}
+
+	BUG_ON(mremap(source, move_pages * page_size, move_pages * page_size,
+		      MREMAP_DONTUNMAP | MREMAP_MAYMOVE | MREMAP_FIXED,
+		      dest) != dest, "mremap");
+
+	BUG_ON(munmap(source, size) == -1, "unable to unmap mappings");
+	ksft_test_result(locked_vm_kb() == locked, "%s: %s\n", __func__, desc);
+}
+
 int main(void)
 {
 	ksft_print_header();
@@ -348,7 +406,7 @@ int main(void)
 		ksft_finished();
 	}

-	ksft_set_plan(5);
+	ksft_set_plan(8);

 	// Keep a page sized buffer around for when we need it.
 	page_buffer =
@@ -361,6 +419,9 @@ int main(void)
 	mremap_dontunmap_simple_fixed();
 	mremap_dontunmap_partial_mapping();
 	mremap_dontunmap_partial_mapping_overwrite();
+	mremap_dontunmap_mlock("onfault self-merge", 1, 1, 0, MLOCK_ONFAULT);
+	mremap_dontunmap_mlock("partial", 3, 2, 1, 0);
+	mremap_dontunmap_mlock("onfault partial", 3, 2, 1, MLOCK_ONFAULT);

 	BUG_ON(munmap(page_buffer, page_size) == -1,
 	       "unable to unmap page buffer");
--
2.55.0


