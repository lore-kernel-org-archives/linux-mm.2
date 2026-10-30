Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52281606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 03:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=zdj2gBbg
Received: by kanga.kvack.org (Postfix)
	id 73A226B05B6; Thu, 29 Oct 2026 23:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 712C16B05B7; Thu, 29 Oct 2026 23:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627E86B05B8; Thu, 29 Oct 2026 23:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 400D46B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:02:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B518D1A05EE
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:02:08 +0000 (UTC)
X-FDA: 85377793536.21.7D5BD3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C75F220003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:02:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zdj2gBbg;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793329327;
	b=E/fNdQv2kCj1ggMX2MlvXQNcvEFNrzHyWtfks+FLwZliBFcK5n+5yZ+ItPFuvJ8HcuMUqa
	OYxseFI7jE1hy0BwNsD6sacVDnRmqGB0DG8XkvrBO7PkTNLRBkzGqVmUR6jMoEsEjgMGKY
	IwoYYh1og4QFotfn+7wihefsIPnR8oM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=zdj2gBbg;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793329327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qyPBZSpQjOcOhJDdOO7H9HvPVzvgTK2UU66TCKWXkQw=;
	b=AkN4p0s1lZnfvYD2IXzKEIiIRJgysl/n8xLjlSX79+3uxXacyauuWAo4xXtONAHK+AcSRP
	ByNcRvHSjrdNV6UuN3m9rfGv2OVU+aOnYf2riIjz7LodTStQPdqv5tN6czO8fA/cmWt8cH
	A0LZlXJkQwh+i7pzvDD+752OuPlcW9o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19A204386C;
	Fri, 30 Oct 2026 03:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EB71F000C1;
	Fri, 30 Oct 2026 03:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793329326;
	bh=qyPBZSpQjOcOhJDdOO7H9HvPVzvgTK2UU66TCKWXkQw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=zdj2gBbgAeReQfQjHbzuJ2hwH63lWKUM1c+KbxLLeEGWR2HOmjFYCMF0vXph8C5tO
	 5e5h7NSPT4i09TJ14R00Ciyd9pYL0RIuLhuR+M1Pq1pJijuTHuYivUwu8GN4GDwVpv
	 uMZCL8Atee0JiF1xV9AfslSy3V7BCAXlWy727VTY=
Date: Thu, 29 Oct 2026 20:02:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>, Barry Song <baohua@kernel.org>, Bo
 Zhang <zhangbo0325@gmail.com>, Minchan Kim <minchan@kernel.org>, Richard
 Chang <richardycc@google.com>, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 00/15] zram: redesign zcomp and rework backends
Message-Id: <20261029200205.ee2a4788b8fdba4a75c2edd9@linux-foundation.org>
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s8guz1ohquubfb1mdgx4d3h5t94d3jaz
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C75F220003
X-Rspam-User: 
X-HE-Tag: 1793329327-755139
X-HE-Meta: U2FsdGVkX19/jF80PWHA2/tnm0kNLi4KFVMijZHhs4CoEVsqfRSg/RgsAxdOpLCi9bcF3KK962fW74Ck5w9YCawr5U+nKzwzVnSpVEa61CP9XjqtPAuyl1M2d/9Zo6dvutcHONZhXw4det9qoLHNznFx+guzss40IVlkfGyhuyPex5b6RAK8Wk/Gxkiz9V21KvQmSbfiB/4jAibIjIFhAlPpMRIT/edIqL3/Li4aWTqtEfmYxHQsN0lfXLtJoGWNdbi9qCFRdaCJCg4AOEBeBgzSxC9IRs7kces/CeU6MBaEfzc5KwjjX31BsG52y/+Y4tGBD83JStMghoqqgrji1h5SW/P7IG9OJrrUKXJ1iNJeRSaifDuxteFC+LQRxkOFVCS8bNiF2xUmQqxvUmE7J+ukDDLE7x68HL+FPAFjjZaFD1Mp5CVc/bJmQfDP3uIUILbtDyQpxOR9bxK/70byc0Kd67Gga/0ShSUQWvG7yq+n0R2NE7vDLPbmJ8pW/gj9Pj9nbOmpuOVDHtzATgmxAJXtSnWKk4eOEU5LizQJ4FTTDpFtGjouS76ANFv7UtnE6/QFudAny8jV/1IMDB3+uahNk+zRd5jlJ/kqSVPTmGxsqoAlczorZ42i58McHM8JVJVknhX8Pt/9zRoF3XptSM+iesYDgGdhtGrjEotd4ohLOmBVCcCn+2PPGIJhrwgKPs+WrbUNlAaPJfgtHkxjlaIiFxr84bCKujWad2G+E2j/RVO9kLaQSQuyPxNH+lTDue7jQR+UtB5BNknKWVOURwMzuS1BZ1lIrbOj3wokr2wSWmDzuIlOEo7dxwJ4q8WHOIctQX4ZTVAKHInEcbcmg7VREuiQCEySUBQOItFUa9UL+EqZIGp1gSpkNa9ukVWSKH2+GI4+BWYv7kn0DSrQUAzH4ngdpCeK0NtjWPj/A++xB3Z+iRgt1lGVU0Nsm6jxPyNuc6ubohgwVmmvnDu
 Ke2MkjVj
 VGn8ckNRoreAvwqBFUou8280kWqzH19CKA5yPkLyHD9UUiIBXgS5uUcZ1l8uyTrxZ0GhAEU1N3aCAd1s1FfFmFCUE5nrm44GyZR1t7UCjwXg4EYV62YGsX6wW1OPfYmx/Vzi2RarMyJsuPXpprg+5W2Qx6U1I/G8Hzm9PKoH6U6kIcJrLk5F4H7IXnZkaYwigRZ5qjIdRqFebYsF8ERTOrUjG/+jgw0a6pve+j+4itC/14SGbLs724L7F6h5mdFHFFkBpTC4FXxNWypbYsGJpZ+tS+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 25 Oct 2026 11:18:16 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> The series has a number of memory usage optimisations and fixes
> that result in savings from double digits KB to triple digits
> KB per-context/per-CPU, depending on backend and its configuration.
> More details are in the corresponding commit messages.

Thanks, I'll queue this.

>  drivers/block/zram/backend_842.c     |   6 +-
>  drivers/block/zram/backend_deflate.c |  98 +++++----
>  drivers/block/zram/backend_lz4.c     |  85 ++------
>  drivers/block/zram/backend_lz4hc.c   | 105 ++++------
>  drivers/block/zram/backend_lzo.c     |   6 +-
>  drivers/block/zram/backend_lzorle.c  |   6 +-
>  drivers/block/zram/backend_zstd.c    | 133 +++++++-----
>  drivers/block/zram/zcomp.c           | 298 +++++++++++++++++++++++----
>  drivers/block/zram/zcomp.h           |  53 ++++-
>  drivers/block/zram/zram_drv.c        |  71 ++++---
>  10 files changed, 546 insertions(+), 315 deletions(-)

I've always put zram material into mm.git's mm-unstable/mm-stable branch. 
Because "ram", I guess.

But it's a blockdev, so I'll henceforth carry it in mm.git's
mm-nonmm-unstable/mm-nonmm-stable branches.


