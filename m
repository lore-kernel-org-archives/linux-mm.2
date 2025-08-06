Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8784C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 13:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256C26B00A0; Wed,  6 Aug 2025 09:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22E8D6B00A1; Wed,  6 Aug 2025 09:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144606B00A2; Wed,  6 Aug 2025 09:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 044456B00A0
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 09:44:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7A84C038E
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:44:09 +0000 (UTC)
X-FDA: 83746451418.16.263F729
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id CBE24160003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 13:44:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PxHvb97U;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754487847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+BoskqRxZrTyHjmVFL6MiKmeRCMGEe1NmNgCqxmHtM=;
	b=GIGPlDjKMbDBaGvpP2TSl3te5TZ4GV8lZCs6u8jx1h9ylc/5J38rLLROy5qXsTdwGgiUk1
	4750IeYNbw93cewSiFE9ZCDg62o0Q3mrgR6iutM51Pyg8tM2wDotaJTUgXpXJWiAXamatb
	wOssoicOR3EBFX0DaAsvLiKbpDaCPgY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754487847; a=rsa-sha256;
	cv=none;
	b=ULxhCngHb06r40Hr1UgNLzxwBNbXEuAXR6VaGipBB73BmX1FukC7tEfaVGLZCWONO41bAB
	tQW2DncGY1Y23L9nbJnNaDI9WCuhJxf5PtyrDt6cp6+1G44s/SVxvCez23BaWRSMZwCqN+
	UgUPEVcKAJacagGaaJWALBJvcPL4p3A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PxHvb97U;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e9028e13bb4so801820276.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 06:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754487847; x=1755092647; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N+BoskqRxZrTyHjmVFL6MiKmeRCMGEe1NmNgCqxmHtM=;
        b=PxHvb97UXL5OBZug4fXqAYysoRwvkBMUhT3pQrq0PGa/4ckHRHroJIFqQ9P63jppqI
         ljFGdy3fSI2W9wV2jQ2N8MOsutEkpSqLx8UbBa681WrdL721g8ciOYiYlkT38i+D7az3
         zeKuw6DmGk3MJRk/dRBJD4MaOhyY6S4fD8SP9VgACrh8twSzzYbekwWGfuzKZMcHN94T
         lcDQdeQ82/fYcO8hz77HYDo2MX4KpAPxY50MSpwA+bzwWGZW6CWXwtNvGG94FqYKfGXK
         qO+hImWM2ODgfmJkrBCrnwZyQXD9UHfnO/KfaA7+sHzYj07p1ff9PG9kY8BUilBxKHFz
         s5vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754487847; x=1755092647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N+BoskqRxZrTyHjmVFL6MiKmeRCMGEe1NmNgCqxmHtM=;
        b=BLNy+JyN/em8CuLgFUty7zlKmIC8Hq6+yoqHhB2i/g+tDtaktLOO+hByPD45nFYuLC
         VFYzoYcE1PWWdkfE+XoppHMG5mual/nAU8m8l5ijRvFvOtGq/U4U6mdB/yjLC2t4ACxi
         Fc+3I3IIlajCMEyjYQz6FP4gEO1fUPXSMx0GfZUkh0i6lz8boTq7tIPcTNekvfM1wFuh
         N3vRk3V5HtBfnsEYrXXt7qvyA8QU/+YoopKVqL7Hh28pbL2khegU+5jcxziW8oz2cEzM
         Tigsun2PKTPImk6VhxzmD5bhYPRFp55iE/yxC3D3Td1S3dfTU8GSS1sJ8vDgLFz99kDa
         uztQ==
X-Forwarded-Encrypted: i=1; AJvYcCVq2ldxjKB4Vvh/zu7t18ov2vzjqiou6doRVXv2jpb2ncESmyfJgpTk9HQwCKTJeWG9+BqOGva3Gg==@kvack.org
X-Gm-Message-State: AOJu0YycIREw8yntlqpTDLMt7stFrhgxhWohvmWwHRbvpOfXVk5IMMoh
	DYXgKu2eVS14ibtDg2KInBqa4j+HsBVkB2ICd2uuzSE9LcGaa8JwSFmZ
