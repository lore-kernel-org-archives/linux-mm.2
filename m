Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BA75CCFA18
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 21:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 338A78E0005; Thu,  6 Nov 2025 16:29:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292F08E0002; Thu,  6 Nov 2025 16:29:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F6ED8E0006; Thu,  6 Nov 2025 16:29:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED36E8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:29:23 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB1EC12BEFF
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:23 +0000 (UTC)
X-FDA: 84081473406.29.EDB5612
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0FEE1140013
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 21:29:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HtAbrImh;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762464562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+gqNXzwQrUwJSMxzoqSc1CwBu2yw1frjOj1IBpGl38=;
	b=fpLY59twPiIt0UmLOOaRP3BNKk5cTQOP9AZImNLeX3QgW8bD9l83czYTD7lhrJ79HOvCrg
	Mw718K/6bMKfLLi0/BHTmNCVi+dOkDaE0T4L6xx3gJpVoZrGnRLwJK4xNem8El6JKPcupx
	RbBADKA4PhIfiE+7/aG2PB/UhykR+5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762464562; a=rsa-sha256;
	cv=none;
	b=WT41aKnzlBOlItiH99n3WCMFVu6BYyro/H/cjgW11rWqjwOyBeUO69PJIiJOqVXx90NfjP
	N+aPC/rMhIH0nCfRDZPHDeyB4EsuWUyd/d6mKUJDVjdNjpfo13BAt3AnnR6U0UlpLEu7e3
	IkCRhpiL3w7RDQYMu74dQty2twAmEIs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HtAbrImh;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762464561;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g+gqNXzwQrUwJSMxzoqSc1CwBu2yw1frjOj1IBpGl38=;
	b=HtAbrImh01omTfEt8zRF6b6U1FqxEx6bPFWX/a+4IowFeyTae/8+pOEYk16ioRqNvZ5vHt
	t7Cmogvp3vMRl7HRvyhZC4/Fht7d2GP4SFe6ABkuAQ6jWWwdZEaII1ddbWDl8YHxFqswLG
	l2aO6TuNNMPat47SufH+2LyUW7p8F3M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-k61oNvIsPW2_VCtk-ZibCA-1; Thu,
 06 Nov 2025 16:29:18 -0500
X-MC-Unique: k61oNvIsPW2_VCtk-ZibCA-1
X-Mimecast-MFC-AGG-ID: k61oNvIsPW2_VCtk-ZibCA_1762464557
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C3C719560A1;
	Thu,  6 Nov 2025 21:29:16 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.101])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 05AF419560BA;
	Thu,  6 Nov 2025 21:29:14 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [RFC 01/10] docs: tmpfs: remove implementation detail reference
Date: Thu,  6 Nov 2025 16:28:48 -0500
Message-ID: <707886a5ce4afa4c54456ab2ad8dfe5ba0d86086.1762464515.git.luizcap@redhat.com>
In-Reply-To: <cover.1762464515.git.luizcap@redhat.com>
References: <cover.1762464515.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0FEE1140013
X-Stat-Signature: woonm7jz577egqqju91o9hpnwrd6d6t8
X-Rspam-User: 
X-HE-Tag: 1762464561-233100
X-HE-Meta: U2FsdGVkX1/GA3khkXR+vtSUu0XZXCxorEITixYvSN2EjrrmbhWh6VJkK/qA/KyYdkyx6MvagscVust0qSMl+VrqB/191srONhWGQQaRQqb2iBHQmmnxTWMslBulHxyPeTJJYLPfgQszhAL/8LGwH1ByhOBx8iWZ5x4dhP0coJm23CDaOglcaDykMWRNPanY29UE3kQFA+/NgN4p34KBr9RpRV4ClpzWMQOz6v9Coi+G0YAUXRXJq9M79i205HC1KMzB6cQA8OFu1EEmWf9CA0GZt3nPKE8qnEhVq3SmgoVKNsPzg+wYiTbhQJB56n44AwOXe43OscspqTUPtloHWb8AClojt8Q5d4f3/ChStC4IgKWmiYYPAXzxuw0wXPVM1EoFmlsIrK0XDFrjtfiFm/l2AKAioHOZ5GmN6Fz+ynPsQd28zvLqfO3s4M9uO5obENWOZKwjyNZWN/dsvHbK9tid49izCTYCVgTzt1+CT25BiCUUIm5P/3pEBzu7Qy+Z3f8ZPmkI+CNvyQpphwY275v2yoHuigV7muocz/9NiVFxtGIS6zU3ULo3izGz4jVIhd4QVeh3kLfYfnZO0DwpzQ2foUb5+gzKNTKuP0P4UYz4Up3FGTw6nd7KPwxcp9ThWYChhmiuN9kqnTguI8vP98T49wEukg/0D3qj2aj7RXYsWZLE8SBuwj7jb7ZTbPPd/IiITlcMwPEW9IPkJSQnc4Z7lyV1REJ6z32NKFAEkIq+JBaAGNirMforhEr8zMGACDdbL8U0OeJ/7dWCkAOPjf2g+wiuwcQml6FQ4AoODgJXvGv7FLrripKlRtXCsno5TJ1tyby+jiKViQG83350JqN/GJ+kfe3RA1IRTSWMMrTGq3U0GcpszNKW9GWO7/PHaQGrPR54AaJ4T1EFVgLk5MmP25sYfG+58E7iAuw7jtlJKc+BBwyUAMNNCwsvyU4nuU3DmqbRcu1jQOUGN4B
 swx8SQPX
 OLwIH9uZZ+QPuNPs2P13jbH8wfqeRttY93KFvfxnXhx4j1Y6I/YcRbmNI6yg2+cQYJAxR2gbveFExjf/Mizrg1dZ4gksAtQELGXum5KGaGOJ340A/+Vtp/q8fm5VasUu/6UBFnAtjRxpe8RHebBuChtUoRUE8tnkfswwjcigwV9Yn3JwKgd1pvHtX97eO31Imi7bE3PVuH0IZo+YlOP4jzy8vXRDoPTRFlPrv2yk15naZh7kz5dmlHc30nGsncU/AfFduVRqH1qp+OKc5mbyl71lyceawLe/F8reZu9X6yDDu9DG+nASBBD2LGD0ejBP1ZTvN0J8A0g4/jjk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The tmpfs.rst doc references the has_transparent_hugepage() helper, which
is an implementation detail in the kernel and not relevant for users
wishing to properly configure THP support for tmpfs. Remove it.

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
2.51.1


