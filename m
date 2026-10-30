Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95BF4606A320
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 17:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Xb0kypc/
Received: by kanga.kvack.org (Postfix)
	id A256E6B00EF; Fri, 30 Oct 2026 13:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6736B05B1; Fri, 30 Oct 2026 13:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5A76B05B2; Fri, 30 Oct 2026 13:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 593106B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:40:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5EE8D4083A
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:40:31 +0000 (UTC)
X-FDA: 85380007062.29.B98DD5A
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 95ED44000D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:40:29 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="Xb0kypc/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793382029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHjT9rUZ9mZdmwhmeKnY8H1ENZyPrLJ45wFlFoMuMrE=;
	b=KoQavqhZ0YeEZS0VpmpFA1PNHh8UPqg7ZzyfZZvXrRnu2/cabSIdmih0XdVArBF/TofXUz
	bBJLjOM5xEi4bcTlqXDPKfcuNrbVunQQo1bn0wkP+jCHhcJVMvZaU5TcLU2wFvPPgeBuP4
	ZUm7qd5fscAauyHaX1U2T2D2uP4n384=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="Xb0kypc/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793382029;
	b=wFEg2HLWEQNyZ8kStq2y1NrpPoQV+mmbqq0H49Ig545U6M4/2ZEJoEHGjh9p/fHfxRlQnr
	cXGroijMPnPTaZvcA/aCY5owQ6hxTWYMSdTmURd4/+WSJahjMunNluJNVfbsf8cLBBqK41
	gFOo1sETza8UbwWlIyEqxfzzARP0I60=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ea7f9c11e6so3285ad.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793382028; x=1793986828; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GHjT9rUZ9mZdmwhmeKnY8H1ENZyPrLJ45wFlFoMuMrE=;
        b=Xb0kypc/BChsH5kJTMJc/Rlph3+HO9usrqYhQ2jgHoS5BsmovoiQJEM2nkVUGZ5VWb
         hkm6y72OMTDLzMZM75SSOgpXdsduHoHfAn+a0h1/37mobk/PMJJQYcbJs9YNNeiSlZsq
         0smcQN2wtMwBIdmtdVeVge5KCwiiTSZYN92uxzHmWeer6Ak25lwU0f1I6pKqbb5zSHjd
         3gwNjPr32U/eiL0UxaRXhZqyamzliKvARdMIWE8h0+iZ0eJlk43BWNGltr/uxuyCxY7l
         6IBPdID0nMgnNWUtYQgjUUuae4mncFDh/TzyM7F+qkrbDo5v6/ljhoVzlgaD13L33RCK
         rJ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793382028; x=1793986828;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GHjT9rUZ9mZdmwhmeKnY8H1ENZyPrLJ45wFlFoMuMrE=;
        b=oHxaquW3nJtY+5jMurtQ6OS7u93dVvDAIvzHtmgfiN6AVnkHRXAt+T8CAYDYTYkvW3
         6Qn7FsQhTuxJwEFEkTD4aW5mBY++dgNsekbDhIduTdAyxHc3XIjkQFSBLDG84N4ZP7Vd
         EayYkYsPxk8g7Fca8VD8MQuxi5E3DJkyyGdPsPUIeDxVq3p3ozTbvXAsWG31vjdxscb0
         GJ+PgW32SRbBmyq/7cm1l+mof7cx2degL2FICPYTdswT3vgnN8WlPMpu9EhYWRFF8hB7
         KIFtbfdTrkWBvfslmH4UQhpmNOz1T4GfU/rDVrSSc4trgylorUPrZPdFkp8gK94XLdvb
         3BFA==
X-Forwarded-Encrypted: i=1; AKwUvByY2ThTEl8mIuuWX0JzOoQ5AImv1UE0/G6NBHfeXWC9C6qFkIU/nVrbZKkLkm4IQbAMpjzDUsBXDQ==@kvack.org
X-Gm-Message-State: AFq9FYKYSJ2dKesainazNghgIM3RSz8jKTqwHVZ36EtKoSNNUrTRTZJ7
	L6gcEc2U99Whbzb3/5J41h8U3NBQ4sKPu46OXdivRTqPBB9Tjhz/3ApRClzM5bs6Tg==
