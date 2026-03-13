Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F07BC105F7AE
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 14:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83BF6B0088; Fri, 13 Mar 2026 10:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31896B0089; Fri, 13 Mar 2026 10:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE95D6B008A; Fri, 13 Mar 2026 10:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA9386B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:28:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60DA41401D3
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:28:14 +0000 (UTC)
X-FDA: 84541269708.17.176514F
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 440B51C0010
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:28:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="OXGhQUx/";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773412092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DhJJ93cKQQk3SpyT61kIFsBKzCFpwnhRvsErphsARo=;
	b=eUN4TjmWuXx3aAwXVhw43mE+9XV38kT3I9QFNMXmG+eHrce/v4U2Xh4DiWvIsarcMXyhR3
	+d1HtY2tgUmCztFIJf72zxc5iJTb33paoWwoPXsHxfobSkoP0OQz5A1MojGuR/v7hmwjV/
	Zinaq0d+P26AVY5Tp7CI4ebNJMYB2ok=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773412092; a=rsa-sha256;
	cv=pass;
	b=rigEiKTVZG1jjQVAzmtLtF21D+jYHNhYJwLmobBjskJB9wdgdkHwwLITYGAah9rekotkMT
	aWo8LNI3b6UAcQdNtWDA4crB+SUSt/vI9dLJrUAwO1v73NNwIz+9su+r5r1btpkQ6MnLZM
	LKrDh8qW+C3lzLIbPzAjOaeEXlhBR4k=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="OXGhQUx/";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-660dcafc85aso4222418a12.0
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:28:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773412090; cv=none;
        d=google.com; s=arc-20240605;
        b=lv4yszPkHTMJ1TzOY5CxvYVQwPMDGrwA21zewfS4r9ww+n7QW9+5sdHN8LGnRk0bkx
         2OoCLUzUnFPa9d8Kza0OLiOAhA9mSqJmLvqq90+Jm/7bNuqQWephb/6j7zuLJTSREUUk
         /dJXgVy+MHNwYTP2tYXJsAh/JoiUNAnq4mWc9c7jW6OET1F357RIiTGBdroE/LUj87+B
         Vi2wHRkKINpq+0jJiBJdGKjXbY0jK38ob8IWravLJ5arU2LJm7RQGYQ+FXhfNhp/vXdy
         QHxPnKCV0hbURz1xhzJaaqHaib6jdC8LZNwGIdRbiqXXPZCoZpvkaF7NEqYXa1nqjIMF
         2CiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3DhJJ93cKQQk3SpyT61kIFsBKzCFpwnhRvsErphsARo=;
        fh=qOCGiIsH5IxisvmCxCkWf9A9Kc/6swiHxcD/hOxBJhc=;
        b=I3QBi2k/v8YLB37D/3CmmOVHMaNT/RyvaIGWnVbS47B/FvxTAeP3mxHa5o8Ts+IR4R
         usuuaWRbcUJydoIF/Q38F/zALDIdRBpHF0gzog4Jqy11fyty7Jmm5mYumXLonrSt/xqc
         NZvDM/4GhHzKnQEi7UvGTHOmU0jcQfcT5j3DuypCncj6yPyFkHLMuuk/SCxxXR+hrOME
         2jBYyJ4Jbz7Gn3/fnAJufzxB+EDOUMlNSwTKYzSQnlUnJmw8LbN0ZNJPYZV0LPgM9THh
         TOiUCaxotC0RDRyn1Rd/S8/RknotlSKnFatG6R4GVLMf6Q6sRb0oeoDv8QNATQwI0fU9
         ZIEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773412090; x=1774016890; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3DhJJ93cKQQk3SpyT61kIFsBKzCFpwnhRvsErphsARo=;
        b=OXGhQUx/6UItoiPBaMInika8SBKKEJfjmViqz0SA9nLH254tJQuE6zSdnzHdb+D3Ko
         t8F3VclTV7wKnddGuoBkQgM5lA6HSDZfFc3LcF0UInNt0wlVv9Dn2P/bm7OANAZgm0LC
         nhGGEg4/qH8i5nYfupgYmKVb+q/zRmfO+tWe1LoMJgtaH2ajcMlJc8ep7s4Kx8zzbB1C
         DU7w3N74EOSFKIDGF90xc8SoRHi4S7P+0XrIFvqy2FEDIntP9IfuGFCaKWgMGzanNrt6
         /UzMo4JD+b7rXTYgRZi0BqkVNKdTNqi5UDI5E8sVSc316LSb7TdCa75hNfjus8L1rzdt
         a8Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773412090; x=1774016890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3DhJJ93cKQQk3SpyT61kIFsBKzCFpwnhRvsErphsARo=;
        b=liijkuK/V9mPgUjmBXv3Y89kaTFAiDn+CZGk09KUnQGQoqRWB5TLnDZ7c3x/RL+QWl
         yFTSJSwfDMS39C0IV1/2xWS2MsWi9dkQD1twzfrRKzTXhBnsn5SFhyuhJIMogc0mbjVT
         GXBF2P9BkfMvtEf/YKx2ADbSCzXFRGlxDOsr/rQnfYoboNJefFw5bTFmTKELnRv5tDuk
         OIYD7ajNdnUceIn6nxFwliY6EDfJH/ezsWWjy0tIGh2SRv0LsSrN8chxct51f/z7Rq2c
         qgi9EyPwANR281nHAempldSM3ciC8SYozgPCrdL/khAfKmCtd+3rh3dUpN5IzwCE+MGx
         iFCA==
