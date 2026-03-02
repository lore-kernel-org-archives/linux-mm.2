Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 436EBEA4E3D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 16:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6766F6B0005; Mon,  2 Mar 2026 11:27:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F006B0088; Mon,  2 Mar 2026 11:27:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5237E6B0089; Mon,  2 Mar 2026 11:27:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40A3B6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:27:05 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 62E645751B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:27:04 +0000 (UTC)
X-FDA: 84501652368.30.2B57838
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5896AA0019
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:27:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KiKWkXJu;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772468822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7UE1GGVwWJfObl7uKLI6Yeo5E4IPeQzQFVK8w6lFswI=;
	b=oyWMN2ZlVbNDjtpdGhvMh746CQjxyGhOtZpfsdbsNySUGrrUa5eXGqWh/S+8yP5L/n63cn
	/jQkSGS/yfDovJNJJOTNgROr74Gl14lJ/b1kLcLdJZH7d1eSf3E09FwltCg4xUMU1aUfuY
	xinztuERYqv2YaQh1W2WD7DMb9ELTuU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KiKWkXJu;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772468822; a=rsa-sha256;
	cv=none;
	b=MtRnuVPLbs8d4qyOEyBe07mYrsjxABoFJAPCt5m5bnhbPog7I9+Rz7snwbCDPwHZrj9Ny6
	VGoe7PvpycJHXikV6dil7d+LTxynAX5Vtu+tIFYl95O1ur7qua6NeEes0eVk8pYlfDt+oW
	E9jpSzTSxavmGBqXe2ebuR9Oxgc11AY=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4836f4cbe0bso39984125e9.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 08:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772468820; x=1773073620; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7UE1GGVwWJfObl7uKLI6Yeo5E4IPeQzQFVK8w6lFswI=;
        b=KiKWkXJuUScFQB5vNmIdkywxX/GNyZ356l70wVgQhah4/4GYv5aW7WjFr7xG7bjg8c
         WN9eKUjdpCkbM2N17tSUM0C6UMMXug8legRdueuGNVJwcF4JfGlDCkdn1QtuYcPQE0Sd
         ebrP1B1NOjPp3WE++X7U8jcfmAA+LpDOZrofY4glrc3+wKTOUl+XGMP6yhzbpIVO/zPx
         JnCkGhEWCu2pAurm0bva6RgtrxxZg9vKUytesKHpddR7dhuk5pJ62sdZoqHluiRQLk+d
         voYl33szmObYNwPn6+yjk9m1bZzbpOlB/F9YYwYLfg2QReZl5byDg52uh4JIjsuLmw2h
         Ey+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772468820; x=1773073620;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7UE1GGVwWJfObl7uKLI6Yeo5E4IPeQzQFVK8w6lFswI=;
        b=YFhYog3YgIyyK8G3K4cRBgCPYHWC7ai9M2889Oi5jbWeUuhr9cWSYAPgrSQZUOZKe+
         RY1rQSbOrQWYARby9QxT/Pa7tBJR9S/LyTxQHosf7SFzvNpdiZKYXEcRirQsNhj7qgLE
         aHLoz5BBM36hE63s2il0VaGIF8qkMPqoI0pQ6c0PHAu+XsEIOe1hPZvTuP+6mGv1zSdk
         z61dJufAelZMmd/gSp9+jh/EquXHKE62ojIDMF/twshOW8zmccxm9t0BQgbzDrHzVFi0
         03Y6UTex1JLqXM2+Ror35b08sSTLsL6SX9LXaJAY0dTCxxrFP0YaIzKbcgpXDAPb1uZj
         Xkmw==
X-Forwarded-Encrypted: i=1; AJvYcCVH55s74mZG3HfeAN2UGVx81edMOSJqUaqV0DjUyrFMVkXkoyBnp+4oggR4jk/TK3Mkct5TPZTxvg==@kvack.org
X-Gm-Message-State: AOJu0YzgsNKVSwDDSdhTPpssJe7KmVq8g+S7eYBwW3YMmAXtSdN/8Rrm
	SVrnOyuGRg3R9ig44oAUJ7wr7KrhIwLbaBFtyKgxgIiFR0w3RKbSG8AC/j4pIwYNAcA=
X-Gm-Gg: ATEYQzyAsdQKPw1ipuku+OGWfUy+gVVVuHUbY4ItycCru52YL7usWvgJ+J3h30oU3ma
	3okggAtA4TRADZqbIFDXqsPbAl2OzaQPEDBJd062J6CKA4HZhu1ZrbDw+J/Ry+7CSDdWJrR1GNM
	WuunqAuU3q6Q0eqgSzuYHxZ7VilwHb3Ja8uufWVElSuMv2pWrAC/oEn56FlTGreG5vTM3T6f0Pl
	RjivD4eZkSShvE0V8NN3GzrRgGj6+yBmp2JK4wMadfKTsVXcQd+vZUFyjILiyJJ8l/EpBiz7Laa
	Ewp0eKs2Hx2oWCYaXCX6fb+qH8x+oRC+o2+Txq5oy72ChRKEW3ar+ofC0shKtMAH9fF9a3VtIyn
	aqwPK5YZe08EvPuABUvVNIA6IY36owmoGuhYxIwTQW5qzafY8KV/Ruw7hlJW6s6xEf6Er3MstHi
	PnF4avelqORNXX1EVmuBb6hAl19mcVBYBFXBiM
X-Received: by 2002:a05:600c:4f11:b0:477:7925:f7fb with SMTP id 5b1f17b1804b1-483c9babeaamr244554505e9.10.1772468820507;
        Mon, 02 Mar 2026 08:27:00 -0800 (PST)
