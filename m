Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09854105F7A5
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 12:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68CD36B0088; Fri, 13 Mar 2026 08:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63A7F6B0089; Fri, 13 Mar 2026 08:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546C76B008C; Fri, 13 Mar 2026 08:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40D856B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:18:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CCA43C0309
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:18:46 +0000 (UTC)
X-FDA: 84540943452.01.A4BE9DB
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0187280009
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:18:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=EwYcX4W0;
	spf=pass (imf02.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773404325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhqfgKfgLjcSN624koQSBBUu7/Eltpq1PY0rzouxX2c=;
	b=1aO2iC27n+FQ/lnvbn1nS/G8DnnDDeYUGkOXhDIy8BBvn+yLoS4qL3STPiAWdOpZI0LXUE
	RZgyd9M0aQdCamVLq3y+yjsx3s2cdHnNEtBNZCSn7fjCoBHI5HZLr6VBaM80A/8fmbFlXP
	mkASNSf/QpNF7FySMYwXnjaJ4ZHaIm4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=EwYcX4W0;
	spf=pass (imf02.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773404325; a=rsa-sha256;
	cv=none;
	b=E7kKImGlEAnb6qzutNrXR17Nf5H5VJxvpGmWRN2ZH0kgJHkMQdCgXPfW0zfXo+O3ZVt8kF
	Kk7MTOJLjWAYtPZO0zRJgH5buP8Dh/hXp2Z1UMetVjYdsBQUQIUrFZVPRbUNFkkBGG3Jj/
	fVBQD3S16YLTuKw7ZGKVxpqiTZ5oGXg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1773404322;
	bh=x4sb+zRi+GZkSPqrObwGi9xUSGxt8wL1sYS5kLEKUp8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EwYcX4W0joHOGEyrAg6FRLo6BeUMmUtVanaXLcKt20B35ZEseAijkKA6QTD2qRrkC
	 /q9P71d6ugXFoHhG1E5KjkdEoPFfdVvwMUbUEEEMWCaWYCSwhKejQhM560CqoiMuQ5
	 VTmyLXUIwFRi9ax9oQwNkgy4qFymgJOqiMa72pM+ZtqHM+Iy5fzEwXaTeOxRgzFcvO
	 HmXq+Tf56UHJ4AkVO178izW66S/6Rd25Hhp2vt+crF4V+3y+6czzjtaOFNsiokojqX
	 uCIuBSPlwAHUKUkSfEx1xsK+8lozLq4NyXljgGZaRKrZKods8Sz0OLZboXZWVUaMqT
	 2uEkCu+I2ixqQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9840017E0E63;
	Fri, 13 Mar 2026 13:18:41 +0100 (CET)
Date: Fri, 13 Mar 2026 13:18:35 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Biju Das <biju.das.jz@bp.renesas.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>, Tommaso Merciai
 <tommaso.merciai.xr@bp.renesas.com>, "loic.molinari@collabora.com"
 <loic.molinari@collabora.com>, "willy@infradead.org" <willy@infradead.org>,
 "frank.binns@imgtec.com" <frank.binns@imgtec.com>, "matt.coster@imgtec.com"
 <matt.coster@imgtec.com>, "maarten.lankhorst@linux.intel.com"
 <maarten.lankhorst@linux.intel.com>, "mripard@kernel.org"
 <mripard@kernel.org>, "airlied@gmail.com" <airlied@gmail.com>,
 "simona@ffwll.ch" <simona@ffwll.ch>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "dri-devel@lists.freedesktop.org"
 <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Message-ID: <20260313131835.52c5c935@fedora>
In-Reply-To: <TY3PR01MB1134662A395AA0A048CEE152E8645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
References: <20260227114509.165572-1-tzimmermann@suse.de>
	<20260227114509.165572-6-tzimmermann@suse.de>
	<abL5rcYIaFFO3GW2@tom-desktop>
	<TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
	<TY3PR01MB113461ACB668738E1952EC8898645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
	<20260313111851.4c1f89f3@fedora>
	<f3384342-cdc5-4260-b670-4ffde76a2802@suse.de>
	<20260313125644.65131b27@fedora>
	<TY3PR01MB1134662A395AA0A048CEE152E8645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0187280009
X-Rspamd-Server: rspam07
X-Stat-Signature: 18n7z5fa765or8zowmryjsqse4w9hfii
X-Rspam-User: 
X-HE-Tag: 1773404324-759642
X-HE-Meta: U2FsdGVkX1/58AQLvjrLwGOoUAlGFvznykEdf7PBJt3nCHvt6flCiwU3Vt1evFjLLbMNd2Cxb5FhHbB1snFl3iJFDcaa+Xst9furdM5LBRvSnnV4tjSVNQzs79/gatPvZqv2KYTqG3J7zqI0dTsa/qXsBtbxA1mOSpNuOx3XBNX6io4GqSw0a09o/54ZVn5o62VyfabbfHMca/4OhzijPuzrJyNJ7CRxt9Ek19VO7WtJWRSVoO5mvqaUnKTRi/gBudiTaljptvsLi0fl0v7Cc17CHIhyH2AWb9/ZRlEB1zNBG6gtKWZVt2IcJyCV2PPjLWEdhPefFKgyMVJrgwTLv0WDG3rsxqBmKy4zrwIdF7/CN0D0OxhRS5DJyTYJrFKHAEWE5JX6t//+gI9Is0eJGZzby2YJ/y0cSn7JNK0+5Kno8qIO6zeA3rwtiAaXVwmpL+HL5/4dCoQ7KwRUDoJX9zYjF+DYimMZHC4S9elpo8i+9Euk6SZcptqsNpRBdANRazdhF2s78dcQqWGGfXz5uJSuJ1oaNhHyty5I6j+LyXmeD+NEsGAY8QferC7hDv/Ly3bmZ7pGq/y5RU2pPuUuB3XNew62/D3oKdJGDBWz4oAH6CRwm6JMFpIOOYRzoArwvT7fS3k45LdCXZiyy/USR6dHzfWeT5QITa8yRfuSuM0dhFYPBiEypRqXkyyfRa9XYeqNQ5w8LRPWJN+6/Nfxq44xhUWVn65UiFqTItWki+VvyfFIcGVZV9nvp+qDHYGoTJ+sEK/g/sf+W4h+l2kJcoC0snWqEl9DQnVcKba9/WgL3jcUK/QkwmLi2dz1o9yf4myQI3tRSu9oD59+ZriD6TJXGEi+Zsibc1XCBaj4N4vPq8q9SgbjTEK1dKBoH/u7w0tmWp3Hk4r5DZIxeuE4ckLEMJmLzw0jjE74ID/MoptfpvAiTt7iS8WWZad/aRh9xTWRuUtErNLcEROEKsi
 s1VFkprE
 P6o26IoSQryHSszkyUrBpsbPgpIDvYat+A8eE0JBcG3wp6W8Xui5thGyJA/5J4TBicmm43vtsnpNrlLKW0630EKqFir949OJ+BYRiYXAJuOBFoDMlVkywCDJv+gW7mDMxuBhDj6e50elUXNQKBz8utXIkaWIbItJ5ORu0DMdxCgUGEiiUSYC+YFLOKBEDPe1MTrVz+KUxD3VR3JTCKSzor439B48VNTWsd9I27lKFUYp+gkx8vGbyMdcyGoUyGClMpCCoZdkw9XsZj7saq7iis300TN68gWugwivv82MGZjZPJDXNbD8d6E/5ckv3qfxxtUyqqY4FcwhfpeYhMWFlOpwWaotGJItjJmXAq7w4a3uWBEWpYbup1+gMUNmI6GBT3fBtw7zJKJde2RZQv9Ekim+BTUZDCZnLGOyw7L4nozPeJabLnfOnzA9q8+7dfN1jJ40NmHW6aNUL5jAoswwADfwimJSS8X2RcoG5hMhBmwZbeOGlFNwbd4jdNGLTixCt5CDwBauuZNSgfsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 12:04:25 +0000
Biju Das <biju.das.jz@bp.renesas.com> wrote:

> > -----Original Message-----
> > From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of Boris Brezillon
> > Sent: 13 March 2026 11:57
> > Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status in mmap
> > 
> > On Fri, 13 Mar 2026 11:29:47 +0100
> > Thomas Zimmermann <tzimmermann@suse.de> wrote:
> >   
> > > Hi
> > >
> > > Am 13.03.26 um 11:18 schrieb Boris Brezillon:
> > > [...]  
> > > >>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> > > >>>>> +		return VM_FAULT_SIGBUS;
> > > >>>>> +
> > > >>>>> +	file_update_time(vma->vm_file);
> > > >>>>> +
> > > >>>>> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));  
> > > > Do we need a folio_mark_dirty_lock() here?  
> > >
> > > There is a helper for that with some documentation. [1]  
> > 
> > This [1] seems to solve the problem for me. Still unsure about the folio_mark_dirty_lock vs
> > folio_mark_dirty though.
> > 
> > [1]https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargomes@gmail.com/  
> 
> FYI, I used folio_mark_dirty_lock() still it does not solve the issue with weston hang.

The patch I pointed to has nothing to do with folio_mark_dirty_lock(),
It's a bug caused by huge page mapping changes.

