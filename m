Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B192C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 18:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016B86B0088; Fri, 28 Aug 2026 14:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08C86B008A; Fri, 28 Aug 2026 14:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F1C6B008C; Fri, 28 Aug 2026 14:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BD6716B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:29:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0E73140550
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:29:20 +0000 (UTC)
X-FDA: 85151515680.05.C2D55FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 12EAE10000B
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 18:29:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5vOSBrJ;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787941759;
	b=RNQO9exhmGZwJ74GOV+SYKI8OQZGlwgLs8nyfOsAOtuYMro1ma7VtFkz+Y+dCj8t9qxqH4
	m2KbeulJ+shzIJIAdtSUNvfVKdCPiOOtVc7X18onsSWWlXJDWUhHc6/ovDmfmXOqdvZksb
	BrO/5J/mzwUaQF35qgbQzwBi8U6IXzQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787941759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QeOHqKFwwRXxKDoOadJ6pEtYZjxux1n/oCSHCxWNGR0=;
	b=hYVlAnv8P0JolCLi8l6L2XNqLZB/9LMH03IXTZ0JvZ3NefGdO0uY9GSwmUBVp7htZX2h+O
	3fBHJO1gp+0YAFbLI6UsWzYUerQnjvn3PpWnb49lxzHS7nf7R8sDBv9TaM/dhBZ048fo1T
	5mL7rU45Lgl6jMahQaL+6w20s/F1qos=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5vOSBrJ;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72E0C41AAA;
	Fri, 28 Aug 2026 18:29:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183801F000E9;
	Fri, 28 Aug 2026 18:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787941757;
	bh=QeOHqKFwwRXxKDoOadJ6pEtYZjxux1n/oCSHCxWNGR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5vOSBrJlYoEX0iEEqFMvHyD/qvqqQD6D8XY4ZUpfg4jNKBDyLgJq5Zb+GQQ3GSI/
	 ZqWPV5YPCatrwZazeLHntHVDTKLi6fSFRzXWNQs45KQ4n+kQG4BYp5jfIT16Q/H/mh
	 jZezdZv/flg6Ym5n/H7JQPAzZ4VVOf40vu3kb0evCD8LtY2M0tY/YkZ9xDDJy2XYlw
	 gsz9GiW4nm1b9HNHCGwf0QXiqrYgq4k9zjigo3iWlrcJGULrFs5g8emNh+35bHcc3b
	 5q0NugBsnP6oRcJ2jZGthMU9G5y+5NPSUpvTyzXgTXsBE7EQZDwiBwATFOvhMZtzhx
	 gRtHWBUzW9fbw==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon: fix unconditionally skip last region
Date: Fri, 28 Aug 2026 11:29:09 -0700
Message-ID: <20260828182910.70304-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260828084737.290024-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 12EAE10000B
X-Stat-Signature: ewo7n8npp6jezsg348p6zc7p3org3x98
X-HE-Tag: 1787941758-132293
X-HE-Meta: U2FsdGVkX1+Hetohq+LmkaA/upEoIygN29IgWgJsv+WjlzVTbauVo1VOPdyAJ8imyUFIYOJ66c02wbm59Ba761MxUIwGeygd73QCzOA6hvugXwR7t0nekaVmBB31yriJdwUBw5bLXOV2v7tHoRB+UAJFOYZZAEeTTTnJa/2cEZ3iB6Oy1nNOfkF4D2Jb9o8L5QsHVQVZjnJWc4A34tTnGvDqoIM/soOltlqsc4Q2Q7/lvtDWAJ3vgLzcFt42X9VF9dO8z3RJGUeZn4klYgPugHID7MUcp7RZ7l9klScWVUMwihSmuFzi8woAwp5SCiLHfbgtXZQnrDkeId7vqgWohPllEY9KfSP3/bYjjA0YPsdh3W8G7FPTjpkSVBK07GmQWPpFUUhhiv4WcEiIAyHqzHUylSmJBVz2XQyGeQgdxKB56JM8KylmR7suChYEadgQSJ00I2FoW+AE6eBdu794WF9afghJZSWMj7OE9Nhc6mIomcYTFRvkbC1qLb94bitTOoGYQ2rs5LX5Pkd0A1wkdtJeKUmYywjd3+M3wqLu683kT7fxAPUalb+vB8B8yDDf+YoLzyEzNmcXdZ9iZtnLf8JW2pVQCVV2wiUMchTa5D4E72WcHrhkFc73ejfyBLEu519fh9Q7UNIBhM65/5RCn3N6cRDy3S4leTNey7sg3MvZwWUTO3lSLdI7p6at10EBhsFeyRe2sgsrx5NPDzlMcERrlin8CJLuLNlYphBOkli49NAYNO+LgBT00Gae+q6MoRYbelY6ptvmtmMD/ZTszKbnIRyvBRpNbEjMDEApWdFTEv6kVcL3xcSraoyGhLCgJ6T7pih77r1pfysmQLlX0Oqw3paw3u5mAhz96ne4FeL2/01XziVYHqUjLYkXVGgaD28FhyHrCRF7RtNno1ezp9JqCe6zuZCecSW/z1Wvosj+ai/6GHOphLSkA9kd9hKc4v91TaA7V+lY1jHCig7
 J0O3Tyrh
 NbgSTbupHgCELKciS8+RNIt+lofCuSrvDmJlt0YHIE1fJrV3NnURyMyWvINHPN5Vwq0jivhAtflRCuNKbA2PiVw3IcTPvqhVTsEwxauf0YK14tKluGiVgo6cPg/z9sUwG+QrvHlE0v1Yir0oQCcy6uUX7QMw2ZnNaz3vMXWtpJQb+vakliNNwP5aT9bmg8Y+C837u6roq6wtqWLuNlHm44H48YpHis4leUtn9hyZzgUi4iI7NLhvr98oTbtKRbRRAn/i6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 16:47:37 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Once quota set, the charge_{target,addr}_from unconditionally skips and
