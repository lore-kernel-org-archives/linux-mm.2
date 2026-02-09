Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0952E7E0D5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5F06B0099; Mon,  9 Feb 2026 14:06:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A846B009D; Mon,  9 Feb 2026 14:06:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200796B009E; Mon,  9 Feb 2026 14:06:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA51A6B0099
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:06:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCF15B73C7
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:06:18 +0000 (UTC)
X-FDA: 84425848836.07.218D00C
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	by imf09.hostedemail.com (Postfix) with ESMTP id E8D3B140004
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:06:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="des/M8sJ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3JzCKaQYKCAQezekmrksskpi.gsqpmry1-qqozego.svk@flex--avagin.bounces.google.com designates 209.85.160.73 as permitted sender) smtp.mailfrom=3JzCKaQYKCAQezekmrksskpi.gsqpmry1-qqozego.svk@flex--avagin.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770663977; a=rsa-sha256;
	cv=none;
	b=jCdGw2HNhPW3duQ7V2TsySYfs0XybmVQlYxh/CCm/ySaBvudjLPyZhFjp1gJqTiQ8ib+DR
	osAa+l3eoDKTJbIBw77/ouQLiaAZSolKgbm7kjj3+xE7OfgPVNYgJ4w2r/vxRTgDTGXMEl
	GFNobV+MR3hMCsjRu8rTc47kwMvBwS8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="des/M8sJ";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3JzCKaQYKCAQezekmrksskpi.gsqpmry1-qqozego.svk@flex--avagin.bounces.google.com designates 209.85.160.73 as permitted sender) smtp.mailfrom=3JzCKaQYKCAQezekmrksskpi.gsqpmry1-qqozego.svk@flex--avagin.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770663977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vdr4V4HK4nTpFzygAIFcY2is0P9+eeyi+VB04pSk0Ms=;
	b=kIgkZmCbt/d02WnZYrC2rviG+Qah1oS/eyXRIx3cRIO7h3d7gAPdqLc5Vr8zN5I1k//Cok
	fb5eg98WD2nk+nXutfmgsseWTHxnIsLAeSkV22NFnBpe6r5iz0TjYyxPb6ktwzcq2oO6NA
	K2fpdQSpf0+r0DmaOFi1BzLjjMMjKEE=
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-4042a16a369so11792728fac.2
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 11:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770663976; x=1771268776; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vdr4V4HK4nTpFzygAIFcY2is0P9+eeyi+VB04pSk0Ms=;
        b=des/M8sJBaNAfiSJ9BAL8++FTLRSBySYL1Z9K/rwl05xiLrFg53gla4oaH3Lv2T+TV
         tkWxNQ+zwsI+VzGG/6RqQH+c+lmhbkclc+rSZfcqsW2nRBSn1Hw2FEjKmZVJYRNmqMmw
         Qvg0w7KBupwlTSCLcZcHAg5mJd56yKGZUflPwlAQ6vawyDWhryAbrG7buhmFCFKsD1Ja
         iPVODwZfTK9gTDOkCD7jQkQxYs+bN2Y4q84yOSk2CJEVqSmOxqV1akKQIoyixyCpXKRv
         hCpctokvIVzu2K1TSiwftbuS6YvpgkDmLJQf+FuPp/NJvCftKn/OV3N2EuXI29gvJgEH
         kcEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770663976; x=1771268776;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vdr4V4HK4nTpFzygAIFcY2is0P9+eeyi+VB04pSk0Ms=;
        b=kb6T094sHsKM5v8leOTAMzKmofQpbNwxzBaoUC5X9fGWlTh4uLvz9uMGRydPwQ9AWZ
         c+6+uO8zoilm9LSTpLgPAwdeM+1F7KxkiUfQbEbMCLdOFmwet+ZYMXHoPLLr87CJy1mY
         ADc4R0PNW+rWHEYuDfY+zEzZ3yDh9Zj5JPCJMeZrZNXMoPRl3Y+++FutKIJhGQul8L6/
         5dlYcENBqvQOIPQT48MCZYYYud1bGu9AXGRr9X4Kvdaq/xJQPWg12NJzez7k3VTdZa7R
         n8lLq4rWODZwKTZJNnC1w2+4fE1Zk1xz66G2Pob5fEqx5ieA+gS/K5ICYIclLpZbCkXk
         eNYg==
