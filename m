Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D62F513ED
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 15:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ECE36B0098; Sat,  7 Mar 2026 10:07:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A0916B0099; Sat,  7 Mar 2026 10:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B01D6B009B; Sat,  7 Mar 2026 10:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6AAB86B0098
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 10:07:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 232631C1B4
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 15:07:31 +0000 (UTC)
X-FDA: 84519595902.09.5C388A4
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 41A3B8000C
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 15:07:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=aqY8Mv90;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf02.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772896049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZYBGv71PdycZq+aLFPH8zUzhJ8ZpxJ5TIDJbEFgp3fo=;
	b=Zufa+g7F8RgcdcqltNz5PozJWxXJcAORK8KCdAQfjQ5b9WJv6h9t8sPc2lHs2Tb+nfXfbC
	+pAHzU+DVhCAjxQywyl2/fod0+birORhUY2bfg4wAbFbFU6TViLnWyl3qgQBRivATU5b6n
	qHQsX+NkTvOPg8fAVGhDmJKevpnrv8k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=aqY8Mv90;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf02.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.174 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772896049; a=rsa-sha256;
	cv=none;
	b=nH2YqMMqOOsw6sCRtkKtdj623uBZIpJMRVz5eIGCGEeqkM0KlF3z4J1a6EkrQ3wQdW/qvm
	ANNoiCdb/Wee4DY2/gtUimNhUHbx1BMrZzDtUybwHYW5glsvSE/btBSLkhQpTBzGKoNlUG
	uW3Hte80SJuo3E34mfJD1wJhJM8tmYg=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c7382731edfso2425710a12.1
        for <linux-mm@kvack.org>; Sat, 07 Mar 2026 07:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1772896048; x=1773500848; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYBGv71PdycZq+aLFPH8zUzhJ8ZpxJ5TIDJbEFgp3fo=;
        b=aqY8Mv90Hlhll2hhRGom1IE5mdZIBU/CiwMsDyN7fBZDDXzDO3IlGX7kR59/FLsTDd
         E77fc5e0Z9ZwDof5ECJCR7TpPhON6WTUN7cRdABzUBBkKv1r4aMeb1kpZQUexIf62k7L
         XD6x3wOffG5lurQfk2KrkY4Vm54sCbSaKHJ8k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772896048; x=1773500848;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZYBGv71PdycZq+aLFPH8zUzhJ8ZpxJ5TIDJbEFgp3fo=;
        b=tUGHGqRDrQHlXX7LpHBn2t1EDw3dMCa/JfVCxcaPbE2NVmgL2aKiHO/BBJefN4Sf8s
         RVZhoi5mf2HoXUiABWgZa8nax36SbexqD/ZQRGHBlhGdKmibzR4oS0rhgbap8EXhqY2/
         WSTZ/lLoIR48SDQH5QHx/mnqCqW/c7gn8ONdha491TKoQmcQ4tjnsN2GZJwiaYe23XcF
         uZN6gjaZh/iaZ2ReVnPjVWqg8NxD6yqk+ON37JiiwflYQH8Hc4oWLIZ+3ql3+LzdbUg4
         7UWse03qruxSujiS/czsqQCSGdzVhCjGJcc5vbNqh5j25leaRKbxjA18qWau61sZKp/Z
         V/kg==
X-Forwarded-Encrypted: i=1; AJvYcCVCCoOf1YCwQVD5JipCQ04H2HPmj+wJxhZnP2vBANbvRTwDFWt2X/1Ho2C/RxJ7R9VGaAOakqMAbw==@kvack.org
X-Gm-Message-State: AOJu0Yx4/buWCCNtaVaO1j1hl9n8nTOgCHmI/lKbQONK5JnMz1ka8SCG
	dOIAZfQgBWTggxDFUsLFG8weR4NWYL2JzuVYNRJmVm5R/uhwceoIPfEJzgqVynANwEM=
X-Gm-Gg: ATEYQzzb+345B/K5k3jNwA25jG5Cbxb7/mw6PhVKO7l7NfGrjENkqV/5W9LcFuDnGhu
	8y836j+YqBFSFsqozx5ItqzIgjYNq//9TdgEo0vFDE19cBmY4nCFwrlncpFoIw/Kdb3c0ohN9q3
	WBTYUGWbDkLL6oVC/vacxROHku9eEp1l0P2lrh2ppe5MWMPlWKsWKp4beaxCH+gQzMRhaDZr/5F
	pBhnmnD42hhwJsNxu/LrnyCBJ3Y6JKCiWsqhbtuW4fpjIzSf4X9UnATJ7ROLcKW76fHmKenbDd0
	g99W13q2Qnfqk7/vvN3Rg93Ef6+ouX7wqtmo3NJtoD7O+2VRxNKOoECMl625H6pGejB0dyqNDj7
	eXCb+IrRrQn3IGLD1Bk62fmbdJHmpuPZ+RKNv1UvQBSTRM0FF1eIZ/KnOJZCt8xni+XpRJMmNYd
	xgyorSDTOOoZGuxstZdAM=
