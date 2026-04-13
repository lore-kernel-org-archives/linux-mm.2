Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D210F531C4
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83F56B00B9; Mon, 13 Apr 2026 14:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34A56B00BC; Mon, 13 Apr 2026 14:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6E946B00B9; Mon, 13 Apr 2026 14:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9540B6B00B9
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:52:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 501BC1401DD
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:52:53 +0000 (UTC)
X-FDA: 84654429426.14.A308709
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7189D40006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:52:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mtaRKtLZ;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776106371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=irVM8cutLTY8eeIFuQG4pJxfVBZ0vjFm1lARbRd9vcM=;
	b=KvSebBo8vdBarAeHLEd1w2P7DzCf2tgYdWaTIJV0cdM772XNYYZKfrw/2ftSK3z4QqKYJS
	Ak6Nr4jb4anzqzwQIA3yBmKMruQMlGDmbHxxX5DAuFZ/22usC3SxH3lkU3DnaDi9d4mpIn
	Yz0tVKH1bXnh6FkX7DB2Nsh+NMah3qs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mtaRKtLZ;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776106371; a=rsa-sha256;
	cv=none;
	b=i8pRgSCT+jf3f2tncovncWzwVi/W5W3KK2HcfBvpCdeOohHizsGoCpczfe7oiEVAUoXWyO
	EyXQs4Wv5BvdvCLu73EnUgw7pIFrybK2jHZIjUpeBaCv5eLACkfGoX0fiBBLwXpSfatFiB
	NzbrTEgqJ7s/VWp228ri/j2OMqq6dM4=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35da8d037a5so2284797a91.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:52:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776106370; x=1776711170; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irVM8cutLTY8eeIFuQG4pJxfVBZ0vjFm1lARbRd9vcM=;
        b=mtaRKtLZskDWDYeJdp8CV9SP9ETRCJt43jkgdVc0tx1TsKi+uPvvPjqaUtgDAr/Isa
         CG7zB6jnzlkqzbV9kZHPLxWty77O45vkx6uQqL2zdu+jrFETn45kR6kSFUgRVg9k5bqs
         3vq9alTwlOPmDxGOReYDTOnFtOqr8rkpHFWuewmmzlw4f1qhmuqnIEWynHpbLRqeVBMq
         zPhuAU3HXf3Vwo0iOcGPizTCOSnJFiy062OaMaZL7zAp1ccTrAigbrFYVzvmYwC9Ubho
         KKzVwxSbUdOyzdJ0chqkiIgGa+VEQqVX3MVk4KaK25R7m8vp7h3zgmXQOeQvc2S6UB+e
         sOFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776106370; x=1776711170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=irVM8cutLTY8eeIFuQG4pJxfVBZ0vjFm1lARbRd9vcM=;
        b=ciA7IQzzBRuE5LudVjJxob/G57xY6AwWJAvECniwfsTdqpZ6vnEHsmXKkaDlW78OC+
         46OAvZ7TX71IxH/1tMYaRX2AqYpoK2XVbxQypGVrF5/VvLZKY8OkmginKod5ouO57r/A
         jSrCiN3ZosMlj/H6kcAuY7T2lMCmrc96wzStIOdbEYpqEW4Ed29lZkUWcSVBXZkwKJeJ
         9HxkI5KMeL/RHr/1qLz/F6YgTSjLywBPOSzbfegy6rNDOIiTHVE3HuhUbh+ARlO0lLCi
         qXe438TMWZfCWLbXGWeOHvLw4EAWyU8iGtLPniXsgP2MlIbRg2jhg3aEMQqEgObQSUBM
         +wRA==
X-Forwarded-Encrypted: i=1; AFNElJ8DuB8mYf8mmG5HJlhh36n333oSEUzLWmfEDoZC/NrBD1ou5D3jMsUGDvsd2f9IAOftKx4ehpdQaw==@kvack.org
X-Gm-Message-State: AOJu0Yzatw+suj9dvqxUmIULp+CmRvpxS1QbPnTPk2iPn6ukqYAYwrYl
	Ff4DIsdjgkX6fBJsZ7qAoMiitc5FUr2TfednsVvkBYSdvihUld8SvtNO
