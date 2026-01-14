Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A723ED31A0F
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 06:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C51B6B0089; Wed, 14 Jan 2026 01:30:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AE346B008C; Wed, 14 Jan 2026 01:30:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090596B0092; Wed, 14 Jan 2026 01:30:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EF6366B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:30:49 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 723C21403AD
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:30:49 +0000 (UTC)
X-FDA: 84329596218.27.7CCAD02
Received: from mail-dy1-f196.google.com (mail-dy1-f196.google.com [74.125.82.196])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9EF594000E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:30:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PlQLt0VC;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.196 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768372247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsT/ZmfFtzhm606qNq9BAjdXFdDwemXIaKcdGEE/foc=;
	b=NHUdQb3bfsh9uwvEbEVPc5b7v8INepC22kUgwWBZyghEpxcaExbqXQI0rikDhiz158BvIG
	eXaIOVefhyNxS5+D6sEgcC9VhjugBG/pfZRqGn342/9sataRlw6IsXLn1M+FjXhee9ic5z
	BDxNyCqk26B2p/AJHDeqhUU35ruahXA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PlQLt0VC;
	spf=pass (imf04.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.196 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768372247; a=rsa-sha256;
	cv=none;
	b=cHu7JSxY2nRg1lq640rGP3BxE//h9bIdCLNpOGDlFeCwxnzUyTIBBNOIhgx0O+rB1iySFi
	xjdYx4b9GC5nE7rI/C+9mYPmllvbEgZeITaCzXOkK1sP9P0nzc2fplD4wYv93fxrlARNMx
	38hCRzhC3EL66Z6s7kHmgNW9o+lo1ik=
Received: by mail-dy1-f196.google.com with SMTP id 5a478bee46e88-2af41f558f5so8833807eec.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768372246; x=1768977046; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wsT/ZmfFtzhm606qNq9BAjdXFdDwemXIaKcdGEE/foc=;
        b=PlQLt0VCZaCShdZu4Fxo26GROzcFRk+o5Hm32LMU2eLaiacNTzOqh7q6NZiPM9m3G1
         /lJbICYberobCt49r3RfJku2SS8SNI2Hldarspw1MvmEzuxtY5ikrTlKrvc+Ienk6zuG
         TZCArJlRPMHPOnj4HNDIw6jQkyXNrr7vuOY/Z/5fHP0dwiBAttiqFGD0sWJdDyijgNAX
         3IW12/T4vjxDNGLEMOADpi16Tey7eyNTjZQuDldZsQVNYK6qrZ/Le7Tt2O0yy+monkza
         Al9eAciD27fvThs1L7W8awySwEucNL6MtwoF0cvcwPbwh/emQrtQlpmbTMuPLmdvuA9t
         w0Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768372246; x=1768977046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wsT/ZmfFtzhm606qNq9BAjdXFdDwemXIaKcdGEE/foc=;
        b=RZ2fGd7RcmADmsTOzflLeYLqrXz9KlMlGCRBWZKYBpsLY0EWT1YzpQm6gky7w3zIVz
         zhBHG4ql+jxKDvCKOrkcmmQaGXr6KbEd/7zzA2YAqd3dUcQoYrvwDPNI2f741UGVi3K4
         rjeI2VlkXzIJGjp4YWno1fmNgmNfpJtlor6Yzr2e70xitbleCuen5K0jDr959S9QuwMS
         YkYrQyLBivrSVvwvDwPbhE4Sc6YdPfVqfZ/REoLQX3E2bC6EcVEmo5yX436wi00NrHyF
         99QP6lo1ayJiL7bH5y+wSQ2oqE1pEcSvpPYOkyvj3T5Jg6Z2xR2LDt3sYm1i6czJem8+
         wrrA==
X-Forwarded-Encrypted: i=1; AJvYcCULjAP61eDrpxRct2b13xdY12wxWsAIRAisS9l0UXgFwCqgqmm9WdL6YxsW8JZ9rZ1wOvM/0JVH6w==@kvack.org
X-Gm-Message-State: AOJu0YzfY4iHfLYzmqa1mzX4M2URt3+IDbDitVz0i2YmmcbCHD8MpJ+Q
	eScYMyKTFU1LfQaPMFLuk6mVoPteCnf008cKVl6kMhfE3JxgWOJA+bQ3
X-Gm-Gg: AY/fxX7ZqP3eY10OLWok5+lHbwF76BvGqw4fdVpbxJ3M0FEmOkJi4hHjYaP9RBSx916
	4mcbDr0sxqcJ73/7m2MXrB6cMLKjGWrqTUlecjYq2JEVgspHoMD02WJ/duZWOExaDtUbUr/NhGX
	LrnY0apjwE977ITlIKtCIJHsEcDkHJjExCJwFmsNs3v97qt/MKoLN+PuiE1civbEajZClT8T319
	OaZ1+rEFdMG6Pin1Edf075gOGsrmW0V2jmjfUS/q/EjX7mMN9RZodE4+3WNybWyRSc+xqleZW4F
	MDCJUfUAWRseeWNliv6GnpAkaRuEeLrbmNo+sCkzad9ReBpQPaoH2/gL4SNm7ElSTu3oeVYEWcz
	3XmGO8MitNvUB86WfOc8f/6KU+Eb8CYmbgw7f15pUmoOTYIZ/M19rLw3HDnai12HPIvrymtODr9
	2j
X-Received: by 2002:a05:7300:a286:b0:2a4:3593:466d with SMTP id 5a478bee46e88-2b486b72a9bmr2703868eec.9.1768372246284;
        Tue, 13 Jan 2026 22:30:46 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b1706a5d3dsm18126062eec.13.2026.01.13.22.30.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 22:30:46 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: sj@kernel.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	damon@lists.linux.dev,
	david@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@suse.cz,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH 11/11] Docs/admin-guide/mm/damon/lru_sort: document intervals autotuning
