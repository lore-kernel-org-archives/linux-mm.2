Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A397EC87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 23:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303676B009C; Fri,  8 Aug 2025 19:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3266B009D; Fri,  8 Aug 2025 19:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1B26B009F; Fri,  8 Aug 2025 19:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 069AA6B009C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 19:28:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A0F51DCD0C
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 23:28:40 +0000 (UTC)
X-FDA: 83755182000.11.B16EF03
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5330E100003
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 23:28:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q4hoJV1+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=almasrymina@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754695718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+d20oXyWLn5bjTnK6D4tXgCVrsEi/H5G9og2EbOp+8=;
	b=rzSJTNS33Bp268F6DQ+T6TJd+GBhzbk8bp4GNCT1an0UolcISErUMitbiaZOe5Am114ED4
	7ei078iSst24BUnHtGdERJwZIXLOpjcFwxZIRIbcXDc1/xJJ0k/CXce/r3l2aVH/PAMnF/
	2vY3iaaub60bs6cHbW+MeU5aGBMv8TM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754695718; a=rsa-sha256;
	cv=none;
	b=MgDfoOO/0MHqRQj8cYnD1Gx84EdDx/W8JjwXVFrFrot1++PrUvYXYARGEo/YB9GR8i9GKP
	G/IA+thNN2Bgau+4HBrhAIC7h30wgtrYLq3F0KlRzhHcqyZXEyPqP2I8HUC55XbZ7cxOV8
	1t5xuvy4oexSSKq+daX7nt1Q7r+wyRc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q4hoJV1+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=almasrymina@google.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55cc866f01dso1384e87.1
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 16:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754695716; x=1755300516; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+d20oXyWLn5bjTnK6D4tXgCVrsEi/H5G9og2EbOp+8=;
        b=Q4hoJV1+M8flIHUwYzZeJZ1UZ6zxjmk978e8E8SAtjvhY/h2vribPMWAGaCcu0xCsV
         /t98kKlc680v7xUDCtjR8c5Mk2HCb6psVt4yVVuuyzj3KictuQMXtktCn/LlWS7cC2Nk
         wdM0pIlc7xMZItBcP2h/wtFeH9JmVmkDyz6+m6+6LG86RiJ8+kAWAcePxpjP1I5KW9b2
         0E7AMlvLVNd7EEcX3+066yQ1GZ1h3WMTuv0Nqpa1/MC1kYKW9f4/NrgCmpriPOHd59CP
         O64L50TxNWHF1uvrqP5ge3DcdwdmtzVCjFGEGZP68n+LTdbRZy39DV7c14TC/kpC77/p
         aFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754695716; x=1755300516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z+d20oXyWLn5bjTnK6D4tXgCVrsEi/H5G9og2EbOp+8=;
        b=ZLbep9TktpAwnCv3T7IeWia4AM/TazDdOI+Cp/jQUw+DyuLs1uVFxa9WLe+9biq2Br
         SJUm3mkPjBgbLhjaEb32Gfz6kRspPYmdFAcokmNESi8aL0YGvwza169QU79d4B49ceMD
         MEgaaslp2hIeqy+PUKFASwVWYHtwXqAJemCizB0e0ePzAX9H3a4aXBf2NU0AE0j/Pj2j
         vySHVIrkY9W4szA+4PJfNvCATyyoLaAxBHBQFc9LfwLiG9ppm2j+Yysz+ZlBler9gMiR
         Erg94aMLcmi9EQas8Ksuz1EJtYnfSams3FXIs1Bvh2RM9IExaX+lcoSnBR1IKKnbGUOZ
         HERQ==
X-Forwarded-Encrypted: i=1; AJvYcCUi00aEiD4VAgiJf09p4W9WTorUxGelXIiyM5YfFkx1EjdpbKBR6nl4NXt2+NyUQ/cwF8dEjtPTeQ==@kvack.org
X-Gm-Message-State: AOJu0YwWDl5QgOjGdxx3leh4T1KhetDR8ebp6R8qDnahT1OyOvVHB5P2
	fODyjInXSQp3npqP8wAzY3rFyFeUJLWZ0V2+URyijbh1P9eEZ2nb0oNdnNwfSKtycT4hL++nJ01
	hJU87MD4Em5NEL6xiH5/qWCSJHwFRf9I3dkfO0kcc
