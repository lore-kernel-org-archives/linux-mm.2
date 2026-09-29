Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E229CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674A66B008A; Tue, 29 Sep 2026 04:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 624DE6B008C; Tue, 29 Sep 2026 04:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7466B00A5; Tue, 29 Sep 2026 04:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 225386B008A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:44:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A00B816045E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:44:39 +0000 (UTC)
X-FDA: 85266163878.17.91EFB12
Received: from mta1.migadu.com (out-233.mta1.migadu.com [95.215.58.233])
	by imf23.hostedemail.com (Postfix) with ESMTP id B2CD914000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:44:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o285bC2G;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.233 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790671477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIq4JLQVY9rAZekwghkIHYtXVxO8+vtHFHY+tB0MmZo=;
	b=CYxTS2VYbwjePw1LhEPbrrhopgnP++ajS1ogckPEaCSqZZ/tn76j2j48w7McvPGSltaEZn
	hkUF+zo+MOqSF9uY7liK1HH58ZWMGIwcn1RfrXcMT019u2oJblYM81r9OVFLmN3a/DoW9Z
	WXVxHYvvZGmL+5aTYVu2DhDCCD/GhzA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o285bC2G;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.233 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790671477;
	b=bYDeHXQmPC+K/aXScC/2ht/tPc4dJbbLqnYR1NSfy4hSHxueZAx2OngER91+FT2HuHEPbG
	RPPLg4Yxn3VlaO8qTE5N3Ft8SpWErMZ+gJmeo0p9oMeAmP7GwBx08KYNZfEXI9TM6uUC1v
	ic2V4FQc2weVhCjt2mkNleAogehDNNU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AIq4JLQVY9rAZekwghkIHYtXVxO8+vtHFHY+tB0MmZo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790671473; v=1; x=1791276273;
 b=o285bC2GP6XbT43bW80uo8UXzq7FbSHs29LLPDwjbj9z8o3AvxngHe2IAtSLyq5kUqRax0QF
 zIJ1WM7BC/+SMvZ7KuOXjF2S0rpI6ZtUaemxo3lvminaB0Fb98fSeZDiEcA9gE42IjuRPuu6SWB
 kPDU5QJYHAht70qH9M0nNga8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 199085bad9bec430;
	Tue, 29 Sep 2026 08:44:32 +0000
X-Mizu-Trace-ID: 199085bad9bec430
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v5 08/12] mm/sparse-vmemmap: move vmemmap optimization
 helpers to a public header
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <a31cc06a-c22f-41c2-851e-4827869e9df1@kernel.org>
Date: Tue, 29 Sep 2026 16:44:12 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Lance Yang <lance.yang@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0481F7BE-F912-4E83-80F1-6E7990B447C1@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-9-songmuchun@bytedance.com>
 <a31cc06a-c22f-41c2-851e-4827869e9df1@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Stat-Signature: fzuwe55rfhxuko6bquybfh69af878n7i
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B2CD914000A
X-HE-Tag: 1790671477-90816
X-HE-Meta: U2FsdGVkX18GLtltuI7QLOYGtn9pfeSsdGAUl7EAa4YYTuPRYbLWV72MNkoR9hMSLoEE1bNE4sbb2w5xkSEg5KCuWoOeEHNMkvjGu5gAAqw3rw3CRK9+5BcHnGtUoJI+1L5ui924VtQugCoJ/B5GYnAZ2DHLbilNMzzTmBp9CEPIJPNGT1U9WyO9NEsu3VJPMUGMmyf8MCGgmzS4h7MFkN3GoFsLOpnhj6n2fXupeUOtIDLC0uJsIDdCxMIFMK8XreMibQJLXAs5Zr3y10647l8Hy3NZio7CKi9xvBShDVaC6sZND9+oD5ZZioNkBYdntkLzVZ5I1eJZjdFNf8+LqJgW0JKbAFvUlMF/N6HZ5RmeNiuB8VCUcV7cjViyhmJVPm8mQL5dIG/I42Nj4SzrKepp4qf65Gmi2BHWLR/LABsBGDl489T9n/8wsC9FPnX6BNUNUp/dNGBBwbVYb30D40kAZKA0OeyK2WYGlmNATHbxDdkUxuXUmtWBIDcBXd1HLg6min+Z6xHr+wf47luxLFBij8ytBmS1quoa40OYEzXmV+0Uoi3tfm5Gj+bDTeDHS+lhidyZ3dFApcX8sZqEjhxzR5xbjStXQpKyScQROpDLnSulj+E9528TcuNixCnPR4n4aZ80SdTcbXbtD+zd5xY+xbQJpThbW9DrGCjpQ2J4Hjr1vTUioKf4aRgfDGUjKKG221KHWEXfQT9Iks3sUQ9MHsqZ2mA0vGkacxG9i+N1SXxlyoAY7BDalI1r3xnOCDd+ByFctGmFluf/Fe0FrMsL5Dxcb8qMMagcMDIeRs+m5jGkI81JQ6GUS9YaR6MFGtLQwfb9l3dH/hAoPOW6E3ivBSB15GIUI+F4yOIyRCBh50wF99xqU0jFU5YTdBWXmnNmXJhroqCkjLgeqh71WSvnziiZxem5UyK/x6T5Eh5L+u8Fzkxy3mZk4a+KBAA/I183F4T3+3wPTcJmpW6
 ivran7hc
 Y5SFUOpd0Ih3neNHLlObuM2v39hcIjmkkilt6Cv/DrRP5nYeb7FGwWQYsXykRaPhGlxmNaYtD4M6yTVBXW3VFw/VsOKtpZd2p5RCYQzp2EdwCybrAybQ0GDiXdq3nDYqRrumxZf+2IfeLk7o/ZHe6Oqoxuf9N6nPSYkRqr8oGZuu5ZhiqOZ+Piu1fdZnE2kSFgvQN/J/hecDMUYm1IUShv9GyR6B90DSKXIURs+5XROIttIEQ45zX7ZZlVPYr28xpTgB9o3PvWd/CDFdT+DCJgL6c6fjoKel87tSQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 29, 2026, at 15:39, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 9/27/26 04:54, Muchun Song wrote:
>> The vmemmap optimization helpers currently live in mm/sparse.h,
>> which is an internal MM header. That works for MM code, but
>> prevents powerpc from using the same interfaces without including a
>> private header.
>>=20
>> Move the declarations and inline helpers to vmemmap-optimization.h.
>> This is a preparatory change for powerpc, which has its own vmemmap
>> optimization implementation and needs to use the common vmemmap
>> optimization interfaces from architecture code.
>=20
> Which raises the question why powerpc was special and will remain =
special. Wha's
> the big problem here that powerpc must do special things?

Good question. I also don't think PowerPC needs special handling,
but when HVO logic was introduced for PowerPC, it handled HVO on
its own. =46rom my preliminary analysis, the reason it didn't reuse
the generic logic initially may be related to the fact that
PowerPC's section size is 16M. With a 64k base page, a single page
can cover the vmemmap range of multiple sections, and the current
generic logic doesn't cover this case.

However, completely removing PowerPC's special handling is already
in my follow-up plan. We need to wait for the current series to enter
the mainline, and then we can proceed gradually.

>=20
> Change itself looks good.
>=20
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks for your review.

Muchun,
Thanks

>=20
> --=20
> Cheers,
>=20
> David


