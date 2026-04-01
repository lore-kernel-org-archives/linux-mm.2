Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8735CFF4937
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 03:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751EF6B0089; Tue, 31 Mar 2026 23:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DBCD6B008A; Tue, 31 Mar 2026 23:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA576B0092; Tue, 31 Mar 2026 23:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48E056B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:44:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B7C758CDF
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:44:00 +0000 (UTC)
X-FDA: 84608593440.16.13030D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9BE5AA000F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 03:43:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OV8d0Wf+;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775015038; a=rsa-sha256;
	cv=none;
	b=HJcetdoGzFDq4ni7XTx8RbZ5vSZQDrrItXCLLDpnybHKDvTDl2ZMj7uLHP0E1hycVGp+EY
	ApIv4s+FTlcXtUkX/go75JQjy/7x28USt+ab4kB397V/d7+ur1lleXNPkymOdmH1keBPx6
	EJRbIlHG7UXn3dJuNRfiErlZ17NLOAQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OV8d0Wf+;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775015038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qd9Kt6lCmdkcz9ijZJA3M1Y3384UtJDIjo0hrWX7ud0=;
	b=rTt0Zf2avKdzMvZgvj7Zf/Dz5jOt+4sdlPoHAKHWJMHyn+4nt48jAmimHim9X4nwzO6Gs6
	AtWOtdPIheNRK48jq1oy0gldKCmykVvxgTmYdeIZmhidbXoHrccDJMWiG1x9oaRU+CT9TI
	6KXGYki8B5FAMJGAkA9ufVIk1J5zLNU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EDF3400E8;
	Wed,  1 Apr 2026 03:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6701C4CEF7;
	Wed,  1 Apr 2026 03:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775015037;
	bh=QSfLLk6xmn3JZ8oYEIuAcMLoScEZWlaljB6P28xGj5o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OV8d0Wf+iJ9LLRJZCzDuGEwhkq9v+3qC4jwq5UvHBAV1SNbqipuq7n0Hn31RydbrH
	 11McPwJs7KlTRMtlFTXLP21SyZ6D56EsUH1ZkZl60YMiOrOAmQiTIfEtM322XRucMT
	 fNsvCPH8fkoC6CSRev3mTQ4nBxczW8uqqSIFeEnc=
Date: Tue, 31 Mar 2026 20:43:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jackie Liu <liu.yun@linux.dev>
Cc: joshua.hahnjy@gmail.com, gourry@gourry.net, linux-mm@kvack.org, Joshua
 Hahn <joshua.hahnjy@gmail.com>, Donet Tom <donettom@linux.ibm.com>, Gregory
 Price <gourry@gourry.net>, Alistair Popple <apopple@nvidia.com>, Byungchul
 Park <byungchul@sk.com>, David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v2] mm/mempolicy: fix memory leaks in
 weighted_interleave_auto_store()
