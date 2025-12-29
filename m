Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91392D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 08:27:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC94F6B0088; Mon, 29 Dec 2025 03:27:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E779B6B0089; Mon, 29 Dec 2025 03:27:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79656B008A; Mon, 29 Dec 2025 03:27:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB5876B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:27:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7ED1A5D886
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:27:24 +0000 (UTC)
X-FDA: 84271829208.27.E5F44E2
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 73CF64000D
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 08:27:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LFoe4JaT;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766996842; a=rsa-sha256;
	cv=none;
	b=22NBVDHVrgTAq3CAf2RtvaIMarhUG1dLoHsRbTNnU9SKhL7gfa8twa7+D9iRFqj8B2ao7k
	07Y/d6I3tnRyGnKb39DztwpEn5LBuF7YYi98QHDaCEYDIlbOx9kg7tTl8wT19I7zw7mLTu
	LsHYUYqQK/xCRKC/NWSBoimfnSI1vkE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LFoe4JaT;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766996842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdN4i2DMWC2lGiJD/4d5sV2Ct8oIxvukmkIqv6R+Lcw=;
	b=X5o5sELoqYc2hly/6KOUALlalPPDcr7vWkscl1s8kLmExYsoInpencozXudGkHXp2o4qbv
	SVBiiBTaLTulwMNEFsOb2jRqlfPivMCpJn8WwVtlgS7yKr3F3zsxzvMrLpLy0gYZuaK3cC
	5RDxVKLugXR9PSbOIvw6pijIU6EYuvs=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47d493a9b96so9725105e9.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 00:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766996841; x=1767601641; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fdN4i2DMWC2lGiJD/4d5sV2Ct8oIxvukmkIqv6R+Lcw=;
        b=LFoe4JaTorf68cu6BFbtz2GKvJPzF/b+bEKN+OfTrpBvrKWqdX7LHKPnBP+4oJjhWq
         oDlMFgT6vZm/jVemA7EUznVZlhp0TtqOwF2E925zhayui/xXcTb1Hb0nCeCPU1oNitci
         tK32SpeSyl/p1qV6oDw/K/tBAfzEApgT0ej68VVQ6UxG554O5vIF+SorLRjxISExDT1t
         T88s/2bnyt2oZmd2G8VK/2LgWTQ1TgvsYKOkFxUdj+5+rxnLIrqDbnKsI/SCgioT6EXq
         wprsNpjIqDifCDcfOOfzNeR0Mwf58lTphvONbl3CsvOF1jZ9+5C9niMBkCoOR/0UFio6
         PjiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766996841; x=1767601641;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fdN4i2DMWC2lGiJD/4d5sV2Ct8oIxvukmkIqv6R+Lcw=;
        b=bqWgE+cLFvqvk3wApai1CjwI6G8jBWLLaqIc4sTlvvXgaLGZkN2sgGPSWpmWD5V1wq
         FihAeinlWfblJ88BDEZlVUW0HAxtzqnakrfv/fh5tvjMGj7nax8rlI60cd9wbb/Xw4An
         0z9EE/m7qPm82dcji2cE55VF96CV9P2jOT9LtipcoV7btTt+/MjaEQpTElGmXA1Gvmux
         fKJsevFzU8GG+bgoLCana3jqe9JfrO5FcMMvok8wGwqr2c3XayL71eW0oQuR+qXYkA8k
         9kPPmtkULNfYZmOB770OHSWl7k4tNE+uqA6hhDtI6IH+NjWGsXAA9ShXcYqxKo9HMzC5
         toog==
X-Forwarded-Encrypted: i=1; AJvYcCWa4zj9Ko/lbFXKEthkrovlWG7E1LtLQ8q+qvFf1ZcDkoMvfV9cVomaL2YXPuEDFE66a5jM2Fljiw==@kvack.org
X-Gm-Message-State: AOJu0YxcJBtCnjEYoIYHT+dwd6Gkcjk+4Up1Wx4HklL7Q3VdWVPLFtJD
	xvkvwmIWqownVGYr4YDO8J0ef0CrpDpyVtJKk07nrRGUpcBvla/n8hityDAx1B1ky4o=
X-Gm-Gg: AY/fxX54VglGm5wO8XKu+V2dlbvYfgNQrbiiZGiG4+0DdycQc3w+RBI21cLHdORENp9
	q9n/h0mZdcdEdogD3ctJ5MaJ0vwq19BG+1FAHdspDu01vvOr3w30J1cWTaxJuBVFnmpX4/4YzVy
	dh9BvOTgg75GUZGU6lbu6HWal5tnTSSP3bsep9FAT0Nak9Z1DRsPNbGwb/x4O1PFujBqzKFBOtX
	S29I29g1K3Yyjsz52B4RWTTmXJmLdOV7WkhAz8Yf/OrRPXRS8VAYlP71DG/Eiw4NTfrcsvBhahG
	AKiWy0Z3g9GGzqqS872NXALv9zdRGXvz+ILd8m6wBHhZbiYYfTS/w2ey4jo1K2VOurPV0n87LTm
	WXyng6UJrVhpoaoc6vluXCHjP1Aek9ml7bCv2w9avGUJ4lZiZc6hBdmICwruJ5TpWY54ufs4fv6
	0HjTHf+wE/w7nIZLURpQJkHN/n
