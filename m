Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516C8606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 23:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=i5HBvmPb
Received: by kanga.kvack.org (Postfix)
	id 0D0B86B00EF; Sun, 22 Nov 2026 18:47:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081776B05B0; Sun, 22 Nov 2026 18:47:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1FE6B05B1; Sun, 22 Nov 2026 18:47:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B9A676B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:47:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 023081A0716
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:47:00 +0000 (UTC)
X-FDA: 85464393042.20.61FEB50
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3399016000D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:46:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i5HBvmPb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of evanfengff@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=evanfengff@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795391219;
	b=CcFdf6SGzoan0xjdW6VpDaJnAYcIOuJfsFpr4Wl/g5kgW/d49uSkSGydsUzn3zsB+j2Mnt
	koUp4qSdvaywRLb24+KG6kdThzKAL/iwAz6qbPE53uhD+2f4I1aWQWvfu9rKuine6Xk0AQ
	IbjGytnvv/cbDlT4IglfTeAn8t5/fnE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795391219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SMUhQZLvGIWMEWzTIwqLJCO1x/4SePRxnBTKofe0h8=;
	b=3igFO9vK2RJ1voLAnAQSeQ7iI04LNqCxQrrN85gn3NaxwSQOM29rzz/DBTaVb8gyDSF37i
	ycUjadFeyn12c5BIQvBhsvVDCrBhQ3Pqm9J63jB6ze1aAdaQzoFF/a2bjE3IDNLsUfDAzO
	HrGMoJROiZuRMO19QVoPX441KdjfPRg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=i5HBvmPb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of evanfengff@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=evanfengff@gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2f0414c1062so13711915ad.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795391218; x=1795996018; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5SMUhQZLvGIWMEWzTIwqLJCO1x/4SePRxnBTKofe0h8=;
        b=i5HBvmPbzriqFAv5rkNufNl9GgALLFUoAjSD459T43AmEUQPp4E4yKXipcV3MWjiYM
         boZAVDY3XbWE35C9b+MeELqe4jRp2jjXdsoWQKOQnsy+3bGYGiHo0jceOqAsENbwVUqf
         6gRX4UL1B1SN9IVbEQ9o/N1HKfyxSOMHEcjXlMMiUFN/hPpmzNsNQPYfdVflqkVN8Yw8
         CNCAJCTuTInw9voYuwhGvYyWns3eycGQnZ7mb9E5nGOtw/218n5kpUUQGwqtC4Dtl8GH
         +1iiPns1OHvIJs1pvUAp/ejiXyPKYrS5ja7uF9fR39sdABvjah8blb/fvv6jN7nG2HHt
         m7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795391218; x=1795996018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5SMUhQZLvGIWMEWzTIwqLJCO1x/4SePRxnBTKofe0h8=;
        b=udkklSu6ZWeWPfB/XbbBng01xzE/sv9KE+5IFTqFoqOgOmJWP2slsXL0SW8sWs2/MF
         bUj2+dpUTQg+agcnkAM2RmJODDlpY5hH/T0ktvv+ZAsd8DwvjwlQApNozvLHglLtFSv3
         n8uRdCkOohPAzoKAEIbtv4BdfK2fiQ9nNGo287uCqfIXnnTJcvZMTX9jiADhWEugd6RC
         Vus6AenCg9Z8T15IDR9Ptp1mYkCokRn6GAz5ISTvNDzLluc34RCLjYOYHTpJj20MacnN
         6a5HUznYi60j5936RAHpMUzN6afuFmd6PWyF85E2yvW4cWiRsQB4j06v+VjmT2VRn9RE
         RkJQ==
X-Forwarded-Encrypted: i=1; AL+hErHrCc1w/a/lWKmQ48Wte8euwPz4pQjrsVRRu/O+NpqOpIe5H9LprLkRS/rFeybRjdMTfakPIkiWJw==@kvack.org
X-Gm-Message-State: APuU4Z+Vm3YUGz45s5N85lpEAsN/3hPiwmHjt9ZNlmrf+JQuJD+dlVKz
	ANSkmPrp1GaagJkI3hyT+iCueFo/YMV0F4zrtgE6P5YfU20aAw/G4a6enfs0Jj8s
