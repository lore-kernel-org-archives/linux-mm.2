Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2201CCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B1A66B0005; Wed, 20 May 2026 04:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8624D6B0088; Wed, 20 May 2026 04:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777956B008A; Wed, 20 May 2026 04:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 693CF6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:18:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E057140176
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:18:15 +0000 (UTC)
X-FDA: 84787095750.28.8E7604C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 64E1A1C000D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:18:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e9ri5DeJ;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779265093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=apshO2Gk6uUHwWpZehDqtUzbXypXUwPFzFdzD5h7nuc=;
	b=p9dM1pUwAFLgSt/xfhz7AQ/HZQYmP1cqaQ/V+qW/Wm5gVFTE9KwJ8bBpYzZxwkyAohwLOO
	SteCeHVEDE7Y06l1k1/6piW+CuEmGlfrwzb8auGDQTlUrgNUf+bBRGn1soI7pL7VVdJRBo
	brrqOzQoor1P8DrHzdmxrc0f8J7sLYM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e9ri5DeJ;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779265093; a=rsa-sha256;
	cv=none;
	b=iDK91XmXofL13ui5KbPwRBiqbWNyeFKPwNAikJLkP4Qkr5lOGeF6U1xbO/VqDwdjx4CR4C
	0CWUR4Y6K0PYAwuqNywE+kLht6Er3z+ZMxXl7r8GZf7lEV6EbuA83vjlFdweavC7k6BRqz
	Yp/vqKUxRylRZhBa4fnIZXAqLF1V224=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 734E943E94;
	Wed, 20 May 2026 08:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9BB1F000E9;
	Wed, 20 May 2026 08:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779265092;
	bh=apshO2Gk6uUHwWpZehDqtUzbXypXUwPFzFdzD5h7nuc=;
	h=From:Subject:Date:To:Cc;
	b=e9ri5DeJDu6smWKkkuWA9/JVU07vuRrQmItSGuyiHxhEov9UMn6KtCPXap/epira+
	 dAsHUB9dO6GU2ZXX4gBoyEt4UahW6+ag3tRvlDvsvvoMH3mpuJFSNPsA/mxF1Pbynj
	 CGW2t7siHHwiT04vBX/xmCWg47YlAZo6kH7g/O30UJbDbUaUHznP/lNjN+OtUkw2sQ
	 odiBSxKuxo3dSYf3PVLazc9sJI+OStm5uVSNf5l44x+HLMNJYncnbRQcZpf4tqmfeS
	 SGeW27dF/P9eZ1prmKmb8nPo6hq1TY2wRuYl+A/jRK4us793dp7AZRqAydR3dEm5DR
	 wz1hGT5fDW95Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH 0/2] lib/raid: replace __get_free_pages() call with
 kmalloc()
Date: Wed, 20 May 2026 11:17:50 +0300
Message-Id: <20260520-lib-v1-0-cb3045bef2d8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC5uDWoC/yWMQQqDMBBFryKzNjRGW7VXKS4ycawjEkvGSkG8e
 xNdvs97fwehwCTwzHYItLHw4iMUeQZutP5NivvIYLR56LvRamZUjR2wNUVZlbqGaH4CDfw7X17
 dxfLFidya0mSgFVIYrHdjmrC6secVjuMPtpW0OYEAAAA=
