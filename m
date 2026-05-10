Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BA35CD3447
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 01:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9D36B008A; Sat,  9 May 2026 21:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533706B008C; Sat,  9 May 2026 21:22:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB716B0092; Sat,  9 May 2026 21:22:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B2BB6B008A
	for <linux-mm@kvack.org>; Sat,  9 May 2026 21:22:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE8CB1C0E7B
	for <linux-mm@kvack.org>; Sun, 10 May 2026 01:22:48 +0000 (UTC)
X-FDA: 84749760816.01.C9AC747
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id EEAD9180002
	for <linux-mm@kvack.org>; Sun, 10 May 2026 01:22:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CAingM6l;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778376167;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oIhWSVTY403il12RL/w6eCME3eB95/PHvNgqJ5h0N+4=;
	b=Zgwwv0uEm7UTGkzDHijlU3ShD5caYWrq8Ef37d4Gwf3XOZI+7lIQVjJYYDg9BO4y8e8YpE
	EgM36/xLTtmk4d+9zUTtE6b4+NCRhdU3foUa9cnrK7g3uTR+MB5hFukAz3V6d7llv9e7Nr
	04FmZZTbrUFaBoF3lBMD7QeoCy97rMU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CAingM6l;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778376167; a=rsa-sha256;
	cv=none;
	b=opVN8u4XCw+haWla5iNERgwQCG7qOCzCpVn7uIEcYOeBqBT3xRn/JNPWjAotGXKjjZQPN7
	/Bw9Ufm45Arzdt0sESd4g9jSC53Rz3IFknQCcweoWkqCSb2wwPloYF0RqALOcixhi1XoEQ
	s8AQCX43Mjo7RERBifCEEzRZNcF3Lp4=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-67f94c078e8so387872a12.1
        for <linux-mm@kvack.org>; Sat, 09 May 2026 18:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778376165; x=1778980965; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oIhWSVTY403il12RL/w6eCME3eB95/PHvNgqJ5h0N+4=;
        b=CAingM6lvlDKaWlPyGL5YHPtB9fHrovP540anlRwaAiyqDcasg1wfPKoRXhTSZ+1uj
         Ewl5tyTXY52S81GcFOI/e39OCjTmEJi6ZU52ZXOFUZwgAfOfQuDJ30r5bXrqHoBn8QG8
         BGrtcpE0GwyQkj/ldNru19dsfFawGWPuTWxPo0geu1IoFMvYKI0ofpECIckBNNnskUjM
         AyvdAbueXpw0AfHlSHMfC0DqBUI/DsjEXjuUBJ06GLwxLfwd3MsTjrjZXhdoWTDH/vFY
         r+VcJMAHCQC8JkvYgScnt/yi+yyBkprLaYR9dMcTk/OXWUi906tRQAwegS8k+tLM8v5w
         N7Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778376165; x=1778980965;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oIhWSVTY403il12RL/w6eCME3eB95/PHvNgqJ5h0N+4=;
        b=Hb89/zo0kUbHl5HfOdnQJzrMFqgiHXCn0srmkYmu3a5n/owKJhKo9wrMGnRI5tBsbb
         RGtShKH92+OBInfl/XaQaFcbG5T5l5yboLDeovmO7dxeKc09fOSF439lopmi7qny0ARm
         FRQKBK6LV0QT4Zr3e7Zu9KGsb9RFmpyibNnUfCUa73n6/FY55LclyokDnbmrQMV7oxLT
         EnXxsRgf3P9CWSU4hdS5B5c6ruM6Wgf3I+jheJB3AqFkt/OV38kthfN08W9VG/+5KmLi
         VEY2BB3WtAREHN1cBLc4vG6h/S1F+e9IJddN3aV1GpDc3Dt5oYxNSel3V1HtS5cIlFaJ
         7DNw==
X-Forwarded-Encrypted: i=1; AFNElJ8zDfbNGmpboTExblBg4Si5bTSJzuVzNpzYb0UN2vuocrSUeXBWwu6KTu+9BHrgiJl3vuyiBpp9ag==@kvack.org
X-Gm-Message-State: AOJu0Yy6IlO8Skq39tUZE/bQy2cDrFUTm6n0ydKs5AFX2I/rhoTxHhAe
	UXtesTCDppLwBUGwbuS/hBv67ShFu1CW6EdKFETMLXfnJ8rfrLZbTVdF
