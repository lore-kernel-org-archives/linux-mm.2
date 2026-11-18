Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65F846073D74
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=beFY28m/
Received: by kanga.kvack.org (Postfix)
	id 7F5726B05CB; Wed, 18 Nov 2026 14:36:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6956B05CC; Wed, 18 Nov 2026 14:36:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F8406B05CD; Wed, 18 Nov 2026 14:36:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 334F76B05CB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:36:43 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81C72A8594
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:42 +0000 (UTC)
X-FDA: 85449247044.27.759AB39
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id F02014000D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="beFY28m/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795030600;
	b=YQ6z7JZEth4XXFoYCYpJy81/M2bHmKDr9pibxj8xXaRYDA4DlT3m8MCyKL6xp11XOR56Em
	HLmFtw+yS6Z54SLkpsWJTQNnQSSXn0t452b3Pozx5yCPkzwEhs72/M2nxn3hS334KeEcI0
	V3DB45UCQmXJ859AxaqGHv4lav7a0qs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795030600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	b=dO5uxxMS02b1Sx4sSuihLeBuTXiQ76eINLPHdzxEQPV5y4KzCOTgYMAX7YariHspAQ7npT
	Pr+TyTUPTwm3JsVmYqHDmFauAfFh+le9oKPiEcaTCQpSS/eBeguHeJh57vJxeFnsAAEKk1
	+6H5HoB5R6ASX0JdyOdB77ZjTQ4M0KM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="beFY28m/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 921BD63982;
	Wed, 18 Nov 2026 19:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8D61A1F000C5;
	Wed, 18 Nov 2026 19:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030600;
	bh=nefIhKw4pk3hNRgKls2omID/HmfGP96iHh55NTs5Fc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=beFY28m/CXPpvXt2QSm6CHgFEu5/DafZo3FIxSdgSW/oD4ncbx2FrbDn9xPIU+lXw
	 5pWxATEIw9SZui6/I+Mp22O4ABSVFdfJPmLyUz7kOjgoFqzYeKTVFSJjNyZit2amrI
	 DBKcxZ3l3rwjcpuY1aD9WfIt7cFmH4sr0qvxFvc751CwKNwWtrb5dFR1f/rLthDbS/
	 3JUE7fDlV6jdl4uuzBw13y6rgHyz9rd2RSxmYJfxScEHTmp9i0b4Wf+C1GGAjtVzLD
	 feQObnq7LeC95R+LGfKdrKvhEUrYHw1Vffz2GCVy3QyHXPRl1RknkOPolgLOvTpR+h
	 76Y+Gx1fhGEPQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 13/13] MAINTAINERS: Add entry for ROOT NAMESPACE
Date: Wed, 18 Nov 2026 21:35:39 +0200
Message-ID: <20261118193539.240065-14-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d5dgztwscu7sqte841ncw4p75rbojzfb
X-Rspam-User:
X-Rspamd-Queue-Id: F02014000D
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795030600-520151
X-HE-Meta: U2FsdGVkX18/KSA6a7a4W6bQav9YFcQpfDF2X8tjANI5MTydHPee9p5cV0fguaoXsjjozcaKwygQYh2enxzwOfh9+6Y1t3yz182N6ySrR57D5JNcx5HgLK+QBRwCoPvRPCsE0981JNXgyDnJQlOjltEZJWyKWsHQCOfLMiLFA2BiBZAjlPAm1XcK5OUKeYx5GwrcA4qD5dzhgo0Kc1e5GzoCpO4wNZzAv61cNKA3DQS1IF7Xk7u5en7xbYG0IUlm1EHxeEyFB8w5GbM+I3cP+fJlZ7jvW4DwWWn9J9rmqCrJjMOLirjWNnxNmd5UiiArK0cYuoMqpfuFsKbUSA1yLW/mM1/pqGTLraUUUgGIHTzmFds46nP+KKndPi9XdM0lxWx0OG1sJJNmKhupvFxlEZrS2GC+Cs1bG1vEfOIK+J7PJdeBLxMqqpPmPwxP+D8hZhXYdsm7xHyXyOtFvnBie2Zu/kqS6eR49rsb+pWyIhAToEC+LFl5i7ILnyjFbN6XcF7yjksZfb3IuGciF1BwkN2PNtcahY3lftrtxutRf6b/umZDgKwOjsZxOYvVMD+K4n2QAnRt6vL1g9SLm6ljCLZf1+pe42yf43I8YTBlszlte+GJTc1x1t4Dj85rmyyYtANwJKyrAf1TvAesY58q4hLMmdbb7J1HS/ZSmTnwukTFtQB+2BGzFvZLLu/93z9hgfu9lykkxcgu98q8JxmJWoNeWxSvlhQQOI2l9Edo0LJCCuGUw0b1H9FFO+tcZ5G8Y+gPDqx94xYcYb4xkLrQw7PH+cwsD8fSvLn+/j0hXRyuVvmUAzgirinCjQ27CHekR67Woz/O1kqQzjJ9PcdF227UW6chOwNQIU78rsUx+33lJRbO1+AeiOlWeHHsRLFQDhwaz5/9HTOZPZjh7VojYkPXXgNwNPquBbrdTnMMmopoYLqnD9m5+7EPNjS60zeoQyBo7aQNaE253berbaN
 ex6xIA3z
 WRQ5VNzvZmmBi3V+EoklxHqe0PpLnJjpNz+gLQPDzmfPK8x3pr6+Q5WnMMmCp39H2WkmxtAQmxXzsFSOjeinaJ3vXodcdJ2IbU1pMMOE0Acq7SCmmuTwYFgkC8DXmeQKcIH1tRg1MuyA8zvoa7hmC4tkzNFSUJw8EU6oPfD2DP7VeeuiAfYwP2VOae4Snbk3KWTWkJe9A79xIOfhn051rDSSlIpVwfCjzipDofRYJ5Htcy2igLbMeq2+ctueYXJ7l3FaQtuwYvcDiMZGmsWaYAZtBbIQwOggvx6yW9ROQ4Flw+g+StU2lHrr7GxONh+o7We1WT2rz0xGgU35f+STSXdE4z8ZlgZGXxNNQP9C7cNXSU/U63zNWI/ZoOv3qsflWmVOwUshrPTe3MZM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Record maintainership and mailing list routing for the root namespace
subsystem across its uAPI headers, core implementation, documentation,
and selftests.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7cbce21ba45a..072be5ec7fd8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24533,6 +24533,17 @@ F:	include/linux/mfd/rohm-bd96802.h
 F:	include/linux/mfd/rohm-generic.h
 F:	include/linux/mfd/rohm-shared.h
 
+ROOT NAMESPACE
+M:	David Howells <dhowells@redhat.com>
+M:	Jarkko Sakkinen <jarkko@kernel.org>
+L:	linux-fsdevel@vger.kernel.org
+S:	Maintained
+F:	Documentation/userspace-api/rootns.rst
+F:	include/linux/rootns.h
+F:	include/uapi/linux/rootns.h
+F:	kernel/rootns.c
+F:	tools/testing/selftests/rootns/
+
 ROTATION DRIVER FOR ALLWINNER A83T
 M:	Jernej Skrabec <jernej.skrabec@gmail.com>
 L:	linux-media@vger.kernel.org
-- 
2.47.3


