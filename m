Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4D68CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 15:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693C38E0027; Tue, 19 Aug 2025 11:35:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66AE78E0007; Tue, 19 Aug 2025 11:35:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559E98E0027; Tue, 19 Aug 2025 11:35:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 404488E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:35:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB21A1A0120
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:35:09 +0000 (UTC)
X-FDA: 83793905538.25.A59FF9E
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id B45C480008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:35:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZKalyDWD;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755617707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toKbDYdLo7GMyEuHj4fkAjUxHgInySnwv2jgwao8mo4=;
	b=NSoXVvNc98xbgiyerBivN0HsbaaMXKm92rIOpb/UvVoySk3rfz1SJcKdpAzzY+VTexIjER
	wGi1NkmGqhEzlh8j5tNZWgVBMt4taKN9vWH0Ev+cpFIdTkuhG6ckC1ENG/QoU0tJbpAFaV
	weAcR6PU8QyFMnNJGniHq51ZKJoZkWE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755617707; a=rsa-sha256;
	cv=none;
	b=vIKfAbapO2kJVBLe7WUza8TDRRhcv60GCy8XpkzDKJ9Tb3w6+uMBplUnixsh7FbDXOsv7k
	JX8k6pSA2LqRR/YlwK5ykvvPkJ67sguKjoyJNHklQBWjF8b1vizpg3HN6EbvUlKE1PYVoy
	K0GMAzsuTi8dMIatCOPKswK7mnUpze8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZKalyDWD;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-71d5fe46572so49401587b3.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755617707; x=1756222507; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=toKbDYdLo7GMyEuHj4fkAjUxHgInySnwv2jgwao8mo4=;
        b=ZKalyDWDhHsy9jrlorkaZwa74LFAmT4uJ25oUXMOxVsFfXXrxe/GY+R5CC8N6X7TyK
         0+dv+jfy8+N5FuTL0ISiJN6QW2k2o84pECZgYkyFcGNoKRN0qroW+pJuynFtybt1XQ39
         B1JiaDF88YEy4wGZSJfOLS/tNk1D3KZPXnKun2+gXjR4XC45jhzMW9o9XeMrlEQpfeV8
         S6hTKX+kE1izvHYE7aD92cQwoHygm/cNshBk+6UrmNaI53kaGiA4CB4VCI0iy5luxc5g
         Se5n8iBzzrsZZ6olgRIilGXQTGB0KQglYuhMeq6bRFdLfl0MHWqDc0TXy9AcBp56MABO
         Sdkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755617707; x=1756222507;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=toKbDYdLo7GMyEuHj4fkAjUxHgInySnwv2jgwao8mo4=;
        b=xTbEDnNlxrTeaz9Qf/LrVsb8/Qhb2dSopzVJrLC0oKfaePa51P+hDpQJx4A5grZc9d
         6crgr6YYUGPOH0w5/+jMY3uIxn0sfHBS2iuAjbSzs1Wzmyyk/eGnMPhHgmbdBEje/pVb
         RvD0Ej9ruLb2im1uWBeF8W7+5wbbYsIfniVI093JQ1RxQokM1eZND02/yObUzeuvhfrS
         hszeZ9P86petGd5iB3O0R+SmErCgPGSI+to7ISfDtX//Ba3eIHzk0D0A8L/P4lmGjm04
         1QmT5zgjjjfSUpU5OBfMkEl/3ZclzJrZRqw3328oGVcPF4bgZSMYcg54X3BMopUv4TvR
         PllQ==
X-Forwarded-Encrypted: i=1; AJvYcCXYKItVhL7SMJm5ujzbxnmTtFAaMU5qHY6w7hq+S2YLzArhflPiIYaMpJU6lRikxkmuVHtnlkUU6w==@kvack.org
X-Gm-Message-State: AOJu0YwA21hgvVsjYxuJfeyc85ntUkozl+x4oKESBPPJu9ujNo8RHHi8
	xnWNrE7oPutAUZhIj7iOBacaTXYui5vAotxU1bsD/ECAgnnybyzXIhhP
X-Gm-Gg: ASbGncsVmcIn5Vx9M+26XeK/lHmoK/8+wobCaxuOXGF2hPEEubghK6FdXA7PBJG7E10
	J4ySfRyNDZjqDKEXH/B9aPJlCL5DFjSx8G+Sg9WiiyFD3vNQ1q5KBMRlWy3jq0Qm10MwkoXVIVR
	iXx8RdL1vsXklRtIVADWzEeFCoEaPRUjyrwVt5fbuYNKXYE/tdZ7YNLbwY5yZb/u9BuTOmYVCLb
	unsdD/9Q44ACf3R7jSzQuWLUatk1MsqUtmq7LRWnDBuQEAl8MIQBQWY9tgyph+Fv3z2z0fb7oIV
	wc68Wkvfo06E1XGvR1AC4JgolTFB1x/7UKcFKDOoAo+dCjUow/aY6GWe2uyWcZpWDqR4jvd2qE/
	FGNxdnio58Qhoy84AL46f
