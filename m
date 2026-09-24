Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD6AC98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42DCB6B008C; Thu, 24 Sep 2026 05:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 405166B0092; Thu, 24 Sep 2026 05:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31B926B0095; Thu, 24 Sep 2026 05:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10A386B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:39:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9ECA11A02A6
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:39:16 +0000 (UTC)
X-FDA: 85248157512.06.2079997
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf10.hostedemail.com (Postfix) with ESMTP id D84C7C0008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:39:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ruYF8cws;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790242754;
	b=Mxh1b8uYePuL9cjpMIe4EBYvsSGGCNo6UMAmDILSVGVsohMvrDYeilBrOW9gFQLtXPXsNO
	zVgMzvZIwCVKy+kfBRkQ9tVWKv0jJ/t+YIbQQWJoKzr2tLDmXmGjV81AndhqXjhYFMYFyj
	8C4bKJnOL3d57KA7OhK6XcBZ8BDpufY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ruYF8cws;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790242754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bo1Dt03xk0CNyDvjLToBhLcXGkmtA+S3j19+BkyISnk=;
	b=MqgysFDgOnd1Bj5wy+yLyYP3ja6QmE/TmRGRjn17IA7zUo5IKtVlXkAIgKZpRqC2TMEz3k
	R0NsutjUDS/g00vhVsUG/S+pRO8zehUVRVky6XMHgXOyxDod/xT74d5XS5BVUfW2HohO+J
	bDzqu0xCkFkgQDsqQJU19ZLq2Fou2Ew=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f88so1279731f8f.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790242753; x=1790847553; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bo1Dt03xk0CNyDvjLToBhLcXGkmtA+S3j19+BkyISnk=;
        b=ruYF8cwsSgyeKXzQl8WrWfrnKmxMuCc352wplTujC2jaHfCzLqBjrdE/o+taPU1Ezm
         VhYlu76A+neF84iZN8YPlPjuA4P2pz4PqAkjN63koINfJc4g2uWUiSg6MF1KL9Mu/5Oy
         x1nznc3RNGSlCBR/1ZldGZSWcqU/vSU8UcbDrQZUDPxRF+h3SyestrSO6e2+1tGxnx0K
         Migao5p/tOvQyoCFoUqnGhjc7Sr4twjiroFGv0wh7rnStfNwp5siB+ra+vsyn3ITdi0U
         /eaSIe1puSPL9F9dafva9WgZKBYg9Wos6J2OLLJ01GVTn7yhimM6m+JiL15WMAUZyjPY
         1/lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790242753; x=1790847553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bo1Dt03xk0CNyDvjLToBhLcXGkmtA+S3j19+BkyISnk=;
        b=j55AtYZ/t3jQ+ffYnyScTUnzIpWonQLYIRvszvPS/7Dy1foKNQfFPhTHQfLlLveBd9
         4Rca6aNvbgJiyB4iAlcBtj9BN1q+JYNKx/FEcTKQRLCSY0q1jA4pJ+6pu+Y1gnc491kj
         nk/Ni9yng+3WhhQ3k6mVEemW+tqz1LvXaJUAHk/GcRX4/QuhWKmPQJTp+2W9cT7I6tW/
         q86dOn0dtHnebH9j2eJ21pMqqL/dj834TydaIw7GZUz6F9U0HKj9h3TSlVB2XqJfR4aj
         whKQGvlnxL2LDaDvR2wWDwkm5tFhYmFZPC5rX18SRIfOxr4C7Wi4Vci9KwMWk9jnO8aV
         Rv0A==
X-Forwarded-Encrypted: i=1; AKwUvBzD08svO8ce2wZX5xGcaJtVWVOo9PiYhNRl7lnxNbpb7MhbNntT/8wcR7F3CcSAv1+BNMsU+5naaw==@kvack.org
X-Gm-Message-State: AFuF++krzpen6YszW/EnHmLg/jZT42bGZujnNdEpo4cmRO8HyK0OLpJJ
	A5HDgdmQbny5awzKfNxAvwoe2hEFEYl1xNZEgcWY+DebdZr7iUOU5pqh
X-Gm-Gg: AYBFou2dOQCHeEdWUFTIybmYhAc0cDS1ubp52lCoDGrFJIfRFrMGzZreoEFKcQYhsg6
	3hlDli2y9wPRLh8p2eu8lINyG0bUUN6OLh9tApEgXmG5AXGs2UACopu4sqS9J1WfCp9OU/42fc0
	IatLd512P3m23KDOyUH8+5Qq3LCPGimqY36PFmbZ8NRAGDsLvuY5ER0bGcVfZi1kOb1Nc46DUBJ
	FdF0FPvz4I/hwkGZwV+6ucLaJE/Y7Hf44QXmNFAygfZ2rsib6mXQpP66ffHaQA0Ts4gzoM7xCd4
	2UbzA49LdPBjvYLjhyUE0vTcFy72uyuKCSck8nwpQdclgsK5qT4e1Ovj2E7OjS8SlzyrKgNeOiz
	Y2aMF6txvwLeH9/4U/bb2oa/SYbKxn/QmcF7oLOzYjbpesNuUccSjGKCrbyqUUjpuqLqPkZAie3
	yNCEbQAvonhvJG7dL5jz7xXdDnRX/AfzVB8Nsm5pMnTcK5wKa9I3Vr583eBf/XEsFm85qYQnwYa
	IHBm1WmJqKadKE/FKtOEQlm7KV6yNjz5OfHIu9LpJb8wIpKj+TFQfVFbyVE5N4B3lbRq1qc
