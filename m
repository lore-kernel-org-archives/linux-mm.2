Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 524D1C44501
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 08:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BD5F6B0098; Thu,  9 Jul 2026 04:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195136B0099; Thu,  9 Jul 2026 04:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010276B009B; Thu,  9 Jul 2026 04:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C92996B0098
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 04:48:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55A88A03C5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:48:25 +0000 (UTC)
X-FDA: 84968611770.10.5D3734A
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7C894100004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 08:48:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mXcQd1jW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783586903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iBarDBcTr9hyYznUl9ohBDfmkAbosBiFwOCPIS/fFTo=;
	b=WlhXMpYtRWI4d00nY3ph8dkwBCXRGIykHg+PE4hOHc+Ku2+zPa09C0aszaLoAlNwolSq6i
	8yKuG/HVcLDwwbQnIpX/t5pHdrkXfv7ZdjaHCOVC0aqVmxKCb7XnEGKc8QVvazzxyqzUGr
	w2SHvAQXn//chqDBcwsFgfalikySQHg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mXcQd1jW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of zhanghongru06@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783586903;
	b=WrBi0s1J0+QtF/lHtzy6Tpoz9lY5ScnSThMViXVpxeLbVRi+9/kzOY7S0WE4jqTYnGrXBO
	7idj/YsUX4hvvPjdykAlMhFd6nOl0BrriRfHcuXtJL0J0tRSN2GaQKJld/7GZ48LDzNquT
	fQgT9DcGKTk8uqtEBoFgtethsQsDYf0=
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-3810f0aba07so1005968a91.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 01:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783586902; x=1784191702; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iBarDBcTr9hyYznUl9ohBDfmkAbosBiFwOCPIS/fFTo=;
        b=mXcQd1jW95QL7IJ5e/27REti29DljHt0k6GKQu/Bvvf9fKEQXtzWlj8UOxUXxhFTkw
         YdgMaRjoge3nx62WP571ByOQVhWsGMaXj0hj5z6D3+SQt4jPkW/3O2WIDS2im8vSEVLR
         wqLF74ox+ihkbfOjLL9+crZ6/UmmwBrW8S7PHVXhBtpj+GGmChuFkbUJSvOCv6FaZvmc
         6NN5UZOH70wIbiOja6i7AWIuVk1rSeO7fUtucwlZbokTlMlSnwO+oRim9DwygOkjARsq
         FtIaI+ilmMY+AKW+1LkTP5BAyaK7sXf2AVYjtgfJQSguzVD2V8T7xk6xp6Oz69AONxMk
         Y6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783586902; x=1784191702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iBarDBcTr9hyYznUl9ohBDfmkAbosBiFwOCPIS/fFTo=;
        b=dVmMMER84pIn2qQhv+COUM3+rMifTplVnPbahRpiXSjrEjSNEdk8xpHndEDxswUN/J
         hALypyyPdBLTwbdFppZOXSVssjHbk/ArdOoeVKv0J06VEq5WM39EjAJAIe5zRN62VmuL
         Eax2ec6d+cT8TZeJSqcM8oVFcCsTuAiaPoI7p6mytT5tBfwY8Zol7weVY+ojh4yCpQes
         t+oxUzLHYAct5Kz2O7X5BncESWb1Nk09IldUFOyYAgrk/PWScufLL5b2fivdt4Ad/UXc
         DnYvRosGZtoNac83X2BcL3jFEev9koToMGKnvqrjZ8GkvLuEa/XyvIdFyRLQtXqZsO1i
         gENw==
X-Forwarded-Encrypted: i=1; AHgh+RrLRr18+JP3S73TzsazeNs32T6VPRsPh0mU6eAqf1jVJsrgpqOwgVp+GGZJrwdoDC+YDkp7hBVWog==@kvack.org
X-Gm-Message-State: AOJu0YwUODOLBZnfzNPydyp+bYFNPz6x3yFzieYblagd0grEyCXN+wVB
	k5+OE4Tkb/JA1pg5+jfq+kDz3EEmuI+rzi1kte47DouT+CH0TL8yfXwU
X-Gm-Gg: AfdE7clifS20nqPutqAtGsrXmfEj0QGlgy/DHHJcBbv1CoX5vlgq5+JG2xJ6XEBmBlT
	lXUzvMhRLQMdlQoClTX06yYEirebKHbkLHcAnLep8MKl0dWn6Wn/1pP7N0lcpCEvGqNxXMvmJKg
	ms4jP2Kz2EeDJ27TBRMK0cYLnjZH0lEfJrv/t1VRnifxZWqejTbhEDPegvRnxxf67jjKsEey4/B
	QsOI1veJOBUkb9Xb4DAGs0b4ok9Na6OMgnD35un+zEYzkej2NoPNOJgB1J70jk8OmeeGhJZDwbq
	Z7sFo5jLPLRg3G4KIOCIZOALw43tcDNmjhZvmIOhmqwBI3fpgfu/7jcLkmZF19938YJ0StKAo4K
	2pf6VKv8Fv1rvu3MndoAhQh9D0MWoqBTJVDyFiCEFCYBY42ORaqs603MOynGV/dlTZmJVnCNU5Q
	MZH1tHAZtzd4uFbiq729tE9DGbPc0fHEN5AbVXGhQ=
X-Received: by 2002:a17:90b:54cd:b0:37f:133a:3e01 with SMTP id 98e67ed59e1d1-38941101dddmr6501170a91.4.1783586902302;
        Thu, 09 Jul 2026 01:48:22 -0700 (PDT)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:e059:8c15:4306:9f2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a52238e12sm832409a91.0.2026.07.09.01.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 01:48:21 -0700 (PDT)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: david@kernel.org,
	ljs@kernel.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	surenb@google.com,
	vbabka@kernel.org,
	willy@infradead.org,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com
