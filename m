Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50787D4899D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 13:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4B576B0088; Fri, 16 Jan 2026 08:33:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF91A6B0089; Fri, 16 Jan 2026 08:33:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DA6C6B008A; Fri, 16 Jan 2026 08:33:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1BD6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:33:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A1381A014D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:33:40 +0000 (UTC)
X-FDA: 84337919400.20.9D6D667
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4922516000E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:33:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ARGWf0uS;
	spf=pass (imf08.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768570418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJ0Kd+SlEJxKbaePbsW3EtzVjRrjQZdOLYvse/lYkyc=;
	b=IIjpXtNolqd7LLIUlJ8RKm3WAQW06oueo4bHNYMMLRjkV0E+xGXvGskaXxIn5MG54uDuYD
	Eg/I7I84Bpc8HBG2dRtWxZumpCHFFzx9VvhkeZZDgv5KwN8fEr2sBOorjZGf3gs4VB+Qgt
	DqehH4jVKoE1lpwbZM34r1mr005KICI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ARGWf0uS;
	spf=pass (imf08.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768570418; a=rsa-sha256;
	cv=none;
	b=DQzYOsOnaXre72Mwj2R1f6kDM1tqBl2Ilcx0BaaReGRHLk9u/M6+5V5ZnGAWLXiEfyi4Lb
	XoBSPJeAiOJY+uqLzEroPlFQ0/o1HBQvm4bn5MuxvKHf8GjvuDZl412N9rJsq9ql/rPCJX
	1ljJNsA1TWlyctJTfxoGzIEaZqMJkNY=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-59b6babd619so100585e87.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768570416; x=1769175216; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uJ0Kd+SlEJxKbaePbsW3EtzVjRrjQZdOLYvse/lYkyc=;
        b=ARGWf0uS7NIdEIOO3bUFOJV3snrzUuFezAu/PmYBO6H9OnifZlP68NFZXxZIdnTCU2
         NaS3l8doHwlZ7U/+UUrak2D85NjSo80HrNRxom7n/rAlroH6Sn/4mwW9GV2THOQLfSrH
         6D0SCNJgjpNZ3KBqfZyxMuuyOQ39+LDsUnulr1gYbPfeebJ53XnEI6GteeNQ6yQDOM6F
         xx8c+hU9IVKxMyZGMsgSC0RXQb1dsA/CsJWSsuWhIXMr9tXFPv4D55XyJRKBAKAlPVQS
         KBat5NYFRqdONNWq8WU0eMwyrsLa0GHOT7tYOSuBQljOrVV4VJUC91vtfRSGKmzqAqGx
         GS7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768570416; x=1769175216;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uJ0Kd+SlEJxKbaePbsW3EtzVjRrjQZdOLYvse/lYkyc=;
        b=H5HQavuz7UV9fc1lUEG5I9dmyI5HFm6mGtUsYkCMbrtkYVaNq48t/ABbdGK9IvltjX
         Y1sKyy9+rL0JX8v+vMPOkwz2AAr80KvXcMBdzu7aHBZ6nHlp1qboLyqFCpFp1H8VYbZe
         Ava708rsLw4ACQVtUfTsmhxwFuSrQFjpzNbT48Y1VfK1O/HpCusoWndnAZYs0C6IV4pl
         1ToBObK2eSL1RGI7HZ3mCvcmfXo5HTjUPTdLZsqbhoAbHBUCGowzyjdwNWob+eB2F9vt
         9h0kMk/ez4WYOZ9uPzz7IKsGLegSfiFDmK4HuXWUuSllP72Q5biL5QRVHMYWEN8fN5xx
         wX9g==
X-Forwarded-Encrypted: i=1; AJvYcCW1pPsTeevSoEf4xjbyWcaMEpNYWY2ZQR+umcPXlimpf9pKOJhJt4zB1n8VOa2YOZeEiVcNit4/1g==@kvack.org
X-Gm-Message-State: AOJu0YyypPVTfr3OmxINHQ5DbXtb8dBx9lQwTNixWPgVpvCkYQQfJo0T
	WYLSnOLUn/zWAi8Aj8+XV1c5P/fsWvgI/GdKQ+PufSVIVebpsuFYN6m+
X-Gm-Gg: AY/fxX6uAjT1Iucz1JaVBtMQ5+1i81h2TLgfI8ajTpMLrF3ghY2AHf7Ka/k0zhOUUKg
	l7HJeDI4Tzp+NSh+i+5hfifVrCp7zQuf2CFkRLKSsyk5D7ih9FXFM5pPm+G5NyPv3qV6TrQEj0c
	LXl8EwUyC+p7O1a7lBFJ4UK6zBn6bN4e1u+5LN4hfg4bpEKY17+ujuGnkbI3Whf2iK4rAjYH8E+
	8RHrUwSVuOqvg8k+DR/Hew/Pl6aiKmVF2LfKX7EiME2PLEC9k0mEqXG0RX8L9ckrb2SUeR+614d
	05XR/6A2lmsu3YJQtSKuYegCM2DuXKdP/GX1h1rxxYH66MhySDzdirvEThfFaI1ZFDU2JeFALZj
	m23DUHc+8sRdT1L9ydbizv4Hhemm/z8qJ4Jnmojg7os4bqIDlWHujdwig2QMglcu4WP9nFKQ/pU
	LrfeoVNeUldW1Ecj4+6g==
X-Received: by 2002:a05:6512:6184:b0:59b:9fc6:f66 with SMTP id 2adb3069b0e04-59baeeffec8mr547766e87.4.1768570416127;
        Fri, 16 Jan 2026 05:33:36 -0800 (PST)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf34d572sm763752e87.24.2026.01.16.05.33.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 05:33:35 -0800 (PST)
Message-ID: <c9841bb2-b82a-4daf-99fa-17aec157e2c2@gmail.com>
Date: Fri, 16 Jan 2026 14:32:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 02/14] kasan: arm64: x86: Make special tags arch
 specific
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: Samuel Holland <samuel.holland@sifive.com>,
 Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
References: <cover.1768233085.git.m.wieczorretman@pm.me>
 <be136bf8d1a6ae9ef98686c3ba0b6a4e2ea2e780.1768233085.git.m.wieczorretman@pm.me>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <be136bf8d1a6ae9ef98686c3ba0b6a4e2ea2e780.1768233085.git.m.wieczorretman@pm.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ng1haxp8sf6e743x18exzb61jjjampj1
X-Rspamd-Queue-Id: 4922516000E
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768570418-812620
X-HE-Meta: U2FsdGVkX19Uhkk9nMglYMOySVz2+sfV3lQafBb+IhdpPdPjGRxgW6g2Dc5+SUd9gWPdeS7Mpl4Pj54MbxoG6yxipdl1HK0Ei/CJmGvW6I3Ubwv12mouE4A3xSuweh0xFhdjC2s5Vre0lZN+wG94GJREgbhM+8IRsa7BzL24hO9+kezO3adhsAFIARxdlr6pc/APlgXpECSD4xaguMwJW1g+8bGb+rapsUWFt5A3yhLGevE3lDS1KsoZpQQecdgsxWwUIbqmPz5sh9E7hpu38WA2gv1L4o2QT7FblkquUd3CNi5QyXOLcDSWi6t/txrSqNQkqcZHJ8NYEGyxgKKHiLdN+IYpyEzQqHpoj7yOuwzRLyv32I5CwFiAyatMP0/H7rXNjI2hugvpf+aCRxaUwa85jaXA2ChrhRA3afGIXA20oJO5sfZ8deW4dKKVopj4iamqw/62mTAuBCsjE7w7RvWEA9KdtwGcxUFbbldfldIJbzeiZ5fDuq6qRg7sHdb6sGmqgOYJ1XDsHkguQyna3y2j6vHgOsMJkDknRN8ufzZOGlxnrcwpnaNOnqajD40QMjglg9wBiY1ucG/ajkftAC4u9J4MAIYW2YovjIqO2HDj9wXh/xvwjriEzRyMylsQpKBsXxErk46FEjvqM829HcPYOFoQmpFP2LYxY610qHOewBG1vdbY/RnKixfdN6UNtwWH5nAbtt70HRhrspYmpBO/j31fG5IBhkor6+1E9/F27EEjTAoJhzFkToCL3djDtwWIViiSqmEE69euHv8lclvkwcVEP90+8k4zRGUzEgHL+rOyZA5Abc9eijmz9R2CIGsrwdo9WnX7Ev7yxIyw6f42bq+nVUonBNNlgHic+z3BCMWlKiZCuijisFmlOWLddSmzul6WbJhE4ot966cvPq1TR2Rb6dUVhXvefNX6PmKH/KwUDTnJEOV52eiO/Y9YF/AG48ipcGtk9zd0UMm
 CiI9k/pa
 87QgDE5535nm/X9UrLw52q71BfN9E5IiVVoQXXA5avrsXE0wihND//PFEn/gYYmNo2d89yml1V6CGvnnhY263gUmy5e5IUVFwSUSrKltfHgi0vtJBLMtMWm5TVJfL8VZmvBRb5lRkZ0t5HfWAcyVjN+CH8xQDiAkL0AH03q/IrQONqspX06vosFuBZRjy7+KtooviSpOtUWL7m5vgJE/OnP+J95wBCyNTHKAUS2DVMcnoAAm5NOElLzTPyzsPddMo6FnyrkkjX1t5g2CqNQ1+AkoFfyxdRE+4+AJ4pf8m8/x9RSW6JTW793QXcLxwjHLXaKGAJ8kxd8+inR3Pt7lCCgF9AqmLHyGPBhTGe5LBaL5Fl4jZVCqBCUa5krQw+GFqZn0m4EErtKAeIHgUfs2ufhdiG86Dx3+ae7xrU44bV9kR8uAgyBYhLhHFtvzC3q+wjHIyhRyowjyUq7xgzEYaRxDthiRodLOBdYxHrcykHVrDJUwS9SajUJhSLAPl+JgegX9DWw1SGQvYu/ITzeVd3SeEvAKGIhF5AagnD8olYKxQB4iN5gzYnHeJ2kixEc3/oExUIeHu4GxXOgCw7vbBBRTbmR2o6Ls/ET3X59S7B87jqmAN+JSHPkoZxLw32ZqpIF5YOIN06QWPhrE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 6:27 PM, Maciej Wieczor-Retman wrote:
> From: Samuel Holland <samuel.holland@sifive.com>
> 
> KASAN's tag-based mode defines multiple special tag values. They're
> reserved for:
> - Native kernel value. On arm64 it's 0xFF and it causes an early return
>   in the tag checking function.
> - Invalid value. 0xFE marks an area as freed / unallocated. It's also
>   the value that is used to initialize regions of shadow memory.
> - Min and max values. 0xFD is the highest value that can be randomly
>   generated for a new tag. 0 is the minimal value with the exception of
>   arm64's hardware mode where it is equal to 0xF0.
> 
> Metadata macro is also defined:
> - Tag width equal to 8.
> 
> Tag-based mode on x86 is going to use 4 bit wide tags so all the above
> values need to be changed accordingly.
> 
> Make tag width and native kernel tag arch specific for x86 and arm64.
> 
> Base the invalid tag value and the max value on the native kernel tag
> since they follow the same pattern on both mentioned architectures.
> 
> Also generalize KASAN_SHADOW_INIT and 0xff used in various
> page_kasan_tag* helpers.
> 
> Give KASAN_TAG_MIN the default value of zero, and move the special value
> for hw_tags arm64 to its arch specific kasan-tags.h.
> 
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> Co-developed-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> Acked-by: Will Deacon <will@kernel.org> (for the arm part)
> ---

Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>

