Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9316C88E41
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597DA6B008C; Thu, 10 Sep 2026 13:37:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54EC36B0092; Thu, 10 Sep 2026 13:37:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 398F06B0093; Thu, 10 Sep 2026 13:37:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D56C6B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:37:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 796EA405CD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:37:06 +0000 (UTC)
X-FDA: 85198558452.30.FE681FC
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf21.hostedemail.com (Postfix) with ESMTP id B50DE1C000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:37:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bWqkIvER;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3v-qiaggKCHwxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3v-qiaggKCHwxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789061824;
	b=ZgpmwjX41zCIvgUNUjV8nwAENVSzFAPQOQpD3FrTgqDboqMJ6UhraCyWEsi1zpN/YQq6o7
	vkTYwAyH491WfJZZtxjotBaQhcepR0cR2oml5I3VyF3wIUOq6pYRbPi+Gj+4g8dkv7JbHu
	HXhP5GaTh9dJNBXJarwL90zRJr1hrSI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bWqkIvER;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3v-qiaggKCHwxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3v-qiaggKCHwxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789061824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucrMBG1dtLZNncX3iBo9nVwxchXvhveT00DBodHEBe0=;
	b=0/xc+n838YsdHyxmRBLa1AAvr7Ao63Lt7H49POAwrRu2fmFdyWa4PC/6H94UzpexYELxOj
	6JvIPKmex/keZ0v3ENjEU6IjtDmUUIgKVjjjPbT0wpf8LOtlrpIZhbEsmbUFCxm6AGBr5q
	OSB7kJPHhhlyFcbo7kFDCP+Ew0uOZ5s=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2db8e9fe9c7so35737435ad.0
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789061824; x=1789666624; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ucrMBG1dtLZNncX3iBo9nVwxchXvhveT00DBodHEBe0=;
        b=bWqkIvERFouxmm34Ts/qwR0BhBOo071jdSauyUvDYMw/UXgKhBDMa/ftmcI3xB/cPY
         jBPo1636uomZ7+e022asxPZxZ0wkfuihQ3vZ4UGLx2r4aRMAEsACJ3Sb5Xmy+UdC1bQg
         41+4loIy5gaf+r/CO6gkCkm775PVrG7aHq3CkXv2iplrqRjOiMuXk+QpD0R4m3U2WLCw
         H6pM3m/oKehFpY6e24SA3paJ8ghgLnZGhkgDX3Gx6+PDCLtJHcYHABHSyNBbjJcH4aLW
         ETdnfYp32RHTxBUHt1PgPKs85ksWuS3WJHxVN4JsjQzSXv6Y1w+ox6r1ZfRCAUQ3BBOj
         DCyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789061824; x=1789666624;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ucrMBG1dtLZNncX3iBo9nVwxchXvhveT00DBodHEBe0=;
        b=iGz2l2Q+KBDOxH+4UQz9IPclDKfifVhyH8N4wo432fpOmfwAd8/nDPWtyiNonfPqVH
         eAEp6zSxg0/A9DnOBH/Gc5bQzS4dMwAgG1yn1s2LsWV4IOYgUzSTGsk4rEmPLSKbTHSx
         FhooNbifdfaYoj4u92CYxIzzbfN9AYMBrc9ih53vYLFcJU7GrWBloaeO7EjMSJiZnBU1
         VxV3dnh7aiqXcu797t8ulp2vficIgV6nCp0KQeiO9P1qidZ3im/CF4rhDQ5XBtxWPAc0
         RF4uPxbtg05vkWZGTs9XDr9NtOSnql7vdU4Cq53Qy3U+SHeF9BHQ4fkhgZEm0vEwyQwc
         ar5A==
X-Forwarded-Encrypted: i=1; AKwUvByAgzvwJihX/EdY5AGyEDW4dioidNEuXamY4s4/MziIyUZRSM616mbh3YyQ26upWyLoGaTmZeRWPw==@kvack.org
X-Gm-Message-State: AFuF++nr2NX6/Yz7DS12jd/6YVKJgCYR5Bxi8fznlW9xE2XfBJtvG/0U
	1i/7YhowD5SzO4tiR/gqVSoxWCK5FrUt7OdYgmb5Q6liCGOA0pXb/uCXe4gKXkNJEHKFcSbBBAT
	ow3s/QT14Tqfr0g==
X-Received: from plmk20.prod.google.com ([2002:a17:903:1814:b0:2d9:227b:5717])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1508:b0:2dc:fdde:30c5 with SMTP id d9443c01a7336-2dd2a35779dmr7586505ad.17.1789061823421;
 Thu, 10 Sep 2026 10:37:03 -0700 (PDT)
