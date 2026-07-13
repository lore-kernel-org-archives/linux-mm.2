Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57CABC44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4816B6B0161; Mon, 13 Jul 2026 12:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4590B6B0163; Mon, 13 Jul 2026 12:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3719A6B0164; Mon, 13 Jul 2026 12:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 00CD96B0161
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:56:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68813A00F9
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:56:18 +0000 (UTC)
X-FDA: 84984356436.30.8284A16
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf05.hostedemail.com (Postfix) with ESMTP id 83A82100008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:56:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iQuJ8SAx;
	spf=pass (imf05.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783961776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wyTThpzWI663yfCX7yR0ohXV0bj+fwjL2+oCBrswHw=;
	b=RogDio5HuF6nxS40zFGBelO2mc45dlKKgV1lOAXoIu3jhOJEk1ToC5MuqIewhX6OFammkk
	kCD7I8DQUhnwC8umK3mqcm+FQoZCMrJl/jJZsXGDH4/Rpasr1AiKo0PIH6e60w2ipvMLUN
	wP6aybBjd+rbYxMf1iLlonkKDHmlbdk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iQuJ8SAx;
	spf=pass (imf05.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783961776;
	b=HquXfj4Uv7oMm7mFzfdBFIIsJc1PUHiawbPSb3kavaGQ8g+FhLKb6UawudhV3acS+n+kJQ
	m4RAe5mRuW+dURncGZ/8WQt14tG3trC6Hcf8pwxSW76xr4oj0HdPAT7NPxV28NDP7dwz8g
	IRMctrbig1tx2Fvi3rfi2N3OEmYN+NE=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso78968a91.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 09:56:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783961775; x=1784566575; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+wyTThpzWI663yfCX7yR0ohXV0bj+fwjL2+oCBrswHw=;
        b=iQuJ8SAxSQBB4p2VYcPpL2RZcNFKQ3jEC6Eq3/rxOwzFjiJjGxFyH1EodI9x9SpiPv
         ZPkuVrAO8cRrWps8xfZeLZ8c3r2o+/aQ/Gn/EfsQR7yWDEelhiwHgfdEJod/148SknEj
         DEBAxKEjd0kUWTNGnpu+kI/dc4nPPRuhZg+zirF6lMf82aH8WMJg763ThuuBQWaMOfyv
         WygeXDzyeN18l12UBZB1W10oAXk4kYnLZVnigKjG+hW3Cgt77GH+e7lC2Ayod5yBrodx
         Tn1smRqg0FrPoxuHHB0Zgfj/jQGJFhJPKbmeKbGAsTkLGtV3rilA5TPWxUrh6ojHiIq7
         nxkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783961775; x=1784566575;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+wyTThpzWI663yfCX7yR0ohXV0bj+fwjL2+oCBrswHw=;
        b=lQsM9qyEb/YR6bT3VkbQFR3tHESMlMeuhKAOS1IOoqgQhyXcV8Tp3kxGrq8aRFlNv0
         NBx3lGJ/nKI68iP4jlWx9Evp3zq7M8fXeISJYJlzj6ewUXLDMbEk3gxW9k30RF6LYXtt
         i8CLaFnpYavmjAwQh+VMxMd6w73chK6dkBzPV96YPE+MvrYmFqDgLIApHtiXGgecvzju
         rBdjEnkfwuvSuvb26o6o0a+kWdxOKhNV61e2U3We2P10Y1BFuzMqKBeI3OjImc1+zfZv
         6aDMDhD/YQzx8lK9TXSwQ15nHY31DEQhtiaVlF6u4UMmfwusb8PJVVS6m2qr9lTVh0ly
         xa0A==
X-Forwarded-Encrypted: i=1; AHgh+RqXWgL7PYVmzqaQ86bHg+Dm61V8XDxMZ25nGIss061ASx3Moy75btYVrdpeBpWjFZDRiUUi92nWAQ==@kvack.org
X-Gm-Message-State: AOJu0Ywd5yCZtfGSWoU84lLnkwzozPHVbE2zLQDyxxNTdxWr09fr1/Gf
	SIv15x/70DTbCKzMSjyEhbBz5Ybma+/h7/pIONNt/piCubB9Vu24bk70
X-Gm-Gg: AfdE7cnmc9iTtzqpyGrm7ejaWA4SLqrt9AF0euEu53J5viWVwM0K811Akdv888SA3r7
	S75Ve1tcHsKByCJM3rRF5QGkKN15pvHKp8n3RiglKEaz4/STS72ZX8kBgso5e9QqR/ZJ7yvJLKz
	zT4OiwfwtbkrBZQmBdqc+vMEjjkx5av++/T7kw3m19HmmEHn3+3TuuOt94MGBhwi8C953xLBVq2
	oV0KIgfiryZRctdvQfhjQwRq/BThYeJMYpvvpwLgyTJ5thOQFi1tYB7dVQXNrE0zz2OYbyh4jfe
	5bHR1maNvx+CtRnZ0vPLe4K3Mdol1ibIP3uvW3+++xGJXsDcoarm0CbgvNXef69B7WeZ5v0VWfu
	aO2MVw50yxy8FnJkJHUzvg2GA7npRCNFXuIDSbCIAUDUjHjtqNAxyVYVR/P9SS4a/PG3Nu4euql
	D/gjPIWOuOPAW1iduQSQf9pYD2fyTnKjBrbkh+fOo1C9IHIlrtmu01sE8=
X-Received: by 2002:a17:90b:57cb:b0:36b:769c:c037 with SMTP id 98e67ed59e1d1-38dc81978ecmr7351194a91.5.1783961775319;
        Mon, 13 Jul 2026 09:56:15 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e1745a596sm180718a91.15.2026.07.13.09.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 09:56:14 -0700 (PDT)
Date: Mon, 13 Jul 2026 09:56:12 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
	dakr@kernel.org, david@kernel.org, decui@microsoft.com,
	haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
 region faults
Message-ID: <alUYrESVcHR_p-S_@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <178371881034.900500.5214601525971121683.stgit@skinsburskii>
 <20260710151216.0397a6f9ac5c7b4ccd274cc1@linux-foundation.org>
 <alG1JwgUK44dCiN4@skinsburskii>
 <20260710224606.69235ab5c49b5987fd33e924@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260710224606.69235ab5c49b5987fd33e924@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83A82100008
X-Stat-Signature: sf7yd78jfhtyqyej6x3jkyzx7crxji9i
X-HE-Tag: 1783961776-361275
X-HE-Meta: U2FsdGVkX1+/KaWGD+lcPs/m2+qghLXiZ07RZX64JHO1d8b2kmcuaPNGNAtnTiEQNmXHiIx9PVKZOO52FYo8RlOUEsDd5VpAsukasrgab6CTT/+c4DPJW+4g8VOuaQkrptVYJfamj0l5B/jgBjXTJegmmGyMJN3HGTUKzh4Sxq2ImbjSCdTQrb50OjeJnMgsAm0aeHY85/BViZa61W9CbBYfkJ9gAShG9hF6D+FHnGYDQkBd1oTZv6aQA2f570KBv+rMp8EwI0b2REEda2pDDDDatTjqyAzg+nTHCujEdjbISB7JADt9FzlZL6SanXmOmnK7xdvqQqKibeDuhF15khzd2fZtQY8AuJZ9/N97QA5Dv7FjuDoTZ2ieis2pejRPnBYDRjxhJuIPLNCxlWQrFWNzPgW9vJzmpnn2MX174E1Y99mcRvsCJmaEs0M658k7rOkuJAfdJbO0XSFHTkkNeaSn6m0e6c8qCUxmC4LHFdJwBebhaC5n8RV1r8WFpAvB2QY5QOZLVI50fMr5vLYElsDzd9DvylqiX80Wg/3alTFDJe/QhWam9vISqFbpDpRnCR+ZDkso9JpEKdLSVGyMXwzkFFvu+P9fSjLxlWyEY9Uz4P05fkClueEez2ItUpTPmICt8rteWdbSevPBOwK0VT30ctFQLKJlX//Zzi1nNwqOuZYmReXg52WhLI9ZarWq4bR6eUc07CuK4yEYfHP/nrJfZtmWQtbO5KHoOKxVi6ZBkgwz8cGQZFEpyQvsB/8CfWOUZDHgnEl8utxLksRdUZ9hlrs2YPreJid2PpBVw/eONbowJ2IUTvkCXHjwg+MPkcty3Cx+HjvBAdY5uE56GtUcJudVYBeJ3/eoV1kFdkQ4jQ23bR0hj7KjnzY0oKqZyBkRhFhR/fS7lS7G3B8MXvnR/4idU4b9iYoaNI2B1MVVULnbch+KAB9kNEp9Zt7dWrVOTghu9G9SjnFobL6
 LDmmIKKB
 4raTFnRnzcC2HxrDCf6y3PEOoS2Fdj2k6BuF7fwR6nJ73izuxr8WGpTjz3GHXJjywT7QYWobS1F+X12N49kf+a1MRlHcN1lbePyEpiee33VWK7fTI5SI8epKx/sPK5HMK2MnRYo8KPNOWDbN/5mHwnbYiroxAKFrsqC/NmJAFTByitdqDlsR2AMQ7tpSxbBYllp3zH8rgN6G2WfgWZ96rzG3AwG2cdHwgYo5q2vVDVRNUvA8djG5Xy0xKbzAjCWNE/EiW6mDbHunbhuwvelMln2ud0Eip70TUNiWZFNU8UtebFHWAg41deuHjZIANy1LR/mZrsOgKP6TyDowKKwe9VSgZM1gpGjWUo/ScRQOXvQxti5flGIw14mWNfdX+kHRUKGoNM1I45+h1sneunxu5JQd9D+sD6Uw4eN7O28tagjY7RNsARxfrJ815EXrI5EDBluQgfy81SYHa964YLhXve4oDNEomJO32bZDrVfrgKHwa0MRzxCpSlHHkI3Ij0ReWWNKmMPZssvqykNfLuFWkiKQM/XntIlsV2I1xXmouVVSlO0zeB3QXqaDIc/W6D4LVHqnezu0F8YS7NnA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 10:46:06PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 20:14:47 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > > > +	mutex_lock(&region->mreg_mutex);
> > > > +
> > > > +	if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
> > > > +		mutex_unlock(&region->mreg_mutex);
> > > > +		cond_resched();
> > > > +		goto again;
> > > > +	}
> > > > +
> > > 
> > > If the calling process has realtime scheduling policy and either a)
> > > we're uniprocessor or b) this process and the holder of
> > > interval_sub->invalidate_seq are both pinned to the same CPU then
> > > cond_resched() won't do anything, and this might be an infinite loop?
> > 
> > Yes, looks like it might.
> > What can be done to prevent this?
> 
> Well the best way is remove the polling loop and use a proper sleep/wakeup
> mechanism - mutex_lock()/prepare_to_wait()/etc.
> 
> If the polling loop is to be retained then maybe msleep(1) or
> usleep_range()?

Well, running MSHV - or, I suppose, any other VM - on a uniprocessor host
would not be very efficient.

I’m not sure whether this corner case needs to be handled explicitly.
But even if it does, supporting or explicitly forbidding it would be a
separate change. As Jason noted, this is not a regression introduced by
this series.

Thanks,
Stanislav

