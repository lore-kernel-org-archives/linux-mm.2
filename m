Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CB90C54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 04:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 378816B007B; Sat,  1 Aug 2026 00:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 329136B0088; Sat,  1 Aug 2026 00:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23F346B008A; Sat,  1 Aug 2026 00:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DBBC56B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 00:13:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B9B31A023F
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:13:13 +0000 (UTC)
X-FDA: 85051380666.14.C82CDEE
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id BF49A80008
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 04:13:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AdHvedlI;
	spf=pass (imf02.hostedemail.com: domain of 3VnJtagcKCEs9sryv2rt11tyr.p1zyv07A-zzx8npx.14t@flex--wfelipe.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3VnJtagcKCEs9sryv2rt11tyr.p1zyv07A-zzx8npx.14t@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785557591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5XpdFy8Z6PUfDqbqo17LIsT1Kc72p948s1zae/y2clQ=;
	b=m97zQpkKe+e3HWq7PkKMpN8OkjZJmFoiT5ZUOkyDBFyF10NrslpSA1R0yb7Pg4GEAxhlU9
	rb00uQYH7VAeRSIXsrUoLvdSHFRhIn7f8ajYgQAMOq+LwIgF7SPDwC3Jks+TMHBh0aXKR7
	5BQx1u52BnKqCbUIKTRaQDeF/Yzxquk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AdHvedlI;
	spf=pass (imf02.hostedemail.com: domain of 3VnJtagcKCEs9sryv2rt11tyr.p1zyv07A-zzx8npx.14t@flex--wfelipe.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3VnJtagcKCEs9sryv2rt11tyr.p1zyv07A-zzx8npx.14t@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785557591;
	b=WmqyW6JtSqmoHYiO5S8DSbzkD+3sBVIcbx+bos3mn0Rqnp6zqzdBlnapa9xBZ49eAbq8fU
	OEk4xWVq1zO1SR66O10dw9j+svyJ1FOE2zD+q3ftLsM2vAkZIaaGtMUhdlfhy3RCis0C4T
	CFDph65DAH/YA6vKE1oH4Xa5E9jRxGw=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e7ff7b375so1833249a91.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785557590; x=1786162390; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5XpdFy8Z6PUfDqbqo17LIsT1Kc72p948s1zae/y2clQ=;
        b=AdHvedlIrhEq6LGUxBn2YayQsO/dDQBfXn2LhjM4qQVDuDkYHb1neAalfOUIBvkggQ
         j6Ebpppbr11HFRb7r9vXUr7Ald0CXq/b5a4h3PwL5iyPMb77PkqMu0dCTt4WZN5xTG0X
         gFkXPwi2fAwWIwzuxxCge7LdnW09b38yb95mvlAcn1wuSVrVEXr9gEr/tY2VNXwsu3mV
         eyQTdAsYGnpRBh+dG3gYtHAEe8KkQNyP0n6oRo/ZqCiunJTf04fFbp13AqueLzafKr4q
         cF7ykj0iSUJjDPwNI+bzIDuNzx0BuJmZgYRQjIRQz1kMXLXH5Aw+zEyxWRmMgrZn7o+X
         YcMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785557590; x=1786162390;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5XpdFy8Z6PUfDqbqo17LIsT1Kc72p948s1zae/y2clQ=;
        b=mRbgGySK6W6cWJvs2rP3B+eshgjrWbKf0/jvGr71AnASb2ZL9CalOulN4RKd31gw5V
         q8qsia43VObbwl/WSxYahT5fB1JEK8eomVyBW1YWUZPMANt1fRN8GodK5Lt9yO2Lzw6+
         K/kG1CB0PlfEaa3XHWhJDQU1qdAm+UgkFift5XI45W0RieNQsdRpqU+xkpshEFcHf1by
         DCfMNyrXsmQslEORO0eQIHCK0WcI43RnQV/h9tXvbbV54tsXh2vV3ROHrgPhEIWcHcVJ
         0kp+uM5ZxwhnenIuQEicgIo+oIfU/SLkbroB6wn+VTvHvhKvaJaVWyEuud8p64Y4PnHd
         Zbhw==
X-Forwarded-Encrypted: i=1; AHgh+RqOgXhoSsk4T2IGxxB5yeRPRib+v2NG8yxyxZmcnhpGuMYb533pmi5Ic6x0HJsvO5RCKiryC/3ANg==@kvack.org
X-Gm-Message-State: AOJu0Yy7YLtlu5vGf1MK9eY4m6r4xNOwO5lqjgHM+D+ye9maaYzAApUm
	BQbo2K/6i5MqNNOl+gTj7FgzEV0X6BQ8+0gh3boqVSngatgCn4SWPsOvqiIYqwTOZzthmoCZWzk
	TDSpYejpZjw==
X-Received: from pjgg7.prod.google.com ([2002:a17:90b:57c7:b0:37c:c540:67c4])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c91:b0:387:e0db:bc26
 with SMTP id 98e67ed59e1d1-38fbc538106mr1983898a91.38.1785557590236; Fri, 31
 Jul 2026 21:13:10 -0700 (PDT)
Date: Sat,  1 Aug 2026 04:12:46 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260801041255.752039-1-wfelipe@google.com>
Subject: [PATCH] selftests/cgroup: test_zswap: skip test_no_kmem_bypass if
 debugfs is unavailable
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: BF49A80008
X-Rspamd-Server: rspam01
X-Stat-Signature: 9fcdjdmus7jy6htzyetip8ki34qfkthb
X-HE-Tag: 1785557591-387407
X-HE-Meta: U2FsdGVkX1/7CZ77FGCr/+gMEwjuGRth1ATL3C/T9GwqSHJTksvLIe7ED1KU53gUK9ONv5t/tNKwEJdLAvzRIRsYDcMCvJfTjT0RwzMDbLIHBo5ZkDP3z+9NsO21YyEPMwQU+C444LX9ZwFawCYOYee+7os+NFpGMJEV9HZhPu8CqF2NZ1P6KccFpphpMz/tb/v4X8RvxP5K4ZgFIBOHNz4vdV6T5kt7ZdKLigBKr1yLRdptXXCo0dDYkZBT/r+vqmdpV3Qwry13yXphhfFVSX8ao3BCI4h2RRoUvDgtkjyNlozvdkw2koILU4yKoTMtdBVQE4brgul0qMVEQg8Z7d/Mmi7p49QPT7h4vjMglHasjyYRCooYVj9DN8mt0pDsr3ra5d9OW3YUHPsXMk8lPXa4Fa4Ur2GCIWBHv5G6LeWGTF5MmD6J1vHvGuYaZU55KzSAeFztbi8vHEWG+if4HPqZ8tafvqqbhCG4VaYCI/rhzcMuqhHC8M310VqS3rxcEc+fqZfouVIX9EDpqsKdAS1PGGY6mtKTGYjiyi7vavcp3hZCsvAXAXvDzTvSJZ5ybvPUj6nGgAS14hYN6Mhu3IiBArfEIQpHrMh8Zo/OPZsxheqrGDoCUaKePtBfZLHJEBlfqqhEsSnhMAKRLU7k9E/cgVQLmXQoP1dyztbRRRuKWCRcPU2g668Fqr2+K6JaM2I2OZNrmWsbvSCQ6VvSjtWgyhpy96S/j/qfNe9W7DBk8YVw+ROENDk+NJ8+kcOJ7uh3PEFmb1+ssSITs7pTZrVSxxB3QbCeCv/4OT/mp9iTsquagxhbBItOZ8RZnewP0/zuaIQ0/ejpLL/N8Z7KYt0F2T1jtZjjUSraXH2gUnUbyEPIX2LyA9hcINfFNipGDduhUGQiyxDpzO1cHNk6fVrz1drWm1Gcg0W3gyPf2mrci9u8ftzH8YRw83VBi3+84uZQjOQOgmmYHF9ogHR
 4P6SzoMw
 /PvtqV9QOntg+2vUqj5SBe3f4AHIGPyywaNDhdJZR3i2+11WIKp0y2OVzYgCsmLYm1TWR2zzFscdPRWscKm2WXXIu7T5KdW2MivE5Y5ZLFDFmODnijyN1TOIZIySPQoxqc53CHDvaBYSg/Ndj5M2YhuzAIkRBo9tujSt3VWUKOk0nAG30G64123Cuy+MOeTjnSQgq35n5/CWdfYqIrTXEwJ0auJ/Ssy/iYUOFAJN9lMWDAOVSUqH9V4DSJF1i3HuivseJybQTDWpOFmwvPFhGqODWVCxO/wLIgyCR/5I9joEfovXbyK6flr+nBw8U/qhloj1x2XYIyCEcBruNdT08BDzh7x8/wGYMdli06fAY2k07ly9+vCMRwTHlnPnf+5uFEqKlYaYUw2fiWEDPT9hhSIGLfXbizC9F/6TolF822pO0RvXio7t4XCrsAxhgK4Tf9FONyTaKp9p1OPvHAhghDSNsMYbog7/44DR+VzamrBb3Eiiv+82obMtY00992xL29y/xhwujgoEWlvzxRBP+3fsh50DARBkU53WQk2IWmueZX8vne09mA+6Vo4pknw/GsvB+TbIfwWOWkB4CEfVdNh9hUDGBSQY+WCfvPlcxDs17ho/Npm+vYPa5NYf57HLq2pV1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_no_kmem_bypass() needs to read
/sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
verify that compressed pages are charged to the memcg.

When running in an environment where debugfs is not mounted or
CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
loop to terminate early and report a false negative (KSFT_FAIL).

Selftests should not fail when if debugfs is unavailable, and it
should print a message when it is skipped.

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49b36ee791606..c4f7b66f1b206 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -566,12 +566,19 @@ static int test_no_kmem_bypass(const char *root)
 	int child_status;
 	char *test_group = NULL;
 	pid_t child_pid;
+	size_t stored_pages;
 
 	/* Read sys info and compute test values accordingly */
 	if (sysinfo(&sys_info) != 0)
 		return KSFT_FAIL;
-	if (sys_info.totalram > 5000000000)
+	if (sys_info.totalram > 5000000000) {
+		ksft_print_msg("requires less than 5000000000 total ram\n");
 		return KSFT_SKIP;
+	}
+	if (get_zswap_stored_pages(&stored_pages)) {
+		ksft_print_msg("debugfs at /sys/kernel/debug is required\n");
+		return KSFT_SKIP;
+	}
 	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
 			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	if (values == MAP_FAILED)
@@ -604,7 +611,6 @@ static int test_no_kmem_bypass(const char *root)
 	/* Try to wakeup kswapd and let it push child memory to zswap */
 	set_min_free_kb(min_free_kb_high);
 	for (int i = 0; i < 20; i++) {
-		size_t stored_pages;
 		char *trigger_allocation = malloc(trigger_allocation_size);
 
 		if (!trigger_allocation)
-- 
2.55.0.508.g3f0d502094-goog


