Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B19A3CDE000
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 21:28:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91C156B0088; Wed, 24 Jun 2026 17:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CD4C6B008A; Wed, 24 Jun 2026 17:28:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3E06B008C; Wed, 24 Jun 2026 17:28:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 593FB6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:28:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C85CB1203DC
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:28:35 +0000 (UTC)
X-FDA: 84916095390.14.A035BC5
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id E433A16000A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:28:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gQo8gjXl;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782336514;
	b=l5eNZ/6iyUe4I+auQRfGgbYbrT+KbB0uNeZ4aVaTK+q9FZgi4+TCgUtVCFWb2npxiMXQkk
	S7lLMJEYXIPiCq9Lk+m9k5H/utJAvC2l6KZ9nJ6snAVzJpcApZ/SXchO72J5TrnAFiRpac
	wAubS2ljSJqeZB1pn+yZITfOkIw2Vpg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782336513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6KvGnSeke+GyyXEP/Bx0FGRYD1wjPR1HoPpU93wagg=;
	b=ELALU5O1fgGfuw9RgtUP1UEqxpkXo5Yv+6Lp4MJJfp4rAhzBZnRquk+R+eXkdRUlxpjS7u
	qzo+4NZo3DRQJZ/pWRrWzupA0uuewy0fimmWg7cyyglwPXl/yGXrD1RDizXZRspE5PwdDx
	xO3I3Mmbc/0kdbaoUqOYZnQeEtAzgCs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gQo8gjXl;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-922ff615c14so156336285a.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782336513; x=1782941313; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=O6KvGnSeke+GyyXEP/Bx0FGRYD1wjPR1HoPpU93wagg=;
        b=gQo8gjXlpg6jIy2J06CeGb/CnGmUlq4CUK1S75nE9UhDbkpPLuRwZVB+9Mh+4Zk+Eh
         WkUjl0o5E+I4y4XqlmAYTI1JQOkDg2+9Bi72yW09aEYMZT0SqXlcW827hKUK8OBYVcFx
         TLKjkjpJeX3uNybnSOHeKLZ4BvMFkAY+pK2PRXBLMFN71JSA3FMvm6OniNyqSlaJiMH3
         UzMWs7gkG69YYGzZAx/diRM1CgqqMwJyWG33/JfwV8exOEwPatNJ00AThyRx7zRN3H+3
         t2h6IxsgM7uTp4NPZwnoqS8OiZSGWzUzfwKm1hWcfWrx4I9CFROppJnzQhmDsJKxkEvT
         bDWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782336513; x=1782941313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O6KvGnSeke+GyyXEP/Bx0FGRYD1wjPR1HoPpU93wagg=;
        b=LU25zdIw42fWLxJweY2QKJyxxZn1zqSCp9+4x7KWKdUmXg9t4bmpnfnZAg/2/tRAEq
         iz01c8Lk3+4zkx8+L5zBtuSvjMygdu9x78Z54EaR8lXjNjujY1IbXxhc+Cw0bVadXYre
         UTyMjIUi8M+tdvcbeR7hmae7VytBioGRwq3REFtupNdbAOB3lD7Qkf6yOKgnF7GV06Bf
         vaFl2GMS3px+2tDxY6sc5xTwurQOXPua0BAaColYWEJmsbmjzaHjb3d/mP4WbfnvVBxd
         rYvJ/29o+tWm84jN2q0W9r8tZwvnQ7dagybX9UvMTNgTKSAHpc9OjUxToqP8p8bT1c2U
         /EMA==
X-Forwarded-Encrypted: i=1; AFNElJ8He7JV03PNtmPSyMBluDVSI3Gr+X+GGxqtIXvqXA+c0yVTTmU/kz2Va1ACnRBchbGNt28wg3BPcQ==@kvack.org
X-Gm-Message-State: AOJu0Yxukx9wieEXxtxaYXn6d939c0E9sqscPVnoFFf7QlAhnJLTgTRO
	J8uHcx2HCCSQMnL3Jy6odxQb/nY/SaBKQEzOtd1BFzyJMJqGWU1XWoIjJD7bpOrgJGde7tvAsJI
	GzQMY