X-Received: by 2002:a05:6000:617:b0:486:f46d:bb02 with SMTP id ffacd0b85a97d-4887197b60emr3087180f8f.57.1790242753297;
        Thu, 24 Sep 2026 02:39:13 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-488682668e7sm15230022f8f.4.2026.09.24.02.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 02:39:12 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	x86@kernel.org,
	linux-mm@kvack.org,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: don't schedule deferred kernel page table freeing while booting
Date: Thu, 24 Sep 2026 14:39:09 +0500
Message-ID: <20260924093909.25643-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <arTtl-7Nl5Ie0SEs@gremlin>
References: <arTtl-7Nl5Ie0SEs@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: mn3y4sdjrarphngq58wn6qnxb9hz4uix
X-Rspam-User: 
X-Rspamd-Queue-Id: D84C7C0008
X-HE-Tag: 1790242754-657733
X-HE-Meta: U2FsdGVkX18j07A2Y4Skiwb+95SIi0r0/tAp6mAqLQhWHGeBeTQHmqtBAtRF6Pdzbu0jvuMsumYmCBMWBAkQek1ix/3t8p4eJZszla35HiGfiSXcbAcQKMG/RZTNVEo/H6UHzQH+tuD3amiHrC3OrbSjAoU5r9kpWYOjJn+IcbjLVkI711SSIlMIUOVwy2nXEysP44iNhLoMLVQammC56qz7VK4r4WGP6zFUvR6mkKDj0zwjEJl2aPO43/St3IwBt6aPluHGikBNLVUsy4mZt8LJVUfEiNlsaSHizMNVdaqvSNBTBIjjdzqadG++wrvJpUMnwJxtiECPXqtihPu7nYLUJQR0ag1ItbrPJwiVt5TqrXN+0+Xb6lE0aJuBCrAreawQJttSFgf4mPcQiM0qgHbrAko3MutZE3Yyi13vHLGiMkKo/htLyT2WUZCVR8T3AG/8cB88/Ey/S1QuY9rTHTODWVEtLI5cLX9Sio0K3RGTxjxZBcvC17UHv8KdTPfUV1d+XnTRD6xRb3gLa8E2ryQ6OUDNxdRxX5WPs8SehHO7eVT6rzLchREN3ojaWXa1ETKcKXyy2RYa/FIH6YsA2RnKc1oIwSjXqRcfwifHxbV9jHNSzJqx7Z0Btn1Im1rsVlPz7D3Uo7j72g5w9N/MMINAjlMVpjUknNWJRqyb9hixjviM1qjY/K7/Zf2GedjnDOf2FHLAK2bCHaizqjHh1tdYYFTQZVSqmDxV1enfWj/i4d4LY73GoX9TivOo75xk/cs6fZveuhGI9U1MntEtur7WZECALZSLRigM/tqrTXRFnH467HSwyGIqkG9l0KrPAxI3llsX587CffI9Y3TTFkWnCn6kBrxEjxeCY6XioITQef14b74dXKPU1kHL62Shft7SNhLKicM7lR9Ed92S8dQ6aEH5dehbCQTo8++Q/Hf6La4+0tbfCvOPWHxWt3rWYLxLkeY6E88Q/KJe7qQ
 bntYwxaw
 i8QdI2jWz/Ew5X9J3cNyWs9SzsdP2UyzfDWaVM4VmGwqqwz78lJoVYJbF5AdFgKODNZ/d20Nv3UJWQkX5SzlKIWsafeKtGZUYy95bUKsajQAwnw5N5xfYvBXdqJ0iUoYoE8JIsIF5nBMQdM+U60WeAsBrj7b7QcaNisGx8h7SyxkA9+ctfM6XlgK3fCNZhwOcz/PMudC4+mV6uJ8k3haB5gpZl7aUUYZMP+EIvJ8npWDQ8zDtDFQZ1eLXycw3krgG6vE/OfNkER1ZGvnZrlBbi+Q46E1jLwrAh2Z0TGyHg+l21piHSDJ5cbRpXWekMXwfm2L9t3MKw61e15dHYGzO3mPXRiiWtr/KRBVyFAN/hXZ5Z50RFeHtOucAUF6GD8J4gU04xaF4ZgoEap0t9wZLR4je4O4hvm7AZGIZFpQciUINJUlu4iWMBbLxVQbRVgus20yx3qPhW0GjZe7fVd+2QDAVYYmO23+dZcYLt0OioxHip6I0Th7LgYZ12S0Dx1HeVaV2+Wiz65AB8dyXfN3QW0YhWBKzkyva0oD2nFPK+RkrdQDnVSZIqXdZIwuJhBC6eAJtQN3V3epdcbU+NZG09d58mU7FXwzj0ekn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 10:31:15AM +0100, Lorenzo Stoakes (ARM) wrote:
> I know I said go ahead so it's my fault not yours, but in general please don't
> respin so fast :P

Noted, sorry for the race.

> Maybe we want to ensure the drain? Like below:

Yes, that removes the one caveat v2 had to state: tables queued while
booting no longer depend on a later free to get the work scheduled.  On
this box they were drained at the first module load, but that is one
machine.

I'll mark the initcall __init, boot it here, and send a v3 no earlier
than tomorrow, so that the others have time to look.

