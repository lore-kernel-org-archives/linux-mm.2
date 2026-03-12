Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03429FED2F6
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 09:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDDE96B0088; Thu, 12 Mar 2026 05:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BBC6B0089; Thu, 12 Mar 2026 05:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97BB6B008A; Thu, 12 Mar 2026 05:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA1F56B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 05:27:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 665BEBC13F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:27:39 +0000 (UTC)
X-FDA: 84536883438.21.6314AD7
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8C8B040008
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:27:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="O0tbNw/P";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.221.67 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773307657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZfNeSw16Al5vHXHOXwMWBWY5/F4YlBQrdPAfQKuxW0=;
	b=sZ7AgluPa9tPi60SIIEHDEg+CmKWC+40Lg1YmTq7i6v4zzex6+EeBTox7HdZV5eUqej/mY
	6pYdQtJ9bCpz3xaALkfhPKZv5PeoHm4ca1ZcQ8YMbBUKF+d5K+3/V/BVMylCW90L0v3xcf
	03YSfsOQZiri2kpdi9LOsixczNhR3JM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773307657; a=rsa-sha256;
	cv=none;
	b=HsIQUxrqmbSXvPG3OvNCy4DQMO+hWMriQmpgW1XkvabwL+UJP3+o5bk8nZ3D+UqnKs2hjN
	6mz7/COpvK8fV0oR4j+HcHoNm9ExAeOGsUAp4fcStM9nknH+yHRvnJC/L2TxEwMS7cHX1j
	NJATgVKOC59J5hHpp/zs+mSuTklc30g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="O0tbNw/P";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of wangqing7171@gmail.com designates 209.85.221.67 as permitted sender) smtp.mailfrom=wangqing7171@gmail.com
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-439b78b638eso855709f8f.2
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773307656; x=1773912456; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UZfNeSw16Al5vHXHOXwMWBWY5/F4YlBQrdPAfQKuxW0=;
        b=O0tbNw/PARVuMflk7Ve46nAEkl0WOibMfFTCtAM8vcAwYLUUQhTPoI9wiAqCrHrayR
         1UZb78rvt+ksJzY8XIThY3tJfmiNcHgRccctethyCDtrsP5wjSP9MZFOeakqAPdtpzuh
         StwG2YQDf0EvuyWLbly+pOUn53v3eYO9LWysVzf7S+DgpjGb4vh1V+wnadM57NUL4uEu
         nOUFPUVhP24SZGh+Z4fes9JDesY/Lscn5gIP6GvpfAq31R3YnanNrFMjTUNO3LU9fQ5+
         ou5Cl0VFuCO9n1b7zn6we5QCzda9jYKgHVDTGfSwCjpPVtqhFVcmwXbH0uGZiJuEUyFQ
         2IGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773307656; x=1773912456;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UZfNeSw16Al5vHXHOXwMWBWY5/F4YlBQrdPAfQKuxW0=;
        b=V8Zy595b5Lj4NXFgU3vWmKI7QkOmwBoFy0qQhkXfx0vS92xlZZZXJt5Up1GO38j0kB
         ry0Kg1XiD3U/EzSZ9lAQo+0V3HI46JtZOgLrsMi8bmoav9ulkEDWlkXkffE/C1wZhRUD
         FD2uJvfiAdXY102zsIoqeXYvasTBD8gUJDN0dGSCmSu/qUSus9k4xDpPNDOtxkhrUpTZ
         R/uRntf7tiVf0eplXKbwh+6JnZOttd0YtpjRoY+ILWaFGhl3y6Qgi9jvbozy9bzcbwDN
         n1ZJ9kXPrGeOJP1x7cF+Hf17x2n9nVJwSBWXMolw7afRy5pgw47QfhQJoe9Wf38g7+5u
         eCgw==
X-Forwarded-Encrypted: i=1; AJvYcCWol415saF/JcF1EsWUx4BfxEYuAnxqfUyeCVzlxOiDxXgB7wqGyUhLztEgNka+7bIDHbqf6E/cvQ==@kvack.org
X-Gm-Message-State: AOJu0Yw5LKHIoNf924gi89a1LKujXwJOdE4+e5s8ALAYtbLZdV5UmmbV
	RMwHEk1U37/V9106QtdQlNN+u91ntSSoV6KSLyG3dDYjZgRvUwKNE/UM
X-Gm-Gg: ATEYQzyQ9BWmpym8rluQLnJxv8JsOatsUfkg7p7/hqVwYjigge/lY3rYeE+xYO2A0D6
	SGVjeOwIpOmpUNMBbnI1kNSp0jCsrWYado9UpjaHp+AQFYtksjFf4otsFW6/8fpI+Dzr5GddtF+
	6VmGp9er9jackxEfYDMIT4wnYBeDgX7lwyoLSw4FDN+Zx7YmF/bICCRPhJ7UNPM/nm9lnUDqF4s
	A+SGLsXHerrG5REU0VeTVDpa1kCqzC+3pz4y4wXqr7JpO/J6uwlzgYq1Eize3cD6r0Qkbg1+QAz
	t92azb5zTFKyKxnO1xB1juu4ViDWsvnbQalQq4T0WUV8rpSUI0kLSmdMCI2djMV39HP9b20MXm5
	PqFsw8INrq1IVVm0/bhPePJgtTib2sDe1XTjyLk+Iqmgh6cCayUJn9HSg3TihoawHZ/Cn3Hkmrs
	vHo8QNrbIN3+0vidZvK0rBgVd1z7aCJP+YrtdKAFJ3cQzdFx/8GQ==