X-Gm-Gg: Acq92OFKxPe3h4jHee9M0GuaVt0+77wFdRlNzuDWOQfXh2IneX+hbr3CywqAsovVMzO
	yVhNmYf68nm0eKX/Q4GM89+WEF4sXE0NDBNikygTQn/YIgPb31lLaCzHn6AuFOIA0xOir6p0a9g
	+SvMZoTQrJHK5DiAi3+GvcJleaZV9PRgaSSsy4xLxupSFMwvCuW68kSsAjver5y0Psd3t8wiuAl
	IIlGgjz0/s6l300uJpyMYurWOo7S5xq8b1dcrebdOjDlW+I6Zxx1osOqsNEh7sI4OuL7zAqM4eN
	U6R1HnWKheYN1yIDfp3whTbeGNAHpFyAe9xCOKVcDnK56hz8bsx9955WB+mD2Tvr35vzEaEV0vi
	6Y7Gv+rDEqumLuU41II4WxpxdCzQUsrg3eEuYEKK3QjArprPJJBEqMxWoWjKYxT5PAdPLPIT1af
	fgjXzcP+N2/8c5RlBt+13sA+Xv+ReT1XiX
X-Received: by 2002:a17:906:4787:b0:bb9:36dd:cd3d with SMTP id a640c23a62f3a-bc56ae2ca84mr1094557666b.4.1778376165369;
        Sat, 09 May 2026 18:22:45 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bcb706b7631sm219272266b.61.2026.05.09.18.22.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 09 May 2026 18:22:44 -0700 (PDT)
Date: Sun, 10 May 2026 01:22:43 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org, ljs@kernel.org,
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
	harry@kernel.org, jannh@google.com, sj@kernel.org, ziy@nvidia.com,
	balbirs@nvidia.com, linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260510012243.sz2ex6hzlmdckmmh@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260508013728.21285-1-richard.weiyang@gmail.com>
 <20260508145121.35e2552d403b94ea6f748b90@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508145121.35e2552d403b94ea6f748b90@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 9najhyxfockx8cdpxtcjmtod8bshtdxd
