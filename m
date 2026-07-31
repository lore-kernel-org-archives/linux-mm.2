Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 644E0C55174
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1836B00A9; Fri, 31 Jul 2026 16:32:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482666B00AB; Fri, 31 Jul 2026 16:32:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BEDD6B00AD; Fri, 31 Jul 2026 16:32:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 174386B00A9
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:32:13 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C589A088C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:32:12 +0000 (UTC)
X-FDA: 85050218904.11.45881F0
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3906B1C0009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:32:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=T04RxQUV;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785529930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dS/ec/wCqlrAfu657jloZlNicm+FYMAt/H6xV35TRnQ=;
	b=ObHhBCesggxI6LUIQ7oQbTBTbjCofJANuEZfjPn5iKV7fKosDe2u7NzGIi6rdiklImq1zY
	OB3yesaUc5bptzqjhoVKVhnuemfSamlJoGoPIRGCNugdBsr6mHoNrQX5ijaQOpgDkRds0M
	7DGjMNJXte4p0Fe1H0Z0KdlGRUTuWHQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=T04RxQUV;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.42 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785529930;
	b=8F0ZXtZGtE1ZUxzySZ75ilkEtUca9VihT7jZFIFvkkU9RzVpDPe5cEngknKcB4Kfh2my/9
	m8VeN4RlRcGBLnNYYxNUyyDxkvxSE3vMBjWJikNK5x1VU3RI+1H8As1NJBrLjRPTtRZWvq
	D3pu/PTOAHLA9TU38nhvOxO9Oir1oXo=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8ef1dc934d1so9107106d6.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785529929; x=1786134729; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dS/ec/wCqlrAfu657jloZlNicm+FYMAt/H6xV35TRnQ=;
        b=T04RxQUVpXQHOh6lT3E4RxuBmWzgD9sQ/2rMtNRVZp2wIqdZvCVjl0932QL+7tKc6L
         tJ+5Z5lRuKozO1M86Zu95qymvvKG7XxSYfAkMGKLBxCCjWpQ4kD7tuvTtAPzwlvn8dKo
         eMyAVK9GCwA0mMdnkmDfX7RNISDtn86hMF2veDWhDzMvnzmwbztr9s21IMHwluFwwCEt
         wbCGG3yMgquu5HoQQE/9b0J6JwpjPPSGaUMmuyFjKBvuiwiJF8Cyl0wzAYB7z4IXWX+3
         8arHZctajU8f2AhoBNB8GYWYCLloyVxofsjPcFZIq/detEBsT7f2uvKs31XNMUHisROw
         FGHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785529929; x=1786134729;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dS/ec/wCqlrAfu657jloZlNicm+FYMAt/H6xV35TRnQ=;
        b=eKF6d+k7TnRCzvKi2GGV81X9Jk8FhBxez+p8ek7HzKdFVd7UrZuZ3XFBnuYB5flXUM
         8hpjGonAZGe8DsWbxP1sgylSVFlOwLSWcePrSX7H1YKbrxJdyJKiDQPwsSw9KFLmT6OM
         mNNOVighhHrIzTd4Q6lgmI5jyIPJI69p8wsBqx44qtF68PSH46t4nSOR+dmccunU5TN+
         q+m4VJY2Qt4vhXoHCRXvYemNoXCf39GTtmnaxZq+GykeXPaKeccOUc6GXEmcIMo0k6x+
         JhVGqpnKUETj0NxQ2tJ3korpVPkRd6/ZdvHoG4vGhyCV3h5XLPCJrDWARB/9kQyjlFch
         4A0g==
X-Forwarded-Encrypted: i=1; AHgh+RqB+nlw9IpV29i27p+WBuq3l4YuYuyILod3IsMgQj3oZVXTP6Mh4NS5ComX6p12/U+TvifXWFHuAQ==@kvack.org
X-Gm-Message-State: AOJu0YxS+w5vTZ47XnGCgyJ0Si8P4vqVPT5Ev9djvFFTi7AIqfIw74H1
	s70qLKysa54Y4DZxnvf+Tmgn99lNpJUldJdyT9VcocDoURQdiZ81fTkcpSdeDQUPaJM=
X-Gm-Gg: AR+sD11E7GUt1yo6LPxjD7IbIZTxX4hI8GgFRajcxWgBpoO2sfHNGPazNEjegW15QGl
	2KLItPmIbf11pXUlrx0ynZKrcVKOVwndcxjT8sAWMcYHATwZZtspB6epv8dfCJDi3vJmMlDKTpL
	RcT9DP0xWB4HJZw/xPiyZE4g4a3LfaLNvjrP/q/ZQkI1nMNvBPtCp+c/Z+jaYN61EgHKypiZQx8
	vd5O/BFLlA/8shlxWNsUb9v0IEBDk55ZgYeKc6dj2yHBwAT3bHky4AI6yTazxF6J3eohDa4baT7
	FASw4F9uH6U75/4Zd2ikqdrL5WzgnCJnbXWTZUSW2tThY+7wHTEovhSHdHvgjQAaiRCMpQ4ykCy
	UMqddeb/Ke8PTsAvDWAlRyBX0UY+t/CWlK/F08tPIuX2S5ZR5tv2W7lpaM9SPrW8z7tkapMzPyO
	554B4Lgyn+VKeECuguuEC97LGyTARAVmm3Y8PF9EpFqvyz9HsJjE7vhqDrlFw=
