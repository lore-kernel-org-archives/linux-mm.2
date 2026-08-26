Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F35FC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EE3A6B008C; Wed, 26 Aug 2026 03:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6916B0092; Wed, 26 Aug 2026 03:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F1D6B0095; Wed, 26 Aug 2026 03:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4166B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:32:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19CBFC02C2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:32:44 +0000 (UTC)
X-FDA: 85142603448.01.0C8CB4F
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5B96280002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:32:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=VMQGacdc;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=z2MdUAMa;
	spf=pass (imf30.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787729562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0qYw6dI/lOMP/K9P716HVlCet1n8A6GD/0q9HLVzrs=;
	b=JRPOidbQwcPQxu1Jw5egWDsuQcf1GGvWLC0yJOUPwdxJwTOG82UKsNnLaO2j5ztt4E+Xad
	Sx37ulD6HsAyme+pY9AE5Ifn1JzQ5uuODIMThQQNAqEG1zBusA06gAGsdYcceh2EnA9xT9
	xD0g8fckah8Py8KnQu0xLTpe4qux4g4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787729562;
	b=O4rGrzKl8cXb+qrX1+bl8Kg75YHq2P37J+4jVbO38WYrdYkKGZJBviajxVkl90Rns19o8E
	cLqd+lbVL7tMWMM9xfLPynWQXXtrh/X+SFEYPfLo2wKW+qi0XkIjeWTowoz+OYhKxbtLPf
	J9yKn5Sp495VI7W7JI3UwFrX+R3exW8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=VMQGacdc;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=z2MdUAMa;
	spf=pass (imf30.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Wed, 26 Aug 2026 09:32:33 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1787729555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v0qYw6dI/lOMP/K9P716HVlCet1n8A6GD/0q9HLVzrs=;
	b=VMQGacdcvMuc2msrSxPg8sy3s578U8lucEvh/cZE4V/kuiAr7MmALRl2ClMviXBxGNm52k
	DbiAwAFtpBiS4r3m3/8x0wfzKkcxmLnRbHqy2n/cBIG430HZhfYOX7I4F1BCgRQ1KPQKgl
	1iUepfgOJ9GiAGAOEDW3L01Ncp2uMFz/i9BWDfUuLNvR1nhKtFS1iI25NZVTck5Dwj5q6q
	8KosOZZD7dw+zVRg/8noxbbDhR8wEdzdU4bGFERhcMcIEAMuvENanuTyijfYqGjTNnsK9r
	TzT8azEkht+nlDD3AQN2+zNGXHPocQGutv2HAv/yecSdl7SWLMdzlhhdv2f8QA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1787729555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v0qYw6dI/lOMP/K9P716HVlCet1n8A6GD/0q9HLVzrs=;
	b=z2MdUAMaarXzYXJUnZ9mDq2Oq8fo1ufaKMNgfCTuwIciKR+qIP2KDHfk5DiFU/9/pyr2Ng
	e/k7E2VBHGxqtJBQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Jerome Glisse <jglisse@redhat.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260826073233.T-KtFXmj@linutronix.de>
References: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
 <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop>
 <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop>
 <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
 <ao3z7Rtw2FROkVpy@google.com>
 <d4f8ff92-08ac-4253-b647-f9e95c66698d@paulmck-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <d4f8ff92-08ac-4253-b647-f9e95c66698d@paulmck-laptop>
X-Stat-Signature: 7abxi3gkcp1kok8q7na5su4bce1p6dgb
X-Rspamd-Queue-Id: 5B96280002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787729562-3689
X-HE-Meta: U2FsdGVkX19xYci2OHvYRPqBrofTz3sE17Ft2X5LlZw7c89qeyR52g2fXOqd4FugnCYmXcJHerd4lgfoXuNBystZbdRIZVJ4JxsshaTxuOQ6wuoJvqiPR5UiecBpQXZrQdJHRfKJ5aqD0426WATrJlVq/pZQirMzGxOLy13j0HfOmKjNzZSPb3A2QsYHsLvn+vd9w/Vv6g/SwyP5wIAj+UkGt3yIMxIpr0gUbMdPW5dPj6vI1El4sxp8uk6MQOWgHf+2F+63iBW/iC41ZOYAG8rNuNXxt9YQyt4CGdEcKb7HxatiGoDy0cWKRZhgDj02ah/+VOmDOLtYDqU5R21TDbOz6n64x7Q0RaCG4jOoXDW26HZPirJPIjXhiFuF6HJUhkkrvscdDCL0H7vO9T5Z+cJOSMEBCqWyC3xwEMStvbWouiAh7GQ/bpd2/lIO78i3+95loNxoIRtKq0d6Oct1EbW7DKfnjozO3S33kUgQY4MmkEyBopZt+kzfdViaOGw/jjTK6dWEQly7TIPUdq8jnB2/sTdUONLry+zRFOY0/z1lh24dsEkJ7bPa9RQQMZSgBsKQi2elM/v8nr0NgmGNj2L9v3mVmehieV35qcKgaEEV+hckBWVICplHQ6N+j79+vbyES/QapfSWDiuCXDFSR1unBMMhnZNZDaBYjY3RPaGDRX4OSjL+vIKfsCkJk0cPYu5mfyAKK6cm8zfaZuS3Y2/L2wIs4myer2+x6f5q5g9aHUUzGanihUKIr3V0WNCUn1zw8wUasj9eqWd1t1zZ99qUJPfUfXGmgcjBdfHXJymwYS6zklukZRewzK2tZKm/UWf3KI7FK9x9MamPpY+UcZyBUreoEnWQhTXVPDrCcl+HSGYoSHZMHOwD6pYlOJGs5HLboxAZnaYJQQGfXdJhQd297TO/e5Gb5U3eSRvft4Tlat5vQ1f6xgCFSYOKMqnCo4naFlGuAqf1bHs5Y4u
 CHToO/7W
 KZEDBsFjuFZArNopRCmfcD3YVOkQLDg1W/Fs0vFzB8bmzVm011Zx99pHYX3Fsfig6bZMr4NnRt9PaIZ4JZFXOloe3pN5QXMC5s0+/UzKYcPSjfuPhkdUv/f2B6iuT1tTyOmCb8g3QjFIkMViKeqmqpcJKpkMLw9CdB4sjOEHD+UmL+D4cMK4rU+0s6cSc1WW1kblYtFgeCUUrCj15KLdmWKBrrRXdtwu+3KJ0w7ln5MJw750CZeq8YcEhww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-25 13:51:14 [-0700], Paul E. McKenney wrote:
> Very good, preemption disabling it is!  It is quite possible that the
> PREEMPT_RT guys will need something else, but one thing at a time.

This reminds me of classic RCU ;) It might work in this use case but I
am afraid that other users might come along where it actually hurts.
With PREEMPT LAZY the preemption within the read-section should
hopefully be the exception.

=E2=80=A6
> 							Thanx, Paul

Sebastian

