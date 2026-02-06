Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33EFFEB28D0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B74B6B009B; Fri,  6 Feb 2026 02:05:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996266B009D; Fri,  6 Feb 2026 02:05:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AB976B009E; Fri,  6 Feb 2026 02:05:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7868A6B009B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:05:59 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 450FDBB22F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:05:59 +0000 (UTC)
X-FDA: 84413147238.09.73F5361
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6CE144000A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:05:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NE8e2bi4;
	spf=pass (imf11.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IB2/ruY1e1gP0SuPgYbrsKSnwM+7BBdQPj97g55uYUE=;
	b=WyYvGj4ANu2srZuIC6W0DkOhQ0Ojor276HAPv/0eZsM++IxQPxXQ0sr4+fVfLNaMRfnF4N
	Q5osn3AuapoLDQLIpQzCp1aC4DjsLlrdAyDVklms/kt1E721qhd6Sm6ov6SUNDikbn6pgM
	Jrgg7/f+b7G6ckK228NXr74/hI7j3qY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NE8e2bi4;
	spf=pass (imf11.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361557; a=rsa-sha256;
	cv=none;
	b=ykq7mBOX2Xt3xCfnXnosWxgnoWwqp2JuicT7DfsBaPylf0FXS6k01gqVvXWAZHhh+3SFwf
	+Q1Mzyt4wlHsSH/pitfkZiucp6gC5YT8mHLukWcNIH8AxF6fvuffySOgaC6B8qhLf2W4t1
	x9Gz1tWi2+VDxmo9CBbDcfLXudB7ueI=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2b81ebac5d6so2344470eec.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361556; x=1770966356; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IB2/ruY1e1gP0SuPgYbrsKSnwM+7BBdQPj97g55uYUE=;
        b=NE8e2bi4hFUsGT8Nrm8HiIBaTG4q3ll4B5QU8zFAT3i/xsdLKIOPaYGM2rgEfU0WKs
         yu2f9I5HkeFRFdJcVtmaPzJhoCTLEC8hYrU5j+dy9/fZzY3H1rF9cnMj+xs25SogL3y5
         kxxoKC17MLnSd5gXOKe6sQu2AWcGBfkoGzObMQAcWBxtBamHOvFvXoaaa8C5ORxYBrJh
         zebbjUBQ3HdyRDfVNweUaReK29YF9kC43SeHiFfpRXBlf4ZAcHE6JVVmYN0e05zEqBAd
         /MW0biXbAGlmOEcJu5gBHTLWFnKKyAV1fNVLfKvpgykCITeZTzgd1xC85QtKzs5xtSIq
         Ar3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361556; x=1770966356;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IB2/ruY1e1gP0SuPgYbrsKSnwM+7BBdQPj97g55uYUE=;
        b=gskTObOptjtx9niWPGAQQJVDexru8h/im8pK7akubscDEmda/N4qo8tvnQ9ka9jVdy
         mxzTDRmZEw0Q9UcT5CXRyQj9XfbxCj/QhyIqnW5+4C3z12psxiLHemJPqSFne4cQhtmQ
         Pf2xs9CeeRHcLWdXZLIsk8oPIqZ22OwSYdO+zXOe9mcr7avH3HACFcrh73ndlNVKTrkx
         QnaXfIdUvzQxy8n5h95Dgvdg4zXy77pKp5NRjEO6OoscG+NqwNaptiCT7cZDBVhCeSKP
         eAiWnTjEInhGSXmk+vyjA6noZ7AuWWNWy1O5vbmMs5U5s236+uybCVF6jJ6I8ZrOAX4T
         eUYw==
X-Forwarded-Encrypted: i=1; AJvYcCUud0osWnYmoLkyZPxGgQ2MwymfOmAupBDdtUGnke5Viqc9nSwsTTBDl2RrhauhY+eDO7wWb1lluA==@kvack.org
X-Gm-Message-State: AOJu0YxShykCwZU/ELATsrgU4usTGBl4oqgYkBuRD8oBPVwwnDG9Y49y
	783T4k6L4TcIf/xjFGuwVqeV8yaWaUe2hwaf2B893bQ/cXAizsIQGFBH
X-Gm-Gg: AZuq6aJg2EHXVlMJpTlIcm+rbyPshsYFbFn4nXj5KFEJICJ7WlYeJK6OYp/p4EgisgO
	T+LKFONKZ2Ht5lv56d9J8c5yo3lf6HO1kLC+EganFG6K3f+ACpDPeNcFRIhH4UGGco/axLVT74S
	Fbt7EFq32of0MzXquXvfSkDxe93UJK5RNxYADYUaa+OKgvf90AmRmj452AYXs7LFkSeJcZkkI+X
	BZGfiSL3PHgHBUCFr8jS6Nj4SI4YaRGKI7cNTK2HoxzZJ6z+XCU3DVmJi/n8u9li6nw9ul97/u/
	0bg5JB1GonRYCXx9/7sqWAaiykfveRjAZnsrgXQgBecqnSFEKIeyVXSooQVEkyoM4zY4NhJces6
	UA2sIG0v+k0NYHuIsltqvYA2I/7E8JqxNLn4lXb4k/L+X01FAQ8ueHd3L1cL100Hftfhyefcsb4
	bSQOewrmoyuQ==
X-Received: by 2002:a05:7022:4a4:b0:11e:3e9:3e9e with SMTP id a92af1059eb24-12704074edfmr999273c88.49.1770361556050;
        Thu, 05 Feb 2026 23:05:56 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:05:55 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 06 Feb 2026 02:04:26 -0500
Subject: [PATCH RFC 05/12] sched/core: Dynamic update
 housekeeping_cpumask(HK_TYPE_DOMAIN)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-5-00a711eb0c74@gmail.com>
References: <20260206-feature-dynamic_isolcpus_dhei-v1-0-00a711eb0c74@gmail.com>
In-Reply-To: <20260206-feature-dynamic_isolcpus_dhei-v1-0-00a711eb0c74@gmail.com>
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
 Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 Qiliang Yuan <realwujing@gmail.com>, Qiliang Yuan <yuanql9@chinatelecom.cn>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6CE144000A
X-Stat-Signature: rcsaidiigaxwrkzyy57nb1ky5wpk4hmc
X-Rspam-User: 
X-HE-Tag: 1770361557-719691
X-HE-Meta: U2FsdGVkX18RkuLpQhPfO3dib7ztNSrrfgp1hq6NRENmXTdahyCKbQvTm/1zZXXJO4QkZK+jb78EtYbBspB91TDpAnfSaXuvOxg/TVQfz3bOuyJSIlefTudNMLVJB0H6/95ckOyKnwM04nytzCJrSwgclQMv0VzoY0RePmJbcZw6VkTwp5bB7y31tefOs1T3quEkZDqzA58wA7P5Q3OgzzyUR8dAmVAOFZPP4oSZptnUjFM95ovJCopJXORDw/xfO2DYdfitj34B72a55SZij/Nnx09fkjICwopsS2wcqW6SIEs2lKXl68PV7oOjlw8+Sk5xWJ/h+huGjkR6FBVDH5EVcayZU4D2yLiHZjq8QLLotjes27/GmwOJZXquPkpO/r4HCXtBb1HcZcifJ7G9djYUJ03znDgCdX9jLyVEJZh9rhH1prs0Z3o9o95p6tEJfEWpVxxlUqswFUKaMnN09OmYbtHUIikIa9Qacnv2hKPOCU+wWbNNYh24PVOmtMS36HOZs5WusJdA87mCSGUvcD+rrLrt//3Xxainl/4hv+8iUjtlxj09tDBQuot5t8fPLoYJ8+NCtAayMZErflNrMhb/tJhjJQRc/7VaHxTk5vMtBgi9SUbKdjs9fTFAqQ/PcGpii+6tkgBsxBwrfEBPG0yQnB2AlXy/vDf8+zMYESTegdvGq0L0YiWe9lgPl9yPZBm0piLV9boZHRcLxq+pBHBz5ONr4FHmbNTx7RAuUyvruWnupqZpEnCrWsW/2TuqFoHzNArLDWNCVFuNa9u3ZYDjyAKjfskjh7gAAcVOsho8BPp5E4tTqu72BtKl8CKPv3uaGH9ZSBgp3DF9iYgoYH1tX9nb6Hjd+IBn50uvMc0AldOUQF1yoIwCzMoJlzanWl1eHYzIb02cSWjxwSumtNHAFkMImys32bWX+PeWNMzA4u7Fyr2cflSno3tf7xsJXW16GS0XIwPOBPNxsps
 cX09lvNU
 ZDC8OpDHo2PLcyDJAx8kL9hG62NxzBrL1mJnm1YwmUqpIuz4dIWRKHdGG++dAbNk5ZLdFX+7Jde8qxHtzHNNFVXM7cyw5rDYUfXG18J08p0Zvrtsa/kIy85QEqB+5CmhcbB1s3ZGyBd9w+59FjY/a9Lsdj07VPB9JxsJY4DGezJjPZ1QAhSZmYh71o0nHjBh9RvjL+e3h/fPmP4u95ECIuYdT15Jjm7D9ayaw0h9l4q0wbhVvuf5b4YdopFiS17ticO8JnYw578Od6Qvk2pdlGPP9lRrLe/e8ge7P3A2xfLatDC13N+ppuvFpcYGkxdAdPRvNCNxJku23xwXrIECZPaDZ/rzxiabFZFezHAMPw36yCIBJBToHdiH/MIjw2uuWOQNse9tNAbMP2os4j+Hi8BlgYuBWTqXwmZyiuxuyWi4Oxigrgr4Zrd84z4MMEEUMZlfq9zMaYQ3Mvvsp/D1C10S6b54qyAG83Xg+2cvGW8H3r+ugpmcLqrm5ubLBdeS6v9hSElBAO6SrQGXZH9j1xMcpjjn2OilNACCdqX39/hhIv8T9RNemFsoIl0DNXFpUf4F1fcjhuJQorz0hWOdh/XaaJOOvdBfc1gRXiY9LHt4XA4P/0jF0TQDtFv2VLeGA7h9yjcuciiVJojQBgl5hkdnIm/qKxMuJGNom
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The housekeeping mask for scheduler domains (HK_TYPE_DOMAIN) is used to
determine which CPUs are isolated from the general scheduler load
balancing. When this mask is updated at runtime, we need to rebuild
the scheduler domains to reflect the new isolation boundaries.

Register a housekeeping notifier in the scheduler core to trigger
rebuild_sched_domains() when the HK_TYPE_DOMAIN mask changes.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 kernel/sched/topology.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index cf643a5ddedd..7f218fc62183 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/sched/isolation.h>
+#include <linux/cpuset.h>
 #include <linux/bsearch.h>
 #include "sched.h"
 
@@ -2940,3 +2941,28 @@ void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 	partition_sched_domains_locked(ndoms_new, doms_new, dattr_new);
 	sched_domains_mutex_unlock();
 }
+
+static int sched_housekeeping_reconfigure(struct notifier_block *nb,
+					 unsigned long action, void *data)
+{
+	if (action == HK_UPDATE_MASK) {
+		unsigned int type = (unsigned long)data;
+
+		if (type == HK_TYPE_DOMAIN)
+			rebuild_sched_domains();
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block sched_housekeeping_nb = {
+	.notifier_call = sched_housekeeping_reconfigure,
+};
+
+static int __init sched_housekeeping_init(void)
+{
+	housekeeping_register_notifier(&sched_housekeeping_nb);
+	return 0;
+}
+core_initcall(sched_housekeeping_init);
+

-- 
2.51.0


