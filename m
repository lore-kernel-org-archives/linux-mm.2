Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D34CCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 02:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 427D46B01AE; Sun, 31 May 2026 22:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FEFF6B01B1; Sun, 31 May 2026 22:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33BB06B01B3; Sun, 31 May 2026 22:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 207E66B01AE
	for <linux-mm@kvack.org>; Sun, 31 May 2026 22:05:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ADDFB161AFA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:05:52 +0000 (UTC)
X-FDA: 84829702944.24.D51A5E3
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf14.hostedemail.com (Postfix) with ESMTP id 61EF6100015
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:05:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780279551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YjDjRGifazkvdwEMorM/IZ02COF75GoHpMw+XN0HLv4=;
	b=14q8YywXQziUc1j4FDqyMqqcMrkQPlFZVAiwDK4dExh07AhiEZfCF5sP9yisstklpCpWBl
	kBCo0RT1vyPcCvEIGs1w0RuRm9BQy17UTZ07kmgNRX4wIXXP5bZceAd3ryDynT2udYhL0O
	h8nFQyfzPiD8VaKKBOuqWxnpisMgltw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780279551; a=rsa-sha256;
	cv=none;
	b=InKICGtWyj6L185TrzyLjqjDN+LOmrweMs1zNjh84sXa8Wbxnfp/0DemKlnHdcdtxqo217
	06SYVrSIzcC/2oiNvKtJAfRIlw+Vv3I72MdoZTAACl+o2RuIlCucPbKZMHD7lmFdAXmaqa
	BE6XrGPU3GcuSgXUUMTH2J9smBsC3IM=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 1 Jun 2026 11:05:45 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 1 Jun 2026 11:05:43 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org
Subject: Re: [RFC PATCH 0/2] mm: swap: allow per-device skipping of
 zero-filled page check
Message-ID: <ahzo96kXBoDv/WFo@yjaykim-PowerEdge-T330>
References: <20260518073455.2495934-1-youngjun.park@lge.com>
 <ahxeXOlodtwjpVcH@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahxeXOlodtwjpVcH@KASONG-MC4>
X-Rspamd-Server: rspam12
X-Stat-Signature: fkwd179wyogzo8t3c7n7sbzk864kzs3t
X-Rspam-User: 
X-Rspamd-Queue-Id: 61EF6100015
X-HE-Tag: 1780279550-772938
X-HE-Meta: U2FsdGVkX1/hk7y/phr+9elAXje+x3iXXe05EylrUfpuHVfVlseGubpAqya7chBJCI7wTOKCIrc6ICb2bHn8nQSrCxuOuHZb8dZhUIEdcaFuPPhw4xfjqlQUmlyqCPkqqyAlymV58UhqX2QS624AzfYf/9FU5hOaWHCLcSLC8TYpVFII+3TEkr6KLT4BGAbzk90ld1msz9IVtQY0tNtQAmgS1blPQo38wotkHJjjtxk65FK6z+cxuxhHSepn0L7HDZ/YtPdi/PT2qxVr7tIMn9ozTIzN7ydpCviwYZdZPX7whZ6xZ3cjl4Ff4fzQqxuWl9c8uGG1pIxuS+QzuYAwuy6xaxmFo0HY8BiUy1pK3QdJKdsSqfmS+85+g2sCXGGwXfcA3RmTOapxwCc+3mpQM+cFlJ72HlcvMfdZM61jlAz+kcqzuiMhlrJeuZ+eB4LtVQqQ8eCT5QLBS08lnSXNYzOSA+GRD5UuuLHvkhzGReIwgldKPSPYkgMk8A0VoQ6+9MlIzOAizgHWNrnm6lDxO6015L8Tzql8LQxLe+wRCCBApVpdD9m9Q9dPT1/8gHhyTmkdO2uaSYjZt61sJ7CO2sOK0y6YDY5HnLpUvAlQ/EHTTOkV4e3pYU7bg/psljCViT5WR8q6sHCcsQ5EpCJkNS1NAeXG6lJAgd4U06kSBwMgFybKVse8zEYDbRCKPBQvW++KEnzefHf5qmBJNZJ3VmrvnEfbvZ9c5QaIGlQFNlmj4qSYaPiSiZ8cxM3qHQa4+AeF+2bnoKNvJHPpMmSN3p1RxQ4GjWOykp9B/dtdFQBLHr5re+Ky/rjb7cS5cCVIY1d2knvPQa4eDAj/HNSH7LvJugxOcwrhRZ4AZwrx/ZHUyajyFTm0p0ochYn+Qwqt2Ca9DXz27xHPKq9gO+wG+xaRf2QPy8VMGbx/1rLS/BeoVe6zOQPBkSPvolqd7SIZhZTvM1dsLE/PJ95FKJY
 iJ2Fbk09
 j1IDVY826ZVqcITRNRdpJPLJci1ZnoW+6V7fjjfg6zwHpWxZ0VHDM13i6UphgNvVEv8Kj7M80Ly6CcsRUL1Mc9LQkRiTp8hm80jC7sGbDEYh4EV3GCMHxEmkKQ73JocQ41WcIv3k5SfawOrFeyCazfgYuAV6Z1l7LYTf0I979/3PEElL8BtIM9DID+g/u001KJQx0ebFxuGvqD0gBPZ17FTOX4YApbYzJdZ4T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 02:48:44AM +0800, Kairui Song wrote:
