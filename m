Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5CEACCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 22:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076668E011C; Tue, 14 Oct 2025 18:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027498E0090; Tue, 14 Oct 2025 18:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31448E011C; Tue, 14 Oct 2025 18:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCA318E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:01:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65860479F9
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:01:52 +0000 (UTC)
X-FDA: 83998092864.17.16957AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 58E5F180013
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:01:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HoHTVsa4;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760479310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLyaOVU6UN2ja5Nq2Y2EolovmcTT6dPEM8U0epXqG6w=;
	b=MiiW2YScsYdxVUT4ydXuTShKJ7HcpETz0D0QDpwGBqFqQD+0nlD02HoSMDAw/p0m1SiCPR
	YbTMBN77hqJoUshTteEVUGqRdO9Wnqe2KP6Kck4W0IZtucpXEpSCg7tpCiE3HjR15+9Zl9
	N5I58+z7jQ02tbtbrw6S6SwsbqFC4xc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HoHTVsa4;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760479310; a=rsa-sha256;
	cv=none;
	b=qGJewliJdZCTmhC6RmAJeqBpv/BxdIqoCfBHtpF+uh3zaWj2KaEbktbux9ahENKtDClHFk
	Q9rMnZt/AHeZ0Soo+iJb4lR2SOwxSVXX4Zk2/lOUeM3wIvbXJXCwnjM6J1fkJ/YJib34QC
	DYilY22RLofuQvby2EXv/saqOpj0NwE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1DA341A9F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C147DC4CEF1
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760479308;
	bh=0AErGF5GqDQIE6o6yNNpxUDc5gP2/xNsjMbENC6hb1E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HoHTVsa4zQO9p1OqWZNVcL+PjRgTlRoKLqSUJhZnNms1ACxsQlSa9lBvt4jzU+v7L
	 MrHQnHdFDrNfv3nSe6ljxQYaNlOTmAMwcNshjw9r0C3qnMqJcMi5uefYMaPivaKFDJ
	 ixUNWVsDCSUywHA6R12YLnIBtlsAx6a+ggaJ2f4AWQfEwdA/JVAM8+x6Yh8TU+5AMc
	 /JzKuPk06+wDVKLlJLGowgBGI6Bpc+z6XyITvdLm9FYZpCZAnHGX0EXX0ISm06koZA
	 5hlclF5IPyOPPJA8wR19h3TxHxmVh/7vGZiVsD6gM2q+/R0qxQ4ESkVQcTDGOGgKTY
	 XC4M0Abux9Aog==
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-73b4e3d0756so65118107b3.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:01:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXSJMtTr0GaT7zgepGRUSGDnDn3TZkgBC6Jr4mWYHEXlTnROTU/tndNSK9gQBuZfsTraErpOhH/7w==@kvack.org
X-Gm-Message-State: AOJu0YzBKEHooAsg4HJ8+dCT04Qzp71EXJf8L5YxVMPkXq3gmLo3cMEs
	wc1/vqm+HqoFAXvneeALLhV6VGK9oDpM9jru7IAr2wzZgYLq+iaFxFxrMsct+KAo9s5SZQMlYak
	33XbokwsYln8qGJnESJS55uMHD2IG+ifBE/31CnleWQ==
X-Google-Smtp-Source: AGHT+IFDR+msBMQjwMlrFS4aDSbsJJjxCanN2O+AmXgMg4oCWbKM8JzyaIe8DMRNOAlkcS5XPoCtdveiDB6vaytrBdI=
X-Received: by 2002:a05:690e:1a21:b0:62c:aa66:973e with SMTP id
 956f58d0204a3-63ccb873864mr18993040d50.5.1760479307058; Tue, 14 Oct 2025
 15:01:47 -0700 (PDT)
MIME-Version: 1.0
References: <20251011081624.224202-1-bhe@redhat.com> <20251011081624.224202-3-bhe@redhat.com>
 <CAGsJ_4y4CLu7qeHijhJtL+NDrehfiWpu9mtsVGxmn5rBy03v0w@mail.gmail.com>
