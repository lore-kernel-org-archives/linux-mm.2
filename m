Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29519F99C89
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 20:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734FC6B02E0; Sat, 18 Apr 2026 16:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5266B02E2; Sat, 18 Apr 2026 16:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4006B02E3; Sat, 18 Apr 2026 16:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7216B02E0
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 16:49:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC8C7C20EF
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 20:49:58 +0000 (UTC)
X-FDA: 84672868476.09.0A09DB3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 400DC4000A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 20:49:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NcStPSRE;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776545397; a=rsa-sha256;
	cv=none;
	b=vLPyue0T21zCvLtjqfJe1a1OvdNuP+5je1cayxJpF63zEV0rP50o6nB+3p7qmD/fmP9Jgy
	mRbQtwg9fB1hyWsy86D+wkOlF89jlgHG6cqIKeifmo2+s527AnNEcnIZx9mc+nuGCDnKh+
	N/g46rV9IjL4Y/9Kye6GgTvOhcUIRLM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NcStPSRE;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of weilin.chang@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=weilin.chang@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776545397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tcK03yvb0EXMm59QJTS9lKFUxmf1dqdPICids2SVgLg=;
	b=YfUH9OFfOCtsE4TUZVD6wYPtxzdQu7ha/JeHrMZGvZP+1bGTjJZs1ctwUWgkZXrTA7DVEE
	t4gkaQ8bJ9Z+McKvkfH5P2IiU/MWvLpFy0Cki/jtnNRbeLO6fxIUDL1mFPCnNLD61m7Ett
	/ofl+f/MRDUZuESIP8bURCzEbPEoAvk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 97A3C176A;
	Sat, 18 Apr 2026 13:49:50 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 72C293F7D8;
	Sat, 18 Apr 2026 13:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776545396; bh=H6WgkZZcA/mA2cLpnncZ0V6CejHxgd1bABjG2+xoA64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NcStPSRE4v1U9caa4EqTbzTMJOkAW0Q0Emov03fEF4WZ3WSZQaNvpplDjjSqnN7bV
	 F9dLncqqvCwwYWAVrwZTUvG0vWXQOkEb8JGA1tnCOndXcPmiiEYgO9+S9ZklCNEuup
	 JOVj+KgDtFS7/KQHicmvI3m5N14I0D7Py+zSHMmU=
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
Subject: [RFC PATCH 1/2] Documentation: maple_tree: Point out constraint when using xa_{mk, to}_value
Date: Sat, 18 Apr 2026 21:47:53 +0100
Message-ID: <20260418204754.120405-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418204754.120405-1-weilin.chang@arm.com>
References: <20260418204754.120405-1-weilin.chang@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: be9f6udb6waj4he46dmqx6b17b1a1xk8
X-Rspam-User: 
X-Rspamd-Queue-Id: 400DC4000A
X-HE-Tag: 1776545397-613698
X-HE-Meta: U2FsdGVkX18dpuNp6podo6rxydfkgJ/zb9HPAikNIujzSUgYDogRMxNEB/0P8OJXaFuspEg+UHQpjPNQEeCR4EmjrRhP5dLY3JBbIh/RbYzYsEycAHljWcwlhq1wOpGJfRnRK85U1WkNfQ9+FREnBJtZIWp9crj8R4benxb9U6LeKUKmkj2fym8NZ7IQXzRmexxUXIc3qCyNmFDNVqdQm+3NAhTWwp9iY1jlgSFTONORvy12Brm5dMHaB9F4mPXmAJDkFXw+iISmJKps/ZFvgJcHlK0yBzrX4aSQs8iPmbBzCjPefkdLRvyzD95S6ULFDH9TYQQVNui0RX6AwYKfvvM8CCnbpQd9AxaRhlGUA72V1V/h2ZRr0KT+O+4VEvM37S/ImBjMfQXJg4cJjs1BIcPWQ6WFUhoABSp76wv4Vvl6L5+Yq8pBr3QywmrJ3VcOphkZ1NahZJxpc555kPBALdNN11vxzIovk0kyxEie/2VP7J9qbaUail1nXah3fEDu3WE9qwgbgB2NMIaA6gCbgNAP99K7Lni+oMnA30Z4s13+PCU3LZ7vSJ+51NUOVdrTUzZEmRtLuNDfL6WpXgRhZgdSmMU96QPaPIm4vtTnzSNkWkJMlVbonoPsU1CknlpcqvHmJp3QGDprj8KNrWvuwj7R8Ki9bHm2Zz/fBrJMMCRL6kY5dC93cFkx0rAHkbcpA0pfzPMjKaMr7mzFSKLVW+x57gmcSchNZFSULvS+f3t9zePv2NSW2lgrsRv6ycRZjKnY7ynjhOerTfe0YA2wrra/IMkTwp5wh58FE0jm/LUZpF+W4Lp+yr+EiFjwkURSXBX0Xu4d2qLSG+jME2244OzdlvNqhv+BftGVfgqjW6Ffu1HxFlJBH1wejLScO+0wpvRyaRihMTEWri5wPiaTQKGRutqOH0/aJdH9Y+MZUcC/6YB9NRReY+J8fd4gzB+EKl/lqLY8QHj5QQTbfiP
 vwec2evA
 1aYTSJ6nz4mM6sVJPAqTC2Vl01pXi7ohiY/dQwGgDAdiMrOEdykbPtWPHoUJbJS0h+7p6pEkq6gCTUNwMJhIwmc6ZeVKOAMw6hReEhUfpyw2uuRoZLsLm+UMxAcpncV9vMBqVxjJ3p0eX5C3jVlpBCoTOUHvNL/UWkm3WYhekD6nM0j/BU44e/W5CGBrcYB1ubb8HfvJyUMfLgX/UIltyNSNHxviKeeL+1/f3U3YHoSjYw1SZAR2C8CGAo0VzVvbwlGNnVBH9/kyXz7fZ5OEWcWXRl8N6XmQaqE5b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using xa_{mk, to}_value when storing values loses the information of
the top bit from the left shift, point that out in the doc.

Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 Documentation/core-api/maple_tree.rst | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/core-api/maple_tree.rst b/Documentation/core-api/maple_tree.rst
index ccdd1615cf97..15eda6742af8 100644
--- a/Documentation/core-api/maple_tree.rst
+++ b/Documentation/core-api/maple_tree.rst
@@ -28,10 +28,11 @@ virtual memory areas.
 The Maple Tree can store values between ``0`` and ``ULONG_MAX``.  The Maple
 Tree reserves values with the bottom two bits set to '10' which are below 4096
 (ie 2, 6, 10 .. 4094) for internal use.  If the entries may use reserved
-entries then the users can convert the entries using xa_mk_value() and convert
-them back by calling xa_to_value().  If the user needs to use a reserved
-value, then the user can convert the value when using the
-:ref:`maple-tree-advanced-api`, but are blocked by the normal API.
+entries under the condition that their top bits are never 1, then the user can
+convert the entries using xa_mk_value() and convert them back by calling
+xa_to_value().  If the user needs to use a reserved value, then the user can
+convert the value when using the :ref:`maple-tree-advanced-api`, but are blocked
+by the normal API.
 
 The Maple Tree can also be configured to support searching for a gap of a given
 size (or larger).
-- 
2.43.0


