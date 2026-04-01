Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A48BD10F9318
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 02:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D404F6B0089; Tue, 31 Mar 2026 22:47:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17726B008A; Tue, 31 Mar 2026 22:47:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C53F56B0092; Tue, 31 Mar 2026 22:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B85306B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:47:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 40BF61605D6
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:47:51 +0000 (UTC)
X-FDA: 84608451942.17.8D6E304
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5851C160003
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:47:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CFaEf11v;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775011669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CukHr5iu9h+eVEsN1hruv3LZlxiR3whhorbvL1gsP6g=;
	b=U7RYYYJKEmiKzZFiGKnWWMaabx6rVECvMKsMSgF8lgE1+KUQmT42r/1/kW9ydWYue5i8Xv
	kwNQiAp47lUSCtLwAIm8cuTwL99gzo9sVoc6FqKOThlGRYbO6RP+B972M0LCiTb/X8ibXK
	27pRjlmRBbez2DYgiHRgqHyDkmkaMHQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CFaEf11v;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775011669; a=rsa-sha256;
	cv=none;
	b=iVAol0jy2KlakpOiN3Ly+jYrHtp/9Db+JrUZIWfBRmxscP0hbC5b2lIQPFhjn/zMzs/EBb
	K/4ZL2FJP6ztBasxgOCe+Pz6/x2FMUDLbRcPkD1cUXRjJEh0CL/2riDbNMKSiofZohDug5
	HdZz/YnceELnPgsmMZUAC/1svzotDFA=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775011667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CukHr5iu9h+eVEsN1hruv3LZlxiR3whhorbvL1gsP6g=;
	b=CFaEf11vAIM+Q1ildXdtLdEWJOJcvrAttxpq+jrrWS7fCZTZVm3n7d4nyovGUW/KG9zmIc
	cmpp0sRwnMqwtvSPgh3+hHJ8ohCbJ+QU8Om0pzjVbwcjEbUmLIqP6/QNVyUc/ItBP6a49d
	1sJDU1kKbyiGgTXfTQUKsKdMDKGV0m0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <29442561-9426-4635-9b7c-cdd138076127@kernel.org>
Date: Wed, 1 Apr 2026 10:47:10 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <songmuchun@bytedance.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Petr Tesarik <ptesarik@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A75367AE-4459-4C17-9847-E1963849C3BA@linux.dev>
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
 <20260331125529.de4deb7b46239fb13e4be517@linux-foundation.org>
 <29442561-9426-4635-9b7c-cdd138076127@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 5851C160003
