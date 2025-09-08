Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3693CCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7893C8E000D; Mon,  8 Sep 2025 05:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739F08E0001; Mon,  8 Sep 2025 05:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64FB68E000D; Mon,  8 Sep 2025 05:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EEA68E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:08:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D29D4C0A8C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:08:27 +0000 (UTC)
X-FDA: 83865507054.15.5D2B96F
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 061AE4000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:08:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JMEPYxlR;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757322506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CXAkEc+0hbVrwg0zBjiBl7uCpRmywegXjmBSprSMPqA=;
	b=s0a+ax2u5kpTD9hhIYqLnd//gpA9CpvzRuDzHhxItyZimmQ1vv+WOkHT9qOUonC3rfN3pw
	Rumzde1nVQEKkOZ8mUMrhq52tRJF3AJzwV9iQBFewyCKNWLH9LbITkBB4+admWZuQcialm
	IQdr74oymFFz7FUZE0goi3QNrKh1coI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=JMEPYxlR;
	spf=pass (imf04.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757322506; a=rsa-sha256;
	cv=none;
	b=NclHUcSyMAUr8asdRuhnSOpLIETYpSd/h+W5fLSCIhA7HWmKfh3b8tm6c7OGkI6Hfc0DLv
	vfAyYFFUyNU17OwOIgAhg+mdbtw9tgEUykKTomuJkpHOVTdRergkKA1BKPqXoTO5aA2v17
	QMQ6Gpj0U1hm5oKAi/4vtw1g2hMhIdg=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45ddcf50e95so14556215e9.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 02:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757322504; x=1757927304; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CXAkEc+0hbVrwg0zBjiBl7uCpRmywegXjmBSprSMPqA=;
        b=JMEPYxlRx+LLQp43J+nJkO44frABvD3r8Eg9hfoEntJUixHheaemv/hWJM4PXwswMh
         +Ay6+UazBYHesC0NonIWezbjrOGpmL46asg5d9GckAn2njsz19f8QiiNT/k2KZopDcxS
         GZIkwvxVKAtTxABic86sQwWcRcanx0361If6KM4B2Qjga80FIicas7ozJ/iYSYe/WfaL
         dbR5Z4toclHAQFRNd0Ou6b8GR4TI4qlK9FcnuOylWMHu+eQ5e2v/4pHbnM5lLMpEbke5
         GN8o1ktmpFoSzuJELy2yPewko5+M3nr6jEl2N+sgW5ymp8tFpZNiGhxRUn77oaZAYkaZ
         Dy8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757322504; x=1757927304;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CXAkEc+0hbVrwg0zBjiBl7uCpRmywegXjmBSprSMPqA=;
        b=ahyFRSJ9SiqQqhpAqhZvJexRlreBbZcL9xJq81cqdAdsJOUC/OQ3Xxos9t63Q03Cnk
         FMIOXUpzJD6y7uPHiX3LdbqAzJg1oG9H6mLASWZ6bLXculyDqv6gwWHx0z6I4vhJF22y
         R8MYijq1UCOJhXxadTImFCtOpwDQa6ZKBGH1k662PWslruadfNAX7x7B8ZUmxJ3fTlyp
         eZGAPJ2RAVWKozejEK6kSlfMwHBbH6hkudl6i6Axd7R83hoxWPRvQzSV76sk4JOUZ1+d
         SgB4qkW/H9FM+0Fa8JOwlQsYSitumVaw0RFahuT3Hk6oLcrMaDbJ81IQJ0dcta0shITS
         oswQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5OZwvIUmmJxuITzT9U0cwUVdWlgvgfFVIpks4514mYbiyoKKsGKTjsNIdwTreaTYN2QAiiKLr3w==@kvack.org
X-Gm-Message-State: AOJu0YzzgBViOgr6Avrre7bSJSdBpQPOGP8vNryr2r/g22b9ss9NPMN0
	uAKTs0bGQWZ3Dnv68XXJtZm8vi0ioRakJv/e0yZtT0Qu6bnUepwPFKi7JlEYackh4BE=
X-Gm-Gg: ASbGncsR07cl2wcZxS3yhLKeMlWhMOjiOIzNBQGQQr2O0UBs1QPyn1HveHokYeKTISg
	Zzf0OnXYUSkHRRkEXItHFUEOhU854xrf2h15dmL2Qbco9oEPeFq6YnaM7yjHOBof+3NYLH2IrSR
	Je4kafTO714ZJ/QJs1nOVAmk+jfZeI84YnnYZSnCoVi3V46d3QUGzipTsLHdysTs/IZjjxodGg0
	jabycWAn+ILJM3v/h/uFyhHhuG3zDChq3PunXXP/dIcqT3pALIH7hXWVE3Sqh6IvrpNBn9kQy3+
	2wm+8kpi4OfhnNBSWHKlol6vFtGZE9WZZvW54eHfKh2/0HhFDUxB6RORow7I1Gd/VQSddpINz1l
	aRCx3OEkHz/63xHd+41UD5JM6GZyoPw==
X-Google-Smtp-Source: AGHT+IGjCdAP8Med5Uz3zM88YDI+0dw+kFhTAhqv2XIHSPraXCW8PtiZpKcSe5HEkCIs8k4Yh+M7Rg==
X-Received: by 2002:a05:600c:3586:b0:45d:d13f:6061 with SMTP id 5b1f17b1804b1-45dddec89e6mr70135545e9.30.1757322504380;
        Mon, 08 Sep 2025 02:08:24 -0700 (PDT)
Received: from localhost (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b8f2d3c88sm300994075e9.19.2025.09.08.02.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 02:08:23 -0700 (PDT)
Date: Mon, 8 Sep 2025 11:08:22 +0200
From: Michal Hocko <mhocko@suse.com>
To: Peilin Ye <yepeilin@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <aL6dBivokIeBApj8@tiehlicka>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
 <aLtMrlSDP7M5GZ27@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLtMrlSDP7M5GZ27@google.com>
X-Rspamd-Queue-Id: 061AE4000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 77rrk14dgbc4jrj7q685ffqootwua8wh
X-HE-Tag: 1757322505-885854
X-HE-Meta: U2FsdGVkX1/1QIcJL7lseEeGjAaqMymIFG3eY+36x57EOyGJqXb96lDsyfzqUpR2CH7yDay42fIMe/YLRvk6IwCTxK03/NF0IHcYlV2Z3IUpPqljxFIRIq4Q9fnk5MDRlNc44kZMAyR293rSR9+XukR2P4Z7l7W4iqkyNDpwHpvi2/iAYvcsf/xL8s66w9Y3i+aKHAqWx4tgYJfwhVE3xaFh/9WgblEHPvn2OXwQGck0YOPNfAdI+57uOmFpIkAl/1vtZhCiA1zM9ydwCgmp2G391Vj1M5ES4/GeOqfPtR4xeyPnuCsjTTOOVih4Php8DqS8FApIxoHXZW3TUYjT3L6EvRCjO8B2k9MJptoJuNMgStYT1OraJBuIYoILzXLYi+eX3gLzZXllGbXLk0UR1I/6CPld/K+PJlEVpE24wPhlS6bHo2OIepaJSGYaANOs81DOftj4vShDiFkvw/0RbequQQ3ajcB4krHB/M/13LyiFZgYe81oopDwefChFRzo3jgW+Um9zBj582iCBhcLrFT5hOE0kwa+jlJJGI6T/3bnmQLVg52B3AqDRWTEqWzfBKinoYOeCjW6wy7wfien6kjaA6nd24m5pnLpLN7azi4hHp+hCxXxQR6iLzUh82aW7Prm9Qa6IEnYecqgMFxz67+BCi3v3vX3fgcCnfP1KJkTmbWg0vspPq7zJomeCKZzSMIbrA5TW9M7XGOLP0h7GlPs3svwO6R8VqDh3knGkGaVyDBtl5lB9TwEQ6Pa8Y3/EX4/lh9KbzNpoDemQITo2rpcgIW1LxAtrhSWTmv2xDp/Pknxgc879Qe9+YRglQmClQlQkWbFolLpKCdx9mRxJ+we4ociP/IsTnNoGz3iE/3Jh8nA67maMDMYV2IZ7iCU2Mlu+cv2KDYMvIX9uscJIo2vv+ORWSAbv7v2h1pQvzBpzTSFWW4kj+isxzAYImob1bOGbeNBlsCiDa34py/
 VJ+T2R6R
 AaGT+gm/ZLFedTW0pmeJOp5PH54wizmYRMi93osdJDgcOVeNMDTZN9lznBfBoMYX1xe2P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 05-09-25 20:48:46, Peilin Ye wrote:
> On Fri, Sep 05, 2025 at 01:16:06PM -0700, Shakeel Butt wrote:
> > Generally memcg charging is allowed from all the contexts including NMI
> > where even spinning on spinlock can cause locking issues. However one
> > call chain was missed during the addition of memcg charging from any
> > context support. That is try_charge_memcg() -> memcg_memory_event() ->
> > cgroup_file_notify().
> > 
> > The possible function call tree under cgroup_file_notify() can acquire
> > many different spin locks in spinning mode. Some of them are
> > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> > just skip cgroup_file_notify() from memcg charging if the context does
> > not allow spinning.
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Tested-by: Peilin Ye <yepeilin@google.com>
> 
> The repro described in [1] no longer triggers locking issues after
> applying this patch and making __bpf_async_init() use __GFP_HIGH
> instead of GFP_ATOMIC:
> 
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1275,7 +1275,7 @@ static int __bpf_async_init(struct bpf_async_kern *async, struct bpf_map *map, u
>         }
> 
>         /* allocate hrtimer via map_kmalloc to use memcg accounting */
> -       cb = bpf_map_kmalloc_node(map, size, GFP_ATOMIC, map->numa_node);
> +       cb = bpf_map_kmalloc_node(map, size, __GFP_HIGH, map->numa_node);

Why do you need to consume memory reserves? Shouldn't kmalloc_nolock be
used instead here?

>         if (!cb) {
>                 ret = -ENOMEM;
>                 goto out;
> 
> [1] https://lore.kernel.org/bpf/20250905061919.439648-1-yepeilin@google.com/#t
> 
> Thanks,
> Peilin Ye

-- 
Michal Hocko
SUSE Labs

