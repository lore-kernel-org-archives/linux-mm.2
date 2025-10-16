Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C12D2CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 18:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A598E0006; Thu, 16 Oct 2025 14:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB188E0002; Thu, 16 Oct 2025 14:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0328E0006; Thu, 16 Oct 2025 14:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB9708E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 14:43:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6878DC036F
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 18:43:51 +0000 (UTC)
X-FDA: 84004851462.21.EE1E002
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 35DEE1C0013
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 18:43:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fwlfK2kx;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760640229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZf/xOnYZ5AB4g+Afgo4f1SIJz1a8qeaJvzviov59ws=;
	b=x/xPfonpqgfvlaUhsWvLCsqd/K/qRa9cgb61eKfyw1jbMX4ABrnXa+mFyywtOLMJDa+lNS
	zxijoNXSE8yI6hWQqk0XCyV1JD1Ab3tkZZTUKb4z9PsSdWLYwDBBYx1Ob0itGHFssDYdJR
	DF2hDk5rWYvfySsk1XauCpHJPJGtM14=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760640229; a=rsa-sha256;
	cv=none;
	b=smZDyca+7zQu0eunRilcADu+/qf4PQce83l8kLGhlqtz+G8suJrMTUqSbDTBz6Y4mgoJSd
	2d1ZL1eLCJQCz8CF0xVkf/hNbIC15qv3+8L3WqIeY+TJxQuFq4vVRtXJEjyFyapjMZNDIH
	M8pmOM6PXQQdwle7AnVvpqDvvyYsW7I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fwlfK2kx;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-426fd62bfeaso490049f8f.2
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760640227; x=1761245027; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sZf/xOnYZ5AB4g+Afgo4f1SIJz1a8qeaJvzviov59ws=;
        b=fwlfK2kx8yDb3PoZWSAp3rjrSCsikHWId7ai8k4WkE5S8xR4ZAkfqRk4/OCSLzhFJT
         XEUe050IyTsix55GLoBFi05dVzmPS8jDaEUA8snxYqC69SDFJwFcFCzrou7yJLluwVB4
         +HLo8kSTakk913xH7XOGtwVngCVoEDBg+amXPh5a4LgHN7PLm2Nelc2dl0tkBqnaVn66
         oQdpl0M7GyOK4PMt3ozocDY+NrnvuuPdB2proL26/U8lFiVBzXcbUNtStxnRUWuGOsT7
         tfSCHHE0LHA8Dj5twmUE8YynPnCYWs6p2hLoD0LgAXA+IGtVR4dtdUwzIJJQ1CZrwhEm
         7mHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760640227; x=1761245027;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZf/xOnYZ5AB4g+Afgo4f1SIJz1a8qeaJvzviov59ws=;
        b=sRGrUOXvv4NQWbUePlWZU1lwdMO0PPfUPDvYojda94G6LfGplEpayONSX3PGvEVlVY
         9whDn8h3xS8koC8TbdJZdUq+wUrpnrfsTt6hdkyIc/X38Q/ScnjukqPzeJWQqhfCcazp
         hAMS/mjJ7BJ891JZ/92YaboRWtjl+X20HsuZFQW7weCow0LbBCMkVjTbmHMH9iZWTdGA
         KKYJpJz/LTKskdFBoAnhl0T8EtJW70CpF5TrmMgeoWTv30NwUsSZF3TrAmi5EXlM1cSl
         GuYxJg7dKHShDAPPAfokyugqvYkoznJuQRVDKVwhOaNxN2dBY0nSpE9AAXVAlhOPBdM7
         VX1A==
X-Gm-Message-State: AOJu0Yxqn1EGPN3DpDkFqvq992SzOUeVM9rYC0Ke8xGoooP3G0mbJWoL
	okJjsNt92bFZielE5VhjAxlg52IgJ5LuSB0VG3TSR2GA5Wq6RwTGkmeISXt5ankcqow=
X-Gm-Gg: ASbGncs3Tf28/jlH0nXHA7wm4dE9I96YmLwOBjMYB6wpT23bogRm+OKmgHCuZGsAJj7
	c5spa3gmQtikUaSZq6uVv6IuWWmvQM/lXB8a4MFSKihzQ77Y1yljxu0DRA+acd44Y+SIk4+pAtE
	nWoQSb51NqYAIskcRv2j3uXEIrHM+bEHiL0LjfSCUY9x+OXQHGorGa9FxbH0S+i7gDPp4tNk71r
	X0EM0kJ7EDslnR174C92hzSw5TbwJyj3uLl4GInvHjxHh8xYqhZWj31Bk1XZ7t5vgcHQhbcPtjG
	1TakhNhRCIQ0MabCO1gg6uQO4RfWm5Hne99mCfFVzTfyDXuNuFUonTL07BEN65dZPklM78Kvakw
	S4t8AovLyC/D5qSRe4AlWqRM9PNOiOG4+JXYJLucfyQOt42GaZnQYLbAaxmfxqlXxYtShY1feMv
	fhJOnY30MA0hs=
X-Google-Smtp-Source: AGHT+IGo6y5lk13djMjMMq4R3viE+pYB2nSrAPV8y+Kp8nAdZ4R6ve9ypzaXAl0LPNYCFR1kJAQtiw==
X-Received: by 2002:a05:6000:250d:b0:3fd:eb15:77a with SMTP id ffacd0b85a97d-42704d143e3mr765616f8f.6.1760640227495;
        Thu, 16 Oct 2025 11:43:47 -0700 (PDT)
