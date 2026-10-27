Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6754B606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Kx5NpRtQ
Received: by kanga.kvack.org (Postfix)
	id 77B786B0775; Tue, 27 Oct 2026 10:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C636B0777; Tue, 27 Oct 2026 10:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A7E6B0778; Tue, 27 Oct 2026 10:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF316B0775
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:06:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4A74120A91
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:06:19 +0000 (UTC)
X-FDA: 85368580878.14.4A496AA
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	by imf30.hostedemail.com (Postfix) with ESMTP id C1A3D8001C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:06:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Kx5NpRtQ;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109977;
	b=LencFzY6w7wG2BAv83u4L1OZjU4LQ10wGDcWcfAcxqIdpVF4ycTfPwkFGMz7+lBuKLsfUs
	S6stOIzakU2MRhtDGowi9LB8AWn1B1lqrTdV2qL0UUjJWq4znddnix5EtPwPK93CTh7RhI
	mRFnqH/lJhI3NVBval56WpaStcGiUgY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Kx5NpRtQ;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CcioC45MmLY3DkNK9gmi2R+KmuN+SF2m/a7+FcEpEKk=;
	b=vIfH/aRMENsziQD+CxOHdpAF+hWTcfxnIfu+qYQqIBBV8x4ZRbdX7bfCdhDm3+7VpT8/04
	5Th+xIgkDpoVkEA62HNsUsltc2ZiNsIEUQAg0nI5AJhlckNpNeHcKjLC8jR6EfdGqgPZPv
	rvQGqVnjq8TA2NIxz3rgI1oG23YUX+k=
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-7cc013095d4so1295474137.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793109977; x=1793714777; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CcioC45MmLY3DkNK9gmi2R+KmuN+SF2m/a7+FcEpEKk=;
        b=Kx5NpRtQxexgN01dMhJ79md8G/BJy4r04RJilepbufkHAcNR8/07N3ggenzAdsisH4
         id7lMpjKEozUAMB3EYlQ3A6JNNq/N6SJeb7Xal13LomEuUsT8+P+Pa+5gPbLPHpMViHI
         brfq/85LSytolWm6kZw1G8xQ7WzUy7gGAvZHKtP8/i/x5VdocKIPtYcIAG2ZRJ1jIp3e
         paPllobY33TcNscmSj7JG8AHtKIJ5S+hG5DzfOcSmp/F+BrSvXd5VZn/kKt4+y62gYQ5
         dFBMbY7RE5q1t5/fxl4/5DNfMn5SV+sgV+MDDF9FWytlPwQ0J73ZY8Mhjctk2UlrA73I
         rjhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793109977; x=1793714777;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CcioC45MmLY3DkNK9gmi2R+KmuN+SF2m/a7+FcEpEKk=;
        b=xV03Ymld5asCgZDkP6ru013H44C/XP3h2YFTDJSmVihAY1okE3ZE6ZytrLk6x+/MdO
         Mvzlw9gTu6+KF+8FUJTFABKygkP/wtH9S6vuZec/yxpzhsHGsWeTPEyPc8OZ/yEeEW7L
         UJnY3mYfOUKruA5ZtgCK6OalMCmigpv9Wxn//XrNJGW7WnzfuvgraEd2vcU+Y3MmBQ/s
         fQPW/X4hNml+LLaGrE1llhOdfT35P8p3G57l0XYJNprmctk5f/I5OZXANAoFF4sFQHi5
         7y4bhDRstM++gkt35hnjyB574Zde8aD02qdHkHh/a09REs66mIK/4kgNJLnjaG4PQtqI
         3kqg==
X-Forwarded-Encrypted: i=1; AKwUvBzwZt6Qgs48/HBrTNgnd40fnzCwKpY5rguyf1fmDYvTkq3Mz/wscalEIUsHdRsVKTVlAqScXhyfng==@kvack.org
X-Gm-Message-State: AFq9FYLe/AROvmEMPRVbiLvTyTy5BgfWRcKEAI4c1GB8zihwlZZylGas
	/EUH2mZmfAIiT0TUJwNtSMqn+lniy2hqds85IkSTosuEwj0N5rnWyKu/V9vqxrs475M=
X-Gm-Gg: AYBFou0Ig86WK5+/YIvcH8SXVYRM+OhmtAkork6atde6X+Tx0Wybz75t+OIed5cPvA/
	xKB6f+Xy+G2RfkaI6DC0FwyGTtXeROYKcdo4RAajYOxp1r13RB/NAV9cH5btoEcYn2YLDz7k60B
	+NhPUjE6js7Lkq4UXDQC5OR5sozcQx52frY0aZUQOCHRJYM6wV8tDgZI/aCj0GT1k+uwzo+6Q1y
	nWb1cDBovTiKMsj5CSp51Gkyov22mM50vbVZPAQh1DMaIZB5tH5nJUUHDwpIJf7WALxnn66InL0
	fktlsy8xu3gTNmfIJYJn5KGsor27dthzJVQMO4WWHmfzRTNz1ZwOQaY+2XSrEVRIhWbpPIhDety
	A/pYK+5AdwvUsuQDc8GGfyEvnDCjL5LZ57g+Gsbi5mxIBA8vvQE/xTTkFeQqa4/RZcISp9bOY9n
	90x3mWlw2ncvhwwTeCVd1esHId2rH4dRsM71+K7aodzjChTdd2q3665Ogy/yP/B68zM+uIwfE7Z
	Qe6DmKtrOnYDxpGCMHLDCB4RRVVwjZ9Ui8qK0mQTbo3vojfUxr89F1QW0m+K+vjN+gNL0AqVhrm
	vkUvDH6TwdiH6qsx/3i7Eg3xrRU=
