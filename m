Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DAADCAC58E
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 08:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D74308E0006; Wed, 10 Sep 2025 04:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6ED8E0002; Wed, 10 Sep 2025 04:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50DC8E0006; Wed, 10 Sep 2025 04:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A255E8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:01:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66A70C07C7
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:17 +0000 (UTC)
X-FDA: 83872595394.20.1AD3424
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 277A44001A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:01:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hn2urHv2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hH2gs4l0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hn2urHv2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hH2gs4l0;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757491275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtSF476Ds9zbd6MrnqNt5+BMzWFkMQ3IyLGQJMUX73s=;
	b=GhWZxbVWf6kjy162oChyyicszJBKWlEZBqO9F71LKgS5HE57D11F4/2wgCW4RNEGaHrPgQ
	V5AElovmEVo/IZImxOLizilitTrHGcT5vMDsG3LA+I5xCDVyOOTtrLSvd+7MnAANz8VTsd
	tQUvvm91m/axErnZlbnWBbyUnDUC7VY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hn2urHv2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hH2gs4l0;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hn2urHv2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=hH2gs4l0;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757491275; a=rsa-sha256;
	cv=none;
	b=DXFEJZ2rjGdurmskFAEviPiO0HDuYGRrpjYKoMV90ahMz6XXuzTJWs1tV84oEodei98Vpt
	Aw/XttRqHmTyPV9UetYtWE3j5b/o05iZEGMvslDzNVmDYYsdVlgkJDCbuVzgjjK2c2Dw0C
	70/ODKBmSbC/54ln17B5CPWLnIid6cI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4159D5CAF3;
	Wed, 10 Sep 2025 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rtSF476Ds9zbd6MrnqNt5+BMzWFkMQ3IyLGQJMUX73s=;
	b=hn2urHv2OiGDeG2e77bSB5GER9p4pdJ++ttQNeukFcxzmDTFL1R94/ETAf5iNKiSBwR+6x
	ZYkrNBrQDTlWBvyTDBzQhNjSR/WOnFyoSj0iyiuRMnsb1wIvmEfvLFUcAYSWx8KUF0+mEr
	SnI+RpORYz5Ma98hX+6mHa/6FVAo+PY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rtSF476Ds9zbd6MrnqNt5+BMzWFkMQ3IyLGQJMUX73s=;
	b=hH2gs4l0wjzny7y+HOMHTr+laUPULtcUp47P7if3WBPoc92+bHFc6mQ32QvuGbOkqQQk8a
	9cZ0vzGBTGKnyMBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757491267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rtSF476Ds9zbd6MrnqNt5+BMzWFkMQ3IyLGQJMUX73s=;
	b=hn2urHv2OiGDeG2e77bSB5GER9p4pdJ++ttQNeukFcxzmDTFL1R94/ETAf5iNKiSBwR+6x
	ZYkrNBrQDTlWBvyTDBzQhNjSR/WOnFyoSj0iyiuRMnsb1wIvmEfvLFUcAYSWx8KUF0+mEr
	SnI+RpORYz5Ma98hX+6mHa/6FVAo+PY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757491267;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rtSF476Ds9zbd6MrnqNt5+BMzWFkMQ3IyLGQJMUX73s=;
	b=hH2gs4l0wjzny7y+HOMHTr+laUPULtcUp47P7if3WBPoc92+bHFc6mQ32QvuGbOkqQQk8a
	9cZ0vzGBTGKnyMBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE4CF13B02;
	Wed, 10 Sep 2025 08:01:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2A5JKkIwwWgGJAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Sep 2025 08:01:06 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 10 Sep 2025 10:01:14 +0200
