Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69510C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA97A6B00BE; Mon, 31 Aug 2026 23:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E322E6B00C0; Mon, 31 Aug 2026 23:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9F86B00C1; Mon, 31 Aug 2026 23:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9886B00BE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:12:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07351120303
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:12:56 +0000 (UTC)
X-FDA: 85163721552.26.82FE51B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0CC06C0002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:12:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cnBuy2li;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232374;
	b=FIysDtiB4OGGFIpAGLD42883QthCVevFsls0ek1hpDEE/bCyH3FKvzKbRloz7OeDIWumTW
	jJcbFjSubi7Vc6Go5ZiHdloHMj+0wSVCOx99FnTHm5U41r8QH0h9Ych6eWLaKyzI/pFDEW
	Bym0I9zZeOXwa53oqTKPPTAdq9t5ank=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cnBuy2li;
	spf=pass (imf10.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTPhd0YOiSXsclxv5AA53kAUpU9ZSjRHrVegM1KWz8s=;
	b=OZGMJt39iwbFOfF0Wk9bq/CkpgBqGChfAt3PL3tcdJ+yq+WO4sKjcyinPoeamnVWMwciNi
	fXDUuU17SjGprIrRj3s6Wm+5cQ34e8z6o/zX+BzgvVwB8h0oNeb/D0Xy+BvltWPczBYpcY
	iB7GnlRBKtKT3NKkJQhdofKUMKd/ims=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aTPhd0YOiSXsclxv5AA53kAUpU9ZSjRHrVegM1KWz8s=;
	b=cnBuy2lipNHj7wMV3uZDnYyeDlyK48Nt1HsPubUV82RHR7g8XhwmG4Ael5W+POC7OKW9kq
	R8os6jzhC1Hj5+3/iZ1v1SM8Ukr9D5a2yrNQfioq/4UTi8tjwJh4RqKdrlRcD8+4WNLPDA
	0YJhsGCHmbTCE1iurIBz0f4xaT7bnMs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-298-w99-JZioNOeppOKV-AZtOg-1; Mon,
 31 Aug 2026 23:12:48 -0400
X-MC-Unique: w99-JZioNOeppOKV-AZtOg-1
X-Mimecast-MFC-AGG-ID: w99-JZioNOeppOKV-AZtOg_1788232365
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C86EF19774DB;
	Tue,  1 Sep 2026 03:12:43 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D042618005B7;
	Tue,  1 Sep 2026 03:12:38 +0000 (UTC)
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
Subject: [PATCH v7 01/14] docs: tmpfs: remove implementation detail reference
Date: Mon, 31 Aug 2026 23:12:05 -0400
Message-ID: <7205859de9c2e3bde0cb1d9539a3976bd4b31d9e.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: CnTm7Is7FSwKEdde5pjab8VDYmyLCC0CO2T26O26eYQ_1788232365
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0CC06C0002
X-Stat-Signature: 189s9h16ro9tix1a3m9himjwpu1whnk9
X-Rspam-User: 
X-HE-Tag: 1788232373-645034
X-HE-Meta: U2FsdGVkX1+GQo3HZCZoM5cPOAglsfnQWNarEu52LuLOvBwcO54lp4Y3nHrFwUtbyDyFortN7FFWw7J6CWb8V6ZEiHCcjBb1AmqXa0dgPeynBX7pYrKhmZEvio9b/JnFu9NK8WN5cneKpzxcNAr/eh3SfiTccjHIi0J+MR/hOjUfVHcoi4FPTCg3xM+7R3jNyt/bFycShNYEW2PEnuSBWjv/acrb+dqziWWFY2R6pg++e4GemMGN8v+mvSGk9VXtC/w1XCXRVO9C3A9dfLMsYU+FVU/P0KPSifDd6mD3asz6sd4xLAIWrZarmzsls4EsiNN9JiHlHMVs6cQoEC1PKJ+VJznZgzCyocOm2Bf1qKIHvs/rUSy3XkDrVhB1y00DhvinsJUg33DGcPUHESiTjJIuup/WSl+iqS6l2pIflah8t24vjfyMYovecgRWVKsVsOm2wKtWonPD0ZEW0cGHnMRJ0Vct1WC7tk2teZAmA3XXd11qQbTF8p3gdtk9TkT2cTc0GKLZNwCkedkCJYLkpPlC8h9feOnkDy3+NjjWyQbEbFe7vIyuMeNZiIWcjvj8B7ujGgJIPUtDdSE/B/eniA39eCVMo4GlVyMSOor92Gsee5+e6crZzzGpA+LU80ujC/91ZhpsaxdafFkbsOksV4qpAflfiKtM9rx+rE5inXHB0zqyx75jWaRIKoxoyIgKlmjgsiqP5cgY0T+SFsJ+ioWONrIb+1qv7XBn/ZMI3LiLDvpVrhZBELgxUfq1Fig2zWh7maEnCPXHD0HtU92YhRI8Mm+ZUV95NS8Brg/OxAX2P6O0scYjV6iE7sQtLBgCQPTj+Wr5hvC7suK2QXp6aTqS60Db6oj0RUSWowFeX0I58WNliQpbBeMmvxtA/UKssRkwLTLIylTdOHkhuzgxwF2S/kNH+fX+lFVMv4wQGxy0i2gr8lIKWPngU2LdqOZM9T3jrAUhhk9Re7BB3rO
 SGTFOZBR
 xLtZLSomY9qsgwoj0iUxQh+HQOIviVDNfH+4+yrTyhKhcZov5xXgOOtaqUH8XoWYlnrlrSjAlHq51Pk+JmCS75MufeyEOGiMPalX5a2UpNeW/8Wru2PWAHD1pOf7yAE/hoou62NPQAAHgsjOk3RbOnslKefb+FjgPAwoCXF14jznTSSoI19VB9j+gCfY8meVEXz0AlX40iEozG7C2XKAWZV84gX3ZllNbaF899+yCcsVGUbHrYmCSE1Tj3EoUITBAtMkDq4uVSIdlGhKs8yM4MzEMtzBGXMsooP/jXODBA5m/eWCZWzx4NYcsuqsULPNoxdRD24ejTrMSYAMY1AxabQB+SB8fQnVRGqgFDxgiwTJUuxfNjdBkyqBOPeRdto45GXdy3K2yNq1Y4WUWJfLaKNULHXcs5GGLUmCXV+17eLAnHBPB/dtTiMoZIBpmUDCLO+j4jd7Itts2jVZ21A9Ie6PGcg==
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


