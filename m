Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79F4BC98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 07:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88DF56B0098; Thu, 24 Sep 2026 03:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F026B0099; Thu, 24 Sep 2026 03:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E996B009B; Thu, 24 Sep 2026 03:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5333A6B0098
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:28:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C2E416026E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:28:27 +0000 (UTC)
X-FDA: 85247827854.24.8432E34
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7F344180002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:28:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="du/wEMfN";
	spf=pass (imf06.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790234905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c/+VrgP7wAI5ReczvO0a14U1+2AXtmCv/lPUe03W47c=;
	b=pZVmc9PflVR6orcOc15ojoioJcbmXd+Vua29I+pzT2FFEEnLj3GmcORYjd+kzynuofJWnV
	sl/iQ6/NBibq9bKhzCf2J9VG6cfkaLU2k8xPStuW7i/MhPDbu2Lv2jOfGZrRVlKWr4hp+7
	q9EyCRU1LNsp04mB77pSM4wazXA4dL0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="du/wEMfN";
	spf=pass (imf06.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790234905;
	b=vIzNXeBm2WZHqIrp8h8C4eHs91/rwX2N4a05WbgVBVj1c4zvz+srn0zqux3v5f30+UEANM
	Hk165rVnhtvzniZACyn8KiwkJJP1Bv75GhVgaGzgiUJDRF7Kqpo1Pr84F+Oi7bZWfgVI8E
	5euth2C6dtiE7qPDba+qOFI9Gkovkao=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso13549035e9.3
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 00:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790234904; x=1790839704; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c/+VrgP7wAI5ReczvO0a14U1+2AXtmCv/lPUe03W47c=;
        b=du/wEMfNp9Yvqzv3rwMJ5xFzDCisoFF3eZ8pXftMyGgUwqvbobLZrWskRbMWOEcu06
         rumdNNlxH8WyBWLagensIDRSQCKXVkBYnWZybHIgE5PQtsl2rNPxX8Qk0e++j2cvaq9/
         5MG9qXFY26vrosw4TQ1/YsCtfgKv4aEPwFpmTAjF29qVH8RtXdYd3SGiAa2hiuYKODgs
         64yusN6DbG2my/MW13GJrK6om1PCpR70dLgplz6UnuZwVIs6ahDzj1srN0TmmGEvJ9B7
         L6aIpfkTv8j/Rr+Y5Wi6OxmAP5qsZos6RbFDQK8EsAZFUSQud/3giPeeMTcWHQIRUxf2
         v8MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790234904; x=1790839704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c/+VrgP7wAI5ReczvO0a14U1+2AXtmCv/lPUe03W47c=;
        b=UeaDSdOV3ASe169OOFxQ6wRqrFQ1kpGxbRg9q9Q6gD9RvvDYLL4GU6MtJKsSp+lgxL
         z7lBnYaixXJjEU0hxG2elNvbzOQFibCfXiPowATbM9nqMGBYhxw4rpiBd3taoTDqHSRg
         2/aXuupWVatgVZZBy4U12VIog8rZyotF1A/EdWddZxzAzTTPkw2GE+0/A6E0xl2FEU43
         6ueAfHdysd4phLmqNWaEKR1RqQcRC9ef+hteqOJ4DT9sDBsPMP7k6qxATH8m3DQWZp/O
         gl0d0ojiNhtQRvrSZwuo4ObRXKMAffpYo/wmC/WmthVcynQKquR9QzaS1h7eoQPhsUrJ
         yj7Q==
X-Forwarded-Encrypted: i=1; AKwUvBy/VhqM2Jvjs858I+KNTkrsmQ2rsOdArzLlTHJHWUrtaDezZ1IK1HlKiS2O7cDmlTdbOhFvDyMQRA==@kvack.org
X-Gm-Message-State: AFuF++nSxy6oMsHPP8oh26iux7Hk4VEeOroyQ/unz16mTiwAJ/nukVib
	3lvbE43eV3z0w5qM5psPmVSz+7ehw2l5gCzLVVE9sMWf9j6Cul7H/IuP
X-Gm-Gg: AYBFou3V9g6F7MH4m2Cnvva1xj+fI+ZbSUgjldoTLHzsO8wnaq5WWyNwqmnWlfVxTBz
	K5b0lFdBjw31z56lP/xS8PEyeDm7GvpKaindJUls+Hd6BXiNX3dTf4PrlRBYWbTFfcynBjAsiEj
	YAhYci5+O6Zln6PPPER9PsPV+z+mrR3dBJLtXMKFDBqidthZ8Wpz56Ffc9p3hcznEfVLwtFF+IJ
	XoY5Vd+fK+yaHk5UJEnXuvlxY7hkqx83b2RbRoxBR+jxkuY7vpejgXUjyGArEs0Z4A0NPzZFEaI
	B/dTu+CbP9BScLChF5Tt++UJsOuGbN8ik92Ty0dyFz5sjxhbc7Uqdlqp+KjeAl09sYHfNSiLqwg
	Bm9L9TbKzqm7ODoB1o/whG+dLaS7mErURiaLUT6Iwv3QDGYM4KtoVZv4ln4TNZefLQFXdHqJcS+
	K9FWgr9gzqQ6wav52dobsX3c/wE+buFDK6yI7RZSN7Y9J0j+3iJYszoGiZxqSQd5PK73XQJbSZ4
	hNnlaErFUVfReRfIwx0VuTpmNxzb9kkKQbO+RraT8dXHNFoE3rwIWUfaozdH3UnJcgNz0s=
X-Received: by 2002:a05:600c:1391:b0:49f:ce73:5e96 with SMTP id 5b1f17b1804b1-49fe670af91mr25055135e9.34.1790234903741;
        Thu, 24 Sep 2026 00:28:23 -0700 (PDT)
Received: from localhost ([188.234.148.119])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5cd42f2sm44430895e9.15.2026.09.24.00.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 00:28:23 -0700 (PDT)
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: Re: [PATCH] mm: don't defer freeing kernel page tables while booting
Date: Thu, 24 Sep 2026 12:28:19 +0500
Message-ID: <20260924072819.33277-1-mikhail.v.gavrilov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <41a59ba9-039e-454f-8d31-f647db802ada@kernel.org>
References: <41a59ba9-039e-454f-8d31-f647db802ada@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F344180002
X-Rspam-User: 
X-Stat-Signature: 66e7ofwkfsb4to1jacbtmkjsmz5d1ety
X-HE-Tag: 1790234905-992892
X-HE-Meta: U2FsdGVkX1+4+qBLd+ckMaG/ppqwEKuJYO/Rj5AzO2WIaFeNTW6CW9fHwhMeAztWAGddwchvrbgsbpQdOgh1POiktQZAvsh9BJ4SRRfWO4KpMRWoAPdCONMRVAHZ1aM1Ippu6yGBCdgAJV4fyrqIwGwXf9tbCL2Wxt2/LDR78kPjrCG4uS0cNF91d9/Sqo5TsfiuwDvwDcJ1cc61xCwyKL39z943y1++XuOPskI4n5VYiW860boD1p1njapW5bkhYrwBbQY5hbY1eKBAMxBa5IheYAlEcwSjJSA1OztFIH3rn7UoeUs9HU3xHaGgad5DsNu3y3qffKsQg21B6qDTAV19ANU6wpfzBA3A4aK0FXB/KcuVV9Dtj/aCHpnXvPMdgWMFr5WNFt5IgVmtZLTn5GqDhikjMof/FSXANVbpvRkuUtJG371Jiv/5dxqx6IgIWJOe/zBxRJfdl0IJxqRJhZ6P5/Vt1sO2fz9afdZH4vkOivt7tH91c5VNQ0YN08ufEhCDHFVNxVGUtBIqj2UE+88Yw/VQXBiGNxlHjBvfnSAGpWKz8crJ+QlX+biN270oNtlmLuQ0gNJWi8zUAB8Qc9zgCKxYm58qrSwjpysbmys6+CWxXuHCpfeLiVlY2UPvQqPpRU/L16QzeyQMwIdCO3b9Tj4SUxNIyIeldSkZrfnvmRvfXHJo8vU/bPqZj5JfVGfcdNo50n6WB+cYEjG6UgO1BzOxxR6FaGaUGFgosjgDs9J9VIymgKvVmAowZ2xcw8zM+6wuycHYwUoYcmpk8/z/fWFAXDomVh0a1MvBYU7JFTIRAgaQbmKrM0ultvZlN0GX1WSzpSNIPcDkHd2O3J2MbPGd3SHFmv5Hn0fvT7sEIMZU0e4Mm43sekUkUerMjvl2fvpC0ZuChcpVVpPLckJdYdm7rAL5GBVJMbdv+qokC1VRXGksuTrGHWWPX1Jjk8LLHwI/wXo7Q0sZ1Re
 5Vd+1hLR
 BDsO6tQoLSUgifa/DuyxAKjjmZO6+NzbGyyLfYsMwCevuiIULtF13tgTONO6Ubp/SNqAkctKERneNUfNwaiCCez/CVTAR580C/uFXuUCLfHPcRYPr5/myIZ3JpU/3vJqSh0UjjJmA1I9GrtNF5G4uIuVxjW1vsW6fV1Srti3SOzzTiqwZBQh8D8O1Rrpcxw2ER0PVDX9zBQKQblwrHBpdPlt9va7QSdo9rBabiZB2NVZClRZ1kcXqPPexS1IVvNHIVXeAdTDhvkKiBeIX/6LHQfgzx5C8MMOZfCCoNB2oqP2ZBjzZOBMlIcMOcZQKiB3X4BEHX04EOdUp2czFUX+TL40A/tif9vwOt+/mL/CGeqblu1XAkClaHmTE17wuHBFhz9pYgtegZb0CYJT4i9PuJ4sz5v01vpbchyLrVToYmP0RrR3mUuGEQzw1Fbg/BNIga82Fcsd+UMwV3BN6C/LpO1P9e5VMgW54yhqPvAeSXlgJ5z5eQb42+0Vs1vC4FyPibzG5NulNjkFdvkoyHEtI7bUPQ24ls4Zkmk5FQISg3MPGfSaVn5r3jOE7r4kWz/pChLhOMNfIq8zzspKIrUZlajweROeKdf8ka89G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 09:07, David Hildenbrand (Arm) wrote:
> Should we instead simply skip the
>
> 	schedule_work(&kernel_pgtable_work.work);
>
> and rely on anybody freeing stuff later to just free that one alongside?
>
> That avoids throwing in more freeing handling.

Yes, that is simpler, and the early table then goes through the same
IOMMU flush as every other one, so there is no need to reason about
what an IOMMU can see during boot.  The only cost is that it waits on
the list until the next kernel page table is freed after boot.

I'll send a v2 that way once I have booted it here.

