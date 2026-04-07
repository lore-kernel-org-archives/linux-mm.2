Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9EF0EDB7DC
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 09:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86E576B0088; Tue,  7 Apr 2026 05:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81F636B0089; Tue,  7 Apr 2026 05:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735276B008A; Tue,  7 Apr 2026 05:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 620E76B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:36:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE0B813B677
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:36:29 +0000 (UTC)
X-FDA: 84631254498.04.D8610B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 29302140002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:36:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l0gMwW04;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775554588; a=rsa-sha256;
	cv=none;
	b=tcdJOLlzPF1Z6aHREkZh8YQ8JNFfU2Eg0EhXqJ2kQHrbBU0hN0PQrWEgM+poFXp1MmAZGs
	roQWBteTfqSmYbY2vb74SiSp3NlSFjqaxDqwPE2j6wJCVR6IuyBAZqO88J/mLqgjFEG1cJ
	GPjBeWpJMLXwvHsSFN4fOV3rIB/by6Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775554588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nE4DGNEAWHklIQCh1vMe0FAieWzW6BSsJdbr6v42h2s=;
	b=LiE8D601N3S4Kp11NUvKDjcW3gnvfzww/87+LvyURSromyMtupBIndFUtTpQL8VT+lMXfU
	SgxUiF3SsFeOEBG+lVZHGirA/mEL4WRfw3fJjRGP1Iq4hrHy8mbnTBqmhx9WCW9vZ9Y7SL
	99HDzb0r+QThnOcfuW+jWHFSgiQXkRQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l0gMwW04;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19DD843F8A;
	Tue,  7 Apr 2026 09:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C21FC116C6;
	Tue,  7 Apr 2026 09:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775554587;
	bh=Xcqs8K1vb05MUeUKbohjw0eLwXgEdr6RXzuOKrc2odQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l0gMwW042HsRuOqECoj0EDgmLBgPl/wHPCYpdzBik+EFVfwmksMgEI4HhIA7gsMaB
	 TbVN/n1MTUAxkgUhDD9MqrEByZtqcEDXKGYJu/OyPw4fUdbT/8FKaaMq15Lt2tsTKx
	 4TDISS6TwM2G0fNz5eb9h3FMYFstU5wvdVaHZuksjG0AaqN+vviQjWfLQX1BIvEuPe
	 5469lbbNYvxnpTe/+d+/QoUpqz4Mxlo1VsY04RHUUchiTtoxK4c10+gmKcEv92/eFi
	 30wjvValc3Eb7rqdgqz2eAL3PxCdLdT+Tf1/SDoK0YP4aO0BPfYge3giJGXr3/wIAO
	 33UqsyZV3Z+hQ==
Date: Tue, 7 Apr 2026 10:36:21 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: xu.xin16@zte.com.cn
Cc: hughd@google.com, akpm@linux-foundation.org, david@kernel.org, 
	chengming.zhou@linux.dev, wang.yaxin@zte.com.cn, yang.yang29@zte.com.cn, 
	michel@lespinasse.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
Message-ID: <adTPQSb-qSSHviJN@lucifer>
References: <9950c6c1-f960-58c0-4312-e4f5ac122043@google.com>
 <20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260407142141059pWDasxUAknP5rqvAMl28K@zte.com.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 29302140002
X-Stat-Signature: 6zpdaxgd3gpbpgm9w5pm9hmjxt1ajf8g
X-HE-Tag: 1775554587-242411
X-HE-Meta: U2FsdGVkX19p77LS2Hz/5vyypNpg0RqkEHWfwDEVqH1ScEP5dBgVf1wW4kJrijSQK73VxAYujjU6ZNJ0VGs/UrbpeZZnBmxa1iT4fUGe4LV8QFxBonY/x9Oo8e7pf+PcpE69sLtzwg17PemI5NQFw5u975G01JP4AdlE0Qej4fKS97Zc8MhC1IJlGUzp+ughnu0rWVsj+q+dPt8TMVKN3GDFsWwEjPyqrqRr8FoE1I0NAl1mAOnewhgR469Rv7x7Z9pWghcNePg6OHk0eeEMRIf8del49Y5KXMGDczi6EJwhoRNJB0wDRHfjoP+wMD5C7kXObDbYJyh1DVvGB3Nqok/Q88GDfUAZufq5BvLOtZeKpzrTfW7a260X19fzKW63K5fH0lKKoXfFYecOOvwNKv5dKH0mDrxNF5tkLJ4KX6bj8vOwxwRWwldUfGM0WE5+eUuwBu9yQTFdyYuEfbXCi27m4gNQhvN+kwT3eGiS7ECWlDHK8ajex6np++cqGqhhFzkSiUclMooglrGwZyEfVpxkcnuldg1O87cewJb0kSCHAl76IBnZVHJ00rNX5aPglUvIm2tiFAnjnyTpcHYNkw9G5jRxahcn6Hp1oDe0MK5fDq4PwHpIoyjZk3hwo0HsXUpPqrqtkStwHjxRxQS4Vz8p1VaYxA43Zk/ieJ8pqpejyK57vNizraRLEUbhCo7ojEVpPt78Jzw/oJC8+q4ApDlsSzhiQJ77jqy58HqK2g89ezuzVp5TqWrZ+v/KNDd5gjJIEmMOqOfEy1S1OTrwHw+PupS1so6S19p+KKpt8CmzvKlfQDMpVF1nFFDznTN8KoXhR9pPu4H7pzoVLKXNyap1NBD0uOWK4qMbTrg82LA8hTlzCsP/xnl9/F8+oBPxhQ7Vg1vcNMp/Y/z3Mfx8aevWwiJwNVoGvN5dXaKz7FVIXVj4yNmSE7n33esNEbxfBtCrij803GaWr1P9Gwn
 Nsx9A7qE
 7Udw9x8HN/o9PX40tIHqVWtWCB5fbKP5hp5XwRCIDbr32xKgLhh0NST/l/MFvZA8v+DZHMO585HCSIqZ07YUqXB0QUHqk6Sl8Uzxjq+2zrL8Hhy8pdZ/dXDKFwS0BGt3+8qhgUFZqa+QAm7G048RO2d4Dr9LlbNZ/eROH3sDNaZbY/e4N0tvwidyKQrLWksJi/VqzUxVKQEewO6QIBGSe63neNMZPfZtoXzLoP+62ZbJ5IrutwKsKyuGffU/bhyMrTusfhgfEREyBAodmc2IWsiIqB8N6aH6rSmYUTB4LUubmIvgKX3ueDeb4fB/GCSisQZIkWjA3aOX1gjw4C/ZzDmPSWEOwOII9ema/hSnA3jFQ1nuf+WgfUTzVllyhMGP6XgZU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 02:21:41PM +0800, xu.xin16@zte.com.cn wrote:
