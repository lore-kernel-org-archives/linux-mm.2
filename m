Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58BC6CA5FD9
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 08:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226096B0088; Fri,  2 Oct 2026 04:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6A26B008A; Fri,  2 Oct 2026 04:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F6E6B008C; Fri,  2 Oct 2026 04:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D86916B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 04:10:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61A73A0676
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:10:26 +0000 (UTC)
X-FDA: 85276964052.16.50E79FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DA29880007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 08:10:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkKfj52w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790928624;
	b=gRHl670Yu/KofR3pX9/AqFxM1gJ4j339/hnHw/HyjAdQidmR17cp34dVKQIhAvOaBgO284
	WPtzjpPWMjlGHHVk5OqhJdnpFp1oS7UzrxExLjeqTUWPFwlBDwCYtVkTTe71fOaBRjB6eQ
	TM5ntEKKCtq4XeMRnCN3NWFb2QCMVNk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkKfj52w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790928624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIHFM4YkUGLtT//ijgD4g07c9OxY00eHXMaA/kwG2nM=;
	b=DzkCsHTVR4bzHL4yPY5Yz5FY3SuYxY9iBjLsD+pReiWvnVSpPjjZ7P08LsZI+6VbN4Vtsk
	J5mz98pZV6VH89wjzIeV/kgIBCB6XFLIwYw+x/WWcnm9AJl81Qh09fzM8pgNPlCJiduIFi
	ip5/6sOR8268KSHBRQyypbCQpciE7JA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01FF160A5E;
	Fri,  2 Oct 2026 08:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD511F000FF;
	Fri,  2 Oct 2026 08:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790928623;
	bh=BIHFM4YkUGLtT//ijgD4g07c9OxY00eHXMaA/kwG2nM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZkKfj52wi+HBtm4OSS7+TGHkipMV+dWZaiDRPkTP1OUg2cSZgWi236Wj6NYUE3zhP
	 cE/wLWLsAeog8taVdUpM5sc8E4yCibHvboHgqOHxAEG+Y5Z/wzqywqWTkRHX1PX8RJ
	 Y6MrqkaPJzwXRfn048jxdDXzNp00NQ6UuQjAuOmLFP1bfYlCjQ7TtK0Qzpq09+/X09
	 mUlW0HPJX0OTnzNLrxPH7PlPg13Ld0kUi9GjYTFEQg80JgThJuOQqXg7k0VabrPqqj
	 M9I4tH9JjiDYoMcnmK8F+JM777QiRIOEKoJxCdsUEHTj9cABRLPo4injcxApsYeJGY
	 nLF4S21X/85NQ==
Date: Fri, 2 Oct 2026 09:10:15 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, johannes@sipsolutions.net, 
	linux-mm@kvack.org, liam@infradead.org, rbm@suse.com, akpm@linux-foundation.org, 
	luto@amacapital.net, brendan.jackman@linux.dev, liuhangbin@gmail.com, corbet@lwn.net, 
	kees@kernel.org, broonie@kernel.org, mhocko@suse.com, rppt@kernel.org, 
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org, wad@chromium.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-um@lists.infradead.org, 
	geert@linux-m68k.org, daniel@thingy.jp
Subject: Re: [PATCH v4 1/2] selftests: run tests on nommu architecture
Message-ID: <ar9ldn036SgT-bq1@gremlin>
References: <20260929235711.2287931-1-thehajime@gmail.com>
 <20260929235711.2287931-2-thehajime@gmail.com>
 <bda5eeaa-7868-4d4a-9026-9e99347afd7c@kernel.org>
 <ar4br2vW7yZGd3gt@gremlin>
 <94759bed23f00d2044005e36be6f72f297e092f0.camel@sipsolutions.net>
 <m2se2o3jyc.wl-thehajime@gmail.com>
 <a65f4431-d225-4535-b921-00319ceeb2a2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a65f4431-d225-4535-b921-00319ceeb2a2@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: otejka8dacfhj587wu3xc8so1aupr45s
