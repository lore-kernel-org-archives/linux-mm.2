Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79BF8CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:45:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C858E0009; Tue, 11 Nov 2025 01:45:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462E68E0002; Tue, 11 Nov 2025 01:45:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 378BF8E0009; Tue, 11 Nov 2025 01:45:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26AFC8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:45:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C622C1A0407
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:45:50 +0000 (UTC)
X-FDA: 84097390860.18.40A1762
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id A21F4C0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:45:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=Azb9Nukr;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf28.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762843548; a=rsa-sha256;
	cv=none;
	b=xe3xrHxR/F7NdyQ51YSIFVT3UHpXy23JGvHvCRInpSq4cLE3B5lChuNXtOyUOFmY47sgTb
	dd3vqAB1awyECYh2jZvnkdXSDjcdPDqkrvxicPql2wsM2YPj8C1xaQcb0tWInW0IaxL2xf
	e5reaiekqdpD1Pf9o7WhtR5s7QhGSbg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=Azb9Nukr;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf28.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762843548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cl+GLucGBzlTLWjtZq9oz0wfi6xtPX0PrTL9GqsnyOc=;
	b=I7HZCkHQoPrvANKdZsHCIcVe64nLyqUEdv9srbR4Fh7MIMC9S5U6AABRBr2BxLrf1cAE+a
	iLCH+fxLql4qiAIKXspumb6jTMtDuqotL5U0GUaSoLltkx9YYr1s1bS0ILJLWoU6w82PXn
	pifK2eyDWOGSHAAeEUqJt9kbGbA4aJo=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-77f67ba775aso4585633b3a.3
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762843547; x=1763448347; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cl+GLucGBzlTLWjtZq9oz0wfi6xtPX0PrTL9GqsnyOc=;
        b=Azb9NukrXOTHMkSkuyTa6X0fgCtrJ7F9jmCLWb5fFdMcwfBtxjek+JULxB86pYXEaM
         r9xS6dvSyLPbmgMgwJtxO6sgpTvlJwo7bc+MQv5DENCOAPbMFKFZVjROXTayR/xIlDAr
         dRypi2jkG84Htb8c4cEn94ClY/cmOCUsA2zU/xNKmvrMFxMPUmJPLdlzgswiOc11352h
         tDM9UwymISGiLAphymUYjnhlfIlstsUipYu7JPn/gUiZdgr5kj4XelX7DPLE+qp7dAiR
         m/d8Donsb92+CQaPy3uoRynA7EgWcSgZGM1LVWcUatDyMnbsw0SssJnR0lhAGyiWJ4Ia
         thzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762843547; x=1763448347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cl+GLucGBzlTLWjtZq9oz0wfi6xtPX0PrTL9GqsnyOc=;
        b=H4paCGeiTWCTgfUODAPApxxx1pSHjy8qn4MPsaPI7fQLyx1pfrnxoaJ9OMGGLodBQL
         OMxOz6GNX8az7pRASEvrCZNZJ/FpZjj3xyA50ZsV7l5ttt+dJUnQBIZwhT+9fT2AIEzX
         xfPIlPQt1g7L6BhdLIN2TM8phS9PZP67Zf0hwqxkDh9fRD7dEU9lKxJ2I56zcv/orYOQ
         16y5s45tiWWe2Can3kef2V+ZYeMCSs11PoY398Lukw0Go73BJaKX4QbXaOlv2RJRsrut
         KvDEc1xCh/WXEJstL8osp8eGxwWnC6ffjqQ+loZZsmrIBkwNLmnL3/35F2i7fMhMxS3P
         ropA==
X-Forwarded-Encrypted: i=1; AJvYcCVjgtj2MZsbHRGrEWmtFr3o1Xl0y8rL7F7LIYCsVr4ct5rzN82Lxu/i4xkVxHTu4AWmeBiWsOkW6Q==@kvack.org
X-Gm-Message-State: AOJu0YyOzKXEjST6YLlWA/bpS/EbaaAXpfM9D2MM6JXQ2vWKPIVVPtzv
	75CdJt9kpfIfekFHmYfUvWk2nSMRZzkiJv0iStRjk0KKV57xmUx1P0VhO4lRwt1RBLk=
