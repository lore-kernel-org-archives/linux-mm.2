Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A912606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=v1Twurfr
Received: by kanga.kvack.org (Postfix)
	id 3C8F46B05C2; Mon, 23 Nov 2026 12:37:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A0CE6B05C3; Mon, 23 Nov 2026 12:37:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 269166B05C4; Mon, 23 Nov 2026 12:37:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1AE76B05C2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:37:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 69B351A0992
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:37:07 +0000 (UTC)
X-FDA: 85467089694.24.CF762A1
Received: from mail-dy2-f8.google.com (mail-dy2-f8.google.com [74.125.229.8])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8BFAB20008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:37:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=v1Twurfr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795455425;
	b=jjpHPXzK9UkCuIrXBkR2EG9M35V/+zjAkX/7eMIv74Myou8tZW1/MIaXEIUhxHpqN/8/mx
	Z9zdGFuG3q0AdOVK78OO00y0coL6wwYh9ZG0bh85+JeJK1mXzTiOIZvpN/Ma8b1/NA4kx0
	HBjWsSSGU1sBYSWnlHIubLCtmGC9v1I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795455425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fHKbWfCOzgC2/lN2DgsPiazl39CRCdoG04N2832eeB8=;
	b=R3mjUyc2uEqGJGNE9gIiHy/55JSFd5Som9N9u6nXYzscCuH/GS8XPPjuf0QjngpZSjmr8G
	frG8cEWWtxzMzLWrwWB5XQEVk+StRAXy1Kdo0T1h0zi0uKBo+LLjt9iuXXSgrrjrTFwtUC
	8/tbpWD8IzUlrFxyAr5ToUOJ5kaXS6g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=v1Twurfr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.8 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
Received: by mail-dy2-f8.google.com with SMTP id 5a478bee46e88-36a6ce64b95so1375967eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795455424; x=1796060224; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fHKbWfCOzgC2/lN2DgsPiazl39CRCdoG04N2832eeB8=;
        b=v1TwurfrI5EckuZN/7sQSDcCM7tcY8zHZaC3CraKEhBK7HvpzFSjQFIvaGyMMkfoB/
         RgYZ5CxedMlkTyYXnl/WC9nQ3qqiXcZEeHbXVQNveb35t0QUFhygRhlbO8EU6O3hbR7C
         4gK7424n/QQSmOdw3m6mzLgEjmbmlv0xMBuWaB1KwrXiYmJ8L5GU1FH6eShnGf1D0QIx
         PZioTqg7+i0bj8l3P0p+CzHwGbY2COL/96yc8t4vhDEcm98pcRFpopqLtEXfLRmDwMx1
         vtML2Mg4ebSp8n9jRzOOHPzuhrCBWfRrhZfuIYvIdtUmwT1ARA+TrXo/tcgxVfF1WbmK
         t1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795455424; x=1796060224;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fHKbWfCOzgC2/lN2DgsPiazl39CRCdoG04N2832eeB8=;
        b=swSgankztBtJmfESSa1CrL3VygXklZD7mOpwlWoNxnAOM5cuDJ+bp43xMzpPHJWVWN
         F2CqO9kgxbEL/9wjzOtpRn0xnu37KV3MsUIgjy8Rt+KYf1Fnsl6IHM9iqXnndMDjjUDQ
         XCTj2DZ74Z6QDfqDrZtd+Kn+EakvTHIMwHVpWUg3rEDM5Jl8tR+Mve9pwU8zTGN7JlIa
         jh9/uRC9b1FYY/kZ4ATx0EgDGst2V2mgKwz9NPb8tLqQol7OgGA0wZtiKskwrNVCzgcY
         aP5ILwMKzvxruaszRcKBv7xTX4NQe8M7V/WLQ37yIyZgd7ZyIlfZEjXUbENdkFGngxqy
         L4PQ==
