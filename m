Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3AC3CCF2D4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 23:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C6A46B00B7; Sun, 18 Oct 2026 19:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69EBE6B00B8; Sun, 18 Oct 2026 19:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4006B00B9; Sun, 18 Oct 2026 19:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E92E6B00B7
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:07:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84716405AB
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:07:24 +0000 (UTC)
X-FDA: 85337285208.05.77B9116
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DC2C2C0007
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 23:07:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CDeFqf5f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792364842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S2GDaNmy/wVSfogh9oHukOtCd9b8DsJ0trBZHfkjrl4=;
	b=5T7ARLe1bDKEDKMHlZn6eYdjXFcB+eWGQuzR4at5CwhnBlPMkf2jUFQqD9j1eDyiSjK92O
	KPbmDg8ir583jKDcuKLxj4yNnBArPYejayFOAd9065+tDUR+7qdSKKmYyqq7indUrqma90
	ja0Gnzv5CpFK0Z64nAm1pUQkq3KtQ9k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792364842;
	b=AKSsF+cpx9c7/55bjo4cdJ3klb8ZnUVtS/VhUO6Xf3UBT7ZmDunRxQdpYGGPoMUwraCxKp
	Wx1vUGVRAOXRumC6OmmDTWSH6HfRhiaI2LX/fpHNXmT7fUe9IfuCkkpVSl6O73+FaJ/L8I
	bgQ9RMgRyMzBrtIFL7uBFeqYiNT5h2M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CDeFqf5f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B6A960D9E;
	Sun, 18 Oct 2026 23:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9BD1F000C4;
	Sun, 18 Oct 2026 23:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792364841;
	bh=S2GDaNmy/wVSfogh9oHukOtCd9b8DsJ0trBZHfkjrl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDeFqf5fKLIa5oRo22htq/OmB8KuGpT0d+Sr7DQESZKDA5ZC+fSj7KLEYgIowl0tj
	 7YB3c/Nwx1h4MFEHTNwm5dAjzja1BEO2nHWtVI3obExFCcDzThvHoJXPdCQ5IUU1WN
	 I6elIMskMWCqq6WkCmrqpAD7WfAYtOMFr0GHV0t0nUg565IgwJOwJSOqTIQJvPbFZp
	 JZrOsta3netX3qxKQ81vkfl5BpqsRRZkUZLNlM+Rjt0vf3+E/A5DrL35ZCv7omCMSK
	 hWkc9guVySn87ZC+tRhQ+yIEroyw1THZ2FulLLjLnqHIoEWY43qezDsjOMGZW24ZhH
	 TJXsBbTIRSIMA==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	ackerleytng@google.com,
	akpm@linux-foundation.org,
	chriscli@google.com,
	hannes@cmpxchg.org,
	harry@kernel.org,
	jack@suse.cz,
	liam@infradead.org,
	muchun.song@linux.dev,
	shakeelb@meta.com,
	ziy@nvidia.com,
	"Lorenzo Stoakes (Arm)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: Sashiko change proposal
Date: Sun, 18 Oct 2026 16:07:12 -0700
Message-ID: <20261018230714.160431-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261018224830.160147-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DC2C2C0007
X-Stat-Signature: 5waf7kog89utwhofw7fmjtnemt7tikm9
X-Rspam-User: 
X-HE-Tag: 1792364842-213744
X-HE-Meta: U2FsdGVkX195fHajaCYhuZJJr5fJaKSVVKwNycrcWreo3VEI1c6S6fw3RslXSq2whhC410h3SiGk4l0tT87lYk63fLONmgggZ8Ezhu1cDwnlmNDdTxkKxW6Dcvd/1aWer5mxMha/MMDRYGg79mFcE/krBnrkhGXTmH//I/j/XoS8QShrExRqr5ZwBwWLZQz/7W8jX/x3mImuGnubOJ80sZzNxSwumeKJpuW4Z/8YXCWLrrUO+gEUxJRk3P7AuMZ2CbF0jIH/6P0nrtuCqpmZYbZUiZUR7nyHZF4Gp0itcvZIDoZ9Sb5XRG7RHxAvqeyR3fL6xv47D9cerYfUQy2JqU9x89LlbdKJ00lfoxRAtIKzThpDPABfTp0KgoLEhdTVAgTznQLyp0QRvZz9mbaBlZRXrcZddKnqLSzaBekG7793PZO3fa72CVsLZa9TdbUyN4xNnxp/V5DOyBvAlMATk8GnuJ6bYdDx4Ep/dTxZqmRppV2iuHG+PfGGDLhoV9xLhiUmu8cYBMnQAwFLCriSEjzz4Qmja3aHpuETlCRRuL777zoX9S17KyEDPP2Ytbd5ZBMwpIqqE7lbmm9A+vnkwWfDIFEn++xm7MYsPgwGdo3TRUMF5uzLv1cHSjQxNJmE2kQH5Xz4xdt2vMIiixNAq3uc0mXax1B9HICWtmUnJ5OJ5AGhMxqQUOHLDoBmNzyOq8JtD+g3/2h59IykcEkOipQwGlZQlxCx3pGNYOUg+lFGB7pQ2mzntW2ZlCBXHCglo5aMbE6PP0LZUb+3X2bBojI+/+pdjGxYfENFD6rM/abPhilD02M/l0uqWSkMvoTVBCDIEN2ToOs6Z2SXguX/eIX0KuZgsYWuKP1MMHpRflh5QzvsIusQNhxp8+QOx4QjYgMFRxGRuBb6SOzLOsFB0wNr4AsU22SprcrJ4an+HevIMnZbUcyachX6C8WIK66GXCdocAPu6Gc0VtHWi8X
 gHrnObfe
 NpiUbHKmX1kc65fixtCXFBci+emz6JpY/Htu5QCyRJu859ysY7ouiBNJV42ydTh1/cag9cqd49hgZBGuwqIN+6edw1dghLAYblMv7qB9J8S15FkjITv/YR9yyu+noimUwMjibN10hCaODF6I3PVx0jnPKZ0iEOdWNXa945hE1QJ+ZJ6s2ADQWdHnhKod8CKSQWsjQ7NV+8v5y9qqr62spDIzCjoOxuohCkyuOalq2sG5nfjWlBw1SsCZmuo6EmcIv+fh4/EbxdWMxRLLztW6VAYy2sCIm9fxau4wVkBJCCWnjlZfSjpB9q0/x+gn90oVpGEEeCM9g/Qs6S5sP+Ayz4p9JaKtFvqyoDfoudBfgVoaAt5luvmCOIe8glFMR5tOVWLY/ueZtg0KYLKheyQAtWUOtW5fIldoxaBN9ghcMVmCDWq+vVTN7zUrfEu76AJHBlutYQPD0wz5emkb5yY7xNtIVYBFYE5WGTp5kes+Xchwm5A34JQunP9iBpdCkxjkpS50xTWfu8htiXt/Sd0bpgr3tDoLGQVbrXpp2CS5SGcU341KDuJda4va9Sr1nomo4AhTT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 18 Oct 2026 15:48:28 -0700 SJ Park <sj@kernel.org> wrote:

