Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DCD0CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 18:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6C506B0099; Wed, 24 Jun 2026 14:59:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1CE86B009B; Wed, 24 Jun 2026 14:59:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E73F6B009D; Wed, 24 Jun 2026 14:59:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72A416B0099
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:59:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E428F1A0443
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:59:28 +0000 (UTC)
X-FDA: 84915719616.10.08FAC60
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1921040009
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:59:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ogE0yRue;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782327567;
	b=hbTL7QqhOGGkIDMYWNrCreqWElzVMH3xoHqW9CVthiCVr2xqtpKOqt0PQoRsKN+vJWWFOB
	+Y+SdVR5WoGthXerEXUutN6Yp0j7j/vu7DBs7TOHqjAtN2v5zfj1KWNzegvSc3N58eyTkN
	oTbidOIk/FW38wzlDdEieIwK17M3yV0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782327567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pT11NgXcnMUuSA5mrycomy1NHWdVYPAjx4vn9wcSoDQ=;
	b=L6BOkFOuxEGEyCfncAqfwhyYAp3PvApgeaRgUHntRd0gMmDuJZJZhlI/EQQXawsvJloqho
	kFzfQHkZRiwui1iovDmAxo9YD8snjCqIySUutQDS8MyXETQ5s92zXSv/Ymb2icRjVT0l7z
	+hjPqt3rco0TPDyeGMaski75dEVf57U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ogE0yRue;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51a13ceb03bso16258671cf.2
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782327566; x=1782932366; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pT11NgXcnMUuSA5mrycomy1NHWdVYPAjx4vn9wcSoDQ=;
        b=ogE0yRue0ssqpn3VlgH0YgdTV96AmbXaeE3zTOOwYAud24Qln88TM4SSDhfvd0rh0i
         7BLwB7BYksuHmbQW5+iTs+aJw8i13iAjAKDMrXcDzUc89KJaX3nUdTBSNnVcTBMWwZ2/
         Sv1FNcBxMeNZoXicgnxRlONb75wK/GVt8ZxTK5h2rERGka9jOTo4rvISQQvcwgiE8m2M
         f9GViPcxgSNb07xNjoCerwvfCWryw/KDUoZ6pxAS9kaGSGHIPIf+ifn9OSnYzhghZj9p
         ucpQR7+m/RUtIcc9v7Klh5u9h3Hn52v7wGMNxQw4KlS4NagbDZ3d803JewcoSJMeD3T+
         hY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782327566; x=1782932366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pT11NgXcnMUuSA5mrycomy1NHWdVYPAjx4vn9wcSoDQ=;
        b=gbqP1RebNgYi22uQTo3cz4SRIIKKpWeK+Q/o48AqxvrSybfLCKBGeNXQ3aV/c2sawR
         GH1eZTTGE1SXTVig9tkUpl+gOKskvnS9gDNhkuUmQ4Lrn6DYNwMetSmixEeq1a2EYwTa
         LLWVrQdNfcSVxqv+CICKdUwOepdonyejNkhCVPgogL0/qwXWDJuvkpzNhAIDAKlvKeX3
         n0dV+O7pOgyU7ljtR6unWGDTaULFY7dCNbC5daNebK6n2zQqaorV5D1ARp6GcLGAUnWE
         SbivCHPMDrRScIrUskZBPqMvTXJZ0GA/jBTcFjjZ2/khRan/Ztz668z+zjSEzbPO6EZQ
         7HsA==
X-Gm-Message-State: AOJu0YzBL3DVfNjPiJ4qRrlqFh0TpgzIx6EMOUiU+xMc8g0YT1MABY4b
	eeZMVuNlEjqjAGhprMhogRiJGIzokOUfjWm+912qem7ioXX+2hBAmpLXt3cFiTDjXv8ciKAJGw5
	MwQF0
X-Gm-Gg: AfdE7cnqWMv5j7zRfgTMdOi/V+CEqIZl7bRtu41BbN5PilWELoqt8piQn53ljPjc8mw
	nroeoUVOPWF5Szl/TsmQNScEZ8jg5as+mN4jTAamxzEKaYgcyvW055n4rrE+wjV1xho67a53pCL
	lVG6gVeFoTHEGlVp5tizg/suuR4DrBBgAp0BkGHjHC3r7OJCGJ7uwecn2GZn0HyQYfg3du0mFiG
	+TdASUN5NV7V7CQlBTN8gGJihcWwQAk4ZQVbchyrURr44q/IA6B0HyBXv2+8xgTjbbs5agzVfKe
	El4TFwC7u3Wy0U9M00J+vPH76u8OYNzao1LjnFUIrWp8Va1ktqZGRK4B2PmoEBIdR2UgB1bhscC
	UZGQC77oWIvr5kbHB2TOthVzdQuMSdEmwes7zOTMcQBNTP/nlas/v8k8JDuFaA4Xd+rXeuhLnD4
	aM+FTjbhnY7keqYppKlgUAdvkO97A6YYeyN78X+GAmgPVfakbVxKam7GsLk81kxPtScWwz
