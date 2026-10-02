Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C684CA5FE6
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 22:29:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE616B0092; Fri,  2 Oct 2026 18:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5916B0093; Fri,  2 Oct 2026 18:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB576B0095; Fri,  2 Oct 2026 18:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5A46B0092
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:29:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C19F1C0643
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 22:29:17 +0000 (UTC)
X-FDA: 85279128354.17.7818947
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2DCF1180004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 22:29:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRCVkEFu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790980156;
	b=ig8OaOvIWaLMZ1scrkN86k/LYUUzw7KdcOI3sjtYSWt6ayCrUzusKvcT6YOuZ+s0qWGoUk
	xyMWQqKWNVqYYQo133QM/tPOfVt95Ceu3BjOx1X+Cb79OA7vEsCTKeLQUP5U1ooxQZLz0Q
	5dA/X7BVfU2BqDNiChhVdl2X9ZjfRog=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lRCVkEFu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790980156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3LDJZikpkdkKQKzaoHH23Q/qctw3NfStM2vrlGtB09E=;
	b=OPRwQzhXhpKqlal9/6Mo+pammcOCaEigA0tmjH4fuUlU6vstPMCZdDDVMfs24U/fkLNhZz
	WWMNDdAMrEco0hOojY7vQeBztjLrt/RsBctwQVOwAbF8vMo6MnKkOPnk2YRmAm+/VeEOYp
	xWjc292txovZmV+JygnZpxSXh+cGl5c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 741C943859;
	Fri,  2 Oct 2026 22:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50AC71F000FF;
	Fri,  2 Oct 2026 22:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790980155;
	bh=3LDJZikpkdkKQKzaoHH23Q/qctw3NfStM2vrlGtB09E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lRCVkEFu/g3U8/pLg2nCTSt7SYCYTyH9AN7U/6z9HXSuZ+zwDWhYtk8laPi8XuFkY
	 pWkWEnrIdUo8Sm6Am7r5D92dCCpN+I+eugyDbt6trBHgZFmpDnCnuXRPmODz+OuEDl
	 wX/O7GVJHH5C4klKKhOPs2PmXsSXalAFCCCcdKW+VxhvUfUgATSCDDKqKOp154xty9
	 +mBZYh5KoXpb9fX6tm9podxVkjCQvHEeWx3gWbHPm7b5u1LrrYi2/SL0/G0F9SEyl+
	 0ZGmRcuAqO10Pmm6BMYp6elNVXm3wpkKCcca0V/ECCq+t/hPpVBQZK2XuFkyU4H/mH
	 lhdmDf/7k8UEA==
Date: Fri, 2 Oct 2026 15:29:15 -0700
From: Kees Cook <kees@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Willem de Bruijn <willemb@google.com>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v4 6/7] mm/slab: Let a bucket set handle __GFP_ACCOUNT
Message-ID: <202610021527.05F3D63AA@keescook>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-6-kees@kernel.org>
 <arJVktqS-CL7zNX0@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJVktqS-CL7zNX0@pedro-suse.tail5790ac.ts.net>
