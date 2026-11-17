Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC87B606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 06:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=MauZHBO0;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=rh0dra5c
Received: by kanga.kvack.org (Postfix)
	id 5ECEE6B00EF; Tue, 17 Nov 2026 01:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59DF76B05B0; Tue, 17 Nov 2026 01:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F336B05B1; Tue, 17 Nov 2026 01:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 180A66B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:37:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94BB516037D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:37:13 +0000 (UTC)
X-FDA: 85443653946.08.8DA5508
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6EA0840007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:37:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=MauZHBO0;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=rh0dra5c;
	spf=pass (imf04.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794897431;
	b=uoeSy1xd3zgLED+XflPhEI8k3cIkqfxCIlmPQbzmuB8grmRUy6jaJCTG72tHANzUXr5ema
	nRMQqqnCvdkJcCCWiBWnMrqhpAWAsVkkOwzW1awjzXfIsVhZvph8u48hLCCgjrU5z6wXwv
	WNdkAE64ZxNaJET8SP83DbBG6cQ+8EE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=MauZHBO0;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=rh0dra5c;
	spf=pass (imf04.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794897431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOsBTsM8HzI17SPUr1ak/9a9bMUvOh6RzD9t7xsTYQU=;
	b=3oPDSLcHCeqUD+sZHcATOfq0GhEbDNvKu4wMveHWXN38Tgyz2tcjJhdZ/eeS1a2543qP63
	5YyhC/K/ugPlrLGmWJcb1a8vdaaCVIVhdqSZw6cnAGox20DUW5YnRVaBQzYu9fhm7Y6h6D
	0q2rAnCySaLrOZbU6mFBGVBnVWJZwx4=
Received: from pps.filterd (m0167076.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AH6UXSG2158278
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:37:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=DOsB
	TsM8HzI17SPUr1ak/9a9bMUvOh6RzD9t7xsTYQU=; b=MauZHBO0QHOwDKA+XX+b
	5NPgYZ4th7Jzs/pn2qwSByCnGvBsaSJc5coSVdGgWEdboi7jundzHOOM5HiM42WB
	w0OyBmo17RGT7CtiNHkic9OwrbhIuAIOKMz1xyVIP0oacCdQoPCmhkkn2AmamZC7
	mBeSrbxoXB6igxp5uzLLa4D2IFme7QvqvquEjuxdUxnBQA6/IHFDWpw05cjVR1nA
	6pqKykASzKK8FkuSYbOtbsrqtnG1wjANodQW1tQeKxZrnFbvlYJ/Evk7urX0feCD
	FDfewHX0Jj2Ys1Zg/kZOA96usAUZAlS01YBpxaYovi/Ep2sJWUyQKe5egD9ZDAKN
	/g==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4j059qwgcm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:37:08 -0500 (EST)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-944138ed63fso655074685a.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794897428; x=1795502228; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DOsBTsM8HzI17SPUr1ak/9a9bMUvOh6RzD9t7xsTYQU=;
        b=rh0dra5cim6c5uC5Y5A8pTPAsT/cukOgikChLfC3CtHmpkcXLtobRmWPQgDb7zVUwr
         VZy6hxg1YKNFoI71SzCloFXClqWiepUqW9p0LOgtjCjTyb/yYP0drEs+zyxHUXc/pYP6
         FbEOXG3Qi596llyB7eT+yMhKsy6rQtfX4hs2RdggWq4l1bzRgxDm1nlu6eGWQ+tcwTmu
         Uew/QsWSUHwIgTicVhMhBMR+t+DlWMZ5THS1R2RnIZef1qDnRlsvUu6hFXap1rRl/IRq
         7Xla19mYJLctu3MAvD+9WxyIq+ImcWAenGR37fZxcHAM6wGXeEtphT2MMj5Lso2H69KE
         Z7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794897428; x=1795502228;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DOsBTsM8HzI17SPUr1ak/9a9bMUvOh6RzD9t7xsTYQU=;
        b=y+BoJwDdPag5+3BccENWCqgQpXSG8trinj7HdfnyRuDNetw83Fu1M9iTaJjAD8p6J0
         LOf2Y1L7etsC71+YywItWV3V7NLyS7PgNhOMbTxymx4iAbGLLFG58HKyrZGoVgDpe3lk
         9aaaG8VC/rsbagdxfzAxZwdIgdNsmcWMwgE3+UcbwECurC+9ybzFfcka04xHmpjrf+BY
         EoVeQnnb93zGrsels/2fXf/IIMvLIrCRiQHoyvG2N/07JcXHBhlvojaH4KSjnqncqKPK
         nyTNcyf2mRbTi8XPZktPbzfl04eUTZqKXGgfKHtQ8RNcc7J1CHlUEa+j0uWdzu6Iaf5H
         XCSw==
X-Gm-Message-State: APuU4Z8ImPceEEzOegDpsBdHXw9zWpocs6eRkxcvNJ5kWwoXTOHsJaSn
	1SXzEtbJJE1yzhLWoxNQ+hIVBtOzmOQWAacBDnH8bjrZHLj9svftcw0lqK5lNuTgkiB7MYnC0mb
	nlvJn9xBINLeS+ygqbeZvug5AJ/PVEj0gzfRTSBF4eBtW55aG
X-Gm-Gg: AYBFou2gr6EdSO4sonjo2nAKqT5BPzQXXMwceK0vPYM3KeTWDTR31Zp3fqY2dGMqUl3
	wnUmg4Xm5kCIWEYIKSaxlDHvsJmzHGgTZkxvi6Vq17bKetnelBfrSSd0fv5HAkGnO6Ij6bHXWtk
	R6dUhaP3vjWRAct0Ao+xWCtM1/jj7Wp1BiSz8xa106FA0JTezUZRE2S22Nngwk0f8inqbsMqyNb
	H+gb8huLjVmUoz44DV+Dux1cPw/uJsTIRXYyJkdxhNPnffyNVdyYqofbYyHiKOTtXVXpJ4TNZHW
	eY7yP2TJi11tUFx+mt7Gb+5gqXKVfjRxJC5ZDYAhrAWBoqkkTsZicQjJ+vjiRklrLawFsEuxmOx
	I4D6acysMlA4rqm6byG3QJ5D2GlbmGwFWEqyuxC9B7zYVlyGniK2VSJb5AEB72UOgSI5blFp226
	Tq4Opxu2DViFxjSD70SZEx8Q==
X-Received: by 2002:a05:620a:2b46:b0:949:6898:2e4b with SMTP id af79cd13be357-94968982e92mr1269464185a.66.1794897427868;
        Mon, 16 Nov 2026 22:37:07 -0800 (PST)
X-Received: by 2002:a05:620a:2b46:b0:949:6898:2e4b with SMTP id af79cd13be357-94968982e92mr1269462185a.66.1794897427441;
        Mon, 16 Nov 2026 22:37:07 -0800 (PST)
Received: from [192.168.1.62] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d614b4sm104980356d6.18.2026.11.16.22.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 22:37:06 -0800 (PST)
Message-ID: <8092de9e-3146-4fe7-a235-01ea8efab08c@columbia.edu>
Date: Tue, 17 Nov 2026 01:37:06 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/madvise: zap markers from guard regions
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        David Hildenbrand
 <david@kernel.org>,
        Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, stable@vger.kernel.org
References: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=L/qI0OT8 c=1 sm=1 tr=0 ts=6afbf614 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=Qm0qsxP7aFY2tkT6R2MF:22
 a=nc3XcxN3xHuRbhElZrYA:9 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: nvtBcBhtDNSSdvYUM94dmafKbYdWgk6O
X-Proofpoint-ORIG-GUID: nvtBcBhtDNSSdvYUM94dmafKbYdWgk6O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE3MDAyNSBTYWx0ZWRfX6n9/S/D2UMk4
 hi5OtCxruiwocogGuWJ9U91kBP+KeSCDD3ypu4ZtbnWdR85JHoce9Rs5KnvjhPloLYxtCHxz6Wj
 18Pl4NOIL9XK/Fg7T/y4X/26vHnAAgMvacBv8CnFyTXWTz18MgwogvI6tRyIALaJwJ0gOEAeaAF
 l5AMpUMPuCp6F8/G9FkNvDBk64t7EJ8nmfRfOBSItkaVhCDhknALDJUT681tC8wGsG8hNLnmWWn
 +Ev12zqTGUeOqQNoOELJJw3HZWcoQsPp2p5y/9QxolczLbUpAuLe6k07TSLCGNKx3FTkuGlQnuw
 UgqFQcZn4aO4o4qZivtbQI0fBdwfcOeUyr99ro8Wc6t/Da77ToetZVSKzYf0SEgHLQJ+ha8oO6U
 3qRCiDksGtfhZUuneN7zv4/qNVO4sPcf/fQbAT8TUMVCxhb5TMvrmNoxynF7vzI7twE6vHR9p42
 ikyhE18x1zHwQx/fzEg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE3MDAyNSBTYWx0ZWRfXzLgTfijvj7MM
 pacoqlSUVr+jgqHCxX3rEXCtWjeEWCIm2RjCtfCi7FyzveVpWJfdMMpNDk1pxCrZ2qq2vwVpo+U
 BGRZZ/FBdGvER63bWStmCsjmaNQDHRHenTvNpqo0fUoeC8WcvKHJ
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 lowpriorityscore=10 adultscore=0 priorityscore=1501
 malwarescore=0 bulkscore=10 suspectscore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611170025
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6EA0840007
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mowhkgtst7aw415e8izwjpjbwuqfpgjk
X-Rspam-User: 
X-HE-Tag: 1794897430-230344
X-HE-Meta: U2FsdGVkX1+H9nLF30aAVKpJL4hRLUhLaNWTas78wOETlEQ0qytCKrrCiRNyL94Y7eiEosBMocvhpkcyKaH6Xlu6EokeWP3MWCRelLhuHHNOP1/0oY86+qPL/bqGRkRSYgO+2iuZ6tbqv/bT5jLJxFTxeCYjRQeG9PSf4nCSYp8Rl/8J/SS80Raxuy4t090zFQTezjUg+PzJAK1NRhsfDeihIsrTE/9MHZLoaYfrBi5XqQTVP9nth+CmW+8s226pkQ5x43igzZgBjrsFpBxqG/fq7VG2cqQi1Mnx24xuMwERVRV//Rgr9BkHnfZk0/P3hcm+9C7iuxFM38XLX0A6SlUgAAIcJvPwz5o6f3dLOxA8iU3+0NJSE90BPoDlsrU7SA2b06ayYR50SIRTKALDnbAffooihlDwbGcbuD1WaaGJSwosSCjLyKONBgW2GGwFa5gQWHp35k3viG0wGmSkTqHWt3UGUyAS8wkl+Vne8UQgLtkDGIZiplaLWcLVT31NjynD/w0ZIqW3X10Wsg3bnaNyFU1usYm75WgGbhCtXBC3ZuOH8/7BrcN8VlQvQI6k1WfN6I6M/3fXlhs32vYFnt/Wli0oNcI5hdvUdgMTmNrPtsXTe0poRfrFdCFKEx6x6uRJBl/KD2HeE5tk3Xri7vl8Iy6AJAcFw2qTOeqXjoYS0U5poyoT4e7Ll9gCgxjmYRHwO1frc5/ZfLUZN+JrBIt6uaw5gkSucn3s64ApqcqLdbk1Q+r8AbLsYIunFfLx1ceW9IGiD7HlqzmtYgeXA8eipQG9OlZsSqWeELbLsr7quL0MikP+V/g8UUjSdLBsQ17vLkhRL74I9TVPhl4HxoLZ2YdVhB0cEKiUEp9nIfgITbZq278PcSU6aKFeH/jfnua5aESMayx1dmCckIS4gTBJl1rn8/svAJguVeYD2MqTCxTUpzxK2ZZsLQp3FQdfZpsaVUuiWChrNlLhRr2
 Fps/7Fug
 SdWan/jrYt75mv9xQAIAOJZIT0zGWCwfxk2uxlDqmCM0lXVwz0BuPWbpbSEbFh1I63Z6N03hMjqxu0K3OJGsm6A9F4jF8ERqdRgLVESPDEj5K1Ry2Cj+whm3/Vx7cJ7ny1EOhczAUMEIm9ef/6/1NycZlYsFXcOlbNGnDGUzzpDJpN7VgaoDSHaNbjr1oShz/ScNpq3QITT5cvqFvyxsr45nhv9lnDGM1S9uesoHFde5dMSSdCdtrpwmmvv8YKvYHtLaKYgyzzgGBqEHOsQc7F9rKmi8bHxZTabLn0GaUl8AKkjgVZpmUkk9IFI0NB9PRgjpP3s5DAkVCeYoSwnjaxssjsoqnL8ZlfvRDRC6bei7aCQc8ke2FlAZoo9258wB2Vmq2hFgIPPmJuWYbazIca38yfFP1m/HmUoCO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 4:04 PM, Lorenzo Stoakes (ARM) wrote:
> In order to establish guard regions, guard markers are installed in the
> page tables of a mapped VMA.
> 
> However, problems arise when one tries to combine this with registering a
> VMA for userfaultfd, as such operations may themselves need to install page
> table markers such as uffd-wp.
> 
> When the installation is attempted the guard marker prevents these markers
> being applied, which can lead to unexpected results (especially if the
> guard regions are later removed.)
> 
> This is especially problematic because guard region installation causes the
> regions to be zapped first, meaning that the removal of userfaultfd-tracked
> ranges will not be logged in this case.
> 
> Additionally, the uffd-wp page table marker will be propagated regardless
> for file-backed mappings as the zap being performed does not clear these
> markers.
> 
> This is problematic, as it can cause repeated failure to install guard
> markers resulting in an infinite loop.
> 
> Therefore, update guard region installation to invoke the zap with the
> ZAP_FLAG_DROP_MARKER flag applied.
> 
> Both before and after this change, uffd remove events will not trigger on
> guard region installation, nor will write protect state be propagated after
> guard region removal.
> 
> This makes sense as conceptually, guard regions mark a part of a VMA as
> effectively unmapped at the page table level, and removing the markers is
> like mapping the VMA again, over which operation uffd markers would in any
> case be lost.
> 
> A survey of open source users indicates nobody is relying on installing
> guard regions in uffd-armed VMAs. Software including glibc, android,
> tcmalloc and CRIU were checked.
> 
> This change means that any already established guard regions are removed on
> zap. These will be overwritten with the newly installed guard markers on
> success.
> 
> However, if this fails for some reason (fatal signal likely the only
> reasonable cause), guard regions may remain removed, and concurrent faults
> may succeed in the interim in the range.
> 
> Since the installation failing guarantees nothing about the range being
> installed into, and since success overwrites with guard markers, this isn't
> an issue.
> 
> Since MADV_DONTNEED does something similar, abstract the zapping to
> zap_range() and call it from both places.
> 
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Tested-by: Tal Zussman <tz2294@columbia.edu>

