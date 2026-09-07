Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E20AC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915326B0096; Mon,  7 Sep 2026 17:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6506B0098; Mon,  7 Sep 2026 17:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B53D6B0099; Mon,  7 Sep 2026 17:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 602636B0096
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:29:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7BCF402F5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:29:11 +0000 (UTC)
X-FDA: 85188256902.09.53B4FC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 62F9640009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:29:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mEkeflrW;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788816550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SCl+jEvdrjqF72ntttZG2eEJe2zsb8hqXfy1vCrvzWU=;
	b=67CZbDV/k2H/fQry7NSkogyb7WDKxXKWk9qb/lY3MBJOwDWbBEKJvCc1Dh/VUyj751aDZZ
	ydcJEK11JD9fAgf0bAutWkMqjJ1hMHuZ2NwO6cBMs1N66lXrfiqmVDa0+atcD8hMLN3Oa+
	z2Q4FWSPFfC8zCi5fYGsufz1mJloMlg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788816550;
	b=ErldTuRnRtogRwS9TGVrB3xyl8pyr5gBWTkkIqPZ1rAWLhLNfZVDX3JYZcWXzHMdfW7k9V
	k4qyocXJY8wEC/zZYllKAJFeC6HDjbnRA7Ozo4VB8vwueMlu/S7+kBveD0cIVlLGUE13JC
	t7BKp0Fh8DwwZ1dw/DcF2IBmb0vyv8o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mEkeflrW;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1712601DE;
	Mon,  7 Sep 2026 21:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E0E1F00A3A;
	Mon,  7 Sep 2026 21:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788816549;
	bh=SCl+jEvdrjqF72ntttZG2eEJe2zsb8hqXfy1vCrvzWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEkeflrWN0r6Z+I8Juu6xf4YbiwhChACWok2YclBi8b5nJBlIpqf1i1momt9AzMLn
	 HI1QtdkqTbNw4Jerj49Q9WTpWX98qUbvbygdjgic02n/DaTSMEahTmlv1lPyfkNLUM
	 WYq/jtyC+ORcrpiixiCUqCGT3HhBkClPjn+0e1dhgw14q14WbqLaTNBJ1+rTTBFm0z
	 Wo+OnNoio7rYWCJuwuHi8LhB5Cz3YZD+JVd+OY+K/vMlx6/4gF71U4NBaqZ8jahuv/
	 zpeq5EIJQp6qYxFG4w7AcQ9aa36+t+qChh4tHUDjmdDzzGm6jRaybZIc0+0lUtQj6p
	 kQif/l2wruLaA==
From: SJ Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	mic@digikod.net,
	oleg@redhat.com,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	gnoack3000@gmail.com,
	ljs@kernel.org,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	pavel@kernel.org,
	lance.yang@linux.dev,
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
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to for_each_*_rculock
Date: Mon,  7 Sep 2026 14:28:59 -0700
Message-ID: <20260907212900.88422-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907081334.1152889-6-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yaa1xtsqgyo4heojx71zdqw4dajhu3yw
X-Rspamd-Queue-Id: 62F9640009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788816550-877202
X-HE-Meta: U2FsdGVkX19KDdAFIwQ0YDPRw4EVgix007hyJ0jUviT02bNYDU6Jkv3xAjYYDb7NJ7tNuGlSM/OcURnF0TX6DMDOT6o4Lq0KnX0jQ6sHic00CNGnoiRYShjVWAA4Aofslw7L8vg90UG0Sb3sZn05wUfWmeKClbdWxsfXi7tq5a+mf5b5utJrXG8Hj/Sx1JWDa/ugFy3Brl6pJRkRAFu2mgLdiKhtSIV9wG+WwhHY1B4I6j7JGtazxEfLs2IO1Gb/XsCtXY1tbT0OtfAO8PvFTH1TubKYnTv3uPlREEcXIsMfgURILS4HldrLxEGbiMl5FRFS8P1fKFcDCjTZ2HHWOvdGWpZrkdJuHPNDdVkB8n7n/1mFJsex61fwKTJlt5xoZVNNswNNqJYNn+KiP2fEQRJuGZ4AQ6tIzaAZZFIMew3hjukMYncGzVXUlD+Um7HiACuw9TL3UK72WtgF5q3ev7brxbMKZO6tU0oL9X/u0YXVSNPnt43cYjFGWO+YTRlXeK4yuzdCQf/funNgI2ZS7BojhEsgzrE//oHQMH8tXUb3qZhClLboL2DyyjZXkGadGIQSXLxJi9W2ANrI96AJD7dZFg2VkH2ZMAc1RvRyDtgWPaJnuuZVZxKKHdhOLfZmkzUybTxvCpe+72BUmHfI9LCXkqJNE4IMruTpwWsgUde0B42dvnmvR0jyJLelydW+XRKXzXj4+ur9bnM4njOkWJC+FM6nu2SHfBhH6Ak6Sls4HMxOSaeyso/A3EWGVXshnLgrUO9wrJNo40Vcf/Q7j82dVudVuMgAh/XkF08k7cAGtVgXVNeTZjfWO7vbU37GaXZgo5mNB3er/Cn0PUkJQFixaEX/JdCpaXXTaB0b3744Y8eUrbyXguVKpwpmyc6NuIkVCzQagwpxV4QLdDZO4Wr5varjrZHpdKlHgXaT1kSRwrE0GRp3a6t+OVFWDoYDiiiI3lDDWZ3GeEh2Kiz
 DfXLmsAT
 Ia3AJ/oi9Xy0iJUNNu07vqS8p+O7H34LCoQKVyXWgN0dGf+PKeuwEjLbRp0v0hES+ULPfJXmFWzrD7ZLH+hCjkmR7DbfSm5Ks31GWVckDULchVboNY0Lblz98mrR0BbY5c5CMhQoIFgw3Ogzbj9BQpMR1WF5yZottbteVLW80uVAFJFTgbT0mHwM9G1fM03sAqkamC5vNbOosYgYemfo+ohcu8NCWTvO6u63bn/wsumnhiwSw4FveM8uxPZNetOM8gQRKPUTjmhzWlIi69WVGN3R0SU3rJwtoUSXsjfMJrB9xbFEof1zfzqI3MGOhrXj/eQXtEaspEpbk0P8VtoF0QTkIxvGcPjNbcIL6stB82bqqRKaWsMPSGaJFDSsS+NAgPIDUgTa/5rHNxZsMhTqLme3VCECUMyPhYV05
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 16:13:31 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() and guard(rcu)
> pairs combined with for_each_process(), for_each_thread() and
> for_each_process_thread() loops across kernel/ with the
> for_each_*_rculock() macros, which scope the RCU read lock to the
> loop body via scoped_guard(rcu).
> 
> No functional change.

Looks good and correct to me.

> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

