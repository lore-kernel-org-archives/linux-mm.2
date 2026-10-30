Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF1EE606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 12:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=EF02KBG3
Received: by kanga.kvack.org (Postfix)
	id EF0A36B05B2; Fri, 30 Oct 2026 08:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1466B05B4; Fri, 30 Oct 2026 08:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90CC6B05B5; Fri, 30 Oct 2026 08:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7ADF6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 08:13:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27FD480643
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:13:06 +0000 (UTC)
X-FDA: 85379181972.05.CCE4094
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 349B5C000D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:13:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=EF02KBG3;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.43 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793362384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZKAADSfZoWv8xOE7quCSCjhwlCNy+kog5o59siXEHg=;
	b=2aBLOZ3efvWInEoIKelXZZTzHU2YOC9WH0WKY0KX9RG7NVAxF+aZGusjMCnzkI9ujH2wgE
	/wJsN4EkXQCZe0qext5B65zlG0FLmj+DWZZ3a13x2JW9lGiSIbRc19tOMQZJeLR5YJH4qW
	OQ+ZuJbeNOlZzfx/+umGqEKGD5EwW5A=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=EF02KBG3;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.43 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793362384;
	b=RLT9jDSql37HI4+jcQ8+ZR3doduauW9eHVTFcBzMw9FclSDpeUPh6xeAiWLsi+wxv4ikes
	hSmouI9DEhFEqoHD09t08xtO8FwBNYMBhF6GbXLUo2xllzxXFYRikghy9NPFRr64yRK2V4
	EPdkLbqtu38gFLPE/PPkYyfueEWBuls=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91c7a0c1617so10473746d6.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1793362383; x=1793967183; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bZKAADSfZoWv8xOE7quCSCjhwlCNy+kog5o59siXEHg=;
        b=EF02KBG3QhTu7S7+JOrlqiAdpL27sRkm36MHoS86nNgbIZploH+2sCRw1qHPYZeLNq
         na92175CEz2/DhjGYC5yzR2XzMFhvju4NHgpDzq+BPgjBDMr54oZXjIylytJHpPZSz3U
         I1yVHhBq3N5JOZ7ZBNOZbOz4aW3pw7GxoiYNMBiQiBW8j1kuu5hmb5caqCJxi6tWjU8q
         JgWK3DOo2cjqJzKkgmQE+zhaziWL9T18m6cspAigs0oP5z2aw+Ll6g+m7cHWUlaq+Bwa
         v7kjq4K4UQYQ+yDj32xaB8965JZr1qwv2rTw81Nl7IGWtC+GRSWPAwvAKKtaBhu8DbZb
         A35A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793362383; x=1793967183;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bZKAADSfZoWv8xOE7quCSCjhwlCNy+kog5o59siXEHg=;
        b=TuTgGrIoS/TGLK7rlHjiXu/KpQZD5GuRMq5nF2JPYBqzTTmZ2L8htRJbDx7MuFC6po
         L9okWFwLJS4rIIjW0xhhNGGaCoRpDfikchvL9guD9g2xljnzT/wsj8JPTKg+F8Nm2pt8
         vQe++HzQ44IlY9PNH/nyzMTeJlDVN89T0p7158ZN/3q6G/yqGnnDOMXHCY6S00wIlXxb
         4ZJ2gU/QLQb4DkOt2sXLHabVZJQdENYd4pQlAr5sbBJZ2oadgfvubgJsKqSt8gvEpzXb
         b4XQ/44Hf9bneC3iUgIb+2mWgGw+gKeEb8QNZqwG2FpmjqFQql2auWsR4M1Q/Pj4aMeV
         A3sw==
X-Forwarded-Encrypted: i=1; AKwUvBznXjADwCSDxrdC2BLR9OdbnKcto2hCmF4Fkg2QxRYJjXSLshhv/kFtZ8mAOO/5gdf+oITfpb21NQ==@kvack.org
X-Gm-Message-State: AFq9FYL+8+tgdQ1vRQDoBApOi4aWKUujjvb4xHdXVzDcV27Il2QmDizd
	TfkHJdC6GeMTSuVxdJzNu333dbCVtZi4qMJiUetPJsQJeq1ESiZi/ZVrNQ0Ah5OWlHM=
X-Gm-Gg: AYBFou1RBz//z6giTlf8Cb/G9G9/u9klz6KsyI1u1bQb9ai/giRmUfYgCV4u6KPZnbo
	4p5hIDvbpwAbHuIf8XY9H+e9N6mh0NA0WbmbTsl4UJfdPuyOBqcvY7hWwVoxy3Ymbvi3eAbkOBJ
	h5kcMwbDqF9HjtAs+OqmLBmro8q9bdJ0ceoD3EzNeXl6TSBlQ8zgCtKfWlrUuILVLHuNMFzZha5
	/p3iG4lInOu/sRWwGcDzjQRX6+H8ssPA7E/UCJ0PkIirujItpmlmZwVYJp1MEw4PYGOSuCPuy2Z
	XZWdLVOs8ZnUCp/zyKMQv4kEHrOc00gk/LH+gPeAdSRgNBsIAoubJd2qCR6PrMRAE4UXquByYUT
	SkrMeC86bGSpUwNUCDvAdFeotUSoxDy6hLx9GqiJodl0+7VgJ4obEALO4rXKwmkatLSgEMK4XfE
	/78OFmt8HUH+JvmySgWbR/abyqsoPR/osyQz8O0ol80iM+qAMh65q7nxPKSQzoha58V67dt02fJ
	hoWZjJegXnxkRI7UptbS4JJPmlHo3Rr47jfOcsuBv1iH/CNt5tBa0uNOidabFFmpVMhfP22nshj
	ETGno3pR0OungEFfzDmVi1HUc9FiteHM0xFnn6GdUndmzyF6xXFi97dRGqX2b3IDUDTMOJtMtGq
	unKK4c/48m9XlOuCw6xQF+Zu57jDTjVdP
