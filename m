Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9376CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 11:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 238798E000A; Fri,  3 Oct 2025 07:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E8E38E0003; Fri,  3 Oct 2025 07:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1248E000A; Fri,  3 Oct 2025 07:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8C528E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 07:18:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A7DF21A078D
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 11:18:55 +0000 (UTC)
X-FDA: 83956555830.12.F74643C
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id E57921C0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 11:18:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BlzTUzlc;
	spf=pass (imf21.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759490333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SNBkS+Hm39wTU6+E0QoP///fT8wlA6nV1YT5ebANpjQ=;
	b=iFwg6GEKlowkKMrxEq1IcGkxjMI7jm9bAV5gxhAXVPeqYkcrzsjPKL66//qTNhjmisAwSw
	ZSfo6JgHfVokBJyNKl+XDUZu7i7sFdPz6dmKAp1LOqRFQbT9+wfGPgxp9emkFnS3WQ54o/
	FuU0gdYFzQR7WcvEBBt8gUFAD2oVPAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759490334; a=rsa-sha256;
	cv=none;
	b=bZCc0opzW2bEQ3m738ndrRzfpDppnl/foHlQa6wYtVEUkKOXjFjPfgMlw9dw8locXfODMf
	kTAfO05xiU/wTSjXsOFdy427VOVCxHrZD/CWEod5NwnM4Vno1FDeGhFwNtfj5tZEkWT+t+
	AjSS8UH9NacaIwyKU8y3Hl4fG2zS5C8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BlzTUzlc;
	spf=pass (imf21.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-78125ed4052so2476366b3a.0
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 04:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759490333; x=1760095133; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SNBkS+Hm39wTU6+E0QoP///fT8wlA6nV1YT5ebANpjQ=;
        b=BlzTUzlcK4Bh44jwPovJjnrnNnyVA+knzHqw3NhPb8N0vyHzLRgJV5aw6LuxoNcpWE
         iIKHz6v8PGhpMDIiLulqeyCjYYhoPCPinNFucuiwobzGmZo6ViOT3unqgbXqdl/ARI6F
         iQf9pjWZ/LEc4wxBVzd6XSyq1zATwnp5txtJjTS+GNuO8X2/egOTJkO+Wu7IHx5aU9A+
         e7CvBGgUV4gtpkBkEne6aaekXtba+RHrA24bt/o6jt/zsUD7lYyZl7YztybhqMW8YXF7
         WgGe8FCxTDJaNayubFeaUUorGNUo1kFWrQXbF0mkZG6uZSaYsX1wQRGmIZEk1IUNpekZ
         2UCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759490333; x=1760095133;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SNBkS+Hm39wTU6+E0QoP///fT8wlA6nV1YT5ebANpjQ=;
        b=ie7NxpMsZ5yfxEX1lrjhgrvinPtNuFU3Jv6+uJ4UoHgRDKHe+3pXTxlheXzXvG9MTi
         RGokUXWKynYeWiRzAM1JokNVXUjm6z7IM2z9Js1Itm7rfgrtXpu1BHf51VrcEvCIIRs7
         xZVHbarC11omt+gmU2AMHNtr6DmBOaIxAQvke65ti/j8pVePB0Djc1Io0B0bDiFpfQLs
         UjtNjkAZjLg/MY+QwETCkA+2eUUChbz8+G43TvcS4LGNGhKxJopvcBlEeRwAGPu39NWU
         tZB4S634sd6R1CtvGSJtJq6/q+KsmqmJ1L3miWguiiNUfE2jMuJY4GgT0AVSvQsbaSW4
         ipFg==
X-Forwarded-Encrypted: i=1; AJvYcCUZW91fO0vvrgD7Z1mhyU+obl4OBlyBSYwxgrIPMKGNsFXo1ky3v8GTYkK+AAjFhm0LyIypR5xm7Q==@kvack.org
X-Gm-Message-State: AOJu0YwM3ddkXcyNSloxQTibTzMUFbyhEA+pC+/JL0cVzLo6Pm/J2Oaf
	lN1kGs1TGFiaZ0TFDxH2FkCHZHmBRrPTqSrIzebGWKld+wJX4zVZcQrF
X-Gm-Gg: ASbGncumeAL3fNta1Iz/TCi+d550LWlybkut30Dx3kKa3f1p+GVxvdDj1OiStTnY3oz
	hVKLWEBckXQH6w3x+uVjAinLypXFsMlCAMWQ6d1zAAc8jjD/joPxQruyahynyFeCzC943PhDrno
	Lkl6gv9ZHhfY8S6hx7UKlgN4/3bfT51Um3s//rtt/rNl3DvmzSc/GhX+RPXS+JFJQEGdqIYKcNR
	LqnmjfWdL8D5LuMajkZuq5ITK1GX7at2sSdqQ1AVGZsxdnWCTKKmBmLmQCB5ggHDBDCknMRaQX3
	mCg6f7AZzeQvQmTxa23kBqapL6ctv40utpFqZLhkDsfJtMJw5s0fiDZLSUgWVjwiYqQ/9DiigcF
	LfjdGDRyrqu2t70rfnoB1eSibDC1pE1fa7nQn6pnD9/Cu8Ume6K77dl6Cn15qhppSblKInIBrqy
	rYS6qfYeDXOTTFew8d3lVTu3nQZBNG6B60wiqn
X-Google-Smtp-Source: AGHT+IGlEts1uXX8hfnzNImW+xFZigVYA6diCbhcx8vs+L489uXPgFFo8L2wxrFd1Q8SGxzM/7FJ0w==
X-Received: by 2002:a05:6a21:6d86:b0:2f9:48ac:c8ed with SMTP id adf61e73a8af0-32b61dfb944mr3753683637.1.1759490332568;
        Fri, 03 Oct 2025 04:18:52 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:38c3:a5e9:d69a:7a4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-78b020537e0sm4696767b3a.56.2025.10.03.04.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 04:18:51 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: broonie@kernel.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com,
	Aishwarya.TCV@arm.com
Subject: Re: [PATCH v2] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
Date: Fri,  3 Oct 2025 16:48:44 +0530
Message-ID: <20251003111844.2784806-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E57921C0006
X-Stat-Signature: zhf8416bgyu1cjcde55et89rpuxaeyxr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759490333-962797
X-HE-Meta: U2FsdGVkX1+iBjSG7xl5EifKTr6F5HEwy22jFRxRfysNZRilfbNb0Iv7+ksFfWw/1FLFbnr4BYfUNgqerGmOy6KN6kHfBEs9RL3cXKqTt7ECT1z9pnHZqnw5foxsVN+YC8iXPC8YzDB5LLCUbj4BaqUMtlj54Mc7MhtnIC6IQDB5DkzjgY/9FSqHcQ2/Kak9yQnMSindBEAgKCzuIf/0a+4tIECdQj5w/D+ZZzkqsPty0Ratma3JafdsQXm5lB89wbtc+WJdfX/0mrrvJ7SFxw/POlXV6sI+dwBNtLjLmMVtmphM1OGygo6tfBR1H01EAvc3kWKHuhSqVNlnY0n6CkmCEvh7t4Z7LMLo+oaeji1wPKWQafFAxmurnS8PGnv7mSjv5L00R8ZvfxEgaOsjJBgEb+lI2OvLn5XhLxaZj97+UQJhysCtd3akGgxsy1m4VNn3jPrCiX4oaSU39/7abEdFVjU/T+fonOxa6ZrqCN0Azn3c3eGm63JDNr6+hERUO+j9m5pkJPauiYNhmyQQzIUT2lwnXSh+lxLXg22G4G5cWKz0GkB6akfA7zdAAfJdRDdMGvrADnoczkYFa9NUicqqi5yn2r799MaWJ63wriKPpeaUjnbICsRdccduXOZQpiK8mry6wExermYa4ksgJPPdIhIUrn6F7A3LuWTobf8K79mQJB4D1mfW/BsxdbfXLjIYpy5qc5ZrV8EULISC8IvHoG9wIwm9McksHoEzWnTDPqgUe7ZlS0owEph2cuLcFmuItsmB3MQVSIMmLEehbq5eawXUlzx14quK8edNzndCOCJP2t7RNONRoaCrj396/99k9lJsahtp3n6rDtZ+HDRPHdSRNqfu9eOG3REki2/qMCJ/P/rXzKydLF5YKOfMrqrcF91Usd4bQnuXyWks4MdFvmbQTvNDeDr3So5kLRU8SvDsg/zPRBNzGrG6JlnYGkKB7743f/fvFbgWT3f
 rYxx32X+
 4QlpeXeQtrZXqunTzFiy3h0+1wCYTB7yWoGlENWS4sLGnW3ZSLWtxexNvFZ432SeoCWn4AStIDs7KeEcG255yc5TA0d6J/uhO0PcIJNkJ29cpwtyZhPUV8Joa4kb3LzfPy54QrnowcxHbDBzxPZuAND9VlV/nn7BMfOuaaEe81mfGI6vlP7QKpPL2qqawS+NCrRZIOGOO2eUvKf7gwvdbI/avDVL2ixgfdgaHXBoJE5E0NWahkWztP/9CQMUXjCTO6fRjEV+j0Rf+yMqxpN5NCtnzhLrcxa0e4FN7rbWDwvZuyzcFW82AQ1YeJyNu2zE5teO2YaozrzCVO9MXSk41T0pUewUwbQriUXRpfxr62a739gBCzxoYJXOTUHE4gdOIkWRJaYWVpBkg3I01+CvRHverisV/sR0aT2XvhXgHBltyFcd6PVTlmt/sSS/3N+wHY8E6QZ/Gg8dGAIfpNrIv5TMOBZ5CWZOjD3AcNHkR7oBidd6YkD4snWNFAJAfKEcpGuS22/gAaCXtFftM26oYNhNKzbmjY2gl5IVRoWwpcLWpjyVx0ikEjlEfx+UZw0aeNUsNuGA6h+QZzBmaldmAYqEgJNK4+Kj3vcDkqaf9gcsTquEVexA+joUkFTYFisYuIpDc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Mark,

Thank you for the report and bisection. I see the hugetlbfs-madvise 
test is failing with unexpected free huge pages count.

I'm investigating why the VMAs skipped in my patch aren't getting 
their pages freed properly. I'll analyze the test code and work on 
a fix.

I'll follow up once I understand the root cause.

Deepanshu

