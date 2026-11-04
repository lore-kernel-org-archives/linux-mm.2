Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C0F606D804
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=RyDWPagN
Received: by kanga.kvack.org (Postfix)
	id 817196B05B2; Wed,  4 Nov 2026 11:15:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C83A6B05B3; Wed,  4 Nov 2026 11:15:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6EC6B05B5; Wed,  4 Nov 2026 11:15:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40B806B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:15:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB7C61A0779
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:15:49 +0000 (UTC)
X-FDA: 85397937618.13.1AB63F8
Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id C298880004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:15:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RyDWPagN;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793808947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJqTJ4xyg07hJqswmJ5AikQ26UFbu12PW8dHC4PPKvs=;
	b=kPQMkG/V70BGRSuj/GHo4JwGfbaN7H9IovcW4YAoJA/8ZEKzcmgNAJu4jHwZg186oLsO8Z
	EV8pm8/D4zimSq35IWdpen+PQn6nbKaTqyPVjkuTtFg0My/90MmPLNpJIkMQaw3xWXdN6D
	+cScZApwQXxZjscwKvNi//mfH+EnFq0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RyDWPagN;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793808947;
	b=0JB00pmRtVStUR252Q9zY5fjomsbabD/g/wLftOjYDXOiDIzDm4wKuGs20DQ6DBiuUae5c
	fE+Xo3+Jrcwusnhp2Akru4h3OsjsKPREl+WZN+Qqltq6ZUG3u74RHceDlLXapJyORf2cCj
	xvVL49/rwhQz9ve0BFMz3JCCzJAWsR0=
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-9906034086cso231178241.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 08:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793808947; x=1794413747; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OJqTJ4xyg07hJqswmJ5AikQ26UFbu12PW8dHC4PPKvs=;
        b=RyDWPagNUScxHXqGIHSapUXDqBtICVVN8VsjPtgONKSFotG/HeXfx39WJbDS0xB/dm
         ajI0c2c4wYy816VbZRtV7V7bIIhq0AFdRPf4qXiA1AKUsM4RZ4L9vPy1Cm0HVoufjdcq
         dTKRqQhbsgntg11f3x3nGsKUvErPs4CgSCvloQtx8YNyZ7hDJ436Vs5SLYf4K9CQjF+s
         3HoJfv42ylK4e5ZPpOLskueWKC2j6mGtxVkSmvhEbhbMDih/OsgX1dIGZu3Q/mibzkXK
         MndQoc3rSRPIGPDcblltHqhqjLKXj/1Jlkuoa5XYcpKeY0p1uNCgYOHnT70DbzYMWftj
         EmZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793808947; x=1794413747;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OJqTJ4xyg07hJqswmJ5AikQ26UFbu12PW8dHC4PPKvs=;
        b=oWdwicLCkc3cVaHzKCS+a6TtJ6+8bvJdl3ZUY3Kvbqjt9u+jp4/fwZEmEZ4C9+t38t
         6x2Nc8H6H3WB1qB7D3K21C50RB3IXEum9sVIf3x7hq2gRLC8yn4hQauFUFoqeQuoNn7z
         eEz9R5TH584QXwgG9ym3n9H5T6DPUVVoVkoZmJhO4VQMyP/+pPtKZP8qx+quHJ96ZtOK
         1iMHQ7b/CdvycUmsRDsCVUlDWhDV8pW8ukzTUzCYzsD3RzfIiTy6zzMEI82n4CBcPgBW
         O+A3TEUC/oSeq3ExcGvlpuTnRPe9V5Us5q1WOt/oEPuUguQWLHPMJwKZwU+SbHjK7EuL
         outw==
X-Forwarded-Encrypted: i=1; AKwUvBzzKCRjhldC96CVR1f1SVsLZVKbxWgetHVYl4fKdV7xW/M4eJURw6TT9oLNgouKEzEV+M+MMlze0g==@kvack.org
X-Gm-Message-State: APuU4Z/NXzeysmoL/Vn3fQlCZ09ObZwLluOqk9s+FQvxQPOifxrbEa1c
	TheNJ4VSJnA6MuhMAq1t6K+Vbc1bzKiOMW0MFrn5JXgGUuXgdChdqiYzD4sPe/8hFs8=