> On Fri, 16 Oct 2026 14:39:49 +0000 Roman Gushchin <roman.gushchin@linux.dev> wrote:
> 
> > "David Hildenbrand (Arm)" <david@kernel.org> writes:
> > 
> > > On 10/16/26 02:15, Roman Gushchin wrote:
> > >> Yosry Ahmed <yosry@kernel.org> writes:
> > >> 
> > >>> On Thu, Oct 15, 2026 at 1:38 AM David Hildenbrand (Arm)
> > >>> <david@kernel.org> wrote:
> [...]
> > >>>> I suggest the following sashiko change for linux-mm:
> > >>>>
> > >>>> diff --git a/projects/linux/mailing_lists.toml b/projects/linux/mailing_lists.toml
> > >>>> index a9198de..ba123da 100644
> > >>>> --- a/projects/linux/mailing_lists.toml
> > >>>> +++ b/projects/linux/mailing_lists.toml
> > >>>> @@ -46,7 +46,6 @@ ignored_emails = ["patchwork@emeril.freedesktop.org"]
> > >>>>  ["linux-integrity@vger.kernel.org"]
> > >>>>  ["linux-kernel@vger.kernel.org"]
> > >>>>  ["linux-kselftest@vger.kernel.org"]
> > >>>> -["linux-mm@kvack.org"]
> > >>>>  ["linux-nvme@lists.infradead.org"]
> > >>>>  ["linux-omap@vger.kernel.org"]
> > >>>>  ["linux-pm@vger.kernel.org"]
> > >>>> @@ -315,3 +314,7 @@ reply_to = ["author", "list", "recipients"]
> > >>>>
> > >>>>  ["fsverity@lists.linux.dev"]
> > >>>>  reply_to = ["author", "list", "recipients"]
> > >>>> +
> > >>>> +["linux-mm@kvack.org"]
> > >>>> +reply_to = ["author", "list", "recipients"]
> > >>>> +embargo_hours = 24
> > >>>>
> > >>>>
> > >>>> Which means:
> > >>>> - Embargo 24h
> > >>>> - Mails sent to everybody (author, list, CC list)
> > >>>> - No positive-review ("looks great") mails (default)
> > >>>> - No other static email addresses that receive a copy (default)
> > >>>> - No additional ignored author email addresses (default)
> [...]
> > https://github.com/sashiko-dev/sashiko/pull/699/ , landed.
> > 
> > I'll roll it out later today.
> 
> Now linux-mm@ and damon@ has slightly different configs.  damon@ has no
> embabrgo but send mails to only the author and the mailing list.  It is a
> faster but narrower-scoped delivery setup.
> 
> I was assuming linux-mm@ side change will not make any change to damon@ side,
> but apparently it is not.  DAMON patches Cc linux-mm@, and seems it results in
> applying linux-mm@ side setup.  For example, this patch [1] got a sashiko
> review, but it was marked as embargo on sashiko.dev.  I found and clicked a
> button for releasing it.  It resulted in sending the review mail to all
> recipients, not just the author and damon@ mailing list.  Correct me if I'm
> wrong.
> 
> Could we keep the old behavior for DAMON patches?  For example, let damon@
> setup to override linux-mm@ setup for DAMON patches.  After a second thought, I
> realize this would be not very simple.  Identifying if a given patch is for
> DAMON or not is implicit.  Maybe we could see if the subject contains "damon"
> keyword...?  Still not perfect but maybe work for most cases?

I just found sashiko has a feature, subject_prefixes [1], which seems designed
for this case.  I should have read document carefully.  Based on my current
understanding, I uploaded a PR [2].  Please let me knwo if I'm misunderstanding
something.

> 
> For now, I will release damon@ patch reviews as soon as I find.  I don't mind
> clicking the button multiple times, but I'm slightly concerned if someone might
> be distracted, because DAMON patch review mails will be delivered to not only
> the author and damon@ list but all recipients.  Please let me know if that
> really distracts you.  Let's find a way if that's the case.
> 
> [1] https://lore.kernel.org/20261018220253.158238-1-sj@kernel.org/

[1] https://github.com/sashiko-dev/sashiko/blob/main/MAINTAINERS_GUIDE.md?plain=1#L60
[2] https://github.com/sashiko-dev/sashiko/pull/711


Thanks,
SJ

[...]

