Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 521D160A261B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 00:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MpiwPJcG
Received: by kanga.kvack.org (Postfix)
	id 598E86B06BF; Thu, 19 Nov 2026 19:13:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523DB6B06D0; Thu, 19 Nov 2026 19:13:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EBCF6B06F7; Thu, 19 Nov 2026 19:13:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 118036B06BF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:13:09 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88E2D40C64
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:13:08 +0000 (UTC)
X-FDA: 85453572456.13.9CDBB14
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id ADFEB1C0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:13:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MpiwPJcG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of evanfengff@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=evanfengff@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795133586;
	b=fAZDSuqzcEvT2dEf8uNF13hgwIrWY2Ahr0Z63XbBehO9gvH6SVvjjG9c9GMQKgeCl1m73j
	0Th/kh/MfVetNhwTqoBUxo/4SjpAOdtRjQagAI1VqZg3Qpf/6BjX5X5ZLTSF0mwqOizqCO
	b9eNQiyrvNeovHdR5CFD3bp2tzYwTIM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795133586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9SB4EObKSw+tB9P4IbZtGcg+6FkG4Gy4Q2cjVejRkPE=;
	b=YofJSvQJBbLt4TZCpi1GeEA5e3rYF/3ayIK+HWhJYg91LNa3akJ4EcR4/3ezBO4IG9+PXS
	Hb1ZZv6B54NUhcmOu/p9AhOXtujLw0xtKCCE41YYSn0F8SkFKYoAyXQgiS44qRzWWEvIAG
	KqTgjWclKQCKMYhNUBABStvNBIQJ7qQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MpiwPJcG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of evanfengff@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=evanfengff@gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-94960131b30so41294385a.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795133586; x=1795738386; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9SB4EObKSw+tB9P4IbZtGcg+6FkG4Gy4Q2cjVejRkPE=;
        b=MpiwPJcGq9fvCpMFcSxFbv0jszfluR4G0bGUJEjsJhqgiuC4cX1hP6OgkVMUSAJevC
         IOj5htLM96klcYbic1rOsfz2FAZxabho1Zp4K3KIvEh3KaP960haaZaTZo2Bk31Sj+dB
         QUewOdzdw/hVImMFdrRAmiT0r7ZQtBU5EhgzsN0DqUTvBFHBQkPW+EBCPQsiJVi1WoF5
         k3og0Mr6kd+HQZjf7lCoV92i1jGBSJH1XH44c1RHJ9P3u76wE6LbhSTkCjli4qenW28s
         e0XudydRpZlszo0YTMFaZ1mjjdRszaNQez4P7RllgjaVvChAqd0g5VK7UWuh9Uzij1fz
         Ytpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795133586; x=1795738386;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9SB4EObKSw+tB9P4IbZtGcg+6FkG4Gy4Q2cjVejRkPE=;
        b=eWIij58xnqVx4ByJfiSvunFHIo3m8xv6ufIAtcq7qWJycMhBACRKbmyUpJi0697sHZ
         FNRNo1SqKxCsCNeN6XNy9q1rcF9+CMAXyL4JoaZu4/GvuoBhuEkLwJ748VLBeITQDYns
         hO7rWJoj+ajxRbwo5rwVABVqSZRQ76FphGCvfm359r5YI6KOUafhHiRqvbOniARLA7IP
         HB/g5vmqDV8aNBMGHpjqcC/kih3hoZl/upZ82yKp/ZLbsLIw7ZXUf3jCQrnAK9ArA7Pb
         LrfKv8KQexqIhsc/+RJd8beAC7vws9hTjbiUznlEsTY1ifQfv3hiKZs5KHwEg1A5pNvI
         1iRA==
X-Forwarded-Encrypted: i=1; AL+hErGUVJlxpD8NvLYWNY3rxGXsnVYkgHXBEd3LZTjHUVXA+zf7nauTqOE+USos3uEGbFF83x/AfMAPpg==@kvack.org
X-Gm-Message-State: APuU4Z/+Rit40TSG+NdkQ2w234SMBZRStjx7/J5wV23v06aGZCbasD0H
	JJZmFFpDKPHwLS4+L+9SFYk5NlNkkO82c0IcfBTXRro2ZAmayeThJ7H6VCWkDOY0
