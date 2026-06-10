Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9D7FCD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4714C6B00CB; Tue,  9 Jun 2026 21:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422226B00CD; Tue,  9 Jun 2026 21:48:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F776B00CE; Tue,  9 Jun 2026 21:48:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28B286B00CB
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:48:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0B061C318D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:48:16 +0000 (UTC)
X-FDA: 84862317792.04.AB65CED
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2E98240006
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:48:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ObND1Cp0;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781056095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V7uGDT/wO/h2postfHb76XgCexw5pCTGWL/5zE3J3lk=;
	b=wejS4GIvo7NaxO5/AbF5OurrNr/pODk8ZVefO46iPp9kKRD9Tu6PiwlXqh09PayWOYHQ+J
	A1hr+VhF4ocZZZscrMsrGUVDondbOL+e5XpQbwUHJEMqEehQM1BacHkOWskcrstsSOlrhq
	4GLNM76THyFkpsm1xpAp+qcB5Yc7GmE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ObND1Cp0;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781056095;
	b=enBaYOuRb8yQvQr3BqcR9vAltji08VVIRKsYOSr9RQ0HoNvBTqGfNIwZXuBi0OWuH4OyZ2
	Qhr/VgSg4G/FUUeS0CyrLCKNO42DeW85mz8PsVUh8oY4uYXGSgRXm0uIh5vXFpw109fOdy
	jm7Sa25ntYUVtqT2C6aPKiipb3qFsEc=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9155183b42cso811047985a.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 18:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781056094; x=1781660894; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V7uGDT/wO/h2postfHb76XgCexw5pCTGWL/5zE3J3lk=;
        b=ObND1Cp0IyyP4XI1RbYU6TBDAap4n/53wNTdR+GKcvQRmfcq1zshKd47PhqjuG/C4d
         AGPDSBASMy7I7SLQzh5k46s+3V5UM37YPEIDG4e3DYI6uuLgSgaLLuhXAgwu94bDH82P
         QoiPPbl1O9xo5lfiZpciVnnvRNbN1iQ9ePQ6dnL6/vo7Uhb9iiJE6x5AgCoQ1JK9SVOB
         VKnj+MayQNuZZwlfASoiK1Wv/uzT5KCTteyZDG0e8vQFKzx5/NmLiggT/1n4VvVRByQW
         9b8nCsvWeKHilkcxZ9oAz2XaRh4CWCRqHMlqyVEiLzhJDKeW1r9uSZXnzWOaD1iCEm5N
         ZzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781056094; x=1781660894;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V7uGDT/wO/h2postfHb76XgCexw5pCTGWL/5zE3J3lk=;
        b=R6P2bvw8NBHArypn15MEz1CRj+uWNpF2WEDVXSKspmVt2pLnTSSm+RSgh03mQEka1k
         Q7XybT6nEi57ynuGtSdNXnmxWCU/RCnarvYrWDMgWfmBVYp7iXfYD1eFjVd+csfDbSjB
         2fkYt2G4hJMfcIaIymcIFRvS8qgG5czo6kEMCSmjK6Jg7RISVgMuAA7tZiFo+Ck+PuUf
         zwAZXEQVyFRPfapwGoEeUXAGNua5FhVqs14AzotdsQzlo3FBBJp7P2yQ2T/Whj+DICAA
         FChkvBTZV2lVdQfkgjKN8V2T7kwvJPxsf/0mr7I2lKkCJGAuWd/f3ZHGRG2LLoG8+nw7
         lGgw==
X-Gm-Message-State: AOJu0YwI8LUQ2lGykYlBSj/M3oGyJitHAOSzrXZUPBveLxe4Q7jt8lsp
	LkstdoSLRpP/WrvrwciTDRQZR716z1HSs8P5aKThceU9xY8Pe5l5D4M6/IaS81iGWm4=
X-Gm-Gg: Acq92OHS/uFIB15lUxe7QcyyFFWNjeQjAC5kFfZ1buW+Sp2Wk/4cKMGiFudCkR91Ykp
	UeENssUIcvbM79GWnV174aQ9mE+i4ADvREWULjDK9IO549+Ng8Z0pn4i2umpL6nb4E4LQpqd30R
	6y4MSS36LxCIfymRllqV9F86VCYaoup374UUfnNWkkxaJmbcD0XPBY1I6FJaW1Idi1uTQsHFFNq
	7rC0VzWA4NG50/w7vyGxYSbe5r7EukPDJdIzIVZIKPr6zsp90IWrU6cQZi8z5wC3Tw1bKpWbeM0
	Ge2Rr4P0lSAS0w3qcnCMVY7R6BwB0wrNQOoodTB7nRwP1NrttnaJj7jO/KPFXMDpyY3TEo4hJXw
	RAHt0QrziWA5OSwuatd8+31qLwq3KCnQKbAe2Gecg61GcpO83+3UgN0ztM288WvUJLq/1xT3YvU
	DtoED9XFTP3633nAXjleYN/id4qVM+SDK+uHTPZQUu+krmEnMWgXMezrmFjWtg/+/DTFl0EpBcl
	m/sVfIUB8PPUtZWqA==
