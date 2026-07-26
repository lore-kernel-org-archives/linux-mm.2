Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83313C531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 07:03:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DF16B007B; Sun, 26 Jul 2026 03:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23E666B0088; Sun, 26 Jul 2026 03:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154E86B008A; Sun, 26 Jul 2026 03:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0FA86B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 03:03:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 43A121A0479
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 07:03:02 +0000 (UTC)
X-FDA: 85030035804.20.89BD8CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A2A4340009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 07:03:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JnFN68mR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785049380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZxiZW08Hu0R65YtY+JRVPRCwebHaauBVClbXymkXrp4=;
	b=GbWhVRCkfdMQzyzXBNbbAiHcBpyB85fVx+fPJOWvGFhdB3RigaHhWo2HChEw8I3ZMneEhu
	Q/HUVREfXIiFDtD83it70eaefGK7D7f1KuRkXsROmP3cCP+OyuGK1ZopWx43reykUYwZ3t
	oButrKeFpIgXAh0Q5QaXC6DHIlYxKY0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JnFN68mR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785049380;
	b=7VXP8amX4O4fRX2wtd4KRIId+ZE7XoRE9ImofsOdtmCrqoQU40VZkIROQyCQiPV2I9Wcyy
	jcfCb0NvDMrgRDEnGUvQAweQHbzHFMesQJkt71XbBaOreBgnxtaTZwZWDmHruTlZk+tIyR
	naIXDMhJY1EyQTDWgMVN0V0C6Aoytjc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B73143C2F;
	Sun, 26 Jul 2026 07:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F203A1F000E9;
	Sun, 26 Jul 2026 07:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785049379;
	bh=ZxiZW08Hu0R65YtY+JRVPRCwebHaauBVClbXymkXrp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JnFN68mRo+kgDRZrt2WqLdbrsEb/UcY3qK723zkwBpCx0kbdfdGlnQyzxGyjdCmK8
	 miFHNo3jn78m1L9mtEB2AOqclgMx35qLrRlo+HV8OO6tIoTiw6RjFMk+hBMIwqULfs
	 PtD85DpsB+rnQfkCgAujltBKD3PkpqIWiO6JKC3fT3M7K8h5vlUcg9yjWzoy/8hWFp
	 N6wx4lW1QdXCrBzthUBxcd8Zol34Dq8vO81JJ+lLqGAwtkB7zNvILU7U1SZPZiMCHn
	 HHuyhXeTnmCPcSiZDbjX0AffFDP2EUh0qv8X632tjhciQfg4JCZTsGQ8E7DuV6cTL0
	 OKC3gHHD1ghzA==
Date: Sun, 26 Jul 2026 10:02:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Mahad Ibrahim <mahad.ibrahim.dev@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lkdtm: use kmalloc() instead of __get_free_page
Message-ID: <amWxHSl76OD1fKQW@kernel.org>
References: <20260722230246.2869-1-mahad.ibrahim.dev@gmail.com>
 <DK5HY1IKXNC5.36QEPX9H8SUHB@gmail.com>
 <202607222046.D287828@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202607222046.D287828@keescook>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2A4340009