X-Forwarded-Encrypted: i=1; AJvYcCUDXCO/P9AjargmzZtCO1+dc3WvTXB80rvV0QTGU1Qcm4rwCTA9OGaiZ3A4KZsV92/gRROji5t6Hw==@kvack.org
X-Gm-Message-State: AOJu0Yz1rwD/tbl1uvKpj4qlpHMcP8KdQ2CSnKlYTsmxogbRgVK8WOFe
	ErSiKuxvDJoF12c46bjxpoT5zZB0Qa/U4mf29JX338CE18KzBgDUA7P8MYFLAuuoPDcOOQaiDJx
	5Pv+myy6Z9eTMtb6KiFGpXxClLU7xWbq5GZf6mO2udQ==
X-Gm-Gg: ATEYQzxtLe/6Px4LnmWfuEvyp1ThqC7/B+BhjcRBvoRp9NzK2oQs+vVt7Er6HJEGfcx
	tVbPoQn6bmpGtmSRQIcWfoWx6HJwJb116+lplJeRijhWEpH6U8kEDdt5vB2/J27A60MfWcoA7Dm
	tx0OnLXIw7jyy6+5LlzI4itgWglI7ZDWgopx3Hv/hFP84t1qezUUbtB6Gke1BZ3SKmnhy3WS0IF
	owQqT7UJ3JJMxXHo53V7jUQEYw8tFSvi6JWHNIfl33ZM3uJNaIxM/Ldj9Z86XNRtJ4q4q+CdRfp
	nB8WZQfbfmPAGy3Ti6824EW2zsg0clK6rGtMNg==
X-Received: by 2002:a05:6402:35cd:b0:663:8be1:3649 with SMTP id
 4fb4d7f45d1cf-663ba9b776dmr1936388a12.3.1773412090104; Fri, 13 Mar 2026
 07:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-8-dmatlack@google.com>
 <20260226160353.6f3371bc@shazbot.org> <20260303210733.GG972761@nvidia.com>
 <CA+CK2bDADhFcMVGoJew9RoJ-DsVhYhiZJGJVwfzTBZdGX++8Ng@mail.gmail.com> <20260313122525.GB1586734@nvidia.com>
