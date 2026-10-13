Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F69FCC6B10
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 06:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364EC6B0088; Tue, 13 Oct 2026 02:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE8B6B008A; Tue, 13 Oct 2026 02:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7816B0095; Tue, 13 Oct 2026 02:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8CB66B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:26:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B51DC0AA6
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:26:43 +0000 (UTC)
X-FDA: 85316619486.24.C1928EC
Received: from mta0.migadu.com (out-114.mta0.migadu.com [91.218.175.114])
	by imf07.hostedemail.com (Postfix) with ESMTP id EE51640002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 06:26:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u9i9HxGs;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791872800;
	b=2T9ZdfbQHAVwlogonytwfm0J+XrCxOSjb2Uh9c9ftLVsSK6SD7C97/xj1jAjIGyAKJs2M5
	d+5D8QuVbuvrr8NDezDxaBLo3DQVmat1ep+g5awQJoNjltc0vOhzawCyk5DjxRkZQ+AzMo
	jqzW/X4jhb0EFcdwYDrHltu1Fe8GlwU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u9i9HxGs;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791872800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7rcTAWmSs4EiZ5IagojymObpWqOsu5m5rrwg8mIm9g=;
	b=MXJZHosKEURbpjniFaAhNkY1/wj97aUC6NDH4c+RGzIov1CN6tl9fbEBcerw3O7lgtoCiZ
	NHW+vzkUfDGaiwFEkBlfMcPyX03j8IZ232TC/3L4kiAE5XdjsGZ0YHOEgfrRsnwnt9DX9u
	dn5w7XTVDlT2lzI5K70LwWC2zwdHgbE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ijzhhCvBzPeAT3SqmYXHx89D90VBI7qukSZjs8T278I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791872798; v=1; x=1792477598;
 b=u9i9HxGsO3x2RvdZiMo1y0Po1scVIFQibDJHRCRougUnPXM9w7PcUAd1D5oZEM5Q58NsF8KY
 CTMpA5sg+FfSAq+7QglTMJahRbZKRUojynG++lked1XiHGWAQoySDRDBtF72CCpb/hM08/hxCum
 JrAENks08xw5/XfDhdt0Xc38=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id afbacc7007ea9f8d;
	Tue, 13 Oct 2026 06:26:38 +0000
X-Mizu-Trace-ID: afbacc7007ea9f8d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 1/4] mm: fix missing page-table destructor in
 pagetable_free()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261012202532.f059fd5ab947510a21d34cd1@linux-foundation.org>
Date: Tue, 13 Oct 2026 14:26:15 +0800
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Dave Hansen <dave.hansen@intel.com>,
 Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>,
 =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Alistair Popple <apopple@nvidia.com>,
 linux-mm@kvack.org,
 linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1F709D85-8F18-4237-BA0B-BE8442DD221C@linux.dev>
References: <20261010112457.49485-1-songmuchun@bytedance.com>
 <20261010112457.49485-2-songmuchun@bytedance.com>
 <asy-b7_C3SjnmSaS@gmail.com> <145CD5DC-6457-4E1E-8B9D-AE7D1EDB0AB8@linux.dev>
 <20261012193114.77147e0a43affa8ee1ae896c@linux-foundation.org>
 <200A83B9-233C-44C7-B4AF-0900BA1E09DF@linux.dev>
 <20261012202532.f059fd5ab947510a21d34cd1@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE51640002
