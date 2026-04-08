Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C54C510F9953
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 15:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CB926B0089; Wed,  8 Apr 2026 11:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17C696B008A; Wed,  8 Apr 2026 11:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA7D6B008C; Wed,  8 Apr 2026 11:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F358E6B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:46:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C4221401E0
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:46:03 +0000 (UTC)
X-FDA: 84635814606.08.A105E5B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3E1D71C0012
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:46:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zu7SlHoM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775663161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ABVcnSBYw67/dNbfG+cq2X/5dXQSJpLjV8UMfC8U4II=;
	b=bv9V0+eW8+mVrDr9Rbzk+sDAC/TWIgtJKuhno4eDnWzd5kofgnD/E0jB/Po/s7xEttXY/q
	/e2c3FHzxxvzDHnkLS14y63bIvs1g2cL+wshi1Fq/XecnaCsAgsod/tQHncCQAqXVAIEMx
	LiXJ+/S0O34nqlg76JSBgDFfpEuldOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775663161; a=rsa-sha256;
	cv=none;
	b=nxnYPmCM537lpTOIiAwhWmKgdqxVmLZMhEMHgDJntaXB0k/cuaj8rKqiiCCF9jN6i1wCzZ
	4m9+aOEASAU1d6XTqpwrna/0Ln8h/+MOjcyV1TWOH7FTGylR863lvyCX2fQNdfpo6lcrhq
	yp0DRbi62gnlMQm+XMTs4Ry9usCe2Cs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Zu7SlHoM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775663160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ABVcnSBYw67/dNbfG+cq2X/5dXQSJpLjV8UMfC8U4II=;
	b=Zu7SlHoMpxRHks9m+4YbjMaCIVNXoRd+htwEq0Dt/8w6HrlT3gkoRGil1Ar+nsyJCZ6pCE
	AOM/550GG6v+vFjm6361mCsA0Nx7AVOAJKXh3rqGVGm+BqtOj2/R3lKPotPXkNeyWbkIyz
	twcfprS5uokAFR+0hlUdoNXFcykF/fM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-353-QrTHQVknNKmkhMeU6X5Y2w-1; Wed,
 08 Apr 2026 11:45:58 -0400
X-MC-Unique: QrTHQVknNKmkhMeU6X5Y2w-1
X-Mimecast-MFC-AGG-ID: QrTHQVknNKmkhMeU6X5Y2w_1775663156
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 133171956052;
	Wed,  8 Apr 2026 15:45:56 +0000 (UTC)
