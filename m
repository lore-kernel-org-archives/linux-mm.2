Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0BD5606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=PumzwmTQ
Received: by kanga.kvack.org (Postfix)
	id BEA306B05B0; Mon, 26 Oct 2026 14:02:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B006B05B4; Mon, 26 Oct 2026 14:02:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB1AB6B05B5; Mon, 26 Oct 2026 14:02:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86AD66B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:02:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B49B1A0795
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:02:00 +0000 (UTC)
X-FDA: 85365546000.24.110340A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6B818140014
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:01:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PumzwmTQ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793037718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PFsJLihFaPQXHz4UKfvj2WUy9LWdZX9tEl8YZxtmyM=;
	b=1jh6eoyvwCk0HPjrI4/DfLIqsLvkVLnmmyeDZTpydDMzDAnkQ90DjMNtND6GK/uEUreSWa
	hb6Zw8/yzhvBYjvVoirACvgR4qdo/IjRcWLfvtFwzVlxbmFDZuwk2J/gVoSks5tgY5YGvq
	1Qk/KtGTFFiHbmFOECjQI6igtIWY0Zs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PumzwmTQ;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf23.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793037718;
	b=PtLhfiD+QAXRmVAS44iaXjyE6Hi4w0ZllflmzkwKxobMU0LnEa8TQbRh/WJGOzNVgYmSXj
	F9EGhuYharYfaXQ9ukoav4x2veDTKFYiPPG4HuGMkHtKvJ81QkU6YHSy9/uYUFrtoEOsz2
	hJfy5+zmZPgknWyrQ9N/BbWRRQdkH80=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3PFsJLihFaPQXHz4UKfvj2WUy9LWdZX9tEl8YZxtmyM=; b=PumzwmTQ9yri+zottlvBujb8h8
	G0+sZp8mwMJwQwf5pcjJJvRZICU677fKHFehVVnmMNH6OuFohjOjRL/wBGGFRuHx50Y45Uaf7Ujtx
	6BZjIXuRDMOoF9PFSiRQm9f5TeQIsPy40Pa0JnSJbPYnUlGD9D3TwDjhHX9wUobWNdRJiy1KDNiaI
	GfvrMFGXPovbqP8CNFgH9z5EHgOfQuKMvn2mGLRb8Zs9Si6/013n/WuMTHJRb3e8HRRcYF37rSiZ5
	SGJJMLEGDNNuRSRTbCIfZr1JbW1bYJpnWtfOajpPqWDz9e/ouWg0qnlYgzF0A5SQolcoZIw3jTbd8
	26Vq1oUg==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLP18-000000032DW-0VC2;
	Mon, 26 Oct 2026 18:01:54 +0000
Date: Mon, 26 Oct 2026 14:01:47 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
Message-ID: <ft4q2mxxiihpvc6wjs2pyku6fvfqg5r4brpgjvz4ikkeh7vwff@s6h5k2dxstk2>
References: <20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.org>
 <at8-42OwXk2z6-HB@gremlin>
 <CAJuCfpFaxo06yHdVKsEEmFf9qoOYS0DbMvUuAZEhNfDe7dcwJA@mail.gmail.com>
 <8c5a8fb7-233e-4433-af45-b67cb2528b60@kernel.org>
 <at-M5hORjFt6aur4@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <at-M5hORjFt6aur4@gremlin>
