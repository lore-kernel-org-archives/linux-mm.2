Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B66D711C7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 22:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35706B008A; Thu, 18 Dec 2025 17:21:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D336B008C; Thu, 18 Dec 2025 17:21:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1866B0092; Thu, 18 Dec 2025 17:21:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF2176B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:21:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60F981361E3
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:21:08 +0000 (UTC)
X-FDA: 84234013416.01.0079882
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 13B42180006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:21:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EQfX1z5Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766096466; a=rsa-sha256;
	cv=none;
	b=1RxSTL9iu+ck7NCvHMPjZ9m6kLLJzkxL4DdBL5otr18pbz0ITtVT4glRabb/t02LOZhOuX
	KUXKYEQr7v5jWCws7h15VZ8YeJTN7jWC4j3jkIH8iz6A1qZ+cXTfo/m83bLdOP3CQ4DXUG
	QsMrid9thGSE9Efos/TvZV957BjTz/4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EQfX1z5Q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766096466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N8rgecbz9Q7Jzp6eajm21hLSWx7IeyY0MrZP+QvLVqg=;
	b=BW2fisUaQQLoqDU9Yjpq37xfgp9Tz+r6NZQ2AzQVBXzx9gLsb50AcdDUBj+ZmMow7VSEzJ
	aNnI6vMxnjh2P+pq3CTLOAZX+mLqbfAmH0rtf1VJpM5fXlVAlHfXCtWc/UTpxsMUxqcy/N
	pXpzO6x1R4qsYpDfD2GUwMRYXqyWwIc=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso1384580b3a.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766096465; x=1766701265; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8rgecbz9Q7Jzp6eajm21hLSWx7IeyY0MrZP+QvLVqg=;
        b=EQfX1z5QlHLU0L4tOsj6rsSYUDVx9vghZ6MamCKNG/CJYoBlqZozPlVf2kPoOiW0pj
         c7Jh8IJxzBY7AJnuANsZEGMbKa/6rS0ox0isX88PLLqjAsqWTjqZr++njOLDsNZi2HzM
         xNHWaQCOqyoBj+I3YoAL3C/o5Le8vbx+HzsyYBbmN2YBmh3N2U54vhkIqfFsWEdI4o1v
         hNpRwQq4zlS9MQnm/MNYUK5nobogXBDwGljcf8NTwAOptoqEnTGtgvbUUMzswgBH7jwC
         3bZwHxwvqzMEi0cYe457haUeqfLEIZ5Wa7mGk0Zu0S6QD17cJOCCYbHRO1cX8+EM7eO5
         dJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766096465; x=1766701265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N8rgecbz9Q7Jzp6eajm21hLSWx7IeyY0MrZP+QvLVqg=;
        b=jw/EidV3bc47p/pyJDr1ylbmXa0DoYJJ4XCJhD1Nwr7TDykw4aBCXbfclrTFRSp2he
         2fvbAsE+i6aBgX3vViR3r9q2Ync591O7OnBZdwXqnnldrBP3Ue35SXolDen5ZxSe8Dz0
         8qB2/wAOP744VB8UF9TrhHC8T5y+iouENz8VV4PdysDs9ZJgHG83p0+9TffJmPYx+GdH
         Q8hnqtupsImvGrymrh0HQI6xOZPo/TvRuD6/CkHlIQbhbTA0gScsG/FpiM5GFv8WsrUK
         uvB5BHZ9TJJTxZrqG6uaVuIhAsnncaiu0baoQbP3/ItFc7tplJHoBDiPGqsG6nz+sCdB
         4e1g==
X-Forwarded-Encrypted: i=1; AJvYcCVT14pWldq4JAE9t2ica/Xw/9KJ5nUjdiixesErijJgvj0w3UWcgrTVFNFvjuANZjYkQCJIOxQ9yg==@kvack.org
X-Gm-Message-State: AOJu0Yz1qdosVhTZDvJr+znC+IULUy1AzYUt2bGx+G4EYgw0nhYyoPS6
	JD8Kf/Gp62ZZ7/SsARsqslNCXrbSfXXMpj8EV/NvSUCz7Q+O0Fx4JvRg
X-Gm-Gg: AY/fxX7AAYM7D83dp61znbA4BYi5m57PGNs5c7EkryZdG8MZ6AxfIkzryhpdIgyLQKb
	5n7Es2jdca7KTet6F0Si1zhjsi3xuAs4VuOFHm030xGqPQugn1CfjpcRc+xgSkHodoVSQrRi/z1
	6o6kyQFBOqLfqKoNKImxCrMu3IRwFAtq8xUEemrbR53RT4n13Kw9C86LPcKBkYu4UFt3F5upmgk
	c9mIvlMBNSU72qUP/Mmf5Jstak/+jJ9lXaLOClsWGS5L5AbKmiubjef+dBjY+uzG7rX7lXbFIIr
	aHYIpNYo+hzP2bNPXx8qY5nxy+He38sUWWCeUD9nD2KOjFfM2+D3T6FWCANrJQT06R3BsUfl0y/
	EsHazPgkitueA4DMWNKpxlsNQn81XlVnTEL6GaVFrAEOT2Vr9tPQmTufMEG4hrwvBbvmBhus8z8
	uFXCI5S9u/k2UWVpIKhiCaa8xrHO06MEBKh1yVYzN/qj+ebfcwOu/q8uM40b2cbtzzcE5wnM8VX
	oINCEmlST4gkYs=
