Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA49FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F3826B0099; Fri, 24 Apr 2026 15:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42EA16B009B; Fri, 24 Apr 2026 15:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE4A6B009D; Fri, 24 Apr 2026 15:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AAD36B0099
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:16:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BCCDE8AE9E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:16:56 +0000 (UTC)
X-FDA: 84694406832.24.77F6CC2
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0243B160005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:16:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J90TYP+G;
	spf=pass (imf08.hostedemail.com: domain of 3pcHraQgKCC4cdOfOXcNQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--stevensd.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3pcHraQgKCC4cdOfOXcNQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JB7NKoMb7Kcix3lOCCD+xHQKh1dK9y1oER4KZfFKa0=;
	b=xBrE6+EBuIVxpw3ey1VW661MTziadt2or+52lxhAdpdSLpcRl7fbzOs2bWanZE+y1Y7DHJ
	TA1b4NJAAVAHtUS5krRMQwRf8rl1/c2W4db5RN04XviVqKFTTAo2BGaGz0q3tfBSE9Oghj
	ISE8gRUnOGeyaVmWcp+EEUTyjgwcQxg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=J90TYP+G;
	spf=pass (imf08.hostedemail.com: domain of 3pcHraQgKCC4cdOfOXcNQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--stevensd.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3pcHraQgKCC4cdOfOXcNQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058215; a=rsa-sha256;
	cv=none;
	b=UH8I11flAoyzO7OO8TOfjJS4yNlAoyI5CU1j1/m3bBvKn3HfayKSIIYbpWrMSE93U0PJA5
	zXDCq0j6Zv39hNPXsDMKluLvVhBr7tBDiSDWI7F6QR/Ylo+H8bzSsow2BGYlN6DFOv0avT
	OuoR/b6sWxk5Bv7WzHvB/37D47Qksd4=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2c16233ee11so11375505eec.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058214; x=1777663014; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9JB7NKoMb7Kcix3lOCCD+xHQKh1dK9y1oER4KZfFKa0=;
        b=J90TYP+GlcqIokqagjc1uhl37y4c/SKPf+2zl2vOJinHtSlbobHuZ/Pyi9KiiAawuS
         v4e+DaYmZolP2MvkNrdiK3Ufuc+ZfpGVPuY5VsXRvIPFdN02wv8ZqR97F9hF1Zb/ID51
         LY6wNRaVRK2mPujixt3dwd7ONePjqRn/0muDrYDxSs0U6sH4mumQhrML/CZkBRtzxKaH
         h+ryHIWZlIY25WNbaAQ7o6fiY0gtK/ZlZRb+wM08akBsDpa/3Z4GRWQ31sRiLlda6TTR
         2bKn34u0RALOUdMHvdGS9QZ/cf8eLbJxVzz01fInWwXTQzsh66bmR1aXEDJJ/gAaDuR0
         2fPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058214; x=1777663014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9JB7NKoMb7Kcix3lOCCD+xHQKh1dK9y1oER4KZfFKa0=;
        b=az0zR2aQ2CouMQQuv7ZePmLAbkiS7gDS6z0FlK14NBUXl47H2RlJXfSt1uP7L29MgR
         SueWPB9uT5JkaFWFe2nGDvEaLEZtde0jxzUwkXAr7fopIljQQt6h5aqVNeN1XFwaGUl6
         mdHLFrg+znDLtr1aMF3oHXh0dl6apJjd6J6myirbMWvUqu3U23KR0hsC4IOLH9g+f5ng
         1Wv7leFCyTZogbNV9bKqcKSwxRTGYSDPoRmcL6Uyx4183TyleG11rpjF//2TuyHT/w6G
         jHAUp+F5StzE1F8oCTZIRtIr0Sr5HjnqWQ1dZ3zru3t6wyeNDCW3ddw3Smeh+OFJaPFf
         xB8Q==
X-Forwarded-Encrypted: i=1; AFNElJ80Hd1P4UgzJvhHQoPILozpmQjQCCmvn6W5ptEEcKv/z0MvqTaOb7YNebVBtT7rDujDRAkZcwZ3Ng==@kvack.org
X-Gm-Message-State: AOJu0YyODj0ptSiKT6mpnOlkb2yyuZUi/uNeHadz2NYd4/uTVuplaKhF
	tKnZ6Q1H/muasXWOVfBqqD07ZARcLx37slnZ1XOIc6XI6gLBEnk1mMqxgcDmI0FPmS5zKh3O21v
	UUy2n2gAB+WDH2A==
X-Received: from dlam10.prod.google.com ([2002:a05:701b:208a:b0:12c:912f:7d3f])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2602:b0:128:d23d:81a2 with SMTP id a92af1059eb24-12c73f9ae5cmr16959290c88.29.1777058213588;
 Fri, 24 Apr 2026 12:16:53 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:46 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-4-stevensd@google.com>
Subject: [PATCH v2 03/13] fork: Move vm_stack to the beginning of the stack
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
X-Stat-Signature: z8nxi4ppnqepcn1sb3mj4si8uu81geoi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0243B160005
X-Rspam-User: 
X-HE-Tag: 1777058214-923381
X-HE-Meta: U2FsdGVkX19bQ/wHtuk1KZc4H+CBDzKWhL1pvuOEJi9sNaLOqPeTqjc+eAzLPief4FapsIyanhI2gUMWbK4Utsrl79/A/4rbx0DQpZZrzoBRn3QT9kE0MlXNHsW5DonjDAOwViRvYxFJtdXXB6v5XjZatxsKc4mBj//PZ9gXJ4uzJlsvpoeXXxQFBapUbqqjYPqXD0hM97oEgc++u4d5siLjR81l9pNaDPTs+0br0xF1LqnA3L+e53ia6bp1euueJNo4lYFOZukWRoob+/jF7UyX57G7uQjhJUkuWvZ9ieKA7lt1Qdj44CiiXEyMhuTkoh0mC/tvv6BR4GESp6Zuv68lQHFcpLyS/mfZ6jPN1o0mcAJB+nZcy9v+MCa2arzoXHg1CDhlXZUVPw5kSkl5Qg64gEdgc40mDzcwPMijvIrpKrx6pLvPPIpGr7M6JQLrkWHNUY+1E7b67Fnh965M3izvN8Hk4MWqwJTvNUe+e+CFs1dhU8iwpSNXSBIyXTKrzrt5zS9ZN37tWBJ4UTAcIsN3RTeKS+4tLcwh6rkJ1QSNldH4R9L2Hk2dRha4C0F7uuHKSK1cDW6zfenHwHh0dDB9UBl0AqC4PkN+9AcP7ZFTn4WRWkgzRnvByuSPMAPA9BFhQEtpwqs/fRujnXT8Jkl0HSn7XgLBfZ/YddtztplRYnWlpiyr9tSnYY8Ktghtev2CCbsa+xCnzct0upIlBaLhtPq89NAMb0QaxLDLvZcXifBMZ2F1GXhNBjpt3Z5YxGIN7Kq67pRDTkLG4oICtPrVJOgqlHNbITOHBuqGdoe0K3h1b9g8iBQf6rx9d5zCkF9bYkQ8biYNh7R6tDFEpVpOomhFrW+uY8YEjMS1AIsbvK1xzlNH88ZuNoo5XRdgeO/ldJD9j2EFqngc1lliCOLd3V1Mvbuvstn2y38Zh+Q85Nynk0KYmw1THGsDnQjAd9KCnDUu1v4wPx3N65w
 wixveBBa
 thuhaSUEjZn7zWUGnbkiJJ7Gt7RHdF81ndQoDkme2dw1wCPK0WcrZpUG/31cH0z32eSdzFDwZIPl5fQAScW5RcIwpM2dCtqLjTQddXFrwxgIKIE26PNwBXJDa3j886KWumNIttTSlsw1PYJgU38yY7ZuRCPiPVOsYqwIhWtK/lJn+JCRzNnGtkgj1OUekggpICGmnpW4pFw11hnuOXp+VniX4FNXtNaGyxPPAddoDCWUf1mYGEGFPyP7DaMLeea0xSaDK5DJzqWiWyTMayGiJc2ncWfNGzNsgeDs7LD/ue5Y3XHT56FZ1vaUE/jv9r9RDlTQAT8Tav4I0biLRh9mPsha86rltGec54Tj+jbM/74JvzQ8TWWYwYtE8/AXxG/l4MlSfIiNjQhK12mbW5KrTFFbFpqYN+2bHQ8X6xGgAloqvxGtZ4svEk0BNjtlcz1OxaBU8PE3JuIiB7tzfPAokpLFi/QTdXV6PsDhSAyPI7IdTS9d3+LTUglWAzIk9u7RSs1meVgcAaO304cisIc3Aptc1o4uc42Bg5qv0lsD5QtoBYefvFWE6FLGG5VJBmQszPXqzIeRoKy2twzbiuGQWGhIt2L/GA08uWZRshaQxN3qCivSLmNbdx+Dtr1Io0n+zr37aRy92M/zr3AoCzcT79PhScmDf4xELm5mNROglhIF6FQcb8UTxzlzUGjhiMg3WAh3MDOAUtDhOstpVOGszpCpJ3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vm_stack struct used to free stacks via an RCU callback is stored
directly in the stack being freed. Make sure it's stored at the
beginning of the stack regardless of stack growth direction, to avoid
faults on partially allocated dynamic stacks.

Signed-off-by: David Stevens <stevensd@google.com>
---
 kernel/fork.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 50772c0cc5da..72c081db492c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -282,7 +282,12 @@ static void thread_stack_free_rcu(struct rcu_head *rh)
 
 static void thread_stack_delayed_free(struct task_struct *tsk)
 {
-	struct vm_stack *vm_stack = tsk->stack;
+	struct vm_stack *vm_stack;
+
+	if (IS_ENABLED(CONFIG_STACK_GROWSUP))
+		vm_stack = tsk->stack;
+	else
+		vm_stack = tsk->stack + THREAD_SIZE - sizeof(*vm_stack);
 
 	vm_stack->stack_vm_area = tsk->stack_vm_area;
 	call_rcu(&vm_stack->rcu, thread_stack_free_rcu);
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


