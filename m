Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC29C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DF718E0008; Wed,  6 Aug 2025 11:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F848E0003; Wed,  6 Aug 2025 11:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A61F8E0008; Wed,  6 Aug 2025 11:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38EE98E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:59:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 045351365A5
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:59:12 +0000 (UTC)
X-FDA: 83746791786.30.4511C1B
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5B40E40005
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:59:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zg2CwYrt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3znuTaAYKCF8PROBK8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--surenb.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3znuTaAYKCF8PROBK8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754495951; a=rsa-sha256;
	cv=none;
	b=XtWQI9zqbfBSm0Rm5HpPLXWmQkAelATaUiYqwIZiGljFOPW7QQsYo4fVPTs3Doo97vP1KY
	uodCB/YasPm39DZxyXy5wV34MHvMwB+nezXGwifoOEcq4F+3edl8jkAfH98C38IsIgH70j
	i4z9Ffzm4SN9wkEWK59jZdOzyDW+Wng=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zg2CwYrt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3znuTaAYKCF8PROBK8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--surenb.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3znuTaAYKCF8PROBK8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754495951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXYe+deuPHevDPYBINDTsn9wi9CS1Jzi+BLJQIES5w4=;
	b=i6Bo1VqahDnmu65BMBrHr5RgPwhIi2efUzbKQHGZuNaQBAg/osTIiBdhw0fZx+wBa4fkxV
	R/TfvHoTrtP09LmtX3Az4OdVxKnt+zhc60zLYB9Su319EUT/mfWQnPm/gsWlMoFXDMOArG
	m9RgSmyWTeH5KrTuWFundVg2aiWPUCA=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b42464016c3so4130108a12.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 08:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754495950; x=1755100750; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PXYe+deuPHevDPYBINDTsn9wi9CS1Jzi+BLJQIES5w4=;
        b=zg2CwYrt9cbMh0cr7WmQ+8unH2L8RYZBPTCDGrnkCUcWdw7M4w+OsWk//4ZjKFJJdT
         YFMeP+W9z6pndQulfplPnfjGXt7DZcREz2JTvdFDR7WYtU7Aq9+62IXrMG0Q8JR4+iV1
         B33uGZ/zqBlZcITW+boLbqDMhwutThPQwRc2qKooycAq8d4L28mTp1xo2eO+77V/8766
         terrZoCUTEB1pihBlRr8OV+f2ldVCkkkQtDcaywpj70UARnS8mQI3dPfJkkxW+2kilcO
         UfhsN833Dn7mHkSS6UHsLywY2kWI+3+wmaapYsdknL2ts92Egu9Z1xY1IFa19RUbXrBv
         sCLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754495950; x=1755100750;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PXYe+deuPHevDPYBINDTsn9wi9CS1Jzi+BLJQIES5w4=;
        b=hSRCSn/cp01HkDWPIoJOkRT6HSFf9jnxWUDVV+F1QQuDNGKylJdZv+4P/iWzpZ2K3x
         9pXZhS81noJMFrCi07xCekbA2saEA1im0zkaXzwGFKPvKN9F/FXetrgdrZn0tatnlW3I
         dONWQ7J2X2JPjCfjLAbzoOh7OFoCKWvCb91RfdiNHLd3pWdMsTAACR4hszKdXkT22A6r
         w98MdBF5w2gvoSBIe+tD2av/eNtCsSxJ620nvK9ciqOe6ZD3ohm0cXmPuJIigw8pTuBk
         gG31G3K97QU6fNJsqMyK7YF26kBr0RKGD3wNBN4AI03KwGWZsw9TawRSyX1VB73RMqgm
         i2Lg==
X-Forwarded-Encrypted: i=1; AJvYcCVLQpFG7nkF4aiTrGbpdktAkOXq552oZ/ne0icZRacB35QHEMhgxC8hJqO5p277onTKEoo0R4V1Jg==@kvack.org
X-Gm-Message-State: AOJu0Yz1/uIkNuj5NUCQx70BfxQBVY7GpKD6Ysbgpmaa7ha8R5z9FgxL
	t1aHib8Se/De95N7hdPXoH1sUbVN1+2++guy41Ss4ZEZGFCuuFUDjRX9KDzD+cqwcf8L3VFhbrz
	agXca8w==
