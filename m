Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65172C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 07:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61E3E6B0093; Mon, 29 Jun 2026 03:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CFAF6B0095; Mon, 29 Jun 2026 03:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498936B0096; Mon, 29 Jun 2026 03:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E14D6B0093
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:34:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8896B120590
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:34:36 +0000 (UTC)
X-FDA: 84932137752.11.8C50A10
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E394420006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:34:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C453Z33V;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782718474;
	b=TuGRzDeA8om8OenXDnVzFnWgKUv8apQlPecY0tzqMHF+rRxkOn9ODPHftxz5PzrSHEshD5
	msDHsYnP+vnlpXlAS3w1MZLCWWijYZOPkPWxV8V+FdiGTz1mrNJoO1pWGHb18u+PEjeWvB
	jwvkzSFaDjN4drkIda2HiPbltch7lss=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782718474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HeoF2K+Kz6f/HgMEPg1+iANT1j637vPpQHoopCUQ+q0=;
	b=n0JjxId7zR+7CP6LSSfuAbwXKS+LdLlvSuZmESYSrMgC0bX1VsQscgNBWpCpeRFs6JpGgL
	jg2Qzi7ILoq5RnTfk9T6XnYOBksd0QLGBbN2UBiWJ0MJ6ZXx8Hpd2s//KjxYpPDc0a6cAl
	F0z5ToOdnreDfzdeJXuSio++1ntPQSE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C453Z33V;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73382600AA;
	Mon, 29 Jun 2026 07:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DF21F000E9;
	Mon, 29 Jun 2026 07:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782718474;
	bh=HeoF2K+Kz6f/HgMEPg1+iANT1j637vPpQHoopCUQ+q0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C453Z33VpFiMQqfQLryj2TsR8w8h3q8S2KzljnlCANMYrPh2xa5pjxvaGXhIdGng6
	 0qP2G7k5u+RtkdH3sN2KFAtAUiQHpFNmauUE6YythfPamyTeBMFE6xuq00Ew9z0lO2
	 EfXHH7b/vvwHjEwb9/hW3PHgnVSIWB91TBxolyVfFha6JB8qNlmNPJyOq4tCYOJNs5
	 Q0uo6vOb3jiqzaNiuMbVmWNeKJJgXQQsVPxDanztYI1zHuA37RpPRJNeaIbHHlfjR+
	 NHD1EiEz/u3BtR8HraMX0Y1A74Vh26oK8ytY/WHAwwmyDKPl3VBya/CEveOYKRJAtH
	 ZAPBHttxuZ55Q==
Message-ID: <6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org>
Date: Mon, 29 Jun 2026 16:34:23 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next v3 2/9] mm/slab, slub_kunit: register kprobe to
 trigger _nolock APIs
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 rcu@vger.kernel.org, bpf@vger.kernel.org
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-2-70a54f3775bb@kernel.org>
 <ajvczSpMOGWFhe30@pedro-suse>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <ajvczSpMOGWFhe30@pedro-suse>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------LonvLfJHVvQ11VwztTHqXi0t"
X-Stat-Signature: qatodmg1g1grjfuce5pd94mkjcok97eg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E394420006
X-HE-Tag: 1782718474-496197
X-HE-Meta: U2FsdGVkX1/Xb62KQxahmlA+NUP+Xm2wuBqqvswhXhDvwl2HNmFMRzeccUZD/oWhmFkMBA85XJRgNoVdUnHT3xm5xy4Rhx2Gt74DEaCvIH+oqMEsVYVCUF3zwpnkCQkLnSri4V3TogJavp2zFSzyQPDp2YPs6S8jOxTf/m2CokyH0p1Jks3KHeN2EPcQhEO3nuEp564tqPHKIGJQQXEiKA3yRJT96RUY8zptClLg81jNS7nQu4SNvm/WKi9upe7gRUQ+Y6w0V/J1vYnuVNsDjBqmpJpwf4v+HW3g1HKGuwYOMBLxJ2x5ESn1392W29OQg1Cfggjfngm452xuPQAlYOF74xsCPMAukcXLsdpd7KeFIucfcacjYCeIPO/XvypXzWxUJ3wgOrppQbo/KBBCT81rAFKhfDZefCGBHpzz7wRMhFtvrQOM1/2xeqnqOurkY1SpPEv8uozle4Dp/5LFADaZyB0Bc6ew1mdLyEYaUCFUZaTQDjLz/RyR1nOvkIpxo3AUIaArMI7JHrRQLlBpa4lids93RjA1uS5HHO8VL0t/2dEOHihA4nME5ZeIBRmBsiisV9sFsuctSFuR0AeYD2uHU5w0jk+3NXeo8WofVNMo+a3MsNyrMCvb9kxA7+0KIZh95l0bXEIZCkqlR20esQrsW0yW7MYryGjTYwqa9hKH5O6QcAEHZEQqXgbzRGP3WCavVRYqgwaYPqhHhWy8TtP/10CsUgB+h48ZQyPPsFjieE/iKJLO7MRGXhvsqjg0QCeTSHWiGfMrqPO3UTMCDsO/D4SdceM3evFMPEW7EbubPaKxcUycbGhWlLIuKBEgKkj0DWDb6MUGoH4CDO6ZzSYE5RmUiwqJy8Ko+PbVVl+7ilK1xys2Q63s2sIRoPblMqzMPmkvZINlNBGx/lPMBqpBDMploDtjjA0m2W5D548O4f0G6SacRQxXOBunD7rFkONFC6LHHr8djeCHhQr
 Wmnu6eJC
 a17rNkDw0pru/fW+1fN30nITKBYCNNMBLcPlE1ndUl/lDbpIG5rupM9o0W+jm46EEMiwrBWxakQ/FB5urnXhGfjZerGituLvQGz3regzu1hDqws8V+TnKlcSTPZL97C0a3LARbH+3zn/sO7hC6+Sp3rLqE4HMX8LKwyGWpuCiJ55l+cf61NqdWTylDMV7R6areH29IN1nxUIIC91IKRhBs6vEhvlvYCP9MdSGMn+YzrjNbHZW3c/f9/YgtQpkthHCaEUzH3Upb5pUZHbrb4dVp2I4+GO7UJimF5xGbioio584SUee97JKei9lSVDkfJZccO20GqNLZcmXlp/WtgpN2kbjN25nvygRln/f7GeuT8xT4acMOI/pzuwpl6Uw9li7rNWzwDrFLfDGBU1OGVMJNS1O2a5+xHRJdxEUnEr8KGT6a+qHarmSbbeYtE3At48EvXwUMlG8/bHqtEc30oa63gqZnmcD/x6hWQJSVm1CaSeZPdSfHc4JxwE9ooXjjkH5MBdt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------LonvLfJHVvQ11VwztTHqXi0t
