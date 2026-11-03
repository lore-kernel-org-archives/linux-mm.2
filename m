Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36ACC606A33B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=tF+CtXHV
Received: by kanga.kvack.org (Postfix)
	id 7BF916B05DF; Tue,  3 Nov 2026 03:09:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7977F6B05E0; Tue,  3 Nov 2026 03:09:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ACBC6B05E1; Tue,  3 Nov 2026 03:09:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3ECDB6B05DF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:09:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCAA41A0329
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:52 +0000 (UTC)
X-FDA: 85393084224.01.DC9BC98
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf24.hostedemail.com (Postfix) with ESMTP id 785A1180004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tF+CtXHV;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+UFJzAgy7f7fNDFNYwbu485X1uKYlUTNzJPVdBiORs=;
	b=3qyW6m/IXS/EE18sRzEjzan8Kn4v9wISWBmbWfFMnudVSmF7+9lRDUap336kYgUiUPfv+Z
	NdH9M4japXPBAPp72gPNeLTZaq77BVtPe2FuHzG0FjMB4LbpylkoSx9PqncH3aPjshyqif
	WkFlRMQzNFO6DHTuQwKq2vvsF1n10Bc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tF+CtXHV;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf24.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693391;
	b=8TJ7aZn2x9U61D4Ku5kN/8+XCuMOFSlhFReoF7hKIGiRTt55hYXku0O0esEEPVGtigTkoe
	vKxhE0Hb3Q3B23PzdKrwcmfHpSt3qsCcjnGWsdIbYlLhUbAkatpZ16qVLM1pgXsV0LX5N5
	RQuKuqnmCIIBK4rewusn0PwGls2D6bc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793693385; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=c+UFJzAgy7f7fNDFNYwbu485X1uKYlUTNzJPVdBiORs=;
	b=tF+CtXHVwlX7o2mCzET7qWHgp2K6Oq1+vzQnNoueIzsAiwRYHbuCmXz/PPVThm+vvMCnkcBg1u5Jg0ukZ2gbOPcxCDrQ5Zgr702V1+5Jd9Wu67yku2SsBdLQjHTDA+ly1yQaeW4JxD1GvcyooO9SEwctrNwEPhkJcVqOtH3tJ2M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XE27L1F_1793693382;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XE27L1F_1793693382 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Nov 2026 16:09:43 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	alex@ghiti.fr,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	graf@amazon.com,
	shuah@kernel.org
Cc: guoren@kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [PATCH v2 4/5] selftests: kho: Add riscv support
Date: Tue,  3 Nov 2026 16:09:25 +0800
Message-ID: <20261103080926.2079-5-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103080926.2079-1-cp0613@linux.alibaba.com>
References: <20261103080926.2079-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 785A1180004
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: cd5ybrf377mdqy6xrm9w91bkh8ez5hiw
X-HE-Tag: 1793693390-641066
X-HE-Meta: U2FsdGVkX19ZrvW1Y/tYtrrvtpYQZBukl5L1z5egR7+z68lHXUbOxrqnSyF+NFFVeSuiADQuSqae+vHx3Q4cZorwGk7ITIX6jC9jnwRC86XKqzjhYnSw2i823PnND4bAd5kFzRfJtdoUq+qtwoArLw0AldH3pEHsVVsdERe3U0hLo7koL2CiRKO4vt3GdmeM2++rTxg1eo+1eezHJWCrIKj1P8Hy1SLNHKqUl0PlC1PGZQAnK1+1jlF+r/m0jkd25KjpHSM9hwDj9nsWXLAaYKDWSYzHygUhFO+fONSZV2cqiS/LRSV1e7wOhHYf08tl/93WIrnrWNAt9JiR9Plgy/fmT9agAGqSpx0MEJMBmKjVQ27qVSQqvHJ4dPZjF8vgJMEFvbFzE44H48XsDOcGK0yq/IbCG/40GWCAx01lFZIKXWGS3/kPuNDlGB8KtsrslJjBB/1SAXsGcTpJ5LuBN2kV/I5HTg9SA1wcj8v6RBV4aLx3x8nFxdQIyHeuOEgw+le22Gawjb21XQzOlJE3llzkQoL6snIF80LPsMFwYKDX7zrA+QO07wArJ8y7epYsemioBdopBwHO3T8nftHqnS/53BEJKnnuCMeaUBDeV2qYoeLAykTdaodXy2P5GUujD0RMMSs9x5V9h/U/hQyMlHVAJlJUJEIyVXhlqM7q7Mg1Nd5E3Zjt5y10kLt8R+vrKGx70QjuCw6+xbz1Cd81kFdUB9XXA9GoI/LNPOzbnW9Oirlc8BGSc8fqg0iyx6bvu0tVG7Y5k70kQM7bk48ze3WnYMnJigdH9nzWpYJLEjudhaieyvwkqmfAdoNYg4ZAGFOoC9TbjonkaPvuqsTvNl+xVFd3fv7dzvD7IKxiCMcly0seAd8sP3ZQXQzjwXjx+lTYB4s6vJw+ETEiaZnqi/aLmNvDKGlPTCF3OUX7+hk1/t3D4covBKBOmcSygw+kP6v526sGBQSROQsBvJQ
 EWUpXSp5
 rJf0A0E22RIhMfDAD1S1T3NlkEZohIcyCpG69Xfv5PLuaomV2kjBPdEI/MrbLqSfIIgYAyPiEOVa8s59/mNir9UgpwvQZ8EzqPm9vOpdeqGNKVjqd8fJY6MgpIPB8woL+vU6Bi9Ru0ZdGcrz5vWELLfjjSQ67YbGubKl6Qnoc+5Xxo8q4iHn+FDjrMoCk45U5+YjFCqEUk1RVHjTj+9aL0dMbmZ3uhTLFG5nI46eKg2LFUKPYzb7MhzeLGVCrv2+khl/g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Teach the KHO vmtest runner about riscv64: map the target to ARCH
