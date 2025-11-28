Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36372CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82FD76B0026; Thu, 27 Nov 2025 22:34:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0676B0027; Thu, 27 Nov 2025 22:34:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0466B002A; Thu, 27 Nov 2025 22:34:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3326B0026
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:34:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 06767140280
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:09 +0000 (UTC)
X-FDA: 84158597418.29.D2DA76B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 474CBC0014
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:34:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F0+ZiwjR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764300847; a=rsa-sha256;
	cv=none;
	b=JApk6DhRjFhl4z+97oIJCDJPDZ0d9gO9+KAIro0KuUZK71C2VlcvBhSmKuEmtoRlvjGbXP
	STcbiBoSoxduipLX275KtKc4x8F2WRbIgPmMB4gvMdmoaeK0oBv2O7jrOaLeN2XSSCHYQA
	2mEmpeCpVBLHgMc7dPmWAHqss5Qkm70=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=F0+ZiwjR;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764300847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/phgffaeGBCaBWv4I/S2l048MgyIWecznBSacZiKmGw=;
	b=5PGjfZNtZ6lqMDgDQsUm2ntlBGfaRwdCcQC6wt3qJm6GJI+eytIS3VOuz4uUCEE+dENJ4Q
	HBi53FSblSvitdIT3e8kdBqu8UTI7r2MwV9pK3k6xWGZmtQz5Ez2+HqAritiJs5fhVocna
	NLE31/oyWOaOAteq8hkTr43by3DpmhM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764300846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/phgffaeGBCaBWv4I/S2l048MgyIWecznBSacZiKmGw=;
	b=F0+ZiwjR4L/C+i4TCJVbnM+ekz96s66IXvIsCmjj5yuQSRBdc8QQ44eIMFMUFIUCHeRrLd
	UMBaVeNkvAzga83DUKtH/EqxAcQpqC9Jc4JrmZk9t67gGsO90kEsUKjYgDmzVRkwoZYDo+
	nLgEG5rUJzND9mpygbbJ1vpH9q3v2I4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-591-g_ehcwKEPAiWXVHUWxLKOg-1; Thu,
 27 Nov 2025 22:34:02 -0500
X-MC-Unique: g_ehcwKEPAiWXVHUWxLKOg-1
X-Mimecast-MFC-AGG-ID: g_ehcwKEPAiWXVHUWxLKOg_1764300840
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABDB71956094;
	Fri, 28 Nov 2025 03:34:00 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.112.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3203D19560B0;
	Fri, 28 Nov 2025 03:33:52 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: ryabinin.a.a@gmail.com,
	andreyknvl@gmail.com,
	glider@google.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	elver@google.com,
	sj@kernel.org,
	lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com,
	christophe.leroy@csgroup.eu,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH v4 03/12] mm/kasan/sw_tags: don't initialize kasan if it's disabled
Date: Fri, 28 Nov 2025 11:33:11 +0800
Message-ID: <20251128033320.1349620-4-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-1-bhe@redhat.com>
References: <20251128033320.1349620-1-bhe@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 474CBC0014
X-Stat-Signature: ipp5xgsyodaq7sycgdi959htapu3wjse
X-Rspam-User: 
X-HE-Tag: 1764300847-952429
X-HE-Meta: U2FsdGVkX18QsdSLe/nThpN+FNIOKKFfnWpbUvVtguAH1K+EaRSYyWNv09RmIJQ5PTIxjEoKXIyx+qyeEX3T/uK3maZBu2qmuaXXaPdhtjHX62sf9yl98TbGzMs2zI97a0Pzu6IMwvmmn5DVW9LyUD4LWNrsRWsjxx6Ul9jtNmqsLLNA4x/qhfqVuvWJT1+Xmn//MPg1Fn7sxAxKJkhBlLzxjPY3lvQRkb9HCpfBMFbAnMVZZRjEl9oqZFet5xo8QmtkwEhVo3tQbRPYcSPHKahV3eO6vjSAb7QpQRrLvlhd0eazKvyInsOzPFVmnYRNQCTlZZGsZbyQpo2M8zIGYcxpdlQLltMZSQYYsexUKcgK7XDv1K2HVm/Fu+31LNrTN+90dC5Jc7DGoojZQduvfcJzR0zjhG/WZOUaeXVxKgLjGvzXBh1gownFVUMEVPWq14GU9WWfuPTsoKaNoYzZHcMEyCixtRiiw7amzWust8tUvvB3moxrmnADWZVfxxXr65xeMtXtk24O/GeA7NeNxKx/wHfSHSjcAE8UrI1qb7lp8813aqNsMv9jcr6j6V0O5OrCwyxH+oSUUe+FF/JqWrHIoLTIJblte/od/TuPczXYzLD3to2AAlXUDHSUuVtZa8dq9fAP2H8UFUpbg7M0sqRP5DA0M+BmvljhLK9UhynqAfREPHSBJdlBVBM5zcIndObI+WIw5Em06wPHdUb79uRFku+8r6ONzC1CsDTKF+d66BIEiSe1R8u5vlJSObJKypRKLHpIusVbTJtI1D1QVOc4kXmiYM/5v9xwtt9mLRp587w607MXTpTBZvziovBmlSEGvUlRO7FolUtgMeUgjWAVv6Jf14MzkQYH1lVv/Zk9SwAdfDNgsuSl0a4twrcnOYUDMUBG614wc6ZE7+faAKiFVst4eKW1npl677DdnnkAonuGe0xRnuD+tKpilijk6pEv65kAai0//S02zIO
 +EMOHcm7
 +ZLyJqNfIdkbYH3J8vp3ttdFgQIWwOp3DealjZ2AtsTQGwb33KFiu7islLbU5KwHPbRNJdNxu7Fw0NVDdlCz3RD/Xyrl0Nd415ULBmhUp5UNpuCdsdW92zUmfkSgmBTlvQ5ow8caiFGsBE0L3GueklZHs8w2pZQCXcRJKTG7BGWudx9yE8WYKgVOxHArxsxwfP5591mHl5XjKKDJMJIRhVqwilRTSY8MaN6chJhHXMku1F4TkhQMMsYjyXXjJvsjzdi+jJ3kkpzNi/sdXQHIaYv4ifW2wF66WxhrhIIKniNHmLCzDsANwBL3nIXzILeHWCK5jXFxYUDwcsChgzCTYBwDEMyqahsP0rcqiPjjNFfR5ifT4EsEdbu2W5KBOU9j2dAJ+HbCzDk37rtf8/RWQFrnUEUu+seJms9ok8SFkAkTOuGOrgwRyB4Y/carusv4+ZWI3sem85yuhuSg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 mm/kasan/sw_tags.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/kasan/sw_tags.c b/mm/kasan/sw_tags.c
index 6c1caec4261a..58edb68efc09 100644
--- a/mm/kasan/sw_tags.c
+++ b/mm/kasan/sw_tags.c
@@ -40,6 +40,9 @@ void __init kasan_init_sw_tags(void)
 {
 	int cpu;
 
+	if (kasan_arg_disabled)
+		return;
+
 	for_each_possible_cpu(cpu)
 		per_cpu(prng_state, cpu) = (u32)get_cycles();
 
-- 
2.41.0


