Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB6CA10F3DE5
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 18:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E097D6B008C; Sat, 28 Mar 2026 14:06:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB97B6B0095; Sat, 28 Mar 2026 14:06:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCF726B0096; Sat, 28 Mar 2026 14:06:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C09F76B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 14:06:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4E4021A0129
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:06:34 +0000 (UTC)
X-FDA: 84596251908.14.17887A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 776CA4000B
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 18:06:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iKkYEKue;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774721192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGkQOj7xTiGl2lg7LS/hQRZ8cLUiBkHJzpWswAlYUJA=;
	b=VHfnOFX60q2raO/pJVz316P7Dcp9jG/e9Mtbb7qOmI/X2JegLwlcExsL25d1njnvuveIu2
	exuCVQhbWTgAN0QUp504+H//omuKo4N1P/EVEFt708U4HHRndFIRBker0smNzDFWjm9vfz
	4l4v1mY4ZTfJV8O586TnNml9sM8okVY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iKkYEKue;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774721192; a=rsa-sha256;
	cv=none;
	b=g0uRnHVwEIyDp2RtjzAuJwPXh/+6OGx/upM9/K2Otzu9cIvWpI4fsfyUmOcjUtVsRxgBKO
	iyP+hm/RwnldK7kFJZ/DLkmI+jXYx3tcYcBhJTYtLqTBWHZTnAqJcIKAYTcfFwSqfSIiFA
	qby+GRfGd1PCF1VjC/QUUkzUebid5uw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B086040495;
	Sat, 28 Mar 2026 18:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741D6C4CEF7;
	Sat, 28 Mar 2026 18:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774721190;
	bh=bPs9tke7nQbYZIsrIsj71vZ4XdK66k9kLYeKFKb62Zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iKkYEKueqRXbP8h9DprgeUd+Y2/fbNYkGdLCRPoTjbI0Up69C+1TzXboKuvQ3Lc+n
	 Bpia6Ytj16VUednqyWu2sBUut0MSPwd/ZSXFQji9OCOHo7w/ta+qA31ZSQFmw28Sga
	 9A9uLCWMamzTA5UMGt02B/24Zmt3/1aHwLSBdrwjh/SUJEO7TDpuI9+lqHVV/YWvdP
	 77lg+Dxhc0P8Pb5Uj6pI4RPv6PHJO8mcSgdUq72H5g7D3vqxuwj6eApEifwNxGHOEm
	 BwI/VM691arleKuiOfOzLeXKeTVQh0TavScAAJsqkPw4fXJx7T/VlR2eXEGV7fSCrO
	 rQo5ko1+W4xHw==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon: validate addr_unit to be power of 2
