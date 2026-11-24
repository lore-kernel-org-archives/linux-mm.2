Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E57A4606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 06:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JaCd2jhs
Received: by kanga.kvack.org (Postfix)
	id E188A6B05FE; Tue, 24 Nov 2026 01:28:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCA026B05FF; Tue, 24 Nov 2026 01:28:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB81F6B0600; Tue, 24 Nov 2026 01:28:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9989B6B05FE
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:28:06 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E9B840AC8
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:28:05 +0000 (UTC)
X-FDA: 85469032530.19.CDF381F
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id A862C40004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:28:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JaCd2jhs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795501683;
	b=ZxV+lWtDlyM2beZREaEVC/S9oHanj6qxk0wZD9SIrehLkxlTrqtt76WJUEGe1jOdK9UH/5
	rdSk/eA5k58PkhUR+2yYS+Y549IbJHG1EUGKrPkW5U3isIrDff6l2SJ4+M7EXCV9kDTkRx
	cwzzrcxoYdjGuNUYEeJJuFxGKs6SMP0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795501683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8CAifW3Lq2rK8dqR915PsF3RJe0oEqOH/K9Z6lx0UBA=;
	b=YkJev9dbI84hmtbSmORkWHVkbT/c46YgeklOmgHm3tOleOaSZFKHd3WzuDueYe1mmv2VAc
	zQEc2Ytk/xTEencxTgA4xvE7z0pf+ornbP8jWDwvWJ4n1LTB7YL/cPqb3d1NT9QfXonXf/
	ZLPBFSlUR73ThwMRkJ0pAxHBo4lKsQ4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=JaCd2jhs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8b32bc605d9so1925085b3a.2
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795501682; x=1796106482; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8CAifW3Lq2rK8dqR915PsF3RJe0oEqOH/K9Z6lx0UBA=;
        b=JaCd2jhsNLyPRwbVPlX6PHt9JTMAQ/ZSbgrbGlk9H2P6tG/cxXbiBBjAoZhRJxLovx
         1HMYdkcesXkhQgYrwncIJM2seI+yW81OeqKzlo3V4AI92ZFEtJIOATXwKtvM0ZNBWlGW
         3iFC8WWq5jNw0zGOpR9eN/mSzpPGKx+N6LDA8AmyWoSRHqlbi7h3PvkQT74XzIlSU9H+
         jGSGGCj+Q7SQyHFRzY9TntMhqfexC2oz54cL2yg9XbjQlmnKcBSdyqBJOuynQqG8jXh7
         ZHmcNKMsj7MbM7+R0HF8pgDiClxawaCq4+b+YXUmu0Ig6Q77pMhIoR2bts1b/lwapyRC
         lSeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795501682; x=1796106482;
        h=mime-version:content-transfer-encoding:references:in-reply-to:to
         :from:subject:cc:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8CAifW3Lq2rK8dqR915PsF3RJe0oEqOH/K9Z6lx0UBA=;
        b=uNaKMXg6aRoTAc8g4YONTJWB0zaLtYBzTq3zRp4oJusqzriVOYHFM2IxP3zIX3jfkf
         UnL/E3DWmye0JyzypDHuYQelZMbRkU35ngrJFFRq/E8coJkhOgezp77l/IJizhbN1xey
         q/meGoEgmT3//gmDw47GQYeD0+w9/k02SmsfyzIE3XOuZqS06BNRD7nOZP1ARRrSAkIt
         F2YLWg5wPuW8Cy9OTK2KVxjhilq7sRCptmYIhsG5ZnpB88YHU4j6o8KW2XTodX3K/aWa
         i5L0pbLLmCeruLYcw0j83SxXLoD+kajId2QlzgvUiCU8Yc6NV1aK2iiZk14QJNOd+lv9
         ZtgA==
X-Forwarded-Encrypted: i=1; AL+hErHrklGCictxWIgtOgs3uK+rfQtvgHvGfr81p/M6qpOUCvc1ZO7V2IOp/0ku/NfLOa0J7jXQmOdj7Q==@kvack.org
X-Gm-Message-State: APuU4Z9um7ju6QTOoQZ0zMXUi5RGljytYm45Gfc6MBrWCuyE0G2AWGS4
	wzm2w2Smo81AyBBzUeahpQXUhKCCgaWA+4VrWA0uMVdjYefszA+kETJi
