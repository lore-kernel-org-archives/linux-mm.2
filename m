Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A03F3C9AC
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 16:04:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0128C6B0089; Tue, 24 Feb 2026 11:04:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02816B008A; Tue, 24 Feb 2026 11:03:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA9E6B008C; Tue, 24 Feb 2026 11:03:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC7BB6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:03:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 72F111401D8
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:03:59 +0000 (UTC)
X-FDA: 84479821398.06.359540D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6C38740006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 16:03:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CYMm8kzX;
	spf=pass (imf11.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771949037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MllAX/uC1cUFlTXyRj7i2qo3BKoHFClirIAI0wCreL4=;
	b=CkyC5BZ0xVb1CTCTFYwfmZO7+TaYJK6l9FIjKLzgbfHc2EWQIHTpCN97TIS9vL/wmfrbBL
	OvI6zs+MEN2/0VfF7MI4JmNBs5/2A3NQw6zNs9IxAYZgNmWA6+r4GRpz3Nhz+S56DjgY/Q
	HoGOOrfEWS/i0g+uCt1Y8cqrdareJCs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CYMm8kzX;
	spf=pass (imf11.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771949037; a=rsa-sha256;
	cv=none;
	b=hv9F/Y5tKbuiiURBMc87PU3owuIyep8qPitjNvdoQtKtMjEThaFR2dxHGpuks6avgkzntf
	Z4Ys+79lSacXgudT/JablQNf5/+mP0QOWV6Mc/4t+DzTobdfF5lO00nFTp10t8EYdFUatX
	fx+w4ZLK1wF5DOcttQjwDWSkp2u0CfQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771949036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MllAX/uC1cUFlTXyRj7i2qo3BKoHFClirIAI0wCreL4=;
	b=CYMm8kzXsNBjuOV4BFFPrD4YYpGzATqZt7vLumGtfw61oGdYQp0bNZjpC0xZlpJeEbrmAZ
	7Df3/I4XUZqXfk4D9wFudkXc+WqPg6XO5c5fmQ37NzdmnRWI+1TFS5L3nt2/ubV71Imnds
	r2IyU8tj1D26mT+cUHM7EGs7B3u5/Yc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-209-Qn2jdw52M4qKQ7iYyUymJw-1; Tue,
 24 Feb 2026 11:03:53 -0500
X-MC-Unique: Qn2jdw52M4qKQ7iYyUymJw-1
X-Mimecast-MFC-AGG-ID: Qn2jdw52M4qKQ7iYyUymJw_1771949031
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4B891800367;
	Tue, 24 Feb 2026 16:03:49 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id AF11319560A2;
	Tue, 24 Feb 2026 16:03:42 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Tue, 24 Feb 2026 17:03:49 +0100 (CET)
Date: Tue, 24 Feb 2026 17:03:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Christian Brauner <brauner@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: Re: [PATCH v2 1/2] pid_namespace: allow opening pid_for_children
 before init was created
Message-ID: <aZ3L3cRL8AEmfQpP@redhat.com>
References: <20260223200254.4104651-1-ptikhomirov@virtuozzo.com>
 <20260223200254.4104651-2-ptikhomirov@virtuozzo.com>
 <aZ2U6TwK7rQtkTvT@redhat.com>
 <3f095a91-f052-4f38-a8e4-2e6dbc9a0c6a@virtuozzo.com>
MIME-Version: 1.0
In-Reply-To: <3f095a91-f052-4f38-a8e4-2e6dbc9a0c6a@virtuozzo.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 8fQ5h1s5DVdVQRitM4u5m1Bx2em6J5VQyDImdChWbxo_1771949031
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C38740006
X-Rspamd-Server: rspam02
X-Stat-Signature: 7k7kzpohpg49h8nrakcqckaxiqugnj6b
X-HE-Tag: 1771949037-538305
X-HE-Meta: U2FsdGVkX184SbOs1//XXzs6wqnU5EiRATfVC+W3mnpC2TV22HGqGZFFudYoJN9dL7KWMjfl9/LPkalX5RONUM1OBiqjtex5F1EI9LjITsYVAfDafeo5wNbsKpXoeZzd5UMB72XcRtZzjhJ0uTp30QB0qTK6qTfOhkKTUMFvE2a6YpIEbbo94ILn2/BQoWZGlmC3aruOeQ9N93C9pdJgFrRFv/26X6SB49rveU2KolpWADIhm0n0oJ32D/sDSAo9eb1EkLQZYsb1ELOzdf9SMnAuxGYpgpsicDXAmVJlZabUcjMIHtYafeHvEsLgBmpS2xp47ifJB3295CEGMQA9DeczaU9qXa39sWofWX7Zy8nvdbrJWn8lB7YZKn+29AZjT6VFC8Kp3cC/SBLsO7/2JvRkU+F0aDAzY1Hfhyfb6JUu5hNaeVNd5Vj2AqNxUacYUd2UJV8/AMVo7wa1n2giy8hK0viJDPnRPJHX/KonOK8xAnee9FNtgcWs1ld+kFqK127e5KtnAtSVh/SNxhvbUwrzCATzFunH/0Uj/bxZyfzA2GxYE/IPIBwqsMisXqKjFKi9+0nFsfutZo3iRTVhOy7XnPS3CgnWwqN79oYAze8wZrp8MDEnEIiwjyipM6Jb47zhNZCaK2cYSzl4V849s6wa2dEynnW457OLFnp7d6j32ybpwvDMBdZQTjX3PTZhS+BSVOBdOz4jTLKOfBeKRZQFFifgEVP2H3BD/jmQnz+Ks4ZgvdahFVCHYdhJtJaao+0lNtizHN4/lDi9mAIU9OEKbGur0lv7cVCpKxwNltuKQMIEUKu5SrOP1EXwUs6N+ATdTYF2UbMVmy/ICz+eDqvk73bALseNwMIQU8wZdj1bMkHQFsJyEZz+CIC/qnZtO47qp3e/WLT/Z2im4gSRWQ4veTkJEyBQPIwu5mZ6Hj09z1yJ0oQOcePv7uGAds7kALtzs0+LYvzDgYJVYHb
 cDLs27rY
 F+OfZuRXDk6UjwtTKg33XIcT2fHhDhLqaPQmWji3bjYSVkjZG4Uqb0EegYpzCi5O4CuQUKp23Bv7z7yoLEoP73UbxnK0hhtzkYVc2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/24, Pavel Tikhomirov wrote:
>
> On 2/24/26 13:09, Oleg Nesterov wrote:
> > On 02/23, Pavel Tikhomirov wrote:
> >>
> >> To avoid possible problems related to cpu/compiler optimizations around
> >> ->child_reaper, let's use WRITE_ONCE (additional to task_list lock)
> >> everywhere we write it and use READ_ONCE everywhere we read it without
> >> explicit lock.
> >
> > Yes, this is what I meant... but I can never recall if READ_ONCE() alone
> > is enough to make KCSAN happy...
>
> AFAICS this should be fine for memory safety of accesses to ->child_reaper.
> I would love if someone more experienced in this area would confirm.

__READ_ONCE() uses volatile cast, DEFINE_TSAN_VOLATILE_READ_WRITE()
will pass KCSAN_ACCESS_ATOMIC to check_access(), so it seems that
READ_ONCE() should be enough...

But I am not sure, I don't really understand this code.

> > I won't insist, but I think it would be better to do this in a separate
> > change for documenation purposes and for discussion.
>
> Ok, will do. It will be a bit ugly as I will first add READ_ONCE to the
> pidns_for_children_get() and then remove the hunk with it in the next patch.

Agreed, this is ugly. I almost regret I mentioned _ONCE() in the previous
discussions, I only tried to "nack" another read_lock(tasklist).

So lets avoid a separate change and WRITE_ONCE()'s in copy_process/find_child_reaper,
we can add them later if KCSAN complains, they are not needed for correctness.

But up to you, I am fine either way.

> > Perhaps something like the preparational patch below makes sense ? Not
> > sure this is actually better...
>
> This looks more universal at least, as instead of two checks we have one in one
> place. My only concern of putting the check where I put it was to avoid extra
> idr_alloc_cyclic() + idr_remove(), if we already know we don't need it. But it's
> only in last pid_namespace we can have ->child_reaper unset so we do alloc/remove
> for all other namespaces anyway in error case, should not be a big deal.

Yes...

> I will add the preparation patches: for below patch and related to _ONCE.

Again, up to you. But either way it would be nice to have a comment or at
least a note in the changelog to explain that this is also needed to avoid
the race between alloc_pid() + fail and another alloc_pid(). This is subtle.

Oleg.


