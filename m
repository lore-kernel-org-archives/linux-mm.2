Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A712CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 23:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480C08E0003; Mon, 29 Sep 2025 19:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42FB18E0002; Mon, 29 Sep 2025 19:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 345DC8E0003; Mon, 29 Sep 2025 19:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CCD28E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:07:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BEE00BA060
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:07:31 +0000 (UTC)
X-FDA: 83943826302.07.0997298
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 02E74180007
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:07:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="i/hJJuHQ";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759187250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycF1xwyVps45YvjPAL6/s7wnfuJoTSzn0L/ibMXGQfk=;
	b=5gj1kSKh5sq8mr/6X5dCAP6FkqJDvXRd7AQb2KkowcV6w40vUuVTjuqiYFNErqtmyRHqZa
	97Uinm9BtumfxEzqXI0qzYLAuGu/KzWf32tNOptZ8ZVIjNPL0h013zHjfXtZMwR2WDg4lp
	/qLUUr/UYrCjYqEXd+Ue+RoH4E0QCXw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759187250; a=rsa-sha256;
	cv=none;
	b=wD+UCy1NNFHrNWGPG6oxrCQZAaONbYTXOrRyDchidwjEn7U+fbafK6K/L15wRYAlrfqWsp
	6DpVHnm78loY0h29W48vDKU0ybiBZhAvBUEBotmUotWxFXm6ceVNDe0oV8upw702Tug7aO
	LVpKQRRlObaEF4tRntsBnqvclD5dsAI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="i/hJJuHQ";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F05D260277;
	Mon, 29 Sep 2025 23:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD2EC4CEF4;
	Mon, 29 Sep 2025 23:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759187248;
	bh=MzYGL2wyER/KYmOlEBsTQeh1KZnV+498S1x4K9T9neU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=i/hJJuHQ4BFjq1aqT9W1i3XrvQCgoFv1iHZt10Y/P2daBJK90SW24q5GgKWnaSqqD
	 WMQX71oSHaSKZLomoO/GdqGpNxwnEBR0Y97tTw/5jEmda9/MAV0aY0eIljpgnYE40w
	 lZjrQpmA3k8A5sVj4ZVpl+mNXFZkV6o6DcrvnNVc=
Date: Mon, 29 Sep 2025 16:07:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: pierre.juhen@orange.fr
Cc: bugzilla-daemon@kernel.org, linux-mm@kvack.org
Subject: Re: [Bug 220605] New: Very slow access on HDD when a swap partition
 is used on this HDD on kernel 6.16
Message-Id: <20250929160727.a0119e93688378c570a3c550@linux-foundation.org>
In-Reply-To: <bug-220605-27@https.bugzilla.kernel.org/>
References: <bug-220605-27@https.bugzilla.kernel.org/>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ta17sbx3aa4h1pza3o9ga6q5tphojtqj
X-Rspamd-Queue-Id: 02E74180007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759187249-758215
X-HE-Meta: U2FsdGVkX18/PCJJUZjlmdQel/efEUwB2nrAX3UfLGYieFyFvNMcB+SCzOl3d5aPALA8E3lJYEUiFGsM9LnoGzZafP62d0hmem/yOIrj/t2Iryoxi29mBBakM9ObsVRBfhtdEbrHBjCSeJEACXhulE+yB0mljKWDDclX1wSK6C2b288cwcTtygr0ip8aBZcoLzMQqX5AdTtWVUiggMKLmDMb5YcwqUZaoQMw3SuzVMBlmmVOuUMWRUp+eTwTLn0W6+DclTwfuY1XfzLkKng8mAfRt+R//e7rV4hWmevyV/Ub5i6EKFXPZnXYP4S3rn5ODDpgoneuXbETdTffGKT5XQMi3dsVk0At3xXbHBByG7qncHduZoyWfVvO5iIzuaU2KHSl9Mrx7VSfqPLEyMMIvd2jtKKIPLaK6yr5JniURcCAFP4vyGx1Xm87qvpUJ9KSvSW2TZHyaBneRhSqszySH9t99jfAYD1F1C3vBoSXYw/fCrmKFJBZml45lfKtzwGR/dfIpR+rx57yDu5Dq+J0rw7zo4AoDWXZeIvoohn6svs+8DpuDVeh76gwfE6E2KQ2W8VwlDAQcCVVBzHnlMiAef5nq0Qfk8+tfNPxLobY9ND7EHuKFZ59amo1dhlCMPa/h00ExHebDd6sKEhYLkjnBnnLYyY5WiBlqMUF3dz2hUhNQ8KIPuEHSytVAbCzeCryME5hLmB6Qmo6n+muYSKr336elhTbTyXVMenSqs8yweWFfxFtnGvBmJHlC+BFKsVLM7HPsutFrrbZ0DhpOYuCctMJKBUm0L9RYQF1PRTIjKZoTxKoErnu27LiwuSzf3huIGDxNkGYLEf3RnLmnqJI7rYiC/y7unCkz6cdHk/xrnTDKsVoEcam7NbrNBzr2+kkROjJ+zpapXDNXTUuDH9ekywFK3tzgzEgoSx2KJ0/YNR8hmYQBf5H4IQnu7kYsWIdv6oEwzyqS/yuscP9GwX
 UmmxuCpu
 7fmIyNDPoM99A1EgQj2HzFoHpFr2eCCO3oFAhRrUOYJAyAHgRN0MV0AI1w29ApJLPgcmD5yp/6nh14ajhZ8YJIJWYZZcWR8J1Jx9z4+KsFkNkom8+w7bq5rjHEh/eCKF0qIJ56/l4GxIDiUV2QqaaEFza2AUXLMEaZAJfnNbAu44uA5cfKVzTwc9nDLsBmkOgsnwApzuLME13U4C8mGlb5VJidQIImy+vRk8GTZvdbKCBYsxQDJ7INYZtTFsTYUJWV4rDvWLLrCmkmMDjh2Un+zyZ1eVZ1+gWyde7tzeXEOeqPYIBA6VSoaIUgPg3jgmkICwfCqIOqNInWM6T0Gk8RJxASlaThuN9yfcbpMBm0W5fkbc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sat, 27 Sep 2025 08:07:59 +0000 bugzilla-daemon@kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=220605
