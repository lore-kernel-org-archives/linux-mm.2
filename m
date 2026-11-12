Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F12606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fht3FoDv
Received: by kanga.kvack.org (Postfix)
	id 1B06D6B05C3; Thu, 12 Nov 2026 00:48:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160C96B05C4; Thu, 12 Nov 2026 00:48:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09E316B05C5; Thu, 12 Nov 2026 00:48:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E16546B05C3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:48:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A5AB80296
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:48:02 +0000 (UTC)
X-FDA: 85425386004.27.D2D2CC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 97F9D140002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:48:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fht3FoDv;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794462480;
	b=VdxNB1naS08juHpEkC3P+tbCxBVPNnkDqKnmZlvXlupASI/c5lqVNYrsB79XxqV5Of7SaU
	EXPyeMnALzVsgsivtnzQb4GLJuKmxV4l7USgbJF73b/cDfG5aZpPtUV61R1VUc5d2+mqgw
	iLzllo9NjyPJ3nAlFoQfnZGxjIKQZv0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fht3FoDv;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794462480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUA91tQZCWZqcmBzWPF8HIacecdJUnqUabvXTPPTHkg=;
	b=uNuyCTMN5d/R1wZl2s2XrwXCGPgl/mZnICTqUxpe6FF2C82dQhvHV9UILjhPNQFdn6CRpM
	sXoO0CYrYhQ9fnt/GFEMY1XBNDFqXBJzloOE0hU8ZW0JGR5c9n1xCEA0F3M5N4ENfnSQJ1
	AvpLCDuJAZwnr5Y6yS4fQrqCi4jxwQE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8754E47716
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5FC1F00A05
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794462479;
	bh=YUA91tQZCWZqcmBzWPF8HIacecdJUnqUabvXTPPTHkg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fht3FoDvB+q049SLtodYssmQY0Qxo+AuNKRxdlljYSHxQEtdWHhCIm5KrI4d22404
	 blFpCgXbtyIsQOnTyvmLe1btup4T/xoaOoUctYbnj608YZ+OpRZxw4I5MwGIcUqmJM
	 4VFSeSVRdmIoctMNI7N0vlb50hvbY6ch+3a4/h77QgjO12Fd8CWBlN1EB+OG/5K+xX
	 ZiIsROYqx12XWIaRxEEHD4Z5dUsKcxu5nPEivP3LYjY+SG++dwpc47kZu0jmC78RhJ
	 8ceRK4aGI6S6rJ2GgAWSM1pBYiZ8BgxW52HltZLXyH91ZDR0kyLHaDwftGi0ptBCxl
	 j8b4caTG92H0g==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93e635220b4so358458785a.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:47:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErF58KTw+09cVupBSc1rW2LIQ1vJA1GXa+kC/K4zRrDbpER1hq8x1miWCVSlgu7rBpjF9jiXr8CgJA==@kvack.org
X-Gm-Message-State: APuU4Z8vTuIPHrik39j1dTsYuwVLJyrUktz6kaEnc3c7m08F/Og/WCWL
	iG4dWwBZobNI79ujtQ/JC925kq/lU7OYC9Mjq3vW5BNWHsmoPW9OgzYa7AWuii4RDF//WWIVJb0
	rcOe+4bfZJgohYNkffM+J/Z4wAXpy9uM=
X-Received: by 2002:a05:620a:294c:b0:93e:c12c:fbb7 with SMTP id
 af79cd13be357-947b0051f3emr811615585a.68.1794462478686; Wed, 11 Nov 2026
 21:47:58 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261111232603.9934-1-baohua@kernel.org> <20261111232603.9934-11-baohua@kernel.org>
 <sashiko-outbox-210418@kernel.org>
In-Reply-To: <sashiko-outbox-210418@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 12 Nov 2026 13:47:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w43aNBSyeSPFkrh0fz-cjj6c-CiQaecAhEev2=RAXHQA@mail.gmail.com>
X-Gm-Features: AclHuK9H902EhM6rH5pgcuZ3RxLool5O2usQFiRRey20oLFUrjntUL0oCOYz3Yo
Message-ID: <CAGsJ_4w43aNBSyeSPFkrh0fz-cjj6c-CiQaecAhEev2=RAXHQA@mail.gmail.com>
Subject: Re: [PATCH v7 10/16] mm/mglru: Run aging when pages are rare outside
 the youngest gen
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, 
	liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, 
	mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, 
	ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, 
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, 
	zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 97F9D140002