X-Gm-Gg: AZFdTZexc4KWugD9s7BbOW6ZqOeLwHTpB8LMCyGSmSZscyJ4e1Ddnl7A93UlDGRyFRc
	yhrzK+SGZ7hW4Gxqz3H8PgCeJKFHmaueBrEf1zY90QyyEuKzlqOENHGaJNYXOu+5quVSIkgXlcq
	dwaUj89SKm+lRlUEbOVKN/RNMbzvfo2eCP7hLdTi4X1JaIV9P3fCyx7f629xf6vyyO81i8bUEAA
	nbCKyZELTdACKu5zdpuFXV1og+N77sovFF0C+RBazUVRdTbtYGjc2hOHxETdH142SWT5XiacWsS
	bv4c4clkbBiTKY57Q9dLdHdxF73Q200NBT0iUWEeV/ykHztY27h1szkD/NGn0HK46EARgm/WskP
	XwPxJdJov1OnGaNHuC/uym9Uic3gpADTN9kCx8a0PD62p+jbZ1swmcoL1JttqQoTSYkCYveIKAz
	Y3xQqzsH45Tg653uIIhMoYSt8BsWqpicwMeNSUkzca/8U7y2V7r7oUNkRXgzhW3U1U0NVs5bwgu
	8B4TD1BLY2hrMLlW3Or7yCR5I2++RpFXyReY1FAKIblGIkyRA6lk88HpH5HBW/EMCL88Ju9vXZf
	QXqRlxhkS6NTswde9blqV31VpnFLOzrp7qQ2v/Tm287o5F4BFxCZgixouULVVfzUYkct1/Xd0PO
	23HsMAr2XgElcuAWlh8AnZgl4KDD1KUnTz4DDK55hUqFIVaQJQmu9wGE=
X-Received: by 2002:a05:6a00:410e:b0:87c:e6aa:30ec with SMTP id d2e1a72fcca58-8c87d31f4ccmr11608144b3a.49.1795501682157;
        Mon, 23 Nov 2026 22:28:02 -0800 (PST)
Received: from localhost ([153.61.198.251])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e45756sm6666168b3a.27.2026.11.23.22.28.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 22:28:01 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Nov 2026 06:28:01 +0000
Message-Id: <DN3885A9PVWV.2FTTIEAKU4QXI@gmail.com>
Cc: "Puranjay Mohan" <puranjay@kernel.org>, <bpf@vger.kernel.org>, "Puranjay
 Mohan" <puranjay12@gmail.com>, "Andrii Nakryiko" <andrii@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Martin KaFai Lau"
 <martin.lau@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Mykyta Yatsenko"
 <mykyta.yatsenko5@gmail.com>, <kernel-team@meta.com>, "Liam R. Howlett"
 <liam@infradead.org>, "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Pedro
 Falcato" <pfalcato@suse.de>, "David Hildenbrand" <david@kernel.org>, "Jann
 Horn" <jannh@google.com>, <linux-mm@kvack.org>, "Chris Mason"
 <mason@kernel.org>
