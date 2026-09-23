Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D4C5C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27CB76B008A; Wed, 23 Sep 2026 17:32:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22DD46B0095; Wed, 23 Sep 2026 17:32:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11D1D6B0096; Wed, 23 Sep 2026 17:32:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E215D6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66271C013F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:03 +0000 (UTC)
X-FDA: 85246324926.20.122DD33
Received: from mail-yx2-f42.google.com (mail-yx2-f42.google.com [74.125.224.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8A1608000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="PZTS9Qz/";
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDp63aNNvlo+CbPC5AYf50weUXwD55oicYAOt2YPLqw=;
	b=3YMpMzW9V+hfwwafsoCGJFVKarl/L3b4dpLs+V1LkOI5mt/MijHY9t6RH8Y5HaLv/Dwzo/
	g4qYraSplpSMeMTZAQVQ4vE0t9a2UrU7pNb7yNJg5SQKe/KjvMVv02Iej2K859FrkAY2rz
	2Cuq78BykAInCYNvkPN1AheAX7YP7JI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="PZTS9Qz/";
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.224.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199121;
	b=SVz5PWQZxWlU65v7OhqgdWYXr6ntHU8ambfVxvisMBcDTB3oOGEalW3nz4tdI2rVfu71qq
	jweJTSZJvkwEdYmImuq8DXluwumL7QswFoB10OkcbdGAgEE0lXVxJnLBXqh/Gpb5qJtKVT
	AIVhgyXedKTOY35Z1UaYCzALoVOY1tE=
Received: by mail-yx2-f42.google.com with SMTP id 00721157ae682-8a45b788a71so15232257b3.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790199120; x=1790803920; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YDp63aNNvlo+CbPC5AYf50weUXwD55oicYAOt2YPLqw=;
        b=PZTS9Qz/re8UMTMMEsqC5zD+Cy7qNbP/QeapJseTeS4WcgjvNvL5ccQ+U2bSG3N047
         KfSra94cInOW0xWWP4m94O2g+P9pxpF07ZHuLjwtel4b623kCV1T5UFur2uyMrEy5HKD
         ZPOHpvWaeoKJnsauMFwbyC34yVll0uyw+E5z3hMckL8lns32LPmovCoZXpiyCM4u96bb
         wqi6Y1Ad9TQIHicifXJBhbdZOA25PjsYDVU0TwL7oB0uWfZk5C3AN5AEe2Atvd0MpmaV
         s3W/3TMpjVULRozY9kPTHlbjp340NQqV71smdfzvS1l15E4G7OS6ktXqeOOSbwGyDV3+
         bn9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790199120; x=1790803920;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YDp63aNNvlo+CbPC5AYf50weUXwD55oicYAOt2YPLqw=;
        b=0l6M+blNQ6EpJaY3LsTcKrZm5LAb2ocxXckPVmWfzGcNJwlA3BMBo+cZrMsN8IIkht
         2Rpw0NVTVY+WDc7jTNYG2kWcMi6l33ZSRp/YEKxRuUSe8wfCf+tm7yBHcM3E4XNHGtdi
         hcSJYzP3MRoNocNypJk8hXCkhdQphS6YhuXSCUVBl+uDOXn+e/HHZfAtJcvEwhtw01XW
         uh8na6zOesneUsGqbbCMHZqt9wsGDM5l5424fzxOq9FB5hgKA3VTxMsN4WuKRWFScsKW
         eOnEv/nywmZTWCACHi/gw2tgKyL7DjGfDcgHAaa+/tmMzmf0C19SmPLyoOBtr0uJ5OAb
         K2uw==
X-Forwarded-Encrypted: i=1; AKwUvBweNt84QlqD9bMBOOwlKTBc07HPm16ogab2pW+TaA4mq79z9s4V10v8QY4CPecPvShFerKRo5DBqg==@kvack.org
X-Gm-Message-State: AFuF++lS7DDqFb57UCjwxVd178q2cem/aV+L2lMHAi77EgSQSna0g47e
	pu/8+uB26pmDf72Z1MV9u3UoUBF9l+KjGqiMIh6J0hnix5/5SzEoyBUGvn8SR1JXoE8=
X-Gm-Gg: AYBFou3m5Gd0fUKdbIjq+1bcq9vdRa22uXzGPLEmZ/h7oHrmF+l0RpxRU4qCJwwYwMl
	nfb1Sh2MrfKXuGq95SuIO1qYblSHwLsrg7SPEhcZcKmA4qoGiNr+ouhna0TZhD5C/45UvFFC1r2
	p2sFmq83mCVuM4u+9aFRN8DREAfLGBnIH5rC3kUfO0wmcFwcbctEeolNbQfa7QDnRvEISH5Aosy
	uXZ+OGnYTqGuMVadOVWuiMDgEQWSbHA/Ec/iDAtXkvLHeOMl8SVEwNhMRyWeihn7mTGgui6IUR7
	3h6nAVO7+9sPwpruj9G0r4M+TiW9zJL4NN2h3mtBL0bdFVy2+O7ZBz06KqDBXxa5M/QWAmkflw6
	m+RO6PM/RzctSiSzKncqF9vmWyjNEknVZd/0aHBav3uxfF4F2p4HFpvfIBswch3UX/w5lVcXCI1
	6ALIhCn0HUlRFZUHFnX95jypJvkiuM2foEvqqI5RthOYfWz7ecv8gBoJivHSRj58Xp/3kjST6yo
	Cwv+BfbYlA/R+c8VSo3Ezdb8FcyThLB2lih02zqrc9ygy1p09fvDitTJW/Hf1gDPQ==
X-Received: by 2002:a05:690c:c507:b0:87f:c20c:67a5 with SMTP id 00721157ae682-8a649d6750bmr4124377b3.29.1790199120690;
        Wed, 23 Sep 2026 14:32:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2474fbb3sm319077785a.6.2026.09.23.14.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 14:32:00 -0700 (PDT)
Date: Wed, 23 Sep 2026 17:31:58 -0400
From: Gregory Price <gourry@gourry.net>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH v3 1/2] kselftest: mm: return fail when child test result
 is fail in khugepaged
Message-ID: <arRFEKD8hmzTKFNC@gourry-fedora-PF4VCD3F>
References: <20260923-fix_khugepagd_fail-v3-0-b387e92fe1a9@arm.com>
 <20260923-fix_khugepagd_fail-v3-1-b387e92fe1a9@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260923-fix_khugepagd_fail-v3-1-b387e92fe1a9@arm.com>
X-Stat-Signature: 1goafxrdf64sdcoswta9skzn3dbd1wjo
X-Rspamd-Queue-Id: 8A1608000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790199121-767672
X-HE-Meta: U2FsdGVkX1+7PBZRRzKwD6qIiiTrozA+pvLWHCAJIaX2K76mBck8jvW8Q1b8uLEmSdJ9W8UYftDiodpJ6eqcNWyybWc8WUYTcKUcMA4Oigh8dERBx7FBfAcn2rZ6B/MNg6nLC+60Er9MApaBSwO9ENEDuL1JcyapglgFVHkn0dxhcBBUbKb76N/cOxFVrO0ILoEqWKwI1iF6YA2Mf35CqsHt195lbeBkQkfsdpAyBOaHNq3O2ESRstJeWaUXKdQYFKwIhSX0CoWeAul5xG8vcY81nmXQqyHWwJlMUnbHPcXcz/hxRbKHWBGFbI/saJt+SnjBvSCOsr3pZH0nNEINzBoFx89hXj41E+lmlSThkUPuOczfRhtahVPhCe7ToDBRYwjpXGnAOsNrJs378gx8Vnm1ku7iqLwVrOAukaSFeLdxYmvs+HjKy27bXdPZUHI2xbArXho/1t/kzPmLwbkY5gz+JG27hfzR22grQZ7U8nARiVNz9FFHMaAGmWwJWRq/BqqUdfj0mv9bbeQydbRiqnF4z1DadWkR/zt9+NjPX6dXQsmDiGzsuh4BSkC2w/k2y3drajS03QSqPhd9L7w/mofJcYwlQLpz+btMZ2soGbjrs7jv2MusE78Sw6+aetUIlgJAJFyM0zZw9BPRN+lz9bYdbQCx4aBuXZqP9QyhEl75srb/dCFvm4Ef2hbO2o9pNQKHPGCIdAq7gU1usY+3hm/cQkTRZVmqAWpsJQfTeKyVVp+pR8nQi8tESphHkgvtbzfs6nLQbJv16pfB/6J3VBU1xdLnYX2+hegD+1gchFDw18wkbsuEg7Z6ebNvtCQBpXLyzY7jnrJ22x32qmmM2Vw4zbkvqTaJvrwm9LyB/RV2cIgoTnJ6tIV2nUYlT+nTuRtb4obT8fgxjG6q7EGTw9/EzFDBOPoFqNPG5YHXcd9ZCNfJoRzmhu/xk2ZVoi+m2W/mYO6FT72tdE3R+ho
 howDuQN+
 3R0Ozc5iJap6ka4F1rhpPERtulI3oZSnp3EhI9W4peWsxv5rkaCZHK+66y8rQde3tbpxvNQ5aUv9x97Iha/caWJAYfFzHjaA1gv2YjCTSieyj2dp2/hc4WpTozc5E0XS72B7NyO2AYpWjyqqXI4pG9rKNDc/kQmCb9v8oNrEpzJaTKuGaxU0KZYRR3EzME/Bn9JiZGe1zddZ7Irs3eDjmxzp2Nh+zqc8iV8PvWO5RLvgELiI5iusl4IOfZoP2z4+cYBJtdKpwt0R0YxN//EjIYvA4wi3CaPnYyCTNshzlg6tw5iJW91cNm6XNeIYt1zxb8whjM5y6yq10b3ZuGrCMKrV8VCJ9HAAWY+GWDSqBmW4qByv/HbQFGf6BcmKqpEnYxQGzWVGmuUC/LWXWYvBkMR9S37oWZ5x+8RUxWlOgpOD7G+jtApBoAGRaYpiqXEcLIdnhkEvBEyTC0jhId9zSm+f2IHXAGlL+eUPgpUFm4ax41+Vajwe62AGopg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 04:29:51PM +0100, Yeoreum Yun wrote:
> Although the child process in collapse_fork*() or collapse_max_ptes_shared()
> reports `KSFT_FAIL`, the result is ignored because the test only checks
> whether the parent’s page was collapsed into a huge page.
> 
> As a result, the test is considered successful whenever the parent’s page
> is a huge page, even if the child test fails, as shown below:
> 
>   #
>   # Run test: collapse_max_ptes_shared (khugepaged:anon)
>   # Allocate huge page... OK
>   # Share huge page over fork()... OK
>   # Trigger CoW on page 1023 of 2048... OK
>   # Maybe collapse with max_ptes_shared exceeded.... OK
>   # Trigger CoW on page 1024 of 2048... Fail
>   Bail out! Unexpected huge page
>   # Planned tests != run tests (26 != 23)
>   # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0  // child failed.
>   # Check if parent still has huge page... OK              // parent hpage success
>   ok 24 collapse_max_ptes_shared                           // considered as success
>   ...
>   # Totals: pass:26 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> To address this, propagate the child’s failure and skip the subsequent
> check in the parent.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>


