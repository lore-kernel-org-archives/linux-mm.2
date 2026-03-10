Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD66DFD4F2A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 20:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A7B6B0092; Tue, 10 Mar 2026 16:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223E66B0093; Tue, 10 Mar 2026 16:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1644F6B0095; Tue, 10 Mar 2026 16:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01A9B6B0092
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:17:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9AB96C1868
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:30 +0000 (UTC)
X-FDA: 84531263460.21.27F5509
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id F09B1100005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:17:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tqk+8Hgu;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773173849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zv0ifuUrVBHsvYG77OntcBZkutyruzbjkzFq9Mb/GNI=;
	b=Bc76KcBJ4YwClp+f/91igV54I6mL36MW565tfKqDoNNrY7HKY4ibnAheX/+RplNkmASJkd
	lCIzxSpbcNqK4dEJnlgXboqndSmyHFGU9XYpgQl2aeCJqamKRV+NsZwtWNh78mWSWIDIcJ
	KlxMixiWKViVN2MpHFzftOVCPQuLQiM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773173849; a=rsa-sha256;
	cv=none;
	b=7PVJMbKOMNrXnpKRw7Nnm0EwbOmVUu6jgGRvNzOe/EiyrX9wZJqU7uBu+UzD2uO6HQNxgE
	VDkVnQnhUcdGitDHuOje33DTRxE9MfTRsbfgQqygj3LulXZIfYfM4jYwflOkptiAWRHiK7
	vSOsb3mjYs/V+vM+MqhfLCpARZTAY6w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tqk+8Hgu;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 505B760054;
	Tue, 10 Mar 2026 20:17:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FF5C19423;
	Tue, 10 Mar 2026 20:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773173848;
	bh=QtKk1KetqJO8ddHn1s9ALjjzXPP0GPXnKoMmCBuF10k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tqk+8Hgu98kpdzc28GiDmYORtbSKwp9lglW3A6TiZzJJBSnLGGhi1BL33H+05JaeG
	 zitw78dZuBZSOun8kLU3sldmNF843SsegUIH2z4IV9WDiyGpUTxbN+lx43DfW6wBbq
	 YbcmSlPCsBgHtCjjJ/X4PdGrCh6YPqLLqSMfWdik=
Date: Tue, 10 Mar 2026 13:17:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Breno Leitao <leitao@debian.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Lance Yang
 <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Mike
 Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org,
 kernel-team@meta.com, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [PATCH v5 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Message-Id: <20260310131726.a9173c7cfa333b6522f9c8f2@linux-foundation.org>
In-Reply-To: <CAGsJ_4zUQPfrpnwcXJQUGMP_0dUW7uQpVuGr7EfNm+qPnDGLHA@mail.gmail.com>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
	<20260310-thp_logs-v5-2-686099175bf6@debian.org>
	<CAGsJ_4zUQPfrpnwcXJQUGMP_0dUW7uQpVuGr7EfNm+qPnDGLHA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: s9mxpmkaxuxt58qcdowk9857e5qj3jeg
X-Rspamd-Queue-Id: F09B1100005
X-Rspamd-Server: rspam03
X-HE-Tag: 1773173848-773003
X-HE-Meta: U2FsdGVkX1+xrHwV3wEEOfErNIDJANfA8CsTMLI+3fK44h5i575v4WIz80M76Rg5KW+eGSpSN0dcyyYiigS0PPP0tfCZT3D4+yo9GYDbFbVqMNkkaEdEQVUD/UIytZUFk0Y+2K+IZqp6Epar7/hTvzVMWZIuIKdnZcPBkSev218YlthWw2+tH2oJD5lHhH+4lw9pKRugzKxr/QyLP4p3vJjI2m0pcK5LvjM6eyjRrGShxPjv5G94d6rGb9O3tTAZgepEF0FMdsYKWkERDTGDAWdrY/I4nA4I3mjz8JUgidhYUBAPjBv39B6wIjBHVpVNUkLuju7ug02TwTlg2AtwFyDFkeCeAI5XIYWWaKkyrV423vOEv7u3C5eyDcYz+3NgXZjFxIN+Mrm6a8Ks9XwQz7v4X2SJqqKCGzNT9GYFnTFxyo6mOs328z96x+E+9fRVinx5hmgOMZChdoIgx1bFidklzPFibko65ol6kW4xeFpG6qhDix04p3FKExq/qBMQI0mlMEQD4LpSGUuN3LgQAiqdPL4RFaA7HW14d5oSSqwduwSDKrj8tctEjqLesPCe16F1draHZVeQL3nYtSYQtHJlZrooHc78cZALLAnHfA7JN3tcrcoi5lU7GGPe/W/ughyRW8wsoiWWyd7JCl6Xz7Gg9SATDs6jNxZEkSUK1O+OZ1AO8kvq4AfMnlAsbGUo2lKDypD5M6Mur7TkV6AzD7J8G0wg8sHz8vlM4GtCZZBwhIHxbcjiAUGKCUNaV24+RkjLcbFA2ez5piYzoofX8OlItIL9zMma7jo4Nk4ugZ5Wlh5joMdJYe37K8ZRGQBo7DGQYvuhytGrPEbf2BbCKb1iRzuPtFfby/rwWhPS45KMk2AyshIcD9K56gOzxDYj0u3QMRxH8pBvWDpfNza79DzcCS8Q25VyHUlIPMXzlEimxe6GwguPkn5wyJl4Sty7D72+xXBbqQOay64h69r
 Ld/28C7t
 sizmTEjcbBq6uvDFYrPUG1qqqh2+dy90s6twvCZJkMrdRzgdUi7nAQqELyx29T0lytgaCZ40mOQDO9c95TzL1xBqvh3JRcPSTKp1y0G741g2b0HKAigt6NVddXgJglBUZ6cJTIIdAjg/dxBlA+/sIxObWclTsj12RyMVvWXmu/bL12iSkJaq/c75EkuCGuVyD4oxNAY6awsoKXXg45Yqo1Il1wY8o9sCCmPLHeLj3Exel6Li6WmhZfxe21uK4oKBWfkVm9YOEnHwcBVPiMlNjeJe2dQqYItuhUi1OGNTk0mSxE8nsw1UDpghuBxlt9/vkQuJV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 04:11:36 +0800 Barry Song <21cnbao@gmail.com> wrote:

> > +static bool set_anon_enabled_mode(int order, enum anon_enabled_mode mode)
> > +{
> > +       static unsigned long *enabled_orders[] = {
> > +               &huge_anon_orders_always,
> > +               &huge_anon_orders_madvise,
> > +               &huge_anon_orders_inherit,
> > +       };
> 
> Is there a reason enabled_orders needs to be static?
> Could it instead be allocated on the stack?

Could, but then the array would be rebuilt each time the function is called.
The idea here is to save a bit of runtime cost.

