Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FF5ED0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 18:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDFEB6B008A; Tue, 25 Nov 2025 13:58:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB7A06B0092; Tue, 25 Nov 2025 13:58:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6C86B009B; Tue, 25 Nov 2025 13:58:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 960F06B008A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:58:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 669E288F04
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:58:36 +0000 (UTC)
X-FDA: 84150040632.11.88528C4
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 826F340014
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 18:58:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NHiEiRYq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764097114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+zeOdZZaF4BJyqy5kMaeSWqNQvCyQPG+omQ/g0Gj7k=;
	b=PuG6uYc037cubZrujtMNxT4NCUQElv8q8jhxKayvfUvMZDXCL+QAqf2ni3sFTo9nonE19Q
	CE+YQMSyagYZaUter6hBzEq+DBEoH6OfiXAUJD1soj0E75YBWfjTHrjY+yltSw3hBqci/K
	sT20oV4IO0Ioci062DjaoaMRGVDpGto=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NHiEiRYq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764097114; a=rsa-sha256;
	cv=none;
	b=ZIUyxo7aF4Wnt0fb8phuw358n+u4nrjPwvfuEEjtwdvsrH/EIO6uFItUjqfm0rsMsNV80Z
	VeuitWfIoygsOoBHPg6csxP8VhPPlyyqckZ4D9WPkiUmYNcrgbpO+uoJz82qQ2SMi9KAcq
	W8orD6gEuGLtjgETYuOGPjYCnfypnec=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-787df0d729dso58687047b3.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764097113; x=1764701913; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1+zeOdZZaF4BJyqy5kMaeSWqNQvCyQPG+omQ/g0Gj7k=;
        b=NHiEiRYqTrFt3lDztOhHteg5tIkrTmDKSNzAkIvHbA0YWWYXC+ezZXPAefA1agBGyj
         qZ+xLjIr7xYXH12VgjzqJs7IawfDssT2aEM7vTMGMox50nftOcSGBPMvo3qaF5dYHTGw
         9qWrLlLSkk/XmNPsA5X8Zx86hy40MY+5ktEKW4VvHb2YLbmVwdyMzgkWcY4XOho+ZLM9
         mVM5tPJMRmZlFgooYQIupLd4VanntEPEQiiNipjpQm1dppfqNZyDrqUQer8cjttA09DD
         vuCPVvW08a2MLTktspOrXEmF5GnzBRe9KiwJp7pGBpHTlzMHh+NnbQ9okOa/7xLpeKFl
         mdRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764097113; x=1764701913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1+zeOdZZaF4BJyqy5kMaeSWqNQvCyQPG+omQ/g0Gj7k=;
        b=V3T0Fp7ZOqjqdTXt8C6MEBowf0DLRQLudse/3GeutKQazzn4FbuidMelnEONIYeOih
         sT9PnMA5FzTrMT+cMY/P1TmQ4v4VK/EiP/MHWROjjmdurs2e+WdvpGyB1wtfnUSlf2SC
         HtA82m9vVHe+zE18NA4O/K7HeZUtpC+BkWvRPsEJF00Rauq4KrAwwXd0GxDupq4x0h8c
         ClHVYVOeqxvVUpeS4QDvRQUViGPMKZK8X5E+RrhEscvPcsp1T+mJHFXNdxLWkHrBgxP5
         VPehuhcSUYI+43uFXQRU3Z6YP23lgVZuE12JXRJNVtC4HrSva7say2lAPwkLAEQYEH6D
         oh7w==
X-Forwarded-Encrypted: i=1; AJvYcCXceKkHXMZFzHY/3Ww+HnVRgADVfRSqQUBAoAmhM1/tBGPrEe9dWIVFHkpga5buUFpY8JDW3wG9aQ==@kvack.org
X-Gm-Message-State: AOJu0YwElAe/VgrDX8TR0UPYHHSVILvzdMF5Punhg89OAiiGpDVg5T8X
	DvP3XkQBTagrGYMY6scDj8vG/cPOcgaDgq0OPWr9X+QgFdjALY4m9rzo