Content-Type: multipart/mixed; boundary="------------Rmq7mtq09nxsELJpSUC76Exe";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
 Joel Fernandes <joelagnelf@nvidia.com>, Josh Triplett
 <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 rcu@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <6edebc2b-5f5a-4b9c-9a4c-564310acee1b@kernel.org>
Subject: Re: [PATCH for-next v3 2/9] mm/slab, slub_kunit: register kprobe to
 trigger _nolock APIs
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
 <20260615-kfree_rcu_nolock-v3-2-70a54f3775bb@kernel.org>
 <ajvczSpMOGWFhe30@pedro-suse>
In-Reply-To: <ajvczSpMOGWFhe30@pedro-suse>

--------------Rmq7mtq09nxsELJpSUC76Exe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/24/26 10:41 PM, Pedro Falcato wrote:
> On Mon, Jun 15, 2026 at 08:05:56PM +0900, Harry Yoo (Oracle) wrote:
>> Since kmalloc_nolock() always fails in NMI and hardirq contexts on
>> PREEMPT_RT, slub_kunit cannot properly test _nolock() APIs.
>>
>> Register a kprobe pre-handler to invoke kmalloc_nolock() and
>> kfree_nolock() in the middle of the slab allocator. However, do not
>> register the handler on UP kernels [1].
>=20
> Maybe explain in the commit message why that is?

Because it's the case is broken on UP and we decided not bother to fix.
Thought the cover letter in Link: would give enough context.

>> To attach the pre-handler while s->cpu_sheaves->lock or n->list_lock
>> is held, add a wrapper function for lockdep_assert_held() that calls
>> a no-op function slab_attach_kprobe_locked() on debug builds. The
>=20
> Why lockdep?

I wanted to avoid hard-coding internal slab function names
in the test module while having a good coverage.

> Wouldn't it make more sense to add these triggers after> locking these =
locks?

Good point.

Perhaps it'd make more sense to let _trylock() fail occasionally,
because that what I actually want to test.

>> function is optimized away when neither CONFIG_PROVE_LOCKING nor
>> CONFIG_DEBUG_VM is selected and register_kprobe() fails.
>>
>> The function calls barrier() to prevent the compiler from optimizing
>> away its callsites. Otherwise, the compiler may consider the function
>> does not have any side effect and remove callsites.
>=20
> My wider comment is the following: this looks very useful but perhaps s=
hould
> be lifted to Kunit itself? There's already function redirection (which =
could
> be used for this as well).

TIL kunit function redirection, thanks :)

> I don't know if that suits your purposes?

Hmm, but looking at the kunit function redirection,
apparently the function needs to have a symbol to redirect.

Not sure how feasible it is to make all those lock helpers have symbols
to use kunit function redirection.

> Choosing to say "I want to hook this random function using kprobe and g=
ive
> it custom behavior" sounds lovely for all sorts of testing.

Sounds lovely.

Actually, I was thinking it would be lovely to have fault-injection-like
feature for memcg because it's hard to trigger that in kunit...

Thanks!

--=20
Cheers,
Harry / Hyeonggon

--------------Rmq7mtq09nxsELJpSUC76Exe--

--------------LonvLfJHVvQ11VwztTHqXi0t
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCakIf/wAKCRCGXBN6rc5S
1k2zAP0WFF+pvp88rmpHr5+CTNLJsoe3HtwPQMCjNUTN1Wuj6AD/TWU08aQXbB1M
c2AKbPtfWlxkJ3yFMUn/T9WJ1h0e9AQ=
=M28/
-----END PGP SIGNATURE-----

--------------LonvLfJHVvQ11VwztTHqXi0t--

