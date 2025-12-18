Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BEB4D711C7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 22:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D37B6B0088; Thu, 18 Dec 2025 17:16:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6572A6B0089; Thu, 18 Dec 2025 17:16:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50DC96B008A; Thu, 18 Dec 2025 17:16:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D94B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:16:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7383A1A035A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:16:45 +0000 (UTC)
X-FDA: 84234002370.22.2FA86C3
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2A59A1C0014
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:16:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Iw4FFmq8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766096203; a=rsa-sha256;
	cv=none;
	b=HDuqai0RjH3CuIed4uvKm2whcc20gRMa3AkGsrtqwpaTF/WI+KzLFE1nNhhc2rOv9Yqlv1
	vKvNI+NBRRFYCOPBLP0bGKHkAQcNkyORrNNYGxQNdPTC3OGt+9ipV8LwXWqUAcRI198gnY
	kggNFPe8v7MkIPuhix35G1W3FpHDbc8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Iw4FFmq8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766096203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sXHinIvqqn4NKYj3YLqEcLxxqdNblij/w/+MvNbYRQ=;
	b=Uzynq/6BBPN0tmRRzzx69bYrY9tPh5NiqKLmUEZwnvIu/aS7bE0L8j8Nktmns0HPnap7kt
	eAlCVMv+8uXPMkG7OJTXzVRfGnuE1RGOmZhvrc5LceRyeQUblOTg74nCiKDAF3a05VfepR
	MZBb8Jso0Vn37lFci5hIcdySqyZDgsw=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-88888d80590so14731886d6.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:16:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766096202; x=1766701002; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3sXHinIvqqn4NKYj3YLqEcLxxqdNblij/w/+MvNbYRQ=;
        b=Iw4FFmq8NVYlTuHTP9LMC0MlzBVZdKu4LsD4k+TK8sUjh6OMgjmYZPB2IEbQKsoARv
         wcCh2UPgUpRkmV4sPKEF8ZVc3urufnGx3d8wG2j5SkLNrcUYJ9vGZiQZAiYW1taC9OSn
         qMms0mxzknrXmBsmm4ngfaNN/3tlQwV+NK+z/qYIF530L337Il1qXOEY7cwj0mbUOL/q
         UDoglLaa5yr2evPrYWITqNYtyVkERmyQj8wg8I+Rz9/Hwu2/sY2EzcB+YpPz54Bznh9H
         0Vdy5UZ2OKv8E9r3etSzGBWw4gUjdPf2kg9Zb4t5sxu/iysSdMHhLvgI3KCz5jwD+Dgz
         LNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766096202; x=1766701002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3sXHinIvqqn4NKYj3YLqEcLxxqdNblij/w/+MvNbYRQ=;
        b=e8zNvcZpuv7+X/4d/QsluAMh9EnxfAq/AcMNunw7fxrHjvFUKNx9XwZl5VsMMLFEki
         HxOS7mIGDUXDcAdju6Z3FDAboSEI+tvMml28FBkc4EfQ/7d2SoFgZ1RS5iv2GWQac3wR
         OtkvNzdFmxTTxYj+GAzsfcrPWrphP077jG//50Q7uvQPFYc++Yrl5Pe1JQH+3hKjEIkz
         LJszT4S122WJyRy42w8/p6+EK7l5twg1T0ISa5Z3D2uBUMmKw2HF0PNi36Vd70ufWNKj
         YCXekzRBeQRTWzRaK6K/Mvt+f0barHb6PqNrRz/aJrRhhaiI6S8k5Jm+pu8lzeMHVb8B
         qlNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVthHKzpeNMcanQBZS0auMZhdwybtXELeUIeowBr8pOIvGsG5m2XxksmE9YY8jZBAm38APWiSWh5g==@kvack.org
X-Gm-Message-State: AOJu0YwnfNcfvLqWDtcIagwYoge+1KH+vu6TlZ3Yp+5stMdnp/WL7nbR
	R7p8kMbJ75ezdfPJjmdOvQEo0GE3Sp2gTctwO8C9fXikBCssGpyd6hT0
