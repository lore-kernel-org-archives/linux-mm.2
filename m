Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0829FCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CF868E0014; Thu, 28 Aug 2025 05:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480028E0001; Thu, 28 Aug 2025 05:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3486D8E0014; Thu, 28 Aug 2025 05:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2363D8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:51:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF406BCD4A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:51:41 +0000 (UTC)
X-FDA: 83825699202.05.5C7274F
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id DB6B6C000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:51:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WeEwPcnk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756374700; a=rsa-sha256;
	cv=none;
	b=eu/R1nn85ATDG4l49ja7Z/mzA/ZoC0ukqY25fAKfjIjtmtD57plG/cxC94A+uWenKDQyya
	6toilpG64UAf+I9gpfsfzWXDK1eaBxexzE6ZRISkQmCr6uzx5E9L0hXXLsxH7dPwEiCxPu
	QDnq09RevuWQWbNVts3Dz/SyzR7oJt8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WeEwPcnk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756374700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcu0DYxrMs+6R7G4AatSzbn0mHIOQG5qjGHtzkS6pk0=;
	b=lmkNQ6ezqKPduR2KyafqeB/LpJTS0DoqXNjZ0ZozAdfKmCDXuJ7u3/cJkAmGWgZojw0uVb
	yJoqvq/yzeoRc8ncOTysu+Wm9p1B7hJiyGcd5jh5WIHOU3JxQmaZnjGa1tqTJEV3O23Jmh
	wGrxIu18iulNW0DtmkGJqMZbHAFMfjo=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45b7c01a708so1098865e9.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756374698; x=1756979498; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fcu0DYxrMs+6R7G4AatSzbn0mHIOQG5qjGHtzkS6pk0=;
        b=WeEwPcnkbrGHDmbKYA2ViNUhN2XepuUfr60C2Vsvi/nUT5aI1z6OeUaVLqhC9oEGPx
         4Tuf0w9QbJeRZt5w481APN0F1NHIBJlhr5W0AMbUqIJiRSYXs8ASp1oK7qoxQGu2uY7r
         HHIXQhBHSiOk8hZQtL4Nyc/H3aeLxMpW31lA9SDbZSWLNYI72vGOmg8d0VuO6KmwAzst
         bM6uV+G1u7exEB6ESkIiWhKHaqeoGLHAM9xttiavzhPD6n9PkkMTGxCzw2jA2FT8C+qa
         SX/ruKVXL9siIHJWU5X7f2d3/kRj7AfdoAwNBp4ZG+edQiCKfY2pwV3OQu0UWJmkgF2c
         EQow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756374698; x=1756979498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcu0DYxrMs+6R7G4AatSzbn0mHIOQG5qjGHtzkS6pk0=;
        b=jbnQEtC68f8xwFeUg8RVwDniyfSKBGpltwwYp/V0wgOAXtXKxAH6XChmANiXvW47Zd
         szjn88UFybIdo1f4L1Joq0bWoSBxf6eFKTZeAZg9ard0IX6zmC06sj01GgC8jTAHHz9c
         m7RjTS3Hi8WWxDbR2+95z1LkUvC7OuiyUk0RkbA3ao9umELMED6UQ5F9KVGpU2ddBjwJ
         G+R9jQZUu0Bozt5eb3Z7hO/6HbZh0Wi3Jw8GdGZ1PNRrgeJ7x8kMit9LVwHeY1D8wK5G
         nC9E/83Xgp1LjUSAZz398Wo6vnocIGbycIyiESjprU6zeMfEVkTSVZeGOO//VydeP1dh
         ThYg==
X-Forwarded-Encrypted: i=1; AJvYcCX+8IHYpT31KLPbqHdSqLbCocEjcaiNRHa4tAIHq4ACalMOSHwIQAwKmlt6/dn0D67uJ3Zx9KWgAQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3Ba7QNEHK5OYmqsgS0jjTCcQEQBYwoWsnr8E8Q03GuyXY6Q4B
	tBHMUMkZgA6p6LLMBFuFE7LT+wt/Jsr5XAUu9IxcQNJzntH+lYodWDcb
