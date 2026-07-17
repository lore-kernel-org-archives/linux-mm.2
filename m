Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BFBAC44507
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 07:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90366B0095; Fri, 17 Jul 2026 03:16:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67E36B0096; Fri, 17 Jul 2026 03:16:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA66B6B0099; Fri, 17 Jul 2026 03:16:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED576B0095
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:16:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1CD338030A
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:16:42 +0000 (UTC)
X-FDA: 84997411044.21.283FBF0
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3FBB340005
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:16:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HZthQBFw;
	spf=pass (imf27.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784272600;
	b=ciFTDYnn17bKLWyyOsLpNYclMAP8Ajqr7IzG3N/5dosDZPZgkgLVhjycJx1eIaU4MGD1R/
	RndBbCGDey3kszxnXv8ZPVml9AwwCNl+s2TASzPMRy/s9cM3zBMHfjmdMM6hu5NTmCcREN
	GHpJl/edx1dknNqnbqomYEYPH7R1kqc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HZthQBFw;
	spf=pass (imf27.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784272600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ykj7j2TDvNrFWyx2wOeD7eQtBc+/mXRhuYo6V5jMIW4=;
	b=INTe7+CpayBLWtohquL4usQ1oZYFboFJLcLPIpF2xXrpkBrLm4d6T+/VxyZ+0x+Xy8f1Ch
	kCRMewfI/p1uOLhpOuCMnVZeC3vJiaLlPm9EEWCuxVeWDASGlhUZAOU42IS4vxpaNDse9X
	pm0XZVUiTxzN99++jvyUN02YMwvDAEo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784272598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ykj7j2TDvNrFWyx2wOeD7eQtBc+/mXRhuYo6V5jMIW4=;
	b=HZthQBFwTPafqA7/z8vwiqrBkzvUO6Y6RY+wDUW/8KsrKgOfmqOmtCh+mGmkMr2L4Vu/M5
	gVElcxGlKit8oIvT+BaHiUEX62Tu6aJm0C2oMC3Ndfi1kOMtncpa4xVEXsSgUwTKrLyQaa
	8jRfWaIKaro9zHCU4gTAPlMG3G069xI=
From: George Guo <dongtai.guo@linux.dev>
To: Huacai Chen <chenhuacai@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Shuah Khan <shuah@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Alexander Graf <graf@amazon.com>,
	Kexin Liu <liukexin@kylinos.cn>,
	George Guo <guodongtai@kylinos.cn>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 1/3] LoongArch: kexec: add KHO support for FDT-based
Date: Fri, 17 Jul 2026 15:15:51 +0800
Message-ID: <20260717071551.11904-1-dongtai.guo@linux.dev>
In-Reply-To: <CAAhV-H5B6Mj2-AffkstJ4f8EEmvvPOGXoDy2QNudKD2kSz2XkA@mail.gmail.com>
References: <CAAhV-H5B6Mj2-AffkstJ4f8EEmvvPOGXoDy2QNudKD2kSz2XkA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3FBB340005
X-Stat-Signature: 3u61yheyst9smkbha9i6yjopcuktiwq6
X-HE-Tag: 1784272600-183828
X-HE-Meta: U2FsdGVkX1+JrsRkEeZ5r1KD8dErkMAFvc1XfW3/I+JDORqca3QRs73wpRh0Fost4Hrx7tECWu3k+ZrKqXxivROecyKPm6nsDSNn5AmGHYZLGmTSGiLA4kVtP7FQEC1EParQYG47Bd12nquKje9dFRg3Nt/ZawilsZlcOMqUKi5LCOXEVfbbB84/uy6UCVqluwwcM7ogYdAybYfPn5PGRR/3ziURzRVXQVXHJO+zUV50COQB6HGhald9o/WCujQjSFkFoYev4FLMgOl4zCGadQtt5CmpqRdON9/VaXRSianZDPoHhk9BkNHglVbAhLL8Vo2+9A/dhR2rmFI+xdVfLpSWi21n7azTCw29oJa1XZua4Fe3+TMzhT4Y2OsiRa1Z+TqK1ZBQLcyu1CISFiRtSHAveifknbMJBEdnkYy7EL+Mq+zLhfX43pMrVk58+JYlXXDL+xqgHtNWeaD6LA390/qgMjEit9Of2kmjgFq2+ZEcUw+pEZEt1HUOvOrVC1vFD7ZQxAlOpDkThLDD7r7NkqzpIhAkUYpUAvjJBzzFKuRbQmG/I1LoeZn6on59U4V0aTRHdrE1liGYdswJugNJk8ZMniwr9sl9oJSiI9MvZPfPfkNWcb0KchI9f0n2I+uZCoWDIRx2w03nmDCQ/PhoTDhpDNBU6V3J7Vy+TOSQtR7wLxwNmeIeymsOIBt0jCzRTjB14pggXz3eaFreBTrGHSO07sWLexaDSgV5v/6bN5pAC58WGERHpNSe4qUZq0XrgXGH/1B1lF3yAgqsaFIH0iI/SQav1Z6Gr7uPxPF8Of28bdyxDtzYtyXSfBm8ckENNejQ2FCqnGKV4NmZUo3YSH0XLkMCrxwPJ96Woc37YNLkAMtlvm1xDyI218SlUfKPWQ6qEA75Q6sXPoJzEePp95lO6+m5VeJvxesoeG/x7D790AkNvJQqJ1XFsaX9qPBCKHDg8vYznRkSEzDLpCf
 H2823nga
 c9a/O9Ul3ll9fRq0BovJb39KuN05xATpOfR/WtKBxMstMPJCYNJXElAvHrqpySaKARfp6ZXCHuC6Lpr33oRfppGD8g6IPNNAsKtalcAMKGFLyNP3bg508d7K7cvHftS69yR3g1M+ooQ1+Qn/O0CdtTt0UvZaV8o3JhJvRXy9GAX4DgilpuN7EsbxldHMKibD8nl42VWvhYvAmUi2UdvwJTu3ZueNlGrAnomqf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Huacai, Pratyush,

Thanks for the direction.  You were both right that the v3 approach was
the wrong shape, and I have dropped it.

Let me restate the constraint and report what I did.

> But LoongArch is different, the efistub doesn't create a FDT, instead
> it passes the EFI system table and command line to the core kernel
> directly.

So LoongArch has no boot FDT, and the arm64 /chosen path does not apply.
My v3 synthesized an FDT and rewrote the DEVICE_TREE_GUID entry only to
reuse the generic reader.  That was the hacky part, and it is gone.

I followed the x86 model instead.  x86 has no boot FDT either; it carries
the KHO pointer in setup_data (struct kho_data) and calls kho_populate()
directly.  LoongArch has no setup_data, but it does pass the EFI system
table.  So I use the EFI configuration table as the channel:

- The first kernel builds a small handover struct (the KHO FDT and
  scratch addresses), adds a dedicated GUID entry pointing to it, and
  loads both as kexec segments.  machine_kexec() switches the system
  table to the extended table before jumping.
- The next kernel scans the configuration table for that GUID, reads the
  struct, and calls kho_populate() directly.

There is no synthesized FDT, no DEVICE_TREE_GUID rewrite, and nothing on
the command line.  I did not go back to the v1 command line because that
exposes the addresses to unprivileged userspace through /proc/cmdline.

I tested this on real LoongArch hardware (ACPI/UEFI) with the live update
two-stage kexec test and the test passes:

$ sudo ./luo_kexec_simple --stage 1
# [STAGE 1] Starting pre-kexec setup...
# [STAGE 1] Creating state file for next stage (2)...
# [STAGE 1] Creating session 'test-session' and preserving memfd...
# [STAGE 1] Forking persistent child to hold sessions...
# [STAGE 1] Child PID: 1242. Resources are pinned.
# [STAGE 1] You may now perform kexec reboot.
$ sudo kexec -l /boot/vmlinuz-7.1.0-rc6 --initrd=/boot/initramfs-7.1.0-rc6.img --reuse-cmdline
$ sudo kexec -e

$ sudo ./luo_kexec_simple --stage 2
# [STAGE 2] Starting post-kexec verification...
# [STAGE 2] Retrieving session 'test-session'...
# [STAGE 2] Restoring and verifying memfd (token 0x1a)...
# [STAGE 2] Test data verified successfully.
# [STAGE 2] Finalizing test session...
# [STAGE 2] Finalizing state session...
#
--- SIMPLE KEXEC TEST PASSED ---
$ sudo dmesg | grep kexec
[    0.000000] [      T0] KHO: found kexec handover data.

I will send this as v4, folding in Mike's two selftest comments.  If you
see a problem with the EFI configuration table approach, please tell me
before I post.

Thanks,
George

