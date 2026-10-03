Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4814CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 09:18:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8010B6B008A; Sat,  3 Oct 2026 05:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B2A06B008C; Sat,  3 Oct 2026 05:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8A46B0092; Sat,  3 Oct 2026 05:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 464CB6B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 05:18:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F427C0956
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 09:18:43 +0000 (UTC)
X-FDA: 85280764926.09.4A2919F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 13B891C0002
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 09:18:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RVdZvFd7;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791019122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UG7OBe1pIKeQYfgpbxk8n7/tnFRBnoNzl8SocuNRbg=;
	b=Ce6zMW8+mbmMoQNjVvocXsp4+tudO7t4t4P2xSpoUujDPlxmlAHl6kMgTjCLZHN2gDYEtA
	qWRWbI4R2+4/Lqwd1bhbu/4g5p+jP+CosKWSigu+sJQrxx4di161ct2HWNOYx+FUNnvEpa
	K/TJrFM73uJNcQxgEyMCaO1hRdqqXGM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RVdZvFd7;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791019122;
	b=5jTnmAWQnHkCsdEkWTalRhY5O5Aav2bnZ6RwRnZA+W2fuQ7Y+3Ge+1OhyAFAN6FMju7fRZ
	T8aFB+M3abbAG1cnwgkBfE+92QEcUKvvI8PtcYmnvYTR+MuIVFpoBOwIZ+OFCq48o7JVc6
	by3M7252KcxxTb1X7d+b7FA1/t+hviQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3431242DA4;
	Sat,  3 Oct 2026 09:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8C81F0089B;
	Sat,  3 Oct 2026 09:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791019121;
	bh=6UG7OBe1pIKeQYfgpbxk8n7/tnFRBnoNzl8SocuNRbg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RVdZvFd7/PpZR32+eZg7X1QRZ7g/q6oTQ6OEknlAyPszGrI+fv6bFpSXAyKc2n4zO
	 8n9dU5jrjDG9xlXBZuisTlYA/57Bbcu5eQoFDFyO84sITO/5CnXX6WWdnkBEMZx74e
	 IPRAGMZQ92UbIT3O+wG+rhkYCWoziPX2apKLB+P5U7QySKxwSQEcHkhUlLzvczlE+K
	 Mhf+JUQdE+YYzI9grPKcdqxagMueig5tF5FxMnRN5hD9J9bNu+kbuVchQ2qFpvmZtz
	 1bkwmpwcbXXW2P5N2ghxQg5qv3iFPV+bRYp8oq8CNgm2PNxz5+6mp64P0ehGIFm3hn
	 0SXBRAqR82yCA==
Date: Sat, 3 Oct 2026 10:18:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: rppt@kernel.org, peterz@infradead.org, akpm@linux-foundation.org, 
	david@kernel.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, stable@vger.kernel.org, 4ncienth@gmail.com, 
	alexander.motin@truenas.com, caleb.stjohn@truenas.com, ameer.hamza@truenas.com
Subject: Re: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while
 perf record runs
Message-ID: <asDF77csaLDIuHTB@gremlin>
References: <20261002175651.811343-1-ameer.hamza@truenas.com>
 <2026-10-02-rc-reply-0003-re-secretmem-sigbus-perf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026-10-02-rc-reply-0003-re-secretmem-sigbus-perf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 13B891C0002
X-Stat-Signature: mj89xa95dje7zyjszi8z78hi78p7gjjz
X-HE-Tag: 1791019121-734115
X-HE-Meta: U2FsdGVkX1+S7CUSpUg0bkMU3kWKyfADNVa+oKuD0Pi9RzE334Urae1lhUJlxAIerNSCZiKJJ4T38eoENbsQb/U6oN90IgUKewaWsu9WOoucYUdcPTvhLx9WAvi4PBBpC7UU2VR+wNUn3NwhywvAeBSxqAvL6ACc92RBFmKHjDng0qj/BcSA3fQxyqppEOUncvimshkKtDZAuC22PaDqc1ATSk7R8uSXlxBiv9MLcMK1MPmFDybjbrBJuxoTU/qkTnul5r/9G/HyS07icDZg4Imdxg6JB7ikFSzFyPquR9//qpLN19WAvfhgIvib7l2EpwOlOldGof95Q5L19C+WupLItSwDW3F33Faxs0rUjPDFoggIS50ZMOQZWcb0IJjF3qCFJnGn+WpldwUrNNMw53N6QREc2wQKgjiA1yrKicvq7Bg+ZmqLXlefjyqO0MojaIJar42TUXvn8OnUlqwY8R7jUH3rqAPImEoJ/uQ1p02z/q8VAusr4he0IvWTDVVLr/JOcQYTliRDuHZxZPgeiGReeleZQhkCMdHxw1fUNT8bqWZ/tmDNHlyb75WK5HBsOkw3ZQzISXC6mIFhOO7In2f3HZneIPyx43f2qDHS5nEk84tcZn/Etg8TyvW3Tovji8FV/gqQjMii/BgV8rmTVxzmGdYC/wsL1W46Nv4EjxqMfpVOrKFb9H5wIyEb1NlCSHISvOBR3mJ1VpX6gUFp3+8EtwM0A34F/egXsZsGEDZr3CyYogPLLJJs0GKbusG+ZHOB/kJExf4bjRjEIZ3gMVSuFhy14H0g2evfr2n0afhMi6Otfd4f2LTONeWcnBSDk9evdvMjVyOAHicwXw/nt7ewiygWQWUeN8S7BhllseZve/FR6gW+TjQs6EWbsgmsLBweoXbrNqO4sx1MH2K02qZfjoi1qyL+cDonlFgDT0Fu0uupP8Fp7z5LldCbn4TMBCVo4h1u6q3TfBjFgtP
 7z32splL
 +vAF83WC+cajEEsR0Z/jq9GAER0UY2a4gDVWf86cEJlxIINJpi/TIoSXVPQcAa5HPQdJz1A+fGHazmT+nhZ5Mh8EtND+QB/DDmRWjxJiY+Zbj/cL5c/T9M38Zz9b1FCT5NOTqLz2Ip7em4rKDmffcQGt4vhaM8Ho2bHxjRyLXas6AD2Rt59VTj5ae5zhSSBdLti3BLezr+Z2/HdrH2EBal+2P0z6P9cWmAdhs/eNvASB/d8H8BAKKNFN5haKTHhb2BS/h8S02wkNqI7Z5NgCbhWLN7enGqljNzflKJ2WANGVSi3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 09:30:23PM -0400, Sasha Levin wrote:
> > Since commit 97d34aa65c29 ("mm/secretmem: properly account locked
> > pages"), in v7.3-rc2 and the 6.18.52 and 7.2.5 backports, touching a
> > memfd_secret() page for the first time fails with SIGBUS while the
> > same user is running perf record, and read() into such a page fails
>
> Thanks for the report. I've dropped 97d34aa65c29 from the 6.12 queue,
> and also removed the copies that were staged for 6.6 and 6.1.
>
> 7.2.y and 6.18.y already shipped it, so those need an upstream fix,
> which stable will pick up once it lands.

Sasha,

Could we perhaps take a breath and pause?

This patch fixes a really quite serious vulnerability that allows an
unprivileged process to allocate arbitrary, unreclaimable (i.e. OOMK cannot
save you) memory.

Allow me to assess the validity of this report _before_ dropping things
from queues perhaps? :)

It was sent late on Friday in a week that I was ill and it's Saturday
pre-LPC, so that's hardly a timeframe that I could reasonably have replied.

Thanks!

--
Cheers, Lorenzo