X-Received: by 2002:a05:6214:2aab:b0:8f1:74b0:a4ec with SMTP id 6a1803df08f44-9084983b312mr21772296d6.4.1785529929298;
        Fri, 31 Jul 2026 13:32:09 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435b6adesm17977316d6.24.2026.07.31.13.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 13:32:08 -0700 (PDT)
Date: Fri, 31 Jul 2026 16:32:07 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: zswap: drop list_lru param from zswap_lru_add() and
 _del()
Message-ID: <am0GR1Xrwr0e1W0Z@cmpxchg.org>
References: <20260731053721.1412304-1-wfelipe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731053721.1412304-1-wfelipe@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3906B1C0009
X-Rspamd-Server: rspam01
X-Stat-Signature: uxyybrwm8qtwwafe778899r7nbqqymgx
X-HE-Tag: 1785529930-629247
X-HE-Meta: U2FsdGVkX18khuJ3c29DoYnEV7ydwQdzaVBvtFy3bkDS8KlpJtnR07c7o3mG1wv3nilTRarw+c+AcjIKAPtodkWURFId+Fpy6p5kIHAUPuh7gELtrQZl9jsjj44/v8JE8pTsRBv+hPiMCuATJhp9cd2vQlYjoUqsqeIB4KVGS0CSKfavp/QDh2vetp1KIcVk+V2f0HgSlCttS5anr4xjfb2myZjspNyqYiZvxExcniEV1z9KC1toQiLZeU14SVplex1HKoPnSa5BIRFo0LjGsDhFtJSAt8eut2GqrcKBHAjnSTwDQFFLCn7kynEiFJ+T31A82MA7jIVopZ9MZBMu4KyvUQ5Okk9Hxf1fj5u2Xt3lBicUaCWveKh13AYwyThlVE7zcK6Kem0SZ1nCySlOAk7IjPZGv9BuJaRcAKIRmOaaDE1N7kKMsQgLi+65Zb7LycmN1sUgR5TKhmSB+5vwJwMSUDyPfp1luCy+hlak8gAWwM4BuU5hIQ83EMPQl1H6UNS7FjlGK+PFUekGn8XwwrE0U1f1S5hgSF8Mn6pITdo3VgPuU29bfn0jBATm92QkxAP1n0y2ZjCqzElTpRaZ2xt38dDbCQ7Un1diz6H9H9naPhEgX0IUUmt5qonClr5sajaBZw0/hZDHHBqkoImfduy5W+Ds6FGdEbqLc5QvxD1N+PqNOEY8KRA8+pfNPvNa6ONmnNSAW69iHnKa2XD05kSjf30f0kuVHbpIp+9ke2a8vqPBnMnm8qUMMlHpLjzJbe0QufXuFYiiVzNnpznYnxScjyDNMs0WlTZTtp8BlC2Tnv/HincAN6+pb/Dd0QkKLZmRAmoBQc+B0dQkoE59Inkg4d9Ffq/fAFwjbzzTmJz/oA2BhwhsRNCKeBFiXAr9HKxLZe8FrMfYRsXm9kYIIKpWWmURCl4YTHtjW8g6VFx76OgvsVzjCFiIWTx1dJpgKbdRsoDgATCfCF7aA97
 HBwM6HL3
 F+vOoivXbwHzow8Tduq26xYFt+ihfmE3pN6Sc1ue/1GEuT+VSU7f7USmVchPplH9hXOLOxuIdhkJdYuBliYgyHTMKTwB4lJauL2VmSX0F/BTmLoktdXoHJd/caU6TJm6T0LUMkU1jv/A4qtoZx2s9bFNfaWwfLPv9tWiqVCd/QT9Kqc1LGxQ1O3E56xtNsIWloHgq1wndNXY7smSHHfqmqQBsn97PYut5IXCcz5d2yhGwPoezu7c5GgjU4qJLuhQ8o33ycSieJlLKy5LFTNpCWIXz56pnX9qy8DWK2ARCqtVsVIhdH0QrCkXmuQQuB6sYoxEZZklSE7jKliTLJVIqExBvcGLj+bRhh7gLd9LsqdaKjN2poQ87rliQ7SPzZxOTuK9wBsdIhKK5S72EVSLktIIHocbyG82Y7KgYQw8scog9K/U9KNZxXPYcyXwvmoOExpysiXCAX1yMt8uxoVjGZBvEj36ZWC5rgRRPjbg1nHK3Ca5+BscstfxBGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 05:37:06AM +0000, Wilson Felipe Pereira wrote:
> Since zswap_lru_add() and zswap_lru_del() are only called with the global
> zswap_list_lru, remove the redundant list_lru argument and use
> zswap_list_lru directly.
> 
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

