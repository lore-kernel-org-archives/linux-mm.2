Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B286083614
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 15:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=MgbJjjmo
Received: by kanga.kvack.org (Postfix)
	id 8C8F06B05B6; Sat,  7 Nov 2026 10:37:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876A06B05B7; Sat,  7 Nov 2026 10:37:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769746B05B8; Sat,  7 Nov 2026 10:37:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5077F6B05B6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:37:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1E79A038B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:37:26 +0000 (UTC)
X-FDA: 85408727292.05.20A4B91
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1CE54A0003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:37:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MgbJjjmo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3s0XvagUKCFoHLGKA8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ptosi.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3s0XvagUKCFoHLGKA8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ptosi.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794065845;
	b=Tu5Kg+lRTFR0kYMnQv/JqN6G/5xloGyhOHXLbnbT7Q3DwEjqj+RzPAMVkvApF57bW4T9d0
	AxDpXgDvRfjwFdfoefY6diQx1sEetKmfIvPZ1DHlBdk/Gp1/atD3lAYWHSMLffvHCBBMZl
	rYkFnmPanD7LWmt5gsay+7UL27WNwS4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794065845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nX/BKmNSgCueREMdF/8Pl/MQjIYzPNWNVVbIpr0RXxI=;
	b=J6pDHR/vxRNDWnTZ/s/51zHeK4Nu1PcxIxJy70hynERL3YlouxhBeeENT+dK3j5obdm9oz
	eos+sQSEmGJZzV/sdnWr47d61ho7Cxd3bJozCU9al48BrpwCxD5wNvY+7ZOO7xaDykn6Gp
	mEqdaSossQRbtJTIVR0iMsLNjNVNHKI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=MgbJjjmo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3s0XvagUKCFoHLGKA8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ptosi.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3s0XvagUKCFoHLGKA8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--ptosi.bounces.google.com
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c25edb54d22so223170166b.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 07:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794065844; x=1794670644; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=nX/BKmNSgCueREMdF/8Pl/MQjIYzPNWNVVbIpr0RXxI=;
        b=MgbJjjmoF/d+uX6859GlHQ0zHCuYvYwPLhGXPQ/jCWhLPwFN6YqS4B7h1UHdYn9x4a
         +wmtRRKufSKkJavEEYZyHJ7E1gHZ1mj4aZGScMParsKTUr02/OD1yGqjrcK8Aez50lIa
         TgZj4ExC4qBmSzu1+n9GQC8G3/EanhsJFfBGSclP0POXwIi8r6cvVckx5W0FczwATYuk
         rwAeE7Yfy+vRAvcP2cnf7RptTALd4SU4pbSgplzqzgiSggnZ3JE40aHQMhfhAkFUFlZ4
         L/hHzL+ZYEFwSvdJBS2lH98J+XSkfOvxX+gMKLRIFJsgVS6G6N3plr+qq3QvraQYEbLk
         dBXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794065844; x=1794670644;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nX/BKmNSgCueREMdF/8Pl/MQjIYzPNWNVVbIpr0RXxI=;
        b=EvcL7rHebU04aEIoaW1WQSVCpwKprBag+WxXeKX+IPhfKQIRJBzA2i4+VKzUYZX7Oy
         ztkLkcJFE+gR8cHklkRY+7qaBAq/+uBoNFg0cAOUy4rcoGTJQ4/TIG9wNUxzBJ/6Zi4d
         sbu9iF3DVacc+pwMSMdrV2Mtae1O7g+enH6eJYydNaTgbHfUg7zwjmwEKfMAYj86ug23
         +k0CFydlN0/uuhog5lJNApB8QSAXb0iLs2BC/kYp0Badz5GFWyYEub/QhZMCvcB2cDKG
         SRucMV1uES5frv79szQiSlqOM8fzENa3X1RzLx9Ew/As5M/k+s/xPdiSRcDP1bkZuMcA
         IIug==
X-Forwarded-Encrypted: i=1; AL+hErGGaoKO6J+7bXp0Q/H34ioeU2hwHU6dwmmaSrDtD/Alti9jOEup/CgYjsxz0ffIUuiU2C8/Q6N2pw==@kvack.org
X-Gm-Message-State: APuU4Z+Sa2XISDIsWbfBW+6+o2knUBPS5BRJRgV53mIVnV6RwYzWRCaO
	Y+CBrBzqPujXwGo3LxNWIs8jqDPeoxPR1rKKZpV6g6kPp+9WxfskJ0OYwhwYb6V9+uEjPETC/ZF
	pZw==
