Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7928C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 739046B0092; Mon,  7 Sep 2026 17:25:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EAC46B0093; Mon,  7 Sep 2026 17:25:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC0B6B0095; Mon,  7 Sep 2026 17:25:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3922F6B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:25:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFEA41C1CC8
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:25:09 +0000 (UTC)
X-FDA: 85188246738.04.5DA0615
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 12BE740002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:25:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZOBDXX8q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788816308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGH0z6eCbi75StZiFhp1/k3e2S59+73Cki+MY1VrPg4=;
	b=x0DmHb2SGUsQIE/IUcXwh+kHmu7jgewYwarMMDnurFo4ngTxymBZD4GwQb8JS3t2Iknece
	Ivb8SetZXMYwO9Ilghl8xCfzE6JATj00vPZjU9kDFAFhCeMqiudbj+jo7shz8kmriwopPS
	WpW5lZXD0GC0Ll6IfKJcB0I0DzZutpY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZOBDXX8q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788816308;
	b=I1a4jjYRRMM9e0OhHupjNi8fM467zx4Ta06DKgreMIog17+jkJpk2kXg/Z1CAcVorQtd6S
	EiZhpQskFFtwuH9fZtvlCmkfGH5mNRJ50zNvQ6lofynArRBn3imzFU9zUToZJqdVikAcdU
	5CYOvrYtwjJW3+dgHYAel1m+w+eyeXw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F0B240BC8;
	Mon,  7 Sep 2026 21:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 750261F00A3E;
	Mon,  7 Sep 2026 21:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788816306;
	bh=CGH0z6eCbi75StZiFhp1/k3e2S59+73Cki+MY1VrPg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZOBDXX8qIyCCRdOP6tmA1KKhaSnjDoxcs35+x3T6KqIIusFXAjWJYrBMBEuco732f
	 2aucM9Ce26EMBbOtvMfVw5m3uXDmIwn75EbcQwOgTfa41bAvJkGvHUkD0LqeP68xaO
	 WXvKxA1HV/VFth7JkNkkD28247+PWkJqzXGr9urxogjw99Bfe5QZqorMT5PhKjqEPm
	 sbr0RFQP4JKb320CuP8R4H7nGOAk8d8njNUH7L5BnvlQtXPuY+B5/TUe0K1mym+3kh
	 E77o10jT7QSqMsVnSpIkTOivSqbfl3yuMr0KsodwV68Qx86U7CG2okAg1UYJ6DuFuO
	 /QlNjIUZ7JYxA==
From: SJ Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	oleg@redhat.com,
	tglx@kernel.org,
	david@kernel.org,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
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
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
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
Subject: Re: [PATCH v2 4/8] mm/memory-failure: convert process iterator to for_each_process_rculock
Date: Mon,  7 Sep 2026 14:24:57 -0700
Message-ID: <20260907212457.88243-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907081334.1152889-5-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 12BE740002
X-Stat-Signature: 7rpayogtqwpa83nagr86dtwj67t1d6p1
X-Rspam-User: 
X-HE-Tag: 1788816307-194762
X-HE-Meta: U2FsdGVkX1/B+2szuHFlv7iA8shmYvmPTIs9jBgV9WkE0WDV5SWkSGyq2mULkTay5DKAqlBpCOygzSulJ5N2Ff2DZmoBj/AG9MPmmqE08KAcIdY1J5yul6XBWwsLh2r4pHOjNvXodvPdkVYRGau0nF6i0bS4hgJpP+UzypwT6Zkkiw1QjG8Fp4UgoIxac+/50bXBs0F3ougoRTeBPM1npSK+bYeBoCw6SAqMigehUKDy/vh2lWXIDuQe/rbObqIEVwWq4aP+WYLwhqPmPug0nZL/IPOLTDDYNwdqfFeGyzzM6s0vLGe8WaPiHaigGfMp2Zwf3N6GYbn21Yt2y4WXQdCuk/NCA1K2lL7l+MZUPPZjZqw1/uH3RswhlsMgTPtPVHrBziagzRIfscr8U0ywUNIntv6lmUxbpoxA2tu1Sjftt4C7i0TqwL3JR9jEt9ocizlASTfBFIGVUmfAl8slc3Nsapuk8N23mRKyXO6lYGiC4Mef27Vzycsiudmms8OmpL1knnRoaWRL/AV6iiAD1XoKXdYluGEVn9Y9f4wwLG/mE+yWXT/L5OVN0E7H5ZOkRvvTeDlnVytpMDR8ATImrePcqL5xBCpmxhUJEXnsn/RhmrkzafbuB9jo7YaKV1HY9p3QnDsFoIxmmQmj3Ah3qsZKFR9ovXX08AWwnl5XhHIs/FODVpMzcmHv4XJcx87iUdKR9o7kLJcey7xvTTyXKutc53L+k59bOw0zJh4SE5ftWFlQPQYBP4lYytRCJBmKEsVqiuuUmCI9LWEcntNwv5caWvOy3SX4NUGsTdaf2rmCdS6SFfkp9m4XJNddPPAWqqtVVgg3nUupoRjR6TmMgszqOj8STXxCePwgSKPO+RFbVH6mLL1RzJmFBtdBUgn3X6r7J3OaeS9eCWiqPcb45uU/YY6XuY9nbAv4v9sU7t2+aJnmzdIYg8EEaGOKH9jqahixllx6iXzfPhB1tqp
 n3nEYW2P
 YfUpn/oSG0NzjEM9hqZ4uf0oWcRy5o0CNAzguAetcni43UnzgZrkv0M7c47ExuD5f90rV/gc4KzpziwDtaBwvKO+79inzbFu+2BNBWKK73k17XTqBZ/Wz/Z/ZilJi8hksLjhm9U0ROSEP6san9gu05y7dhP3s2P8tyKkAdouqBFBPpAPlcOGyn/lVFv9G5fgutsdTLOyFwF4snvC4BpM4ZxIFw4NuYeFJtM2gMWcsoBmDdIy3WW7iwQ3aeU7jNpq2prANyjKCvNTu82jq92gpoTXY+CgI3mhKi/ZUTwHQ4WY1gplpN8Y9QGWb3RNEDXdnGtdygeGrcX5vEmeMN/ItWzA5K4h8CVjHGPuy2q4RygHuVEWnZ700TKVYBVFC8JHUhP6oGJozIG+UAHn0FpluaVcdB+d0Wo9cN/VaXKfUk7HN4JZu0/tqk4aS1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 16:13:30 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
> with for_each_process() loop in mm/memory-failure.c with
> for_each_process_rculock(), which scopes the RCU read lock to the
> loop body via scoped_guard(rcu).
> 
> In collect_procs_file(), the page_pgoff() call now falls outside the
> RCU read-side critical section.  This is safe because page_pgoff()
> only reads folio->index and does not traverse any RCU-protected
> structures.

Thank you for clarifying :)

> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

