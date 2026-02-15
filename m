Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DCBE63F08
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 19:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72E46B0005; Sun, 15 Feb 2026 14:42:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A7E6B009D; Sun, 15 Feb 2026 14:42:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C776B009F; Sun, 15 Feb 2026 14:42:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 994526B0005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 14:42:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E4F91B4EE7
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:25:59 +0000 (UTC)
X-FDA: 84447520038.22.B2D6EF3
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3675380008
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:25:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HcCK9SE5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771179957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RoRxoyUYawYz0SvC4ZTIT9GVYnxJ51Bx8qMLynZ7mkY=;
	b=H7BfUt8mlIeUGdM10Bdg58meHkgvhL09EsIMlDQ1EMvsQU9qzujGFNY8WKHlZzZ11yxI+L
	67G+tULP+H5XsAWKqcHENiV7msa5nMt5EAQlJ+CThdDd11p8UWr7cB4LAvFjx5yIZGcmK4
	bVN1ZgOpLTMOQ5EJEVz6XFfUuAiq5kI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771179957; a=rsa-sha256;
	cv=none;
	b=ZMp2uSdntB97BdigptwgHB3skYp5ocTn2Xd8qEjuGCRjtERw1sQNDiNITPRvJ7ew02N//N
	hPz6FCx8GJtcWN6mnS0cZ9vpajdf2xqC6B0leyu8tXGDbeVVQqKw8T6Cmh7hEGPT45LBe4
	4lonxREImvNACxu2X04jjOjwnAfijgc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HcCK9SE5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ad32708177so661215ad.1
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 10:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771179956; x=1771784756; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RoRxoyUYawYz0SvC4ZTIT9GVYnxJ51Bx8qMLynZ7mkY=;
        b=HcCK9SE58rsESsJyYeOf1qs3zTTxQTrUIvOy6xU4KtML9eLcvhwMtKQ/es6oHj0VdC
         wpjyH/mZsuXIuYVwfSOS4Uo+PYxCdyvlORIBEVCFt7sOE+qOaRsVJYo5f3RglcR3lUyN
         RjoN9rdXh1lOH4UIGjUAUYBpzBj3w4D0imP1hSwT5aSnmz+xLDihz2BqG6jKHwu/xZM3
         CcJuyo37/g74feB8Z90brBbbLtEmaJIIPVMUle5yYrlLqo898uiw1+6JlphZWq6pi+i/
         LiRGlQzjxDB3RAF8tK71uT5GlDu5gGTrz9n27mWUvTKCFE42PfxjmegpCjoIm0Jtk7xo
         qJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771179956; x=1771784756;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RoRxoyUYawYz0SvC4ZTIT9GVYnxJ51Bx8qMLynZ7mkY=;
        b=JUAudJKn9bJsUhbeM8hrmfG+AxkNAB/izqyf+tMMkUyhSLQSuXEI9/lH+4xkdpPhfO
         MY8BqGVPyYfv6Yb9vrICL92OgCuNekNAVy5YA/fBDwXTWTFXubZk0+vbgR3gEQ6glo97
         PNK14ZV5dk1NXkAxFFoRXydNcOYjKkdElvt4WpVpDCIZlgKoED1kshhd9bMudKLAbwP5
         Jsd6sFqUHQzMjWWPpZkMjF9gJQMJAe8b6eHtSvgYrx8p+FmsUy/6E1A4U2qgCGwjPk2/
         GIpjGAipbVTNPP2asJ3/DqUJiCWukOuTHQn26/XLGy1/5CXV4nqerCvQh0YwktTzxUn7
         AQCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpOKkgCljzQVBRK5/tsnFVGhg9bQUwMXPOVTu3FPNvY8m1WP7UT4BmrHjj83mQx0ZrbPptRiAcMA==@kvack.org
