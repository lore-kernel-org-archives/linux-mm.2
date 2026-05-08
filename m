Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FACECD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 12:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E3A6B0151; Fri,  8 May 2026 08:05:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24EB86B0152; Fri,  8 May 2026 08:05:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13DF36B0153; Fri,  8 May 2026 08:05:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 024D76B0151
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:05:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA49C140904
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:05:21 +0000 (UTC)
X-FDA: 84744122442.24.808EA87
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id F20CB1C0010
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:05:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EDraaeuC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778241920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X0NYep24oxwExvfDEJUbhKhfGyedS3L8W91sRP11drg=;
	b=rBYTfKotwJYBGkOh5+hpxtfBlgqLdN7or82ncfRtyY6NGEuk+VDKwBksbNNf8N7oZxiLzK
	yj7iwXPiHMFZw88vl2b/JRxir5AXv5p5TSf+gTWiAFmcl0ry9DLr/avWs4iyhtfCR3U1ni
	TPv/GkACHR6rHkr0+1870TmrPe67sk8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778241920; a=rsa-sha256;
	cv=none;
	b=5EdDsJEybiZqtipDw8TnmGAGbojgI2rYzdudZA7lKRDO5ZX7PTJbbDzc53i4ZVhQDAprWe
	gyS9M5rKwi4ydd8k+QLPZcPB4zuyplJZ8gL6IpZoEeHlrpjev43opM3hi0SKygYjTvJyfP
	JW3/3B9hgDKV6d7pi//CUZygXWxd3vE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EDraaeuC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 66AF160583;
	Fri,  8 May 2026 12:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB22C2BCC7;
	Fri,  8 May 2026 12:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778241919;
	bh=HbrqXPjMWQnzM3NVdDgd1ulka2fyGI7xQ8YVGZZNNxA=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=EDraaeuCu0sFfifx6+xorFpC0hTL/BZU+H61b1CX0dAXYRriQPCf5alI8CAPjg/+0
	 3uY333iGtwkNG12OUZmKBE1qz2ckjlsMgBUCju89CP8hlj9sjVEV24XjhfxtA3XRcA
	 wPSeJY7/6OcCh674Lov3vA0tnhtO8mZTqvTLsTB/g0lBNt9duBUe2abOF4A9EMdFMA
	 yFoEp4iJpTsC4TASpI314Bx1TYlWeJHfo4XYbpYZmMwycZ+l0FGR4zajrsqGpYQAJb
	 D3bwRuJYJO3RPFlw03A16MHJIDLsUEj8kQ+tsic7Qnp4w7DNsYunhJD7F7HBBU1/e/
	 LhbK2jla/8A9A==
Message-ID: <4da9d106-deef-4a82-add5-cadc929b0057@kernel.org>
Date: Fri, 8 May 2026 14:05:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: LSF/MM/BPF TOPIC] Deferred folio splitting: extend or
 remove/replace?
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: lsf-pc@lists.linux-foundation.org
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <9d5af75e-e41d-4052-bade-8e51c9622523@kernel.org>
 <71247244-73fe-44ce-ab05-69c852f3aa1a@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <71247244-73fe-44ce-ab05-69c852f3aa1a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F20CB1C0010
