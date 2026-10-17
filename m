Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CD10CCF2C7
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 23:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2F1A6B008C; Sat, 17 Oct 2026 19:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF8E6B0092; Sat, 17 Oct 2026 19:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5966B0095; Sat, 17 Oct 2026 19:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C07B36B008C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:14:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 526271203AA
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:14:21 +0000 (UTC)
X-FDA: 85333673922.24.1302368
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6D87AA0003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 23:14:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=awBjCuok;
	spf=pass (imf25.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792278859;
	b=GJJJZP4iqC+/7QT4KZmGLGHy2hyxcMCRALDNFNAVDAFgKCMhfcoFVu3tyS9l0HmOpIhLsJ
	NfjZQ+YpRHqclNM9/ozQdktQe/ALCXi2uZHxS1V07NlTAw3VXmnkrY360cW2A84F0HtgEK
	NjYD5bzEnD2ctaswfQAesECtkWyWh8Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b=awBjCuok;
	spf=pass (imf25.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792278859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+lMZg7+0kACDrdadkjvJfyvZj3KfPiWWzgAN6F43PM=;
	b=olsJFBcRtDAEbMvgctrbQbHLzHuY3dvtw8xmDK9ebzbsuyQ16+w43bvl1+c7j/CXFIvtJo
	WfiBKsf6ohXGu8tORoz0Q/n/6yBXa+AIR3Hc8vvCDSGoLbIWfI0cslyvdgCzgJ9uHU80gl
	SpQXrCMk++DyDztzMeUbnBvIjD8CurI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Content-Transfer-Encoding:
	Content-Type:Cc:To:Subject:Message-ID:Date:From:In-Reply-To:References:
	MIME-Version:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=q+lMZg7+0kACDrdadkjvJfyvZj3KfPiWWzgAN6F43PM=; t=1792278859; x=1793142859; 
	b=awBjCuokOwxe+rw+mVwngjTNoUau1IMoUIl1sR8tGXgcI3HtwOBxPZtjlBS49leGz1BCHUjhqSZ
	cODTIe0w2y5Y6eWrpJSHHpyuFSh3QkFSvtD8mH+G8cv8PvgrYkpxVE1CkOQ6Qwiil+5IonuZTvKSJ
	aBhgdh/VQXpciaVqIPOGNL3I5/ic8/jyso5U4BqezDVCIk/+rIl9HqSL9QzjQKKQXaify15OCr5Vg
	eI9WhQt5fAgeaAFXRTTQa7C00gZwq/cWtqggSavn+FxdtNjynqz+u+Y5wPNkQ0ebcF30bm5KwIccG
	iuJFfx1bB3tmaE1OkH2l5YFjxR75uiYQ715g==;
Received: from mail-dy1-f174.google.com ([74.125.82.174])
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xIDbW-003knG-V0
	for linux-mm@kvack.org;
	Sat, 17 Oct 2026 19:14:18 -0400
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-35aa0cf7c40so1943962eec.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:14:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByAcZovto0otnusQWIbzsdf/0c2/vJ4nNujzW3J5CGmGTcRrdGhHvC2rFB3/x+3pTayG5lG0It2Uw==@kvack.org
X-Gm-Message-State: AFq9FYKdS7NvyilF8nxbQtwlwBWCvlyBbx5uDMs7J6Ge/FddDmwukV+v
	vpYxUrk8jiUoR/U+mRvylN+A0V9t7PWpIcKYENuKHTnbti5musPXEaTlJiNjfl6sVA+QlXop0HM
	iS/4SxTwRZHhkKAp5u3Sj4RJ30toz8AQ=
X-Received: by 2002:a05:701b:205b:10b0:169:9f67:a91b with SMTP id
 a92af1059eb24-18511eb675dmr5404234c88.12.1792278858015; Sat, 17 Oct 2026
 16:14:18 -0700 (PDT)
MIME-Version: 1.0
References: <20261017154120.795844-1-nickolai@csail.mit.edu> <20261017125244.b2d7134fa9697b2982cb8cec@linux-foundation.org>
In-Reply-To: <20261017125244.b2d7134fa9697b2982cb8cec@linux-foundation.org>
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
Date: Sat, 17 Oct 2026 19:14:05 -0400
X-Gmail-Original-Message-ID: <CADGQE7FrnVVtP1xUrTOLYrK_OLbfEO=hOV=ViN0b97RaHwcuuQ@mail.gmail.com>
X-Gm-Features: AclHuK96zPFZbSfOt-kyY6WULsd5EQwS6pFByJIjbN3gQGvkzyBQSd1dAADJhV8
Message-ID: <CADGQE7FrnVVtP1xUrTOLYrK_OLbfEO=hOV=ViN0b97RaHwcuuQ@mail.gmail.com>
Subject: Re: [PATCH v1] mm/vmalloc: read vm_map_ram block regions from the
 requested offset
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6D87AA0003
X-Stat-Signature: ahrq9hbrm5rnyg6cx1orrzm5mi1zf5n5
X-Rspam-User: 
X-HE-Tag: 1792278859-472135
X-HE-Meta: U2FsdGVkX1+ojbw5UfBZbhThJn5BugjVT+lsq69SsNF/DOS8p0MwrYIGdU0p++PaE+JAO78NI6lm9clda15Ww6m+6TLJvWznjRyIxMDt3x6IRqw2GUsy+Ahe4JcYzWdjDR/78mnG8OwCdXBOjVCpEUrfg8uKZmlE26RqxnTfd4l3bC3MXaqRcIUvtAYAkikNYxBiD+C/bktPb5jHpZGOYwwVj0TnxXUH9Be6/msrg/Na6hMo3U4OehHoFGmxdhv4n6j4M/Vj3WN2Xce88SWRVqi13iUk8clje8IYUuY+nIqFHShdSD7RXb4ZOx/qU5AYM19EEjkdSo7/ho6K0d3NE0q/vYDa/s/F04IaT8yx1ChpQDyejai3oMLZL7jfH8acR3lqVJlCl6bPtggwq7EAi9OOe260tMV/fABOWrjasKXIsX459QaHqSD9YIJKztUtDJbdcgWjyACx9Uhs85m0k7ULVOd0m2hoCx9KT0ZwaKmxBxlq8qNqlJOM4zFnJx3MLcBY/c8Gi9tVwko4IDnxvtoH2lKPgrsUvYglFR79BGf61DBnmUlsoGPlsI2MYjv85ZJqVFkPNVKfzh9ndyavz+D4wRPtLKl8Q/c7WJV1rpuY68jC36I7HyKzOr/a+vHLt8nfteTqxRHgsAHDJ/BOCVQJW97wtl54J9nFwdUPFqgcIQKd6+I8ZHhBtQ1a4eVQFvCmf0xFEGWTLyAq0MldxZA2H4pCtmyodVkXATLJh/KCisb6LvWcdcOgQawZjBXAIJzd7kcALXqYGyhkpcOlZkW22o1yTKR/Udmb0PyBK60VPE2tKxAGhajL/Q9C0TUwovueeJrVS8y+jbDUdw4T6Chko7iq2VTjF39G7BbI3z1ZS+BKOgAAq00pPauQCWz3hcYEGYqQk4zxBsw5+TeDP0SEiotqNJghoE3HbGbTZ4gBC3cWZ/wjktDmnowFL3Hs1MGh1coJsq00k5D43CJ
 rgB0gIAr
 N66pgxmAjHjtSnX+xKVWG1m1jJDJ97XFCUo2Gg6kArYgpWb/EkxAa3pB1IP2GdElCgrlTvX7cIHPYMdMNnPqhEa2Np3sSSgioGdMqDhDW/j1gyXvePFBNpenP9fcV0p16QztepqNABCifkhgt4lPLvNv5VyrfZYYyB1sF6zcaGTNC+oukGqBLxO7vH7PzELFQtJ0q7ZRwjQW5wXLSLNEEqd97DzRa0zsK3N+r7cAzn/EOXMIlcImm5yYd3WmfYc6V1UEMbzOo8HuHtWOXSeXwGV+GHZwwfONdtCEcCRF2eEl3u2gmLyfTNwiYGIgRMvN2m9jjZMo5ytOt/5xkygxDL7keSk/REpqpj85wv1dbdiy3OxMPxPXLg4nnPh/jWblYrDJgQRlkmy7hO4+051Eh604SvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 17, 2026 at 3:52=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> Thanks.  The Sashiko review is annoyingly embargoed for 24hrs, but it
> found a possibly-preexisting off-by-one which should also be fixed in
> the context of this patch.

Indeed, the +1 was preexisting, but confirmed that it's also a
(separate) bug.  Sent v2 with both fixed.

Thanks,

Nickolai.

