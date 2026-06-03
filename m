Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 846E3CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 02:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CB3C6B0088; Tue,  2 Jun 2026 22:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A29C6B008A; Tue,  2 Jun 2026 22:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF226B008C; Tue,  2 Jun 2026 22:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4EFF36B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:50:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7E5E1201DA
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:50:56 +0000 (UTC)
X-FDA: 84837074112.11.4E6A549
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf31.hostedemail.com (Postfix) with ESMTP id 119CF20008
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 02:50:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ui7ur6mT;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780455055;
	b=Szjij8Ak/yaVfNo5Qx/jBT9YY9pDWNnecyPdsHMNv/sktF6u5kg3IF2wBNe8o3ErufgaR2
	l1cehRrdXCIKbHo16xRtI/FH4a1Vm86uMMyIJLvBTdYibDIOLs92cJm4re+sGSqGWF19er
	9YWczusTeUxMOt+9bzA4hRlXIDtVsQY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ui7ur6mT;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780455055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1IZPLWBHqvJvl4gIvSvnZxXOnDR854hRgX/CoDKx5XU=;
	b=HvxbGs0YdDJ44F3coOVWdPZl2IwT8NfCirVOawEfwK3DmAj/eWmb9oO6fBKmSLmvaVhy3x
	T+biiB/ZFouN3AumqCW+m8RmB7jNyloO+hd9jfZmboo7k6k0piUGExTqiOakPlN/MqiHB+
	zC/idimRWS4U4y+oAFiOTVU43uzFcrk=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9155183b42cso30689685a.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 19:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780455054; x=1781059854; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1IZPLWBHqvJvl4gIvSvnZxXOnDR854hRgX/CoDKx5XU=;
        b=Ui7ur6mTLMbbWYahdctFT81H99bUFcHJYl7noZIDP5Ac+Iqt4veUFsA34aGhXcLW/r
         x9n2SqY848M0dZDsEpba9flOTsOCxYvxlUzpIhJnij9/qPHPYxQsdJ8DMVizWJFFCXnR
         ItXsYIXV0NmUbUaiKolIMfSQgm18c8KCuuC0ywZ2QxMF9DiIsl3sbIM7NzR9LVctNwf9
         tLwROvXPg6mQeR8AnA5GRDbrgiGmH5RGUKmjfxsX8TbNmjkwrSYzV2pVwbgDQEITsLTC
         QRROkInyh4cCe3Qy0BGbrDKMkuq1YqabiPY1vN7RdFmoAIoQFucCX3BmLsHF46zKToER
         F5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780455054; x=1781059854;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1IZPLWBHqvJvl4gIvSvnZxXOnDR854hRgX/CoDKx5XU=;
        b=NnStP6AVTXQOfWhj/xL2fFoYh8MLpKXUEu+KwHWbtXRESmvOAvw4KStx/RmOmmzvwm
         J16NJlyGYFVJzTChc1jC8Qvtj8DwjJ/Z/iTdMNs0jahH0U0WAXZTXbwwUQ41Ausw/kr7
         1fuqsvxkmVjq5ejKSNos+V+FGZZfov5RZYJsLepcnns2vwyoorHKZ+NdjUTneZ/jZCRM
         vNcqlPvpwFTAXB4FYGGoqxEgNY2a2PiQLD33SpMuaVw/lF7yatP14xjfsZbpkfltlZkI
         Yv8hirJq9kYkEyb31Qd/jK9HX299HBUmsNmvj7/FPg4ousmsTXAKoSCadpxaSHXt9Xb5
         G5+w==
X-Forwarded-Encrypted: i=1; AFNElJ9gEdDqas+ivtbAl8kezVQ/G9gM9lD5qaatUy8Ysj8x3aQpGM4djmpr2meTcu4r25+ZwPkA2aEcEg==@kvack.org
X-Gm-Message-State: AOJu0YxVQIZgGIBT9RXK/jnUM6Rumg998IXjNMXYVmSK/wrTGphhqlfw
	1BTR57K9SO0Ba1EUcr5Tt0ycXKWeVsvxY1dcaPTgsU4myqfZzcGSxsgzp06hVFY9WEU=
X-Gm-Gg: Acq92OG2upOeJYQ8MkcTySV6tpoVUp3Cdcn4ysa6u7LT5JaJ6fQ/4uj/0Z/HP3raoDZ
	Y/GKS0IPwiTwJKwmpg6HyZ2D4WdzduUMzqC48c2B2ntXb22/iGQeEmjU2G82ekzlMoJZ1WHhxuk
	ievyb/wC5glqX33ND6mzx2Mm9zr2DCAaB5UnVyrjhCn10/4grLztVdljElCEx+tA7v0P2AsphJY
	6dS3QqyO9s2fekTIq0c9whhGpGonyVZs0TnDjQ/aVZEKWHEgvRx0StC2BtyUIprvvP1WGWWYZju
	aXlDquptaQsjZLW8iUAuit3OMN68edy9qmYQmtPuR26jnIuLhq1IZy725g57UNlf4Uhmzj9V9jS
	09rnRqL2/TePAlfn7PtURa3jCU9proHQv/PhiBrG9uq4TweDIlMZr+pzELYEFGlJ+lA3z6ZvPlC
	RBVRrX5n94DU4AjNGBSApvRG0KfJHjX+i4+MGeho18ClieM4tARd6nKkN+JEJrCw==
