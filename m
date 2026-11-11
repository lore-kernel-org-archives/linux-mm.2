Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53BE3606A33E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=SiGkmjjE
Received: by kanga.kvack.org (Postfix)
	id 6B1226B05C2; Wed, 11 Nov 2026 02:53:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688776B05C4; Wed, 11 Nov 2026 02:53:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550506B05C5; Wed, 11 Nov 2026 02:53:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2076B05C2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:53:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B3E3C1401FC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:52 +0000 (UTC)
X-FDA: 85422074304.11.2229402
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id CA667140005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=SiGkmjjE;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383630;
	b=GhCs9r/nRNIZ/9aCj1pZCC/X0sTlBDLbmnMIPYBTLURmP6ZRfDa+rzgSda3JhBhJmHDQlm
	/tBlxWvNL8rVfCIX1vjN5FDAZTFe51H0fL3Xbw7R0VmwRQy122fGXVJtlH+tVm63Nr9GAz
	6ztzCf039+zO/d5aAUB3tSCanR1NhzM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=SiGkmjjE;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSI9syxLw5WcjFuLZ1glFarNni2XFz8U30mQtyysmWI=;
	b=an0Rnfw65kOY5Jc8Nea/m2L9eEDelGOaff0/AC/+LOGN4Je3ivSxxUwrfbgwMkhIGlbw+O
	6iWmQFiPo2IBi4CbwXlhhPDlw4Q9EhGZ80f/4w8WWj7K6L1B41sWvN+u4vL+9kYdg4gs2v
	ixPAcBJ6TfYeIIy9v8kVC0PbxbeO79E=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cdab8873d9dso1241124a12.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794383629; x=1794988429; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=SSI9syxLw5WcjFuLZ1glFarNni2XFz8U30mQtyysmWI=;
        b=SiGkmjjEVul5uwO3tPlYDuevS20I6GbwGWfFdJBmGhThvgqs5lHjnjZpcHpiFIgd50
         rj0fACV572c+JhsDipi95aNWq3GdjrzIPfIZXVElt3WkjTcyvVgt4o264gh1IVoIFzSp
         XItedDXrCIRjZusdGoxCKxfEU132g4V7qYgpA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794383629; x=1794988429;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SSI9syxLw5WcjFuLZ1glFarNni2XFz8U30mQtyysmWI=;
        b=XkmWKZ19+nuK4cT6PFEjBnSHUrzmd0s3UhJ3bUC4jxONhnqR+HcsKfpP/gvOMZ3jGn
         WgU+ZYMQ7Q0eeHpKkn6rBP0Gj+CB9z/nBQvwfoW9IhS9kybe8vFZXjMpmS0bF6CYGIde
         V9YO+JQtr9u5nAA2lugAGTVIr3+NF81AgOvofNLdiiwVEQ+p9Se5ktWtcgsJHYZgv2Zq
         2YAhl6pUFT474ySBvh09Op5NX/6mb0O94J8sidn5JHr9JJMj4XWGGX9NYPXAMEmvdo+R
         i672XriUsylP0md0Fe1dSMBiYtbL6x7GdHOeLJG8YWw69aG6MX/eBvNL1ixOYKXdI1El
         28kw==
X-Forwarded-Encrypted: i=1; AL+hErF93z088BBsXf9ZEUCZXP/JAdRKOS/v/wtXFJTLiHV5O/i3hLjMBxRXvZ4fJ2VJR9Oew7PUE6YGTA==@kvack.org
X-Gm-Message-State: APuU4Z92l3D49Pv5niUZ61GM3wmUpUKjhtH7S07c8vkpjDtmC9zpEbG1
	cwmo0ePfkTHWlFkI07BeqRmGVQcPJGFmy0m2UYXa6l4HWCPe/x30XCZ+5HDduqt6avg=