Subject: [PATCH v8 12/23] tools/testing/vma: Implement vm_refcnt reset
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250910-slub-percpu-caches-v8-12-ca3099d8352c@suse.cz>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Stat-Signature: xfi9x9h67zjubk6ockfmigt3gp1ys5is
X-Rspam-User: 
X-Rspamd-Queue-Id: 277A44001A
X-Rspamd-Server: rspam04
X-HE-Tag: 1757491274-864401
X-HE-Meta: U2FsdGVkX1/oTqI79/viwjNug+8MPQF7gtvk0YeQeI3oShdfD4KkLDyhbUedEx2djHYH67wtMvtHX1Jyg/2M8vKta5UpZObcW+lG5L0m0iTR0nIm2NKIjJwcV2unFfcT5HDUtEFf5OA555mvDYfr4rF3zGtVmZyqCFEpxen1zn1AJvfQRCqwqM8g21EpLzHKgyiyB5Vwxga1mOdm5oGaPWIcWrZgI84Eaoqzyxs31/Q+HilVyjxIcb+ck7/nEq6+OfHiA86gPPdVAYOTD2+BKhZUMzvn4dvdYGWK1yAUBJRkZu26pcM4j7OpHdzWFVlS7tuOxQtWid+9cPtb2oxsdyiSThserrcMviJstwzkn3OA6UG3k3M9OrsU3vKxFrnN+L66GURTuNwPoBzafHjOh/0JkKuPzirIXT1wS4ZPf0YO8ReA8WakGaHc+J1GFCelR4ydbZFyCxx6c3mcy3SiwoVMLtu+J5uXR9MZjok41KQvJ5i4twqZ6HVhdwz/6NIbWSo6Ltds1t7Bad+vVzqjZEt+eSHf9d1ObjV2tNPVsHqap0D6ut0vimuaU7eGvJm59wIhsIb36mJYKPi4OBNwBsRIRwu9YM7aw8qWEz+yFUlqCqu+T3eRCfNIwGTZZ1VIuonwUq7nChnqLARtynH96w5bUmplPC3/1ssf95KpmR7rvniuXjmI/xk+Q2dJrOBBvWqvAuwedXfLXQRXWLEAUz7APS3MZWMux6WgI2jMDe0+c5kEL7DETTMc5WQTOlVZOq07Ut3aFkLbJbNSLRsOEJQw2z4FM8ZtFc7aVqS3tn42oWNr38Jd34zDGi9unudQ/OL5a+pIKidn7HE6n2/9hOL0O6CItJabthwa1msccw6YMsnE9Zdn3/PBWivAAPy09XUGuVFeiFxSi376X56bOj32eV4DIcdKa3kECfKW3MrsyvONYJLcMHffj3eFVa9hE35LyUxS5eIgDN4E8RB
 UY5dH9+D
 /X7cqi/g94Qp74A+eIMSbR3snzSbXp/q7rABkwiO7rE/ZMRYq2DjcE/0ZlX2V1K2D6Ds0Jui/XFbfuf0BI5bHX+Gz/R3NBm4wBLLFReRshu81ocWti0lFhiHSwJMn4Lfm8lfMIJNJKifV96hZoV9MW4hSZHJ6UQhSUfvZTbMeKHsYkKthDhCEMRr33JWudhfKilUjSeomWw0AzDQfZkHQyW/+1dC0D/O6nqoMISbyPD46TLdjYfL9VqPqk7Jbem6y8bN0IYj4mDgLXT7aSNNETDCCBi2Xxn38bZcx5xINFehbNtBK00Z0NpWL8AHI7pm8Kt/yChu6z3+0zSk8y0pVGuHCTv9xUv0fslWz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Liam R. Howlett" <Liam.Howlett@oracle.com>

Add the reset of the ref count in vma_lock_init().  This is needed if
the vma memory is not zeroed on allocation.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 tools/testing/vma/vma_internal.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index f8cf5b184d5b51dd627ff440943a7af3c549f482..6b6e2b05918c9f95b537f26e20a943b34082825a 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1373,6 +1373,8 @@ static inline void ksm_exit(struct mm_struct *mm)
 
 static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
 {
+	if (reset_refcnt)
+		refcount_set(&vma->vm_refcnt, 0);
 }
 
 static inline void vma_numab_state_init(struct vm_area_struct *vma)

-- 
2.51.0


