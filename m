Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D321AEA4E29
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:53:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40E2F6B0095; Mon,  2 Mar 2026 10:53:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376AF6B0096; Mon,  2 Mar 2026 10:53:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11CC36B0098; Mon,  2 Mar 2026 10:53:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA6636B0095
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:53:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2F861C0E2
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:30 +0000 (UTC)
X-FDA: 84501567780.08.C6E0037
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id E3AD01C0012
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="f0P3IaV/";
	spf=pass (imf20.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=3fFl+ZQpqgOCDxOl7PBCDqalPNAwSCe0FsyOaa3j76M=;
	b=cmVSyHtkAu5dXQ5LcdBAzn1T1zz2XFHDdN30CvPIvxfu6YPt3nymK9VTXDprR0/vF71AyZ
	e6NV29bcdkwzXOHTAqzE/TAUutJZK04VjgU8CA6YdUtEf9CtLvz/6d823jNg0N/IK/+h4V
	eNkewR3ipzPxd4Gb3Sg5CD1azNGeUHw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466809; a=rsa-sha256;
	cv=none;
	b=nMoc+CAoMCsbnMPh4qrRW2P3+wgijehj2ck2yp+bH2aalfe/VkXbq7bj6E/m23JmmqBNyH
	nn9X9bNwnYjfb+Dj3119cVWgdwAMvlsNYrsDJmPtU38dFwvF5G/r99UCHOZmyPWiyJYa4C
	P2WwKR6dO3j1kvry0/107Wn5OyVRr40=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="f0P3IaV/";
	spf=pass (imf20.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772466808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=3fFl+ZQpqgOCDxOl7PBCDqalPNAwSCe0FsyOaa3j76M=;
	b=f0P3IaV/VYukrHzGv1uUgwSBYw6DQ2uDXs9gJ7ewfnPaNEvqagIji7ZWXZVEv8juyFiP0X
	M5OrK+Ho2aUd5UkcO/QE0d3MUahfux17fM4Pd1uugXux24KheNRb8ULUelyJd2vIhYrdsW
	6iPeJCljjtR3PcfiTAW28aZ6rBnpD0c=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-402-81pMIkUsN5O9DDZjxwXCsw-1; Mon,
 02 Mar 2026 10:53:25 -0500
X-MC-Unique: 81pMIkUsN5O9DDZjxwXCsw-1
X-Mimecast-MFC-AGG-ID: 81pMIkUsN5O9DDZjxwXCsw_1772466802
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3FB5C18002DE;
	Mon,  2 Mar 2026 15:53:22 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.6])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 052691956053;
	Mon,  2 Mar 2026 15:53:20 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 8E103401D9E1C; Mon,  2 Mar 2026 12:53:00 -0300 (-03)
Message-ID: <20260302155105.184592916@redhat.com>
User-Agent: quilt/0.69
Date: Mon, 02 Mar 2026 12:49:46 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Leonardo Bras <leobras.c@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>,
 Boqun Feun <boqun.feng@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>
