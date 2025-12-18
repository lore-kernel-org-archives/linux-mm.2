Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 747FED6ACDE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 10:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC9CE6B0088; Thu, 18 Dec 2025 05:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77E26B0089; Thu, 18 Dec 2025 05:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59416B008A; Thu, 18 Dec 2025 05:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B09AF6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:29:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 536FF5D573
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:29:51 +0000 (UTC)
X-FDA: 84232220982.25.5952FA3
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1F09540005
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:29:48 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IdVkes0E;
	spf=pass (imf04.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766053789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MJlukGe2XKQfRTopvmsYHxe3yWp3t9uPRnCG4ocU9Wc=;
	b=vuBH35J9Q+9rWvVPf+19ID0VLbpNYzTvz5NhuKJlt7MaRc/lATGOYzYakytvlsOU6nlTKM
	g0oNfTPoLZRmM3MdgeT23UZqHW5V+T1UY97BGmP2kO12XozMOckbUjFp9rwTLXBCe99/Vx
	rTCaIqMobb6oseiDrhGEA5+dj1RakHw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IdVkes0E;
	spf=pass (imf04.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766053789; a=rsa-sha256;
	cv=none;
	b=RqAE6ykd+biVfCO9jhz/TQRg96EIhHYfR16zpdzf1jLOPP02a7WuX6u+vM4QgXS5yVCQFb
	gtmoizPLk6v824k2Wwc5iLVIwkkXgBw1T5LHrUx3iOfLmsO9OjgGJ6OtZGwrrliHj052/e
	K92lvqp4cSImLkyUnm5JJoSfwEHRUng=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-888bd3bd639so4959526d6.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766053788; x=1766658588; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJlukGe2XKQfRTopvmsYHxe3yWp3t9uPRnCG4ocU9Wc=;
        b=IdVkes0Ey/Vo3VWIy8kXEGtAsINf64o7XNrrMrx9YvrbnS7AVNN+2SjpvYUtMV5Pks
         7i9zns8BVyTEIqVK7HLlQOLDgoNQWs6DefsQaLr7FYwOgjCi3YOHvZmUyCkYe+93rMBT
         3TqAeDKJSPRt5pSvUmt6gGodYepDhBu2GbEEtfHHDycGbM8iTyFPCFu5u0Qe5bcbWGIC
         eWLP4dwVhiFE5nGb0c+h0MxwnlIBDkNb1oXkRqYLUuCVMQPWKI0sfTBoYTbhtNs32kSD
         K5O3Gq4QtKAhNo2BoV1QWSpx9Aj0826h0NQ4A35Hay7NnRiFc1flRRXd1xVhiqVO/LtU
         DSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766053788; x=1766658588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MJlukGe2XKQfRTopvmsYHxe3yWp3t9uPRnCG4ocU9Wc=;
        b=tGFDWbRB1CHLx38GJmu4uutdWzfztaYBarS/r1g3sQDzQm6fpnDwRjzYXz0K5AGGMb
         qnfv8NAnw9//B3Z4+zpDl+UDWqQAjDiRD52I6OYcWE4L9O8itj1p/bP1wQ1bmRTpffQ7
         H3YS3mmxsFs7EHzyvLfKhAliCYRSL5j9AkuNA72I65lwLxZ2EthhACnzIXuxqdaMimdk
         sGFhmCSnUIr3PlYSPiWFkPS7pAvWNKHk+6Z6Vsw39ppswcgvxIzDwrshAajR3BfTpy5T
         C80YMENNx5Mhwgy4tpQ5vkF/A/VWZY3mn3JjuUaUrKZNQOxzpIZmweOuYcAzQzt39MQQ
         m+eQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyMNGhgfINWrjniS/z1vXZf4dWxa4JnFHZvSqsAuldyML6SNUEB4TN/0AOfxHa/3hNgjVKPh9EyA==@kvack.org
X-Gm-Message-State: AOJu0YyA7cbaWeDPwAt2MLLRthq4aiQGtbo0ISHOAC1cDCuXb+OHuGhJ
	TAepIUwY3cQs/zX7p80Kn8CsaBHMG8LPK+f0BOUkJu3og5zrtgEwWJNW
X-Gm-Gg: AY/fxX5bMCZYHzt/YmhSm8Zll/J70+IICeW+rPNOowH8IbZToYyaR7IMR80DX+NAiMk
	zowldWbgkqbjeSOXrXunHkfBenBbuIHxMenFIRPsRs+QEaEmGumJ5EcIzEGVhjvsosoke786LNT
	s36IPRBc3KW38zJnKON4YJhiW5NL0RJgDqaD9l3B3sfGsMjUX817tHNyT3r9vVniE+tlxUJyD0C
	tAI1zCl/lCFooj+4TLmPXILtsObYPnWbHJjS3KZF9wiznjdyGabUaU1whA5urL/wczH8/aB0wU3
	c30DfJYEYuL3jDzqcSoSH3jG/nh2FvMMhbMzlOAXfxFfhR/IS5umJUEbZLXOlrJoYaooendJD0Y
	0Zb6L8cJ4cffmHt+LJdA/d5eTERIuVNAbqrTQeIk30Irlxe0YLmyHQ1ATMXH5aagKFkWdgisGvF
	bUdETTuNghsIpw9EaUk2ZkF5JEzHhZ4i5Lhh6Hw2oOW/0vJ+oKZTHyosYfhFtxH9vmWBmxfd+8v
	3wlUoSPKVcUDABFsi1awp88Ow==
X-Google-Smtp-Source: AGHT+IH+TwsnAFhP1xQ+6J09p1YnquJxQF22NSdtr8d1wVnpvOYLPTtrp6BsTCMIvWuluMWUsctcHA==
X-Received: by 2002:a05:620a:454d:b0:8b8:7f8d:c33d with SMTP id af79cd13be357-8bee79e244fmr303524685a.45.1766047022651;
        Thu, 18 Dec 2025 00:37:02 -0800 (PST)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8beeb5d5fb7sm128786985a.7.2025.12.18.00.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:37:02 -0800 (PST)
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5FBEEF40068;
	Thu, 18 Dec 2025 03:37:01 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Thu, 18 Dec 2025 03:37:01 -0500
X-ME-Sender: <xms:Lb1DaeuxRH_5bPEcXeOn7DaCVUW1U0pAGUTwS0VKj1gCEZkZ6wurUg>
    <xme:Lb1DaQ-TjOZIozrgLukNb_thiqu0uQzXGBLB5Lp9rDvq7_5ruk1Y7hhhD8IieIt68
    8_-2rQPASmTVBW9XvvetqMz8vokMtwyn3zwCbGIr162dNpU2J5g>
X-ME-Received: <xmr:Lb1DaV0tQxRVC4p9LDovx9IzQtQSKy3UeToLuabGwIvov42tTET37kTjXTds>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeggeeliecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrthhtvg
    hrnhephfetvdfgtdeukedvkeeiteeiteejieehvdetheduudejvdektdekfeegvddvhedt
    necuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvg
    hngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthhtohep
    feefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmrghthhhivghurdguvghsnh
    hohigvrhhssegvfhhfihgtihhoshdrtghomhdprhgtphhtthhopehjohgvlhesjhhovghl
    fhgvrhhnrghnuggvshdrohhrghdprhgtphhtthhopehprghulhhmtghksehkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehnphhighhgihhnsehgmhgrihhlrdgtohhmpdhrtghpth
    htohepmhhpvgesvghllhgvrhhmrghnrdhiugdrrghupdhrtghpthhtohepghhrvghgkhhh
    sehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepsghighgvrghshi
    eslhhinhhuthhrohhnihigrdguvgdprhgtphhtthhopeifihhllheskhgvrhhnvghlrdho
    rhhg
X-ME-Proxy: <xmx:Lb1DaWfGiBHAmTPYAevQ_wEFZMzzpe3ny5LHzAujMIFfpOjhO4w3Gg>
    <xmx:Lb1DaReFSi5kMZarEKuRO4VbN9q4bBzo-U6Ra1uquqvgF3y1UKzUWw>
    <xmx:Lb1Dac0PIZqbUws6P8df74Kbt5CuaCYOxhdt87ywXond2zyEitzjJw>
    <xmx:Lb1DaR56enoIcPkvmaTCGUaxmFxRR0KH9c28Hnemo5llICrfvWamzA>
    <xmx:Lb1DaTK_rJkYX-qFPNr4wvprOlNlu3LKtTQfZpL6DFMn9O-N2JshU6U5>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 03:36:58 -0500 (EST)
Date: Thu, 18 Dec 2025 17:36:57 +0900
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
Message-ID: <aUO9KRaP0FXpm_l9@tardis-2.local>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F09540005
X-Stat-Signature: 8nisyo9pamw3fwrkux59ky4e98zfoe4d
X-HE-Tag: 1766053788-219465
X-HE-Meta: U2FsdGVkX197rfJOLze7xVebMwaRGjl5Uw0Nqgmk8u+fxQTveLQ0qG2Ndkl1/0nKASHulEdu3jLgy8P2KciplM7ZaFs/fe4pilpqSIphfcDF7aIa+AgKxxHlhfm6uxzkQ79UwgduvcmL9X6IOzNe+LhAYE78Eyfbol1aVjdJO7ST18MDSPP45KnxMHPU7eUgiFeAldQ9tpMl8e8ETSZdwPNlfjOqUWUqbgtiLz+0TlZgoOd8b+n5j2XqTfJ5AwEmmez07WOD9uGNm0ZjEcfzA+fTwF3DVM8gsD0QEyz/P4kQ7sDWFLdHhnjTqheTCx05NIT8ELzDNBrRnOsR8G1TzO5JZ865LFDHXqq2W9fsfIKw30NaR28aO0sp8vV0hRVqo8V9TAgbajrTMqN1AFENYNxm8nHSBQD8DoR/k6f24ub0oodpTcplxv0sN0K8+mrWf4NGlloZfxV+2SSHZL+h+/2YNkkpqw5ggNw5wdVBGhsOZRGm2AuJyBMuHAlNq6+hDNVOLkrctip47cI0H0NIZmkeNZL3pWhDXkYInKzN5GIRvF8xwE5gKW1lrgx91Z+R0O9wGKZN/zYgTvajRKBDPNnuy0okhs+tTysTL71FdGFWrXzZ0qrsrkRVwi/bjp1EOBgEwnuBJIUts24dhT/AcfV1JIJ3Coa2o5YND+yYOxYKmexBh80Ds5ioNh3KzLxwtl7WlZMU1JZJMORQMHi3ouQ0cCdN7ET4J2lBPALk6s8HTxsaryjtKhokEioC8pktvx2sMAC2lr1/pQOVUaHoRjkhmCGX4xmfsL9JvcJOSJyL6hfFzVne6Zhh5azNxZbJI9emn8f8IDNBg+cSup9P6ljXyJDcmwJjR1rxw58Z2+kSv5T9RuIlFd/6F0HxAlylhpMYmKBA9m0n7eVLxBKrdwX4jhVib01It9m3h6w0MOm/62a4XG3FGqVuPvCQl0WmWz0kXtTHninpgVkcUoC
 /HXJ9nn5
 Ep5b9DWkrfkF1VIBdkfuLxHKjodUNoK33Zar986Xm6yDGqad36L5e3ftT5Wu4rId2OIgA2bHCJPxvtQ/w/woQUvpA8lku1LUCcFmOZK2t9yjsRtjA7e5cSWwbEQsNvlC1bzmTITo5SsQDL+Sx7gNAYSWpE6Q3TLjeOR6Hl0bg3brvLRelcB00nzE+vb2FlKWX6pFwlplwZdm/f2JeL5iNPpa7RVrVpkmKE8812r5rHg6L5DGpMqxj6mRVlY4YgfcQU9Y+CbrwbDti3SF/J6/dKigDwzSWQGzPS3x+y6ubn6Y9NAUOlHcmE1ZisxbksRn5+X1d68uS0XqkcwRyMT3Mcr3iIG9BvpHmRQ2v5tB4iqP3/QnOs1QYuLfDvE7rJR0zpQ5HbyJ8gHjABE0s3LHxTvPbOFJ6NJZQaOel4RkfRA4JoJx3whgsItta1KcjMaXh0wOPx8BS5TJT/NWeeFGfV687D7aQm2cQS4UE9Q4Yurq2pefrMEX2dA98IvQ0+ceTQu64633SzbYAqCLxSPvjraj46IuUqwc5lKA5AKhkHGNqnh5D1DLaUAeyGg9mxAAGdTEHbNDLI0izTTJIHrqs7WF4xw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 08:45:30PM -0500, Mathieu Desnoyers wrote:
[...]
> +static inline
> +struct hazptr_slot *hazptr_get_free_percpu_slot(void)
> +{
> +	struct hazptr_percpu_slots *percpu_slots = this_cpu_ptr(&hazptr_percpu_slots);
> +	unsigned int idx;
> +
> +	for (idx = 0; idx < NR_HAZPTR_PERCPU_SLOTS; idx++) {
> +		struct hazptr_slot *slot = &percpu_slots->slots[idx];
> +
> +		if (!READ_ONCE(slot->addr))
> +			return slot;
> +	}
> +	/* All slots are in use. */
> +	return NULL;
> +}
> +
> +static inline
> +bool hazptr_slot_is_backup(struct hazptr_ctx *ctx, struct hazptr_slot *slot)
> +{
> +	return slot == &ctx->backup_slot.slot;
> +}
> +
> +/*
> + * hazptr_acquire: Load pointer at address and protect with hazard pointer.
> + *
> + * Load @addr_p, and protect the loaded pointer with hazard pointer.
> + *
> + * Returns a non-NULL protected address if the loaded pointer is non-NULL.
> + * Returns NULL if the loaded pointer is NULL.
> + *
> + * On success the protected hazptr slot is stored in @ctx->slot.
> + */
> +static inline
> +void *hazptr_acquire(struct hazptr_ctx *ctx, void * const * addr_p)
> +{
> +	struct hazptr_slot *slot = NULL;
> +	void *addr, *addr2;
> +
> +	/*
> +	 * Load @addr_p to know which address should be protected.
> +	 */
> +	addr = READ_ONCE(*addr_p);
> +	for (;;) {
> +		if (!addr)
> +			return NULL;
> +		guard(preempt)();
> +		if (likely(!hazptr_slot_is_backup(ctx, slot))) {
> +			slot = hazptr_get_free_percpu_slot();

I need to continue share my concerns about this "allocating slot while
protecting" pattern. Here realistically, we will go over a few of the
per-CPU hazard pointer slots *every time* instead of directly using a
pre-allocated hazard pointer slot. Could you utilize this[1] to see a
comparison of the reader-side performance against RCU/SRCU?

> +			/*
> +			 * If all the per-CPU slots are already in use, fallback
> +			 * to the backup slot.
> +			 */
> +			if (unlikely(!slot))
> +				slot = hazptr_chain_backup_slot(ctx);
> +		}
> +		WRITE_ONCE(slot->addr, addr);	/* Store B */
> +
> +		/* Memory ordering: Store B before Load A. */
> +		smp_mb();
> +
> +		/*
> +		 * Re-load @addr_p after storing it to the hazard pointer slot.
> +		 */
> +		addr2 = READ_ONCE(*addr_p);	/* Load A */
> +		if (likely(ptr_eq(addr2, addr)))
> +			break;
> +		/*
> +		 * If @addr_p content has changed since the first load,
> +		 * release the hazard pointer and try again.
> +		 */
> +		WRITE_ONCE(slot->addr, NULL);
> +		if (!addr2) {
> +			if (hazptr_slot_is_backup(ctx, slot))
> +				hazptr_unchain_backup_slot(ctx);
> +			return NULL;
> +		}
> +		addr = addr2;
> +	}
> +	ctx->slot = slot;
> +	/*
> +	 * Use addr2 loaded from the second READ_ONCE() to preserve
> +	 * address dependency ordering.
> +	 */
> +	return addr2;
> +}
> +
> +/* Release the protected hazard pointer from @slot. */
> +static inline
> +void hazptr_release(struct hazptr_ctx *ctx, void *addr)
> +{
> +	struct hazptr_slot *slot;
> +
> +	if (!addr)
> +		return;
> +	slot = ctx->slot;
> +	WARN_ON_ONCE(slot->addr != addr);
> +	smp_store_release(&slot->addr, NULL);
> +	if (unlikely(hazptr_slot_is_backup(ctx, slot)))
> +		hazptr_unchain_backup_slot(ctx);
> +}
> +
> +void hazptr_init(void);
> +
> +#endif /* _LINUX_HAZPTR_H */
> diff --git a/init/main.c b/init/main.c
> index 07a3116811c5..858eaa87bde7 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -104,6 +104,7 @@
>  #include <linux/pidfs.h>
>  #include <linux/ptdump.h>
>  #include <linux/time_namespace.h>
> +#include <linux/hazptr.h>
>  #include <net/net_namespace.h>
>  
>  #include <asm/io.h>
> @@ -1002,6 +1003,7 @@ void start_kernel(void)
>  	workqueue_init_early();
>  
>  	rcu_init();
> +	hazptr_init();
>  	kvfree_rcu_init();
>  
>  	/* Trace events are available after this */
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 9fe722305c9b..1178907fe0ea 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -7,7 +7,7 @@ obj-y     = fork.o exec_domain.o panic.o \
>  	    cpu.o exit.o softirq.o resource.o \
>  	    sysctl.o capability.o ptrace.o user.o \
>  	    signal.o sys.o umh.o workqueue.o pid.o task_work.o \
> -	    extable.o params.o \
> +	    extable.o params.o hazptr.o \
>  	    kthread.o sys_ni.o nsproxy.o nstree.o nscommon.o \
>  	    notifier.o ksysfs.o cred.o reboot.o \
>  	    async.o range.o smpboot.o ucount.o regset.o ksyms_common.o
> diff --git a/kernel/hazptr.c b/kernel/hazptr.c
> new file mode 100644
> index 000000000000..2ec288bc1132
> --- /dev/null
> +++ b/kernel/hazptr.c
> @@ -0,0 +1,150 @@
> +// SPDX-FileCopyrightText: 2024 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> +//
> +// SPDX-License-Identifier: LGPL-2.1-or-later
> +
> +/*
> + * hazptr: Hazard Pointers
> + */
> +
> +#include <linux/hazptr.h>
> +#include <linux/percpu.h>
> +#include <linux/spinlock.h>
> +#include <linux/list.h>
> +#include <linux/export.h>
> +
> +struct overflow_list {
> +	raw_spinlock_t lock;		/* Lock protecting overflow list and list generation. */
> +	struct list_head head;		/* Overflow list head. */
> +	uint64_t gen;			/* Overflow list generation. */
> +};
> +
> +static DEFINE_PER_CPU(struct overflow_list, percpu_overflow_list);
> +
> +DEFINE_PER_CPU(struct hazptr_percpu_slots, hazptr_percpu_slots);
> +EXPORT_PER_CPU_SYMBOL_GPL(hazptr_percpu_slots);
> +
> +/*
> + * Perform piecewise iteration on overflow list waiting until "addr" is
> + * not present. Raw spinlock is released and taken between each list
> + * item and busy loop iteration. The overflow list generation is checked
> + * each time the lock is taken to validate that the list has not changed
> + * before resuming iteration or busy wait. If the generation has
> + * changed, retry the entire list traversal.
> + */
> +static
> +void hazptr_synchronize_overflow_list(struct overflow_list *overflow_list, void *addr)
> +{
> +	struct hazptr_backup_slot *backup_slot;
> +	uint64_t snapshot_gen;
> +
> +	raw_spin_lock(&overflow_list->lock);
> +retry:
> +	snapshot_gen = overflow_list->gen;
> +	list_for_each_entry(backup_slot, &overflow_list->head, node) {
> +		/* Busy-wait if node is found. */
> +		while (smp_load_acquire(&backup_slot->slot.addr) == addr) { /* Load B */
> +			raw_spin_unlock(&overflow_list->lock);
> +			cpu_relax();

I think we should prioritize the scan thread solution [2] instead of
busy waiting hazrd pointer updaters, because when we have multiple
hazard pointer usages we would want to consolidate the scans from
updater side. If so, the whole ->gen can be avoided.

However this ->gen idea does seem ot resolve another issue for me, I'm
trying to make shazptr critical section preemptive by using a per-task
backup slot (if you recall, this is your idea from the hallway
discussions we had during LPC 2024), and currently I could not make it
work because the following sequeue:

1. CPU 0 already has one pointer protected.

2. CPU 1 begins the updater scan, and it scans the list of preempted
   hazard pointer readers, no reader.

3. CPU 0 does a context switch, it stores the current hazard pointer
   value to the current task's ->hazard_slot (let's say the task is task
   A), and add it to the list of preempted hazard pointer readers.

4. CPU 0 clears its percpu hazptr_slots for the next task (B).

5. CPU 1 continues the updater scan, and it scans the percpu slot of
   CPU 0, and finds no reader.

in this situation, updater will miss a reader. But if we add a
generation snapshotting at step 2 and generation increment at step 3, I
think it'll work.

IMO, if we make this work, it's better than the current backup slot
mechanism IMO, because we only need to acquire the lock if context
switch happens. I will look into the implementation of this and if I
could get it down, I will send it in my next version of shazptr. Mention
it here just to add this option into the discussion.

[1]: https://lore.kernel.org/lkml/20250625031101.12555-3-boqun.feng@gmail.com/
[2]: https://lore.kernel.org/lkml/20250625031101.12555-5-boqun.feng@gmail.com/

Regards,
Boqun

> +			raw_spin_lock(&overflow_list->lock);
> +			if (overflow_list->gen != snapshot_gen)
> +				goto retry;
> +		}
> +		raw_spin_unlock(&overflow_list->lock);
> +		/*
> +		 * Release raw spinlock, validate generation after
> +		 * re-acquiring the lock.
> +		 */
> +		raw_spin_lock(&overflow_list->lock);
> +		if (overflow_list->gen != snapshot_gen)
> +			goto retry;
> +	}
> +	raw_spin_unlock(&overflow_list->lock);
> +}
> +
> +static
> +void hazptr_synchronize_cpu_slots(int cpu, void *addr)
> +{
> +	struct hazptr_percpu_slots *percpu_slots = per_cpu_ptr(&hazptr_percpu_slots, cpu);
> +	unsigned int idx;
> +
> +	for (idx = 0; idx < NR_HAZPTR_PERCPU_SLOTS; idx++) {
> +		struct hazptr_slot *slot = &percpu_slots->slots[idx];
> +
> +		/* Busy-wait if node is found. */
> +		smp_cond_load_acquire(&slot->addr, VAL != addr); /* Load B */
> +	}
> +}
> +
> +/*
> + * hazptr_synchronize: Wait until @addr is released from all slots.
> + *
> + * Wait to observe that each slot contains a value that differs from
> + * @addr before returning.
> + * Should be called from preemptible context.
> + */
> +void hazptr_synchronize(void *addr)
> +{
> +	int cpu;
> +
> +	/*
> +	 * Busy-wait should only be done from preemptible context.
> +	 */
> +	lockdep_assert_preemption_enabled();
> +
> +	/*
> +	 * Store A precedes hazptr_scan(): it unpublishes addr (sets it to
> +	 * NULL or to a different value), and thus hides it from hazard
> +	 * pointer readers.
> +	 */
> +	if (!addr)
> +		return;
> +	/* Memory ordering: Store A before Load B. */
> +	smp_mb();
> +	/* Scan all CPUs slots. */
> +	for_each_possible_cpu(cpu) {
> +		/* Scan CPU slots. */
> +		hazptr_synchronize_cpu_slots(cpu, addr);
> +		/* Scan backup slots in percpu overflow list. */
> +		hazptr_synchronize_overflow_list(per_cpu_ptr(&percpu_overflow_list, cpu), addr);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(hazptr_synchronize);
> +
> +struct hazptr_slot *hazptr_chain_backup_slot(struct hazptr_ctx *ctx)
> +{
> +	struct overflow_list *overflow_list = this_cpu_ptr(&percpu_overflow_list);
> +	struct hazptr_slot *slot = &ctx->backup_slot.slot;
> +
> +	slot->addr = NULL;
> +
> +	raw_spin_lock(&overflow_list->lock);
> +	overflow_list->gen++;
> +	list_add(&ctx->backup_slot.node, &overflow_list->head);
> +	ctx->backup_slot.cpu = smp_processor_id();
> +	raw_spin_unlock(&overflow_list->lock);
> +	return slot;
> +}
> +EXPORT_SYMBOL_GPL(hazptr_chain_backup_slot);
> +
> +void hazptr_unchain_backup_slot(struct hazptr_ctx *ctx)
> +{
> +	struct overflow_list *overflow_list = per_cpu_ptr(&percpu_overflow_list, ctx->backup_slot.cpu);
> +
> +	raw_spin_lock(&overflow_list->lock);
> +	overflow_list->gen++;
> +	list_del(&ctx->backup_slot.node);
> +	raw_spin_unlock(&overflow_list->lock);
> +}
> +EXPORT_SYMBOL_GPL(hazptr_unchain_backup_slot);
> +
> +void __init hazptr_init(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct overflow_list *overflow_list = per_cpu_ptr(&percpu_overflow_list, cpu);
> +
> +		raw_spin_lock_init(&overflow_list->lock);
> +		INIT_LIST_HEAD(&overflow_list->head);
> +	}
> +}
> -- 
> 2.39.5
> 

