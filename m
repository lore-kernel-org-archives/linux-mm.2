Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 528F3F9D0F6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 21:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E596B0088; Tue, 14 Apr 2026 17:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93F776B0089; Tue, 14 Apr 2026 17:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855D46B0092; Tue, 14 Apr 2026 17:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 716FB6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:25:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0279BB7014
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:25:49 +0000 (UTC)
X-FDA: 84658443660.26.B4D4AEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4C03C100015
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:25:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rbwiMaSd;
	spf=pass (imf14.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776201948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oW246YAmOxlVG4uPvQVaSvCnMj5W7Vd9gYk0nyIHYB8=;
	b=67YXYujUED8UQ+WSvbGFu9/M9FQRMgtvQsDRcInRzYZewH9sTNb60bJ8jUfavgceMwuNwd
	l90DLmpbgHtOlnulVmqXkRwgmx53BtZ5VS/proTGi7nBq+fbnUibDtFOphKKgKGsfe2Ma/
	awyHwg4ISMH4XX5wUxEzdDtaiGMc/G0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rbwiMaSd;
	spf=pass (imf14.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776201948; a=rsa-sha256;
	cv=none;
	b=VgXOJmSGtpq6FQSS6oESOYx97Ma0OUfE4mbp7TIQ4Kmtfqg9tFLXLxOAY42gjS10VtlP3G
	dXItny/qZ3ejyqGhfF8CRZU1/Tfv7gcT/nl1ogMbeBL4//DZ54XLuY+d8ilk1Hix5CYt9B
	V5WshHEo0TLYyDmO8INvnz+docWzpDU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A2EF442ED;
	Tue, 14 Apr 2026 21:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3471DC19425;
	Tue, 14 Apr 2026 21:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776201947;
	bh=7P7F7WGcbi2CGd41uCZAd0HNLhsC1TsYqmIPqKA6PoU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=rbwiMaSdhUF53StkQMJfEh0fMbLskeFVLCWnhMdfY3z54QSj4fBh65AsS1vLuLU+4
	 KgiZN8mRe0w7LQUfSeH5rUisEjLyGQhGOgPfxwNbiNj9HxgLBg5Wszcx0/hGp84bKF
	 qCsCof+7C7NPbp3K7f0teEe0rAlfUE4486ArlgaOD0lTNQs85Rmg6nWCILPCFzY8P+
	 N304zWX9Va8hhExmbkycx0UdEGIWs27BS2mXRbfUCoXg/YvJurlwy2+WEtVfq4dMzN
	 EOjqJdslad9D25iyRXrXMa9qC+Y5Qih+8yTThRZQ4CW62Vaz5kaFIE6c1aOjYQh8vd
	 hKNe+sBCRDarQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang@linux.dev>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Tejun Heo
 <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Waiman Long
 <longman@redhat.com>, Chen Ridong <chenridong@huaweicloud.com>, Michal
 =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
Subject: Re: [PATCH v2 02/12] sched/isolation: Introduce housekeeping
 notifier infrastructure
In-Reply-To: <20260413-wujing-dhm-v2-2-06df21caba5d@gmail.com>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
 <20260413-wujing-dhm-v2-2-06df21caba5d@gmail.com>
Date: Tue, 14 Apr 2026 23:25:43 +0200
Message-ID: <87wly9dyjs.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4C03C100015
X-Stat-Signature: awm3q6zstqa1j8dwytg5htp3sdrm8hzy
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776201948-487492
X-HE-Meta: U2FsdGVkX1+u8j/P3rtY+e5oy5rPZesICfGiE1EgWb+ZtRnoIqNSJXfgeFMRcuwr8fESfraSGTmkKLYPlJM1LpnKdDP6DYnTXkHQsDcyQ3dU57dtuJIuzfTnvz3rD6mDYDBpi9mGGLWWV8GeslGwCS9pbQ3TDoOdHCyEsmP9PNBfHtTmWswDehNSdqnUDpsdJq7v6XtgbIeCqRPlQmQqvjlw9taMfziWieO4WVgGhBjSoRBkMxKnJuBM1PwpdYbnbhtGyaR6Fsojg1ekZM1LIDCzZc+JYP2xzSVinJx8Z1rX1NkPTtZN02My6KSD+n1ZtHKZpXKy/pSbaPN0A48cs2gEf38oIjLAPPq8Dc7pqflkEUFCyI8i3geS1poCv3Q2sX2lJTTgM78n23AROyhggiSDzOv4Dcb+QjNHYqjkcQXh+dV0hPgi9joSuKYkxsawPWc7HHfQFpekDFuyFiqRhOleZwS/e5QS3QXzPkyauxc15lycFZuw5iqFKo50lV9718U3YjlRNQ9fsehZgwalxwdh8/zcMUu9zGYd+JGBS8Ca4/m91ggM1V1Is1t1y81ZCImowE6vjVPuZxm2UfmTrDWCbCJ75HCvL4b2YPrRplxL+9f9uNT7P42ZVCtd0kppTYLJl07Je/dNKQZRgUNMcax3FEfL3aWKBWuW5B8nizFb6zqwoDUvsq7Eqpbn0kZ/cnwUz1F8UgDourtC7BrnX2q1UErHGfMEJp+GICszEbH3bZES3UWQvjP3rS2UKd9RUDb1DKdl5WdpPv7wYWqvZ3CxxYMuWIZi2cYuU+o+CT/Qni4u1H5F0p/cG5x0OKCKAAh81NVGERZCl/t3fz9YpJh6VHIhR5su+eykg3VXXvWDPbbKoADk4vhIgAwoWX3BusQxDxOIwQZtWQ7zYbEOw01gwKaZ4bPY1Jtp7G8X/xBiHIa56p/p3tolO0N7rIlfiEZac8/YdqtleMP9Egw
 wEML/ywn
 vf6jfxggWZKcaXEbJjaVCtzozkuwZ2HdBeKW93ntuftY6MzZ4uyzu41BG1ER8ukaJoyWtZlis+nn1YsRc72xzyXQ3xMBWcldvQvd+wrfSZFBmKZ0vtPHA1D4JX552mAGrvTyQmg6cKnohvSIsyuRlF5dczRnHJTVhZiBQb/NQ5yzG4h1Rj+c2OwfeQSeR4Sqmxx6YC9CBa7sEg/Jdn07wv+7vvuiO8jzQMpDhNz6zOvCfpNpFimrYE2WDZ7wRjaLhaVX0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13 2026 at 15:43, Qiliang Yuan wrote:
>  
> +int housekeeping_register_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_register(&housekeeping_notifier_list, nb);
> +}
> +EXPORT_SYMBOL_GPL(housekeeping_register_notifier);
> +
> +int housekeeping_unregister_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_unregister(&housekeeping_notifier_list, nb);
> +}
> +EXPORT_SYMBOL_GPL(housekeeping_unregister_notifier);

As I said before, notifiers are a horrible interface especially for
things where most callers are built-in. Especially providing proper
ordering of the callbacks is a badly defined mechanism as demonstrated
by the now eliminated CPU hotplug notifiers.

> +int housekeeping_update_notify(enum hk_type type, const struct cpumask *new_mask)
> +{
> +	struct housekeeping_update update = {
> +		.type = type,
> +		.new_mask = new_mask,
> +	};
> +
> +	return blocking_notifier_call_chain(&housekeeping_notifier_list, HK_UPDATE_MASK, &update);
> +}
> +EXPORT_SYMBOL_GPL(housekeeping_update_notify);

Why is this exported? Are random modules allowed to invoke this?