X-Gm-Gg: ASbGncs9KaChdUjU/w3egFxwwEdq7PSxnu+U3erEGrFn2vFvb+DX5dIk6EvT7KYKVwd
	Lbq57dtj8IxTVlWkCXBWmqpefP97GJX7tpXRJhb4/MNFjGQJ7hDqm5zLe6PzkBVgAARReCArSB3
	pJua/BjYpzI2ogKxWw/sNstbILyZV2DSquc2k5gum6pAhHlOUEwa16f+zwegFn44dEthHL6iI86
	fXW5FizTHQjTvILZFRuLnK2S+iNxdUjvlvkRrm+/3x08LmMGatWrXaBdUeqZfteQdjWH7P9hu+i
	JmlLh7D1IbGqY3UwdAGrU8VjJKph4/MvljgfuyO8y7E9QDcm5mbnwCV62kHXp7G1PRKvNKIaCV/
	+ETjG7cqWQfrHdw5QYSZwWgO4aTfrhdV1eYUmZ2pg6mf/oS42/PhZ9LyMXN4FngH0/3HNb2X0Pq
	9+fQE3z4Q=
X-Google-Smtp-Source: AGHT+IEd3fC2WDscBWmJaJ6t/VrtBvr4q279/8luMzo4kTWQtijZrJPqNt4WkAAB0deXmKVtpnwI3g==
X-Received: by 2002:a05:690c:45c4:b0:788:17d2:be64 with SMTP id 00721157ae682-78a8b491d25mr140972287b3.26.1764097113523;
        Tue, 25 Nov 2025 10:58:33 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:72::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a9a39101fsm35977827b3.43.2025.11.25.10.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 10:58:33 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.com>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	"linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/mm_init: decouple page checking and init_on_{alloc, free}
Date: Tue, 25 Nov 2025 10:58:18 -0800
Message-ID: <20251125185818.1586946-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <5d0c582f-7e1a-4623-90d9-1dd6db443473@suse.cz>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 826F340014
X-Rspamd-Server: rspam11
X-Stat-Signature: po3qi9hatwgznrsdeo8tskwunzbbbtbx
X-HE-Tag: 1764097114-813108
X-HE-Meta: U2FsdGVkX1/Rp01lb+hodmJ98AJih21wI/T70F+IEwMcGC2Gr8wB/xJG4LbQz1tGTkn4ioMabl7uj2GtW+Dnlf+rthISvuOjHCLLB/YXL/TpZhFwbbWBBXQyCxb2vAXPol3RBhtm6nSfJ1hDpEtGoFeU4UxEXstXxOohPyLx7DbWVNPwxyG6DAzs7ZXxtLGeup4uFiR01uSxCE6rwcTX2jLbZ3yNHMUPXGquOOWQMgL2c+6ef97l+Qz1Q7NbzsBmrC3KRjjQdY1/oROy19m+rji900fy20/n7S1WfcU0yz1l0EYOsMT/XL5VYOhnJaReIofto83F6etjCqDg1xqqotVj6fOpDZuFtN7U4pWj0XjZKeJNRMYOZuSxIEmWx0QdQzNr7olUaqrbGNjAMIiFOfxEmRJ+lWv8nUG+q8WBCIoFqcKI473ntMhGiTo8GaOhFYsC9AJVVn8xQbANQZIcsJ2R/R+AyQMkyJdaNbfN38DmwngZCbh4TJ6qgVFDAb/h3UuxSf/pbmOnPjhRmrSl8KZEbE8zF1JXL9dSatQzpGl6yS4TYt7NDwcy2bOn0WiO9hwHpWlGCxpyB02zRaW5N0hYCXs+hujhFmy1+Yw2g4DY/6+hK48yLChDk51mEBYs/E5OXKtesITbbgj+VY9Fu3y93eECuCQxDtf6UUDTPbxF9wOdYOpy1KjdtRj+6bF4uY8zb/O7PshgemEc9r4125oCcMt4cMYuizjc57LHZhmVs5z5sEbuBinJzsmPcUzMzoL7Ci/ObjIjn3quvtBUj6rEFcrpu0ErJXtEflS1gv5WTZ9QkPPO2M2VZWLhmqg1mt+XUuWv9/87VHnaJil9hSA7aedpzGvn5Ethdt+095Whr/As26VTwFFGiU8DV9gh4SCVJjDLacwzP2I8LJHo+3kpiy8GZXE1FMCiDII2HULT9DuLfk1BBnOEclW6cKPGec5YkDpYNOqF3+v3R4j
 QE/rzLj9
 sSE6AAfHTlsJ+v4tFexxpvtV1eIDdpp2GTVWUz6gqMUa3VxlHBRZu9bkVTUsqITK9j1Kf9dQhW6JFjCd/tJXAZom2r1QQ9I5XQkhjYUMvg2nJoJ/akxFLMb9p2f6SzV8QvMmlmzZ9SOF4aM2P9BX/FF1ACddeGR80J5kKJR8rEMN9d4hKTKRMnSzwfmUDtN7cr0zRWSeG9K4oFibJSqBfN0G4ErHUvhiiKN3FdwuuHomMlsrJRhjo7UefOnCJuJ2R0yCl8IPf7Yp8cGKZYylJtsXdIgERnP5uK8wK9gjxxWo/Jt7//anTINPYB/CjoOshbWwgbSE2yDM2Ow3/w2DCuSCiivHIWwSQg9f218OEHtzj1FXVCNkgfL6vP//j2K4wJcMX3rlcXhHqJUoWENcbtFf5BACc6MnhT0qJdlKdHtrPQWnhQx/aDY/TVTCqMwOwFPSVwcez3NcHDyD4r+vuF+wHHGbO5/1709JJs3uQoWxvV5e5wtST5wcAijkXnxqQTPdbrseqF2OLe/9sOMh5YDK+De3rk8mMSuql5M3UeL45WYahx2VX9gSriWib21+5SnE1p491h6MUQrNbBk9w2+80aGCr+m7ZCdYl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Nov 2025 19:06:53 +0100 Vlastimil Babka <vbabka@suse.cz> wrote:

> On 11/25/25 09:45, Michal Hocko wrote:
> > On Mon 24-11-25 14:54:07, Joshua Hahn wrote:
> >> init_on_alloc and init_on_free protect the kernel by initializing
> >> allocated and freed pages to 0 on allocation time / deletion.
> >> Commit 700d2e9a36b93601270c1e15550acde2521386c5 ("mm, page_alloc: reduce
> >> page alloc/free sanity checks") removed page checking from hot pcp
> >> drain and refill paths, and instead coupled it with CONFIG_DEBUG_VM,
> >> debug_pagealloc, page poisoning, and init_on_{alloc, free}.
> >> 
> >> As the commit suggests, the first three turn the kernel into a debug
> >> kernel, while the last hardens the kernel against leaking sensitive memory.
> >> While enabling page checking is relatively low-cost and tying it
> >> together with page initialization is not unreasonable, it does feel like
> >> a bit of a side-effect, rather than an obvious consequence.
> >> 
> >> With page checking now pulled out as a boot time parameter that can be
> >> set independently, let's decouple page checking and init_on_alloc and
> >> init_on_free.
> >> 
> >> As a direct side effect, systems that have init_on_alloc or init_on_free
> >> will no longer have page checking enabled by default; they will either
> >> have to pass the check_pages boot parameter, build the kernel with
> >> CONFIG_DEBUG_VM, or enable debug_pagealloc / page poisoning.
> > 
> > How come this will not break existing users? What is an actual upside to
> > get for the risk involved?

Hello Michal, Vlastimil

> +Cc hardening people for input if they are fine with the decoupling and if
> docs for hardening recommendations or something similar needs updating

Thank you!

> The upside is mainly reducing the side effects i.e. being more explicit than
> implicit. In practice I'd however assume people running init_on_alloc/free
> and paying the cost also want to do page flags checking anyway. The more
> important patch here is 1/2.

I agree with all of this. Maybe an alternate approach is not to decouple
the flags, but to make their relationship more explicit in Documentation.
Currently, userspace doesn't have much visibility into this relationship, so
an additional line in Documentation/admin-guide/kernel-parameters could
achieve the same desired outcome.

I'll also let the hardning folks comment on this before sending out v3 in case
they have additional requests or ideas for this.

Thank you all for your review!
Joshua

