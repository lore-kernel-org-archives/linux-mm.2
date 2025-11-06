Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA512CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 00:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0FC8E0009; Wed,  5 Nov 2025 19:39:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291A58E0002; Wed,  5 Nov 2025 19:39:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7A88E0009; Wed,  5 Nov 2025 19:39:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 08A2C8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:39:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AF8588CD5
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 00:39:52 +0000 (UTC)
X-FDA: 84078324624.30.3305B02
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id B062C4000C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 00:39:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lF87Buyf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762389590; a=rsa-sha256;
	cv=none;
	b=QSeMeGsoca+yCbb0JXb+pZErl8fwvp6aj52xhru6ECPRK0ZVEoz5R7xNmgwOtqYwEeQW8Q
	c6Yq/XmoVjOsUhRIiAJa9aCZGXc3oIExu3fxwBOzTLGtXMTAiW1cl193/Ue2tiskHKa+ho
	jdW8Zac958fzvLg8pdyayfvA/obJQn4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lF87Buyf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762389590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qB7xEdpyB1NMalXP1PSx/JV/NVaBw6TXvhQyAEW2AwA=;
	b=ZGXa4fcY72LExASlfAxdVa7cOpdU0DUa83wWJ3sgwJEx6qDIvkDwpVH4JnW/e0q6zViloH
	8e8Wen23wa/wjK5oRJHbVTSoq31L9zAf/NCn2j3KfwIA46uanq90ql75qIx5tr/seZDN/e
	va7nUr27WZ9b08V0mkOl1GOv7cyWZ+o=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ea12242d2eso77981cf.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 16:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762389590; x=1762994390; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qB7xEdpyB1NMalXP1PSx/JV/NVaBw6TXvhQyAEW2AwA=;
        b=lF87BuyfrRSOOnudNqIoCtqe5nwJaTN3MvUH+hAnHrv7PrKmsiJ44tgcziM3c+/gue
         yXDjxh5AKksmK1GacHWq6AWbKMyhUCIMSiVWmY9WGfXuX+sDB89fcGJ1Anpdv5V8pTmY
         mNj+wdUxvSQKCd5nkhMGNh8kB4Do4e8LDyFQwi+92Ql/5Qcz1CPQjw332moFTzP0X+sq
         ty+mQs2UObG4gyX2OXTXlV1zpyFN4VYpk+x8Lme2jHhzxqVVthpt24deqf7LTtisbHJF
         TCv+ofxfSBLioJ6byVPQ9E+ntcbOmzj62uaMBAXDhTNcu8yo9/FAfon5cXYzqh+xOnM7
         5Lig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762389590; x=1762994390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qB7xEdpyB1NMalXP1PSx/JV/NVaBw6TXvhQyAEW2AwA=;
        b=oWn6u3jFGSMfTBi80c8Cn86djZOw2mVMykhGuAisi1dDf8xtkX9aSi7iyB62b4aly0
         lJw6nLruXNK4DfuUeLQUMV2z4+v2t23UQH1YnkxH/UfhYx8AMRejV7+jgJuHCZm8V7OH
         xsOUXpU3ZWn501KCriJMtOSkSvJBW04heJH7Kglr3z96tdwNAnOo+R+/4SAax92vVnMP
         rvM0kZSu24Zekdqwu2AUFAAKnxi4ksJcdaL5+1/ElaV+JragpoxQ78++pOTVazf41ZhX
         nedFUpLgpZyAN/lAHic8TM6ST9Vacef1JxVsi3w2VO3TRDY9uAnkTkgjaj6TLLk9URq5
         iq8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWd8Ad6xH7LEJT0RilN9D94Dx0sOJRKFqft3yk3NwIlS4wopxtr9jP7ExBwnpcjI4+M7GH5W/BJDg==@kvack.org
X-Gm-Message-State: AOJu0Yx4GzZY0IBdbj3v1UFM6mmj2Bnw00W6u9NuvybMrdZMKSAuDkRH
	k+Wl3E/HGDbTLfnq9pYiDr4Eq7fncZmuUnoBtiJgR5YANVQm+DNIq8ame/0vjmR2rp372841I1h
	oy/ESnPfYLWBzd3XgoHyQMuZ9pIG++YCjg5Kf6VGk
X-Gm-Gg: ASbGnctOiRYG5hX+8ENmLi6XJ4LOpzlTK7v7MuSwabzn7m2lHLWp7QZxeNHYy6eDmyc
	SXIclMv38LbnUVJXtN8UGGVY5fhhJAFV6WJEs0gPrRWl9k/YhoE9XgMPhY398v0Fc6vyFQqbGEk
	wX+Wvf6Kyx1arQpy3VPYp9pMnIMrxmKIZqFza8ndyKkZ+xCfuwIAIjI65FSVBqs2+N7g5hiLuaA
	RQuhQJ+AgXing9JDwU0qTgmshwD3IkxHqlS+RPCdQ9G2zVHeYAhurOF4u3zs5vXxV87YQ==