X-Google-Smtp-Source: AGHT+IEspr+mA8yBfzyu92XEiMHrHEfySL5XUdcBH3qNwt/XL6ga6kYNOb/BEKUmPIRMr7Vo9NJQvA==
X-Received: by 2002:a05:622a:1801:b0:4f0:2b7d:5e05 with SMTP id d75a77b69052e-4f4abdc5894mr6756991cf.73.1766089353934;
        Thu, 18 Dec 2025 12:22:33 -0800 (PST)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88d973a7f17sm3470116d6.22.2025.12.18.12.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 12:22:33 -0800 (PST)
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6CAEFF40068;
	Thu, 18 Dec 2025 15:22:32 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 18 Dec 2025 15:22:32 -0500
X-ME-Sender: <xms:iGJEaTXC7Mbzq2VSxQnniDwb0KXl8rx5O8vsG465qQfLHhdNSZdoLw>
    <xme:iGJEaZH-9Zcpv5hnLU3pV4LhmPg9-pPVGbsYVvnaglo0r3e9p15WL18nuEXd9AQ1J
    OTqM5u5b5LgFyvYLHhR-VD0NFHPy9gs-5L3cb6GLJhRjnxreyUGGA>
X-ME-Received: <xmr:iGJEabe_lCyjfDp07p_7ZwF5QdisUDkwZxJhmKbV5l1RBsbTZaoiNqWOavJd>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegieefjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhnucfh
    vghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrthhtvg
    hrnheptddtudegueevgefhgfeuffetffeuheekgedtffefhefhjeffhffgfeeggeetgefh
    necuffhomhgrihhnpegvfhhfihgtihhoshdrtghomhenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhp
    vghrshhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrd
    hfvghngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthht
    ohepfeefpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehmrghthhhivghurdguvg
    hsnhhohigvrhhssegvfhhfihgtihhoshdrtghomhdprhgtphhtthhopehjohgvlhesjhho
    vghlfhgvrhhnrghnuggvshdrohhrghdprhgtphhtthhopehprghulhhmtghksehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghr
    nhgvlhdrohhrghdprhgtphhtthhopehnphhighhgihhnsehgmhgrihhlrdgtohhmpdhrtg
    hpthhtohepmhhpvgesvghllhgvrhhmrghnrdhiugdrrghupdhrtghpthhtohepghhrvghg
    khhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepsghighgvrg
    hshieslhhinhhuthhrohhnihigrdguvgdprhgtphhtthhopeifihhllheskhgvrhhnvghl
    rdhorhhg
X-ME-Proxy: <xmx:iGJEabnyuKxJGLEnl3scEcV1Wr2sOT-vA5J2RYUGjX6RJN1qIORUpw>
    <xmx:iGJEaQEQN4GdKTlX4_1v-2RuuKtYr-H51p_MjcfnG3FsOmRfLIpdsg>
    <xmx:iGJEaW9xXmliOc7FtXTAYnwZkx0ObVMah_X-__4eArWyRu5ecw4ZXw>
    <xmx:iGJEaRiYrFqs_GGsbrm8ibaxbhwj1OlS_MFhn4aj6bNPGtNjuBwxLg>
    <xmx:iGJEaaQeaoS5QqiZYn8gsAq0HZwfSVU4BK7sqnOpSpF3J5k8G5qP5m-->
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 15:22:31 -0500 (EST)
Date: Fri, 19 Dec 2025 05:22:29 +0900
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
Message-ID: <aURihbmjsKi8m7MO@tardis-2.local>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
 <20251218014531.3793471-4-mathieu.desnoyers@efficios.com>
 <aUO9KRaP0FXpm_l9@tardis-2.local>
 <fcbc99d0-b7c7-45f7-9cf8-f5d3bfad966e@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcbc99d0-b7c7-45f7-9cf8-f5d3bfad966e@efficios.com>
