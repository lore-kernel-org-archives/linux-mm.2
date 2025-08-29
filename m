Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B387BC8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 03:09:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 003D96B0026; Thu, 28 Aug 2025 23:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1DAA6B002C; Thu, 28 Aug 2025 23:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E332F6B002D; Thu, 28 Aug 2025 23:09:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1C476B0026
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 23:09:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 851B6140502
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:09:42 +0000 (UTC)
X-FDA: 83828315004.06.9D05309
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id A86FB1C0003
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:09:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bk8gLTLp;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756436980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ncZ5KmT7quqwzcrHgotoGroXDhrNJBCwwNOtYIhN8/o=;
	b=bMuJZOYvwPF/0b9exlt05cvsr43X4+rB2rd1BK7fpotJI+6rSjtfdop9jzcqKwzbJ4hC5x
	YgGXytbVrB1N88z8NSEKiRhND2AS07uuh1OpW5DnJIzH7FzwPvkvMBUEnEz123MC8TwBJr
	T9Ml9Yi9ZkJwIADLawfUFv9DN/vbibM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bk8gLTLp;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756436980; a=rsa-sha256;
	cv=none;
	b=okG4nZ7ZcgJ12tM8slVqSWBOgf8KCKX2oUUerjAJD7i9rWxAKdEtBP40XK1R5/q7EFDtpn
	n3UFpLBsOe2bb9SyaRraMO5ljB7aDD2ySLeiXjucehBwee7EuEpsbbeDGGRhVssqdtPb+7
	XQU9A5xfdRqrrcJAUzOcsvma8yrUOsE=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-70dfcc589b3so8011816d6.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756436980; x=1757041780; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ncZ5KmT7quqwzcrHgotoGroXDhrNJBCwwNOtYIhN8/o=;
        b=bk8gLTLpi/PcI1I2rTY6LVGNm9ZLmQXn4aDKD1gxxQKHZMwDcm2fhzaLvYFwH0Tgev
         v5zKwvpuxrDtyWtzNB2qLW6STnI2edR5Qo5eOQjTTHTceejOS75xGEr/c3e0d9+GNXWU
         Gjh9OlfDi+Pmqw6/S/iJ1PFXSr10M1tMlVS2ogNh3FsTVxh0liNhOlfWBXX0S0eEp9Xg
         Crqc4JtHxM77fFxjkEzExtxVqEPvIGTL8t1QlRhyrv9w2Y7VIE+W9GJP3c2SgqkJpkwu
         Tx+FOjnuGrUvThcdVu4FeZExt9evELajdVWZrD6/1IA00a6k1y5idTZIUl9+aBGHjV59
         wZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756436980; x=1757041780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ncZ5KmT7quqwzcrHgotoGroXDhrNJBCwwNOtYIhN8/o=;
        b=rQEr/1EPAnea9NkocWmhozpH0DKqBzaLmj/tMQddhT1MCzl9rII6xB/o0sMqSs25qr
         adV4nsiwH2yv/Vx2Wd1GUSCTIZ7+BZcWB+6rGGMbTv1+WH0Jums0GOThnOAF+UGCEKhV
         m6+7ozZS9zOAoaK1eEVs405LewgwrvEA/kOieT8/baxLKR8Vd7rKmqjox7x7esNaJb//
         g87UZQtsON1/dWE/QiGx6N/rlmCxcSbOdAPo+8vQ/EhK9K6AzRo3qP7NqSl2USLUr6MJ
         O63wErnIDsfXOx95wNC1f6bEKhON+P6Z8QE8VmBWSD54yMnx5MetCBur/goKfJqAejh4
         3ciQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzW8poqTQEn+hWk6nHEupnyQ6JIxr4YLURKQFofHvLLKkeHN9/li2XtX2xfAuAQIkk4Ud1ceOXnA==@kvack.org
X-Gm-Message-State: AOJu0YzyDknTODTlkR42TOHYEnIQfZNwUQ7h4wvGEZ99AqqWfvjkrIOc
	61fpQWgR1F5DieqmcoNgv7crxW21SFjyYfRiH6K+uYUHLgKzF6vKVUIf/Q3Zfa08OM7HMYDo1Ug
	E1fcc1EhwuUnXR0dk3xJNsQ2ucE5WrO4=
X-Gm-Gg: ASbGncvvrR9zYY4EEhLSrvYgiKLENE7gfVYKSwxrLN5URia7aTyX5FNCDWIc0Bg44Gc
	7xltCcQSSDY/AW1tBo0/ycmSKzWCDq49wZwS9+oVdhrJtdy56KoCxom+xUZy2a+YFfjU2ikLtAm
	EDKRZB+HAqmQIw6m2UmRJu/pCblTYF6/2AICZwd9aSTAiPrH4OigahPH11pFoRpvyBPg2KECLfe
	mlU3aQqD5yjZftQPzpWUbEPrabvUnDPAARSx6Ne