X-Gm-Gg: ASbGncvJlaswPBUAzU/epUKv6FWjs/TDBHsdQxmrS3iqzvXChfPF3B0/Y+0E0Vvp7LB
	n0TZzjS76a+x0to+m6Uyw6ptVOceWV+GKqfkMDVsS7cT2Pw5YLj1E8XHyfBeLbi9YHz8FKVvtoa
	O5+M7AJKZqR2gfb2G9tJaWXMfUnNXZHEVrELo7faP53sA8ERML/GzU8jIEXL7/hloHhQunH6FyV
	OW1udv9Tls8Y9gB8p1jFZxgL1M70ItraXUU7vbOM5XRiXYNLP6eAwQSSXOe8nZr/VF81WHheNWo
	VSSS9bJHWEfZES8nvtEsqNDyUhrLK28rArIsmhnAcGXopfYqp+WiBFrjIc2LPFBO8BQKriqp/Pz
	bHxh+1aqMBTIeUyanr9mwupd/UvvpNfm4Llq5pw8=
X-Google-Smtp-Source: AGHT+IGr8n5UrW/1/lXAw9gaGgBuGbNK8ig/FjzziWaJErrSrrUmOz6ZsnV6yI6wYcnNM14gKe6ADg==
X-Received: by 2002:a05:600c:6304:b0:459:443e:b177 with SMTP id 5b1f17b1804b1-45b65f11097mr83864065e9.25.1756374698038;
        Thu, 28 Aug 2025 02:51:38 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:5a::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b797dd66dsm24817265e9.20.2025.08.28.02.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 02:51:37 -0700 (PDT)
Date: Thu, 28 Aug 2025 02:51:35 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] mm/show_mem: Add trylock while printing alloc info
Message-ID: <aLAmp4oayTfkPJ3o@devbig569.cln6.facebook.com>
References: <cover.1756318426.git.pyyjason@gmail.com>
 <7e2bc96faab1a338829e549246189ad96e6c866b.1756318426.git.pyyjason@gmail.com>
 <20250827150619.4e468e68988f224f9f9bea6f@linux-foundation.org>
 <aLAUhXeRVWzLCNNd@devbig569.cln6.facebook.com>
 <c8db3486-4f13-4922-a270-1fbf61e2d782@suse.cz>
 <aLAXsptN4cw05IoZ@devbig569.cln6.facebook.com>
 <2182c715-aaf1-46d1-809e-e4142bc083af@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2182c715-aaf1-46d1-809e-e4142bc083af@suse.cz>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DB6B6C000F
