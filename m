Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A065AD39010
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 16:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16AB36B0089; Thu, 15 Jan 2026 11:51:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149716B008C; Thu, 15 Jan 2026 11:51:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04ADF6B0092; Thu, 15 Jan 2026 11:51:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7AD26B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:51:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AC43160406
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:51:00 +0000 (UTC)
X-FDA: 84334787880.25.8504987
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 489114000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:50:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jAP089gj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768495858; a=rsa-sha256;
	cv=none;
	b=OSkdD1QceCTuBrlk4Ck1WaLMxUHE3weksYropeoI30+DqhChkEK5IXdN7atw8TGIuUJ0Vw
	J2j5Qr2D6fhq7tvpUjJc/gPsYEMq9wOW2NX5z9+0fzSEHgJZualkeh/+6bOML6stNMIibW
	qt19fldjdOtK0Kc3JoVWVi2QzelL46A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jAP089gj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768495858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SljNJ9ya7guEeZDCesmPS6qTlCZIDBdh9EBAuJaiH00=;
	b=oZbZCx1AWJBM7lYihviwfAbpBMX71gFuoucIdpjlRrcgcbNoL18HzVuH+5XCCQF2+FiQso
	dpI1jvRmtoP0OkV6UnNCUG/ic3MPoVppYFIU2aZTSfSwbc1fjcbmcuBdtIVd6OurDVLaDr
	kqgcOXHxPOs1J74JqNmFH0Rb6IjC8dQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768495857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SljNJ9ya7guEeZDCesmPS6qTlCZIDBdh9EBAuJaiH00=;
	b=jAP089gjR4c3y1KcIKcwlWcrrFlP6AAT4dfEbrhC4z0gOUbFuAdeJ3eGK8GkYun3D0cOKo
	popN74Dh4JrSswUxtg3icUB+59836aT0q0jAAvKf2hwCEFPplWz78pE0v9r7J3E7yRg4ki
	lMyq1CzU4o+TPcMYGGYogLX3ahIIgFo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-CQ6xqS26Ot-R0ucrYnSk3A-1; Thu, 15 Jan 2026 11:50:54 -0500
X-MC-Unique: CQ6xqS26Ot-R0ucrYnSk3A-1
X-Mimecast-MFC-AGG-ID: CQ6xqS26Ot-R0ucrYnSk3A_1768495853
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4801da6f5c9so2101895e9.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 08:50:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768495853; x=1769100653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SljNJ9ya7guEeZDCesmPS6qTlCZIDBdh9EBAuJaiH00=;
        b=A++zNL1J4PUk7ho7UO4aOWVSptssCZjZ8NIWLQ7rbo+mDDarmwwHKVMZi+FEJ4Rq6h
         lPqK/gwnzaLpRFxYPZmsoYKEAUP+BZ6fxyiiIaP0+Q32IaY5+BTWT8VlOE1ppNQVOiC4
         kN+SF7YVwXh0nvQsdtP4Hz+dUSdRssn63NBclOliBeHAqzID4JjIyy71+M3rQyBlkT0z
         7sd8wTWHr+zJ9TX6a1Hl6Rv7AHb6/wxqg+K+96CDA8QM+BrTGShWaHDajscU8eWOC820
         WwK+d/yuI0uMWmC+PH6ydKVgr9m/Kj59lgZbsk6Oy665hhUbf+Hw+hUYPIP3dJhTvBih
         xEcA==
X-Forwarded-Encrypted: i=1; AJvYcCX1ANH5jvUt287WGUjBqq9AADJimQ/452kOmEsgtA2GPSXJL13jTjBFTsisHPCU/LXS2QSybLYXrg==@kvack.org
X-Gm-Message-State: AOJu0YzSkz2AzaOYnm3ISmXgWdXffYDy7mBGvahU5wJBRzALjvT7PLej
	1bPkslF4QFCLL9rDvw/T15Zjf0VejZCyS4wt53bJ9irzACkrnsY8EyXgtvuba7b5u2jlrHEAaa6
	MRgOXfjhPCuyuTLQgQ8Y9ALEcMx2BqgI8TneKZh2HHtcrffE9kTrw
