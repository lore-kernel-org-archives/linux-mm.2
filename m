Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B313F327B1
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:56:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4EE66B008A; Tue, 21 Apr 2026 02:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFF516B0098; Tue, 21 Apr 2026 02:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C15416B0099; Tue, 21 Apr 2026 02:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B27036B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:56:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 498EA8D01B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:56:15 +0000 (UTC)
X-FDA: 84681653910.24.AC503F7
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4A0B5A0002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:56:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dfTBsInn;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776754573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G954RTMVaWHqjwglqt4or66X4ytIZGguQaz2k8xzOuY=;
	b=MbA/3BUPS+5oQ1rrYH5rtgYdk2K8M917+fGGSLAWUkt0aYCjgyUhJSCBLjas+lc7kNZMwI
	SS1ILD9IoYEr5nI/aV/jTg4rlGNs1bjY6F6q4tAo5ghZcMljp1rGzwlb5Ys4oKQ3K+fn8+
	uEMrFs6x0LAQh/iDTAmolPbh7uK6AEI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dfTBsInn;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776754573; a=rsa-sha256;
	cv=pass;
	b=LgbUcw2OyYmqIsSzRsFB48VOhmG7/RfEDIP6ZfF1j3pSVr3nJvTTAoqgimlOLhK1XNSNe0
	4HnihX+2nBzhue9wuRtfvjkKgxIY+lFq4G4cUsX8Y3d2iYxA77YD1wp+9CK67xlDt//gtv
	VWxl9+B3Ct+SwzTjFYelQ6D3/tyf+g8=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-79ab3e26cceso33452407b3.3
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 23:56:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776754572; cv=none;
        d=google.com; s=arc-20240605;
        b=gSPN7klx/VkCLAIATnue9+Qj7gTmyUWwdReery+oMpbo8fKxEDRzTGf0Sl2H+T8QVt
         eJ1NElQ2NQ4HGSYKftJZ0dPfDYICyak8L+pSejsd1k3RU9HOasJHbtdEnE6U/tmtUTsq
         xmhEbLvokvm8CucFWl7uxaTREiZau2RkMDUQzMyJUPEua3Qm09i4Q+AYyOFlrSF9lQxq
         PLKluRkkRyNfrvXnXjFdA1yhkxNQRoqLfBmm0wJ6r7l8+0SRiKc6zv5FMRRUIvgUwHz/
         6jVHrzWcOlSSKrf4csFZ0Rij0uPxRsQr7+uroV5CkTX6bWdT8YnGcCm+o2L88jf6KzUd
         Ebhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G954RTMVaWHqjwglqt4or66X4ytIZGguQaz2k8xzOuY=;
        fh=kD9ka3xWM/t+yAsodllS2u2LDwSqK6CMexVbR/SRkIU=;
        b=C7xa68j1eET8Svk9gvqCn8qAKIvYwq1Xlw1d3XW6Ly/YqJu4kZTOmsr0OXXUuYEG8P
         sBhujvHOzyQd7gjvuwCNaAnZbV1CpoOBUk/lruJyhe9xzaHVjmrx9TtoeFs2Ps3YetGn
         SrfMtX2PxlZUeU+NKeHbnu5VWc6sElYSu5otF86dQWuuDbO5Z1rkFP+VJlHzzQZAj6xf
         9Y4OOu+Ncd+OaegNC98GH/ySll5iolaN55pVhhOgzFbPoHyiW0CloavmHXSe/ngofCBA
         g62X1KjTAQGl5TDztQToljhJW9V70WasHiJlYitep15yi9xqLkGpKCCiJME9sVpFL6Y9
         Zkzg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776754572; x=1777359372; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G954RTMVaWHqjwglqt4or66X4ytIZGguQaz2k8xzOuY=;
        b=dfTBsInnaKoezx8B8+ys8ufX4Zstrk6PT/vOUAmXqrnZAhHC5r3BF1qnCPOU9QspBV
         xIMma2o2/otRtgctcpsMvwodTo9cerdSnseI1tC+etSfFJWlwL0RwK+N6gUP9fzxpSqu
         UjSt02y921igoTrEQG3PL+6HiB89dtCUjRrx3dgmDhOVOXBLucN94b5MkQKeMyq3iOca
         x7WGicV8zE+Wdv34akQmRwSsP9R+zUc3H3pctXqwVFhPyqm3g9oMckm2B5DuiIQ8md36
         jKM1Vtzk+xoCI7+6kASj6rycpmp0mIA9tYiT48XNCWZAoNMMXoxxaF+oyPYQwxkI8HMs
         yy9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776754572; x=1777359372;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G954RTMVaWHqjwglqt4or66X4ytIZGguQaz2k8xzOuY=;
        b=SlSzP7/9b4Z7MR3i5qu8tTD2FaXERWBLKnyIqs5hRIxm1iq3QSsG/tNwTOaHrhywYi
         LJrK0hJYHNvMN++dK5AT0wIJu/mlfzrFz1P7EGqKDEoc73OsKUYClcRa78C6gB0gfFRd
         o5x8FSU8WoNCjO8cuql6xeH6oCdDOSlVhl2SnJuy4R6+TLkF43gqKqVuHjDxGw3XERFM
         Ei76r8uBDqi4FG+oCRihCf/dfGXRGzN2ceEX1/1E5EVdXmUIrxEL5UIvErji6SRtqiN5
         6WI7sqIM2lxcvVIAbD9TQfdGjbNokaiZ1gZyISe2/+EbOSGtRmIlCZ/FQijtN8vZbEh6
         3pcA==
