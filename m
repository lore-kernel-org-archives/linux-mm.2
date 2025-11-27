Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51026CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892D36B000D; Thu, 27 Nov 2025 05:05:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A8A6B0023; Thu, 27 Nov 2025 05:05:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7802A6B0024; Thu, 27 Nov 2025 05:05:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 67B0B6B000D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:05:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B83E1A0985
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:05:30 +0000 (UTC)
X-FDA: 84155954820.02.184E754
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id 264C11C001D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:05:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wu5ea96P;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764237928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZgSdDqX071DIvawW7UIpDWp4rfSyH6l1bXthLT7X5s=;
	b=luSs1uN5WU+50+VztjIqUZkozD/+g+9U0tsqaABP4rpleD6HSsT2+0XnamnOfbiB6IdaKB
	xw88/+fmT1Rw8ttFR4VXKoTSU83WGIQL6Eq+41yhMcjtkTleUqWxendACBZY/oVZiFrF4P
	QxXRtt4DnmJkX3yveZFpM4TKEgRzEV0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wu5ea96P;
	spf=pass (imf18.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764237928; a=rsa-sha256;
	cv=none;
	b=5GQTVqG855/SS79S1HcFkCsyF5yOLNVx+sHFe6bLltAf/EKhtLCZfGNINLpPJiV0k+xlJG
	dP4E7odECdJezQx2Yxd0uQTZTzpr/TgDQGREzn5aUwALnsRk9CsjnsBMTcfnxHdIWR37RY
	Gq3u0BPO810paDPX5+W67MommNWaEpc=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477770019e4so4711845e9.3
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764237926; x=1764842726; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZgSdDqX071DIvawW7UIpDWp4rfSyH6l1bXthLT7X5s=;
        b=Wu5ea96PYvxlEf/tC7zLV2HGjwvwI69bsPik6P6jLXpN1IPgoqaFE+Iy+byBhoLZp9
         dso01+9LL5y1JxMbYHCCr1meo4fMwwj/o4ULEIC/SEaMYv7yjOgLcxrcD+RJADWPBoOv
         0ZOl7fZJorEXYK+LIMz+2PusZSZniMY/K6N6jr86tUSzC2IpZhYnuS+pQAcl1yACJh37
         Nzr6xVk/Ua7aQ9hN27SJpyRBK5adVc4N34G4S1/RnXMFZaWbicDECyPiPhm20wvCJKYZ
         Es0Ro5G6dS/Vlp3AeozvVl4qUVbGgOKcxfyFSJTtlvjN0f28DjSuf3TuvVVZiVKb+eze
         SGXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764237926; x=1764842726;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YZgSdDqX071DIvawW7UIpDWp4rfSyH6l1bXthLT7X5s=;
        b=gsmk/G2Rld6bQjqim5dvpswElTvnctF2qqXtyhkqdqc2A/8KBtlvgtrtp2jFoBzgtH
         Q1LSeDdhqu9LIfzruM9j45rsIg0fatLBSsYvcOGkXrfN+FI0O6uF5p6YMJsQhgaw3J/n
         8GDoZipYe3NfTJ+KMuZ6eMlj91SzqIQUI6V1qYXhCGnEc8QcwWQf5SKdhiExhjTmKuvS
         Ju2ohcSRuqrUbl4xOcQlTIt0mrRNtkUYxEu9VYDM9Hb1zQ6b+7YfP/54lvGZxXjSjtV4
         xKnWi6K9xdm/Pv7ezhG0yYziDYF9rS0p04piSFqgSbE5et7aYwEoRsGuJnrHvTnIiHIm
         bP+w==
X-Forwarded-Encrypted: i=1; AJvYcCVBFUuIceGzv+1W0P/1UDeV5lRIk+gBt3DfLYa3JxJuBfT88waeVzwca/5Fvl+ja7yb0f/OsqZ6EQ==@kvack.org
X-Gm-Message-State: AOJu0YyMg/egtpG5RrTovLGWd7Ekn4LJhYHqD5iBGKaZ9YRjFazW5/tV
	pCl97e9ehM5XfSJbBdrUL3G3R0Qv0u5HVhfcJLfPfVJRrlWNi/k4Dggk
X-Gm-Gg: ASbGncuFYLuu5HgygkY3xqBvkMTY9SiA7ZrqfqX+D6d6SsdNPPdLcUcvZ9BmDQldKk3
	tY8LN3bVYX5Pom0Zcb90Up5NoqmK5nqZoSpD8/3yizTAAZ8q8W9ZSXU2Ujfwt63tSoWiscH6bqu
	ca2t4HBIRwmN950QmCs8RffAMUAdYEm1wu8oRmzgrMLOjX/lNi0QQyvt5aSzVro+YJH/eSVTQLb
	aXGc0KLs6N/6O+JBn5EhLVzBquOWADJe+CPFaPsdQAEUCSqXPTvEbfWwdDcOtCWwSX3b6d9V2kj
	D/u4EuclguGIWmYxBTcgVZn+cVkQjDsx/E0/Xb0pVfoAheRfif1pQKTi9X5mds7+G7CDuy/aZbP
	IxH5Xvfu9d7HxlZJdNydrtTRpqYfGytoQATNLya9G6UMu5ejH+GQnhmkd9W1qN1mu/uH+jkHU3M
	AKikHoJPUi65eSSTFp7TmACyHRpqOl2dx9mCGJEbzpjyrhu8391r3bL2qfvWWk9Vg=
X-Google-Smtp-Source: AGHT+IFY1jgwUDgPqtcZLYuxy0Lcq2WWkQyCPLjZ3gLgZDSUq9NcRpum4zTpdYkH75hax8j7XjTKfg==
X-Received: by 2002:a05:600c:1c24:b0:477:aed0:f40a with SMTP id 5b1f17b1804b1-47904b1af90mr119607205e9.19.1764237926224;
        Thu, 27 Nov 2025 02:05:26 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caae37esm2522835f8f.40.2025.11.27.02.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 02:05:25 -0800 (PST)
Date: Thu, 27 Nov 2025 10:05:23 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Sahil Chandna <chandna.sahil@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 mhocko@suse.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 hannes@cmpxchg.org, shakeel.butt@linux.dev, zhengqi.arch@bytedance.com,
 Liam.Howlett@oracle.com, weixugc@google.com, axelrasmussen@google.com,
 yuanchu@google.com, yosry.ahmed@linux.dev, nphamcs@gmail.com,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 david@kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 1/3] mm: pagewalk: simplify hugepage boundary
 calculation using min()
