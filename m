Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C4110F3DCD
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:21:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C040F6B0095; Mon, 30 Mar 2026 10:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDC226B0096; Mon, 30 Mar 2026 10:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACB576B0098; Mon, 30 Mar 2026 10:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 99E166B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:21:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53FC6E0F71
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:21:18 +0000 (UTC)
X-FDA: 84602941836.01.97D3D45
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4404F120012
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:21:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QcA1y3WB;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QcA1y3WB;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774880476; a=rsa-sha256;
	cv=none;
	b=SvmE/0YRHQAPKcKhBwge/fDMbZGJrnDSWmoWQBNBh6wZ2P2ra3ZXmyFfzOABPi4Bk8lb+R
	M1qgZLLCzXBYCdFmu8q99KRd9eFGTCVEriIEhZynPGqCpIyzOB8cu8sHMMdNKik9RREVw6
	R4kJqigkbexCBRRwFbShGh2SgH3dzwg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774880476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/ozzOwDq7xepOmxDik1p69jmSO0OqDcfdyRDIq86y8=;
	b=d/Jj66nixCwCuBdpww6Oe81CBk7g0/aAroMlNLGkqtYVTMJafAZ8nVTAvwWwS4rnq1jK4i
	Ra9AsqTQ7BC2JOb9tY0seRsn2g0ob950W50n5TKVvp2+A/eKIvLkhdVBC9kVFlR9pyUWVZ
	ilj8CtgxMmvkfi2y0BN647oGJkLbfic=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43cfb723698so934372f8f.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774880475; x=1775485275; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X/ozzOwDq7xepOmxDik1p69jmSO0OqDcfdyRDIq86y8=;
        b=QcA1y3WBj2zA8+Bbl3BZu7Edc1YjimhsNzgRHA5OgtuAPKWJakTen4HQhsFw8Y716/
         1BD42t4Clmno9V4Gm2uf6/Z5OjX5yrV5+tI4ou8XZvJrCYidvdXUsVv/JZoG5YqjO9P+
         beeCzNtV3PrXV9poTGCL+kraAdR8bgWWyHZvdz5Q7Ma66SUx3JeEZIO7WO79WJsSUEIt
         1T5sNj2RnoXcMAKl2g87bp72ZpHDmxaCkF2XE0DoxtnPdf2XWDdsyZxuUCy6OQq9XIJU
         LEW5eGRZ954lGhN7jVpoJ4rLgMtZEHN8qIaOvx6hTdQuwr3dqRGH25HYdMOKrhTF6y9a
         zUOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774880475; x=1775485275;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X/ozzOwDq7xepOmxDik1p69jmSO0OqDcfdyRDIq86y8=;
        b=qkFvllM1RdUyMf2KK2ai+/Ux0PHmMqopO9/MFnMW2G5ngJx5GOHR0Q50SaC82I2TQ1
         Zpn9YkM57A+q1Ds7r7unS9RToOfwLFcVsiXRf5QO3y+HH5a6Y5i8+umN6uNYc51DYBxd
         JriB8YdSskcDuF5Xx8eRkh97HrhIOwm0GKVfb+/RpNJavhce153eRnUlboAa3fp8nMEU
         pEPD3IPlxjR8NDlG4Dsbp2NodrPc2QOGa0d2OrJib2/1rXATNvxUWQ2X7EbLAH9sPmCB
         aRklJr4jTxiOItfkjrB4uJcCdfDk1MXAic7txpkNCtFMexIud8bqLV6uKtdUWmMe99B8
         zKnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWv6b5c56QbIIvJFwvkC3fVhO53TEYECOm0aSYmWePA9Fbf2eUK1pEBW3WwHshkvRnQLNPAdYRJvQ==@kvack.org
X-Gm-Message-State: AOJu0YyZJacjjwamrpZcHBLULd8eCva/HhUdbCrZ9fgL5Qcf3JJ6PNWZ
	VF0YRR6UwK1/4QX/Pcy21epGBji4qz3bTG8W5v9otcKJt7j+rr36HbkLDxsxvtvkfOU=
