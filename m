Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3C8606C156
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 16:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=qdkwQug2
Received: by kanga.kvack.org (Postfix)
	id AB0646B00F1; Mon, 19 Oct 2026 12:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87DE6B00F3; Mon, 19 Oct 2026 12:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99D9A6B00F5; Mon, 19 Oct 2026 12:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7E56B00F1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:10:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A00B1A07C8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:10:45 +0000 (UTC)
X-FDA: 85339864092.30.C64C887
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2973916000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:10:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qdkwQug2;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792426244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=524VuOfFgYNOliyeGIEdLFsd0yqaT8bQWUr86gODCAI=;
	b=fVFoc/mqOUJaHpLvZFJy46weAoHmx+3YTyZHxe7BICV4oP+Zz/tBg/jIm8NrE2/hHw5Efh
	15BMaozv2eRfp8CbFVc176jLGoLFO57O71VFWCpruecwS/szbmGQSp0QavQYoB+87CZ+Kc
	tNudYFXHaKftbMjHC32fzc05S6UkDxo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qdkwQug2;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792426244;
	b=Nq6uYhSLzPGEGdTBo0hxIq0vpfhHr+wt/RGf8DbHfmwXWIR/lbsqNT7NESXG3YRDSjY8Mh
	1EZUCtgZaVSIUuB3Qz9osush+QNZeoUJjOWJThClQtN9phhl0rmTbIr+OiCYehqFRfVong
	0+5QZs2tjNFV0s/EMxCz2Hbr+Exebsk=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5363c8de563so20570791cf.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792426243; x=1793031043; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=524VuOfFgYNOliyeGIEdLFsd0yqaT8bQWUr86gODCAI=;
        b=qdkwQug2mBcj5ER5wHNHIDlBOzFOH4gygHaeo/LEscoTPTY5NqtJP3KYrNUQtMR+Pp
         pNN/WAxCFe99h5GNXzlcS8wW64OWZFpd7PXvi+ArCuDWbrV4I6ESGEi6mv/QnHG+Q0mx
         zdlvZR+6co4ZpqVWTmvpCqQCZwTCzeP8FegnlSkKPkG3gBsPlk2tsEftpHtuPt5fHsJf
         E6s9hSQf8gPcQgmi/3lcHa+kI9MVskBbeWnzFQj3yMdEBqC0RBS+rEZAXjlQUrUjj+tQ
         E+98IAeYLEIzarNkcdIpzFUN7HasjR6v24LXVxR8Bdgha32a6y5nKRuTVseqCM+24X86
         Ru8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792426243; x=1793031043;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=524VuOfFgYNOliyeGIEdLFsd0yqaT8bQWUr86gODCAI=;
        b=kYNGbuyLGQDOAhZepjlXfnXY0fODErhgbzSnjODihPlT5v3+Z4NP7PSYE/qHbjB1PQ
         vfDVIaMNenzAQSyvbk4lKfmvCmDDhnUpK/Tza/jqkDq8wO/ay1tLqsVgNsBjdEuCIOtY
         axUSSsa2tbzSloXCQbgQYzVmJyQ8ILrmk1/7JLjUhEXh005J4HjszjPOHfJ7q9MqSs83
         Omv3fU0mCEaVvdsW0AOTRJkH2o494iiFwPQj4FOeYHrdJrVioL8cmCkdiDqkIf9YDm0c
         H6QEuj5EpwYjrUewNeeid/Fq91Fqtstj7BZdJl8rZKsl51+QrB6u7VxNxXVQeBtoig+C
         oNiA==
X-Forwarded-Encrypted: i=1; AKwUvBysJJjd45LHY7w43j4cK9y3fBTd3c6RFvvEUnxs0uRTnIVB5uQ56fiSZX7Ef1TNBSKc5I1RmnLiSw==@kvack.org
X-Gm-Message-State: AFq9FYL2PsvjJtOB8h3MDDbwgIxC6JX5LpqcB+MY+qvcVgiRONBNdccV
	vNUX6Iy8D8pZjHxU+c9iKjdp/LzBZTV93J5IwkuPh0DgRl2EtCpJY40dHtQe9SWzLXk=
X-Gm-Gg: AYBFou048YiS96lp+wbobfVw1m2C2j7l2gxA/pR7FjTpe76omHy/KOX6WV4Lfk5EGhw
	CWyWiyCam1iFUZGlkR/d465gn+BZfiOYkxBZ2ts4qhbtfFUmq53s5UVudnb793iRxsJXKsZAg/w
	45m+cWhZur6V2VbbX2Mo5iRuaEo65OU4/kZfsV0gVGpdbo2kfJg3SfQKss+EYDKp48MMTdlBXuX
	aVbyg4PvPpNV8fMHEQIgLV+916CXlAlcuoHe6QzryfNcHxiXWAnRxoFrSMcc0I+yFUU3SroXNmK
	xZd9rjz0xjLYRwzPtzpr6UYJrKcj9zOl3lschFgt77EWvg9eUegLppWoEbUKVb4gGz0RiJiJCco
	8mbPQuoCUHHgMuMgpbeew8+h0ndQg4Hderz/JRhfPQggYwRKBZg9DVdckxjAJQVcLVi0ueHPlyy
	k+KgPib22xazLaNoeuG+P+XQr4aRFfkp+O5SqNmtafONlojQO0q4sXPu3bxhXvgaRctgut+RAHE
	ufIy3IwG4SYCW85Xy0QKqRziCSderx7XTtj/+TyDUi95hA4rNxbgrE=
