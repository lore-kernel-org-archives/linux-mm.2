Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF0BFD4899E
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 13:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575706B0088; Fri, 16 Jan 2026 08:26:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521F56B0089; Fri, 16 Jan 2026 08:26:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402A76B008A; Fri, 16 Jan 2026 08:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0E06B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:26:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C4A4986D11
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:26:56 +0000 (UTC)
X-FDA: 84337902432.26.74AC887
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id BCD661C0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:26:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CxbCWC6j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768570014; a=rsa-sha256;
	cv=none;
	b=1X3lCe5CTONEvhqW9SX7RXl999MC1ZryBJ1LIv/fnbdnVNk8gbHsjS+b0C4LjwCDATm6yp
	9H281dLX2xBcKEwUTGzl7/yEiM+WxeH5QSQecD+i476bg5ZzQpLrmFM78XxTBM2ncpo3LI
	sYIRDhVPDSpWF4LgcEmp/BFcoHt2uwc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CxbCWC6j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768570014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0eA49DHdlAf9Bft0pCk6JLi/3Gfwpf8alD37YhIJQ0=;
	b=iONyBKnUnBUg1cYSTE2j2Zm8um6C1qDrQG8IODuR9bHWk/Grb2hK2EdI/npqGnH7W1Pa5T
	/HjKCBBn9/RcwO7/7f6ZbCcmJdmXKx11qpgHfz/8ruqJUGD84pDGtcUrDAE230govHIw2Q
	ywCHFX+Jukx49gyLkKXZXkPiEJGxdEU=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-59b77ff32feso270196e87.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:26:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768570013; x=1769174813; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v0eA49DHdlAf9Bft0pCk6JLi/3Gfwpf8alD37YhIJQ0=;
        b=CxbCWC6jhztXZ7WmMcjGoCwOWbUg/wRE2i/ReaoldaYCvhvm//s5ldGhaxffSQylkj
         GImAu6ydhDBrLni6yVz0rsqv8bIpTnI/iszQP6QgBpEgBvqcXJybe6UA0wv3J+ggCVXP
         GXTHp+teGrnajsBjKcZsnQVN34TFSxIWroBRy0+rIl0Gjz57OD40mDm+6Xug4xN47etQ
         5ScpJ+QThKb+oOahalSJUQtTeHb5orHX8nugb5lvlI+CNI+oepHP0nSSerdlsiBs/W1a
         YCjh6KhFf4sJ3sC9na8lkKWg7YM8GfEElFc7LnzIVAk77UCusknDKI3gSguPiJ63NcUZ
         B4nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768570013; x=1769174813;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v0eA49DHdlAf9Bft0pCk6JLi/3Gfwpf8alD37YhIJQ0=;
        b=TYvC8O1Asn6aMuc2+CFK2yOhlv9DoC9VHx5QxTZCRlIwIYgI76IUxZ3U6ZbaZjKoTT
         ZHyNNo6zc0zdWJbuhzaSqTZSsgHPgKv/BH51WwdQhHebvZKfZvL6TtpI6ODVRROiQ7E/
         BMLIYqFuM2L28nS6prqEqjLMGWDeCR/3W+vBKfLTsfw1NREtTXPpuSONnJzJ1DVPWwLk
         gwfoluNTVSeLo41mCP22ZL14eHgpThjknKooFRXkFdzbnsnSnJk48rjO3TWNJTLYQaLe
         eNCM7FZ2k6+2cIB22QLQwnTGOU1t+ENt61rXFm4oKiQOksfFRHF0eBsMy3zdpY4no7Ft
         T1Bg==
X-Forwarded-Encrypted: i=1; AJvYcCUNkUspa5hCte5G2e3zn/PvO4i6QvkH0KFX9VaJF3/rGepHirHfp786BE5+J7N/RXOslyDNj2oXog==@kvack.org
X-Gm-Message-State: AOJu0YzIb8twc0NBtS7kkBXZOAxrL0fRotOaxYWopG6m2jgVODbC6dr9
	vDdJKNXZc89Hqb1Vx8vwr+UFUZetIKxVZxlsMTupF3mBVgo8oHtFdRNZ
