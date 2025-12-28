Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61D80E784BE
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 15:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C28A6B0005; Sun, 28 Dec 2025 10:45:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57A4A6B0089; Sun, 28 Dec 2025 10:45:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47ABF6B008A; Sun, 28 Dec 2025 10:45:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 327CE6B0005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 10:45:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6A4DBBE15
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 15:45:10 +0000 (UTC)
X-FDA: 84269303580.30.A75F70E
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0BE9F1C0010
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 15:45:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ASa9Xckc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766936709; a=rsa-sha256;
	cv=none;
	b=hNXSGxvzz+TnPD3C38Mqh9Ju+kV4c70xaTH7uXoRaJmAk0Mho9cdq2GVjK22bGqJJjSBmD
	yjJCD5ZkKomL26olbcHYlyJWtjTBHK6DJt6+6Sehu6tbrnWZF4APl/bnsEqbzZ+PSvP/OS
	rLra9KhLgzNhLks1Zp7/jBrryaqUK3g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ASa9Xckc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766936709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/OzOFFAC2lo1Our5Sw3vSvRYytWrlEkBz2lezJBdxAU=;
	b=I0Xh4H9igzLg5GRdw7gYDUNu5gw3pG4ebGI3jEmNK4rGXtFgbVbW7YB8PhGCnGE+3j6/ns
	xgf/mh/aTPKLIr6sWglpOqedVIagTeBoOP+kL1GfsYnnfSXz7EI4CIL98zE1dwLRhezpJS
	XBZVxC9zSRmqONXUmu6agfnv/RicdDU=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a0c09bb78cso61808995ad.0
        for <linux-mm@kvack.org>; Sun, 28 Dec 2025 07:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766936708; x=1767541508; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/OzOFFAC2lo1Our5Sw3vSvRYytWrlEkBz2lezJBdxAU=;
        b=ASa9XckcnZo91PJmMQBXoY8l2o4wMPjTmDwdr2H5g+Q1AD6p+TAZb2xPcpJbKPmUCP
         w/tcju9ATliKlP/m32J9Ejjv3alJUQ0FAHd4XwQ4w3W3O2VErBuD04/wVZjb0ebe7Zwy
         WZvPJvKLYcQ7ehfTA61jiKxsmVB90CT9ApStN1u9JHpF3aE5XH2gJ7cQwPi0DQ5gZbjM
         yBKIOlz18GpZu1Uhjxs4UQQZ+JZn+U3J2852POoZZq6QoY3LO2GR7MtfB2FzU6tYrFGe
         rrBrqrPaedq76JZgs9nV7v4NH65SlU5GjO0AOi34B87QUp+El60xZB1YYqPaXWYQRoyx
         3Ddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766936708; x=1767541508;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/OzOFFAC2lo1Our5Sw3vSvRYytWrlEkBz2lezJBdxAU=;
        b=Vw/zd05AfHkYgNTyn2OX3fBM3gBs9dgiBw65zSe1fiH5Jg/TtYC4ff6bMzzcaksedD
         Bq4tAhvsgJPlN42r74++zsiwYWYDX6I8OBK/YMyrK8ndWWb8rbSOctaTcZaC04cXbW5h
         QmpuF30c7guHmgbFvYVAk24pDKNJuNpwq+mu452sYza6L0FZq/+HElGcVrRLBE7O+Vsj
         2c3ydJFV+4dJFu7cuOOUWmxreiwVu/+K5Yp8aPf7bA1IV8hHlTWu5O/iMLfWv/lI7PS8
         K6sUsVKNy+wpqr/a3HpO6n4APJ4jvGg56cG8ZOxBTNNMfZtA5l9mNKkbHTF2ena0TLRm
         k+5w==
X-Forwarded-Encrypted: i=1; AJvYcCVcrJPwbRSNDkqew3ELIpCjnk9c36aFCJqG6jI4RV2v+nKbANxnf+CeG+ym0FgjQ0FOJ7bPGQFwIw==@kvack.org
X-Gm-Message-State: AOJu0YyKbMK0Pa2Qz9FUb2sQ2xdYxijQ/KYduIlKOeFD4d9Kz6R/UcJ9
	WWVkux/OR7tCkJSCU534+8aZjlTySdSKzOa7LIpTi73uuk5xKy+iX2Ru
X-Gm-Gg: AY/fxX7/91iGi61SdwSwMlGsw61lZtqXHKO0wT1x46rL2kA9unwRieMaEd0W21BlBZo
	WIf4pSHKJFFojVl4IfPc3DFZNOiRk2peS8WeXFv4z7kzKS2BMpJWvD5UI0coYqQ1MmFYiCZzknp
	01zAeu2SNywBr/CKtpRflCFJqoH3zGXWhozgpbzu3ZWE926bFK8E42GxRP+wEIQ8gQrJpuIRzTY
	iY5cc/4cIyaE4aFExcjAcaOmw4fE1G+xDODRRk/QnjrjbOWsKfWnOD/eY5U+hTsmrLvHJbZXUK6
	6a9qfQ9R9Z/Tn2AMl9ZkGW/OOV/aVLZ3I2w/NvwYlnP5Eau+vIF5nmhVNbS6l1IYrKYu+kPVn9c
	tsVN0SXKC/vSK1uVOm8vOgPArH9E2EOoo/I90Mw1m8jVyy3SF2Ob2RZJR9svP5Bn6+he5l8fUy1
	Cd5yFRiJ4=
X-Google-Smtp-Source: AGHT+IGIvfU74StCeilc/KSU6t4Vmt3YP88PHmeu6KW4rAqZsFceVn/6XQPb0q2nKnak4gAcZ4C8Vg==
X-Received: by 2002:a17:902:c94f:b0:2a0:d527:4d07 with SMTP id d9443c01a7336-2a2f0d2db0amr285540965ad.17.1766936707820;
        Sun, 28 Dec 2025 07:45:07 -0800 (PST)
