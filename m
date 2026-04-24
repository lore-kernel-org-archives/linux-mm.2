Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2D92FDEE53
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 00:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12AE46B0088; Thu, 23 Apr 2026 20:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DBE36B008A; Thu, 23 Apr 2026 20:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33876B008C; Thu, 23 Apr 2026 20:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7ABA6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:12:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36FF140959
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:12:20 +0000 (UTC)
X-FDA: 84691522440.22.841A344
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 633134000D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:12:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QKhOoCcs;
	spf=pass (imf11.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776989538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=/FcUz0voUt4L6VgJUyW4964a1uPVYvz+VsQOTuJZDE4=;
	b=dQl4uMW7pBS703qYI/Bk6Yr2Dfd804TbusT+qVs4W9Du4wFOCXfzqLA5F5933veMJoUtMN
	hNfmS1uDXE8xycVoiHCobM2x81Cg+zc3F48TL3hMPOfIbCvMItiN0bUx+UndVqaopJNCL+
	VSWUKuBCanqFIqORAvPHEua8rqK6SAs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QKhOoCcs;
	spf=pass (imf11.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776989538; a=rsa-sha256;
	cv=none;
	b=6am6FaoAPZMBSztHd3S8VE0bcvyoOnQaH2qU9UmkWTKWoeSHy5hoLAQGH/KPDTPpn86dkq
	Z9zwyqlQ7aJEQwZLyNNnIH0h4M+v5j3JIB9+2yZ8pcA80+umc4fp5dIDlygkZcHJphiCe3
	uJlfN6gNljx7Rb9X7+5MAeqkxgNO9MI=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2b23fcf90b2so69385675ad.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776989537; x=1777594337; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/FcUz0voUt4L6VgJUyW4964a1uPVYvz+VsQOTuJZDE4=;
        b=QKhOoCcslif2T2CZaHyKeb1+EVAtTT7v/6NaMkdHNpRZN8tRpbmPbydw9jX1/5dqFk
         DNABPrpv77sL4tio4yCn9IQFd98dPgrtM7H+ufFrdUcLxkLQdpAiAJUa9M4j3T9JBRJz
         E5aDA1Xbwb/1x/kZ9yne0XvO2hDP8rBtNg6qn+7g7pFolx4gZQV3eOLeGNwKJXN8x9ms
         911f3MJpy5TSwuOK02px4qwNxVLAkbfcLTygS6DLAVN47i1f+DXeKbkWxJO08JrQ12Q2
         CEXcHR1M61G4DZ23GV+azgl51Yd62vOD2S6c21aEzxQ0bRzqXROXineNpDF1k+jHnAeA
         MGaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776989537; x=1777594337;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/FcUz0voUt4L6VgJUyW4964a1uPVYvz+VsQOTuJZDE4=;
        b=ZPwW6VRqDs0bgUC7cqM+elnbbpBnyvwmH6u0Cvw9jGpu6OrObF0QnlzCTOu9t81wqM
         R2dAvovNjg7MpuNOuDjYOIS0U6fkd93uP48RzSZx0SNbzhMWjrA+LTnsSOSkvjDu2Yw6
         AnTaBJFQzqI0qyLPtFxUzzjr/dBUFCPivlvMvGj+cysv7od+p8rx9pGqfYSxDIuCd6JK
         u++X9WEVdCX/0X/hfbJFnDPL4C7RSbxy5JUoWNavJBhX5yaDC2xZtgzY7Syo+K2eMFjq
         6IOUDW4UX8S3oza0gJwq4xXlntNlXEDSS41bsHepcutYrdnDId5fx4WdloJSdg5vrMIp
         MW5w==
X-Forwarded-Encrypted: i=1; AFNElJ+gQ0n3TAAyN2cWJOodfXOfs7VeJ5eyMqogNEvJ/Q/b0pXpvARDiz+sC3ZpzcEgkbWAHmXNhCm+Lg==@kvack.org
X-Gm-Message-State: AOJu0YwIahbFYFy3KyyhIA6DKXcS8ZWwIB6kVefLzRp73Yu8Rk8pwcfN
	tgx5dmAH3SzGZAajJ+z1umEA8k/kztEGb1w9o3tBIWgVE9aKgYypyuutGAY2Hw==
X-Gm-Gg: AeBDieu0Rddsf6CvDhoYOjwwBg4pnsN33YLHt9uVh3vZ0epvrTuPwDulD9ZwWsNqgZj
	qPNSWi7/o9FdNutQ8O/E9q011I12JjFGJoHBm6sgta3FV5xhYcYqpbHOcWI8KjPCv1Aj4DiJjj/
	NJNtamqo5uXrXVvRjEf4hm/crz78G20muEU6hWyDGEETuCw6D11TM4slkXecwceHXo6Iw6AGyE/
	tE8ydR4pDj0qiEzdTta4T9jyfXj6wh829kfBvDHI/XsXDsAlRxa1zIE9HH/sumLVqD8V55eHwvH
	MaDBLYDw2xAN4t4bPjm8+J5bPxUR7LdUCHXk5KuSGGix7pEdkSA2Vo+UgNWf9QAC+z+6vrrPXYv
	LUEb5xwr+nO8yjyIWtk3GPdvoY5c8IWj5OdWZZf+K4UzhsJGkXi5Lyr9rAMxkZlFHVsWF3TQbwW
	eq9crfiK01ptYyVpKzspGp+edcck3lxeCH
X-Received: by 2002:a17:903:1ac6:b0:2b0:c90f:44b2 with SMTP id d9443c01a7336-2b5f9e8252bmr308135805ad.12.1776989536590;
        Thu, 23 Apr 2026 17:12:16 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff71esm213485585ad.8.2026.04.23.17.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 17:12:15 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>, Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap & xfs
In-Reply-To: <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble>
Date: Fri, 24 Apr 2026 05:39:23 +0530
Message-ID: <340lte18.ritesh.list@gmail.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com> <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble>
X-Stat-Signature: s4awioqpitbf8fwsnf45z7s5gzghjw56
X-Rspamd-Queue-Id: 633134000D
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776989538-161197
X-HE-Meta: U2FsdGVkX19v6CdbLLDdGS9+GqzfiSJ/EKt1539SZ/A0HlXtdAuwCLjnUa+zok6+Kv31aVNz6CsECEcgg6dQXR7Ks0v+lBrvYFgo2mV20mATgme85+6YaM+BF4+14WHYuzzHs9x8sePu1JfUb6jFt8MPyYmxriZ/EVMHEA3xIGTd1g3xE6/iWc5AwcxyebZpzqJYqGsUM8fNEpSniYzdcGQNIe0WF0jkhF/MeoUvGxtFpXZ7clI1PmwUlgqdnRYoRvq10JmD0dmIkNlQKJ0jOz9CaGTanFOwrZi2UdabnGfDz/bkmolh5bZ33tKkdELp4zVZR+gkE9QO25d8dgpnYsse37Sagu2DY8KVP+/g1ppuz6t2cBnpq+hEsQpDbYmaQtwguCMipiy5XWFTC07eyiaVr0NbZexuzUpw8Ay1QsPlpppid9O9dlAo3qCkTD0369vx+yigiB7D9ZIR+2CikmbZ0R7uLcVBqJLzu/FvqqAt9nJUw2A4sL6uV0x8N+tAYf1MnhJ4Jb7d9nO8DXVRRrejqtCjWRtf95+pZQaXJmVOlslmMgh9K5lcZTDCoL8xXuMH1mFVA38V6+UJnqatZK3mEobuYOuCI0IaLfq9h08iJTpX0W6HqzS9RK/3L4LwLDTAXxoF3flBYW9bV1yKGyMTNbcpaJ314FEG36MFmXKm/JM7g3UQhj1chQlLY9HNtG84kAkVlSco736bLeXeViz6msk8kH+rCnExjlTuok5s9UwzqqHuvNooT7cp/Ml7wDfTs0OALlIKMZmIX1AKmCpMQXQbYb5qxvKtOt/sU4mXhC3iZLHEaQ1L5vCj9X6HAGn6+uVgdDbKpkwRXbdis3PyC8eKp5oT/BY8ePRhWjYYUxfcNTHNMAi1sqk+D9TYsYOZTmOf7BLTSXm32tLhApuDDLA2EPJBE/rQdOZHFXh82hEpDbxlOAQIznWcpwC+Os9yDuv0VtKrdhnzONB
 OXPEdPTe
 lCmHcupy9fjnTRhzulldjvHpHY7SZvgRNetu2JiD16s9ccpwZAI8ERgn2sY1SPPaDBSz68ArWebVS4X+NaxBIkSAvm1JS5aHPsPuKQeM12ZYeMVNLa9HwmWxWIagmrbUYGevZAjEtunKnzfRupboXOOohy+tw1cGJotKN6rZVeEI9iuu9hHANfWHDxxIKCQwTVzpHcPK4EN/R9SCCrpUGDLGnR9EGNF690rMvTb63ASBRPCMDQDzC+oFpiQqfFt79iCUIjXkCV3xdU3QWeCwUCx2ncKfCDJRoDdrooX91cimNV/+aJCd8mBuRqGbro5CoTbl7A+hipfjOfW3LWCX1swiz/+eyVGD/HtAjClKagWwB09lmfnWTjzS/irPzRW+c+LhLA+6RQxtjnEGuep1l4fxv9LWGKz4SkFud
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev> writes:

>> 
>> 
>> * Testing Notes (UPDATED) *
>> 
>> - I've added support for RWF_WRITETHROUGH to fsx and fsstress in
>>   xfstests and these patches survive fsx with integrity verification as
>>   well as fsstress parallel stressing.
>> - -g quick with blocks size == page size and blocksize < pagesize shows
>>   no new regressions.
>
> I am hitting a very strange error in generic/127. I deconstructed it in
> to two commands that can reproduce the issue:
>
> ```
> $ dd if=/dev/zero of=/media/test/fsx_lite_nommap bs=262144 count=1
>
> $ /root/home/xfstests/ltp/fsx -l 262144 -o 65536 -S 191110531 -N 100000 -L -R -W /media/test/fsx_lite_nommap
> mapped writes DISABLED
> Seed set to 191110531
> main: filesystem does not support exchange range, disabling!
> main: atomic writes need O_DIRECT (-Z), disabling!
> short read: 0x0 bytes instead of 0x6c7f
> LOG DUMP (1 total operations):
> 1(  1 mod 256): READ     0x39381 thru 0x3ffff   (0x6c7f bytes)
> Log of operations saved to "/media/test/fsx_lite_nommap.fsxops"; replay with --replay-ops
> fsx: save_buffer: .fsxgood file too short... will save 0x0 bytes instead of 0x40000
> : Operation not supported
> Correct content saved for comparison
> (maybe hexdump "/media/test/fsx_lite_nommap" vs "/media/test/fsx_lite_nommap.fsxgood")
> ```


This looks like fsx has a problem where while testing writethrough
support we ftruncate the file size to 0 instead of file_size.

@Ojaswin,

I think we should have it like this I guess.

diff --git a/ltp/fsx.c b/ltp/fsx.c
index c9901f65..3b11b1b5 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -2095,7 +2095,7 @@ test_writethrough_io(void)
                return 0;
        }

-       if (ftruncate(fd, 0) != 0) {
+       if (!lite && ftruncate(fd, file_size) != 0) {
                perror("test_writethrough_io: failed to ftruncate to 0\n");
                exit(132);
        }

-ritesh

>
> This is on a bs == ps (4k block size) xfs filesystem.
> ```
> $ xfs_info /media/test/
> meta-data=/dev/nvme1n1           isize=512    agcount=4, agsize=2097152 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
> data     =                       bsize=4096   blocks=8388608, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> ```
>
> The same test passes if I pass `-G` to fsx parameters(disabling writethrough).
>
> The error is coming when we do a read operation which feels very
> strange. Could you run this in your setup and see if you can reproduce
> them? I still do not know where the issue is coming from or it is
> because of my test setup.
>
> --
> Pankaj