X-Received: by 2002:a05:6214:1252:b0:917:7d92:6486 with SMTP id 6a1803df08f44-91ca4a0c511mr31768696d6.6.1793362383132;
        Fri, 30 Oct 2026 05:13:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ca7e24001sm13957666d6.3.2026.10.30.05.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 05:13:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xMlTf-00000000Zek-2qdZ;
	Fri, 30 Oct 2026 09:12:59 -0300
Date: Fri, 30 Oct 2026 09:12:59 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Samiullah Khawaja <skhawaja@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>,
	Alexander Aring <alex.aring@gmail.com>,
	Shuah Khan <shuah@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>,
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org,
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <20261030121259.GC3889730@ziepe.ca>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <CALCETrXNEWQNPjtuHnTfVFOafeJ7APXq288Cq16Q5adDNYx9+A@mail.gmail.com>
 <auEksxfAi9lHFXmT@google.com>
 <CALCETrXDY2e8x2kdr-FQvFLs-Y7FwNozXGDvqqM6yvVA7QLV3g@mail.gmail.com>
 <auPKfqh_YjRU9Ui3@google.com>
 <CALCETrUEyfvaEGxMHo=c0ia3CDgSxg-YW0_=Z7T31Ou+pvicuQ@mail.gmail.com>
 <CALCETrVpEP=HxVqdSP_AgA=U7ignwAgjz5Vi9+Z9dZsX5DXeLw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVpEP=HxVqdSP_AgA=U7ignwAgjz5Vi9+Z9dZsX5DXeLw@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 349B5C000D
X-Stat-Signature: 973qssowyzpkrzh3a8guctb8uf6zaek6
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793362384-135947
X-HE-Meta: U2FsdGVkX1/Npks9EZ6ijm2sOwVxW5z1cCslE03c6t8tgGrlj96uhy5RfQbHYLkD2A5R0blip1GZ+EC8c2RnC/BhtQFRKT2CXm0sFQGVPXSC50Em7wVqeVzxMkDCDbP2q/SKiP9M7LQLAkw/z9x34YdY8M5/AX1a1kgcEeb8R/T9OWn40/JpsSr/0Xz0fqwvKJaxjQS191BUBP0Yxbt4vCCoZDw4FAdgbomviMgECAbJYiwQB2a7db0sPUen31kgVqiK4Hdv3hIPsXV6wDJas6oy3Q/lc035RK1r5sAYQ5u/SlD02+srW2/2L05jEfJWXfr1QX7/d+0EKnU3l7ASDO2syZH4vorkvkatrvTNvUFlLxJzBWAaaaRXT6Spmd5Yw1M48Y02Pmk5VE1D58JgHh74KgGwGdfXc/AvCReRq8C9hsxGgFlffpJB2scsqSnFH4enWBGJV+sJmPi6VXkGh1UoAYPSmkv7P5elIU1fJrFWddtTnErWjtYST4hHCX9FdSgMH0/It3Siht5LWUh4V7bW2+SvisRRIT0PRbfMUbrdfs0+JDlX9F2Mnd19tUTF58T+fMVvtsSecbk5+SJI3Oal6u+wCRmt1nsYHmEafx3YMAKUEW/Qm+nnjIWC/qT2QsiY2kSu6FoEpCOpdP0QAntHNVWMZmtT1lrH/Q+XOnAMgeC7OWidk4HBNg/SqJgiVeAdiDI9n0dJkcWwu4K094B+0+DACRObOPXT25e3G+da64QPihiyybe7/BeRcTNrOVYdwmgHCu20daGGHme2ildrf+zb7KLWLf/THWNoz+NBDbWOXS8/KjUDE0OYjwIP7x7SiaAcf3IsvqvGDFdTGSVB3IAgFgAy7VfOOBuqFDXAm5vpvqAYsfXpmHaUeenKtZgPCTmw0CH8RXSPUsp801nyD6l+vHlSGHcDUX1w0ZcGrokF44tbCOzhT94dNZkpZDCVCHRQcW+zpVwLdsX
 sCeAHcpN
 t8VrvucQUxVqtazAl4fuEfr9rDVkyywVLP7UPdbxpTq8lfdfCJ5kSAjP/W5WXUU+G/v5ro3y9rp+Njj9jsfT8/PjoMab3G5Xh+uBghm3vD09dX9Vhj5C/6QdzC9exeSYgAsJSfVbeFAI+unIX/Res77+MSh6zzW06/hghpnyEf9PpRZjhvGJLUPUETyZo9PxDq9FEnyyHAI5DzckgXcKzc0U8abJeQINeY5zIp1QCIdjxgQmwkpFM3GfPT8d4jnnrt3npRn3YVI9TKACeZiAI2i1dowR+Vy6dg/MafKh2+0e2eP+lLI113sF/4mcv+ObKeJ/viuhlSnqWszZluOowxBNOMgAtNSbZ+7X3WiXeCdVVBfnXWbyMfqZR8HMhjKNZgKPtG2AuEP5rw15G2db9eau6QzcXtoKHl7PV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 07:11:25PM -0700, Andy Lutomirski wrote:

> I can't shake the feeling that the problem here isn't so much that KHO
> + iommofd doesn't like this but that the behavior in question is
> nonsensical.

It has been this way for ages, like David says if userspace shoot
itself in the foot it should not be surprised by this illogical
behavior..

You can get the same nonsenscial thing with just mmap too, you don't
even need a memfd.

Jason