Received: from localhost (109-81-16-57.rct.o2.cz. [109.81.16.57])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-471144b5d48sm41689115e9.9.2025.10.16.11.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 11:43:47 -0700 (PDT)
Date: Thu, 16 Oct 2025 20:43:45 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: Add retry logic for cgroups with
 memory.low in kswapd
Message-ID: <aPE84XfToVH4eAbs@tiehlicka>
References: <20251014081850.65379-1-jiayuan.chen@linux.dev>
 <aO4Y35l12Cav-xr4@tiehlicka>
 <a6cd4eb712f3b9f8898e9a2e511b397e8dc397fc@linux.dev>
 <aPEGDwiA_LhuLZmX@tiehlicka>
 <46df65477e0580d350e6e14fea5e68aee6a2832b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46df65477e0580d350e6e14fea5e68aee6a2832b@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 35DEE1C0013
X-Rspamd-Server: rspam02
X-Stat-Signature: 18khny3obrr5swheygs5mtn5i35a6ygp
X-HE-Tag: 1760640228-531403
X-HE-Meta: U2FsdGVkX1+xbmxJfSWe/vpv6JhdWMv/SFkB5qD7fjEvCAJ7NiG7lfn6Zi3KGNRgtfbsNrN+Ry7BpeoywBHDVM3/OHtPfjh2D0LF0R5sdH488auv91Y/KQz0QnkVz5SX0RAjZ4OLXulnZ74q3M9Nif4LruP/EtAyevCC+Px51FCvOz+re1sE2BI8Hx8TX7XXobyqNztV75d7Zj0odJU6OJ8KTTd71d9ZZ+qGO3a5GvKlLu3OqSE3wlRBp2O0ShB+HktchAlKNPo2i2xqVATGU+wGYpCSfuQJg8C1DI5TGm0mXxsUCjvF1HXgQn3R2lUJ2ZvwNrCUhF8xpPEcv1Duq4+lkA6B8KyEhpb0h7fFJh7xedI9SGtl5yJ8KaJbBStJzQMzbpg94oBy6YwhK9nLkl5Fggeyfg4nZblGXTCvOfbWGcNkfrSWQnFYaiAlTh7C+1WL8NmioIgh9/IXxfezYfrLZd5Y1Zliq6phiPLBkuZQVurkuspM4aAgcIDvUvRhAGaR3elnt6gVpkuOLKlRT/gk4/AmCR40D1Ncx+JR23RFAfNDVMovRI1RLBQv4ZFAFGknS12VXXB4iCbETnJSVBUqAzdTHlL+rsTCPYZtSbhh+43Z1bSFnC5Q2cp4k/qJhfdPkXHS+qS5vb2+Xvdr3HZOSLCw+oabXcTKuriPY6IGSx+Mqnh9KF6wccU6ZowCQ85GeSWjpzi7XCqDlanwlmU0YELLwTsYlNRYiP1sclDbf27GC/imzdSJQW56lYBIxuxomBJeZMAS1rZmr75qa+uoLpZmgr3HB+S0n5AJddvbWSr8ofmWHwcYWHrsvkN4LjSGVO31QVlcYUqVQhbdCJbQSfA2dn3Ws7652uDZFcu5C9cwMrV2X1EONCqfzJ6M5xzXORnxe84t5zTgSzCp5H0mIfll7F8ItwYNuv83IfoqlpieRo0RKSbG1+INQ4ElOdTD849vPbgT2gwGLC3
 ovysSxq3
 gOlr01DQa9a4VULr0+vQfurGbBid20yt/R6YB7UnagERd5hmIDQPk/fOQEQW9PUZ8BDhbFc9c5kAnfShCb2ZNPaFaUiSWYCicsx96uOUTO8fJC4r0QuA0xWrXXYJtqrNUz3aLX6Bco0RgN62RNUysxSHergTvGjxNn0/uYwV3lX6TAzLWI1yBynWenfHv4zkAF+ytaM9NrQNxzxhwj3PqFfduj6eAhhPgxh0uruoxajIQk5Bgi3DmrODEBjccOQOAZFpIt25a1Cm6p1U/uLkRdgVC8Pby4rubyykJ1vlTplbRFDhj8FKOLEXN1QBmIzX0PIBR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 16-10-25 15:10:31, Jiayuan Chen wrote:
[...]
> The issue we encountered is that since the watermark_boost parameter is enabled by
> default, it causes kswapd to be woken up even when memory watermarks are still relatively
> high. Due to rapid consecutive wake-ups, kswapd_failures eventually reaches MAX_RECLAIM_RETRIES,
> causing kswapd to stop running, which ultimately triggers direct memory reclaim.
>
> I believe we should choose another approach that avoids breaking the memory.low semantics.
> Specifically, in cases where kswapd is woken up due to watermark_boost, we should bypass the
> logic that increments kswapd_failures.

yes, this seems like unintended side effect of the implementation. Seems
like a rare problem as low limits would have to be configured very close
to kswapd watermarks. My assumption has always been that low limits are
not getting very close to watermarks because that makes any reclaim very
hard and configuration rather unstable but you might have a very good
reason to configure the memory protection that way. It would definitely
help to describe your specific setup with rationale so that we can look
into that closer.
-- 
Michal Hocko
SUSE Labs

