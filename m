Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D5F1C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7344F6B008A; Fri, 10 Jul 2026 10:16:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70BF36B008C; Fri, 10 Jul 2026 10:16:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621D46B0093; Fri, 10 Jul 2026 10:16:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3ECD46B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:16:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9327A03E6
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:16:40 +0000 (UTC)
X-FDA: 84973067760.11.2CD3012
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 24E511C000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:16:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KahqDGrV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783692999;
	b=6GI2uAayBmdutxZ3qFKZjpIF1kd5+buBDJlyFVLbr0+PSUrpyaOc0rwY+yLam1ERK1/ZE3
	oWiODxZXYCElEM7UWnoQSChj9LhVvbXq9SoUGtOTDinoSS3XlceuDO2tAXMVmerNhe63j1
	xdBZn8LPGs2F26uZSVAIZQF4NrQQy1s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KahqDGrV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783692999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QaIclYB8bbvFhsCZS8P52iBbwbOGPeVuy63rBC+62Yw=;
	b=O3RhAmjPYQiXYY06DJ7k/YMEf/8kP3+sKmaXbmFH286A0DRTChMwFkmMU250ioDDBYUysp
	WM5XODCOESDJVQlmewGT01fOMpNjS0D5XxHvfV9fDJ/cNgdGlKkSCPNyrNrrEIl4QwLGwy
	WIZMxUtaExaSfh/MSzAm36gy88JsdX8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0A766111A;
	Fri, 10 Jul 2026 14:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4A81F00A3A;
	Fri, 10 Jul 2026 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783692998;
	bh=QaIclYB8bbvFhsCZS8P52iBbwbOGPeVuy63rBC+62Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KahqDGrVB23ELbwXbfrA0bkp0js04Cm/Sd3I7TGV92lsdkdd7qyEbPwROUSAJSohT
	 NrueGXCoe7BiMBfiWG863Nt3bEJVBDn+o1o1baPQvxomFbSf9YoCp7N+OUBb2HxXK5
	 8dGhBMdmTWJAcsGjQK/7J/XN+8DJqg3e8Uot9jW9QZYxV+cntA9WGWqYgD416KLFSo
	 XSqHrta9v1gh1aCHEc5i/aHtnC//JoPtvqbfrI4bVlD1+X0MCOFR0axUKCHh8y73HL
	 u061aLt5n0t9FxLsZye2mR40+u8n4kgE7x50T/kNEP4WgdCzwielOjqAVRIbXi4Pj5
	 jd9IXI/6kzibQ==