X-Rspamd-Queue-Id: 13B42180006
X-Rspamd-Server: rspam03
X-Stat-Signature: nyqzgw6dxe9u4aoha398rsx1if5ps745
X-Rspam-User: 
X-HE-Tag: 1766096465-673600
X-HE-Meta: U2FsdGVkX19jV6lexzMoHewJfijVcAQV9GaZ8wtkKP0xq8/Rb9J9+SzCvtyl8L3DL7L93Z+koDIohhTvtZCuegzX9JDMx3GYBhzXOTWHBm+FVx5jeuc2r8j4FAlP/wvjqPBh46uOS2ELpfA3iEBQheaXlrG6MvmuDjDPh+PkKJkhqb9ARovP2vJqW7Ish1i+vzIpFDpdWYG9ORaU/+ImhPsAS/V94SdZ9seHDNzSBmbdC309WCJ7Jlm3Z4D/D08EcsFLzdNdjpZ+xxDGuA6ykz1o+svy/8rBPp0CShGATgBT9v8V84QTashD1qDJXsTv48gQGPwVbDVIYHNXhtVUSaLzT7yWJIdRjW7tCG+4ch/E0UQEuva3ycO+Tt+Yyvcw6Qku174udK6xHZqKGdNo/TfruHVx6eTWHjnyyO88U+5qpRV5XnT4u7Hjl9dUjwcRrM6IEuj93KqXV67EYs0o85lno5298LYF5V6C9acijdmYzZyL87+5WYRY8if8RzvCrUXMj2g4DA+Sgxfsk5ulh3FMskHZRDEQRkBJqyr2Qae7jVGOt/AR9CpeR02VAOdrw4/sm5bstzfxjDBpF5aYrm5NPkfuEPyVuGiBhDWO1KOWkkZC4vDrbXD6v6C+deCVQbCo4iuc3arEwLSjZlrXUf3lwuICy/EAX4KfV75XZhicZSj44Hbzd0GFzpcyVRPJmFD4yzIdAO8ugOpJb5nZ2KjkY5xUY85tGZPtVo7NGXvainvVfpw/heRLHUxYRrUD0KjTpicSx72c39zh1uTPmN7O5O0Z33GVPXZK9B/jh5yXY+A6l6UAyXZAWXHH+u5u4aokPk5XyH7lLnQ5P2TtGFk5WzmbEFDLiXElY3p/zUijYgtYoEVw+btzfBzf368dqBdDWaaodKg4jWfhE9xx2I3pFJjX/fHqzNXxRnDHvygHqveUoSbyF4VAjY+53zu/it7oaT3VMW9D0pvD0ao
 KO+pP0+N
 9LRya5OuwNOoLCAmCcqQDZuRN4kNS2/QMzxfVSsMssXlnvjv7sMOKUqtPSlADQ2vQ7Ixur/ApKYj5gZaL3+pzVoi964L0heFr0s0Q/GGDtxteTmfQADie1IKHhCODx/sc/sgZ4tg/AcybDAAqU2tmflLUzND95XkXFidrGWtb+I53l70IMwSND8gob7lZcAofryp9KO4m6V5WAkRj40qp4IPoocm8YR7N7yew4a//G8IlV/zPBnmKTCeRgNTRcA6Y/IXY91yEUV/in55OBLP7lLW5eCJs/rZSBND30BeBuv7OGJnBMHD3/v+anKA50XQ0Ns51sfgqP4qGFati4L/De/uWXfWrZ4KcbOgZPxrT4vgxXujIDiTNS+cYA70XthpdVT9nNaL0L92bCLdwCsraTZkYuqYdakk+79f7ugJ/JWc8h5JyI1JEwRUd5ZO0e3sUXqzL7TFTOfghsUqR6Ky5HTmdeg5aGAgu2xNzVFxrJVM8nPWPkU6dzNRqRqh5x7i0UbHJqJ6uK04596T+m2ULPdWXNGc1H/xWbY3W/MMxbRTFAjjwGkrEnb5O1mRWC1W1KmXcxijwZlMILd1y1R4NR9Uboi3/LrAsuqKe1LanmPqeE5o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 12:35:18PM -0500, Mathieu Desnoyers wrote:
> On 2025-12-18 03:36, Boqun Feng wrote:
> > On Wed, Dec 17, 2025 at 08:45:30PM -0500, Mathieu Desnoyers wrote:
> [...]
> > > +static inline
> > > +void *hazptr_acquire(struct hazptr_ctx *ctx, void * const * addr_p)
> > > +{
> > > +	struct hazptr_slot *slot = NULL;
> > > +	void *addr, *addr2;
> > > +
> > > +	/*
> > > +	 * Load @addr_p to know which address should be protected.
> > > +	 */
> > > +	addr = READ_ONCE(*addr_p);
> > > +	for (;;) {
> > > +		if (!addr)
> > > +			return NULL;
> > > +		guard(preempt)();
> > > +		if (likely(!hazptr_slot_is_backup(ctx, slot))) {
> > > +			slot = hazptr_get_free_percpu_slot();
> > 
> > I need to continue share my concerns about this "allocating slot while
> > protecting" pattern. Here realistically, we will go over a few of the
> > per-CPU hazard pointer slots *every time* instead of directly using a
> > pre-allocated hazard pointer slot.
> 
> No, that's not the expected fast-path with CONFIG_PREEMPT_HAZPTR=y
> (introduced in patch 4/4).
> 

I see, I was missing the patch #4, will take a look and reply
accordingly.

> With PREEMPT_HAZPTR, using more than one hazard pointer per CPU will
> only happen if there are nested hazard pointer users, which can happen
> due to:
> 
> - Holding a hazard pointer across function calls, where another hazard
>   pointer is used.
> - Using hazard pointers from interrupt handlers (note: my current code
>   only does preempt disable, not irq disable, this is something I'd need
>   to change if we wish to acquire/release hazard pointers from interrupt
>   handlers). But even that should be a rare event.
> 
> So the fast-path has an initial state where there are no hazard pointers
> in use on the CPU, which means hazptr_acquire() finds its empty slot at
> index 0.
> 
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

Could you also see the reader-side performance impact when the percpu
hazard pointer slots are used up? I.e. the worst case.

> [...]
> 
> > > +/*
> > > + * Perform piecewise iteration on overflow list waiting until "addr" is
> > > + * not present. Raw spinlock is released and taken between each list
> > > + * item and busy loop iteration. The overflow list generation is checked
> > > + * each time the lock is taken to validate that the list has not changed
> > > + * before resuming iteration or busy wait. If the generation has
> > > + * changed, retry the entire list traversal.
> > > + */
> > > +static
> > > +void hazptr_synchronize_overflow_list(struct overflow_list *overflow_list, void *addr)
> > > +{
> > > +	struct hazptr_backup_slot *backup_slot;
> > > +	uint64_t snapshot_gen;
> > > +
> > > +	raw_spin_lock(&overflow_list->lock);
> > > +retry:
> > > +	snapshot_gen = overflow_list->gen;
> > > +	list_for_each_entry(backup_slot, &overflow_list->head, node) {
> > > +		/* Busy-wait if node is found. */
> > > +		while (smp_load_acquire(&backup_slot->slot.addr) == addr) { /* Load B */
> > > +			raw_spin_unlock(&overflow_list->lock);
> > > +			cpu_relax();
> > 
> > I think we should prioritize the scan thread solution [2] instead of
> > busy waiting hazrd pointer updaters, because when we have multiple
> > hazard pointer usages we would want to consolidate the scans from
> > updater side.
> 
> I agree that batching scans with a worker thread is a logical next step.
> 
> > If so, the whole ->gen can be avoided.
> 
> How would it allow removing the generation trick without causing long
> raw spinlock latencies ?
> 

Because we won't need to busy-wait for the readers to go away, we can
check whether they are still there in the next scan.

so:

	list_for_each_entry(backup_slot, &overflow_list->head, node) {
		/* Busy-wait if node is found. */
		if (smp_load_acquire(&backup_slot->slot.addr) == addr) { /* Load B */
			<mark addr as unable to free and move on>
		
> > 
> > However this ->gen idea does seem ot resolve another issue for me, I'm
> > trying to make shazptr critical section preemptive by using a per-task
> > backup slot (if you recall, this is your idea from the hallway
> > discussions we had during LPC 2024),
> 
> I honestly did not remember. It's been a whole year! ;-)
> 
> > and currently I could not make it
> > work because the following sequeue:
> > 
> > 1. CPU 0 already has one pointer protected.
> > 
> > 2. CPU 1 begins the updater scan, and it scans the list of preempted
> >     hazard pointer readers, no reader.
> > 
> > 3. CPU 0 does a context switch, it stores the current hazard pointer
> >     value to the current task's ->hazard_slot (let's say the task is task
> >     A), and add it to the list of preempted hazard pointer readers.
> > 
> > 4. CPU 0 clears its percpu hazptr_slots for the next task (B).
> > 
> > 5. CPU 1 continues the updater scan, and it scans the percpu slot of
> >     CPU 0, and finds no reader.
> > 
> > in this situation, updater will miss a reader. But if we add a
> > generation snapshotting at step 2 and generation increment at step 3, I
> > think it'll work.
> > 
> > IMO, if we make this work, it's better than the current backup slot
> > mechanism IMO, because we only need to acquire the lock if context
> > switch happens.
> 
> With PREEMPT_HAZPTR we also only need to acquire the per-cpu overflow
> list raw spinlock on context switch (preemption or blocking). The only

Indeed, pre-allocating the slot on the stack to save the percpu slot
when context switch seems easier and quite smart ;-) Let me take a look.

Regards,
Boqun

> other case requiring it is hazptr nested usage (more than 8 active
> hazptr) on a thread context + nested irqs.
> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> https://www.efficios.com