X-Gm-Gg: AZFdTZcOslQZ41Si6hYPNOeQHTwMcYT2TXDQhCF3ln3U8ZOfNjlV62B4HlzTs7HA3Uy
	0v/rcQEI89HUdeORZ7by2tOuDxGRhIDe0DcVLbQPmQR/FGZzSAYTPXwIJtpI++O87xajnZdcKUR
	5sz/FGcaSmchrfsvX5ySKgFPGOHnJfF45/1rTs5pNo4oZ+vPYXJ4idaH3FcQcMBMfUoMowMZw4U
	ThX8UyIMsBKZlsjCHOXUpwh4LXlzJgc0RFdhbYgcxK6sEq9osU58yRj0H6PUs6WtmwQSuxzGKmC
	PhooCXCaOhpXmlUzqOyoUYLVLaU1PUReVjC90R3NrCk0i8vRYGzyQHduw5b6v/2hapy+VLFjnBL
	NK07Cl/PHVTkFXnoT+c4blvw/yJuf22AxH+ZQVxjHhyfyYyYsWUL3cpjmF77m3PPXETcehjZ+Jw
	8hQrL6KuRLttQzydS6qgKcGcvGEL0Ke/nnx7Fvj9OioU5Aa7OyajOFpjCbTShbMcWPAH8nRkLOc
	tecHSbVZaPehvo9d7Y49UxJoPLwD0dIFkeFsQGamAnxPOJRwazz0dOHM2CF8rjF6UFCNp/tQKyJ
	ZulW6Kav4IG61dXPd1AhDCUIUM4bWapmdJt4IfkX0hqFsn6hg3TmEtOz8ymNnBFHclv+7NGRhxo
	Bkgsd7adCcjT3qR/0BB4HXR1t7Az81Xz0DdraQcmrlLtqxMI9JUKdz3q6hBs=
X-Received: by 2002:a05:6214:3a84:b0:921:3171:b604 with SMTP id 6a1803df08f44-92134b48c88mr23359986d6.54.1795133585733;
        Thu, 19 Nov 2026 16:13:05 -0800 (PST)
