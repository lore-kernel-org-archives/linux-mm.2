Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DD97D47CD6
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 11:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116536B00A0; Fri, 16 Jan 2026 06:26:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9D96B00A1; Fri, 16 Jan 2026 06:26:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32996B00A2; Fri, 16 Jan 2026 06:26:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E53C96B00A0
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:26:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AFDA916064B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:26:20 +0000 (UTC)
X-FDA: 84337598520.24.6E8A8C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1696C140007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:26:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qatyKed+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768562779; a=rsa-sha256;
	cv=none;
	b=uxn7xSITmCRhIWYaj+2XIblmhWoAsyEdut999mVW4VHJXkc7MZVmkRXuXYrTfz1yWbAXa/
	Ku2OMHzDtvMyhUF+oydkBkcpHhKQiZtlxKKt2/w6YMavEoGa6yreHl87EkFgsv0p7umhaL
	Nq9mLgMAiG0YVszoqejI5gg+84ozA3c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qatyKed+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768562779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M8l8yQ1a1bc/fwaoSp2e3qvRZNmODQV9wC8HwAyH/4w=;
	b=lJV1Z3/GSy8qpwnfGdepjCaVl6aYllbAkKJ0sy4h0vL45KuNAcJXIHJMfIAYysnH/YX0jl
	G0hfrsNnsAN1yDkcqYMFctaVzxvhNzY/eI5VvX99kAP7Qlax5vLsSqgaOdC4i1ni4ni07Q
	ZD/lBdLCNAoWO+/a+5FdyEehFCuCvbM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F51360160;
	Fri, 16 Jan 2026 11:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D04C116C6;
	Fri, 16 Jan 2026 11:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768562778;
	bh=M8l8yQ1a1bc/fwaoSp2e3qvRZNmODQV9wC8HwAyH/4w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=qatyKed+jzn2XWTT5PwsqhL5qmW8FWQKcnDchvZoJz7PXwHpzwxDI1r2qqb0phTxf
	 gzHhpCEQ7v6u9hS5bGYTABUudcGFp2T75kCUOXyNHjwfd5JVQkHJLZwAbUbiDB9fra
	 EiOJoB1KL8EojWhqu5AIwMOCqPLPWKWG8CReGbDoTs0YlzKEL6MhprXN7nGPnjexD7
	 ZSzI92fK/fccpZgDAUkzbIhc7niKmjyS9qm0GxLPGDehJpU957IXDN6CoMgKoVYB1v
	 yss4uYImD05mEaKDMLMOlEPrAR3pRuFHLOCHaqcQMboojNxzWAn2p9AKjipW8N1L2k
	 E9kKEhJlTnH3g==
From: Pratyush Yadav <pratyush@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  ranxiaokai627@163.com,
  graf@amazon.com,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  akpm@linux-foundation.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2] kho: init alloc tags when restoring pages from
 reserved memory