X-Gm-Gg: ASbGncszXIn16JOSL6erMApG/WzbzMP6B98hNAdblaew0sczU6SRDqStxWpwf1kilgA
	FkyFLVh1N+ukPIN2laJMQGmlX16RbCa3y6uhIIxM2s/DRj5r7Bvhg2in4Egl7B4k8bQiZAjOj2R
	tnNj+EHnZ//wbyyJEeXDZSgu0WUWtjqGlgDVreiocHMyvqNGgJagp32BHWVMmV6iEgriXbQa/nV
	WUPlO/It7OQrZ4N3+8IFwJUD/04ZVs8sKAZURWNdpraApJuKptoPT+3inkIST9lIdmWDphOxWup
	xYZC9eEaWejG/UjnOnmflJgdLEOX+Hy0PJZT724JcVo3okzrHalCUwFXEnqyuY/p/P9Dp8NpqE4
	WqLwSThpFTLLwDHKOx7QO5cJJPK01Hinf4WzcpgazfjvWpT0WUW0/XC0LJCbDRIOPY/sGeczGkT
	cjWRaLaQDaC/BMDw==
X-Google-Smtp-Source: AGHT+IEicHLSYzdwynj4I4nc/MYN4IYvIV6/LmFIMqRyJaOIQeaa5JTA6robs499AmJpzGJRfdsVew==
X-Received: by 2002:a05:6a20:3d86:b0:343:3d3c:4685 with SMTP id adf61e73a8af0-353a1de1402mr13983796637.18.1762843547462;
        Mon, 10 Nov 2025 22:45:47 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0c953e791sm14370759b3a.7.2025.11.10.22.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 22:45:47 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: chenridong@huaweicloud.com
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	jack@suse.cz,
	joel.granados@kernel.org,
	kyle.meyer@hpe.com,
	lance.yang@linux.dev,
	laoar.shao@gmail.com,
	leon.huangfu@shopee.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mclapinski@google.com,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	tj@kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for on-demand stats flushing
