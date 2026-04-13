Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD5FAEBFD10
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EC226B00A5; Mon, 13 Apr 2026 03:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4026B00A7; Mon, 13 Apr 2026 03:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9A16B00A8; Mon, 13 Apr 2026 03:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7A76B00A5
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:45:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E7178E3FE8
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:45:25 +0000 (UTC)
X-FDA: 84652747410.08.382A5CC
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf21.hostedemail.com (Postfix) with ESMTP id 00D631C0004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:45:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mRvgv2yC;
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776066324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNYrrMihyJ/UopuSP8NsPFIh0brjDU9y6jBpikXxsOI=;
	b=iWfZ1hlYHYHULpvvgU2eHsPo9Ianje6iqxvuxCcpPoRtbf12wGmM6Xtrldybj6QbOkDLm4
	QI8jfAkDCUqhou0fw1ndRoduSm40wsn8kSI9cMjopkzytM4+x+KbTR4jymnEuOngB28Het
	4ZgHUaPGcpEHPmqpqKTdV+sGPzaAxLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776066324; a=rsa-sha256;
	cv=none;
	b=G69rALosFSAn6fNITjlee1WUOBr6LSwDKuIAhoH96GIAYnKodphp0UFSalQy4xmgWGeqVP
	8Bmpy2BiwqdMvr9Q/YR5D7OJ5atViLkTuGvhwQjn/DMCexN4EdWIDc/on4rYers0l+XzTC
	WDd8CmZW08Xc7x2jrMUh0ax7mo/Q3XI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mRvgv2yC;
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-12c45281a06so1611496c88.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776066323; x=1776671123; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eNYrrMihyJ/UopuSP8NsPFIh0brjDU9y6jBpikXxsOI=;
        b=mRvgv2yCSGCFq90mhWYqI8nLaEDl3pPRmTLvP5KbgfnmiZsMGZ/nV74njucUXMsx3v
         J3PXuEhmC5CauZu8GZ9/NIUFBJN7oE+/GzQ9fe/Z2hTAaKP+ohC3rpgrwV1gv+7uewSf
         YZ8gVG2XIkP4t7vTmss+UVS8iMWYZn0NPCtCDdHdunzUBkKEs5c1NpQJh2RTvkQPp+wP
         4rBciJruGIZYHEjuxn+107B/xcO54FD7JQAoJZAb/MropoorW9GWZ7t8tsp9uT9ql22E
         XwbjVlY/e2ytWV5bNqhkjf1wemwPQk6cqkWxsEVeAuUuJkD6FX9zxPOG7zaj5wM+psOo
         k9Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776066323; x=1776671123;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eNYrrMihyJ/UopuSP8NsPFIh0brjDU9y6jBpikXxsOI=;
        b=iDREB7OyBVPZsG/IVj2pjbokRNCOvLqSyN7cGCOuQBqFzHPhtvmyrOQEMqcli/Q8ue
         yNdar2qihww6r6zAp8tPJWb1h1PougONP2jvjmQ/61iuky7X3V/NzUKtg8307sIvwGI+
         k70jLe6c1aQ6Z8qN6O8/U5hKDBdsU+jAmqiXikPFXpfNB58LrC01BqJZiOfwIy+q0rHb
         AF3LT3eCu2iYJnuaSjwnT+J4ZKFsUAlHI2fa/RGwRPpwUOW7R0/3Im5SyZ8SahB2Agze
         vHCQNMGvDuV0SFPBunQo20UuMiHtliPFrij8AglN6ZdZa6krhfZlF9XT1QmaCAq7ca5P
         C9WQ==
X-Forwarded-Encrypted: i=1; AFNElJ9ThJoJ+HFKntyRYol8eWk+GHfqqZLI26rdKOUC3vegGfuLwWZJucFN5g7Kj3GrbESEnXYm/BvSFA==@kvack.org
X-Gm-Message-State: AOJu0YzNC1jqztbhfr6NdBgoy5z/08KsDU6llmANUa7X1az93oqvNHG3
	Iy5xnp/eezoviFZv5RUtU52xeNv4S4zoLQatRUUozpU+vcNk9b/M2sCkuAwsxVq4
