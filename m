Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB699C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 08:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799506B007B; Mon,  4 Aug 2025 04:22:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771456B0088; Mon,  4 Aug 2025 04:22:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686836B0092; Mon,  4 Aug 2025 04:22:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 590B66B007B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 04:22:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 285921DDE3D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:22:11 +0000 (UTC)
X-FDA: 83738382462.10.CA7D0F9
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5076F40011
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:22:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AGiY3W+1;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754295729;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rvd7myixX9Tdbc669Fpwy91E6A6uestbIHb9Av6+758=;
	b=8CcwdFq0ysw/3w5LgEke18T+Y49HuwuDMHfg2QyQRolPFzh7x8xYpAjp1u6nrK2BpAO5ou
	xymx4yu36pNgrE8ekuekRfD0hs1clwvfDIBb9wW3c6N+UqVxgt0KftXwWvHxpUl2n+tv3o
	lZJ9EpHRMU6RCuxaXx7u9pWvIpAYg+I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AGiY3W+1;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754295729; a=rsa-sha256;
	cv=none;
	b=GztyZZqnU4omhu0BIjICET3dfT7wc+wq83gm0i+2OkNljl0zZm00WBt+VfcgbnIMWm1xNP
	1W9XLJhrt9vjA2UU1++taqtiWpCyIHUL23rJuoCBIUnCnXoM3Ys/a9Q+upROqqWruElRQJ
	Vs2LNnTWFB7RDsc72I4YvYKKPu6CN+Q=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-af9618282a5so206185066b.2
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 01:22:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754295728; x=1754900528; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rvd7myixX9Tdbc669Fpwy91E6A6uestbIHb9Av6+758=;
        b=AGiY3W+13iRjk3umYnzUIbNzFQ+ZJie5L7i8OFLTpZfKlrY5xEiCgyuQ+fB0YMEgdp
         IEtnAEXLJB7YHQLvewzrxvl5Hf6AbCwUU5InBvysPKIMBZUZqb1iRkkaHEvHXWtq74vJ
         m/6hnm0vhRbK2pcls+oJJWUJzr7HZJjsqqt15HkHS7oeulau1qW2bGMKVbwgWAZw4bqB
         tuuupWby/b7mq1/oS21ommb8kzVzm3msTsSXg0A+8tJgnhlBAE6LTmfqdqEvNLyMb9fR
         w3JHlxXDpRnHpr0TeFiRK4Q7ZjSfzqNoviI1tiWJftjM8NZhb8N/zse8EmfL0PxnwMWZ
         n+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754295728; x=1754900528;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rvd7myixX9Tdbc669Fpwy91E6A6uestbIHb9Av6+758=;
        b=RHoN7bHI393IPj+F+kM1GKVShppO+w5b7Pab3zmhufteotxNihN2Qh409GrBui+eJh
         Ry69fWcH6XVto4m1Um3ZsMD1BswxDp1jSCjl+/TPn7BKwLJYjTc0pgCZbiGnyZeWy+TS
         hU1QP2+F5GZSQc43hmh8Fg9x28veliavqLLS9t8pXa1wMfzKw+fTsYygjYBVraAfvY8o
         qUURLI03DYqpmwsMqL4JsM2wbmDFpSOLXdaxwMbf/F3Xl6Foo2KID3jGsoel7SPB2ZV7
         SmIpUA3oVfUC3NEbU8O9ty6J/uRqw/YZVSr84wcgCR5ypAC/K3ZfnDVHRmi3FmYRDC31
         qA+g==
X-Forwarded-Encrypted: i=1; AJvYcCXcEJOlwK6JNYe6jN236dnl/tNWb32NshuvRDLV6oThfVKpwAGuCHlzJh+kB5q/h2/MbRmWYH2PyQ==@kvack.org
X-Gm-Message-State: AOJu0YxoOxPjXAvxPXUxj7JIolSUMCxYyP6Lmgh0UfiRnWyiQ6DZAb+X
	1qmmH78tnUZRSdGuudxP/4a58wj8cLDB2HsP48o6rCVsAQzAkziky1xg
X-Gm-Gg: ASbGnctWdWe8SzT5Gu64U1NZkk6B1sj+UGXahxz8KQmazbIp4u53bj+NRP/Fnou/Ocf
	pi2HCfwrCItq0CvG5ITucbndz52YLlPGJOGKOmi/MR5frtjU0L0hU4ScYGmQUpZPtvWLNTZULQC
	IyXt7INlj7pYzhAzL4I8gd0JyVUCfixKa6iLW/bAouyMk/+VRyx0G3PfpmVp2/eWVnJSAwlEiyU
	WIfWinvul7FdgLlDYczhQM0enSeeD/PBfpCgloOH9IR7FiiJqaeJsw399EcrW1GleJEEsQJslVZ
	2OtkBsc7o8TxlwgXl0MZV5enpuvylhnReavOx8PogaDbUApcMuptC+LU1pNea73CUUJIoQ/UvNU
	K6CJX9auziQzkrjES39oNWQ==
