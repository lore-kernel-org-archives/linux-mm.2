Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C275CFF60C1
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 04:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 206676B0096; Tue, 31 Mar 2026 00:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5B16B0098; Tue, 31 Mar 2026 00:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E476B0099; Tue, 31 Mar 2026 00:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E3A6F6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:02:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7746B13BFED
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:02:22 +0000 (UTC)
X-FDA: 84605010924.24.9624165
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1205614000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:02:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H2F5ET6I;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774929740; a=rsa-sha256;
	cv=none;
	b=Du3tbUXFoU+ocxiJtS9F7tgaYACGyc0EIBTJiKcQTKfoMlSIaCfFAlhR0VRbD1y7OZZO2z
	okbskXcKOBuVPyCoUx9DiDZr8+Ro5CvOC0+R5C7QL+sT8ztl/KIvacvjKK39m84HfV2YaN
	zYu3sGfAq6BlZg9W1mBJyuQZVYggO+U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H2F5ET6I;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774929740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VvrYLvc4bheXY6nHh3gvx/fU9nd8/iSIX4Lotedv4lg=;
	b=Z3EGIP+r6pgvaoxAalak1ZwQvaxNanYdwsT0efAB6dSVI+tne58Wzu44JO0jpUMkve/CTJ
	LkIMmJIU8JnKYq+++IJ8zNk/EIT0/nQPby9GE+/XMzhrvt0+eNnnmvqBp5K4wfY+gdA8II
	96hsYIxTJHEqfOXQn2dTIHWZNkJ053w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774929739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VvrYLvc4bheXY6nHh3gvx/fU9nd8/iSIX4Lotedv4lg=;
	b=H2F5ET6Iku75SxHLpGyS85HimXG45I50zc5PcH/Wiu8yr5QkvEqoy1Vhsjw13Pdt4TXuoM
	sn8PdTzLQSeXqzQLGX1tsQt+bEGtpq46HNnX60qj8xEzwdow6PGfraoPaMueNhIwaZX7NL
	ebyZGuqveKtHuxMOkFaxqx5tmWrOlA4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-613-2sKpac99N2CcFOHSra_RFA-1; Tue,
 31 Mar 2026 00:02:14 -0400
X-MC-Unique: 2sKpac99N2CcFOHSra_RFA-1
X-Mimecast-MFC-AGG-ID: 2sKpac99N2CcFOHSra_RFA_1774929732
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4405180034E;
	Tue, 31 Mar 2026 04:02:12 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.121])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 892DF30001A1;
	Tue, 31 Mar 2026 04:02:07 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] selftests/mm: serialize local_config generation for parallel builds
