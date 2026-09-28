Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB70BCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD7736B00A2; Mon, 28 Sep 2026 13:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87F96B00A4; Mon, 28 Sep 2026 13:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4FFD6B00A5; Mon, 28 Sep 2026 13:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 763B46B00A2
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:41:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15433A5A3A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:54 +0000 (UTC)
X-FDA: 85263888948.07.6FDA7EC
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf19.hostedemail.com (Postfix) with ESMTP id 51BDB1A0003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RR4xDfdw;
	spf=pass (imf19.hostedemail.com: domain of 33qa6aggKCHMjdfjkRWRXffXcV.TfdcZelo-ddbmRTb.fiX@flex--smostafa.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=33qa6aggKCHMjdfjkRWRXffXcV.TfdcZelo-ddbmRTb.fiX@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZMttkoCzeXLC/JEGKL20pI+XNOolXdLvFIFeMj04zLo=;
	b=3Qu/PqZ4bvYP9iWpSJiGAdOWp7VzqMbzTbZwH62h/Tyrmu5mDW9JweH8BOUG38pUjK4m6t
	4jtdpdKGex+c1KW7kKL8D86l88ukbKyUUy5ctO+M2KCDJZEkbcKvhPG1lMD5Z2zbbe2JbY
	BXzU+mOFbUEjY2zTAydGsu649Zoc5sk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RR4xDfdw;
	spf=pass (imf19.hostedemail.com: domain of 33qa6aggKCHMjdfjkRWRXffXcV.TfdcZelo-ddbmRTb.fiX@flex--smostafa.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=33qa6aggKCHMjdfjkRWRXffXcV.TfdcZelo-ddbmRTb.fiX@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617312;
	b=WZaJed1rysYmjf+fZbeX0dkCHBnn7s3dGaw1c6s7g0SQEi0Gt9HY0pglHNXNxfk9vKt31d
	AYGmumsdEin0dNa0PCb4AKHpuzw+wFj8+kRjiTfHgVcE5oKDVC5OmxwRDGDSQlfON/e1Cu
	7u1bU+8GX9StPJSeS+SRnByzeKaOOzc=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e7631c43aso34369625e9.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617311; x=1791222111; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZMttkoCzeXLC/JEGKL20pI+XNOolXdLvFIFeMj04zLo=;
        b=RR4xDfdwTBNgc97qexyhLsucs70kuG48g3WGvPALM9TPYIKPwRguhNMBqy3TsRRD5J
         4KTO+QkCNEAxj/b2MlEqVLnDNs6coGthZEBlZSj9FZJbhSQZAnFlVYA4G3jOSzH6+bHe
         ffw0ZChcPcGuASLAQ0MH/pTejPSXusxqF3rqXncJ9+E2B9gbJEG+P7NXWSbCs+yJMHCf
         2ZvchVD/4Vm14awnzq2qTxZcdVUbOuJJuMAYWWkw76BN0ccCy4+C5KskdHWE9sRKyiW/
         03Z1AxFV1wSzyAzy/QyaDXHkJ3yiQbf/trYcMcnIQtwXZuftAGsSdgkRKqc+xHpI0mZO
         AOQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617311; x=1791222111;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZMttkoCzeXLC/JEGKL20pI+XNOolXdLvFIFeMj04zLo=;
        b=eBNwGjyeUEgX/3S3WL0DgHwB8SZze6om4lzmjYiJB3hUm7MN/wlLX+enLz1ACUxgW9
         ZG66CWT6Q2w5hwRCrBAUDu7nkuZBz59flsUHl2Heckre0oSMHoZkN/FHvb/02LlkcGpy
         3qDd9dIwocFOwL+Df6X1MVU3bCKD2dXCvwM80hDfqFHaev6boA4/6XSDp30kWIo/bZnH
         1sH9GBX/6Q9HOsjh4fPAkonjfCyuMI5M+zevM0kdFSEIcJavcopoH0KJwm5CV0O/FFgu
         Di23wsXEtHwvMLZkcwh3Bn9VVk8w4U6BTMKTyWMnvmwpofooII6ZkPKzoHK1Rj7b7l4D
         cwlg==
X-Forwarded-Encrypted: i=1; AKwUvByDLbvPw/l8cGMNSpW1s0nbiudnDnD0wRjaHeNJDsbpeyVF3Cg0mAVUIQEOM7PsoBjXC2C6SjfMJw==@kvack.org
X-Gm-Message-State: AFuF++nU+Ls4cD1GniRMg8Zq6mNmg9UulujDaD9l2SAKfE8IsQB7U2fm
	b2477fXFDT1JrHs8Ks1yeXxLUZdJHbruP7PdYye75484SIoyLVyyyWxjDydWcMbGiGPRaIT/34H
	V/wlRHPT5l3/toQ==
X-Received: from wmqb10.prod.google.com ([2002:a05:600c:4e0a:b0:4a0:107:e5c1])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b4c:b0:49f:bd3c:bc16 with SMTP id 5b1f17b1804b1-49fe66f4c16mr231430235e9.17.1790617310870;
 Mon, 28 Sep 2026 10:41:50 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:10 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-4-smostafa@google.com>
Subject: [RFC PATCH 03/15] fork: Move vm_stack to the beginning of the stack
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	David Stevens <stevensd@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 85hd1asqj5bwhqepx5qrjw8qowdqhxux
X-Rspamd-Queue-Id: 51BDB1A0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790617312-698725
X-HE-Meta: U2FsdGVkX1/WU5Mg52KE7cd0CvOtOXHSEBd/uctBjyhUKsGH+Q0w+znnikBb7Eau8pv5ML7NPKKtLE5XW5dstFPxEebVhWDcBV5qw9SNxIS8RhGcGKaJ+Wk1LLOI/bPb6pgIQTwk2HfHgeMg3vhGbj7g4HjSyRmnJpJ/hkva+II0yfFhxv2yaHvdngYb4NhgugSSAMhHrxWsrJzPgB5GrGTp2kRayW2ePt9a2bUuOHstx8xNxelvFlDicnMk/SV1au0rQ6AYqb2S15IzCjxblXSX5y+9Dp94InYEhyr/k335zpCaavQfZE1afpaE1gGUve8SOdnvJaVm6GJoeJZ/Ebz/ek4FbcAtvO+tiKJb5Sso6GKE+qWkZrs73/8DS9LzYSXqmqkbg0I2eKL2MIMQKA5xGlB05+Ysy7+DLLvlv3zajXSdQH2h0hVeR86GzzCa13HPsLqAb4kkn5wB5NBAI4luBVICKj46Yn8EIK/HFnHEFrKCXMnTIIgfy6fLTEcpKi6/jTsYEp0DQP9jKuezydJSNH9dmKx0y3ZtMOerMQR5KEXRXPfZxM60iP+N70U9F4clEdV2Ow5DiQ02TGiLnvkwC8EdcZYoj3gn+Xpbp2xxIGcNE87GgvEGyiRhczU12XMnb+cDBlzvJXj9GvBPZUFO4vkeeRbcLB/rIN19QISYYQ6/BHPg5HdoCBhfogVOxbQkXKUeESUW01UFk8JNi85kVcph/N1bb2Q0lXig835EEltB+9bSI5oL3+uX5N9+aY+dlr6oaTf2Qa0+1Bb6GxVH2aHB/pKYRclcCMFv60csMChWa0m51bGLQfA9JnLOwcWTL941HjsYjteAaam/VbO6wDPpYhJz8VX7DG3xVP/jgmDvBMHpYhqx3o9lJ4I33M7KaTn9+8MtHO9OHcbbmYDt04QsLOE3RM/KFfK+aBRv1pTTHXxW/my/+owkw6kdMpxrelzpBtBKR0+VskD
 jRLYQjxU
 mA3cdSQ/58DR7Ld3RPnmXVRPQJfuweIN2c2h7jWDUaxJqK+y4hnjS4ams7YGYvhcEsXxFkv5P3I4PKtqurX8zdFllOAubLQwHry4YZtt+HZAdmY1FzA5cVQjcF4MOYPcWBBz4QkTzAFk+2UpIs6CSdCm60ZhaUcTkh5fAbfMCWSxjjgXH/Ox+Bu23SweoD/2FIoujNmqYiLa44cAqkEPCnFppo8xgNj1MS4Sif/d2RZet6yjLXmgsDPbI1whJwZfEFxM1Lt1iCvhQtmbpMoYGpZu+tCIYkIJ3K+l7zCMhwPLb+l6PCGOqbMzScRmQRcYSZsadasIBqZCa4cNY9K0C8tHqUy/KWY2/9OErxQ8Ip/fY+PIvxPqB5fTwykm+UbdcTgCQPdPivhXJedOReSWGH4q7TaCkKJ1fStVyIbGlYRq/NcKfNDFOBsf4OaWIJrzvTrPjY7Dayh7iBSH45sqgV98tJr4KGDl4l5MzOrsqzJi+JDCQYMp/FZbufjdFTXtPr/AvAq8QXlUq46lHbzEtaIipWZ8elk6my/7ve0zF9SM1r/Jc8lV2h4nk5vocseRYr2t24HEvz8VvnNcGaik2lQFW57vcOfCHHwXOgdUQU+0KIwQP8ffwBCFLZOqG+PonFURzauWMxr5OoNM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Stevens <stevensd@google.com>

The vm_stack struct used to free stacks via an RCU callback is stored
directly in the stack being freed. Make sure it's stored at the
beginning of the stack regardless of stack growth direction, to avoid
faults on partially allocated stacks.

Signed-off-by: David Stevens <stevensd@google.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 kernel/fork.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index ec4431bf309a..473878d7f62f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -285,7 +285,12 @@ static void thread_stack_free_rcu(struct rcu_head *rh)
 
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
2.56.0.rc1.315.gc6ed9934b7-goog


