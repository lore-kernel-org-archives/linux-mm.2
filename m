Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 906B0F3D5E9
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 04:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49416B008C; Sun, 29 Mar 2026 00:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B20CB6B0095; Sun, 29 Mar 2026 00:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A37A06B0096; Sun, 29 Mar 2026 00:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9091A6B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 00:08:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32C4F140399
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:08:35 +0000 (UTC)
X-FDA: 84597768990.29.E22D237
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 14173140002
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:08:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=FHXsCm2y;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of r@hev.cc designates 209.85.214.174 as permitted sender) smtp.mailfrom=r@hev.cc
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774757313; a=rsa-sha256;
	cv=none;
	b=OavmsfDK6+hTt/YdSZf0WOfpc3I9dREDAaPnYNaGVp722pA/ofUQ/yq72vPznn6O/SWEXi
	5pebF+rmaHYVMA1A6NzDZ3q94iHesS/XlaphbzIQl13BsxoNRpa0akeVRyB3melXKvRBm0
	g7VlgBuAGZXuHfu5/piWCyy9go6NeB8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=FHXsCm2y;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of r@hev.cc designates 209.85.214.174 as permitted sender) smtp.mailfrom=r@hev.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774757313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcMba91l4VHF9piAdu7w9FJqozouFzyx+yXZRyx5X4k=;
	b=pBBAz4kRYOBedCeKx2aiPYt42yEcrY/rG7iTmDeTZqU3LbKmbh+8CdtkXF7fGgOB30UKmK
	6dtvuJbn3+gQddM0ENe/fuGimY2whzhbEOB7EgTrdcReJ3tMTviBYHYWw3G6hI01ApXuJ5
	kuUSDizTTnNPKPwonBtnDMNMRafA0iA=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2b2503753efso174655ad.0
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 21:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1774757312; x=1775362112; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcMba91l4VHF9piAdu7w9FJqozouFzyx+yXZRyx5X4k=;
        b=FHXsCm2yLXKuXTMVHjt7Shdxtt2ZOgqDdEgx3BUOBfDjBncg7F56B5BrxMYknSz8iD
         4mquT+g4qzX3HToUE7+K16YLJQIz5qzeTrPoaZEIJwLHg87yok9wRjGUqj6UV7phqkKW
         aoYeZLkb5kTOXh7W6A2JZHTSHuhJtLemNIPO8hF8U6gAVhy7H12tWmmuA5EIVpb8Ni08
         Une/bArN2YwxDxK9bcA+7twlVzymc3KWZ1DCq3DelMDyzMnbx8Qq+utrMkxRkk47fLjN
         YVYUDxsFO79bM4NRSFwDWuxK35HC8NH1R/9HKqaxkkE4yzTwjT3RcERqjHF4bnfvjEtN
         QOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774757312; x=1775362112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fcMba91l4VHF9piAdu7w9FJqozouFzyx+yXZRyx5X4k=;
        b=GUuPkSbPLUKY5Pe0EJlajN3a5x/poYOyEsWKV3/oj/95UTc76nEETntY+dkpst+IjM
         f4ezqgoS+o4o2oHEdDk8ANYW49+s+3m+GDQmWX7+DQ4sPstWt/j18GcYfoambMrBM06u
         cI2g5hMQiwfnqLV7Oo+56jVT9IO1MoVqHWLfhRvN6118yd5tp793gbfGORidOYCy6OhJ
         2DqnAwSIPsrh1jEElx1TYgpkyBBcYKLmQ+bP3KL0TcKZWE8Rhlhkr6EsRJIyngFhfV12
         HPfhCt7u5i6jkVmscFCyVQHDh4JGTIHlE3XTr7+3rvXsEnvl85Q/QkOZpQoTJGLj+NQG
         iucg==
X-Forwarded-Encrypted: i=1; AJvYcCXApThVyjC+VDenb5JjG4gqRSYnh+0teOhTbiMcNZKBdrfjsazT+HlL6hiaFAH7acSHTk4MfmHNdg==@kvack.org
X-Gm-Message-State: AOJu0YyXwyP0HastifjUsCxqw8/6zb3Yzemz3Xc4SOHvWNZhMMTUDRnY
	9PRoN43IV6pfRhNy/reKgE1tun05XsbxMub7hqGGdj39q++ob/vahPOoTyJefUl1HCg=