> On Mon, May 18, 2026 at 04:34:53PM +0800, Youngjun Park wrote:
> > Currently, the swap layer checks whether a page is entirely zero-filled
> > before writing it out to the swap device. However, some swap backends,
> > such as zram and our custom swap device, already perform their own
> > same-filled page checking internally. This results in redundant CPU operations 
> > checking same page pattern.
> > 
> > This patchset introduces a new swapon flag, SWAP_FLAG_SKIP_ZERO_CHECK,
> > to eliminate this redundancy. I introduce this as a per-device flag
> > rather than a global setting because traditional swap devices still
> > benefit from the swap layer's zero page check to avoid unnecessary I/O.
> > By using this flag, userspace can selectively disable the zero check
> > only for specific backends.
> > 
> > Furthermore, on certain architectures where the zero map is managed via
> > a separate bitmap, skipping this check allows bypassing
> > the bitmap allocation entirely (saving memory).
> > 
> > This modification is based on the previous discussion with Nhat Pham [1].
> > Additionally, this patchset is built on top of Kairui Song's recent
> > patchset regarding swap table and zeromap modifications [2].
> > 
> > Tested simply with zram on QEMU to verify zero-filled page handling.
> > 
> > References:
> > [1] https://lore.kernel.org/linux-mm/acQvNRLpHwnHt7i+@yjaykim-PowerEdge-T330/
> > [2] https://lore.kernel.org/linux-mm/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/T/#t
> > 
> > Youngjun Park (2):
> >   mm: swap: add SWAP_FLAG_SKIP_ZERO_CHECK to skip zero-filled page check
> >   mm: swap: do not allocate zero_bitmap if zero check is skipped
> > 
> >  include/linux/swap.h |  4 +++-
> >  mm/page_io.c         |  7 ++++++-
> >  mm/swap.h            | 12 ++++++++++++
> >  mm/swapfile.c        | 14 ++++++++++----
> >  4 files changed, 31 insertions(+), 6 deletions(-)
> > 
> > -- 
> > 2.34.1
> > 
> 
> Hi YoungJun,

Hello Kairui,

> I think this idea might be useful, some workloads with very few zero
> folios doesn't benefit from this zero folio detection and it's more of a
> burden than gain:
> 
> For example, one test result with MySQL:
> 
> pswpin      129323368
> pswpout     131460192
> swpin_zero       4641
> swpout_zero    248210
> 
> Less than 0.3% percent of the pages are zero, and almost none of the
> zero pages are swapped back.

That is good point.
So, There are three type of wordloads. 

1. Zero filled (current kernel targeted case)
2. Zero filled + Filled with other value (our targeted case)
3. None

The third case one also benifit from this kind of approach.

> I think the zero page detection is actually better combined with
> compression, e.g. ZRAM & ZSWAP which will always have to touch the
> content of the page. But some devices may be able to just accept
> the folio as it is and CPU may not want or need to read the content
> again before pass the folio to the device, that may save some CPU
> time I think?
> How we can make this zero check as an interface is arguable though.
> 
> So I think the user might not be limited to ZRAM.

So, In my opinion, 
This same filled data might be controlled in some proper way.
(like this patch, CONFIG_*,  etc...)

I will think about it more.

Thanks 
Youngjun Park

