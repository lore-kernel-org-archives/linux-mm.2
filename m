Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A399CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 15:26:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DDD36B008A; Tue,  9 Jun 2026 11:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78DE16B008C; Tue,  9 Jun 2026 11:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656726B0092; Tue,  9 Jun 2026 11:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 531B56B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:26:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B6E4120463
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:26:30 +0000 (UTC)
X-FDA: 84860750940.19.1D87987
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0E41E4000D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:26:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UnTZ4LXq;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781018788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rY2o/b8cd6ANaJfQdcKOucxVpV0MJrStEBR6w1nR460=;
	b=Ut66iUfa5yRHP6FmilAWOnBEf/UJLXRMvFoSZ1QyA6Hu+a3xnkGjfhc9+QSPLZEctvv5P+
	35PWDpqj8tMCxYuyH+War1iCId1Mq6Vz/2w9LY2XxCSB7d1QGa7zX3cQbsSLLLOe+NYB2b
	eMz1QR515rvf6GoNZEb3Tqp0oJVO8rI=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UnTZ4LXq;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781018788;
	b=qtkPBRDLfZlhE4kuUUFkDl9whe/IG3RQp/JMrnHLmhpyugUdWOT5xlZcsk/o0tTpvoFLia
	LVLgzjyeQVAPCBhDBShoia5wcZJXESdtb0qTC/FmL1s9kL1UvGQLPLq7yqjxeHUcI+uLUG
	VzZ97ZqIS6Aw74JtRloqvdFSgp+KdqA=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5175d339e8bso2497651cf.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 08:26:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781018787; cv=none;
        d=google.com; s=arc-20240605;
        b=QmSDCJRjitO9J0x0ZcneTeP5rLYSIVbvaAKrbZNycjKd2IG+xH+ht1xPLDskfAI0b2
         My3GWGzi7w86DUpUuaYdlskQW+Qzgnc8WyLwUhGnP6jhii+HKM4m47KtvFzvaQHxiTxn
         U++9pZ0sh+1H4PjI9SME4+M+5uj8q+7yywYkePngFGnylbDkqs2aM0pHtavT4OV4a7Yy
         LQEv1AAoraH6ULsg9ymkI9XK4PYFIwIDlh1QjH/v5hAjSxxhfeseFYBJohxkHBvan5wj
         NhXijigqyN3iBZzQ4g2n4gpRdzc1bvSNWQocABPFu8fp6F3cjd4Z+r+52keZ+FzxERXo
         RqDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rY2o/b8cd6ANaJfQdcKOucxVpV0MJrStEBR6w1nR460=;
        fh=2071n31ux3yZ67pYxUFVmnvrA1uP+R8fYLHt4P39vSQ=;
        b=FcgsPTLNxV+Dvb6JY7KhBn3y7IICVpHAl/LJSIkQ8YlcZkHSYZFUd0VpUmCa8sQNld
         4FuEKu0NzHIRYTYaRFuFUoy4iJC5xM4yVb1Zrl2ug1caN/FqG5qiRhN8Oxar29e9i4ve
         TID0BUzul+z386HbtPYNtuZJ1sZ44Jr2NkegxLVd8qd/++xs/p5anB9PROmUuu2bW6k0
         GzVZDmBL5vKUvVwPBVH4HwlEA7fC2Jy+50q7JBMOW+rp/xO2mJ73Y3znmXPmoyVC2EnU
         xwzB9M8+6N3AhNG+isYqtNlcqAFOr33R6UlKXvGs7Ip14a1c1KBXhmPDcNH85vWcWhQc
         J3OQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781018787; x=1781623587; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rY2o/b8cd6ANaJfQdcKOucxVpV0MJrStEBR6w1nR460=;
        b=UnTZ4LXqv3kyCbTPu48VctPARVoOHjC34pZE4C6AHgwMbT4x6V5fhhj7Wnd48h1S9h
         2pKVBCaqtTKHUyU8nXkCF+tBdwn7QQRXEBcMBKFz832g9gwb7HPUv+9XuaF9FCghRsmw
         CnDQp1H7mogs8h5bZvSsU32PalOcQz3csewEX5Hsu+p2OHav7IxguoDqlBz6s1d1rvcS
         6ALzlwK4Tv1xJ291wHFP1ILatzl/f5AgTa7lu/sXEXivyENwcAJOtRGqjBkYxh44qrOV
         NyHRAcVCjKVBnuibeTaJIy94L94ID+UU4mg1MLGPaIk2UUmhl46bDZ1w1R4RBnd7w61e
         Zuqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781018787; x=1781623587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rY2o/b8cd6ANaJfQdcKOucxVpV0MJrStEBR6w1nR460=;
        b=RJT+u9kadI0W0a/ijZDR14vn2wETULZMuZgpEvtzBIFYkA5CVyRHQJVPkgDARapyQF
         sShQl+0cHjvtzfsIscZ1gqGEwvWCHRXV0kz/I9C/vmYlhBcrkzHPOROAhYGra8JjQOe0
         Tt34jk8Z502QQqVeRIqvi5hPjUD9ijIL3qR1PwYbcVKSav6Fb/X9BMGBXb3BDgpnuamG
         u94nBH+d8OUdbVq0JSrtzf2zFetNhoQnR/6Y/jbwVsgZxigRO+L0NXqeDtXLYWj9BwgD
         fd0Heu8qLSJsQNcILva8qE3UTlm5vfNl/pfnssQ9OQCTKoTKyO9GP04R5VDVYJURr2xx
         s78A==
