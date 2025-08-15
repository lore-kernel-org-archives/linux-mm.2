Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22373CA0EE0
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 03:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C4C8E01CF; Thu, 14 Aug 2025 23:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914108E0002; Thu, 14 Aug 2025 23:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829D58E01CF; Thu, 14 Aug 2025 23:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 724828E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:15:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22DAE118079
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 03:15:05 +0000 (UTC)
X-FDA: 83777525370.10.3D03C4C
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A8BB100008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 03:15:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fNizPdEv;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755227703;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jil/SDWoEH0VnNo/eFUe9s+p3KUllo94Bl9QN7tRkts=;
	b=nH6FPphhepHW37eMDxRSyd/1j20yl5bAFOZo1BWGzkXofPEstS3rAQ9kChF3O+jN66zH1z
	g8XQ7c0XTEybzhSUqVJDK24W3Ibbk2YauDkBBWGt2jMGhTnw1f11O8jLYqG9UlMl6B8kYP
	DyW8zE5pMEutphCH3hEaOsVUhdGBHEs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fNizPdEv;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755227703; a=rsa-sha256;
	cv=none;
	b=YmHD4MZ9Bz4OHz2l3xjjlG9vuwCr0TdTCSLp9G5JGIjDYeYCl0iQMR9C87stgnxtS6X7SA
	rYszPMSO98FLIDDmeO3ndj4a94jKL3X8P/0Eqn6MWlfh6fyq//Rd4rPAQbo/rnuyXPmYkH
	ADUr5aYwgJYZS3heiCaYiarBjwlwaCI=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6188b65a2f0so2944646a12.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755227701; x=1755832501; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jil/SDWoEH0VnNo/eFUe9s+p3KUllo94Bl9QN7tRkts=;
        b=fNizPdEv8BommSxd1m3llCWiwlYwcVjWAdBaLz6UJLwof37L/4vGoJZuqfSbTuaRrb
         VrA0/GO6Yd3oM3HdjwwTckefYTKj6UsQoBL+r5JByGz+Um5dninH6W7zDseFANwfcCPk
         TSmwg1BT/dmQzRPuPQ2kycy9fyeEWQd95c3GJ6ORKDUNukhh+5nngfQ7QfuoWVgdMFNz
         ZK2WdehLp1SzyhbJ6a17/jrk/xMP1+59thHFIRjffRVqhUDssSkoI+V5mAFGqJMp4i3a
         Y4HiQqEn4czLUs8tds6JNDWwGbrM/YvGBLQo3OmSsYZk577AGBxGoxozagytNkU45oY1
         PTiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755227701; x=1755832501;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jil/SDWoEH0VnNo/eFUe9s+p3KUllo94Bl9QN7tRkts=;
        b=NuKtgfO3XoE7YpDsbf0bhy6C4oGy1J7oI7s1du6/61B9aV5nhdIcGK4BRg/USsIWZ9
         J5twaFZHMuWQs1MLKKsmpnw/CybSt2Urgu4p71KZLTGYnGZobyqh5eI0xgwd1Tcu1mBI
         7K4iv5lUc6DnzoXtu/7I98ccR1JA5Xknb/o2YzRSFnM2E6Vb7yNgULccSppSJOYTxsyb
         yINLFJxrRfhW2JubsDas3OKgcn59loHyLEnf7ZIlvoNsO0IhQqQEsCIEk3fHjCmEvooe
         iJ65aoojuIsL24ABR883DxkPtE9rW0ubiSJiZmgQrVx7pbNp8t+g+vNXyrrTTU/jsyaQ
         d68Q==
X-Forwarded-Encrypted: i=1; AJvYcCWfyjqKTcEqeO2vVNXRB32A9BzuPLsTVDcL0uabUJe0OzVX7BmBZAbIgf34jcl6t7Bq85hlF7oWXQ==@kvack.org
X-Gm-Message-State: AOJu0YyARBAlzFryGbpC8YLhYXeihIicUf0DOn1s6zPZ6XLkG9jxRC0H
	6ZcZug4E6E/zUNZsgaHbnEqyawDVp89zNeTFCxRaH6bwXKV82CpYoVrE
X-Gm-Gg: ASbGncvW7nQohhQ7ssZ47FcKCSKRz4WoGpxrzEdZgF/Oou/aJvhATsIi4EOadUhH0yA
	2kZNJpKtLbj58aPhhf8VutOvBT66ZMYzTB1OVoumIOdGfwY2lhvAEdF7VeFeiLU3aNz4VbhHwpC
	IuC8nYYYNMbz5yEkwzIDFHjqZmDkBSlZgQZXbIs7Y6lJkilJ2wAxTT/E0QxW5V4s2DLyEWePZIa
	CDgZ5X0SVbGb4EAcTB6O1HOt9NmdGfr1DZs+blMRliSkk4ZREJZ/8RoyCOQXCR/q7e6qmBiAcPj
	mH4jBKaac5dw+ChFuzxij8BtHM85FY8NxgSuzDA7XAWcUoJJkHuVidTsDywp97NW/qqZw1e+XgZ
	CbDA1ZhAm0RKmUSqAeCsrYQ==
X-Google-Smtp-Source: AGHT+IGs5zK6Ch8KejfddlgpsFL2gRX/QDwoXH7kjER4bd5FDXapFk6ehUlWVvF4mB7EqW25R6CYIA==
X-Received: by 2002:a05:6402:350f:b0:618:4a1e:9be4 with SMTP id 4fb4d7f45d1cf-618b054aa91mr339368a12.20.1755227701104;
        Thu, 14 Aug 2025 20:15:01 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-618af9da5d9sm393836a12.16.2025.08.14.20.14.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Aug 2025 20:15:00 -0700 (PDT)
