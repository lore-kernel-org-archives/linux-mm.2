Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDA3C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223136B00B2; Tue,  1 Sep 2026 04:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5526B00B3; Tue,  1 Sep 2026 04:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C36E6B00B4; Tue,  1 Sep 2026 04:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D15176B00B2
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:18:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52E5FC0376
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:18:19 +0000 (UTC)
X-FDA: 85164491118.11.F7FBF4C
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 123B940008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:18:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LT0R4Z7C;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788250697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vDg7iEVSu1Ou77o1BepraIOCR0zi9VqjbIQOkb7jb2Q=;
	b=yQw9OYmzCSV9SRQkc8Ofy08gZ0Q3b2PSRNUnde8dcP14ardPPEF07vnSgqRZtXgzvThEjO
	db9cxHJoj2KSMtAlSC6nD0Yie2XRza1C9+a/xwwvLUBmcij94YobqIwa4L4aG6IbbYLnv4
	gEGlOpiRwO4/066ikA4Cgi8dS0A22YQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788250697;
	b=LaUz4xho9/03c+ByF+OF7MtdZkcMeugob21AsrsQ9bjdn5hoq2U+y0kWm6GCc9KuM/1kb9
	hV1qPtyuaazseMj2ntlhCE4koqmng7Rtw329uA8ZWJ3USq2tt2yk+lwCL6cZwlr8e10O7E
	bMt8zmrY5dk0fw7aUhJ0WH0rFgudVVQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=LT0R4Z7C;
	spf=pass (imf11.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso51218245e9.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788250695; x=1788855495; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vDg7iEVSu1Ou77o1BepraIOCR0zi9VqjbIQOkb7jb2Q=;
        b=LT0R4Z7CsPRFRGF5p0KlyM5P3IVG9G5hH1pgtKo+uTR7SSyxQ6nsxktdNxRuwBAJQb
         jhXZAholM3gwrd4mHBdMGsdLy0M0Maq8vQSDr0TFngqupSKMWFL5ylNAqFVdxc5Z02N4
         2H4uXFPw0ynyKyhJvLCJAOK4EOzXhKq0cnRM7z6OyLJuBEDKPmbiY/xLtyK6s9tXZxYp
         ztt3Nq4kCXvkXTtYjBNPn6gHgDrWfQIndScQn8MRFhFXq2Ig0nuhzLsf7i+VpqOgCyMe
         1vZ+W54wohaYeWGle+uqUDdTr+UYz8KCvvZdhYsdHNuabctOiWvv8JNphae88dtGnHj5
         e2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788250695; x=1788855495;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=vDg7iEVSu1Ou77o1BepraIOCR0zi9VqjbIQOkb7jb2Q=;
        b=II4BKpAYKNWXv4W1IqpwSMKVIhYWXxVgC3m3X2z13uutXj64LonUxqnyz2BeB+uJQ1
         hA2GjE1bJnbxsaaVjkTyJa4BBNj68cjMcPmH2qeyOHxitDBDPTDj/uYyumHBKBJ47aqT
         SgFG4LFZaGPcDG6YfZTABwpU+2c0bPcLhVt6/ISNvgZ1xaa9YA5iQfnye2cQAcuSAc2z
         9LgnV6UQj76poj2O+bwQlNIBm0XU2+jIxLXpz9UZmrpInKeSvZ9UGVJG8Ker+2tQgjg+
         vcBQHRQp4Mfrg8PpKOcJ2JZnaX/l/x4KNMe8/5D2XMMty9KFcoELt8NV6YnmW4xWiQdT
         HEiw==
X-Forwarded-Encrypted: i=1; AHgh+RqOTcyfPKp5GLNsvvFswnAdqpCxzOzP8hLUK9HXV0BSmPjwSNcvRY0yh5HkhT4/rqN6oCyo580WtQ==@kvack.org
X-Gm-Message-State: AFuF++kMnf9hXrYeLohNwRwq2mY8Fatm/24xhihtbrZqwiCiy8v0ETvO
	nw9se+UwaO4X6cBT/GQVqZ6Zdv+c/A1J/WaFIF32QGAxTAxv8n2U7/z2l+YAobjXSP8=
X-Gm-Gg: AR+sD12TGUgzMOrWTAe8lzAvbHv8bblyUEnJFYtGZWaRptXV1ru9QaPxOqRFG3mgyX3
	a2gmSDea8WHqMgz9lGqIdB+nXe+ayDh0IqgTH7OKN0HqMkZBTrlV6PxCdcoHrICbzbo6vEI3rly
	pJSWrQhMK85AF7THoAZYcgS1mThC0pRpTFGJQXUoGb3bGmLFbxoRMQ7m4LlT+A8nrzrvCvkDAdS
	mCwsGpLHHtuFCJofFH9T6OU/e7Gf3eNRNt/8tRClh74+mwMJJQcJNmzF7H3v82iSRBkWtwssTMz
	m6rPN2RCBsyI0SdRctrAnb30WhNnlHNtDpXMiUJv58QgmXcAo/tZhBMfqXPFWUdUJlJwCynfbEC
	H87EgfyZaCKc5gxIQPV1XEMsMhuMIZvf8U1GkGveOmsv7RgG13l0/LMxarosFO2L1iIW3uHC5KD
	JS/CNkR6rc0wvZqJdG2m7LBAR1jVBNPxDP0ciGupCJfk5U4BEQpP6ckP5CobQQMq/OXCoGRUw=
X-Received: by 2002:a05:600c:19ca:b0:49c:cee0:f383 with SMTP id 5b1f17b1804b1-49ccee0f3cdmr296600475e9.16.1788250695555;
        Tue, 01 Sep 2026 01:18:15 -0700 (PDT)
Received: from localhost (109-81-87-32.rct.o2.cz. [109.81.87.32])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48442c42593sm3530650f8f.2.2026.09.01.01.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 01:18:15 -0700 (PDT)
Date: Tue, 1 Sep 2026 10:18:13 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Stevens <stevensd@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <apaKRS7TYhlGRRW3@tiehlicka>
References: <20260831234339.280376-1-stevensd@google.com>
 <apYXCL_GJs9Ovu0v@linux.dev>
 <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOiLmNEV8b3TW_Q7+h5mYrZ1Nw73XcPFPUsapeYObLYajq_PJw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 123B940008
X-Stat-Signature: sjnrww8ruts3ouyzyrwg6uemja3jpxze
X-HE-Tag: 1788250696-844599
X-HE-Meta: U2FsdGVkX18mCUXqGqNPyEgOrrVF3rfPO/W655zHw0HbE5FFMkCJqEphx2zAhDEnBQmnvdkIY40Toth7LDMffVd7xwGWSe6ELLA17fMBi2Lsp1AYp5zGHVB+1mrzp1hbTuhlGqWfDPflIfakNF5u6TkaBD9r77MgPBL9qwme/NN8xV2LhoNnNWE9kQJSURXCTtO8Sr4ezkDqPRMobBkALlnR9qvhk2AxX3mpnq49YvcX+E3IiiiP6cX8T7dbA7s6urWI2i18wYx1nrN9sWmdK7g42tZ9RtzF9E7s66KmyCjVzKS58nfjtG2qpKXY8IESALC4ADLBRIw+Ytk0UGmxhTGGjcdqtdDZX6C1ZykJ2igPYaa1TmEvhYrhoYOEuM+NqJs8xGKcEEb8l8Y6k3sn9zYAPPc0zsnpPMJDEJr1AUmra/HJRgtdOTVUa1lv7oIgjb5PqT9OXY+l+KPChaTPO7+0rwEOZ0ldKae5G3g+5rFZb17GP0Jjo9VjHM56fQFr9olhCl1y5SPkZfz29W2/ETjaZjCTDDSqMUPo7WWeLBMJHb2CJzisehR868n38RWG8ywWZz5yoRiJAQ5Jp7YIjsdVsT3PLauF43PFke4AF0AkQa1e2nqnnCnZNmMckh+szGM+Jot3QkIfxPTnN63kHNzTQ+rDiqw0jbkhGQGwZOV4K0MaR2uGQ4GqOpGZcZa57GysO2IRhpWDeqZ+aEfeXBHVydR4oqzrDHGGxTs7fztvF2mvPdxJlS3FwfFvhO/CXcUVnhcfzUcHEhfd+fUOWDnsaB6XvEfuA5/3smkmA/eKF9W9t+5TCsa5TmG1s3upgT/rH5/1wzn2wpHuf5Cw8gkFw54jzmKD8NQYCvX+xfHvJjbqHZiqDN1LXnKn23+vVDB6AFg4/lqbbGRW0sLxRgslqAQ/I+MD2Je7oS93Htq/zaZQfTPUBhmWD5wLU+BxjWh/1ZiFd6GtGsgCBk/
 ALzFYCN1
 DJSXapAcvFqPgrBejMtaX32/puCDIOv+4GNNIE7t2crn9LeCasmAXCUgavzZ07BRnnuRz23ov9viV/y2IuO92ptpK7tOsDoVZFz0ezSSHkXuirT+Kwu0eCKQVMWwvdUqsyg5ohm6DMDa6XkmEqx8rwX4O6+FY7UOWSoR1/xrL4fWBAaSjqPKsUoFj8/qlqwAUjvZZeyA/5NnTv06/YFO5bpuRxV/ke/mVaGJHH/nQ+JCDJjJzJDTGSqduR7nIcNl30aIcr6qGnCEyKexZaNYAwa/ODvVMsrppS0z5frNanxS5vvW90GxJwqVYF0TdChCmLiDYa4oAkK6U0TybIlTl4huseD0goLh96SIV3NLg89VccUEy3pWj7mAt5MaXHdRMjsg0NDQcx8trTjwhEx7Qoj11R8KStzVbhmJiHTzLocK4dogD/do0AUtNd8hNFAJk/GSm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 31-08-26 18:04:57, David Stevens wrote:
> On Mon, Aug 31, 2026 at 5:10 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> > > Memcg charging can be done from any context, but calling schedule_work()
> > > isn't safe from an NMI. If memory.high is breached from a context where
> > > spinning isn't allowed, use irq_work to schedule the reclaim work.
> > >
> > > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > > Signed-off-by: David Stevens <stevensd@google.com>
> >
> > Did you hit this issue or just code inspection? I assume this is the
> > done_restock code path.
> 
> I just found this via code inspection. I spent a little bit trying to
> trigger it for real, but the only way I managed was by writing a hacky
> driver absuing alloc_pages_nolock().

Then this is not really a fix but rather a new feature.

> > > ---
> > >  include/linux/memcontrol.h |  1 +
> > >  mm/memcontrol.c            | 12 +++++++++++-
> > >  2 files changed, 12 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 8170bb8066a2..036d973ceca6 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -219,6 +219,7 @@ struct mem_cgroup {
> > >       spinlock_t       peaks_lock;
> > >
> > >       /* Range enforcement for interrupt charges */
> > > +     struct irq_work high_irq_work;
> >
> > Instead of adding more complexity, let's just return if we can not spin on
> > done_restock path.
> >
> 
> There would be no guarantee that memcg reclaim would ever be
> triggered, which also would also stop MEMCG_HIGH events from being
> generated. Overall that seems a more serious than just dropping
> userspace notifications like is done for MEMCG_MAX.
> 
> That said, it is very much an edge case. I can send a patch with the
> simpler fix if dropping the events is preferred.

Yes, let's go simpler before making this more complex without any actual
user.

-- 
Michal Hocko
SUSE Labs

