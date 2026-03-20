Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692F5109193D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1D0D6B035E; Fri, 20 Mar 2026 05:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD436B035F; Fri, 20 Mar 2026 05:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BBE36B0363; Fri, 20 Mar 2026 05:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8664D6B035E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:32:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 355431BD3E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:32:46 +0000 (UTC)
X-FDA: 84565926732.01.AAF9AE3
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 278F2140003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:32:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y1+loh9Y;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773999164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OM7qYlf9HKURWz/+a3T3Y3rxMadnxIAJ8Nie9c0bxzE=;
	b=bF7EhCEp0gef+NNqg+bTiMSTbsoX1gC4i7Lp16/0bfWxf44kLs2eb53Nt6NaE8Qa+vIvnv
	t7b554qkDhgUVSn7+7zDCDWTauBcTlsjrpCYv18HTwYMmngrbrRkjuctj0OCmqmWsl358y
	ArE8po7Zuw4cYxDlQvAViaINO64qodU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773999164; a=rsa-sha256;
	cv=none;
	b=DqdeIGBmdL0IvQL0gpub2L8xedXMKAFfTdjvfPO1x2RjJYLDKOI9hUp/icb6m+257KmL6N
	RZBB6sQ9CDUahm/+6KbdiF8p0Wd2HuRdBmrt5gacNYxDYfowivc01rCKyTiwza0U86veAI
	WKdBD1bsN4SiihSw4vNE9vYip4yKAFg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y1+loh9Y;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf23.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-439c9bdc1eeso1558653f8f.3
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773999162; x=1774603962; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OM7qYlf9HKURWz/+a3T3Y3rxMadnxIAJ8Nie9c0bxzE=;
        b=Y1+loh9YtCctbLA45SzUAVn5s4KOKtKeRdWJTT/qzKp8OclbcREmTzlr2eVkqJCZmq
         IGjSrJGxM2ir2BGLAV96kSSwhbMwGI8xGjox2ZL0uPnX1hLbM49f0XfgUAVOimCxygEv
         PdChlujztEysQhW16pKcm+VHiynqMDbVsMzZAwC3hgqD4X4Xtb6F1uFrPpQMxX7xs1/4
         CGhjK/4xERCxq2wUuoYrIMhrxu+el+GBDDuhnoGcUNiFDkU90YNcZov41HiZes9UV22W
         1xS1Bmt4Fb2VvtQ+4vjRbCmvhFclPm/TMboIjOYx8ZAsjxMF4H4n+rR1OnIFpcIc3OXm
         vjBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773999162; x=1774603962;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OM7qYlf9HKURWz/+a3T3Y3rxMadnxIAJ8Nie9c0bxzE=;
        b=exLuSe1WagyTzAy9mzYfFj2I5G1HzIFrfo9M3aFAM/bNaxK6ug+Qq/VzgCSdM8x2rb
         S/Z9zwUkb6wWlcqOHZSZBqmRz0wLERSbBzMrEgorskbtPbzfXrJWEc/phBQRvrIzPG56
         g2DKV5+4aA2EPzjZyNP9nUjnb+6UElLtUZmwpmi5I1sl03FoW0J0EuEPzqfkck5oF1QB
         8khN25V1Mijvw86HDms04rTW2p+Gu16ZOwMlk3DY3HOzhvWSnY+NLeY0oAVx6BEmA1+N
         0gl0L6WgebLzPK0aKLgseaHRc9O5mvL29Z+LPbFf2B0qOs16zwKE7sgX02gU0nAqi79P
         Z3MQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnx0fSvbTmlUS9G7wqHr+dUqPJwU2oy5OV8k+Lmcpsz3G7aMLQifRZ5KZAJ9xhEKhWYi2VouF16Q==@kvack.org
X-Gm-Message-State: AOJu0YyhG78VwD+8gmZPZ5FHPUDvQSsUvGZ0k0dY83Wvk5aur9wSkNJT
	ehGepgrRjjcILpibvHNpxhkouh/N1huiUtTO04VWlzuQCJRvioaywZ+iwsY6gvP75y8=