Message-ID: <20251127100523.6c6f79c6@pumpkin>
In-Reply-To: <1e01c12f7666ade41f5f34ada24ad3de1087454f.1764177933.git.chandna.sahil@gmail.com>
References: <cover.1764177933.git.chandna.sahil@gmail.com>
	<1e01c12f7666ade41f5f34ada24ad3de1087454f.1764177933.git.chandna.sahil@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 264C11C001D
X-Rspamd-Server: rspam02
X-Stat-Signature: qhstrekisnhf84qqfjnei3yba6ix9iup
X-Rspam-User: 
X-HE-Tag: 1764237927-920575
X-HE-Meta: U2FsdGVkX1/eufT+q/5wHXFDIXw4B7FUHixEIZ4h1oix3W2MwOm7qSgpB1P9H/FVKtaT62VfGlprDi7dWVaLeuLZbE4ioRIktr+aBpmq+ko0RjBS/aWSc8uFclIgtp0WWPKDooC4CKG7JEZ/MrdT8k+jlrr45ktPaRUILcM3TyhknasY3eYymWU+zh7Jxu1ZQo0oNplMqfiopIlY2ZYFH5GFWsgZ9+Fo+dumgcxaTVHxMd5HCeeWFY86dTGeZUO8ont+slLxPabPhExmmkgfl+pEOR5PYLNOzXHjwVLevmFFV4hILFI6bM9Qo13rRGhj0QRZ9X/abX7pMGh8IEjzgF5BE3Bdg4gHwAD/HG4jwt9wKUjRAg/KkP04AWTZ5aPnxjukita9ER531iboOMS1A/J4QA0ZnCgxGww8AICh7yL6Ho8PaLrCpnBLLPPgVfDjMQKHGJbnkMJ5GEazn20eL39wPOS5+Pt57GmXYh62h4JN2GILmGSZCeSPFT32D+bPtsdJdgW/pm7prBojx6jXkhyereTZv8BDqDePtwHFdIM+Wl+f7hAv2EPUH1o4DvDYkTNShUGNFVawZjnLLgIB8SRxw5J7aSMGrss5AoPRjmLD/EFQ9Vv+IPDqUvPOBbO+2UxIU9KnPQol3arAFbdzEoResEgyJG1+G3GJXbQiny2kpYTzKTztbL1vY+gKbvtk4DaDkhIWsQOSHaGZOKNFC3R0DM2PP6wGb8RoCh3IY38YlwiUAAfP6sxDBmGp0DAWrU21r5I77K05Ixz55A+B3mIxD+yCH2fCj63Y0IHrllvWnesJ+7ebO/QFisLOnPPme4/+gBC+L87rBumx+Rzw1r4hwieNznNRh8GPBiGATsBRdRRpuR5dlG/V4dSwQPX4WB6fKo1W+bNeJWH7o4wS0b66UyrtWWt2i7ofOc9kaQ/xIkJ4li/dWpnvcRFbbQFsutHrqLE09QWWdy+byKg
 6sM8a3M2
 BmEWUbo2WU5VjPXUGmrVaAJxoONNaovtdsGoit/fwpE9hBGdSlkjBaSRcBwTZQcHwK1a7AJ7h50TwLRxjbP5OOtOdXTlITZ5/o2pLRocnuj0wAK9UVB52IeRb5LMsR+qWGSH6r15zhIyKIE2TdSz2/9aGHnXwfmaIoqX8sb0z8MrxCQ5zfGR7YXolfMBrpEXlvkT02kixXgZCJmV+jKR8eOtmUwqZX9TKIeDGfYdHkatv2NipZ91QicMXJlFOZ0q35/FRblXEwN9pbhWCfYEdSEAXycbYKM5mZxQLA902LSawevlGWXGu03jLRr62M82/Lv1Org2z9Y8uBsZvYIwlMmTMK5C3OBNLG8Uvgf9dygODQatcIwp/fJQTd0D+aLDllSM6UAkRxSRACb3+7QoeFgagryVC5yYE1gd8Q+Ais/ygr9/3NvcVA1Rry1SrOTPxV0PBUH8gYUwauPoofYPeTIjvDOSHINvhuXqrqcYTJ+fehLHZXH/CxKTsQ5bcyzqwie5QhqtB0ALNZYP9/L9V0hrZ0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Nov 2025 10:41:28 +0530
Sahil Chandna <chandna.sahil@gmail.com> wrote:

> Use the min() macro to compute the minimum value instead of an explicit 
> ternary expression. This improves readability and matches common kernel 
> style. Also change the return hugepage boundary expression for better
> clarity.
> 
>...
>  {
> -	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
> -	return boundary < end ? boundary : end;
> +	return min(ALIGN(addr, huge_page_size(h)), end);
>  }
>  
>  static int walk_hugetlb_range(unsigned long addr, unsigned long end,

The commit message doesn't really match the patch.
The biggest part is not open-coding the equivalent of ALIGN(), not using min().

	David
 

