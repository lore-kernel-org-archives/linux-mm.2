Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9AEF5A8B6
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 20:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835EC6B0088; Mon, 20 Apr 2026 16:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E69C6B0089; Mon, 20 Apr 2026 16:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4CC6B008A; Mon, 20 Apr 2026 16:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58C3B6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 16:18:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDA45BCAE6
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 20:18:18 +0000 (UTC)
X-FDA: 84680046276.17.5508888
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id A32244001A
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 20:18:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=N4n9Skxx;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776716297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iu0T6TGCkXYKWwEMylQaN73AMHLmcLO/paZjNPSUEYQ=;
	b=S3B3UCjfpsCF7StYU9lOp18MftnztDdrE/rhMloFBsTJjyVKpij5nPAqev/PB59IFfZlEw
	bNWvOk1kHl3QvfN+F/XBEJtZb4yBEScqrQrAEjzKyeozgm6JN3MhMbzvWG4dWN4xWEtUfn
	P9NsHHMzJ311tmMmdwVjz7MFal7cbms=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=N4n9Skxx;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.45 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776716297; a=rsa-sha256;
	cv=none;
	b=IYqy5NRXwnrCAz3EJQHXcXb/qSbNCg8rot4+m9ygWVXdrNpgvE/nRsHQHei9+m/FQ6Q9/U
	aKtvT7sYu0zZzr87phAIM/qCs0Jir28zMfnGVEcaqjpeK/sNh2ck+rT4y0o91YZupIzqNJ
	0SVuEafDXvLfa0mDNRyyI9+7lkAcW2o=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8aca2726f61so42922586d6.0
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 13:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1776716295; x=1777321095; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Iu0T6TGCkXYKWwEMylQaN73AMHLmcLO/paZjNPSUEYQ=;
        b=N4n9Skxx4LFtloKTJgPt1iA7DoBcBDyrwxWpMThokc4OSNEPfkUFlX+La9Fnc8zr2E
         BlQs7PlD7TGNFo4/CJpCF/FMUd3u1u3Sd2TO+cs4MQVhwS930nohL8OsnfJgKMkaE0iA
         HhHCgGUWji+oLoOpVSn9tYqGnpV7jOpMpTSMGY45/E90LVFe0pwovVB66E5HryavPL/b
         NQEoTjssG9/tK8apmOlGF0SYybdpVo3qnQNpmUhPNSDTsdpsufrUaszWWYA1RCRi+8IS
         iHcfFFDRn1L6OJ6Wv8r2yISfC4n8+pReqZP3wnbucOzbKucVSrj8XaQTKlr3tsxpoqz6
         g6cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776716295; x=1777321095;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Iu0T6TGCkXYKWwEMylQaN73AMHLmcLO/paZjNPSUEYQ=;
        b=ZLveOenqFrY7E8KD3rjTWnSFxD0Eoe8OSBSD2tEgtenYGp6Ih6fSsTPqXKVDV1T4tF
         b8Si+mosLdY7dt7mqsrP68P3R6sKj+Cvoe1Q2E5AczPCxTixYav2v1AZ0XhPClM1Hz9R
         J16lFKHOzSeg70QRNMGg5DdhQsSaqV1Gea4vTlnKO40nhYRv1mgjzYKOsV8ji3sm1xj3
         Nce6adW6smiUba0Fxzo4NkwewOu4W7xINf6tL3RWbGQksC6U2un33m4LDNB8Xlz1izgg
         2I9fUMe8mR1bLyBQ8CWjQdqXodjOdFcDJgSclMiJPdetfuOabTF4x37GbTx1aI8IXiId
         vt+Q==
X-Forwarded-Encrypted: i=1; AFNElJ/CFm/yINIvYmN03dShxCWgepPHuctoXPJg1USC4fS1+X9UEWnC6YwwofSz/VE5tElLP9wFhBPt7Q==@kvack.org
X-Gm-Message-State: AOJu0Yy1ePS03NMdzrnA+dbf5JqNwbNxd6j69Ove9sPgcWezac11nIrg
	pS6MFPAKvD6OyZo5lKQLTFinBnmKvNVOqKX9IvOeKKb0PNZgLDBE5eib9Wu3JZ0GOAQ=
