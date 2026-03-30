Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7057DFB3D15
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA6AC6B0096; Mon, 30 Mar 2026 06:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57306B009B; Mon, 30 Mar 2026 06:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A946E6B009D; Mon, 30 Mar 2026 06:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA816B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:41:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50C8EBB77D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:41:33 +0000 (UTC)
X-FDA: 84602388066.25.F2BC5F0
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18A82C0002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:41:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=GNmq0aPE;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf10.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774867291; a=rsa-sha256;
	cv=pass;
	b=ov+itE4dtCAvSaD39MAi70Sd2pSp1N5a6GxJWb33N26o8+UuvlG7qXOF5SepEt1srd4WKL
	P2K9vDN2xovzSj1xvACukx2l9JRfGKFa7GWxW3nePS+KxYTmJ4cwtkExi7wykpn9v1B0PR
	YlqwVHIlwzqEPeqExBe9qgCjXIOlDjU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=GNmq0aPE;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	spf=pass (imf10.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774867291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1gLOxW7D1YyMkjgkNZACuXqcsJMnta+9MITqYhpWw7M=;
	b=1UznvSagGsFmviwrMYgdkbp7t7AuTclrVKumXv4D6PkOKWePmpsb/AbF7AJmIwD1H2t0s2
	Fm3qomUrimdIpV965n/uwIprngZs3lLYi9ImMyYAezG/a01FOcdUGsZr2gxSaWcBwMc1HO
	osrdlJKWDVRHLd3Wb8weafzFAa2pLg4=
ARC-Seal: i=1; a=rsa-sha256; t=1774867278; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=jElvRFtbh2Dr5cwbvr0lVMX/yO6tjM5lDEYi26SaeY7yJ9MK+ACNXtZw3F/uU5OJTHYPWAcdzCIhH2mP/K0X3bCK0aatRqR6qBhE8PWXdorQp9aQNn9khWKM9Fn7wYHBjzin29miy2W8yo+czQNx7AofKXMQ3FYPwVZWpYxAV4A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774867278; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=1gLOxW7D1YyMkjgkNZACuXqcsJMnta+9MITqYhpWw7M=; 
	b=XI3YiIz969zpimdjZeslludY1iQhXB6HWdpXyvQkLQ+wOR5d5cGvS0ktDM0jYX+kmr1iTZgHi4RB1NZ3w8lJr3FWhkDungAjJ+215f+1nf0XyOXaM0c0lyRnsK2V5cFTCLuizAKZmO5I0B2fuGC4Es0unraJvuS+ZWL5U506QfM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774867278;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=1gLOxW7D1YyMkjgkNZACuXqcsJMnta+9MITqYhpWw7M=;
	b=GNmq0aPEp7ZA2jnvTYdlmXaJfxahukN4yVraQCr2iW8KCq0jJs42ZvgUnUOclH+n
	m+jbw83v8x+bA4HvvYsY5YOPKE7TlV0+r+hsMH9lER53ZtVHbx/kgZu6aCCOAFnkV64
	4jHT4gzdcoGIJ4JjUJAjIR+rNse0BcLWBrQHW2dI=
Received: from mail.zoho.com by mx.zoho.eu
	with SMTP id 177486727888129.864738753605025; Mon, 30 Mar 2026 12:41:18 +0200 (CEST)
Received: from mail.zoho.eu by mx.zoho.eu
	with SMTP id 1774867277943384.19373731732355; Mon, 30 Mar 2026 12:41:17 +0200 (CEST)
Date: Mon, 30 Mar 2026 11:41:17 +0100
From: Herbert <objecting@objecting.org>
To: <david@kernel.org>
Cc: <krzk@kernel.org>, <ljs@kernel.org>, <hlcj1234567@gmail.com>,
	<sj@kernel.org>, <akpm@linux-foundation.org>,
	<damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<kees@kernel.org>, <gregkh@linuxfoundation.org>,
	<brauner@kernel.org>
Message-ID: <19d3e556876.698a550f63973.7445500539418743220@objecting.org>
In-Reply-To: <6f045727-91ff-45ea-842b-c78ea61ae4d1@kernel.org>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
 <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
 <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local>
 <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org>
 <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
 <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org>
 <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local>
 <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org>
 <e5d45f3c-4f46-40d1-bb7a-0a2f930fd7ae@kernel.org>
 <82256A72-42FD-475E-935C-629964FA80E7@objecting.org>
 <11429699-81b4-4c1e-b247-480136fd1faf@kernel.org>
 <6deb290e-b168-4de2-95f8-fc784ed31c27@kernel.org>
 <25688dbc-cd11-4137-bad4-a215198feee6@kernel.org>
 <19d3e3d3297.190bc89f62053.5899613485100180781@objecting.org> <6f045727-91ff-45ea-842b-c78ea61ae4d1@kernel.org>
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Normal
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Stat-Signature: 1t45ro1e7ms7aai6o7zqa3y74dz6wqzm
X-Rspamd-Queue-Id: 18A82C0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774867290-844194
X-HE-Meta: U2FsdGVkX19BAqpGuLYl/ZgswByEGvLSazUOyo4qkaS0ysBDTtRfmBS8VGP9wArWnKKJS/mZPASGDd+PHekTc8xSmmTVyTNB/1PNk2mkKsLcB/LB8Hf3iLfJd1kVkFLGZ3bfcKwsNrWzupQGcC055GbpuMh0dxFYC6f3JYNvRisAVIcdu3J7S9Vqngnz4LaNByXC5/t9zDa6OsIyRxcRB+Vnaq1z+lSmtJO5mH8EFe4RhjKGdO7s6U9XVvV1aDA5JCrG/BoGOzwU0YN32KzrIgBpQi4pvgn1qYvYYiNxanoBqh7GKphG3f9QYQuvdMAyBJjzHm41DVW8cdWJSXxPb5YrhnZM07tSkvZvhcXVhyEwuunwfVdOouu64lshIH8x/eH9CelyAAHyiRt1AHC/QUFzjo5xYI/keN/umEYvbo37SCCxGsldyA4zssu1hD1cWFlxzAZABMtRcdNW67x6fh9ytA+UtZVHNkPm/jZOhZcUBFnSFC3LFF4TR5Tf6aSgeWtowyJ4r4dIo+QHNGFr71CDvDVXlmlnmZMHP82+chD2pc81VUx8/6EwNrAliHZ7APlPhBaxG79fmqqTqzsmcaOCFLKcZeIkrzPcfpOiSW0LtnyIDxDssXcY+TY4bYWrrUKA5fmNlJQoUtpVCagOIichlbwXi5n7/rnXMVr6QGHfNkTXBqeCTr3mrk1YAidFdDBZbA4aLDVVvsbr9oI9cciZVWLyz/a3Cl71ea98Pf9ZOVqDJxsh1L40/z/z75cWfUdNbvJaU/uL70ASC/cxhKqCg1V7TvSNjQq2aB8CPIufV8KvJ+c4QMruLrgb8OAm6uyyLy/TXXe0V0AfFa2nvGM2gjvamzc8qTRSzhRYKVgDNMDyniq/ZcjJkfnDUgQdHM75HhcqeLQZTCzlSN/+aZIretDBsuH3ID6Kx3JX1dG/o02vAmqvvWMrtZF9PD7/GRL1ImlhWGHr+/QAapL
 Q1C+zVav
 NBIcwM+49zMjE/o5e88oYbNd6YHDRldf/XwL5/NzCsESYjtfT3CZrsLODZQVqWpqH9FkdLGEJ/XUJjy2PA4/GJyHWHLG0/kQvekW6hMKN+jlUXR4kuC4BwZs0NJjRxaXVa5PDOo6kmQ8MYJjIBECoJ+J7Tc6AiqTN9M2GL/ovGXziMcSyUfznyRmt1EQHgZ1FPS24XU3fqtxGoJfgzZQQoRNrL+QFIS7SElhn2JhsP80n181XKe87WBRVNgMSZa3JL8ZFtmQ1f5ZvmOBoqccqyG+VqQfd4FjII0iA44CWAUFhSh4ib6UytDWvUUDRXUwqgBOfYguhz4Jo1ktqklbXTD9r06SBInEn9Hh+1eZ8F0pInd2zbtK+AMF4AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>









---- On Mon, 30 Mar 2026 11:36:39 +0100 david@kernel.org wrote ----


> On 3/30/26 12:14, Herbert wrote:
> >
> >
> >
> >
> >
> >
> >
> >
> > ---- On Mon, 30 Mar 2026 09:16:44 +0100
> david@kernel.org[mailto:david@kernel.org] wrote ----
> >
> >
> >> On 3/30/26 09:50, Krzysztof Kozlowski wrote:
> >>>
> >>> Yeah, good luck. Several people asked for that already, like 10 or 20
> >>> times. Andrew asked that a few times.
> >>>
> >>> And yesterday we got another sloppy posting, so that would be it for
> >>> having some time off to learn things and take slowly. 3 days after this
> >>> AI slop which does not even build.
> >>
> >> Bot confirmed, I guess :)
> >> --
> >> Cheers,
> >>
> >> David
> >
> >
> >
> >
> >
> >
> >
> >
> > ? That was me learning the ropes, by making a patch to the QCOM subsystem
> >
> >
> > and it was a genuinely "ok" patch.
> >
> >
> > May you please tell me what I did wrong here.
> I thought you wanted to "take a couple months break"? And I suggested
> getting a mentor first.
>
> Anyhow, this mail was sent from "Herbert", which is quite ... confusing.
>
> --
> Cheers,
>
> David




sigh, I need to fix that, my friend helped me do this, and for some reason the name change didn't appear, which is weird


