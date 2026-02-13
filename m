Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56546EF48CB
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 03:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 040076B0005; Thu, 12 Feb 2026 22:51:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F04BE6B0089; Thu, 12 Feb 2026 22:51:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE68E6B008A; Thu, 12 Feb 2026 22:51:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C9A916B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 22:51:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65A37587C4
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 03:51:46 +0000 (UTC)
X-FDA: 84438059412.01.E553F9F
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 71F501C0006
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 03:51:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DwoGt+Cg;
	spf=pass (imf18.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770954704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ur79wVvacYtOc72pTo+eN2J7QrUaGisXZvJ5nNflJAM=;
	b=zPDtt2gPMwvEIMoCb/5GMd3covRuJVKrbj18j/+IYjERexSOPrFGMU/4KRP/+6rmcjoyj4
	jf5dQQ4pxWOBE0lh8hf/gnheTxHZrCFq5a3tpzlEgmOwbugJLGBosiaxKCqQ7ZuApXS+za
	fLfQ7GqqpoYx+DM0FZg+X3ZCuuihkyg=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DwoGt+Cg;
	spf=pass (imf18.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770954704; a=rsa-sha256;
	cv=pass;
	b=4Z5MuhJVnHnOwDsgB9Y2TeXnF4GfmDxvIXcIqN6SO+nUHWiNQbUkw/JkUJ+ADcCloxeP2f
	CqOkQ/jl9JbVQ+JNVT0hcVt5MYx7Jweamz8y9Tvk9q5oLO4VYR7BKFgNpWwZfYBCfXb7ZP
	v4mSmHeASlaYR2q2xK9JIqWr5umW57k=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-506989e8516so4946421cf.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:51:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770954703; cv=none;
        d=google.com; s=arc-20240605;
        b=K5tVFtIr6AoUafZAkzpanc7k7s8DtA2/7xPSTDCI3OgZlj+8Jf8cv2AA6nuvgSffyx
         jreLYAkgebYpzWO+cb6IfkEddpiQJBbolBvIlARnCDkqmaSEaQFySMUCggfw9MKkZi7m
         69mwu36LLqhSklvCRr2HiJpkaqkuH082vbr7lFNxlsAFJAvwrlwcNm+s5mN50F/wsaap
         /fwA9Qf4EIy/U8jHMfujAwPBlzvMFRP0qyr/129Jnjaj8DfalloWe3BN2QqLKK6krgLR
         I0Cr8GgPSKAaVnVL4WyxoRC3OzgjjJMnvaHcH2WlxQeyYquY4WIgVAuPdN/lGRzWDZ8l
         08mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ur79wVvacYtOc72pTo+eN2J7QrUaGisXZvJ5nNflJAM=;
        fh=ACfTRHleBqgLJ24pQy7UYWiyvRn3yyDhGYASp8cfj5U=;
        b=TgD30/gY0UbE9S6wdmm39MQiNR1Vic75boUf9ESvA1w5r97Tj/c6u/fP32L1RRrfrE
         bxA1Q0mEszQNXCmbQY/DT4wX9FCuIxDJDkjWEOpatnTemnmnNTCc3XMzwdaiQKb2JAHH
         8Ft2c19b3DxEl5LQ2HxVKu+Li3N2amHYRPORIWzZWa8Djf5VU0XXBDc6Bgm0oShDJtmd
         /AJ4dx3rQnJ/WYTei8rkT5YV7+gd5zfqakThh/vddJ2IZ6jbPlqJ8cA58b+4dol84WMx
         RWFchGmGhMOokY8k+Zu/bVmSI5LQl3Qi4LeplF4Xcd+ds7mw0iJXP2OfPvGOIImEHbDG
         077A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770954703; x=1771559503; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ur79wVvacYtOc72pTo+eN2J7QrUaGisXZvJ5nNflJAM=;
        b=DwoGt+CgGeFfmlQqlSycMahDh42ImcVR6Tqe7HfZOjQJDdzKXQCu/aOVd8UcMlisox
         SG6qjVMul1XW/MSQN4M5L6a+5Sk8KG140DtgmJyzBAOdGpMvZbq9Idi0rgc+fbqJJlXY
         lrOfOehQ1EOPIlc2W0vCfGq9EvrQulzoHQxckkF73wqVl0QqbFMu4FSXD0EiT/sZwtKi
         M2idOh7wRWmrZYDNoinNfKJKhRJHLktlXoepAz5CERJ0rqnAHXyOpO3mbq63wN5hDSZd
         Db6ZgFmEOYdmQs8btTRaOsXwNBiRxXLqj7x5zrJHcbn58xJDA5f5azXs7LviI+cp3sKC
         hI2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770954703; x=1771559503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ur79wVvacYtOc72pTo+eN2J7QrUaGisXZvJ5nNflJAM=;
        b=iuSK73ekAPt11FXh5djAfDx6g4JzzEXZP1ySkuSENBny5YiG3zHgplQRj5ZiGa/I2h
         kaX5rb42/v+1PRBRC6coiOeJ5LtsQyT8I0BvjchlPI9+BrRnMvxzVEtHgM1wAaTsvokO
         yawzSIEOVqH+dwlDl/05mdxV/nQby28hXfGGLXCrCRwlzIaBYJ7TmxxH/hm5Xyw7GcCa
         yFo83RNHjUtbHFhpCVped/Tc17zqVcDq4WW+DTGyPDfbKzqm+sxU0IRDRDGmXYk7Vt7i
         1WbHafARKpXARZWn4vSZ6gMkr1YYMPDJvLwQ3DzGLij9WRkP2Yg+9bvG27poNGgpmnG6
         8/kw==
X-Forwarded-Encrypted: i=1; AJvYcCXdxeduBd0SPV0DJyutNAkfbgaWEzC6gjK/xN5NfkRoxBh6S8YNG7FVmo+yy1bmqDGVOlE4JkvGcQ==@kvack.org
X-Gm-Message-State: AOJu0YwQhO8Al26ojl8X71JQgbgzdNfQXnx5hajOax0o2HlbUdsMshL8
	ZinTyOLQH0q2PyTFgIJcUQScJCx4Ct0PHdOxAcLPU8O1KxgiYqe6IEEF9kOHRLUem9Ux/tk3s9F
	maGcTdZWf8iE1h+N1hPQjZhDRdzUwFGo=
X-Gm-Gg: AZuq6aIrNlb4X6L5z88AsRILZdWfEhvMtigUnGi090LUKxThos0wbuPR8kd7AYm04El
	0SkQLjskkfJFPSZxa7l5A3yhm4D8clusEyp/OHTsdkp40hbDXphHzQieAESvE/DyzuveKnGRQhu
	mg+YLF3o+/KuTtxF3G59pHMayRrRajg01wNg+sm9oHmGGwQjZ4VVAFqNZ23osrllv2+YRfneh2H
	WgfW/xhSZLhuVLFpe48dBBG9tOR1R/I3l8/vm1QhmUpHQa57QkRp8oaYSDRQ8c4S+AYVrEhKh1p
	MTy3FQ==
X-Received: by 2002:a05:622a:507:b0:505:e9fc:2f0d with SMTP id
 d75a77b69052e-506a836fd23mr7042561cf.66.1770954703268; Thu, 12 Feb 2026
 19:51:43 -0800 (PST)
MIME-Version: 1.0
References: <20260212021835.17755-1-npache@redhat.com> <20260212021835.17755-3-npache@redhat.com>
In-Reply-To: <20260212021835.17755-3-npache@redhat.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 13 Feb 2026 11:51:32 +0800
X-Gm-Features: AZwV_QjEFQ9Vkh76on9P-JoHsGsMdhw1n-e21JWVj-0EoHb0mB-c4qDN_bdcHT4
Message-ID: <CAGsJ_4zyGq-Gg-fO059U98J+cAWFV2Tsq+Azra_hVJ3yvUV07w@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/5] mm: introduce is_pmd_order helper
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, 
	cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 71F501C0006
X-Stat-Signature: jyeopmuxhjp5kqmy7md98n7q3s3qro6g
X-Rspam-User: 
X-HE-Tag: 1770954704-519199
X-HE-Meta: U2FsdGVkX1/ZnyrB0DO1momeQavByiMteJP2YawQotB/Zr5HjoypSmPP7kK+NfomvJuInL9Iq2IOAumnh5Ta5LH5EiSZ6iak9GUpGbNmdEMi1A5FB0UFtGeGGLs9s6eg8ekFCcr/SGcXSOR07y/6tUhXknEy3adRp0Cw1//qcSR1UKVIFJlZKah4qDnm9108sBbMB9SdEwVKlUpyfnhW8gfS44n1ouXx4halmAiSgoihehlVmSPBKgUNWxosFCwNoZuPMY0k9jEEz/Ho2WTjZTFiV3EYs2Ycmwn/G0W7oko4gx6m9HqdY3DLW/55WblrN/6I28ckel1BV03eOXEKUzvTkvDya/WYJbYqkb2v1BvVBygIn4TVEuUY12YahnfBNCgRff/LHk87kEIqwdaffrxwqCoUG6OAsoAF4sjWH69y2UkLb7wfPFiHUjdEwIt+66Dk0QJMd+P3h0OfQVbAxDROCgCwEnmUvWUHV/dDyWaoNbhd5Hp6vyvOsAwQebIs9Ggt5BRB+1JHRLfGE6hzCbGtIBSnCcgPZNE5F3DiO1Tz+e21tuAm1c5su49UMENxbs2lwB0Wk1mmhg4dbgt6fU9N6FuQ+mXoSJ/rxaT596/F4LAbdCIiFBEDL1bT6wPsHMAOYAs7KiBlb5/KQ3CDCPEJ4OkWmckTxKzHDhN8jPoN2g5mLf6M/W9bFe4xGvJf2baEYeqsBJXBkOXSrqwOs+sHqcAv4sVZM+t21zSBXNVq6xz1Mizbcoj21hcHYnhGGLshdJiBOAjKH3CYadcD18Qdl9ZtgGP0rQAObDfldhQqFRh2bbH8BE0TUzgEqsCOQ2MwVKeRaP9VKGeKD37F2TjkxIvc1lwmlf3RLFBPFAozCPTbbFWCYjRQL8c+nFZzEfq1VUGF+AIaIzF3I3Csi3Nlia0io1qoIBvCNpKFwk311DxFzQJGgvkvmQg1BuQblHGmgr6paqg8ZoEJZia
 SiFbFc8p
 JR0i5sFkUiA5DuENg2jQGtsg2IzSD7qKKoFsWMr/wTj3os0wkxXUn5r8rB5+ClWgCSMZsmbRIe+0sMEwqULGIElmovo3677iC486LW0BxUp8nAXSwrMUve0ubJJ+unVie54BFxUwY8DJEV2tyr3AeidINcwf78wqq6cKBIiXLCXO7cIgm7U989joirbhIPaJ5sSp6zEggMMTTJY3W7iHO96uUcmSjBv0b3YY370wMSKGPgXpDSQDi9nefPuQEPmMZZ4kEtDD82j0jZ6ybFuiTjPhTiCeM9Zo5naLzZnPc4ahXEavQXRjTvFirqVU00chxcTF4RxIAwByLW9d5b2Q5O9GKBVOKWOl52sE+DqwSTAx58D/s4ogo/hUPDkjLqC/8nCE6xV1N9KkaGp+iFDH6DUcqvSVLX17nxK8oej2r3n3DyAzu3B4/qFxNWbLdl7F+T/bQf1eYAZdyQjs+GYvxklD5xM7RHAR6Mwhgu3b+gKDo+LlnvhMSeflgpSKL7pYDUGCBOfVUxDPPNmH/gmAw+xcxdOTWPW8+LoXv9N11+v2eUHRJOOKLNTbFfSr70nSeS3IC4ETPa4yFXQ/+AOfDR4sgHgJUtjDdx97bFNPw9Q/E3uM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 10:19=E2=80=AFAM Nico Pache <npache@redhat.com> wro=
te:
>
> In order to add mTHP support to khugepaged, we will often be checking if =
a
> given order is (or is not) a PMD order. Some places in the kernel already
> use this check, so lets create a simple helper function to keep the code
> clean and readable.
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