X-Google-Smtp-Source: AGHT+IGgvg3dQvTXmdt74y/yValTWb4FYmuEsFGJGvZhCliPSz+PpQKAizJFqhgIhOOFcKnbAdsQp68ZE7E=
X-Received: from pjv4.prod.google.com ([2002:a17:90b:5644:b0:313:245:8921])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2688:b0:321:38e0:d591
 with SMTP id 98e67ed59e1d1-32166c97f61mr5487656a91.17.1754495950179; Wed, 06
 Aug 2025 08:59:10 -0700 (PDT)
Date: Wed,  6 Aug 2025 08:59:02 -0700
In-Reply-To: <20250806155905.824388-1-surenb@google.com>
Mime-Version: 1.0
References: <20250806155905.824388-1-surenb@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806155905.824388-2-surenb@google.com>
Subject: [PATCH v3 1/3] selftests/proc: test PROCMAP_QUERY ioctl while vma is
 concurrently modified
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, david@redhat.com, 
	vbabka@suse.cz, peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, 
	brauner@kernel.org, josef@toxicpanda.com, yebin10@huawei.com, 
	linux@weissschuh.net, willy@infradead.org, osalvador@suse.de, 
	andrii@kernel.org, ryan.roberts@arm.com, christophe.leroy@csgroup.eu, 
	tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, surenb@google.com, 
	SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: g39ttffnwgo79934h3ao834b4ah6a9ce
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B40E40005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754495951-570452
X-HE-Meta: U2FsdGVkX1+INb0Tc2pVW8R3xajhFXwc6QjTG34LMtD22n+L2wwEo7rT7y5l2QMOZK9JXvHcGTl3Yo0IzME4GwlC2Xgpn4Vjd37bOiCCPGBnKOZl/2Q7r/YODQlzt2CG/SfTx+mjqvrCL9ExTOwfvnuUeiurqwgGA8hjWZlzWAQFx/MdlCL81lj4YwfK7dh3fxiV6FZSuLccMcUjW+7PERlFO+QfvPOiBYOkE955ICvxSo0ypPOBekfo6g3eMLgnZpLH2wpjyp1n0pE6j5wmPdyJTUP49whH2+vMHHts1HuwahTGQK6YQFXsw5onObnNXfzGfdGWj5O2xcOO+Evzd1J3XJ0OzabsIMU7DMrTIC7/9z85p4jzA2LuYYSVUXb7kEd3KoC5umVYnqvtsCBCIu5OK3NpKNiWSymmVGyB+Vx44vkm1pgrZiqwmWF3/i/cdEB0N4W0gnBJvpZfrKI52z4Zl/AGzUG5NlNseDzYlgr7E4klhkJ6kVB98FjnwWKV4nCbe5qzp4EIkQmZzIedYCTuGxPN1i5ciKRxewnMG28o2OtL1kDMzyeIBJI5+NkZ294tvlAXRXo/czLF7NJ4AjMf03t2U/ieaBVsVg/iJkpjlpy9FfqHU8/e+DvRObFDBhthtMuW9zIdrKte+R8aMUsjgzphC3IzmNzhj9LLcffcGjeg38MrhUsFsoxDwbqt1YXsM4KNGtz2bOLPxYBdGFxYyMmErdWCfRA1oARADLX07C19CqsSypXDy+S1K4VKdBw1uwcTJLZPRhKZFK+vz7fkY/3WMJevlAotlnA3M2Q/oCMWeElWY63J5GFKHjpxfBYzPzMS234EySWvMAMWx7zel/8IzEyfnDOEBSapNzCX3z4FpsGxBjXpPlALI4vN73PvcbZFmmCUkf22jQiCphy1mR0DL3sOt5RDDMIUOqMbYXvNW6m72Hu94bDg4gbn7dS1bDqk0xiNFuxLmLT
 s7nPbw6h
 I4kuu1wAFlvt5ekxSzzFKFj95iN/qhhflEafHJ0sS/n3Y/cqb2mNon32fqfLhxwIXxyjHcnIQupZfmYA9BbCmmjjRacPT771niTZSXcdVlMGYjA8Sc8DCBD20WmC2RPeIAN0TJ+sXv8m36nTX9m+GTgQm5pJK2FPXylOmCj8idGuV+PCcLLyxYBiRVMMcrvY3S7y8mXMEnse22u959Z8aZv9zYY/EBLZcOeKGb6PylENNqPvuMeUh8p3wrrmyHuUB1UG0xSZ+lY+sMmaBZYrlotGejUy3CCAGQM4K0YC/wVhTVPM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend /proc/pid/maps tearing tests to verify PROCMAP_QUERY ioctl operation
