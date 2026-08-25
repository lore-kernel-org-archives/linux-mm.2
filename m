Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44BA3C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:54:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57AD86B00B1; Tue, 25 Aug 2026 10:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552106B00B2; Tue, 25 Aug 2026 10:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468186B00B3; Tue, 25 Aug 2026 10:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21D146B00B1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:54:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B088F4044D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:54:32 +0000 (UTC)
X-FDA: 85140087984.26.4768611
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id BCC14A000F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:54:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NcLANvml;
	spf=pass (imf15.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787669670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GckowvKcKSZKNqS6mM8Rx6dNZPUZzNliQME9DsHgsg=;
	b=1G2jaGtkAnsrRr6yaxtYBYwhwOTb9c9F3mlo385ZnjVLDnwrs+Mj+J8ElRMdtws5q4vDZA
	gwxO2CvCYQn1yrepK5RtAghteFionsiih9Vdk6MYyxIotQ0lk+Fm6WZMWygMvI0sIQJqt4
	Tpvn8kX68SysnQUAmtjOjE6hFat9wR8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NcLANvml;
	spf=pass (imf15.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787669670;
	b=u4O0mP8g7EeuKmY/A8dB9R8M+/KCFU0NIGtgBQW5JOK7HH+J7O8G2POlTMkzZj35UtL7l4
	TkUzW+vDftmFXvEoJ1a++G0RE0782lawztDu8MAv3dvcFo7uswZw9Bzq+isUanuZPcdG28
	9lMXqqgvdDiHic9bfAgvhtDhv+Fjy/M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787669669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2GckowvKcKSZKNqS6mM8Rx6dNZPUZzNliQME9DsHgsg=;
	b=NcLANvmlPfr/MOMupVd48j6x1JudC2DHDJ8U78axbVgZSGEzU3OwPdrEV+rNFH/qU+531B
	k76ufLY2xQO/pwSKPqZziunnsg4yU+yBe5/CB+z8T1mNpxfSz9lBVFfaxYfGS2i9Zed5Kp
	36iP2xIlTzuRAV0BdBoWlzNerOLdsyc=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-nNaYHaPZOR6SQVuG8Hmu7A-1; Tue, 25 Aug 2026 10:54:27 -0400
X-MC-Unique: nNaYHaPZOR6SQVuG8Hmu7A-1
X-Mimecast-MFC-AGG-ID: nNaYHaPZOR6SQVuG8Hmu7A_1787669667
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90cc540a846so1167566d6.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:54:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787669667; x=1788274467;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2GckowvKcKSZKNqS6mM8Rx6dNZPUZzNliQME9DsHgsg=;
        b=pNS0ecrX5ZwKQXqlKGIpG6xtkeEceXX/y2hFXEfAmVWQSOccNZlMHb0UU3SthDxFsa
         +FMK8dDR0+PGB5CbUsgPlwJw9a2Ge4o4Y82WhjnqsW/fv7YyDDemgmOMoS8rOFAXAPqF
         iMYjSf6yxRiNpydOtxyFa2uIOi2IlGmpXEYQ4sp7WMLMcAlJM8CGfZ/AcO/tSHrh0V+z
         CHY7G2NM/pkv3APd+HMILTSFF/9hB/Kuf0z8SJdoPca0mDRdOLGmi6u5bTEXrR6/1RAt
         rKOGDpM/0Q56TrVBjEK0/Qy2UQELU+QzbgzNEtPDn9Sr8CcbdqdHJofelvnSGDByTCho
         MfxA==
X-Forwarded-Encrypted: i=1; AHgh+RpiF48KFwDlgjCqiFBt+fCvAd5BxpzBxv5CF2g178GSp0V4WTr38EAxfBU8ZgulYeXrzWLqpM4UPg==@kvack.org
X-Gm-Message-State: AFuF++m0I0/PRFM9PTMVZqSV/H7on+GD2Fal2FMHrzHF0CwhkTDbSbGA
	9fzVvMT+eOUpScYlz9VU9zWuIqp8DZYvgSwObsv9VoL2F5+r2Kne3O9rODwlIA0vNgJCzPZPj8H
	HG/RSkyPY0HSKuTiPf0i7rk83IuyEPKEy6eDGTM3idEGsEeakokes
X-Gm-Gg: AR+sD13KGnZ4KKcvJhEvQPOlJju6kzbIpzsIaZ/Kl8CmD7fX9Cp8SpZgSf1EQYDUNHC
	sV5wcfXDJ8TjI1JQTJr+VARexo6407L6B7XrqHkxwbS0QQbHHjMqOQmgUxhfh9k0qwmqBgagNA7
	e9+sECFrU1EK2leg89A2bAuaV61nXzcOMzjGQKDg/bkFVinKwrvjGqqYG5AT6MJ4ob+SsErs1yI
	81Iq9GpxFhftsIWHSsQqUhYC3/LqHgEv0Z8NseqLlTHW4Nqw391azYEL0loMnFEL+UaIXA1ffFj
	Mrxj46/vEVpak+RIQ7OPUEVtbHdeChqef44PAGeMAKmR1WiqQjSwrOhUUT2qizAhqge9SIxE4Dz
	QQ1pdKdjdB5rU1Iscq7lcXt1j0Jb+r/vkxYjS6ZOavZdO
X-Received: by 2002:a05:6214:4304:b0:908:7fce:f111 with SMTP id 6a1803df08f44-90c80c13e25mr416128686d6.6.1787669667130;
        Tue, 25 Aug 2026 07:54:27 -0700 (PDT)
X-Received: by 2002:a05:6214:4304:b0:908:7fce:f111 with SMTP id 6a1803df08f44-90c80c13e25mr416127656d6.6.1787669666433;
        Tue, 25 Aug 2026 07:54:26 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90cc63e8d21sm592276d6.13.2026.08.25.07.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 07:54:25 -0700 (PDT)
Date: Tue, 25 Aug 2026 10:54:24 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <ao2rHli8HUCJ8h8Q@echanude-thinkpadx1carbongen13.rmtusma.csb>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
 <aoxEGzZ1eVzIU8xH@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <aoxEGzZ1eVzIU8xH@localhost.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jW1kakOYZEMYUHwbbR2PfDPTR_09Z3alJX3FRTyU6_A_1787669667
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iz3ntyotr4uhqbfkk1zgsr9owfig36pt
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BCC14A000F
X-Rspam-User: 
X-HE-Tag: 1787669669-305736
X-HE-Meta: U2FsdGVkX18T6egdUowTGPckfhicXtetBlcx+GoDD759Q01VjNoDsVNx00jnz5vDRpLgl1NfDU7zDUhDA4FC1yB4tnoIZ5Of9/OkfdS8Ku/HBZ0IcQU+GAQO87l3vossrArCNXtyzbxuerXMFPDG6dfO0/dJC6yQnF24QrN3HCR7ntZhje8sHruOdHZpgt0zqR/MAdZtEpL/rzNnMdc4ZtUJLm4dQeKij8zXqkYFD0P50VVjRwfL3mWklLFG+QXiVZP+/7vwGJwmRHrQrlzHuvkrr0TpVxDjApOdvDYTFINK6Wvo9lea1D8cqktlTpst+tQ1luT/wY0f9nDqEehDhzSzotZ0A48BcsEuWq/CEuav+jDrUa+kdPGst5z77sBaCEivB4sKVEt9zRqHQXE1aRPUis1LCP1jVPBRlzBNGPl7XpE1Mbq3+MZOi/dEaqqIJ61vjDHAoUV6znqRlAP4IsOm+FDG8wyHPx3c2ZzxTcZmOyHN7cR/q2rn6idgMgHPOF1IdxTyO8sTYY4XffVQJNHEbhk/5RWlBCa25B2FloI4WRi+5MYdgrDKGbPONJbUyBnX0g9oucO5z0lKtGHu8Mg478n5DNFctzHRbOjPktEeezld+ci9mCDdFvkS4xcEzau8gOm5GsZR8ud09F26A7BYA6KA3hdndSuSsaubGO2UYeseCiflGug7tXCWM8L/Vw4FjcTn/sSKHOxOFiojCWT8OZn2IzYn6DTgALz2SFTXM8xLaIPc93xLNRQ8EsuEJnup7b4VEL3B7//jNr2erJYuNZGBPeVi6escpirmxyZdBSWk5NoI/jPyLCi1EQudDV2UHtpKXasQxPnsupm2qJLXlUzlfZSeKQ38ylPszDcJP/YOQ2EiNzD/Ut9BJgzHCztWGVTlexE5FxWSVpyeMgYZHfHDloZdWsG2qG4wPGEkuAC9epGFd7rzx2meLhVTkwnjxK0ZG7j72KHQY4Y
 0qHtlhZd
 MEzR4rEwzlYRjrDm1YaqiyITzA2yshPnijXn4TZczNG820ugynET4d+OnZZn7mtRFxYQSeUf3883gkp10zGoqHZwljixrOXOhbtfrFsbzPBhijjm6NUw+XOYnusaSsfIqyjqVpY3ZNVYKrTM7SN/z/Ve9mPlIUs9Zf9jDf+4UzseCPR6H1lYJo713TZT/cgA5St85Sgft4rnew1MoaPI1Spt4bNEc/+zNTEDGwgW14jQgiiUF9UTnN4xzW87AODD9JvE8krzBZAum7GohsEILleDBP+5JqGBMsQecZpH4mupiGgxuJXDRJXkrcqpuanV9QRLDfumcIi+wF0YvYrhXpUUsOcNvFTBPPo0hRQTSlOBTSuV2MqXk2QC+U7lobtu4e0QPar9xoSYloXvSY9dDuguTw7IEbuyFOES+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 03:18:54PM +0200, Michal Koutný wrote:
> Hi Eric.
> 
> On Fri, Aug 21, 2026 at 02:56:52PM -0400, Eric Chanudet <echanude@redhat.com> wrote:
> > Finally register the per-area usage counters in the cgroupfs. Each CMA
> > area creates a memory.cma.<area>.{current,max} pair for reporting and
> > limitation for each area.
> 
> These areas quite resemble dmem regions.
> What is the relation to the previous dmem double-charging [1]?
> (Successor, alternative,...)

They are, although I did not make it clear in the cover letter, my bad.

This is a CMA centric alternative to the other series that tried to
issue the memcg charge through dmem[1]. CMA seemed to better fit under
memcg directly as I couldn't find a solution on how to correctly charge
memcg once in dmem where it was determined to double-charge or not.

[1] https://lore.kernel.org/all/20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com/

> 
> Thanks,
> Michal



-- 
Eric Chanudet