Received: from FKXX2DL94F.bytedance.net ([72.29.204.230])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9213515f467sm8311096d6.41.2026.11.19.16.13.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 16:13:05 -0800 (PST)
From: Yifan Feng <evanfengff@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: fix damos_walk() hang with zero watermarks interval
Date: Thu, 19 Nov 2026 16:13:00 -0800
Message-Id: <20261120001300.11809-1-evanfengff@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261119014247.119946-1-sj@kernel.org>
References: <20261119014247.119946-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: ADFEB1C0003
X-Stat-Signature: auy131394u86ypbnpqnntcnqqh5rbn5f
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795133586-32919
X-HE-Meta: U2FsdGVkX19CQDL7+o5EO/OlLGMcpkwWwbi3G6kBIOdZYc+DVjlG9G5l6cZE4Q0nX6TZjDnU5+WmBD5/EAieouDh+GUetI7PUR1oPY5v2IBrulnQ2gHi8ATKl4If2iGic7XYu3gyM0Sv9b9YE1ZfVn6/SKgckgsPBpqnytegQ/95CtBxMB+JNYQwSNT7WmjdYvuDOGT2a3W85qnOCVdoDBAzKN8Zkaq5ERntyefvPXZ+gscPzHQVsUyDJuCtxnUCgV0T/YIWqaL0PPaoIzI/0RbU6ICai7WAM3Yk31qxLNU7hJVHnyruaJGUqal9DDak6VmE8lZ5jLpvJBSMxh+tXcCV/iqst+lK+lphz10M1mDkwyEz5ihSDkL/i6WvASrqWxbCr2AfRywAVGWgc0eMcOoHza/nV0pTuzWFiEPwYzlxB9CnPkKreP6mG7cs6N+2ZrGKoK7i+uOJZCsw2Lcj0YmkkUjOOZkRkHDgUa5rJqXBcC9S9T6lldCdxBZHO1T32KU+r0p6qQr1qjLu3wlAwLT7y4Y4aiDjZB5qfEpZgCjC0H+xYH52owx8UsvZGnRMiDa2btGK3DjopxQuh7V78r95YW3WJOQ0FVWGxLNRK5e7ul/2ozNzOU8V/lASgF2UE1N0bEQcZPirHZ3wCi+rczZ6Cjv7fFRoH8izImGYpp56T6zM20GnWIyJ3yi0Zwh+3a8EfwQXgkR4wpPLUJJzSEevatpjAFcTlb/hBGXbWvDMMankBhNuylq8gZPTsSxvMotfnxjLBjuV2NeFK2i68wgNfanyojLB2nrmKv7dw2+fCbciS3OLBVc6AK6ivNFGTBh9dhzCnfb0gmLqpeYMgnVIBRDvtS6abElgL3W9xEuP17ToiMMn8gXdjnVwYu7jGIL0lODdOzOJw5LIf+oR4rdeOtoRaLjTAMJbb8wGGvfHCyB/j7uFjgTa8hwHcYg6gAf6wYwkJvyOK1TtXge
 M3gzAATp
 t+Ani43mU/emCCCfTj0+PUYuNl/h21MHXaKVEFUkK0AbG6PbkcLsX5V8lNvgaDisqKRUVLhCN1FphSLPEnTneeg5yQaimZ//9CeF5JiALOZVaeFe/2Qo3ImnAONypAjDy0DxhJylItoDbw6DHWfEiArvX22/rI0MawE1huNj37L1jER8LNncAWROu9f9KIlxxNaogsaFEbXYOISIo+pP9uv91Xa+SMj0Go/jY/FXSctZmT/wWbyt6sVv/58MSpYRNhyOL8vImFNukjjRIXUTAHzugMRTrcnHsY81KOT5P5lRO805+0NvvLtmyUWU77EZ2acTFY1aTGYVqNQRPtZCod5rJ5vdD8vHh3CTaJ/K8kDUg87T0lYgeIfkIkZ8FRIH69hBeFvS8KJty9mSPKSak58eSKq9pGCdrV+/5z26lepofKq0tVmP+sWlFXTQL6L8UCeoxCMP/bpNw6T8z6lrl5FA4hrYjDDuaGAywJy++QXjeiiIqVtuMY295fuJDMd1LFQmp4Oo30jljBfC6jYmwGf3AMppnxGDt/0ML6UNJzgBp1lRm4Nbh8om50YyvsNjffUAH0GlwQpLNDiEjr/iwiVeDK56TubsM0lT5bNAWJyJ+l0iXO7i2qytzlCffzV34B2xQi/+GZ9pycxUIL5Fu/XdcW7AHxaZM3cVPr0l2I/l0M/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 17:42:46 -0800 SJ Park <sj@kernel.org> wrote:

[...]
> But, this could make has_schemes_to_apply has false positive.  How about
> calling damos_Walk_cancel() when has_schemes_to_apply is false, like below?

Thanks for the review.  You are right about the false positive.

I tried your change.  It fixes the hang, but has_schemes_to_apply is also
false whenever no scheme has reached its next_apply_sis yet, so it cancels
the walks of activated schemes too.  In my test (one stat scheme, default
intervals) 18 of 20 update_schemes_tried_regions writes got -ECANCELED,
and two selftests fail: sysfs_update_schemes_tried_regions_wss_estimation.py
and sysfs_update_schemes_tried_regions_hang.py.

What do you think about cancelling only when no scheme is activated?

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3492,9 +3492,13 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 	struct damon_target *t;
 	struct damos *s;
 	bool has_schemes_to_apply = false;
+	bool has_activated_schemes = false;
 	unsigned long max_region_sz;
 
 	damon_for_each_scheme(s, c) {
+		if (s->wmarks.activated)
+			has_activated_schemes = true;
+
 		if (time_before(c->passed_sample_intervals, s->next_apply_sis))
 			continue;
 
@@ -3506,8 +3510,12 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 		damos_adjust_quota(c, s);
 	}
 
-	if (!has_schemes_to_apply)
+	if (!has_schemes_to_apply) {
+		/* The walk cannot be completed while no scheme is activated */
+		if (!has_activated_schemes)
+			damos_walk_cancel(c);
 		return;
+	}
 
 	max_region_sz = damon_region_sz_limit(c);
 	mutex_lock(&c->walk_control_lock);
'''

With this the hang is gone, 20 of 20 writes succeed while the scheme is
activated, and kunit and selftests results are the same as on the base
kernel.

I will send v2 with this if you are ok with it.

Thanks,
Yifan

