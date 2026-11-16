Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 560C5606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 19:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K6A/F4Ea
Received: by kanga.kvack.org (Postfix)
	id 74F1A6B05B4; Mon, 16 Nov 2026 14:10:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FFD36B05B5; Mon, 16 Nov 2026 14:10:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE666B05B6; Mon, 16 Nov 2026 14:10:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38FE06B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:10:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E89B1C281F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:10:26 +0000 (UTC)
X-FDA: 85441923252.25.96F1EE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 61D6E8000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 19:10:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K6A/F4Ea";
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794856224;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DLgUcDfAseuR3yJ0CiNG9qISzP4xn7ICnWPspQDKS/A=;
	b=Qn34D6x+FiTCR35Ahp22CK++peTBPOGAbj4tVk78+tJvDU4AeUmeRx0v7P3Ox68AiMQ5Ie
	dbb76GYzTVvGaff6mUiNBlwHyuFOmgrUde6Q3fg5da6okYQ3O0kV09F5Sxzu+0xLhhc0/V
	qZGdzDCzq7K5ep/Z8uGByBwvdVkydG0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794856224;
	b=jbSl3SUop5FPE2BrDKl1GHsKSVrypiRvTB6spjD7NU3FPKVQbiHu+RILN38i2wDQ1qd6al
	BtvhGun2CS+KBDE/q+jJOnseHk+rWjTkJ1MQ25JPbfdjhuV0sOUjTQVqUViC4KRk7HSz7n
	B/l0OlDFczi2yokDrYzOrLLA8jGuq7I=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K6A/F4Ea";
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3424466E4;
	Mon, 16 Nov 2026 19:10:23 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794856223;
	b=Qn+lzaq55/2Q5tV6nYN/tTyqEld2IeDc8V2l5+l84WpkMh3xapv59HCn7dlJEtWMYT00
	 3lKQUKkNC09jeOCUT6GHBQfGuekvJ2LiRxDmqpbYZl4k8rBARG6Q63++KlDR0rb1wp5dP
	 WTGUAmalHt5PC0ZW3feqtnkiYLOYC4tXnBZr3cZELNVLqtUXzFEqOGlw9BgfDzzw3gNFP
	 jt8e3CeF2fNAL78wbzl+vIZpwIUxdPx43FKoEh45RsyJlsZrEL6NDVdBk9pHauiAezW4N
	 Awm7ReU3hbzqZs7dNNERhUyVjDvxagJBzzBQZ/HPA/MuGSUNolXrnQwOeVRUFw3snjQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794856223;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DLgUcDfAseuR3yJ0CiNG9qISzP4xn7ICnWPspQDKS/A=;
	b=qYeCGUP2lvR6MP8UXIgpV/ccbFXi0y9JewGnv7Oa9JxcYwbMbQH/ECJmEy32Q6X/zfXe
	 N2ZRr8Crjqs5xVkPpe5bvK85chWVbaIxgE7FyOJMPLwxoqCGCkhgfEtjX8dD4QEoQPSRI
	 Vuo4TqJe97tNzCmhYg1EEQGWpbQlPt44n5N3D81K8TIsoWXFD3zc7X8Nth3l/7ux5+JFF
	 BOT7njlP90p51xdftTEBWCcC1hak+Ft/mxGTZRGh1cIPUaNTALEPEk7cTRyReCgtWHFJh
	 cuqnFcRbL/FMj4Zc3vCxfEbFrZ5Gp/9GaTJlM3tNfpkA+hb/TsxP9mHHHShNhcF4YIQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1E4F61F000C7;
	Mon, 16 Nov 2026 19:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794856223;
	bh=DLgUcDfAseuR3yJ0CiNG9qISzP4xn7ICnWPspQDKS/A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=K6A/F4EaG4jUFZ0ZBS5ziKNbNT6Bh3gRmWk3mXDm0bf9xFHOD0/GVF+9JtSnDZ9kO
	 qD/7gRCqLkdg/IXbMo9a8ffSazxXCc2LVFqqa9O8EDiYX1DciDJJQpg/W/g3memeUT
	 ZF4ZiS3bD+Ca6FiRg0L46mwQvZBP8gWp0KH4dHWQkggLNtDxYWKnUP5hShzyptlWfW
	 jWotLk/ZmfVrfL6MkPCt16DD6J6aRYHkmjTmek4DViR7K17UishjaxPz8KFDwVC/87
	 TxYypk/MsQTUEcxKInOnU4ShL1F/gxkqpuG/0V2fyupT9ZwmSh11OlkAjsYrXVXW6a
	 BstQ9pkwqiHiw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id AAA674A5A5;
	Mon, 16 Nov 2026 19:10:20 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Date: Mon, 16 Nov 2026 19:10:08 +0000
