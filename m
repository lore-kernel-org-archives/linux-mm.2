Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4273CD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 00:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B206B0005; Fri, 12 Jun 2026 20:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32296B008A; Fri, 12 Jun 2026 20:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E546B008C; Fri, 12 Jun 2026 20:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3A6A6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 20:39:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2A90E1C312C
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:39:14 +0000 (UTC)
X-FDA: 84873030228.07.36E4183
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 95D544000B
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 00:39:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RaB3KHbD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781311152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TEI/oYL96D6QPPjj82L55jjg/d8h3AkIL0OSLpC5t+Y=;
	b=MwnnHbz0rhk65eDtbgXwpcJj4A+BoGoKr87NhB9imEJ4zaUxVxwxZNxiVjG6xoBaiy09uu
	ur1IucVPANDWl9naDdl4J0J9rD3LVTe6MP+3D5y/c18qU3TccGN52Mr4hm9BT05pkG/Ydz
	eqnBZP+BUisqCbqh7MmVT/Jyi9Hdo+E=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RaB3KHbD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781311152;
	b=HgZ4xGpALCxTbZyd/rXAHfRLGvHEOuQotLH/5oEbytsCFLfmVItaLS0tx6B2sSWlamUbXH
	uTD9v95NcmJgMqxSAo02pm5sQ+HJhN3qAcvR42q7V6B+rjjIwsAFs2orz24m5H4BQlq+7g
	SSKXbFWuTfYAcBWxd5WQuDmb9836unk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 27CF060008;
	Sat, 13 Jun 2026 00:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BDDD1F000E9;
	Sat, 13 Jun 2026 00:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781311151;
	bh=TEI/oYL96D6QPPjj82L55jjg/d8h3AkIL0OSLpC5t+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RaB3KHbDYrCrCpghgRrcfM7xtPFx2sUsgqe6B4GoO9Avmo+oVZwHtErMBqQo/xzlT
	 fXlAFyT7ds9gvCZd3bt/CtHxpMO/pPmRxD5Bxfn76NSFLlYNqSm1hDhilDWa21fTG5
	 ydnr/01AKEnZSclCf+X98zMvV4QYODluKYjvmDJsj1nvvST/YfZJSHP/D1rdH2h+hh
	 kNqLm5IVSfExkZpxpo9l7iY7CmCxejdfol/VwdRrm+GPTqYv2TtTqAd1v1qup8A1QY
	 8VESK4htyjib9pYl30SpCwNQVgCsNRQ1REp1lOpLYAogCvm5J8LvnNSMYvsjYY+CUH
	 hVmTmZCbIl4aQ==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/4] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Fri, 12 Jun 2026 17:39:04 -0700
Message-ID: <20260613003904.1932-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <abc8acca-5145-4c16-aeb7-4127da234a62@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 95D544000B
X-Rspam-User: 
X-Stat-Signature: 6x9ftptb1fjiofr8gc4pkcbf8z8xwdei
X-Rspamd-Server: rspam09
X-HE-Tag: 1781311152-91420
X-HE-Meta: U2FsdGVkX1/COyJlvlNTQCI7xmoq3UpkdotgaJ0CxvGGtrFLSqfQgb+hNikuJVcx9bpW2n5izIfnIBIXoe+mt1TIWOjXv6jZ5dk2b0BG4vzIxbu2gkmr4RLS5DraKx5IaKrLAh41PgBkf/1TGrvW9cQOldF+vFBoCHQRzgoxbH0l8Fp0LJRmhi86E9NxSt43Rvkp/gIHcy+FcLYsJiWROEowV6PJn1hR7OFs5jO8SzqMUH5Ltzz3MMP8YBCb+NvpZZSfpadjYbBTN4wdlfxd4sEtSc+HKkHJ+zRDU1kpadxyAa8LxmOP+QK7e3EaX+wn6CJZ6769ClzCtKPyPwhE9sQBUwJ0m2l33PzGFBrQkpMZThpcnIvGqCmaZf8KGDv0sA3paqqdgznuWEXAzzO5dsM5Cn4o+yaS6Vv5TRI2hiyDYYC92JvAxle8N7HGFp0I1L5xZ4MamchKRAslMhPFz0lUwRO02Zq9f7jIT1Siri9N+MofDHP9U5PinLI0idNVM+GGkl09bgbeL2nUJj/tEaVlfsXAIpxyt+kMgG2HOBWIzTF5tWS29kdgtPVvT0Q6PPV0uR68xUMfHNWgGaVu/fSu0HWaYtQH9oOErjihDKz6Iyh5sTFjTvyPy4g14lEyBOM6zZ7KDkbZbVQqP6VEI6ywGRuWcQHGEyYCr305B50yEBS8L0+dLpk6iXymv/snRdxSAr6ByeToUmNdl/8IZuz85KfSWGPXZmOJb2l/g8exVcWSYfQCVjVShGWVWRjxAaBN1PK6CnG+udIg31uBSHVEDBq+MSOa4uhJ2VrkhUa+UbRnzmS/CKzLlSsx55Z1dEFsibQhB0S+rIlnd+ZLkPu30QqzK7A6eSZeQ5xA86Gwx0C2PNKhshJaasB9cQNGiDXppayXyEWpJ3q32mWe6PuT79S8MDU0Aq8OUixnn3FCfOCtVvXN0vu0DRpsXn332GaA/Zuq3kbv2o/0l/x
 lSCxXYot
 VTb6isSN/jB35/ai6HfGy3/8Zdh8UoIiiKGQE1j1I/PxKrYMNlB3rvDKAbt44QwlopPCRn22+Tc58OTkJdOz80LHqeL0Ca4w+yAtYPNRzmpQywde1lZiLsCE2UiI1zypkXyEw98c/mwyRFN+0PZna3tc0GPVqTFzfbHxwu6aPEfPPMEA0VdwDQDdjgt/2O85eB4nwzCAjUhGluGl0GtFRAou63ScT7eaCnQeCqgH23MFQDpIRWUB+MfRcbzL8igyW+1BNg2vhBAZuvTH+HBf/K4XOqHVYUhBN7gLOpkoxQ4HNv2+dLpIXvvBn4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 22:36:11 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 6/12/2026 3:56 AM, SeongJae Park wrote:
> > Hello Asier,
> > 
> > On Thu, 11 Jun 2026 15:02:40 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>
> >> Overview
> >> ========
> >>
> >> This patch set introduces a new autotuning which allows to collapse
> >> hot regions into hugepages.
[...]
> > Also, I'm not sure if I asked this same question before, but ...  Could you
> > please share your future plans for this specific series?  What change you want
> > to further make before dropping RFC?
> I will review once again all your comments.
> 
> Since we are aligned, I plan to drop the RFC tag for the next revision.

Sounds good.

> 
> In the future, once this patch set lands in upstream, I plan to submit a new
> patch set to add cold page split in the sample module, so that we can have a
> full THP support.

Cool, looking forward to that!

> 
> Thanks a lot for your patience!

I'm glad to help!


Thanks,
SJ

[...]