X-Gm-Gg: AeBDiesRILdOthP0eH4ACr4JNO6mONyi5bakSmR7vieG3hF5rOF0w/BhuxtNjMOT5MK
	nA0wRB9mv02SR2yCkyDgST2nH99etNYPEt6Gzg1HQMXUXBZpO4Ha+Sj/poseibgI6x/uXmmKD8e
	Z6JKElwkOGfmCLQa+RsakyZYPJOVq3U9Oq5hUIfZV4VAgsshG3LR8ZxHrXFZwc6elFJcyaSuY1M
	YfAPV3V+G8dGoPsM18QZcsRHlsoQvZ6aPPqcCcpHuUR99+wH9pzx/KBvcFcOXg0SeN5DdEA7NhU
	kUkRceUcUB4uCv3qp6NE7NUBOenot6UotCxrciBiY3PbYdyBCqTshr/4zdeWJYsm7nBeidL09ZN
	2MBlT5RDR01f4k5SA4+4xBa5bPQg0llZ2czanN38lq2S2PedR4711SnA7uxUeGh5DjA3xw5jBqa
	evPKKqVM4KVosFvo/WzrQGP7d47yESK3vqWtcRJ4EB1QM=
X-Received: by 2002:a05:6214:2a46:b0:8b0:2d20:ff79 with SMTP id 6a1803df08f44-8b02d2100femr237889216d6.27.1776716295400;
        Mon, 20 Apr 2026 13:18:15 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b02ae97347sm84300596d6.41.2026.04.20.13.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 13:18:14 -0700 (PDT)
Date: Mon, 20 Apr 2026 16:18:11 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>, Ryan Roberts <ryan.roberts@arm.com>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] Page cache tracking with the Maple Tree
Message-ID: <aeaKAxrAUtfwM9ns@cmpxchg.org>
References: <biynsvpcamct5fva5nxxdvc3q43dqi72jotpyasvrk3pumdz2w@7okprmuwznlo>
 <aeKO6bKupHa2bgWt@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeKO6bKupHa2bgWt@casper.infradead.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A32244001A
X-Stat-Signature: 6wihjwwahwxer6szwpcknoni49mncj7w
X-Rspam-User: 
X-HE-Tag: 1776716296-984219
X-HE-Meta: U2FsdGVkX1+aCEDU9ccHQVf2p5bnadpItxD5cmpSPfZxcxT8KkVkMkhIVFlBg+cirwPhdNIu7WbaALuXEHBboox0NzDg4MgAlN1IMz75j/SM+WAHG9lhfCEC8JnLOY0ZsokJjjqCvlRzizviF6jmcEWgdXYKvgJXaPdWAJIxjJFgybLdC7qB5Ht2KyKiO8tTSgdkQPUk5GuYtJT/pCw1vA0tAOn6T9v7t+aHp+8qzZU6gQaMoMfrjuIkuH/XimcGyLZy63DbgwDLLTZ7/TAg0doMU9Z8UheFz/frn1SSIc41WZkGry5OdOJWqQQm3KiPeQt8v0oidt0fM2VDKL7QJs+RAzVWQeQUbgehm00MTMojvxIihEzSjlSLOOq2EINwPk0L9fJqU+fQDP9xeDOxh+iTjLCkuPg7mnBYYHm9gXQxG99EASmpnPnB4mXne+DRVzJvkX6+sm9ZpTdEVM7mhSOmxgCxC9Hw1im31PbvixBzy8VQHnPwIfTMT9sydI2xAZehvqX1/WWyBHyFa+zAK5ovGOjT5jhqufVDi/NQDSEOkuFGBIArSZ6YhSPE1va81Fbg3qpDmN3nEYKoyuTwQCUCF0H1BHgtFBLdpJzgkB4iqGSzuf+DPkT870vH5g+PZTBOVdtah/czXm5KLZQNdAGRAKsrhs9F2QFfb6t8aoZ8QkSvv2M0hWhoN1a5lPUiyTpcmzGDU/ICrYoNigOlU8smiLJhuTrwGpP1XYtowIhGtZzGMRBLLRaDUBcP00lFqYigjtAl0VrSCZBPWS05rvc2TnoIHUGvro6B/Jf53xj98GdrQMEJ9IApGBRcrJSPyS+XeszgxmgvZ3GMperdOnGYAT6Z6c6TxApZwt7c/XsiFKJbWIXwB7/YAo00Mf2tAnhfTJC2E7C9qRisG0w7Bkg/FGCjP1A3J35tsUW0uN/ik5PUWkarlkIxZEogag2phDqtwcPtEdCicf/fdqw
 TD/W2dLW
 ysQDf1ccXnlJrWW0DuxqQ/9QGptOAPCvG3AvW9rRe2RypkmHTxQY8COfHfzLIzPjcPt/p3sgq4ET8DJ6kSiLGSF/DyZaNy+7rCosTR2a6wG45Mt3E3zn7V6OsZwDJY1two2EeokgSS7FW8diPeV3p0sdrnRz1SL5lg0NC1cpEp0cXJ4ek7oc3YoUKGWHAcjf85NhiDsq3R93krA/dPtqnwbCTP5FtoMDMczo8YNgsD0E0nC12fosSRPLQ8ChR22jk6bnsHnw0Q4IU1KVOnYfPFXeSs0J6fP6DN7PUQFP4oV2Zrda2v1DM1/XbX66TdZ+YimrnZI1B6yy5o7mxlH0ZHRp18GnS4zVzdAotwrpJNyy0RCyV/+f6bay3xjH+4QwghaToghAvm+JhvXwH/+dSr/TsAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 08:50:01PM +0100, Matthew Wilcox wrote:
> On Tue, Feb 24, 2026 at 12:10:26PM -0500, Liam R. Howlett wrote:
> > The Maple Tree needs some enhancements:
> >  - Support for purging shadow entries from the page cache
> 
> Liam and I hd some preliminary discussions yesterday around this
> and we'd like some feedback if anyone has time before LSFMM.
> 
> For those who aren't aware, when a folio falls off the end of the
> LRU list, we store a shadow entry in the page cache in its place
> so that if we access that page again, we know where to put its folio in
> the LRU list.
> 
> But this creates a problem (documented in mm/workingset.c) where
> we can fill up memory with shadow entries.  Currently, we embed a
> list_head in xa_node and add nodes which contain only shadow entries
> to a list which can be walked by a shrinker when we're low on memory.
> Ideally we wouldn't do that with the maple tree.  There are a few
> options.
> 
> The first question we have is whether it's best to keep nodes around to
> wait for a shrinker to kick in.  Was any experimentation done to
> see whether eagerly freeing a node that contains only shadow entries
> has a bad effect on performance?

Hm, I'm not sure how that could work.

The LRU order created by readahead makes it highly likely that all the
folios in a cache node are reclaimed/made non-resident at once. Going
this route would destroy a large part of the non-resident cache the
moment it is created.

The goal is to garbage-collect the oldest shadow entries whose
distances are too long to be actionable at this point. Specifically,
their distance to lruvec->nonresident_age (per-cgroup, per-node).

In the current scheme, we just go in the order in which nodes became
all-shadow - oldest first. And we only do so lazily when the
non-resident cache is far into that territory (cache set vastly larger
than available memory). That gives us confidence that we're mostly
dropping very old entries without having to look at them one by one.

We don't have to stick with that design, but whatever replaces it
should meet the goal, or approximate it well enough.

> The second idea we talked about is that the maple tree is much more
> flexible than the radix tree.  Having even a single folio in a node pins
> the entire node, so it's "free" to keep the shadow entries in that node
> around.  But with the maple tree, we can be much more granular and
> delete shadow entries in arbitrary positions.  So we could (for example)
> keep track of inodes which contain shadow entries and purge shadow
> entries when they reach, say, 10% of the number of pages.  Or 1000
> entries, or some other threshold.

It's not the volume or the concentration of shadows, it's their age
that makes them good candidates for garbage collection.

Searching the tree for all-shadow nodes should be possible, but you'd
still have to filter for age. Naively, that would be unpack_shadow()
-> workingset_test_recent() for each one, but that's likely too heavy.

What might work is a monotonic ID counter for each node that becomes
all-shadow, then search the trees with quick comparisons for any IDs
below a certain cutoff?

> The third idea is that instead of having an injected list_head that we
> keep a tree pointing to inodes (or even just maple tree nodes which
> contain a lot of shadow entries).  That's not how list_lru works today,
> so a certain amount of development work would need to be done.

Ah, so you don't need storage inside the inode or maple tree node.

That could work well with the monotonic ID counter, you'd just scan
and reclaim through that tree, oldest node first.