X-Stat-Signature: ss9job67m633gsfiamigf7iim89k9p6u
X-HE-Tag: 1791872799-551947
X-HE-Meta: U2FsdGVkX1/cm8c0c+DYtd6j/ZfLaZ+5oXT7LXqDqAPx1pqRSi3dIkm6OBbzRJny/woCUpSyozsh+b+DF7cftZmenHnNJtjZnfinR+R+WzPDzSHNWPf/a9r11ejMsrpjHve3+K4/ASf2jbfIgZhHtl42Cev3WfbYXApu2Y7gYOXZLpvmN3X13Z/zviOAsGdYkOnBhSgpYZZybaI0ZfDa3155jCM1rUvhvXIkdgEsZlnZ6YNHM7MBD9w41bWnOdrkNqTsHg551Jcsi27guiXLveHEoTtYa0PQoxsDQBNkvE8NFhbPJFBJjHynNKdLORrw/zoE8+F0iNWpuoJJKK8ZCCrX3mws+1tJvlXQVhsnv/xK9PzvzUjSDzxEvvZ+u4UTcyUZTWY2CfNaOZTHzPbGSDP3OAgNYN+s97XhL9rUuzdjzh8x0E2WBuqWCzKHY9XKumdCH2iuwXBEdFKu601Hd0ndyrd8npQIUp1CLf/PrgoSgzBanQrzMmPDun/ey4RLG/ApZMUat+G0DT8J0qabFSCzNros8HSOTFVJeZwVdayOLT/1dnRXDSHklrbsAx0XfwgSqjMMCSyFdhY7h//Dt78StGvtdSZ79hWYSkV3N531yieR0bjR2/7nVwYDLirinUJKZq8GLZZMLO35ZwUb/nS/JdULXjneQ/fa91EEjqZfQLwroxjwZYefWJlg8Bg1a4JH7dqFkvNXEbIySwO6DyNXLYa80Znm0+tPn3RXcBBfiJgJka80lROSYU377vGD6c0yerm8MYdYMjA7KAefx+kyQo1iJqin4fvQ5okaPfQeJDof12kTzr3cySQ9hjRXiKalj2Z4/0e/DbT+tWiEiSbCuIEe9Nm/xDRfuL7tRhOZRHBCIPYhs+/bJ4HIxTypmcgKE8nYysDOUvGNf5FQCHqxlw65qF9h5yhfPQgVubYM+tCYhKmRmgvWccLF7klUe2gDG/GCw75lLUzuCAc
 qSfnkJj7
 dqBqO2kKNnv64CI2NOIt5/MjW/+wGO+cC8ldJ9vI58qMInAWjSSbgOyIyuSSoE1diUHuNAecyWIE7iN07Xy+j6TavFP+64lK4nU/D4h616KhfMrCzRIw3X+ENapsU8I+VCGiJbXHaeAA1oHq2fWsidcWT5eLcvH+MgyJXAsGd/uNqSzhaMxp2u+WTRYQulQwYOpaSKHdUbvelmw+elpuR/XOQ0C9N+uU6c/IuG2B4tuOVnropVNPKLJx6kVd98X/FiEd4+yOyQrtFN9ms1hvGdHypYFRXtFWmSVxdBCwezc/975lJBdOeei20nx9NPfgg0eqKSb5oU/hUcnazXdYr7mlZnwje3algn00Rr0eaK/W58thqCikxjIKXOEqpWaKKfE7PP9cgPVXOjEYofU0aPdcGXv6SXy9z3M2k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 13, 2026, at 11:25, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Tue, 13 Oct 2026 10:50:21 +0800 Muchun Song <muchun.song@linux.dev> =
wrote:
>=20
>>>> The correct trailer is:
>>>>=20
>>>> Cc: <stable@vger.kernel.org> # 6.16-6.18: bf9e4e30f353: x86/mm: use =
pagetable_free()
>>>>=20
>>>> Andrew, would you be able to update the trailer in the patch when =
you
>>>> pick it up? If there are further review comments that require code
>>>> changes, I'll fix this trailer as part of the v3 respin. Thanks a =
lot!
>>>=20
>>> I don't know if/how the -stable maintainers handle a comment like =
that.
>>> I expect it's more reliable to do this via Fixes:.  Possible?
>>>=20
>>=20
>> Thanks. I used this format because it is explicitly documented by the
>> stable kernel rules.
>>=20
>> The shell-style comment is the format documented in
>> Documentation/process/stable-kernel-rules.rst for specifying =
additional
>> patch prerequisites:
>>=20
>>  Cc: <stable@vger.kernel.org> # 3.3.x: <commit>: <subject>
>>  Cc: <stable@vger.kernel.org> # 3.3.x
>>=20
>> See:
>>=20
>>  https://docs.kernel.org/process/stable-kernel-rules.html#option-1
>=20
> Oh.  Consider me educated.  Edited.
>=20
>> A Fixes tag alone cannot express this dependency. It does not specify
>> an additional commit that must be cherry-picked first. The documented
>> Cc comment provides both the prerequisite and the required =
cherry-pick
>> order.
>>=20
>> Would this be sufficient for the stable team to pick up the =
prerequisite?
>=20
> Hopefully.  I suggest you double-check when you get the emails as =
these
> are applied to the various stable trees.

OK. I'll keep an eye on it.

Thanks.