X-Gm-Gg: AY/fxX6A2jOh7KaotYwNv8H7fq7byOgNeiphDQ432BoeMh9CkLW/O9eMqtDpcl8tB42
	1KWcDutAY9WIRrHB1BZsCvq3/wEZfPc8GE9CtA7wUR0v5gWdi68DcI1L+LR2rjsvLGfADp+dI9t
	WFEjxkta0AjjVIScH3DtZjSTUQSwDa9ZOH4a3x/cGJqa9fvQPLhu7yljlKiOKMqzlYRLbq9BAz+
	rOj7dhDz1Ujvvi90p7Bs62yxaoRfoXs/03g5CWXPbwQSQ3GLodsOhNZ+ZvDtknJ8ZpDQnoqoa/L
	REdZTgEfOv8I8tGH5zbou3y89hu7bEu9TSpwONPxbAFQt+ZCo0wZaCXnyEQPSQh0MiJ9NryCsNO
	aBr5ea/KglqRkjQ9XhlaWrGryiDQAREEG9jPMpL0+IIGx7wCtYALw6VRhZHcxA8MGNtjKNwXPDr
	E6nsVKL5ZdP+RuMFuagQYDcf+Ul5BemCIR3D0/RBnu9WDNtj6hQLRiug7luzqJMHo/WKrm8QNZK
	Yh+C8GNvPuudPk=
X-Google-Smtp-Source: AGHT+IH9dlus8CLBnccpPwM7k0azGKuifjOTEiDe/F0ZElbIptxHmkvJntfFb5aH3wD+BBl6lym7+A==
X-Received: by 2002:ad4:55e6:0:b0:888:58e9:fda1 with SMTP id 6a1803df08f44-88d851fd95cmr13819516d6.14.1766096202075;
        Thu, 18 Dec 2025 14:16:42 -0800 (PST)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d997aeef5sm5249626d6.27.2025.12.18.14.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 14:16:41 -0800 (PST)
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id AA726F4006D;
	Thu, 18 Dec 2025 17:16:40 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 18 Dec 2025 17:16:40 -0500
X-ME-Sender: <xms:SH1EaZcr4nosz5Z_u80KXr3YTuBVa1KzutlGezTRHSDZs3vGJkkjOA>
    <xme:SH1EaUVPH7FAjWPnxjlkT6SOQdM1MN3G4pmjPM7rEFGVXaj797cdyQ5pHlryNlzxO
    VVPAdSNKmeWi9A_l2pblsDmpQTl9iH-oyauJMf2dWNjj8KWqT1ByQ>
X-ME-Received: <xmr:SH1EaS-mmRPmfNgvg_LETVK0X3GxPc8Ju8gr-cxm8qbpQU35_qsy-_unMKTt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegieeitdcutefuodetggdotefrod
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
X-ME-Proxy: <xmx:SH1EaT995_TeAJ4-63c4V7xKFasqvDak3J-igt9puhk5brWv5ylc_A>
    <xmx:SH1EadWoyqZsWXiMN5K-uDQ0qYQ1TUjy-3UEAJTDVukr5CuxkvA59g>
    <xmx:SH1EaYbSjUFJ67X-225Ef0HegXoCvjFb2nSB95hz5Zynp6lYavMa3A>
    <xmx:SH1EaXrTNm6EN-1Jchzt4W1vY9_BIcCtY-RjJ8xXdv0SKAXGMxtvYw>
    <xmx:SH1Eaf5et_nD7VWPecEOioNTVhm-onsV73utDC78UeHLz4tMAvn8XfBk>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 17:16:39 -0500 (EST)
Date: Fri, 19 Dec 2025 07:16:37 +0900
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
Subject: Re: [RFC PATCH v4 4/4] hazptr: Migrate per-CPU slots to backup slot
 on context switch