X-Gm-Gg: ASbGncuUQqPpXgpCi320YdFGODIGMmHWyLVi4nRqDT2x/bKtwls5bZrHH7zvPSLMhJa
	8Aovz9dolBv72cU/jU+M7D0eYQ7nIDuWqwFPRw8N3szHw+Xr2XfyDftFMGq96zt7eizkdiC2SFv
	9zPeXJy7JxwKgqDPozbee8rVj2YSRN2wAfP1ESWwp4C2K/TogQh5brLEej544Dd3Yl4V/ZDrXwG
	wtBmwoJeNvNAdVieXrDRoDn2YoxCmMVPFxQNZ8SzjKzprRW
X-Google-Smtp-Source: AGHT+IEdv1w7QaR/0N5fORVsH+DJ9deVF62A3/i1e5So5KwiAuzIy0EDfzma97+kI6RU9BDDGv1QEy9xGRRRodJA/0Y=
X-Received: by 2002:a05:6512:1145:b0:55b:af38:41db with SMTP id
 2adb3069b0e04-55cc89c7bbcmr60515e87.7.1754695716156; Fri, 08 Aug 2025
 16:28:36 -0700 (PDT)
MIME-Version: 1.0
References: <2869548.1754658999@warthog.procyon.org.uk> <CAHS8izN89j9deyODUjxQroKrLoiAq1kF+RVowuvVecmg4tNAUg@mail.gmail.com>
 <2941083.1754684186@warthog.procyon.org.uk>
In-Reply-To: <2941083.1754684186@warthog.procyon.org.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 8 Aug 2025 16:28:23 -0700
X-Gm-Features: Ac12FXyPh-Jfeqe4_Ia59zNE4ggMPY6p0Hb0AzjzpPYfgU0oYp45vqpTmqQE3_w
Message-ID: <CAHS8izOj3OCD6+6GD9foc53J7u9o6-VK+YS-1RUWU4NR6d-9bQ@mail.gmail.com>
Subject: Re: Network filesystems and netmem
To: David Howells <dhowells@redhat.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, willy@infradead.org, 
	hch@infradead.org, Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Byungchul Park <byungchul@sk.com>, netfs@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5330E100003
X-Stat-Signature: ztyfh19o3eann1dhzki3texxeu68983y
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754695718-666774
X-HE-Meta: U2FsdGVkX18ML6AU896QMID6a2NUhS81zj6jSs3Sv5GOGTwvRPb4iyK4AJ+Ep6Qu3+e/T5NKGwqxU++RrzidFfz9VFRM0LhspyGWsOWOot22qwWK3dYdPxNIhZooEjUUVJcQdz41jR+fvNrqFADip6mgp04xBkbp/ZL70njLocDmzVM6pC+fkFpLZZAadOmrLeSma1cGuKIDwr2Xjkz2Dyb7w7vB8zlP75rndgPTJKlpGvCFM8m/RsEt1kC0si3BGVy8HQf+yycEwu07H3QCA9VYYpGC8HK+1PVuQAmUQODohEnfeJAFrVthz0uctsRxn/hmP+jzcdEoqfLbtlqXG8GeR7VRbe1g9RbfYPnbyWSejumVZyM0WNHa9bcdqqMyG9DLLp8x/yJZ/HOa2SuoopT2C9tpabjl/P9zXcYf3ed1zkpuu1dP47hogVZCv/r/neyZyIhhEDvBbUwRlcTIrUs2Cy9M+Jn++ZoodvFhuLE/fEV3A8exMQmmM2csXdQw20Q6A2MDq3HpzJPgbJcjIuXzHgYOnkpzUtVbzF1Cn+FvMMIr8rxjdlMKFOm3ck/2YRuz8SeEVfi3WBFXU3b5oBATNQqbpptLjtVwWYaVA9i5h9ZW7Vhpqx0NEJ67fVm7kvLmOzr5vseOD2QtQEAbCVdLaz6A7IhAp3RvkRu4Jm21pMGqTAhGk5o+8ZVuO2eqX4BzqJtbkpY7hEmixWyVEA28Lic8WBIZ6PzYobt+UBY0oyXujkoW7tfSXqkDYklM8fdML4b6FGj8IqHn6zXeb+FKcjb1J4z4NDod2cP1qliEGBMlxLGSlbxxn8TZMqFhoHbrzs9+W5Xq8okDz51wU86llupkzJJPFYJR1FnxyHUPUwGlY/JZXDesIGlRw8CKU+P0tYELqth5emk8L1TA0ueegLXVSLVoouyzIHHJa8DwpXwHtd8/yxQuXhVHX7ifL2ns3yPkfjT+UvnYVrL
 vnnSt4Yf
 2tjJwRu2pqasuwrzc/68jT9tf4YGOv33iWnnZE246qF13yPnLqufhsrwjvlOOQ6e+7eOOe+N+qaBcus3VmbDf9/2EGkO71vsqbGePj4Tpd2mjtzCWQ2banDE01xgpoCQb9OQX4/QHokLFk5bEPBaOOMDQMSGlj0rSTy7bnbIqa1CMMMu4uGXGO+7IBgsNoRJrLdiK/ctScxrH7ASoRw2LvpJ1zGbgPwYL42Q3h9JXWTGMEOfL3Yi8XVqVDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 1:16=E2=80=AFPM David Howells <dhowells@redhat.com> =