riscv and describe the QEMU virt machine, the kernel image and its
console -- a 16550A port probed from the device tree on virt, hence
the SERIAL_8250{,_CONSOLE} and SERIAL_OF_PLATFORM symbols.  Also
select CONFIG_SPARSEMEM_MANUAL: the runner requires
CONFIG_DEFERRED_STRUCT_PAGE_INIT, which depends on SPARSEMEM, while
riscv falls back to FLATMEM (no ARCH_SPARSEMEM_DEFAULT), so without
it the test would just be skipped.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---

Test: qemu-system-riscv64 (virt, -cpu max, TCG), in-tree runner
"tools/testing/selftests/kho/vmtest.sh -t riscv64" (boots the Image
and kexec'es into the same Image).

  KHO: found kexec handover data.
  KHO: exec from: 7.4.0-rc1-next-20261102-00005-gfca49e548231 (count 1)
  test_kho: KHO restore succeeded
  ok 1 KHO succeeded
  # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

 tools/testing/selftests/kho/riscv.conf | 9 +++++++++
 tools/testing/selftests/kho/vmtest.sh  | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kho/riscv.conf

diff --git a/tools/testing/selftests/kho/riscv.conf b/tools/testing/selftests/kho/riscv.conf
new file mode 100644
index 000000000000..ec2a46cd45d5
--- /dev/null
+++ b/tools/testing/selftests/kho/riscv.conf
@@ -0,0 +1,9 @@
+QEMU_CMD="qemu-system-riscv64 -M virt -cpu max"
+QEMU_KCONFIG="
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
+CONFIG_SPARSEMEM_MANUAL=y
+"
+KERNEL_IMAGE="Image"
+KERNEL_CMDLINE="console=ttyS0"
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 1e86ffcc3a79..56cac6ae3cf9 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -21,7 +21,7 @@ Options:
 	-d)	path to the kernel build directory
 	-j)	number of jobs for compilation, similar to -j in make
 	-t)	run test for target_arch, requires CROSS_COMPILE set
-		supported targets: aarch64, x86_64
+		supported targets: aarch64, x86_64, riscv64
 	-h)	display this help
 EOF
 }
@@ -127,6 +127,7 @@ function target_to_arch() {
 	case $target in
 	     aarch64) echo "arm64" ;;
 	     x86_64) echo "x86" ;;
+	     riscv64) echo "riscv" ;;
 	     *) skip "architecture $target is not supported"
 	esac
 }
-- 
2.50.1