X-Stat-Signature: a85t8zdjz6dqg4tbj864hr3rr6zq5p6e
X-Rspam-User: 
X-HE-Tag: 1778241919-699402
X-HE-Meta: U2FsdGVkX1++0L0fVnkHZE1QVR+5kImYU7Yijg6ZEKpkGGnre1eqr10R3bX3NUwinVvQ0HXA4J7KsuZX6RV8Ewl2DH4+ZHIkxa0qWvB1U4RbmcJqa3+jJFchir4/mTpLPUYZ5FKHuvVvuDXku8p26utWOsUOWDfTZPFQ0Nxw0FiyvhaUTSfUYCSrPII02CHswjw2itsEUDXUlfpwK4rDBbH9oX1aLF3t5OUbzGENJYLXt8hKJ1GhWqtX+FM8arSrSZthao4gHJ2kcxffIABE0h6e1nzfWVQW/pHwK7unfT6nisAK0ZXVylQwX8HfFJ74JD0l+OYDekApKpAuXK2rgZS+wKIDr52VduXbn/wvBmhP7yVbF4H/mkZqyz2f1A2uVMf/j+GViMmsKCsEAu+fHS6ozBNy9WfrM43wOETPplhmTKNxTXOw9owg2XUIVEhg9wutQSGGFqIM+w2dlUjIjd62s1oABa5STNrEw0rXRluaxD9TLbl6AlWbx7+jUnFW3uLlckP89ywZ/1XmmWcEzThb8vVm3fTtjZDE13NOv5AO6gwNDHvngoOLsekA02xPJPbtMzR9HfTVbLkbLhyk3DBfpjaehnRgx4yb0CYsFYWpop+nUX0tlJP22W13wkSz2Zw13KKhGyrWrQSaSx7KyV4FLmdXK03LD7Yh1Ss84yckAlI5I95syY1u10lek9DGhkn+ewmsmfHVIqYa35ltmOFIdkm9rZUGOImEUbhQXNdJTahhLkpIdQ3JTy5mt80cq+MERgHK9PG0PMOizqGp3lLbWiSlKtIExlP2ndeX4b4vKeKz1oMhxJPLqjgkvT88lszCCv9GNJ6KR/9fDW9UkZvJcZTuPd+bdSAs3eG/kxFMp4Kql58tKHkaRKkOayKYT1zAwX4F2wxCugCoVnGwwPaXi4rJNxphJrKNji3OdxGNlQOznideYlcJ+7WeaGwLcHnWbBEAz/ZybIunN3q
 eneRCw/G
 ttjSkcu/9wrPIds519Pf+6/GBn/AuIBfykuRK1PhwWZEX3nm9Ooso8tmVr0j34jpLM/uzXIOfpdhl1v7yJDbmkEhgWzudcokUYhWonLYKKsOzFia7AJLZe/uUZd0UNHX+mcSpmVcYiJ2D5EsLP62q3jBzW+lplIyZl+zbJkwW7Tmkl0jg32OCEnMdDwOsSyNCNqPFHAT7usd3fQ4D3ZTMk1YaJPaOztSBc/1iEEcJEGclqum/Cih0CPKNnVrylTe9FldeZJp2CfZCRPM+JcwopaqtItrWhDjhbOWUBW7z18yE710s2HF0LL6TeznFyTt6Fzs4TOZsFWQX3KY3iPGhyFBlBo8Z+teFcuH3glezA3hvTOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 12:26, David Hildenbrand (Arm) wrote:
> Hi,
> 
> the "deferred" folio splitting mechanism was originally introduced to reclaim
> memory from partially-mapped anonymous THPs under memory pressure. Partially-
> mapped anonymous folios (often) guarantee that at least some memory can get
> reclaimed easily.
> 
> Ever since, we extended it to also handle smaller large folios (mTHPs),
> but also to scan for mostly-zero-filled mTHPs that can be reclaimed by replacing
> them with the shared zeropage.
> 
> Nowadays, each and every (m)THP we allocate gets added to the deferred split
> list as default, as "split_underused_thp = true", which is rather suboptimal.
> 
> Historically, handling deferred splits has been rather complicated and error-prone.
> 
> So I've been wondering whether that complexity still warranted. Could we instead
> just let LRU scanning deal with that and get rid of the shrinker?
> 
> Or could a shrinker instead use existing LRU lists?
> 
> 
> We could flag folios for being
> * Partially mapped (which we already do)
> * Possibly over-allocated (unscanned for zero since added)
> 
> To prioritize processing them.
> 
> One of my motivations for looking into this topic is that with
> CONFIG_NO_PAGE_MAPCOUNT, we can sometimes not reliably detect "partially mapped"
> folios and only know that a folio "might be partially mapped". To figure out
> whether it is actually partially-mapped, we have to walk the RMAP.
> 
> While I could extend the deferred splitting mechanism to handle such partially-
> mapped folios as well, it would imply taking the deferred split locks more
> frequently when unmapping pages ... not having to mess with another list might
> simplify things.
> 

Slides at:
https://share.daveh.de/s/bQsDpD7xigJ6wD8/download?path=&files=LSF_MM%2726_%20Deferred_folio_splitting.pdf

-- 
Cheers,

David