X-Received: by 2002:a5d:5d85:0:b0:439:b60a:b400 with SMTP id ffacd0b85a97d-439f822a739mr10111934f8f.31.1773307655640;
        Thu, 12 Mar 2026 02:27:35 -0700 (PDT)
Received: from lima-ubuntu.hz.ali.com ([47.246.98.213])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe1a76e5sm6301780f8f.12.2026.03.12.02.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 02:27:35 -0700 (PDT)
From: Qing Wang <wangqing7171@gmail.com>
To: vbabka@kernel.org
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	hao.li@linux.dev,
	harry.yoo@oracle.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	wangqing7171@gmail.com
Subject: Re: [PATCH] slab: remove alloc_full_sheaf()
Date: Thu, 12 Mar 2026 17:27:25 +0800
Message-Id: <20260312092725.776677-1-wangqing7171@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <bda340f2-1d49-4ff3-bfae-e3065607e918@kernel.org>
References: <bda340f2-1d49-4ff3-bfae-e3065607e918@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8C8B040008
X-Stat-Signature: xkxj7s5n41ucscriiet8kxskufr5sfz7
X-Rspam-User: 
X-HE-Tag: 1773307657-913120
X-HE-Meta: U2FsdGVkX1+9Ca6BOI1+88YvhrIvUTiAljjgrHFwJIjxhF3tYsvpRwuHqv9DdPS9VtOEnz/20gbNNKJ2DhLg5Aav5LPDxefLDLqSJk24xAJk6wKnYDhUDuRRNqKWl2tiz+iL/6SdUHKdUqLoZCjdzr1HOd/xyKzmianFgogx5MgmMqD5kOLQRLFc/jBLE04DITMY8nvRO1OYy2d9xze4NFmNSGW5+ZBe+IpbJe/my6citbaieZUpC1g71WcW9FwiZg/Bn56hR/PCbRrHEvlpxfjS6VIRhYp0HYp8iAHF4KtFVOxvKVSMNgcvgj7m+t/cnO8d/hxEgNkhFQY2HSAd5osATh1Pzd+ne77Zlegw+3MB7TvfTqoFaK/mmr6pdgvMzAaop6z7zCisqMWtrnMPNMSCXO15v8R+s/6yYjYMgML612uiTaK4mQaMTKHhS0nF6sGImcE1TEfc/yGUSIXOefVIEqWiA84LWBFepVfoN0L7GwmgDWsYTQfw0qZyT2UlCpiAQqYLngQW0y95uvKLwi87+JRT390St9SjGDCYRiiswOpDMTGJhsXF9Gd67XbVMGyDREXdy+OIBkZO3WB8FAcQfOPXi16KfjlBENT6Nm6SVHzFTygi6GBvJWXfcfYmmN4KEdARk0xkYJuu4UWz3xS9sloXw0JgMitEpwIrJChnIwthwzH4IE9y4SwM3xgstnaa7ejTeCGjEthNQdH+L3TheWThUIotB6QayaTYn9+QS6TYhyYgd7VklyCDl70wQla3wD7bhULSi6eROS/v8RotjoFmBnYtV3BmjRDTt9Q+uo/aYr1sip5T3xOQIA7JHQn6AVC4ZZOU6ooqMXpbQS5BfTqbKHGQOyRyAA98msr/46POvccNDC2qk5nM9elesVgr9GRRtwtFBjlTue43AeCEtpoENIN/P3gUDJAyJr0rQDTF0DrSCxfs/bYPEGBakgxiY40Av7qapuveAip
 6sv0Al+L
 Jiy175AyTa64bQ3FvRMmpS2pU1jPrdDzZTu9vbNoqDjx1xXZzpO5/TFEiR9n450uAMD442iyF09ZdLHxHYxn6rqQd3KqzdFjPNV17afXadUHfIjjDutC5IXtPSP5c50HB+Drk0KKeRmPOhyN7X7Ryde6KPpd4u+6xk6X4kxFzpoXUKzW787K+4qm85tdVm8HIvJpTOQxGyEri3No4sd3CnbWMyON5v4oMYLJfbpZ944l0uTbSvX0o/NCMEvl07jXxYLTMzwA3B5Wg9Jk3e7ZlXIYY5tqttpOYDxiNSG82wgfrOA57ukB1gqsh49zgflXjZiivXy8WQetfYBv5fxNhdqIYvXnTs/2HgmnzgwUIgB4QzehMdzh/FBsABW3leDRyRGv/Xg53nKevttGMCaqNQvaKuvkKQSqbaM1jv2X5ftZ+BYQbTqruIcZYTXPrQj2A4HO1cMdemAHVxGzpIEwwsh8omTPAFMySqYZDKim4f9CUI/rNyRmaK9jGorLz+f9SHdehbBkWRDrymllCWkI03Jdo2RncQBRgSxg/j2VwXiyan5Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 at 17:10, vbabka@kernel.org wrote:
> Exactly, it's only for humans reading the code to make it explicit. And if
> someone tries to make a change that will start using empty, it will oops
> immediately instead of something more subtle.

Indeed, thanks for your explaination.

--
Cheers,
Qing

