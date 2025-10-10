Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40103CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 21:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4318E0014; Fri, 10 Oct 2025 17:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB7D8E0002; Fri, 10 Oct 2025 17:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8588E0014; Fri, 10 Oct 2025 17:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF4D8E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 17:43:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F33E316047E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 21:43:07 +0000 (UTC)
X-FDA: 83983530414.27.829895B
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 20F67A000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 21:43:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=E3vZDXs3;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.166.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760132586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTEdXIM9TCGjTEQmnu4q5KwtmIgjop26pFrSD5vSjaM=;
	b=OdqTxySXH22MNZVEtcziHYtiJuZYU3b8YwVeXLrHXiKzWLKZ8wneJpdiBxH1mQQ+5WhyJi
	60rfGeW6ekEjYP7EvJFx3/P1ERJ1FkKFT8+fmYLaTHHHnXQguo+80yRVH9rXGMUUB3zxKT
	cfn+7YepQxSl9zqEPNgGoFvD+zrAyZI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=E3vZDXs3;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.166.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760132586; a=rsa-sha256;
	cv=none;
	b=oDUMhDOgAK3iwc/a0dQK3366DedI+kZnMDz6+mGxdu5XvJbdJVwWrYLV5yhSfhTU3xvGNJ
	Ljm9Ht5aaQPDfYIsm1HPxRpgcb7nP0j0z7DkCBB6rrSOR/OXDxg/IepHFjULrx9ccgwbY1
	ekFl9YcD7jz4ArWxI6f0s8V2noCFaJE=
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-42f8e736ecaso175525ab.0
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760132585; x=1760737385; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTEdXIM9TCGjTEQmnu4q5KwtmIgjop26pFrSD5vSjaM=;
        b=E3vZDXs3qfhtw02Ljn4y1eUfuVpHKypHof208K/5/vFlffbTVlJjHbGSUyv0HwqIXr
         YEqwL9Q31GmgsgxjQ/wtbC/+Zovs3wh/m28+fw6A+rLGAoAcyxC9xDv4juF5B1qdMOp/
         UsZixnS2ikHJ8JhMwONQThtApIeTuuXnHP0smoPkZ6JlWtMdyYINpI8njngPg5O1YTr9
         C6qq26uZBHm7R5q0hr9ut3ptTO7EFptIdlJ+B4pgpzAxeyAIwmxwWeRJ43X8Y/UGDGNF
         EEc/zjXeRawp8pEGbX1BDA83G6MD04x8QzsI7LvBSpmBQFVawdKoXlHmmVImU8fiRI8F
         I/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760132585; x=1760737385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zTEdXIM9TCGjTEQmnu4q5KwtmIgjop26pFrSD5vSjaM=;
        b=NISDFOxDh8iIE8JkPnXO4yKYok92D6npqDuiqWjY6zeSOuJc9sixZ339ZtZ29kDCfx
         i93Utew93MI+CISX03TXzqfPSGYLcBb6H8ElbbXNWO+LIYvtmRoAC4OmmvDEyfUrIJ0H
         Jm0oWlFuFzr4O1wx11psZHFdMAaf6rOYieW2D5DywaiOKhe13ezPk8tyVL7VWglQH9hg
         r8CYuaTqHIqNcEA/SJNJdOnkIIFQzGrnYBxduhuWxnMz9H0X6cW79h9gdmGi0DjK5Fz3
         PqZE4mhRZud5/UAbJngDoKZOwSj4De6dhjQNt1e218j+ZMZhrOzuwhTXWTOT8N869XAr
         Hm7w==
X-Forwarded-Encrypted: i=1; AJvYcCWCJMGL6f1BCCsHkbqShJMu5FuG0MZ6GnB/ZabT74oRgf79k2Mv/72Zxe0XDVqzKQ8I+Jbe2yuA4g==@kvack.org
X-Gm-Message-State: AOJu0Yyh6Ams/m9s9IJdL+APJYAe1v0oz0/RSsCpapfOP9id7rIkzdUy
	QglwU6W4WzQ0sYNj7ROJ4tjSIi2HazHqgn2lQ0xY4yTvR44oMdY01KIYUDixpSCjkZExBIZwpZO
	rI10oShlp1frv/sb2wsWKznzApSb/5xmYJ/e7CYxc
X-Gm-Gg: ASbGncsfaIjNXWavbBtzT2tuXpFrvUiIQbFDMmHj7Z+Fzv2VRQNn4UpIBqB2dROX5Oe
	zBGrfvr690t6mybVAg3m3rURd6w8YOuXZDpsWzm72aPZO0yns2bB63IQSt+/xtW6MHZrxdCAMvU
	J3clFujjgGQqnxqn2PrHgb/7PQjjhawc4Jmmgy33eiuJKeYahnFr6Tkqew8sSVm1+0aBEpL5f8L
	Y/82py1HOKkVISqXKeeK5IhXJtIltdNcM9tTJt8Zw==
X-Google-Smtp-Source: AGHT+IFYO/m3ZokqgLgfZFSBuJ8vQyfm/3HMocIoflB016BCepHu8r9v6klK4bxjJEyMNFam7jZJfb7DI/PhTm+ebno=
X-Received: by 2002:a05:622a:348:b0:4b7:a274:d54b with SMTP id
 d75a77b69052e-4e6eac0ca05mr25279901cf.12.1760132584434; Fri, 10 Oct 2025
 14:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <20251010011951.2136980-2-surenb@google.com> <202510110501.92Srmvgx-lkp@intel.com>
