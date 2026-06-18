Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAFCACD98F6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 16:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40EE6B0088; Thu, 18 Jun 2026 12:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD0BB6B008A; Thu, 18 Jun 2026 12:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1E96B008C; Thu, 18 Jun 2026 12:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6516C6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:30:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C1BBD40010
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:30:02 +0000 (UTC)
X-FDA: 84893570244.10.B2550B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id C66CBA0006
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:30:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=plexdl3X;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781800201;
	b=Wpf8cUg++3iBeLeWRgpX2miKB+SCt3H7M0MiMOxEYH7Z9TzG6/pMVyGHsMdj5z0I7AobAl
	plOLt96VTQv7BSpfrw0JKfX/CHH7Jqd0kYd8osW8mUzLVoJ55U430IkipI8X2gZZ2ub0zf
	W83F7ge/AH78fQpUftRVygKcNayjfTI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=plexdl3X;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781800201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DQnlws4wWcJ1dLl6el7H5YeJjw4j146Dai2SHHxJ38=;
	b=TrE4/nbMFZdJsSzPOLgRptaCUkzUfCAYCQJ68klDLy3JxJTuCZ9ifhElUu9sjIaf3YgDkK
	KyXLZqMujIFl0azsUn/Ch9jelyZQ22T2xQK5Qyqzx/uNBGuZyFLjUmO/UPiI6akUwH0SZ3
	1dJWDLqoKqlccWptzGLRFfanYC5Hu4E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A18284048B;
	Thu, 18 Jun 2026 16:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 495C61F000E9;
	Thu, 18 Jun 2026 16:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781800199;
	bh=2DQnlws4wWcJ1dLl6el7H5YeJjw4j146Dai2SHHxJ38=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=plexdl3XvWRzI1joncA7IjRg4N6k+Fd94qagAqnKV8Xm0NQdJAhItrFKd154SQ/Xo
	 B+sWsVsDyOYJOfjYpqMl7QP4mt1nW9ETznvul51cg1NJoqcK3NHMQYP30t0bMbLyvv
	 L2naVy8yoxNui5gGIYN/jtFa+YPiQzxhrgupvwLo=
Date: Thu, 18 Jun 2026 09:29:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: pr-tracker-bot@kernel.org, Konstantin Ryabitsev
 <konstantin@linuxfoundation.org>, linux-mm@kvack.org,
 mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>
Subject: Re: [GIT PULL] MM updates for 7.2-rc1
Message-Id: <20260618092958.28c03ea5978cd6d61547610b@linux-foundation.org>
In-Reply-To: <CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
References: <20260617153144.acead3f2795da15f1e56005c@linux-foundation.org>
	<178179616355.2947725.4377157124023044624.pr-tracker-bot@kernel.org>
	<CAHk-=whn39dQtoMeJrz++nAnZpgnrooU0dgzOZXdn1LyxQ+f2w@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C66CBA0006
X-Stat-Signature: 5h5mdsxtqforzne4w5aienh6cahgnw3t
X-HE-Tag: 1781800200-272791
X-HE-Meta: U2FsdGVkX1/Ww7JWo4WDis/M8NiQF4/WamZdI6BQkK8yPM95o2dmK3ZnKTxhdUkSJBNUpfr/S4p06WFM3xdfkr9F8X7v6O3DJkqFnOkz4oti3pwmGLZ9QzZEwe8YCRz5Ht8GLg/V9abA3sAW7aRzCEzp5GF/ZI9tabuNIy8Z7d6YAEHBYgJWLO6uSexTOwPvfDdJrb8YKg01UrGlIqPQzMK/FLi1GQhSMfXehjKX0lIB/OdQDizi3YNurvFCViL6b/ftFlFppMUU0wUG+nazOsU8Sb6MQkw3MtO3tiIdvBfY+QvQ54MFehiKyZUWifr/RcP8+/J2Ui+zKdtTdmZS55LCSbQHPr5fdChAkO6PobSfi5ItWiumcKCv8oA7oOzX033sF0Bmu6Re5B8matM0keUyHhNhbA80cruQgYxju+ntwnFr88uYINQ/cR7odv/pUSmckuGCfSKZhF0eeUReL8Cck9tXZ4gTVWZ4JCwlWJM1YK7HVkHqPD5o2EPOSsGCppNb1Een2lNCDUdd17SX3tBMBSV5cyxeXdWGc6oZOgOblys9vcoHkDVQeKaAbpEedJAY53UPMweFZQ6BesmimzfzNV4yhkrF6rvlE0Pws9M5UXBNMFfOJutWlBdOmhuanO7p1Nt9XEu+O7dzW9b+PhBERIJeK/9z9k4phTMrxhjRYshK/LPX0FxQ4RX1j/YyvMfpGbnGdkbx3qHmH/2I9B9pSdBEK9I2vAsJ8hQpY0OVhXSk0C8+RhXFMZcLOEHIFb6EaUTfLgbLLSUc77Az2nAlEawoumhX2AdI3KCdSAWecGtejMXYpkyNwx/xDkP6FmGPg0MN3GarRu7FRVjrsPQtFhINWzvXm1IL7x1zcgMFaSi1Ha13nEgg1xhaSR3UeRyh+AZLvti4HQrcPUN3idhRBp8rukV0RbhlwABvYjWM5/nt7AsueX8r6G0jzpchsQmRIzAFUeaDp07hDgO
 5oPMfdWw
 o+RUQRtSQUI3FAWI15khr92a0bD8ChUPcgquFaIY6enHgz2+4ARq8gNgqqU6O78hmbh3IlKTZ2/SwKjlbgbMbRq1O1SZ9BrYDw1S2hz1wLQOokjJ9rMIbNJe9wCWjVrOsPyD9ftI3m0kspOKpzt7IAr3w4qS1Yl1HPAF6PJoxQdRpJQ9WzjdnDAlZroTr3llRBS4dRNRy9uRdb1Od/kMJ6y17b1dwjhG9lYowYjy9uKawlgoIaKj+z9BdzdxvxXErh0aRMnhErPt1TIcH443I+IX97XbGvym4KfqAW2jHUH4BQILkJhXksH0a+ZtrWOq4jQKlGffFk1QhMwLBhU9pFc8LiEUDnbDeRh+BgTq8pkAumVY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 09:02:06 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> And I have no idea what Andrew did to generate that bogus pull request message.

Me either, sorry.  Let me redo.