X-Gm-Message-State: AOJu0YyciQRcnjpysUx/CGUzQJQSxNdSunO36bE0PUMX9YudOd9YHT8g
	U4YVht6fFZbbUlCitTVzyNJf8+iC6x/GYJJM19a+plFH6qlHFUBbJ3Tb
X-Gm-Gg: AZuq6aLUO5SBLzbPBZy7Wna763ddef2SFgmma0omVuNO7OnCPjKUj4xkTGm3ULu7A9L
	zIg4M8k0h46yIFg2rK0Uuhcg0tTiGrQiZ7XNJJmNAege/psw6gxzWMKbmYbhWC0ad8vsc6kolTJ
	5N2fbdvpu9OXB7iWug9bMa4kPOlicoZ3yPi1ckhklXIFRJG17BwJVK8VfbqVxkiNYEGE7HUANMW
	grxVf5lE/3Xf2/7B7bKYdTmjiBrdrbcvCXgt+tuT1Thd2vJG7P+NRmRiDhXe7o38WhMw3OQf6KI
	LkNU+3WmmpLglTp1c58UbeUkR200RlMNJOiLVLMvTk9fAkUYpXQgg7T6p7yeAgVXOFnscgMBl7v
	SPN7KgCy60Gi3iEG9nNXaDV3fshB1iPGL+JWnby088UyNBNX68X3KwxWnksPmnFnrpO45d0d5Pm
	1lSQmCzlzp8TMnDjzgtqbyOs8mbJfha09CljcLzOuKLrj48UTZS8wDPbTdFA4=
X-Received: by 2002:a17:903:3bad:b0:2a1:35df:2513 with SMTP id d9443c01a7336-2ab505555efmr82707105ad.17.1771179955980;
        Sun, 15 Feb 2026 10:25:55 -0800 (PST)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35662f6bbe9sm17255584a91.12.2026.02.15.10.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Feb 2026 10:25:54 -0800 (PST)
Date: Mon, 16 Feb 2026 02:25:48 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kasong@tencent.com, 
	Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Carsten Grohmann <carstengrohmann@gmx.de>, linux-kernel@vger.kernel.org, 
	"open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] mm, swap: speed up hibernation allocation and
 writeout
Message-ID: <aZIMvN41isdR0JGK@KASONG-MC4>
References: <20260215-hibernate-perf-v2-0-cf28c75b04b7@tencent.com>
 <20260215-hibernate-perf-v2-1-cf28c75b04b7@tencent.com>
 <20260215090236.b546ef526b9bb6315f7884b8@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260215090236.b546ef526b9bb6315f7884b8@linux-foundation.org>
