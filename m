Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A6A606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fdF2XExI
Received: by kanga.kvack.org (Postfix)
	id EF5EC6B05BB; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5FD6B05B9; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45EC6B05BF; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1FFC6B05B9
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2AE8480990
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:42 +0000 (UTC)
X-FDA: 85387204644.25.97747A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8E9E680003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fdF2XExI;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553400;
	b=0FkiKl224N2WcW+T1Ki6rFvcTM1CpMQPLA7F4kV7z9aiuLQU8paxftjsDRo65bK5Twx6Eu
	fKsbU0WoJu92i+hdqMp/1kq+VBuPaoXfMLPoELpK9JFN5UIEvO8iToanbe95aUgMHbHc/Y
	DsYO23AQmgKkDqvQ088IUfO8qoP10/o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fdF2XExI;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nl/jwuQeYoLkJzo/bhBa5SyX/AJXXbPvtIr1rgEJpfc=;
	b=sQuLZxoiUQO9mJixOb4G3LY5KVPOiiUQ2d/HotHTs3s2g2/MoiF7Aqk+29VSAvN6qqMqrA
	3CWtJHFA2YjhFfWctfXOu+gWM1HKQh+QA9m+UpN8raaBqGj8p/OkZlKJ27uxcyprX7AiBB
	GEmSWGE9Y4Qb323CKZSubtu7jZThn9A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3511A600E2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37B91F00A20;
	Sun,  1 Nov 2026 17:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553399;
	bh=Nl/jwuQeYoLkJzo/bhBa5SyX/AJXXbPvtIr1rgEJpfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdF2XExI4DFSHn3O+sv2bRhrZabBsUJQa7Q46X459ylwshC4GVgY9EGouNFGzEWxD
	 7/b0UDGTjczQ1VrCbZytoQsIsBvcAZdfq+Wb7wRv2sFGgDsEegfHuygkcIpyoimxTk
	 p7nUr6tmdkBgkXCYtic8otEvTzAWHQ6YFcroqckJe0FYPKJdFvJtRFcTJtR5y/L2XU
	 MO41HI4MHwCPsPu0htndVTEqkLX9Dd+1laq4ujto4zijNAKoVP8dtFHlR6bOxccba5
	 EY4kAgWmmOAaT+f2c2SK+ayeGvSGKxl/9aNrmA0LN1sS3Jph3ZX9tUGa3s1cOs0bhr
	 4l4FatZv41FWw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 5/6] selftests/damon/damos_apply_interval: remove unused variables
Date: Sun,  1 Nov 2026 09:16:28 -0800
Message-ID: <20261101171630.81477-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101171630.81477-1-sj@kernel.org>
References: <20261101171630.81477-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E9E680003
X-Stat-Signature: bmt7p5dp7731ro34w879hubnw6kdrmk3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793553400-519665
X-HE-Meta: U2FsdGVkX19QSKL1ChykJbSlChsaEcZ1WFFzV8/FygSOrqw9DTZ0cgXuK36O673Bd2wJrRs7LP6YE3aKoEb8kRpeLYYxFjepqKcAdkICe20Sa6r7pakZVrCznEEbord1Uxant80AE5JjPxW6MUOUZld5K68RY7zUpa9N2lVHBGCYXGex9BP4oAD1+LU9UTD5GiWkg/UhdlVukzUUIEdG4mJeoCG9EgbHOJXIU4KnehBUteEEKWtCSQgGGVVIJqph+u6cFEokd7KphJsn1kGPSa3oCpuBTWpo+rKAjOlruZabXI5vl235ZLMgY3bAzq/9A4UhCXjZ/lqHgDBHzujMCiYnFA1CrzL4CK6wBUEWmrOO6U0kq/jF7VYu9oavpgvf9rQSNx+tMIVyABOR6ykYiRvGz+GnrZ3mYVyObToS2klYrocGNzw4eQYBO31LmCntEAXY34RzxJKI84kxPXy92j7wpOdwg6xTqKzeyEBXfA9nrGEm+JB7d3/eaaaYf71UCW4YS5qqXrNTOXCUFMuZB1f0PSikfN0sSuJyPM2oKS38D9SUjv94/RIU1F+kLwNDzPNyS5JBxV9DLeaOSRjKNfvXSy8RkWjajL5MoY+J/e25DgE7lIHU3VhqzSvz99XOCOt++XurdsB2wR9EmBtENLQYUJWumElDvXYaMBy00N3MpvTPuzvo8OZeFwcmMr7LeOXKhBeo/YoCKRM26/SvKg4hqGIeklGxILvkzz0QpKz/kyF4krarougpZGzfG74/F4bhH4u3LYiCGaV1PXLNTIX7YHyySn5UC2UNBCj69t8G0pYgWEurvpRSuKkhTLWAte04McBOJFoIGetfBL7WS+6b6337GhrdAmPGGzg3NXZ+flL+ku4RpQvCMtvCDNFR9QshS5GVhuj3WSmWGWSCkvhQTAfqIoadPEemJJQ5zdyyvq1WsbjoLK5Y4TfIYQePMoWExqye9OMxzY9ulza
 ovteZRQM
 pim91xWt9qsdFvLLkkGUzy7SU5u+Naq5IbjFMPCDv885LdUieqVi2yH7dgP/gwetXqDC4L8wHVjaw5BWA8C2WjG/fwoNvhM1ERe8ZS94oHPx9IcPMEJcrerioSAarNqaZj0sEWbJg5U4zxwLvex5r/4vSZ59pHCT+aJh9CWhMPt93rQKVQteiP3E/8lCyOrCZSMJPrt5Vi37gkwL5H0J9IOJE+32OHROFlYuafdMbujKwA+wJwwr7P7oGogNt4wE8VbErM4bNWirR7ie/LIoWNyEWPOMO4XdaJkfI2JIYXbffCYZE5f/j5Vp+m8m9dyQ99hqAGdCWnfapaKZIt93w0sKLIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

wss_collected and nr_quota_exceeds in damos_apply_interval.py are
assigned to but never used.  Remove.

The issue is found using flake8.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/damos_apply_interval.py | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/damon/damos_apply_interval.py b/tools/testing/selftests/damon/damos_apply_interval.py
index 0bf7768b2006a..0ad110be0fb94 100755
--- a/tools/testing/selftests/damon/damos_apply_interval.py
+++ b/tools/testing/selftests/damon/damos_apply_interval.py
@@ -42,8 +42,6 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
 
-    wss_collected = []
-    nr_quota_exceeds = 0
     while proc.poll() == None:
         time.sleep(0.1)
         err = kdamonds.kdamonds[0].update_schemes_stats()
-- 
2.47.3

