Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A7FC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E294D6B0092; Mon, 14 Sep 2026 13:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDA1F6B0093; Mon, 14 Sep 2026 13:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA28B6B0095; Mon, 14 Sep 2026 13:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC7C6B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:05:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F57A1A01D5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:05:56 +0000 (UTC)
X-FDA: 85212995112.02.057C5B2
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42779A000A
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:05:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=DMYKoxv+;
	spf=pass (imf15.hostedemail.com: domain of paul@paul-moore.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789405554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avx3LuQUj0eIvtk4vMhq4fafE3JrorX2BSEZUs9YMHI=;
	b=77EPhZzkvnQ+wZgaalHVPMzPrV/LkY4EfmkCpt/MJKRcUZmF5Lu891u/G444Rz20cAMOIb
	R/4uVgLZLjsesftD8jRo/40GgH7fPr9pLCDcYwqU2/vO+g3DIEs3KqWV0rCPcSFrpMv6sX
	ByzWxHdz4SXulXrb+vGhz2BUyAbNdUk=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=DMYKoxv+;
	spf=pass (imf15.hostedemail.com: domain of paul@paul-moore.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789405554;
	b=n7WG/OP5mgxD5Pv6NMIFcVuVtvouXjFmCwOvrCvWy2CboqWndr7Np6dWv+skJpbbAZBSv8
	buDeMx+9j1avyGDA2oatm7L2Jw6xvLountmhMWKoxee/67mqhnC6tDMg3cEkxc9IIM+SaG
	Z6jU28TndMnLh9iNFgwyzyfX8TZvWi4=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2db18fe433fso15301275ad.2
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:05:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789405553; cv=none;
        d=google.com; s=arc-20260327;
        b=B/h1goiq+8W5GiaRydmLneyM0vOKZ+9vNwLlIjVTmRUlhAXwVhk36N9DvJ50McJfZc
         wo/5VISmU8ZOnCRvYRpiyPFcxQNrQ+0yXKChYQoALCdHilXOWQ200597R/ltkJtStpMe
         i5KT1d8OonRc4LMdivh6r/ISXTJZD9PIL1YF+3PIT68gLJ/7341fKr/CKjMFBd4nRePZ
         0QT8+yI/jiuDzUAKQo9xCNrOZK6h7v+WnfcBJv+yK2Cp4P5BxIumDJ0sKSEAKp1V+upn
         fHYvOxVHQEisdLmXrl2cZmyRfRVcuG02p392WJv4RF7ai2z2RCo43GLUlsReBQWbK4qV
         x3CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=avx3LuQUj0eIvtk4vMhq4fafE3JrorX2BSEZUs9YMHI=;
        fh=ShJiFkmiI8PW4gl1VprDJahOBipu13DHLSXCeXIkPaE=;
        b=l+nrQF5u0bUPs0+0aykLv/wPrezq7qIfuPH7JsxDs1TeN9bkzCG71EWek/gdmsjzlY
         F694bc0qTUFVXfmLexkZKHlHIB4du7kNasoDvaCdJCGdWhwulluqsp+NHyHo3JFrYeIy
         EVAsq+B3oBRNgbLtj+UEreUrq3lI8k4xVZMmxu7nzM3uBRlC3HHvMTx85+tD+ZxfST+A
         kz83aQEU4cUaaKvPW+1aOR7O9RBs1RZldqJY3zQziLL8ZOYEMZEC2nEK/PD7anjx3Tyy
         Z3l/fwUi+1KEbZZ3NZnl/uFIlfGXPn1WklUro/cCTs4LEDFqdn94bcvCWUOtmpQRwX8U
         4gcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1789405553; x=1790010353; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=avx3LuQUj0eIvtk4vMhq4fafE3JrorX2BSEZUs9YMHI=;
        b=DMYKoxv+WFc0esppdSHc0aqaA3p8oo2fMeaoJbqTJJsQFldAAbbtHOiKTwIt+RwLxE
         Ft0eVj1hHdYacIfUQLgul56JoUC1kvQKqvZonc6HXIg3Ikfo4mTIkctL9SduPL+lVIJR
         RofZgzNMZyFqFmvOGYpvCiibZFfun8r/+Y7ccevVk85JhDHIkYPBjZud9MpxeSTqRbRY
         zuISeuWPHfmj2KxbSV1dQow4xQCoqDzPwIkPHhbEeL1M6mynIE25VlJw5yEks4CBKBbp
         pwvjUoyHK++T0wvXtxlYDzm2l2FhIV5jdk/nBE3TgmLHuIIfkR2oo1n2aAWXLRN1+khd
         RwYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789405553; x=1790010353;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=avx3LuQUj0eIvtk4vMhq4fafE3JrorX2BSEZUs9YMHI=;
        b=JLbNUZahn++cXnX/1EC0x597HBvTdJITJb0YigRwscr0ZH2sJ4Mo3KQvKJcFBye+jG
         KlyYiElW3ShocFfYP6rwUZSFGEIK8gAkET8WyOZUxNh/giPm8Fz4qvHZAeHivSGm+qtz
         wvXlQJwcuT7DEAMalnCfViR2/YRiKO69CduAQpCozaPxQhItK5HrhU6HYUyninVh8nLj
         bqiDkND5tY3pPRZplH/Db2Bpb82gn4FV5uNe1GXPrhd3sN6q4mJI1ADxNIxVxuvq/qdu
         eUV2PzuxfuxhnoFpMkQxEdGrHFI/ZbnK4/9Wgm1LJ54rGYSTEt9l5oBoKbJ+/3jv4Vqs
         qTug==
X-Forwarded-Encrypted: i=1; AKwUvBw481oC/5z6DX9mgd7q04gG9w2Y3Ro/eb9XOMfguxVVFoSW+cr2T3kpJLXMzyPXKPuJWspG4iC2Rg==@kvack.org
X-Gm-Message-State: AFuF++l7pq0VztC3WtlU2+pmkmaEej57ulAQWZ7B+DnkUq0ZW5IHFcLu
	y3FfKFIdlUJfLHQBbkZrNZkFbCnWHGLLgHmNRODxAYBHgfXfZnzzpXtjanNirYJMe6rg9PMuHvb
	V8KRzh+RHlPxymGPZBI2Q6KM6uUFtCRAlN0luSgNm
X-Gm-Gg: AYBFou3MMVFDyRbceB6ztX/oeynpCC1olFNWQx/Qg7YuLfI/aYg1DNx7/893sOVzH6d
	KGUAoZ59ZnXQD8Yw/6xuNmqn3JGqY3SoTD2bb//Nkv+jcUyaut/lD6b/ztWnUh/kURGoSsWBj7z
	JM9tQltMlb1KORPj3GJzYvo1edPK0o3y92A81KV78CrUbt9rYKe2cMYr2bxqm+dPav/3lQ9C4yi
	68XW5MvRiDDIRxSOk39c0hbFMG1GPQNpn4Ih4wvkl8uBX698ZuEljZiyOQwxIF+ixUpE1LVS2XW
	CVbxI8rFvNOQmUzI9XJtD/WWUwXTBxBOyaMNG5SaAMy9Z0P+FRiIkoExZ9VNS9KZT/otLHCaB+O
	vQYCNed37Qxg=
X-Received: by 2002:a17:903:2cf:b0:2db:56da:6a0e with SMTP id
 d9443c01a7336-2dd6c5f140dmr73526135ad.9.1789405552920; Mon, 14 Sep 2026
 10:05:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com> <20260910-wohnbau-bezwangen-wegziehen-7a32dcf237b1@brauner>
In-Reply-To: <20260910-wohnbau-bezwangen-wegziehen-7a32dcf237b1@brauner>
From: Paul Moore <paul@paul-moore.com>
Date: Mon, 14 Sep 2026 13:05:39 -0400
X-Gm-Features: AcwNN1Wk1GrQXU1YfDdXmUukQFqj25lXZKtxh5blfh1kI19p2jakplNL0VfIjvw
Message-ID: <CAHC9VhTE82bRRSXSUuMOdrfoMh=xOb5hDvqiKWzBKD1urab3hA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] proc,security,selinux: let SELinux block
 FOLL_FORCE for /proc/self/mem
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, 
	selinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 42779A000A
X-Stat-Signature: h1n9ka9ecsfr9yxkqnx8n7fy6on379uh
X-Rspam-User: 
X-HE-Tag: 1789405554-523193
X-HE-Meta: U2FsdGVkX18fZERu2Umv99GIulNLTn9qg/64i3Tyz4bKc4p05n4v666MT0YF/Rjmoqm9OTb7y1oCXpny923YXBZNQQ8Twv626tHckz5AcQ5KvZpPa2bdx6lqMr512GlkMx267bZX0d440uDUu7rJ/eRFW/PORN/h05W0SWuJsbFpKU/P3c52l37neyLfaVpZYVY1uaweoZDbe29sTIGmYiFMbmaU/lsBwcsED/QsJxDhK3uk8tCetJVH+m9gqT1oUCfqXFO+o5laFS8sTHd7VNR7eUVDFHtNeB6D0uyfoxqcUXUsKvQnzbfkEI6qeSqKmTgB4ffmcRP0kNOejRR3kpPsU8wKdG0HFKeJDOxHOucdRmALaMT4HqOsx4SS7ZCor7iOY80pcj1a/xlgvzbys55xWpUJb8XBrc0yynY2HqYy+nUJ/EYpJojhWZkk+UZQkr/G2jWdfkU8+KPWTygHuJ2UWjyZJl+o1/yYfWuHkeBWdW3Eezd0489dN3O1MGswPGgmJFSNUDikHRDSQZl/NJgK8JrU/JhAQhS6Vi6INJ8jHzzNqRXku+oKqFU1Kl2WazVckQA0tex8nlsl96sXGFUeTI5U6+WZGwgTzwYrGW8fAlNWMxdgbuECL2R1JhFuzka1P6kYVYW9y3EDbxJww7dpleWc58QvlzRowPg1ymx0ON0dTvyrvsP2kHUdKfgNOPtTskrTFbyfx8p4gmvYxNXP3QvneQFjWkNkC/JmBUhFbz3K41KZVNau0D2SMBbJgxTnr2R8LFDcx2/9+zYRqhybmimnGZfqh20fRsQ5MIKHvCgqYNa15LGSbxL4guQjdVD7Cagd65zyn1zPq5gJbN3c0Og8taN1FMyCQ8P3juDCRrGNWwYdXRjXyl0DJO4E24qY2yIL9QLl+ERiYyuLZt2vVq0wba75qdhzZSJCEB8tzbi/MWrPZsUlCnJm9MqUVajqOJjV06YmXqDOvbr
 DL1VcqPy
 2QnKejoDbleoLyikqKff8QTnRA1X7GlZb+QJrQwou5S8d08S6rgy+gJhkO42eEalQV0Ff8PKk6cbtfSPQvtqljGDKbNGrZgcVy10vuIzvOeXh9WgpslhtdXDggWqz4FzynAqMB9hSw3a7ogiPxGXMYMCGr2gkDs5RT7vtwUQ28oY1OU+JGzn954tORhs95Ev267LaAC7dsMvLlQPk3TeR3KEEDEKaib9Tjl6kp0JI15h0/Gok18pwsdbR5MscZ3vw+/9hoeHM+erWhG2TJgKZbxrlwrKh4xDvhBPsI1SwTWAB3MtY7LBowni6OBTmfn00L8MHUU/R1F3oWkpsOZfumosFw4L/3wqThBTODW5K24aH6TkZQdyARlhJ4CSvRIQE3MKu+OwR5L+t+DXCPOKrLiyFCq8CKtlWccUJsWWqe7pVNdFIehIkRNA+Y20ytO8KtICw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 3:48=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Mon, 07 Sep 2026 23:00:15 +0200, Jann Horn wrote:
> > proc,security,selinux: let SELinux block FOLL_FORCE for /proc/self/mem
> >
> > The goal of this series is to let SELinux prevent the use of FOLL_FORCE
> > when a process writes into /proc/self/mem and the system is configured
> > with PROC_MEM_FORCE_ALWAYS (which used to be the default behavior, and
> > is still used by current Android devices).
> >
> > [...]
>
> Let's move this on a shared branch that both the vfs tree and the lsm
> tree pull. That's the standard way of handling dependencies between two
> subsystems that want to route code that touches both of them. Branch is
> stable.

For some reason (/me looks at gmail) your email never hit my inbox, I
only noticed it now while reviewing Jann's patchset.

Christian, can you explain why you merged LSM code that I haven't
ACK'd?  We've talked about this in the past and I think I've been
fairly clear about it; I wouldn't merge VFS code without an
ACK/Reviewed-by/etc. from you or Al, I've been expecting the same
consideration from you.

While I don't have a problem with a topic branch for this, can you
also explain why this topic branch should live in the VFS tree?  There
are more changes under security/ than fs/, and unless I've misread
Jann's cover letter, this entire patchset is focused around enabling
LSM/SELinux controls and not necessarily anything really new from a
VFS perspective.

> ---
>
> Applied to the vfs-7.4.shared.lsm.foll_force branch of the vfs/vfs.git tr=
ee.
> Patches in the vfs-7.4.shared.lsm.foll_force branch should appear in linu=
x-next soon.
>
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
>
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
>
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs-7.4.shared.lsm.foll_force
>
> [1/3] proc: refactor /proc/$pid/mem to use struct as private_data
>       https://git.kernel.org/vfs/vfs/c/d5662602d178
> [2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_AL=
WAYS)
>       https://git.kernel.org/vfs/vfs/c/9f90f96af73d
> [3/3] selinux: require PROCESS__PTRACE for FOLL_FORCE introspection
>       https://git.kernel.org/vfs/vfs/c/5dac8c291d9b

--=20
paul-moore.com

