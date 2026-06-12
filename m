Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C8D1CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 18:48:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861736B0005; Fri, 12 Jun 2026 14:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812936B0088; Fri, 12 Jun 2026 14:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB006B008C; Fri, 12 Jun 2026 14:48:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 585066B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:48:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC2948C584
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:48:04 +0000 (UTC)
X-FDA: 84872145288.16.BA7DD5C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf15.hostedemail.com (Postfix) with ESMTP id EEAE9A0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 18:48:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iKK9OQjB;
	spf=pass (imf15.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781290082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htPuT7tm372smVg4DmgxAuibfc4nj8Gdpe5982tY96k=;
	b=VEIobJcbbyjOSYbKZ3vMUUsj2KvRil9eyqNrMJClwxl7O8Hby4W3S3+/qY8NNYyQlu+jH9
	E02Nmi1ZxRcS/oMohSI5DoexTmwizEumLUUJeZHFbOJ8wkdbuC2sHDPA4+JE4hU/3Rtq+c
	AXSF0JjJXcEc+glCGiHP7ovptli4oHo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781290082;
	b=v70lQl08LEqdDHIvrKMHUV9HNh+/3Yl/+ayyAsPNomh0YB8FWfALGoZeYzt4gowG/TKQ8E
	sCil6UU8MLapwtWCM+h1HMWqcPq95zDDrIzCM5krXTJvUTpt04j2ql1sfRif+SMWUeY5JU
	6bWRQCwf7aQSZm9tZxw5OQE51aPSjZ0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=iKK9OQjB;
	spf=pass (imf15.hostedemail.com: domain of dave.hansen@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781290082; x=1812826082;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to;
  bh=htPuT7tm372smVg4DmgxAuibfc4nj8Gdpe5982tY96k=;
  b=iKK9OQjBQXk5h15fXQhA7Y76RaC+NkuL6Uxnc3UYMRzFpF2ZGEUx6qsM
   yMWVTd3q2LjNbQep1w1riROPlnAe64FZq+pgMrA/jPwE/zH00NI+j+z1h
   k/b69JbQFlfwdzSxaDUXuKZ6Ai/Dq9DzqaCjjjYc7LSMk50aY/C7/PCN0
   wPRmLg73lEys202ZiZqfPwPDs7yLeRq4PtLNuWXgwlQE9E7ynI/pdzt2p
   RsdS2bDPsZc1rd8hlwkBJKet4ohldzqB5SyJrEk/MqpY7eCq70hfHalyL
   xWOxgtPwTwKIUeqw14Q/wE5u4oj+gYuXRIGw/NuJy6pjBdn1tsl8QH+fE
   A==;
X-CSE-ConnectionGUID: PlyRr5eLTfy1FyKHluoKig==
X-CSE-MsgGUID: oyStVVN+QfSeJTR01qPrFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11815"; a="99703418"
X-IronPort-AV: E=Sophos;i="6.24,201,1774335600"; 
   d="scan'208";a="99703418"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 11:48:01 -0700
X-CSE-ConnectionGUID: u7hVGyS+TsGIOUmWJ6QcfA==
X-CSE-MsgGUID: efIcFitYTtOtCzU+B/fO/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,201,1774335600"; 
   d="scan'208";a="242515111"
Received: from aduenasd-mobl5.amr.corp.intel.com (HELO [10.125.110.161]) ([10.125.110.161])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2026 11:48:00 -0700
Content-Type: multipart/mixed; boundary="------------X9GYwTAIw7Vm1mltbbp0duDk"
Message-ID: <2da031dd-4442-45b7-9515-72ffc60e8d8c@intel.com>
Date: Fri, 12 Jun 2026 11:47:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
To: Suren Baghdasaryan <surenb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOl?=
 =?UTF-8?Q?g?= <arve@android.com>, Carlos Llamas <cmllamas@google.com>,
 Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org,
 Shakeel Butt <shakeel.butt@linux.dev>, Todd Kjos <tkjos@android.com>
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
 <20260610230413.D68967BC@davehans-spike.ostc.intel.com>
 <aipphZ5iCnbXVNSR@google.com>
 <CAJuCfpHmem_g7mEoic7O56LVSLkbftgWYgzexPWy7VSwp7_SiA@mail.gmail.com>
 <131c6a49-9177-418b-a653-8f13942fb8d3@kernel.org>
 <876077cc-db6a-4517-9d81-cdfbb43e599e@intel.com>
 <CAJuCfpFh60wULMkFc7hzxWNg+qmZ2R_HMw_QZe5CNcDRFuoN6A@mail.gmail.com>
 <e9e196ff-7428-43bd-8e06-dc2cf0628c9e@intel.com>
 <CAJuCfpFo_avdhpOviX7EsPqLgDJ3DfeGpth+yu1-ahfawqaSzw@mail.gmail.com>
Content-Language: en-US
From: Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAJuCfpFo_avdhpOviX7EsPqLgDJ3DfeGpth+yu1-ahfawqaSzw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EEAE9A0005
X-Stat-Signature: 3gx9jht3qwah1nfcxe7jbmxd7konxeys
X-HE-Tag: 1781290081-954575
X-HE-Meta: U2FsdGVkX1+cS3sf1/uhZ2Z2m76REXzU02Sw/3s3z7110v4AK9sqFX3Pu2L0XZkipwW/6mh+8SgxVfOjJy3dEPFSvyZNnZ4QNpBDK8LGQTKYYde2ZMiM8VyJ0w6uKOvoFY4FdJjKOQqL2KrqAicxDktB1uk7aYaaXUBU+aOvT/wk4iFFCxWZ0tSCKjxey07ufUmXwjfYigURQO4+79cA3xoSDeodM3Kb30OUDORlCbTTzckXp2ozkom3kQ3P1Vz/DQ6NNifbFBptUFxv62GGZmtkG0xokzHXNRcUuk2Ab5Mh1zYcBEwJ+s4xghsUjQmJXlbUYaWgEkrn0p+woLXh9ZY+PQaO3u8yZRh89huAafOLtUmq0zW1PgWEUiUSORvHn6lBDf/ffXvG520/fSF/a8qzNdxhVyVLtZyqgFttQSSX8Ofg594+dvrtUYv98ZonOOpsgwxIU5PG6vFxj/QgrA9b25fyH5fWAD/FN7dN+UGTbQEp99IMME0vLFryxGAZoS3pLFa0rCucdUBbdHRtihnZsYYYyCTHbKued3Ure/PQmTh17mExBLELdF4JRmRX1AcZWPEFGE2SszG6vxiWmG4H/Po0s2foSTLPybeGSXTqJdpjoaRd5dwTd4bicai/CAHx5tWNm3TCq+20xsuJSrSEXtEfhpqqLd8MJRFIl5G8hEt8mN4V45ueWLyGIS+aSpxi4leS9wVyneVk2uqEqqHa4Q015oPMT20zeYQZNzfPojV48eIyyCE78J9IMH2oK343IP/Gx0XRh7paIGL0oW4OgwR69Y4ZCaykIMLeHePgdg948t6ihfKC7B/Sp5w9Rl+JiPv5fC2C/hhEpDSFijS2XzzSaFgihxsGpJU1EFBtJa9g5A04Sm5xtj20rKkGwLZzdl++3rYLHNDWG1js/VBiCRXzyz2pdkuBAIrRUfFcqGsPG0gmVah7imFVBD+TvOvkKMOmlqRORbP1eJF
 iYW+vFsa
 7AcfJPZExEiHuUB5PsZqdrmIN+jQXqj23zLFFWFsNQmszQmsXSR3yD09fhupTwLK/9LuMSJxXGD4xnHQSxx47C2fDk/0U8iV7VsFqcbkT2PTZuPBieGV0niwqeLzaCLhVPF2ZBMe7X5S27zTqY8ebJqiBCNMP9XmSAVefbLYKl8LDmkVM/rYDZlD+LmVzV7m6YAoO/UcfOMUN9Ssa08lzWMMLyCKdnFMDhZCyA+cfcnJo7eAw/AnyzBuYdFDX2v4PFR2Ls/YwTksGjy9I9b52/udqm/i66b/BVN0JQSBAnWQp5mZmw/v2cjCRoOVG1LzCA+tvApI65iunh4sns/P3jrS2HGXmAZsYCmYODmRQATYP+bLoeVadtyEVSIEf/J3+DDDkF7+onAbC9/CCvQdUuat4tRf8r6mkddey85DDtFxGXOnH69PkJf9TK53pgpnN3ztH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------X9GYwTAIw7Vm1mltbbp0duDk
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/12/26 10:44, Suren Baghdasaryan wrote:
>> It's not impossible, but I do think it is irrelevant. Or at least that
>> the *VMA* is irrelevant in this case. binder_alloc_is_mapped()==false
>> means that the binder VMA is gone. It's not in the maple tree, and it's
>> not coming back. If a VMA is found, it's an impostor.
> Right, but before your change we were bailing out early. With your
> change we would be generating the traces and freeing the page. I think
> that's a functional change. Was that your intention?

Yeah, it was intentional.

I think the existing behavior is buggy. It also complicates the goal of
removing the mmap lock fallback. I've broken that behavior change out
into a separate patch. (attached here)
--------------X9GYwTAIw7Vm1mltbbp0duDk
Content-Type: text/x-patch; charset=UTF-8; name="binder-impostor-fix.patch"
Content-Disposition: attachment; filename="binder-impostor-fix.patch"
Content-Transfer-Encoding: base64

CnRsO2RyOiBTdG9wIHJlbHlpbmcgb24gVk1BIGxvb2t1cHMgdG8gZGV0ZXJtaW5lIHdoZW4g
dG8gcmVjbGFpbQpwYWdlcy4gSW5zdGVhZCwgdXNlIGJpbmRlci1pbnRlcm5hbCBtZXRhZGF0
YS4KCj09IEJhY2tncm91bmQgPT0KCkVhY2ggJ3N0cnVjdCBiaW5kZXJfYWxsb2MnIGhhcyBv
bmUgYW5kIG9ubHkgb25lIHBsYWNlIHdoZXJlIGl0IGlzCnJlY29yZGVkIGFzIGhhdmluZyBi
ZWVuIG1hcHBlZC4gSXQgY2FuIGJlIG11bm1hcCgpJ2QuIEJ1dCBhZnRlciB0aGF0LApiaW5k
ZXJfYWxsb2NfbW1hcF9oYW5kbGVyKCkgd2lsbCByZXR1cm4gZXJyb3JzIGZvciBpdCBiZWlu
ZyAiYWxyZWFkeQptYXBwZWQiLiBTbywgYmluZGVyIG1tYXAoKXMgYXJlIGEgb25lLXNob3Qg
dGhpbmcuCgpCdXQsIHRoZSBvcmlnaW5hbCBtbWFwKCkgbG9jYXRpb24gaXMgc3BlY2lhbCBl
dmVuIGFmdGVyIG11bm1hcCgpLiBJdAppcyBzdGlsbCByZWNvcmRlZCBpbiBhbGxvYy0+dm1f
c3RhcnQgYW5kIG5ldmVyIGNsZWFyZWQgb3V0LgpiaW5kZXJfYWxsb2NfZnJlZV9wYWdlKCkg
Y29udGludWVzIHRvIGxvb2sgdXAgVk1BcyBhdCB0aGF0IGFkZHJlc3MuCgo9PSBQcm9ibGVt
ID09CgpUaGF0IGxlYWRzIHRvIHNvbWUgc3Vib3B0aW1hbCBiZWhhdmlvci4gVGhlIG1vbWVu
dCBhbiAiaW1wb3N0b3IiIFZNQQppcyBjcmVhdGVkIGF0IHRoZSBvbGQgYmluZGVyIGFkZHJl
c3MsIHRoZSBzaHJpbmtlciBmdW5jdGlvbiB3aWxsCmFsd2F5cyBoaXQgdGhlOgoKCWlmICh2
bWEgJiYgIWJpbmRlcl9hbGxvY19pc19tYXBwZWQoYWxsb2MpKQoKY2FzZSBhbmQgTFJVX1NL
SVAgYWxsIHBhZ2VzLgoKPT0gU29sdXRpb24gPT0KClN0b3AgdXNpbmcgdGhlIFZNQSB0byBk
cml2ZSB6YXBwaW5nIGRlY2lzaW9ucy4gSW5zdGVhZCwgdXNlCmJpbmRlcl9hbGxvY19pc19t
YXBwZWQoKS4KCj09IERpc2N1c3Npb24gPT0KCkhlcmUncyBzb21lIHBzZXVkb2NvZGUgZm9y
IGhvdyB0aGlzIGJlaGF2aW9yIGNvdWxkIGJlIHRyaWdnZXJlZDoKCglhZGRyID0gbW1hcCgu
Li4sIGxlbiwgYmluZGVyX2ZkKTsKCS8vIHBhZ2VzIGNhbiBiZSByZWNsYWltZWQKCW11bm1h
cChhZGRyLCBsZW4pOwoJLy8gcGFnZXMgY2FuIHN0aWxsIGJlIHJlY2xhaW1lZAoJbW1hcChh
ZGRyLCBsZW4sIE1BUF9BTk9OWU1PVVN8TUFQX1BSSVZBVEUsIC0xLCAuLi4pOwoJLy8gUGFn
ZXMgY2FuIG5vIGxvbmdlciBiZSByZWNsYWltZWQKClRoZXJlIGFyZSBwbGVudHkgb2Ygd2F5
cyB0aGUgY29kZSBjb3VsZCBiZSByZXN0cnVjdHVyZWQgbm93CnRoYXQgaXQgaXMgbGVzcyBk
ZXBlbmRlbnQgb24gVk1Bcy4gQnV0IEkndmUgbGVmdCB0aGF0IGZvciBmdXR1cmUKcGF0Y2hl
cy4KCi0tLQoKIGIvZHJpdmVycy9hbmRyb2lkL2JpbmRlcl9hbGxvYy5jIHwgICAxMCArLS0t
LS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDkgZGVsZXRpb25zKC0p
CgpkaWZmIC1wdU4gZHJpdmVycy9hbmRyb2lkL2JpbmRlcl9hbGxvYy5jfmJpbmRlci1pbXBv
c3Rvci1maXggZHJpdmVycy9hbmRyb2lkL2JpbmRlcl9hbGxvYy5jCi0tLSBhL2RyaXZlcnMv
YW5kcm9pZC9iaW5kZXJfYWxsb2MuY35iaW5kZXItaW1wb3N0b3ItZml4CTIwMjYtMDYtMTIg
MTA6NDY6MDYuNzA0NzA3MjMzIC0wNzAwCisrKyBiL2RyaXZlcnMvYW5kcm9pZC9iaW5kZXJf
YWxsb2MuYwkyMDI2LTA2LTEyIDExOjM0OjE1LjMwNDQ2MDUyMCAtMDcwMApAQCAtMTE2NCwx
NCArMTE2NCw2IEBAIGVudW0gbHJ1X3N0YXR1cyBiaW5kZXJfYWxsb2NfZnJlZV9wYWdlKHMK
IAlpZiAoIW11dGV4X3RyeWxvY2soJmFsbG9jLT5tdXRleCkpCiAJCWdvdG8gZXJyX2dldF9h
bGxvY19tdXRleF9mYWlsZWQ7CiAKLQkvKgotCSAqIFNpbmNlIGEgYmluZGVyX2FsbG9jIGNh
biBvbmx5IGJlIG1hcHBlZCBvbmNlLCB3ZSBlbnN1cmUKLQkgKiB0aGUgdm1hIGNvcnJlc3Bv
bmRzIHRvIHRoaXMgbWFwcGluZyBieSBjaGVja2luZyB3aGV0aGVyCi0JICogdGhlIGJpbmRl
cl9hbGxvYyBpcyBzdGlsbCBtYXBwZWQuCi0JICovCi0JaWYgKHZtYSAmJiAhYmluZGVyX2Fs
bG9jX2lzX21hcHBlZChhbGxvYykpCi0JCWdvdG8gZXJyX2ludmFsaWRfdm1hOwotCiAJdHJh
Y2VfYmluZGVyX3VubWFwX2tlcm5lbF9zdGFydChhbGxvYywgaW5kZXgpOwogCiAJcGFnZV90
b19mcmVlID0gYWxsb2MtPnBhZ2VzW2luZGV4XTsKQEAgLTExODIsNyArMTE3NCw3IEBAIGVu
dW0gbHJ1X3N0YXR1cyBiaW5kZXJfYWxsb2NfZnJlZV9wYWdlKHMKIAlsaXN0X2xydV9pc29s
YXRlKGxydSwgaXRlbSk7CiAJc3Bpbl91bmxvY2soJmxydS0+bG9jayk7CiAKLQlpZiAodm1h
KSB7CisJaWYgKGJpbmRlcl9hbGxvY19pc19tYXBwZWQoYWxsb2MpKSB7CiAJCXRyYWNlX2Jp
bmRlcl91bm1hcF91c2VyX3N0YXJ0KGFsbG9jLCBpbmRleCk7CiAKIAkJemFwX3ZtYV9yYW5n
ZSh2bWEsIHBhZ2VfYWRkciwgUEFHRV9TSVpFKTsKXwo=

--------------X9GYwTAIw7Vm1mltbbp0duDk--

