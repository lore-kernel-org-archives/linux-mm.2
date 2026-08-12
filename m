Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B698C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 17:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B6B6B02DA; Wed, 12 Aug 2026 13:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D166B02DB; Wed, 12 Aug 2026 13:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232F76B02DC; Wed, 12 Aug 2026 13:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEC196B02DA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:50:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8535BA03B3
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:50:03 +0000 (UTC)
X-FDA: 85093355886.11.2EC9F15
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf27.hostedemail.com (Postfix) with ESMTP id 29B554000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:50:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=e0sq6gSu;
	spf=none (imf27.hostedemail.com: domain of BATV+8f88a44aac2376c73a89+8389+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+8f88a44aac2376c73a89+8389+infradead.org+dwmw2@desiato.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786557001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgdPYYGyUUn1IOAhtILtpO8XLrtOMFaovKbcoEt2Z6w=;
	b=bNC/OaJfADXEFYwyiOC/abNIPQgCZzHeILQYQ1NqFTFc/gewl6+j0izqJYd9KdsuOvt8Do
	cy4KI+056IGXKrIeop0uCLhv1OnjFu79+JkMbgPzYJQqvC1mf79DeVxODOqgyAaq00vdtj
	QWVg6Y+PuH5pWmkIzPGOvoK1dNrUsJc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=e0sq6gSu;
	spf=none (imf27.hostedemail.com: domain of BATV+8f88a44aac2376c73a89+8389+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+8f88a44aac2376c73a89+8389+infradead.org+dwmw2@desiato.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786557001;
	b=pYdssZcxsdaGcdM86O9s4Q2aBspFRtz6Jwgd2mfl6eth0WGEoEMKdSqNYgerh29PH05FPO
	2q4ms27tnVzYzUUWV2OhNhEcLvHnxbJTmMcDMo0paTwO1i8oKdM20c8MHJYxnpAGV22opz
	Cg54mbQfy2c66PBexcBttOpHAb1rM8g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=bgdPYYGyUUn1IOAhtILtpO8XLrtOMFaovKbcoEt2Z6w=; b=e0sq6gSujRTYecy98463RKSYr5
	ck7/pgTc+ObD6YsHZxdGLX56oUpdEwt0TgoOeohryUJY+eNLzKbUGii3Gzdzz3oy4+sb28IbywOli
	ids4I0XSod+9N+LZ4qRHgHAAPeEL96JLTHIAr8kGOKtZ9LmxXajdrIPY7LExV40+EZWg24QGNJwhT
	WF4dkdryVKMANkONGNaBPt7hwk9SpPypljTF3ayIdDtcDNODd1t7y16tRl70/YXDWNow6FB3vTMSY
	/Vrj5k2L5YNxTvo7hnao6a45HYurKw74ie71aDfNvNZUKl2q1/gGFoGPjUzjG4JSRuj68kiclo/3T
	TZw6HBhQ==;
Received: from [2a00:23ee:2678:290c:4649:38e9:2279:b11] (helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wuD5M-0000000Feu3-2mNa;
	Wed, 12 Aug 2026 17:49:53 +0000
Date: Wed, 12 Aug 2026 18:49:50 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>,
 Simona Vetter <simona.vetter@ffwll.ch>,
 =?ISO-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>,
 =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Sean Christopherson <seanjc@google.com>, linux-mm@kvack.org,
 kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/mmu=5Fnotifier=3A_Remove_non=5Fb?=
 =?US-ASCII?Q?lock=5Fstart/end=28=29_from_notifier_invocation?=
User-Agent: K-9 Mail for Android
In-Reply-To: <CABgObfYjdQ13Gd9AH-kck85ZWch7j_E00rajawFuRdt5D=m3Sg@mail.gmail.com>
References: <20260811135537.GC544626@ziepe.ca> <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org> <20260811142730.GG544626@ziepe.ca> <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org> <20260811104229.72fdd928@gandalf.local.home> <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org> <anwraNIKJV8zwrNT@tiehlicka> <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org> <20260812122759.GA662699@ziepe.ca> <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org> <20260812134934.GC662699@ziepe.ca> <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org> <fb87f673bf290cad133d113dbb0750a7752b9d30.camel@infradead.org> <a94b75e8b9b1d2191f365c0f4275fd5082332df5.camel@infradead.org> <CABgObfYjdQ13Gd9AH-kck85ZWch7j_E00rajawFuRdt5D=m3Sg@mail.gmail.com>
Message-ID: <5364F424-42B7-4D1B-BE55-B6F9E68B0F2B@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 29B554000A
X-Stat-Signature: 669kt7bwb996cyhf88i9wsaxegrwqyrs
X-Rspam-User: 
X-HE-Tag: 1786557001-865300
X-HE-Meta: U2FsdGVkX1/LPlwfsJpuWJmK7CV3GKY8RChl2ou4GV+pjnF7rp1/qvbIwOp3K513ut5UgIzTkwvmskf1ejiAeF9gvr98aWTlxSpsM0X1lAr+3yBO8x4SxU/vYgWXAj37bquPRKIiZkoCkFHW/fpEt3N0JeOgsVtf0RyHfU6Ia+RqIk+MqXfJiGSxoIJe8alemDktFyRtt4odg5HD9gZIhWvdxYlQ7fyi6WqIBtlkdMBSVhjwE3mNNQHv26gZmypZSg7w2kWQXYSN6Qao04eWUQoHa66SziMvoC0eTtFKXffTVJVRKj0AJg+Mw6o/pLUkw+3/lQ8o57efUVEXw5y69cJd3+4fhpyuhELsypro/vZyhb16pna6qb0WzXT/AmBmjHROP+MfC2NaYBio08KzsaJE7TYj3LKYdVsKZXmHfF3I6/iTLKv7tvj+F2v/e6inesxDMifZlsDn+wv3iOXAIllCnsIFya7krRKOR8Ff/qs65Xhn65aVNrKQD7MHbkS5Q693fWApYIUbPeSJLb416zGIYJsS+iMNNXdKCbA4ggxK9M8wtE2tgdJXE5qtBa///G+uvwOfBf7m0ByQhNS28fnuXyNhpIgL00LtXo2vAQzeCj1kFu0HB7/WYqJpwTBbDWyMqOZ1twPgbrGBlfp2lSZJi+OE1651PHxSQgKV6QZp3MkowsVaPdBWFes4SbP3Uf2GZya5w8z8sjebfbDEiKWuE0X7ID+bSKmreCl2545Yo5YOHrU8dLZNzyk9VqHhOp9JijqF7lNaczM8mrcnJwktc+EEPdVUUJ7B5NgKJGN+A1/4uThkGY3Glqao97mRQDZoHHCDb3WZwG61c1fKXcVn0pMY2JPLrnSkQUs6fzm/JQXAILt0VcuFwpUAZgcFRlBL28y+93xsNIOJjUxGF8v+1xYZf95lV/iery+5yRmnTFrFq6RHA1Mvwz1GIvVTtxtfItCBd4/yJl79B/d
 UbfeiHN6
 tP0KUgqBjCWE+fnLcPBLEbFj2vA+fB0+CE1N6C8JD8RWNQg9jpHPbN/kJENSvNnUJgtdxXJKXAPJU0sY2SR5qiLTHiJwgysDF7ATq2lyBSGMbMkpUgDb0mTdh3UTnKtbwJ9uYgZGgzknqsNkch+uBZmAcwcyfy94aAc2QfZrjun4VewzaihIyRfJIlGvyRz6zFCfROea7RScWBvY3NdPHh9jQQ/sEo40xw8rgmSOc20CWiFv+avVa9uzf0SGNP3TqbNR41EumVZd5oM4/JKJ23qhTNzRrjmHJON5qFeU3CObrYZ64fMrKUrS0lsGOnaPyxDC0YQ+70mjIjCELL1BVy7u5CD69G1SgdGsH0/qm1ElgJuPNf/fNQanCkY1wE9aWNBrh19oL/GzY1rG63NqZpt6qjLxmgZ0VOKqYZq63tv94BshbgXE0NtcRX/2DcySBrBbU3+YnezR9csoEucxRYNUbqx9DUZ8jLopvZUuemKEAtsacp3jWQuEggzvvSvpKCDoqLtNtDmdQ/6ysjTs4QT5am0GU5f/sLSOEtOBxbop+CLgFF+n33F9eXkAaiCj0tmP4KpEmSYPz58uXfvWkLgQcfY41o2YzvR65y88qJp9YGy3Sb1GNPWMlI5wQUL3pmv348+zVE0v9teHM0F++5sgBRbMwBl4SUaYOZsYE3cCO8T31vD2yHfNSbJb2m2SwKyXFqXXhe9JiiAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 August 2026 17:04:47 BST, Paolo Bonzini <pbonzini@redhat=2Ecom> wrote=
:
>> + * Atomic-flavor readers run with preemption disabled, so every
>> + * read-side critical section is bounded and running (not blocked) on
>> + * some CPU, which is what makes spinning here sane: the wait is
>> + * bounded by the longest such section=2E No index flip and no
>> + * grace-period sequence update occur, so concurrent call_srcu(),
>> + * synchronize_srcu() and srcu_barrier() are entirely unaffected=2E
>
>Making synchronize_srcu_atomic() spin in CONFIG_PREEMPT_RT is a
>slightly tall request - it's basically putting it on the same level as
>raw_spinlock=2E But if the MMU notifier guys really want to make OOM
>notifiers atomic, this would be basically the only way to do so=2E
>
>If instead it's okay to remove nonblock_start/end under
>CONFIG_PREEMPT_RT, for RT kernels I'd rather avoid
>preempt_disable/enable and only make synchronize_srcu_atomic() try to
>skip the index flip:
>
>   if (!try_synchronize_srcu(ssp))
>      synchronize_srcu_expedited(ssp);

Yeah, so in the normal case it's truly atomic but in the RT case both read=
ers and grace periods quietly start to sleep again=2E=2E=2E just like spinl=
ocks in RT=2E That seems reasonable=2E


