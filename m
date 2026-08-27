Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D53C5DF97
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 00:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75B06B008C; Wed, 26 Aug 2026 20:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEF06B0092; Wed, 26 Aug 2026 20:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0956B0095; Wed, 26 Aug 2026 20:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC726B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 20:46:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 21FD980273
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:46:51 +0000 (UTC)
X-FDA: 85145209422.19.F34427B
Received: from mta0.migadu.com (out-248.mta0.migadu.com [91.218.175.248])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA4D020002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 00:46:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UtfBXtF+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787791609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jP3kOAvE7hRjDCGYvFMzJvM1PhI7iWnLQlK+z2nBuXE=;
	b=BkOMYcsSMIuWvb4KbC8FTGqEvrCfQHovOafPNlGvkrH496vxR87+ggqv+a4UVNdCY9N/Fp
	oJZXq+SkJzUl+rKy6WQEIioFwUsIti6ZmJNhD8UB4frcNgLFHqwEo+mHkOu4CRcJQzNM7G
	bJCtLTzbHF3hLYR5vCc8fyBW6TJkTkY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UtfBXtF+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.248 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787791609;
	b=SxgvnHhU1NSpylarcplnsEAwXggo3GWMh6e6n7WbrMmQ1zjxSZqNGxUxhBesAKPh+WY+9M
	nOYdHYwcPCUVccZoso976/SEpDQjj7OjX1eRUvtW4Feuy2a9XnNxNzQojhpaVSlosfWR6X
	/fJyeYMdI3UDa3z9SwrITauovb4HNdw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4zf7+mPWPGCfOdkH9jTVWkCuXpWtEtW+l62A+47KE0E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787791606; v=1; x=1788396406;
 b=UtfBXtF+ICdzer1z1jeDjTM4ZX7wu+76i3X9lyWtYNcRZTnZeI3T41NviQXsaTmCgEZy/nym
 aAeZRzHqLkwtGn4apkv1htI3w0oEmXZjbhgl+IVIMTC4DfuFpqsl2SMnDLqpftarPPEtI8PHUq/
 vR/OkHwBZ4bAss6RTF2rreq4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 49c01e81593a4588;
	Thu, 27 Aug 2026 00:46:46 +0000
X-Mizu-Trace-ID: 49c01e81593a4588
X-Migadu-Flow: FLOW_OUT
Date: Thu, 27 Aug 2026 08:46:42 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com,
	zhangbo56@xiaomi.com
Subject: Re: [PATCH 3/6] mm/mglru: enhance cold/hot inversion handling in
 inc_min_seq()
Message-ID: <ao-I8rYv_G5j4wz4@MiWiFi-R3L-srv>
References: <20260821102538.22642-1-baohua@kernel.org>
 <20260821102538.22642-4-baohua@kernel.org>
 <ao6qTTtk2xkkeKob@fedora>
 <CAGsJ_4ywk7mA1xfk=emtqby1UAwFsaH9PChmk2TuZoDKrMzuXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4ywk7mA1xfk=emtqby1UAwFsaH9PChmk2TuZoDKrMzuXw@mail.gmail.com>
