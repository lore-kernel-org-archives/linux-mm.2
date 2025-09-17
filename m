Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D509CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 05:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AE918E0011; Wed, 17 Sep 2025 01:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 685BC8E0001; Wed, 17 Sep 2025 01:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3548E0011; Wed, 17 Sep 2025 01:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B8F68E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:22:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DF93613ABC6
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:22:06 +0000 (UTC)
X-FDA: 83897595852.27.3E9C37F
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id E4E944000A
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 05:22:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="bOCBKn1/";
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758086525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4V0oPOiHcQlvz8Wl1Te3jqJzsEZTBdcCgGtgXa655o=;
	b=RY6ToDHKasIOws/IqlwoMDZAQNqAiuZXtlteiRpB70sSGncgsWU9VF+snsOXXaH2YM4nLI
	6r/GLbdi0OP5wPCEQnXtRk7j4SrcVNIk2iZFrrB6MUYxQZLzzknrn0URxgBPr14O9Lc3bX
	1VZ/4hWKvpYe0Dd97mW/ln9+8B81vrM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="bOCBKn1/";
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758086525; a=rsa-sha256;
	cv=none;
	b=J/akpZy8UqjJT0fcr9vsMhtfhZQ5vOwCPQGJqX9byHc1IzxHVg/6QV8Z5D3YnSsSJ1Ty+2
	XVz+5jq/cCPGMljT6ZyQEmgjdeVAnssLQBS1CAOj/BSG8llIc/jdwQERrro28uDQx2yl6/
	WGWM+HWB8wTJ3QG3r+nkxvnRry52oVw=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55f7b6e4145so6832047e87.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758086523; x=1758691323; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J4V0oPOiHcQlvz8Wl1Te3jqJzsEZTBdcCgGtgXa655o=;
        b=bOCBKn1/cXfMNj0cKDOwugw+58GhL4JEXcaLS+93Xx4s99GYdZJh8jM5CsvmcewOc7
         0tp7VrXzqtQvFwlTkYTnd6ArEzGbxJyzA82V0ANjYXU4NtK74D9RwReoVpIbI7wCGJ6J
         OV0Q8SwcpudhdCuLqcmXSqGbJqxsTsQJPlkgXICLBC2AGHFOmdeBYxlXTNZ+diSzjldJ
         xVDqGWGvWPvRdBXRMP3Pr19Y6VCeYjB+1H00dvBzvrP3h9FHUaQBwSULqHZPAZHbgXwe
         BlFG9cGkOWCZNYfOtVKlWKHwlMd8bZqnbjKXl7S9uW75lJIZdptM5x8p1QdR5RfNAvpT
         oKPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758086523; x=1758691323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J4V0oPOiHcQlvz8Wl1Te3jqJzsEZTBdcCgGtgXa655o=;
        b=ePO0TFmGXvhixmU7SEUCH0UP5U3l44LaHpzONfJgXLmjcnSt2YMQhsfxaZGURPmEJB
         8lrgARii3HYQW7LNhVEHUhffrHZMo+Ogw0HGd7aFLnZdGDQVF97EQ1ymRR5gtMg69Lui
         FYsSTGefvIVuH3qEA7JlZxf+D37OZ34mQ6omqa4nWIMytdGBpSpbIMck9wwD9ibrl+9/
         AsbP2SIm13evpwSlNS11Px1C0gO/A9jdjliBu3XGxOr2/IZ2Wb3mq3cPKuk07VAURiN4
         aUjTqhYxmd+NhmrZw3dSgCLODwJY4GtR+KqtU9HGLdn3A7zKuYN3mZQFAojfRhJHtiq9
         8Jig==
X-Forwarded-Encrypted: i=1; AJvYcCWTyjYieKeDx0t8FhokwfXw7d/8GXGmDFyv+8D0Gox+jM1fbMS6A2pNUerBP2g8mTgkoSzmUiP7xw==@kvack.org
X-Gm-Message-State: AOJu0YydFH+PzCepG2jzGNQQlGcCK2PcZobgGZ3Gbx+61V5gnb0GA4hW
	UnjyTlrXmsTeBzTvLArSeHf4s5cQXLvdZDDSJyoFd2d+kYtu+OUwCTiZ
