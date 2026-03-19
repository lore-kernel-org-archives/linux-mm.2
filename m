Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A491088E70
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 04:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1786B03D9; Thu, 19 Mar 2026 00:12:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2486B03DA; Thu, 19 Mar 2026 00:12:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3236B03DB; Thu, 19 Mar 2026 00:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC0716B03D9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 00:12:46 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58DDD140277
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:12:46 +0000 (UTC)
X-FDA: 84561491532.17.B0ABFA2
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5877018000D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:12:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B5UNDQEx;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773893564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mefQ55wBWCGVk0eLqlHr0dgjbi3ZnY9DQRcxE3feS1s=;
	b=ZGdlLaf7AxiYXHGRKslTjwJNaFcr6+jAWX4SfnFhzTApqjG9jEX05F/BT37zDzOrhFSmto
	nSj1GZOcvEyi4Iferi9KAGccLqWzRjfFNnRZ/LEIv4LRGccBi/qyFy+KcO3vgiADyvUr/C
	xAHwYMtzn62kpndsnOGSTsOWKCYpJUc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773893564; a=rsa-sha256;
	cv=pass;
	b=KSSu8fyI2dacvgkHmreWt3ucSFQDtAXQ8XBXXj0LrL5vdgskIxvhwgexuwROAWrOFVBnOk
	6ju3KVtk/8172O80XfDWti+i/Fo+ixo4/unuTLLvIObUIN6dNuoER5xXLgUHutukKrPi5h
	zOiFhvD2h7qjijR7oNWWSXqeQVAETqE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=B5UNDQEx;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-665634cb208so1053633a12.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 21:12:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773893563; cv=none;
        d=google.com; s=arc-20240605;
        b=JJA8Vilo4zBFnrJnxSrQP0PDNHScGBcJzjAlKXjejR4JSbrXW4mdMpid21n/cLx4gP
         pO9TKy07PBRcHoH+cimJbTW+dT6RVkgDXN8NrILthULF/CllGHGTErFu7Vw9G/u9o98F
         Iv9q5Jgjxy+GXZrd20K2RXfNUZZtYN+VRhRckY0aNuLlpJ1xn1uXkPfrJbyJIbQ76TTZ
         GYYc2rOJvqPJ59mjS+1lk3f52CBEfo1uC0Tc2qm7HpS4Dz1OouhzqEB/aAQo3XzBbcC+
         ZzljLYwAvUM5gWxfQtcbbAnzmuQ6gOWSk/ZkiQzkXd9BLNlmE87PqWQ/4nchylCAPCnq
         iuQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mefQ55wBWCGVk0eLqlHr0dgjbi3ZnY9DQRcxE3feS1s=;
        fh=GQQxm9mw5zpOVyA3t4CVNbi8itAKnQtZqEwirkITo2w=;
        b=HTU47fMDA1eO1C9yVN7hF0GN93DctlC9j0J+oF5KeQNOD1a29+ESN+x2Pg014zHHyb
         KxHK4hOqjbTlWmD+3dxx9NyS/PwAsnUYNHPcURit8Vu2OMTDRowRA+NZWb/nbLeUJCin
         7TrfReelAw7uMFMid9gnfuYrITSqJPTbWYxGWyRIrXGY4dGi73FXKAbZplchdwXCLRjB
         3vglMUT0IshYWXAYygNETqRKRDtDaepGA2wP0DJapo4xO2Ymzokond/jqI6wVL3/FpuT
         mOGFtAgZ9INnH2cp4fK4Vnwii5KgdRf9eyyKJbvur8vfUi3UP6BVUMIwbstpwTQSnZHN
         jjyQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773893563; x=1774498363; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mefQ55wBWCGVk0eLqlHr0dgjbi3ZnY9DQRcxE3feS1s=;
        b=B5UNDQExnHbUSVl4Jk7/z5qavGVf+H8/q5skDXYqBDhnb8ReeC2/QsA5c1PNJFKDJc
         ywHpeXyoXijRkhe9tWaLI52xdsg7Qp+HyRhDBkCQnCkWYmJBEna+rpQjj1Fsl9uivH16
         DIUbJ2sb1xGIrAK/gpDks0SK4VKopztETpCE21RqtHGHgX6j0H7F9mPZLgVx1y4ayiVW
         /5dedS5yZGV87KHjJ3ttJBNk4jVJBnl3WotLXqTjvTpkpLY5ATIee8yTaSWSSVXWGzNv
         zCbLMfwvHthhft48dU+3MYmdg29LRKRsJcsKiR4E7aW12vzr5p93kASGW/2m+8hd8R2c
         fwEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773893563; x=1774498363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mefQ55wBWCGVk0eLqlHr0dgjbi3ZnY9DQRcxE3feS1s=;
        b=TV0Bz/ayXswOuFK4Tq9YqWUb96oVKbqP2V7fEFVeP6JJHhhYNJ48qRsVxlB7T8QUBa
         bsznxKHGIhi5VvRcQyLolFm2ueTXLfC4A5fFlxqhLMiH58K0g4tFITkRj28e1znppC8I
         4vO9HC8RqYbmYXbt4BZje5DmAcmjV9lKxwRTTr4YDh+GfCLmLP/oyzcP5hQOM58YX8eo
         w0VPnrcfqQKeb9Pmz0ie7c0ZrCSzH5wX2tK8d47QhYV2j1IUEvM8QNGyDHWvMtno1iLn
         uuHyW6RXxlKbu+//N2ChLH6RWUouxXdVh0neJULgezWA+8SmLf5BY/gIc49T7VyWIBuG
         S9zA==
