Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE139D68BC2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 22:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4423C6B0089; Wed, 17 Dec 2025 17:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ECE96B008A; Wed, 17 Dec 2025 17:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EF5C6B008C; Wed, 17 Dec 2025 17:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1096B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 17:27:56 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C71891404DF
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:27:55 +0000 (UTC)
X-FDA: 84230401710.29.0F8BDBC
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id F2E11140004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:27:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rfzVccWl;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766010474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aP2xNPBMnMxTzb75tZtSoPHwVxBgrcZpOLdt0vBQOLc=;
	b=e5Vl5v98howl/4m4Kan3Ke3+uBCWcTcUTLqkKHyQM1TIIorEeCzJ2N+SoBEL1xtxt+Pl4t
	j1ePF3V6oPn4bKxEDbAsGcVm0c4ui6hC+tdP/CuGrHHlghYck5durEc9JKJhFum2wc+WD4
	lgmV9JsVLdyTJ0AJCkLhOQ2TgwPrcPE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=rfzVccWl;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766010474; a=rsa-sha256;
	cv=none;
	b=Qk9yxRuckcIZ2i8TUkjzE88fqMKJfrMBL3eMnL2DY1VcMCZVAtbD+Q3IkL4O1F7oP99kBA
	k041JouktI1J9mFiTOzy/p8o7hfFh2vbeJg0YGYTPjxwX99iaaA8aXG3IgeBYztdkR23bv
	JW97d1HdfyWWhFIYrg+yRIEkQe6of4w=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b25dd7ab33so1693185a.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 14:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766010473; x=1766615273; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aP2xNPBMnMxTzb75tZtSoPHwVxBgrcZpOLdt0vBQOLc=;
        b=rfzVccWlXaFooGVatCpivNKRUNt9Dn2efz/Gw2MmIV1UGIhWi5o9BshJeHcbcMrHt9
         w1ar2nEpo/wBrdZz65hk7rgS+wnKN6t43P4iYrrEtFJIqFI7oLmTE65e43NqNvRPTePL
         yqRppPm/83L3Xe40IMmpORa+gcL3ye4RGNCVSDjlsVYWk/ECbktULMuLX/B23oRHzHFq
         p+FP27l0c1Z2Uq4y3obtdzd8AIEknAGoDg8jstfc6Uhk5RrHogBlT8cYDb72ADhMj4gz
         p959qfqDmp5+Wo7JtxqLSk9wubsRyj5fa7yJSBi5BCLzJRkAJgFy26D4WVD3e8JrPm2e
         90cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766010473; x=1766615273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aP2xNPBMnMxTzb75tZtSoPHwVxBgrcZpOLdt0vBQOLc=;
        b=bR9Kz/ukRIBWf9ATbKa6R3nHagQmoz/gUN73lrppg5oIUoUD8psCD7Sq3qf2Uo3a5t
         9+iWI23w9ivrsG5v6cWz1XekRUXNHezMDu+EIqiQ9cvlQglMin5ccBVqz9QFvyyKFxrU
         FBJXtZAp8l2St081Z65JHrmjKbs7rDkBAl1au56dajtIo3k8xeaBaiNXZ0oYjINNw6uu
         0vjjyz+E1tc/BIujhrZdseKxPqa1dqHsn0Hggx9vXBrhlr6k8TKTx8Ufp6rwBijVP5H5
         3xgcPnqXg3n/SC1X97pXS2jyQVXI2M0kf+MqWCoWRWn9IytkfAd7VpdxBESJUeUXwOFE
         06sw==
X-Forwarded-Encrypted: i=1; AJvYcCWZIcZT5ka8sJj1XI5upjqe7G6ueFg6FK2obbrYEbI9kwcO5LP4pkA8f99Mn8f4+DKi3+C7/zXJbA==@kvack.org
X-Gm-Message-State: AOJu0YywRjWzxuDecsbPi58dQxVm9IZmLc/GLmKiNqj7bn9G4j0nZD36
	Po0m9ZxEbgmEkpE1nsOocNS2TTxsAxHofsdTcOPk5KP8hVSoVdf2KduwyvNxrzEx+PI=
X-Gm-Gg: AY/fxX5MkNgItRW/zjbrJCx+p4UE+YMsh6qWpByr4bT37a79JNjV5HSvPwY3ALtZj4O
	MDNi/doSpFQ30N4hsIef5L9JyIRJnXHU+7TyQONYYw+Mhwjm8C3JdHUmDW0afMOKxofvxeHAc/Z
	Rs7gPZO6/j+gR7s6p78xbj6I4z4RW/Ute6eajX9txzGPVlCp4NOJpb/OUk8sws2IS86JYGCQ689
	/0mQwugwhHYOha4JE+yMBWhWwBLQMqwEXZbb+tzYhq+m2FZEUaSG3fQmPuJ8qDkMXbPmHjqOycJ
	JOcBBAuWlnGjeg4XaqUFn6mcjjf1slq5vLvq+sFaR/51XXBVHwD2nn3ymLLdPy8f2hrh6RlbSzZ
	O/CSgW8lmCXt5wN+QbcE3zrCbiTi9dJcrDGnkKulgJOo1rp9rRnxjK1p+Y2dt5/pYU483KHXhRv
	Z2r00rDd2uo6QGjDzyViiG
