Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD372C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39F16B0088; Fri, 10 Jul 2026 01:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11C16B008A; Fri, 10 Jul 2026 01:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9288C6B008C; Fri, 10 Jul 2026 01:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E49D6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:31:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 063B91693F7
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:31:19 +0000 (UTC)
X-FDA: 84971743878.30.4170466
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 267A740009
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:31:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPTbVu8q;
	spf=pass (imf01.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783661477;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MaVer9arWAHUppGvxVeMzetkPe6ZA5O3DBtQRX3i10E=;
	b=TiSEwLCrvrinkgBjwwh5CbhplfXFldKjBl6K0esmsAHtIuT5WeiCwT65Vu0Y+DErJAtbda
	bEZW9vxWkrJjBkBO7r7iPkJVRtDyLLOaGzHouX8ostdRcY75R9W/fNPNRPPLoLjX6ta1Xk
	tcDoNN4mQEmVN3QM5Go99bex32bOHP4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PPTbVu8q;
	spf=pass (imf01.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783661477;
	b=xEXuhHYAYYwE+3RTBEaALkAKl22JuZnbVQlGXUoOgTlyRNStXY9rm9mr6XW3oLxxayeHEB
	VKEesEyqGbxf+qFvzMjdLp+fI99WBzFA/At+wSGtkBS8iyFqdEVcLVUy3+Xi7DNEZotiXT
	xy7ZeJI9lz4bdauKiMd1dK2elYpvA0w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 58835600C3;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07B20C2BCB9;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783661476;
	bh=F+56U6C6KuvEh/81ka3tRtqh4dyvZl3JiYsBpnaflyE=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=PPTbVu8qHE0mx5v9UcIPNs5BFLXPzwWihcTILO098QXtbkkne0slwGtCOSVDwFIMx
	 h/j3/ekIbQuu5FOvd1F2vdGF6mPUfTKycmNhLU8F5VeL3LlP8UZ06HTMEY+5Wx9du9
	 f6QU7UioNEIsp9vQj6QmzC8LTGy55WYvGFNvSEGsc3vMH64fZOfqFMNXpE0AyvQR+h
	 OPaOS+2EyjLnmAWQ8nUuVAY19FRgk5CLMsGcOPuCPl9+xWGu2oQd25rDbqqg45yA+0
	 Xd6xqVaA/WNeYTAXF7MeaAskfRnNbCV0UkGj8WcHPPok5maNJupRFfXGwuuDStR9GT
	 UT00LMnl7AVhA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F49C43458;
	Fri, 10 Jul 2026 05:31:15 +0000 (UTC)
From: Eugene Mavick via B4 Relay <devnull+m.mavick.dev@kernel.org>
Subject: [PATCH v2 0/5] tracing: add ref_trace_final_put tracing
Date: Fri, 10 Jul 2026 13:30:38 +0800
Message-Id: <20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAH6DUGoC/53NPQ7CMAwF4KugzAQ5aZpQJu6BGNzYhQhoq7REI
 NS7E34GJpBYLD3L/t5NDBwDD2I1u4nIKQyha3PQ85nwe2x3LAPlLDRoC1YbGbnx3bkdZRNaPMr
 +PMoxomdpqpqcL/IsUeT3Pl+Gy5PebHPeh2Hs4vXZlNRj+0IdfEGTkiBrs3TGEqpGu/UJU/CHB
 XF6lLyF8ofgiQCUsdpi9Z+ARlHREPDS/ikAclVYptqV8Clsp2m6A/C+Nx2HAQAA
X-Change-ID: 20260624-refcount-final-put-trace-49bd7c39bd5a
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2130; i=m@mavick.dev;
 h=from:subject:message-id;
 bh=F+56U6C6KuvEh/81ka3tRtqh4dyvZl3JiYsBpnaflyE=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFkBzT2nTffvL220YFjqU5G9671GPtP7pTwnHPj665sea
 V+MthXqKGVhEONikBVTZKnJSnDPWDkr0fjopB6YOaxMIEMYuDgFYCKc+xn+qQh1Rf5p+KvZv67d
 RjgjT/Hwv0U3T1fafTyl9LhojQvrNkaGB9U7Lx3R8z05//qev8/ZJ76TZp7dJnnJ4vNylqXXXls
 HcwAA
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Endpoint-Received: by B4 Relay for m@mavick.dev/default with auth_id=850
X-Original-From: Eugene Mavick <m@mavick.dev>
Reply-To: m@mavick.dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 267A740009
X-Stat-Signature: 3dunyi5upptefrx7jubhs48n4xyecfpq
X-HE-Tag: 1783661477-430206
X-HE-Meta: U2FsdGVkX18iC34u98eCbe6sDOPwkp5TvXKX0PCKQG9rmvxRpQQL3dC96l8gntktd2AzV9JCgx0FrOBqc6hEhvzAT5sV7qZGnWpf7xTofXX+I9ZzHuyrnhNNIR309FajYxticKphzyLsSpGgPvjYEFrczuRWtUi6pnnbEUTKaKa32FvxF0Scmj3MVTkav3KIxrNqhqp5/Rhg1W0R1XaFJhgcVhVdgGIiYWfVFpmXqaXClsmphp31lM2zMK6huox3D706vjtIC2kb0ZrIRFZa7VH8rnJHLfpKdL/kMe0ykteeIEGDSS7q7+dKVNvsReCZZdSiC1drbwKFRhMzl3ObM5pJWm3LpSrZUF07kkqJAQE1MHhXwvPpu65uIe7t8l4VvoDDeOuFeWTZEw2TueZ/KKlCLoh7uQzhyMWSQBxwxc3R3qoTHccXYQYNROwDUbixsKjLP1v1OMsKMHh1Uor3VRwlUx2YeTY7MWTCSV5GHxn3btsKCPnqy5/SUdV6syvXBw+ten0Tt/jYv1701qCn945sROKQ0nw2BIPhIfJnSO9pT+rAJY/XVA34MLKS3d87Rx81riGYRPb4Tp0pDg8sNK1kcezze0e8p6g1TMgpk6rQzlOLr0DGNZR2p8NYfDy06HUpPn2IZTDbcyqp+xDfJ5whjm3WhBdluy+cHTMvcxE4UA+li0JC6iEgbCcDJquplflfKIjq3YtsuGyjNsiIIcdvs83fq5EpnaQzJe5WRDgmhmy12vyb/5DnIgmlJKwTI9O+MowkE42LtLmAEd84hg1WMei+VXBiFl79K6sMvdvWcxoCe5iLHMU2QVHCH4ruz/577jAs1vRLTdX+HxMsGtW4gHmbcD2To7sicDo6TXTNUQpgx3dzH2M9YpnRpmXwxN6mmWgjpdJH85fL16kotUUFv6wVCPst73hfFCYIuQtdDZMZ2ZVIZmntDC+BEwMowm3ywZP3pDv14QdVDPK
 /cCMwJb3
 jEoTLOd/pz1HY/R/rxfk3LJ135jPbv8OkxY4gNewwChHBb/8yJjUuL0LjmK6LcB8rl97B3IeCEfQ2VpSF+U1Tn32CFY+ugKR3p7TznonsNk8qit2phq69tHQ6sEooFXTsir5uZeCt77OqzkVWf0na+yIib7ORie3WzzkYFNMkeHOr/ocO5iv5qrdsVE0U3rjfF/z+rbQ4HE3rG9FeZ31TLADmSuLivTV8Wob/uG6isBSU1w+ZHukkoj1tIiJp4cYdpvEEQYiZlDFa5BmE49958cKE77SGQfzZOZiogi6qv6MxKPvmvfGarybReMEyNo3N6DBQ3lGoiJQObNUpMpTGvH0HXcGyf0l1EKvhezZA2f3Wd9K1d+dG47tFFLLH6b5veFD+sIWmZmwyfs81B1UGoilZiyOA0SiAJ1DFYdzSdKUqPosKGP3riAD4loddadTp+buQoNtPNIhFG74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When debugging use-after-free(UAF) bugs, knowing when the object reaches
0 references and enters final release can significantly aid the
debugging process.

There is currently no universal way to trace this information.

This patch series implements tracing of the final puts in the
most widely used refcounting implementations,
refcount_t(and thus kref which uses it), and percpu-ref.

The tracepoint records three fields:
- caller: function that called the refcounting
  function(refcount_sub_and_test, percpu_ref_put_many)
- fn: refcounting function(eg refcount_sub_and_test)
- obj: refcount object(struct percpu_ref, refcount_t) 

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
Changes in v2:
-include/linux/ref_trace.h: change macro name, use direct tracepoint
 call in macro to avoid double check
-add tracepoint to refcount_dec_if_one
-kunit: make significant improvements to design, fix critical bug, add test case for
 refcount_dec_if_one()
-Link to v1: https://lore.kernel.org/r/20260705-refcount-final-put-trace-v1-0-0ae936edb750@mavick.dev

---
Eugene Mavick (5):
      tracing: add ref_trace_final_put tracepoint
      refcount: add ref_trace_final_put tracepoint
      percpu-refcount: add ref_trace_final_put trace
      kunit: add test for ref_trace_final_put
      MAINTAINERS: add entries for ref_trace_final_put

 MAINTAINERS                      |   3 +
 include/linux/percpu-refcount.h  |   5 +-
 include/linux/ref_trace.h        |  26 ++++++++
 include/linux/refcount.h         |   2 +
 include/trace/events/ref_trace.h |  46 +++++++++++++
 lib/Kconfig                      |  10 +++
 lib/Makefile                     |   2 +
 lib/ref_trace.c                  |  12 ++++
 lib/refcount.c                   |   8 ++-
 lib/tests/Makefile               |   1 +
 lib/tests/ref_trace_kunit.c      | 136 +++++++++++++++++++++++++++++++++++++++
 11 files changed, 249 insertions(+), 2 deletions(-)
---
base-commit: df685633c3dbc67441cc86f1c3fee58de4652ba2
change-id: 20260624-refcount-final-put-trace-49bd7c39bd5a

Best regards,
-- 
Eugene Mavick <m@mavick.dev>



