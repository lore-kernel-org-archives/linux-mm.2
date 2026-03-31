Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B96C2FF60EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3157E6B008C; Tue, 31 Mar 2026 05:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29FCE6B0098; Tue, 31 Mar 2026 05:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18EAB6B0099; Tue, 31 Mar 2026 05:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03FBB6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:36:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB9755BA00
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:36:06 +0000 (UTC)
X-FDA: 84605851932.03.FD6A558
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3BC1814000F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:36:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UqSufg7e;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b6CbvR8/dBASIiCO4zI3qofvdUKzb0+QulOlwNByytU=;
	b=4ah82ShhQSI6BwqDrJ5o5z6mCxUE5jDUJ+dx9gQsxAqf1VOla/0KjdoG46YdWi6YCwPgUA
	bC6zAjTFX0kONVVHytpVe1eNTYiQ6F0X9+dLSj8UCKyhZkAcJ0WKz6O8ZyWsCeNHOid/oL
	H4Yo3E3WpHXpMMdB3sW1a5ohVMIdSSM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UqSufg7e;
	spf=pass (imf23.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949765; a=rsa-sha256;
	cv=none;
	b=6e7YzzknVckCdYCZlg5IbAjehjp+UzNyd76N/gt5j/UokuX7Zj4qhK9fddoqSVAoTZC8dX
	Vc53hngBCid4StbqQql60tCZvcedG6uzYB8KdL00qp0BH6xdXl/zbBtkb29gzhHjIu+Als
	RszIznvC9MdR3EJE/Dm5MBiGXXtDjDg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A3B26001A;
	Tue, 31 Mar 2026 09:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC742C19423;
	Tue, 31 Mar 2026 09:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774949764;
	bh=unm0mN5O/5fTupUJP5/43mpmznDqUzGRVDsTFh0CMvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UqSufg7ecQ+Wg2DuC+R/UR+odxiwJs2VYV4DwERoT3W8EmYBR8cHR6TV9nHDR5e9G
	 DNWyNLpMyravuJGr8qGJLEkqqPWPDc8WRrUyHwvheRgvLWa4hru/o7xiaH2SxVtDps
	 dGN9D1i8lfx9blhA+g66BOqVMoEHHohm+nM0nbCtS3gFune9sYQzK+SW9x38xKcc7b
	 UFhDxkaNzAD1LwVq3ZS1NC7PMvMiJ0g60mTFEjqrJvsubEgFftMSvPWZ35E7Esdruh
	 7Io7X37tGiqX5l5+4flhDHiTwOchYDFE58LQhMws4ARzYSrE01fZ537tQlBt/Xklt+
	 FPD7dVClbx4sQ==
Date: Tue, 31 Mar 2026 11:36:01 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 03/15] sched/isolation: Separate housekeeping types in
 enum hk_type
Message-ID: <acuVgY5AC-bMNsZu@pavilion.home>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
 <20260325-dhei-v12-final-v1-3-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260325-dhei-v12-final-v1-3-919cca23cadf@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BC1814000F
X-Stat-Signature: 9yswtp485r7gb43ibfp3zoozajb39ecn
X-Rspamd-Server: rspam06
X-HE-Tag: 1774949765-738714
X-HE-Meta: U2FsdGVkX18ptvkLRAu+sF+leizRttrehOqyoqQYaPoKgpsAIW3doRleVAWYZYJ5GIfqFldwZC0vU0GwbcXxxpOf78q1lJQWyJA3dQSiVYsKK51+IEUZU2XGfefG3Um0diQ5yLcF/DeoFx6sEOY+ejTyoQJuUTLNUg3RD9JRX4gY1rVbz9iWeKCz6hP9X2kDsKhqVxSrIjGC5jLzOu5wdcXyjozFbpW7IQWjhDqzD6W8IrF6kfft1p72Lef5uZGDNFOf6Dv9EqR89TSVxgXXz+3lt6tuDHVzdCwD4ylB/yAxXLKbO3itKjDgC0E5Zqr4W/tnM+mjvS2HLh5/H4e8sb3W9FLwSFVp9GXMnvo3mmeAeS27aDCeVqM5hy+XfL6tsAnbuhZZlU0c9r7AcwTRjkbf7Ih6c3wRUtpspThRPss7mzzKv9D+xKm1BrItjoPqk3cJsiFkXcDzZUIJDkQjRnQqRVHxIjmH4/Gm6QuRAE8WH6Tl0sy+wXmG7GwCnLnWlVrW6CBpauPE3mTKVENXOg1z+Ii2ii+sHsyVuSlWFdPLphxVqAK8had4nC9W00pEdXsPKf57FJWNlV2VxMaT/7VcCVSGzduaZKMJHSmHAJtIJ7DORF95rO67KJ3QmtuR9HsugNLlg6mstIIk7y8bEYDwF1h9qBL+L4YKtSFbmgehJWsunfTlpe1kjIdAu+s8mD6q1vhTDJGgroaUQDGaOpp31dmus85A1c/d+Kktw86zK3yzG/Yjn+zNdKy6P7aKDACymtyON92Vd4/DKVBcX8cjVUIz77fzgHmDMWHJjYBx4fxBXnKhsJwNY+7cQ5nuLEDmZFzpJb/H1nGTQrK/WQqQRWaFjJ24/CUnjOyCsOcsx6cSXmOUTdkWpxzS6Bpg6SF6aI0/hYYd5f18b+p7MlM0CkAYfSI9sDHTYcrXhOu9H8Yk0bH+YOnWETnqazBWbqEui4Hoyn2iabty9uP
 T136Nl+L
 KuopqSHBlUx0aHp5DoI2vojjRBiwEIk3bYDdi7jXYth1s3RhZ9g1Qq1Clmi+mPg5oPGiJpN8GBunht5SHrTuJoZjtiSusM7M80j7ffgin5/+uLuIJ5fliqKG4NFMDushD3x6kJvA9c4H8VootAXC7cQOOhZbqKvYLCfDLUgij0PiDA6I2Rw1o8Wf2D8h8fhtMlkZFUW3oxmZW5UUcl/hUG1/T5h0mG2wh9XAYR4SIjEMpu1NK4LolBfLYt+FvOBoJDjQnZlpUgel5x46daEiG7TxaZDNWv5Ys3wl11bR8PQt1JsCx+9CVHG1wMrifBVhGP/8J6x0V3RknMiKCaLKPXkiIo5coL9Jbsjoa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Mar 25, 2026 at 05:09:34PM +0800, Qiliang Yuan a écrit :
> Most kernel noise types (TICK, TIMER, RCU, etc.) are currently
> aliased to a single HK_TYPE_KERNEL_NOISE enum value. This prevents
> fine-grained runtime isolation control as all masks are forced to be
> identical.

For now we don't need finegrained runtime isolation. Only domain,
nohz_full and managed_irq. If the need arise, we can make it more
finegrained in the future.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

