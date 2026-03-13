Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2DB7105F799
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 10:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082206B0005; Fri, 13 Mar 2026 06:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02F856B0088; Fri, 13 Mar 2026 06:52:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E535C6B0089; Fri, 13 Mar 2026 06:52:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D47D46B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 06:52:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85EE48C84E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:52:38 +0000 (UTC)
X-FDA: 84540726396.06.1CF9400
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC5161A0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:52:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=k1crffAN;
	spf=pass (imf19.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773399157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glCdIlbKe1KKtrplyO7KWdTFQ8Slcu/lDbOsFeROz9I=;
	b=hdCHgxB+CTCwrN4bJk+kUJrynOU6fcFzzBUWbRQ3qbRVJuxLck25ogfGe8RN5s6HZwquaf
	tCIyd+X3A4yq85b9jzGDttLjPgaIkVDo22DwVlnd/abXsAcZSJSi6AtFpjVHpjKV8tVREn
	P53jXU8GHLKvNeIiFPLdQT49xbP/68A=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=k1crffAN;
	spf=pass (imf19.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773399157; a=rsa-sha256;
	cv=none;
	b=zntAe0XA58bTlxVPz9rinrUtuawocQC5mx9tys8UVmq15h8EDYEm+r9qAL4L5IKOp07wYs
	Vo20Eeln07xzZvEZjVyqnmqTqWDEZB2K817y7Dy/QUIR8mz+Jr6O3rsdREQDSa2qqVItAm
	XVjVW44qzXYS881v6ARJnMuMf1Akwo0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1773399153;
	bh=+oXaDRbNusXTMSSax236f0w9eZRyQ4ofZH6RI1lFFOA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=k1crffANo5WtMZ8+i9gRbcbmXS3NbPjwM0y8sdtEfl9JhpHRCRWRYPeG281GYwykY
	 FxoIP/swG3kK9QMyPdFhHcxbS0X8UCbPNvdmAmcNJbuIoAsQwHVOpzjWlkdg7IXp8r
	 fpiNDxqg2hZbQ4O/TDWD4ASn5QZDczct5NxCONsW9j3wn8quOElNzGw+6mB83OkIw6
	 y3I1fX1Co0PKTyvBbtvlEY1bMOz3GJDyq9hv/T1bwi80czB+jHGEtQwk/tpa5VYWvu
	 i+CS2Izek3iZGkPE3QmE88SdkHVyr+GBUCa8nxKsaGR4vMqeDkXNcti53Vb96G6PR8
	 P4nI1Bhd7GAEQ==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5089317E0E42;
	Fri, 13 Mar 2026 11:52:33 +0100 (CET)
Date: Fri, 13 Mar 2026 11:52:28 +0100
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
Message-ID: <20260313115228.5c516729@fedora>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC5161A0005
X-Stat-Signature: k4fe3bkhum3kzs5kjq7yn9mmnen1f9rx
X-Rspam-User: 
X-HE-Tag: 1773399156-699242
X-HE-Meta: U2FsdGVkX18hvX/NmB1qpvRGWUvnarfXWLObhR9Idbl66ghRCSicRyG7VZP3zC345+ERXTdwgeNcWHhmjT1nBaa69Ga5debi6IPWa6Aprw26MwFHCrkbMt8moT+uQWP67bPpBAxQ4lWze96a/aCgl5iXCvZ3qgu5vUqC6Y9dN5cwXkD8lRiF+yaFJjpIs7bDMz5W10Tq1ODQ2FaZGNeiMJjKGSNE4yh3V98VCmp+Mjs0Xe90dmlrJjbJmecloBeStAdz9Q5XB4puCSJtb4r5ttnsLBbLhKJALzFtuaQyVrAhTKepDsiByJGS4S442+W68KtCWFH+vbVEoa+3UhPjqnv5eLvKZqnOz4ycJ2zEkRnOzvuBgceXpDDU7JAZUixZaPy0EUQqjHipNOtWwSlDKkCGizB5HzaXNYxAtjJAJpwQeQ2BlXJRn3v83N9m0Q2XfMMuF1s8sRWjbuWXKWmq6MaIOM1+r1mGPc2nq8r/l3BE0iTl7XIBqcTjHjK5VMI2WcnNqHBrF6UzFHj2UEvRUudHunAm4TQvrjUqQtlDg+MXnFH+N0uEbF+z9GRve4jtyrwKe6Ot32zD1xxGKFoSUj8xewu8UaKfdyUrNIn5/WCO7E0VPFIMo9/5xh8Nrm92oNTVdS5Dkp0/g0ZWLLbtCX8j0GiGC5Q9EkZvY4R0zzJRyMnHT4aO7ftzSmPZ9TgP62mAv+z+I7Y76cwtPX28jC+wml6BQ5MInZnX0CvdSpZfMnbSywhtx6r3/V6XZV5VTM4XNQVt0NHQXfTfMYVT13Aj1A9eu18CPv+/oRXeCHuNwf2XaBGKrlQ20DQh3gdTVqMFKp3kYWYROPB5Nm5tPCE5ejfKURZvF3ACY6TTuQMSf3s8k3qqVV9Sp7k/dCATYKnTl7WV/USH/SuIFfnWld30R5e5CbvMu9oWLN8/0sdoM53KA3w82o2Pn/2VnuOA3mBZG3Uhp0TTLNVphfG
 xVeaxsOm
 /xcEofBCs73vibbZCWOSmuG1teR8FYYeM7G4W
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

I know, I meant using that version instead of folio_mark_dirty().

