Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC1341091900
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250AE6B0572; Thu, 19 Mar 2026 13:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2291F6B0574; Thu, 19 Mar 2026 13:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166836B0575; Thu, 19 Mar 2026 13:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 044E16B0572
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:39:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BB0AFC22FA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:23 +0000 (UTC)
X-FDA: 84563524206.10.E0E5D2B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id D8310180003
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NNIHQMpw;
	spf=pass (imf24.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8AJoJFhemnk1DLT2xYvQamPJ/h63aubGqhq+ZDBiKQ=;
	b=HAZcRQ0d864c/NwOnsrM/C3YYidhnUlw9FW9+ePyrM6BtjP0gMmlSYWkzCS4E4Axo5JCh2
	KaAbrv64W34hl4Fy6BjMW7G2Xrf+er1sbpWCILq6MGQo+StL3ahA+KiLd7Ezq6CcGJ1wBF
	7XSsiWAM7AsMeBk0NB/TwKqLizw0kJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773941961; a=rsa-sha256;
	cv=none;
	b=8qYnV+HerAT2qq4NUH/6BJvqbZfjukFCQfv3t6XctJWtIWa15co82ZX9qMlAtQSpGcrVnG
	1ExYmDo8T0GpFYWAnlVbsv6SHetZ/Hcf9d7kKxcsJG5POxfF4p9K3A5RBuanWVDFoISLOR
	mbrSYSFq2Mf2/ZOBA6kK1b34X7oOsbY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NNIHQMpw;
	spf=pass (imf24.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773941961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y8AJoJFhemnk1DLT2xYvQamPJ/h63aubGqhq+ZDBiKQ=;
	b=NNIHQMpwi0+X4mm1Q9oh8DV+ZUaJCtd5hbyPaFbK9dT0b34j0GbWrt6PWAQMVgX+wemJnp
	huOAQH6k2ZtNSMmyUrAjUN3HBqy8klh/BBifdkBZoX2O4bAI1ouFx98TfDug4Xjke2QQg8
	GzkGv3aABF4gj1hNoBE4ZY8Jzlma8n4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-45-N4MyzdgGOh-xRtock0apmA-1; Thu,
 19 Mar 2026 13:39:15 -0400
X-MC-Unique: N4MyzdgGOh-xRtock0apmA-1
X-Mimecast-MFC-AGG-ID: N4MyzdgGOh-xRtock0apmA_1773941953
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D731818005BB;
	Thu, 19 Mar 2026 17:39:12 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.80.194])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7CE330001A1;
	Thu, 19 Mar 2026 17:39:09 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Li Wang <liwan@redhat.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 7/7] selftests: memcg: Treat failure for zeroing sock in test_memcg_sock as XFAIL
