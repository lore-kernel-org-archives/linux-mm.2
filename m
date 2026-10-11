Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AFFACA9ECF
	for <linux-mm@archiver.kernel.org>; Sun, 11 Oct 2026 19:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D086B0092; Sun, 11 Oct 2026 15:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC69F6B0096; Sun, 11 Oct 2026 15:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E516B0095; Sun, 11 Oct 2026 15:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B4DB76B008C
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 15:49:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 302B5C06D9
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 19:49:09 +0000 (UTC)
X-FDA: 85311384018.12.04E8211
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf28.hostedemail.com (Postfix) with ESMTP id A14D7C0006
	for <linux-mm@kvack.org>; Sun, 11 Oct 2026 19:49:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=kMCbYXah;
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791748147;
	b=pDDdQMSAGqf5SFaQ4n/QoVe/BaIM3mBzkh9/UHMn4b81IEWHDq1aVj61Mgd8vjPbnI4D24
	ezBYjV2k2es2VuICWbcSId06fallW3ynZDC1ETme4cggVNbC2SpgQllcRvBGFzTIFumGNl
	3zO+uiDCYfVHIsMfh9eZa47FM7PYTUg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=kMCbYXah;
	spf=pass (imf28.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791748147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkhbRL4OIsL1Dxt9Yr/GvUlPu9lfUGNaz88z9suH4Ns=;
	b=FMAx56LHYYp7FjiSfHMMK2ijT450QO7apzvGofjEtwXwyz5IIi8xBcXTafo+TeGDQB5xkz
	VQ6BZ9cQdQa3MDRr0KNNDEfkmNcx3xqeeaLAX3zj5mTYUsNcX7eKW++jBULkAEKcfvW+FA
	/fgM7BzcEBdje68buSAPLNq42WwMPeM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1791748146;
	bh=RkhbRL4OIsL1Dxt9Yr/GvUlPu9lfUGNaz88z9suH4Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMCbYXahriyssY8V5buxaBdgsSDoErBOedhxeP2HfnUOwrM4o6GxxL6DQ28q2V4eN
	 XFKxC6nVEIJ6n7UGljg13vOhmhQoxSzLJBheymUKnGb7/UDz8Jar/JaJp057NwVcfn
	 aTgVKyH31JIETSyE3zaNIBwGaO5EZkPL8to1xvx7u3thlJbZbA9RK1CLdzaO1iykos
	 TK7tn7ABZkbUOhyM4eFm+uQUoiUOQsKwfLiXmUeWKzBP0KlWtR74k9v9jI/XGWxAo5
	 hzrDy0zl80PfSMppGDDkegZVnt6AhkNjSB/Dph7JqbZXSRC/38V+vrMebAUc2Xuanx
	 V/fxkmqxZEqwg==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4j2rl65Wr0zlsh;
	Sun, 11 Oct 2026 15:49:06 -0400 (EDT)
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
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	lkmm@lists.linux.dev,
	Nikita Popov <github@npopov.com>,
	llvm@lists.linux.dev,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [PATCH hazptr v3 3/4] Documentation: RCU: Refer to ptr_eq()
Date: Sun, 11 Oct 2026 15:48:49 -0400
Message-ID: <20261011194902.97364-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261011194902.97364-1-mathieu.desnoyers@efficios.com>
References: <20261011194902.97364-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: orxfbkq36ouxftphjt133y8imaeha59w
X-Rspamd-Queue-Id: A14D7C0006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791748147-794866
X-HE-Meta: U2FsdGVkX1/Ymx9+EgmAg4hsIf7aM9YV+nAZlgI48iOMRlzpRCUPsXWvqWYODFKFruGHoAhT07pQgEHgHR5MS5fSXL+jYAV7J3DmxPTfeF7QFEZBNmm2/WTi4W5uON/MN83jij1V5c5k4n/vjxju2cpxBRNV6RR9SU8D3W6SyWVzWXsmxe3qmtIXX1ULyCVf1OAwvq5RicxdzX9d2OjD5tMfT2HAKs1cPR7qvfhLoByRrcqg75zha+OrYGQyPtxWOY1ZtVCPEahBcRHQl0bUNEI5GM2na2I7M82qAP33ECcdNUKOweD4nXCamaq8Enw8n2to7UxewX+z8+WLQI8aE44NJJmUVmeRuu6phN3790aVVNzUvvFnum1u2MgJnS9Q7s6CI0UPE6Xs4td9SVMVdkWwRPcGr5A8ppK/stR+znDzMeYut5/S30xxHARoH7wqjZH9pMUjabr/VGTNSjTRv+Mxx2zwAwnkJ974NBhH1zaxMkrRbG0Jhg+7RzDaoNe2goYFrh74S9AwdaHe9K7CatqvVlmYhwErzsIFpahhUsxvBIhLGRxnTFVMARDCpBe9YB75lrlT3CiEXWhjKl+zU7GthIkhJcIqIRMPOTet0xSOOf2puZk7E3xaNBOEuvBQraskzJ/VD6UBiFkKl5KKU21sFQrmQlPwVMU2lXxUlChhxOM0TpSEMqxUfwxU6GQxrOlvjd/9k02ySQHs4GtgpE1Fwou066kUFjfCI8hFHIP0azR1e3H+u3GuuDcPmX1HnV7VL/v/pIBbDcezInyw4as4WDf+PAjYBvSrt+ozOY0vfxhtvU/GIjNUvp5CVBgeEInLp1i2vOSrjTAsZozrDHDS1UJNkNVQnhkzjinaxvTCEQJqX55fn++IK7OcaljiQwOINFYOFDmPsR4JSp9WoyIfK9MasbBUHsPuKkOFTGXG1lT7k0zdbgk6lJJ8I9jehTCdIU61xz+g17gnc5S
 0akidQlJ
 /J+ZVyT48GE/bjq5+e1iMqlZrpjg8lmNzM+hCxSy0iM08Dhqsr+IeSdcEJywRR6kVwwFXIG1gIBYrORJJObySLdquIhH9UXYLFx9BM5uOp4P4CZn9r0aLVEuuyjhWFf9iLoVhPCo9W9EHYDMfBk+8UjnWzqwV1pSU3tB8sRQ9o0xNPzrOwDxybqAei1MwuGLubjZe31EaNPDnNkzMKM3UNkP9kRfA6v7R5Cdo8gnFJg1m2MbKTjmGVIxwNPqFGisSNrWbLpA8UFDRLmVdMeTLfN/FzzNNSUwAOWs9eJ8GZpq1rXqbFs0/CKnVxsk9xCgKSg3nP7uOodvu814jJ2RSxmv3zsCJcLdJL7A/diq4/tPSG+gbiUnUjis28RdxVfNvCAEcOuOWLx9bUf4eQysRqodyY6UGb5YjYCuS97KOy1GQSm4WQnA0jwKHgrzvAWh4aHVCcbt1WehArkVsNIIjJVfY0S7Ozbp631hDAfrBnnQtMLkxn6wmN+d6TfKoWWS6bShmxvVjjmXvTn/PplTjRtBNIeDhyBuYGG6OF9Zfy3p2P89aoAhwX7TCE/5zK2pIl72sVCVS5X2rrlxlcq/pr8/Q3G3lulLWcy6B32NP6FX6Jv+5m20ONlCtuiOdaoJ2YG7SamQ7E0gd1SgAFLg98q3uBTn0MA3XdplweowjgfiCEqg9EvRAttfVD+FWJwCg0jH5jQxALwj/8unvtCQjQRWW08zA59LDuT1HInEAtP+yX/xx5iGBEev1Z6lhIcZcY3ufWXk+LwvTpoj5Nfz3VyfmxgM+4M+Jv5qwRc5t0334G4kXgD6uJQRDRSuFWcnuo0k68ezqL4WdS5RfWrmX+YO+U2F/XM1dPN0Gz57Tb2IYSTOvawlqqWfhX9R3DhGBxI5HZ7/V0aAJkbbfPr4/GVC+UTmNEZx94H3OognsUh5EW8Kq+y40W8QWKDCrFfNw6IP1yiM29NYTEOaV+dqyYDXsPtfW
 RbXJiKoL
 /HdBLOw/lTlSsCLR164ixJs7XFm8i+z0tnpKHkVsYiBMPA/NKi/vuMhLfWTrHBSXO/Hjjq7V2JRrpYXHE1y+PB+lhYhTkBz0Au65qZQnm9XCqbiDWL4Be4L/ue1szL8uu5kRsAejnho=
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
Cc: rcu@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: lkmm@lists.linux.dev
Cc: Nikita Popov <github@npopov.com>
Cc: llvm@lists.linux.dev
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
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


