Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CE9C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 20:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E256B0088; Mon, 28 Jul 2025 16:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7AA6B0089; Mon, 28 Jul 2025 16:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29EDB6B008A; Mon, 28 Jul 2025 16:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11BA56B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:47:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8571458D79
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:47:00 +0000 (UTC)
X-FDA: 83714857800.21.1914C82
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 67BBC80009
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:46:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ArcG8R8S;
	spf=pass (imf30.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753735618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wg5ivtWALNkMBQeNS8mFnEKygIvKZPICqN0FK/djSfk=;
	b=e3jlkNrWqw5ZeMN6j+teyV/K1bh76QuGKR6g4zpJ7vmXMYCifEw8LbBSQVivKC9kzVZkBJ
	ocsPML/n6Axje68QpHNG9j/wcfnXheIIJMnMPaxijn4a4W+2WhNutj/3jLqr1XQ5f3U9qT
	Pydr2cnNvuGwfnm7YQku2AaW3raPu2E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753735618; a=rsa-sha256;
	cv=none;
	b=bVvmNcNeHHXyNameFSKIIcFw9MrQLRN6IeXzFe6c/DKe13stK9l279GegPVE0B8tyvWEni
	8fiy8srPBYf3WqEmccnBdylUkt5mKEuO8cT7EnjGoUpVr2AgbPUuG2RopuqHIhNzCFNzsB
	t/QSzxuwsZUDgvuor2Fu7TZZMgYfMCo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ArcG8R8S;
	spf=pass (imf30.hostedemail.com: domain of dhowells@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhowells@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753735617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wg5ivtWALNkMBQeNS8mFnEKygIvKZPICqN0FK/djSfk=;
	b=ArcG8R8SjccGdlpu7/+7jd12BXPnPtYkiqwAMSQW3svS8NULl0+4qPI2G3lCLDUEUh3rhA
	5F0tQpFq0rlugcQq3O8r/xTGBTAQuVO+QUs49D1jN62jE5DeQF++PoAHIJHAQacYTGrw09
	i0RbcQsBIMsUf50ppkiibmd+tntmLks=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-62-VGIc3EEJN_O97Psf8GkLKA-1; Mon,
 28 Jul 2025 16:46:54 -0400
X-MC-Unique: VGIc3EEJN_O97Psf8GkLKA-1
X-Mimecast-MFC-AGG-ID: VGIc3EEJN_O97Psf8GkLKA_1753735613
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F421019560AF;
	Mon, 28 Jul 2025 20:46:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.11])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 017E91800359;
	Mon, 28 Jul 2025 20:46:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <jehx7y7mwer77d2rrx323qixc456ffod3qrcssemkebjotstbh@fpklsa72lzky>
References: <jehx7y7mwer77d2rrx323qixc456ffod3qrcssemkebjotstbh@fpklsa72lzky> <202507220801.50a7210-lkp@intel.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: dhowells@redhat.com, kernel test robot <oliver.sang@intel.com>,
    Vlastimil Babka <vbabka@suse.cz>, oe-lkp@lists.linux.dev,
    lkp@intel.com, Roman Gushchin <roman.gushchin@linux.dev>,
    Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm, slab] 5660ee54e7: BUG:KASAN:stack-out-of-bounds_in_copy_from_iter
