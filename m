Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A04B5C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:17:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EFF56B008A; Thu,  3 Sep 2026 10:17:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0016B008C; Thu,  3 Sep 2026 10:17:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 668456B0092; Thu,  3 Sep 2026 10:17:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A1716B008A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:17:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAF061A0568
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:17:19 +0000 (UTC)
X-FDA: 85172653398.25.175A5FD
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id DF19B40019
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:17:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oq3AdJM1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788445037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zcCW6+/z3gty5vQ5bRmZgnTdisuOcsWk7AuFt/Gu6MM=;
	b=XCcdtioMrILK3Iys7naHpVEPsyn7g8FvNOUxqAuctGGRLOagJyCh0bz7gvAiCNrBj2p532
	KEVv+wWunJFvNMz6IlHuDfVfZQ0FBkeNJod1GgYtFzeS89Tz0kaRiLTwRFAw+LlCx+N3ok
	1rP626WsMzyVATSDCG2M8ysrhn2YiQc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oq3AdJM1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788445037;
	b=Y+V0aZZJWcnHnSmd53WSBZkFztIaWpeJx1lVndf/tFSJGf9fTgN3W1yHSafdkNSuGIJdx7
	R8QHoLRCU9kyt13ow0mNJQeM72NCe4wN/QcYNWvuK9rWQlCimjuYYtxCKJIkOeimzW99MS
	jcAbeQzmFPpV3vPOb7VZ9/hYaEOe8ww=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7f84a55e31aso1067549a34.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 07:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788445037; x=1789049837; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zcCW6+/z3gty5vQ5bRmZgnTdisuOcsWk7AuFt/Gu6MM=;
        b=oq3AdJM1WZXd+u5kfBeZ4ShsEpWisTxVmYpVEqCqiDNj5jeCwmRO5txuJHWaG+6hJ8
         aFlxPqK5NZeYAvl+WDl6vgp0cn3R0I76RtYRDVrZh5QlA9hxcR1km7exHnh559DFsHDs
         PmUImJIUyM1yHJxzzk/VJ12fY879zNZDX0cguv9yvu6A0BwnH1os+YsvCAczufVUeIZh
         8x9Dt1VHlkmFa+8ZZqEAQl9FFo5JqN7+PhDdrxuv/i4lTSC4Ly4L/mGlnRkA/K3n0yoF
         +5mAb7Jn/OWGgajtlUCRrlVM8Eul0nm61eq3gQ0aA+0qfa3/8q2mz4oXQHZ/s6CkP1ZR
         5rhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788445037; x=1789049837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zcCW6+/z3gty5vQ5bRmZgnTdisuOcsWk7AuFt/Gu6MM=;
        b=fPPsW99dzEAPslOiljV29Ihqhc47NKxbTv/tnDi1rZs2xUGEyJZPnTIqXLML7errRB
         +hEV5OWITcUX9sT5oQXABXLGHQqYICY37mWMHcrYG0juzeNku6ZissJJCv4X1dC+tp+c
         kUExWMxm+Txc0a2iDxV9vfVFU7K0f4yl1cz00bvoEejRniMjDst8eomC6bzsbscLtuZN
         bhwvMciMUFzdAAA5zAGcJR0PQ2hIftzmbM1VOGepB3HJH2YAHCLVmqNAaUvLeTnYwOEq
         iQ/+3bn2SLlEoOSv2qqcv8+eHFcFTsD1mJKTjN/NyQ7O54KyIxz4+2GpThuU3UA9a14A
         TaUg==
X-Forwarded-Encrypted: i=1; AKwUvBxdEY9DE6d6r1vLFuxytjXO6m304tokAWRiBXXPdK30L81cpMGHgxg9gg0OiXBOtTC9/ybiCN3JLA==@kvack.org
X-Gm-Message-State: AFuF++nnm6cebxpV3A9r7wkuT3BHeCFTGXDn3khhisFWbig7baoI24/D
	16C7tJu/UHvY+bRd7aqGRRDXXIYTjwTtKWk+2uUiABu3pWwZHx2xbdCQ