X-Gm-Gg: AZFdTZe072gKiKf2099d/nF+el6e3gEgXwTDu12f7pKILUVElBeDPV69LBih4X8IriI
	4YsXr3lQG+4Ituj2I2dOgENe8JvsEkoakkeoFhBhLMFb+iEf0qjoFHzwbuo8i0is0H/Kjq1kePO
	kCj5Gt1z/tegj5pTbqUX47kEO/49lURBrldV+cEnx0wDddaanj0F0wKHbfGajgKza3OAtW6OxTl
	KQUgyjpxpcvwPjlTVeyzTtzMK+mIieW6G7M9DGtDBneU+Syj1NjDAX/uMtKc49ssrXyMp2+zE86
	soToUcjHFfWXx4Rms/yLjYbpMt4+GBMxcbaMXKEmFMzKIM4Mu6wlhBQ7Yak8CFBGmNvM/U5GNFw
	Vqohaa8wSzmJ45D3Zepd6eCSAgwV/S6mUzwEwxHYfej9MmzIPSxb/vxXa3ylJHWwpYwSBCfI0Kz
	A2Geoz+55HircxD80Sif+1BIEovtc3ypeNTAku01OXmqMqARDwosTS5eVCVSJc/wWso/6jzYMAT
	34NB3rh9sZWbkjJIIHSJeg71yDMuS4af2ybb/tanXfR5gfGBWxx+sadRyaJIXFDs3EXCYJlEvlS
	jPb50t5+dArKk74uaV/z9L1rFT6Gu/cu5aWnaNpXfXJ06AzcI0sqUON4QywP1PwQFT1SUsf/0ee
	51+6LUxMZ8fOjuZqyOf0irXtC106RX1AnlFydB8hdXgfj/aXxSAHVzda9YqAEZE10WAbHXICDb0
	Qy
X-Received: by 2002:a17:90b:4b05:b0:3a0:516d:9f88 with SMTP id 98e67ed59e1d1-3b41c911c9emr8676680a91.26.1795391217624;
        Sun, 22 Nov 2026 15:46:57 -0800 (PST)
