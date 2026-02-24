Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B5B8F3C99B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 15:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9E56B008A; Tue, 24 Feb 2026 10:44:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79AA6B008C; Tue, 24 Feb 2026 10:44:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B999C6B0092; Tue, 24 Feb 2026 10:44:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A73526B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:44:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3858414019E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:44:47 +0000 (UTC)
X-FDA: 84479773014.02.932E311
Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1656180004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:44:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gVC6Vgx6;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771947885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjHfY2lLGnUeJNju8+7/gahIG0wuIDcc4ZAP6X6I1uA=;
	b=BxI6D9N3BoZWvRv3ZSFyyMvoz3waEjgmpXYvICQpPRlCfxVcRfxPHGbnmCTAZUYcOswr7y
	EtS2UdvaHV/sKAqPz1IMRUgutglRl6AgxhVZUbZ+qEq8CB5YfLMfMgw1Ws1qPN5g21NvvW
	hf2pKwWGV8jnthQMrJQH1E1PoQHXpbc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=gVC6Vgx6;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771947885; a=rsa-sha256;
	cv=none;
	b=Q7CLA4FNU39I9LsF0ExYhp7TsmVH7cRWDOj1JO196NcM/ntYH1AZ6AgsjRz8hDgG/Ag4GG
	WliiKoyAOegVM2deRK9+4EnHbkcA0REDIdpSIuWj9dw8up9dkb5eER8GeaO2pPABSxnzQO
	q8nxiVIDPfq8/W+nORRT450Cm9GJIdQ=
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-482f454be5bso61104505e9.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771947883; x=1772552683; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mjHfY2lLGnUeJNju8+7/gahIG0wuIDcc4ZAP6X6I1uA=;
        b=gVC6Vgx6aXzThl5MspfIqFhuEqoHe8QzQNxh9UjyOuLARrM0BWi33qZspIIrIxr1nD
         lxwSpD0566vY006/I4HatgMDPH/aUYnyBlqE+b0yag2ML5n4EPYP3Rag9I7qNi528JAG
         f+OvWChTXVUNc65s7jjjfw9TOwgVFgi3PEsrKxylbrnnXA/FZdX8ka1jDZgNUo6d+j0T
         jfUr6x9UNx7lj/te3i9ph1QjYtXdr3X/xjsZLE+I1GJ8kywQzWv7zwpn0+spjXfU1tE+
         Bq5GFId/7bvEmbPrLP+WOJb91j6dc2qmvZjIkcBnga7kh5vbteChZ4KqTNwlnbegk9Zn
         1ufQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771947883; x=1772552683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mjHfY2lLGnUeJNju8+7/gahIG0wuIDcc4ZAP6X6I1uA=;
        b=dS9irHfTbHB0LxrAKCt144/8Oajj9ZmRIjZSaz8n4JQoaBBnw7l8In6fCFA/LyQwlD
         Js8H14RFA++cn0v9UzRPyShLcxhRissqSCn4lbLjQS1lE44myW1W3UIFw2qSV9GBLA9P
         mXBwC9CuDXcJ5fwe56S2n1QSwHU4z2ETKf8Ualadr03OEk9lu0Ap/wMi+IMCanF4tFJ4
         2/MR1D8MVZXsmHWKKsIZ/h67lICpgSuvroJl90vOpXBUkrfJ1VSftSH5eXQYlu0PLioE
         PRYQLRoL3vzWcNAoWIJMaYlmZ4B0l04/gbJAQ7gh8TD/9bvkSGEjTHdFPy5+J7SCVkX0
         0Pfg==
X-Forwarded-Encrypted: i=1; AJvYcCVeHxcR2dTlO/LpgaF4yBQWa1A35LHURwKJVojqijuZFfZNe6kQObORYxlG0PDTWJQK4coNvLpRTw==@kvack.org
X-Gm-Message-State: AOJu0Yypk6cIX76WlQUEnIYNQosnhr2YvBP7F+TN48pJARQ2Y0T6byCh
	nZnxDPxNeyfFamFfJjMHtQiGLgSwpF512W42VbeZsG5plmlAAXRciDuGEbNiEPqQaDA=
X-Gm-Gg: AZuq6aLpV0qButcg1oA50fTVQl3I8t8inB+GLvXI0MBhDybHXjxgBjJmUxyJIFWdmkP
	9PVbTlQURwtRiDvNvhx1/rowA5o3aImetJeqqmqTKuCofkljG3VINOv4dE4h4dg//ETRcT+Z+Yf
	SBnp+7C27tLmHtrFE8OutdyvNPA80NIuKQdD1p6NB0P31KexOG98zJgK3D1xCzzdQ0+g4Kmi9Bo
	Bb2acAou6AIzYd9gb2J/3nI06MSSXh1LJHiJb8SXoXIc0Snd2J/1mV4yxr81OeoeqoW8q6u4Bfp
	sNaiJtH/Uc4HmokVOnNiMjs9D4lYlKVxnaaecxGM87LW1Hm+kKPGP33IcFhltWdF4KxNNQMFB1f
	6PYUTqH0/dGhGN411M8tN5TJ1Df3ZR7WG4NspIzcXzrLflPzFrQJIk9hxVtZcweIBwU8fWVOFAs
	qi5pACH8mlVoamIk7BkUsdyEvgRFJFRuY=
