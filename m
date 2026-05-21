Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E01CD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200746B009F; Thu, 21 May 2026 02:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0136B00A0; Thu, 21 May 2026 02:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078626B00A1; Thu, 21 May 2026 02:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E76576B009F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:57:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92CD6140212
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:57:16 +0000 (UTC)
X-FDA: 84790520472.22.F52647A
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf11.hostedemail.com (Postfix) with ESMTP id 25B9240003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:57:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779346635; a=rsa-sha256;
	cv=none;
	b=tNqYsboFHhlPkCrTOlrOchQNSSWf1kC5TBRiNLrvQQ23c8x/YOZJWnzE/ZwUMzMP3JtaX1
	cesI3dTGQnNhXjpMT3WiGNp5wxwPAIg6SStgWdAl210+YfszfhyhNHWFgBmwVbb/PQEV7Q
	ZTNVUYTaxDHAlklZLWPPsY3j8HoN0lo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779346635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hJwP1w68LqSIqJX/Ax+OSdIZnuC/uR3kWJNpqGBxxF4=;
	b=PAjD9EJqK2rH7syvn/be+uaeJAL7xLfnY5QICmwnc59KsMVGYSactFQKNwMEEzllpfDVnU
	hKrsBChJIksLGkR3QTMlxW5aobY4L7fhE9Je7Eb/qm8BN5weOTLhyAEhMDJ80pGluMGSV/
	Rne1i5OAv5VudrzVYgsxmvRY9Xh/I+Q=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 21 May 2026 15:57:10 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 21 May 2026 15:57:10 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org
Subject: Re: [RFC PATCH 0/2] mm: swap: allow per-device skipping of
 zero-filled page check
Message-ID: <ag6sxsav7bIYX+FL@yjaykim-PowerEdge-T330>
References: <20260518073455.2495934-1-youngjun.park@lge.com>
 <20260519101615.2876646-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519101615.2876646-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 25B9240003
X-Rspamd-Server: rspam03
X-Stat-Signature: 54e5iafgya45x61h5aw3motwxibaec11
X-HE-Tag: 1779346633-284638
X-HE-Meta: U2FsdGVkX18XgtXAT7mZzKjYVze0fHRDVDTvZjRxGYFjrJDMsy5ONUlNZ1IKtZ/Rz/j3VB50pdFq/Yr42JQvJKkB6I7gdFDVJx6VvlHD6Y3C+Kc6yQqC61VB+YnxzUy8wImOISwGJlxfGEk31yR/QQ6QEXF4QkRwfG5vUMArE2CAQ7O2ZJBv0O58HGgEDZe3IgO0j04vFLLxaYP8E8+hy0ogb4cUHb5aWxlTzzd7XNFdZfkj6BAMK2LTskL/q30crlTu8BKT2qIGnxk+NKczFNHVOiSBWmi0X7ySSjkj7VBtrOywDf/CHIvB2+0yIONipKHj8nba7xuGiBXtfmki4VggEfg9DPeGeIcde8ooecYg5+548/RURHhvg/slbNynyzMSaAsRlhfCRMp0BuxeHtnxgDdjzxngL4xZZaRCyuNysLg3+Y32f3yU3o2NRjUDnqcMPohIH71qvmi3db3iUM/qw7uIeD5gRjaDlkXTRHHvMgqaOFo3w/jJEymiZ/CSwPgy76xuhdxsc8XKWphRo5ft2u0jaIUEHOqAeux0Sl/PSMoWyXt8EuWcuvGBZBGNs3EhuZgI2qwE0M41oJEYvExMAOUIzyJWHRhqgShCt5xCRw21bzeiCUPdNGcQXnsY6Bn/Kketxu+Z1wj2pivz1EcD8CWtWYcxDo/W5Bn0P4McbSy/wS69bP43O9GvDbKHRt8WlB3tdz9L7kkrJoUdRsXLF35w3DBSzGf9yp56UHpqQCIpyVuUI5PtcamDK5bgTjCmLw8wBqV5GGhJCXCB8dpObon+OQNVwxUmFqxfrhLfGEzjzMqNk68TLBAiZZh/RJOq8cAG8QGAOZh/CmNOiT+O+i6qcQYnctYh3DXdMnFlCeNUl7pNBPQPFys642soRaUjbMMx7V+hT9j2gRTNNM7mFaacNjqemnYtSv+Atv8P7i45nrpZ0JhU4Pfi6M0cHdjycU9X8ydlgW9ca+y
 y0lzjhuC
 cMjJqlXJwg3u6f8GunwKbTWt+/6itTqDMcFf7WBgZsdvoh+/55jgz9Yc86IvBThqVy8ffoXRLwutWju5nNPdhkyl6Bi8aWUbaWOdZ49cDzUQt695xKxpe6AtodcVeLCjwCYdQkXAcnLGyBvUgmU9QzeG1fObt+3CsA2uqaJKA8LXheJepBNLtubW2+tOek9dQ/Z5lMnOG1+6h78LzSie+khIKfNsdGQxtFHscNR0H3C2BZYNNsJKRZFWBUa+JglOXVJH5ELM9YZb9J2tZFKohZCP/3bju8dzmm4IK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 03:16:14AM -0700, Usama Arif wrote:
> On Mon, 18 May 2026 16:34:53 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > Currently, the swap layer checks whether a page is entirely zero-filled
> > before writing it out to the swap device. However, some swap backends,
> > such as zram and our custom swap device, already perform their own
> > same-filled page checking internally. This results in redundant CPU operations 
> > checking same page pattern.
> 
> Hello!
> 
> So IMO, we should go in the other direction and remove same-filled page
> support from zram. When we added zero-filled support to swap, we removed
> it from zswap, because its not worth the extra overhead of maintaining
> this in zswap.
> 
> I did some analysis at that time, and I remember more than 90% of the
> same-filled pages on server workloads were zero-filled. I think someone
> else did analysis on android (maybe Barry?) and it was about 85%.
> 
> IMO we should just remove same-filled page support from zram, and keep
> this centralized in swap, so that everyone benefits.

Hello,

Workloads can vary (like ours), and we still see value in checking for
same data filled pages.

(For reference, there was a similar discussion here:
https://lore.kernel.org/linux-mm/CAKEwX=PBjMVfMvKkNfqbgiw7o10NFyZBSB62ODzsqogv-WDYKQ@mail.gmail.com/)

Anyway, I will review this again to figure out the better approach.

Thank you :)

Best regards,
Youngjun Park.

