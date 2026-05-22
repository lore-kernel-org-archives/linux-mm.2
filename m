Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7003BCD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 16:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77BEE6B00BB; Fri, 22 May 2026 12:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753B16B00BF; Fri, 22 May 2026 12:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690CA6B00C1; Fri, 22 May 2026 12:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5AE686B00BB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 12:16:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C71D4C32BB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:16:18 +0000 (UTC)
X-FDA: 84795558036.16.52DD9EB
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id D31321C000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 16:16:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q0r7+mfJ;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779466577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Z1BzU0TCCSZhOvR13JsXIxVpOY0gN7R0aERAlJ0Ans=;
	b=L1olNBAV17xx4CxIyelpMeEovAunt9KyTMC7F1ymUFlrnz78uAPz04YAGscOfatCfzmGxv
	w3GPp7IEnrRvxwpxN0tzoI32JJLA8GGEh5fX+dScv7PJYW0LUkVVp7EkV7/Pbq1epzHmeE
	YGeJxtCImxUQwbJfKO6myb/oMOuvsjM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q0r7+mfJ;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779466577; a=rsa-sha256;
	cv=none;
	b=K/NnucYk693NCZDSUkpyjsl+0sx1S2/FVXRJ2QkrgVaa6d60hTTCwQX3Fhr5RzVMPhsKpf
	jcR5aLP4B4d1GsRPTMMLdeJjV2cI99kjKJsLkkmug9IEmUilVs2jusK4a4y9w8IEeYK8L8
	YNSw/q6ZByNpcw7JcndfnnezCQwHKOM=
Date: Fri, 22 May 2026 09:16:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779466574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0Z1BzU0TCCSZhOvR13JsXIxVpOY0gN7R0aERAlJ0Ans=;
	b=Q0r7+mfJigdGlW8RWCJe1aremsWrxqE6KL7UKXX4fkS+fXcRHFRRk2UtaJ5w02O2diHDkV
	yRLTtjoJxg0QbEYbrhpexs4sOFebYZuk2wyEMlAL9Ust7lt1jsmA08/fLTOJRfKEKZXOF4
	xA63/cU2zqsFx0P9+xcXZgYsgfXml60=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v3] memcg: cache obj_stock by memcg, not by objcg pointer
Message-ID: <ahB_kaWXowIIQ6dQ@linux.dev>
References: <20260518222827.110696-1-shakeel.butt@linux.dev>
 <aguiSnY3ie1y4nEl@linux.dev>
 <4e296262-fbbf-4ac7-aecc-3ef831583704@kernel.org>
 <agxszIIN6FtK0fEb@linux.dev>
 <ca8e655d-5fe7-4957-8a36-6667616be8b6@kernel.org>
 <agynzVVBb4CYJTYG@linux.dev>
 <20260519134927.ee04379d07b0674872422c06@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519134927.ee04379d07b0674872422c06@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D31321C000D
X-Stat-Signature: 7q5zhgnshncdbfzwqfki14ox5tyxee44
X-HE-Tag: 1779466576-827807
X-HE-Meta: U2FsdGVkX18knUx5GFWHn80Vr3L/Fp6ddQKdOJ6tVxlah8a1DWIYHf2eGls5yoXMaXgkStBVJbWbxExMKA4qvghR3jLeQNg3P9H51WxwbCICsmOMqjpP6P1H+Dn4rGYNl0Q1Du7CZvIpRi9cKX3hNk8qr5NZntx7pRaYPb9zOCsyekNJ439nLl1nv6yXtKUnkQazQCRYUuW8SKWjrWzbvd47DWHhQ/kw0eztg5o2i6silZaUTp1/OB/MOM/7114SrC3F6K+F3Kc1gb+7IyfyjjC9uN70bdXt9bllee1KFjt6raKqWoVoUC+s+s5LWWCEdg0YMCntcGWz/N58k3yODH3XusgyM0ZdL7hNSceUYcQusqUwLTATVciQf1qcVkx38TgxfLKFAnR7jwPH0TAOeYygV/27nh7SemGK+fYrLrflT6uM5F9I1oPuOls4pP9eSVVPCXqD7uHh9M/by2WSDOK31eNegyW4nxBSgyWubt1uqFkEbT2Nmr33FkPP20BNp1LPVpUGVOzTFg2jCpfrjib6NWmx0pH+w4bJ6GIOXfmeCAy/gfTyo/OD4AHuBsG8I4zHNCqQC9cunpMO3keM1NbRoWfwIuatEe0/8TBHd3WvsoqShfdtiBTbhhbPZjsWWze/3g8qIsPzdgVGuw13oadrzI8VA69PKy69N6jzvPs+Rb89ji9/3ZAugxbEkGbUrTVfK9XHFQ/bbbmxiU9bcWpZGfBOfX6bzyt0G0XgTWdJaFnQJ7SkdY61s6iup+o2Ikcl+djJIMFgQMAi2hcs47v1dbt05JdK3BiYPRliukkk73iX556oxt24J6XdFFqBHH/k780OkOXECGSHA95m9YrQs+oAvf+2Buojeq1SJVew/bailsnvSPyA6JgamT8WlSn5qROHC+b7MaK8Gvf8WUE+Bkjc4GscrBo1Bkco3P59wHrWoZf+xMvumTW7doES1eHx5aGWOES9urq2OnX
 mSolleLO
 4o0Nd++FQxVSh+xzA+tDRjUmo5UUjVrjs3+fgm/IMWGID57OUnsEEJ91VhS6nyN/DPaLmaGV/G6BXjxS8afUaiBwMYBfP0AjcPD4okbUteNxipgyUJIM44ZwLfQf/23yj9+Z8vnP7jV5FXvVpk3T3maQ0RvYjsDBmUPY2JHibU5n5I083aD1kj9fQjuHad6RuA5nw7q2Xzo5wXsM3Lne9QHh1+Xo8BbYpq28z7H7Qj7tugGQdEIw9wkaiPrnYcKG0HAECavywYDaAJaW1kqHGtqDIqtJ0qURs7JBGiM2UcuN8LHcpBcjNUWhcqb6y4mxxiz5NYjvzsQfnG4SiaxH5X7DB31farz1w26og
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 01:49:27PM -0700, Andrew Morton wrote:
> On Tue, 19 May 2026 13:11:13 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > Andrew, please don't send this patch to Linus until we decide on the option.
> 
> No probs, I added a note-to-self.

Here is my suggestion on how to proceed.

1. Let's drop this patch (memcg: cache obj_stock by memcg, not by objcg pointer)
   from mm-tree.

2. Let's not add anything to 7.1.

3. 7.2+ will have the multi-objcg series [1] and the patches will have fixes
   tag. If someone uses non-LTS 7.1, they can easily find those patches and can
   backport them.

Please let me know if there are any concerns.


[1] https://lore.kernel.org/20260522011908.1669332-1-shakeel.butt@linux.dev/