X-Received: by 2002:a05:600c:4812:b0:47e:e0b3:2437 with SMTP id 5b1f17b1804b1-483bd726b00mr4761635e9.5.1771947883174;
        Tue, 24 Feb 2026 07:44:43 -0800 (PST)
Received: from localhost (109-81-84-7.rct.o2.cz. [109.81.84.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483b87db57fsm38737105e9.3.2026.02.24.07.44.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 07:44:42 -0800 (PST)
Date: Tue, 24 Feb 2026 16:44:41 +0100
From: Michal Hocko <mhocko@suse.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ3HaVuIA4Ezu1uY@tiehlicka>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ3F2cghZpqBi1Mk@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3F2cghZpqBi1Mk@pc636>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1656180004
X-Rspamd-Server: rspam02
X-Stat-Signature: p1rhixro1xzk96ux5eu93hn9d9ycsg8f
X-HE-Tag: 1771947884-954150
X-HE-Meta: U2FsdGVkX1/AYBB7i244IStDnl1G1zLT9L5FV/Na1Fp2UhGJNXcHRXda/ixgvNEMmwb4F11e3Vi8PVmtOHmx+5lkzk9WaS2ooWxZe4u7hQss80TiOUHDFGQCWwnQTPtqGyjpYD9HoCsP2euAkSRAZFwT4Bu3Gngr0MUcNIFlw+0avhlN1L42RE/UNukWK+JQG1eCMERDinENstSZt4EeCjmCcaj6QGYEfSCjFZxNx7Ryd6hOFjlpluz4Vr5ktKf0GL0NgFX38Jb9xOdFoBO7+Lzdb+FwEDMT4xE/tncoZ2Nt+x5ik/ZFoh8jTwJfQCHN9lhDgixiAKBA2tZlxllhMxQdfHjdsL0Bu3sD3zViif5GD66E9Ab0NbT1ArQW4v7/uyOuKh11HJi8lOYY0eerGp5Bs78v4SdRAjd5XjsfBzOXGH/hj7NHAOKtwx6AJnpJ7IGNOvN5SSUoSm8BAUY3vVbiasrGnsB1U2C81WdljRSIq3ZYggL9QK9KeJscWhFf42lnK0b4SC8kdM0gMGFZbGU7BEV6xaWVLGcM73FJitxu5w4rG5lR765sMnFCOSRzGoatZBAXT7muZbq2mBNRF44sg8lDvTmSjG2OGoYI0hr1X/ZbGvc3uitUmlDSzhHRHMI2DmR2XwIHGvSqRYdsvKq6GkydasuaZypItSBw2G+Y2aI6gJXiuYDVBKhWobLHnGv8bHb6iWdAK+8Z4D/sf63aYQhQmyIw293rZJtpe8F6XZZdkitUjOWXDbkorimqLpjrXTSY36L59F/zzZYi8Gor2Sx0vlxWDnFMxnxRCdZsLjU5/LdSleYSHqPwbBKRCsQZWOon9Tr24GPxSSWK+5h05f4cVGCp+RwUHkfgascn5E+QkVOg/ZXIsD+5vHPVQy3Lmpa9THmB2C0iQouIkdOQ0DKeOO+3fR79Hrju70+ZXaYdT184n7jE3AKryfWuYp8zGmbsowe26zNLVri
 nszN3ERY
 pqvOktQ+oqag8DqWQj0nVJdQxCFNAj+wd0p85KvI22CdFJ/RvO+XT5JLK2Yk6kM15WZMi8UU0YLEgy6/4RW/5p+EViyQvcIUpmuLAI5a9NIVPodVbd8KJeqwpbByFE5z5IBlXfGNS1jbpeyLjIfi+xIEtLWH47eyTGZSVLfaF0BqfWy5/VcQ1TySeksXDlu8ks84O1osiEHpbuh6jS7snDb/HSNz2dFcW7hW/fuXk1v4tTEivs5dy4fxNq9MO9eS0oBm5ydEJnrgExip/wDK6khwNHQsHnJjPAWXdoBksZTxSkq/LkOhf9I2ROzgXiWX27bBFnMBpDdh9s0LfU9FSfQOe2vGyw4YLjeOn27OC5AGEG9GzOjXzmHYX4uXCaeBxbUUsPYQunA/KMGnYV/fqtqawXE9JkKz41upXozOwHYjxqNI1Ke1Cer5NNuiobHjMW3URpVdvoMSGcZCprJlO0KgbaUo+PtijiN1L4u1Hh0fsCqiU+ia8AXupcXbGlEGzFOqAZVECbpr9kp+iSqPQKApbFJvaYKPwsgTepw3YK5PtPvIkhmr4kH504Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 24-02-26 16:38:01, Uladzislau Rezki wrote:
> On Tue, Feb 24, 2026 at 01:22:36PM +0100, Michal Hocko wrote:
> > On Tue 24-02-26 12:39:33, Uladzislau Rezki wrote:
> > > On Mon, Feb 23, 2026 at 11:08:02PM +0100, Michal Hocko wrote:
> > > > On Mon 23-02-26 20:25:38, Mikulas Patocka wrote:
> > > > > 
> > > > > 
> > > > > On Mon, 23 Feb 2026, Vishal Moola (Oracle) wrote:
> > > > > 
> > > > > > On Thu, Feb 12, 2026 at 05:33:30PM +0100, Mikulas Patocka wrote:
> > > > > > > The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
> > > > > > > flags") breaks the device mapper VDO target. The VDO target calls vmalloc
> > > > > > > with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
> > > > > > > flags.
> > > > > > > 
> > > > > > > There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
> > > > > > > let's add this flag to GFP_VMALLOC_SUPPORTED.
> > > > > > 
> > > > > > My only skepticism about this comes from the line in the
> > > > > > vmalloc_node_range() doc: 
> > > > > > "and %__GFP_RETRY_MAYFAIL are not supported."
> > > > > > 
> > > > > > I myself don't know why that may be. Could you elaborate on if/why the
> > > > > > doc is wrong please?
> > > > > 
> > > > > This statement was added by Michal Hocko in the commit 
> > > > > b7d90e7a5ea8d64e668d5685925900d33d3884d5. Michal, could you explain why do 
> > > > > you think that __GFP_RETRY_MAYFAIL is not supported?
> > > > 
> > > > The problem with __GFP_RETRY_MAYFAIL is that it cannot be fully
> > > > supported. While pages that back the allocation can be easily made aware
> > > > of this failure mode there are page table allocations which are
> > > > hardocded GFP_KERNEL and there is no sensible way to extend the API to
> > > > change that (as we have learned several time over years).
> > > > 
> > > > > The VDO module needs to allocate large amounts of memory and it doesn't 
> > > > > want to trigger the OOM killer (which would kill some innocent task and 
> > > > > wouldn't solve the out of memory condition at all), so I think that 
> > > > > __GFP_RETRY_MAYFAIL is appropriate.
> > > > 
> > > > Understood. But as said the very page table allocation could be the
> > > > trigger for the unwanted OOM. The same applies to __GFP_NORETRY
> > > > unfortunately as well. vmalloc has just recently gained support of
> > > > GFP_NOWAIT allocation mode, though. This will make the allocation
> > > > failure much more likely though so I am not entirely sure this is a
> > > > proper solution for your problem.
> > > >
> > > Yes, the page-table manipulation entries are hard-coded and it looks
> > > like it is the last path which is not wired properly with gfp-flags.
> > > 
> > > Since we grow PTEs and never release it might not be a big issue for
> > > the __GFP_RETRY_MAYFAIL usage. But it is still not valid in noted path.
> > 
> > One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
> > __GFP_NORETRY is to use NOWAIT allocation semantic for page table
> > allocations as those could be achieved by scoped allocation context.
> > This could cause pre-mature failure after the whole bunch of memory has
> > already been allocated for the backing pages but considering that page
> > table allocations should be more and more rare over system runtime it
> > might be just a reasonable workaround. WDYT?
> >
> As far as i understand, Mikulas uses __GFP_RETRY_MAYFAIL with vmalloc
> for some time already. I have not seen any reports about that a PTE/xxx
> alloc path triggers OOM killer thus i tend to say that it is not easy
> to trigger.

Yes, triggering OOM killer is usually not all that easy. But rare OOMs
are likely even worse because they are harder to test for. So I can see
reasosning to avoid it as much as possible and rather fail early.

> I do not have a strong opinion about workaround you noted. Maybe Mikulas
> can switch to NOWAIT flag instead.

using NOWAIT for the full vmalloc allocation would be just too easy to
fail under moderate memory pressure.

The real question is whether we want to provide some sort of backoff
early but not way too easily allocation semantic for vmalloc. If yes we
need to get creative in the vmalloc internals rather than expect callers
to be working around that on their side. History has proven that this
just leads to tech. dept and more work later on.
-- 
Michal Hocko
SUSE Labs