X-Forwarded-Encrypted: i=1; AJvYcCU49GOud0q87QR7vmlQBlUkn3AdL+ODZSMs69OqgTcJ75gwsX5SXafNhxz50iqTwaD8RI3QSbATlw==@kvack.org
X-Gm-Message-State: AOJu0YzJSnjaShMrQGSlk2bRjQI80dF5GaTlOR1PJ/IZcaHxnQcFXLLw
	wfsBoxNG5diZ6Au0Pd2A23lcv5kiq0Y44UbvDbU3adnnv/dXLyrEfmhREIE0AvFP6h/yyEoHUBj
	5BsW9Jw==
X-Received: from jajt22.prod.google.com ([2002:a05:6638:2056:b0:5ce:8aec:982c])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a4a:e54e:0:b0:66d:f051:e91f
 with SMTP id 006d021491bc7-66df0613260mr3273923eaf.23.1770663975878; Mon, 09
 Feb 2026 11:06:15 -0800 (PST)
Date: Mon,  9 Feb 2026 19:06:02 +0000
In-Reply-To: <20260209190605.1564597-1-avagin@google.com>
Mime-Version: 1.0
References: <20260209190605.1564597-1-avagin@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260209190605.1564597-2-avagin@google.com>
Subject: [PATCH 1/4] binfmt_elf_fdpic: fix AUXV size calculation for
 ELF_HWCAP3 and ELF_HWCAP4
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Andrei Vagin <avagin@google.com>, Mark Brown <broonie@kernel.org>, 
	Max Filippov <jcmvbkbc@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E8D3B140004
X-Stat-Signature: ganicr8mmjmxzdm8s89dxga4idhnebze
X-HE-Tag: 1770663976-10959
X-HE-Meta: U2FsdGVkX19WpVOWuf7EQ8CRCiJW7RNxiTw+GlpWktz6NAi91RahR6JvfdH1PqiB6HiBa45N2iHIQUQATdId8pRhVILqIAGMUcRasK9/ruZO+XsIVn+Uc7Gp964BpuXOEVqhv4Wu/+O9tDYZ65aBo8yeyCK5QMnXA/r1i5IB7qQ9xFQ9gC2NLakaLcXKYH8XYwkTqck15V+NhqTdOOv8FZgT0Oren+f14n8nuazx8SSl9Vu3qNRbYNZLN3+hWof+g2o8DNIQzOg9+P7d9fpWyBNoCY1gnzHySZ8R9xZbndYu4awgZUZo+EA0NEhKmKX4FoYqbGNPYD1ba6H7pfEy+R5KnMBAIWt+I0W4o4QOIReaeWlTWKulEiPxjdNPqrnN0JgPHd+LFLt97fXOljCXy/gHrTDHmOh2DhyZPZi8QL/eOmcX909JlyL4X9LNeIzft6zHhC4QtbLv5799UIZLQ74BS0PR6H8oSdpPbJ/xsntnbxFD3FIoeGzF7PaBCmPan2hSsVf+x03pOMWRRiueLH1RAVEQMhS+18gHc9EYhJdz8k21NVhl8lpN9r1eDexzlMZSw+lA2sFjCHm6esymUlsZ4FGfoQZOKNaegtqLJgBwjkjexPXVjkySE3vN1AT25ev+FDZZ930qUFrdCd/t/VdJjsHVeLdBYDjoFyNc0sPGDkrWlj4ougaREvSoQ4IWdZNDQ+TuHu8WF6i6zKWMQ1aFoyG8541QmKWpItmWvbjqr43bQk/4TnJkZbwU9lQnkJxA2z1PZXykPp3FTCFp7AVvdtLnBtCdTiBOtyDlf01KQK9xnquUmutiWOwncop9CatM5ckrpMPmihYLG1dYxkdmemLkjXBX06NChsVrEnNd2jvtK9PosGbw+9DuWl372OMRYvZKY8f0B4HAWnMHOTwNpAR0Dk1u9l/cToZzCYnzJc4AnEXLe0naNnD5ahCMKbokt0o099pHyqrVvF/
 XzFoeflu
 zGyW5C2JeFjwk47i6JrfutAtHvub9b6zGHQSRtwYLEXBHuZeDpz/4bslg/MAcNEzC769OwsADGdbmTolxCFZj6un1D9tyxD7vEN+c7HKATzCpAxFloiLo9sN9YDQHTWSMpkTNmMeCdOcESghCjq1Q0C3WkeXIvkV5Cl5eWv/jPATh86kollz6rOzqsaf106x/cPgUgbLPhPDtoYzEjqTC4TyC6sJKIoShxrlzNYlCa8+LJGkOby0jfL6PYvEzYxCzUzdoQk7QN2gS90TzEdkZ5CjqwUunnRCshf1u1HotXk/iAR9QxI5pPugiEsR3Gni4BzreQXk2py0vYfX16iNN6dcY0xm7Hqgtd7ilb2KuedefJnmAfULcmP+9c9vJa+i9OLHZlEUDJvFXRUC3Lspf1obd79J8fKlaG5sVUvD4UpRdouN2DguD1EWNnSzo10e4tLRrutRw5q+kJLVU8rCkPMRF3Vytel8o2UiDwLeSfGKSd7DteZajSqcrfxgwtMCzr779sAVVZDd0TIQ9e1P/YgHNOzzuV+sLMzqE3YsmCQmAgt26et5K3n6S3SM8iMUUhJRDpGT6fwZcpDifSgIodOUrvCgljmE1ekkzj6WfmThjJSA5o1Icxes4HQy5uBtRsWp0QxT6Ke/JOE+xKY/811+0Wggjdft4YwPP4G8HKuyw+MNZBWe4JPN1yGWEA7dm9nXSZ3u6vvNEzdbyqrWFWzMZgNxEfTyAvSDINl0EkRyVE9Qr360OWmP/J6pTkcyWBfNRLkqkCe+EVqh9M5lJNBUzPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 4e6e8c2b757f ("binfmt_elf: Wire up AT_HWCAP3 at AT_HWCAP4") added
