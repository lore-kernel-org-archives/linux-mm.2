Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 984FB606A7A9
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF18E6B05B4; Mon,  2 Nov 2026 07:25:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1E86B05B6; Mon,  2 Nov 2026 07:25:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9915B6B05B9; Mon,  2 Nov 2026 07:25:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A60D6B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:25:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ED68EA0C7F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:25:52 +0000 (UTC)
X-FDA: 85390100544.08.CBEE231
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf14.hostedemail.com (Postfix) with ESMTP id E908910000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:25:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793622350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QWxekjA+fe1OvVXW0+7PF8qydE4AHzzyYdNfB4ajrnE=;
	b=JbFpQjc889Xo9TgkyTPGGGe5JLdVu0h7YzwC9oY6LlP5Qzp0kQDCLZyfxk0eL/rfDhM3F7
	/niKlDZ86IaobqYPdMxro+693bDBCcf5VZ5Ob7/shOPVCFMr6w0PMhI7ovSIWZkLew6X+q
	NvNEs+i3OdtxAEbp2KWE2wFTRvQZ9ng=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793622350;
	b=i2ZLffq9vB7ufdZivo/UXInM+Va0pCWyJsttez0Xj3AQgnIOUjK3JRmCGNgGVaGW3p61NH
	0HVpKiP000JMVD1biOAglSnI/Qz8NuOdPedA50XNI9nL8TwWhti1Bw9S1ZI41cYt9Upd5z
	RpFbGPK6zsa+RelHRM2V1iWIqfXNYys=
X-UUID: 84ea5216d6b811f19a56ed5b684f684d-20261102
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED
	SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:f7350ef6-cc28-49c7-ad94-79cc583fd268,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:f7350ef6-cc28-49c7-ad94-79cc583fd268,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:3a80eb27c71bdbd8150ef340657003e0,BulkI
	D:261102202544AR6ZPRG3,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|153|
	865|898,TC:nil,Content:0|15|50|99,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:
	nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,B
	RE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 84ea5216d6b811f19a56ed5b684f684d-20261102
X-User: husong@kylinos.cn
Received: from ctao-book [(114.244.3.119)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 155186156; Mon, 02 Nov 2026 20:25:41 +0800
From: Song Hu <husong@kylinos.cn>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: tj@kernel.org,
	tjmercier@google.com,
	ddrokosov@salutedevices.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH 2/4] samples/cgroup: exit cleanly when the monitored memcg is removed
Date: Mon,  2 Nov 2026 20:25:26 +0800
Message-ID: <20261102122528.1498193-3-husong@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102122528.1498193-1-husong@kylinos.cn>
References: <20261102122528.1498193-1-husong@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E908910000C
X-Stat-Signature: ibjtdisymoycqrms7ckq3tfzwifit4k9
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793622349-227710
X-HE-Meta: U2FsdGVkX19h1BlkpQ9ggdMzaIKCLpOxVzuS1HcedkmOFTkxK4FATYOYG+jNZZocvnhMSQtVpvbyi/LfspYCfkfP+3+zsA7x25m1rOLDwgtj9NngaENavR3B+9WfhedS3zoODnkitDqNmrTJWzM46ueqUeo83sf0EPI4PSvukBLlaqNb5RRtfRivK4h0YIq7yYmaP9+iVQBv0m5oR60zCBgYhUQ6iUNJOoezlbV0SuRXsm0uwiVPCUPDgtnDkgdH/KoDm5eVvbNhLjsGn1oud/jdJS2gMOpXt+sU+bEXFKkG1KaW4Ek/wrYfjx6raHEDGK6uKvSaMwDzIYJ49brmbV2JerNxPM0XpAFW/UB3J6LdyxTJrlHEyoH2kn4mIv6onT3LF5IUC9T+NF6c/jweQWY8SeaqUvbynF+is3zw/YKUPqtImra+7jvfin4qGUEwug/IFL5/4DMqBSSkA553rbCk/bmMMljYC4KcgNtQMOqWuMjCMArXeVVRvbnQ5lY/QfyifzNfd9zt9psZbd0s65WWMk4ccXj+Z/EGwwUhiPVyz2FDJBWdpobc539LsSp3jUKtU7HBdBxfVg3HV0fAvu7587cKGOH4rVjNd7Eqyt/sZ05e1o1PVnVIent695rtSj3IxmNQkDPbWICU5zwukpjS2zIPwYmECAfLEqN7GkiPaQnSi8sxNrKptD9NAU55kpqQzGZ6xCcHL2qAvGp2vWkFbBGwA2/LFOP7Mu+6qP+FXTMpVur3nd7dbRXx17mnB7Yf7aZMFs2aUD5KAff+/Beam+NVRix4F9Chws5PxwrrwQrHWlbfvsN02H7C5gc36Vk7VsHri6JTwRay3amxgjNLHriU4fJtdOw/GT4adriQyuOdBanjW0mFqwne75M/xFWQMQqsj4CYaPZtI3r9fCFHEUMG5FvsnnTZd1MgV5ouAX7IOh3GqpYILBJJ7fQYV3TNqhpdyQuPitDF0Ky
 4L5MQxHP
 xizaM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The handler processes IN_MODIFY only.  Since commit eea5d2bb34ba
