Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68EB8CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 16:36:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D34E06B0111; Mon, 18 Aug 2025 12:36:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE6306B0112; Mon, 18 Aug 2025 12:36:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4AC6B0113; Mon, 18 Aug 2025 12:36:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A8FBF6B0111
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:36:22 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3FF78415B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:36:21 +0000 (UTC)
X-FDA: 83790430962.20.80CEE2C
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id B23634000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:36:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=CzlUFtiZ;
	spf=pass (imf17.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755534979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8Qw52IvfeGqkNMfZ2jn+p5tbsiqR4BTKmRhpUh8Pow=;
	b=aJK8+lDXnFde1K9qct5ilSIhPKzsSsbcGRyAf4sOClWI0y+PTzX2LHw68nigNVAIgbaTfS
	rU2EnMDaq6SvSD5Ei3oZR+Ii2syLdv8Fob2arAwWubgDT2QcgNZNbCtWko0lHV0AfL5sMz
	0ihY3SMbD26XzdyO3dw6mMECA/jE52Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=CzlUFtiZ;
	spf=pass (imf17.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.171 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755534979; a=rsa-sha256;
	cv=none;
	b=rYJZ1efF+x2kqiQb+q6zZDMsVBLkEkwmOxv9pNcNFWpEmAhG+1EEnKlgQcKZzNKIT4UP2J
	f2yciQlkoP9wJnz4pK2lxoNYY4zLNOwaU3W68izhJgGDpDM9N/XE/yajnNWdp6DI/RBIhX
	1kNtlxXBHfA8aNaZv+KDX6o5kLWAQP4=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b109a95f09so32965981cf.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 09:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1755534979; x=1756139779; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g8Qw52IvfeGqkNMfZ2jn+p5tbsiqR4BTKmRhpUh8Pow=;
        b=CzlUFtiZMyhJzkKX4Y1txUxBZcOG/5WEXNAWYvopQrzBbv6RkQEXwr1rUMSpG+30yb
         WyDwnYu3PJ+JxkuDvLFfU6ftyfykXJD+hRdCiVNx39rWuaIuAA6lm+on1jnRqrLm1rIo
         o7OqTg8xv6H0F16zETwyTAm3Vw2bDZOHYPM0Bizs0UBJCew/1EoZIe7G3EQj8xn8poyR
         l8GLO7AmC+J71J3EN4ILP7joy56ChMib+g+ILVyHSQTn0cMrYq2ZsH/O7GS8M2fYf3Tf
         zctWCYHtDQ5nhfmTM0cIfCJTzNu7yYMfF11+FQUTpfO9jQhc0RVqX+H348kGJhkQfCuy
         pXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755534979; x=1756139779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g8Qw52IvfeGqkNMfZ2jn+p5tbsiqR4BTKmRhpUh8Pow=;
        b=WPOLjzvwtnI0Xe3k5Pwbv37ejjRqpLk1hP/Rv+6aUSc+11poOLTN9ahXBtOmmlxvAo
         GhQoJwwSzn10AeANsC9rLoicQoUYNagujWow6mH2IWmXByVbyMrnvRsYNpI8ulptZwSP
         fHmIfy4mTHDgjjdkWu1NjOzxzIHP8ITH77Nh3PJ5dgiPoHvjciz18tAsBL/FcgjFEqya
         /fLteSsm2d9Loeavsgj5Jv9Hl/C8p0UllkBHLBIAV1FscaHhfxDh8TrZmOb7yMn+9IBR
         4ucTpss6hhASq2Ed+xQpTFQ6cTqpzRBEX/4QTUW9TUatqZsSyKdcVn3ottfmS7CKDRtH
         4fOg==
X-Forwarded-Encrypted: i=1; AJvYcCUcY+k2WNjKkzc9Zc4VSmPkO9AqUrCcj7tnIMPZUHl9EXuR55JGNF1Nil1l9uLCWPrdqHIUxrOugg==@kvack.org
X-Gm-Message-State: AOJu0YzaSDRN2KkwB38WxUWUWLyb8gvo0Eo5syWPPDcMFLHqpcxkw7gy
	JGsCtIEWWpcObC8APtQ4zgoQhdifSfDo9qeDsaYFDZ7kb1Q2R7KygJRFB2KWkiTZ/Mc=
X-Gm-Gg: ASbGncvrivsTBuMIVrL0G/AnRE9x2GcJmbFQfKIFtHeZhji+5W0Ln5FtjaqAFJ9UUZB
	q+sPZWcssUziYKc4VLAlx7Qiq+q0Wwxy8S7k8irDv+OhAupRlUFyn3ew8yKEagwGw2agKJPn8JS
	R8Bb4ABCusK+/7MoiPU84Qw+fpQ+ekh9zLVarkWEhxA1j1m687P4479Ennb+fx11U48exdjC/VO
	C4nC9+1G0HodD60nQ4IJmzL5hbikNq6E61qdhg5lWa/8uzOOeT+esYFViLm4aTUK1D6oHoVN6sO
	i7J91Q9qgD0YkZQbc6LhKBJ9lN/cwx3BFNiKG1OoClHO9xA1nb/o7pk2yT2zm/LGKMxC4x36
X-Google-Smtp-Source: AGHT+IHVTekjFOmo8tz7Xgwi6XnFUskfa5a09qL5qXfEjb1nIAksYckiRGpg/LVtaH6xVkuRuKrP0g==
X-Received: by 2002:a05:622a:2d5:b0:4b0:b7d2:763f with SMTP id d75a77b69052e-4b11e29510cmr187661001cf.47.1755534978599;
        Mon, 18 Aug 2025 09:36:18 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b11ddd8727sm54906631cf.39.2025.08.18.09.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 09:36:18 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uo2qH-00000004PiO-1QzU;
	Mon, 18 Aug 2025 13:36:17 -0300
Date: Mon, 18 Aug 2025 13:36:17 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	intel-xe@lists.freedesktop.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Subject: Re: [RFC PATCH 1/6] mm/mmu_notifier: Allow multiple struct
 mmu_interval_notifier passes
Message-ID: <20250818163617.GI599331@ziepe.ca>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
 <20250809135137.259427-2-thomas.hellstrom@linux.intel.com>
 <20250818160726.GH599331@ziepe.ca>
 <aKNT8GUu0r3i4Ikq@lstrano-desk.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKNT8GUu0r3i4Ikq@lstrano-desk.jf.intel.com>
X-Stat-Signature: m5equc5f6q6yfugpk6gs7pra7czy8cnf
X-Rspam-User: 
X-Rspamd-Queue-Id: B23634000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755534979-985631
X-HE-Meta: U2FsdGVkX1/FLzgWvAhWs6kbQUWMncbpq0Y2DOyJj+GtYLScq5ahmsVKNQlKIbIX39YSYFWdaLx4l3gJ1HW9mtN461y4c4JrNslfygAXgrHZif8yncv4QMWO4aegNz/qR/bSxPv2ma155Qr2xe4h5M3mysrKbRH3dcLne+7zzzrpCcFULwQf34xdIh0Bp+s6N4ZpaxWDQ4FK/9XPVk39h63sf3Wa3CFYievagaoED615iAXwjNmhdWE/93Gwr5lMX420cBQSeMlQsqAPrYfZpT1Pq8J81o04vN6eqnz3H2S0f1g7nH40R+SCaQKDnqNNUFHkDaWdjXlW+pdiOAzpxYNr5CIHMZAq4q95e0x5AeInQKVezwBqTmmLh3kC9CRzN4tLLyLywLcvQuiAwtXr70YjElYd03fCt7KIqXj/N6dYlJmuRBF7vHitoN8kr1YJhop0DjUe0e91UkN8AMH9raJG4MOgPJWLzcC/pn6jrXneEFlfikXyrsBERYTBY+M8H9JkprEuQeCWdrFgSaWdGDTq8ORsmSQ3+IWZDiwUQ44ndmhpwpyYOqLVkeIzJRSJlEcKCydUoHD5r+0COt0QqCeVn91+mqMSFq6xLH+UH0kYcmXjWM2+MbjZP5gy0A0QdGzL43mrLdHiW+/iaqGKGZbY16Yg9TszCMM0c+ozjMHir+u6SUjed+jJSE505dGcF7OhAT06FMzFZkbXcpT0lsb7tjsEilVkWevKYv/d8408ZiIeGEvSXLS5GkSI8Xq5b8ptevAjYGo5PJ+7MFMJuUPSrhxB2HSOUhOICXGn/uxA/WbG5d6Z1PRL74fO2ETfraYaAIjsskhtApgWJ3scOv+k+OdT9MyvQcXFvADWSTzeDPFi7s0avdes1bR+0EPfk37cwjdxYro2n+A+3HxjM5dS9GkcgnwRQyitrvdQLa2Wr88E2t1TBAVRF7RNEYq8bcq8uyD5zmPH/SFJWdl
 QpGTmV7y
 e6p2k+urjxObrJxUTpjwEUc8N4mMTY3HcERShI9L59DPjdWoOguUQHZBO8sb/YCt1xiE5N/mPDmxRHB7LLqqCaMbWx+KqzlgqYdcJzliVEqSHJNAH3t+/yLymzYiH3L7DQoblSD9yFK3jMQQoM2sh1KdOT/D+Wi3/7a7rkYP7LfufAt3pcOiLq2ol1ot5/FPzL9yc3gczPNiHCoi5a6KnyoEyKd/UC46p10utC/Q1cSFHaEIm0FssGlpBVP5IZZFjfRhytjSZ88oIDLArjuxE+Se1xNrWzFQhUqGWT61M//TeNFNFhoHyhk2FFrg7xwF3hmWCgxhrxNplcus=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 09:25:20AM -0700, Matthew Brost wrote:
> I think this choice makes sense: it allows embedding the wait state from
> the initial notifier call into the pass structure. Patch [6] shows this
> by attaching the issued TLB invalidation fences to the pass. Since a
> single notifier may be invoked multiple times with different ranges but
> the same seqno,

That should be explained, but also seems to be a bit of a different
issue..

If the design is really to only have two passes and this linked list
is about retaining state then there should not be so much freedom to
have more passes.

Jason

