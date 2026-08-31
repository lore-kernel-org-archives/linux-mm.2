Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B90B1C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 17:38:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965FE6B008C; Mon, 31 Aug 2026 13:38:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9173B6B0092; Mon, 31 Aug 2026 13:38:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF7A6B0095; Mon, 31 Aug 2026 13:38:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59E0B6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:38:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C68DDA395B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:38:56 +0000 (UTC)
X-FDA: 85162275072.13.9D4BDF1
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by imf18.hostedemail.com (Postfix) with ESMTP id D54A91C0003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:38:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=acRKMFNs;
	spf=pass (imf18.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788197935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDRmFKQ3KwKa7CTJ+rHynqNI4b3G5V8gGpop+oMVOJQ=;
	b=JHfSAQg+ETHb9MzbnkH7yAS59jbAEJCG1OboRl5sAgPzpfpLfML+5kcVE6v6oiK36qEIoY
	bOz0GYYYo1V+0O16eHsB1CwooFwVPSEVcd9ochIh13V8qTHrMpM/NXASelrT0CIXZKy5ml
	wPVUP6lpZXkrgtuyHEAL2p2QXW01S1M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788197935;
	b=m7XZBMKxjA6QlyQgxhpAH3tJd5r3wMnpg2KLWdtpMVo+v7TrUAq1XlnjB1IcWbt2wgCfd0
	0AkEEvqtW9rfozKa9rs5q7PyAQ8qHl5gZ2TbS8S8rbBv0jBOno+Gd2pnDd8/XRJpCMgt62
	FoRlPa4Q5+Mg8B2zB54ST4vQntnR8Pw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=acRKMFNs;
	spf=pass (imf18.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp4-g21.free.fr (Postfix) with ESMTPS id 56D3219F54D;
	Mon, 31 Aug 2026 19:38:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hDRmFKQ3KwKa7CTJ+rHynqNI4b3G5V8gGpop+oMVOJQ=; b=acRKMFNsGBMMmsd3ottK8QINuz
	cxuo3f4grvDL+afeeOwnnB2yyWOyEZ591wOajJXLH8ya0eSlXwVoz03KAg+iOintFkDplC+Tsg3/g
	eGdZPI7epWrOyMplvqEKT/QlrFz4QtIpB3zMHkLGsq9knG6dkHqaad6yROgrlJpi1Ob8=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1x15y5-00000000TQ2-2V0w;
	Mon, 31 Aug 2026 19:38:49 +0200
Date: Mon, 31 Aug 2026 19:38:49 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Guillaume Morin <guillaume@morinfr.org>, linux-mm@kvack.org,
	leitao@debian.org
Subject: Re: [PATCH v2] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <apW8KS4D6k8621Ca@bender.morinfr.org>
References: <apGbO2QM35VZ8d7a@bender.morinfr.org>
 <apVC2D11bMz-QHic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apVC2D11bMz-QHic@kernel.org>
X-Stat-Signature: 5j94ptgyiyyq59bh7m51ox89eu9r4g48
X-Rspamd-Queue-Id: D54A91C0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788197934-726704
X-HE-Meta: U2FsdGVkX19ztcVQR/miK7ft94Bv9tvJNhd/7U2KF/quVbSlRw4u3Yv1+FABpGDvIZxogLuXYVeqj+dMI+aOD7FBq1o07XIo3HX1/EtqcgbVOApkNsnf2/ZItL28qvc4CXQ8OuQIufQk7zUcuAssFF8vcdCwQ3+fUbyuzHznkWDJfdmSQtOw4cFoD2KYuLp1sWkCYJUStYIHVcEOq4vgQ30UFU/7/pG9wUS7L55TsAvzmf2h4s3SQqxM3x8JM+3h2WD2+CBuGtcYHmSBhtpXBMeFQdKftV2UNyUZrYOW7rBa9zBADobJmYZnIMKSegnFSIZN5e/J8Xc7+BWAKfQezp6k/copUrFMBF10YamFqUR4do+3uJ7Did19ENrg7MiOZIYOXxw/Rz6CE7HKmVxRuBLM3DYwLciEMwXnshIubUPPrkkWX+gV0L16oqgr8TOO5jMwQWdbGsXH3ybbPzcPS6PQWmSI9G4bEpYDw+F4s7zBSbo0O+YL+QYjhDtNJbJjPNxVEVB8auZhWhGll7PjruJoXeCWx2uH6yKpTgVk+jdPgW4mhA7eZ8xwvqBXZAR1Oo9nLODHbsiEFfQBOT6pBuEmXPX5r1rx+OXkhRX2jKp0zan1LWFEoxQ3jdK4dGyDGsNlDCtzs34jyU/TxZNw4dFRtU6HNf+y94Oqv7zJCE3ibv+Kb5FEAgI9VxpHxq4AUD7unKQD7YqdAlmlz+eilORUDS8O0bnbRxiyXsFV6Y/FhVE2bU5ec7OgyjitDKb6uPcXsHE+b0O13Z9+aD2YJx1tEOhltGgEe2Cjwqt7GGP0SAc8MQ2iFkIfKtBolysynSUNjdJZFcIE4qIAeVe6PvdHCwiYw+Zz6qn6emDGXMmQmTCYNj2494vt1U6lzlH62Ta5JykMYkBrReyYnHSdzNheAHbtLif2RClgpjvaxu7V/THI1cXOZTD8UXYvQ+z0L1QqUzjO5LknehsVFGs
 V0eIeSDB
 ojgTVc0oVYUySsHGaRMXsiUm4tDzOHvUPbmSyjCQpBBZ3QmH5v6+piqBhFjKxLUWyyfWvtCOTerUXAqS6xE9JF/xLjzLwzAWMlHPcv0Fmu5NvUgVEF8M7a/JBdpPuC9AfYuQkh2/pi0XFLqV+i88f88ctWRaPQuaH53vCxSpSgmUswoMkFRfgOwadRlUEnW8Uc+Quu7P7XaHg+BnLOOsqQmsouxFY5SIvGmehdj2nZbnYmIjn7qwXkq+0YTrnBykHNdJ8os/jVKwAxkeKzca7szGLq9DW1YA+OMprfwMJWXlvsLUX+f8zFLdDO3Yru3AykZRzsX0Lei1q0QhJYQIyzM9AcTg5QGAgSUCfvKk/BG6lHsY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31 Aug 12:01, Mike Rapoport wrote:
> > +		return;
> > +	}
> > +
> > +	/* Parent */
> > +	close(pipe_fds[0]);
> > +
> > +	/* First unmap, this will close the vma */
> > +	if (munmap(huge_ptr, mmap_size) != 0) {
> > +		kill(pid, SIGKILL);
> > +		ksft_exit_fail_msg("munmap failed");
> 
> Won't this leave the child as a zombie?

It will, for a brief amount of time then re-parented to init which will
wait(). Happy to add a waitpid() here but I was concerned it added more
complexity for not much benefit (it's very very unlikely munmap will
fail). Let me know.

> > +	}
> > +	close(pipe_fds[1]);
> > +	if (waitpid(pid, NULL, 0) <= 0)
> > +		ksft_exit_fail_msg("write failed");
> > +
> > +	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
> > +	if (nr_reserved == 0) {
> > +		ksft_test_result_pass("After the child dies, HugePages_Rsvd is properly set to 0\n");
> 
> This makes this count the test as two, right? 

Yes, it checks both that there is no underflow but that the count is
restorred as well. is that a problem? 

> And do you need to re-check what happens after the child exits if you
> already detected the underflow?

Need is a strong word. It can be done either way really.

> 
> > +	} else {
> > +		ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after the child termination munmap, should be 0 or -1.  Repeat the test\n",
> > +				   nr_reserved);
> > +	}
> > +}
> > +
> > +int main(void)
> > +{
> > +	ksft_print_header();
> > +	ksft_set_plan(3);
> 
> The comment at the header implies we've added the second test, so they plan
> should be bumped to 2.

So you're saying that every test function should only fail or pass once?


-- 
Guillaume Morin <guillaume@morinfr.org>

