Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15408E63F25
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 06:06:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BB976B0092; Mon, 16 Feb 2026 01:06:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169A06B0093; Mon, 16 Feb 2026 01:06:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040B86B0096; Mon, 16 Feb 2026 01:06:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFD3C6B0092
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 01:06:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 776E9140A23
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:06:19 +0000 (UTC)
X-FDA: 84449284878.11.D0A8F1D
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf23.hostedemail.com (Postfix) with ESMTP id A41B0140004
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 06:06:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="g/+KwNtV";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771221977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1+2hICCHy9jpCc/dQXjjfX/dwmXFH+Uwwb20tfSQEQ=;
	b=KbFFA3IU9ZUCSbOkaZV0rlBG4r92ygMTmBkQJEYx+pf8FanLG2QX0x447tBqeSFO6+urBF
	xO2VE7KUS/Z51mt495b3XyfyIgFT/tqMfZjfs8w20FD2u5QIe9fVogoM42rh+bWq1Yo0N9
	LS4dxBQZno/2Q2Scy+Uxm6treemVqFE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771221977; a=rsa-sha256;
	cv=none;
	b=BGHyOt4rbJU/E5loDuXmdh93MWg4smjRqT6IMrS8zgkG/hn2duA1MsLOer9Z0Lw32e0Edm
	kxKjPJ1/aq9ruXrIpAbaFir8zwXF8+0TamlQllF15gtqhFtuJUxIouHrELho2jTdbHPKoI
	HvIca4icKuki56fdMAOezyPK8wNLW+U=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="g/+KwNtV";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a91215c158so16237105ad.0
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 22:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771221976; x=1771826776; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+1+2hICCHy9jpCc/dQXjjfX/dwmXFH+Uwwb20tfSQEQ=;
        b=g/+KwNtVqIGzwbEc6tpMCkHcId+SAttdQkgIVn/AujTDQcrbTUbWo3Icm0l18L4Vt3
         YRbtyTLsUZrxhjjX/UViyAdMocXqDDrGYxj2V/e/ZBIgbpxvNyg3R6rzsMGY71Qr0kQa
         nggqgsVm3QmivObeJzP3aKU9+1D9rlY0mvXUtvVOXOIpnkj6RqsmVo4S4dENGIQFg0qM
         pLLk4t5z4ASKoE7RbgiuElFJnnv91gPQGhwXNTjoDeIcnul0wRh/zhG/F67d18obt6vT
         JthjEOtM7pizdauOPziDtdX5NGtT4oBP+ck8si61ztGKd3w/IGZMahYPWE+zbiW7yB9f
         aQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771221976; x=1771826776;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+1+2hICCHy9jpCc/dQXjjfX/dwmXFH+Uwwb20tfSQEQ=;
        b=E4TLHmbBwfTYEQR0Y9hv0G4o5zu3PqX8WJy2Er2ZTCXbkPf0NNzfpCN5anlvHD+WzB
         jGa+ce5h1oJ6P4BCPEP13tJgAiTczxhkUqM0KOAbtBcQrlE/ItilGtL0YILVXGi3oHeT
         3cEHA179ICSRMmL7qIOMzhxEOQmunrHOSZ7rtWfEP6A03BOeBaqychNQdlbcjTE6IkS/
         XUH3kTdjfnFcjnISuD2XaJZKOfSW2p4a3j4NukCq553U8qj78MOwcQc3wEvwIsbAooi4
         sLteQOGiMKqc50sr/eNMkAZ7BqD2Xej5lNi9JHXJecjpbcB/RJxlXqVIGKl88J+vjsvj
         L6zw==
