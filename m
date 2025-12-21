Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 125EDD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 09:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B4E6B00BE; Sun, 21 Dec 2025 04:59:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8186B00BF; Sun, 21 Dec 2025 04:59:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1256B00C0; Sun, 21 Dec 2025 04:59:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4963B6B00BE
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 04:59:16 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF4F360624
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:59:15 +0000 (UTC)
X-FDA: 84243030270.18.B4C3678
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id AA9BFC0012
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 09:59:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BVlML/K2";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766311153; a=rsa-sha256;
	cv=none;
	b=C9RJk4TJgtSBiIi0KimfcuE9JBSINnQBDxmjkGk5PBrliQnHe0+TcTpDxLC3lBU85lQAtI
	fTgsnllMGCsuneuxDTNTeXZRhx9fGu5jgk7NMV/kFmqTTnEtDnYrhRo15tGRXrijNXQEA9
	dM40z5QAYnitwmA1wM4WZDHyjIx5f0U=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BVlML/K2";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766311153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjHwQCJ+WLLRT0TZamL7R6ZEjyOxsMVMPGjCn4Gr/2c=;
	b=Jem4FnQiJtUmdRj3yACXDUnrSlNeBleVNygCM9PQvGyIBLMJvChgXqfA8PFagbSEinevOc
	EesCZ8sX/WeRf8tpDwYn8IiPOTlERv5ON/a25x2cgHJDJ3lI88ZwMg4//o1hv07dJXxOQl
	WSwvULxjotgbHxcrK2yEtLejvxC/qq0=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4eda26a04bfso37796551cf.2
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 01:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766311153; x=1766915953; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fjHwQCJ+WLLRT0TZamL7R6ZEjyOxsMVMPGjCn4Gr/2c=;
        b=BVlML/K2BP5sKzz8lmDJQCgu9rIeIQWGFQFo2yg3ysmAWysbKPkZm5Bx+6tY1ZAIbi
         tQT14yML0V11nhDhobClxCAwl2kqD5A/j49/uelJQ2vLpo054UnUZhdLaZGHiWdFNn4N
         9EAm0wzmAleGYCr+ys5P5HwrrJQAxJUXyCfQsNs9h5Vb2QUOocpWxXNpCVXSbgg3INOK
         QYkS6h+K/XXQbarwXuyuMMcMrlvNctHHMEn+9FlW11xvTWrM1q6pdRqLEPZOXL+snYiN
         a5OPGZE/q6jbv+CZofc+8BnpH/bAUL/7B6DRQk9WAbOg09JU0t7YtOxvj+pFpwQnPqf0
         dgLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766311153; x=1766915953;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fjHwQCJ+WLLRT0TZamL7R6ZEjyOxsMVMPGjCn4Gr/2c=;
        b=t+Y86wVXV9Qr6GvJO9eFLJ8PSF79FYf4wwku5dtXX8PaneY9/kYztVw4AY22UAYYML
         cVWExDuacBrJ/sP86BroOrYskjyfP9HYlMV0cefxOSYcAheH5k5vNM+JqGS3raIkNu87
         0LmaJwvbh0NoOlY/E7fNOXGFnbff8aYI00jT9B54eH1go5kg42FwKvTx5Nvwn5HsiPkt
         N8BXG7wFLRSHROoqHRZjxDADbAvrw9N4CdECHEYXgsbB4Bhlum4setVRbbOK/1nkxqnk
         v8nXpKMXhYedJb44vZ5dJoRA+zVcKw3wTBSZxreEuOQEBcof8ntLpqMwbdAIWfzgNO4l
         BsFQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7cdQSv+g5j0TB1x1IMgpAK1DIbg04j3tEneNVo+Mc0mVDVu3Wak7qf50xB6ziZyqNJuOWcvrG5w==@kvack.org
X-Gm-Message-State: AOJu0Yyv+P7a9KaPYtH9oTEzW6zQy5V6wEE11aje/E6rCaObJAMoVrLs
	NMkl+NPuOlXVdUmMtuslJdm0iYpwtOEOcSjyO0frd3MWIHjkknNVDg6R
