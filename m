Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D43FECAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 15:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD798E0008; Thu, 25 Sep 2025 11:18:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A5168E0003; Thu, 25 Sep 2025 11:18:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA678E0008; Thu, 25 Sep 2025 11:18:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09AD78E0003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:18:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B3C401A0191
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:18:35 +0000 (UTC)
X-FDA: 83928129390.01.C85460C
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE9B8C0008
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 15:18:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="WeN/fhxW";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.166.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758813513; a=rsa-sha256;
	cv=none;
	b=D4tDmbicYChBqKj+rZUKx9Nfb9KsSp5utWC+oegBQrLqryt6aqHYsj0ob7eYWveeGQwc0x
	gg9klAGMVIsVe390sk1u1Ey/1xDo6EKywVxWhdjwVvReXY4R9bgamYetmLGABfv70w0L0a
	kltz+AK57Xt13OhJBkF6udFMc5esoeU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="WeN/fhxW";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.166.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758813513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uTV7SOBwRvtCz9nLHK3fWm3pn4TCNp2vMjiqO7XDDco=;
	b=5euaypvOBHeb/j/AW7rxS3WtxB/3nHSrV0LwZ5m8A8BQheTD+4QfpreVW1kucEPQ7u7kQ4
	wAQ/w8MIATGL9SEhSOwibeoPgVVHvc/9KUF+mwaDW9WEIvQwXmizu1zZSowogujOfU9LFL
	zr0h8WZgNbs7Bo2FgfzguQLc2lc2rQg=
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-4248b320541so11596685ab.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 08:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1758813513; x=1759418313; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uTV7SOBwRvtCz9nLHK3fWm3pn4TCNp2vMjiqO7XDDco=;
        b=WeN/fhxWe3B+yFAiS6UAAv++ROIUFRm1aDLe0qYgo8ol63yhKhgikfCJB6GKgMkETR
         NMXeXgiGNqShN8DEcnv3PluuCon4lomGWdOV1DpUxO/22s1zFGqbk154jZzEvW3xdwZa
         NSUwi84l+8F6l81v7jf8jLLpZkQ90b1LwfLtNZ6X3xpPaxAWQ36A/rskvCQDTnu/9AsW
         jGU9bmEogp9K+Zgbismb72120CcfemJbF8gOpkqZSLrw0OdZz4HlUT9OO8HI8qm4eCQq
         C09JPRY+kBh1Rmt/Ym8YuUYIqNWlPvCTYgCR/afjkJzez+n++m+7de7zDhXk3hhYSJ1V
         wZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758813513; x=1759418313;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTV7SOBwRvtCz9nLHK3fWm3pn4TCNp2vMjiqO7XDDco=;
        b=wuV6DkWIl3a2b7lJ5dzzjrU9zDWcJWkf+rg1X8ZmkqNGA2F1qMYO2YNlOARbNyo52i
         D0MUbbGepTIAvdf9eFXuiqN8ev/442u0roRnNEhlFFil+PkscJvm6OT6qB58kDh14yCR
         Zji4X9f3Np4APHSLULoE5pFRj6HG4kLhelnzArGp6U5XnLa3tMvqEDh/8Mmy46i3nUpp
         rkrh2OSD36R1dmT8HcRRiSymYkrd/WS1CsgwPNyvaSrVMLqnKI+HxzJ/BIw2sQuYzJsM
         gUtSRxp13PNS883zf72A4hj11ZHkwF/7a5PbJDiC2UkTYbTlabSH9jRp3poYJBTW/VxQ
         c7JQ==
X-Forwarded-Encrypted: i=1; AJvYcCXP7JNGjp4r8vvNErDS9k0Ty0NyWa2F9sV+E9Qsz3MP20dM7ZaIdlOMMVwQzi+ccqHKAetbeoAh+Q==@kvack.org
X-Gm-Message-State: AOJu0YxbIuiQloUySnHvZodRz8u0gRl9cSjZrgluR94ZIN+RZIdHocc5
	1k392KqYJlL7IBu0XNJrtcGj0ggEibp+1sVuFhcguVMnAV5ctjxV+nA/OhYwRk8lZXI=
X-Gm-Gg: ASbGncvicpS+fKBxtEwou+LREdZk6GBZRTvoHaDt2C+Z+mfT4/z1loIRopvsbFWVExd
	f64BuF6+ID6UxUdGekxJ6v029sb9UPGAc6N/sGDzT3Ba6Z6CFR1+SWQqkhCHJ91mv2n4VHW50Sx
	k+bpmtEIZZOR2l2PaniJjElY2WMP1dAaowckE2pXw+k+wtjOPrRzXXUXc6CJSovo/S0RwgcZYYU
	OqOCLLNIbN5tfufW3g8wFN6JSMxzaVOhyw286cqotRgrW2YGC/NyQiqu5ON3tcpdANqpJJ78PHZ
	mq6QSQ7t+68psORPwn/tTwBqR3wu3OzDBxVYro8/cYJxRQS1iloHARiqMB6JI3vrYyj22yM432+
	dC92S8oCKObKiemEZ//ZCFyNYdIcZBiU1GRShcpseTlRbDQeY4gc+eeOmeBJD8f0O7Qb4qJkGek
	M=