X-Received: by 2002:a05:622a:90b:b0:536:48df:345a with SMTP id d75a77b69052e-53648df3cb9mr103473081cf.32.1792426243229;
        Mon, 19 Oct 2026 09:10:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5367b3d1ccbsm12827051cf.0.2026.10.19.09.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 09:10:42 -0700 (PDT)
Date: Mon, 19 Oct 2026 12:10:40 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, ljs@kernel.org, 
	mhocko@suse.com, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, weixugc@google.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC 0/2] mm: add source selectors to memory.reclaim
Message-ID: <atY-LD2AzCYATRii@gourry-fedora-PF4VCD3F>
References: <20261019141401.11927-1-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019141401.11927-1-lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: 2973916000B
X-Stat-Signature: b9tb7t43o6tibiqqochtru97cifrpsbh
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792426243-283300
X-HE-Meta: U2FsdGVkX1+X0JhFuLKGaFTc6vtNrhE+7YZJh6VGpEoMtml7DXybdSFFq9wM3GV2vua6nxB/WmTwVvjapNQUJohIHZTYraALbNg8ahf2lelWcE99mAFL9UsNYgAQAlsosNjJtyW5rZ22SJHfQ2KUjshTEeeynldK+lsemSvI3A/6WFF2z/VjsBzXwIvoUMI0r1Z9nzk5Gn13hPaxUK5kVDQHyPKKfcuMA9R7ql1zfLQoJj5n+IPMn8bHjykTcQD4xnjY7ZnWDIf/xvqk1xNENDVKhGTIa3HsjIaekTWzft9PCow26kegpXOKJvTo5M4RKU9skdx4n0R+SU9M6t0Ns3Q6yJ3oXjLdu8+OyRy39Kp9x6eCCfXKR9gj3xiiR/A8KHTbYE9BWguIDmFgVNT6Ge217JtDGvYJkbi7URtKwrZp8O7XIQIq7TSFqpwTKtggUTl+93QpRbhngziWvqgxnlHC5baHIxJcAXFrSrfjhr015tijzv1sE/fp6fQD3Mmgy1LdbFdHmphZfEyp8aukQ3XKrHIHcyGmMFY6+qspmuILSE4/HzPWcYYTFoU7Ai3G32nzOAX/jYODOI33cIgqMpAIxhioVeyZri4P6vw/njYSii8qHW6uJFRbawLwTXZ+Ol7U6idwEJz0XE5zJ6fpZDu+zZtYwWhBuc/uJ6JgjyHWQ1mQP4R2cnMjOCoKC6CR+m9exc/d1psYXWPbRV1j1qyzQAizGfezcnAwRPjG1UGzmvVaXjJbJzGEVg+xPEGom0IOwF6Qa2iI0N7lE8kTKrOryKQa4RVjlbPp1c85qYyOtSkOEeIqxDHSAd7iiEKu7yrNjFwbrgxOHyhVZWued12wsxSEgx8lPq9rHHaFP8OkabJ/kIveQvRSziCaeC/IEjN7q7eUHyj4Mn8Ezhk2qLK2W5F01wLvGfFcMzX2V7xbU5n4Kltk9DjXZgwNIjAdnDcsgU9FFKP8pVyzfEu
 BSbzncvN
 S3Wnf97tRIPq76IJqBDDi187hWdB5Ktv/54jaS6m19wI4ucSs3nQY4gCLO9WlP5s+xu11Ehe9xvo8I6Jmu/x9yd2M+YmGo2jmt6Z/u4Cn1zMUGirjH1uT0ctZTWDWyV24Lb7P0NhDObUAJ9wd5Ojd7eA834w6QUIBFKpGlngvX1ab/gurpJYN9tq7iRi7U1MKTM/VwOxBxSpYNACFfEEPxlvkSPsxC+MxMR+VUjTd77gE+sBPviqr3vO8A6qL2htx82oZu+aaK/rAfh7nCanuRKYDebv4zHTExmjaQShiJxpolTiwLPa5ZvmNQ1LNTETmTTILX+CEsE94Lcxh6yASrKmSuFrvdoNJy/iOdyVQbvKB/mFDxoIqX4WoEOxkx731fZ2a12RKoesti1TdOnVk6bnlLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 10:13:59PM +0800, Li Zhe wrote:
> memory.reclaim is a useful proactive reclaim interface for memcgs, but
> tiered memory makes "reclaim N bytes from this memcg" underspecified for
> userspace controllers that manage memory placement across tiers. The
> kernel's reclaim policy is aging-based, and on tiered systems aging may
> demote folios before they are eventually evicted. Without a way to
> declare where reclaim pressure should start, userspace can only reclaim
> from the memcg as a whole and observe one aggregate progress value.

This is not a good argument for pushing the complexity of managing tiers
into userspace - it is an argument for fixing the reclaim interface to
handle demotion and eviction sanely - which presently we do not do.

My best examples:
  1) the watermarks don't make sense for lower tiers that need to absorb
     large amounts of demotions from upper tiers.  It's likely lower
     tiers need larger WMARK_PROMO to let low-tier kswapd run longer.

  2) proactive and async reclaim current reclaim top-down, which results
     in swapping directly from top-tiers because lower tiers don't have
     space to absorb demotions.  We should experiment with async /
     proactive reclaim applying bottom-up (lowest tier first) so aging
     the top-tiers demotes into lower tiers more successfully.

     direct reclaim should stay top-down because we want the best page
     with the least work to minimize stalls.

I have a strong suspicion if we made these change, then memcg.reclaim
would work more or less the way you'd want - and anything else can be
managed more directly with madvise/process_madvise.

I also have concerns with extending memory.reclaim this way permanently
locking in reclaim implementation details that prevent us from making
changes like this in the future.

~Gregory

