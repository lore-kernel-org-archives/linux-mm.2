Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E11A6CCF9F1
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E5F48E00E7; Wed, 29 Oct 2025 15:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BD778E00B2; Wed, 29 Oct 2025 15:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1856A8E00E7; Wed, 29 Oct 2025 15:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 043B68E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:56:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB4EB1408DF
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:56:41 +0000 (UTC)
X-FDA: 84052209402.12.BD02999
Received: from panther.cherry.relay.mailchannels.net (panther.cherry.relay.mailchannels.net [23.83.223.141])
	by imf30.hostedemail.com (Postfix) with ESMTP id 189CA80009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:56:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b="KB+JTHc/";
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=pass (imf30.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.223.141 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761767799; a=rsa-sha256;
	cv=pass;
	b=SCFMJA9lLf47TXh7dnJSHHtQZfWtpVTn11i0/z4ZPKtyX3EEL+OINsh5gH321DV6T4FHlQ
	gHNxhOSA5jicyJ5GjXCqU0HA/oRgvitWgPoD0WtpQ50izpZK/B/Enq1X/RAvVOxw+eaKcD
	xzpnnexWtAazisyC48ejwqEnyW/C6EQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=israelbatista.dev.br header.s=hostingermail-a header.b="KB+JTHc/";
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=pass (imf30.hostedemail.com: domain of linux@israelbatista.dev.br designates 23.83.223.141 as permitted sender) smtp.mailfrom=linux@israelbatista.dev.br
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761767799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+yJuOJUlXKdKViOtv+OYoLNyuk04aqpugJBZxV8M2kA=;
	b=5mc4pY5qjcgbiWCDUleMb6jIHcvAsilvhtaR05OESD+TYhmaCLU7JPF5jN4MVYwW3Xs3U4
	qQ7MybE2b3sEo51fedXVxiklaZEXeOrRBy+A5x7vnPMBR3J9bFbDwkaSjPSb2euPhSPkUb
	ceDC21Zw8H+12m7BK9hKXzS8gVQS+Lw=
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id E2070161D05;
	Wed, 29 Oct 2025 19:56:37 +0000 (UTC)
Received: from fr-int-smtpout17.hostinger.io (trex-green-8.trex.outbound.svc.cluster.local [100.123.122.56])
	(Authenticated sender: hostingeremail)
	by relay.mailchannels.net (Postfix) with ESMTPA id 7349216208D;
	Wed, 29 Oct 2025 19:56:36 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1761767797; a=rsa-sha256;
	cv=none;
	b=mMn/wZoqxjELg0tQWCW+4/5hSgNvher8OX7jmam6tDYgcr2BQ7dbFOwOwBaKfrXat5+CtY
	HLM1QOObsbo+i4/3bG9PpyQP1duXkbQDLkffA4EO7R4jpZxjLoZWMaCy45xKfEGeA2htDD
	TODsYUbmRHmk+F340xEdKek103jiqbSPynokg+j0S1pB0o2TjTu1AWyJJBq4L5jFE131rG
	N061Me5rrue4FPsqyClzGpVYU/FiY4SmeEJs6U04jb2tg5Ww8h2wc58UVh4Cz4CkQGyMiF
	Wl1/PfrAfZ0dtV+KGM9rlb3HTv+1aAQ7naBPRcOGw1QX3CYtXkBt71AncoxJlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1761767797;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+yJuOJUlXKdKViOtv+OYoLNyuk04aqpugJBZxV8M2kA=;
	b=xU47KWX2ljXbccvF/mfq+vClsuGlfEc5C4hFaMLLYGg44hN0w3NKPgyIA8xjmCMra1vDnA
	GmbXSWgWqYehAItdPz/yuFCpgPWW+zFxOWX4OyMh0eYPKHXvWiDbAWnft9zt64pK90C13a
	+Ah+84ut/yau+MeOlwDzpmlmooMv9JGxLvS71QmMqBT7tFhh/YS467NDe9btkU2iJSgmBN
	XMi5ee9E9ofRCXKmlczc+egb+tYkVcAQgFxtwcVHbTu2Pr8BLhMDuDkrsp7rrKBtz17X1V
	loYPXQoOhsFTcF8sYWsuVlSKbauywvHywa1+I5Z39djz5AAOdmPPL5t6BW/yrw==
ARC-Authentication-Results: i=1;
	rspamd-77bb85d8d5-8fc96;
	auth=pass smtp.auth=hostingeremail smtp.mailfrom=linux@israelbatista.dev.br
X-Sender-Id: hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MC-Relay: Neutral
X-MailChannels-SenderId:
 hostingeremail|x-authuser|contato@israelbatista.dev.br
X-MailChannels-Auth-Id: hostingeremail
X-Abortive-Fearful: 23ad77a02f87fdf6_1761767797823_3549134956
X-MC-Loop-Signature: 1761767797823:3821853701
X-MC-Ingress-Time: 1761767797823
Received: from fr-int-smtpout17.hostinger.io (fr-int-smtpout17.hostinger.io
 [148.222.54.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.123.122.56 (trex/7.1.3);
	Wed, 29 Oct 2025 19:56:37 +0000
Received: from fedora.tail0cc0bf.ts.net (unknown [IPv6:2804:d59:8970:3b00:5f26:e2da:68e6:2358])
	(Authenticated sender: contato@israelbatista.dev.br)
	by smtp.hostinger.com (smtp.hostinger.com) with ESMTPSA id 4cxdKp23w2z1yFc;
	Wed, 29 Oct 2025 19:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=israelbatista.dev.br;
	s=hostingermail-a; t=1761767791;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+yJuOJUlXKdKViOtv+OYoLNyuk04aqpugJBZxV8M2kA=;
	b=KB+JTHc/KSth5URNiy8KvCQo9aBJlQFxHxadqMqsisE9jRxRX0CsmDekw8ZYWHmdx7WPXH
	oI9Rdi42HZFWltuioPxr051Yvsjm9tbZdjUsBp3HLMnf/EhvPD9CbCl6AP1nK30SsRORLG
	eej+x71WkIvZRI7DimKVS8+uWHiedEfrJsBydpammzG5T+p6z3B2dHXQWgIql+vPv/0e2H
	daxO58XjfMTswfJCM1yBV0UHdDGfABVm7JwC1gwRVPuSPtGybIwsYSN6cm/27JZEjL5n6C
	/HefeJsCzLgnnNrOEalulydT+a3SEK44f/UulrJUHM25R9vmg7kR5eyQbWAbbA==
From: Israel Batista <linux@israelbatista.dev.br>
To: david@redhat.com,
	lorenzo.stoakes@oracle.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: osandov@osandov.com,
	linux-debuggers@vger.kernel.org
Subject: [PATCH v2 2/3] mm: change type of state in struct memory_block
Message-ID: <20251029195617.2210700-3-linux@israelbatista.dev.br>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029195617.2210700-1-linux@israelbatista.dev.br>
References: <20251029195617.2210700-1-linux@israelbatista.dev.br>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Oct 2025 19:56:30 +0000 (UTC)
X-CM-Analysis: v=2.4 cv=DJTd4DNb c=1 sm=1 tr=0 ts=6902716f a=WIeu/gG1zxr2CnNbFFeIHA==:617 a=xqWC_Br6kY4A:10 a=DtwXHJUFikXtE54jZx8A:9 a=TWtOS45hTxhqQf3p7L_t:22
X-CM-Envelope: MS4xfIkluH79V4IjV3WQC/76OxLvrpG/ldOucB1qUH8rgoijdlrawTPSKVyHdLBGlxue7CiqyJNzleaKJonTXFm6V9PH7CzxWWxRM54B5ymEOiK2xePXbZrg qN937g6oFhEljn2rE/8vldXHLC0VU4viXia+lW7luHBqAfTtQ54RWjxGp14y5Nw7AmLqutTvTwEixxgCGwrfwckadrL72cdA5zEeWrXD5GZwb7jixuAgYqnl gttG4dqIz1zQDgOwzMY3NFHwBbr62fgs0im4nplx3rsKm8Y9H2FcJIl/Hv2acIux4SKvHfWXdzVdnpwledue417/1wxSNDn37Y/w30tHtEFmtI1JQ9u9MP+w gEaCDK4/NTY610xa8BXsgRCo67+VVuaCpyXkT/1kDKh8jrIvwqR7wtYfYjtftdvp0y8+40OYvzcBJXt4onb2FC1au8CEZC7MFPA9t4d+Vd3F5ZlcFEc=
X-AuthUser: contato@israelbatista.dev.br
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 189CA80009
X-Stat-Signature: j9oz6q6j6ga5mjkjfww71ja5dx7jpw3p
X-HE-Tag: 1761767798-226358
X-HE-Meta: U2FsdGVkX1/gowXL3CVkOiv4YpEP+keXe8sVJ/crk+FFFxHT7YukZNHoyGsCbC2F5rr3R/K0TsqcfjzooLVIUzqBV12ikS/4axv0N7+C9+RSBxmRWFG1yeGE+1HMXf+422/Ug81vvsyMcfmBekt4SAAtdAkQvVV7a0nozk5YNUatoyKGu0ohiRHGdf2ctKfn4AK6+YFX/5UxqsjzJfdEY06nFP7vqeEz4eFkmReKCKt5WT2hsIALl+Jh6UwxJ/qT3J8q+/4hgqZoGcU8UpFeVgqkwWLxn93c95rUzZ59CXT+oRRhHJuv/fYnZ4UX1dLkMz1j5sISuVsz7m6wpgISjPld5iwOQ7q94NE3GS6YxWgnP/BvMjUSDPtHZzKbKVxq7Ewmsf4akDV64cov30NLsdo6aVBvAb+8IB4JpoqPmUP29AteNAiqGN5Y254S5iw+My0dQnvRIqBEv5mAOyaRjdwiMFwKy7D3Rs0aelJhF0Bb7EQqisFaYysUJDGrGuCrMlVvCg1C0ezq4wQY2JZOI1lvI7MTM/iQ+BacORh1piZMf7WNGKUS2nM4TQ6kBNx5rseNqducogYcJYiV5h6IiBeq1xdosiubK0kGkrH3n77fmEkNcFoQiNvjDPFr7lPo8s4nrSyB65eRwcNnT4AERmSO5/2icwYn8eGSD9eEt47xYturtJr2qs722MQygluk3s1Ox76yND/i9iszyrgMrEAzN9kqIauZzo/5/i9pXZ2J5e9p6yf996U8KC2v+j4g4v0qzSAuaSTiTlCsyBGppWWEftRf7Q8Ky2Dx8juHeBtTwZdQuSP6eQSLeqgohV5pYLy07YOYl/dufpc3ZSkQuwl4hbMTqLFOUHaGzz774WDr+/3HbdbGtJaX1pIhdpHOLHv5r/hESJgc7dQ79OoPsUPxtkdLytPMyHa+Xv+wuPIbQXk1bRMlMtsQmHkhlwisLelhWN1sqmq4C7Dqr3X
 vuzLfiD0
 puNfpUoCZPefXQ/Il/1TwZ18M2X/z8gGkHfS8P6EqwLmhZPyDx+cBXqkL6edcucr/VX0wnJbyQRrVvUif9TNhgAy3KDEY0++jh0LW79CLaZUFZJDjOJaAx5e7u/tUrHzTbGExL8NKwGjC6uS3UEj+QQE2zEKgIPqnFSBYRYr4gKEtiFUQAkco2lA3Y7eJwDexVCg7S3iI3V0TtSFvZur2vH4sXNbYeiLDnEXEIZ27PnOatbD/KF5hG7GRTIaCVrolu0ARVVZIvzUBa9sbQ3I8It6i7ILcDKG4iU5QL9Fsa1sHKuLQ6hnDFqPZIV2+jF7CXL8KKsEn/URuhEI0JVjWV78NJt/Uuf/T9vIO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000103, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The state of a memory block should be restricted to values specified
in the documentation of the memory hotplug API. However, since the
state field in the memory_block struct was defined as an unsigned
long, this restriction was not enforced at compile time.

With the introduction of the enum memory_block_state, it is now possible
to incorporate the desired semantics in the field declaration and
enforce these restrictions at compile time.

Signed-off-by: Israel Batista <linux@israelbatista.dev.br>
---
 drivers/base/memory.c  | 2 +-
 include/linux/memory.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 6d84a02cfa5d..3d17dd774947 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -198,7 +198,7 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 		break;
 	default:
 		WARN_ON(1);
-		return sysfs_emit(buf, "ERROR-UNKNOWN-%ld\n", mem->state);
+		return sysfs_emit(buf, "ERROR-UNKNOWN-%d\n", mem->state);
 	}
 
 	return sysfs_emit(buf, "%s\n", output);
diff --git a/include/linux/memory.h b/include/linux/memory.h
index f4e358477c6a..36d733283329 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -78,7 +78,7 @@ enum memory_block_state {
 
 struct memory_block {
 	unsigned long start_section_nr;
-	unsigned long state;		/* serialized by the dev->lock */
+	enum memory_block_state state; /* serialized by the dev->lock */
 	int online_type;		/* for passing data to online routine */
 	int nid;			/* NID for this memory block */
 	/*
-- 
2.51.0


