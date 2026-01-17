Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2B1C98303
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 178BD6B0089; Fri, 16 Jan 2026 21:30:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127426B008A; Fri, 16 Jan 2026 21:30:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0085C6B008C; Fri, 16 Jan 2026 21:30:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E28F86B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:30:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AFE113A752
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:30:13 +0000 (UTC)
X-FDA: 84339876306.07.19D20EB
Received: from mail-qv1-f68.google.com (mail-qv1-f68.google.com [209.85.219.68])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5881E4000E
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:30:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iWz3HhCY;
	spf=pass (imf04.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.68 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768617011; a=rsa-sha256;
	cv=none;
	b=rylTIqoUJhk1Du0V5e4gSPUimZrSvCmTLy1gSJT9h9dLKJjnUR9M7NJbqjDAfXqSk9GT95
	gyrZYgihnwFpfyzj6AwWeliOB8DJxWIDov1rhfSJQ5rhPG6VndwRDy8pPjLU/3RzBhka8r
	ceJdXfoywrZeU3gdsuQ4I7JRdo0sfSU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iWz3HhCY;
	spf=pass (imf04.hostedemail.com: domain of boqun.feng@gmail.com designates 209.85.219.68 as permitted sender) smtp.mailfrom=boqun.feng@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768617011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7v6jVLBvVKWoS0dmG0nNndXtomcaAtap7nM7qINq/8=;
	b=0Jwgk3XJOw1ERfEzZcScmielfQn/30C+2P0vdIj6VmsLpf3RNtM5RgngJzG+cUB5xdfaNh
	5aYf9tvz+HwqfPq5oYxVtWHKnBgIP39Pu3gkhbDIBiemRwzYjeZlmVPofEMQ1hEmpU0WJF
	6c/7wVd5kZyItFCG4ITvowvOnaxDaZo=
Received: by mail-qv1-f68.google.com with SMTP id 6a1803df08f44-8887f43b224so50115506d6.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768617010; x=1769221810; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e7v6jVLBvVKWoS0dmG0nNndXtomcaAtap7nM7qINq/8=;
        b=iWz3HhCYUaQJs1PUaNxBro0qUS58KEWJeupeWoAshHHexE70kAKYKn/r4rABJWjcEW
         oszdaoiSugp4YIunFTOrjPB3LXZeWgoGKZTZAT/VHvFWXMzQkOSu/gVwFFtQ4hkQ1aRv
         ur73Dhv/1WTEPGN0+0t5Jl1j7YRN3QKNSnlGoe3TPvC4bIB1v4yFptrs/5x4kC1I3cUk
         x55Cyq1PoFbSxW2R7e3bD1za9NThzU4gacDIOEUU7IuFJyP8I+tkSg6SMvUrfdbk0M5D
         rWZ04+5reiuJQZn8gHALPijqxJhx1DO/R01L9gf+y1tKhkV4ipwwzdnIFGi9uWkUpBJy
         rnBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768617010; x=1769221810;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e7v6jVLBvVKWoS0dmG0nNndXtomcaAtap7nM7qINq/8=;
        b=oqATva/KSYGDxJLNg5bNpQpy/NmtQEneObaAHbpRUCaUqX/9N334q5rpgYN0yyErIn
         aqxg+yV/JSTFEkPuqznJpQHZloDLF0oXUiDICTlyJxJjGco1NY/GxR/d4/UkyeLHPimS
         ZHA0FXD/4jz88Xs5cUeCwsQDxnvpVW7vCmA9qkeIthkuRl8GZx26pvXnJ+2UkMXeldYK
         qpSiFEDoVMQeUKUZyXcgLXjsJhShTqgCtHW0OYAGYdhgKDrKuM/lLYsourXqKTiZ+j8+
         9PbKweQeP6qh/lcFo1Ihf9u5+ipXwN0OqPfMuMkbR54mLgEPG07SppvaKSbHCpcZoJ5E
         OclA==
X-Forwarded-Encrypted: i=1; AJvYcCUXp3FjXa+ukUnK7ta7nipuNfI7XyyELx+iK/WtG+jjqP0tQbJJSpb9J3Whpp0/g5jh7KNcRB/obg==@kvack.org
X-Gm-Message-State: AOJu0Ywipk5BjZU7I+mCEBOmrqBdLeLJGk6LP1mXh9bZEFZKsMkHxb8N
	jEYl1zO9qYT47hrROobexhskkCtOsnVYH7j+SlLSUC3UGZSahcM9GaSn
X-Gm-Gg: AY/fxX5SwipJBk2m/urWNvWYPe/SQfQdlZ+eEgO+s+Vn24Xhts3IsEC4QTSvpgaOXDt
	fZ0/4xN/j1ItDf/oll8NWTxC4XMwU/zYGxFL2t1FezZimIspvARmB8ygj3ywC6xs156XT+bKBLY
	q3hPu9Td/c0EMzryLnNOv94CDsLS+ytdT7PiiYFLGqj6TWRpGQQyhxsLRp+Tc77xDB8j/l+WZmh
	3hDJDumynAASIxC8aPxY/pGjD/rj0CZLe2iuZAhcgoc48B9sIKHJR3KJuYmOFFEB7QzMhYWK3MN
	8qTG2Ptkk6JolNa0goFb81Y6ILnIpGm5gb8L/Wh7tukxN7EklOVEKPIzNwRGGp1g7I2lA8oSRuQ
	pQbATNbGFogkNri4RDaQkROVQotT5OUcZ3kW4uj4ZSiNfCDYTWIA0EkMV14UBEO7vOJ3/MOw5ia
	iWIERnUUjCzxmt8H5LKG7cIQ+K3aqI2IkKki9weov5n9VBt/BRjPO2oZMw9nB4/3OjVulO5HkHt
	TmSGzJZmp80bR8oq48uoJ81+g==
X-Received: by 2002:a05:6214:2261:b0:880:5193:10fb with SMTP id 6a1803df08f44-8942e4b8ff5mr68519416d6.54.1768617010378;
        Fri, 16 Jan 2026 18:30:10 -0800 (PST)
Received: from fauth-a2-smtp.messagingengine.com (fauth-a2-smtp.messagingengine.com. [103.168.172.201])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6d87b1sm35532246d6.53.2026.01.16.18.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 18:30:09 -0800 (PST)
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id 156CCF40068;
	Fri, 16 Jan 2026 21:30:09 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 16 Jan 2026 21:30:09 -0500
X-ME-Sender: <xms:MfRqaRL--ju4zV_ISOu5lD9zKuBBxccbOly9O2AkT6D2dCeGlk9QQQ>
    <xme:MfRqabhDLTJhkDbvlKH3L7AcPMtqfCzOXh9dPHvXbgVVSuhNRITNqr-8h81dso5rJ
    MUkWoMxPEL5SyMbc08xe6WVYEKeg9a8B5cqy4Mffy6onkcJq9PL>
X-ME-Received: <xmr:MfRqaVveKIEYp7Ot9BEkqJqaTy8gceQxw3BraIMpzTKdynrvoBoI5YOP>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddufedtieduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtth
    gvrhhnpeehudfgudffffetuedtvdehueevledvhfelleeivedtgeeuhfegueevieduffei
    vdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsoh
    hquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtdeigedq
    udejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehfihigmh
    gvrdhnrghmvgdpnhgspghrtghpthhtohepvddupdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgtph
    htthhopegsihhgvggrshihsehlihhnuhhtrhhonhhigidruggvpdhrtghpthhtohepphgv
    thgvrhiisehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuh
    igqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtoh
    hmpdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgiipdhrtghpthhtoheprhhpphht
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtoh
    hm
X-ME-Proxy: <xmx:MfRqaVgFbFySiTaExKnRETsMtBEpjHwVJZum39nKdmXH3mwjMdxINQ>
    <xmx:MfRqaQd4ta15fGVKMttu2rRyHfxXOQ2EusHp3BkjbeK-VdvOWxkUzQ>
    <xmx:MfRqaSkZnYLLPvBasqV9b2RbiHU68ypVtKCh4KlMsdVxIGxHtjzCwg>
    <xmx:MfRqaSqaBACFyXVbEeiBXGBGH8TB6yKzTlb5HdIb8bYn_RZ3aar-nQ>
    <xmx:MfRqaR8RAU3Sdk6J2divnS1AK2TGSw8HBVJLUVxBMzEr3KFrLlG9dGSa>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 16 Jan 2026 21:30:08 -0500 (EST)
Date: Sat, 17 Jan 2026 10:30:06 +0800
From: Boqun Feng <boqun.feng@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Waiman Long <longman@redhat.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND 1/3] locking: add rwsem_is_write_locked(), update
 non-lockdep asserts
