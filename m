Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EB1C105F78C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 11:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A0C6B0088; Fri, 13 Mar 2026 07:56:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5277E6B0089; Fri, 13 Mar 2026 07:56:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426B36B008A; Fri, 13 Mar 2026 07:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE776B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:56:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D61DCC01A5
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:56:54 +0000 (UTC)
X-FDA: 84540888348.25.0D0E4DC
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf24.hostedemail.com (Postfix) with ESMTP id 078E4180005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:56:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=IIESd1Uk;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773403013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9e4QYCBfu9X1XugTZ9umLoiQeyWhBUoGrgSTAJmng0c=;
	b=gjYG050MhWk9rQuL3AferiKV+VsX/rnqSPqzDiwTZ3nhLB6bybuQMw3ojxBaJOH/6q8TWO
	7CwVC4Nr6fW3WDKxnDB7fZ7kxisesz6qDIHUwPXg8nt8gyQaDl6ANKq+xFwSyl7+hLFS2K
	bmXX0MPdU0UKPNrTGZkdjXzBrX8caVo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773403013; a=rsa-sha256;
	cv=none;
	b=qBI3QZxPsAbDfmeKDO6LjG/jGVpdlACrdkPBGhzOcrRrDFZAZDx+Cn4OP+KqPoAWdA0Np+
	c9ZvNwm+b5fXwPStZLSHkFjbtyvXEhibgDj7DJGmCoRw4U2qzn9JhaxuLNyfHOf4NrxHRt
	e9l/B9+1pRzYKwdTFDQFm+nlSGq+6Ck=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=IIESd1Uk;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1773403009;
	bh=ryfo0HX0S/V7M0SWwIS4tZdxJ9Lo0de+Y8H0l4abNTw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IIESd1Uk1oG7U5UyfDe0THl2ouAMqR+m4rEcTeXgDwoPpDZbZMthh9uHpZwEAwr4H
	 eNNiyCXl+59Dhi9/G9tCj3CButG2iEBU/MJSm4v1JuNxIxG0thDMzj4eErz02xATFh
	 f4PWEUOEFGNTbynfQINKj8fnS+mTZ4Y540I8jCHD1jGrPHqFdX2MLQaK/udzMCagfx
	 IxaaXNyxuQ32iZklS6sbx05KxeoVRjBaHV5xYidm31LA3fglqVoPqqg4SgajqxQyxQ
	 VARBUe9mhhLuVbtGIyBLVVN7G8kVkyxXHYLJcLZ+LVeZHk0Dnf0HAamGB38yBOrj6Y
	 jzDVEiPTCiLIA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5CA2017E0E6A;
	Fri, 13 Mar 2026 12:56:49 +0100 (CET)
Date: Fri, 13 Mar 2026 12:56:44 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Biju Das <biju.das.jz@bp.renesas.com>, Tommaso Merciai
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
Message-ID: <20260313125644.65131b27@fedora>
In-Reply-To: <f3384342-cdc5-4260-b670-4ffde76a2802@suse.de>
References: <20260227114509.165572-1-tzimmermann@suse.de>
	<20260227114509.165572-6-tzimmermann@suse.de>
	<abL5rcYIaFFO3GW2@tom-desktop>
	<TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
	<TY3PR01MB113461ACB668738E1952EC8898645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
	<20260313111851.4c1f89f3@fedora>
	<f3384342-cdc5-4260-b670-4ffde76a2802@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 47bc5bguzinm11sbtdo15mx85thrct34
X-Rspam-User: 
X-Rspamd-Queue-Id: 078E4180005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773403012-744899
X-HE-Meta: U2FsdGVkX19WzzZiZZO5WTnDcdpXP0b5VNVCvPJwHlJKaN+FA2Ec/GEUptoRGYQ2yXvJXsOFGKAljwX1pMHCSE4tBku9WEVxF95pRz9bxhLLIPAm2WpRVoJmFKq99cqDSoyJY3bxxe45peUOqf3mhYvULcGoOrYJm89OH5Bvk43U4d2LMWHImEDERwxzpGE+J/ev+JyR6BYQe6IfY9aXSZ5ZGo3K3BFriTi48kDB3sZ2v2BZ68Aqq5ChIozRzn+YGZBl9XP/M48aganc5LnT9AI82qbv9IxoHVffWJdOQ60cr3zir5CvTdXdHvY0XG5JGelMpxgpAbnBuhTKuK0e/7oWIzMK2j+H1/IXrqq2LeIfZYsn5r1AOIem4LDOlRZt2kusjkOqcWqQgQOedjpm4JS8IUmht6OhUUlhHP2mQAv7tWmX+2t5f79fSJE0bdKDDn3BgYZtnWVzQ0SNfXgxMWmUYnasM56HNsMTrNyLaN38btzcj7cwDPIXSyjA4bOl9WDNS/AWFTbyqt2/BbX0346Q1JC78DSv0oGfN4d8X+98Z4XItbm4/zLvJ2wINpRFoRwCdvY7UqgEhWLVTAgK+uFEcgR8MpeisylMfFydhpjQKC1/H985sIjxfDJ/RYpl7lXUuC9LGkHDAmH+PV4ii/w9hcLWGowpmg3zAMT44xixDxEuumClQLGfQWkPT4qNkgMJEH1+10m5u6unurWzPVvTkPaCgMW/cVLiX8rui+Tr9zo6ICpNUqM1433ub2mtlThF+LolnHc/KZeXhdfi/d+W1olj42kf6Azfe6KRmvKLedlPMkPWCldR1V/ST0tdu6Ggq0iVe4NsnnrINFEYX12buvRkjYZuxao6z2dwRhQUu9RPh4tL9HAS41R2W03oyP3KJWk0W5KS+YuPuihEi5KWLjQgoPV1TmeWx6ta3iq5feHX2vA8bK8/wOV12APNRE1i4EahzVDEMd3l+Vh
 acVg3UlJ
 N72tnM7V7RXstIqtAGRK2DTmiUWLLiBdTLL8lOohOWUv2xS65JELHIhW13bIqY4Ff5x+WienqW4xjcNYPsz4WQSpjGIcCG4s/WGfF3KUxCM4/9inuvQ2OWXdg8TlHWtpkQT1dpspKXXHaGo3uy9pMHEeg7iNkT3G3Jm65JCsa4vvxa+MIq4KKFXAJl6FCuk8X/QKVHHnr7Q06//M++dp+FKGbB+l3kJVvd2QGkyeJSm+fJJr+jNIW2u5p9kHBF7Zo63q05yF9H1ZCvr/VfOTBvvEg0Ki9u6Ud6gZYTGS2CNATUdeKpfy9G0L6k5rF424xLNyPjSKxqVkcx6hJFBWw1JLrj8cmdcBtcc67Zg2kUIge++Fgr7HPpdBAwBb2zJ1Leh9zWbNdneh4PvT7GuRc80fXrxaNcx8gXF9F/C5mGfrs+7yWhOMpb+N8oA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 11:29:47 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi
> 
> Am 13.03.26 um 11:18 schrieb Boris Brezillon:
> [...]
> >>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> >>>>> +		return VM_FAULT_SIGBUS;
> >>>>> +
> >>>>> +	file_update_time(vma->vm_file);
> >>>>> +
> >>>>> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));  
> > Do we need a folio_mark_dirty_lock() here?  
> 
> There is a helper for that with some documentation. [1]

This [1] seems to solve the problem for me. Still unsure about the
folio_mark_dirty_lock vs folio_mark_dirty though.

[1]https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargomes@gmail.com/

