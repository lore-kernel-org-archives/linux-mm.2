Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44FDAFEA838
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE8746B00B1; Wed, 25 Mar 2026 05:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A994C6B00B3; Wed, 25 Mar 2026 05:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988416B00B4; Wed, 25 Mar 2026 05:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8324E6B00B1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:11:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2D376BB04F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:11:35 +0000 (UTC)
X-FDA: 84584017350.24.6823849
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3ECA418000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:11:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q8lR8x1r;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429893; a=rsa-sha256;
	cv=none;
	b=4sL5OghgWAhOOIENCa3/Cl0lR1tVdd4ZiqB46Ki2+F2RHLz0xB7K5hlfDJkY8YHsdrhgsJ
	CglIdnmu8fCDWh8FnKbIdctwWmZ1sBIPKvPAsCjuzYc8Hr4RPNrq/1YXdpU3wcgo58Vt/x
	BYz6UOYP7NWOmYZcTktRyrDKuxZdar0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q8lR8x1r;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p2KjID10vkg/qXstgNRvPPvkY3Brj7dL/qNSBa8q0+4=;
	b=I7ke0n5u1zvaiHKYKNRXkscfvfI/ZlbqQ7lkg+AwbauHlZjwWX/AiJ3oihKg0a0kbT5SLX
	EqeKQHw7E/glwW5KDunxlWrfByA8QkP5At3eq1xN+OHonXuyDvpAswwlUqSAcer21aYmoK
	yxVlSrXJ2QODQzlia2VKyFgPX3NQbS8=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2c0c482e069so4016961eec.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429892; x=1775034692; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p2KjID10vkg/qXstgNRvPPvkY3Brj7dL/qNSBa8q0+4=;
        b=q8lR8x1rLQ8yYuPgXkgeyFgx96nNQ1ARlpBdKTCzGNohNzcGMdP+a1KfvYbcs8oCEC
         ABrqNNd0lFF3dYcEquLn6qoJNP4E3oeeNTHE7vEKBO8jxOxqWdN972m7m0ruDvb+wUzh
         zKFybBoP/Y7ePvl8W6u9to3kbHl30FI1eYJRaeB7Zi57S5dmBbxiktVDpJOQUh0qRRR2
         obeMlsVi6b0/zTKNaRGXRuhCz6XMbXmozlPeh0c8oFtamFZHWrySA9tllo6fxdv4S0Wb
         sut0agcVnlDWVx8sWlxTwi/fgKb1h3slG9Va772lm7A8ZOJ87UYLZ8BPh/x7VLAag2Po
         Simg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429892; x=1775034692;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p2KjID10vkg/qXstgNRvPPvkY3Brj7dL/qNSBa8q0+4=;
        b=kq9+6xiZUANMlsJ0A/YLxAr8qg7vMwUO2yXhnQqw8pOQWApNiWCAro4qp2yR1mwYex
         zGAfPqxvMQuuJLiPMD89miJG9AMqsvxJxS8ieJpUW9oeCl3m6EriAvkT9bY3OYmA8nAX
         hIe/bBwCRCQOrfLOlUnYWA2y3/bUWfz2Dwjh0e7/9aKM/1UmwDjp+vGK4NP5FnVzUFjx
         zI3Xo38e1s3DTrb8rflB0ZJGp7YL8qIZkdLmBBUSwNol61VmSJt6Bc6PkVirKfoz7rUY
         yIttSb6SOs6ow7llc0RP/v2ZktSx5BSE+Qgkg7YaZnNg6EoADSPpcuOFBqEuiePrU+1d
         NKow==
X-Forwarded-Encrypted: i=1; AJvYcCXnF85bctFnIk/bU63Pc4n2MkqZ2rAN9hVC/l6WNQIArQBq+nbiBJ75ug9LHkIgrR0Cnd9qNUAn1Q==@kvack.org
X-Gm-Message-State: AOJu0YzWufXjpnD6NwvuK4QKxCXxGkwSDg7DVesh8dU/GwtgNlzanaRa
	vK6hjO1G892OxJQf5zdnQ5//Z6JSLSEpBD3piWaIjuZ8aobdxQGWjf+X
X-Gm-Gg: ATEYQzziuEkEVo6Qm302hw42qWtchsiU7xo+B6SgvmLhnOf0TPPQ7iaBuGiiuI/IYYY
	LISyH3iyurHyyVsVsfSO2XBsvrfwVZ7c21V0dkwJJDgAhRATceO+UTf+1txh9L0TUlvjGX1/IOJ
	6FXSfnE8HZrZ8HnOvO0vUNID7gmVqOgxDPBO64taHdvsLLF0J6CUTQpORWibepS5kgqN1weuxj8
	Tzp3DBTF+guxy7U1KWIj9Su8d5y/oRSV4yidwdYaMlOufO2YRd/SZOAgIPpMrGljA4rvo64yGxe
	NKvcLgoVe2dM3usdXdzLT41GV9k7Kse6yA3z4DcNXDg3fCTb4NXrgoKBf80fxnD5VUvDGjyXAhi
	0VE2mkoxV+u5h6w8Ugf4++o8rVbmYKVZj1IOc/TLr5FNeXsxtDX1GYuko0PMFPwatmGk3UUkQNt
	GTeB9X8Xx6Iuqb/QHq
X-Received: by 2002:a05:7300:2305:b0:2c1:4f1:c87b with SMTP id 5a478bee46e88-2c15d357a32mr1565966eec.18.1774429891947;
        Wed, 25 Mar 2026 02:11:31 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.11.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:11:31 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:45 +0800