X-Gm-Gg: AYBFou1ZW1Kb8wzZcDy/OjoPKKtGxBD0YbC4R6HYEmwEFlSHYslFA+RqYXsDqcwyPhg
	lDJr8/mtU5WZflLVeaKY6ChqbH7S8fHEp6n8qYnfQlT7RY5OzVt6wLMy8yGrYdlZj+MzHZ7FF1c
	oXMHnuOdJfK8v7IgpLxNu7+V4v1TtEd9JVnpVsaVR2TvBEMqgPH2wp2t3U5KOxx4GJ9prE/OGlm
	Gb5vWKc8sB4aLNoVHUBoI2EvvrCOlVJIjm6ZpSb12xk8FE3BpDT22NDVmjgLhoc5bFGpPUz2L2e
	halx3GUOplWxKh+Zle5/xZ6dhiALTXdFFOevvAThfWLHumipwFpgLHD+rFmwsYynfp5l4q4U6Mw
	/8o5FKD1YZhSwrRkFMhvWPL9VMTuN1/W3TTc7uv9BEiYS36egsd0/wTbnMOZPjbTliisc6tMkKY
	xDoh9j7m6li5em+Jn0NAg2uq8lvZkB2sjML3F4KxCHMY0X38Gsgu01Mjq5cN0cSlhgyq/Iro+FX
	Pf1qyaFa5ZVi8lLmNsMpA5l/a2v2JVT6cnAgFYSZb20BBYmGFMPozX+DrW89wh2fez9Cx48zynG
	ElY/h35+P5E87O585Jbvt+vE1vu6COqY2k3r8qWwEB2NqDmcrIPWgDCLzGFHuIViz44BrTxBavt
	Ml/YZr7Szjo6NrHlen1t17Hk8S8jcdVcRzgtWv7Dt9CxXoaCwuLya5Qy4AuuyzK+yxk3fwVZFb7
	Zuk3Zpdq6AWcdR8QsnfNqCKX3WhyKkHbWPzx0EzP+JnICruUgurGe0
X-Received: by 2002:a17:90b:5483:b0:3ac:80dc:f419 with SMTP id 98e67ed59e1d1-3b182fb308emr1835511a91.25.1794383629583;
        Tue, 10 Nov 2026 23:53:49 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17da4cd8csm3404966a91.2.2026.11.10.23.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 23:53:49 -0800 (PST)
Date: Tue, 10 Nov 2026 23:53:45 -0800
From: Chris Down <chris@chrisdown.name>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 9/9] selftests/liveupdate: Check handover revival, sequence
 and memory stats
Message-ID: <738fbfd19034ce495de9b22c705a7815a236907d.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794383544.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA667140005
X-Stat-Signature: n5fur8ym7g3675hbm5bagtkynhrg7ng7
X-Rspam-User: 
X-HE-Tag: 1794383630-578663
X-HE-Meta: U2FsdGVkX18iPpN8BFtYx7E1iYPUy7LfhLAFj09Yfzv1tjNDS4Cl7qDfpo7AFKTAKGf7/vgeoE+6Ofp4G5JPhVlx5VpmA0E00QQm8g2/nO6W1BAr0scYm87asnvBazE2jlh9sbNm3D7NNsWSw3nLraAdxChsBg554MXuQoeLQZ1dixoAKXlWyXrVy19iNo3DNZxKNEhWAOh1H530jkv/dVQWWlDq2aQUsB+uB1Ff+8Jfj3DXkLJZOtom3PX/cWZbJvjKpiSWeqWMGGyNIBPKaO+R1lguRxamqVDVSVovk7aUh8gu00/uvfDynBzYpkhlUDCPrw1IGx1HmjECUnLxvk8tR9ZOo2TmPNh8hZ+4tt4JOeOJyZDKx2TxZxMG2VhXu+tq2uW6fgL9/Mo1SKom0scu7g2fmNUB4pZkApoGgrXE9Kgd3oIONFm4sUKS9RJKt3n1Jd5ZgywSAZ591JHNALfnlusPKD5mcDGe04I+TtADN0uqC8HgOMNbzfJBx/6GoKJZd9UrvWPo7XzWyzkkx9GUaLtLVHckSgEIvztKslAtieXl1grsJCv3Pzffl+ijUNrpmNyq4dmNi67I3HDB8zO9NkHjEKu3RrRpM7PP/C2dj+DULgDFMOzGCts7pOyJxfcLqGthOJtrXKzQh+dYdQ3A8/pywQYKMNRaNNWQTUXkZ5vh5f10sjaUghu5xkQXlvDwqsTTPjSbXRzFS8uJ6+PLL1J7IDbf1gQG1ahmUBeAeYLzWT6g4yy7suzNaTdBuaocfywp5V3K3aC8pbFCk5XGlvpZfwgCnxBed8W/4nZ8mqBM4qTPjQjUU69hIQgtWI/YQE8z0o2BP094OdIRhaYvjjyOVB9V1byY0BBfhF9AAPwTJb/9T1rokeGwASbjrTGicZGFYJ0S1SiL47qM2KNXt/s5oo8XSZHSvbvM6xttzYCcpgkqOX307HZ+TDtZX33qUgyVzXMd67ok1ez
 ju5R7Cwk
 yolv8ljEP/4J7u+4qH0RuWd0Xkfc+2n2AE1p9wYSuM3+VHbG7kM8lQSrkHF/fETaJGWWHl/TGQqfbTVk8BligauglNs42dbw6pEM3zQD2lnGwfEdaRhGtVZTRkcBnavyKj2fpDgFcjlFlYsiO2uipyq5uoWSLPIdyk8Djj8LiMq8hw/GpoTNKkzUwkNcpBoYwQJz8CGPDjEJzsEckh5+EWk5Z5hPoqI7S5d6xiPxdiqb21bwJwoWVlgGDLshftKZ/ZXHZeXH+niaEq5yI5B7ySrmfgmE/HiYfsjKB2160lD4xsASRCxpU+ks9DGf8GbAGgJY9FQwix29fdsn3SMoUAwip1PxaPOZ7DZS+cnPDYwj/+tfVMLmT/qCf2wHVva4XYS2FMtcTQnHme0B6G/+h+aaCpZOZEyKBsRtR0Glu71b13h09BvHys1JOfxaTSiGFaN6nDBOzFcDDkPoajKP0o57+1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend the handover stats test to cover the new files. On the first
