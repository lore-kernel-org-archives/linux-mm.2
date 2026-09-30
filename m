Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D95ACA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422986B0088; Wed, 30 Sep 2026 07:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3096B008A; Wed, 30 Sep 2026 07:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1BD6B008C; Wed, 30 Sep 2026 07:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 028D26B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:59:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54CE1C0711
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:59:59 +0000 (UTC)
X-FDA: 85270133718.14.98B19DB
Received: from mail-oo2-f36.google.com (mail-oo2-f36.google.com [74.125.231.164])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8749340002
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:59:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="P5eoR8/w";
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.164 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790765997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Woc7loh+3fAfJUM+qt0sDz2j23/UUVhg4Uqbsoe5iBY=;
	b=F4Lw9cFN/KUl5hIL3z3dE2z7oPHhJfNkEAJiQqAbqssYXVXWg6ScjKJQGXwjhhqTq3rci9
	hN025+zN83hLl0MGfZT9Yb2H0mrQvBuvMu0Cl58Vw4MVoE4gHfdVA45av76Ns6Nu0PbxvN
	CXUyDpJI4tTEoIiDgkKqkIxPR5TL0os=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790765997;
	b=2fvRHnMZqJQndSNCwhqdkqG8pxvm8jyH7wYiCGu24bHNHPlPr+JvbMSCBOU9mI+VTcggPx
	IF1CE4xXqcwwoQsO+rLuVt+b6MamCUxUS7aJtzwFEhbupMzNl6Wl9zk0PP5+orN+TDaRLc
	1qv7VQBqwZeck9lkgMhtXHivEdu2zqM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="P5eoR8/w";
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.231.164 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oo2-f36.google.com with SMTP id 46e09a7af769-82067e86a89so171076a34.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 03:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790765996; x=1791370796; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Woc7loh+3fAfJUM+qt0sDz2j23/UUVhg4Uqbsoe5iBY=;
        b=P5eoR8/wpw88nIImO7zItU6Ly0txAbWMSCIR7XBX/CUQKV9zTShWgVJp4MoLvn/ioC
         H1XqUzOUXwnhlM1IoFUDMyG3b+1Z+cubTORx4/E7hXYdQZCJCZPoCU/e+GmlpCbBk9La
         SGemreosdoGygbP6Mge34KgYwbfoFUc1EKfzFB/6pbzAsFLta48RRk2GeC1DzELbQ77C
         hVSFCZZLB6/XYtKwqZhXf+APGUX9WQ2E1olVTxpubujJJZ+nRROFSEEN58jzm4oKsjIf
         z5bHLs9SABC6LD+peaxXi0AV4l4CSKmRlu69fq55rirtqnRtDpgiBfXfx0DIYgBIvhXW
         Wv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790765996; x=1791370796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Woc7loh+3fAfJUM+qt0sDz2j23/UUVhg4Uqbsoe5iBY=;
        b=M6zA2whbtyn+0944bF3E6LQbPFxvLVmnXnG89NOvsNyVfjJ9IMS6tZnfj1j0+QBRwG
         ZbxFg0yn8r9yxrKL9vc/vFxlm//QnzAAhxxto2ZNGavgU99gD8iYJkzxr1r4LAeu2wli
         E/8kNEb3EBNmidLiDjhk4zJx//8oj0qRlBxjYmRjcjBGGGi/tcFJJHpOL63Bp9jsn5UF
         nJCsyl+uwFIFQruWSEKonpoCnsBs8O9xw2Dlg9EDfpbPjbhvY5a14ebmLsPP2PKBDUTg
         mwA/lDp84vkrEN1OjIhEx5q124jFAYil4LXHitIyv4HEAMejdVqoSPeKN2UTl75tZub2
         luyQ==
X-Forwarded-Encrypted: i=1; AKwUvBwba8KOXaB6XfzyxAuo8HdhY6ZTqd5esMXZdSBFazFaGusZbcoe8JsGNk+JXK6wowGHXJBa2rKQMw==@kvack.org
X-Gm-Message-State: AFuF++l5vquw1gV/PQs7+qh3sWB4KP2g6qcP0GPpuICnhQ4aXBFNqp7L
	o900J1FsEE78GmdZ6vCG+iP2fCNVsADpzC1qcFrmQ3ysC53ggrP+6c/Z