Subject: Re: [RFC PATCH v3] mm: retry page faults under per-VMA lock when mmap_lock is not required
Date: Thu,  9 Jul 2026 16:47:52 +0800
Message-ID: <20260709084752.147379-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ak0Xl6q52exX9sBH@lucifer>
References: <ak0Xl6q52exX9sBH@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7C894100004
X-Stat-Signature: j7yegbec9r4mni5k63a1oub6g39gfhdc
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783586903-291962
X-HE-Meta: U2FsdGVkX1/PlJH1uHs8knssbXlr+612knKQ7WyQZp5sszhXTwQizd+Lb3fhaZT65eq44qeVfzbBGw86IjMrnd79SGIPEE9LaIpcsuM6kZhEe0VDwY5zogs1VsKlaqCGquYwHOH4W7TwclarLgdLwvXh3Kpk/JHhiDGI3vZMG/RgBqNY6ETt5KN983LoZg4TIZw2rSpQPuLzmzU8Dw7iGjaa90E3RhFfSFZWQNhz5He6REem7RUcJNddo0BfqxRrfbBwoQkerewpQ52Dhhm/9jEt1ivhCshqoFKula/2S7ImPHY7aHgMh7Hx5libwWywLe4cD3oVUm9RIZoA2VgzpglUOC1BgmLUDovU/uOc+zg9N+NlwMTOGoBRWAf29hpEN0i6QE+3jWy2YtGj8Hz9+RCWH5dJAiXbWFAymue1YqRPp5i7WFTS3AmsGFmUcQvLrxVU6dAq5xCLoLIFJnTpjmvgXB2fCOgnkKK5aM/rm8FY4ctcNdJkSxxkcNJD9L49J0g8bCwpCBAUzrTF5gZPcq0KnoveQmySUEziCaVIbhZMiv91q0W2MS9kc0LV1fzdYsTuTyMDOkMTTAWl80VaLKxf2/vgrLDrKpcTwOx2gqzw9hBqQtoSHgTdOo9mIaOTphvw+y1zh0Wdq9pdzYd9VQ/zRuheVPKVoEnMF9MI55R4wYxRKEoPCu72k1pCJP0jxDm30Ljq3WAmSG6Fh9VQ3bbAEEGtHxVch8GZtu2eURKXcpGKV01bH1hI9tpZz+oESzllKAaSKlGrUue1JFWxXwz1W8X5SQ5x0G6jpK4rSU9geL0758K2fg/yQCLUqQf0twnLZBfsPbgSIaFYw5L5M11H8p0m/jAvxqxc2681ESDLVqoUo4WBAjrsqs21vA4wx6PHDpl8uyZICsM9XjdLuBvb5bIvEwm51plr6ljKQew/zjuIOnQH3wkP0h7wh1pX4vy0oM6wiEurkBZ9mva
 GkRn1qaG
 lQVWG+J9gonVfadGbY5fOrFvJbjhe0ywL5hgk8niihcSCU05nhzfLBPr8A34M1erQc9FtmgaCcw6/IXgGWQpmwCR2k0MZKUAHhO/6m0GhEzU9G0i3i2pFRCNVyEL3t3I3OBG56KjvAu81PDWLnqGXDgm80BOZUAgEnvDSP5sKeAp7xA0HT6bhwT4T/+fpci2lcsPgsApIO+jNIliIe+DLoco17HCKP587l5NsiSlky/Cv6mGN8JOmSst1XWAmSxedVRydXAaaHA+cySIglxyTTqeB1N1+6IOM/IFCqSw6cdHLorwzXQ7z101mFSZXGUD1dNtZb6q3Sa3dGf2w49kWwyPLWW9F0YsQKK2GM8SBCmD0blCUKwHH/L6rlMlptXN4O2i/lAAmcXDE5SuJ8s928kVoWYCo4kguvvpR0OF2YRPjrRm7NLMtPeKWroYLPQv0chGnkwX0uJ64Q9jd02sCXtlOA5HQ+sDIfUXT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David, Lorenzo,=0D
=0D
Thanks a lot for the detailed review.=0D
=0D
Yes, Barry and I discussed this offline, and I am taking over the series fr=
om=0D
this version, with his agreement.=0D
=0D
I agree that VM_FAULT_RETRY_HARD is a poor name. I will rename it to=0D
something that makes the mmap_lock requirement explicit, and document the=0D
semantics more clearly, including how it relates to VM_FAULT_RETRY.=0D
=0D
Lorenzo, I agree that the unbounded VMA-lock retry needs to be addressed. I=
=0D
will look into ways to bound or otherwise avoid unbounded retries under the=
=0D
VMA lock, and benchmark the candidate approaches.=0D
=0D
I will also look into deduplicating the arch fault-handler changes by addin=
g=0D
common helpers, so the arch code does not have to open-code this logic.=0D
=0D
For the retry sites, I will audit all sites that return VM_FAULT_RETRY and=
=0D
document the reasoning in the next version. In particular, I will look clos=
ely=0D
at the userfaultfd released path, do_huge_pmd_device_private(), and the=0D
FAULT_FLAG_RETRY_NOWAIT case, and update the stale comments where needed.=0D
=0D
I will also fix the subject and make sure the next respin includes the full=
=0D
maintainer/reviewer list reported by get_maintainer.pl.=0D
=0D
Thanks,=0D
Hongru=0D

