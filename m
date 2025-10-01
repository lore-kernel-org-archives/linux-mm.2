Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A74FCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 04:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563658E0007; Wed,  1 Oct 2025 00:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515AB8E0002; Wed,  1 Oct 2025 00:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DCC18E0007; Wed,  1 Oct 2025 00:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 305658E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 00:35:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5D4D13BF16
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:35:00 +0000 (UTC)
X-FDA: 83948280360.27.EB4779B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id E8DC34000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:34:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YsHJGiyM;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759293299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c1Do2rkufLmyW7Uw/umi5Z/fqdMDaGBEe8TTZH7oPXw=;
	b=KQtSbNgRQJ/Cg6VCZIuJxPi331b4Pdxn5fodQBzgT/B9o+RB5A3qsqhBKCB8ErOy56AQNk
	1VYxYRHvINwGAfd9yCQj500iyQpf+KeT+Am14IoeJYAxrQjt2NmliK+9Ei4uJCFSwZL4vj
	wyK3G9NAjHSQue7uceCqRB8hIzYw0zI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YsHJGiyM;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759293299; a=rsa-sha256;
	cv=none;
	b=htY81QSwQ2RBYDZOBFbWDMUfsl1DNVB+C0eK69YhP8t03vpdioMSPEQaF6rjCATK0hFlOC
	wdNugCSGjmEREdkJAYHBmd1C3SQyKil3oWOt1YSGm2PolRzDq+uNxZT+ziCQ99ImNStTYk
	x/vKEy+wif8BTsyyG00sN07th5eKoGo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759293298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c1Do2rkufLmyW7Uw/umi5Z/fqdMDaGBEe8TTZH7oPXw=;
	b=YsHJGiyMH1ejdM8vvcI9ervaq/w19FBCnapwUA7E7Pc04/h7Eman9PPcq+7K3fPhvD375f
	Y8VqHaJ4SbZfVk3nsu6JZUIAvgo7FOz6d+Yd3fHjllu8Y+VA/9qEbrzXM9wQIAfiyMVlpb
	/2H5eLhYXzr69IseWjuSFP+REjfTwdk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-QrHEaRghOMWhqPvcGRbZIg-1; Wed,
 01 Oct 2025 00:34:57 -0400
X-MC-Unique: QrHEaRghOMWhqPvcGRbZIg-1
X-Mimecast-MFC-AGG-ID: QrHEaRghOMWhqPvcGRbZIg_1759293295
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A159F1800562;
	Wed,  1 Oct 2025 04:34:55 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.116.46])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D2B81800576;
	Wed,  1 Oct 2025 04:34:50 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 2/3] mm/swapfile.c: use swap_info[] to find the swap device
Date: Wed,  1 Oct 2025 12:34:35 +0800
Message-ID: <20251001043436.41338-3-bhe@redhat.com>
In-Reply-To: <20251001043436.41338-1-bhe@redhat.com>
References: <20251001043436.41338-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U7ElVmJlmdPXbp9t3n5r-EMfN50SVWTzijUvt-zZIfI_1759293295
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m47iiz78n5f4nuha4z448gsee881dqyf
X-Rspam-User: 
X-Rspamd-Queue-Id: E8DC34000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1759293298-325187
X-HE-Meta: U2FsdGVkX19zBa42VZnZ2xsyb1+T1ivQjSbFcHvbXwdhRf/QCZK/KGF0phAVIOI1/VasmOewmVvEcoKwyl8SOdIKDRrEI7iby6LYJmxIb5sFgysojQqssGtyIlu4sWztI1O+pCokdnSw40bYcoSnS3q63aoAuZaApi/RAYwmHSeAUHNiqBWiXBYe9soyuIZ/ldk/BIh5xdsiQbnuxBYHWcnSgX4go2dfhJWhnVDbpWlji5XmLUy2ja2yQ16kHSjNYNFXuTKErjI44LGuGuwTg3QHhNKc5XAu+RUV3rfmkENbKNui2lkMyt6+PmYOcwo+K/ZJl4zYkWqtB7R8p7WCeTjfBoa1YK4j0GqXNPm1Zh11Dg9it6ccpHHYG6RQeTp4l7Iuxi4AtiPA898wXV7zhxXz6YdcsfnfWZx/EzMwytT8v/3W65kSaLWJRzIRlXsUOF0Rudc0wllc9Ffk0VOV/d6nu6H0e+tWru13Wn/j8NktVNz5lm/hxtay8EnCFaJw8Cf1JldvNHEsV5e55LMtu7cb5fKbnUQM5dYLM8ol1muHDPKj2mSIj66iv038asZ3ho9PfsodMnMLy2Mw7+sYHOWak5oT7u6h1DI5yySQOWv27/d461uin+lp9UWNL7h18KaaFvp8BHBdh/4V7uHnN5WDoDXNXOfz8TpVuGPQU3wjyIeTQc5X/6k5Be2TdokUKU+fWOukkoyhxjztMlVHgt8gIIWaGez0gD0/8eEkpUpI5ZgXOPTShe3iHhN9+B8NLuMRy8IDMwoNqgX/A4HQjT9pQoAUum5kHNI7oRKGJeJruNqM4Q19zLn1+/nO8KLYxZlOk2Xv1ySBXD8gProdskCnnN2NEyWUwIs6UWbnxFzvg9uJh5NAeZSUdGyNJNBLcPANrhl7TL91JlSHwtpKVhoSunxJcbG83FibSyDs2DZnr7xmCXSAaEJ+emVEux73voPJaUmFNS3fDJTBO1+
 W+2Uk8dC
 8Rdekx2Ry9SBQw8uKBQk3evq5juNHWeXG+81L3lUEsSQe6ibkX/C3SFWFzHKrAMBxZB2ES/7KtE/FT3JeLbKvMPaFS4wtvHUVPyK3qbyYlJMbf10Em2OAoOfNd6Dg8PbhLChTKhofMsQa2GTsCOqVjY8hZc1Ozht9+7tEY8iPzaqJghkdNuKEa6SVQ8yH8cizYVCedJ5/X5pkAgZvLbURV1IULBe4yUDpm7i1YJIZE7bn+n/Vh+z8VvIJWvykoVokbAciefbTabkA/fuJWVAuZKA1DY/frtnsyofgK1VT6dT+kLBNNhxA9vv1drILQ1Gv2lvVrR4yTKK36LCfjJ1vK/HqiO7CvGnUCV5Uix5NBftTfZOwh7Pj8v9thhQuVoplORBDntqRXj94O/RBzXCuhNT3KS8yIDpISBchQPPRagdSPts=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now, swap_active_head is only used to find a present swap device when
trying to swapoff it. In fact, swap_info[] is a short array which is
32 at maximum, and usually the unused one can be reused, so the
searching for target mostly only iterates the foremost several used
slots. And swapoff is a rarely used operation, efficiency is not so
important. Then it's unnecessary to get a plist to make it.

Here go by iterating swap_info[] to find the swap device instead of
iterating swap_active_head.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 mm/swapfile.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5d71c748a2fe..18b52cc20749 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2641,6 +2641,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	struct inode *inode;
 	struct filename *pathname;
 	int err, found = 0;
+	unsigned int type;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -2658,7 +2659,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	mapping = victim->f_mapping;
 	spin_lock(&swap_lock);
-	plist_for_each_entry(p, &swap_active_head, list) {
+	for (type = 0; type < nr_swapfiles; type++) {
+		p = swap_info[type];
 		if (p->flags & SWP_WRITEOK) {
 			if (p->swap_file->f_mapping == mapping) {
 				found = 1;
-- 
2.41.0


