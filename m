Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92FCA606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PhbAvZhP
Received: by kanga.kvack.org (Postfix)
	id 37DA86B05B0; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B806B05D7; Tue, 17 Nov 2026 18:23:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52BC6B05B1; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 932896B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:23:13 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F8A780631
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:13 +0000 (UTC)
X-FDA: 85446189066.30.EFC3D38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0DD5E140007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:23:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhbAvZhP;
	spf=pass (imf09.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957791;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cue/7N2uA7x0b67B8cg5P6aqtiRdNdHZ/UkP/gcIMjI=;
	b=fX3XwhnLL471ukoJGWSJ+QGi1tgsOwUUqjXo3PtQbTlal1n/dAhl062EBuTviAdfLAGQXa
	HATNpePJSYwEcKVuTDLlbAsy9OUWmZPNrbiAzbzQNcpSrz1zUwzqMwSDpd03BjuUczoDVf
	FXn4HTrozUKdM8JuqyMyrHd+JkB0dck=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794957791;
	b=OBxrH0Ih4DsX7trWyQT7dnawprzBsRXAtxw8fy1KF6mG0JkU+QQuyhpuGLwhlQ5Xhi8IRG
	xVZZudSF3QlIw0U2bxf7giSX0LAxLqKKZO1aY3tfoJEJRAji9AEpUQy1ALFBPJyQE4Cxxr
	lpyIegCRP8E8atrPfx66AUFkyzBwMDk=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhbAvZhP;
	spf=pass (imf09.hostedemail.com: domain of devnull+mattathias.pinchover.uber.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+mattathias.pinchover.uber.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F33B61D9A;
	Tue, 17 Nov 2026 23:23:10 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794957790;
	b=CmCybs9dPshIBK5dI34PUg5+Id4sn/MC9dTA5uPBnmxAcPVue4pJmi8hPj0kXnnUEMJx
	 fmqWosM1EWmvACQw2/ebCsjI2VvT2IW1BIWQXBWD6em0W1ceeZRedSA58sGFC+fxDVZfn
	 yMrXz6rMyZQKwXFvjy4N9a2B5tBsUxed9/aP374/EAIIefHTbIbY+i2twNcGP++lDNYnO
	 VI7sbv+KBaN3hVl+aSeTHgI/OruiPkM6UEu9fBH4AsToWDK9XHjbKKq9gMt/s/snQ3zVd
	 8WD8mRtgNIYkDoIY4xRmK4/ppj2ry0u44h/49XxGDbSuyZX6UnvnzKX36zyDLSoTovg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794957790;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Cue/7N2uA7x0b67B8cg5P6aqtiRdNdHZ/UkP/gcIMjI=;
	b=a2AUSQ9RuECs+gjJ9SdsxraqHcwvAsL87t8KIjHXt8rstqHqMXYuvMH8F4hhtnb+lMe4
	 Eo1btDeiGvvGwX15LeptjsMMw8ZekJe3DWlkVV9WzBxJ2tRW5bt/eKQUOJ0KG70TOgrC1
	 tHyytxprdQo0CyYiXOKZrzv6hUlF7wBgdnSiY6HyXsE9IvO9rc1q1hiuvw+Znkg5DdhBI
	 DqbdoEBnwZKmY1QukWlrjJ9Wd7Yfuj+NXe62UsdvZ3QvF9XwWX5wyx5geD8y8uwVZ+ysX
	 aK6sBi6VnIvBLzM48xjWvdwfP4IPUjgabnBSNoXP8KYvD8MNPUqfsjhF4O9+Bl+dK8A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8E4E51F000C6;
	Tue, 17 Nov 2026 23:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957790;
	bh=Cue/7N2uA7x0b67B8cg5P6aqtiRdNdHZ/UkP/gcIMjI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=PhbAvZhPnjSxyiLY32V3TTIWZQ4/coLalRJ+dZAPFCq2ZOBUWyfZXfa2nZLH6fTXo
	 m4fW8Oicx+B2ZI1D+vpC4tvTbVZHffczZfvuQuaFoYLvSEe5HmYgFO3gTLBTSPblGV
	 /WIzDQYT5xhQKIxhDZL/uhDZffv1xQ45zXx0kOpvVQU/o9+ulJ5BI+BBNfrk+MpctZ
	 PJ58mDSDjnmNIqlL9C1NIi2AdoG43b9db+5L3H5dEnN/dWfUT3Iet2RrqPgESBuvlp
	 AM005YrJOk/CJA1arwxC8HDriXMh3AONQrxWS+fd70ivkl/czQ3GDXm0RbYkTKukh5
	 XkU9i58H/jvnQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 15F4A4AB4B;
	Tue, 17 Nov 2026 23:23:08 +0000 (UTC)
From: Mattathias Pinchover via B4 Relay <devnull+mattathias.pinchover.uber.com@kernel.org>
Date: Tue, 17 Nov 2026 23:22:19 +0000
Subject: [PATCH v2 5/6] Docs/admin-guide/mm/damon/usage: update for
 sz_ops_filter_passed_last
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261117-damon-sz-ops-b4-v2-5-439888fa04ac@uber.com>
References: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
In-Reply-To: <20261117-damon-sz-ops-b4-v2-0-439888fa04ac@uber.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, 
 Mattathias Pinchover <mattathias.pinchover@uber.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794957787; l=2220;
 i=mattathias.pinchover@uber.com; s=20261113; h=from:subject:message-id;
 bh=tvJBR8JDDpKpw1xULOsbisctgZ8T255dOmTkH3Mq+d0=;
 b=sn9jKNfNT452I5qkbsBxzO7juwhpsdzcLKXVP8IlWA37FavQ/FVK/H/BHGFb4SMBeN6MYU0x7
 ZCSuZGNmB3uAaGmXVWyoK1VIwPRJijhPDgKYBGx4YelarTXegoxiDD7
X-Developer-Key: i=mattathias.pinchover@uber.com; a=ed25519;
 pk=6Bh6OEwWiU6dpON0CVcoipq8fXtEgvhsM1Tmm9CTmtY=
X-Endpoint-Received: by B4 Relay for mattathias.pinchover@uber.com/20261113
 with auth_id=1515
X-Original-From: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reply-To: mattathias.pinchover@uber.com
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0DD5E140007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: a9y7g9ox5j68n9n7nqio3proexea8uy8
X-HE-Tag: 1794957790-709911
X-HE-Meta: U2FsdGVkX19HRuvx3iyJS5sW88A2NuMRRNJywwwlWq5zgEtQ0aAjXd1R+gT09dgqsvN5eFe4ipE/vDKrIbjl+qD53GXCJ7eke1fk37ykrKlFIxWO7rRBx8xpvKyqCvCTZiMjCOC5p5ZKbK3oqyrwEiSi738jzU5le79tAlt+EWQJBr32neSyiadAgDGfkNWsSmM36F/6Vttk3/55EW8mqPMivi7GHt7I6X1N1aX2lbo4FH2AftOhb/A5KwirxuRZHpct3/Zt5InjRnCjcUAso9cwCJatgGRaADZZ0Ubd3kjfDAEjgPu6usyfbvnOK6wCL1SxR+Vx38XAAaJatle2kaezXsTTHQtDzhQJt7cTQEWZ7NnKZEf6VeXvAXnoCTF9VnlgdpA9z62LrMvRM5x9uE5Cd8mSz1OLT/lQCCQ+WgX7We3byMJWHEOsRwiHGE9+lneKIrGn2Ad/3Fd98ZW9nkxSSrMy/lMMe+hCmRL5iVQzknE2Yph5ngNF5f/KNPX9YLVLKu5zv0DYGq4gtz9i7KdHlbX5CwlSsCG9FTwcV/zZswGB9xFNZyMWzs7pBdVcmIZsk5yMXbw5MG3ukYSTkmByoSP/c85ixHSWZ8nI4sXpVQ/nIVifB0E80H69W58jiXKbK9mWR0NA8WOqPrchAfC8TdEVzCkZrKHQrPBKUGETgIjN78sz0ghtibLqs4KgXaKsiDUabqYCAJvoDcTe/dzu8KzCewMgmm6fsG8qVXFCuzNJhFYZHwatLCIRRprvXelvIDwqmsSKnwCe0VMO1jho9vKp0klVdT3OZjiARTURujAOFatsGP4bn6RkcJh+RIbo2VtUz4mtXIHeAc7tH14qabVOZYiWJSnotDT7neQTlMJ1+2dQIFQZwCu/WUUuk+zCEfRSEYgP7L3hRBMaXTCm8FXNR5FcHLGPR64MM0M3TSYXa/O3EfG00CNx8l/2CKf7iyUP3KwXM4w0JME
 AXFY7Dt1
 xqoMAj/ip7OIfzzF37g6GQUKW7i4+43hZEOXVgCg1B0LTxmgu90k7K62Wwi8RcqmYi8jYDTICQtJTFvBWalNbMIGJXMW9H8xYu8oIo0XPpr/sm4pv9bU1/TtWgcZxmXVIk7fwbUN8a/h3mwK2LWlv4POIWRjXR3eHwoBWIWPp1aWbBukBfG7cvx+vxKKvDlUtRlRxPzTprcogN9/32drxvSDpX4R5xg7a28oA7rYAfFzHLRQA621PmuzhfXM0XwSsIvk8iKMBhLxVGXMpSTlmPn3y8VjC0YUT9tO4dMEeyiJALajuhrBPe48FDYssoAAMc39BYkJHtDQ7cy8tbDGc7A+dAABaemRagRgH7U6UzhyvIz7KKblh9QuxdfeeER/nJ3QRckkpdaXL0vj+IMMlgB/OfuIOB4IoiBKkI+EpuAbZCEc49Cjibzk/lsR1sEzMC1tilwCcpHPSx/t8ZkJDdtV+rDiVDoQBcPeWdc0442yyWsl/mI7s8zetdojC25d3NLPN+VV01ngEsmPGMs1HzB8nZGUTnCBSurLy3JzijSeOaooQcUoCyG07PbbpC3GL4Q+KcoA5h5FocP3MHIbzXlSOIX0cT9Iao3btKHaUmA6XHJKgzKAG2sIQ4dhytuG7WKArIPTn2nRNHXFD6hvHvGiMeQ==
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
 Documentation/admin-guide/mm/damon/usage.rst | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 6093b1c8fbfd..51c4909f1a8b 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -105,7 +105,10 @@ comma (",").
     │ │ │ │ │ │ │ │ 0/type,matching,allow,memcg_path,addr_start,addr_end,damon_target_idx,min,max
     │ │ │ │ │ │ │ :ref:`dests <damon_sysfs_dests>`/nr_dests
     │ │ │ │ │ │ │ │ 0/id,weight
-    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds,nr_snapshots,max_nr_snapshots
+    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,
+    │ │ │ │ │ │ │     nr_applied,sz_applied,sz_ops_filter_passed,
+    │ │ │ │ │ │ │     sz_ops_filter_passed_last,qt_exceeds,nr_snapshots,
+    │ │ │ │ │ │ │     max_nr_snapshots
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age,sz_filter_passed
     │ │ │ │ │ │ │ │ │ probes
@@ -631,8 +634,8 @@ online analysis or tuning of the schemes.  Refer to :ref:`design doc
 
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