Date: Tue, 31 Mar 2026 12:01:54 +0800
Message-ID: <20260331040156.119158-2-liwang@redhat.com>
In-Reply-To: <20260331040156.119158-1-liwang@redhat.com>
References: <20260331040156.119158-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: nMlu7uWigHgdOifAtYGjH24OtUdV6qSOXx0-W5ShUxM_1774929732
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 1205614000E
X-Stat-Signature: fqemg4conk61xwii7pmxa8cyqz1npoio
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774929739-605059
X-HE-Meta: U2FsdGVkX1/uqPg0cQ7eJSagRwn6pFjkabh2MUIQuC2LeP0eAc+Zwei2noE+FIrymV0xjChZNJ8heuonFWt08K/foClMG/R10yIbXZd0C4Yb8p+UymNm5390aGIFewnEmZBypA9Dke+5FyT6Crqjs3/c0Gwyb7FMyjWe4mLySfhJdmTxp3So4uOhRDhvAu2ogHmIfoq+X2uo5RUO5EVl7s9Ixp5XMuq7fbUa/7lJ5mPt8u0NwcGpI2njmrzrh40NhreLXnj4TPGKbo0zHzK80NQJRwZK/Pibt+o9RV7kPdK9sW3u1NAmplXCAuHwfkmADCuMr9xRtJpxFgKhY7mkejMoH+PFOuFO9BdvxMNnFdhTwTVBDA7FTzGAHbKQpTToinEiwteneVXQibsjo9Ps2z0UvgTJ655X/I9H7dRCXFfihfFcWaUbya54qX3oae3ti436dJosNT/lTF03kRaKey9UCGGXPgPRtVGxDRCVRd8hu441a+n9IMr+MQDIIkhayoI+JGwG0S1L1ovwc3ZZi1z22IZ39kxlhm7MRzsC/UhO/1ZlqmF+11tmHCYGWnjeYYKtLwwRSm6hyJ8twdLTC2dSYQAzpYYPQIpKBqb1f7dCP/DOzblGBcFMvA7EQJu13M1eXUln589lluhdGuzzjI84w/araldXhxKw9m+hh32is0+QW5zC129MUYNiSWSqN15AhO1Gw1MmDqzllqHxjVdFF1z+WOZ1Fg0M/RTNvJeoixlzDY3e/NV/AYR3QoKR90lPjtgiii6jjSWDKpCuT7cdj/u+IPVX8yMgOJOhCMga4MtB8KEcSZzf+xWUIPQHYB5y7xNDAxGVMflSYoOVpENYwoDPjrLAiGriT+yyLMikYwLDQTkoagrOZCgI1aAFvd9CntdDauVmBiUFlHH0j+zo0g50wmh+lZNhavQ599S66p1BpUhilsbNeqXlSA6WQaoz3ZOXInjbKbaZKeW
 sLO5rbp5
 cmv4/KtkBWe5BZYBPv8C0IUhivN2MSZnABNJV9F4t8FR9EpPjxh6kGshOpiSY2TUNUgAqqjYs6IOVk92wLA89Hm1OexlbW5yPd9g1SQrFhO/Oj6pVxm8llYIYiXZq+7nmpOB21mU4QTGOUNJUtP7Wk+OWmeGbjrtwjobqHRSwJEVpE4u148+okVmSmgPXWa6XFCTLir7EOKiXZBuf8B4+YI90tLQZTvvuzaWghTo3utDXXX24cCtRi+VhrqGsBp7Kf1Lxmi1MY+djOUjqNa02jH82GGaLN68qKqTtJfl149LvlYYYEm30OKBRHXf+VNvK5X8eZjsspmFoYjDmH5nuZJxEZEi7UcBX8Nes6G7hDPnG9e9dX9aLqK2RobAefx4enr5uPOLHmi+2/mc2MkX0FsUIXDTuAU+R35LRfrbl2di/7LoUFl+64HsUidHxUJqav4K+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mm selftests generate both local_config.mk and local_config.h from
check_config.sh. With high parallelism (-jN), this can race and lead to
incomplete target builds (e.g. only a few binaries get built after
'make -j100', while 'make -j1' builds everything).

Switch to a stamp-based dependency:

  local_config.stamp: check_config.sh
        ... run check_config.sh ...
        touch local_config.stamp

and make local_config.mk/local_config.h depend on the stamp.

This ensures check_config.sh is executed once per update decision and
removes the parallel race window. Also hook local_config.stamp into
EXTRA_CLEAN.

No functional change intended for non-parallel builds.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Li Wang <liwang@redhat.com>
---
 tools/testing/selftests/mm/Makefile | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 3b222cd6a048..78496f705386 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -261,10 +261,14 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
-local_config.mk local_config.h: check_config.sh
-	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
+local_config.stamp: check_config.sh
+	$(call msg,CHK,config,$@)
+	$(Q)CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
+	$(Q)touch $@
 
-EXTRA_CLEAN += local_config.mk local_config.h
+local_config.mk local_config.h: local_config.stamp
+
+EXTRA_CLEAN += local_config.mk local_config.h local_config.stamp
 
 ifeq ($(IOURING_EXTRA_LIBS),)
 all: warn_missing_liburing
-- 
2.53.0


