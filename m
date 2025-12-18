Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2E4D68BCA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 01:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10EE46B0088; Wed, 17 Dec 2025 20:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0756B0095; Wed, 17 Dec 2025 20:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAACE6B0088; Wed, 17 Dec 2025 20:45:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A34136B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:45:38 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63EE11404D0
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:45:38 +0000 (UTC)
X-FDA: 84230899956.26.D95B95E
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id BF052100008
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:45:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=mkdnFgaK;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf14.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766022336; a=rsa-sha256;
	cv=none;
	b=MqJ/QqxPMyZ3mc/uzNBdUMX/EecpEUOwjxKDRpwRzvRqrOzz5h/x6LxsMzOlWIhFHChUkp
	WVqACxqtF35QIK/FtrKJRL3xi+fXYUJS9HKx6fx9z+rTJA5UUiRgMlOdOHh/FEwli0zr96
	GkRD3p8IjOyeKyDT3NOUAMw9quHel2w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=mkdnFgaK;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf14.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766022336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJeK9cqUNpduMZzg3p89tCXHZLp8MadqZH73S50Do94=;
	b=e9PyzaFELNY3kbis6ITG1H80QEul8EQUchj4mzvPMM8uqknWkiKmJIO1dZEbXO4Uod0n3i
	ei93CEIgHOKAItNVBydqLxzTCEk6sDzbM6J3kkYuY6n4AxRAn/prgU1c1pHON2pkn5WBpc
	r5J0PW7vY0zaKJ0NvhAkkx/sXSnTWZk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766022336;
	bh=GJeK9cqUNpduMZzg3p89tCXHZLp8MadqZH73S50Do94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mkdnFgaKjBlLhuqIxue0KYz/9ZJLztA9e3N0jMPYgs5sK3ZFq9k3Rv34DllWz693S
	 qNe/HSSwv3uYIwt1oY82rAxKdYdXG8FJb93t+cLWRs94Z0tTgMBN2xH6R6/fYUU5Wk
	 2W7Q06ZRbU5JwrSOrTUWK9nkBpUbRMq2cB7iPEgYFbuS9woWlo8u5D0qL8KeSg/gq+
	 M1mFMI2dHQfyn2UwrF6nD64Voq7KWWKIgIoB7e0r8Jq5hu855qmv7ZzIO0D8ZoZfOV
	 XyvUAObxTjX6MmQjz5VJUQlkxTWziA4X1XaWdZOqwdhmFXHRarjtZ05b0Rpzhc5QTR
	 YfHOE0kxK9R2g==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:a253:d09e:90e7:323f])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dWtlz5wn7zc9f;
	Wed, 17 Dec 2025 20:45:35 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Boqun Feng <boqun.feng@gmail.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	John Stultz <jstultz@google.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	lkmm@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Nikita Popov <github@npopov.com>,
	llvm@lists.linux.dev