X-Gm-Gg: ATEYQzwnN4D9B/3Ob3XsAFVdZWmOkQSi2UTzbAYj5a/5wG/Lvfb9IsnC8v06BhNrmXm
	lx+CxAN++GI1sVzyTeAL1dTr9YhGc9JMdctTGeX7ZzrUr7Rq2eZhzSUJKK6zas2LgBVWetrbhT0
	jsnd/DuBpOqGZUYieH70efkmkAniGUDroB4f9lBKOtELVn6xpjFNuCG8lt62EsQSLulj5ogqFAy
	Vz2UjfsxS2b2wEV2Os6aXlXEouqaqEHtGacws3j27fqYeNpG/NyLOXgM2hLa/85fcXhMrsmQzeI
	ME6sLAU9NooU5x3T78BS9qj6/7EL7YlA4kG1wyMNMGB3TEE5YJXMc6MHQ3F4WyOunY4FvmRUgpv
	RUbky7cA/ni6ThTlBP5nLcW07obNeyvNtpmJF/ngx2bxBsNw9xc7+OlOEC8Jhpd736Vy0LVmBMz
	Sp
X-Received: by 2002:a17:902:ced0:b0:2b0:c2d9:270a with SMTP id d9443c01a7336-2b0cdcf0019mr88952725ad.42.1774757311794;
        Sat, 28 Mar 2026 21:08:31 -0700 (PDT)