X-Gm-Gg: AYBFou0D61/afxJH7FTjFouWAgweF/j9ooFfhnmRuGQkkBaId2LK6T090Pr+p0VV2v4
	U488TbQnTVPyUqhUw7HloUAwW1+ySjp9lyOOcTzAJIYKqSgwI75pMZhxg3n3CYCn2K8wdJ1JB9S
	8pfjhTBQ84r2U0NPhInJLgbGl+zPc79t1L/3YEvaxCV+iFruOJE44CBIbhI2kuk0x2JzxVWue2J
	Jx8aXykknofXOUTfLDJzSjNzVDsEFooQrSdVQUq2nsaKw8p0Fz6teG9K+iGGFS7xTnf921qbG+V
	gs/dkHtL/Qrz9aRezGdQkF0o2d41kQ+FmVwTRDLlB3XbEXbQppF3iZoAK5sv9TliI73M4L+U8Gj
	U5GpBDAaGEctyxbamWKNMi33Sad43cLbJQb/UebIjhtuUXCzUug2QGaAv/6Eu1OC7kgV+DxzxGI
	d5EfjnnDGVCM9zJLRWVZqfBsHWbzeWdkx1udj0z3uV7AolUWDQwrjrcci8gtXOm63BtNIQsCYai
	A/NvRcD+BM/Q97i+0j1/xglWZ+0B9+j8gPhy49R14rI3I5jScxdT5UPqiz52PcixsAdejlz4OHZ
	uHjIvQojrwBWwQn+ScggNb+BbANrkm1JW51UIOP1Qagk1TOnHz0QPHRyrcb6gUMD9pUGpWk508n
	1tfu85x+3FRQdJm+HsAz8Ww==
X-Received: by 2002:a17:902:dad1:b0:2d5:c090:3810 with SMTP id d9443c01a7336-2eb1b6c6ae5mr11320655ad.2.1793382027347;
        Fri, 30 Oct 2026 10:40:27 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8aada9aadecsm286624b3a.48.2026.10.30.10.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 10:40:26 -0700 (PDT)
Date: Fri, 30 Oct 2026 17:40:22 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Gerd Hoffmann <kraxel@redhat.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/memfd: add F_SEAL_PUNCH_HOLE
Message-ID: <auTR9SnDLsLVmnJ7@google.com>
References: <20261026220546.3114241-1-skhawaja@google.com>
 <d4891333-43ea-4d74-9fb9-6ad8dac1a446@kernel.org>
 <20261030121113.GB3889730@ziepe.ca>
 <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <2c7aa5c1-3af3-4654-b244-1257d05c9d45@kernel.org>
X-Rspamd-Queue-Id: 95ED44000D
X-Stat-Signature: bbgrqnqr187tj6iq6otbuh3zp6rb1b87
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793382029-497972
X-HE-Meta: U2FsdGVkX1/momg86U4GfX6rVnEkMi3MRM7jppBd0rgbRofLuYqZYn1lV1e5OF3PKHk+1nBFVMkoF6L/+BxnyGIf/5d8s8Wz0jEyARK690eV2SSdSGJVHcusEfKMjrvGbV0T9Nj1qA8sGdQb6c1GH3UikrqNLhPLFiN2nQeez9236KqaYbPhLshSqkNvkqUbM76DXsStEXdIzNFmo0IJGOWlnGKCqgNldyctUrpYe7KGlESKcseOTwrmHfrH+ZjCbgFQOvL0zrTuv6Zta++9oMqcBXjD4qD8/qsFGVn6gCNLZ8p99SQtsin0wwP3atAoQ41iWu6uOokXucukqFOCC/2Uo1rGmzpCe67OPB8qgVmSIwOcJ3JLWziwI5HrZk0qYHIg40/gctPKNgzEKErQi/a0l1/PXs6TBOkMvbx6AhRmcy40OKDbO8JFMIfrWJ2eD3ofeCK3t6LeYoU3AaEAh3EqC3+QHVCAmur6Hfpa6ALdOZlas9xcWA6R3Iy67EJ0UhjHUXdwqSKfvbpbL5SzTkTh5pbbUjQusQWAYGdwnT4jzl2pUH7NTAmn9TnnY9i/qLFccOjNOLLOd+l2ApCxhsW+t0wfdg4Nr39CMvOfAEwlPyEm5IGsUosNSrN1rvemHd+w3PVD8MeUK5Xf4QDKjpTt6oQOVle5RTzKgZ0BFEPADb7GDsEYQ9MEkSQfx6FVSb70kxzOtfNXrH9LToUoLiIrTfBKj7+YbQt1OMtE7DnEWQwDtM4Di7o8LgopoRnhSZKlwAToakd4bQH2RFhDjiuryJLmXW6Ppf8du7r3o5PlKfrBGm7MDVm9NpFfoyQvzVfNWf+pEksi4mjqOCnFUEWGvbkhXEJRNf/vojmmvVyjKLRPfoEjV1jM7GovV3yBhQX3HrOIo97TDIZmrcGfqmPbVj9BvZhVevVG51P9hQufL9kwvH+3p1FghggGyX4a0KsKvcpZU26gkwupO7q
 bzfHKbe+
 FKAyykpWO3im5rSrud4U6qy5QZyl6bwOkj6GM7wGdirGp8b4pqd0CyhfQjvWh8BwBGvfOnuJWVX2YmEsGqykqAFsCUfc/tM17c36NF71vbL+09/ac0GpMobUVDdXDxCCQrQBYJ5NwbH4LWpAaISf1SwBVOPEPXuLpPgFBW6mHpGx6Oy27SyumwSc8rc7JRWDiFW7RW7GorHCAjD2gg4GZ2UUo8TFLle/G+MT+HOMEIUHAZ/XLAJTJ7vmRcPnIXUGbf1ZJqdvEnJNaTaR05JLl0QOQrczbktqVX7s83Z8PU/OAJk7mLw/U1WavPiLK/j1NaAXA7hM9z/sIM+M544AYY0ujf6UeF/YS/2kjTxcs26q5IsJsiLt1FLx8zT/NmHeX/T7jA0Y/wYXvDy5esHQUW8C8Lq4h84vVIaeYK/WZWRPgJ1NQuTZFZ7sXJq6thEN+afz/GmZfSeB3YyEuVO17DienRZH56ZphHRmp9dmjysz6SAs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 03:39:40PM +0100, David Hildenbrand (Arm) wrote:
>On 10/30/26 13:11, Jason Gunthorpe wrote:
>> On Fri, Oct 30, 2026 at 11:20:30AM +0100, David Hildenbrand (Arm) wrote:
>>> On 10/26/26 23:05, Samiullah Khawaja wrote:
>>>> This series introduces F_SEAL_PUNCH_HOLE, a new memfd seal that prevents
>>>> holes from being punched into a shmem or hugetlbfs memfd while leaving
>>>> the file fully writable.
>>>>
>>>> Background
>>>> ==========
>>>>
>>>> Drivers such as udmabuf and iommufd (via IOMMU_IOAS_MAP_FILE) use
>>>> memfd_pin_folios() to pin the folios backing a memfd and hand them to a
>>>> device for DMA. Pinning keeps those folios allocated, but it does not
>>>> keep them in the file. If userspace later calls
>>>> fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE) on the range,
>>>> the folios are dropped from the page cache while the device continues
>>>> to use them. The pin holder is never notified, and from that point on
>>>> the device and the file silently diverge.
>>>
>>> We have the exact same situation when userspace maps anonymous folios into vfio
>>> and then desides to MADV_DONTNEED the pages. Or any other memory backend that is
>>> used for such purposes.
>>>
>>> User space must not zap/punch things that might be pinned elsewhere.
>>>
>>> That's not specific to memfd, udmabuf, iommufd or anything else.
>>>
>>> I don't see a reason to make userspace (that should not shoot itself into the
>>> foot) a kernel feature it must activate itself to not shoot itself into the foot.

Agreed, for normal use this is userspace's problem. The seal was meant
for the kernel to cheaply verify at preserve time that nothing was
punched.

>>
>> The issue is live update doesn't preserve those background punched
>> folios and now we have created an UAF attack on the kernel across
>> kexec if you don't do something about it.
>>
>> There was some notion here that with the right sealing flags we could
>> tell if everything was 'live update compatible' and then know that
>> these attacks are impossible.
>Just remember that there was any hole punch and refuse to live update this instance.
>
>We could likely implement "we saw hole punch on a pinned folio" as well, but I
>don't think that's required initially.

If I understand correctly, you mean recording on the memfd that a hole
punch happened, and refusing the live update if it did? That would work
and is much cheaper than what we do today, where iommufd walks all the
mapped pages at preserve time. For truncate, the existing F_SEAL_SHRINK
is enough or I can record that also on the memfd. I will send patches
for this.

>
>No need for more shaky seals.
>
>-- 
>Cheers,
>
>David

Thanks for the feedback,
Sami