Subject: [RFC PATCH v4 2/4] Documentation: RCU: Refer to ptr_eq()
Date: Wed, 17 Dec 2025 20:45:29 -0500
Message-Id: <20251218014531.3793471-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BF052100008
X-Stat-Signature: 1sr7dktqh8s34np5ohen6bwdwxd3koeq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766022336-769850
X-HE-Meta: U2FsdGVkX1+VOqhngUCGpWKT7wASJdvjQAj0oawb3bLU4U2xRk2gp2yenINHMyguHd/IXmiaXul8bKcPbqeAonlHUX4O4xL/8amD7vqNpx6gBMV/qtgehpsBNxbgt6fI9uImKLOGLZI799NRDbtevtSFRWFDBTxjaST5VrDrH8fK2pveX0qGWfWEx/iSZRfsHu2r0a5BOc+14yBzvwZ4xT21cwinxvxUSVp3xhsyYGyXe1uoXYpc9XeiGTqz27rYlxPVs6E32fRh7ZduHRps+WaZO1PvLEZYzrvArpms9YEoMyWwmfkYcWe0pEaPcCN2pYbNph+GxLYfrqvxXZy77FlJWj6qdzwjxkyF8wtlkHf4ii/JQKKsB9+LPvdfuzdlun60YD8igdbyFshmelp9m+A+6uigVQYWDqvQfCPwyM9JXxbi1FfZk8O/gd2G76ItmbIIU5R/89irjtZTaW1xEy/TfQ8NaiKBuCA7+U9hgvIQRkXD0qBH6aZF7BYozH8GtR1rlc9gad8V+Tl6TDMkDIgW0SvQ6M0AetgPzfjZ21c81isbG+0CToFUCUNXb8vMH6R1z6odQEYBdik5N2c3pCbkIPAlv/SFqFkQkyJfX0FzoK18jBR2HlUn0c1IKoxepWWR3u4FUVK4dxK+YaZu2gwxe6KaH4zVpOPpXkNO27AXijEeP1JNnNedK+f2FeqPujembfSPwtC8hrLwkIYfHJ+Cci0SPNuIX50pBzZ+MhntEsV/4+5e8KhLWdh5YYhR6SAWD/TY0GuC0MXygMjFKXIZFr0gvn27cvBvEEAfqxNQFjEbnnOzyP0FKl5xuuSvQpxTEyFaXyTSwcNgwhY19OrfU0RORAqjAs/jQeMye1UITbIK38cYszRRXUJgK1hOD1a6kPbCVjR4ZFPjlhLYhrtwjMkJPnRmcxbHQnBEwn+Fxw5AyqGnPq0AYL7AMndZgXga4lPyujRt4cpKPju
 BII2NL9w
 IDG5P5s+bgxj5ueacK1A0Ak9qsrpfz0KWhRKM1Hhj369R5O+wKJ6tK6/4rq3DXY+L1J96G9m/0A12y2Q3hDtTGIs4qhpzpkuWSi0eLwARMT2S36KpaY+4wv25g0sHslAKYOJlgd2h3+okkkbOTDrKddrD8wfgvz9YqvCPn6R9icxRwty8piMN+PdTkMeUY+Gxq4KtjpZIBEYfjZPFLpqMkTWJsy8XArtVJ8q5EUWwyQcOPXMkBIbl30QlmGLGegGGep6KMgYlROG+h7K/R0sGu7oinA5MLqP3bo4jc5hW1bfgRAO3e/MYN9Bi7l1rCaUdO17CeacVA79ylfSkn44bREqLJ/A099I3VMzr8stvazvfbG7SkaRvA9rl7HlNp0guk17QSi5Nuk8+U5VWzz9/uPc9E/LScdH9TWBfzxiAkIgI4WcuBSgp44Ut0u1LpstGMi6eIR3lclUrzCRvGOkP4UKHfoDgz1m5k25BWWs2ugSCUcO+ZlYGO0lVvaNmxeJ5iFvkwyxa9MegLGc7Nsrw5Lu2KnENdP07TwmO+159psi5Fimil6Bcxxpw9RwdI9SFCw9taH125buReh9sX5Sp4z0dceF4lFD1aDyVTQP25LRAl8lsDYgGwmzBjZ2JibeemT2R4uEvPCMtJ+MTT6VCWvRYS0lboyry1wQyAMyIfIFvk4X65INFqMCnHIFRxG0hJOjzLOialzB2wafAJDCNk+ZayK3jTyQ4hsos9oQE1W4ceJtLCXxYnc8pYsAYkkyJb5mrFt6Up2it9mrXllxgPzJ3RS8lztPDzMuJ/YtK/S2lLS6RT6g4ge7NMa4fY4XsOwbUXu+iFzpKMicz30Tdm6l1mBpgtc+AL8CfGweE0khLk/KZopsrmk80UYRHZe35d/dHcvn13cEFjcHw8KdRe95ihrs2iTnY3QaAqIkslnXxPdnqsI6mrP+nEzwuxIxdU9kZus8ixD/dRysiI/keJsHziLN4
 l/lGjynW
 /aLmSD8PjZNgr2ziE+kbd00vp52yhGARxMDm2sac/UtLUI0SR5vzLLmfATzqxFj5yCnyz7g02tPfZlI8l+bREv8dec5xMqsYxZEMJiu+H+r0TUH6F/QJzr3nHPQYh3ZNrAqgi/xGGusGAOjZl6oFNC+Art1QtV4oDBsFB8+whO/wPsEN2im0Syq18RC6gc/OgFVMjgmfHgE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 2524dcdadde2..de6175bf430f 100644
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
2.39.5