Date: Tue, 11 Nov 2025 14:44:13 +0800
Message-ID: <20251111064415.75290-1-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <7d46ef17-684b-4603-be7a-a9428149da05@huaweicloud.com>
References: <7d46ef17-684b-4603-be7a-a9428149da05@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A21F4C0003
X-Stat-Signature: dti3dccms1q9s4zk1kkdapnyridsusyh
X-HE-Tag: 1762843548-499563
X-HE-Meta: U2FsdGVkX19OBxdy0xpD08aVXa7hBH5FsRzltaoxmkk0CylhHZFevsiT0+Y/j+WyqG/yqM6fCVOkSrDqX0TERMrGrezUpD3Zb6IFXJlYxnQr9A4/JfX8UtgKjxi41xAlXIbAabe3lU3rBaSsLXkyTxv9CfV9kTVzqC8QDyCx0J0Vv92/MlTB9nGc+k6u9PBQ+JzOdF2WphYrC1NGAB2a8VGHgurwrYPVUnPGhe3aqQBRgwggxf3zqgeCVW84D9rSI+UKVNYxlyUom8a4uv71/oS+2URCqOPZ9dfCXLQYNuVD/eVzatBNrgBPrX4rMkNlS/HX2SbleOQpNedNShdfmmtj6DFWjeqMbz4Vsk7drV4OLMNRErCFkO4Pvb7fPJ1m/+B1abMckIUvcRmnVC+PFGeQucY+3IcJ78uPB4LEQKYZso7ofFXocxms04yuRcfEn2P2gjPphE3jg0RKinIlfgYGvqJKn514mOyoNxtRxP4uSidGnsejssrv7zawchiHJrC9OgGYTsUm0Mhuq8TpYS904s8WzEZKmM7Pxfc6qOMTexpRyOfzx7ec4cBDVPD5wEO/TxY5E29OEJznLQRX/J/YEKL9x+s2n7fTipL8SSvSrOGxwUkiuETjY+37t5uvVcTSY3ODGaOj4xStlY0/lnmi6tbrB1XTUH0w4c4g1mZq5X7IELDSQthtjPwQJahg++6Hc6J8Ths5HyFI9WQe5VRITKhfLB0vf4+SNNVED/0oM0K+c7ai63RgwIUtU5hDau6k8m9fFk27mmoYWLur4c5w+7ksDxJVgu6s5JCoWUZ7VUUzOXAYTt0AHSQz0eyciAhcQqgatX5T0Zh86EuSVSsXciEmCk6KNjl+OIYbeJKiK3r5cb0hD5mR6xhaEYUq5jPz77SOIRmuysWc+FwWODMcf7B9LTqYb5MCFp9XZ1nOPQi8GLg9SWJgdfO6h++13xcVIkrD0ezZ9urQjQM
 kcyt3tQg
 JosST36QbDgEsamMqtUjApx19GeaFP55cYBzJ7b8EZALiIlNSzE8VLvTUrpkqcSVkzn4FkqM0wXBht5lwxf1mbj1ge/gMNi6rcVLLfwF3buhNf6mI3XOkgCBffmqIEVVUWqJHSlHO13B0XqQhSNcnuhsAbgfH0NXG3a8jjrDsrWJEF03E1ywPIDbyp2BrkAO+gr1FmOtGcYYKBhAtNso88Sal238NqV99uZN/lZZPMERhb2mCBsygMcHcGWkH00hasns4LjvaDVmhM64OxX2CQMAaxhqfajVujKeJAQQDRAC9DjYHSO6Nd7jPAJ+t8ObxWN7ekXbk/HYA6WO3lKTv+jRxoBYAqJ93zx9+30pNTM4Izue0LVr4tJFCXVBHZ026YqK5E1cGQMjQS+4uxuFwbzn5OiFoPmN6Jr2j0YkhDWCMBhqCXi1/2ukGBM1XDsiZUsTtFIx3VV2xjMH18WIBifc4M61GpQcKeX5seNGSBAZTjMQUQPrU3jdPBfu2EbSbuLTC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 9:00 AM Chen Ridong <chenridong@huaweicloud.com> wrote:
>
>
>
> On 2025/11/10 21:50, Michal Koutný wrote:
>> Hello Leon.

Hi Ridong,

>>
>> On Mon, Nov 10, 2025 at 06:19:48PM +0800, Leon Huang Fu <leon.huangfu@shopee.com> wrote:
>>> Memory cgroup statistics are updated asynchronously with periodic
>>> flushing to reduce overhead. The current implementation uses a flush
>>> threshold calculated as MEMCG_CHARGE_BATCH * num_online_cpus() for
>>> determining when to aggregate per-CPU memory cgroup statistics. On
>>> systems with high core counts, this threshold can become very large
>>> (e.g., 64 * 256 = 16,384 on a 256-core system), leading to stale
>>> statistics when userspace reads memory.stat files.
>>>
>
> We have encountered this problem multiple times when running LTP tests. It can easily occur when
> using a 64K page size.
>
> error:
>         memcg_stat_rss 10 TFAIL: rss is 0, 266240 expected
>

Have you encountered this problem in real world?

>>> This is particularly problematic for monitoring and management tools
>>> that rely on reasonably fresh statistics, as they may observe data
>>> that is thousands of updates out of date.
>>>
>>> Introduce a new write-only file, memory.stat_refresh, that allows
>>> userspace to explicitly trigger an immediate flush of memory statistics.
>>
[...]
>>
>> Next, v1 and v2 haven't been consistent since introduction of v2 (unlike
>> some other controllers that share code or even cftypes between v1 and
>> v2). So I'd avoid introducing a new file to V1 API.
>>
>
> We encountered this problem in v1, I think this is a common problem should be fixed.

Thanks for pointing that out.

Thanks,
Leon

[...]

