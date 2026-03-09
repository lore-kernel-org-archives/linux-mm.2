Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2505F41807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267EB6B0005; Mon,  9 Mar 2026 11:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249296B0089; Mon,  9 Mar 2026 11:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155A16B008A; Mon,  9 Mar 2026 11:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 080596B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:38:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A96251B5A9A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:38:28 +0000 (UTC)
X-FDA: 84526931496.08.B93EA66
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id D98CB180009
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:38:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UxsiCuWG;
	spf=pass (imf06.hostedemail.com: domain of qq570070308@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=qq570070308@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773070707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=X57U0V4sSgYCWSfpV3skueJqwmOEXkvkQbQCoj2ilaY=;
	b=nJgjCsdYiHlby781/w0R9lajyjxgDekMz9WRAcv46A8dIWNU5bGNUeZYfxKcPtzqYGyquO
	sDLIHxnL6mVDSuZ+W//bApVsS5V89/ttHydione2kh8Z5HyEbWAYE8Vx6boqfmRm22l6+H
	lAeDas5YNQ8SuIy0rpF9kINVfjHfz4g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UxsiCuWG;
	spf=pass (imf06.hostedemail.com: domain of qq570070308@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=qq570070308@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773070707; a=rsa-sha256;
	cv=none;
	b=ywM8LoUZt8d7hxvE078tTbK8a+j+ZSUdBYU9cX03E122M6qc3g52H5cYacXnKKKNIRvLRa
	Frt1bS933y1NjGgsUDzE0KnWt2hFUR2awdHidCNYDUpsjt0Qr7XDJ3IeGrW7/+M0SKlNQd
	xHepmsiFx7pDZd0fXsTnD8FX2tCAQLs=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82987437624so2194923b3a.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 08:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773070706; x=1773675506; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X57U0V4sSgYCWSfpV3skueJqwmOEXkvkQbQCoj2ilaY=;
        b=UxsiCuWGVLR4YPNLxJ6/JwuS9Tb2oSHoTb07oZul7BkGJcnnokAvDv/Nc9Z8PUmzM7
         231115E8eciGhZizHVrhYaFU2QA5pyPyIEUnEMfuDSMKfQcCR4vB8/fru9Y4+sgmuOBB
         9OD+YWakVr3t8O5cxOjQgdgjsvgJphEsPUX0VH5Cbv7ACIce/IOMwV4U3/7HJO1Gw9ig
         +VmvdzFcux8zlhNBjauBNXvWyrzhvXwM88gzxBhjM5lI8U0w25I+lHnTQ58N8ETr7ixx
         vuPKOQBP/Mrpb9iYOX7Za314cozL2+tLoMy64Kp4S47doOvHorCDYDcP2lP3zXcHTu9g
         xQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773070706; x=1773675506;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X57U0V4sSgYCWSfpV3skueJqwmOEXkvkQbQCoj2ilaY=;
        b=IiyyoG4BBWndFLBn6GLeLXLEkGACZMI0D23+1YoopirjdG4wY6gQgt0vlErQgoDhj6
         SGa1wQChkxB/aH02IEqgEVFcXi20+izIgbKmxKPECGRvhyQ4ZNxxAidqq27XyTkRcMP5
         54ezMfHVTiN3bNeiDHofL/MwUk49sQjxWfYwf8JmmOoC29bPyvEnd7fS0BlSgqefYeK8
         kFep/WbvBKK51F8+cxPLF+CJ7cJkNwu9AuXictyloeIj74yYUVWPIKplDC2/tp0JbFEN
         QjeWg85ptk2eZAltfFlP5aYakPzQ7jA+ASL4lBBmDvEKumTZfg8Q62otDZZLDo2jNoLk
         zevA==
X-Gm-Message-State: AOJu0Yz/qS03Yk+RzqSH6tK2VcKFIqcqKrxB9MzIPJydkEVHIA1qx8Ns
	hW02MV4yehqyzfe1pVc3pwrPk9nRMGLAngc1vVhAhRAKuspdjrmcsTQ2
X-Gm-Gg: ATEYQzzmQ4+Z4uytkRvWpJ18EvsCS89cXrp2nxIVQZx2JeQYSY0jeez9PhGoYk79M4Q
	CtkDvFgMM4oCoi+gvyoIFVWyuPjP4RHl6rtSznK+1pkV1TO0Hk6eHxaLLed/iF6NzZQok+PzT01
	aR/nF+9BQIAbB3C1CgOFvAENdCvt/ONB8kfNU4QYPHQ0YNQQW2o2gpktUR4PeyZAl6/L3T6rZT8
	SSbIIpHMrl3ha8szGlo8Y/xwVIu/I1NxmwgLIicrq9OxGDd1FbZdkE/jZubESAVv4200WG7QTjs
	q1DkqNi5r89hXuNRLyGEUkbaquwxhTHjYqsUzqdxm5TlbGUKQrj+z1CU4Hmtw6ZjKJS+GwWVR9U
	atEolSbi2aUpz8FcC5LKsXnhEKTbY6zqhUcsUg52cQI+3IL2R6hIm3O4DI8Lw5UvMQgBlWYqn1I
	rvKJatZr/EDGGJ1g+j0mFrGc46Jn5WCXvy2yOI7Y3jjT4=
X-Received: by 2002:a05:6a00:b92:b0:829:751b:4b06 with SMTP id d2e1a72fcca58-829e4045bc1mr13470b3a.21.1773070705549;
        Mon, 09 Mar 2026 08:38:25 -0700 (PDT)
Received: from DESKTOP-3LEPQG8.localdomain ([119.28.20.50])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a48a54cesm10516486b3a.48.2026.03.09.08.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 08:38:25 -0700 (PDT)
From: Xie Yuanbin <qq570070308@gmail.com>
To: rppt@kernel.org,
	david.laight.linux@gmail.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	justinstitt@google.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Xie Yuanbin <qq570070308@gmail.com>
Subject: [PATCH] mm: optimize the implementation of WARN_ON_ONCE_GFP()
Date: Mon,  9 Mar 2026 23:38:11 +0800
Message-ID: <20260309153811.40958-1-qq570070308@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D98CB180009
X-Stat-Signature: tp3y5yyi1td5bppwishreswiq4qx56z5
X-Rspam-User: 
X-HE-Tag: 1773070706-904899
X-HE-Meta: U2FsdGVkX19fZlzRme0A4iY+lrT7yqKO17+fYWkUdHPUsuqGngqeRMX8PKEtKyuYKD7gzyubcQx7+Jq5+sTPlx6QRjLVceUpgfkKJSPs1pTAH+k7tOJXEJeP90vLBHcpk9xOfxOiCrbZMbARyS3jyVLrPY62UMCNQLpNXneboPA8a1mnEy2IXZ+c5nK6KptHivHdQrfbRhNXp0HI8dZT3iy+KWbR3kwx/DH/QjQ5Ei6UbpH2iSSsYCwC1AOir9oHlXwshyW9BWKMOohGI7vVkOdasFkG513Rwh6JHl2dfhlAuB02mjkbeDoel/vNQ9YZ49TJOPR+XPlBWpEeOhkskEaDMpSs/FUcUWaI2BoscYpYvnFcJcZjEB64zE3FGlln/rUPPA2LaF5c/kQ2uO6IUeCkiHvj3rJArctnX0T37yvbY2xmm3KtMHHz1fSRwws7kaGoDtzzcG6QtX1fPY0OIK5iAwFtMt3un13y2PWnoH89iq8g8ROv3YGRiG+h1mBrIGxYu4G7esd7J7lNHasDwnXAJQHfuSBwdvFRBGbE3ga9mgjXvUewvBd2WXP7QG18JqQyIk5qBqenc1iJE6809/uhtHsPM5b7Wxn5w59mCy7T+2vANtfrmrU6QhVmFoUDr/6RPWkfGjQc6j6nnjzC+us1xcaCX3YtiPH4GYiLO1EBDb8EKZOQgM8YRN7bf0DeQtfeE+bE1Wf0EX9s+3NOzg61wbcxLGQSrvVNYv+wDQ7h7C+rl9XmkLNCm0v8dQpWq9H8oI9r8dPuaB0V705Q3Sh3m0ILjQ8dINrrouocGu4EE4UWxmPQ1Zbaer7Y0ZCeNCaP/z7mweI8HkMiAQpN0ahYNSbEpfWVv6zSPR5816uA1Ra7VKq+cfpZvnw57IxRYrJvvQcekNTwaifye8ajAjGlLtRhcidJ3Q8DzIKgHFV5UziGNl3iCxB848Pe9NfvVa77v8/opHZvzIjneVb
 FA7ZU3Gp
 +bm8N/HRE8haWJxqbBFYXh2Hih8SIZK89yaAuw0CDR/RFjY5Mf7NdvRepYEr74CSwrD2SK6gywNPD0fpAFik098H9eTiqvLYq1yg1D5WcCXeXdZBGVJrojo56i3z5WxqkT3jXjIe8qCs0d+QOwC9J0ohWnxGvmFARqlFbxs3Ui/kHuwJ2CfmuyA37grjx6xaIqrdCDz6CU8pDBx6ctjlkBIjjimpcqE+mZyNFULHtcuzKvh8q3TuVX0fw2Rn6fkJewn5MjlRAgFR1jb5BjWOv/TQ+Fq2gAUcD8kuRPVqDSl6rIYy1rgc/MPZk4Ruqi4A0oE2y4jMLzREwhYAclmVT0EyA0q/I7o3vbIA5zGtgwWqXZPCkLFxGYWcMW2TXJWDqTJyzCNpRW2Ju2eA41z99GS1asj4zf81FAOo9ZHG0GZVIcLC9RmIwqbyWoK+WBnJLiiwQyCeSnl89DullFHFZOPzjNGC9X2A4J+Ea3tBf7KB93cFN5+slAohRdnt9iYO5daBrKa1qxyjTijYK+6tstN0gbuDQg0WcVwzyNr0YjeeFv+qtdNY3AJPpaJOHNx7VT2yNT9+Z9zmccxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As shown in the commit message of commit 242b872239f6a7deacbc
("include/linux/once_lite.h: fix judgment in WARN_ONCE with clang"),
the code "unlikely(a && b)" may generate poor assembly code if it is
actually "unlikely(a) && unlikely(b)" or "unlikely(a) && b".

WARN_ON_ONCE_GFP() may be used in the hot path code:
1. The argument cond shoud be unlikely.
2. When "1." is true, !(gfp & __GFP_NOWARN) is unlikely, otherwise, a
   WARN may be triggered, which is a very unlikely case.
3. When "1. && 2." is true, just like the implementation of WARN_ONCE(),
   !__warned can be unlikely.

Reorder __ret_warn_once judgement to first and split out the unlikely()
in WARN_ON_ONCE_GFP() to optimize performance.

Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Laight <david.laight.linux@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Xie Yuanbin <qq570070308@gmail.com>
---
 mm/internal.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 6e1162e13289..49d2b7a270d3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -93,7 +93,8 @@ struct pagetable_move_control {
 	static bool __section(".data..once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
 									\
-	if (unlikely(!(gfp & __GFP_NOWARN) && __ret_warn_once && !__warned)) { \
+	if (unlikely(__ret_warn_once) &&				\
+	    unlikely(!(gfp & __GFP_NOWARN)) && unlikely(!__warned)) {	\
 		__warned = true;					\
 		WARN_ON(1);						\
 	}								\
-- 
2.53.0