In-Reply-To: <CAGsJ_4y4CLu7qeHijhJtL+NDrehfiWpu9mtsVGxmn5rBy03v0w@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 14 Oct 2025 15:01:36 -0700
X-Gmail-Original-Message-ID: <CACePvbXmd840LQsWBrEGA1SBUQVznNC3wmT8jU6+7GaBwTTW6Q@mail.gmail.com>
X-Gm-Features: AS18NWBP9VivGkKo9OOIeKfhGiqgvjbNkeU7TNJ2YV7UQTE4ezqHObLbLiyZyBc
Message-ID: <CACePvbXmd840LQsWBrEGA1SBUQVznNC3wmT8jU6+7GaBwTTW6Q@mail.gmail.com>
Subject: Re: [PATCH v4 mm-new 2/2] mm/swap: select swap device with default
 priority round robin
To: Barry Song <21cnbao@gmail.com>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ogaonxwuncbr6agdwd8ktdh8girf568e
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 58E5F180013
X-HE-Tag: 1760479310-320003
X-HE-Meta: U2FsdGVkX1+BIY+GyO81b9/svydXgah5AQ9RlRO0P0EKqEKqp9ZW4c+FQAJCFvGNvlo6NekAVmXMwXmRliDgmaMYYsucUU0rSiRrGgieOmAwz0f4AN4E6lT4JbqXQrM8KEoW9IXb2rowUWdgV8QUhNAmDYMGe9QzPO04hylMM+WqaYfkimBqUbBJboXwEnxuNB5DtGluiRlaK3XMjRo/DSG/c0/nlKG8eZwazOncQjJjaPutmTVDZA3REmfDbl+Z+jWqQxoG3nYC4XPNFo6YjIBIirBoEr1Sg7oFS1UZm5cN21/wfZLvbnEItqyIi/gDYj5zzX9PVbE8Bf3JytpB5+L7o/tjwd+phIZwWQEK89/n6mhwrVdUI/ebXiuB4k64Mu7bbPItg0yfBOMZ8XgU/e9Mj2qMdc3UlOeoSD5yBn4KeFR1b15TiYioVovueV1e41Xwr+7F0AZMJQqp7aD/Tl6TNzIgVvf7sNRc6MMb4RP+fNyfvybxhsghEz8gDr5bLvRKoZR5Pm68AaTDQIljq6WYQgOGKScakCor925VsUBYi1fgrrDd2zZh3R2zzC3fj0XvwdlyHYpJVRg3oDecddHtcxGqYqOc/y7TWD9uq+3zRfzkS+2hvwWJXx6JvRfkiZVITUmJbbaRbq1cqTW++Hri4mlGQS7Ls1ZaDPvcviHz4vXnI/hyV823kvTdT24JkpT26mwGtMPUK07/KQNcr4Dr8gtyl/QNZhSWFbwZ4M+V2dWQ17/Pnjoa3unHP2V3RCd8KXRiClw9V0RlHU15AYnVKW5cAH1U541QunNCVpBIU5g1yjenvN4ZrIUeozRLCGFPlI7lAhI9Drze8Qv3ILhRWEujXTChVQWDRAJtopa+glkspXhqdNwp/kZGF0y1UJJDsd+JwyetSyxe05lmZmWV6iyNtqpO0VbvDRlt6pIbtmy0qKu6mMwfPZxqtvVCQWoQ1zVlX1hXWjnifzn
 JPtsqylC
 6zEvL4fYXSEXAND9IAATeSZa0rcCNpeKJFiYlobTgmqrsI8DmONcZSuEWTNsWrkN10cKpwnA2k8jecn9MyAtJpjcF5T9A44fpwvgKSHSZGd2vioD5ZGcPpjGXDq2Kq2z0inILDFAFXhqKrwwcun1WXte4h6X5I72emo5asbycyJMht5T8FA/3VHdGLVqJfUelrmHJl8tl8R3noOk3CRw7WvmG6S5ScJ5AWITc4r7vcD6fe3LUslG0JnaPscsJUKo5a9Bx+K4C9qV0vk9vdnbBW9+beZsQQeqUvNlNLbA1A1ETcRCiXZOx51UEf+2+qp3/jU8E711U++kmI0w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 12, 2025 at 1:41=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Sun, Oct 12, 2025 at 5:14=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote=
