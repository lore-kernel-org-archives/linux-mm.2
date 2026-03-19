Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B73CE1090237
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9146B04FE; Thu, 19 Mar 2026 11:15:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0266B0500; Thu, 19 Mar 2026 11:15:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C66C6B0501; Thu, 19 Mar 2026 11:15:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09F946B04FE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:15:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D3CD1DD32
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:15:38 +0000 (UTC)
X-FDA: 84563161956.04.6DE7A48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9F9561C001A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:15:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a7+R6c3T;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773933336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=33bThit0WPqoyyEUNBKRyXPbdcEy/94tY/t6VmI8KZQ=;
	b=Wccc0z9eSPW8aUTnHhCQdGXfFCxieFdpOTQ5gYNlMQ/o+14EU/AYh2Cl1nF6rx2ny2F8wZ
	ftKeCFx3eTAiDATIs2//qhJhe52qJzck7xdoCHD3lfEWwLP0ijCt8Y3IFIh0xlJpsCm0Cd
	BG8BzSghpD4J9PX964BfuTKgjwEO19M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773933336; a=rsa-sha256;
	cv=none;
	b=CHhodcZvm1NykKD9UXbhe/KvShXCcEm6nnohVCRb6sogIGNZxRMWEeJkANGEu4NfSYNOsb
	9JBe4J4zVCMBJNarBlNc1bcKplSG2+yCjRH8ijACIRoDd/Z8B0PcUriLHmC8fz4/a9Q5KZ
	ggp2DCZ68+2aakDFLj+lzwCrbR3dAgY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a7+R6c3T;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 80EFC4241E;
	Thu, 19 Mar 2026 15:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C11DC19425;
	Thu, 19 Mar 2026 15:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773933335;
	bh=myApSUFfBWDq6Jiq2hPNW90QakIWQOgZc24gvNSByvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a7+R6c3TvD4reuMqaSWbBaN71cbGEHp5t4wjlNIpedgQAAywdK8HymV19kd+OPMAJ
	 jKqxpny15NG2CYZN/udcjNez4C3yl7sAxJCwvkM77z5t2Hdwk36Frb2hGHlIg20kk7
	 YI8GJmsSoUZdtgcdp2xkD1r6CScNNUeH5cfvBusNXG5jjBrGnbuAzKDRsR7fpZLAnR
	 5T/nO/sP2XfN9YJ/ja5OP7pavRVCq7IwpuGjH8Zo2krSK+D0Wr420HxaFgeW/s48Sd
	 QR2+Le0IERhiR8azGDO8RVubNPmX2E2Swp7XyRVZrUf4VsO+s0GpbC8BdoaY1KiUcb
	 caeybmlYyauWw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [Question] mm/damon: min_nr_regions constraint and inconsistent error handling
Date: Thu, 19 Mar 2026 08:15:27 -0700
Message-ID: <20260319151528.86490-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260319083639.36440-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: y561g9bf88pco3cy96qhiqcpds8g8bjw
X-Rspamd-Queue-Id: 9F9561C001A
X-Rspamd-Server: rspam03
X-HE-Tag: 1773933336-248711
X-HE-Meta: U2FsdGVkX1+fPaEr1tOxGiKXNlEKWa2VO4aS5Kq0T/oVwUjCvOA2EihouiKGj8Jhx64Y2t//Jf2G20+6E4OPIN4ny68KmeGTy2taw7oOf3s+2zW4PTWR6sERipITisO0mz61C/coCh4j+WcOcrgn2V11s88t9cI9t0HOKTCY+ISy039Je/BCcAdAnRw5Waf8PUuGV34XfBiWWIhnu/dAo37p8TADavfM7ODBc/nwh6dSXe5Mf0k/gcHWNCpNLCY5s/xQmvX3x2uZ40Bw/Tcp2d4/2ioNScq0pNKS49TcGnLMN4Kp6EtG0zWqwJ8wOJGeE6gmw+Lj3IruLyP+acmrNRmjLD1myHbAu4YDO/Pah7/1TWbNy2XAExSRsnaamniVJvfUpAdewBAR/EQH3lGolmnQ38sd1ypR9l6RYWsAajRS+gyc1y9/0ITq40Yk5sojk6+seVN92/Qpp9Ih+a1/RPRapzOpIWZZjAJmeGiaYu/5FXASN4paLlOIweVXTWe7FqvwBZ0wBIHsfpkxfUCkmWIizaW2wXFmsBPy9STrjJawwUYEPoPK6oJWBqLQVR/w3kJeN0SLR2XdyfTbmhgnHfmInpFnuIL4KlDGyogG8/0h5F5+lm2/nAxQ1gf7lGAxVXWyHe6KsgZChya0/vwYqI9ZLGhTUp11/dDtzJCwnT9SbMMapf42Fl85Rc09OQE2yiamgN0bbOePvc2Sq+IbJ1FX0pBao2sdQStCF2EDS7TXskIxfBuIc4OCFo9gAWhV/4ooMz1vE0j2WiLQv0Cl6bsU7PNOkfQ1hF3t3JGBX/rcx3V22Y5sZakTzhqP6+L2KsAPGkXWKhvWvLCPQ3mAtjvMYuHmjRDtPbodNqmYLGIGNrFtwhMwTvBDJGVGmwn7Egdjb4j808XK4rTKubDmXf03HmXkOrLnWF37SNpDje1paPptvFdO0/xJfSg/Qm/WUSxXi2nIKUisTHT0ivz
 4mbKcBmK
 aIalQIZp/Kem13BUEvlH0SFpVDIlGZWJMlshkRs7NAlJ22DFRMHSD2g3JPpUHjiIcMteFYpoTzNsNHYZnIrV5rlz8xzlPvS+Jq7rqU+DVl7gbr3JwHdGxHrQIspjhtFKO0qhNr15GvDWKxhvrZAHLgOWJnMgkm4vZeV7ziO0spK/lFVLRYEaSqb59gAR6xVpyuCn8HME2++Pjtil9JRb6Izsoju/Bbree+1CbY8UhQ6G5xGljq6LLDLcbcrcIl1zW6AVxDDLHLj0XmvbbfFRZKPNLOU+8RjL74pdlAZVqfmn3UNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 16:36:39 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Thu, Mar 19, 2026 at 9:46 AM SeongJae Park <sj@kernel.org> wrote:
> 
> > Hi Liew,
> 
> Hi SeongJae,
> 
> > The initial version of DAMON was supporting only 'vaddr' operation set.  And
> > 'vaddr' is designed to have at least three regions, for the two large unmapped
> > areas on normal virtual address spaces.  Hence we enforced min_nr_regions to be
> > three or larger.
> 
> Thanks for your explanation! It makes perfect sense.
> 
> > Yes, I think this is a nice idea.  Maybe adding a comment on damon_set_attrs(),
> > or additional sentences to 'Monitoring' section of design.rst [2] would be
> > appropriate.
> 
> Agreed. I will try to figure out which method is better,

Doing both may also make sense.

> and I might
> send out a patch in the near future.

Looking forward!

> 
> > I'd like to be cautious about adding logging, as it might be a spam.  I'd
> > prefer making it documented well.  Then, users could find what is wrong.
> 
> I see. I understand your concern about log spam, I will focus on
> documentation.
> 
> > I believe the above command should returned an error.  If not, please let me
> > know.
> 
> I re-tested it on v7.0-rc4 and it did NOT return any error when writing
> 'Y' to 'commit_inputs' with an invalid 'min_nr_regions=1'.
> 
> This might be unintended. Here is the full log of my session:
> 
>     [root@virtme-ng x86_64]# cd /sys/module/damon_lru_sort/parameters/
>     [root@virtme-ng parameters]# cat enabled 
>     N
>     [root@virtme-ng parameters]# echo 65535 > max_nr_regions
>     [root@virtme-ng parameters]# echo 3 > min_nr_regions 
>     [root@virtme-ng parameters]# echo Y > enabled 
>     [root@virtme-ng parameters]# cat kdamond_pid 
>     89
>     [root@virtme-ng parameters]# echo 1 > min_nr_regions 
>     [root@virtme-ng parameters]# echo Y > commit_inputs 
>     [root@virtme-ng parameters]# cat kdamond_pid 
>     89
>     [root@virtme-ng parameters]# cat enabled 
>     Y
>     [root@virtme-ng parameters]# ps aux | rg "kdamond" | rg -v "rg"
>     root        89  0.0  0.0      0     0 ?        I    10:15   0:00 [kdamond.0]

Thank you for sharing this test results.  I also confirmed you are right.  My
above assumption (error on commit_inputs writing) is simply wrong.  In the case
of wrong argument writing, it just silently fails because the commit_inputs
handling is done in background.  So, not a bug.  But maybe something better to
be improved.  I think it is better to return an explicit error and/or document
the behavior in near future.

> 
> > Also, if you know users who depend on the old behavior and therefore hoping the
> > old behavior back, please let me know.
> 
> I don't know of anyone who depends on the old behavior.
> I am a student exploring the kernel (DAMON) as a hobby, so my
> perspective is limited to individual research rather than large-scale
> production environments.

Thank you for sharing the context.  People from different background gives us
very different and important perspectives.  I appreciate all such voices.  And
knowing the context of from where it was made is very helpful at discussing
suggested changes.  Thank you again.

> However, the current behavior (staying alive
> with valid params) feels much more sensible to me. But it should return
> an error when 'commit_inputs=Y'.

I agree.  Maybe something that we can improve.

> 
> ---
> 
> Plan
> ====
> Based on our discussion, my current plan is to:
> 1. Document the 'min_nr_regions' constraint in admin-guide.
> 2. Add the design rationale for the "at least 3 regions" rule in
>    design.rst.
> 3. Remove the outdated sentences claiming DAMON will disable itself on
>    invalid parameters input.

I found an issue in the current behavior, and just posted a fix.  Assuming the
fix is merged, the behavior will again be changed.  So, please do this only
after the fix is merged or completely abandoned.

If the fix is merged, the changed behavior will be something like,

"It will continue running with old valid parameters if the parameters are
wrong.  It will stop running if the parameters update was unable to be
completed due to internal error."

> 4. Investigate and try to fix the missing error return for
>    'commit_inputs'.
> 
> Does this plan cover everything you'd expect?

Yes, this sounds like a very nice plan.  I'm looking forward to your next mail!
:)


Thanks,
SJ

[...]

