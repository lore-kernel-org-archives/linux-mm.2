Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128B3606EE8E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 16:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FHGSR5qG
Received: by kanga.kvack.org (Postfix)
	id 36E276B05B2; Wed,  4 Nov 2026 11:46:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F576B05B3; Wed,  4 Nov 2026 11:46:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20DC06B05B9; Wed,  4 Nov 2026 11:46:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF7D56B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:46:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8265D1C40F3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:46:31 +0000 (UTC)
X-FDA: 85398014982.11.4EC60CF
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id B7BEF100006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:46:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FHGSR5qG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793810789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qxevzDe0ERznAZjpDl0rGSZzGbCrk7b/Nsjrdx1IHxQ=;
	b=a0c3tPVDxPcNe9EZ6gPSsUin9+D46U/b5tMGHbWtDtsLfQubfzzDnwOakEfTa0dlbyq20N
	jstX466O3qQp5bbCRMtguDYc53uXnliMWOtAB7YgI4WzJOqAFXbhhPfHeIqisLjkhm99Yp
	5cZp4UXHpnxhc9fo465jn0s9TKDUwDU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793810789;
	b=XobX3NvyvmaOAKBhUveHSzZIXIUVvHW84U+cg9rMGhnFSkgX9MCRmDM9ksm1L4MlguPC7S
	eUFi6v33Zoldrpk07MqKFrGKyb5mvJCcABxqiK8S544pAtgJtQoQbtnnneG+UcSxr+litp
	useAnpN3SFz+66LlDm++Q4snXDT7Jes=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FHGSR5qG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ed1f1a7695so1649755ad.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 08:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793810789; x=1794415589; darn=kvack.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to:cc:to
         :from:subject:message-id:date:content-type:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qxevzDe0ERznAZjpDl0rGSZzGbCrk7b/Nsjrdx1IHxQ=;
        b=FHGSR5qGnHlFg+CiLMcjm2kci8VSKIat6UHspFAMf7IMyELs0iSO9YCqCE3jAfc9N9
         QZQQ0GrbddVnP2sg3N32N94/lwQGvIhRtMhhUFao8o5pxiBkWol67CA9Z3c69P7jDDK2
         g6bsraxD6rWZba4688zo1z6jRjmsI4E1DYFuihwGVE9/q0YI76+5Q7NLDH488jy0khoU
         Df4gdCXQduJvFuOnfWrVLUTsUXnNyPDCXlbGrnq4XsTWr77GYEOjC4AnTXQL/UC7rRXm
         hnqbk/FB5fEV5IheAOcSwC4FFEQ/4GvATRXyrpwzXqA/oVEX0PgeisNoI9byCWd3vvrD
         DyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793810789; x=1794415589;
        h=mime-version:content-transfer-encoding:references:in-reply-to:cc:to
         :from:subject:message-id:date:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qxevzDe0ERznAZjpDl0rGSZzGbCrk7b/Nsjrdx1IHxQ=;
        b=kdV0fSOrjlYYliavGpivzFfU2Fyx4TUXcc0ezjzkKpBsNcf0m2NuAkeLyvho0zMLV1
         5HG4Q89gMawzXfiZQsi29xuUhRH0kRjvyZtxFBK29rhZ7pR7arGZ67mWWRNKU7ddEvoD
         LZ6HqUJkffX9lPgPcaJkOonWVpB54jkaXmpTZkPFOtI3VpVKI/kXx/kliZEkjWuj9pSk
         N7I8/WFUn6+gttg4PUyucoqqfdOfyJS8WQSaowbopUqRwNRenh16oyoy1bZOPEVvVfWS
         57AuAUpiFo5ku/AkFv+kZHAS1qF9MCS7PpdGFbFyE0AdxnG0mRSpTc6htLhCQlEiQqsr
         iFAg==
X-Forwarded-Encrypted: i=1; AKwUvBzrgBXg9+7EmTChUKr/xvm4rnzD5aAbNSg2vYG3jkUxks+4j+V8gAO2Clo4lNK//uBXbals+Tdcow==@kvack.org
X-Gm-Message-State: APuU4Z/2ojHrGTDp30AEpyfV6RdXFThqr3a6DVN6pGvjNhmGXLyLmySM
	36d4Z6jB9I3ozdLw4AVyMMPGD15pJvaYc3bCWs8v0TJaJgsIEhy9fY89
