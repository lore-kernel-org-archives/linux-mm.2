Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC7961093168
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 01:39:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027E66B0088; Tue, 24 Mar 2026 21:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1B776B0089; Tue, 24 Mar 2026 21:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31526B008A; Tue, 24 Mar 2026 21:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2D326B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:39:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46EECB8024
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:39:49 +0000 (UTC)
X-FDA: 84582878898.04.626F6CF
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4C65BA0008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:39:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gByBZ150;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774402787; a=rsa-sha256;
	cv=none;
	b=U6Y4i47xffqmtnuDrtHv8Cpka6lpQXfs5J8heFnod0VGyY0JDz+EOoUHAos+QkqILK5H3z
	MiL+onehcU0OQltqxNXLLtZuw+/9FO913bPT/VnJm4wdgVn/r9Wt6ZvUMqCGPJYEJBRiBY
	ph0rYhHy/wHHKCST4pBHG8Fd4mImPNg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gByBZ150;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774402787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f0lb1fwwGhgf5ADRsUJX20lMn7/h+aTx638YqSGGiQ8=;
	b=swvi4HJHVQpodxovvRI/95p3DgtWs2Slao6q5RNeiOCPjAHd9thW5483+9Qgj+pi2koe3X
	rbrDBSuroiJC2kDXr5Rjlw+xMZEXLwwhB6q0MUXEQht5YxJ1doSgob/ie1580nnuhd+rfn
	1zhNYpt33KzC4LPDwHh+DnwNGUEuoEA=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82c68339cf0so299994b3a.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 18:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774402786; x=1775007586; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f0lb1fwwGhgf5ADRsUJX20lMn7/h+aTx638YqSGGiQ8=;
        b=gByBZ1501f+sQsJuq6OMjxriRaL6oaj7IsEKtY5DZpRRv+g551UEFiVXHhWxT9db6d
         65i6ERwcNRUVh5Mijfp6Nw4vmzV/fFCzStns5jISYJldXjDfcxeIpHOkc6XqOAwcw5OF
         GkzocSbv06/ESWZQAshA3f6L6poOv2BGGiXWPCN4wiMocVHHN5NSYVMKa0ZmdIpSrSVi
         038x8CDWlOXp7WVhWwb82YevUKlF7C/urZWH0O1Bij6U8PzgMeH6bF6rUB57VAjKu1gi
         ub3ePKCbof8zc6NXFNVrvE4P8wYYpdP/JlPv8KUS8rjAz6+PeVEGzngut6t2+L44juu4
         LBmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774402786; x=1775007586;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0lb1fwwGhgf5ADRsUJX20lMn7/h+aTx638YqSGGiQ8=;
        b=H9XLYYN7JcQZcblUjtH6sDEHANWcpybGYwYwRvCDy9DtylyqV5GQM86brITgdnIsM+
         G4wzUQC2qTfxjsDjQQpvsft+zOYmsYvAmcVyR1pGkbG/XwvEW3AAm9HVTXQnQQfLehLg
         hb/4LHfIAexUl4GHpYRNDJw3Jt8Dy6mlY2RT8TLi1d/DWV4P6dBodgknCjeZ0S5P1ASw
         9XG6oHkuz02/DkhpL0UO9ZxXAtpyBUROX+88LrJPFYisI/rNAMcEu3ombgZCB6RrT023
         lxqeK/Zf+JbcNrscHbymjIYCenck7vxVysqy5i479+1ephYlUIQ14vzXdVcwbu91ySp+
         WbBA==
X-Forwarded-Encrypted: i=1; AJvYcCVsGmtF+UQIcDu9Jkiycauoerf+vyPWcTqNcKKIC3k3rjqOMzeY+hGnodvG0NzHOCsEs0GLOwG9ng==@kvack.org
X-Gm-Message-State: AOJu0Yz31Oq6YlhRSIjKZjTUJORf8kSvSGm5s+QvEqKfe0sUEHv9S1po
	lcwc8L63HG/zx+c7hkJWfKB0ROGmSdr4DABcj6siJgAljaGqcoDzdSNqhlJ2Dw==
