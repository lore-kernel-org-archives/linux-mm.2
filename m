Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8F3FEE49BD
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 05:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA666B0088; Wed, 31 Dec 2025 00:01:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 261306B0089; Wed, 31 Dec 2025 00:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195096B008A; Wed, 31 Dec 2025 00:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 066486B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 00:01:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9ACAF1A046C
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 05:01:45 +0000 (UTC)
X-FDA: 84278568570.29.0DA2455
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0ED15C0013
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 05:01:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fgsqbEFJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767157304; a=rsa-sha256;
	cv=none;
	b=sAk0Tn60RQXYRmhis0ph88ok+xavbyfikt411BYyFi3zla6kEclNfenZTkvBsMqnsKk/vo
	Xqkq52H7C4sU99lpaISn7FmB42goGgnaxPsn+BnVSHanZuF/einIcaBWj5Ou8TTaZDXgfs
	eiCVmvE0ORkcmYcHAzS90g8Kw9erizY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fgsqbEFJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767157304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zVE06YjRpVx6MboC2zFL1ebr0j3e9aVs3q6ztrTrduQ=;
	b=Wel6KUr+r4hGiB9FrWAx9pqAoatUyZE8YCs8VLDCFakIFmMDPBD+agQXieqHcW5asV5P//
	F+IkCkV6mbxoGRrF7ZiiueW03WE9Nywsq0toEzQQr76TDdEilzmbgZNZjrDlPwDpJ9MlNr
	2/yMi1qLtKIdHc4U6ZHBcJsfJR/JT5Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8775160008;
	Wed, 31 Dec 2025 05:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B9BC116B1;
	Wed, 31 Dec 2025 05:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767157303;
	bh=ejr65dPwB1igdyhJuOkgkDHxjUZatDO/Hs5Knw9TBVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgsqbEFJMphC0NO85sA0hK3dRmiHLIn/+JEvZ3VNUypK1t9a27aQIRKldS2AIQWG/
	 xTmKizpo38V3KcPQlAv0MBFChHJj/8tvP3MjynQHl/gUa64CqW04pAZcWQIpdtGdi9
	 yZXTEiFhaFLoHiHajZsYX9m/HefGnzDlKh0s9ccLHTzs2TSQubV2ClWlJQqvYm6omo
	 JCncODigKLKHXsclYZtW7jiKhNyZi1NXfPtqvC//DE8IflhspoIyMqApPhVQr//Uqa
	 2BjTHt1tIBdlDJ1onQo57zNspzMUI00kkpVTWvM+Ox9sT9gqHCI6QKLYUz37seWjI8
	 Euakf0dOf3yIA==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangkefeng.wang@huawei.com,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
Date: Tue, 30 Dec 2025 21:01:37 -0800
Message-ID: <20251231050138.77727-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <4b367446-2248-4936-99b6-e9ee93298eb5@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0ED15C0013
X-Stat-Signature: hm6c868jr7st9w53whm5jpso169yspd1
X-Rspam-User: 
X-HE-Tag: 1767157303-892203
X-HE-Meta: U2FsdGVkX19JIFO9MXkx/nAz7metdc4Sb9zt7toAlYZkMlENLxlr3bK74U0iHMVJsvoswR7ZuCFykybompcpGmLqUK6u0bEC4cX83+2Wofwu/C3XEWNNiYJfO56CUe8pSTw2mpFrE2KF7uPxRQ5RDZPNGSJj8Hi0br/pu+ybdptfZOEgJZT7M5iYUSSY+bc7NgGnyPXs9wH2Iq6A26WnX/sQypBn+t0XZw2q5tJAElNQ2OvG74vEV+ZKuyLsrILoRS6f01O8EmgGkbXeeCpGh295X4FR3n0JnazTKoisfA0i6I1AaUytEH5asd59JTvpghBaKJ8pvFhkeSM/dJJhatk/u14kSkiLIPs7gLwKiuUiZTqe1T+WrOgzj2oPynHnG0a8MRF4jYo/Xp/2HChVvHZIn7v5rFNCHEd81PbEAYtIDMw+FJ+TxHV80B5KwWN8ZtzXnbrBbjlCbknegj7m84lLn3UK2aNhc97qWrqW5NGMMl7qlfXLYd7CdUc5mMWA71xlYUAJwWzADyJvCAfFUhia5Ahppc8RDGK4TRdU4N5t5QBmEXAPI4kE7vpNUyUMoL4ZYUNuV2RTwzaeYktZIfLsfdVIAxR/Elicf0iU7Im59ZSR4HYpy0VcfCcSiL0WYCvcoVkqmNu1Y2ZgDIk/SJOgeynM0TYPKshqgkZ2sjNM5IlyPIsq3aUg7uUWAccidAaJAOKz28ukf2MTIBulCNVtiI2krbPJtx/s1wvLY8sUDHQSa1d3c7/lttHSzb6VKRErvbe0cknwKccNje65iaIVDl9Ba95eEjDemWO+sfGQCGTW9EuaETqWjX9tB9cD6zHhoIG7OBfMSrjAc2QtMMZMbQaXGcwpg+oXRYDR1XsjOZU9WNFh3VAyjGVJPXGGuWqEV0clGI+XNDeEyF/gygldVMt9AnJPoVa5254YChY405gqdl01lpm4+HsVse3UZ/KNSdOaP6+tF3zqLWH
 yjqYxM8h
 DQcrk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Dec 2025 12:02:31 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> 
> 
> On 12/29/2025 6:22 PM, SeongJae Park wrote:
> > Hello Asier,
> 
> Hi SeongJae,
> 
> > 
> > Thank you for sending this patch!
> > 
> > On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> This is a minor patch set for a call_controls_lock synchronization improvement.
> > 
> > Please break description lines to not exceed 75 characters per line.
> > 
> >>
> >> Spinlocks are faster than mutexes, even when the mutex takes the fast
> >> path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
> > 
> > But call_controls_lock is not being used on performance critical part.
> > Actually, most of DAMON code is not performance critical.  I really appreciate
> > your patch, but I have to say I don't think this change is really needed now.
> > Please let me know if I'm missing something.
> 
> I was just reviewing the code and I noticed this. Yes, you are right, the performance 
> is not critical.

Thank you for flexibly accepting my humble opinion.

> 
> >>
> >> Initial benchmarking shows the following results
> >>
> >>
> >> # bpftrace -e 'kprobe:kdamond_call { @start[tid] = nsecs; }
> > 
> > Commit log shouldn't start with '#'.  Please consider indenting the above
> > command and below outputs of it.
> > 
> > 
> > Thanks,
> > SJ
> > 
> > [...]
> > 
> 
> Thanks a lot for the review!

My pleasure!  Looking forward to your next patch :)


Thanks,
SJ

[...]

