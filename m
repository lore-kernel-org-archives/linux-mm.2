Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E120C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948496B008A; Tue, 25 Aug 2026 14:20:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8CA6B008C; Tue, 25 Aug 2026 14:20:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E75C6B0092; Tue, 25 Aug 2026 14:20:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2056B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:20:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1762160167
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:20:55 +0000 (UTC)
X-FDA: 85140608070.26.1711BC9
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id E4239A0009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:20:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B87IUPXF;
	spf=pass (imf25.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787682053;
	b=0UheGaVhZjWrespGZXCwWd3h8mMdyTjJD5aIDGPQHup7popTk2jJ3idQy46rs1mKRBfKl2
	dUZiPzIj9GW3+hYViqPjM56UWgJHwWzFk7GS5KdHT908Zrc58wFDLD8t+KCvftP2BpzKyh
	QnSZsxQWJvLb3DbuxUjZaGEu4/rJrKg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B87IUPXF;
	spf=pass (imf25.hostedemail.com: domain of anshumantewari123@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=anshumantewari123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787682053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8vnnD4wqEAQFZKUQ+x9frnB9gGI7jKoJfDp0bNGiIc=;
	b=MFOyg+7fwJ6bwZ4yED30mzSJQ30molXhvuhD3izKFOWhB4iNZKptNuCSGjr9Vwd0cWmUHF
	mQaIlRUJOdph029xc/yFdMIEIjidEL3XLdo1PHRz7zSSguZNIWgeoqCADsnw+x8SvZehJb
	PMZ7inc7D1m+GwfKD4vkhwTSNdyzTrU=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38e07ebd263so160230a91.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:20:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787682053; cv=none;
        d=google.com; s=arc-20260327;
        b=Mg2rv3ONlAIgXnJ4PeWjHWBSDs7xGPzabHNHwRDivr0yo7lZCr+tAhXuWEdF0DFSQi
         RS4PCi5QkWLT37fYwMPEf+AW5VykGSqRBANKPQjCU8dzVeHd1ERAfRxcvT00rKRncrDX
         Ah+aCJ+bKkxmYw3iauLe8ClFGMTqwBW9worBABJ4j26QxrbGEj1bM1FExyGB8bfI3USZ
         aGdTJSiaxqYPSuEa7RhEcIha7IhAGzk0xN7Og6yFvPzMpvNod00IE98UFiVCfy9zGysO
         Yd6tC9MziABbLyI7BJcKoMk1JrdlBhJNek+HUoVzFocnzcF8zmdmz4p8cgV64yS2zOjr
         hdww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L8vnnD4wqEAQFZKUQ+x9frnB9gGI7jKoJfDp0bNGiIc=;
        fh=RQ6Xt2w4S/AJKy5S5u+0o6zt6lQJEAy2WQ/+EjS2XLs=;
        b=c5rzMtjeVhxzwCRR3MXqk8/fKQ4jTbfI/Bv6FNwfMalr3aCGE9zy71XO5hxOu202Mt
         jiGaER1cBEv+6mVOSQoxreju7HL9wRr2FBfe3Tbbd8Fey1PLQZEqacEGvAD3LoLjnctz
         hHQ5EArYnKndC1e4I3PdlJqNy13+euxuCgyDbpJYN6bUg33EfkT57U+/zA9UDYawJ+lw
         s+f7vi2fc9C0H6Rld5gDLrdCvkWq6GGZRV0RNXqm45wVwNC3EFF6ZKXbkn8D0TwKWJgI
         UK1wCoQ80sUSEYEbexRKZr3sGQRAuCTS4VBd8/Mguo3+XPzzhGwnFaes5Pu/VpgW5tDw
         bMwA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787682053; x=1788286853; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L8vnnD4wqEAQFZKUQ+x9frnB9gGI7jKoJfDp0bNGiIc=;
        b=B87IUPXFnJuHmFsN56pOsw6CWOLrS6FqBZzKVxwnhbZ55bRe6qqL1o+q97CMlOCEs7
         pd+m9psOeuWAdAGyIo7OFijnX/7hiz4YRnQhZRpJLIcITak3BtdF/lOPqO2CW9w63wa5
         qbui9TwKxcP2uV+h403CBIfApOEJmeD7Q3TNliw0frRqIZiQBKogTsnBs6abVEllHmuM
         g4Q7BsPmsqzfmc+a0YBLvLp+sH43pGNPSRv4OM1aGB+55APZJ+koitzE01Xzyla6q19W
         rDHx1OfwZNvQe6r0zf16HsLpN18g7k0elJ+w2808xnluMFS3d2f79SzDOV+U1Ti1KDeh
         8C9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787682053; x=1788286853;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L8vnnD4wqEAQFZKUQ+x9frnB9gGI7jKoJfDp0bNGiIc=;
        b=N1YYI9me8ti24gGm1fmvtuxRaGtzpfkPaRVA4JzeJ3VC9sEDmHul7fvrtpSTO2mF6W
         TPXBFMaA+663DF3e6vWpen6A0wzuV7hsvdtRCE8Hrmn1pVc+YwRCDnBmp82FL8KgLfzH
         JiAtginMRgcdxHxBTUoJ7G0Qusp9eNXWueQb7DAfjkKhVp8A4UbSJ6l2rpjsPc25QOgW
         lFjY/VvwPERhhLyVwHg0xV4Yo/Cpu0kIZYdRt1BN3I3yNvci9zoeyArMggcSG6ifu09G
         9pm5vavCI6wATRgU0THCXg/3UClPwbPpvbZ3kNqzLJuRcLmS9ongC0LJBC+GsZBItHjN
         dRTQ==
X-Forwarded-Encrypted: i=1; AHgh+Rrj6ukF3O3UuGkCxvQaf7Od/8tKtLxuvWOJMgVPQqjFSflDu1QaGJk0vIG12llr1NZgPgzXlXqRTQ==@kvack.org
X-Gm-Message-State: AFuF++nv147ZmjiKMZm92g5C/2b5r/XfYCRkQ/lsxtLFcdqxXkA1Syvg
	+u5k9x1QA64ljDL36lEu2SJkgYblbs4vxReqcHp82MDnGxaiF7fE8eQsOJX3Ut0F3JxlQavvuZu
	FZY7JP7HFZtB4cBZ57/usUplXhkjhYWc=
X-Gm-Gg: AR+sD13iq0lGgFyzH9uYz+DZV81H+HikWYrlZCIaTI8JryFW/0GXkl3BsBJR/NIpHFf
	gXOwRRK2IbP3cLeZIHjxKCRfAG4Qsh/EHJzGBNqVrW/7GcGRwELLlTmQP5W7CJt92PIUv8zqY+4
	jk5mCMTjX+5KnmrN+xBux52maWXUdyYqbJs3jOrRUaEBpsip5Gy98HASWooRXnXDKUZ7OijKWFP
	zIf2spYafVS239oz9ucEGfPK3RmU3C5EG7Kfz9vYsSXliNZx7AmrTS6dZYeqVipfaHoKfY/NGFo
	50lYuWRGXcyOezPR8gsbDahh3euw6D5NJ+Gh8azy/Ro41R3+cHXVUr03A6kIn9w/4IgUIL/amyB
	vMQ==
X-Received: by 2002:a17:90b:4f49:b0:395:4de9:b30 with SMTP id
 98e67ed59e1d1-3966d1baf30mr1848749a91.5.1787682052569; Tue, 25 Aug 2026
 11:20:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260821114416.12255-1-anshumantewari123@gmail.com>
 <7bb2d581-924e-4a59-9955-b8afa2b51268@kernel.org> <CAJqi8kJf9EzfZWBo=1KpEzGiq+vGRz0J0mN+-NXAjrtq9HDrMg@mail.gmail.com>
 <e7c339b8-b936-40c7-b121-1a4c14838dd9@kernel.org> <CAJqi8kKaNsxBM86Hg4W09gLo2rj0+kc9dAvps48jmQCshUkxqQ@mail.gmail.com>
 <b993b8b3-351c-4d2e-9bd9-12c622f427ff@kernel.org>
In-Reply-To: <b993b8b3-351c-4d2e-9bd9-12c622f427ff@kernel.org>
From: Anshuman Tewari <anshumantewari123@gmail.com>
Date: Tue, 25 Aug 2026 23:50:39 +0530
X-Gm-Features: AcwNN1Ull72X_WS0KMiw_4u9rzH-HYvB6Zo9b63KvXBECPIeUZSEqjnT49MAQLY
Message-ID: <CAJqi8k+cTXvvk4Pz0RdjQMPvSNCszzORH746fb7YgQUgngykbg@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: check strdup() and fix buf leak in parse_test_type()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E4239A0009
X-Stat-Signature: ruw71mzicpcih6f9mpnmekimagoctqxr
X-HE-Tag: 1787682053-689476
X-HE-Meta: U2FsdGVkX18PlcQLQ2Evsa9ixlYTD9Qm4NznVQRjvgN9ORxj/uLpWPbvU3xaGKs0cNXndqWjIpV+2OuwUEUO01S0E4jtXYGRdYJ1JRmzm70F/zH/4MG5B+x45Z6U1791qKqbVDvMUMuGs9BcOOepQ1fzbuaByUqjMoavJwI+v3GKCDwKufa0dJan2jlZJEe2ye84FRYjXPzWrcPDfKOhDUNDoB0Kfzew61wkl6look4g0/hdeXl1aoKKhOL1x5CfVV9pzXnKTQCw304fnCuEM7Rte2S+sDdPe4WG2Bd+9Owg2W4l9J/N7G6J6GaorVvYGL5M4sYmGJixQKRV7HGJrt10xHt9OKJM+sMUDW0DzKo2L6+V/bvYWHdw3+AVdsFV7RKwiqwy1O/jGqbeeBz+qZOiQwpDV/K6z9nKVyXbFNjoWCKmmYhJLxFU8PbXP+8qubSDuPZHnTNyUhGhfjPm38bGg8uS8D4VbVwno8PW/JG+pjM4X66+uTQURfSOwWoQ4nERLIGCe521JV7Ic3AUW1xu7w4MmLyJxTX4TZSNhpDMo9KwiDZcSQUQxKGpW/Gy0n/IuupC0205l3R3zu867FjbEcrnqV+3ilKZRtiHDH26nsYzCuMNfm4sNn7XmCdDI+jY9qeos9mQM/GLV7pOJe1c3vhC3MVj/zp6DYtZlAGicpaDmEwhhB98UlaSFPgI9etKeuWihMCEJ+QX1fG04oy+hRohqlMMtHOVT65aD5ZkAUQYBkFR7PD043rqUUJJIiBQ9419Wl4Grjyd4q8mwSBr9ui7+bq8itq4PcGm0pg33Jo0/Bu2m7iDftIf3uCDpN3pz2ZFlhUzBxiVUNVPAc023QEz3484Ijpdy9HhVgd4mo1ngvXQeuPCmNvVJnIJmPKk14e/FWCXyDfaakSQ3R8rcu3AxTlLZjMAkjeEI5Gb27bp8xiNFiZ6SFsT9kARUZNMENzidg+m8ZP/5DN
 B8VJN4pk
 gBs7iabb3zsbKBpFoXFVNZbTOfBAoP3z1yK/0gxpYYFg5cJ7srIqCZAtvo6eNZzGx0iLv5rbOPXooS9xiwRIh/0SwTrG2rp5WNUHZnfMA2teTEV79YI3+4XdlMWel96JdwyH8Z4hqk/+g1b7HzAKzGMqv7H6QTsXmHVdiQGfcV8jZYsBvqCWBEL0TVVPyLAP+6l8plRQBKguRE2Ia+2zJjpXKMV0U7JI5Nn03LZN5iATnVV2HXaZPTfDysA3Q1K/9NkRKBD0853ojlYJKoBs5Hrt/Luhk9Ygy8SZ/HhnH4eie8ndVKKRpkk2T8a4tMUtSFPKik7DN7U5LDF/OlG8FwvpZz5S8z2RHT70vz39t0nstJUafw9a+IIvJW6mC562dBHcDNnIqhLtMQyIkNkkB/AeoTKnvy8iUxrrochqES9rgApIJMESx2h6p/SyGeiJvT+ABD68YOkKVgBY1+LZ6mO3tkTKcEL/OpmzUWkylU3fQXaQv3Od+r6qG0DK+QDrl+bnO851Pb5NXBOs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

That makes sense, thanks for explaining =E2=80=94 I wasn't aware Reported-b=
y
needed a Closes: link specifically. The inspired-by note with the
link is great, appreciate it.

I'll take a look once you send it out and add a Reviewed-by if it
looks good.

Anshuman

On Tue, 25 Aug 2026 at 16:33, David Hildenbrand (Arm) <david@kernel.org> wr=
ote:
>
> On 8/21/26 22:14, Anshuman Tewari wrote:
> > Sounds good, no objection from me =E2=80=94 happy to go with your versi=
on.
> >
> > One small ask: since this fixes the issue from my original patch,
> > could you add a Reported-by: Anshuman Tewari
> > <anshumantewari123@gmail.com> when you post/apply it?
>
> We typically use Reported-by: for actual bugs and must accompany it with =
a
> Closes: link. That doesn't quite apply here because this isn't really
> something that would ever trigger and really needs fixing. It's
>
> Suggested-by or Debugged-by also don't apply here.
>
> I will add
>
> "
> This patch is inspired by previous work from Anshuman Tewari [1].
>
> Link: https://lore.kernel.org/r/20260821114416.12255-1-anshumantewari123@=
gmail.com [1]
> "
>
> If you want you can send your Reviewed-by or Tested-by tags once
> I send it out officially.
>
> --
> Cheers,
>
> David

