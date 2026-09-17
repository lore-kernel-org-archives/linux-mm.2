Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82F40C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 18:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7931C6B008C; Thu, 17 Sep 2026 14:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744786B0092; Thu, 17 Sep 2026 14:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 633776B0093; Thu, 17 Sep 2026 14:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA5F6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 14:00:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CDD28041D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:00:23 +0000 (UTC)
X-FDA: 85224018726.08.C5EC5DD
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id ADFDFA000C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:00:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MpzVt8uD;
	spf=pass (imf15.hostedemail.com: domain of karthiproffesional@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=karthiproffesional@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789668021;
	b=OVpXKiCiFUuysdgDZPb1Kq76AA3BG+Yz8Um2e/6e8bQl7/9w8c8NVJ7Cm5T/AZc9ZzKTwo
	1gFGrS5IkHBRoYw5C66k5FD2uG5z4WvlKgP5TfLJfaGnhqjTknB/AMu/fmDi5xNB0OL79N
	I2RQejySME4fYkhA6vquSye6l5zvOWA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MpzVt8uD;
	spf=pass (imf15.hostedemail.com: domain of karthiproffesional@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=karthiproffesional@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789668021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCYa7xbUQUXHtt05AGeI1m7rQB4mKruUeHiavBrEL5w=;
	b=VX9eTusVso91kIKps8H2E7KZlKjXenQ6aW4BKYKJTZDviz8RcObUcX+bxUc/s1guf3qG2i
	m5yp/TzJLCmyeCFffmBxIFgwPh0YMN7TPlVH/9NyKOkw9kQdwagrWCoqbymB3rdiDRAK1X
	cbME8cKaPrDQfhUmauBKfWH+P6xzs08=
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-8692a856865so1045845b3a.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 11:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789668020; x=1790272820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RCYa7xbUQUXHtt05AGeI1m7rQB4mKruUeHiavBrEL5w=;
        b=MpzVt8uDCSr3iKX/mgcjFNwdb5xIP9B9ubxSw5ZtgAuuqRwXWmxQgayEWi9ixSs68J
         MGIm1MdONEdtUfC3t7UBuk1FN/Wmw+/lo2qy4ZlbdBcw5+P5rO2xHubYjIsR4lu/GSK2
         JUbpOBQEFL/ca2J52fxGMiQPeelW/sW0uTkTBthGk+vo8ok3jTJ0o4WlsdUJjpE0qVTy
         Js7nTQQM2Cs+5HQz48HfDad6O3r8PjEzmcHXYEY2uqdx1EZ1iQibrXlB7FjWmXJT7IuV
         KPBFnu9zW0JymucBmEG9CjokeiOBg6VzpmrZjcVp/exfsGZJ4OEZ9n073wo/u/302cLu
         0SWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789668020; x=1790272820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RCYa7xbUQUXHtt05AGeI1m7rQB4mKruUeHiavBrEL5w=;
        b=vwrsVLo8QQx0gfvUmBd2HGZ6sENp1TsCpThssjWmCfJ7ryGn2/avce08OEiqvSuUmb
         aT+Fhi6OW3wlOJ4T9W6epLFvnEeWN7gTkhDQIpSWIrWByh525aCKUPsjL0AR0zI5w1+/
         YZxmXzDMEhLK8LlUi7HUGcdIf0/COfisYZ4QJqFl63LbvN1xkmgp1BTZLhaI70Ppglnj
         m+jRyXB7EZOL+90WuHIIAHeiKjum20RUCa+uKnC2aHGEQPc7EY5KpFqbTCkPse8T7Sj4
         G5qE4yQvpXt0RLk14WrLU5k72MnJ+p2QGs5uxtqAcwq3t7wGeWsa6QLclpxOIYIH2ThC
         EDXg==
X-Forwarded-Encrypted: i=1; AKwUvBww6ACZB2s2p7jtlRU9JGRePZGHD0jHkf5Xf6ihKTmUBWAffUMmXuzUAmbH+B2n9Ocr7njt00y2Og==@kvack.org
X-Gm-Message-State: AFuF++ndO/iGaXsdH6go6duZ+1WPH94+fvF7QNfiF8mrnqVoI2A12GIx
	vFmEudhr0PXmt8bI/sWwLpL0ZzPBa0jWm273N3kAPc9YyqX4iyfabrut
X-Gm-Gg: AYBFou2l3M1Wq1Ri3YONhePk6hhmt1705wjemKiVyR4W8KEmlf9jmArt3gkMa2kuge3
	3KwUnow7p+Z3CiZqonjq9ufiIgfbX4ShGg1JJgYfHkpFtGDMSkbPunapsc1fQedqa+wo4rwprew
	JVDvIi/YmGWxEit6bj/BTAkl4JZS3z73diKsUvTySDRyWaEOzXfdqAzBbwNqo97NEWXl0fl+5Nv
	ITLgyknR8Y4XMuWrYu79qD2GMRv3s2CE+eVSqC8UXXtaZ/qZVW2HONmi81m0ZirwSvbgHEOiKBq
	MBR1WNcKFnMAn8XQVBKSTtHClbCqQwwoeemM1jbqcvPBBr/bWi9N3/LbPMO46mkJSBm7PyMttZM
	OCl2QRg/3CP77ql0bSqhp74oEqTGRoKMPDacl3naUuRiW1ftFXWyLhaTYGEtLK5b70nGniNVUS4
	GZkZh/4CI7L6jtcMAkGV+rfe+KAl2RLFMLWpxrGjrv50ApCuPDV2zYKrz5pbH7f7KkYbXDAEeAX
	PIRbl1two58+72jgm2jJQV1CZjhv3F+rrVwkFGW8df0PXFVC9h+nA5wjW5t/7DykxVDy5uG/6Ms
	jTeRpCput/mJRXnijsPg3qOeeL+j0QVY3QwihbUiFVMRDw==
X-Received: by 2002:a05:6a21:4782:b0:3dd:85a8:4c58 with SMTP id adf61e73a8af0-3dd85a84d82mr1969849637.31.1789668019933;
        Thu, 17 Sep 2026 11:00:19 -0700 (PDT)
Received: from LAPTOP-97G9G880.domain.name ([106.222.202.182])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5b1d335sm18580264eec.28.2026.09.17.11.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 11:00:19 -0700 (PDT)
From: Karthikeyan KS <karthiproffesional@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: reject zero sampling interval
Date: Thu, 17 Sep 2026 18:00:13 +0000
Message-ID: <20260917180013.1279018-1-karthiproffesional@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CABFDxMHjbQhzvrQmRjo_F9Tf0_zQ20FxaSHFEQN8nfN+VgsF2Q@mail.gmail.com>
References: <CABFDxMHjbQhzvrQmRjo_F9Tf0_zQ20FxaSHFEQN8nfN+VgsF2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ADFDFA000C
X-Rspam-User: 
X-Stat-Signature: 4bd5xc9zhcuzbu341ae8zjjt9nu1pwoe
X-HE-Tag: 1789668021-656146
X-HE-Meta: U2FsdGVkX1/8uWDXU/YW+P36TqxdZ9F6MSJHMavQbE4uxsYTjvHLnxHMvsaENTsgwp+ID3aJmRCg1KVSRM3maUc/tA5+0goOIW6mac3A0cRu7PIz3UnSf1e8cxVZeXLBfl+kkk2R20unPYZWJgrV7VSfwWOkllZnROvWDfxau0H4XiLtEZ6E+g/yh5uF1QZG4Gb3KK0pBTWporP9GJmp7uPkIBeuAm4m1omO6/0PBiG8P0gIqOcn/+xDT3ogorFBHMaMV2n+31bcuUsvvf/lmV7aPNeKAqkJnNo7eIdntPVADsgLCzf5iyhaH/QCv11WfnQdLRnQ6H2CymhNvhSyTzFSHipceHDqYrrpbQuPWG9umXYS0ZLtP4kyymXddYkfaPP5syj1k30HV7jGL9WfDbHGX8yrnawoEB2YIW8kQYR1RxkgiVbKg5uB5yiiLJeBiCjrmY3p8FkRl3RNzle2Mp7SOTln3Cm5lgSR+JYpcc7xQYhtKlx/cPgAp/tpkljWsIG2EhWXGdxzMm2yXSJuHlBtK8YsoO9X4DXCgLm5o2DTAFBMrZ0xCQTczbxJ3XhWcRn18gpxdo6Bgms9olAIxpx/cVoY/gdmxI6aEZhGqx4iD+54ucIbU5bCmO/oq8tSRq/dtd7kQ1THbr632Yqk/ycNnQ20TKMPTafaMOyinCwaaJAFo2LSdUhOLia1qxOlSC8Ecb+1rKBcPyT8BFUxLlMno8rGUAui4rzqwmaH/jmlUATsR3ZY15HvU+hzWkQcpGOyAPVkvI0U2vYoKs//sBut1582fWGkXdHRxq1JZJZGxb5usELCnmDLkDOLXHYtbOdodu3AAXpKULIk/dLeMo51n8+erqZ8tp5OFdd97ZGgmU4YU2S/nsZNXCmfNttET/N7x5PVvSx+H8JIFeN8bIWnWv0BXnd3Ntfax3xmf7Ey4XFWq4KJOFs7C/iVsImSwhopd0UHjjyYRb1B8lF
 +Gx5zO1E
 aWkrDX3HJoA1JyKEW88yFJIGv5xAHy7PVZet5bIea1WUdowrXOiX6m4D04YsqO+9OnFufDw4x8JAbpgaG8eBgsDGVUBtq1AxCzmZAfh1qd8vNSdUtx5Pe2cPt/yPyLrO7E8SK5guAk1qX4grwgZ54nHugGCE5L/Jy4DdwlOhVYSZktJdUIAIYi5EU2HFhL2EplD03oxc+qcZowXjqtX9z+1nLGhAnbHKSVs40FUSSYLwl+ODl+8d2BSZjWgREqhaR352yO7J9HKkqVXGAAG+yRRocv6cgkHxBHjCEBIIYqGZTSjvPpDzZci81Qpbs5pfPPDimCkMKPtARjovxFq+zcsF6wWvGGXBiUnt+ls/4LWbH6Kqwdiim9/lOgFz9x/lLFriinZ2uVxkdgrLy8G2DSHpgzJTDt4q+EkiJeiq8+e5A7S0je/AxDS614Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sang-Heon, Hi SJ,

> I think SJ already commented on a similar patch. please refer to [1]
>
> [1] https://lore.kernel.org/all/20260722094304.3132750-1-dayou5941@163.com/

Thanks, missed that thread. Same objection applies to mine.

> Can't we keep supporting zero sample interval and fix the warning
> or the real bug instead?

I measured a few floors for kdamond_usleep():

  floor    kdamond CPU (3s)   vs sample_us=5000
  1us      84%                28x
  100us    42%                14x
  1000us   12%                ~3x
  5000us   ~2%                1x (matches control)

5000us is damon_new_ctx()'s own default, and at that floor the spin
is just gone.

Would you rather we just document sample_us=0 as accepted/expected
behavior, or clamp it to that default inside damon_set_attrs()?

Thanks,
Karthikeyan KS

