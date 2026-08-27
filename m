Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B846DC61DBE
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 02:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 096426B0088; Wed, 26 Aug 2026 22:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0203F6B008A; Wed, 26 Aug 2026 22:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2ABA6B008C; Wed, 26 Aug 2026 22:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA30C6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:14:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87AD3802B1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:14:26 +0000 (UTC)
X-FDA: 85145430132.15.867DE7B
Received: from mta1.migadu.com (out-209.mta1.migadu.com [95.215.58.209])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4705E14000A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:14:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ux3DPNy8;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.209 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787796864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBBLnK03Ce3Gb3dPdF5TUs0inLWwDIQwPuAG98VZHgw=;
	b=8KACR7jkVwBl9jrXZ8T9V9RGwnScADzlvHrVHkWmkv6dcd6wjPtQRTQ+NdeJrjXVkUXojb
	oQWgAIhOqaq0esf1XyS58tdLcPrfRGA4A7RqNDBZmg7k0wiKgq/hciQI1zJ9e+RDK5/a1E
	VuQ6iTY6oRdP341hTdkMt+173iIAntA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787796864;
	b=Q/HJbeijTWDCY2QSj58a9ON+UgbWo2EkqAIXtB8+KHkz/uM0BCw9fBO/37nV41zD2NxztI
	k8sdqxAbL/8BgNbcPD4OeKSmNlpXin94IeNegXQY5EliYhVWOsrNEMSS2y9j5IyozVnBp7
	TMDRtk3ODvPNMSTu8ppCGovSPniOv+A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ux3DPNy8;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.209 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JccDt/Ebs3T8dFYp1/kM4G7Y7+hnSC4GBpVNEFEMEH0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787796862; v=1; x=1788401662;
 b=Ux3DPNy8Qw3IkAf2CWTzhiYTIhuyNXY5esueywUhua2T7g2nrhJ8q3XWhvnLD2A5K+g+QzPK
 jbx5A7MRH+zoHZTShJdcVAI3OuK4+gDFtSHhzPtSViJ+PGGf3Uy4gemy/PmTrNQhA5cB3x5aENR
 DQu74H2/lB1iZAmJPRJOL11I=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.159.239)
	by mta10.migadu.com with ESMTPS id a5c59b9767382a5f;
	Thu, 27 Aug 2026 02:14:22 +0000
X-Mizu-Trace-ID: a5c59b9767382a5f
X-Migadu-Flow: FLOW_OUT
Date: Thu, 27 Aug 2026 10:14:19 +0800
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
Message-ID: <ao-dewgE9XAfP0rU@MiWiFi-R3L-srv>
References: <20260821102538.22642-1-baohua@kernel.org>
 <20260821102538.22642-4-baohua@kernel.org>
 <ao6qTTtk2xkkeKob@fedora>
 <CAGsJ_4ywk7mA1xfk=emtqby1UAwFsaH9PChmk2TuZoDKrMzuXw@mail.gmail.com>
 <ao-I8rYv_G5j4wz4@MiWiFi-R3L-srv>
 <CAGsJ_4zoXvyXG6-qAH+=nv6V92w_U_tk78YAPKMihRniqvTe8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zoXvyXG6-qAH+=nv6V92w_U_tk78YAPKMihRniqvTe8A@mail.gmail.com>
