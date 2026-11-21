Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B720606A6A5
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c4Wb4ArS
Received: by kanga.kvack.org (Postfix)
	id 76A246B00EF; Fri, 20 Nov 2026 20:53:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5306B05B0; Fri, 20 Nov 2026 20:53:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCC76B05B1; Fri, 20 Nov 2026 20:53:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25D056B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:53:35 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8CBA31602B7
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:53:34 +0000 (UTC)
X-FDA: 85457454348.12.F635B99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E2C40C0009
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:53:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c4Wb4ArS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795226013;
	b=hKdiGorchsn4TYgf4eBvGnjtaOECEEj4xYFhM9dapdIv4xMR8lO3lI5DKzJZTR7W2311V5
	jYUj6w6uWvoJVf9KLlWFwM5CNsFaI5Gb9e5qHjwtrD52E0cBegFDh5rJZHu27VeVD9hdoh
	gRGdYDFPNSqspg1P9PITGOBfNfP90wA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795226013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFeLlw2MWa6op+6humMbJWZtrLF8Qga0uCnT3clDGps=;
	b=0uTqULbDGm2JQimNsDxJlu/G+gQR/gOYMgjAKj6nXmZBy0RW7/rGCAK8qVq1+7NLayyVoF
	feijuEuuss+2w5d82Hw/Rrbw3spJjIe59FnTrfswsTRx+z0Zg4C2sX5/BX/fFKfrXX6v76
	ikBpCOHwzrtEo2JoD3dMcytRVcdD8rY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c4Wb4ArS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7770360269;
	Sat, 21 Nov 2026 01:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8415F1F000C0;
	Sat, 21 Nov 2026 01:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795226011;
	bh=EFeLlw2MWa6op+6humMbJWZtrLF8Qga0uCnT3clDGps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4Wb4ArSVa1bTRJA0LEoIpw/y9SHCqlT4fV6u493WAyH0spPqZOE0/xx5WpZCkmn8
	 7HHSlJYJC+MPYvfbMUMAhoad19ediwAhBaL7lKwaWS48a+VimJo1wdXRTFSbgtriDZ
	 56Uq5Lh8632q2i3T+26xtjcaNakNYVUpZsAemJx6VL6VTpBxT7x92H3+VU6i2A0+Kw
	 M4qO63Du6AYfalTfY7jwGbgcJHGRaauUrHOZ582ZsntX1upuv79y3poRs3doKvmdHR
	 QOevGbEwLMPn9s+ddbM5O4cumr5a47DAFPL4QQySWTHylhRkzq2RDiwMg2/jlc1DKa
	 E4FHZlepGAUEg==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	arijit.desaii@crusoe.ai
Subject: Re: [RFC PATCH 0/4] mm/damon/reclaim: enable auto-tuning features by default
Date: Fri, 20 Nov 2026 17:53:23 -0800
Message-ID: <20261121015324.83753-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120060741.92121-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E2C40C0009
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rmiwmre4ncozgai9okwc89ppg6qpst47
X-HE-Tag: 1795226012-393248
X-HE-Meta: U2FsdGVkX19yU4n+8QnI9/xofEz1TYxa7WzWcwsGcvnNJe91BVNbC5afDWUoV+hjJ7UfUrGIUlKXUC5RTX/Vltkls4AB/x6cY24zCDVpNqTSHmJMrrZCRbzkgGyri5b2eaqk4WfwPRIgqwnkBWjk3Pdho1AtZz7+U/QOs/uoQT8ESJyTcagoBsZuodzVsRS+FBW3HP27/tp3Z4XXJ1qonGs/J6kfS0mmRZZUB+kP3cLd+39Bru5KcxbpX9F1dSDG5y2kfHu2Gbwrnkq4k3vmDFzUwm9PRv8bzGuqwVmL1EIw6Ipfx+W8OkV6F3CElr5KxaiO6kvJ5Qoa0fWeJe3yKQYVw0ON+vNaaqiNwX4OnTvE+cykLcGxhivs7Oc8I1y3j+mfKKjeMx8dv7QfN3uZow81Z+fSkKL5cyn/H4DkrcnzkRD8QBGhRTp96Wcej5fKLRsJJSGt3z2UggsZomIRRdgSq7kJHcKFoYXH/qvf0LQCPqyp895DStlaNNrfKm09xFwP5rJ1X1R01/tZOBhfu1zO/liMC9RTEhvlwpMVciBzgkAqySQ35pJu7X5lweXVuWTRcn3OEEaR9PAjZfVqrUM1KDMmxXQ30cjsz02JQjV8sQy4Bxs0jM26Hk+OdOZlVn8eFp2jNHbn2kTfxE9LRUZP4x+Q5WnuDe44YhAHu+PcE5RdVB5zF8UMh/HexiBlKRMzV8d2DlGCz1fKRXbmvvm5u6a+QPeYVuvLdJhHCiQQxKolVVA7B+gKQZqRncuo0qY9obkKx94rHnnKJj7yQhldy5EW5CUrXhsx3E5HSLOdp/MU/d8s5P5LpRScEvqp8G09G6v+XmDLBZEmQhP9+sHh+MV5m3DKKGpuk0qMtwmQyoFIpTYTtZcdz+C1ezUhKNU8Nc+3O15ClR12fgbJHoyvba7zjO3hNL3DpUucgj7spVGsE7Tn1yQ7AZEO3DiV52syUZauYtZoSxKK2WP
 VP4gOo4a
 gxB15Gox365JDOhga13Mnr9BZexMJbJbZpX10PLCDhHutkmhkhPu66shjVkHt26Ue8t4xHYb+t7ESBm93kZXaLJnxjt8Z03itYJQNR3LqZnkeKWJcek1iNjred812A4aoQafLgaxNTnsBMP5KeVEohBJh1B7bX/jJhybJ3gRXhWaRJUPrllMppra6Ipmru7fc225QHTvKDABuaDx3WqWHYOTn49eWh2SE2Xb9TrAoMI1M+FzhA8TyOzXmwROtkI1a01zkaQ4aKpEJZ1EDLvBWXXa6ZbKcemeFQDPZuAH9pHy4iW9a0yoXnwGvBJQnan/5Fgzg5rv1q9tx2I2zFQcvxGUikzuwe0/XsOXZn4hvTsNWtfO5MhrsIY2g01t0ZLrhwUckdmicmOgm2cTzctZTA1Jj4CuD4/WrLRZ9kUObOGXeXDHZ5cZaVrUPUbjHMkDHs6/+BJ/XKIj5+6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 22:07:34 -0800 SJ Park <sj@kernel.org> wrote:

