Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9FFDCD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:33:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33A8E6B0096; Fri, 29 May 2026 10:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C37D6B0098; Fri, 29 May 2026 10:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13DC36B0099; Fri, 29 May 2026 10:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F19336B0096
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:33:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD9B6160C3A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:33:32 +0000 (UTC)
X-FDA: 84820700664.23.898773F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2DAA62000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:33:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DafaDXjj;
	spf=pass (imf13.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780065211; a=rsa-sha256;
	cv=none;
	b=BhE/JFAbGxJdJuCABn/irEJaFdE9THfbZtX0/ztJinKqWls+OlFlTIYEq+XT0EBYyZv34W
	NP6XK6YPaKUiGVZIwf4gNgEj6xkwzdYOOqZH8Jm96z1+fxl67KtTBQp8NF3eWJHD2XM61q
	QNcVAlVrpv8iy2IFodqBuSKSRYLgRjg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DafaDXjj;
	spf=pass (imf13.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780065211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vyAIkWzZgGB6LrCF6zuZOLFTfkZ2Yg44+ju3GGAi4XQ=;
	b=vnnP6pBvNOjTZgu0U6mw/zNsFf4TdCYyCilYyP4qe5WZZklhs32wbqsTu1r7M6cvZL5RPd
	jCBiUJX1VUn1UOoqtPu5MFpH8b9CYkdUiTI+NdT5XdYS1zNF1DeH1rLmc4dnIx7n3pzZZM
	hKjoGkYsq8XBEDv3WM0zQlrGba7QTQE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780065209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vyAIkWzZgGB6LrCF6zuZOLFTfkZ2Yg44+ju3GGAi4XQ=;
	b=DafaDXjjSeXGtjcjH2mCT9Xli+n/rYnZ0YEXjHK9TESaf44ilrrY9qDK2pVPBNOUC6X2W8
	r5hjtFAUjrfNCw94N3YpQ0/74WSpfZLeHgojtLEPfX3phj3XxYiJg061ipNs57HTx5U1YJ
	+aJMEBCCPHZRhAQq1vkm8Fe0d7cADrw=
From: George Guo <dongtai.guo@linux.dev>
To: Huacai Chen <chenhuacai@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Alexander Graf <graf@amazon.com>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH v2 4/4] selftests/kho: handle QEMU not exiting after kexec on LoongArch
Date: Fri, 29 May 2026 22:32:38 +0800
Message-Id: <20260529143238.169169-5-dongtai.guo@linux.dev>
In-Reply-To: <20260529143238.169169-1-dongtai.guo@linux.dev>
References: <20260529143238.169169-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DAA62000F
X-Rspamd-Server: rspam03
X-Stat-Signature: jm5e4srrafs3ahwpn4rc6fc7stqgryp7
X-HE-Tag: 1780065211-364186
X-HE-Meta: U2FsdGVkX19zjQpUzjhL9utpERi2bXrxcVRdaVwCQo8Ruvle77bID4R4kzAw6ttpYSduTR77gLb08knDEH8DHgKDGx9/RcVISCIfJtdlTGEZLT2P5pCYCftoI5Oupewc3bkn6kPuW5yhMAVU9U9dMA0Q45qa2yw+Gv5MoaRxSnpM9psWJmlePoZQuQzkKFV3BygSBREaicVe1vHBKehM3p+wDvugrvIeEeLoMAgdLQwxaXwKVfy47/889l2RFY3iUD7HiPNhSu7hymikFm6LcuXR8H8GiE03MNNTCGjrzbWG32FJE+BcjnG5YsooScmNWM5gK/9FzAqT6ayKgwMdH/eRrVTPxB3p+FxPXx/tuNZXw0BYngayEPdQSNSzOawkyfctWM4v7bO53mOwVSMvMANp7RzpEbI5P8xy8PQ4mm7oEbaB6mVq6rTa47bbrjlCDks4ez75kva9c4jjF69yWFj1HhgyPZ6vSK7W9x+2/6jykPGQpsuL4X0Vl2Ekb9OXLVTcy7oesqeZhoRaeiYTZzTYM8zYElmyCey1UnOUCIo2s9mk95fTMczZF1puDyRWJb8+BfscVKqTaz9d40u0rLcHTK7YHi0QLr5tSsEInIsBT9xBeokZBbrakC7z6mvQ2I3zMcY9O5n6bEZypEPet9uhtD923WA21ihYPpkhSbVUtu55iPx0AgdhaW6fE8ql1okdGC9sbkaHT7gTfcoi5qUWIoX4o+rAtr6eCT2NxlFdGfBPJ/pA9lOdks+tmyIhpEMYKJ50yrkixDMzyJzo7jJnn6FQojmCNxX/sd11s5yEf9r5acg7bXCrwLmA9zCl5rWg6gGykr6z0IAj09GBVwPpgzyzvXP9bI3whuYTpE+Qmp/kUFoiDftSttlm9NOjOhKXrjtyYv4/10+k1ppdAOgLtW+/EwlYb6xU1Dl4fLNiqj8mSDPhrEN0WE3grpjw0o283U9g2MWkzmE9c6d
 aDNAiKb1
 Wfk5Nh0vXTzzicg0qeusq1o2hU7hYaoTHq/4LCbFTFbRxT65nfsSMS6IQmfdafZXpFwBlKAy55x6i1PRFxU+z44U8U5GfIqlDJCromNJMpoUTwi4rlH4uh0OIs1fvPo5TGrmFmvvqqZGJ2VanceQssfCur6gVatmyq37TemMQh9VsAz65Mkq6TlEUboQmBXSXh6/ayq/ZSKa9LCHKxzf69gbFb/yNA9y5gAq6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

On LoongArch, QEMU provides only a minimal EFI stub with no runtime
services and no ACPI tables, so machine_restart() falls through to
its infinite idle loop and QEMU never exits after kexec.  The test
result is already printed to the serial console and vmtest.sh reports
success, but the user must press Ctrl+C to get the prompt back.

Add QEMU_NEEDS_KILL=1 to loongarch.conf so the test completes
unattended.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 tools/testing/selftests/kho/loongarch.conf |  3 ++
 tools/testing/selftests/kho/vmtest.sh      | 32 ++++++++++++++++++----
 2 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kho/loongarch.conf b/tools/testing/selftests/kho/loongarch.conf
index 0145cb49e5b2..02a6add633f1 100644
--- a/tools/testing/selftests/kho/loongarch.conf
+++ b/tools/testing/selftests/kho/loongarch.conf
@@ -8,3 +8,6 @@ CONFIG_SERIAL_8250_CONSOLE=y
 "
 KERNEL_IMAGE="vmlinux.efi"
 KERNEL_CMDLINE="console=ttyS0 earlycon"
+# QEMU never exits after kexec on LoongArch (no EFI runtime services),
+# so vmtest.sh must kill it once the test verdict appears.
+QEMU_NEEDS_KILL=1
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index a6ae9ac09595..821e13fa69a5 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -107,12 +107,32 @@ function run_qemu() {
 
 	cmdline="$cmdline kho=on panic=-1"
 
-	$qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults \
-		  -accel kvm -accel hvf -accel tcg  \
-		  -serial file:"$serial" \
-		  -append "$cmdline" \
-		  -kernel "$kernel" \
-		  -initrd "$initrd"
+	local qemu_args=(
+		-m 1G -smp 2 -no-reboot -nographic -nodefaults
+		-accel kvm -accel hvf -accel tcg
+		-serial file:"$serial"
+		-append "$cmdline"
+		-kernel "$kernel"
+		-initrd "$initrd"
+	)
+
+	# If the target does not exit QEMU after kexec (e.g. no EFI runtime
+	# services), the conf file sets QEMU_NEEDS_KILL=1.  Run QEMU in the
+	# background, poll for the test verdict, then kill it.
+	if [[ "${QEMU_NEEDS_KILL:-0}" == "1" ]]; then
+		$qemu_cmd "${qemu_args[@]}" &
+		local qemu_pid=$!
+		local remaining=100
+		while ((remaining-- > 0)); do
+			grep -q "KHO restore succeeded\|KHO restore failed" \
+				"$serial" 2>/dev/null && break
+			sleep 1
+		done
+		kill "$qemu_pid" 2>/dev/null
+		wait "$qemu_pid" 2>/dev/null || true
+	else
+		$qemu_cmd "${qemu_args[@]}"
+	fi
 
 	grep "KHO restore succeeded" "$serial" &> /dev/null || fail "KHO failed"
 }
-- 
2.25.1