X-Google-Smtp-Source: AGHT+IEcsXkf1MXgz2gagCv3ucD7FmAzuq2fNp88Yg3wSNNkHMeDfXEGHBsVAKWR4yZOpHcUg+CgXg==
X-Received: by 2002:a05:690c:6d07:b0:71a:2d5f:49b3 with SMTP id 00721157ae682-71f9e9583acmr27292797b3.6.1755617706448;
        Tue, 19 Aug 2025 08:35:06 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:2::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71e6e0aa17csm29743707b3.57.2025.08.19.08.35.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Aug 2025 08:35:05 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in batch freeing
Date: Tue, 19 Aug 2025 08:34:58 -0700
Message-ID: <20250819153459.2088221-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250818185804.21044-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B45C480008
X-Stat-Signature: haoejbfjr3txx8fjh1dspdo33n89t1ke
X-HE-Tag: 1755617707-363996
X-HE-Meta: U2FsdGVkX1+8XURTScO0wPDz+axa7VMDojWZLRWa6ZQcYkK/4HepDtrd/qIvGB7yRVwS83QNz87ad6yRg/IV+qhD0mqaLRMsXMJ83iRCmzDys+VdfHSAlAHlqy/4TSGH2PHR4VV1BeyCKd3WNdz5mnLzqEZ5Dm4aFROF30bgv1qUCi3yh+5upjYZ+W1zXix/5V+LgKy05UgxfpwBP/77Yy8teGuPCW+8adngcJC557/I0zRqsWKfRD38qssdPRXKMAhiqb1ol9WNBJ54jVyvUxe9XASycneXNp+UZflzrCRZ+yKp+dDowoqmEkCkf/tZvn04+ztYs/0E98EXPPY/AJg2mSYoOm1w0P21XoPqrrY1QuQsbfsQOwrKfeA6KxkiQIAUSOzSyvhq86Ba8wrGcHaQoOwS8Pe2SGoR7fI2OLCSHyUWeM94mh3NkhATWB+xsIDtZ5nDzd9GuQyzt5/rDg4rLPoVy4gJvVy76FVu2oxl/EZwzNDoYfzuHW+BPrKi0PjswX/7fs47TmP6ACh41l63fJyF8Ky5QdQK4ikCkzo1lagtMQjBl+jTpHAgOBtYoxA0ePOBF5ezLGmxtNgkbAUUYD2QeN2ek7+IbbXfhgPBHsqnMJz1D/okv7iWMw6V0hSQvkBCpErC6Kuj0K6hqwxs4Pjb1wkShH92ejmCL6Yio/4Tlcsgwkmj5nLSSHFikDj6eojdyeS6AuSf/GR7Jo1TdAVrxoQowz9jhVknx4/4j1ZFYE+hP2c9yV4IR2zSdKuGFveCQxuH+QfnF79KwkwFvn+hXUAiJJ2XF6ieMzx5ls2Y0KnHvcrIUESL4SgPg6KJBX7Ao0csfSN5P5W//KjljmpP8IrznsVmsJPF9dUTa6GURXUPSNWgE3bS3e1Kk0aikk457DWtQfjePUqIWUxfJtuW5d2OK+cMukrK9TGalX2GW3dEgLyDOz0yUNBt8jEAThEUdjIfK57y9Qh
 2wHJvMTu
 trNaeR9aMz5TF/jKTW+oVOABK6WhZy4h9KzlWFHjhXHXwhbw4VTc1eZwOVCOVWi+Ay2jF0q1aqxDTW66GfA0MkTOno7qn8k27vXUa1yxHVLHMHzI696gBWQHabtNrtk3yDP9+NOVxW8Ffr+8xaLC42rn5gzHjXmbj1srjIo3NkyEY8NkhzFrnu64FCCQxaI+GXkCJxsYJgqVc0GW4SafyBFdXY4s4CBHhxMfP50GDbROYLNodBni2eC8MKLsXitilkqGhF1pQy71pcGlECVIPFD1Z5gCwF9tKHW0rh6jodoIclmfi4LblTFHuUxhmMLR4HJueb0jlNgTAXA9s33/MqLzhqnIVR/fUjptNg1jhz9dZQdByVe1W7+SGTpxwjUM9pDxifPJlUpLBcWNZNkzb7pPgKVTbRr4D8hI/wPR/M3we0SZWq7V4g2HJg6VfbDFYqeKavH9WY5JZv7b5y/IMZYeM0z9eLPsk7VIrDzItTodwMiIU9UQUkq3GjfdbzSuw6niSFJVZW7gY0JJayAVT31RdGhwO7V/dnCPoBieTR23wm+2Prc4S+i9IPvYEhCPvYedmQHnmt+JD6MLSAbBdmfwaZz9i0ACWOvl1YnSbNUN96+s6EmBIKnQzP/AM2mORBBs7gyd8Zv84D/41T0ycwleaJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 11:58:03 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

Cc-ing Suren, who works at Google, not Gogle. Sorry for the typo!
Joshua

> While testing workloads with high sustained memory pressure on large machines
> (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> Further investigation showed that the lock in free_pcppages_bulk was being held
> for a long time, even being held while 2k+ pages were being freed.
> 
> Instead of holding the lock for the entirety of the freeing, check to see if
> the zone lock is contended every pcp->batch pages. If there is contention,
> relinquish the lock so that other processors have a change to grab the lock
> and perform critical work.
> 
> In our fleet, we have seen that performing batched lock freeing has led to
> significantly lower rates of softlockups, while incurring relatively small
> regressions (relative to the workload and relative to the variation).

