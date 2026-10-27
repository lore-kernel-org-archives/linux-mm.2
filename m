Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8AEA606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OzCpyyCq
Received: by kanga.kvack.org (Postfix)
	id B14276B08CB; Tue, 27 Oct 2026 16:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEB0F6B08CD; Tue, 27 Oct 2026 16:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DC1B6B08CE; Tue, 27 Oct 2026 16:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 730596B08CB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:09:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9A94C0AE7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:09:05 +0000 (UTC)
X-FDA: 85369495050.24.23F2933
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA61B40003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:09:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzCpyyCq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf07.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793131743;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VeEh0rShVYt/Qe12CelPAOWD3oT/iB75neohsnBaq7s=;
	b=cLTM0ExkJ1rvubwpeC4gNn9MNIvi7RzdwwCyFHdYL6kzIKqAOHJ08CTtTdf5t+t7sqRarR
	YwozpxtjdGdDFtWzloHhW4LjmHoc7rsr2mrpIwGfzA3sj04JvM2CSfE5/Q35WdpBZGG8mJ
	purYoBvZ9A6c3zAPhTg1rJiM8MS4aTU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzCpyyCq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf07.hostedemail.com: domain of devnull+mt4022.columbia.edu@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mt4022.columbia.edu@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793131743;
	b=iS2Ms7Ziy8eNJdqqOj0vOmr8d+XjZaeRb0NdE16LodKaKQ5mWuHiEb41kYd3ca5L4liSJa
	hTqrvaWk9DInC7/r8w7mx415ok5XLLxDnh62bDf8Ne1WZCkmcTdxyGbMNdeadidCMspxIE
	b4h42r34sWeREcenGcSht4TDWUL3ZuY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C2A143B91;
	Tue, 27 Oct 2026 20:09:02 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793131742;
	b=IC5yHianAWAZ9MGWEEhNM9xP1tRw7BStTU9jsR3w2hH3xkWw+gblW0DXLgH5XeRuEHH2
	 LTTQt+s6HX4lVOz3+JNJLFtJXfJdnHpZ9cT9Z85piqobSqqAOSYDX0GEmvP9dfkLGlsNc
	 PGsjO/ecJOCQke1192SE011XY0r9idRwGa5VcD1PtDFw9z4U4AfAKI1h82aAmz19RiT+y
	 /jszid0Xl4ySw67NPS7ahypEHS2U5/jTJGI/aVBgLv4Sviw6AzV7/P3KUoCRo3dkBkAPH
	 gS1sthkYeSB1g+qfmHgYBv1StsxsB/b2MEI25NsHmzkSDuzltXVYjaYqDLVms+dWAnw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793131742;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=VeEh0rShVYt/Qe12CelPAOWD3oT/iB75neohsnBaq7s=;
	b=Y0+e768HBov75oGpO7EEdWwp7eL4t0a4/kPM67gNNWeFvFP+Ji5VQSUvAhNzl0ZkJnJY
	 GrbRvhR/m4BFVJ3FWlicelYncy9yYzcvQdoyxAW8Vv1LCo1TJxxQYEBXnSQFSCJTOdK42
	 fJRqf8cYma6SzpiEXxIrJLExScRbeXszbbZKpnfKnwimynjLEP1YeH9C1tScTYyFmT18q
	 8rNpn2RBPwu40l19z1l25XBGB6p0BpIx9gfNTcUtpzzVCj3UFIE800rNrKqRyfrw+ZEhO
	 1jivXrfECaOUSCYZPicPeMIYtmrFGiI5HVnrMpwi6IQWgQuAglGqpi+rljgoayHu5Wg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 095DE1F01825;
	Tue, 27 Oct 2026 20:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793131742;
	bh=VeEh0rShVYt/Qe12CelPAOWD3oT/iB75neohsnBaq7s=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=OzCpyyCq+cGaRUmp3UUPoXn333kGLmmkp/w8rhfiLT8F2+s+FMDMzIUauf/5MK8in
	 ctWPWjxIRlTOBwsm8yKx31KdSs2RMrJH703ESHd5A3CnurdYUiWJUZfnUS/aiXRkdM
	 YD68/6La9O1GZ4iqg9JE44wzoIe+Tu2MrAW9+sCMVE1maJ3GCEXzNP+VjEEmd6s8Hr
	 tgV9/z+gIeZN1wiHJiR7J6GZX1n6XoPt7CffvktAeBxpxqpip6/8UR4Va7xt8ln9Pv
	 YZhp9Dcj8Fd8mBZ52a/cbSj+55BRNP/nOE/RrwUmhW0oxWJOFfZ9h13uqlbBYsaTqN
	 QDYEdW33YJVhg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8AFEC451B4;
	Tue, 27 Oct 2026 20:09:01 +0000 (UTC)