X-Gm-Message-State: AOJu0YwdCl7fmiFBo79A0h7cbJ3ChRDf1Wwr5+eungnWvwBphVTWgNPp
	k5scZ/T4EcorZ8IndILUJZCNPwDGQBzB7HpuZj6TjB/73PCwFW9tSCmuPEwvyee9Pl35GiiURjO
	2B3yYqruHF30pAzsQEf4oOG8acYfwcIU=
X-Gm-Gg: ATEYQzyga4SZGOBTghTNcXI5km18By4CoYvkbwAB6G0g9sE5gjYYlnlW+N5LOEYp1CI
	vWPZlr+g3+oBUAIh7nSrX6SAW6DCS/E4JW4Tv3lzf5LjhO3NJbiCjI0UQ++fuAjFYy6stGLnXb6
	2tdIkAp/c2/Q3n/+x9Gk0Js3ePSEJVo9txOcNIPpF9BsckUyqbCY7D7jAZjGvzkPoJig+QmAoAr
	CEn4ukQ+1KPaki+EX8P0MjZhbYblAcSaQs2pkxG4yNyLgrgnzqbYHw5ChTmjj5z3LfiUmyjWUTw
	zJ3Q07ouZhDju9Zx+onQFMwkUiacpJYtVwGDPfdh
X-Received: by 2002:a05:6402:1473:b0:663:8be1:362b with SMTP id
 4fb4d7f45d1cf-667b1984833mr3949531a12.5.1773893562458; Wed, 18 Mar 2026
 21:12:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-2-2c46f9eb0508@tencent.com> <013e34b3-abf4-4794-8cc3-d6735d4fb156@huaweicloud.com>
