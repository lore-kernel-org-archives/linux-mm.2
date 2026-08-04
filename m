Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 619D5C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29B8B6B010E; Tue,  4 Aug 2026 10:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2729A6B0111; Tue,  4 Aug 2026 10:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 113E66B0113; Tue,  4 Aug 2026 10:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5C6B6B010E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:47:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75D26120135
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:18:33 +0000 (UTC)
X-FDA: 85063490106.11.E6E06FA
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	by imf30.hostedemail.com (Postfix) with ESMTP id BAFBD80012
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:18:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ugreen.com header.s=pkvm2402 header.b=pOBKJq+e;
	spf=pass (imf30.hostedemail.com: domain of warren.xiong@ugreen.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=warren.xiong@ugreen.com;
	dmarc=pass (policy=none) header.from=ugreen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785845910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=N+5x2O0AaXVTBFLcJOSpjdOEEsG7GciUWuhMJqvwAwI=;
	b=aM8o12KbMNjfQIaRV5eEo+apuecsKiK5djqbX67bU8RKjmtRIFb+aNaGTC2gGIW8CR/6lV
	8kqNMbkJV4kGmAQhTZhTc2iH4H62Zbp+8abshIvg2mcjhpHCsE+/hep6+Ic8F2x/Z6RVZb
	Io/DCcOtpi/gcfEbmgw0igrhy3jjBQc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ugreen.com header.s=pkvm2402 header.b=pOBKJq+e;
	spf=pass (imf30.hostedemail.com: domain of warren.xiong@ugreen.com designates 54.254.200.92 as permitted sender) smtp.mailfrom=warren.xiong@ugreen.com;
	dmarc=pass (policy=none) header.from=ugreen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785845910;
	b=nq/rtUk9DKI7x4ExWi2iYJ8EGFdsnWdRTOK2HQ7m2GjDiPLSacfixeTIeKw+efLo8535Td
	ez+LfiZvC9ElvuhK5PSZLN99z4UggEQ6q0hFfE/VLPYtuqMbUKn0rY5Vpx08glri+KVv9r
	HZTu2u33TzOffbAWQi0FkAdttRafI1A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ugreen.com;
	s=pkvm2402; t=1785845863;
	bh=N+5x2O0AaXVTBFLcJOSpjdOEEsG7GciUWuhMJqvwAwI=;
	h=From:To:Subject:Date:Message-Id;
	b=pOBKJq+ehAvshgC2NVJcF+ad+g6SSQk/NzFlJeVlCYbINbIYVD2EV+k852VdqX2m4
	 Bs7/NLDoPiklgXbTgpH+cJNKqU9wmlJXn18nYBFlNzh5+1lPdG9LWczMIUQNRyNYsj
	 I+5cpUIrn6tqToffbAKZEJZvBXGy4T46D3baVhpM=
X-QQ-mid: esmtpsz20t1785845853t7f5c10f7
X-QQ-Originating-IP: P3vIaFGclNI048NjNJM92lV3lMKWV/wY7CS5UTrKovc=
Received: from localhost.localdomain ( [113.98.201.214])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 04 Aug 2026 20:17:22 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 15148486447510069967
EX-QQ-RecipientCnt: 13
From: Warren Xiong <warren.xiong@ugreen.com>
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
	Warren Xiong <warren.xiong@ugreen.com>
Subject: [PATCH v2] selftests/mm: read memory information without popen
Date: Tue,  4 Aug 2026 20:16:58 +0800
Message-Id: <1785845818-3131-1-git-send-email-warren.xiong@ugreen.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1785720615-5826-1-git-send-email-warren.xiong@ugreen.com>
References: <1785720615-5826-1-git-send-email-warren.xiong@ugreen.com>
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:ugreen.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: N0LiquuQTBPGbvut7+gGg42CMggaO4zDxX6wZzL1FAngnus2iIxgeysR
	9iOPmmMKuXeEfXe9FdXqdMj1tncfA6vob4vNBQ8OW6d+ZBw7OeASRalgdiVIifo/396MUik
	logXuzG34U10qe0aJgIKiJXjq37cgi5KU+Z/1VhnqNoVeGA8Q9JK1pcznaPvmKNyOpf0IPt
	igCPD9vjM2C34E8CxYeUNcYosEkIju+W096HFB0Q02fv6GfalDyWGwPlDyC4MCkD0vPZY1X
	Q7sOjGTw/psxj21IdXtTwWx1Vq18CmEYsUv5RDE7DI7XKmMVMLdFiYcklXvNEdYCKkQ3HYD
	iVpQtHa0Eu2sFrwvhjUNw5Lg65573/AcUUzk26ze27uzvT+5+5m1DASvZYlL0u82I4jThdR
	YIv3T3OY6kS+dXBKMk49DI+VwMLhLKHZ2bd9tF1syAoiz54M6mROkdn5Bs8tXdM7Q7aDA7o
	ckCb9eSO9sVbdF/TmlH5BIpjurzj8W+YquQgu5Kuu8I+XPNPHMFRFUmbWGn4hINgZn0Dx6v
	RXWqUz/2MwU8k3uMrYuM9GYHaqzXxUb1x2d9PxZQM1/toCcfBBPjdaFFwrblbIhQ+8/M5mt
	FU9vUNv+X2AAv4K2MghdGhY21nguFSEfUdDtG5CqYJPPKpOWpFgusdDJ6FUgLVmQHZ4GDEj
	vUHTzehJ7rzgkbYJrInT2xQs3/jWx9Q+UmfRipE0kl7XrvLF9bIpxDlNxTzqaPRh+uKmFfA
	VKcjvlC8gRp3/PKviA9KNDQvlLVgpNfR0dwebT7x8WzsmMqfqfrYtWN1tTxlAHdjLySyl/L
	ncP92U92Wp7lcaJenS0psuvIBYl0H2OkylblJWj0snkSpxJyTsfsuXj/79xw1gf/Gp5Qmzy
	Xy79zP3pU0FU4FXZ0aIpYGeN0W1OONUl/mVl2HDTLbYLGzwY7feHv2+dwAUZwANjdUgXSF6
	jPdrR4khrJHk1a8BpIdjV02u/oSu5FqmsPqtqwdhGVL3feQCxjIdG1zT8hEBPIIUEPuxIG9
	1UAN95afU0wR8PIn6cz/D8je8PkiEuvObyndtM0bPWk39UkYwKGrXAqeDDbL1YYfF2iOvzC
	+1BLexMyzULp1vGEa8b46j2aiqchOV3Hg==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
X-QQ-RECHKSPAM: 0
X-Rspamd-Queue-Id: BAFBD80012
X-Stat-Signature: 4k7hbnfgadj1ajasr5nhmhyi5o6tpdbo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1785845909-76016
X-HE-Meta: U2FsdGVkX18myUmGblTlzBisoVMgL/oc19r6300SoWEadDZN3jHIq4TihY5P5pC1GJVmBRQwOusCi0MjQED24O4ONJDFV4hOy2hFWrUpwNnubSyrlQHzn3B5uHgbvj3HQbOFExEp4Pd60Fdb7TXYuLt94sITcBQKrZOxrnxDvk1yAcslGMfrJPcMqxcgDjMyBTVT5NIWxe3PcU93P+CYcAjekApaYfSUOekLbks524PSOhvV3aE6zjf7IN1t8Z5RkN4TPO51DUi8Xd4yVckL7bKiO26vRFrIXW4e+nFbaWIAL3m4qgnjVZ57xYAthEI4zOuHFOXOsvXNdOl7//eml+i/EtEAW1VCP7DpejCbSj1op8cb3HjuMZxI77WfpG45bWcaurvq8AGgXRaDZbMT+b2Cvn6XJ4E+TuhBfQr1n9LMCZDPbadGMOE4fQfB1xQrKwZPR6oQW6y2G3uzRO8WaqN4NcyH9vtsjI3JEfAE50LJ077aoImTsliAhv9cn9vZCm071UgmLK485ocv2la1ASK1voO9koDF9xPhm7ojHVWP76MZAj/oll/r4z+KkxvCDifkPAHuCmhdI6KHe2g63uYTotbEPLFH46dKWHbdkQSdWNffJJRCk36P5ExQQF0+GP5oNbt/20wwaBBWmKtChGJz14PETFCxDfVQT2+UNVxVNICpUu5PrIvr1jaL2cI3bjkplTYmh2O6ZoLYwa3ffAHIWqUwxy1GnbdhWIFhlAwbnDCwByxaA6UQamwLqO0dcE8IqJwzBTR2w4goOcA1CaUenUtFFqfxaFoxfI/eYyZSkmQnGxn8wqKR+3h/b2IMROmJPPH343NchUt3SzZgx2w3QQ+1GqApK9LDduEhVOlN1e9OjWWhHqKzhJURm7Ug5uMNIY8p0Pn5tr5U46nK41EtGHIuJ4u8u1esX1d7+c42tWM1M8BLPOwPZLbS0x991E91ozNiWsBwPCDKQab
 sS39L9qE
 W774En8ueNFHsdYe4zQN7ZKAnVLoI1n7aPsidO57X08nR2KE2SR/UAsNGKgY7NVjSf78/rjmf9PzKcQg97EXhnDDEnTMdSzRuR0beK3RygM0u3o1qtAR8mZWN3UwhZpAc2myyjnCmRSydd/pTllfO5xmyY0wJl6sLScIfyPNFJt0cPdco1ziesgEJacv2scPfYpM2e2VM+IoEw5VGM76u6SyH2NPXAkhAIzk6ltOuJX9CT/wVJQFF0VM8CBVD2k26cqI2zgJbVX4mz+oU5hUY8h8HIBq90rVAiVzgpsBSQl9S0wdm2lynsz+mqCjJZktu6bpM5Ucw/QLkrhAUz9TXjJzQhYTPb9zVqmr7EAjsdYKb/40=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

read_memory_info() invokes two shell pipelines to obtain MemFree and
Hugepagesize from /proc/meminfo. It does not check whether popen()
returns NULL before passing the result to fgets(), and it does not call
pclose() when fgets() fails.

Open /proc/meminfo directly and obtain both values in a single pass.
This removes the unchecked NULL path, closes the file on all paths, and
avoids dependencies on external commands.

The compaction test continues to pass after this change.

Signed-off-by: Warren Xiong <warren.xiong@ugreen.com>
---
Changes in v2:
- Replace the two boolean flags with a hit counter, as suggested by
  David Hildenbrand.

v1: https://lore.kernel.org/1785720615-5826-1-git-send-email-warren.xiong@ugreen.com/

 tools/testing/selftests/mm/compaction_test.c | 38 +++++++++++++++-------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index 5b58258..30d4ace 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -29,30 +29,34 @@ struct map_list {
 
 int read_memory_info(unsigned long *memfree, unsigned long *hugepagesize)
 {
-	char  buffer[256] = {0};
-	char *cmd = "cat /proc/meminfo | grep -i memfree | grep -o '[0-9]*'";
-	FILE *cmdfile = popen(cmd, "r");
+	char buffer[256];
+	int found = 0;
+	FILE *file;
+	int ret = -1;
 
-	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
-		ksft_print_msg("Failed to read meminfo: %s\n", strerror(errno));
+	file = fopen("/proc/meminfo", "r");
+	if (!file) {
+		ksft_print_msg("Failed to open /proc/meminfo: %s\n",
+			       strerror(errno));
 		return -1;
 	}
 
-	pclose(cmdfile);
-
-	*memfree = atoll(buffer);
-	cmd = "cat /proc/meminfo | grep -i hugepagesize | grep -o '[0-9]*'";
-	cmdfile = popen(cmd, "r");
-
-	if (!(fgets(buffer, sizeof(buffer), cmdfile))) {
-		ksft_print_msg("Failed to read meminfo: %s\n", strerror(errno));
-		return -1;
+	while (fgets(buffer, sizeof(buffer), file) && found != 2) {
+		if (sscanf(buffer, "MemFree: %lu kB", memfree) == 1 ||
+		    sscanf(buffer, "Hugepagesize: %lu kB", hugepagesize) == 1)
+			found++;
 	}
 
-	pclose(cmdfile);
-	*hugepagesize = atoll(buffer);
+	if (ferror(file))
+		ksft_print_msg("Failed to read /proc/meminfo: %s\n",
+			       strerror(errno));
+	else if (found != 2)
+		ksft_print_msg("Failed to parse /proc/meminfo\n");
+	else
+		ret = 0;
 
-	return 0;
+	fclose(file);
+	return ret;
 }
 
 int prereq(void)
-- 
2.7.4

