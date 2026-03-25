Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39866FEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22E16B0099; Wed, 25 Mar 2026 05:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AC4C6B009B; Wed, 25 Mar 2026 05:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C5A6B009D; Wed, 25 Mar 2026 05:10:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 743B56B0099
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:10:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45B135B2BF
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:08 +0000 (UTC)
X-FDA: 84584013696.11.A2D3F49
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 638DA180003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RIkWHvVJ;
	spf=pass (imf24.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429806; a=rsa-sha256;
	cv=none;
	b=mo89mNmtF0YGoaOHrPLPZhDmsB3SUe/02nZWXBrBjw4EZuwKGmLdFUFV7nfSCD8aKGv4h1
	wTeAe0Avt2EjdRZSAsUpNYqls0k75s3qTvKiwuEvv3goQjO3aypwA++2yf7KkRrwHkPxsc
	OlmmpWzcC7yFFmAor3vFeCS+nI0Fyxs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9UY5bvoYUVv1VU3Mf2W4jpyCEGASZWHJe/emL8ca0U=;
	b=HAdB0o+6RHZPujcQit4fu5PLDzNwdYJCDckoHQI3VKSlOt+v8/SNKrDTPOaDkBM+YNEBiq
	xzFZG7/WT1Tk8A5MPDDg6+6y77pVGvz2vC3yVUCvAqgOHD1ohGTqn68wmLBYRPuMw9O75R
	TIyB1p1WFwxBhb8CmyD6DAXSDqlTRMI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RIkWHvVJ;
	spf=pass (imf24.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2c160cb021cso526881eec.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:10:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429805; x=1775034605; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/9UY5bvoYUVv1VU3Mf2W4jpyCEGASZWHJe/emL8ca0U=;
        b=RIkWHvVJNyU5DhjKGTlEUwPth16ZbvtZIxyzxS8hkM0BsYYDj8SfQ8a+V1heK7KaBv
         2kA32BGaYiE/QIenfggOPW8RTBcQ2OY8AXkiQn7zBai0J1B/vsWGk1n8XYRhR5uL+MQk
         DlyhnQ0sL35MdfPYn0cLmU7G+iTArYA8TE8PgPvbYYfM4e1XUKkyBl/xq/eUs1gHf8ee
         hJ2jiqFVLm7wX0AvSpxrAsZrcj1NaVfmZlZyRhuVdwVfU7kf1wKN06iXlVw8Gz54c845
         MZctHzqkXpR/KvFhgTU7yENSLRCN3Qh8QaBqfal5N5w8iDx6xsvcd5E1pQdUY5kCv2wB
         07qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429805; x=1775034605;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/9UY5bvoYUVv1VU3Mf2W4jpyCEGASZWHJe/emL8ca0U=;
        b=I+/bTMU5icYaG1RC+RnsFCgtWAbcERMqVzYH+kr0T5JVqG3tNRDjCHqUHapxU8VWAj
         I0CzHwg4BdKGUQcFyW+7r+MYqn+5OfyvBzGrrYIABXyyUig5su2+7D1F4NLzI0cyL/up
         xB2GJClDMS3oXx0z9j+aE3c6DIDuMCW0hgG9+OF8w+C507PpUaB+53Jp/tPVJv6xIXCo
         fH3o6UElu/i6UQFqsjt7Ltww+ecJjF5xUUaNieJmrfM2u2DOMQvZH6a/BYeRIw78gnpl
         f+3UIqLBTv1OPSIksz+ZAPxWh4THSM71fWE1Q6rTgsMtWeOed1deHZh7gFT7ixwlBah6
         5kxw==
X-Forwarded-Encrypted: i=1; AJvYcCWVMdtl67+iARQSGXwnz2I8taIJqWcQynMOq8bzIYEc5dwrfURrd/piGeqGX7WH4jQwYebSwjtyjw==@kvack.org
X-Gm-Message-State: AOJu0YzacseR67grpdE1x0zPBkxUReRWzm3znKOrbEez2Bn5ILACfLYQ
	SEUB3NkyGbBW5PDthBSGEgIJg1XmRI7VwNhqel8bsPMSCJPCu1BHweXD
X-Gm-Gg: ATEYQzwRVmP/JDbapIa7qhcLfkegkqjwzsgzV7nzED4p/A3h5TkcpdbFzJ9x1e7+j8J
	/QHy1pfE+9/UJXS/Lk6PnFngTcR9IpqNS24XfJcP80lMhXt5IATNX/dVUz384koaxg9e5DzlQMU
	Cad/wyyVzlbwSAumL3Cr2d/2U/nqvUh0khlFR6lZRv788JXY3SuAC5RE0ZLmV32EcPI3so7FwsK
	P1jcfnrw/r//lvfBuS3FRZM5eVKsPOjVVk6mjVM8R7V9gL7I+Nh+ItUa/XM797JgcDMniY7Mx3t
	tsPnzTRriZZb29I7e+HMCg2xM4o1S74wfGpIE4bwd/YvyPeJqvwun0aZmTDUwcWBX83Oc0CuWI/
	Suv/552/ztGTiTzIp/Ln9zhzh8dnBzZeYlKbEASgiTkZEUGktg2ZVjTym/B84r3lxiPg7hU9X7I
	sKBgFZjpUhI66cosXr
X-Received: by 2002:a05:7301:5781:b0:2be:1779:3289 with SMTP id 5a478bee46e88-2c15d4cf79fmr1292448eec.35.1774429805106;
        Wed, 25 Mar 2026 02:10:05 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:10:04 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:34 +0800
Subject: [PATCH 03/15] sched/isolation: Separate housekeeping types in enum
 hk_type
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-3-919cca23cadf@gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 638DA180003
X-Stat-Signature: 9o7ozsmuem3qmncg8sogawwg5enqnhp7
X-HE-Tag: 1774429806-904628
X-HE-Meta: U2FsdGVkX1/B0UFg+gIwP8ZeymsyG8Re9IN1Evpx5H/kBHlbow649gpT/WP3KtnDrFYlTdjs0BReqjr53c/WYhw4AHIEjBZ9qZcLpxOwiJeZgdrcQIKj1VRKJ5kD+of7Nh8257haar4mF6jkzoEgGqwpBCEGZG07Exf+5GfavkKiL5dvumwLMjlP87Zm4MdnPwhN7aiTgxcv/uK4/GG6xWUexVQUGwkirrC6+CwTvgtmrrR0Jeo6QKKRzMOUEkefig7c/J1AwsrP8FHCYEFVnVjJPyn7h/Wytrj5e6b2lT7uIdp7FlRF4xdg6hiLP321yg3qvDzafC3S0UNjlzsDTx7/2lF4/zd0gKcU4lrP4jZxSD97AhWhBJvG8WE9AanS1BFthdvD5QnrRt+fwf/3/m2MrmJ3gW/xlyWZ8sQGKRGTRYkIr1MQmOh3zPCWLRv9WgHKGzcU8AJMmGWR27oGATAmj/rSDgYx6C1iLgwze3OEXFfV4D8CS0P8m7w9QgpBCboHN7Y8t1EKK7p/SaYPoBTgEFkrmbBxu0UvFLUOVSgP/2OkReWjl6m/EEHFpKjP+kTVw4DuaMtka3+NH7mxwsBcTRm4Yt6AyQMzlMjkQo4P5ocEs/+oh7o2Etdsvr35M3jZDLTFmV1efAHP/ITBX0XOtfCZq2qsLMx/t9tyZ91UFOEzcy7hKoPJgaiCLdBCNPsX0LEjK+Rtf2rydNyi01dZIx/Ri3iWVZJBogzNYPBGq426Aq47iqgCzQhZA84S7/NlPh+z/ZLZAfJUm3nMG/iqYtXn6P6XL5saJIud0I12WqiT9A09936kg9NXqx6+lMgznNOCwam6KheBv+orPDjIpufNxGkKUV1u/dUz+URyO5gwe5LRU9qht4c4CFPl5BIYUOTiEd2k+olg6pK4qWsGh5KxMDcop+3lUaOmVueYPYimo1cHpB2TM66kUWPHpXTg+n/QERc34Eq8aQk
 8GKf/7SS
 /BFnp2MqMKgkI3p8oDtpEe4oj0UKgYZcqBGA6WDPNLHNL+1vdvb6kCWMvKW4RGEdCRePt9RZQgfyiObPCiNnjFoX4orVIl7+2ox3TB+mpowauA0URHaCF9KW5e8H4obY4Y/FcuCu0gtjAUlKtkrYqr4kWWFIw4ysJ+dfuUt7QWHhtjQ9DeGm27dDbASFT7UlbZBA7aPg/lQfKhrWufN0pbAsnvVtugiytlLJxxiS23sxVbs0yBxRWo5qPEEkvkiRXCUeAp8GNpEhqIIrckP/SO5Lbe1XryaD0RvKxNGe685H5UVZcsgoAzrg/O5wppvFJUZDfKC4ZBMmfC9u1+nkPU3qOjSA/JyY2bUCA1qpjWn87A6klxJVC9HXShTBAUCsc6JUnzjjQ9/WjNb95kiuqUYFL+58EB/LTH7YftgLaZBYZ23Cmx2n5Jtn3CWLOZ0PqfseADxsZSkL+/l6Hk/bT4MHoQD+xr5iyniegvcTG+/Uq0Z0fJN8ZLxAXix6keB/EDtZIYrlA4PgtitOOWnPmOPCMO/Otg89Cnt0s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Most kernel noise types (TICK, TIMER, RCU, etc.) are currently
aliased to a single HK_TYPE_KERNEL_NOISE enum value. This prevents
fine-grained runtime isolation control as all masks are forced to be
identical.

Un-alias service-specific housekeeping types in enum hk_type.

This separation provides the necessary granularity for DHEI subsystems
to subscribe to and maintain independent affinity masks.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 include/linux/sched/isolation.h | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 9df55237d3901..6ec64eb3f8bcb 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -10,21 +10,18 @@
 enum hk_type {
 	HK_TYPE_DOMAIN,
 	HK_TYPE_MANAGED_IRQ,
-	HK_TYPE_KERNEL_NOISE,
+	HK_TYPE_TICK,
+	HK_TYPE_TIMER,
+	HK_TYPE_RCU,
+	HK_TYPE_MISC,
+	HK_TYPE_WQ,
+	HK_TYPE_KTHREAD,
 	HK_TYPE_MAX,
 
-	/*
-	 * The following housekeeping types are only set by the nohz_full
-	 * boot commandline option. So they can share the same value.
-	 */
-	HK_TYPE_TICK    = HK_TYPE_KERNEL_NOISE,
-	HK_TYPE_TIMER   = HK_TYPE_KERNEL_NOISE,
-	HK_TYPE_RCU     = HK_TYPE_KERNEL_NOISE,
-	HK_TYPE_MISC    = HK_TYPE_KERNEL_NOISE,
-	HK_TYPE_WQ      = HK_TYPE_KERNEL_NOISE,
-	HK_TYPE_KTHREAD = HK_TYPE_KERNEL_NOISE
 };
 
+#define HK_TYPE_KERNEL_NOISE HK_TYPE_TICK
+
 struct housekeeping_update {
 	enum hk_type type;
 	const struct cpumask *new_mask;

-- 
2.43.0


