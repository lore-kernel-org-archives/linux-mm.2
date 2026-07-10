Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AE66C44508
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC776B0093; Fri, 10 Jul 2026 08:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08DD16B0095; Fri, 10 Jul 2026 08:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC11C6B0096; Fri, 10 Jul 2026 08:21:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CAE356B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:21:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5EEF9120469
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:21:52 +0000 (UTC)
X-FDA: 84972778464.11.D168934
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 243CBC000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:21:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lx7BB4SG;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783686110;
	b=3OxFePnlDS5VI3kRk98yoX7KVPj7GpclMMXGR9euk9swA47qzb7lajoApiwiwbNzwEdMBo
	C8riKDU54NKcALfV//Jnfst9cIWPzQrpU92U7fc9D1gMWsuB9HFqd9lQARP4J8Oe2gB3Z5
	QuVdys5NkUxZ4uUjQajnuo6QIOk6Tdw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=lx7BB4SG;
	spf=pass (imf10.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783686110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnykIrs/H9V/9TFzopaasthMan7ew7i/OfjNhpwuS2U=;
	b=L250KEOpchvFoM+asfIYTYWJKc3JYXLifdDEUNK+bencHYID6yP+vK84/W+qOknvuSibE7
	ptB143H31CJhGxlOJMKnac8wUyDVjNP9uISNJGaZRrdm9XtSaYd8R1frVxqyLD3Wlp/CSz
	J8rzUW5zZxnsRag4swYcPIsWKZ4wz3M=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c21495722so3753201cf.3
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783686109; x=1784290909; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pnykIrs/H9V/9TFzopaasthMan7ew7i/OfjNhpwuS2U=;
        b=lx7BB4SGhewgHFIF1Rb4fX3rGGxeT9ZsLTf13zQwuoP//mnYakc6AN3Lq9dmzt/243
         bCG7FFV7abkjalgjIFs+dlI4urDGhKOQtoDqyn3dZjSVUHtq3kRSc042GHuK6HX/vIKw
         4w/KL9nk/DE9XvM9JxJOSw1Gkg611zBZuLEBxJqH+oC5w6HwMX8C+V3STrksRhG/bUrr
         Ephj422X2wXmUsQ0bRL/ofj2LNELiWY4F0rUmT3CgoKvYqn6aKN6LQBs+5a7zZlJwfzE
         i6RElVrQ6oWVEe1ORV5O8ptO7r6Q6ZJ95hUXuUTZhwsMoarzUckyd2MLiKyBgUyup3Xb
         Nlcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783686109; x=1784290909;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pnykIrs/H9V/9TFzopaasthMan7ew7i/OfjNhpwuS2U=;
        b=b3FOEy/1NUj5or33Cr0zKuFqPdq7gDnxSps5P9Jyh4n+QCPqjHydoO+w0ibEv4GMc0
         YZJVkoyXb9r26TztdrWK/by/yObYh764JrCbX1PDoyXjbJ4WtWwCLzYXudQOPJzLXGDP
         Q5lGgNZSy3r5jD0j7GaGTxoId/XQ+UqcvHBGDTjin+XTijc6dxFE5/3NlCXQ/LFRH0Fl
         n+4m4qvByo7GoYmcVD88cJCCDD08CRcSKumnGmxqzYVzIo3UwyCvkxnlovvOMq2+ra3O
         ZFRwusG/Bkxxgh5+C6yy5BSzIJWfQ/6viMoU9DmOZBv5XFHoKQDHm7TE0QKxrd6wrLXn
         20Ow==
X-Forwarded-Encrypted: i=1; AHgh+Rpsg2qAEFr3tJj3Vll/Jf7C0RQUNLXLMM6Xpj/a16f7PdR2W22H1Oj6MYTJ+GEQ6TtoURMAd4UKwA==@kvack.org
X-Gm-Message-State: AOJu0YyMa1LdTFohpP0dih+k55+HNwD8BBgBfqo5be3fPMR6t9FCft0n
	EVo6h1+5pCIsjAXON/4vm1XH9/8vwj0MAN5ymxb06nPrfpLJYHMW/Kt+PbDkNfY9DLA=
X-Gm-Gg: AfdE7cm5j1rHzodkxKphIos9PrWHAdO9i6DRSgUYa/8xJcvks5tmRb7MOXPvJfi5BfT
	tLQrUlL/CeLvL8w8FiOK8NmAtAaq3lwe3hw4xRAw2/syKfFMo55w9agq761fkz4NAS6pMqwiprZ
	8eKwChfzS4OLvW+A2zu3Q4cKkWvGP/eJw1fk1mArn7FOQJim+aRzZ/c+04hs9SCLSUczENmn0xo
	ctir3/iUDLpPdro8hWO40IdDaT2B/OPg75aBLdEkAu3WZCyd+5iHqTrwoEFJ879oBqR18Dudo8/
	vdFQU07LkTuIj1B5BHxs4+z3+A2qJ67rsq3N8sg/bwpH2vOD6qv+ilCzv3q5u3y+LouimRau0W3
	jLZxOwf7KlLJcN3O/mpCUuWzbNqT7tgaOfJmHGSFjfl17A9CLbry0UskuPluVb3Q91w9/4G0U5i
	ZGvcIpghqipv8=
X-Received: by 2002:a05:622a:c08:b0:51c:12bf:d4a3 with SMTP id d75a77b69052e-51c8b3c683fmr122768331cf.52.1783686109180;
        Fri, 10 Jul 2026 05:21:49 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1d22bsm39699356d6.32.2026.07.10.05.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 05:21:48 -0700 (PDT)
Date: Fri, 10 Jul 2026 08:21:45 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ridong <ridong.chen@linux.dev>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH -next] memcg: move mem_cgroup_swappiness to memcontrol.h
Message-ID: <alDj2VzbpxT-I74e@cmpxchg.org>
References: <20260710111224.2355668-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710111224.2355668-1-ridong.chen@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 243CBC000D
X-Stat-Signature: kpzgs6xw4pqg48gbfp4c9rhbsb1i1o9f
X-HE-Tag: 1783686110-617762
X-HE-Meta: U2FsdGVkX18a7+ykrH7rzgl/+fnXaT3DwURMP3jExSKJUACi6KRTrF/S0Bois5UKN3qzvMfBAB8E/OpfbwHqY2nWW5mz3MzYt+o+S9/45obIr2pUqvXx4ULBvBzaMLxG+cgk9/6x+1cM68tEWlnlWL4ywx5cx19yHKuLYHzgussz9SIn+7x6n/k9lU+P5k/1KqlWjPGUxvccNQLC+3eKqTQCNjjCoklfgnHgRDqJ3V4KcCVUIlzySLw56pzpYzLgAwYVRdNuDFsJSq003sxHHP81CDvmxUlCcko2yyrYqqetiBjrRimdfXaeZWxbjllsfk4KxKYzYGlDCqJ/Q+LuE3Sw+SF7QX7Bqz8JmuaOnd1JdqNPtbroffPWJHHXxuWnpJlpx2QaE4S6YxuLwgJLhFcDGLklg2xAk7h7Xrtv0mBL8Sj2fKh7QQV7I7YyaKECgeXNIfUN8Q4daCD1lyl64rqnGCrXDgGjcWX0/Rh07iUw9tkxE3/xulA37pJqlVWukj41ftkX6SSO36nCh7R369+fFQpRZz6zZOely65tyuvg/SUK5zwo7uajiz1UEncjF1f+KcxFDK4bTZTlNVZVM/i6DUPDQSA9hoLHMSN3A2Hu54Kl5CffMQm+XpeTtO8mU6jSJO+etivxQc+Ej6cZThSJNHeZR+bOystn4s3F9NcZdFuwv92tUU5s1DoW1pLErPYKvsij6T8T5D0NZkRVy8X9AAoCRYK+hbbPfS3NqlbfnumM6qAig+bmrvg1mBeL59zxGa9HZANXt04WgyyKNnDNzlET89KP+gRcdIR17cIM4o88z1vnVxxIYXaKl4YofC96WJuByL/BLnbER9rvAhYVP+KjWe2rSxSmGGeo4vjegCzy63GGp1l4zs6HwYqOzoIMl7nbauaAHutr3zEGa2nKIben+hxWtvBrfqvVtFurqDzL8kNdlG8yzwNpIXJtpOvvUdjnEUIeG+gNKjs
 kHhW46MW
 1LY0VNCvsIQBHvBmBs3vSLY1N4uyd/lcZoJO8TIa6qNFe87I244+M6DgXg9OIB/gGHOgISl1AcYkjppG9GH6KZygM0y/JQMYZyhNFXhk5eO1as3zkPBS1TBzsAxV2B1v9NkXG0yFGjyf8LrfenBdya/By0jTKf6Ssh01fz2sdIYiApRLW7ImitIWIUyYHkRhcx3w2GlwoU1WmEF4cxjVrPzoQFs/QJOm2P5W1la5WJ2sIXcSdKItedKFe66IUJo/WES4x6einkEKx9sJqQokKEBJ3277vj//6oe2MCF8y80VAZTu8gNATqod3pKH8ypaqMeJujVefqy5xHGpaFhg6C3CML0dhZQeLkQy3plcNAKMq0VXE2SdmF/h7eSEr2Nj2vTzb6GcL/o2N2JU0xCg87kMEv8NyBIovEqxnDe6d4YlmJiA288yJ01UsT+s0BVYS7qJJT3y9h1bdMzlYd59gxNgy6idWC9bZ91DnrgU4GJPQ445iCGb5h/lHTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 07:12:24PM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The per-memcg swappiness knob is v1-only; v2 always uses global
> vm_swappiness and ignores the per-cgroup field.
> 
> Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
> to memcontrol.h where it belongs.
> 
> No functional change for v1; v2-only kernels drop the unused field.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Nice.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

