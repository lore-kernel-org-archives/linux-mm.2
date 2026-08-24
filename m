Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C55EEC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CD66B00AA; Mon, 24 Aug 2026 07:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64926B00AB; Mon, 24 Aug 2026 07:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7CD46B00AC; Mon, 24 Aug 2026 07:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8776B00AA
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:26:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 446221C1B1D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:26:43 +0000 (UTC)
X-FDA: 85135935486.21.49BA8BE
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5EF2F80007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:26:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hhK73oa6;
	spf=pass (imf30.hostedemail.com: domain of nicoyip.dev@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=nicoyip.dev@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787570801;
	b=pj25uKJKEp8+HMiMlCmbKFadzwzMSeabBfSOtYxzVoGoV8XjyxRWpEgTaejNmWkZk+PsH8
	cS6nKiZmSm9A+3ICQV7olqvX4mkeLLPsOIwANMhU/VwCPGga3rJXcvkcXMz6IjDgKXgeol
	gdosSV7gzReNZ2QuGS77sodeXjDWa2w=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hhK73oa6;
	spf=pass (imf30.hostedemail.com: domain of nicoyip.dev@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=nicoyip.dev@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787570801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jQhGWzkKSaiEn4reGO8BqZW7gZKqXxVsZuryAY63ImM=;
	b=1dlsDBsPgYJitcG+115SoitMAydxnV3pRydEJ25PylEagcytjJGW2pOHopJBbYAKyWZd+/
	lO4OjvSupsxNs9YDFlltnkjgEYE7GeROAYQVzd4xm8f8ez003dp3UXlDDTmcAsZj3hjk/d
	21+bbmr74z+8QoZ/zxs/MwsDf8WK0bQ=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c16879184e7so27998466b.3
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:26:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787570800; cv=none;
        d=google.com; s=arc-20260327;
        b=hycmsdMHEbjwPceXvxddmidAyjPZf3dGPFRDOk3zGVKbUkvaRAB2Am6sq6p3IqlFZp
         54dcI8wD1jXNVqJIvNmq9p7OqQ8Qz5d/cEji+8k1fSo/9dnfNiL0Lbcf6JWT4f/SmVGR
         FLaM32EmRVfO/+ssQNYkVy6T31Vr9Ugz0lgeTYNG9uiBakrVu7bY/8x3AvYcMfn+eyZN
         TL6nfq4D6QU7xOFEBJaXmgLmHgO421EVffVEmzEVQF9dcKJBcoPKQWN1fSMo75/MO5d/
         hWwSADlGo+qUvXdD9LBM80xyuw8XJA3B3ILIhMdPhJFMXPkuUASSmXlrIy+fEdMpiaBF
         rofg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jQhGWzkKSaiEn4reGO8BqZW7gZKqXxVsZuryAY63ImM=;
        fh=eczIuT73u4kNQ6bQmzoD/5SQSjPEU9Uc0LDFiAJ+9/M=;
        b=PBLv4tdLyL/WVvAfWfPx4FWo1yt/ZZyWbzLSOp8RmTM4JpExmQCcZuEz+ddVypwOSS
         1vcDF4V87vVW3I5RAilhI70gSD9M9W2kSxm4gAeXjygDaG+y4CwToafFo/XArpZRXZmQ
         ToxWTwRVAaear7SMnTdNX4cXHaSXiEPG3U1NThFnM6HLbkd0KxIW8Md9yML3Mhm84cXP
         7OmRCjH9Un8vPbdLrWI3SdDOTEnZYESK/vBFn44lbb3SWrQlWjJDJrwTzlT62AojhPfJ
         aKkU8HP9/02IujQ9R7ciJ3cyJ3XefTEvKwDYXANHujSY9S8FbpwHuULa2uHNo4a9y/Lp
         8brA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787570800; x=1788175600; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jQhGWzkKSaiEn4reGO8BqZW7gZKqXxVsZuryAY63ImM=;
        b=hhK73oa6gQGMGOw4isGLg8bfun93VwTFbxLq2a1Rz+yDXGkI30VG+QCGmqDD1tooem
         vAFRM9+iAp50uYGTXdRDtJ1vehMkX2U/lrEvNmbPfv1Ky2/ants2hxz5Fhh6jcRPDhf4
         NDD0/Ak3IaqBDaMRYsNIUoTiIBcS1IqWrL2ZKDKDrv7Seov9So2HSwZQnb8HS8QRevJM
         snO4iQ31n2AofkMFbMzP/lxEzQvQT0TNT0dSeExQwXzjPhxvGi16QFYSzEU8i68+TfsP
         AcGS99GY/ovzEirOEIH7M5Uh/w48XCD2vmJNa1AD74RL8W3fHeA5wGmcKm7rOxhRDhG8
         p4uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787570800; x=1788175600;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jQhGWzkKSaiEn4reGO8BqZW7gZKqXxVsZuryAY63ImM=;
        b=Wh5ReGt11tkQf85O4Ovq+ZGF/Q1qvtwXcDhKrnX6y3gkJONgao54FzAkU3xkWsUeMc
         a6dac1MU+1tKfNWOnYl77KYdd9EHLrvkY1h5nN9nUc6sLlgV33LjCvR2NUmTjP8RRydU
         xoaCFuF8sNTlLi9w2BIJtdGpfkZdURaBfn1J2IqDCZ1ZYbVBKxcy/74eGzjAAdyl7iio
         mnBuRoclbUYCD7g9iXwswxsp6HBUdc3vf9cU8o7X/G7w23ZbDvEJqYQEGqYu0XIv6zVf
         4SUFNA8/9ZHlRVUrIR5ejSXatZDYz6qdwr3OBoZ+Ih3uh+6oJrOhZDaD09UdTzmBi4DK
         086Q==
X-Forwarded-Encrypted: i=1; AHgh+RpAlFEToM1BXdSSOLnWSxJnIu8da+m6MRWjHH7bamDPhNBW9zgBYJPGgVAqHPfvrpzAz0s/ye8Arg==@kvack.org
X-Gm-Message-State: AFuF++m/ddBx8J6ptauV+kCjSjGStQc3oDTodAKcQD7UlbcjCYeR3iZK
	oBwl+xDCnp0EhO3OAnhHgbbV/PLBaX4Wba5slQOTdjPgW9mfC1QcViVOzehtGFeoRsXTzHhg5gj
	5RymN8KGnjYPZOAUEe/15HfdZAYEx5xI=
X-Gm-Gg: AR+sD11/7UOkSfiCX6MkQ1zz3Pb61dkrZ26QROZEjDuvJzv9nlyi3uXH2mORIoFIXbD
	3HL6q8rGnh7qZFVVD2YNeDJ8Bn5muLizp7/HQ9ZtmnWx6A0q6vZLCWrYm7AccbxtoFDFSIbb2Rn
	jnyBwk7tjlqXiWN0n+jMthmNjcZ+a/WG8qW9I+cMw+K+OIg7z+hvb6+YrXNKKVOcbzWoYZx6yiK
	bguEBtq7Z0GmJNDfnhlsskfSdE0/z49feKq7xEq54L8IIK4ihdbwFukMeDSw/+ZsXpqQpb2aVc4
	SCXYKNKWm1mPjkGUeB2UABaoIiUMtxRo/Pkz+BadMrrhKJ3OLL4NtQEi2m2LkSSmIfp9FuChVQ=
	=
X-Received: by 2002:a17:907:1c26:b0:c21:8555:5f55 with SMTP id
 a640c23a62f3a-c246a65eda7mr1686296066b.2.1787570799606; Mon, 24 Aug 2026
 04:26:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260822163846.3747787-1-nicoyip.dev@gmail.com> <5501d110-9f04-4a61-b0d1-16898910eb93@kernel.org>
In-Reply-To: <5501d110-9f04-4a61-b0d1-16898910eb93@kernel.org>
From: Chengfeng Ye <nicoyip.dev@gmail.com>
Date: Mon, 24 Aug 2026 19:26:27 +0800
X-Gm-Features: AcwNN1Wccqw0xEpAVNPC31HL9r3NmqSdwsB4IhFgkqOaIR11op4Cw25r1k8pRgk
Message-ID: <CAAo+4rWuTAy8Tn5NuixTmixuzYw+Xr33bLtzoOLF1Nmo2f820w@mail.gmail.com>
Subject: Re: [PATCH] mm/ksm: mark migration stores with WRITE_ONCE()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Hugh Dickins <hughd@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5EF2F80007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: nwfay143xrjksxkttsy3r5bg5hjdch8w
X-HE-Tag: 1787570801-549039
X-HE-Meta: U2FsdGVkX1+o0KQHJMcB/EOSk/jVbQLDjrxs64r8v2OcRJJux92j1PXa08FivrrQhasvYksoK8/7gWSXwbuT0WESASCBgx6DDzNCMTS00QLZHqs9CXy1Dnyg/ele2x4THAT2Azy2gbc7Aa30y4M1/hL2VhPopiwPrhcvhd1SbDsC7tbyv4w+fKkI1wcujSfeVZBXC8gq/E/gbnS0CFQGzPRbpZW7tzN3qIxA0O5mkY2ME1nH5BKH80+b6+P6eJMJ7Cgi9pefsoVTVXm2LtkOxNQN5XNF/ciTs8gh/XRGxUY6/skH2BRo/rOHw7hMLf4csx36xGTmOfHNGJRIvmUNfANDCrED0MR9q6rYEudZBeu5MPCST1K+NtBucNpV9/J+Xbv/C3va/4MLh1r0kjzws0ytlmSQ5OfVS81/ni6vSGcSCOjxffvmdfdHHexYdnnf4wiph3Bvq49z02/c8CsKOHBGcGl9a0Mvq7VW7Zb6k4L/4moS6pboYBDOU1byhulRQwC0GTgSL3EaQDvei/bUgPNdwOpbhIjLoP9p8r2rZsBt54VGlK2yeGCCrv6GwQ6tJS2rLrJagfxyJBm33bsVKtawZjgMVtqZwiFjkGF+Im7+mKNVHhevTqmbhK9Ef+sMQ25r6DAKnQNviC63wj2jsIhKKC8FhKXQrLigmCsTk2MiJnhutsGzz/6+XImDPy3fGyzErWqtm6W0YcEgdJeZSJuZadsKCMlo/iPpGrAMpGqfnjqUtRqbh3RsFYA5CLKUVOzJkbL3ZkGFD16C+9oSmMG4L7Wp0srf9vItJB/NcND+3AnX91ddoosF4FDwVFflq3rzJLVupZWdwZcquPtSz/0ldC8XoFsfQ/+1ChHcbsEotqteehZ7ZEgj9wvzueZpduZvzbm9EUUeLTYmgT4poSNRusGGLPEN/mBDkk3tzXYuktAjCUT6w7knkLqDe/iTCtRfbbEIlUe+nDvCuAp
 ln2+GSiY
 O9v7s65l2Ay+mgyidSkuklbhnABOYItDj4+rNWbncgg1qidZSFt13tbPFZGxlweFrXVOtgpSVuZlRX6vBigAId1lrv6KkED2m3pVvLK+rY/pAXl7fkMq/qmpq4fRjCIbAUbY//IeQt4OIy5sFEh/QLfmOHhcN+mBTwwyzB2tcqJWqncPbM/W9enZ7BI5qRrjN4dQjarAAM3T5PsO9gSWA5E4p0ukI5I1CBTw1i8GB0FH8t0soqvjNUmQZ5Ri/45K4+wRduCsyk715CTcFFE2WspKQAmK16BmCIo1t1qWiHRTsROBW+MJXVnu/UczfiwWZZkf+SR2EJqoYhf1xzGqL5zTHQ6Aq4BW7zkCcaw50A6xE/mG17guS2MS/CCduLx4oxZBc5C6A6AWXxk0t0tZYcFH4pXZS3SN7JtSHa/PYAJqLeBZmK+kw560q+eEjRxcJERU/zsURmcsI3XBj9Ep57QoKPHzl6guDpXRKC3PEo4C04/Qq/6aGUn+gq8Shv6slvRkf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 6:39=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
> We want a Fixes: tag, can you dig?
>
> I am not convinced CC stable is warranted ... but certainly wouldn't hurt=
 here.

No problem, v2 is sent to add the CC stable and a fix tag. Thanks all
for your review!

Best regards,
Chengfeng

