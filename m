Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 074CDC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 14:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B7048E0007; Mon,  4 Aug 2025 10:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9671B8E0001; Mon,  4 Aug 2025 10:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855FD8E0007; Mon,  4 Aug 2025 10:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 714638E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:42:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B4FCC053D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:42:06 +0000 (UTC)
X-FDA: 83739339852.22.42A31E4
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3942540002
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:42:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mRhkgUUv;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754318524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9Qh5bbxJ0F6IApOoCKKQaIcT54l6R0cIJvpxKuBMDc=;
	b=wFn3d0j02CmQ5k0ORS5q2GOcIgOZo2eYI0u3g2aLNYSYqcNsm0WLJ4fVtC4QxKWPpbcnz9
	81qgZriJxov56LVqzTy4w1Gjs8VBlNmCudkAl16u+P4EmCd8Y5gUQYr46zKBwT8Iue04PZ
	hZB8pgWGRPAc5T9Y54YwncXSBSEgp0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754318524; a=rsa-sha256;
	cv=none;
	b=vJ9xZ4SH75YZA/QyHIlAHZIqYPbL9SYjqNtzAJqGVm8msBMm+gfgKsMTfrxWSo4vdE7EK4
	zbr3ioSgxO7t4i68mdp8dE6u7TsoPRXLEO+KwJyitl/GTbdP6ga6vAySyXoJcKML8zkEhF
	4I8m6OGY5Az6V1rcs5bAOc2h+JmWyhE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mRhkgUUv;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e8e0c6f1707so3238455276.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 07:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754318523; x=1754923323; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L9Qh5bbxJ0F6IApOoCKKQaIcT54l6R0cIJvpxKuBMDc=;
        b=mRhkgUUv4nVSS2+HYbuUYknwE9EzqSKWTXBViY3zPsK28zzDJaKOY2VA1RVj6knD02
         h5Av+QbGaTq9SKQpwiKtlizUk/w9mF9URdZL1SwJ8EH2TrvL4Xs7/CwsevbixKF9fAqb
         zgpbAGiON7NoIz4z0Ig1mvst84aOgto3P2KBe5CQv3JqE6sRdnjN62VNR6DEHQT+NV2P
         AYvhRQoqV4xHoOPvKFh9pw0Fzt9802jmQ7DgH00xSBJt6ELTZrpRikZm3FGU0JyqatA2
         yrZP4IMJUR9KsPrNQXqQdseqQ09NTJmQhx94gH9n7wRUl0/DA8DN2PFBesiQFe7cudLB
         GqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754318523; x=1754923323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L9Qh5bbxJ0F6IApOoCKKQaIcT54l6R0cIJvpxKuBMDc=;
        b=fnzHnFR6VbyOeDH/p1zdtNXLk45n66R9HpnxDYHZ6UgnoBaR0Q4zx7Tq+jY13q3QwP
         81MjrJCneFPOMBKsMNGrQl8b2n+bkHtPnLsmStfW5Upvy4MpzU4x9MhotIzuULw1e+Ex
         IgR+ENLp4xWzhxRSnBOCZBpbiWA/6PQpwIZEbihTrUL+N2eZwQbtlN3uzy/beLFu/UP2
         Cou4oK4Nw6G8PjuxZn1Z7H/mnEzun/WVIfb+9lDJ4x7IdNnLoaqEgXVta2dpY3PwRUY3
         tYvy+0ih9XVPsuW4l7SBDu/7aeO7/efxWRBsIL6XFkjdWtMxrD3b4D/Fnktd2wIpzQ2x
         sj2w==
X-Forwarded-Encrypted: i=1; AJvYcCVa9mouD9EZb02pViCuUKqg2I1wXbWbRDc5PUX3l55DuinV0JoXNyZMD7WZR7O7NrY6DjuYjGprDw==@kvack.org
X-Gm-Message-State: AOJu0YytZ9EkvCcxnjj4QxjtJfRvcOUuR0clvDLq/VYzzCvac7nQTm5g
	U71LsIrvQRxxpZR8VbRdnci+vP9id2QFNEoCXlHHvl5m0Ci4j4uD3dQh