X-Change-ID: 20260520-lib-8afb92134307
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 Li Nan <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=669; i=rppt@kernel.org;
 h=from:subject:message-id; bh=nrAhJh8xxepHLcHtg2F03NYQlXZqQEdXXS280WH9zFM=;
 b=owEBbQGS/pANAwAKATkDhibLDv2RAcsmYgBqDW43NCEvsfHLGh8NEyK4DiUqQPwTwYFozaau2
 P27N28Ld/KJATMEAAEKAB0WIQR45VhVpZkvn3TRr+k5A4Ymyw79kQUCag1uNwAKCRA5A4Ymyw79
 kX8xCACPOYmf5YXvGaf2g0SGz8xY2YcDsY4arf76o0ndd7o5AVb8jNhXqQzQJemBk451jMZAOd+
 roPl6Yj54BxyDRjZtB5sukmEMpiMKYVfFtqmaovGLCLzWEacxZKVU/stSUagdYp5Enc25dnEobW
 CE/pgs0fWFWcEvRjYgOPVM3EG/a+0aJ9XVnepV+7Ctjv0MmdJvTvzK0N8sm5/s5yFn/qmHJmCYp
 auqNW4F5jb/vxWfYl1234/c51gLYcNLEokqY7FQVaOYK5xkAbitGVhG9/iw+BpahL4Cg5PCaax/
 nmDTCYASjgywIeNMPROZyXFn25s7A5RaTMcNB1UyOF0A/m8U
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64E1A1C000D
X-Stat-Signature: x5ps3xnihqxdd8cj93myo9ntn7qcdhxo
X-HE-Tag: 1779265093-661295
X-HE-Meta: U2FsdGVkX19Bp29IYgCGo3Ogy3lnWKf6d4WmWF9rgBHSy021GUeb8IQsVIeCssj9UEt9OHrTb9ToFCaeNVavSKvYniJyy53iVjVk7yf+9mb6gX2p9CKzaj8oBbH6enHR/k9ybS6+AMam7XGTr4y68KuLLesn9bJRAGH/f9LOO8HeC++YpmcD1yehzXci3JXTutlfDX2wQlZhxRHFzx6SCVv1mfGiOtK4Ts7YODtMnYs2JvK0fHbNoKRnf5CkW+y79suFa1HUIKwsMsx+e0pKLFeqB0p73HIBH8umRK3dtyYfVoIurVvK0pYyVqOsPi9J/Rad84chqiLg5T+HYOd77s+7giAhSG8wO4lhyUjvgfnA2+eHcHTD0sjWirr1BkSwQshtBngPunQszOH+LGC5lmsy79PkoPPxYeQWHwjdX/eoEkLk9EbqJxgY8Kt6HhYeQH/ZqYuhPxDS9BmuamhLX24xMN98tSfipKWXuB7veSvYgFuvbaCQYbueQXYpCW46Jvr1aw+Zy0SmdaDWDIqx2ZyQdLtPfzAuG5oF+/Vl+S3+Zdzmef6HBGw/7t5bs8hxk5htWP7ocb4Ja9A/7mY79hWDp0DZM1R4djlbqKaV1x1anSJ5M/GW6mizI4e/FNEHLHVyeIxPvBXXT9btc1PEbQwA2pJ8YnlQOwdmzSEr0+vkZCDpz9FZB7f4++IIiargO04tQMZ1v5eZKqp9DFcFpHFondhFNbd+/g2iPXWEFkJYnDAX0Rvj/6HHqHQUEq+cJaVZLM7TlQmnDVlBD2Hu8vIBHnCIQNoSXhmnadJi7PHCZibyrGeIEf1f1I/TgKze8qW+9jC8+2C2qAUICT4Yystq00UuNVB5bk17zD9ovq4GpghplQ4w7W5IsNhtsoO/h+ldVV3SkNuDgJlYIaa6UA/Bi8awb0A29Ldq948Ay4zvy3qMhUPR39wzFQ42OXofJXmkzBxcWSCVpUKWRe9
 GL7/vHNH
 QSZ/XtJo1eyVkrAyZKO2H0szq3BZn2jJZNpxX0/akOdqS5Uwf30tetjYyTjTOmTUUZQ4amxlPTd6xnIcGmc4jOMDW9WyEF+Q98Sr0BrX2I7eJ1lVpOiQd52lFotkbykLl/i2bX3x6OELrsQlRn12iAr8TiYytsphgUXS/sRGZ/4yv3TIT4qVm//aEQbxB9uOsFV55685ZHg561DCS8OG4um3MJItk3nj7wzJ6GEub+LUkhejEcFAsX4l6cnw1dd0htw1mhZqbTLs86UPlMdyulTIJPzrKS9jjVlsw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a (tiny) part of larger work of replacing page allocator calls
with kmalloc:

Also in git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/lib

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
Mike Rapoport (Microsoft) (2):
      lib/raid: use kmalloc() in calibrate_xor_blocks()
      lib/raid6: use kmalloc() in raid6_select_algo()

 lib/raid/xor/xor-core.c | 5 +++--
 lib/raid6/algos.c       | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)
---
base-commit: 5d6919055dec134de3c40167a490f33c74c12581
change-id: 20260520-lib-8afb92134307

Best regards,
--  
Sincerely yours,
Mike.