X-Stat-Signature: ftyb3uq7yzz7xmdqbwwe5d7dyjyee4zx
X-Rspamd-Queue-Id: 4705E14000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787796864-380245
X-HE-Meta: U2FsdGVkX19efUYeAIKu5NLpnrfEdMm2L6/9N3/6RAvnCvFwPmEF7DdhC7gmXhG+ag8P3MKagStvYUtf+/Vj7bPkl/TdyUOLAajwh8sdQHs28sVAOlN92hNdy9Zld2ytJ+kreTT3rK0Zo0gViR2DHGxXOUthRSoejXGiIEE1l17RMPxwUaQhUTxigQOS/N4YKtNYP7PhyPgO1brpwAlrkFkqPXDuqIaMcU8Mj6G7hLBNoPiDJQYjCKexAKP28XKRaDPM2K3R94JkjweWHA9TOf7wTsTwnIIW+hcb1gjx2H3VOtJviUXd7ix/WaYUfbC2e/1oBdAnGfzwvi/+axyXkoqOXb6T5ymZnIIPy4KlJTWosqaRrlgj1ysXEwQ/6ICGBIB8yDA/6OExK21yL9HOIYbkRImrkfMPlbGxmjlsXVYDvOGQFppD5ya4Zaa+gLcHd4FyVMsfSY4oBtzc9jytLcH/JJ6Rly7doAkf+6uA4SHlTYxxqeMPfNhmiBUdIvdfYnxYYkF0lzBE6zADrcmgdECUcHTspOpcNgCQ+2jeujKYjACPQiJlWgm2eSBdwVgeoYnkhN1uaz9upiZeKEpDYDfKo+7u4c46b27KWBU58TzOv/IZiV3Xf1nQOoUIXE9mH5znqOlQh80GreZiasSISxPJg8Z7HuGgAJA7jHNJO+A6PbdPNWzKapOZGpv9wCMtfKyHp0vD42AChGRrVoVzFmf336JpnnBpUS9ZAIcfXAY/LiEW1f0cHAzi6Il1dTMj7m6M2qzlwOGz5DD2iLyqCYNcm1bRQEIk/KyeKu8DRxLpUiS0o/N+6GbtEBVL6xzhrQ3x3dHrnohaddE8ZC81vbInMcJggoQ3Rn/af8bO5039fQDJDYw0vOdAbftJQSjA8qnNmjf3HIhRUOrM8mMANXFyZPAlOldKbTTG31+mCdJ1ED4z6bgAnrTH64agmYDKEWn6nduslpDbaPmDj7u
 UjPM4rTD
 uDEdRfCQH6njiCslz5IvaMfhqb5xoIfosJxfSKZHf3UDY8TumjpilGSbC1iV37osXQNhqmdYtPRVqA76rnasfCGB9YTSLssJPTzTeY2B5uR9zEX1rnugfM2ixQCL9PPxK1q9X2lbuJrNyWnCN+nD3of5XLlHqnIF3CnHbuNq6U0+GnExqqZhdPhui3v9GTi19Xq6ZtlWlaYhL/C9pAJUpAGpjJeYAKu/vi/oy+83kVAlW6G+7wz46lICsBaaq/hPJvsqZrL9WVdASSqpaUIFRXWjNAOk1MMmKDO8/sz9HdzeTxi6CBmeNVsuVfhHba0Pg+wbptp4luLoAlub+Y5xX02/G047jX87/PZKCM9G9eKjLANYgnWotpeoll953biOSKwcJH+6icGD7xOJFXXmy+vwvp4sJx3kqR7yZZ7kQ2Bfdh+TM4t95Dze6yP7PkWzOmQgWAmo2+xr2k2leZTa4PULM2MJNbSNuBT70f/qQ4XrJddmSzuUg2aXUaL7zldJexdtb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/27/26 at 09:24am, Barry Song wrote:
> On Thu, Aug 27, 2026 at 8:46 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > On 08/27/26 at 05:43am, Barry Song wrote:
> > > On Wed, Aug 26, 2026 at 4:56 PM Baoquan He <baoquan.he@linux.dev> wrote:
> > > >
> > > > On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> > > > > During aging, a folio's generation may already have been updated by
> > > > > folio_update_gen(), even though it has not yet been moved to the
> > > > > corresponding generation list. Such folios are hotter than those
> > > > > already in that generation.
> > > > >
> > > > > It makes sense for inc_min_seq() to increment the generation of
> > > > > folios that were never promoted during aging and move them to the
> > > > > tail of the new oldest generation. However, folios that were already
> > > > > promoted should instead be moved to the head of their updated
> > > > > generation, just as sort_folio() does in scan_folios().
> > > >
> > > > While sort_folio() move protected folio to the head of next gen too.
> > > > It only moves ineligible folios to the tail of next gen.
> > > >
> > >
> > > Hi Baoquan,
> > >
> > > Thanks for the review! I’m not quite sure I understand what you mean :-)
> > > Could you please clarify what you’re suggesting?
> >
> > Sorry for the confusion, Barry. I meant this is a good one, and
> > sort_folio() has the similar issue in which the protected folios are
> > moved to the head, wondering if that need be adjusted too. One consistent
> > rule for both is better.
> 
> I think it might be fine for sort_folio() to move protected folios to the
> head, since those folios have either been accessed multiple times or have
> reached a tier higher than tier_idx. They are sort of hot in theory, right?
> 
> if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1)
> 
> But for inc_min_seq(), it is just catching up to make sure the newest
> generation doesn't overlap with the oldest generation. Those non-promoted
> folios themselves aren't hot , so I feel these are actually different?

I got your point, sort_folio() considers the hottness, inc_min_seq()
doesn't. I agree with you now. Thanks for the explanation.

BUT no matter what it is, protected folios, lazily promoted folios,
and no matter where it is, put in head of next gen or tail of next gen,
their refs are cleared by folio_inc_gen(). Then in sort_folio(), they
are all tier 0 of the oldest gen and must be reclaimed.

So here, I think differentiating them and moving them into head or tail
doesn't make sense, the thing is whether if we need do something to
retain refs of folios when gen_increased. At least, for lazily promoted
folios, it should not be put in the tail of next gen and refs cleared.
What do you think?

Thanks
Baoquan