Subject: Re: [PATCH bpf v6 2/3] bpf: switch task_vma iterator from mmap_lock
 to per-VMA locks
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
In-Reply-To: <awSELWmIo2LA3bM8@gremlin>
References: <20260408154539.3832150-1-puranjay@kernel.org> <20260408154539.3832150-3-puranjay@kernel.org> <awGZWsCp6v63H_py@gremlin> <DN267JUKDRNS.2VMV07CQ58R4X@gmail.com> <awSELWmIo2LA3bM8@gremlin>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A862C40004
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: o4cuud6kf1dizmksj6nqfgk93y78nixk
X-HE-Tag: 1795501683-379525
X-HE-Meta: U2FsdGVkX19UcNQVygt+vnSd17ucX1r6+QBraajuQ7hzPLsM71/7UD5PZtEYUY75ssqEmQ0dwX7mHNoqumF0k6IrduBoxz1s77XYHSyrfa8H+0OWLJScp0n3BrogpZOvqKhJCKwzXuJyOTJI2pEqT+7kQKlnO48z/0Vz9ihj+D4cPeRGFFCvaqqbF61nRQNDkg0XVZkhkow++ZOEGQ71evMPcDnIIzE1X3GcRkne0xVLg1kPwRBDKmaITyh4UVDuuFS1tK2WOtXLPiYqWPqlBUVNJzFofcopDq1So+KzAIwlsxJ8+r+Q9bihTUfIpUYZmZsfbJNEiUt6Wk7ixb4TgIy199gn/Y5A+pXBa7MefV1/jviJg6iAvX3vUjB8MzhzU6p3EjGwQK1VwCGq3SRKD2qkC+gSPAeZ3DA67CFP/7JxdmCPJ8/+7J6xVNv+3Xk8XIJK+rIXqS2Yw1FVgO2Pjqiqv8p/YzgAp1ehhigGxv8fP+V4LiCrxE+mBzLM0OR9lVV+GKHxH1EgJuGjzIIVg3a9ayDHEmdgvEyHQxJV2Q2zSePrsvd/miiC1aqtLne8JQfhUM1aG3xwkB11KoFgTAXn49ImTkwz330hxyfsFbzTGPhPhkK0JDLr4cVwYioO1w9vheA0vINkJtU54HV5+MItHqLwFpS/QacahQ8yMmmZN4GzmScKiqJ2iCV0u1vmDmnui8jYvsARJOE+Fi25PVIFlFtvYCnFGqYVVTa09bnGOPIKkRVeJGvj3Ly66HI7fXCqzslPxLtDRTodJA7sCZKboIim8L6hhNvisKeAkCZdR6TL3ibDqUxodH9gUC5pgg1Wzn/vznSCG8rC4kdGf0oacW7VzFMENxL1Sgi4enqkGqXhd+inkpW2XdXBsRbDpANgK4u+3DCTBcpP1aXW4vECsaUb5cQ4IgXXOJC0oxTNXXd7j9Oc793a3E1OyOMIiNtIfgqIPAjt8IjgPeR
 9BqWiq9t
 642QCLX3xkGDf4/7OY3xDtiduj9RuynmhxQKQEobxVu/eAG2LExwf66pRdWc5jUNIDyKcp7giwVroi0YbFj+yXMaVQwVtFVRgN2ptR23TEFXJNfCkwB8cJCNf+fm1SSqMaL1pux3jMiE6QGRkBaEZTjEx2wxKjXNwwMmrtEDF6Y6dm9/p9P/Jt9d+UjWSK29X4895kvPOGwX/MXpPtlF5CIZhsAXbOAf4ti8umR0zVCGgUpoQQqgVuYxu083gdnshW5FC+kcicpwRcYEEb7khpmeynlWr0DJdoMVEIIdkjlheBko8lzoq7MpGosVBdc9YOj7vHcMpUfep2faNnA128RcUuaJLNsVnhP65W5Zhwt+QnidNgTD14M0RKJ9v4DQm89Ame9HxfTpL/FBIBNY/z0otSVxS45OKDstjeuhURPMOb4s2+5KrgsnargY9BpkLBMqiPjZaYcBnRf5iiGIatJXl8w1JFAqTdPwFTwYISMiduI0oeN6X0WHbnbd16DsdsWACoKEwupSxttcxaKVnasCr8tNbpQSkMU/q56gYILVAZ3E564MLrPntRyOyoUcoR5jMK2DwGonfIwmHsxnDkucx2fjhaF8JPvIT6VzhtAnx2FganwHfVmOkEOB8VSj872zQQBjBie6niNFZP0tTJAranXRGtWuSDWAtAoszDdJW7qW7nyyJOEj0IZxifLOq9XlfZeGvmoQwgI0LxsSzXSIUGT+b0FsNL2r+2rMJotB7gfPZ8QayT6ghq0bk/lj9lIdBJbbOfkiBCQ9Gjon8DcxZGRH7bqk/1doblJzgX/wk2KHHM7viX0YKXayIIRvAkW+4YP56+YIes7gzpPnEhDih4zGhsedYiF4Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 10:36 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> Probably then mm doing this is the right way to fix it, so let me have a look at
> this and send a patch.

Thanks.

> But yeah, let's also revisit this open code and have the VMA API give you what
> you need properly as a follow-up.

Yeah. true.

