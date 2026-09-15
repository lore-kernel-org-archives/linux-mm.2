Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE1FBC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 14:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0A56B0096; Tue, 15 Sep 2026 10:51:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99156B0098; Tue, 15 Sep 2026 10:51:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D70E6B0099; Tue, 15 Sep 2026 10:51:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76D926B0096
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:51:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E29B1C22BC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:51:04 +0000 (UTC)
X-FDA: 85216284048.08.C88365F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 00A334000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 14:51:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Wdc+2Vi/";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789483863;
	b=xtCtj5ZAER/599B5MDjaLZTBz5+vapt8iKWDkquVv+a5On/ylzFh2R1CvgMn7WBN1BSIeu
	fLRS0BTv1osC7bWWgof9R5G8QLdu0no1pUC4DQXoDmkJjKIhcpFzSjlfrI00UoMVtpj7A7
	jwvM6WZ9ooFw4Sun91yNSEyYIEBSgs4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Wdc+2Vi/";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789483863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttqsgjewLy0H5CGwDqwjIgtkd7bY0dbIELIdhgGk55w=;
	b=IwyNV+MCxrzl+vxbGyG2N9LVn9w81CYVDxoIbDfS8leUf36JfUMFiD63O0dCRsK7T/4Wkn
	FVPP+biNoDxwvXy/rEJi2WTrjtABFT2E/9I9VodUZe9uGjDc87XPcxYWPQi81IxjbDUTUi
	O4zWWbDvsRealxqYGLQVcscJ2gklIT4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6929760142;
	Tue, 15 Sep 2026 14:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37571F000FF;
	Tue, 15 Sep 2026 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789483862;
	bh=ttqsgjewLy0H5CGwDqwjIgtkd7bY0dbIELIdhgGk55w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wdc+2Vi/1ypQiG51/JO+tXV3pbsxO/NkGqUD3tomIqmzQmzze/n+eKqveNmAxgCau
	 NqMPFkksYyxt6HPqFVdb/EPHgprhxg0kM/JgjAOVv77Z608felCme8bXd6wj63gTLY
	 MHYHTZ645nB5OseiQk8KF1BvVL1UTO+0c2B9XERzr59c4KenAifLD/fHEpWhqUL9Ix
	 ACFCu4ok6KqS88NKR0jJnoc2EG7B3H647q7XN/d56TIzHmcFzCWBP4ukICBUJXw1QJ
	 UhsjEix0AGf91Ce3xRC4pEq3grND5Pi3EjlHxGM+ciQfyGge3J/POPwOwSyXEYGvzb
	 QGCmWjvlxVT/w==
