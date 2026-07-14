Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A767AC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F97C6B009D; Tue, 14 Jul 2026 09:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA376B00A0; Tue, 14 Jul 2026 09:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871196B00A2; Tue, 14 Jul 2026 09:03:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F2976B009D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:03:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D10941203A7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:03:47 +0000 (UTC)
X-FDA: 84987399294.04.139E59E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1F4AE180011
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:03:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ddGyknup;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784034226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWi7hqyYTbzO1/N8hNuw+3aCqzWSHoGEXiSIX2DNwFo=;
	b=g3iOZH3pmdLJeqw89cPGLnGYNuVmExIf0vjw/XulRYv9fqkhaYiAHswSgzkCwH2x/nROEC
	hfR1d4fa4lt1cAYlNk5xCXezoNIcsa4XZsj7eqntZpWeM15jJ6uoHCpwcZKvBLNlANrS9A
	zccqAJqy/xreMzbQlRthwO3XxnbjXto=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ddGyknup;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784034226;
	b=6j29jZ9aJ0TkboX3PK4zMs9NAQF8SM93Y9W32RHzr9lhB9emncrdtqXHPwczPDpuFzNUes
	2G8YDN4U18wRpJ+5KYrs3fvctKPHdljJi8rcCa+kCEkG+uShSumuZG16EILWoMXRtp5n9n
	6qiHCtRybAH0Rv6pteCJj2gv44xFczQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37D0E601ED;
	Tue, 14 Jul 2026 13:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587281F000E9;
	Tue, 14 Jul 2026 13:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784034224;
	bh=jWi7hqyYTbzO1/N8hNuw+3aCqzWSHoGEXiSIX2DNwFo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ddGyknup29KvGfQGIfEwqFGZ1d4WWXQIGRtrE9OBzjxL9Xd5BK3gttkewgrGTwbiL
	 NSk8Zcv3meMLAjy0eCgXXMtcGhvakuD2PtTuuiPL5xd9U6yhj3uWoReue0sc05+ZVV
	 9Fos/z1NtDQJGC2dZCMRTg7VozDKZqjrye+LSnwqd22EHIsaWMzAYs+Y9tZzTujqTb
	 3M2/1Ivgo4ZY0qHAHmGFoqX6ixQRbeLA6bIToa4Wm4Dh3db/n/585AZFwIigaeQFxN
	 3T3p1A92MU030ioQLguXyDW+g2niZAtU5QtzovFMDS2PpF0W/nHjlatlwL+SdrRFpk
	 GKw2afA4K4BxA==
Message-ID: <1d49594c-3549-482d-8c11-fdeb2051e952@kernel.org>
Date: Tue, 14 Jul 2026 15:03:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/34] ARM: mm: make 2-level pgd_t a scalar
To: David Laight <david.laight.linux@gmail.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, linux-mm@kvack.org,
 kasan-dev@googlegroups.com, linux-csky@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux@armlinux.org.uk, akpm@linux-foundation.org, ankur.a.arora@oracle.com,
 rppt@kernel.org, linmag7@gmail.com, chleroy@kernel.org,
 klarasmodin@gmail.com, chenhuacai@kernel.org, kernel@xen0n.name,
 kas@kernel.org, zhangtianyang@loongson.cn, wangyuli@aosc.io,
 tsbogend@alpha.franken.de, ljs@kernel.org, jgg@ziepe.ca,
 catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de,
 ryan.roberts@arm.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, kevin.brodsky@arm.com,
 anup@brainfault.org, atish.patra@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org,
 guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
 dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev,
 vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org,
 djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com,
 Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-3-yeoreum.yun@arm.com>
 <20260714133415.78e25654@pumpkin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260714133415.78e25654@pumpkin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1F4AE180011
