Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FE4C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 16:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFB946B008A; Mon, 28 Jul 2025 12:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EACEC6B008C; Mon, 28 Jul 2025 12:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC2A06B0092; Mon, 28 Jul 2025 12:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB8F26B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:39:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 57A01B8955
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:39:38 +0000 (UTC)
X-FDA: 83714234436.03.4EA06FF
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf06.hostedemail.com (Postfix) with ESMTP id A4522180005
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:39:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MKGEAs/K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753720776; a=rsa-sha256;
	cv=none;
	b=y8jwR3SMYpT1/hCzi62olaNLYefXKRJsBQh9YeZJK8jRHqD4uHRZ3gdn0MdbVbajnHWHZ1
	uUDb8jSL/484CA0o8OCF0zwd6vaIfR9fyxXZ4IeTvCQZGaDUGm6F4Rqgb0OUoWwu3XE33r
	OJmYrPyh9I0iQJohZlmx9Ij+YFBkTXU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="MKGEAs/K";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753720776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YVxYvoiT+msYxIflveP1zRR5vXMvcN9Jov0LfV5ZYQ=;
	b=6uszjdhnCuV1LOZ5zswLAPz+6rg3GHjM0qY7taDgqxuj57m9Ei4l53I18lOLw0FvtVqRXq
	CKTR3NT3FNO0RdmlrMt6JUVLvibpvhUDvl2/StAl24vtLCacNNWI9P6C9ceSRDCAzSFeVh
	2GPHGX/Iv4kQ+KHO8iqdpiq/z1td6/8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 8A6115C5ED1;
	Mon, 28 Jul 2025 16:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332DCC4CEE7;
	Mon, 28 Jul 2025 16:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753720775;
	bh=/ov/rk2cjeihsiSkEYV6bT+tgrRGVDD07ASZNj862Qc=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To:From;
	b=MKGEAs/KG5gX+3jiwpP1Xj1E1Pf1d6o1ajUpyRq7oA/oJXi4g7O6y1Q8qV7NoptzR
	 0cF/FxJirOD+0VQ35WbrHmVfs0Yp6wPTTnonXGktCbPeJ1sqRLafK48waU34SVINKa
	 AMiwFMYk+LbehkaovZW6q2QvyDVqiVaELn52fD4GyxZE5MH8OXCZjwMujfZfQiDm/q
	 2cU5LEDDV2qoNJpHl4zLJiWi57MhXbHGLCr+tVDHuopu47DYY8Zfkhaz6JsJFgqRNI
	 236FEZPFQrNGbGAnf2JifrukjEAEPf/tDOjXoB1IcNHLPJxOrGH9atIydeXZRuCPGT
	 gu0xfGzoJXNSw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Jul 2025 18:39:29 +0200
Message-Id: <DBNU4N9KCD5J.2G97H1EI7DO1W@kernel.org>
To: "Boqun Feng" <boqun.feng@gmail.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH 1/3] rust: maple_tree: add MapleTree
Cc: "Alice Ryhl" <aliceryhl@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Andrew Ballance" <andrewjballance@gmail.com>, "Gary
 Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 <linux-kernel@vger.kernel.org>, <maple-tree@lists.infradead.org>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-1-27a3da7cb8e5@google.com>
 <aIefe_MEPd_yicde@tardis-2.local>
