Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 384EDC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39D26B0363; Thu, 24 Jul 2025 19:37:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9E06B0365; Thu, 24 Jul 2025 19:37:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDF06B0366; Thu, 24 Jul 2025 19:37:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65B396B0363
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:37:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D5F3140573
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:15 +0000 (UTC)
X-FDA: 83700771630.19.A371476
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 42C9C100006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=bP40IkxH;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvHRga/2x06e/3IXRCXpOvSv81ZyfpTLSHYXhuUCgAU=;
	b=46pxN/X7mpI+3UHo4kCd6xLZ+sUqPCpfgVfnDbR53cEqAO34KydL3c8PUdmWe+O7aYEj3T
	ClvSsC0NSaOPeG/VBgT2OjIT8vnEh/nAsJUPOUfd+NTH5MXs/G/5UV4XyC5Zeimq6jKkOp
	egj7vlt/Zt6dsXSRCROGFAyQ2Dasrt8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400233; a=rsa-sha256;
	cv=none;
	b=B7TUvJv984Iuxb8s7OE75VlvzKdpPi82gumRGMhi6Gm+r0ey5UTMd8VEK6FF0mxw2C+afC
	txpk/PzERVXLi7auva1D+opfxftdLPrZmGVc2Z4Lazes/iGY6b2Jek12lUm6Tn4CY49KbR
	Tp4ZIJ6DkDJla4kd8RnjxMaAKEqVXfI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=bP40IkxH;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2350fc2591dso19146425ad.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400232; x=1754005032; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OvHRga/2x06e/3IXRCXpOvSv81ZyfpTLSHYXhuUCgAU=;
        b=bP40IkxHuFAZoTCkuUqWJfRR5IetlSZ1Q3d4nVV6A0IS3aVO8ooIyHHRO3D78lrmO7
         hUUEdNv7C4/3GVCNOO3yAp5Og44Vi9B4oDSUTZAxis8octLyGhsk+wOyCic62GNuH11F
         kqbAnEehJYecqVjD7DtHP4ju25yWAZJoa4o8JY0kZxHYYZ3C4mVdCMAUhsyjxjVFCfyI
         PikbvIJXSfq8/b8orFt28F14imkAeeQ95Cm5eokwzfshzOPKkZyG8jHGpW9Hrfh9lGp3
         M8LgUHOP2535Oz+69fqWQPwMVz0KTs/EqXUhndrwEqB0S7dJ/gJcmzNrJkU39LkyONAm
         K8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400232; x=1754005032;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OvHRga/2x06e/3IXRCXpOvSv81ZyfpTLSHYXhuUCgAU=;
        b=rCOU0mk7vkBY4V8Sd4/O29kvwOYru7iO2Bd4w5KSTaPn1/1otVClqEusRnSltDSyZL
         DhzclojF+XJkIJr6gWmRere4UEAuBwt+QcqxX3qfNgtrnaHGhU2i8mKTZj1ha21VffzG
         Z+tcLaoZIG+FyX58tD4tLOvQDBoypPH0UVYZZYUdkyQYIINkUxXMr6GVkdp80Dx2mbzW
         G4hO4DASs3N/3Q63qCtDyeMVN+kOIjt0nHoMxxHj3/59IQ1Gh3q5ludZhWYR3sM1s+le
         A2rlzXNLhBdV3J4XYkWo4m3VH2Kro8Lp8HhJXqznz/1QrAoEg2UJgQ3dT/BvZj6F3cUx
         av8w==
X-Forwarded-Encrypted: i=1; AJvYcCVkK2WNsCjBR1otF19u+rKi35lIW6QppMPU/FqerEmDZYPfJSaGt7TEuysHfmDOS6qBzue4J2rEXQ==@kvack.org
X-Gm-Message-State: AOJu0YziwfxTVPpfJMF4nIPXej/N4/wInr7TPSJ1WzpCmquygb7Yuhz5
	J7Ad6xXC9oscKvSC2ARNgcEaCo4/meUmsW3KTKxS+cDbTgD6Bb5fD5JUtSsgTH7qbrPiiJWWAHO
	H1N7g
X-Gm-Gg: ASbGnctlDbeC3C7O4kILFtfs2oV7GhYe0ydoj37oPhMnYLg8/yJ2CSCCRytLHTruwHo
	s66TpE+CVL7dkew/bVkhZIcvCtY4UCQ23zZOvllK0NKgQ0zed/dbbuZeBMivZGBu5fHPREBow3x
	phhuYf1PqmUE2lowVk6h8k8ZXXI8VBFwMQemt0C4Nau6zTheQNY8NnHhx3GjKJ9q6kLEwbRQOx6
	nQrwQaa/S6Laj8/247WKZF382CsTAoyaS5Ig2StN9k6mPT5HX4McnBAAoMifx+1pexqnEMok1AJ
	IujHMAjsbMpoUOoESbwysW6OY8jLUlbUbZnQfZGTk335laaYgsb7nLjw3Ffyyvd+KWPwSLDhRG0
	1Jh9aqnl++pBXqkqp3G8ygoamjhfzd8+N
X-Google-Smtp-Source: AGHT+IHlehaeba0g7zvJWooWl20RVESgD35SdGjk7uZPTtlJW4lACDouf6PruSCC8hJSgeGX0h9FOQ==
X-Received: by 2002:a17:903:28d:b0:236:15b7:62e3 with SMTP id d9443c01a7336-23fa5d12ce3mr54400555ad.9.1753400231958;
        Thu, 24 Jul 2025 16:37:11 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bc706sm23598685ad.106.2025.07.24.16.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:37:11 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 24 Jul 2025 16:36:56 -0700
