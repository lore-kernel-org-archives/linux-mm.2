Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E592D0D172
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982A76B0088; Wed,  7 Jan 2026 15:29:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9150F6B0092; Wed,  7 Jan 2026 15:29:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82F8A6B0093; Wed,  7 Jan 2026 15:29:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 710506B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:29:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EED0590B9
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:29:37 +0000 (UTC)
X-FDA: 84306308394.23.BB76CC6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 23B40140012
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:29:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TiAGgbrW;
	spf=pass (imf26.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767817775; a=rsa-sha256;
	cv=none;
	b=bgqYASTeRwVE3iHbWfU3xVDFgyvTXQdmhSEt0tlq3Xxfxvy8hCFT1U3GTY65txAgZPeA6/
	Z6IS50QJj1GXLU34M4kfHXqk3dTn+ME3mVYwzhUe/usM9GmHtu/k5R7LypZ3FVPc+xyS2J
	2+pHyZwSUDxd+Lwkuhyzqfd82gLlI7A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TiAGgbrW;
	spf=pass (imf26.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767817775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EYBm4fsSKMIFV9VkRmhgrkSCmBstr4iH+VMnw9NmY+k=;
	b=Ev6AI6ws5ldnY2Msp+KAedIrMdCTBL2VdIL5Y+OF1R3JOaMdMCWpgaXMwm+8KM/Pykj1tN
	W72Nvr6EBpQkwieYUKVy7k3xrDt75QObUptAWmdjaVMk7O7Cwu3qm9nfayrQ/dl3aZlnHu
	xqnTgydCQ+eZrtM+9HCUm0AqSIHfUeE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767817774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EYBm4fsSKMIFV9VkRmhgrkSCmBstr4iH+VMnw9NmY+k=;
	b=TiAGgbrW5zzfJOA5RTua2TWx5KW8ptu8ODpDEOYu6vmnVZoBi7UQHpKPK0D5waNNqGK7O4
	qVYwW3kkP9LwdraMk8pnSbi+r2LWu9wNPS+s8g9RIBVlEWKQIgv8TfC9Im4YYirZa6e2/j
	I8qpWF0MJitWMcuOr2TUrmZcHnqqAGI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-qSSJf_TFNOKML6QBkLcJVQ-1; Wed,
 07 Jan 2026 15:29:32 -0500
X-MC-Unique: qSSJf_TFNOKML6QBkLcJVQ-1
X-Mimecast-MFC-AGG-ID: qSSJf_TFNOKML6QBkLcJVQ_1767817770
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9849F1955DA7;
	Wed,  7 Jan 2026 20:29:29 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70BC2180066A;
	Wed,  7 Jan 2026 20:29:26 +0000 (UTC)
Date: Wed, 7 Jan 2026 21:29:23 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
cc: Alex Deucher <alexander.deucher@amd.com>, 
    =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>, amd-gfx@lists.freedesktop.org, 
    linux-mm@kvack.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
    Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v3 3/3] amdgpu: don't report an error if the process was
 killed
In-Reply-To: <7ffacc33-9233-4fa1-a7d8-28fb3fbb8061@lucifer.local>
Message-ID: <06317034-2677-d2ca-b468-841a2076e84d@redhat.com>
References: <aca0147f-61be-30a3-eff5-cb981222aacc@redhat.com> <7ffacc33-9233-4fa1-a7d8-28fb3fbb8061@lucifer.local>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6d5QqSqcjVK57NIgd5lhumuzDZ-vOd_6L90WmoNQCos_1767817770
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 23B40140012
X-Rspam-User: 
X-Stat-Signature: 3farrktrkwrs6u66qnmcxhwyihc7opme
X-Rspamd-Server: rspam07
X-HE-Tag: 1767817774-509631
X-HE-Meta: U2FsdGVkX1/4JaHxjzP7acWmgK+2JdiVKreS2bHPRB1qi6lSsoaJK1ccS+19GX2zflaMbUE4l79wAF4k2qinQKFrEtRIxtxwhHT1HG8CmT5kSv2r+YRoABxsjv32Nn0px1WOWpmUfT+oNF01QsKHgverFEfLncMdfY/1s+grrH/h4YpJesXR8jj9IKgSFvcNoGcuFJid4YO0ENuLl+ZaezDuytq7YNbu3vObjTdtolvpRPiqMbRD0OKxO9WSaacwJiDx1RQyCISTV8dIdL3liRak485rBr9cUqeMXXKs82COi0aDqW2wikIq7ojFDy/cKLBpYgHo0I5K1w0OXzc1boAW2ZPgILQmP4cBSuX/yL6C1xoPedWGy+/lMja104HcGFtPyFj6q7k2Z6WAvXPZZkXYbyg0B4s0VMQqPV5V9bggh1eIYnP3MkbePpZ3THXhN7VhPGtNXLgam+np8SnakDvoYecYi8bGNHdv5PcGYc/IunNwDZKQiI8QN5zwvjmpXz4ik0QV9EoI3di5AOefZ2Glvn+k0+ESJOTvYnZuKdycia3PnQyVtxJrmpY4S9n0/c+EpDiHKJAY8fF5dci1Eyfn4Y4m6m76+En37zjHSau9i2/XQ1lYMnpBOJZq6cxxdFOJQpS5ydDkXWpHYsa3nBBBLs3frQVoURVvTTUUYneMgdk1+0IZ5USPWr2nVI2DL/MT6WRflYZi5a4LcAQ/kF4+/0wqcYKWdIh6kz7VZcMSF9zMxXchzASzBkAggC7BkYieBE8ab+AX/ZMh/JY26iCGArv5e7lRJ+LoI3701eUF0z34zdSbYtgrZ6WyiURyVFNnMkTWXNEkD1bBBvoa9L38DhyBC+0ZRtP2uaa+v+NL6YXswQ9k40d7OHEK2hzUNr7+QfLppnIV4ztgScbgj4b27XGA46reWRdPQXr9u+St14GfRW1rA08jvWeI+qqH5hgLBdbf9PtXOdzJckv
 p/YuhAvX
 DxPWo+eibd2aHF25eSWwkyG5h7ovO0jBepEkhSrFtg9NBBsD05FSeuBouRn1PwD0TKpAdHa2sIgEbgRkuSunUGH5fIuM8NLaR3woFmq83JGknodb2P67GTY8CeGRCOpkOALRIMSN2/Rcz9G0ZGPFBB2Sfx9OWPaZTqQSeEb+6ZHihuJZZQWnp11JyjV9ek455nSCgtYW+EDTa8OTP8N6GaN6YWDJ+6sr7Yb17+Rs8YeakEdiN+Yjh9pOENSG4MJFPCeiMLUxWqFsRQXJiJV70Qqga5hiV2ILoBpyn++JpwwT/iXFwH6C2t2CprTK/3DcpP5i9cPS7ZU2/VlHkhiX7fuJnO0G1uv2pdVJLDDm1eDnzFWvhZcIbZPfM7TfZz9NZcGDjnTUL6VCv2EY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Mon, 5 Jan 2026, Lorenzo Stoakes wrote:

> Gentle nudge to ask you to please thread these series emails properly in
> future.
> 
> Use something like:
> 
> git format-patch --cover-letter --thread ...
> 
> Or b4 or etc.
> 
> This is a nightmare to try to review without it.
> 
> Thanks!

I don't use git for patch development. I use quilt. I find git quite 
awkward when I need to move between multiple patches and update them 
independently.

I'll try to send the next version of this patchset using the 'quilt mail' 
command.

Mikulas


