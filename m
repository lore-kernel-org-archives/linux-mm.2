Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80AE7C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533D96B0096; Thu, 24 Sep 2026 11:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EA596B0098; Thu, 24 Sep 2026 11:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FA826B0099; Thu, 24 Sep 2026 11:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24BDB6B0096
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:29:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B60C480384
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:29:32 +0000 (UTC)
X-FDA: 85249040184.03.AF35422
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1A4A8C0011
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:29:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gsOK/vtj";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790263771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4CDD8TQ1G8oa01QCVgmfSk+fkIBvjWyhYdUITJIOzi0=;
	b=kKS9ThXgwYms5CtE/l6qNMypt0FLA0rMbiiBxIjHBRdVUtDHL+7nHs59k+azSrgjItgGLR
	sL63MD43+ieFG8kpVegw+nMBB1Tbyjboi0MB4CvHNm/xuUrDXIqcnmM96cnVYAzitqJXNG
	XmtKRL8D46tarC/3qqCibSkpsbTCndw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gsOK/vtj";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790263771;
	b=1PVAXDpKTSzkB4YRjIQx84APMVwvkqwB5vwTznk7YE0SYq/Y41JcUcqMM3kPlKmRe+hKtl
	Oo+yXTb1ldnCmoBd5iT60LDUJ1DqSiA3ljCC4hI1JUmcxIexFsGbA0jmFPIqqrh9oz5aNK
	gGh+z+leu6jwkzEUYDbKGnc1pTx5RPM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C9B143F8C;
	Thu, 24 Sep 2026 15:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B46B1F000FF;
	Thu, 24 Sep 2026 15:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790263770;
	bh=4CDD8TQ1G8oa01QCVgmfSk+fkIBvjWyhYdUITJIOzi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gsOK/vtjVVEK91BGtbUMNOrj3Bo+ATVmhtSfHb7BmJN9Tc4DzT57CZaDbdG7mUqfm
	 xnM8jAXmsVmO/rcuRvwTKO/TVzMCCyUEYUFsU+Usgwz3IOyfp13fpTaOFXjg9QY7fd
	 FLqqp8Q3/3fms65qsdaX2pqAAuBBOHn3BUnnZhQlJ0QYAIQk6H3D9QeZvSamzpiPYj
	 S7WOOuj3WuBcphT7nN9YALKjaUp8GROewIBaQLfpSxKfMrHzYluhPF73qGgdaZDWUa
	 8Z8K5rwKHAMq3Z7h4qox4wOuuSi4/b9SAi24rXJdlttIxcFHaQwtEYa+TA5xn6D2kn
	 IzcR2ULRKF1Ig==
Date: Thu, 24 Sep 2026 16:29:23 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
Subject: Re: [PATCH] drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero
 correctly
Message-ID: <arU9Z-EhEQg76CVz@gremlin>
References: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
 <2026092406-irritably-maggot-9512@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026092406-irritably-maggot-9512@gregkh>
