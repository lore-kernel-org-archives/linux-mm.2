Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50F9CD3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 21:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5319F6B0006; Mon,  8 Dec 2025 16:31:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5093B6B0007; Mon,  8 Dec 2025 16:31:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446F66B0008; Mon,  8 Dec 2025 16:31:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 323FB6B0006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 16:31:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E07BB806E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 21:31:13 +0000 (UTC)
X-FDA: 84197599626.13.5C80D79
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 39CE9140013
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 21:31:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ub4+FvzN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765229471; a=rsa-sha256;
	cv=none;
	b=m5Vi4aSL2wZp7549rvcDccM4i+wMJDz/1MfCN82otdojFdm53vWA7mruZJSKlJOJKyIc+o
	gjL8xlIiNZvq9GN8hp7hQJomUUT601dgLE2AA4c/Do/EDvIcpO1LJi12/py+Iw7+A0iE0Q
	5sNoDdtBfBT50dziuu4BAM/AG9dAC5s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ub4+FvzN;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765229471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GbkMTjdP41ZWpVnOfAvx7UHNDJQrnVEwvaxDiEcsLhk=;
	b=u1C2UPdcurLGuhpqlbbkTSuEepJNtfTFR9xPVyJit+PgM1vH+ps4K0iJ+B2xPYjT/QCQlY
	KdZUSG+urWpqHbcB8DenrgnOsZNATzuYiXXV6dHq2dof4/GyV+Z0iGkSTiCPYKROb8+2Jp
	5o0QxtzlM3Ds42PwlXDPUPXweUsiR4Q=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ed67a143c5so148241cf.0
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 13:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765229470; x=1765834270; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GbkMTjdP41ZWpVnOfAvx7UHNDJQrnVEwvaxDiEcsLhk=;
        b=Ub4+FvzNO//URg+Dg9AMSfiIrk44t2WLwyyCJoxO7H1YZbtkUzcHdTi8ruFZEc0BvY
         lCtHaPZV6XcSBWue2rkldwhMK4OJmrRR0mC4PthNDm/ixdTG/7YPOZoGbIIHEdVw+8L7
         gUpA1i/WPSl2vimBiuhh0GDEddiHak8tC0GSnMY8tYCne8NsTmEGnqwbKMz0vgYF12TP
         s2dMAEt0EqEWAUo287dgzqI/1NTLQFyoonWbB9D3JvM0GzJSTFfGKtq23ipgeO/1qbw4
         xscRJLjzJik/yCUhhm2ISqKb6SFjksUjkcGY1RA77zNDNsr5IVy62+AGcFphsa00D1Xs
         JrFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765229470; x=1765834270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GbkMTjdP41ZWpVnOfAvx7UHNDJQrnVEwvaxDiEcsLhk=;
        b=c+ReedqxDtpK7hClXY52hvm+A5kEP7oVymYPwOUlyFqtdSiOVX+MVPefsq1gzCyTHd
         zQA5TgK1AhagTEAJOvDjLof9zECp2Nle/meOPo7g0eEbq1zDeKqsiurWlvBjdCn3alWJ
         ssZ42my+RIMM5OK9oS6NhuJv69EZ1y8TexGGpEZVLe5nq4p7RzsYLU48Hu8w7ZNVR4OT
         IHjWfmqCdSP6D9fWxoAf7iHCcZ8DR5gQfp7QkoRMmj275+Oa0uRrcYqj46jgwLAvR1cC
         8Go2oGokBnpRhdM9h+P88veF4ryUcdLDwZp56MTyDGTv/0xWCP87KjGg34j9RZN8H7zc
         saiA==