X-Google-Smtp-Source: AGHT+IELwHA+UHDrVzL4wnDtEXCyDMiRCKsNJHLwn90wHHZmKgOk77ST04CvXoQGVeP5Zdga0fQmew==
X-Received: by 2002:a05:600c:3b15:b0:479:3a88:de5d with SMTP id 5b1f17b1804b1-47d247132b8mr300308835e9.36.1766996840713;
        Mon, 29 Dec 2025 00:27:20 -0800 (PST)
Received: from localhost (109-81-26-224.rct.o2.cz. [109.81.26.224])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa64cesm61431589f8f.35.2025.12.29.00.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Dec 2025 00:27:20 -0800 (PST)
Date: Mon, 29 Dec 2025 09:27:18 +0100
From: Michal Hocko <mhocko@suse.com>
To: Dipendra Khadka <kdipendra88@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/oom_kill: Remove unnecessary integer promotion in
 format string
Message-ID: <aVI7Zsr9S1WqKxz8@tiehlicka>
References: <20251228154456.2386-1-kdipendra88@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251228154456.2386-1-kdipendra88@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 73CF64000D
X-Stat-Signature: opjkpkhkt5a9y8gsiwx5nyuw4zi6c7cj
X-Rspam-User: 
X-HE-Tag: 1766996842-618197
X-HE-Meta: U2FsdGVkX18VHBRDdwsM0cc2FDdfce9U+a8qjl1PUWKibTmnzZGlD1pcQA2XrMx79wyPoG+F6WJROdKk6DjYW0Mx3PHZ6dpvF6vcgy+xBuEDq+Mw5uVJULHiJUJfkjsthLm3+UaQKtAdkXHPJSXCn5KtKpMbV/AHI63yqMcfCTcHlOg3wyyHwkorustqtStGqmwVU14Rc6sUCIY6hKLN1HKNoaGqCmLmK6iQoLmXuBtXQkJ/CRFe0u8GS2ZZX3numizMz5vguiQIEIYajvel6QZ0zsIXBIFJGFCahLMbDq9ovBuEZ5By4Ipth2Nf+3JHDhSyDdI968Fa/1LQwiFUK3+KmBAhtJI9/ylNrSOWjZRYcyJ0O0L/HCbWBhjZyHEKShqjSd2u4dbikieond7Ul1Zhf1sc6NHKotuzV1ZRtzAV8/1JH4cH+HRfUeNH0pyuQl/O571UM77MYkNTIq8pXxZO7ONlufAmEug+LAZ9I5Df+VEup64EZ3BiihMvpmjNoymc/+ktI0pcT9YU8Py1hkkjqXY8XTtPYtW0btyOafrCd7gpHEuGFMCGvLo+HplK8hUfjdWRkxH154j5Xkci9XoBscDOBQi5QeGjK4YKekdMXB2+Za7RD6HfwwqiDDC8bG4HYCq7wKT+aV8xJ/pBQKklJINlLwFukNwh9mctZOrBp6K8PiNSlQbUv60tJUnVQ7kIUWNOCbk7ePOLRDCFVgU/RN9XhCzc5Mwk+gjWj9+SeJNj4Pa45LEcXBC7ugrOcSglkJKlTUaZkcbt3JWOkzJt1wFs9uDzG5uM8ucJ57HuYBlCchrklkyBaGDcoicXW5iIvvJy/7iPsfHUhFLoBPc3qCHUDPoyfcTBvz6T5JHZIvnr7rB4TiJUlrn+b95NIjet7lACphN2hb76foz3uZfJ5eJUtrh+eD1F7uekYEX92UtO2qSCFXUSfsZAoC6/785jAtawDQIaseVAGrx
 Ygun0jqh
 Vb41GGl7+P71ll9e7c9ttU51INBMQrG1eiHeCjARARfRMXmzCAl5bvjNF3EDPBQJT9D7yD6qFSf0H9UUEk55aUFvG6U9+PzPQ/e5Wl/IUNdBAwf+9LzDJ4gsC01wPgrZVVgz5RV4bPAiGdOrx2qjqGHYc54iZgVBtdJAjRO1vpEhv9SzL1QER0YBek3xzJ8hhT+VJoIER+/EDu4FrICVLnBLjWxjLy8WtGIx3CrK03Ea3H1Fm3hEInHV8gK0vzZTG49YTSAEPE/hf93afCMwVKUj9BYjNwQNR9KDWO24/uI5L1l/GYMSwzckZhlWc2TwZeP/wCdYyAyPPTQOrEX3YRrNuGM6r6h3NaBpuI8q/TXJrj4wn0KFmkFmlDYinjsmr91wxJE+xQobbi5Is6RCJegBtLuXEeQleCBGjufYsymRwdJlh0g5fDpA69LorH/EVsltx399GXxhbS5WRYpRBDGqmjvacyi/E/USbGSUZcpJ1b/Y5sFXAUKP8tMhJUugV0Tqt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 28-12-25 15:44:55, Dipendra Khadka wrote:
> The 'h' length modifier in '%hd' is unnecessary as short integers are
> promoted to int in variadic functions. Use '%d' instead.
> 
> Signed-off-by: Dipendra Khadka <kdipendra88@gmail.com>

Why should we change the currently correct code in the first place?
What is an added value?

-- 
Michal Hocko
SUSE Labs

