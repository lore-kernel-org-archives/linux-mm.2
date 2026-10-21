Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3957C606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UEiUIF61
Received: by kanga.kvack.org (Postfix)
	id D60176B06E4; Wed, 21 Oct 2026 07:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D107C6B06E5; Wed, 21 Oct 2026 07:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF1F6B06E6; Wed, 21 Oct 2026 07:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 968DE6B06E4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:48:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90476C0541
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:48:04 +0000 (UTC)
X-FDA: 85346459688.02.B4CAD9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 013278000B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:48:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UEiUIF61;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UIvPhIRZOXHZ5pivfsKNKW7qsEyxT6PjRp1D6g3/ZIc=;
	b=JoTZ+hL2VkYxFatczHSPpserlN6F9BX3+516H59Ph7OfPSkWigwrGGPS6bWajDlXj8WJpy
	4rNrtDEqEHqNzl5M8DKdToVGSTsjtaxY6bwcbuxGlHPWbyOrf/Rhkm6V+2Y6GE6k/f23od
	xQOO0xKTIJxHgHbAtYLbeDWWPaWYB6E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UEiUIF61;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583283;
	b=gewcOypycEa6Vw99FAlVT7cmCFwwK/daW0S5r21wkrRkBULs9VeMKQOTBQoEZL5x3CNNG7
	XklWTIj58lt/vFMZVvfIw3y5sCkgsLm356W/mrTyfER9PaL2/yMNW8W6Y+QHLoaj4kzNFf
	W1cvqN2BLQoEWXO/T+V8gIlkpi/fON8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92C23601FA;
	Wed, 21 Oct 2026 11:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EF71F000C5;
	Wed, 21 Oct 2026 11:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583282;
	bh=UIvPhIRZOXHZ5pivfsKNKW7qsEyxT6PjRp1D6g3/ZIc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UEiUIF61PWjHXaujmCUo3lHTkwT0rOwBz/pimHwq6xsb98Nk51S5FVHLcVJldFKyE
	 zwT+rIzRyNIMu8C4sh9+s+FxwTZ6rKF54hbhKmChPa4Mjt0iV5H0rmh1+fnpDvvUoU
	 WXFilAFLMjQSWv3qZ+fISA3X1mcD+naUh7LjdzKo9mfmALAl+Xv6lkJxje6RuzTZdY
	 H8aTNC8PTOYMEEEElPz2N0UQGnYBXZF6/CnvEAiDU3zxTxOIqJcpGjlnB98Q6XHGFa
	 SFk9utPZV1TP/6p0k4DHDT5VcjcuhyTgg+eaxnK+SoiI6m0oeHy24LxI6UPpFWwzD3
	 x0YmTpdPrP7Bg==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:51 +0100
Subject: [PATCH slab/for-next 10/14] fanotify: specify SLAB_MAY_ACCOUNT for
 event caches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-10-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, Jan Kara <jack@suse.cz>, 
 Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 013278000B
