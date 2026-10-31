Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90DCA606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 16:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RFz6wVcr
Received: by kanga.kvack.org (Postfix)
	id ADF816B05B2; Sat, 31 Oct 2026 12:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90706B05B3; Sat, 31 Oct 2026 12:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F4A6B05B4; Sat, 31 Oct 2026 12:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7351E6B05B2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 12:08:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B4BB40A50
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:08:56 +0000 (UTC)
X-FDA: 85383405072.08.02907E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B6B7140004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:08:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RFz6wVcr;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793462934;
	b=a/iso38GB935RaBzJnA/ncJwIjmZ7OeVkZZHqrie+/06w4RKsXNN2bDbVnQ4AnWt1LsVze
	a5O7ND1gjT7059nkP2/Fn+dC7D7LPXVY8ljW/UeCibyg4w6mp7WNqe8RS/DYOyFxm8MEal
	U6OcX1Y4TN4QLx9MBElRV6y35mRZHEM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RFz6wVcr;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793462934;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s2q7xPa35BAHDOQ+++CerAIr4KoLioGpEtciQ77nd8I=;
	b=kHHCMXTnvyEsToxDtBRMVzWNZJRdObjcqGfvxZlc9QGsxY9NOumUe7X9/1wubAsR/Bo//h
	dk3bSocH5zAOaDDCn2ZKdQSQWuHh/QR2Jfkokni0mUgyUZPIG580bPonsNx/HR5y6QUZcX
	DEJT/y5BS+si5qHh4E5Q/dDudqKLo84=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 930F742E0A;
	Sat, 31 Oct 2026 16:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458041F000C1;
	Sat, 31 Oct 2026 16:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793462933;
	bh=s2q7xPa35BAHDOQ+++CerAIr4KoLioGpEtciQ77nd8I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RFz6wVcrxaYAhcxuXI7cp40EcOByTPt3TcRCob4x2/H0sYHOepshkYVNvCEFSlkaR
	 IT596bHj5O6rDliLpVBsNge083ivXclxxc944ty1Q67TAN+JiLcCPyuXzDKSEC8p7i
	 XAchGsLDpt+PXzvARLQrpy8i0iyjTUC2r+sFQp3e5XQwBJcp4Q9UQ2+s9aIndbWFgp
	 mMATntGmUsCbGqggjTwO+cKaI7Hws+wKNKDldGmp3cMECrNql+MCdew8EG26OLTmIh
	 fQ+U3ui+pqEMH9EDxkkV8QHGmSx/Hh+y1nwlG3goMy6hMS7rQZq47HaNAWpJAYZcCi
	 2FWKZAOcNs/1w==
Message-ID: <sashiko-outbox-192033@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/2] rust: alloc: move `NumaNode` to the `numa`
 module
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun
 Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>, =?utf-8?b?Qmo=?=
 =?utf-8?b?w7ZybiBSb3kgQmFyb24=?= <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir
 Duberstein" <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Thomas Gleixner" <tglx@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Yury Norov" <yury.norov@gmail.com>, "Yury Norov" <ynorov@nvidia.com>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Rasmus Villemoes" <linux@rasmusvillemoes.dk>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, linux-mm@kvack.org
In-Reply-To: <20261030-cpu-helpers-v4-2-a8d840d34837@kernel.org>
References: <20261030-cpu-helpers-v4-0-a8d840d34837@kernel.org>
 <20261030-cpu-helpers-v4-2-a8d840d34837@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 16:08:51 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: B6B7140004