X-Gm-Gg: ASbGncuWJMjrZe7/BBK2gzUkR4gRkVAgTd2KspF1+eEHD8f2uhdFdiL4MXRfl+TujKw
	kB0oagx6uM82AhcpjGknAhIVgUsaYrv+YCadds0atR9AoSo3w6GRTTZpdfkgVFv+1HhCQqmUZpd
	CbEWy7y2aFZ16d+/GksrblsTflAd5E8HEVksT9vM0rcDk48FBu4W10C5xpYD1lDw32L/jHxpySz
	LIgQlxLwjfT7hZY2WuTqsWtYFem/N/OxUOYFqwmmxTX+/9eaOUwNL7JaRYGwyCeN6C8Bnz4mT0Z
	x/zGhFDPJbYWeKecvwgpg47/eOqNVB/M9xtDeSshx7eZdoRF3wdPZRDTAXblIxjRLCMPQTeDGLp
	el9AtGgodvesy/nE71Vjh7g==
X-Google-Smtp-Source: AGHT+IFVq2sed4Q3r4rw6Dy9QgRMBqAMf8fLudYYr+d9ZFG7cvHGyBa1fE+AwgBBwCGEV5dFY3/rew==
X-Received: by 2002:a05:690c:6183:b0:71a:2dc9:a209 with SMTP id 00721157ae682-71b7ef6121bmr119241167b3.22.1754318523063;
        Mon, 04 Aug 2025 07:42:03 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:55::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71b5a5cabf8sm26176687b3.62.2025.08.04.07.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 07:42:02 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	SeongJae Park <sj@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mempolicy: Clarify what zone reclaim means
Date: Mon,  4 Aug 2025 07:41:59 -0700
Message-ID: <20250804144200.1047918-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <8734a7zxo0.fsf@DESKTOP-5N7EMDA>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3942540002
X-Stat-Signature: jtobekn5157caigr8xbpg14n767qrpns
X-Rspam-User: 
X-HE-Tag: 1754318524-516809
X-HE-Meta: U2FsdGVkX1+MZyG6zRv2zFpwz0/xpJT+71fFacakK4OazDcnkysTYPit97rmPZ5g5Zr3PvgqY6adD6uYs3l7zdj2zwY8rOD9J5pwc3M5T4IlXY6lccpdKK0FHxMglLSEkDv51mVUPt2dwl21jd8/2E0sLAiNwIhHAinUOTY6NL/eKzKDL1oLF9YGJngJU8zECA7KDGBxPdkv4KVBCE0fj1Js5/Nsc5/scncXaQpi7MZID8bxzxE+5fPNpDsTCA62ajpzsriVipQD79z2syy7FckImV8aDPfHYMGpbStO5ayp831qYyCtC91ynWJT6/YlNsxKnt+PudFX1kJ2A2lvZPORiEwgJHgGsQ83tzZ4H1r/FFUxYSNiH49GK7N75k9CaDw2LotllrWBf7U5T0sZsun6ukQrzwtzpS8hq31RNB6uJYXfBcJ+5h0e8FKHwsfqgbhAMlmYF009mtjxRkTwK25H2UDtoR4mkn+fUwwIxeoemMRn5C5KHjufs7w1ytz42lxEMS3i+kqSHtcUIVbPhaRI+D2uIKNS08S/4Vqu+9BV9v9fGNdYVeKpKX8XzpcJF57MaPHIaO6UZe7EK/oABhwPt3Vmf8ZTWmWAgqNmGNWI2/5gzV0gWo/g3ZnIrBht9a3ziBHW8g1fgM47prvnTE8Oxr6vO1EG7NzISg0yZRFAkJ1N8CmkF0LZyGsDmdca0F89JpIEAIHXKTanzW8qrKnLZTf7Y9GGbAi2tZ2YKu58bmr03JwAtYgDkBgRGPZT5HKHQNhKLLyyFE19+Ms7NUK3tLk8qrhU71WI9Uana/e98gkw3wZ9Vw9dtbif0RbWJbplySTUShovzc0chmZa0cShmZvrD4Sy7izzfuWkkYF0rtJ2wRdNt/hf3FDvqKH74an1t0OWV6qyxIpVsXos/pnfixm71tcVNAgMAjAvxa9SO0b2Euj6eJArpZFBXjLFq9ebtVAOC4Rq+GNw28N
 bTmbUMx3
 PNaoWGSfqQzrdOKAqPm7Rzx6pV56BDGgJTkEVxeCqLjerIJ+UYxMOKJ8lswglioW9rrHKDxAVHU5Rd8VKqonwbQEJYHlOuUgJX31LOCoePy/J9n+RNBcxS6feUBZA11H/9tRCsa4ZJnhUCkcoeVkvjHIWyVzMNgxbyLSnm3ElKf9l5+mefDfOFCD7J+A1lNvmMcafy/j8HkJX3sEzwu94YTPJomM3jBK8R3qsAcx2zEj0s4CDOVXQCiAqH967HROTCjUzTHzMPHgzY2M+0xI55Uj3UheJYBX0FywHUJpdvrcsbRflNh+QxLFN36mXJMP2/1JXILJyy1wCyuPeftwWtDdWr1Cxdp80VxUbPnLTxwhTvjUmA+FK7V6WVpBE93BcNaK5TTBcjSKG9vY3edB9Fa0kWU4VCoZC4tUYvNm6w2wodujftD+w9EGwuHvELHpxmMLjj26v8xziWFF1aeLlwxHCwuVOwD2FIf3lb8pKdlS9rDCtqXSngLid7WZIiOBqrArB9W+p5Gz2f9xgglGunDZVqjCc7Ph3H0PvHm2e+vpkzqu7jzLnTtxpbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 04 Aug 2025 09:24:31 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:

> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> 
> > On Fri, 01 Aug 2025 08:59:20 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:
> >
> >> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> >> 
> >> > The zone_reclaim_mode API controls the reclaim behavior when a node runs out of
> >> > memory. Contrary to its user-facing name, it is internally referred to as
> >> > "node_reclaim_mode".
> >> >
> >> > This can be confusing. But because we cannot change the name of the API since
> >> > it has been in place since at least 2.6, let's try to be more explicit about
> >> > what the behavior of this API is. 
> >> >
> >> > Change the description to clarify what zone reclaim entails, and be explicit
> >> > about the RECLAIM_ZONE bit, whose purpose has led to some confusion in the
> >> > past already [1] [2].
> >> >
> >> > [1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/
> >> > [2] https://lore.kernel.org/linux-mm/20200626003459.D8E015CA@viggo.jf.intel.com/
> >> >
> >> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> >> > ---
> >> >  include/uapi/linux/mempolicy.h | 8 +++++++-
> >> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> >> > index 1f9bb10d1a47..6c9c9385ff89 100644
> >> > --- a/include/uapi/linux/mempolicy.h
> >> > +++ b/include/uapi/linux/mempolicy.h
> >> > @@ -66,10 +66,16 @@ enum {
> >> >  #define MPOL_F_MORON	(1 << 4) /* Migrate On protnone Reference On Node */
> >> >  
> >> >  /*
> >> > + * Enabling zone reclaim means the page allocator will attempt to fulfill
> >> > + * the allocation request on the current node by triggering reclaim and
> >> > + * trying to shrink the current node.
> >> > + * Fallback allocations on the next candidates in the zonelist are considered
> >> > + * zone when reclaim fails to free up enough memory in the current node/zone.
> >> > + *
> >> >   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> >> >   * ABI.  New bits are OK, but existing bits can never change.
> >> 
> >> As far as I know, sysctl isn't considered kernel ABI now.  So, cghane
> >> this line too?
> >
> > Hi Ying, 
> >
> > Thank you for reviewing this patch!
> >
> > I didn't know that sysctl isn't considered a kernel ABI. If I understand your
> > suggestion correctly, I can rephrase the comment block above to something like this?
> >
> > - * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> > - * ABI. New bits are OK, but existing bits can never change.
> > + * These bit locations are exposed in the vm.zone_reclaim_mode sysctl and
> > + * in /proc/sys/vm/zone_reclaim_mode. New bits are OK, but existing bits
> > + * can never change.

Hi Ying,

> Because it's not an ABI, I think that we could avoid to say "never".

My personal opinion is that we should keep this warning, since there has
already been an example before where a developer tried to remove this bit [1],
and this broke some behavior for userspace configurations. However, if I
understand your comment correctly, you are suggesting that we should change
the wording to not include "never", since sysctls are no longer an ABI (and
therefore we should be OK to change what the values mean?)

If that is the case, then I can send in another patch since I think the goals
are a bit different for the two patches. With that said, I think we should
keep the warning just to avoid any breakages in userspace, even if sysctl
might not be considered an ABI anymore (also I must have missed this, I didn't
know this at all!)

> > Thanks again for your review Ying, I hope you have a good day : -)
> 
> Welcome!  You too!
> 
> With some trivial tweak, please feel free to add my
> 
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> 
> in the future version.

Thank you for your review Ying! Since there is a question remaining about what
to do with the "never" statement, I will wait to send out a v3 with your
review : -) 

Have a great day!
Joshua

[1] https://lore.kernel.org/linux-mm/1579005573-58923-1-git-send-email-alex.shi@linux.alibaba.com/

Sent using hkml (https://github.com/sjp38/hackermail)

