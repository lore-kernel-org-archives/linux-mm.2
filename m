Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1D1DFD876E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 02:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBB9D6B00CE; Tue, 17 Mar 2026 22:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C1D6B00CF; Tue, 17 Mar 2026 22:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C345C6B00D0; Tue, 17 Mar 2026 22:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEA726B00CE
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 22:02:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 594A61A0442
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:02:38 +0000 (UTC)
X-FDA: 84557534796.12.F281681
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2DF3C180007
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 02:02:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773799356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t7kRoyWD2jj2iGJWuurHkcbJZtHttyKSBkcYsebTCQ8=;
	b=DBCv1G6B4fASuBNCUSTYydmU/zXlt+wvq+Zzkb2s2WBOPkJidnV7QfRRjvGCWN1cz7tdRm
	tYizDIAivgyddtaAxionuVvJ1CHWPn8+p8Phz0X28uNth9WylgRpGNi7qOFWR9yVF/1QA+
	86YAVWEW3of8rx2f3mVugtCbzXczH18=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773799356; a=rsa-sha256;
	cv=none;
	b=cVsl8ZymCx/fQl7QScaMLZl6W7BRkv0jq670ib+ITB90FoowVQS6EhU2wz8tGDmdbl4MTf
	OOoTJvqIeapRiRS051R1uJefHrjY/J/qG1QeIGrlLJKPgWx7+sFbnAwA396fWKPRgY/7ix
	P5IuJS+z9LUBts5myX0XvesPQXzFgT4=
X-AuditID: a67dfc5b-c45ff70000001609-95-69ba07b464b0
Date: Wed, 18 Mar 2026 11:02:23 +0900
From: Byungchul Park <byungchul@sk.com>
To: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Toke Hoiland Jorgensen <toke@redhat.com>,
	linux-kernel@vger.kernel.org, kernel_team@skhynix.com,
	harry.yoo@oracle.com, ast@kernel.org, daniel@iogearbox.net,
	davem@davemloft.net, john.fastabend@gmail.com, sdf@fomichev.me,
	saeedm@nvidia.com, leon@kernel.org, tariqt@nvidia.com,
	mbloch@nvidia.com, andrew+netdev@lunn.ch, edumazet@google.com,
	pabeni@redhat.com, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, horms@kernel.org,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	ilias.apalodimas@linaro.org, willy@infradead.org,
	brauner@kernel.org, kas@kernel.org, yuzhao@google.com,
	usamaarif642@gmail.com, baolin.wang@linux.alibaba.com,
	asml.silence@gmail.com, bpf@vger.kernel.org,
	linux-rdma@vger.kernel.org, sfr@canb.auug.org.au, dw@davidwei.uk,
	ap420073@gmail.com, dtatulea@nvidia.com
Subject: Re: [PATCH v5] mm: introduce a new page type for page pool in page
 type