Subject: [PATCH 5/6] Docs/admin-guide/mm/damon/usage: update for
 sz_ops_filter_passed_last
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261116-damon-sz-ops-b4-v1-5-1cffe7227e6d@uber.com>
References: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
In-Reply-To: <20261116-damon-sz-ops-b4-v1-0-1cffe7227e6d@uber.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794856219; l=2099;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=oiIYUzWQ/llW0+1v4VIsDSeWAi35sgosZXSLIgAe5qQ=;
 b=6ld5QzPT/dJkRlFCAL2FvutDAyfX/kfm7BgZrwH8jaVtlFk3UldzuyTjYS4LsQkmatBaJIsmj
 pQpun2dVtjyCpr7x1upic80JQhivK9dQ0KmDguZOkJt5CVMwprRvDT7
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 61D6E8000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fymjdmcoxwpfzooinfui9f3j7sd6tujj
X-Rspam-User: 
X-HE-Tag: 1794856224-492359
X-HE-Meta: U2FsdGVkX189RMmXJ7I9wD1uVbnAr/Q/9d7CAKr4iOnSTXawi0F1LIPFBBALAzFbEY0cNtaH1kSl4Y2+zgt4B5EatY1OhiQubqPXSgUOWDoF8AHkLAHIDWO9SJUAIPuNJF4uy1mUdOMXhyFd+2L576emamOzPCZ5dsuMFyK11/zpkaQVPQi9YPnxrTF7Tmp4Z9uHS0KAK4x1AJthtJfwkNBZHF0AcKoQeiFxCJilam1Rf5IB6xni+6ezkMH3JssMro+5L8525X/zW3stsh9ynGC9SbW3BMMGzHmcA/FQbFmr9e6gszueRi+jFnU0Ld1c/u554fG1av91jCalbsYcJ5GBVWrf+R/IOgVZL9gbKZo2WQKkw+dkIZtW0Chgx108wPxZqHdnpmTFiYC8Jnn6Q36AvTFCswFzUnyDsWKDGLxADMduA6LtLQ93T/M+lU/yxVJoHTEgvH8xe2G//t/4RqwAz02OvulW61/u6FPvB1+HaVJs/xuQzB/tHXJh0pbhHNlfroDv1ScD2f2RA0ykbvtCOaOsWdLR3oAhC6tWYq+vNYRDEwjuNpoYfeWnKvHQeS9uKAxSO1OZ+Ag4Ly9waFKEN3+i//X1/g/7MlT73zzVEyEAYr2o2kF8D7I1cfFEDmZUfWhPG4ffEiLG0iVY22i8N4OINN5dQ9oVkh5CCbosvEHYU6N/rEaO4P8JuMF3NjejKS/H2AAR8adKf5oITyq4SDLAiBhlGYKVY9Dzaw2+moB9FoqhWED0rHzLw9KptfPWEPatclSoga+KT7eGmAUfACaoy3L0PmUcYMKBG8KEy/qE52Q6urDa7bI698Rzp5K2wzJVhU4fBrMZs/qHETnpZbtDjXtoInhJb8fHxS7aWfM7urEssg6+/wjVNS6CnhXuQCkhyWwd6NoOASOWHkZy8JCISgVGEFNkOfPZEnl78Tf4NPdufSz1IHe7rBkAzbPpo83pRhucqr9Hgq2
 t590Zgv9
 lJhGrIhvWUiBhMdGNCi9TMcaU3pDaOnbOp3fa5ODNTnNnDcMK+cmb8jTsHJuXcZfonf+Fg9vZ3hkt9h4QcMVprda3Ol2iGzFL8loC4gj1Ic3s+Al53YxYZmTzimh4/Gi5Opm0ZPs1gJ4rrPX4yMXMsV/Jtot06fPDCgk0cRbiR2kuiZQQj0NECDrEK1J863EuvxQTiqRYZr89l/nxFXiiG7/8juDqVyPNXPinDzc+84kcy51m+cQLMDdyw0DA0h9ZjhI8GPr/uu4MuRIIzJ39i2jSx7ijXwNP9ZsGKieCB6qtuop+NpWSMBsLuwLvzCCMPoCpOYmjRgyxs2Ymp4JHvK898j2eVfSSs4FWGK946WN7qxJhWX2s9fTk5NItEw02XWNKM2nbZnzi9764r3lVjSZBB1t7pJeAHj/Sc5Iu1/7QdrtBgs1mC1Pcdn7qh5EfDQhsp2GZY8BJGfks788llm2HKWo16sTJhMB8mAn+TglJZyDQWsuu+6/xXxvkvLws+uu2xTFq5s4CbQIioNsLvWYSsCaxmFI6WsU0VnDdZlBeX51lwXemZbcYjomHJ1safZqZxve+y7d89DTC6U66+stvNd31WabflsCcER99HKGfCsR97Gf3lRJpGx5vEKi4sSpEDHJ02L+DRSBkPebCBU9uoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

Update DAMON usage document for the newly added DAMOS stat file,
sz_ops_filter_passed_last.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
---
 Documentation/admin-guide/mm/damon/usage.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 6093b1c8fbfd..c0101a68a033 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -105,7 +105,7 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
-    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
+    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,sz_ops_filter_passed_last,qt_exceeds,nr_snapshots,max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
     │ │ │ │ │ │ │ │ │ probes
@@ -631,8 +631,8 @@ online analysis or tuning of the schemes.  Refer to :ref:`design doc
 
 The statistics can be retrieved by reading the files under ``stats`` directory
 (``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``,
-``sz_ops_filter_passed``, ``qt_exceeds``, ``nr_snapshots`` and
-``max_nr_snapshots``), respectively.
+``sz_ops_filter_passed``, ``sz_ops_filter_passed_last``,
+``qt_exceeds``, ``nr_snapshots`` and ``max_nr_snapshots``), respectively.
 
 The files are not updated in real time by default.  Users should ask DAMON
 sysfs interface to periodically update those using ``refresh_ms``, or do a one

-- 
2.54.0-uber3



