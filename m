Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48FF8C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0C16B009F; Mon, 21 Jul 2025 21:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D911A6B00A1; Mon, 21 Jul 2025 21:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80546B00A3; Mon, 21 Jul 2025 21:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B62C36B009F
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:51:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 847F912F28D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:51:08 +0000 (UTC)
X-FDA: 83690222616.12.62C8905
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id A260A180004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:51:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none);
	spf=softfail (imf24.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753149066; a=rsa-sha256;
	cv=none;
	b=FKs1vpb915POmDoFMz8EjBdwV4IdJV4+BMshwE7qkE7ycd8GXUanvGmUHc0KuSHqx49yCB
	eZ9ChhurGZ2+GtL77dASosBVcsj3anhpDhVxq7x8oMdFSYP1rmejkukc3lWM4cezsjEFNG
	wjJ5UL/VMp4XcojA5pWrKsYotzb/GHQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none);
	spf=softfail (imf24.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753149066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6gDI5fq4qQM4ol9bGGo8KcOvk2/5IX8Lr2DkoPNISLA=;
	b=SJRRgmXnH+hTf6BgZg3A06XXGE2qRXgFNgJcAIgniqxRlYNEUOz+yMDx2JlovJSQ3xYnVY
	84VW6sQSBcX+KG1DOa9drGXevHv5nq+XszLzdU6x8sALfFa5QxV9mOmfBhcQDPwElxgxBl
	R9ys3y8j/vHbPKl/PtV5QGGDC0/yyOU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629--sIjy9f5OSaEPx7UAIzeIg-1; Mon,
 21 Jul 2025 21:51:04 -0400
X-MC-Unique: -sIjy9f5OSaEPx7UAIzeIg-1
X-Mimecast-MFC-AGG-ID: -sIjy9f5OSaEPx7UAIzeIg_1753149063
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 64BB519560AE;
	Tue, 22 Jul 2025 01:51:03 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1C02D19560AD;
	Tue, 22 Jul 2025 01:50:58 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 13/15] memcontrol: allow objcg api when memcg is config off.
Date: Tue, 22 Jul 2025 11:43:26 +1000
Message-ID: <20250722014942.1878844-14-airlied@gmail.com>
In-Reply-To: <20250722014942.1878844-1-airlied@gmail.com>
References: <20250722014942.1878844-1-airlied@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bfyJDWArDyY2kAsb00gX0nhaAqr9pysxcoYqlzcjV8E_1753149063
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true
X-Rspamd-Queue-Id: A260A180004
X-Stat-Signature: s35hmdh6kfzd3qsa7kp73fpxtoth3n7g
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753149066-678219
X-HE-Meta: U2FsdGVkX1/G0bO6jGlyp19RwUn/GES0OtBsJz+5Vs5JGVus6id0pgLS0pgOSlbcnRhVpDY0t41e74BfUDZN6du1K5gV7Zo8wt1zqGvdCWH76SBGZXAQMPhdHpdAjhRuwtgVQvjSWFYqa/Hq2wu1qqL1mhbPo9+clkn0mU2ptqQdUQCyl5EzzAliLO9eHpujk9rLO87YGu7iDIrLuGA+KmkyhBJ59kZUgERQXB0xlbmyiEsCK9aQ9NMrNzqzutQmD3o0LHreA9q0JMFrh/MkxUYeH5e+90VHQJ0tFqFG7YMNop41nkr28l9hjtQZMmRLOhx30HdITsc8gxIKNlNTJgrjobKqhF1RUpyApRWG7ezehZKRWImNaxCa7Ou1HseuSjF0Mp+xbYaP4rEuOr0OvjoT/HMUrZL545qR7uuED+MNOp+cRE6vCaoIxbcZXMS0+uw1k79UTZQvlYAWxv+ET17AQ3z/VZ108LBjPpqklT99vXsdDd1XrxXaBThZHvjErUbIBM7QiQ7DdrRMg7S0ZqoVy+kpmHmw+Q/PnAOpA8pD4SM0ghmCCwGNP5zJdGAqN8QhJlhFpZeeNSlcaz6q6Iph9ajjGE8ni1WJ7ZoX23kkcuBEKVcrJWVNzQ+/P77462dHROFUZharh3sSDhsBOL0As3G9FzidZ0tyESq6Q9bz8m5SXLYsqTxbnDXc5z8Iz6J6E9FKcXJGlmunqT+WJ8QOqG70jbIApbJze879osKTUgsdEO1oS2z95bpxD/FFRp/w5gnoHM1R2nBpOrdNE9vePozPwg/sMGhFrSVnsuMBumO1M5VcBbmqzjo/G5ISnMsdaoaw0KDBp86kgTD5bNxu/pNtHjeJ3tM+J//BQVxUNdsgUAfo05TH6lfCXbZhQ08mQy1uvGUBlQa0zujtVR89f144VuHR5mIo7Qlhvln+Q0ip8UqI6jmCSjuieXQkOp9uuQFdvLFy/zmTTQw
 HhQPeRMw
 z/67Vt8a9yy9ZstfcGO6aDvUVZ1ka0BvFAFcdS+TtOdlcfwscbAaOs2vHNuoksFK3N2d4RkIUe0ifkA378ocNdL8Mn5Nu7GFKqZVrXcsqLz7dMoR03Z7ghiYwbE4fCw1kJPfU6Xuow2vM84H6YFuLIoitXXJ8wAOVLkPjomYdnN8tG902r4KQSeoMCfx3z0IR/sEOdIeXUFYwObSDg1i3ZrAMR26X01igkzjKBWlpJfPVXqWyFGF5U3ute4RjdrOzkIz8SJk8lwA8x7Zauln7FZWVTfk610PKPQ0RRmH5oEkPfxB2++F+eGlSXmOktOeOll5Ogkb67msUlsUK+tXIqKhIt/FZj8tRcbks/oyos8hzNnChGKOlSPKWQBCpxK8hZphN25TMNFI8johQUkUmd8WAvPKpG6p9TitturuRp0EWIXKsP3Ybv2XZxJm3dGqzmIyZiiVzmcdyX7/S/j76y2Ha2fYzrge/DRcj/imA8PhBYGfAcx9ELKaLcQpzaMGj4S72dCrRJpOXPQ8cLsy+9W+SqxiwB2fkkp64dwbZCWVr9kkoH+Q+wwNiTW81+CW2NiMs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Airlie <airlied@redhat.com>

amdgpu wants to use the objcg api and not have to enable ifdef
around it, so just add a dummy function for the config off path.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 include/linux/memcontrol.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 21328f207d38..55f7ab318eef 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1756,6 +1756,11 @@ static inline void __memcg_kmem_uncharge_page(struct=
 page *page, int order)
 {
 }
=20
+static inline struct obj_cgroup *get_obj_cgroup_from_current(void)
+{
+=09return NULL;
+}
+
 static inline struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *f=
olio)
 {
 =09return NULL;
--=20
2.49.0


