Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17A2DC5CFEE
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 22:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD336B0089; Fri, 20 Feb 2026 17:38:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45A0E6B008A; Fri, 20 Feb 2026 17:38:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CDD6B008C; Fri, 20 Feb 2026 17:38:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 113836B0089
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:38:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B13D78B397
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:38:13 +0000 (UTC)
X-FDA: 84466299666.12.51174C1
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id BA0FD1C000D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:38:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JpzUK4+G;
	spf=pass (imf18.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771627091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/XzsAqXyN/LDQgNAnCZM9h69cqY0mG7wY/zZ4ZIqdNg=;
	b=5fQPJ5g/1dcmcyu9BhmK5GTC3IwUwIYoKMbz5aIGTy8VQGXo4S/nyyAHhNrYDv5sqLceme
	MilP+lRDIdK0SaaQllQITnmmhJUJtf1WGCE4JEjRWedjbJi1ef88GuqR9y1RjA73rYTpLK
	L27temCMJg9/+3Y2oNbyNkfX0YKxp14=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JpzUK4+G;
	spf=pass (imf18.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771627091; a=rsa-sha256;
	cv=none;
	b=GR+dHnzd+fy9z7/kzy9owWgEWptx284y424ewJmQuvFWc06rOTqV+8ACcU6N3B5+rmJGuM
	bav57BtiaHfYBXh7RedZQyrU/TbZgrRm2toys7Ya65Kr+VmLkGnb76WGC/iRlb4l2LxQiD
	cZ361azbYk908Xf1iFoC+1Fhk9F08Rk=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4806ce0f97bso21031995e9.0
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771627090; x=1772231890; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/XzsAqXyN/LDQgNAnCZM9h69cqY0mG7wY/zZ4ZIqdNg=;
        b=JpzUK4+G0Fo8esKV7bq/2awuEecmXQ8Co86wEuFhHoG8BIM5fIVEZzms91hop4xp9T
         vusTXJoq8DrEThnTd6h11Bl+K5hXPgf5vlrT7bxw3P2/MJ6CtD/aezyoSmWiswihxzt4
         H4qkDMq79z2S0O4btSmyJvyHPtUE2NKg3dCgb6ipix/+Q+lRCWnUEWaICpMhmILICHSQ
         YyV2w6sscIb02w1HF5WTv8wavsdZOTJkY1QYtwny+6L8ZTbJD7GFz/lIXt6IKPDS6SJC
         YYFZHcRK+VM8hNuG4k1bTxkWjlLD3gU7DNf7R2KxVEMDBM9+fyZGbe7XziPbP9bvM6t0
         G29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771627090; x=1772231890;
        h=content-transfer-encoding:content-disposition:mime-version
         :references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/XzsAqXyN/LDQgNAnCZM9h69cqY0mG7wY/zZ4ZIqdNg=;
        b=DRjNuMLpl6jms5wrfMu0woeYuqityKRkyhSziWwhNvGM4unpG58kJrziLItqnUKGXH
         RnS50FCt9FNagToEGAEiCzF5Ugyr+BhXBrvFgIN/BY/cRM/6SDplnm5VkjFsp0pVkbOu
         yU/b/eF7Qpws1e8Wg1XPVgANEK7D3jM6yyXmMffljSb8T2lBp5iDtPeQRfriI43XcbJ9
         UoV/hD9Km5fxgjDZvFApx+CVGkfILDECN6+v9LSTvoouMvREBzOTSIioQZChUjxr2dzy
         k6fdBIsaBcBD19gAm3RnH+4Ltlrd589mrkGJt/qZBVMZZKbYenh7wfRRNWOWFWrTXRE0
         8uZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVM3L+8haQZpCtNMpkeVvasxght3oQyq1PH8x3+rNqfIEDMVOjzzMYx+awN/mP2KRudswkYR+q4Yg==@kvack.org
X-Gm-Message-State: AOJu0YzAcoc2BnCjaHP9JMxd3s23CedbaHgRAxaX1WTU0U/pHtp+Rn4L
	V01hKK3lLMD1bOw4/zLZeBXkhmLFtfEap3hdTeqTkx++NnYxyInzfs6y
X-Gm-Gg: AZuq6aJu0Wj/zDp9cJq6Refcr9fk5hbeS0pkGc37vCmPfQzm+yIeQ3b0CBflQee+kV2
	SuK5UDuCIZwCt7Umuzr9IIzlb/LBCiGAYQDyVtKEmQWQsHQdFL+aQ9ANzIRGzQzeuTsAOoYZMxH
	kk/jNhLoDVZzONy2uso1uuFXvwSy9s3H2e0GS7hWnEHszNjxK0YaiROyxf0BzG569+RXLy9Zuh3
	f5SVOidvnbgezl5/cdfXsWiiwH4QRIq1EzZ3h0Lk2IxCb5wM7nH0cCuiSbzGp3ewHQQtuAJrqMy
	NbnBte/0faW56OGeG9d8ZWhy0oIZPS6i2DKwVzYgf96cHO539rV6KD8CbitqqzvPy+VjMzBmcTj
	52L+rEH7SKT6RDPl0pPPlkGPXRb82Kd7U2C0K7H9LXlIKo81+SfoU0tnQ7i++aWeZ4PB740NHYx
	eyahQVIMR6ngv7sNqWC0JSSmdHjYl96/EpYWM=
X-Received: by 2002:a05:600c:8b71:b0:483:7980:4687 with SMTP id 5b1f17b1804b1-483a95dd932mr18372615e9.17.1771627089941;
        Fri, 20 Feb 2026 14:38:09 -0800 (PST)
Received: from WindFlash.powerhub ([2a0a:ef40:1b2a:fa01:9944:6a8c:dc37:eba5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31b3e0dsm167824285e9.1.2026.02.20.14.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 14:38:09 -0800 (PST)
From: Leonardo Bras <leobras.c@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Leonardo Bras <leobras.c@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Date: Fri, 20 Feb 2026 19:38:04 -0300
Message-ID: <aZjiTM5v-AOsaq2y@WindFlash>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aZiSHT5DwIZwc/cH@tpad>
References: <20260206143430.021026873@redhat.com> <aYs6Ju2G4bm6_tl2@tiehlicka> <aYxviLoWsrLqDU7o@tpad> <aYywl1hdBQP2_slo@tiehlicka> <aZDw6xI2izFDfuuu@WindFlash> <aZL45yORfkNvS9Rs@tiehlicka> <aZiRAa6uf4KhscJC@tpad> <aZiSHT5DwIZwc/cH@tpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7decu1h5cgqwp9f4xxgww47i553g59tq
X-Rspam-User: 
X-Rspamd-Queue-Id: BA0FD1C000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1771627091-378280
X-HE-Meta: U2FsdGVkX18GBuNYBsM6GHWZEUNoELOoYjGvuee1Ead6WB2p5j8kK+e+vnSaJqYg7K2pSza+rZ/J5Y5q3FCYBs3lA+8fxsvzR85jm3SAzZBt61BqFt14S2cb9q1CTEIqolUEjJZTmZuhyEv1Ih+lZS/bIq2pdhXFrbiri9BlGqd0VI8dKQcaHipXy2qI8CE4KtGA5qF6RauEuS7LMQzRsNTs7QcCYGRPDUoAPhp6EDOyViCNGPnq+chF3YEt7shp2MSsiiUTqpYF8c1e0JQBKQCZb4qpkK01dIfIfHI0ikCuUdti3gNQVQ+k2ek4iQ8qFDnmyCtbnC5jbA+RoseDl/RnXXEK61NQTrGUgfY3LQF3m4YzG3reZgoXmg5Z7eabOdVNu+z1vBa+dOZ/hkpjwfCdf6JHrBNbL0RONwCNIXC4rS/9tJCTeV/bItAVP6x+1KmwCj8aClbxMyegfKmE7NIm5QopqoxRVB11fmHYyA8JAD2MXzj6yHws4QM0BsFcP9lRTTY6M90UJurJmzjueSpGNEta20kpDonoS8B6Jy96VD1DYAGRfqt37KPNqnCWGveIkk2/AACXt1oHDGvHmzh0sISyPnK3byGJp1DnQIQ9j18aRhoKHsynlncPmzw0ssRJgVXV/E80gmPJOPxRgF29MMn9kemyG5OjK7zzGP0CJO8wewRjxlpYEOsv9QGJzIiPXagNN3oPGM2IXjTf7uHFXx17kDbu0rer9xWhQrye9AW/CyJtT9Dv5/Z11c7htrEZ3ujfcynMpTc+VGLSNhwmOTJOVuJt8qxYMEX/aXdVs3SmEXLu5a0XjDdV9skXKMMeF7D4LKNC2RGiSdK9gTtJ6E2BOGpC37wr/C46d98cLnNIlTUahhg7/EafcHUhUoTrOJ5JYcU7uTgliTLJyWVjJ5U38Kic2NapwTo0bXIKWNO6h4UNOUAcG6yWJqXuMl7haJyvOoF1t1w9wOR
 7OESEmpH
 DhhVbcGoVaO0edFcfoFHvk4uq8H58n3UTxy71Claerv9L96+s2QCqvSGjKC4Fh/LUSTJUphb0DaWNHbrosXPXs+VIOJICvfcamuqamm+SNFPDyC+188EFiWMYA446GIhPSilXfcHErsM2EjDAeg22TYJJn2kUrlRaSPikEvqPuN7tce1aqpvKeENdUk09iRO/alNfZrE7Fk/kV4fvzhZfgwxKGs7fb1zyeaufeHS5iaal8xI/H/NrRJzf+plnV8yACnCBBDIbHAOhjlCCqcdlbYtyZ5Y9F4PQ6ncerQNBDC1PE5WPZEf3bva8FQoxwDCI3/32vL8ZQ/n2vXML7XAChqZln+Op3xzDKr1RIJtmQ2su5cxS+SvkjaJvN3huJEPz4aUC+XmhR3Y7Nw4WIGoDsmHfjn1b+KpCShGdG5UrSbh8t881VqeINQlP4cPN3a18XKij+P4Eqsszgka6wLsVlPnSaPVhevAvn/tzvDC7VK+lYV9ilMMIUJ+H3pp76rcMbNMEgA3rFQpNqcZRw3/AN0ZmJZt5hxAyZCrB2uh87M5PIynNwyF6Hjb4EkTAPCJQAZxioK9hN6JzmaLaWscqRD51b1n/6/E6ijA1RXQ3QJChQp7m3xb90fIs9M2Wd6dcjFuielp8XqryoFqNwqm5UmTP+JHO7uQ45yMf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 01:55:57PM -0300, Marcelo Tosatti wrote:
> On Fri, Feb 20, 2026 at 01:51:13PM -0300, Marcelo Tosatti wrote:
> > On Mon, Feb 16, 2026 at 12:00:55PM +0100, Michal Hocko wrote:
> > > On Sat 14-02-26 19:02:19, Leonardo Bras wrote:
> > > > On Wed, Feb 11, 2026 at 05:38:47PM +0100, Michal Hocko wrote:
> > > > > On Wed 11-02-26 09:01:12, Marcelo Tosatti wrote:
> > > > > > On Tue, Feb 10, 2026 at 03:01:10PM +0100, Michal Hocko wrote:
> > > > > [...]
> > > > > > > What about !PREEMPT_RT? We have people running isolated workloads and
> > > > > > > these sorts of pcp disruptions are really unwelcome as well. They do not
> > > > > > > have requirements as strong as RT workloads but the underlying
> > > > > > > fundamental problem is the same. Frederic (now CCed) is working on
> > > > > > > moving those pcp book keeping activities to be executed to the return to
> > > > > > > the userspace which should be taking care of both RT and non-RT
> > > > > > > configurations AFAICS.
> > > > > > 
> > > > > > Michal,
> > > > > > 
> > > > > > For !PREEMPT_RT, _if_ you select CONFIG_QPW=y, then there is a kernel
> > > > > > boot option qpw=y/n, which controls whether the behaviour will be
> > > > > > similar (the spinlock is taken on local_lock, similar to PREEMPT_RT).
> > > > > 
> > > > > My bad. I've misread the config space of this.
> > > > > 
> > > > > > If CONFIG_QPW=n, or kernel boot option qpw=n, then only local_lock 
> > > > > > (and remote work via work_queue) is used.
> > > > > > 
> > > > > > What "pcp book keeping activities" you refer to ? I don't see how
> > > > > > moving certain activities that happen under SLUB or LRU spinlocks
> > > > > > to happen before return to userspace changes things related 
> > > > > > to avoidance of CPU interruption ?
> > > > > 
> > > > > Essentially delayed operations like pcp state flushing happens on return
> > > > > to the userspace on isolated CPUs. No locking changes are required as
> > > > > the work is still per-cpu.
> > > > > 
> > > > > In other words the approach Frederic is working on is to not change the
> > > > > locking of pcp delayed work but instead move that work into well defined
> > > > > place - i.e. return to the userspace.
> > > > > 
> > > > > Btw. have you measure the impact of preempt_disbale -> spinlock on hot
> > > > > paths like SLUB sheeves?
> > > > 
> > > > Hi Michal,
> > > > 
> > > > I have done some study on this (which I presented on Plumbers 2023):
> > > > https://lpc.events/event/17/contributions/1484/ 
> > > > 
> > > > Since they are per-cpu spinlocks, and the remote operations are not that 
> > > > frequent, as per design of the current approach, we are not supposed to see 
> > > > contention (I was not able to detect contention even after stress testing 
> > > > for weeks), nor relevant cacheline bouncing.
> > > > 
> > > > That being said, for RT local_locks already get per-cpu spinlocks, so there 
> > > > is only difference for !RT, which as you mention, does preemtp_disable():
> > > > 
> > > > The performance impact noticed was mostly about jumping around in 
> > > > executable code, as inlining spinlocks (test #2 on presentation) took care 
> > > > of most of the added extra cycles, adding about 4-14 extra cycles per 
> > > > lock/unlock cycle. (tested on memcg with kmalloc test)
> > > > 
> > > > Yeah, as expected there is some extra cycles, as we are doing extra atomic 
> > > > operations (even if in a local cacheline) in !RT case, but this could be 
> > > > enabled only if the user thinks this is an ok cost for reducing 
> > > > interruptions.
> > > > 
> > > > What do you think?
> > > 
> > > The fact that the behavior is opt-in for !RT is certainly a plus. I also
> > > do not expect the overhead to be really be really big. To me, a much
> > > more important question is which of the two approaches is easier to
> > > maintain long term. The pcp work needs to be done one way or the other.
> > > Whether we want to tweak locking or do it at a very well defined time is
> > > the bigger question.
> > 
> > Without patchset:
> > ================
> > 
> > [ 1188.050725] kmalloc_bench: Avg cycles per kmalloc: 159
> > 
> > With qpw patchset, CONFIG_QPW=n:
> > ================================
> > 
> > [   50.292190] kmalloc_bench: Avg cycles per kmalloc: 163

Weird.. with CONFIG_QPW we should see no difference.
Oh, maybe the changes in the code, such as adding a new cpu parameter in 
some functions may have caused this.

(oh, there is the migrate_disable as well)

> > 
> > With qpw patchset, CONFIG_QPW=y, qpw=0:
> > =======================================
> > 
> > [   29.872153] kmalloc_bench: Avg cycles per kmalloc: 170
> > 

Humm, what changed here is basically from

+#define qpw_lock(lock, cpu)			\
+	local_lock(lock)

to 

+#define qpw_lock(lock, cpu)								\
+	do {										\
+		if (static_branch_maybe(CONFIG_QPW_DEFAULT, &qpw_sl))			\
+			spin_lock(per_cpu_ptr(lock.sl, cpu));				\
+		else									\
+			local_lock(lock.ll);						\
+	} while (0)


So only the cost of a static branch.. maybe I did something wrong here 
with the static_branch_maybe, as any cpu branch predictor should make this 
delta close to zero.

> > 
> > With qpw patchset, CONFIG_QPW=y, qpw=1:
> > ========================================
> > 
> > [   37.494687] kmalloc_bench: Avg cycles per kmalloc: 190
> > 

20 cycles as a price for a local_lock->spinlock seems too much.
Taking in account the previous message, maybe we should work on making them 
inlined spinlocks, if not already.
(Yeah, I missed that verification :| )

> > With PREEMPT_RT enabled, qpw=0:
> > ===============================
> > 
> > [   65.163251] kmalloc_bench: Avg cycles per kmalloc: 181
> > 
> > With PREEMPT_RT enabled, no patchset:
> > =====================================
> > [   52.701639] kmalloc_bench: Avg cycles per kmalloc: 185
> > 

Nice, having the QPW patch saved some cycles :)


> > With PREEMPT_RT enabled, qpw=1:
> > ==============================
> > 
> > [   35.103830] kmalloc_bench: Avg cycles per kmalloc: 196
> 

This is odd, though. The spinlock is already there, so from qpw=0 to qpw=1 
there should be no performance change. Maybe in local_lock they do some 
optimization in their spinlock?


> #include <linux/module.h>
> #include <linux/kernel.h>
> #include <linux/slab.h>
> #include <linux/timex.h>
> #include <linux/preempt.h>
> #include <linux/irqflags.h>
> #include <linux/vmalloc.h>
> 
> MODULE_LICENSE("GPL");
> MODULE_AUTHOR("Gemini AI");
> MODULE_DESCRIPTION("A simple kmalloc performance benchmark");
> 
> static int size = 64; // Default allocation size in bytes
> module_param(size, int, 0644);
> 
> static int iterations = 1000000; // Default number of iterations
> module_param(iterations, int, 0644);
> 
> static int __init kmalloc_bench_init(void) {
>     void **ptrs;
>     cycles_t start, end;
>     uint64_t total_cycles;
>     int i;
>     pr_info("kmalloc_bench: Starting test (size=%d, iterations=%d)\n", size, iterations);
> 
>     // Allocate an array to store pointers to avoid immediate kfree-reuse optimization
>     ptrs = vmalloc(sizeof(void *) * iterations);
>     if (!ptrs) {
>         pr_err("kmalloc_bench: Failed to allocate pointer array\n");
>         return -ENOMEM;
>     }
> 
>     preempt_disable();
>     start = get_cycles();
> 
>     for (i = 0; i < iterations; i++) {
>         ptrs[i] = kmalloc(size, GFP_ATOMIC);
>     }
> 
>     end = get_cycles();
> 
>     total_cycles = end - start;
>     preempt_enable();
> 
>     pr_info("kmalloc_bench: Total cycles for %d allocs: %llu\n", iterations, total_cycles);
>     pr_info("kmalloc_bench: Avg cycles per kmalloc: %llu\n", total_cycles / iterations);
> 
>     // Cleanup
>     for (i = 0; i < iterations; i++) {
>         kfree(ptrs[i]);
>     }
>     vfree(ptrs);
> 
>     return 0;
> }
> 
> static void __exit kmalloc_bench_exit(void) {
>     pr_info("kmalloc_bench: Module unloaded\n");
> }
> 
> 


Nice!
Please collect min and max as well, maybe we can have an insight of what 
could have happened, then :)

What was the system you used for testing?

Thanks!
Leo

