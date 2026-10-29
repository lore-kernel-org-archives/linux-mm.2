Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08752606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 00:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HIMw+WKY
Received: by kanga.kvack.org (Postfix)
	id EEE486B05B2; Wed, 28 Oct 2026 20:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E78306B05B3; Wed, 28 Oct 2026 20:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42886B05B4; Wed, 28 Oct 2026 20:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAEDC6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:26:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B14D1C31D7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:26:03 +0000 (UTC)
X-FDA: 85373771406.05.3BD9A26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6D2211C000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:26:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIMw+WKY;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793233561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URGAbIYsZmrO7zoKja8bTGELNEU0ptfP/g/LFZldzT4=;
	b=zQBd7J+/mrDnfQAxE4ez/KuV+hcLHl/5KATiidwrvNTtBAb3fTQU5LkfO0ml/YAK3lANia
	LQqJoONaSkrd9jH03upqCPoDkPTQhwodS6+hcE8caATWbGGDpNL6sE5cSbKuMW0BcakRqG
	cvrb2KoUMUzv439tk0xGXxpjc/EKHQE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HIMw+WKY;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793233561;
	b=KyAfMYATffkNslq45sNBPNTGId+74qFGO14t1oilbswBVPSg0ZNgFNuTED3UNaLJE/mZQe
	yOWOa73jC/7zf4KzW2xQYu868NyboPUZWHpi4OYX/rp2+0+yu4+OSAXKnzHGfyZfU0S3dC
	dN/jFv6Jo5MNyAFieQBImYuY8Nf7CpY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CF9F4135E;
	Thu, 29 Oct 2026 00:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A541F01829;
	Thu, 29 Oct 2026 00:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793233560;
	bh=URGAbIYsZmrO7zoKja8bTGELNEU0ptfP/g/LFZldzT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIMw+WKYWlwxxKQz7LcDPrgXPqVxDcT/FqKJqvHmk2595MJau/O1w/72iQxQuLlCr
	 vVafhsd/P8N0KxtKgB44wU7Hwh/N0Ycxa8dNsu9mCmsbc6nK/QgqcS3GMz/iS+AEpF
	 mMrbVRTyJz7H1Xcbpgs07hkb3LiRWvbTXIWuSJOFJ2fWKy3jZhuTMEgL25j3W87mHG
	 T6ykjpTgiLgQKP8Amho5YrPl+29fgJjePsxW95Cl24SgHrYrCVWZuO2iR7B4sEs4XR
	 P8k1V0CCiDf1FiZRQHgTOAKsdsRB46afd+QxyXHuG364RrNn6KZ9vTI4dp0ieKxQqI
	 37x52cTfuqDIg==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	corbet@lwn.net,
	damon@lists.linux.dev,
	jm5905938@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v2 2/2] Docs/admin-guide/mm/damon/reclaim: rewrite complex parts
Date: Wed, 28 Oct 2026 17:25:52 -0700
Message-ID: <20261029002553.167065-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <e68efe96e67c8b72047f2ab01c874026cecb025b.camel@mailbox.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D2211C000B
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ou6phg19pagfrf1ybh3aekfatyfdcnft
X-HE-Tag: 1793233561-49941
X-HE-Meta: U2FsdGVkX18KxUoTqks6lj1jyRugx1QSH2KZFJRvh/V5L7c+2uPb4P0u+ojFj202m3xU/AQOKxnlmZEFc6kDdbv7Ir9ZXUUsBICFfwczjHEB0OW9lZfD+lPXvpxbcc5T0dqom3WwOe0Fz1f2wAjc/hy6KIaVQN5mXcF5mQoASKElMPrOkpADBujp9oelcBIxqC0kupL/1ZmzO1Xi3ocZFwOhXK0tY4d1qt0Cw0kimuBN1pcwcK1iX/WlkfONFzYFjLHCC6tnVcuJReCCN4NiVds4IiV8/YpW8hJRIqn9f0SwQaEXfI6jEa588PF0OY8pvReD+ymS/ZQnMcyIjtGZOhxhaDrMiUqZApSIAI15P78tLFDrXYUNjppmTexjeJy0Xeh8bukFbKJCsZK5VJrz3V1wEkwUJVY9i6k9Ws6EusZiKQu9zc0lkEqpRpuljj8+hARm6oKYL/TlhCqY9NNosNbcmgqcrnwWJv4zYC8cwkc43qpPhDsElzge+2iWa6qyj73rz+gBL+2Jo1O4yt1ijdOoIc86Kd6WkoC+iPPsgEb7oFd1GhNEQgPrZ0Bvq8gbfhLSXB7B16OB6Wqm0rFI6YXOP+wBOlu59BCW28fRYN5irE+HiJXGTmEUJELy6gRo3nof0AfGsEA2QTQELSbsnm1THlniJN4O8dkGWY1ouH188cvFV2DozpnRqgzfwHRpOn0qEQMgyaG8v5hVmIMBk7mpwdF/7TKlGxREgHwSU0WmlPsM4pixKHms3uYuIJCl0OmjK/JM/+ECr2xFK2qnz3s75fzprgbiBFxHBUuUGbSR6Mrwy/mFqWKoaDb6KkZgYwm6HA/DLuamLlHYWeJgD4i6M9RGUN5jeRykzoIhk+vwvYG2OEk2IeaRJiM720vOiRcOxyjvv679LcLnl6M3Cn5bmaGiA9pvX+VfLmnwY6uFY6QfpGCTaSRek/XJAGu3koHRGBXCyrxM/5gEDmj
 oX04miYi
 mAzM0XOIVyDGju13Epbo0GnYbtYvP4WvX9zj9n/VdPx0hEGjk5nNCHg8WWwg92UCnVr5pzQH5sIVpIf8o0Ry9XO4qoiW3ZBXI/aWtPQpC9cNBk6CAJCk8kXG0e4psQojLXKz5lKDqB3pY6G8btI0iv3EGvOdFOj9YS8N0cUgIkTtCEgZXXe7106lyGT+H4rbRVJsFBmNWhZy+KZDQtt8eIJ4tae+v9XoaEDQ8kDfHD8Yy1wxHs8YJHdPFJlrJmA4CH00ikMrbyIBt7u8NyGEkEJqe6TWvCSdsJegJpkxkjaZFOxMIlQnNr8XQsvXtJq/UtgKusA5svvkxTXt5+T9PgBpvx8Uk/2BAwUz1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 28 Oct 2026 17:52:17 +0100 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Hi SJ,
