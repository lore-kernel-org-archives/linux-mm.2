Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D09606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nbh2KEED
Received: by kanga.kvack.org (Postfix)
	id C30D76B00EF; Tue,  3 Nov 2026 03:54:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE1C16B05B1; Tue,  3 Nov 2026 03:54:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E7E6B05B2; Tue,  3 Nov 2026 03:54:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E2D06B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:54:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E524F1A033D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:54:47 +0000 (UTC)
X-FDA: 85393197414.09.63F26F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7C45320009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:54:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nbh2KEED;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793696086;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noKBATG2MCO2VddT070pD71T8H5et8cXNeowJimnxp0=;
	b=6lr6P4BIaH6sGTQa1zNSTp2jGnINmF1SsOa3dy0jfnWX1Nak1/ZwSlpEDWu06/VV1gRags
	JphnufR7Sy01c42XqIruaZA6BjlFnp37VnNfIPtYJePdi8UnuC8czHji7R73fE4WA2zoTH
	ISUzxhNRIEd3GPQVEW7avfYp2RZyExw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nbh2KEED;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793696086;
	b=WkNRldaawlvOVYm2EEY8ysONcuodahKO/8S6YQK+vLLm23dg6kTncMZRo8VfkNhuJle5aE
	TFx3c8W141GkvtZoQam3u4jfkX+BM8Y7F/VyTJLqdid0y95PtoqHfA6Mxf1hh1W44ML8ON
	kFbwABGkSjemGvG66lJcW9AhfxR3NI4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D287F6022C;
	Tue,  3 Nov 2026 08:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9CD1F000C1;
	Tue,  3 Nov 2026 08:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793696085;
	bh=noKBATG2MCO2VddT070pD71T8H5et8cXNeowJimnxp0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nbh2KEEDrQB39BytyQ3XzNR5R/8IpsHGDu1YlpfabZIB8cuFobAcuel1xdtT8ErkF
	 JaroDmAK8dJkWCziCQfyrhU+SXL1rYDEnfSy4/yWgek1U9a8iWMLRF1y0WYXciaITr
	 OGGgHc0uFKbQ3GYRH8eYxkRL8xwsYW95LrU7PXwD4ES5+0xhU45ZP0JqM1OjiZRJWI
	 6k3LhimrTqiKkkWhpHloWvvHrtg1zfiOBK2Bpf7CyD7DABP5fFEbHryiJVBOex0gh2
	 6+A7a9ybDjI8l7Q08upmYsqO5u6OVBNfGMbvGUtXdRjNAZYaM5UzUQ1VVG4euxP15m
	 7Kx+DNsEBElDg==
Message-ID: <sashiko-outbox-194896@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] tools/mm/thpmaps: handle carriage returns and non-UTF-8
 filenames
Reply-To: sashiko-reviews@lists.linux.dev
To: "Weilin Tong" <tongweilin@linux.alibaba.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Ryan
 Roberts" <ryan.roberts@arm.com>
Cc: "David Hildenbrand" <david@kernel.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org
In-Reply-To: <20261102085419.696232-1-tongweilin@linux.alibaba.com>
References: <20261101211644.c63a2028bbede0f763f41f80@linux-foundation.org>
 <20261102085419.696232-1-tongweilin@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:54:44 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7C45320009