X-Gm-Gg: AYBFou3MoanwY7Wfhb8zQCOhUZOQDjpJ34hhu8Av2eheJdKuG+OjwNocKG0HVorYBMl
	5GUB4BQrq3uy7QJsDr3RZV3qUPCZC0V3t4entUYq21UplpXk7zLsESBz6LTlOfOEVCR75fqKEzC
	n1AXjGXWSwzoQtwh5SsWgOF//5kiLfn0AUtAB7fMeXKhaazpMWZQALN3oGQEjO9jiKxZkSLX3Oe
	erYjembd0SdX/D5XbnliVp5LYv3XX6x27vH9bAMcT4CRvpJaqgE25DovFAJy2c+9bUDAUF0FjIc
	1jwLvWtuiXJXTa5afcQek5sa3+IRGgTh+NkpcYF+3v/7zfm73Op7viVsZ+BpwDfoGAmuxCVVZS4
	4gwSxQqMYhcd2Pa1ViedbPo2slKHX60sO37JXnyFVOeTx182UGCyPOVp7RFi5obVhVgMt9vb3pN
	x2VaL/gkLyIXp7m3p/bdLrYPYYGVMWyShyeOqtTuKXUcB+SlPozZOJjDsbtw3ZOYd0eXr12fcs0
	35f58wfwkiN298znQ+8vyx8Yo6kpD+tu9EbFol0I7v9CP9NKoPuR43D7uXUorDBk1MJyNFxdS41
	9oSbvpvJf9p0ztqWN8w8IeZOZc01JUAXF9nqDOF1wU6YjwDuyd8PuLzx8x3aoeQQByZnZKq60Jy
	Yl8QglHTEO18shdSXVR5jMK5yrjNYBszHwoU=
X-Received: by 2002:a17:903:4b0e:b0:2e9:9a19:c54 with SMTP id d9443c01a7336-2eb3646ee38mr139469995ad.50.1793810788339;
        Wed, 04 Nov 2026 08:46:28 -0800 (PST)
Received: from localhost ([153.61.198.251])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed08bd4a3csm9983805ad.11.2026.11.04.08.46.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 08:46:27 -0800 (PST)
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Nov 2026 16:46:26 +0000
Message-Id: <DMMKUQVDEM0N.322USN1ZSYMCU@gmail.com>
Subject: Re: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Harry Yoo"
 <harry@kernel.org>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Hao Li" <hao.li@linux.dev>,
 "Christoph Lameter" <cl@gentwo.org>, "David Rientjes"
 <rientjes@google.com>, "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
 "Clark Williams" <clrkwllms@kernel.org>, "Steven Rostedt"
 <rostedt@goodmis.org>, <kernel-team@meta.com>, <cgroups@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>, "Sashiko" <sashiko-bot@kernel.org>
