Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41B3ACA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 09:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC8ED6B0088; Wed,  7 Oct 2026 05:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A316B008C; Wed,  7 Oct 2026 05:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1AE56B0092; Wed,  7 Oct 2026 05:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 765646B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 05:17:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E2EB120149
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:17:37 +0000 (UTC)
X-FDA: 85295277354.16.B7D19AF
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id BD9D21C0004
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:17:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hSoq6sjB;
	spf=pass (imf18.hostedemail.com: domain of sahaj123.sc@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=sahaj123.sc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791364655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tMJqX2UfW+yt+gLeXDIEXy10CvrOQ6MYyBHgdruEdmw=;
	b=sIkB8yA298M027Oxdd8S1zNfhj0yC+3Qj/e4yfVn1QLwQCzVc2eRwNkJ+1M038T/XW/068
	tB/tA7A+FRHx64wGbZGD8/pv7zV9w8YukugFV14evNlhpf+LaegoPv5zDyIQuj7hwKVHjU
	NkN0g+GBsV7ROHyoZxTyJ1pbxGRZLbg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791364655;
	b=DzhMI6HPA6VsAyldtiXhd2dhDX8bsZd+2mck6CvgJ2PIFFa0+g1C+WYTKni0EmDuErXjfV
	heTD7h8Oy5ew039s4bjzZJMp9yqCOdKCx7K3CQUWUzS92iKi77cSG10RNyAWJBJfhFHIs4
	X2xp7Ki+sRTgcnQYE1GlFX172eh4G6k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hSoq6sjB;
	spf=pass (imf18.hostedemail.com: domain of sahaj123.sc@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=sahaj123.sc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2df8c28a0b1so10967365ad.1
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 02:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791364654; x=1791969454; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tMJqX2UfW+yt+gLeXDIEXy10CvrOQ6MYyBHgdruEdmw=;
        b=hSoq6sjBx22KKm15d2U9YtFs5uQRY3Seir7I1/auhskhIA409kS8a+0AxykCSNAkwf
         oPE3ezKrX6+KCnofBwmu6a5LsNBsWoZX1Fjd+fWXJowvm/V/a1YRTfQps0nY6iGJiEVk
         9i6CuauaW12b8skDPcX4Oi83fL4Nul54Pe87UZvQ7PeMLlVG4EZvSPpYCrWV++skwVIE
         bj7lGfUYf/Cj5Hyc9ELLB/vITAsMQ+IkUKabvwVWaUdi9QFWgRqRNKHsxoX2umhNhfQA
         ZgCY7CpmsEGCUlGDoLxjsx+PQ0mSQSU2DxZ0+TxEicUAXCNX1KE10oGLS7pGWARTBkvm
         aXUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791364654; x=1791969454;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tMJqX2UfW+yt+gLeXDIEXy10CvrOQ6MYyBHgdruEdmw=;
        b=uibji9TzuRGXWJoAp62i+Lx/iJmqzyhmWq+zCNOtcifUlGxuL5CapjcL0V/qOzNjtg
         y3Zqm7CNF89SWQEr7O1ymYF83QNa/7Ozp+DGzkgdLlT+X5ycWJH81sWCoFRtY6pukwUr
         3sn3l6O0iH96Sc3kfve4Zev+2TjNk26pZD3WYIyKp4n/7xz+pdRf4yYK/2DAtMUaIjxY
         JuRpc8ZNu9g5FerZvdgGKXwk6q3hM1PWePEaF63ytz212Uf1iGXIcvPo9lqMbtA8N0XF
         Lejl2psQWzgEIDgnSlcG2iKUNQSt55hrZ3Cba9w7bvJl8oCDB+IEFFvroMGgVDg1RWVZ
         cYbw==
X-Forwarded-Encrypted: i=1; AKwUvBw3O3AmEegZzrAJhPmzjhKO9c5sGm+h37Oe52Vet19hOIIQ6X1mvItBcaahKG6P6PZDAs777KPlHQ==@kvack.org
X-Gm-Message-State: AFq9FYIpa2pH7SAaKMu6j2PqrVmMjxjvez/vWA5ro+ta2si4H1MINWR8
	KyD6DJ+dinmuJ+RbL8agcuR7BCFnXXlQ+lijRsXhaCZR9HO+0ZV8O21r
X-Gm-Gg: AYBFou1Du7SEZBd6bRDcLqy8iKjwJaWjhrRGYRbNoE7vW7kHZe8xvCrFAHhT1nH94rA
	C7xMYtlqZImFfeeZ9uTuno9PhW1gHO+RYuaSepCoHz+q6mZcrpEap86uWp7lxIn8PBpgdb3bsU1
	zHwioWplXZ4Kgneom0fuuVWmH/stcnAgxi/eDTdFqVeo1Hs1/KxzSRoQV3rb0RDkPJsJhOkvAIA
	sQQmgTCsuo1BYxEcZeBHzOdRMzklXEyipZGJWjjbercW6iZ8WZgqNq+Yb0FZHPq3zBPNtyGmRaj
	0F9M0E3z//i7Sgd0Tfji3Jx1NLGQVXNnWySbIXKY/ybOmxz5uZdYzJcOKZmXkbFR1oT9X2n3jJ5
	t5ObXmvZWsCtvGwsaSteNffoK9GhEBr7rJYq9E0Y5ZNw/m82ROdjebcZPT2QEV7hqxbwFWesQym
	VcWuqkd49lkWqVZOrKhXXExmonbNjMkrnQjI1i7+QRmmIQePBQG6nMYC500g+6GDBrRP4xbHzmg
	Y53163nqIPhDwPdt3YyfKO8UX4=
X-Received: by 2002:a17:902:ce0d:b0:2e5:a355:56e4 with SMTP id d9443c01a7336-2e60036c486mr15062015ad.11.1791364654342;
        Wed, 07 Oct 2026 02:17:34 -0700 (PDT)
Received: from obadmin-Precision-3680.atlascopco.group ([167.103.3.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e604724b46sm7175375ad.42.2026.10.07.02.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 02:17:33 -0700 (PDT)
From: Sahaj Chaudhari <sahaj123.sc@gmail.com>
To: akpm@linux-foundation.org,
	shuah@kernel.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sahaj Chaudhari <sahaj123.sc@gmail.com>
Subject: [PATCH] selftests/mm: test MREMAP_DONTUNMAP mlock accounting
Date: Wed,  7 Oct 2026 14:48:09 +0530
Message-ID: <20261007091809.1438944-1-sahaj123.sc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BD9D21C0004
X-Rspam-User: 
X-Stat-Signature: d79j5kgfj619bw1mj9if3yz6s5nt7khb
X-HE-Tag: 1791364655-42505
X-HE-Meta: U2FsdGVkX18pbDhUaEfZnS/NYoTDGv1DQagS3Bps9+1QP8IGEl9Ws104j1BgRAzO9njpRZGW7A67v6Sm+WBhWxyvD3S4yICeC0vkf7kzqWUapY4+eM58R9wyQPF09J9J/kwJRqzPjMaqaMKZT0XkfgPaEmlSOw4tJV4Q/NGULsxxtXB6YVLdcUsGSl/L0w79cRoDXBRWvqEaQgTyp6vtC2KYSnGyxl+PLOFQlUNccQmF4GpGJhOMi8e9B8KobpPedaCfYrHnqiTsAR1+Sdp25Bbf3RrU5pOuqMw09C+g8lh7g4KegxRk4dsPo8gXQDbAzEqDNtSOvAlIMAh31z3abC1LVM9EZX851wbHejdeAc1jw/OLNwwyPRRh7SF5DJE14QraOmW6/n2aOm+jLbNbeACPUYJSfAsQDoQlDm5rr4/GfOoouhjCE8Tu5yUdU7VEFd4n7Xbxp5QR8UZ49XDs57Ypae39qvD9Y5OEJRSlhoRHZe8LeXlQsf0rfdZx9VHuwtJFj678te1+Iob+ph57gG5TaVdabHJQ143X5mEqlJu1GDubp5cazHUHr8VOYFQzvNbWEM9z0WQf6utzO4aPPTKE9rUTOF34qdWEFKSQVQVpUHD+gPt5hU2jgS0wRWqsDr6gb2v+X90Lw3lW7J2LgBFzCQ3FHgVFAu9MlJCHbpNiM9TlykNzjlRaSi7yLww2WR5ckLdF2VPBhFx7zUeqQEHYY6JJEpUyWNRul+JwU60ZbLWJffXsvoxW7gKTGz+aHPE/yExw+PIYM2Zhyg8CGrG/nqHBxFCww5xyaLQgUTDNWeIz38JEPK5lM5cifSakGtmZCGYZiY19jzxf2qnjwVYBZu+U/1doxmq7J8L7lLyOKbZAi4Tg5mOsHTazpusQZeBShs+0I57w4bUT/mPn5dmQLzXICDfLpSvPNOF8ZwC7L17X6aiz2HXtV7bN5Ha3C5AQHpstKJJ7OPpPzDS
 z4VCdHe1
 O1FPT7gfxLzMicOU42wcwVJoXx/RUD9u/ouQNUN3Mu4i2HrGJI0YY43dxTAT6MqKHdPcAaSYQlebIqfmEo/cfSGMCOl5sa+COe8hWLHS6ex9/g7gYO4jzyV+GRiBVwdWZnx31NFS+P+vVe8Pf7MlhIdv7NvJOYHT+qhiO/aRChrWeOdQdlCrmQpV9JvFfKlQhkUxC1KUWpBab8QthBsDkOrNxkHBFc5bnPuKg03MkdYBmuziT/4pPov+6pWwIJ28qJrPwNXd6N3UJe4OVEX/tEuqxXNA8+cnFTN1u8zlf/RNozYA/OiJAnMnzzEOK+37V3lSaYMPwmoglxQnZ51NOurB3zOri5H/y6OLloBdqUkaYnCveE89MT2CRWEXnHGzyE4T1cXhsEp+MbRlSrvnev4Uwhkc7YFsP+2TksSnar6TWbEEqKAVyyGKyjyumj+mLzyqXgKgfC2MO1SCzoNlccfPeeyU0pBa5qLooSArka9s7DJtQLKyw21x8MLYEJWz9ymSy81ZyDJPGJ9uVrib5KhwgIdYx6gHy2M8n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MREMAP_DONTUNMAP moves a mapping's page tables to a new address while
leaving the source mapping in place. Check that mlock accounting charges
the page only once after the remap.

Add a test to mremap_dontunmap that verifies mlock charges one page and
that MREMAP_DONTUNMAP does not increase VmLck again. Skip the test when
mlock is unavailable.

Signed-off-by: Sahaj Chaudhari <sahaj123.sc@gmail.com>
---
 tools/testing/selftests/mm/mremap_dontunmap.c | 92 ++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_dontunmap.c b/tools/testing/selftests/mm/mremap_dontunmap.c
index 96ba537facf7..e4b0e1868a6f 100644
--- a/tools/testing/selftests/mm/mremap_dontunmap.c
+++ b/tools/testing/selftests/mm/mremap_dontunmap.c
@@ -90,6 +90,26 @@ static int check_region_contains_byte(void *addr, unsigned long size, char byte)
 	return 0;
 }
 
+static int read_vmlck(unsigned long *vmlck)
+{
+	char line[128];
+	FILE *status = fopen("/proc/self/status", "r");
+
+	if (!status)
+		return -1;
+
+	while (fgets(line, sizeof(line), status)) {
+		if (sscanf(line, "VmLck: %lu kB", vmlck) == 1) {
+			fclose(status);
+			return 0;
+		}
+	}
+
+	fclose(status);
+	errno = EINVAL;
+	return -1;
+}
+
 // this test validates that MREMAP_DONTUNMAP moves the pagetables while leaving
 // the source mapping mapped.
 static void mremap_dontunmap_simple()
@@ -125,6 +145,75 @@ static void mremap_dontunmap_simple()
 	ksft_test_result_pass("%s\n", __func__);
 }
 
+static void mremap_dontunmap_mlock_accounting(void)
+{
+	unsigned long before, after_mlock, after_remap;
+	char message[128];
+	char *source, *dest = MAP_FAILED;
+	int failed = 0;
+	int err;
+
+	source = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+		      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (source == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
+	if (read_vmlck(&before))
+		ksft_exit_fail_perror("read VmLck");
+
+	if (mlock(source, page_size)) {
+		err = errno;
+		if (munmap(source, page_size))
+			ksft_exit_fail_perror("munmap");
+		if (err == EPERM || err == ENOMEM) {
+			ksft_test_result_skip("%s: mlock unavailable\n", __func__);
+			return;
+		}
+		errno = err;
+		ksft_exit_fail_perror("mlock");
+	}
+
+	if (read_vmlck(&after_mlock))
+		ksft_exit_fail_perror("read VmLck after mlock");
+	if (after_mlock != before + page_size / 1024) {
+		snprintf(message, sizeof(message),
+			 "mlock changed VmLck from %lu to %lu kB", before,
+			 after_mlock);
+		failed = 1;
+		goto out;
+	}
+
+	dest = mremap(source, page_size, page_size,
+		      MREMAP_DONTUNMAP | MREMAP_MAYMOVE, NULL);
+	if (dest == MAP_FAILED)
+		ksft_exit_fail_perror("mremap");
+	if (read_vmlck(&after_remap))
+		ksft_exit_fail_perror("read VmLck after mremap");
+
+	if (after_remap != after_mlock) {
+		snprintf(message, sizeof(message),
+			 "VmLck changed from %lu to %lu kB", after_mlock,
+			 after_remap);
+		failed = 1;
+	}
+
+out:
+	if (dest != MAP_FAILED) {
+		if (munlock(dest, page_size))
+			ksft_exit_fail_perror("munlock destination");
+		if (munmap(dest, page_size))
+			ksft_exit_fail_perror("munmap destination");
+	}
+	if (munlock(source, page_size))
+		ksft_exit_fail_perror("munlock source");
+	if (munmap(source, page_size))
+		ksft_exit_fail_perror("munmap source");
+
+	if (failed)
+		ksft_test_result_fail("%s\n", message);
+	else
+		ksft_test_result_pass("MREMAP_DONTUNMAP preserves VmLck accounting\n");
+}
+
 // This test validates that MREMAP_DONTUNMAP on a shared mapping works as expected.
 static void mremap_dontunmap_simple_shmem()
 {
@@ -348,7 +437,7 @@ int main(void)
 		ksft_finished();
 	}
 
-	ksft_set_plan(5);
+	ksft_set_plan(6);
 
 	// Keep a page sized buffer around for when we need it.
 	page_buffer =
@@ -361,6 +450,7 @@ int main(void)
 	mremap_dontunmap_simple_fixed();
 	mremap_dontunmap_partial_mapping();
 	mremap_dontunmap_partial_mapping_overwrite();
+	mremap_dontunmap_mlock_accounting();
 
 	BUG_ON(munmap(page_buffer, page_size) == -1,
 	       "unable to unmap page buffer");

