Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77ED9606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 00:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QkOLfMlz
Received: by kanga.kvack.org (Postfix)
	id 78B5C6B05B5; Mon, 26 Oct 2026 20:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762AE6B05B6; Mon, 26 Oct 2026 20:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679046B05B7; Mon, 26 Oct 2026 20:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC896B05B5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:06:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B6FD41C42B2
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:06:27 +0000 (UTC)
X-FDA: 85366464414.15.77E3CA5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 22CCA80005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:06:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QkOLfMlz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793059586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H2Ogge+YlKva4/OWSPzQ/Pw5emMiiypoqA3hsC0HokQ=;
	b=Tkhm3IVf2ZN1nntyGPzSML0lgv5lm1XT4daSp1zlUUZHPWG18H68fUxhT5NSyYHmh8Finp
	/U7msNt7pq44BREg/KfAMvb7mGqam8EYBtpKmRDKLbr7UbMjIHFyVMe/u7j0adW3uiNGyE
	8fjSbSoXstfz2BT/YizCXnQIAJ/tQxM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QkOLfMlz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793059586;
	b=IBiCf+lv3A2/iq7nTg0jfpEYoAQVFk92lCmWuAe11nbg7V071tTXrCDbBWmLkIOnmftkp1
	OCT6+cFDMYUmNoY7358JGzAjOwOi7tdqm9F8I4xPkt3lQnPYo4lvplCcOFruE3cB5lF7w3
	rloHI+VuLOpjgCWbTwbtLBH3Yy3mcvA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FD7A43CA1;
	Tue, 27 Oct 2026 00:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80331F01825;
	Tue, 27 Oct 2026 00:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793059585;
	bh=H2Ogge+YlKva4/OWSPzQ/Pw5emMiiypoqA3hsC0HokQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QkOLfMlzsLkpneHFEytiK8w/aQUdinJpiYzkmIALzAiffAzFQZHFg0Zz2qvDNf5ee
	 BiG+Rc5BBXKvxTAEy59IsDTRWONsE0lNO11uHExhNujpWgyFGqWsKYEKI9CufpFt8r
	 7y2IwMBMO6WjzstMSXar5n9XF62FL/kyEEt2jiOOKTOiy5GLlFt6gqDl1Xvd1mp05D
	 ZvvvTC/TGyXxOpV7VBFRxz0qDtSlnFvfsfED6SPtLTnCoaMl538sj2OvNUi7uR+S9r
	 K4MKfM4bNZYGFA8RLv+4vOnHzOtSG+v6SlElUYPLcq8D+mh9r6FylgfvPQbxRhgB3f
	 AcsRc7JFGHZFg==
Date: Mon, 26 Oct 2026 20:06:23 -0400
From: Sasha Levin <sashal@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [RFC PATCH 6.12.y v2] mm/damon/core: error
 damos_commit_quota_goal() for zero target_value
Message-ID: <at_q_2pemJCnUvBZ@laps>
References: <2026-10-26-1-daily-reply-0007-damon-zero-target-value-6-12@kernel.org>
 <20261027000120.156623-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20261027000120.156623-1-sj@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 22CCA80005
X-Stat-Signature: cwud1m6aq9ba9tuhhr8j7eoaq1g315mh
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793059585-162957
X-HE-Meta: U2FsdGVkX1+snYfV63Qth46oVbMz5eB7ZKNxMhrpziQbmZXXF9syvMxLGB3D7wedlfKE1zJ1HU27nXC26tB86HGfpxLFTw/PDnVJjDz6N4xaLJLz4pvGO25ldjcUr3lgYHm7r0vuQdfr0lJh2VNlaqcHr0cJA6KqA1Wh1RaV/6mP4e8F2UYgioMR42tfykovK08+/YQQjGVala2R2y4x+4uTrKOCmN3YnJwbjxxe+IDm1YgxNgr98Gx5V/YFlnmP6MeSl1AQWfG0dkJL/fQ6gLhQWM8ugfV3y1Oxtx9Qkg8JoTYw4xTGBAu86OH/OLs48ah2+QXyjc5yVaaYvLR328HHAki5eJffRYCeLpP4A1/uKL1bLvYlEPzcHZsQrPKJjhk8OmAAhT/gAFTPlBTf/NYBU0fv10/4sNi1Pls1asbjoq8rs1QPWpSbwVEqw8DDQyY9q8Yc5m8wJXlVbd+aPYN542mTMlrSjZgXNlUiwplwZcBjpVdkuSpSPi6mqowJ+WIrvnm2d20p6FSIaVTiC3Rlz9Fm5DuNqIthXVmpeizKhrngqQi96iqBgHAwWPZU/SaR/fQPsNq/evJzBRUVZ2m7Vk8KUzjRTmrX7yLrohKiR1K1DnqFohCkLMlss6YaZ8iwODsIT374fxekkMGL+/wJImS6J3A5cTk+qAwPv7WwTfeC+ggJMLMqiLxIBfx98dDE5q8PdIjrHXM296zFzzTnpQqCT4O4DIzPVLO9ayRcmqOkSvtSqwuO+B/1tUoDh1QgFnm6ONW2ogcFKkfsni7ivQE1HGBJqPv3QuZVdqO0zTIVYoP92NJ3VqdyIHnlaTM9SARGGL5eaf0+xc6i1zsM9VcKknWpkZVl5LkVsLANO2a89TC+TO6YM6IWELk/KE7MqJsqhrR9kyjh3ybkJHheSdrNBptd/FQlOODrafvrfciy3NVIj7DrxbQeqBrqogRg7jnnYAvui2ip3Q7
 K7VuXTio
 LdTz1TkKMRYRl52VDu6eYplS0OZSQaQ66/+b/UWVverX8M2hNWq9Jbe8N6tjN3yYWXXM+F6EVtS/zaJFU6YnaHL0PvE8WSmuFzT1l54r3LGlK8eTkXu02K/Kd6clKc8mbHQ5xWtvWOUaJbun8ZoFXLGw53sh9hvv1U1kJPSXPzgVA+Oa75KK3YxywfY6Xl+0qW3BrG8bWFCfVI/Bv3lP7Lr+Byi36nyIEoJfuvlciRGK6nw2mlp2xFdWX9IIAciQSF0eVyIviuW81ThWazhNBQ+wjh0grpAjauPFAAZCm7JkI63pYMc7eegaGaE2ellCKW7ZVPjNjWcQQXALHcX+DO4A0Fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 05:01:20PM -0700, SJ Park wrote:
>Hello Sasha,
>
>On Mon, 26 Oct 2026 18:55:58 -0400 Sasha Levin <sashal@kernel.org> wrote:
>
>> > Also, the upstream commit on this stable kernel can fix the issue for
>> > parameters commit paths but DAMON start path.  That's because DAMON
>> > start path does not invoke damon_commit_quota_goals().  To fix the path
>> > with minimum change, add a new small validation of quota goal target
>> > value before damon_start() call.
>>
>> Queued for 6.12, thanks.
>
>I'm sorry but could you please unqueue?  Sashiko found [1] a bug that can leak
>pids.

No problem, now dropped.

>Also, could we avoid queueing DAMON patches that marked as RFC in general?

Sorry about this. We don't normally get RFC tags for backports so my brain
didn't register this at all :)

-- 
Thanks,
Sasha

