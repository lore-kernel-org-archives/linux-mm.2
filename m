Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9240CFC512
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 23:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44DCC6B0024; Fri, 21 Nov 2025 18:20:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 425506B0026; Fri, 21 Nov 2025 18:20:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B446B0029; Fri, 21 Nov 2025 18:20:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22D026B0024
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:20:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9C0FC0780
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:20:50 +0000 (UTC)
X-FDA: 84136186260.30.EDB97B8
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id DA7DC1A0005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:20:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XwFRos2a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763767248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tq9xbCdYMfzLFCvaBRsqdkWrBL/TNh6NYntuvvoNmzQ=;
	b=jqy13s/83edgZEx8+VamU0NhP5ieUIkDRQxnRt9YgdAqje4D2cjrQoaRIRWLM1W+eD/uAE
	GyzbOA17KFuf7vqHnzcCY78iY+TiYuFj7cKBg4LO6YT/N112YP6iGDv5C6X/aDB4UO62OK
	lk83Fvl+vscINQDgMxssEsn8SnWNU6A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763767248; a=rsa-sha256;
	cv=none;
	b=WIiZLvYD8Q/VmJaYMDGLDayxUKNwRFGROlgWE79+5QybAEJe80PYVuUYBNfWgIHOAyTDOU
	mZ4hkj9vSCFuepZV9uFkJwdvvQmYM844gI27S3fIlKcSFG7pwPifQyrRjbdPQX9sCsUhGd
	10fDPlseImoJ2QLkB3R8mWZU2zJJ3Vo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XwFRos2a;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-642fcb38f35so1624186d50.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763767248; x=1764372048; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tq9xbCdYMfzLFCvaBRsqdkWrBL/TNh6NYntuvvoNmzQ=;
        b=XwFRos2ahbElMMc6FwiXIR+seTw8hoOWOQLnLHDZKs+0noXAGPg7Sp72U2ejvEplu9
         aO7dYFUnCHmZuCd0orhfAZWd9SYbk6xGDSnyFHV+iGSJz/Rhhkdh49XBHQIBpq1fLNVc
         pmY8uH5T5LumXtSzccPXFIsQlO8bzuHvLwj0dsb4C7JceIuZ/UHQsE1CvHnKRNNN0seD
         hF/hxEFXtuA4102XccT5AqJIBtqn7fFFtO3f7E8GGNrp4sX8qgQZY4Nx17JKQAMzb7JX
         cxAcU0/00horDntJZF1/hzvG09zNAeFK1Go1qe7doLFqlqUmFh+nfhlsRknsKZhmHnG5
         RaDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763767248; x=1764372048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Tq9xbCdYMfzLFCvaBRsqdkWrBL/TNh6NYntuvvoNmzQ=;
        b=IQ3HoG7ci31LRTd0eHr7EUjJa/uGXbX4OJOArj0V5STd/aPhsudsrplkexlj9BoxAV
         IpG1i9aXHX7XrSkm4MYTW7A/ZiRZ8ZZYpn4+iovcSM3MS8dpx9kxWrnanlbpBXbauHSe
         cdO9tkohgRK0k+KHMuCymGt7BmpwpCz1VQ3kghVVmrUMp2cpj8cbeDseQsshDuRhYcdt
         +aaiVGXC2qcktYLJsZYm/eQvFbyRDGayladhPMzKxlSTrpZ5JOZZC0NWjy9nM9mGZqbW
         NalyQUR3RhVJPUeDVp8/onVujnD6X8fe9EguJ5rJ1yYp5ZlxdjODRUbJ0Gjvv69Hv9te
         eLbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPQzWYmRE9AaI+v4KdJXWcJuxAJ7b2u4jxsBJTx+dU9gFfHu4c31xA6feSHTAY1YhTulQg74/AxA==@kvack.org
X-Gm-Message-State: AOJu0YwtBrowOluHWbHn+QHYjHksNfilY9bMraKEbz24OxxYsIkBNTtp
	MevE0xP4OTvsMOBMAkL3pe7tTPnCHseeQXoYbCSJxXUqi0Kwnk76mxqfF11oVQ==
X-Gm-Gg: ASbGncsXHfhYJ0BDaiSHFiM9jeoaXgfxJghR2YgU6D0tnAheoviR77ui9xpFMqcHFOS
	HsF9r5G6DOfrn6HzzZc7bb9DtjiKVEbRV3s5xsgd90dI7ir1XgSOxOVZfXdnDJfLm3jc+OxuoJm
	pdhAVMJ08SDhLqqFgeaH+t+dOx0iv+jlBpa703S+0c9/FLo0Fxw4iy3HDDoaFT2EABbn+XBeTL3
	MjH1/BwU00hopGkowaltGkjubcah7wsTmw4PO6XhSS7oYpPMRsvwM2ZNBA3xyJTPNh5uVDCzSgM
	NbS2SklOjvpaC8IHH46TKbjVr4QEzuQPXvXflsdl/HI/4zC+RzgXNJmFH49yOmBw2ZzkTEhF3ai
	VGPrbyk6B0AYZsbzK8gzwOa71K2lshHt7mxp+hy4+neUPraBh5+RGc1Gjkd/JX3uN0z1BkpCy/l
	plqNCltLo6OgtY9RHINH8myQ==
X-Google-Smtp-Source: AGHT+IGyQP2VuMLSm+xaWSncG05tLOmwZ8qWKD5y5GuAXu9VCvpBCmfrlIYgSqlrR6tDWPPh8hcH9w==
X-Received: by 2002:a53:cc85:0:b0:63f:beb2:951b with SMTP id 956f58d0204a3-64302ab4ec9mr1841480d50.42.1763767247782;
        Fri, 21 Nov 2025 15:20:47 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:4c::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-642f7178824sm2123443d50.15.2025.11.21.15.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 15:20:47 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Kees Cook <kees@kernel.org>
