Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A964C55167
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 23:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E938A6B007B; Thu, 30 Jul 2026 19:48:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45B66B008A; Thu, 30 Jul 2026 19:48:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0CBB6B008C; Thu, 30 Jul 2026 19:48:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC2A26B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:48:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1C4716030B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:48:27 +0000 (UTC)
X-FDA: 85047084654.22.35293EC
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0735714000E
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:48:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XScp2vED;
	spf=pass (imf23.hostedemail.com: domain of 3yOJrag0KCJc1289J85B21G1K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--abhishekbapat.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3yOJrag0KCJc1289J85B21G1K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785455306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cnzxumlUaeANW0Mk9pTdxHWPrbLzE7Ij4fMLsWP6Nzo=;
	b=Lmqw1afN5hXG7Ev8hxvXgLPzec3quXsr22+Wf7giMEk0IpcsI0zpc+4Wr1aO3Z/lRvzjPS
	a/LDRZYIEBNtP8OeDFNHos7FID5uijw/o385qwvtJjgnM3/Nv+GXqANY+J/HMgLCnzKbTF
	DwHAAUOuq26JpIwxgakxf6tQhsPn9UA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XScp2vED;
	spf=pass (imf23.hostedemail.com: domain of 3yOJrag0KCJc1289J85B21G1K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--abhishekbapat.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3yOJrag0KCJc1289J85B21G1K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785455306;
	b=jYUUjv2Sp3lyoQKdTzBnmes3sBKsvanNjAI7ZYieIll+sL/ghhvdjN8oY2I0Q5Maj7jd/z
	G6HJWKK4V9ChOjFPLXnDYXrPM7QXXMEkkA45+0Z20Z4qnNbNaS7hFilab3Br2hC1TxLbv4
	mpfSB9rBau906s8xXw0azXuzzJpbtZY=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-388b404eaa4so529234a91.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785455305; x=1786060105; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cnzxumlUaeANW0Mk9pTdxHWPrbLzE7Ij4fMLsWP6Nzo=;
        b=XScp2vEDZ5IXZE8nF0n/MAN7PPB9qZ9bpY4LfqrMXLmXp6Hk3smu8QhloJEKOjcUuf
         Qv8pKDd0IjvsY8o3wIJryoiCLR5SBYrIqo8YQ9YivpUz1PCWWcgBtuRITgGPNFh2bN70
         m9ah4Cgi1+0ujAoYN+2xaZevewtRFRzaHzBM7yD8QNadtozIrwRp8jHTR21L6r9Tq93y
         bFx4ZtvbVP262s5G6ryHsDmHF79ITWA6tM1SYWE7oTIHxetP7hy/O5kzZTP8dcX92QhD
         hxRra7IFJ7MjNXExnJ0iEf1I2CyHTFq3mTR6hsBNdPKmQ7FtibS/Av4sCjUmm3hX+f4s
         dKmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785455305; x=1786060105;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cnzxumlUaeANW0Mk9pTdxHWPrbLzE7Ij4fMLsWP6Nzo=;
        b=jppsIeA2QiXqWE13cHk6ygorEmfih8V6wr4bFLUUFSDu0Qo96Qdt1+20XRaZhDs++F
         Fz4EyspSrZ8qg71YydwhBZgn2eqhbRaZaZh0iGOp6kTR/lFpfPRwtSSSxot6ZLfZ1uCb
         ihwa32293quCwU2UTw8O3NT8QjvLNqvJdS1FhF9D402If1ba10Hm+B6+VhDiY6y5t04T
         VLDbDG+QzmBeJs7299EFyMzzaC9+PdR4Vl9NMTXIPIS8CI6/TTRdXsupuyJCpB7f8oVK
         91F160F1E8itSmoBvJI9et1fhlims96atRXr76TwCyzdRnD5H4OOUeypRXDMgeBTiRkx
         M8EA==
X-Forwarded-Encrypted: i=1; AHgh+Rp6JIfMV6hqei4kpVxEgq+ybw7wMgnqEsS8xUXh9ALGM4WfgNK51X0d+StETyeqlGk3NYR1fu8HZw==@kvack.org
X-Gm-Message-State: AOJu0YycAS5RVX4IRJ1bVmuqwGM8pFYp6766Ox7fa3RAo7RnmG5/Fkos
	FXnedtgnDcrtYlWVMm0K0E+a5vDVysctzPSd7t7cyuG+bCc48C+iwPBHQOdgc53BlmzwEPc7ToH
	LFoASNWqzxRFVbIlWgta6/bN/ZpKy8ZcO9w==
X-Received: from dlbbo24.prod.google.com ([2002:a05:7022:4398:b0:13c:fa4d:cc16])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4c52:b0:381:a766:efc9 with SMTP id 98e67ed59e1d1-38f9bd51d11mr3681083a91.7.1785455304317;
 Thu, 30 Jul 2026 16:48:24 -0700 (PDT)
Date: Thu, 30 Jul 2026 23:48:22 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <0d84763f140ea735d790e0b30a8e954536beb875.1785455267.git.abhishekbapat@google.com>
Subject: [PATCH v2] alloc_tag: expose profiling and compression states in /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Ge <hao.ge@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 0735714000E
X-Rspamd-Server: rspam01
X-Stat-Signature: 11f1iet5tb7e1icy58qakm8narwrhfnh
X-HE-Tag: 1785455305-340137
X-HE-Meta: U2FsdGVkX18OXRYHJ8I0Zr0ytQJlcXd/wCXK2TDAJoFVFdjjD7pjCyC8xwRx+xxiQcySB6Uw3Nr0hHJ40p6yxFA20JDHobit3kHQ1gdTEDdO/BCQEVJJMS7OfKHX82zlKL42SbqVKOibJVkLMEii0kiDjykQv5KXSNbCfD5/QY+UMXN86QVxGACpXs2vP8Ffv6UG9Zlp2Bn01DtEzwvXBsTaF+cqr5t/SMQibHn/5KKJU71bS/cC039U8FpUIA3kSQsc2rz4mjvCaWiRZr2//LTMxeRWf1enjh/5SMjmWMRktFavrs2mT9ZOp9Bkam9eMXv4LfA7QLOr/jECSL31eVOpT34LKVS+BnnG7Ble5o/Qv08WZ79RZFYyssD4wlZTuH5eHPOMOqP7z8xhKQWZ1oK07a/GOzKjzhkENzOXTiYz1TNoJ8wzhyTLzZ1zAbofu+EXqOK9egw8Ndc46UwnxvzypJp96Qwd39V18fidotKuEDdXyl+hZL700MsiXtCnkYvlGm2ZF57YzVpiymdBO4LtdQENBIuwmf/en5KgHuuQsAYIz1qWzeGPzP35rOdsaUHuGHhVphBzvbVEJXxR3XIuCCns2kZ4KZR23X2w7inZ1chMqGTiyDuIEwDU5pUTrszAADzCbKKg/GruI7S4xGLFghmNoMiRfOVE4tQ/FHu5beZM7F028V+NQVCIyUz7my0HiRciDZOrZjdsj40cqn2Kr/sxOAo+H0tGFIZDtRxWB3EXgfmEYZq2MHfhc7APcpmR2xCK0Oz6O635hwy3tPfe+aEpMH+vvMHvPaIhgRtv7I4t5PVprjytXsJw3lgILzMltUV0QXZgJjQZ4DkSm/OqGhKqTP3GW1Q6vSymQbCS6S6E8mT2y2jorWwsyDGjccPKjB2UUkTSJZ2VMeNfBWerrWeqLLIVMYpv2mFkOQB3VMgBRg2sNTrPS+3J0t5mv/lhZ8KzEcYRZMPOrEE
 IKnYmWEX
 r0g4/3HXGLim7c/nfbseRgGOr0MPvAeXFCbdBAHvvTmDrE129fZPE1lilspvOD5fZvWlbc3NSj6Y1eifymp7n/0Z066GHti/1vnnyoe8hG2KoHDy9go+nG4BkERRGzRMBuGfJ8sAJ4VwgWZ275qgFwcCv19YtAuLFJ5DTY2kNgreG7yT0UmTLhrm7E5jCVRJ/V0NCkb6jzprEYx/rI3hOvCOqolN0dtyGcIyUzjesnsstarwmFzjBU4KgHcVSpbsw9u2PyqEYRlCNR9+EtgJUtTY1noQlrvOIn8dXnPycpv0aVU87pYwlhigXABpAb8970mltT4N1c6oUiGyQxqUA8pDSG8HZmn3fbp9g1WUnJRecDG7WaMqZEkzH7Sr3tzQLaeMk2Aap86b0lszwzMVc52KwCcfckmYTFPoVusvci2TFp3+hjzmLihjc/9J2TRGd3WcMB8KKdLAO8cduQuTaMzYZkUqZbzcTHSfuoUuRC4ZaUVINf9hiGvzZpde9FFMXPe61KoNSm2hMWRGefIPtiIRv9SGPKSt2AX9KLuWWb1j3hwK3S+3at2gLHk56QxuJl6mfSy2rOc4GtfKfOSGJmOJMKzlU+70jv46eruKHaAMwYhrwA0OZan5zQKf9edxPTrBqFrpYDDy2xaLlT6Hi6TWcD5u6sjRJz0z0zTI8Fc0AS7Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, userspace has limited visibility into the exact active
runtime state of memory allocation profiling and its page extension
compression ('sysctl.vm.mem_profiling={0|1|never}[,compressed]').

While reading the sysctl provides basic on/off status, it is currently
impossible for userspace to natively determine whether page-tag
compression was successfully enabled without scraping dmesg boot logs.

Resolve this ambiguity by exposing the active compression state by
adding a new read-only sysctl `vm.memprofiling_compressed` to output the
state.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 mm/alloc_tag.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index 52aece27b00e..877068241f06 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -1303,6 +1303,12 @@ static const struct ctl_table memory_allocation_profiling_sysctls[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_mem_profiling_handler,
 	},
+	{
+		.procname	= "mem_profiling_compressed",
+		.data		= &mem_profiling_compressed,
+		.mode		= 0444,
+		.proc_handler	= proc_do_static_key,
+	},
 };
 
 static void __init sysctl_init(void)

base-commit: 2ed26e8a624f41887d64e2e37a2f6ab36a118d1f
-- 
2.55.0.508.g3f0d502094-goog


