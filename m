Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 531ED606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 01:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WxxJ1P99
Received: by kanga.kvack.org (Postfix)
	id 4B24E6B00EF; Tue, 17 Nov 2026 20:46:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489B56B05B0; Tue, 17 Nov 2026 20:46:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6F86B05B1; Tue, 17 Nov 2026 20:46:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3156B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:46:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 948A4140592
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:46:42 +0000 (UTC)
X-FDA: 85446550644.28.9329436
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 024E6C0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:46:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WxxJ1P99;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794966401;
	b=Iv4TrXXMGE/TkMmocfI+8TvL/JxwXui/Clno4soqBggeyBqY2EPoD3tryGPxw0b5XqTVK9
	2XQwiLXEapLH6JH/gUKhRGoKaFk4yKEBtCRhr5BPn1GzTBViBpkxni4IrjgXo/AdDm60ZW
	uIZ/E9j5N+j/kYGJuMReDbPEAiH08Y0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WxxJ1P99;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794966401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ij7QL2lC6iO/EW2eXzqD3vptmXnm8iDoR9KY7vOdFJY=;
	b=VOAQNOiT85EISjhjOEkW5UyVt3eY+FO4GK0zN5sqSvyDUDf71bD1kdDcYxOD823CZQoahK
	0H+kYVZAFpBJKkLE++w+0/v67C0P+xa0845f0LzF28EQyAtQG/tJU/gDbzZ7E3DmDLc4UP
	Ms4hHnVGbB/ZpAVjnQD4wURUMQE7M0g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 226C9434EF;
	Wed, 18 Nov 2026 01:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43A61F000C4;
	Wed, 18 Nov 2026 01:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794966400;
	bh=ij7QL2lC6iO/EW2eXzqD3vptmXnm8iDoR9KY7vOdFJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WxxJ1P993x7np9WHlyZJ4QJntFW0aBEG9e0LFkNzS+Ag7AgczfP4SLgMUHol5bhFg
	 R2cX2gN5ZjYSlHwz8zC0Ya8f5gn0BQYbZL/iLJL0YifGiEUXvNSAHKRxxw96TpTDJk
	 /LwfilYnjusNIVO64EIDYbwpSuSILhDF7TsFvA6Ra+3TzLLtJ6NXv0vgrK3hVGj7nt
	 5lkx/wJyGbuHnPgWX2sx2soW4S9SzHWlheKFh9Pkk9XWlaQRIhxlR5kp6ZfJsWa22/
	 nsdaFKst/ck4eF0aGQHwJwCbIF9DhUsvk8GjRncWi6UjecYLqmkCi+y1v1iDgLhP6V
	 Dfg/fDTCjWnDg==
