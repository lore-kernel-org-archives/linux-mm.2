Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 829E5606A8A5
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 01:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=NWQLS20E
Received: by kanga.kvack.org (Postfix)
	id A12046B05B2; Tue, 17 Nov 2026 20:29:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1B96B05B3; Tue, 17 Nov 2026 20:29:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889DB6B05B4; Tue, 17 Nov 2026 20:29:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B16F6B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 20:29:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D6F341A0483
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:29:36 +0000 (UTC)
X-FDA: 85446507552.02.A87CD69
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0187510000B
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 01:29:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NWQLS20E;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.215.175 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794965375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3JSCXNwcogBu1PJnd6LhkuPj4w6tsB9fs1YwGA31yI=;
	b=tDPEO0oPW+toS82YDCSW4d2V2/Es1S2Loa4KSYYZ5OKZAEH87j2YLnZsD0fggPIOZymg4D
	giAUGJvywKa4qkjgOwcrb6FefbPALVBsEPtiaDRSVJaSVyEIciHvwof9Kp5DvfJmqF8/Ox
	iZ5zaKVzImZ7pSPKpG7hJPx25icEKPo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794965375;
	b=nmcWSHzSjOmEvHCtAEiBocxUfnZ45MtlqMA51tNojYOLjvYD2/64MdIoSYKLPuC1ZQto1T
	Oeo9qqe2wJUSZfevfwsu4K7hO03RHn91yifhOFchRHaacWthxuVLjz8AREOqvgn1umdcGp
	weWJjfYHW+5+AptJUpzm4lp9jODwidk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NWQLS20E;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf14.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.215.175 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-cdb86da313cso9318a12.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794965374; x=1795570174; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w3JSCXNwcogBu1PJnd6LhkuPj4w6tsB9fs1YwGA31yI=;
        b=NWQLS20E8gBtWKqd6BgHaYYAP5cyAE1/OdoVpHVopRHVWiOSgmKx18XONDmT0s/J49
         89aAqbjxHp0U7MlgSi8iLnGle+x+GfNoaSdxKi/tJjdU0QxRReMLRkkzs7agMqu3BWMV
         8ysSZYeZCrA1pTcFnzpSV2e9gioXIqx7CtV68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794965374; x=1795570174;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w3JSCXNwcogBu1PJnd6LhkuPj4w6tsB9fs1YwGA31yI=;
        b=1jf24VdAE2pfukBXpC/4UkH5yv3+DVHtj7ddC0OSAZySwRElsCYgsYhu1mPZvLjEeP
         kBHJvs5NGHglYOVV3uRWpzzOVCweTkeeO0+LOx6Pd5T6kA93CbIGKb2m5V5Q+sgPLUUL
         wmIvdbK8/4NZNc6eKGlGvBUu1BGeRAb0PbB3f6n4HAxjqmxRCiWUKUEZtXwjdXpTY3Y/
         eiiDW0QFw+rvgeV3exVQyVr0VVmVVQ+Dw5fZ6179Iiapo6iXWr2I5AdqIhrWQZZvWPDI
         Q02jR2rEnzrz61mUeLMiNvfOrfh36Cq2D73k95HLMF20cs+ChgdtBLGFt2ihmuMgrhUO
         U0mQ==
X-Forwarded-Encrypted: i=1; AL+hErER1IoFUqrLTk3CTU0vGW+kLd5LVdaZjs70Ijkrzy4g0OLRLIh5EBBSMHSAxZYDWJjhPjx0f29bbQ==@kvack.org
X-Gm-Message-State: APuU4Z9jizPo4zKEy5O7Djpefv5wpJk61IjbVKVbDwrnNtbsyq9BD0Gc
	zL1JT3itvzMyawocAeOXfWhGcrRpVdOodYlSmiasei0DVBDSZ1fAeVndxIJISFXk7g==
X-Gm-Gg: AZFdTZd4wvi3AKUpIXkSBw1ZZf6KaN4cjftWRKR4kK1udnkZBsT+2b4t3WZsoNWl5t4
	A8GFsFa7xWHndTgc93+Wa32bv9OIqAx3fau/pykjtMvabVaucbv7MyfM/s2Sxnj4QREu/oQr3Sf
	IrClsQqkYTbmh3Akd3+tpD1z52AJTjPLzD4ypjL/MWSpqRyn3tV3R3l0Oz4vP6X6fcf5cgN+zX+
	eHiD1v/ONTBDgDjiDzbEIKGd1t9SvgzChiCB36Vag79XkFHhs9o4iItZ3FhxpHne307XuV96a35
	QQU+NGWB0PSAJ38G2ZuqiwV99Gx2RcIiUSISg30/oWu+DdKcFA2PMpX5vKNIp1oM4CyshZ2zMfu
	hOcGWRJ5FLJvZ+awik8Mh2B52ca64h6sdetEf7UADNG6h87a3yhpOIZWSEETqFzRbfQJFL3TOg6
	CK8+5xI+c0/Zbfsh6D9BlJ3p0VuXEToNNC5poIcUWpFcgabTkk5/p8fK9ni/aLfdlXpaOn5OAyU
	RDtL9ob8puu2OkSyLC0htzD4Pff3POJ1ubKJtmts7MXFla52hH5ARVZj9YF5ja9IbrvdgTX57ea
	Bk6MofiIABJHYZl9UdsvH/zcH/c73rYBz+BDEE+3re9pBnzxegWKckuPDMUH2k7SDhFFQHY4bCx
	5CyrMuKAQ/OEaeGOD