X-Gm-Gg: AY/fxX5kYXGYsCVMP0sVZSvhexEChmR6iy9hz8gFNUjoXy619pDdfOHHO5e1Sm1a2Yp
	aFMnEofrUbrzjzeWcGL+8x1vplgOqHW5udU0y7Zv2RRoprQ24Ri5cUTFmFt+GAzl2WkLMqD6kmE
	VbBRVoCJ8aYjRKxB1fOugfiaydOag868u3I7W5E+5sfXkY3WHZtkDlio9Dzs079CJo1DWNgGvxX
	2f473BunsyK6WHugax9Z1k3zZYD/uOb8Pk7ljVtdo1J5+6pXQh6kU/eY5Sbpkmt2I/IU5yxokFA
	dOAZvR84K4mMP/ytjsDM8wLrg4Nbi8D6Vd2eQGGkibTA99p1i8GZ20tcM8dmcOX23WMM5OlX884
	pBe0g96bbawsluF2UI0QsAzfk11An5As+eaxgJOWqoF/UMIIX42ZeraY57rnhQLWVuLbDey7F/c
	XmWiHTbt92TBcKtOZ4Hw==
X-Received: by 2002:a05:6512:63d1:20b0:59b:7be4:8c40 with SMTP id 2adb3069b0e04-59baef130e4mr407353e87.8.1768570012429;
        Fri, 16 Jan 2026 05:26:52 -0800 (PST)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59baf35273dsm782709e87.39.2026.01.16.05.26.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jan 2026 05:26:51 -0800 (PST)
Message-ID: <10812bb1-58c3-45c9-bae4-428ce2d8effd@gmail.com>
Date: Fri, 16 Jan 2026 14:26:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/kasan: Fix KASAN poisoning in vrealloc()
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
 Maciej Wieczor-Retman <m.wieczorretman@pm.me>,
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com,
 Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, joonki.min@samsung-slsi.corp-partner.google.com,
 stable@vger.kernel.org
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <20260113191516.31015-1-ryabinin.a.a@gmail.com>
 <CA+fCnZe0RQOv8gppvs7PoH2r4QazWs+PJTpw+S-Krj6cx22qbA@mail.gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <CA+fCnZe0RQOv8gppvs7PoH2r4QazWs+PJTpw+S-Krj6cx22qbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BCD661C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: zsma1qn4qu1pjphmx7qu74m1dqyjgwtp
X-Rspam-User: 
X-HE-Tag: 1768570014-185326
X-HE-Meta: U2FsdGVkX1/B4VFxK1Ty03O7e7tOQ16Ot2eEXsFJ5BRmPgnSDJXfA9t7nF+I1YaAYaPNP8Loixsm+c7laFAfrCU3lSycleDdJ6yA48gsTqzeXJx3cH6ZSMhMCuXSaTRGL5OVCNRKnkLKoye8RdxKrOtFD8tdHgoNZuqaTzl+MsnrfPPiurew+AaspaICnLljprFzEElcKnpa38sYmWDPRVqMXSB/esT8o416PgW8ao9qxmbirgEiHIJDECubqoFYLt7Gp9mBtexblRL01VyS/LBHiYuLetkuaAkoD9nuoAwhTqxZyeVl6ftSeWcVsxYHyekBdR48NFOll+ttfJsXbAO3dEQ9ISQPJsky9dp4o5e/d8bmwYH3jjERSXKxrv7NrFut9k2dI/QSIE6sCynjlHQp7I9/LsEA7lGvD1Z+S8W8HOX+l73QGzujMc81DgwMUpFuBhSFfonc7bB3AYVqVGcZAP9/Rex9xQtUkBHkmCHDjvVhrYwGsFVzepP48TJur0q3pbdAqQVcwb1yGVaAN+Hourui29P2mYmBRZSzVrCTyQQvWISNun385Fg/bQnDp0ZH7TOjGS/vWSV5BDtXjMPc8kI+w9Z5qrWRfcj2bJHWK42Z9ahdG7JHjJnk0Lw89AuI5JuFwafIPYCrZ4UYQL2iUHHefvYISjpzqlHl4s3qDSdObIqMNCD8oJLW5Y9GAMmKf+FV5i2SLzFByDFjbTCq36D0NXSQnesp1Bu5wMXYqVcB6UnDCe5a/ufmiumiBcz1+lPAYdIEb4cEamLHKeS0zZ+x5AXpGARnVjWUoUSF1ObNjP9reox9O44stzBYTRX/5eh1wo0E/QL/XMCMySKcfx6f68vzJR9v5v5taJPwsxy67VFHHpOXHLhRenQC2jZ9PyJVZVZjj2VDTlarOHI8VG9TmjL/reLCSVMzU3tImrhGBGc7V0Kqq+kUrNX3MqAL0NfTWKWEEsu9OSg
 gDEwDbdV
 /5CpkS1ZuUN6EShj3CwaJTZeiZbovwRI8TDPt8dgqqddvLyKnNPnjq/WD1W7ITD09kdvIOH0ZgimRCHwOjhKWg6VhJT8AfMtyJXNckGjXHNYTq7AU1yYYWpBzSyIhOKBAj4MAej2G/z/9Mfz+9NbUQBz2WdmA1tkr9AyB3CeYPumBLGqJtsQDMr4QrUubEQIDwZVpnZsF5/tBF71Bty2Jt6CqoTZXB/C5/hP3sf84wOBfHTY2e7F89kcRaWAtQxs64MBE4UOr8d8JzZQ8uMwwyDEHcg/q2AibwectpTZ9TB+PLc58JgPIv0IxDiClcqCKI28t/Y/kdrDPmVBUfyuU38tL4a1M26ZenAuhnYnA9craAeXRAVRC7XdcFGoqjBUHEKzSftShF/tJ0yQOPuJnThBszs0mOjyrl6QBewdoWxDblkar7Vf+nkDshZtE8UocogJCI2gGmJb2CeG4CAe3VJI2ZSRahcj0txb2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 4:56 AM, Andrey Konovalov wrote:
> On Tue, Jan 13, 2026 at 8:16 PM Andrey Ryabinin <ryabinin.a.a@gmail.com> wrote:

>> ---
>>  include/linux/kasan.h |  6 ++++++
>>  mm/kasan/shadow.c     | 24 ++++++++++++++++++++++++
>>  mm/vmalloc.c          |  7 ++-----
>>  3 files changed, 32 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
>> index 9c6ac4b62eb9..ff27712dd3c8 100644
>> --- a/include/linux/kasan.h
>> +++ b/include/linux/kasan.h
>> @@ -641,6 +641,9 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
>>                 __kasan_unpoison_vmap_areas(vms, nr_vms, flags);
>>  }
>>
>> +void kasan_vrealloc(const void *start, unsigned long old_size,
>> +               unsigned long new_size);
>> +
>>  #else /* CONFIG_KASAN_VMALLOC */
>>
>>  static inline void kasan_populate_early_vm_area_shadow(void *start,
>> @@ -670,6 +673,9 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
>>                           kasan_vmalloc_flags_t flags)
>>  { }
>>
>> +static inline void kasan_vrealloc(const void *start, unsigned long old_size,
>> +                               unsigned long new_size) { }
>> +
>>  #endif /* CONFIG_KASAN_VMALLOC */
>>
>>  #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
>> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
>> index 32fbdf759ea2..e9b6b2d8e651 100644
>> --- a/mm/kasan/shadow.c
>> +++ b/mm/kasan/shadow.c
>> @@ -651,6 +651,30 @@ void __kasan_poison_vmalloc(const void *start, unsigned long size)
>>         kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
>>  }
>>
>> +void kasan_vrealloc(const void *addr, unsigned long old_size,
>> +               unsigned long new_size)
>> +{
>> +       if (!kasan_enabled())
>> +               return;
> 
> Please move this check to include/linux/kasan.h and add
> __kasan_vrealloc, similar to other hooks.
> 
> Otherwise, these kasan_enabled() checks eventually start creeping into
> lower-level KASAN functions, and this makes the logic hard to follow.
> We recently cleaned up most of these checks.
> 

So something like bellow I guess.
I think this would actually have the opposite effect and make the code harder to follow.
Introducing an extra wrapper adds another layer of indirection and more boilerplate, which
makes the control flow less obvious and the code harder to navigate and grep.

And what's the benefit here? I don't clearly see it.

---
 include/linux/kasan.h | 10 +++++++++-
 mm/kasan/shadow.c     |  5 +----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index ff27712dd3c8..338a1921a50a 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -641,9 +641,17 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms,
 		__kasan_unpoison_vmap_areas(vms, nr_vms, flags);
 }
 
-void kasan_vrealloc(const void *start, unsigned long old_size,
+void __kasan_vrealloc(const void *start, unsigned long old_size,
 		unsigned long new_size);
 
+static __always_inline void kasan_vrealloc(const void *start,
+					unsigned long old_size,
+					unsigned long new_size)
+{
+	if (kasan_enabled())
+		__kasan_vrealloc(start, old_size, new_size);
+}
+
 #else /* CONFIG_KASAN_VMALLOC */
 
 static inline void kasan_populate_early_vm_area_shadow(void *start,
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index e9b6b2d8e651..29b0d0d38b40 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -651,12 +651,9 @@ void __kasan_poison_vmalloc(const void *start, unsigned long size)
 	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
 }
 
-void kasan_vrealloc(const void *addr, unsigned long old_size,
+void __kasan_vrealloc(const void *addr, unsigned long old_size,
 		unsigned long new_size)
 {
-	if (!kasan_enabled())
-		return;
-
 	if (new_size < old_size) {
 		kasan_poison_last_granule(addr, new_size);
 
-- 
2.52.0



