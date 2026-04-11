Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCB1F3ED50
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:33:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E7D6B0089; Sat, 11 Apr 2026 12:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FFCB6B008A; Sat, 11 Apr 2026 12:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914E66B0092; Sat, 11 Apr 2026 12:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 82B326B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:33:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E1F813BCC5
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:33:56 +0000 (UTC)
X-FDA: 84646821672.27.4EF7F9F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 66C2C4000F
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:33:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jMtDExXe;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775925234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iva85vmDNb3aJ+N9xgxcpveFqbZ0Oc6lxIOFhE1AFqk=;
	b=ZyPPEYeLrIEZjzvj7dZxSmwpo61USalC0uWSBuC2MmjAwKlx4xcMcpznHwJwgYj/rETMCN
	smS+M1QtiGbXevoCl6B6LfKgkwc286QWN/n4qa5Uc0/86dEUPqoj3Q6FhFfDWic35c8+/O
	FjYcp/0gBJ53WH2iXmqfbwh+O04q35A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jMtDExXe;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775925234; a=rsa-sha256;
	cv=none;
	b=olNKnBh+8FZ/SCQV8xTkfUefshmDmAy24+MnceBSNTw6g+8jIlLne+hUgGTVF+U5abjo9O
	UxoELCPgVxuubKP2A+v4h34sGJOxyxaHvSjoKtWWM+MQ7EVksZSa9qVUCJqtQWfVXgkons
	ysrl0Tk8u2CyTsQbXp6O3uny4FAZPjQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 29CF442DA8
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5762C4CEF7;
	Sat, 11 Apr 2026 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775925233;
	bh=EpJ7cnZvULwnwdpRqje5W/TcK0J3y3KDLXRPTpMJC+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMtDExXefHWh9g0Ufr77FvXAmhFo7mMZG1sl1FdQCiaEls21Pt+1w+hADIokQdUqE
	 2Yd3N+tSItyZzwAiJAvu46jafblC9wTsKy/Jk3r6gFu1AhU9oCfSDxHkCIKKn302uI
	 pH66J8UPU93wF/vQckjrcwVQP/O7O4WVCEqqZNgaDsVavzuXX/tX1IW9B3r78pF+mB
	 6R5spZT30/9MCLTwUirjviFHn4ZFddO1BR+Src4Pm0hU5iQhl/IDTrd3ijAJY/Gd/O
	 XEH7S+FjG5E3+PJ1DOuZcMpiZJ749E22GR/SL/b56XrrffQrb4dkoUubpOLT6QCJH6
	 Wnuxfd+KuMMFg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5 02/11] mm/damon/core: merge quota-sliced regions back