MIME-Version: 1.0
Date: Mon, 28 Jul 2025 21:46:48 +0100
Message-ID: <659285.1753735608@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TwnxWleLPN8kUfnwzk9cs9Kv-0pzUVPYyps7GQQW-4g_1753735613
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-ID: <659284.1753735608.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 67BBC80009
X-Stat-Signature: wyd1aigd7xtoyo7cpc6desxkz4ugabsj
X-Rspam-User: 
X-HE-Tag: 1753735618-429391
X-HE-Meta: U2FsdGVkX1+X3CqUDvCcWh09wWLwYRQpV+spmDmZ0tnLnxnmUH8vecEX6ORL1dBK1JZHDYNYEiOluwJ6sQ93awyGrCUeq8X96jXtDDQRHf1olejKILqxAnHAtZReIw+cBN54gXb6sl/iCNXNR8rN4XeYPFjWR0qNGApjm1beAlEaAOox6JWBiykzHuF4J9UPCHuiWLlv1JktcYZkiZtM6LQBhbZHbx3j20US0BmvnY4gBwmTo4k2BG69MB36oNCuCL8oZCInrcpyn/ONi/zA7wD8B1OPMMhLMeKoeYcUi3BFrL6rox6q4x0wurtsHj3oHnglBtpKdRDDwlensP2c1HC6n/5rT0EMVSlumiEIszvkIWk1RcIWEomb85jUP69OU/0bhdxCfwPl9UYxIsMCpDORC30QXPt7MLEqGAO0tD7jzx3+INBY7f9849cDK5ke6ZXGQtfo5UpdavgdXrOD9vmmxLMXF56Ij8GgBaTb0fDxcRcQ3y7S4SLT/f++pQ4c8uiITW+0Bb6Kfa+/kwjapk41MJVpoxceaRpyZUot5Anwnx4bcyOBNxcXbjNvzZoY+mo8GjmNfpwSmpkXQII8xplaA66Dsg3wSnrEA+PZ+7EcliXHDvqdoHRhsQs5aw5jMSG++B9eXJWn/mwOR3W8kPlNSp/+ngwa06nTypMmt65pJL1jQwJEi6GxGnmPB1MMgDqK4MtCCVFmAjhYV7lvacjvXNlARoUe8o0B+pGHjocDvvzfLYgOO9YbRC59UlFwonMbeihBMMxef0IfOu/rOQ/Dwf30xE0x/h1bVUowgj9SxZVLDL8+plkqVcYBUtszj78HQaHNtieZVfioSLVEi4ZpD7xN+Ih1/eHZ+hUh00miHQY8+3eNdJ2zFnnMUIot193ZdaO3mnBMWtxZBooAPoSVtotMkvyal4xjbJqFvUVSV677WeirEWvI0hpgCBNogJFDySJM0biJ662XPuJ
 Nwl+6rCS
 QD+cnzdW2HFCZ6EKswkJXCQALJzlMm44oL/5YtS+1vqpstXoaAvEJjkZVlaeBgLpgY6v5AcHy2i3DrhW8XivVZ1euxV4NNMkbY2HJgJpmNOYW6WbhgT4x2RGfAk76Umz5w2Q2idrEOrbymYwD0PG+7sulhb/Bkp7AMnevpZEsgSkusWgpUHZ7nPB0ymvgvgKFqKxFi0uRPmADt0inUPfDeLP1S6OHSrpiQQXzpLL/7EpiZWsy5IWmOSJgNF+JjR06e6VAFn6QfCp0kwJjRQjawFKDRvfqMKbLkNau8ZmE1pFZh1vL/aIpE/6tPLNytriC/muVf5JElod2+EVXYZYdby93FAnkAjMhWAZBbZen8nOQ5z/X+dS69MBiHB96Jb29Km3G62OL+lg8MRY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pedro Falcato <pfalcato@suse.de> wrote:

> --- a/drivers/infiniband/sw/siw/siw_qp_tx.c
> +++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
> @@ -332,11 +332,11 @@ static int siw_tcp_sendpages(struct socket *s, stru=
ct page **page, int offset,
>                 if (!sendpage_ok(page[i]))
>                         msg.msg_flags &=3D ~MSG_SPLICE_PAGES;
>                 bvec_set_page(&bvec, page[i], bytes, offset);
> -               iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size)=
;
> +               iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, bytes=
);
>=20
>  try_page_again:
>                 lock_sock(sk);
> -               rv =3D tcp_sendmsg_locked(sk, &msg, size);
> +               rv =3D tcp_sendmsg_locked(sk, &msg, bytes);
>                 release_sock(sk);
>=20
>                 if (rv > 0) {

Looks good.

Reviewed-by: David Howells <dhowells@redhat.com>


