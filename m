Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2EEC87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 20:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F345C6B008A; Fri,  8 Aug 2025 16:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4AE6B008C; Fri,  8 Aug 2025 16:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFAAC6B0093; Fri,  8 Aug 2025 16:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2F436B008A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:16:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 492F1B99EF
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:16:41 +0000 (UTC)
X-FDA: 83754698202.07.ADAFBC5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 31499100004
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:16:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E4dpJVXp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754684199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dODnAzex6kez236sAmX2/xLcfh/e67rE65nHZQ8pCLU=;
	b=x8ebXjAIcFhnqWUaoM+RZwRhrRkuYtfj+F7V+0n0hhE48GKhjyamQOZsPOzJ/NcDtVPPHz
	t414P9Rs4AbEUOaCQFsggDHlHU0ea5dRgnQykIrOpSwEhCI88JtJaRyDNQzs/ommltPOEI
	DJM1VxFx9jkHq3GbDOjal7rElegmBGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754684199; a=rsa-sha256;
	cv=none;
	b=A3uUvOVRRsP8y9OBtidroNJHNG1cl3N5AaDN3b7cqsC6gR/c4zZZjuissZPaIFT4+6Ry0X
	8OARL70r+7yRUAy9F8Bl4Fi/D/ibgthmH1dLMOtYo34QpbJpR3Jn6LlWvCj/bbTDKK1KCv
	jgbWa/7COEV6GZRgd8oOrPlfbCRjAGg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E4dpJVXp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of dhowells@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754684198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dODnAzex6kez236sAmX2/xLcfh/e67rE65nHZQ8pCLU=;
	b=E4dpJVXppDAA1ea/WphyoLBnd0flfJH9nFbhe9083RHOUdlG8IqJIvrvBsyohSbE/eAe8/
	6TXDDDLQSRtswaAubm83kwcj+CtrJxWOYEHLuvn1a5ilwQUUuSYChS+FQVzvOy2T/GBLon
	MKu4sQFauAyxtJNRizGL23gOdOmVSXo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-ypUQXZedOVqWhEjxpVEsVA-1; Fri,
 08 Aug 2025 16:16:34 -0400
X-MC-Unique: ypUQXZedOVqWhEjxpVEsVA-1
X-Mimecast-MFC-AGG-ID: ypUQXZedOVqWhEjxpVEsVA_1754684192
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EF831800446;
	Fri,  8 Aug 2025 20:16:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.17])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 42D5F180029B;
	Fri,  8 Aug 2025 20:16:28 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAHS8izN89j9deyODUjxQroKrLoiAq1kF+RVowuvVecmg4tNAUg@mail.gmail.com>
References: <CAHS8izN89j9deyODUjxQroKrLoiAq1kF+RVowuvVecmg4tNAUg@mail.gmail.com> <2869548.1754658999@warthog.procyon.org.uk>
To: Mina Almasry <almasrymina@google.com>
Cc: dhowells@redhat.com, Jesper Dangaard Brouer <hawk@kernel.org>,
    Ilias Apalodimas <ilias.apalodimas@linaro.org>, willy@infradead.org,
    hch@infradead.org, Jakub Kicinski <kuba@kernel.org>,
    Eric Dumazet <edumazet@google.com>,
    Byungchul Park <byungchul@sk.com>, netfs@lists.linux.dev,
    netdev@vger.kernel.org, linux-mm@kvack.org,
    linux-kernel@vger.kernel.org
