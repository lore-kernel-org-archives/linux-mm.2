Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02A0F606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uykbY/4O
Received: by kanga.kvack.org (Postfix)
	id 132986B05BF; Sun, 22 Nov 2026 13:03:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E2FB6B05C0; Sun, 22 Nov 2026 13:03:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F140F6B05C1; Sun, 22 Nov 2026 13:03:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFDF46B05BF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:03:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B37CA078A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:03:30 +0000 (UTC)
X-FDA: 85463527380.24.01D78CC
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id 522DE1C000F
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:03:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="uykbY/4O";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795370608;
	b=Pw0HpXMHj9frOFukYrqhsGLuORBSiCB4AAZJqQV5En69xP7RRDLYpujQgaqHFvwi2WcZBp
	M3vMnkfTRcuCYcIclPfe0gwQfkTzKdCMa2a6uyoQMZ5aZ6SdQ+EyBunWXP9WcI8XKXuNSv
	JQ1hvpI880tvq93+HCQPlVpWmrZEwtw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795370608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KcdVkOlTNRHI7ZDEV4KijIDaD+lWmFTKZp3nDfya9kE=;
	b=YXRyDtvaJiUxkEDPf7gCFnBAo+HabgaENktyKtaHmmrTF6JzMVBHzXkLyG/8W30maM1nKs
	F4D+HvoEBZswH7Ps0ENmD9wBgbrbsQCpY+YWRoRrJYLYAM7VF33RB2G3fiQDCktyy1WFFu
	wGZ6bmx9+7WlzhK/3qE6pkx53b4eVTA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="uykbY/4O";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4bb61185057so16303545e9.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795370607; x=1795975407; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KcdVkOlTNRHI7ZDEV4KijIDaD+lWmFTKZp3nDfya9kE=;
        b=uykbY/4OK6V1Lt0J+36WcYm+uslrB4PkMkjyShe55x9Ki4PTfclZm6MBXe3yVaUIFi
         sSklnQ/DhkHusU3e2des3J1XM5BSKhuzPC9xCOpik9G3Whfs5WljB9OO7uot/WpdyIDZ
         rMGANLeapFGQvGIwt7LTvQhzWbQBFgk7jYm5aU1DfLtiYUig2M7LFBvPGOwgbF/zjvtg
         ncrywYBGYYnINLt3QyTEKUyiqDK/Hcusy9gIv2swICUA2xlPob/RFVm7qM+AJe04kZ1u
         k2J27wk0Hvyh6MUqIZ33ZUysa9Fww+KNDKoXFa1ezc4zsqnitBcJ7cDXJWSTzIAvlvew
         apQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795370607; x=1795975407;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KcdVkOlTNRHI7ZDEV4KijIDaD+lWmFTKZp3nDfya9kE=;
        b=Y1kfrOfHmR9zZr9vjL5nup/IGuUQjtbWet0Q63qHqst1mqKAnINPOfKwYGNUzDYvvM
         bo0l4AOcZpi7TTVxeUjQln4ZT9h4CtU+2vzHiaxqPD/4HBkGIOMbHDDIowt0M+krbfKa
         eQ2U+pUQXxnwSxfTrhj9j7Parur+puYYzW2CnAbo43F/KRu/AH2ULF8pqeMSHpk6kzb/
         h7U5LrGX8cV6IeSYwgZD4x07q9pB6jbUcyeRmCnY68dNbvN7bBN7uxbOJ8c6oaFRmdVq
         u+aPtPQl8KIAPi8aYLtARFin8YDNS/45bELGbUcbSJ5el2j4CqWOW03HyW7h0XqAZeay
         Ygyg==
X-Gm-Message-State: APuU4Z9L4dv+J7RBjWUO7OtBXQ2jdZJos4fZBLbxAL1zVYV4MQxd6zvH
	E1vHSsOjIAW+E8etuM8Fi5aFtDs3T6reEB+kqPc7iLvw2st+4br846dI
X-Gm-Gg: AZFdTZfY8vmj/ByOK0CMusXIE/uEY5Kat1kCPsb3+yT0fCd6Clc+Rq6V97J2cwfLKrO
	7/X+K/0DkpsUpDSryEDaMYHVy19P0Uq6Ew4zkIvgD51U4IOusi39iKQeCULdg6snyWA92yc3LoB
	7tsN0Hie3DgAnNjZkX1axmJsb9u1lOpzkctDks6pIEH4FxaZgb8BODZnbej15Qa546jXXhtwYCn
	Q178IEWlElRoEZpDau7//RCpUCBIkNM1cyI7qPmsAUnK2A7yhMqrxF4HlndWp0CJCxr15/C2Wz3
	4taTe1ExDe1x4tLqYIM7Lp+4beH7GzXdad1eQYZfhIRA1/cmL6IulRYwL3QSXjPBxHm0A3L6DUX
	Ivos1n3q6K+2GO0yHZbCvxkBPkVDewU+lXUMz99d8IE3u1eYsU2Y5tApN+QFuRfjae2KmsyvMdk
	U7HvmDESve6+Dv+trwujfEHRhVFk4YDbsfROVf/EtQsu1AeVRoNYH2smy87BqCJiTPrfHtrpCBt
	5LTek9+uFNznAYOrzN3jd/18VvAxwJYX3JkhlrI60kCKU+rg2GHPwZ40V1OMqIagf0A1k6OdgjM
	NWvHvwhVsQXIWTafqwfhx4Xh
X-Received: by 2002:a05:600c:a087:b0:4a2:5267:3cd4 with SMTP id 5b1f17b1804b1-4bb887c9fbamr202961535e9.3.1795370606966;
        Sun, 22 Nov 2026 10:03:26 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8526cbd0sm373065305e9.0.2026.11.22.10.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 10:03:26 -0800 (PST)
