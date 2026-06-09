Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78F90CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 22:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 964476B00C9; Tue,  9 Jun 2026 18:00:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EE566B00CA; Tue,  9 Jun 2026 18:00:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78E8A6B00CC; Tue,  9 Jun 2026 18:00:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64CFF6B00C9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:00:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E97CC28AF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 22:00:58 +0000 (UTC)
X-FDA: 84861744996.29.8389890
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id A35A3100019
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 22:00:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UayPz2NW;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781042455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9i2Af7K5yNSnpzmJpY557qOnqur0hKTAqhtHYtV96bo=;
	b=oyKxRCGJrhK8AMKcw/j0gTij10XwxU/Cf20xCGNYJ8WzNUi08Tg/Hsm7OyXb9YYf/WLAO1
	QigxaMzJXWEPIO7sbS5CWwWh7IllD69bGL8YSOE28hWjvu3+X+/V9UofWSJZOqgVTsMuQ0
	53ykpM4HtzXCKOXNvxsKahO3O+FUBhA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781042455;
	b=5CwL/GyCdHB45d3Y7P2LtSKfWTKR2oS92xlH02jb+goirffnXDum58J78mGvyUsAFz5ftD
	kDCjCgzUZelK7tQac1Pq3sdm66QBs1xwu/Chd+yzwHPZQLr6XNVuxcQq8korh2IarM8TYS
	VI183cacfSBm3DP+ZnDQJh0mLGGJrgA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UayPz2NW;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781042454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9i2Af7K5yNSnpzmJpY557qOnqur0hKTAqhtHYtV96bo=;
	b=UayPz2NW6FZYp4db8AnroV1mcXxhU8Gwxi2oBCeiZuv1914x7EMGH4pTT4UEpolEFSWnHW
	RFW2GSRTqkeEb67d1B+1xe1Upl8klmWcHtvLifuBlmlV+KA/uH8y4tfPqaS3M6uA4ly+T+
	Ls6sQ9KbFm6SOIm+9gndRcNeT/tHy4M=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-wwFimESINeW2Yaoj9jnVFA-1; Tue, 09 Jun 2026 18:00:53 -0400
X-MC-Unique: wwFimESINeW2Yaoj9jnVFA-1
X-Mimecast-MFC-AGG-ID: wwFimESINeW2Yaoj9jnVFA_1781042452
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45ef5e38a18so2812173f8f.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 15:00:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781042452; x=1781647252;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9i2Af7K5yNSnpzmJpY557qOnqur0hKTAqhtHYtV96bo=;
        b=lMzrkgxhe67dPKropWKxocQJGJwDAKm2cmC6HN5ygUsBzHq1W22frymtDe2dTXfLl/
         FOLHiCZQZCWbnJQzj8CsWx6silIxzAlQalJOsxDFKC755rXm1tqwOWBrHJjQZ1GBsQT6
         qkLEJdbfxAsWjXf8iolSD3+27JSIFcSNMh/EHDKq3LJFxfHj2o0rWB/17303ewFXNmzN
         ey8ewqYh2/jGDL0ngiGE0OuvV+s/TbiDxMLvUPGwq5pb75Ip3JXSA43iS9iaIjFparE7
         PLsOkn/TCpgqiAP18ppE18BNyR7XF6aCMWd5UKA3vF3ODCrGWhzYl8WuX7wwS2h1frYf
         pQog==
X-Forwarded-Encrypted: i=1; AFNElJ/9cmO88jODLsO5SXdq5lC1gITfDoYuSr+J//+ppU+13W0CoHNWjwhAkzu8VOatS2mr/MxOSv4oHw==@kvack.org
X-Gm-Message-State: AOJu0YxP7KfR/ZgdmAYvWqeozWqFlq16vHnDemR5RHZTbIKANfGtGClu
	bfTX0zXjQKn9LlyxUIEbirGOyclRxq3+bIa1pSQMfAGjaJCG5ULUXQqh+z0Y0ZF8grn4jUGCLXT
	rGIBiTSywX41nxHQurGt/T92j72/84UV6kOc3sA+N6jaKUjrYRdKY