X-Forwarded-Encrypted: i=1; AFNElJ89fi3kZCpzbem1H4H7GxuzXHRF+Vi5dWRj7NPVKOgmcWn+Lt/nlsv6YJw0di7CEQAs1yCeSm3K2A==@kvack.org
X-Gm-Message-State: AOJu0YxuI1Law7Xn6VtQ947ujjsPGT2beJrFhyVNHvYAtREcs0DBOc8A
	Gz3HYVgxxxa34cXYATM/5N6oqInwKaNR9ni6KIAnGFzYCf9nMKVNXkIABvPbPL6Fk2zEbEm1On8
	AkLI28EIO9TOCblgQXWdgJZaXaWbOxrg=
X-Gm-Gg: AeBDieuKstVr7nnqrrr8AGItwCfA2dHRFXzgZHUeQ8n72avpUwde5ifCPS/dn2jQ0C/
	ostGZM4868nl8B2qVN5HPuzz8wI3z0xzNtf6OyVm/p/6gtNJqq5mGj0wb3e+uz3b9AUohgZz0Eu
	R2Szf3fkn+uXR2PHggNpAkvvgGOgnHc5gmA8BehhnKk9SykqmR09s7PYN9XrY0jpOJF7/Dezi3Z
	KBeUoUy5bjHcGJDcYtZYT6NpfUxSIQ61WAV74lryWG/XPP8oUZAEIDqBR2G1RkpwA8bDrlp4tuy
	vhBZEoiBhhxhGXY=
X-Received: by 2002:a05:690c:93:b0:7a4:8718:8c73 with SMTP id
 00721157ae682-7b9ece91691mr161678827b3.9.1776754572269; Mon, 20 Apr 2026
 23:56:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260417135805.1758378-1-ekffu200098@gmail.com>
 <aeXIKM9BeRmaCZ_d@kernel.org> <CABFDxMHT0W-FFuLJwiWMqXueXZvz-2wSsZyRPKJ6ki6FhVPLnA@mail.gmail.com>
 <aecZPdGyF5i1baee@kernel.org>
In-Reply-To: <aecZPdGyF5i1baee@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 21 Apr 2026 15:56:01 +0900
X-Gm-Features: AQROBzAdg2gdS3KDjvk2aGpa-rV7JJ-7DXvwsEhWWWwN200E8Uy85JIqLoWfXtU
Message-ID: <CABFDxMGU8DwoG0yYb8gBstntTJ5okY-2bs_2iywBnrSX1H7-Uw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org, 
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>, 
	Munhui Chae <mochae@student.42seoul.kr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A0B5A0002
