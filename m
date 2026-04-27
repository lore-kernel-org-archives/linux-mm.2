Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E0D9FF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9E1F6B008C; Mon, 27 Apr 2026 06:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4DD06B0092; Mon, 27 Apr 2026 06:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B63EF6B0093; Mon, 27 Apr 2026 06:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A11E36B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:44:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B796C046E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:44:06 +0000 (UTC)
X-FDA: 84704000892.01.4D06EF5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C0789140002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:44:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K8qaMwJC;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777286644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TbutU5ZwoGRvmAgJqQ0DEtGQomyedCE5ty8Rp4BqQQ=;
	b=S189nDD7NW66Mnjl4FSCW5NgS+1hLDntk7RPkefB2GC1n15HRZix4YBjCso7i3tGM4hvuo
	5GQeCjNzLR3ir8Q/m3obHSPo5f9uQV4lJxbXkraWZswN19lv7uy3V5r5IYTqkdgMAUUTom
	JYzQJDxEe3OFT200ZTf6+z86OEMIy3Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=K8qaMwJC;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777286644; a=rsa-sha256;
	cv=none;
	b=FaJROpZ5tQKxmiaYkUN+IwEdcZn+LPj+/5WdtHif6phdN4jnYe2iHPVWEj9D6udyhUS616
	m0E0WNx6OClbSLq/Ern8YFyXlVz0WhyJEG2l9txTud3DF1UrphMwcl0fV23twp/YV2uqrK
	dqNX7H2OvIUyraZ4TcfXFboxERE6LIg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 05EC160138;
	Mon, 27 Apr 2026 10:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500D9C2BCB4;
	Mon, 27 Apr 2026 10:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777286643;
	bh=iTndbkVHwjqibIZVTSPWbo8ojcxJAy0mB2LeI5+NXD8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=K8qaMwJCaqiC/yQFukTnoCCKBEdcWHxwZ2CKVJKGiGXAeCJT49g4amyjQTrZv6yJl
	 EeazLQ2ZXtADk4bUag8sm3blu2HWaiT8O/wPFYsFl6WlK17luWwBc2wQTEmq+YJV9v
	 YPk4oUIeYEmjNT79i47KevFsVW5wSqODNbJm+d2k=
Date: Mon, 27 Apr 2026 03:44:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: shakeel.butt@linux.dev, syzbot
 <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com,
 vbabka@kernel.org, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [syzbot] [mm?] WARNING: bad unlock balance in do_wp_page
