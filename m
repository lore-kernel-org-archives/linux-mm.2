Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3853CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 15:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3FB6B00A1; Fri,  5 Jun 2026 11:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155126B00A2; Fri,  5 Jun 2026 11:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043EF6B00A3; Fri,  5 Jun 2026 11:41:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E82756B00A1
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:41:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C7AE8BB76
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:41:42 +0000 (UTC)
X-FDA: 84846274044.30.17BB0B7
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id B2EA0160013
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 15:41:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jCo9B3Uj;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780674100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFfuDG07qzWYz9cM/uqAnn123BbnDuZibDKFIXN94Bs=;
	b=I+sQ1hP4UXK6tBwNwf3vglFzgk8OCceLelOjNAIHEBzCMPfFq5/X4UK3TzzjzQsXbGE3jY
	x9bJ/KQhRux9TUgof5UgtH4cd+NijN8X/6nQ4snID3A77g8aCSW9cs7SUNn1uKWkk3qwUn
	dbumoJUojVlnX67kx9Qxt2XgLGZ6IRs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jCo9B3Uj;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780674100;
	b=wI/Aoyjaf7BZZRJbGKgrgHm0AokKfuX/Z2A8DScVRXmuRV/BUuZLs9cI2NlmsTmJ/XLsKn
	mKivi1oJZtBaFkXxd9U4yo4wPdRFUFW4Pp3fgjIVSI3XTIour2+E376pr5j8cOTPavRhDs
	wKiacn0cmamPR/vOaMzS8f4vcp9f19Q=
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-69de16f5e80so946747eaf.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 08:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780674100; x=1781278900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KFfuDG07qzWYz9cM/uqAnn123BbnDuZibDKFIXN94Bs=;
        b=jCo9B3UjD/TDJiiEzlZfiIJv19KDYfUKOs1VYRJFmyKefzgtMvGjSHCIm1ONsnq9Lt
         KvRLtxzgcu0kBcg9IZYVcKuWMko2zP6xq4gLUVuofNZwtYGnIyZ5t+8y+gLyk0a/5QVG
         9VWDPEmsXC0UDisaXtpAvIXLke00Diw9b7vEkKuIc+n3b/VZBpUc1tqhVnX07AB0Aehz
         lUxizZGFs5sviRDEHmy5HfY4uygx4hIm6iUXkw3PQ5u7iTPsoui/diw+tHizcZ2zM8Ew
         12X46Qfn2OXktZC0DMCv2agHD1gvDQGzewmcsZ75zbkQoD1qKROQpVnQytt+4sQdPQ2j
         WC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780674100; x=1781278900;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KFfuDG07qzWYz9cM/uqAnn123BbnDuZibDKFIXN94Bs=;
        b=Owm+LJVeigAT8qrm8C32ND0aJfEVOMuZNL3VKkKDpiEjN+JgTvzzy0tqoKMTB1+iJe
         z1wYTNMyFTy3j+kT3Zwe8Jufl8FDMQOu5sb7HdvgNzcuyDd03qYSUMaUBHNtIELsg3wZ
         yrxvJzcjM533EepEuXOhNRbum6v+KspfKvo7xADXi4QwKEFyqOcrop+FWcfFcKENP3zz
         z8w9i01UQYqYaJ6mBGAcy7Tp6mYBKb6z86mZ/YbjDrNoRBj4WAnzRDyetz44FHGbEpbG
         Cmz9vZjGiLj6itGaiqHrbkaz9g8iHD6QL0G4OnqSvUkoF3ue5jOQq1YiWz3p6jTMqwGU
         mzgA==
X-Forwarded-Encrypted: i=1; AFNElJ+vjEXFF5G3uY5txpoc3m/1exv+Wts5YArkCQL4dDNfPRU+F67CwPVdYwJoAHSYEzySX3cBUzKsow==@kvack.org
X-Gm-Message-State: AOJu0Yz25SmssQDsXf2AXHzJayieg1XG0irmOoW+e7ymkoJHfbgqhzXK
	8Gu44TFLU3BbYWVIiOGrM78TE6Cd/m/4WYprg1ub5P6RQ+Zzoz6Bp2FL
X-Gm-Gg: Acq92OH+8+v2UHLIUytTggDPyz9Kmj8xZNo2hcBOUvBkmSlZ4PdfKoGn7VJOYgxNyHX
	hHxlCPITF4z9BxdthLnEaHLAVKuf/8/YzLATpPLSAM1+8GE2uQLj2xzSIYlqTmGN56BjiNksONm
	CY+8g7qx5ro9RZuvoz54Fj+A6qPz10Mv3oTbb1w1NQaUm3D52sXWE6gK8a9MQGfbNJ8qC0LP6RN
	QPf5LioZmXKRwhZ23XZQZ/PX/zd7H7e1v5et+sqadB/IHMQWms6f1fXNcYxbeHx9tOysISG9ezu
	0qAc0x0J3eyhliQJrU7u12iY5eKMujUEp+SKiX9bD0iYEXKfTh9CGjE8BAqvjjjp+Vs1OYpB+KJ
	oj+Enz+zDPFUv2A6znTneTbojXi3kSzwEX7GKra7TLHL62c+bb57341axRGk1GReaJ1bckMUssH
	smEs2dhXlOp6v+Zs/coxz2yHigipIDQ3JEHVNw0XrkU5rXc/nkQol0GSXt30CZo803
X-Received: by 2002:a05:6820:82b:b0:69b:196a:de67 with SMTP id 006d021491bc7-69e685faf92mr2261978eaf.0.1780674099658;
        Fri, 05 Jun 2026 08:41:39 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5c::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69e464743f8sm5649858eaf.15.2026.06.05.08.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 08:41:39 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 0/6 v3] mm/memcontrol, page_counter: move stock from mem_cgroup to page_counter
