Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E52FCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EA286B008A; Wed, 14 Oct 2026 11:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39A7B6B008C; Wed, 14 Oct 2026 11:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263256B0092; Wed, 14 Oct 2026 11:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED98B6B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:13:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7591014058F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:13:15 +0000 (UTC)
X-FDA: 85321575150.01.7003A55
Received: from fout-b3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4E9E318000E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:13:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="u Qta/om";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=OxtN50Ew;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791990793;
	b=TVydHCgj++uOaRlK7kPVVc+ZwCCIOYXMB2fGoAkSG9mg4YmNaBr/au9HytOpfDMU2pjb8T
	Fa7T1SfohWV8Z/wLDBmDYREU1wYmSDRmX7JhLJsQSymYq1mGAE+DjoQ9Xc7ar/NKWSHZXa
	Et3YP/9fhMY8ecdbroRQo/1m4aet1Is=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="u Qta/om";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=OxtN50Ew;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791990793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOpUc93gFFArBoAXhaus4seduOQibJAcMCNch1pqklg=;
	b=SbZX/aHpy8TZ2l/h2TklC7HR1t+pAD2zcuD/hGMB+o2zytFuPG3ASJy4nt6ECmMPuKo/uF
	VIpQ4BLJ9emqOqDu5wVRXJwVuqSrZM39B4Kc6mp4y0/ZThBQZwiWH12Bx65aEDF8z9WaWq
	36d4W5++cb77G0U8Bqy0UrMnxDHnkZU=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.stl.internal (Postfix) with ESMTP id 9878C1D000FE
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:13:12 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Wed, 14 Oct 2026 11:13:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1791990791; x=
	1792077191; bh=wOpUc93gFFArBoAXhaus4seduOQibJAcMCNch1pqklg=; b=u
	Qta/omLOGimjIHUEKQwfL7ovZ1Lo4R2MfYGoNM89lkMZeWaHMKy7GL1g5UqyTjbI
	mbo66i77QLZAfV3PpUG9ahmmUcu8KmnaxXoccU+oSWy76beQqEjtU5Ph5I+bYIyi
	/XsLiOP+VgLb5ZDRb0KDuweDD4JEhAlN1hTqnm2Iz99/rcku+U599ErRcNi7VLJB
	d5EhCcxfcGidc6TJf38fmp6Y2vxjz2WMRFDD1ZUuf+CP8glkRtHfIt5xkq9B8W5N
	FlNAFLz2W9OGOCr2nEuO5bfFbbmTYQ7VuET4qkr4dICA3uIhUB+3kn5BMCr3D5xH
	2fYfseBlR4WbAouF730eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791990791; x=1792077191; bh=wOpUc93gFFArBoAXhaus4seduOQibJAcMCN
	ch1pqklg=; b=OxtN50EwzPAHLrIDo+SxTurWAKMOY2VMScylMB8tMqI8HyUuzVG
	kZo04+Z/KnJeSZ3zklT3vpuhPha5g4GYCQG/C5T17xcl1y+Me9kxGkct0/I010KQ
	ZJi+UAjAg4exnfGaX15qgmxBHXeIFy1Akbx/qYdd14LZv/FJMTs2RUjiViJAOFJd
	OF7LsOWh0BRHfenivBQRo0K+8qVxQ82KWlE/F8gSQBU32V35CclON0xi9yWcTnvA
	qaQUAuqjkeRGIuerWTUzn9DboQvbMl71xyT3EfG5LcLJExVlyA+jVKzuilKRV8pW
	JSmoiazAIucv0nmcqcekkac+NqHOBcgRBvA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791990791; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:q2WALhSfnIQZxi4P9NMEADuV/aH2Ltt4gXGHZ1GTMGwQPaE
	vnGphxm5eueBlhDJpb3//LRx4d7FU5/2WdqGWSS/NktfVcV0onFv61RfNSUTqaAU
	5ZvqspzEV4WC8kKwf+2v7TcL3XoRelYGMsdkt5Q3VMQ63jaYVmtFRiM/OIkWthR2
	uHB9JdqPpYNdyNkGNfNgwZgjlH27+e3RezK+EZeblaT255tFc2/sUt8Yr2heBdlP
	q1B0Ofac0Q4Vjr7UQ7b6ApoKxh7UoDxen5XNakoIGS/QQaltBNW1oSvwBJJcSvIx
	vsDbBQVm4jUJAlrsKSmWyJm6j5cSNWOCAr3QjfQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:l7exCgdNv9j0ZInYme449tBrkRlNDP+jpQLyBNQizzU=:G60KgCAh3+4rO87ttQo4oGU0cSK3AxlL7WM4JZKqcCA=;