Date: Thu, 19 Mar 2026 13:37:52 -0400
Message-ID: <20260319173752.1472864-8-longman@redhat.com>
In-Reply-To: <20260319173752.1472864-1-longman@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: -p-mgDVw8unbmoBe9Tki18QnPr9pHOAfbKKj7iupSZg_1773941953
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D8310180003
X-Stat-Signature: 76jhorup36fnzbeos6hb6oy3c4poufo3
X-HE-Tag: 1773941961-20959
X-HE-Meta: U2FsdGVkX18ODa7zmJHkezZULrvUk871pfnP+6brpq/pKIlaq9h1iHURX0p/uQ2VfxKpiqFWlMapAoJjQ487D+qFVf+nlMLxNUrKozbhVtSAS6mfGldDv2XFKo8oMvRqmKj59JV2gj8ulrajaC9lGXpxWZgIOay2pvCwdildO+jyiCw2D7iPiBJXwDYB4As4ABDR/D2Ub7ZCBWdU3iF92d8BpCP7AGRD7iDXDOo1m8jvQ2l9H3Ik5l50ZQHDZnIjIAMATi7QG5FCr5puuPRX+mxFAT/Q9bx1V8m/g2AEuOJHuCsCBhO9iVafRGCALaecbuTHScs6Jxz3TL9clhMbYF7RmRM2LDKTH8VqyBrhLJ+BMLBEk6YsQcmr2xla5kSFn8wwt3EsE7G659aS+v5+/ltY1BOaJM/SGX6bW41JTlQKSwNNQBTAhjkhf2tEyFYjGfwTCwYMen6aA8KJ6Soz/xLzGFZkHGhKqLGd1xLZIx2R6SynqkQ21aEBAMvwCIeJJomycOgtM6PcJ02F5bZVJbshvKqHGxlcvkZTLkb8lZ3zNodBdLLMHmaSdvCKm5+TXBIUuT/ijC7S+iJbd7qZS9Dt2HD6vXSpgS3P3zGeZRbKXqmHF4HC8euSiQpkYUt+MTxPchK9IQwBHM5BGa9BtT0KOnjamizD5j8dh550WbIA/QIVe5+Ok7w4R5eTnod4nqkF0a9iWCcUufph35RhrhqsAyOHyKeO6a1cQJpCxaxys+AIu1SFTtiF53FKlAk0svDneexWlpij4IfA5WKghQ1WoUPoTEdHdD3lFJegYKYLs6dU+HDt2j+APycNxyiIkwhNPAoN61UrQBDYwha3yTZYwJTVLeeGhxUIhuo5SZS+Aq9i4rk5LXW7C1HyhSOZgOiB/GvDwMEAKdtfcO5qGgSUVGc2jRu9wxIZlTwJMJuE5Xcef3f4rmF+whTLSKMD+vhThEt34SK25HoQYlZ
 FzBMsjWG
 VZdwlZcWxDRNSb0+hP4JsnHb733d7TqthZhchOanZL+aQ4troeVMA/6j7q67mEE5/6bCzqoP23Lc4Mv2rxtZGJo+F3zhEg5jm2eF/n0WppD+ov2/DjZ5FoDGyLq4za2AV0DCGSE/AFBs8BGnBSS5dO5QOvnXmlQME04ejw18obcToKzFxqDp2xYNZA73Y60ZyWClxroe21RuZnKN15ryI3OPPZ6DXJQ4Y7e1yiCJDVrH3z9wn4dKW6sljDPsppZCKdVlCs9WDRufNrYx0NhWBtOb45LuH+zDQzlep2tU2kbZxhCN2sVcUWNkuvv5u0y0G8r/hLR9g98kbNi07IiCjJNXSNnLUIRvpRJTeJ3TPT/G1KQDbAJ3tRNm9ItWExvfkFD87Wz1JmdBZAAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Although there is supposed to be a periodic and asynchronous flush of
stats every 2 seconds, the actual time lag between succesive runs can
actually vary quite a bit. In fact, I have seen time lag of up to 10s
of seconds in some cases.

At the end of test_memcg_sock, it waits up to 3 seconds for the
"sock" attribute of memory.stat to go back down to 0. Obviously it
may occasionally fail especially when the kernel has large page size
(e.g. 64k). Treat this failure as an expected failure (XFAIL) to
distinguish it from the other failure cases.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/cgroup/test_memcontrol.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ef09bafa68c..9206da51ac83 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1486,12 +1486,20 @@ static int test_memcg_sock(const char *root)
 	 * Poll memory.stat for up to 3 seconds (~FLUSH_TIME plus some
 	 * scheduling slack) and require that the "sock " counter
 	 * eventually drops to zero.
+	 *
+	 * The actual run-to-run elapse time between consecutive run
+	 * of asynchronous memcg rstat flush may varies quite a bit.
+	 * So the 3 seconds wait time may not be enough for the "sock"
+	 * counter to go down to 0. Treat it as a XFAIL instead of
+	 * a FAIL.
 	 */
 	sock_post = cg_read_key_long_poll(memcg, "memory.stat", "sock ", 0,
 					 MEMCG_SOCKSTAT_WAIT_RETRIES,
 					 DEFAULT_WAIT_INTERVAL_US);
-	if (sock_post)
+	if (sock_post) {
+		ret = KSFT_XFAIL;
 		goto cleanup;
+	}
 
 	ret = KSFT_PASS;
 
@@ -1753,6 +1761,9 @@ int main(int argc, char **argv)
 		case KSFT_SKIP:
 			ksft_test_result_skip("%s\n", tests[i].name);
 			break;
+		case KSFT_XFAIL:
+			ksft_test_result_xfail("%s\n", tests[i].name);
+			break;
 		default:
 			ksft_test_result_fail("%s\n", tests[i].name);
 			break;
-- 
2.53.0