X-Rspamd-Queue-Id: 3675380008
X-Stat-Signature: nwuu7zyfnyihkfftajqs7n6hfc5h3gc1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771179957-895836
X-HE-Meta: U2FsdGVkX19hviKlwjPYECnIdlL7gdc7U6E1PkhVwNAWXLxbkWAJxs3qAD4fmdTFGeoDv/XrHNxoQ4cbVDPjMT1fqs7b2uKSDu2Mglrmm89rWC0v/IB9i9RPE46DPe5V+ZRTwcLDCOBQgsMxE8JWt8Hhc75hgzku/DyC/8yml/k9KGcApXzhQyE5W5ArZBo1PnGIewU6QTR/rj/2VlojlSgUiqehSpJRLasC7aRk6jg9/0kftudSqlvzJNmcCOLH/A3JWRJEyUNfXDCNCfe+7nUGkj02TegUQT65T3EaiqGzwAyWMYCzlmodCQbNOfZTjJc2aerSIwzp8bU7oMqricIFbnC04ie2DjZO53SgpCOi+pzESmKG1jj0DBWYHRToFWs5tTAjnkt+WsVrkMUNdIB4OzjYld1gkPjMYwP3CQWMSdLKPT+K6kDTItM+k1FM8+utnizqpxvl60F0sXFnf2vEHxa6vAjjYb2gRGmOYkqunn3eXj1vplZ+oUPoohyahdTCwjPfLhBb3ztwG8ZQQdewb7HyAA14TidOKAxPYNqknMVdbtd43BLGk3Vr3FBAqwnoJtV2ufzT4abpRe4XcX6T4dZ70GBCu2JNvCgHeT8B4oooJpCIiUeeitKNYBSTCwpjkM6ut5vx0rWaxeabYySwPFEvWQDX612yO7lq3jdwdN6LItihZra8R8CzUe2GALzct9+UztXqt2XQNIGYcQb3WtY0AkQHLVnH+qXUL5BfMTOZVoJlu8D8dkHxLqFpcwqNwkknt10mLuCQtn1WUlmt4LfX/xanWDnxY0QoPkOjGmEsQdnz7K2IfWgmJ/Fp0VEutghLHUhNAx2oj9+JjKyp+8jBj588sbG9ifpvfteRrhyRH1JsOP3YFtsozFgm8gykWoT9e8vzSGA78xHGgyU4LQPjDbR1oFC2M4go+KcjeH2c+Ohd9OJC/GEJTExK/aWLMWBXlOn7Gc8mzT8
 kvnuhuNe
 1dEKRFZyn4Ia5ggY6Cqm6+StC9hIffI7dSK4AnVVV8rrr3s3MwXTOvtGzywP0RfPUsLQ3nhJuLH8xARYuEFJP465dgaf4ULlS+ck8YOCNghfNh/EJxHAsWA5KIK4bBwyjfPYWp8odXFRqVesDIX9hilnlICt+Et9+5L8OeaYx8FhsGRaU5LmT1zV5iyOH/UHyT2QhuiKbD0qnFkJ7U5jbRW2jmEygbKj1ZWCghJWcUAL0JkyE1Thd4vdGMUNFH4ka0qZ5SteeW2WEDt44Q0SKCYjuEzn+ExLZSiql2RbIWBA6kEVVgOwujvuNH3JEyZLWY5NJEQ3g/0ybnQjIzDmIblM87h1S+x51ihTGdFmIu7ird7RzFFEDTPiS5h8yA9gmmvu8zmdTnHxyA2yxZIXCtQWlmGuwqAHytLvyRwxx8pDkSB9vgEXbwV1Ye0ee1s3PwkZkFAxQ0BPE+dM6dPx3g51t2SwFJ5/F3Wm1xEhJ5D9NDm4HWCOBg98QfgUx+Xuhp/XI2HqfSalMudiipwksnwogVliIOWIVVWe52KrAt2Cm1UU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 15, 2026 at 09:02:36AM +0800, Andrew Morton wrote:
> On Sun, 15 Feb 2026 19:15:05 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:
> 
> > Since commit 0ff67f990bd4 ("mm, swap: remove swap slot cache"),
> > hibernation has been using the swap slot slow allocation path for
> > simplification, which turns out might cause regression for some
> > devices because the allocator now rotates clusters too often, leading to
> > slower allocation and more random distribution of data.
> > 
> > Fast allocation is not complex, so implement hibernation support as
> > well.
> > 
> > And reduce the indent of the code too, while at it. It doesn't have to
> > check the device flag, as the allocator will also check the device flag
> > and refuse to allocate if the device is not writable.
> > 
> > Test result with Samsung SSD 830 Series (SATA II, 3.0 Gbps) shows the
> > performance is several times better [1]:
> > 6.19:               324 seconds
> > After this series:  35 seconds
> 
> 10x is a lot, so I think we should offer this to -stable kernels.
> 
> If you agree, could you please prepare a more backportable fix? 
> Something minimal, separated from the [2/2] cleanup and without the
> incidental whitespace alteration?

Hi Andrew,

I think this is already very close to minimal. But I can send a v3 to
split the indention change in a standalone patch, just to reduce the
LOC changed for stable backport.

I'll also cc stable too. I think we only need to fix for 6.18 and
6.19 right? They will still need manual conflict resolving even
without the indention change. But I can help with that.