Message-ID: <2a0814ae-801b-4f5e-a2fc-e287de15394b@gmail.com>
Date: Sun, 22 Nov 2026 19:03:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] mm/mremap: apply the mmap() offset limits on
 expansion
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Kees Cook
 <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-5-236e925d9b64@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261121-some-more-ai-fixes-v1-5-236e925d9b64@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ge9c69ds4fcrs5fxd5t1eie1d4qay3y4
X-Rspamd-Queue-Id: 522DE1C000F
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795370608-314609
X-HE-Meta: U2FsdGVkX18F9Jb4xW55+ERm4/MlNXAogT89S1a1IsQ/TMOfIdzr2RTICsZOKIVRQm5lWu7WF7B18p/xgJK6M9w1LF0QcoUGcjF+5s30RvSiK4AjvhDuPLt9udebh14AXuJQsQMriTBCNSn4WSX6aZMz6cF9E559R8BuXHk/v5pVyoVuQeOyoi70iV5Qw6DvZCMyDyOv3PEsoYOrsmx5IjnzH9URyKw62oB4z9SSwIKNxAWAvy+QXybjXQrRGplKbaKcNuNF8EfKWojhPSFse4/KQc2etmkTTntM/i4Est8EGURrcDRG7REHkqJ/YYBXQ9SmzsJDTGSsM+5OSC1Rjc2x+sfe24pUZG6BuyUwL9rMufwtkqjyQFADZ6u5aZPlHhZFXpYpJK314OPnLJb1FbWN0CKrR4b4BVqrQvDPl2mf3T3xa5Jr75K9JxlK4dUOdD+QHCfKBKu1wpxSOg4EJiyfOp6wtRmMmPr3V+3lee3X6/YpubFVs0XnKHR44Sm7AX/QFMOTYyuyOnTT0ccXZoL/qEwHq1A43xAQWYV1fPGpe68pofPhsxLCHoBC75qG4ngc9O0k3Ob0sA8YDWXGR4T+NRmSqNPTRWJmcdt5JE5cz+migrnXthF93coyTPpIaI6VhdsVdDExtyrIPhkQLf/gA8TP3hIOlJXq5m+4sZL426qVQZN1zrqcXFoN3i9If/DPxL8WJgoqwr6bt3Mb8MR8AqWx4J3KfW3l7A8VFG+GtX9SQcFEyOptxXdmZdkhaEVTzgmWl/UXGGWHSAFvfKXBxC1cAnl1fqz4uVsKhP85EV4zq8jJJRetnmSviW5qtT+Xfc/w+KoVdZoWc5tVnyumXvQ/1eNQXybwT2B95opzS4C2AEJEIMokd/0Ur3riM1VvS3r+i//Ud6tYIbTdS1Dbhd3mO07F4yD0qEna8A6XvWGy+lr+04k61Sez2Z/E95+NFGRaZh+LONaZhg9
 vsq4kYS+
 4+Jq+sgIQx0Gw9LjTxFOX1ecH/xOE/9cV/O1lQNA7dnwDjSb9d+SkbtbMcupbV82lnBrv7A/et7dT5ok1fCe7BT/EshWRALPAeRmoafEsqoEJEs+5dT/sYkMS+bLEBYgOfK0+tgy4e9i6IY1bUyPJv1FTOuafrCm3H6j/TnAmAnK0riY3sxTON6aFr2Y+i/Yc940QBAliqsHxPTknmXRO4H+XGzgofvslHW99RMw33IRYEWjed7FqbneUpTF+M7ezpFx+zoHAK0lpXoLUH2gE4ARqD+7D79V4i5m6ChSvLmBElx/dl0H9erfFMkFFk7VVkQkiPxLKilu6cfGw2Ha57ABd72xlVGZsuXJ2plJl0uXwB8v9Yu8VEeFN8vclfKm2wEIeWJaiGziQ+Qt0Iya4to8+5yzCzZ/SdWcyrf7QpWEZPPw3HW35IEC8XKp4DHpjxfN1/jluRGR1S9H0IRif+Rbs5+3PjC7xBepbNlBT5pBmXITG9celKdTcVze58yaXDT2xc7x6pPQAtLf+71/VYtNrc5ovUGQNCg0C4tNL+5b6+xfXI0Q2qxaR3DI6xKo2dfzEnUCfvLzPKjX/G/QW9+z98Gaak1jK4UDAmCDXQAVbOpoGmyWhGMB6lwBBogsjVVZTvAZRdmGMkJAYBULuvWImeFawFDFlG6Sivk0PnX+Nn2rgfeiSzJvYqthqGlBZs7xOgCPLiNJpkqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/21/26 5:02 PM, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Commit be83bbf80682 ("mmap: introduce sane default mmap limits") made
> do_mmap() reject file mappings which extend beyond the maximum offset the
> file can support, via file_mmap_ok().
> 
> However mremap() can expand a file mapping and only checks that the page
> offset does not wrap, so a mapping can be grown past the limit that mmap()
> would have enforced.
> 
> Fault handlers rely on that limit. For instance dax_iomap_pte_fault()
> converts vmf->pgoff into a loff_t, which overflows for such an offset and
> defeats its i_size check.
> 
> Fix the issue by applying file_mmap_ok() to the expanded range in
> check_prep_vma(), failing the mremap() with -EINVAL if it exceeds the
> limit.
> 
> This means that mremap() now refuses expansions it previously permitted,
> however no file can have data at these offsets, and mmap() already refuses
> the equivalent mapping.
> 
> Fixes: be83bbf80682 ("mmap: introduce sane default mmap limits")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: fixed up commit msg ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

