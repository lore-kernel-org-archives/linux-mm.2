Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D92C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345FF6B0098; Wed, 16 Sep 2026 09:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6DB6B0099; Wed, 16 Sep 2026 09:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0466B009B; Wed, 16 Sep 2026 09:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7D196B0098
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:34:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2547A140714
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:34:08 +0000 (UTC)
X-FDA: 85219718976.15.E55987E
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2CAE020009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:34:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nrmRbVkg;
	spf=pass (imf03.hostedemail.com: domain of kayracizmeci@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kayracizmeci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789565646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKxhsj7x2KGNTWtDWeg+zi9RZVEL4pyqe1TauKiMIHM=;
	b=WyqLgzjryZuUBuQ/uoUCVuVIcjl2YdqlKFcrztQ/zdbRHU4SCZjye71XbbZkZ1vOWdJHd1
	gne+K5MNzPCuZvkym+Cw5xubVNB44Ucu2NhoAuWZtVW2FFBDGY3w3yOLY62ELC/e0MjpD9
	d0w3nUpKZMruvdHNsW9HSRAXhwxyVIE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nrmRbVkg;
	spf=pass (imf03.hostedemail.com: domain of kayracizmeci@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kayracizmeci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789565646;
	b=5QRsVeHXT0jeynfjnu90pxQ4eDVosdsAFfqw6kzGRb/5MCAb1gQGp1jbndmXDFdU7QVjzT
	tg7GumtplMfGt+Wd0dXYW7aUBxFHxsZ4dGpl8l+lyGbktBkxkKeg8MN+eurGIG/P24yHdr
	Gh/HuBD0O8lVrx42HPXMWuBgvWTSJss=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1ddd5d0aso671725e9.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789565645; x=1790170445; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KKxhsj7x2KGNTWtDWeg+zi9RZVEL4pyqe1TauKiMIHM=;
        b=nrmRbVkgjbCdXLltu3WyW0rIhlYtqBMY37dbteHzOzN3MkM3AneFjv6pPn8mglYpt1
         St/bQsq36mz6HiixEvCE5UDOLyntQulRhKFAX5H/Y8Ejb0lPRzHbvt0g5ruil69Dd+p6
         p1R1rd2RSmraL49wAO/Rqva5+EfKYRe4hnfbE4/LRC5VwNa3M+RQCJFGB/6UyB9O8s8N
         w1fzKsJwFr/G2u6e3W0ynA1gBOdjK9FZ0qmzO6oJLxQ2DaO/0YaYFpiCXhKXbVn+2wJX
         dRxvG0us5rfk1nNCUA6cUNluFZlEO0i0n6gUonITgix1efQcvXsY4jHvpK1/NrYxeVYx
         4DtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789565645; x=1790170445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KKxhsj7x2KGNTWtDWeg+zi9RZVEL4pyqe1TauKiMIHM=;
        b=dfH9qNffrJ8zQZ4/FtcAaGclQyIhPKWnK2UMGq353qJzVGddhGSQXjRGlMSiJpOkBJ
         kCUZlNvYiUuqSrQOEYRUyAB3qsnsV4X6P6FUVt5JFDCn2ZWHUFGDNsV2a15WML3vARKQ
         ciJmyjInkTK75Xwsn8o0+y2Xl75UVl9HX05w5009SKk1QRXEKLDxF92cAVQfM9nNjSjF
         cluP9ulBuROUJIDddnbUAlQEDcyvVzy2P7ipNMjE4uM+7ITCC8jXck/UDHT7JeE7uHj1
         sAlGXsUV1aCi/sCp3e6/g64oNC904tAnN7aO/4aoe1EItsbsVrjMq0zRMSnwnUp/isY9
         hFwA==
X-Forwarded-Encrypted: i=1; AKwUvBy3uqOuaNelXkY+Cfi7m4oMZxOy646dsx7J5cEdFvUxXwMnBZeWKT7zfjYcv7DxOYNteSj44H4YNg==@kvack.org
X-Gm-Message-State: AFuF++kIqJXml3IDjgZPbG+UJnZuvjXMqOtK5DNdnOHgJUptzhdi9U4i
	CpdSuUISr+g/31sQI6azwnabRxNUuYA21Md5e80zcnW8dEAIIfBr/r8R
X-Gm-Gg: AYBFou3m5gTADM0Mq1+6fQR+uUP2C+P0cdWBFNGcMA6tce7hOZUrBBH4ymWk4fd08o2
	JZixU71MXFD579crPv+zgznV+xJZllmzCRButoMq1UNY4n1gUwqAbASz+OIYElv0aAcfuSRdUI4
	yvrQFcoH3qE7evYgI/atMLsx89rv/JRXXsF6FP/Ob/NtQPWr4Bz2bNqc511TQALhAqao5fi/++v
	+WqZktTUGkHx29/07qFkECm1updjj26x925FpQUDyoPW06SHwqA4k39Z50VV9PGuKNmRT4a7izq
	hceB0AGCLu82JIkgIzLMY1/QTqgmFmhKM/jEbXB5krPzkRQzOF4WkB5MQWJUJvZFgtQgaptEGvk
	JE3vj8zj/Qs9KPQInoSxiCl/9LVBJ6v3GCXQFrja5w19laE3iLzDLw5MpT81gIH/xNSDAzSDW+J
	d/+2qyKWM9A0TXuWW4xxuXpHAA2kGucZpJi5anI6E/jQwS2oZASvv3n9HIBgJTo4Cs2fX/bvk77
	RhQJaJzyQfpJZUNLveoYDkwahKB2DissQ==
X-Received: by 2002:a05:600c:1f84:b0:49e:6806:5712 with SMTP id 5b1f17b1804b1-49eb733596bmr27842625e9.2.1789565644472;
        Wed, 16 Sep 2026 06:34:04 -0700 (PDT)
Received: from lima-kdev.local ([85.100.66.184])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf1fa70sm6931392f8f.9.2026.09.16.06.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 06:34:04 -0700 (PDT)
From: Kayra Cizmeci <kayracizmeci@gmail.com>
To: peterz@infradead.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Chen Yu <yu.c.chen@intel.com>
Cc: brauner@kernel.org,
	bsegall@google.com,
	dietmar.eggemann@arm.com,
	imv4bel@gmail.com,
	jack@suse.cz,
	juri.lelli@redhat.com,
	kees@kernel.org,
	kprateek.nayak@amd.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mgorman@suse.de,
	mingo@redhat.com,
	qyousef@layalina.io,
	ricardo.neri-calderon@linux.intel.com,
	rostedt@goodmis.org,
	srikar@linux.ibm.com,
	sshegde@linux.ibm.com,
	vincent.guittot@linaro.org,
	vineethr@linux.ibm.com,
	viro@zeniv.linux.org.uk,
	vschneid@redhat.com,
	wanglu.priv@gmail.com,
	yi1.lai@intel.com,
	zhanxusheng1024@gmail.com,
	zhanxusheng@xiaomi.com,
	ziqianlu@bytedance.com
Subject: Re: [PATCH 1/4] sched/cache: Keep nr_pref_llc_running in the runnable domain
Date: Wed, 16 Sep 2026 16:33:28 +0300
Message-ID: <20260916133328.3422-1-kayracizmeci@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260916123046.GE776954@noisy.programming.kicks-ass.net>
References: <20260916123046.GE776954@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: q7pyhjs69qp3y5hxe6igbkhebtdsxx76
X-Rspamd-Queue-Id: 2CAE020009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789565646-84396
X-HE-Meta: U2FsdGVkX1++gJSxKB1/MxIeWrxA9o4c2IWScoFo15hx0vaPrHGlGfgTCMiTHbSCEfMDFu3ducavGFPQmYql7SXi5bSlUDap2Ae49nEaTIqN7KaLiFsQHEqBJDi3O3GiSY6xq2yJ41PMqJdKBhfEztFK74rqsFC2fvlts2ZerQTqFVQAz8SrSqPR1d3KdpzOCtMmxzpUbTGKi3MUxcy+9GtYTPyvm6jFfMojme9OyVXCrYeWBi1/qYLQ/nEj930H9DD2H83HqVAJQNeGNJ7D+WFHErL8BsOjALhUna6RwttjFqJSaWNjEHgodhRNBVvzruVOVEizcFKMBYzYp3LvyxV1CTQQRI+Levw1IJpznN78umzBRxtYvO38lOG51xf2dh3i1in/W77PWZZXD2io0tCP5qBE7p9t/aj8sDUVVDdXiDUuTlKPeM+tujqx3BSaX54jQUqNGahrPArhKq4xfw9EuLTHPqXLLbWg0pjoZlHteAIr6g9hS8bINQLfmb2ewGJuCgxJxx7F2LNrCLKjemhWPbdqcOovOGF4Ewo3AqX6jVQ8P3sTbr1nknvvRGSnl2gCiah7+PJw7o65xKTQp84BtBFPjIK/fW9MBhHF6rz04HXa9jaejhrSE5lcLi5qReW5mLVrRcjdZDJPJ1Ynh8wZjwNw4YofueywBfCuKhw2AzroCAC0qC7k9Cl46/vuVsZTeXVvfYAoZ8kq1zzJ8ZBd4THZTwitgMoCY5NMFug8vwky34JrDpOP0RiW+WircUaeXT1HYXiNIyWj38kSgrXdfhZsJ61Z3YYKA0hum6y5dZ3h+bQCNq5vAW+AbChsjB2XiGA7ETIszSU2AI0apepyuouJw/TI+yQtcZLJvmpsap5b9DRrDKOz1xm93HfZk7OAR/48QgGtUn4B/gNsTmbgCbbrrZ1LrcMGdg729OEehwh4MhZ0DTUmsJxkYeYPTenOT/nT3UGDaNcL22h
 OVHYmIHm
 5SOs28q6xjntKJp2jsO+cbLwtAZIjTAQy8E73/y74tvUK/8HEkK9zzRgQaZ1Bl9Kj8ScIiFxe1aqiG7tIh9eI2vTabj3KZAP66mDaBZY3EOd0yFlhVSSF5m4okpYc83Ej91rMcrdpEXQA1rnaVhup5Vpg0j56Tnswskdar486D2JghIUzGAnJQdJIBLMbotC7nqw01wezAVKacr48VZ0CvRA57qWXVCLjnqXvGCmaCxzBwB4Bn/64fasvkcU6Snk33w2zMcgQO5+4wNBr+4FD9ReJPMYeD9vIbDAhwHuxGJvIIF0OTfYSjUi+mZpZkoZSVsEs5/heCFSzFmT8OVYJACXt0qxbU4dTHKiHDnItk/BwRseyFJCiqPJxwEuhEE1E9lC0w47Negf/YYIuj3meGzymfAQC5XpEPABQ7T+7lR0U75jUej9ZzWstsgqlgBDe0QMWeVVNwX46lpcX6nX9fRtDlARAkqawh3ZvTkqaCseuGfbb9zTj/Gx+/JmhOJUg5EhK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Needs a fixes tag.

Hi Peter and Tim,

The Fixes tag should be something like: 

Fixes: 714059f79ff0 ("sched/cache: Handle moving single tasks to/from their preferred LLC")

This is the commit that adds this:
env->src_rq->nr_pref_llc_running == env->src_rq->cfs.h_nr_runnable
thing. It causes the issue so, you can use this, Tim.

Hope this wasn't a unnecessary message. I wanted to
say this since I already found the commit and didn't want 
you guys to search for it again.

Thanks,
Kayra :>