X-Rspamd-Server: rspam06
X-Stat-Signature: qtsnwbidm9nro4deoatoyybzsahkq4xe
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DCF1180004
X-HE-Tag: 1790980155-901237
X-HE-Meta: U2FsdGVkX18TRu4+orWwhjTwsWWCiFA6Epzv/Ke8mkbB0B8tVlvV8bZoRvLiwTsW/IgA1VsYBJoCojvZTTvHwv6MCQT7Xx8tkkj5oe8h43WRABMWR8tLJCq2eZieL/RSXpkhfwmtNYprcH8WO4k1CLvJCFZzO3lcJ6/ahMSg7hJD4OIS9/Jv9T7eHcNovn3uEsu2aCw6Gy16iPiRRniaKMrhMSVGMKs0Ozk97pkMtjnOBVyNNS+exi4NIC8Uj7SABSAxdGOCXuzruoJgAoEx5yii88f/+TTAW0b7H4u6qn3FXbPQcJVKJhzuuTYvDWLfqcDzptcopdLY1OqAfCz1DiGd4uxvPVZ3yxzXwco9ra7C+7JoSCVI75V7A0q5eJ3mjM3whGscWBxuyBmmMOCtUN4eOBYJCqVA1d/0aQ/DhB+UO8NBV10ZjZss7/cYXTT8+E7IYxnF/4BkKZWgaV/FpC6wVb20e6IsA66OZ6+TaLnmWfiC3bFPClsw/zuyvlhb/R94lJ/o2TVAU697/UEkvE0Hlgd6G/sAXgrd6/GuvtSg8d5pMvv2Iat9+ziyXTuH+w7BH0XNz9N6erV9jJI8SaMzS2IG+lUClzRbKSwVYXZBuopM6vteQ4GhpYGfLUfXmWgah1cKQ8peAsBEQmRc19+2XBfb+pjTr45E2jGSzGVFqCQLop0RbkI5G2XifitiAyxty48aSeI7CHfn3XbUhgcQoUoPtRfIRWKAzoefIlVHoAIy9QH8jwDMIqjl5YCElf7wK4E6oO3lQ+smCCo6zvtBFINy+3A/F8yBBXonTNuohpoO2ufJ4WNA+8JxTWFE3rhHgfzGHmuy/ojDbyozhmKXVXn8uovlhxstOAufHP8IKdYp/FtPBRupe3WPd5RLbglBW/NZfCs0ETbM8M7dDLkBn9fTKmSu52Wz+eDvmHqBccQbPghtCid5WQnFuwe0psl2ZoZSsDr1GIjrgqJ
 EwXPUHSL
 wVLXelP3u+lqVpFxz/pexa2Kb1ddvPEyFKLZZgnQqXmqR5HQAIiG4UTHVQxiXm8Xd9CXXHh87D9KQuc09Nwo/ogtOCW283wPkYUZMV92sys2u7uozvNfrRUfDxPIs3Pn5xBC2FfQ99lkjTdLRuOR3RygZaEZVfTZ0vhVhTbQfpMXpJFxq1AHUeI2IHetojKo5i6oV9X6PaF05zRhlhGzg9SB5N0UfeG44WQe1/kWnraCSAhd0zrCG6c2l9TT3HCdsSmeruGi5CYawVTwVLuDoro8epc+dTaleTP0LvjxVSiB5tPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 11:20:40AM +0100, Pedro Falcato wrote:
> On Mon, Sep 21, 2026 at 12:58:17AM -0700, Kees Cook wrote:
> > A bucket set holds one row of caches, cloned from KMALLOC_NORMAL, and an
> > allocation of any other kmalloc type falls back to the general caches.
> > Extend this to handle __GFP_ACCOUNT, so that a single bucket user can
> > isolate either GFP_KERNEL or GFP_KERNEL_ACCOUNT allocations, as is
> > needed for skb data, where AF_UNIX uses:
> > 
> > 	sk->sk_allocation = GFP_KERNEL_ACCOUNT;
> > 
> > The coverage is selected at bucket creation time:
> > 
> > 	b = kmem_buckets_create_types(name, flags, 0, INT_MAX, NULL,
> > 				      BIT(KMEM_BUCKET_NORMAL) |
> > 				      BIT(KMEM_BUCKET_CGROUP));
> > 
> > The prior kmem_buckets_create() function keeps its name and defaults
> > to only KMEM_BUCKET_NORMAL, leaving existing users as-is.
> > 
> > Only the accounted type is offered. Nothing wants a reclaimable or
> > no-obj-ext row, and of the twelve places passing GFP_DMA to an skb
> > allocator, all rare hardware: b44, b43legacy, prestera and s390 ctcm.
> 
> Well, yes, BUT I don't think silently falling back is a great option.
> I would rather things be done Properly(tm) and kmem_buckets allowing
> instantiation of most/all kmalloc cache types. Given it's security stuff,
> I would prefer being quite explicit over silent.

The types that fall back (DMA, reclaimable) are already isolated in
caches of their own, away from the normal ones, so the security goal
holds for them as-is. The one fallback that would undo the isolation,
an accounted allocation on a set made without the cgroup row, will
warn now.

-- 
Kees Cook