Message-ID: <aUR9RfVChdcDncwX@tardis-2.local>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-5-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218014531.3793471-5-mathieu.desnoyers@efficios.com>
X-Rspamd-Queue-Id: 2A59A1C0014
X-Rspamd-Server: rspam03
X-Stat-Signature: e56gcawtoibr7h5xo5wjtdmkxybyg9xf
X-Rspam-User: 
X-HE-Tag: 1766096203-211231
X-HE-Meta: U2FsdGVkX19Jewmkl2kt1k2v1uDbgH02isgwtJ47+Ov3toW4fcg75Y+vmGKXdluRw1CgHLswDigeMQRExiw8As1N/8oaDXmjmWJuHA6oN6AiR5a/xdlEsyWtFUhkHPVGEBW0wPFrVFLfFyQTlyNbbpvZFdHVgYiGdTjkAGfjgyWyQK/9yrvNJuBqACf7RZWMzSK+ThBLw+rxlX9Jupi9mclK/Gx5M9/Htk6fM5w6xz8sVrs7KWlM4rQZEKhqCr0scFjOJjMuwu8dOXxehP6GT0nJkIVhl4sbvvwilEf0WnbvRvp1kjWp++17uNq3AwbMcpPJqNwx2QR3JxeMatiKMRxJq3RHBls49svyjYbS4VZ2bjZr3XJagOIJGA8lN9dr+sZ2nIz3BvD6gzzxHNbzmPDq4gz6LUelZsQCG1tDfSqnMlmZn8/7u86dZgn1BJ+4q/epfCMsj88mBoX0ySHUWi3N+mf3NyHZHTsBCtwWvsR7j7QCKLk0tWdXyET3qu4zeNtjOAST2rc6VX6n2jhQIGygt/3iP2zH8h4KJ4xRYlLM7LGh6lnhYsplkR7xmf4Sm5Cyia+BzFiAltej/W7oFlSE9f38DGrOdl4sstNugyctEBKkGssF7YsovhICyI3htHLNc0n6twXswE9Se51q8WmSuylPI/XIuGcYPZjPXty5nQDlLwObhpLzwCPn9IKyeZdq4/qzS/ON3L7UuMPo4Qa+KkyOHpS9jZpd9aNJrzBoijuINwfPGV6+aPubPfa1iyrJtgnO7dO1SP+r4/5OSghjElAB5WdY+sY4TOGeXqZOfM9+9CF556uUGGB4eR+uhwTTpHWSksnjI5nrOkMrX/ONsktuiJwqMjw0stLBCO1TOFbzNGu4BFRgwZQYIh2t22Y3AyGfmNgRGcSFw5fvGkwsL8oKVLY1GruZyOphjVc4qN9vSEc6e8dpLRcXq6lTTidawATZidC0zj9nvqM
 R1f3Jo6q
 FmXcfZJN5YjF+NJ6w6vwXdVY/v+b8QnpXttuA2dnOxVLzYtkMFMsnXqHEep721Zfh+UBSfggtptwxE89oVh7rBQ4zVZwKCAnEknBkPJSo6Ir2w/8vwq/FoZ24q+P0pjajkVT6wQlDqIb8sKow8TXzLnEvjqzqw1aREzbz5dEhK3/IH4KoZEvv5l9+CoWAYcsmKgTWN33BP49q+1IURkNc8EO4zbCy6u5X0of6wph1vXwo+dHukd8wb57dsVledfd0JgQtpam3/VbuU6M4qp6ajUT2qHBWtdt5PsqynLVCQppLE81qstGFVo1VVyyNSW215hU7ll+nfMtwLKQyzCAaLtk+W4ibhHz9fhYKGAo0u1BrFebKFTf2DHnAnnbPkMjjSQDeXTL+zns9kaZh3QgXTNXSk7F2ocwpwkSjBT2AxOAiHo+Ol1leIJ7YScIvrdWkErNp7/+pn3KXssSvG4+DjCHr2haKYiCDpknnTEHURshWEl2AzWygkNAdS1jkpR446Ps4vugLC8ASF2QErta/8+N/Mp5LRrq/E+KeC6ZmgwnPv25WLzvquYQfHROdYzq4zZ/95cJ6lDMKlzC4cQOJxWhtZfzIImdBM3r6jrFeNpPb2IkGBpp2Vcb1T59b/SlC+Q3i48caJKTokQXHbF87Q5AEiEMbMUGlXOKnzVm2teuzB4rGfN5eWx3PNQVH4KLUtc+acBwJwDy76ieRDpfKP+eu+Ev+jfvHwI4XAZDwjIVbgKWD/dUkfGUHsuS/wyXlsJHCQZL0TSu3IIog7iCrwkqkxSxczAhkFqlo/w/s2Gc+UHDrOaPdKDdGzDRr/mkUgTb8RRkbRqDNHeXe7LiHwTth9/oVkmMD++UFgj3uE3dDCw9lB21QzTwrz+GLfs6tJyM1XMIXdfBt2yddYUbTKX6yhTVLzOY6GgNl6CeZ1pERSmJdp6M+c13NQOIdjeV+fvk8f4E1Gc8nFUyTNLsVkMLw1kW1
 cVJWQSPj
 tN8tpFxCAyIxPmPH0ug8oKnnFZSMrUixtOmkq3zKOM7iXlQNT7M1qyjDYeCci8a2rtpB5Ux58CMG1rjv+kRexLSipyR1NgkBVz+TSBEVzNk7b4GMYo+/Xfb4rHFOADCnZCgF6+vRpY4HjLKA7Yh1MQGECcaAJYe99reHwQ2SGqnfZCE9++jyz6sKDKTESuZh9VNbfJltDM3hZ9N5m1hsTU/wOfwyc7TK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 08:45:31PM -0500, Mathieu Desnoyers wrote:
> Integrate with the scheduler to migrate per-CPU slots to the backup slot
> on context switch. This ensures that the per-CPU slots won't be used by
> blocked or preempted tasks holding on hazard pointers for a long time.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Will Deacon <will@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: John Stultz <jstultz@google.com>
> Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: Frederic Weisbecker <frederic@kernel.org>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> Cc: Zqiang <qiang.zhang1211@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Waiman Long <longman@redhat.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: maged.michael@gmail.com
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Cc: Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
> Cc: rcu@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: lkmm@lists.linux.dev
> ---
>  include/linux/hazptr.h | 63 ++++++++++++++++++++++++++++++++++++++++--
>  include/linux/sched.h  |  4 +++
>  init/init_task.c       |  3 ++
>  kernel/Kconfig.preempt | 10 +++++++
>  kernel/fork.c          |  3 ++
>  kernel/sched/core.c    |  2 ++
>  6 files changed, 83 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/hazptr.h b/include/linux/hazptr.h
> index 70c066ddb0f5..10ac53a42a7a 100644
> --- a/include/linux/hazptr.h
> +++ b/include/linux/hazptr.h
> @@ -24,6 +24,7 @@
>  #include <linux/percpu.h>
>  #include <linux/types.h>
>  #include <linux/cleanup.h>
> +#include <linux/sched.h>
>  
>  /* 8 slots (each sizeof(void *)) fit in a single cache line. */
>  #define NR_HAZPTR_PERCPU_SLOTS	8
> @@ -46,6 +47,9 @@ struct hazptr_ctx {
>  	struct hazptr_slot *slot;
>  	/* Backup slot in case all per-CPU slots are used. */
>  	struct hazptr_backup_slot backup_slot;
> +#ifdef CONFIG_PREEMPT_HAZPTR

I would suggest we make CONFIG_PREEMPT_HAZPTR always enabled hence no
need for a config, do we have the measurement of the additional cost?

> +	struct list_head preempt_node;
> +#endif
>  };
>  
>  struct hazptr_percpu_slots {
> @@ -98,6 +102,50 @@ bool hazptr_slot_is_backup(struct hazptr_ctx *ctx, struct hazptr_slot *slot)
>  	return slot == &ctx->backup_slot.slot;
>  }
>  
> +#ifdef CONFIG_PREEMPT_HAZPTR
> +static inline
> +void hazptr_chain_task_ctx(struct hazptr_ctx *ctx)
> +{
> +	list_add(&ctx->preempt_node, &current->hazptr_ctx_list);
> +}
> +
> +static inline
> +void hazptr_unchain_task_ctx(struct hazptr_ctx *ctx)
> +{
> +	list_del(&ctx->preempt_node);
> +}
> +

I think you need to add interrupt disabling for chain/unchain because of
the potential readers in interrupt and then you can avoid the preempt
disabling in hazptr_release() I think. Let's aim for supporting readers
in interrupt handler, because at least lockdep needs that.

