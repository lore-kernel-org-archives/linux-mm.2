Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE487606A325
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WPG5loz0
Received: by kanga.kvack.org (Postfix)
	id EDAF46B00EF; Thu, 29 Oct 2026 05:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8BE16B05B1; Thu, 29 Oct 2026 05:18:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7B346B05B2; Thu, 29 Oct 2026 05:18:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1DDA6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:18:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2DE59A0354
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:18:29 +0000 (UTC)
X-FDA: 85375113138.30.8F8D441
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 85ADC1A0008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:18:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WPG5loz0;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793265507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UkwRg2MfCoRtAJI2sGxhVQjo2bap0vqxQXUt68TRs8o=;
	b=k+GWivregZcQbcoyEe9cqS8sM3sHQse2ssLx3jaFbmjLdRiV9BVNrAd9Ipz7yPfic2Wrof
	gRuAdLzxf+8zp3/4Uwr3mkIoklqsn8TL2DubM2doHYHI9j4Fi5L5j/CZE7KK7v6SzyLer7
	N4MoEKaSFSsPPZAlFrl9ELCZtaddEJ4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WPG5loz0;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793265507;
	b=C9UaEronURay05N7L9jI+N1yL/ftbz9Ra42Kw9fENSwiUJd5e2dlKCyZB4KH0QsQ99CrKQ
	0TFMpY7op1cbMScNaS67iJl+M4bp7+Hz/YGV4EfXppDU5b5ZzkDIyOKONVVNqNQkvvt9pm
	H6nnXhunfUnajC3MH6zV4qxCK+3g2UM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B364140B30;
	Thu, 29 Oct 2026 09:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54F61F01825;
	Thu, 29 Oct 2026 09:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793265506;
	bh=UkwRg2MfCoRtAJI2sGxhVQjo2bap0vqxQXUt68TRs8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WPG5loz0OzzMkDVWR0/RpNMb53o+NMDQ8VSEFjfepQzfcPpperDYBZwPoNNeNuXO+
	 FkRxqWgqe4eYfxS1nYOjB6wQZ/xqbDR+H5e0gXKGrgldBgH4Gmm0OaX81ATkpADRSi
	 TGzIeIazP00gQWOV30Urwq0V5NhUxJrj5dv7qfWC/woUpG/I4RVC7f4FuNgsLcb+c9
	 rOG3r4VVE2tMYRR1aWjgT1wIyKxaF6r3JHRqW/rgCpeVnw/LprE4s6KHUJh4D+YwlZ
	 Eaz30jiCbbmNhI3jaGaef4jqEDApfzBH3O2P/uV4L7REpM6bmmfTT5GthHZY7vWaS6
	 Y/pOavIuBOLAg==