Date: Thu, 10 Sep 2026 17:36:59 +0000
In-Reply-To: <20260910173659.1945246-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260910173659.1945246-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.1032.g73a4cd73de-goog
Message-ID: <20260910173659.1945246-2-skhawaja@google.com>
Subject: [PATCH v2 1/1] liveupdate: luo_file: Add documentation for dependencies
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, tarunsahu@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B50DE1C000A
X-Stat-Signature: eseabyp71nr9y6x4mntdk1bq75mz7oc5
X-HE-Tag: 1789061824-396793
X-HE-Meta: U2FsdGVkX19hIhV6cTyHfBprkvcrkqCTuEbBQFBP2+/CIN8IlA1Zzf7CYpxJ+a9FofLeSBBrYXZ6JBOJFYBNf9GfxOfhsYi301VMXPsfWmShsZIIGHmKEdLSI779REv5Uu8LKgpilpEISecI8DP9HvZiAX3NNfVlEIfxpH4Kf0UNB4b0pLFCvfOog4YE6go3G1F2uzK/d3xqPPj7NlEjHYF/bB5nV4smpue9d3R14p3KZfJBFaPMDQIUKWqdPm+Vi9d6uVFrSu0eSpw5R698WrTbTHZuYLuoLzzzImsmfGuph2qG1VMAvFmuWNygf+Iv15yE3QTqJ6DTtLZm4thVgpeJdFrLm+4aDsaa19XUNvLCwrAYAd3ZTQJJxSQbJQkVKeH7+DogXMHhgu7+Q7Cz3v5HjPtMWt2Ro2u2IYq4QyogHHZLxPL/7l3w19VcwYdZ/Bn3As0wKcy5VQGO89IYkdP7HeUHojWcIxBBklMW2vhoAredyl3MNqMWysyCrytIdP7T15xVyl57sJLKCcwRx7GkemcLx5Sx7Exol/8fxBLkgE7dOsOcWl0UAofttelkpdVkJ34+B47SbrVYluo9NsqD2zZ8jNJ4leY9LIRgLlLdNWTHu0CE9qmXkxxeOdfr/qsFw0bQcZeyVZiSJ1GnJYQAukGH2dFpUCuGwQdFACICHs3v2snJRY5u6jKy5WQwvZO4beyiQkyJ+xXTCjD/jtUJP+8Nkcgmtw0h8sNbb5gTrjALO236lwgTg/NjGaaB3Y9f5tZYPww2nkEyvbL6LiKxL3pnPfG3Qvc6xQJN2DMFGCnOJEI4sEyoDomi+HAMsZCLD5AuDSB8kSGcIru8uTOcqCNFlXmvYgZvzQMdlm+oPyoVmM8pqHAMhJMAedepB8NTaK8XpF3eMN6Oh3TF8CrNkxStTIvcjQ+mJ25F8P1/QOOcMfFVDxEWkcpstqYVJXEwT/Lc8UasbC4Mej6
 wMNd2uA0
 sVjDqQyQ+1/zIsQvr0xqnTHihtVh/XIiXQPyzNVLlKJ/DTVhUyQcnFqw1pyDkgqNQVBrPeMlXh/aPTCwCWKFQ8UffmpgVibAJkL1IHUHc+VDLW/6FSMl8uvN5oih/rzEnLH+ysiv7PQAyDlqq97/l1Ncub23VtP0FwJbrbsagwn1lKGhGE65BHV2s0T7XSPxVVe9b3tr9rFMyygRh8nCJUSsemD/N8DxdCj9JfvsqBt3EJCH/AUKlLidhRXHhoh8v/bbpLnWaeuRixgdBKFLlP/avsoTAYcm8aFlxNmUL+mWrX1JpIUNx1ujL2I+RLyGZUveWItViT61C2iR2qTX26jmrU4mekKXtW+t+iFY9eROOHtYcJ4SVhZOK2l7p7oklb7l0msMEYx+65qnn4ejADtavuSyl2jV9ofRTeAYLKbML3iCOI8fUb4oBQ+HRVhHfuZrMrUsyKq3T2JaRsuv6iXDLrXq6kBqMvbRM4WYUrjjsxot/+VjqMMKiYJdDO6knUG9NJrm1RUiDpwVVe+YL8taGEm4mkidLxuXHY4zqoBEDZ+nOtQ1X6zLDriQcDPNQqosbl0V4/9RKAJOUC+pissKaIh4wFwstyTJ1K7cJfuhiBX/0sNxYxffLYWDouiPbN25LCCepcI4QtOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for dependencies between FDs preserved by file
handlers. This supplements the previously added
liveupdate_get_token_outgoing() and liveupdate_get_file_incoming()
internal APIs to allow file handlers to resolve dependencies.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 kernel/liveupdate/luo_file.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index dbae0715220b..a39992da504f 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -91,6 +91,21 @@
  *    again later. If the issue cannot be resolved, these resources will be held
  *    by LUO until the next live update cycle, at which point they will be
  *    discarded.
+ *
+ * Dependencies:
+ *
+ * Preserved files may have dependencies on other files that also need to be
+ * preserved during a live update. A file handler can resolve these dependencies
+ * by querying the token of the dependency. That token can then be serialized
+ * and used to fetch the dependency during the .retrieve() callback in the next
+ * kernel.
+ *
+ * Some of these dependencies can be resolved late during file handler's
+ * .freeze() callback, but some of these might need resolution during file
+ * handler's .preserve() callback based on constraints such as immutability and
+ * performance. This introduces an order of preservation. Note that the order of
+ * preservation of dependencies can be safely relaxed later, but it cannot be
+ * enforced later.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-- 
2.55.0.1032.g73a4cd73de-goog