In-Reply-To: <20260313122525.GB1586734@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 13 Mar 2026 10:27:33 -0400
X-Gm-Features: AaiRm524CkK4OBTNvXFWcAvWcl42dW_YCeYpiFYkXzW17TUn9itgLI7yXbb39d4
Message-ID: <CA+CK2bD2ryZsvgono-5Yg0jwwCa-p55wefT=hn3DRsDJVc0ADg@mail.gmail.com>
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, David Matlack <dmatlack@google.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 7mm7m5fwgws3zii8zeio3wxmtcrpjonn
X-Rspamd-Queue-Id: 440B51C0010
X-Rspamd-Server: rspam03
X-HE-Tag: 1773412092-641963
X-HE-Meta: U2FsdGVkX1/g+Od2OywZGIv7CFS/g9Ou6K29iTrdoXlQq8s9yvJBBikvtVelixXLYB0ObIFxX3tw9zOgwcrJN3TsKvpZqE21T3NmxSENbpAZlzLD5DM2pfcrNdhnKkEqX2Qh6tmWqCWYJSlnoimDLGNwIKxeCGTLBQ5/NxhJ2T+RuwusrQFoqsjQ6sZUh4nY061Z4qxGNbNi5sBvbFflLNKl1wiimj72kQHLIF+8AR+whqaYetFXvRLIgSKyrGPCRimeJE6j+JhYhLDIvVYFgsttfB+hAKyLaz006hBLXHkyXihNmrfn3SOiGgtQfz1HmE7lSWkALEbFl/J0l1VwwMWpuMbMHrEOlUo5JLhdyjdDLO2lvc0lqQKa2sMwns+GQ539DLCqT53uNQwoTUMiUtygt8eVrmhb4WNkDAr0kY+cxY2W17H+eVoSzx2TARpAZzeeDbACrXsM0xL7JiUt4Wxr4mpoE3gA8joGzlX17tPi50cthxf65YgJbVfJ9898flt9bE7t9yQzoaWnC5Cys6I3lMHuSTYf8RrLo8Cku4flzbjl6SW+p02TbpISRojzB9sSWjDj75Oal+6RiZzHgd/KQZTKJukeSvio/LnRqDwPgi7OhmhjNyuoZqtb0DojYYEDqkSI70AsaWf8FCxpejy0DdYSEaeDqAZQJ83LGyIFDW214HXGZKCJb+L0qX4nVyAsHooi/yWUt4MlNaJWZSWpqJc4CZczPa+/O9bsHhgPyo7aUL8zSMaO/96veZIBb6hPG2lmKXrxfPoAegX7ZWGVetx97/YnBLy6jw/cXLEOG7/5rFVHGc1vlU/uDYYyUlWKFU5+0q3iSPFwfdZV0eidyJtnybsHOzZFMlVa9UMHyyogkacGsOSy1hibnhkchyM2rYvkEsbLB0IjOiEUi7YjV4kqJCAwnexCq8ZFRZrNFWR9M33UXDKmZCaIvVC9r2nm2VLWy/iEABcZN1n
 GRuDa+5O
 phgCsQQrf16piiLCxPbIFi15U7shY56iU30Ug8pC+Zo0kwHLUq06m+Le3Ui15/B8YXRyVYOQZtosU5DK5QTNFIhUHs72Gk8Jb4bvEbbA53s4iuwopmd4zBnFCWwzXjQOX2K65n9D5/T0uLNhUHPNucbU2ckq19XLmMLcikUFC4MXLli8agvxOUIvGBWR86h8wOHppkjPqfCB6mPqjHYuZXzECjVVXbsM299v3eccEw1LD+2WkkrLHeqgGdP6bFz+JKFUj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 8:25=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Mar 12, 2026 at 08:33:27PM -0400, Pasha Tatashin wrote:
>
> > If there are active sessions (incoming or outgoing) with preserved
> > data, how can we safely unregister while they are in-flight? It is a
> > rare condition, but since the user can cause it, they need to be
> > notified that unloading the module right now is not a good idea.
>
> IMHO blow up the kernel or something in the core code, you can't stop
> module unloading once it starts so it is pointless to propogate this

I see, I will send a separate LUO patches to make unregister functions
return void.

Pasha

>
> Jason

