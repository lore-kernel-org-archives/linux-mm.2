Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A21C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:26:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01CCC6B008C; Wed, 29 Jul 2026 10:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE8A56B0092; Wed, 29 Jul 2026 10:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2EE6B009F; Wed, 29 Jul 2026 10:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FAE86B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:26:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 095AC805E2
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:26:46 +0000 (UTC)
X-FDA: 85042040412.11.2A034C7
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id B13F580008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:26:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZH36KbU0;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785335202;
	b=ZNqeLOc62UxLes6iQVOJpEaitqBcISfMSbwrmrLAmwIiaKDeiLAk4EWR7tSVbyCjz8VphT
	/KOvwhf1j9zxfrs926waaZc7vOjMUZBsHvEpL8Gb/JQ4bq3gEu7DmOpop3S8n05nApW2W5
	dvwOe4tu4hwMWyxAjQF8Hzjw6GuU3u0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZH36KbU0;
	spf=pass (imf30.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785335202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQ5sw2S8TC3g0HBtNAS/PmD4W872YaLT1+5/e811w7I=;
	b=NR9ljn8jj3TES7K/msywpSduKwkTSHP4zendr+08Rgnw1MRpMMUWh41lgrNiZ5os3dytJS
	kro3xwC9ySNCLBOfkzCyTYi2Qtqz7z+bamQNO0wMTGkP9fMsUwe8OB/dWoobp7CZlUXt3D
	mjlS/Rw36heaVW9IhJaVDFUWr3BSWgw=
Date: Wed, 29 Jul 2026 22:26:18 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785335197;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lQ5sw2S8TC3g0HBtNAS/PmD4W872YaLT1+5/e811w7I=;
	b=ZH36KbU0TXhYvzDJMRFthBhwpNzP6gy8d5toUvOh03i9AxaR7l5NVXBc5GIgnJEnLbou7Y
	qEIrZMkfu3UeIGNMp08k3GNdDX3Elxne6HgumLnOffUAVrB4lqksGrvkf8d7BI4d+gAPO3
	eDwjusN4E3c+LmeOx6KZvDy7gbsvRF0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, nphamcs@gmail.com,
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com,
	hannes@cmpxchg.org, yosry@kernel.org, david@kernel.org,
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/11] mm, swap: add CONFIG_XSWAP and xswap fields to
 swap_info_struct
Message-ID: <amoNilhbItzaEZfO@MiWiFi-R3L-srv>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
 <CACePvbU7ih58GHW46Wr59uUdo7wnA6c6Nd98oOdwUzi3BGF0-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbU7ih58GHW46Wr59uUdo7wnA6c6Nd98oOdwUzi3BGF0-A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B13F580008
