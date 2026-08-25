Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94484C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 19:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60A536B008A; Tue, 25 Aug 2026 15:58:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 594416B008C; Tue, 25 Aug 2026 15:58:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4606E6B0092; Tue, 25 Aug 2026 15:58:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F21F36B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:58:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8631F401C7
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:58:41 +0000 (UTC)
X-FDA: 85140854442.13.FD42DFF
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf15.hostedemail.com (Postfix) with ESMTP id CAB8EA0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 19:58:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tMgHf3i2;
	spf=pass (imf15.hostedemail.com: domain of 37vONagYKCGkZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=37vONagYKCGkZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787687919;
	b=TSH5zd5ACf49yZQ+iaRYB1UtuRENhuIEESr7uxjkiwWZVqx60xy30Ccn0nxy+O20BWaFvd
	qkRkqPzgSUrdvWzN6LgbQuo4BsTjjZfR01Ox0e/mb4XSpmPzRsLSU796dUqdcyoWyVhsQa
	8VjqKCz9XSZk1Qn9JzjdyTQIdSUCPJI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tMgHf3i2;
	spf=pass (imf15.hostedemail.com: domain of 37vONagYKCGkZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=37vONagYKCGkZLHUQJNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--seanjc.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787687919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pw5HPga/49LaG41hAzsub+JW3+Qdxi0vmGANh8Af4Kg=;
	b=3JHPF+N9g7m2i+IqNot9WsaBesMHyOkz/jxu+xEYso5f9Km/trIS8Cnzdf6sMU6m/KMS6f
	QDvm1c2IYz7Mbb/YdvXPN5G7wQGGKCHfkYpufVeppSmMKBvtyEfDG9cNuySg0c42QfcFnh
	gV6+Ez+HCV+y+0Vah9zPYXvpByD8I7k=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ccb6823efcso2363115ad.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787687919; x=1788292719; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pw5HPga/49LaG41hAzsub+JW3+Qdxi0vmGANh8Af4Kg=;
        b=tMgHf3i2C0urSq5ZM8OJ5fLns/YHDGvqvlkAdc2ooU87C3YJc+h0EjHbBj+NMdVefb
         rrLsPWghyLGTi9SWJDL53psjtYS0tMMIvS8XXh28UQf34bPopKJIcMj2vXSx3wDpiGQf
         TSkjpEfKiA8fQNvnrylccfrUwqpPopt2LqUxtZ9YjJgNEgq99JTguwoq4Tp8xPibruQ1
         zMKFWBNIkLV+u8DPFT4NfGj3NDFs32d/JzaMgBqwC9Q6YwsVGvNzVz8Dp1gRghCT4pIE
         ddyYh7W13SJ9E5hg083G1Z904t+LQ/RGXFVdxC7zxPy1BtZ2FU9MSjHkbfOX4CkWj36G
         1RPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787687919; x=1788292719;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pw5HPga/49LaG41hAzsub+JW3+Qdxi0vmGANh8Af4Kg=;
        b=RrefFJWjlGI6XAWoLtPZj+2K513RSyMV9aDdjTTjRADsBopRM5BvYY9VzZo75k+DQw
         mlM/w5rSRLidXuKDfS8tethwaPvIIvvOfC8QFiM8TzsEtNdLWfhytl0U/Y0mXVhL0FPe
         548eczJ7DktXCUW2GxL0L7iy/HJA+BDSYfN+WZLqBpHy5b7JYgiFx0l+fNt15O7pQLeQ
         AprBo5T96qM9qem2iUxpZcHlIcS35PW+Tcmmph6AUPfm5wcwfKRLhol5lQb2LJ0ksktw
         HpNIpvSEwl1ywLMaEyIKjUzKjdBRcXeSxlGr78ZFw1j19nz1mhYMxvvbmm6UKmQoMhl1
         4l3g==
X-Forwarded-Encrypted: i=1; AHgh+RpqwtcTOUlh1ucwbAASv8/7jOpe1ENwC3iDhQ/dZf8fgFtOYBb+XpMcHKM7725IqPf/IpBQ17UjNA==@kvack.org
X-Gm-Message-State: AFuF++kaMMR3CUGVdBTOOW++Q7UKuoQXihb1bymype9AyY/Er2hypm5R
	NhFOFomeXoEimRh6h/HvZOmNnx60+qySPwY3+D3sICaFdu5dRK5VK5CLVjbybSuJZ/2ePK3meqr
	zOR6rIw==
X-Received: from plyw15.prod.google.com ([2002:a17:902:d70f:b0:2cc:6206:58ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19ce:b0:2d6:f6ba:263d
 with SMTP id d9443c01a7336-2d707aafd1fmr12835735ad.7.1787687918385; Tue, 25
 Aug 2026 12:58:38 -0700 (PDT)
Date: Tue, 25 Aug 2026 12:58:37 -0700
In-Reply-To: <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
Mime-Version: 1.0
References: <333c4cdb-8f34-4e3f-a47f-961f47e089a0@paulmck-laptop>
 <11dcf5a87125451897982f728c1f65a5151987e4.camel@infradead.org>
 <69567965-48fd-48c5-abb6-0699d7f5bd16@paulmck-laptop> <124af87fb49c267eeb26b8b4d952b9b1a5b3fb68.camel@infradead.org>
 <9427a8e0-3ba6-4f31-a35d-54429bd7e071@paulmck-laptop> <3d0463b6099d4fcde9a025a2f9e231d75303b61c.camel@infradead.org>
 <b0be19e9-b0ae-48de-bef6-d905ee007c8a@paulmck-laptop>
Message-ID: <ao3z7Rtw2FROkVpy@google.com>
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
From: Sean Christopherson <seanjc@google.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Jerome Glisse <jglisse@redhat.com>, Christian Koenig <christian.koenig@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: zfytmfkr5qb1zbdd4y41iku4kg1kj85f
X-Rspamd-Queue-Id: CAB8EA0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787687919-502866
X-HE-Meta: U2FsdGVkX19iQ421CNYGzJMLGsPxIi7zPhjsI/eut3RZsnaB7fVDPGqRPgotRF9lTfUZu1KXQdAbm9BxDD4ZT37eScalLJhrVwAidCOsFgAo7QkawNE5EyQONZwKseMKS65vRLws87cIeXSFAeYkZD8jKsdzara2IDkvvH8QKdEUFi4AtshyjzV9kBMhvUCRA94lvdQ8Bvf/hLwVpi/aqvz816/4GLJpvbWfK1oG9sKmhiIoajS6aIyDWUADQYr7S+mtlfyiqQId2Pc10jruqW63bGVlRXFDmccrgDbgXZqS4VdHXTBIwH3XEf0zh4GceWlWwkxQdZeXOewSgSpk42tE8HdUc+kB44vrrYw0iiA1ezZAv4IwejkG/X+3AMzAw15xZKzVRCjT7D5ViI0HkGJc0QFsXAknHLK7AlA4zNMUKe1u3522rd/R36x3ZLhREpRmNhIx9/+P0V/oV3zRjUoenHeq0KLeAJOBpCscoRSwUOG2GYZF4f+mE8MVJzjVszIs1vUCjJuE0QAkZOu6ToTc4Cs8D4oK8gZ6clrbcGRfsZpB+BcXrFHhPkBYHe/994PEyeOeyKOkRUO5qoHFlTzGnD8yHyjC0xlyQhloWJs+fSp6Kdvo/deulpRBT6yChdyNH28nO0kFcutVpWQgC938pTp5D/FjqKU20N5ixtXn6+WAWuUT7gCDfTHhJqZvW4We3Cycoa1jECkPNNRigzq01ofXMACsqa5zg1Vt1W60x8Pu40Z1VkIUpNh8URzyqPaKmr0TufoF/lX953yheJZ/fKYaY15T6XkdP9jzbo2JT6XqwQBO2v2daKfu4igCeo6T7ZUT0k5Fs9pySiGycSGZBPuOkqY/QOJ4E7MdzwzTIzgrqDJOJcXXnUAy0dA1LhnD+DqCWe4MSWRbGSjBy6qSu2I2OMCPwIOVn1BxcqrOKsISgIKZy4+71UieKkicKtqu+G1MI96OQV+s0LP
 5ETUU0+f
 wmlBZLWCrNow3gBVuFjIzNz3ws/n3MttSDoQaEqKftBhvd7j73wzqVKKsJZFx8+oI9I8w8ocY9Xm2Z2c3uAsR3tFJqq1AGIzna1qDVItE/yprPXxsvUfcJ7IUbE3c6qtORsf9KGX+nqe0YCwXt04t7awmQROiOCynOcCvrJX5qKJlqme+OBn7r9UajzAZ9CLzuZ48Q0lKzXcW5dok5JnreX7sFJlbdqDbzzAzuhO1+6TXwKw0I4QAKMacoYY1Hfd/Ws1VEKHIu+Pojw8QR4FmZ29h+7XDP9V/pr6wp6WY874ZVx3NVwVVBgqf45Z6MnHpcqyyfLy05/FZvLWbcVNpGAQtpm9u+gqSjvH3aaponc3aDlWKUyRHnU42i/XhJFh+SKR1t6qQxx+RyvCt0Y6bVFpzmrQOXip8A9dIh3+Hb0uWKlOvPVBGc0/zb1ir9ogop546H/N9rVeet5pkEaerT4RkzF3E+/HlOSMp3wkzvKB3H9vEmm4JowUpdzrTyNuXpxanrO+45pE4vpVDx3vw/kE9Iv39F3MAw+hx1lQtg6OnNpQRQMizdzGS3lLwJllNPny3c/7+nRBaK5AeMDT9PpnrJr2Qp6jQ80ZzvaqM8J7s2QGjvouWxQ9yhemLKF1xJRCgcc9VF1p/68uqoebprMsy+vzvBL0ttx+GxVuoWszhJ8tcQWXRkjKph5KJjUIhg6Sr33HOHoSMt1KqOmHiVPacomk3JeF2zwXwHsi+9jkpqSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026, Paul E. McKenney wrote:
> On Tue, Aug 25, 2026 at 06:48:08PM +0100, David Woodhouse wrote:
> > On Tue, 2026-08-25 at 10:19 -0700, Paul E. McKenney wrote:
> > > On Tue, Aug 25, 2026 at 06:05:54PM +0100, David Woodhouse wrote:
> > > > On Tue, 2026-08-25 at 09:47 -0700, Paul E. McKenney wrote:
> > > > >=20
> > > > > On the tail latencies...
> > > > >=20
> > > > > The easiest way to reduce them is to require that preemption be d=
isabled
> > > > > across srcu_read_lock_atomic()/srcu_read_unlock_atomic() regions =
and
> > > > > across all calls to synchronize_srcu_atomic().=C2=A0 Without that=
, the problem
> > > > > is that the scheduler does not know that the spinning is pointles=
s,
> > > > > and we cannot use the blocking primitives that we could otherwise=
 use
> > > > > to tell it what is going on.
> > > > >=20
> > > > > So, is it feasible to simply require preemption be disabled as ca=
lled
> > > > > out above?
> > > >=20
> > > > I'd experimented with disabling it around the GP driver loop in
> > > > synchronize_srcu_atomic() as seen in
> > > > https://git.infradead.org/?p=3Dusers/dwmw2/linux.git;a=3Dcommitdiff=
;h=3D07165e79340e
> > > > and that didn't seem to change anything (which seems reasonable, as
> > > > it's the *waiters* that were descheduled, not the threads driving t=
he
> > > > actual GP). So your suggestion that we do it around the whole funct=
ion
> > > > certainly makes sense too. I'll test it.
> > > >=20
> > > > I do wonder if we're really doing the right thing here by selfishly
> > > > blocking preemption because we want a specific tail latency to rema=
in
> > > > low in a contended system. Maybe we should allow preemption and tru=
st
> > > > that the right thing will happen?

In my experience, preempting MMU operations, especially mmu_notifier invali=
dations,
is rarely a good idea.  E.g. see commit d02c357e5bfa ("KVM: x86/mmu: Retry =
fault
before acquiring mmu_lock if mapping is changing"), which worked around an =
issue
where KVM would drop mmu_lock and yield in an mmu_notifier callback on pree=
mptible
kernels.  We "fixed" the issue by avoiding mmu_lock contention, because it =
was the
easiest fix and benefited all setups, but the underlying problem that made =
us take
action was very specifically yielding mmu_lock on preemptible kernels.

This isn't exactly the same, but it sounds quite similar: being greedy and =
hogging
the CPU to complete an operation can actually be beneficial for overall thr=
oughput,
not just for the immediate operation's latency, by avoiding trash and overh=
ead that
is incurred as a result of yielding or being preempted.

> > > > Maybe the p100 isn't the right benchmark to be chasing... I'm looki=
ng
> > > > at it because Sean expressed concerns about it, but it's not the on=
ly
> > > > consideration.
> > >=20
> > > My concern is algorithmic, not benchmark optimization.
> > >=20
> > > Suppose that there is only one CPU, or, alternatively, that one of th=
e
> > > atomic SRCU readers is pinned to the same CPU occupied by the (higher
> > > priority) task running synchronize_srcu_atomic().=C2=A0 In this case,=
 the
> > > call to synchronize_srcu_atomic() uselessly burns CPU time until its
> > > priority decays, real-time throttling kicks in, or in some configurat=
ions,
> > > maybe never.
> >=20
> > I certainly have no problem with a blanket preempt_disable() around
> > both sides for algorithmic reasons. As long as we aren't *just* doing
> > it for the selfish reasons I described.=20
>=20
> Suppose I simply disable preemption in srcu_read_lock_atomic(),
> enable it in srcu_read_unlock_atomic(), and disable it internally to
> synchronize_srcu_atomic()?  It might be against all RCU tradition,
> but might also be easier to use.  ;-)
>=20
> > > Requiring preemption be disabled across both the atomic SRCU readers
> > > and the synchronize_srcu_atomic() avoids this, at least when running =
on
> > > bare metal.=C2=A0 My (perhaps naive) hope is that guest OSes get some=
 use
> > > out of those cpu_relax() calls.
> >=20
> > Yeah, an overcommited guest vCPU should be able to get preempted there
> > by the hypervisor, allowing other vCPUs to run.
>=20
> Whew!!!  ;-)

Ya, and on KVM x86 at least, cpu_relax() =3D> PAUSE will conditionally trig=
ger a
VM-Exit after enough spins that causes KVM-the-host to try to yield the vCP=
U to
another vCPU in the same VM.  The intended use case is to detect when a vCP=
U is
spinning waiting for a lock, to try and give cycles to the vCPU that is hol=
ding
said lock.  IIUC, the same principle should apply here.