X-Rspam-User: 
X-Rspamd-Queue-Id: DA29880007
X-HE-Tag: 1790928624-203648
X-HE-Meta: U2FsdGVkX1+nUO5tGejkpprLobNXWFub9wxLHWD/UjoLz5y5ZV75GyKsz+SVDXrKjjHv/WlBaA5GxQ5HKcTVJDY1sY36xRlTLbVRns0Htjx8f10+TRR391AewFj3OAJWjI1RBNiNI8MoYmeLHYwhDVJA79iMZYK0JwAbCV7F8bA1QyAdt29m0R2EW1kbjnCYmmipMi4pb83/3ZATOWEaHHfvKRPlUB5TOcY/uymj3SVSQzdR3k5OE7kcpB9iCaTzIcEbstI0D/oBsDWGEOTntqxPEfsMW6tt+wgd4rF1zWrtNufnWI13YSw51jjU0kkw2ODzUjTJEtGf9dI+w0X76Hfbv3vpmEfP9egPX7CR9nzg6q43rHbYUxHxIfZzxcwaUcq31vVGSw3EAqI//MuvhfLfY/LmgdDV8v2J10d+KidIjHgB9fistABbDF3tcZfh1hB8JgL+qL52rEy6+lCdWEFhJDe9waiFxKkpmoSDuyPLRZkR8pmlxnAy/W4ZY7SOrTAb+CIQU2jafPVNejO07E1b5qCBZAbr7elDsWwhWgcuKb6vg7B9XIKa+uTYbNXgBtB0f6lfziiqv2HLnCYYkdZoijNeR9KPrAvFZQCVCg8FBUNmh6cBhTbNZvfvs4pJiHv3VakaI2dm2Hp9ZrPgAx1aNK1yQbA4n6rbyiz85JlM6HkkEhIWDvYrQ4UB4QNlJVLbfxfj6MK7q6YyBBACBf+iuTcSjdmXLz5e+MKtSasTFrVuXE2CXzLTHTpEdAnw5BbF3ZPHZDlEcWSOwJIpXxoOjAbzrhkd26DH1R8A8l/x7Fri0GFd2XI8g3BFpV0qBQdPWWD/TYgRox9FqwXguc3voXwg+W/VDd7O5XTQ4Cpo0rl8ZilNJgleE2FhuqLhNjO5pkxwzgcA4FwJ+79rAN8MjsRxUJkWGY1euKORg9ZE7oECPRhKqOAxH7KqUYQD+iHMOTEDS01UsiXuodG
 sgyF8XPE
 unUL16noUx58tOJl5+HLBraoHdklgWxLD2epULj1WG5QHJn2k0XJOHrCeNajeqEXVTONYSlNNmRZ7m8pyerSwWbc6QgSO9/BeWJJl4ITLAedz5o5FBDwbpCCJbqvbFcsNt9+f/ZGbJk4yyI7dGKOEc+QMGnJ4XsdTMYNw8NWrB2Sl4fHqnexw4aFTcZnnF3QCx0nPK1G7qhh2E+jfcGgTmuIYJX/93QHWoqKwwRtqfn5ONuAYwtqiKtWx+OfaLuFWZ8Bc7duMHDBwyNhvtrm59fX9KQWfxgmrQ9l6z0cgO/rf02H+EhCACgyx4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 08:08:44AM +0200, David Hildenbrand (Arm) wrote:
> On 10/2/26 04:38, Hajime Tazaki wrote:
> >
> > David, Lorenzo, Johannes,
> >
> > thanks for the comments and inputs.
> >
> > On Thu, 01 Oct 2026 19:01:45 +0900,
> > Johannes Berg wrote:
> >>>
> >>> I thought maybe uname could help but our LLM overlords tell me no.
> >>
> >> Hajime originally wanted uname to indicate it, but that caused
> >> regressions elsewhere, so we dropped that commit. I guess we could put
> >> _something_ back?
> >
> > systemd uses uname information and our (old) patch changing the format
> > triggered the regression.  thus, we dropped it.
> >
> >>> It pointed at something though.
> >>>
> >>> In fs/proc/meminfo.c:
> >>>
> >>> #ifndef CONFIG_MMU
> >>> 	show_val_kb(m, "MmapCopy:       ",
> >>> 		    (unsigned long)atomic_long_read(&mmap_pages_allocated));
> >>> #endif
> >>>
> >>> So MmapCopy in /proc/meminfo tells us definitively, weirdly enough.
> >>
> >> Hyrum's law and all that, but I guess it's not highly likely to (want
> >> to) change :)
> >
> > a runtime detection is nice.
> >
> > scanning /proc/meminfo might be useful. although it requires to mount
> > procfs (we can actually skip procfs mount as it is optional) so, this
> > is not 100% portable.
> >
> > checking ENOSYS like syscall(SYS_mprotect) might be useful but I
> > wasn't sure if this is always the case of NOMMU or not.
> >
>
> I assume there are plenty of other mechanisms. Like testing if fork isn't allowed.

Yup that's an obvious candidate!

You actually need to check for both -EINVAL and -ENOSYS since, of course, we are
inconsistent with this.

Some nommu arches specify __ARCH_WANT_SYS_FORK unconditionally for both
mmu/nommu variants meaning you get -EINVAL in that case:

https://elixir.bootlin.com/linux/v7.2.8/source/kernel/fork.c#L2830

Otherwise you get -ENOSYS because it's not defined.

But fork() -> -EINVAL or -ENOSYS = nommu, then just have the child quit and
etc. should do it.

But then that'd need some C... ah fun :)

Crazy to me that we don't expose it in uname...

>
> > My original attempt was to use include/generated/autoconf.h; with that
> > we can omit environmental variable or command argument of NOMMU=1,
> > but gave up with handling standalone build/test case which might miss
> > the generated file (and complicate the patch only for the NOMMU
> > detection).
> >
> > So, specifying NOMMU=1 is my previous, though dirty, conclusion.
> Let's avoid making it harder on users by doing some runtime detection.

Yeah it'd be preferable.

I see a bunch of usage of procfs in selftests.

So can we just please require that the selftests have the user mount /proc, then
the /proc/meminfo grep is the easiest + quickest way.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

