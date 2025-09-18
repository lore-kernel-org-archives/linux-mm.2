Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2B3FCAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 19:32:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04230280039; Thu, 18 Sep 2025 15:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36028E00F6; Thu, 18 Sep 2025 15:32:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCDC280039; Thu, 18 Sep 2025 15:32:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE8EB8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:32:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 816A7117B5B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:32:44 +0000 (UTC)
X-FDA: 83903368248.19.AB62C10
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4BED3180006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 19:32:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gYPJ/zd/";
	spf=pass (imf06.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758223962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FrxP5xNcG3tL5SGiDQEqP5O3t4o9iAHN60NtSVZIh5U=;
	b=ROG+OyZHFmYNXIrXST8f+1vqf/T0/ybDcIYdun0S/uxmkzk9tzMIPNxhSGRVD7yFBGe05J
	CoRQMFAlarfw2Zepq3Z7eT0xoacP3LpJFU6ytceLmBQ+pyu66HH/znMbRGZnyCP+3BWoQX
	ov2GqKNZ0zhpWnzKTNTPzAMYjjrpo3c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gYPJ/zd/";
	spf=pass (imf06.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758223962; a=rsa-sha256;
	cv=none;
	b=p1NhNcbATsWuRiCuuDh0Pe7WsN0an7jT3vxoDkwXnQlJI8G02eNCzRZDCR9RcSfsFK3AHO
	H7tdxsiEAAA8q1rQu5JdoExbrlKLp8sffcnjYK6HKUxXDHAhpQ97QIzkqC2cHvEQjxdyC9
	Rtjas/dOGO+UFZzJTtYC4MtvqBRRQXM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758223961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FrxP5xNcG3tL5SGiDQEqP5O3t4o9iAHN60NtSVZIh5U=;
	b=gYPJ/zd/sYqm9xaK7xbKI8wyzSku6VcEeGB5E6cVtibv57ow15GgwD+VuulV1PqXF+e8+C
	UTlmfgY0ipbrpD9iMCOdQliGLNeugl06Ya746I9+eNjv8RwfaWcOhr5ha8NKf1R4yFWo5a
	FsoHNE9Z0+pvbrX1CrLnaaxKYmMeqIs=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-49-OE25dMLeNsqpo384KAj4AA-1; Thu, 18 Sep 2025 15:32:40 -0400
X-MC-Unique: OE25dMLeNsqpo384KAj4AA-1
X-Mimecast-MFC-AGG-ID: OE25dMLeNsqpo384KAj4AA_1758223960
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b7a2999d38so23997111cf.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:32:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758223960; x=1758828760;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FrxP5xNcG3tL5SGiDQEqP5O3t4o9iAHN60NtSVZIh5U=;
        b=uqN2wG5YNweV/DNOvePm+C6LO1xmq7TDeXKddH5b5HUiR39ztJoSKmyb7eFoxoqdQ/
         D+TF+svummNh94UgebVkrNZTrX9io0NSWXdSCk9TKE7Oxqdy3ATrwUIF0iWybbUUp3Nf
         Ha7LstVG7nx/mhC99H/tAdMOVFA4YEVV/aPbS6YR4CUT6rTtVh5FKg3TtWos0eMgZoFr
         UUBcMWqcjtujgijNC3smIkm4Zv+jKFC8OT01yve3ipD+vKJoFIHNchKMY2/Si4A5ZwvO
         y+js1a7CYHl2nUNvDu3qovrnW51QjgzCJYwegc1LzeW0NiLtOerOqYzSLVxjygKpyFBj
         /RQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcbzYMGGh2xQZIL0khk53DhxfcIXY9EwgBHJCP+xkXr5Tp8ZZ+EGxaJpPElW48wli6qD+dxZk2mg==@kvack.org
X-Gm-Message-State: AOJu0Yx7i1U4PANx0+AlEY4PNH5WO1OvOpMxgMHATrBp8pEsMQDwuuv5
	vgDMowooOY3WLtisZPt8nH5YocRqHTIC6mwhMDN0vuZwg808KaAd4m5o5/h1G6XFdgtkaOsOcxz
	tUJ05Et7k08Qr8XevY7RWOgesxb7vytw5NN8lObxfU+ntmewulLYI
X-Gm-Gg: ASbGncvECGkcO1JM7mgvHvgNYcW0bfRWCK7NESW7Zr1CFmy+7FyrX2UZt3ngL31KQO+
	PTIa6sKZlz2/HQvjT89v+q055hxMNtYnFNXfqLD9ybEVAAOUxxsZzzm5VFA1QYJBxVDQa7WTnH8
	QZAcojQg4s7i2ZwLBEzcqArky9YUbnydzm+Bxrr0NlqqWB0TthNy5qsPcV6B5TVc31Nrk9HvYHu
	90ENsyT64T57izwFY1Ad71DllSkSVNeNGg2UQbFl9yaCQ6I0LXEha222Dpzc+6h9bT0DQisaNZg
	QEzUrofV+EL6ZxWtvfsX2duEyRbELKuN9cFo1IFkuwasR7RrwQ3EvU07vNF0MjRgAqNsjvJxBA3
	moC30gA50I0Y4O/zNFROhNw==
X-Received: by 2002:a05:622a:5793:b0:4b7:b44c:9fd4 with SMTP id d75a77b69052e-4c073d943efmr7226111cf.80.1758223959756;
        Thu, 18 Sep 2025 12:32:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvFx9YHg5jdY/lipm2LL0MJse3fnFRollEDEK2u/yHDAZ3diTQ/mHqSJpJks7YE+ILPdXElw==
X-Received: by 2002:a05:622a:5793:b0:4b7:b44c:9fd4 with SMTP id d75a77b69052e-4c073d943efmr7225721cf.80.1758223959270;
        Thu, 18 Sep 2025 12:32:39 -0700 (PDT)
Received: from x1.local (bras-base-aurron9134w-grc-11-174-89-135-121.dsl.bell.ca. [174.89.135.121])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4bda1fc418dsm17972111cf.12.2025.09.18.12.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 12:32:38 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:32:36 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aMxeVMkwLdkChhYd@x1.local>
References: <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
 <aMxJ3inEs_RRyqen@kernel.org>
 <2rkvuudmsf5tv66wya4f7m5niwnodu42owzmro5jzyc4fcep5n@lre7hir4qjli>
MIME-Version: 1.0
In-Reply-To: <2rkvuudmsf5tv66wya4f7m5niwnodu42owzmro5jzyc4fcep5n@lre7hir4qjli>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ytu0ZGgN_Q1EvyC0ifmIkKxt44cJWvNHqQOlYKcDx_o_1758223960
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4BED3180006
X-Stat-Signature: 6n6hqhf51m8bhi8sbafhzp6wpmcpnbdb
X-HE-Tag: 1758223962-51763
X-HE-Meta: U2FsdGVkX1/zvCXHB1so5LrTLptZcUZqvontFv1nUh5Hp4oaiwTkM0OvVzB0J7PMMlmHP8Cbf261AfqIdxe6Ht+LAU26s0Y4I3lz8o6NAKWcyf0gnlGo1gKP0wONjI0ctLxx5k2GCFInwvLl0SoMqvWRVDKRS5IjjoILX4gtxsljfxHOfeu2JgLvcOeacVsE0iNXUABcNVkMKOPDPRGeOTSID8tWgGqVPrTy67wtCn1QFjNJ8Jsm2XyOBkV3v3r0H2YP8HtNe+pzRtRNLD7nKDzGdF9x029nnr80xi76A3RrK8lVR0uoB85KiF4C07isjVx+ewqaBDGLGTBaysIVsjlmSlmqzrj09mgGrLodOsRSDsp2PzwDwAwltfMPW3+jmmPgaGA46GGwSZySTEaINUYthp8neBH/NZ58CK8c/lJIqfHWfrNUFS7O0LFsPcRBgBXk6ZS4+bLFbAz0CLymrQSSErWI4DVGg/tEaMkoV4w03lBibmQp+pND6XyM1Wzbz/eSSyuvPGEGwcFeOun9pIa+bKIULuxLR79vwr0yyPKSzO/M3xrjYFwmi0vzRr+hPz/ZSv80yU+UQZKEKMoxHWSbPqPOWnCSn0/IXqa+R4rRiOBwWcXBnGunOc1IEw2imdx6xWpsq0zSKXEBa+dxU8g9YGZPhnGwWWE2WO+mmBOJ3mAGzmPar5QaS+wB7MfYMSL4eOUoWQpQmQKnB3fppnckSoXIKdZJGPAHhyxSP0YwNSlZyLXCUX7z18JmpJ/Kx1q5vFtl7M8wYeHEHATYLXJd40jqKlAtIklmX1Kz/Q4+uCL3crI3FEshAZxnX8axaJ/vI7cWhMLarwBxe7rkUz2cKTN9IE84YHfLIvqenAW6yXRwXLtCO2fTDk1eXorzsKSGjxQOuhiA8CG/mPyzD296GSt2jYA8MxMXGFORQgOi49aD0FOSxvgB4u1zJsOKyxo0+/wKtF48fpVNUVA
 53Sum8Js
 5J0eISqvCsdtVdNBzR6/5ZgShLewY/ZfxmxZpIzTwy/ujlrf2ISCNCiNkb06rW/B76PBcaQ/YNoZ91P3IPCuecA9ZnTJdtzuYFVk5DzSU+O5FI95nLitGlFmhE9k/10BxMtY/25PWnDekfGo65zS45ZILtPPpTpyiwp+y9+PomjDymsCISvOr5cowKLHQl4yrBXN/sqFXUPfjQ9xpYC9PvIy+uS4vemu7YPmXIHBSmumiOhU5NpxcQ9p7sdU7aukz0FhEDGXuY76pX3oyoy4+61rcnvebT+eA6Ary6pCjtFab+QLcdRQof57y393k/wHO/sxHHEP5ADHvt5PmzL5l0qZYqHjCJA7p2+xbF8cMvbhrWFUcAXi2qHJhgp/miiSXIRqTatPoFr4se7uaVu/U3pdYekMaeqqOm25nwXpsOscP9717bpIDNz2FncGi65m4YMIv3qQj4g4i2O3IRF9xLEI8bwPo7XyW9WragU8qOdjL9Ip6HiMDnzVHkFbDndpUkY5FWzfebK8+q40tqvxM7xDtwh+BUvQyrDWV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 02:32:31PM -0400, Liam R. Howlett wrote:
> I believe the location of the code that handles the folio.  One would
> decouple the folio processing from the mm while the other would decouple
> which processing of the folio is done within the mm.
> 
> Does that make sense?

Not to me.

do_fault() allows allocation and some other things (e.g. trappable),
uffd_get_folio() doesn't. They're fundamentally exactly the same otherwise.

-- 
Peter Xu


