Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A1ECCAC5AE
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 00:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E8998E0010; Wed, 24 Sep 2025 20:24:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0EE8E0001; Wed, 24 Sep 2025 20:24:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6798E0010; Wed, 24 Sep 2025 20:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F65E8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:24:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B75613A212
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:24:54 +0000 (UTC)
X-FDA: 83925877308.12.DDE1CBA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 11AB4100002
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:24:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ENzOOanf;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758759892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpofaZWQ5RtfiDXbeMNhBoeM3aRtu/ICZXyFnK7SNdw=;
	b=lR0zuFg2HhfVxVqz/JZvWHs+VHthg+PO1Dxa3BdMFVP/ZW78ywfGc58kH3xz1PTcgSN9k0
	9xRAonVDi3oA4n3laEJPrELJZ+iKJvmgreYiccXtVFhbHVOpgCkeJXAJ4RIMrv3DiXw9oM
	6sDh3vLvdsItkkdpc1Ki/AyAhTRE+1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758759892; a=rsa-sha256;
	cv=none;
	b=0KU2yhAQ47PquxmM+rwpmyw8RXBRjMUDSq39TsE2EUO2jKjjxE7gJg/d7KbIFhWBZNQYt3
	wu7Mv/NmlFQO3xmX8jklWOifTN257TCADWCY51TjbQxwE92EDaQhs0HDC3rUy/VWS8y5Zk
	Dq43oul7DJYBC0FIuW8KGJP5Z3mEsqI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ENzOOanf;
	spf=pass (imf14.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758759891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MpofaZWQ5RtfiDXbeMNhBoeM3aRtu/ICZXyFnK7SNdw=;
	b=ENzOOanfLOBFeuA3l/sHyypU+Ll/mIQwQ7I+wAJebSsLpvrE+ff9pNfHyQBmcPvMV8Q1/O
	c1cT3+Q2/hYMVS5p2SacXAEGlKndyz2lOfW9qxm2QNQCEo3xnmOXZ5TrHsHlAuFp+gsvSd
	8tIvB1Jmv8YAVf5+VzI4ubYPG2dKCJI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-v7QXCbceN8mKkv-eXC8CJw-1; Wed,
 24 Sep 2025 20:24:48 -0400
X-MC-Unique: v7QXCbceN8mKkv-eXC8CJw-1
X-Mimecast-MFC-AGG-ID: v7QXCbceN8mKkv-eXC8CJw_1758759886
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 288BB19560B7;
	Thu, 25 Sep 2025 00:24:46 +0000 (UTC)
Received: from localhost (unknown [10.72.112.12])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F8A71955F19;
	Thu, 25 Sep 2025 00:24:44 +0000 (UTC)
Date: Thu, 25 Sep 2025 08:24:40 +0800
From: Baoquan He <bhe@redhat.com>
To: YoungJun Park <youngjun.park@lge.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, baohua@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
Message-ID: <aNSLyF9euWstYpYu@MiWiFi-R3L-srv>
References: <20250924091746.146461-1-bhe@redhat.com>
 <aNQdpCgC6PDLegr5@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
In-Reply-To: <aNQdpCgC6PDLegr5@yjaykim-PowerEdge-T330>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eOM5SL_l1J7NBxcH0e4vw4eV_vY-7D8Ft8f7Clvc6j0_1758759886
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 11AB4100002
X-Stat-Signature: wtsuy44c6wthn5ma1tkffpfgpnhhxt4n
X-Rspam-User: 
X-HE-Tag: 1758759891-455395
X-HE-Meta: U2FsdGVkX19bliiB4f1nRGp838U9WRLiB2FB3XZ+b6LLHKIfBSEsXCHZGE7CS4iS5qFJsiHRH+KuS9cvIMxy3IGbDGJ7nDu52jrD6JPjETwER7TEyFy29SZroRATZ6/hV29M+syGqzbklqXJH89oObrfHUQi3BQpll62dgqSKenIcMARW1IsVw7xzXpvFiQsw2dkZM2KvhKn9xWphZ6ZO1QdS3lH/fbR5KgVUhYcUsgan282cOZ8lrPUBokhhmuwKy3rmOQrLFITePhUxj7kTcUtxEUIb+oU5VEMAR8ZsnOKUKEhSiI4eGwA87Am40eVR6wWksBwsO5KhQzcopuSAMUyz+jBKFNZemDc1ywo6gx3Un8DYixdOC9uvLmNLIenZvD+WEkN5OujCZ9sL3ccuyY2ph2LAwK5hWUx+MtMY96oaV/VOfZvdpT8KLqNUHgaKUnnMTLIyzsKihosz6IjOuv7bPStSif3sIM4DiofQlp0Ir+YGzqoA02Nr9xvcHBM9auoJAWpV96Hv5ivaqYH7rZnoQGx2ZsCJyCrowIyIkCBxLlzGEyr5Fwk75FbzWuCOcK8x39P8ZRJ54rALtCxs01yL/mp3+4mW96H8AzaK1ODn68bAAzqLjYUZpQpawtPvJyZ5MX/sV5ggO5gYFhzdKnDamlS/8H3fedAbTGbn4Ug1D+od+OrCtYCn8JnP0yLs/lwVjsPe3H5HB94XlEtSr8P8KM0/K9VefFVddA/r6FEJm4bFWZ6ihiEktDWPm9NWb5vEdxzOZcf2v6y0Z8g4YFj4vORGR9hFlwOBZ4IwCGFUqHPLWvlKZm2ZafrK54baweJRMGwXllkXS4k0kA8zjApQSzFNmTbPlWjR5yiGpVkt9NuT+sdAR6o9aGwPQgofzAz8ejQtT5nMOHTorsy5vUuGKAIhRpsLGVKhjHV3Noht6TOC30p+Us5O9W+6bwn+ykYTTUah+W/Vwvkp0V
 wvWleFDe
 8x3rdusbvf7Rf5e5pfmD1uFdoL54f6QVGtCjDBgXcRy+Py+PtrQh4yNjAyBUZDnXpvdAPxnZsNZ0z1n3hxSwp5O1YeylIk606BRMNmvcnS2OxX2yDjBzm8dH1Ini1kgG9l6tHr3KWMJKNsdem9NF3P9V+EVl4qkHWSUClQqL+l2fMYL+Sza9fpuFF6rgeFK5DnwSa3BPQafh/JVXmolWiQS5Aw3AFUr2aSwSkt36XjQpFpGLcESQvKqP/Up/o8q5L7ADfivMfpixnDitWCPXfk9+CGTrzZ9ukI/tyD8OLRao6QNZFcp3K8H1YAtjojoG1yHegS5wb0PFxLKgeoWLlOEbg0Y+beayaNaciYHFbLkezK5BP7bSyWEMyyOfeiPbksrNmZA4IP87zIQTwPaMZeAyuaIkOzOrM4kfnmafdjSejOvaC3XmeSBZkf9M7QJQMrJxvgRTzIIIQ5R0+R4beAf/qW0Zk5fdbdwSD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/25/25 at 01:34am, YoungJun Park wrote:
> On Wed, Sep 24, 2025 at 05:17:46PM +0800, Baoquan He wrote:
> > -	int i;
> > -
> > -	if (prio >= 0)
> > -		si->prio = prio;
> > -	else
> > -		si->prio = --least_priority;
> > +	si->prio = prio;
> 
> 
> > -     if (p->prio < 0) {
> > -             struct swap_info_struct *si = p;
> > -             int nid;
> > -
> > -             plist_for_each_entry_continue(si, &swap_active_head, list) {
> > -                     si->prio++;
> > -                     si->list.prio--;
> > -                     for_each_node(nid) {
> > -                             if (si->avail_lists[nid].prio != 1)
> > -                                     si->avail_lists[nid].prio--;
> > -                     }
> > -             }
> > -             least_priority++;
> > -     }
>  
> Hi Baoquan He,
> 
> I noticed that in `_enable_swap_info()` there is still a comment describing
> the behavior that this patch removes(auto assigning priority). 
> Shouldn’t that part also be updated accordingly?

You are right, this need be updated. Will change in v2. Thanks a lot for
careful reviewing.

> 
> static void _enable_swap_info(struct swap_info_struct *si)
> {
>         ...
>         /*
>          * both lists are plists, and thus priority ordered.
>          * swap_active_head needs to be priority ordered for swapoff(),
>          * which on removal of any swap_info_struct with an auto-assigned
>          * (i.e. negative) priority increments the auto-assigned priority
>          * of any lower-priority swap_info_structs.
>          * swap_avail_head needs to be priority ordered for folio_alloc_swap(),
>          * which allocates swap pages from the highest available priority
>          * swap_info_struct.
>          */
> 
> Best regards,
> Youngjun Park
> 