X-Google-Smtp-Source: AGHT+IEfFl1nZHnH205UDOdO/2YcSf3f7mGkXXRNlXeIJKOKcFcgdrIIyXU3DOKqRW+7y+wbgq8+DQ==
X-Received: by 2002:a05:620a:1789:b0:89f:52d:8560 with SMTP id af79cd13be357-8bb3a248d15mr2896187485a.47.1766010472929;
        Wed, 17 Dec 2025 14:27:52 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8beeb6fa2f9sm39210285a.24.2025.12.17.14.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 14:27:52 -0800 (PST)
Date: Wed, 17 Dec 2025 17:27:51 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 18/28] mm: zswap: prevent memory cgroup release in
 zswap_compress()
Message-ID: <aUMuZxMRSMIc3EKx@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <cbd77b6cb5273b75fb2d853f368bcb099f52869e.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbd77b6cb5273b75fb2d853f368bcb099f52869e.1765956026.git.zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2E11140004
X-Stat-Signature: jdmqtetpeh9m8atoat95ayr1q1wbjf3b
X-HE-Tag: 1766010473-976760
X-HE-Meta: U2FsdGVkX19nJZZTuhb1pUtTvJdlkqn9M3ibYUXLAYswviNckxMGqHvcHboTRNqP2vy5ZHuVXuzQYvXRcWywEu3huWqiiA+jO9JySKo2PqhMPn1SXm6BmB5Lt9ehm6uJhh5SKyHcAGhzCnuFgg6KUh6ZLuTOOFjk9DJi32PnILmd0UuObdG7p0Y4u5dzjP+ky+mKl0K0JvRKkX7iZBL0Wbwoi69jcwbaM91eEbRpu4FuiyfSquiVjkRY/HTpthYHbz+tE0MOZzKn2KgqWI3T7r4iXG/LwZ3r0LqYm9tGUpG1v6vGYDNr4jN/nDkuYRa2NwkXWPBwopwRfYn9C39XwWSdSUpkynVPhdBZL+uK5IX8A75GezZyyPLln1HBDjHzzNxIX3GsiDM6ExcCZWl6vZrvIwdHQIXL4M0+tCRpD3hikketGQTeuqCS09X6mqwcqcYsVmsOD09+13ATXTc18Ph1j1uezggigLTCiTep5Uag0Z5owMqp/sKW3LdPhHMOBPJeJBic52mmdmuswuG1veMTtSh/heBPdkokBr93bRi1ODgcUsVL7hLxR84n87rtMqkGWXnSw5J3YkqI+GDnx8JE9CPVOYPtb0S2n2MJ4BBV5xmJAAh4r3A+JJ5PeKT3Xwpf1lm4gtekJjpe508FBw8/Ae0E8IPvz3RcZMDtfmD0E+RER7eGy8n6NOy8uO8PC5wWuXWlLmJGRk54+2RMbb/9cDqeC5KV0kl0l1Wx+y9JLiDOwuGRmO34di1V8D0UjXYq75kJ90OEdMSj+jav8uoBAxdlKk0XsZhpxVZ5SCkF3ZZFD9CdqrLj8Mzz4KyZ8XGq+FrFz8EEAB1DRnvfNOes5LBP35n/19XbywjTsEBEXu9NMeJTc4iwYP9lVxk5XecdLzNPxmDCHmZTpxnFFuNA/eBIL6yJY7FxBZldoPAQag/kiaSi/NK9B6W6vXUmH1Yycr3tYxwWYTMDacY
 oYSgPJ78
 3qSbsAwFQPSkoPJq/1B2t8VxGUjL1S9DW0yHIDwwlVwtZXotKq4IIANXSus+86sqAeOjQuy3eoxBacsEdbX3J8M8aT1SWsI7q52eIoLIIdGaJbbhoAUXHDA3Rnh/spIcyNDPbsf1X/8CJU8PQd7eXOA4BK8pvBLq13P7jUzci7bYRlj3WB5VvjWwa2NTaTMUoMzc2ch5O6FJqyFgchMXv0XYuZDRLv6Q1Y5choxMf5fiuBkbXA3XGCgO7kDUT93tABizVJYs0N4NwuRkOpQd4QyElgSBlUspUejH0UVv55Z4qKJPwBSkz1KVuJ9Mno2R5SGn5R5aThGjFQ3VlrFNO9IXPIcBVlU3MBfIEcrvwB/62GxGGEB2Cv+wrIo1VJQ9K0EZ6vEj4n/Z8tj8rGvvuc+/3czHkB+wqhj3xC/sEN3l2Zfmt+W3NTBJO99eLgNcYaau3u0szxm38iJVVb9Qyvw+xRUOonIqESR1nJ7A4V3UYym2tPUxOPFlCcXBTOoAHpK/0G4ovvnTY7JGW6/eivx+xbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:42PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding memory
> cgroup. To ensure safety, it will only be appropriate to hold the rcu read
> lock or acquire a reference to the memory cgroup returned by
> folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard against
> the release of the memory cgroup in zswap_compress().
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

