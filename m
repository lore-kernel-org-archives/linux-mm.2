Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54DC3D6ACF0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:46:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE9B6B008C; Thu, 18 Dec 2025 06:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97E6F6B0092; Thu, 18 Dec 2025 06:46:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822F66B0093; Thu, 18 Dec 2025 06:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73E8D6B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:46:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0156DC11A2
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:46:06 +0000 (UTC)
X-FDA: 84232413174.23.F360ECE
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1EFB61C0005
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:46:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LnP18GIQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766058365; a=rsa-sha256;
	cv=none;
	b=z04UtTx0u1MLHFdqmP2gM8DY7z6+Rk6bEyXgqGIacmiS2BJ/BrKEl0FeAsNgRqkTUWZL5F
	Tl38lG5g9RDd3Ad6a7S0Fz9yve2hc8qOUkNN3DRJOHSCr9u/ImCdn6MhhvC4cs4ZUxppPR
	tseayd9kZe7N5JtRGXikqHNjWMI3+6I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LnP18GIQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of pilgrimtao@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=pilgrimtao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766058365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1IZn9sTa7c3lv2AGukKMMHC7g199ZBSIk2OztX1p5Dc=;
	b=YHLnigp0/m/USrrj6Fe4v6w0pXtQGqOM4ko+JyQWsLcdIOtvEhBr2teWR9BGfVNbcEEt8D
	BhMET++OS4/Ou+E2ttN3y1ILrq42VWuSXN3eaAFASXihMbDe76BNe7JlPZSVPnLn1dmndI
	XGeh9fA3IS16pXpwa826AWkMUjaoEsQ=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34c3cb504efso576618a91.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766058364; x=1766663164; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1IZn9sTa7c3lv2AGukKMMHC7g199ZBSIk2OztX1p5Dc=;
        b=LnP18GIQegM721gdie8rTA1wZRc0NYCEAuyEBS67GZn/3v90eW/inGWX7fu60EuCyw
         3q/xgZhR1Sb9I6pWE0t2CUmWlyYquhwg2pF6liWBffNkpfcCuIFjBKhQ2VafKsG2fudR
         19ycjAL9x3dYa4FTAc2kgg4pcW/c9PCC9wcxQMZCT3u9knc0irU7Kkfp+DTm/KM2+7mZ
         ghuK+uxf3caNaXd2y+9RSBmsOfwvva9YJEkZm+S57FB1v3oMNPiC2l+sadSezUSEe1vx
         Mz7y0kFlAHrcPOPrC3394ALhIILutWMtx3A4uGos35cr0SkrGyPZDy58xRJn/jQz87Mi
         TW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766058364; x=1766663164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1IZn9sTa7c3lv2AGukKMMHC7g199ZBSIk2OztX1p5Dc=;
        b=VwAu3VCfgJK0/lJR4pYg5j487RF8kuL6pjda83Vo1pMPziMCq/iff9bxEOSNv/r9s8
         k3M4cbBRoi/f2abbQR71CZNLSx4t6GDZLXbvE3jsM4ZtlWp8C+6PUv5ktKie95CeBzjc
         D+/djtOIWWmKLUgpAuA9gFMZthhZVjZCcepZKdfi+azczT4HzPMqVB/b0SN8++ouNVBC
         bPY9t3vCERHkjZeNPXoMHCqN8Sk54oMK987t+xOzBOde0mR3lujZQ+Rnw3Ew9BQBZEex
         jICnZ99fJqMtI3zI1dkYARPHyhzU82Iu2o+r7DjdODzo+frR/uyfIKJPwDPFpv2HoYYF
         EVfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVbO228arPbrhlAc00PHeH7ODq8PnYfC0YaUf1ifp4rquKXKIeCSgVQY4Iskp5QxYCl0Ar/k0zjrQ==@kvack.org
X-Gm-Message-State: AOJu0YzU39eajXxQLMT9kplZ2r9zV9Xs9Vi86WE5tCpkGP0+bR0diMOd
	z0qDHjWv/J1Gjh+AUxOogU/4KlcE47UHZcnMjK2GShezEeNn4imh+9WBhqXfEfWpM6Cwq6Q1Vkz
	3pDcXGOV3UTrTx37KN9GoeVPE5rL1ObQ=
X-Gm-Gg: AY/fxX5bpKHfJU5U0t+SOtPQNjTwznN1cSRpvgIo+TgIxgruWjUI+XTVCQAIwnEZnMA
	HHhhsOFJK5EC02dksdj4i0dAUqvbFzmBMVo+D1doEnmJDUCjrhpWZSl9soM6l7j4m87+fQkS8Og
	gy+GwI5neMAxDt9XI3jinJ+749PySf7gsYZVNc/nCLNCequn7v61W67ypG5vJ2rGNsHqL3ZzfjG
	FAsAgqMaZQoBAl4uknONOV3wYJ/eyOqKArF4adqxNnVrhoPXRcbAp2EawOcpnjnIpKiyA==
X-Google-Smtp-Source: AGHT+IEvF1KBiCCd13SNnZh9nGwSbCfJXkC7JARZp2pD1vme5z96PC3eWOuC4uYYsxgFL4v1STQ3q4UOVbVFIF1Idp8=
X-Received: by 2002:a17:90a:fc47:b0:338:3d07:5174 with SMTP id
 98e67ed59e1d1-34abd6b5d0cmr16492807a91.5.1766058363931; Thu, 18 Dec 2025
 03:46:03 -0800 (PST)