Date: Thu, 29 Oct 2026 09:18:20 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Randy Dunlap <rdunlap@infradead.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Daehyeon Ko <4ncienth@gmail.com>
Subject: Re: [PATCH v2] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
Message-ID: <auMHSGBR6SB6HcTZ@gremlin>
References: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
 <atXjbsDn7DJybsHU@pedro-suse.tail5790ac.ts.net>
 <atYJA7nIu_RwpoCC@gremlin>
 <auIIxSorX0bhZNZc@gremlin>
 <auIPRjj2t0BcYlOa@pedro-suse.tail5790ac.ts.net>
 <CAJuCfpFVv-t08YGMPR3YHCyiOK4HY-YjMk5rB6tdBa=mq2MvKQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpFVv-t08YGMPR3YHCyiOK4HY-YjMk5rB6tdBa=mq2MvKQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 85ADC1A0008
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: m3p9or4uygyb84biuncwqc97jyxohs3e
X-HE-Tag: 1793265507-171737
X-HE-Meta: U2FsdGVkX1+CLBwqGh37ebpdLo4VuuRR3P5Ke1eja9USCB6i1bWFdk2Qn34WNYvrFPMp3q2TIhQ4j5s6dSvLWitjs2XDK3+P5GQkriUkXUyiK4iB+LE7kITDPJNYqJtSzJzuNI3QTdDcyHOW4hbK6MdgjWB5a+QwCkMTX72hd2TtxUXAZhIYLIrN8rmKHPr38zG3VtCW70YZlANLM4w/0SBoogUb3iBp8YuIOhWmlHOOCDsXroB4oiswsl3D/3XFyZGYNQZndkDoWxz2sMKv/GApszY90o0Ki/nczNo51UVzbHAmU1fvfG9zjM1peQQRKCkTBhCcqifg28CHzp2zFkYRGjn6zT9A7dBVCQBD8K+IRAS9BEMpjjeOzZ1xOJhArHQK5Xbk3SE250oyN1Dfnb4F1JdMzaJreNaYA9jWZB9D2Hyk7gHtWG5R0Wpfl11cdOYqtjCoEVVAktKUc43GlwYGsjGIH7vw6DnLP8axzCftHVT35jSej9LQ3gEIc8tM59HbskRKy3guJjPzA+BnLJvpS5RpYyI8AfiH7kENt72lEC3d0FEueXoqeLkPevXzRCyLJrc6TJFKrfu8G5/D/syOpjrFwcgwVRIJwvqB08IE+U/NJ6YGcbke9wSC+W0B/pKlbOPKpntE5jVrsecNp7qg+ksFcKjbnaifVdj2dNkBUmLTJdwmgePI/cohsW5LXLSzroxNI46n9/drpSK5A0460N3OdNETsqcZBMuRCMw970LJd1UAnmM/KXXyDP9OBNTTeqX7sN+jfaoaeu7coI2oyrvCo9Bd8cH+5ADVccDcpqoqzvuQEpagJrjh4UTEw4DxtdUpg6AxjypknDQSUoa+qZ69QFH/AnztMVKm/dyNDP6kW+x6cSfZU36H0NN8y089bpM/b4Q73ORCTE3/9JuowOGc5lmGZymdMO2b4oiik8CtIhr15a5R4fOcVryAixjpxu5usfIcL/4lDtt
 eSgbshWh
 b1r+z63j0l6DuWHE/ZU+22lMw9nDdN7fPR7LlRQFpNc5RfB13MDIkJDollKdmTSJ7o9fGQXkSU5YQ3qZInZyYpH1zAX7zqyNZXlUum3iDlYlIPCxvipW5a3nIPPqeyczAbv8eXbxmiJEJHlIF2BiMwBEiO4tke1GnfD48Pjscgw7XSopHIOHKHGD+vBQ++o082MYlANq9SyWddo08ETt/3OTL/M3uUzSr97yET1n9DG3gIuOP+XlIU+79aI+Ey/o18yblY9hDh9lPe7Csivrnu5CPU5ysHRqcCxmfGrc298Lwvqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 05:34:38PM -0700, Suren Baghdasaryan wrote:
> Sorry for missing this fix before (due to my vacation) and only now

Never apologise for taking a holiday ;)

> finding it. From a quick look it seems correct but I'll spend some
> more time reviewing and testing it.
> Thanks Lorenzo for the fix! I completely overlooked this overflow
> side-effect. And thanks to Liam for flagging it!

No worries, though it has already been merged -> Linus's tree (lol). Obviously
if you find anything of concern we can chase up!

The general idea is simple, really - though there's nuances with the memory
barriers (ugh).

First off, it turns out we don't have to use UINT_MAX when initialising a
VMA, since commit e5e7fb278e59 ("mm: convert mm_lock_seq to a proper
seqcount"), as 0 works just as well (it's not observed since VMA is
detached at that point).

Then we can simply detect when there's about to be an overflow, and zero
every VMA's write seqcount.

This is done without VMA write lock and with potential concurrent
readers. Which is fine, since the write locks are about to be unlocked
anyway, so any write-locked VMAs can either be encountered as write-locked
or not-write-locked safely.

0 is even, so that marks everything as unlocked. However, to avoid read
locks spuriously failing due to vma->vm_lock_seq == mm->mm_lock_seq, that
check is updated to also test whether the seqlock is odd (write-locked), if
not it allows a read-lock.

Since the 'reset' doesn't acquire VMA write lock (not required and not
really meaningful in the context), nor does it block read locks, it causes
no interruptions on that side.

And, as per the numbers I got the LLM to obtain that I shared with Pedro,
there's no meaningful latency when this happens, which for most workloads
takes ~days/weeks to achieve.

For backports, which lack my anon pgoff stuff, I will simply make the
fields 64-bit which make it practically impossible to hit the issue.

Let me know if you have any questions/concerns, thanks!

-- Cheers, Lorenzo

