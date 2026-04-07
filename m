Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65410FEEF49
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DC216B0088; Tue,  7 Apr 2026 10:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C7C6B0089; Tue,  7 Apr 2026 10:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B016B008A; Tue,  7 Apr 2026 10:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2926B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:32:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE4208C3E8
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:32:02 +0000 (UTC)
X-FDA: 84631999284.29.AF59B26
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4E5AE8000D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:31:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hPIsFLyr;
	spf=pass (imf02.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hPIsFLyr;
	spf=pass (imf02.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775572320; a=rsa-sha256;
	cv=none;
	b=KE9Pisv2LGLgn2Xn+HNLeoKUGtzL4E7GCIX6KKCza0ALfvKodHQwDE1wGxTz40SNXVJ6tf
	YtKcUxK0ZaJTV9V5YFbeTM/U5LAnEPPTgMbldIfx9iRUirD6xdlMKRu83ynZ6NPTAs8+L4
	lOAypYuEPmx/5plAhBe0rnHglZHe/Tg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775572320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8UDiNGg7oHctRKWHlUV1gXCd4Od4na5ntrKyJgT/gtE=;
	b=4aPDpk/BOhPMeizdhqeKflLdHnwDuQjc+fvHHMFwKTo2uyL9CULXmRIhTWdtQqblqH1izK
	sY9x9a6qlz9yL8Dhqk8t0ORgCHHVl6KrRCnwLWCvHBwVjl7VgZVZU15oTKm0CL+xv6gyZE
	KbFh2GBL4w/ttQrlMnB/6u9/0XQtMUI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775572318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8UDiNGg7oHctRKWHlUV1gXCd4Od4na5ntrKyJgT/gtE=;
	b=hPIsFLyr3W4VA+ne/yME1BuVFdvRCHH7xsvKEddcnwI9bJXKoKw+eGKfBwgxCP9P5RHUqm
	yuPicpsJNRdCJPgwhh/JZUa8WXmVa6nyw+AwIk59Ms4zby3KfYPFMVj+eVKrMeLyffs0aF
	fD9Mu+9jIyG34A1VxBl3pZeAN1Vtv4M=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-55-ji4xGGa_MkW-UKzDamWTIw-1; Tue, 07 Apr 2026 10:31:56 -0400
X-MC-Unique: ji4xGGa_MkW-UKzDamWTIw-1
X-Mimecast-MFC-AGG-ID: ji4xGGa_MkW-UKzDamWTIw_1775572316
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-953d479ea6eso9230453241.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 07:31:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775572316; x=1776177116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8UDiNGg7oHctRKWHlUV1gXCd4Od4na5ntrKyJgT/gtE=;
        b=fk7c6XWuIkFk+uSKhkGp1J9UYTzERdcxwQ2qR32hyCUO4Ql5HF9JUuceWO+UwtBBmD
         vlWsO12bcEApOQaioYujm6pAC8SYwQgwk1Rgbwnia9D9KLml9IwKqLihagEHXtVypgxJ
         VWIMtuw/fbN6XtrpwCZYLUaEE+8Z60yDWNY2Hak5WIjYdZcgck6uS4G0oMTYcHvttldZ
         a+AjZ4C0u1QiCghwaIxDIjGnD8xkXSh9IREx+t9lYKFhnhhhHaFuwovsKrYgJhBjdswm
         4l49AEzwfMQNlc56dDWol/mlcErQwLvUDTE25Vp0jlYoKcKyP5ETe0wwFoj4M65jFq/i
         lRDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWes+yicYYytrCkMmpv6DEa5js38PvuTfG9qA4djk9//kg9KuVkwhnH+Yiez4VZiMieaGty3nkSkA==@kvack.org
X-Gm-Message-State: AOJu0YzBuP3wQ6//bDMUEP8biBw1thSd+8pdVd1PJaZDOs4RDlai5v9a
	r+wzDIjoAYmCUPfHQzS+6BD44fhNoh+X26n0WPFwzbWyX70N2/mZiV//5Yi14F7vwHcUSzgcln9
	e0yzuB3nSi2OAaruQ9eYWm6JhPemfztGGcNt3YrEdr5OOFtdK/yjj
X-Gm-Gg: AeBDietHJlpf86VP8uBgcFb3OVWXOIO0CjoCuN10F/tupFFZIiUQLLIZoQda79zvaAv
	wg+WWYfluwy4dJ3wYbmvvrAdeh1VxFSRCllDf6r+B/ZuIOBWCBjc4hp/YEd0AKT6Wz/acWwIKPw
	qoWVyULz8hH6gf5ZuWhKNoUDexlZUIcNM3BN91ihh2O68z+QdCySFhCIL89c7AubBEVJXH+/vP7
	cnyPcCZBDL3g2KIhqtWKwflrk8M/hSUKtgQLutz0iEM14e2ERoG75qy6KzSfXbuda0KddGwRD9I
	LcAmZUsdo1pR8jKNF+JhJUhvsQ7zjjqUkWdFjOPl0yUFI1yGujvdCJlU6sEjydBaaUHjuk8bnv6
	EC5LWjiZIRFoqxjBK3U3+o1AJCsMQtrbxkBrdTN71vOXQscJSj/N/N3dpqUMkz24=
X-Received: by 2002:a05:6102:1487:b0:602:b037:4de8 with SMTP id ada2fe7eead31-605a4cc6f09mr6384680137.4.1775572315631;
        Tue, 07 Apr 2026 07:31:55 -0700 (PDT)
X-Received: by 2002:a05:6102:1487:b0:602:b037:4de8 with SMTP id ada2fe7eead31-605a4cc6f09mr6384602137.4.1775572314700;
        Tue, 07 Apr 2026 07:31:54 -0700 (PDT)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d3edb58da6sm1104864185a.8.2026.04.07.07.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 07:31:53 -0700 (PDT)
Date: Tue, 7 Apr 2026 10:31:52 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
	Dave Airlie <airlied@gmail.com>
Subject: Re: [PATCH RFC 1/2] mm/memcontrol: add page-level charge/uncharge
 functions
Message-ID: <adPzsvwzkTCOh5RJ@x1nano>
References: <20260403-cgroup-dmem-memcg-double-charge-v1-0-c371d155de2a@redhat.com>
 <20260403-cgroup-dmem-memcg-double-charge-v1-1-c371d155de2a@redhat.com>
 <ac_1l4Fyrq1AhY8D@cmpxchg.org>
MIME-Version: 1.0
In-Reply-To: <ac_1l4Fyrq1AhY8D@cmpxchg.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dZBVXo_MiQR3DGyTFzFn-0HWjfkU1j4p8wTFfVumtWg_1775572316
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4E5AE8000D
X-Stat-Signature: jsnm66zufdq7fhb3ncrjagso1ds7yneo
X-Rspam-User: 
X-HE-Tag: 1775572319-522611
X-HE-Meta: U2FsdGVkX1/uKioMUR5RsBpOe6D8DDU4+4qFX6zdLtlpJMqFf3rag+IQYsaRpw6+lnXUJWjrny3xRFUVHpsRFDn+IyGJ2VfBAfX9NKsNiqLT89bVYf9gL4YHt6XxaWMDaanqODfb2nX3n9QnHM70pb9gjXCxQOsK4vxiVsPB6WMsGc1mOOqEyNP0tcjyzPK8Jn4zIDpB65hrIhOXhs2GK2hJlwqoP+1fC3U/ZHqTB6eTokC2SppcUJ7x7gbrzFE1Q6BSU9fFPd6Mpjkca7JZiyAks5nvawHXmHaNt00lNMhDL9bAMFDpeUP8FyTDeYUa+Vnn4lGsf7BhcKZCbt72zHHZeCCcHikJqBQ71MnSmZPcs+kJ1ektPmvqNSBj5dK75MHAqsuIcMvvZ+mEBp2SggGGF7pAFRgv4iKc6LC+I1jRa/A4H7hfdTeo91YLUGz2Qo8h0QEsDwsgo2Kd+JLjgW9a8qZzEVI+qfIDIhIaGHzhgwRv6a7PzYJgf9ycSEoPhAqNA8Rb42hgMGsle/Eh8oXCtYdMzpco539gXpYCXhkAgrGrBntus7pEx9XM2vB/G0i7sNW+ZyPFEi5Cmi5w/VLUTPZwvWGC0EE+EKoWiImXpH0oIZbiHa4/R3ov8lU9aeabXJJkBfo9UCuZp/uwvbgqS0hJbebmOUcCDO1wZ6sSqapOK56DUFGLS1Xl7mKQTV+FdV9VdLKARHt5A1a7tZQwuWh1zWLoDAyg2olwGKNtS3YdPQIJzfdlktXRWV4VVBrpCHlV7JJKcq322kVHrMRrFQwRVPyoAvNDIL+WyjlUU30k1meycvmpVdA94rH0hmq2HHpOYspBEcFliBaXmSV5u+0cNDuuGYGpBLYWCb+enEBwW/s54lAHW0EFngG6pBcZTTch7F3hkEkkl6drCAjw9pw/05sqD/djOs1dEkMmnl5Mq1/5aRYSrYhLAlbcIrXt71a7AN5CCJ7ciEX
 6JTWA7T6
 BTcr9l8jUcRVKJFvz60LF2DvbelwFaoE49q2XLXXjIZrs/679izjo5K3s+dO8z78u5437FG7Ka4gx9BZlDdaqdC+wE1iObZVhLpP5mGlp/qR+29MbcWNV/qexMic0YxNAOEkApefKJW09SMlXpnAzWLKKBduYTtunIZPjLxWlsHObDCk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 01:15:03PM -0400, Johannes Weiner wrote:
> On Fri, Apr 03, 2026 at 10:08:35AM -0400, Eric Chanudet wrote:
> > Expose functions to charge/uncharge memcg with a number of pages instead
> > of a folio.
> > 
> > Signed-off-by: Eric Chanudet <echanude@redhat.com>
> 
> No naked number accounting, please. The reason existing charge paths
> require you to pass an object is because there are other memory
> attributes we need to track (such as NUMA node location).
> 

Understood, thank you.

I'll change to using a mem_cgroup_dmem_{,un}charge functions and a
memory.stat entry as well, similar to what is done for
mem_cgroup_sk_{,un}charge.

-- 
Eric Chanudet