X-Gm-Gg: AY/fxX62DD/VYMPJ43JOvRLEzgxNHtGgrKClUL3l0aI5/cFcG/YrmyCCe2ts4FB50dq
	xeg6n2n54QKUb8pc4CPeCggbxf/CSICfY6ji4XwpZ+aHEXCouVgsjxk0xZX/7opJTSG2GDb09eD
	Xm953XgguyzgyakRbORyttOeWg9cL/XkytupoBYedlkMCsVZESFRrM26BMaDygimhy/eHikey5c
	5WDt3gIbdpw5vEDGt7DLkwpyQyvcrOlHbwImYnZmZ6co9IQa5t8ZLkmQFBIK/lM0R7qzOERhlFK
	cI0vXSOQOzroXwsLsrIZseES0W+shMTTEoGC1b+K+y3dkUHbf5eLF3/NZBXHgP1SOsrKpKiR6y3
	j585uSDEiSrpbWCp2CTUUy+z9SQ4WFnbL04ZNg7eil9RUQYVwkNs5jHitCtUGPFCw67v0+/QSJt
	Cr5p706g1/gr0ms7OzwvLy/3zRiIr81h1rP0RztQOLOirnlZNG5POkWuGQYaaAuJ4WiQB63HV3a
	qC8rHUJ/ctjy6Q=
X-Google-Smtp-Source: AGHT+IGkZ7YmQ4iCIVP39dS3Dspfdfd6jXXAiK+b4cBzlfzo3Zgdyb/boYNxk+mCnLQREZ4Jn+Teag==
X-Received: by 2002:a05:622a:250:b0:4f3:5346:5d54 with SMTP id d75a77b69052e-4f4abd78d8fmr113519801cf.50.1766311152615;
        Sun, 21 Dec 2025 01:59:12 -0800 (PST)
Received: from fauth-a1-smtp.messagingengine.com (fauth-a1-smtp.messagingengine.com. [103.168.172.200])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f4ac64e43asm54346251cf.26.2025.12.21.01.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 01:59:12 -0800 (PST)
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 06446F40068;
	Sun, 21 Dec 2025 04:59:11 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sun, 21 Dec 2025 04:59:11 -0500
X-ME-Sender: <xms:7sRHaR2N2v5QV0zS7rTjGaMTxsDxXqevcMfxDYvckKrndiHr9nNznw>
    <xme:7sRHabBBkyoml_p8QsCSVUISTOCodrotwwrFVf2B7-gdeQo-11qe60ozt8uJk-u0T
    HNU-gARi0H5n7K7phSZiFSuAiofuMLm0OKicd7-IEHjM0akskKMcw>
X-ME-Received: <xmr:7sRHaaFsv_hcs8DZVZClK1YuwwoTNd4iBxKqdxkoSNNA8ZJmsbqidfjit9pE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdehfeejiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrthhtvg
    hrnhephedugfduffffteeutddvheeuveelvdfhleelieevtdeguefhgeeuveeiudffiedv
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghoqh
    hunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeghedtieegqddu
    jeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomhesfhhigihmvg
    drnhgrmhgvpdhnsggprhgtphhtthhopeefvddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepjhhovghlrghgnhgvlhhfsehnvhhiughirgdrtghomhdprhgtphhtthhopehmrg
    hthhhivghurdguvghsnhhohigvrhhssegvfhhfihgtihhoshdrtghomhdprhgtphhtthho
    pehjohgvlhesjhhovghlfhgvrhhnrghnuggvshdrohhrghdprhgtphhtthhopehprghulh
    hmtghksehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhes
    vhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehnphhighhgihhnsehgmhgrih
    hlrdgtohhmpdhrtghpthhtohepmhhpvgesvghllhgvrhhmrghnrdhiugdrrghupdhrtghp
    thhtohepghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpth
    htohepsghighgvrghshieslhhinhhuthhrohhnihigrdguvg