X-Forwarded-Encrypted: i=1; AL+hErFaQCwAYB5LmZXt4Xmg9GK+u5F9oeUj0eI9HKXQOV5jpS21HLR2wGtaFYbBwQNNCO5pmFfRWdMF7Q==@kvack.org
X-Gm-Message-State: APuU4Z/aKLM0ec0syreF4yVpkaCBfCNcBW07CRM1KGfdJ7Ira5yVuVKR
	NNnYCwsVRia4qC9igvp7OxArhswePnsxJxgoCcQlFce1R5HXVE9bkAW4
X-Gm-Gg: AZFdTZdQThUqm0bEfYbuvtzOfTeNDaqjTM8uwTUM6lSIFM3V1aiAzun8N9XcC45EvaL
	s6Js9iX6in52Rn+hxwG1g8ZWtiIYHxT46g6YPQYHqlu9PEfFit9ZPMBSF8cuknXmZI+s+Df/c/W
	1T2/bChuLjQ4UTEexSDCvzUAkC3XoubCizBWsM0CtvfPO7e8Xp14fE6Kfzq3tkYsh4PssaEPo1D
	dOqm50jxnP6ftbA8+c37/k3bzB3n5x99frumPNWL7gA3JhJ+qnLANKjaJDXCEopLNHZTUKLshbY
	O9tF1KJ9S1UK/a6KOGsvTqt356vYh66keV1cCF934pibsX5jdtcDnqbET1SBC0Mz4iw+3C5VkKl
	BlkNAWwiy9LAncDIK8aRxPNANOtgUMhHbPZhipp1TTchSo001tn8NUWN77yXJZ7P320JE+lGHvm
	rMhxy7qBr1v3XuyjT+TuO/Uq8KQOGndU7QfyApQEh6BSFqz8kIylksr3D2YgQbIsqiriKtcUZ91
	sBnoW507x5wSz5m6FEiOWltNhKxiK3CdcQu0oVAC6A/6bKS/Ef6spEfebyYOVQ5paUSLsEeXvqk
	NsallwR+UA4Vp93oEDdpvsrOq0q36x3xLCmk3puAT79XS4Mhq5+7McsDVRiDvn8yZfRlhentxSn
	XiU1OSJWtjhag5dPEmboF1VYkbPdQEgG2wbuwMTRRipaeedc5xPhyOM9hN4QNuQ==
X-Received: by 2002:a05:7301:d81b:b0:386:b6f9:6c52 with SMTP id 5a478bee46e88-386b6f97178mr2279321eec.13.1795455424320;
        Mon, 23 Nov 2026 09:37:04 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38567abb870sm31532302eec.25.2026.11.23.09.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:37:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 13/27] mm/damon/core: introduce damon_report_exist()
From: Aveline Noir <jm5905938@gmail.com>
Date: Tue, 24 Nov 2026 03:49:24 +1100
Message-Id: <179545256490.4.14288363666764598017.b4-reply@b4>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 Lian Wang <lianux.mm@gmail.com>, linux-mm@kvack.org
In-Reply-To: <20261121210013.130397-14-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
 <20261121210013.130397-14-sj@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 8BFAB20008
