Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5230FE9B26C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 14:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D6A76B0088; Tue, 24 Feb 2026 09:20:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884366B0089; Tue, 24 Feb 2026 09:20:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7832A6B008A; Tue, 24 Feb 2026 09:20:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63F656B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:20:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16C3D16018D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:20:47 +0000 (UTC)
X-FDA: 84479561334.20.9D0FE8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4C452140005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:20:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mi2r2O0b;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771942845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8r1qBywDeapq/2NIs4Olq9iLglUN7u0j5VXhkh0oOxU=;
	b=BIOpalSPgpjERoZqgFXEOGsp9i8WyRkH3COTuWRccGTEpjkwvey7BwAkA8OaH5kcJ/+baJ
	EBAcxI0ysFTOsaG03/fkkqswv2PO2cX5dvLlSYmn4cSJNijXRpLYVvmxaN8v8PpOmpdm4d
	JMkWPJYhbVly1vP977cVNuQxkuSpvX0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mi2r2O0b;
	spf=pass (imf23.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771942845; a=rsa-sha256;
	cv=none;
	b=HpPeo22881yGM8+pKx1P8Lcv40hZhIVUh0oDP0J1tDsu8zz2MCxrTpmLhKvDPpUgzGbVbV
	/QzVyzOPeTNwLpEf0T3NXWyGV8PaTVFThQ9YtRA4/40m3fqP0lVmWiCNV3ga0rxZZiGhxu
	GMcuwAT+vagspnm8WplIoBk2LYA6r+k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5046843E0B;
	Tue, 24 Feb 2026 14:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD07EC116D0;
	Tue, 24 Feb 2026 14:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771942844;
	bh=6hP11Yqqq/GprRK2m8tsdirVLpoUEEz5m8g6sqgivnQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Mi2r2O0bcVP3kNrU94OzHezKKtr810sFgXSDqUTfy1t7kGF6CA7IrNmP76HxVuW/u
	 cngKdcjQ3eki6HHwThIvpxkbpFaJ2BJUTvY7uKcknKpgTZA42piMZmD9NY5wrQNoob
	 OKeCdS/K62rMCxFt/NClkt79UTcN/A/iInwdQ1l0X5q5n20E8+Ve0V+a/+ejsGN6i5
	 CW55fYFJmX26Qo2yr1Fr+KycrSXQLKGnQFu0Eq4/7HMeRE3U68lSfDtWKHmlfI+PTT
	 CKzaBde/Ay1zJq/ZlA3y4fZ4ZvCpCg0QS/c/wLfCEpQ9u9XUHNXsqy7LiM5E3mzUmd
	 6EHAXmyuMP2pw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Tamir Duberstein
 <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor
 <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
 <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, Danilo
 Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, David
 Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, Daniel Gomez <da.gomez@kernel.org>,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
In-Reply-To: <aY7eMIhkPJ3wXD51@google.com>
References: <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
 <q43rzzvpfh6ke74eyn3nypiek2ihaq6nat552asiobqge4vxmn@knwkb5dexnga>
 <87fr77viat.fsf@t14s.mail-host-address-is-not-set>
 <fU1FEYt6-SY0KlyJy4VClCr5j6P4d5-wukzc_9TkSDSBuQNlY26xyOIprMbHEVMv-H-nrAJ1iN_9tcfIXEI1iw==@protonmail.internalid>
 <gta2wjt4tkcvyu7g56gqyipiigbmbk2ca3biqzmxc2npch3rk7@ccwzwgnk7mcz>
 <87y0kytggx.fsf@kernel.org> <87v7g2tesf.fsf@kernel.org>
 <_ZaFqe4HzW4GSDQTrXKDgkSCr7L9bxUh-h5QPqVlMUHSvE0oRFuZJOPi0JItf3VJXHmaX4PA4QWAGBeG73cJYw==@protonmail.internalid>
 <CAH5fLgjfSWfhUkmG6_ugue6Wp5LKtkEFJofWViJSNByq3sO2Sg@mail.gmail.com>
 <87seb6t9t7.fsf@kernel.org> <aY7eMIhkPJ3wXD51@google.com>
Date: Tue, 24 Feb 2026 15:20:29 +0100
Message-ID: <87pl5u1avm.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sxgu148h8cbubncmjsytbrcyunwrgre6
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C452140005
X-Rspamd-Server: rspam01
X-HE-Tag: 1771942845-684713
X-HE-Meta: U2FsdGVkX1/mXaBkOh5csXA8Zks9NTRIg19ZQgMsJJXIODTgQn8GYUifIvyjDK8dFIcUL5X3sGJs5CuaVwqbHATGxqHUA6ERlMl5q3lvLcsP8+5mdEmuiW5KDVIApARtYx+aqjgTA+ud/cftcOBq04ldu9k430fklgE3rl3EMub5sfXg9xrOleL1WH83ZyAJmQwdD/mn621ra1VYgtHv2cyh4GT0x4AouXChxurK8p6rIBfW8KWggd1PucRd/yyYQGuFsOvq0DrEgpKLmbEmHuEmz5kN/+L0bPc3/ndSUdbYh1dU2PRHWrFG34l2Lc+V4Sf2Qema7/dnzzAivAe3P5K2gPWp+IOT8a3mZ8fZjsHe3erBdLIVkg+gH21qxOIRvz6sL9xHR4eNLG8Es+vrp4bSx6l+2gnmZ6+tZ6DQwnfB3LOrccaQyOlexEivbd7sWtU+7vnlGe7NIRSO9FKwSFP0ec9HsQfezzdFJ7wNNcmyQyZgqc55O1vuosSr//vmDgvrY9qEfjd3UDGORm+bsArAPrdJSwQPr9n3wG1exqUIdu2aPHLsPpgxzIwCOGlH7ntb6n54Edr1AVIo5+srxk4zRIwfOBRYyZ/bwbXZNIJwsO3A8GG95BDA9jbbF0AVJaN2ygpGoD2ZE6CyYoNAj1T/2ZTPrC+2LinlUUJuuB9WjmrjkeWtKcynG7POtMCsnfBQaI+s2FoX2rqxTHlS21gHn0wrVH8wdy5zQYgf2I3J+fTyn3UqZ98qjPFOQnY3uUM2fvqDXY/7na4pxuBq0n3R9EKujI0fG6siT7c2yIN1NWbQl0irAGi+Kyt6TEJKDi8qKtx0e2H8JDo18phWARASiTgD+8/dUgkOQ7Y/3HDd8ITQ6OhF75e1QIuZW/ap6M+nisGNupw+VYa+xhyEoMMeSc0Fo++iW7AkG9HrJFPKeD0yIbMwq7GiSaQ65e2jkB59pOc+LGBPv2oyMYb
 lJ0JiUSH
 ZQ/4MC0yAKLlQkJkLfz+VONuIF3C9IJFdZFAz10wL03ArujJI4Y7odjn07rJNKqEuYHER65uv2wlPd5E4OzC8hNmhwpvvjzApnRGDPNn1FzgmSF6DxN7VNkZILC8fwZgge/SLd5U2DFSRI7gpqueqy0GmqMJAxsm6StO8ZzvlgyFjkZ4BtSWyQwyNECtWFJqn1kLFSsuOIupS8UklGyW3jWPZi/d2OLrayRGLz7V9W0jWgmzaNJslmugabw+InBnFnUDMebkRqIiXkt1IgC3hHnuLpTEEZHKGm2Em/giH20w4a5EQ7un65EEqBAIUQg4QXfE9kOceKTcMD7lxnm2FIVocya7GvL5hup3hhh380rWZW+5TO9EiNJ7LUGTcEz1p1Hon
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Thu, Feb 12, 2026 at 01:39:48PM +0100, Andreas Hindborg wrote:
>> "Alice Ryhl" <aliceryhl@google.com> writes:
>>=20
>> > On Thu, Feb 12, 2026 at 11:52=E2=80=AFAM Andreas Hindborg <a.hindborg@=
kernel.org> wrote:
>> >>
>> >> Andreas Hindborg <a.hindborg@kernel.org> writes:
>> >>
>> >> > As far as I understand, this is a borrow checker limitation. It is =
easy
>> >> > for us to look at this code and decide that the borrow on line 51 w=
ill
>> >> > never alias with the borrow on line 49.
>> >>
>> >> I did a bit of googling, and this seems to be a well known issue with
>> >> the current implementation of lifetime analysis in the rust compiler.
>> >> Apparently this kind of code used to be OK [1] but the Rust devs deci=
ded
>> >> to remove the code that allowed this, because it was causing excessive
>> >> compilation times [2]. The upside is that this is solved by the new
>> >> lifetime analysis implementation called "Polonius" and it is the
>> >> intention to replace the existing implementation with Polonius at some
>> >> point [3].
>> >
>> > I believe the standard fix for this issue is to provide an entry api
>> > similar to HashMap::entry(). See the rbtree for an example, as it
>> > already provides such API.
>>=20
>> The example above [1] is using the BTreeMap entry API to produce the
>> issue. Are the BTreeMap and HashMap entry APIs significantly different,
>> or is there something else I missed?
>>=20
>> Best regards,
>> Andreas Hindborg
>>=20
>> [1] https://lore.kernel.org/r/87y0kytggx.fsf@kernel.org
>
> Hrm, tricky. I think it would work if the entry type had an into_map() th=
at
> consumes the entry and returns a &mut to the original map.
>
>   fn transaction_impl1<'a>(maps: &'a mut Maps, key: u32) -> &'a mut u32 {
>       match maps.a.entry(key) {
>           Entry::Occupied(o) =3D> o.into_mut()
>           Entry::Vacant(v) =3D> {
>               let map_a =3D v.into_map();
>               let value =3D map_a.first_entry().expect("Not empty").remov=
e();
>               maps.b.entry(key).or_insert(value)
>           }
>       }
>   }