support for AT_HWCAP3 and AT_HWCAP4, but it missed updating the AUX
vector size calculation in create_elf_fdpic_tables() and
AT_VECTOR_SIZE_BASE in include/linux/auxvec.h.

Similar to the fix for AT_HWCAP2 in commit c6a09e342f8e ("binfmt_elf_fdpic:
fix AUXV size calculation when ELF_HWCAP2 is defined"), this omission
leads to a mismatch between the reserved space and the actual number of
AUX entries, eventually triggering a kernel BUG_ON(csp !=3D sp).

Fix this by incrementing nitems when ELF_HWCAP3 or ELF_HWCAP4 are
defined and updating AT_VECTOR_SIZE_BASE.

Cc: Mark Brown <broonie@kernel.org>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Fixes: 4e6e8c2b757f ("binfmt_elf: Wire up AT_HWCAP3 at AT_HWCAP4")
Signed-off-by: Andrei Vagin <avagin@google.com>
---
 fs/binfmt_elf_fdpic.c  | 6 ++++++
 include/linux/auxvec.h | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 48fd2de3bca0..a3d4e6973b29 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -595,6 +595,12 @@ static int create_elf_fdpic_tables(struct linux_binprm=
 *bprm,
 #ifdef ELF_HWCAP2
 	nitems++;
 #endif
+#ifdef ELF_HWCAP3
+	nitems++;
+#endif
+#ifdef ELF_HWCAP4
+	nitems++;
+#endif
=20
 	csp =3D sp;
 	sp -=3D nitems * 2 * sizeof(unsigned long);
diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
index 407f7005e6d6..8bcb9b726262 100644
--- a/include/linux/auxvec.h
+++ b/include/linux/auxvec.h
@@ -4,6 +4,6 @@
=20
 #include <uapi/linux/auxvec.h>
=20
-#define AT_VECTOR_SIZE_BASE 22 /* NEW_AUX_ENT entries in auxiliary table *=
/
+#define AT_VECTOR_SIZE_BASE 24 /* NEW_AUX_ENT entries in auxiliary table *=
/
   /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF=
} */
 #endif /* _LINUX_AUXVEC_H */
--=20
2.53.0.239.g8d8fc8a987-goog