Date: Sat, 11 Apr 2026 09:33:39 -0700
Message-ID: <20260411163340.46397-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410235527.90900-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 66C2C4000F
X-Stat-Signature: 3m8un9j3e3ac3aafo3cruqqk37pw144c
X-Rspam-User: 
X-HE-Tag: 1775925234-830755
X-HE-Meta: U2FsdGVkX19gJkSVaLDJl6wPB0s7Ct+RPokGgJHH4bLviJAZ7Fk7aoUNcMGPCeavlejfpnCJud4tPGn1cPq2Fa/mYXAHPGMPnVndE00pqNb57OpITJsgVPx2NmKPbIjcdDsJG41KGSGrghEPp62pN4+nE/GKBblwKFhEvlvn6CZMp/shMfhhV8sIk5JpS2je9cZ26cA3n/gRQrz8ZVKBgNt67tTRpx7JdG3IW9BWVESPUJjJXChPh+P5K17wAlQUfQCRduit3WDZObo4mGiA70Rg74I9zRNMPlP4RRBtGMTQCXat78Yxbp9OpkmafZEPS1MDmnAar6DtkOsnoj7/E+4NTxslJ938XFa/57WEFkuweL/VTSO+npR7INe7WLD8pLYvnZW2gUxlo47vknI9OC1T63loQZ29v9T2raV4SrTbSrJbqbmTzy7V14LyxbdREWsJepdcNd8bz+Ti3x4RysbIfK19qGydZrrkBMkXdWkMCHDJnj8TBLtjdo3FjVIULsu83i24IwgGokljHKqoww0WKInbrG+rekL9WlgOUdZxc5eNFMcwa6r/6cwa3NeyMjCBk1/ThWaovYfQb4PAxAisbPDHF+ZgWzPz3fFrGHEMM1PqtYFvG+GfxFR8m2nzS3LJoQn5vfh02UJzWUCcR2IoZRylw/QIHKjOHIc59v8iuEwQ/MT3Ofv6C/wNP0nZeA4tynZJtFLTMyXdw25V1Ri5hwMJM2RY0Xec9Xc1QY5hWa98fVnIerdHzVGHXYriqXRzpV2C1Z43ctOVlLKA9X8i2ZKxAwmHiR1Fl1RqYIaHrTgvc9FbxCxCakRXpw1WVL4OvqAE5mnfCLJ1JIBEbrUpC4zDADoXR9pLf9bwDUNA/i95LCpOn8dSm168JgJsN3CS8Q5cayqHo2GZopJs0/47DtQjqWRgvyA6wh/ALJg4fccVnrI3k50HU90uTBwfYdo42i391WAWwSi1IGW
 7WoN/90u
 C8b/i8VK+khLmq7U665TYyn0eTTIOC2clm4t9HRVp6h6kFlYts1Iip6khYAFKJ/mbiaOUCu6uVPosG8GFjBO9A8PuLIeBE5jATc0JN0marLS79A26S7O3uy4YIFx/X3NUtLqgutz1YpOhfIKbkO4vShM+inBU15qczNCUQnFDyFBDoNtkZc4ivyRjJAHePvEMCzZ5+Ig3EE9hzjsB2mglZ12Z6WxyUNag8DWu/kbHStzuRIwtCQL2SUl0qMWtyt2lkrDOx9ris1mXrVT87c7lvOGDRQ0zd9QOU7GgKnPH4v+U7TI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 16:55:26 -0700 SeongJae Park <sj@kernel.org> wrote:
[...]
> > Should the merge condition verify that the contiguous slices share identical
> > state before merging, perhaps by checking if (orig_region->age != r->age)?
> 
> Good finding.  I was thinking the scheme will anyway be applied, once the
> quota-split is happened.  But I was wrong, since DAMOS core filter is applied
> after the split operation.  Also, age is not reset if the action is DAMOS_STAT.
> 
> I will address this in the next revision, like below.
> 
> '''
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2439,35 +2439,32 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
> 
>  static void damos_apply_target(struct damon_ctx *c, struct damon_target *t)
>  {
> -       struct damon_region *r, *orig_region = NULL;
> -       unsigned long orig_end_addr;
> +       struct damon_region *r;
> 
>         damon_for_each_region(r, t) {
> +               struct damon_region *prev_r;
> +
> +               damon_do_apply_schemes(c, t, r);
>                 /*
> -                * damon_do_apply_schemes() could split the region for the
> +                * damon_do_apply_scheems() could split the region for the
>                  * quota.  Keeping the new slices is an overhead.  Merge back
> -                * the slices into the original region if there is no reason to
> -                * keep those.
> +                * the slices into the previous region if it doesn't lose any
> +                * information.
>                  */
> -               if (!orig_region || orig_end_addr <= r->ar.start) {
> -                       orig_region = r;
> -                       orig_end_addr = r->ar.end;
> -               }
> -               damon_do_apply_schemes(c, t, r);
> -               if (r == orig_region)
> +               if (damon_first_region(t) == r)
>                         continue;
> -               /*
> -                * If no scheme was applied to the sliced region, the age of
> -                * the slice ain't be reset.  Don't merge that back.
> -                * Otherwise, the monitored information of the region is lost.
> -                */
> -               if (r->age) {
> -                       orig_region = NULL;
> +               prev_r = damon_prev_region(r);
> +               if (prev_r->ar.end != r->ar.start)
>                         continue;
> -               }
> -               orig_region->ar.end = r->ar.end;
> +               if (prev_r->age != r->age)
> +                       continue;
> +               if (prev_r->last_nr_accesses != r->last_nr_accesses)
> +                       continue;
> +               if (prev_r->nr_accesses != r->nr_accesses)
> +                       continue;
> +               prev_r->ar.end = r->ar.end;
>                 damon_destroy_region(r, t);
> -               r = orig_region;
> +               r = prev_r;
>         }
>  }

This could result in too aggressive merging, that can make the number of
regions lower than the min_nr_regions.  Actually this makes one of damo tests
fail.  I will fix this by using damon_region_sz_limit().


Thanks,
SJ

[...]

