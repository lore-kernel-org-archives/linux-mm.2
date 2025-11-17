Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2522FCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 18:27:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4D08E0011; Mon, 17 Nov 2025 13:27:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78C5D8E0002; Mon, 17 Nov 2025 13:27:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2F08E0011; Mon, 17 Nov 2025 13:27:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 57FEE8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:27:41 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03597B6BB9
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:27:40 +0000 (UTC)
X-FDA: 84120932322.23.1462485
Received: from mail-24416.protonmail.ch (mail-24416.protonmail.ch [109.224.244.16])
	by imf19.hostedemail.com (Postfix) with ESMTP id 13FE51A0007
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:27:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=DweFroUb;
	spf=pass (imf19.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763404059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhZV33r+RQPxcvac5lYHFWgWQCGcX9mvWrodK8gvvLc=;
	b=U8PwQlnfoAthRIFR4sG6fBPSujH6DJIoK7r4tqAv9HHkhEtucbmYnK/6GfFYS8v8FTmdVl
	w9bnShoCFgL+VNdLSndo/qLOXbO8Uaqz5ESHpSQPoi0SnRuwD7Y2prd5P/iyge/0iO8aZt
	iJtDk2owRpnt3B0S6gunErSsQEJaPzc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=DweFroUb;
	spf=pass (imf19.hostedemail.com: domain of m.wieczorretman@pm.me designates 109.224.244.16 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763404059; a=rsa-sha256;
	cv=none;
	b=jgQ26zwk2qCjrNplRaiciV58sNU1Y4uiPevDQBZLgLCN6H5m+w7G3KSJMjqsFZqcGyBogs
	ceu5U8XyU3hy8Z4B2ne/eTflQAJVpffFmc4RHO18papWcsNbtNVfWEyr11VBGQB1smgIha
	KQGQaNrBJb/krn1lU6XmIGfLjDasNCs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1763404056; x=1763663256;
	bh=GhZV33r+RQPxcvac5lYHFWgWQCGcX9mvWrodK8gvvLc=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=DweFroUb8uo4PK06n5Wl5fGwhojNY7QszNM7iXFG7EjKvb9GqP59Kp/IQVSd6dPIJ
	 R7xxMHHCAwnSFusvt8q2csjYAnTNj7gxTwpSolPMogoyXE1bKL5u59danvmqUqUSsW
	 ToI+LrL+YK42ZNbLleg0ht45BloqOHxM4ZxDO28CNG8x1K77NqVV+E0+CSz1W7GJ+E
	 G9cevD3xQv7zY3CPjIyxwGsAor1t4RqqX8yW0KcAQ8ltvE2rkXrE4mpVgKNS9IWwkW
	 fCiVglPffu/+YMy7EF5QrRXfFB1LgpMKvFSBFDcfQzPr+6ef7H8a06OPSOjaENJcHG
	 sBL89XwygkdmQ==
Date: Mon, 17 Nov 2025 18:27:30 +0000
To: Alexander Potapenko <glider@google.com>
From: =?utf-8?Q?Maciej_Wiecz=C3=B3r-Retman?= <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, ardb@kernel.org,
	Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 03/18] kasan: sw_tags: Use arithmetic shift for shadow computation
Message-ID: <zxn3unp5foytltq6xpzqmsuijaargjuigcu47fdvlhpgyvwfj4@zwcnws34hjfw>
In-Reply-To: <CAG_fn=XyQ5Mc_ZvsibN4K0r70xfDAkhPqUJgtojVRcgTt-q0WQ@mail.gmail.com>
References: <cover.1761763681.git.m.wieczorretman@pm.me> <ab71a0af700c8b83b51a7174fb6fd297e9b5f1ee.1761763681.git.m.wieczorretman@pm.me> <CAG_fn=XyQ5Mc_ZvsibN4K0r70xfDAkhPqUJgtojVRcgTt-q0WQ@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 6ca281a9780caa8602cb87e0c0e4e958f247dc5c
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 13FE51A0007
X-Stat-Signature: fy871ow4srcmkp45uydmqtgpdfbirbqk
X-Rspam-User: 
X-HE-Tag: 1763404058-824323
X-HE-Meta: U2FsdGVkX1/rk5/8hKZdStm9YDLQVZzrZU0KOLCRB1/AZCgzC/CusNvbXX9i4MSkc4xqZeK0/OQe9qaK4HfRJpot2AC6Kn/SjgDRq4isFms7FxYBF42TJvs+4caw91YeQ8inDjgcmnSMDLkY7x87Gt8bpnEOfaoaZNPPVXUowtmbN4vRYSorDpFN279BO87AWEKvxrIy0QghhEcmy63e2mk1L7FZNhe9oNdSaNq9bJL/2OVXUULP6NdiPJrVkWvCHlnU+hd+TQcjZf2/KAOPxiFw4geVUgJQ5ZBYl9GxvLwTQ37a7FhtGO+qs5WcyvDJDvuJwD1ZEE2PiVmiX2iFGl9CYDtj6UQBgwUyKFHH1xh87SLFzBUeiU0Dy60MZBL9NGRfbJgo7PTrJ3ppUcV71Q7NPKpoprHvflt8wIMeQLLn0Agvg1Aq+o/1sIQniPOx+vP57xpg2LY9BFUzPsIuX50fAibpl6OHqazDuROitq8N1tV2yGrr8PkphIr8BcmDU+cVEf5nZqvW8i7VGJtHxjtNY3SXIZqZkGXt07H69eOE9LZrXB2otwRYcyREAkOAqU0axdy6BhR6UeGQF1KR/q9ca6TW9GXPh5s4SHps25I/11emnSyP4mrniZaDS38UqUJm6kJ5CczlAZIsPj/N6iIrR3xgxD9zSbbHOglrNh4f+e5FHfpaX6HNqm5fsvOxxas9uyf5xJzyWLdgLzz00FM7/JOvfVFNUhmLTeladJBmpuuKvNmxbxBMUsIUI+E5Necy3VPnYSlkrL8OLURYN5uOjS26ck1/vQdgvJRAH/N2/UaBInBv70dCRQd2WW6tNYbX422Y19Z/E5aj41iRxLzrxBAI7wYQp2stWw2DZd0heqdijhc5+yYBmPkGEECX/yn3xdAbgz+tBYJe05XfJrQSbWvXbltX1CUVA8kzny8k2N0GOycJ5gZsdn08RsTpZN9cJz+Tq7J9wrBRDyX
 NfEBtX23
 C2LXRH+zDlid6LW0NaDnx03VLW4FKGrwTVh+CS1Dl6Kw/xZ2wWmifQ+x1Vl8y5kEFvv6dCsEAusG9n5Y3o+zAFc5mj6osKqtus3AfTvWqx3Wg5v6T445bEPAfnDSaf/afYn5fP1ij2UbJHbsnFE30SQaS2f8ISwV85u8VHQFad8s14LID8bwdugx0Myqvxd/mtxy3g0KjgKZPvF8zose7FhEUG7RPCi8KTrKCngnKr94weJLE44szMkIYeCZ1B7+ia78ImZy5W3J9LcZ28RcoM8gxYz8MdRjJ8dvowATq7yI7JMYZA8CC5g8Dicf7yjnP7maAlpv1AHKFDw85/CTXuJz4PPhLeo8Cx+6Eex1cqV6Y270aZfffQNJHz7aDVR4dwFeEZwmBdPF5KCk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-11 at 10:39:12 +0100, Alexander Potapenko wrote:
>> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
>> index b00849ea8ffd..952ade776e51 100644
>> --- a/include/linux/kasan.h
>> +++ b/include/linux/kasan.h
>> @@ -61,8 +61,14 @@ int kasan_populate_early_shadow(const void *shadow_st=
art,
>>  #ifndef kasan_mem_to_shadow
>>  static inline void *kasan_mem_to_shadow(const void *addr)
>>  {
>> -       return (void *)((unsigned long)addr >> KASAN_SHADOW_SCALE_SHIFT)
>> -               + KASAN_SHADOW_OFFSET;
>> +       void *scaled;
>> +
>> +       if (IS_ENABLED(CONFIG_KASAN_GENERIC))
>> +               scaled =3D (void *)((unsigned long)addr >> KASAN_SHADOW_=
SCALE_SHIFT);
>> +       else
>> +               scaled =3D (void *)((long)addr >> KASAN_SHADOW_SCALE_SHI=
FT);
>> +
>> +       return KASAN_SHADOW_OFFSET + scaled;
>>  }
>>  #endif
>
>As Marco pointed out, this part is reverted in Patch 17. Any reason to do =
that?

I hope I was able to answer that in my reply to Marco