X-Gm-Gg: AeBDievrV6OYOnEkP/tl37jqEdIvHoYci2hQgMBiaNsZ7ZiNn+x2Od/JDYNxBQdLyct
	qgXXGwkBoqv0pvOyUFs72UdHUZb0xuMt1GufWjJR4W4YfkgsGioPsXDMJ8lnaDMkTMLXfjk451l
	aydUWIaY15QnDkTBSLdSs+z9xbE+VqccdT/KxaHrowXbMTyY0h+PqCKa79EfUUUuRnFnX5y6Ox4
	9wwLtW9ogPrNfCFnz9iEGSKiUZFQpeiNSzk11/d+BoYMpXC5WY0UnJUG2iXBfjW/BC3LUVcJVfM
	TudobQjvtJvdp+LJlqWg2iCFpMAdkMQm9Q/P+0Fisvc36EGXrvyhg7cuCaqJfNz0JM6euGKjYAY
	oMIkc0U56m4F95TInTpHwbOZLvCw5fDFS8Hm+nISvJXdS3xxGReMhqBZxXmJxvocPovbhhAXvxx
	6CHPEmkd4BPDjZ1YpA
X-Received: by 2002:a05:7022:69a2:b0:12c:8b9:7208 with SMTP id a92af1059eb24-12c34eeb95cmr7021315c88.26.1776066322024;
        Mon, 13 Apr 2026 00:45:22 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c347fa2c9sm12884610c88.15.2026.04.13.00.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:45:21 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 13 Apr 2026 15:43:17 +0800
Subject: [PATCH v2 11/12] Documentation: cgroup-v2: Document dynamic
 housekeeping (DHM)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-wujing-dhm-v2-11-06df21caba5d@gmail.com>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