X-Gm-Gg: AYBFou0Y2cWVanFGx0KrWttg8Qim8Wjse5RGw7R+mNGnf2Le3lGgmlvCoV/EEEGXKx0
	2eR6wErRAbRzgYecWMb1ZgVCclITWHeZ0ocjMmnbnV/B2eIa4/LKR0YiSb1WArFH9kfVEfIbYiT
	u6Ve8Kk8YHZaMSajCRADcZ4CndTNLW0IqX5AKzDGXqAhkMeEyDbom8Zq3WFJp7N0bnJzXZoLk2S
	vwACQDC+Z4Ryo3AW9XjVtdRE0EowPgVqtQbx4FDrWgMpGCxd3PSq1IKKlSBAg/HsLBOeexWQaIH
	HKTOHawK8lt9o7h5HFHEeIU9rQvhZt8CaR57klP0RLVkIIpOGsr1T3XqWVat6LTLixPYXh2Kzbg
	fxfZpRXeM5r1QwblH1xxmtUOZhDBcrmPbxzsjLa/El8tB8++xqHwzXWJ1yj6U+LtIawuRktCadd
	8NA3ng4O4ExWUz/I0OFyQ6evDvyRHxUcnImOOHZ25zalpWQB97vrxvxKzQNdI9C84M9Hk+hnVW+
	5YZb0xpnebzxqdEpKM=
X-Received: by 2002:a05:6820:a0e:b0:6b1:4fe1:9464 with SMTP id 006d021491bc7-6b47dfac321mr10573094eaf.22.1788445036581;
        Thu, 03 Sep 2026 07:17:16 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:1b::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-46f3292c0b0sm7715350fac.12.2026.09.03.07.17.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 07:17:16 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Krush Chavan <krushchavan@outlook.com>,
	"Chengming Zhou" <chengming.zhou@linux.dev>,
	"Tejun Heo" <tj@kernel.org>,
	Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	"Shuah Khan" <shuah@kernel.org>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] selftests/cgroup: account for zswap shrinker writeback
Date: Thu,  3 Sep 2026 07:17:13 -0700
Message-ID: <20260903141714.595256-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902180408.05b925ce05359cd4d7f96894@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dqhqoch6hc9mdjdmf8axt7nu1xdzkb1n
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DF19B40019
X-Rspam-User: 
X-HE-Tag: 1788445037-897540
X-HE-Meta: U2FsdGVkX19bshA4N7Byg8gJuP1UgpPI952jH5udKBb+pKVt2QKIpEGHA+4ETIIkW9aGJDxg8wluO/AZN9OAxkeynl7jIuFNlph7CVPvaLI5skPfl6tZKUAW80L56+lNqlO/2kx+wQdMwtABWBjPoNREGpFX/UC4GmvTCIhcadockfKApbT1nn2scPVZKW8hjPDyG8idNMPOQskTb7jKVjLjyQl4hXoRIAvUHXxcpfqu3RXn1kO5AQ9LtUf9ycAEa+qO9aUrSAaj2jMjQOFydyZlcj8M8iqWpXJiGPswsn+kZg5I2/MwRfVtMwUFdnKta1BWCLUqg9tWBn2tUr1zobEseES1JHH7UdkQ6bXl2sM1YBeUH1Uzlhrisga+RZK3HmJmVYv50lW73hIU0Zdh4P2JO12lM82t2+pzYd9L/j9EQi3mMP9jYCAl8hfqk6dE93/1+4x3bcE199AQ1gEAQkI8lcYwJ93orAyCRZDotsqgQReON8bPv83lbYzRa+f90yayKaA2VMZ9i0m+E07V+hNK7PAzACeTH8YDrEatKxiYGD94vkJzCyl+57DPFaEjuf99e57OTryt76nkaZIFrmTzfQDrdMk10xMGj0jIR5AoaiFioEyYpS4/rco72jIS4i46Zwda3Yms3RUFaHBn9tbld5SJLN8MArOWY/8qxAwJWiLd0UXGrofLZ1V8ZGMfMV8kKYwn6XM39Gd+ngFuUzdtQjYRbdIs3I5IhhWOoeykxFF8CNKIWcGv/98NkUVb0Lq32ffwF8p1aVOFpe+lWOPTAW3PcrdqbXuh5x3LDx/N6aVrdrkI9UyXkKpZi0/RoEAPFJP8eNNhXofyeGyiQ1iPfoZCnDYYFurtJgfy3E7c/QF03ExKJW6OBzM9f3wRCokbRAqgKwJFCxgZjR8BEj4YRrQdK5Edl/M0NuahdhnixEJ99LPm0hzkk7cL/Ld5b1H0A89weyKLypC4Tb4
 TouGJymd
 B4vBN7+LS0jhd+cgbS7EWAg/OuhG+0UoFrVF34j0rJtj2JVzFPumJ8L/rplwK8n+Eu8tjfzDhKw8kabEEgZRf/YPoCsS5VtfO4uT3xpSCP1g4oXa14HyA0bol6Z5DWkDOUxx2/JodzCKXHzv37/6ulME8VnN/oY6A20Gc6vl3s/D/FM6q5xDsJKNWhRDBaipG7eo6hUKJ7jjxT8yLRdlQGH4iMLLDdJT4U3g/SHDIDyiGIGnTRUPhRSygE2szU7lI29wBQrfKiEr7+NOxritGpS0XwBmuE2owixjoW0W0u9WmCfjJWCCImBbNYY7mqUycYNdQnQTinsZMEzLZWS7K7ersO+bvlCkMK9exkh9U/7DLL2pcT+BOtQme9BOpNkkiPRvzqx8S1cQt/udDYQL9axagAxhApeUzxw8q2gYxUYlGibXq46f9rMA3OisQdgwoWZqFHJiw4TQKZ1fBhjsW+OwemP2mfDwf70skpsFbDz/J71uWTiLk+X0Zs4q6mqHNNrZ9GKeechK+1peOYS0Ug5SP9IL9vQEbl6yEqRjS7H2LltUMIwpxgmJDbl5ZTNwdbRn/V0jAykfAU+HlMpUlLqTYrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2 Sep 2026 18:04:08 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed,  2 Sep 2026 12:45:20 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > The test_no_invasive_cgroup_shrink selftest checks that when a cgroup