X-Google-Smtp-Source: AGHT+IEE6BSjkeOHtrqgDMGp6UEs/8XlcmOungL2XSRC4po6mROif6Vk6dLzPa16z642TGp7LJtOhg==
X-Received: by 2002:a05:6e02:3789:b0:424:7633:9e72 with SMTP id e9e14a558f8ab-42595653cb6mr54081225ab.30.1758813512638;
        Thu, 25 Sep 2025 08:18:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (50-32-2-77.vng01.dlls.pa.frontiernet.net. [50.32.2.77])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-56a647da50fsm909985173.15.2025.09.25.08.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 08:18:32 -0700 (PDT)
Date: Thu, 25 Sep 2025 11:18:29 -0400
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>,
	Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dave.hansen@intel.com, hannes@cmpxchg.org,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com,
	Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aNVdRdXVzXSm_4SJ@gourry-fedora-PF4VCD3F>
References: <20250910144653.212066-1-bharata@amd.com>
 <aMGbpDJhOx7wHqpo@casper.infradead.org>
 <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
 <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
 <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
 <20250917174941.000061d3@huawei.com>
 <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
 <20250925160058.00002645@huawei.com>
 <aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aNVbC2o8WlYKjEfL@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE9B8C0008
X-Stat-Signature: r168uzs4ee1x8awnxu75pz9j4z9sa34q
X-Rspam-User: 
X-HE-Tag: 1758813513-457133
X-HE-Meta: U2FsdGVkX1+046MDK4CSgKDayfxvnd9mXkxQfVxgjmG12EEQwhnMCl/8EUm1s9XF4no3QOYD9X7X18+qxCx7NmhjRPA1OfDZk5Js0FjhX8jZw1nvV6uN1KQz6xdIwuz4r53z3tHi63melhF294hoCqkp2euJ5SLOUTcvU6W6Wk574t5hSbUTTyoFTT9y11+rJB0Ztc4YRUBjrT+dPJiM2jnrq90pvpLVZ1alWZFotKBX41tuqLG00PSL8PctTD7PBkbe+urtAwoE6lgoWKiCu8SA7nLYHQ6rrg0pPS3YZdhmc9HasrehG0W0YLFSej6mzuMlqHpzSV7QgA4OrP04DJpSPDxyBb26ByOScRnOR8aIJGIq7jz1otVaWYRDLi5S4OkWnmHqu853m8aVCKVHPshhFZ/f7BxzSlBSxypuR9SrJF64bkUpX/+Ew76mUR3IrYZb8oeG5KzhBJ4sJ4v+QUUHkKzDOiSY/q00DlS8Zz3Ge0DDbU/Yy3vTzSUeXO35SzlOwwex4Z5pZhcRpO7xniGKiDNROT2kjJ08RiRt0B0mmPjhTQZTmWJQPv0voRh6ZMrwBpWqHHLLfB9FBu2uGNORe3NL0XY8g6oK8RgplWblDWQZ1R5jDa0EVVFUoryQwmWQQUUq9WHLWesMZ7a2MVkIZOl3wP4DrEOlNqZ3AIg9o3XKtYHLttDsckkcwK0OtSViXQJRNSXA6xGIAft/klhHKt1IsB2ZxLU9r33SJEmGU5gJBiTUocXXy+fVPcNxmntkm6OUhqmGjEQUQDAS3TEPkaP2n74eLsP5i8G7Ijw6UU1Wusi5PDfMttpw0z2m8Mct00tfEYAXtNzzmpeAcpFID6q16k0MusAFrBUNyLL3hQ9Gh9xpsjuFp6FVfW7IhHhzZHRRDMSB6FbBiMa4pR2B/luee9ua3LahnTOFoV3dqzOtegtdjzryik65JKOv+qfbsfwI9FcMD/7/0G0
 vs3FW2by
 Pe0aFMzUJKolhSnCVzraZKEPPSDusJYSFdifr85ddOA80Sz0acS8LmNy55nu8OidhHXIhIQpkKLgfxxLHHsLOtQV7J9BjXrFcDKKBcwBr/ZG8/nZHvGMSkbrZU8f3zHpP7g1bZfmbfXm8MkQl125zRLttYNQGn0ZpEX5KLovlHvODdWkZOiQVNrwiKmoMZrx6tbD/EGP3bp7v2lVuT+YgIMQltuXgPrA7C05VWfqLKosTwi7qt5J0UeyNhgor2Hbogwg2rKV5B34FyhztrQwviSbOaYzK8CWyHGoMIrgiWtj2XR5OpP2VbEJ5bIV8hLDTf+XzdpJfH0xAs3Hb4xSFidHRdQEju5Cf4f8XhKlZmkCSBWqQP+2b7GqZK0aBJBnyC+XAWl2T1zNoF8HgM8ouQEq5+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 11:08:59AM -0400, Gregory Price wrote:
> On Thu, Sep 25, 2025 at 04:00:58PM +0100, Jonathan Cameron wrote:
> > Now, if we can put this into a special pool where it is acceptable to drop the writes
> > and return poison (so the application crashes) then that may be fine.
> > 
> > Or block writes.   Running compressed memory as read only CoW is one way to
> > avoid this problem.
> >
> 
> This is an interesting thought.  If you drop a write and return poison,
> can you instead handle the poison message as a fault and promote on
> fault?  Then you might just be able to turn this whole thing into a
> zswap backend that promotes on write.
>

I just realized this would require some mechanism to re-issue the write.

So yeah, you'd have to do this via some some heroic page table
enforcement.  The key observation here is that zswap hacks off all the
page table entries - rather than leave them present and readable.  In
this design, you want to leave them present and readable, and therefore
need some way to prevent entries from changing out from under you.

> Then you don't particular care about stronger isolation controls
> (except maybe keeping kernel memory out of those regions).
> 
> ~Gregory

