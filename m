Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFDDFE88D82
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 05:03:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BD756B0005; Sat,  4 Apr 2026 01:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06EA86B0089; Sat,  4 Apr 2026 01:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC68C6B008A; Sat,  4 Apr 2026 01:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DEA1E6B0005
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 01:03:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C035160786
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 05:03:55 +0000 (UTC)
X-FDA: 84619681230.30.BF9FF3A
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8F22040003
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 05:03:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VYh1wBbs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775279033; a=rsa-sha256;
	cv=none;
	b=v5zhnrrJNTNTAeReY1s0pKmZ2vE6n9CZWjdi+W8NIFrWIPXusdreGBi8WditP+G9FwrNQK
	vGngpLU2sxBb5buvWByBuq5tyyVtYVMKai9LpCW1gVFolELKo1udEH3v3lgTBR9DdCzM26
	uimsvwTFD4U4ewxxrMoHGJFtcz+v040=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VYh1wBbs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775279033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sfHSpbLXBsMlAl1URSV/gwiOLc9oaa/SNwCNcyDSw4o=;
	b=hFbkRoGbPhjVteR8eKGXl4ra6U3E9cKKWFsRGatuWtPk+e12E967qE3czuiWK8moXfQSCb
	0fXVPRTgvqTztSly/4yMUZCS6JZxv68AbfrxtqY/sOw+MQ8rLsLx5X6aeF5cTPD/W+G5Ah
	yTekqFXiDPcUlihjCjP/0bMLiUL8xWM=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7d9d929e27aso2258168a34.2
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 22:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775279032; x=1775883832; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfHSpbLXBsMlAl1URSV/gwiOLc9oaa/SNwCNcyDSw4o=;
        b=VYh1wBbsBMtxtitr278j0aJ3+7o4ec030jTDnYRuKSZZMI/CvDYjfvDA0fFyca6/SR
         dFFSb7jsU5+8aQ0d/qUNW7n8B10goK0PouIkcWVUQsC6LnIfBD+aR7W69NgL8l0Lp3o+
         rnXdB4bl0xqa3qryyDAR/hyc5ONxtUyTCnjjUeED2G9FsURvbgc+TvJR2SOulhdEfK8X
         cPbkWa1WvlaZTti48EEqUvzOuTm6AuE1pXSm9VrLFa4AmmaInjpAzi/EEv27sCuvOS9a
         NZT6W4FUUMongXZCcC1Dx+Pme8BIRBH3jEnaGKKxZ/mLmbxi2uN6FmmwBpJv4aVLxUzb
         u20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775279032; x=1775883832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sfHSpbLXBsMlAl1URSV/gwiOLc9oaa/SNwCNcyDSw4o=;
        b=idylskr3dbsLoyYBOLHnOykhNsz2jWQAzaZIJc8WKHIUWrvtVCWywgUkWi503hSwJA
         9R9HwYb/OQU6B7DoVJ5e7gfrykqPbCy19SILBuTQgjBKLnp7veNRJjelXHVBEHGMKm+E
         HVmqju5qAQYnNFG+87I5aU6Z4UxSj1BSVlLQWd6TcizBQZtAsZZpwSnPYoUZ+RJ17USk
         WsQhUeh8rsFFmLSiBITALBxdnkCxLITuTnGlq6+4qkfWu0XTAH9sU6Q1kzsTtKvZsWzt
         miVAbyyKQbV7OMWHyTl4fg2OlPMrZRC7aWlJQ51jmC/MSODJVK0NFee+wd6PD3OeUyek
         zk6w==
X-Forwarded-Encrypted: i=1; AJvYcCWRbO1OPIIeVXwTrfldt27kh743Fdncj5cA+L//N7N7hRWFQIXaLUfdaavvI3eTkIMFRFzKIZcgsw==@kvack.org
X-Gm-Message-State: AOJu0YwVW0OxQuAH8uwV571L6i9m4nu+ZyLEsF7bNPbXBfMi7RfxTxuI
	Ws/XnHofPGRaQGhmZ/0bi3QBzwb/m2fMUiQ0moSIDgnwX4H7E/gVtPce
X-Gm-Gg: AeBDievBZwCyKS3GRL37ZJOisJmrPcwA3u0nMBXBNhYv7fp/4AVcPevdAnwvEXpgVFv
	Pm4R4O7v4+Zrc37ts4XCPHitqVMdmUrtZMukIBqEs+RfOiKK1vVTUS9JccBe8dbfB7iBqR+dXoL
	pUJmx9HF7uviFJZ1If0zze+j/vb7+Ct456/9izYMg9BJvX4a7YSycmfIRr64GUzd6TtRNr9xzjc
	69WZXFVYCe0hv2+n4HgYLi4jWkspzM+CS8/+qltXfbeAMpjQcyVNmy1d0m0Mhe5pqG9cpsfO+NG
	1TlM1RukZsnWvwF6Mgy3eds6qH2OGMabgCLg7F8ysm8dVyI2oUB4joOU8SFnHHEf2uD+34XSTwX
	CR+ovi6iqlWF7VaNPiLH/e5mOcOaKLmAuxk2eggtZBT4msx2nmayhUe6vpXm8EphmtEYNIiaR/W
	d8k4dgkwkwdqTXwiJcCOWL2w==