X-Gm-Gg: ATEYQzyrgczOKeGHTWJmgp+nDuJgDHxK/iSN240TLiozJ5K5HcRoNMzKk98BNWTPXnP
	4qyKindeeOgegY4axW8H0NLSViO6rb7cPiDYE97mwhzBBgGb2LGq3u7r9q0mY6OyNZVNmrBXzYM
	vxrYL8N5520UqWZTYYb8M2y02XSWfbERCIVDjEP+pBTlCQZ2GB4eGzTGOGv5e8iat5GCweotnro
	Scx+rt81r/XYz0XCN2Wdo/8nH+uDr78aOZRGEPm8pdrDFeLlYZG+SXE/bg4s4MHqlHwgzt4J34H
	92/TS65kuSSS/2WTTGJKmsPWQrn1dp1vGErViI8+AtQC+oV+dx62yUFJCTUMkd0K8vyyNW7wRf3
	cxzv4O07Di4DjcjIeJUPrdw8GwtZtJ5lRCcs+B/YTPIT/a9uAN2BPxJ0B5QjphaCZ8FGOYP9dDC
	5gKTf84g0y2KJaqhxgrQfliVhTBNxNa1sH1w==
X-Received: by 2002:a05:6000:608:b0:439:fdd5:10b5 with SMTP id ffacd0b85a97d-43b6426d710mr4221954f8f.39.1773999162404;
        Fri, 20 Mar 2026 02:32:42 -0700 (PDT)