X-Stat-Signature: 1awbo4qb15ezfnfmp7ucyk5tx54kn6tq
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793462934-748328
X-HE-Meta: U2FsdGVkX18mFElQH2gSadKyNJSE+nnJphfTgF9JfqjkwGKXe9UxT6rg7KJMt4Mqya2r5suKCH31JTIqXrirQ1BBR1fQ3zp/wsmBmhDcJ4EnlgcBsKK00JZLzC7HTaQyMVN3IVmQvnIJxX/TTJdUHPNiGLNnkV90QfYwkT4Zd6IHgir4G+9i1Mdrpa+Tafiw2vSDouQ9XzdaAFwnEKkZHXYF5+FAlRinImcp9IIw20vnIWoPOuR1wDr8ckA+TjWzomrbYXPKuNpU74kTGvfD8Z8cMumUX7ys6M37zcY4fQ2jmohdP23FhshKu2dsKBwUrB2eV6n7SSOXih7Ji+g4HdhqpYuZvxi3X4bQ8sll/EziyEvB8gf2wrK/9zDg89puvZLAcboZZAZPwpBzqvyx4oteF/oLVC3ZZIVRPlaFcgwFb9g3Z87VpsOp5UKStQff187165ZlE+0lYfbATcm/hqwfvD9GikmkLVvSLRsgt1P3b8m+zCzbDoOQSLPZfG3lYqx6dnvaJvnUepHFAr1pwdaMBuhGbjq36b/bBSkCylcC4XhPEQnTh7kZq9+hOO1pu2yfmXeXfXi4Io4l1pTT3UBohxTK9t8FXLMpuDF/MgwIqKmlz4cRIi943lzgEkHqmf9QVb8M7JVX/ZkIR0eK0FMIlicwl6FJm5RKql4wG5WeM3cxrxtj0JGCeoxgw5np3L7eWVWakA5xFxnsyXRpim+FbITANLnt5M1YSQXKjHUqaHXp4b2ApSmkoyPfLmaPk7vLQ7nU1YjKp6/DWxFpdQOufKzwbuhNUVs5LChoIVS0JMmDC403Suq/vC3uSMV00xrbSpb/m1epQoUtMmEgQBkvX6XXYXsWw3qNb5te+wvh5mbyOG8nL/RU2WlCLNjbOpQkJRiPf+r2K+P7CN9bHHRhoS+GcS71XRA2rAEx/Xz9+/MCfv/zIR9Q/dpMGNlgVdhyIYHqJ/Azwp1XPst
 JcaiuinM
 CGSG7Eyxv7IYiM9uIfLvCKRdGZMDpQCN+tP8DOOaU0obpaxlE30H59MqjMXWB+piFDZnV30CuYBmsofZTRt3eVzmOKx6Q57xMIArERlzJqbSFsAb07LKnZRzcszQuW/1mB8s49a/RBpwUP+zKRah0LCCWgS4hldMHmIfrBvOMVImD/ePQtRW2nJ8tX8klW80aAQ/TpoXE8AL8soKJyH3vWaaHxMus98VT3cWPx8DH8FS7H5fZJ+7bHQaDIa8mV58oPIl5Nmj0eQG8pgofHwMEsEdVR3P/y0rPHvfTGTvAl4E3z/uomKsSnwFFyeO8sq9TS0BRmWi0flqvBjPlY+gJqxmE54i4q8MB5fu3lZnvX6Vg0wc63MSVBQmiTWwfc1dg3SlavY4CF9eGvV1vPpTagRQ+jhm8CcpYWk/ARFKpiN5wpO9woeat4G3BB6yWi6Tbibmknum1fm6jbCf2jgWQATdHgCAHaILYPEy3AmzqeWEtzxuFePEHIfW81m88x1pHiitYutYHSiXVIsDsfX7Z5AUj2EPZpQElC+Txw/5byypplTk4hQDS78I3cIiRvnQFniduWcJ9LHz9pmkW0mp9FyqsQvgDQIwqkbWoB6FfWR7llMS3BR39uR4rU1HIaaUivmCNrhK7fs3hfVqY7MZAU5uMKsrSbROgbZEVNhd98PBl/D9JT0P+JhpI/g==
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
- [Low] rust: missing #[inline] on NumaNode::as_raw()
--

commit 642cdfa1b2261df4d8bb7af89b382fd608fe93f2
Author: Andreas Hindborg <a.hindborg@kernel.org>

rust: alloc: move `NumaNode` to the `numa` module

This commit moves the NumaNode type from the alloc module to the numa
module and adds an as_raw() accessor so callers outside the numa module
can obtain the raw node ID.

Link: https://lore.kernel.org/all/aiZvKPFCkqJUsP0a@google.com/

> diff --git a/rust/kernel/numa.rs b/rust/kernel/numa.rs
> index 164e622d325f8..4a3a880308f3d 100644
> --- a/rust/kernel/numa.rs
> +++ b/rust/kernel/numa.rs
[ ... ]
> @@ -27,3 +30,33 @@ pub fn num_online_nodes() -> u32 {
>          bindings::nr_online_nodes
>      }
>  }
> +
> +/// Non Uniform Memory Access (NUMA) node identifier.
> +#[derive(Clone, Copy, PartialEq)]
> +pub struct NumaNode(i32);
> +
> +impl NumaNode {
> +    /// Create a new NUMA node identifier (non-negative integer).
> +    ///
> +    /// Returns [`EINVAL`] if a negative id or an id exceeding [`binding=
s::MAX_NUMNODES`] is
> +    /// specified.
> +    pub fn new(node: i32) -> Result<Self> {
> +        // MAX_NUMNODES never exceeds 2**10 because NODES_SHIFT is 0..10.
> +        if node < 0 || node >=3D bindings::MAX_NUMNODES as i32 {
> +            return Err(EINVAL);
> +        }
> +        Ok(Self(node))
> +    }
> +
> +    /// Get the raw representation of this node identifier.
> +    pub(crate) fn as_raw(self) -> i32 {
> +        self.0
> +    }

[Severity: Low]
As reported by Sashiko on v3 [1], this isn't a bug, but should
NumaNode::as_raw() in rust/kernel/numa.rs be marked #[inline] since it is
a small accessor function in the kernel crate called by
ReallocFunc::call() in rust/kernel/alloc/allocator.rs?

[1] https://lore.kernel.org/r/20260929-cpu-helpers-v3-3-e968ce5ee613@kernel=
.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030-cpu-helper=
s-v4-0-a8d840d34837@kernel.org?part=3D2

