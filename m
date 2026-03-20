Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF7DE1099B40
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432106B0122; Fri, 20 Mar 2026 16:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BAB06B0124; Fri, 20 Mar 2026 16:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2353D6B0125; Fri, 20 Mar 2026 16:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AC1E6B0122
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:43:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB5D51B75B6
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:29 +0000 (UTC)
X-FDA: 84567616938.04.6C439A6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id F3AF24000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EhbBR7LB;
	spf=pass (imf07.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774039408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNnnx0J3yeBnBNT/ZZLy4XythaRAMwcdcOOMkKfy0Ug=;
	b=X2yzKNH/5yN3ngJifC5OBhmD86RIJ2mmNgAxRLYzULJhM5D/HKar0P8S3pOtT84poTFpwt
	DNaRQ5f61cTJLG51qNlprYv5WV5bhrJ2B3TeXg71YblOOFwJObnLDIdRMKxkweKfwWy/4Y
	yMP4jiuSYqX1+9gi1yH7naU4Q6cx/vk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774039408; a=rsa-sha256;
	cv=none;
	b=AmW97XdhAmFQqGR4XQ3Ax8/fgMVoF0H3Pg2xzDpDmjiDdWPlq+L0maTNIpFkhAGZhN+gZi
	pOw+GYArDEBslvsHkZ5p7u4VJuUggqiDtpaLJ5dVwuj2r6u/AKvMWywPr51TuyWAmAQ5Wq
	0bYtDVDnhy+BqVFITPZWhZ7GfwvNkHE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EhbBR7LB;
	spf=pass (imf07.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774039407;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NNnnx0J3yeBnBNT/ZZLy4XythaRAMwcdcOOMkKfy0Ug=;
	b=EhbBR7LBTlkVtQD/rPHONQrLmgGh/9jeQVQIaJYz5KxUCBXPMzexf4qyHwfKpqnJmfgbQe
	s5GGH3KBmjyw9u5RH8k0fQ6N5otpVRvMDUHnJJXpzVpeuLUFiYh/VGyOXDfTHca4/kxF/E
	7FXPKpJAKRx487oQ3lnVcT44Hj4gQHo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-QZVTQ2s2M0Stp-4wudu18w-1; Fri,
 20 Mar 2026 16:43:24 -0400
X-MC-Unique: QZVTQ2s2M0Stp-4wudu18w-1
X-Mimecast-MFC-AGG-ID: QZVTQ2s2M0Stp-4wudu18w_1774039401
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 979F41800345;
	Fri, 20 Mar 2026 20:43:21 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.65.139])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A2A5A180075C;
	Fri, 20 Mar 2026 20:43:18 +0000 (UTC)
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
Subject: [PATCH v2 7/7] selftests: memcg: Treat failure for zeroing sock in test_memcg_sock as XFAIL
Date: Fri, 20 Mar 2026 16:42:41 -0400
Message-ID: <20260320204241.1613861-8-longman@redhat.com>
In-Reply-To: <20260320204241.1613861-1-longman@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: fldaIs_EDOUldW964zvBnMKA7o9RDzs6xV9Rqn4Saeg_1774039401
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: w4r7j3n96wqydz795bt9bsbx5tppk1pe
X-Rspamd-Queue-Id: F3AF24000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1774039407-267675
X-HE-Meta: U2FsdGVkX19rNa536GgS7ydKynCiDVdgGjH2Vp1931wR5DVqrDRUaWKbmmbqTsJphdTeYFcoeNyGTzOZmmZXcTSuXBDvgbQkipBRrxwia6qEwRdm90PqFOCN1m7gmDEX2Ui4InMFjVE4e+NudK6pnkqxDz+mSEGxoS5QbAneGr1pZh9sBaEB7NtL9pbk/IRGpggFiS3jZJAPks7n12kyxTjXpYWpZ93HTHuzqax7fZZt7VxuvpSaoG7gB+Hlm2Qa9z176nFWNTHFKonY5a/z7ZzAsosUSGGkdt8pnUfAcMJP1y1KiF/NFmCy6eOX9X2ERTVeC3kd9uwUc/oAWqTEqpS6bDwNlHbmYy39j+svj/b0XORrlEm1NJpmuI+PLltq715zfzi0MhgoeTjVBeDPnjLP7IYXH2ur9Nzuqy9rY5Ea8IJGMgIYl4HCePcFMe05SlDMgLJqcnKDNntuzG4hm16s7/Zu9peDw0dRY67TeYsAP1Cl1mcy2P/JHRYsdLSaJVmN7SIROmGwFydPTsPp2HY/IyBujeOXB0rMdqDC3wq5otZ0mfq8B6cBk85b6U1C6okT2P4rIrk8O2AJBO8JfKT6D4j+mlb/f7fKaVHbo72/B7FgTdEDqBzwmSy3CZImkKomNUnvR05sMH7lKIQYgSJ7vtylm/SjPsysrVcvHiHtnMLlnEKZ0kiUGVY+3Lp4WVM4DUUxpewFui3i3XiVLafsgZKnzITXt0tHLY58kz5lnMXye3cP8zhGWsQLfBSVprQKgOpqnanQGcbDj6s5OW6JPbm0d5x4b2nY+0loFsvIFBvwN70/OgBPLnjQ3AvhN7e0qabEl8/kxZ5X9wfay2i+7byhUENh82OdDTVWw2/W2I4FLssYX+wuoTFV/pdEMlWtCWB1i3W8voJwTT75EG2/ss2rNMXF57CgVWYc2WeksmJpnUSBzdyHCL9yX4M+36p5WBx2VAWf8mItV+k
 IeWSi//H
 zv+l00znxYvxgu36h6WuByNQLjzRB0bNhbKllKP3+XL9gETDUO/W6s+daZgXn/AlnJcg8//tO0dG7gKl+G9dy3lbhzYLTdzDf5gFKOCDMNDLN0nBsBZ+o+BUJ7uqZKN64o3xrBkadZ/lI8lcg9z97vFIl20oH0IabA5q9ncdCt55gtdYq4Ub1OyTRHP2XIgvB49m17yfE8i4Lvacr4QBt1mMnpreBszrExpogs8X8oYIGYMg/eDOkuUiaXeGh59XcAo2wPAbhCO9hXM8Tbyk2cgkWE4OrJY3GAgkjsaAEQ6rqChT3cDgxvn96DK4G9xLbTCjeFzSeYwK64DEyWA4ys0T6tAfO6/6eqJtL0pzmhst1OAm16a1KgFPftEXAmJYdmX/uI/AzLPBOSR4=
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
 tools/testing/selftests/cgroup/test_memcontrol.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 5336be5ed2f5..af3e8fe4e50e 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1486,12 +1486,21 @@ static int test_memcg_sock(const char *root)
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
+		if (sock_post > 0)
+			ret = KSFT_XFAIL;
 		goto cleanup;
+	}
 
 	ret = KSFT_PASS;
 
@@ -1756,6 +1765,9 @@ int main(int argc, char **argv)
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


