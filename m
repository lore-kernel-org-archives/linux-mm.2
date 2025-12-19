Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D55D711CF
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D536B0088; Thu, 18 Dec 2025 19:43:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0BA86B0089; Thu, 18 Dec 2025 19:43:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED7E6B008A; Thu, 18 Dec 2025 19:43:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B3BA6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:43:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25827C044D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:43:48 +0000 (UTC)
X-FDA: 84234372936.10.B47A2CE
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id E832E140006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:43:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="D8z/T1LG";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766105026; a=rsa-sha256;
	cv=none;
	b=LOL3M56d6bK71MEX3bI563DCsq4yOwpQf9nE0YozbxEeX6xUE//qUio65tyhFqrH/ooU+V
	zyzIk5Tj6Swp70KHwgjtNTQYOhV2E63SVEhPPy3RGTjIVXzDWTSEXWE68++iOppIw1CA9q
	tOvWUVGDjA41TSDDE81YyzBxlgxZYWU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="D8z/T1LG";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766105026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5yXQjeYJcUm9npCVl/WQPVGb/ZOj4espvLUprKL8vc=;
	b=RGjh9nB8ocK9LeraSlEMQHL5HesbLbmw9YHJ+b+S5wju7Wi01HiUNfdF1thshubV1GECkQ
	BT9U5K20QJovVJw1BJAUbB7hVdQi1EZSDCRa17lQJNsJr2tIxESrGGFlI81qlW3K7+wuPl
	2Gjua9RhO4WKKYQTokHg47SivQtHNCA=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b2d56eaaceso149083185a.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:43:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766105025; x=1766709825; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5yXQjeYJcUm9npCVl/WQPVGb/ZOj4espvLUprKL8vc=;
        b=D8z/T1LGJEa/rdzMEGo2jT8crY8NAnIxsWKigcBIBU9HF+7UbyDQoJ5Zw1sIv1O1/2
         pbCgAVYRdOEkflmKT3TCjXsnt3qBJeQHJ0O1y/m0TGW0C55KNAnUNUeYT1/mBh0L055m
         s29FZYEyP6DlgkvMHYchcbdSbCCKSt1AyDS91RMVViIzOz/sB8Xsu56wLN++THDe5ynS
         CCaXTGj6vdb2LccjAERgOP17vF69Xuurldrr9g1Q7C3xJ4ozZMpMZoNOtynh2emeQgiZ
         k2Rpg2n0egzhjQ8cdmb5ac276nEH/uPkxkFwoYwM5SPrVw7rit5ZAiLgAVYhcjn/Ltt2
         VHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766105025; x=1766709825;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u5yXQjeYJcUm9npCVl/WQPVGb/ZOj4espvLUprKL8vc=;
        b=wXDD8ZyFSIYP6AVx5Z9gieYN0cigYWYlLtgCQf2Nj3rYdV82lYCv5/QAaRmpLLuDoU
         e3/KuxXWwu/P7MScE7hVkdx8NFvaUmdrfwTd8oP7LfXBoYgaU3Z7Xj75BSmObJ6yhARX
         Rv9axV9AwM/oN9kkFLQCrKfGmzrXYhE6q+SAq7AdRJ2OXy74l/UPC8vdojG+mBgJQJYk
         yXqxs8q6eRV+YobevcH9btluDLCyS2CR3yH4HUdGtuZUNdja+WxXlQRm6akdqLVh0+Hn
         gdA4KsMTFN7pNmblVgR7mdyIsJkPraTp6+Zt+5J2L67izZ13zNpi1wrBQTGhsWd7qYSe
         EESQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGsKwE6Vcv23IFNVKXBzEuM7h6YcBm5CMWfJtDM6wJSz36H5hSJLKZoV8GunraFYYxfU4s2SV9LQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5s0CFEOEKgyzQHSRcnstJY6gIGRhrNZdX67WmC5PHliMO2qpQ
	fKvAdShdgluP56Ai5bgQ0NZA7m7v1DoU6oF4JxgbuVt4WELS3Ua39svi
X-Gm-Gg: AY/fxX7UokaLMJbK/cTNw8YVfG0qywcByF5a2Eft64+g8jDnL5S5kHFan2cr7SDMSPf
	6b7MQsUBplyHqxfsqiBbmBnR+RI+Yz9hxVTxhWfZTVTqklvxl+kKvnVM0x+lSLtvStxYEjbGV5C
	M/nkxdMaxQWLITTt/e9mEVx4kWE+roWJVjDvok9ddnb64WLK3p1Uz4igxM/xfylO7rm7VS9GFIP
	gub3mlsY+k+4Z2IEayjc9Qxc2s/8iIk8lJmrJgc+X7bupVA6cHFD3lHJHag1XN50mXK+cZK/hsl
	dIN7pvqWAd+q9hrJr3A0KZ4/wvfIE2+mr5BpaI6zQkKU0r642wzQhzIrds6NLHb//Wzje5klDxu
	FtESsuQUbgWWp3eoA2Jkw0xMUIuSIm3ywgSU56q2PdCxKLfBBisISJvRSA2G1crQmrUv2b10bw/
	3YakC5QFA1Uqst92XVo5qqMOfR1pV5UL2UWAabuZMN84+6EushLKQ2I4FuX0QIcJbPFQpl/OLu8
	YnIxDCH5bjh1dMQz+PKGPMEPQ==
