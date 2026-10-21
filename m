Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911A5606A336
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 05:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FkfkxB0Q
Received: by kanga.kvack.org (Postfix)
	id ABC736B05F7; Wed, 21 Oct 2026 01:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D3F6B05F8; Wed, 21 Oct 2026 01:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95C916B05F9; Wed, 21 Oct 2026 01:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F5106B05F7
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:47:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3266402E2
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:47:07 +0000 (UTC)
X-FDA: 85345550094.05.B3236F6
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 06ACE1C0005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 05:47:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FkfkxB0Q;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792561626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tSn2dX29VgDqk2hgfuzvCjkC5Mz2yIfzdQjrFRKGhV0=;
	b=ye0HzTda2BWLcMuKbQ/wAA55IiRsjupypPizS/fsqff7tUerDaMC8eYSJM233iaju++A2P
	QZVEH2qkZm4L+uUN3Z0dxYNCNunYiJ/eoApGac9Vyb/4sAn4iOBatIwcrPqQoCiVVOn8pd
	IqqbglcTl2tR0nuk2IO5401PR+qhyVg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792561626;
	b=JpjU2lz9y1wyENs8Oc6ycD0v3wJBspXwQ6MtEe9ApvCvaLNBoWnlgxp0mYQJh+QDJ7Gxwj
	QWKcc7BdldHFS5F/yWARLR7PSFyAt7p5plTmRCPLOWeFIf4IcnrFSrfkdU/Q3K2U/3R2uJ
	5izBlpwlcN5vDLkUmoOCkT3beLRuP60=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FkfkxB0Q;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-679334baa1fso292405d50.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:47:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792561625; cv=none;
        d=google.com; s=arc-20260327;
        b=ox38DYqRo74WoR8na5RegyWAlagt9uEnSV6f4ZQT9xpXRk/fNFlCy2+GFppIjHGpAb
         FRtP9Zo0AZbTBK0kJn2IlexMbsEyOXEXVRmNtlkuEY2OIhfaJ17LWrPtuW6BC5X3dz4n
         BdC8hLKaPKjaY5FIV0Qo5BD9YX8NWp2898KR9aHhF63/XxHTkeKcewez8B8R9Agj4Xld
         kg6KVq98ryfDEQaiStzPzmUORh1XQsL5aYl7DXU+8B8aqSeeKdUK55Lv3SuOq9ceBBRL
         UjP6rniqAjsZ9w+U0GHQ1uG5JAk2AQHvY2j51WCsQY37HK8NUu9HE3GKDSjE0lynxyVA
         +3ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tSn2dX29VgDqk2hgfuzvCjkC5Mz2yIfzdQjrFRKGhV0=;
        fh=DfEQXTPbwHY68/bd9C0c+9xx4a1qa6wYEC1wGf9dajk=;
        b=fsZAGkcBkH16dt61XJn2CXX3uL317vCaoMjfJZ5N1Oyx3hTgTkSGrVTlyEnck44B4A
         MU7aQPioSm05YSvs/BwwqSouJQLgXkXX9jwGkQrPR2lASO9Vg+sDL6EFuEtJ+Gqv0qCf
         9UW62QFQavxY/XUZrFpSaXpA/YouIitcL1M1wGMfAzh6/nsq91Uv5YxCrOWGIdp5g4bD
         BlS9xolk2JDXtASWuBHry0XYalLxWB/06ssT/ZLPeut6tMwNBpXM2QhlUpKqiyQxA7cu
         Ij1zaDGuWlnSih4cO8c5/vWjXjORuqtFh5cSRbdSkAj8/scsGR3TLsrBlWZQlk8h1ay8
         H2Bg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792561625; x=1793166425; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tSn2dX29VgDqk2hgfuzvCjkC5Mz2yIfzdQjrFRKGhV0=;
        b=FkfkxB0Qh1kjUpAeG395pcYI613F/YddqosLsHNmM2+mQ+gekvuxGER+3QduKn7p8f
         vcRFyl9zg3cUdsHuPv6cYE7zYQpb010b72oc9CZO720ZZvuAEXIlCd/uAaRtisdjpCpC
         +8n96fNXAUK/PxBZnyaC1BWNvT0vMiXTXRfkfmXKvf7yCIlNrvMfInbYiwkmOsqxQKEi
         /BM/UGlwOedb5O/xOcY7hAbHJX3WxGBecQRcR8ui8FEI3xFtpwTb8+M2NVgodAZRo0/G
         dP84DESXSjbCJ1DrBnNZGphrbFuPTE6IC3S/mN5IUzW3jYtG+KBh/aEGlX5C4Fw5W4Lr
         RpMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792561625; x=1793166425;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tSn2dX29VgDqk2hgfuzvCjkC5Mz2yIfzdQjrFRKGhV0=;
        b=cDPzi89PNnvqYaNv//evrcyIG8IFSRQuUkB9NuDrWEy7xb2lXE+yn3WZ9z8Iy2cr/U
         IpT0Bup0ZzedmlDx4JA8zgu5dC4Byw/krDf6p9d2CpqhTH76rynHmzNxM8YNYLtiZx5T
         2e1xQap/AtZ1TGeQTAviBvF7DBKs8xsMsZk9fejpPYgeCndNa4haQzD66En+D7WdUFsW
         ZLatVxP5uCTCcIgNGbMzGJY54adRycnnv+73c9piIUOxOFlk499STGI1HAlY20mXHSgM
         2ZhBe7mqV9bTB8l81lk+U1LVMRmrJhvO2rqptkryYWPEgxVfd6dzj8PMaejth0R4OfWp
         Jcsw==