X-Gm-Gg: AeBDievAHiHzlys54+fAEjMoU+GtFBI9HB1ULCL7K9ShXKlwVCGfiC8iolerL6m1ZCQ
	Cj+qizj3JgFTS3K8Gg3m7yb6ONYfmbHXjh2+umjRCabCaPFihqe3HDLpwoYWYhbN2XGCuNi15qD
	c9qeuAu5a+OapPRhprLybNQU3evE+d/xJVZNgVg4XzHYnlOirdSQl8sn1RxLQq2a/uDoGZCGZQS
	7llqyLhetKK6ThJbPMd50CeF3znJCvXtsbI9G/i/OercQuJAh1VYxZ1lIr+k5d1zBoMKgKXkWp+
	OapWcU8E1gDgSo2K8d4BlKoSZIjRDj1wL+BZHJEdtnGsFbZOM9eHCulkItpC0cZK2PwNqxW1z6f
	GKqSyz48EftYpjchWjWa/kJv8Qk0hH1JmZxYQ+UtGshIRNjbCR0NQb5N6U3BXBp76xwZwKNniCP
	xjE2Je2iBX0NrHDeejzMGzgHDd8LcRlQ4wkeBW9uEOFhZZobIx4Hs=
X-Received: by 2002:a17:90b:3fc5:b0:356:22ef:57ba with SMTP id 98e67ed59e1d1-35e42759e2amr12885903a91.7.1776106370251;
        Mon, 13 Apr 2026 11:52:50 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35fc2adae0dsm1225435a91.3.2026.04.13.11.52.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 11:52:49 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH v2 2/2] mm/damon/reclaim: reset thread status parameters upon kdamond termination
