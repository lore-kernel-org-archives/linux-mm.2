Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 736D6EBFD0A
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:45:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB15E6B00A7; Mon, 13 Apr 2026 03:45:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D888A6B00A9; Mon, 13 Apr 2026 03:45:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EE66B00AA; Mon, 13 Apr 2026 03:45:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B934B6B00A7
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:45:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 772BD140CCC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:45:37 +0000 (UTC)
X-FDA: 84652747914.02.1170D99
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 88F13C0008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:45:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pCwbIV2E;
	spf=pass (imf22.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776066335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I5M3+b2z7keZbGNN1L4pc5gbCusIv4rK3WbERlRAtRw=;
	b=0Hx55TfpVuDY5hU4NEL/NUtUz7353eoXQSAIUBWI1gn49e0sWB7RBVIw1rcw8iQlFRUvsX
	+/wsmV0yEG/496jVNfNdnxxzVLVA25Z/XrnkKtYfeT+gHn5NUNC7QkG1X5D79ErQd6SVFU
	trb3ImcVy/uqWNZgnQbK6rc+8Pf0NHQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776066335; a=rsa-sha256;
	cv=none;
	b=QbqH5MWPWmkGVahRPPy1mMbKqcVo7MvUu8ol3uqQadnhV6wL+I4rqlQAvzR0ZIkpEiy+Rs
	7QVETi+P5Ous3VKPFwUEvXan2OgFC3Vq/Zolsh6sBjQz644H/zdm8E7K+Hawu45Oc//N4I
	APzpi6goJGUphr4FGzgYr1b5thKCbKk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pCwbIV2E;
	spf=pass (imf22.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1271195d2a7so5345359c88.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776066334; x=1776671134; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I5M3+b2z7keZbGNN1L4pc5gbCusIv4rK3WbERlRAtRw=;
        b=pCwbIV2EhjkIUbPmNf0NZuazrjGptUtvg+/1+kGiKtWaD1mdMl/gco30TGb2JdH9tR
         WuHyp6kjqQAnh04Z6b23jVY6Npm5wxil/FsSYegnV9c458F/TtP1dF+/yrb1O9u22Naj
         0WKq+koWvr9qzWGd63LNUVoe/8dcaOT/13CwUt9ICzcjqlbX+5e3h7Xjm2BJ8oiUtAzn
         Mc/HQ6lZ1ZJwsgZbIpde5xRU2G/zsV13m3n9Sw+xhtHF/T59R2POM7Y79KWQFaNQ/OaY
         4LitilBq9b/gunHR93GNo9PWOT1oj4uIHeHuSlrwg6yxgMTeH/Bw8IpTCLfFoMukCVOL
         p6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776066334; x=1776671134;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=I5M3+b2z7keZbGNN1L4pc5gbCusIv4rK3WbERlRAtRw=;
        b=LlMpYlYbO2WUGtynqwUqknCwddV71ziVw1hXkTUNzSe47xkJHJ/imi/GBmVBL0P/ia
         p4uK5y049fkUjdaHUg7ZSRRFpoDCJ12BkRAiQbJToOeShsUKGA80z/P0uPVU8NABg5Vb
         kW7sX7MMOzci6T8nd1+MdZpLcmx5Y3Pp3/R3sOCwdvSlCInjK+4C/YK5C+adiP2X+GyS
         yEQJX5x/MUUrIUyhkzBx4kVdo66k0+4i80doa8h+fvyxrJ0EK5fPIeGRgUrkfZe/PySf
         ws9G3FzyvElt0xsPVq+F17PPpv98iPCURS9EvdoojmJjLxU04l9/CFWVbTbtLHBGZeVT
         t4AQ==
X-Forwarded-Encrypted: i=1; AFNElJ/RXIE0OMlXL2ia9npp29ywCXGvle8k87QRquICrE0CLwAgIbHYUedTGopLgq2XCLutvUxDVQPCpQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3JLuFc8QCO/Mo2Wcb7ufSRN5ZlF0ACUwN5ZAtYx4J3ZmqveGC
	xvGACqiqA1lqK8ZaUIwDNIqly+ehJXgHjJ1BEjT/9FZ2AnChaoVLbsgcxpOpZjL0
X-Gm-Gg: AeBDietkjZTTZgrtIsvxrJsEtI/RpptwaogRpNGLT8r8v9vIv18o4T3sZHBZWO2BT/b
	KC4S5+Oh7u5tjbckbmBDIZNlutVqQXX/v68pB9PmBSkpCYE8DEbCbH85+hyV8F6Dp6RvfJr6W2Q
	dpKYZmgrB4yK/uuq9SmCR20htUReOJrhY3C/GCmQdnf75FZk70d189z+Va0ItehtbkJyxrCWQTM
	YSmhqAZv2OtBZEJWAvl1/J9kP/xvnZiPVpkDgKldmXLvZm39FloE3PCQ6lWZahS1n4s9qnkunk4
	tCTZFULyvxnp9SSaRZmvSEOIpRe+ZCWOQzwxAW18/B6oDgTGZb0KI4XCg8CcirQzKRzeWr4y9N2
	EWnyX97PG7uJ3vjQuFUnqEcdQPNILsZ6S1MY5UtmOGeBbjULfbgyHa/46l0VzbRu/uc7ZUbYkXz
	WRSYv9aa/ZoH95nELK
X-Received: by 2002:a05:7022:e1b:b0:128:d107:da0f with SMTP id a92af1059eb24-12c34ea9471mr6689826c88.10.1776066333988;
        Mon, 13 Apr 2026 00:45:33 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c347fa2c9sm12884610c88.15.2026.04.13.00.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:45:33 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 13 Apr 2026 15:43:18 +0800
Subject: [PATCH v2 12/12] selftests: cgroup: Add functional tests for
 dynamic housekeeping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-wujing-dhm-v2-12-06df21caba5d@gmail.com>
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
X-Rspamd-Server: rspam12
X-Stat-Signature: bqt5j5mew56fkab51pm878666mh9ur7t
X-Rspamd-Queue-Id: 88F13C0008
X-Rspam-User: 
X-HE-Tag: 1776066335-966089
X-HE-Meta: U2FsdGVkX1+THQBbojoOjTMj3ZCR43+1/mmwrtbF9K+3OErIGvOMzNJM98qm0HS2tckCDSXHWVwf4oX+iLeXpvhiebhuX+uLeOaDO2In0JMU/1QfQ14ic7J/RrPZ5ge+3ZcwMRoqadEEYFWObS1s1cbiMBsTj4/eSkGhfH9lZqWHqGAqBgw7CB6k9Ep06G7J2dc/bi2N7u5JhGrfN3jaKatGjfTS3tZ3tZLPzD0g/I4jHwGOWS6Asr1csZZuNrzIPRXOi2uS4Tyg7g3ubZvzBWw3Z2lcOiiopJwgYSObGvydND4qCG2j5LXYURO2r5Y9bC45P1FTdim18afNeQONGPPbAIP3CmvKdxBNIjA4xb4iolvaApxaEdflbuwr8taM2d3uXriwwXbtPhHTM8i8V5PlX3lTXo/tI9gvMp9DctwIEJwYH5YdqRzyot/fSvF0XOV1JqcAgQnt6it1rDsR1gBnrBVvOEBSZt9WBqTGlpBeRhdTyDgTtzJcS960MUP7mZh9nBtpR4kn2LacLJ3aCoFelTcfajhOuvy/4WityRQijbEnQRZBBdBjFw810CI3EwXwZKGEBGcUp2jLqhFyCQiax+DOof1W1/PFP4j/f1M/JNPeL1q4ci7GLT2zsf/7ppYiR0MVG5JLRvEDHOwHd7T0g4ihNECvi5JDxtjZSPJcdjSm5o8Ze3d+ET/SdH2csh8FRvTrYJwK+HeGTqOxSUqQDguBkBfkwPzBnzI3E8trkABnsPonded5yccr3hq6LKRitL1Q6m1HoYhTUVlHxrfXAATgEt1crL/aWFOlpxcCx+vsKrjXtSF7oKKfpnQJboXuwR6QdsgA3+TIp/jehzgeEKi/wuqeONGP5NCxg2SZ2yOfUQrhzb5UZ9plbZir46KCtOydf8rsbKukYVg+Kj9EG0aj007yADT9kTonRcjG2IkZWbB0n9Qiqv1UKXEJiXVyhFzsTSFh9SDm7pZ
 QLFmFyB7
 Tf1x/jiz8V73NuzwiICLYlQUc5e/tDSpcROr1+g2cdcb1fZ84gR0RF4XSOOBqEJZihCcgwA65GQEXCZKtsv/xA8wfjlQHxazNVhY0p6w03fJPHsTAKoLyc6GrHxUg9qpEyduIdNwfxxuzZ0GHU2eOWxr5cAPMCrVhSXSRjE7K1dqmmcw30TXUmxIjQPy4Jg+k7k8EhQRv1Y1F3QpUp4iC1UvmHSUEPYmIirIyG3q+JmZMFC4gqUm0efz+WBfEA1f5IRtIGeS6F7AQAjDXDYHKq4JtCGczr2TpF6yvWyNV3rZJm5gdRCYpIni9kzWMKBK6nlvxYBIi0itYBHBgEVQ2nPSPjFoyQ0vFwGWFkZQ2EwQLRPmqt6ZCGB6qsOyQ2MUGczdF12q86HYVPXZYlOMHCNuvZv3OAppx2MWyBpX3pjkLzbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This extends the cgroup v2 testing framework in selftests to validate the
newly added Dynamic Housekeeping Management (DHM) cpuset interface:
`cpuset.housekeeping.cpus` and `cpuset.housekeeping.smt_aware`.

The `test_cpuset_housekeeping` functional test verifies:
- Validation of DHM's SMT safety guard (`cpuset.housekeeping.smt_aware`)
  by ensuring writing to it behaves as expected.
- Basic read and write capabilities of `cpuset.housekeeping.cpus` using
  the base CPU mask.

If the DHM functionality is not present in the kernel, the selftest skips gracefully.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 tools/testing/selftests/cgroup/test_cpuset.c | 36 ++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cpuset.c b/tools/testing/selftests/cgroup/test_cpuset.c
index c5cf8b56ceb8f..b2a032be4407a 100644
--- a/tools/testing/selftests/cgroup/test_cpuset.c
+++ b/tools/testing/selftests/cgroup/test_cpuset.c
@@ -232,6 +232,41 @@ static int test_cpuset_perms_subtree(const char *root)
 	return ret;
 }
 
+static int test_cpuset_housekeeping(const char *root)
+{
+	char buf[PAGE_SIZE];
+	int ret = KSFT_FAIL;
+
+	/* If the kernel doesn't have DHM patch, skip */
+	if (cg_read(root, "cpuset.housekeeping.cpus", buf, sizeof(buf)))
+		return KSFT_SKIP;
+
+	/* Test writing 1 and 0 to smt_aware */
+	if (cg_write(root, "cpuset.housekeeping.smt_aware", "1"))
+		goto cleanup;
+
+	if (cg_read_strstr(root, "cpuset.housekeeping.smt_aware", "1"))
+		goto cleanup;
+
+	if (cg_write(root, "cpuset.housekeeping.smt_aware", "0"))
+		goto cleanup;
+
+	if (cg_read_strstr(root, "cpuset.housekeeping.smt_aware", "0"))
+		goto cleanup;
+
+	/* Read root cpuset.cpus.effective */
+	if (cg_read(root, "cpuset.cpus.effective", buf, sizeof(buf)))
+		goto cleanup;
+	
+	/* Write it back to housekeeping.cpus */
+	if (cg_write(root, "cpuset.housekeeping.cpus", buf))
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	return ret;
+}
 
 #define T(x) { x, #x }
 struct cpuset_test {
@@ -241,6 +276,7 @@ struct cpuset_test {
 	T(test_cpuset_perms_object_allow),
 	T(test_cpuset_perms_object_deny),
 	T(test_cpuset_perms_subtree),
+	T(test_cpuset_housekeeping),
 };
 #undef T
 

-- 
2.43.0


