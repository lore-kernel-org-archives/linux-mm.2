Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B883606A330
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=myM+v23c
Received: by kanga.kvack.org (Postfix)
	id 3B4306B05B5; Tue, 10 Nov 2026 11:24:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B076B05B8; Tue, 10 Nov 2026 11:24:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283076B05B5; Tue, 10 Nov 2026 11:24:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 027AB6B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:24:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 039E4A8741
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:48 +0000 (UTC)
X-FDA: 85419733098.04.19A0F97
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id F40FE100005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=myM+v23c;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794327887;
	b=A8AAr7dSmZjIVg81+wi35HvuDoAlf3YRyDK3hBM5lVFvWsUDa/DZvYv7Wj9yVJmMGezMtE
	zhkoDlvFqkkkC3pmlTeUa8A2yaK5k5WevTT97uKRzZCGQVdvCdoQBEtz3wE63TGapGr5hf
	ObSejLxBjqQjQw3atIHC6QBd5afu4Iw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=myM+v23c;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.128.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794327887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5Rnh7B5SwAkMtwkddcYgTa/ycQfIe0CQGHW3qw4hcE=;
	b=VH58lxXoXy3xvqhKS4O3dlcPWvp+qXCg8/z1KtGB2yNv0cuKVFUfbSYOZsbeLtrS7dEgrA
	bfiW1ifAG2lgjegLc1VlWGTUuhxuPcKp/3q/vMx3ka1Ls9XITa0K6mTBTTUInk4U3y5ngq
	PljDOBDt88S38CId6JD3A1vGDK0iicI=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-8b349d21fd1so16908887b3.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:24:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794327886; x=1794932686; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=d5Rnh7B5SwAkMtwkddcYgTa/ycQfIe0CQGHW3qw4hcE=;
        b=myM+v23cCPBDQoVhv72aUCJx8GBwVvRPA3tg39X4pmkIz9oi18tlce1tJXaAmQo1Oc
         z/3Rh347cmjYLUIx4oDFHAq9NtV+INS7cz1plIXYHvMIycBLFfsLj2iH5FC3XG6tKN5z
         QI4ap4uJzdxF/IVg4rg/JrQR2iMwkAWHvxBSda7lq7aHQU9FQlqjOZ1IEvndwL7tTXJ0
         xBrZYP8dK534lw5NTzCfjrlTBfJXCQZ3aL1oW+US7rcT4/LObKfVcexkwsUR5gvPB9jo
         kOFbMSwESA5fVBWAkvVmEgdaD9XRsei15tJiWEV5VpM/V8JoqNz8GbqqNu0pzdTN3WOW
         9mGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794327886; x=1794932686;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d5Rnh7B5SwAkMtwkddcYgTa/ycQfIe0CQGHW3qw4hcE=;
        b=XNHrKIglKlaVQc3oUBgZeGKel5NoRWsi8GKb1BCExa3U/Rr/d2FsBC9XHAMjUd3/IE
         /uM8sepXYG3iUhTfRg4pfy/31mXBn2dOO0qXPSUngSROaZRsYH+BtoimtFeryJzyOaNt
         PqFR+v8WcUS7kJav14pYju+1Sstkpj1x+jZB/TG/SvDC26yXN2U5NfBBWJ/2V/IwCV/P
         ml2MnOfvQOhti8VD7uBSHAslkI9iKIfl92jYgq9FUImK2Jds8KuIHScagJD/oHV29VCd
         5kZtckGXZR+jsxXO5iH9+yIIAq/zfmo37Mf+kF9aCrAfPiOsYM6w4pTUB8VwFnX8ju26
         S+YQ==
X-Forwarded-Encrypted: i=1; AL+hErGvlCLB7+HGWjGQfC2SzmPejrgcXOlR9a5BVtHixZ24t+vArDG5rYE7QTkw5KGzuKXSVvNRUNf+sw==@kvack.org
X-Gm-Message-State: APuU4Z+vaLmotQ3E49L1j+5RkeTih+XvIs/g9uHMTmIjmQJwAoeKFnLt
	YCB0nxBig6zkhqO9LIGfzrO700Ak9oc3r0amrH1rVwHk8o2BxG1i/OtSIxyJL653mOk=
X-Gm-Gg: AYBFou0xGuzQQTn2GuKdhEM1EE4vipWE1nUc9KwO0n41hlWgA93o8bGox6DRzVSn+18
	JLLH+HyaHrvd06MZiXpeHe/dtxUFLFFTSIVDwrwxgkBresvz97H2vMVbipD9bxDtQKLNI7uhr2o
	PIlWUN2LET/lzc4d5HZvHz0Xmms8e69pGvShPDF2rnUOHZrecXYrbaD2QiJVuHKlJ3EuCE5MEyO
	CWijrIwS6efzRzzhWAEZhrYI4+Kcrk9URyp/NUaxRvnM9JZLul9SkQhAVwRedpxapZjtAOlfB/6
	84lxX26ztYUZCO4zjtV2pzfM2GTVWAQufKOnIVrMGBkR3J1Ph5x+qOLI8u16tenAvop/Xjy+YwG
	X6yD6jEnlOVXmZa9PLnGPUc3HVyJxs8WvfmzPWemoLQtbvBzpiuvyh31K37oPsLDkjbNoOSYl+9
	apI5lylbE27SuNLX7C2xyvSrbjGjJRSlcNdKM5KN2exiryXWoaNprIL4GrtE2ROmg/xabkfNW2S
	4It0lTBs6ScLp0ZKHALBUROvVWJrqGwbSnDeWQLXmBfPDAoP7lo2IVgPcaQ4dj0Qa0Cyi3H4Akn
	4jAqP7mjJ00cqhav47dNYajsBax+I7+kB2HR7Yzl5fvd5np8bqE4aGsuuP5AtesDaD40lqPlGt7
	mf/IAptA=
