Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D306CEE369D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 16:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 006496B0005; Thu, 12 Feb 2026 11:33:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29EE6B0088; Thu, 12 Feb 2026 11:33:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28AD6B008A; Thu, 12 Feb 2026 11:33:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D3BE76B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:33:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 655EB1A025A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:33:50 +0000 (UTC)
X-FDA: 84436351020.17.6DD7C04
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf22.hostedemail.com (Postfix) with ESMTP id 81259C0012
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:33:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=MOg9GiZN;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770914028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXxVe4fRiyRXCoNbo+oc/BgJFQHLEBXNd+WUueWHuWk=;
	b=Hy7dwhlP9EKAtGoABX95Rg5cUxfXmKR3lxhJM7I3vN1yYpsaIGa/RQFobvfftmBlO8a6e2
	Duf+FIRYt3wIKGn4l5ImWz8J1z860f6HZIKiSuAnMs4vDKcInDca5xVtOdURslzio5rfGJ
	aXFMyEf7ZAAntmh09JqwZLaOi57MtVk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=MOg9GiZN;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770914028; a=rsa-sha256;
	cv=none;
	b=bN+WQbVjI+q3VhW4taO/eErXBSnmKxFEe0oBOEr/uY3mPdIi00mkGI0earujWkRKP3H6bU
	9hrQEHpBVxyXW4xze78Qhmq+1f0MVfq9//xuPXTnSAbkQOI+BWUnvj5LvH+Od+IcNcY8Nd
	dCHXbFnV0FxcfH5bYZ0NTLNpuWMDgWE=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8c7120353f1so6898785a.3
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770914027; x=1771518827; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rXxVe4fRiyRXCoNbo+oc/BgJFQHLEBXNd+WUueWHuWk=;
        b=MOg9GiZNerdhit4wwVbxMTr3hAUhfl+e/KrPdEhsxYTnIBsvFS/V/kGMsjNc8K4EDj
         vuLv+SI8XFSpYr3QEPrwl+cGxWD8EWkXlXh/GoxmKYB8XlaPngYTuaMaHyjCgYIjn6of
         NWzTqr7To/xqrjpyi2RI4yRND6/L/aymk0TVUj3OKOOAQDF0Y2wSeuzwNMffZhnEiAOA
         2xzVE7uEcJTW9oyEiGuyPTEzAbmSmbO1mT0svLgxmCvHuVGxtzEPjU/8JSjgvWwQ7fos
         nLsgut5XecgYVKDFWU4Lc2o6lHHXHjj7CjikEWrt/a7emlmGynA/HP1KP/hhKVfw8xM6
         WFpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770914027; x=1771518827;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rXxVe4fRiyRXCoNbo+oc/BgJFQHLEBXNd+WUueWHuWk=;
        b=Rh43Tg8+Ycu7JyX5LjkB+lLrw3nv7LhfBkSDISzcIv99yc5TvKWuYfglzfYih37KMi
         R9/g/09Fjug6YY678nhFAT4g+anqTn2gs+Xpb6UoKQVPiHohT9Q/B7HpRo9HSbmBW4FD
         gpF/HUZ3QXnZtZB+rEpCNiity3cwV/mBDrRGMvsJNvZc9arnt8ggNphng9lKdRKlN+OX
         tlBrwt39yoMShdBFfXOeS0QKMpzQ3Ab4Ib3ysXJeg+Qa3wuyYr6Ir3i+3g5d8gi2VRVm
         39TvV7fjaVeWUlNNiyIvJyNEnRl0dzeRc8vbGqtZZlgRp7oaK4XSfzHyBlCe3pYrGLPw
         EbUA==
X-Gm-Message-State: AOJu0YzRWXF0nzg8UbU9Tc399VzZrWxExgynxlKfvDJiYQ5sfvjqbbMK
	COMTtEbR+L0qyHDavXtwLiG9b+JP4jVBFANjdYnFMA24NozD86o6QL4Hdynp7xNZtQw=
X-Gm-Gg: AZuq6aLWYbMwv3QXCVjIU90sxsFQw1fnEE8aqu9LQnmV9UARsPUoG+fdiqd7sqEhpbr
	AA0so+gte0cVfG/THAMhlTbCtkI6AME6KYfyUHaRqBIS0WxyacWujvhSR6aaS3Aj56sLA2JVrak
	hATJRhEsm7uLRmUMsvXDm4EPrHqclNAdVHQD8c02icUjMyjKZ/vMXYd0wliVMmAFexbSgsvCFy0
	mk8ViwNUm9wesV3Jj6b8erAKE3z1aiRWtlNYAxihPHaL/Y/KdkfU3zdmLfd/lQ2gxQksKvCrPDB
	CDITZLsSy8nlPxA+ndw2N+b6meLdmFmdfh2Q4kLcLxoieTVIGuCQ4hzLN/vAn3XgIC9lQ+W5QEQ
	u37RAkyL9dTwj8utBqmFbVX8QyJgm3d7d9RqtVZ4iDfRNjNyoW+YPCHKOJu0zAsvT8GfIqwzkCM
	daqXIrw+2muBHo3ruY76DxxFDnmY0glblGNaRlz5H2b5H7PKSeU/aKLaCH463l4lDDCpSCOt/R0
	1EszgPr7w==