X-Rspam-User: 
X-Stat-Signature: 7qskxm1bqg3aq779gtw6i9rs5qgpgbu6
X-HE-Tag: 1785049380-987987
X-HE-Meta: U2FsdGVkX1+6ZupOux9BTyRm2fkwd7iCpqU4BPZiAo0UClhSiH9WaoopD63yLhiyr4jOjdgVoT7Y7Fy1m8C+vKpnQ0rYz9XZAYX5E6553ajSpd5QDfoa7aYDkO0vLHnkBuY2L6JAYJs5L+WcU+zXS5Lriik/Gp4qcOuXJerCKhmKIoAy9qXwD3GyUiH8Q4Gy9se+jNbHzYyhchNObkEWRX+KlBC1owUZnm7D6C9aIFFDNunmWHdS0niSzPxhvJQsuFH5+kt0t0WlgRbBN10HCY47vnPITo8QpUSxpZq1zmL/mFUiC7nU91GXfm22f55SpDxQGsJ7lkc/bwmeKspp1RewFmGjjPFR6yP3wsjSoXHM22kcBjLQr2HofaHEJa1GAdPlIcqanQX37f1X2+kqjtl6a0JWEI0ieHl6lH2ZIRA2lACKI/evQrsLmom7xV80BKglTagDBuS91udGgimILflIRrvttFK5UE2xguk1DvW8Y8sKLbrhibQ6lm7Xf/QS7C+aisy2LCt0oG/95lBKgngXlzw790F5lEsqJaT4wZYiKnCzpY8Po1a9mhy0BpbH5tT2RsFY2Gkx5UORgNYwkRdL5jvvnDeck5qBsWCmyIF61jjljuc+YVu8d6z+vZFCdtP6tsn78P4ZKoPRoPISogWQVRnZH9JIbs+qlnD+yOwPfY1exQGFwnDSrQCW7xP2njGaxs1YXJC4753JoRR6VhA+k5dSD7475u77XkGLhL+4LAQ+fjkuyoGfZGV6Y5xceBCjVdYKaNtJN+dXk0rEnCG3Y/mWoLcxDyEtHBsLoCj1YghneIS+SNzCw2rCZ8Sl70YZruIzo9FPJTGDdh9TFC4isc0hSQFaZ9S4GlrBK+4UX7p8jdm5u0rWTxUUkCBQtWj5fQ222ZWfWhgtuHLhzcPyG+AWjcRxYwgd7NxOfxerp3fHJuiLTWmSvouMC47zyfaP/Zn+3E8NVaY5uS2
 W7yHJMxJ
 ZYCAQUJqBakrq8OjVpnZa+ZMPgKmnc2m+BYdfefGFugp30TEs719jP968zd0S3RGmXNZLw9611imNOXoXZUaIno19r2raY6OvPTKt4wmsBjoD7tVHg5Tl8FGZQAzqLHuxctP+cTz10YDt/43KD3G2WdmvpC660OnlSwl6SvGQ1cemzjJsQTZMMEQz8rl2M40R88YmHmf2bQ6w+R67RPMvlkXE0ZqNynkhexJzAm82HZHM83apq3r2nTQ0vBVeFpxHYdCLGRQK/0XK+RPOBcowHZq2wTS/pZkFNF0UcN8pINDuNDyBWdGHZGieU/ECWnSPKyq1PAuozx9OrfIn33Vx+RPbK9xnLxE07LnOSgGrtjyugWezkLJiR6me6sZdFWV4igJ5nZwYdqfN09pqhfcfMAfcU0JwT/1dev4RJLZN9vnGliE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kees,

On Wed, Jul 22, 2026 at 08:47:01PM -0700, Kees Cook wrote:
> On Wed, Jul 22, 2026 at 11:42:25PM +0000, Mahad Ibrahim wrote:
> > For context, this is part of the broader __get_free_page() -> kmalloc()
> > transition Mike Rapoport is performing. I noticed it on the mailing
> > lists and found this site which wasn't covered.
> > 
> > Some background:
> > 
> > [1] https://lore.kernel.org/all/CA+55aFwp4iy4rtX2gE2WjBGFL=NxMVnoFeHqYa2j1dYOMMGqxg@mail.gmail.com/
> > [2] https://lore.kernel.org/linux-scsi/20260704-b4-scsi-v2-0-7d2d21a810de@kernel.org/T/#t
> > 
> > I apologize for this messy reply. I thought I had added the context, but
> > I didn't.
> 
> Do you want this to land via my tree or via the series Mike is doing?

I'm not actually maintaining a tree for this, I'm sending patches to the
subsystem maintainers, so your tree would be great.
 
> -- 
> Kees Cook

-- 
Sincerely yours,
Mike.

