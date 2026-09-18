Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D68DEC982D6
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22266B0096; Thu, 17 Sep 2026 21:46:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9DF6B0098; Thu, 17 Sep 2026 21:46:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4BF16B0099; Thu, 17 Sep 2026 21:46:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E63C6B0096
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:46:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C35B1C22D6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:18 +0000 (UTC)
X-FDA: 85225192836.25.8725A77
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1551940004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:46:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EzCIRFQj;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789695976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTPhd0YOiSXsclxv5AA53kAUpU9ZSjRHrVegM1KWz8s=;
	b=K7ALaVxtIVW7cHIL7zPRYtFv9jh6yXdOQ1sbZLuoyEMmbDBbBoBiqIE4VLls/ljUNDX9NJ
	VmAVKMxzhDu6dH9jw9icxywCKcl5HMEc0LSWb76jOgRqwlAYhdoIpcakBEE73b7x1jvCZY
	Jw8ybslrjzUDcPC+6jevAXdqr7FfMR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789695976;
	b=4yMbxZbepQQl8w4O27Zwl817ncjT8ZpZqJWjW96G5rM/6x7ypFJquSOjqhxQwAGYre80mB
	kbDbrk3A7sCdgpsouFlpDQm/geirSK8G95uC4U+5clsjQ45WXRU1tJYJg2MsacbeFV5U6H
	/oFGfL3uGokROrVmjaoQSkWEq3lmQo0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EzCIRFQj;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789695975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aTPhd0YOiSXsclxv5AA53kAUpU9ZSjRHrVegM1KWz8s=;
	b=EzCIRFQjYLmCmlbnUmClxixaW3AlOyDFTAnfkN3TRhknGl+y9IaMUnIhwLWr4v7G5e9qr1
	plwETZTNnDcPq6n0M6CVq39teo3udhkKeTHLJG/7RIY8kx3IEAOdbMx8aawb8WqQXzbC00
	s7KTuwSz0UznPUFyIcoMh7QOmjoZOXs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-695-XOMUUELPMGauq2xvyS_sjA-1; Thu,
 17 Sep 2026 21:46:10 -0400
X-MC-Unique: XOMUUELPMGauq2xvyS_sjA-1
X-Mimecast-MFC-AGG-ID: XOMUUELPMGauq2xvyS_sjA_1789695968
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3AB401955D52;
	Fri, 18 Sep 2026 01:46:07 +0000 (UTC)
Received: from lcapitul-thinkpadt14gen3.rmtcaqc.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C436B18002B1;
	Fri, 18 Sep 2026 01:46:01 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v8 01/14] docs: tmpfs: remove implementation detail reference
Date: Thu, 17 Sep 2026 21:45:22 -0400
Message-ID: <0228ab0a273ead9829d372ee7c044eb8476cf2b3.1789695931.git.luizcap@redhat.com>
In-Reply-To: <cover.1789695931.git.luizcap@redhat.com>
References: <cover.1789695931.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: us-V8NQSrxo5UV8OrDqlq46z3_lgvlShYNNHr3FXCKE_1789695968
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: xhaq5epjodsoy7degyzfm5a63y86ohwq
X-Rspam-User: 
X-Rspamd-Queue-Id: 1551940004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789695975-627589
X-HE-Meta: U2FsdGVkX1/aTpu2Y8p4mwQM093moRHG7il6ScK4bOmK/+NLpc2TOtWYVNQ3qKbaIazH6pIfVyA/R42pIWWfcbCT2xWcF5BJAtOHU1BcMVJRIN5AhgGIZLyXx4x+LuacMD2hFc1aKEozwaal5Wssl0flNn4lVI1r/5F5uUTtgnyfTDQLQ75+PVeUmP1CX+WY+GHNt5qs8IU2sEuls3E5Wdhk9qPDgCqVmvUoTMvOspt2z1Jpaa065EDwq4FKe/7rH6+jms7YheJPuEE8xaTTAYSeW1OBkTyhUtiq+MwuoW6v/FnzGLDADhf30itB4/5ZlTD1caSspxtxTew5T/RhObaIeJHv1bhhoJj/pEbDBAKPZMK/TyeTlkSiJXrFxg52jRSBrELLgQSFgDB2YTSvcpo3ts1YMVtqCebE7k3H7fK3bV7VB/nYe00mD6xwe/NOwouBeoHoaaFyKA4yZpRpkXdrgJlvsTO6GRCaNdJioPE85GsU4NGJwVkYCvA9dPTVLoQgLpjiKra9kjB/rATxqx70x+bbOtWc/2GnHSCBbMrHf7v09eyyfMtnzR7/+GEXTAS9UnDkc+yLngb/wx9YAURiv2Urs/rQ72OQgSv3qcf1YMheEY/JHL3nzSeMkVvp4p5AIO9gyCrPAniiqw05S6rKrQWzoY5U3KBWIKKDKYaL2/JHlDOwozkTPu/QKIJXqgrsNl/eP5togQT4VqmjBwBGJBxndiRnoQoac92+gZ/UEzjos8rZPWI2OGK2yjBzW63KdS19TJT+gH+z3xa+KzeJoZCK5CiurHnMe88YKeOOagX7vZb8DI2IX4R5zVMH9yT7h6sITjU5O8u2yFq8CxKvSZW3r3jJ3SycZSt/nPyRN6M5url5qttIpwKaJKaTTjd4p7Gg0IYk3Q3F+8NJ1kNVMh7h2HBJitNEWqobsIygg1V0aMn26K6OvE4XF1qg7AjibW1pMfH6X5VXsdJ
 m5CwRavb
 Jafag32LAktVz/0g+om1dUBjLrgxMVQ15jZB4ka8Q5wVgeqOzDnpL0xPNPjvdLAWSR9sLPOqy3AuwxYEkM5oNlYxly1vShRH8xA61WLzwYzK0rcy9D/lv4tjSaebv5jI/VjZwe43r0DOCM9LqHXnS5IM588StQN2nwTytHfhDll+74S1ddPgZ6Od3rF4X5ZCybEl2OXA+ekfmxVBwO32KtZ93RWToMAQSWETA0a6SVi1tJvMTzPbyp/49kZTF/s/p8+yENr3VFOaY3pmjRYSDcqtMGjIbbKAaZL+jcLOu9X4cqBqZdh+we/oDgdZlSkpqssRWlWVYl35kEB+4i7Glk0m7qJARlFxyPz9ozjQxNgddaamWh02t5JOJScOolNA29wsNjNvgR5fygTFF2vlSxIP9oHSv15rVvjMsatPkaFQp6VfaVlowfx21RuWOYVqG85Q1R3EihV1HhlrT5xGYKh33PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The tmpfs.rst doc references the has_transparent_hugepage() helper, which
is an implementation detail in the kernel and not relevant for users
wishing to properly configure THP support for tmpfs. Remove it.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 Documentation/filesystems/tmpfs.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/tmpfs.rst b/Documentation/filesystems/tmpfs.rst
index d677e0428c3f..46fc986c3388 100644
--- a/Documentation/filesystems/tmpfs.rst
+++ b/Documentation/filesystems/tmpfs.rst
@@ -109,9 +109,8 @@ noswap  Disables swap. Remounts must respect the original settings.
 ======  ===========================================================
 
 tmpfs also supports Transparent Huge Pages which requires a kernel
-configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge supported for
-your system (has_transparent_hugepage(), which is architecture specific).
-The mount options for this are:
+configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge pages
+supported for your system. The mount options for this are:
 
 ================ ==============================================================
 huge=never       Do not allocate huge pages.  This is the default.
-- 
2.55.0