X-ME-Sender: <xms:BpzPagLxp0jZW1pc4QX2lC1ovBgjRCBisoidbAJQmyCY0Acu9v0p6A>
    <xme:BpzPaq_7GYtVozT03T6peLWLV67rToRejqTMAdddSqANNPp-hwx_FRUtGAszqKSDs
    aDbD4uYMQ35vzCPXCD8GDy8QXJwCfuG2TWrgm_4BbqsVw98oVxz5HQ>
X-ME-Received: <xmr:BpzPau8vqyvIR_bktSL81eFnEAJe6HFpopdo_oLBkXN70gOaxp2Nm2GKxDQ>
X-ME-Proxy-Cause: dmFkZTGOpaIiUCvzOKJYmWwXLjE5VgiI69sgmw5zefHn3fmXaEZm9155gUIeRoBxRHgim+
    ixRIflW98cI4qN3hOAjoBaFOgQR1uVMYXdKZ+fm59GlcrANLb2+KrT5qejXhIsxbQBVqak
    1xyLocSkJsK8DtQftxAbNn+72pI6QgbvPcQ7E5BcVM+MrYW/mxVTtwGxkpJBdPU9OZdPFZ
    j7vKRWCjzBkG9w+tE20g1pFuIPAhd78DzHySseDSKBy2rIghh8NJer6mAS6Tj5c43ccszP
    ggeSyQ7V/cdwJiI6FVREhq6feoXVDszLULow4fyrDr4sy3cFU/Ms4vtOPIs8OhElQk/sTm
    wIfCb4Z9fF0Zvqb++fnTIbI4LSFY72L9U8H9f0eDS9isgrlxGTsieOHp8uGHXF4yZOubLv
    NIRHaTqOdPpHbjZWewcgr4kRAZZIX/u2CQfSgLXHfT+ck/AAq3W7duqcwKIuo8gNzmbc+q
    4x0IG+l7d+LyfQIx6LpMd9z8lsHFqaYAMZbp2OCncLW/4cUCpmh+DOWFeWqK91+U12j+qu
    ITuE3dOOc4PqunrKwNv37D5SJpDCe76lw+pmkMj3Od2Y1zm7v8GEDpC4kQMU/aqVyHhiFe
    oNzPBWg3oQOV6cUd5NYqJxMtjgHJq2qU38hxfrikXYACTyMHiHgCuwZb7new
X-ME-Proxy: <xmx:BpzPas_aL-HXSm6Evglg5jCYT_Vqfbmuuym6tulxuya7o9B4bbE5sQ>
    <xmx:BpzPahKlWfzgSXDFkUL_olfi1a6lLRK6WTW4PyP-nSUzqcKu-30-rA>
    <xmx:BpzPapS_789xelULVYeqwXs2AfZZvE2AYwLqgJ4Iu8tjfcwmzZQXqA>
    <xmx:BpzPai-m-KAXgGLQZ7CGnmSbNfJbNNrEFJTouUWp-_Apo5O-uFZ1gw>
    <xmx:B5zPalhIblhyXImjNOn_4nXgCQ6sg96scz4_xXA25V2_KEep2ZytyFTS>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 11:13:10 -0400 (EDT)
Date: Wed, 14 Oct 2026 16:13:08 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v4 10/13] mm/collapse: open-code collapse_single_pmd() in
 its two callers
Message-ID: <as-WGjXRHws2f0z7@thinkstation>
References: <20260928100630.21870-1-kirill@shutemov.name>
 <20260928100630.21870-11-kirill@shutemov.name>
 <b2133cff-ce69-4a45-bf33-c44b774dee7b@kernel.org>
 <ar-nKHZ5hlbsXeFP@thinkstation>
 <dfbb4bac-0def-4e1b-87a7-91c9cd91349e@kernel.org>
 <20261013143839.832f1a4db51f801a2b95f850@linux-foundation.org>
 <3bd88620-c245-4fab-abb7-9091d9a1b649@kernel.org>
 <as9cHpbmDm2FzJai@thinkstation>
 <b5b2e72e-496a-4756-bdd9-c83c78b3da89@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5b2e72e-496a-4756-bdd9-c83c78b3da89@kernel.org>
