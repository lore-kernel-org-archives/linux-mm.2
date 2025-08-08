Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E3AC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 13:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26BF6B009F; Fri,  8 Aug 2025 09:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEFD6B00A0; Fri,  8 Aug 2025 09:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C976B00A1; Fri,  8 Aug 2025 09:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A34F66B009F
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:16:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 775701A01DD
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:16:54 +0000 (UTC)
X-FDA: 83753640348.29.62821E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72E59140014
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 13:16:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GAk9z0KX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754659012; a=rsa-sha256;
	cv=none;
	b=Yrc4h+JfF+5v97c2wP1aTzWvQdZW/Ubq3n7hGFJP2OHY2d5HXgE2LUmlRucLDRDTfZfQx5
	mkWfaQ0z1mqMcXkCjP/Am15qY2SvW+54PQ2fcPf8CjlSb5AiLIMpOdUvyrwTToD6i0Ls8X
	e2c5ol5ZhMowHBcuzzjZM0y5zEnoQiw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GAk9z0KX;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754659012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+4nRLUZyUNTfksn4kFj0u3mtM2LKCIPv2I+IwbAen+w=;
	b=lwQ/CU0mabis7mvm8PXmUUroCzy7PvnUfrvc9ADzECzaWq15C9RuoI3qMNBDwHftPMQa8O
	F9EOBMGU+rSVnvY9h2MAtRGzHNGJEdsPLpbELukaxk2CyEvOp+wvV5a1jpzkvzf7eBjnVv
	OWp5K6+t9iFOOoBfi6WgcH+2EpAP9KM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754659011;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+4nRLUZyUNTfksn4kFj0u3mtM2LKCIPv2I+IwbAen+w=;
	b=GAk9z0KXOZayOMzkQE1YypquNu9tk4lhJJC7TrgswyurWik5W0b5RrriwHjRV3iOsOmR6r
	AIbyCeDoJeWB9y4UfnZObzELyHv0GLeCY8Rz9HtR/litXGgzQCZQI9bLmVkGJ6m+TSF9aI
	aQadbMuu8y3YDVCtaJ2SyZgKbPfoivI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-g6pVE89ZNq2vZa_PmYv4ZQ-1; Fri,
 08 Aug 2025 09:16:46 -0400
X-MC-Unique: g6pVE89ZNq2vZa_PmYv4ZQ-1
X-Mimecast-MFC-AGG-ID: g6pVE89ZNq2vZa_PmYv4ZQ_1754659005
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 96A451956089;
	Fri,  8 Aug 2025 13:16:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.17])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5FE8B1800280;
	Fri,  8 Aug 2025 13:16:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Mina Almasry <almasrymina@google.com>
cc: dhowells@redhat.com, willy@infradead.org, hch@infradead.org,
    Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
    Byungchul Park <byungchul@sk.com>, netfs@lists.linux.dev,
    netdev@vger.kernel.org, linux-mm@kvack.org,
    linux-kernel@vger.kernel.org