Subject: [PATCH 03/11] riscv: indirect jmp in asm that's static in nature
 to use sw guarded jump
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-riscv_kcfi-v1-3-04b8fa44c98c@rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
In-Reply-To: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Monk Chiang <monk.chiang@sifive.com>, 
 Kito Cheng <kito.cheng@sifive.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 rick.p.edgecombe@intel.com, broonie@kernel.org, cleger@rivosinc.com, 
 samitolvanen@google.com, apatel@ventanamicro.com, ajones@ventanamicro.com, 
 conor.dooley@microchip.com, charlie@rivosinc.com, samuel.holland@sifive.com, 
 bjorn@rivosinc.com, fweimer@redhat.com, jeffreyalaw@gmail.com, 
 heinrich.schuchardt@canonical.com, andrew@sifive.com, ved@rivosinc.com, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: kdim9pmepb561cz9ke57fhr33emu3sdu
X-Rspamd-Queue-Id: 42C9C100006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753400233-632930
X-HE-Meta: U2FsdGVkX19AIJZWSc9ANP/i3hum/2cnHfQZpAWMFDts6pkEjzb91yeIfEVo8agqy1al96+5O6cSgBKwok6ihBNy71pReA5sWNTcrnJ/KlLyWxqwC4ZSIwEzlNFuUTKperjfW2iyTecxVBhT8YogqlGBy3hV8o4a95AlMvdGb9FVLC8NnRboHj8Rya+hjus9yd88UyZf8pTHtOQq2w6AJbGqUuw5p/ngbdjtgTNZOY+1a5cjn7ICLRdhN2V/jvN56bOXGUpaVxHSjDwAotdTPCU4jcyJix8M+Nh+TnrbioznsmlmZystqs1B4omOOoXFBxfN+nxVT0SwX/6KiLIDGElL5SqvHqs4IPzTROL2EVpa9GnBBeP13f7pUIPDt2vfq4fKFzUsP+b2rK/hPkqstFW4WXSeFo8rlm/1vXY30SEMhGCwf7hAnTYnZm+CFPR2+ujzhpBgoEawMJFhXyESFLW/wP6iJH9JL0KntAuc1KoXdWzgrBgyMULOTUJUboyUHl5+bA6TjZA8xVvnOi/7doO9DFK0bdTNqvQPgBDOR38PukXUQDEU5dqJqzVAI7x4TgdsZVSht5rzpkHuHhypw033KxW6PgQEXX/YrpFWkQKdhKM9BEFVW8ksduQPXeBIYaZtibyq5kvyZjVHAZxH/fpOiJ4BnvNyYITmm3evtjzJLC218IHgayxgWtuHFCvIFBgK6jDwA0eJd6FDdbmS/kPRJFAziEN2SjqbvKr/Y1H39GdtBnCmDVZxm45ivtwbkKXa+YF7r3CbV4uyKHbYoaj9e1kn5A5+6bdcSW96WLYVwKCn6t5wZvoN0mM375iZvFNq1LTqg7diQOq5Jw47hJBkpqekqLw63YFKx7vQUTq+u4MdidEd3c1jVVBFYka+guN5dVhDfjrIXtxWwv9IPYQqyHycaUPdOibO38x/LJGKb4i9FmsZl1/KI0xwLK1+R3HwMOq8DuCOBey6Nig
 03vz8z3q
 qM4gAVTfi+9rT4nmmiNcy3wkXRFpTeiLHQ6Vw+j5oC8NW1atsfAcqCRwy0UoSLjyIpWBB4EK+r0buEq7fZgECg+65Rkd72dyqM3a0jc3L+xV4Z+1LkSRl71yESSJhMkEBQJjgsp7TRPLBqxUX/tfX6sYuPeEekHfiRUQ9vNkxw4MEhMlFPCxSWPidf/p+qLgTTTdZHfyKK56WLQaYoE0gtPD5I7t8TYHf6ANIlQgzEBJI6c+thhlIx0wKOr3NP24o505+y8utsTRyZbOzmo3i68+8ZxokQ97RHJgKW/WhthnHQ2dsolkfd2qJVF0UqmzgM2lSIQY+lN7EtoVNonI3a7sEqBHB87tiYlAnfUCgVBtLSg2753nAN8L8gaBgMZu9uRpKomoFYCKwCwWXgvP11BUuo263nV8hQAcpp/SDH/hRgLeaPFkvr6Gv4U/wA/qoflcVmw4H1NG3Q5/nLDO2FajE3N8Xi9yUGpmy5mnIMX2lQEkpjBFLTkUqAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Handwritten `__memset` asm routine perform static jumps within
function and uses `a5` to do that. This would require a landing pad
instruction at the target. Since its static jump and no memory load is
involved, use `t2` instead which is exempt from requiring a landing pad.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/lib/memset.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/lib/memset.S b/arch/riscv/lib/memset.S
index da23b8347e2d..c4a318d8eef3 100644
--- a/arch/riscv/lib/memset.S
+++ b/arch/riscv/lib/memset.S
@@ -56,12 +56,12 @@ SYM_FUNC_START(__memset)
 
 	/* Jump into loop body */
 	/* Assumes 32-bit instruction lengths */
-	la a5, 3f
+	la t2, 3f
 #ifdef CONFIG_64BIT
 	srli a4, a4, 1
 #endif
-	add a5, a5, a4
-	jr a5
+	add t2, t2, a4
+	jr t2
 3:
 	REG_S a1,        0(t0)
 	REG_S a1,    SZREG(t0)

-- 
2.43.0


