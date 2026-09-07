Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 696CEC79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47E896B0093; Mon,  7 Sep 2026 11:53:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455E56B0098; Mon,  7 Sep 2026 11:53:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36C826B009D; Mon,  7 Sep 2026 11:53:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13E786B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:53:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A097B1401E5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:53:57 +0000 (UTC)
X-FDA: 85187412114.30.C1A76F5
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0CBFC0008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:53:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ijnoLH5m;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788796435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpjJCtF9a7Ao8JicOrb9fcW3ZU3uKqej/fz3Z0ryD7g=;
	b=hZkHEx8xa31cIkHEEwPQ/91kRjUtV+JIYawH71Kc5i0CjrfVuLiatrWWKaKQ2cz1nD6ZNJ
	HQ6G90Rhdt1tMLezMteRIJXmzo5L1qxwpSE+bdk/1ZdWEfR+7u5jI+CAd/voxwKgFBf1qe
	ZY2UuagPb6hEvXXPj+q0TNnj9ojwt5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788796435;
	b=XSPzK1l1oxQtLgtbpcucjpMLGUzcdzd9RkT2z5KlIH7vfqC/GNemPPlKDl/E1yzmZeZklP
	rRHrlI5UPJZzJE0hWt8qiIrTE1jxiUbbWhsHOaA5tgNDW72qJLnFtFf7HCtpRjakjrifdT
	hkx4X5rnUJTqs3zH8Wj1lJMd/0Bh/Z0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ijnoLH5m;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-9104956083aso24992996d6.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 08:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788796435; x=1789401235; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MpjJCtF9a7Ao8JicOrb9fcW3ZU3uKqej/fz3Z0ryD7g=;
        b=ijnoLH5md4T6g6lyj1SirLa5lBDDyMJqj5LcDXFLDlVjBGjE1kmFj6zZ/8wmsWE1NQ
         UpL0J+bqfCKUYFkfXs8yZHEZUS3rjxVJOf7E5gZ66p4xfKSpmDgmzPnOUvYFBryOx4Hd
         HptlMHda9FDmCWFUbNrffL0aylOEpPT95YpzZt+RbDZ4XGuOqDbDh/zEu50UN+m1botx
         Y6dTkTq9A5d81oFiHkdY2ANMCbgQPv/49DX9FVd7H+Z+hp3b8Utv2okoSI8eBuxZhFVT
         7ZZD599gVFOCsH6EYq9BSeKH2a4MMfs6MVEK8CLSXh+ImPlhzuby5v+jr1r3Jh4YSvNj
         wRow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788796435; x=1789401235;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MpjJCtF9a7Ao8JicOrb9fcW3ZU3uKqej/fz3Z0ryD7g=;
        b=R1Vx5o6m8p/i8w/DAUS2Sdr8eB28Beo3Gw7nWDIjkZ1lGC8mktDlhcRIsPkKSVjNn3
         z9z01IuwXli4ElSfjl4q4vkfHX2RXEokCsYoFx4n9TdkhINX8j5e2Ow56zYA/USHF+2w
         lOCdwgSZe38tD0gMWZa43Vuu4jV/uCA5uyUQx1ya7Y4zFYf6Mntzebfxs8JpoWb4MtAk
         meUYBwgIjsrocvyTgUIc63J4kcPDXg79HVtSPVQ/r6n+Fx935/jyrlFf5aX8Ds02MOnA
         XVGeOjDV0YlkNLgqq1fWBPV1KOOrCAmixGdAL0ttRaI2u4E4jentR3xmcBw9bke39UNu
         g7wQ==
X-Forwarded-Encrypted: i=1; AKwUvBykP2gavtAJLdVCLGX/BJv/SNbqTTgiItcp2J0a1kbf+SVt7mxs7O4ik2KBEenHRt5NLbDHvTOv5A==@kvack.org
X-Gm-Message-State: AFuF++nd+tjydSyr4gkV01pbuD1jW2pGtBrPQL8DdPMHIwOYSSuAwUaW
	odiddz5rJVwMrKTE8OAgENZpu4AJLn1RUrngWn0bXCm6AOHvfixlHziAf6f0AlsFgNA=