From: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>
Date: Tue, 27 Oct 2026 16:09:01 -0400
Subject: [PATCH] mm: annotate lockless accesses to vm_committed_as_batch
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261027-kcsan-mm-v1-1-66757485b917@columbia.edu>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAyNz3ezk4sQ83dxc3WQDQ3NLE1NTS1NLSyWg8oKi1LTMCrBR0bEQfnF
 pUlZqcglIv1JtLQCK5KvgbAAAAA==
X-Change-ID: 20261027-kcsan-mm-c01794559599
To: Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, tz2294@columbia.edu, 
 Mani Tofigh <mt4022@columbia.edu>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793131741; l=2109;
 i=mt4022@columbia.edu; s=20261026; h=from:subject:message-id;
 bh=j7Mc9C4QlmCwhmnKNi4h7TqTqfjBLIBQjYqiZTNCEhg=;
 b=0Hqd2fa5iviDcBvKgRDs91aLAznIPOLYpILVxsb/Gu5CvLIwOieETU/yf+NKTPQfPHczGDeQK
 J9UjE21rqSfBHoTSVWFwm69tJ00PEmDUjslAk2LRNLpDoBJ9Upa1Mc5
X-Developer-Key: i=mt4022@columbia.edu; a=ed25519;
 pk=gljCMQDuxyKPmd5y37CRpEJGSPXDV1MyAnHBhCgXl0I=
X-Endpoint-Received: by B4 Relay for mt4022@columbia.edu/20261026 with
 auth_id=1322
X-Original-From: Mani Tofigh <mt4022@columbia.edu>
Reply-To: mt4022@columbia.edu
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BA61B40003
X-Stat-Signature: gyymgpcxm8ykkpxyk78kh6ryp7xrwhi6
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793131743-922385
X-HE-Meta: U2FsdGVkX19J/O1wbwkvtAStO6nGwgDfiscs9Ga7gw5uq+Kch+ludQU5qu4AkW2m8UimmWxZSdJtL3UkIligOxFD/nLuR20Vw0Fs/J6vHsktZtZodF48/lGpxLo5yKdrtIMrNZfJ5s34WcqOu+9Rgy1bpjzFkS4Fqu0jtxSEPIzVtHKJZcgAQ4FatfaCEBFkJiWo+eCsEeg2VkvY3YTtAJBuSUDGyjmAcqgds9gdsSQYHQafFWvE7mZtAv81jpqB4uKLhYpm/3cVF/VtUQde5rungnK4oYy/JVHsNJn5SAyZVmHGYpaBjrS2hdSQgyUFoX5moB3F2HxWOVgUcIbiSh/vSEKv+ktmqK26FReaHA3X8X+L+Wh1H7Vhhx5oa/t6W1CP9gc9hwJYxFk6V4/6sMtkEpdcDejXj223ZcQz7SobKzCJqIEuNW0IIKOhUnqBQu4OASQ6RtmutP+1cclGRZRhfsbDODEoSi4JY+WRG/xmJqZbgd8ZdPqiYYspLJUuc9v2v605EXuCGP8KwHxEYaQOzh9wifYtBSN+GxNmwba6iof6HsrwkeS945oDqCnG+OsK39uOLKcPjIJo0bYG1lAKgp9oISPMZqGsM+Af9D1vhKVLn8erQPF/JTqZsZxwSaxVFRfRf5vKrvbtUnRNcYwZWUbIt45/w/IW/Fdv/WVCw3zINtj9YQXCzKubCnajgLBeYrX5PhohhXPF0qs2po3Lq5OFSbhR1Vqtdzm4b66/Apvnje4dbYHyM19owY+37tXkAazZ+wbP4py4g5PU1cZofYM6sO8j/m1eHmVoJDiqopHzERK0ZordJEiozkiIv2Qup9IEo5sH4i5nfy0Cg683oTZ2HU442Lm6D3zclIv9PuLEk8fX4wbo5FioHnf99DpdRx+r+79/kFAcl9DBU8FoyFF1b3rav4IOxGSO9VHNWHq2VcxctVmiMIXyKcI3JNtpUWD85Hjs+l2i8r7
 WrwlXXkb
 i5rmOKx0nPADto7LIleG7cbv43X8eA87KntaVmtfIaMBIdOWMEGTPJV5hyXoyRSYRDAYDbjS7ZaZv+ROYbFNIZ1mIoXAvatXsb15Ka+OGoUV7sd4zmbcll8wX1Mry1ZJrOtHXUw071aFXdLgevZPIELgpk58YkeWm0vC/G2OBBD/d7zDCWSnqOWHJxQdDGergaNURPAAq5xtYvRWXNTpd1a3zIebDrs+xTESTH26MhbC3eF3O3p6Li7fxw8qoL5W5SAkaw7r+R2lXzHy9jN0BOYz5vEcHqncq5KzAGYIbDe/tadCNH0kAqTPzWmlUmHCI/gXVVGbeIp150Tpi7ASmLbyRFE87c2Sgwl9sFnQBzbCESCAQ8w/ZvRzsaZRj+LMUi/dacKRBI+ogoIptPJLp2Xk30YG+vnnBPctEiEjxkZDT/4r7q84/AHkkoFnaiuhQEqiT10EWzyvt2x0Wx3WL292nbpUaFIzpL3aP6Id3VJzcYObbD05OuOde3jav/sb3fbGElC/KRPW1CKE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mani Tofigh <mt4022@columbia.edu>

