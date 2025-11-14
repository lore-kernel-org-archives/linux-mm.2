Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1728ECE8D4A
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2328E002F; Fri, 14 Nov 2025 10:54:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32BF38E0029; Fri, 14 Nov 2025 10:54:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6F58E002F; Fri, 14 Nov 2025 10:54:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 08F388E0029
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:54:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AFF911403B3
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:13 +0000 (UTC)
X-FDA: 84109659186.11.26E5E73
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id E07E22000D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:54:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GTKygwvF;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135651; a=rsa-sha256;
	cv=none;
	b=KLH+7n9K0hfK4fiePxtnY7X/nDlSgkVtrMaqg+oEg8W92c2uX2ZlA+JI+aLXihgWjwl3w8
	sxpdE4Qd8QKnVtKKTrigxyiOpC7IddxdfNB5XjlMJ6LxQESws4k/m2H61uxgxLWsR5uGro
	YfC9MHUn+Vj0hqKeF8kXDmnKoStX8bk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=GTKygwvF;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAQesQhs6e+PTptufLvrkGE1DQZP/NgJYpEOzUVqdGc=;
	b=36Y0REsNcbXhzIODwT1D5O+fpeocVy6/1/JEQlNA8Mny7h1YF8iUpZB+GcKM4wSv55ex8B
	ASyjHb7pPlzwUn3uFnvB12RJ3Z/eCUP7m0svE5EfsdHQBjWUWUUF/X5l3YoRp1yQ9LWaUX
	PsLTpayFGZuu9Mu6Oj9j+ZKdYmxE3PA=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-63fc6115d65so2074820d50.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763135651; x=1763740451; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oAQesQhs6e+PTptufLvrkGE1DQZP/NgJYpEOzUVqdGc=;
        b=GTKygwvFJ7yjXJy0SdANvQOSavr/kS+vptqE05hxDwudmZG/2LOA4gCXMGIZxTU4a8
         ws4HtTWlnCWp7Wl+kUzcjl0mLhuTMsEwRtYy1t05kKVQRxyNaO8NUizllfJQZbm1pQO+
         kfHAz1arY59lBJAuk/NH9E48k3KSJdqbRTUoTfbc0WY1OllAZKFrdsfiEwR6QDbmc+j3
         9kgHunNOB+8H0gS15npfQA0kbzDgK9tj2SqDKAPPfn+fv/6kqk6W3HUgg8rOhWwybAxz
         6cgzENtb17tXyZxYCm+dq1W6KBulgJFWeEKgt0M0TA6Wi9RKYwipYbXj4DI0YStD4qz/
         MHXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135651; x=1763740451;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oAQesQhs6e+PTptufLvrkGE1DQZP/NgJYpEOzUVqdGc=;
        b=BaMYDI1rJ15f9r6DEZmQrK0BxAafeAniLl7lfIgy+7d1cM0CcbR2xaZLRrVPnWJJ8G
         U6IuxMLBx6dE/Woh9xdkpqS0p7aipbkbzBbtTl6CC68ESmzld0HN2m/zprqXHePXG2Wi
         Ksf1qINE18JTtl9CH9iwBDHWjl8wGoP9/i6qYzSvRafeXwE4oCnAs8/5V3LSc/wy9VIm
         A16ySMavhvlx75NA8jWYzoAtB+jnVOFwg+DVJQrItGWV4EsOBFW6BnBnvB/iY6fhKnoF
         vaiDzsPLYgpkRBIXVfwdetPFFYdLdtUFOTR0VDB/0iVoyJzaFJoVMDNuBNklmCTUWZ1y
         lLCg==
X-Forwarded-Encrypted: i=1; AJvYcCVMoS6hRJdE/14BQqkoANFTWJVCSU+g2AwHhMc+mmH5l+pPEsf4qGZY3W4cZTycrC5BF9iSNUruUg==@kvack.org
X-Gm-Message-State: AOJu0YygepeZ5uNxs4THQ5GDd8H36j4cMXqcIqn5nosEyzx0YhKzzEj7
	hLzcmiWlEaYcr2Wg8o+cu5DlplqVC8p33+BXsYbevZPiQ1zWwGtOuIuFhr3aPRbxFAI=