X-Forwarded-Encrypted: i=1; AKwUvBxuIrL1pRzuelYrPvGZFvc9avn2Mr9vEWKjfCM/ItH/8ytuuM3fmDBqDrZKmHecwYEJmsARCj4B3g==@kvack.org
X-Gm-Message-State: AFq9FYIVqJVfQA0mdCIxartuegYemE239yC1dGwYmplVIE1Xm0wshwv1
	+t3+OPXszrBwf2cQ9XfdtSMjSah0QTsmP3so9w/NdwYtYbkmiI8oPCTCF9Tdjq47OXmRLWVBfBo
	ZINhMa6DCotpnTrfS5yah+Si4o25YQmc=
X-Gm-Gg: AYBFou0MuBI8YqibWYvaXbgOiLtF24HACBBSwlEoe21edAsqsxFwc2zL2dBilGA/VeC
	c7KiPeXko+/BY1rRTipkS09XNhNuQETsgs4YjMMc49l1nJj4qzQZ03Pm7Ev9Rkoc95n4aU4FjgT
	+wDWYLeZFU4nf26FMnR84WeI13ckWhNEJVocBq/DcEbKzQsx5VFeynLOzeKW31UMa8dbH1204Mu
	p3gRyfrLozNdVFwOwXCwVmuoK9bzMRO476WfQubUhZq/iUQAoXQPdsMtwg4XG5zM1lGI9khseA9
	/oeIumhtnOqJzfge5/mMwXmW5Cni3I8hpDgJYpQpZfAXdtX/PWZqjg1rJjWNGlkN6BNKKZ89P6/
	9/bJSZy/EAXaXCXsAPne29RPB9IHpDuLmfg7b5n2F3kVrE8K6xIgSuh51BEDLPYZqxxpRthN5GJ
	4LmQObbmth+DTc
X-Received: by 2002:a05:690e:4390:b0:677:a7ac:5624 with SMTP id
 956f58d0204a3-67a0e4bbea1mr386088d50.44.1792561625107; Tue, 20 Oct 2026
 22:47:05 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019064157.29885-1-laoar.shao@gmail.com> <20261019064157.29885-2-laoar.shao@gmail.com>
 <179254940965.1919196.7604748267690139512.b4-reply@b4>
In-Reply-To: <179254940965.1919196.7604748267690139512.b4-reply@b4>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 21 Oct 2026 13:46:28 +0800
X-Gm-Features: AclHuK9yUw3q9bz6eHz4oS9_OplikvSYcNJ_NBkBIXr9uF4A9eTzN6CgKR5Bujk
Message-ID: <CALOAHbD_1rRWk+T4JU9gbQpjCnf6FnKmnj70U7G7CgWXdp61EQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 bpf-next 1/5] sched: fix stale get_pref_llc() stub
 for !CONFIG_SCHED_CACHE
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, 
	zhao1.liu@intel.com, tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, 
	bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 06ACE1C0005