X-Gm-Gg: AfdE7cmxSX11YPPRZLxJvHuqqOJzzZiIhVShxw3q6rsVtG0F2dwTkEuLgeAWUw7tdhu
	TWCt+93wWpc4nFaKdnFRPXjW1XD5JOI6c2dCw9Ggd5fguvFAK/mbQS2rkYg3Skt6FN6s+YWf+UG
	7La+r43zIutPr6fKtKjk7Zd6/yHQpEbTZUICKoFJBLJAp7voKBniwXUZVSA/O0PZ6Uv6woI0g7L
	Az8tJpUQZUiqJ5k+DsQJkvK8R/15Kn/tgI//DMDPpjYAebhxKOmurSXhbQUnFre8ayt0ZMN0y0I
	2Rg8UcRPUyBlTUlhry9n8Sc08wTOAkZO6oGvGBWdqRMnk6ZYLNKKWy96FoMWFd6ZWNo3hqsRLeO
	dHRezlUifQntrMAPSnJnlaxyFrW0pZ/ic3K9E3qF93JqeenUc1sgIPJ6+EjMjc+ymJiCWLxcLgX
	QnaFWk/u89F624QOWqY2aQgwkzNoJkYYrfrXxtQaQ/koe6tKIUWBGwMhnMXpT+Z0ccsDQP
X-Received: by 2002:a05:620a:c45:b0:915:abc4:b570 with SMTP id af79cd13be357-9277ea2e6e2mr831365785a.48.1782336512781;
        Wed, 24 Jun 2026 14:28:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-925fd39106asm630817585a.7.2026.06.24.14.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 14:28:32 -0700 (PDT)
Date: Wed, 24 Jun 2026 17:28:27 -0400
From: Gregory Price <gourry@gourry.net>
To: sashiko-reviews@lists.linux.dev
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, david@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v5 8/9] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <ajxL-5d3JUArPRyo@gourry-fedora-PF4VCD3F>
References: <20260624145744.3532049-1-gourry@gourry.net>
 <20260624145744.3532049-9-gourry@gourry.net>
 <20260624151122.AFE551F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624151122.AFE551F000E9@smtp.kernel.org>