X-Received: by 2002:a05:620a:bc9:b0:8b2:ed29:f15f with SMTP id af79cd13be357-8cb33090e29mr430636985a.21.1770914027457;
        Thu, 12 Feb 2026 08:33:47 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb2b20f5desm372226785a.41.2026.02.12.08.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Feb 2026 08:33:46 -0800 (PST)
Date: Thu, 12 Feb 2026 11:33:44 -0500
From: Gregory Price <gourry@gourry.net>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	david@kernel.org, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [PATCH] mm: name the anonymous MMOP enum as enum mmop
Message-ID: <aY4A6CgqvVKyCw5H@gourry-fedora-PF4VCD3F>
References: <20260211215447.2194189-1-gourry@gourry.net>
 <35db57ae-64cd-40ed-8353-7d3b64069471@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35db57ae-64cd-40ed-8353-7d3b64069471@amd.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 81259C0012
X-Stat-Signature: 688spp1cgy1wwz8ku5y8mp5m3jbi3ttp
X-Rspam-User: 
X-HE-Tag: 1770914028-831789
X-HE-Meta: U2FsdGVkX19ivj1vWdQdsP94sDY+WaOT2Kc3gy4LDCj5wyCgD7OiHTsZceSz/EWtQfZwOIV7jNGRM6ysJNtEONubDQ8kkfuizT4ye+mO8MXe0k+EHj0onZRVHQFf5SUESWca1x2NmRKCA2E8s+ml41QCplNwDqRvGKXpjDXfgakqBf8Xex2GDcid8Fea/mwAkB66WakE2MV40hTuXo3KKP5MD1/P195NszYUsrzwfA3Hn6PZE23l3PxD3lj42Mp364BTWR5O2UvvpixtJiEQPPo1fotxyxvgpjKI8dpDargdTg9SoZx5P3pmOBSr4fzMK7aHtNMxHpFlG+UDPratXyEk1RanVeZ4RD39Xg7/knGHooJU7ojqMW/VZzQyxZ6MpOvAMNWpFqVzwgLqtP1GR00g4I2RPg2A7wQ8/b6b3hinNYQ3BL+cCXhbxQOgX8ars4NVtMnYpkc8+3pNzJIF8DbnX3LFVDBZSM++9blPPp8H28qcuDs7cciHHtmznliNXPbBREPAyNREaodt9Kos5p5m+2IOuYSh/54zbrS7D96XcwUtPWjbrjgwbUdF1IPtboXPhmvH+8UCrvTcrV5G/rP6kMm2lmfrdYfl7z8Q7m5DStf7iBxjwScCLcaMY/t7It8wlxniCOJdIDABBo/Pl9TAelJW17/mMAgXP/B55KudveydC35NAZlmVBHUmDk+LykTAwfBVIaiuOiyrA5wCmPX1Z8G0+J+yDWnry/vxoVQV/WSvxHbPE0P177917f9Wem53qgBQ5WdSkrb6rLIV4ZIjEtZkyvVpZpKPogvJg2s/RLJICUOGAtmj/dSuWljOW5KKej54+t3lwyfZvFZCb/75OeSRn1rrHCBklmaKhG/FP271KM130FpksoisovAv2GnH1Nh9WLj0L5apvvgfpatICv9mur5o1cp3vm021oXp+VCgFm6p6lFoq0kLSEL2bT7sTOndqbbbYMFZ+j
 wwx95Nkr
 aXnEOdnxTS6E1utsUoRXwO5TZtSUtFV4vV5rjaUf6xp1xZRgsQS31Uc36WO6rOTnnOkZC3qwq0ZQUP1af2QxxDw8mXCkebq+m6HwyJ/w5wXHpJsKvJQ8tM71Y6k7ER0OGXvbuOKbAidNN9rS6fdeqUZb9jVN0bTDzVm3dSKT7b5H7zUN06kJEm5ymLvz9djiu4CEYufblwGP2Krde25qlrYucXprLGkLJxH3FD9JpYZLGDnP1YATS/ngdwOrm9UinRfgkwM0ecxoBBNHwDSKmw3ByhfmoVd8bjKoKynW0PeJHrAJpU3MTz0kox3QKz3KCLI70lNOAOKv109I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 04:18:45PM -0600, Cheatham, Benjamin wrote:
> On 2/11/2026 3:54 PM, Gregory Price wrote:
> >  
> > @@ -77,7 +78,7 @@ enum memory_block_state {
> >  struct memory_block {
> >  	unsigned long start_section_nr;
> >  	enum memory_block_state state;	/* serialized by the dev->lock */
> > -	int online_type;		/* for passing data to online routine */
> > +	enum mmop online_type;	/* for passing data to online routine */
> 
> Comment looks unaligned.
> 

Ah yeah was already unaligned. Bleh.

Probably not worth a full v2 unless Andrew prefers that.

~Gregory

