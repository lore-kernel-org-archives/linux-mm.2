Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F1A0F8D753
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B0F6B0005; Thu, 16 Apr 2026 11:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E4E6B0089; Thu, 16 Apr 2026 11:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFD2E6B008A; Thu, 16 Apr 2026 11:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD8186B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:10:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9430A1B8C8F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:10:39 +0000 (UTC)
X-FDA: 84664755798.02.669B73C
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 89416100012
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:10:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZHsjKyBk;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776352237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3XEBxqMWUDBsaapxLN2EkFmNDcbcrBGu5uflDyv4hk=;
	b=jO9xeA3DMQoGWs2uUTB2D4EW2L2x6d3njZCDU5N0cx6Fjfup6cs+dnfjB+ZjXfBqE3K9/V
	Z/UQwotkZ3kLsb8NodzEh86KVdpSUu3Efqtm9EXWTlCGtg2Bed2uqjnzJNKLG2fW5TPZNl
	eUnNkCqFnUh62BUpaAJ7mSVMLqhR320=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776352237; a=rsa-sha256;
	cv=pass;
	b=g4BcKC5d02NP1kioFB6WkW8AJ2TD/VBcHkEi//7JiSji2I9h+3kbBa2sjJuuOFnqE6iI4y
	NHFiQjW9uTJnY39a/INzf+V7YUG0phThsXXHX+JOjPAjT1fUuwXx2rHMMaE+L6poiRfihc
	t3t3vu776XOwrNGf7GmPPk/C8+cFvkU=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZHsjKyBk;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-79a46ebe2beso84876257b3.2
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:10:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776352236; cv=none;
        d=google.com; s=arc-20240605;
        b=JYX3fIiV22oNMu7LXrVlSzEb6vGXs/dzsnJqlLG3/ottScp7lMnqHwDkC8SPFnDH3N
         Fkx6pcMVvn3iocNJAJ3TJtAdzi28mufrINv79RpA0BVyU0txn1EGxyi/f9lOFmqRD1HX
         iT28cDqDi6941PNDmzthY/4Ss5iZhoMdSUVDhZ1WeyrB0QJWbhijSTRAWD+CLZvjsy49
         ROnaczz0g1xl6Hi63Iyp4WghKJMpP2vB9K9tWMjaOgfgNj3lH1qQh8JOBI1qeOcYYq/e
         ONHdmNrvB3me2JsC9ZGvA2IwfP2Hb+UJxM6V3djeWq4c2WWknWGB/q75SS1SCblmzL+o
         gOhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d3XEBxqMWUDBsaapxLN2EkFmNDcbcrBGu5uflDyv4hk=;
        fh=S2yND7mb2yGQFggx/GlcnzzR/bHk/R3w8zWODHEoAro=;
        b=aaKquVzjhjXA9IzCn0nqkfNEaC0aDE3YTnLqUzvpg2fd6/kDHYTwsO/Z/LxsyVOB8w
         hh0uTxhKti6Els1W9d+Z3E5niBo+3ZXTg2SRTEbOhLG9gkEnuzjbKQHMttd50abk/Y+c
         hYKgjqUW0EfGub6kMz16+ACaoIymLjec9pkkoUxcybVsyBDC2yqyf091cYnEQKNXjL+8
         gCVhpHA9TehJc6QVrgZUcRj0ETY5P7QKFGRTq2NgmyAKomWAjmbUXGPKo6XmNMXguEb9
         sJ90lzqD9q60G3hXH8OOBliPSxGzUNnsNBd0WfKnGB6CvqXv7Nr3dW4QegNLq8VdYDrZ
         FTaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776352236; x=1776957036; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d3XEBxqMWUDBsaapxLN2EkFmNDcbcrBGu5uflDyv4hk=;
        b=ZHsjKyBkSlP+PdgSPJ1cvbRwZDe8HyJZBaqpdm7yW9jgqTOPXQUUtHFYLlUpUwgHeS
         GGCk13RUTZq/Ge6kFI8QVJYSCS4SPxNizCVECxnymilXJCqNpIWM8mlXofwPB1AcKvKE
         tzkbmxtTD8qy1ugemj4dI8uQnu5enF2huLFxOdNi6yOuaXCFQbn1Ygkr9hyZqPLHHp1w
         uBnEcgXHy6YPVck+ZAKqc9NCFFAOxPozty/orukn00FUKpjX+dC2bmAsEUDpI9zP0wYl
         xi0OcOa3Ve43k8JJMEYQB8UMRpL5/rEQQp3Mz8xId1yT1KIqDINiFHVQQzJTSqKpa5ow
         yVSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776352236; x=1776957036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d3XEBxqMWUDBsaapxLN2EkFmNDcbcrBGu5uflDyv4hk=;
        b=oekpXIRt0+mZj8PXjTC5ZKav7npHtOp/lrwMBBaJICnX3nmWB3rn1q9YhK7rh7zrad
         g+UPehTsd3RKbtXTFTCg2dGh2n2lgZ0wpqIF/blyVMFKBrXW8wCaa6sS6zTDpEX+GeRJ
         HKsiRZY2m93RYQjbhCBlcy+HKuvQn6xwAkyjodHsgde5myJAWQjQDXKu0it98PMPon0v
         Z3a3ibMAXbbTGjx7FGIpa2ovAVX6/dOhd2+9pMkhnBIXVJ3FAFfuW3sijWVL1WD797fy
         vi+uvc0MmdMN0rIhuZ0pa0P9KT2e1l+Wc2Y8yL2BeQQ1LnjnF4KaXsrwixOPm9XV8k7H
         GKbA==