correctness while the vma is being concurrently modified.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: SeongJae Park <sj@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/proc/proc-maps-race.c | 65 +++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
index 94bba4553130..a546475db550 100644
--- a/tools/testing/selftests/proc/proc-maps-race.c
+++ b/tools/testing/selftests/proc/proc-maps-race.c
@@ -32,6 +32,8 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <linux/fs.h>
+#include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
@@ -317,6 +319,25 @@ static bool capture_mod_pattern(FIXTURE_DATA(proc_maps_race) *self,
 	       strcmp(restored_first_line->text, self->first_line.text) == 0;
 }
 
+static bool query_addr_at(int maps_fd, void *addr,
+			  unsigned long *vma_start, unsigned long *vma_end)
+{
+	struct procmap_query q;
+
+	memset(&q, 0, sizeof(q));
+	q.size = sizeof(q);
+	/* Find the VMA at the split address */
+	q.query_addr = (unsigned long long)addr;
+	q.query_flags = 0;
+	if (ioctl(maps_fd, PROCMAP_QUERY, &q))
+		return false;
+
+	*vma_start = q.vma_start;
+	*vma_end = q.vma_end;
+
+	return true;
+}
+
 static inline bool split_vma(FIXTURE_DATA(proc_maps_race) *self)
 {
 	return mmap(self->mod_info->addr, self->page_size, self->mod_info->prot | PROT_EXEC,
@@ -559,6 +580,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
 	do {
 		bool last_line_changed;
 		bool first_line_changed;
+		unsigned long vma_start;
+		unsigned long vma_end;
 
 		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
 
@@ -595,6 +618,19 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
 		first_line_changed = strcmp(new_first_line.text, self->first_line.text) != 0;
 		ASSERT_EQ(last_line_changed, first_line_changed);
 
+		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
+					  &vma_start, &vma_end));
+		/*
+		 * The vma at the split address can be either the same as
+		 * original one (if read before the split) or the same as the
+		 * first line in the second page (if read after the split).
+		 */
+		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
+			     vma_end == self->last_line.end_addr) ||
+			    (vma_start == split_first_line.start_addr &&
+			     vma_end == split_first_line.end_addr));
+
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
@@ -636,6 +672,9 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
 	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
 	start_test_loop(&start_ts, self->verbose);
 	do {
+		unsigned long vma_start;
+		unsigned long vma_end;
+
 		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
 
 		/* Check if we read vmas after shrinking it */
@@ -662,6 +701,16 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
 					"Expand result invalid", self));
 		}
 
+		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr, &vma_start, &vma_end));
+		/*
+		 * The vma should stay at the same address and have either the
+		 * original size of 3 pages or 1 page if read after shrinking.
+		 */
+		ASSERT_TRUE(vma_start == self->last_line.start_addr &&
+			    (vma_end - vma_start == self->page_size * 3 ||
+			     vma_end - vma_start == self->page_size));
+
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
@@ -703,6 +752,9 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
 	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
 	start_test_loop(&start_ts, self->verbose);
 	do {
+		unsigned long vma_start;
+		unsigned long vma_end;
+
 		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
 
 		/* Check if we read vmas after remapping it */
@@ -729,6 +781,19 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
 					"Remap restore result invalid", self));
 		}
 
+		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
+		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
+					  &vma_start, &vma_end));
+		/*
+		 * The vma should either stay at the same address and have the
+		 * original size of 3 pages or we should find the remapped vma
+		 * at the remap destination address with size of 1 page.
+		 */
+		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
+			     vma_end - vma_start == self->page_size * 3) ||
+			    (vma_start == self->last_line.start_addr + self->page_size &&
+			     vma_end - vma_start == self->page_size));
+
 		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
 		end_test_iteration(&end_ts, self->verbose);
 	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
-- 
2.50.1.565.gc32cd1483b-goog