> 
> On Tue, 2026-10-27 at 17:19 -0700, SJ Park wrote:
> > Hello Manuel,
> > 
> > 
> > On Tue, 27 Oct 2026 22:23:46 +0100 Manuel Ebner <manuelebnerli@mailbox.org> wrote:
> > 
> > > Rewrite complex sentences.
> > 
> > Any special reason to keep this as a separated one?  I think it is ok to merge
> > this into the first patch.
> 
> In this mail ( https://lore.kernel.org/all/20261016142921.126622-1-sj@kernel.org/ )
> > Let's do such rewriting with another patch.
> 
> I understood this as 'make it two patches'.

Thank you for reminding me the memory.  I now remember I thought it is better
to be a separate patch.  And now I realize I was wrong.  Now I think realize
this is small enough change that can be collapsed into one patch.  Sorry for
changing my words.

[...]
> > > @@ -125,8 +126,8 @@ quota_reset_interval_ms
> > >  
> > >  The time/size quota charge reset interval in milliseconds.
> > >  
> > > -The charge reset interval for the quota of time (quota_ms) and size
> > > -(quota_sz).  That is, DAMON_RECLAIM does not try reclamation for more than
> > > +The charge reset interval for the quota of time is quota_ms and for the quota of
> > > +size is quota_sz.  That is, DAMON_RECLAIM does not try reclamation for more than
> > >  quota_ms milliseconds or quota_sz bytes within quota_reset_interval_ms
> > >  milliseconds.
> > 
> > I think the original sentence was not that confusing.  Also, this changes the
> > nuance of the sentence?  What the sentence is saying is
> > "quota_reset_interval_ms is the charge reset interval for ...".  If this was
> > really confusing, maybe we can add "quota_reset_interval_ms is " part.
> > 
> > But, I start feeling we might trying too much polishing...?
> 
> I think the verb is missing or can you tell which the verb is? If you can
> no fix is required.

I mean, changing only the first sentence, like below:

"quota_reset_interval_ms is the charge reset interval for the quota of time
(quota_ms) ans size (quota_sz)."

> 
> > 
> > >  
> > > @@ -137,7 +138,7 @@ quota_mem_pressure_us
> > >  
> > >  Desired level of memory pressure-stall time in microseconds.
> > >  
> > > -While keeping the caps that are set by other quotas, DAMON_RECLAIM automatically
> > > +While respecting the limits imposed by other quotas, DAMON_RECLAIM automatically
> > >  increases and decreases the effective level of the quota aiming this level of
> > >  memory pressure is incurred.  System-wide ``some`` memory PSI in microseconds
> > >  per quota reset interval (``quota_reset_interval_ms``) is collected and
> > 
> > I'm not sure if the original sentence was really difficult to understand.
> > 
> > I'd prefer dropping this change.
> 
> That's ok.

Thank you for accepting my humble suggestion.

> 
> Will you handle the final edit or should I send a [v3]?

Could you please send v3?


Thanks,
SJ

[...]

