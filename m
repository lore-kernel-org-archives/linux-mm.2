Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ECDBC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 16:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F7E6B0102; Tue,  4 Aug 2026 12:36:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275D86B0104; Tue,  4 Aug 2026 12:36:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C516B0108; Tue,  4 Aug 2026 12:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8A2D6B0102
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:36:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 523B0160213
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:36:24 +0000 (UTC)
X-FDA: 85064139888.19.EAB440B
Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id BE47540013
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:36:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785861382;
	b=bo44lCQ8NlIIqBW4toZdov4Yl4vDc3hdmgOmhTZie9f1YGiDlJNovWy6MvSc7bxKzzAJfq
	On9cM7RDA0i9nz9tkmAmDy7IyDhjW27oEvTxgcRTYQK5rVkSCjOFuE0goK/czCsSKO12Le
	L9AFh7drwUNFv30IZdbIHi9Q27ILtCk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785861382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rdd+u/cTIOtgUs6m9u7jQVw+oY43/nsVncY3ziic15w=;
	b=xg22B0raZi/Q1DOyLPPxjWVTVUc0ETyfKmPpYCU0FxABiO1SH6kEvyXTPDJJ9nrRY781Nl
	KfSlQRaWcko2r6t/YMTHzNwQTPprPGUxKNPEA8hSydsPhfvDClFt0AbfuGvvOnGo4nbU2e
	jvkfndQVWsRLwWONeesKMAGR+XT+Xos=
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
	by 156.147.23.51 with ESMTP; 5 Aug 2026 01:36:18 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.126 with ESMTP; 5 Aug 2026 01:36:18 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 5 Aug 2026 01:36:18 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Youngjun Park <her0gyugyu@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/swap: fix stale comment on
 swap_info_struct::cluster_info
Message-ID: <anIVAs1a0N37oba1@yjaykim-PowerEdge-T330>
References: <20260728155907.391820-1-youngjun.park@lge.com>
 <20260728155907.391820-2-youngjun.park@lge.com>
 <CAMgjq7CdpMKQCPyJxDZzYG163NNxbbnOdiyhbiXKzEh1qS-VKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7CdpMKQCPyJxDZzYG163NNxbbnOdiyhbiXKzEh1qS-VKg@mail.gmail.com>
X-Rspamd-Queue-Id: BE47540013
X-Stat-Signature: ns14kk9pn9z4jnw47oksd5zm5pbxhfpy
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785861381-341124
X-HE-Meta: U2FsdGVkX19dtqrxdJDKbliLvf1vtMKTULuCzbcJKs8eM4xVtvjZ7OVCH8MdctEfWWyhXi37ngPZbN2nvFnJIriYRLv9/a50FH/Qwm49m3DAI/QyUsdfPQp+xXHejvHwqjx6Sd2Ry++k0qbUOPdJz8ReHiWcYbQmr/EqRAB56cJ/+fc02CQBIeEfIgIM8HRMDxm1SSm5BmIJL2E7BcVQOCpeZDjAPTIEFqe2O/P2EJj48kwnhoIM7fQk9QoUDKWrIpLyK3vvDKwxJJZE/4wHe+qy7uJZ4EKeqBF2rJAFmTiorgqIhhShsAgPEOR20jFytJyTzdef3CpSFslRmnitNOxU1L/spKEqFR7fmBWw7xDtlrf64HLVgiZV+bADtdX6mLYGJfenneT3Ggu4F7SItw45W6ZutV3Vlklbp+FaVPqhg6q8MF7P+FFBoo+coSRvzF3aaiRrP6SdGGeBKyyHowfQWNHfZ3OrlfnHINuTcWO2mC9VcE8FEXIX0UgsUVE5GIwb028vn1YPURqbqD00CgKozBZm0zoxTi3Ov+pCy8BvRRyFHAoFTfMjMOU1hnT+AwbNWrikfIIdznkpSuO1URd9wRUq1wQREPEAmqwOJO/65P3MjIerrEzxGEUzUpOjzRgAt2VexSkx0ZI36LXGCEBDLwya5ZU8ZTvsaLZ9gihttP9PnXRJ+UIH9nft33cwMehWHhQlHH2CtXXpuxIBX581cJ/phj8wPo5UGb7CuubQ+IP5z332fMfqSi+hRUjPiNTNnW8ThKYbVKeFbyJNYuAuTg4b/6HP9z2fOrx3k7e9lLvUocdXM7+Sei0aE3s4gyhlMIOwSm9YcOBqjI1DC+0hzGe89KTtoqO/bFY2GA+nIO2y2QXfIxvclDmf6dblqWsrEql1lFZh9teOMVurMcJC1tZaY2fa5CeO7WFPO6J4T+ShoxatPSCTVF7pSxsw5r5xquwZRu3lw+LCoOC
 YUq/v7zL
 ILdGGmEFBMhRf/k2NSTT1RW9UNRft1ReEnfg+Sfoy8SNH21+FAS4eMoXRschsFT61dhceHtOh56RZO6dabGnL2siFfrz1RyN0gpsYsqUkPyn3mLJnvlgFj+vk4RbBIm4Tsb7qFcOpnYGv9PyfO2qlR/WO/Eh4AwiYfMDm88fCZm8dDK7JtcqcRJWz4jqu3HDjfU8nG+UO7SFQJ+1clOS8/l3LAbVTdFNPwPz0YmlhZzAmAa2S8ld/NxiJi2aF+if/N03U/NBxzj57q4Ih9R1c3+ViU6xjm6gq9MYqbweaFl6FaU/MFjqYD+nqAy9UjSPI7t8LBjpgoHuSVmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 05:48:51PM +0800, Kairui Song wrote:
> On Wed, Jul 29, 2026 at 12:43 AM Youngjun Park <her0gyugyu@gmail.com> wrote:
> >
> > From: Youngjun Park <her0gyugyu@gmail.com>
> >
> > From: Youngjun Park <youngjun.park@lge.com>
> 
> Hi Youngjun, Thanks for the patch.
> 
> Double From:? I think you want to keep the later one right?

my git config was wrong :(
fixed it locally 

> >
> > setup_swap_clusters_info() allocates cluster_info for every swap area,
> > not only for SSDs.
> >
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  include/linux/swap.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 2cb1d29307c5..e12c73891b48 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -246,7 +246,7 @@ struct swap_info_struct {
> >         struct plist_node list;         /* entry in swap_active_head */
> >         signed char     type;           /* strange name for an index */
> >         unsigned int    max;            /* size of this swap device */
> > -       struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
> > +       struct swap_cluster_info *cluster_info; /* one per cluster, on every device */
> 
> Nice catch.
> 
> Acked-by: Kairui Song <kasong@tencent.com>