X-Stat-Signature: s1j6oryj545rmxjq96ahpksb5srbdxje
X-Rspamd-Server: rspam06
X-HE-Tag: 1775011669-754747
X-HE-Meta: U2FsdGVkX1/+FNWnaoeiw17mxhyVLJpzbJHhQvJXFJjxM5NQ7yCDsiP2NKHMViIQ/jIIpv6ohThqzFo4GnNbCUpg+ZtXnSxUb+mGlbON1XS2/Tcyamqrs6kgQOV36+5hHuUgBEijPj774WTqSwmyEF1aR0A4Z5upZ1OWkINGUSCdPraKhuPwrHyAB9jwBhldt8aEt4rH6XhJc0uMeMyxOjb20RiSGs/8KJnxvRGJyGTU+QHtacDdU3uyXNV77AW2KCsR7rppnNtbgV09qfCRMGC20+QQoh8Oc/ObZltoLmS/cEuY59Ab8FAXhNOEhS7gDRRgQQgUrIkj3BQR0wQfKwuFM/QrKbIpnMhaPzIDo/ozXeTEyqUDvjUwKyE5KnfhkFLUoct8AtKTj9DPSxtynrF1GTeNco5J6xrzAy1++9MdCxz/Dyvp50OSraoJLXk8e8RCvSrK/YunWyU4+/OeMLOvAPRWM2oM0OaDZx3WDW1LK1TR5ot19SePyNmHLc7p53UV29RT2r8jQ1hdt03Az5qDBVevut2BHpjEsUwYsMoPQ4YvlVV6tNb0YgMXFNVDMDXRPzYJ0ijxTwb7+oISjmQ0SNITuF4WMiyXovcOSdgGeO8FaFiCc5Oe0MoSJH5bbEyG4AO1YHHIZjVlnEaRU1jY8OryoXreSSKgp7g6xrWvJz99AOvxfJTbgD0oSQ/UYhCPklbldI3dc41xcvk/flRN2kf7fHqUDT8sQTP2r352YZxXRTVcs6LeVX/EZVvCey9izxyMCwnN7uCJmQJFtgk3qE1d0U/auoYx1CNdnaqLgbVVn7cUqJ318EHNdwnMAVwi2c13jLb0sOMNRg4SGW1lL72XQelq7n5+5i0D7F71cIydux/IDk6shw8rQCwcG0PswjovSTu8U0hKW8RzhxHk+gxgR/IaNMSUDzg69TXwiOOeorTUp6iXzXhSmVYmQ3jrLVee6JAyPslclJq
 teJ6D79h
 oLiJJ+y5K3/IB3nwR0W+mEQYSPEK2H/F5Fh/R1YMQ2Q2WsmHEe3mzRjZWwz3zQKC2yupAF8rDoeqsJz/vwQLaR66ktx92hypq3oSBB4aNFEJ7GdFMgAmLKjVNJ1bA412pW/3iyy5kKN60y3IxCBG7ng/pLImLA+Kbiaiu8CehF9UljRqJIuiGHl6KAjOZTLzXQqawdwToL326XHRWUVneI5EgBIhrf7W5/S6ZjZCrbI6/WjeWtuf7IntbxouJ4ZCgSA3CdKkfI+pEUh2xzrEpRFPA+UcMydAlSWXtqsBja11HbnwBM+meynq1JBlb0dmvxNOMbhVWOr4YaQY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 1, 2026, at 04:04, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 3/31/26 21:55, Andrew Morton wrote:
>> On Tue, 31 Mar 2026 19:30:23 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>>=20
>>> The comment in mmzone.h states that the alignment requirement
>>> is the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT. However, the
>>> pointer arithmetic (mem_map - section_nr_to_pfn()) results in
>>> a byte offset scaled by sizeof(struct page). Thus, the actual
>>> alignment provided by the second term is PFN_SECTION_SHIFT +
>>> __ffs(sizeof(struct page)).
>>>=20
>>> Update the compile-time check and the mmzone.h comment to
>>> accurately reflect this mathematically guaranteed alignment by
>>> taking the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT +
>>> __ffs(sizeof(struct page)). This avoids the issue of the check
>>> being overly restrictive on architectures like powerpc where
>>> PFN_SECTION_SHIFT alone is very small (e.g., 6).
>>>=20
>>> Also, remove the exhaustive per-architecture bit-width list from the
>>> comment; such details risk falling out of date over time and may
>>> inadvertently be left un-updated, while the existing BUILD_BUG_ON
>>> provides sufficient compile-time verification of the constraint.
>>>=20
>>> No runtime impact so far: SECTION_MAP_LAST_BIT happens to fit within
>>> the smaller limit on all existing architectures.
>>=20
>> Thanks.  So this can fix the build on some arch/kconfig combinations?
>>=20
>> Do you think we should fix older kernels?
>>=20
>>> Fixes: def9b71ee651 ("include/linux/mmzone.h: fix explanation of =
lower bits in the SPARSEMEM mem_map pointer")
>>=20
>> Eight years ago so I'm going with "no".
>=20
> IIUC, there is nothing broken. Could only be revealed by some new
> architecture.

Or increasing SECTION_MAP_LAST_BIT for powerpc in the future.

>=20
> So no stable :)

Absolutely right.

Thanks.

>=20
> --=20
> Cheers,
>=20
> David