X-Forwarded-Encrypted: i=1; AJvYcCVFOzfVEeledMQiRg8ALBHrTK5ETi5lKTZAPOQ5O6DUfuDZldhZJ4EOC76NKw2Zhy5wX34R15KPHQ==@kvack.org
X-Gm-Message-State: AOJu0Yyl+RRN1hYaQfF37s1kXFO4v0yO2xPdRxV6GqQz2xTiJibAB1gK
	OiCzIl5FNTvNe6+FuqrJ7/dEFsXOGstF8SVgigi9C1IBjulud0wfWWXkUbe8uz/nSuyplB8WFuc
	maE6ZjwwA1E7MtGiQh/FTR7JpBnaf7PqJcIy2ipZz
X-Gm-Gg: ASbGncuCr1S94zE5H3fr3THkuFU0dbCTGcycfxTXPZbl3ti/CSIXxbxbo/uFDGEisHc
	eUqMIeBn0P3i3aIPDsXIqwID4L+RLBvfep0fpOHpgymQ/9eGGf87Ew+McWQValCc7qUY3sE9IMl
	nuecxUqsGCr3mesQncWrW7wb183zG29g6zCHGXSlBoa5s2PTA1/2cj/YYr+44UT+oSV/wS6p+WJ
	G4YhZBKtdWobgJVDrRpYcsP210K8xEDeoGLU4tdzSR0qEmbY5OzA9v6Oj7DhU9aHnUy6naQEw==
X-Google-Smtp-Source: AGHT+IG29GaBxwHWZQc2LB9NRpX+zT3/jUbD+9n9oxYqOMrPzqlyPGzUr1sjF/e6u05Vs4J0g5cc6rgCzdD1pfVFPDU=
X-Received: by 2002:ac8:5914:0:b0:4b2:ecb6:e6dd with SMTP id
 d75a77b69052e-4f1a5e7b540mr854641cf.1.1765229469904; Mon, 08 Dec 2025
 13:31:09 -0800 (PST)
MIME-Version: 1.0
References: <20251204220957.360838-1-surenb@google.com> <202512061207.7zufoIcC-lkp@intel.com>
In-Reply-To: <202512061207.7zufoIcC-lkp@intel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Dec 2025 06:30:58 +0900
X-Gm-Features: AQt7F2pnkHbec3VF5ekmZv-cl7lVMbNag4cTqBp9jjapgjBroeJ40ilDtAS4xhQ
Message-ID: <CAJuCfpGkdz7QhOGuS2SSTw09FrQkQLPFpQuLtMkmFAbJhGGbKQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] alloc_tag: skip rcu barrier on module unload if
 profiling was not enabled
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, oe-kbuild-all@lists.linux.dev, 
	kent.overstreet@linux.dev, vbabka@suse.cz, harry.yoo@oracle.com, 
	da.gomez@kernel.org, jonathanh@nvidia.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: efnermfeu6593era65rhwyobhkb61di8