Received: from localhost (109-81-20-148.rct.o2.cz. [109.81.20.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bfb8724bsm170155795e9.11.2026.03.02.08.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 08:27:00 -0800 (PST)
Date: Mon, 2 Mar 2026 17:26:59 +0100
From: Michal Hocko <mhocko@suse.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, Barry Song <21cnbao@gmail.com>,
	lenohou@gmail.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, weixugc@google.com, wjl.linux@gmail.com,
	yuanchu@google.com, yuzhao@google.com
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
Message-ID: <aaW6UwI1JuXIgz59@tiehlicka>
References: <20260228161008.707-1-lenohou@gmail.com>
 <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
 <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5896AA0019
X-Stat-Signature: kh16hqkt9k7z3ksbiimb5pcgpacwfrqs
X-Rspam-User: 
X-HE-Tag: 1772468822-821587
X-HE-Meta: U2FsdGVkX1+QpnQFdUu0RHDeRBGzlVzcdWMlT3RngOKjZ83XYC9vVCY2McPtqsjwILHoigJZ3LzUTFS5tUYEuyt21QFOL3uGA5iVc3PePVPQwkD3XyC6NMbnufLu0gQKQ9L5guF+2kl3IOvGremBVIn1KT5OiJjkzDC5VxkXBG2GUbHXDv4s8RsP+OvEhhaUkA4XWvWuZCCXmScW0rwYU+WpmpQTn26TVTtIU/5MHFBiPtkKW0zcF3FPnJRJLvZHZIqI9sYlqDcaTxFqxb8f/a33WuCWljYEOEIFXs939mNWr2xv7skeLgs39mfVv1U06iP05X8BjSnx85fUzisBE3Xf4qiP1xqs0PTHmprnUlamrH79sl8WTDn6J9LPv8UxS1f3jcRJL/0k8eRc1EMwNk40HxVnViSYKCStbYs1tDVTIJhr5RN13k24fkI2NodIecFqKRuT8QLFQ62rA0TXWScJDuW/c6X0ZIClnV9W91utjoqVjB9E0M08VEArH/drsUY7htm3m6kvK6/dq010YurugfRO1PmHqmSML0qRuw9Uas3fbLlaojb1+FK7BnV3/kCFr7FgIq4y1gaMHtjXkYzIC979xJo7kthv6mHiLqJ2IWFfZbo2+2aQQTvv6OAyzQLPFtSy2p3Ui9CYudBGbO14yaVc1EzgBdCXVzx2cYOXI5+0qaiaeVv14qzAe3WiN2nREZGEew4pVouYsB7CP84sg52pCurB3cjlWIITiDKDCY1HTxXFNH0xSvhVd8CQVBbzeknfbCAfV7lGeH/WqlWhEbLIZzOqjz8yhm2MzhX0L0+u3dA5dtq1beCi1jMC3F61eox+ZJePb+sajoYeSz/cA4B2sUzpYkRg3lskJfEYPQjRkt86PgFRhZIl865SRv7DHOfBer6NxghN08uiQMcs6QRcxVRnE0raj98wxWe/iGMJa+zDEw3RlYFYpiMtwLF9KfZrHqzCIqgz3PC
 z7cZD6hj
 dT2Yxlq/OMNz6m+TYM/fa6h9vjnRrm/I4xoMwEXpbouIcevJd6FCzpi0aFFuvWb13OSChjrm/ENfcekIpou8VNnYJ5oiH4vADpiUXn3sHbvWghRJxprfivob3qWbs5q/lUfT99dFFGLEM0tRD0y8TKJltJahAZsfn4r8T92+F8i6q+SR1pof7M4cKdFQ9oBZx5qAKY5LWpDVG63cgM/VXtY6EyRzfKrO5sqZHdQ07248TSQPfIbBEytgNbRrnYzFX9R/TmlPDxChzfpAJuNzTfeB0uBFyTOvLeyOahQ6o4kBjbVhiCy8rXyJwJGdyB0Af9AA/DPic+LNwqwDzKGvAVNsY7JBIgXEx+uZQO6DqQt4stNQpjaWax2+9J301d7aMKHHqhd8+T6G9G9HUzpO8WVclIDmZLkDYCRbx49+5/3xCcVG1zEv7mX9oKR+VC1op1hM8X1X0bA5LELxPSGd4XC8/roV3XrK0/7wTw9JXOxf3gqLHtkbt4T+Ly+Y8h6UEmVQN+AycG4f3kCnKPyqP/1vCXKYgKoDfZfKcyjxwRXAYHzt4Es75tYBFOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 02-03-26 16:00:03, Kairui Song wrote:
> On Mon, Mar 2, 2026 at 3:43 PM Yafang Shao <laoar.shao@gmail.com> wrote:
[...]
> > > To be honest, the on/off toggle is quite odd. If possible,
> > > I’d prefer not to switch MGLRU or active/inactive
> > > dynamically. Once it’s set up during system boot, it
> > > should remain unchanged.
> >
> > While it is well-suited for Android environments, it is not viable for
> > Kubernetes production servers, where rebooting is highly disruptive.
> > This limitation is precisely why we need to introduce dynamic toggles.
> 
> I agree with Barry, the switch isn't supposed to be a knob to be
> turned on/off frequently. 

Is there any actual usecase other than debugging to switch the reclaim
plementation back and forth? In other words do we really need to care
about this issue at all? Is the additional code worth it?

-- 
Michal Hocko
SUSE Labs