X-Gm-Gg: ATEYQzwEYfwP1SSk9Ic3sUZpWl/nKHBi751TYkULWfJ0oFPNCxQc72hBc3ht4iabcJW
	MUZGGtyWfoxM3JKncSND3qLj2yoycW3zDRWutxGrsEv9SVMYu+xZtsevNOMKwyUUVgjtbyUfLzK
	htSRuzGSJfs0PSV/OTF7oaY2WZ1FB1PemFW+6O20BzjNxE/RJtgO5DeL/sh9UfZtgyvxZSK+Rnj
	K6GGFjtR1AqdTUZV9Yu1x5+dlsHzMFczoknXhR4MvuA+krnXWi8zwUFxWvXp2xJxl1NrRlaWiOX
	X19OW5YAKstpWCoeV+h5N5kKXV8npmnZt4dSo9xyvREBqysb2M6bcFJNB5Is7pdg1y5Pao/M6gu
	b8Nt3JCSRim7+WzbbIX56/aNK4GOO2itdi2eCBVsb/s5289ohaxI77Ol1XhIGbx0vBpWaVUl53G
	ljPH5SQWXtRzrmqtM80EJfwAqGD1wmJ6Cn3zif
X-Received: by 2002:a05:6000:290b:b0:43c:f976:b8de with SMTP id ffacd0b85a97d-43cf976b9famr9996886f8f.20.1774880474446;
        Mon, 30 Mar 2026 07:21:14 -0700 (PDT)