X-Rspam-User: 
X-Rspamd-Queue-Id: 39CE9140013
X-Rspamd-Server: rspam01
X-HE-Tag: 1765229471-282328
X-HE-Meta: U2FsdGVkX18Hi8r9nhP+9BzgMVdDqGQTHaUoAhJcp+NUCdrx21HczeQ9JEDUFOHcljmprVSxWuZTzoGbBDdcn3jtjS/H7EKV6gx7Kd5QqsvZcsOnWKrJtdYK7aEPZrxIqC6iqrSquMO29p+E+7EtYRWSdWz5AdR/OEvziJMtRsG7HNMEeY5xsiJID4/AOCCRxLbR1B9PldW/cQwuAbIKqbaQKhQVPsN0M7rL59yD68r6lZYjJOjYY149NFbKmG/0FMrQuRd987awlHuRGqgG9Ad3aOB3mPUMY4l4FeyvQlJQOnDVcAZKCEwYf9UYerMf60X1wLdHqu03SM4bBYhs6vgVngO/9aTBHAoJQ8B/Ak+2hmRhmJN89yV/SSK3ngfH7gOQDW8cEviVJbC6PSunQHS4K2oxHDKvn1KHPW53zA/t6HcrHcjvNSGy28A0QTtiMRnU61N/CU/4nofudob71XocEVLb88y6I0aVTkutEU8xnU4yXps/A+A4RRaSt0taBp+6AYISpGrZw0J/xZmncdzd68w829xstWeo6sI8F1XGQ+OhMR9CC4CcINKwEKnGaudU5MJ7ezgt5919T6Tw9YwOC76/Mq9+aP6Ha1l0/kSTViD/sxuzZ3PRQmXc+GU0maUL0cFtlRAAF8VG/EIGUGQ/e4oyBXrQXeA+/W6wHAW4QgLi8aX3ieI8NU0HmoJ1Jgf+l+Ar8go8utyxjCt7vNz9hGJab1XBScY2O1v3IRN6tg1BuoXvtZlLxGOAU0aIJRgxnsMbAg9baEhuVuujNyTA/xZYqIAC7uHJI4njZ5z2Cvs3UEQqUy+xLsyZApZMQpbRjF68zPQRHrisR1VR3OCxjFuZFHTSC/vXnYRO6i3kCkQ0PjUPzSmoPgAeZeQ/aogmBBj1rK9YwvbxsexCigPH3JX6ShQ0Ggti5ZL1MHjZdqhqccrnJsggxh02mTzQtdsMs/ybZYwfPUmxDxT
 kuBMdtsd
 8KjcBWIKYGNg/3Rk0gsUQrdXt2kkTdl/RFvan/4joskV5FliBEFo0XN8KxqvhCSzlKy5+CwrSyINrDyOgz/UxFxOaSAOqUK1gVfLLQOKHWVmKHyEk3EsYVzLo5KXd9Fljuq/UwV80oHRb5CdmLJ+7QZX7jdTucq3uoSRFcQsvUE84G3dzOgui5rVGS135VRyk2QZNeO09iLPwR71fqWwM56Q/lI3sE7nkrMmoWOg0WwPA3pLmS0FExHd4URp7B5aq8BbRYMgZ9n3owoO3UgmLklNP0Hn2q5nZ0VPMuTC2bNhSZrUR69BE04iGhERB+JukxZR9b9IbGXl1cpGzjsjYeEhc/dGSTrGicQJX8k73VWRYhqGjr5CzJQDxy//tNOeLJjIvLspxvBnwcW0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 6, 2025 at 2:08=E2=80=AFPM kernel test robot <lkp@intel.com> wr=
ote:
>
> Hi Suren,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on 3f43be96f919cc611dcb2a4e38dd464831f4513e]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Suren-Baghdasaryan=
/alloc_tag-skip-rcu-barrier-on-module-unload-if-profiling-was-not-enabled/2=
0251205-061310
> base:   3f43be96f919cc611dcb2a4e38dd464831f4513e
> patch link:    https://lore.kernel.org/r/20251204220957.360838-1-surenb%4=
0google.com
> patch subject: [PATCH 1/1] alloc_tag: skip rcu barrier on module unload i=
f profiling was not enabled
> config: parisc-randconfig-002-20251206 (https://download.01.org/0day-ci/a=
rchive/20251206/202512061207.7zufoIcC-lkp@intel.com/config)
> compiler: hppa-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20251206/202512061207.7zufoIcC-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512061207.7zufoIcC-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
> >> lib/codetag.c:37:13: warning: 'flush_rcu_on_module_unload' defined but=
 not used [-Wunused-variable]
>       37 | static bool flush_rcu_on_module_unload;
>          |             ^~~~~~~~~~~~~~~~~~~~~~~~~~

Thanks! I'll fix it and repost after Plumbers as the original issue
seems to be resolved by Harry's patches and this optimization is not
urgent anymore.

>
>
> vim +/flush_rcu_on_module_unload +37 lib/codetag.c
>
>     34
>     35  static DEFINE_MUTEX(codetag_lock);
>     36  static LIST_HEAD(codetag_types);
>   > 37  static bool flush_rcu_on_module_unload;
>     38
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