X-Received: by 2002:a05:690c:4:b0:8b3:4911:2dbd with SMTP id 00721157ae682-8b392bd0b26mr15687467b3.54.1794327886162;
        Tue, 10 Nov 2026 08:24:46 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef04d9b17sm24654076d6.20.2026.11.10.08.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 08:24:45 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5 7/7] mm: use VMA flag helpers in NUMA balancing
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
 dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
 mgorman@techsingularity.net, mingo@kernel.org, vschneid@redhat.com, 
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
 kas@kernel.org, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
 ying.huang@linux.alibaba.com, matthew.brost@intel.com, byungchul@sk.com, 
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, hannes@cmpxchg.org, 
 osalvador@suse.de, raghavendra.kt@amd.com
In-Reply-To: <avM0EbXsE7WyIPJE@gremlin>
References: <20261110150446.2452975-1-gourry@gourry.net>
 <20261110150446.2452975-8-gourry@gourry.net> <avM0EbXsE7WyIPJE@gremlin>
Date: Tue, 10 Nov 2026 11:24:44 -0500
Message-Id: <179432788447.2062277.15377194638664380330.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F40FE100005
X-Stat-Signature: nwguspun6eseuqoepg3xheha9w9pkh7o
X-Rspam-User: 
X-HE-Tag: 1794327886-146237
X-HE-Meta: U2FsdGVkX18EBeNDRqACe5Co2cSbQreSyKcjQeM39BRrP+ABx/G+Jjse8SpCPvAhb3TOSTRayvX5IFFe3c8I7JWiLaTnqbrFAWeWr5zGC69jxK/REM9ATRvdKG7srUcEo7ml9y0abDgiQ2zUHSk1mv+ggnKPRaHJqPaGMdWkTP2E5QRZDTJRreQX9MMIChzqp7tf+CnfhAc5En/eBQMwOxzAY19+lr28z5woijSzy5tCLizEMUxyypbpzY0IK+IvAjJmLB5EVb/G/8j9SpqKgQQc09zPLjO8xzZD+BT+seSnFwDeu2XVMoGlOdv9qof0F+0yZSRnL1bPZFHL5F8OjSfIxmV5Y0GYsTk6c+ytOIk9rwZsU52FVphKOR0z+L2ERuwmpQ5LSmyGXp7QYu6n8R6YSqvSahB6VGpooU7vMFJw4aElaWQ4wIrskQZO8RLrHa0vp77rI1o4P1cVyyLg6Le80pWPbJqHtrhwdk9nJqMCJN8hZ3Msc+XQLI4sPt7jC0LOk3pZwNYBmMC8EZR+5TCQVWZuVhvZpsaA7TlWMXUtM+vT/ADys+WTCqD72X0I/Ek5ZhbMOjBMK9RfG9ZbRYIq9rjHjAjiVRF5cdyUnM5FWDzu9J6I/O1mtReNJDYKo18PNHXxrxbUx8Hjw9B4P6QcXuibynaYGco7mT6nvgi1s9lOVYNkJ0ArvbmsnElgBtW3+DE6BDmUzHIJZwe9wT+dR7gJ1qRvSvnEKFf1rB5gFnwgtYtIRY9pBNdOqx2g06b8LduCZdfprsWcK2ACFIx6eCTHF2tEDkrgsW5k1tTO8PK6MjQiGOJVbRTkUAE0o3v7FHK148USPXT5aSM0MnWwiiH7v/nhg6xczD8mrDQhwLq6uU6sD5y54DmJgqsqXfozGzbqnnPgNjWqc+e+QC30BnfAPdwsfilBjwdNulLvWMyoRxszhGzfLbyCZ4rix2kClKPBneE5pVXKI+x
 E2E25hkC
 wNneswHcCKIAT2ylhQN48ZH6kim4WTAnTV7lwsb9ZdVn0NPolDRSJ8O1XqO0mS7NTv6xcrkOXe9vbnBd+s+uQmpE4Vhnl39WvTcnGwFGIONgk3vikLoEHFdWvGtxeKu0kOqRfFmQYTLgvniACChvHmCFdCOxwdKZISu/hqX4ijLLPj2swwmg8sdRwtKVIImaODi8GhGxWQzCWb3p3eJ1g0lXdZiMzXgMoEY00YPHCMxvaI5q4pDrOoYbQiWUI7c6IXVBqo1eA6Z4hmUFKLdV7EFLeLtpIencVfOeS/BWiCnkm5Rx97c18An9gtVA5nhzBVcOtEF3hJPCpxjMv4aS6qJ5A2kpYEMYmgiTp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-10 15:15 +0000, Lorenzo Stoakes (ARM) wrote:
> On Tue, Nov 10, 2026 at 10:04:46AM -0500, Gregory Price (Meta) wrote:
> > Use vma_test() instead of accessing vm_flags directly in the NUMA
> > balancing code touched by the preceding fixes. Keep the existing flag
> > predicates unchanged.
> >
> > No functional change intended.
> >
> > Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> 
> What a legend! :P
> 
> > Link: https://lore.kernel.org/r/aq1FDhy00epXXtgd@gremlin
> > Assisted-by: LLM
> 
> This tag is no longer required, in fact I think checkpatch should moan about it
> now.
>

I cargo-culted it from prior revisions, feel free to drop it.

Cheers :]

-- 
~Gregory


