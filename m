Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A449E6ADF9
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 22:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DB936B0095; Mon, 22 Dec 2025 17:18:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 671B36B0096; Mon, 22 Dec 2025 17:18:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560936B0098; Mon, 22 Dec 2025 17:18:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4400C6B0095
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:18:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 05AB258CA9
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:18:25 +0000 (UTC)
X-FDA: 84248521770.07.1A5B6A9
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf22.hostedemail.com (Postfix) with ESMTP id 541E4C0011
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:18:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VakcHsBK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766441903; a=rsa-sha256;
	cv=none;
	b=WSv12LGwLvXSbxfL91+w4N2IXWK5A1zZvd3qhR4Rvs0FfLwmvyLHEtZzqdhUfoJ9dA64mP
	/LZxSw25ZT+MhLXH3aWy7Py1DixtmL5DUzZdC5RZhY/+BoFkowukNMvJ6QGw2Q4jTg6o1/
	gghtRR9JuRQSI4OMy5zKtKBY92cd/U0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VakcHsBK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766441903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdqb/JrWPy4gNeCuNrTpT2xWXxvnkmMMxVP8Vk0ZQYs=;
	b=t28//LnBEaI5RX3ZYP7FS2pNnVFnW/tjLDXfeuXHyRQ2F+nTBSzKPLbtDWbScLCVOoJv5s
	m3+e/Dp5061lH1mDThxXI94dc3SLkfrM2dk/fLIlWQMmmw08h72dEh+jam5MOiQw5MnNPC
	4WvLTcQPLjpwDGROyy+G+IoCthN31l8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766441902;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qdqb/JrWPy4gNeCuNrTpT2xWXxvnkmMMxVP8Vk0ZQYs=;
	b=VakcHsBKcYRmNqnVH3KJ1pOq7DuE9CHVpf4ylwyvS0U+2MwCFrJqNoSEYASXIbu/6aZmwu
	2fm80umV+WHHyj2J1NBAw3E6586sEVv9T1ANQfodPg3/6UPY0R8ne8gxwTsJPhdDNwJ3HB
	yV5rmEV7WfIrt2IMbnKyPuAHvoIA7FE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: JP Kobryn <inwardvessel@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 6/6] MAINTAINERS: add an entry for MM BPF extensions
Date: Mon, 22 Dec 2025 14:17:54 -0800
Message-ID: <20251222221754.186191-7-roman.gushchin@linux.dev>
In-Reply-To: <20251222221754.186191-1-roman.gushchin@linux.dev>
References: <20251222221754.186191-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 541E4C0011
X-Stat-Signature: 814mfn57awayx6i8t1thmhjpwdbic3z6
X-Rspam-User: 
X-HE-Tag: 1766441903-128683
X-HE-Meta: U2FsdGVkX1/xqSiNPUIifR38q8edvBl8tJG9MER/lDgf+wGTo/LtKPWX1ro2OiIQtsim/ixJ80xKhffaV/wMqlfpbhKGQ/xWNUuOtBy1LViTyZlZhbk67WjDzGPwBQzuJlrF1BUSH0Baz9mvn5H5K89T4RYq/UxmqB9QlLq8ui+FZVNJI4B4rbuNXeA4Cv29wJk3lr2evzExlVcoGdLs4lhS38dKXmROipw4hivrz9m0M1/Y+cDcBv8c8t0IeXPjajsMzQl+/3LIFwfTQWb0D2H58kSLo38x1Jngv7KWlaQaaq7t4vZuY4ls1KdQ5RzctKkm7dDGFw2JMcaZkjCjGumSs00Ra/IMmEd/pIhI1vXFCh+lBWuKapH5J5K5gLyNtL/BjLXZNKyOVkXKOupB7CY6ODr0YtHrMe2QctoDn/fLDXot4Rsep3fyj2/hnyVRUqbh39R0S5FmqsJtMwUyULsJUb2j16LVLbDGZp5FSSvifnnxGZhb6Qiai644yq2nPOT1yhOcVxz2w9NnWHza2n5YKSCG6dmC/ce5ZJT+x6f53G1BwiLLW4xp3n0iSMDlqo0Fj+qbgQz7ARXuxloFxOtHQdC0VStaeblS9drizsrFkeqQ/1ajaSPPIbUM1OdPjbG6wKiXVMG6ostaFeXwSrtZ919GeqtPeevIlEfhap6+UJCRKXVASgslgnx8ASwGYJt2kjMVJnbsa4XcVMv31usnqvdhBG5uFdL9RoPE/ViyNuutd2ESJR8kw/XEOm+ReXIm7cKGHxPNk76v3kFjDBR1udDU7dfSXoqeQOfascZWu4sztK0hYq+oWgl+JLjBqsl1k6t6QPfdRqgSajKt604K6Ar3jKuMezVPCkc1pVKeaAq+G0fyuEzz5mK1qbWAATqjWc+SEvPYZIls+0d6+L0P4mpHe29hovYupW629ChlynEJGJq+P0aV0/EdcsMmK3wMfKlmD3sa15GhTlZ
 Y9gOPW4w
 xeb1HeusnUmbnklvsL1zTZEX/VO4eoEMzdGqIZgu4Xjd8LSCGnu/TaGNnN2PzUGA3eUm+Qoz99j340S4umt/1VOLUjK9ZjxYWIBafMXjzA9wdwncrMT+xnXkFYjvUq0Y5ISOmKo2wjR0/0vxCpWdCQ1S32dMhQG+otH2hJoGr4Hbm2Hqp9/M8UORZ3fLelp4JGzINbAqLniyY5CxZbQSXff/hPUC8N3Uuteb17f51GjEXoIyR+zjNUp5lkK//+sCQEPTxGBhh1850BT4RxrTf5Cpvjw9fELTvpBBCc/zg7gPOdBu3ipS3WwNsIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's create a separate entry for MM BPF extensions: these patches
often require an attention from both bpf and mm communities.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e7027fba97db..70c2b73b3941 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4799,6 +4799,15 @@ L:	bpf@vger.kernel.org
 S:	Maintained
 F:	tools/lib/bpf/
 
+BPF [MEMORY MANAGEMENT EXTENSIONS]
+M:	Roman Gushchin <roman.gushchin@linux.dev>
+M:	JP Kobryn <inwardvessel@gmail.com>
+M:	Shakeel Butt <shakeel.butt@linux.dev>
+L:	bpf@vger.kernel.org
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/bpf_memcontrol.c
+
 BPF [MISC]
 L:	bpf@vger.kernel.org
 S:	Odd Fixes
-- 
2.52.0