X-Stat-Signature: z8muxdd8ps4tkbkjxgmbwm5w3ocdzjig
X-Rspam-User: 
X-HE-Tag: 1785335202-329118
X-HE-Meta: U2FsdGVkX1/pPbUNWrg83rTyW3ao2XsPVwWQcKG4ROAXVkIDYi20aqGm5H234Zz6Z/zmA50pCvZLf7uOAkk70UH9tkVp7NR+v9ZDxUCguqASwazZIFkBBpqmLWmOlhb46AHzT4H0T5nCcvo4TzU+7ogb5L30IPEAZioonL7InpvOKAGUQmJia206nA8Hkczk1jQn8jTJMeIWxRZUESStlsiZMZft5etZJNGLMdvQMnhlchLferkBez0tRhDlZaorPFaZ39TIvJnacfw5c4BKSl9rE043hk+xGna4KIi4lMnY/oU9NNTtaxHbdrrSQ/gqr8MoC6zc5L+76C+f6l+0X+DbLNj+3zTB4VCdQ0+zNmDy9PAU+ApL50+gKwVq/CRWizZBmg+ToS6KGKlNM3PK3bLOayd4jYkgNgbNN0evU94hOWBlH7SeVQZTUDpOswdg52m9Cbk7eOe2IrdqYFtJe71LaYSCjG74/zwlasYXn+5U0Bh5DrpW/1BlvMXEOCCnbPv6+5B38Of5ZdbtEBipRF5Mf5bUP/WiUw3zNOHW1+m0HEgQZFc8Ft6ts7WGsfOYFE0rGvGTiJX9IKbrAckaGTpfpQQtY/L3EVk7OaegJyA9S2gE55yfhbt5ohAv7z/0XGFOWGsar44gZ7JgMPQZ0YFAbS4P3sw+ylSlRU6aJYJYTCAiPTLzPDuBm3tM/FADB8/t6JD7MA6ga564sRPo1O/U+Utq2QQ4vDrj6+ENCyBQOFkbL1GQA32KtrbT1BH54bIzM5NygTavjq3ntoJ/4Ul/AesrI+JwWbOrvumcWYV1k7hXt91aKyp6P5LxUsvhRzty3BnMff7+gJB4cRYB6TbhcK8IxPVxsmrBQ8lC6SvJKZHM6cxJ9Gnp7/r8x8pUioGaEtpB0092qL/gcI/6T7hDreNe96ukPT2EqV4Me4AoNxzOgY3FT+JjElTB/+slGyv98Wo6abH2lubZ+X/
 ERnDJsqD
 NyxNYb0vfoRG3uaNbTnMP8g+T4wyRRYDeiGYca7/s+BV9Ah0xniTsmJ+AHNl4Ko70cFhl4L2tobjqbHG0Gte6PPkxwweO5IUatN/jiJZnEVb/Nb6RH6MUW64novbPVUUs9I9SfkPk19rVzcqb/dk6EIam0TADwCNxlZNQElV8TwrbN4esDwMXqmiE+TJVh95Zl++Aav2gA/rE/d10ErcfBnyKHOGSMipkBV2IZKyEAZ3jR7SItM82rvxMCVjhkI7224Yb6KLeE44XIGZiemWh4XX9tMslLGJ5ID5aUUUekF8GbW+gtHg1yp4qWS/qTKwr+cER
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/27/26 at 08:26am, Chris Li wrote:
> On Mon, Jul 27, 2026 at 7:05 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > Add CONFIG_XSWAP Kconfig option (depends on SWAP && 64BIT) for
> > extendable (virtual) swap device support.
> >
> > Add three fields to struct swap_info_struct under CONFIG_XSWAP:
> > - cluster_vm: the VM_SPARSE vm_struct backing the cluster_info array
> > - nr_clusters: total number of clusters in the xswap address space
> > - nr_clusters_mapped: number of clusters currently mapped (lazy grow)
> >
> > These fields enable lazy vmalloc-based dynamic cluster management
> > where the cluster_info array is backed by a sparse vmalloc area that
> > grows on demand and shrinks when clusters are freed.
> >
> > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> > ---
> >  include/linux/swap.h | 5 +++++
> >  mm/Kconfig           | 9 +++++++++
> >  2 files changed, 14 insertions(+)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 80c83dd8804f..5f6b14d30758 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -248,6 +248,11 @@ struct swap_info_struct {
> >         signed char     type;           /* strange name for an index */
> >         unsigned int    max;            /* size of this swap device */
> >         struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
> > +#ifdef CONFIG_XSWAP
> > +       struct vm_struct        *cluster_vm;    /* VM_SPARSE area for xswap dynamic cluster_info */
> > +       unsigned long           nr_clusters;    /* total cluster count for xswap */
> > +       unsigned long           nr_clusters_mapped; /* currently mapped cluster count */
> > +#endif
> 
> We might need more than one dynamic kvmalloc grow array. Maybe
> abstract this into a struct so it can be reused for arrays other than
> clusters as well. The abstraction can also include the element size so
> it can have a generic function to calculate how many pages it needs
> for N elements.

I agree in principle. I think we can pull that out as a follow-up when
the second user emerges, rather than abstracting prematurely.  


