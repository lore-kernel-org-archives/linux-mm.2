Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB32E85367
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 14:09:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 172E36B0089; Fri,  3 Apr 2026 10:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1236F6B008A; Fri,  3 Apr 2026 10:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060C86B008C; Fri,  3 Apr 2026 10:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC5B36B0089
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:09:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B449C2710
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:09:46 +0000 (UTC)
X-FDA: 84617427972.10.50445D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id EF4E912000A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:09:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WdojIXK6;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775225385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4DXnUZO/vknJJGNhS/C1TAd+WrjtU/dUhSwQh2DLOc=;
	b=hRaPEMNSkBkgOmjb0lVUpMcb3WhXi04y1PVaTfr16QK7PFqTsKu9LrY9uIn8uzMDaq/FMj
	3HTAC2/DJW8LQheIBPf5Ih4LdDNr76rur77r5rZtRaC3DyWjEsuI+IBCyRZcY/vQh/hsiB
	Y6Hntr2bLNFZCYPeRRxHmq0qZcKIqeM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WdojIXK6;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775225385; a=rsa-sha256;
	cv=none;
	b=rXlcYflDFyqLoxbSD2qVgrfk+RxNWwe8da9DAo97lzZhPCuuYGEsdbWrFbiO6kuGQjJFEq
	eWbAvpQk4+WTBeE+V03YWuVAwldQjDB+FJts1ZtlTj8rE/qdKH61RP0+LWeEmxTa2M31pM
	PGRvSyB050EvloUYQvsb9S/DRiJ7ytQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AC5E43C10;
	Fri,  3 Apr 2026 14:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6170C4CEF7;
	Fri,  3 Apr 2026 14:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775225383;
	bh=njgCd5TgApSbLqL2BVaGVJE3A23Q9YuPZCEfrjmffPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdojIXK68rUNezxrGuDGVTF3irivnY5fZ8XHKrTzsat3/aLEvV9fF3cCHdrHorOZQ
	 +Ps2Rsy4srNp/ZNqQExGzLtmp/SmyfrcczIjrpOQxk6gju8amDXnFKqqaZ2JSrj25I
	 PGGnIKnixUABwe+9jyY5pN/ldpsWGXX+O5q1RKT8hq+FvDzORCX3vpx93UuorTh6wB
	 8XFzGu83cCurtM+5SPl1Pdau1bAVWW3ERiD52MeiaNih0xMeAsyFLCEjgLSCMyZlvK
	 Y0zh2AB+UwInJn+614qY2KvWhNNrzcTtiZvBkNECAzlGxhYAaUINHauGHFx1zQ1NDZ
	 6ilPBo5pnDAdg==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon: validate min_region_size to be power of 2
Date: Fri,  3 Apr 2026 07:09:41 -0700
Message-ID: <20260403140942.50643-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260403082910.5346-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EF4E912000A
X-Stat-Signature: 5o7cchnsmetceke9atpyw3x6ibfbkudy
X-Rspam-User: 
X-HE-Tag: 1775225384-497243
X-HE-Meta: U2FsdGVkX1+gkFXEZtwns2H+cUJUEeZsFNYNjczNBMecB+YLfXaQYyq74wijTJUyV2GTC4uQlJD1404/avvIPnRb7IiMwB8kKT1q03opn5u/bh8phGwTrMSEQRQc0x9fVL9XvBq0YQWy6mYxRI9g3Yluh/wUQzqSyqdQsxCkupOOMj+CJHRmeLa4udOpL42Q631UNrOy5pDSwaQWPjNs6Og7SbJB9AeinNnz/XB7VX0aF5Gsva7VwEvtVKcGCOeaTRl2WJJ14E/fx8DurhWT5+h0b5F1NDOQ2q5xUIk7bKYMN6LiBdbaj1rVXVD+B2qqTLvY88Z7k7PiIDMlJKg6lPO6nJfetjFcbc+qIGW6EbGwY/sjN/FUcITxP1oRXf0ISUcEfduZdKQTfN7H26yTrBeoXN1Gjf+/JrLBEXfUsaoqD/6uSeuUuXAaoA6B0DYTb+XVEi5UgqhTU8qij6AC1GIn3O9USKWoiYBuUb33KkDS8O38ZbnuHtcP1QvELGbQEcrmljKlvX3glxEZ77s5u9MPbJ/8A6vPLyAwF9+xJYrPyE5bEw5gItENsYnXJZ0LEpnrbvF2WC74RLLDETQ1xlD3K2bvZzPGGetxPUKRed0i8pin57ki/M1BHMC8OFifjmK1Mo5MkUGSca+fswUF+tScspdVJkDFgaTGq2daE0Dyw8j3mgzbelYVBiNSpH+ZpSchHmMPiDhxrV5SikjZL/428f37SImqCCgSSFCa227ose5OTvFcwIOg15dULEakOE7B6Bnk85gfu8kcmbGl9BrWwGgKZ2+CqaeJwnBJY3Zv/y623nAFZqI+6PWTK0JWyInhU6dwpKuoH29e8y63nLjSsCgFeqSjT1HGPZgmEmU4E0WlOyFRnMVy4DomTD0Jycs++8Nj+9HwmEWyarhuf8SiKAo/dPD/PKqBCB2V4LPQe2QC96KqVWTGael78sktS6t1x/4QXrQlAclVkF/
 P9pmahF2
 Sc0OEoSXrvWSZ2MN/tIftAjU0kihTF9nP1YcZLIfJYitJbAkMs7zHPHjFSZQopBrxtaxfXi/GnP+ezyZzG5onEp/GWxlji/BPMaOj2zjx1+C52IOYH1hrz0zlqTh3kWzX4W9x+RxlMUM9eh+N5OPCKXjnZ2Bpk4Tu186Ld/XCDDgxFav+i6gec31pByF7tbf4X4wnKazvGOubn78s2sXniudnzruU+hUneHZgBr2BDjrzM1429cL1wbPujzABt5bXRNyjiY5DqiVqynEd2i/xZ3iaYDArHzbgqG5gKdp9vh6HUHI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Apr 2026 16:29:10 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> Sorry for missing the discussion before sending out v3. I was too
> focused on the code and missed the context of your questions.

No worries.  From next time, please ensure discussions on the last version is
ended, by replying to questions and waiting about one day for giving others to
chime in, before sending the next version.
[...]

Thank you for all your answers to my questions and requests.  That all make
sense to me.

> 
> > 
> > [...]
> > 
> > The code changes look good to me.
> > 
> > [1] https://lore.kernel.org/20260327062627.66426-1-aethernet65535@gmail.com
> 
> Thank you for your review and patience.

You are always welcome.

> 
> [1] https://lore.kernel.org/20260403052837.58063-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