X-Google-Smtp-Source: AGHT+IFay41fv8PMLFKhbM9Xqksn5yPJ44K9INTfADwIXSsxeUXdkXezhYJ/sTAO68xxPH9wqKC0og==
X-Received: by 2002:a05:620a:191c:b0:8a1:ca96:5d39 with SMTP id af79cd13be357-8c08fabda51mr230657285a.59.1766105024843;
        Thu, 18 Dec 2025 16:43:44 -0800 (PST)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c096783662sm67864185a.5.2025.12.18.16.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 16:43:44 -0800 (PST)
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id BF7F9F40075;
	Thu, 18 Dec 2025 19:43:43 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 18 Dec 2025 19:43:43 -0500
X-ME-Sender: <xms:v59EaeAftY8boR_LXQwkjYXG75LZuTP6aK7OJzQPjgu0cTzBMjQaSg>
    <xme:v59EaVrotpcsAo6Q92mmtVinEj-wxAuodYi7C0dLXtpLaeDPDBZcScWbaboCR4-UH
    fJLQ9RfurryVUxVSjtkVKdPneGwlreQ5hbEli3-9YyE3uupKnNlgA>
X-ME-Received: <xmr:v59EaSCyCsvr-vOaynLld1YCxXWgcxeqgFGEEN3q9A2sKhe5i8r1qakbDW4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegieeklecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrthhtvg
    hrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveeiudffiedv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqh
    hunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqddu
    jeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvg
    drnhgrmhgvpdhnsggprhgtphhtthhopeeffedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepmhgrthhhihgvuhdruggvshhnohihvghrshesvghffhhitghiohhsrdgtohhmpd
    hrtghpthhtohepjhhovghlsehjohgvlhhfvghrnhgrnhguvghsrdhorhhgpdhrtghpthht
    ohepphgruhhlmhgtkheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkh
    gvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepnhhpihhgghhi
    nhesghhmrghilhdrtghomhdprhgtphhtthhopehmphgvsegvlhhlvghrmhgrnhdrihgurd
    gruhdprhgtphhtthhopehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopegsihhgvggrshihsehlihhnuhhtrhhonhhigidruggvpdhrtghpth
    htohepfihilhhlsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:v59EadwY8KDN4BqKdqkPGjxdmzPm2xP75Cd6JnjBeVbBDGbUMI7Xgg>
    <xmx:v59Eaa74_zwyFapcMAazBtoO36hiztMsW0ymuG_x4dsq9WDsY-8h2w>
    <xmx:v59EaevHCeZW17ybOQqxbPIzNIxvUw6PkUNMH4WwUTMGoIcp6BNhWQ>
    <xmx:v59EaXsNk6QvIuZnQUiPMaHyRDhPRvbMr79LrZj_UbhZUPztfY8O_g>
    <xmx:v59EaWv3BFKQ45zgyfitJutqnFrYmD4ojS-u9-hgcEWFdlTO9y0E8JqE>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 19:43:42 -0500 (EST)
Date: Fri, 19 Dec 2025 09:43:39 +0900
From: Boqun Feng <boqun.feng@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Joel Fernandes <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,	linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,	John Stultz <jstultz@google.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>, Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,	Vlastimil Babka <vbabka@suse.cz>,
 maged.michael@gmail.com,	Mateusz Guzik <mjguzik@gmail.com>,
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,	rcu@vger.kernel.org,
 linux-mm@kvack.org, lkmm@lists.linux.dev
Subject: Re: [RFC PATCH v4 3/4] hazptr: Implement Hazard Pointers
Message-ID: <aUSfu4V9mrD7BQGl@tardis-2.local>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
 <aUO9KRaP0FXpm_l9@tardis-2.local>
 <fcbc99d0-b7c7-45f7-9cf8-f5d3bfad966e@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcbc99d0-b7c7-45f7-9cf8-f5d3bfad966e@efficios.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E832E140006
