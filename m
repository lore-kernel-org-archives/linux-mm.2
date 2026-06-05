Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC75CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 09:33:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45926B0005; Fri,  5 Jun 2026 05:33:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF5FB6B0088; Fri,  5 Jun 2026 05:33:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDAB6B008A; Fri,  5 Jun 2026 05:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBC276B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 05:33:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BD28163B14
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:33:02 +0000 (UTC)
X-FDA: 84845345004.25.DBDECBA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id EC6D48000B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 09:32:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="GoLay/zQ";
	spf=pass (imf02.hostedemail.com: domain of fweimer@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780651980;
	b=Yc0AFmGI7PgCgrmAHtg4Oi4vaydYlIz11hvkXy0L7ysBOOEeXhkYNtY5y3fz5k541hxqNl
	PYkUxzFLgjMfv3hWfVGsktndy2uZ6NPO1f/5ezx4ICHeRHIzZfzujqFMxlWA22LrIROGBf
	QpUm8X70h6dOQM11jajOv9npnXnu2uo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="GoLay/zQ";
	spf=pass (imf02.hostedemail.com: domain of fweimer@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=fweimer@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780651980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oH+D7ZeSOaE9PHP6jmKMDbjckrUXBE5O1ghWpaUmya0=;
	b=pO7dx+Je/IQLoqev7yC3EZ6zV1KZoNmKQDwtj95oKX+fOap6ULwLC0icXDBV6OHEC2W+z8
	D36+yxzrpCpkdsimAjG6BFUpS7tW3366STj93qs9UXJm9lqmC+GJXte7lq2oRpSRx1l8bd
	d31RfzOeXUxvDOq/M/+6NV/y00Huiis=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780651979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oH+D7ZeSOaE9PHP6jmKMDbjckrUXBE5O1ghWpaUmya0=;
	b=GoLay/zQPkYFG1fa2d4g8UdNR6sD9litgvInngk5yRTYdY3wp4uc3eZidXPg0/2zluRUAF
	r8vMgI+VxHd57zdKtGEgeFSagdJRoBXJ7IX3TxDP6vi+HK3u2tomEwsp6YsvBeqO7mou9n
	ArDo2pcqGmDlfVivVKJF5J3zWAqJ5Ko=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-537-rjGcsIZmNDGiRIUyLqMLGA-1; Fri,
 05 Jun 2026 05:32:57 -0400
X-MC-Unique: rjGcsIZmNDGiRIUyLqMLGA-1
X-Mimecast-MFC-AGG-ID: rjGcsIZmNDGiRIUyLqMLGA_1780651974
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0FDE91956080;
	Fri,  5 Jun 2026 09:32:53 +0000 (UTC)
Received: from oldenburg3.str.redhat.com (unknown [10.44.50.55])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CF111955BC0;
	Fri,  5 Jun 2026 09:32:45 +0000 (UTC)
From: Florian Weimer <fweimer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Laight <david.laight.linux@gmail.com>,  Askar Safin
 <safinaskar@gmail.com>,  metze@samba.org,  akpm@linux-foundation.org,
  axboe@kernel.dk,  brauner@kernel.org,  david@kernel.org,
  dhowells@redhat.com,  hch@infradead.org,  jack@suse.cz,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  miklos@szeredi.hu,
  netdev@vger.kernel.org,  patches@lists.linux.dev,  pfalcato@suse.de,
  viro@zeniv.linux.org.uk,  willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
In-Reply-To: <CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 4 Jun 2026 14:42:51 -0700")
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
	<20260604100609.6b37f500@pumpkin>
	<CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
	<20260604183829.63c35fd9@pumpkin>
	<CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
	<20260604223216.73468830@pumpkin>
	<CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
Date: Fri, 05 Jun 2026 11:32:43 +0200
Message-ID: <87se71jps4.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: r1ZBWQ3OasOw_DYkfHa0GgcNsdWH0KhyYML75sY7Bpg_1780651974
X-Mimecast-Originator: redhat.com
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC6D48000B
X-Rspam-User: 
X-Stat-Signature: qfr5de3xoxq48mocs441o8ycjji1jefa
X-HE-Tag: 1780651979-508811
X-HE-Meta: U2FsdGVkX1+uRpr9hiVtpQNTkUOU4FfcAJY1Psb423ndOmDhr72x+/gZrR+8nY5/+Nrj7HW85FksS1pK0bGiqhtgBdLNXEL1ovH5MjTPLtptCH7ty1VALdAM0P6K3nrRmIUw1KB1qGd8naqZvJpFjdFXj9jgWiT5BDJjoKuvrDDKkFL/8TCyKmBSA1DGuzD/gRWqemD1nrANZUlxFo3h8G6+2BMjTkEjqjngOK6DSNXq3jp5q0dLlQ36g44qdVQkUJbUEsXgF+tyZERCWhCfy/QG0bvNKDXd35q5te95VYoKjJv/NjXaO4j1kj/5zIVj15wcJygz7shMEmwemLGkpCG9ttJ0iM8fFaOZu97tO7Ht8Vr7lboljkX8AL1DIG/UfM7IKTs0fOXCZoEin5alp0/fEXNuB1tJ1HH0Wjke1H7Q8Jh4KNdnQ1f1soOM8T3XbFK4x0WQufyv1PGC1++vipOcaqNoX49jiP7xWE9wLwn/gzz4laX2snErnvcebw5LlfwWQwyFMncm7E8/W/JlLN8CeMzx/0uiCpA47aqyzO1dTPirVOjMybm5cxTcQG1yWiUAmKv1EUEy9cLZLkizsE+Avrs8KDtKZ/RLgs2/52dKgc2IfAJ/zz7Z0UV7OmYvJjALkUgbVmllOmkGR/rImaPHLcVPIUaP6qomBF9evcwqbHkg1E04Lxs+gSaWSt5CRtgsSiOjw8KWIBu3LvfIrOfGtpmTntbCgUftLhrE4YldDwI2fcxTp8anyRxgcPllun2+pQLULsgxHNyWMnzWbj/1LA/1LKyW4UvrQ8eDpAxeEsUvYSiNMsD2i4sd+/MfQRwm9Aoolfhk9PUPmNk2fW9o5vMWsNY9V/wMFe2Xg1+rEIGV1bA0jL1lKZ/e/lEjEYI0W7BVFwsiNtPQDPqYTyOo4hXBoGdQ5EJJ308GTihgA2tsgK+A7/ARinrYdrslTniuHVaTrWyTqopJJMt
 fr0pST9U
 A6z//oXeI2kqaZmL0suvu0sxL6aA74OxfGxHCkqe1FsYu6JcaQpZMdznHvwTFruv3wheBd/R04XLVg3+JNB4K1Kp3bv7JOMkrtMOTNX6kUA57CLpljXyQ7q4MSjtOoGhU1OGl19W0dsBBIBYuk4u+EsiaYcMKem8WOz594uL/EefFkWQa91VuVWgZkbreHmhsrrL4KCD/hQx85yvRy4OKV8l23yodyN48nkJYueJGgM1Q5+g9FbC5rFkyN9pjaP4Zr2zhm1g0TMIlR1vGazTuaHEMXNWZ89CKu57YSNwBBJcK2aeUL0jGdgEPNhqeQ7Xvi2CfDgb/mOjKYLc+t3owKipChxLOmDm8ToG4/qU+1f8pnuwfEzevf1f68mo6Uz1qr0Nn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Linus Torvalds:

> On Thu, 4 Jun 2026 at 14:32, David Laight <david.laight.linux@gmail.com> wrote:
>>
>> I think riscv might sign extend 32bit values in 64bit registers.
>> x86 and arm both zero extend.
>
> That's different.
>
> x86 really doesn't *care*. If the caller zero-extends or leaves high
> bits set randomly, according to the x86 ABI that's perfectly fine: the
> callee will only care about the low 32 bits. So the high bits are
> simply not relevant for the ABI.

Please note that Clang does not implement the x86-64 ABI and requires
zero extension.  We see increasing problems from that, now that we have
more C code calling Rust code.  (The other direction is generally fine.)
Unfortunately, it's difficult to fix in LLVM.

In the original x86-64 psABI, this was left unspecified by omission
except for the special case of _Bool.  However, Clang/LLVM gets the
_Bool case wrong as well, so it's not just a matter of an unclear
specification.

This isn't really specific to x86-64.  _Bool is simply not part of the
ABI that is stable across compilers, a bit like bitfields in structs
passed by value.

Thanks,
Florian


