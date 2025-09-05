Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9C21CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2153A6B0007; Fri,  5 Sep 2025 10:35:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ECBE6B000C; Fri,  5 Sep 2025 10:35:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DB6D6B000D; Fri,  5 Sep 2025 10:35:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0BC26B0007
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:35:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 65E7157D50
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:35:32 +0000 (UTC)
X-FDA: 83855444904.19.B0691CD
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 542AD8000B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:35:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OH290tpZ;
	spf=pass (imf30.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757082930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wBMMkeCxHosHV7c8FxU0uPkYWEXN7KfNUsOKbUcY+ww=;
	b=MwgUOogFeBl2r83Y5vGVY19wi9T8Gel0QZSlKcZzgNaL3r+O2tb05Iky9/z2ODGTaDQL9a
	raSiQlOt7mgZ/cLXXyFyXhv3G5vkEW4FIHe5t/+CfPFc+SDOMDDQIC3KTJ5VnxnI84qqTw
	SF4IvvZ7ht6lpLDOn4deez9ZXTG5V2I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OH290tpZ;
	spf=pass (imf30.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757082930; a=rsa-sha256;
	cv=none;
	b=dzU9DdabsGGPNZMRZ/998ycs8+1o7NfEyWq9VizURHx4FJH+SBDoClElIiJ78px2mPOVlI
	WZkSoOOX0+xwUe0Vv4Byqhzxy2ZtVlwafj1lBeqLTswDbHsvmwG2ziAsdDmljCmjioijoB
	hWFd1mH77D/+guoPHb6ZR5BRKZveIV4=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-55fc2236ce0so404330e87.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 07:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757082928; x=1757687728; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wBMMkeCxHosHV7c8FxU0uPkYWEXN7KfNUsOKbUcY+ww=;
        b=OH290tpZ2CH3bChu6AKSzNiWHM/wwtKQZOvfhCgBf0wYaaR2qmtACnGE0Gp0DiiEQh
         zyIZ7/OwrbqgjOynalnzgGKSS4u09SxkMRkPhXeaULTsvHlOEu2WoIn/2U9avRvIVgMo
         xza4FxWHqHaIit04GmS/AWRG/Oa9o1Rvit6NSbtHeivRFhy2y3bB3FECmFEMHKnmkMDP
         Psx1RIH4bsnXg50w8qq9u6VS00cUaewlUCOESkfWD2eo6d6qvLY5pl37EIoznBf7CnEz
         14EX4tk3+9kOG5ggRCn1x/yIVowlsCe7SVzvMI/4cizUfqorssFQIvh7fV2cI09YE3W8
         S08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757082928; x=1757687728;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wBMMkeCxHosHV7c8FxU0uPkYWEXN7KfNUsOKbUcY+ww=;
        b=Rc1eBpUnCBGlydDhn4BP5ZhWIyeT9n1xMsmQqtVpZ08rt3Q1mfypBSfCtAlLhepxBS
         kkcOyu1kLGzfH6DXsBwJ0O+NCs2WoKCKCDT4x5FbqEShOhNxMwKxLuPKImKPOGuI+efx
         YS3IyXEremHCEH7qVVr5SWgKsmFVokiyKPbeEouHbvHqcHhIrBTCMREHfq2ZvK3Firkm
         V/33h9qjBX/5xCNOANv6f5D/WZNM3Y5Eh7HrfL44YoQ2KvOhwdn1dofHvEA0+GUwmycf
         4T4HIsTeH8K7YkWZCGwr7BxCQpuGoFFnYy6P23/jOUDHNXCI5dQgYkkatv0VYveGV/Hx
         +HgA==
X-Forwarded-Encrypted: i=1; AJvYcCV+KU3A7sRkJRGE9ovYt54IyXmK/i5DaapOVhLxZKo+dophSHI0cIi98BHFl6+06dCwQjR9MPKlCA==@kvack.org
X-Gm-Message-State: AOJu0YypkHNgW/kWUWtyCz8fsOF5DK0YpRO4n19J0+DRCe8ATL0xXw+z
	owFJ0xlmCnTgnz0L6U26w6QFLz4rTe3O7YLoFt8jgjQc8cptYxl6HpcH
X-Gm-Gg: ASbGncvar/68///Xu6xSwozZWBL2Tsfn2vLBaA51YwEfM70fuVCCLtFeCtoKULAEkjc
	SlTJZ/K3IfY3ROadXJeHaHRLBHy5V+H+4aRbD35bz+wVs0gBrNzni19U39H2udkQRcY3gQwyZPX
	xDiSX12fGHJchzg07t8IgYPwiw/AAd/uI0CkhcEhh51/H3b+8yPpH4L90p2xvHbvIPO3xwH1awS
	WDGkEOxMkgkdcSEinPzpgn5qPj4UWQ9gAgj5vvCqE4CDxZWaWTKJ/5axmRwTgKU5eiwhTAPy1KY
	BzFBpUbHWqTiuOdIGpKx0C2Xznc+nIbghVmay0AsfNSTCFTYr4Jv1OqScDjW8ZDzHHh4FLoVNGa
	lsjf/iOW4XhjgLHgruE6RXYBrjtu6r27m1QHdKds=
X-Google-Smtp-Source: AGHT+IG4masltMaevxRMKJ471lFxHbeaLe9lEpEOz6RdTaqnQgxzkAWchzUMWXSGkj3L9K+f4Q+ZOA==
X-Received: by 2002:a05:6512:31c7:b0:55f:67de:343e with SMTP id 2adb3069b0e04-55f68b7d516mr4140045e87.1.1757082928376;
        Fri, 05 Sep 2025 07:35:28 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5608acfc25bsm1820494e87.98.2025.09.05.07.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 07:35:27 -0700 (PDT)
Message-ID: <7563a670-0118-4110-8ad6-7771f22bd046@gmail.com>
Date: Fri, 5 Sep 2025 16:35:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc, mm/kasan: respect gfp mask in
 kasan_populate_vmalloc()
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Baoquan He <bhe@redhat.com>,
 LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
References: <20250831121058.92971-1-urezki@gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250831121058.92971-1-urezki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 542AD8000B
X-Rspam-User: 
X-Stat-Signature: nn1raf9caemcs4cryw89u45ih6mu37az
X-Rspamd-Server: rspam09
X-HE-Tag: 1757082930-578646
X-HE-Meta: U2FsdGVkX196yFfRIC2OfE8GsoaO5rmuYZ5dzL3guoP62cn6UmW5kDWFH2Tn1GbLZ/cetG+6ldILh25br0Ky3eOgYpDHAuLK7AE2Q2s4jDuLfUQzLKhW1EPOUk3J0jP6ISB1cupVzCuCkUKFBORfPj2LUrOdMpmdQv3+0QjTiMnzfncVWeoiMI55ICEUauRt+G+aQr+lw2SLDZwGBeCwnonXGvzO00UuZ9Pd2AKfNyrHNp3oQZLEqgbdy4VTcQ4jYLoyMwt7yhY7i1TDrCWvJqjodZlxstd3p/EXmleTtZSyo6vdgw6d9V5l1iFhMzXPlZUyPM8lJdWOifmyWWDA+EVMQKIWe+bnMflHZ/a5evro1Zstk4o+E2eBiESEN/q8RFXHndvKRF2Vhy88thEVR/EJDfRbddKkdVA8Zui7bCU7gNROmKFH1c25DaELJsWwb1vYMSM5ePbzUY9o516g1R8WizsS2ZOclD80jnsDZS+n9+gzZAkfFDVBpQ3x+mqk51dKjBFd2ugt3d3IP2JSQMOtqLayw37vX+CddbF0Jx2Ad7IL9syeBU6T4/J2iv7QrXsDwcEqS5R8ucXYn0N5OZY9uR3JcJ5vj78FD3GgfgoHF90zvEsp737XGps36EQggi22XotRAiewMlIAjHjt9K9k/Lwjot2nuEIc6WXVWOR4WADrah3i9mLchpMS2IrUUhur/aRfG3QnO3J/OKLgTmCGnIXY7rzOt8NQDdZxqwbZ19nnvg6aJn6lRCtjY/UQejiPG3NHbQcmTQoX0e6Vb1Bd3aVWad2tQpC3ice+q/LDRgSYjBvWuqtac5mArXxb3HoiKjnzQrhHc6XzRxZj6odL2SLuJK0oJCa+tKyjOnnVcZ7SwVn9el29k58H/cYoXKubwacZXFBPTDmUi4bo/EaV9Gx9T8KkpTwv/EQf2+PhuFki4caT70bGFGnQduX8PD1mlFU8+B6SPWju9JD
 mVJ+WE2n
 Ws8KsimrDF8t63dsWMVTDPyEujNrWSZkg+5/7o9mRql1ybAENimbCdhiwnX0ctMh+FOv8Nxmz7BqWAnzagTeU1zEMK1zp2xSi2s/J3zrc0vlBiFAbiXhC8IWGRmci6uR0RZpvoYScze8y0b6PJgVJ034GUoS+YILonH/XMKNEMkpynwbz8UnLPLSdvg0DEZ7n8h5zNhprNhNj5d03o5R+2c4XyA3SONoO2tQ7EPcpaw1vxuI/7hrprC6j0E+oB2MSFt1y7UYJIfagyuWreCogtzezuwG2ASVPX50OdMYsNOFC9R5TIfK6lVZ/Iw9iWXAjpKAVLh59VaJwqkWZNFtCsqk0fdC8fZLDF/j3jcknhZrpPy/9jAsaKa18L91zJpzWwfHROdxwGv0QO0Ur5qUwR9kGBA12xAN4tWiTk3OqCp1OmdxPr7HpMx3/3IbNp6e+k58Wuf9Bb7Wk59cts2zTay8FjbFVTKMRB3QaN2cR+VsvAjrSL/ipAyeeJtR1P/bfyNXkmmRjghWJv/N6VBMt/j1leIhD8nWHo7ip2fsiykQXvydZbJX405fnywYzp+SQZsOxQzhF6pwfcsLNh+yAi5WaV4yLHUnk8S7pbCGR8kjX7axKB6ZzKdkIGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/31/25 2:10 PM, Uladzislau Rezki (Sony) wrote:
> kasan_populate_vmalloc() and its helpers ignore the caller's gfp_mask
> and always allocate memory using the hardcoded GFP_KERNEL flag. This
> makes them inconsistent with vmalloc(), which was recently extended to
> support GFP_NOFS and GFP_NOIO allocations.
> 
> Page table allocations performed during shadow population also ignore
> the external gfp_mask. To preserve the intended semantics of GFP_NOFS
> and GFP_NOIO, wrap the apply_to_page_range() calls into the appropriate
> memalloc scope.
> 
> This patch:
>  - Extends kasan_populate_vmalloc() and helpers to take gfp_mask;
>  - Passes gfp_mask down to alloc_pages_bulk() and __get_free_page();
>  - Enforces GFP_NOFS/NOIO semantics with memalloc_*_save()/restore()
>    around apply_to_page_range();
>  - Updates vmalloc.c and percpu allocator call sites accordingly.
> 
> To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: <stable@vger.kernel.org>
> Fixes: 451769ebb7e7 ("mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc")
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---

Reported-by: syzbot+3470c9ffee63e4abafeb@syzkaller.appspotmail.com
Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>



