Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE0391093177
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 05:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19F746B03D8; Fri, 20 Mar 2026 01:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1505B6B03D9; Fri, 20 Mar 2026 01:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 065FD6B03DA; Fri, 20 Mar 2026 01:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA9DC6B03D8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:37:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94F541A023A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:37:36 +0000 (UTC)
X-FDA: 84565334112.16.DC16AA4
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id C39E8180007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:37:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HccoEVNr;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773985054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7AUkyahrA7jetaNYrGD367jzrlPTnRWAlYOYrOS3To=;
	b=z+jpCTJzm42nNy5yqemgcD5N1Tk6CnGFeYj4YFDVgqshK5BCuPulH/bFEf/lXY/L7PY3cP
	QKPdXktw+hibQG64ACpzn7je685uC7eTYTAmanC/jjWjzoJnjTPwL8JB+r6CMep/x20u7c
	vip+yJVwThXa0OBse1KVXzA8ljiiGBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773985054; a=rsa-sha256;
	cv=none;
	b=I3zG1xhIANThvEoO8IFFEMW8sRdNxeckXiKa8kzMfbghPvUpL+ve6TidpB6qOlBqDQu5Ee
	BlrlFAJ05943FeqHkXB0TGa1K5YBV5A9zVclOz6O+c2qla+PVPQ8Haq6rajs1Fi3SC5eqI
	gvv5ojCLr7sIbUSGNicRYka2vuPxoiY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HccoEVNr;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2aaf43014d0so9595875ad.2
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:37:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773985053; x=1774589853; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t7AUkyahrA7jetaNYrGD367jzrlPTnRWAlYOYrOS3To=;
        b=HccoEVNreSn9Q0V8wJsXhpx/vxYHRpTPii+jhM3CInrfiJ/PZ3lEj+YWv0UMGNzh4P
         pJ9OTk4oJZNieX26hryVrDCx6l/BU/aMTgX6ykeKXwt45Z1ok4Sz/CJC3C5gDZ+kD49+
         zQxYis9orC6dHoQ7uokRprLxCKxUwVRaClDHVuQxFJM17pvjHdPHj2sUHz1di4uLwMuw
         vP5m+E7Uv9Mzva2RuPax4ApRaj8Clki/IVfrrDaNBdIZn5yrJiiodflx/7eSpE5USWUs
         oNvKu1bMGieU5bwCd2WL8bP4kcBjgK6WlaZglMuFXKE3cHa4Vj/1wjzU9PmmbZjGWW6u
         z1Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773985053; x=1774589853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t7AUkyahrA7jetaNYrGD367jzrlPTnRWAlYOYrOS3To=;
        b=jsl6rsNAE7Vi/tAlAl+yKEJfQzewRyU0pxTctOrbn05eA1wx1SzQwg2MY+tobu0OHl
         cXsFOn8IurxG7QT2AmE2qBinJPZrbCS3yjcM0HxWxO3TvUSJ5z0idBXPCTsr/y3LsbKx
         oHuAzEBw2TVmG4oyNJcTcoxIevWS9/J20nypKxRbXwvFJMa5FJNBPfF5LLMb1Fp+f63S
         5U1IoDUjjgtAm/dezRR/WZG+zPgE6kEQAcQqD4us+qu9MdDIJB7hHujxDR85umcMNtDw
         NtBaEB2L6lQQE/LZ+rGdwTg6bijtrzpywGyD5bOM0n22TFWtdQs9ZDUZLKxAOXFxvhHV
         87YQ==
X-Forwarded-Encrypted: i=1; AJvYcCWAEmEMOsOJu+KkfIY1NmlNBgC5fsMMBvHkKDBPvdeprCBlw378FGCJt/9ypxNqxs+1YgNm44LEsg==@kvack.org
X-Gm-Message-State: AOJu0YySzWw9dez50A+rAeIPwfrVuLnP0yMJrssidZL1bfs/YU9/wsiC
	MptpHSj6b1a6zysNJEBb4e/6g90P1osRD+oyoDZDbVYnx61Y0j7t+AlAXNCgpZbt
X-Gm-Gg: ATEYQzyo40LWW2q02uJbmqXpGdwIvGL2RSGsbIPGa8LPnzMMjkqpf0svhT6yERp0eoq
	A5SzqWxbjgh7UgGR0L+vlAcfK+xFMy/C2FKyywyd7jbwMbbsVvsIqMwBQSv4ZXauAFs8w5zXBnP
	Wrd65JB5XV9FgxZ1WqS45VX9aNZV5iTUcQ9AuklrZtLDsb5gO9FiO3DuwCzRNHn4lcDQn/HwucY
	jSv0Q0BCZumGiTKFf+oJAF63KfEvnJAb4a8jQylO80cnD1PfsZZyvNeHJqG+Ps2gRzVCPUlT3w6
	fzEYZfuv1QJkxMMNEDjVJtAG0hQ7Afm+xnMXYGm9MVVNORis22MlbbO2HAlYI/NxXHgr01Ez+H6
	nm/CnU47KMepE6fmgSCX/jsTyBVfoI3dxhsmrCtzBdpAsl82RrC7ms4WCLwVysEeZGG2ANhBo4g
	DJyKI8YY+UbTJaeh584/H75RQwMWscu9WD4qOYHT1wB+Z1IDEBpDX0DsDNOEaP2A==