X-Gm-Gg: AYBFou1A8fR3ZyzhSzjHlGa5ZLPM2FO9Ska8PDxKFdgJ1baVhpxHFDtswBTFc0cecRa
	hPNH6dRthvoxxXP5cJ+D+VbnZIE7f8+c1l98TNBfmKPtLwMgX644AeKSjJSpxjAhvFxxaGPZBnk
	JuDFXwS3PbQRzmni/wlLaOHCMUoaq1n0m1KzM7bYOr/5+Cau3osrnjvWMevijs1KSSOJ4sy1q1Z
	QDrz++OR7hrOEb26A6C4/YUyKYP2lO3q+CMxKHjwyZwh4MMYIXfX4klVHa/Tx6ghCdSMtT0MY7D
	J7pf48/P6WU/NjwA+ybjMGXamO8y4THt40L+G7uzU9xMUPPOs/narDx7kPf0D4ATP56AwkoIERI
	KXgmCRXTaaTKH0KpmAo6pyEUhr+KvaSJNshTdD5oyAO0tKAH8dvIGjzCx39b7HU/1LpJvy7SPjY
	/1jjITbBsOcjf1d7EGYNnCvKIe3djp7GqoH/Qti2+0ni/SgOD/pazNF7ZmQepy0ANZ6zO8F4Ojb
	8FjokyydIiVoI+Jr9IvMxtZt0idd6qNrPNvopnytbSpa3gEMwXpWvoTFZMh6GHRXyaj5osQXqJS
	VE76TuWjCWeRDhryfXLomlBnlEzhV8FGtJNarjh1rsD6H8nR7aHFI09MZkUz4s65w7tCFfzvmo+
	krT8nWQ6l8QF/9249gSjwLsPYEFN+
X-Received: by 2002:a05:6102:8092:b0:7cc:9d82:61e2 with SMTP id ada2fe7eead31-7d0725cfd86mr6050535137.13.1793808946717;
        Wed, 04 Nov 2026 08:15:46 -0800 (PST)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d8afbfe6sm2262989241.3.2026.11.04.08.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 08:15:46 -0800 (PST)
Date: Wed, 4 Nov 2026 11:15:45 -0500
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 03/10] liveupdate: Allow file handlers to mark
 retrieve failures as retryable
Message-ID: <autW_3fjUS_hEhZf@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-4-dmatlack@google.com>
 <2vxzv76ck7n9.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzv76ck7n9.fsf@kernel.org>