X-Rspamd-Queue-Id: 6B818140014
X-Stat-Signature: 57d37g4qez5sst89gzkn7wwpjwh1cbxi
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793037717-348312
X-HE-Meta: U2FsdGVkX186DpkcEYx9DNetZiADEZE5skfp2AnQqYbChkbabT+/XAP/f2ZmcR58/zaNtjdQ95hbcSTeqUiABOQ3vZj2HB4OTCAHQgCGU6tOUzw0QgKemxSK3Im8AkQSGZRsq3qPxrFVKznni9dUU40w16ep3Fm2OoIV+cEbLUfH7wGl7JU50errySbpriksk01ElJAJm8xLzneJxhimBz2JqTzt0eU6wt6sBfIVvjKd2FSBQciAaEo30ry0cRfEk2NS0JKqk2nh1mAkHbnmBsPPn7sstJWeaQFJFJysLzUCZoEbsaFXzGBMcNm05fMjcFhJbDkOZY/StZyoGgBzTa2QlxZbIs29m0amCmRwj9ct+6X1UgY0bxTbarFOzTQfLKFbAd7aHtS3HjwR+909l72NiWxqtZNIzJSzMAarAaACToEItKpkyj5qhhnzLUOQumTvFTVjtULwnDesHK325CvhzEREV7GIsWzq9noFnUL4guH1rvuLNA1nQ0/AWYE8AjsBL/Rss/qoa4VQSN5sOxv1/Er9Qsky5rS40uY5vPi2RW7MYPOVuMBC+6r1zjhovevBabeec1QF/zVRQ5wN70XInBdOUbn2o5Emmsw1rGUrSkKBmiypAk0A0hK+rPKCxrMBzqtKTqywYppWfCSiFYMRJYdkWXxT+4972kPzu6iQaeLFqcFdEVGHz1adfBMP/KEg6AFtmeE0i2vTuHZ/YMMFkbKLIi0pBaDFy6A6w8g9VK2DsKrePzrFLcmiVOS+wNOlLFLU/Qsk33mXO66L8TiMNKh8Nq+PkbIE5U46/Udnl1J/Pbz9JGt10tRcEVCiTfWT/JE3CKpGw7PP/YPUnJ0uStTXBDq1pOw0GBxMyHW5ipjVjemfD6s+Z6p9aNyfSgleOGh/jgDW0FHc3zzbvBJW4LHP2+HzbDNR6R7crknkQ58kMUaoTtuj/ZBvy9zAZjdU1PyorSGtoQCf+Bj
 2kLN+C1S
 6GAWlJQbyqJW1K8dSPoGAG00b94qfKZ6LjItWmUD1Cvg0Snaae0UXNE/JOfTpj/6/UJMDE0vQdXXDWhgvUMumt1NO2AEQ5Oxo/eA6KUKKDWpNuLnrw6Wvg978mrLWvdHx9MhTI2Su0ldsdiBPkGyfPoAUTycQFZ9wdqBg0PE4GiTqe1W9FpP6s5Oy7E1TMs8uxrMimvz7CZ55YX/5SxYE+o2XccH/a2oK6HbQZQ3U6PnmMKk+bCS/8vZMJxYyK82C8R7wkaml0J2I8mU9YwtKpNj6Y8JP+uZt2dZcNdEsRp3ANXF+fQCnvkpNgW+a7gI3hSo5cqaPdO4GUkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/10/26 05:26PM, Lorenzo Stoakes (ARM) wrote:
> On Mon, Oct 26, 2026 at 06:19:18PM +0100, David Hildenbrand (Arm) wrote:
> > >> +       /*
> > >> +        * No lock was held since the last call, so the iterator's cached range
> > >> +        * may no longer be valid. Always restart by address.
> > >> +        *
> > >> +        * The vma_range_is_empty() checks below avoid unnecessary mmap_lock
> > >> +        * fallbacks.
> > >> +        */
> > >> +       vma_iter_set(vmi, from_addr);
> > >
> > > This is clearly simpler but this unconditional vmi reset is not ideal.
> >
> > Yes, exactly how I ended up where we am right now.
> >
> > I pref my current fix as something to backport that avoids performance changes.
> >
> > If you two disagree, please take it over and drag it over the finishing line in
> > a timely manner.
> >
> > I wasted enough of my weekend with this over-enginered piece of software. (had
> > to change one word before sending, can you guess which :P )
> 
> No problem, will take over.
> 

Just a follow-up, another option: the vma iterator can check the
previous end from vm_end and set the maple state to the range of the
current vma if they disagree. Using the set_range() and not
__set_range(), so the next walk will be a new walk immediately.

Thanks,
Liam