X-Received: by 2002:a05:620a:1a20:b0:8d8:697:1cf2 with SMTP id af79cd13be357-915ad2f7e0emr2592726185a.30.1781056094343;
        Tue, 09 Jun 2026 18:48:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a37cab6sm2274803485a.22.2026.06.09.18.48.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 18:48:13 -0700 (PDT)
Date: Tue, 9 Jun 2026 21:48:11 -0400
From: Gregory Price <gourry@gourry.net>
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, kernel-team@meta.com, longman@redhat.com,
	chenridong@huaweicloud.com, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, rientjes@google.com,
	chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	baoquan.he@linux.dev, youngjun.park@lge.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	ziy@nvidia.com
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and
 alloc_context nodemask
Message-ID: <aijCW3RWWX9_wccj@gourry-fedora-PF4VCD3F>
References: <20260609002919.3967782-1-gourry@gourry.net>
 <20260610001937.77371-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610001937.77371-1-sj@kernel.org>
X-Rspamd-Queue-Id: 2E98240006
X-Rspam-User: 
X-Stat-Signature: h45u9s41uzejymfoxuzsjk5p1937fu3r
X-Rspamd-Server: rspam09
X-HE-Tag: 1781056095-509059
X-HE-Meta: U2FsdGVkX19kQnR+iAgBLzaineo84KbZqrUgfnXstaTeH8OXtVv7d6Lhc3JvWu6wBJbgtT8+RpW688tpBLrJgAq8yIwsbfT2MEW9F03YeSZpyfeJiXlC9yupmVppr8H6ZVe4yMzjJfe5HfFrgv16cbpXKZp3Qbzk9ZIajJNkpIE7IS4OSTDKBW1ZE+OBT2a2reJj++jNKljeY51h4MVU3SDaBtR4uufO8K7Vo2F1jMoNc6VUAxwxkraWBa+hlQPnQCWBX1Fro1BHutlHggjWyDVVwR8X1cu3ZHE299+JifpKvcM59rkT9O5hBuUXPxI6DrFIs0ogYd5p0fkAsuvA9QH+4wPYQhAkguqw+501tU6MoXPfNQgOah6e5kO9jT03FPqHzcf/qHjoIvigzCl6yEYQXem88XEpF9EP6I8eLUYpOzrW/JvexlI3ImVUDzSFr3sTUDvfO3BsJXacq5HmThNrNhS1sIwz4GHg+TlbnFEIB2rH9m6Q8cM2i4+2GfMbkCrOczhpSHmTdvQBFIMR8Wbw6+bu2dM92+7NpJfqq6MmlhkDWmJtqG6MDVcf5OoCXQJ+2yJxMSfHAiDZUUtld4CGUPHZVYJaL7DOXfvMthqwEk+SLs85PXucq+C/lCVn9RByivY5ID6j+sufz71Wn7GsDv4Vo09/2YsMMpJM7J+UNfyBwNX4qpufJLv6Zzh3m3mIRTIhkOE8HWp1E6nx+oa5tw7DZpsO2EjoUQOWSkkKGtwsq0c4EnAQFekg4KikPQifU3fNNSmaNnt/YeW08PWyPNchKMXVj41Wrt3yDBiKe1ophHs1KA6J9U3TcxCMHTU2qtE6wfmFYwSqRjIkuBhdDiNU39uwxYNxIkFLiUhBwu6pBqkCywPGLZ1KI2pgzUbrRXYjAyxoFCefyru9iSOfOBHplgoe4WEkCdi83cJny4CpDerdGsNK4phPDkEt6fvMfu+qgKhQEcaHkhe
 tScs8jhB
 o+ownqGTEcnYW16KgO37/fZnNgjw0pEfwx+X2waPr5TxS7X7pFDV+AzbvYVGUHJYFSL0aTFJJg+iBT47fOjFs8PKW060LYNFdubcQvZXZreOm3gvFhOwac8ttsRphq6im3L4lDR0odfHugAdmbA2bCm1XD9sYIm6fUHYNEOUyT3l5p3x8HOLF8E0Yp4NZf0gffkYCmePN8w46iPtSkhk9GyKnHuGhxP5Xgg0rup3EURkXTqe4BseVBVaSOLoJz46YoiO8XkV0ijUN0E9f4U1sRHk5uMW1CfSCmPPIv51lq6G1sdASj6sTnwL4dOoXjdDvQ4JBYeQNxkHN3Mlaf2Ur8Lf5kcA0mQ3JkI2LdAaC651L4q5WmDXq1ybq8dd8Gny8p1Q7cdu7jVrho74DWnGKYHvEgRVQgCX9vd1oaOgHnUF6VphDsWluPH2Hnc7UwFxI9NCY3WtGMfiSwIwPl4kK5fU0sedM6i8gMjBjJbWOw3PJ3L3XhTnulrz5g4ea0GLWluNuufBrIFUFNTE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 05:19:36PM -0700, SeongJae Park wrote:
> On Mon,  8 Jun 2026 20:29:19 -0400 Gregory Price <gourry@gourry.net> wrote:
> >   */
> >  static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
> > -					nodemask_t *nodemask)
> > +				    const nodemask_t *nodemask)
> 
> Seems the above indentation has changed for a rason that I have no clue, and
> also introduced a line having both spaces and tabs.
> 

It aligns the const with gfp_t on the line above.

This is a common alignment throughout the kernel for any function whose
prototype spans multiple lines.

Thanks
~Gregory