X-Forwarded-Encrypted: i=1; AFNElJ8ECB3rqHNiq56QvbiLChSDHogFtRKU2jeB9nw4tAjm0Sd68ssAp//nSqv0rqmnOfa46GXiiy6/hg==@kvack.org
X-Gm-Message-State: AOJu0YycNju7/kPmVDbt1zAuLAMqIY6B4zmLADaA2wIwrnyMwXeuXp4s
	k3qDj1q9M3WqX18Ts/nPsoB3KhXwuz1uo/n5hBaKaVERMpXBAcPiE9mZ3o+zwSN1Vb2axuKlDmw
	qdzcMQYOmf4FEhLbedkEYzj4nAZb0zr4gDACcmx74
X-Gm-Gg: Acq92OEAgcxCwMMqLuNnHZmx+091Gd6ZWjyqIHOuu41Kh4W5L9+Z+uSQGo+uTEbai0z
	1ZBJ4NSUCCZd+EHHRr8MCLXZ909OYNV+p4Rv1tBbpJgnThKdrIhJWrLOiM2eBWbMJW4of3FTBzY
	wv+FVnHNJilqI00YEkROMjYlXq3NNhWwXCOTsS7hz/tkyp5vFoUZp9qSeuj1PCpRwH2/582w2MY
	i48LwF8S9HQTCb6yeh1VD0VbWxGSfcUbKMSUxIetSRIl6BDmRf4U/aie2EGh1iQjMxMIium4YUT
	yK3RyFjH6PNhzF7Fy2lcQjdu6TKGcNo1V2vErm4nrNc7EnSh
X-Received: by 2002:ac8:7fce:0:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-51797ffe81bmr33892121cf.5.1781018786362; Tue, 09 Jun 2026
 08:26:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260527110147.17815-1-tao.wangtao@honor.com> <70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org>
 <CAGsJ_4zg8+pVDwtsJtxxiC1ahJ9MR56Ue8VXCt_VrQgcXES2uQ@mail.gmail.com>
 <273d02a1af954b8c9f4da7fb74e6b4cb@honor.com> <CAGsJ_4xTMsV8fJVfhshDQp4=Ax2f_+b6yR873cEP11bjcEa_5Q@mail.gmail.com>
 <3031859912bb43a7ab16ec63863914ab@honor.com>
In-Reply-To: <3031859912bb43a7ab16ec63863914ab@honor.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Jun 2026 08:26:14 -0700
X-Gm-Features: AVVi8Cd0phUCN63P78bsofAEIxBfBidiXphGPaa4I2_plf94aKBqa4-HMso_0rc
Message-ID: <CAJuCfpG6-PkWpRqr7m5evzTy9s8LyV3nW3TScOyjqWb+maVBkA@mail.gmail.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma creation
To: wangtao <tao.wangtao@honor.com>
Cc: Barry Song <21cnbao@gmail.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "willy@infradead.org" <willy@infradead.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"ljs@kernel.org" <ljs@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, 
	"liam@infradead.org" <liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"rppt@kernel.org" <rppt@kernel.org>, "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz" <jack@suse.cz>, 
	"riel@surriel.com" <riel@surriel.com>, "harry@kernel.org" <harry@kernel.org>, 
	"jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, 
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, 
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>, 
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>, 
	"pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>, 
	wangzicheng <wangzicheng@honor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0E41E4000D