X-Received: by 2002:a05:6a21:4d05:b0:394:f972:43ca with SMTP id adf61e73a8af0-398590b611emr5336431637.54.1772896047874;
        Sat, 07 Mar 2026 07:07:27 -0800 (PST)
Received: from localhost ([149.28.151.93])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e183596sm4394555a12.27.2026.03.07.07.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 07:07:27 -0800 (PST)
Date: Sat, 7 Mar 2026 23:07:22 +0800
From: Chris Down <chris@chrisdown.name>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/huge_memory: Prevent huge zeropage refcount
 corruption in PMD move
Message-ID: <aaw_KkASxkpONUdU@chrisdown.name>
References: <aaBVz7eb6-VBCvaz@chrisdown.name>
 <842272d9-9e9c-498b-9b11-cbad25f526c9@lucifer.local>
 <1cece140-0602-4563-80b6-fc7ab608de2c@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1cece140-0602-4563-80b6-fc7ab608de2c@lucifer.local>
User-Agent: Mutt/2.2.15 (2b349c5e) (2025-10-02)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 41A3B8000C
X-Stat-Signature: 1k9646qhe6ouewpdq1xg8gjswafqdhiu
X-Rspam-User: 
X-HE-Tag: 1772896049-499837
X-HE-Meta: U2FsdGVkX1/a75wIeux7NUpnjbup0twYS7TY/4BuoEfTnE88pQ2E4O/6CP0pz4JSdKvxBNnOI4SM33bcheFdIsmpwDJ/KJEs+8jDY8bhV68oFq+nN3qXNp6VGKvsGx2UH03o/cyTL2FrRVtjage2mhJMtiPb/E4O0cYz0tPND+4LahEkLuKpczq3fi/oMlSUD7dt72H9r0Hq9N9DVWb3WwkooY/egHpAjwCckeDY6hL/mGjwcHeorVQgkyQEmemtXzWvuqB35uNfHj1+WGGmZ3Akz+94HZwq7Y9bGMrrHURRbUZ4ri2hWmU8LaI5D78QKrOc6H6aOZeobNU2grq2EGKISvVkf/0fiEMcgU3OLVRnlp9367CK7rXEVkGM5UJuH19ku5geu7vT2h2iC9qK7p1LCl/Ha20//jU8PkJF6t2WmwmhfDqSeZNDnb0gibZBx4oWUNdBMpi/td4KFHdxCQe6yGyNjL2N7+94q+9PFyL/zqTuebCikBueSHbXPr8ncw8orTmxJqN4zkRsH7L8oOrXcRs51WHQqR+QcR+15uqiGI9C6z1wWeiH6uGWUalRjx9w8Tnp2PoeQMrss0KhevcxaTRFMYDhdKaeHq9bHdxZWaFjxYrsQZyyOorT2RmA0Zsy7HZPHzK5QAHP/05cKAV0H0l1Cx1XWA8CdJrDmZx5PwCcgQyfR5Pm5G445AL+LigdKtvjwRIrbVZ5geL1WpF+kNDd0KxqQ0P223V8ertABxUZwlhwJ0g457ruaquThm5XDJVJCtEFvfWC0fQd3sDD4mxRM6shhE1she7PXT7NeqGjbbpmBNuhO8opKCxVq7vpwdOhOpEHqKD+8JHw0ohdGoPFnH3s4gjbQ0eMWQ7u0Kxf+hXpD5isX/BODCT9IWRms2LCR3AmZHYo9IHFymzbefjD3hZN/L5r83LOlsyUIXACx72dFOJKpQcGxpAnZGSe19NxUUIaV/2EM01
 m78xdoq9
 AkWzDs4w4lV5HJVI2mOkngnW4X9eeq8UqdSAZSAukoNpNkNIQXGuwWag+SNjMG53lXpj+HI4bpAFs1SzaTSS02MhYK1dM26b9H6MrwkGY1ieeZkSTWD/Fi/s0L7lbzoC+iTImNgyM7ba8ETF2l6XwfeAwxD2oJzblCXFtqzgpULU2oMeaKeZf47mfOyx87mJNBJBEZtobtnOOdwNvRgOHOShWKlvk9pS2Gp8XcFEYSfN2eycOJQQ2upIrBJxlF4ttYnH9MmI2b3nJSqwqNVNTn7WE4k22httc44QgTbx5zZuRWgm5BrNvKXpe1V5G3QVzDAzHlrcbe/3NGbwhg7xfHLopztmirDaBldlEHUZh8MkKAo7/xoz/QbB4ASEX829MCO6Z9brPuXtbQ3np7dZfm6CsSotnNeu7o3V51fyHFlaBIQ/25z1F6/8GRLheDSaim8gMG6sc9EKGdnT+ReqhHKVkl7cz7QnJXaG4Ue2ADdYLKpUoHfUTbmk2fgXTW9ZHpnzt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lorenzo Stoakes writes:
>TL;DR - To make life easier, I squashed the two patches and asked Andrew to take
>it with my R-b,T-b tags attached, hope that's ok with you Chris.

That's fine, thanks again for sorting this out.