X-Stat-Signature: 4wrj8wogrchd3addeiwm6p13gqo14son
X-Rspam-User: 
X-Rspamd-Queue-Id: E433A16000A
X-Rspamd-Server: rspam02
X-HE-Tag: 1782336513-136024
X-HE-Meta: U2FsdGVkX1/+pbtXV5PXhgV7eKyp82eIoUWlvxCjXbQ3lMN36kpySyTmOwu6dyiXy/3h2tFsXsoJybXXYo5vUKKk59ycHJPb50ytgDXaZOtcfOPd2enIS/IZR1WDaiSyoam+CZMJpBQDIL/PAA+OAABXiC9zdJXQeDEnKG6FC2PWLSSiHP4Dn9+V0P1AMAnDQpd58MQrLvagcXbUrDP7bDDbb/puzcvITGZmsRBYlUj7+e4Ox7xl4kjWF560YunGeDsqYC2H4N8bBOOHYwFte5mTQkF+6V2hyBHcnLunaz4ujpAfr+apkbtzBHXYOy9mXeJ12KLgvcS2uziAb+KIBONyoUikcFWqI0hOIWZfs+hQjgGe7NBQevYMu+Nlhtj+3dWJx+sREIKxjkiefT1tx2jF0eJx3WIu0NqoKSsq8v4S8ixJb3Lk6Tm2yIoMWtx3D2iaR5hXVLZVe2GRDy3fEd/Knuu19x/n2GLaewKSG0M2K5NDRk6j+HD7TyaNnA6/KPT1/+8TsVOS/MRUuEYhKj+STCQNUXraYjwNvp7MC1bNDF/vD/bc0yGXlK3ZzKXd4L8H9BZ5Qj42oVHhZmD+WYQ/+vxD1XH5PpdY+yOGUZsblzE70qUb4HqO3u/NbXoAfiKhH5WjXsOowjY3Zo5TGWaidj8HUK48o4YWd+wKBMOPb6POAJ/+JHjTVWjXBmVEdWHn8TI78qLdNhhoUxg3fHXap4XPfBlXnveotLA5/33Ez9wD4C62nzyf0xlHXVkpbOOuq2VvlXg9GTtLHSjnzMpSPNTyPlr+zvAimf2JTIsV4SLJ3kxYA9MLuOY6Q02M7P5JXUdHLJgGCB4pNGXmc8QYULDkoU0CYBI+RyoVehWUeGrVyH0mStnDX/gly7Fk07Brrb+n9QtgKUMOfuiLYow+miPGp3draed/+kiOVq9Se0MaYnE7jF0Mpk9WfgCUyFz9exWiTvtV74d3/dn
 SOdKXqMd
 ls8r5CqhtaQIIfp3jXlPJ4Eivh1RovIKw/gxFlXFdRCZ1pZZR/LvcY39rN3FEIrjysbmK9LMUrPVK1lKPpVmXD3SY+ckJWDKlfxQD48aWAQHmdDiQPJWemAhRExPZHKjqf15mGvBflNJhmX21hlhHJPg2LQszEwVRdj3zK7oIcxqP5wPMw8TMFADB+I8ulmQU7AefSASDr4DXUfOMzZ9b/98Gib/DYxT9Z3enQ14FxmvBTzfRVSjJhHPHNaulkVCmH9r0zHAF2qEDTRagrvqyc9tc2d8OfQ8G91xrG0cU3xXp4PhlWi6+kpZ0AW65JZSAc9jodm0SA2aB3+O9VZN+IRr6TvUeogNbO3kzmuVLMWMP02HXK1o8nodNORQ7QoTd8T3R9kokvWmKHR66lLRDKWSdcpgRMTRZo0mz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 03:11:21PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] The protection against deadlocks during driver unbind can be completely bypassed if the underlying memory blocks are manually onlined via the core memory sysfs, causing state desynchronization.
> 
> commit fa89899811083ada324ea3db8204b1c135005af5
> Author: Gregory Price <gourry@gourry.net>
> Subject: dax/kmem: add sysfs interface for atomic whole-device hotplug
> 
> > @@ -348,20 +490,26 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
> >  #ifdef CONFIG_MEMORY_HOTREMOVE
> >  static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
> >  {
> 
> [ ... ]
> 
> > +	if (dax_kmem_state_is_online(data->state)) {
> > +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> > +		any_hotremove_failed = true;
> > +		return;
> > +	} else if (data->state == MMOP_OFFLINE &&
> > +	    dax_kmem_do_hotremove(dev_dax, data)) {
> > +		dev_warn(dev, "Unplug failed, resources leaked until reboot\n");
> >  		return;
> >  	}
> 
> [Severity: High]
> Can this deadlock during unbind if the memory state is desynchronized?
> 
> If the device is configured with auto_online_blocks=offline, data->state is
> initially MMOP_OFFLINE. If a user manually onlines the underlying memory
> blocks via the generic /sys/devices/system/memory/memoryX/state sysfs
> interface, data->state remains MMOP_OFFLINE.
> 
> During unbind, dev_dax_kmem_remove() will evaluate
> dax_kmem_state_is_online(data->state) as false and proceed to call
> dax_kmem_do_hotremove() instead of safely aborting. This attempts to offline
> the blocks while holding the device unbind lock, bypassing the intended
> deadlock protection.
> 

Pulling this feedback onto the list so you know i'm not going to address
both pieces here when it comes back in the next version.

1) dax/state and memoryN/state can become desynced.  We can't do
   anything about this without a memory notifier that prevents this
   desync by disallowing memoryN/state toggling for those blocks.

   https://lore.kernel.org/linux-mm/20260114235022.3437787-6-gourry@gourry.net/

   this unfortunately breaks existing userland tools.  I was told to
   drop the notifier path and explore deprecation at a later time.

2) What I will address: if state=UNPLUGGED we can safely proceed,
   otherwise we'll simply fall back to the old remove_memory() behavior
   where deadlocks are still possible.

   I'll add comments that address this.

~Gregory