In-Reply-To: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Waiman Long <longman@redhat.com>, Chen Ridong <chenridong@huaweicloud.com>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 00D631C0004
X-Stat-Signature: 4kfbewy9mgeey4iugubftgt8xfdikwsx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776066323-803541
X-HE-Meta: U2FsdGVkX1+WTZUeH2BvoWsnVIVBdHhy+NrnwvYYrzoxFNlidaYAhYXOXoj4QXHoy1rdIysWdMEIvbZPxafCyRsi+9/M7Y64EWy1tECZ2/eacsAww6X9ZBzJw7FKhC3pUI4Ixu1SoYq1Ej/uu9NofNYVhC5IUQyS7SUedFVTTrAupmPUrleyxS+WtbFXFoXDokW1+jfcZTLWmrLxVTx9DCGceZnLu9E8G9mLRcR/B9dgKv2xmg/NBhzMaqWyptTvRlNkzPjTjjatl+LIxbUF250Ck03x0QtLD0y+OAC4lCR9r7gjzEhNK040cWkinUFni15JPAN7dDNiw3mx1wxV0lkiWZ0wPYVjjwC/TFmaMyyueAv5Tm1zZt/DkkcsIySdsMuR6IfZfaoimcgwVB3xiJH+0e5w6tx1a1MEt7ePJSb1ATIH+/YNkOn8VUUi+qgrwUDvdwCAAFOa2+AwQGgADo1ZevdLgTsM1qCmbxUKh8fUoQIlqO8X71tFRdxBqaw5Yg/sbCa7KVqFeAuELfPu60wNLiGUn0Pc1WBPM1HtTcP8N8UfEcyQANt0jyCwbgMSuQ1ra91JfhLQnqnwibArcz/4+2feQ2GZelM4O8idmFjeS7J48TA8tFDJEy21zP0LYOkRIbMLRruE+Qjf02O9CLoOF+0nb33js0kLYh2z48/Ia2cxJeA54p4vb/U0YQgLgjxkERI4mHhkfSwp+twmhLRHEletWqsXts6sV7OwDNIVIEQ1h1szqOKuBQlCIC048R2ZNf+NFY/7bLyW2w20GD2e1WUuctTLMok+RaKpC2F0pK2boyDj66om7ONn9y3/mESeo6nrfrEzTQGVPm3lQlYRppA+GMBSX8n7G24M80NqacWKaNY47eOUh0HZkc7fai4ih9n5rohU8isljFnbCMMkUoxEQlcKSrJfztqnhv2o7LyA0rAv8WkCu5ySi1Lrpxxnwpai2YTdjczPLLu
 T8JhXBM5
 tWV8SXjeUA+2cv3tj68sHAHvYGJxHapPGGXzXCY590oW9FKndeOB4UcNU2Y8ciBVXGtp6ST5qgSshN04NWoqjLWl/db7cTLelGrZVnov4+qFRrEyI65D3vlgk+lNRPjsQGiBt3tL0RlUqJEQ5j9eoCYapy9MOz5diH1Jd4qvY8BK9TUFjSE3yedMZlxjutaUxFbRlw5LhXWqpiVoKiP9DeQx3yByhHDjTAPSHN8qAdulVuviO3PmRMOLc0NjeSevtTvtRm8wkZGLDlg6osbqDPDUQmEAvxwFLd0u8sz1G7qMwbIL/LZwYIvSIQ7lQSl0dpY8CxhpRvkKNkTiedgmlmAuQf2RBy460p+e++nDRMj96aBwU/XPXkDocNUq/YCVguBzwCe8yTOGL+gjqSAbTjLhwySrQQGN2SISfgxQEVPoDxcf5aSAGDgZo7kgUceHJlC1YkSxW57lVGkpO3sQ2KX4BaatEAK92dQ3rJA1uvmAALohNDshzY+yo4+a/WjSJI0xq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the admin-guide for cgroup-v2 to explicitly document the newly introduced
cpuset.housekeeping.cpus and cpuset.housekeeping.smt_aware files.

The documentation explains the use of the DHM framework for reconfiguring
kernel subsystem isolation masks natively through the root cpuset without
incurring system reboots, and describes the functional restrictions of
SMT grouping safety constraints.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 91beaa6798ce0..deb644b88509f 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2592,6 +2592,30 @@ Cpuset Interface Files
 	isolated partitions. It will be empty if no isolated partition
 	is created.
 
+  cpuset.housekeeping.cpus
+	A read-write multiple values file that exists only on the root cgroup.
+
+	This file is part of the Dynamic Housekeeping Management (DHM)
+	framework. It allows dynamic reconfiguration of the global
+	kernel housekeeping CPU mask without a system reboot.
+
+	By writing a mask of CPUs (e.g. "0-3,8"), DHM will update all internal
+	housekeeping subsystem masks (scheduler domains, RCU NOCB, tick offload,
+	timers, unbound workqueues, and managed IRQs) in real time.
+
+	The new mask must have at least one online CPU. The value stays constant
+	until changed or affected by CPU hot-unplug.
+
+  cpuset.housekeeping.smt_aware
+	A read-write single value file that exists only on the root cgroup.
+	It accepts "0" or "1". The default value is "0" (false).
+
+	This file enables the SMT-aware pipeline logic for DHM. When enabled (1),
+	any update to "cpuset.housekeeping.cpus" is strictly validated to ensure
+	Hardware Threads (SMT siblings) are kept together. If an SMT sibling pair
+	is split across the housekeeping boundary, the mask update is rejected
+	with an error to avoid severe cache and pipeline contention penalties.
+
   cpuset.cpus.partition
 	A read-write single value file which exists on non-root
 	cpuset-enabled cgroups.  This flag is owned by the parent cgroup

-- 
2.43.0


