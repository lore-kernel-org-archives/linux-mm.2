Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5DABCD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED2C6B0005; Mon,  8 Jun 2026 16:16:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277066B0088; Mon,  8 Jun 2026 16:16:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1177B6B008A; Mon,  8 Jun 2026 16:16:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F114F6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:16:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A20048D06C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:16:58 +0000 (UTC)
X-FDA: 84857854116.29.C4711FC
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id C855E1C0018
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:16:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H0jTJ8i4;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780949816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5P0019yd+Yz79EK8psJPf72tTRfll1uVTKsf/rhDJ6c=;
	b=2/OivZL1YuOLL7zYqX3dhU3jTcK4tk6jr/1ahBJAPN0LV2In6oy1IKMIVtxhDPE4DvtCyr
	RbxUM8sOogoh0igreaPnDdlXclAknpeQHD2IbJDNnf6RGXtjQbokbJKIFqJ6eqtM0HvjGa
	2NM5KCUmxZ6FoxnczlJhJxbv9mPDujY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780949816;
	b=NaBhJh4jDESzqaI/d4kGq4uUpOgSlWJuekIn9+N0FROc7UpjvdGlzDc78ujJYqMzh56ogW
	nAf9A6OxNdMUBIgddb3BOHwMJP3Tc5hGMTiR2eVVqw+tuLhZLrJC/CFHeJpXO0wugqJA6M
	MWwp8oSlWNsG6orsOxgj2Cfqde4aoqo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H0jTJ8i4;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5176fc0cc72so49419761cf.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780949816; x=1781554616; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5P0019yd+Yz79EK8psJPf72tTRfll1uVTKsf/rhDJ6c=;
        b=H0jTJ8i4ExhRnJmSIASfoB09l2VUFxY8Mrjr1zP+aHVtjk0znmFoFMx7yLm0cLJrrb
         cyykRLDQTQqPwl1r/ulNG9zUf8ysfBLgnfVfa3+YrkfPDL6UZ0VWWd/81ZKX6MS+l2vp
         H7dcMngPYoLKkx7IXM/YdckKrkEOScuNjKLsREtQmJWHdPmV6FjAscCIfWCiVNu0M/lu
         rAVBXvaFDakHbn86txua9Lhsniptld5lVf3pteFsj2eYLR/XienpnDn4zSi3CzrXNBkg
         o0xrDwkOSMth7RrQ9r1AoNnsOlpg1jUB//QOfEvOCqKMcRZE/OQMMxmIOY8Pw+AzgoGW
         iRjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780949816; x=1781554616;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5P0019yd+Yz79EK8psJPf72tTRfll1uVTKsf/rhDJ6c=;
        b=asnESTvBt7/EsSFgUF01ZMvZ94CqeBPH3kkahkYx7x/34cn/Eh0mpjN891Y9B0qN5C
         MkRFFBWIfLMD6M0xkXoWPmvL1K6DIp3NLxk72wNJCbiRhpyGoPqe45Uve56IXEmEKWzZ
         Z/NjmFvPghNcR0MKIy2ZjAkQkZ11O3BTTxqcRj4YmjSivVuHUnEp85dciqJ/NlwRB7gR
         IgSHt6wckG4B3LHzdb40WZprrCXvGnShEGM1BwumjqgDaD1QUqmW4dAFuGY8nipfRv7V
         RgySwu1coDaE04//AHFA3K0wEy7qd0XdRP09eQuM/J3O9DC4wCFOaWPip0oC/am4V7Sd
         IB6w==
X-Forwarded-Encrypted: i=1; AFNElJ8uoVU/2vatenmjoYA93c6RomUc0xRBVioYLQS11QxnHAfCoayQn4sc5wWpm32niVy/h7XTJk1dtw==@kvack.org
X-Gm-Message-State: AOJu0YzUhPgcnE2FbQ0Lny/UG2FXg7dqRn15Vx9tRAthNCSirNH0m/KW
	abqump+MYZmmyA9jYB1pKq9hZqm+vwSv2yqfvNFnUSVILslbB5HVWp6f7hc3ZrUo6kU=
X-Gm-Gg: Acq92OGTVmtxLIB0dh4Gpu/w0FgIa3LXLHjRNThO8aV/y4BwbkYxLQ/y3BtEqKMM0Cy
	yJ5Af0nhGaHVrGWUqZDFnIr1Sr5o5TkhukkBilLE6DF97bcnoBdohzlswcPqMNWbPYatTi7pl6C
	ZsUJJ64nV5129WgROrI//mCovgi0jyBxBWutQTETcp/wbX6lcDqDY5vQGn4VNyLqNwPwWmiv1yU
	zLGV2pTL+5pMcB0gWsOK5sJoBcn1EaxAUhF4Cd3gMzGP9ZLn/c1LGHR5GU5RvIMw8fz551TYyKy
	w0E/a+/+QOGyFuaW4O8faSVyKrYYZVfvjuwR9DlGt6WkTmcIGYoGZ4DhnAlVQcyJB6ILcPczHov
	J9kntCTxnOyZ+sMNmoi4Ds1YsJjIZG2KDeHjGuC2rMMQdqOIYtLjheBkEJj3htRzBNLKaJTm8uZ
	13sWkSg8J1gLWxVmwHDZrmsXrz7xNzYF7XS4VoBrcd7C2G0J36OWyHSkCFiGmZTfizC+LTOZ7Va
	9nZtSRm2+5071NtTRo+ildStHi6
X-Received: by 2002:a05:622a:a6c4:b0:517:79f0:ae34 with SMTP id d75a77b69052e-51795bbfb19mr190530941cf.20.1780949815842;
        Mon, 08 Jun 2026 13:16:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775c4648asm177764561cf.10.2026.06.08.13.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 13:16:55 -0700 (PDT)