X-Stat-Signature: ibgg9fromnpa6c4sh1nxbqu763pzd3pi
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA4D020002
X-Rspam-User: 
X-HE-Tag: 1787791608-14249
X-HE-Meta: U2FsdGVkX18zlKJNA5t9veexOIjKQm59cykcVw8LpmCf5Ssxxr0LQ/jPSZMGncSh20cGHYgmalME6yskDlrXRUtJCwVC5LY3p+uI2ak3XSoAh+THysWfnVAHK2F0Uq2/tp2a35deWo4YDWIFwxAUxvYpPeRaOEOa14R3RtJaVbB5odFmcTkQ9NdfYUEluxJhH+Y7QvOiQgXUfiUv3gKZsPLdp45FwQjsY4QwOTu2DkeRvzRWoex9IY5Q4x/Qg6QwQzuFNZlcyJ6wKPnSW6x6BI7KImyyRi1j31ySHiBj6h2RxPY8v1SSdytdRSFU2vmY/F3LXo0nKrNW1zPg8RXrwWvzdbM6UI9fqRRMsOE65ddH9cbT2pSfwcE5yzpnICth08zdKpYe+t3DLAcSRm8/oPGfDqKqWtAFh6hB28d+EifruWEOkVGLpGjK7JL/ZRSz+ik3naLP3M5Ie8YJpTmfFGD6FPgP1Aty4jMMAxvkK090S82hyHaT/+zeD+m983VVDGbf8moD29YNuzURXQshp69vdDrSBHrff921fuPQVhBUH25HSUTUI/YRy14La5Oyrhibbx5eGlaac1kn/dHxNXmfW/8WS/fkRrzNIchn/ngWoTvsf07wX70yQmknitM5CKUJeBkVMrNSDHzp0SVy1ktkEbcyRbc3liYG/EPAgi/XQsLksP/ZzPkksYspM/NLAV1jT0zYmrbWrbkWKZ+2t91W1qYi19GWDuZfm0jp0owiXwFxooIzmlh0ky6r9d4pRjK6btn7quUgUN16ZdNTa+KSSV/FaJA/oWjk9eBn3imBCtp/UBUGN1HI/zxwR3E4nzko8ubqQohbWKJ3vTEBPUcmt76678jphkY88vBzoFpq0lNHsesEL4TsQVqab069ydhLjfnH+tDAvGRM0lKJQ7r/9kDCn2kCgUXo1dpSVOBXAREcevyzFkwkgEAFX5AqaXGOJjdySLELCAWbCuY
 ARV27L3r
 tlqOErAMU3vPNdFWL6QbeWOhdAt3vU577ETyA2Uj384kDm4OUNI+EnMQIC78y3OVDO4HuKdFiLFdsRhVNKKIc+uVB+aSLyTltmoHX9QGP1Rk/HP09y1lx6tosCd4yAwUvXKAPFaOESe6DycMOgiIAWixuwkcPGBYbNRquS7Tna11uxe9FA6xjVvGwJvKufOjyAuRAtEo99c+qg2uL0d2c8bH2hlIZvzGmCNlBF9W5i8y6vpsUe6mHXSH+/TRRdZC57fLRe6cABIRQ6gBKqMpUoy9J71h3r4PAFJs1WweIj1H2cDFCWQK6r9TLE9iTgdmhKsAhdkp0RuZSRn9bDIEDr5z8iqC5PTxdpTcD/rDAFa4AtNsHeOdtAP6n3oLr1FBaErkmnLcavR9Jaihqw8tePTZ95HxZo0K0h1cirtHl84Ky3mhMDuLqGzSakshNMehZ+jVXaGdULw0EXFIDUlBB9/bXoUEcv1lbl845NLTA8Y9UlmMTy9Q1dtfqDAbtb0TH2wtafBIQhwpfnNaMB38gfTGNpIJm2IFqvXsCAzK0PsouOCGiEvkQ1I7uJNkV8IRjfNoGHU+Q6+myPRd8csxebbShlzK3jUfrJxg1E6uRtjqa62B/o6VG20dsSx/kBKcs1OG7kM0cjibwiQMxMCDc0G5IFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/27/26 at 05:43am, Barry Song wrote:
> On Wed, Aug 26, 2026 at 4:56 PM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> > > During aging, a folio's generation may already have been updated by
> > > folio_update_gen(), even though it has not yet been moved to the
> > > corresponding generation list. Such folios are hotter than those
> > > already in that generation.
> > >
> > > It makes sense for inc_min_seq() to increment the generation of
> > > folios that were never promoted during aging and move them to the
> > > tail of the new oldest generation. However, folios that were already
> > > promoted should instead be moved to the head of their updated
> > > generation, just as sort_folio() does in scan_folios().
> >
> > While sort_folio() move protected folio to the head of next gen too.
> > It only moves ineligible folios to the tail of next gen.
> >
> 
> Hi Baoquan,
> 
> Thanks for the review! I’m not quite sure I understand what you mean :-)
> Could you please clarify what you’re suggesting?

Sorry for the confusion, Barry. I meant this is a good one, and
sort_folio() has the similar issue in which the protected folios are
moved to the head, wondering if that need be adjusted too. One consistent
rule for both is better.

> 
> I can explain the design in more detail.
> 
> Yes. For both promoted and protected folios, `sort_folio()` moves them
> to the head of the corresponding generation.
> 
> Here, `inc_min_seq()` is a bit different. We are overlapping `max_seq`
> and `min_seq`, so the `min_seq` generation should be moved to the
> second-oldest generation. Therefore, I think non-promoted folios should
> be placed at the tail.
> They are genuinely not promoted, so they shouldn't be at the head.
> 
> For example, suppose we have the following folios:
> 
> Second-oldest gen: f1, f2, f3, f4
> 
> Oldest gen:        f5 (promoted), f6 (not promoted),
> f7 (promoted), f8 (not promoted)
> 
> Without my patchset, the result is:
> 
> Second-oldest:
> 
> f1, f2, f3, f4, f8 (promoted), f7 (not promoted),
> f6 (not promoted), f5 (promoted)
> 
> So you can see that both promoted and non-promoted folios are at the tail
> of the second-oldest generation?
> 
> With my patchset, the result is:
> 
> Second-oldest:
> 
> f5 (promoted), f8 (promoted), f1, f2, f3, f4,
> f7 (not promoted), f6 (not promoted)
> 
> Best Regards
> Barry

