Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A124110F92EB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6C06B0096; Tue, 31 Mar 2026 15:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAEDB6B0098; Tue, 31 Mar 2026 15:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC0F6B0099; Tue, 31 Mar 2026 15:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC4DD6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:22:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 67B5DC3D07
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:22:29 +0000 (UTC)
X-FDA: 84607329618.29.476E52D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CD161180009
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:22:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gcbU/Z1m";
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774984947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+A1It6MVw2bJOkC1VLAvKTjq+fTDHZYgBEyBXWgpHOw=;
	b=NQti4hV5NmTCIBT7q8uaUw6YbIVoaEnqQnG3unQysBNLV3icrGIwMtOI5VnnChLLCAl9Ij
	8m89j5c5qSIqup0EsRyqhzP5AeuKdBb8GMURT74e8he82IaT4gGY7lDiMn369ZmjAFe19H
	h0oDEz77KEZY53PzBQgbeenmxAYibZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774984947; a=rsa-sha256;
	cv=none;
	b=S3qqbpP/P2EFVS714D+xqhkM2IPxyANE+7006CVy5PXxt/hp58xGFIJX+lTh/zqUByLPKg
	ugpN23lUC4Cp9DtnSDnsRmb5Tll9K6TmASFeY2uQFQVWGsjv1iu+B8+ZNn2DifFkMy6iKM
	mDFjKitBpcGcLsQ8o6cW41kdRQfCSaE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="gcbU/Z1m";
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B58C6013C;
	Tue, 31 Mar 2026 19:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E981C19423;
	Tue, 31 Mar 2026 19:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774984946;
	bh=NtJAEnQasgoVLEwwLKfhue0JsEEDLd5R00KCgN7cw0A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gcbU/Z1m/yB1XtkHD2LSFGULkoFEoe3dUhITr7wVVwAdkQYpd6dINPpe8Yc9jOU9x
	 unRVg8KWYX8VQQnQ/joChCQqQztIePJPisfL1DDj62nKyX4JIxcJ9vJiK+kqpifmNX
	 6mTlncZH03LT71ndzNMc8F95zA8RM0D2zCf4l+8WUeGYDBORH5CCHWqV8mKKZzns11
	 UrdbVhjhSivOl8DtYmbDL/EHYGt7fk2heDrAXtQQfiuXXfwlBVf4Nku5ycP20BvcED
	 3PJTXaMiZzJ0TqXgUWfUktP/aGTc9ucp9o6vApE7R0gabvpoiEhKs6Hyw2MkumK7lx
	 /gEho0SUT+2oA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  rppt@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  dmatlack@google.com,  skhawaja@google.com
Subject: Re: [PATCH v3 02/10] liveupdate: Synchronize lazy initialization of
 FLB private state
In-Reply-To: <CA+CK2bDFidSZQ+UevEXPgfF2BWkN1AWkb2iRWGxUNV2iLpJGXA@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 31 Mar 2026 12:41:54 -0400")
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
	<20260327033335.696621-3-pasha.tatashin@soleen.com>
	<2vxzecl0i8rv.fsf@kernel.org>
	<CA+CK2bDFidSZQ+UevEXPgfF2BWkN1AWkb2iRWGxUNV2iLpJGXA@mail.gmail.com>