Date: Mon, 8 Jun 2026 16:16:53 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 12/37] mm: use folio_zero_user for user pages in
 post_alloc_hook
Message-ID: <aicjNRrHYOOBt0Hx@gourry-fedora-PF4VCD3F>
References: <cover.1780906288.git.mst@redhat.com>
 <f92f6f06e5804b4ea7f68b8664b7e69953b50f4e.1780906288.git.mst@redhat.com>
 <aiacZ6_7SG3nvVjM@lucifer>
 <aiblhJv_BvMn_8XY@gourry-fedora-PF4VCD3F>
 <20260608154354-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608154354-mutt-send-email-mst@kernel.org>
X-Rspamd-Queue-Id: C855E1C0018
X-Rspam-User: 
X-Stat-Signature: 5mxhb9c3kn4pko39g8p84gnujkmticjr
X-Rspamd-Server: rspam08
X-HE-Tag: 1780949816-455349
X-HE-Meta: U2FsdGVkX18aTwmZQc6uqi0INmmV6PIxHtJYV6EluoOUcSBGtrviCr9xKu7x8Y3P1BXd3QwiVSjVqj2ng5RwnZxIFPVgbd5i89hoXE9Jpq6l25W9b68Fe4o8hhm1Zfm2D1Xp9h7UhZO1WJNyMznrbz1JobzhhCy9nbcf/iQYTMTao4+K/NRzcWLb6AnKLsRHyKZSHzWD6TZvDXgTcK1AMIC9gVOFZROZDLcD6goBRqwueQxQowu0hZl8eKOyZ0GZRC9u0vSYX06xydhEX6qdMS5vE9cAEUvI0XEZeRsE1xHlJxsrb4yfXY8FoOp1W02b7RoO3FUjRsGkZ8bwgyA0+6UjCSdiyGL6IuRP8VurDIb9rPRdhlfUZOqf3W/9/OQ+aLCCD08RhEsYJD1E89f23zq7/6SyX8Yj5f4PIiKYN8AExpW0MW2p6+Zad0jiO4VV2a8Qp0D1OmvpKs5oj31/o6h5R4txb7xntZRmFgICii3seLtJhXVhH7RgcO8IzegrTgO+WblghkUXPpiwIU41SpzpGMiSxqkZLAQOLDCkOgleYePG5OdGp0QdWNDgOiGtUPRZotrb3sqYdjKhj/ooUnyRMJjfN5UIm8UBx1DL8ITPMk1KMvMzQujEKWMramK4qenWyyirvXWvDAkzY/hWQnL7V0BMur0p7JLzwXMPjjmrngfzBx86MqpB2/CaZics2NArt9/tHWzN+NKYuD1aNgB7P6u8oQTqYW9IfMk5htn5e80M2tC+En1+pSUsU49seDpKmVtwA8VjwvQem3/0K34uovBxcv2mQExFZb3Z8a3+ocT4MM2PRUx6h0jGrfDn4VgwIQqnvAKgQ7mUyu5u281Jay+o3iPJkNdlOdlr0eHFq1tFx3yGFdD0pR8D7U8uzjbZarUa/kzltiNzJsAC8Lmi29vU9LeGA3xtx+cQbRggowt/wqaT2eJK1+6XEJtMY+8IOm5ePQBp41xdO0r
 BKScjd9Y
 XFTBHdaX4H4FuCg+48WfUKN2JI6Rver/lfSHoN0BPVq+rohjzpotGVx6X6MpZ25EJk0jkriBWo0r48TfS6DcU/uvt6qisDeV5Y1OfZhr4MDZFrgrLXTur2RRRk80Ry27pi1MMQd+yjmQKuBK7aKDspoQGE7ThO97hgb2Q54LAd3IPr5Xpok+HZ239v+u85F6PmX02Ny8QBiVHlTGu2B9jzo79ZXzyuneGx2ExR8jDZodzWs+57KUjo7n2N2TSX+fu5nPVH7FqeoYsDkOb0eJQSgbPMTtTeXFMS3M7IcgOqt0sPvM7QVu9HuZeL5kvyCfzQdfWgbUN8mpCFbUB19S2ciMgyHNXAMsej+wUCuV+vdp8cJ/dWJm7UNQFo0fQYrd0ifkVhks3qiDfb7ZEXkDCvyxTs3bDEkkDk2PN2IgerWSYro7GbCCOs2CkP8BL6sRFAf8E013XTQ532Ys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 03:45:58PM -0400, Michael S. Tsirkin wrote:
> On Mon, Jun 08, 2026 at 11:53:40AM -0400, Gregory Price wrote:
> > 
> > If `user_addr` is now implying anything other than exactly: "This needs
> > to be zeroed / caches flushed", then this is bad.
> > 
> > ~Gregory
> 
> Well if you do folio_zero_user in a non sleepable context then things
> are not going to work. So combining e.g. GFP_ATOMIC and GFP_ZERO and
> user_addr all together is not a good idea.
>

Can you say whether (GFP_ATOMIC | GFP_ZERO) w/o user_addr has the same
issue?  If not, then this subtle complexity is now a tripping hazard.

Is there some combination of arguments here that should just outright
fail if a user attempts it?

>
> You are saying it's bad? It's pretty fundamental to the idea of moving
> zeroing into the allocator, I feel.
> 

I'm saying having to infer that safety state from the cobbling of those
things together is not a good pattern (at least as-is).

If the introduction of user_addr into the mix is the thing that causes
us to have to infer safety, then there's an argument the page allocator
shouldn't handle that operation (in this case: user_addr cache flush).

Please consider that this is arguably the most fundamental interface in
in all of mm/.  All we're doing is going through the process of figuring
out what changes here are reasonable while trying to meet your goal.

~Gregory