X-Gm-Gg: ATEYQzw5l9j6Tnqw1EYpp/o+xr4GL6u8LTtQC4D3imRlcExt7Hs/VyLoRMXqsDoBZAD
	917Gh5ZuuF4a4jUbPz7PRXbV62bZoq2abn9P4/Q1FpYVVV6EHAHIb8QJs8PIsnAgCt1msaq2VWM
	671A4vEtj9412raJ9NC/5f/rDmqqcX7OKytExS6o6LuI6qh7R4PTArT64fuKgAmE8OqsSaTHaoj
	7So5toCjTPJmyOQz+G/Eiuo+nAnDTGKFhNoKh2W+WOuj/1o4BGIH+2qBCPwmyy9PUREOO/qr4OC
	j+BZFq4Hr7AOFvGosY05OSQFU5vxfdz1lBTvoeDk4WjUlaS1YMG24pjMmFvYfg8pXlBnUnjWsLM
	5HovaCLf+dYNqm69PmXKB/U9m+TypRJfb+Mi+J8qGnrE6ZWujvAxZl0EoXI7YIEf7ylDzuyred8
	09IMNj5rfDpWp189oiOnWLiHkTmw7fJy+mAbZmq1zChRQWJkzksuqpBqmVWO3uGg==
X-Received: by 2002:a05:6a20:6a2b:b0:39c:3f34:7e06 with SMTP id adf61e73a8af0-39c4abb7d92mr1746911637.4.1774402785894;
        Tue, 24 Mar 2026 18:39:45 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c74443ccbf0sm11654417a12.26.2026.03.24.18.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 18:39:45 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC v5] mm/damon: add synchronous commit for commit_inputs
Date: Wed, 25 Mar 2026 09:39:39 +0800
Message-ID: <20260325013939.18167-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4C65BA0008
X-Stat-Signature: rwbybpa4oymjhb58oezqc9h5b3thpoo9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774402787-906599
X-HE-Meta: U2FsdGVkX1/v+wOHGnzw6nfhKMcQS4jyQ60xsMznxgi6tzPfCHXJeUwoGFeWGkwoJD9WLgxeL2Ee3Ho194WWqlt77OEt5MRyfDjHcyvQxNE4tfGzsyTEh1/KxCIyRjcHBcJ8I4TZQ+y2rOJmy91xlkSF6xhDTW1URXxRnG3rOREIPYbcD1xIf2D97ULGrrQeH4GxgqdJCVhGJ5gemdpSfdHl6OiyxbAA7QWnFmeBHeh2gLARFAnrG5/a62Cqei5GpLuPWYJgKHsh1B4tD3j8wjgbYdsKAy5hWq56pOVvxfifdF2I75sdDqdGI3DC8Vq2phU1POWuCuhQLeUGJnRGbvkVHFQ31wxEehHSbuV4Y5UnRaiQFuH2ObO5qtbet+QxOApzTEybbwEtrN5ADvHP0WZco5bdav8M/JeFEJJjNZOb1TdZdeY0SOzHG/U1DoRhDR2lN3jGjOALvgfswiDRxzM8LxriR/5AgxvvWwKoBOVQouvnBt0D69pBKPzmFGo9aYm/4e4v0Y3JpwLqHjqqdTHC8lM1ad+MfuVelUN/SBhoDIeLqz8m7I80kSgLc4hQzTrSoCQqCJiLpbMUTVFPjMcfXi75Mo+AaIuEL11ShukSTF0grzmYaWUPkfjJpvL0kuE1pcfgjL9zh7tnTj7sUo3BNoEBE5uMtM3pQ0Nd6pJjNrM288h1AKv91BiWbnHfnmQ9VuHIiZ/9Z0v2UiuG7sFd1WwMyYr3T5I0YecCl80iE2Q/Qi0g112N9i7C5H0l2ZxFO2/mu/u1AbpwrK+Vcg/YcDzSJvygmMOM3VE7engCjIIgNyY/tySiKncEvokRuSyBdbmoXiH4pMMBqR5xBXpjmvdj19n21mZZBkhc7s/stXnq+qPuUSRE13+3/zghaiPy+DMqyTZL2Gxee4Km/HEjz3DW16kS3a1yeid0B1oGj5U0KrHCUzDNS79QX4ZtTz/alRmjy7vN0Kb+f5U
 a/uexaH1
 lLdeNX70HuVv1QTZbNb30y2f6gGidrwPV6C2Eki3KmYkgJ26AACkkB++eWebvHaeXk5Fu6X8S37+dz9bYspm1JKMmIq4xVtk34tnBW0zySITYioBhUukGvqc6REQuOc/AwlEs62A+fUWf4iZRklkWbVh4k28Msf439UYhoXVEo3CVhLdM1otjzPJuCZXdy/9X0DCCqZEKpRcIBHqJKSFNqO1Ze+jAOV+eWjOddRUZoTwjalfq43smR3iIpn8218C7VvVp1pGhp1aLV+gvHWcM1fqS9U5fgLISpSl4iSqHOic+aqy7Y0TVT7+ZHElzaRjB1C1kbJZl4kJI6stW93WOAYHgVdsnPRK5QkvUfu/tnXwgruxSUOqCxIr9ALlhEh3swuT3+ZajpUb9MFF6J9f63/arQ5m3rXAj4a1rNDKhPCXMTALar1RVWfCcVpvtV74h5l65U6Gq+PI1+cWx6DjUgjuYJDflOKMWNb5y9EmEhMQapT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
