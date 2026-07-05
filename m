Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98FD8C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 08:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82DC26B00A2; Sun,  5 Jul 2026 04:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DE986B00A4; Sun,  5 Jul 2026 04:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDBC6B00A5; Sun,  5 Jul 2026 04:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 369846B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 04:34:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7BB49048E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:34:51 +0000 (UTC)
X-FDA: 84954062382.11.6F185EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 316F840004
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:34:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JmO8cMVa;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783240489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hpyyGnCmoaU77sn+Ro68vpJQoBqTCnGGK+pBiKnHXwc=;
	b=3zDHskvHRo2eubuHYqvmGXY2oOfGbsBrMqb0qAQYYThBG5B4mjqqx/AxoKhqi00EoUH934
	n7q7L7lXFCQmo7P2NjQ0FyK+2XcchLs4UdSU/kQJSzmGy9YwplRUxHgBr9Wgdn6hly8e5E
	0h1Gzs6Nma5V65p4eTcv5l4vw/RfLis=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JmO8cMVa;
	spf=pass (imf17.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783240489;
	b=02K2vWDV/tRedK/9yV1jF/OsEOERI0TuR97YLOoTNDHmWPclZQmzlZpFp/Gt0ZmKVwR4Fi
	3ecVhycahK6GCRIE/oqWYjEJ+NfDKTlaGFnF/IDhjvcHNCljvs45nLlucX9JXs2mBeSkCP
	IPHx7p6pf3Db2tv0qn9CC6UXB9Zritw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783240488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hpyyGnCmoaU77sn+Ro68vpJQoBqTCnGGK+pBiKnHXwc=;
	b=JmO8cMVaJk23FEqeaytAa19wM8+iXKiKfDu5VfxtQUIDfjoihhthVrZkl2I3TLz7E/KZUc
	LcgBd6oRb2KBF5IIC2bf/ZSfi9KhfmVrUXpp26tNB+2p7/Ev66Cm+W+5GA/C6zHFuKSoDH
	FK6sSTSkYMJi0WqXipE4KehmderpkxU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-18-pPyasKEaM8yqaRBWIY682w-1; Sun, 05 Jul 2026 04:34:45 -0400
X-MC-Unique: pPyasKEaM8yqaRBWIY682w-1
X-Mimecast-MFC-AGG-ID: pPyasKEaM8yqaRBWIY682w_1783240484
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-493bb6a4336so16591315e9.3
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 01:34:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783240484; x=1783845284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hpyyGnCmoaU77sn+Ro68vpJQoBqTCnGGK+pBiKnHXwc=;
        b=GQQer1KPAiuw590Kot+e5PTemD7q9pzyaxfAl/+TmbT/IYD9hm/SxnaWhOprEcuEgq
         xnWlZlCeR18JWVyRA7xh2/+GN503YjFZcBY4iXf+bsxrc8338Iwn3OuscjDbdQGg+rPU
         L4UYcaYeK9VsUxaVqdajHKkf6gvYFdsiVvN977ZinjDgpZzujszOopWL+zcechCPtONs
         qozBB4Jp8oli3umF+0KVqIaYPslgHlStO68SB350vT60Tfm4/eVJyTvWTmiT4+hUySmb
         +OFGVPPuwSIcpwSqMyMa2849AAPgBrVpMjNTT3Yhxg7NNgVAVFb6i9oY4SCbqDGP4JVW
         A3pg==
X-Forwarded-Encrypted: i=1; AFNElJ/tJvHBRHqAXm34iYOMIisyhKA7RR5TEJshMxGnXMi9jmr4oi42LMU7f04xzoI7l7WFtKwln1xeaQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+H+jENJ16B6izgSneRqC7uoYKSrUv+H+IQ/H6arW1J3wI6ihp
	MKfpdNHSLIyIYl3plYwBPhmfnTYz7PF3DqRbHSmYAFU7gSg6Khvz5njwdebsDF4orx01Q/MY5TO
	2QBVxbFKRKooMfogKEDTU4zEyFEv/6euIMPm1hUh4sdKzZJk4sICq
X-Gm-Gg: AfdE7clrLWYkQ1MFGNbpzUvURPyG5CPLEesxP94XwTakVuin6o8vY4+n68G7S1x1UqG
	rWc8Xdnx/b9BVUd6os3wpRKZ2rIBdkRJ7uV48ENYfVwNheeGyKtovBURFaZ+wausQ+bJ3HvXkgx
	CAdJ+KKoGiNWH+QhYoJEfHF/3J/N6YAEDxRDFDx4BnwfYKWT0lDXFaOKTiceaON1teeJkR0Tuyh
	RrttN2agckGbVV/n1Cz5C/nONiM1o5Jn1fbTuIWxS7MBN4EIwIsSzGYSmuQPs8XmuwI+7VjzARx
	ufSD4nQpxHU5KfHTeAhB9P42n76HC2FhLV3j+dh3PuX0hy/EUlXNCz1mXgIw3AIBL6TG12RZcCx
	om/rVPrL5D7ycHi+FQm6glXB5lPNVg7m5
X-Received: by 2002:a05:600c:1988:b0:490:688b:f9f8 with SMTP id 5b1f17b1804b1-493d11f8067mr71136205e9.27.1783240483676;
        Sun, 05 Jul 2026 01:34:43 -0700 (PDT)
X-Received: by 2002:a05:600c:1988:b0:490:688b:f9f8 with SMTP id 5b1f17b1804b1-493d11f8067mr71135645e9.27.1783240483110;
        Sun, 05 Jul 2026 01:34:43 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493cce1a844sm177749835e9.15.2026.07.05.01.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 01:34:42 -0700 (PDT)
Date: Sun, 5 Jul 2026 04:34:38 -0400
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
Message-ID: <20260705042708-mutt-send-email-mst@kernel.org>
References: <444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com>
 <20260705011635.9974cac7f0defec9961e85c4@linux-foundation.org>
MIME-Version: 1.0
In-Reply-To: <20260705011635.9974cac7f0defec9961e85c4@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LkpiAIHPbTYa0v0ZGi4309WtHPaD6N-6vaDk1L58NqI_1783240484
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 316F840004
X-Stat-Signature: w4iwahczzzi38jib6479fpzqxy8rf9fr
X-HE-Tag: 1783240489-787325
X-HE-Meta: U2FsdGVkX1/R8o/Hp8imcHzesDgxtHeuv4yBRdvNLD6i9ntkTu+T+UAwivspKhbGqfpsRjDvTZb+SR5722BHBi20M32bowU7XlTr5bRjjW+kORvT9x0px5Iu03uSRCDoTQO4JTmY3UZvY5iqGaBOkUGlBWzDEd3MNf/OX7kKbJRY+Qvg569r2y9nK72jZVEMc9auFGlsp25IcUWto3pkhb+z7H1WmRyosX6+B1tqLabZrt6RUNr5ZlPcbnskvSW/KVy5hORsyAT+2q8JrSde3AGpPSc4kcQ1pZ8J1TJGOx2wDNjyjD1xeusj9K5nYypgqsdztx/csNULbrTcXEhI0mv71ACIHiuc6Y8qOlevXMkNDRDHYRUwCZbdXi5fm4AN3oLAaayMY52osI+gPHnG4+oVhn2+fSYGs8KvBWzIHxby+dOXhbxmgOgyECsXMg9XCNsk0XBVHtTV/++rCsT4OOG6IwnBORYRWQsjXg8kJbQOi7FiN8FHtjJKFXuRvnAsOu3sLa25RIU8S/0d6V5gDeRAz/+kvAZOG9AH6VB/ZCQpTC21CGD3CKWt00kvKAZ5tBG+z//v+oripF5urwBNpIv7aRDLFo6fYJxOEeVqfT4cRJc0ircy+nDW/j29szLwhP/jZekWr4ZMpgetGkFuDl+5yDfc/YA7MQoI12hqyDvmY0C02peGrDjSoBfrscaWew/pjndMbDUCp22xPreRzUPpQ1A6h8Yj2ltxdIFI3mTDH0O3cftbLmYqoRW68D9iCJ77mkt/H77nYdY9ZWqiEQV3RsfRynF8hA7OMembphXKehFh3quTA/Yeoh7vQyg/FdNG2xQuOFg3sP03nRuAtj45LNceUbihEZM1Q8D6PHAt7zJHFl9QKapMCO+0sL4mYwGoaUT+tjqHJHqfj2BfxiTh+qUehSH2IRORf9X6oh/K/dVrHrKGLIe9K+19sT9YS5xyMjBaiP/J8xakTqv
 RTc4PyVP
 AomGMMI5uXtmlT73WPrWZo/YsqLyorGItFJR5CjKdDs+DllxuNBkcf4HvJ96L3j7Rhjei6i5oBO9PnM9GKVGVxXL4BEm/8o5sQ/3YeSJsW64WwDVdP1wJqARchDhjfd+mHUF7CGTPmb8aBkg26bvrA1CRQXvVyX7Y5GfQFdpEs5GcUfyfF1f5NrhjyHGRrYEbWg8bxhqGggZUp9wtt/sBUt4gQ5wLuZRNyyL5XhCCxFCwzpA9oh7npU6E9QCMLQ87kCqkFyolxW9s2MEvCt2DZwcA93HfT0oCy/QjaJOSYNL/259y57nm2fHJ5E3msuyWu+mS4G0Qb1DA1Lt0TXm6KPNr8XZLqAXbN07ORP2ub0MtUOei+wkIpY7USBBg4zxUvxYkSuBNMMTawTQFjqCasPtCWcQxyLKXYuJ5hYxyIZY4Gsg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 05, 2026 at 01:16:35AM -0700, Andrew Morton wrote:
> On Sun, 5 Jul 2026 02:25:13 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > At the moment, if a virtio balloon device has a page reporting vq but
> > its size is < PAGE_REPORTING_CAPACITY (32), the balloon driver fails
> > probe.
> > 
> > But, there's no way for host to know this value, so it can easily
> > create a smaller vq and suddenly adding the reporting capability
> > to the device makes all of the driver fail. Not pretty.
> > 
> > Add a capacity field to page_reporting_dev_info so drivers can
> > control the maximum number of pages per report batch.
> > 
> > In virtio-balloon, set the capacity to the reporting virtqueue size,
> > letting page_reporting adapt to whatever the device provides.
> > 
> > Capacity need not be a power of two.  Code previously called out
> > division by PAGE_REPORTING_CAPACITY as cheap since it was a power
> > of 2, but no performance difference was observed with non-power-of-2
> > values.
> > 
> > If capacity is 0 or exceeds PAGE_REPORTING_CAPACITY, it defaults
> > to PAGE_REPORTING_CAPACITY.  The 0 check and the clamping is done in
> > page_reporting_register(), before the reporting work is scheduled,
> > so we never get division by 0.
> 
> Thanks.  What's the priority here?  Should we fix 7.2?  Earlier?
> 
> It seems that Sashiko has found a pre-existing issue, a hard-to-hit
> error path thing:
> 
> 	https://sashiko.dev/#/patchset/444c24cf39f3f3620fc90ef4695bd6b0979f4c4b.1783232420.git.mst@redhat.com
> 

Ugh. Yes but it is a minor symptom actually(

This is the root cause:

        virtio_device_ready(vdev);

        if (towards_target(vb))
                virtballoon_changed(vdev);
        return 0;

DRIVER_OK set almost the last thing. But, e.g.:



        if (virtio_has_feature(vb->vdev, VIRTIO_BALLOON_F_STATS_VQ)) {
                struct scatterlist sg;
                unsigned int num_stats;
                vb->stats_vq = vqs[VIRTIO_BALLOON_VQ_STATS];

                /*
                 * Prime this virtqueue with one buffer so the hypervisor can
                 * use it to signal us later (it can't be broken yet!).
                 */
                num_stats = update_balloon_stats(vb);

                sg_init_one(&sg, vb->stats, sizeof(vb->stats[0]) * num_stats);
                err = virtqueue_add_outbuf(vb->stats_vq, &sg, 1, vb,
                                           GFP_KERNEL);
                if (err) {
                        dev_warn(&vb->vdev->dev, "%s: add stat_vq failed\n",
                                 __func__);
                        return err;
                }
                virtqueue_kick(vb->stats_vq);
        }

this happens before DRIVER_OK and it's quite out of spec.

All of balloon initialization needs to be rethought and fixed.
Maybe.
After coffee.



-- 
MST


