Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B207FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C326B00A5; Fri, 24 Apr 2026 15:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD846B00A6; Fri, 24 Apr 2026 15:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4085E6B00A7; Fri, 24 Apr 2026 15:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6636B00A5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:17:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E47291602E7
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:12 +0000 (UTC)
X-FDA: 84694407504.15.BA5D3C4
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 20AA5100006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tGcGFDdS;
	spf=pass (imf05.hostedemail.com: domain of 3tcHraQgKCD4xyj0jsxilttlqj.htrqnsz2-rrp0fhp.twl@flex--stevensd.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3tcHraQgKCD4xyj0jsxilttlqj.htrqnsz2-rrp0fhp.twl@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WM5wn0gMsIuTgGRwyT/97PaVP0xOF656BTt5vV1/wNU=;
	b=Bz10zRVD145t2CVRoJUVy9NTVVHathl2K12RWZaHADN6RaXDki484Aa6LZXzM63WghYo3Z
	okxJCPOTWcmKHUIV1okfMnGlA4/k01DwqjgkUvE30GR1N+utdMKh0PmQvzsm1uW08JPj2e
	zu4UM5QmlPoBvquYqsjQC/8VU2wtKBk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tGcGFDdS;
	spf=pass (imf05.hostedemail.com: domain of 3tcHraQgKCD4xyj0jsxilttlqj.htrqnsz2-rrp0fhp.twl@flex--stevensd.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3tcHraQgKCD4xyj0jsxilttlqj.htrqnsz2-rrp0fhp.twl@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058231; a=rsa-sha256;
	cv=none;
	b=UiHW6aj//eaHQz/QmuTXsohVziAZ/j+++ZRFUhiOGXioFobVY3RirTVo+8daqPTELsMVwP
	3VCVVZvJ7FnbxASPdtdg3zGO3VscD+C/jblicZnqGKWvEo2ePdz3uRW32QG/xjgGtrqn+p
	7Z+j+P0cbmqJ3b37dHw/rJsJ0XXidpk=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-12c91ef7009so19770476c88.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058230; x=1777663030; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WM5wn0gMsIuTgGRwyT/97PaVP0xOF656BTt5vV1/wNU=;
        b=tGcGFDdSSyFoJ+koZ+SZnqA3ZHTRatTGz+dnwuu3q/7qOxcOdg2PclD/6lEQLBz9L8
         d8s0pZE7jPwhyk6i+xBrnBD0st+84m4k31F2fVSPB2EDEPBlMRx5vr7vxLdBMX+omp6z
         dcDhUbwfAc721wphmsCUSfNyBtW/XLwMzYLcNn3UJKK9TkLNO9R4j5E9IX7Y+DEsXBQg
         bWEuIEMcgSR7D3qv4OotHO32ud1MTAhXZ6oEG7YLa4geVNO9akcwcQF8a6jDSSaLNID5
         FOz8pe39g11/0NfuA3+hocX4g0Y34K5IdqYIT175VSQ54cTE2rHr/h41fvqfG0rHPtO2
         GWkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058230; x=1777663030;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WM5wn0gMsIuTgGRwyT/97PaVP0xOF656BTt5vV1/wNU=;
        b=c7mT17tioQh1R0UKwm8ii2uGox3Jx7U/c122c8aD27WfKkzDOHUj2CptAIlorKgKpW
         tZccKmCRE1F9izS7tB26DPXi3iCW/gdfufjSxCR11pN7cmWMn3A8jAYG2+ZNAmxkoAtp
         raCJ6xlVBHniw9rUALS22Xrvgzlok6ZKVTsnGe9nyFWdExEmG7qWmwmSYpZHyBv+NhSY
         FaIwJYe7tDCHCQHHP7WGRVIfKnbOMJlumkLDYjyEmKN0qorJbYQ60XEg3jfa3OQcorXC
         y/VrYu/JADFILGql7fl3D27TC05Z1O3qwJfFhlPEnMsIvqeF5eX6HyBmhc2ck0hBeqVk
         ryCQ==
X-Forwarded-Encrypted: i=1; AFNElJ+52TH1woVUjQ5sF/vy6A2lYanIwPoKR7bLNk1M2TQLWsr+tP9q8hwyiGwiOJqjdDbhB1lYcacjuw==@kvack.org
X-Gm-Message-State: AOJu0YwXPIH5HwtAjZbjA/qZIjEGN6B2aLepQwM7Pgn6PeJw49gai2qa
	xUmTD59Y4o6oAycUPkEWXKIm5geGMMrE5S8FQ896mAwTs18opXKmby0TDHPTTRYT76NhtHhpfC2
	dpXjLe/B1iLeEXA==
X-Received: from dlaj14.prod.google.com ([2002:a05:701b:280e:b0:12d:b28c:f5d6])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:2415:b0:12d:b26f:cafd with SMTP id a92af1059eb24-12db26fcc16mr6838722c88.5.1777058229763;
 Fri, 24 Apr 2026 12:17:09 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:54 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-12-stevensd@google.com>
Subject: [PATCH v2 11/13] x86/entry/fred: encode frame pointer on entry
From: David Stevens <stevensd@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 20AA5100006
X-Stat-Signature: wohi6xsd3h97guzr3r49am4aymbyh9xc
X-HE-Tag: 1777058230-468034
X-HE-Meta: U2FsdGVkX1+fPm0pZvEHpoO3geZ4aH/fTOpVcnLDZmAcoT+9q7pTSKusQtW6l2Is1A5OcRM+eUT2zMHT08bZiMvSNiCOjpPWrI4T3CSOWeoeVbnNHCWCzIqweQeXnHOwdTvTWldt/+IaC5gTbvC4bTz97O/92nmFUXXhlWJAdJaPdAVswmwcDmB+gncp+wse8gOL99YFPeZq78AXLatmX6lVFn5yEfOg8yyJgm9+aN6m+FbB2QL/UG5arz7pfDbMA03qYraF9CTXsFlqpez72++tYMxcDul5V6JqVjVXYMjioerWpYLj3doRT7R5HAbaA4A+S0hM7fszr8L0sETOjp7YigRVpVf1QhmM2eXONjWIddMALGZYvq9VzAu9fR1pcPHuzcGsb6VzFDpBmEB6BGN5dT1ac/glrJcXnkTaqKyj4Cw/sWAIxr7tvUYenG8llJs2N59bXinpn1DlP8iEe29KWnfLhXuastwTHmI2uoJdY6FpSPtIWNPve/QzUO04l8qs6U3IcQSHbBsUlMPbnjMK8b/qJirQSSEUxI1toHdcV0Nk/Cjhs7qMbve0y5vlJ1PpBcoBZyKgMdW0DQMSvneYkzUPfZReouVFnOvINr5XrzkI2ay9h3P4J2BynZqW3KfN04C3rwbeGy/Lo1dNm2f/nx+xSZ4J/5fbyCVVKrqpTfqLEU2UrS5s/v+OAfkIVSGNI2X1+nejM2szZNCzsnlzRF62CDpgQUxGInX8BZoq5f3keD8YM0m2gWJev3yhaX2l5l9Qb8ScV3Fse1zi5AtnSK3PgT5/3qVvGuKTQC9ccfrmHU42EdpjGrPxdrIN8ZB4LDJE6cnTj736o8rANlAUCXv4X6cvJzhChwv6DoVq6/ywbNOitM5uO6cs1TrcVdPB/HO5qDlN/9okSzahcV3rGFrewRe2BwmQ4sATiI+elxE/vYXZtM+WU7AMhdUm7XWACZlK3d0iPDbgtiM
 I8zqZmui
 /Mn9tA9Mr88G5Ux9HJEuK3E+hmAwQeTE6/HCmb99RUhlWh/sgAtbz/1Jw5+N/cwp6AOuEFGdsmdGRcdKYFBCYU8rcZj1v6cQLDEkXOK/SaiRJ1jHRrdzRTRMx/liGX1ZRbtdO3kI9IJrFEOqB1l7+d+pfqN9Y0q0RBNQtbNgck5Ld7GrbNxgw9ai7+fcMpDj664xJu07EnJtDNcDLZhdsiI+GzycSRd/lMwKTaEgMcAok3nNTWH+JGmG753eoX2H/t0ncWbPYkJ+b6gdLGnFxa5wKFTDJodQViQi+anbJv7CQJb9LUtjNdcPMqwA9o9NM8Swp3jEprW84p/jaFSjyeRud9pBDfJTqBja2srAcEpEVzvBk7BUGvL2iQhfJyMWl5Ta/DG6WRhsJsEnVpRu+x/YRtG//OXeyKjcrtG0KATdZee31MXZhFRh+8gM/FmT+fsNiURnUBMQz+HQ2Lx+RwYZHRLQy2281cC2IFouE6tXWCBS6lyRSrZPKySdwZsEkFT9IW3Ycb7ul2sPqCrOkaNd7bqEX1vmWpl6533zLij4bbNqCuWGqgB9Ks0hRF2fXBQTbS0/8zAMXasGMa8jZcTaMo3roIRWewGgz4M+inK5hSQRGV+nwIo2NQxCSaBTyVcKgMceGrps6oT1zb4dF2mu6DKMqoCFoCFJVrxdbyicxtP0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add missing ENCODE_FRAME_POINTER macro invocation into FRED_ENTER macro,
to prevent the unwinder from encountering a NULL stack frame pointer
when CONFIG_UNWINDER_FRAME_POINTER is enabled

Fixes: 14619d912b65 ("x86/fred: FRED entry/exit and dispatch code")
Signed-off-by: David Stevens <stevensd@google.com>
---
 arch/x86/entry/entry_64_fred.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/entry/entry_64_fred.S b/arch/x86/entry/entry_64_fred.S
index 894f7f16eb80..119b8214748e 100644
--- a/arch/x86/entry/entry_64_fred.S
+++ b/arch/x86/entry/entry_64_fred.S
@@ -7,6 +7,7 @@
 #include <linux/kvm_types.h>
 
 #include <asm/asm.h>
+#include <asm/frame.h>
 #include <asm/fred.h>
 #include <asm/segment.h>
 
@@ -19,6 +20,7 @@
 	UNWIND_HINT_END_OF_STACK
 	ANNOTATE_NOENDBR
 	PUSH_AND_CLEAR_REGS
+	ENCODE_FRAME_POINTER
 	movq	%rsp, %rdi	/* %rdi -> pt_regs */
 .endm
 
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