=======
Writing invalid parameters to sysfs followed by 'commit_inputs=Y' fails
silently (no error returned to shell), because the validation happens
asynchronously in the kdamond.

Solution
========
To fix this, the commit_inputs_store() callback now uses damon_call() to
synchronously commit parameters in the kdamond thread's safe context.
This ensures that validation errors are returned immediately to
userspace, following the pattern used by DAMON_SYSFS.

Changes
=======
1. Added commit_inputs_store() and commit_inputs_fn() to commit
   synchronously.
2. Removed handle_commit_inputs().

This change is motivated from another discussion [1].

[1] https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
Changes from RFC-v4:
- Rename the 'yes' variable in commit_inputs_store() to the more
  understandable 'commit_inputs_request'.
- Return -EBUSY instead of -EINVAL when 'commit_inputs' is triggered 
  while kdamond is not running.
- Link to RFC-v4: https://lore.kernel.org/20260323021648.6590-1-aethernet65535@gmail.com

Changes from RFC-v3:
- Added checks for 'ctx' and 'damon_is_running()' to prevent NULL
  pointer dereference during early boot. (Found by Sashiko.dev)
- Removed handle_commit_inputs() and its associated polling logic as
  they have become dead code after moving to the synchronous damon_call()
  approach.
- Ensure the 'commit_inputs' is properly updated.
Link to RFC-v3: https://lore.kernel.org/20260322231522.32700-1-aethernet65535@gmail.com

Changes from RFC-v2:
- Removed damon_validate_attrs(), now using damon_commit_ctx() for
  synchronous validation in the kdamond context.
- Following DAMON_SYSFS pattern for synchronous commit via damon_call().
- Link to RFC-v2: https://lore.kernel.org/20260321140926.22163-1-aethernet65535@gmail.com

Changes from RFC-v1:
- Remove question from commit message area.
- Added synchronous validation for DAMON_RECLAIM.
- Rename damon_valid_attrs() -> damon_validate_attrs().
- Exported a new function damon_validate_attrs() and declared it in
  damon.h.
- Link to RFC-v1: https://lore.kernel.org/20260321002642.22712-1-aethernet65535@gmail.com

 mm/damon/lru_sort.c | 54 +++++++++++++++++++++++++++++++++++++++------
 mm/damon/reclaim.c  | 54 +++++++++++++++++++++++++++++++++++++++------
 2 files changed, 94 insertions(+), 14 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..a2410f648b51 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Desired active to [in]active memory ratio in bp (1/10,000).
