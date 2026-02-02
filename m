Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FEF8E7316F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 19:19:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52A076B0088; Mon,  2 Feb 2026 14:19:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD526B0089; Mon,  2 Feb 2026 14:19:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B91D6B008A; Mon,  2 Feb 2026 14:19:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3C46B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:19:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D51931B14AA
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:19:15 +0000 (UTC)
X-FDA: 84400479870.30.06279AE
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0C5054000A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 19:19:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y2+shljc;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770059954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asmdN+eKpioswtzM18Womc5lL+dXDrk6p42YTES7X6Y=;
	b=jg40ji2agWt099Zbvbaod+jtS1pkdieTIvGJrmiWc0FlucewQylybkqBGS/roZgtiCH79d
	mOMaGAd3Z5XGoYrdYVx7iHkrbYhf16THYQEO+Puy8qeqFXPQPdSvgmWAIdr+ZMOmO+Or/G
	02xnsj40tAxFTLo8FE7KZad4cPhFLIk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y2+shljc;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770059954; a=rsa-sha256;
	cv=none;
	b=kAyy4F8zI5V/TXfkT6yGGlImaq4TdMSCcezTl1O5YE7DF3kQWAhOy6XcDf4FS2a1STqR07
	5Ddlxksa7QfaEoLddryfN8RMx2OSJuo3i5hdc712bZhyZ65s+oefchQVpYLk0XSYSWKkrP
	1+g2nRdhNpstQHNA59HhjkOt8Tl0UMI=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-894774491deso61704486d6.2
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 11:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770059953; x=1770664753; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=asmdN+eKpioswtzM18Womc5lL+dXDrk6p42YTES7X6Y=;
        b=Y2+shljcUsVg9uoWQ+CSJpB6a5t//1bj5j/rVD1DccYX2CJp6aMBicTaE/6b3XKpDw
         dEmHObaY21+enAjsK/lPPlZCiM4dmJe1zePOoLiG5vnzgeAW6QM37H6gv+chI9fqeroe
         n51Xl5C6TgJZVW56AOqQcYRwdooF84TQk+DLV2C0baXXuZ31VESCxCKT6iwq+O9aXdSr
         iF6Wu6HgqkEkFsK/kYSAxjqpjKreC3pc7j0rBFaObtzTWa1tit9Dr1Tosh9aKx2L5fU1
         GjrR7y+z6qV9qr4VBQFkKPup/4GlOAiZvVuQmApr3NzRnCYrou9TPsbCy2VR64Ka/LIt
         PlLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770059953; x=1770664753;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=asmdN+eKpioswtzM18Womc5lL+dXDrk6p42YTES7X6Y=;
        b=HJhaTf6NJ/qZxrvEAP3UEi7oqp+2mMuXHCnjtNyxO3KnmTklkBElAQorANv7Uhd3XH
         Lz01wMQwko7RtUjogmO4S148xxjIvIQo0+RvgDkoj64uzEjdUTxQEG0XvizHuQ6QuZNZ
         KLfJ9Qi8n+iEoK7i+c+rGOQeqwKU3R3iQlTsXPWP/tCVU+kwzdoK2o3RY+M91H35pO3I
         lUojxwGFNberLutJ1RB6w/HIsCgYT6kdJbOPv67nE9tbrg/fic6/8GuKYG/9UlHBLPum
         w+VhrKa9r6zzIl48FcrIVmILBPLCLzlCzkM8qU+o7eahUlk0TOqZVCel6izp8WB+tr1d
         fweQ==
X-Gm-Message-State: AOJu0YyhRDm8YKEYICXd43yLi8XOLi5R3ngbrWydspxNJ5aA8oxS8pa+
	swP+nrB0uHaMlLHVcKVfIwpBnpcVJ9b0Yi7LPd5sIki/Socca7DoptykUw2/3nFRQ6c=
X-Gm-Gg: AZuq6aIH/9fDskt8I5tlArSApbsJPGRyiaAJ6UBe9VG9in+fbS8Hc/CKTxo+0HyvqlC
	tKPrVOaWqwFT08r39Hc5W4groGMGKK5IjLwtxxtyvyHBFNd/dPY052v3Qu999oiytpYYPCDcSK8
	E2aB92bYww7lGC36rxlc11k5uenBTYRNvfz/VzxLgiHX3YvpgNijY0BQhC4Srll+Yzkztf6Iajf
	WVMF6madd5n5u2pDWrvUBX+aEtLg7XVTAO/kgq0BEA47PFMi6YFuwcRJkupy9H2vMn9pU8UAvpz
	LERu+F4edJ1/B2I3y+iVuaD9GGARoTe9hJHWsgQVs4IGHrnwst/TM0m1jdCjtF8Kqtve/lgDcVa
	R17TDVIRn/QyVmJx3VUZBuTUfUdS2W1/iVZxDEYjw7fXqLE3Elif9ZZyQwvWge1jGcLW49P2PQr
	s9LdH/t+TK/Q+M0muG9kFRR0zE5s+jKBv72cKD3/j15dMmMuRGuCqdRZSLy/zM5k14+6MDCg==
