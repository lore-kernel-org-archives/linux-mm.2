Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6E8C87FD3
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 00:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4826B0095; Wed,  6 Aug 2025 20:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155E36B0098; Wed,  6 Aug 2025 20:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06AB86B0099; Wed,  6 Aug 2025 20:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBB226B0095
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:19:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89AAC160753
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 00:19:30 +0000 (UTC)
X-FDA: 83748052500.26.2C2B84E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id EDB8640006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 00:19:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BWMHD7WA;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754525969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0KN+bbWjd2o2NhRHtjgfHoCWzJ1yJkPPPNjFvjPl+E=;
	b=SZtCGopdoXvpvDnOXHwTQNjNbrTOKVO1ngwonEAPdSMQhi9qcWL2DrkBn9ziYvsKph7Ewe
	keAPvLaOckoOBBWQdXrJL5SSFHyZrAKkqIqMt4cu0UGlN14tBluCzjLhFe4hiUwxz1I1K6
	rGp8ZWeJcqjwIeWWY4ahfF2mUQ3NeHE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BWMHD7WA;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754525969; a=rsa-sha256;
	cv=none;
	b=gGA+Alr3S0EvDfcUzI1XrbQ8Ks0kZyJyTE67Lkkqh1qS8tc0bimed8wzDQOHwhcM5gXU8T
	M5ZqAEKAjL51DG1nV1CKz36RsMGFeyg+R7+/4sYq8mCSV9lQIzbP9gzFqOSppx9GMIZlGr
	J2dYjrVfEG2uKjmmKZjJNOvck9pL4I8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D566601FD;
	Thu,  7 Aug 2025 00:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 777F1C4CEE7;
	Thu,  7 Aug 2025 00:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754525967;
	bh=d+AthCl+27uwwUegwgI7OVtC0RLeunbYLIjyUmAKL5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BWMHD7WA2fsa31FPyzFfAtSSQPM+Ofdy+XivkqkQTv+Ems0ieAI6rvQbRIUNDdj41
	 /CMZRn00i57EZLpXjRIBLBG92352EKss7kA9djfBnAlLjGL0sg0fCtAJKBpNXKKbgW
	 +n3CyD4SvX5+l8G3maitFejW/syN1n2XJ1IG4zwOS10Vj0mAYPvlVLF9+OEaWWZ5th
	 R7pf2bboXgjXpBJt5UB773Y0xZSfg3BQGIG2HjYJZZTRdzEaahRqQjzfvQFiJ2e6qY
	 j49i2htRnrnPezr+kVcbzpPnpo3rQQ/2db3TKC2H9+oG2hhcbUkMASp78CoBbqPMOW
	 w0VKJC+g8zhsQ==
From: SeongJae Park <sj@kernel.org>
To: Bijan Tabatabai <bijan311@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijantabatab@micron.com>
Subject: Re: [PATCH v2] mm/damon/core: skip needless update of damon_attrs in damon_commit_ctx()
Date: Wed,  6 Aug 2025 17:19:24 -0700
Message-Id: <20250807001924.76275-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250806234254.10572-1-bijan311@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3w4mk89kn8u9pfhk518aubstkdu4aopr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EDB8640006
X-Rspam-User: 
X-HE-Tag: 1754525968-579801
X-HE-Meta: U2FsdGVkX19tKtUgaL1iFHjT6SZT3NtbXsLNP1WmrybyFafA6SYGJ4ZftIzhQyqc7HJiUw4KQ4o22DOy6tqHiKdT+iY0LauFw3nlDVl+pDjbNMZPujGvKAphgoBwEbT1rQZCPHTVVE94X5uC78QbwWCdBC/UD9rCwwQdaJUfGYLCVgBJlb0RO+bFN4DrTVlpMK1GmqW2gB1R78f3HjmukpQa/mCTEG93luSTWWVs9rbn3asS7zKYmQad4umcguGC/PfCJciBnns5R3WMPUOi0rCZ2TlbgkdrIuRBvkmZyg7X+mmAumGkZfnxATJbsvJoEZQpP/Z5uSUw/uow+vNPqYp55HR0ClfcEW0Ta/S+jIRCLYW2ESwiVDXEYVsyORoM9wScONFSPYv1sMo85qImEinX6xh792J2TJtLGcqoUbi6oNacE3aCV5Ir9/2txzSpSBLmjLPonXd6S+vBQDNCA/9+cg0B1vO2mb1kYM7SXN0sfNlO7H29xoET93ox8ndB4Rx9+pfQjNunMOdPPSV1OKp7KM9vY9pttONlvtsrJ9LoomHEetnvX+5uGvV880x0aNk5yryay1tmSFW6jdttAnLwxnU2gYUSmHUDk6G30KV/W7Q3mdlU8C80Vt9JLn9XILeRzl+NSRrDFtO/qrAH9GfhHEotRIEWIbuWnrClJGjkk7kxSkB8tkL6XXekUH0dAp1n+JLkoobKEiNdZWI23prL6Oii1bi79nicdR6zg3k8dvDMMVjuESAKRThmG0w3SqY4hoppkeAfAJCdM+EVOSD9soo93Rzke+6EIlcKQNo/mfFUL5GRza+arC/JkAtXBJvBslR6U0oOGUcCgAgjENt/1bUQE5bsaiWcIizMjBUA0ctd+o9xs535DujU5Lb7v20AEPPRovcTnDc5BZB72MbcKiHRUVl95zkpUTNGiRMK/PMxA9NjzURedzJCgK/2zg2asplIJLlyN59aSj0
 6HjG/6YB
 whFwHU5uLBZpfcXCpp86jBilCpUZLIJQ2wavr+m/7ZaKa9NyjSLNJrGJjXNY1PxUL0OiH9om2goSpdJXrcvDJq3f8ydUY4iLAmlXgQbrmCfIcmpaKx3w+XHsvfi4NOuk6pNxazYbubEaAkX6XxCTxQz6PKFmVfPNKespDsHyMrwv7mCRspA6HNClclKMJ7ivZqCKQ1u8zHO5Sb45plwCgc+DjsVDepjEcNRehZcXtYGDH+VC+KRMud10m+GejpkFQSX4FHdjOU4ydvEu8TKer7SkJa2sF0aWWcNH9HDeVzlfogT9B660raOJ6CtqXVH8G+93AjIm/cx/WUG+fk5TVNdrX71h/9jniWv4QGru6PDkJF4g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  6 Aug 2025 18:42:54 -0500 Bijan Tabatabai <bijan311@gmail.com> wrote:

> From: Bijan Tabatabai <bijantabatab@micron.com>
> 
> Currently, damon_commit_ctx() always calls damon_set_attrs() even if the
> attributes have not been changed. This can be problematic when the DAMON
> state is committed relatively frequently because damon_set_attrs() resets
> ctx->next_{aggregation,ops_update}_sis, causing aggregation and ops
> update operations to be needlessly delayed.
> 
> This patch avoids this by only calling damon_set_attrs() in
> damon_commit_ctx when the attributes have been changed.
> 
> Cc: Bijan Tabatabai <bijan311@gmail.com>

Maybe above line is added by a mistake?

> Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

I have a trivial comment below, though.

> ---
> Changes from v1[1]:
>   - Compare entirety of struct damon_attrs
>   - Apply logic in damon_commit_ctx() instead of damon_set_attrs()

Thank you for doing this!

> 
> [1] https://lore.kernel.org/all/20250806164316.5728-1-bijan311@gmail.com/
> ---
>  mm/damon/core.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 6a2fe1f2c952..80aaeb876bf2 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -570,6 +570,24 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
>  	kfree(ctx);
>  }
>  
> +static bool damon_attrs_equals(const struct damon_attrs *attrs1,
> +		const struct damon_attrs *attrs2)
> +{
> +	const struct damon_intervals_goal *ig1 = &attrs1->intervals_goal;
> +	const struct damon_intervals_goal *ig2 = &attrs2->intervals_goal;
> +
> +	return attrs1->sample_interval == attrs2->sample_interval &&
> +		attrs1->aggr_interval == attrs2->aggr_interval &&
> +		attrs1->ops_update_interval == attrs2->ops_update_interval &&
> +		attrs1->min_nr_regions == attrs2->min_nr_regions &&
> +		attrs1->max_nr_regions == attrs2->max_nr_regions &&
> +		ig1->access_bp == ig2->access_bp &&
> +		ig1->aggrs == ig2->aggrs &&
> +		ig1->min_sample_us == ig2->min_sample_us &&
> +		ig1->max_sample_us == ig2->max_sample_us;
> +

Unnecessary blank line?

> +}
> +
>  static unsigned int damon_age_for_new_attrs(unsigned int age,
>  		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
>  {
> @@ -1198,9 +1216,11 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
>  	 * 2. ops update should be done after pid handling is done (target
>  	 *    committing require putting pids).
>  	 */
> -	err = damon_set_attrs(dst, &src->attrs);
> -	if (err)
> -		return err;
> +	if (!damon_attrs_equals(&dst->attrs, &src->attrs)) {
> +		err = damon_set_attrs(dst, &src->attrs);
> +		if (err)
> +			return err;
> +	}
>  	dst->ops = src->ops;
>  
>  	return 0;
> -- 
> 2.43.0

Other than the above trivial things, looks good to me.  Thank you again!

Andrew, I assume you would prefer resolving the above nits (removing
unnecessary cc and blank line) on your own?  Pleae let us know if not. :)


Thanks,
SJ

