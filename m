Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10005C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B526B00AF; Tue, 25 Aug 2026 10:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0130C6B00B0; Tue, 25 Aug 2026 10:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6AF36B00B1; Tue, 25 Aug 2026 10:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFEF76B00AF
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:48:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B02DA39E6
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:48:01 +0000 (UTC)
X-FDA: 85140071562.02.3E3140F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id F214E1C0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:47:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cdbz7zf7;
	spf=pass (imf21.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787669279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6s1XusrMHrXnvzwU6UboxiHzAtGjQbneiTvP5eiCfbQ=;
	b=KtwdqiLdGC7GkDA4sFPIrFqmh2cDQYia5tOi9JiexNe7h2Lrtg3eZauVgt9dehj9wRILFZ
	kBHh5PBKfMlh7jeZ63X2IRtRaMiuJ3DEXDX+rMs0DQLatXHzbFWsIL00c/p6BPpXy+BgvS
	dlzMYdMgJH/xMWsH7MCMvzfQgxq6Fic=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787669279;
	b=4KRhp6Dibe1LEABfze0AIN0hQIYL8U5FUJ9vfJIGCbRX3aK2tCAoW9k+ruacH4LiAaUSl8
	vFyzaueaxKadfEu8od3XDam7Enx4qnhPr1i9AN2ZggTBloiTHxdWkyjr6VLFaILyuSjFAZ
	hgHO7VYxS/U41RebRoLV1iO6c8oE4/c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cdbz7zf7;
	spf=pass (imf21.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787669278;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6s1XusrMHrXnvzwU6UboxiHzAtGjQbneiTvP5eiCfbQ=;
	b=cdbz7zf7rNr6bXdMkqRyUlRtrnItztwOlrbKbDknxtAy9xI2Ap2RWYHtnBludjVPbYx7Kj
	MIkwVq5plcaypH5oPF7fdMCJFmUI5246YjjA3Hs3tskt+YPM4VXLJ+qFBarS0vCgQylV3m
	CF46D6Y18NYQ7RWY0vmBJFnfmnHhxC8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-yPXK_lnIPZmSDOuH3zybOg-1; Tue, 25 Aug 2026 10:47:56 -0400
X-MC-Unique: yPXK_lnIPZmSDOuH3zybOg-1
X-Mimecast-MFC-AGG-ID: yPXK_lnIPZmSDOuH3zybOg_1787669275
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-92ec3146553so896555285a.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:47:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787669275; x=1788274075;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6s1XusrMHrXnvzwU6UboxiHzAtGjQbneiTvP5eiCfbQ=;
        b=LRP0YxBArTnIZf2bHuoPmVR9J9fdt7eq2otATOGOR91Erk+o+TF3O+m7p37Y1Z2Ues
         tanSAAD4UBmUkXrb7gTV8iMW4DiyOsaLHwJXhZ2agvx8mu8UtZ6Nk9ayEkjgcsI62e58
         5v8kI2AFeEzmfq9z0bghUTpvPi4iwHNZF5tSRH3wO+Y7difwYLV40enbhh3b03YkO1Tj
         PtYVT7ImqdUqLNjjS7BdGw8JkDLwHZX2BJQT0gGesLnK0Xugvc5B8EIfVeava6McFfrF
         qyF9zccWu3VkIypPgnWCrjNhJxwptUzkQpJsdotsv7Mb+YSavdvDv2gmLWkLu3x5KVfg
         dkHA==
X-Forwarded-Encrypted: i=1; AHgh+RofwcBJXvrTKu7UK1YnxI/Cbs0AEIxExq+hX4vzH/TnrJlOUzKkxA2OEjmYX+HvBQjlMSnUR26zVA==@kvack.org
X-Gm-Message-State: AFuF++lRaVYdZ1PV2gLFeOjdI4EzknUnXtJlYkPOYIGQfqn0oTnGTUND
	B0TQt28+qTT1dpHtnL12EuDc9/g2dp6FX0pU9VHGgcWGu9XCLoNUbMNrHnAFKARQMRNsnLTk5nJ
	T5k3jGZpHqSX4zqmY+/EkeJ7N0oTeZhdc2bO3oSkibR2yyApKRKL5
X-Gm-Gg: AR+sD12KzKEKLRRs5TsitIKofb+YqCzHYtAYONdgIce99Pa1Avll1RxtqIe+TVuzzbS
	3IwP5korakCNDUShrstUD+HI6nfr5BxmjIwUrv+AlJCMXGOXyv66TDWQanzD2jpGBLsFgpatadc
	zkDf99Z4goCN2y15TX3HKeb6ETqcyLNQ26WXoKsNzViCNcUqnGWB7BFpZdV8U17U8tLVMn5jY4+
	CIymgkRki4KtMLcLt8yGeFKRsKaJE+qzf7rcJpfVYXeXbXYQn63qhxx6Umq+3OVYfSxC1lKwc0v
	6ITP7JdHbWB7mMEZ3J5oIvU5ZL3TECvKG6LppoCkGdF9iTga6c8Fhb0RkC+h8ClP1K/cshbDVno
	gXtF5hFisnv7AyVD1fiAVPqyIZQu4G1d/4q4Nwrk43X1M
X-Received: by 2002:a05:620a:a413:10b0:936:d35d:204 with SMTP id af79cd13be357-937468b3248mr1928935085a.13.1787669275401;
        Tue, 25 Aug 2026 07:47:55 -0700 (PDT)
X-Received: by 2002:a05:620a:a413:10b0:936:d35d:204 with SMTP id af79cd13be357-937468b3248mr1928929085a.13.1787669274849;
        Tue, 25 Aug 2026 07:47:54 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93749abeba9sm745605585a.3.2026.08.25.07.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 07:47:54 -0700 (PDT)
Date: Tue, 25 Aug 2026 10:47:53 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao2gA_m3BCBu2esy@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aowHqqaqK7TeexQH@tiehlicka>
MIME-Version: 1.0
In-Reply-To: <aowHqqaqK7TeexQH@tiehlicka>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: q44CJhyETb-y4lZeN5AWvHQrNzyMcJV4K1LMi58th1Y_1787669275
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ecww4r7uea9ziwwgs45f1pq9szizdysc
X-Rspamd-Queue-Id: F214E1C0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787669278-81213
X-HE-Meta: U2FsdGVkX19hYl+nGidKOwch2DOBIe9+hGD5SLN248aVhYnW+pDHjGHWTdFgQLDFu1/DhfdoBZZx46lp1sByh88x5RIoKHei9aTsR4EK8Z1OuyylfuT4fE9y1D6n4qHZEIUD6ncybXmQV6O1DuoR2LcIkdncBl0W2SC2aD8cPUbYXBOEExi8jC3GjrLcz1iioL/oStgwUhuLyq9ZYLRZx1XzK/zSoHUAgdbMINnoJFXUEll3ieyTUzCalgfgnkyL2G81hlQfnOdK4AVXk8gf5Kg0tca0J0HetIs86itiJuqDDLCzWQOUeDhXSht9yiVz09I4M3iLQa/rOjWi53xdYYZiGhSrfZXZEILnj7ZwlO0ysbbbVqV+6OckCl9rr/Ob9qOGkUpKbRdGFMIE1S0rH0cohDQR9ia2lJPHrmXvS1/nQiqLeUC/2pQ9PLlJihOPjx9E8dhGcakK7yX7U6tJ3VRDF8ybs7J/hORdyBLXqpxb5seANvHw2zLnqJg6Cx4KziJCS4GtlfYNlmDXv4CqiL7YrgEZ7R6NbMO4YSU8BxzYIcKqx3Vm0isyUwX5jmYUtgluoyCSP1jgmtnatxty4i+WmUl0r4sRzMzYbmSEf53987FNzAWolGqomHexGWO0JMZDCKJRpzKuB2O74D1qpXwGwgBrU94ppXenEMgFgFw3r1Sn0a+HrmPqm70U6fKZmZcZOqAa+qmEHLAeYb8haR9BmS+5Z2VNnIAQqKKLqypUnftZQASRMEhoedy3MC/kzs/nurOADLM4NAOOBCs6zWeThpKdIUCq95O5zIvenINK18xMYTYl8TIT4PiwqLz++bcIswoxRYV5cpCG+ZlY8dvk+tlEt8RhJmwrWvQMiOwToauS3UxhYtrCDcPzUysd4f9sM2Jq8XxPsOMXtA22UkM+eELvQDcvzXHGxJ6svReE5KdHQQb01QX5g37mvlNYuHD6/6xeuQbGELWQrpB
 ARWGSVCE
 mV7k/SiNudbKT9Gz/2A16JIQM12Lm+fEUJIfRbtEIJT55onpkhkazDdzB6Xq7yLuf6NyCnx5YyvpSKk14huMXibBGhXtHyIALFzXpr+dUx4d9AY9/oG6Sht2fhwtmCo6OV765rxiJfWtG2O1Q67u5Lll1285RIdqfg8slFPRmvce0c41RWY+tMCT9bt/3hE8o28o1ApCi5n7GBv4avdeJ60QGAYMX+0KToxQRsm6TvYSK5q4Xe/Zt24gu+s67Da36UGmyA2CpwznzRRIKVonfL8SKqmPB2zIhHZYc8f7dP/203V4Qyl8dBjkJZGQ/w4Z5ey9XLyJwSPX0a63UH3n1IDFXdgtxRcsYBbMoJSrpzxIatT8E9t7A7jDo3uklVND7qWCButHRzov1+iw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 10:58:18AM +0200, Michal Hocko wrote:
> On Fri 21-08-26 14:56:52, Eric Chanudet wrote:
> > CMA allocations are currently unaccounted for by cgroup memory
> > controllers. As system resources, they should fall under memcg, but CMA
> > areas partition the available space for different purposes and memcg
> > doesn't have a good representation for that.
> 
> Which CMA usecases are covered by this work? It would be also great to
> spend more time describing usecases.

We would like to offer some usage guaranties to userspace processes
ending up doing allocations in CMA.

For example, a shared CMA area is described in device-tree for an ARM64
platforms. Userspace components could then, for example, allocate from
it through the dmabuf heap, or a device or framework-specific ioctl for
that matter, to use the buffer with sensors. The dtb may have other CMA
areas described additionally that may or may not be used by that
component. In this context, we would like the ability to limit one of
the userspace component to over-allocate and choke the other(s). memcg
looked like a good fit to achieve this, albeit handling the areas, so a
cgroup has a quota in a given CMA resource.

This trails from an earlier post where we tried doing this using
dmem[1], but I was unable to reconcile the requirement for memcg
accounting[2] since from dmem I didn't have memory objects to charge nor
the guaranty there was one. Given CMA is always system memory, it looked
like a better fit to try something without dmem.

Best,

[1] https://lore.kernel.org/all/20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com/
[2] https://lore.kernel.org/all/ahB7pCu_G4vuswc0@linux.dev/

> -- 
> Michal Hocko
> SUSE Labs
> 

-- 
Eric Chanudet


