Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B91ECA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4166B009F; Sat,  3 Oct 2026 17:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B8B6B00A0; Sat,  3 Oct 2026 17:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7637C6B00A1; Sat,  3 Oct 2026 17:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44EBE6B009F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:08:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AADB680A19
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:44 +0000 (UTC)
X-FDA: 85282554168.15.BBBE9BC
Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	by imf30.hostedemail.com (Postfix) with ESMTP id D0E7680002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:08:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qf1kTTlk;
	spf=pass (imf30.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791061722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WdQn6f6AsaloNtXz63r2rYU9L2euT0e0WgByXQq7Q8=;
	b=LoshsfhzjiiX7IMN3NRelBifT/3mvfWB8RJO2xtbsP7NcGzOiUVn131+tlbZA71IBNOTOA
	P+LuVcVKTbAKr27dNnx5XOeBPM0K2BZuXZ9CJrFUSYBnrJNDpL3Vasp9zuixwWoZ6HAKRW
	KXdo5202C4e2Rmy2yHDCxT2phKs+ocA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791061722;
	b=cGzHPB6zxrwSPlmkqNw8af/fKGgNYRx7OT7LSCrEJFzvE6XkYn5Rrdtn60NyNLmYHEvoq3
	SF8nNaBD9YyegSRPE4uVylpnhW7+F4xto+3nfa5CQhrzDE0htsDe0OxTaFzimOWfIJQzkz
	yphQGVbju6rYBTO6Q9bVTPqlcmf2GX8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qf1kTTlk;
	spf=pass (imf30.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-8ab43af5e97so3420007b3.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791061722; x=1791666522; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7WdQn6f6AsaloNtXz63r2rYU9L2euT0e0WgByXQq7Q8=;
        b=qf1kTTlkwIKR2Or8dAvh6OFu8pavLekdLn08TnO0GFgjuMMczIJbp7jGp96XFNDPXF
         Fk8om9DT6/oHrC6jPS3Wv1WV/Bzz4g6S9UScO63RHF9XNmewUmHN0sBrVylQ7uvTMre6
         aOTf33w1M/nfqFwwJc9w16yP9wq7ZgompiqO2q166QynGUU4MZ+yBCCxCZKsnlZPbTUP
         ke9qV9BCkAvPrdnTREyGSUkgPNAKqORitsNjO01dsXxYV+0f4TRNp0YUX4HV1y67wQR5
         LuHw65NKXarWxsyVs1FjM160XspdkaKPASRi3MrcsVfiNpKr2a4ziWc4GKhh08wrExYl
         ADvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791061722; x=1791666522;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7WdQn6f6AsaloNtXz63r2rYU9L2euT0e0WgByXQq7Q8=;
        b=O4ex/qzRR6ho4c5vFjLg7C0Q341kMKS+WyRjNMSs/3feagG1klsVpjlomURUfqwXKk
         zjucpuGAhxC4e+osP3J+fPAHwTB3cUJqvvYFpCqRUYCFMctxNyZuhxt+rbjozH2P+NCQ
         8MXoC6KUJESjU2doC0Za/sxpfxolg5PAnWFKm8yqxy42XD3hSvj++QI82/1VQ1tmbFwt
         ZlPYCjCu4nOoQGhqFIuHxc4KGLRRkkhHHIq+B/RS0txISqGM0LsxkYYNoJQlfoYMg65D
         e/b7Pa5awgIgR9vpVpVHz+FSzIkY4Qv+ymQTO/bfnHM4P1X+z1IJU8Ozxc62hPD6EJnX
         EdAw==
X-Forwarded-Encrypted: i=1; AKwUvBzpo/gG/SvIF+DarpKd4HfVJ807X7IBgVX/BcGr8LZcGUpdzmDPVnE375+fu02csaVdQ+wbRJ9rQA==@kvack.org
X-Gm-Message-State: AFq9FYJM8PFANetwSMspIbYF711AW/GPn+TuCHZHmtk0P2TbLAa0VM2L
	wBwLzUDIIB9ora31pJan2Y11cyQXErQqYSrwnAhZSP/Z8DWVHy6R2369ttbA+mSOCA==
X-Gm-Gg: AYBFou0RTbn1fMDPsMj27oX/4IMDqt3HM21gDJXptIdO9qDfBGB/Kbrl2pKE65s0Waw
	jErRGYbN7COLVq7XnG9by0Cq0vILVwa8DQS0DjA+rm+0D6TzR+WwFLpb20C7cS8w8prR2C3YEE+
	TlIlz/G8lrBA4iqlUWhxtk9SeLZjm0cYk3ThXlHwKJsb0T8Fwf73hyFuvBJIsidAjtIXp9C08Uq
	GjINrD+1HFI4Argux/tRrEzGUHs7lddt9BCT9wj/YlGtchyU0XkXwzw5q0VEvfxz+eK51uKHz0G
	xwkPsDpbm6qMSKlNOzFl2PYjL+K7IlHfGrxA5Rgy2h4DNa4GD3Ep+6rzru9x7vYYo5uO/mEgS4J
	o6kkOMUGIX7IhDy3+sCi7cZ5IwGGeDEeoJ32LDk1HH9UevP7UVfZgyyGk+4Am8GuGFuWoQs7UWZ
	KxQqp+Blnh3fhRQcraRGeW+JO+LJOZ9cI5YEFecupiPmILrWM1y7CxIsSwm0NSQGmluTV2vHAiV
	3HVldXpWhV1ZRTWTLDaX+lPiq61NBR40LsgMmq4s0tjEkSdzVVk3t1mf0r0Q1301CBLznaLKGXL
	d1Dq5gOngkmS3h3TnV/R+TLUGdT7EqycEA==
X-Received: by 2002:a05:690c:3181:b0:8ae:98ce:5497 with SMTP id 00721157ae682-8ae98ce7efemr12330927b3.0.1791061722002;
        Sat, 03 Oct 2026 14:08:42 -0700 (PDT)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2600:1700:4577:1050:550f:9551:5468:60f1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8af0d179d3bsm743537b3.40.2026.10.03.14.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 14:08:41 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sat, 03 Oct 2026 14:08:01 -0700
Subject: [RFC PATCH v3 8/9] mm/damon/core: cap the region merge threshold
 per target
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-8-0f00417b41bc@gmail.com>
References: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
In-Reply-To: <20261003-damon-perf-rfc-v3-send-2026-10-03-v3-0-0f00417b41bc@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gregory Price <gourry@gourry.net>, David Rientjes <rientjes@google.com>, 
 Wei Xu <weixugc@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
 Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
 Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
 Kunwu Chan <kunwu.chan@linux.dev>, 
 Ravi Jonnalagadda <ravis.opensrc@gmail.com>, 
 Jonathan Cameron <jic23@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Stat-Signature: 7pg57ghdafrokwggnqjppqj6u9yed155
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D0E7680002
X-HE-Tag: 1791061722-964362
X-HE-Meta: U2FsdGVkX18/8VuMcgixUkTpHm4v9wbfajV4H6FQeCkf79DxEEZT20FZoLXZIG1h7kiJWnG6y6fbUKjoTrs1RhTbS/TjOLCdE6CcIPdAvssi1Lj4BCepY0hRQ0lWMLUnQaWjyf9hKa7yaOMFskNvDgaqp74rPOBIU/nE9SCOhnEcxIYI4otYBRgUyQ6ul2EVWaYedXlFzmbvZaaKopxZjcYrKDtroz2m9KpLmtz2MNrkGXfrWT43OW3b+I9/suPIsuqDY7J57lpuaiTzdFnii48MG8ycagLc2LpjM5g900EGu7R+E/EwawH94evcxJWjAbK0a+5pf8i1ufasTkmw1IWQ5XhTtvFuo479u5hb/jO9xmzigqwX/eFnB1s2D6EftYIAiJvdgt34o6rQXtUIFBrifXQEMhqRbe0pYZ1tqVOUrh4vujTpo/b13HvppHJb8YWmnfq74qe3h5yl9vv0jaIREGF8kA7wOyOabL3DNiZRjmWEBrN3McXSqIGSnsOCqeIfop7yGMcgJ4LUP7/6LcN1qtxs3K8WLoGWBcmhHQy/oBlL1NdFcvDADjO5HeljOi9nY598NJVMp+/ovft8/E9rhGMYr+NDg4uFR6jG0lZleEhJG+Z26Z7QFqEmmlagNUMoYRP0EghZxPBBwkWg1yesfUQpDlbwxSHVWdQlH0NgRoBnYcO5sR4yjnJ6cydkM4f7OgLJxo4STkjwaUO2v3WISf3C8vPkfh9xM8a7DDVbfkaJARlHOnU/1zkVOFptno1YYiNmtChwS8dH/AVkHFom72FyvI3qHDDDkuD08BVyKlxghf5BJE5Zb8NuVZWMr/8UXEcV/5Qaa1V5QMmqAHUv83QCO5F56yiu7z2bmkNyfEtmO42L9SDiB3EtdTgZoI+nqaNo/GJ8ux6foqznqY2xlXAHIDbQ/AgAZ9tcQttpFRqxnrbnbfLBrUNIJzpxr6qpTqJ7nc7wS9LMvTy
 g4pud5JB
 qyEmJKAnS1E3NfRBOsO56hbF13RlyxCMdRK+xJ7+XVE+eGS+9W39Z7PmMXXUfVFchAMjxLa6t1FWwijRk9jVscR9F3Nzx9DpBG0XW0F37rvJsajQ+niZ7eSyUDjELrci5uu18eLLMExxh6wAQyKdt3OLfQvDLRwCcmHI+RhWv2ESmEaqqe+aOAI7/01QBYQET+lkFZN3bdeGZzrUBt1saiJ1nguWadxeMzwyXtUX6fFWKkpIh4lN/2xyZN4fxDwTYrt1p+443mJvwItMoTaaRK3DD9m8rdp5k9Txwtq7Sk42DdQSXFMs4/SdmkkM5FAALe5NvfBp7uLvew+3orntXr6oNZvj7WPiEYiNs12yHI30b4/yUMYmojdccSbn3gu6fjdswtbC45RM0c1PxrE4/PZXdNssGjqC4Knfxuz07iMgTZGQmjtEwQDDOptwk+uOfXR4X7Aj4pSGIrceU7pEAckCZRpfmQ3pmgV5SQzeSyA9krElMhTxoJVvucAnkm1qUeLlo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_merge_regions() applies one context-wide threshold, the highest
merge score across all targets divided by 10, to every target.  When a
high-traffic target and a low-traffic target share a context, the
high-traffic target sets a threshold permissive enough to erase the
hot/cold boundary in the low-traffic one: a region with nr_accesses=1
next to one with nr_accesses=0 merges because 1 <= threshold, even though
that difference is the only signal the cold scheme has to admit it.

On the regular merge pass, cap the threshold for each target by a tenth of
that target's own maximum merge score.  The score is the one
damon_merge_regions_of() compares, so a probe-weighted context is capped
by its weighted hit sums rather than by nr_accesses, which stays near zero
when access checks are off.

The passes that follow the regular one exist only to bring the region
count under max_nr_regions by escalating the threshold.  They keep using
the escalated threshold uncapped, so that bound still holds.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 1d25f820e3f9..c2c74d0daf95 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -4175,12 +4175,36 @@ static noinline_for_stack void kdamond_merge_regions(struct damon_ctx *c,
 	unsigned int nr_regions;
 	unsigned int max_thres;
 	bool count_age = true;
+	bool use_probe_hits = damon_has_probe_weights(c);
 
 	max_thres = damon_nr_samples_per_aggr(&c->attrs);
 	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-			damon_merge_regions_of(t, threshold, sz_limit, c,
+			struct damon_region *r;
+			unsigned int t_max = 0, t_thres = threshold;
+
+			/*
+			 * On the regular pass, cap the threshold by this
+			 * target's own maximum merge score.  A high-traffic
+			 * target in the same context must not set a threshold so
+			 * permissive that a low-traffic target's hot/cold
+			 * boundary merges away before the cold scheme can act on
+			 * it.  The score is the one damon_merge_regions_of()
+			 * compares, so probe-weighted contexts are capped by
+			 * their weighted hit sums rather than by nr_accesses.
+			 *
+			 * The passes that follow exist only to bring the region
+			 * count under max_nr_regions, so they use the escalated
+			 * threshold as is.
+			 */
+			if (count_age) {
+				damon_for_each_region(r, t)
+					t_max = max(t_max, damon_merge_score(r,
+							false, c, use_probe_hits));
+				t_thres = min(threshold, t_max / 10);
+			}
+			damon_merge_regions_of(t, t_thres, sz_limit, c,
 					count_age);
 			nr_regions += damon_nr_regions(t);
 		}

-- 
Git-157)