X-Received: by 2002:ac8:5ac3:0:b0:519:5836:2f04 with SMTP id d75a77b69052e-51a61af8223mr67843231cf.8.1782327565960;
        Wed, 24 Jun 2026 11:59:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df7f018898sm161022456d6.7.2026.06.24.11.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 11:59:25 -0700 (PDT)
Date: Wed, 24 Jun 2026 14:59:20 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org, nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com, ira.weiny@intel.com,
	apopple@nvidia.com
Subject: Re: [PATCH v5 0/9] dax/kmem: atomic whole-device hotplug via sysfs
Message-ID: <ajwpCOSGapenRPsu@gourry-fedora-PF4VCD3F>
References: <20260624145744.3532049-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>
X-Stat-Signature: xpdy8i7z6n9mie9wmqeorn1ibwwes94j
X-Rspamd-Queue-Id: 1921040009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782327566-469508
X-HE-Meta: U2FsdGVkX18jEl9PmgCfCNmQZlH+sUHHOfRLiHJry3WtFifxcSJq24OkLUmKOVeKmGHSDSGUicfAij46JOZFdwtLWIAzpUBHxY8+/uRgNL4nA1OXEr+d44RU8vwoGYl7V0JLGstw0kv4ePTp6TDIXPnF6NJKLVsBICtegHv6kqb3mssWLzFO7Ufx6pD5F9y4YWwMr7hIPyLE1F7l/q+cnrYUMcHMfajzGjzATr4Ad9VUGimVyDNDUbeAqEIN0cPIfpVEgLob/tYAdpFL51wRPK2jnj/VRvg748UcRD1tDcqwfBtJcrvyDBnO9cMnc9ZgM4cn18PlmpdJaNIysqV8San3YuGERvbyQEEP6QlUiK35siFd6Ex6abcGH6drQZdemELHCF/ZEwi03Zqd2ucD9iNVkXStkvF5Bq2N/a3sQ2GzV5Mieq08AQLS8KqBPLsVSmOBi+e6BGsoXg5oH9wUgpF4Jsc+S5/ilqqrMUmxV1/koeJT6u8/9DLYJfCp/wZSvaMwKflTzY4I1vndeyiRQMThAP6ygpqgUkg3QgG6bZIDl03cMXFwSYj2lipJTC2IYNJ/lO6X+j2Sr/N+0py2GlmS2EhaXmZOS8PW6Pf1nUFFM0gmX8vLFJFaqPu0J17kOh4B7S3+5cC8H8wlAZ1ZwF0xasom98DIRooSZG9xwZWqDWipU9ZZR9ov8PRpIeeK7ggqN5RfNxgRBEZtjf4BKe4aMZndsSCZgJYnPT+X1Vc0R06BWcdsJPrZ+CniB0bE3F3SNT374Tl/YKUTRswXaoXSTa+57VsJZAQZdv2F0qEttVd8u6TTn66lAL+sP7T0nN22iRNCIBVE3hryb3bHvYk9empLCzM+NussHqt1/idEvry/+FGwwa31rrdh6WpoXnYWAhfMD+8K1seJvaM83NAcq8qfvflkike8n0YdPBtDOBNkfKDbHMys2BagfGCdx+XvnYn/1/SO2O8Pssh
 gnV7VFno
 exVLzKB7iJJ+1veiWpcTwxmWDIPpsmd5UXh6c+PlemUqu8/nOUUeJkf+0dBz7oh2l/rezpQIXMTvkfEDxWWYNKvtwTi7nbuMS47lri80j3NWt+jjfj2SWC6ZS/FgnMxPxN8GCJc7li7Q+2nh84byqrBrgdXobT/7ijrLGRRecA2y8Z+i28/MfBmjxjfLSxYIldo+E+EM4DaAGPgfvza84S4P+NCabWVnWRI/lFJluzegv642c4oJ0YhJ0XRoIrEVORo2gfIusSAEv6sWxRKNbfSjaJityXkSYSIy02Rd7YRg1hFBq7aX5762PxQ5D/maPMs9xjOKmJDhu91MZQhi/ejXJvM9fMDmhzq6d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 10:57:35AM -0400, Gregory Price wrote:
>... snip ...

Disregard, there are a few unaddressed Sashiko comments, I'm just going
to respin this.  Will wait until after the merge window closes for v6.

The rough shape of things should still hold w/ prior feedback.

~Gregory

