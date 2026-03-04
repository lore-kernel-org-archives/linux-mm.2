Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0DDEEF9011
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8A16B008C; Wed,  4 Mar 2026 11:53:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B00B6B0092; Wed,  4 Mar 2026 11:53:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6986B0093; Wed,  4 Mar 2026 11:53:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED5DE6B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:53:33 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B94B1140637
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:53:33 +0000 (UTC)
X-FDA: 84508976706.07.61D469B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id DEBD320016
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:53:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p8cv67e9;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772643212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2sR/y/6RjXKZA2Xb/NJXLggqVzGt3wK9gVfzabs/UkM=;
	b=8GPhd7qYaK6M8b6jzNAkC5C+lWWrb5ft4MjlyDFNpJQcfuEcyit2iMQxX/uy/uRCYdiutE
	IaxJlop+A+jMyvSmPIg1vWobZ1KlFacuV1WRbW3TPh7dOaMFKxFAh1+957MsFCj3+35dmz
	yuJDK/VYyNwmHBynYQskd2jzdERCcaM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p8cv67e9;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772643212; a=rsa-sha256;
	cv=none;
	b=F5q1FUJAY1Ho6iJgoHDdFFaOXk+nYvYht4tU7DuJoqcDA8JksdSjT7a2HyuTqYplvJ38M4
	6wpkEycwnpuIh3ZODa42KrZyUDgZ2/gRdF45XykRQOllSqpr+RUJ6HhiIiMU9x3rFRi5L6
	343yG4zA219u3eywTNUpKMhWRbV43po=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A5EFE43D55;
	Wed,  4 Mar 2026 16:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E293FC4CEF7;
	Wed,  4 Mar 2026 16:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772643210;
	bh=sDB+az1bAXOGbWMmUUUu0SDGfeabr+ekuNO1hj8thSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p8cv67e9ssUeWrFJGzAnKEG//LYmeqoUbvIrlKriZR7tjoP6HIKPNDX8pAccTwBH3
	 kXINSbiaDo1xDJrz/JeaCLaBaVqAnxS7nhEA2lvzOiuDnxxjG11JLenaxDm+s3Lxj2
	 gBLGMkVgja0Q4hASgoNQuIwIlGSxpW6FrxNNdPNh4/g6M+m2IOlHz4cIUNw50qQg28
	 S1E1hSZaFUqKAdRvL5ekKo6FKeATDlnWWE64vY5pnnLHk4JSh7QwNEnHPKQCu7T+j6
	 PIJ1RxF0irx8ZP6DGic6mucNZ5qkVhr+BkuZBSZI1pTlvap4lmikyHjbTLgwLSHuAZ
	 l9ami0VnilBOQ==
Date: Wed, 4 Mar 2026 16:53:27 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH v3 2/3] mm: replace vma_start_write() with
 vma_start_write_killable()
Message-ID: <76aff8f9-1c08-449a-a034-f3b93440d1a8@lucifer.local>
References: <20260226070609.3072570-1-surenb@google.com>
 <20260226070609.3072570-3-surenb@google.com>
 <74bffc7a-2b8c-40ae-ab02-cd0ced082e18@lucifer.local>
 <CAJuCfpHBfhKFeWAtQo4r-ofVtO=5MvG+OToEgc2DEY+cuZDSGw@mail.gmail.com>
 <aadeHiMqhHF0EQkt@casper.infradead.org>
 <CAJuCfpFB1ON8=rkqu3MkrbD2mVBeHLK4122nm9RH31fH3hT2Hw@mail.gmail.com>
 <aael1XWaOJN134la@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aael1XWaOJN134la@casper.infradead.org>