Message-ID: <20260318020223.GA69943@system.software.com>
References: <20260316222901.GA59948@system.software.com>
 <20260316223113.20097-1-byungchul@sk.com>
 <ebd00055-d4aa-4612-8bf3-ef0a308512f8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebd00055-d4aa-4612-8bf3-ef0a308512f8@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0yMcRzHfZ/nued5unXb0wlf/CFnZmskxvbxY/kxP76bMfNjmQw3PfTM
	FS5Sja1oSVOd/Nh1xQolFTcX3V3UciVXbDjuPH5UhGt+heTWqeGuMf577fPj9Xn/8eFp9T3F
	OF5K2ivqk7Q6DatklJ9Cz027ztVL0W53GJSYa1ioHkiFiy9tCvDX9FBQUlWHoN//nINfDa0I
	vrXcYeFDcx+C82U+GkruZzHw3fyDBnt9D4L3xsssvG3t5qDashK6KrwM3DxipaG7wMlCXtYg
	DQ3+Xg4O2SoD4toMDh7U5Svg5I9yGqwZLzl4VF/CQmfNLwV4HXkMtJkuMfDlVAsNXfkLobV0
	NPjufkTQYrZS4Dt2hgV3UT0F1xvcHJxwlbLwOqsLgau5m4FTQzksFGfmIxgcCCh7Df0KKL7d
	yS2MIpmyzJLmj59pcu3SU4p4jMcZIje2U8Ru6uBIqWUfqa2MJLmyiyaWqqMssfQVcuSF5yZL
	nMZBhthfzSF22zeK5B3uZVeP2qicHy/qpBRRPz1mqzKh7KGX2u2PSPWeP8tkoAaci0J4LMzC
	Oe/ecn/Zn/0MBZkRJuNK85AiyKwwBcuynw5yuDAV98guKhcpeVqo5nHTwIXh5ZHCGiwXWNgg
	qwTAXk87FxxSC0aEi09m/mmE4baiN0yQaSESyz/fBUx8gMfjiz/5YDlEiMEeZ/lwiFHCJNxU
	d2f4GBb6edzY/ehP0rH4VqXMGJBg+k9r+k9r+qctRXQVUktJKYlaSTcrKiEtSUqN2rYr0YIC
	P1ZxcCjOhvoerHUggUeaUNWGWLukVmhTktMSHQjztCZcVdFSJ6lV8dq0dFG/a4t+n05MdqDx
	PKMZo5rp2x+vFnZo94o7RXG3qP/bpfiQcRlowteJ6e372wYLnLH9udYiU9+qrNkRhgXl5oOb
	l3jT4jalO2q3XF53eLrC99T8eETM9kVz9Tl7FnW4zhijY+JCIzqlwsVNmwqUtuwT2UvbG29c
	JcamlFU9T1ZXn+YTPOHLnMtnGJYaJsIVONBhvWqMnVf4SQi7Z5t3TRXt5ldErNdpmOQE7YxI
	Wp+s/Q1eK7MLXwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sa0hTYRjHec85O+e4WhyX2aGgbCGBZCVZPN0kqPA16K5YfamRJ3dIZ2wm
	WhSzxMq8VoJNC+3idTac5pxkmZrT/FAZyuniJauNTCwviVO7bFHktx/P//n/eD48LKm8L1vE
	itp4QadVx6hoOSXfvelCYA1TL66ZqgqGArOJhorJRCjpr5OBy+QkoKC8FsG46y0DvxpaEYy1
	2Gn40jyK4E7RBAkFz1Mo+G6eIsFW70QwmFdJw6fWAQYqLLugr9hBwcOLVhIGstpoyEiZJqHB
	NczA+bpSt7jawEDzzXYZvKjNlMH1qXskWA39DLyqL6Ch1/RLBo6mDArajWUUfMttIaEvcyu0
	FvrCRMcQghazlYCJ9Js0dN2oJ+BBQxcD1zoLafiQ0oegs3mAgtyZSzTkJ2cimJ50K4ezx2WQ
	/7SX2boaJ0sSjZuHvpK4puw1gbvzcigsPXpGYJuxh8GFllO4ujQAp0mdJLaUX6axZfQqg991
	P6RxW940hW3vN2Bb3RiBMy4M03t9D8s3RwkxYoKgWx1yVK4peukgTrr8Eh13blEG1MCnIS+W
	54J5V+ob5GGK8+dLzTMyD9PcCl6SXKSHfbiVvFPqJNKQnCW5CpZvnLzLeIL53H5eyrLQHlZw
	wDu6nzGeJSWXh/j868l/A2++/cZHysMkF8BLPz+7TaybF/MlP1nP2IsL4bvb7v05YgG3nG+s
	tRPZSGGc1TbOahv/twsRWY58RG1CrFqMWbdKf0KTpBUTVx2Li7Ug9xcVn53JqUPjr0KbEMci
	1VzFwUibqJSpE/RJsU2IZ0mVj6K4pVZUKqLUSacFXdwR3akYQd+EFrOUaqFiZ6RwVMlFq+OF
	E4JwUtD9SwnWa5EBVVYZgtIHd9VYic+3xxojsG5l1SFF9fYtPXPCuny3KSP0S9d2jIRrR3I3
	muLlYY+DRVOWMHjAvuNMyKgjcO21qfvZVjLuisaZtLRsaOzyXv/14akHRpy+P0LO5Ry37V/i
	bU/F0T2BoX5no/yLXct8zAv2dYxvFm5p9sz7/gT76e0qSq9RBwWQOr36NwpIYiRBAwAA
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: 2DF3C180007
X-Stat-Signature: ox78qxse3uqpte9y7ec3xf8jpugtui7e
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773799353-547278
X-HE-Meta: U2FsdGVkX1+mov6XxDnrONTZAfPA3ScycV2tpIPjxDCOA+yhJMNNCSiojnmVeoA+8hfe6AV7q9cm2esHAkWI0erF2K/59xfnIrmAMqbey3UzZlbxEEIPYbDiWzycmy5Dw+mHvXAN5vjS5qJ34KPipM9uoVCmFr7ZbCxFBD8SEgx2VbJq+FL7ZeDcbiZy1joh0LfyNvcA6icbGH0mxP8edqP6H5BEvr5mjYkUnKyZy2s4iwEgubOCHpJ44dU0BI8layT8oBuHwyC/PgRL0bSRuY6q8ClkzFCO2/bbxNR45RDg6PAxJJMKQu2mmq9zJc1t9tZDgBMysKkzCTp8OrarOtKjGS7TugYtAuVO9GW4phvkakBuQNRci8PKamIzb1zPfMa04OFfg+l9L2JfXamiRqSiuouzIkgvxHKPD0ATofevMS9laxjuTbLcssSmQaWQn6SFJozKcxXIhERn1M/HzZCgq5eDjs8H2omao9kxEaCE7HD9KWXV8975lCU5XV9hNolV7BqLTBo31fADxrAR9PoZsK9VYymP8qgs5m1sYLtnFOIAP1vP1NwaS2aMZOkJCLGoG2QDFSHrxyxtDJXY+gRPoxi/siD1axVora9rO5mrN6B4D5G1MKgFKoW466BQSp7FuyV7SRl7k8APwZvZkErduB00OftEqufze6wRJqPdesbb/x5/lDc/2XTr8LQ9nIW05mYj05wSeqLMPUCjd4ivw5gDD9hBdXKk7lF9B0vWv0r14GmmBjGy0Rbh/vhGky/QyhskiAXV1y4KwV/++O7Juv7aVizHRRMN2EQm+aRJad8t9jzJtyCGyQoxpuXRyj6kF76vZ3DfBCe+hua65LZMnEGqtoS0766luTni8qvQRHiLIstdRtjZ7+99sQb9Ryt47JW5ako+ZdsNJ8dQHGlXPZFZ8EJG74mIznOSaWNDYDx+BjoY1VQVYdNvzdsp667d2IjLXQYzJNTv7Qz
 3Ti9op3C
 LO6mRd/a+EkdmQGQizWwPk6qStB2H764EzV+ZpLRm8szbC+IVlkBXZ6rxFn2o1XRUjBGb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 10:20:08AM +0100, Jesper Dangaard Brouer wrote:
> On 16/03/2026 23.31, Byungchul Park wrote:
> > Currently, the condition 'page->pp_magic == PP_SIGNATURE' is used to
> > determine if a page belongs to a page pool.  However, with the planned
> > removal of @pp_magic, we should instead leverage the page_type in struct
> > page, such as PGTY_netpp, for this purpose.
> > 
> > Introduce and use the page type APIs e.g. PageNetpp(), __SetPageNetpp(),
> > and __ClearPageNetpp() instead, and remove the existing APIs accessing
> > @pp_magic e.g. page_pool_page_is_pp(), netmem_or_pp_magic(), and
> > netmem_clear_pp_magic().
> > 
> > Plus, add @page_type to struct net_iov at the same offset as struct page
> > so as to use the page_type APIs for struct net_iov as well.  While at it,
> > reorder @type and @owner in struct net_iov to avoid a hole and
> > increasing the struct size.
> > 
> > This work was inspired by the following link:
> > 
> >    https://lore.kernel.org/all/582f41c0-2742-4400-9c81-0d46bf4e8314@gmail.com/
> > 
> > While at it, move the sanity check for page pool to on the free path.
> > 
> [...]
> see below
> 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 9f2fe46ff69a1..ee81f5c67c18f 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1044,7 +1044,6 @@ static inline bool page_expected_state(struct page *page,
> >   #ifdef CONFIG_MEMCG
> >                       page->memcg_data |
> >   #endif
> > -                     page_pool_page_is_pp(page) |
> >                       (page->flags.f & check_flags)))
> >               return false;
> > 
> > @@ -1071,8 +1070,6 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
> >       if (unlikely(page->memcg_data))
> >               bad_reason = "page still charged to cgroup";
> >   #endif
> > -     if (unlikely(page_pool_page_is_pp(page)))
> > -             bad_reason = "page_pool leak";
> >       return bad_reason;
> >   }
> > 
> > @@ -1381,9 +1378,17 @@ __always_inline bool __free_pages_prepare(struct page *page,
> >               mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
> >               folio->mapping = NULL;
> >       }
> > -     if (unlikely(page_has_type(page)))
> > +     if (unlikely(page_has_type(page))) {
> > +             /* networking expects to clear its page type before releasing */
> > +             if (is_check_pages_enabled()) {
> > +                     if (unlikely(PageNetpp(page))) {
> > +                             bad_page(page, "page_pool leak");
> > +                             return false;
> > +                     }
> > +             }
> >               /* Reset the page_type (which overlays _mapcount) */
> >               page->page_type = UINT_MAX;
> > +     }
> 
> I need some opinions here.  When CONFIG_DEBUG_VM is enabled we get help
> finding (hard to find) page_pool leaks and mark the page as bad.
> 
> When CONFIG_DEBUG_VM is disabled we silently "allow" leaking.
> Should we handle this more gracefully here? (release pp resources)
> 
> Allowing the page to be reused at this point, when a page_pool instance
> is known to track life-time and (likely) have the page DMA mapped, seems
> problematic to me.  Code only clears page->page_type, but IIRC Toke
> added DMA tracking in other fields (plus xarray internally).
> 
> I was going to suggest to simply re-export page_pool_release_page() that
> was hidden by 535b9c61bdef ("net: page_pool: hide
> page_pool_release_page()"), but that functionality was lost in
> 07e0c7d3179d ("net: page_pool: merge page_pool_release_page() with
> page_pool_return_page()"). (Cc Jakub/Kuba for that choice).
> Simply page_pool_release_page(page->pp, page).
> 
> Opinions?

This is not an issue related to this patch but it's worth discussing. :)

Not only page pool state but any bad states checks are also skipped with
is_check_pages_enabled() off, which means they are going to be
suppressed with the off.

It is necessary to first clarify whether the action was intentional or
not.  According to the answer, we can discuss what to do better. :)

	Byungchul
> 
> --Jesper

