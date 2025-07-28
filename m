Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BB9C87FC9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 14:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE51A6B0088; Mon, 28 Jul 2025 10:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBCF76B0089; Mon, 28 Jul 2025 10:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CABC96B008A; Mon, 28 Jul 2025 10:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC76C6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:51:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18E2B1402C4
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:51:15 +0000 (UTC)
X-FDA: 83713961310.29.151FDB3
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2072240005
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:51:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AuqEWPO4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753714273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plhcie/uWEJ2l8MLaYw41+bnUS5YGYhxQ5JWVcQv7gs=;
	b=1HakLG4Id7jzvhyZKciwUFzhfUSUTLZmpa/8AXZV+Mo3VpN+wMUmXsPaKxA1vaOD70j/2u
	VISzctXEykvYOZeGI1aVkSfj2N6xjQBNncNY7BXP5TfX9FvPqO0NXwaF4rRpypdFE4cw0i
	o1KYxX38MAJc8vWFWwt4OyD4O2h5ZsA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753714273; a=rsa-sha256;
	cv=none;
	b=zaF1kcugA8X7N+ELF8CFcbdD7A9oZjwLS1Dm2bmU4cEWHpKbnajNLotYZx/ypSBPxc96TF
	CUDzPPfkevrYhFm9GOrNBOb6KI91NvWSYYNry7Et7ZFIyhxqSFN7QpsovxDPhl1aW0wWgu
	kClC0WUsz98A0JG8dSwhnhQm2J0dI4Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AuqEWPO4;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7183d264e55so41103887b3.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753714272; x=1754319072; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=plhcie/uWEJ2l8MLaYw41+bnUS5YGYhxQ5JWVcQv7gs=;
        b=AuqEWPO40ik0m635qniQrRuYtRIMes1gDxTmrvuu6AJ9xmdXPCtZB3UrbOzcU8p9Qo
         EZ2qnCyAOQk1hGX6Uy767PtnXEeFqN0XE5YxtkOyEeFJhkHDj4LJRnlf6+zKJm/azJ1Z
         Myig7TN49PY1UxHflZ3gj140huTWxaImi82jQ3pQlktVdGcoNCPQQquvvr52iHqB93zA
         nWe6edWDGnJ/LdSETLuv4dqWRTtd89ilKl9/reImLSJ+YngImlQciO0ROP1xZqtYYo4l
         0KMcYHLt0zz8mzoKPkpjbDsji3v6ILaRDqS23aft4ZGXQpsTL7QhzHaV+5gWABMabi5Y
         8IXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753714272; x=1754319072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=plhcie/uWEJ2l8MLaYw41+bnUS5YGYhxQ5JWVcQv7gs=;
        b=E+w0yraXwmMk2pSCShFfWt/71DTn+jWOIjFoEaduHIsq2cMsYdFBrdqy6BdGmatBs3
         CU/sJo85m42qndnGxMzTpkEI4bb4UA2ErhuiIK8jMPRlWEQSHmo6NoikaiX2P6TrZHd1
         ktgNYqu6P0mudPRU+e+NzImBxQiqQHBOYnersh7bwRnATptE7tt2QqXpcgMf22tNTRPo
         vmkri8qHZIy0wuT6lqMxPve3YvRZZwBvFDWvoFrhCPg/j68bsoN6Y0bOW8GMJMy4RwrC
         FCjDB3epGvNUtVShrBgGDw+hZHGSQqWlRup0qJ8azxPuzjgnd8epsnFIf2fjtXsZSRRa
         A8Vw==
X-Forwarded-Encrypted: i=1; AJvYcCW7BTFK0nZwnKE7FJ5mHWehgpJGQMBg6MMntT8ARixRgDWF6xk0RbhbN5DtUWgupmEeI7Wi7XKSHA==@kvack.org
X-Gm-Message-State: AOJu0YwytwYxrsuRoopNLTq2UYCIKxp2MTAYwuiXO8sS/lo9flZ6rA57
	edjxka8M/eUYMgqpq/+P6gg5/2F4mujzNajrFJ97GvMjbaoeP1YIcv7X