Date: Tue, 31 Mar 2026 19:22:23 +0000
Message-ID: <2vxz1pgziz2o.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 35szcd7d1u5dctyd4ijmt4btf9rn6zhh
X-Rspamd-Queue-Id: CD161180009
X-Rspam-User: 
X-HE-Tag: 1774984947-883863
X-HE-Meta: U2FsdGVkX1/6AJq9o9pL6jod2Eb/xkk1L95ti5WwLeQYYMREHzPdnU59a8MGGPvgeKvL8T9HtuSVn7FrRkxG5VmYRV+EfSzLl6Hba/RUBwCBEoF3WVr0V0P0ny4FsmasoQWkhJgLoNDXm/Thnuhi3QDpmzAnyqQJBQ4wdMgrDNpW2dRHU0S1dNSJKaijFy2K6ewyCPB1fglP3fGbOJH6qTRh/k4xfBDY74wD3JvRP3io37fsp7F03Xsr65lvtXmIqKw8LE3D7cozQFIYNPM9/FfNMqcbCJsozaKjuWY9MtS/CShetb0+PZ1ZE+RymQ000hWD0AsiLPDm1oiZ7rYB+2/ZYFlkxmzb9B4a3PsCieECsmB0vStqSwkfOuMeP/Z7bsqmght+fixHsBHzwsAiQBm2XnC54WNLF0FLwnkRsjO4/kuPp18u5M2uZMFTk01YfFbcqsV85fW6nvgebErkLK/d8YCtKLr9e2Shr0psuzz9fhI0BGR/TF5Jg39AFp+RR4GjSmY8ckUwQrFf/UjmiViTs1MIJRDeDBAtblzhy7/OxfwX98y8NxkVbmpfsIAOr3zB6cINUIWxxNwup6k/7acWu4HYKLI/vE4KjwZ0RDn+PNJA7/zboqiVo+slwJmp4eky2Fzt1Zo/QhsS4MdMFTzuJviKKv1vAIG7lzuDAjCX0ceMrqnWpVVasnQlw3OwtjK2+oA6cs4u70cUMxKH/qj3HPq79bkIxAg4Cv6w+5W+aiymU8VdD/BQoTlhhrKF+TNrQKUttzkkCq9Oaj5uqGkySqY3YvA7z03YhKcrgGNGptNdWYbvvkbz+B+o5euku2MwXEU21Bz+RiMFVK98AE4i1pcS1RQFkqizl82rREdOcw6KDG41rPdi8Ru2ryWo43IGLIgCT/wqkWy9I2Yhn7WfaBezOfI+5/vjuzmNVDRUV3UM4RJsUJfRl16krpQ0tkxZBT+ogRhjQGQDQt3
 yV494r+b
 U74rLuXa0GSlv8sprpA0m/1I0Jlbb/etx6NxzwJ4T8GO3zkvQgxSHuWmXmzckZ1FwXtBHgRnrTjpTVVa8K3u7+bDplAc8SUcKyWY/irlLV9MCKu/F5mpO+H+ah2DD7FWQwuxKim2tpzhTZTIJ8f82jQWPMxI4gQ4y8xbuGwBff7oml2iWM+3MLnwGTiJQBdAj4jHlNZB2dxOq1M1nIHNdJJjdkQX0R5/QaZau7KynGWY4aoKo9t2osrjFGXuu2qtsnhdOlwKM7R3syCcS8r/t18l7d6qFcoicnIBVcAJ4wXF6aUk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31 2026, Pasha Tatashin wrote:

> On Tue, Mar 31, 2026 at 6:38=E2=80=AFAM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
>>
>> On Fri, Mar 27 2026, Pasha Tatashin wrote:
>>
>> > The luo_flb_get_private() function, which is responsible for lazily
>> > initializing the private state of FLB objects, can be called
>> > concurrently from multiple threads. This creates a data
>> > race on the 'initialized' flag and can lead to multiple executions of
>> > mutex_init() and INIT_LIST_HEAD() on the same memory.
>> >
>> > Introduce a static spinlock (luo_flb_init_lock) local to the function
>> > to synchronize the initialization path. Use smp_load_acquire() and
>> > smp_store_release() for memory ordering between the fast path and the
>> > slow path.
>> >
>> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>>
>> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
>
> Thank you.
>
>>
>> But... wouldn't it be a whole lot simpler if we introduce a
>> DEFINE_LUO_FLB() and get rid of luo_flb_get_private() entirely:
>
> We are planning some updates to this code in the near future:
>
> 1. David Matlack will send a patch in the next version of VFIO LUO
> preservation series to add liveupdate_flb_put_incoming() so that
> caller can protect from race with release of the last FD release that
> will also release FLB.
> This change will increment FLB 'count' not only when FH uses it, but
> also when the object is being accessed.
>
> 2. After I plan to convert 'count' to use kref, and also decouble init
> and liveupdate_flb_get_incoming(), this will allow to access FLB
> object with interrupts disabled, as requested by Sami for the IOMMU
> work. I think, that while working on this 2nd change, we can also do
> some clean-ups if necessary.

Okay, makes sense. I really think this initialization of private state
on first use is ugly and it should be gotten rid of. So please, whenever
you plan to do this refactor, include something like the static
initialization I mentioned.

>
> Pasha
>
>>
>> #define DEFINE_LUO_FLB(_name, _ops, _compatible)                        \
>>         struct liveupdate_flb _name =3D {                               =
  \
>>                 .ops =3D _ops,                                          =
  \
>>                 .compatible =3D _compatible,                            =
  \
>>                 .private =3D {                                          =
  \
>>                         .list =3D LIST_HEAD_INIT(_name.private.list),   =
  \
>>                         .list =3D LIST_HEAD_INIT(_name.private.list),   =
  \
>>                         / ...
>>                 },                                                      \
>>         }
>>
>> I can't get sparse to work so not sure if I need some special syntax to
>> initialize stuff in .private, but I reckon we can get something working.
>>

--=20
Regards,
Pratyush Yadav

