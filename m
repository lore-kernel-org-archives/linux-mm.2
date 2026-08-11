Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0759C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 17:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91B06B00A0; Tue, 11 Aug 2026 13:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69B76B00A1; Tue, 11 Aug 2026 13:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C58916B00A2; Tue, 11 Aug 2026 13:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 975DD6B00A0
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:53:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D540140189
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:17 +0000 (UTC)
X-FDA: 85089735234.13.C78D38C
Received: from flow-b7-smtp.messagingengine.com (flow-b7-smtp.messagingengine.com [202.12.124.142])
	by imf08.hostedemail.com (Postfix) with ESMTP id 31A75160004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 17:53:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=bcI27Xge;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="P dCNW6x";
	spf=pass (imf08.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786470795;
	b=V+y8FShIE4c7OiISyJsSAvXNTKlXja583rOxO//arVR46AgTMEsAGH8pVhi1n1NpU2rPlf
	H/YKHZwOVtMJbCJsqUzDNu1WsyDZSgHtmwN7MMqdVwT6H3LKhUnGM/Ce8MrwSzooByW73M
	Gl6Or0I3nbM0Plpb65Gty2HktWzJbvQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm3 header.b=bcI27Xge;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="P dCNW6x";
	spf=pass (imf08.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.142 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786470795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6bzYVrzwmgCxs1BAVE3pg33ZbHvutLaxuLFDziO3j5s=;
	b=XOu35ydvAkvWQcq/6dpHiAFel636cC0lD8VuILP42NDcjqWzsy5qQS9EhipYRSR1LmL849
	DvOUa6I7tjVs8hH5l8egX/dWU30BtvmJuY6h5nSOBjLxyGlggIMSNo8oU1mhwyzriil5vQ
	KXscdAHZkisES8IajINdR85yQiyyEhY=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailflow.stl.internal (Postfix) with ESMTP id 20E4A130010C;
	Tue, 11 Aug 2026 13:53:13 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Tue, 11 Aug 2026 13:53:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786470792;
	 x=1786477992; bh=6bzYVrzwmgCxs1BAVE3pg33ZbHvutLaxuLFDziO3j5s=; b=
	bcI27Xgefx7p/5EIJQwftgbpvO5xbhyQvUijxfe5lVDAqyY+fYJfIhKaWs1SId5h
	iCajUTbExspHQ0NmFeIilMuSmDj1HGY8R3StcexlvninnGRbjaIzKRPvh1pfWj0Y
	4N+v43B8Hpn+L7vL2mKr5VKeTR41GSmIMtmxCq6WwGMr5xLi7Kyu2heugjXYdzML
	Moi1BXAQnsWQ7nzy3kEEL+w/qgUSiBueMIBgolB5oKcjc+wZM+NsJdam3isuz/Fz
	LREjp4/GOAq0fFGYJI9yJQkU07vKIGOhe7p+vKrmrn+UgxdGRXPYiDjb5sGDQ6SU
	b8xitavmMV6Bgt7U36KW/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786470792; x=
	1786477992; bh=6bzYVrzwmgCxs1BAVE3pg33ZbHvutLaxuLFDziO3j5s=; b=P
	dCNW6xpi1mN3p3koEB0o3OQTpob2y8vaqd5Jw7xtCovcdCiiFZwJTw5E3zAAk8Pk
	t1gmBkV2YjUGRq5wy2UHjKxdGK9npQ3h5CkvPKLKkdOzhJgIVTdvW4cCoOb72P/Y
	StGUUPUW3gY2jl7tciu9f9af0n7PQhyVkzXTBx7FkZ5RnO9EBZUdtJC2kQY8qtsY
	fgmRH4ZE9CjDdXZ5jer4QGRzQuYNDLt5VVYEhK8jBr3zMJOPhQzX2mDyC8IFYeiB
	Wqgl3IsX/eyJofhyg2xCw5hl7Qz0fQWLhqaxOQLc/rBPCzyeuGLvEJkCiuuhJ8PR
	kMNy/jou2hvlE4s71xOKQ==
X-ME-Sender: <xms:iGF7aiu61NAIB8QebsQ52KHNn_nNMTrvOHWNEhpLSeEAs46b7sKxKw>
    <xme:iGF7agT11EMLhD5AFnZZF6M65yV05agW3GuHDyQNW3aDPSXh7ygFFv2k2Wh8Ypy_I
    VSAFRBIVlbxIyrTqqH_pPTNzv30Ow-XaSBZ0dcyBcVfTcY_Gd9e3g>
X-ME-Received: <xmr:iGF7akXYpB3rU0N45TB6PYZ3KjSf6srOrSOHQ8UGMgZPkoWdu3TJh1OMv_BgLvXJSvNXpMzNvZy-OkghN-mligA>
X-ME-Proxy-Cause: dmFkZTEwrH8wfhgctv1ErvL0nhEWRZaXCL40jelDGtxObnm8dQ+WB7ldi7zgGP18fqrN+C
    7xne4qHVB4V9kXTny9F3UzpVvRvOC+vTRbUvHE754Z1otc2eFdFHJmjh2luxatp0pqWwYy
    sRKrXvmGl66/LIjfpMZjwK9kOj46ks+olR0W88tI3sOrJxqKyJcEI0DOFTt1YNjUFLRRyj
    iHYKN+FQnILJq0PWlXi8sHSJU6WpS6NMySRow97FBBcIDr2FI/M1huQ7BdiSPQY9tzBu/P
    Ctv1qfsiGpDZ4DjvEs5TfiMr3xHnr/zYsFyi6aFPQHrx/6AOsIqWNugJkcAhGMC9jATngj
    PsYwLs2afmtUbJFrF9pVWN/ueehFiV4iqe1vK7Uil7dEB1ZoerwVUPSf+EH5Er+YoOKMn/
    bl8akgMI1uL3WWLdOzwKvEEJwRmYYKXvrBGkbESTPvfFFYUjNLj4SGDvyCd1kqNFX3kqtz
    HlR88uWTDziuwE0rFpj3kW5HwsI0yC8CSB84yGGiXKoT+iw1+vCALkSh0ieOMAiE1KMSkA
    C5ZeiquXLwsgm9nTcBQDN+WxS55rWEeuX5UMsECC2BtGAzDPKGiqOR+SeFj/vPoUr01tpr
    TJycXnYh9lfAnJVuJ9hsWPPtO+MKT2bSAZijEeNf6g1jd2G/hPpvETrWGo2w
X-ME-Proxy: <xmx:iGF7aqmoHd9EB0RUBj17pcVXfhfHIJaf-UlkyIS3DNXuHOwiGDNhsA>
    <xmx:iGF7asqQV1HGfsugDyNjZYHYid5QT7JwFNxXPYrd831S0JYGeBVlFg>
    <xmx:iGF7auTnF4YVDh5J3S7Resvx1aOwzVkbQdWlnwWe7GkNkK-cQfmsWw>
    <xmx:iGF7ajUrXLAp1F4bYPYSwQmmiegSLeX3PuTRw13dpWvxVdrpvkvHrg>
    <xmx:iGF7aqYRQScPD_bnRrY2QFIIFIvUTzVpfvrHo3Cowapxz3v_CwJVz0er>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Aug 2026 13:53:06 -0400 (EDT)
From: =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Date: Tue, 11 Aug 2026 19:52:50 +0200
Subject: [PATCH v2 01/13] kexec: add CRASH_WIPE_SECRETS to wipe secrets
 before kdump
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260811-crash-zeroize-rework-v2-1-9561d13c2340@jaseg.de>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
In-Reply-To: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
To: Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>,
  Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,  David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
  Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
  "Serge E. Hallyn" <serge@hallyn.com>, Lukas Wunner <lukas@wunner.de>,
  Ignat Korchagin <ignat@linux.win>,
 Herbert Xu <herbert@gondor.apana.org.au>,
  "David S. Miller" <davem@davemloft.net>,
 Keith Busch <kbusch@kernel.org>,  Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>,  Sagi Grimberg <sagi@grimberg.me>,
 Trond Myklebust <trondmy@kernel.org>,  Anna Schumaker <anna@kernel.org>,
 Mimi Zohar <zohar@linux.ibm.com>,
  James Bottomley <James.Bottomley@HansenPartnership.com>,
  Marc Dionne <marc.dionne@auristor.com>,
 Eric Dumazet <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,  Simon Horman <horms@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>,  "Theodore Y. Ts'o" <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>,
  Alexander Viro <viro@zeniv.linux.org.uk>,
  Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
  Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
  Mikulas Patocka <mpatocka@redhat.com>,
  Benjamin Marzinski <bmarzins@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-afs@lists.infradead.org, 
 netdev@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev, 
 =?utf-8?q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 31A75160004
X-Stat-Signature: c7dcu8pcbennckzuuz1q1pxfsksngtsf
X-HE-Tag: 1786470795-579193
X-HE-Meta: U2FsdGVkX1/NE7880jK1ld1l/fcXQMoGzwv7hiTKLj/7rPj1FZ4evriGfbbZi63MRDmDcr1onTUNmgdx4UuI/rNyK2ymUqZth3J13mHb2eiaOSt0ftoswqYHHWaW49b1V3rUOT0XiY6XSoTRBqzRMYcDa01s1ctzgpmpuJ/P+/US33HptoQtFLpWoKV6JOAaRShBmRgmc0aMx4iuPY6gtL6DFs5x66zA1M1fKg9EqKS0u6RhAtVdTyLbvkM2+d9LU7UN3ph/JVpxHrQ90mz/FJia90jdO3MDXYHwqUhwJYVRW/baxhKZn5csN3l1NVsDD4uUH7dneyZxRoUBReV1VPZSo8ULXLS30C7x7wFDE3wX+uWNHoTYb3m7dEPPpLuvStA65yNRwCWKoPqaxQWeq2eOOQax67XSKmToLCtSLJbaD/P2o/pb4wlu/virg6gZBWhGOpaYyD+2y5Fp/mUL9Ab6D7EzAmLZoSDo9TB0Jc7jku0iY4oLifQ6Yt7OHEPCctn6hqrv+vZCkVLsI6xrsY0JLucH30bC90r2NQ5KfkpVqyeD3ZvVOHWDzgrE5QpaJ77SAYuUk2y1GDoI8PM4Q8n9DN1u7vshLUoAMN0xF/SQM1HfHm0/LAHEeTDv21cZEOnLiCuw1ABINdMzVQEHp+Wh83ptT4oUhazPKeMRtZskbDM08pYiAoPhBS4OZkeVGy4vFDSKPhpBE6m0XTeoqGtFeGt7vZAk6j6NK6iaMxx12ZFvJDv9EZwfjZRNyCPZ9dxYQcAQpz7/5/2/JvN4S984obPFTpbv/WMIHrw2VJXUsh6HfOvqhUUBhDw6r1RVk/duGbP5+ZvLJGJ4EtIMCBR5gVZv0UEcVx5HWqyw9Igx+8IYy6wHRsxa5+ztW852clsNb+FA/rC0Hwf2C/wzz9tUNAshCbZ/yG5GmViGu3RLLPB7ICY3AP2qBvCi9cu3j/rTLOO7RmxCehRM+TR
 1t1fsrbC
 TUdErJMAhxr8gcqiU/Life2OQa4cdmqOfggDzBLZJ9NxvaB1OvZwKCZH5C+5WlQVV0SPXeC5FAeafYoSBQwpKfLqMLLDe40ZZpvC3fnSf7unxHcBRBALROXV06ZFpBlAd1MAF7RETX7LinDd9gGc2rNAv/uaeMkY50d+ATVLSOcFym0+h96RHhgJ0ijoeVpdaHPBVqVlk13pv8lsJaq5oW8xKc5rsVNMPO/ZYNVbhWlhUhKb/ROEV9ri1ABkm9n2K5YRLtcQTrnhNWJnVUeDEHvVJfnqw1B2Ei633y1qM0JBMrPEUngG/cT/lrKXRj7mFgvBwFPRmcuUiYolpB3kkwAD3gEv5E3isdxBFvIg2oafyHWR3BXFEhxJ3Mz062kLmUCWwbr+tk+HztIh4U2vmQTGoCb1MCH1FQBCJ1AuxaiIXrY9iDDsp5531lzU++STmfsnH+DbnsGcsH1zXcaZdlljvdgNlJDvSGiIQXtQ1BPjMKB0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kdump is used to capture system memory after a panic(), any secret
keys currently in RAM end up in the dump. Add an opt-in atomic notifier
chain, crash_wipe_secrets_notifier_list, invoked late into
__crash_kexec(). Subsystems holding secrets can register a callback to
wipe them.

Callbacks are run after machine_crash_shutdown() has already stopped the
other CPUs and disabled preemption. Callbacks must not wait on locks,
which will never be released.

This is a best-effort, defence-in-depth measure, not a guarantee.
Secrets in flight on the stack, in registers, in DMA buffers, or in
other places in memory are out of scope.

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 include/linux/crash_core.h | 16 ++++++++++++++++
 kernel/Kconfig.kexec       | 16 ++++++++++++++++
 kernel/crash_core.c        | 29 +++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index bc087124cd78..4230463f3faa 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -5,6 +5,7 @@
 #include <linux/linkage.h>
 #include <linux/elfcore.h>
 #include <linux/elf.h>
+#include <linux/notifier.h>
 
 struct kimage;
 
@@ -34,6 +35,21 @@ static inline void arch_kexec_protect_crashkres(void) { }
 static inline void arch_kexec_unprotect_crashkres(void) { }
 #endif
 
+#ifdef CONFIG_CRASH_WIPE_SECRETS
+int crash_wipe_secrets_register(struct notifier_block *nb);
+int crash_wipe_secrets_unregister(struct notifier_block *nb);
+#else
+static inline int crash_wipe_secrets_register(struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int crash_wipe_secrets_unregister(struct notifier_block *nb)
+{
+	return 0;
+}
+#endif
+
 #ifndef arch_crash_handle_hotplug_event
 static inline void arch_crash_handle_hotplug_event(struct kimage *image, void *arg) { }
 #endif
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 15632358bcf7..1d2d273145df 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -179,4 +179,20 @@ config CRASH_MAX_MEMORY_RANGES
 	  the computation behind the value provided through the
 	  /sys/kernel/crash_elfcorehdr_size attribute.
 
+config CRASH_WIPE_SECRETS
+	bool "Wipe secrets before kdump"
+	depends on CRASH_DUMP
+	help
+	  Wipe secrets (e.g. kernel keyring and memfd_secret pages) on crash or
+	  panic. This is a best effort, defense-in-depth feature: If the panic
+	  happens at a really bad time, or if copies of the secrets are present
+	  in places like on the stack, in I/O buffers, or in userspace memory
+	  not allocated through memfd_secret, they may still be leaked.
+
+	  Note that enabling this feature carries some risk of crashing the
+	  system during the wipe process if the kernel was already unstable
+	  when the panic happened.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 2b36aa9fade0..95f5c0415e60 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -23,6 +23,7 @@
 #include <linux/objtool.h>
 #include <linux/delay.h>
 #include <linux/panic.h>
+#include <linux/timekeeping.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -33,6 +34,33 @@
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
 
+#ifdef CONFIG_CRASH_WIPE_SECRETS
+ATOMIC_NOTIFIER_HEAD(crash_wipe_secrets_notifier_list);
+
+int crash_wipe_secrets_register(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(
+			&crash_wipe_secrets_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(crash_wipe_secrets_register);
+
+int crash_wipe_secrets_unregister(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_unregister(
+			&crash_wipe_secrets_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(crash_wipe_secrets_unregister);
+
+static void crash_wipe_secrets(void)
+{
+	pr_info("Wiping sensitive secrets...\n");
+	atomic_notifier_call_chain(&crash_wipe_secrets_notifier_list, 0, NULL);
+	pr_info("Done wiping secrets.\n");
+}
+#else
+static inline void crash_wipe_secrets(void) { }
+#endif /* CONFIG_CRASH_WIPE_SECRETS */
+
 /* time to wait for possible DMA to finish before starting the kdump kernel
  * when a CMA reservation is used
  */
@@ -142,6 +170,7 @@ void __noclone __crash_kexec(struct pt_regs *regs)
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
 			crash_cma_clear_pending_dma();
+			crash_wipe_secrets();
 			machine_kexec(kexec_crash_image);
 		}
 		kexec_unlock();

-- 
2.53.0