> 
>             Bug ID: 220605
>            Summary: Very slow access on HDD when a swap partition is used
>                     on this HDD on kernel 6.16
>            Product: Memory Management
>            Version: 2.5
>           Hardware: Intel
>                 OS: Linux
>             Status: NEW
>           Severity: high
>           Priority: P3
>          Component: Page Allocator
>           Assignee: akpm@linux-foundation.org
>           Reporter: pierre.juhen@orange.fr
>         Regression: No
> 
> Hello everybody,
> 
> I have a strange behavior on my system (Fedora 42 up to date => kernel 6.16.8).

You certainly do.  I wonder what we did to cause this.

I'll cc the MM development list.  Please prefer to report issues over
email this way - we don't use bugzilla and it's rather annoying that MM
bugzilla even exists.


> I have many disks but but my two swap partitions are on 2 HDD, sda and sdb,
> which are identical (SEAGATE Barracuda 2To). Swap partition on sda has a higher
> priority than the one on sdb.
> 
> I don't use zram.
> 
> When a swap partion is used, the disk on wich it seats is very slow.
> 
> $ sudo hdparm -t /dev/sda
> /dev/sda:
>  Timing buffered disk reads:  24 MB in  3.72 seconds =   6.46 MB/sec
> 
> $ sudo hdparm -t /dev/sdb
> /dev/sdb:
>  Timing buffered disk reads: 540 MB in  3.16 seconds = 170.85 MB/sec
> pierre@pierre:~$ 
> 
> Sometimes, speed gets down to less than 2 MB/s.
> 
> Lets turn swap off => swapoff -a 
> 
> $ sudo hdparm -t /dev/sdb
> /dev/sdb:
>  Timing buffered disk reads: 462 MB in  3.00 seconds = 153.75 MB/sec
> 
> $ sudo hdparm -t /dev/sda
> 
> /dev/sda:
>  Timing buffered disk reads: 474 MB in  3.00 seconds = 157.84 MB/sec
> pierre@pierre:~$ 
> 
> Now speed is normal.
> 
> Lets put swap on again => sudo swapon -a 
> 
> Speed is still normal :
> 
> $ sudo hdparm -t /dev/sda
> /dev/sda:
>  Timing buffered disk reads: 612 MB in  3.01 seconds = 203.56 MB/sec
> $ sudo hdparm -t /dev/sdb
> /dev/sdb:
>  Timing buffered disk reads: 570 MB in  3.00 seconds = 189.95 MB/sec
> pierre@pierre:~$ 
> 
> But swap is not used 
> 
> MiB Mem :  31952,0 total,  27091,7 free,   3057,6 used,   2343,0 buff/cache     
> MiB Swap:  36000,0 total,  36000,0 free,      0,0 used.  28894,4 avail Mem 
> 
> 
> So I suspect that, when the swap is used, there is some sort of lock that slows
> the whole disk that contains the swap partition that is being used.
> 
> Logically, the system becomes very slow.
> 
> There is nothing in the journal that seems related to this problem.
> 
> Since the virtual memory has been modified in 6.16, I suspect a nasty bug.
> 
> This affects 6.16.5 to 6.16.8.
> 
> This appeared "recently", probably with 6.16
> 
> Thanks,
> 
> Regards,
> 
> Pierre
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are the assignee for the bug.

