Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5653C606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Et9OPNf2
Received: by kanga.kvack.org (Postfix)
	id 79B446B05BB; Tue, 17 Nov 2026 19:24:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74BA06B05BC; Tue, 17 Nov 2026 19:24:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E0D6B05BD; Tue, 17 Nov 2026 19:24:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 449476B05BB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:24:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C805CC05F4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:24:09 +0000 (UTC)
X-FDA: 85446342618.21.F23DA84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D6DCFC0008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:24:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Et9OPNf2;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794961448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u6oWx1ny/i9E9ms2J0GDi4d3fbg3mrPP6JGKuvrVaXs=;
	b=6y9w4k9HoBfSTUIaalcSjraIYf9b/sBDAY+rUaHJvA9nXCwO0nacz0dgRx66wt1AqyXHgw
	60oJtkqDBf7haKFjys49nQoNjxKTHOHO05cdOdTdTSADPLvmX07y+NVzZN0rlWjSB3SawN
	FxsJyZ2/m1M5hZU/rwzJfIJNLGrEdNQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794961448;
	b=t7whZYk7TipeXkuN1giPvajYrKD2Dpm9u5qN50TDX1z3fWda6kA372l/R0mdyW1IFFdVDP
	Lda64ROqEd6aPwCXWvRAR72xELMVoiE/IV7udMJVvNvDXteNcE/eFy2iLPxMPRcIJFV7b1
	5N3t8vHxJ4OEhVD1l+VUikp6f8nXugA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Et9OPNf2;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2470043743
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087971F000C6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961447;
	bh=u6oWx1ny/i9E9ms2J0GDi4d3fbg3mrPP6JGKuvrVaXs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Et9OPNf2+uEThknGo4NZ5p/dqjt9wBSm0zYWdAuk1PpiWLmyvLOUiBpeQYGBBxVgv
	 HxVZW2L/zeqdRGuPQwPAybTFqeFBOyQdEGMjhWOmiVynGBQ/CBM95KJoz1KXo3wOfH
	 VLs3ePMIgImnHtqPlidYtKYhjcHwBPsnoU+d64p166xMXNTOvtbvtm7/Zag6vJqO//
	 9MxuXdB3AYxZU3w81YZLi3hUEGpvjRxTQ2jGVRgLqtLj7b4RjDLO7Ic4BJwsFh7wt9
	 6OtK4xQhc/AMUVa1RCIHj05nHKhXwFnsDb8iG0HNsir8cIhuiAwh1upw/Rsr+wqNmL
	 JQHBvNsCEd7pg==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4d5b2db4bbso75188966b.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:24:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFEfx/TMoMKzrmlIcgIBUy6B3I+ZkKCfgmiRGWGJbrz1TWiNDRaUOYC6tuiX7+vb7v6Uz7rgcvuWA==@kvack.org
X-Gm-Message-State: APuU4Z8jHlxnCcKXedRFOUSNBeoZb/8IROtDN17+n9bC6PToOFzxET4e
	/mrPgCd/7vh8e+0fZtmmc3lCcA3DVcywqtTrzg9SrE7qgsd/1VfeG4FeIZ4unVAlMOlnq1vL3TU
	esXggwSQnL/TUEIBdv/wNUOZqK2vg/GA=
X-Received: by 2002:a17:907:7f87:b0:c49:9247:9688 with SMTP id
 a640c23a62f3a-c50f34ecaf9mr367492566b.7.1794961445932; Tue, 17 Nov 2026
 16:24:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com> <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4> <auwOBaRtM9p_Wxfx@google.com>
 <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
 <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
 <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com>
 <CAO9r8zOY1E7gCYnJZAfKvyHcbj8e2WVuXMqsaPGPsKR4-9itsg@mail.gmail.com>
 <18e53459a8013078.3137322e32332e3235332e313736.12c7b6.0000sendgmr@google.com>
 <avVVRYkIAQnLC_Yu@google.com> <18e8fb5c1c4d127f.3137322e32332e3235332e313736.289d37.0000sendgmr@google.com>