In-Reply-To: <6441429b-eff2-485b-acf3-26c3034910ae@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org> <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org> <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com> <auo5G__ac1qA9JRs@thinkstation> <DMLVUTB5J1RJ.2QKOUW6UB04ZM@gmail.com> <6441429b-eff2-485b-acf3-26c3034910ae@kernel.org>
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: pztukqmrb3z36651kixhbdwgfx8ihike
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B7BEF100006
X-HE-Tag: 1793810789-441111
X-HE-Meta: U2FsdGVkX18SjYQVAglpWysCBQIxjzw88TJ5PiXCiwCMw0XcQoT6U948De07a+MwXYWsR02lp0gfcDL8jZ4xQyIhsw1ijaUW1DbdTb3dvEoL/p4KJx9+A1yMnGvL7oha+XNPMgme+UNRNDZeNIV0gfhtZMPl7GRDA6HfGvF5R5Pz7E88rIJrNqHP5q3JYhf/KMsccW9a3mNQsSEuj/14mUizGiOwYT5CVQAiFnD4M3oAFesNJ1sKRGDvukhUnbQcd4b8FzY5XvmkhV1fWY3jBdSH0Q+6rOeGcVwLr2Eoe3rLVz4EtPpA7KoTnTP5veunZrDu0j0HB55aHg5azEaYYYe6foXCwp+otTWja47mTbQJVIgMQpI6mrQkAQTa3UqH2y8l/bJfcvXyEbML7wEmpCbhj3fbclg0zERm8swYjXk6DSAWPeAeh8u+4JkwD65A+6Wqg35tI8qSwO5mrwwMYsHItiqtbCFqory8on9cCLHsI4mpYGxVneOU5oEtoHcveXw+IJiX0woNpDFA1c33k4vuxknWPFnBwK6sv1uH7EGkeDN2LrAn6ta540k64zqIykvNjL+LrCrt998kEJisqa7JFEuLI44cFg9FJdwFAc86b8058DhyB+9bBuqEpKefnnLaabyud8LfyKouraWrw13NBG3XF4Gk7iwlzj6i6BFSIitriQVe4+LjxGvkJddlNGVu+8vEEl8YqMr7jso1MHZEk3FUvJt6xDyiCHsed6P3JVcH7/ZDf0kUh7kpCEdyjjUwL+FP+SwixTZzlEqEph5NFdVt2bccmi5jfKHVA5mdKrwC+YEYf+hHJ7R642+QAWz/QC0KawaESj9snTfaN9/sKWLlfNDFPW102JI9cHNYeU7UkxbQHsPJPxwDr6r83zRuhwOwd0UMcDaLvpFFk9pRx2oMY71h1oxaXr2cUAA8lDHQmE//xxVGrrS9eKxZ4JF2NXERanvxx4t/JeB
 8agr78tx
 b+SZHy/haMecilWle1HlefY3jhRqyFc5KeJw9pvkX+oDZNtlmMMh0j20/13gijc+xqj642ctzqszDT5ijjNhn77l0KuwJWwrAwsKGyqtY6Alme1GxzNyqfNV9LVF3xtVYTDmYCO+WIu+J5S2vhsF1lQFP9Xk9IIZTMk15dzpfOdxODzuAR7p/fvLiLYGqLQNw5jfeYFcHGgxOgKy1GGkK5kHsRvHCZWL9Jsva+2d6/pZ0b5wAAH2Q1rsua+bdY8033kGrpMfooxbwfqFQvZvtePsVYycHt7yZZQG+/ov8ioYo2+11jNO39qOX4/zKwlRJK3FulTNFjubSp/YLBm/9015UOZ8RtLAgc/hlXn27aP1ZmmLCVZcF8gkf/RBy1pbKdFjCMenSl/ZqDw/qG8T18a1ObVtTC07XB2Q7PhCTWEQYKW1ll0iAISALHZQaZDxOxq7rA2je5NOJVBbqZ1ELPRApTZndOHAN+6DtenjeDvdlzXXZ7bZY9N96vKurJd/MfJv61LSiRtcW4cFkP9pIFTCcklOsAL0UxuL+JrisKmPY8WT/XyafeNGmiPFtbFmRVaRrOaCezl8bfcK5yEIs6InALg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 07:35 AM Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
>> I don't insist on kfree_nolock() there,
>> but can we try free_to_pcs() before defer_free() ?
>> Like:
>>
>> 	if (likely(allow_spin))
>> 		__slab_free(s, slab, object, object, 1, _RET_IP_);
>> 	else if (!can_free_to_pcs(slab) || !free_to_pcs(s, object, false))
>> 		defer_free(s, object);
>
> Why not try free_to_pcs with allow_spin as well then, and improve
> memcg_alloc_abort_single() for both contexts?

yep. Even better.
The bulk side does that already.
Like:

	if (likely(can_free_to_pcs(slab)) &&
	    likely(free_to_pcs(s, object, allow_spin)))
		return;

	if (likely(allow_spin))
		__slab_free(s, slab, object, object, 1, _RET_IP_);
	else
		defer_free(s, object);
?