X-Received: by 2002:a05:620a:a2c5:20b0:915:8f64:6056 with SMTP id af79cd13be357-9158f646703mr47560885a.16.1780455054088;
        Tue, 02 Jun 2026 19:50:54 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ceccd9fc7dsm8925566d6.5.2026.06.02.19.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 19:50:53 -0700 (PDT)
Date: Wed, 3 Jun 2026 02:50:52 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	corbet@lwn.net, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v4 08/13] liveupdate: defer session block allocation and
 PA setting
Message-ID: <ah-Vp6xKSPWkuCyR@plex>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-9-pasha.tatashin@soleen.com>
 <178038801492.119771.3419366349068848854.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178038801492.119771.3419366349068848854.b4-review@b4>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 119CF20008
X-Rspam-User: 
X-Stat-Signature: kbonmigdefr4jm4btxcb731ui199nrtg
X-HE-Tag: 1780455054-271059
X-HE-Meta: U2FsdGVkX18+QFP/5XOS5cahjA1+skVYWuSCMwhggZ899iVGcpRpu9YWaxPgkz8C94Lq3nl/xVUlokdOpPJOTENkjLf+f7OLY6EhdLZ4/stlsKbL0cdtG124LxPviCbJ++PHhTPWeyrIL2AIA8xXe76IHLIOkq9AiG0WeutBH5ugJGCsoFhCCEyWx9OHx6ZyJ8eQHk3/R+rMfZzbJLl00emK6WyuLHLqCXHr4pek2eTZ3lU+YpG5/cyQwvdtyK2RBvXL0ZDFkRf2KCg/Z0lQhkZ6yY5jL7vsQNZK1OxHiNuU5Hb/VQJouUrx5hQ9VLOJa5/3jsBw4ClwYn29YAjC8Mn96RAWI0SZbEoHOMCLEIMC+PTJTN/KBvS9JZoRghaZpPwrRRp3tqklg61pKSwD2CVDTe0lX5iiKEJm3QUuiSVKtpUpikXnVQGpqmNzOm/KKCi0fZwfctbhjrU4qOosnNl2dBcv0qE2aE34lmtL8FpXytacDfFSe+t89FxF5OLgThAz76Dlhe/KYku9rPxgO9PaldCSMtgwsE89Hb1LBL6W2SHF67beGhmcT67VXekzg4fPkYletiAbJCO2g7iLT7CNaCFV6hHekiyK5MyJx3+ZWkFkXCaaPfS0lXLKVTp6j6SIACP85ubIT9jexenSyztqpJLBJL4iYTKpAhdy1RfjlR1j76AigbYrDcSBcKwaqIKZJqRB+iBu9I9Y+rhtv7BPiqOA1oBZfxVDe+P/zr+OiholZsfM9GQRPdWy9hpcDFeqe2YoCcDc1F1Rzd/0dGJhv6lHtyxdpSbEgcjGp1SnKdv7KNHp8P4ebBS5JSkXe5EGRYncXPzqmmb1ocpXf8XyniezYhtV6wLaefSMOuCmWEXtbbwcmKNV8swyjLocvsVmFpEQORaU4pFubv6kcURaDoTe/YTKnGCNHI1wxbxejbmYoellC+YOxRGh2/zBpLuwMiie6e1PQNbKW6t
 vLM97Ssj
 Yk2t0QMWVPSlLwBVEBDM85mwsTOBTYvCXQV2EN3qL2j2i1uXZiO9Tgn81Oh0CVF189glWmUxYvNyatX1rLYKn3QCztWBOvhptgWL0BnZIU5m4veokMVR1P9e+6hl8iNDz8Wkp3+RS+m8MSnaFV4l7pv0ZSEKQH2xWn0pqa5rOBFzRPrdZnIE35emEIJbbTcDWdscz4zA3INP5fMdYjTnWxtZgV7ecewxXXyRINFByaEqZUwsWCIBfysgKoPQDI7NKd4FRvwMNtq/SBWZaK+k0SJJqNS9YR2eA5zj3MQiELSW0B9MZwI81vhRQOknwOgApjCc4Mwl0d8Hn8LRPi2dT0/7wW6/g4FPPyxFIgBIE4Tgly5UpRhrYGtAFCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-02 11:13, Mike Rapoport wrote:
> On Sat, 30 May 2026 22:19:33 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> > Currently, luo_session_setup_outgoing() allocates the session block and
> 
> "liveupdate: defer session block allocation and PA setting"
> 
> PA as "Public Assistance"? ;-)
> 
> Let's spell it out.

Done

> 
> -- 
> Sincerely yours,
> Mike.
> 