Date: Fri, 15 Aug 2025 03:14:58 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 3/5] selftests/mm: reimplement is_backed_by_thp() with
 more precise check
Message-ID: <20250815031458.455xxdaiv4m3npxc@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250815023915.1394655-1-ziy@nvidia.com>
 <20250815023915.1394655-4-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815023915.1394655-4-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1A8BB100008
X-Stat-Signature: 1w8xx8m7p3b1gwhrsjs6pkmwrged3ock
X-Rspam-User: 
X-HE-Tag: 1755227702-508755
X-HE-Meta: U2FsdGVkX1+lj8M+zEa4Zjc33LVcksZxhEEnu+Jmjzb7QWWRhbyTTfut7IkgAjRnaN8HneVCez/A4Wm+CUuw8OByr5V04Evq3saOoAUZviU7qY1lqERd9m5SiBkHswJikmrdh3wue+9M6P5i6tDLFSH0EWji2jBd8Tubmn7IamZyQm2+ls27T2/OjFWVM4q2uf9AvinRxycMdHTgrmMUALW7GETxrTOnrWIuwlHqIEKvg+aGJTSpWiM8j4cukA36LAKEvXiu2pQSMNXPfh/w/qO3J96O51uqJktW67iO1xmBZmc9RtZkDXwtfydU2czRzcbQDTQGfbkZxPYbT+hnRmykWI9egqUPezhY2ovRWN2c9++vekwM6sVlD/SmdanCdmwLWhAYWvmLyygENs1wbzZGvK7hViIIjTND7GzEFkyMAXDQP7R0mEa39k3NAqfltA4SWhqehuruDmt/RG3XGZaJsn5AItJ5aZkWtX0qTAYlDF4dU/3wCN8reojr0HHqyGScCsspIpCpe1cA3OZtfwRxuRWAgZgEuitq7zkjSDPaqR55YiFagGmdtKTkbH9VnC5lLuhcO1ae8ZN9VlKJXlypRSPXw+0eJZxnei8clnzQ3FlrO8PhSYp/+l947CuBRxfUzvHf8dYVANsdB5XK4WKQTbO4xbgoE7RpTjEAE+Lk2wGkuKwcvWo0bpSw8/d0tDhIZ3sTKEodN6gid4vTnGLUDGb0imL/03PAWfIvfzt8u2AECkf4vKmtiRpDo99yOT8s0oFCSqcrZCsYHRcle1fEosWO9cyQ29XC2pmuWc9gkZlH7nOWp5+3ieFHrGliUnqCMgRbBI4XohCSjbwJ6NB7hF3QOy09AQ8g7H+28YdqM4HE6uRfTQtdQYDoP/5NFeh/4DjDp3LiFUJ2v1GAwF9C7iO7kwQyYxccP7OrLYdnY+bhj0aPZtyxGVbHXrDaWoNQ7dEtzm3RSpDts1D
 +aIEcDC6
 DouQc45vqGDjL1MoJyukvQwC6qjPxEsS7K4gijTIuksLiarIIobQxToF2GYhuD+735S0B1MPvrMqsRR/I450cRNe9FVzg6ZbRfNuGLhXFeXJaEKV+jjMrKnHnFq0KqYeVgLCx0juS4MRJRViq0rDsM1zfjJP7GrNZ+tL9az2mQW+ATT2h8kt0DfzYk1Ka/efz+dNtAGd55BrXZDknB9/6lxbDH840EsIxv0WPj0zB2EniUJBVxU/liRbL1cKPsOqwoLA01WsABE2GMCacg1fS/+Hdjr1N1JwUwcP21r7o8Ly0lbIVi48Z8kwf2twQa1CmyVAdJ9fxMgwPL7/oJ1QSZNtgtYKqIg0Va0SIztIjNRvWqNSbpladQ0RP26ghpaWlc/0W4mzf8bRv6B+kN9an5bW1dFM3O7Or4KeGf9x4NjS5bOEzynE7MjvEVKILkUSkIAjB7fBkJuRglR825G1M+22OxmwBkLr/I3OzgAqibfXG8mjOqJ2Ynijq5/rT2f1IQbWZodBcODmh69xhSpFoGVpNOlTLAi4d8ETkwHkaH5cpCPEXA6Gd3PQY3fPZGdCKogEp8q1J9kLyEP/3ke9MlCDbXjjG46rdje5v7wBZWeFmX5Ag49J8PsaQ13+oHudXlTZ3bcCqX182nF6etA24CiZQ/yHNRM+lxfIe7psXI7jog0KMmCLYOuRxZ8mUCvtcYGrh9f3lFScO9JhtC2enz6zhFxBSgp0ITyC3YQLVEumPz32ct0JdxXXfFrKiVuAEOoWhcbuCO1Po5ZJP+DQA1hNPmdclEY1BgQDSn//eo01kr/KFv2Lt8l43PctDG19CqZ4h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 10:39:12PM -0400, Zi Yan wrote:
>and rename it to is_backed_by_folio().
>
>is_backed_by_folio() checks if the given vaddr is backed a folio with
>a given order. It does so by:
>1. getting the pfn of the vaddr;
>2. checking kpageflags of the pfn;
>
>if order is greater than 0:
>3. checking kpageflags of the head pfn;
>4. checking kpageflags of all tail pfns.
>
>pmd_order is added to split_huge_page_test.c and replaces max_order.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