X-Stat-Signature: cap98xy17mwhi4igptsx69decdkxtz99
X-Rspamd-Queue-Id: 4E9E318000E
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791990793-828941
X-HE-Meta: U2FsdGVkX18Zm565fnz18st3BccHdvxx11Fega3tTX3eifRdnKO9TDQS8UXyvUIWe7pB6az+6dOgsGTsUAIhk5s6RGEJ9zudmvTsYlJErj3eggDn6LKlUFQ1SFSwv2QmFnzvXXz8BK+8pRuW+fpNsQ5P9d2iY4Z9ZAw9ZgB5pEEph/rgp8GGiu8jfkizInPO3RIv4JWmJBhSy15eeQ2KORkk2W7YoTFsWkujfCroo8KnnDRXMHJFb1db1XR5dSDQuhkzLCPuJkLFnFI9loDEN0bWAMArxMou9OK3yc7pRGCHtgnWZbkH5rNjs5QTo4Yll75EjNjtfZbEmt5hRfi+XsFGAxVq8GTsjHnV0NSTsPXcA2yRrXU8sF333GTkuWZrk6SEyMRQPDd70jQzEWk/aUYpvGTXL7MftS9ho3RAggjqYahab/hCYB0wS1jM/dWFZ6fro7JdvNiIos/iVpYYICBWVTkfZ/PTliiEOlJ+NIY5n3ali2MWm2E+nYgyx51aT3utY0xm4ihrhcbSe3n3EkfalxTja5HqDVtsiG0VN462l/83O7XGkuesiMzjmlYIqtdp/gjxGw7bFg98JKojkZqTE+3PPoo2yndfBHI+4e4a6h+0UP9YhyaM5sdpL7iVu4HgzQ5TXqjkDrAU36xKBnr4jQpS1zOg2FWupXjo3Wv+7Q1dSmIsoVBAs6Y4mEhczS6+bLtE1vY5xm3OLJAJ+5tq0DVe0LRT/mBS8rN37IHM6WGDm4I8Uc/1EkEobwOhkFu2jJI2SXxMYBiXpgBcrJepdvBaQDs6uo/s4I/EFAfzDFsBcirWbARhDnZAnLx5WYG1O4IluPxpXf8LYjZyHR8XiCpqUDYYbSJnpf6aZRF588d/fv6vctOwmdZ3VQ4l3//egtqC2TrtnyX2GrvnMGUvHK39FR06V7bU0xEiaieY4T6EP6fjz5G1oZyRmd78e0DmGO155rzUyGir6yw
 FI8BVnlB
 UcxpOpDQnMTPNmr03/tzLC5LAurKNUEolPQILcYYGP78/k3TGRgMmO5WTAPph2P7EdUunaWHtDtUkuQa0Vmt8cL/jqqB/kMZiElYD4bSPDCCnO5TBQRyrERyAB7GJOe/4Wh+dGTWaa0n5sXi6eJ++EQ45tnTIrZeoeFSXoUjucaLUP0oBttWvb/9MWV4fPq4JcT40QCHAzpVPb7AF5VDQvjASlTbcrrtXiPORCjK+loY1lVSlTC5tkhPnEhHVuxiRH+dmTgFXl3TRUD7SMawEzN+gUGCIvalEvH34O86kmWALK5PknxMw6E5F8slHgQOw0GqHPTfQwdT+OesHQXw8KvU+B3jjw1O5AANr2GxWUClB8uH4CvA8hPFJEBvQrT48ZQ/vKSL6PI7vf1gwVCSKSVn2kdJLi3jD1M9VypQ1NvPpXF6vrOK1TBj78i07L2sR3wNJOeCgWCbhnWqYElmNzSU5zSULNddfZTks9Or5HSSTTpMoZC3xn3CHzJLkdr1LdxIXiM424GyPknCm2htX8VETHW735XqDNBZhRRFrIneCRHT81Z46zuC6Pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 02:37:02PM +0200, David Hildenbrand (Arm) wrote:
> On 10/14/26 12:55, Kiryl Shutsemau wrote:
> > On Wed, Oct 14, 2026 at 11:33:46AM +0200, David Hildenbrand (Arm) wrote:
> >> On 10/13/26 23:38, Andrew Morton wrote:
> >>>
> >>>
> >>> I've suggested to Kyril that we park this series until the next -rc
> >>> cycle.
> >>>
> >>> But I can bring it back - we have a couple of weeks, three if we get a
> >>> 3-week merge window.
> >>
> >> I'd say we move forward with the uncontroversial parts, and keep discussing the
> >> controversial bits. Either these make it still in this cycle or we'll simply
> >> have them for the next cycle.
> > 
> > Agreed.
> > 
> > Andrew, could you pick up 1-9 and leave 10-13 out for now?
> 
> I think #9 needs a resend, right?

Ah, my bad will spin v5.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

