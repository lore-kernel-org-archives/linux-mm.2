Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E6A4CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 01:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397776B0005; Wed, 10 Jun 2026 21:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348906B0088; Wed, 10 Jun 2026 21:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25E7D6B008C; Wed, 10 Jun 2026 21:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 140706B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:23:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CF358DCB5
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:23:15 +0000 (UTC)
X-FDA: 84865883550.23.73FE38F
Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	by imf26.hostedemail.com (Postfix) with ESMTP id 78033140003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 01:23:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AZLz19S0;
	spf=pass (imf26.hostedemail.com: domain of enelsonmoore@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=enelsonmoore@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781140993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8WT+fivEx36NO5awPOrGIa04kuZ3OK/PwrNjHMoyylI=;
	b=VIW18UowNMwakCjCXnWROLal3TH4QBUrLUZa2Ogpfw5ZxumF0RtbbK4vnTEt0FJ08hSe7R
	uCQ49ZC22Zqbmo9COgg4ME0xGBJTfsmq0X5hLNdJEAEIHJ96oTusUYWo1eYxrBGYa1uaeQ
	YqBZF0BIttCBxPleEhOgNWO5pnQeVdk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AZLz19S0;
	spf=pass (imf26.hostedemail.com: domain of enelsonmoore@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=enelsonmoore@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781140993;
	b=W77KkLBJiBf9pUIWgAymc6TTpn5i7FlBHuocSq0YCD874nN8/3DYDVIrzNOQa8AjYEVUsj
	iCarYOL1uIc9KxPVJe8k3eVC9S/7o5oASLmd2ZqnekwVCFEp39QS2Hfh6HjtDSdA179Jr8
	3P4mKmsBXq9m9d35YZIEVprYGP3D0UM=
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-13809223fd4so7283504c88.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 18:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781140992; x=1781745792; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8WT+fivEx36NO5awPOrGIa04kuZ3OK/PwrNjHMoyylI=;
        b=AZLz19S02ySgnGkLYACWwM4Jtg18ZZup46OjLslh9Z6enzFpKymf6eBuOKy3AU4s0s
         rXw3EMZe5CfO9vo9+/8lpcvk4eAtsyxCjzRcmqMLFtQvh/m/pTypgyH7UVyadpRINeP2
         3irozAL3EZeYpMHImv7C7BXmO9iwcvYhnD8GfOhfm8W4CUADFw87J3R72Z6Oh5MC0IC0
         AEgR2b96khfVxWMAnmJf0P4deNw54vNHYivoMSrzn2CrF9VeN3YoRIYqEjuCTz5mhR3X
         RyyiqONLps/NiSPnbQzKsjLRlSVIZkqa6XUFw21V9zXq4xVBaeudAjGZ6MjLXmqpc1go
         WBCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781140992; x=1781745792;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8WT+fivEx36NO5awPOrGIa04kuZ3OK/PwrNjHMoyylI=;
        b=oE+c3G4+f7mDA9J9EFT62dWe+Ofbb2N+FvNsOCQjilfUj348PH9CTrweQwio037hTe
         WDp7rUvUOZoIAl509mrCAseo9Ldd0ZI72afHYfUY9rw5EV2y8PV2COWVMMRyhQTmjIiS
         VPZnZruvw0sZc4vIqOexoZRgAVLlc9PQNxA/TwuGYuivf1TJk0kctQnUh446NcZnSMTU
         6abSXNhjG714yO4j8Y6J5MsEBlviM151pKOxD8YM0pyRlYbFwhSpgQBuVr0b/UUVUqjQ
         MmpL7brfUOTVzrfOnuH9MQ7i9USqskInzjK7cltab/sXbhij/s361wNhhyP6rVnZtwkb
         Cwtg==
X-Forwarded-Encrypted: i=1; AFNElJ9reLC/tATrGmjHkzNFbBNKyMtfXLby5TlHVM3sDGeSBxJ5UQzZhM2a7/KSAQEPikRNUfSmLzqrkA==@kvack.org
X-Gm-Message-State: AOJu0YyeeSvtdJM3+gAa5w+rIYP9wdanxZ6DGDZOGp11Ldebfns/NRx9
	3VPOLKBkqQE4DHBLzfoEm5Fuoyn3EPLlj+5BNt9k3aZe10+90kdethN/
X-Gm-Gg: Acq92OEnylThuxdu3CHr/d5S7XBp76ew8u1X3RIyKaJO+M4vZqHbsZgLVLT+8kOURbz
	wJVW37SiDZ0boObJtBcVoT2dnUtEtzMjRjyQgMMDBSHRRdaIjkTs5AV+2cNih8cItq7wwsjHY4S
	CH+iAkF0+OM8FDaZTRNba8crKI7aNWLKdv6loJqEPgi0Br8AuxAV5jFsxu5igAzi1/s4Axfb0Zj
	cL8a9gVouZgeQ7PUnCzygK7DBg8C1GfhOyzy0sPRiHtMj1/b0uuXXiprWUdiJi3nCEvTiu2eCf+
	F2kzWJswaIlyw5n4nc+pk+zrFl1pLeTQ3TEj/0CPl4oTLmrHEGBzZTz5mG2z0Uzkhfp9m7CLXep
	s2TDriKwqaWI8cS6TZxaPg9yi0mLSC09BPVW4RusGywNGpVFnh3e4db83FijBdF/yD/JxgfMW12
	nKvhUI4c1W5AmxinCluzmy60Zr9MsONyB17/J78U0m0u+BMnpb+atv6d122ODS64sfgBE0xSAXo
	rrmdvIS3aJcu9sY234qcWtPlODfXbkR3le5dsf9jHuj4CCj24qvtL+vxQxfOBpGoI13mlEj/kUC
	PQr1mFVDrjNYUuB2fp2uHLGkYE/x
X-Received: by 2002:a05:7022:4a1:b0:138:42:96eb with SMTP id a92af1059eb24-138422cb8e2mr382496c88.17.1781140992031;
        Wed, 10 Jun 2026 18:23:12 -0700 (PDT)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13842f81b4bsm290810c88.1.2026.06.10.18.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 18:23:11 -0700 (PDT)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Alice Ryhl <aliceryhl@google.com>,
	linux-mm@kvack.org
Cc: Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm: fix CONFIG_STACK_GROWSUP typo in tools/testing/vma/include/dup.h
Date: Wed, 10 Jun 2026 18:22:44 -0700
Message-ID: <20260611012258.432043-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 78033140003
X-Stat-Signature: cwhyauaqjqkarrgdqwdjxz1oo73sgzhh
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781140993-77495
X-HE-Meta: U2FsdGVkX19fcMgnHBG1eKnfG84GAo2MTfbSBv9nHxv2wA0mj/2S+vmDzCIgr54WXsDMd6HkhlT890wvmRL0dd5yyD/bSw5im0CEy2e3vBjBCeQ/W3T8NaMbYL7NfMKBf0qRzVtqc659hy1CqOjS4DlakLx6recNbGgvK7eW9ITWUs9Qh8lMYS4wJP30QpI/60W735akHxkuU+8UW/XD2MJ/eqJ8iOy/POhK1u2mKzWD2jnWFXSz9pls34NMG77c/ZIM2RXdxpEr5r/5/UkgVOZU5Rwn8oW+OmpUwmb1nXpC/JIjZS7+av/expa7lawLl71hHlhIhkpUYq4gsF6QTItGQajhHE4rNyiPyZU18fafwAkpiYkh5tGMMA+NOML4uix54bj9AW/t/a/U36Bqqwlq447qsz9pFvxJM1BCXln2L2L0KCrw5oNBQSChSSB0za8bkSiW3U8y12sxFdXYnjqOP7WyOidyrwIS+biNyLRqD3IU8NPzipQAaL3O8EM54sqxSIiYqzeByN5dyJVBDI/xLJBMHxw2eIr2sLe5uNzcTkxL44lRSz9Wr4Yp2jtvp/1ufV6dkp6XYL6UiC8NwoBAIhYaOPITWIrCO593zQfRvYj9c04BPKUs+85M5c3pTWt9K8prJ6WhJue++9lBFbTi1dBStlUOR8fT0klymIULfnshl0gERETMIPBqR4eSRBlFZzoOEBJLXE5SIt7FoEApea//4fmCJo3GTDtYMHw7UzVj5TwLTEPsSOq/Ri1zuBrr22a1lsvvAJuGLoAcrGPakuMcMfUGF84es8ARtQbgptydYVY6oItZ7oB+H/m56114pe3S3vuLJ7hHZQtqJVq8kUguZj1pLMMMzdvWi/9kT8oLRjaRq3Ku5kUaSoQgOkgeRqOXzs6tk9nzGonZAc74FM7f0JNRLUN+4NjtZgoDX2OGF7J+29rb7mPmRwGpXgyWy37wuRShKnEheQo
 UCQ7DKR4
 /f9p9SnfZ6p8mo5O9QQ7hg505IwqSJERL2hq+QGp73Vp7ZlycZIql6HtUX6Bxk/OrhV/VpqMW/ZOXSHu+cklLzpgKb8aBobMIPVi22s1bGBEXiVk38PzdlbgO3G0Lofek2VsX3UHBnhQMw/FU+br9TbD/vvlFFulwGcK5mwOO8X3s/Ne/Ut/QvktmK4p4wmf/4Ao9yZkn+eLLoD3+Hs3LqxjEuX0dukc2osYT5f0HqjkhUToybZTr9rqzzWGixjuF6LoUo0DMsQTqsH2/yjkIWzv48iHLZDSyTUzv6LSACHGtfLmZAq3bzK/a5AFRTgfwrhSpynwudBNdzdi4M2D8UJel7sJmKVpS2bf4XhZ5F1vgPogpQWSzzFeAD5U6EkM5GhzaKFZrA/dwCRqwXDBEjjZ8QUowp6TVSHCr1qcIIm7QsGiilQca2dm0yZrprnYSMO/kNTeHoxLToI8MfkXTmyv04C2gBjBFJjp4az41I/tSLOiw2mubngwo6kWu7Yv8Na6e2IZIsTA5Zked9vuHbFIn0rN7bFjP/vdzOtL/ZCGj2XoMNC2e7Z+1ZyHserEYJnw+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2b6a3f061f11 ("mm: declare VMA flags by bit") significantly
refactored the header file include/linux/mm.h.  In that step, it introduced
a typo in an ifdef, referring to a non-existing config option
STACK_GROWS_UP, whereas the actual config option is called STACK_GROWSUP.

Commit 40a4af52e047 ("mm: fix CONFIG_STACK_GROWSUP typo in mm.h") fixed
this typo in the mm.h header file, but did not update the copy of the
code in tools/testing/vma/include/dup.h. Update this copy as well.

Commit message adapted from the above-referenced fix to mm.h.

Fixes: 2b6a3f061f11 ("mm: declare VMA flags by bit")
Cc: stable@vger.kernel.org # 7.0+
Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 tools/testing/vma/include/dup.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 9e0dfd3a85b0..adbc3179085d 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -243,7 +243,7 @@ enum {
 #define VM_NOHUGEPAGE	INIT_VM_FLAG(NOHUGEPAGE)
 #define VM_MERGEABLE	INIT_VM_FLAG(MERGEABLE)
 #define VM_STACK	INIT_VM_FLAG(STACK)
-#ifdef CONFIG_STACK_GROWS_UP
+#ifdef CONFIG_STACK_GROWSUP
 #define VM_STACK_EARLY	INIT_VM_FLAG(STACK_EARLY)
 #else
 #define VM_STACK_EARLY	VM_NONE
-- 
2.43.0