Regards,
Boqun

> +static inline
> +void hazptr_note_context_switch(void)
> +{
> +	struct hazptr_ctx *ctx;
> +
> +	list_for_each_entry(ctx, &current->hazptr_ctx_list, preempt_node) {
> +		struct hazptr_slot *slot;
> +
> +		if (hazptr_slot_is_backup(ctx, ctx->slot))
> +			continue;
> +		slot = hazptr_chain_backup_slot(ctx);
> +		/*
> +		 * Move hazard pointer from per-CPU slot to backup slot.
> +		 * This requires hazard pointer synchronize to iterate
> +		 * on per-CPU slots with load-acquire before iterating
> +		 * on the overflow list.
> +		 */
> +		WRITE_ONCE(slot->addr, ctx->slot->addr);
> +		/*
> +		 * store-release orders store to backup slot addr before
> +		 * store to per-CPU slot addr.
> +		 */
> +		smp_store_release(&ctx->slot->addr, NULL);
> +	}
> +}
> +#else
> +static inline void hazptr_chain_task_ctx(struct hazptr_ctx *ctx) { }
> +static inline void hazptr_unchain_task_ctx(struct hazptr_ctx *ctx) { }
> +static inline void hazptr_note_context_switch(void) { }
> +#endif
> +
>  /*
>   * hazptr_acquire: Load pointer at address and protect with hazard pointer.
>   *
> @@ -114,6 +162,7 @@ void *hazptr_acquire(struct hazptr_ctx *ctx, void * const * addr_p)
>  	struct hazptr_slot *slot = NULL;
>  	void *addr, *addr2;
>  
> +	ctx->slot = NULL;
>  	/*
>  	 * Load @addr_p to know which address should be protected.
>  	 */
> @@ -121,7 +170,9 @@ void *hazptr_acquire(struct hazptr_ctx *ctx, void * const * addr_p)
>  	for (;;) {
>  		if (!addr)
>  			return NULL;
> +
>  		guard(preempt)();
> +		hazptr_chain_task_ctx(ctx);
>  		if (likely(!hazptr_slot_is_backup(ctx, slot))) {
>  			slot = hazptr_get_free_percpu_slot();
>  			/*
> @@ -140,8 +191,11 @@ void *hazptr_acquire(struct hazptr_ctx *ctx, void * const * addr_p)
>  		 * Re-load @addr_p after storing it to the hazard pointer slot.
>  		 */
>  		addr2 = READ_ONCE(*addr_p);	/* Load A */
> -		if (likely(ptr_eq(addr2, addr)))
> +		if (likely(ptr_eq(addr2, addr))) {
> +			ctx->slot = slot;
> +			/* Success. Break loop, enable preemption and return. */
>  			break;
> +		}
>  		/*
>  		 * If @addr_p content has changed since the first load,
>  		 * release the hazard pointer and try again.
> @@ -150,11 +204,14 @@ void *hazptr_acquire(struct hazptr_ctx *ctx, void * const * addr_p)
>  		if (!addr2) {
>  			if (hazptr_slot_is_backup(ctx, slot))
>  				hazptr_unchain_backup_slot(ctx);
> +			hazptr_unchain_task_ctx(ctx);
> +			/* Loaded NULL. Enable preemption and return NULL. */
>  			return NULL;
>  		}
>  		addr = addr2;
> +		hazptr_unchain_task_ctx(ctx);
> +		/* Enable preemption and retry. */
>  	}
> -	ctx->slot = slot;
>  	/*
>  	 * Use addr2 loaded from the second READ_ONCE() to preserve
>  	 * address dependency ordering.
> @@ -170,11 +227,13 @@ void hazptr_release(struct hazptr_ctx *ctx, void *addr)
>  
>  	if (!addr)
>  		return;
> +	guard(preempt)();
>  	slot = ctx->slot;
>  	WARN_ON_ONCE(slot->addr != addr);
>  	smp_store_release(&slot->addr, NULL);
>  	if (unlikely(hazptr_slot_is_backup(ctx, slot)))
>  		hazptr_unchain_backup_slot(ctx);
> +	hazptr_unchain_task_ctx(ctx);
>  }
[...]