Message-Id: <20260331204356.bbc585801a40bbad07ff52c0@linux-foundation.org>
In-Reply-To: <20260401005702.7096-1-liu.yun@linux.dev>
References: <20260401005702.7096-1-liu.yun@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hfehemaubgz4cjp7o1bupbt4wejg1ec1
X-Rspamd-Queue-Id: 9BE5AA000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775015038-882324
X-HE-Meta: U2FsdGVkX1/eB13aZdrkqFufeyCq+i/AayLa+Tyer9ZAaPAzZT6jXR4NGUgESJCgAlYP3Mp7gcRRTNuNohFeMb1XmXDhTP1NOYf5RV5Un+FtixPiMXu2KWryUzXtK9+xWNd4HdjHW80nRbIIGdcNaRFIZjYKyUvsPqWt0zkujedE+2BatoNfm2JWT+BIRonwlWlDFv3q9EEmEVC84QqmZbxU2apvj35PAJeV2etp3xaB6PsUwphPYXx8hvDrk71U8eTTyJejJt/TGwzZHl65VzFCfMC2jxmTq0CGc3eomTwZvn0Vx6oXylQzVab+25JXPJ41vBDf9FupIk6ETKiHZCMXbTO8Lcxcn+0DJiwAfVkCOMky5bSZjFIOhrVAz3e8slm1wWA63vgH9YOHOUGbPfElSfG2qubHpHrAkyrCQ9lklGmPb/gJX8pgMpk6ahztwXzJSX6faxsimsdG9Zyr7aeoNYz818TnaHIukzRAvD9/lFLhDij6cwZolSWcvUgodAcoHcSAOJ2JyfEE0lAd29d6zvMThjxj7vBsukqcGNQ85QxMTGOeCv73EydFQ3FRl0zrr3JVuAvZEkp3EgGt5vNn3xfE/Hidxq46twyK0E0ler8Y2GhrPgUXKPixZi7tQX64UOckGrvxgvK4ymW4BTXJCeokAHSGYYzDjYeF06MQzZCqC75d9OYNhaSLKTaMhClJWMGkiCeRehtYN8jCewEQV1JEI10No9tA+FgMUc3zWgZ3/4eoWBpW5ksedwYQ09jcxtmHtnK24CkGmKLrs5vd08xRTzxz5i8A0Qyew9ez5cTSAUVdRRfBpG4RAz8gILs8KZOkINGz+z0M1b/okWlq1e8zTJoxbeCN48ezbSliwhAENPDQUnFqRkOnXB4yPorLvCN6iHbxJc2k6iOVXL8uZABKc5nqiW8qnWCkT4EVrdh+zHF6cEVuJqzBxVQLgeNuOoZ51tRZJrf2/Cv
 NThdE3ow
 r0cq4E2IIFn18CVpb8mBUhwWr73Lu3ixEtSWDHz0rHL1EsMOU65vnH5YHHgkgk4TgWl/k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Apr 2026 08:57:02 +0800 Jackie Liu <liu.yun@linux.dev> wrote:

> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> weighted_interleave_auto_store() fetches old_wi_state inside the
> if (!input) block only. This causes two memory leaks:
> 
> 1. When a user writes "false" and the current mode is already manual,
>    the function returns early without freeing the freshly allocated
>    new_wi_state.
> 
> 2. When a user writes "true", old_wi_state stays NULL because the
>    fetch is skipped entirely. The old state is then overwritten by
>    rcu_assign_pointer() but never freed, since the cleanup path is
>    gated on old_wi_state being non-NULL. A user can trigger this
>    repeatedly by writing "1" in a loop.
> 
> Fix both leaks by moving the old_wi_state fetch before the input
> check, making it unconditional. This also allows a unified early
> return for both "true" and "false" when the requested mode matches
> the current mode.
> 
> Cc: stable@vger.kernel.org # v6.16+
> Link: https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.dev
> Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>

Thanks.

> Changes in v2:
> - Move old_wi_state fetch unconditionally before the input check,
>   instead of just adding kfree() to the early return path
> - Also fix an additional memory leak when writing "true" where the
>   previous wi_state was never freed (Sashiko)

Yes, this has changed a lot since v1, so your removal of the three
Reviewed-by:s is appropriate.

 mm/mempolicy.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-memory-leaks-in-weighted_interleave_auto_store
+++ a/mm/mempolicy.c
@@ -3700,18 +3700,19 @@ static ssize_t weighted_interleave_auto_
 		new_wi_state->iw_table[i] = 1;
 
 	mutex_lock(&wi_state_lock);
-	if (!input) {
-		old_wi_state = rcu_dereference_protected(wi_state,
-					lockdep_is_held(&wi_state_lock));
-		if (!old_wi_state)
-			goto update_wi_state;
-		if (input == old_wi_state->mode_auto) {
-			mutex_unlock(&wi_state_lock);
-			return count;
-		}
+	old_wi_state = rcu_dereference_protected(wi_state,
+				lockdep_is_held(&wi_state_lock));
+
+	if (old_wi_state && input == old_wi_state->mode_auto) {
+		mutex_unlock(&wi_state_lock);
+		kfree(new_wi_state);
+		return count;
+	}
 
-		memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
-					       nr_node_ids * sizeof(u8));
+	if (!input) {
+		if (old_wi_state)
+			memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
+						       nr_node_ids * sizeof(u8));
 		goto update_wi_state;
 	}
 
_


