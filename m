Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92CF8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99B76B0093; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B72226B0095; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E5A6B0098; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 512236B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AAD2F12038E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:31:19 +0000 (UTC)
X-FDA: 84971743878.26.172B713
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BE43B2000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:31:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WTwPePKK;
	spf=pass (imf03.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783661477;
	b=69hu67SQXvsA32aliWCZcwix37ISbZmrfxJcIrTgSSkdacke2pl9gGbyhGw0SPw70xq/X0
	ehUtupj2Eyg1ZId2vflaAx//LJoxn5HoWOD6GhD3wZdt1yk3jhQLZ3DYmxbARgJWPxSsII
	RmUjx8+qV2R62G19K0qZhfdqHXnuhiI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WTwPePKK;
	spf=pass (imf03.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783661477;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TLyFbGuuklzUrw5MTa+nUkArs/G5WrJWz49khOadlA=;
	b=YX+WF5OV9cRX/bYOVfA57Rqt8cghuUsjcnMR/0UK6ZGsnjEzSqU4Uoi9hDPKdgPJ07N30W
	3gbopLl+x9/rItEXEongKZLJgsBXcB2tGpV5Ck2hT+y60f13KsCAirlWmK1oDj/N11DxXJ
	hXBpbH2EWGH4ZO5V4xpfjhgTbSekK6E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7784844FF3;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A299C2BCFC;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783661476;
	bh=N3UNjWOifoQciMT8bRgQar7ekquskU0egj4OqvXH15w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WTwPePKKIBMnJ83AaPUEC7cUUPfM//rKzNoWC2n47+rKDIXlR9KkD2IYKRCa1mz/t
	 y9TvjYaISfnHmEzXrvxC49FYTriD4f+whjvU8AyYf82kRqMBsFeEOiBcRtqNoiQ5e1
	 8g+G2cJ4MMTnvsPAN+bomjEMkWbeakkfHK1C5Gz2/FxmRJ96C40aYePCDqbMgDLXQF
	 2BtA7Dfmgy3giEep4D9XWCziwp/vVufH/gqoaDCc7aYuMHuHI9bQMYOGQpL+zKdO7c
	 3S8FOvIFMxr3JSxDePMPirSxpLd/iEGDFTcDTKtyL92FLuEICXxPsZDilaR59PDYPO
	 Zu+kyupNOvSPg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 313EFC43458;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
From: Eugene Mavick via B4 Relay <devnull+m.mavick.dev@kernel.org>
Date: Fri, 10 Jul 2026 13:30:43 +0800
Subject: [PATCH v2 5/5] MAINTAINERS: add entries for ref_trace_final_put
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-refcount-final-put-trace-v2-5-557cfce860a2@mavick.dev>
References: <20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev>
In-Reply-To: <20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=665; i=m@mavick.dev;
 h=from:subject:message-id;
 bh=qY0jw9qG8rTERqF+Mm/JywN3bXE+e644UzadbgoAM88=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFkBzT1/DcKkKm17S69+OZR4JdNRoG2tTpF8UDNXWP7Mx
 Uyp9nkdpSwMYlwMsmKKLDVZCe4ZK2clGh+d1AMzh5UJZAgDF6cATCR6NcM/I6ODKmyXLLZ/eT5J
 9dAyI6OMB79Djq3a8L/smAyrtc/jXkaGdfeUHiw5E3Xwy0SZeqWnt9eVFZw1Wb+ssaP0hajyx/y
 1XAA=
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Endpoint-Received: by B4 Relay for m@mavick.dev/default with auth_id=850
X-Original-From: Eugene Mavick <m@mavick.dev>
Reply-To: m@mavick.dev
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE43B2000A
X-Stat-Signature: jyjmtdc97xw7aeem3q5ae4oahacye5yq
X-HE-Tag: 1783661477-946238
X-HE-Meta: U2FsdGVkX186A2p8cqZH4sqHGquEsqwFw3RNtko1ASHtrDna9edpG4KFO4iq499mEGJ6MjfWBFFoEBJz8THz7JuhK6lp87+1Z3n73qpI2SvrB/+WkgzjBdHwz/EdB9h+Oy6w+hyJS985TcakhY93G+i3+0ExmtDQTD8NpDAU8sKF/Ly1TzkShmqxiQ7CwielQxzX0zwADZOh6Jh9+XFmTXiNatm1lt/vQ7iQzGwqDDQEose6XVVj98SiM+LSUVpTRh3mYq0P/11WThzYVidTfzVWkf1paCds0cKNzQGvbLGWgCLLNRGulAY9iO4lNm2I7kHeJ6OhuOuED63ViA0fyDYqaAyY1X26aCfxk+EnQEULiSqa6YBcVrX18KO529/tKJDauMKw+i8XLvHPc2NO060dfvzPWdByLQ5VrvC+GZ07VUCv3OpyiZT65oR/hBvx5ahIdDinm652d9UgB+BedOkHfaBKji35YZulkkVR4ZgnDguRJds21fsJNBYV5IfeTfD9P0GUJvd4YoQ5Z8ERiVyPsqxj4UpfwMzqb7hO875Rfb/gAW2IQ17ZlItgwMxH4U6WIu1/ZA8qtBN34PCZV7pNfofE0D1JE9i1cLEg3JFNC0hvr5fBQi9WTTRyeTCu1XTK3M3hK6E6vbTGtstWKKrXi6CykiNkmAQIGWw+PWjdwk6FQ8XJkdGGHq4XJYgRbEvyw6J9Nx72XyDkfaQzex3j+IQv1oiImCZ3hsqGzQOMuoKkwWegj+eRSJjY6jEq4bNYdXP3xvgOFGZbgehU9Am/+wlj0oeiy+GuhnJpquC4o8TOu4sl/rHGjf4Mpd11CSM0sBT1sNhpjuMqhzuttDYg3HyMIHiFcz98ljC7Y09XFg3wwe0M55o4Jy3BuCqblM+RMQsCXbEuLcrOUY5/1RHmnEP63PFhmh96tX3DpLnpK0D+G5PCZfqcH46Ivddwy1L3o582dAjv+uYOB5p
 26ZcE1LO
 xri/Uy2E6aQ0Ti3qkHNazLLT1yQhJvLHbi5Q2YE4cYH7dxtq04shGoshHzoOPwoZRlFep4wleVje+aZ9e+9rNsxbw2VhRAYZsvb7RgxbNq29HEdlvi4ffsvvTfeo+G61p+aQ0QAXCy8YJLPGn6XWLEHbvhyY5hrgwMTktiduVzyWHvWBaZ7KLNgZQS1EJUSLnfEPzoQ4LXiBahnutmQ6yEbzYbpV/dkDWdIz/py26Bhpf8lk/txT8Z+X8ixVdPAVnKUDuqXATNOcQqOSt6Ts8peREHq50wUsgrVw8ouYbaZ4PVs1SkAjMpjODa3mVHdhNMYuXByqA/pOMGjKAycK1Dk4+9grAcvYfuitS5dsgPjTNoTwi0JIhAJv+JJjuepUIw5jLMAYzXZ+uYy49/N9rypnn0p7Ard1lBBrG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugene Mavick <m@mavick.dev>

Add new files added in the patch series to MAINTAINERS

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
v2:
This patch was added in v2
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 10e8253181d3..2dbb7441906e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4210,7 +4210,10 @@ S:	Maintained
 F:	Documentation/atomic_*.txt
 F:	arch/*/include/asm/atomic*.h
 F:	include/*/atomic*.h
+F:	include/linux/ref_trace.h
 F:	include/linux/refcount.h
+F:	lib/ref_trace.c
+F:	lib/tests/ref_trace_kunit.c
 F:	scripts/atomic/
 F:	rust/kernel/sync/atomic.rs
 F:	rust/kernel/sync/atomic/

-- 
2.51.2