> > > From the current implementation of mremap, before it succeeds, it always calls
> > > prep_move_vma() -> madvise(MADV_UNMERGEABLE) -> break_ksm(), which splits KSM pages
> > > into regular anonymous pages, which appears to be based on a patch you introduced
> > > over a decade ago, 1ff829957316(ksm: prevent mremap move poisoning). Given this,
> > > KSM pages should already be broken prior to the move, so they wouldn't remain as
> > > mergeable pages after mremap. Could there be a scenario where this breaking mechanism
> > > is bypassed, or am I missing a subtlety in the sequence of operations?
> >
> > I'd completely forgotten that patch by now!  But it's dealing with a
> > different issue; and note how it's intentionally leaving MADV_MERGEABLE
> > on the vma itself, just using MADV_UNMERGEABLE (with &dummy) as an
> > interface to CoW the KSM pages at that time, letting them be remerged after.

Hmm yeah, we mark them unmergeable but don't update the VMA flags (since using
&dummy), so they can just be merged later right?

And then the:

void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
{
	...
		const pgoff_t pgoff = rmap_item->address >> PAGE_SHIFT;
		...
		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
					       pgoff, pgoff) {
			...
		}
	...
}

Would _assume_ that folio->pgoff == addr >> PAGE_SHIFT, which will no longer be
the case here?

And yeah this all sucks (come to my lsf talk etc.)

This does make me realise I have to also radically change KSM (gulp) in that
work too. So maybe time for me to actually learn more about it...

> >
> > The sequence in my testcase was:
> >
> > boot with mem=1G
> > echo 1 >/sys/kernel/mm/ksm/run
> > base = mmap(NULL, 3*PAGE_SIZE, PROT_READ|PROT_WRITE,
> > 		MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> > madvise(base, 3*PAGE_SIZE, MADV_MERGEABLE);
> > madvise(base, 3*PAGE_SIZE, MADV_DONTFORK); /* in case system() used */
> > memset(base, 0x77, 2*PAGE_SIZE);
> > sleep(1); /* I think not required */
> > mremap(base + PAGE_SIZE, PAGE_SIZE, PAGE_SIZE,
> > 	MREMAP_MAYMOVE|MREMAP_FIXED, base + 2*PAGE_SIZE);
> > base2 = mmap(NULL, 512K, PROT_READ|PROT_WRITE,
> > 		MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
> > madvise(base2, 512K, MADV_DONTFORK); /* in case system() used */
> > memset(base2, 0x77, 512K);
> > print pages_shared pages_sharing /* 1 1 expected, 1 1 seen */
> > run something to mmap 1G anon, touch all, touch again, exit
> > print pages_shared pages_sharing /* 0 0 expected, 1 1 seen */
> > exit
> >
> > Those base2 lines were a late addition, to get the test without mremap
> > showing 0 0 instead of 1 1 at the end; just as I had to apply that
> > pte_mkold-without-folio_mark_accessed patch to the kernel's mm/ksm.c.
> >
> > Originally I was checking the testcase's /proc/pid/smaps manually
> > before exit; then found printing pages_shared pages_sharing easier.
> >
> > Hugh
>
> Following the idea from your test case, I wrote a similar test program,
> using migration instead of swap to trigger reverse mapping. The results
> show that pages after mremap can still be successfully migrated.
>
> See my testcase:
> https://lore.kernel.org/all/20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn/
>
> Therefore, I suspect that the reason your test program did not swap out
> the pages might lie elsewhere, rather than being caused by this optimization.
>
> Thanks.

Maybe test programs are not happening to hit the 'merge again' case after the
initial force-unmergeing?

I may be missing things here, my bandwidth is now unfortunately seriously
hampered and likely to remain so for some time :'(

Cheers, Lorenzo

