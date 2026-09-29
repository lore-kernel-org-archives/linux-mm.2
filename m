Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90C45CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C12C6B0088; Tue, 29 Sep 2026 09:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999E76B008A; Tue, 29 Sep 2026 09:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6836B008C; Tue, 29 Sep 2026 09:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F25A6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:13:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F1F71A04E0
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:13:40 +0000 (UTC)
X-FDA: 85266841800.10.62907D2
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id 66217180006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:13:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AeIPBUqI;
	spf=pass (imf06.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790687618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qCT9DoPWiXJMvBzM02aoXjnaw6xD/j8g116oRTfEDZ4=;
	b=4T7ce3Y53gUVKpnJp/VljhbbOUi2jlucPjzxtS7eqMqUvf++mphaJ0bFHh0Si/F3aalzYZ
	goMrSeinnUa63B5lvlZftfkc9dwGkl7Jn97xYf2oFsU+QJl7u8JsYlCSFy/jzgsvZfo0Gh
	1dmPy4LnOHJ1KzPsPG0zKvn9i8IdoPk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790687618;
	b=6ryyGqurzQde3fEbmQLISAkPauBRz+KYFsi8uXof2HY5aeBXU/sZ0wdVRic+wB2VIOhYrr
	Qz7yBIQ+I3aP1Gw0bzJzJZAbux6VDX/qk36j4rDI8nLALCK8hJExegMO61ho9air6sCLC3
	6V5vDNYky4NLPJ/njVhBEyUn10UpWHM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AeIPBUqI;
	spf=pass (imf06.hostedemail.com: domain of med08elkadiri@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=med08elkadiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d391aso31535105e9.2
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790687617; x=1791292417; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qCT9DoPWiXJMvBzM02aoXjnaw6xD/j8g116oRTfEDZ4=;
        b=AeIPBUqIHsyW4p35HR6sxdTA2vPZ3cPp9rSgnqhHTxMecRpVoP7vvB68v8sjikRgS4
         5nyTCNAXPJwTPLTCZI74AqOaHbo1vRtARKS37c3gLGVjWCs4WtKWD7EJEkGYrQWb5PCv
         7xUWY8j7u9DYacJssKuYfD7wYuLswvPWIssDSYc6gkckF+ZtVuS+w+iYNM7QZAuq809i
         h7YPlvZ7TLiLGwRW8EgVDXiZW4+bwoiCuXjm8Ogq9H/cFawzTNO8vAOgsw9aLSmubaB8
         KAnhBhilHPRAFEaFuWruWKWutypzQXoet427YT6T3eSfMLPIUlMfGmczrEanKTDjUEca
         0Q5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790687617; x=1791292417;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qCT9DoPWiXJMvBzM02aoXjnaw6xD/j8g116oRTfEDZ4=;
        b=iV8M7hnn/omW+k74YvGTy37/3bpQpH/KUGmunk2DcI3e/E+ajXTx5/la/l80+KVqCw
         CLZsOjR8epMxo/mRQrvQVWDb28BVI7pLbnqeEbOBfWmdueTuOQX/cvIuMuMb4a2mDRlN
         3jc+v3nv8f97INpVHwgPWCHHnC3hxc3Tzun+3hYMsIQnJ1Fl2R+EDrHCIntle8eoysQo
         TH6TzK1lUfTTQiu0gHePMZ34qSVY56wUGvy8xS3rJO1lqAc5hxEAdE4j0h58iMsuZszi
         noerRYKZWNW6Cye4ruWAvrYOYMzFxmPqf+DLIWVDUUMDTEJWBnhfbx4Qbc74qjEvJUv5
         JQfA==
X-Gm-Message-State: AFuF++mgA15l0BIBA4nmXjW0DnMDy2lxzmCPvJFgKuz4v+7XGDzKnHUV
	N2yfVYsLCpVaqxO/MmzNxgEbVSlObVczqTKjoHk5AFMuAkPn8gcgwmg=
X-Gm-Gg: AYBFou1xQ/+ZiafvQfI0uGhnuX8FAKsLOzuF/vhShVoNHhaXXT4JPor+D4+0pt0cfXr
	ncBOJoNJi9BueDPWPcaTEipnCe66QN/DWZlStO94spEzT1Z3aeamvxYCYkMWAe/1twFT7oGN/w/
	3ntGHWKFyOwo4xo9wGBKmGMjwSn9EwRM7PoOOZIJzp6RWUigmKmpArbfleHOf/8QiHxZJJrHfqR
	3yETgMn20g5MLxfl7K/rK46++hnLviMo/c2XUhbH9ht1FwWBb4YVK7K0BDMMATUYXiGLAwwYq9r
	nlXpOF/D+xH0K8jLxtv3juH9Lgev5WAipwQ4q4sGydIa/qw9mTA/jwJfGSsEemQgbHnDFSTLswN
	a4eNCRMmmvS5EaeFKNCje1/nJwtuiW2/x6SYePB2Y0h2Q2bFr2Mz7A3rwYFIRXnMn/hEW++3e23
	PnyC1WkTpEuoAkvuqeVnm60EK/L0AZwHXDnNThqm00H24NmTnxPtkifLffruvP51PY+pe0LOJKn
	4Bg4gg7uZTETXDCzyXCehygqB88x30KxOGnbMXR1HEveorAofUa9FcAfnn72yY/brGPvYtHxbiz
	YC/hjzM=
X-Received: by 2002:a05:600c:1d1c:b0:49c:eb16:9fd with SMTP id 5b1f17b1804b1-49fe66c9ae3mr274819225e9.3.1790687616568;
        Tue, 29 Sep 2026 06:13:36 -0700 (PDT)
Received: from Ubuntu-2604-resolute-amd64-base ([2a01:4f8:13b:86d::2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af5049419sm3566825f8f.14.2026.09.29.06.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 06:13:36 -0700 (PDT)
From: Mohammed EL Kadiri <med08elkadiri@gmail.com>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] shmem: fix unicode_map leak on remount with casefold=
Date: Tue, 29 Sep 2026 15:13:24 +0200
Message-ID: <ba38f80f629fd093c77f3a49fdab7b71ee7bbc5f.1790687276.git.med08elkadiri@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 66217180006
X-Stat-Signature: 4eowy34nrc3in53xopmmwbakzc8pbkrx
X-HE-Tag: 1790687618-163760
X-HE-Meta: U2FsdGVkX1824GIuLE5cfwl4u1Wu/lC4HojPab2hFV1tiR/PQuSsReNapvQGmjj+UBVx+YUhH6Zdwck/hGD3Wj2aoSN9o1XE1eJnb1rqmIPhS+jMrNRHkbP+ffd9K/dXDJC/Du42DyvBmtap2nk4L0l+yXtAB6wI8Z5UNia9zvHijd8NHHoL0cysRz9FnAoU4Ifgw5g59846D6dxYUPiVdqGwIQ7Z/AWUFjWpMG9nbgarAwdlfP6X0tMfkYCRMC/a2Anh2WdVh8O7pd2dwrysn/2u1EmPEjZvftVpcxDbddiT9YKsuR76cTWhpw2U94ZYFDLWWzFRYgw9fHImIR1FmEe3Atk/qs1G0dbINX0HB8xHxVfWwwnIABiBZ/cSWiE5pXV7kP7MCDIbspxhcuYlGKVn9iiFxIa6ahP4RyhMMA4mq/VHzrXqG2Fn8UD42rQA7KKxjouTXxNaCDSzJgklPiDz3gbtpVnZ3LroEuyVkLESwrm76wjvKFsKOOk+Dm6lrf+el/hncHZ72axULOMi/U35wa7MSOF9/vStUn4JZSeiCVMZHDyyqVHELaaV+2GQdEmYkqWWYHUj0N5147eb9ReIShCYt4FdO8QaIhzX/OUARjOza+C6lTFaCC09JQIy8/569oUzzPWpGDaYX7uQ/azGkC5nPClQOPzvb8RYr43WeKWDvkiQyMAHj+u4vumbzr+Rdv8N7QsewGpPWtba6nhQ0sJOV3jqSzQrHQo+Hlk3Zvkrpj3Tdn4JffLNX273DsURBb/jgRQaz0cBUZRr3u8Iq8/p8hpHEf98h9/4AzVwyHU6wsLZoyFyLqxIpazsV66TQqPEWMcExThvfDHKWl27mzmbp9S22JycaaEkCTrXtWAC2k02pG0kKzEbn+W4dyXuCZywMlfnwwghb40zexEcxNT5L1Ww1378a+m8rsr0vdiEe5lL2hkRcEoawzkqmCzfJmNsljyJe767D9
 9SI3TUig
 +UKngwhPkfZc0WAHrFcuA/2dd+MTzRBOnKr/2VwcFmyEFNGouw2zJlQtBOh0l764oGB9e4IZITIPXMkuFU9Iff6E/kwK7NCv5r5sHH3K7iO78wQlbJQVx8lfOAEpHCnVqkB+gdPwXGWg1M45SMPBafFaHIjCeDxzFN/7vZsx2BEK6eQmunWJ+ExFvCkcg0rB8lSR6Xq3b20BC1imrMvEUFnRzU7n8pXTDc87N3tkLW1dvgv23kCpxqkg9DbYdEUfb65oFAQaXfsFvx4UGEalT3j3eUvkE24bx0Isk5f7D6SSQSSDvOAs+RHXd0sJ2h+eXt3HBgwraoD2h42SBgOW+r/NeOB4fQa+LscfaEudMIfIw+V+g/LjIGOrE7Jt2c1r/E9Di/OI3aBIcMlQKGnzgPv2L0rkTXVtMQuir1vg0G/qbDnuU2uIe+0c5fPvInNGg67/MP7E+iaB134KgYpxhcqfm2p6VN9rfdMJGPYvbAXojtf4M7UC8VuZBUOPxFlck9pxb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem_parse_opt_casefold() calls utf8_load(), which allocates a fresh
struct unicode_map, and stores it in ctx->encoding.

On mount, shmem_fill_super() takes ownership of it via sb->s_encoding,
and shmem_put_super() frees it with utf8_unload().  On remount nothing
takes ownership: shmem_reconfigure() never looks at ctx->encoding, and
shmem_free_fc() only frees ctx itself.  The map is leaked.

50000 x "mount -o remount,casefold=utf8-12.1.0 /t" on a casefolded tmpfs
grows kmalloc-32 from 660 to 50574 active objects, and nothing is
reclaimed on umount.  A tmpfs mounted without casefold stays flat.  With
this patch kmalloc-32 stays flat too.

Clearing ctx->encoding after the transfer is what makes the unload in
shmem_free_fc() safe: otherwise a failure later in mount would free the
same map twice, once via put_super and once via fc->free.  This mirrors
what shmem_reconfigure() already does with ctx->mpol.

This is easy to hit once casefold= is reported in /proc/mounts, since
mount(8) then passes it back on every remount of a casefolded tmpfs.

Signed-off-by: Mohammed EL Kadiri <med08elkadiri@gmail.com>
---
 mm/shmem.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 07b2855dfb7b..49b3cbe0c324 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -5202,6 +5202,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	if (ctx->encoding) {
 		sb->s_encoding = ctx->encoding;
+		ctx->encoding = NULL;	/* transfers ownership */
 		set_default_d_op(sb, &shmem_ci_dentry_ops);
 		if (ctx->strict_encoding)
 			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
@@ -5302,6 +5303,10 @@ static void shmem_free_fc(struct fs_context *fc)
 	struct shmem_options *ctx = fc->fs_private;
 
 	if (ctx) {
+#if IS_ENABLED(CONFIG_UNICODE)
+		if (ctx->encoding)
+			utf8_unload(ctx->encoding);
+#endif
 		mpol_put(ctx->mpol);
 		kfree(ctx);
 	}
-- 
2.53.0


