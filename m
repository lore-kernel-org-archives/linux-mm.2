Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 620F6CA5FC4
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 00:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 112D66B0095; Wed, 30 Sep 2026 20:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04DA86B0096; Wed, 30 Sep 2026 20:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA5096B0098; Wed, 30 Sep 2026 20:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1C096B0095
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:57:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2131C14029F
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:48 +0000 (UTC)
X-FDA: 85272245016.27.D59F0CB
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7520280007
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:57:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nu0SDABf;
	spf=pass (imf02.hostedemail.com: domain of 3CLC9aggKCLstlibxbkbhpphmf.dpnmjovy-nnlwbdl.psh@flex--skhawaja.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3CLC9aggKCLstlibxbkbhpphmf.dpnmjovy-nnlwbdl.psh@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790816266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yIoi1CTTQE+H6lBdui6vFwHZt26KiAg5p1JL2AMiq80=;
	b=2NUJKxhFpgJOdY3MobHSwlzz07Kq0UpQwgy8jZk/SYyHd8NAPH+YxCR4jdRPcW9DYDD45s
	a7rVz2VsM0eOwxS1fJMBhUgCY4HOD70x5rBmgE6p9Fb2MTM56CjG9SnI1QOClXFPfHYncc
	N9xVE/p5vmygEwA8QJhrebifpFwEK8s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nu0SDABf;
	spf=pass (imf02.hostedemail.com: domain of 3CLC9aggKCLstlibxbkbhpphmf.dpnmjovy-nnlwbdl.psh@flex--skhawaja.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3CLC9aggKCLstlibxbkbhpphmf.dpnmjovy-nnlwbdl.psh@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790816266;
	b=DCzl64oQp5sLg0RXPPDEC+ERR90scmu63XX9YqybgAx0exvidn9mAahDrfkETq+mSIDHGK
	+irPC0esXRB6Zccqxj3gZxtMToSeXKnKAP9bH0xYfaCGJGc5AQ7Pslnu+yXu/PdD18UaL3
	LluXr4mE833e5tc3pxAzWhoaONZRtz4=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2cfa4e4684bso99750605ad.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790816265; x=1791421065; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yIoi1CTTQE+H6lBdui6vFwHZt26KiAg5p1JL2AMiq80=;
        b=nu0SDABf2/BWjBCPMoPjK3v40aczJdfhePeM7MrkT2/3djpsvPK6EMes9gKx2GoEO6
         tVdG99zgQhPzSQNs2qFb4BWh4bH9GRUn+JrjCBzJizqFAbI5sozyXdRxec8aDoyaW+SL
         3txLnUX+QgrYxJP1DocYIqH8NVoaXJ2Ed2lXWXWkv/vhM3CDZlNDpbkYBYG8u88YX0l5
         d2A76aJsxgCFxhVWZ0mZg1pIlBZxSMhlAPy5l/EKzPSVH3/k1cZz11nToK+4ydWnwiix
         LOnu0q6bSdcmILbiFxIGAhgBLusK/HmH/OQU+8L+jd0Pctdb0ptniQNj3aXkzjyTg3ij
         b/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790816265; x=1791421065;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yIoi1CTTQE+H6lBdui6vFwHZt26KiAg5p1JL2AMiq80=;
        b=pmzjq+5/Oq+TNZlpkpNN3mGqfCLwGXGnL7Dv6do9SUb/2FXyTFVlmNBjdd5r6g0JGY
         yTEj7uBFpMw+B0vaWiWRZiBPlYXuOfqbc8SbvtWYosXrtgO2b8aWz7TPAGmqueUsjlRo
         BEQUSSbki0XLx80EBljlBPS1lQmeKev0H25bLI8ynWsifKhil74aC+7cfsRGi6FHyzsN
         hA9j7xtk+Fd4B0Ah2kI5i0aJQNlBtPi6zPDKR/M36a80ktAjYl/7HBAvsTzE02rjA4Za
         zDM4NsOF32GdISZiTYzQAEEVVizJQlVjb3cMUXVg4+vG9z8KjpI/JvbVw7BKgt40KVJ1
         PfLA==
X-Forwarded-Encrypted: i=1; AKwUvBxXFQpOSiTP2gNIihimzqcGaLpRsHygPqh3/IxDUCmNRpNQ7UQItLcPFgNn8mu2PoKWRY1pR8RE2w==@kvack.org
X-Gm-Message-State: AFq9FYIW1fB18lZ1U8HQQ3h6vj5lPlYkpz8EHvWieVdKZaknrT36CI6E
	fjLrP0PcZAnqjYBln5xqg7O5UUz3poj0WoXxgya/IG+gqbxnvVQZz6Dh0dklUHWGaY041DKg5ZP
	LJ8VIWouUG9q0qg==
X-Received: from plan4.prod.google.com ([2002:a17:903:4044:b0:2df:8ab5:8354])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2983:b0:2e2:dc0c:1615 with SMTP id d9443c01a7336-2e2e4b3399fmr25155855ad.31.1790816264954;
 Wed, 30 Sep 2026 17:57:44 -0700 (PDT)
Date: Thu,  1 Oct 2026 00:57:33 +0000
In-Reply-To: <20261001005734.1033516-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20261001005734.1033516-1-skhawaja@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261001005734.1033516-6-skhawaja@google.com>
Subject: [RFC PATCH 5/6] selftests/liveupdate: Add API to preserve a batch of FDs
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: a3tryzbg7obr8yy6184ppicsnge7cpom
X-Rspamd-Queue-Id: 7520280007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790816266-168396
X-HE-Meta: U2FsdGVkX19IYlHT3fewrWpOL+X4ZSfGFgW+tt7PzZ1phh21AR9i1l+f/oU7/Sx08aF6b5tnB1PvrxuuUkdSpogPlpwC8c5ZwoHLKYBSMqn8PvbSEvs5XRF7VvS4VxkxekiTC/9NV/qHi2dvYI4lhGX/36P/iYUnpl6eqQNGNZm6nPZ9ISmW0wsyZ83H5rOPu4+UwVmYgrTLbLAuissdct8tcVnbqzLOQE+ot9qadxxAv3zS4UI69NpmzZZoJ+ZcYqq2dYgqtlh+oZJ3MOlCYYr3pGlddr35lrXUjKUOhb3njSiXQLspuzIxAwzJ/Nqa+y7yWiEyD7flUzQ5C4DgnWcc0YhEH6PbS7KopQUgEeGQmYecvcm6aOkmw2F/JQgCViz20/tatu9wRkjU4XzZOsv7Tq5ASr3k2ReXYyhW8HbM3njindvK/3e3tY3qnSUzDwS3fUUFhJLZOViAEMDY2siYQrlkJOtOtI3IqDf16TbeNnb5PdlIoTYd9R4suzkItXRnamObNQ8k6paRmbwZdFkqERmhtnQdR1f3HQhN5IRGokgkpt15dYD9zG4Xn+AovM/k8+2U8B5rSUjdzUFXi1XX8neeucTJyk92VmFiXATBI83CD3bK8DRGlKBwo9z/yVCoU4tr8eU1Fh6ebo+PxTpbryaHn0X29IewxxafmH+Z9MIOulJanFiGhRaz6g9Wjd6bir4MnxgR4LlgMndkgcHfxWxHxcL0jeRxPRXSA4pzDXU4Mqdl/roM4xGArKZWkvjAGCASWoSyZaeA7F0cpURowq1xQSNzmCNkpD/lpy7GUkv6KeBom9VSkD2cwja2hWUlgZwZv0DJz7+8jf+ysGOBu4VBRAzzKNeO321rDpo90VVuET+1hYFiyt/qOS/4wzVRXRn2C+IXQ+I8jlYvoYWPuNONULnKM2VClYG3uEKkGP6My8reg9fk9zsr53HiBOArJBnfUSaJxFK3PDo
 OU1wL+C2
 +l5GMUOY4SVCf4L620d6NcHHW1qntAI34/ALadRJuleZz6r2xjJv2BvvBLybj1DdIMNtpDm1q5y+8vocebVH9NUWTpvyGOv+JcgmsEZ8cw0sCZG3uRIV5bc6UFT8Xa5tpM8xrrLdvpCLz69ot25EppG8RojUpI2SH9Teeta9j20x0QVJnZ71NDcUAlYfSxcQ0ZEulySLhH6HFhuiiRqdCsaeb3bT0sm6U2vAZN3jH9Owds4tjLtgoSydbKmuwCGsWx7UE6QIqzDe54vGG0ck5InwFH5NRRRs/M4yHPoM/0yEUcJsWwdHucXYaa2CZkKxb1QzLK3dLgC6lXX/UeRP8fvadcocd9tC8FDrEli9c1iP3SgSW61uGl2MH9exNlzC2dqjO2M1FneB35XFjTK1mU+Ap0rYipeMu7mH1Vptzy5+FL1xZEPZiME+6MePtENJn0Hfj/tT1+gXAi4+jGXhGTedX8QdgTY7xTO/AXi39YI+P+o5PAHoOH1OKtBLQzxNy0SW1caGc+rRYKi7MDHCWWSaUF4fToQijTl1bbZQMbMA1ra3LxsD39QwFkB4SK6+CkulSxiRsIAbhZiN6NBIakIVLJc8+EkWQJ977
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add luo_session_preserve_fds() that can be used to preserve a batch of
FDs using the LIVEUPDATE_SESSION_PRESERVE_FDS ioctl.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 .../liveupdate/lib/include/libliveupdate.h    |  2 ++
 .../selftests/liveupdate/lib/lu_utils.c       | 20 +++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index fa07fed08364..9aaf6f28ef56 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -29,6 +29,8 @@ int luo_get_session_name(int session_fd, char *name, size_t name_len);
 
 int luo_ensure_nofile_limit(long min_limit);
 int luo_session_preserve_fd(int session_fd, int fd, __u64 token);
+int luo_session_preserve_fds(int session_fd, const int *fds,
+			     const __u64 *tokens, __u32 nr, __u32 *failed_idx);
 int luo_session_retrieve_fd(int session_fd, __u64 token);
 
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
diff --git a/tools/testing/selftests/liveupdate/lib/lu_utils.c b/tools/testing/selftests/liveupdate/lib/lu_utils.c
index 74d41115c281..1290f27ff004 100644
--- a/tools/testing/selftests/liveupdate/lib/lu_utils.c
+++ b/tools/testing/selftests/liveupdate/lib/lu_utils.c
@@ -93,6 +93,26 @@ int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
 	return 0;
 }
 
+int luo_session_preserve_fds(int session_fd, const int *fds,
+			     const __u64 *tokens, __u32 nr, __u32 *failed_idx)
+{
+	struct liveupdate_session_preserve_fds arg = {
+		.size = sizeof(arg),
+		.nr = nr,
+		.fds = (__u64)(uintptr_t)fds,
+		.tokens = (__u64)(uintptr_t)tokens,
+	};
+	int ret = 0;
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FDS, &arg))
+		ret = -errno;
+
+	if (failed_idx)
+		*failed_idx = arg.out_failed_index;
+
+	return ret;
+}
+
 int luo_session_retrieve_fd(int session_fd, __u64 token)
 {
 	struct liveupdate_session_retrieve_fd arg = {
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