X-Google-Smtp-Source: AGHT+IEPbm4y7fey1onDhmByGjKxHPo70ZzQZHAm5qmQHVdf90yYBG4ZI4uiojOgTL0GgVXd+t0SBHE6CuokBI95Z6g=
X-Received: by 2002:a05:6214:19c4:b0:70e:86:af3c with SMTP id
 6a1803df08f44-70e0086b42amr23127166d6.57.1756436979724; Thu, 28 Aug 2025
 20:09:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-3-laoar.shao@gmail.com>
 <299e12dc-259b-45c2-8662-2f3863479939@lucifer.local> <CALOAHbAwTZQViuZQZpor9iMHr8w8AvptQTb5TEHrekN6FSjLxw@mail.gmail.com>
 <e3566528-5441-4467-8a3b-4aa52c031984@lucifer.local>
In-Reply-To: <e3566528-5441-4467-8a3b-4aa52c031984@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 29 Aug 2025 11:09:03 +0800
X-Gm-Features: Ac12FXxStXC_AgXwSS5Q3ssoufTvU5oMx-nbH_8R1iTOseNBbytcdMCyoYiAjS8
Message-ID: <CALOAHbDhUsrVxbr8XBD_Gv8ASbKYm+x7w4Vc7hqM01cBRxPHag@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 02/10] mm: thp: add a new kfunc bpf_mm_get_mem_cgroup()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: pwmoyob4d1a4ry38giuy5r4xpi3h66kj
X-Rspam-User: 
X-Rspamd-Queue-Id: A86FB1C0003
X-Rspamd-Server: rspam05
X-HE-Tag: 1756436980-598994
X-HE-Meta: U2FsdGVkX18J0aCPDnfA8Tu1bv7wqIarPANASf2ShgVLhlruVcbhc+zMrxDhO1l2QD6oYNQmibhk1BWCC+bvIjZM8UOA0c1fo7yPH43YARKA2p6Sp1e1Txr0nvlOZ+zOsCGjdCBpJFOUhattd4Zj6EneIjl2Pi4pLMxNH4l3Abd2V3/I0HYGX+ZeAN+Y3lRNli4Utp7ssqHYKGmPpqUstxuKkOuf3O+AWWG7t5IX8UfEppcP1BP0lILzuHTD4ySqKY0IZ0kKGFP58KtJjRGDDLZhtCXUJeIbRn6sUAMe6HrZRfNBhdSgjTiFtGCbYgKgCp6HwTcKPuL6vmMZTEt4zZGlMI7bAEyrca+G87DIPELCTsnjU6eDfcrkl92i3wdSj219SWQpfO9ZcVnpMryty6K3lKYSEzIEuTRQJAGwhSaI0QzDU615tBF/jAph7izddh/BUsOhbu1FEiU96khiiddBFVl35pXhnYcFqShAEJJudgjT6Ve5dQv+Go1T2EWITLpbTQito8nI7jtXrqqlJ87Gfx4ZbvFPPxxz/oekK+r2/i5ctiMPfiFK7Le07N9UzdlHvML/qsUeYYDBgK1KvUdTJZOYeNSHVkafi2u5VnhLtpbHWQrvDc+tXvR03sZscrDOFE3omL90QTjIxACfqfXKlsczmzw5/2iH2CHNQClsrKMWJw+rZ5uRMAy/M34rnqAgBpPoT3LDjf2dWAHQMNPWJKYveORcu9MVpLizQP+tnA1iT4VsmMG7od3CV34vyWQm0T8CsUThuIC5A9o8uoDaTuWhoH1doDqJ4AfW9buHRoUTwSZPVgCByn4tsWpkYlLwVFckeh+eR4cUr5wwsYDPixUdRcZcKiaXzrmODhQBmjAr73kE6bK5QshSX1xIRYAJpd6CmxmX7HbmsXNp+B/eAdqh99CsGCSxTbw2n+U0P7tIpHEDrK3GvSL6kpwdAbRZN49U2sC6glJCXKm
 86hrXC3q
 WtOYHgUAm+p10r/pMAECWYJKOioItQ9mc1wsdns//1YU9uFdWbh1ZVsmIEpLMU40MxOxaJqFmyf5G5VBmB2H6hg0EQqUrsA/T4+FOIfFPJDl8JrXft1RUOEKczInA6uoLGHSDRrbzvK/u/MfxJrN4gieL7ym7CUoSIN2LAEsW3hrhBanMS8kN7F3N6LXQPkI/txxNrm1tDDdg1PxQKzLntvWNz3r7EvfhlWeJPtUQ3w1/R+N9JV60gOXCapaAkJqOLmw3qGx3EjF/r9H1yFnyUdayOvX/srusuPuuEuWtrA5V6LWIvHJc2oOaJeX9YFm1hZ7ckbtwLirt9U9pFm94J+HSCv8Afghmuo0aBfFwr/F1+Wz8yh/xD8tClgxRVWNM9YDAcH4jmFbxTd1jh6/i8BoZza/T86GPwt9/RCcUL/zGPN5DLO3aVOuOXm9UjqKH7RUCq6M7hOSANv0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 6:42=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Aug 28, 2025 at 02:57:03PM +0800, Yafang Shao wrote:
> > On Wed, Aug 27, 2025 at 11:34=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > +cc cgroup people, please do include them on this stuff.
> >
> > sure.
>
> Be good to cc on future respins for the whole series also! :) just so eve=
rybody
> is in the loop, thanks!

Thanks for the reminder. I'll include them in the next version.

--=20
Regards
Yafang

