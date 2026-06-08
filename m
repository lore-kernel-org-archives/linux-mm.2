Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ED83CD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D59AA6B0005; Mon,  8 Jun 2026 17:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D31286B0088; Mon,  8 Jun 2026 17:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47606B0093; Mon,  8 Jun 2026 17:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B43536B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:17:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6069D1C1DF4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:17:32 +0000 (UTC)
X-FDA: 84858006744.25.3A95D66
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D5D540007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:17:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=POtzC7nW;
	spf=pass (imf04.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780953450;
	b=SIh/xfR9oX6yZ2EijBwy3ufD0Da15w7G0yzPnn82ad04RJLTXidZRPmHSTkOIHdHF62kkO
	tGbf3BwS/5coUXO8JKJnb+y1pdMLvzFjEplrQFJfjJK9X2GXXfcPNXDXUqnyjJx1RyC8Ps
	Nqq7HR7dAjhpoOyVaowPMBHqcFXLDME=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=POtzC7nW;
	spf=pass (imf04.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780953450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0X2aqDX8OmfJ6U9IJ3AZzlNBASoTzNs+e5hFts4zm3A=;
	b=MNt4AJ0gXjCI8yhf87bfJz87HQkN2QbuZbx19EaTIT4KR+yXgUVKiHmBdt0Gk3uKQBFz+r
	qorgc2HbDu9tMa+kWrRXSf0UqzSGFgc7Lo/QlOX+ZiGxYtGJHBee6XcJn9uVGe4XXZ3VzO
	Og89OviPvK/kpnlaR/dilhCeTQsI1g8=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45ef372c58aso2579352f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 14:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780953449; x=1781558249; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0X2aqDX8OmfJ6U9IJ3AZzlNBASoTzNs+e5hFts4zm3A=;
        b=POtzC7nWdeuAb73bnRa03F2QhS/UEXXPric/uwoG7fA3phMXJU6V4fv1Me/LnaJwsd
         uWVsz62ZwHvd68ieMlZXvX4goL9s6DLExPzsZPXk99ZNfo0ejqejKTI76YRqldUCbQY7
         RuFZ5YYZHqdtKzUE5j1NJ4c0G/POGE0igXzP8WfuYiBa+pvlDcx3nqWgeJnP0fDHzIAA
         PfD3/WOm5YnShMorQceT3UWm1DRu883q1pnUHVMwm3lmr9S0xOPeFKShG/2sQdPLhRoy
         8DtmA33vQl3i7Q0tELteqD9AbkczirgO/NF8hE2gAtQIWVmOlA0pbQAqAHhR+4SjYWo0
         //fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780953449; x=1781558249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0X2aqDX8OmfJ6U9IJ3AZzlNBASoTzNs+e5hFts4zm3A=;
        b=qS0zUTul9nyFcNK4d5WIK2lUoFptkKEc8kzQN98AExnsg7orRhoopfwnKnbvtzGj6X
         R6Xp0NUlBZLBFFUzhE2qKoq2KQyoAhaSJ8jSti/m0IPlgY4xpT6R1txcTeRWY414Koep
         TdbKQwRM23gdIA+oW4pLYldaXoZiqj2L/nYZpGgJTVUxSUJsBiCGDhpJMQDGw1n/DTVl
         zj5dQRhFhTxv5axet0tXMA5c2al2xycnCT1ovVocDi1iIYbnT26ZcMJk/YZOMAcGOe6c
         9Mwx9Bz8oV1D/cix76rVFbGM8ad+cQUrpP/qKRyjtYWpPrv9b7ogQHmwnrIecoU1JY/3
         x47g==
X-Forwarded-Encrypted: i=1; AFNElJ8GhFmZ6EMgDM4zRiov3oT42rtOjlLTfb4tkQd4u9wbdXJu0QwaW/KA7ZjrOrrZxjX+igq9dIRu5g==@kvack.org
X-Gm-Message-State: AOJu0YxassRT/VKM/7LXHZi1+yItllNHtRJZfz/5Ho/NtueDW89eGsjh
	6KNWbJW1mdsCTzMiZBcgMWTu0F3J6hUUt389vwDhZFIMB4etsIFt/1pE
X-Gm-Gg: Acq92OHCzAV30WuvxFeTaE8R8mMOdb1aSnqbXGMdvRvk4KYz70xgqJXkV88G96Vurys
	semJrr9Ei9bud1V+KtVOtj+T0c2C/e2IIMMSko71uKhKy++sArKO6XbYo2Mkwd5EISz+97QrASy
	mptU5kYXrAJWr7YMMYB1egvqfxAxtBgJVF5/oAbDd9dmDXOj64ZMXc8BrzAV6ILboh3MF4kjAFy
	3mubOyDZPeKMRsN2frQfyvtuOgupkjwzUuzfhgkcwKjTPYvD6F5WPMi8+rBAOwIfWy8MfTwKKJX
	4WdK0dLuFFc7VjwFicH1yNP3kGAVCGF54cKZ23kLSP6YafOwI7mM3TkHQtMu7Rd9wqgiBo/2rUU
	IC5DEJoZh0eKv3Ni3Cq2Dla/pcMwbDHnojnRdyM2tTO3uc2P1vf0Nd9JQI1qrauxOMDgTZA1Jm7
	aZGVKYm6vN9Eeq8DOfOmWYbL3djtqS3xyA8tYa+Ed6u2F1TQC8POwAwS2XDi4z+z2FGhDjLvTfU
	ERlYMQuDnlXUC4Av2w6rH9gqrkncAfVcTA=
X-Received: by 2002:adf:f290:0:b0:45f:f142:d569 with SMTP id ffacd0b85a97d-46030505eddmr20146309f8f.15.1780953448689;
        Mon, 08 Jun 2026 14:17:28 -0700 (PDT)
Received: from localhost (pat-125-253.wlan.net.ed.ac.uk. [192.41.125.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcde3sm57328226f8f.1.2026.06.08.14.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:17:27 -0700 (PDT)
Date: Mon, 8 Jun 2026 22:17:25 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
	akpm@linux-foundation.org, kinseyho@google.com, weixugc@google.com,
	ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
	willy@infradead.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
	ying.huang@linux.alibaba.com, apopple@nvidia.com, dave@stgolabs.net,
	Jonathan.Cameron@huawei.com, rkodsara@amd.com, vkoul@kernel.org,
	bharata@amd.com, sj@kernel.org, rientjes@google.com,
	xuezhengchu@huawei.com, yiannis@zptcorp.com, dave.hansen@intel.com,
	hannes@cmpxchg.org, jhubbard@nvidia.com, peterx@redhat.com,
	riel@surriel.com, shakeel.butt@linux.dev, stalexan@redhat.com,
	tj@kernel.org, nifan.cxl@gmail.com, jic23@kernel.org,
	aneesh.kumar@kernel.org, nathan.lynch@amd.com, Frank.li@nxp.com,
	djbw@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/7] mm/migrate: add batch-copy path in
 migrate_pages_batch
Message-ID: <20260608211725.fr5e2yqjojvz4jqf@wrangler>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-10-shivankg@amd.com>
 <b7956894-86b9-472f-b2e9-bb50c0316c39@kernel.org>
 <c2bfdf39-8caa-43bd-b1ad-2285b4cc767a@amd.com>
 <27f6f5d6-e81b-4e0a-af39-b175187299e2@kernel.org>
 <8EAC3D9C-6956-44DF-861F-A4864F08273D@nvidia.com>
 <e0b16bc6-45ad-4383-a4c3-f0265dfae1b4@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0b16bc6-45ad-4383-a4c3-f0265dfae1b4@amd.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D5D540007
X-Rspam-User: 
X-Stat-Signature: 9or5cq4js18ki9ncyca9yem1bpwdgszu
X-HE-Tag: 1780953450-63182
X-HE-Meta: U2FsdGVkX1+HjZMa/NcM649Pm98RTwZQotrpoXEHRjqtT8wSEbFHeNM58R4LWgpxiR3VU7oE0BH1r7WT+pzRY/C04qPTtWXjncffuNL6f4BEB36tZDYRUrbgygE1Y84Tfy29P2zhtclIfuZqaxhvIJDm/hkokr2vTjoQuJ0H4+0fE44FXqGDZyHobJYwzIwpwQIhfigfIRFKHsRC/lDPLk3O6cn9k4FkMgxK1tvvoYovvqwDac2mORpZ0MAV7dAHS1HfS+WOJZCMPZVK/b0ETQ0cZiYNOH75QoyWZI0PxbIFZPtbctXz0lLrdaNHm+iyiCcx15s6j7L4+yaZQ6uZplz5eN5J74j/h+pYAzlLf7WHkIJHTPm4Uw9CLRbmEiftc1ycJq8hhewtKUPK22zWVZYo3zMrGE55oqXMrFA1dqEwyI7X2S8AcQqTvDIJ7FbafiF77Wl7tUgwxVW1lxxGez4Mo9SQIEfPvWzK4YVMZpL666bAt+PDl+SGa0i/aWF9lC84OMXitXb+b/7FY12EJnBOohtheO0wFNnSOOhnnTJCCcE5h2MfT/mw+abz0O7h8d2TsC6vK9yobwhG634Hk5ObGBlE7XgsFWKjfVnuTAncHuZucsvKOubhWASdzaLmrKsM6X0DIT3zjZjrjpo8qUTEVnw/AY5CP/+Sp6+I8TcnTie52T7GTMBrLeKQgPHBCo2znon7Q8DpzF+VJOWOod3ghsxuzLe+Dzqk4WGFuxGfhC0BVZiXVuJvf9YUrwqdnqIN+OOc31CTOyDKJNyPeFvsQeQ0m6pAZhxHkGvEBhOoW5jBVQ6hW3VDQKi7/XUyqO/Pb2EY9Iukwlz9HhV/0nFZl94F8ZVB04i6lkfAsLErWr2clZfGgf9u7zZBaJrlHZTElICSJmYk6Ih+N22d3sCFVcdnQM6krLjytGZjen48Sk8oe+Z5NgbxXFMO3ILdLj/tlOlpKbregqQeT08
 2Yp6ouAu
 UW7BzLGit6kJJGXDcIFQPkkTjeQQSWl8DdI2NkPGTUIoa//B9EP5HMm9QFQDK3MChDGSJhpfqjoztM+ecWuS/XMkmZL/dlLaesLjBVic67r4xsgA2fAp/bYLEx1tgEM7XMv8la3Mdo1vDI2n+TpYAef7V6HbAYi6gCJqrQ2YCBnDTAwBmVw7VRsLZB5N6mHZ6750sRikrKRF3t2FyFc9nM5mjKhGFs/ZnUvyshycjGB2VVY5hrp6dexqm1eaOZMtl2h86DZhs8d0Uy27LlXJ6eMWoqjUTq5AB7nEuGe7lhtl7ezfa48JAwxkOjiKEfGOQ8lld8XJeg6mnkISPGVBS90wLb3QotmDGhUz4S6GMgRNOfWl9QJsPO9s+99h2KS7ex/uyg16QWiIBmwqw4qeUYRZe+kGf0pNLkAnX1VaX+aWdrfs9bGxCAeCfibU/qaMWoMczxFK/NDx58+p4KIhzOpn33sJV+i0FhqSROX7Q1abWHb+4cO6hr7cyyqcdXxeQVPp0Wk4/5V01SRI0t9wmAAt1utuhuEYCdXjY5dLwIKzUeMCI1ZhfaPq+6Ok+zuHumxntroSF7cfBwYBZxoKodaiIULfvsp4p+ZwEHB/XjYnq9d9ME0XUMPUsnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 02:10:21AM +0530, Garg, Shivank wrote:
> 
> 
> On 6/8/2026 9:06 PM, Zi Yan wrote:
> > 
> > Maybe do this optimization in a separate patch to make it simpler to review.
> > 
> > BTW, the whole migration code has become more and more complicated due to
> > batching at different levels, I wonder if it is worth the complication to
> > optimize for the rare memory error case.
> 
> 
> I agree on complication, but I think this change is actually simpler than my previous patch.
> 
> Using per-folio marker lets me drop the already_copied arg that was passed through
> different function:
> migrate_folios_move() -> migrate_folio_move() -> move_to_new_folio().
> And there is no separate error path with this.
> 
> Whoever performs the batch copy (migrate_folios_mc_copy() or a driver callback)
> sets FOLIO_CONTENT_COPIED on each dst it successfully copied, and __migrate_folio()
> reads that marker to skip folio_mc_copy().
> 
> If copy is unsuccessful (e.g. memory error), FOLIO_CONTENT_COPIED is NOT marked,
> and __migrate_folio() will not skip the folio_mc_copy().

I fully agree on this as well. It's much simpler and cleaner than
passing down already_copied flag.

> Since the per-folio marking is the natural implementation for this, I kept it
> in this patch (af44801ee).
> 
> Git Tree for reference: https://github.com/AMDESE/linux-mm/commits/shivank/batch-migrate-offload-v6-wip
> 
> 
> Thanks,
> Shivank

-- 
~karim