In-Reply-To: <18e8fb5c1c4d127f.3137322e32332e3235332e313736.289d37.0000sendgmr@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 17 Nov 2026 16:23:54 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOtL4t5pwQOE=SAWeg=k2TkhtNXgV6CJJGNTwuTebKpBQ@mail.gmail.com>
X-Gm-Features: AclHuK-0l1x5Ka17FQb35YPdKVq1Bx0JlvEgDxgD4J52JUsmFJaic8A5SEFngsA
Message-ID: <CAO9r8zOtL4t5pwQOE=SAWeg=k2TkhtNXgV6CJJGNTwuTebKpBQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
To: Chris Wiseman <chriswiseman@google.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Xueyuan Chen <xueyuan.chen@vivo.com>, Nhat Pham <nphamcs@gmail.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D6DCFC0008
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1jio7bso4yabr5r7dswzhc5f8d6fjrib
X-HE-Tag: 1794961447-507590
X-HE-Meta: U2FsdGVkX18VKzHxWXymjd/2m2pFV5RSLxmhnOQ1jng7Np6Poe1YcFb0wLBSji8ZAELfa4xmQqpOT4Y934pYKO+sPlJCro/mDk9D/fTocNFXYZ3ZNYexbVZnFshuhkg7wfqzNbdDE+GJatgxZ6nobQ5MHcB6k9cWgn7e+s4j7845MGFqOdB9mQDx229chkvOnhtXt7ovSeV0QWPL0d/jQIwA0lK8T72D0sTuwoyuyRjHf/fHjz9wrr21QOZgKwwgfEh+dpP47R+5W6CIDox+KWfuT3du7BNPJ7wO6clFCxopsaKn5ZBBM2UqG7Lb0eN9q++qJ9ePhtKsQPR+RI+1GJdsZH4G92goBOzO5b3Ey0+YieRB5Abe0iU6SPD5Pt/iZ2Bg9H97Wk34mg+2aHz3WxVgv10PakQfDDV3EzPmKZICOkMgNVhJWfGpvwoa7MT+x0PgLM8o19C7MiDj8EPeKp2aMiSKi8404AfF4TLcxdo/oCn19LFCAk/meqR4aiq1APlHU3Q06c98A9jJx3zC0r4kSGZG2EjBm4AtOr0a36o8OnU+y6ixB/u7tU4UTVzyvH2oyMMhBTY3MlEKfvOU0xxqxrQr0lbviclUeSwBwZXTobfcsvn7Mh9G8ZGMgTQvow+vexiaIDPYvGFa1nUqO4oY+DSP9J+C9PHur5CIhUWNFSrsmlN4N9Mq83XfBaH9Ou0eTapxwRNFLwiLg/2Z97o0wlD6bZFnpqyeycaiWeiREZKY0gfXYJ0qgqWDQrRJEwNphdMJSrkBCzBkn5mb7sPoYoSbsFa+qL1RBbwvSssKzuP3N68lrmSsWMG3vv9zSEwgVHy265fx2+2U8X8/XQWtOos4AI0nzqtd0kqKUgJ7YljKD0OxPa3GVJZWyt8W1Q+Xdncjc5lP0MAV2rVNiiJaKKYl4BpamYA5puSR2911R1qRucbjJJqhatuKyjCH6kjIH3YmM/NNJCa8omv
 jpe/Yk+g
 0ZoWA7wTKKZW2Hw3Btyj8KXXgqHATW/mJmoROl28Pz4exszYbWGjNMg8FEZowp2B130GEhy1RsZOQ9ZiJckvV1HvYLW27l4Z81zhenKUPA+ncUuSgZXyfgMpk4SoXaB4dBFb48/tNZ2cVNODnvJt8TSL+VLIjUjPn/PbbPdrXjo1Lrp0nbFvVOfoPxe+6ZCLVDaic4UhafEBZ50JPOLMDCn2dOGfgiAwjcKEFqQVuW50gYxsdOUUerJ8CPGrPKiylWD6ciaGC+Df5/X1RLxjeX2zW7WaftKtCJw1Xtk5HCruYQ3U5PubLruwW/eF76AEt64M3DuCrVAiWGT3OdaHDbjlHQtR00J/W3qOyFIh+x6zF5mihqVah4LE4KvtA19UGPrU6e2vwKCrAitYghaobp4j83Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 4:13=E2=80=AFPM Chris Wiseman <chriswiseman@google.=
com> wrote:
>
> On Thu, Nov 12, 2026 at 2:58 PM Sergey Senozhatsky <senozhatsky@chromium.=
org> wrote:
> >
> > On (26/11/05 16:53), Chris Wiseman wrote:
> > [..]
> > > Maybe we go with Nhat's idea (CONFIG_ZSMALLOC_SHRINKER defaulting to
> > > ZSWAP_DEFAULT_ON) for now, and if zswap adds a proactive compact knob
> > > later we can just kill the shrinker?
> >
> > Sounds good to me (on the zram side).
>
> Thanks Sergey.  Xueyuan, are you still planning to send the 2-patch
> series (CONFIG_ZSMALLOC_SHRINKER + unlocked zs_can_compact() pre-check),
> or want me to spin and post it?
>
> Yosry / Nhat - any objection to starting with CONFIG_ZSMALLOC_SHRINKER
> defaulting to ZSWAP_DEFAULT_ON so zram users can turn it off right away
> while we decide whether to drop the shrinker completely?

I would rather drop it right away, but I am fine if you don't wanna
bother with zswap.

