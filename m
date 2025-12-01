Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EB6D116F3
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 15:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E916B0024; Mon,  1 Dec 2025 10:13:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636396B0026; Mon,  1 Dec 2025 10:13:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B396B0027; Mon,  1 Dec 2025 10:13:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 411646B0024
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:13:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4381D13A0E5
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:13:52 +0000 (UTC)
X-FDA: 84171247104.25.38F3EAF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3F6461C0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 15:13:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FKRvRYGJ;
	spf=pass (imf20.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764602030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/tlyVzi6SvS7uRQ6J4iLF5XFx5rEXURTZnzpIQU4oM=;
	b=NyMZ/UXnl8fTaLthf4UnlyKBHkJGjFDurmzf3VNH9eFWxar9byXoPLp13NhTK8lT9DeZQc
	LIS1qxLMrR7yQRGZWJE28pOOKJZ3lIH+SC1TRjrkk+hY44SoZfCeXaFxdmAlyLHrQvyzfI
	ABbxkkBMMTvbXc8saGXTatBlXDNMdok=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FKRvRYGJ;
	spf=pass (imf20.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764602030; a=rsa-sha256;
	cv=none;
	b=f6lEgIUXjKdvxFf+Gs8H9UOgm+wIZeb9DIM39INdtB8G1z/K283bqtrXrTTzgu2cAbzAxq
	UFZ7wb+BqYT80xH7taeWpy0I68dCMWWHaCslN3m33JlDrULSFxQkDcybxthy3KdchUnUAN
	OMQraWVcP4khLBomErurHLkrKglo64I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764602029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f/tlyVzi6SvS7uRQ6J4iLF5XFx5rEXURTZnzpIQU4oM=;
	b=FKRvRYGJaPcklnMoUfnCJllRqfeSFIJZOFtKIqxl7bmaO12Jdt0XKPt0v6TiXJYziAOLl0
	/ymX76dVTcpslPOBAABRIIqv7d2lBevH99Ofei/53c8uzTVapgUjdKcsvJmg/wMWPcwk/O
	A80H2aF5dLWwISlJxQI59WRsCAxdik4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-385-MtAWk9dRM6CenYT9ryiugA-1; Mon,
 01 Dec 2025 10:13:46 -0500
X-MC-Unique: MtAWk9dRM6CenYT9ryiugA-1
X-Mimecast-MFC-AGG-ID: MtAWk9dRM6CenYT9ryiugA_1764602020
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A590F1956050;
	Mon,  1 Dec 2025 15:13:39 +0000 (UTC)
Received: from fedora (unknown [10.45.224.36])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id CE22B195608E;
	Mon,  1 Dec 2025 15:13:20 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon,  1 Dec 2025 16:13:39 +0100 (CET)
Date: Mon, 1 Dec 2025 16:13:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>, Kees Cook <kees@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Serge Hallyn <serge@hallyn.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Yafang Shao <laoar.shao@gmail.com>, Helge Deller <deller@gmx.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Adrian Reber <areber@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
	Alexei Starovoitov <ast@kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	tiozhang <tiozhang@didiglobal.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	YueHaibing <yuehaibing@huawei.com>,
	Paul Moore <paul@paul-moore.com>, Aleksa Sarai <cyphar@cyphar.com>,
	Stefan Roesch <shr@devkernel.io>, Chao Yu <chao@kernel.org>,
	xu xin <xu.xin16@zte.com.cn>, Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>,
	Dave Chinner <dchinner@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	David Windsor <dwindsor@gmail.com>,
	Mateusz Guzik <mjguzik@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hans Liljestrand <ishkamiel@gmail.com>,
	Penglei Jiang <superman.xpt@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v17] exec: Fix dead-lock in de_thread with ptrace_attach
Message-ID: <aS2wj3j5qfoWDt2p@redhat.com>
References: <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <20251105143210.GA25535@redhat.com>
 <20251111-ankreiden-augen-eadcf9bbdfaa@brauner>
 <GV2PPF74270EBEE4FE6E639B899D01D8870E4C9A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <aRs4zYDhddBQFiXZ@redhat.com>
 <GV2PPF74270EBEE6F59267B0E9F28F536D0E4C9A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <aSNTNZxiQ0txISJx@redhat.com>
 <GV2PPF74270EBEEDD43083BE45C6E26F674E4DDA@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV2PPF74270EBEEDD43083BE45C6E26F674E4DDA@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: 3F6461C0010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: cy77dw1op3gkqd89q4zqrnragf7s8q4b
X-HE-Tag: 1764602030-382018
X-HE-Meta: U2FsdGVkX1/nQjYos0RFtFp+plTWYLuhTEdv23g+yZ0VbZeUCaHgnyroVuQahMjQLoqChMil21NllyDHQKTCoUdHEnLvHFMUEP5r834oaYymOzvBlih+FK/PMUU/YdGi0FN6+NlZmBTL/jYYxdwBEs7LcGEzyY5PGGaOyLq+N3wqUKaeCbundPBTiCdFWJ2V01gXaeKSUluVF2WXKSiHy+lvgu763MM0m8ov+MdPF9rw7xYNYP+HIKxcLtJoijuSiqujrWVQyAeuiSRiJH4YkkuDJJDfxJ2ETHUjGmrC5IG5JuCGnFsZsAPwWKnyrR5pDGon+RpXc26Khq29qMi5K4q0j0u/+Ib6S2r2V9TSyJqf0XohayAWv0F3fPuzyIOnGF0YtMfRCD2C3rehjSlUylnGCZMC6xxf9ES0HLo3c2ox7ltMabQeOeOG2XZYZ232pb2RI7MQ/VATfOgyWqI+DrGNgP7aMAjvjOM4esLXipTUzQDkNgeULvLlQzCM+k+mvMndOZniMzjIkMvjGqna7c74lHyLHV576yKzDkOPyYNTXHVqUzdNiz963BSfMy905Lvg7QtcsdiymqIbcwl9aJlYZd5RwR2nneTc0jfJ2t1QNlqEl4T06omzpnxQxO6Dp/G84eAon1p4n9WdUMW7yvTrL6b8s1LyuMQ1T/F4TaLCavheVjHxeLHCUK/rJ+zDWpOtQ16VCoZnaAAyugi3Qb7mC+OMA93ynJdNR0NWuaD58Hv8bMIjfKbsiwQEc8C+aLIZuRLQcS67j9UWUMhiQYoOVr/Pc9jPaEYzzlSAocjc3XB1nM3ATFOxbW1Bn2x9EwL3XjbHK87SeMzDJUNFjwODjdKJfA6wHTtRjj158HuHKMrQhv7zB8mvQILpf515WkdOLEsz3Mu+1gA4dGVEgz3AXRG2ssz0KZWjf1X/M0EZ31NRmEw5Nxv537uwCOdgijsWTgPWNtThwaWCTL1
 qMw0kDWK
 e9fEJon4O8WiMMwqD77SBwou3Rj/SF6LQ1p2WQlBCnytttyAzUPVkhpYHV3piVI2+9ku9BkXGhGW8AISZbQ+CoJR7EZ1wasix2SmUU6AlYvse58DrIS3Ek12lHXBKW3G78xYv+rsyehPPNOKsvP+QjM8pyciHHMijMj7STpP18oOH+w9Vyi01IaEBT/OsCR9IxM6z1d5g7XB4hIsyYcWO9xI5xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/29, Bernd Edlinger wrote:
>
> On 11/23/25 19:32, Oleg Nesterov wrote:
> > I don't follow. Do you mean PREEMPT_RT ?
> >
> > If yes. In this case spin_lock_irq() is rt_spin_lock() which doesn't disable irqs,
> > it does rt_lock_lock() (takes rt_mutex) + migrate_disable().
> >
> > I do think that spin/mutex/whatever_unlock() is always safe. In any order, and
> > regardless of RT.
> >
>
> It is hard to follow how linux implements that spin_lock_irq exactly,

Yes ;)