From: SJ Park <sj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/damon/core: score an unmeasured PSI goal as not achieved for the temporal tuner
Date: Tue, 15 Sep 2026 07:50:54 -0700
Message-ID: <20260915145054.92001-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915060937.3423-2-kmehltretter@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00A334000D
X-Stat-Signature: unh3z99rquufuc6zozpej6bb9o8d1zyn
X-HE-Tag: 1789483862-314751
X-HE-Meta: U2FsdGVkX186Mgle4q5xBaN/LhrWAh1mg2B9ndUTlqZ20/DuXh7QpseCrY6NyNM81kYZg27HlxE59ui3CLghYbpXWhsavGqMDe7XyE4JTMEUo4bPgy9a3wWiHqcjiykFuli9jAR7HaTqtOyf63i9k8/TpPPTEqLhVrPbZO1DN9JXmOmekEu1yVlT9WoWwPSdxLsDx1EdTRstIvidWHv1DG2/VkGuuWhm1HHnlwbrDmD5wmwSNLPFIoFsJywfsBfz47ja9aMhtEmTtWhTFcMS1bshTXaO1IVzRRP+ZeLi2WgzAtoKE23/LU7FyQCnSdh7Euk1jyYxlPVVjDCmC9MWDzW7JDy2tcFLfHyCJnj2x5g1C+SHhNZe+dy8I8myxlCjqh65dTzu/yVbrITFHtAT120odD1S93eTXAEmMWuabI5vPYOf0iye+xd2Eolw2b1ghwo3XaBKwN7nR6YClUFYgs3thQiCph/FLtxEyGM+G1MOlVZhjcMSz4d55YHv/+JVS1VBGNefp0RGfx5jdT4UioH6n4caKH5iOvzpmCcD79M4sDXXLT/hPCjUG7XYTw9AU4yqbSN8KzIGXjcHBSPfWP6pA6+VGokWsC9IVHt5EBzsYM5cUnOZWAhapPITixUIhkB0dz9UGmyEagk6QZcUoJNj8b/hrPkJ+SQQE5iyalEHHEzSQagu79m6BJ2q771+zlykeem792cUyQ2sjnCXMwp1ZA6ovOfgDATiD+jATGOf73KG5HMNQZSAsFLz01lp3pimDkRkSezW8EFX7aaIg0Da59XdY01465Ka47iB36kB4baJWar0mPqzMobJLgCyaTL24kG9AMmq5oH3k5IUOkvKW+p9Ff8rCbx4twtiBG8P6NEB3qzGnw/SCVXCiue6JEQbtWivvkWq9g9jhIVbjvy4XJXPjPewPngw/oLCVSISQ44OXJTzL95u5JPWyQtWjLt/fN3RLZVLR2cMKgT
 h4m8vIii
 ufCx7BrGZjd2r4DpVgX7v8iXBj0pjy+nQB3kqTp3BwsPhSKfh7i23MR+4/UaKGS9X6luumLt5R5mNGrimmfEQ4x/5oiz7868xPMvPjy9g0xDuHuYCHV3tG5V56r3juwcu1mcNcC78LS+x+8+ldEzmUGLY1StEA7SIYJgZXPtHuSfkfiEhFFYSfz6mBvQRHtkci7LJguAw4L+V/fEPZs1XRz7Wayvd1ZYsGQXTRqWSL6F6eO5AxbJGIlUL+OvCEeK4NdYxmZYxgxYIg94bbCApDPGGq5ivkv/uA21howwM8z3NgVF+aJC/2K9OcgU/NKpmeY0I34r4nqwg9qg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Karl,

On Tue, 15 Sep 2026 08:09:36 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> A newly created or committed PSI quota goal has no previous sample.
> Commit a68878f83ae6 ("mm/damon/core: handle uninitialized
> damos_quota_goal->last_psi_total") scores the first tuning round as
> achieved to preserve the consist tuner's quota, since the feedback
> loop returns its input unchanged at that score.
> 
> The temporal tuner sets the quota to zero for an achieved goal. This
> skips the first charge window and the window after each goal commit.
> Committing the PSI goal before every tuning round keeps the scheme
> idle indefinitely.
> 
> Score an unmeasured PSI goal as not achieved for the temporal tuner,
> so a new scheme can run in its first window. Keep the consist tuner's
> behaviour unchanged.

Good catch, thank you.

> 
> Fixes: a68878f83ae6 ("mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total")
> Cc: <stable@vger.kernel.org> # 7.1.x
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  mm/damon/core.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 06cf2ab7e97d..e6d87fd3992e 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3161,12 +3161,18 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
>  		break;
>  	case DAMOS_QUOTA_SOME_MEM_PSI_US:
>  		now_psi_total = damos_get_some_mem_psi_total();
> -		/* uninitialized last_psi_total; make no effect this round */
> -		if (goal->last_psi_total == U64_MAX)
> -			goal->current_value = goal->target_value;
> -		else
> +		if (goal->last_psi_total == U64_MAX) {
> +			/* uninitialized last_psi_total; make no effect this round */
> +			if (s->quota.goal_tuner ==
> +					DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
> +				/* an achieved score would zero the temporal quota */
> +				goal->current_value = 0;
> +			else
> +				goal->current_value = goal->target_value;
> +		} else {

The intention is to make no effect this round.  Setting current_value to zero
to temporal tuner means it will now have highest quota it could have.  If the
effective quota before this was zero, it gets an effect.

Ideally, we should somehow remember what was the last esz and keep it.  I have
no good idea for doing that with minimum change.  This is a corner case in my
opinion (correct me if I'm wrong) so I want to keep the change as simple as
possible.

If there is not easy way to do that, I think just keeping the behavior but
making it explicitly explained might be better.

What do you think, Karl?


Thanks,
SJ

[...]

