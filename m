Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A56C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 06:59:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC78F6B008A; Fri,  7 Aug 2026 02:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E1D6B0096; Fri,  7 Aug 2026 02:59:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDDC26B0098; Fri,  7 Aug 2026 02:59:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B07386B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 02:59:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9447D40213
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:59:56 +0000 (UTC)
X-FDA: 85073573592.30.CAD7926
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id E0D3D1A0002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:59:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786085994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1jPAjBtHXXcP1NMUJ+AKnm3yQzwFncFHxKYL2qt2lD8=;
	b=bB4BwYhgMiIq27RzN6XDoonCf6rk/8/gh3eHL2StTRsUWl5GgGtIyXfvskRAjt2X3IeDhy
	8c3lKCWneCUL99WU2Yp3JO18Y0W2kc0RZI8BlM8s9zV59CBzdCCLHHpfcHtTZMmXg/ALH+
	YCKR83ok9Zj/WlU/T6AxKwUfv2/gPPg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786085994;
	b=v/ZNcmR8DEvuRSaprG64ouWDvDXeMkSQsCusuiH+zM00pn5TmeB4u7qBP8xbaM6rnHR4+a
	F/Mi9UqSe02UEkqcyapHPpX2MrnNPzUsez7H8erJf1UrYlW5wwUBw/d1r9XYAeN9P+oo1t
	hpT+PmU4F6AbSxUI/kCJ9FVs1euS32Q=
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.52 with ESMTP; 7 Aug 2026 15:59:51 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 7 Aug 2026 15:59:51 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 7 Aug 2026 15:59:51 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>, her0gyugyu@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] mm/swap: skip empty clusters in the swapoff scan
Message-ID: <anWCZ5YaOjELoffB@yjaykim-PowerEdge-T330>
References: <20260806193228.458685-1-youngjun.park@lge.com>
 <20260806130655.420e16bf621b580cc5f08040@linux-foundation.org>
 <anV+EoxWGKdU9da0@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anV+EoxWGKdU9da0@yjaykim-PowerEdge-T330>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E0D3D1A0002
X-Stat-Signature: z5u3qcbmdsyyw5pxf9gptik4d9n7569w
X-Rspam-User: 
X-HE-Tag: 1786085993-275071
X-HE-Meta: U2FsdGVkX1+QdQngLhQJb3CBs7kRvS93DQijJZtm6Td6ofHxUEF7z78kvogVDboslGcbBe+JSe6nifyEfDyOxjDQM6MLHXI/fJlAr3YRynnEy3ZPe69XUn/hqPhtNNmDdyB3DSssmOtSSbsyWs/U9vGsvDumIaqDYUyrql+E0Qm3M34FxhkWiVErNvscobcIEW+Ep60oNYsGd6KeC1JJyLIY8pMgm235csOSsZiMIDdMv+u2sFQMsFEAMfQhauLX6R3fJDF5kiI8wbAF7/GGn2/92Lpq9H7Tnynlw/a+Da3TuwCHD5Kf4+kTVXmmEtd++8v7zUoOhtrb64g8dVLrgJvlxeGl4VISD7keuCaUj7nMR7tMtUL51cdzNXTsgyqllUIdtUmyH/sfRZC2w1MgFPNzNxv0he/ISWY7DehBQZEkNQTqhtSbMomD1IYzhKXotjg4XRSz7mDuq4IrZMkGI5kLV4TKtpcgPu1v9iCEiPJ4UUZkvt0e4++XOQt54cQqlj7RHT0A9yceU0TwlOmK6TNaTpLJ+oLdSZ9Rii4TjcpFthMZZqrWyyg2BumR71BcWnxFIko4ug2Rbs3XyBv8y+QODuMSw62P07iQiQTbUxuk0kjD1D+bY+fWcqk9x8JvBji6dxV7GARKPlkg2NNpFr99Y3ZTrLNsVeTxKR5LdKwF1A+1TFlToi2ENgZ1HT25NouZIcatF12+Qb9OF5vNkXrEzfQqrOoloMO+vLzL9GsoQQfpY61YnIMPRlhOkFVqiJhafJAF5EQgLQtupFRDr+67+Hup7zYRCgTxZ5PmFBwB3Be2S/lvOyhzj9WP6wj6ozktq2nhkeqGir2VeCYBAZGonER+5LzMf3xGVEIKwZgYlvIfCPEIZT1UTCylpdG51uNxYNKKFuTRA8DiBCHPPEOaBzhvdkvejvidGFsAcFJSKgp5j98lnYXHMIEOK1AxcyNUAycWJJ2iXOJWtTe
 7eH1pRVh
 sb+P2g+pbBDJx5qZcjlG9JzLq80N1Pjf9RJdnSbchj+ITEJLKvJ1n1l0SHaqzQ2sPoArB7Q47cPxZ2rYp3eg1OOZWCpN7fg+tSnYotVnSAJumAGvxM51oWmaUzCU6lgnegAKFhucHtuPcK/sfVsHpZeBJK+3cyR0Y11E7PJt2kUz9wRBqS7YwJtXXzw3Ke/NpUnLFkXazQlt9jmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 03:41:22PM +0900, Youngjun Park wrote:
> On Thu, Aug 06, 2026 at 01:06:55PM -0700, Andrew Morton wrote:
> > On Fri,  7 Aug 2026 04:32:26 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> > 
> > > find_next_to_unuse() walks a swap device one offset at a time.  Slot
> > > state now lives in a per cluster swap table, so patch 2 dismisses an
> > > empty cluster with one counter read instead of SWAPFILE_CLUSTER table
> > > reads.
> > 
> > Thanks.
> > 
> > Can you help us understand how significant this change is for users? 
> > If "not very" then I'd prefer to defer consideraton of the series until
> > after 7.3-rc1.
> 
> Hello Andrew
> 
> "Not very" in the common case, though there is a case where the win is clear.
> No bug and no user report.

Something I forgot to mention,

This only affects swapoff.
and few users run swapoff often, so the impact is limited either way.

> For now I would rather defer to after 7.3-rc1.
> 
> And for your reference, here is the details.
> 
> Every swapoff does a little less work now, because the scan steps over an
> unused area one cluster at a time.
> But IMHO most of the swapoff time goes to unuse_mm() and to reading the pages back in.
> 
> The gain shows on a large swap device that is almost empty, when the last
> pages still in use are near the end of it.  The scan has to walk up to
> them, and today it looks at every slot on the way.  Now the empty clusters
> in between are skipped in one step.
> 
> I have no measured times yet, since that case has to be set up on purpose.
> What I did is the arithmetic for the case that skips best,
> For example 1T of swap with 256M slots with SWAPFILE_CLUSTER = 512
> and everything free but the far end:
> 
>   - today:          256M table reads
>   - with the skip:  512K counter reads
> 
> That should be around half a second of scan saved.

+ benefit.

Reclaim can put a cached folio back into a page table with the slot it
already had, so try_to_unuse() retries and the scan starts over.  The
saving then applies once per pass.