X-Stat-Signature: adgtuy9bp7tywyr4fny5ng9qqpqc6gqi
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784034225-244675
X-HE-Meta: U2FsdGVkX19qRfciERmIE2D3A4HO/2509xghrot6V0du5/bP2IUumBcOT6HTTn5q3GZ0UeiArayeyM2DSys7kdAlAws6AXsRxs7WPp+2S64qCizUa8cwBKSvNSErI2WGcHg4uIA+GWDqHFh35NEVQCHrA/t3s13pwojkNtLK25zW0pvEYJ4Q9MEE2LEr/vR1+5FEUwrtcRVfMGClxtBPL/BdN3RPbU8Q50UcGWu5/HUR8gpTsVqM6cmWGi73lh1aw5AjjOroDjTPPw7pi9Mh6FSD/aFCWLLhaAhbQVZ4WK/d98aZE1W27SIq33bGw/MZmY90Au2ojMOY0tcBZpzgufUph1wROr9QMc4iQkJvErEfLAuOhGNKsc/FMqelKPXoH7wTdjCoTbkJ1FVvvXQIYSWqofvc/NXluYYBGTPMbztSEBzK8Dq6jlFRKZQyN2GjBff/cH0h+DCqJK+D2VSn9QkRf1RiDxJem5oEN9rWp2LgrXuPqdr6M6uNdypY/m9X91WRDo2kUfdqNG/4KK5ZtdxVi7lLRY4I2aE/Ay1Wg3cSSW7tWXQlPneajT/QXoOwsXp0J27NCcemQDyaeWKTPOIXJYQPjeAZMi6e1ycsu00WBwbKGBoTI/P9JttzAVbJxlLWtDrYiX28E2tvpP8cHBiaUtuUCDHeS8WKd04iEWhFEyDpGIneQjb+uLamXE8iKgX7GHQDljzE8jywj0E4icJ/4p/N1wGmdPwuQdrAujDBpVBWmZ/CdxD2ssmP9Yg+qjjdUaW0z7S0iEFo52ugRgugDFXGvAQPcOK5fQ2X5U7kLhxH+PPYZTd84R2lGgI6H0+iM+y1prU47dINC2nXJ/MtckiuOk+7XD7ZlPPOsK0s13RdKMNR3GewUOQI6XdeBKdeBDjo2iY6bqQQc0mpdvz91Q7af1Q3ZqUBpNnmbatNFT/RF/nE9fhdRQcHlksX4j6HlhOf146pK1u6wLr
 bBr76j3l
 zq9PN7nBdndbX7RHEDgxFWpbnMCsxIGobiwI9mzkQzCA7l3ig4OH6s7vyq3o050Av+OpcJPQmuAWP5YxS3s0PEAHsoJkRa49sK0VvujH15tZ3o872PswOH02r3yK/K4XybbFje9sjCcvS9519odGjtAmiBQhODns7Ek2llUAqqkxOFFRehFW55A35lnQCZg/F7TYx8K2UpgDv79OLu/lR/5AYcvW7NyyR098vVv0yt/LFcet2khEubcGaDzI4mn/bauqJ6esRBhKxWyH1cWI1TQFR0RVkGZ8HkEqWLbUGZEgfUaTHcHzaJrxIzl4ePJ6stYvWofQltQbrN9yIyWncdscpFg0FVyH6qo5yBI5Z7hbTs96E2AfZ4QDfYIwW7SCTq0QkaNRKeSS4Yt1deMSzB2uzFeLUiAy9Z4+0bYgjb5i0xxVrwtoVt04bNfkVSg9Kz2Of/szRJAhwtpOwU7M2O8pBnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 14:34, David Laight wrote:
> On Mon, 13 Jul 2026 14:55:41 +0100
> Yeoreum Yun <yeoreum.yun@arm.com> wrote:
> 
>> From: "David Hildenbrand (Arm)" <david@kernel.org>
>>
>> We don't want pgd_t to be an array, as it prohibits returning it from a
>> function, like pgdp_get().
> 
> If you use a two element structure the compiler/ABI might be able to
> return that from a function in two registers.
> That might make the entire mess more readable ...

The patch description states:

"
As an alternative, we could use the STRICT_MM_TYPECHECKS approach here
as well, but using an u64 looks conceptually cleaner, even though
pgd_val() gets a bit more involved.
"

Arnd replied on that in more detail.

Maybe I should just go back to using bit shifts and handing endianess.

-- 
Cheers,

David

