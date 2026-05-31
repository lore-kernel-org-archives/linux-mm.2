Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5745CD6E56
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 09:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25F406B0118; Sun, 31 May 2026 05:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2362D6B011A; Sun, 31 May 2026 05:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173D86B011B; Sun, 31 May 2026 05:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0933B6B0118
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:18:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C75C21C070A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:18:31 +0000 (UTC)
X-FDA: 84827164422.30.68815A4
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 47ED240003
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:18:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="m/6br8Pg";
	spf=pass (imf11.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780219110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6imuRvcJ2QoeCub05D2ebeR8TkoLAgpZgEl546Rm/CQ=;
	b=hkP05bkP8KWPwkZC4ijvxVMZQbQ355xC9EDJ7IcmbMMjCX29bQNfvO9P4kNKOG8I/WfHvK
	mQvqU1DLC94+1LMbxmyqrpPCHtJo885MN8tk/iOLW5f5fklL2gbLq0AJqnYJxrW67Vp4bl
	YpEt2HjRWsUyvmL/7s6lCIMMJ2KP9/g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780219110; a=rsa-sha256;
	cv=none;
	b=Zs6HC5oJ6I0fpA1N8/hEUxhtAjkGAvDLJy0fqZPHocCMG3sAwfTlX2M89hl0r/nzln9fba
	4x79bneeF+e5HMx0CYXhOG2fzdP+cXrJAzjb/NKB1r8pWmSvho40FQoBSdaqpeAf3w6hWf
	384k7yJsmWD4dyJT3Yrb1Y+6K+ax6ZE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="m/6br8Pg";
	spf=pass (imf11.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780219108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6imuRvcJ2QoeCub05D2ebeR8TkoLAgpZgEl546Rm/CQ=;
	b=m/6br8Pgr0pSniSxeY58mcipn8VEfCt3UaNwBwtJEymYbqoFWlk6qwGw8qfuifnrCdeHpo
	6VJMZjHCwuuE/0/WMTjdnzfp/9HuT+62jbfWOGUWa2GIoXldzjZHq9ctR6xLEc9/FmgEcT
	dqMzlsvuNJgGsMSsL00C3XinN4F/VGI=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	shuah@kernel.org
Cc: damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH 2/5] selftests/damon: fix memcg filter path handling
Date: Sun, 31 May 2026 17:17:21 +0800
Message-ID: <20260531091724.84381-2-kunwu.chan@linux.dev>
In-Reply-To: <20260531091724.84381-1-kunwu.chan@linux.dev>
References: <20260531085633.48626-1-kunwu.chan@linux.dev>
 <20260531091724.84381-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 47ED240003
X-Stat-Signature: wrdwq7cguhpitdt9wwom5iqsndc4qjad
X-Rspamd-Server: rspam06
X-HE-Tag: 1780219110-726412
X-HE-Meta: U2FsdGVkX1+lAOXHGUs6oI5fR6DPPTzLqWhH7wB+3oTnozmRZOyX3OSCMwlxGx3uTS4fQA8lx4IOlzWLE9YUJKtfYvJYA/OxdDbB95BlQeweXN7zbzHofLTBzjz2vBy6GQ0dwEkJv1Raml/epjNiTeZ1b4uV/vDaPRA1PiVFAmF80JVvmGiWpO8v+FYLsc7dE0Gy/NL8bWCZVPuS4HOVU/z81NO7LIH2NbldCkOPjAGUm3E4CYKsgQJVTIHtbvoi5RSWk5lg6xrE92htPjZ+LDUXgoICaatsKVmCcQktu47g/etQlvR6fJDmdS4UQSKYdefk+PDkzYAQFkVrpVRyrOkfFt9F/OkAtwkfDHmxWJgFuB7AgiRNEwwypJRi0evIIsnVVUHOT+W1Iq72V5PlUix3fptJyXC+MZGgXM2WKz9R8sxTQenDoCs+ulZ6QXTYZFJkDobtD1yZzT0eg2OrQpXfkvq26CWCOO1DhAdnUw+0jE/WmQS9dc9aK0rgMCdvRYDJXy61iVmQWNWtN0NWvK5ZFnNF7Zqa9EB5pxhdZcuBbrR3HxtAAfQrqZForeFohQMGuEfsbIvx0vEyluRixRcUtTqoa0DvLYyvn+Uw6k1pmTbbx+a0ELeOorTJeuwGlEisu1h8yuUY/IZhDbmMIWLQ80bnEg/oM6HzDSydFbPJUUUF1Pmjb26UZt/vTu8YqyggwkLUCjjbNuDJSc7yed8AInD4DgYIJj5rDUaJzVyAp+FsAadfdaP3UhKIyaZrSIOmWhfT49BfsauKrF5+M/SUeA6V/C465CT5cz6i/Ci63M+MOnmX+09uCbLa2Qt99L8OfnA19loJfHlcjnvtEaE3JSLB0UdAFVt6E0ulOzJUVFz//FzKyfD/5dCgGEUQMgMS+cBlQra8+e89Zq2vdjXMJ6XMqtzatNGWos66Poq5UxdY88gqm1JgB34O0DK2Ebioolh9mRfdk5DVgZb
 /na4yuNj
 deOSO3DIsBpdEvU4lipkPHDpkE5VtIn5jPrcMWhSrydXv6UkOPXsT4+y12d5FFRvVgSnsfdAzbkNpM25Wg0qsBhsXOHqnRwrFkwRt5eE+W/JMCYeNiHXH8U7498YkEjHDMSSyXhCGq0IygPYFSDWHBDocp4FOhlAK+PIBMqEaZvePfQPOCC1vOjmohVErJ3BJx1RDDytzlf5jaVPQaXU4wgC8BI78fWBBR/hI9Q9CH7pYN2NmYnto3EHKnKvhdOonNZ7s2LpFm09riqj7JV9IRrwVVqcDZiyCyhQUsPaz0w4HNf/KTf4PF6UfNl/CxsHkKQLRwCfy9D/xqL0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

A trailing comma in the memcg_path assignment makes
memcg_path a single-element tuple instead of a string.

As a result, an invalid value is written to sysfs and memcg
filter configuration fails.

Remove the comma.

Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 2f6f2699db25..006c92a76ebe 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -271,7 +271,7 @@ class DamosFilter:
         self.type_ = type_
         self.matching = matching
         self.allow = allow
-        self.memcg_path = memcg_path,
+        self.memcg_path = memcg_path
         self.addr_start = addr_start
         self.addr_end = addr_end
         self.target_idx = target_idx
-- 
2.43.0


