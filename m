Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D363EC01A6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 08:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8C676B008A; Mon, 23 Mar 2026 04:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C16446B008C; Mon, 23 Mar 2026 04:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04D36B0092; Mon, 23 Mar 2026 04:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB3B6B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 04:54:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DEB113BF62
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:54:03 +0000 (UTC)
X-FDA: 84576715566.11.DBB3A41
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 055F518000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:54:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ah06bRTP;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774256041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ogcl2ZAquuYNoAzauwvXFFTaynrHJWtFRV3iycnT4gM=;
	b=V3DnqCUcwy4m9G/nFsURdNMJQxFx4GM+rEswB6sS6G5FZlFTeWIJr7yN/AXLG8xgMF8nHi
	RC8bNBMd3V45OcsI4PzXgnL4fN9+vBC7Yz0cTNg1vk7Uue1v5dooWaopZvGvReAoU3dMA8
	YjR/JmDoV33pdH3JlA+3A/ci6OGB0JE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ah06bRTP;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774256041; a=rsa-sha256;
	cv=none;
	b=HB0oVLwrlHNW+yFc6P2i7kqkalpiuhKM3DbQJiVhSN3uVHNPgnJmfNVSzXeZOVUqc9qQZf
	pTnKOwfoO/QJjttPIQMQoO+UzGrlTZ/K98eLaHbaqYUkx46JW45ZtWDJhUEwMN2x5BZvj+
	2JH97nnY6q1nF2hoZtnvb6H9xFZAiCc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774256040;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ogcl2ZAquuYNoAzauwvXFFTaynrHJWtFRV3iycnT4gM=;
	b=Ah06bRTPeq9tYMrEWY7cW9aXKxEN2qN1RkXo1cdEUDHZ1YqvEzvDA6MKdccqLiBNw8q5fv
	wAF+LPD50cXbSGgJPtY2lWrgWViHwF08NPvDj8N58fK+A9Hypnc3/798q6tgRQQ+ZdQ/n7
	LbjYPQOklIDhLbV34617J8r2RLTnhBc=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-YwifE4NGNsmQNO-wmlo8yQ-1; Mon, 23 Mar 2026 04:53:58 -0400
X-MC-Unique: YwifE4NGNsmQNO-wmlo8yQ-1
X-Mimecast-MFC-AGG-ID: YwifE4NGNsmQNO-wmlo8yQ_1774256037
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-358f058973fso5707970a91.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 01:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774256037; x=1774860837;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ogcl2ZAquuYNoAzauwvXFFTaynrHJWtFRV3iycnT4gM=;
        b=qNSekmj5yueq7L99QvAJmNYVZpWE2gZHpmoDs36sTL/cYQ/zDqmtH7Fy0rKFN9DqB7
         UGrcWP8lXC/7LEWZNF7dyX/s8CLYoz0vrSwofyYMmPdFxKENio2SWyLVy5XjydDncJBM
         +MwRQv2SpUHm59EiE7DvgWam2tAdVaGS86pF3hWSQWRnVlNyLWRm/L9L+18ZMhRGvmZ9
         IhyBf7SgAOW3IDDUPV9GAQUjW9yMhof9EYwnAMLP3dvAIjIkSu36CLOnpWASkjAdsf6X
         KPwTBlim8+8+lsYoZKA5AUWOVAgxYNCptQ8XO4QZyFH94dTeu3gMrBHriQCxx2rXd0x6
         hfQQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9Kl73XFQ+Ubes7U/1EGhkSEMVzGUUZ/hGwuVRaKesjyje4pR2kYAgwQKyosbc2RFxci8ABmgFUQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+mCQs8FOTg7kugWEf2idTP/xRzpBmRueWuFm9ASDocigBtfO3
	/I4NG8C7WcbKCx65Sb2REkTzHMzldMuND83m//SQNkvPvtHOdDOiTis8eVxNEM96QPgp7Eyh7Ia
	5n+Fqhv8xG79yOePijewnSLPdTv1056JInFwekALTG68NoryVATpe
X-Gm-Gg: ATEYQzzHFW/j6mGVrmUpD/0CmLNvm5aJVGdUI17BJ2NgbOMzHg1Ur+PW6nnoL6ADe7W
	MoEgmxwDkqtpdNNCgwOesRmoUUncvdZb3MhUCkG0Qla5/pdE34yuYlF1JG9s22Rjb5Y7OI6OHAM
	e5KxNWkUX5UiOCLsuCbhGxntgZL5WGBpEtFku9gHs2G94pyfXLfN4ccWuoNHxITWRLNXLunReUO
	3TGIfT7mQvjjnwv8AJmbKC2h+4T5xlBtwrzZDXqq/LP15W6XCMd5GofYsDjrkdsvQQLiit6uNDY
	8HLGo8g/TvE1QH2SW1iRc8RlcOykG2DGDk8QuxwYlaQGVT3SZUrCMnLvns90DLStE6aOrS5HqxI
	Xb0ubMca2sDHFlETQZw==
X-Received: by 2002:a17:90b:28c8:b0:340:4abf:391d with SMTP id 98e67ed59e1d1-35bd2cb1ea5mr8848383a91.16.1774256037060;
        Mon, 23 Mar 2026 01:53:57 -0700 (PDT)
