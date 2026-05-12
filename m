Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECD32CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:05:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694616B0095; Tue, 12 May 2026 17:05:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66A156B0096; Tue, 12 May 2026 17:05:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498116B0098; Tue, 12 May 2026 17:05:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 386B86B0095
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:05:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95D461C01E5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:36 +0000 (UTC)
X-FDA: 84759999072.29.2103A83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id D3ED0100016
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CsQIoHEB;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juESCD15BnOKrr6EkQ7tkoqdE6TVo1zPSi6TDotEUqU=;
	b=fo6Iq6z/fq8FolF3rTrJLfE/ibyX6X5JRcrn1I1YjJsEKlPWwmLgluKFqcOgdrxRhEPBFw
	V5M9mnKDWF55hQ7I76yN6fEk+ZnfRc2hbE2731UwCDmQE7za3kVWKxr4Dj2TG+t9phVz9k
	VQh5/QzXTDE5p8ZAHmfHLyDCjVp4K9I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619935; a=rsa-sha256;
	cv=none;
	b=75q51Yk7THd1PqSZx1uv3wPDhhWNKR2fSMzt+YVW8JfvfgJedZa0n2s6N2MUjzh/qj3q5u
	DfeUhavKYw3lclW7NZ4SVmYaGhIOJAXL5TrXQa1PVWJGkgHf+WZKa8djrobLP9/4ueGSwS
	X0YspqMIynO1LtgmxEqnCkbP8kBNo4w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CsQIoHEB;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2762D60120;
	Tue, 12 May 2026 21:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508B2C2BCC7;
	Tue, 12 May 2026 21:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778619934;
	bh=mo6e8Tl7INL5treUcIkpAfOY+0nT4RQkp/YxRTbOF7A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CsQIoHEB8oaEHcAMFfdBryz0a1eiebYrMmN+ZI44OCVnR6E+YcN/oFEnuMH+jF8mL
	 +Edt3gUZ7QqMMLtvW3HlcoJSiNJNWZv+LWR2rt0xoSG0CV1D7QQvsc3ETwZmvXUkqm
	 3q3WEw97mCEI6T1eJBIQMdOn0NalAzj1VojejrbI=
Date: Tue, 12 May 2026 14:05:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Stanislaw Gruszka
 <stf_xl@wp.pl>, Alexander Potapenko <glider@google.com>, Marco Elver
 <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Allison Henderson
 <allison.henderson@oracle.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
 <linux-wireless@vger.kernel.org>, <kasan-dev@googlegroups.com>,
 <linux-mm@kvack.org>, <netdev@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, <rds-devel@oss.oracle.com>
Subject: Re: [PATCH v2 0/4] treewide: fixup gfp_t printks
Message-Id: <20260512140532.f16379be75ab006f2cca4747@linux-foundation.org>
In-Reply-To: <DIGPS83BGEGA.5I7VLH8TV7XE@google.com>
References: <20260326-gfp64-v2-0-d916021cecdf@google.com>
	<DIGPS83BGEGA.5I7VLH8TV7XE@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D3ED0100016
X-Stat-Signature: e3me3xtkadfgac8csekni3qgu6pr4id5
X-Rspam-User: 
X-HE-Tag: 1778619934-36809
X-HE-Meta: U2FsdGVkX1+v+02KOhySVp0gkEzvT4cJS791IPHbCK3barwnYKcMfAO+ddhQnPzDt8VqlTnHuCXYTfGM/JzbJ8AecrqVRfAj4OW8qHfVRy7IrmI87HN3IfY+lTQV6pSY1z3jyOvsMXMWQDoNPKLMpJHKFipJQkjgOwmlUaXPOOltX5TSGhgQR74X8SqiBiPhgguyLiRDPc7PFgDAJ4dx8REwv32LwfZTs1yxnhP0wGP5IYnWGMQmRQHyKcq1vOJkcsKkZQqyXa2YDD6+lT+PzTfmLS8P/Nqt9lwk5qZ0fhaOF8TaisYmMkkkvA9Y/EXTNTIz5/hAq0TTwLSL/qk6KyPfQehjUmrJEoyhQDSApNdsm9xKFtTmcwaPSzrG7Rk/4ehAZi799E8XdAtWHuGRYR6iC2e7Jf6lvnkVvh3PFAmwRlAfr/TETNMrl/IQkpDh/xTgNIhUmVJpuIzKBMGqxY4/ErF85mCNcyufFFNNoqr5DbNqsi3dxoK/PCjlswaE9/SfyFLOup3v2pnfNrUUYJkEQJYrNrkRdUZ7Lry2DVxuKXMJ6QHKlMW1eKeY7P4EM2T2m1yDV8k1a1UMw8YT4PnP0uSG37+15HowBz964RO99lKDcemRZ3JWtDzY8uV4QvBqtN6bViAwKIJ3GzQj0xNf346vlYbYI6J811d0cr3PWO4FwFQMp8b5HbEZyuhDJY7/5qXT3VNMTy6BYZL+WaNVXrwLb9GYhqWa+Sck8mX9kSDhoH9Lc2ICWpb2fQ/92CfqdasXDLEaTIR1cOqxYv6EGRWWvX9gsIVxU13jKwSPiE6HnK4XdporOj2Wq7JEN0bKA2I/txnPC4/kmeeDinmnstcJE0QprFRJl4CQTM4tWZzhzvqkkvOR3zDk75zMU2/qsYTktoydIMMtl1RWdyH7pZJvrXmICeg4n7ZLNcl3LvFbZMnEIBWeSMD1oeLPDdlLNiPcDLSQuGfzJGf
 EQgN/04q
 SFhF/6VyLL36eQpxJpLYrRcIX50EIRy+GhjdrS4JsOrrg5whdUqNxG2yPh1Pu0vuCdCFlPsUKlfqnyfnK7uiC8s4qqIFzR0rOLjPi7BrzhQIqEinqc910QKKM6Wbaz2AasxjCQwii5gRijIUC2IS3dxxz+SVMRuBP5GP9B/nPVHipUVU8jWUaYd13IIiOZ73ZBPrtT3+1qecOb1OZty/XLXWQdOl2mRx59V4u8p1ee0TrwgFIIGbBWHzRyVdUeZ8YarAQyCWzx+a+c0+3zLOV7bU83RS5J8bZhbNtYxaiEJpI8LtYG/gIxTyz+6GBtyKb31q/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 12:58:20 +0000 Brendan Jackman <jackmanb@google.com> wrote:

> On Thu Mar 26, 2026 at 12:31 PM UTC, Brendan Jackman wrote:
> > This patchset used to be about switching gfp_t to unsigned long. That is
> > probably not gonna happen any more but while writing it I found these
> > cleanups that seem worthwhile regardless.
> >
> 
> ...
>
> Any chance someone can take these?

[2/4] is merged into the wireless tree (I assume) and the other three
are in mm.git's mm-unstable branch.