Received: from localhost (unknown [10.72.112.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C55419560A6;
	Wed,  8 Apr 2026 15:45:53 +0000 (UTC)
Date: Wed, 8 Apr 2026 23:45:49 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, baohua@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <adZ4LehwC9KisuXf@MiWiFi-R3L-srv>
References: <20260328075812.11060-1-21cnbao@gmail.com>
 <20260328075812.11060-3-21cnbao@gmail.com>
 <CACePvbXVaK0McYSr8O7h2XMpEh1f1JGzLVJQd69V0QnFXr8Evw@mail.gmail.com>
 <adXxdLSHp2E2k6_5@MiWiFi-R3L-srv>
 <CACePvbVwoqdOmMWkJUm=mqYQi=MgK+Q3NJu1Pxmmy9v61f4qEA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACePvbVwoqdOmMWkJUm=mqYQi=MgK+Q3NJu1Pxmmy9v61f4qEA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: bxvOFPR_qwJySzRg_tpyU2Q6L5t9IE8iJ0f9FdDTs14_1775663156
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3E1D71C0012
X-Stat-Signature: b6f1463ytct3o8wumh7aoispdsk4t1sc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775663161-755390
X-HE-Meta: U2FsdGVkX1/vmN27AF3BqhW9fHcRNuRIQT0yg2r2SqXgHPmz3ry1wEjGkVW3MZyzQ6RAwJT0sGeUU01o0ThWqQCOgruWWB7X7Lqyp1HZ3RRZsGLzYJoSJEdEK50i1MOgkZ5huB9HJe1mOyvAM4r7G+qlb1dGwHx2ryFcr0wnEpklbE/UJohNH9wYfIpJ8uaIYJmhE+hAhN+iLGnIpLwr54DMeyxAlRVyQcVks4oF3JFGBlRnLBAXxF+Pu03MrRLQZEeMJF3qx7bsV2ig5jwODB+ZqbnZsyKQllG6SvLFclsgzJmJga0aNP30odI/91nTZyYJ0ePblfPN/pDJVBxhJERuiiLNg76ceylYuIgT1lsDkeTI4oMwa2VPVE+C6RKzs2KDAvidn4qkjrcZyUDvthyDGITgh66Z0DEgDAo7WSljcMmvEkaxlLcwduO7jtuQqyQaCr1/VxOLx/J/visdAiq+n4OCY5znVfLy2AB6ySF/x4sKgdZ1TuxjSQBzN+Mqrr/CBXrGTQvBQfaE7rxV0+wBlPyqwjZpMSnKIWHd5H4YfnPGPReNsUsaUyD8GkR3U93lmzocuFTJSEqPsOiYb4fiuButRV0wUfiBy77DIySpLTzyvxg+ImlRAlYN5cHet8eQ2rS53zbth5Cz8/L+pNkx34jcU86h261T24MzFYI0sqjtn/wDr1dA5lNQ1uBnBgr7K59les9QzuNrD8DgzIqCFfXt1PdDMFtdGa0s6h0cdsRZRwruWpwAL68OZEjntpheYwsX9epA9Txcs6bAo9OIfjl3J5eIVHqe365LerI3pcn8ZTCLBp3aVywbZrPp9RUxMCJewgn74pPC7i2Bl6p3FTy5Gd8Km7hrshbhAsX9OGtdFKmjqbhmUpfLgWWSYewJfHHxKB9nRfE9OlyRMXaNjUUMqfjIitUtvHENhdgbYzzCHivn9CbbTIcCugLyL4DNM7fsVzkNUxqDKKP
 +CxMF/UB
 O33HdtOm9rQZrcD+c6vkzR2ULNfunhiXPv3as4n8NSa5BbFJpQs15YnqxghV6qRNVPKrihcL2XuU6PNA5AAwfHFiClh820mQChjU4LmkE264WgagMSlHhxJsf14/T9Hooc5H4+hD3jerv8cew55LhJZUrJeqP6dOZOWSKBv0oWxCp+5KN9eo6ZcpOxgAkR/cMjItWLLP0/E3S7EckL35OLplm1gd7UII+Aaa0EdEHYCWpCDTbfUcBFq2kkpQYjRj1WiTKzPzfLTsyOqwZWJXgeM3E3lifIczpG1wG3OgYCP0rTFGA5uBXHpStqWZZQHD41LQZ5HlWeXttUPph00CLh/hMbuPqTIUUn4sYlkMyr2Pf4xjV4WyqHVGKzZx5L+DFzCPzjQ6qtW6sMRPy0/HJPubL2ucRi5ClOXSHWuMKDV+JjpDCgicoKKuiS5ssTlRQXL1eDgYA+5B6Cs4xZsC/GuTqZC+GQC04ot49DhrOTheyZhuFSoYajjgD8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/08/26 at 02:26am, Chris Li wrote:
> On Tue, Apr 7, 2026 at 11:11 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 03/30/26 at 08:30pm, Chris Li wrote:
> > ......
> > > > @@ -608,6 +593,39 @@ static void swap_read_folio_bdev_async(struct folio *folio,
> > > >         submit_bio(bio);
> > > >  }
> > > >
> > > > +static const struct swap_ops bdev_fs_swap_ops = {
> > > > +       .read_folio = swap_read_folio_fs,
> > > > +       .write_folio = swap_writepage_fs,
> > > > +};
> > > > +
> > > > +static const struct swap_ops bdev_sync_swap_ops = {
> > > > +       .read_folio = swap_read_folio_bdev_sync,
> > > > +       .write_folio = swap_writepage_bdev_sync,
> > > > +};
> > > > +
> > > > +static const struct swap_ops bdev_async_swap_ops = {
> > > > +       .read_folio = swap_read_folio_bdev_async,
> > > > +       .write_folio = swap_writepage_bdev_async,
> > > > +};
> > > > +
> > > > +void setup_swap_ops(struct swap_info_struct *sis)
> > >
> > > setup_swap_ops()` needs to return an indication of an error.
> > > The error is that sis->ops is NULL or op->read_folio == NULL or
> > > op->write_folio == NULL.
> > > If there is an error, we should fail the swapon.
> >
> > Thanks for your comments.
> >
> > In the current patches, there's no chance any of these happens:
> >   sis->ops is NULL or
> >   op->read_folio == NULL or
> >   op->write_folio == NULL
> 
> I am aware of that. Adding the check in setup_swap_ops() responds to
> the WARN_ONCE check on op->write_folio() feedback.
> In fact, we should never have a case where op->read_folio or
> op->write_folio is NULL. However, I can see that other future swap ops
> can be NULL. e.g. Notify swap entry free. It is hard to enforce that
> some fields can be NULL and others can't. So having code safeguard it
> is fine.
> 
> > Because it's a if-else logic in setup_swap_ops(), adding an error
> > checking looks a little weird. I think it's worth adding the error
> > checking in setup_swap_ops() later when we have new swap_ops added
> > and there's potential any of above three cases could happen.
> 
> Adding the check in setup_swap_ops() is to remove the useless warning
> check on the caller side of op->read_folio(). If you think the check
> is not needed setup_swap_ops(), then it is not needed in
> op->read_folio() either.
> The WARN_ONCE() then kernel panic on reading op->read_folio does not
> make sense. The check was added due to one of the feedback that what
> if this call back is NULL.
> 
> I prefer to keep the `setup_swap_ops()` function responsible for the
> NULL check, due to the discussion history surrounding it.
> I'm also fine with adding the NULL check later. However, the NULL
> check needs to be consistent across the patch series. The other NULL
> check inside WARN_ONCE before the caller site op->read_folio()  and
> op->write_folio() needs to be removed.
> 
> Does that make sense?

Both is fine to me. I will change to do the checking in
setup_swap_ops(). By the way, I tend to rename setup_swap_ops() as
init_swap_ops(), is it OK to you?

Thanks
Baoquan


