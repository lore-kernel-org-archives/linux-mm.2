Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B023F9B5F6
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 09:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0556B0088; Wed, 22 Apr 2026 05:26:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0814C6B008A; Wed, 22 Apr 2026 05:26:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB23B6B008C; Wed, 22 Apr 2026 05:26:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5D466B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 05:26:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77CC7140F73
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:26:49 +0000 (UTC)
X-FDA: 84685662138.01.3180B6B
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6AF4E140004
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:26:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cZX9a8oR;
	spf=pass (imf23.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776850007; a=rsa-sha256;
	cv=pass;
	b=iCCfnwx1r/QBpJ/+jLpAT1EVlZbe5jJxGn2VWwJPR6/2HHaAXLlixLS1rRlUiYZQ11StoS
	383kjIRmZbrwetEakmAXyvPYAphqKwpuz2cjJOPAWPN24ofd3fTIiNQ36UAEOtq9p2Kfmi
	02GhU0StP178p/PckjPNuVSol8UEU4k=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cZX9a8oR;
	spf=pass (imf23.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776850007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4SOaCs+inrr2/XRTBiKFCWBNEK8rNs+pRQY5g7RSTn0=;
	b=00+Uoh6o0WwImIfyti/WbVHblm8lgOH5VJ3/j8AEMgqDjjVLwvXz30CMKtVGCJN8EwE6FV
	dxrb9rCNz8ajqjbUH5tLBAaetmCe+Xy4H9aaZAOvVq6ar4K+pqqtRgz60ED3LrMdK5+h89
	GMHHfYjM5+847UAFAiIPiqx4WWmys10=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7927261a3acso45366677b3.0
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:26:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776850006; cv=none;
        d=google.com; s=arc-20240605;
        b=bdyjHaDHzTujfRNAB4AtLxp2kVN0A0dN5/7N/4uMYA9ieEEyZWmtE2KRMS8+zFd/Py
         5BP9vp9yYL957u+O2fCQwDHy/x6s+R+hDTg3FCjO7FEPZvsbG6550hbsrns4E4vmCwdt
         aEMJsdR7uA+r4czbU9TDio3ZQKWE20jNdP3paYYq5Z68ligzvC1YPPOV112CSmzooZG8
         UlrM01JL+ZDPiZALjOsIU8xyX3BVeBVz+T5yRhuMMgPHBX3+l6z18eFW6tSvGHbc4U56
         4hXfW1SnomRCETj9+3q8pAyRFx0EowQ2ULqhsZ5uRkQaKHOl1kkyAKmf4GW+cuPA+cjw
         MA7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4SOaCs+inrr2/XRTBiKFCWBNEK8rNs+pRQY5g7RSTn0=;
        fh=xFmJ/8TiVRrtTxAUG3tZyEpTqnCSq2XCbDvdJpAg0Ws=;
        b=RIdPAjfl/L5UeGFJpiM49zRgQJ0R4EcqZE0eRzGnETUAP6CTwML9xh1TDlac0ABMCq
         GMTGAJedUlvMqVN7kpexrBEgJT3fVfMezvSwmPwplHHzBMOvOAbNjy4NDTAJqVQ1SJpr
         3i0jsQJcuOCT58TTHVFBzrNGBhl9/SXYu7fifn0GPBsGOckZuynPmDOc374l2mEoL/oH
         WHYqdIf/lyJnZqMSD6Vrupi7fSL9X7wA4kds0URDUA0quZHQEGTC7FGvEpYQTsWNz9bg
         feWy3ziI8ojRRFEaYJMaXq5kMch0N7BOKLqcdSv6Y+QHLwV4Ydua9XBfacOv4p1zMhel
         LQNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776850006; x=1777454806; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4SOaCs+inrr2/XRTBiKFCWBNEK8rNs+pRQY5g7RSTn0=;
        b=cZX9a8oR9d8tyEzS+X7LVRppl3SjLrFedWHYnQZM0LrKEdXkjnoSkM4/xWeMxXld23
         ZqcvSWSDZOip9TT8H1Poq+9g2DfliazXaok9koJw67nGp307qjwrGX/g8qssrQpLNPf5
         h16Qw4668Eykkr1EF3fVlJrnR0B7ME81hZ6/i0ANqiSJhLU5MQmxRC8OitWasM4lRSSw
         kr9IGP3nCQsslU7I6mORk9d8nJnXiHeIYWrvaoqaGOFbSUS/IjH6mxPnoGXWZDA59jAv
         MKV+16goMEZftdr2J174IOYtbHPjbNsZoiD1HdamvpN6/PmVWr07h9Ro7UMu/WrHNCtn
         jTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776850006; x=1777454806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4SOaCs+inrr2/XRTBiKFCWBNEK8rNs+pRQY5g7RSTn0=;
        b=dYyeT1poieV37AL/mkQhsQnG52dFq9oX8FuByV+bX4DXU9T540k70EMHspl26zPiLy
         G4bp+qwRL/7cMwyVVU8l+iH5neE7w7s0kXCwbLcLw1WEfBGnrAoss6k3rUcezyeg6hMS
         +h/at+q41FDcW/M4+QzJJgJOaHWmYAWaI6h1Py+TiNxicXL3EzwZTtfImgVPZxitcmE3
         nQOHXZ3Nng6oQWEeBruo6DW8lPiJOsJxMAFsyVsHqlKO6h7qSmjIs1Dd3EZvaSs2hlVc
         U3Iidz6z/t3WKaaGMn2jhtNDdaNzSW8NkgFq7uP2NMoIylFse9YAUhaPpjlhwvdlzK0O
         XOfQ==
X-Forwarded-Encrypted: i=1; AFNElJ+6KbtrvkU0QF3p8mAs8++p4rOYDemDrPONudR5epYINng/eokkj9D3d9cKErziuD2mSuwPfgIoqQ==@kvack.org
X-Gm-Message-State: AOJu0YxMaSLm3xcq383RV7CJt0E8OlqRNjWgx8gdsdRb1avr2/itlJOa
	TmXzDTlbCs4FMKfN7g8j2a0XfTig5iF7l4SgIbB/LX5OHSaZdQZF9lMQPER9AAV9fEYtrjVoUF7
	Jsnlz/PwAQZY4jTLVOOzKWLSerJrcFa0=
X-Gm-Gg: AeBDiesZMPD23MHPQ9rjcL1Gnp4oUXvam4GbL0ZYHrzaDjFad5dqvYKd1YailAVECvf
	iw9utmEgaiv65vs0CuLq83goL/t+0btmh5rkCfyTf3aZZ3yi3ObVO504nmvTHJ9O0OU7RLjmVhL
	dlSjQak38umWQRclWkDbaeH9SKVbNTo1KU3RessseQm0OIF3DChKU4NKrEssa6GFngbvw8MQIM/
	oeVIDAgxWcZYj7oZc0yL34LRoOcffgGdx1a5u0QULloFCozd2IC3/GudA/t6fVcpIzVX0yrAhxK
	8o6vRYAfljxPOjo4837u3E0gTQ==
X-Received: by 2002:a05:690c:e3c8:b0:7b4:657d:bd4e with SMTP id
 00721157ae682-7b9ecf7fd94mr233270687b3.30.1776850006304; Wed, 22 Apr 2026
 02:26:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260417135805.1758378-1-ekffu200098@gmail.com>
 <aeXIKM9BeRmaCZ_d@kernel.org> <CABFDxMHT0W-FFuLJwiWMqXueXZvz-2wSsZyRPKJ6ki6FhVPLnA@mail.gmail.com>
 <aecZPdGyF5i1baee@kernel.org> <CABFDxMGU8DwoG0yYb8gBstntTJ5okY-2bs_2iywBnrSX1H7-Uw@mail.gmail.com>
 <aeiIish34t1mA50H@kernel.org>
In-Reply-To: <aeiIish34t1mA50H@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Wed, 22 Apr 2026 18:26:34 +0900
X-Gm-Features: AQROBzCXj-QVEWt011p_F9MvHTfhKg2xTaeKOTklqGiG_tMy1x6z0QcUZfW0FfQ
Message-ID: <CABFDxMExN86rK0h0XesE7rT7TjCZbYS9_dmb6dES+eJ0hN1EEg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org, 
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>, 
	Munhui Chae <mochae@student.42seoul.kr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6AF4E140004
X-Stat-Signature: yeob9nsz85r48entopq4fz8mn7x5do76
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776850007-760633
X-HE-Meta: U2FsdGVkX19yyjKVux2u+hPjBK1KJlmos4bqoEIqCMTPDZsQQYGbI5df/7rgFLPo0datQ+tIjdPNz16ycgAPusqyHXe+1O8Czij64bDZfO/tkESnBuUBoNXhn2jEWYyPXcEuD9/tW/+iQxk/nMOYs4v2L1dzMp8f0GoWkNKmVP7CFcfUScOjtVDGY6HAZhIVn28BUqtex0EsQfVru1QWPj6LmXRGTwu1lpol+ZoS+GvwfY0NcI6ImGRvwxBMRg3BaVGxwyRWq+ONs0snlyUx38Ow8+tip7lIMn7y/EUJm+Yr5IaYNSbgu1LZArPMXxhM2KSj69JM+Qpmm+vv/bjRIM223ph1/hVS6oYg65ogEbYBnXNvXMcZr7bOFHu1Anr1zGxFTHfco2vrH30gcC14Kf6xwIAhtslhvbLLIJfB5NJk5pp7kZTgNghIrvn4lXiBvSHGNFC01Orf7kJXBXGaxQ7Lkmo+LBz7ZIqwAVxZ65ATxeK1pxcVAcvHn3itQ5xM48oyGlP3SZFivuEUdF0G31ys+NyKNMZFF9+hoEoMuexOPYZBhucFPNTr9CjfI1G68fpvbRcb29R4tn4N0qUiFW37vHlE5Bi5tfygzZ+UtkL1srIJ4NFlxXUYIlk0yYvpOQMCbiBJufHlXGOAdC8YFIZQxbYFFISSEre7ybQ4yU3opZ0S1YgEBi9v4ZA5Q2kxyD4t7eRwQNBLhSWug5GW1L5+fRmik6zkcmwdwQ1JYcYXpG+pvoPauIELw6FW3jnXnFO93L3nu45HIL3Iw9xsU8NQ8trAK1f+ktlOfaV//N3buHvdnivaLHv+twVB618pUYA178GYndQAWOvAudE8HRUC03qset/9IAHjs9OI1iHV86J/VHExjhaNuqb+DQuiNbvfkwQ1rK3CXOXWwUsua0/3cdJy5Zr9kv2TSYQLyAAuIvnUOQICi0iRHSYGMgN6y3cKfYb1WiN51K3xfYe
 9ZJadUVG
 rmubA9JCD+yzUIVEASH3XV119s4KVzAiHmIVl8TpWkyJiTDm3tUadWiylwyuwDRW+tq1qbRi4x6O6dBMRcXQ0B2CgqHnRzYFkvdwuJLvcZZxtVvu10osJxaE4b56xeiXsqvrno+vjPt8p74SMJ55i0w8azo3k7sub822v+3N4UOpV3K4Yz6wET0MqSiJxX/SMh4niH0DLhWkDw6EgPphe4uDDnz50U9/p6W+uWk5wfB3Thtf5wHGea9USShfTY1gh+5fK1x/FuTXiWBVmnONMocVaw1Ftu6qUe1YOllC6c13/3vafIFzlHVjhGWaD9kEGF4tg3/szWGS30Bd3ocsKujh/XxM0cjK//a7OZ2+3a4/ua02X5fGoNgan5kRdXgvRHFWkXatUu7lFCaXHn6c5WM6JeLLf3dhASkIuznNoEpWndFI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, Apr 22, 2026 at 5:36=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Tue, Apr 21, 2026 at 03:56:01PM +0900, Sang-Heon Jeon wrote:
> > Hi
> >
> > On Tue, Apr 21, 2026 at 3:29=E2=80=AFPM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > On Mon, Apr 20, 2026 at 11:26:13PM +0900, Sang-Heon Jeon wrote:
> > > > On Mon, Apr 20, 2026 at 3:31=E2=80=AFPM Mike Rapoport <rppt@kernel.=
org> wrote:
> > > > > On Fri, Apr 17, 2026 at 10:58:05PM +0900, Sang-Heon Jeon wrote:
> > > > > > When split NUMA node uniformly, split_nodes_size_interleave_uni=
form()
> > > > > > returns the next absolute node ID, not the number of nodes crea=
ted.
> > > > > >
> > > > > > The existing under-allocation detection logic compares next abs=
olute node
> > > > > > ID (ret) and request count (n), which only works when nid start=
s at 0.
> > > > > >
> > > > > > For example, on a system with 2 physical NUMA nodes (node 0: 2G=
B, node
> > > > > > 1: 128MB) and numa=3Dfake=3D8U, 8 fake nodes are successfully c=
reated from
> > > > > > node 0 and split_nodes_size_interleave_uniform() returns 8. For=
 node 1,
> > > > > > fake node nid starts at 8, but only 4 fake nodes are created du=
e to
> > > > > > current FAKE_NODE_MIN_SIZE being 32MB, and
> > > > > > split_nodes_size_interleave_uniform() returns 12. By existing
> > > > > > under-allocation detection logic, "ret < n" (12 < 8) is false, =
so the
> > > > >
> > > > > In this example it would be 11, won't it?
> > > > > I'll update when applying.
> > > >
> > > > Oops, my previous reply is not the main point of this review. (Plea=
se ignore it)
> > > > But 12 is still correct, because split_nodes_size_interleave_unifor=
m()
> > > > returns next available node ID.
> > > >
> > > > IMHO, it would be clearer if both the commit message and the functi=
on
> > > > comment change into "next available node ID".
> > > > If you're okay with it, I'll create v3 patch soon, including minor =
fix below
> > >
> > > No need for v3, I updated the comment and the whitespace:
> > > https://git.kernel.org/rppt/memblock/c/a34436ac05e76bd6634a89fc0a399a=
b3a48f509a
> >
> > Thanks for your help, Mike. However, it seems like '12' was changed to
> > '11' in the commit message. I think this change should be rolled back.
> > Could you check?
>
> Node IDs are counted from 0, hence for 12 nodes the last nid would be 11.

Right, the last nid is indeed 11. However, the return value `ret` here
refers to the next nid, so it should be 12 in this example.

> --
> Sincerely yours,
> Mike.

Best Regards,
Sang-Heon Jeon

