Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7C59C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4B146B00A9; Mon, 27 Jul 2026 09:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB486B00AA; Mon, 27 Jul 2026 09:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEB936B00AC; Mon, 27 Jul 2026 09:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E4A66B00A9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:58:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 16351120730
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:58:59 +0000 (UTC)
X-FDA: 85034712798.06.535CF04
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id 13773A0006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:58:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OTUWpnQE;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785160737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jeVBGviPg2kCaObeNUQhF3Ba7R7LGyRIaSNUXdzPkhk=;
	b=WSt+qwKbzMaXRyeSLB9sqdKM5i/CnP4zer1NsJ/2x0RjXbF+EB146BFfjwTeYikM4dWFu7
	zpYFEnGip3LKyO/T72cY6StD4WxBo++QALnOSa65+DKNU3cW7NGRa5IzQu/PWejH02Is2s
	j5BnIpzJracWiG5eYVLKo6xRjqfWqkQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OTUWpnQE;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785160737;
	b=QnbkNGqLhAIJ3YmlpjufRRVIQe6I9vT3A14pz7QzHy2g2CmntT0hTCH9r9TxR7aj7NKB5P
	2ugfos7eXU3ozcXYWMgFyMUsJD+TBO93e7FkFNhWLCzEgtLH4bH1BSjb3/SD3gPUosyNpA
	9OGL3OuBH0SgYtEjwxMwCnHIS1p71xU=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49550ec592cso23663885e9.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785160736; x=1785765536; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jeVBGviPg2kCaObeNUQhF3Ba7R7LGyRIaSNUXdzPkhk=;
        b=OTUWpnQExrAX1XmRDTU5IbI6VADMh7LZvPclfKGMOR9UbgECPjAWnn25Q5jL3NfUur
         NsLpJF1d5INlJz6c2ln4e8fmtlt2p/yIZXPzmrdFtZtIzBclALtMNj7wyoCx9VbyTkpI
         nHydxnt25l+4fKxow2llnWN3j4D5fTLm41f92cH68w0HtbPEtFWkEpdHULmzO4WH1nLD
         HueEXiZsGlGLJ1jNfDM94TZXkSmwZJdVefVSSwsqIAA5+6k4AEqlIdUVfgmhMFGMHIGx
         4BLFRJYpBRIbWJ+ca8CJkJ/O5tOAx6MeK8ztQ+9pDuJ5pgI7WG4H7lS6hTRwt55Ku7PR
         52DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785160736; x=1785765536;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jeVBGviPg2kCaObeNUQhF3Ba7R7LGyRIaSNUXdzPkhk=;
        b=f7slFWs+H+8vS9bI45iZgnQWKSyfBtntvUvCLmuKdWNQlDRQNxVyOl1FGkc0tG+iD2
         SktBH5P4KI2i5GGMVC1o4FV0vjObiTsLz/y8AaStIA8CPlbduf6L+zp4wgn7PoKvsEWg
         RkVkTXhEtUkQPPYwRanyvwsXnAx5jGcjl8tEgUsUyRkBxdIrRGIyZC43u0b0bsmY73fo
         fmeSgMa53TXYbdw1s3I/r8vZcoJgD2O3VTWZnHDqC6QZWoAAsK4PLBGHGSnpyR+sEO9c
         u6FvIf8vr/hOmB0M6M4nOorlxaa1WY5QTq7g54zNAcAMFFe4Sp7J3Xkc4XC0Y/JlX3ym
         aDPQ==
X-Forwarded-Encrypted: i=1; AHgh+RrxZy0vrv1/yY0337jyl13qwmFzAwvtDCUeg7mBO9DeV0g9zqqdmyA6XOKKyuIQynel8Y5LIKGnyQ==@kvack.org
X-Gm-Message-State: AOJu0YzA+kuOYwLpKAGWqr5mbaE+R8dyOFp8GKIhsILLcl5R2l7HRhqc
	16wHhOlXS5QVbc0G9uyw8i1FEgiBTzqfty3DQqVB4LZZ9X+jjdTPEsYXUmAdgYUhU7I=