X-Gm-Gg: ASbGncvl+qX57wITp4AWtWXfRxFryDFOfdlwIgReOtp+tGFwGqGFNeYXNm0TDpV+K1f
	5k5OznmPpm3q1nCMP3CWlcNvtzP1ce2fierHTkogt6jCLauuIrPbLtC9Ip+V0DbTWaaHxgVDnt+
	rRn3BfkcMBx27/a+987JFYzVnoPlktzkQkbihj24p+wiX6GM1t0pucC411PIv2U4OzphAAk6pg9
	Um83bZp0fV2M8Km1Vlb6gjyfMp932rsR39HIPq3wUUpBJE8W6n55rNPZ0yqcw8d0eCbEIpMaAg2
	y1aJzHP+k5uoFJ+78i4Zz47GxQxjVoQCanPAr31fM5lMUa/XURgoLt4DMNMbEB51EcgG5z/s4DD
	oesQ1iLN0GPcghimzh0yc1w==
X-Google-Smtp-Source: AGHT+IFqruB0onDGfKbcBKOJcNNcVE2gI40uibzJ64RLl9KiQFHtKm5sGT8a7BgrgZDLUKDPK7Q3kw==
X-Received: by 2002:a05:690c:610a:b0:719:e1de:806a with SMTP id 00721157ae682-719e328a757mr160433217b3.2.1753714271906;
        Mon, 28 Jul 2025 07:51:11 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719f215500dsm13050867b3.10.2025.07.28.07.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 07:51:11 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Alistair Popple <apopple@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mempolicy: Clarify what RECLAIM_ZONE means
Date: Mon, 28 Jul 2025 07:51:07 -0700
Message-ID: <20250728145109.1524733-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <87ms8p2iop.fsf@DESKTOP-5N7EMDA>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2072240005
X-Stat-Signature: 1y74acwr5chiq3zgzbyb34xkxuaoks31
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753714272-633448
X-HE-Meta: U2FsdGVkX1/5s1Tdf2M0R5ygKGVQ/YchL+z9hDsSdTGLPtiRElRJNQM01+Q6vmJnah7Y9H7Mq3htoH+y+lknt3F+HKptXGAiWF9m4F8Dmbu6BSB22y1ODBnvMXQW90lo2DFRuhukWMDVbAL0vMm+mCYeQTY8aSuquu1RE1ayd8nXLofPJFgJ/lzwNZ0mBw8zxDGZBtSYHd97moHCruVwvyjy0nSEEaiDp6lbNuN1veXZrA2k6MTJsjeUdsOYmC7rMt7Jrs5cuKkFlGcO04WFZ3AGuxMGFZrEKDlfA8esAIrtjtwd3SMcG452TmYiPo8AGqS60n5KUobas1aDCZy3JeA95jG6v6QF2+YrGVq+eJ1lahYcroUT517xwxv/30PZZIbh2ZjdFFjk3PCj7m3Z92lhLUicA8nAoFjN229lbfy5YmQJ00Rp/1s6xElKZlBAiDP1ipPrXHj0uHxiaggAXf+Sxyr2VsHYCNgtcR1ZbQNASXzihqODWCLS4VTc3AqbstJZ0mgu9w7mG9MoPC24NJTpQi+yS4oE00je++e+cOQGZofpXwxg3nIjCFFTe9etyArw+vjxCEkSF0hPwQbZCM6Fp2mdgJ0XImzrx1jMxDZ/B08MKwdSSaSwEPeyiCVDDJXCGrNrfLZrzqFyhZnmXmrftycS710vaI44UDSgVDnC2yDycTpX997OA/tFsyceBkm3KcHyOkj4Zb88FkebRdw6D3cNmFbIIezPu1njMP2KLQgG9s9HS3/SoFp6zPbEQ05Dg8GNyUx4zs/sgPg61agEz3pIL+R243+tP0By6QYh8boVY6FvOckLDm77BAwx8mIL6qXtq4FoxhWGZCxlCiyJTvgAy77ZM2/Neu2UWL67/c9WLyDNiXgnUBN2X5F0azzDotOjOdC10n699a5SBc+fPmQl43ZCAN0BRFYLq+YUeFCX3VELRFhcitVTnlHuSuDIRKH/SIbg7EjHKVq
 WtiK5GIP
 r4kD/ZB52V48cpTbKSieuMT5CaBG76UfAMZzYEkStxo2TanGg2iXwboGaEv1eQFqOIuVgkxymab5eExeocpRt0eina2OIaQpu5Ut7/f4gLHP5NHCZrOc73WUMC3LRG1uo0G/HyOD4nxzhCrYgBwo4ehM7aaPcZzXtz+E7QFvmYHUDb/bb8ytbsIGKT7iSxVTAH6TBcWLue+vOdrdOMpFeDyh5j2ROR/E5aiSMkavb3yElJsn3Mfrz/x8Zsna/Tt79RE6Z+yDM41YD/y+Os0BgZIgDoAbregtRH7F7hdqqeE0fnnO8y6I6bDC+lw326jI9NZb+7y6Pj+xOHt0v05NFLdcg5hEAXpsjKXscX6vWJWVK1QA3LLBoxLQZqjG/bmL5Y74J/62Cbn3oNMGOSJ1gnIT5VZjIli6UFGXljXQeBdJtZZrF17xy7CAZLyQau0tuptFE3oC0VI992DMqO3W+mueDp2G4hdOS/93KhvDebKIU/gOK3UCSB9kPKfGGbIddHHVZdWjBMf4nxDBPT5yl4SuuvlNv5gKqMcMAnjZPjsgG4owWcaB++ZLA9C8Dbp648wMqYT3Nf9NKijP6h1uLWh5AKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 28 Jul 2025 09:44:06 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:

> Hi, Joshua,
> 
> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> 
> > The zone_reclaim_mode API controls reclaim behavior when a node runs out of
> > memory. Contrary to its user-facing name, it is internally referred to as
> > "node_reclaim_mode". This is slightly confusing but there is not much we can
> > do given that it has already been exposed to userspace (since at least 2.6).
> >
> > However, what we can do is to make sure the internal description of what the
> > bits inside zone_reclaim_mode aligns with what it does in practice.
> > Setting RECLAIM_ZONE does indeed run shrink_inactive_list, but a more holistic
> > description would be to explain that zone reclaim modulates whether page
> > allocation (and khugepaged collapsing) prefers reclaiming & attempting to
> > allocate locally or should fall back to the next node in the zonelist.
> >
> > Change the description to clarify what zone reclaim entails.
> >
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> >  include/uapi/linux/mempolicy.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> > index 1f9bb10d1a47..24083809d920 100644
> > --- a/include/uapi/linux/mempolicy.h
> > +++ b/include/uapi/linux/mempolicy.h
> > @@ -69,7 +69,7 @@ enum {
> >   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> >   * ABI.  New bits are OK, but existing bits can never change.
> >   */
> > -#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
> > +#define RECLAIM_ZONE	(1<<0)	/* Prefer reclaiming & allocating locally */
> >  #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
> >  #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
> >  
> >
> > base-commit: 25fae0b93d1d7ddb25958bcb90c3c0e5e0e202bd

Hi Ying, thanks for your review, as always!

> Please consider the document of zone_reclaim_mode in
> Documentation/admin-guide/sysctl/vm.rst too.

Yes, will do. Along with SJ's comment, I think that the information in the
admin-guide should be sufficient enough to explain what these bits do, so
I think my patch is not very necessary.

> And, IIUC, RECLAIM_ZONE doesn't mean "locally" exactly.  It's legal to
> bind to some node other than "local node".

You are correct, it seems you can also reclaim on non-local nodes once you
go further down in the zonelist. I think my intent with the new comment was just
to indicate a preference to reclaim and allocate on the *current* node, as
opposed to falling back to the next node in the zonelist.

With that said, I think your comment along with SJ's feedback have gotten me
to understand that we proably don't need this change : -) 

Thank you, and have a great day!
Joshua

> ---
> Best Regards,
> Huang, Ying

Sent using hkml (https://github.com/sjp38/hackermail)

