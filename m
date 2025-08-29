Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD202CA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 11:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC338E0007; Fri, 29 Aug 2025 07:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41108E0001; Fri, 29 Aug 2025 07:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2FCC8E0007; Fri, 29 Aug 2025 07:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC3A78E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:44:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B0EBBAAC1
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:44:46 +0000 (UTC)
X-FDA: 83829612972.18.D994869
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 977301C000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:44:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Hecwbn0i;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf21.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.44 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756467884; a=rsa-sha256;
	cv=none;
	b=dem9iNdfp0I1jP7I7/rE4pONzLG6UORCHnQ7JmV2HKJxt57yrK/+iuFSzJ33AOYJekpTg3
	ycbtaKh9cKkbab9wOGnntqOb+ugJePfYNE2qzW33X53W2spTfBzPP3cB1amA6ihsWXKOm7
	v5GFN+KXkC2PX7VPivN16nMTt14fPgY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=Hecwbn0i;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf21.hostedemail.com: domain of linus.walleij@linaro.org designates 209.85.167.44 as permitted sender) smtp.mailfrom=linus.walleij@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756467884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jgtia+LpfMpm3WYDNDpUT/QXDK2dR0NCJT/wLTvQl3g=;
	b=49anzTXLdKhhqCSJl6kI0F9O126YJdg19jPsySBhYlhNJfqKGN6205ekR2pM8NeXdDocr8
	rk5VRv8IvEotLaiph9luhrDvlOXLgin0uFFBtz1RUvvOrlo0tRVKMtjf4bfG1U5VQnX80k
	xbUQMVdm5vPitRDXe6/PgndQ6y0z3zI=
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55f4345cfd3so2090509e87.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756467883; x=1757072683; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jgtia+LpfMpm3WYDNDpUT/QXDK2dR0NCJT/wLTvQl3g=;
        b=Hecwbn0ioje6fS3+RQ7zC477UV6u45byJarmWEdDgaPI2JZzKku1fi+Cyk6F+uukHU
         XvpGKJz6jGjup8LlQ4QsINVcWHjZvRkUYLx2OKXPHVjVnTRVTdFvPtbAeS7aY3WNoDCj
         nKNF+pra81+X2SulfOiCcFchamRfQb3lJgZGisH6wLSXMxesop4BLIL98ZtW1A1qmvtu
         kQ9u6hZdLZGJY36Tynqh+2ZwnWzDqN0sUcL8KuJEHuSLgML7Y66k2guIP/Cfuk+fzN31
         Ku6LA2LAS5ui/U2zVNvDBxsYhGchn5onlieD77wb4SfGnkubgzcGMOTD8ndsvAGbRgYv
         ZOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756467883; x=1757072683;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jgtia+LpfMpm3WYDNDpUT/QXDK2dR0NCJT/wLTvQl3g=;
        b=NGBXCbk4qL8ZsBCRUgSOMf0YTZKCyNiLXmvpw43EGFRs61iX/rV9aXPh5R4tbttzmR
         3Jfi83QW8EGhCqTsvqP7h9MRDC917KUfcrSPwtYMBXVErG8tSeoEbRSnm5xQC62qk6vK
         MaVY39YL3CzK+c+7xDRqkrpqHOYrTaGKz8XuJSMlZ7YLhtP4kyicS7hD9Au3rLBs+OMm
         XtXkSsnoUX6EqiGC5pIQP70uLSqSq+H3ksJYmYhAhC71jaH4iz/7ZvCcapLtN5TyPers
         8gmLY3v5vxbdQsRFMom1qy4RDGklkG1TQNzRGWiP69Iy2pkEm4vb34JHJ6Emrp/6upNH
         ok/w==
X-Forwarded-Encrypted: i=1; AJvYcCXWC+9sXS2NMh/cEsKq28clgwvu8U0Hpdkqepw66e9s7BgOcSXY43q6hE4iEJKmd2zsueP0g8s6nA==@kvack.org
X-Gm-Message-State: AOJu0YwJdwtGGzxs//iEzfXSMHVdEwXOuXr/z4qfP2Z3zJeJGsuHNNAR
	2FUSCygxdCMFeQ5q/Qi0uuKL841vz9n91WnFLQ1lkamafb/N3Cagaf+TAfE9nB/+8A8=
X-Gm-Gg: ASbGncvjRR63DF7q4J6aLEvT1wh91G8FhEUZUIAIqGTxtZpkBPDd7sv8uhUEGEB/BGo
	oq8syIiOyRoRHkqG2Y65ym6UFvURNTpn2GR9C1chPYRe4W+i3M5dRj9SUu6yza58PrTI3JU9qPI
	o5OEFerGGdeI35jx38hO2Vmc38Ts8Ai1uDfRdg7oIju6RwBVe0SJTzSbNjALAqiFpzAjNH15rdT
	9oI4E8U2UZlfRvrxQRixueqwiGjuRrf2zGXYLyFrqgy38M6kOiK25YEdoc4X4ZvxT1gc1UeBvvD
	iCIcuIxdvARTwZ1YvDlsnKdvaKTYK0S3/NLaILIjZ9nukYTV2SSmonJaPOzYEZomkPb0Ldequw3
	hduNDi5jOzTx6qIeQRMX/EhvpvgoSAdQX