Subject: [PATCH v2 1/5] slab: distinguish lock and trylock for sheaf_flush_main()
References: <20260302154945.143996316@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: jaZHaZLR6CgUrQ_yZghGOboNo17fBHesb2vPQwTrbYw_1772466802
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: r9zypkbqwjibfygwte7ucmg3mypzwqz9
X-Rspam-User: 
X-Rspamd-Queue-Id: E3AD01C0012
X-Rspamd-Server: rspam12
X-HE-Tag: 1772466808-712268
X-HE-Meta: U2FsdGVkX1917b1Myu0SrqdbUTAgt2oGqnj0yGJMum9pcbZdmC5U67KzWnv+PXtkcqqEaZRHNjCyY2GDtAwcgFlQzxkhUFYyyNdbAPnViaP51VXn9i6l6g1j7CkTvtpjD7OclfRpwP4VehMlMFIaMBJfyDpVZ2ARWxdth7ZuVgFon1CxPJ4h6VD0j633JJliL+xUCYb5cHzxflVvsYLe9UBnKWl5zrfKvpFsGXZGIDhAF/61LdlctltDwg0h3MY2wcK2H6+A+bnYa23CCDCaVB09u4oBz6pBo9qjBOXlpCtmeqJ//72L+fUmSVYUhpc05UUdCBO7kq4HETznXMnAJ5itH3tYFFC4GMW9GyHJS+TRS+9biRoiqLdaEpS3+DyOlZQCA0Aw7Umgt41TI4i+hnZ8GK5+Z73HoVtx8C31RGctD37WSv9EhHv2HOZ5bu/Ge+bou7wtcY7pxT/w72wJcAL2mXhrErHq4IUMp3NvRZR1l2usrn67mBD5Hx4+CSqJS8cFMyZyUlPdE26bOeRQoTiD1079oq7zb70sx/BeVsPXoHu7HMNklY6MZbqQRs6U30pTpPYhPzmp5pZswd5pxL+T2vLFPNQp09EBChrkCFQerDMt6x+FOTKmvmsPdlUtAtIb5RuktVtgVmqsUxT5SmdAnq4I3lScp6XssWqSvzhkLPkqb6yKXUYVzGRZm8p2bi57qW4xsXKEvtav7eAYXd1B/WMHwulMOhtfaxGRxweJe2kbPi1Dvt1NzkNj7p86m1EBe1nDg/EySblD2/fBC8o/4wMsM+0tcAO58DXrbiNiIzauIu3fXO7xma7owPKr2KKdfdhsKk/Bkh/eju4Hy8pGr4EK5veoTCQI2rNQ199s9yFTrRpiQGtvVsPFNGdM8AXgzd1XEMnnMjzpfLR51HMHGATitAr9SbJd5DX+ioa4RfKhvUaaLkeB7zuERFmu1PdxXpCcPxm0rVh7e5S
 uGsJoJaU
 OhjJ2XnpKUp62VtxxV0JTecHX7rELjqdw5bGXp0wOovORE+Mw+kKa+Bxz16gYrXN1s9CBptyjOlhcrs17I20dF0q70PKnMhZ5ZQtAFcvVLLTZrBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vlastimil Babka <vbabka@suse.cz>

sheaf_flush_main() can be called from __pcs_replace_full_main() where
the trylock can in theory fail, and pcs_flush_all() where it's not
expected to and it would be actually a problem if it failed and left the
main sheaf not flushed.

To make this explicit, split the function into sheaf_flush_main() (using
local_lock()) and sheaf_try_flush_main() (using local_trylock()) where
both call __sheaf_flush_main_batch() to flush a single batch of objects.
This will allow lockdep to verify our assumptions.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 47 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 18c30872d196..12912b29f5bb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2844,19 +2844,19 @@ static void __kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p);
  * object pointers are moved to a on-stack array under the lock. To bound the
  * stack usage, limit each batch to PCS_BATCH_MAX.
  *
- * returns true if at least partially flushed
+ * Must be called with s->cpu_sheaves->lock locked, returns with the lock
+ * unlocked.
+ *
+ * Returns how many objects are remaining to be flushed
  */
-static bool sheaf_flush_main(struct kmem_cache *s)
+static unsigned int __sheaf_flush_main_batch(struct kmem_cache *s)
 {
 	struct slub_percpu_sheaves *pcs;
 	unsigned int batch, remaining;
 	void *objects[PCS_BATCH_MAX];
 	struct slab_sheaf *sheaf;
-	bool ret = false;
 
-next_batch:
-	if (!local_trylock(&s->cpu_sheaves->lock))
-		return ret;
+	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 	sheaf = pcs->main;
@@ -2874,10 +2874,37 @@ static bool sheaf_flush_main(struct kmem_cache *s)
 
 	stat_add(s, SHEAF_FLUSH, batch);
 
-	ret = true;
+	return remaining;
+}
 
-	if (remaining)
-		goto next_batch;
+static void sheaf_flush_main(struct kmem_cache *s)
+{
+	unsigned int remaining;
+
+	do {
+		local_lock(&s->cpu_sheaves->lock);
+
+		remaining = __sheaf_flush_main_batch(s);
+
+	} while (remaining);
+}
+
+/*
+ * Returns true if the main sheaf was at least partially flushed.
+ */
+static bool sheaf_try_flush_main(struct kmem_cache *s)
+{
+	unsigned int remaining;
+	bool ret = false;
+
+	do {
+		if (!local_trylock(&s->cpu_sheaves->lock))
+			return ret;
+
+		ret = true;
+		remaining = __sheaf_flush_main_batch(s);
+
+	} while (remaining);
 
 	return ret;
 }
@@ -5685,7 +5712,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	if (put_fail)
 		 stat(s, BARN_PUT_FAIL);
 
-	if (!sheaf_flush_main(s))
+	if (!sheaf_try_flush_main(s))
 		return NULL;
 
 	if (!local_trylock(&s->cpu_sheaves->lock))

---
base-commit: 27125df9a5d3b4cfd03bce3a8ec405a368cc9aae
change-id: 20260211-b4-sheaf-flush-2eb99a9c8bfb

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>