X-Received: by 2002:a05:6102:14a3:b0:7cc:28a6:ee1c with SMTP id ada2fe7eead31-7ce5ca1e4bbmr3674778137.2.1793109976725;
        Tue, 27 Oct 2026 07:06:16 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47bd2110sm103733996d6.13.2026.10.27.07.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 07:06:15 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4/6] mm/page_alloc: don't undo another isolation in
 alloc_contig_range
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, 
 kernel-team@meta.com, akpm@linux-foundation.org, vbabka@kernel.org, 
 surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
 hannes@cmpxchg.org, ziy@nvidia.com, linmiaohe@huawei.com, 
 nao.horiguchi@gmail.com, ljs@kernel.org, liam@infradead.org, 
 rppt@kernel.org, osalvador@suse.de, muchun.song@linux.dev, 
 iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com, stable@vger.kernel.org
In-Reply-To: <a4fc92b5-7d99-49f4-94ac-89fdee699042@kernel.org>
References: <20261027042204.3741307-1-gourry@gourry.net>
 <20261027042204.3741307-5-gourry@gourry.net>
 <a4fc92b5-7d99-49f4-94ac-89fdee699042@kernel.org>
Date: Tue, 27 Oct 2026 10:06:14 -0400
Message-Id: <179310997463.2232644.3260379218896917308.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: p9dy8y1utxim1c8fn9uby96yojoufqon
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C1A3D8001C
X-Rspam-User: 
X-HE-Tag: 1793109977-352622
X-HE-Meta: U2FsdGVkX1/YhUnXd+uCcLyu+uNOHTsdvhemWQmlSKqMgbc874p7f80EHz13CImHUqwqDsX+5T6pW6BhMpFkxBPRNWKcMmW4QQacVfzVAWcFuDxAonzq3TSo+2qh47AJh4DZvRZKMn6CvZIPJFdFOD92A2rSaKDdpiBxW1EwmW2GswjyK+ntXShB2avAJWtYQ3IOQ/4mxvnclJN2Q61JAyncvXQUhQmmnJM3ywOzFfjgu4HPzQD+683uvYaOCvMTIk7BlpCVr3kmFPZsJwY7b2TvSxVoYhh3AEP/5GQNSsRUp2X4rnuKH5LDfn0Q5TahfMUq3YcH8L10LFZkOpYoJSzSe6AEniU2ZXJ/xev8RQ9UGsdWnSvMYqK24H41+WveqkFikC/X3jGeKJOhls1ATWiKeQM1/CkrnBGnaKPsTimxDoiqR/4xB/DdLh7OPR9Sx9XHv1D1Cba0KXK/Bp6ST8XFwDyqVagLij+4XWem8dQkVWFM9ClcqwXx6RBUyjSh/GcLknecF+NWnubbYdyvrcdOJC4FqjFEqlzN15+YWeFUBTjAc8L8aAtX89HOWZFh1a8l37jqgillmd8pbg6M4w3msBR6bMJULIOCA35B5q9DuVNJm4g/Wh0CKx17b0ltfCnv0Ljiwfuy5mY72piGdvxFfsGf19uSn/PSpcd6EwmegkP+6UVxRP+/FHjlnmAFX4IbAsHo29yhMzS3/0wTzyyhqqx2ZyPJwgbgFiW3T4UZXtzlMZVU21hZyOg12rRchWBooW5dKgM5FHFOau1oRdc8xQry4SKH3Yt3ZZEWCHjNzery318kIn3+sAuk9DgOt15+52e1QAjVHGvpOWqE6JQSgb53PJf3hic4X4paVM2CAWRbmaSJ9zGk9BTD9vzcscT6Z/Brbe8IZJOL/cSA9zb9muTFsLlOmSuXETtfhenI7IOXov51WYIxgEfrVc1GHCapEN47CoOP6VEgDuE
 Pv/aqNHd
 U2b+pV5ccabc+JKbwVusjgAmjo3VjelYWAtuhUsSRzkf+iyfgzVXWSVcI1Si29IS/WdZXs7tw8Q1tkAvQbH/uHW5TUSEZ8okXatnUUsuo1ZHcGkbjF2Ns/iF67cg3/r/mcoPgHkrCDRp6mPVshEeEP49OQq8as+XpVfvVFzMMoFg3krLRyLMO+Gjpro9nw07yAArmf8TQehgeT2hL3fZ9GbJTyu2CRqUcnxgV76bDQLQODkkAhqi0Oa+kuprkvZ7wHFl+lhJPtEA69TdfTs4o8MR0vnLOJTT4GemTEmZ66otM3PfJx2u13vfFCAh3HxdM9vKPG6eu8k541dv9kuJsZ5G9hTlgGi48k9/qTPwKgLhVOHDE/r+jY+eY+6AGMV7kPuqq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 14:37 +0100, David Hildenbrand (Arm) wrote:
> On 10/27/26 05:22, Gregory Price (Meta) wrote:
> 
> We have an existing AI fix for that as well already handled by Vlasta.
> 
> I think we'll have to establish some model of "ask David first before posting"
> because otherwise we just create duplicate work for everyone.
> 

Yeah, this is going to happen more.

I've been sitting in these patches for over a month while they soaked on
hardware getting performance tests.  

Maybe worth a private tree we can rebase on regularly for these kinds of
un-vetted/posted fixes to see what's coming?

-- 
~Gregory


