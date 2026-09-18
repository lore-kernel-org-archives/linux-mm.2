Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79ED1C982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 02:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1456B008A; Thu, 17 Sep 2026 22:42:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15ADE6B0096; Thu, 17 Sep 2026 22:42:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024986B0098; Thu, 17 Sep 2026 22:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C28C36B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:42:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6B23120543
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:42:49 +0000 (UTC)
X-FDA: 85225335258.18.B556A19
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf31.hostedemail.com (Postfix) with ESMTP id D320F20002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:42:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LQxBIdk5;
	spf=pass (imf31.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789699367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pChBH6fnUF5InIxQDkQOn83gyJog7ZSG5ECzSiY4hs8=;
	b=Fr0bgGm0W2+x3v2sZU+sVc7XgzJwdvqSHNGde8HdGFjBjc1913B8IGmUcTqdBTM6RtMy3k
	czwfyOjUx7TevaDbPSvWnkaKZDloqzJe8eY993yI5ZxFDeK9sC5i/87bd0fPPyvisS9JEn
	EJVU1EHC+8Ds+rSpc1iVlD+7fHZF4I0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LQxBIdk5;
	spf=pass (imf31.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789699367;
	b=2uwe1OydedorFC/FxDAwcmav0opPQLeu+eJQoDWgKGQ7SID1IJA9Eq02JrJOnZmSIIW1CS
	fXJpMMoXHaOlsytJM8Ykv9r3ZJnz/kDLwktYYpo86ncsKcZd3Yl+alrfvINbnJ3cQCe7mx
	gLE93Bg9haKMTSs8Tn58N3EiJukalms=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4cdc0d663so98970a12.3
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789699367; x=1790304167; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pChBH6fnUF5InIxQDkQOn83gyJog7ZSG5ECzSiY4hs8=;
        b=LQxBIdk50nh5DnKxvWGNo5Kuhsi9gIrc5luxSo7P7Ti7PSWfU6iq4duh3yokogl71V
         LiVH42oCw/yzhqLVtaDQK4hkymjeacsQgXoPYqL69SHgQyKYfUoynWRSpMCFj3K5ijqy
         GnibSeO5W0IaVJp3+jBJ5GWYnTBeYqPKffmyuvBifGpVqq4f10s/BzQUeAYVw9jDVdtC
         gcnn3x/iD1B+mPijJ/Hnb/vcfWFa29TDURVZo0VOu5V6ewvyWmQ4AnMSIGdjssLPu7AR
         2t3aOoisSde/Px9QZsJ2VjrHywDUDRhwut1H6AhkExvPcQL8XlVU/w0DABzmeSkVh3nL
         2rtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789699367; x=1790304167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pChBH6fnUF5InIxQDkQOn83gyJog7ZSG5ECzSiY4hs8=;
        b=1z7t71NztDwz6ZNT/kEN19xx3O8c3UEO7iQm9UKrgPW4TgoLn60hzToHdu19T+nnne
         TnqyMDVRlpdZED59kpdmjLzXU+ZzeWrbYJ/TLDLdjj9asRrZUl+hUSOS1aF2RR9mdtAk
         2XDuyVvXWD5w5tL/WfmkElstRsQA5BAdebY+TTss5VxrVAU+d9HKJirsL/d3knfsnICZ
         Ko25uz03foDkbs+D7JYDjg8rbldFr0sprW5iW/MHlqeG5A9L+HKPOjPcdoI1xA95cLxQ
         B1eE8ECizIjfvSsNZgQwnuoz6u6fmTpbKQbaqQrOOjmOnQQwLs+OetmQKJ7lb4diaVIp
         9Evw==
X-Forwarded-Encrypted: i=1; AKwUvBwL52vXdKy04YApUMtgCvscwugkNdV4NBm9JlFIiF+O75jzYnBiH8XwRDk3laOgNPvcPJMf6IRv0Q==@kvack.org
X-Gm-Message-State: AFuF++lXxKMpJDkHsCtjG7QD006fkQZ8AvRaY0yVvZ1f2hc2QSVxOEeu
	2D9Sa6LslNgU6726iujVOvACWOJyzprkl7/8depEf6Fm1ZvF1ffWQWTa
X-Gm-Gg: AYBFou1Q3RzicQqTu12PwtdgSSwWHcSsTuiHexkEPDg956KJEDNFj3M3x4neq2zCjg+
	zZjEXVpsz7lT96GAlkiGmuIy/QJi9y438/PD6wkDijQJ+Iz8gHNx4LbuX3QTNZAysnuGp8V78jt
	d6qclA6ZaxFZgv4dQzJrrFbVoCMp0nTBX8w4woGjJuEsRTrdTpNvWnuF4Kwn4Nn45JsJna0ajtV
	J/RKashtJQOmX5XIrS4MnFbdoryetEIwLS+a18sKB/lEzN8C0TM2kcmYokVRwkD/02dTntn7rIe
	n40SvqFva1y5sF4bWXEtxWXLOHJ8BtxMwZE+Nd6MIid2gsvziKhAughC7yGf+hJM4XgjEc9s2Gd
	sSd3gEwNBWJSZ/uUl93II6h96u19vfIpqZrQ+mI0MqpzM72qouwR7v8fBCW8UMha7RXRYrM5vqs
	l/DYIAwnYhAepNxGA77BQvaJwFz9BpWH10n3PmjV8P99AciqzoIzyI2TGKKcEZ587vBpf5zD6pb
	EJhyWndcBGmGQ1CWWdJe4zFId0=
X-Received: by 2002:a17:90b:39ab:b0:39e:34d6:7eb5 with SMTP id 98e67ed59e1d1-39e54b85746mr2288555a91.9.1789699366611;
        Thu, 17 Sep 2026 19:42:46 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e5a53e4e1sm550938a91.13.2026.09.17.19.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 19:42:46 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: kmanaouil.dev@gmail.com
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] mm: adjust free_pages to make __zone_watermark_ok() mTHP-aware
Date: Fri, 18 Sep 2026 10:42:38 +0800
Message-Id: <20260918024238.31128-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917171642.b4pkhqmvjwnq3vmq@wrangler>
References: <20260917171642.b4pkhqmvjwnq3vmq@wrangler>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xjfpk1e5crroprtw8nb1u74nqbzgmd6k
X-Rspamd-Queue-Id: D320F20002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789699367-127843
X-HE-Meta: U2FsdGVkX1+WPrGVjYFWAD4yKssSE4vKPT+BBvwWwDM3zahZ1/t42gbIK4sHt8pPgc99RD9frDaOwxIs1qdU0t4SAe2Hj8M1T7Xs+jUeJ70gIzgeSrjMTzpRdbo9iBg9hgUCxNAsn8CI5YjslsJ/ptJdZpvFa6V+WkypmsLFW/KfRwu6Gakn7ujnUH9Je/JhwIAdxGgWgF4V3VJEvsZGSOUd9a3KVCrjzxjnNynO2vXuxlDWHx8MjmyEgI0GXDzUmGGtx01JfYVkWk5NH8sF4DZGlR0DjRBOaW7iQRvZjd4pCG5tOHEjUm9hXkN1XJHs9uQuALTDQGmK104J7cAOEPm8sM7bbrEhSDhWHAay5BOeL/ETEDp9Q3LcT++ls8mUvTTLKic2WPggCWgwwXYaLFldlumab1dBLIS3Z0+PSGKZQSABDHxbdM+TcYxoRJPMK6K67OJOxoZYykKywbjFW9PFH4tNIuDjuE0UIF1yj/EROqJz8kN2+SjktWxMc4hLUnop6CU+aR9V4LMG851Tvb3I9l6rnJgQIGd5Gx82UILS1+7PAXbNmF4oeJZUjMIY39Aq+Alu3cDCvcYD+HBSb3GAYrdl7qfURA/nRW1H5biRWqaFV9A7JIE+JaEJCFL4pq5mM1GMD0v8JxjctaBEU4VEJQeEAtyFR3S5yuqhOBXA91Rx0B3q76IoJjhM2LQt8NZIinbUQ/EYsGSKHAybRBpRLFCPQlwqTolSCc18iVpxYXq9hcz3IFR6JS0oxR37hcxLklK8NByDfV5Gd8mxoR2cT6WGiiHF7NfrF4Bk+/KCsOGtTzxZES9aZU22/VIS1JDCQwcRzDNz91PVtNJMjU8en/EZh488oS722nBXyjfUeb4yvsq0/4NX8Z5LLqEXfFRz9u5AOCwE1K7ecWUOiU0GR2As2rpZvqIEMpNJAH2X5N2cnFIoXJ9TnAMZsHZsU3yMOldth12sfSu9k2b
 82AqIr73
 EcYtlaNAkaSoz4swccV/XQKyaIxaIoYZzY0mX9s6pSsZL3dO6lbNT1TIqXOEW+eCzXtl0B28XAQXAId8G+dKbC6l7PhjQM/dt2G2RIK7N8BU2Nz+R+WURHsi8Cn+CA9l9ajydXFDoeexOMxp3sOjqCFEosisQEHMT+KyZSZZdy6hgIwpDWWHB086jtl8pCwkIAOr4nMfbfBxEMSUTRtUbAXX0IfC21h0onS82qxavOUe82vS+WAEzDL5HOLV/9vA6ltJ7fuTRYTfptjWm4rPPRfWNAiU8oGvucnF9NzbzWdCr9SZ1aINyDso2K5OYBik1nVxilfht0eq7AFxx6/LbeKHqpn7lzUbElyJUzjVQonNFEotJwXrKozEMsqi3my5alFMQ7t9D281w0bc7CNQ8yEvEQT3PQLqQGEpK7spQ7xIe/9AYHcrT8LAF8SPo6JSwVj0ryBah8lZQF7szKmOlhu/FTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 17, 2026 at 06:16:42PM +0100, Karim Manaouil wrote:
> > +	if (READ_ONCE(huge_anon_orders_always) && order == compact_hpage_order()) {
> > +		unsigned long free_pages = 0;
> > +
> > +		for (int o = order; o < NR_PAGE_ORDERS; o++)
> > +			free_pages += zone->free_area[o].nr_free << o;
>
> I understand that you don't need a precise value here, but in every
> instance in the kernel source tree where nr_free is accessed, it's
> accessed under the zone lock. Do we need to use READ_ONCE()?

Good point, thanks. The nr_free read here is an intentional lockless
estimate. I'll annotate it with data_race(), matching how
fill_contig_page_info() in mm/vmstat.c reads the same
zone->free_area[].nr_free field without the zone lock:

	free_pages += data_race(zone->free_area[o].nr_free) << o;

data_race() documents the intended racy read and keeps KCSAN quiet.
Happy to use READ_ONCE() instead if you'd prefer.

Bo