X-Gm-Gg: AYBFou0+02x2FVW/e4+Lm2OY0obpGbHLHdJ5vu6RseFUWvYrcfb1BgjxTcDmj2kpd3N
	C0FKcArLZAoer2ybt0gQWmlkTcMPD0J2fKcUIi+TQDzuAZJgd4D/mangZyl6QshikRBLoibbSN/
	DCDjCxZ//9Hd3QKPy8IZcGHdQY0joLYcSoUeQWEDOH8sM6cTxfGK50Py3l5DXDVYFwumqT/l71i
	5H8Cyog9LOS2ugVLm1Mg3NUZOpm2fnhHpEAfpL5H1TDghHFVmYD1PpBlkFv9NagrJtPQsMeIq0B
	lh6sAUbUxjfz/KkbUUXJCrH0/PBsUv53x9slqLU609aunSmX2B6IvEDlGjP8O069GBO7atvilhq
	GO4d8qiiZNMk4EWRqKNVhBCpSMCVyj4X1iwUpY2UBaEpmxExdy9g6Uw+POihzLAG+cYHGoi+Ckw
	5c4hBp05bq7HejEWmYw5UBLUXE28JiScRdR8d6HTL8D7jgCHX0JO50Uc8TYHDTivKj1DepCKzmM
	9YysW/VKO2B/os0VWUnmKA65b8SkIBRm4AGsJ5ppQ6A
X-Received: by 2002:a05:620a:851d:b0:939:6de8:43e3 with SMTP id af79cd13be357-939804cc15amr1836196285a.48.1788796434937;
        Mon, 07 Sep 2026 08:53:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9397fb59c72sm907982585a.26.2026.09.07.08.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 08:53:54 -0700 (PDT)
Date: Mon, 7 Sep 2026 11:53:51 -0400
From: Gregory Price <gourry@gourry.net>
To: Ye Liu <ye.liu@linux.dev>
Cc: Thomas Gleixner <tglx@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett <josh@joshtriplett.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Ye Liu <liuye@kylinos.cn>, 
	Michal Hocko <mhocko@suse.com>, mic@digikod.net, oleg@redhat.com, david@kernel.org, 
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, gnoack3000@gmail.com, ljs@kernel.org, 
	sj@kernel.org, rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, tony.luck@intel.com, reinette.chatre@intel.com, x86@kernel.org, 
	paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com, pavel@kernel.org, 
	lance.yang@linux.dev, pmladek@suse.com, longman@redhat.com, 
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com, qiang.zhang@linux.dev, 
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, 
	kprateek.nayak@amd.com, mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com, 
	babu.moger@amd.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <ap7dC-LWNaoPYJvv@gourry-fedora-PF4VCD3F>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907081334.1152889-6-ye.liu@linux.dev>