X-Stat-Signature: 6ute4xkc8uxg4hhxo8dt9ttsdk981n8i
X-Rspam-User: 
X-HE-Tag: 1781018787-813203
X-HE-Meta: U2FsdGVkX1+30tOI1bCHU2vXueqzpZAtypXEa2hfcEcCLWxik7Gq+1hsilAyW7MblUIFr8Ns/J3Ld1PMKVcHAnlNNFwyZ2cvx6rgrsOTUNPVU+oSm/zTRELoZundLdirdZrVGWawRy+7fI5EIZkVVph9NWzq0oEGBAW8fSr5OabHhaOhM5K9y17dfrAZLJNWpWPGkhmbh0oLFTE6UYpuPUeZX9X7pIKeJsjbUUZYlpF++E1VCJMfqKICjDZ7pV883M3ByzZaFtWmAJ1aIpKl5y2qauY9mjVQbsw2DVP3bHK97K0ly2UMN0qzfdColFb8WSiMK/j5YopRx8pEEjl9m0RKBg5Jfj/YBepz0UYjzV5KtNC45M+TGal3H9TbwV9MLMzn/Jx9acQNHsx66dUARe4IbaXFtvGHzs439R7NBdoxh7deAIlR+XfUJeI/6Nnl2snDUcOk6Y/Hvss+iKl+4UQtdLpyv0W5iRtC56Tb4AK6pNuA/mkJ/CelozwdyOPKEj7z3jtxVveEIubwm4bqSRZDiZ/zBUhY7NjZ3lIWlcQy38qL4II6ULQ2Zi0iDTOd/3PzU8fgB+tk9v45STKuBN9W1RIDzSOaLoUblKwYSJh7vS9v1LLQTqAoHkaHILZKey5UnqZWh6YBMBokXWQEYp+mMJFfYnyjXZ+fZxwCZ7njLO/IQ2ldU4s20MtIeyIUtG91Pv5krGuNZTvVZZG3QPJ/3I5BLCx5UBzx1t9Z7F7yY7i5YNbbEpCHwBzAvMLtS+fyDdpLOFLRqW3RhOjNFZli3oGSJhsb7L2EL8fFTSfFrR9sWHujRAAORHlqOJ00J++YPQ8rGuSkG9fJ5tmLNKvvbQrSdL/keHgZWwdTQeeseXud8TvuwDaK09F3Fca51AWIHj621O6N7JT5GBdvDOyztwwdsNoPjCw/knjX9WbC7wITaahRtGc1Tb+UINh+qTKFsH6wDDDNCO0Xu11
 4V3FklyU
 DxipQeyF/R+Et745Ha2QwewaFE52Qg+0HlmZBPLvRAc4yQYsodYP8eq+hN4Uo6Fw3i6NJyPYk3CkjgOQN4IkSmXrDIcS0XUqtUrHSPW7QuNckJGn7V0tQSaTlaj8drF6oU1mLZIpLuJpmO6c/z/6udcFwE1sfK5SF+Svu2+q6qUNMviKZSQe9aVeI2hO0V7hIIfPZz7RXvuNPTkmJ8bwBWO2vl+C7jgWlIPzB1Zv2on9nYurjOrNsProUIBhv0Rw2T7onJIk8WarFRyjCH9xQIazbq18rF0JNYNOiQlyIyqrsfIy8bDCvO/SJ+8HiB51fKMjbLECh14BEjEfHHffD1JjARqtogb16y32YAfatmrZOytjd8Bs6BUKMBBrKg+IaKeMZ05Cizp1sKF6lsq7Fd7MdDD1+WwOpTH1xyStgV7chCq7Ove91SSKi7zUM3s0o9uOTtR7CkwMQA2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 4, 2026 at 12:35=E2=80=AFAM wangtao <tao.wangtao@honor.com> wro=