Date: Fri,  5 Jun 2026 08:41:36 -0700
Message-ID: <20260605154137.300900-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260605153603.234296-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B2EA0160013
X-Stat-Signature: 5cdsyz5beeohiiqt61n6gmgwh9nxs3zm
X-Rspam-User: 
X-HE-Tag: 1780674100-560324
X-HE-Meta: U2FsdGVkX1845sh9116I+dyObvPJTyO8/P3XivLMALODPmIDX4DXk2MWCJwXPGqeFI2b7B11HMKS2TEJnh16Fjtino8vgOxhaRQn9oOHyd+ltAAU/vY+1TPtvbo0MJZw2S876vcizydafkV8rMFH6bqwsDDd4q+PU6KF+qioLMr6KmZ177CphwprHt4y788a2TyPDCDCJbug774UniZSLI9FD7GXWC2BtR+9Fv4wy0+sBGMZjJvZGTA079h1/0H8OjG7ugA0rMrmqjnGxwWTQUW+eBM2UzT31wMdpKDqrou1XIdvyiZ94qHURRiFZRZa0IEF7dqJ0OMgJgmStUerPmKAql3sy9GW7uhCZRc5s4jw2iw0HWpuTGerm7CyMUf2qQrYWCCvVgH/TuzMJcII7xGB9pupBzIUFE9XbfiuFs4Dxtep+d4n1l8YIetaqV4Q6+196ozitW+AtMIQWJfZkxYDvN7aEBf1Q5VzjgPmDR91yXtHccQevBNcEWjDlqaar7mYtH9s1hm5+w00rS7fCMiIbqUbh/NrY86Asq/rq/ESxi0vUnRYzquVIh/EEy0YM2tKiL0s8w5Nng/BOFhZLkWOMYBzeHZwzat58POauZXbdAlGof/56I5zF8A2/Y+ZKNljC9UIFkjswpZUy6sTNeT0qMmrSpYBteSeJqisGA46VUeUASE/U1lGxGPmvGnoDlXfQs1rXW/Slp76swmIQjuCTrrNHGmVbvufAQdoq4jdlAuKmUIZNZcQNkbyj4MbHFcbEbjP1Gxvaf7SqP03dYqcRUnI1MqCTmYvGsaYlpEZ0F3lTyf+YC8K9RcKkrp/1nMtlbYuzv43TMvLDGAwRpDEb/cp8/xfEa2wCNORfDZDFkWWlJRU67rkdmL3aIGFDRg5lFxtgbZdkZnGq3WRsSWzrK5QcvrN8AAFuqAJt+tIC54ASjgbIgMpI9kYxbvdDch5XFHsJupWZN97LIL
 DUb3VOXp
 fC+MurM9vVCYFdrnIUsLXQItuRv/s7lbeFEo21x7+2NJ5G7iVSpFtjUcEUc4ZhCqxbkDp25ctnQ5DJDq2HG2lxCSqrIr+iYSzo9j6hr8dNU/ls16FynClHyxYwT2p8xO0JhaIGmZP8ACTuZVOXVXd+Vxx0WcnIagXGBg2HbX5v3rFRFMRADN6rq06glVh3JjD+OF1RTbRMY/A9aYjvq2pu3rUNbk+BU+kAtmLg1rXe6T/bmt/0r6nQZFad1+Bfm/T2IDdtPkEw20O49x/X5Z1jcJ4JYclZvvR1IXO8HN25KpDiliuWPLi0BLzCAEhEmBv89Z/j8Hn6fauwZS7LpLG/EIcfwTX9kurNIsBvhveMUTPTtRsXuWlLqM3pHUTMBNcpFZHaeNfNfmzqriUOOcX+0QcGwwspNKyxRIZHEoclOh4F47TJDS3c/pHD/VGOXz7D5EpygqsSKc1KYc3fprx7c9Ztjfz5WeOLYH7Ds9EsE9iq3OWvj8Va4120CVxhY5EY1XnIeCEGkjWE4shPwNVtSBn+sYRcY2rl8diNAJ+Nt0aua1xf4a92TQ/g9s8hsFgnhOTBb6VYUUC3mocPkfzTrJdXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  5 Jun 2026 08:35:56 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Memcg currently keeps a "stock" of 64 pages per-cpu to cache pre-charged
> allocations, allowing small allocations to avoid walking the expensive
> mem_cgroup hierarchy traversal and atomic operations on each charge.
> This design introduces a fastpath, but there is room for improvement:
> 
> 1. Currently, each CPU tracks up to 7 (NR_MEMCG_STOCK) mem_cgroups. When
>    more than 7 mem_cgroups are actively charging on a single CPU, a
>    random victim is evicted and its associated stock is drained.
> 
> 2. Stock management is tightly coupled to struct mem_cgroup, which makes
>    it difficult to add a new page_counter to mem_cgroup and have
>    multiple sources of stock management, which is required when trying
>    to introduce fastpaths to multiple hard limit checks.
> 
> This series moves the per-cpu stock down into the page_counter which
> consolidates stock limit checking and page_counter limit checking into
> page_counter_try_charge. This eliminates the 7-memcg-per-cpu slot limit,
> the random evictions (drain & refill), and slot traversal.

Sorry, two things that I forgot to add as reviewers' notes:
- There was a previous v3, but that was just a rebase, so I wasn't sure
  how to name that / this. I decided to name this one v3, since the
  last one didn't have any changes at all. I apologize in case there are
  any confusions.
- I think it is quite late in the merge cycle, this is intended for the
  next cycle, not this one.

Thank you!

