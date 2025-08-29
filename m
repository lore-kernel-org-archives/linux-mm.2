Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D498CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 11:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4467C8E0009; Fri, 29 Aug 2025 07:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7008E0001; Fri, 29 Aug 2025 07:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249948E0009; Fri, 29 Aug 2025 07:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8A28E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:44:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9624D1198B2
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:44:47 +0000 (UTC)
X-FDA: 83829613014.20.FF74920
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id 94B51A0007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:44:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=IBcrhA3H;
	spf=pass (imf25.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.41 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756467885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WFe1CktsVDIUFXMUlAWVFSXINqaL27dLXjci6lesYis=;
	b=RownBaGyZ98Yx5fR9Ge3OGV3wm4ibGIbHGYkIi2JMD1VYpinhGGtVoVIp0JqVHMKt32X4A
	Kmjps1M7ZBZIpFtHVkYIlDtPP4NM75Wm+gcJC6iaWsJQq8IHVht5jESqj/gX8WVi6BVZRi
	Mm7aYUhCeh/YPy7HLCzL8HRiNpLyiDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756467885; a=rsa-sha256;
	cv=none;
	b=2jOSVATMLhS/vuo8ouT4IEtSFnhEYaE7klNPPtiH0/TMWAqz0p4ob3XPiZI3l8+4LxmnCH
	fPsZc/H0bbrvnlBjN1Uqtq9nfWUvZMdjiMVhhs5LDCd8JImeFT0OxrTh/gbExcs3Vrl5rW
	ihRAGCkuR6Uhd9XyS0ZOnts2fZdNNnc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=IBcrhA3H;
	spf=pass (imf25.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.41 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55f4cf36c00so2183132e87.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:44:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756467884; x=1757072684; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WFe1CktsVDIUFXMUlAWVFSXINqaL27dLXjci6lesYis=;
        b=IBcrhA3Hx3s9dFfLTijzzbMKuUZpzyujRgUAe5YRbYHFTAjQm+Rwxn03xSjYIBIonH
         ZjpJCA+ob6/uU/Mv66wKPNGAGmBxqhFMIkM4pamumFvFhFeHOmTZgwobnFHJRWOgCXve
         S2gNe3LZpTXwEuqcbm9BMIuoY7BA4ZXzxNBPjr49lri5oDrCFksBoTCvX1rrR41WFKrt
         eyCq1NlzPdR9nRIi0kktlZDH8bNyg4pyPO5zr//5r9eljRBFn4M0WHenNwrKpqARkSzu
         t+yhCfcRpU52fXqbUx7HhuLRhNs8X5Mj62m/g3ZUhtd0MbvvMvRSnojW5Odx+pLf3MrS
         SoRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756467884; x=1757072684;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WFe1CktsVDIUFXMUlAWVFSXINqaL27dLXjci6lesYis=;
        b=iTp4ZfO8sgtvTOZnbBRHSoBTsoZvFD2rLEqI0NGx4NjAz80pw/mnab8OnhK6vzTquF
         Mo6St0HXXFIuZOR53/yQuZIEtbsw/TGGfK7fBmIzZg4VubjiA/iR9wPLncPy7G1vE0be
         5p+6kpSsxSJVkbu0puTLxc3bcifghElSRiQqtRtC3FM+yPlcqkViVgs3848F4Gfai5e5
         hkGTRGn06Lwaa1n2zAhHgYeQm0YW3Ut5XMnj5p0kqiMHl0eoDGvtBlThURQMYnjacx+M
         ZdHvbkUNNUjqGjpvPE83APMMqVMo3p0cdrj+ZkIZsYslIYFM+8BCaKWMgIJLDLt05OJi
         vhow==
X-Forwarded-Encrypted: i=1; AJvYcCUgM028O9ka6gdlMAMMh58yDry90VZQXnEt4/3cu7xqMfIoCWlzMnCIFKQT1WdtFokRJm/WWyo72w==@kvack.org
X-Gm-Message-State: AOJu0YzMFctdABZSr1t/I4hz4DA0ZMrpyie4qqzWIgzgDvYLyOYhKlmb
	r00MVhqgK8VYzNOSm8Az75IwBGfhFDSGqVBBjbCsaubN5nxcEcpesWdy1Sf1pAWwIgg=
X-Gm-Gg: ASbGncu0q+hL0ZI32zhRhepAhP1dcJWKfIHhp2xm6lBKN4k/3GPPGsMaYpBeye/g2w4
	olwwgsMAXp4hdp82I+yepAEKNkScD5Qtd3+NOTR2LEc5e7tiQU5rbwn4Pr3SYaBaIOZeWptf8Q/
	23+KCiNpEWLxwmhmXuZG8UciYjDU6Gp5c7jBXEXSBXC32M7jUKwSZy6WGivBq3iJGxF8ysIN5A4
	3hRBpFKQFhqDPsXZ76Mgjhf4yFV/qZyYeLkL+iOHKOhk+OCdfEX3EwdBnAM9J8j2AzFoHys81lq
	Mg9lktFOXR2JpOcn3D/Xc2qnGlx8vMWp7SR9QFfSlrgh9DV5OgoxppDOlBlyukwYaScyCFHnqCU
	kpjg6xqPCi0fiQN41e81DvleyIEF4xUkROtRdcUT2aio=
X-Google-Smtp-Source: AGHT+IEkHsybnNaIxaBFEfVj1kIY3d3G3hiLCzbN2/ndqe/LdNG+/k5r6X74sVsHOJsMfoa47sH13w==
X-Received: by 2002:a05:6512:6703:b0:55f:449c:19e7 with SMTP id 2adb3069b0e04-55f449c217emr4969600e87.55.1756467883912;
        Fri, 29 Aug 2025 04:44:43 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f67a4c612sm581162e87.146.2025.08.29.04.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 04:44:43 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 29 Aug 2025 13:44:41 +0200
Subject: [PATCH 2/2] task_stack.h: Clean-up stack_not_used() implementation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250829-fork-cleanups-for-dynstack-v1-2-3bbaadce1f00@linaro.org>
References: <20250829-fork-cleanups-for-dynstack-v1-0-3bbaadce1f00@linaro.org>
In-Reply-To: <20250829-fork-cleanups-for-dynstack-v1-0-3bbaadce1f00@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.14.2
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 94B51A0007
X-Stat-Signature: nj8e1noc8hyu8ar74wp8sgj91d7u46mz
X-HE-Tag: 1756467885-333357
X-HE-Meta: U2FsdGVkX18IvEZtEdNzVOSVi8jeYUuF2ktrCkuQDP0/NlepO4Z7s70WWI+/3qsbYbJVjQgI2/cKbmn/OSQExMIvdYBK6CtWwNWwL2bTrPVNywX4CyQ+116IoA1iVSdAJeLu9DbBNhH9Vl1WGoz4dszPwSZNj3j0JGIrAGQnRD6VBIf8axihj8mIBRjvBHtpU6f7HYKl5zwHyyI1F60X7Kh9X2SdRUYp6SpNCyJ0oJJ9FY8+6rv3OPXj0uIjWT0z4dDui94a92pJt05Q1Q6+YatpQwZqYknaVGMWMrwokJyaFO69hdC9wYu+udlX8f/AdXG7Gq5A8zth/9u3fUsCCXBkMmxS+DR702reM3OPEwm+ncauoq48P6orM2OwJBBYPyncmpES5mc60KDVHkLdbTRkICQi2A2IbkeoLlx5SCgxWbuOxJLqmXGnAcjZSU8Lui1e5Z+81V8OptSD4oXA9fMeMqL7QZKDeABNx7anedhns1FgoW93LPXlOKsuRgNzrEEsB3v/uWBZqT+0Cij4WjxbE6BWu8CaFyRbWsIebhVxO6+n/VyMSW2IWCRyMHxd1j2O6EIY+zc0K3aUqOSmGMVmc+C3p/n9xkyfUjzJ9JbSNnOP+s9jyVRUqJ1+PwuMdmSHfaVUwwYz+SKW/MmmjwR5Bv7lcvfKA3JK5eOXsInamh0jKpYKtBsLJ9dPB1gr+wGbNAqDyv3tC2aOc1OU7mOzveEt9ubV95utY3DsVdrOUb8E9887GwEBkAfSgeRYgw6yGLY/VjZ/P9GdUP6TgUALkxNZmSh7CXtJyOnLZzP2K25sksUb4+PJK3nlhZB1HHqNcRZXlQrZEDXVgXY/QgGxRkI+pprGX9cgnuzvAerCLV2pIAEfwKwWSYEGPp7v7vyl9rulg5fYoPY1Sgt8fuNhSbFOX1t/MO16dfZhn1yhQDiWsJ4wTvJhq++WkmflSN686hihCwjW+1JEVdd
 cBwQgrxP
 HSW4j71xLv9ZbGmW/+hCF8KqNQEIVTLgArQFm8QzBoprlTaqEPgpGozalfBRvffC/wvBZAFh4648i4Y/NwSdczRXtEEZ39jexEjgQJnMvk3v3dLJYmsZfkMp8YTKWJ8xT3J5tM83d/1GBJpLrBTPcOUO2YQCMYwGdG/qsnYHJjYxezWaFLwtYmVLLUEx5VKjs3eRbxVopCvCSgnCMZhzH4Wp/FfayUmlQUiib5rNvt57QA1rFDQBzhs/ukECLHMHDUKJrvaChbZw7noihdQ490e9bQ4e+/UJNHsOx1qloHOLOVRVWevWYJJnzxcgfMpbMDVf3f3gtXm6lcS2m0aUMzfZL5NWKkJ/U3liuWdCaVqdQSIqBv+Xke+tvRxxWwOkc6xoWlvGtCXDRuOaMWEc2Yq5NWY7STBTbkIa/CzDC/sD3Q6NdRLzaVQK4fMczdOHpfdmL/C5mbfu0V/zotoWD7DH6fKSPKfkKzrKEZDAAEerdEtnZQMLjycOLog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

Inside the small stack_not_used() function there are several ifdefs for
stack growing-up vs. regular versions. Instead just implement this
function two times, one for growing-up and another regular.

Add comments like /* !CONFIG_DEBUG_STACK_USAGE */ to clarify what the
ifdefs are doing.

[linus.walleij@linaro.org: Rebased, function moved elsewhere in the kernel]
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-13-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 kernel/exit.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 343eb97543d568baeb23142edcc9050a8b8be8bf..9f74e8f1c431b6aa6e391ff71aadf9895a3857ae 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -780,24 +780,29 @@ static void exit_notify(struct task_struct *tsk, int group_dead)
 }
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
+#ifdef CONFIG_STACK_GROWSUP
 unsigned long stack_not_used(struct task_struct *p)
 {
 	unsigned long *n = end_of_stack(p);
 
 	do {	/* Skip over canary */
-# ifdef CONFIG_STACK_GROWSUP
 		n--;
-# else
-		n++;
-# endif
 	} while (!*n);
 
-# ifdef CONFIG_STACK_GROWSUP
 	return (unsigned long)end_of_stack(p) - (unsigned long)n;
-# else
+}
+#else /* !CONFIG_STACK_GROWSUP */
+unsigned long stack_not_used(struct task_struct *p)
+{
+	unsigned long *n = end_of_stack(p);
+
+	do {	/* Skip over canary */
+		n++;
+	} while (!*n);
+
 	return (unsigned long)n - (unsigned long)end_of_stack(p);
-# endif
 }
+#endif /* CONFIG_STACK_GROWSUP */
 
 /* Count the maximum pages reached in kernel stacks */
 static inline void kstack_histogram(unsigned long used_stack)
@@ -856,9 +861,9 @@ static void check_stack_usage(void)
 	}
 	spin_unlock(&low_water_lock);
 }
-#else
+#else /* !CONFIG_DEBUG_STACK_USAGE */
 static inline void check_stack_usage(void) {}
-#endif
+#endif /* CONFIG_DEBUG_STACK_USAGE */
 
 static void synchronize_group_exit(struct task_struct *tsk, long code)
 {

-- 
2.50.1