Date: Wed, 14 Jan 2026 14:30:33 +0800
Message-ID: <20260114063033.88885-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113152717.70459-12-sj@kernel.org>
References: <20260113152717.70459-12-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9EF594000E
X-Stat-Signature: 7c1to74y9ys3qtc8nzo5bba4pz3upbzp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768372247-622082
X-HE-Meta: U2FsdGVkX1/YfaG+kVsU6MM1B7t2fdUoIdOM6Lvc9aM6rvSXTakF5PAEwoQfT1HuQERWnuyqG5QjVUc0f7kVnQPQFCAIFdxncZpmz5I+GhzYrC4tjL5MCg5TZwYG8CQ7MGYT8IhDjAgrei8kx3r+qjr3JiBCVogkaJ/dmSBd1OVYzmWsZT+NUtwO11Pdb9fA63HQsjo0GZq5N8frt4im/yIAFAaA27Ywu7tGYsQZiYLH930PGVsEBF0qyKjwPs2uyYUcvnutJvl6YgIy/GKlD3jttq4r2XXEeLW4ImZEOefwa9K6ctrTg98XQgYMW6B1Yyout3d6jICcZ8Q0Pt0fsSTsBxVQNi+g1GjQyOkyt6GXFEFSmpknyj1hKCCUkmB0rqxNq0QvSnS3GA/aeoEDUNAV7F3mtAiGvBlKXBHXVtiB5MVJNkLkbEb/Ts6U93zut9w+pauHALxlFZ7JRlTj5kiHFXO/zjCpBLysDrjrA7v1Tj3JaRGgzZUg7VEDzP4/v2msSU6VNzdx0xcD1o3C8TxrO5atieQThUpdViJIrVUueZo7iFCG+PDgbfqv6yXMQusyH8zWkSq/chrQUL/yg8GtkqZwGnkfLUk9a58FRqNM8/AmM89sQ8IvjuOZtgvwjwDYI5Y9DW8ej1oYsn/1anb3tQjUpnNt6F9RjLEIT0BLPov0d4t6ZysC0/7T67ItCUTihEzGzReExp3zlJEYImTShyd4or7ZJtX0bV1xf8ryFPlIQxzo8LX/y7wLKGFbW9X2Dh6kWLyWPez2M0XCBib1v7akmc9OsKFcmTqizKCTp2FjehBznVQa9/BbqRxEiJ7+YDd14ZB+RIsT/w9o5u5zE6OHDmhaA0ERt+ofVTKWu8cePiVwAAFWidD+TxpM+IUJyfjFxqU+IDK7p/2E28I5lrAh6UzpXYqZBwWmd4sDxlvCc9Lj7WXAcJnZr/4qTpo3qNtkJ74iIn10lH7
 lGQmMYWT
 8koLD+MgslFpScCJe0bxzyWcsxuegM8TC2Vqy5OdV6HlccdlNkSS4K7lfioc4KHWdVMyZq+gbFb0vZVehC60TUDR0Mtrnzhw4Xx2fRXQJeUCFSuvploezGyZLWq/ejt7rGF5ACHvzjvn+nQ9CP2YWvyEPPml8L8HUZ8FwqQ9wD8rBiXOd4MW4uEyRYorNdtAq2IxiwqUTrysbP7cV6NS9WP1oYUVXzRnt2S+4JjVMbRFTk7U8EWiI50IB2KsjMhR00+yY/Vft8VF9jg1XfonOKJts6dSMxXOtW4AA7HgrdO2PTKu88qvIHBcSIlAxhGyC74Ipwem3j+kREpeYPcU7TI3vrfZY9ENvbo1xGPGH+i5Ue+Nq/y3tNvoeb+zfwDjWtvq0Pq5uXVmCo5EHj6fiXl2POw+AsZ2ArRsU3Nsy0afODHHa/vTcaMeJW4mcry931hTn9P0RE8yCoJf8PwmekSK78RpKArOSRiuU7Ih36/9lex6bNqw1uHNJ9HTcfJf/yYLJS7ihOXPq8VKCRh3bfm5gSf5FHzqNLM6S/2eMo8MtI093W/M6erzsyVtN6sTnIka9iPnMictcvCNUM2Fl7f1pVjS/KdPlSJBm+psNtARVzxY4sq+w1SkI6oYkvv77dn5ct9hXG23HVUQwjbR2VsxaeT29yVpkj25GaK458GasSlUfn7Oyse9VvEvMXDWPNO7F8vB12D2GY46RuWFYm2J1kD1Vr3QyWZ4Dmd0nRr/Yj10=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000007, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Document a newly added DAMON_LRU_SORT module parameter for using
> monitoring intervals auto-tuning feature of DAMON.

> Signed-off-by: SeongJae Park <sj@kernel.org>

Acked-by: wang lian <lianux.mm@gmail.com>
--
Best Regards,
wang lian

