Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D195CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 09:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F028E000B; Wed, 22 Oct 2025 05:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A07028E0002; Wed, 22 Oct 2025 05:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943FE8E000B; Wed, 22 Oct 2025 05:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 823608E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:57:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0DBB4BB6AF
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:57:59 +0000 (UTC)
X-FDA: 84025299078.04.5010300
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9881820004
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:57:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf13.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761127077; a=rsa-sha256;
	cv=none;
	b=smH3ssXQVVQawqhweadf8gGPROBCswI9v3Yjjj056UEQv8emx5Y2mYmG3kEtTogKYFw0BP
	34mVa+9ZrP+dvny3UCbHYVOkBm/FZWFBZ4M/0f8E3+Q1Tyq5jyIgpsEEV42wbd+Y+afjuq
	1TiiSZnvg/cLYRkPxqrNtNdOZv1CoWo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf13.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761127077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=caZZFGjSl0HauoREUr8sdpmyd8rmYIzTl3VncLuUe00=;
	b=CFJRL44c++W90zv/JBvcCh7L0DPn0Ne1AxHOfwRw5FtQHI36n/BsmzhsW4hGyFpAd/pztR
	Ys3GPK4j26tX6mLEVL8KzmSI8k2NIIx5rahT1YdIeDk9rMCHH3zGsdZBGs3h9tZGOdu1IF
	sB8K3YLxCmceXVN4RI6acGKMHAqg4WU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C6863602D7;
	Wed, 22 Oct 2025 09:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 031A3C4CEFF;
	Wed, 22 Oct 2025 09:57:54 +0000 (UTC)
Date: Wed, 22 Oct 2025 10:57:52 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yang Shi <shy828301@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com,
	Will Deacon <will@kernel.org>, David Hildenbrand <david@redhat.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH] arm64: mte: Do not warn if the page is already tagged in
 copy_highpage()
Message-ID: <aPiqoGyCmj7bA37C@arm.com>
References: <20251021181353.3842660-1-catalin.marinas@arm.com>
 <CAHbLzkpd8awNe=bZVv9fTux+Fx-HT8qL4ENZ-uC4YcPjf9e=KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHbLzkpd8awNe=bZVv9fTux+Fx-HT8qL4ENZ-uC4YcPjf9e=KQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9881820004
X-Stat-Signature: 93uhdffiqekgtod5dxiu9i99jwncpwgb
X-HE-Tag: 1761127077-448506
X-HE-Meta: U2FsdGVkX1+H8DDBOR1jhB7CEg5h3yF988RqSo2vWckJo+6SBb55KyqIu2A12VM3idHOKx6lKL4G7RjYslpzI2yfwpT/dhhdS/U4k4TTCdZ6ncXZ6016e7THKcRdfMFJBhaD85y6Vt2csP4C807JkQtXDGHW1G1CZxIGk74ONEBQiU7p5aduuhXWi0/F6yFQ7Y+8oObXqpytBCZihUZEpOlOv8GizJd6mbwIvuT5fC4fbVJ86kTwWhtYpzDeHmJT4+naOJc86xrzD1pCnYHXCR9TXj5zfzjnTwShZk/XP3nDeaK8l38Ms5cNn2t9azp33tim+YP6l/FrHO73smja4pRRewTjhFYPux20e4/mZaX4MKdl6To0NkY12qRwoE/Y+fAy7M5nVQYUYXr3VSTyQ+dO6mtqpUftzzv3XiDJ0cQpAYZvP8Xg55t4k8ZFDjhS22skAm5Sb4RO7MFMmdyl+vD55WcfeLOXvPJR1Ue9bMoeIBTnEoW0x9mGWxFATC+ujGy9wq5g7LIbiiHoYAxiC7YZZujRLTgLp9hp0kVhV59usR6KWw6frYPpPZ7tv9q/zHID4OMxRdo7DMIyrrunk5pP9OVzDizkex2bXSZJEPWz3Bw/bXxotZYVmMEJP01Hwgw9jxgH4GqHYnuuI/F0Z8b6zCoTlg6MjHhKclsEf3kkoXPD6qdaiXgugJh7BLRTeEbdTqhlax+wHhc7nhs91+5cE8Fd5brJhFuLhiC/YpoUI5Sqbq9GLWFlBYANuL353h/348Jf7sV099CH7VdKNWFwA0WKoxy+AVRriJ3cRYe2+I8sm2ESbU1WtEMkJcP8TLaB1K/oqlrSRCkw5zXB0Alh7NLWQha5KaItL4dWbKBEGuGtl7hduSzDU2pGPvG5sk/EOrdftyNACPhpzzrEEc2J9HzwThR2VJg8jddrPVNCE9wa4hAJsc3zjZMIuCXn6LZHYFWZB77UZTytPX4
 wX92gXLl
 QR3iRKqTohy6SMbtD5hd/bdkYE5vLDJ7NoIw0tnID6qRyGCHXHmRXpE6CtxfUCDXm85C+Rmp52c178QJq+7cAHk9i+m/fg4+6IC+7ZLg9a42YJdjMrNj+XEIq1ysMtwgCz+Ongy9dRUE544AxBUEuQ9W3VjeKGs6EUUJVm8wUpYlO7kLT+aLj0HQYi1OnqGJZ6HrVgLwe55HR7UTI9hyIeTC6Aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 12:00:04PM -0700, Yang Shi wrote:
> On Tue, Oct 21, 2025 at 11:14 AM Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > The arm64 copy_highpage() assumes that the destination page is newly
> > allocated and not MTE-tagged (PG_mte_tagged unset) and warns
> > accordingly. However, following commit 060913999d7a ("mm: migrate:
> > support poisoned recover from migrate folio"), __folio_mc_copy() is
> > called before __folio_migrate_mapping(). If the latter fails (-EAGAIN),
> > the copy will be done again to the same destination page. Since
> > copy_highpage() already set the PG_mte_tagged flag, this second copy
> > will warn.
> >
> > Replace the WARN_ON(page already tagged) in the arm64 copy_highpage()
> > with a comment.
> >
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > Reported-by: syzbot+d1974fc28545a3e6218b@syzkaller.appspotmail.com
> > Link: https://lore.kernel.org/r/68dda1ae.a00a0220.102ee.0065.GAE@google.com
> > Cc: <stable@vger.kernel.org> # 6.12.x
> > Cc: Will Deacon <will@kernel.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> > ---
> >  arch/arm64/mm/copypage.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
> > index a86c897017df..40749d0a385c 100644
> > --- a/arch/arm64/mm/copypage.c
> > +++ b/arch/arm64/mm/copypage.c
> > @@ -51,8 +51,13 @@ void copy_highpage(struct page *to, struct page *from)
> >                 }
> >                 folio_set_hugetlb_mte_tagged(dst);
> >         } else if (page_mte_tagged(from)) {
> > -               /* It's a new page, shouldn't have been tagged yet */
> > -               WARN_ON_ONCE(!try_page_mte_tagging(to));
> 
> I think you should remove the WARN_ON_ONCE in the above hugetlb chunk
> too IIUC. migrate_huge_page_move_mapping() does the similar thing.

Good point. Thanks!

-- 
Catalin