wrote:
>
> Mina Almasry <almasrymina@google.com> wrote:
>
> > >  (1) The socket.  We might want to group allocations relating to the =
same
> > >      socket or destined to route through the same NIC together.
> > >
> > >  (2) The destination address.  Again, we might need to group by NIC. =
 For TCP
> > >      sockets, this likely doesn't matter as a connected TCP socket al=
ready
> > >      knows this, but for a UDP socket, you can set that in sendmsg() =
(and
> > >      indeed AF_RXRPC does just that).
> > >
> >
> > the page_pool model groups memory by NIC (struct netdev), not socket
> > or destination address. It may be feasible to extend it to be
> > per-socket, but I don't immediately understand what that entails
> > exactly. The page_pool uses the netdev for dma-mapping, i'm not sure
> > what it would use the socket or destination address for (unless it's
> > to grab the netdev :P).
>
> Yeah - but the network filesystem doesn't necessarily know anything about=
 what
> NIC would be used... but a connected TCP socket surely does.  Likewise, a=
 UDP
> socket has to perform an address lookup to find the destination/route and=
 thus
> the NIC.
>
> So, basically all three, the socket, the address and the flag would be hi=
nts,
> possibly unused for now.
>
> > Today the page_pool doesn't really care how long you hold onto the mem
> > allocated from it.
>
> It's not so much whether the page pool cares how long we hold on to the m=
em,
> but for a fragment allocator we want to group things together of similar
> lifetime as we don't get to reuse the page until all the things in it hav=
e
> been released.
>
> And if we're doing bulk DMA/IOMMU mapping, we also potentially have a sec=
ond
> constraint: an IOMMU TLB entry may be keyed for a particular device.
>
> > Honestly the subject of whether to extend the page_pool or implement a
> > new allocator kinda comes up every once in a while.
>
> Do we actually use the netmem page pools only for receiving?  If that's t=
he
> case, then do I need to be managing this myself?  Providing my own fragme=
nt
> allocator that handles bulk DMA mapping, that is.  I'd prefer to use an
> existing one if I can.
>

Yes we only use page_pools for receiving at the moment. Some
discussion around using the page_pool for normal TX networking
happened in the past, but I can't find the thread.

I'm unsure what it would take to make it some-tx-path compatible off
the top of my head. At the very least, the page_pool at the moment has
some dependency/logic on napi-id that it may get from the driver, that
may need to be factored out. See all the places we touch pool->p.napi
in page_pool.c and other files. Or, like you said, you may want your
own fragment allocator, if wrestling the page_pool to do what you want
is too cumbersome.

--=20
Thanks,
Mina