Subject: Re: Network filesystems and netmem
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2941082.1754684186.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 08 Aug 2025 21:16:26 +0100
Message-ID: <2941083.1754684186@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: qd7ubwxmzcym9ifjiosdgiceoun5xt5k
X-Rspamd-Queue-Id: 31499100004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754684199-815200
X-HE-Meta: U2FsdGVkX1+3fKR/KHjsQ8ZhCEYtk9km9whka3/VvSO9P7z3dL9rSiRrnHcpeP7us5LfJeuRCTOvcZHBashQv247gOoWfqeS0SO8+0mabEUI1acH9+5g0nk5MdcKeeQtaL0y6S2LCFiC+mf2TV2QHXD2D8Mzehdyo0a2VZAz+XIL4axOf58DPB+BN59dUcsm53kNFSR7Onz0JeYZwg6w98RWTz1GGdCEzX8xD/bZ5P2Le/RDvvOaGr892wYilp8tuniXcSGkx179gcvTqdmqsE/q9rUpgRUZH8yQ1x4hjeKgE+MoZY+ZjV+MJ8jtQlSxcxlIXsdmgw2dgv9kFtkNlxwCt4WU6INjjnzp03mWdN3StD+wbKFSsdktUYvw6DMpuGLT+t/PhCUSC5+3QEHs0oT5tAbrGpzuYkPqYNtI2aqa6NE7NDhLkTNybSsuWujYwYtYClUWEw5L7qrfcBU5RDHfJwxr/sXRiO/45U9T+ewTGsGyDV+3nqUxVtEcBxWP200zw4e9PLvFHsjIy1h5Ci3rOYY/9NiB0ltv8DFT9QlV7V/LsMi3pRBVVwqXvLaQsad0FNlaNNyPdl3RuB9ODM/NBuPf25OHzAIaGKzXPun8YzflPGA/OSo0DBWXEfm2upBJeuiz+iAW49kquS0+/ks/+OipUM+NTkGL0wT+VQo+pwcY3hypbRiRDFsKdB7oAbz3qhgPm1/L+Jz21UGQVGXLSC4BO6wmPiPfAJ1+hQz2QwLuKLS/mVtrK4KKr0Cjyn/vUqEmXhk4MqCJOifezfIcedgFOzpjG2w1XdABatO04rLdn9SmC2J/9kFYpR3AzsgOnKz9Ac60IlAGJJaEIIZ25W/NB4BG8iDcF50DM3d9yzuoHpPOycq7j+ntIoHQARTJj1yXf+oiuBT78ayuwK50kc73f6h68kSnDH8t4t8tr3QRVbm+AixUlHon2fcWUmdqz3Uge7ejUZygahF
 lBeYS/f2
 c9rtlhKhNVy985Nf0dQPp+5C2S6oU5kkT4LpIvomfs3CA9+WAf2dra9/ZyiRKvXqJEgLqftpzItQZqus6gF0G7jegbrRWUbOcff2MOU0iZgwJaKxkdex6+HrYwQQjLBWxx32/1jDEFdolyRF4Fo8doaE1dSiX7fLinMlbWw4/CP6PhrOsgX140dzXy+2mK9qTvlUaG0dkSz6gW7Hpk40yUXQ6AyYU9pJ5B8QkkcTj9T0TNFBHCx7gc/lB7OFWTIifYz63SoB0kA645xVMKA6Q8AhPII10ZMn3cm0HyysGwT+N6gTRcf0JiqyDcyDTb7L8UPGyS+Bjk0BSqOBdLaI0iZ+dLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mina Almasry <almasrymina@google.com> wrote:

> >  (1) The socket.  We might want to group allocations relating to the s=
ame
> >      socket or destined to route through the same NIC together.
> >
> >  (2) The destination address.  Again, we might need to group by NIC.  =
For TCP
> >      sockets, this likely doesn't matter as a connected TCP socket alr=
eady
> >      knows this, but for a UDP socket, you can set that in sendmsg() (=
and
> >      indeed AF_RXRPC does just that).
> >
> =

> the page_pool model groups memory by NIC (struct netdev), not socket
> or destination address. It may be feasible to extend it to be
> per-socket, but I don't immediately understand what that entails
> exactly. The page_pool uses the netdev for dma-mapping, i'm not sure
> what it would use the socket or destination address for (unless it's
> to grab the netdev :P).

Yeah - but the network filesystem doesn't necessarily know anything about =
what
NIC would be used... but a connected TCP socket surely does.  Likewise, a =
UDP
socket has to perform an address lookup to find the destination/route and =
thus
the NIC.

So, basically all three, the socket, the address and the flag would be hin=
ts,
possibly unused for now.

> Today the page_pool doesn't really care how long you hold onto the mem
> allocated from it.

It's not so much whether the page pool cares how long we hold on to the me=
m,
but for a fragment allocator we want to group things together of similar
lifetime as we don't get to reuse the page until all the things in it have
been released.

And if we're doing bulk DMA/IOMMU mapping, we also potentially have a seco=
nd
constraint: an IOMMU TLB entry may be keyed for a particular device.

> Honestly the subject of whether to extend the page_pool or implement a
> new allocator kinda comes up every once in a while.

Do we actually use the netmem page pools only for receiving?  If that's th=
e
case, then do I need to be managing this myself?  Providing my own fragmen=
t
allocator that handles bulk DMA mapping, that is.  I'd prefer to use an
existing one if I can.

David