In-Reply-To: <aIefe_MEPd_yicde@tardis-2.local>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A4522180005
X-Stat-Signature: 5op678zsbbjtx7s9kbjk9k5tdha619ac
X-HE-Tag: 1753720776-444126
X-HE-Meta: U2FsdGVkX1869bPvfK4FaWrqtPglpaYDcobO8IHtoo3cZh6cZt50CZnfeiPNiN2DKTkaYUpmC6SL/i/HUfazTa405y35VFVxS330Puq0REys4yj2u/XiXkHA3ObAXMvaHpgKajX3+WQ3/FqBTcf+g3qAxYIjlDy5Fru7xu4VwIdPAPFVFD+Wo7R52ivIiuaM42AYuUZa7p8rlKR7PVfNlKqLfcJTbM1TPstfNzlrTtTCizcFLHItLfUNiFcWq4EgQ7Rx1622VKyn9yS5gnP41Vq2JYfu+25EtuLhs6Q2VZQZkf/Q7BOEId2YCx5RZxW1BNE/XfeakOtp24YBDVo0YaaWuM3urR/7KRp9jn6jgxpJdK0ddZYgnmSo4vsP735FfQRlbZZXtabEPupbi3JBUAn26l/XPRfOFaeOMlSpGDruOPMVw87W0dzzou+WS16oSp1sJaTmA9RkbZKGufCkCM8Y8tjrX0vdrk5i3jQzwkoh2ncf3roT/YfX/ps1Dz3Jp4YFUmPbNngkblLRDXs6+hY50OBtmQXD2Kce9ArwlyLVAbJJZXW1e5ebFBXWx4NcmlYIbgG7JkFNLLp5Vho895d8cP4Gwq/ko2XgsczGT6ZSTT+1bad0BAYXEeFKWXemYZFo2lPW6fn/Z/NSCMvcmYVz0OZHUbl7rJrzTg0MZrqL1Y1eGZSHKAG6dg21hpwSm3aaq945b0N52G+XUAA4jY20WUMGaN2MXuKjl+zQzNW5WLx8XMG3RzJ96pPJo6t4wMQS8YN99arG8fX7x80QxzdwoGnm2i+FVw8WdCfjRECPeZT3Fd2TdcHjys5k6vLdM7+er3RAKsa90uE2/AsvLuGNe9feG+ZQbTy5mDWkUOjb2LpbnGhS/sDlJdUEyx+qU5KlCwoMTePCwk+kNaePttaL48plDoFnlnErkSCqUcZkw/8jcnNQ+Fe3X9zYr9SZwBaQOKgaCo7DKc9zOD8
 3M/eeYEI
 Zo76VGsUSVuw/9vLzTHXl9hdZFZcbTkTr2HWQ8AlXXQ8gzZ2VydLvapoDv4kuXO7te9Jl8UwovWUr14rsTi1ca3FDZPaiOwh/o8iL7MCTyL+N3IlRNF0aFP42mn1iEbAzkjX3EkyCluvv8mCTCNrQo2gm00o95MnB4XpRZjevyz32cDqUXXuVBA8gvcaVIP1K2vdgq1MLsUE4jPQi1MwcW4R7lMwy+9ANVC3j/1HrUJi193Q3K/PzAjmlYDP+maM/x3v2LX+VwgP28BUwH13616yZGIFjuM4uqs21o7+kZq2/VRQNnwPa+au8gO7duOaXEucTh8hiB9IJ1vCenH33JHKX0xfEcKqHUOgjIMkS6FPQg3DDjh3bzZw2zNbXcv4S7sSziCQcU93IYjTHlo1jYCUZp7/tWDvr8bXLhya078qcvvUFqKmMrdeYHSaO15kYnMAxzcTG84+WgICGl1kSbjBc6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jul 28, 2025 at 6:04 PM CEST, Boqun Feng wrote:
> On Sat, Jul 26, 2025 at 01:23:22PM +0000, Alice Ryhl wrote:
>> The maple tree will be used in the Tyr driver to allocate and keep track
>> of GPU allocations created internally (i.e. not by userspace). It will
>> likely also be used in the Nova driver eventually.
>>=20
>> This adds the simplest methods for additional and removal that do not
>> require any special care with respect to concurrency.
>>=20
>> This implementation is based on the RFC by Andrew but with significant
>> changes to simplify the implementation.
>>=20
>> Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
>> Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
>> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>> ---
> [...]
>> +    /// Free all `T` instances in this tree.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// This frees Rust data referenced by the maple tree without remov=
ing it from the maple tree.
>> +    /// The caller must ensure that no reference that remains in the ma=
ple tree is used incorrectly
>> +    /// after this call.
>> +    unsafe fn free_all_entries(self: Pin<&mut Self>) {
>> +        // SAFETY: The pointer references a valid maple tree.
>> +        let ma_state =3D unsafe { Opaque::new(bindings::MA_STATE(self.t=
ree.get(), 0, usize::MAX)) };
>> +
>
> A meta comment here for the future direction: I think it really makes a
> lot of sense if we could have the Rust abstraction for struct ma_state,
> that'll allow us to have flexible locking strategy and Iterator-like
> interface. Maybe it's something Andrew can take a deeper look when
> MapleTree binding is in-tree (no word play intented ;-))?
>
> For example, with a ma_state binding, we can do:
>
>     let mas =3D MAState::new(self, 0..);
>
>     while let Some(v) =3D mas.next() {
>     	drop(v)
>     }

FYI: Left a similar comment on MapleLock [1]. :)

I'd rather have that sooner than later, free_all_entries() is a good intern=
al
user.

[1] https://lore.kernel.org/all/DBNO0N1TDAGI.2OEWH6Y60JNYZ@kernel.org/