X-Received: by 2002:a05:6214:1311:b0:87d:c7ab:e5d0 with SMTP id 6a1803df08f44-894ea096c06mr178827036d6.55.1770059953093;
        Mon, 02 Feb 2026 11:19:13 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d2889asm1253553485a.27.2026.02.02.11.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 11:19:12 -0800 (PST)
Date: Mon, 2 Feb 2026 14:19:10 -0500
From: Gregory Price <gourry@gourry.net>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com, willy@infradead.org,
	jack@suse.cz, terry.bowman@amd.com, john@jagalactic.com
Subject: Re: [PATCH 8/9] cxl/core: Add dax_kmem_region and sysram_region
 drivers
Message-ID: <aYD4roMbjyBkK9l5@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-9-gourry@gourry.net>
 <c1d7d137-b7c2-4713-8ca4-33b6bc2bea2b@amd.com>
 <aX0s4i5OqFhHkEUp@gourry-fedora-PF4VCD3F>
 <9652a424-6eb1-462f-8cbd-181af880f98b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9652a424-6eb1-462f-8cbd-181af880f98b@amd.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0C5054000A
X-Stat-Signature: aaqk1urr8c395684yfudsdroqtp3n7p7
X-Rspam-User: 
X-HE-Tag: 1770059953-985547
X-HE-Meta: U2FsdGVkX19KwLSQJDorIDJnm6IWOMS5t3cGeySny75CnW+adCBVglx6mHvxZpKeNY2kWFs5Usrfj1BNzNqyMdz/8+0LY09TH1XfCKe6qEO4Yz81Jvf28kGMVerdb41/6DhwYvDIrAbLGKCw2H8zVvH6jU1eAXOPKa98b5AldqNzxYM9JKHuCx3yqTn3EarTAUzq7vtQTwtbSp/8S2Ax8qsn1R4WWuWyYoipqBXw34pjmeAlScsvgJcLTMhuDVhJN9RrVDdg/d9Kj3Cj/674X2059Y/dRHyt/b1RRwzUwpUuhf7uxRSqQ8/ItwCK8pwdKP4gyvo9QPcWnrXCDY6LWvLHX73a1rwd61ohc3xPlShzvM3ta6PyU5h7y0HUw3e98qhV28sPvuui6XlkN/UaQ/FmjYUldik61vitznntzZUk2pnwlejIXGeRbBjonQkZk4A2gA/x2sUowTaQYOtTDehnjW6t7a7ybgDe2KEpY7G8xgOKbzZomvopl4QChBc7q/un19UDMg2dJ27+bN2/Qh7VQI84NGWibFgc7KUkyqt1yty8TKt2kvhLjZgmHHX7beY2ak6vzBMSCs5d7cTVHSC+ZyxZGfV50LOjqgzW98/c5BxhU9u3dwgy96uDZIGFc47sEuDdfzamnvuFc6IJpiC10Ht2IRqx4yDUw25DFcPOEH/9aB9SPs4l/uoIqTKT5NgNgoIV5wdhq3u/4D1sFv1khK7SfZBzym2Jq4tFl10LS/0lqYYf8MX7f+1P9kGzDNGnZFo1lhawc/RVhvAyJ0slkdklng0NzBWrydW8RfS7AIpFy4twFXLh4amOgWscgIXnoM8+oaKAilV6wIqHNcR904AUXcAuBYjdREmm95oqZzddaoWtFsclSvwfl0BQzc83VV5WMJNgBbF645lpxI7TwJs2Eh7juc6T3GGtC8+4tQioW8waeSxcm9SkvWxLEubNN1ktCyA0cRslt6J
 6LMraiPi
 AIR1BXz6ABTWpVIlA57IgduzwIw25pZy8TCiT5QY6qOs0GoyRFxIa1zf1csD0Mc8Zbz1vtI4GZ66bHHxTQWkEbBip/XpvkRg/eUYjILlduxiAE1py41jH8YSfMCe9+200Yd+rpb0dg0OgHLzge0XAAy/fGFYJ5uifReZr+mZqbymilUEfjjEakpexAWZKUoBv4yh80lgxhMRTurqjRSTzkzdkUHHPAuXZv33HNGyytci+fTCGD2+hnO89KFcgcZiZF9Bm10xpFM9EG45vWgjmFORhpMdNTvQe6Qd8AOakDboGxPNg80UaFsb5ICw5tLIvy4s63sSRdAdFhq0WtzO5cipOLQIMsjgJPZx2KzjAHFc1I1ltG8Ci0iOung==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 11:02:37AM -0600, Cheatham, Benjamin wrote:
> Sorry if this is a stupid question, but what stops auto regions from binding to the
> sysram/dax region drivers? They all bind to region devices, so I assume there's something
> keeping them from binding before the core region driver gets a chance.
> 

I just grok'd the implications of this question.

I *think* the answer is "probe order" - which is bad.

I need to think about this a bit more and get a more definitive answer.

~Gregory