X-Stat-Signature: ecrn8j4emfyfsossi6y9j1egrphgkxn6
X-Rspamd-Queue-Id: 1A4A8C0011
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790263770-220719
X-HE-Meta: U2FsdGVkX1/vWV7Zx1tpiw64doDQ/htNnVGsHUA9zbj9eyGmnK7kY0YSpAAm+svfp7HO5n2VFoune5gXCzxMyhbgPTAO99zE68QEdfiGMZMbkdg5ZhR1ZBMKF4MZcrUx7WQpepQBZqj/gk9cTxVPO6plqSFZzvH0lLyc+zCBxkcOV6vaaMmdfD4uNo6jT/wJXOvHTvngmKBL9KfB4ASeRmZ9npEx+cF9oASBY81YAxffw0YykE+D7Fvtf+NABq+WKeY800FpZAO2XyIMQKn54ykNcUgQDp3/5En31KifpjDu7vcB5GP2aIOdmWxna6ISZDexpvejX+jMCY/+nb0XR/IkjbbPYWDHW55TMTjIUCjqFE/uYenPXYE2XDR1l2okhFW8DDtxXMkWDDQfCRN7Sd33XMbb60BPuq1zpa6fgJqVJwVdrqEV2pPievxoDvv7YYOwrEceDHtDvSd0KKrB3ljUDw52WwC21bM+Xjq7qDs+WGNVK04zqFf2u9FjjkrThG75JO09By01jBAcJ9ymwCNUtXfPkBReIB5V85JV/mlGuxzvkgwCrKixMPgFNe74152F/0wEQWm+K9Kn0/8vVfAkmLg5kXe4bmURayjTah6M/cSIj+rj6RbuPkohOx1gQBwz2/wdSWBFfHA3VmfU647bFvIRY9C1nO/LBIX8ytnWp1gZpVhxVGxn+jV9tRVlunyeCwBqeHEBgawlsOmnnb9tpCyNfz6yg2e2E65f8l56pGq1T2xnMWt+rC7cY9OruHbrdK9hnq058vvnUNgMNVop8khRfqoXBjBy9+mMyrg9+dwGwaMSho4qADDUORQjfw5BP0VLqf3mGuO97O5sUgcoqFrxDtrCHN0isugJM/CHVCX4vJClV3oXHrWiz26cUwXkjWrwsK74jsu1USiDIj4DLFMko1lkjwxBT5WK8F8moFMGZICPrRaiJM7bJCLaywiu6VY2tvG2NR7dwsD
 As1FzeoP
 NRW56G9BR1TdGvFH5QxMhqFmkHTPBj8s+aih9bDTCyHiGmA61Pu7txAkZuoEU0KqQYaNcGEXFAKsZeOP3k6u5TYuYa1FZP/t8DQnWKrloq5cmk4M05rJnOo8CiHx+PZ4COhVcBf6V1PMRV0x0ECCFrQJ4iB61Q81mFu0edbSh84lNEh1Knd5TJ8WaV22Xy2IBsUcd6sDToYZlir+2dHhyr/AfVdhEAzxz3eHVNKEru79+0mZtCIVtJ29KNgCB6df3RDxIoC78SKMbTVnatzRSSy4Vvx3qqGNm9oepLEmXZMaUHTK6TpW6hQuR/+Zdh8Whw0c0FOtudTaZFVQ2pdkLYz2Hk7hYieufwMX0SQyObr0Syxlvup0j5DCV7L4M1LUqY8AcCWX9+kvU1FujrD7l5lOcfeyZ5gABdRdqRyNe+ka1SU/sNLbDiU8a7IrMST9jsdsasP1kzVdbw8tv+hbcMD4THvL1Zi2hFGmvbjTJScRQTirP785JR6Hmzp0XwAyYMApLU7tGAnK5HyW1mcN694c26nLx5AKAF160
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 05:08:49PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Sep 24, 2026 at 03:48:24PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Rather surprisingly, opening /dev/zero read-only then mmap()'ing it
> > MAP_SHARED gets you true anonymous memory (albeit in a VMA with
> > non-NULL vma->vm_file).
> >
> > This is a by-product of MAP_PRIVATE-/dev/zero being how anonymous memory
> > was mapped in Linux's distant past.
> >
> > It happens because mmap_zero_prepare() gates on VMA_SHARED_BIT and when
> > mapping a read-only file MAP_SHARED, do_mmap() clears VMA_SHARED_BIT and
> > VMA_MAYWRITE_BIT.
> >
> > The gating is incorrect - the (poorly named) VMA_MAYSHARE_BIT flag exists
> > explicitly to tell you if something was originally mapped MAP_SHARED.
> >
> > So the fix is simple - gate on this instead.
> >
> > This isn't exactly a common use case, but it's unexpected behaviour which
> > now causes an assert if CONFIG_DEBUG_VM is set.
> >
> > While this bug has existed since the dawn of time for linux (or at least
> > since 2.6.12), it hasn't caused issues in the past, so while it's incorrect
> > behaviour, it doesn't seem necessary to backport that far.
> >
> > The mapping is now accounted at mmap time and can fail with -ENOMEM under
> > strict overcommit, and read faults allocate folios. However this is normal
> > behaviour for a read-only shmem mapping.
> >
> > Commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE
> > file-backed anon folios") is the first patch at which the debug assert
> > fires, so target that instead.
> >
> > Fixes: 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE file-backed anon folios")
> > Reported-by: syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/linux-mm/6ab4ae75.80e1c6cc.1e8e5f.000d.GAE@google.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  drivers/char/mem.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> > index 63253d1de5d7..5b93c92c2cf1 100644
> > --- a/drivers/char/mem.c
> > +++ b/drivers/char/mem.c
> > @@ -503,7 +503,7 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
> >  #ifndef CONFIG_MMU
> >  	return -ENOSYS;
> >  #endif
> > -	if (vma_desc_test(desc, VMA_SHARED_BIT))
> > +	if (vma_desc_test(desc, VMA_MAYSHARE_BIT))
> >  		return shmem_zero_setup_desc(desc);
>
> What's the odds that something "big" actually relies on this?

I think it'd be fairly crazy to, unless people really care about read-faulting a
lot of zero pages which they want to somehow not account properly.

Anything's possible but I think on this, right to take a (v. small) risk!

>
> I'm all for the change, but be prepared in about 5 years for people to
> start complaining :)
>
> Want me to take it through my tree?

Sure, thanks, though there will be a conflict against a patch in mm.

Though it's really that the file is moved (to mm/), so actually should be an
easy resolution?

>
> thanks,
>
> greg k-h

--
Cheers, Lorenzo