X-Forwarded-Encrypted: i=1; AJvYcCU1pBG32p+zqPdvZiQO9uxK5lLSuRuEGahSDWIwqQO3pg1hXZpMzwEckDIRwnfsxoDyFDZ936KAwg==@kvack.org
X-Gm-Message-State: AOJu0Yzbwk1yjlhTh5W9DTYe8Eg4w12MGXUu0yLJJDyDPV6i7KzgvxE1
	prepDTDxAnXfSP/sgZgyi+UGrLohmxHeUT7ySd+B0kbHGxzEMdDqbTgb
X-Gm-Gg: AZuq6aImuHtpYggLXzvYHSXeRkYcYhRPWxhlWRb7gc1FhVboyxOnPA98jZmRFVeqAQ2
	vtiZ2YuhOBO7jNNhR1PDB0Eq8GWN+mbttcqZtQDTkV90qC6MhAQXo9Pi+aahL4bDJZU8npqgM8U
	SZbo1K2LkW0RjabSwEEYQMv1BQHkInlgy/bVG8XXlSYaTDlKIL9P8ifTYpocnDy/bv2OBzyFT/P
	Xac2BtS2BBB+9SLZtFwdwSFpa/MpgLlcAcAm2tWHfs7xSZtO9D+NwGOfEgwdA0Eae0fUUoqJesY
	A+4s9e/OW97MwZAC3tEoR8PPmI6mA0NAyAcPukuu2+GY66iC4pHbwPobyfITGCbKyOk4sWpaLNI
	ncJDjXqUOBz20e2IiJGblqoIM2XhKkcFOE5J2h3QBu3vFIEKR15C29WS6hG43YiRE1MMtiFJjP8
	CB+0Bpzx8x5+jSUS3GQuoE7WEa1qcUy0r0Kc16o7Far1IXrFfJuiEv9BlrnQNHms3rdgTAlQ==
X-Received: by 2002:a17:903:247:b0:2a9:634d:de98 with SMTP id d9443c01a7336-2ab5055e59dmr101213855ad.23.1771221976325;
        Sun, 15 Feb 2026 22:06:16 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1aadd47csm57750265ad.65.2026.02.15.22.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 22:06:15 -0800 (PST)
Date: Mon, 16 Feb 2026 14:06:09 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Carsten Grohmann <mail@carstengrohmann.de>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	linux-kernel@vger.kernel.org, "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
	Carsten Grohmann <carstengrohmann@gmx.de>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm, swap: speed up hibernation allocation and
 writeout
Message-ID: <aZKzUoZLp_3lK1s2@KASONG-MC4>
References: <20260216-hibernate-perf-v3-0-74e025091145@tencent.com>
 <20260216-hibernate-perf-v3-1-74e025091145@tencent.com>
 <CAGsJ_4zTCnL-bYN+nMXJEDPqHtF3hgiyHwyCoTc+nb-t6wouRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4zTCnL-bYN+nMXJEDPqHtF3hgiyHwyCoTc+nb-t6wouRg@mail.gmail.com>