X-Gm-Gg: AR+sD12b9gp5/Q2FOWDSC7sa+bK/A+gRQx3u28O0QLCXjFyNDB/XIO7TI3Lt+dXDB20
	OLwMVx9u9lB/NptuhJl94T/Ogm1PYo6IQVWNtbBL6YrsqTcxFLnekNeXiGh3GyyKGNfKPHm53zF
	jBK5GI3yFBkBEgzU+x4S1KXB/0haVZzH50hJ/2xTL9Eet9Xc2Q7jFaj4bJlFXxNM066Gs21rED+
	H5MvgbI0gTX97ljmPWHi1Hmj3zDpdVuvE2ZaJixdEE4toMmuAPz1k7DvUaYlC2SXY2sFbqQTipp
	Vt+HmD69XjiOMdgBJsmtyiNKusPXRSg5f1mwWFmOOXD1irbBQnUXZztzVRfhKkC3PvkPtvohAnR
	6XEEmhZxycdpeZ21101+nbBdrm5+GK+eXZoNykSbk57n792b3A8erCijQescwNJMV6bUtlpuaAH
	V7ErL+t8SozA==
X-Received: by 2002:a05:600c:5253:b0:495:7016:b875 with SMTP id 5b1f17b1804b1-496b5c7ca38mr104189715e9.13.1785160735634;
        Mon, 27 Jul 2026 06:58:55 -0700 (PDT)