Message-Id: <20260427034402.096cb95de92bec15becc78bb@linux-foundation.org>
In-Reply-To: <f0ab0c7a-c597-41a8-92b3-4424b12b1b1e@linux.dev>
References: <69edca15.170a0220.38e3f1.0000.GAE@google.com>
	<20260426034938.db29d74982a8eb8463f8cf3a@linux-foundation.org>
	<e7187a21-7114-4f42-bf8b-90d6e6b54fa2@linux.dev>
	<20260426105532.43768b24a42744f1b52fdff2@linux-foundation.org>
	<3591c663-a4a9-4c22-97cf-b58b2e7d8a41@linux.dev>
	<f0ab0c7a-c597-41a8-92b3-4424b12b1b1e@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mfrb9x7dgpsak4zbi4zo9zdkccptaqne
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C0789140002
X-Rspam-User: 
X-HE-Tag: 1777286644-142948
X-HE-Meta: U2FsdGVkX1+fS92rSF+pvinG/hrkkiabyB7gHwXfoylH1e+QauC1vH6Cx/I1sxvFTOEqEPe1NkA4WiI4reURkf01DSgF7dZhclJENePGD/t/5zLNnrRu6sC1y/IQbominvOv5UlIIcKdZSgXib2qPW+mUQI1TUS/fViKJ2Tkui95c4gIxR6lwSudPFs8DW4OIAvGjMkaJYcuyDR13XaX6WV/aRbwtYvCOM5ZOHx6O626/AT0cRo5z0MDbK39IJv8mXGSXNxM+8scvoCqBrMQIQvtJpIbk6dyckQDbZ/3XtAGRKPtxfS3mz/Um0e71EuE/XHQVuvsWbkqhKKLb1yro84aNMKgvpkRvRRICq8EGRq4ILCRPZJTL8lO5MVpYTTTNAIkQ7Trol8p+zjZxgbQYULRp8my45N9r8wE5EKwkQ/nVv2Z70Lj7bSBx+PK/YC1nzz0PuRwhuvRAZ1G/ESAICfsQys3+C17W21E2SwJE9jgaW6TqLg56Xa6rIMxe4ZuCPV3+zdQODSwVGiq2jA+jjfj3odGlC7EtXQ2O9g1rAwUuZOc4CvXmnOJvYrxJV9wbUnSy4WQnW+DAJlvc+QP1I4ZZB3d8lXwOxgWsNg8weU+iL1hJOt0ylQxJWc+zzrO/Xft5M9EDqNy3+/XO4kHCEz683kHgrQeQ7SWOv43uI/BY/a8xhe1Me0JRgyeKBKb8v3Vcbfr8S+dRomuvQVR/Q57zjl3df92/tlXSmelK8jzJONIOmG99f3NUt6lyKB+dScM+ojSFQhozNrqq94aHO0TRMihUjM4eojQ5UqXn1XBg7l5Bc3DJZ+Vr+QzdX6kTEaHXZF3mXuqiWNseSZUnHJcTQbFYCpWRshjWiKkp+KXkqptkqztA+WpD0C6Yv9UKfMbMArvWnD7zh+SOTxbQAvohuptH2ego9DYqCALHw3bt+zeYE58IXboD7ZOqoUzua4CkWCk+QKX8VdpOgs
 tSSbrAoO
 jE2QNmC+NjMCSCF1JF3VdD9+DzyfaWR2dHuiU+uKUk1CarImwkHdN0xugUkwE7it7j++2TxkG5p76APiqC7H6mB/uNNsVbpiMA/iyPsNNlC0lEBU4AqZQkgxlw0vwI79i1PZ3t9px7g7GgZxpTV2hh0RRbVbPldUicqcDuBKSTUaNq67d0NCA+SQsXHKG0adRPJrE6aauy3ui765cZNyrj6Sp99OBllEY7zTAI8KKPfTpVRgDvE7tbsvq1ALqIkeJARuByToUO1hV+xEglCQfrSUCjXSfzNOt0GuDtRYH2afZYTPsX6b8DqLhi7gPM5Pv41lio4FRWDn2jcGzyQZyufDe88kYPPMbzKLOhW6wNow5T68sn8yDn4iurc0BUCzfbb/j8+58DgUYoWz0kAcFit8edIxC1SYuehskcSThfCyWZvd7krPwoLnvtKDYZz4VkvfUOIWT9pajM2DUWeh3dOUE3c+9cGK8jm51BzhcjZCeH3BxhG3oOJQCzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 17:43:38 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

>=20
> Alright, it seems I have successfully reproduced it:
> (The reproducer is attached at the bottom of this email.)

That's a lot of code.  Thanks for doing that.  Maybe there's something
here we can put into selftests/

> >>
> >>> However, in a production environment, this is practically impossible.
> >>
> >> Can you expand on this?
> >>
> >> sysbot isn't a production environment ;)
> >=20
> > Rebinding only works when the hierarchy is completely empty. This is
> > generally not the case in a production environment (e.g. when systemd
> > is used).
> >=20
> > BTW, it seems rebinding is about to be deprecated:
> >=20
> > cgroup1_reconfigure
> > --> pr_warn("option changes via remount are deprecated (pid=3D%d comm=
=3D%s)\n",
> >  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 task_tgid_nr(current), current->comm=
);
> >=20
> > Also, it appears the current memcg subsystem assumes that
> > cgroup_subsys_on_dfl(memory_cgrp_subsys) cannot be changed at runtime.
> > (Please correct me if I missed anything.)
> >=20
> > If we can get a reproducer, we can try the following fix, or simply drop
> > rebinding altogether?

We'll want something which is applicable to 7.1-rcX please.  Removal of
rebinding sounds like something we'd address in 7.2 or later.

> >  From 6ae41b91339625dd7bf0f819f775f26e78171a73 Mon Sep 17 00:00:00 2001
> > From: Qi Zheng <zhengqi.arch@bytedance.com>
> > Date: Mon, 27 Apr 2026 11:20:21 +0800
> > Subject: [PATCH] mm: memcontrol: fix rcu unbalance in
> >  =A0get_non_dying_memcg_end()
> >=20
> > Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> > ---
> >  =A0mm/memcontrol.c | 30 ++++++++++++++++++++----------
> >  =A01 file changed, 20 insertions(+), 10 deletions(-)
>=20
> With the above patch applied, the warnings are gone.
>=20
> If no one objects, I'll submit the formal fix. Or should we actually
> just remove rebinding instead?

I suggest we just fix up current -rc please.


