Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3E01CA5FCE
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 19:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DFC6B0088; Sun,  4 Oct 2026 15:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BDD96B008C; Sun,  4 Oct 2026 15:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD326B0092; Sun,  4 Oct 2026 15:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC7266B0088
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 15:56:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B065120C3E
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 19:56:05 +0000 (UTC)
X-FDA: 85285999890.18.1883168
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 59FD4180002
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 19:56:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="bsc/Ldmj";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791143763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpkaiXvdHhIcWibB9SYBycVYBcgkusfdPB8A5buHEEk=;
	b=Ne/xm1bHssAsBTsTJsB/8RJnN0LX8FSchWxYbm85fENH90DhxFG8cyAFrXh0YJmYUHnHAD
	PpWnFlQjHQuTOmMxsg5nfxSJmMkM7JZmplMIwp9LU/d71sW4UPwJnSkG/AKe8DBWVXxaqS
	NlUk+srcIj6XaSRapwrZzvdeQJPXCZ8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="bsc/Ldmj";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791143763;
	b=dmBKDJ1Nz1xsUAkddfiHeuNHPoxcC+PrzVKhCh/s75+J6lKPTAuv7p/cclSfIlHSQSqBLN
	pSK0WquK1XFFSWxuAlbCRQKihcn3zs125XNuTVINEgAR23chCCYVKsslWNPc4BypTwk+l/
	QfWaAe6cJJUZM6SCIbQggiRQcJrIYg0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 816CA429D8;
	Sun,  4 Oct 2026 19:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFED1F000FF;
	Sun,  4 Oct 2026 19:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791143762;
	bh=hpkaiXvdHhIcWibB9SYBycVYBcgkusfdPB8A5buHEEk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=bsc/LdmjzyZjLRf2S+ltcr9UoQpASsvsad4cpVvRzBRa/bXU+oDQcpooSXbyMetul
	 RsbKSU5SV6H6QLjDtc1lcov9ztMd2PZHkxZw2X5vcu0BJ8E2GyOkHq4fpIHjB4rsjW
	 DliqWVNiUt6/tBgXYYAxRdEg4b6mHcfWTfymaXTA=
Date: Sun, 4 Oct 2026 12:56:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nguyen Duy Nhat Anh <neganhat@gmail.com>
Cc: david@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/gup: fix NULL pointer dereference in
 fixup_user_fault()
Message-Id: <20261004125601.c06953a6f0660df9859b0c2a@linux-foundation.org>
In-Reply-To: <20261003194846.205918-1-neganhat@gmail.com>
References: <20261003194846.205918-1-neganhat@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: e6caks4m4ani1m1hg1du9ij78gjb1od9
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 59FD4180002
X-HE-Tag: 1791143763-351115
X-HE-Meta: U2FsdGVkX18ADB9IXxeMP2APsMCiNqdootF/OGLe5IicDx9LJwQaIeCbRbdW0wwSTNc768PRVegdeHtilzrOZZzV+eGAmqGffQKAxmGkIi9aQ6FaJx3k4EQCYkjCmog1/eAdXdgFS54ML9sSXtUhZsktryc4mhs5Rj8GPvNhwcWb6041wZr+Igptw611sEK22RPnMMH24idEYs7yED9mt9mKKL6OMf9PMHVutv/DverrIk+ScUGt05lmI6pwh9LUyW4jdtfvQX5VNPXwZUDjr1inKNb/k7pdtH2dpShEclQdV2lKQjUkQIIj+3OBlDdr3IRU4wNeTAGZ76kK3LXxiwonZQ8/PnDDDkkskzS8m/OfGbEcRBUcCzgdRh73nkTFXsQ5QuY6s/lbDoGQUdbncZrxJtO71k3E1SjR0Y+01gj3+Ky2Gn8pdtZGleQoDhdPqagA87GqQMtZzUNtYXhFQ+skA82bwEOqnCfGwUE5pQJYNRUFbyCRhu+DIp+3GhQYe+Jn4ewZpNFEmHtAu6XSW+fUTVyti6AhiPGsvPnSZ+AP0Ka+PmYzX4tX90Ck4dPkYj5jqxMelhhoT+dcWggHGwBUX+uR7AJE6G+Whsas7O5cF+h106Lw/hYLBaAfCGfgem/nXr4P7og2J4LudjHNz9R21PAR99n0HJubCOxkNg97Fo2bJeaOiLP0/ynNTAkAVF3GZ4Tujhxqlc7O46wXggtTfGIMupdKNXrXFOsnI9DXYtNTg9B0rNf3xb2G7Kf2ePVHSqZXoMbt3+FbWnoLvl/qj2m8SaPdmXm2V0+HsGXMOk+9px8LZJRAnkEZeiCqyvdpUrzRAcSahmMvh3Uil/+8GXzkcCWFakmy6PDhO/uitAkxHn+OXwpaYCWavIbOsb0D1eZoIC201I0VN7wnTEND5KJy5NiNxsA1Oc845FrxBRdwAmxW2VRvZf8a8aRsnBRMQ4QOLsM7s/h7Zxd
 huxcu3iJ
 x9DpVqeNr5dzze7u5KSyzC3Bir7xH3zPjYE6yvRYApIeJioAnccylq+gzqEryIkbSNzgsjGuH0F9IcTA9mSP5ud9YQUUica+oHlZXqZruoxnUs+Pvl5rBXqF4aMCpM7x29wdbWBfvZ1kDDOIjoVHV2s/ePMO1XDhuK0+xxIL/zoPd7lAFLbMkbUyPzxzxuZAdO+yDZ14egFojWyqbZPlXlKsY8RueiLWWUTl8Sp+pGtMirrcK03dZVaSdWaVxV9QslI9c2EZlrgyWnd9AMbd/B6qCE4fjafAcoLaq0s/Dm2UPPLScP3DgJ27mmST61ius7Eza
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  4 Oct 2026 02:48:46 +0700 Nguyen Duy Nhat Anh <neganhat@gmail.com> wrote:

> In fixup_user_fault(), the 'unlocked' parameter is checked for NULL
> early on, allowing callers to pass NULL if they do not track whether the
> mmap lock was dropped.
> 
> However, if handle_mm_fault() returns VM_FAULT_COMPLETED, line 1597
> dereferences 'unlocked' directly (*unlocked = true) without checking
> if it is NULL. Callers like s390's pci_mmio.c pass NULL for 'unlocked',
> leading to a kernel NULL pointer dereference when VM_FAULT_COMPLETED
> occurs.
> 
> Fix this by checking if 'unlocked' is non-NULL before assigning to it.

This code is too subtle so you aren't the first to attempt to "fix" it.

The key hint is in the kerneldoc:

 * @unlocked:	did we unlock the mmap_lock while retrying, maybe NULL if caller
 *		does not allow retry. If NULL, the caller must guarantee
 *		that fault_flags does not contain FAULT_FLAG_ALLOW_RETRY.

Trace through the
FAULT_FLAG_ALLOW_RETRY/VM_FAULT_COMPLETED/VM_FAULT_RETRY logic
to confirm that the null deref is a cant-happen.

It would be great if you could pick through all this and propose
addition of a comment which will make this code less confusing for
others.

Thanks.