X-Forwarded-Encrypted: i=1; AFNElJ/tmtymRqA5p1mqBvuBT6DLMcu2Xkmb9EShdIhPwDFbZELhagCaELmydXgnw91uqTfIvdjuPjU7VA==@kvack.org
X-Gm-Message-State: AOJu0YxfK/1tty028XtTaOOJAWpTBsymMk59KaPoBwM9nhrojTu2+rPy
	VzXeC/JPGY8L7b7sSot2Npiix02Sqf11JAVk1Wr8C5B+ylPLDXBY0swuHO/QQ8fyk+ewNuxAYZn
	CB3PiLZQRzy363WBPLGujF+Uw+jxHsTw=
X-Gm-Gg: AeBDiesN8WGn3Reyj6mX0ZekUCCdZPUSF8iugA7rRuMd8AtcTRXEEMeqVbSKR69O7Q1
	fMOclYvcOlGYUr/nwE6sYm4hTG9/QFjWZdSXooB9vYzHjoDCUbXEsAlo/wkNB1rxTunfW3tHGbl
	5EDH5IG1on+5hQnfbaX5LyBA6MO4qb1GA5J2I5uoaG83GW9dIiPO6+UzDtTufJmzh0vN96zET7Y
	GIZYSyH4ahutu2Pxa/lUQbKA4bUjwo8ktaz75+MIqFvnlKGzNt3VrYWQV+pfiUp7wMaFUzkvLXB
	EeFQQhlzSsge1lo=
X-Received: by 2002:a05:690c:6987:b0:7b6:31e1:7e99 with SMTP id
 00721157ae682-7b631e18819mr107266817b3.6.1776352236363; Thu, 16 Apr 2026
 08:10:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260416102558.575210-1-ekffu200098@gmail.com> <aeDyNm94j7ikZl-A@kernel.org>
In-Reply-To: <aeDyNm94j7ikZl-A@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Fri, 17 Apr 2026 00:10:25 +0900
X-Gm-Features: AQROBzCifctjF8HGZ-_gE9TlXJgyb--ZL50_wZrMHz6bkvqVOknwdJc-K7NK-ik
Message-ID: <CABFDxME=CYj6byBjkSgXq1niC2MobFrUNJTtWHktEZE3VYiu9Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org, 
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>, 
	Munhui Chae <mochae@student.42seoul.kr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 89416100012