> The initial version of DAMON_RECLAIM was supposed to be used after
> manual tuning of its parameters.  Among the parameters, the monitoring
> intervals (sample_interval and aggr_interval) and the coldness threshold
> (min_age) are particularly important to be optimally tuned.  The optimum
> values for the parameters tend to be highly dependent on the workload
> and the system.  Hence no small amount of tuning efforts are required to
> each DAMON_RECLAIM use case.
> 
> To reduce the tuning efforts, we recently introduced two auto-tuning
> features.  Intervals auto-tuning (autotune_monitoring_intervals)
> automatically tunes monitoring intervals to provide practical and
> efficient monitoring results.  PSI-driven quota auto-tuning
> (quota_autotune_feedback) automatically tunes the coldness threshold.
> 
> Because the auto-tuning features were introduced after the initial
> version, the features are disabled by default.  That is to keep the
> default behaviors unchanged.  However, enabling the auto-tuning features
> is only expected to provide more benefit to the users.  Disabling those
> by default only makes the adoption of the features slow.  Also, it is
> difficult to imagine real users who use DAMON_RECLAIM with its default
> parameter values.
> 
> Enable the auto-tuning features by default.

My colleague, Arijit, found this is not a good idea.  He is now working on
proving the theory and making a patch.

DAMON_RECLAIM receives the coldness throughput via 'min_age' parameter, which
has 2 minutes as the default value.  DAMON_RECLAIM converts that into the
number of aggregation intervals for the time, and set it as the min_age_region
of the damos_access_pattern for its reclamation DAMOS scheme.  DAMON_RECLAIM
does the conversion when it starts working, or a parameter is updated online,
using commit_inputs parameter.  It doesn't update the min_age_region value when
the aggregation interval is auto-tuned.

This patchset enables the intervals auto-tuning features so that the
aggregation intervals span from 100 milliseconds to 200 seconds (up to 2,000
x).  As a result, the effective min_age can span from 2 minutes to 4,000
minutes.

In usual real workload, the auto-tuning converges the aggregation interval to a
few seconds (20-200x).  The effective min_age will be about 40 minutes to 400
minutes.  Even on long term real world workload, that could be too much
threshold.  The user will show DAMON_RECLAIM is reclaiming only unexpectedly
small amount of memory.

PSI-driven coldness threshold auto-tuning can make the effective min_age only
longer, so it doesn't help.

One strightforward workaround would be setting the min_age a small value, like
2-4 aggregation intervals (200-400 milliseconds).  Then, in usual case, the
effective min_age becomes 4 seconds to 40 seconds.  It might feel like too
small threshold.  PSI-driven coldness threshold auto-tuning will make it
better.

Yet another workaround would be monitoring the auto-tuned interval and update
the min_age online, using the commit_inputs parameter.

We introduced age_ms DAMOS filter type [1] to fix this kind of issue.  Long
term solution for DAMON_RECLAIM would be modifying it to use the age_ms DAMOS
filter instead of the aggregation interval based min_age_region.

My colleague, Arijit, is working on the long term solution.  Until it is
arrived, I will keep the RFC tag of this patch series.

[1] https://lore.kernel.org/20261106020559.98352-1-sj@kernel.org


Thanks,
SJ

[...]