X-Rspamd-Queue-Id: A41B0140004
X-Stat-Signature: 5n4zu9yw5x95dweedirzxryew3pzwjni
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771221977-973571
X-HE-Meta: U2FsdGVkX19M2rSlOzZ0FkHMYZmO2olYevqaaD5auB3YAkArckDcMqk9DdimUKGnTnMpRNn4lcYXAcCEA5oGUE+H+JadVNfecR08P2A9IfrttZ4TQPfYXCZHOXohc9+IH/LU1VfePhytWn1YP6ox7p+6Ea+9PSDdvKWzp6DT2wEpdzkewT8dSY+/nh5cLja8EWfB6LU2QSrbc/sqrnYyNj2S9Zh62N/kpXJuu4V3jBAj28a5G/KBNUkAaZ/FyLhaVa+wcRQpoaa6I4hhQEUaUYHZcWZCxcWs48uQV4KuO4M6BYw0YXJ3FXysqFUahbZC6ekmKmj8KbOJp3/UDx1CgHbaSaxX/U/zdnT+SqY0a0iUol2AwESshen34ZVpUnnHMQ4H/WZzZk1qsPnTFWV4Rgwyrd8r4Xp9wulHr4RSuilH4us3LnxHTh0hjYO3m/PksvyMOVM5KWlgZ96xcYBRZ0QOnNRjtjC8VUYVTj+01kWyxOzchyuAV8PhDwjRPnKefOO3rtCvZIh7r5qhoLi/qP+OTg31qM6z6fGvG8nwvC/2WK4qPWnRqQqgopISexF/BEFkpkJQhK2+IQ4QieMcprmQZIJb3kJa5bJI+cjFhgL3577MrOKRo5XloajWUslLo7c1H7nv4Ll3roirPDMQaM/FpMo7L3hWyX/7Y9jd/wcs9+1TN8tnBNC5nQ4+aHUik8EhdRW5Pjh1loDtCPTMpfI71OiO8n35iINYSeJh/8oG0Gl4wNvB3Xi+h/NJmry/OSkwV0+/zjM8jhGTsxy0GVpLkkMhTT0tnNYHwbPTVcwPLJZMbVsSmJ7h7TCWvxEYwD1roYfPLs70LC0Vh+aFMkLfZPbv3eJUA/Z3maicpxZyvT5y3zYE8Qc+7OfR+yVh+92M2Yyb6JSYvIzqlBnTcqtoKjQO4q97Fabfcja75kBrCAL3WO9J81XBHjUN5ukOAA8hZcJmWCTL7AXxtah
 /8UQOQJq
 HxexZgx27iAdjnHgZrjMQ7z5Jhejrc4fky5YUL0ox3e/e2Ni8i1bYe/VieVP8F+9mIeBrxmPyHkxSfmnzD6qrJ1pMLK0e7PtQxBb2EBWmOcidLQMEH2cGvncV0LvEA6bso1l0jqkRL5N0UMy+9nGjb4eklg9wptkFgI/mfRDUvbqMw0TuG6f/mJUt9YjD3MqUGvTQScbaZ/GlzB1MoefPAvuzm6mRhEGwDXxfCaVd/oQOBCk6F7QncE6XUwVlaBFb4o2ah7bo2ceGG5KjTKB/4IUQlGRCfTv43NuTHBMQW58zI51ONKIToxMlnyyRzjUWEqCDmt2hPioDzRapJooeQC9PJvyqyxLUhUzF+LSFy34AwGZSrvcuOhCwPR//Q/a2U+qXLkNA1EARKOdppvSE7JMfOOcMIOuPFwA7lNwW5jJjrg1zf9hbdgZN4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 04:43:40AM +0800, Barry Song wrote:
> > @@ -1937,11 +1938,21 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
> >         if (get_swap_device_info(si)) {
> >                 if (si->flags & SWP_WRITEOK) {
> >                         /*
> > -                        * Grab the local lock to be compliant
> > -                        * with swap table allocation.
> > +                        * Try the local cluster first if it matches the device. If
> > +                        * not, try grab a new cluster and override local cluster.
> >                          */
> >                         local_lock(&percpu_swap_cluster.lock);
> > -                       offset = cluster_alloc_swap_entry(si, NULL);
> > +                       pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
> > +                       pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
> > +                       if (pcp_si == si && pcp_offset) {
> > +                               ci = swap_cluster_lock(si, pcp_offset);
> > +                               if (cluster_is_usable(ci, 0))
> > +                                       offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
> > +                               else
> > +                                       swap_cluster_unlock(ci);
> > +                       }
> > +                       if (!offset)
> 
> I assume you mean SWAP_ENTRY_INVALID? Would that be more readable?

Yes, it's very common in swapfile.c to check !offset since
SWAP_ENTRY_INVALID is zero. But I agree checking SWAP_ENTRY_INVALID
is more readable and maintainable, I'll change to SWAP_ENTRY_INVALID,
also use this macro more in further codes.

Thanks!