In-Reply-To: <CAJuCfpE3ffje9qXdwB3QZsyE+rD-unChSNXPfrijSkk5Nrt5CQ@mail.gmail.com>
	(Suren Baghdasaryan's message of "Wed, 14 Jan 2026 14:03:30 -0800")
References: <20260113033403.161869-1-ranxiaokai627@163.com>
	<2vxztswoi16k.fsf@kernel.org>
	<CAJuCfpEwa=_fubhf5wBnFKrKpOgjyXRy94f2BDx38x_NALE_OQ@mail.gmail.com>
	<2vxzpl7chw8d.fsf@kernel.org>
	<CAJuCfpE3ffje9qXdwB3QZsyE+rD-unChSNXPfrijSkk5Nrt5CQ@mail.gmail.com>
Date: Fri, 16 Jan 2026 11:26:14 +0000
Message-ID: <2vxzwm1h7q95.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: yzffocdfk9tk3wzh99n13wfxjze5rudn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1696C140007
X-HE-Tag: 1768562778-958345
X-HE-Meta: U2FsdGVkX196Q3uKRDqLb3C/jfkV1LjgB+CyK/LrgQIKrbkU3YAiVYfpHfkuUM3s/2kkb7k8vlgsMvSP6Fn0pf29Or7RnpgaTuPnqLPxtlYVgpLNIXUZ2+4WlZ/OwzTY7arLT9U9Plw8sg8zkYgq1QYPqPs51hgXe4L+ZmajjRsOpGs+07u3Nra5edh0qQwV4hZIqb/zADfHtKdwiDpRMf1YsQBwjza+cBnZ0GWLEM+NPuv4o655WYLH9ksI/M4e3d7rnpJfzvV8OHjq+7ssQPMCzRpaBZm1CQ6cfzvYcD+QdLTAKJ9XFjubaPPzNQVFglTGsJATVzeRJdxRCxATgEAp5Xs5eIXtCW536rUoy7nBa3rB9NlFNqqz+SpK6G9jgYLUvT3C3WjIVtpToWS3IS+UT1hmvqtHdCziaWvjcYzScQmDRmtqrX8jaKZJqsrESHg218kbDpiV1rjzqJ05xlIQfBYRsCwo61L18Kbi9xaNhEwXkNPdBCZJWQbz25oVtYsX+NSIB1do8pbxduQDjwPXT6zfuxDip6vABf1bP4GVWIqXJo0zeCWds3GF0kdXiWnXc5NaL3jAocFqibD/XwtEg7S82hQb/usXA/ACEt4WxvpVNDt0xMXZlwTB2Woq6OK6uX4tqZjwZHEgVuyaRbnIjoGJzkJdMd67iRjTAzIdzo7ivk1UvQhBBrcGr2q2Qv5d+28bY9urd4IKXckVClM14Phm1c5bVlhMVLiLGMsqAZJJQtRYOktJ0OZniiavs4a8k8LFApm9ULvQjqhKzJ12JN+8pM6x1ZZwqeD2h0Twcp5MzrLM5pZgYMAozETdqMfVI8LPeW3K5yxz2O5v3uODLx/MosCjO4EkSUXGbBMoEr09aMwnVFyUimnim/gNyM/vcTOtXb/PT0wk8Ki/spyZJk0AxvW2OL0p3ckdLwUiraW5QR8Ta8557a8BVSodS3yYBLPjB2tCZZF0WhV
 +ebrt3im
 4xB7H3mTbqchjDJHd86z81efYWfXAb3+t2PZuCQa8I/Dp270tcaXMauqTVLXCiJwoijl1yaN/VDxE2VFWZPEfOIbeNbDZw0ZJWjab1evITu/4nyNoijy5byUgDEeGw+CvUC4vxOzfDflt7owrngJ1QIY6SvOU+IHdZqDKrbESYSc4TDv/s1eBmRxllfD5o7MmAJVdeYD/2DLa0vJErWVnTmiRUXssSBByzk4ZzS9jYVW87pDpwXU7GZQdiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14 2026, Suren Baghdasaryan wrote:

> On Wed, Jan 14, 2026 at 10:42=E2=80=AFAM Pratyush Yadav <pratyush@kernel.=
org> wrote:
>>
>> On Wed, Jan 14 2026, Suren Baghdasaryan wrote:
[...]
>> So I think you do need to initialize the tags for kho_restore_pages().
>>
>> I sent a patch [0] simplifying the page init logic a bit. I need to do a
>> v2 but it is a very simple change so I can get that done tomorrow. I
>> think it would be good to base your series on that since that would make
>> it easier for you to modify only the kho_restore_pages() path and the
>> end result would be cleaner.
>>
>> [0] https://lore.kernel.org/linux-mm/20251223104448.195589-1-pratyush@ke=
rnel.org/
>
> Ok, let's wait for your patch to see the final result. Please CC us
> when you send it.

I sent it out just now:
https://lore.kernel.org/linux-mm/20260116112217.915803-1-pratyush@kernel.or=
g/T/#u

Feel free to use it as the base. Once Andrew picks it up, it should show
up in mm-nonmm-unstable too.

[...]

--=20
Regards,
Pratyush Yadav

