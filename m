Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B4CFD45FE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 757D86B0088; Wed, 25 Feb 2026 19:59:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705856B0089; Wed, 25 Feb 2026 19:59:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608056B008A; Wed, 25 Feb 2026 19:59:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4EE1A6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:59:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E72691A0407
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:59:20 +0000 (UTC)
X-FDA: 84484799280.25.C0A549E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 520514000D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:59:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aMNubDGH;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772067559; a=rsa-sha256;
	cv=none;
	b=ukKomTun9JhF9o1DcHv3ilpw7xGDFSS6nCx6aaMlZ9F8qa7CcMbfF782xhe5eDbya+FyEi
	l6gitC8cYl0xYtFTXYzeLo0fO3jFg//katjalJykz2fB54o0l5q4Wy/RVvG0glH+nGYA7P
	tleyJnK8DA8xXtNBF8mZyGPer2biK6Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aMNubDGH;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772067559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=muxVEeMUUlwi4/9ghE60UDQpzNyZTTnDnOz+ilbq0DM=;
	b=itNtfqf55T3yPOAOaiZgfeWhq1CLu9xCOoKSxbtqT3dKN+2AlsfnbJfY5DY/mwGnXs89+h
	M3otGap3r6VFTn8mfjK3KfuJeocglJO3jEED+cMyk+tUMJXow15HMxecLjC81C5eDR+Elf
	hxEIJbX//17YX99m0GAlVyC4d8X6Isg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C417160054;
	Thu, 26 Feb 2026 00:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0BBC116D0;
	Thu, 26 Feb 2026 00:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772067558;
	bh=WgtMgVEJKBbw5rku/Ulb3PMFelZylX2qCcQghD/WKGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMNubDGHFO4gX9UZIZ0xL+udtZ8ylyA4aHsLnZPtS0UrNwyrlD1SemckyK6PmBSHi
	 vLI+hW533UdcQOdT2JUqkht2gmkGCP/Kvra+ZCn71s/jjGRKIGIKcfrnq8wnT1dcPf
	 E28L5kPqiXXB7spXLQNP/fQcufvcN8Ha+p33TAwetW+L5OcRjTpOlb2txC58tLrdJU
	 L5EADGe/7D6JStAQWd2u0fvJAgbcNgttvev5/8eKgKG7MoQoRbaY/QwYKZ3grCI3am
	 1QCpgTzsMRet9RN7sOldX3esvjswLpW+84aVTIDJDwynyJxvFt7U4lOmCwAukvd/I2
	 43I4Ix7qqd8vQ==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v4 4/4] mm/damon: add PA-mode cache for eligible memory detection lag
Date: Wed, 25 Feb 2026 16:59:15 -0800
Message-ID: <20260226005916.7950-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y14yVxW+NSP6-G+93yHFLKhFhvKMQowGUR1MBcPgvO_q-A@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 520514000D
X-Stat-Signature: 75bxgcku8hw7t3kaixygkj68mm16szqo
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772067559-916705
X-HE-Meta: U2FsdGVkX1/ZSeznCmhzQyv79EXUAxJA+q9L6JmW/aZFc1xj+NyD7gg8C61iwSKgYLWqdyMInB8+KgD3qT9N5UUjY0xCcOYrbpLYtz+1nBMkS9uZPtWTSd1xSZ1LgvcCE+pxabNUOFU+xX6Oyd4DjTjN6Oy+mRXDKnMfs8RLvLufc4Ui2/u+H1GjcuRbPDa0aG3fKFkHM/DH4aqLW/zHD8V7LpzA8qb84ZloTFpWzFt82j00auYrhj8QDtFfVkTv3eXVy3PyaXao/HZf8q4fbI6UhvMwoVwUdNR7aXILty29ZSjfClM+m1fhxV62onXxEPj/kGwA5wGiy2opy6xkoUy3rdIUOc14uzR+dch176pK3OXwAb37ekJcS5o1vSrZqYnkXq3zjGvrxf1FZpxuXPUlXLR195tscFlhq/aVGubJPFWJee75ootLpIT5zdk9Cydd0n9DwqGelruYQ1ikLwth1Zz1dCHHIhKY+66xmjV/FmzZJoooo6zkC+8AFXpnZI8fxT40V8fpJgZ5bVe9KfULQ1YNykeyXfeBSUghBKKWevGAHxAvap4Yk8ncE1t5ufCGbBi4k9WSIvm4zuNeHGxo/TX/cRrcMDNeAFOlykGkNYVleK2I4xuKDwyga4YWRfmGYHcPfOsh9G76VbHo+C8Txlmn1bHBJ2xJoPICMqp4EcnfwDQ4fJxNZNFXqpdofP3YrniN7vzFHb5VZM7fVp88Py3s+Csaav4cEGTeuKAuQm0Gw/kvyKRAY5lBCEMS0X40qZp0MWTJQJm75C+ZBi9yuDxt9CR/HuQaIKGRiQK3yoiJUAsJWgAJqYFD26ZukISSBOEbSWcCGBTkyQ8Y5LlyPDcOPa63Su0SEagaOn9zCM6OMXN2gUn8VEUqr+JvrQ5LTmfCj5Hdfi309/zD1F9b4ag4KQ3MRislksn1YJfQ3VTmB7Abbiy998+obYu2fSSKYcQ5odrekoELUN6
 2h4N1OQA
 6P+0e/DoS73qcKZ6EvHnSrTMrNbSlAWWKcn7k1BgejATKqR7aVaw82aDqEAkb88rcFuNn0iRQIHeydnr9sb3XGH0I+w2Mrv9kd14Ipy3ZlWbd+bLYZfngju2rB+w9AcJ54uVtiY+ra/6w/4gE31t0P5TPHvWcre9je8C15NFQIBbE4A6fwlWc9LexFRCQSTTEmjBuN5ICHkIl5W+H3qHVSRucCAtgdOqad2/i3ZsygSS3YIlQNYQdUsf8WZHoq+LOH7fvk8R3X04mrNLA3wtd4TLmyU+42JdZBjIwKiwBEHnVMneaImq3l/uDvS7FOG3PlU4qjTjgDq/iZdiGGUpBJuJk2FjKckQcE9A2jQA4GdrVKHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 10:58:15 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Mon, Feb 23, 2026 at 9:54 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Mon, 23 Feb 2026 12:32:32 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
[...]
> I agree with dropping this patch for now. Let's focus on getting the
> core metrics merged first.
> The cache mechanism can be revisited later if real-world usage shows
> it's needed.

Thank you for flexibly accepting my suggestion, Ravi.  I hope to continue more
discussions on the issue later.


Thanks,
SJ

[...]