Subject: [PATCH 14/15] Documentation: isolation: Document DHEI sysfs
 interfaces
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-14-919cca23cadf@gmail.com>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
In-Reply-To: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: 7x6uu4yqurmff8mf54nr7wzbmd15i73p
X-Rspamd-Queue-Id: 3ECA418000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774429893-944714
X-HE-Meta: U2FsdGVkX1/QRKgeHoeWyz13FNG9AXcnXSyGLbq7Al5XIKqJRwmUyPr5pHt7ogAja9C57ZnUubIJDkQ5LL4hVKiAHUlcnqhiZtTAlNmRkjt4JVBrWpHQLsM5GcIh3cY1k9ONf4IV8anf4RyEKHMu4mRusGOpWupIxoMaksM+Rmb4DIHILTls9KV1gGhz/spMF+CLjnV4LZJO9j7kmH1sCvl4ZwoyhsaQdFKrZS8tcAnSDf8TJ0/9eG09v1dxm/bVlOiVzn3PTC86E78NqaNgbech6swd/blrLEdDnhCDdtbaCMKiw//zJ3mdhK02CWHNaLD/kL/Q9Jio8JCdhgBJ/qUtOgCzQeo2qyL7kZeeLYbZZhdX5njrZIDWzMzJji67c7NVz9UTk0WachTjBZYozCrEOn8EXCnho+89gfVSZr0NIP8Z6Q9Y552p/M+jtWY7kmArJ97af1r6qreNHy7jTB0gH0V2u1ieHZBit8bq2eYNH7YoO4WGJ9uoP4blKVlrkiVoKRfn4hUxlfVCpqT3WWTQxqAbvcciZEVvyrokOkaD20ryvziRhVkey5b1/9ARTLXb1ZxlWQ6JSkCh/PtA97PeIl3BLWvrL9gY9uv/hVqYL8leHl6UFDgxRvw9gSiuTaO8RuxuLIO+e2hm96wPD6kg3FO6/hMkcg5HRZiAmqFMadDrC6r8xKD4ZRwweBa+PD+spnqmybM/5HywJUksd7Ub/2D1z9y45DPqHsyTXTcBsh1/0Ro2OqbHQcLAcgQT1YpZ9MAfN4Hr50Y6bUGlDZ5PxjRm6X52fbWVH0LV/iAKQPu5Un/G4H0HUpJpRUhbGz0NXASAQyUm+eLxRBwNKuFpDL8il7ROtWTjM7ESgEGI7FMxS7Z71/qCGmnv6PsnTV5VLgn5xbZcbFWzgc+oHLRhOxlNdXF7ONXefpC1v8CTnbxGGXoUDAuX5yb9+iRYL3xVh8xQbxjPbmLwb+p
 JOE4qe4Z
 uVnJvQIbVhfaM4+Tb5wgz/k961+MCgCVrtPp8CKIb0gOx6vAsQ6t9+XODU0qhCuUPlLr3NO3Km5lhLMl2RCt3vxu+yKS5cDKS7EbjpyS4LYDbXB3uioGaYJXrRd7Kxx15SKD7afuZ6U6DrTO1L/GAKjyf3M1XqrqfaU0S4NKYLZB9jznbsWggwIUpCvP7FjqJG0xjcvE3VGesfllEQRzBtKp0VYZLDN5vDtusFVuoR1C9Wyh+bIVSGiM6yoyPUE07oXbAQ+kINMgc+bKooOgzG3ef9I8i2/m64OIwt2GIJWNvlIOmJYrESDWqvsurVJx/pLNxzGiuQGX4gq2SwLXTrfAgmE7aG98j3qo7L+eBwUi7giAP7WRZ3d5u2Cvj7TMy9Bypl2YbfOV3nyXIyBzoIlq5774XAdgn8xWW0EfajNpfUvhyboGgDojr4eRxRRlNRZUDMz8p1mDn8Dg/rIG+0GA+fOtTgfWPdwBVAZfI76ZFQN5Qlgdb262F+a/O1Weii9lZSKwer7O/rFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

---
 .../ABI/testing/sysfs-kernel-housekeeping          | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-housekeeping b/Documentation/ABI/testing/sysfs-kernel-housekeeping
new file mode 100644
index 0000000000000..3648578200111
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-housekeeping
@@ -0,0 +1,22 @@
+What:		/sys/kernel/housekeeping/
+Date:		March 2026
+Contact:	Qiliang Yuan <realwujing@gmail.com>
+Description:
+		Directory containing the dynamic housekeeping configuration
+		for various kernel subsystems.
+
+		Each file represents a specific housekeeping type:
+		- timer: Timer and hrtimer interrupts.
+		- rcu: RCU callback offloading and GP kthreads.
+		- misc: Miscellaneous kernel services (e.g. kcompactd).
+		- tick: Dynamic full dynticks (NOHZ_FULL) state.
+		- domain: Scheduler domain isolation.
+		- workqueue: Workqueue affinity.
+		- managed_irq: Managed interrupts migration.
+		- kthread: General kernel thread affinity.
+		- smt_aware_mode: SMT-aware isolation toggle (0/1).
+		  When enabled, writing a mask that does not include all
+		  sibling threads of a core will be rejected with -EINVAL.
+
+		Writing a CPULIST to the type files dynamically updates the
+		housekeeping mask for the corresponding type.

-- 
2.43.0