X-Stat-Signature: c3syxh38yxftb843wd1qwbwsk1464ixs
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795455425-28300
X-HE-Meta: U2FsdGVkX18VcUnJCBRVblbJYwDGZmE3fngnEBQ/GaFlR/TdMAAsKZ869YU4MncfAGoQzfApsBFC0hAoWMAJDJ5IdMuF8T6YpScDEcnq2Iv/c8MjrG0sXbc5taSfY0rSsm5oYSVdCr2TUtHKGgqaaslzKjoBY1nLvyd0uEKGuDEZ3gt3w/UFlpgsYuuzFtAKKPBbSeclSWE1UYmCPNAMfwVpATeFpZPUw3kOz2v6C2JfvZTl10CDg59HyxDGdRemWMoKTLjktVImOm17EV9THrtdYRDUy8qDcBKeFhBAREMsgRMp2hg8EoOtZSYIjqWUJDvJTpManGxSpUHRgsJe7nDfSgcE0QZcr6b9AQViHtvp5fMhYX/F1RGBvEMEqrCGGyiEId+IvJgRqHBlDK1yGFjSDI3qcAqjPdoQKVv6yMP3rwqbTwMSZAuSeOcBZj4IyAVco+VDnT1Bu7oC6YkS8il0S6PxkUFnmJensDw89fh/vGJox77JvHTdu518O8a+m4VOvWZ8MnlGMmjg1xbcFNP0t7s9qvVv0osjPD+JUUFqJkUTrAlrf/vp7MJOiE8ggmFbqund7tTHjwGbiHdgza2u4a1oXUGFoKJAQB6ABNXg2sXBw9pCd1bKRf1zD9BwNWZLrKkXVgfw9yWJjqOtWM2u2GBzh+lFt2VefzHjamcltaL5Bn38jGys+wJEbCv4lRqHs3+2uWwj5O8hn4MduOEjJS4aqhctbvGVp8oAnK6EBrJl8307jIBiBV8WCIQzTqyHlVM7edFqkATqayVkIPbJHDcH7PL60+put3sa743+yMv6xN9s99rkIyckTCJ9Ro62oYhV0Q8Tb2KNSnPMUDpf5d5mkARpOod7gbDhvl92WMsnGBVZ+402BaXeBh0bcdKxUYK9W+XVZgzJ1sXQ6CKgX96qmkCoB0fGjEMVS7B+NnBp9wXBN39g2whzsimFjWJNb3cix0eJI4UWJEw
 xw2jEQVH
 1grwPlV8+GRlLQSToeiyhA71n0/5H/7b7HVncG9y+qRt5iRchNwDQfYyiuNnH8OG/tlOe7pHMilfffFAbV7RtdlHXHcp2AOLw65HnpdcbxRN0BW7FTYIpGRPw0xMaR4HpY/a25Dsb3gDQA9qfeF4yKnIM/yTtWcxQ9Jmu+bqgy3HGvnHi4GyYphEUMbbPNzvM/khiLwYcYCmQl90vwPNy3RqRD5VWIp4sP4QkueNUEX5bJ5d/nZ2Gctdc5IJ9es1tOTjYYz/QBtMUZV9KLeM9J+JeTyrrwongFQSiFlfB5mVDCTekWWUJA6tdpMT/Y31vtlM0HZApGktwWMhHKYT88awf87USPzZ0Vqco4UGa1IlWk0xMjhXJLl0dHUiXlivHRlpUr0MQPHEeAM91EaWHALQY41wbBbgs8gEUXMlguSu/V5slTwehgNDuNWv3wVR/NwPaOObzeldryvLpDx+2SAfPbRWWUSQ0HlaTqoa1d1cj2UmETCZjC2gRdjE6CdxfkhzXsIIIVbW1UWHMAkcSLHjPu1YcK0oZkYEmIS6sQzMM4fSINd0OoAd5YbvzUGEhXpXq4pijSEM/fLDWbW8FLZCCPaW48GMn1Fi+DYNKPfGPao5+V0nMxROIqmrx/StvFlzvtmhaHHSCfEYQ9hLjdKTyyS9d4Ywm4z/71pM7EmmXomS8dZ/bwF6R+TcCoR+PyGkjBYrbNlWfifglrwzDJoZDj0cx1zTTFuojaPfbvPlJ1o8I7Gixr++oi++aW59FtIEVbu5/sQDsyEXzCs1d/stA9WawjrfeweUW9qhjMaEz6ko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Sat, 21 Nov 2026 12:59:57 -0800 SJ Park wrote:

> Implement and expose a new DAMON API function for searching data
> attribute reports from the report queue.  The purpose is to let
> operation sets use it for supporting the REPORT_MADE type probe filters.

LGTM, thanks.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

