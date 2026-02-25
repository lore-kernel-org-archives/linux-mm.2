Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4107DEFD208
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:17:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22656B00DF; Wed, 25 Feb 2026 03:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E34F6B00E1; Wed, 25 Feb 2026 03:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F9C36B00E2; Wed, 25 Feb 2026 03:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 770B06B00DF
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:17:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 318E9C1EFA
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:17:01 +0000 (UTC)
X-FDA: 84482273442.21.2BDC5D9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 406A7A000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:16:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XhKTmIkD;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pa4Mok84BgrIJ096oguK0x0r8biU2FN9KdJaqHRRdYY=;
	b=YvhcTcIBThUGH0bLu6wJqQBk8j1W/8pIDvtz+FEe3MTGpT+bmWUPuaU4NrockG3u1hr6Qe
	WIoPSxLDbkr2zD3O8bUqLXuUYdH8CLn795jPk9Gd4tCOZxdhg1rKlR4XbzViSK1dnMkTXC
	7Xbi6CIe6KU4WQTq6LaILvJFA566DMM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007419; a=rsa-sha256;
	cv=none;
	b=6ZAOhKqRCjN7oeWIgRVa/hs0zNivLbFgmW/L1QnpJpMfcaqj0kztdZq8/sTsNu+ciwm/Az
	rbIQ0J+tTP8c19hBqVHItq5c4RzLXsRuS4H6hU0h+3AZe22GAmLeoD+/e10qHADAU38LoG
	lFsf5XhClmunjYusVtm0i+0w4D308oc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XhKTmIkD;
	spf=pass (imf25.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pa4Mok84BgrIJ096oguK0x0r8biU2FN9KdJaqHRRdYY=;
	b=XhKTmIkDcg2Fih69qKUlZZuW7tX3nWUjghiA5tNDf5Syu/wqJxBee3R1avIZzUKuAws7dL
	rDaZAqGA3io1qm+VL4Y2Gj0vksMPNNW4WyQ+wsltrm2bUT6pogA0vvd53wn4ZtD6UClI0K
	VQxmmTnbOKCB8RMk7fwejqqg71sJ9N8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-199-nAFljNsZOpiYJ57hUOCZnA-1; Wed,
 25 Feb 2026 03:16:54 -0500
X-MC-Unique: nAFljNsZOpiYJ57hUOCZnA-1
X-Mimecast-MFC-AGG-ID: nAFljNsZOpiYJ57hUOCZnA_1772007412
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32EB918003FC;
	Wed, 25 Feb 2026 08:16:52 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A81041800351;
	Wed, 25 Feb 2026 08:16:42 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org,
	andreyknvl@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	linux-kernel@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	linux-s390@vger.kernel.org,
	hca@linux.ibm.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v5 13/15] arch/um: don't initialize kasan if it's disabled
Date: Wed, 25 Feb 2026 16:14:10 +0800
Message-ID: <20260225081412.76502-14-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: m4rEfFcuf9cJrEdq-IxuPbJSoTzjj5xwJ_oZlXjFYkE_1772007412
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 406A7A000E
X-Stat-Signature: mffahgtmnj58ha5166bd1wt77igzmjeb
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772007419-303049
X-HE-Meta: U2FsdGVkX1+xuGtssJVTZ7tWJSiVc76YG8VidYkJ7QAoZuLNV3D8HZFCioavX0x/2p4RWUWCoa0R9FS8VkmUexMENHQSpK6gbN+NHjnE68wk26K2bF8ENr4whTMoDZJp4gdyV9BqGY+31/ytU5qdU9S3BHmSAgNjzEb8QTi7NT3l7ZlP3mBUQL9w9sxYjb+M9kZcZ7XeFqLbyxc0X66qA8syEGF9tPXRH0kP2U6Kb6Wb4FeWTjZgjTy4J5XQuNGnsLNr+rZR7v65yJkMx0mMgche2r0zdFy43JcAWf4s8IxmUbMzaCK9akB/kwqDxxI9XzZix88MU5Zz+lNBMQDgzjBpkssZm2Xt8m/SsXQI/m6JOrvk5cHvkC5pTTziHy037I4Vg00wciFwCzPbu8SSNPbijsyEKdJ8RW+eyY8Q/YshLnqgwjb2zFG890o0XWhKuGOQ4YTAAvhD5fxr8VNiBMqXVqfDiJgx/IOdS6n39xSMotM7wyYgFo4HG3Re48xMwSjeSEcj1TcWeDMzeS2tyjCH7JLAmQryubY9XpA3E8HodavpfwgOyIgeYJz0OGHYU5xi4m+MMuGvLjppp0yZfkJGclhmBEa0GYmZeunFyqV8InEJCTcDygXWwAKoEJSOG2H9Gk5h4QSEcxfc96B2fzYUVpeeeQ7+dzPTXiRiTrm+k4F5YSpYf8sE5gaIcBjYCpH7A6oFX7uDTrwYXNYyx/bAlT9xpJblayIVytAjWwv8aD3xMu6xE1xaS9sFHHDpRGq9kEeJ339Q2gDDGwKwoHxEQRtF1ZV3lpU5EjOsgEQdNHnG/WnDHydeAnfvj3vwXBNyRxbXPmNw5KKItoxAZ6PlKsL1qwUEtGledOXAMht5Uo13wxpuPkzZZ/4Oikg5vjm3g+15/CFqrYSNUn/UtQ/6RzcNywmAZ7mxKcG0F6BAq3UUHde70vgxJM6UyiOjXHrd2ik3h2KfmatASyR
 4wNV3TOQ
 PbxPCBmQow5E7+6f5WL7yEg7pB6x7bBbgtXMq0gqCdhRDeJ1YHICKy+rDzn8Lb4VA9vcyX3L+qTIgcm+R76OOU31Xlun3GG60iLGzRdJEb7+QD/g4ukmGpBueVQfADGGoBOvZ6ckOjk/Ul3AGt8fKkTAOTwKyH/y17l2pu8yczh5+YRmPldX8fVQI/lqvrVOhNUAxHR+WZcYBDzVYSmLM8JVsBH5U6pVh+DKt/SCSVXTbWHZ7mpS1dSMrHFVXp92RfyDOcD9TsQXUSj6UI8eq7NMYvnogz7UzeVP5t/CufZ2XMo6P7q0uRLJnUHzRt4pdW0qTvk76qT5etGuRgpEynFOXn1730tX6gIHdzq7DXKw11jgjAEqz8dabyAOTbnIw/2jeIomN4Q1Dydof8EQ5GYwAX8X3uVBmWQmLEUOb7LYwwkJcTeFOnpropBfwbHMkePayViNAcC87hG0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here, kasan is disabled if specified 'kasan=off' in kernel cmdline.

And also wrap up the kasan code into CONFIG_KASAN ifdeffery scope.

Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: linux-um@lists.infradead.org
---
 arch/um/kernel/mem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
index 89c8c8b94a79..2bf858ab35b5 100644
--- a/arch/um/kernel/mem.c
+++ b/arch/um/kernel/mem.c
@@ -62,8 +62,11 @@ static unsigned long brk_end;
 
 void __init arch_mm_preinit(void)
 {
+#ifdef CONFIG_KASAN
 	/* Safe to call after jump_label_init(). Enables KASAN. */
-	kasan_init_generic();
+	if (!kasan_arg_disabled)
+		kasan_init_generic();
+#endif
 
 	/* clear the zero-page */
 	memset(empty_zero_page, 0, PAGE_SIZE);
-- 
2.52.0