X-Google-Smtp-Source: AGHT+IHAqQsoVsR6L7a6rcLo6fKDNuhsLtvlWrPRnW+IIIX2gb7KKe3MHpJzSG95OBA3WhmSJVm61g==
X-Received: by 2002:a05:6512:12c4:b0:55b:84d3:12b9 with SMTP id 2adb3069b0e04-55f4f4c6a38mr4346175e87.18.1756467882843;
        Fri, 29 Aug 2025 04:44:42 -0700 (PDT)
Received: from [192.168.1.140] ([85.235.12.238])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55f67a4c612sm581162e87.146.2025.08.29.04.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 04:44:42 -0700 (PDT)
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 29 Aug 2025 13:44:40 +0200
Subject: [PATCH 1/2] fork: check charging success before zeroing stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250829-fork-cleanups-for-dynstack-v1-1-3bbaadce1f00@linaro.org>
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
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 977301C000E
X-Stat-Signature: fmfy8zmes7w5moxmubwrbtimbehyfoca
X-HE-Tag: 1756467884-754216
X-HE-Meta: U2FsdGVkX1/a/ttu34P77oO4OkCt8THVqSg6Fz9QocL3xvObILYylb2CWFHavXKWForBoFgMYb9+cfz4mxo/crIlxx8ODGFAYLXo+lfc0ZyYsL0rrm21OvOnsMGIsE52u7TXhygi5gsbqbGXYsNsO9ugdwdsVk8h+UFyC7vIYFTXVoxLULTSgJCCsMgSVohLX+ECIGXiG6L0MmCXz6PR/jKZ9/00LQPPiUYKxLk0OqRj3bsE79nBi83cHqhKoNn4BR0dLtkYtC8CFqvTw1IeHruA5CkNlKYRfN9HfFT+bns22aG2xo/nVRDpMY2E5uDeOLpMSEMhUc18/TwlgW+iRQwurmWZ1iPYy7K8B5OvNzO5WCWXsnGLgb6cu8Ag2IvtQtY/btOul9aRc+z+7kKCq2CWHGG8WX5Ysgrt5oqEbbaI9TX9RmrFfrloN30MccDp0m2UhqvM2NDrr9jSG3QmohXUmrDoaugRf4lZ4Hky+v2E9TMbmoG7uDa+edZzIxFSUiKaUrYu975p5uC1jVRy+VXABiIddCFjtmBzb+CrYZTUwWAe4Rc8JOq1RTyxxl5KpF2LXyS4sLYpzZSH1IWtwL5MxwKvGeI3gAXZz7RdBAXqoYb7cmvHMMueGznrIBG2YqBlE0LZySr+AAEhf6mkU2D+1VVCqcahoLC/ANJYjvaO3nivtUdEnr2VpoIJSe4TNQuYvwV4+MoU7ewH9rgFeOGRepRmX35f3BtgQEwEbAI3fmKYlBUZyGyqFoNIkSJ8EqpNoMDocoWN8fW12iQJgf2WGNilyZh2wcPg57O2pkIVZHLqJQj93qKuM8giD7MrSalovwq3JSkYShpn+mSHi6d/ktyNiLXPHxtzUYtD+BNqPLzMxRoXugreOMSYJcimNjcAhohJoheembU71KgsJPNcPNopqncfvxo0H9qY9uZgcT4NbggRdBjk4LyRQLX9cgfNSI26mVdTBzayww4
 F3LP3Oeb
 s73x9kGxruhCQJInwmryXYfFmUKd5E4j+OUkmKn5awCVRQtq6I6eXBFhEyGM6WiTTGFrzMW6MIaxVn2z4o7LdwTHVxbAEYoSLuKLyT3Xb5/aP300icY9V0Zu9HDo7Yg8vinBHgrc6EPajTe5R0c4jKlaIczQEFYvSQA3RxsvSjpeKxryftRK58+wzvvKlGOvZ+YgnRh6yb+ITzvoXBuDIuemdDhLkKmJKbVstjPV/kn/boPv3sJWCAWWghLscedADIrSTS2Zmz1luNdbjZD3c41OZ2zzu0H9zrgqANn1T/VhpRQUdFJMtE7y80YYgB+GqJegvvt8fEwHwwp+TZ5k8VSYGZmoomW0imvJdWFRfy9ELWxNclLpudsDQNW1rn5N2MDbdl9vc6Qqt2nr6qL9QjwBOSCOVE7s+nLrIAOPpbEIHs/vu+E7XAtzSoLvFMsvA8T/Vj+lGPulsPIE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

No need to do zero cached stack if memcg charge fails, so move the
charging attempt before the memset operation.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/20240311164638.2015063-6-pasha.tatashin@soleen.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 kernel/fork.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index af673856499dcaa35e135a9e8042ef28d5c5370d..2a5b7a5fa09b1f3a42473cf44a1316ec8b3b31d0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -290,6 +290,11 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		if (!vm_area)
 			continue;
 
+		if (memcg_charge_kernel_stack(vm_area)) {
+			vfree(vm_area->addr);
+			return -ENOMEM;
+		}
+
 		/* Reset stack metadata. */
 		kasan_unpoison_range(vm_area->addr, THREAD_SIZE);
 
@@ -298,11 +303,6 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		/* Clear stale pointers from reused stack. */
 		memset(stack, 0, THREAD_SIZE);
 
-		if (memcg_charge_kernel_stack(vm_area)) {
-			vfree(vm_area->addr);
-			return -ENOMEM;
-		}
-
 		tsk->stack_vm_area = vm_area;
 		tsk->stack = stack;
 		return 0;

-- 
2.50.1


