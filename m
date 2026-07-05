Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0805EC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 09:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98926B00A1; Sun,  5 Jul 2026 05:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49526B00A2; Sun,  5 Jul 2026 05:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C134F6B00A4; Sun,  5 Jul 2026 05:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88EFF6B00A1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 05:06:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1750E1A0686
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 09:06:37 +0000 (UTC)
X-FDA: 84954142434.02.768BEBF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9AD6018000E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 09:06:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="M3EVi/ZA";
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783242394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lwl2RZIgRGshSa/qt93sniK4Og2qca+KFPXUQBK5QlE=;
	b=PgKTpCUE5Z0XA7vo5ogbbvZOlHaD20LA2FSrg7GdFpIgAM4/cFJrwoytyFmfg5MTnKB+vT
	cK5PpeSXCc1BeA0aosDc8poyhKjJFPAOzZJG856jHanaIj58PWsEUHYtSz3ZPvF5+TaFex
	YJFdV6kjMCNYxce7sDDyRTvZ6J/6RKI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="M3EVi/ZA";
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783242394;
	b=DVg61VoIxS/JZXVb99LyrTs1RSjvDWTZOTPfcAWgFKcBmYynaLgLBihsnojpzVRO68r9qS
	lMK9cUvUlHYcrROVUJYmMvrM9OQGwOWIBopGbRnLYvvrvHtosHtWiE4y5h2qk4cJE/HTxD
	puPbIS/P7cuea/+/CAccjGZT6Z40kpg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783242394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Lwl2RZIgRGshSa/qt93sniK4Og2qca+KFPXUQBK5QlE=;
	b=M3EVi/ZAVKMzxUk0mZ4lxfTHf4gP1snPcP/wClGfnCKUe2KZk1UuNn9bGj+W33B5tOu4qu
	VrwQSCDLJ8CpnUaM2+37fTlXp8oFQgTp2zeRHKUicSHnVl4Md/AEpBjVBeaVjciDicXeff
	HqM+RPF9HFL9EDo9G0fV1b5p5kcS8zE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-IzJ5rwpkNaeW_4j5A5qJ0g-1; Sun, 05 Jul 2026 05:06:33 -0400
X-MC-Unique: IzJ5rwpkNaeW_4j5A5qJ0g-1
X-Mimecast-MFC-AGG-ID: IzJ5rwpkNaeW_4j5A5qJ0g_1783242392
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-47132f8a98aso1100258f8f.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 02:06:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783242392; x=1783847192;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lwl2RZIgRGshSa/qt93sniK4Og2qca+KFPXUQBK5QlE=;
        b=a/N9mcWVpQCkcY/+ko0VVRO9TpkCGUNanNg8540qj3iq5caX0UwQVZGEzFCPAClE7V
         HdydGzbj/4y5rZ5rBeTMxuX9Y21Dw+iLjfYzGIhSk0rCyDjrl3jFp/uye9BDJGO2NEbA
         LMfTzvaYtj+BVoLm2A+NeiVnnlSimqe3AdGt0MosaqUxlBnK0vfgpZBPF7Jcy1uCMw4V
         wWUOnn+pa55Tyxoj/RUy57gW82LrTY8uChKu6j9/oFv/1UXUyuEDy5r8pssQSNRnL3ct
         36xPJMohvxvoPuY1/sz6kA0JClR4ts07Tv4hrYabMd4caHbKZZ3DGG9+sgB3Bk0H4Uiz
         B6Pg==
X-Forwarded-Encrypted: i=1; AHgh+RrrJbiQxk1tBp11272/QTEXJRviUec5rSgUpGz/YhUUVxGHlUxG9Td0gOYoJHU5aYcngT0C7PmQRw==@kvack.org
X-Gm-Message-State: AOJu0YwMIZ3BYK+Ealzn2aaFLLGKnHxMw9PS5RGVPPZPCDl+3RKCLpr1
	jyAflpbpf7BdtVJzD2G1ctA+EqJjTxN4vc54H95STa2phfySStcZoqmBBWpxupTQ8ii5NSqyGs8
	FWoqcoZvAwkoE0vWwjPBB152n1g4FW2xfeHDyC43TQJWgKhvqDZYk
X-Gm-Gg: AfdE7cna6k9yQHBFusgyxeTdeJU3h74klmvwiyoaXxrIHdhLCveVPk4hKocypBUIv+R
	cychRjwTkiaG4U34TVCW8WgPd3T+s2qogBE3WJdt7I7Czy8XKg+Ua8WWNUWBxw2GZTkwXp4t7TH
	pCyuY6vGUJv8Fy1uAWu+Kz0XxsE33LBZkDAHjc+DoB2xdydQwtqS4kTes/3tMjuXCtuFkkjEwU5
	j3TIg0GpZMJQquA/HKKZxOGD0ymicgLJxZXVw+mabBTNAd7b5IovBwALh338AjvNMNRd6nAnWrC
	vfXv9qTTP0+4DQtUhUJ3cZK0EMJiH/j3ekGM2hsqnFK37tuMqq6WwCs7a6VwVvPkoES068IQcic
	xFeu+1dERIVeBb49hgv6gQ2llHyMedf6/
X-Received: by 2002:adf:f390:0:b0:476:cb01:6393 with SMTP id ffacd0b85a97d-47aaba588demr5679059f8f.11.1783242391653;
        Sun, 05 Jul 2026 02:06:31 -0700 (PDT)
X-Received: by 2002:adf:f390:0:b0:476:cb01:6393 with SMTP id ffacd0b85a97d-47aaba588demr5679022f8f.11.1783242391124;
        Sun, 05 Jul 2026 02:06:31 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0f2186bsm14405764f8f.36.2026.07.05.02.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 02:06:30 -0700 (PDT)