Received: from localhost.localdomain (180.36.101.34.bc.googleusercontent.com. [34.101.36.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad47091sm15052556a91.10.2026.11.22.15.46.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 22 Nov 2026 15:46:57 -0800 (PST)
From: Yifan Feng <evanfengff@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/damon/core: do not overwrite wmarks.activated in damos_commit()
Date: Sun, 22 Nov 2026 15:46:32 -0800
Message-Id: <20261122234633.89529-1-evanfengff@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261122012222.148520-1-sj@kernel.org>
References: <20261122012222.148520-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3399016000D
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 8nig8mutqu1xp75hewpzzo4d55pcthga
X-HE-Tag: 1795391218-653589
X-HE-Meta: U2FsdGVkX19VM9gGWixMzA4HzAQ7vfq9YfihCpwqLeM9q9TbJ+aWZ7r0uSpMo6TP0UpsI8EdVf81OqLsStvB8TpLwd9T1OyddFu+EBoMFUB/d7Ynxjhaaft4Z83ivCv36LtvCYVA5bWjc6oymnxa43NMB8jfRHCam9mF3gwKPvW3JSMK7kVdUCBDwDswrxoM4B7D2d7fFakkFc6xBZuNP5REGKrzTGjxRx640K8U3SNUNMjrFUsnJ6V6sSmx/rX1DeesumVjLGyljkpun4zyM56fGNakNx6HuYhXgcbC1xJXJJ2l+z5h3eYKT4FTesBxZOLsSas08OMc1niQBkbyN+xkpRu9KydoLOjbXpltHbgr6bXb4LrRdSsbraCoOTZ215Kuc+vPVSmVhCQKG4QBdMFzZAgvYbHXRlqixCsNttVeEz614/kRhggzEmeQlH815YVQpKkD9OPgSoIWeTI6gssccP3gv7fvFgWPEd3qJ25Buda8NbcM71MGV/nBjtZoECvANd7IsdZaXel7HplrrBNRhlxHu0hBPGSZDX9xLAZ0nfCuhm294Db5ykPuxIvC1yL2MBrwkFCsgdOnukhaglD8Ny37qAdoqHGdWczSB9pXQ8rVJrJJ+vVplNPlUAnhqUQcUsgn4bWmdggBQBLu2AAeo2KQjHGpWUaLPLIJi9IvzbEvKzbECySmFQ4eGvtKVtAUzMCJb9bnfeOXf59sucxmLITXnSwUTY+zExQzmiRg6psC2EODXJEb4SSDeM3EVOWmNs+srip25PW1Ri3OZxe1/b//98c31jVr9GnzRscRceGTngQWA2MtjsYC4MsjZftMwFoH+WM4CLtYfJ5vMcd3EaafuzIOpRbh7d6PFtUNWHRGShVO4CWCv/LJ19SWkf/dx/iTRPXu5u54ax9ucZp5JK0nxFVE39MKdMcMOuy2cZBXlW3AlC4dgWAE2sBli2loItgCfwuC4Gl5QV8
 UT8gmwel
 m+L1CRfRZI6suKXOqYYYhGbQR/IIN14XCZo6+vE8NiI2ipwoO6fod+w10mZ1lUTUwT5pJpBxwU051KoKCaJO7UvhKxMX40D/1Tr5/T6FkbQthvxz9CM9XAFZV1aDmWvsdJYWZQtlr+tVEXc6JJjUmz7l2Qt1TF75QF8reMnErqemab7sV31khHiH9XoVUwHLHfH2dM3k5DrvzX7aMu/VrnSVgORS2mJfR8MWhOZdeE3s+QsKQqwyrnc/9p1rezMyS9sEPIBawq3zvnPk1dYZreScouqFEmsko3dg5WNEDjbjauCtTW7w0RmCvIpa9MyQ3KokmLLj+zyFIVNR9EyBNqpax8CSxHvnzXzFc7+eD7no5gG4h9ZpUFIPVsu+p0r9gyJBhwQezoWaNcUyEf8qGZtpFB9e9viP4OfFBa3RitKsbXm6KWYHKbSqtYeyWaWZwGcumbA6seSMpeEVAd6TjRI/oIXN7qXEfBYAqH436BagyjED5LnIjckDwAaHj8okcXUgtHpc+iloZH++jrVIMvO8yPSAlcVBY7hTIo+6HBDzffmphoIcJTD/kjbDIjr4xmGuaaAPMnnoF5y0ugkB58wYj1RLOUePvmmgKnX/5drpF4Gt1kOChuQcRk6vssxXVIT89ExGaXe+hoSfwLtCw+6sWIL6dDgQYXZXNZHUUUwjbrzY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 17:22:22 -0800 SJ Park <sj@kernel.org> wrote:

[...]
> > Do not restore
> > it for DAMOS_WMARK_NONE, because nothing sets it again in that case and
> > the scheme would stay off.
>
> Is this really necessary?  If not, I'd prefer restoring it always for
> simplicity.

Thanks for the quick review.

I think it is needed.  With DAMOS_WMARK_NONE, damos_wmark_wait_us()
returns 0 before it touches 'activated'.  So if the scheme is
deactivated when the metric is changed to none, nothing activates it
again.

I tried restoring it always.  I deactivated a scheme by the watermarks
(free memory rate above high), then set the metric to none and
committed.  After that update_schemes_tried_regions never returned on
my test kernel (it does not have the damos_walk() fix yet).  With the
check, the scheme is applied again after the commit.

Thanks,
Yifan