X-Received: by 2002:a17:902:e850:b0:2b0:58a8:5f9b with SMTP id d9443c01a7336-2b0827de53fmr18104835ad.49.1773985053460;
        Thu, 19 Mar 2026 22:37:33 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08354bcf0sm10226655ad.33.2026.03.19.22.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 22:37:33 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] Docs/mm/damon: document min_nr_regions constraint and rationale
Date: Fri, 20 Mar 2026 13:37:28 +0800
Message-ID: <20260320053728.213664-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260320052428.213230-1-aethernet65535@gmail.com>
References: <20260320052428.213230-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C39E8180007
X-Stat-Signature: wo1e5tg8tzx5cbsurzx41611xnetnn5g
X-HE-Tag: 1773985054-31931
X-HE-Meta: U2FsdGVkX19Ytw57FoNdbeoQW0SDeOMWQgB4mGtz8XLG58XLZqSKaAKW3zbNuI2cPVDC9LWHCpXrB7nmcJCU88hR4I6U9SFT0BHOzCFaIxT5DgE04nc122FzZ5LWnrqRT4PEs+iNtKevqeuX61QWkGQqVNwUWvDFujFOvV597NlC5IxxOO9xvvrffaTD1DYSRM6UL7BPnbNjrPK5YLhl//DoV7axumLwUPGgV8Jd6tKDEgHCbBXG2XBYBk89EXrfvXX74VZCGaJKKOmnHTdX9d3c/6z+4AZC/FfMqVP2DBvEgpI6iVEdIjJ3ig0FD1MvE8W+r8358yfKNpGNGq8yaYRr8FPT5Z1B6u6gUNKN5d3aQjAUkxYeUbEexrTmxkIQeE1wWmahydvcbReJ+i3SbODXP408JZ8YbNix1iIktFv/Q557ZIpceUC2fRcAf8cyavZj9vW1W0+UHKrcoDYhhJm5weG47oWw1p0FDSXQF8gMwCHzQGRwzq4H+cujiJemjl9mVjFe0E4L90aEH0c94ojnEf13nCkXIuVbncJUYpyTM8twvDbOBw1QGaCf7LeJUqBE8g1hEVqU4Kl/sDV5krN9ro7O0lkhmDia3qvk0R/epOrvG1Na59roDf+xlioT9bNeTM3NeLxzDkl3OEKG0wljyTiG3+4oGAMD3ufRggDfD1+T21RxvzTvdtZJjveXGJ/1DcKcr4xJ8Q2YiYDaEGKm1+nybCxi/Z6+piu35D8pT+6DpwJwatLdOhV/ojOuD3M40Ljq06ocEH+YDSVCYVpHg35Ii3FS+YE7MVj2MzaqY/+jlQR8A9m8qxmpM5VYzowvBJFWycTURxvx5VZQ5627b0z62KKdzXQa/2eFOPTx/3GqxnyzmVtDdEm/CtG4azHWv8AnMAsCU1MKn4NMAvNguXOazQEDBUgitL37X0cuP+3s8djD340yh92uU2+/nCBa7zHFLN9nuEaMNNJ
 l3CLL2VM
 P5Wu2iCO+PhIURyoBWK/SWVTFWUYbrJNTbexcDOQkT8gs80kNPy1ISXvbNAUxTaZ8ojqbq1EkOqfJY1WnyOUqCPnwGNkNlGKcex2NfzL+d2gxj1ccvKYGsT/M4Y92YQoQD34hmSxiFnctgaKfbl4kWF4oNgnAqbMWu8B2MV3RBS0PKLKN1itW8aH5PouHUebLDbMffmUVs9/KHDfKtu00tBgmm+j6qXlM2CxlakWWet8517k+C/8HH9J/MVVYcOtCJ8vlneAiqj4w31zsqqP5ghIXB3zRlzmVV18Hlhgl7NgjZjHQeiSQtAk5GEpyNNpmR1EpIkP/BNdQ0I1acJrVuiiLULd1iHJqkPVn31BUw3lC1mwCxeAj/i0D59bmzIUX6706F/+6KBnM7C5zoIgYSWL7o+YJtj++ITQVvBDzZunaqhd726dtu+8STQp+jnLJjmIKlSsHq9BCPQiQTxUM6lThLEEN5HJCqD8avK6k3CevmFOlWubMjvD0EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current DAMON implementation requires 'min_nr_regions' to be at
least 3. However, this constraint is not explicitly documented in the
admin-guide documents, nor is its design rationale explained in the
design document.

Add a section in design.rst to explain the rationale: the virtual
address space monitoring design needs to handle at least three regions
to accommodate two large unmapped areas. While this is specific to
'vaddr', DAMON currently enforces it across all operation sets for
consistency.

Also update reclaim.rst and lru_sort.rst by adding cross-references to
this constraint at the end of their respective parameter description or
usage sections, ensuring users are aware of the lower bound.

This change is motivated from a recent discussion [1].

[1] https://lore.kernel.org/damon/20260319151528.86490-1-sj@kernel.org/T/#t