X-Stat-Signature: 6q8x8q8tuqjn6sxmw1c994iatr86bwkf
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792561625-789015
X-HE-Meta: U2FsdGVkX19ODDThI80q5C2xIAKRu7cSN2Ct/bI23Aw1cMpKV5tfO9YvU+r8DNY38LvGTdBFGMbPTbOxjty7gFRGZHj/uYpTdsbmoq63WlXwP++/6gmmCtCqDbWMtHktPZo8Lr/q6RhIzcSR2ujShAOZLsPQl3TcVlU/R3XriUWNMUJFuHT4z6DEY6b6b79vI+1zspWJZDFUyMvgayr23viA8fXTm94fFBTTXo+lzsyUdL82KfcGpPk9aSgQxXHrRoRdcl0gJM9EIf3WXawQRBVGVLMmE0keh7X12+2/qETLkOwXKRd66IY1yQqjwpNw0ZQTGOtSurn3XmdJhh9zAH8sTzc2SyPe0OXXXYBAlw/M8e/K99mlH3Mt1aGzjDw9FDKpgJn+G7wKqBmCIzfjX37Zd+0SKSikuG+UcXzPgYT08f5hN9bALWSP+nzfXGmolAVpQ8wp8QO5xVxE/+VAX2X0pLIWpbB5ajhxsJzJPq/lz006i4vKtXb7rsJQhAq8AHwAQGu6xMqbcPIcrBqrIqWv3PAmtbFbF4cn1FzW/8Vzx/41stZd067ClpdS25zlLScVs06gU8rQtKJb8waHdhlfHt8LsAKHsXvyg/DiX8QHUei2IsFs8PoTOCWEZFOdNlPA+1VPbAmlWZR3uYpSdOz34CnFLOfcHv6IDDMwZJAWVYRlPEnaQr8FN4S5TblSQI3Cf/LshFXptI0n1sZLdRrQI0fuXabm8nSH+8wWdyEBmkEjAfPVD1DxI+M8DJdBkIg/tFj7KJ9qk/G1YAMC5CsLGzkHtlNC+Hjd/CeohBlNciqUHNgTIly1gYb9RO1ssI0V3wU22Bwib5W72BtY0cDFjCEG+LkwXK2aes1Ey3SazD234HFUEQ1eVEzDt+o99+ZRJqZOQV0bJ/Q6nKgRE93/5ecPIKGIZ7+NWkxnwdJHan9UFXhAvkcvzDUDh/P2MZNUGsVJe7nNh+pIW17
 tu5ZriSz
 BRRuwKe5cE8893hk9z9I7PNV841r+XLGTIOnE3f53PBCG6Es201QD8DTPBC8Nu2FgqkYzDIKMV7SmpQraO3aaM/lU9KSpHlm81LoButQ9eMZaQo9+8qRDdDGDt4ZoXNTwM0Z5JQgA3J938SbSCXmX+T56REMxR+CHjE/TYcyXYXpr1MYGRN7gd+R1Ed/Xnzr3VBVKMUJO6L/o1/p9ldUOT/FkWrv5c2V33FVuvlG16N3W7UK/49nYqFuGqE7EH1VRIjzt3MxylyB4jg+cYAw6zV9ANc11L2JskXTOjeyH2LTtHWnVnGz1a5BhJDm9Y6xP7DBG5WSy9UbeqnzhtM47ORRn4pBhLzp2IktIcLkLON01Dr18V9ffoXHfLYlZ0L6PUGd6HnFUBBGVh9m1XJR8UGMQmBSLGj364Wpo4DKfa1TmPJkVUbUn5aKCXqh0doO8eXVvd7w+M0bYUIFngvQ3Kv/8e6pxq7NgYXRWU9ZV8VCwcKiOJRPRodyEpM9oljIa15AV59meLFYPBY/+QYZOtNcP7a6ZGQ9Ih9rrcEt1hTtwZq7yIyW9WpdBGGCCcMUbbU4/Rcg9VW+6CJQSiyDjwEbZIvjOgvyALlaQpqwFjAS4RQthhJCUB6+xQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 10:23=E2=80=AFAM Gregory Price (Meta) <gourry@gourr=
y.net> wrote:
>
> On 2026-10-19 14:41 +0800, Yafang Shao wrote:
> > Commit b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_g=
rp
> > to fix UAF") switched get_pref_llc() from taking a struct mm_struct * t=
o
> > taking the task's struct sched_cache_group *, but only updated the
> > CONFIG_SCHED_CACHE definition and its caller: the stub in the
> > !CONFIG_SCHED_CACHE branch kept the old mm_struct parameter.
> >
> > Fixes: b636fef85bda ("sched/cache: Introduce task_struct->sched_cache_g=
rp to fix UAF")
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: Tim Chen <tim.c.chen@linux.intel.com>
> > Cc: Chen Yu <yu.c.chen@intel.com>
>
>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
>
> Please submit fixes like these separate from your series.

Thanks for the review.
I will send them separately.

--=20
Regards
Yafang