> but
> to me it looks like it is done this way:
>
> include/linux/spinlock_api_smp.h:static inline void __raw_spin_lock_irq(raw_spinlock_t *lock)
> include/linux/spinlock_api_smp.h-{
> include/linux/spinlock_api_smp.h-       local_irq_disable();
> include/linux/spinlock_api_smp.h-       preempt_disable();
> include/linux/spinlock_api_smp.h-       spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
> include/linux/spinlock_api_smp.h-       LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
> include/linux/spinlock_api_smp.h-}

Again, I will assume you mean RT.

In this case spinlock_t and raw_spinlock_t are not the same thing.

include/linux/spinlock_types.h:

	typedef struct spinlock {
		struct rt_mutex_base	lock;
	#ifdef CONFIG_DEBUG_LOCK_ALLOC
		struct lockdep_map	dep_map;
	#endif
	} spinlock_t;

include/linux/spinlock_rt.h:

	static __always_inline void spin_lock_irq(spinlock_t *lock)
	{
		rt_spin_lock(lock);
	}

rt_spin_lock() doesn't disable irqs, it takes "rt_mutex_base lock" and
disables migration.


> so an explicit task switch while locka_irq_disable looks
> very dangerous to me.

raw_spin_lock_irq() disables irqs/preemption regardless of RT, task switch
is not possible.

> Do you know other places where such
> a code pattern is used?

For example, double_lock_irq(). See task_numa_group(),

	double_lock_irq(&my_grp->lock, &grp->lock);

	....

	spin_unlock(&my_grp->lock);
	spin_unlock_irq(&grp->lock);

this can unlock the locks in reverse order.

I am sure there are more examples.

> I do just ask, because a close look at those might reveal
> some serious bugs, WDYT?

See above, I don't understand your concerns...

Oleg.