Date: Sat, 28 Mar 2026 11:06:28 -0700
Message-ID: <20260328180629.55498-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328174409.6786-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 776CA4000B
X-Stat-Signature: tjaty3ebs4ibxgpznq9yckx3mj8z7cy3
X-Rspam-User: 
X-HE-Tag: 1774721192-417265
X-HE-Meta: U2FsdGVkX1+BZ2SVCZ1UgAB3VKSl142FLjNg4T3UFD1NqE8VZcNjtMDPTyAzSrMZaIIJIeky72w92lR3Y0aDwrNpPnRA9J4UXW+dwLZHLY0BG6fBvqApCruZwYlXdXwzB0sQHP+vyBqlXRZs/rBQeFDr7hLvXZedq4YAMAkrMN/tuwTNdl3Xnk07L9swflIxSuKsKSjLc8gwcbE+CdvhbhMF0s78k79Ta1L2zUyJe2DCq8OHeECivNpKNdSClVSV4A8H6Jur556ssUnj0MWwI04R2ELzs2EMv65macC2/41HAh78Kef27z6U6Y8ft+rJ31nLYG9Rww9ZwMU1PzxyUxN7eJWQX0Lqx9OZD8QFA9qdgt0h+Rvi7BJx+UByUBTLtdRVnFSB7/1iPrMZf8sqI1iHKweft1qMu1VAnJvRpVC8gyp9cN2ZaHSe717NILflKL+PmBTKlkQXOZJR9b2dFsy9x/5z+8vRVsj9Bpe48bREaDo4IPxxh15WAchRY1LnlsGXpCi21/imVfTY1+DR3xK0tbdlQ2q5+7Hz6DlbRhmTjCYt3I9Gzlk5Y3Oi2N0oA3NVY0pU04yUXTu2nf8z+vZi3adEP3by8MaZen0geDntXfmD5O/uYNuWffsQiaXIFkBXdT+GFhKNmTmw1S4C68yZzd47tZH8hpBZZ4zGitxM78t9/iT82E4lCBOvB49tpsV6Hgwk8HljOj/JGMJo2Z+haMa+ROauLP56P8SCEHIVpzUK+oqmLbdw+E4npmEs6jCAoR9fABdQel0ZfrV820Z2PHAiXj9wUarVeNnEbU/ClnJ31h8u8ybMrTrIFj2yCgBGs5Y9T8YK6X6RDPa9xjRhMquhwynlO53cxF3CnWw/vx3t5uwV0C+T9eKNUDxnOlQzSlqLA0eTLfQ3kpR6Ol+lc9VUV9FCWalxu/UJLY3hJ+fF81IQuwwXqxEVsQc5+HxzMHS+3qLPRZFnTeS
 5du5ohDs
 HVj1H2tDUCgSSxgu1Q3AeGiOeuUtyc072/HxAjoWn3ydTduh7M0A6r5izvCbBJAQF0ral8W+mXz5ov/19dci8v0RU6EqwbFZnHRM94VwmsnaEMlmDhOHRgx+GH9XUsR6hx3R4k33QQGSwEAT7TgPS5o8Qemf6UIQeXklSXGmTZDV7LivtwMAleAnEdWkpg8qFoilDtCJ1tafXsZq+W1m6fbGpUQ4EJPB1SxSi/PZHpoeIl+EwpZDF6b9S3kiJ1H6/kb2k+bIxyA1wt4MEuK1ISX/9sNRbV0VMkejIzrhZ8SVQv/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 01:44:09 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Sat, 28 Mar 2026 07:13:23 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > > On Sat, 28 Mar 2026 10:26:51 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > >
> > > > [...]
> > > > - Would a lightweight fix be acceptable? For example, performing
> > > >   validation at the very beginning of damon_commit_ctx(), and returning
> > > >   -EINVAL before setting 'maybe_corrupted' to true. Since no
> > > >   modifications to 'dst' would have occurred, kdamond could safely
> > > >   continue with its old configuration.
> > > 
> > > I suggested you to try something similar to what DAMON_SYSFS is doing.  But I
> > > didn't get your response to the idea yet.  Could you please let me know what do
> > > you think about the approach?
> > 
> > I was thinking this one more time.  So you want to ensure DAMON_RECLAIM and
> > DAMON_LRU_SORT not passing wrong addr_unit to damon_commit_ctx(), right?  And
> > that's required because exisitng inputs validations of DAMON_RECLAIM and
> > DAMON_LRU_SORT are not checking that.  Why don't you add the just one more
> > check there?
> 
> Apologize for the confusion in my previous explanation. To clarify, my
> proposal was indeed focused on implementing a lightweight fix directly
> within damon_commit_ctx(), rather than adding separate checks in
> DAMON_RECLAIM and DAMON_LRU_SORT.
> 
> The goal is to safely handle the context state transition. Specifically,
> I want to validate inputs before marking the context as potentially
> corrupted. Here are two approaches to achieve this:
> 
> Option 1 - Using a label for cleanup:
> 
>     damon_commit_ctx(...)
>     {
>         err = 0;
> 
>         dst->maybe_corrupted = true;
>         if (...) {
>             err = -EINVAL;
>             goto out_reset;
>         }
> 
>         ... other code ...
> 
>     out_reset:
>         dst->maybe_corrupted = false;
>         return err;
>     }
> 
> Option 2 - Deferring the 'maybe_corrupted' assignment:
> 
>     damon_commit_ctx(...)
>     {
>         err = 0;
> 
>         if (...)
>             return -EINVAL;
> 
>         /*
>          * Only mark as pontentially corrupted once
>          * we start modifying dst.
>          */
>         dst->maybe_corrupted = true;
> 
>         ... other code ...
>     }
> 
> I think Option 2 is cleaner as it avoids unnecessary state flipping.

Liew, I suggeted two options before.  But you are skipping providing your
opinion to those, and adding yet more options.  That makes me difficult to
follow the conversation.  Could you please answer to my suggestions and make a
consensus about those, first?


Thanks,
SJ

[...]

