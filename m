Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6665A606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=TEsYbTdz
Received: by kanga.kvack.org (Postfix)
	id 7192C6B05DC; Thu, 29 Oct 2026 10:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A26E6B05DD; Thu, 29 Oct 2026 10:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543796B05DE; Thu, 29 Oct 2026 10:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 317456B05DC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:54:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AEE5B4045F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:54:05 +0000 (UTC)
X-FDA: 85375958850.26.19CC459
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 643F3180003
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:54:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TEsYbTdz;
	spf=pass (imf16.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793285644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=afj3acdy9ojv0BvYV/YH41RH6XpHTpffhj1u2wt7WSU=;
	b=mbwog69QJ/y2A9DRWquGNkzFSOEF1uh4TPqlS3/v167x5CtNf5nd1KPwrqiT0twCjTPOsQ
	10IxLnGFYlaXSpR5RreISQyNedasyGK9OCmyEeQlJBlv3ZohW+QrgOfUmGZZXPggrQ/oca
	E05i8Gv5cYqyz0khQwqSpzOhetII+oY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=TEsYbTdz;
	spf=pass (imf16.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793285644;
	b=vfJil3Wzd6nV4FfsgQpbVMyqdpo/9/fRxDRxjCB90IMAuMII5Vx3EC9pwzxl2LDGf6xIaM
	m1lUz3TgnjBPDW2c1NFuuI6FytDPTUi7jzc0OWtMECt0qxFLgnedVUAzlcErgiFEWMQK7a
	eBDWEYOkJQRDOkK8UqIuFn+X1llaIYM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=afj3acdy9ojv0BvYV/YH41RH6XpHTpffhj1u2wt7WSU=; b=TEsYbTdzMT+SODeK6nJ0Sxuj5k
	PYnCvw0cBUzpaPNfDihLevB+g+jDrtTZRPMr5dWfnLMh6Hw47nevYTLPyUTLFZmGEtyYJBi1E5oCu
	ij987NgFINqINwETRxDEjgnHHuDd227mpUm0O03tCEXEfQU2dx/EnS9xZyUlt3+CtutsZXazz1ulV
	nZORVAxWbmRgkjZYUBmzYODyvZbQ5fkHSbmdR2C8bAzSs/NxV+YZZUyuMICYg729sZrZT4euaIEsb
	PuoIBBwhMRy9jWMyu7Zn37u01Otx0SGFTR+sNWLDWCHqCFcy2FAQPi/80X7xfX1nrvS+iPWCLZDnk
	h8Q8hPgQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMRVw-00000009aWz-0hmY;
	Thu, 29 Oct 2026 14:54:00 +0000
Date: Thu, 29 Oct 2026 10:53:56 -0400
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <jfvq7vkx73vzp2ukq6nwnb3v3g2ezdcyppba4oa5lpzmz6ls6t@akc46gonndgy>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
 <auKshDXKQXt1kvjy@gondor.apana.org.au>
 <auMbCuecFeRmBFSK@pc636>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auMbCuecFeRmBFSK@pc636>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 643F3180003
X-Stat-Signature: mawpbnc6cj4pnupbx3mpxixuor1nt8ut
X-Rspam-User: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793285643-525660
X-HE-Meta: U2FsdGVkX1+rhVk1tHLZ6tTrtDuKAmAsxX0SDoFDXq6Amamui+H/4s3fce+3axvehPYSlEfl5+o3TXgMNZHYaq/PTlP2ikNsYecWad5iB76kffc67eQAW73IwfdtWugjJZcDYGm8NLDhopbLquQhmKD+YATPIRMmosvBrItLCipgs2ZtxSMK06bF/SWFoJSutxrD+5CYWIVUTFCex1y2Z6DdYugTTmaveSEA2EOUTxOXByHqblJkMHoUhAj+z/z67bU881HftSGqaQv/3VOgj0n+20kzxgl/Oczp+tnaNgmJEiKUasMOjO5ogl/uZI8hBfYxo5kRLst2rzQYhXdzqjECSWrUtjAth6i5Cp5izsjiKhBpUsxYC1am5GK9zijB7odmSRknbiSPsDyTnGpJdDtjpBgSQ7c/1TBRztx2BKCAdjZrFpriaYA+eyr4o1u+byY0sZZtThisshoLBBb277gefUC2SWHiPtBNo7GJXlncdwn+ShihdcfDWP0A2ba1YT+ih+kIxJIUTI/DTSFenG4pqniCoZ2OneViI9WyB7kaLvCBdoeEK11EAhLny9ALxgfE7pfHbjw9xTcj3ARHls7TlUnj7GZv6wwWn3tYvjzhJ7jP4nv/rcZQr3eonghQlxdh3seTOLKatN+Oqu93/fVa1J1FG00Qd7Cuvt77uob44TQMUWYJAFdHxaQHaRhD5anmDxKQ4wMDSUWs5XvYu/uTh19ohp+peD39lmALYAvNB0QbcLhl9IJetBa1c3tTQMupxe2nEGR46Za70mEGi47h7zyZjDpeQ+Pd12OIxj/lw8hbFlT7oXzQPdPxCsqLntztBbBG5kQMjm/Q/YVB9Mq4eA6CkiLBWWpY3ndW/+4cd9LtFL3U2WLkS6lcGuj5/5PtTZEPsW3LElM5azVuJY+exTBTB2VXP/FYCk6a0DKfBU0qw99FdPOY6AdKQ/vLOshNnESJuWrDjw+DFpj
 qXiTj3WO
 eMLaovKGClP9tCJJAk/9j8KXqPOBRZEQWhVc/7Bw0Pi/jDPo1CkT5JlJ9fBrEAwP8Aya2rsOcIGWFpP/5kUwWh7R38DkKqhUPTZ3fLDL+b1f8oAlIqMW80/1nDBrlgLv/QmSXVBN/W0o7SMsn9OvCqeluOIPXPEUucUq4ckL9wpQgC91RdPSIacfeE6/Cr2cgD+e5G0zfQUjP2yiqUIY1Kf8v3IMa8pXojlfGLiC6r0VeTrv9DMC1kFszDB7yrCHhOx4TFdUEej0fl62gqCe35yxv9+R8nzXSsSM3fXszlm/Av8B2LPcgBUuAgcBKFgyPIxi3ey8m8hvLaTo/1KxKo3yGna1tUKu8Duq25x9ggbQg4m4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Sorry for missing the ML in my initial email, I missed it from
get_maintainers.  I should have really clued in with such a small cc
list ;)

On 26/10/29 11:08AM, Uladzislau Rezki wrote:
> On Thu, Oct 29, 2026 at 10:16:36AM +0800, Herbert Xu wrote:
> > On Wed, Oct 28, 2026 at 11:42:18AM -0400, Liam R. Howlett (Google) wrote:
> > >
> > > Below, one CPU adds an FDB entry for an RTM_NEWNEIGH netlink request,
> > > while another CPU is inside vmalloc() or vfree():
> > > 
> > >     RTM_NEWNEIGH                      vmalloc() or vfree()
> > >     ============                      ====================
> > >     spin_lock_bh(&br->hash_lock)
> > >                                       spin_lock(&vn->busy.lock)
> > >     rhashtable_insert_rehash()
> > >       kvmalloc(GFP_ATOMIC)
> > >         vmalloc()
> > >           spin_lock(&vn->busy.lock)
> > >             waits for the other CPU
> > >                                       softirq: a frame for the bridge
> > >                                         spin_lock(&br->hash_lock)
> > >                                           waits for RTM_NEWNEIGH
> > 
> > I think this is a fundamental bug in the kvmalloc non-blocking
> > support patch.  How can it be used at all if it is susceptible
> > to such dead-locks?
> > 
> > And if you can't use it safely why don't we just get rid of the
> > broken kvmalloc non-block path and have it always go to kmalloc
> > like it did before?
> >  
> If we have a look at this as we did not have vmalloc() here:
> 
> 
>      RTM_NEWNEIGH                      foo() or ...
>      ============                      ====================
>      lock_bh(&br->hash_lock)
>                                        foo()
>                                         lock(B)
>      rhashtable_insert_rehash()
>          foo()
>            lock(B)
>              waits for the other CPU
>                                        softirq: a frame for the bridge
>                                          lock(&br->hash_lock)
>                                            waits for RTM_NEWNEIGH
> 
> Same issue?

Looks like it to me.

> 
> I have a question:
> 
> GFP_ATOMIC/GFP_NOWAIT guarantee they do not sleep. Do they guarantee
> not hitting ABBA dead-locks or they are not interrupted?

GFP_ATOMIC and GFP_NOWAIT can be interrupted.  It's more about not
waiting for reclaim (kswapd might still run) and GFP_ATOMIC might dip
into reserves.

The issue is that kvmalloc() now falls back to vmalloc() for
non-blocking flags (I am restating this to make sure I'm not missing
something here, please correct me).

So this changes what is called internal to rhastable so it doesn't reach
vmalloc(), like before, if the caller cannot block - they go to
kmalloc() with the old fall back.

I *think* the question is if the change should be here in the caller,
internal to mm, or a new call to opt-in.

Considering this is the only kvmalloc() caller that forwards
non-blocking gfp from BH lock + softirq context, I think that it makes
sense to do it in the caller.

Given where we are in the release, this fixes a real issue that can
happen so maybe we take this now and settle the general handling later?

Thanks,
Liam