X-Rspamd-Queue-Id: EEAD9180002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778376166-314894
X-HE-Meta: U2FsdGVkX1+ya+ofUwTiHJk5QDK6ctCSOM/07ft6YDFJbV+mJ7mwlqmBOdQSpOiNTQYH8qhCJkgQEfO7v6FdREEST/dIrugWHw8FscRMt3LHF7mwKQxBfQ2h0AZCNsgTOTl1QBofIATZo5yXI4EBB7uhgzOXNCFU/b4ILoEJW8OQSqz5NzssGcBGrZOjwkc45CFRK3DK4cjNuHnYE5BHh8An9KoqOzn0wFuyIEVerD/XyLbyLUnPSbuVMtr+mJocHueph3i5bdEBuMVM9dDtnKeenitVMnLiNBo9Dwf5G4n4dajm/mbW0C0QTSwCzfuuJz491Nu6zvwMYtkCktzeDHkZeNu1ODsRmxQHc/hpGmNH/Oo1QW+Cp6Z6b1qZVhfb229eDp0cN/yQwlACSj7EngmsWrY5NgoYN410GAsIAqpm5SSaaD3f4fbc2KYV5Sd8O2w1F1pxidN/p+UCTJ02d0VF0MlJRgOhBgkegLF95RqoxYO9CcYfF472hTWhPzE7GFaXkr8vwGYDxltATmquPZ0q4uUa5b45zzCP33qQtC0iKPC+iSyniXucXdKjGUWV9EhZnTJfYtIRFagtIrymd8jkserfW6oK8z4/KxoniagaHihPtsD23HvoYFDzjqoNshhDtkWjvyh9YTsHbW/mFXiOi1jd8Lm+65VBVU65rdOyUpTHD3XXWhwPI+MvCF9WjHWckO3gHMGZS6ZKZiDN1Or0/9RCSo1/QSump7oQxC9vgIEzZAPqIxjYHaJcEyv9gyHmRGVYBeh1ArWNy2lpFDmOwfEXlNnITSc4n+xgCPteumiinydvbMkBjkFd+0xiLVLrgJKIMfKl3RcNuCpGWAnCuLk1C3kmpE4IDJJwQQxdJPGMksu65MzKrQljSUYKvqIf0AWigebV9JSlDZioywK7xUBiahVtuDWh5/u9+2EUZfZqi38KA1Ag7fCI/YuHRQAjv0yZSv08mksyDEh
 Ivo4YUH3
 yxOh5VC5K9hGzQjcSW2VVv63eU8ZqyMJtCHpasz4YzD1lL8BI36X32ZstrlNiag3AYecaelgvd0YyLWJhRjNl3XtPeaKeIpM9I3RaJm+uz6MY61eK3Yi2JzySlm7fkQJnW04fVayNYUI1mP8YXD5kag5FpCBar6LlFN5sEoZ+PRm6ZaurGiOW75LV6zgla99Y/UqvZvcH50Tcfu6FoQMmYMz9FRdgPDAgN1eEneML2TqwHdgd5WBhtgBJJFUp5mCbfnr5zNFSJlSzqtMbaF+ie6hkW5sBbpoOxw68HDR6PGEqQLNFtePd+N3sWnv4VbDA8MMyJ4IH486T7aVoseeB9COdzLIIR8mqaFkD+LyMGpowoA4c1XWRbMb6b1TgywgBdcdfUqPamw1uzz/GuHpQKjrOolm2Pe9yqoxnMRujALw6ZrWEJdb/9AYKOnAYFWN1fpEjCwRD6O3FAjHk0sHhwbh+TCGH6K61XIxPXeGtb6K9AyKtVq0AMBpKx9LaaUx2HPSZ6VdZ1Yr9T1FxyWeJB2gNZIjRhdsef6FZ+rJUI6L3vcxkjZc6+y0hkJuMIGGrCqLYhmPLNaPsteAoXh2KjvRv10Al7rTZleBmLanU6UR8X+0m17DFK0w2/JTojf8XH8PS8TEWqSVoNVBWduDx4rf5e14VrLBTIXxfltZ5HNGc/68VpxfaU6C9ARbVF/rpy/AvV3YZ7uHLsStjMplcyL1zeXm/JbtH61AbJMjElLxPvijC4wn8P9/k3FpWfpq7RylECsPBtkCk/rOkjpBJolgQELbV9/r09A2wgUtUyY7ayVI/3RJKDuKyZnQo86xQT34GQmPEkEaW0PpS69BngDhfGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 02:51:21PM -0700, Andrew Morton wrote:
>On Fri,  8 May 2026 01:37:28 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
>> before return the pmd entry:
>> 
>>   * re-validate pmd entry
>>   * check PVMW_MIGRATION
>>   * check_pmd()
>>   * handle on pte level if split under us
>> 
>> But for device-private pmd, we just return after pmd_lock(). This may
>> lead to improper situation.
>
>What is "improper situation"?
>

For example, in remove_migration_pte(), page_vma_mapped_walk() may return
device-private entry which is not a migration entry.

>> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
>> support device-private entries") by following the same pattern as
>> pmd_trans_huge() and pmd_is_migration_entry().
>> 
>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: David Hildenbrand <david@kernel.org>
>> Cc: Balbir Singh <balbirs@nvidia.com>
>> Cc: SeongJae Park <sj@kernel.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: <stable@vger.kernel.org>
>
>If we're to propose a fix for -stable backporting I believe we should
>fully explain to -stable maintainers *why* we're making that proposal.
>

IIUC, we may do migration on a wrong pmd entry, which may corrupt data.

>IOW, and not for the first time(!), what are the worst-case
>userspace-visible effects of this bug?
>

Got it, will pay attention. Sorry for the trouble.

-- 
Wei Yang
Help you, Help me

