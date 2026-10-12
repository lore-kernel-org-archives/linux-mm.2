Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12C9BCC6B02
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 19:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2572E6B008A; Mon, 12 Oct 2026 15:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2084C6B008C; Mon, 12 Oct 2026 15:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1249D6B0092; Mon, 12 Oct 2026 15:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E776B6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:25:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F3F4120ED9
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:25:18 +0000 (UTC)
X-FDA: 85314952716.21.B53B517
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf20.hostedemail.com (Postfix) with ESMTP id 476C41C000C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 19:25:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026092801 header.b="kw4mNG4/";
	spf=pass (imf20.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791833116;
	b=O6PRWS+zQWffkKpPFtGwmwZOZrZLeDUmbhHFkHSOV1wRDujjUhvBuVObuquIWRseCiAbMr
	tXs/wz5EHGCkVlMQoy0Z23GWbWgXG7kYhnS0ziYR2yANSFOvkO7TiXo1mGDHEtQWES654b
	7tq3VayEBxUp8NXZln5LNMOC7gCZaX4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026092801 header.b="kw4mNG4/";
	spf=pass (imf20.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791833116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yAoccG/LTttD1h9L3r5SW6HRQUuXcC+JCP51wkvLU30=;
	b=MxUnEObHR5iCA0PblsrXvA9RuGteoNJAduraDjnoHKT9S8P7/z7PbT6qbIk/6D4bZgxgSF
	KaaPi9LIvgJM/KWxMRbRIJKWXvUsmZbs8kp8VD+yUuHa2PURLzQ62tsbaWFa1Vq+f5KV2Q
	EReF9ryAQAB4Nekt1v/cuk8zokZZgSw=
Received: from ehlo.thunderbird.net ([172.56.213.145])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 69CJOuGE954325
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 12 Oct 2026 12:24:57 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 69CJOuGE954325
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026092801; t=1791833097;
	bh=yAoccG/LTttD1h9L3r5SW6HRQUuXcC+JCP51wkvLU30=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=kw4mNG4/7IHPtMe0pOKvp2osW858vqnhSfpRr9iX0ZyOkNdJogL4o8ji2nwY8jMz/
	 lYWcj6WrTraRc0VLGkb1nxEMVnxvNxg6X92zh5FnrqLhUcRLLMuE7w6IJs5oyfk3PV
	 dL1d3g7OXf0jmWaDZ4b/7m4sx0w6wRN54FWnq+e/4nu06IMhSShNVK9HXvrlh6GmOO
	 Tr0DwTrhkKQb9USemmPYmdfdqLOa0d4EMoI71Z9w0l3WSdn7YRldXUZXnHwen0OADj
	 WsvJ1MZFc6tTjuUqGZuqibzF+cA5MmTC4lGNhSEQ9PDRJm1MJE4NAhqE/MOt0dF+KM
	 voMzdj9Wqw3Ew==
Date: Mon, 12 Oct 2026 12:24:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Borislav Petkov <bp@alien8.de>, Luiz Capitulino <luizcap@redhat.com>
CC: x86@kernel.org, tglx@kernel.org, mingo@redhat.com,
        dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
        blum@kernel.org, david@kernel.org, linux-mm@kvack.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v3=5D_x86/corruption-check=3A_Remov?=
 =?US-ASCII?Q?e_the_BIOS_memory_corruption_check_feature?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20261010194519.GAasqVz2brXiOLegQi@fat_crate.local>
References: <20261010153604.1885381-1-luizcap@redhat.com> <20261010194519.GAasqVz2brXiOLegQi@fat_crate.local>
Message-ID: <33A35EDB-3AD7-4F29-85B1-4D9C9B41C874@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 476C41C000C
X-Rspam-User: 
X-Stat-Signature: fcpy4ngttjuuujywtfe7ias4hfr4gbmp
X-HE-Tag: 1791833116-378317
X-HE-Meta: U2FsdGVkX19V0Vd7H98eDHqOU6QyL06yEkBzqLg0Y/dHblxb5mez2aGBgyK/oNTANd+t7mPR1ECCIN9aoPzJe407aV0bMZddxlOpiKAVzhb1ukFs4EkX/wpGUZVOnGTqoUKYN/4hNIEIVd/lj1X3PpGSatx6WdkW79WouavXslKA5Q8sBZwPuZ5dEThljYZ3FH8AYAkUHu5NR63QQ+D2NTTXYeY20VgH2gx/pYpeRSUMy8DIvmGvCfn+ttAHWXMCv6uePpTLWcD9Ad4wkvwff98CovWSt0Vzy94Q6mGRamrcFaJidAUZP/UfVwryuRRUNK+ifRXPv3kAhpyDN5TiX9E/fkHqML6cF8QtZ+Z+Vnm0dxDLeHPqZUyhLg56Jm5gvOWvXRkxK8Pmd1OSL9A3JG0qRFqYJN83aX4HmsqYGeUBMCUC+tit+WTCEitsec8C98RtzEyb5mbn7qCsF83GGSxLdAazmQWO3cP2e2xKDQ4cXSt3vBxbBE5HObMvze3gbx7JhcqCiF3SEtxqgx5FXY2Tul1j1PtCx+d6xHDicNOyiqw8oXzWNQa4m0/BNnBLrPHrwGa1mw6iQd/7f6Ho3yp1ye6a7cBGyecY1CCYWB6kNHHUTKzL9h0AaxKvuyMohCmhWtqKOGef/zrIqNf5MGlSnmfMhLfWPh4GEB6RVtm3rFBHgLXOibznj8u1HCyk0U6YG0iM9kbgfdXLaQvdkxUvODObyHj5pO4ZAsLGJjlNSBKgOJ9DI6wcnSpIUuJTZl3n1xPFPC48R+HrRf5eBD3CVAuTUzI/3vCTTnvpwQIN2o04tLf44wcvxguYikRL5RobqJ+pYyRgNw93PMY6maXYjj9u18FHOXcj79fNo1JfclzX7sp/jAhITmtRN6oPTETptEJ5mN1slTFNmMDdY41GX1gxGNW2WgdfiKUg3lBxONM5SXT0VVNViR5pIFfoXrSkXZZR4ahOJMtaofi
 rhr4GS9s
 VBcBXrpIF5U52HkHE651bB2A52WoEOq7aZviFgK23ZN4KFxQ4o/TgzcdNVXUk7XDGu/aXmdceJ3BL3mjcSTrmniHbakCwPWFvRFpa/G9awPeJiukjq8Lx1N8JX8miDsFc267yGg8MuE24HhjUtj4fcM3tXRAlb81nwqvTe64JDqNQ1CqeaX/1jO+VNx+BbrbcddegLbS7VkVTPb0u9Ly7f/RpHOjYje4on1VHWlpHCAfmyg9acYK9JatIEkWGNpDoSVZQ8i2t67+3MQs5PYSSBMMsltUQBf672jgkI44j4wY9oZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On October 10, 2026 12:45:19 PM PDT, Borislav Petkov <bp@alien8=2Ede> wrote=
:
>On Sat, Oct 10, 2026 at 11:36:04AM -0400, Luiz Capitulino wrote:
>> By default, the BIOS memory corruption check works by reserving the
>> first 64 KiB physical area from memblock, zeroing it and then scanning =
it
>> periodically=2E
>>=20
>> However, this functionality has been broken in its default configuratio=
n
>> since v5=2E13 by two commits:
>>=20
>> - Commit a799c2bd29d1 ("x86/setup: Consolidate early memory reservation=
s")=2E
>>   Moved trim_low_memory_range() into early_reserve_memory(), which runs
>>   earlier in setup_arch(), causing the first 64 KiB to be reserved (whe=
n
>>   CONFIG_X86_RESERVE_LOW=3D64) before setup_bios_corruption_check() run=
s
>>=20
>> - Commit f1d4d47c5851 ("x86/setup: Always reserve the first 1M of RAM")=
=2E
>>   Hardcodes the reservation of the first 64 KiB early in
>>   early_reserve_memory()
>>=20
>> It might be possible to get the default case to work by allowing
>> setup_bios_corruption_check() to run first, but it's just not worth it
>> given that the kernel will never access the first 64 KiB area anyway=2E
>>=20
>> Lastly, note that it's possible to get the corruption check to work wit=
h
>> a different region by passing memory_corruption_check_size=3D=2E Howeve=
r,
>> the main goal of the feature was to check the first 64 KiB=2E Besides,
>> the region picked will be almost random as setup_bios_corruption_check(=
)
>> will pick a region by size=2E
>
>And?
>
>Do I want this or should it be fixed or the first 64K are not worth it to
>check or=2E=2E=2E?
>
>That whole "rationale" is not really clear to me=2E Yes, it is broken,
>apparently=2E So let's remove it but we might get it work still=2E=2E=2E =
So which is
>it and why?
>

We aren't using that memory, so there is no point spending the time scanni=
ng it periodically=2E

