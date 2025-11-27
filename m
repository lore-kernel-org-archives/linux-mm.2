Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 081BCD116E4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 01:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308EF6B0008; Wed, 26 Nov 2025 20:52:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E10F6B000D; Wed, 26 Nov 2025 20:52:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21DE56B000E; Wed, 26 Nov 2025 20:52:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1056B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:52:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B1D701A0897
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:52:34 +0000 (UTC)
X-FDA: 84154712628.30.FD7CA8D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id F0D96140009
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:52:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CnJc+BtJ;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764208353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R8dekcSPpSsiEGl28fb1XvkqjOvt7EKLP6QkQLciu3c=;
	b=Z67Ndm/3cUB9EJIJ8YZpMpoLDpKYSgm9/KYGRQ8wllYMiNsZ/Qrx3XYS63K4pW+oKF8VDz
	mIrRtq1+pb+aBiYh2RjEWkwpgP4YhVpIrUAsp6xnLxoO8GXhvCkdKzuWqrdrYppF8Ib9wh
	/nCrkB2nTe8ya6EowQIshlOQ1Pe1x7s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CnJc+BtJ;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764208353; a=rsa-sha256;
	cv=none;
	b=KuBx0LlZDWHRhY4A35F1AQkfAq4eo/mPTFFFnM32yMqNLIpRYVXLxTcQcUNmFfijjaiF//
	VNoc+pzC9DrygKMwHGzwj154z4Nukfk+ik+ys5R6mTnck1t5Ctqua4qnGg9T1uNHTHOEhE
	R3PJfIAliS2kOO1wm0uTdd38A+gA15I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5549B601BC
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A80DC4CEF7
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764208352;
	bh=rTsMfK4mKTi1gb3lui4zzUTKl4L3MaLNMfpEHmqmbJ0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CnJc+BtJb6vvhuuDgjP2eSeiLWuWly4lTtKVjkd6U3MCpXWon4sF7V2z51lJuGxpK
	 sM0pSidUHx5zKt6VLNH9fWRrEZvDelprdLPO+rsG18YB6ANWHcwRy+SIHrG84qL//r
	 7eQi+thVNmam0ziMQ8+/m3jPFTekvk39IgYMC42DPzwqASTLG9uo8X8xh7Q0VtTyFL
	 rO34nPzQiu3VNggspH+XthEEAnXW5Qdv4OCOBISz9hYfV241LqN8Sa18o4aNR1gdq0
	 WKoe6x6QepD/TZ4OWMPv6LxhVjB8Ztjwa6CtOQq2eCyFqmQ453nmlS/XsryGe7t+gt
	 mD95r1X3KDMBA==
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-64308342458so360979d50.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:52:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVfXW/MbwS5JKodDditk1U03/fDafZ4q5ZsWJv6LBtF5+3xSeyy/Cks2DqQU437BKP68dC6ZkjCZw==@kvack.org
X-Gm-Message-State: AOJu0YzlA5Wt/XRuUNZyMCZb4kGAqlaae0OCaZkRo8gvWljQDZNCn/9c
	EvF7xHBA1XNgGfDFgtqayzPW/ta3UZUQ+tDhc0Uy18yuFe1vVzmcQTHV+0gPjxEPx+VLeHh+KlN
	LEyjB7h4qhFQBemlVgNvqC+dEnAv9lAS0RV412VXcmQ==
X-Google-Smtp-Source: AGHT+IH3oh1hM7hC3bKPCS9ERIVbg86t+92fDNeJ9vlTFOrtx4TxOi5qfj5svJlcwAEPfHe95P9qurU5UXUgeeMcm8I=
X-Received: by 2002:a05:690e:1510:b0:63f:9c56:96a with SMTP id
 956f58d0204a3-64302a8f864mr15407991d50.5.1764208351316; Wed, 26 Nov 2025
 17:52:31 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
 <20251124172717.GA476776@cmpxchg.org> <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
 <20251124193258.GB476776@cmpxchg.org> <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
 <20251125213126.GB135004@cmpxchg.org> <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
 <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
