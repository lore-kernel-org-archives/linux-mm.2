Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53475CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:20:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B52386B00B5; Fri, 22 May 2026 12:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02DC6B00BF; Fri, 22 May 2026 12:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2236B00C1; Fri, 22 May 2026 12:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE6D6B00B5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:20:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 349A81A0749
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:20:13 +0000 (UTC)
X-FDA: 84795567906.25.80F1F1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7D05E100003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:20:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j85b84o7;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779466811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnSicpjvcBNVy0CRSGn1QhxVVZS//kfYT8GlbArGmV0=;
	b=mPFm9N1uHmh9nM/nJnL0nlvrvnURv/vaUEwNrlJfNaWsDzQ0Qd8qQbslZqb/W9b1hHG29+
	eoN+dhXhAOGNGZEqoZaCamxCV0oUF1cSXfk03QS3qVsA2roMdh7RrrGOxrErqaqKISBLyl
	kLljwbd1cc3seg3QsUINJk1/WO+CGgA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j85b84o7;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779466811; a=rsa-sha256;
	cv=none;
	b=vfl6thUVd4wHTLBhI2I6uJ774HJeGqzB171+Th07JcGXvH57jH1GJiOcnpoRTuN7nTPXJn
	r/e14s7q33rMHP73bwIg+7OHFHB2m06jXZTYwtvsL2Sm+CzL9iuykovBfLaYniywBbOea9
	0uwPj20j57zAN+Gn3NvF3566Tpm5ijU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B120C60138;
	Fri, 22 May 2026 16:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F821F000E9;
	Fri, 22 May 2026 16:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779466810;
	bh=FnSicpjvcBNVy0CRSGn1QhxVVZS//kfYT8GlbArGmV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j85b84o74dlM2RlikWLtxJ8InZVwop88/rTxiPexhk+8nBlTalaWkjejulMgi6MOg
	 Otfw6BCjq5y5HGx6wlPg+DesU+9LvQ6X9h4vJsJW3JWyTuk0PqiGTMMCUXmO8uH9JZ
	 uSBnA2R6/ORbxzKWFOOhviNaYIyIAv9GaSBrTSp4GQRNF6ocMKKrHn/PNEjEF1VtSB
	 kB03USBOnE8B1vWYbl+ZJHc6A5c5hDGKeyr9ruTS0p69+lgtuDNbca5ROQWi6u7Ch8
	 K2cb9KUB+u00h4qaTL8jEGhsg/lzQC4FM5nZ02MHuluix6um4gyMrG53jy05UiNu/f
	 Yj6rzl4Fhc5Hg==
Date: Fri, 22 May 2026 17:19:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
Message-ID: <ahB_hae8coGvf12Z@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <CAA1CXcCoDU_pnp0SmMzRi8wPGB1OBjbbokevq2X_03X1vpWtOw@mail.gmail.com>
 <ahByO_HWn6MB8z-u@lucifer>
 <CAA1CXcDoFdZZ4aBx0BPA7QXYKYBYDoqUiLTLYe3L5opJ0LsJGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcDoFdZZ4aBx0BPA7QXYKYBYDoqUiLTLYe3L5opJ0LsJGg@mail.gmail.com>
