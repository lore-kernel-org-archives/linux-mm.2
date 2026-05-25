Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90CE0CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C726B00A0; Mon, 25 May 2026 02:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0544B6B00A1; Mon, 25 May 2026 02:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3BB6B00A2; Mon, 25 May 2026 02:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF0296B00A0
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:28:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A82DB140129
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:43 +0000 (UTC)
X-FDA: 84804963726.18.94818EA
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf15.hostedemail.com (Postfix) with ESMTP id 20AEBA0007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tapMzdVl;
	spf=pass (imf15.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779690522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYxwosLkp+8p8G15z4kXkSPo4todC1a7rfK+baWf0Ng=;
	b=bhxKmdlNoP8vk0u19Qxb2vkBL5/uoMm03gb1EvlVtbYXGD6Dj/r+W4UNxiTiI8sct6IzOx
	s/1YFqc3/BdT15c09Uxe7zcKRvDZCXxN61eBHnmiAIYEtFUmzr0yVPOCzsy9863QIj5HWe
	Ha7hMLc/u/vvhKdcmWNnxEIYWeWdy7s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tapMzdVl;
	spf=pass (imf15.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779690522; a=rsa-sha256;
	cv=none;
	b=uyfZXoVJ1fH1BohSz85gE5guo+PonYRX1MqG7V3iSBbBqw1WdBtXSHdWrMQUHon0CQdsmQ
	PswDZvN5IjTqZHvTFVyF3unsM5PxktywqSyXv1hokFIDJb4ZRrR44syj1Q0nZa7cHpPPPx
	gWCDtPJRK8eELPVYm/T9mDYrjWn9MBc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779690520;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tYxwosLkp+8p8G15z4kXkSPo4todC1a7rfK+baWf0Ng=;
	b=tapMzdVlPtDDpbGp9ExBzdrIWJd5Y2uo8fnGLvCqnWZtlCYloM8DKKodK5W+vk8n8kh2zT
	bfsvelwOgxjow3PTKnfGN1YfC+4DEJwagn4PVMZlpiRhbPSa+9NbkpAWv3FaTpceQHBKZy
	McUhOyUC4DTF/o7X/PEECcln0mOrJ/Y=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: kernel@xen0n.name,
	graf@amazon.com,
	shuah@kernel.org,
	loongarch@lists.linux.dev,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>
Subject: [PATCH 7/7] selftests/kho: handle QEMU not exiting after kexec on LoongArch
Date: Mon, 25 May 2026 14:28:10 +0800
Message-Id: <20260525062810.103367-8-dongtai.guo@linux.dev>
In-Reply-To: <20260525062810.103367-1-dongtai.guo@linux.dev>
References: <20260525062810.103367-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 20AEBA0007
X-Stat-Signature: yw5gi4tyi83m4aup87ns4due9eqj8krw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779690521-569543
X-HE-Meta: U2FsdGVkX1/hvlIWTK2fBv49mfX2HekWcDujxOU40GkM55Vk5fxDRtzi6RcC0MC43B5zD9xm/0d2ZaVwvElugHp/fB1kjNV4BReZbj6KVcTSuN9k9k0teO1eMMwgrbplLUXEBaNcOhGuEweOHx572bvkzpRPz2m1W/dONHT/JHpFAI4Dscz3MtkEFvfpvqpcxyqyOOG8NDua9b8nH7oBa6chCkhgkOpKerw8ILeslP+sQdYOrLE8/I3QH9CD7NYE5Ls/yWoQNNJ/oF9bXywMnsRTusK10u64TQYcFJViL/VKV5fhw/U+qZ/F39VWaxJplQTHtXoDQgINLaPDbIa6WdVDdsv5adTjIGJDO0UM8//GeCQa4kkZ03GRmlhJ4mIQWHOnGE2szNKupJaz+62i80r0icO2Wh4yxzctnL2/++QFo3L01J1BRzdPkCG+SY4ThJlE0Fr/5vzXArnvX6XrQAY/sIA3VnvXyz5bECQ3VQN/3wVgq/fo4z36l1F/gFDOSxX5UVsq7u8zUm0hCK1QqT8LBRL9SLVViz4aYg1XmUm96adKn15FNfwUMrQRelMoRgSF+iwyiFPHQBi8rccfFOwJKhbxEPG6+blRsN3+1hd+3paOlQLH48gy0gcHifyLJ6Fo/PVzL6O3f/bvRuJbS23Ja1fg7H1sPNd9Yu4mswx53mbQrCJSYqYk7WeByfbQ+qUy4jyJ17PHIdX5EEWKDcJPxoPb2t/ePUfBajpc3lDJsZOyDd/S0Y3demqdG5c1DKI5fGkGeUNgzpTPSoFkUB+bINga/A4+VZdvYQ3LP8e0MVA11dienM5ZGSWuRzwjqQWoO9dQUYNo6aRyOaCpzPBDQr60fY/J0Bwd8NmCTGb1PGGPQOqnXrPeXRt9lRtjxPymIUGBagNYPGZDG5Iae6YkV4fobwgnYjnEZ8lBo8s79eN2Ajcds1ItTJ5g97B55HWt4CTYL+WXQxyK2bn
 wfb27A7+
 hYFBMuDDh87saI/GAqHUslVtaKM8Hg88okJ1xg8Aboe8lipZEZbM1+sq8h259ke4KJNMmm5X64DivAbRipunEuo+HpmtY2nFEbyWXNQ4Ez1ufWWZYvBq+uOEvVCrGfog7HgH4frM2n7y2U7ik2e6GTrj6MAuFixAOUVBx8iOLUBhqJMDdYdvVAlGw7/q+3NjrDis9i1cdP6hCoRA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

On LoongArch, QEMU provides only a minimal EFI stub with no runtime
services and no ACPI tables, so machine_restart() falls through to
its infinite idle loop and QEMU never exits after kexec.

Poll the serial output for the test verdict and kill QEMU once
it appears, rather than waiting for QEMU to exit naturally.

Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 tools/testing/selftests/kho/vmtest.sh | 35 +++++++++++++++++++++------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index a6ae9ac09595..3cb9674e4475 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -103,16 +103,37 @@ function run_qemu() {
 	local qemu_cmd=$1
 	local cmdline=$2
 	local kernel=$3
+	local arch=$4
 	local serial="$tmp_dir/qemu.serial"
 
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
+	# On LoongArch, EFI runtime services are unavailable after kexec so
+	# machine_restart() hangs and QEMU never exits on its own.  Run QEMU
+	# in the background, poll for the test result, then kill it.
+	if [[ "$arch" == "loongarch" ]]; then
+		$qemu_cmd "${qemu_args[@]}" &
+		local qemu_pid=$!
+		local timeout=100
+		while ((timeout-- > 0)); do
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
@@ -179,7 +200,7 @@ function main() {
 	local kernel="$build_dir/arch/$arch/boot/$KERNEL_IMAGE"
 	mkinitrd "$kernel"
 
-	run_qemu "$QEMU_CMD" "$KERNEL_CMDLINE" "$kernel"
+	run_qemu "$QEMU_CMD" "$KERNEL_CMDLINE" "$kernel" "$arch"
 
 	ktap_test_pass "KHO succeeded"
 }
-- 
2.25.1