X-Gm-Gg: ASbGnctuIq9bp/eku4PXDIbe87jjRKI3xFpkVT8ZBmlgZ6MngzLHTkpxuOwnQVaISxr
	piiW92db2H27M4BEaie3DCrww7M5vJYyvVc3Q3DfUxYqOIdfn9Jlu/HEt/0FMvg1WaU6SAiPOur
	RGvUBOxzO6OdIGEjevysZ3M7FdJdffOyZP5cJkXGvy76BIm218JzdeeUYFkPcMQKz5EnxXJhMKQ
	JPNfH308XeJWNTpGEGrvph13PVeYcNFS2z2RcMuiNpW+xc2RvVtvBPjawfWKlAVpnfDs35vvpF6
	Yn8kt7SYH/uDN+ESFk4wuOh7GxunBCCLXehe5eSkQlHFYbXAgz5VP7zGdb9rHyXe
X-Google-Smtp-Source: AGHT+IFTd55XpTxH/s8Wj4Dy8CPAx1rIWPrgzoIlER18h3np+V8WcEqUMNnWPJgXqpr93S+bIj9hGg==
X-Received: by 2002:a05:6512:6382:b0:55b:8afb:e638 with SMTP id 2adb3069b0e04-57799ea77b0mr164452e87.28.1758086522911;
        Tue, 16 Sep 2025 22:22:02 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5779b5d6928sm233405e87.131.2025.09.16.22.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 22:22:02 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 17 Sep 2025 07:22:00 +0200
To: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 04/10] mm/vmalloc: Avoid cond_resched() when blocking
 is not permitted
Message-ID: <aMpFeIANuJGRc0vO@pc636>
References: <20250915134041.151462-1-urezki@gmail.com>
 <20250915134041.151462-5-urezki@gmail.com>
 <aMhIv3HfRMyjlSec@tiehlicka>
 <aMmCJOJFMTuCXH3m@milan>
 <aMmnkm_E7hDO_yN0@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMmnkm_E7hDO_yN0@tiehlicka>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E4E944000A