vm_committed_as_batch is read without a lock, and it's only a hint for
how often the per-CPU counts get folded, so racing with an update is
harmless.  Annotate the accesses.

  [    0.953509] BUG: KCSAN: data-race in __vm_enough_memory / mm_compute_batch

  [    0.953645] write to 0xffffffff825165d8 of 4 bytes by task 1 on cpu 0:
  [    0.953692]  mm_compute_batch+0xc2/0x120
  [    0.953781]  mm_compute_batch_init+0x1c/0x20
  ...

  [    0.954325] read to 0xffffffff825165d8 of 4 bytes by task 41 on cpu 1:
  [    0.954373]  __vm_enough_memory+0x24/0x2b0
  [    0.954444]  shmem_inode_acct_blocks+0x1b3/0x230
  ...

  [    0.955288] value changed: 0x00000020 -> 0x00005003

Found with KCSAN while fuzzing under a deterministic hypervisor that's
currently under development.

Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
---
 include/linux/mman.h | 3 ++-
 mm/mm_init.c         | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/mman.h b/include/linux/mman.h
index 389521594c69..66e6c9c335b5 100644
--- a/include/linux/mman.h
+++ b/include/linux/mman.h
@@ -75,7 +75,8 @@ unsigned long vm_memory_committed(void);
 
 static inline void vm_acct_memory(long pages)
 {
-	percpu_counter_add_batch(&vm_committed_as, pages, vm_committed_as_batch);
+	percpu_counter_add_batch(&vm_committed_as, pages,
+				 data_race(vm_committed_as_batch));
 }
 
 static inline void vm_unacct_memory(long pages)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 41a27860d2f6..81f360db0787 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -211,7 +211,7 @@ void mm_compute_batch(int overcommit_policy)
 	else
 		memsized_batch = min_t(u64, ram_pages/nr/4, INT_MAX);
 
-	vm_committed_as_batch = max_t(s32, memsized_batch, batch);
+	WRITE_ONCE(vm_committed_as_batch, max_t(s32, memsized_batch, batch));
 }
 
 static int __meminit mm_compute_batch_notifier(struct notifier_block *self,

---
base-commit: d135ab453a7400a34930bdda1ef4bdc8acfac80e
change-id: 20261027-kcsan-mm-c01794559599

Best regards,
--  
Mani Tofigh <mt4022@columbia.edu>