X-Gm-Gg: Acq92OGyz58+WBTwZUzyvrmpdKVnkf7jpTaqzxxX3f55jXCU0KgSkHqEesF9rK9XKS5
	fJnYIVaa+N4f63kxNOGbll3LywgoWhwDWfNrONCH2p3gBtYZ185qOS7wBMru1aaum1DkkRoxM/E
	pSltHXZ5Sni+q2QD7SNLuIINcUMdtF0QWsgkxvNveyYZuPW8tQk7CyAtOnXiqtN5PLY65DRgI04
	zLb9mnu+NmCh75T9Yi4WZ+yZKRjch8RENL0/IDqJvWNOSCgQuB8Id8nSZgf8vlbw7+Y5bCt2ICQ
	LcDC8V8WxdJy/kGbEzkyEUnZhIQbsYzDj7yiwbwJ47ZNyaXVBnaY+qKTFBdaCJuELoleUgy5ka6
	EjHLCqr9m3qGvIWBEUk5+WuhxCmxJgY3vEZczzKesAMFjnaw6QSRdfg==
X-Received: by 2002:a05:600c:45d1:b0:490:bf13:a1b with SMTP id 5b1f17b1804b1-490c260567bmr335621585e9.26.1781042451972;
        Tue, 09 Jun 2026 15:00:51 -0700 (PDT)
X-Received: by 2002:a05:600c:45d1:b0:490:bf13:a1b with SMTP id 5b1f17b1804b1-490c260567bmr335621065e9.26.1781042451443;
        Tue, 09 Jun 2026 15:00:51 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490dca8fcfbsm4818565e9.1.2026.06.09.15.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 15:00:49 -0700 (PDT)
Date: Tue, 9 Jun 2026 18:00:43 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Alexander Duyck <alexander.h.duyck@linux.intel.com>
Subject: Re: [PATCH splitout] mm: page_reporting: allow driver to set batch
 capacity
Message-ID: <20260609180022-mutt-send-email-mst@kernel.org>
References: <b25ea6c63503f24c8b5b64910a44dc03b5aa610d.1781020302.git.mst@redhat.com>
 <aihRBTaTUmgYmZfX@gourry-fedora-PF4VCD3F>
 <20260609160506-mutt-send-email-mst@kernel.org>
 <aiiJPwhn6gF3ILur@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <aiiJPwhn6gF3ILur@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Hn5u4HVthTbdVp-lGV-5ln2Dn-sHNZEW3WfPyf8vPro_1781042452
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: A35A3100019
X-Rspam-User: 
X-Stat-Signature: 4h4m89cso6tnfuho9heybuqmdfbhczit
X-Rspamd-Server: rspam08
X-HE-Tag: 1781042455-570055
X-HE-Meta: U2FsdGVkX185xI1QjDF14ude833RKzC2LRfON27WFVSEc4gH3hxaR7JbLN9bM8aG21QASOjIYre3/ZtVD7leu35KwbwZamLaRicDj5Ay4ifrr0zefxQXhu9APaj2/MQqLaU3Wb/YiYppDfW4QsOyd8zV9xuPBzJKYNL5G3KJSIB5ix7XVfNcxIi4qlp2EC8r7q+kUeYJ3IoN0kQUDtT/4/2o2/b+Sv5FkSDjRm+s3C/Y8JKuxdQAfGlD6OCBZGHqEoWcLyuXH4Qscd2b7hPmkQ/RU5jI0qKzBWxxri8JZEp3vmjNcz++L6PweqdlH3waBWBQ1FHN9y+5va+EtgLHCQeB90Sev2KMHlcL0UgB44QlvtJsFzn7yPdiR2XZ1dR5uXjhvV9K2zN7B9KcQBrL1PHGZQW7ReBQ9C8dGgtKM422OHp5Lq36Mmzs1wM3KL/imXoffSimPaAAbOqXHtcTwF2NVndvMSZF+wAnazpfc8wJ4fxIItLwozH3rzVsO/JbJkTWdZDxjTW3HBYikfrPn+YSQBPWbNBWQsxJHMpOv0Nz8WrqjT9jzD9usoXXtMeNg004mdbt1Pr49laK3zsBRt2fHhc6Fcn9HvpOzrC+Os568C2cykwpxg99NxpJ2Uk32Hw6aWDOsyTWxOvGCxq4rX+XCiIQc3zQe4qEbWlNEnBrJvbf+cvFF3dqjvDrInQ36deOWXCoYJbumFOGfTx2vJE9DDt1L04mhg3hd476xLl6TUxELjnd0Bx1R5jvbF2ZXobFw4X7rAWcfWysY0YYIyAofjmQN1yzkRM8Kagq/Pjy7WB8EpwbLKAn0eD1U2VsCcBg7jlMzWcbTG5nm5c43fedKH1JgtDgzksZrAufxacdfTik0kPn50x1kYlfjT02NZRiBiFGuLbYkROB4LfEXjgyGee8RYQSGvUcDs5N48UewKFbYrDTr0MDE1NyC7hK02AC6gI7MW96zVBRCQi
 K3nultTX
 1vhs0yUb2dm/Y/7z0ZCVXmUZ1LSrWPTe6guUY1jWh7/El+eBAj0baubd4/joEDExCqKADDshySjy6CpD0Jhe9D9hF9uiOEiqf2QF9m+V58eT29kehbbvN8FT3mDouGibmkoWRIdK1Z1tSR98JB1cSwiV3dzUkggohXjr6TjAdJ1FCfQApUjWlUSm4gKherWI4MtqgPhT4ItMWps9U5KeSunZ8atVsgW44fV3cGilRDWCwyw25gLrIDMcGQ+KNgOnkUxMBK7N/Gxh0SlOPC01rs2Y5otKzDSJmOSrow+d+dhqt0g8kb2RkqdtOr3iUfD4DG8NMdlrZcVEAJM1j7PO/7aryhGBtEaAA5dENBfMKG4CUaosBFjWzaCHLhhWDvEjDDhjjkumArNTL4RiYSO3JNc8VppMhjj/43s6s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 05:44:31PM -0400, Gregory Price wrote:
> On Tue, Jun 09, 2026 at 04:08:08PM -0400, Michael S. Tsirkin wrote:
> > On Tue, Jun 09, 2026 at 01:44:37PM -0400, Gregory Price wrote:
> > > On Tue, Jun 09, 2026 at 11:53:20AM -0400, Michael S. Tsirkin wrote:
> > > > --- a/mm/page_reporting.c
> > > > +++ b/mm/page_reporting.c
> > > > @@ -174,10 +174,10 @@ page_reporting_cycle(struct page_reporting_dev_info *prdev, struct zone *zone,
> > > >  	 * list processed. This should result in us reporting all pages on
> > > >  	 * an idle system in about 30 seconds.
> > > >  	 *
> > > > -	 * The division here should be cheap since PAGE_REPORTING_CAPACITY
> > > > -	 * should always be a power of 2.
> > > > +	 * The division here uses integer division; capacity need
> > > > +	 * not be a power of 2.
> > > >  	 */
> > > > -	budget = DIV_ROUND_UP(area->nr_free, PAGE_REPORTING_CAPACITY * 16);
> > > > +	budget = DIV_ROUND_UP(area->nr_free, prdev->capacity * 16);
> > > > 
> > > 
> > > Initial look - is there a div-by-0 here?  I noticed the old check
> > > prevents this from being (0 * 16), but i don't see (on first pass)
> > > the same check anywhere.
> > > 
> > > Unless this line below always forces the above to be a
> > > PAGE_REPORTING_CAPCAITY if it's set to 0.
> > 
> > It does, does it not?
> > 
> > > > +	if (!prdev->capacity || prdev->capacity > PAGE_REPORTING_CAPACITY)
> > > > +		prdev->capacity = PAGE_REPORTING_CAPACITY;
> > > > +
> > > 
> > > It's worth making this corner condition a little more obvious.
> > > 
> > > The code intends for 
> > > 
> > > if (capacity == 0)
> > >   capacity = PAGE_REPORTING_CAPACITY
> > > 
> > > but that's not reflected in the changelog as a default value.
> > > 
> > > When happens if a driver sets (capacity=0) either on purpose (???)
> > 
> > what would the purpose be? if you don't want reporting do not register.
> > 
> > > or
> > > because there's a bug (???)
> > 
> > exactly ??? since where are we practicing defensive programming in kernel
> > APIs?
> >
> > > and then page_reporting.c forces it up to
> > > 32?
> > > 
> > > There's something to improve here.
> > > 
> > > ~Gregory
> > 
> > 
> > So I'll update the commit log to mention PAGE_REPORTING_CAPACITY.
> > And maybe a comment near capacity field?
> > Should be enough?
> 
> I suppose the question is whether capacity=0 should cause a WARN (i.e.
> only a bug explains that value), or if capacity=0 means something
> special (i.e. use the default) and therefore that should be documented.
> I don't know which of these is the case, but if it's the latter than
> that deserves a comment yes.
> 
> ~Gregory

It's the default. Will document.