Subject: Re: [PATCH] mm/mm_init: Pull CONFIG_DEBUG_CHECK_PAGES out of CONFIG_DEBUG_VM
Date: Fri, 21 Nov 2025 15:20:43 -0800
Message-ID: <20251121232044.3120695-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <b1ae4706-b56b-432f-bde6-7d76e9b02598@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kjmtixjyghsue7fawayis8xnnr66cbcc
X-Rspam-User: 
X-Rspamd-Queue-Id: DA7DC1A0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763767248-991526
X-HE-Meta: U2FsdGVkX1+tJLgLA+xGxAMGJCnZF7vy/CNHX/b5ksLv3yKBdmGUVZDvAVcixswCfd/ufMXhSGJKUwZHF8UWBefoqMKq481LjU+sQ/roAs78v0FlwX5CZU8lrfi7/h9da/GF+fVEqc/c8B6LjztcYfmKU5tSzdkp3VfPMxWvf7oq1qx0c9A7F85csh0A1GNysIXVliAQeaouQmGjiFXX6F3eYxHPJl3hJG6+FBPi+CS9OAUQ5fyxXRMSCxpgb2MmCUXMf199E4LuyiiaOLuB2lQrqzRVPe/GQxWw9kfGeO16/Trmtl9u6tzJZENRaDCx6dyx0nX0iyvp4xn4W2CzBWi2b5Vo2jQfZOIxEbHyAH1x8Rj8impxrdTbccnRSj7CIGaCY0bB69alGyAreOM0fAZZXOtsRH4A6oxvatjhhWm5ddZ5bIk2/lH+LDfK7okCIi3EKPZfgzED1WsyspQqVoNMmIzxmdO1OnKn7W/hqFs79Elh4Is+Vy6X3XtMOfqvPRx5BnBXrwDE8LRAekJ4ExjJiixPoQbJVbi9qvhG9LhTkUCiqsWlTS3WrNOaJn8ASp2DVkkuXpOTtPl8bgGmrhBIuc6YnYtPrqbkW56l0F3Tl7dHuU1Hj0I4tvDMFKDHnZ+Cqn5WlwF83VEgfy9pj5gL6vCKK8zPHDHbf9OdwgnuhWCKlSa/LtkWtVm6PmdwxWuc7rt6ADsY5Xaf3F58JgolwbJuGC3bRngj6i5ib1GwoCklzsbN8egROyRPPMLuEsMAf5WJHkM0ixl3AdeA5YURAN/OBrRWob9sgrmnpLyYZAwC9f5NwuR82DvOGFnT43HTKeTDvGXWcNeRmzV5bHo+hZRMZV2W04O5dXr8Eahu75iTs2IDkx0qIwfc8p0dONCpj+TGCH3jm13FBpJU19Pc1hbWi1cr/46NJg6X5/0g44mNLNZygXf+6b/WOrn6k741C/YpKzsQ/nP/6hE
 GzX4Cgak
 FIzDnCwKK1mHSQ4PoFQkVwYXQUonBHmLCeqU7vlvaRpc3i5rgYQjD/EthXP9hHz1yuIZPUys+RaZYgzgj0/Je3gvxV9+CBY8Pey3cX3let9ZquydG/s+IAv8BqJrmadwxJUZ/xTwQvbx6i0udltJs6btfxKqrq4mzncvujPs5rT1Ttbm32Xt482uxA+zmmYAudokp53hNjjNYt12BBjXL6wNH33g2AU6ik1LEWNyBzgl2ZidSPxhW3ynurkOJpbe/DxIfur0rzj5p+Xq86kOFT4Achtj3mXHXaQYoapDKX6z8rrNOwzd49CznNH1yHCKGVgdRU3kTFu5ZYhWYiJKVTFe1OKKclV8HUYb1ZVdZG0nPzOdsESNT7m6GF0i55SwPplUhKcfFNYeX36pCjSWUlKvRtYvXGgCJyEZDkW8WpHCRJF24CvHqSofU4dgPs6f3il/gUTbmHKiXYQr8Al9Z95WCl7GEUY4aKY+6YPsXNI3E5IXBAp+SWNnibFkZ8Z0IRo5TCOpqdF/pt0J3IsIUKqw08B1a4yF3JtTcUM0F8L59LpPONzJIsZcUHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 23:03:01 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 11/21/25 21:44, Joshua Hahn wrote:
> > Use-after-free and double-free bugs can be very difficult to track down.
> > The kernel is good at tracking these and preventing bad pages from being
> > used/created through simple checks gated behind "check_pages_enabled".
> > 
> > Currently, the only ways to enable this flag is by building with
> > CONFIG_DEBUG_VM, or as a side effect of other checks such as
> > init_on_{alloc, free}, page_poisoning, or debug_pagealloc among others.
> > These solutions are powerful, but may often be too coarse in balancing
> > the performance vs. safety that a user may want, particularly in
> > latency-sensitie production environments.
> 
> OK. Would a boot parameter work for you instead? It's more flexible than a
> config option. Then we could perhaps also decouple it from
> init_on_alloc/init_on_free as it's a bit odd side-effect for those anyway.

Hi Vlastimil, thanks for the quick review!

Yes, I think a boot parameter would also work perfectly fine. There's nothing
in particular about making it a build config that I think is necessary here.
So happy to make it a boot parameter, and also decouple it like you suggested!

I'll spin up something and submit a v2. Thanks again for your review!
Joshua

