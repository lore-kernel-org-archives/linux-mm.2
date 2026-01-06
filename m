Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B247FCDC19C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:24:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136B86B0098; Tue,  6 Jan 2026 08:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F4706B0099; Tue,  6 Jan 2026 08:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38996B009B; Tue,  6 Jan 2026 08:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E15716B0098
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:24:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8079958F9C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:24:31 +0000 (UTC)
X-FDA: 84301608342.14.CC47C0D
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id 819B5160003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:24:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=ILIkA1u+
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767705869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLe3wwA2KEDYP6Pc8iIb6s88ks6V9T+zKQuLs+23u7s=;
	b=XmMNtWy7MLRTeKqA4C9WcT6W4FHN74fo4M3OaPPJVLTdTyUjaG62G4zecAM+Q5H20KbxUQ
	YZ/NrWvpeOB4y6hUccz/mmB2rptWRnot2zur/2x00VfaaB9J0WZy1OUTBEaC9LBNbvSlwb
	qGT5FsBYCrCb8kptYhtjse+lYJHL2xg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=delta-utec-com.20230601.gappssmtp.com header.s=20230601 header.b=ILIkA1u+;
	spf=none (imf08.hostedemail.com: domain of boudewijn@delta-utec.com has no SPF policy when checking 209.85.218.52) smtp.mailfrom=boudewijn@delta-utec.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767705869; a=rsa-sha256;
	cv=none;
	b=O4fRb5z04S63f7fU0D3mcHsshq6IshnZro4hE3+KctusJlGIwvMuI6SzdeufH0MCHMFy24
	eLvOEQYiTgd29J1lo0iTnxKJwM8lEVApu9d6U34SFRGTbCrHiT5hl5hHjvPVD9OxeHH2y6
	OMiXjGoAtp99Gk+m/QW5a2mFqDVxgPU=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so198615966b.2
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 05:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=delta-utec-com.20230601.gappssmtp.com; s=20230601; t=1767705868; x=1768310668; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLe3wwA2KEDYP6Pc8iIb6s88ks6V9T+zKQuLs+23u7s=;
        b=ILIkA1u+ewUuNMgtQA01qe6OF9hD1uwLi0mIzqxssdIZLph0Shr30AM1181oVT6iqF
         K584lWVzg5/VHTSbcoP7TrfkTTPgLpdy03OKdJrnmWxnrTzxrViVP2SHw98YWhSWP/1w
         rjaRP3vLpUyvvIZmkB8nfjTmC/v2tGW7DHVCx/z7WtDFeP2VNlQzJcoMDa8aSMxoVImx
         lefgSX3lu/DBo+iCZoKls6i759O/sMts5r9pD1SK0KUxw/kdK3CG1gCPQEcIrhheRcms
         YtaCf0oV6hYjUol3IdkTX8uGE3lxP0PLhB7SaA/1w4xLtapD3H6Z+0d9O7dx9xQ3Ez2e
         fbgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767705868; x=1768310668;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hLe3wwA2KEDYP6Pc8iIb6s88ks6V9T+zKQuLs+23u7s=;
        b=TtcjAM6N0jJaFQj61Xx0boVNmalxvbXZRp1rcC2TeoxvfP9rAGhDUG9nMKiLzZwY/Q
         2vYhPeou0KpEL7TG+Kx9PFdcFv4NrY8NH8L0s6JhntrYJypO/TzXG8mmQ5nXr7VXjP5n
         F0f6DttsbQ2pyIfeOt9JGUqGoSXNyVJA7t9nqgoYaFSIyZ5N/Uj6rIi4gNUC8eq9feLP
         iB+929s07mlBkr7b+z6Za/WIG4eC0WOhwa7U6ow8ektDij7GrlL7KzK7ds0zyciub8/V
         ByEFIDPp7OGa2nqtKhtkk8vJsnBtpCIQfH3Gd+RSJbVp8wOvHe8PJcuNBcaDBpgwnzMf
         xF0A==