te:
>
> > [...]
> > > > > I won't echo what has already been said in this thread (and I
> > > > > didn't manage to read all, unfortunately), but for such big and
> > > > > invasive work it's often best to get in touch with the community
> > > > > earlier. Otherwise, you might end up wasting your time.
> > > > >
> > > > > Ok, arguably, someone who writes that code learns a lot on the wa=
y.
> > > > > And if this code really was written by one developer only, I tip
> > > > > my hat! I'd be curious if that code already ran somewhere on some
> > > > > Android
> > > > kernel out there?
> > > >
> > > > I heard from Zicheng that they have been running this for months an=
d
> > > > it seems reasonably stable. Please correct me if I'm wrong, Zicheng
> > > > :-). This really should have been discussed with the community earl=
ier.
> > > >
> > > I initially developed and debugged this based on the Android GKI
> > > branch and did some preliminary testing on an Android phone.
> > >
> > > Since GKI generally only accepts features merged from the upstream
> > > community, and this memory saving could also benefit the community, I
> > > ported the patch to the Linux master branch.
> > >
> > > Because my English is not very good and I rarely participate in the
> > > community, I am not familiar with the community workflow. I did not
> > > send an email for discussion in advance with an RFC tag. I apologize =
again.
> > >
> >
> > No worries. I know someone who has worked on the Linux kernel for many,
> > many years and has excellent kernel expertise, yet has never submitted =
a
> > patch throughout his career for various reasons.
> >
> > I heard from Zicheng that you are HONOR's key MM expert and have been
> > guiding them on memory-management related work. That's really impressiv=
e.
> > Personally, I'd love to see more ideas and contributions from you in th=
e linux-
> > mm community.
> >
> > BTW, regarding my earlier suggestion about using GKI hooks=E2=80=94limi=
ting the
> > optimization to newly created VMAs and to applications that never call
> > fork()=E2=80=94do you have any ideas on what the smallest possible hook=
 change
> > would look like?
> Even if Android does not consider handling for 32-bit, KSM, or
> memory-failure, a large number of hooks are still required.
>
> A different implementation approach is also needed. For example, one
> or a set of anon_vma_locks could be used to mark whether a VMA is
> lazy, so that we can avoid modifying all places that dereference
> anon_vma. Reserved fields in vma could be used to record the root_vma
> and a reference count respectively.
>
> Roughly, hooks would be needed in the following places:
>
> 1. __vmf_anon_prepare: mark lazy_vma in the fault path.
> 2. __folio_set_anon and folio_move_anon_rmap: set mapping to lazy_vma.
> 3. rmap_walk_anon: handle rmap_walk for lazy_vma.
> 4. folio_get_anon_vma and put_anon_vma: add hooks to distinguish
>    lazy_vma handling.
> 5. anon_vma_fork: decide whether to upgrade pvma->anon_vma.
> 6. Add a hook in try_dup_anon_rmap to upgrade folio->mapping.
> 7. anon_vma_clone: handle links when src is a lazy_vma.
> 8. vm_area_alloc / vm_area_dup / vm_area_free: add VMA reference
>    counting.
> 9. mremap: handle upgrades in copy_vma and move_page_tables.
>
> If this can be restricted to apps only and the app never calls fork(),
> then 5 and 6 could also be removed.
>
> If each page's mapping in the page tables is synchronously updated
> when upgrading lazy_vma, then 4 and 5 could be merged into one.
>
> If lazy_vma is restricted to anonymous VMAs where
> vma_mapping_base(vma) =3D 0, then root_vma and the VMA reference count
> could also be removed.
>
> With this restriction, we could directly use folio->mapping to record
> mm, and locate the vma using folio->index, which would simplify this
> patch series.

After looking over the patchset I must agree with other reviewers that
it makes the already complicated rmap code much more complex. Adding
this into GKI as an out-of-tree patchset is an absolute non-starter. I
don't think you can refactor this logic to be contained in a vendor
module and without affecting the ABI, but even if you manage that
somehow, it would be a maintenance nightmare. I would rather spend
time backporting upstream-accepted solution than try to debug
unexpected custom behavior down the road. I believe Lorenzo's solution
will have similar memory savings and I suggest we all help it succeed.

On a separate note, it's very encouraging to see more Android partners
becoming active upstream. For years partners developed optimizations
in isolation without engaging with the community or sharing their
ideas. This is a very positive development which I believe will
benefit both the community and the engaging partners. From my own
experience, learning to collaborate upstream takes time, but once it's
done the experience is very rewarding and oftentimes even the biggest
critics turn into supporters. The key is to listen to the feedback,
ignore harsh words and realize that people here ultimately have the
same goals. So, don't be discouraged by this experience. I think the
biggest mistake here was the lack of prior discussions or RFCs for
such a big and invasive change.
Thanks,
Suren.

> >
> > Thanks
> > Barry