Subject: Network filesystems and netmem
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2869547.1754658999.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 08 Aug 2025 14:16:39 +0100
Message-ID: <2869548.1754658999@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 72E59140014
X-Stat-Signature: ru16rne6yms8iqknm95ueg8fzjqok99e
X-Rspam-User: 
X-HE-Tag: 1754659012-539264
X-HE-Meta: U2FsdGVkX18tVwy7pTlP0x00t9wh8QxzVoVmXUT4eQkikrz16dpcyo5AOhYBJfStlwWLu7TDSG0dAr+i+8NHwDoxZWAlB7u8HOO3T9DzqNQY3M1lJI+NI1UIWsiun9J3dVji83BCxEbKX8d0twjt0x8ANHkZFIJhCEGryGJvvUG6zZBiimteQ/aK3JahdN+aqNxtVK97XkSwVov/L+UGglmLHTNuvZawyBwjUhO+1/a5nLFSXsYIvfTOG6vkgv41HjzGUIz8ZGRryVHxAUCucF81m4J9PegcNcIw1u55dj7xmcnR+aFT+p/67G58VCYPtV6qaDlWTOqBOyqQPvzwri3SmJk9FcQqpZSGzx0qU+WAEcJ0lzeAbYXW6Y4hX1klNep/jM3vLp2gwEA4iIUL9kKV9Ai5NzNR8sJe41If0bRY7vfyBcmzk5ZLpsc+BDHOHp+27caywRY1Ny8NgvAdjPkezB+562rIsy4Qj7PPRTF+pgsYdThAifzOgG4C3Ih0lvy96fbKuRXq7dGzZYvxRDevdUKyJEwWDkOy8MHtTuFds8Fu5mAlLibcac2NrPILpM7zvabGSMJRl5OE1WJzy89z0TqU9phbWifmXhKCJLpzIYBSBDfG0JHmfh4aRt1SGYlQQOmhK7xk6B3nCmIxrIUCu40BOzXqPT2bihGC8ZpnynYNzrh19pXUt1xOQOIfMAVPkFNFgpCNV0H6y0291mITx7PAvNmW2bgDqhyQjbKm22W8noMDLYcHg34dD49WPnrf8M6zdC09ZyeXK2hjQLvZPzaBEzqwVmVYpwzHy1s5lUZnEElqMHFAxSMLIDXv35vkD8mbqFDYIKw/q5M0gF8931EiKRmKxeMnc7z/1uarsb93dqqpS6W1isjWl121ZtT7RvqDNhjHAo1rUTIFbuce4c34uT0ki+OhoicQUPQkvdAfFlccIn+NJsN1GamE2Lrn6B7FRvUIeejvIeY
 hIRAIZrv
 q7q52cEVTeQCGXQI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mina,

Apologies for not keeping up with the stuff I proposed, but I had to go an=
d do
a load of bugfixing.  Anyway, that gave me time to think about the netmem
allocator and how *that* may be something network filesystems can make use=
 of.
I particularly like the way it can do DMA/IOMMU mapping in bulk (at least,=
 if
I understand it aright).

So what I'm thinking of is changing the network filesystems - at least the
ones I can - from using kmalloc() to allocate memory for protocol fragment=
s to
using the netmem allocator.  However, I think this might need to be
parameterisable by:

 (1) The socket.  We might want to group allocations relating to the same
     socket or destined to route through the same NIC together.

 (2) The destination address.  Again, we might need to group by NIC.  For =
TCP
     sockets, this likely doesn't matter as a connected TCP socket already
     knows this, but for a UDP socket, you can set that in sendmsg() (and
     indeed AF_RXRPC does just that).

 (3) The lifetime.  On a crude level, I would provide a hint flag that
     indicates whether it may be retained for some time (e.g. rxrpc DATA
     packets or TCP data) or whether the data is something we aren't going=
 to
     retain (e.g. rxrpc ACK packets) as we might want to group these
     differently.

So what I'm thinking of is creating a net core API that looks something li=
ke:

	#define NETMEM_HINT_UNRETAINED 0x1
	void *netmem_alloc(struct socket *sock, size_t len, unsigned int hints);
	void *netmem_free(void *mem);

though I'm tempted to make it:

	int netmem_alloc(struct socket *sock, size_t len, unsigned int hints,
			 struct bio_vec *bv);
	void netmem_free(struct bio_vec *bv);

to accommodate Christoph's plans for the future of bio_vec.

I'm going to leave the pin vs ref for direct I/O and splice issues and the
zerocopy-completion issues for later.

I'm using cifs as a testcase for this idea and now have it able to do
MSG_SPLICE_PAGES, though at the moment it's just grabbing pages and copyin=
g
data into them in the transport layer rather than using a fragment allocat=
or
or netmem.  See:

https://lore.kernel.org/linux-fsdevel/20250806203705.2560493-4-dhowells@re=
dhat.com/T/#t
https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/=
?h=3Dcifs-experimental

David


