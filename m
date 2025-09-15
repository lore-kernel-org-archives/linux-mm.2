Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272BACAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 18:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733378E0003; Mon, 15 Sep 2025 14:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3D68E0001; Mon, 15 Sep 2025 14:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9B78E0003; Mon, 15 Sep 2025 14:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 508368E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:43:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB12087112
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:43:13 +0000 (UTC)
X-FDA: 83892357066.15.A15F4EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 27A5D1C0012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:43:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e2HwtNAQ;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757961792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zR/8EbwwcJ0K6UgVTMyrQprv5o7ydaEf7t7fV1qU78I=;
	b=L8rwNwtHn/dihWL4oAZcq1t4Ivlhzt214azsTkPrecZehHNF03/IBSLZ0WNOKqngkJ6JEs
	AlJawfe4sJki8u6mcwBoktaUOxXNja45iodw/gs5I7o6VNHT14Tf59KooW42QQukdqF8C0
	myO/Ex9AvobweUi78U3OnyGzXi80P5k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e2HwtNAQ;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757961792; a=rsa-sha256;
	cv=none;
	b=ljxTY2E6RTF9Cy96MgTU8Dk+F1cLQhErF7FVzDljX6yniv51MUgpiaBAIgdgJ6iGHGYNQH
	9zJOSXGeBxqV+1hfywOiMjo9IR7rPsbyxvRo2ZpqZgIRxmRrZ/jRXjUGvYLOu3iiT2aSr/
	w9V+HMLv8zT7BSUq8KB3MKh0sDLREbA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD21F40563;
	Mon, 15 Sep 2025 18:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B85AC4CEF1;
	Mon, 15 Sep 2025 18:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757961790;
	bh=aeSPb7UYuvV9fS41JrUTDI2+bisGhOXstOy+yk8seuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2HwtNAQTxZUrWnS7dLonZJwz1gbzG0AwzJ+pVU4HVSml+vssWgfxld1bAUZtyRS4
	 KWbXINTvCZLgmCDZOdr8oosrGiFKG0pNZjW776jebqfR2oTINGZkdu20EVa6eZdoqf
	 ZREVi0bsHGfJvWNupHnPrkZUF2Td/QxiAatf1H+ud1wRFaVIAfM+yPHumFvKwOXWLF
	 rhIBSZFkUr1OupbGGfyjz0OhurfPoR3Xq1BWvAQoIn5S0CTBlNoGurI2qt5y21NURL
	 Gy9jHuBgVKtauKpLjEvltrqGYU4gxLpMXT2oaSmKPS7Wf+uJ6CzCYAEmGxj8sw3ywS
	 LCRUjUApIpuvg==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/6] mm/damon/lru_sort: use param_ctx correctly