X-Gm-Gg: ASbGncuCt5IkXoVzO+21me1J/ejD8ZcZH2ttQHl/UhdMz1jnS0PWNZXfZQJ6hmSzQC0
	Qke1BxXofFE763AUvD0s1QnoO1OFUJWyDvkODj7x+wDLo7Eaj6FxhvP2quZ37+Iv05p6YX2ZbZ0
	msQF8nybrUWATT/6/uXftK8vgyMq1Hmj+/tngXXM4MviABJTDge9+6gzRdb4N3HeIeDDqfVZANS
	q0pjtC67JIdwFXcOh3NzcbAGa8ncaIZB8yGRHnOdv8ahqvu2OqiRL62PPW+1F4ermDHR2Qsa5y3
	Bbb3mBJkeSKolepDPlhIiqFp904XTVxZDp279wqAR9CUfgPYB2xrhuEdY7nPymu40tXP7blTSte
	Kjo/FGtYyT9AxbjsCklOOYg==
X-Google-Smtp-Source: AGHT+IEawk87xQDQOVWUd1SSZMxS6FyCzOtqHsqYpXoO4yyDYZeLvgJgpUUMmfH9mL8lTAc1P0UXJQ==
X-Received: by 2002:a05:6902:320e:b0:e87:b880:7dee with SMTP id 3f1490d57ef6-e90287695fbmr3351443276.12.1754487846599;
        Wed, 06 Aug 2025 06:44:06 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:44::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e8fd375267fsm5550223276.15.2025.08.06.06.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 06:44:06 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	SeongJae Park <sj@kernel.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3] mempolicy: Clarify what zone reclaim means
