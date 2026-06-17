Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E48FECD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83E96B0005; Wed, 17 Jun 2026 10:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5ACC6B0088; Wed, 17 Jun 2026 10:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49DB6B008C; Wed, 17 Jun 2026 10:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7E06B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:16:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07F75C1F2A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:16:02 +0000 (UTC)
X-FDA: 84889603764.11.48AA40F
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1B34B18000F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:15:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lAGxkgZ9;
	spf=pass (imf06.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781705760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kLH2EYfcnmjV4+OcjUuMrn5lYsdA4BHEscTR5GyJ3aM=;
	b=FCU+9YMmpibVWXd7jmllBIIsbH3ISvYODPUZHM6samA4OGtkXDD0edY9Iy9aDPKsVprunM
	q8TlRgO8Ayg5alh9nti4y5t2mWS4UKH6cpPxPKjERcRkOT03AscybBSXKCS11cwXmX3JuI
	dgGtGOnaXj/d+1BLhnLJPfMUzwMb4AA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lAGxkgZ9;
	spf=pass (imf06.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781705760;
	b=IEcTu68iB9TOUIOlRUNszcAwLUIcxeqykK/s/SOOQ86jf1knz9B3T1midVW1L0z9JEsG5+
	yM9rYZj4epsi7izv/4CcXsqCdOcFS014qoRiKo2YtKgYevWLvcY2sqXEEmn66bt309zW5G
	x7oLPeJO8JqKxpyrGcMYVZUp+POgIrw=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-8423f241792so164703b3a.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781705759; x=1782310559; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kLH2EYfcnmjV4+OcjUuMrn5lYsdA4BHEscTR5GyJ3aM=;
        b=lAGxkgZ9B1BvojiWh9pLHFxVhSB+9egMjpdFrd9jJA2k8NPTt5P3+zjZpjylBVl3i8
         /IqD7sFVG7V26nnXKF5+fH/zFiJA7/7yqFEosu5oq/ldZpc/dDojLIlfkhnxeAsSzW45
         ynQfYmHFa/WJmCGXuiw9uvZtAz1+aivO+dC670D65MrWHTLqgKPO8rKwxX6B1be5hWy1
         KoJ04H3uesbMdhFK52LTYl/YMi0Hs35RWAKYVWGS32zLH4BGFDKIRcvZEoSBRTpPrQP7
         hhG9N0DEEY+/lYHxBY8UbCJN2LgQQTFduBlh6puXTRnom2n4rigOm0RhLZEXi5qB8JQ4
         st4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781705759; x=1782310559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kLH2EYfcnmjV4+OcjUuMrn5lYsdA4BHEscTR5GyJ3aM=;
        b=c+1ETApd1q1I3nM9MViLa5/clOnnOafuEwWc5mRXMXq74GrxRBZv+4wFsDo5u7qwsm
         5J8gaOJKRId2R0mDvYXuKMUf89vk/RS+J72pEQNMS//W2kqGZe7O56bQojRvl0zAI6A2
         /iTJvTEEc9iKFlJfWQwrh2sA57M+jDRdxHPjy8mPTtwGudQTnnQ68hHLf8n+Fq6CkLkz
         9sj6PIniCCMNYEE99sdehnpixlg2wxdNnUiKDu9ZPfFo3HjStiy/9fFwjPr0uSnNlRd1
         HsLOR8/7x6g6xKrpjlAyDpHilZENpZGRU1br4hAr4zq/ytcC+Ttn5DbrVIGQxFizK/Y1
         hmKQ==
X-Forwarded-Encrypted: i=1; AFNElJ8+/+5WhVzQRddIJ27hW1NM11sbno9uIMtJkbKtLKvkkXssjidl5+NlP2LncAWYIMJ+r6jtHjeLsA==@kvack.org
X-Gm-Message-State: AOJu0Yx/f/qF5Ao7nMYuOr9cWdVG25fHz3EXiQ+sQnWadP4MF/2k4lUF
	Q9mhaZtozZoIinXod6aJxiZEEP4+eo3kTJ8ekmMa/GR5B4l0nXBSQx8OyAUDicykZufgww==
X-Gm-Gg: AfdE7clTswlou2zEeno4oXHMbYKY241q0IpA1Kt1AzgqH3tihOSSbsCnmkT/Absm58j
	2QpIbCaVFcRmeGIFP2XSPuf38aJ/WDdcnFcHc6w1uiUf2ELjU0sRj7wYMhLAN9roHv5gU1xMQVh
	2aO2V53vjHnhw4n3NFRR8J1NpgiB2ltZh/3RFYmhC/iDLwVxEJV1m53O2dHMZqP7N0P4BU5Rofm
	gDjccbqX6VvQERpq11kxHu8RvZzqIgoBHeAnbPjRPXjVl6zVHXyUYAmcyXHRfLlm+56zY4+NC+Z
	ocDhB6yVT5DcR45EL/HNJTKawV4/Bl8VFrYaaVkvMITr01idbDTR5NMfA0PU9Yi3n1cFCgvU/if
	vDLbaC4mpEOPcPAg2VovvfvXPAbVGFsgFY39/3QukOe4TaVt1ftQQf4CcOEvmXJFUwiBh2ndcXC
	/QiDj1uk2w3lGn/lyrXmajzahU5lOuwQUs7ifj9wD3riaJSAw7u7tcRlUBppJNcf6Sn20HpFVTO
	8U=
X-Received: by 2002:a05:6a00:3e1b:b0:842:2280:5392 with SMTP id d2e1a72fcca58-845247c66aamr2077327b3a.7.1781705758882;
        Wed, 17 Jun 2026 07:15:58 -0700 (PDT)
Received: from fedora ([188.253.112.231])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b040718sm16905766b3a.51.2026.06.17.07.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 07:15:58 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: david@kernel.org
Cc: dave.hansen@intel.com,
	xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	hpa@zytor.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero folio read-only
Date: Wed, 17 Jun 2026 22:15:47 +0800
Message-ID: <20260617141547.144275-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <3b20ad2e-bb69-44be-bad3-5efeb169c573@kernel.org>
References: <3b20ad2e-bb69-44be-bad3-5efeb169c573@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B34B18000F
X-Stat-Signature: yyjhc5thzwzpdh3pyberast7nnzu4cfa
X-Rspam-User: 
X-HE-Tag: 1781705759-236324
X-HE-Meta: U2FsdGVkX1+wdgsELko/rpBOCvl11R8qjCi4Lac8ImexZtF8Y9qFHqwIqo4A6x8INCCNMUX7JHExOTxwowiDNaIh3SMsLWT/H609BGtx3mM+bbuWvufWHntDcdGpaotsDjb3iPaLb01D27GG7aeenB+7oI33JeSl6xgtAXrKNM5thuzhRO4+zthQwJnUKPcKW/XCx7WG10oxF5iFrdxdtB9XnaAmqsYSq0hrlJJC3HAiXyk/NPcrgIm0gs1KaPvtvRoAq/dj9zgK7FYY+paNwA+1xlx0PY4UXtQN2MNu/NZVdCBxDtu1/OQOR2lmn8P3qH2FYH0RQUs2eIpkalaS8g48xomnAr350JW/EaAFhJx7IHhYj3RUblqsncUjKxP+1NG++VlXj/fisvhQgTZFEiVrNGlubLMVHcl44Z7bnRVmlF+F0SqVX4DExI6aNguYJWzbR6GCiw7K8nmm/a5IWS+KluQhA8yKgC9E01euErJQ3lnXieStj3JSMx6XNDhSjXTBhn3CxKWmjZsvfV3lfXhNSsCN3cUpf3V1o1Zx1JGilRERKfs/xYXRHmY0EMAunxRSFNPnOmXWImRd+dZ+JS2K0wEugxm1D0Ar9OgXIN83G0Kv5URDv1jHJb+BVfaFtxFVyUfgz8bC/7oB0w/zfAFiz7oyhp+3RQbGnsuMlEJ6pjCheW3nkvbgKba8IiwE/YE3jj9sjawIanwlS+WVpZdM3wQP2cqELM+7bCAyoQEmHsUvHYjcFqsSr+A/NnUyTEOTQ62LQymX2GmHX9qvg7sVxcdBD3gshf9BnI/RLmxBEyr+Nmf6aKvdObZ3+CohVUQ548CLzoFYb3nSW+QRGFCmHNXzq019ga8LcsqPn/i6sfOCajNP2R6VaTEUyXvyGLGDrFPfUJ2TRSDhkw47HRT4T9q9z78EFIfm43+5Ja0af56GmAYs4WOrCYFJhDlwcIh2d8U8L3HDjDp0tNv
 Pu7yT/MN
 7i6PmWZJ+lG/qG4I3gwgFdIK0sWb4lHP+fDkMJ78irD/wMbXaaSY8Fz/yX5RNIgLr62+BLOH9YkYHWQyEqUC2AHC239Zv2asmTgDPbUoQI+9P4KZvXenB0COVgZ+bLu3wh6nMkl+dWEawVkY4fwO1gHCV/a4mA4Xfau/0DvcahiXfwL12AUO/2bHaHiZmAzNgPBYRDdSc2/UQ70omvU2ZQrJFuwiCy2SteqTPKDueVHaBBM0Lp/hX9R2bYH1ghZgvdC17rJVEOrxtI7KmdwVqTI6phZbr6zptCFRXwE9LPxhA1ONWh8M46tl8cgIYmf0Q0BmpEyBCZbhwcMUDBI6KnYcqQCkfE2Bm0AnAJZ2BI82l0VFKTHIePsdqp2RiD7kWtNnCNg8BKgKkW04Mrp5Alt87rpHvuWSzG+82SuzznOBoBLWQ8BThpHgB0LcqZJhp1BuiUzDal+x8v+Lq6GtYvteGwRVhVaF14suKlndpImdTYvxJ7vIGkqECswCWg2kgr7vGB/vhJGF9ZlkEWuF0pxSnAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jun 17, 2026 at 01:50:08PM +0200, David Hildenbrand (Arm) wrote:

Hi, David

>Yes, kerneldoc please.

Ack.

>
>We're adjusting the directmap, remapping a r/w page to be r/o. I think we should
>be very clear about which transition we expect+support.
>
>Also, I rather hate the "set_memory" naming scheme ... "set_direct_map" is
>clearer. Anyhow ...
>
>Now we are throwing a "arch_make_pages_*" into the mix.
>
>Should it really contain the "arch"?
>Should it really contain the "make" ?
>
>Why can't we just reuse set_memory_ro and pass address+nr_pages? (highmem check?
>Could that be moved in there?)
>
>Or do we want a "change_direct_map_ro()" / "remap_direct_map_ro" interface?
>
>

How about naming it int set_direct_map_ro(struct page *page, unsigned nr)?

>> 4. Should this new API be folio or page-based in the first place?
>> 5. Is mm/huge_memory.c the right place to define a generic mm function,
>>    even a stub?
>
>+1

Ack, will move it out in RFC v3.

Thanks, Xueyuan

