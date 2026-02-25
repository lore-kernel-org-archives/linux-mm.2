Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1639EFD209
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:15:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600C06B00C7; Wed, 25 Feb 2026 03:15:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CAE76B00C9; Wed, 25 Feb 2026 03:15:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CDE26B00CB; Wed, 25 Feb 2026 03:15:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3A15B6B00C7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:15:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB62113B0D7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:40 +0000 (UTC)
X-FDA: 84482270040.22.02B23B3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id C25CCC0004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MLKA4wan;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXwY0Q2SJZmWL1WR2SYctHtbhbAGYnU1QS3gfwuZnJo=;
	b=34Q7RLCgbnrzrhluF6VTI8KeWkNmzV7XZKN8JBtkJkN6wUaC/svJGyqxk7RrgWRV/TCYUI
	dAGpKkKIbHIChl5iLp0G+mzq/+OU6d8SzIy73xJgkWyuF22b2aPND/3gses2XULOebiy5+
	cNbhg7W7TTmx5DgboLL1rs0fJthKKIA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MLKA4wan;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007338; a=rsa-sha256;
	cv=none;
	b=L4iSHageOeXswmKfxhMjHyFgRwHplfxT24m52Gfo4yuN5oqE/TZBFw/niNS0QyXJIHEZaj
	4Mcrb51O1OEjysvkVHC8Dh7l7hpWGwFKg+6Q5o3xt2PvCq2jdoe6p7a2m/6zlLcTQvNG/N
	o/8UlWIFDvoaKhdE3rVuYU6OftOoTqo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772007338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iXwY0Q2SJZmWL1WR2SYctHtbhbAGYnU1QS3gfwuZnJo=;
	b=MLKA4wanB3tX242ihaZ0q0PbSnRNQAFNpoAx8qIXuS3HYDGC2F2cRk2u/iqsUIaiJcK5eq
	7xzenVQsnds+21K+CjyL+cS+GT5296h1xFUYrJCAm03M7TJUg7Qx+GHqwqHRG/Fn20cETx
	gkFqRDpEGIItTJP4oD2E63672hwFakk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-338-W_q9ig0KNGOLXjAkoHCtsg-1; Wed,
 25 Feb 2026 03:15:31 -0500
X-MC-Unique: W_q9ig0KNGOLXjAkoHCtsg-1
X-Mimecast-MFC-AGG-ID: W_q9ig0KNGOLXjAkoHCtsg_1772007329
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 989F01956068;
	Wed, 25 Feb 2026 08:15:28 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.55])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 03B561800351;
	Wed, 25 Feb 2026 08:15:19 +0000 (UTC)
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
Subject: [PATCH v5 05/15] mm/kasan/sw_tags: don't initialize kasan if it's disabled
Date: Wed, 25 Feb 2026 16:14:02 +0800
Message-ID: <20260225081412.76502-6-bhe@redhat.com>
In-Reply-To: <20260225081412.76502-1-bhe@redhat.com>
References: <20260225081412.76502-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: hCiR-Tvb6XbAmq-Eg1RT4jYWZEEVbqD7ml1ekDgebC8_1772007329
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 49potmonx5fc1n3r8gjkc6qatraxe7p3
X-Rspam-User: 
X-Rspamd-Queue-Id: C25CCC0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1772007338-544326
X-HE-Meta: U2FsdGVkX18FwcyzoMG8fqCtVMsSYKxsdcVZ3hlYcSS1Ii2ZSHSzBPv79Z5QYO6ufVaYJ0bWpiRsffQTc3pevP2UMqV3QgDzYKkZhWnDJEhZw9ISE68IQHBCj4VqHuZiy1hpCTkMeH5FJhTDZrZ+giYidrsdZv8M4LYgNO/WKsJI8QZsmNlZlYAciRm9FEk3FRnOWOvcGWj0K2Piz2FB/F/2ByOs19CZOWWKclXxI0wCqcuznHZpxxrLcTwYKisetnHasz9+VMYVxjG/SgEpXU+ggNapDyYYazAEAtaZJRiD3JR6mo/3c0LcyMyiTqsSNAMDwd+0Q85BdGRwhp4TflHusMjOO9q6Tirv11Wvp/NuUw6AHxP3Jr7GxJUIlQxklzbrTaJzhcexlQyaF6DG0pY2G//CrGJ2KTnyzKs1PDrCGPBOcMs9CzHTRMMKM9qXs/79fUgkzQ4iUELVmP1o872HrG/eHXwAcFEbkIVpjrraeWKdRW4+qAo9ps/Iv9BhBO2agwjinIeh5mCKzcMzFKFX7qmoJLqZJO8qoQxm7vRcG5m/wYC6mGRSuxLP/cYH01ItocgJ8WMveldiFKIg76fuhH0hwluH6baKDjUellLQuYny8f8SaUa3W5Y0qP0sQUWOhXEiJWsL2FHXrXy6uek3HoQUpHlG2jMNcTlTB7YB16mMeXC3c+VecunKLSPEXhoh9BQcCX76uqWeX/WYFUGftJGRCCgC6FdZtiVzc3oi+Upq+ntwBQmPFrsedTJcZzWULTXrT/HQ4VEKUG53tg3yINiNKPHHx82O49sEChqUqZBWFpSwlfb01J/+/l/l+bKIRhnBMebHQ07j2odK3jk4w/+9DyRxfumTdqLL3BsNyc14OtXOWjaohw5EPFwrmBxem4lBx2u/ReKizLvU87Q/DtKPQzWPTPQvNwFo0BJcciDNfBYQ0efotWlpH/03+QT3h+WlRr9hH1ABjWV
 f/XYWKyo
 g3S78Pv81SQYnoWFP3STBUvy9EcnxtT6nLVGZveNm+mGne2MCZnthnJomVx3QamJg/PXZkKPV/2LoJMDeLfJOCzubMQTpdYM29Ftcg+DUlsCr50BBMD6pRSLm/VH/KO4EJsXuk2k96VUwqrSqfKzUTf8+1Rh+38cWPGHkm2C/aLhhyoQPC7oT3lplW6+rBIoaaWUPnLcFEySmBTsyMvb/0GT+A173BnJbhVcHv7tZrQ+Mtkh9USYmCHBtaoYi9rfjy1ITqTLhfbVmlZaQuHgYC3Bn1XhCZRQKG7BXLZToULaBWwfaV3lcpJ0AcN6baWaVedfgpzidwRHtux8CK4SUOGHjxYavF33GhMardrw32+sGYoW30gKIxBBIZfUAyyZkgqz/XLCBXfISKIlVFLEMnqBpztuXUY717AC/cy1tJcbP2w6U4kAYtN/MAZac/sKykVnAes7qgB0lxcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Here, kasan is disabled if specified 'kasan=off' in kernel cmdline.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 mm/kasan/sw_tags.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/kasan/sw_tags.c b/mm/kasan/sw_tags.c
index 6c1caec4261a..7757b69b1c86 100644
--- a/mm/kasan/sw_tags.c
+++ b/mm/kasan/sw_tags.c
@@ -40,6 +40,10 @@ void __init kasan_init_sw_tags(void)
 {
 	int cpu;
 
+	/* If KASAN is disabled via command line, don't initialize it. */
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_possible_cpu(cpu)
 		per_cpu(prng_state, cpu) = (u32)get_cycles();
 
-- 
2.52.0