Received: from localhost (109-81-88-11.rct.o2.cz. [109.81.88.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b64703c27sm5170510f8f.18.2026.03.20.02.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 02:32:41 -0700 (PDT)
Date: Fri, 20 Mar 2026 10:32:40 +0100
From: Michal Hocko <mhocko@suse.com>
To: Bing Jiao <bingjiao@google.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org,
	bhe@redhat.com, cgroups@vger.kernel.org, chrisl@kernel.org,
	david@kernel.org, hannes@cmpxchg.org, joshua.hahnjy@gmail.com,
	kasong@tencent.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, muchun.song@linux.dev,
	nphamcs@gmail.com, rientjes@google.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com,
	weixugc@google.com, yosry@kernel.org, youngjun.park@lge.com,
	yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v3] mm/memcontrol: fix reclaim_options leak in
 try_charge_memcg()
Message-ID: <ab0UOCqHmZG3hcJ2@tiehlicka>
References: <20260318215629.2849052-1-bingjiao@google.com>
 <20260318221957.2979346-1-bingjiao@google.com>
 <abvB65BYCUDT9JF1@tiehlicka>
 <abzBfHzRndwjrGQY@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abzBfHzRndwjrGQY@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 278F2140003
X-Stat-Signature: xbt3k71jokggk1kne99zg8f7rp9iz73d
X-Rspam-User: 
X-HE-Tag: 1773999163-279503
X-HE-Meta: U2FsdGVkX18hAgLqWb888dTrdCZNJQ3HnjPp/tBm5OC/E44WW6cMGtpgUzwkvsCNNL0PX1gCymMuIAgqiMMJ+lyIkc1AtEIGGVvvgPRIkkNndUd02xUsXKIBOQYlEKdFrnKeQAha0ArHaVgD19H+Cp7CSrG2M5EsnKCXziUWdVElybF5bu74F7Rq67jw7lv+VEKKNNt+6HuiVuBqeL/2mE93moN3sRCvzQ5lAUZ1xfHNQVtn7aXmJgIVQaELsjcRz9LrDxCeL5IIy0x+LYoVSCFhohCUB664p1MNv5WTi7Z6G+gyMbK1VGo6e8lNqsPpIiF06U3uI/QZklPFKN0/qPCoTd7GjGH2kdeYrRVMWIFyXJw/eAv+mD+dn6WplRK3zSCNDlyxq0zwfajW+7RJFugDBbU4AiBgJma3eNWX7csUFnE4ehbDoxiFZ9uIi/bQZ0A6l8JaAbXE5x0sobXJM4FOFosYKucFNY8vIz8vxm+lT1fGTWRCBy/LPoRGgJQoOH3b1WMCM5WYAOTbBZ98IBW23Qmbv6/igug5AdUPV3UIVObv4EHozl7aFhm8+kj47S/dvKDM1wOn94/zxNdgEWXWfmSAT6nvPAldnRD4LeqW/h4b7GOfRxv4PQMcpPag+zsB997T40Rjd+QpGgQTY3cyTkIBd4K4EhGoSGMaEYDfTG6S3/pERoGtBzxPsqJe4G+sph9IpF/uR8t/9XsYT336EcS6o8REudbDH2WbD2pnWtxiW+KNdByVhJsPWVtlO+TqXngjBn1Q2nYRGivcLCBV8WOcfcy686HZZSZ7MLoJhs4rQhsHh128rS4BvabLfzQZZKUZ2AdnHVTUL9wZfCVAFdjgceOiEp1BkgLPvGXloBXBsI+Wop95BOZtJd64HZqe7rq9+PY6Imr0hBD17DcwyqnKlKByYFFAMPAl3/HdSGWOWNmqFdcqL4CZdmrOwY5UMXFtG5RsBwAXipL
 v8d91V4Q
 BsFgf7bYnXgLUO9m20TIfqgMdzpBwOo9NLXTZvNw3ZXUoze3+eVjyOX3mJg0nxl3wmwXEuzOPS2bvTQ6kan7OKMQocxQMIpZp6NpCvWmCSNcSUDF8zPuEt5Iuxf85oa9axVXIf9m/150UhMdZpqGi93CP2MZ8hI0uh4T9Vo9YjYCKVZeoYdv4vlx1gjwUVz5nQbIKDMI8ZaJD+QOIBBGP3+X0MLeaQy7zGgdbXkdVbe9KuMaB6Eqer5QBPmMD2OySYQkXDih2Ay1bwIrvOwPpFPGnUG+2DRKr5WY8kWVhFCIeh8gRwDqYvyNtzD9r3vt+YkD5pMx5GxU1Pr8oP1cwKLKo8UP+zXolTEsno7idaS/G3YgCJjs85AbGDfrmOE3H2KCHX2DmAJ0ID99LcTxNNg0p1Oh/4wcTrYUheyUA7OBlXg79GIGPYpvKihW0yDkgymbOQUzAfVieo44TlmEZ+1iZBQ6u8xHo+5Ti
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 20-03-26 03:39:40, Bing Jiao wrote:
> On Thu, Mar 19, 2026 at 10:29:15AM +0100, Michal Hocko wrote:
> > On Wed 18-03-26 22:19:46, Bing Jiao wrote:
> > > In try_charge_memcg(), the 'reclaim_options' variable is initialized
> > > once at the start of the function. However, the function contains a
> > > retry loop. If reclaim_options were modified during an iteration
> > > (e.g., by encountering a memsw limit), the modified state would
> > > persist into subsequent retries.
> > >
> > > This leads to incorrect reclaim behavior. Specifically,
> > > MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit
> > > is reached. After reclaimation attemps, a subsequent retry may
> > > successfully charge memcg->memsw but fail on the memcg->memory charge.
> > > In this case, swapping should be permitted, but the carried-over state
> > > prevents it.
> >
> > Have you noticed this happening in practice or is this based on the code
> > reading?
> 
> Hi, Michal, thanks for the ack.
> 
> This issue was identified during code reading, when I was analyzing
> the memsw limit behavior in try_charge_memcg(); specifically how
> retries are handled when demotion is disabled (the demotion patch
> itself was dropped).

OK, that is always good to clarify in the changelog.
-- 
Michal Hocko
SUSE Labs