:
> >
> > Swap devices are assumed to have similar accessing speed if no priority
> > is specified when swapon. It's unfair and doesn't make sense just becau=
se
> > one swap device is swapped on firstly, its priority will be higher than
> > the one swapped on later.
> >
> > Here, set all swap devicess to have priority '-1' by default. With this
> > change, swap device with default priority will be selected round robin
> > when swapping out. This can improve the swapping efficiency a lot among
> > multiple swap devices with default priority.
> >
> > Below are swapon output during processes high pressure vm-scability tes=
t
> > is being taken:
> >
> > 1) This is pre-commit a2468cc9bfdf, swap device is selectd one by one b=
y
> >    priority from high to low when one swap device is exhausted:
> > ------------------------------------
> > [root@hp-dl385g10-03 ~]# swapon
> > NAME       TYPE      SIZE   USED PRIO
> > /dev/zram0 partition  16G    16G   -1
> > /dev/zram1 partition  16G 966.2M   -2
> > /dev/zram2 partition  16G     0B   -3
> > /dev/zram3 partition  16G     0B   -4
> >
> > 2) This is behaviour with commit a2468cc9bfdf, on node, swap device
> >    sharing the same node id is selected firstly until exhausted; while
> >    on node no swap device sharing the node id it selects the one with
> >    highest priority until exhaustd:
> > ------------------------------------
> > [root@hp-dl385g10-03 ~]# swapon
> > NAME       TYPE      SIZE  USED PRIO
> > /dev/zram0 partition  16G 15.7G   -2
> > /dev/zram1 partition  16G  3.4G   -3
> > /dev/zram2 partition  16G  3.4G   -4
> > /dev/zram3 partition  16G  2.6G   -5
> >
> > 3) After this patch applied, swap devices with default priority are sel=
ectd
> >    round robin:
> > ------------------------------------
> > [root@hp-dl385g10-03 block]# swapon
> > NAME       TYPE      SIZE USED PRIO
> > /dev/zram0 partition  16G 6.6G   -1
> > /dev/zram1 partition  16G 6.6G   -1
> > /dev/zram2 partition  16G 6.6G   -1
> > /dev/zram3 partition  16G 6.6G   -1
> >
> > With the change, we can see about 18% efficiency promotion relative to
> > node based way as below. (Surely, the pre-commit a2468cc9bfdf way is
> > the worst.)
> >
>
> I=E2=80=99m not against the behavior change; but the swapon man page says=
:
> "
>        Each swap area has a priority, either high or low.  The default
>        priority is low.  Within the low-priority areas, newer areas are
>        even lower priority than older areas.
> "
> So my question is whether users still assume that newly added swap areas
> get a lower priority than the older ones?

That is a good catch, if the per node_id swapfile logic reverted, the
man page should be updated to match the kernel behavior as well.

It is a good place to describe the default round robin behavior.

> I assume the priority decrement isn=E2=80=99t a stable ABI, so this chang=
e won=E2=80=99t
> break userspace?

There is no ABI change as far as I can tell. The swapon has an option
to specify the priority. The default swap_on does not specify the
priority. It is a kernel internal tuning how we arrange the default
swapfile for the better performance by default. If the user don't
happy with that arrangement, they can always specify a priority with
the existing ABI, there is no ABI change.

> Or if someone sets up Linux assuming that a newer swap file will only be
> used after the older one is full, then this change would break those case=
s?

The existing kernel implementation always fills up the high priority
swapfile before the low priority one, which hasn't changed.

The negative node_id has been removed/reverted, that is a behavior
change yet. But I fail to see how it breaks the user. If you have a
test case that breaks the user, please specify.

Chris