X-Stat-Signature: 84ijrz6ub1685k1h94g6bu55yqixtpkm
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792583282-373130
X-HE-Meta: U2FsdGVkX18hZU0IeAsTRlfYwkF3V3IshWHQla6yCMTR1IAafKqFLCy/5Fro3qTc40ENIs+80W+uc3ywIqJVPWj3C4vX/loGSyBgXeLzBncq/I3k7+eISAsmD03v//OgaUIc4xMS69hNBdGm5/SEc9lhZcAyGgWkR19dmwjxerBcgMm3A4yBa/BvbqW7sKty/fVvNJsqCs3t8f80pK8FOskpOBZrL+BymBr+79kMHO1R5NzUeiai6vVCngzu4pvDCGdKTnPxhshkBEzQS43XhAlq+EwvIkPo43kGxD8trXogdYp17TxFS5u6ghBGrEVFvaDl0zZJLH9PEEixqMIKrHFIPPL7njRs74I/2j4IO/6whbhxrpwlXA1RPWOtxaOa2iYYgwwp93Q3HxKJzJw3YYdEaaRbtxXdKMkElnRlJWsuxrFVL73q1M/0rM1UxAgwmD65C4mf7oG45GU3zZ86JFME9UdamfaRLdrejqHmfL0etJ74Wk1hf4jm5xKIVM5hjTOKVoiii9RIxK8gcvOQdbZtu482V1azbWuNyDyngj6kvz+C8xhugFn7iwscLF2T3DSU4pXAqTL87uB/1bvEfWXJn3X5blf2a2ehlp87T/pdA7vlkU7eOZWg9jVjSI1eIXUrHo02Pl05cLXF5se3zAWDWb7XJiIE+UQau5hmXH8y5Dovg2q+YGwc5rzG7uBsarZdq2J7i+4Twx8WIBp6JDTWAVIYRp4GBArZkEEM+SVQq3H21dtcV2yVnFLY9cxu4q10ieKqYh0FeEEv2M/nRSYwybX5vNnvQ9r2W1GtWqfLmyFmPco3TElzPNoeG+pm6QI+rdmnKbEuN0DDhwwRH1IQ8r9XnaO8HxMmTdw/Gui5pM2NxO9kUSVKmP1Rmko4V2y040fay8jCKUlSosdQ5tRxgVdJ7TDj/mvkfOj1vaKusNGGze89yp6fgNsDLAiFsT//UEIGg9VxZbN5krb
 RnYDZt0v
 MSGDZSyl5Yw1CU0/u2b8YvRf0vv0i4Y3xJLsyIehD29HSIqXeC8y3VEyEMkp6VpNZRws3kQe3Rfi4VwgtkujNPo91BtoF3WXslYESYYkkaxYl/ZOK1HNIIIYcbf0F+Om0AAQeTc9IdptJy7aAVV/uvhtws8vyzEynCOvCw3LQBbx4/DOgZ9WEMZBpWx6l9ac5i7yDVcx9yTMNljZmUBxEMj1fI3lMqRu698p5YUNBat6lDM08aMCyNXjxrHVsZESXE3YSUwJNpIo4BkC6SbXDh+TTWKEersdxMwmLRPjoZaA889xURmrTDhr2QQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fanotify events are allocated with GFP_KERNEL_ACCOUNT and charged to
the memcg of the listener. Specify SLAB_MAY_ACCOUNT when the object
may be charged to a memcg. __GFP_ACCOUNT without SLAB_MAY_ACCOUNT
will not be allowed.

Path: fsnotify() -> fanotify_handle_event()
  -> fanotify_alloc_event(GFP_KERNEL_ACCOUNT)
  -> kmem_cache_alloc(fanotify_{fid,path,perm,mnt}_event_cachep)

Assisted-by: LLM
Cc: Jan Kara <jack@suse.cz>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index a32c6634d592..bc1227e521a8 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -2184,14 +2184,16 @@ static int __init fanotify_user_setup(void)
 	fanotify_mark_cache = KMEM_CACHE(fanotify_mark,
 					 SLAB_PANIC|SLAB_ACCOUNT);
 	fanotify_fid_event_cachep = KMEM_CACHE(fanotify_fid_event,
-					       SLAB_PANIC);
+					       SLAB_PANIC|SLAB_MAY_ACCOUNT);
 	fanotify_path_event_cachep = KMEM_CACHE(fanotify_path_event,
-						SLAB_PANIC);
+						SLAB_PANIC|SLAB_MAY_ACCOUNT);
 	if (IS_ENABLED(CONFIG_FANOTIFY_ACCESS_PERMISSIONS)) {
 		fanotify_perm_event_cachep =
-			KMEM_CACHE(fanotify_perm_event, SLAB_PANIC);
+			KMEM_CACHE(fanotify_perm_event,
+				   SLAB_PANIC|SLAB_MAY_ACCOUNT);
 	}
-	fanotify_mnt_event_cachep = KMEM_CACHE(fanotify_mnt_event, SLAB_PANIC);
+	fanotify_mnt_event_cachep = KMEM_CACHE(fanotify_mnt_event,
+					       SLAB_PANIC|SLAB_MAY_ACCOUNT);
 
 	fanotify_max_queued_events = FANOTIFY_DEFAULT_MAX_EVENTS;
 	init_user_ns.ucount_max[UCOUNT_FANOTIFY_GROUPS] =

-- 
2.54.0


