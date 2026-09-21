Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F18C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 16:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7406B00C1; Mon, 21 Sep 2026 12:36:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AE756B00C3; Mon, 21 Sep 2026 12:36:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC2F6B00C7; Mon, 21 Sep 2026 12:36:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BAA86B00C1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:36:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF0F040239
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:36:13 +0000 (UTC)
X-FDA: 85238321826.15.77BA3E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B9D640011
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:36:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EiZr+ppo;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790008572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mcvkpNssIr9zsxZTvdb3UBAq6HomywEqsmTm1KMjY8=;
	b=eFLdeNJ75N4t78Y6QB66uMuVvgoYlmthSZbec6hsKsGjXft6hv/qHvx+7H5Nkc94L7mdYO
	eFS3aWyPVMEuOMYOVVQhELfwWsOGgPhLr9LTAbW8gFkfaClkMT943NZ5guPJmuXbOhLLh+
	dmvJCR/dEUmQH+d+QMLBOgRvsv8zwDU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EiZr+ppo;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790008572;
	b=lJ1PsoSRWJuX9Miz2G95f6G66aGLuU/UGSdfrgLRLRCOcvcaWejhiMcnwzdPtIxQo0Jmtw
	MVHcqUXcpRx8woR/YxSzu2e+eC48qfbqXJ942Y/mXjPKqQa016rt1CEzO7Uaa+mBziC+31
	AFxNv6VKmO/tAiiEnYno7XFxqw2Cy8k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 874D260008;
	Mon, 21 Sep 2026 16:36:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0A11F000FF;
	Mon, 21 Sep 2026 16:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790008571;
	bh=4mcvkpNssIr9zsxZTvdb3UBAq6HomywEqsmTm1KMjY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiZr+ppooIZMW0rM50EkJwB3hmEjBh+yQmM16YqF0W51wi83p9SeIEmoGsie+kVtl
	 FEO2LukxA4gzfl8XSR6zm/MTVL7oBF+Q64T24E0IsPAAlr3PiXnwPxkKcsMYAOlQ09
	 u142y4lCKVUiiPSRARmbTKo4yZ9W8WAmhkgwHcXMZhs82/gGNHh9txjAJctPGgQTe4
	 j85aTl3ncOAczAK9NcudNF6KwFUYBXzg1jcJSg9nJffijqo6eAP7XTq+5JWi+RPQ0x
	 WqX6wz9KyDa1ZjYBD+AzfP+MkVlYJk0sPjJ8TD/cl67PQqB8UM9JZqXLqnBaHe4gTs
	 JmOAwKP/zwTHg==
