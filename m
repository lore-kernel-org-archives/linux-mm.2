Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 723C0C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 15:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5386B0088; Sun, 27 Sep 2026 11:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287A86B0092; Sun, 27 Sep 2026 11:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8A56B0088; Sun, 27 Sep 2026 11:51:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEF5C6B008A
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 11:51:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4A0F2A7296
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 15:51:52 +0000 (UTC)
X-FDA: 85259982864.02.DF189CD
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id A2BD01C0002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 15:51:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=wCEMVHDl;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790524310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LbCPjRPiehEgYsY0LkPAes0gDEo2YYOkyfyk4XJZWkk=;
	b=sn3ZdI/ldN7x6B41WdJytOInv0YNTp5zPrl9o23L25QSmku0BjiuXvRd3ENd8YfN+deD0z
	zy8mCHpL7iNbLYmZLwZWmlj6z5PWILZXLILyiCWZBHWPTHQcspIhU9qVsE1WTbzqAPC1vJ
	1kq20N9HrtSZkHEgARcOVTN4lPGNG1s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=wCEMVHDl;
	spf=pass (imf21.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790524310;
	b=x1vH+fmGcLk9l2duCZz+i8MrNhwlgleS9Tax7s4g2afJjLwMeNrnCrBcEfi8ZJmXJXnoCQ
	p/FhtjaiDeMOgHDkZe58Ar3rjoENheUmMMPxAfjkQiArwTj5cOlyFhCqMkO4FhPQwgTeMI
	H7FCR7cGHXPzCTkjR1qoWaeFGakDQBI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1790524309;
	bh=LbCPjRPiehEgYsY0LkPAes0gDEo2YYOkyfyk4XJZWkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCEMVHDlweoSmmOHKAQYYmzKsJiAUEPYfaQlVtcVzqs6FqO1kpxtsyI0zyw557FQK
	 Qmd2ExybNHV8uZqs4X/OV9IIQZquC0TxowYydwZGp1vHpsNcY9AHjhjXn9kdfp83Ma
	 SCLl2inf69bbqXHH7JUDxmO/EfNS9TiRwElm/8eBN7lGltxPLRlF5iLsgGuFb35qF4
	 XsNKhQicROmq2Pyigp4oDddRQbGB0tCgTj7nypCoBW+1J7NolaXV7SKU1fNwk98f+f
	 LBXEV+vUyhyZL1FFF5i1ayu4FaN+NsNLwqH8ddFfJjwrNuyx3W90FyYoyOi4XkDJWf
	 t5p4u9vGpuoTw==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4ht87n5L08zhH0;
	Sun, 27 Sep 2026 11:51:49 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E . McKenney" <paulmck@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Joel Fernandes <joel@joelfernandes.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	John Stultz <jstultz@google.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	maged.michael@gmail.com,
	Mateusz Guzik <mjguzik@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	lkmm@lists.linux.dev,
	Nikita Popov <github@npopov.com>,
	llvm@lists.linux.dev
Subject: [PATCH hazptr 3/4] Documentation: RCU: Refer to ptr_eq()
Date: Sun, 27 Sep 2026 11:51:30 -0400
Message-ID: <20260927155134.4740-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927155134.4740-1-mathieu.desnoyers@efficios.com>
References: <20260927155134.4740-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2BD01C0002
X-Stat-Signature: 95zyy5ef6gzhppg51ci69stfjrumstmn
X-Rspam-User: 
X-HE-Tag: 1790524310-205023
X-HE-Meta: U2FsdGVkX1+UEOHI5F7JSYscgymtz1Ulmq1vbBtm+xM3sIBeg+fgzk+fqSlpgn0r66wRhHNvU0OneqCEZth8e0nAyBh+V0gqlk+v7LBf0FtsCj+qdGi/8jXh3idH5NOTNfNlD9q1ckof5/VdEUd9CiMGSvCAWiAqHkzRFGkjfSXbFya4IbyE2ttQYpX6NIVTssNVc3IaLkZUOLm033mDgGVihHotsIeO7bDiIBv+oJ+MCjsDE9GFGdVWWsyD+KDUYgkBKg/Je8hLvC7h1/sM83WRlWjW3iuDNbsl8S+ItD8mlvx4ruf2W7o6dQGYtyY//+mmleM42iQsaxs3+bZxRe67h19iPG4i62cNwX23R3vIQCATTpNcS5UE1vDkBgH/1Zye1qaNePdKMq62S211C6guSsErzrr9BxlFFg2yQQKM/Duu0Q6yVOoPldVz1/odO4DnnD/vkxZ0yKj746sHec9BOVGUlk9k2/j74O+1yQpaUtI6wqLZ+znHqVLaeqaIsBBS/lOpy1tVOtTiD/qzcQ+m7rPMLl81tv30jOKY4yl00f77i4hKcDFSEBUcOiDx4tg2d5LX3V28JOrjxHMQL8bRipIHMbMIjxCZZxW87+Z1ElE93vIxCAWtNzLeDYqAnJUvN5TUL4rT+0HNoTGODFXORFpzGPafrIrAbQGfQLiXOt0P7E/W0KIcPQ5Bp8/ZlpaO+nBT8mXfg9e00JGHHnbSqV1qWujgO2EJ5VQ3geSaZua6147mPZM4o5c1ebb0S0DN8XEkMZQxNk12RsRu2z4wAg5ZH7jHlneDtuLqfe3mQPROVCXanZXf9eAntoIkgFi2wamDn8CVy/ykTLMwiCR6NV4g6lGEywD5w0/Syusm/76Gxsh/7hVdPEO7oG4BVfqSSoX8kcjNPdHOGZFI+J5n3+JRIf5A643ajLWyi7+Y9a1r7H15hmGwZnf8Yoi80rt5cKLpahCzp5ac274
 jGc2/Cwo
 IGVrmm1XZrRct8xD9A5auP1jlfioygv1v9YwpivuIrcudYUWUK83bTV1MObFB+aBsHSjhchTqBLUjByRpJLA0jACCvOO2MEXift7qZPZokYueS/wos3sWLLqvBRDROFPhBqmEpKttgyY4d/nOvi0ka1ux8xHwsBXahPG9v+YpU4cIVfTRHdr/sgWyqoey5PVKZxbVnWW6nTvwVBiWBecsvU+aNrR0Wh+TUmdecJvY9/bek97aFdUHE1esvLFUArNX7SuVDcWHj48evqWvvNrh985CmON3+FrcWuKNwsUPz/TnnYua4Ux1bjL51K0C0+kdob6KAwz1UzuW0F+FENqvuhTsbFi5W6PD7ssRHc4bEMPJA9Qs7KXSyqoAMXDtKBEI6UuqACy+YIG7Aa54n7VzUbHg1vSYiJ9TYto9sCyVk1+uUi0v07THgdbauLUVCMO+pZFiA6CnI/xIbw2Yuuytvqa5dJjgERkdIyl69OMm8xS0YDWJMSfY5kFr/RG7RfksId2C8Rmzj3gpI7fQSJP+hW3ktQucuZLESPGBBC/m7GLoPjsm5BU+69qhk6UvaomcBuiejT4ORJI8x/YbUE48z5Ng43C+1/WajY/n+KKdTQFJd1DwRGIyg2o8gtG5kijJrARC0wFEgBZzhSMgF8b0tUao4JlpjpT6DS2bdDkfPHLsKvc5aRsjpRaiJN/RiRL/AodFvQtbHbRbmxjHacU7Wmt4TGKq9CjIAWB0lSFzxlCucx+XKnSLaQKrOzPvlOHl6a22hn/qnoaxJuEIzvRKnRyS/ZaoV3eUh1fCpw2+WNjSUCeZsHYj+UZ77CDBeijCn8BReU/j+1CkclYrQoIDuW1fgPUbx8opxmyHRLSRO0UdBCr4p0rkcYUYSALcyAUoJXplHhvUiOXcI1c675TpoXAOJktnLlrdJrma7Y4IQ9MPeQTJeK0NwWg7T17jwE3jYgX8HUMOIk1/WrpDQB0ekRipKmfd
 E9TyzfIS
 EDO7EKYmIf8wAOztvuY65b2YSW03wBRcx88uqYDdv6+woqkVU7uHwwaMqB9hQg8U6Apde3ZAtvsweIyRIlBvbhlCpVbeWUhn70xCRemTXSiPBWeZkB8R9iR1BspkM/suyFDfweLVAqqVQYZ3X5LFVQ25KGZDOmj4HgF5xU7LJ7kcCJRq//LvPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refer to ptr_eq() in the rcu_dereference() documentation.

ptr_eq() is a mechanism that preserves address dependencies when
comparing pointers, and should be favored when comparing a pointer
obtained from rcu_dereference() against another pointer.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <jstultz@google.com>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: maged.michael@gmail.com
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
Cc: rcu@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: lkmm@lists.linux.dev
Cc: Nikita Popov <github@npopov.com>
Cc: llvm@lists.linux.dev
---
Changes since v1:
- Include feedback from Paul E. McKenney.

Changes since v0:
- Include feedback from Alan Stern.
---
 Documentation/RCU/rcu_dereference.rst | 38 +++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/Documentation/RCU/rcu_dereference.rst b/Documentation/RCU/rcu_dereference.rst
index 5bc3785ebfc2..85b5f79ebf14 100644
--- a/Documentation/RCU/rcu_dereference.rst
+++ b/Documentation/RCU/rcu_dereference.rst
@@ -104,11 +104,12 @@ readers working properly:
 	after such branches, but can speculate loads, which can again
 	result in misordering bugs.
 
--	Be very careful about comparing pointers obtained from
-	rcu_dereference() against non-NULL values.  As Linus Torvalds
-	explained, if the two pointers are equal, the compiler could
-	substitute the pointer you are comparing against for the pointer
-	obtained from rcu_dereference().  For example::
+-	Use operations that preserve address dependencies (such as
+	"ptr_eq()") to compare pointers obtained from rcu_dereference()
+	against non-NULL pointers. As Linus Torvalds explained, if the
+	two pointers are equal, the compiler could substitute the
+	pointer you are comparing against for the pointer obtained from
+	rcu_dereference().  For example::
 
 		p = rcu_dereference(gp);
 		if (p == &default_struct)
@@ -125,6 +126,29 @@ readers working properly:
 	On ARM and Power hardware, the load from "default_struct.a"
 	can now be speculated, such that it might happen before the
 	rcu_dereference().  This could result in bugs due to misordering.
+	Performing the comparison with "ptr_eq()" ensures the compiler
+	does not perform such transformation.
+
+	If the comparison is against another pointer, the compiler is
+	allowed to use either pointer for the following accesses, which
+	loses the address dependency and allows weakly-ordered
+	architectures such as ARM and PowerPC to speculate the
+	address-dependent load before rcu_dereference().  For example::
+
+		p1 = READ_ONCE(gp);
+		p2 = rcu_dereference(gp);
+		if (p1 == p2)  /* BUGGY!!! */
+			do_default(p2->a);
+
+	The compiler can use p1->a rather than p2->a, destroying the
+	address dependency.  Performing the comparison with "ptr_eq()"
+	ensures the compiler preserves the address dependencies.
+	Corrected code::
+
+		p1 = READ_ONCE(gp);
+		p2 = rcu_dereference(gp);
+		if (ptr_eq(p1, p2))
+			do_default(p2->a);
 
 	However, comparisons are OK in the following cases:
 
@@ -204,6 +228,10 @@ readers working properly:
 		comparison will provide exactly the information that the
 		compiler needs to deduce the value of the pointer.
 
+	When in doubt, use operations that preserve address dependencies
+	(such as "ptr_eq()") to compare pointers obtained from
+	rcu_dereference() against non-NULL pointers.
+
 -	Disable any value-speculation optimizations that your compiler
 	might provide, especially if you are making use of feedback-based
 	optimizations that take data collected from prior runs.  Such
-- 
2.43.0