X-Forwarded-Encrypted: i=1; AJvYcCV1+uvSzcoZ4s1Wul7k25j3foUXjDUf3l3j9gCKzc5bfz19myixI1DbHjZMbldd/LJd+drPN3AGcA==@kvack.org
X-Gm-Message-State: AOJu0Yw9KdCRSMzw9aq0EAcTmjA+D5IP3/CnSt+0wQo/cmn4hj15jgek
	W1QJze1TgKGXOtcXnUb70m/CGWDOZhn1d0cjC1JNzB1YYezcxgezu+Br06plNVySWw==
X-Gm-Gg: AY/fxX5t08Mb7O9C0H2goOHFQTUCPaVfAom7r3fjv40eS5UqT6jX54PjX6DhFOh5w+V
	Aq4gklmY8sEeJDQw8WfjMTbAwK3lQoqLLRW34Pu/ve0aw4Gb9k6faP0O6laFu6jMkMmpFIs6Ib6
	N8I9GPVxNRJXIAB/VKPb/Ohohhj/71EVtWx/+9nQ8vZt1TwND85fetC9h71FxKYtobQcsBVl7tz
	5EanPd4vwQATpcWsKtv4oqrzWRQ4VzlYFQJQgiOLFSq89oUcowCp336VJu/8hVyK99MbqqeXT+I
	y1rHIpqWm+lxvdxCAvhJrMs3cGYMA14mJ3e/G/V7l82Jm5tNjSfYVw3gapJ7VG1gPENXoBsfODH
	Loxk+O/tZuz/gyFJ+esrkCrDytL2MvVaiSDqo99V2shXA04CPz55dE9tXl59TMlusagDRMyT783
	eeV6tGiIux4rCO3K3HF2GHxFpHGQd0Rt0buOUOQndrGzxXTlAbs9aTpM+oSAHAtvjQ/iyrVO4Dy
	MihWl2GFU69IyT6cMbUa0PrQI+oX/6oEK+IQVB+
X-Google-Smtp-Source: AGHT+IFqcaVA0U22F5AO1EtQKh6NaEtx//r6IuAy77I4Rzsf+eNQzqgKz1++L5vJry4MqCwG/RHJcg==
X-Received: by 2002:a17:907:94d3:b0:b83:3773:e72a with SMTP id a640c23a62f3a-b8426a43d45mr296632666b.1.1767705867458;
        Tue, 06 Jan 2026 05:24:27 -0800 (PST)
Received: from localhost.localdomain (2001-1c00-3405-d100-fd78-186a-9428-6b97.cable.dynamic.v6.ziggo.nl. [2001:1c00:3405:d100:fd78:186a:9428:6b97])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a27c8f3sm232698066b.16.2026.01.06.05.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 05:24:27 -0800 (PST)
From: Boudewijn van der Heide <boudewijn@delta-utec.com>
To: willy@infradead.org
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	aliceryhl@google.com,
	andrewjballance@gmail.com,
	boudewijn@delta-utec.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	maple-tree@lists.infradead.org