MIME-Version: 1.0
References: <20251217120858.18713-1-pilgrimtao@gmail.com> <aUPiFbuaglcjqiB1@kernel.org>
In-Reply-To: <aUPiFbuaglcjqiB1@kernel.org>
From: Tao pilgrim <pilgrimtao@gmail.com>
Date: Thu, 18 Dec 2025 19:45:52 +0800
X-Gm-Features: AQt7F2oFJjE5kIHB1KINR0FTWOfFtI5SPHyYbe5RtYRwej8-SfnmNij2BqSQqR8
Message-ID: <CAAWJmAaxtKY50BEm3N8V1QTwpyCgQLfLFarrVfPVVpXg9ftmcw@mail.gmail.com>
Subject: Re: [PATCH] sparc: Use vmemmap_populate_hugepages for vmemmap_populate
To: Mike Rapoport <rppt@kernel.org>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org, 
	david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com, kevin.brodsky@arm.com, 
	dave.hansen@linux.intel.com, ziy@nvidia.com, chengkaitao@kylinos.cn, 
	willy@infradead.org, zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1EFB61C0005
X-Stat-Signature: 19x14cq3wmkaffyqy8b68qnkzhj5s8tf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766058364-595641
X-HE-Meta: U2FsdGVkX19xTg7452RKNNt37ejnNwJhwgklGnsXmaFXitvpKEAUUSfBZEHjVVJ2MIRFoHXdLldj9XZNmGMPph1DElGu/9Q/zpxnpCDPRcVs9pBCeva53+B9DmZp4yisBkyNPzLXHaUunZokEBl1yU01TZSfxvbb4PmpzmbsHBDFtn/79A+fUmrebLAcooQQ/oubdzsfkxrCkK2miFX4l/LgrX4bLNhkYDBbawrdzgsDwJG9BjwhxMwX0hHbKp6wW8sZij4hrcB5cT/4wYMrIq/XH3YSYCilHi416GQ66cxTk19AMm5AV0MEUBXczXQ4Bz12ZSW6LK+xhn+A8XBklyhz+jTimOsagS2ijIpzCuwviDGOKaRSQnV7QGoqaS/0cw4KV7L2gTXwqj/RnuJvoU+sogWz6rbK/NQDqEMoVNqddqB/0u9HsBDuLf9SsyKJJQGAOztj762Je+o5FWdbNnyEFwRpznOAOSlG4345zLZErC2tQFd8Nv4ksXEeoUGydC2pGCxLyX5FnNZ7WrGou0ChATJFmLND8Wp9ZWEZjA8PrhcLetnSe+BcdiH1iV4P02YGIZnRT1asJJ6X/fdNPADyzJYGcXslx99yZ8JJRNKYnOi60QMvGTWbnifk1WvOBGRcAVAU/Y8Kb8vpOBTe1Trqf5WifPTjKe7MPCWVs0aH5+t97fnTIFOFRS1x9IO6BkSlvjOSEyqHNiHytYK4egW05plARv2VlQcD7EI/oOge697FWt+HHbMicTZbzJxiLswoi/HLMEi8v+rwA1UNzIpCLwoDDe/q+SAKMIWIkUk7lFubVcCtgafKa0U3OsQtxn408thGygMzxk/CYOwG1rOvxRMZbAMYftmB4jLDBtdPYLh80vsg7wVH1TgpAnvzziR1Ot/eLV2iSMYUEY6b8jzQjEZHgaRfXhIjm0uxZwQk0JOjMwmnVxDkkfRLk0KxJ5R8l3fwaxf7zmKFHKH
 BDz0UyeH
 rMs8SqjTa+TS06Xjpsb1BqItynlEudKYfTAQNPi+aHjEo5pU4bgRUv2SsF7dz7qpU3Ry4r6I1BdypDBwhEZcnfslF5Mzr9okRy1pDKVhznu8inSx3yEgM9rx3wRZDkWWb9qAolADgmYr+mI3JMc0Kl4rJV5DwwJZgyWyDlylH1fXjgGZDBa7gNMy5RPsC/mePZbiHTrrlwxJ/0UsIA9mBIl1EdCxpToXXJUTgVG9OeWBUZwSHAG7XU0te5cOrtgZcKcfT1TNbnfjb1NuZXGKpTt+wcqw9v2a4MgMPGAQ/AIITCfnMJcwYUY+8emRWvKkppQg8BrBpvMsUV0Jq7/gQcZ5Otuo4QaYDtB3JZlu4T8KvHAj7LiOtfOb4DUobfrtvSq52aKvcjJ+hoKzOb0OvzKMQvbJo+etbQr355xrpAb8bE24=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 7:14=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Wed, Dec 17, 2025 at 08:08:58PM +0800, chengkaitao wrote:
> > From: Chengkaitao <chengkaitao@kylinos.cn>
> >
> > 1. Added the vmemmap_false_pmd function to accommodate architectures
> > that do not support basepages.
> > 2. In the SPARC architecture, reimplemented vmemmap_populate using
> > vmemmap_populate_hugepages.
>
> What problem this patch is trying to solve?

Following the pattern established by other architectures, vmemmap_populate
is reimplemented using vmemmap_populate_hugepages in the SPARC architecture=
,
which fulfills the intended purpose of vmemmap_populate_hugepages.

The functional logic remains unchanged.

> > Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> > ---

--=20
Yours,
Kaitao Cheng