Received: from localhost (109-81-83-7.rct.o2.cz. [109.81.83.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957f9ae5c3sm325139165e9.3.2026.07.27.06.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 06:58:55 -0700 (PDT)
Date: Mon, 27 Jul 2026 15:58:54 +0200
From: Michal Hocko <mhocko@suse.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
Message-ID: <amdkHvSMj95DUri5@tiehlicka>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <amcT75pLmA0hRUm1@tiehlicka>
 <615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13773A0006
X-Rspam-User: 
X-Stat-Signature: rehd95bhy85tcqporarxisac1z7k8nwy
X-HE-Tag: 1785160736-74445
X-HE-Meta: U2FsdGVkX1/HBYYrqflblp7gQ6F6dbAJ0a118eadiz59guMrw4/Lw5n15AsMvr7/r7yvS3wZ95Gdqs8FmfuwWYLnWPVy3dWbyRKUPDh3sGjINgXHxsm+nvc79aTK6nUhZyxC+m2HxwyoOCcJNq0k1/xLcBKkuneZGvAVB7OCbxiEzBCaJkySpxCML8t9AOiIiwC7cnR+Eb/VhFKiH5i74CI4axp+hJhPDTRk1ZzO7Mo0yMhoaPHNQZ35ldSCsMPCbfnolyJBmMd4IyLdoiCaO+u3QEWWBb40cHjJR51TfZdM2WlhczGzFfmZaHBeTyMK2iqNrN7T7GXQpcLkwXmZl8Ds+Q6yNbZaSKpUhYLQZA5PqFclGcmOUvcPDMvX1bqVkVdD6mvr/SpvyzqrWbvfWgxYEI6z1tURj3zLr8evoNJMzxAspjlVjlEnxoDVnh9emHab4Ns6YlnvbIjg4SNg35vVij2fDcfblEfewWki4oILHJAip2DyYU6de7K3ml+Dr1oCBIT/g62Axwc3yp4xi+ZFJWjzw7OKSCqBXWC0GUqcqfqEq5K7wxjRnaZGs/Hrn1LtY963d8n6GBGelarbx5GPqL28JVM1XHIX2gcRqG0Oo7ojBRWBMkTuO9wOIaT2FcjxuoNVpW8/2b07TgC0sM3m8KDmMgYX6IGabtgp9rdveCIZB2iIIYmrXKC0Fro3HsAglu/WJZ2I0S8Mtf9PlC4gPcKihlQ3DghdUestwrq28+IhMgedHDX2YG87+I5yVkn/sRnoAiY8RPBtn38jHxy+GbsnWCR20I457OT85jdz+TTBUohYoFLIiF29NhvNGuamR+RlswOWVhar2zvtpMJXrG1xLuDyE+JcHXUhmNmeYQu7JDatAam6vjIUrNZkz8ULMsEI2rd2vFbJw3B1R7J9DlhBURklHT8QVh/2lNx6hJtCGIwr4IxjMcMsRMUZqAsrMimBDGZKoQKlJ7a
 ZBCgcXOO
 X6M+VVmB1Xj0MjiwH7kCY0uUHfnu2t5TuOWfy6u4uSfetxFpVfcbxDVuxhYyRjOKBjotQgV45XpASkRda8GoW8/eiF15tbFS1NZ/Q28MytHIHL8Wwt+JOnnWMwVZGoRIOM7CC4QmRxRFeuV7d+7vWp2AnD6WumH/N7xMg2X4Cq+eA/EpWv8qI80vDVoAhu+0onoh8WqUeyNIFYdjoRSOMGcULYwSHrfXGTQEUrC9kvXWEXsm4ftrVzjsaOsuCi67W8ojOVO9ncWvECy7mMMm0UQV8sfwLPQYLqLF3cQ2BSMtTypuHIKN4K4tGff99GWu3tVXq5X13I8hJSnjByqReYlZglqi2ErkFXl6sfpqEQcV0wHPJZ8f9zROBnvsKZTzbYdmM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-07-26 20:59:23, Guopeng Zhang wrote:
> 
> 
> 在 2026/7/27 16:16, Michal Hocko 写道:
> > On Fri 24-07-26 10:18:05, Guopeng Zhang wrote:
> >> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> >>
> >> kernfs serializes file operations only per open file, so separate open
> >> files can update the same memory.high or memory.max file concurrently.
> >> Both handlers store the new limit before synchronous reclaim, but
> >> continue to use the writer's local target in the reclaim loop. If another
> >> writer raises or removes the limit, the first writer can continue
> >> reclaiming toward a stale target.
> >>
> >> For memory.max, this can leave the writer looping indefinitely once
> >> reclaim retries are exhausted. The OOM path sees sufficient margin under
> >> the current limit and returns true without killing, while the writer
> >> still compares usage against its stale target and records another OOM
> >> event.
> > 
> > The current behavior is deliberate as described in b6e6edcfa4056.
> > What is an actual problem you are trying to fix?
> 
> Thanks for raising this. I agree that the behavior introduced by
> b6e6edcfa405 is deliberate while the limit installed by the writer
> remains current. The problem occurs when that limit is overwritten by a
> later write through another open file.
>
> Writer A stores a low memory.max and enters synchronous reclaim. Writer
> B then restores memory.max to "max". A still compares usage against its
> local old target, while mem_cgroup_out_of_memory() checks the current
> memory.max. Since 1378b37d03e8, the current-margin check in
> mem_cgroup_out_of_memory() sees sufficient margin and returns true
> without selecting a victim. Once the reclaim retries are exhausted, A
> therefore loops indefinitely and increments the oom counter in
> memory.events on every iteration.
> 
> I reproduced this with a cgroup holding 128 MiB of anonymous memory and
> with swapping disabled for the cgroup. Writer A lowered memory.max to
> 32 MiB. After that value became visible, writer B restored memory.max
> to "max" through another open file.

Is this trying to replicate any real workload? One would expect that
writers to limit do some sort of coordination otherwise the exact
behavior is not really well defined.

> On the unpatched kernel, A remained blocked after B's write, and the oom
> counter in memory.events increased from 37333 to 13512861 during the
> reproducer's one-second sampling interval. With the patch, the same
> reproducer observed A return after B superseded A's limit.
> 
> The new check does not change the behavior introduced by b6e6edcfa405
> while the writer's target remains the active limit.  For the indefinite
> loop described above, 1378b37d03e8 appears to be the more precise
> Fixes: target for the memory.max hunk. Does that match your reading of
> the history?

Well, to be really honest I am not really convinced this needs fixing.
And if yes, your patch changes a well established behavior existing
userspace might already depend on. While your described case doesn't
look great it doesn't seem really harmful and the looping task is
killable.
-- 
Michal Hocko
SUSE Labs