@@ -349,18 +348,59 @@ static int damon_lru_sort_apply_parameters(void)
 	return err;
 }
 
-static int damon_lru_sort_handle_commit_inputs(void)
+static int damon_lru_sort_commit_inputs_fn(void *arg)
 {
+	return damon_lru_sort_apply_parameters();
+}
+
+static int damon_lru_sort_commit_inputs_store(const char *val,
+		const struct kernel_param *kp)
+{
+	bool commit_inputs_request;
 	int err;
+	struct damon_call_control control = {
+		.fn = damon_lru_sort_commit_inputs_fn,
+		.data = ctx,
+		.repeat = false,
+	};
 
-	if (!commit_inputs)
+	err = kstrtobool(val, &commit_inputs_request);
+	if (err)
+		return err;
+
+	if (!commit_inputs_request)
 		return 0;
 
-	err = damon_lru_sort_apply_parameters();
-	commit_inputs = false;
-	return err;
+	/*
+	 * Skip damon_call() during early boot or when kdamond is
+	 * not running to avoid NULL pointer dereference.
+	 */
+	if (!ctx)
+		return -EBUSY;
+
+	err = damon_call(ctx, &control);
+	if (err) {
+		/*
+		 * If kdamond is not running, damon_call() returns -EINVAL.
+		 * Remap it to -EBUSY to better reflect that the operation
+		 * failed due to the current state of the system.
+		 */
+		if (err == -EINVAL && !damon_is_running(ctx))
+			return -EBUSY;
+
+		return err;
+	}
+
+	return control.return_code;
 }
 
+static const struct kernel_param_ops commit_inputs_param_ops = {
+	.set = damon_lru_sort_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_lru_sort_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
@@ -374,7 +414,7 @@ static int damon_lru_sort_damon_call_fn(void *arg)
 			damon_lru_sort_cold_stat = s->stat;
 	}
 
-	return damon_lru_sort_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..4cbd67e08d56 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Time threshold for cold memory regions identification in microseconds.
@@ -255,18 +254,59 @@ static int damon_reclaim_apply_parameters(void)
 	return err;
 }
 
-static int damon_reclaim_handle_commit_inputs(void)
+static int damon_reclaim_commit_inputs_fn(void *arg)
 {
+	return damon_reclaim_apply_parameters();
+}
+
+static int damon_reclaim_commit_inputs_store(const char *val,
+		const struct kernel_param *kp)
+{
+	bool commit_inputs_request;
 	int err;
+	struct damon_call_control control = {
+		.fn = damon_reclaim_commit_inputs_fn,
+		.data = ctx,
+		.repeat = false,
+	};
 
-	if (!commit_inputs)
+	err = kstrtobool(val, &commit_inputs_request);
+	if (err)
+		return err;
+
+	if (!commit_inputs_request)
 		return 0;
 
-	err = damon_reclaim_apply_parameters();
-	commit_inputs = false;
-	return err;
+	/*
+	 * Skip damon_call() during early boot or when kdamond is
+	 * not running to avoid NULL pointer dereference.
+	 */
+	if (!ctx)
+		return -EBUSY;
+
+	err = damon_call(ctx, &control);
+	if (err) {
+		/*
+		 * If kdamond is not running, damon_call() returns -EINVAL.
+		 * Remap it to -EBUSY to better reflect that the operation
+		 * failed due to the current state of the system.
+		 */
+		if (err == -EINVAL && !damon_is_running(ctx))
+			return -EBUSY;
+
+		return err;
+	}
+
+	return control.return_code;
 }
 
+static const struct kernel_param_ops commit_inputs_param_ops = {
+	.set = damon_reclaim_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_reclaim_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
@@ -276,7 +316,7 @@ static int damon_reclaim_damon_call_fn(void *arg)
 	damon_for_each_scheme(s, c)
 		damon_reclaim_stat = s->stat;
 
-	return damon_reclaim_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
-- 
2.53.0