X-Gm-Gg: ASbGnct1FmoUD2aGPsVXLyI+2e97yXLSn/BNm/Z4MDiyM8dOOhoy5S+c23lc1p1iUFZ
	ubpfOSCIynXV6A6aivYbRSaRkLt0rnh/MuNAe9/TkCsqgW9VkuXo8fFGuiQOc5EdcuywznRJw4f
	ba4V4f/mcvmpNwDZ7q3bREAqLdBBUUJ8QiX54w75Ek9+Yv1wrCN1jKwk3cfoYW7/YN7Wovwc1vH
	A/FWFDUYZiyrKoc5vpTU0mr+Y3G6tP8dXdacx4QklEuXvyHJIw1vi+cUt9qt8+dJSr+5/3LxC3T
	/7jsorMMVFF3PxsQxlcJTIyDdfWVL3m2jXk2OATFNlmfg83rrebKqt4+8NyyA6dVsQsiqZ2vZmw
	8PSQWH7vClyjG1dnZHveGbclfdQl3TSRRVHoYkZuI1F9MT5OtAIZ4CrHiZSPMaXPbtFZz4fQFtS
	NcfXtv3wPDYTrf7SrwOLLg6MsjdEPJhxJOqJP9dStkgntmEgvS+Osq/gQvkEEQq0Lqz+JBK6F1y
	+AyxwM=
X-Google-Smtp-Source: AGHT+IGlvukkElqwWxXv7Gpk1y3f7JDTm4WbhlGwLIf1Tn2iiPc/ZeTFQ6+QGmg6hTPSZZWz9TZhAg==
X-Received: by 2002:a53:d013:0:b0:63f:b952:dfef with SMTP id 956f58d0204a3-641e7280bb1mr3380829d50.0.1763135650981;
        Fri, 14 Nov 2025 07:54:10 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78822125317sm16468577b3.37.2025.11.14.07.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 07:54:10 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v1 08/13] kho: Remove abort functionality and support state refresh
Date: Fri, 14 Nov 2025 10:53:53 -0500
Message-ID: <20251114155358.2884014-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E07E22000D
X-Rspamd-Server: rspam07
X-Stat-Signature: j5y1c16ha9moi99m1tgpkytx87yukgec
X-Rspam-User: 
X-HE-Tag: 1763135651-99913
X-HE-Meta: U2FsdGVkX19/vtpPl9JFdfF5UjT5Dh41QlrvkdGcqrBvfiuySG4E9lrMewlOdSPsE++6lcZ74OlKON9nRRsGgpi7Q3yvJLUOXEsJcLJEz+BvBav0GKMe0hubOlvAfbv60t4Znwq+xCN1X7UDew+vH8ydggeuvGUNS9bPqgyFp6fSPmliTaD7prC66dCn9KGJB+9/1NhNLTyMYkcPjCpPh23iJwMbfFRCVjiDUHNSdcDcWRVqDC/f8SYwGx5YhVii2RkAYWq13pIpBMAazh8aWta48y19TfVxhTRN50NrPdC9NsubC7gqJJmCYIU9FEEI0sLKUaFKJ/rNEsShvZYAE+ZgYMacmF2ksJpamuDkP+FhIyEFekDupzVrq0JaG/70hXg7kOELxI9wtvqi30MiD7F6kJDdFW2iRhLz5h+bPXwOn2jNP/FrJOKeum5dr9A/nHb6YswdN2sxpSUQ/C3uL1lp1tVBCym8T4QJOUCbotPhWYomqjNeXOIxvMapLVRmuc0ZtjrWh1LKv95vmdXWQX7ap1k3t1F6bWXnADHVlxl3R/w15imU33nQqxQdGaErynHbXZXjYZtRIU3jeElFPJu++3xSKDdfjq3ohFRi5Rk7nbinVZW6bmQcIqwiVL+EU3nuAUohqFaqeX8UmtyFRCsybRVEWW4kkHiUjBuFKVzIj5QERj8BugNFR/uBh9MV/PyyzEKNrj+C9jzMY9ir8n8+ges9mcqzb+GVHCPZUdo5S15NLbJUhZ7AY2iq7PSjsWwtKeaOypXCe0D/NCJZK49cjE45RS8Vi8CEyqOVwn5mo14FMHhMVy7OhGhkXXn1bzpRUlubNt624dIcP/0T9VJNaqUb/XDwoqIhpLdvvy9M1TVbPKt5KRLKtbuJxS5Bp15OMpYjOO/ij+e8J0q8mBfgfqx1BB+9NEMWVm7knmHda5rncnU739AFiXB17dyv6+2aL31PqpmpYNuWDYP
 qx9eiui5
 uOsTTP2OVqkQpkqX9RonkV6JC3KOy/PXrs+bl6nTZIETz9c20gyelkUx7bd2v7uLCguRiKS4UErEZ4vvZiD1j+anP6ga0nanvQEoPEgqBYz5jo9Kh9TCIHhXiR2gR7+AA6woD74OUCr73ajSTraYqmtt9K2vJUvf8Ox4L7sK7Q+Z/JFB8aaJlbcKZHBEO6rE0uNlaybWPPEB0fCaAH7ytz4kIEPJaIhNll5bsEUsO5cVt8VrWBYIwbnjHG3xidQL6onNWkgiTVehbZUO2ygtSJfrJCPBDs467luAhkkco+QgSdomAn4rjk9PUtT5mAi0e6aBeJPhPVBVc3cW/SWFat5R/ttOyXTFHQW5z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previously, KHO required a dedicated kho_abort() function to clean up