X-Stat-Signature: rmphju7wh6j93fnzqn4kwemaehspui7j
X-HE-Tag: 1758086524-518251
X-HE-Meta: U2FsdGVkX18xLnYML3agVZ8f4rrdHWs7JbAeSzucQ8H2xyzjRNJ45JeiVHPviV8vSOuh1o/d8a1MepimM+wrCzthplbCv1E7aoRnWV30mM4KtKqAK6OwCjFv+kzUxTkxUEsOm6Sk+xFauEJ3yyjZRYFpbYm7KPbRhdhKYMUJ9V4BYW2046ff+2j5F2tvAk5xp0H/WrHgRuh4ygDuQ1iYvnpnV6bftqptBOV+3xOX7k/70RQrWJN49TZojJQ3h2xlEFoj4TlkKa4w2JpYA8/bmVV2TgeLVkWaGPaAi6qMdLns6L3JR2Wzmm2JdukZ2IVBOtoJ1u+/ifm07B8niFZrV29KJxIQQsuWfLTqIeoC99dsJRUHY+kAUfpvygMCkCZY/jPVcMxJVkX/i5g5ClJdQhmQGMpmYvxLflrjzeaSGoOJQ33LCKL9YQAhwlavzX1f5szPCsVq8cc2Gn2ay27tJjf6Ql7k75fhM2lhdxXghZC0o37KQkxt6FmAjjS8Rb7ob+1BUjYwPdCJERCYbiVQPXRnFRSKzWM9QHQ3TdFeYrh170+7U4TlSB3RMQ3ix3DdHeEgssjCKqZMwcpI5GAL4xUDyojrsVuFgzhU8wHuisgCVGmDIFdLiFCNcZM4IQvcvyOrQj2tqcdza2WPW3sAeEh3+k86trfHnyW7N3ZJ6uFf4uhJuuYNHVQ4P2NRZzYMOSEGl+cO3FUcg55oPpPx+rqoOT68FVvOX2yh7OV7xQwcDQoS0tb8tPDO4iaZYdT6nxc+06RD6J1KjFKRX0Wq61XyYH7WN6JeaE9tiWVW3q+fh0DccJSx6n5dVlg+eOmRIxCXe9+Nn5BxFZYJAHBg3qlyq0JTU7Bb9JH2AHzLXFpTe2w1Nm78y398QOH2CPRso12zkc+jwqTHJMZdBfdPrP762EMGYB5WwG+0Ioi6C6JSGilQudSAZkJq8jr4ng7r2PG67iorIasj8i7tVXF
 /omH2FyQ
 Qa3aGmpTx0m8uGQndS5/i6EjqlBM1V9iqFHXlcjPvRPMzAhFw4Hha2LuBHBkx73AuyQhvq6eTRA+lxyHv5XYdVga2v9EnKopKvECs4VLATu0htXr/c+6XEv7IFS1/0JgIpv9pVj9hX8O4ApkI0nhv8lu5lDNs3/PoJ52jcKP4hCpvlyn+m3HEjF7w8Y4jUNQY3zpv+Lu54B037s2tS4qB1Q4kgWG5NYcGwAmXQT77soReYymAI9GfYOq7qZiACvSBGk6Y5qjsMe4euM6pV8toI5kN6B+BbcyA2DC0B6tN8YMnL9k0eLMvb0Rkjf9P247C06A521J/9NVQufoo1Qz1Qz5JXoZwFp46TU6k5tASsaXpm7BQA7CCl7r96znkQZJAptVp2eBbHYKQc484YNrpGxv8kJgKEiSJECZFMfT1sR/RiZIYBxLxplTpntNf2TZ+K0UjJZ1OKDY/h/WIrSBQr/DPdA9KLG0a1DGX3xIgW2XVjaw2jnGZSkJ3UKJ/kjRX81B2gt3W/FJ0613MYdsTljEWHBkvezlqNhp6jDW2UT1AcUTgBayHEqEO+XUCNGheVVd2ysZBWRPn1BE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 08:08:18PM +0200, Michal Hocko wrote:
> On Tue 16-09-25 17:28:36, Uladzislau Rezki wrote:
> > On Mon, Sep 15, 2025 at 07:11:27PM +0200, Michal Hocko wrote:
> > > On Mon 15-09-25 15:40:34, Uladzislau Rezki wrote:
> > > > vm_area_alloc_pages() contains the only voluntary reschedule points
> > > > along vmalloc() allocation path. They are needed to ensure forward
> > > > progress on PREEMPT_NONE kernels under contention for vmap metadata
> > > > (e.g. alloc_vmap_area()).
> > > > 
> > > > However, yielding should only be done if the given GFP flags allow
> > > > blocking. This patch avoids calling cond_resched() when allocation
> > > > context is non-blocking(GFP_ATOMIC, GFP_NOWAIT).
> > > 
> > > We do have cond_resched in the page allocator path, right?
> > > So unless I am missing something we can safely drope these. I thought we
> > > have discused this already.
> > > 
> > Yes, we discussed this. I did some test with dropped cond_resched() for
> > !PREEMPT kernel and i can trigger soft-lockups under really heavy stress
> > load.
> > 
> > I prefer to keep them so far for consistency. I need some time to
> > investigate it more. As i noted in commit message, the vmalloc()
> > path only has those two resched points. Probably i need to move
> > them into another place later.
> > 
> > As for page-allocator, it is in a slow path which i do not hit in
> > my stress-setup.
> 
> OK, so the fast path can trigger the soft lockup? If yes please mention
> that in the changelog so that we know why this is needed. With that
> included feel free to add
> Acked-by: Michal Hocko <mhocko@suse.com>
> 
We, in vmalloc(), also have a slow path. Those two points seem to help.
I will move them later to alloc_vmal_area(), after a slow path serves
a request.

Thank you!

--
Uladzislau Rezki