Received: from gpc ([2400:8902:e002:ded5:78c1:8178:95c1:6ca3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b24b3a82f8sm11038575ad.63.2026.03.28.21.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2026 21:08:31 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: ziy@nvidia.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	clm@fb.com,
	david@kernel.org,
	dev.jain@arm.com,
	dsterba@suse.com,
	jack@suse.cz,
	lance.yang@linux.dev,
	linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	songliubraving@fb.com,
	surenb@google.com,
	vbabka@kernel.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org,
	WANG Rui <r@hev.cc>
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Sun, 29 Mar 2026 12:07:41 +0800
Message-ID: <20260329040742.17269-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <52CACB9A-A782-4D11-8B6F-66DA8D345C78@nvidia.com>
References: <52CACB9A-A782-4D11-8B6F-66DA8D345C78@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 64ud6zd9qrwfzbnz3aoiz39f9gmg4ro3
X-Rspamd-Queue-Id: 14173140002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774757312-204042
X-HE-Meta: U2FsdGVkX18xLMK/kzN2CbK2V9MZLBU6zzYokD1INvWGRPBxmNvTEnpuiypqMoeprFFlrnaKuu+h5mvX1eQnMg6pS+gzD/qzWOSXkdsOC/SBwS+PtwDPmSgEIKdEQRDFbDiD5x8S8xDheqddAXiXfSBSDtMuA/X/cBqM2KxqHirW5zS1UEDlfc6dWjk/XWwQkreijv+QRnj4qfIeEV3UODqGdTlwLlbZiXJbxsLijTQye63L4Q5jMaJ8Vbzp70aACLs7oBCCV/DUSVST5/GWXJ7sfHBJPLqBpFC2n2Q5zpmDGteIFgFO4uREpNXmgHDlfypOeHmqdAkn/LTg56EvBu76FCIz1PrAz7gXiALT1r/60gC048TyiyQZw6UjnsHf/dvTzQYlk7CQLsb6Fj11rjT1auoEN2JfJ9N476IP4ou/eLZVkhYae/w2sffXWys0hczdezNu4GdVJ7PN8JqurHGIqBhMSUzRo9Jd0kc1lziQrpriPohz1Aje//TOUYDVWCNfqSLOUf3uhUIFwHYAx+C5AfJPUinlk1cZA7As0nwsj5HZpLIlL8Ah0FmoD6TkZTSbA6Z+YkXn6pRZwR8wmElLvJvGCOMD36GDM1LFyU9s3x2HlgLNN47KRpPi4vPEEuQwRWNvIjbg2dJkMubxdBnMYgYqB00rUpgsv4qxLwwS9wdPmjtkIuHxEn+Usf2gezJ3MRxKVKUnWJJO+060hI6wmfFB2uIT1PhN5Jj1HXn8sdRDrY86mlrKebuC1v7zQ5eSjC5iMXizXUos35pGQXf8zgx8r7il/1ult0/8OV7tsItP6VDbRvyehzqX6BKwmYM0TpbBpFlVaLu4mqXzj29sxO+eDP+uW8xCBqh4KHokeEHDcRZW07bRPTrtoBaM4Jlzr9nYnukifU5ecH+BI1tNt+qWJejMENDN9ly6GTv0KLcTV0kfRUrP3x+gLt7OeOdxX3E2pNHqh8OL2yc
 krY1QhzS
 YIewwrT8iwyw9Gzh8rjh5XR1QbsnjYNjbbG2DeLO/J0laTMsACuN2LNCjcP5d6FDuCqYDD3POkqWU4vxq/9qurqlmbEH4lRd4RL3/QgVDt/tFTbviysjryFNK5TNrbVbc/9OHe2Kl2MP/Y6MBlpw2qR8dzNqM/xFapAyrGXseB2b/c4xU1pLURivgCw9XBR3w0vMOCZLal0bCttX1ut2dTLlOBU4c6xXSooWhyFkUbGFEO8CYWjT18S+d6iAnThNfitygtz+Ch3VdrLLTUF+OVctogEiL0RmlSMsc6o4mi0sqU8XIc4iH0ixYkihQvcNuIoSLj9Y+clJ0G6+G6bCdYLpFMesOYW9TY2ByKclqr5xHWBhm/GSaNG7X95/Qlh+hE786Ln+k3XXyedB2GMPyFZiejxz01QZlq75bBGNQn5F1zqLaEYUMTNRYNZqTiYpeQcA1YfmNJk1aIPo65t+9Zvid3ddPd90106mHhI7PeyF0DrHjU8H6kN0OXoMARsRiRfiWDt0eJnMjG2Dq8OFfeuaSKUZB9Few3gGc9lypwLoEz2R+jJzbvGz4qDsndE9ZlDlXCnOnvW2/aeeO9DscmiiHa6cmbOgwdr8uHMrxnxZQgPmRsGD5gJbEO5/wPdomEaKTlWAt9Xec+hZTy1yGVgYFqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

>> Now without READ_ONLY_THP_FOR_FS you're going to:
>>
>>                        |    PF     | MADV_COLLAPSE | khugepaged |
>> 		       |-----------|---------------|------------|
>>  large folio fs        |     ✓     |       x       |      x     |
>>  large folio + r/o     |     ✓     |       ✓       |      ✓     |
>>
>> And intentionally leaving behind the 'not large folio fs, r/o' case because
>> those file systems need to implement large folio support.
>>
>> I guess we'll regress those users but we don't care?
>
> Yes. This also motivates FSes without large folio support to add large folio
> support instead of relying on READ_ONLY_THP_FOR_FS hack.

Interesting, thanks for making this feature unconditional.

From my experiments, this is going to be a performance regression.

Before this patch, even when the filesystem (e.g. btrfs without experimental)
didn't support large folios, READ_ONLY_THP_FOR_FS still allowed read-only
file-backed code segments to be collapsed into huge page mappings via khugepaged.

After this patch, FilePmdMapped will always be 0 unless the filesystem supports
large folios up to PMD order, and it doesn't look like that support will arrive
anytime soon [1].

Is there a reason we can't keep this hack while continuing to push filesystems
toward proper large folio support?

I'm currently working on making the ELF loader more THP-friendly by adjusting
the virtual address alignment of read-only code segments [2]. The data shows a
noticeable drop in iTLB misses, especially for programs whose text size is just
slightly larger than PMD_SIZE. That size profile is actually quite common for
real-world binaries when using 2M huge pages. This optimization relies on
READ_ONLY_THP_FOR_FS. If the availability of huge page mappings for code segments
ends up depending on filesystem support, it will be much harder to take advantage
of this in practice. [3]

[1] https://lore.kernel.org/linux-fsdevel/ab2IIwKzmK9qwIlZ@casper.infradead.org/
[2] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc/
[3] https://lore.kernel.org/linux-fsdevel/20260320160519.80962-1-r@hev.cc/

Thanks,
Rui