Message-ID: <aWr0LtTf1rU7iae8@tardis-2.local>
References: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
 <8e343ccb9319433364f5949a69519f1bb521fc8a.1768569863.git.lorenzo.stoakes@oracle.com>
 <20260116151215.GH831050@noisy.programming.kicks-ass.net>
 <99818e30-9f88-4751-af82-0bed019156eb@lucifer.local>
 <20260116155743.AuMKcTAO@linutronix.de>
 <5ca7b2a2-1e9d-4d90-8459-1aa35b30b49c@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ca7b2a2-1e9d-4d90-8459-1aa35b30b49c@lucifer.local>
X-Stat-Signature: pep93jasu7wwx9pzuihhf83hx7rdtcaj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5881E4000E
X-Rspam-User: 
X-HE-Tag: 1768617011-197823
X-HE-Meta: U2FsdGVkX18wBCIQ/PrrfnRzXfYWIYyFjxw0qt6nPBRHn//YM8K9ecSkB5FtL7z1i7210NIA2om8Miiwy2pYUhhWT9aimqH9LGiPFN2CXYOaJPMlxYSbHZWPwLmMJxwQnU2DWmysopbNMttVb7SsAkqDZEeR24vwjRaQVQ6K4jfbuFqFkC5nzxQ38DEqKD9aPLytI2QxS4HztjQf/bnyUMjSsklPFyv4ig9H2MgZPjH2/13YDXZkU7NwuVWywSGHqiWL9OwZBJWmvaKvBi2Vy8MviMB+0Z8JCZz4+JJTaaDVKNl9Jy2NsySJueH2c38073eGh1wz9zxOYE9lgsut3QlLxJ55AH6yLfbl9Bd3l9OixaRK42XVt1MvmOkUPTVfLVD0ZOl68VwRVk22BvuMOAPC7uYpBqRVnm/1TTgZ5bTJMZQLMwaq1rqnKngYVvgJDAfS9JvvLSdu02PoPbLMCazVpKZg8dAvMjoUe//Zo9c8iSE6WJ+kn3s2kS9/5gscNWvdaclj7l8c9PTV1lmgCQgJDeLgscOFE09Jgh3EMm9ZP5b6pUOezn0tKh32pB0gF77wzUKzamFTXfzwiiITneMbg5fMo+YxR++r9Z6Fqxms1t+YKRvZlZQdPhbYpyKciaoKLpvv6F3Jr9G4vywhnW+1WQrVwQBb/8crQRHqDYfmT00sgs7YvTRhbpD3USQ7BZs07dbReiDhvdL5IuI434uF2pHhUhq49mv15WQM7XvD7YUDdPQtun1e6SujBLjW7580a3QRme7xVl2u7E8N3fQXAvmpPNN9U1nMrowc1CvAuPI+r6WqzOm1V+YfgO2ay+YcQT21KyQbXNHezPxGp/8xT26n8PP+fBDesutUThGk8bfHF7iBg6xsRejBgZ925MQKXLG7t/knNGlgqK5StmjIZW16w9v9P3CcfsafnyaXuxTL0sQsyO6Cyxyza6eciSo+Rsc2XVkBEwEZtT4
 F1SFjOwS
 F1ER8Jcpjr9GoMIs6PJBJ1aiiIJXR3lqwMG9UhluDfYaJl8jLi+yUA7os2vB+kIvqI6gL2brUk/JIp38+Y5qi7RsHpRjF/0f6VB9jFXJMRkFRwsYGkPhh7/v0iOzjEEZKpuw4vWdtR7+BK2+HizBVHdmCyGLM8rwS73ngWLDC3LdXnzNDdxZiUIwb29WHFB7TrCHSncQt7qAhX4j3yZQyyXh3vh1lXXVxNM3HFvrlAZgjefk3Ol0Wy1+DrpJ20wlrj5AXinz3/O5mP2O7z2EVhCCOmKwQIrlOjNH1GD0LdbdtyQRZALvv8CjQ1aggMM+Preu5VQS0UuMJ0afPoIu3p0TZsUmPXcxbiIHe8nLHh8VFCTbigt+L/vVw2g/blajzvufCSOqAoJqfCk2SlNt+N4OtJnoNam87ROrcHT8GKnjk1AZV9lZZIt0+7vqUNQX5d8qXDWeF8pSlI/FkaFW9iKs8IEC0sxy/sZGCf/LAI+mStV92AM0Bi/r4i/WpMTv3uLu8w00ihru4OQGWy3CUDC3TA7udSpUyvJ1sCwU33LdbHhKKY0kxAcoYtQkREK2FbUsaPG/6DCjebQHC+XU+c8nvCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 04:21:29PM +0000, Lorenzo Stoakes wrote:
> On Fri, Jan 16, 2026 at 04:57:43PM +0100, Sebastian Andrzej Siewior wrote:
> > On 2026-01-16 15:50:24 [+0000], Lorenzo Stoakes wrote:
> > > No, but we need to be able to assert that one of two locks are held and we
> > > don't want the failure of one being held to cause an assert when the other
> > > isn't.
> >
> > But why don't you use the lockdep based check? That assert only ensures
> 
> Not sure what you mean, the checks I'm adding don't exist yet.
> 
> > that it is locked at the time you did the check. This does not mean you
> > are owner - it could be owned by another task which is unrelated to your
> > cause.
> 
> Yup I'm aware that lockdep tests more than a simple assert.
> 
> I wasn't aware this was possible with the lockdep primitives, mea culpa.
> 
> Also this came out of a previous discussion where I added a similar
> predicate vma_is_detached() and Suren suggested similar for the locks.
> 
> Anyway, I went and looked and yes I see there's lockdep_is_held() for
> instance.
> 
> However, I'd STILL need to do what I'm doing here to account for
> CONFIG_DEBUG_VM && !CONFIG_LOCKDEP configurations right?
> 

There is an idea about a light weight lockdep where we only remain
tracking the held locks in a per-task stack and skip the whole
dependency checking, that would provide lock holding
information without the full cost of LOCKDEP, but that requires some
work and I'm not sure whether it fulfills what you need for DEBUG_VM
tests (each task_struct would have some extra space and lock/unlock
would do extra book-keeping).