X-Rspamd-Server: rspam07
X-Stat-Signature: cqx35ojk7aurww9c4jurc8zpxjn3a4ps
X-Rspam-User: 
X-HE-Tag: 1776352237-836517
X-HE-Meta: U2FsdGVkX1+io7xAQtKkqFz/LcOLlFO98BrbsSvtQg1oHTFWZqaF7pjmWYX5sdqOo1i7A0zM1W1ebjol0xxN+/yrGyQUNkjqJ+eiRHY+Sqe0izmOQw96cxl1xiDCVwZUPkX9MZAIF7+ozgmHWTdV3jsRg1ddtNW8G5VyID8GwDxyqEXmKrTemUOODGv8bjMn9qnUZf3Ta0wCH2CQQ4fNZ/m9Lecnljzq4T50H9KF9XwhGGx8ELndI41tjdmRlfMyPjRRqJ1CqqU4jEovhWLa07z//e/A4GINwZfxV1w8c3uBfI6qBKMUhZPthzojgklRgonMuJCLzUm/2dIHlu0WaIeYyIjoY9ObwESJJruOpd3mS2ZbX74ohNLbs9Ic66HXVDnYXRSvzFmyLL0A+XoLY9qbjz9jCk1RCuY0wC1T8koFvpg8YWdy3LB9/k60zwwTcT+M29fJU8PsHI5BGl2wrRzZkfhcz70MymUUm711BFUAvjnlZiSEXRv3i032xncYh0ne3gRIQ3tPKioGBBBpWgSLlkd2GdAQXFb8KHcxGX2//ohp8EhUlw9ZjRpApXr8yuLt34bC339+KB614c1VxXtjUd6G0FalIsk4+qDs1bto0IynBnyaBBMnEi/dwBgMzkdqn151wQ2kIkEjRgltKF625+q+1Ud/jo83Axv3SH6McGcty+r3Ne1MX9dMs8p10KVXJgnx+W6wsECWrp395CR7ws3X/rgoeIBm0iKptcHZ01qDYNS9r+KYAUUfN1juKBCBtf7h8Yb2WUQoECETPutej0TfLidf4YKfvytQ4J+qw00b1nLfoEdw6lJVabb8FaGFKvMWXxIxA/ce0tp/LwbAXjOyCXNW75UbUNhN/bEJTFb0BDCm2UZCgWg/UdIPrN4VeJg04WessTcbdtvsT7lJWpWuBFcHZ4Bw1SCpopBSTWTqYBmsMW2EAhXkPnisdgVvKVEXYWrBSl6a5Mn
 pfiyfN/c
 YbMu9kDh0wZLhCKUGu2ZrSXPuhXUCcoWAMxnJenmnqRw31RjFDCRlB3W0gFnNmx5MGhk9jG543f6gt+ffpesSvGk/3sYPdjXGybliGF4ybqZ6DPC2miOiufeUC2bDQPLhgepqotEPBPeixnJv0/UsHHA7jqeyz+waotwZUbjy5d4WK2hJ+hLvee17RXLczdnq/qWuLERC1DVJza8q5RPYaSLiaChsNxs1jYJBmp45BXVau0S8oZ0+b4QUmvpC0JkGsb/lPwWX3Np3Y+s4/V8FL7hTTKW+6vl6qyIg6QlGVynLRUIuEl9vA+gWZAUDIdekTvhG+v4ijNfwnuwxelDaNrrhwGlNl3HFcYvY0HPHxkkBqxQmAidZst9Uom6XJXwo4iew7QYt2+EYh1wr44Vm45Pjk44f2u69dgiRA2e8PQstoITM8kQk/9Gm0NH1CyasxMlv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, Apr 16, 2026 at 11:29=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> Hi,
>
> On Thu, Apr 16, 2026 at 07:25:58PM +0900, Sang-Heon Jeon wrote:
> > Subject: [RFC PATCH v2] mm/fake-numa: fix under-allocation detection in=
 uniform split
>
> RFC in the subject means you don't intent for the patch to be included, b=
ut
> rather want to share it to get an early feedback.
>
> I believe this is not the case here :)

You're right. When I sent v1 patch, I wanted to check if the way of
patch was correct or not.
Anyway, it seems there are no disagreements on that part now. I'll
remove RFC in the next patch.
I really appreciate your attention :)

> > When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> > returns the next absolute node ID, not the number of nodes created.
> >
> > The existing under-allocation detection logic compares next absolute no=
de
> > ID (ret) and request count (n), which only works when nid starts at 0.
> >
> > For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> > 1: 128MB) and numa=3Dfake=3D8U, 8 fake nodes are successfully created f=
rom
> > node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> > fake node nid starts at 8, but only 4 fake nodes are created due to
> > current FAKE_NODE_MIN_SIZE being 32MB, and
> > split_nodes_size_interleave_uniform() returns 12. By existing
> > under-allocation detection logic, "ret < n" (12 < 8) is false, so the
> > under-allocation will not be detected.
> >
> > Fix under-allocation detection logic to compare the number of actually
> > created nodes (ret - nid) against the request count (n).
> >
> > Also, fix the outdated comment to match the actual return value.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > Reported-by: Donghyeon Lee <asd142513@gmail.com>
> > Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> > Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capab=
ility") # 4.19
> > ---
> >  mm/numa_emulation.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
> > index 703c8fa05048..c1d0a76aef64 100644
> > --- a/mm/numa_emulation.c
> > +++ b/mm/numa_emulation.c
> > @@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64=
 hole, int nr_nodes)
> >   * Sets up fake nodes of `size' interleaved over physical nodes rangin=
g from
> >   * `addr' to `max_addr'.
> >   *
> > - * Returns zero on success or negative on error.
> > + * Returns absolute node ID on success or negative on error.
> >   */
> >  static int __init split_nodes_size_interleave_uniform(struct numa_memi=
nfo *ei,
> >                                             struct numa_meminfo *pi,
> > @@ -416,7 +416,7 @@ void __init numa_emulation(struct numa_meminfo *num=
a_meminfo, int numa_dist_cnt)
> >                                       n, &pi.blk[0], nid);
> >                       if (ret < 0)
> >                               break;
> > -                     if (ret < n) {
> > +                     if (ret - nid < n) {
> >                               pr_info("%s: phys: %d only got %d of %ld =
nodes, failing\n",
> >                                               __func__, i, ret, n);
> >                               ret =3D -1;
> > --
> > 2.43.0
> >
>
> --
> Sincerely yours,
> Mike.

Best Regards,
Sang-Heon Jeon