> > has zswapped out more memory than memory.zswap.max, it does not
> > trigger writeback for other cgroups. To do this, it compares the
> > writeback count in a control cgroup and makes sure that it is 0,
> > and then checks the writeback count in an aggressor cgroup who does
> > expect to see writeback.
> > 
> > However, when the zswap shrinker is enabled, the victim cgroup can see
> > legitimate writebacks not triggered by the aggressor. In some Meta CI
> > tests, we have seen this failure mode happen.
> > 
> > Instead of checking that the victim cgroup has 0 writeback, compare the
> > writeback values before and after the aggressor runs and check that
> > the victim cgroup did not perform any additional writeback. Note that
> > this can still lead to probabilistic failures if writebacks take longer
> > than 5 seconds, but this should fix the systematic failure case.
> > 
> > Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")

Hello Andrew, I hope you're doing well!

> Thanks.
> 
> I do support backporting selftests fixes.  We want selftests to work
> well in the kernel with which they are shipped.  But, as ever, we
> should include a clear explanation of the userspace-visible runtime
> effects of the bug.
> 
> Seems the short answer is "false-positive test failures" but we can
> perhaps do a little better than that.  Quoting the failure messages
> would be a good way - very recognizable.

That sounds good to me. Unfortunately it seems like the selftests
aren't too expressive in terms of why it failed, so this is all that
I was able to pick up from the selftest logs:

ok 1 test_zswap_usage
ok 2 test_swapin_nozswap
ok 3 test_zswapin
ok 4 test_zswap_writeback_enabled
ok 5 test_zswap_writeback_disabled
ok 6 # SKIP test_no_kmem_bypass
not ok 7 test_no_invasive_cgroup_shrink
ok 8 test_zswap_incompressible
# 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# Totals: pass:6 fail:1 xfail:0 xpass:0 skip:1 error:0

I'm not too sure how helpful this will be, but maybe it would be better
to amend the last line of the commit message to say:

...
than 5 seconds, but this should fix the systematic failure case
and make "not ok test_no_invasive_cgroup_shrink" less likely.

> > Reported-by: Krush Chavan <krushchavan@outlook.com>
> 
> Relatedly, is there a Link:/Closes:?

Unfortunately this was detected in our private CI workflow and raised
by Krush, so I'm not sure if there is anything we can share.

If there is anything else that I can add to make this clearer, please
let me know. I hope you have a great day Andrew!
Joshua