X-Stat-Signature: twbo1kitp6b88cauewid4rs5maoqe7kh
X-Rspam-User: 
X-HE-Tag: 1794462480-292364
X-HE-Meta: U2FsdGVkX1+NEffMs0nX1S6IvmbgldiuR/cgGflBJ2+X6gEpufFNrtm1+9dRL8XNw3mHLCJq8miVkyQKfO02SBoEJVwXGrQuPqpNyOjxYOqYNBCa+4IpcI4vOK30zkw8O9UXGwJeYy+4iX2we4OviCdk/09tchoqrd5nMC5lGDe06MOR/TVsdVQWLlFKcHi8MboW7HZY4Z3lLe+xJwF6iNLHeAJd7VGuh/auV0HQcqm7xrzMO84hrkdGJnSvkckUKdJO+SBWAX+Y6T7ij6o/mwylWfjOOIZros4unEJmkU6MzVy/aIj/7YXuIbCrU6xq3ICbHIQIr3XAFYyQcQLjQt1UhY5xxfFqwmkoy7MFm8OIshUJEePYwP+0GEuh4d7wco3FGbADq28IC6pbHJ1H7PJqZJpC3hwLKbiCWjNALgKcLD3aTjwte00wWseOHEwdVzeByC9mFW843ZEXo5PHRHBg5p8bmG88Fb0dAB1TWBPuw9CzNSFkMafkUYbsUno40SFN1gKNznj4lFrWyt7Kqh72Ij7cZ5N0Upf5reImYxFUPysDFiHKaNwM70AjKyarlHgqT0c85SCdIaZbJgpnRVTZx6UVLN8aKMj1GP41V60mT4GrPTpT/elE6tJu1JpzSZyH1P3ZHN920MBGeNZDNgArlI8rECpw0SQpxO/qi9N8XmakY9cWEqKsGkdQ5DWCMr57k2eeSdfpcC1oMO6fvugciEY8NCJlS4xjKnNqVPfx0JIP2UmT/xLXivIg0Vd4W/V/gecSGBpmvVKl4wbZn/EBVVhsriMPXsvXxEKdh5o+CfdRqhTieAl93UMD66/TlKpPj/k9L7siVDFrQDFzSaZwv5sAKFz8UewW/l4G3FhamhnirMXyFwuVpgW387w5P5IUqLTkBSufj1AQVkgpglAsfIwAK+z3pltMrDKVTKn+9cWhOaISrmgD+BbinfcIRlUEIhjvIzjf5X6z0H7
 /OXamBlE
 V2CKEePor9bRxO7YjbHq3XJCdJXWwGjD7+301bKuQai6EySgc6+cyxua01RaABGslZY54iyg90CKAl98Jyt/DnIGEJdgkXOnim2KvVG6WanzbHoivuFdfi4stTa7lBZxl97zDTVmPF9oIgUhX5kDDCegk+YWAzjAkTWQwivnG+09FZD1kLnfYkSjh8oc+gHl6oISCrolFbR+hlUs5sUkNLFwl72+jq7p/p6MtpybghTrl26++DANpJIRHphK1VHUrOjZrOk77lBaUWaI+IyhS53BbTqrMdfmP2rWI4W63/Wr/fnWJ039/mwJoV+JrmU1N93xeGa9pIhXL7+11JTSTbPSMAYS1mtfRRJlVcbSOYFt2wp232PlnmbzG2F/6DoSqyZSkCsqaLgIXkPtGW0b6OgOUnkSs0CdOIu51HlfK8HCOb2TdXOBpKQPd//kmSPMPSnWNSxpdiUUiaJcF/MDFnTx/1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 1:01=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm/mglru: single-word handle used in commit Author and
>   Signed-off-by trailer
> --
>
> commit e3df19968a61ac9c4f39eb92e538d862f157c5ad
> Author: lyugaofei <lyugaofei@xiaomi.com>
>
> > mm/mglru: Run aging when pages are rare outside the youngest gen
> >
> > Run aging when the total number of pages outside the youngest
> > generation across both types falls below 1/MAX_NR_GENS of the number
> > of pages in the youngest generation. For extreme swappiness values
> > such as 1 and 200, also consider the balance of the corresponding
> > type.
> >
> > This improves reclaim efficiency, especially at extreme swappiness
> > values, while reducing system time.
> >
> > To avoid the overhead of aging, we only allow imbalance-based aging
> > when the reclaim priority is low enough that we might reclaim the
> > youngest generation.
> >
> > Signed-off-by: lyugaofei <lyugaofei@xiaomi.com>
> > Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>
> [Severity: High]
> The Author header and the first Signed-off-by trailer use the single-word
> handle "lyugaofei" instead of a full real human name, which does not meet
> the Developer's Certificate of Origin requirements in
> Documentation/process/submitting-patches.rst.

Okay, let me change it to

Gaofei Lyu <lyugaofei@xiaomi.com>

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.99=
34-1-baohua@kernel.org?part=3D10