> So I'll respin later with if (IS_ENABLED(CONFIG_LOCKDEP)) ...
> And sprinkle with some lockdep_is_held() and see how that works.
> 

Yeah, for LOCKDEP=y cases, please do use lockdep_is_held() or
lockdep_is_held_type(), those would provide the accurate information.

> I mean rwsem_is_locked() is already specified, so naming is going to be a
> thing now but I guess:
> 
> static inline bool rwsem_is_locked_nolockdep(const struct rw_semaphore *sem)
> {
> 	return rw_base_is_locked(&sem->rwbase);
> }
> 
> static inline bool rwsem_is_locked(const struct rw_semaphore *sem)
> {
> 	if (IS_ENABLED(CONFIG_LOCKDEP))
> 		return lockdep_is_held(sem);
> 
> 	return rwsem_is_locked_nolockdep(sem);
> }
> 
> And obviously equivalent for the write case is what's necessary now right?
> 

Assuming we want CONFIG_LOCKDEP=n cases to work without extra
book-keeping, I think we could use rwsem_owner() for write cases, and
name the function as rwsem_is_write_held(), which tells you whether
the current thread is the owner of the write lock (we are lucky here
because rwsem is one of those locks remember their owners ;-)). This
would cover the use case of MM without introducing another is_locked()
function. Peter & Sebastian, how do you like (or not hate ;-)) that
idea?

Regards,
Boqun

> Or am I misunderstanding you?
> 
> >
> > Sebastian
> 
> Thanks, Lorenzo

