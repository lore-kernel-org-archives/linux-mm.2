Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 524CEC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A0B6B0096; Mon,  7 Sep 2026 17:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C5A6B0098; Mon,  7 Sep 2026 17:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C906B0099; Mon,  7 Sep 2026 17:44:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D438F6B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:44:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6955A1602CC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:44:42 +0000 (UTC)
X-FDA: 85188296004.10.905F0E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id AE40618000A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:44:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ERrMVVR0;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788817480;
	b=x76BhK4kR8YCIjFJ/8vEUyaolp1bVNNK9sknjNZ2saPRmHwnvBuirIDW36v0Jz9csABzXg
	cO2NjDdvdTiL1HzkeV8DEKzH247CCvHeWpVUKuw7dauTlAEjM45lPpRoR17TA2ybVPKAqr
	5i6G4DoEVKxng5h0Ql/bBZ+aOpc+0As=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ERrMVVR0;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788817480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8PEL7ctvrs8f9gJpA/MPoY+Iz+nKZl0JJs1AfAL5Us=;
	b=PHjccnbjHGzDoWr3PDzM8UXONWepu21LeET5zpNpGO0eYiwBHBta95v4yzMsoyvLn/SHXo
	QZ4hig2dWIQlEeEDKOtXx0Gca2e/5nOade0WUP28k7PXms+ZCLLZXeK7qI1S8m9el486mK
	6Ri8k1uXzqM7+KOq0yRi0FYd/9KS8SA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1CD5B42B9B;
	Mon,  7 Sep 2026 21:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6CF1F00A3A;
	Mon,  7 Sep 2026 21:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788817479;
	bh=e8PEL7ctvrs8f9gJpA/MPoY+Iz+nKZl0JJs1AfAL5Us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERrMVVR0YoM06xDxrpDyejQIadx+eQ9bZoWCmhpJgu/z2Ag8xwoBwAR0W6lsWUUn1
	 10TgoAgTfR4oiRlgC0NQnYV3LwG4qDS0Z8J3Lye1zTT+F8y2lgfcCviKGokMfi3IhS
	 fdoMi5jNaNCng9cYb78yE8LXv3wErzf3oU3vDvK7enqj8LpGMMntCt0i6Bzyjblokx
	 BD6JCNmeWcS5tP96pScNCGcTK4eEGwIJTYCiapCvTbuXaO29J9Q1Nc7qv4EmeGQfRA
	 shDUPHyzErFUUDtFpQA+jm6godpoOjzdEJZRR94hbjJHxygzPwT6uknFv50qfBuUz4
	 yIdkUtPJT+n7g==
From: SJ Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Justin Suess <utilityemal77@gmail.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	mhocko@suse.com,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	oleg@redhat.com,
	tglx@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	ljs@kernel.org,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	will@kernel.org,
	boqun@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	pavel@kernel.org,
	lance.yang@linux.dev,
	mhiramat@kernel.org,
	pmladek@suse.com,
	longman@redhat.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	mark.rutland@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 8/8] security/landlock: convert thread iterator to for_each_thread_rculock
Date: Mon,  7 Sep 2026 14:44:28 -0700
Message-ID: <20260907214430.88978-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907081334.1152889-9-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nmifp1pxmi8qiumfhq1r86jz5gfggx6w
X-Rspamd-Queue-Id: AE40618000A
X-Rspamd-Server: rspam06
X-HE-Tag: 1788817480-809951
X-HE-Meta: U2FsdGVkX19SQKjcX6VyHgAamsT4acGPKm04xBib52CvaooaX/3+R6I3sSPC+m420VOD5MiPD+GGuBRij8BZ8ZqlvOImhskFz4O5QF/Sd/sAj/R/4TfGIm+QBSqQ/SVRJORJJBwb2tMquARl3lE1v6yJLUKWUFYBqS/fGA/fEBqDCuosuXJHjGPQqpgU2Um8ksvrBb7LW8GZF4L9H08v6JI9Fcd3bDhdYD2RbKKxYQVyUkGMdyiDtgcuvGokzKlRrygjppYAVXw5XASMuOWS8qTvTTfuMiMXNRe9Mcd4IyurcKtmKuTnP56p4ywnazAVQKR73flkhb1QWtvNX2TUvz4HIRxXn240nBQ+DdGdyQnTJ8F7GPIhA5bSXSl0TOt1yt9YEnnzuj1DTUdoI9ne/ZsohEn4zDfrn9PtItIXPZ5PRsLkqczH0pYn8fF3+Ofz9UXHT/08W07cla5IDqPewMXIkrppGPd19ilw1KXaCLmr62gzstXh14gBpFYWVcsca/BogYJGF2gL8cevkC6i5AdEBgHXJSEgUzF/xfX5RR2y4Cq6MJYXlo3VAR4qpa+NNip4Z4KWE8Xr2JKMbBHrchhpMioDy8nf1avWCEXYzY9xOLKNN2kaWNUt5hsyhdfvrtBy4tiPSUtA8wz9NJ7idTUJz4ZosjXeEmAM362E6zec3Gw6MDbRC9bYEi2AhCqcSWGA+44ZmafmfZSamB4oZrIKOQKdQ53UZMOEpG9i2aAoYvSqz58Z7PyDYXeQzKgPmZzigS8LWfgp+iavg8y4I/JR8t53Mhkf7XGk0aUj9sqrWyDhMsxhqA/vMds3GZ5hyHXKFN2GnfthLHwb7Dbyw9zHWVxWo/tHEjIbICV3qZTpklz/FN4WpT0hLBOArUFwREfa6rY1PAcKupflFAlc9SRVidAwo37oBpKnK2TFCPi+uwyuO8J6VBrAa5bZqLFIvxbRRIxZUFQgrdw09x7
 n/Vh/9wO
 uH/p0hU16/EzVwYDBtFwDiiD94AF8VKIvLWNEVIA7T5O+H3sq7OPsl5qDoHohBMMUK7T6/CwwLpF97nW9jR/tjbdKh2BfMHUtDHxxz28A687pVydlbaOcn/AtgG4h1HDYo4Rtxvkf39upjvYSovm0G6I2RjS58QkAOrfjrTcE2W1nMUGml8ekTfNHyjq7KVYq6HRLNUwcGhjff0YI+44Qb/kxzGQ0fC22JPRQWOaNzUTbf5JjCLv4ina5S68ZiBew8NlvSBq8bvLdiq4IS1+TrSnkrnReGHWRNFa2fX9GSMndCCmZK1irJDUwxX6EOaS/DgOFFGeLLDYUs8qDei9zbibeywr+V/sgWlU9pvGHURf7F3TQ0YpuyNQYlm4M7ex1VQm+ZySb1BGFtLbQP0VLlZWV1OBktCGwVVTb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 16:13:34 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace guard(rcu)() + for_each_thread() with for_each_thread_rculock(),
> which scopes the RCU read lock to the loop body via scoped_guard(rcu).
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Reviewed-by: Justin Suess <utilityemal77@gmail.com>
> Reviewed-by: Günther Noack <gnoack3000@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