In-Reply-To: <013e34b3-abf4-4794-8cc3-d6735d4fb156@huaweicloud.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 19 Mar 2026 12:12:06 +0800
X-Gm-Features: AaiRm52CMWhsDdA5DzbnK7HHOMfDLT3X-p_y7TxCYYrUJhhfza2JG3sUA0yKvlU
Message-ID: <CAMgjq7DRGL-yLXLwmE8ww0+scPmjPuLYmbD4thcDbhPmk7HA7A@mail.gmail.com>
Subject: Re: [PATCH 2/8] mm/mglru: relocate the LRU scan batch limit to callers
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5877018000D
X-Stat-Signature: bqkdno6k71sgxp5ij1zpz4zmg7bx9wx6
X-Rspam-User: 
X-HE-Tag: 1773893564-837212
X-HE-Meta: U2FsdGVkX1+Cb8i7XEkrSAN6iTrQmFasBi1Ggn8NZ3V8sliZLIA9Ce/9oeQY5p+JEm+KdgFCnXyli78l2THnbYOQCNjC3zjmllY5KlhfQEKOERYQPRX0rtOHBde2OEupxdAz+0CEY47PnUl3ctKiAs8WTkT/2w1TY+f7wqnINwLD14xIMLqsChYIFRu6ycWDPYzFcOn6kOSsdXhVo9s5swfSCqbWZKFI+5qz73Bso+yM+yPsFTu+r9jKWjnwverj0cY0VzPmQtv8ka7x0nUoiEscAuOl3E5g/eT7bClRBvI/U171Ls7S/j2Pyo3zcPPQMjpWKqSPtagxotxGewJSbU/517p47I/qNa6PB4cqWbky29ztZV37uxWYkv5whY63UowDejEJiiyrTGJND+lFZ2ght0kn6b+IdH8UBvppWqAWX+eDl+MZjLlaJRFocjylsD6G1K7QgxkxSlrt0ZPFp3IBnITvM7fHEiBZIhZKyOE1538p9cthddf5Yvy1lThVsy3VHmTAdFnnz2FnX2csAo0Tlq3f0QcIXbtwGE26ENVArdKuLhk16US9V0aFKjcKboXp1FJS5JX05AtAzFefgM0LSeTR02XuOrZhGYc5dVvCJHhzk78sBB73DpzZCq7NLFZLNnnDZ6nw9EVovyrd9kw5mXuxvdGvvbk7Vft2CYwbYwCSeKAGV9IQ6qm0zbG2Q8iiPAbGNVMVbiX4Oeoe1O3vQySM7ectKstCd3pGu5xd8I8o133ZN66AIUxsikGCciyWcXR/MYSgghw33ZhOcI6h+Ip88v9xJUgMmItHpyKxMFIXcJtZN1SNUrt0foShMSoUWx5I8iLhaknqQLtryLtO+GUXAxicB0YGtFXCAgHaf7wbPof6RWltVTkGhU0AlH7pkYaeqTWJVJDDICjWxLCmFkSAbM5WHWJgk6tv6pL46/dOUcksyRrub555315Y6O9D25q11WnMqdL6d+P
 mMKRQYRH
 xbp8YKuPQF4JU0aTLOU7f3lRhCp+MwbCgNe9ECYMZ+5OIE9qskj/s/o3Fnm0LuCrT2gi7fUWGmZeFrFDgwZYoVO5s+tZ0oaR2XLIDB/C0oEV8yNQrOxNWkM9uQa8FqWu2YU66+/xNGLQtpcifYSwSYB2v6YCQP6rmS0peOgMDzNwkPPapXTJrnm/p+Jq6xdkF8XqOTGrYp0UT2RQMm9J18iuJXpB5UNMqb1iysWMCdUzmXtJahVWYFCcoNSOPXMzHhonGnjs0VDoFCzMvhyEZNGIMwhPG5fwMCkiRKTyDtL4lAq1Qbh0vXi4JH6CLv/MgNHqEcEJ8qo7MpdEo6Vk4FktHevIF+kv6cldYUC+DVwCjfyD1VZRmPeLQSsQD5dD0UO/OsTtkFCgCV9Rux4p47l3Gijd9re51yyYclFV808exrnMYLO2UZ7qqQvgsz9LQBfrm8JXlmksIjMBY8eIQeIpI29OkLuZ1QEFyVfiNWEieQBMBhpCGV5ZksF5eSKUenQgkaJyJl8WJi4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 10:00=E2=80=AFAM Chen Ridong <chenridong@huaweiclou=
d.com> wrote:
> On 2026/3/18 3:08, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Same as active / inactive LRU, MGLRU isolates and scans folios in
> > batches.  The batch split is done hidden deep in the helper, which
> > makes the code harder to follow.  The helper's arguments are also
> > confusing since callers usually request more folios than the batch
> > size, so the helper almost never processes the full requested amount.
> >
> > Move the batch splitting into the top loop to make it cleaner, there
> > should be no behavior change.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> I prefer to keep it as is.
>
> If we move min(nr_to_scan, MAX_LRU_BATCH) out of scan_folios, callers
> (potentially many functions in the future) would need to handle this logi=
c
> themselves, which seems unnecessary. The scan_folios helper should remain=
 cohesive.
>

Hi Ridong,

This patch is mostly for later use, and there are currently only two
callers. One from the default reclaim loop, one from the manual
reclaim interface (not memory.reclaim, I mean the MGLRU's command
interface).

In the default reclaim loop, later we want to control the exact number
of folios being scanned for each iteration, or at least use a smaller
batch value. For the manual reclaim interface using a large batch
seems more reasonable.

So this patch is needed I think. I can merge it into a later patch but
keeping it seperate seems more clean.