Date: Wed,  6 Aug 2025 06:43:52 -0700
Message-ID: <20250806134404.2000234-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <87zfcduv3l.fsf@DESKTOP-5N7EMDA>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CBE24160003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: miwhfizdaau6u55x75e1mc8f4ifx97en
X-HE-Tag: 1754487847-962257
X-HE-Meta: U2FsdGVkX1+x/bgfeG07Trht6TEBcTB3rlIq0YXWXocc01xSa/kUmV7bOZNPopF6562bHrmQv0iX0Sw79iE4iWiI9U2s5jKznpjy+MAeQ43O8Fjn1lmCIk+PxlN8bzCDz6H3JaVuYkZ8N/1nVS7X1yeNTF+j25H3xB0R9uinwYaHyCEwOiNNPWAGzPFOeo12D+kZanb3j5HENr89xV98igWtBb9/US8+RBmLiNPPo0V16FdNGiTu0E8pxGEnP0utwiGInaJ2iH00ft5S9/N/MJD/eMh/Jymp5FmpZ50Pf9mQzWk2OaVyYEvB6JH7LogCM41+SWBvYnI7a/d1Mm03DA4w9VDXLkUORbvd3NvsuZZidxQGfTdMw47sjc9XH5zQ3K4PEbuPN61y9C+KuAuhl2WAoAvFv2xLMyobuIrlVShN6i4ZD328NAKM7Aow7a0xClBX6FpVf1RXFA4Mf/XZXuM/ATrE8bl7rLJKYKMVElxb7z08dl/9IFYVDmnhp9b41Rct9E7uOSpuzDbOZPSxYG7v8yg4IjNXFK+G1zIyCObeXJrW5u1WOOGoRjA5BsZ6hwYcemyuQvWiCfE5ppsu4bZ01mh0bitDTZNO/43F+ur8X0rTYIGIPkC6RArG7G8wmf6yQkwLbhE+8WVYtcbCjl2Nw0b2tDCal948degvDWWOLfdcRswCXPuxGcB3HlB6ynvVMYN28yJ8a7N1GBR/eLX9kMQ2y6pgYxJ7U90qB1TB2q2neXEL6bQ6st871OxLhjm/Cc7gterpxKwqb/jrABFFSevyYuT0+TYqdmzsTwGnu0DMD54UVEfvcQk/a2q3DRbufH6RQQ2Q69oCTe8VG46SioOMuLEDZl1QF83WzNQ+uu02uCsnpzZFueWZuRi2O/I+gA1W8LqNJy32e/Ffxffvh78woKxyXuxcZa6OvIjot43+NoZZm7DOPCe7jElkrrzbLhtit13A0gUy3pL
 gOX8Ju95
 I7QLSqTcZsbLtxnDfDEsuSUbsOdqELwJVyUWxVPj0JEc4rbPHcXVQQ8qEQUkY4TJ7QJtaj5Vkc77xOkm3+ofA2+h9hHVri5tZCQpXol/XtIE0ErqTKcmPuspO5XKE5lj9MZmbVE5m8NFaGnTIzH6bOPduxAFNhcZXe+w6ehOdJGDRVkt81bXVAzpO6Fa9m/vDWSoUJA78oXj5ek3i4R3GsmpYnsDGk/P6ggBwKxh1KLzgh7Bq/YoYnldgQsCSgsTW3YGcAcbdXDNLY3ZPl9kgTjqqFGVlgWHa96Nltzu8uqBjXdhkCAieeoVCCw/vDboqObjfNB+8oRo+C10SBS63uVXsnXs2JLjwKKYcN5njQ3DfAbjsfsra8oZugz3Dnwag61+/KIC+NTdm/WeJ7U8Qjmoljc3ax5KiTvIEIukiLkkNoeKcXp3L5IxbPUYpezVg0dfbod85feCcDqpeqQezxeBYilRHqcUUl+unLedgWtiVQrj00MCDFib0VJcJI+w6CHHgrMqSCyCYdra/uzDNSTeHzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 06 Aug 2025 08:55:42 +0800 "Huang, Ying" <ying.huang@linux.alibaba.com> wrote:

> Joshua Hahn <joshua.hahnjy@gmail.com> writes:
> >
> >  /*
> > + * Enabling zone reclaim means the page allocator will attempt to fulfill
> > + * the allocation request on the current node by triggering reclaim and
> > + * trying to shrink the current node.
> > + * Fallback allocations on the next candidates in the zonelist are considered
> > + * when reclaim fails to free up enough memory in the current node/zone.
> > + *
> >   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
> > - * ABI.  New bits are OK, but existing bits can never change.
> > + * ABI.  New bits are OK, but existing bits should not be changed.
> 
> Should we avoid to call sysctl ABI here?

Hi Ying,

Makes sense to me as well!

Andrew -- I saw that you added this to mm-unstable yesterday, would you mind
folding the small fixlet below in with it? Please let me know if you would
rather that I send in a new version, whatever works best for you!

As always, thank you for your help : -) Have a great day!


Remove the reference to the vm.zone_reclaim_mode sysctl as an ABI.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
index 683c130782f0..8fbbe613611a 100644
--- a/include/uapi/linux/mempolicy.h
+++ b/include/uapi/linux/mempolicy.h
@@ -72,8 +72,8 @@ enum {
  * Fallback allocations on the next candidates in the zonelist are considered
  * when reclaim fails to free up enough memory in the current node/zone.
  *
- * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
- * ABI.  New bits are OK, but existing bits should not be changed.
+ * These bit locations are exposed in the vm.zone_reclaim_mode sysctl.
+ * New bits are OK, but existing bits should not be changed.
  */
 #define RECLAIM_ZONE   (1<<0)  /* Enable zone reclaim */
 #define RECLAIM_WRITE  (1<<1)  /* Writeout pages during reclaim */