In-Reply-To: <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 27 Nov 2025 05:52:19 +0400
X-Gmail-Original-Message-ID: <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
X-Gm-Features: AWmQ_bnqiAM_KQG-4EvRrObG0Dno0PPMfjPHAA6uFYO_OJazY_b0uEaMSzwUd1g
Message-ID: <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Rik van Riel <riel@surriel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, pratmal@google.com, sweettea@google.com, 
	gthelen@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F0D96140009
X-Stat-Signature: q5yrgeim6x1kmdkx5ked5x8p6czikh9c
X-Rspam-User: 
X-HE-Tag: 1764208352-130071
X-HE-Meta: U2FsdGVkX1+MnSgUer8nGqYRXvtFZMhSEMXylZnk3o5CfWwkqu5FJfJpqQLpgbDDByrqFiVieDBAM9qEJjs/qd98ZD4hCAkjkv87Z0YTg1XANtqquPlvYxnUbEFpB2VzCBsR84zuGWabRZKngFpem8YI6SF3xGWvx58ZmtcK34IAuIBRmrOUNkVlgi4IRn5YkAjlLZV//h3z6fhIINTqu4/3acdbo/HXzqpoK9GchrqRIZAJsG8BLSWXG7J86j85Op6bwGIjH7h6sTGYORybNaZtmHlU7sg58EqqK+IMgV4DJZbgeNgOwhXSAa/g/8byQ1OPXK8I8BM0akHRZYrBVGdzxMNWpJpO6sEXVFfw9h9WRDzXliJOERYBNB1F/6USKNIIgq6XpNg5LBo/AUD49RsvYOTj1z56oss7yOEA4q4+PMyqp0NTQv14bsbkoIRX+Gk5GpyJOJmmY5nVaBYyLTKg64k98ws0syR5+oNdNN8y1w9guIJTsQE4A6g+VijaajIQ46FA1f4RlEEdO6pjNdn4bfXd8Btafb/CvMNIt0iVqup0zlZUXnpjMNOuWgnnDIi48MVdAZ067bxrAiIIsEyePKtCj5BHyo4PRw9tAQTwJ2XCwUCtoC0CGnLPdml18sp9pEjvQ5WY3BS7cXttB1TCVOn6968ify/Gq7Djnl2plv0sZTS7fLRjsMVoEpzGU74SdDrekWQPz5Gkx1cb6qipE4xbVtAb6XoRJYw+22aMlQM1nEiH+hwb8FB94U9DrZRZ/nYHnImbgG7ZO48SivDBui3By+zzvi1ytrsX3c1bBdngn6qlw4j2uhKqdv9isUUDCI5zaa/q7DrRoYF2iodRJAm29tVTFYbz/TD3juC1XuxWkxDDJ2AVFM98o7rwb2ZpuH/Iaxx74ESancwwvo6KVHbtBzMBpd8GfoCeeVLt5jJTqvZ9Ktsa+Y10KWdsIDSwosoVeZQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 1:53=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Wed, 2025-11-26 at 23:22 +0400, Chris Li wrote:
> >
> > That being said, I think I have answered enough technical questions
> > of
> > my approach, to let you re-consider my proposal. You should be able
> > to
> > realize by now my approach is more optimal compared to VS. Do you
> > agree or not? We are just arguing how big the gap that is.
> >
>
> We would have much more confidence in your
> solution if you had told us exactly how
> you were planning to solve things in future
> stages of the project.

Can you clarify who is "We", sorry I am not part of your Meta kernel
team circle. II just reply to you and others how to solve the other
things. If you have further questions, please ask a clarifying
question. Until you ask, I don't know which part of the Swap Pony plan
you don't understand needs more clarifications.

> A "I'll solve it, but I can't tell you how"
> is not very confidence inspiring.

Don't need this kind of innuendo and it is not helping.
Please stay on the technical side of discussion and try not to project
personal judgement, thanks.

Please keep in mind that I am just one person love kernel hacking and
want to do the right things. I am doing this at my spare time, it is
not part of my company OKR's to work on upstream swap in the last two
years. I don't get pay to do this. I am replying this email from my
vacation 5am in the morning.

Again, let's stay technical. If you think I am holding any secret (I
am not ), please just ask a clarify question.

Thanks for  your cooperation and sorry that I did have a chance to
explain things better earlier.

Chris