X-Received: from ejcr19.prod.google.com ([2002:a17:906:2813:b0:c31:9562:e7c8])
 (user=ptosi job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3c8f:b0:c3f:d8f2:f08e
 with SMTP id a640c23a62f3a-c4d3542619emr438107666b.44.1794065843438; Sat, 07
 Nov 2026 07:37:23 -0800 (PST)
Date: Sat, 07 Nov 2026 16:36:17 +0100
In-Reply-To: <20261107-mte-kasan-split-v1-0-d84ea5f30f94@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261107-mte-kasan-split-v1-0-d84ea5f30f94@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20261107-mte-kasan-split-v1-11-d84ea5f30f94@google.com>
Subject: [PATCH 11/24] kasan: provide empty stub for kasan_report_async()
From: "=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	"=?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?=" <ptosi@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1CE54A0003
X-Rspamd-Server: rspam12
X-Stat-Signature: k5yjhru17tjuw3noejwpyw83y7prxtcg
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794065844-432596
X-HE-Meta: U2FsdGVkX195LxxLjMDow1142T6ZSrzPBlgWjs3cS68lvO/ti6x/jecc0k2GuRW/yzA+vlYWXY9935zf6SdPiS35VRsbxd7oyjnn/jRaz18cOpp0L4HYadkdwa5sY0ESV3L2D4wMXPNiiH6EKmpofDzYr7cJRvAWzBO95IUTQB0jpPYcsQtCcQawSi1Wb7rAlXF+15WzXEWrF4TIJdoZphC8buC18tmbw9JVXzsCPcPM+Mm4DLLkbZGTIz+HnOm4hd2TbQJpGyrvQHQDdB3+Mnt6vQRBzERRXT/sA4CAgEDkR4rKJTiBqg3Wkx0fNTw2xW0WVAjlj8SSJaLiuFFXtWTOj48+j4E8CrosUb3bp5Ac0Hlt6uhhXZWmI0VJjuHwBDemciu87ixpCm1kWpxrmrPYsdlvfdOngvGh1LD9uRkw9Xi8Cu7c1Ts+Nppj+e3p+R7LXBXQ/slUfzQZowbyZV6s3PtAWNCxCT3B6tTuTeSAZ+gNMKoZk0KWgHaoBuNy78Wd+p+UYZZyXZX1qyw+qwkC59If6M07ieIXc2Z1I4FAbYKABs7hoVzfVxrHiWzh4BesiyN7UJ700iq0hIooDTnASD0rjyFC85X+1CyfkxgGKExZ9zpGQuwyvGNMuwRciZ+LReHGvwcXyuYipIjnvB94bM33ovttxYOZOrSVh6MvCU07sr363aedplSB8HZtz6gc7Dr3QBQ2SztiqYp3lXWbaGu/oJjhAA1cQHmyAXFN92EyQ8bjmLurB9YNDCXbRW07SyD7txNnCHZmDB19Wy5RrqNR8jV4gtrS6sKB7u5nRskKNEanbkrmyOE4LxejsjqBUny/w+HycI3V9G5jlnxZ0h9BC86ChMoCgFZTdH2qJopx2Hn3umftZXdaKNbjcpntDXVDrWTlmC/zN0pkwXy6WGmiAhZExTrPjPkTrvuBNWM7I2q6DIrX2rHrACSQjVlII1fh99T6v4t+QK6
 BDyVazoQ
 NuwfUpThCKP6mTQn9meLjYfMBktniCso8eW/AwKSktibM9WE4ZfILUiVfpRjNW+9fHpqYnsox8RrZ5tnmVL8LygzctSR+f6ewGHGB8xoqjYQwqeOCZItmKVlIIML6NJkQ+egdVFxpYoLlQ0WEIkaLE1tW002Pp+xyH08igUNM0NME0iyk1D78TfiXdRNqvl7peGGKgheqd8xZ35U70anW1Xm6Z+f1b/UdiNgc5W0GAZfFWF8Hi0UD4aqvr87hN8dgYpB5la/K7AUAuPThKaKZLRIZJNKIMGrI8xkHDyMNE9eCYEVsim88DVEVwKjApIsvqIpUtlGjl1x69vn7hy9KHU7q6GoarNy7iDpviaRWjOFQqOjPICbrgyP6on+xHBQFOyZxhrdiHYyYAuwtTHILBHPbZZnKR6ludI5RoH+uKDPXhezNqc6yJ6VV86M34EuCw6jLb0Tc/s1b5D8uT+IsiGQ0UOZ62US/m9aEbYpQ3vLiJmgEGZgh38g8txDFeQZrF1lA+KLu6oxxq3jPuuAqzRLI87PfULKv+3FPK8BqocRIjinjp1dORWzlbfzyQwqchfDXbE+6njK+VWyhOBlKy6koEcKyBSAupj5sUmJsqg1qDJ9wgNZ0cfp8HipZck0EiA6g8xK77OuEz4WNOUaFLW2ZUixnVtYnkeMl/r2MMqtUfLzs/WCBr+M1ojanTVuXHT/z++aA38GBnhe9DavmB2PtlS2XrrcrdQZSSJIQAPAA1vzidOHckNZf+5Hq9dq3I1VazmGM1Rs1M/F5kxoy7H4udK31K97lgWr2NaROr1TjbZmCQUyXb8Zu5GBdSBpJJOVmWP/YYYhiI3sD0Axz9xRm+bV5YLYQS5QNNxqdZIGy6IE82Na5vmkBXiO1itQQHyZ2Cj6yghsSVwVFKfrQxM6ojSp4pvR6C/E7DcejG+z9uxMXYDyOfPIDfapUI5D9xGis74JmnE7a4dHQSYDI3/4tIGTX
 rca9xdSp
 1j4DSEtlQa5mNwij70F6Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Allow callers to compile without #ifdef guards.

Cc: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org
Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 include/linux/kasan.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index bf233bde68c7..e429fb483176 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -541,12 +541,6 @@ static inline void *kasan_reset_tag(const void *addr)
=20
 #endif /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS*/
=20
-#ifdef CONFIG_KASAN_HW_TAGS
-
-void kasan_report_async(void);
-
-#endif /* CONFIG_KASAN_HW_TAGS */
-
 #ifdef CONFIG_KASAN_GENERIC
 void __init kasan_init_generic(void);
 #else
@@ -562,9 +556,11 @@ static inline void kasan_init_sw_tags(void) { }
 #ifdef CONFIG_KASAN_HW_TAGS
 void kasan_init_hw_tags_cpu(void);
 void __init kasan_init_hw_tags(void);
+void kasan_report_async(void);
 #else
 static inline void kasan_init_hw_tags_cpu(void) { }
 static inline void kasan_init_hw_tags(void) { }
+static inline void kasan_report_async(void) { }
 #endif
=20
 #ifdef CONFIG_KASAN_VMALLOC

--=20
2.56.0.455.g6c5a503b38-goog


