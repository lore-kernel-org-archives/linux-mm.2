Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E87CD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC11F6B00B3; Tue,  9 Jun 2026 21:14:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6426B00B2; Tue,  9 Jun 2026 21:14:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AAE26B00B4; Tue,  9 Jun 2026 21:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1DE6B00B2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:14:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3D9D12085D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:14:31 +0000 (UTC)
X-FDA: 84862232742.08.937A4FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3E0EBA000D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:14:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RlHD8R2t;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781054070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pb0n/eJX1vGIeSAU0z6olfpVOoRIiAMjbL+eNzYDAJ0=;
	b=8kIRTdBOrpIuhv6YIzXyNft/Z/mayv8n4Y1FX/MZgG3SeDnilye0WKcuJOv3Nz02uJsshy
	7KzK86kd0QVnjkBRwQrAyjOCj2lvvPvFiOUa2zepf+fr2tbgo03Was21Se3FU/xqfT7+Kf
	o3rEChALSi7d/XiTMQvRDoA2C/lZ44E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RlHD8R2t;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781054070;
	b=i5r135XFo8FA0oQ3bCDogv6T8EIELkY8zMCU1XSDfsM8MD9UAHp/yr9sqP3j0VAzdT4buJ
	ZqMAEorHbiuM6bRnyCeXio5Xj0P+mM5iNAOoXbcemv0ewHqO9VrZg/VtnjkY4TBJb7xX4z
	MikDzwe17NJO9v6XrzkearfrOB24aIo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F77E407E8;
	Wed, 10 Jun 2026 01:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4101F00899;
	Wed, 10 Jun 2026 01:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781054069;
	bh=Pb0n/eJX1vGIeSAU0z6olfpVOoRIiAMjbL+eNzYDAJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RlHD8R2tmPn4c+ph6TQwiYaWFXdVRwLlvgGWj9DDOSP38PEXQP4YCZ85EF+s9T0fc
	 kxU1mYxcmac/7lxca5ZVA92AiS8souEpHcb712bJVI6f+5/nqJaz8hSWt9rwsbOcRz
	 xUfOlrMOaV5V8wOjJz7+hmaoHNP4gmAB3DMZGgaAsfqhSPCdbqL5x1JHEOXRhdQqvQ
	 E3iy0LwpVWW8L5pa+YPy5yBFjW6FlhDh04HTskfayNOuRwGcFhUCvqd2k6bsgoE6rQ
	 Bqd577ewXcupCac58o/T5bSVr1sh/pyNl3khldS7tKGQx/BZzYXvs272lgyHWPbA/P
	 3HqYRVid37o2A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 1/4] samples/damon/wsse: handle damon_start() failure
Date: Tue,  9 Jun 2026 18:14:14 -0700
Message-ID: <20260610011420.3018-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610011420.3018-1-sj@kernel.org>
References: <20260610011420.3018-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3E0EBA000D
X-Stat-Signature: 85iwbibn4rujqc1xtrou8ai31jze1pj5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781054070-974361
X-HE-Meta: U2FsdGVkX1+UJtdMRnzm4upkt/hUglIq2amJWQR7JcTwLyFDFigwMwd+NjhgI84JKeGB96z3E3x2WvRVy4AQx6XB8ibhFcZ1K5sdi4/Tv5SkQlAlfV7ybQT0KNmzkQY2rQIryKf4ZwtHXkzpR93sId9TCQ11XYljdgLItiEofxrRCjlnfv+9rAm5uQEX9WM0sgTmYoZAn0KIUzZByxWqlC0+R2eGdiwhMXp9aW/nOiiN5hsHbGsnGL9msZGcu3qazp+QFZLqYMyKa/dvjxL+ebwiAxwRFEGXZOYRx2EhcIXaFjAcoSb2Ayo5Der7rWpfQVn9sLP4rQTOmO+nODKFt/bcjst9bi4BOBTOs6LSpX3oMKunhm4azDLdOAob2IhkOMhp/fGffWYE9ahpKzkdbKh1fHZx6afpuwhyRVPpZbf1RAkBex5164DTSiSyBGVHJNaXTkU7UymSAH/8tDFjAimkd/gsv3xbbLLCQGzeXxfxaOhYKIDsMSYkhsYftS6jRdtm8ipmdu7CF4NpeM0QV1yY5tdmmfTOZvN8xKANx6PkEYOEWc7umFBRTi27FypAPvb/9qTDmGDNr0x9HR/CSkEq/BKrYUfStIeYJi0xrqn/OuX0vw/qpPQAKaFenWemwMe+xuD6HkT8rmMNkMUrJend8ZlNRA2l0n9bZqLkrduso5p8yYpSzve5DGTqyFBCMJrkRLhStvKytkdOKcSaCsdIGtqAfyrrvglguoYrqOowu+8b1lS/VGi2cDogkT2DCSIKm3ll9CnZCFu1fEzJsQ4R3poNxoCUVhHkoo0+aVgbuuC49XQxkAUVjXw0HZ+RPLdsIFkURvN4HhVPKoc+ylCIbn+2YB+z3cqVFTiinZnPXA9IggUAdvnvRtX8gCo1HgRC+OglTDXIztW2q9fPzTTLd7Kk4VQkGK6bHSkeKTnAB5rQ3hvtQv0TErojTtWMi0kPdWiLkobhqD7op8E
 f1GYJlNr
 J1AXhk1OntV6BOBHjSMRtItI0yMuamlNYxYcIM+YB719h1WNaESU0XkL+yczfXoVany6stpg0Lmr2QU4oVL1Ky0tftbwwKJ9W+9W7jsWxjUauG4iO2f/XyUh2Ib59aogkzlC6DA3dAyiSISD2lwQ2czlgseaT3EyB2Og7xw6J8vDFXICBR+qp8r8RB/iMI2uetPek9YiPvF1zrGNCKD1KjScTcGmvpVfvOG8d4VlSZFt+b82aS3uHWDYKmddYJlWujAJXHSxeBubjhmZBN6ORFA+xfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_wsse_start() callers assume it will clean up resources when
it fails.  And the function does the cleanup for context buildup
failures.  However, it is not doing the cleanup for damon_start()
failure.  As a result, when damon_start() fails, it leaks the memory for
DAMON context.  Free the context in case of the failure to fix the
issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo $$ | sudo tee /sys/module/damon_sample_wsse/parameters/target_pid
    $ echo Y | sudo tee /sys/module/damon_sample_wsse/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the third
command fails the damon_start() call because the new DAMON instance
cannot exclusively run.  And without this fix, by repeating the third
and the fourth commands above, we can show the memory consumption is
only increasing due to the leaks.  It requires the sudo permission
though.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260609145814.70163-1-sj@kernel.org

Fixes: b757c6cfc696 ("samples/damon/wsse: start and stop DAMON as the user requests")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/wsse.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/damon/wsse.c b/samples/damon/wsse.c
index 799ad44439434..bbd9392ab5b36 100644
--- a/samples/damon/wsse.c
+++ b/samples/damon/wsse.c
@@ -87,8 +87,10 @@ static int damon_sample_wsse_start(void)
 	target->pid = target_pidp;
 
 	err = damon_start(&ctx, 1, true);
-	if (err)
+	if (err) {
+		damon_destroy_ctx(ctx);
 		return err;
+	}
 	repeat_call_control.data = ctx;
 	return damon_call(ctx, &repeat_call_control);
 }
-- 
2.47.3