X-Rspamd-Queue-Id: DEBD320016
X-Stat-Signature: inyxrrdsebgbcga7zq351jr19jsm7j3g
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772643211-884976
X-HE-Meta: U2FsdGVkX1/8t7DvkWjtf6PDNU5cNhj2DUroN8n77k1mkc7S7SJoOpKNP1QPVkZPGHjRMam4kVE24WxTgsY8ru8bHYAhc6LPb0wnyaibsua6y0vLm+2QBGGIECgKkak5TxvXI0+8W2Qen0rm+oJhy/XwFRqHdUjgTCqRs1PaP5nXS5XrIMdO01l4ybP0eeVx9MoqGyXjjami8URDYIQMoOu7bZpAXfRk7XMI3mnxwkJq/QoIoCDiyLGBYkW4IXlGdO0n0iLomMRUmmvQmyEHFNj1uZwa70QGHspJtQ1oMXhNA673yWWy2UAner5dOu322T+THHxaxllhqt6sXAAmI/Mirean3yohNMil30tzWluno3AoGx0yPGsvmltJcSjS3rCCnA3X+ZkG9aAVl42Cuq997ofOZtV5cHgapeueZTXfaUDsLYQZGQkwDEquROihHBCHYRfi4G4z2q9JjzO9rkV0ungTCcve4uoSAX16w1SCec/bvKolWMv7HHdwPtXHX+UHkr8048LjXjuyeMrR5hPIKJFfkdNB4gj5soLlkRamZAKbZSD8wDP04vJeA3I/WECznKamx5YQWUNAfd3IloPm8qkM1iDi0pkEOmts9GH6Y/c4ICxIuDAX7ellXgohc6ZyN8bcZyeGjBiDXxDnhfQdaCCJ2UQVYmLZXRxGCyh2oeoAtso4rpfdqWpvmyvfaau7dtrP2gx4finRKFdw4MhK7U6DyhvTSN/kKCPpyEEZvNSPqZp2URDx4uAMuALSmyYsWT0y/gU9QPHAyFpOoYH6vvor0PKcDsuY6rmCvrz2OraxpdG3BpFkLo4a9wAMsieypFusATskjWHk/p5sGmc/I43YbOtZbWu2Y4yPRmqV9iKVgR67X5lqrnxKYZOgCs4hYTIXJ8xlYA+FJTX0tps90c/HUq+h8IVNAGN0RI1Fn9IKnDM6bRLcK3J/9bDfHclYJhd7/uSjXpY93qH
 0PgvBr9G
 AyZVLSC6RWubV/H5LulXTSU5+kSwr4qiWkMcPHtRo16wX+VJ7+OaJ+dgeCkWAk15jnpIXA3Lw77IhYCLLtIv28hij3asqAemv+pKEOsdwuNf+s8Umtrj+n+rOWnopCramO8gzaEohpvKYka8H/RBxTr4xTO0p4bmVeUuhE/QxjvpqtQv4ATuAmt3k42gZUJKG96emYRId2BjiSOKc0PDFzVAVWUpYBeaFV/jHvrugq98CwliDteFBts5R4Tb6dBXZYvpUwjWrndw08a3qThSl12Rer5PBcTIFqP548/d0Q74Aud2GW9HAptC7Jt6oEAX9jVxhd/FTQVeTScNFQs1Z78mxqw9Iw1v4JNqNJEHJUskqRBfbkUy4Fxerk5P7rvlOnuxYNjvrnj8butsP2/GeYIbCG0Vnr+FYenjUeP14vrwtAI3XxuYyCZ5Y8BREBZ3YydmY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 03:24:05AM +0000, Matthew Wilcox wrote:
> On Tue, Mar 03, 2026 at 04:02:50PM -0800, Suren Baghdasaryan wrote:
> > On Tue, Mar 3, 2026 at 2:18 PM Matthew Wilcox <willy@infradead.org> wrote:
> > >
> > > On Tue, Mar 03, 2026 at 02:11:31PM -0800, Suren Baghdasaryan wrote:
> > > > On Mon, Mar 2, 2026 at 6:53 AM Lorenzo Stoakes
> > > > <lorenzo.stoakes@oracle.com> wrote:
> > > > > Overall I'm a little concerned about whether callers can handle -EINTR in all
> > > > > cases, have you checked? Might we cause some weirdness in userspace if a syscall
> > > > > suddenly returns -EINTR when before it didn't?
> > > >
> > > > I did check the kernel users and put the patchset through AI reviews.
> > > > I haven't checked if any of the affected syscalls do not advertise
> > > > -EINTR as a possible error. Adding that to my todo list for the next
> > > > respin.
> > >
> > > This only allows interruption by *fatal* signals.  ie there's no way
> > > that userspace will see -EINTR because it's dead before the syscall
> > > returns to userspace.  That was the whole point of killable instead of
> > > interruptible.
> >
> > Ah, I see. So, IIUC, that means any syscall can potentially fail with
> > -EINTR and this failure code doesn't need to be documented. Is that
> > right?
>
> We could literally return any error code -- it never makes it to
> userspace.  I forget where it is, but if you follow the syscall
> return to user path, a dying task never makes it to running a single
> instruction.

Thanks for that Matthew, that makes life easier then.

We can probably replace some of the more horrid if (err == -EINTR) stuff with
fatal_signal_pending(current) to be clearer as a result.

Cheers, Lorenzo