I see. In my use case, this line

  map_a.first_entry().expect("Not empty").remove();

is not open coded. Rather, it is in a function on `Maps`:

  impl<'a> Maps<'a> {
      fn foo(&mut self) -> u32 {
          self.a.first_entry().expect("Not empty").remove()
      }
  }

  fn transaction_impl1<'a>(maps: &'a mut Maps, key: u32) -> &'a mut u32 {
      match maps.a.entry(key) {
          Entry::Occupied(o) =3D> o.into_mut(),
          Entry::Vacant(v) =3D> {
              let value =3D maps.foo();
              maps.foo();
              maps.b.entry(key).or_insert(value)
          }
      }
  }

In the actual code, `Maps::foo` is not a small short function, which is
why I extracted it into a function.

I think I could make this work if I just put everything in one big
function, but that does not seem like the right solution.

Am I holding it wrong here, or is this just the way it is?

My `transaction_imp1` is `get_or_alloc_cache_page` [1] and my `foo` is
`extract_cache_page` [2] if you want to have a look.


Best regards,
Andreas Hindborg


[1] https://git.kernel.org/pub/scm/linux/kernel/git/a.hindborg/linux.git/tr=
ee/drivers/block/rnull/disk_storage.rs?h=3Drnull-v6.19-rc5#n209
[2] https://git.kernel.org/pub/scm/linux/kernel/git/a.hindborg/linux.git/tr=
ee/drivers/block/rnull/disk_storage.rs?h=3Drnull-v6.19-rc5#n148