> resets at the last region of the tracked target, so the last region can
> be skipped even when it has not been processed.
> 
> Example:
> 
>     1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
>     2. Quota is configured to process only 50 bytes per window.
>     3. Window 1: Processes R1 (0-50).  Quota is full.  Cursor is saved
>        at (Target, 50).

Cursor means charge_{target,addr}_from, right?  Let's explain that, or just
keep using the terms (charge_{target,addr}_from).

>     4. Window 2: Skips R1 (0-50).  Processes R1 (50-100).  Quota is
>        full. Cursor is saved at (Target, 100), which is exactly the
>        start of R2.
>     5. Window 3: The loop reaches R2.  Because R2 is
>        damon_last_region(t), the old code unconditionally returns true,
>        skipping R2 entirely and resetting the cursor.
> 
>     Result: R2 is permanently skipped even though it has never been
>     processed.

Let's make example simpler by setting R1 (0-50 bytes) and R2 (50-100 bytes) or
quota size 100 bytes per window.

Also, it continues being skipped only in a corner case that the region
addresses and the access patterns are kept.  So the user impact is mild.  Let's
clarify that to not make users unnecessarily afraid.

> 
> Fix this by only skipping the last region after it has been applied.
> 
> Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
> Cc: <stable@vger.kernel.org> # v5.16.x
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
> 
> Changes from RFC v1:
> - Minimal fix, only fixes the issue where the last-region is skipped.
> - Add an example to the commit message to demonstrate that this error
>   occurs very rarely.
> - RFC v1: https://lore.kernel.org/damon/20260825124616.5129-1-aethernet65535@gmail.com
> 
> ---
>  mm/damon/core.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 644daf5a1656..21dc6b086c42 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2347,14 +2347,15 @@ static bool damos_skip_charged_region(struct damon_target *t,
>  	if (quota->charge_target_from) {
>  		if (t != quota->charge_target_from)
>  			return true;
> -		if (r == damon_last_region(t)) {
> -			quota->charge_target_from = NULL;
> -			quota->charge_addr_from = 0;
> -			return true;
> -		}
>  		if (quota->charge_addr_from &&
> -				r->ar.end <= quota->charge_addr_from)
> +				r->ar.end <= quota->charge_addr_from) {
> +			if (r->ar.end == quota->charge_addr_from ||
> +					damon_is_last_region(r, t)) {
> +				quota->charge_target_from = NULL;
> +				quota->charge_addr_from = 0;
> +			}
>  			return true;
> +		}
>  
>  		if (quota->charge_addr_from && r->ar.start <
>  				quota->charge_addr_from) {

As Sashiko pointed out, this doesn't work if the the last region's start
address is smaller than charge_addr_from and the end address is larger than
charge_addr_from, but the size to skip (charge_addr_from - r->ar.start) is
smaller than min_region_sz.

As you replied to Sashiko, let's do the last region handling in every case.
While doing that, let's do the charge_{target,addr}_from reset in only one
place, like below.

'''
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2688,36 +2688,40 @@ static bool damos_skip_charged_region(struct damon_target *t,
 {
        struct damos_quota *quota = &s->quota;
        unsigned long sz_to_skip;
+       bool skip = false;

        /* Skip previously charged regions */
        if (quota->charge_target_from) {
                if (t != quota->charge_target_from)
                        return true;
-               if (r == damon_last_region(t)) {
-                       quota->charge_target_from = NULL;
-                       quota->charge_addr_from = 0;
-                       return true;
-               }
                if (quota->charge_addr_from &&
-                               r->ar.end <= quota->charge_addr_from)
-                       return true;
+                               r->ar.end <= quota->charge_addr_from) {
+                       skip = true;
+                       goto out;
+               }

                if (quota->charge_addr_from && r->ar.start <
                                quota->charge_addr_from) {
                        sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
                                        r->ar.start, min_region_sz);
                        if (!sz_to_skip) {
-                               if (damon_sz_region(r) <= min_region_sz)
-                                       return true;
+                               if (damon_sz_region(r) <= min_region_sz) {
+                                       skip = true;
+                                       goto out;
+                               }
                                sz_to_skip = min_region_sz;
                        }
                        damon_split_region_at(t, r, sz_to_skip);
-                       return true;
+                       skip = true;
                }
+       }
+out:
+       if (r == damon_last_region(t)) {
                quota->charge_target_from = NULL;
                quota->charge_addr_from = 0;
+               return true;
        }
-       return false;
+       return skip;
 }

 static void damos_update_stat(struct damos *s,
'''

Btw, I think damos_skip_charged_region() may deserve a kunit test.

[1] https://lore.kernel.org/20260828090410.40AEA1F000E9@smtp.kernel.org
[2] https://lore.kernel.org/20260828115047.332978-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