boot, kho_incoming/state should be none, liveupdate_num 0, and both KHO
sizes 0. After the kexec, the handover should be revived and
liveupdate_num should be 1.

restored_size should grow by at least a page each time a memfd is
retrieved or dropped. The memfd in the unclaimed session is retrieved
last, once everything else is done.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../selftests/liveupdate/luo_handover_stats.c | 74 +++++++++++++++++--
 1 file changed, 67 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/luo_handover_stats.c b/tools/testing/selftests/liveupdate/luo_handover_stats.c
index f18df79dda55..2863630b823e 100644
--- a/tools/testing/selftests/liveupdate/luo_handover_stats.c
+++ b/tools/testing/selftests/liveupdate/luo_handover_stats.c
@@ -10,6 +10,7 @@
 #include <libliveupdate.h>
 
 #define INCOMING_DIR "/sys/class/misc/liveupdate/incoming/"
+#define KHO_INCOMING_DIR "/sys/kernel/kexec/kho_incoming/"
 
 #define SESSION_CLAIMED "stats-claimed"
 #define SESSION_UNCLAIMED "stats-unclaimed"
@@ -28,13 +29,13 @@
 /* The first open starts deserialization. */
 static char state_before_open[16];
 
-static void read_incoming(const char *name, char *buf, size_t len)
+static void read_sysfs(const char *dir, const char *name, char *buf, size_t len)
 {
 	char path[128];
 	ssize_t n;
 	int fd;
 
-	snprintf(path, sizeof(path), INCOMING_DIR "%s", name);
+	snprintf(path, sizeof(path), "%s%s", dir, name);
 	fd = open(path, O_RDONLY);
 	if (fd < 0)
 		fail_exit("open %s", path);
@@ -54,6 +55,11 @@ static void read_incoming(const char *name, char *buf, size_t len)
 		buf[n - 1] = '\0';
 }
 
+static void read_incoming(const char *name, char *buf, size_t len)
+{
+	read_sysfs(INCOMING_DIR, name, buf, len);
+}
+
 static void expect_state(const char *state, const char *expected)
 {
 	if (strcmp(state, expected))
@@ -61,13 +67,13 @@ static void expect_state(const char *state, const char *expected)
 				   expected);
 }
 
-static unsigned long long read_number(const char *name)
+static unsigned long long read_number(const char *dir, const char *name)
 {
 	unsigned long long val = 0;
 	char buf[32];
 	char *p;
 
-	read_incoming(name, buf, sizeof(buf));
+	read_sysfs(dir, name, buf, sizeof(buf));
 	for (p = buf; *p >= '0' && *p <= '9'; p++) {
 		if (val > (ULLONG_MAX - (*p - '0')) / 10)
 			break;
@@ -75,19 +81,45 @@ static unsigned long long read_number(const char *name)
 	}
 	if (p == buf || *p)
 		ksft_exit_fail_msg("%s%s reads '%s', not a 64-bit unsigned number\n",
-				   INCOMING_DIR, name, buf);
+				   dir, name, buf);
 	return val;
 }
 
 static void expect_count(const char *name, unsigned long long expected)
 {
-	unsigned long long val = read_number(name);
+	unsigned long long val = read_number(INCOMING_DIR, name);
 
 	if (val != expected)
 		ksft_exit_fail_msg("%s is %llu, expected %llu\n", name, val,
 				   expected);
 }
 