Subject: Re: [PATCH] maple_tree: Add dead node check in mas_dup_alloc()
Date: Tue,  6 Jan 2026 14:24:18 +0100
Message-ID: <20260106132418.57408-1-boudewijn@delta-utec.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aVx4PjdhG31LfjuA@casper.infradead.org>
References: <aVx4PjdhG31LfjuA@casper.infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x8yhke8h6m5tpqi3sarrbdgk5yejaupn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 819B5160003
X-HE-Tag: 1767705869-566601
X-HE-Meta: U2FsdGVkX1+Hv5UidiAX1rxDRfFHQDKF5x18/UzU+nYYnarggoY2Em2aXmq4jHRKtjNaelnje+MMF6xA9lyw9c3k4U88EZ3Ij34rdJPI7CFHHDsBqgYTmc+slrDEGrOm4i2bZKPue9ViE1UlqGtoMB6pGe0u32NG3+YIeahCaHFGTPGHKAzw0PjHulXwk8oYxRKnuhwy34FcRv2Pfd7A/mQm3ruS7xkiTvU7ne6EOyuf7jjXw1YaZnWCX/jcmgTWsVwMzTIVABUXVwwOZEdSVviZubCTn+E+MtC2SPqQ4FoY/BhYWpJNmSZTcJheRc+jdgi1Vq5OsyMuGHybKAAxMIbfW56lJyRKL2B/n/AefgumJRLE8rt63ji75fofAeRfujZCrw2eZPrYsqFCpguka93zaMijB6nV2CO5CobQG50DGwzxi1rUSyXCtowH1U/bdGuSYtIhzrHQZLW/ZuLN7UA0b/vE5jbhbD6US9Kfsp/L7YZBx1rZF6uGFHgjZDgR8PYJu8532tvQnJYKW/DifLs1F8IuTBouofRTG2iCFwe+UHAkzpl+MmQw2U5gilhDdkaD3X4fBKI5I2MSDXZthBQZZk4U62F7Jbid6Ga3SN4pFMQLCOQMCkueOvsf2NeVr0ndEybn89jVJVYTocwhjSyltbUxXdfzrs7icPLzOou+NU04EmFA6+ictSjEXJnS4423HZ69ZHEr2jLmxh1jJhuGFySB0cf49hCM0ClUfBh/cSSy1fasusPiJODDqHqIolEIaQBjYyY+5PP1VFgQkaahr6nruAymfhrGd7oc0EE4pUwIMxBRV2uKleoZYWfXu15rz1MF0FK6qSRwVgfsEhwvrozQUwEXG4WLd3pvyzbB7zJE3Z2GDNg1Gd4Fb0hA6o0cPf/TOyGytW6pS7QMae1BUdxw2LO4Bo5Lpu2/+HWo0aK4Os9YbsVyp8foMHiFYssWsPepoaIYeVb4QjI
 K7yNKl2d
 cr+qXJnQwi35VZ9YSnY2ar/qbCfLfV6D2D2RBVJF+mEEe4Y1N53xSfcxPSu/RjnpKrP1TdrYKPKw0yb+/h7D0NbePzSnRLFyfpUqLWFeq8Rr95CmDYVkVJvJKl3DFOYVtye2IbuBWT/b4D7JQ2HtKJ3sBoPQngV9+T5WgYiX0wGlt18z7avA/w0b66+kOBrbr+iKmNBWuU4RbHcNFP9bf7UTK1jdAauzqv9sebDPQmH0P5fkR4ATgP/8fimxjWThrQb2oUm/xo9o/zJT8+SOlItACC9o3ouNEx+0LN/BXRNjTCpjH89sjT/RKP7y4CcMHNwwsRITzQ4tIvK8F9K1ZZ+/OUCYaHrFMIojpk4ii6uRJIB3cB57ezyq9QPH3naLMJQ2AA11aWAMCJosoi9qvAK/UmuvB3M1DnRIoaKeOZSeZw629DE9sxM3Cuytgbna27GADKRli4YPylKXJcSKfMgZZ9Hcyk9biD/du495nUYNmSnfIGYYP1elT/PIw4AphhFbB/ujtOg9Velyk+3TEecg0yQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.026365, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Surely this should just be a lockdep assertion that the appropriate
> locks are held?

Just to confirm: do you want me to remove the original runtime check entirely
and replace it with a lockdep_assert(), or do you want both?
If it's only the assertion,
that would mean that production builds won't enforce the check, right?

For v2, should I add a Fixes: line and Cc: stable,
or should i leave it out?

Also, do you want me to include a Suggested-by tag
for your lockdep_assert suggestion?

Thanks,
Boudewijn