In-Reply-To: <202510110501.92Srmvgx-lkp@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 10 Oct 2025 14:42:53 -0700
X-Gm-Features: AS18NWCwzOb_Fs69JrpmWw3AQRynK9NMKzj3B1QDKKaakj7u0qI0Eoy3eq_sHTw
Message-ID: <CAJuCfpEa2rdLuu81SJ807M1vuGd1eY4GMO2CrrfU8gY=VRtPcA@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm: implement cleancache
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com, 
	peterx@redhat.com, sj@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	corbet@lwn.net, axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	hch@infradead.org, jack@suse.cz, willy@infradead.org, 
	m.szyprowski@samsung.com, robin.murphy@arm.com, hannes@cmpxchg.org, 
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, minchan@kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 20F67A000A
X-Stat-Signature: 6mu5c3nii8c4u95xqxmy5o5cz1t1gbs8
X-Rspam-User: 
X-HE-Tag: 1760132585-452271
X-HE-Meta: U2FsdGVkX184LyNKM0fjIa+HaKZHkrLKDXiDD3qrZFQBc3E21WlYEt6dWotydu0sPk1GotHsHIzp/eB6ry1ZDrbmf9e8wfUBXQvwEaCeUEmuJYAeQVL8EQsONKu4JqEM5kqplAyBeK6DPrT34wwQ62PHyjrzAklnQQn0q5XTNkdI6UhTnSgwUM5EdCg2u9OGooYbFq+xnInvQA2gTfupOY4O8yviHa6cJnKWtJlaXHepeTLi0DTdmUq6iKJY4tFI4aH2naKHABitIoYOhbi3ypPRGBgYSSUxWJbLiHSnkWOlmTYy6tS4tkwRz+zNAIoy+bXUCHyUU3kn15NonU0iG2azPrc8uxheJWzj5C0pz6q0aHzsksL6aTMglbkT5Vw3bz8pugpwbVkIpcsAqphYejQHrLp6iFYsXKsiZWicmbHENmku894omfO16EPoaGGfnl4/E/vofqo6RK6GzlsWo2K9GmWqv9ivS6R6e444ns6foIIHsg90ts49fF3vwMOKy4esLJnRVpKerX1zrrmlua9xTyQ1ixSAHTIZJOGRjiEwKZGYeoPdh9NsowgzyUR6umo73+vdy9AZa6d5zIttgYKqs2wVP+SmmcIZyBe1bVF5qIx5Ex8Udrwpqjzs3S/AOvTET+EMmJ+trQMU1bz/g6lvu3W4i2F21UblVUVWEHZEyagLjGuGmI6+lcD7/jyhqITQk6b9xd0Qx15XmqOGxqxyJZXAqIXhVHJr5Bw6uneJpUJjYybgONbjWihM6X9BdkR/23Y1Jlcazws+iwJ6EtGlRkgqV9mEz3ZEScxGlQ+h6zX8Q6BjlxezIiJgQTG9jOEdIo5Sfa7ydGZ+AgVClkvTpeEjPiaE2DUs05bGswrBo5SZLkcHl+jitSw5NMy/x1DuuMXU1CoO9RgrVSnJMbyblB+67R2GLGssh8bxbUdtAiPKPZZ9GfxME4vs/vcJG+/KgEwcJ0EhayqqFyc
 +VdRU6kk
 M+Hj/yRdwkzC52Z+Cj5SX5dLWAP89i1zPcz+J1nAIT3AMXcJDuWuaEdxm/kZq6+GBTSnwrUNUh1DMDm5wFwJmdIJwUI6z1krm67Ll+rInFdbJSVR9IZ+Wu1jwri1OkOJg59WAA73/IpMcXmK7ePcp58ikps+XoSNG7qZx0FFX7PAShd4TiuImePttmJgPkgVv/O8FSzO8tjIglCv+VeJ9aSXyFjh+fbbwBkBlAG2EUL4L+pFfUi6k43MyzGYXakhd5wbUBSJYoRQAaRMdMx0kbCbvXyWqaRblSeePML25Vd53Jtm+Bf37m38KTxvT4scmGJgZb86fB/fm+qeWQSuGs6MYW4T8bHxkEXOq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 2:18=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Suren,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on 70478cb9da6fc4e7b987219173ba1681d5f7dd3d]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasaryan=
/mm-implement-cleancache/20251010-134501
> base:   70478cb9da6fc4e7b987219173ba1681d5f7dd3d
> patch link:    https://lore.kernel.org/r/20251010011951.2136980-2-surenb%=
40google.com
> patch subject: [PATCH 1/8] mm: implement cleancache
> config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/2=
0251011/202510110501.92Srmvgx-lkp@intel.com/config)
> compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd70=
8029e0b2869e80abe31ddb175f7c35361f90)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251011/202510110501.92Srmvgx-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202510110501.92Srmvgx-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
> >> mm/cleancache.c:119:13: error: casting from randomized structure point=
er type 'struct address_space *' to 'struct cleancache_inode *'
>      119 |         *ccinode =3D (struct cleancache_inode *)folio->mapping=
;
>          |                    ^
>    1 error generated.

Matthew's suggestion to use unions for members with multiple uses will
remove the need for typecasting and should solve this issue.

>
>
> vim +119 mm/cleancache.c
>
>    113
>    114  static void folio_attachment(struct folio *folio, struct cleancac=
he_inode **ccinode,
>    115                               unsigned long *offset)
>    116  {
>    117          lockdep_assert_held(&(folio_pool(folio)->lock));
>    118
>  > 119          *ccinode =3D (struct cleancache_inode *)folio->mapping;
>    120          *offset =3D folio->index;
>    121  }
>    122
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

