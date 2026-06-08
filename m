Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B763CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 16:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88E576B0005; Mon,  8 Jun 2026 12:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865EE6B0088; Mon,  8 Jun 2026 12:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3856B008A; Mon,  8 Jun 2026 12:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A13C6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:20:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B025A01D1
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:20:08 +0000 (UTC)
X-FDA: 84857257296.06.0A9D117
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3E1BDC0012
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:20:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=guePbd+7;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780935606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IA47/0wWSH5Jb2nhwGgbeCpI7lm8FtH32SntL7z1fRU=;
	b=WInZywNsMU7eWDhLGPFKkI26ITqwfAvt+PUsV8/64tJOpb9sFin9s68daYSGzTtlCgSAJa
	2mJeysTxhJrdVyeiMUBW5KVA168bVacvOHRPsPf4nyaHTemyWmu335HZAUauHK3cw95foa
	DAhxh96/SdX1FskHqa06ykfzlJDZIqg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=guePbd+7;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780935606;
	b=CsE3Y8TJxjXHMpHzSc+IrZzEnwiww05RcmYcefhk2/jMhs4HAqdHUknkFKOWFo/ekKvBCr
	A04w1lcqMNk7++P61WEoIEAh//9rkBE4iXNtsSYGAUD7UwrRxqjkgOdbDKtnaXa4rOUTZT
	e4Ja2IJiceLwItSlLSq0gtCvEUqqqTg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5203D408FA;
	Mon,  8 Jun 2026 16:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E541F00893;
	Mon,  8 Jun 2026 16:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780935605;
	bh=IA47/0wWSH5Jb2nhwGgbeCpI7lm8FtH32SntL7z1fRU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=guePbd+7dxvB3aFnn5nzcbye95yA/1gvUCdASLX4UMyA8zMCwxM4J9HSpZ1AO5YwI
	 IHvtuALaBhDNDBLTMtfkTpzTURKFnV5LDJJwrdq1jg5G+qFmd9uCV5WC1X4nzCP46h
	 XBlAa6lB9sOaZwRmz/KeRjSjSmhLM1R5wcoPoqP8=
Date: Mon, 8 Jun 2026 09:20:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang
 <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio
 =?ISO-8859-1?Q?P=E9rez?= <eperezma@redhat.com>, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, Matthew Brost
 <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
 <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
 <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, Alistair
 Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Chris Li <chrisl@kernel.org>, Kairui Song
 <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org, Andrea Arcangeli
 <aarcange@redhat.com>, Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH v10 02/37] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
Message-Id: <20260608092003.79da896c536a767ee6c2e495@linux-foundation.org>
In-Reply-To: <20260608094153-mutt-send-email-mst@kernel.org>
References: <cover.1780906288.git.mst@redhat.com>
	<df06b66fe4ff8e925ee0714955abc2183a727b90.1780906288.git.mst@redhat.com>
	<aiaOZoa2vSCz_0wY@lucifer>
	<20260608094153-mutt-send-email-mst@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3E1BDC0012
X-Stat-Signature: qr1owhwckhosdh8dxubybxo474fhs9bh
X-HE-Tag: 1780935606-790145
X-HE-Meta: U2FsdGVkX1/UUppEiTtUDIqTTuLXJq8aWIybjJYUZGawQqWp7oGMkNlbHwJKe+60yI8DEfWUBdIl6LAqziP+nNkRv9KxZcCICcMarYuzuAz7IM4zXXEcD53LOo+xEfb5LPDhL0V4k8T5hz91w/JeY/XzWqmoXgLH01pijXGm5/3E7ddX6WTp31ekxtH3QziYeRlXqXcpw9HAOrkpolAO+feprKyDzoBvDv8PvAripiMa8YslE0euPUrz4bdENS3JXH4rNN/cHgsrhO6VlQtupChd1ACM7XrAbuM/9mwHckfMoYEuESAeG5B+HnQ29ZTikGlBko9ImydE7k1wndjAr0tIr9JNxCGeZfkyui3qj5iVvs1IY68DPK/2JoMV686XaASCyxtsb/TuFpopevsNy6ZG8MNdVzaLU7Lrn6lLZfi4xL+zsGthJzbWVsGzIXnUVPVdJK0QmSy1GYvpXoIU/6yQ8K9HV0YKfk4Gu1lAoKT4MI+p5RpeD3j+62vnUoMbGdGLY4ZnGStsRbImKqwi3ypsqlXSxA0+H+kt5uJlwJHta+ugF+A4KOyxGF2tiB3MqeS4bt8YQBKhkHcwm6zWquMxhHOv9dFsbpV/Zyk+3WeWhfTMbk5Smc+7Nmkw+ceT+FKNKXeOway4DjxL/JeqKRKwZQqW7yhtQ+2x9c8XdmC0POTplcw8oItoQIQlS3OiHQDt6MwR9YHzASr7GSwIfMsDAv6KfIRwH6mbx+c+Wu8UfYVCKKNITcIyAGC9EnEVi1Xadj2Um/ktV5uuBEdqxAwaYbqxPEmTx/C56l399RtryubFbKAexgkYi4GlSuJtfstZqNDfGjSX+nwjzJzc8631oRsvPYYPx27QA92+9V3Gd+wVahC9RJPBaNKLgKfdglQDAmocy00wrTaFJoRj3Agrep9oU67OZhx6w5onKYa//GGvZELaN6uK098PR+mgBmE9LKIhIRZW0CkNRic
 vDPszsYm
 zz3i2Qyd9HL8NrHa8VvY7TmL00pPOEhATR4lMmcOfnVxYnOxD8bLg1fqumzZhmkwqcmqIuMiRnJoF+phiowB8Ys+dDCc8yUYdEBSTwAnWrWWi3NA9AlcoGH54OqUZAOJYncn1dHLbBRxpEjUA6Ge2TnOOLbRWMmzbaF9gTqTdy4zS9A5hp707gZBepuPn+sNs1Nd2nl45ABux3RJRbVbWO4Z+fsE4By552lVEXW2ZyqK7/LHAXjdkdTyLnSuGHP5NMzqdCUGPI/NCGbyhsuNxym5/plEFmiGpuK5Ew1owF1vuMds3H/VDuNXkNy21rDwlHPc/oiYxOi9VtzJ3Hdb6007Qw2Nm1+nBc7Up
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Jun 2026 09:48:34 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:

> > These patches seem like unrelated fixups that you've discovered along the way,
> > and don't belong as part of the already rather large series, unless I'm missing
> > something here.
> > 
> > Thanks, Lorenzo
> 
> I think you are mising that they are a dependency, not unrelated.
> For example, this issue gets worse with the patchset as there are more
> places that manipulate flags without atomics. No?
> 
> 
> You are welcome to send this to stable, but I think stable rules
> preclude theoretical bugfixes.

I agree with Lorenzo, please - let's have fixes separated out.  After
all, the rest of the series might never be merged (sorry, it happens).

Whether each fix gets a cc:stable is TBD, case-by-case - it depends on
the expected userspace impact.