X-Received: by 2002:a17:903:3bd0:b0:2ef:eadc:5c98 with SMTP id d9443c01a7336-2eff6f86b0emr15976975ad.0.1794965373725;
        Tue, 17 Nov 2026 17:29:33 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2eff5ed09b4sm4409835ad.9.2026.11.17.17.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 17:29:33 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Evgenii Stepanov <eugenis@google.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 5/7] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Tue, 17 Nov 2026 17:29:29 -0800
Message-ID: <20261118012929.290499-1-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.703.gf848ed807c-goog
In-Reply-To: <avwp1ZpVudiT1Gux@gremlin>
References: <20261116230627.3537051-1-jeffxu@chromium.org> <20261116230627.3537051-6-jeffxu@chromium.org> <avwp1ZpVudiT1Gux@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0187510000B
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: sbfkcixurd1fe4q71k4ecrsokyjqk5f8
X-Rspam-User: 
X-HE-Tag: 1794965374-699221
X-HE-Meta: U2FsdGVkX199Mg3H1yOgstU661PtYvbsdseD7ae0SLKsASFpYwF/9Vi85Niv99kyajZE7hXatlKua5FgR0IwiwL6L5+zPyu5tt0mlNGaMexr3JBLe4jrCsk+h7d/Zk76TqRweEpZqEUvEDeiS2zCCjFUhuEdy7Z+Uzh0qAeXJcnmlwaBj/pijxutL8Cevx6OtwBM8rVF5D9GR7UDD3N2DTdnMuwe/sDTvyzG7rnMvna5xNEXORCl9C1xGPOqhAVdKMavYNCcpDm5ukDMqOJEI7lQ3eUwn5qw2/D0TNBWNREr+KaUH2+Yoxth9/b/h20C5TXfaLR3Mipg7g39uHiTqAyYPsFn2wdMRRmLIH+FrWRRpPySGcBv5L7mJx6poGm8W1uM1iKIZhqRi2M0a9c81OX01FzNiJkdPvLbDgbgg7nFUEU7cKXUhj0OJMkGJriQVhe4H6FxCczNnKR0tfw7R4ooK5H2Ml/+fyF1miof3Xm7JYUOQovVucfeMCpH15BL/DAp7wDqj8F9AFkSoq3noz7DBnfxySVNbD86F7U0EmpwWLa5boiVfuXrMZnpMKxBDKpkcNzWUeffGUP6hNZ0xvPxC4O5+rv0qT0YUCt3DR3FrlNvdaGoG9kce2ape37SXOhqFxPOI8JLGLkB2jJ0oPmPJLeqwoevHC7pfanT3w3VIQnWZfoq6USibh20hJql/+72Kuwg7uXo+H96jELJZZgROVWPf60Hy0eNK62OoJCy+Ithyl7ihDpGzdVtOQYEAZsdiL2zW3aZ5N1H4JtcYZ0ytf72BvyAycAq32okVvPnfXYpdjewj5Bs8uf/S5f3sfvV2UNRYZ0/cwsO4hguiRYAFa+yX1yYVxnXVCyuVYAnQxBuwPSYvns6tTmZjSc12aJb9JbBWjwNz/szA5iFWvxSNyHmr9SpVO3GuAIIGgAzBCrWn1UMNg0WT7See7d1Cj0aZg+qpN2Cf/P3STP
 AWCuOPBk
 mELHEnDWW+FviJqToDF58O8BljV4S5vs+dUwx4tZPUsEyZ9BhuZ1y5bA9E0FUxdIXht+ozVodZroE6eNVLsXka+MLL5sMblwhPV0ydu1+KEzsWgZu5kSO/AROEsFDb4CL+8BJdP3PyXOm5wYnLD1FffyvlHSrjd2baOgNM2RV/jFa/PG131JLcNhEOQyzB5f+3ufNO/jfdV7TMcuWMkuXwkZ7fWXLmxmlLhAvWkNTqKKv4UG5cdzvOm0mzUDeszgrdmhb9wFkgLd2h804M9WRjfq5StNUO21qq77drCFzRH9dmEs+llNW6l+4Nwz/8WO2knNG9Ieg+Ty3t0WBALp1QIsQ1WgP2PpBUN/cnHumOhtbCTQ1buOlX8WDFPTJgznb/BjP47WCqovxnYflwRRlSqJhukBlKneBxdITaO/PentUU820RA4e3r3U6kwli1raGJW4Twjz9uIPPBE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 10:21 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> This commit message is just inscrutable. It's like reading Finnegan's Wake :)
> LLMs are obscenely terrible at this stuff unfortunately.
>
> You seem to have rewritten commit messages for the other patches, could you do
> the same for this one? Thanks.
>
> > Link: https://lore.kernel.org/r/20260519-panthor-kasan-v2-1-b7384458f076@gmail.com/ [1]
> > Link: https://lore.kernel.org/r/20260521105148.5497c281@fedora/ [2]
> > Assisted-by: LLM
>
> This tag isn't used any longer! Thanks for acking LLM usage though, we prefer
> you disclose it but in the commit message or the cover letter etc.

Fair point -- looking at patch 5 again, it is way too wordy. I will
rewrite it concisely from scratch for v2, and drop the Assisted-by:
tags (keeping the note in the cover letter).

Thanks for the review!
Jeff