X-Google-Smtp-Source: AGHT+IFcqDL91bJ8WI7tVnisTnu/P57zfWTIch9YEy24U+3LW57zanCt6Si3JczoGVKBqIAUY63WTA==
X-Received: by 2002:a17:906:e093:b0:af9:414d:9c2 with SMTP id a640c23a62f3a-af9414d0cc1mr806271566b.3.1754295727344;
        Mon, 04 Aug 2025 01:22:07 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0765f0sm693935266b.28.2025.08.04.01.22.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Aug 2025 01:22:06 -0700 (PDT)
Date: Mon, 4 Aug 2025 08:22:06 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>, Lance Yang <ioworker0@gmail.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 4/4] mm: remove boolean output parameters from
 folio_pte_batch_ext()
Message-ID: <20250804082206.ri5roofvd32kyaya@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250702104926.212243-1-david@redhat.com>
 <20250702104926.212243-5-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250702104926.212243-5-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 5076F40011
X-Rspamd-Server: rspam06
X-Stat-Signature: 8xb4rugg8c5zm9btruofr5u5xh4jfjwk
X-HE-Tag: 1754295729-727066
X-HE-Meta: U2FsdGVkX1+8KzSgDHqXb2T/QPDN0idePdqIMZ6KhDKOQk77+TouFZlnLe1Rlw/QFQZxJZSj352tb+eF+3T6n4MVSZz7YlqMK8QF/yhM/3DuGf3Yx86itV07i+r6KX2nRcruzOB4UtO9MCfyGCNSl+3lih3cX9+2VcESiI10e4jrBupWaPjYAjWXqP9CY2i6GfwBV4bd07ZlDbZ27N25NSNRdIXAAWS9xhS18ItmGUO2oOpcF2cJUAvFN9Am9H9CbLa27dGWsQNFsiyuJ390W9g2SzMpW+sr/X/qzkl6oSRhBDE4ye5bHW2bMV6gF4l8iSKJfJ8SMK2jbrkQRDRnT0NUCRt74FwbBk3X4aIIOn7hrKuaoCm4Hsx1pshTKE7NiUYV/fiuDT2KZbFUMDkTlklkT5jFDGnrz7VYWb/tuIf7gFgvh7V4o4OOXc2yfG0fcg1KUJb+a2owGYJmrx0rTq+QVHfzCUXiPhyksF81G4OsRs8PEwKklPmJrFLomy1/MU/Ta+jj7GW26aolCH/TxNvCTlfr5D9e0Id7VAEgkJnCWa704P6LIG93NEIdXQnVJ2ltQ1pMFtuYv77qi+di5ao4Z4Oj1l34+uqzI6tzo9fag/7RgJKV93zlg6+EFG1CzbcvI/7sMKLJVD5Aw0g3LIz8QWKNkKS0JRATYmBWJJgQImG1OFiwFDVE2Fgy+ED9CR1bHvJ0WiVml67RwkTi9revU3g2n7y29k5M9zC5EDEU7AS+dhavxg7+p5KOYAM+TQrF9+e2BpI19S1/k5OJNqY+545nult0nP32MXPO76/NTY+TUC3D34idz9ihz4WGU4+lYulEJXF0GPPG00o85mvBcUax7qii3Nwmvt4nrGvJq7p7qScCImE/dY4c9z0xDHEEAWOMbk5c3QCQjIHKMu+v7ulaGiaheuwlMwUyU8NV5iteqfg/hE3dwe5ntoeRbb0JOR9ksMwgNpY/dvi
 LVERE6T/
 PoW//ayud2DLrjswX5oTxz1M3mhjzq69PvchEKTJadNBo305zcUuj4F7oISXb0mN/NdmKhmDTzlPsFBFnoHCsTX77xZ+3sUgOcNXm/VCaJw1mAIxBdTVwD5+zktOZgJlFA1OGPrF89+4pv41XDO67dcnG14jui46GJ4wexAObiF7st+DT//lFZd74m3+ZvGBOgxSNDMPmASD7tWa6wChDjq+LXtGqlgsk6lp6AUyai9ZdlWDzsfew7E8eWuvGASphQ+/u6zhzaVcN+twh0YZFuKnPV1Kobz+5acjeWGbUa9S8A95xuEnE+9Lvn6Qphw8w2vuF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nit in subject.

We have renamed the function to folio_pte_batch_flags().

Not sure it is too late.


-- 
Wei Yang
Help you, Help me

