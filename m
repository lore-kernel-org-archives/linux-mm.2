Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E646CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 16:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55EF76B008C; Mon,  4 May 2026 12:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537076B0092; Mon,  4 May 2026 12:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474426B0093; Mon,  4 May 2026 12:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9CE6B008C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:58:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3473C11B0
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:58:20 +0000 (UTC)
X-FDA: 84730345560.01.49C990F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 15373180007
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:58:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fACHE6mZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777913899; a=rsa-sha256;
	cv=none;
	b=J61fQvitVx43GOWtOhSL59Hi26i7yfJcY9xFhzWNM3A4mqAmLSVrnGN75XEvjjS8mnuuNI
	amjFBT4Q6GsOonnYl7ygpFMTiVgvk8wUFW2smb2y66/Qclfodg95uC40hfDpl+eC4yCXXh
	9bRYmxAJCR4auSLw1Ej+rgr2SSF2egQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fACHE6mZ;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777913899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/MiE7dfJyZb+PHTwCrK+dPewrtZwRpxkBRvtGcLX14=;
	b=3z1YUr+jmnbeD95JZS3RGiwTTdnDP3pZm+B283NYGfgAULJ8TOfsnq84WAiKWG0N1yo9+1
	L5+ImdoIKy7NwKi0Yy+t4f/2dLqDZOILenDEmZg4qX9z4+ygeNOXraOx0VXd/53xZchg+Q
	luCtD4v5/laieXPMjz584j3iAkescYY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE22425E2;
	Mon,  4 May 2026 09:58:12 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EED0F3F763;
	Mon,  4 May 2026 09:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777913898; bh=BrNBR/Fa0ySYMqo0xErRxfDh/QEUbYZzwHot466ZjCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fACHE6mZnpqgjY69/LM+qwQ39TLkVqtrZ0UoUlv7A47vEIW8LTbLDAc57hymp9J6n
	 wPZsHiTVmvfjD7ZtzW+T1Ugk8FFAcT2b0tItBIwSxTSZ91X/ZSNtvsQ0GY9lzUPP8b
	 kEcKgoo6xM50fbWoiDX2/XFZtS9VosDNQCrx7WHQ=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH 2/2] Documentation: maple_tree: Clarify behavior when using reserved values
Date: Mon,  4 May 2026 17:57:46 +0100
Message-ID: <20260504165746.1422057-3-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260504165746.1422057-1-weilin.chang@arm.com>
References: <20260504165746.1422057-1-weilin.chang@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: afkp15dzu6hj6shugqi3fxuacryoytnc
X-Rspam-User: 
X-Rspamd-Queue-Id: 15373180007
X-Rspamd-Server: rspam07
X-HE-Tag: 1777913898-576992
X-HE-Meta: U2FsdGVkX18PjOWRY6v1Gdf3791bdvVHYuVSsWHC4CYczAfuLTnI7GZJJe8VJJ2KdLrSv5BMkXpQX2p0BDVlpNjjEVZZzdc7+smQ38q2k+M586pxCBN2P4ayeHss3MxbCiF+EzjItFDA1xJdEfki4grfUR40ZfGmYBC3W27em3RRaE1rGqyk08w6OZ7kCnkWd1MUMlM253m0P0jrsKU+aeccvg+4TTjzfKtT6QpbDAQ6h7Xz9PiplPanllEblhq7df1SjZakEgwPESmWO0YFoZH+V/Ms+9REtn4QeVzBJ9pLCivrjW5t2VAa2km/YpCjV5VmwpZtqF0Uj2PxuVafwONogZv1X5oAVYbZJ76pLWdpLL0olUcT2AC3a17D0RHCorjG85NQu+L8+j6QyfvIwolPR+gXZe+D9sVpDgibYxTAI2iOID1VjUMs+OcdxBG4KLFNlT5v6iZM1raeFGZbyJIuBQ6B5DDoYOuAeLlJKx7ObFVdb/eSD1PxNC301096jf0izR6nXHAIlg9WxQedxZ5sWyo877WHC5S7/zNu4igs7WgU9RAIMe8vTf+2QMq3Or8nE2zR7MViqQTo4us1TehpeekjHPj9jZ8P6C+9H0IAR8IcbV7V4hHjthBu6dNIds6FqUPQDEqcmIaiEW0paPg7lCvuAi+y9B1/783HAaYYUfC5E7VlWycUs7aiCrxuD2ltOSour2H6Ai7W5DzOkvnTSNSTJozJFAZvGQrG+sOGMH+yDxDQn7BK/EUZYRTugXiNO3kn5qP1EHPtm8JSs5dMI874Msch0L41vPtg2wjOP0DsImuvtLxTtc4nuLozK+PxG/U9SrlkBD1zhG33R3jjeTOQKs7VVqiFx1U8AydhB/mIGtVkNn9j+ZrAzS7C/A4kgvhY+Xuod4V8khRQK+JPwoRPquuuJ3F6uZ51n7U065vkCWX+s16rTERY+ydcbEPRWC7AEr1KUXY87/I
 2eKnONMN
 CLlU1+O4qyGcy/9Zv4x8QHt0yn1GtsnnAQRfNMaeOD0oMCHeGMpWhZ1jhgURqzwkFGPeLLd5+uBOOvWRKzRCYH9X9NyoCHBc7jHQ+GBsm2oFw7Qjl2hrusIDH9m6VhX1c7IUCvItIgI3PgRFoHm+hzuAFwui4rjr3B4g+SUPnhtWNZizQvUhAHOqMfJVOZWo0YudmXWqUprJdNrIwlMvWGoMs5nYBditQeavRIc+Omy6dPsq4kJAyfxHs9ZvkLS5N8udQGyfpsH/GNJjoByQKHm1BKqFaTwYgACSl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It doesn't matter whether the normal or the advanced API is used if the
user uses xa_{mk, to}_value when storing and retrieving the values. Just
specify that the normal API blocks usages of reserved values while the
advanced API does not.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 Documentation/core-api/maple_tree.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
index 87020a30ba69..e5ccafb84804 100644
--- a/Documentation/core-api/maple_tree.rst
+++ b/Documentation/core-api/maple_tree.rst
@@ -30,9 +30,9 @@ Tree reserves values with the bottom two bits set to '10' which are below 4096
 (ie 2, 6, 10 .. 4094) for internal use.  If the entries may use reserved
 entries then the users can convert the entries using xa_mk_value() and convert
 them back by calling xa_to_value().  Note that xa_{mk, to}_value() bit shifts
-the given data, so the top bit will be lost.  If the user needs to use a
-reserved value, then the user can convert the value when using the
-:ref:`maple-tree-advanced-api`, but are blocked by the normal API.
+the given data, so the top bit will be lost.  Usage of reserved values is
+blocked by the normal API, and will cause undefined behavior if used with the
+:ref:`maple-tree-advanced-api`.
 
 The Maple Tree can also be configured to support searching for a gap of a given
 size (or larger).
-- 
2.43.0


