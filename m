Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B126C982EA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D62E6B00A1; Sun, 20 Sep 2026 22:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ADF26B00FE; Sun, 20 Sep 2026 22:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3606B00FF; Sun, 20 Sep 2026 22:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3177C6B00A1
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:33:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9B201120562
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:33:31 +0000 (UTC)
X-FDA: 85236198222.29.133BA49
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B6C780005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:33:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=VI6tnq0q;
	spf=pass (imf02.hostedemail.com: domain of paul@paul-moore.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789958009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0CX9NjM39oZwYo/+39OeXBXc2j3TkyIq6Vet5QN2Aw=;
	b=KLqneNe3AmpUYAGRcT+UzLxKESpaYvab+r2MQ+Bcfzy8fmeayQuf+1hsKdm10dSiPYaGr+
	DvIbxnpdCxpZ0m7MFc3YEvQ52qVG9afEYyq2vlgD1Nf8bUxDHOckJaSHAC3IY++4QSUep3
	r/d7gMo0vMt5kYTVFb7YCuZQe3/mo3A=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=VI6tnq0q;
	spf=pass (imf02.hostedemail.com: domain of paul@paul-moore.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789958009;
	b=pN6iSnkfo9Abrf0V8E6zTOyYIj2HY5Kx8JwZGSzIqQMaeB1Ue1z+12faLbLxG0HkLkNO9D
	REHDjUByc8K5GDGgxjsIalJFs6X0U+q+yiiYNZmj9oxU1ACW8TotlF5eaCShSqi2ohKjCY
	m6Xdt0cObojw4NDcuICuw5PByS694m8=
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc1cea4ae2cso2050827a12.0
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:33:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789958008; cv=none;
        d=google.com; s=arc-20260327;
        b=bW5FMqS3xU8H0SNa/ygJc9BKxuRuYjMTyvwWXx08WANHcJ9icKKyxOClhoNl/xZ/t2
         frr6IpJhnE4NWf1r1ngePm8Uwzm6/pUIGQzFZ1RmXCU9Ulug0sqq2mwgfoDpNq3vyHWh
         28lm4sgvwSrPoi5vk5nXscmQ+UXGbAZpX5lnQMSlA2GuU1A7qorNHWYtAtis1mNLcfs+
         vENRB14BIqdA2DAxtE54Bf9guG9Hz6yNzUadvsNQ3OK0eUQ9Lyy1hNOTVEFKW69sXTkx
         ApFxXXZLWJKBVXWwtTd1Hae+VUQMGEKj60PJLhFTqj2qn01w1pjCAHcsMpXEVueDLohD
         ejKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y0CX9NjM39oZwYo/+39OeXBXc2j3TkyIq6Vet5QN2Aw=;
        fh=Rey6kGUrkzwj99nytOSM0Oiafsgp0mhdRTxfnpDA9Og=;
        b=RozkNMXi6flXQY+8AY6gGDWuJQJ8BW4dd1T+6g/+R0xsyNQn4nszm63CowqUpJHdqP
         qBAHRNAON/IQgiC0NzCyW5XOWFIciLPG084+EIZ+ZMfKekPMBFoh47vIomFJd0lBzoAD
         UgM/dHmrnnQTxOinr4gOzuQOPlQN+mw6Bd0iWVYnB0Cf8jFYk7Td7rWh/mJTWJq1CcQn
         QsGXw1NYQOEIJSnPzYaO42wyOPUrEysw2uC6peBM5QdRU+7ZR9DTceZvPFahRYYJ1klf
         xnJYPvvC83zIQoaDx9+l+tfbjxQuH06sHi5RRLBWc+JYvfS1+EjiiRVb1UYgB6C0uBwn
         W3JA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1789958008; x=1790562808; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y0CX9NjM39oZwYo/+39OeXBXc2j3TkyIq6Vet5QN2Aw=;
        b=VI6tnq0qhf2qCKz2TvLN0QnIuD8/gnF9Jc1zjrUxw870qCt2LEPuiSG6Yq0QfpobRD
         2WdL0lkBRmQex02M9TPoCP6vrV9r2etCKq4Q/SpQ/eay/f9rGcXilMJ81MaRxw/+7xkT
         4vxXYtr7ki1OqnCyRrUg9uf1Eed4Wc9vqdEQ3QpS8rdVvZK05fqZRBicZmkbuYqjqpU/
         OCbkWp6+wcEfhePYntvSWCaRxZeNtqsjg/dNEk0vX+93XSOyiyy+7i5prCQp77UXpOCw
         iya2Ea/TbJhQmNHHO7vgTeNpT4Ivjsntfs43QcyfuVm4ORYTJ80IwIObjghqoIZhC+6H
         KdhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789958008; x=1790562808;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y0CX9NjM39oZwYo/+39OeXBXc2j3TkyIq6Vet5QN2Aw=;
        b=Aoqykk209Q6RP5RyVPuYt6EnkLZ877SMBLXeQOeL1+lEJ8Sr9ULpP7S+5+FI0CQkAm
         ImbPWNkf1G9H2ndYGp0e4FEM3p7tarx9ZTMetuYFHrJ/F5My7kamoMKy5POSf+fB4B5s
         j6d6bNtzIqmeA63zUWChiY+iGm2W6fF237diAElJAgooaf1h4jvEFSM2oQTijqeSQja4
         hX2yBP6oES1tmGXn66izLkmf+cXS71QPS1n4QkovyWOw5LCayRASYaR48sGNQUmLIxXg
         LihUbZG2ITxZ0hXIOt7EEQZW2CxfneQVMB6pjZg5AkjgzRBM9GF1i49FojCFP82KHXef
         4b6g==
X-Forwarded-Encrypted: i=1; AKwUvBwuWxKzaJlGxICCtBv686KeI+/I4SX5PP45ezqaTkypOrDdGRY0770m7IaAiAQc4pwpAHdwPegZfA==@kvack.org
X-Gm-Message-State: AFuF++kJaWzDIiExDh7/1gSyGx0gNX95VpJO2kQMM8THEVnbzwPaL37s
	nLTc36aMHGkKdTfz9RP1zwdOhY2Hu39Q2urwA1orjxTI8jZjjYM7U9mzaA6E0X7x5IqkZOu2Tmx
	U3oBob2h0GqnlEGGkL7dt6eXx3g58imHjJgH2gI/r
X-Gm-Gg: AYBFou0kLNtmRq9kE5E3ZDSV6lk6/uiJ/XYRnmaCDGrW4MlVfiyLy/b1i8NYaYz5FyG
	yZsfc/Bmdmm+SwO/QyaGjY9ct0eEvBteJnOyvPOdd0OrsFjbSqrCRBxULFIAXo+5ctVPfHE4MOX
	C2iyB5L2m2nvaAByXaIRLU8NF9goYVTOaIXDaFeTJhVjbf2lCai40oHERGrLcdNEi5QCeW7G3gs
	j1BhX5DE73V5mIJHvin3safEtDtU8edqQamKAa8YSztSvQ6vWWIvRfWJiAAacylW5Hmv1Bc+yFY
	bBFCuzsRlr/ZAqlLUd0XUaUKoVJ+/6EbnZkQ59roQQFF6Reo9tH9UdTJ56QNaf6RkKb1RB9Hb1r
	pgqtZbLWQ
X-Received: by 2002:a05:6a20:394a:b0:3dd:a196:53a5 with SMTP id
 adf61e73a8af0-3dda19654e2mr9716786637.71.1789958008327; Sun, 20 Sep 2026
 19:33:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
 <20260910-wohnbau-bezwangen-wegziehen-7a32dcf237b1@brauner>
 <CAHC9VhTE82bRRSXSUuMOdrfoMh=xOb5hDvqiKWzBKD1urab3hA@mail.gmail.com> <20260916-begossen-tischbein-abgemacht-e7dada3d1e56@brauner>
In-Reply-To: <20260916-begossen-tischbein-abgemacht-e7dada3d1e56@brauner>
From: Paul Moore <paul@paul-moore.com>
Date: Sun, 20 Sep 2026 22:33:15 -0400
X-Gm-Features: AcwNN1XJfic_AjA2ynJbPwX0hNkODxVU2hbKAKXrt_cjhAGvAIE6GT_12dvWT8I
Message-ID: <CAHC9VhRDpR+o9ThzajboAW4mpQWG7Yy0FemuowviyQXYvji7Qw@mail.gmail.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B6C780005
X-Stat-Signature: 6wixtxdsgtakufsk8tac16kykmnmms7f
X-Rspam-User: 
X-HE-Tag: 1789958009-861205
X-HE-Meta: U2FsdGVkX1/CMiX7z5tYHmLqz9JTsgs9UbjUJ/PjP12WumbKbbImKJKzbutjuPd7GwczIh6q1u/CdjE7BfspVixVxgXcAPCAJBgnsTejfG+fhvfdGcO5igRo9/nmb9tU36NQzwCa9bK9KCPQOnccurYfPokGmCswhBPR1Ue5baiX3Fi8sC/eNgrpa1P/gugqx8PZ06xg1D7PxSOam5xTqSqODis4Uu3QArefyJTHdHO2NTCcKsf7zARi0gj1b+EFBwlf2xZEnS7SSCfoJF46kb3yyfwgmfvwWglWmGkIL2u3CiIpuzHuh02bZZHJyBTC4xTqs/l+JpvW4jJaHsCd5wQwqxflYf74KvTSsMONjeckA/rbAOaU90B5+5N3ECxoP8FcZnaO7NcboaiPuvYeo373PzWcbicHKp/ae/7hPP+3ZDi5a/h1cZf6+CYDxc9JzhPgMjQPXD7iA2+x/ZmG3mwiQ/fIYESuYLakOq2nCM8QEZchDIMSYEa3oCp36bimTNzp1R4k8rRh14UslQClqJbSLHpg4tejYUP47JgbNnoJzO6bBbuGfB1jQQXwt5ZkjV988LpDOfQrpGEu1KIlp905VWDwoKGGZMDtp1tb5KFnbK0umvkxjg9jphzh5z/qwZBdBa9L9j17rOnI6u8qtNAPB7br7HCV6/+VTFmLADsEowgG3eJVaUv7MbSgilc1haKMZNwvd1/A1QF/teCZAq7WKhljrBWAx8cfA8uK9REZLB8VhqLwPFEEIpbp2aKZwG2kW3StzwKm7aEVg4ydtOABhgxYiOWUK9F82m4NI26/UWy1gqw1ruBZK61h7ZfLNM/cywCxFx6wfTE7VnpCPkYOu6ig3V4HUj2UL7BHE+zXbynZXqRH3LtAK1H7oExhmhRhfAMZAf8r67yaQQxVs4gCCq+gerbyMz/0W2XEkViAn44u3ZPXvkCh6itb4a8PLg3LCpXo/ZaHz0ZjnL5
 33zOyQs0
 9Ozw1+mtDLjMC6bW1bGrHN5BUHboCRg3Cs+YzBevG1jRpcQfqmY+EgziaOmSE/vTV9/YdmMR+hdxhjq6xwl0bJ4+4qE3qxtennCgkmd94M171b3uy8SsRirkwxBEi8vPhsuBVWypUBS/BsXIaEqu+2DCwBwwmGslBHYPRJJp0++lE4J6nqYhbDFt+52R2GvOuz31NlnmKmUXGPPD53VH+rFD9L8AsrdCAYxr+cD7Zk9H3bsQJGAeqMQGNuQXGr0RBIs6lVCcsx2J/avVtXWRY+wy1rdYEZEfS7fRC9kIZDzVn8Xz+jDHC3E+JmZlMrOsNUomkb5Xo5b9IdP/aioh5a3WQ8JVVk+eR0jq7tKPXs6K4M/XGCQNrxxkWGO+cgfMrO/M8RteXT4EHWFjwndlCYQ2AvMqPTE5ocZd1IQj1OR1PtzSEt+3lflTSNixFJMwx7yuy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 5:01=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Mon, Sep 14, 2026 at 01:05:39PM -0400, Paul Moore wrote:
> > On Thu, Sep 10, 2026 at 3:48=E2=80=AFAM Christian Brauner <brauner@kern=
el.org> wrote:
> > > On Mon, 07 Sep 2026 23:00:15 +0200, Jann Horn wrote:
> > > > proc,security,selinux: let SELinux block FOLL_FORCE for /proc/self/=
mem
> > > >
> > > > The goal of this series is to let SELinux prevent the use of FOLL_F=
ORCE
> > > > when a process writes into /proc/self/mem and the system is configu=
red
> > > > with PROC_MEM_FORCE_ALWAYS (which used to be the default behavior, =
and
> > > > is still used by current Android devices).
> > > >
> > > > [...]
> > >
> > > Let's move this on a shared branch that both the vfs tree and the lsm
> > > tree pull. That's the standard way of handling dependencies between t=
wo
> > > subsystems that want to route code that touches both of them. Branch =
is
> > > stable.
> >
> > For some reason (/me looks at gmail) your email never hit my inbox, I
> > only noticed it now while reviewing Jann's patchset.
>
> Oh weird?
>
> > Christian, can you explain why you merged LSM code that I haven't
> > ACK'd?  We've talked about this in the past and I think I've been
> > fairly clear about it; I wouldn't merge VFS code without an
> > ACK/Reviewed-by/etc. from you or Al, I've been expecting the same
> > consideration from you.
> >
> > While I don't have a problem with a topic branch for this, can you
> > also explain why this topic branch should live in the VFS tree?  There
> > are more changes under security/ than fs/, and unless I've misread
> > Jann's cover letter, this entire patchset is focused around enabling
> > LSM/SELinux controls and not necessarily anything really new from a
> > VFS perspective.
>
> See the reply on the bpf thread. I think this just a misunderstanding. I
> was under the impression that with minor tweaks v2 was already acked by
> lsm people.
>
> In general, if a subsystems hooks into the vfs layer and filesystems
> that are directly maintained by the vfs layer then the vfs tree provides
> the shared branch. This is not at all specific to security. It's just
> more pronounced for notify or security because hooks are accepted
> layering violations that place constraints on how vfs code itself is
> organized.
>
> I think this is just a misunderstanding that would've been easy to
> clarify without the kerfuffle.

I'll follow up in the other thread, but I will just say here that had
this been the first time there had been an issue like this, it would
have likely been different.  However, from my perspective this was
continuing a pattern of behavior I had previously talked with you
about changing, and as a result I was much more annoyed having to
revisit the same process issues.

--=20
paul-moore.com

