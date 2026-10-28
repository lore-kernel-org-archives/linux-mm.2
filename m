Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F6AA606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oSdlew1S
Received: by kanga.kvack.org (Postfix)
	id 93A5E6B05B3; Wed, 28 Oct 2026 09:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911D16B05B5; Wed, 28 Oct 2026 09:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801C56B05B6; Wed, 28 Oct 2026 09:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61B716B05B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:46:58 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAB314033A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:46:57 +0000 (UTC)
X-FDA: 85372160874.03.6E9D368
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 39097A0010
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:46:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oSdlew1S;
	spf=pass (imf25.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793195216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gKFUBdSy6v7/SpB0ZQpz0JziViW1zO3RHjALuxOoURI=;
	b=KYzyk2b6gwXAusFcZAp/2nJj/GvLnl/e6ymuKKRA483RaKoSv4mDcIPRQOdx8B3W2HlXW+
	utv3zTMps2/bpmH9n9PiiyvnBlkg74L4lBbNnUHRrAewWRTfySMjxYkqTh8Pm6zFnrzdyk
	Mkf47ERAU+Ftf/AqWhr95hka/rV+WkY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793195216;
	b=kq8IhJDsW+4Q8nrSu+S+P6vI/21Y/UdkegEcOl6YlhoyZm2c7lu6tOJpmMCnSTw1BAhf7J
	0nOTgBxkYgPpBM8hbcTwxVQOy1Ts4ilUb5kHxE+VRlriMpaaoZ03OBg1OvlFRrdxa3jKTe
	QXIgjQE1BJNEwyZUvcZbISMTNJHXJTo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oSdlew1S;
	spf=pass (imf25.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cd61a2dfd7aso361336a12.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793195215; x=1793800015; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gKFUBdSy6v7/SpB0ZQpz0JziViW1zO3RHjALuxOoURI=;
        b=oSdlew1SOs5FVvPMYATN/qUHw+sjT6JM/SK0ZQoQUH9oFRs4eu5mD5bz9eH7ModgwM
         Usc9Ay9LNwmAVL7iZ/xWkmJm3Ka++4qXjjgoCMy03WHvWhCmlkVjdKc6ZlNJ2r0gbT1d
         NeHmy59Laue8s5eZznECwvWVKL/dAUKjFztxJf4E03DL0qCFQuG5QTmDgxvHd6/q0W7e
         rKAVvAr2qbMgg7s2o7bM6ThAjycHDpCfkj+HMqwA7/lvLxQfQtffZoy9hbNEib1k5s1d
         eok0U4w2FXk+rDabwsH0ASvxt9EcWtVI6ic9bWwwamuXpn/nRJalWplW3OUOunyRtL3h
         KfWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793195215; x=1793800015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gKFUBdSy6v7/SpB0ZQpz0JziViW1zO3RHjALuxOoURI=;
        b=PFhEjpcixiYqG8oOCSne0Kz0l+PLQ+ILpJLyhVv0vlVUHDTAWAxA6KzpBoQ74GDFin
         bJ6+up7CNuc2bx5RiSHjh7XBP+VXoVclMVnwmsip/QYrTVv5UTx633lotJV4tqGnWH6E
         pdJosub4Xbq9n1s0IRU6Aupj6q9RT5q1CLOBdQJuVnP9rxUmvkSEszB8B/AtcTaRh8TA
         G8aWeYKWKuZoRhiS6LX03LY5tkOmIk52xVvcAUoGpXRqPVyX0HynxfYjtjDUuktUeSie
         n/C38i114XDScTLtdz5ADL/Gv1DLqc/VDqP2lhLeNE1XE2K65v+6vSlSIghgiXxKdCOg
         s0jw==
X-Forwarded-Encrypted: i=1; AKwUvBwUL3MrAQKenJZdZwbX90a4AIAgz7W0falorAsbHNVwkq3cE4QSDodNc57tsSm65q/tdlHi8qFDvQ==@kvack.org
X-Gm-Message-State: AFq9FYLyDuqeDQWu5MU5LAdEfRjthoR/tfgPdVoAONlpg5bAf7didQQV
	rJ+nBQOBnDXhj2QwTJBJv7x8YydUSU2RuWJdWFSQ2uASfLLonYuE6lZf
X-Gm-Gg: AYBFou3Gay/+27CMmlALxShCL8rCcJtPbAwYXDXt9aK7uT8xb+mdLNme+1KBjgtEuCA
	2kUjSOai6AID6siW3QZeslIwHsGXS4c6ILYjHc6Pj97X/RcVVCRd7/e1yQzAYJ9zwDVq3gzWiWf
	aVsM8e+N5xRsFpEjjAG13BgI/1wladMP4lcQ4cF3MPq6HAlkDWxcNYBw5d9Vy+lOx7b1G4uEN29
	de7md0KrAfjcRnJIkR91bE6eCYN6RkXWAvYiQ6Cm5zz3zFouRxkVMyBWXJ19YIv5w1n61YOK/rd
	FLkKohjFMPwCSRkhWVpafc5j6tX6Nh5wA73r8+PQHIF8pIG9y01AZ6M9O1RyxuGNHI/fokGZUGD
	HKs9si1k5XR1aoMe4etqxpTiH8lD3rI4ktliEQu9uX/v9wqjRjLIgj0vXbfHY9j72c8yCAZzIqx
	UZkgNoOcy9L4KuZYf8IMuYmjqGmdkjRIp1gqzdMihuWwwP45sCfgNSmc0CthZGJ2vJAhK+kkPTW
	uX1FWpnfZ9AgcDOsequVw8SNWgQhprithQs2He1LSiTVBqhll2R5s+wuEJC633JqjUufoT2wdoP
	5Vlq+LhkBgJeQPFhBYLH1ZG9rndeO3PrYAfBOfwqRqkg1w==
X-Received: by 2002:a17:90b:4ccc:b0:3a4:9a7a:360 with SMTP id 98e67ed59e1d1-3ae58100a06mr1891992a91.29.1793195214929;
        Wed, 28 Oct 2026 06:46:54 -0700 (PDT)
Received: from osman.mioffice.cn ([43.224.245.178])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6ca1bb2sm22014585ad.68.2026.10.28.06.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 06:46:54 -0700 (PDT)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
To: vbabka@kernel.org,
	harry@kernel.org
Cc: urezki@gmail.com,
	paulmck@kernel.org,
	qiang.zhang@linux.dev,
	akpm@linux-foundation.org,
	hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	rcu@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhanxusheng@xiaomi.com
Subject: [PATCH 1/2] mm/slab: restore the rcutree. prefix of the kvfree_rcu parameters
Date: Wed, 28 Oct 2026 21:46:46 +0800
Message-ID: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 39097A0010
X-Stat-Signature: wbe1z7cyhiget36yu7we9gqfwrc8n4ut
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793195216-41395
X-HE-Meta: U2FsdGVkX19hiuq2DgrSAnafwsQjPhMFKS6ir70h3yd5kCuQtyw1MQCLKo/eXY06ceaq3QVCiQ93hZOd403w9IO8sT9R02qvouNJ0dTP9m6VQzI2BeiNuSRqJ4/foVUfVLv89TZGgTjkin1+jW5QVsCx9q0DozEmUjrYthni+Yt3aUnwb6g98kjW128vPn4LI9gdChNNewyxNn6zEX7JVlj5OAsdN8CBMPSUgt0Vnce+0TzVIaK014QdtK1NuwCOm3c16yv4WPOXiDREQzyidNfc33y/qf8sw05z8frx2+mvBocczTmhTRDgxJf2f3NHReidL3WWyjN35y2JC/PjwkrJUoLs1oVE+6lOSkfXednDsJMOkUmoMXc/NNqFROmhRTQCIdN+doKZX/5eviq/0d+O9EZf4J+lfA7W0nDDc+d8XN7CMJYdOQzg/o/5CJgSfGOwbZT5wMZUwZ0SJh8OWFvesYEUAcDMvvOqzkSSGzZVlhpF65c3uYdLMmO3NDerepVEO/57GtO8kSKITl+1QBGDUBGFWLKsQuM+L0YjYhX6S3VEJw5RwPyp93/yOgxNiKOSbXx5a3q8w7wuuHTdsGxoxRFbp5VrrwNhEjeDNwWSyK38z9JCMyickUaBeWxK0HCNjGurT3ePZGsmzheR0BOWz2P0ViU/enYMRiuDVVNQYThtC2Yu28kqhr409gBYKhu5WBjREFSvAGaFguijFrv0dBQDZD0Mn9gfQkjqbqVCt3eW0j6bougQoDbZvlF974lZ8A/vG1LFWxNz4/Izq1yXxlRTPuvrTZFRNMygL2KJLWcEPrmbnDQS6lAGfOscXNKsiCI7kDs2T7WXaejTfhxWZrAR5vySv2ixalhDqwKz+DhTYgDH/dgOHYkVb8zYXWm7J/vQceSbU2NCK9TGEbylQ2IleEGbyI0/tP78MJQ55CYN8JE494cRpRdoALHm4AKXupVVid5dlD00j9E
 O3/Lqiw9
 GY63/oGnvN6SJ8tbOsE7z7y438eG4BEAyAwGSwfgyYsGse6zk9Lr4wpnt7va4KdbdPZiuPXC4QPi43qraR/x8N/s46T6dlLU/uIAzqEAFBwTgTR/3zWeJntr6+QguSg1dK6JjLjb1OsNR32Gowv599Woh0D8+ACbk2UNRQmv3EoH8cmpIdBCJOwgwyTHnZippaXWDYP7Ou7ttYQEa6bL+Ys5BgI0Ss/kZo409MpOw41RMd4gtlrBGAqBmpmlRMW9uKt+Xa/Q4FiZBW1zPfUxxYOu/f4zuzD7DgzBCawmgU+e/iv3ZdihMqyWOMYNNJ0lnVepsl9ECsarNKffGuNq28v/UbBm8B9y8YloGsQTaMm60Ry2urkvseW7pjKSxhX6CRhorTvUiUMdM0KaZC7QfoynoRNP9EK2mGSp2Vo4Baqsy07T9euYJD9Pf/DiPphjb0S5sr401d9hBy/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhan Xusheng <zhanxusheng@xiaomi.com>

The move of kvfree_rcu() to mm/slab_common.c dropped the "rcutree."
MODULE_PARAM_PREFIX, so rcu_min_cached_objs and
rcu_delay_page_cache_fill_msec became slab_common.* and the documented
rcutree.* names are silently ignored.  Restore the prefix; the
slab_common.* names, never documented, stop working.

Fixes: bbe658d65802 ("mm/slab: Move kvfree_rcu() into SLAB")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 mm/slab_common.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 01c64ef661e7..3729aa7a6156 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1373,6 +1373,10 @@ void __init kvfree_rcu_init(void)
  * per-CPU. Object size is equal to one page. This value
  * can be changed at boot time.
  */
+/* These used to be rcutree parameters; keep their documented names. */
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "rcutree."
+
 static int rcu_min_cached_objs = 5;
 module_param(rcu_min_cached_objs, int, 0444);
 

base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
-- 
2.43.0


