Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFE9CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D420C8E0054; Tue, 19 Aug 2025 13:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D194D8E000F; Tue, 19 Aug 2025 13:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C561C8E0054; Tue, 19 Aug 2025 13:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5D7A8E000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:53:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 687141A018A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:53:51 +0000 (UTC)
X-FDA: 83794255062.20.EAEAF47
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B8E8B14000D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:53:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bBr2viVC;
	spf=pass (imf23.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755626029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBrgpXrCRLQ58HlS0ADXTe2XCIP+nF5lGogPz0T6X2c=;
	b=uvQdMabG+71cPNc8rBCUIU+n+U/zxya6Y64q4x9Yah88iwZnEzKLT1dZi1jsX46QrwbnPb
	yqoJngAl/JKyaD30Sp2Q3jkc2R97LwgG1GCn4OFTYS94k+wkc1fZc8w+1CaFnNG2h0EJGa
	xDlP+QNhzm568fuhhJLzZ08JfeOYUJE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bBr2viVC;
	spf=pass (imf23.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755626029; a=rsa-sha256;
	cv=none;
	b=RP2336Ufutch6ReRTIS2PXOy/raS9mL3f7bHloqT1UyO7jSRcYHTdgSdOH01oJRkQn4VR+
	XbMwrlZsNfYUSCc8yKXwoV2hXYsWTc76YwgdAX4WAHBQX1wFs0ED2vKPABZpyYEU2j0lVY
	T6lSj53jYaYtLsr+sSb7juL5OISbojc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B65C60209;
	Tue, 19 Aug 2025 17:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E635EC4CEF1;
	Tue, 19 Aug 2025 17:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755626028;
	bh=+xxXPwLoU0wjEb+mW+JP5nJ7ehtG5WJJ5v83QIHPAO4=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=bBr2viVC5Frwot+fUtbob4OA2U2Aso9ZG8T/EcSpgnZY7VzFOm3a3Op1M+G1KyN8S
	 Qv6BturvImnj+cFCyEY6ZGp26VHFlVXVehSK1o6b99R1SGjncIjrwZIffIS/IVWgwi
	 cHe9kWI6WMQHZE7DSpoJlRB3qUYV+Jc+xjucuRuL3fPPtcCbatAQAuTPCQ54FuBtWg
	 leAPoS9xbbob+n4lhn6RxRfFn8KSIWwd9ipS4TV8S1ATe6oi3GAKuUAgTlA/bPNNjy
	 ZNliXflbwJimCpVjXSw/FPAIiibCkdjhcDbbWiXhve2i7QJv6Cu1p4VN8jDny+LuaK
	 SHrE4VDN3VPMg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Aug 2025 19:53:44 +0200
Message-Id: <DC6LHHC2RQAE.1D7LOPCF3IZNB@kernel.org>
Cc: "Alice Ryhl" <aliceryhl@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Andrew
 Ballance" <andrewjballance@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 <linux-kernel@vger.kernel.org>, <maple-tree@lists.infradead.org>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v2 5/5] rust: maple_tree: add MAINTAINERS entry
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-5-229b48657bab@google.com>
 <DC6DQKE6LVNQ.3BBD8WF8XGROO@kernel.org>
 <5ssx3vakl3enjeaygpxfqtb26ufehwfjvcwqfna4xbhc645xpj@lzuvaf3my3f6>
In-Reply-To: <5ssx3vakl3enjeaygpxfqtb26ufehwfjvcwqfna4xbhc645xpj@lzuvaf3my3f6>
X-Stat-Signature: f5a8ebf5xdpupdad13so6ou6i6iw8y9t
X-Rspam-User: 
X-Rspamd-Queue-Id: B8E8B14000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1755626029-371379
X-HE-Meta: U2FsdGVkX19VbvZ/c8gmT4ik4InJi/2cV4+xWU8nee/XZ3GStAMo06ihtvYTaFES4qt1YsvSrSnpI+EFsJ4sL0NWVODNm46XLqVleBO9Vhg48DuyWaVo1W0FH0BPAwqworvVV8RGoHom7eerSj0oIL9ps6U+2NJtaED1lCuM41oyNQWrcdtQhreHFRDi4VwM6o3RMHiyhujrK1y4N5B8ncQiH+Y9SL289u0Qe8LauqjCOscMd5KnxnlOuqk0yXJvOGdLnL1eJC55PpR8eQqGZ8rZ0yE18jXf417uD0XLDWW3NRyBgG4t4NmqQPHuse1keCj3H24mZ54artgoPM8TpekFHtu62eZN903WURrnwqAKQZ8ENRvPZwTayM0cddO012/brnV8dkFR752EuULiqnPxvFnymt0ujtwIakUpGI9InFIX4b+B1BbPshdk9vcWeYkFw9cIqD/N/gGqnhDfDPJpNKOlcBxMRf8999OM8SRgUYJeTtn1iJqxNx6F1RI//1j5GVF4JjD8bmpSQUg34Ezp1Bb8R7uKEPk5zkWx2JpNBbtRcw55M5WjOA76Oy97Uyyd/WdEydacdsXMnDoA7XLnDsJ7SHSw91MsbiEWN3NwO5M8DPcYEyBh7puQYQiXqFwQIvU0S1HQTF5xt7dqGlxhcXZvjzoeknxwGtWKt5W5taku1NBfZdVBtyWzBHKHtY5XWNWL+dPP+1+Gl6Dnt2JtJZt1NMFQmEcieiE2QPeXt8DXCeqEFTNmqWSPAzQ3cIvz01msxEHc7HTgELIUMCqOpGpho52IwlvRqJj/5CZ/tYKqyrBWuMO6p8IuTAFV4FjsLZ9EIaySpa4mKdyRMPsl5iNAvI/mp7aQfUkG/9QTt+O43aR2kK93j+aUQp8KIkPnvCmGFH5PDamJpZzaISbbrYOSVkli5oVRtfG/Iw2l14TGWJnpNAU52P+6aVotJ7bDbhqi+Dz77X+uvl2
 CoIhapRL
 SxY/k3LwG5WkDNAK1jiO4q/WUjQKrQOOOTtsASbudGxfmUrGx5dbPC0YmG6VrsuIPpdjcwapsYcAtGAwncQTdsal5DQ8LkUfF0RNKpr8Y8Y+/nzWGPc5ef+UtktZd066WtAew2Umld6xzU3ZzyB3b+4g/XjFR2t0iYxEDerB7FwlvF6qR75d8HIefzFx5BKFWxDsgG724geYgVl5J8LFKwfxfDuRxtHei1Z5SbNz/LIdgIknn3QXhAFXwpmuF+5bKFsjvdkA7mk3AA6ue4QCT8x7Slt89pVvltq1cwuQ7/3B+zQmwe+GWVtsLg0+0DVjtkbKfdQeJcfS86I0Yt2VC51hGqSvGdlsceto79RxnOOrrFBEWdwCJBhjZ2IOG3K0QX9qKsJcozQyKKZaopu1cbqV5JwicMT0VUU9OPYQESrYkBoJfhISgLJ5AZqLgMKZdEa3t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 19, 2025 at 3:36 PM CEST, Liam R. Howlett wrote:
> * Danilo Krummrich <dakr@kernel.org> [250819 07:49]:
>> On Tue Aug 19, 2025 at 12:34 PM CEST, Alice Ryhl wrote:
>> > Similar to and just below the existing MAPLE TREE entry.
>> >
>> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>> > ---
>> > Liam: I'm not sure what you prefer for the MAINTAINERS entry, so let m=
e
>> > know if you want anything changed. There are also a few other options,
>> > for example, I could just add the files under the existing MAPLE TREE
>> > entry? The get_maintainers script should still send any relevant patch=
es
>> > my way because they also match the RUST entry that has a wildcard on t=
he
>> > rust/ directory.
>>=20
>> From v1 [1]:
>>=20
>> 	>> We should have another section for the maple tree, since it's not ju=
st
>> 	>> used for mm.  Your stated plan is to use it for GPU allocations and =
the
>> 	>> code doesn't live in mm/, wdyt?
>> =09
>> 	> Sure, I can add a new section if you prefer that.
>>=20
>> Maple tree is already used outside of mm, e.g. for regmap stuff and I al=
so use
>> it in nouveau. Hence, I read this as moving maple tree to e.g. lib/ adju=
sting
>> the existing entry.
>>=20
>> I personally think that - of course unless the affected people prefer ot=
herwise
>> - it is usually best to keep a single maintainers entry for the C and th=
e Rust
>> code. Maybe Alice can simply be added to the existing maintainers entry?
>>=20
>> What do you think?
>
> I'm not sure what you mean by lib/ since the lib files are spread into
> other entries by the looks of it?

I think I misunderstood your comment from [1] above, and, despite knowing
better, mistakenly assumed otherwise -- just ignore this comment.

> I'm okay with the entry below or adjusting the existing one.

If you're both fine with either, I suggest to keep a single entry for both.

In general I think it's better if we try to avoid to differentiate between =
Rust
and C code of a single subsystem (or component) maintenance wise unless the=
re
are specific reasons.

Even though sometimes it's just a formality, I think it can help to bring p=
eople
together and learn from each other. There more good examples we can set up =
for
this, the better. :)

>> [1] https://lore.kernel.org/all/aJW3L3SEVUl_AVvN@google.com/