Received: from localhost (109-81-17-175.rct.o2.cz. [109.81.17.175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43cf2580194sm17882325f8f.37.2026.03.30.07.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 07:21:14 -0700 (PDT)
Date: Mon, 30 Mar 2026 16:21:12 +0200
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Message-ID: <acqG2Mr5ekCn2HD0@tiehlicka>
References: <acpmkY6_gWLdtJCB@tiehlicka>
 <20260330141010.3126996-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330141010.3126996-1-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4404F120012
X-Stat-Signature: x4gqp6cf9m35aokd96i9wxwswfbpzbsf
X-Rspam-User: 
X-HE-Tag: 1774880476-274432
X-HE-Meta: U2FsdGVkX1+/JKede2Vis8x70Ul9KLQ5HWrJxtv8v1b39amJh6kAXyPLo5cYEoKr3DkKXFGjIomjoYWKNABvi/MrH+awgFM0oG3nk11rFQOqbTCOxhq4b+9+S8a5YTLhkZsrTZ7veVyJBdu2bz0o3xdyExyvtweTfzptZAQPFmdn9TVLGJaSCU+0q1aZD/5oxECv4EoMqlUaS/+9xaDXvLkinzvS3ycAdXUTimdQd9x7O402qpNX0/SLJvp+2/fUJB8fYkcxX2AhHzG5LRlUaVaHiettw/mwHQpjf6rLm/tKXlvl7wV6RI5bskZNDK8evhlWHf4DE3QqiGcrj2vKAQD6hHLFwtf0PWJOu/yeUn+uCruyNZVIMReHvNvFhiNAS79k8l0IqZr9OibLFONs7Ta5ttXC8eDGkkVTzcp+RdavNoIaZQxf4B9k/VSaXGvP5qYhXVWHo12Mp/c+WiuA3iQbaF9RrTK7GrZnVIA9O1nLUPSZ5UeIbchGSo7CbR45RmQj+5bKpisNnVzRooDLX0h0iIVj3CiUGq0nz6UfeMWXGeM3tgUVjficd+IqN9s1ROFFc7LaTQNfwgass9N2dapibAfhpzFjTAToSqe3N4DazSC0vmXt0L0LwAJsT2gvlZqGx6i5lUcRDnZnmh5RuYqezw/2i0FaAStrCH9opNvrrCQkMTDzWLT31opKcoHYGFLkq/ZlF6wN5iYrpbrny1fVRApYdVm4pTJe9ZQgSbJp9KzuyC/OMJbDNVEEVfxkLFf1b5PoD9hkbI+ZPtwyEzXGn4jnryPy6oNK+NOlmVkFR9UyJqCg9hfBEXnSMszI2bNJt1krHRrgbzizlSVVy4NBMNMgeUL63CHE8S6ZcCzVQJciEtgdP2wlAPd7pFVZnf+WADJwkAmMKfFdCalk/kumGuxXR/2+5DEuGXmWuo6i59htrQDcb68R6r0h2iQ2EsvBoKq/tUyL0PL1kF4
 BI5JYBBh
 QOn/Q/yh/uOxOPc+hwJz5Wz95g/9prhJ3mbPsRzkcMkaqYAl1fsiFNZEAoL+/6ktiW+dkD6mBn+U9+uBkz9KSLaVn22LfVuPJqCiAUbOgh0upkxEPFxtp/q83Z0dZVPtH9lrbjedzEji+/2LKaN5pEzLOyMdBGXPqP0gCmmnp49psHz2OCZO724UnNwYvQJBbu7Q0PeVErVFlB5BN8W6vjm9jtMZK98BLQYvbP6TT4ruJ2xXXYZikT7Ad6Ehup/K++lDeVW9npj5w6q9951gglezWW3LxXqMgsak4B4Bc5Azf+RX5w8jp45Og9SmYBu/8sN0QEbf/4VLX+sxjrRZC/OJlzrltXRAXJ7PT2vcsfdV5GLoeovnKpM+1wJHrYB8w6bfer8bhG/Xpp3/hqvzIGpdYb8f9q0NHL15ivzg9iqWFBtidcrzvk3TTHAltebTfXoYnwtiQr/lJsuvS9iU7S+4pGWl0wsG4DzkRpWCoMTkh1YFTaeK42gVcbV32g98RYMA03MDEGwhNau5ZTsH/GYM8YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 30-03-26 07:10:10, Joshua Hahn wrote:
> On Mon, 30 Mar 2026 14:03:29 +0200 Michal Hocko <mhocko@suse.com> wrote:
> 
> > On Fri 27-03-26 12:19:35, Joshua Hahn wrote:
> > > Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
> > > to give visibility into per-node breakdowns for percpu allocations and
> > > turn it into NR_PERCPU_B.
> > 
> > Why do we need/want this?
> 
> Hello Michal,
> 
> Thank you for reviewing my patch! I hope you are doing well.
> 
> You're right, I could have done a better job of motivating the patch.
> My intent with this patch is to give some more visibility into where
> memory is physically, once you know which memcg it is in.

Please keep in mind that WHY is very often much more important than HOW
in the patch so you should always start with the intention and
justification.

> Percpu memory could probably be seen as "trivial" when it comes to figuring
> out what node it is on, but I'm hoping to make similar transitions to the
> rest of enum memcg_stat_item as well (you can see my work for the zswap
> stats in [1]).
> 
> When all of the memory is moved from being tracked per-memcg to per-lruvec,
> then the final vision would be able to attribute node placement within
> each memcg, which can help with diagnosing things like asymmetric node
> pressure within a memcg, which is currently only partially accurate.
> 
> Getting per-node breakdowns of percpu memory orthogonal to memcgs also
> seems like a win to me. While unlikely, I think that we can benefit from
> some amount of visibility into whether percpu allocations are happening
> equally across all CPUs.
> 
> What do you think? Thank you again, I hope you have a great day!

I think that you should have started with this intended outcome first
rather than slicing it in pieces. Why do we want to shift to per-node
stats for other/all counters? What is the cost associated comparing to the
existing accounting (if any)? Please go into details on how do you plan
to use the data before we commit into a lot of code churn.

TBH I do not see any fundamental reasons why this would be impossible
but I am not really sure this is worth the work and I also do not see
potential subtle issues that we might stumble over when getting there.
So I would appreciate if you could have a look into that deeper and
provide us with evaluation on how do you want to achieve your end goal
and what can we expect on the way. It is, of course, impossible to see
all potential problems without starting implementing the thing but a
high level evaluation would be really helpful.

> Joshua
> 
> [1] https://lore.kernel.org/all/20260311195153.4013476-1-joshua.hahnjy@gmail.com/

-- 
Michal Hocko
SUSE Labs

