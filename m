Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D438CC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 07:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66906B00A9; Tue, 22 Sep 2026 03:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14946B00AA; Tue, 22 Sep 2026 03:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2C976B00AB; Tue, 22 Sep 2026 03:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F48D6B00A9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:24:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3E2761A03B8
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:24:07 +0000 (UTC)
X-FDA: 85240559334.03.1F1B819
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id EAE9E1C0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:24:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZljLmvs9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf18.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790061845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdJLflAlPG2srZDj55Kplumdt/HlutALrygg5uboHCg=;
	b=0N/+NySa610i/EmUAAaAy2+ecYAD/wmgb0ExxfrCFkLNNtMo2FnixCsSCp0Kt549lVuhqQ
	zQnS9aXUfJaPzcXtnBAFNa58ZrwGEXdFRMHQIijhnh6+86y6GOMWVwHIZzTTxfChhfH9Lj
	mxswi+hio4q+4mqZYti+xcSeTB/mso4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790061845;
	b=z2Bmd+84qWJtJ/gu4fN6wY5Xwx8laW6NSpSvkw583NOuPpZ8FMssynFxBF5I4eht2lFE/i
	OoPn2nH64SvkFWFxNp/IQxxIDC29H/ECUh789tLYddrfejbOusPF26eQP4is0G5xXp9qaz
	7BmgfWI2cLv8tyawiRhqZH0OndBIYtw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZljLmvs9;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf18.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OdJLflAlPG2srZDj55Kplumdt/HlutALrygg5uboHCg=; b=ZljLmvs9ZpjUSMwVeNapnu9yQW
	bR4eSE1Y7mhFS2+g1kSyyZU24sd90De3F+IE+8ZpWQVqbI4UWfI6MOO4EVCOAbHIUb8G7FTPXNZQ+
	zHhaaauBp6/etPY1cYGIeFssIs2ve4iIpnkAdMSCgCeePrOBqlC533SUpgdp0sGs+CAEgqcxpmRqv
	u4ZE9wd8xRrgZ4lMPZ6mTWTm9KKnv1dwpvdTxIK+BF0ikHIhWB+3qiN4AA2gjbKN0OaIkEOpj/tvr
	0I6kaNTzsihN5aPn/nWepBC4pMSUTPZn7Wp/hm297NaxViUbCXbGY1nvj/M57y6tysU2MxwEFz833
	sZlyoGcw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8ur3-00000007UwY-1ISQ;
	Tue, 22 Sep 2026 07:23:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D97213008D6; Tue, 22 Sep 2026 09:23:52 +0200 (CEST)
Date: Tue, 22 Sep 2026 09:23:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Lu Wang <wanglu.priv@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	Ricardo Neri-Calderon <ricardo.neri-calderon@linux.intel.com>,
	Chen Yu <yu.c.chen@intel.com>, Hyunwoo Kim <imv4bel@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Yi Lai <yi1.lai@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	stable@kernel.org
Subject: Re: [PATCH v2 2/6] sched/cache: Honor migrate_llc_task semantics in
 active load balance
Message-ID: <20260922072352.GW4121339@noisy.programming.kicks-ass.net>
References: <cover.1790035273.git.tim.c.chen@linux.intel.com>
 <cb39f64a17fc2b76097264aaec74a2d6dfff4315.1790035273.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb39f64a17fc2b76097264aaec74a2d6dfff4315.1790035273.git.tim.c.chen@linux.intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EAE9E1C0002
X-Stat-Signature: 6iw5cjn9htuu9qqpz8qs4j3683k7uogr
X-HE-Tag: 1790061844-603030
X-HE-Meta: U2FsdGVkX18TKs0YRQo6y8W5HKHzYnucRFdDONDJ/PhV8RntkkJZEmvv8Nikua6lS3cwoHp24EK5cKNmBMOVGwjjEM1ePSmrMEtMEhM3sldJesdYPSLTLWPeBuBNgGrkxTWK56GvvF4WBfYfdfJ8bYvfJZxcH5Wfr+wvP3IH94ngTpV5+v2PrjvZK4iZFd1pL6g/MqJLa4/QTkRMfsGxzm98wyx/otbBWlQDHfSP21nLmEAgd+C9+NsZSeoixhreNl8IcKyrqA0XDFWUVyA9CQuGt9THacTGFfvTevmxUsBlwYtNwo9R/djMU3DIz8Qr1KHTE9RT0Frq8mUCF4uUGAd/rkPHBOb0TRKWJlwLuuFQNQaeG3Yk8UlXawQq+GS++HSBXGvC4Ou8nqyUvn4WMWPcqQ+Yt+v5AetYRigWsCFTQ4ZMlSWrvcDbJ1+b1q+O4yWh30LVaHc4aumtKyf19SkC4E0apPlYsuFYMPRXqifY7JrXck/gcGbGudpxKWDbmzOB9T7OBqw0mkLg3aCCgFfLcSdOw1BDGZLOFVu0ylWS62yjsliDo9TyzqFnepoj+u1Tjjl4lqflcgnztAbr0CZGj/+lnDs8D+eWWCB9sTSarfjVV4p+LECZ/dU40nIu+IN8ltn353v7P31d/TAIM3QOquByWcvDy4zmycqLQUjVyIidHVlOT3Y/Mex4XcBZsrGhjBS7EDqS2UxjRhcwW5TQ8ZP7Q4kkNS1MxLYqOZnTxLxOoV8gUGa3K6/jhpnLHX6buIvX6xWxj1MA6NWDmPHfVKF092yzfk2OThX/USqGKWfhwtR3cCl7RlfGK8bteAWz9epknQEAr/UpJeQk2D2pRSjg2FHsMiI7D9boDVdAhZKH9T7tEjrGLHQGOacF5HUBq7JH1YYSKhy7HNr/CmuttKUTbykwOVF2J8aN+CDhsk+d7NXw7LnP73FrEvrE0HnSP8Zius92MCp1duE
 vj3U0BrU
 9vQfG+F4BNbuIhWc06NrzFXTRDwauxigvoirLvQr2KBJX1qOMiC+PoF0+LtJaOr+4CcDOGMss4IeVZ+EnbYYYejAaQplEJx5hwQjauQksfCOnT7aIv7keF8/32/gtW0Z8leYcay9Hq+K+zPoLroaB3tdrcXFOWkXkZhTbTKjoVz2IcmQdPjSpIVInYCvNRvQZn9NPIHUk6ZznACpJaziTj5EFAuUda4G4ZiOhx0FLWSCucMHpaFLQotLPbNclyEQM2n90puv3CeMiG2UUMY30CGd/21A3urf67BKPsGFpwA3PU1D0Jtl7uuBNmziEwpTMnmJoVYDEb6TqJzSnMrMXGQsiJ1dJZtphwx3bYcX7uevnVwR2k5wD/jcL7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 05:37:23PM -0700, Tim Chen wrote:
> From: Lu Wang <wanglu.priv@gmail.com>
> 
> CAS introduced the migrate_llc_task migration type to direct tasks

FWIW, every time I read this I get confused, CAS maps to
Compare-And-Swap, aka cmpxchg on x86.