X-Stat-Signature: y6uymf4kbp165je8fdz5g49fpw4bfm5x
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C298880004
X-HE-Tag: 1793808947-591948
X-HE-Meta: U2FsdGVkX192VwVEy3m4Pq4+CWnRNGAHG16rMT6lzy78wOFjBj0ZRvZV1hhgJwNGurgtQMzESM2IW5jqZyEpHdZMWaQT0yhsMc9AKpcsRVQQW27jIvVk0RlEFDeJR+QRmEYs1O/urv7p94wCje4aLVyjwh8g0nZ05yeX+RLZzR198Hh214ixAzDpEMtQjy66F9C2gB0GdPS4fiTJnMkevStBk0U5itZhJ6B0ATp8eWi55KHWgjW37/bOUC6j/UgoX66oT/+yG++t34Uvs23BQdohLZkAE9c7o60FNkNVWz9UDjKu2CljFbaqh8LbOW15/1vmsDTNcoTRqU60tLIlvuD+WxnYir3trZxM5cSK0CLaZVx5DBVYcscUAmR7/f9RotIHK0sLyv30QSU5HhRYlCYXTiZ/2hHr9TXcBSqhCzvxJeZlyiuUJsGooLPyh0V1S+zOtUDj+oEYapR2kCZ+Vcf8cZyNS8wbLnt0kc6qeFefEjdsAxbpo3lbeJkyFTu+NFdbNQFAtDxyXyD+fsqoVFmt7sudHCA0QZA3GHbEw7ywOdVI3uuGhpLtwNTQqkzTSDxeOOM1g+0UXOIiZh5GN71Al1OVGDc6UEJcjQu/8NS+UgDKKKVsqPoyC3pY1M84vNT7WdMNUnt9EnBB8RVHsWIA2kPFHOHuWW3DCslvNP9A9lBaFvdYMDISD+icO2esDf1nJhuqT8ER7L2OSxXf/J1JszH1cs3eQv1W/zKfvm3PTum2JRlPT0hzOXBkppvMuGwEP4gKBj8FEC2B19xfQOqiKh2zeva93A3K4MKYPLNx6CGCKevv8Uvya+xnvP7gCMlGAVhy5zxs5soSWlEt1OZWjuZEw6eGBEaCEzgzmpOWwuXPXD0tXydwJkdOpqufSGFic4P70iekJ8don/dKkzX2U+4bmdNzEpT4gdS4xwrqxO6B2Ic6eaisaYseJDN1qkjHJ97OgbahvFv560b
 cMqqJcDK
 1IUf3eGdoq6OnMnD0VimVFaHjw01H4kF2MEt3wrn5a24XR2hvH6ar0a2HRd+oTvEXlRcBB/feXBMtIbecGsvRMVIHust9lJERktGdtPceO0nyEJA/jI6hbSmcZLBnf00hb6LfEeKQ0rSBsJBX4WKyFaOqyjE9EWI1OmlCO//31dgfldkpaUnxMSEjL93Q2faeljfL5woC8S96LFswcVQ1UJn0MlCrMCVHMZyeaLv0XWr8xYEBQbUkFsn5idua2IRO7YLy25+N3uGmreN/fJfKWLjsAOSxNjnoeu3fNf2UfkxVOdTPo5FaTJVw6V+Hgre3BENkRn8QvtXXfAYs6TBpWDQo8/SLJ7cyG5gKFrjp8XI4pFXAPaX7T9e3XQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11-04 15:12, Pratyush Yadav wrote:
> On Tue, Nov 03 2026, David Matlack wrote:
> 
> > From: Pasha Tatashin <pasha.tatashin@soleen.com>
> >
> > When luo_retrieve_file() invokes a handler's .retrieve() callback and it
> > returns an error, LUO currently records the error in
> > luo_file->retrieve_status and blocks any subsequent retrieve attempts.
> > This is necessary when the handler has already partially consumed or
> > freed the preserved KHO state.
> >
> > However, with user arguments passed to .retrieve(), a handler may fail
> > early while validating caller-supplied parameters (such as a missing
> > argument, an invalid or read-only target file descriptor, or a non-empty
> > target file) before touching any preserved KHO state. In such cases,
> > userspace should be able to fix the argument and retry
> > LIVEUPDATE_SESSION_RETRIEVE_FD, and if the file is never retrieved,
> > .finish() must still run to release the preserved KHO state.
> >
> > Add a retryable output flag to struct liveupdate_file_op_args. When a
> > handler sets args->retryable = true on error, luo_retrieve_file() leaves
> > luo_file->retrieve_status at 0 so the retrieve operation can be retried
> > and .finish() will still clean up the unconsumed preserved state if the
> > session is finished without retrieving the file.
> 
> Should we give some sort of signal to userspace whether the error is
> retriable or not? How would it know it can or should try again?

The goal of args->retryable is internal kernel state tracking.

From userspace's perspective, LUO ioctls behave like any other syscall 
where errno is the signal: userspace decides whether and how to retry 
based on the error code (e.g. retrying on -EAGAIN, or picking a 
different mount on -EROFS/-EACCES, or adjusting flags/arguments on 
-EINVAL).