("kernfs: Send IN_DELETE_SELF and IN_IGNORED") kernfs delivers both
events when the cgroup is removed, but the sample warns "No IN_MODIFY
event, skip it" and returns to poll() forever: after an rmdir the
listener never notices and keeps polling, while a supervisor still
counts it as alive, and the cleanup_memcg_events() call in main() is
unreachable.  The
accompanying selftest, commit 2de27980e1d4 ("selftests: memcg: Add
tests for IN_DELETE_SELF and IN_IGNORED"), exercises exactly this
two-event sequence.

Handle the removal pair by printing a clear message and exiting, and
subscribe IN_DELETE_SELF explicitly.  monitor_events() returns through
the normal path, which also makes the cleanup call reachable again.

Signed-off-by: Song Hu <husong@kylinos.cn>
---
 samples/cgroup/memcg_event_listener.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/samples/cgroup/memcg_event_listener.c b/samples/cgroup/memcg_event_listener.c
index ec7c03fa7887..996bf6fb117c 100644
--- a/samples/cgroup/memcg_event_listener.c
+++ b/samples/cgroup/memcg_event_listener.c
@@ -199,7 +199,7 @@ static int read_memcg_events(struct memcg_events *events, bool show_diff)
 	return ret;
 }
 
-static void process_memcg_events(struct memcg_events *events,
+static bool process_memcg_events(struct memcg_events *events,
 				 struct inotify_event *event)
 {
 	int ret;
@@ -207,19 +207,27 @@ static void process_memcg_events(struct memcg_events *events,
 	if (events->inotify_wd != event->wd) {
 		warnx("Unknown inotify event %d, should be %d", event->wd,
 		      events->inotify_wd);
-		return;
+		return true;
+	}
+
+	if (event->mask & (IN_DELETE_SELF | IN_IGNORED)) {
+		printf("The monitored file %s was removed, exiting\n",
+		       events->path);
+		return false;
 	}
 
 	printf("Received event in %s:\n", events->path);
 
 	if (!(event->mask & IN_MODIFY)) {
 		warnx("No IN_MODIFY event, skip it");
-		return;
+		return true;
 	}
 
 	ret = read_memcg_events(events, /* show_diff = */true);
 	if (ret)
 		warnx("Can't read memcg events");
+
+	return true;
 }
 
 static void monitor_events(struct memcg_events *events)
@@ -247,6 +255,7 @@ static void monitor_events(struct memcg_events *events)
 			struct inotify_event *event;
 			char buffer[INOTIFY_BUFFER_SIZE];
 			ssize_t length;
+			bool keep_going = true;
 
 			length = read(fds[0].fd, buffer, INOTIFY_BUFFER_SIZE);
 			if (length <= 0)
@@ -254,9 +263,15 @@ static void monitor_events(struct memcg_events *events)
 
 			event = (struct inotify_event *)buffer;
 			while (INOTIFY_EVENT_OK(event, length)) {
-				process_memcg_events(events, event);
+				keep_going = process_memcg_events(events,
+								  event);
+				if (!keep_going)
+					break;
 				event = INOTIFY_EVENT_NEXT(event, length);
 			}
+
+			if (!keep_going)
+				return;
 		}
 	}
 }
@@ -291,7 +306,8 @@ static int initialize_memcg_events(struct memcg_events *events,
 	}
 
 	events->inotify_wd = inotify_add_watch(events->inotify_fd,
-					       events->path, IN_MODIFY);
+					       events->path,
+					       IN_MODIFY | IN_DELETE_SELF);
 	if (events->inotify_wd < 0) {
 		warn("Couldn't add monitor in dir %s", events->path);
 		return -EIO;
-- 
2.53.0