state before kho_finalize() could be called again. This was necessary
to handle complex unwind paths when using notifiers.

With the shift to direct memory preservation, the explicit abort step
is no longer strictly necessary.

Remove kho_abort() and refactor kho_finalize() to handle re-entry.
If kho_finalize() is called while KHO is already finalized, it will
now automatically clean up the previous memory map and state before
generating a new one. This allows the KHO state to be updated/refreshed
simply by triggering finalize again.

Update debugfs to return -EINVAL if userspace attempts to write 0 to
the finalize attribute, as explicit abort is no longer supported.

Suggested-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c          | 21 ++++-----------------
 kernel/liveupdate/kexec_handover_debugfs.c  |  2 +-
 kernel/liveupdate/kexec_handover_internal.h |  1 -
 3 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index f1c3dd1ef680..8ab77cb85ca9 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1145,21 +1145,6 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 }
 EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
-int kho_abort(void)
-{
-	if (!kho_enable)
-		return -EOPNOTSUPP;
-
-	guard(mutex)(&kho_out.lock);
-	if (!kho_out.finalized)
-		return -ENOENT;
-
-	kho_update_memory_map(NULL);
-	kho_out.finalized = false;
-
-	return 0;
-}
-
 static int __kho_finalize(void)
 {
 	void *root = kho_out.fdt;
@@ -1210,8 +1195,10 @@ int kho_finalize(void)
 		return -EOPNOTSUPP;
 
 	guard(mutex)(&kho_out.lock);
-	if (kho_out.finalized)
-		return -EEXIST;
+	if (kho_out.finalized) {
+		kho_update_memory_map(NULL);
+		kho_out.finalized = false;
+	}
 
 	ret = __kho_finalize();
 	if (ret)
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index ac739d25094d..2abbf62ba942 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -87,7 +87,7 @@ static int kho_out_finalize_set(void *data, u64 val)
 	if (val)
 		return kho_finalize();
 	else
-		return kho_abort();
+		return -EINVAL;
 }
 
 DEFINE_DEBUGFS_ATTRIBUTE(kho_out_finalize_fops, kho_out_finalize_get,
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 52ed73659fe6..0202c85ad14f 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -24,7 +24,6 @@ extern unsigned int kho_scratch_cnt;
 
 bool kho_finalized(void);
 int kho_finalize(void);
-int kho_abort(void);
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
 int kho_debugfs_init(void);
-- 
2.52.0.rc1.455.g30608eb744-goog