Date: Tue, 14 Apr 2026 02:52:49 +0800
Message-ID: <20260413185249.5921-3-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413185249.5921-1-aethernet65535@gmail.com>
References: <20260413185249.5921-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7189D40006
X-Stat-Signature: qzxiqdaiufjnpi19pqr49r78w5iejhie
X-Rspamd-Server: rspam06
X-HE-Tag: 1776106371-227606
X-HE-Meta: U2FsdGVkX1+F7WilufK+qJ5Bz42vq3qAsZghLN5tTQmFm+5BM8tcg6kOVUP5x/OTjYEe/IT737kRDqFtipxYCGSQfMRC9kmOF4D3ddXWcp5GDKyb/1UarLf/wTerkkpKFht80vCE/zW7Q2S1sIdujJ1tNyWh+AgQe9+3M67pvqqxDwWa9btuWmPPHKVzuiN/vfx/S4cW6Wz1PkxSU98Kwz+5TxagvQhbQsAaphgi35lrRK+/ynueuPbuaiMZmDUf+IPGlKt2J2IU9MGG4SDB0N09j91yP0J2OW1GSCxCvX+C9R4v7GRYqhHnMtbEnMC2BSdWMLQ54fF0ifInb4VBLH4XWT1A4VN6fsaEig1EpHZb6eFXrerhgSpBsXCNHBYLW9Az2dSsnu+A1a73tFvUqtY7Rx0HO7xll35Z1dHFwXVyLC0ByM2ZZvBVyyUm+T0Puz6IksHrOUmNziMpS4QuOHHezlXtNv8ptCRn/FYRX5d8X53D1EaVmH85Jfa4QUvzlAHGmADC1YDiA9b6BYcAF+phHLWVQzbKqb3nj96MBqRgRaSq24xu6/0I+LavOCrUO5S0RiM2wjXjmA0cDrHQBr1fRdDOFWt1FrGVwDyD87Y2jkY7+SyUhO1g21NR4QCSMF35UosKCL6yEJNIjnu/IVrGPr2cAeXHv1GOWv43B0gv2X6EoJ0lzvjkalGGcYKVa/5tRoiVrL3QHXhXKfFMr2KWIqUhbckEcKLsBuQYxMb0QJawvA0kPLJPHytyJfpxGcLRM6O8enea1eMDSUI24oQ3NksbTyZrXtzVAqj7klG+/4jMIxxLKReVLj6b8mpsEa2kd8/pcW7xNEvtpRJSFKgwN1RV0dfHvqFVeMwlRLzAsH4SiMuhbodZX8QEIHxes2p5EWFx5Px8V0ZlQbi5vcp4vYavz6dizujCJ1+M6rJw8afmLz3wbOW+V9H3fbffkxByHSXjOSJILRg2hLW
 OkNcINGm
 lbKq3UQzuXa9i3fhvLblmDZscrJb51VD9FcJd8hD4gyPJ1llHReSpBtMBcOjZb8lnS/rxQqTIorm6CRz5vgejpSzfli83HWK3E3MaptK56hP/y8G//qR/OZ6qY9o8dpKrR0aD8xg2ToKDWERmog7IsO3gx3arLz4ZN1qCeSiHd4b3mPc9qvEvJ24EgX+WnL56s2TtcJ5wxXVZGXc/vG+REOIwF7Lv1Ul//3reP0SfDe6gOPBvwFAq3+los42Ci3KFrQ+V+pfgIa7hLGn68OMXLmB7aN6+/uS36B7hWTyR2X4iIufEDfZ+fMz7lkLKZSr37SMIsqZpa06R3/frAyZhxVX2qORvik5Ub4b0QgQt7hwg21nkhq8aUiK/WAtW7aYeGcAeo2qHAEqNCIBu9z9mBvaPr9dLSbsXqece
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Problem
========
When kdamond terminates unexpectedly, 'enabled' remains 'Y' and
'kdamond_pid' remains stale. This prevents user from restarting DAMON
because both writing 'Y' and 'N' to 'enabled' will fail.

"Unexpected termination" here means the kdamond exits without any user
request (e.g., not by writing 'N' to 'enabled').

User Impact
===========
Once kdamond terminates this way, it cannot be restarted via sysfs
because:

1. DAMON_RECLAIM is built into the kernel, so it cannot be unloaded and
   reloaded at runtime.
2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
   Writing 'Y' does nothing, as 'enabled' is already Y.

As a result, the only way to restore DAMON functionality is a full
system reboot.

Solution
========
damon_commit_ctx() sets 'maybe_corrupted=true' at the beginning and only
sets it to false upon successful completion. When 'maybe_corrupted'
remains true, kdamond will terminate eventually.

Therefore:
1. In damon_reclaim_turn(): Add fallback logic to reset parameters when
   damon_stop() fails but kdamond is not running.
2. In damon_reclaim_apply_parameters(): Reset parameters when
   damon_commit_ctx() fails, as kdamond will terminate due to
   maybe_corrupted mechanism.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/reclaim.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..e3e148fd80f9 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -250,6 +250,10 @@ static int damon_reclaim_apply_parameters(void)
 	if (err)
 		goto out;
 	err = damon_commit_ctx(ctx, param_ctx);
+	if (err) {
+		enabled = false;
+		kdamond_pid = -1;
+	}
 out:
 	damon_destroy_ctx(param_ctx);
 	return err;
@@ -290,8 +294,13 @@ static int damon_reclaim_turn(bool on)
 
 	if (!on) {
 		err = damon_stop(&ctx, 1);
-		if (!err)
-			kdamond_pid = -1;
+		if (err) {
+			if (!damon_is_running(ctx))
+				err = 0;
+			else
+				return err;
+		}
+		kdamond_pid = -1;
 		return err;
 	}
 
-- 
2.53.0


