Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8AAEF8FA91
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 15:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3D06B0005; Tue, 21 Apr 2026 11:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94AF6B0088; Tue, 21 Apr 2026 11:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1D46B0089; Tue, 21 Apr 2026 11:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B922A6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:07:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1DD855DEF3
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:07:26 +0000 (UTC)
X-FDA: 84682891692.18.5FC218D
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3E9AF4000D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:07:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QE89DUrP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776784044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvD5z3d9+wA7tb/nW8saysrfgp0G4rLi1yg3WlABLYo=;
	b=tea3BBCAFhDAweYUtkgr2iyUgmUpbqG1VKosQlXY8KeEy4k2SEB+beXFAzyyPwPWQAVhEP
	0SX4dce/tlTR/Xag33WR/JepmyBU7Z/E0f+JmT1BS5peDp/U0HvvBbyljrgIIAdyvDpn+7
	r61uKlkXHcav66ON5iQi9LVRDrR0O3g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QE89DUrP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776784044; a=rsa-sha256;
	cv=none;
	b=d1BDi2w4qNbgLVr8R7i0psIuuJvTzVUI8Mip4z4JBR0Mqbl/kuHB2+5hN2CG2qDE19pzyp
	qZiHPG5IVvaaBcdgl27QIzfhBDamtoqZVQ3GFBSXcKsPLuhqOvgw+TQdEMIkL1GTCKoMfQ
	jhpRd+pSzEywCmpTByaetSXvtmB7y+w=
Message-ID: <d2eb14ba-8229-4a41-b3ec-3b618a60b396@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776784041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wvD5z3d9+wA7tb/nW8saysrfgp0G4rLi1yg3WlABLYo=;
	b=QE89DUrPH1rS/mJokbAqm405th9d8TYKa1dLrF8IeeactyP3YmftMDTzTWrYObzGu2dBik
	RfGaRbfxglCRr/78WAbOgnrHM/BeX25AFAXBY2b5FkdPhwaGTzwbehqgVwHkIVjztyCLhc
	GE9AJw63wgunPZLtNjA+ZGkkyGNKGac=
Date: Tue, 21 Apr 2026 23:06:35 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] rust: sizes: add SZ_4G constant
To: Gary Guo <gary@garyguo.net>, Miguel Ojeda <ojeda@kernel.org>,
 Boqun Feng <boqun@kernel.org>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Tamir Duberstein <tamird@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-1-41c6e9bb061c@linux.dev>
 <DHY2X44G62PD.3A7IMZ2FAWXLG@garyguo.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Alvin Sun <alvin.sun@linux.dev>
In-Reply-To: <DHY2X44G62PD.3A7IMZ2FAWXLG@garyguo.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3E9AF4000D
X-Stat-Signature: jszieqbyr513w4hxe6fiaw73xi6okjxq
X-Rspam-User: 
X-HE-Tag: 1776784043-984476
X-HE-Meta: U2FsdGVkX19rnL0wyqQkwLIqNsLvSyVtI3F9M6zX0gHybxbdjlJ63jdkmPTziipp9AQerDTdeW6Sxe9/vt72lQ0Dd6WP+XjyRCXskZw7rOXDwXdI2LP+XI0AZLEqvBTpcPmmZ6l1HVHes9/FXwqQVdhznxjO41pPlvg7tqV6J6/Ih7fOiP160fVb07fFnogVdPafu1O6pMnJyBvzwcxN/5vOL/dq4UdAfVszX0XFTURyjSSapGDrle/cMcLTCry5CQq60S/Yax3WsZPZzQo4ylUyTWIELN9hnMJ2GdtM4axMi/1o+JHY+hvKqzPbwa5Ibe9Mc5WzOpwFRaoaXlvkg3XvugLQ2Q+QvIE5ZZw0cp3fvRPHaQvWx8wvPh8VOk+3PXUEzLfHNcZvN4MtIfBW/HM2mDgtuKNXK75AevEKR8yUe8p15jSslO2ml1C9cqRNW5x/1Kst3CCaVeSedqw5wX5nbBEMbeDitLJJF9p9gKylcrV66cYxaRSudE/iPG32Le0TCMy7NVA9tVMAm2P2mz8/0nH7FkI8pN+syxpkoN4vZ3JnBJUU+RMhEPNio1kSePh8DCz2Bp6scymr1ugQ/FB7yiAth6VqHdBIg05Onr51wEcxv39JX111bssiZV+QeBr+TZzsqkquZKHfTZXHdcDRkWJ0QmbMRwQszbsLVqPVfT5vI1XhAR//GNjW8b0uUSkN+US5yyAkpYevehQ7RLAw1XzHDFWYGjyMYr5+e5vQcg0yeiweK0OCvaq+PaW/mqSe9cXZizi8NVztVgGJjCSvUTpVoR53lTj8/eKhyyvwqZHpNTsANqxt9FxLCVxOwQKBKF/AueAVaIGE6k0KziIyXAZNKgszKkxlfKFhTYl0X+GRPt6xiYdjZzzx1x5ZA70FGZuuwFMclowOvAk550Wikv9jNpGEqwuBm6h/2zgUxqr6cdz5LdWrYaE/jV3dA7QvH6BM1jiL8C16W5K
 MOJEvAQ3
 zLfur0ZOW9aLQaGSE+kie8JWuMjsp2u6vnVMN5NAQlpncjOrpnxZWQE99xnHxQZTFw0lVDZkVEBKbYvw67Y2J3bO63aa+UbVi+Ji9hNqX0ToL7c23maQMapyMrndJLWrFGu73AAuadZLFnvn6RZ/yJGMna8v0ogYRJTMG2bquKn6ADL8uzZu+A4P78/wuEth7l65W5pbZ6CAe8EYJlCDcxE+22E8iYNCcRrK3LQ2t5wNsc3R9dJlX0wbvloyBE0F3Y4Po
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/20/26 23:15, Gary Guo wrote:
> On Fri Apr 17, 2026 at 2:05 AM BST, Alvin Sun wrote:
>> Add SZ_4G constant defined as SZ_2G * 2. This constant will be used by
>> the Tyr driver for calculating user and kernel VA layout.
>>
>> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
>> ---
>>   rust/kernel/sizes.rs | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/rust/kernel/sizes.rs b/rust/kernel/sizes.rs
>> index 661e680d93306..872f5bb181ecf 100644
>> --- a/rust/kernel/sizes.rs
>> +++ b/rust/kernel/sizes.rs
>> @@ -48,3 +48,5 @@
>>   pub const SZ_1G: usize = bindings::SZ_1G as usize;
>>   /// 0x80000000
>>   pub const SZ_2G: usize = bindings::SZ_2G as usize;
>> +/// 0x100000000
>> +pub const SZ_4G: usize = SZ_2G * 2;
> How is this supposed to work with 32-bit arch?

Thank you for pointing out these issues! I didn't properly consider
word size differences across architectures and wasn't sensitive enough
to using `usize` appropriately.

I'll fix both issues in the next version of the patchset.

Best regards,
Alvin Sun

>
> Best,
> Gary

