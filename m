Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20DB960A2607
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=oN3nKQsD
Received: by kanga.kvack.org (Postfix)
	id 934716B05B4; Sat, 14 Nov 2026 14:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B3F6B05B5; Sat, 14 Nov 2026 14:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821B46B05B6; Sat, 14 Nov 2026 14:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 503846B05B4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:56:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C5A2C1C3A9E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:46 +0000 (UTC)
X-FDA: 85434782412.11.FFBDFDC
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id DFCAF20002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:56:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=oN3nKQsD;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.41 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8tQe57OZTUGccU/0PYe2wABwR56zJWhJyWxH7qncio=;
	b=AFBpbupY/R5U8LJ1hCJfYcumDRjq2TpPSTBGVJY3a/yGo0Anectg0mjQ2sPJKhnmjWvuuX
	OHHmJfqo0W8Mo7vjBoIH3KD0O/c8CEVZjW+gKNYf+GIYQjT9+poknS5rbEHeNTwb1qUSQX
	8q8GzJlkRCY+4cPxt26cpnbEePfswgc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=oN3nKQsD;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.41 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686205;
	b=E03puKraA2H92mJVo4YSQfNzwb4erhHzj7XENeng2JZKDaVq2fyzTdHstJ7SlJmszk94ZU
	15mi26SgU4VWkGRnc9rxK9ecRbMQg0C/vcEGCgbqYaiIFZlXUDroO59FTTroFWwmmpfd9W
	eXBA2L7jdtu54vulGsBiOjuavVw+YMM=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ace1f3897cso1113549a91.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686204; x=1795291004; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=h8tQe57OZTUGccU/0PYe2wABwR56zJWhJyWxH7qncio=;
        b=oN3nKQsDDG89px3fELE2vwSlCqxeO71629Rpmiad9LjBUj8OGX2kF2nTkDzG52nj63
         3SOqFIJjE6xYqZx2jN8FbP9HRb+R27G8TQRyvlBNgVnO0r9WwSQiuB+hPPuZ4ZPZmGnp
         PkhaF1Ig+JN+oss0HzYbo3y2GTlH1CiO2VjO0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686204; x=1795291004;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h8tQe57OZTUGccU/0PYe2wABwR56zJWhJyWxH7qncio=;
        b=MH/y+jHzLnyxK+HNmBJaKD4z79vS4LySmgSI3xK/T6IMpGfdMeLymt2Qj7flSpIeQ+
         46ND1ny8NP0E1fMBykM7UIng/LaZEl/tGby+fM5tyuG0tKKY/5IroGKfpGzxfYTNnpUG
         rZCWsVzGpQMv0jZ0+Q4C6hS0N+c4q1T36YpagvTIYGbKI7BQwxiG23YcUGcFpVqXAT60
         yrUdpJt1/JferiyLmv6vHlXo5jqWpdHeQZK661wLeJOzUfpvy7r1xgqz0doFzWXTjTLY
         Vk6cO2JMJxMYdV2BQGc1anhrD57wHRBFmWTbkn/t3zjMCoQrppSgkpYOyKLM2lLjU0K8
         lX8Q==
X-Forwarded-Encrypted: i=1; AL+hErHtehHaNlFeyWWZbFWq3nXxG4iNgJ3jZiUBt06m0lN65F/Ha+0Y9Asg4QHmV1gutB+nrR8afpLl8A==@kvack.org
X-Gm-Message-State: APuU4Z/B+K75jS/hCmpqErq/1cyyHm+QEbNJCftG8mDrFo6O7opnqoTl
	NIDvKu65hZjLNfOJKYmST7yf/4kuHEtEVxu0K5llH96wmO9lVkxAfdVe0jH8UJvMefg=
X-Gm-Gg: AYBFou2tmUvUqXm24NNxf2IYfxn3n3xySm13wcv2NO2WNlAmTL1HOlQm7bNhTiLXxMU
	6C2nW4Vx7r9BnZv4EAbauDcGmnb/QNrWLK0HNv3bww34ltZivZ1ls4Gt9y/eLtnNiLD1ouPK0Lz
	kjXLUpzpUIHXGdlXC+odMg7YE636AwpjlpHl4RJdxn/dZ00j9rJ3Z2JrPxokoeVCswL+yi34nmI
	BMNAsLV09ArcDrw/CYuKZ4IoTzDUyMZXl+ZCl3NGP+uNoVRrI7WaJYG0gaeqL1sAqxo7ti923VI
	5h96uydX6Nc7cLUb1sfYKuk/la510Pmtq1UeplMFtZFPZAfnTlYUHfR6ih6iOq3kvFZ0T2UMYkY
	gUAANXHfC7mmH2KHIMgZ7QM2QOpsgGVVNSBaZByi3yitx7HAIZxP5cITPkg4hTCawWaoDYTSwtn
	zBSge2Ykz9K1p0hBCrhiU4dO3bcg7K0BGmPncBFj5aN6R7mXzy0BJ4zhfpWtX43ASnbh3xrellg
	i4yfpgzgCAmXDJlnT0tChKf+xmT91VxW904jQq8k+Rpz5r+DDk2QHGohHscyTQ/D0uFFxSUgMZ0
	umKCj1TzfBPeHwTgn/gLzpv1tzuvZ/At+/8AKf2gpuvBqYTYod9rR39+xsiVW1bvN2/FJBXpgOw
	0sbtXRkokMir7gnuoQw+RPSB/HE+6gJ0w1mHM9DUhYXppcm0cHzuZ0HPn79t6aE7CCRmWc9GuNN
	s6RZoAnMMAhmjg18lQ6fih9+q8tTaGVqRMwmEU553Gc4L4s01gxq29KMPb
