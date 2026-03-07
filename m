Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8700EFC9EF8
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 12:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9A86B0005; Sat,  7 Mar 2026 07:11:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497406B0089; Sat,  7 Mar 2026 07:11:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A31D6B008A; Sat,  7 Mar 2026 07:11:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2744A6B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 07:11:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B170B140A25
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 12:11:38 +0000 (UTC)
X-FDA: 84519152676.08.230AE7B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7E16F100007
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 12:11:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EGztRvi8;
	spf=pass (imf05.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772885496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXTMSOZayuB6LOw8FILsdffQXhPWAaVM+3qLhyjMXao=;
	b=LK17sZVHLh1zamSyfDv8FzdjnRp24XtDnFkaPJwmQLiQpDvbwsKxaKYoQwPifHXyP5mgeC
	uYnaphE6u/mXDVm3I2wklTSdl5hsLQL3BiAf+ZQAMimM/PztgwojaxIRRBXVZAsw76LkKg
	Dhotvo5Ndcsf9csctluKGmciorEfDGs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EGztRvi8;
	spf=pass (imf05.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772885496; a=rsa-sha256;
	cv=none;
	b=hhIFP8wWhXDyB2S2nQg0jFWfekYrvJh/3VNuSg+NAaNtTPm3h/XZG+1pm8dGZvFGDOOpC+
	3FUsodsiFTULuw7wcifOc6NaAsNjlH+ACMxclJD4t2u5/qn1QVYX7NnllQ61J5wnwkHLht
	xbT/0Rzy6hEsFtUzAx53PY8Vy8LmN6I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772885495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BXTMSOZayuB6LOw8FILsdffQXhPWAaVM+3qLhyjMXao=;
	b=EGztRvi8isuYXVKFjnJDIaMzmxPNcLdeRcSqegPg9+84HjKIcwY6NGYRhVncQwG7aGggS+
	1nZuryLtMszK4UD/tAO0+tHI2RD3pePE2N4UgMv2eeABkv4xvsN1TbrdD0R+9PqMHsFIf3
	xxLxNln26OJxoX2CGVYxbqrwpSybUR4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-y9DUh456NvKYiqjoeeDP7Q-1; Sat,
 07 Mar 2026 07:11:32 -0500
X-MC-Unique: y9DUh456NvKYiqjoeeDP7Q-1
X-Mimecast-MFC-AGG-ID: y9DUh456NvKYiqjoeeDP7Q_1772885491
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB5B219560B5;
	Sat,  7 Mar 2026 12:11:30 +0000 (UTC)
Received: from fedora (unknown [10.45.224.43])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 74C37180066F;
	Sat,  7 Mar 2026 12:11:28 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sat,  7 Mar 2026 13:11:30 +0100 (CET)
Date: Sat, 7 Mar 2026 13:11:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, brauner@kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] pid: cosmetic changes to alloc_pid()
Message-ID: <aawV7-yjMAy8TF7h@redhat.com>
References: <20260306190100.1900572-1-mjguzik@gmail.com>
 <aavuocRuM2Kmwj98@redhat.com>
 <CAGudoHHgTA4-50qLFvptDmg1r9FB8G0TxdX7OrWoRoHgtZW_HQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAGudoHHgTA4-50qLFvptDmg1r9FB8G0TxdX7OrWoRoHgtZW_HQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: MVOZ1B3saUNZ64InrNsJiKw9WRzDWR2uVt4TAJsb-3w_1772885491
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q7f94pu17knizmsjehakrn55h1sqja7h
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E16F100007
X-HE-Tag: 1772885496-832121
X-HE-Meta: U2FsdGVkX18+J+/a1uRxOd9zpHZNOWjFi7+pIfOmDMaaeWaL/owWEEwnV1IWIFADAk5ZxfZNSWHSYAweve4YZHqCa44hECUvVmlAlXBiEDcgPzkvCtod0vKk6S8w7tT199MB2FbLr74dYdnOji+/fFHYizrzPN3uGa5dRHbhAxklHe5CB9D6xuquyIBlZx/qsUOjpCuJxIqlMdQAYRQwc7UK2L/SjZ1+ycRQE4nZUvxm0mv1AgGrHO7IIlD0sOMGqV6Ogp4i8vbCOZqAA2cp8bWeHjvA0CD7s16Bth16biXhMFm5zD+BEoxG5bKETTTqOvb7X3Po+V86S2O27oBYVB/eYZbiUv5VqMOSmBfkQcw2LkMvZUORYO9ywU5RgxZW0rPZdnpoE+Q8yM3883xqvDEjhhl4V2BM5gPPgY1ucTwoPALdLzKGqb+sbmBjtAIlXXrCQuh96NsGNbB3BosY1dvtGTJ/mYmxpiM+cxhVK8V4XzPmrdON7I1jxKBBekoJrASuZimAipGsgpjWYgL7FvID97BsRdRiTxA0vFBYiDor/pqj96i7mixeYTs7GxENTam/+QhCyoOq6R2Vbe2iEFMp4dJTg7hbhFSweun5JESwUsfX1XnvIRUKfF+ktkscGa9AJnOgjou4GB00PWjI1e1E/fBVb4oL8rWcrhuTxYgy8K2THA967UyYLIgouZ22zqboBDNveNHavZVe7VMd0NFS6Nw0BSnGxJctvvUgJNuJcDwi3KPHVFDqnF2B1V886U5awiDX474szYZxe2qFpZTCYmIrKTmnzyMjSXK7bDC/LBNW+qamf+2OwaIfg0CHKSyVDRUtoQ2ZFLUryChsKOowYpquhFRJbEvsXKLpa3XbYwoJho1uixgYSlHgWkMeXnMjtz9FIK16i2DFdNb0Lj8WQa9ci27Lp6F+hD7Tm7C2if0xquSCd/1BDYwXkfI8qLVaCziswvFt2KFybgQ
 vj8M8rBP
 IOeyJ9Z495IArIf0Sg0mgr/d2MtLod523HxbWGzoARQCeZdcL1U16gebChadsVBU5DUtsazwznnPVo1zUi3Tmc60YModIhlzV/AUANWFd0ukGpGXK3lgIxaxKMUsE1i6ghYADcEjasM+tbvP+4GFL/ppoQcoqTLRS5JDYMghdok+wLR/uffdG+QyQ+IVb56ziBJgEykaPZ4O/lymB/SxN3b3QE1WQFOJEOXxnPcqlEppJ+w4YqgeAUhuclV8S/laIyw1ZLUAAmwWaRITHQ/WJvhfKFL6TrLDInMjNiW+8XB9ZdFdqWk8al3dXWb8CKls+wr6mE+yZD1f1DmQ1ESsgdnKUrcnOEulhnv4Bxcsy8nj5VNH+79B4hgbBQUGfx1fAyyTSemzL0Q0hA3E2tjwXzzJ7+59Lj0KH5Ctnp/Oau5VF/U758Hw1QFox3HeDFg/+24Az9ZcOCH6N4BUBu7Tb+iepPZhLm4JSn4Zh46iwxj78to6tlyaNNR7KNB50y+nLtsAZBlhJ2gpUFDkv/5mLmOnavG3xnLhg4UDGMGrB1qOpCcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/07, Mateusz Guzik wrote:
>
> On Sat, Mar 7, 2026 at 10:23 AM Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > On 03/06, Mateusz Guzik wrote:
> > >
> > > Commit 6d864a1b182532e7 ("pid: only take pidmap_lock once on alloc")
> > > landed v2 of the patch instead of v3. This patch remedies the problem.
> > >
> > > No functional changes.
> > >
> > > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> >
> > The patch looks obviously good, but it conflicts with Pavel's
> >
> >         [PATCH v4 0/4] pid_namespace: make init creation more flexible
> >         https://lore.kernel.org/all/20260225133229.550302-1-ptikhomirov@virtuozzo.com/#t
> >
> > In particular, this change:
> >
> >  -     for (tmp = ns, i = ns->level; i >= 0; i--) {
> >  +     for (tmp = ns, i = ns->level; i >= 0;) {
> >
> > With 2/4 from Pavel we need to decrement "i" before the ->child_reaper
> > check.
> >
>
> That patch will be fine as it modifies the other loop which already
> had i-- towards the end.
>
> So I don't think there is any need to rebase.

Indeed, I misread your patch, sorry for noise.

Oleg.