X-Stat-Signature: kcrdpo987kebyf359wswb6brh8cm7omo
X-HE-Tag: 1766105025-911238
X-HE-Meta: U2FsdGVkX18IQUoY8GryApbgh0VYUjvkEUGXSfmyYLMoprKo49pnSn7mOA0vFmhFqhrmhW4B/fbTx1TVKATRg7kkSufw4X+WTGakt9ZsKxmwV9q5awbFleZBQ+zcHDn66nTxg781y8uAFqnCGoiQ/9DhnOz0uH7a4yQ3ggMsNhakaNJ3QPFGjQxT9nqYY7vl1no43j2HaWGY3Q49rM76wny68ZBUgzbe7bYjZjYb0IStj807hfJCNtJXkId3M3DHMpRThT7UXCkzXBRpaWSol/gLXm7OqyNsZNpYnjl68d1fA81P884zdy266Vl9K4CyfPQUds9vVvqm2Zn0w/wHo+aZ6w56+xFF4C20MDW6luc4Y81bwhvsSterLGA6MNocsYzTU4MHegoMXoybgjy03bFkYxQTLuTbnKbviSZzJy0jRI4TP0l6xPQa3bKXxlvFp/IT+Q4VjWKvCxXjhcFva+ujj11nQwM+jZGxa0I7jQBu4XZ38Ro5Z6nr733R8EySZPnV/e2JzGhXnWGbsbNOAmDLaP2PnZ5dAruyPA7yPSo/XxnbiJ+BaWhcSNJQfoWIfCO6Z5w6JkxaDKoNSPEREteLp9XOFNvgGEJc4ni0cyxsuafCPJTLornF6kQah1JN+g1E4aSmKkeeP+Nh9sRRD+clnkmDJpQnZlhmuErbEj6W6Kgk52RVcWF9JWfnbrHQwLvR4a5cdIf0lQYxPdSjPaMoR3GpLgXPb7DO7J0dFTAFFhxVqkfwbbHBNE0rujTw0yr5+R+1yoyXZaGYeljTkfijusxGd/NMrYvQNGjgC9uSuuVEACATTlL6nZdksto+9mpiaa8ESf9h2UKldbG3ru4lPDfeySoO86eDjaNYoqllpN1nFujpvtx3zKI5fGuztBpF83VCdDAGYHbLrnUhxQfnbwgU35/meVPJj/9nQzU9CaDi0viDsXYwIZRP+oRtdnh5kVn5XbS8GEkFhWT
 6t1Gcty4
 UOpuC5TZHBrhI/VK8mbAT/5IRmximI8s238B/zqKc/P4ZyXoYyLjs06eEog53StnxBe9WbU9o/nsK4rT+Z3koWxCZtjbqc8ibBNuevEVyxJ1siZkuOvLYuMq3LuN4pfVp+bw0H7b89Z2LsY9nWUKzH4C6hoS2VtPWqN8tJ+GLWEKAUZBh65WiNAWrZlAgIJV3h+uQ9jRr01sM8VnPvpt7ePqQzpp4npLLmpXGOryVVUtlHjQrLaLmZ65JNFnece0ALUmaen0z+Rr02+nIyCz/DglIFbQgb8VWY6B2xgqpMFm+u3QpJqT1LSz4niCVbajLHU37E0rG+YEgpQMD8b0e5UMv/drnoyMddUh3ApcLrZMj9KHrWxNmfZR3krhS2vdH+HdAcRxYvEQZpAW0npe4mxLZ70VYb5fQyr+aqUOY/3Wg3azGoBu3whJzDz+tdeH/3CZCMXur9idaaIqGs+JnPD1t5IUFc5tbFFhNNxzbRYaCNEcvZWmsAEZk7gmkVQUZSPnqqDQqoki+Szo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 12:35:18PM -0500, Mathieu Desnoyers wrote:
[...]
> > Could you utilize this[1] to see a
> > comparison of the reader-side performance against RCU/SRCU?
> 
> Good point ! Let's see.
> 
> On a AMD 2x EPYC 9654 96-Core Processor with 192 cores,
> hyperthreading disabled,
> CONFIG_PREEMPT=y,
> CONFIG_PREEMPT_RCU=y,
> CONFIG_PREEMPT_HAZPTR=y.
> 
> scale_type                 ns
> -----------------------
> hazptr-smp-mb             13.1   <- this implementation
> hazptr-barrier            11.5   <- replace smp_mb() on acquire with barrier(), requires IPIs on synchronize.
> hazptr-smp-mb-hlist       12.7   <- replace per-task hp context and per-cpu overflow lists by hlist.
> rcu                       17.0

Hmm.. now looking back, how is it possible that hazptr is faster than
RCU on the reader-side? Because a grace period was happening and
triggered rcu_read_unlock_special()? This is actualy more interesting.

Regards,
Boqun

> srcu                      20.0
> srcu-fast                  1.5
> rcu-tasks                  0.0
> rcu-trace                  1.7
> refcnt                  1148.0
> rwlock                  1190.0
> rwsem                   4199.3
> lock                   41070.6
> lock-irq               46176.3
> acqrel                     1.1
> 
> So only srcu-fast, rcu-tasks, rcu-trace and a plain acqrel
> appear to beat hazptr read-side performance.
> 
> [...]
> 
[...]