Received: from ubuntu.. ([49.207.198.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2f3c8d10esm247232205ad.42.2025.12.28.07.45.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Dec 2025 07:45:07 -0800 (PST)
From: Dipendra Khadka <kdipendra88@gmail.com>
To: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dipendra Khadka <kdipendra88@gmail.com>
Subject: [PATCH] mm/oom_kill: Remove unnecessary integer promotion in format string
Date: Sun, 28 Dec 2025 15:44:55 +0000
Message-ID: <20251228154456.2386-1-kdipendra88@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0BE9F1C0010
X-Stat-Signature: cd8ww1eek185xjnwdhsdgroyaa8354xq
X-Rspam-User: 
X-HE-Tag: 1766936708-165715
X-HE-Meta: U2FsdGVkX18M3HGkcWj9BGCkSPMYHWz6LI4D45ttdkmaY6p0TFQsWgiVjsc5Fa8lOStIalQoNL/aPuaNpvQG6juv4Tc1grrYPPJiYrbQYXIApcZFgH3wroeLnVBhuqO6LAg+ROTOHYnSq9sfWrKQp7Y6xHOIiN9nh9ZSddiJDe+afuyK2K+vq/Ay3mwYLTtdVhLeKqbw5oACdEAhLbrYxlIZFzu/Z/yz+S40TXcDhS6pwMaAGJU/2barj0GpT5y0rzooyql2Gp0I5eavODq0Z/FPXpVrDdcl5jN6HuKWdf+BC9G5jMEkfZ74eTkzecGj93dHkHvXotBV0fmAjP9KnRWEGrTqNDS5g4jFqu7QTp/61uxeSk+k4iNtxmsiS/7xMV9BpV5+IZ/QqIgKgdKxq08LpfhZdU5SigaBqJmYtApHJ4VXgfajMYeiCdAJ/d3A+4KjOWD1CHTrI4ZQoW3yxkRCReCWHVRzkQlQuON83ysVZ3vOOqpx20/1erQZE1q+95RroQReOLmEFsXcj2CwiQLp/raEchBpW5dlQj6/mtGZRo3Sp0DOh3y20Z91brp0OVDsdLeLAkrQgFoHSBU+cgKrc5xFrSvZMvStyvt/hbvFMhMemOVtYzmLHdpYdjNA0qcg8reDyFFYZqRxj/9eWjY74KQ6qHG5qCSgXYTUS873vg+KPCO3VUusymdxYiGDcAWXd9wn+U4022ExYGJRyFxR3DvLJJUFGglzV8X5SyuBtbboHNrBL+41IegTSYr2tBvJrKN4R8XzTYEHYh2TdFsc1v2P2jc/CDpDi7mwcDdHvi6aiS4ghEf4Hf87je3GGMayRHLn5WhZFxRFd0i8IsN8V89JyS8sLITd3ti1wPWppEeTRlzURpf+gdAWrzYra/x2ODZ8e/bMkE1jKcVzT3eMmrNirQERHnAaPkhpE5VibuRNKoLvY37oSLvd6tCquF2eBW2NMMcH0glFQv2
 B8/F6OD1
 GmStMrKRVhP0+20EOw4RKfIKj4Ib8YyHFpUQaAyRWMd7/xQjyVZ3N02w58ezB2PcjvEAfOfu9QdLaaKdGOzcwn7YynOGHve1jAU9gr/hh29JcbX4Az5y1F4ih/diTfjxADbptd0TbQU6rGx/VnrSAKCqLNB65vNdE/bZplo/BRYgY0jUmjCAqzWlgjzd2qNZiWDCxjGVfaLGupdpNGLDvwH0OzBlWf1fe/mOi/edvVTQYZnmg/k/Uh0qI6dTc1axzRL5E0mTOPAkYz84gjL3ElbVrfiMlF2cPZ7RuKP38XEMR6ra9v3XJII9LE2Mk0bHBoaYBA+MQXqWfQzPph7pSq5QsmCi/Kz0hM32Uo3OHXreDP4BCH9FfwTpvukariEcvA0RKF36G4rQOXktgD3IkbF+4Pcs5NsXcdSijs569cK2/8DGEdobU8OQQLUtNBYCS0wBOf90beqK3w3s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The 'h' length modifier in '%hd' is unnecessary as short integers are
promoted to int in variadic functions. Use '%d' instead.

Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>
---
 mm/oom_kill.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5eb11fbba704..94066316e3ec 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -458,7 +458,7 @@ static void dump_oom_victim(struct oom_control *oc, struct task_struct *victim)
 
 static void dump_header(struct oom_control *oc)
 {
-	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%hd\n",
+	pr_warn("%s invoked oom-killer: gfp_mask=%#x(%pGg), order=%d, oom_score_adj=%d\n",
 		current->comm, oc->gfp_mask, &oc->gfp_mask, oc->order,
 			current->signal->oom_score_adj);
 	if (!IS_ENABLED(CONFIG_COMPACTION) && oc->order)
@@ -958,7 +958,7 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	 */
 	do_send_sig_info(SIGKILL, SEND_SIG_PRIV, victim, PIDTYPE_TGID);
 	mark_oom_victim(victim);
-	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%hd\n",
+	pr_err("%s: Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB, shmem-rss:%lukB, UID:%u pgtables:%lukB oom_score_adj:%d\n",
 		message, task_pid_nr(victim), victim->comm, K(mm->total_vm),
 		K(get_mm_counter(mm, MM_ANONPAGES)),
 		K(get_mm_counter(mm, MM_FILEPAGES)),
-- 
2.43.0