X-Received: by 2002:a05:6830:6203:b0:7d9:d2b6:155c with SMTP id 46e09a7af769-7dbb6ee7f3cmr3593469a34.2.1775279032484;
        Fri, 03 Apr 2026 22:03:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dba715bd95sm5622147a34.8.2026.04.03.22.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 22:03:51 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Date: Fri,  3 Apr 2026 22:03:48 -0700
Message-ID: <20260404050348.2787292-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <adCaF0jpayWn6-FR@casper.infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: afgqqa1h1xhf9ig9qb8s9nti7mxx7pao
X-Rspamd-Queue-Id: 8F22040003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775279033-679818
X-HE-Meta: U2FsdGVkX1/xRkKB6okUJgjSvDceLKcRLrDoGeOFXrk5VM08O8iUArvA0C8zRhX15+UOODTA36yyg4HoUwCa3jqW6WB9dvEu24gfRmBPf7GuPcjS8KV/GArVSNa5tIffhqH5DjlCko04dmMl9+od8ls8fAlx5r4v6NMY/Jh2QGnCXp2sNcOlWRdCqcqsY5gYAbvEyOUa9IhORE0ntB2iWOSRJzw56j19RGZxfWXBSJijeeZ9dTrzyxlj5f6fRfknwo4LMoFcMq2mmhCu+IdOpMCLUNpD5N2W9OkXHsaSnBYqUUezCV/CpOvO/mY5a8A9RjxT7O5mAnAWJ8EJst4DBRFmtaMtQD3xooM8e8X2gmIrfDfK+g3lcywfH2wjQ2dPOivM+6/9G94jxDs9Ui9nZz2Lwk1MXYuNTs7+bEW0jEDQ6gSJYZkFOz4tcrEeNZR5m2Y4S3RcrugepAz87sTo2y+ytaLJS5Po4l3X3I83ZQS3sUnkYxrvABWfNhqWptoYAoxPXUMbFVuhT4CFwvjoFxefN8vAgdJTLc5F4dAkqRBIWt9UxS4wO6xBK9boRzI8anlJMBl7riTimE4PdqF9dT0lwpFIxlQvSS8vbxH8Lagwr9X/JTfsQqUol0m7BCu29MahfdTT2yrX2CJdUj2ZfvBNromsPs/ldtoTOOIpnPu8i6ofmMSwjMylgkIcjcQ5G39YL8R8eTmA03cj1ij+1Ma9LPpgJAs+VhJrptFRW0dyzhAg8q2M3q5eW+drJRNuGhH4BgQfNWdurNPycjAehr8vNaRSJZVqGQFv9y3XdgriLCrX6AB5dlhZeMBgNhIGanSuifLUnnAAhhCbS6nqeKloFaI9/0lkmpDoBvSRKP48+S7xxSTifypT/HfxCaVll1YSundhKbEaGuiYB4hWXvoJQmoAivf/foVwUOXmOanRKCComjV5yNNUxVH7ODwxQ9Z7lBGMrzNmtkzFwz0
 0IJsuFTH
 t2CAksirEEol4Ln8SK4fduYS+E0f0zjxqcNArHjMoNUe06zR6YNR7cZVI3VDj3dY+1BkIU+EzPihLL374aGwDWMrJ9FU3IX1yawqfOjzk5cv0cas3t++fHF9JrQkTwGF0uuAZQlHXsqH28+sebEssXPUInNSCSRVYSMvWQzUKEwQgKnKT64Wuk02yR+PBgWeUABIPUuKXJ3Ex662XGK4xzBc/n1GZRJ9g8jzMiUoN9li33Po4srgPO7dS6kbLSIoEQyYsPnyBvs4gInRNz+V8cfjOxgC00JIqIK5iLEL0P5qaSY32rlnQnrLAtz2pdIJJGSdi5LmDpay6W3ihCkHXOrfjwy/1JTbFEovSMe/Xgk5ScCDKQ5PZnWamcTVNEU5TJdd790LHfrSmkGufu52XEzBgkMxApI+e8iB8fxBz7SlB6IZXUUmyJ4JlbbdqFA19VvGVwIwWQ8qNejl3wOtRvFPUrcakeSGZ9/Ci4Z+7p+O0r/X4ZuKxrCYxmNhqgegtD94LiE/nQ8jcSsW8vGAM2uMtA5CxNhZDL6T19uHp5Xt7bF4Zos/+Ew1XIjHUUz9DT5e32cY5D9L/DgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 4 Apr 2026 05:56:55 +0100 Matthew Wilcox <willy@infradead.org> wrote:

> On Fri, Apr 03, 2026 at 08:38:43PM -0700, Joshua Hahn wrote:
> > +EXPORT_SYMBOL(mod_memcg_lruvec_state);
> 
> What module uses this symbol?

Hello Matthew, thank you for reviewing my patch!

Whoops, no module uses this symbol in this patch. I was working on a similar
patch series (accounting zswap statistics on a per-lruvec level [1]) where I did
the same thing, and needed to export this so that using it in zsmalloc
wouldn't break if zram was built as a module.

Obviously there's no need for exporting for this patch but I forgot to drop
that part when copying this over from that series. Sorry for the noise!

Thanks again for catching this. I hope you have a great day!
Joshua

[1] https://lore.kernel.org/all/20260311195153.4013476-10-joshua.hahnjy@gmail.com/

