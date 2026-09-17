Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ADA4C982CD
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FDD16B0095; Thu, 17 Sep 2026 02:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE6F6B0096; Thu, 17 Sep 2026 02:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C5D06B0098; Thu, 17 Sep 2026 02:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 474376B0095
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:56:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0237A47F8
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:56:32 +0000 (UTC)
X-FDA: 85222345824.06.B3F2040
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	by imf19.hostedemail.com (Postfix) with ESMTP id D59D31A0003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:56:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=ROJs14Fb;
	spf=pass (imf19.hostedemail.com: domain of zhenghui.hao@qq.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789628190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXj5mWDpDOqjhTb00e+XGy84HCvylbuQfYwN5uzyfd0=;
	b=5GOUZic+pv9KmnOLX34BChP6JZhuBjs0YV86XR438/frI2U37sNhPis7BPKYqMoBc6SPBP
	xC5SRU5AOcfY08Ic/baFxXCVmMNq4IPxexu0v48Z0IFu7gGXS40fSvkJZ02JIy2q73TOza
	avUS7T88MqwqMT8gdys+n4OkHaB8zUk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789628190;
	b=mKv6popanQWsoIR2EL+a2fxr0w43lejRBx0KXZleVcbkW/6DJbYewJ/JYkIW9GkxFKskDy
	01VEjsQNElNF9EsXvd1ONn9IeveaDid1Tkk2DEecolAZdOuso4B0ZS85KR6ckkzOlqQ3RK
	dIrdVutPUx2fbeuvNUc1dTEAzCKZQ/0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=ROJs14Fb;
	spf=pass (imf19.hostedemail.com: domain of zhenghui.hao@qq.com designates 162.62.58.211 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1789628166; bh=PXj5mWDpDOqjhTb00e+XGy84HCvylbuQfYwN5uzyfd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROJs14FbPxVJpvdJv2LuAGMh0r8D4/uUKup7h8VZN/dzfAqRF5idLfyn4lKULwa7H
	 CulJaKURF73oGuRnmsyBZ9d7qSY3bYGxg8Xawquz6aI/YU6RTTtJV16MGm9GLNOv0o
	 xYC1VnUJI7MmnaGtWTt+NxSi3Faac5PzJjOOLmAQ=
Received: from XJSH01426.meizu.com ([210.13.72.171])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id E0103260; Thu, 17 Sep 2026 14:56:01 +0800
X-QQ-mid: xmsmtpt1789628162t7il4l9db
Message-ID: <tencent_5B0AF81532EB30CCA672E144A475625EAB08@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNznUYzJAzdxZL7clo0Cw8Megp5KcEry5FLmcnF1PBKjb0Jn+Z2/ty
	 1NAsWfFolJNasymySCRGUCepec7QkFYgn3ziPoXirYS5OPJkIf4dbkMXlcqSvjUJ9bopRMk/uIXa
	 3t5fYiKTTUisQuPK8bwWCeQB60zcobFfH/8l9gM/XCVSS1F1GMHXSmHGN9JtrbgPvVENMmPbZP5R
	 oc8Aou5NVPKJnJ9iKx12OP0dATMGy3HX9JojyDdzGe5/Os36Tuz+dF18RRduPHADgcLrAaZ/TyjC
	 65LP9PaCdgAWxL1QNrHcwUUD9wTqEtrRxG2pbN0rkFBPglrrV1CkukfJR8nRoLzoFjjlBKrxMMU5
	 bJmy0bTOHaaNkA4CKDfzsOF2YToiVCjBC2GvqlLYO3cXLYGm3Vubg1wqdw0om08JaLbVivufkr8s
	 KcH/P5oxOXP8gjV4u2KrnsYye+Dszo1OIJXTuZNnuTz7K60zmZU7JIVjk3wL4kGIYK/6ENwWCpuK
	 JncnHNeq3RNMSFdyaVMXa6Uex0BocMyPEVTLCAiW/WgB/F1vfN2bqUhuMgTrHeGIBzwxKm/8eWvO
	 Ni5JI9qduMraRdFAOgn6wp/5XzNdHPdj77dZ2IFcN/25SkOzX36XI8xTHdzmfuHdHhVe0OuOLrr7
	 0OcA5Lx1MFvLkrjM9DhuvRSNJsctvnbOogrN3KGA3YtRwaWCnTpeIE231muIkjb/1Fej92Olf5tY
	 ju4cbT8jPdLf0gVdwUsSzif6EJTOGUQddhLELZv6c4v/pGTPv4dc8Fv4ODkpRTYWVQHPetj8PEGR
	 0WVOwV0egOOOf9a5CQXnX173vr+QnC+xhHrjjVMv/IW0YsbCvzQEtB/+k+3ZKBSoOhGJTSYFqnjO
	 FBdM6Q7hOhqBNyZA905JVR/0TgPAGjKHudnWkuO76YB89Yb0kt6ke8krUB13fN4SOvTTwMBfpWBh
	 MsNfRynpr4Sy3/nqyBMeGO9sZSz5F8h8HzjoC2WF7X6ziAipg3s/Ia2S90Dl0H5P+UJ2spC6cYZ1
	 RsOPYCHl1tTQdliiPB8In8U6v9FKbKpdcO12S8xecAUTjs4gocxKMdCnuOrAiecjPK5xvRy7tgzC
	 mjo19XdK8mSMXUCgzemYyvaGqViXnErcyoM4Gh3whL1DkAHRVUuVXLeqY97g==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Zhenghui Hao <zhenghui.hao@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Helge Deller <deller@gmx.de>,
	Christian Brauner <brauner@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Kees Cook <kees@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Lillian Berry <lillian@star-ark.net>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 1/2] init: parse early parameters before memory initialization
Date: Thu, 17 Sep 2026 14:55:56 +0800
X-OQ-MSGID: <20260917065600.564083-2-zhenghui.hao@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917065600.564083-1-zhenghui.hao@qq.com>
References: <20260917062837.558251-1-zhenghui.hao@qq.com>
 <20260917065600.564083-1-zhenghui.hao@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D59D31A0003
X-Stat-Signature: 4175dc6fwcicj43dm36qsturc19akr79
X-Rspam-User: 
X-HE-Tag: 1789628189-794628
X-HE-Meta: U2FsdGVkX1/cPId8zFAcjGw9vGsV5nUvAn7Em14h7gV/hCfxd8TdwhKbJy0nn6E3ToYb22sIfd7PLoEHRRl1kM/aeYIEdQ4NzNfLh1demt3/0OLf8Tsc0IRwOiA0pDqANt25vWXcH7+JMwuc8bogqytEzdvf+uEdVJ2WzGZkX+CSpLjCIt0BfYw5axpe0YAhh7OvU7NmfkxOy6PrJjggg/OhcFqerJ8y9bIfmlKaqXaCiRN4SqjJ8xlsi7K1B/GMVnr/0lISsp3AbgvUcnTHNPk9RzKpAlskOEOuIBEtjmQj7IdmpKQ3kXJcSHLWF5JDk6lOEqDvvDonxW7IWnrk1w8muTK/KoLRlDMMc+KODpdbMTxhUhrvOW4hkjO82suQunoqTFKrPk6ug2jBm0u7tM8Q9gfoweGlJhhJdVxw7uTQGHLvew55/9NFavEm3hrws9LNCAhCAHPkuNXO6mGb2hr2IXUNw+Mp72ts79cFxWMM3KAHQDz0D5FKVzVlyUKze/6Z19be4WqbhgnYk5HJ6OYF7fJsugGCMz/5Q9aFnNMntvqww8HTKLONqfGgj8btR09Y2cxsuEv5jtYYb690kYCrOfR8G/K2R6jCbVm0OMY2Jg/cKy6XVMzss+09uUZgdYW06oCepZbg+Zs1wlmMo80dgtQnGlJrVdADPaCf9ryEFsK4kjb4iFS+TLXXJwReUehd4vbTFnbkl/8BlHvCQ8gE9d591Bf3RqXH7YpShdXq3bxUHp4CyjDISX6PfjTy043thw30KEnfwLRGg0NrKaCUlF9NVa9CnAtD1agIRcxLnjYzQfUKrSQZFkM2UckNMiffd/VUbsHViw0lwFgkwNOYNabMP+nbKKPp0I3q4qroQqiUz5y17NisN1UQr0Jbx4uQh84ZJtlYgeNQ9XV3laIrSkTJtQpomHZ4l2UQ6P8qlcK/FUO9pBvKDxTGrZASam7eb7fmuyDTb78ESI+
 6HtZpggQ
 183MBBT0E3Vnh/KVRXASULbi1JSOHFIJCpDWuOyjAr+oTOKFNskRaQZzhEvoYJjWnpdJjKz7ArnTVwO01UIkiAyJ8Vv9ScB2wfGXoxFi7SlsAXoYxryzDXQoctTwvS2ZICOOKgYpOHz8glr+58k/BK/XyTctk/O5SB0D913QiCzxGUvgChAxYDmU5A0HorbLDmJP9XZVn9GD2TAd+QTmQZCK0oDmpyjOoPZe7R3zUstAc8kz5Wj/MGlrbveFZ0VJ1CHJtqaWPsXui2MmNm237DFmbefAfiNSacwKS3ekD63b7UFCBpE59+jrkBG8nbaWynTr0ZiLVLabQaP2L95HA6EALYZjmPBY7GIuTo+7Vpq11zCMsjKz+NCpml5rFZsRalhgBiwBS/iM1Yb+H/fuIwXp7DC44OkQ8i1Am
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugepages=, hugepagesz= and default_hugepagesz= parameters are
recorded by early_param() handlers and consumed by
hugetlb_bootmem_alloc(), which is called from mm_core_init_early().

Commit d49004c5f0c1 ("arch, mm: consolidate initialization of nodes,
zones and memory map") introduced mm_core_init_early() and placed it
immediately after setup_arch(), i.e. before the generic
parse_early_param() call in start_kernel().  Before that commit,
hugetlb_bootmem_alloc() was called from mm_core_init(), which runs
after parse_early_param().

Architectures that call parse_early_param() from setup_arch() are
unaffected, since parse_early_param() only does anything on the first
call.  On parisc, which relies on the generic call, the parameters are
recorded after they have been consumed and are therefore silently
dropped: neither do_early_param() nor obsolete_checksetup() reports
them.  hugetlb_cma= and hugetlb_free_vmemmap= are affected in the same
way, because hugetlb_cma_reserve() and sparse_init() also run from
mm_core_init_early().

Move parse_early_param() before mm_core_init_early().  To keep the
"parameters may set static keys" guarantee, move jump_label_init() and
static_call_init() up as well, so that they still run first.  None of
the functions called from mm_core_init_early() uses static keys, so
running it after jump_label_init() is safe.

Moving the generic call, instead of adding a parse_early_param() call
to parisc setup_arch(), fixes all architectures at once and makes
"early parameters are parsed before memory initialization" an
invariant.

Not tested on parisc hardware.

Fixes: d49004c5f0c1 ("arch, mm: consolidate initialization of nodes, zones and memory map")
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Zhenghui Hao <zhenghui.hao@qq.com>
---
 init/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/init/main.c b/init/main.c
index 31f2bf54976a..bccf521910be 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1007,10 +1007,12 @@ void start_kernel(void)
 	page_address_init();
 	pr_notice("%s", linux_banner);
 	setup_arch(&command_line);
-	mm_core_init_early();
-	/* Static keys and static calls are needed by LSMs */
+	/* Static keys and static calls are needed by LSMs and early params */
 	jump_label_init();
 	static_call_init();
+	/* parameters may set static keys */
+	parse_early_param();
+	mm_core_init_early();
 	early_security_init();
 	setup_boot_config();
 	setup_command_line(command_line);
@@ -1021,8 +1023,6 @@ void start_kernel(void)
 	boot_cpu_hotplug_init();
 
 	print_kernel_cmdline(saved_command_line);
-	/* parameters may set static keys */
-	parse_early_param();
 	after_dashes = parse_args("Booting kernel",
 				  static_command_line, __start___param,
 				  __stop___param - __start___param,
-- 
2.53.0