X-Received: by 2002:a17:90b:28c8:b0:340:4abf:391d with SMTP id 98e67ed59e1d1-35bd2cb1ea5mr8848368a91.16.1774256036672;
        Mon, 23 Mar 2026 01:53:56 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c743a7ff529sm7219812a12.2.2026.03.23.01.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 01:53:56 -0700 (PDT)
Date: Mon, 23 Mar 2026 16:53:53 +0800
From: Li Wang <liwang@redhat.com>
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Li Wang <liwan@redhat.com>
Subject: Re: [PATCH v2 6/7] selftests: memcg: Don't call reclaim_until() if
 already in target
Message-ID: <acD_oR9CmOkQFBZL@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
 <20260320204241.1613861-7-longman@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260320204241.1613861-7-longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F7wGSrSmN3qkRoHY6CWcCLftM3SRU-DJLcv0mYkJcVk_1774256037
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 055F518000E
X-Stat-Signature: cj11heenabj9o5ceh7mxmad9kmy5xx77
X-Rspam-User: 
X-HE-Tag: 1774256040-961629
X-HE-Meta: U2FsdGVkX185TjeC5pLNGt9KEvF7iUgvDdIoiW+YP5eztLVbecFxKPqxGOhLm0bRp+zii7/e6JhDvdTxsKA8fZStp/W11lXmw8CSYDAPCPlMeFQSjRitskO5nQA/EcAC8nwylO38jczTC1NR8hUrx9t2PUFRnX8PZnmH6+LQUleVpzSWcfgb3ia2e7mjssxPCpEtXJu+GGp+YOzxFobZJtZPGmi13EX6cQMFFDQyXDtMtXQML4uLvQuZnEhG7znu28Dlo9qyd2tvcBvYMEhEIjOoBjxEHo3kTAK2UMbbqBUbKnmwwDeGnQKVzRvMTXhE1HtscdK63/Dnw51SzZu8sBSMRaeYxH3VIB0wSYxo4cScG84mxq+RVhI2tGow5HVVVIRVn4vsW6j6VyZUJbsgQjoyuUN41PtJ19TkTYGe1BEHmdsH51U0EHv0ZNX36tGvKD+WVmt4Boz0ozeTvGUYarB14sTU27fc/xA7g8hsP8gIpZZR9Vc29QUEZ/F0cCdMbYEiJcgBxIbYFSemAYiukar/sfFFMu+e/F8myHjdqngDwLa421NNXN+X0Gti6PUZ/yHPvL91fVxWY70hezUSl55knYD59SSHTY2a7UDqsUczCXTAKDFh+ql6lgJFhXn2hxpq8DwXZQAVq+qBAW1x/hBs0FKGqAQwwP+9RSSgenwOICkcqh+U8J5FNqthkzMf3on3YDYJH/z6PG8GqSvp8KHfHat5kpTLokf+/psdpDkN05tIS0XVo+TlQD9sznyNkt6Aja1bgqEayBAAwkF9/12PKIdS5H0WK27NnWm/FNiy/hlSPhxkgaaQyI/W5v7M0yG9Vp2OSOJkT+DxT9hXwfkDG/dgsz4ig2Li+Fo0w4jP7MiNwu+0/DS81bxTUafy1CinpW3F1OVp21HOLeSzuXOM0D1IaMdF9WiIqxEzaRhQPoWHxFS1l+OLRDSGH9JM7+wCFsyJ5pYbRmE059L
 EKLiJS7p
 4S/WpIPDCjMgPjM2BGVfWvuSxfYi1eB1/S7d3qKg2fn3kzuQsdp27DNKgkDhBYg57Ok+sYohaKAroa9zkOhg0LmNlNLnNv+TvrPWvCSXVm2yeKi6xfln146IRNQMKE3rMp2GwugpyutQeodVLafPywUYc0zMpK8eCGWD3N4ceYAjvewmMic8pnXssLH49zJV28g/IpjhXJug8ED7oc57sNJnQZRImclaE2i6ZO/+4J4EUGm8Dd/J/PuvnRUrnbKnS+jMNrSvSBtIpBL38y5cMneTpetv5eVFzGl13Swix8DisgKGEmRl+URc2Mou76YbPNxrHbvDw5W1FqVnEx8ta73iqtyjIiggengSa5YpdZsE/6sCKZbxRRZoNEUGp3rlSwfvo9A+REtm/Owj2OqHVMRBNHIlva6hLP04FOtzZX5yFk7/E2fYlFe4KBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 04:42:40PM -0400, Waiman Long wrote:
> Near the end of test_memcg_protection(), reclaim_until() is called
> to reduce memory.current of children[0] to 10M. It was found that
> with larger page size (e.g. 64k) the various memory cgroups in
> test_memcg_protection() would deviate further from the expected values
> especially for the test_memcg_low test. As a result, children[0] might
> have reached the target already without reclamation. The will cause the
> reclaim_until() function to report failure as no reclamation is needed.
> 
> Avoid this unexpected failure by skipping the reclaim_until() call if
> memory.current of children[0] has already reached the target size for
> kernel with non-4k page size.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>

Reviewed-by: Li Wang <liwang@redhat.com>

-- 
Regards,
Li Wang