X-Stat-Signature: 7r57nm1xyy8qjgmtioxjrkgec8j14khu
X-Rspamd-Queue-Id: D0CBFC0008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788796435-713380
X-HE-Meta: U2FsdGVkX18Dd8+WOgOgaAGYe4C4a8PAbjH0HpHIvQ6t9GcSXpmWnZ4OYvGxEikMEtB/4LJEWjR0epRgsgQnj6nPIQzqF9yiE2IaDRvYCzSKLDbMd0yvQa+I7rfZFU7PGIlYuxxqazMdFmY3cft9k21K8Q6Og29fcVkqu0ehwl2X0LnFf2mJrmiialBlheen+8+nTWEde6UGKkW3oGPWemxhT0InQl39z/vJjexKnCIZ58A2+SoyfBghWNz5jZOtOq0aU+Uo5ts1MXbRntWY87jvw1etpSIlMa3yftTlsupNeNfYgXuHbK8D4eAOXSMESrqzN0BClW+ZUdramYsnm6xoxjCu4VJRwNxE0oFMz29UZ//fiQ1HjKWtwQIoF2J1QMz4MJgVJMrFiJ1jsTnhqoTqEHdapO+n8GPDTOuS5OUhU2NnrViCh0qMn1bfUTGhWwmPpZWTHIHJ5GtkzBdOjfvaKNmqMwtX4+LU9G51+QnoOt1kb3xu25WVlg3iMCU5MhMrbYiPRSn0dA7mgUgp1SDg720oSdQcN690fjphSCniBqcxTg7uHagvOyOSf8xLU71DZOtU1W9SPgnY6MZ+3zzw5HJK+hn+JQfYz1AKqvSyRcqU6zf/mnNwNJP1s89ZSs2k/CsoFqqMnSljWhTHCddGFpDCE0lg8vOzVPVp6Vr1JA69KqKbUipiY57vJ6OuyRq8u04RV6jcX073gbUaLJLHDC3NNcicdWBVp16YBVuCbW4mUqHOocuIRnTIzM9ITxfGlMUVAJq8+HUD9esXjsJU2nitybMuQnXIbWRfUAJiITyYIbi8GKzxHlVw0Mko4g77EKSNjXrZ+dqZKCSR6Q+WBA+1FtkOAapZJVrPKl+Z7xKbqbHsKeeZzb4wOeJAQdfXiRTEf9gDJFGMS/R/99KUpFyKuivK9NCU3Tygm3r9kzlGU763dQZOmnT/SSDRvttLF2HKFeTLU4C1o7x
 KHciAhIF
 5gddOPtYcB8QoDDyj1XlcHibEVGa9TOzcKSeo0TkW3GnCWJ7EiyQcB6af6WQvsoQhRaNlMO9VFDl9Wmk5GA5h8oJqaIZPPNyBE9b8v60GQa/aR+w7Ef3AUIw3ZzqQhH3AdVc1NuYswNO31/Isg8eyS7+/5iHSvjb+/f2LBWUnkvi6KVS+B6teFlw9jOt77siaoOqwdd9zb8H3Wwdkb4o5OULecxeCuDnY9CYyVlDUWKmM+Q1CtRVQ6jLuoVM4JqHWq/34dvyuBfkdww6UbiGod0SNb274kvua8YkAIuw8KrJ4Cs3n38cWFnT8lA44FqzvKtyv7O2Lmw6vd/Q+NH/TjH7sGRUocA4dV6oXuu5jz+qAUEHPfKRzFDTc2EWZeKYryDAMuSlKlhdfffq2IB0S4uK+0usmSKnuj9gc6iaZwuQkTcr24qcKV++NWetfljSdI5TGTAWfxtdJx8g6Ne/YkdPbfN8WQIpFqj3BfLap6bh+qVnoGHpDdoooI1Uj+O9GV3w3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 04:13:31PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() and guard(rcu)
> pairs combined with for_each_process(), for_each_thread() and
> for_each_process_thread() loops across kernel/ with the
> for_each_*_rculock() macros, which scope the RCU read lock to the
> loop body via scoped_guard(rcu).
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

Question below

> diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> index 6fcc94ce4ca9..73a5ad3be9a8 100644
> --- a/kernel/hung_task.c
> +++ b/kernel/hung_task.c
> @@ -315,13 +315,12 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
>  		return;
>  
>  	this_round_count = 0;
> -	rcu_read_lock();
> -	for_each_process_thread(g, t) {
> +	for_each_process_thread_rculock(g, t) {
>  		if (!max_count--)
> -			goto unlock;
> +			goto out;
... snip ...
> - unlock:
> -	rcu_read_unlock();
> -
> +out:
>  	if (!this_round_count)
>  		return;
>  

The sunken rcu_read_lock()/unlock() + scoped_guard usage makes this goto
at a minimum very confusing, if not actually broken.

Are we sure this isn't broken as-written? Generally we don't mix cleanup
and goto for exactly this reason.

~Gregory

