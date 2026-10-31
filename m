Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B5F6606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dXuiWQid
Received: by kanga.kvack.org (Postfix)
	id E2C8A6B05B5; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD756B05B7; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAB06B05B8; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A05FC6B05B5
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D669C0A77
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:25 +0000 (UTC)
X-FDA: 85384053930.21.C98F78B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 81EAF40008
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dXuiWQid;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793478383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzYWdZOqtsRFb3ngZK/C1CAHvUR8f0Jk0wMaxETN/S8=;
	b=hJO30/nrqVuIh0Z57TD98VmVpzcUo+XldXbzkZt4AmGuVl4LmaKV5vsXXzJ/LkZLFbfBSD
	UlIm8fLoUTPv9mekA/PHb8DQalJF8tS+x7LE+o6apdtoSfcdW4ns8pWTYYfTH/3mhAd88/
	kokgZS7LCTt8S/nHMP7lKysNB66BwS8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dXuiWQid;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793478383;
	b=t17DwTvFAftvOYTghZRZ7yEDcrlFC8Ko1tnT/0oYrMv53uy6eZGIkj70vn97iSX+0k2Byw
	25O6g7n1qVMMHQm34RgKP3FiW/FmTaVOrOw2G6ZixgAOE4B1hydLaoZDgfIMVfcV+GLJ/6
	iFxl2Iwunm419SROwbqe/DLIwfZH6Pg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B50D643E2C;
	Sat, 31 Oct 2026 20:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745481F0093A;
	Sat, 31 Oct 2026 20:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793478382;
	bh=qzYWdZOqtsRFb3ngZK/C1CAHvUR8f0Jk0wMaxETN/S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dXuiWQidxV4GKs1te2r8gQmqYhcV1FaR1jedExIalifCzD4YoA7zD4x7ducE94Zbx
	 VSXw9pzJ0MtbNE57AWdEBBEm8j/4qxd9wLxHgBMsq4y4TVvwXgvCBMyLTztCngesZv
	 xGmqDr6Z36wN5ZxnpHhCmCK5Tgwhlr4RB9izoTQCYt5RMEGFAQh3IU4Kv6SQn1Fw7c
	 mA9n/ivt7TW+YNqdRqEY7YNIJq5KXI+I/o7/UF9fRxEc+oXkJnmvshRnGrlDSXAIRc
	 /Jd15eCnt6ozjqwsV9gLsRfKGG3SwX2f4cZL6hWZ41zm6/SYuXfvFkWeKN88R2q1/S
	 RRtvmySP98taQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/6] mm/damon/core: handle invalid target in damos_fix_stale_charge_pointers()
Date: Sat, 31 Oct 2026 13:26:08 -0700
Message-ID: <20261031202614.96036-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261031202614.96036-1-sj@kernel.org>
References: <20261031202614.96036-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 81EAF40008
X-Rspam-User: 
X-Stat-Signature: adubb3buq3tro76nibhpnmr5bzodsy8p
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793478383-380679
X-HE-Meta: U2FsdGVkX19CEs3xFzHNZd6DGJMVoKfpDdkki37lw3AIbDqh4CvCoGvmPbI5tdUHRit9CEFucn54WTEJRZmA4wpqbj75Lrm3EUwzlX4Wj10EsjzMSn1bTntE3Kt6isfh93W4HVoN/mGMZgiVlxOTm2xXSK+PTT0VtlvlCNKf0Fm7NG2mWSAZs6Q/R2cqgTqbXURT+cj7Dz27P4c3Q6enWuFp+8NC0AOU0UrZ74tsi+BStlsqokpw+fVOEFHTskRtQ1J/qRwfyU/vLxsTAuCyTNv3fq3zqCj5B1NGWUu4ZQGPufT55YVc4WHAsgGyYWkZn8AOwU1Wpu9GBLWIzwQUgC+mhS3MHsIB5vVM2JZn4mLf2jMCpEfEmctX5kn0eZP4yiVPVUD5kURNRZIioaSUQjN4EraLXQFY1RNJl2tBU3VReyjU+Ljo3CsIxg9BNanQBFVsrk3ogEwCAygDQmCskBLZVWbwJ6XTyzBS7tQ1LFS5ep78EoP8nIQbLmXiTcoRTXFIvk6R/kw6xdPYLfXkZVsOT4XNVZhjZjhxSQmau9oS5eDtSahPaDmD88ZM49e9KlzKmS2w2YhAZ4C+xB5iGejINV5f7OMzwUP02WxfE7eViWxQJiT34ARJ6JGnMb2uEg/WL7yIhic1X4a6Dcxn4kJ/+FWoxVIrn4rfSjP12JzsaWl/zpvfsOyopmgYPA3jhjIyJJRkNyAen/6JUCjYZVfU2QGdIppa/zauCRAEfZ58sVe6Hvbuon37vTV7l6r/EpqXSGn6fkcAK0zIs7e0ZrG/8x4qP49opYtpkhqoPcgiAchZH92jwkhjn1Tt72gWZWFfQFjIW0nrS6CE1hNuISKSI5gFc9hk8zlE7lu3jZw+nBaStvgVoJxXJoN3BbVfTEJKAvGBWpoKsFct6tzaI3bmK0RizbwY+KqFDNb+HgkwzbTCo7AdTXRAUKJ1IV5ItDy6sZgSESX+clRQJuW
 8ceSsKEp
 iwXuwiKds2CanpLztBuA+ABzPI/P7kO8yJXSrFlR0CKG4Hooetd7kJcHrY0JTLRm8aIjODgYSjSSJOAlMYn8Yv1Mx+gYk8SgScOXtFakhU3spHnnRBOjo2ZTZdm5pdnm5zqfFxTFmMvZ/MaTzcGw1p5iDbIRZ/m9BdbJHKzBRbynoDbx6sGsiTJIUCFYbQqaszY15ePTZ1WV4CIa57MlEO0W9OpkA4KJb0mchBJyoU5znaOCkDGUyCYEjUdhdIsx2OMSfb+TJAphlROqR75UV6PuuPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The fixup of DAMOS quota charge pointers
(damos->charge_{target,addr}_from) for removed targets and regions is
done in damos_fix_stale_charge_pointers().  A similar fixup for invalid
(terminated pid) targets is done in kdamond_apply_schemes().  Having
similar fixups in different places only make it confusing to read the
code.  Consolidate the fixups into damos_fix_stale_charge_pointers().

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 73b571b429cb3..ce75db510a9d3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3394,7 +3394,11 @@ static void damos_fix_stale_charge_pointers(struct damon_ctx *c,
 		return;
 	damon_for_each_target(t, c) {
 		if (t == quota->charge_target_from) {
-			if (damon_nr_regions(t) > 0)
+			bool valid_target = true;
+
+			if (c->ops.target_valid && !c->ops.target_valid(t))
+				valid_target = false;
+			if (valid_target && damon_nr_regions(t) > 0)
 				return;
 			break;
 		}
@@ -3513,15 +3517,8 @@ static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 	max_region_sz = damon_region_sz_limit(c);
 	mutex_lock(&c->walk_control_lock);
 	damon_for_each_target(t, c) {
-		if (c->ops.target_valid && c->ops.target_valid(t) == false) {
-			damon_for_each_scheme(s, c) {
-				if (s->quota.charge_target_from != t)
-					continue;
-				s->quota.charge_target_from = NULL;
-				s->quota.charge_addr_from = 0;
-			}
+		if (c->ops.target_valid && c->ops.target_valid(t) == false)
 			continue;
-		}
 		damos_apply_target(c, t, max_region_sz);
 	}
 
-- 
2.47.3