Date: Mon, 15 Sep 2025 11:43:06 -0700
Message-Id: <20250915184306.110418-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250915150548.1486984-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 27A5D1C0012
X-Rspamd-Server: rspam05
X-Stat-Signature: gjbhosqesn6w8ksomirpropqw5osgabp
X-Rspam-User: 
X-HE-Tag: 1757961791-484268
X-HE-Meta: U2FsdGVkX1+nWZmGbRwvpp075kzlqViP33HpQZtcMO8f8kMfyXeCObK9dwTIlsCuxrUGrS+wofxnvNDEtVXCYzwTuU8PbYo70cwYIJ3VD67F+7VWlHWdUdqeGd+FkjnmBFN+pdzJrzKX80PWk8xPBQwmUIoAaqh1l6Y5qqjxl14/BW9a55Me51a5TuEeY8fJDiWm0oHak+bzxhrXQz29I1JMxmgMfu53aVCNvvvlR78DlMerpqeaG7ZavIR0dxAyMP5mOS9uFEzahQnFXQkc+toGIFSNmBkn/NWh75G/GspY5HlGVEl5BBnrPlN+EhK45MvHJBbznJYDPC1cyxB5enf9ySl6SP8VbSc6eztLphVRBUHWhqTIJnQBo9odhN6bpe2IZbeaTtSz2NrBVLcn4jseZIVG9RsH+eq9nyo3+7PviwDcnAH0GTKnWU4mnWxfTC47Ew8NFl+ZGzVQQ+RDtqs9ga6PzhNgMr/xVGbs7nH2tSYwUuNj0nlgmequvGncF+4g7VfP6I3w15GXJocKsnpDIn1vNVsHICYq+QmR/EQDapT57IpwTqfQ3DrohrI0Vk/e+A5DoHVNBIFV6v6SwGelqOswXfOws+BCMZbpE+jU8xYxxHaowKzV/+NqrX43qAIZYWe2MfP8xG2E9F+38Rf73ANNO54VfqS81jblQbrGO2dR19BfgNlE28tGU9aj8v6oa6bSVkdvazhcykPefMxNOpRX+dkmR9tewCnUDod5zlDpjn8Wj96G2HjSzX9smhqpJb6qZH8mTZJkZMvrqQRKddePAzenA7GNf+yrS8dnZ3qIeBuOinARLtcQetD91+Y6HGjUSqV17G49Ztp3EpmnbGJq03A5c+PDeIcAphS+yzeaH3cwWacRCD5FfiiW+gTNR96plomGwtHvOK1UxupT3KmXavKPQdHrLrxbYNBVWS0n4XVwCpWiQOWihGI+ec0MWGKt0Ryyu83G3YZ
 MyrR7ulp
 vIaO16VqFfTBLG316j9XqE/2G8FiHJYfIvSITe6kJgEA3ehegQl3HKVYMSW3YRSeDBRePJtdZ3wjCQtoPdAhyRfn05CBR9yNghOCLktV/f7IiJyPN807SFG7MkdfpR1RAslJ6EKrkUxGnSXzKH8jBb8YAJl3eX5bmi8fdlYE/d/RihaGIBRox9R6HZiVWweL+1t6ZtTQq4c9wrMqNa3/W0P0VrIvhsetU6qYOd02Vouf5jhZMBD9eSbCWEEtbWgpAobEcm7N4w3ib50m5D/PND2EaBJg8i17emH8bc4Dsa9fd/+bf15ccF9YTlwnx5DdomY3yHtBvKZcMi/XzMvVo38xMAKLx1Cta/KyiCAOqiFGXZ2RediHV4MDwVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 08:05:47 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Sun, 14 Sep 2025 18:58:04 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > damon_lru_sort_apply_parameters() allocates a new DAMON context, stages
> > user-specified DAMON parameters on it, and commits to running DAMON
> > context at once, using damon_commit_ctx().  The code is, however,
> > directly updating the monitoring attributes of the running context. This
> > doesn't cause a real user problem but apparently this is an
> > unintentional mistake that can cause code review confusions and future
> > real problems.  Fix the wrong use of the parameter context.
> 
> Hi SJ,
> 
> Thank you for the patch! I am a little bit confused by the behavior in
> damon_lru_sort_apply_parameters. I was hoping that you could help me understand : -)

Thank you for sharing this Joshua!

> In particular, I think that this patch fixes two possible user visible errors.
> 
> My understanding is that we want to make changes to the param_ctx first,
> validate the changes, and commit these changes to the global ctx struct at the
> end. In the middle in the errors, we can abort the operation without committing,
> and ctx will remain unchanged.
> 
> So to me, it does seem like the current code could lead to some visible effects
> from the user's perspective (error-handling case).

damon_set_attrs() has its own parameters validation.  If the validation fails,
it returns an error.  damon_commit_ctx()'s internal validation for damon_attrs
parameters also depend on the validsation of damon_set_attrs().  If the given
parameter is invalid, damon_set_attrs() will return an error without committing
the change, so there should be no user-visible behavioral difference.

> 
> Also, I am a bit confused by how the commit is currently called. We have
> err = damon_commit_ctx(ctx, param_ctx), where the first argument is the
> destination and the second argument is the source. There is a bit of a mismatch
> because in the current code we have the following:
> 
> +------------------------------------------------+
> |              ctx                    param_ctx  |
> +------------------------------------------------+
> | New &damon_lru_sort_mon_attrs                  |
> |                                     New scheme |
> | attrs overwritten to NULL	  <--            |
> | scheme rewritten to new scheme  <--            |
> +------------------------------------------------+
> 
> So in particular, the global ctx will never have the correct attrs pre-patch,
> since it will always be rewritten by param_ctx, which never had its attrs
> initialized.
> 
> I hope this makes sense : -) All of this is just to say that this patch does
> more than just improve review confusions -- I think there at least two errors
> that this fixes for the user. So perhaps a more descriptive commit will be
> helpful in the future, since we are also adding a fixes tag?

Makes sense, thank you for finding this Joshua!  I will send v2 of this patch
with updated commit message!

> 
> Thank you again for the patch, SJ! Feel free to add:
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Thank you!


Thanks,
SJ

[...]

