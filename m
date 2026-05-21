Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910D4CD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265646B00C7; Thu, 21 May 2026 10:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215696B00C8; Thu, 21 May 2026 10:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104E46B00C9; Thu, 21 May 2026 10:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE2EF6B00C7
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD5BF1C19A8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:43 +0000 (UTC)
X-FDA: 84791673246.07.F564FB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 315C41C0011
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F69e6r6B;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEjjWBHpUcq7nMlrb1+WzxDoNOgxUnUZ3YjegNS7FQU=;
	b=ebC12BgEYe04FgEYKPJv4eIORHUSXPmGLGeh6QvSlN34o95dzFerI+WoCurSNe5nd8Maz4
	JGu5LGddXJHRp4yvhBMWHZTXwKtK8LqUhOlN/rHw2lwOrJFQeFUQOXq7/HgPRyt3Iufc14
	coLZ7485rg6uvEUlrZAGg//CB1/xQMc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F69e6r6B;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374082; a=rsa-sha256;
	cv=none;
	b=CwLFJfnkCExO9Eyff9MoGyM/o17YfevxUSBESqVHtZofZpEeBjl07dI90fj5rPal8pemiP
	5jLtXlNvf5Bc7HK+ut3ITXRNYJZ0RL/T1JucSWxjC66c8ruR9PpVBIBBYUZ9lyj/fQ+KNU
	HS8VIora5A1WUiWAwmiJDwb2PH4H+6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C35B4386C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6751F00A3D;
	Thu, 21 May 2026 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374081;
	bh=iEjjWBHpUcq7nMlrb1+WzxDoNOgxUnUZ3YjegNS7FQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F69e6r6BcRcQCE51aqZBQpHoeSZl4Kfu2dFiXgBh98s5RaO+Yn6I4gbHLk3B5vRX5
	 u8tLxKzx9/UVR+7qSApZxy6U1dP/Zbl7MIRYjdMy2UAnkRcd7Y9wog2fdFIyjHSg3G
	 7or+svTc+QKWIeUgNlnrqBuxykLisG9dL/1e+3ob3Jf0zrgY/YzEGKSprH3Ja+SPIO
	 O0f9feCV3NsgjC+qDaXUlHKkLqn6WbtMp2tlVQ6iF4UJ6KlBSmSTB8BG2g8320Bd8E
	 u1aHkZi8MVTrj9+29V5q0CG5V/6bzpsGCIGzumJck+xqaktUxXUvUyidlf71gkqcYt
	 foM+WcAz25B0Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 11/14] selftests/damon/sysfs.py: stop kdamonds before failing
Date: Thu, 21 May 2026 07:34:21 -0700
Message-ID: <20260521143428.83157-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 315C41C0011
X-Rspam-User: 
X-Stat-Signature: nxhfnoq8iwkwo7k3f6fq6ur4bkzqdjmq
X-HE-Tag: 1779374082-674883
X-HE-Meta: U2FsdGVkX1/0S6YcDPGuKXwl+q0XdnmFOiYXYu9QavQP+vkPdEqPYhRR6uFXim3huIa7SnzSttI91oBQmS1EE1eoo7lNbFhACl80DqQ1F0M86ylf/2jeG49HWhTjnkRActdBZuk5MmrZiDErIqkIL6pazuytmkYeh5pwGi6WXu5Fd1kaTS2ZGAO9K7X56P51K+QRFc9fWjNZApRVZEJE5jyR0AmNVF3NFDPitNguvskguJzUmRGgs8+kyP1LUBOURW4QR+iMOCIoR2QZ5W67mPtHra0lpBaAVkIBVAGQablvmMB5zpqjmiQW5SYt1BfcJcd5sg0BXKYYpX4GfrvOhvGp16j0s24I+QpVq4fNGU6duTzQbUI840g5C1xdDwCEHRAVomdBDm/n6BbOcK4oR3jZT5aL6aRxHjiqdb536z4LZz/4dkH865n76n31P7Qde5kjKu12Mj8FUl1gSNuAsOjmF3v2mjem36FabY0hVALTXmg1SB3HGJPT5k4x4hTYTQ30TIhnQ0fN0lPNc+8/iC7Vj3djyhqA2qaluk1oITn1LHAIbSalovuv+S5/oyADKwijfGjci8I73w1SbBWJLwdMTLUTixto/Ptqxit3HTP84dK48hsOttqH2qI4PS7qCJ1AsktJ7i3AGgX6YAKCUaCWmo9Xd+V0rd1hisDB3iT6K7ij6Azz8uIWPsyRvTonf/vyPnO66UinvUU2472HPznDQYl8EftW+1QOh1UKTdeXVw+pfaq50dFZJL6icY4fRFF3HWx64VO7vK41G15JCigErn5OVdJMSgVCqfQQ0rRLtWGoovVp2xYRcimxj8OgveJqqVpokQp42cUFDQiBJFMJ/0oQHLs8pMetPPumiVgowW/JTrAq1nXWXHkmW1RcsFuuEiYz8GXuSlQQLMv+hcdVW5h3g2/+lZ+XksOiJBIltP0TwZ+H8JKe1jGKkDP4AVaVh8lGhHlkuMuKDSl
 kfgvabR8
 2eLdajJ+IR+kTR7+ypDNGbJITKspKnUFb1RbQHELfaW8tKN/dLHpcSkrqhxISDd9fbkLr2r7TFHaNZcPYVS6Iqd6RWcJ/NIsn6KACq0IC2voOhfBXBg9EV03m7mzJ893XJ4TDjqguXq0kyT270FHSslVZuHRRaEt2WlvCXARVrRZnkIDJLmkNZfcV0dpjDGX9EuXyfsoDOTKl03/J+KOX8/eokHKph2akl635q7t8cq3dwKRexB40hvDQR1+5P12B3b775OH1GRXlEKC1PFqG4HQJvQXSu7x/qgfgRtlI4HOkq4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an assertion is failed, sysfs.py DAMON selftest immediately exits
the test program leaving the DAMON running behind.  Many of the
following tests need to start DAMON on their own.  But because DAMON
that was started by sysfs.py is still running, those start attempts
fail, and the tests are failed or skipped.  Update sysfs.py to stop
DAMON before exiting the test program due to the assertion failure.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index cd4d82c852113..aa03a1187489f 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -24,9 +24,12 @@ def dump_damon_status_dict(pid):
     except Exception as e:
         return None, 'json.load fail (%s)' % e
 
+kdamonds = None
 def fail(expectation, status):
     print('unexpected %s' % expectation)
     print(json.dumps(status, indent=4))
+    if kdamonds is not None:
+        kdamonds.stop()
     exit(1)
 
 def assert_true(condition, expectation, status):
@@ -248,6 +251,7 @@ def assert_ctxs_committed(kdamonds):
                 ctx.pause = False
 
 def main():
+    global kdamonds
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
                 contexts=[_damon_sysfs.DamonCtx(
-- 
2.47.3