From: SJ Park <sj@kernel.org>
To: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/tests/core-kunit: add test for damon_call() with repeat control
Date: Tue, 17 Nov 2026 17:46:32 -0800
Message-ID: <20261118014632.95656-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117174834.29182-1-saileshnandanavanam@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 024E6C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: etk85ammd4grmcbx89nphnpuwstmfmyj
X-Rspam-User: 
X-HE-Tag: 1794966400-295832
X-HE-Meta: U2FsdGVkX1/NgO3mm7YbZZVW9jTFMc31Ey61vwAmpiu4sGPW++UCMlh/3/xoWC317Tu5PcI/fvxAzejKX2KbGuVrKd39B+WKivCb+F6kImw/2Tj9LIQYQUeVOhKOKqafep3GztHPqhFw0u1oY/x4h7QDkPlr+fNSB3tGjjFWSgUo8PZrdfkAgRj3pX21xhSstq2vBOVIwTgngDvaVx6YrvRK6xa0zqKdLE4sdrlLEigDNFVfp9f8q3fau1YIGnsTjWbt/QAVeZjDxHfIptaRkNsPp3kGGsQacZVBB1uzlByftxEAnt2SzRYzTkjWs6VY3EJe0SPpFy6yKfSpIXz+EfJfM2kdEINcreScYMfXdZjYMc7za9FxlFg1M5c922DKDp7Ym8EDOT58mjIl5deDIRaLRTC+tSzEnxLbjdaCsEd7VQbIPCnx+NCFvMzyj6qgpf2lGjZ2o2CQ01XrNsqdxrELa7a1xGvHIV/8yn3+XTXv2lwzJ/i9EXjemuFY2O17Yo/xx12Y/CBajIm79UuKA8jzjzsqCYkt2z3mRpbeKk6jVJqNoCkCPh5xjJBtN5V0j2IbdbfRyZ/bQ/61RhnASh4FCcwLeZcWVopBYPijhQl/VETkdfxpFf3bkrBfhWaq0VUleJ6RhHw23dBh8sLBHHiTCJhL5fNopyArAvQKK/sPjoUp+UHR4WX4kHs2zHxTgDVx9ejPNBbIkD9J9oQIJp5NKNCkX4NF2EkNqjtgHQ2Wp320PvkBBFi/bXaLzWsDVgXYTtcQ+V9xTsAN80sAECTSj+zbkoZqCniJIrVRGwemYODqo3uhQpbpTaLpr4ez3bbQy5zKWN4Q1dJznPX/vm0lRMRnK6IkdEUTz4a8EvlTnLV2TWirF8TBfHucmYzpNUwn3AQHhd6Uj6Y5/ZLzKnj7D6Q7wNp9Wuk9ht800SY6arklzMeBQGZikFc30C2hat4Mv3nc50TZQRVHB8V
 QynMw86z
 0EjaODBuqFpUeM+dkqSYjE1qg4uHyfYbdmefqE7Gfs5zAh8+FDd/xsozwMCQr2TQCUtmgCwfKH5Sfi3g2q/Ansghj9kCd+qTXbV1wjybBmCSbh0QJkuW7CWgu0Y/iVuYTk9mQ8ZQeYjW6Q+D1w7igYbeYR32egg57a0ADeoyMa8/IPpiTIWTM8y21dsbFo6dsp/HMkDBlQABRTO5BwItosktSnEh3FeWGNYLL1ZGd3jNOGrR5MOG5M3pmhfybgWtFLqtyYVPdLuNR5t3Q3/Y8lCWLMnRF4vRz82D10Ps8bkfehiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 23:18:34 +0530 Sailesh Nandanavanam <saileshnandanavanam@gmail.com> wrote:

> When call_controls_obsolete is unset and damon_call_control->repeat is
> set, damon_call() should queue the request and return 0 immediately
> without waiting for kdamond to handle it.  Add a kunit test for that.

Apparently this patch was meant to be sent as a part of a series with another
patch [1] but individually sent by a setup failure.  As a result, this patch is
not reviewed by Sashiko.  Could you please repost as the series?

> 
> Signed-off-by: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
> ---
>  mm/damon/tests/core-kunit.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 13315291f69f..bc93677487b5 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -2499,6 +2499,30 @@ static void damon_test_call_controls_obsolete(struct kunit *test)
>  	damon_destroy_ctx(ctx);
>  }
>  
> +static void damon_test_call_repeat(struct kunit *test)
> +{
> +	struct damon_ctx *ctx;
> +	struct damon_call_control control = {};
> +	int ret;
> +
> +	ctx = damon_new_ctx();
> +
> +	if (!ctx)
> +		kunit_skip(test, "ctx alloc fail");
> +
> +	ctx->call_controls_obsolete = false;
> +	control.repeat = true;
> +
> +	ret = damon_call(ctx, &control);
> +
> +	KUNIT_EXPECT_EQ(test, ret, 0);
> +	KUNIT_EXPECT_FALSE(test, list_empty(&ctx->call_controls));
> +	KUNIT_EXPECT_PTR_EQ(test, ctx->call_controls.next, &control.list);

I think the above last two expects are somewhat too much implementation detail.
I don't think we are promising those list status.  I'd prefer dropping those.

> +
> +	list_del(&control.list);

Can anything leak or corrupted if we don't call list_del() here?

> +	damon_destroy_ctx(ctx);
> +}
> +
>  static struct kunit_case damon_test_cases[] = {
>  	KUNIT_CASE(damon_test_target),
>  	KUNIT_CASE(damon_test_regions),
> @@ -2544,6 +2568,7 @@ static struct kunit_case damon_test_cases[] = {
>  	KUNIT_CASE(damos_test_esz_goal_temporal),
>  	KUNIT_CASE(damon_test_last_region_quota_reset),
>  	KUNIT_CASE(damon_test_call_controls_obsolete),
> +	KUNIT_CASE(damon_test_call_repeat),

Could we merge the above two tests into one, say, damon_test_call()?

[1] https://lore.kernel.org/20261117172219.26725-1-saileshnandanavanam@gmail.com


Thanks,
SJ

[...]