X-Gm-Gg: AYBFou1M1UXETRf2ABBPzYOyDex1bJnFR7XT3L1ABxJiE8Focm7r33464fGMenyjtBo
	km1JkJc+jnbGcUlfyAqXie3wTU37H2OSlFu6M7si3p+sKELHhLleCqKUvI2jeCqP/SSheltxzlz
	LajRjPWwuK3710sjmU5YWb9OxVfjMnP/ZluhPX3GWGWexh3AjI0Gv7539CfvbPXADBDUL5p3ih2
	485YSTfD0zax4/fDyIeNmiZNneLwYCMWpY/nzHBcw96TjIbgEELrPDksGLtO1h6U43e42kHciN/
	neWUP+1HGd/+1mWWKp++mJOnQuoQ8Mdf0VKgNlnkgs3x7ph5+AY9sXtsSt+//ktZ8+ley/DgafY
	yzytTinqtDt/g46nO7DOcY8mgeCbrwQz3PMNvRu1Ci1+SEGmUNiDNA/vtICP3FFMzrBz0HiPX1y
	q8bbTAtMt/fMppBQ3Vq1apzFT/9HAG+85ufMUXzhcilvoWEL+5dq60kGT+FwfDqwytQflHU309a
	QT//HBtcqxGlKvGH+LS5CAKaU9h0g==
X-Received: by 2002:a4a:ee14:0:b0:6d8:e140:66d1 with SMTP id 006d021491bc7-6dcf4b6698amr692225eaf.23.1790765996325;
        Wed, 30 Sep 2026 03:59:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6dcce85d9bcsm1045955eaf.6.2026.09.30.03.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 03:59:55 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference with MPOL_WEIGHTED_INTERLEAVE policy
Date: Wed, 30 Sep 2026 03:59:52 -0700
Message-ID: <20260930105953.3956219-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <arzR_QtoMPtM5kUB@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5xn479r6ma145ruhwzwy9j3wuyf3u13d
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8749340002
X-HE-Tag: 1790765997-99939
X-HE-Meta: U2FsdGVkX18Lbl9zCscKip+/wl9XKiaISTRftnyPf+hl+y6lS8h8Ae8W/mymm0Aoqv5DtMNsCGMl6rcKpnisk8KbAEXVJBjSEqBaHjWPcvUnb9DAXUWt95WRmh7GL5+1H1vRr0Mi0XqZ03YZ2zZn2Bengr2mxTi+FYX/9qTgDhSxL6NYg81HdWtN58FcILcPQdMPjOzTkGYq5pU3LGHARGk4FkKON0D6uEOWrWdxicCemBSFJV6zPwb1mupH1M5//Tn9ouZL/CxETpBHDBIjjexBUujpza7DSzN0AZuKSQuy/faJ6hkEg5DOAAxPOmdUbQFK8lJDcZBQt9lNct5/mSBO0gtkPwXh4v7lCPsd5nwg3ver7gpFHgR0eOQH5gXxdXIFyk5VmHI1Yod5N64ikwtdWqXd0kWXBLcS9PMgjcarlMaIO4Nqc5hAATy5zOl49b9OAl0MgvdWcaSTrsue8rDdo0aIfI3bDCZjjgfEsvGmRxYFS91JPLhYwVtPgO5i4oHRDMVYv0tG2GiVAo7TqMfFbBm7uZbQPAejsH/d0fSQgz5lclaxJXttinNEchcrUeaHE2fKtLnhZVw5xLEF+mpCLcUYfsquFcwq6IzP8oP6ZmrLb3AWT6rKiSfhABIzZfgz61csuBcNlNFnpDYq4i6qDeqtiYvs3cCkOAZW4+ZkTrlEvAY4uRK5tO6k65WBvdYaZ9c9RB3TGgnjw1X9lJGGM7UJg0fzGz9grJq4WE3k6UgSfdF+05Gi6WZmdhHtfKQ31VaJTD/uvqVY/6528FeLb99+CpRo/+Z//wJaiode28OnL/a/pKers8ne5/V7e3tY3BbrEmRwdKZC2zR6su4P1piqwJNCWLwNdqJmT8CZKIahZ6DQ1PhQnQ1AiFSr7AdM9Zut95zG0tjuveRtbejw7GQP1widQbzOvtlf9txWGnlE9sCxd08XWXPM/fTItVFwJhmZzJ395YTBfGf
 DFDk84Gq
 D6CgnGDzf6Eh+IWBLgpWYYb9vlSZZYYxUbFzErIKlbMH7D9ohjkBeJaoKrZZpE4FLnzMKqZwXoJ9zCYGdHLwkwaVEjMBIArAo/YCgsKQfgWyijeUHFtjVfXEq7XPguF254Qn6q2jfBT8p1Il1wBBRD1iBSvFYs5MEotiCgsjsbegGEpfwpcVyd513mSJ9STkBywbUkt175p8wo0R3+PtxYomM5o8sYtlOLbLxYm40dqid07+Tw8LmoAGnvrKvQSYD0dGoe4wZEzp9/jM/tr4s1KkSFRcOPGCRdhkRJEwbRiGseetIQUkgVXRtmJCOzc/moZcu2BpXqhoEbqdmdVSL1T4KB2Uw9+BIUAjHLjRtJUrHr4jcF2eRhQJrzCIeoQYWbc+dSJU9qWkpa1ptJduSt0oSq5IEA0zMlO8IzJRAnYq7OhAbanWAQuYCozSJSRa1RgnaSGCF/IEHPBsKOMoSH13D94vEiXeAWmaOoePVEyDUpNopZYvZHxIIIGCh/Oe983xequcuttdWejHM4PBLVfUDR4FkwutyXm5lMn4VhXALTQcJr57zFfuOeROWb7onV5jkQpPaP6dJl0nO2AEuS76krYbmWa/uKJOwEi1nDxbyKt44Ddr9Y0z2pLVebVPJyzREkgvisHSfLix6zw1RH0DTZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Sep 2026 05:11:28 -0400 Gregory Price <gourry@gourry.net> wrote:

> On Wed, Sep 30, 2026 at 04:59:50PM +0800, Li Zhe wrote:
> > On 9/30/26 4:43 PM, Gregory Price wrote:
> > > On Wed, Sep 30, 2026 at 03:26:17PM +0800, Li Zhe wrote:
> > >> Allow MPOL_F_NUMA_BALANCING for MPOL_WEIGHTED_INTERLEAVE.  As with
> > >> MPOL_BIND and MPOL_PREFERRED_MANY, keep migration constrained by the
> > >> policy nodemask: if the CPU's node is outside the nodemask, do not
> > >> migrate the folio there.
> > >>
> > > Why for WEIGHTED_INTERLEAVE and not INTERLEAVE as well?
> > 
> > 
> > Thanks for pointing this out.
> > 
> > I focused on MPOL_WEIGHTED_INTERLEAVE in v1 because the motivating use
> > case is to seed memory across tiers with a configurable ratio at
> > allocation time, and then let NUMA balancing/memory tiering adjust the
> > placement based on access patterns. With equal weights,
> > MPOL_WEIGHTED_INTERLEAVE can also cover the regular interleave
> > allocation pattern.
> > 
> > That said, I agree that MPOL_INTERLEAVE can be handled consistently as
> > well. Since this is still an explicit opt-in via MPOL_F_NUMA_BALANCING,
> > unless others see a reason to keep MPOL_INTERLEAVE out, I will extend
> > this in v2 to cover both MPOL_INTERLEAVE and MPOL_WEIGHTED_INTERLEAVE
> > with the same nodemask constraint.
> > 
> 
> Looking at it, is there an actual reason to limit F_MORON at all? Or
> should we just lift
> 
>                 if (pol->flags & MPOL_F_MORON) {
>                         /*
>                          * Optimize placement among multiple nodes
>                          * via NUMA balancing
>                          */
>                         if (node_isset(thisnid, pol->nodes))
>                                 break;
>                         goto out;
>                 }
> 
> Out ahead of everything?

+1, I like this idea, especialy since the switch-case break case already
leads to an MPOL_F_MORON check at the bottom. It would be nice to just
consolidate this into one generic path at the top and simplify the
exit path as well.