X-Stat-Signature: 87bix4misrka3s5p6jfgdx87t16dwk5z
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793696087-91823
X-HE-Meta: U2FsdGVkX1/GAMsVWMgMb04a9Jlmifq/RzdyLMC8jFOI1vXShZ9nT/OLy+vKxJN+XK0wXBRdh1GOfd+llqOgsbKPKlQ5x6C0T2FqYzRkgEzOP2qSbIJLYkAK32ucNZ0moRLPi9DR/Zyr7suOsDoabauqSBh89geQrWYcXwArkvwr1m0+rvJW/Xt+Lvd4xVo5yUJTA5h25IvD3vwpvJYK1TJRwi7i5nT/JDF/ItMFYa7mB17Yb8NhHMw+y4t2prVS/nY88VSAweSMla/b/w6cSLxYtjnJk2h1gHC2y0J3FNi3yPE0W19DQoyHK/v11fNE82qFuvCNVJrSIp366kp+LnfmoJEq6IbvZPzRkrDWtQla3qxebdU6rKizkCMY0u6dlh6E9h9BatNvlqFFXg9B0fZr8DZdb113RXmhUPcaVxZqwWdM4DrWlp+YFULA0mExZsrKZq/Xp/56WJ/Fox7Xd7tWwaXrgG9M2zVgMEu8gY0GYZQjAPEfmSToLrv6lvFzJH9ONTG7hQSplmnyhcocxXJzMYyUEj3iZSMiCpAZgtezKaOtaQn2LFEgam3eCzqjjW92MKS/a1J/Y+VVjotCqRyphTdqGDuxCMkufE+0AUzqWGpkykn3rs5AWrWtPnHInYOCt3PI0YpMg7x5MbTls2x83lDJTtCDgtSYSceX7FIUgpCFR+5UriN59+IkrG4a9xRzfM8rbtYj4/o0+5AnFCQivFmMquHYRthhEoQt8YCWu+Wup2oa1/vHM6FEUd55OvkQDKWRNwuVMdk9513OgldMCoJBtVHhNKPeioqSSsI3lyGtWaMbNmYIpofnHw+ebniqHMGfz5Dkn1dhUwJpkaeaSnsI8D5yIZrcpp7UE94kBIYQvV1xpCi+qUJDzUjmBewwfftI/UPQG1na2SBhHQWFgZp1TgTkcORyst3nKkLZQ5KRZc0FC9/GUUbSKZknZPrX6LYFKyNGspxDKnj
 xYbcdMFK
 CMoYbVoyazyNciuqrvVG8ktnK/2Y/2atjd3frV7X/QlhEeH5HO92h5WtgT+h0pHkimB2j7WYH94xtiMjoBg4nNuKKk8UPSYmu3tNVn5Q60O9AZFncwa+9BI1XK8LUojj1QgF/SqoJFPDSL2WroTYk9MzcUWRZ6TkSid1xit8EylHTkj8aS2Q6Lmh94HPOvE3yG6yAHdj0YZQCak28ifdZGYRb/HY66+AiojtHDcdhttk4Bvugbv4gr9BZmHNef8TVvy9VnFfP3k2siHfAp0P5PcCSWoA5B9Iy6WvyHavsAX89iIIdehXccnI50R0ntYV5HvaJVlYiMnFnS7Oa6o2IGcEVrOnfIHISxO6p1RP6Sk8ot6BaIgN604v+uPaA9xjtQnLW3SYm9ESKmoQadziLvbQXpajARhmDbzVZKZJK1T9oNDNUy3x1ZrIK85Z/rTr8v21wy4eTnasbmxO7wt6UvvEXzNIjDDvn7/lP2deN76/18tO0LtBGc0tmQJa3zJ4vrfQXqDzrtza00E44UCsUv11jDXR54aQXACweWv6v8mkrdiLG4u9IUriwdbXao4NNh6lRCN8yrVgMpvIXck0S+UKYSQ2mg3wa95ENgbfLOuz+XzA8xmTOQRTpefI5zKgEp4YZTo47qGongrB2S6nQ+9/4jVo1E0OkB2em
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] tools/mm/thpmaps: UnicodeEncodeError in vma_print() on non-UTF-8=
 filenames
--

commit 5f793a93e6fde4bbef2fd7ad6b6bda119aa8b288
Author: Weilin Tong <tongweilin@linux.alibaba.com>

tools/mm/thpmaps: handle carriage returns and non-UTF-8 filenames

This commit updates VMAList.__init__() in tools/mm/thpmaps to open
/proc/<pid>/smaps with newline=3D'\n' and errors=3D'surrogateescape' so that
carriage returns in mapped filenames do not split header lines and
non-UTF-8 bytes do not raise UnicodeDecodeError while reading.

Link: https://lore.kernel.org/linux-mm/20261101211644.c63a2028bbede0f763f41=
f80@linux-foundation.org/

> diff --git a/tools/mm/thpmaps b/tools/mm/thpmaps
> index a1a9bc30514f3..f89568bd499ec 100644
> --- a/tools/mm/thpmaps
> +++ b/tools/mm/thpmaps
> @@ -196,7 +196,8 @@ class VMAList:
>      # instance to receive VMAs.
>      def __init__(self, pid=3D'self', stats=3D[]):
>          self.vmas =3D []
> -        with open(f'/proc/{pid}/smaps', 'r') as file:
> +        with open(f'/proc/{pid}/smaps', 'r', newline=3D'\n',
> +                  errors=3D'surrogateescape') as file:

[Severity: Medium]
When VMAList.__init__() opens /proc/<pid>/smaps with
errors=3D'surrogateescape', non-UTF-8 bytes in a mapped filename are decoded
into lone surrogate code points in vma.name.

In default (non-rollup) mode, do_main() passes each VMA to vma_print():

tools/mm/thpmaps:do_main() {
    ...
                        if args.rollup:
                            ...
                        else:
                            vma_print(vma, pid)
                            stats_print(stats, vma_anon, vma_file, args.inc=
_empty)
        except (FileNotFoundError, ProcessLookupError, FileIOException):
    ...
}

And vma_print() writes vma.name directly to sys.stdout via print():

tools/mm/thpmaps:vma_print() {
    print("{:010d}: {:016x}-{:016x} {}{}{}{} {:08x} {:02x}:{:02x} {:08x} {}"
        .format(
            pid, vma.start, vma.end,
            'r' if vma.read else '-', 'w' if vma.write else '-',
            'x' if vma.execute else '-', 'p' if vma.private else 's',
            vma.pgoff, vma.major, vma.minor, vma.inode, vma.name
        ))
}

Under standard UTF-8 locales, sys.stdout uses errors=3D'strict' by default,
which rejects lone surrogates. Doesn't printing a VMA with non-UTF-8
filename bytes in vma_print() still terminate the script with an uncaught
UnicodeEncodeError unless sys.stdout is also reconfigured (for example with
errors=3D'surrogateescape' or errors=3D'backslashreplace') or vma.name is
sanitized before printing?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102085419.6962=
32-1-tongweilin@linux.alibaba.com?part=3D1