X-Google-Smtp-Source: AGHT+IESxNu3DCWnIGyPrBib8D8gpFaENt4OMOL4jxhrw506aLjvpEZ9DVEQvAJ2a/G1nvaS2hjdXcVDTuDbokSzSsg=
X-Received: by 2002:a05:622a:5c9:b0:4b7:9b06:ca9f with SMTP id
 d75a77b69052e-4ed813f6bf8mr2933461cf.2.1762389589412; Wed, 05 Nov 2025
 16:39:49 -0800 (PST)
MIME-Version: 1.0
References: <20251105023925.1447482-1-zeng_chi911@163.com> <20251105044715.71861-1-sj@kernel.org>
In-Reply-To: <20251105044715.71861-1-sj@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 5 Nov 2025 16:39:37 -0800
X-Gm-Features: AWmQ_bn0SXD9jGQRU8p3H2zsdC-whATeFwUjvsd9nXkwe4AS233yuHUdZlfz2Y0
Message-ID: <CAJuCfpEyz6bbPa76fawWbAW=Wj6qDxo8v+RftYCMxE3iiGVdBQ@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: Use %pe format specifier
To: SeongJae Park <sj@kernel.org>
Cc: zeng_chi911@163.com, akpm@linux-foundation.org, kent.overstreet@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, zengchi@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B062C4000C
X-Stat-Signature: tpi6fz17fmd8jiaigpd7fr1u95cpre4p
X-HE-Tag: 1762389590-111395
X-HE-Meta: U2FsdGVkX191zGHMDCW8x9tBQjIKnhkxyuVPhispAIvxacwwU4o0p0qatBYXP8CCX/ybtHaYRcaeJbPALX7u1DtqTepI56tQObfKHdhiXd7ip2+UrncWdphUTVUJmHV394tpqD7BabH0J8sPcMe5d8uBSuJgRJKVVRzMjyL9X3tEd7qsvR+HVGueGEwiZ1NoQvrhlAFyL3sXKkQUCwn8npN8BntlCPq8cksF3W4yowZJGZYF2/98q7npfbMCLxeZGhrnGSkTXe/wD68ygTzAR3tWAcwUXtZlyn1agDQPLrGcCBqp/DqM1UiW6/PX8H/DDdRs47Pomi6hiBaVqTX6D73cTUWY9t2YZ/xa6o4S5M51L7vqdRNhaRz6snA054UwpQPWYtrAuKK86HubR3eKiu9eVjUktmW8CqGRJpT4bmrbFCuWz4/q6+SNOv3QYI7aO7+haqTi7EVZeKCy37XgRIeYCwzaH1l45XFMb+CfzpvmjS6XxUHIe1oBImUhqVjNtF18iTod6h6W5rmtQ52IWqQyLF9kfK7GFV8guuwvcFY6FmqpVB7Ug1hj8/x18yc3ggSvo0iiOa0wrcYUGdKKEaow6Xv6qbzyDozgRjJna84ZWSyUL5AaYU4Ou9xOBHAHdFR7nxos6G7TN2DclB1Zcwy+8twL8ghwIm+8GyQGJLalNuyLChWKC+CIw+BiX4rBeNF6n6iMPjaPDM+0hL347W4f9Dul9ei/J8aZpCUjOGyQBryurvmApBYJHfgphFiw2IJ+GiCSVu+HtE9EFtNSI+GNmwcRib3xXG3/FbH36Cdqz+Ml5HmM/8GiHBEAuDR75UWmrDRn8BG7wioymCPd34c+Flr+5ADnCIOuxUGeEsV18KLl1rlu+C39jqY0WERkhSpOZgt9yDaPR8KAUVW/MGKEkovqvTbNemm02Qp7oMaRfbuu5AVHUy420kFlJJRepa5ztrcm3V0KQ71vTba
 22QSPIFR
 F98H6xNs2bhvwKcQ70OXBuM10AuSiAS59mjPN07sZEkdjqyHut/HQr1ZJ3S+1BACapOmgqMy024la0Q6wN6VjBMDUIpG50dcp7puX2bg/Sf4tF+Wloz2QSOXMxvGDf4+3hMIQ4jEf0dinWeXU8KAFtIRRwHzJhpEWD577eHORkdjbPcNJYfdK8xy6hhaakhyzraSCI/IGGVvQj3fFnZNWtxVLkR4G4ngxhN5oWca1d0nQkTJ3AlkYwEuE+JTJu/CFedMqOCPtjhaAg1iRLVZbN1w+r9PkzTChu+Kyy4i6P9UiN7pG8h4aDTtysg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 8:47=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
> On Wed,  5 Nov 2025 10:39:25 +0800 zeng_chi911@163.com wrote:
>
> > From: Zeng Chi <zengchi@kylinos.cn>
> >
> > The %pe format specifier is designed to print error pointers. It prints
> > a symbolic error name (eg. -EINVAL) and it makes the code simpler by
> > omitting PTR_ERR();
> >
> > This patch fixes this cocci report:
> > lib/alloc_tag.c:776:63-70: WARNING: Consider using %pe to print PTR_ERR=
()
> >
> > Signed-off-by: Zeng Chi <zengchi@kylinos.cn>
>
> Acked-by: SeongJae Park <sj@kernel.org>

Acked-by: Suren Baghdasaryan <surenb@google.com>

>
>
> Thanks,
> SJ
>
> [...]