X-Stat-Signature: 5j5yq9sioir6fjz44coqckmcq5ja557e
X-HE-Tag: 1756374699-876433
X-HE-Meta: U2FsdGVkX19Au4N/SpglplD7LocgsAQzFlBwhhyeF7GgXT6HYe6Xi7QwxISxJ4sGjhxFCVCYlHZ97M3YhEgpcBT+Y9dWLb7BqtRnmfaYoPMbZxZYRP6LUbHvklnTOrZDt6m1oJgLu0ghrWf/fjaYgSQPSNas6Q132rt0q6eTssahX8gKCRhE+Vq0nFhXtV5YLGUAlgykJ7vYiWZ2r1azhp0oaV9NEjIw2avrJbGuzsLM+afDhkssJKVWNI/dyOX/B2Po3CAl3MGVnodKnkwycQeNr1HlsglwHVffv7koV857CnDlZ0M90qbUzvrczpyOI6ucmWsIASo7OAEDujKzwpMiFs8t6nfiV+OzAm18RTMYoLvs87jqbtClJ/Wi0YhNN25viLwAWTKEMAvsn2apoZ5tf9Nqgbl8VkDXrun9KnPKMPMCvr8NI8WSDK8zwEnvGXn44VXzosxBt2L1QzwgjoeuqYNpyHAXRUADAiOadCdEkis/G3cdWq/y1WWHcmoREtsIWu4LAEgEgXem2H2WOBoq7X7JpZP2bGKkABE7oq/Y+yMsA3g4gcFuZNYbNCyJDPK0jKyNQdS7dpT5JWHpGQd/5RcaFT2NKNq4z13VnWXhwpUNnOdCWzcL6+f1jQTsPoYbYZ8fyuN6x8BiAqyqm7dbyM5rJ4q6/bkl315QhmQc0h62gyWw9TFNuTX5hCaJST4JGrHj0bII7dSFhomDpSJT8uUbwvha1UyYe5l2T+7WcJI53SXOhMfT/W+dBeaTpK+FMY3XRWF1ZYG+ZTsM7cOtB95kGW9CvKKVTPHuqFOx17zBmtCCzSnroCCRkZOq1HULv7sM/sPK//hFaVlNN/Dlt9kiAEGsXAehOQpW6qjeDTE+j01XB5kmnO3Uu4JHyLtw65A/pcVudleNUJndQ5iNkagGRcj3ASlG5pdgbdls84acQaK6NHqm8UjjlQvc3XOu+KeNV6fYtWoF5nL
 t0GY5wy0
 InTBYAS5WkhFj1zeqAxwe38ZedgUGKsiS49K2nVQ7WotIVn4KgNa5EF1t/CyGbbkbqkSs/8DnzdOXq6xFDzXAwbo/Z1X0A6Ewl4paFjlactpJ5dbYyPcCCdytibRPgJkLIcQP7dqNNxWitxBwFnKjlM7VD2WsioltiNQQrBY7+Fwz0m6CKM6dij5KM5dCHIpKXKtZ66GabyMGPR/L8tSHVRG3PRxCmIkAaRlsqWyNs0hfwtX1v6sb2u6nm2SsyPLq9x/dcHY8H7AwR/2ado55VprlzpSUoOa0PpE07Xk4O9KlsLpvxgbYGEOgvlogKyEPZZU3g1wTroZ8UtO64dvxqAt6znaHdSUIiQs3z7uMuGlgXPa+FBTwyyiJjGVCfzcSf+ZARyY9M43nAVYxPEiPbbEtHLPyR0w4xxbDono0aVli9KLFI8xUiRaehSFA/mD1uu/EnFT+CGY/CvmJzze6MrbGROfubaO2QInQxHZeAJvD/hIILtAVZNz3DwSsOOAoGqmk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 10:53:01AM +0200, Vlastimil Babka wrote:
> On 8/28/25 10:47, Yueyang Pan wrote:
> > On Thu, Aug 28, 2025 at 10:41:23AM +0200, Vlastimil Babka wrote:
> >> On 8/28/25 10:34, Yueyang Pan wrote:
> >> > On Wed, Aug 27, 2025 at 03:06:19PM -0700, Andrew Morton wrote:
> >> >> On Wed, 27 Aug 2025 11:34:23 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:
> >> >> 
> >> >> > In production, show_mem() can be called concurrently from two
> >> >> > different entities, for example one from oom_kill_process()
> >> >> > another from __alloc_pages_slowpath from another kthread. This
> >> >> > patch adds a mutex and invokes trylock before printing out the
> >> >> > kernel alloc info in show_mem(). This way two alloc info won't
> >> >> > interleave with each other, which then makes parsing easier.
> >> 
> >> What about the rest of the information printed by show_mem() being interleaved?
> > 
> > Thanks for your feedback, Vlastimil. We cannot use trylock for the rest 
> > part as node filter can be different.
> 
> Right.
> 
> > Do you think we need a lock to prevent the whole show_mem() from being 
> > interleaved and to acquire it at the very beginning? Will it be too 
> > heavy?
> 
> It might be risky so perhaps let's not. Guess we can disentangle by dmesg
> showing the thread id prefix.

I have thought about this. Since each line can interleave with another, we 
would end up adding tid to each line. Not sure if this is acceptable.

Thanks
Pan

