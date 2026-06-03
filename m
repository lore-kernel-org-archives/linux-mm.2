Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC894CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 21:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0A1D6B009D; Wed,  3 Jun 2026 17:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC05C6B00AF; Wed,  3 Jun 2026 17:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9806B00B0; Wed,  3 Jun 2026 17:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B645E6B009D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:17:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4483C12053B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:17:46 +0000 (UTC)
X-FDA: 84839863332.09.8DCDB78
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6597F40012
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 21:17:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jshrpz5b;
	spf=pass (imf01.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780521464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6B/50xn270YOFb+RgL3nLDaMTNlbmRRwqq6mUIoXECM=;
	b=E06Uw/IqH6RvEBNrTn8dG6XbGtjYgK7roIMZ+C0pHiJkjygonwt5NJBrFT4XkWECTKnixQ
	wMoeG1/gvsWyI1BPPY0AKF121t62d6A6NTtrfzwHEIhPW8fyKceJ+8VdLeXdASE98Kbch7
	E7BYZwIxY8zg5dodA1f0/q3yciBdB/k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780521464;
	b=Sq+rOvJq9Ir0chDGR5fKKRm6AEBiP7wZJt2ywRruG+ynTH+bOyZjNREBp3F2eJuyIIfLeh
	3zvd3Ubg8bBrO2RY41wZPsv2f0UiqtGzO0615DF/BuCq8E87uHW+dzcV1YBeVXpxxIXXHQ
	FZ7xTq0e59ipf+pSWRyXXs7lK4fgiWo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jshrpz5b;
	spf=pass (imf01.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490af320e2aso93175e9.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 14:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780521463; x=1781126263; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6B/50xn270YOFb+RgL3nLDaMTNlbmRRwqq6mUIoXECM=;
        b=Jshrpz5bDHo5EzN4XFfNYvMg9VclML1E0NM+LTJ5O8AdlpnPfyC4/Iq2o90ZYGbs2j
         84jHMJQ5ufTO83HQqRq+qx2qS23lyDyoHWQM2ojIbRhPQWdv0hzjLwf6N1V3nQwljPnU
         ISg//VBVRSeD1/8b1k5FAUvSWvNpQfyte3y6M0JmE0fTTOfFv9JycgIDlsxbXKB9Mko0
         I6ctvGYkY10FofLaR5w1DpKDgq0ZqdM+eerXUxiIkgp54YJDF5c2jWpg5h1PQJMbbguk
         2ziDpOxG8o3w5SZavunWjUDizX/3d0FLwryNPajgpJUnkXnwwXbk09ByqX9q1EH0cKfn
         Te8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780521463; x=1781126263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6B/50xn270YOFb+RgL3nLDaMTNlbmRRwqq6mUIoXECM=;
        b=s/YzbVQhGf+1Pxd4mAQ94Ibrh1M601dQToxCqEPWDJ9isbVBaSQbVrSxRZ1SOp4r1G
         O88frY1Sn0LK7fJCdE7TbmN83B3g9qTUTUGd65oYyGL0ol5T0EchBz44Jll8P5UKznOP
         xH5Ku8E/BGnqqdreTbkbLJ844g+30xvLd63C5X33TD9xdjNzrHbSoPbQ0YJU67ow3Vw5
         GfHWLgLGal1rBgbDXIjcFYQa/5esOXPBnjKAUjSLiqJu/CxwnO+1TUTOn4/ZYg+L0G0X
         yznNIYPoq6t9+0fSM/S/RJPUHOjgf+y3A+c79MicCVel2iWMCjPWmnCXpozagXh1/T66
         ev1Q==
X-Forwarded-Encrypted: i=1; AFNElJ+NEpOeWCtv/+Gcy5oqyHx6Anaa1M/FzwzAxWJSDVfwnp7gScJVtBU0FqhtIQzo95M2rxHX58oiaw==@kvack.org
X-Gm-Message-State: AOJu0Yw+0MhAQcX+U0wGn7OqdECzXuagjf73tZEbHujG2GaQxzRMuyps
	TqlQxZmZQbBZnxWOWSh+epSKoeeaopaxVWFotnZ2n6cQQgOfLmpn9iSV
X-Gm-Gg: Acq92OHddMkb8BTOWY3QK1Dvz4BvsRms0gzVZtJF1hxbAPQ2Jb6w8LklVsn1t5y63m0
	K2D3BdHMerRuMAf0z/R3UQdHhpeFIsRczjP/yM1gOsvIKRbjrIKmFOcKEJ0RrdApi/2uqphUgU0
	+0wRRGPtHZWB+9EnjEVSSyi9iewLxfzTfSbJDF6xtmxDy/BSk45Kwh78X5cCMnOkMIIaAcTSo7v
	K68AavEC1KfT+eW0y2RwVz3iLcB83vNSTbR1j2JzvggVw0ignw1E7PUtJvuVkGCrT2gtXucs4yN
	15NSyvsoOleAeXU7RcwgO8fNx3YJO6b3pxgg3cLJlUcFwzc9MYz4qNk2M4C3/7XQP/DHcZh9vfz
	JGECMMooGyz44HJooF4fMWDTspi4g4V9ums/JIpI2AxBVYI6Tci7Wkr1xVs5NXGOQtPrZhkFyyj
	jz2ctKeOBpQ1ql0J3qu3wnG8EXz/10BQ==
X-Received: by 2002:a05:600c:19d2:b0:490:7136:ad02 with SMTP id 5b1f17b1804b1-490b5e94d63mr81490465e9.7.1780521462549;
        Wed, 03 Jun 2026 14:17:42 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b7a273e3sm59171155e9.0.2026.06.03.14.17.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 14:17:41 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: metze@samba.org
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	pfalcato@suse.de,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Thu,  4 Jun 2026 00:17:36 +0300
Message-ID: <20260603211736.755139-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6597F40012
X-Stat-Signature: ysjtmmq5p4n5mborioj5ams3du9zqz1y
X-HE-Tag: 1780521464-53637
X-HE-Meta: U2FsdGVkX1+hQA59Zf02GTWPNz3KXSckavgkQVMTwdgjHzoT86gXsSgqVDXDrBnpFi12isoh8PubmigM0C9asXode8ivV5IVyPt/ar9a7boNt73JpgNKzrooey3kx3K9/GhEvQmYrIaRqkXZeikZmLM8b710M5I9xgz1oFqqkgf42nP/nAwY34v3+7/o6A0Dvx4mp8M3zT4CnBGHgz4d0Qvx29GNwJdh2nzwWWc1cbPtBw/xlrol99Oic/GxaeB4HRgBzdQ48kEwUr9ZNu0/7HasUD8+PKJch2c8PUeIlPUhCRHN5gFlA5UAx/yEhyqhIYsfcIlu/IPNGH4luhl2IG5WJZt8nnGw6QE+fkNzMz2enBHTZq2skngk+Cu7XLUjJHG/jiK+jNoK39PeiisMIDg+3WKg1qViLr98VawCPIa29+VDFLevJO//c5fsrRhLFI8aAJ084qM+HVTowFTsuzmGBjuqIyOk9KK5APlc78QPQqzodcK6Vv2kv6y6UB6P4tpDYjnQFV5qPqVOHTxHizyN7yeV82vudvuXXGH3P4oWeJaTfqxpER7eSzBMpoVwpSFemK3Sx1yKtIFttn622s9PdRbLnWw/yaX1zNbaX5rUay5rScfggvJ53QocxFS0iToo8ztN25k8mK+cfjtFiQieaKmKFzPUsr7V9Q1GXYXblM9EdcqG50Vsfa5vS63RHcn6FuhXVv85q2fdyPHZpeJ8TDIGDnQlWdKxaKs2z6C+E8gMVIlzOYtKBqQxGQDAdt9+b6M69NohZ+6Rjiem3wBsl3oXKVN9dts9np830xS7G2fs5oB29NrqzKxUz4a2vBf2Hf8zmhRfwzJ/M4IP28MgIaHd8RlEoxMu2Z/gHSe6kKMLbZQc/3xfXepzWLQFgOpDvgQEpb2pKpMKwQ7zr1ROjwOhpNmvBhL5q5tcdZO4tmUA7sILbKVgaBRD3r+1h8UFYMQGXyiFgFVLMo+
 XGm3QK4Z
 hO4HzxtCt3IT2J7jSTzUX0fEJJJwwAHrvXMJfY7yoZIXanhSVMaIJfKWG42lzdmIrlTTsUYtC7cLfMgO8OQaJmlDg+OfUaxtD1xV4q8IjAhM+q9+iBRWGwZgGPB94zWXD8wAPK2nieT7oWAZuj6OCYpW0lC9YjF7562QR6l78QOcmwm28rtt/obKgI5eTkLkYs9PFCp2Ijk+JA503mNPBSSJ6ayi3q6nbD+FxTmvXwufOO3iLjQNeUGlKwo7ajLEQOtcuMC83Jmt7uypaSL6iwVsVN6Pns5cyHIVQQAdBn20A0HQwABvaDtuIt+DezOmC92SXrFEEaj+BacZnPmV9Er60aNWwhNUzoq2Hssp9yU/Fr7HB7kMsa8P7NklNFasafijVnpZjvtDwRfRzBVnmOL8Y0F9D8iPLCiALPo8RAn5W0jq+KURQi0jK/234B7Be38CEcxVabAIZuFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stefan Metzmacher <metze@samba.org>:
> Why is 'int fd' changed to 'unsigned long fd'?

Because preadv2 and pwritev2 take "unsigned long". I want vmsplice
to be as similar as possible to preadv2 and pwritev2.

> Should that be its own commit if the change is desired?

Yes, possibly. But this patchset already got to next.

-- 
Askar Safin