X-Received: by 2002:a17:90b:4a48:b0:3b0:a970:caad with SMTP id 98e67ed59e1d1-3b1b0a44a42mr5984883a91.28.1794686203709;
        Sat, 14 Nov 2026 11:56:43 -0800 (PST)
Received: from [172.22.0.2] ([64.16.22.130])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1b21c609esm4089149a91.0.2026.11.14.11.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:56:43 -0800 (PST)
Date: Sat, 14 Nov 2026 11:56:40 -0800
From: Chris Down <chris@chrisdown.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
	=?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 03/13] mm: cachestat: restart the walk after each entry
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-3-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-3-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115640.c707f5c9496fcea4@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DFCAF20002
X-Stat-Signature: bpjt8igmwnoigr3k5iqtk3gp5ku5rrwu
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794686204-766932
X-HE-Meta: U2FsdGVkX1+pyA4t/Ik0NeglELjVoCFsPYh/FE57dQab0WFnF598N9fRyTL5bYo/px7r0rZlcsVrup93S5QCCps1fn11tj0PhUvXDLEmBB4a+GSaTyNeeDOpe5s6rpIYsjwJXPKhD9oQLdA7DwbbVUJvRlErcINQ6jg37PHSVPhI0nK/S5S5AifBVXQmrN/lTrZmIrPEQIYXSPtCKmrdXNgr8Mrz8NVi0kypuYoxPit11lt07DOvQ127t9i5iAR3TMqnflFScgr87r9QNDSAfJYWEH2zfOnBJLDUBevT7kj/cqPKV7dvZyIHXFTOior/qw87l/k2itrGvkvI0fGAKOKNdS5Sb2LbadmCe2hZoXT/MVTkJrL0qCwyWaZ4kJ3vK2tcpaEZU2maOaN6ulYfaMyzNzU81r6fzsaqU5ORzt84uLKgm3r0/NvEZ46OVvxIXmRmRArrbi96DgJSvy/GsN2nFEencvLeCMZtdG7EwQr7FrEXayuCKiH1twHDp6YTY/DXrJCWVJvt/DIXLTtJf5UnFUyVruLENleHUlWijZFOx6muIyCQxHxSL08YqloBB8B23TnBE5j2/H7H0cpmFkLAxmpQyRTbC/5y8vGzp6BN1FFH6bXd+q8JakU9UjaaeszAgH7UjzuLdJheGV9zBCxM8Zj+HVVENd4niVszJGZrbH2Ipg+QU2U7b+bPcU7/xV1iQnTP2aDRxRAlxI0QsRtQR2J5PVo0bVQL81/CUzhke/kXgmTt2bkujicz9XG0T8T9+0OC9WI144ST9rEEUFsWvD+Hm9mdU1ra6UN7Yo8OYxL92K8L478ioN6xWLwdGdJjBGqgdBFGjJYlX08BXOAqcDknMzyRti9HUB4h+bQ4/KZ6zBUhWu3Bt+F+XEE0Ml8c+lWoiYpJ7D3A80urnxjA4HT05SBNfdaZZk/KPWJQZGXaSkpeWkSNclRQxM9BTt3Uji57sWm0pyTFbKU
 bvWeLDPI
 mR3Vdtb8mejgbD1uLACVLx929bKAWKPCegnF6AxH1i050QfAuFODgmD75drCS5vmNPyE2U69FBnx6aFfiwFhBarjYUCJrhA3ceOhmCiCd7jn1D7MRxFVEIcXW8w73vIptF2ipD3LZYEgL7ndQ8UGkAtHM7NH+CaPa3CKhJuFsTzrqfCIy+7nkYNZXjiSQ/lSaTbuUd9zxnwnEH9TbjFdewPycbBr4Zj+27BTmUIU+bxVXhgoc9X6cRCcp3Iar0aAdJy2uAlDI8+aeqU0AjUYU5emhpdFzwx3ygP5KdQdbbY4gM4igDwKeqWp64aeP36WhcnHFMtX8Hmgb0bvyiC5IrdE1zV3AznlIR3BCVUNCE0Z2Yw1LYQeaBYuHcGmaFMXTyibL1eVZOO5Dh/e6FMmMu2RnqXX4vr+MI7BqeKU2opMIjG41a9m56k/fOdilD/uemw+Z5RSt7nN0IlynT9eX4I5UJTRkseNA8KkAzVto7PIIZUR8x1MOt+seBqqdxf2k8QpRKgPXYqw6tRaqHZzHmKSkKCLc9+UnksuJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

Thanks! I've tested this with cachestat() racing against splits and
collapses of a tmpfs file, and with this on top of 02/13 the counts no
longer come out too low either.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Chris