X-ME-Proxy: <xmx:7sRHadqKf0RTS3nOePlAQvUozbdkH1E35MAQvZyfuG_bq4zKpklFew>
    <xmx:7sRHaS1Y2epauX9OBV-y9l-R-Zk5Fbd6FmY3INiJFgdckMvEcL9nFg>
    <xmx:7sRHaRAPbAze_26JzP05OzQKeAn06Zg5nMbyWgmetanI2Ftb88lQ_w>
    <xmx:7sRHad_m279CbYEdXqv4sqfsQSdM2Z_3F2PEOvAtMVxacM33U0ReiQ>
    <xmx:78RHafNWcaktLFSnepHDt1H0rFJluyVrCqzHdfbKcufE0b2QeG9VpLXk>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 21 Dec 2025 04:59:09 -0500 (EST)
Date: Sun, 21 Dec 2025 18:59:07 +0900
From: Boqun Feng <boqun.feng@gmail.com>
To: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,	linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,	John Stultz <jstultz@google.com>,
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
 rcu@vger.kernel.org,	linux-mm@kvack.org, lkmm@lists.linux.dev
Subject: Re: [RFC PATCH v4 3/4] hazptr: Implement Hazard Pointers
Message-ID: <aUfE61t5cITwolX7@tardis-2.local>
References: <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
 <aUO9KRaP0FXpm_l9@tardis-2.local>
 <fcbc99d0-b7c7-45f7-9cf8-f5d3bfad966e@efficios.com>
 <aURihbmjsKi8m7MO@tardis-2.local>
 <42607ed5-f543-41bd-94da-aa0ee7ec71cd@efficios.com>
 <aUSbhiMgluudbVEG@tardis-2.local>
 <edbe45b3-0f85-48d2-8d4f-784781a8dee5@efficios.com>
 <6353feeb-c2ab-4ff6-9ea6-04ae5102641d@nvidia.com>
 <6b27f3c3-47f7-402f-aa6c-b564e3db1d6a@efficios.com>
 <38d05c17-c28e-4ec1-be30-e77fd7015b5a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38d05c17-c28e-4ec1-be30-e77fd7015b5a@nvidia.com>
X-Rspamd-Queue-Id: AA9BFC0012
X-Stat-Signature: a37a6bfufwydciu4wyg6hz64znfzmtku
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766311153-720959
X-HE-Meta: U2FsdGVkX18fHQqRmRmy+h9D2YX3uUpMI5R+lHrO/donAAZAqW2xQKHP15pKBUnAnm36rVIVG7MFbZPcQDcnPAn8aqZKIo+YNZ6Kz+J/x2IeUuZjssFnuOEtFR7mhX+yLtkKwTYjD2rygr/9HbWKnNkGLzZ4O0EkgQe0fDKYCWyGB2jdom+Gl5SBYYGwfppWDD1a99222qw1AUtflKT01HhW9xZlumm2uBOAQdQc9cEWVpC81AFxkYJ8b3jpGFeElfwxf4aZUMbBtbUdrpnzgbRcv6zEX0JMnLnLb7ns5EKMWVQQZUXG9XPdt6NwryXWAEosY13p+lDMc3ljjK6Ds5qRVf7oBofIYPTJNHF9UIw06Y+B043YAQMB0s4JiG9j5S7/bRPIA+ie0Cm80QsFFoj4oXX/in7mz41yXQD7l65acfNgYEWD8MJRSgMfZsXeANJNYi7oDco06raMd2yZpdV3UnBmHqB4orL6eRhTqDVTypN6mcX5M9ynN1YnTwvO+0Z4XvrkDASnbHcEq+apt/cuWsqRhKeL0MQEx8JA1D0lopWN9qR4TkGrQF6+RD5DLn3a1VK6caOZeixluzfBqeNPRgxFE228BoP92QoIyEWTvx8/hNUeLZH/slvSYVOxD2+LkgSAwlcmsfU6sgf32ib2705ViShXF3l49FkGMDPsP8haDSNiwXg7K+U4GuYT3tRfB+rU/Flg8GurqD7PAj0X+ky3IsM12tg8KdoV3HUDNFmOKbWJ/4rZaJ2bMW9SDpv37qBrQBDoU4ALjieduruMaeEK0XhK7lfZL2m6hmntZ5wwfqd0FVqAHQcmh/62eSKKHA3un3KLHODSwc+MTsimkIMOrHE9LvTX/BrNcgxUPeBg+3leKlSn2Ar+7DwWuLetUkMEdlVXURpiN8S6qqC9ctIP/Oi7jLhUAtU/P6w7Tq/yEqqZX5NYURiMd2vKpCwCOk79iARZcp/wfk5
 q5Shvdl2
 /ePYddsBcKdufjRfA+OI+sEPx8MwG93zuaDrstOyTH6Toth2qJT5rCSP1jj9qrHUmvJ7zKjFMWZV5Tb9zCr++/GeRuGgfZN0sXMrNPH+KDcnq2QaLjk/wFo0xkJfuN9gWtu0c4Zto/h7Y4Lal60t4xXuPwd0+q9AAUk1V8ElvYcYRxBxJX8S9qwy47yNCDFgZubcWhhkXKym7Y74VCTPyhk+dpWcvyUg+hUCVPsPj1aEdQ/gxnbM6K3FDCTaBnzQq0NXvsJPbkqi6/oQXOjQ5amVUHj88zUCnl43pxFdUOwt7JOAYXVf3P7G+kedpKcTF1yBD1kOntG2T/3AsMG44K6SyBmdDgedkyd4StKzca5Uh9ziUYAxnqBSkM21B9C30+UjuNAAa495ydpIvaHjLG6EogVDmH8t3kmT8P/jVQvMUZ7lnqHnizReHkvRRS235GXro9C9QYO1A7ukFsIOyPHmuq23vdXvYct63RTWLcFqRzZVc6DrPoXUTJvkY9TQwOGa2muK6kUDOvrU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 05:39:00PM -0500, Joel Fernandes wrote:
> 
> 
> On 12/19/2025 5:19 PM, Mathieu Desnoyers wrote:
> > On 2025-12-19 10:42, Joel Fernandes wrote:
> >>
> >> IMHO the overflow case is "special" and should not happen often, otherwise
> >> things are "bad" anyway. I am not sure if this kind of complexity will be worth
> >> it unless we know HP forward-progress is a real problem. Also, since HP acquire
> >> will be short lived, are we that likely to not get past a temporary shortage of
> >> slots?
> > 
> > Given that we have context switch integration which moves the active
> > per-cpu slots to the overflow list, I can see that even not-so-special
> > users which get preempted or block regularly with active per-cpu slots
> > could theoretically end up preventing HP scan progress.
> 
> Yeah, I see. That's the 'problem' with the preemption design of this patchset.
> You always have to move it in and out of overflow list on preemption even when
> there is no overflow AFAICS. My idea (which has its own issues) does not require
> that on preemption.
> 
> > Providing HP scan progress guarantees is IMO an important aspect to
> > consider if we want to ensure the implementation does not cause subtle
> > HP scan stall when its amount of use will scale up.
> 
> Sure. But if you didn't have to deal with a list in the 'normal' case (not over
> saturated slots case), then it wouldn't be that big a deal.
> 

With PREEPT_HAZPTR, the overflow list will be used if a task gets
preempted while using hazptrs, without PREEPT_HAZPTR, the overflow list
will be used if there are more than 8 slots used on the CPU (most likely
due to task being preempted with a hazptr slot being used). Therefore,
if this hazptr design it to have a few users and we want to support that
preemptible hazard pointer read-side section, soon or later we need to
resolve this scanning racing with readers (in context switches) on
overflow list issue.

Surely we don't need to have something perfect in day 1, but planning a
bit ahead won't hurt ;-)

Regards,
Boqun

> >> Perhaps the forward-progress problem should be rephrased to the following?: If a
> >> reader hit an overflow slot, it should probably be able to get a non-overflow
> >> slot soon, even if hazard pointer slots are over-subscribed.
> > 
> > Those are two distinct forward progress guarantees, and I think both are
> > important:
> > 
> > * Forward progress of HP readers,
> > * Forward progress of HP scan.
> 
[..]