From: SJ Park <sj@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 0/4] Docs/ABI/damon: sysfs ABI document fixes and additions
Date: Fri, 10 Jul 2026 07:16:30 -0700
Message-ID: <20260710141631.24657-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710044737.561102-1-husong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 24E511C000D
X-Rspam-User: 
X-Stat-Signature: gsgrkx1g1zdrwhbq3gze3sjs8nyyi7py
X-Rspamd-Server: rspam03
X-HE-Tag: 1783692998-301475
X-HE-Meta: U2FsdGVkX1/MoOzauCDUoq5FurZYKl206Em58QvtevcOViuYq8B+VVfRl0q2qwIWx4pQ9LNLl9C5qhQBDj7dCxwq+NCfoY/lEx0dQ7cBPXRj/LUcUTItVG7MfXVP9CmJnF3JWXuwT3NMysxplKI+PJbVkVnekB5Vm2aupjo1TQDM5l/WdU8x7CBLa7LVlsjxh/uwRTvWOJdz3M30upDLWhzuXh7oKJWhg8d/uOYSK7FvjXtoU1Z05mLtbiRz2kBG2NwJ2nm8ZMUi3gJirJnpa0kNnWHJzyV5Vd/uEq4a14P9foOSNHSD6Ncf/bzlzfo68imswPYAJiThHJxax8JPHsMYRHaqkGlhcabfCMBY5a0udvkPhy0MertOAmtjjynI4vBgHXMAphHYatbQxH5IBplEIS0n03qm25M7cz9SAdYGdk+BOgjpm3uuFkcpNUW0PfDaFPHRRZAix5QDUGq+G+6QzUV5anpkYVh7FLxs82OFBB39eGfO1Zkr5S34C5Iixn0xt1b/ep/Dj1KBp04PN9LHb75jKF9gAX/dv+S+XW9rpA4SsBB2bpWzSPmc7BxliE6ZUTSJ1NDZtf6Y9zuzatMXD5GaSMWIe7flSF4NLPYZGWpjhHkZubD3vmnGpXpSuDcLTb/4UnHbvn0N2lL2otAbhtO0JBMjagFlNPGzcoAHQ3RvP1mZcyQB544xRtBuj2bxntEkvVvqoI9LblDyJGWu/nJ9iPJ5iExTjLSUPmrZL8fgIwtO0L1CFxGUifM16ZCAv2ws3ef0Or/8ZpGPGMqqSbmrn+yDOfBCXTagY9G5vhfXgBoL+vsBmPRPegJMYVn1hKQQhB8iujHhUkU8xfRysEsqwsNaACRlnScvL1UJYGYj0nxCxWelF6OsY/96AoM4n3Pkd3QODHbjTl5x6xt+jUypIvOVCnRHZJhgoO2JPX95piDkpOkYIwhoGBFP7w0t8d9p7L/MzJxXu3C
 QOnBL+Vo
 qARSaGkE7Z2vbxZouJOR48uh3qDWprXP0PLJ1/sugHTFj3Um8NhQ1aWgpBkqstzrtFbJBiWrxvYaW/o585ltctpHGAQjT/aclbkfzNEG+1HurwTqktFX/G8+tVAjAGXHFLaC47ndjzzCe93amHAUbFRvJAiPJx1bIUvOvB2CWEb3KWEDqdrcvbjj/NxDyGP0cR+tMeW7sM2ePBruqI1DUtZERb4jUWrbuvv3cH5getax8bAYFE1OT21LBYOZhefmn3pI8Re2zZNsnwdTu98hrPeNXiJf+7OqGT1nJBcmGjY5UffkicxR4gdagEJ712Pq7EweXvBgPA3wyNfAS92777lwhCtyTmdS9JjfYbwz+NEziOFeu22t1wDkwoqUN8tvs7POSBKgjp7CLPjn51erXmRi745CC0q8S9TkA1YOItKAZefriz7u6BQOtDhqkDua+rCP00lQbqosm+CMlv88vgZmIWqKGvZRSzLBLmblit+chK4m4ybqztrR/Yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'hkml patch check' [1] says you forgot Cc-ing below people who are recommended
by get_maintainer.pl.  I Cc-ed them.  Please Cc all recipients who
get_maitnainer.pl is recommending, from the next time.  'hkml patch format' [2]
could also help you doing so.

- Andrew Morton <akpm@linux-foundation.org>
- David Hildenbrand <david@kernel.org>
- Lorenzo Stoakes <ljs@kernel.org>
- "Liam R. Howlett" <liam@infradead.org>
- Vlastimil Babka <vbabka@kernel.org>
- Mike Rapoport <rppt@kernel.org>
- Suren Baghdasaryan <surenb@google.com>
- Michal Hocko <mhocko@suse.com>

On Fri, 10 Jul 2026 12:47:33 +0800 Song Hu <husong@kylinos.cn> wrote:

> This series fixes typos and fills in missing entries in the DAMON
> sysfs ABI document (Documentation/ABI/testing/sysfs-kernel-mm-damon).
> 
> Patch 1 fixes a path typo, "intrvals_goal" -> "intervals_goal", in
> four What: entries; the documented path points to a non-existent
> directory, so it is Cc'ed to stable.
> 
> Patch 2 fixes two further typos ("WDate:", "manimum").
> 
> Patches 3 and 4 add ABI entries that exist in the kernel and are
> already described in usage.rst but are missing from the canonical ABI
> document: the 'update_tuned_intervals' state command (patch 3) and the
> 'tried_regions/<R>/probes/<P>/hits' file (patch 4).

Looks good overall.  Patch 3 looks unnecessary, though.  Let me add comments to
each patch.

> 
> Song Hu (4):
>   Docs/ABI/damon: fix typo in intervals_goal sysfs path
>   Docs/ABI/damon: fix typos
>   Docs/ABI/damon: document update_tuned_intervals state command
>   Docs/ABI/damon: document tried_regions probe hits
> 
>  .../ABI/testing/sysfs-kernel-mm-damon         | 29 ++++++++++++++-----
>  1 file changed, 22 insertions(+), 7 deletions(-)
> 
> -- 
> 2.43.0

[1] https://github.com/sjp38/hackermail/blob/master/USAGE.md#checking-patches
[2] https://github.com/sjp38/hackermail/blob/master/USAGE.md#formatting-patches


Thanks,
SJ

