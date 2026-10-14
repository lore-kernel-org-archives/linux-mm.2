Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C609ACC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 18:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9DE6B0098; Wed, 14 Oct 2026 14:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B176B0099; Wed, 14 Oct 2026 14:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 772396B009B; Wed, 14 Oct 2026 14:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E77776B0098
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:47:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68FAB1607AD
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:47:11 +0000 (UTC)
X-FDA: 85322114262.29.D671AD5
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id 45FBF1A0007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:47:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=marliere.net header.s=dkim header.b=FPIOsqjv;
	spf=pass (imf19.hostedemail.com: domain of rbmarliere@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=rbmarliere@gmail.com;
	dmarc=pass (policy=none) header.from=marliere.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792003629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ud4UQpU7GXwKVtHEzNn/aXQljAT04341tSRIlnW7qwM=;
	b=BtVtYYzv1cnO1MubtyzzuanMOKoIsWpQG1ydzvMVOeaVzHlG7ey33X4kdwagVEq9Ohr+cV
	fIssNwMLg8KjhFM0fS+JXzje/ZJt6f3qOdH1Wx/jkDhwmBSS8AQw9haD+fcxy3LAfTvCbA
	HuQHe8hwCYxcGOzKRkODlN83onGy/TA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792003629;
	b=Mk0DRMwJWnKQugVk4/uDbEvr73uS4xMyl2KS1YyT4xTUFgyBUIvIZ6fzrE3kSiBsNBniW5
	wubEdFOSAPbs5rUO3XR2NE5JQBtzOGx7gQX9QucwDCGfy7QD9KSc6B3Lajcc9ooc9oac+t
	+s/puSOgHyjuYaVPpHUMUYyOnJdPfYI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=marliere.net header.s=dkim header.b=FPIOsqjv;
	spf=pass (imf19.hostedemail.com: domain of rbmarliere@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=rbmarliere@gmail.com;
	dmarc=pass (policy=none) header.from=marliere.net
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-6cf995766a3so3599530eaf.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792003628; x=1792608428;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ud4UQpU7GXwKVtHEzNn/aXQljAT04341tSRIlnW7qwM=;
        b=D8zquTdr+/SAJlNzPOvNszBiqWSTqkY8wBbe3lzvqKzWijf5n9eGzUH6LHRpEYj/nb
         KMLVnQNIAi7z1L5QrOvsIzQ+zp2I9cMiCyoHvWBCTQvjKPAXvR63lnCKlRaJwuceHlNv
         GvVlsZubmPYVonLJuS1SbZqfZMjKOTu+zDIntNbSH+vzarOnvPaFlr5nAYpIMrReCt8k
         kbvX0lOskcCKVuW7UJMRBz3eydtXzc3kTHDNoIYrZfM//mnS8KOF14XEO2AsJjILxUzE
         9RIX5NtNeORYnftjPKwmIyf32stt8tSLgOTslVhTx5cIKO/UgIScRHlQWnPenAzvUUaL
         NQpg==
X-Gm-Message-State: AFq9FYKspTx2ez+KKv1bWajntKNVKB8p2U1jtl4mdRCy3+aHJAGm2CcE
	zERLASLoVqlX8Q54viRiMdCB0w/TzBs158PlIXcrB4bgJeGJzVA9CTQQ
X-Gm-Gg: AYBFou1xUEe5fEZetUM+ZAUT4cIiKZDDULwswuVbvqExX1+ybgv3NLMj2lY5PSRhX+t
	8ksY2os3MYURfzPfgKnGOkclV6qOwGlMT2VrOL1jpjBOw5iUO6miSUna8+QTgxP7BUxK0aGVZzb
	tLG4jJK0y29WNPxtulNIb4Xm/wB3m+T9/03xp7e9y0eKEar6u4nLasby0VEsamDj5TNRcWWzszS
	dAY3QZR0UepVFpxdNRqtckFHFam07d7WwSu8jBlRD6JqbWxA2AIztTUcTB/u5x8nAN09k7O48sO
	mfoHIcBLifYIyevcMiHU3WleO0qVNUAH4+QYtYbGXTtxIVxUnL53DB16PjPZZhrRJpY3iXEkDQz
	FpJtXQ17wHNssthBHlkPnDndSzHPcOpgucExmqMdq5Dy7PazBUuOX9nJg44DJRwTgbKjh3Svwnl
	fV9WwQdoI6V8eE1U8LEBZ2FW0AicqbHdDxc0euWDVnNALZw9EslPuiZB+ar20bsZNR4ZGWqwiSQ
	gvjvyaSPppzYJeavIxeOJU3x6PhKEvDQOykdZX4euQA+YexO33SsiTigpkz+79bEQV2mhbmrF+L
X-Received: by 2002:a05:6820:c2c8:20b0:6f4:ae96:c59b with SMTP id 006d021491bc7-6f4ae96ccdcmr6553693eaf.5.1792003628127;
        Wed, 14 Oct 2026 11:47:08 -0700 (PDT)
Received: from mail.marliere.net (137.65.66.34.bc.googleusercontent.com. [34.66.65.137])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6f47500ae30sm9548549eaf.1.2026.10.14.11.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 11:47:06 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 283216061E;
	Wed, 14 Oct 2026 18:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marliere.net;
	s=dkim; t=1792003624;
	h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=ud4UQpU7GXwKVtHEzNn/aXQljAT04341tSRIlnW7qwM=;
	b=FPIOsqjvI9KwWd8TDkBUXyQASuIwYvkymEHQbt7eA3vYTcc+QbYh7fpFXA2/SeJxafJZBR
	GH0srJnkwqT3w9MGG/AnWN8R7TzJNy63q76UWYHjemYZ2I3zvJrLqJQiktQGgOeppwuQNE
	fC9R2T24tUdjYBOSe7RPPbih2dytIgLjsq50IzNB7mVtUrISDQBn0JD2U3S1/aml8H5jzH
	f3iz9SHZ7TICCUk8Y8Zq8ZF7BKNuCy7ro6pJdUQp7fdNchflAtapa0RePn3gwoKKx25O5V
	Aqeyrw5iu3ur3zcR5BFZnoEcRSn3/VGrNTuREDwAIw4pxK/n6TyJoVeOrdX34w==
From: =?utf-8?q?Ricardo_B=2E_Marli=C3=A8re_=28SUSE=29?= <ricardo@marliere.net>
Date: Wed, 14 Oct 2026 15:46:46 -0300
Subject: [PATCH] selftests/mm: mremap_test: Validate the preamble region
 before mapping it
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261014-selftests-mm-mremap_preamble-v1-1-2e97f501cb56@marliere.net>
X-B4-Tracking: v=1; b=H4sIABXOz2oC/yWMUQrCMBBEr1L222ATtahXEZFNu2lXmrTsRhFK7
 26qX8ObGd4CSsKkcK0WEHqz8pQK2F0F7YCpJ8NdYXC1a2xtj0ZpDJk0q4nRRKGI82MWwuhHMqd
 wOWPXuJIHKIoyBP789Lf7n/Xln9Tmzbk9PCoZL5jaYasm4Z7TPqJmEljXL+N+uOGgAAAA
X-Change-ID: 20261014-selftests-mm-mremap_preamble-5f98ad625f93
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 =?utf-8?q?Ricardo_B=2E_Marli=C3=A8re_=28SUSE=29?= <ricardo@marliere.net>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1792003619; l=2090;
 i=ricardo@marliere.net; h=from:subject:message-id;
 bh=suiRUnyroocuk12grD5LSkD20Wp++sZxWYm4G3hH8zM=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgguRCc5X8/UX9M40lkMnr//aFGOhce
 x5ezt8MFNUFlqYAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QMvzTA1Be/AaPv+icYSQObP6ZSepseS099c1IS7GWL5yRAlaiDjRXKqF7qK+kLROsQ0b2JWSCxZ
 Qwfn01UPNwg8=
X-Developer-Key: i=ricardo@marliere.net; a=openssh;
 fpr=SHA256:pzhe0fJpYLz+3cZ33FFPhIfaUElk9CXPFFXmalIH+1g
X-Last-TLS-Session-Version: TLSv1.3
X-Rspamd-Queue-Id: 45FBF1A0007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bbauepnfckz1h69d3m15iwgg6o1njcfh
X-HE-Tag: 1792003629-959101
X-HE-Meta: U2FsdGVkX18M+8Div+y4/s7ytSqzk31oCb8xpC67AUnE0TLr81PTPtwwEIPL0YAu+t8PX8LraF4eYx6/Rw69ONJISgbelhpuRVAvVWvOtzSB2dfwDz81Nf2DzCu9FfV2eImrUontf7FGCOzAVwPKbDqQu2ZOswch/jM6XqS41zvs9pnD3W3Yr6LqYvZrKGyDxoGnyNofIMk4PSPVbU/H2RwyfMqA8vBGvwiEiww8OKYP2nwP7vqrYWfInsO4MVvlbgI7mwoCoSbb0hBV4YfZQm93ZRKwS/jYW+QT1TOyiNoUav8NeB2qvCxVu4g0pQXAobuAq3VWUsMoxIar/0POKM2v64k8/sf3Xi2NZXSQAV2t3UfqhY6Wj4BB1EAeXIeVs3bcNWpEBamTF4wXJnNiw948yMCzNy3dDXE9x/9RVtfPBWC2wf+ZR6BDpO59F0ja4WMuf6BSbNpgk0J45oBRCyKHLHabMd65Geq32EmIc99MvGz5X8Mz+eZDNlq6imXhvFg/S+3SaZmEkV+YzP8Py3fzpO/jutQXYQwaEnHQBY5N7riBM6/NNDZZmY/UoaxebJiDdLuiiHCBt9ZAYATE8lYa7WIwKwOKjKSoQsTnhP0ijBg12mUxU1iryFByMk4777LM4ULdjZLUNoK1WoNW0Zxm80EAlXonn1mq2JDO8vOscz8XAryb61Q8VSyXR2kCKUNZ5IQ/w8KHhoglaVjfepO8bnaQLpR7AJv9uTt/lMscnopvVb98ODnxLXeqLqvsA26V+i8RTCTMt2lT++f4h/e99dyG3oJ5njCmJAqljPiTtm/IQjA5IgX1M4U2Odlj3lOSrJ400S6BE2XeJ4TwFwVrCqHBkevX9IY81HjiufxetQoSfnvDSvCcKFzUAUk/Pt0m03mzT6BQ4Ho++z4VzTFqqIJudgm4evqLs4BVsCFxABhooQgqoGeabEAtb0C29wvj7j8UJf3QUXui9pO
 qftYhSYq
 8fbxSUgxFTRSqM5l9PaDSpi+o2bE8pToJp9V71awZ/n9FZnNVjZPDHvZBl7QXWari5QllyrCljNiUXkGt5ezo5qHFuvwzPyHWw+ZaNkm7LLr/RATPza/ieIAvIf79Mhlu/C57gLnf+ZG+FaaBk2QpwBFTMjwY125yocAehCCPWfzoxFA+9rgxIZJkbza8cPRgrPYLcORDqipMaM7eldVpjpiHir47J/yO1A9zfq+ACfLdXoTlL4s6iP1Z10urxAmnz4MuFFcP6Np4kOiXfmnxE8WI6Y1oi3LqGhtcqVZhqXSo0qd1Ybt9QWp3QzIjSnmW1HFTf6AUGGTVBUlLgqwW3bGnCYHwK6iE0TV+gfDTClCVO3snpcZ2QMFyq9A+KbhugVCSgQTrYCAkKTxneuLDYEmz0njKIeUD4QbdCEhGQVCQVvpUvAYf0PcLm10JsMw6D73AVIwX9TxaBNoepQuoG8tthwvGvl3nOy0h35TNpsze6vdIF/jX83QpIeDS+R4LK9F4XrS7TYdvNfpM51tVJ8iVty8v0LYHNGIqHKsSQfhWDuYmwoTDBl1h1j9c0l3DeMZ4I7gqR+nTHaOmRjKrZqVchq2wi/xd2Iss+UQGhxdME8aTdHIiKKJ1XpUATMIA4dyAdVEkBcb1RJG+O3ZlxwY3LhMrdv7+IEZNHQHyZnh2eTnuCtvuXMmQfcWYuSTm8Z2Obb/d32byh8PVg6BNRMgX2Jg3gtL1hYzJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

remap_region() checks that the destination region is free before mapping
it, but not the preamble region placed right before it, so mapping the
preamble can intermittently fail with EEXIST:

  # Failed to map dest preamble region: File exists
  not ok 15 5MB mremap - Source 1MB-aligned, Dest 1MB-aligned with 40MB Preamble

This happens when the kernel's heap ASLR (arch_randomize_brk()) lands the
process heap inside that unchecked range. Confirmed by correlating
brk(NULL) at startup with pass/fail across 60 runs: every failure had brk
land inside that range.

Fix it by including the preamble in the free-region check.

Signed-off-by: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
---
Hi, this sporadic issue has been found in openSUSE CI:

https://openqa.opensuse.org/tests/6270334/logfile?filename=serial_terminal.txt#line-6760
---
 tools/testing/selftests/mm/mremap_test.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 131d9d6db867..8d4fa3025a9d 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -1006,8 +1006,10 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 	if (!((unsigned long long) addr & c.dest_alignment))
 		addr = (void *) ((unsigned long long) addr | c.dest_alignment);
 
-	/* Don't destroy existing mappings unless expected to overlap */
-	while (!is_remap_region_valid(addr, c.region_size) && !c.overlapping) {
+	/* Don't destroy existing mappings unless expected to overlap. */
+	while (!is_remap_region_valid(addr - c.dest_preamble_size,
+				      c.dest_preamble_size + c.region_size) &&
+	       !c.overlapping) {
 		/* Check for unsigned overflow */
 		tmp_addr = addr + c.dest_alignment;
 		if (tmp_addr < addr) {

---
base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
change-id: 20261014-selftests-mm-mremap_preamble-5f98ad625f93

Best regards,
--  
Ricardo B. Marlière (SUSE) <ricardo@marliere.net>