+static void expect_kho_state(const char *expected)
+{
+	char state[16];
+
+	read_sysfs(KHO_INCOMING_DIR, "state", state, sizeof(state));
+	if (strcmp(state, expected))
+		ksft_exit_fail_msg("kho_incoming/state is '%s', expected '%s'\n",
+				   state, expected);
+}
+
+static unsigned long long kho_size(const char *name)
+{
+	return read_number(KHO_INCOMING_DIR, name);
+}
+
+static unsigned long long expect_more_restored(unsigned long long prev)
+{
+	unsigned long long restored = kho_size("restored_size");
+
+	if (restored < prev + getpagesize() ||
+	    restored > kho_size("preserved_size"))
+		ksft_exit_fail_msg("restored_size went from %llu to %llu\n",
+				   prev, restored);
+	return restored;
+}
+
 static void expect_counts(long retrieved, long dropped)
 {
 	char state[16];
@@ -111,6 +143,10 @@ static void run_stage_1(int luo_fd)
 	expect_state(state_before_open, "none");
 	expect_count("sessions", 0);
 	expect_count("files", 0);
+	expect_count("liveupdate_num", 0);
+	expect_kho_state("none");
+	if (kho_size("preserved_size") || kho_size("restored_size"))
+		ksft_exit_fail_msg("KHO sizes aren't 0 on a cold boot\n");
 
 	create_state_file(luo_fd, STATE_SESSION_NAME, STATE_MEMFD_TOKEN, 2);
 
@@ -144,11 +180,16 @@ static void run_stage_1(int luo_fd)
 
 static void run_stage_2(int luo_fd, int state_session_fd)
 {
-	int claimed_fd, mfd, stage;
+	int claimed_fd, unclaimed_fd, mfd, stage;
+	unsigned long long restored;
 
 	ksft_print_msg("[STAGE 2] Checking state before and after the first open...\n");
 	expect_state(state_before_open, "pending");
 	expect_counts(0, 0);
+	expect_count("liveupdate_num", 1);
+	expect_kho_state("revived");
+	if (!kho_size("preserved_size"))
+		ksft_exit_fail_msg("kho_incoming/preserved_size is 0\n");
 
 	restore_and_read_stage(state_session_fd, STATE_MEMFD_TOKEN, &stage);
 	if (stage != 2)
@@ -163,6 +204,7 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 	if (claimed_fd < 0)
 		fail_exit("luo_retrieve_session for '%s'", SESSION_CLAIMED);
 
+	restored = kho_size("restored_size");
 	mfd = restore_and_verify_memfd(claimed_fd, MFD_RETRIEVED_TOKEN,
 				       MFD_RETRIEVED_DATA);
 	if (mfd < 0)
@@ -170,6 +212,7 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 			  MFD_RETRIEVED_TOKEN);
 	close(mfd);
 	expect_counts(2, 0);
+	restored = expect_more_restored(restored);
 
 	ksft_print_msg("[STAGE 2] Finishing '%s'...\n", SESSION_CLAIMED);
 	if (luo_session_finish(claimed_fd) < 0)
@@ -177,6 +220,7 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 	close(claimed_fd);
 
 	expect_counts(2, 1);
+	expect_more_restored(restored);
 
 	ksft_print_msg("[STAGE 2] Finishing the state session...\n");
 	if (luo_session_finish(state_session_fd) < 0)
@@ -185,6 +229,22 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 
 	/* Finishing the state session must not drop anything. */
 	expect_counts(2, 1);
+	restored = kho_size("restored_size");
+
+	ksft_print_msg("[STAGE 2] Retrieving the memfd in '%s'...\n",
+		       SESSION_UNCLAIMED);
+	unclaimed_fd = luo_retrieve_session(luo_fd, SESSION_UNCLAIMED);
+	if (unclaimed_fd < 0)
+		fail_exit("luo_retrieve_session for '%s'", SESSION_UNCLAIMED);
+	mfd = restore_and_verify_memfd(unclaimed_fd, MFD_UNCLAIMED_TOKEN,
+				       MFD_UNCLAIMED_DATA);
+	if (mfd < 0)
+		fail_exit("restore_and_verify_memfd for token %#x",
+			  MFD_UNCLAIMED_TOKEN);
+	close(mfd);
+	close(unclaimed_fd);
+	expect_counts(3, 1);
+	expect_more_restored(restored);
 
 	ksft_print_msg("\n--- HANDOVER STATS TEST PASSED ---\n");
 }
-- 
2.54.0


