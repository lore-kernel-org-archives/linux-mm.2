Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B03F0CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 20:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4798E0007; Tue,  7 Oct 2025 16:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D698E0002; Tue,  7 Oct 2025 16:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2BE18E0007; Tue,  7 Oct 2025 16:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C6748E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 16:40:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00E99584B2
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:40:30 +0000 (UTC)
X-FDA: 83972486262.01.06CF7F2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id C32ED2000D
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 20:40:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MBIgjBME;
	spf=pass (imf03.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759869628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/WZ6z3oBQe+qrHik3HZBUI/wg3QioRoFpqi0YyJXTI=;
	b=IcMn+GqSF3BgUJumw4kwztxoWX/cRnhgDRpjaP3qYQ1E2drcKjQkYH/nMJfioeNcxP9nyc
	+G2zCAfGHYfZpqbvwLK7+qoS3gdtm97KPwaVGndxk/iKK40xHBeTWOD255W7ydBj+yQafr
	z3GSkxkxnkzbp54ZrJQfVD5+P/gDqL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759869628; a=rsa-sha256;
	cv=none;
	b=eGAomrfNW5OU94ODgslbC1AwVW/lBh3HumCK9lGSizLW2uBtI2WgijeK/xt6ADg1iY08iA
	sSOT0x2Sym3CgNELPMlz+Mh22PmXkBqyge8tc+uhXirLonDNFJnv3Vvch5uk9BKx/Q2aUT
	Jip6L4k6pT8YfOz5UDVTNNmQr+vY1Ww=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MBIgjBME;
	spf=pass (imf03.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759869628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H/WZ6z3oBQe+qrHik3HZBUI/wg3QioRoFpqi0YyJXTI=;
	b=MBIgjBMErPVoeU1w+2voGILFNkojc8xHGMnpxcPfVOFWOzmqInK1k2IFghO69vk+vTM2yN
	VFj7XRXNdf405HD3p2MTmjEFhJzQvGkSAPVSo3nCNYVrVrPJYE/XS0M3cZ5xLMRa4uynJv
	FUg9M/c8F+Ve0s9vrcTsl5w7oE9RF3Y=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-207-CTs3MnlbMLyHNef58CMB0Q-1; Tue, 07 Oct 2025 16:40:27 -0400
X-MC-Unique: CTs3MnlbMLyHNef58CMB0Q-1
X-Mimecast-MFC-AGG-ID: CTs3MnlbMLyHNef58CMB0Q_1759869626
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-78f3a8ee4d8so126050416d6.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 13:40:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759869626; x=1760474426;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/WZ6z3oBQe+qrHik3HZBUI/wg3QioRoFpqi0YyJXTI=;
        b=QzQfToAplBoMXgEHTZU+SThaObS5r14rSriz9jKNtGJ5EvZEF+axLkOaPw3OFzdCR9
         ehMJMxcjpirhyl2unQnBGAm2HD1OVI7qk0c9GYc2m7WrQhjY4sX4lRO/h8ztwah5c/WQ
         6FIpznYKXLV3+CUpYFP55Q/Z4Jdy0EILq0UGXa9FNk+PM9RJ7qMGpE3d2ApQ2GOTW6P2
         m57WMfdOCR1Fly4ERXbRJpeY7jidjbWOoq2o5/nqh5URCzhhFimQ58+B8Pptq8RccWZN
         N/++W/wXiPwUcKFaVSjl8O2YfoRCxgW5SFCG9v/U7Rqow3JQ0lRJ2I7Rp0oXyNo296j1
         g85A==
X-Forwarded-Encrypted: i=1; AJvYcCWKFz8nMBVRn22AaIR6S6p0/UyV9TAq/1Y454cOq7IdcTbCVC23b+gsHmkKxKVoNbKRyEwV9/RfTg==@kvack.org
X-Gm-Message-State: AOJu0Ywr7hm6BoBDbH3fzu/4NiDTwQIivjyYnvKq302iGglqE4uHbtdD
	6An7uuTyHnLG0Bpi6eaOroek91Qoz4CwbWZoIaIOlyiD7Y5A3z/R14RDGUm2l5YR0KQerkwgAGc
	alRhLKdDnJ3gGwCewkdNrKcUKtNiMhGozo6xkr/nEPeji2K3NGoEK
X-Gm-Gg: ASbGncsnC1dQDemNCv5qTNJMhphB5MU1xASjvx+1PKI/kUv7btGn3f9hdXFnEUsnxkF
	s3crCbr1KMkDRq+R78gNrmiWoGGNtzXAivxoS7k8dqFUtnYrFu0is8+ChZ6kkK5e/8/Ro1toXth
	+neEBGRTPkrZpeYXQt3PONFcJNggYp5Go755EhsBwb6jnB1qYsgYCr40TdKwLH/MmLIs4a9OgBj
	sjNn0x+ZtZ7eOr3bnZzm/OdxwmOuXgSgyU6d2ctl93PbEw9xN7drYyb+XUgtGxi2f/L+kil+83z
	vTXtzpV1li+f+9Hg+nXLAKfJrx/c2TiuUiGaKw==
X-Received: by 2002:a05:620a:28d1:b0:828:6f7e:879 with SMTP id af79cd13be357-883521db3b2mr192514785a.52.1759869626174;
        Tue, 07 Oct 2025 13:40:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9xBA940n6kRoyXPAy5XEeKHkXneQCWPoqjDHrtncfqMafSdhwjOsgyCfguuM3RUeHnC5t/A==
X-Received: by 2002:a05:620a:28d1:b0:828:6f7e:879 with SMTP id af79cd13be357-883521db3b2mr192507985a.52.1759869625472;
        Tue, 07 Oct 2025 13:40:25 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-877711296b6sm1615975285a.14.2025.10.07.13.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 13:40:24 -0700 (PDT)
Date: Tue, 7 Oct 2025 16:40:22 -0400
From: Peter Xu <peterx@redhat.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aOV6ttA17Pt2S8xO@x1.local>
References: <cq3zcvnajs55zr7cplf5oxxjoh54fb7tvo23hehd5dmh4atvum@6274mneik6hu>
 <aOQuZy_Hpu1yyu29@x1.local>
 <akld3v2mtnjdqvs5dgwr4gnffdqf5dojwhmfylq3mkfzakjj7j@5oqqxsymkcbp>
 <aOUa8C8bhWvo5TbV@x1.local>
 <frnos5jtmlqvzpcrredcoummuzvllweku5dgp5ii5in6epwnw5@anu4dqsz6shy>
 <9089d994-262f-4941-8bed-f3c6ee05a769@redhat.com>
 <aOVEDii4HPB6outm@x1.local>
 <6csw4pmymno4kdtlbzd74posr3dekamq4zkje2mfkmbg5q7xbx@y3o323tbm7h3>
 <aOVtAMm8PqEbGANh@x1.local>
 <33wnllmydtdlv4vf3rzz7ei3vg7t7x2gqqha27ib3i47lfd6mz@n3nyevb4yf26>
MIME-Version: 1.0
In-Reply-To: <33wnllmydtdlv4vf3rzz7ei3vg7t7x2gqqha27ib3i47lfd6mz@n3nyevb4yf26>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2WWiLq17oinZRme0sbD_btYJOmCtbLKPGkM9nO3toMQ_1759869626
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Stat-Signature: pomruk4zucuteqkpsbte3s9cq5ef3okn
X-Rspam-User: 
X-Rspamd-Queue-Id: C32ED2000D
X-HE-Tag: 1759869628-523606
X-HE-Meta: U2FsdGVkX1+JVoKyCBM6aZVEeQsMX778lMeW8rcDe7KpKrWMOGzWO2dl3C311yrNxgmS8zJ7HalCOVNWShzU/V20G7dwFgj7mtvjwWKeuXoAc53iCEqVKXU+q4K1Bb8ndk+VcfJGSalACi4OUAF/pHwWJxFHjyqfOyptsl2U9uzDRnKfuyG55yNZYT3dSCvSOoPCp6V8CrcnGRvOfwjpXp3O50WeN93RR1UTJVKwGB1UQvM6uBGQOIsxE5m41yR3JhjvHkMg0liT4inNJfEFw69JU2Yd0HCgpdTgqolPBf5Q7WdMNsuvy5ktlBzCYMmd7aCknIeE5r2OSL1rSOmW774CiABun2V7VFoTgD91tjRQmDYlGHEQ9DCv0qUDbb2MOsyhDVyjacWoY+ebXeneeI2dUMN/h+kuTScQ7Be4SL8nSuj6MEJapeF5cqgIl9rwYXATE1Wk0IWsG+nYKuphF/xThna4TLwXMRs9mxfB+cMyzpDxwAntRaBr64DE/wyya554yqLAukfkWCqBMEmVQVEX4PKYyGf6tIsOzz/prtljOfddQSeJTkSQlPMByyBgb3QvJjTl33TryG7yIV1f8nByvjWZI+FbGkcTZbqPo6kF8XdCFE7ZWlcb8KxvYRi44YcCTris1XTh8nhwzNcnchfq34fwEjvJrnKTk00Oyk5fyKQDoByirU1icA9klMKFOlX941jZUw7tPMGW200sX09VfMhEKL2oiKg30+S51rGqYMN3XIqOMpgr5sbNDb7W8PBXzJLYi4YtPpm5Y6Ek1otwmsKpuU0rsae2J8IcNmiVlepFDbUMveP1dG63HW1K2Vcp3QW4woN7p8ARS9dv2pB7Oaf9o7YtK4sIGzB2LK9jK7aBrEvn7VSvefJp5UXsch4zEro+bvguENnp4CKnLu1n6nsxelnr+pUPXrwwFEGoz4TbreyS9a6orxvD+f5k1yHqaSKyLJz36v31lGd
 1/KNJc3j
 4YQA6noIcXhFmn5j1jaXPkjNXAvRdO1xAhM9e0/hd2zplNsuRlDq+9VFq1uiIqzXZV00MD5is6JbA7xkK2KmPJ6QMnPIA/bqRsbSMkuExoOHaG+i2ZLXEu6iljiavW+nYUectnYL09InuPUV4m2SwoKzyrBKMv1KBceTfBb/y+LrtJE3DgB/BAdyd+5inaFFt3XsMZGcepoq1dW+9sp/7qTVNo4tGdRnt0VcabkkQPwtfdC94f+q0EYaIhiJf7V4kaFWYwrv7sZzHvYrJFU1thtczCZ264ZTnVDZdE7Z/R/rVV0mbpGF8+8dg9HUte9yRRCKSu7lzHqkDP8lOO6GO61HKV6KvAsrZoYeosSV8lY/54WHR9cLbIMNwb+Z3vkpJTeE9x/NI99tODsS77LEH6twQX2ftiiks3ns/E1PfZUmE5j6ls8JPsE4P67igr7a7K3GcZUJRSbk4DaOlU5g7ZR1nbonCYCmvMV6zAsWhHvUtomC1HDfKsoH5eqv08fKWb+AOMEK6cPXhAl+uYSMRyPbKm9EEIsgrLcYtJF8Ix2vDVvBVPU2HbvbolKcd2+0TOFnROr/QZpC5y1FcN5GQh9PQHSuhk+jUbSm/xgUxMGKbB7au5hQSrnmKWUpgN5BcWUAS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 04:25:48PM -0400, Liam R. Howlett wrote:
> > Would it look better to you if I drop uffd_modes_supported, deducing it
> > from uffd_ioctls_supported?
> > 
> > I believe that's what David mentioned very initially here:
> > 
> > https://lore.kernel.org/r/f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com
> > 
> > I'd rather go with the two fields, but if we're trying to introduce another
> > feature sets almost only for vm_uffd_ops, I'd prefer keeping it simple, and
> > deduce the modes from ioctls.
> > 
> > Is that ok for you?  So it'll have (1) get_folio(), (2) supported_ioctls.
> > That's all.
> 
> This is still middleware - a translation of flags passed in to figure
> out what function to call.  I don't think this is the best path forward
> as it means we have to complicate the layer for every user we add while
> we are already providing the most flexible return of a folio.
> 
> This will end up making things worse, IMO.
> 
> Think, for example, we add hugetlbfs_v2 - every place we have
> "if (is_hugetlbfs())" will now need an "else if(is_hugetlbfsv2())" to
> accommodate something that probably has the same uffd_ops as hugetlbfs
> v1.
> 
> Why would we do this instead of actually making your uffd_ops a complete
> API, or at least a subset of the API that supports guest-memfd?

It will be the complete API with (1) and (2) on minor fault.

When one proposes hugetlbfsv2, it should make sure it will work with the
API that only has (1)+(2).  Some uffd paths may need touch up (e.g. on
detecting VMA sizes), but it'll never be "if (is_hugetlbfsv2())".

That's IMHO one of the major purposes of having hugetlbfsv2 after all,
which is to start using the common MM apis, including the one we're going
to introduce here.

Thanks,

-- 
Peter Xu


