Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE96D3CC80
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 22:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0A1E6B0005; Wed, 14 Jan 2026 17:13:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B7AC6B0089; Wed, 14 Jan 2026 17:13:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3956B008A; Wed, 14 Jan 2026 17:13:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7987F6B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:13:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A575137FF9
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:13:21 +0000 (UTC)
X-FDA: 84331971402.26.B60AE61
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id E24CCC000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:13:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MfvGhUcd;
	spf=pass (imf10.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768428799; a=rsa-sha256;
	cv=none;
	b=WaTJrUJ3mehOJbR0DorIIRKb0KbD3lx08rRt9Y8Dt7UDQFV2Y277kX58WcVAi8FLHPyuh+
	kXofJRtGrLxObPvnnkSkA0fOUlpw5Dl6YtkdLMN6AFRNyzisPO73bXDHQgo0/B7PQ0NSs+
	ZG7rIh2Lbn0fyP6Hjhlg0YmDl9B6630=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=MfvGhUcd;
	spf=pass (imf10.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768428799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9te7Py4jVWEi/zTRZhhdfHD436sqYIG62vqnpysxH8E=;
	b=CQE6FCGNctpfX45LcXxBNW3M9tFkHKKf8TZ/cpgQ2Y45Kl/dPg/XYJepO0KdsD7Vleuhox
	7jlcwmqbQRqae9s6vLIBcvn+01PIhZaQ67g7NWCPrWM0aYhMyFACHvuWBMn9njtmTYbVSV
	C4+m9zonooV9UEFs7XmG/4a8G6DKtvU=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47f3b7ef761so1693675e9.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768428797; x=1769033597; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9te7Py4jVWEi/zTRZhhdfHD436sqYIG62vqnpysxH8E=;
        b=MfvGhUcdc9UrJm9UOjxC/KzhiZvAtHO9sFu3b5V+NBCUd0cd+XFYs+xORnMEqZSCu3
         TfNmAUC8U2Nv7JQxB0FrNPG4bB3J/Ofgpw9D5CUMlg1dhDpkzOPAH+hcLVcNqEe2UqjL
         0/MxJafAjZC/m2xMLAN6+BtKi3g8Tt13Olow81x4WTNXcI1z8Er9gfnqdpLW8cGOK1x8
         B9OTTsIpnQIm5qDRN3FaHpVOK8IlwhgvQpi1n88j0EUdScSVl09VZrUOUp0NA+4tj3BH
         bFiha4PtAsZYZc6cEL6em4/kdtFc2JV6Xy1suW1D8n3oFTunl8EEfTayAJuKTu4dprZi
         gK4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768428797; x=1769033597;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9te7Py4jVWEi/zTRZhhdfHD436sqYIG62vqnpysxH8E=;
        b=nPk5BwvQlWNex7vrOivQpaplHjbzz9oYoP/9MKUmJDrH4FAeZXGTYmKwekir1vXBHf
         mJXKEGry8oPxWZekWPuxhW7sVfFmacT5TT5nnkEZFQJHYmVs2QTnvm40rb4NBtznSCoP
         Ubqb/vmBc8Lp9EnuK5I3PpJD8TfbDBYH0tZGRHKW32M/Bh4/lNPivQkDwruDA4b1/lfS
         4NHZr0QFUvE6XQqXbWLhpDySJJbnuEbPKDi4vEUCafYqDrYMK1WWRYgfD7Du4EWJT4ew
         rSkiTERKYlDTGKlRcLoENbwzbkdLB+eYFhcaWcAFXoZh0gWTXgXqcoEqDSSL9x5VGIIj
         QX7g==
X-Forwarded-Encrypted: i=1; AJvYcCV5pwIpBV4ZIWWypCUgJZu/VxWy3mP5a0Rq22HtaqSE+uiAxoeLsWtTUSr8MED+hxbvP0XaCPkOSQ==@kvack.org
X-Gm-Message-State: AOJu0YwK82aKCMeEZ3u+6bHzAS3q1hkOncPHa4oUKITKln9fWcjqoIyD
	qu388LzckqV19szuErOum5C0N+VUUij3rFquJB0rG4BgLzTNwrFVibuw03vXYOkodkw=
X-Gm-Gg: AY/fxX7eClGXnkRaG8//aWTGRNVnr91zDUwzJIXwUN0K7GcoJpPo1fTZF1jdJgl2CSz
	894EbczKvyPWHq5ut4pvLzWMMpZxd5+LgzH9cHXqiO6JsZAx0/s2YcP7EtBfs/kUvnazjxEzSO5
	ZJfHEahg4CUR4MAGRr6yQU4nJ6IRKLG3lzzjpZwr8g5hIN6XtjWOCiu9jHfjsfSLK0pbMz4pfHe
	8g1LFCXPqy5NUEj09UG/Q6si+lqA2paCb5J8b6eDfHu0iLfyd8QJxewz5ct4qmSCVKGlfuI7N4Y
	TW0Bzxubq0rbb/eV+aL9SC1g/gxDROCxR1QZV6ntABPD9FR6u7i1uL1zTaBLhJR1Y3VwhkbooWw
	gcx6mTVyJG8kbabzQVqnkOrCs7Oy4BJxVsdnibnRusfmPYDwYtKSJJOOXVDGPwJJPS/o9fshDsI
	/tOg==
X-Received: by 2002:a05:600c:34cd:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-47ee33117d3mr49883055e9.15.1768428797424;
        Wed, 14 Jan 2026 14:13:17 -0800 (PST)
Received: from blackbook2 ([84.19.86.74])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-434af6b1455sm1617183f8f.22.2026.01.14.14.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 14:13:16 -0800 (PST)
Date: Wed, 14 Jan 2026 23:13:14 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alistair Popple <apopple@nvidia.com>, Byungchul Park <byungchul@sk.com>, 
	David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Brost <matthew.brost@intel.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Rakie Kim <rakie.kim@sk.com>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Waiman Long <longman@redhat.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Zi Yan <ziy@nvidia.com>, cgroups@vger.kernel.org, Yury Norov <yury.norov@gmail.com>, 
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] cgroup: use nodes_and() output where appropriate
Message-ID: <qhobdtdwtkux7n5r3b64itvpe7zchm3ovpfmazim3v5ilg34kr@5o5wu3chh5b6>
References: <20260114172217.861204-1-ynorov@nvidia.com>
 <20260114172217.861204-4-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260114172217.861204-4-ynorov@nvidia.com>
X-Stat-Signature: wndcs8hkn9acuy3b9bqhb1x9nkz1h6r3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E24CCC000A
X-Rspam-User: 
X-HE-Tag: 1768428798-320309
X-HE-Meta: U2FsdGVkX18crZ97iRkjVF7TDvK0KfYaYLSFqV0YBiXozJfOU18z5FFsQleNo8vMtjjJAaPSZwRVMBqf6+cwnJWvy+BJSVURIGJKVpwZjvQ42Bn2WMBRt1Yal+ftkAaVEBvdZRKRsabKw7o4jkN0zcEEPcw0J0dZxiG0cWaQpIYPBPrQle+8H/1XMBK42Yf70Fra7fzxYmzcldzZcuWKQosRFpwoy2sIxv1ZlFqSZ1FUjJu635tJUy5A7kRNIrUfiwdtN+xzUBn9PauUDgrqm0+i+iSshe8buWOXJIHdJcIgZUfKAg5oNdjK81pwCpJI5tdChJCqUtrzig7T0BsQ0Xg/jCkJi7qnF9xhBhywHEakN4qcG2Jb0YyKKWcXF2DqSaMRHULCfcfN/oX3neNxIy/yHMuNsZ+A9oHfBPcX3UdWsugZc15lm29+I9jcC6TRoIhSyVklEVp3xJ1kwiiFpOjUb3z7vyCm1DnbTbCtwN6oDDkLSZBx+FEOo93E300fLijUFeRCiytZ1CstrxsnyRfLOdEWDx1zrbH/D5x5pi8Q4MbMvWTCuQeGe89tFuqwMOq+3gmZiUJ80HWHxe/CGNlOCqCxMZljjD+EEtClEozzDRoYVw9visVjr3m9gi/GeSytjNQC6kgHF/SabN/WVOU6UcJOA5b0lDa2rCu9+HUvHs1qQ5NRRPh7OGY8pwAkWdjyMJpZ9+GVvlcaFyYyfDp9mGvO6zSOr9A2icxFYiN/V/wwigkN2XjspfAZ5x58qk5eITiAz5uz7x796xZmyHIs5cmWTAodDqPvHLPZbjg85RkdiVNQkWlPDm4g/YSoN9wD5ER2nXLgpV4DL2kjRk+j8h/rtONcG5hMzbmPjRCG9HXhWFhdWzGv5tZHRWxwMBlDufZyMMn/C+M/dj31Q9uWcA/O3d61R5lnO0LdRrow56OOVQBUUibu7Wtc0ZVYkWIrI1HrX0M7tTvBXzT
 xqOB3HNq
 mf8LTuzBOhGjQumBW39O81fElfoQzLTxxXQfdPJ3XzVnyZd3N9YsLCLuphWgWz97olFtDI0LF2NAiQ6vgZW1MpmcrRx+zMBCDnGssDHUyKqq/89bWrQxxBRNqxQBNZVlvJ4ArUlPuQ+Uv8ztOJHnqQgDNpPbqR3DI4zneTmFWbRyJgNj3rBcYxiP2wPG6ZDFik5CvsPp+YZXt6aeJbGvtQiAUYT2ZV2g4aueyt67Flg0D5fvGOfl0S9/evd+WQMjiD4tBdGvCUQDgoSANJpu7qcscNNoETnuu/dCo5o3+V/oDOSZxlOF4jOxfrbsf4Ahk9tD/r08aqVKo6uA6r5UCcXis0hE+ikdz/p9MfeFsMWJRzjhsiUbDt29a7j8JfJXGhc/XZEWQH+mrhruR97Kr6MBNSK+AYFsiIA8j6cyJBeEu5osrecy4OAeMRNhUV68OJeIczZbvf3LkXhyAE5FfyqvJs75UR9EoC+1QfM5wVYFQG2GWZVo6//H4d71zZeX+GylVjIlgMsyaBMDAIL00Nimd+aNjRVbqaKfIblmgUqJOc6DxsUMS2F0ogA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 12:22:15PM -0500, Yury Norov <ynorov@nvidia.com> wrote:
> Now that nodes_and() returns true if the result nodemask is not empty,
> drop useless nodes_intersects() in guarantee_online_mems() and
> nodes_empty() in update_nodemasks_hier(), which both are O(N).
> 
> Signed-off-by: Yury Norov <ynorov@nvidia.com>
> ---
>  kernel/cgroup/cpuset.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Nice improvement.

Reviewed-by: Michal Koutný <mkoutny@suse.com>