X-Stat-Signature: 3x4knhndd4a8y4fbt5daiq5kkkaff7x1
X-Rspam-User: 
X-HE-Tag: 1776754573-424962
X-HE-Meta: U2FsdGVkX18f3pyYLh/3MP0yffWXz4NfxjPuXcYCqQ+8doBRMYdVIP9gqBhskyXT2nrU22mnBLxpV8o824CTD3kBxubEImJHyGkQcdp99T5Vor/W99nKDD/d+Nfg3LkpqTzTZ+TP5EUUVuHvF7wIHjoEsq5Q3gbbMGbYWEWgYTHM69Enzvo80VcHTI3SGuyUB6lbLj6rjrDHJF3cIsywwiTV+iYd5pkcXXKXnpmyH8BMP6rnZ37Qw8usa4VNboJoLkp5klDS8ujqEz3TB4eRett1RlVEOppsCcLh1Je/Ys8rrEK2OMni1uuegTRpl8odXeOOeT0dRe8e3LYTpa6ypJSSRsl8kFgu/zs3SCzbtvbmdLpHTfT4NY+N9W3geOAYdh+omgilfo+BdDHdVdzrjDqQue7xbrKdL/pn2J1Zk3+MtQrM5XSoOTi+MGrjuhk3uvg/HwmA3lbDFFBuT6GlWG3Rwuv3FhRaVbNR7ajuXymfeeFwoQetDfkmd0YjzRvmPnnLUQk7ncS8S5zxkqWGLuRn49E1bSydZ1zlzvwRp/CguGl2MyTYKuyaPWurAzIZ4U5s0YfjZpN+4F6dRjxwh7PdCbOopOZTNeHjx3oFd1cy/DGNGUTHAas4THdG1Y9s+ab6XLmgerHRhs1/v00idwWm9rYmkHSCcetV+lJySLG7nzF2pL1efZ7zhGpRfr/MPsk59dzxBJB3438OKTydjtodgQE5woNJYtMqXgFcxPD/rQzpZgGXYYkz4gYAL16auANIEhnBiTHbHqx/CUYTd0srG7mooZGRoRpjC0EcqoY071dJL0PZW77oqn0DQ1cBbow2vIyBZqxShcO9oyo422JEYq7NdXDtwChp2ZH+mcLpkfbV7A/MCsTOzLJFY6is1+0XnD5w5jYuY+C2qDVEicd6/gRdTwyzsA+0e6icEBflTGS6ac3bP7/AMCb85GT0ahRP4T2V2LnlphMJ5Ct
 ZsdmiMSI
 23MM76+602ppixhz2pngsZ+7xqWyZRgFgo05EEdEVzuUAH/BM3NzXiihthq6DJqtWMOsftnm0vPWhTqIJW0Sr9zMZLSXKDlO+Eh5EPnNCulonWZCvdcOXVISi1VMDtmiCHl1JGOJlrATyG42N7jHeCS5FOq4Iv1DSRdn6sg5JQcRO9rcHPWVxV/FxQHJMqQ0XNDkDaRA7RGax62KWnaEXxsrEUHxeKJlYKAJisnsqe2bf7NiBpJOh/iQjuSg3qzm/v7tVMcW9DCvcvgLi6fTC2fkL7TPzDtO9jBk6vWp+ZLCk9jAXvjhw4viE3hPxsXBDHHZ6gGaBFOrmbStepKEQQQ85rlXzXP90MkLdaIMkDUnXztEqmkhSQzQgW0uzuievH4LZx99QUfNB4KKRrJynnM4ZpKIyDT/XDNGRFChATOV/K6c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi

On Tue, Apr 21, 2026 at 3:29=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Mon, Apr 20, 2026 at 11:26:13PM +0900, Sang-Heon Jeon wrote:
> > On Mon, Apr 20, 2026 at 3:31=E2=80=AFPM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > > On Fri, Apr 17, 2026 at 10:58:05PM +0900, Sang-Heon Jeon wrote:
> > > > When split NUMA node uniformly, split_nodes_size_interleave_uniform=
()
> > > > returns the next absolute node ID, not the number of nodes created.
> > > >
> > > > The existing under-allocation detection logic compares next absolut=
e node
> > > > ID (ret) and request count (n), which only works when nid starts at=
 0.
> > > >
> > > > For example, on a system with 2 physical NUMA nodes (node 0: 2GB, n=
ode
> > > > 1: 128MB) and numa=3Dfake=3D8U, 8 fake nodes are successfully creat=
ed from
> > > > node 0 and split_nodes_size_interleave_uniform() returns 8. For nod=
e 1,
> > > > fake node nid starts at 8, but only 4 fake nodes are created due to
> > > > current FAKE_NODE_MIN_SIZE being 32MB, and
> > > > split_nodes_size_interleave_uniform() returns 12. By existing
> > > > under-allocation detection logic, "ret < n" (12 < 8) is false, so t=
he
> > >
> > > In this example it would be 11, won't it?
> > > I'll update when applying.
> >
> > Oops, my previous reply is not the main point of this review. (Please i=
gnore it)
> > But 12 is still correct, because split_nodes_size_interleave_uniform()
> > returns next available node ID.
> >
> > IMHO, it would be clearer if both the commit message and the function
> > comment change into "next available node ID".
> > If you're okay with it, I'll create v3 patch soon, including minor fix =
below
>
> No need for v3, I updated the comment and the whitespace:
> https://git.kernel.org/rppt/memblock/c/a34436ac05e76bd6634a89fc0a399ab3a4=
8f509a

Thanks for your help, Mike. However, it seems like '12' was changed to
'11' in the commit message. I think this change should be rolled back.
Could you check?

> > Best Regards,
> > Sang-Heon Jeon
>
> --
> Sincerely yours,
> Mike.

Best Regards,
Sang-Heon Jeon