X-Stat-Signature: me5c5k6tztukdyeunf61icihdy9jeif8
X-Rspamd-Queue-Id: 7D05E100003
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779466811-535518
X-HE-Meta: U2FsdGVkX1+7ujPca+8Ufv76rK2+97MvRKZs0t1L9eC+wMUerKlhmIciTxaA9mBj3VZkTvze9MRdxRK09dlwPPt1VvuiSPEnxrTMqunhGTWeE5BhOz/gixUB0xSRnVgifc+IGiN/8EcdkkPBaNhryE7qPbCi24H3J0t8eRu953rX5y1tFH/0MwE0pBWKdUsSnu++PaTUbZQvGcqw+P5l4AyMYwUdueZlmWMX3SSI+gAuciS1RrsJGoabiowOMMQfxd5k7mtjN6vfroOv3GmjY+uym0JC+kUrkZfj9TiT7bGV/PJSymv6wVKBxalmVnvjsqIkjjtUDcnI/a8Wd/1TfFwdaiEhGrnO1IEOmcpP0maip7w4v9241oCmfYk6xl/PdsPLsunyZQjWiEKPYt4bHgmNumZ5qfHn/Y1uUuG/Bd9Nj3Ikm6XbDNWPxophY4favGMH3ghi6VD9hFJpFQwPkOYGhUqZelF/yI44X20OZzPN5zlKREMenGhHdtKDeDAbrfRfQnLTV9DBSVzmUgL0aS+2/CzPq/hQwGEWui3g+t8/z7Mv1J/MXX8HA/CzfHDBuRM/0/ygvpjYQcaPDAPGiws9STmLPnk99NkY6C9InRoHky+hHdn/RT0IfO2njy0rZHk5HoCrYRDYQz0lUFOb/7mz6RM5VjE2s513R7WWE0noyYgpRpwbkgWxgY2TzDDzbjIaR7k7BaKtEYTv8j3nXoDoYzStrfnPlxJwErW17efI9l99Z2RrxUz57s57t8voZb8xun4PW+glh4wKtIsi0o+nTjMpdzOp6igSsJtX6Hjx4fgXzQ5ZpW/j8e5PmIcmJPQBN7QD0eIJ1MmVNcipAynN4GyjpWvnaPIjdCI9v1c3GnevJQx5ZPKRz7ai+zNjKARuhU5WDWlIXM5BHuIvMxcgPSx14Qd2L6QBHzkGzXkiuE7J/4eZYmt1tbC2kiLh0UlbQ1f8MsG1yVdP7hG
 xunl9xe4
 +3jcaG/iwerjzKuzPNy2nxXZLePWurlKOWcyXJRLU+KKFj9tZpuArfnvJzPy47mr7M3Es8UFsiJCqrxGBoQ45Gv1NagdAHJvgVQSVBCdfbKsij9a0E/Ok5bWs4fK3odIErODj0UplyoybH+8eZ15RPL7ihXb5PPJp/w9qcpXjY/y7To5GhIMT3fyLoTUFMQ14amUxu+UhXyVOV1nunXCVkyxR9b1j6pn+ZGoFqScB+PaREUUsU3+Jp+OWBgaeRq3DGntwENRvM66pkoVU132qlZjyO5uJwqkcYcNFdXOP19Kj+sXl3fW43RPXeYSTwggudkXp++g7yodarMNa8qZIw0isR0M3Cjm6WjUfmuvGFukPwPrY2KrcE/W/oQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 10:08:19AM -0600, Nico Pache wrote:
> On Fri, May 22, 2026 at 9:17 AM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Fri, May 22, 2026 at 09:07:29AM -0600, Nico Pache wrote:
> > > Whoops I manually changed the coverletter subject to reflect that this
> > > in on mm-hotfixes-unstable but never updated the others...
> > >
> > > Hopefully that is ok. Just a small mistake. Base commit is referenced here.
> >
> > It's not ok, this isn't suitable for a hotfix in any way shape or form?
> >
> > As you know, because we told you :) May has been difficult because of
> > conferences, holidays (and in my case burnout recovery).
> >
> > And unfortunately the series seems to have needed quite a bit of review again
> > (my suggestion to you would be to ensure you don't make major changes, only
> > small incremental ones on the basis of review feedback).
> >
> > So this isn't viable for 7.2, and we'll have to target 7.3. Therefore there
> > was no rush.
> >
> > Also please don't spring a respin on this series on us without discussion
> > first, with people away and (frankly) the amount of work involved here,
> > you're going to have to accept the pace that workload/availability permits.
> >
> > Adding spurious hotfixes tags doesn't help anything :) please don't do that
> > again.
>
> Hi,
>
> Sorry for the confusion but Andrew and I spoke about this before I
> sent it, and he confirmed that I should send it against this tree to
> prevent merge conflicts.
>
> Because Zi's series depends on this, and this is already in the mm
> tree, choosing a candidate before my commits was best to prevent merge
> conflicts.

There's some kind of confusion here.

This series isn't suited for 7.2.

Sorry but Zi's series, unless it depends on functionality here, will have
to be rebased.

People have been at conferences, people have been on leave, I've had to
pace myself for health reasons and it seems there's been more than simply
review comment-based changes happening here.

(Again I strongly encourage, at this stage, to ONLY be making changes based
on review, not adding ANYTHING else or changing ANYTHING else to avoid
delays :)

Also - shouldn't mm-unstable already have mm-hotfixes-unstable in it?

I think in mm-next we will have an stable branch, that everything is
based on, where things go once review is complete and things are mergeable.

And a separate hotfixes branch based on Linus's tree.

That would avoid issues like this :)

>
> The intent wasn't that this is a hotfix, just that this was the
> closest base before the v17 that is already in the tree.

The convention is that [PATCH ... <branch>] indicates the target of the
changes. Putting the hotfixes branch there implies it's a hotfix.

So please be careful with that in future :)

>
> Sorry for the confusion, hopefully Andrew can still apply it to the
> correct tree.

I'm not even sure what's best for that at this stage given we have
conflicts and this has to be delayed until 7.3.

I wonder if given that we should not have this in mm-unstable at all and
just wait it out until the next cycle begins? Review can happen
concurrently.

>
> -- Nico
>
> >
> > Thanks, Lorenzo
> >
>

Thanks, Lorenzo