Date: Sun, 5 Jul 2026 05:06:27 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: page_reporting: allow driver to set batch capacity
Message-ID: <20260705050445-mutt-send-email-mst@kernel.org>
References: <444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com>
 <20260705011635.9974cac7f0defec9961e85c4@linux-foundation.org>
 <20260705042313-mutt-send-email-mst@kernel.org>
 <20260705013956.36f649b5cb13409d9088838a@linux-foundation.org>
 <20260705044139-mutt-send-email-mst@kernel.org>
 <20260705015116.bdf3335e9a955f057a6d9c5d@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260705015116.bdf3335e9a955f057a6d9c5d@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KHEZuElgHMJ2h2VWwI1QzN1xqU5ZrMStS-UF612w71M_1783242392
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9AD6018000E
X-Stat-Signature: nqcd8u39uwqrnyhjeifrood7f5chm4re
X-HE-Tag: 1783242394-670964
X-HE-Meta: U2FsdGVkX1+he6/USEt7N1jqttX0wHBL8Wu6mcn/VjRultKSziLT8MYKCzUeFEVO349QnG7L0JdAcLBZWqXzbpiuPj4W+riS0ouP3JbbGfNMzrqpUdRe55Wd8JMeNQwr7bywecXeNofaX0fmgKpYjX9L43fgFoYbIuVKiaVm7ua7NJAhzGC7gM+HZcMuHe0Tdba2HMLNl0SXqQU1ziGh05RALOu5+KiLv0xRKuXMORrfBJ2a1PYaBBfxWC47avAZeK+NARjsYxUYU/Oy1dwH2naKEePCYZuweRK7S0vHaKnzw3AJM40SqbS9D6EevnvtEFUNbfwZuF6+uj5n2PVHSXi0OXVnBKLDJALF9tVbkTMQvgLOb15meIixM7n7a8q7Cs8r55W6Gq6jMdIiNKGrKuoq8okerTgBAqxenhyt2qM3BwNQbxH7jbJd3VqFanCxfEWF2oaDuLWhQhWM0Y5QQBmg3F+MgtGa5CEn9bnhua4mPdBG/HGzyS0nwNsFlB1cOVLjcdsekt5G+oa/lZCrvwZv3S1eEWXn/t5qrjvZZTPzoojxguvdPhJofrMQ4yz6l+V3yTfpUty3XpNVo4Q7nJVfs9lhyU9uEiCbUkdhTp0TDzLGnJvFHLN2R/1l19ypM4eEwoWBOT6ooGj9/wtbltxhhJJEnVVc52u5hfmrxNHs8lPZYbj1EvQTo7WR3dmPyfUN0SMvGy/V8NCADD4nJHYWWCmXTvOR/tyOla+MK96MGZ3rl3OvMb7xeeKYlrLOw5ePBjZ5JvZtxDsdVBlBMYmDJKseH6r8GRVCWuT3Embh63rFUn7ivicpZsvw28N5uILG2ik43ANYv1VpNnIVWAteEqWKrPR4Da6u/aBNY54cMBeQTEPb4h/shnKuxs1jMsp0lryvPx+VJGuvqivPocry+icvMA/PbTfXdMWIC5xqcrc5ozUUu71DW6RD4P26ulGrMBNdECGBmpOKRvR
 XSa3L01p
 uLokMF5bhf7ABw42hfmE9gHE/RB8Gvag/t3o3n3vMYCau0KyiX7oyMkGAy2CQGlWDXvodPm+aTK45guBOLWCK8d6rJKMyHiiGfXxcVdZRNDCq51n7HfXs0XOIT4xG6PClzJBy2nF2eGhSZ2rdA0wJARgJ7mT1VCA034g8jQmKe0lg3+ITLzjvG/6wBOooeAVcdCXeSXdho3IhwnS2GDgt8l02Er/XKvOcb359TYpx0wKfvCJr63X0yiiQIz4exbSrwvW7fmW5b+qlSo8qleHwhvXZ9cNQGkp/6PeNHQzrR3rhT+3emRNlPfDS76ClMCiq6cePjdzuM2+UN7rfNr+Nmso3McxXQh8hUL4uAhFy4aFcW9I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 05, 2026 at 01:51:16AM -0700, Andrew Morton wrote:
> On Sun, 5 Jul 2026 04:42:38 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Sun, Jul 05, 2026 at 01:39:56AM -0700, Andrew Morton wrote:
> > > On Sun, 5 Jul 2026 04:25:53 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > 
> > > > > > If capacity is 0 or exceeds PAGE_REPORTING_CAPACITY, it defaults
> > > > > > to PAGE_REPORTING_CAPACITY.  The 0 check and the clamping is done in
> > > > > > page_reporting_register(), before the reporting work is scheduled,
> > > > > > so we never get division by 0.
> > > > > 
> > > > > Thanks.  What's the priority here?  Should we fix 7.2?  Earlier?
> > > > 
> > > > If possible, I'd like it in 7.2, have a setup like this (small
> > > > queue is useful for perf testing).
> > > > It's very early in the cycle and the code seems straight forward...
> > > > I judge the chances of breaking anything is tiny because
> > > > it just failed probe previously.
> > > 
> > > No probs, I moved this to the the mm-hotfixes-unstable queue.  No cc:stable.
> > 
> > I suspect the Fixes tag will make their AI pick it anyway. But hey.
> 
> -stable maintainers have been asked not to do that - only backport
> patches which have an explicit cc:stable.

Out of curiousity, is this specific to -mm?

-- 
MST