From: SJ Park <sj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/damon/core: keep the temporal tuner quota over an unmeasured PSI round
Date: Mon, 21 Sep 2026 09:36:06 -0700
Message-ID: <20260921163607.81366-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921020013.33105-2-kmehltretter@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1g3ojr95h8r9k3isbwwftgj8dtd1a5fp
X-Rspamd-Queue-Id: 4B9D640011
X-Rspamd-Server: rspam07
X-HE-Tag: 1790008572-347949
X-HE-Meta: U2FsdGVkX1/JDCEVdIIJ1zZrR67DYLuguJ5xJZqoanutW8E+KVvzje+HbZjAXnOeTDB4KxK/zjiutQfX3KE+FUTwdVvADmxhRS8YNZqloVE+d4ZsTHRVmFeL+EyJrx7K3pyB9lodKSyencA5wVzcahqLqSQ4IRVdDF+Z2RayamX4rwLLmlY7Zx8Vtk3IeVxQzpq7VIwfz9KoMZIColATOxsEa0g0J48uRFH1h40kA+OhrUVAW/aC4Edc8TYq7XDUfOJz+dcuLYF+jlTy6oPNpNpTaI6P5+vBP43ik//ZqL4H6eIqOHRIV8cDeK3MVB9bIq4ZyzxYYzyZI26mV9hfQFGYX7swCQIx25v6ixoo6qt/j+D2uA7YvkdWM9hfPSox93UjnUoxb3UFamT0HUeZCOfp4TqgiNfXszopASTy3yvD0DMUrjSYNnh0uHknhb2Fm6+cdsNJypQrgRWmCHrhq8+o51x0tWc3LYgpK/GuEW4M66nwkFOR1Y8lG/lAxT0DR4+TAjvO7bIiS9/AObDZ3Wt9/TOLLCSsLpTm9BlWnKYZgR0NUrJpK6mk2dj/pcOt+5/YFMxh95FeSolWxjQCNKeGXnQRZxnVQBB2F7EA5n8Qz9kNq7a+/kBDyx5T1adXrZ+EXo3bxO/B4c0lwMIEQW5qvEu0kfTABuqA1F9q1mQhCDL/9sHnVfwvhwwgfxWEJ6SsNbOWEqKsWlK+z9OGvQhRrExCSakPEvd+/eena3I0ZLDocNOiTreTg7Tg2ryGI/TRQ7+uWUWL67mvlUMgEY4A+ngevJS6IwQMXTRa23XfrHFV/+WCTaGn3+3uz3DtOYqB32lfu5Wp57wYQm9IPImtWyMTIPWalbxGYFF+59J7AVXjkt+4WTsYRqr0idNm4e13Ns8SaKxd4JeZZok+Z+EH4CGZdrWCOcA/cauVZ/dT/7Am2v2K/7c789RHGHj6geXO70hBTg+nk1SpawQ
 fmYsMI/e
 MtphMGBZc+u7gwIqOXXZ+Zdg7yoB6S/8ANM4WzRu3NZWNnp4/ot/fVZnW3kfEnzzIt8nALtj1NCkdHigeYDwinOj5bQAVRROX+ZdaNJkXkQEP3A2Jn6SNqILVwgRF1mRak3CPWkqo7qV9voD+OBucKdGQwzU2OUiM3du+0oS4yq3++WxkLuziJF7GPy0csWi4I8gLs1K0AZQfn9jWJnBff2Xfpudk94Ns8T9CGfrsAax90eGdPof9cdU8DwbyUiCanh8YeLr1XM2HoobxuuvP1xJmTSIBBHU+3K7OE7z5OFdszdYY3p9h31nw+C/G/slvqPe7yP1BgDc1c1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Sep 2026 04:00:12 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> Commit b73198a47ffe ("mm/damon/core: handle uninitialized
> damos_quota_goal->last_psi_total") scores a PSI quota goal without a
> previous sample as achieved. This leaves the consist tuner's input
> unchanged, but the temporal tuner sets its quota to zero for an achieved
> goal. A running scheme with a nonzero temporal quota therefore loses a
> charge window after a quota-goal commit.
> 
> Use the effective quota to preserve the temporal tuner's previous
> goal-achievement state during an unmeasured round, as SJ suggested [1].
> Score the goal as achieved when the effective quota is zero and as not
> achieved otherwise. A new scheme's initially zero quota stays zero, and
> the consist tuner's behavior is unchanged.
> 
> Move the PSI current-value calculation and last_psi_total update into a
> helper that takes the current PSI total. This lets a unit test cover the
> unmeasured and measured rounds without depending on system memory
> pressure.

Looks good to me.

> 
> Fixes: b73198a47ffe ("mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total")
> Cc: <stable@vger.kernel.org> # 7.1.x

The broken commit (b73198a47ffe) is not in the mainline but mm-unstable.  We
should squash this to the broken commit before it is merged into the mainline.
Or, maybe pointing the original broken fix (2dbb60f789cb) as 'Fixes:' is
another option.

Do you have a preferrence?

> Suggested-by: SJ Park <sj@kernel.org>
> Link: https://lore.kernel.org/damon/20260916001311.101024-1-sj@kernel.org/ [1]
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Other than the above,

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