X-Gm-Gg: AY/fxX7YolffZ2wISQoAhcMOH8Zs62J5yoXZrsWe4HBsCVeHCTrgQDBS/WZGes8pIMz
	ZGUNUAPw9yYlTuf5hvQnnppucWUSlGY8hFFbOwgjfhqQ7INXTyuf9gEWJpVeBMfkStrXeaPWS1y
	qhQgnACqZXEU7iqrfqP40MsIswhujtbCv7KsGFieHTXPMADS6os5zR1NxuCKoxlbFUwVD40wr/E
	+S+cjJdCLmc+yi+rPJvLnCO3gixv4i+FV5M9KXa7VmF+G4Z4A4R3sorU5l3VMDtQYaIopy8xwKm
	4bvYPHDcMRjcuW1ezYM2CY8FjCIQ5bcCBrh88WEGGJ1ECLh3byIqJUPrut9AS1OG6p+YyR2mQI0
	HI2iV15Y8xRGC5/jMj5hpOtLekoOZkQ==
X-Received: by 2002:a05:600c:45d5:b0:47d:264e:b35a with SMTP id 5b1f17b1804b1-4801e30aecbmr4637365e9.13.1768495853197;
        Thu, 15 Jan 2026 08:50:53 -0800 (PST)
X-Received: by 2002:a05:600c:45d5:b0:47d:264e:b35a with SMTP id 5b1f17b1804b1-4801e30aecbmr4636905e9.13.1768495852632;
        Thu, 15 Jan 2026 08:50:52 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4289b7aasm57337815e9.2.2026.01.15.08.50.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 08:50:51 -0800 (PST)
Date: Thu, 15 Jan 2026 11:50:47 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 22/23] mm: rename CONFIG_MEMORY_BALLOON ->
 CONFIG_BALLOON
Message-ID: <20260115114849-mutt-send-email-mst@kernel.org>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-23-david@kernel.org>
 <219f7be4-8355-4376-bf97-3410c6e23867@lucifer.local>
 <37fdb994-59d1-4196-b377-f3f749148b19@kernel.org>
MIME-Version: 1.0
In-Reply-To: <37fdb994-59d1-4196-b377-f3f749148b19@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GU6WTvrVt3IWJo5BtPJ_Do8T1DPC_8Pl94-IaOBtF-I_1768495853
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 489114000D
X-Stat-Signature: ywhsut6z37zrbffcsjagtsgngpo79xiz
X-Rspam-User: 
X-HE-Tag: 1768495858-587604
X-HE-Meta: U2FsdGVkX1/YHU8NkQSxwlZ3Uo7oZdw0nAuqI949InN2lY0IfbRELesQrn3AId+Nc1QCk5ziXtbQljTpULXw+0gJCuSHMzOItFAePXcz7wF8NsC/+JlaFK+4wr6thbxPmz/5WmTF4smCs5YA0Y2URsWswyr6uEUqanOi9nOoMMa6cIBTNGJJIu3DUfIVVvN48YJbmhGllzVpJEKcnFi4imt2jWVvq7kgdxi6OmD+VvMCbBPatPl3Rc4fVzzYoQweTFOXQl+nf8BoJTMQXXexq2Zrh/AozKlw12BqkITrZHqaYoJtziGMdIhROzVGwk+3CEhzvFZashCE0B1DlOyC5XHkL1datiu/TmwO0WtHWnCTp8EpOlKnwBz8ZTe//nJ8CSUAjaJG5K7noE5kjT1NxUwdVJrnHo2bOaR1QAkm4wC8MgQPRJv5vcijYTlmZxD20iNWLZjVkB4hj55ELsyiqeByljy65KEI3uGrelcfPVuOP6CBD46mY2VpllDJgaTvS7GmjT5vvk1ec8Kn3ydAHZhIlUiZcbRzNOoK8OdmxxO2juD9Eu9Pcx+0b91p7FFDl8AcZyZJ7C/v8KOKJDxCjxKYsmc3rvoMTBc+U28UXoepOInL/U2RgdKlfy3U1FFcR/A0LTDpH3HW8nyoHQenw0OKJBf9AqCjBKEquTrUmWoy1VUmn8lzTv9GkA2uhUpxCa69y1sRY6ow5OcUtfk1lf1Hvx2oHjMuYwqgxd/D5I/d7jRJd8HnzOE8wvfChGUTVb1hRAJlvFZk+zPpeP9TH9F9r5O18PWSlF53pAEzBI2T0D+ywzF80mceBKeeM6/sX7BLXLSm1Qy7WRtuxh6TqPXD0Je4NZXjBsjk6/Iuqn6SDHaN6wL9gbzzlxjxwRZoGphlAA0zoFxdrmn72EXEGwL68oNdWRgjqHp8Db7l3W79yMJX4M4R+VO90/r9mdTNg0r2X7Ym+r+AKyzcA7B
 6/2rR2fy
 NsHJr2fXjVkuVwjZ7LFbHHJi6sfiMN4O+k1ouliI03yctUWNc1npEhETmbleuCctph431Yj6YrLK+gdd47deHRs+Kf6CEiwhwHJ74VLFSQDbKgUYLm3dWVByXW+rl/Yzd4DB9bMuydLsh4Bay5MiSLd5kq6qzDlTyODCYe9F/8/IVxn9QrmGxI8nj+qe+35eboicXDibUq+vv3urOwQ+ZlP9+RabiebnyXNwd19JH2OCr1ZM5/1KyxHjOH2rDBno8WDbboqntPQgdlw20CTwjJNbW9xB69B/hMDEGzr3W4u5pOdJ+mRWgr94kJj/qfRMO57kW14XMw0N29ZoeLd8pSJbaJtJ98mbXy4JpKFS6ong+fPeyN/K6Vx8QoSgb/vsITtBgH316kLdGPK0l572uEo3zeHH2TdPdkfKN8g8pYssJcDXNP+LHqpiOeuHrGH5K5cE9JgTSZ87lmJVs2mvwSsnK/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 05:33:56PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/15/26 14:55, Lorenzo Stoakes wrote:
> > On Thu, Jan 15, 2026 at 10:20:12AM +0100, David Hildenbrand (Red Hat) wrote:
> > > Let's make it consistent with the naming of the files but also with the
> > > naming of CONFIG_BALLOON_MIGRATION.
> > > 
> > > While at it, add a "/* CONFIG_BALLOON */".
> > 
> > Probably not relevant but cheap for me to share :) so grepped for
> > 'memory_balloon' and saw:
> > 
> > include/uapi/linux/virtio_ids.h
> > 44:#define VIRTIO_ID_MEMORY_BALLOON	13 /* virtio memory balloon */
> > 
> > This maybe relevant (I guess this isn't actually used anywhere?) though
> > interesting there is also VIRTIO_ID_BALLOON... hmm :)
> 
> Yeah, we want to leave the virtio stuff alone.
> 
> Now you'll learn something you probably wish you wouldn't know:
> 
> As you spotted, there is
> 
> 	#define VIRTIO_ID_BALLOON               5 /* virtio balloon */
> 
> And
> 
> 	#define VIRTIO_ID_MEMORY_BALLOON        13 /* virtio memory balloon */
> 
> 
> The virtio-spec [1] defines ID 5 to be the "Traditional Memory Balloon Device".
> 
> And in there, we document that
> 
> "This is the traditional balloon device. The device number 13 is reserved for
> a new memory balloon interface, with different semantics, which is expected
> in a future version of the standard. "
> 
> That's in the spec already like, forever. Likely, at some point someone wanted to implement a
> new version (for whatever reason) and defined ID 13. But that never happened.

yea Rusty wanted to do that. balloon has lots of weird bugs like it does
not really works with large guests. We really need to get around to
fixing this, and maybe it's cleaner to do that with a new ID
than trying and failing to use the old one, was the thinking.

> So now we have these beautiful two device IDs.
> 
> I'll note that the spec also defines a "DEVICE ID of Virtio Cpu balloon device as 47". But
> no changes really happened in the spec with that for the last two years (only the
> id is reserved).
> 
> 
> [1] https://docs.oasis-open.org/virtio/virtio/v1.4/virtio-v1.4.html#x1-4260001
> 
> -- 
> Cheers
> 
> David


