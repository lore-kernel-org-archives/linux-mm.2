Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6294FC9EC4
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 23:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4F96B0005; Fri,  6 Mar 2026 18:38:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862B46B0089; Fri,  6 Mar 2026 18:38:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76EF26B008A; Fri,  6 Mar 2026 18:38:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 622286B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:38:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D97061B87CD
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 23:38:32 +0000 (UTC)
X-FDA: 84517254864.19.2D8BD52
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id D9AA01C0004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 23:38:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pv6MALj8;
	spf=pass (imf18.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772840311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZv+THovHzTJCVSKXNcQIUaFk+fkGXYm1zK+N5Bh8ho=;
	b=P45asEDv8F/uPfEW2YGJ3m2T9uA5Kjg5c7/YPRoogMbQBcM7dm9yCQWFSlPupoogaCjHnb
	4txaHr0ND04M7FtgFpNbWw48yBrq/1sSqBrgM/wNsnVrx7waIS3Ze3vo+nMubkMXNaE7pU
	oxLfWqM03zKTkH7WPmz8hNB41MYpZls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772840311; a=rsa-sha256;
	cv=none;
	b=5cxz7r1JtyvByX/1W2p0dnvTxPQykCCjNMSQfFrB+DcOEkp/WxjmVXfI6sSq1fDpC6L8pj
	WOF61tj1ezFRVOxBYEIIHnmHzglLuKSesabj+NSEvp+jlqx0HS+NszUHcXzdnFoTL+eqdW
	SRDdeHs8awpjEK2WxglEyv+WDuTAkiw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Pv6MALj8;
	spf=pass (imf18.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-439ac15f35fso6324664f8f.0
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 15:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772840309; x=1773445109; darn=kvack.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZv+THovHzTJCVSKXNcQIUaFk+fkGXYm1zK+N5Bh8ho=;
        b=Pv6MALj8VurGAfq8ku5OfYR/TGFxJ2bhBA8LYeBBVj0zIo5M9B1TO/4CWvqYKsoZuO
         glCYaZf2bk/Rmgs4lbKX1PLg5a/H55GOgnZ+54SFzENx570fh91byC/0V+/Di3vPkST1
         ruuosJLIV2i+KrZuStHYrv7sSw5y4rol0T4pnlPv8M2AqntjNgdYhBgZqE4GsJ3l/3a2
         u5d329EaqTNixWgqJPUlqbufCRjBrnbALgeuMLoLe2xvYJw4pGHNWKcM4mUvhwEbk+qQ
         yCa5KfAr9vzHoH6vW4+m36tIX5HfIuUOi8bUahn0UC7sXHNcFARiWzbpJmvQ59QP+wMj
         euDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772840309; x=1773445109;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mZv+THovHzTJCVSKXNcQIUaFk+fkGXYm1zK+N5Bh8ho=;
        b=BGouEjgnCQXs3JPEl76exok0mA0qzkMMpoChJBVHm1lZLptQoKlxBYsvfkjS66+1OG
         lppYS81flLBRqrGn6GomgNt4cC7MPTCLZeBsKq4sMwJi3KEB7utUjT16hOc8vsSFxKGv
         YAtxRsApiS2zzRJAAE+qCUo0VpZ1XInsoyUkSLMOul0/XStvowji/8ch+B1mNmUfK5Ng
         afTWHDq5f/0vzdmExIzRfjgI5Cp9NST4WWJ2Aikfi2AuZJFr8dhcO+0uSKpsAJPaYqZ2
         rEnn0HAEQTaUmoWS+EEJ4E97s9ZgRwJJ0qNkE8vyeOJrklVd5OEQbl0tVb964bx2fK0g
         jrzA==
X-Forwarded-Encrypted: i=1; AJvYcCUVwti9YCTS+ijNBDmjbe2ySPt3FoCfj82mp0O9mutSPjU+p3NRyyL4vO5W0yaIvPT9kbTa/7sn0Q==@kvack.org
X-Gm-Message-State: AOJu0YwHTVvd/5HfbmJEVgX2WCeJwfJlXLMFIeLC6zTCRSeNf+AEAAeb
	YSc5Ou6c+6KdZRap1ZX9G2G8HVRk5EuKIEtX061MPEJd+Co67WkoJDJ8
X-Gm-Gg: ATEYQzz/hRvedDuI3oE31ma5ET1vX/CNQvheY6E8LS4pGYPCOtL0LDQyZtebkmVf2/w
	ZYI3DksbPsqDFUWtKcqBAdH8hn+KHlDeASiSB4T9fHMOMk3AJ3NnG5ku01qp6EyWnUFn0PVhx92
	4wg0NwgjYcRBc7NH87bqT3/ySJVSfazvFtfDsP6AjYYirYGkAwS25dTNIvSxT7q2+Lr8H2RysuG
	Eq6Bbc93jnO0YhdUSxQnyFNCuxMYS6l9r1ngLue14FCcbYWiM7AtFPGHhpE4tyu/eKMuLX4LP9C
	l10sCq7P+AnOtb7DfJ2lSNxyfJ4XYDZkMBW3oEYpQy7FMgYZ5eOvf1DrS6wflg+rEbMXATGGJkr
	+swGiQb+rCkZmKg4HGf10694sw4QEqdY+8duzFMN7foqVFMevnJQ9feq/82HjPEXIfUvSu/f3PC
	1/i1VbsGj/3euVXLtV
X-Received: by 2002:a05:6000:1843:b0:439:c9b2:6571 with SMTP id ffacd0b85a97d-439da3697a9mr7081358f8f.41.1772840309039;
        Fri, 06 Mar 2026 15:38:29 -0800 (PST)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae57c05sm6340069f8f.39.2026.03.06.15.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 15:38:28 -0800 (PST)
Date: Fri, 6 Mar 2026 23:38:27 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam.Howlett@oracle.com, aliceryhl@google.com, andrewjballance@gmail.com,
	maple-tree@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Josh Law <objecting@objecting.org>
Message-ID: <329e9c6c-81ad-42c0-972d-4f187353dd77@gmail.com>
In-Reply-To: <20260306145434.c069313fe809d94e64a07109@linux-foundation.org>
References: <20260306200820.2819999-1-objecting@objecting.org> <20260306133321.4fa6c5a73067bd179a5e888e@linux-foundation.org> <b796ccaa-242d-4e4a-a9f5-b3a91f46f838@gmail.com> <20260306145434.c069313fe809d94e64a07109@linux-foundation.org>
Subject: Re: [PATCH] lib/maple_tree: fix swapped arguments in
 mas_safe_pivot() call
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <329e9c6c-81ad-42c0-972d-4f187353dd77@gmail.com>
X-Rspam-User: 
X-Stat-Signature: j11cp9perumjypadqrmf8qkh9qdqiqod
X-Rspamd-Queue-Id: D9AA01C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1772840310-75679
X-HE-Meta: U2FsdGVkX1+zxLiJydA1SzZM6ElY26lT2vmi5JXP3j8cAa8+GDUt6jD+sJ9E1lKgHZDiJlCc5C0dXrHDp92FHfi0CsbXsp/5Q23s8M6CW6zXQlVy+mXg3xy6aWcXob58BfE0cCFnR6LLjEfJG50sSAEdiUJUPjne+Sop+ULIkN80WXXD/GfswGfARwsHu8yNqFs84f6asvDfCGeVp20NmmNoeKPIRmXLB2bPKvfGbjb02KkFYASNLFfApIAYoXKLGbYttR7e1bvI+VXUV3diZhuICM7ceHLYNJd65qnPuxCDYCsej6tSB1DHottkapohZVHIkl6yU3YAuQxA6segkDAVXnmmG6diss6xf9Kqv4izeUDjFWfS1ZPOA71K8pgdsTAOldLeFSxhvWz6XalwpvF9bwNsE3i8LOVyEl4qtlfDwt50AKBAu7DPwtR+CYQG0kmuYeY4uOHNCi0lwuLAqIpJphExPt5KjNcAv5pTtQkT1hVP+zsrfZoKdIWMvmwMB5UAOSCcmeq80S5UbxuovUtL2XnlsBG7nxbFR2U5rEinwN+4ktxJuZ6f206Gfw2BBsaHtw4p+2NvDB0AgqkG5WWyZyobmpb4nUZGD6wLAa8haiaeGVE8SJSUu/OM0MukwxFytJ/O1h7GlZUb2Yfv6QTsnyIIJF9u84rmqpO2s8j54OPAhSsL84H6mv8rh/Y3FGbE6SyBjwbTgSkiAqVAeZ89cnChVIUlufA+o9vnL/YuOV9vQEvDoSdL0UwlMJL6hXifYhaE/XE4F+Ry0/QhZve19PYSK+6flst8rtmVKJko0lclmOUETIZUkFTzmayXK0tOIrpWL2vPnlVbfCwJwt7ihGpFkCqcUYTVwGQcoVzuyYNydH6EkOWdML7dCVXvdOQKojtDayL2xHUtSMfc96MSaOltJ3ZXVgka2bap0nKK6RQbth96t73GrwhQcfQhVwT9lx7xMPXrqJVDoHy
 60/GcSps
 3wiQElJCxFUVXx22YpMQ3X91dfb9hnV38XciL9HzyKKEnlmFCODkKCl7jX5NlkYA5YG7//KJQ+fo0r0cGHx5HFnat3qY7KgZZlykhoSASPYjd3mNn3NNBxiJUdKJ4UFj8VuTxRpd2KlX96IIecxosYnjGWfEs7iBfKfQOtahqG95yNlBkHITyqVO/UHi95H99rBlB1E619wjuf2nboYofBCtvA+6bg1PwtEcO4mBunglUfjPZ8d4XPdWtMSHYRrylwl4A0bgYfGGDos8PBTevjJ48kAMR8tn/BBRFR3qaqyJ6cOMr4vo7G5YRoUDlxKwYnS2SHcf/t3hIVKMfhqwKotKS1GiuPaJ1IWMFUokOtyd2Oz477I1Q04MK4qP5CzuO3W3WPwWeQNAps+PValUMQd25xZMh0T5Hix4qHmiTrpMEy9YFjxPgGA04H4QJMkErtj0hRhZbCjsifpD7bhaiD362OYGboG83RCjKfoVDt1ufZCBTuayHTOCQ48Ag47XnipB8c36RsOkET8rMJVk72agdq34bMyZj8pefBhMc5JsE3Xxafn8noo/4M40MKezqVO6Aqt4vwN2BOWIs3CV9v+6aOOOQCEW/Kkds+zM2mIZHUPrJYhMs0jgacCU8TAA7KdGv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

6 Mar 2026 22:54:36 Andrew Morton <akpm@linux-foundation.org>:

> On Fri, 6 Mar 2026 22:11:54 +0000 Josh Law <hlcj1234567@gmail.com> wrote:
>
>>>> --- a/lib/maple_tree.c
>>>> +++ b/lib/maple_tree.c
>>>> @@ -3279,7 +3279,7 @@ static inline void mas_extend_spanning_null(stru=
ct ma_wr_state *l_wr_mas,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (r_mas->last < r_mas->max) =
&&
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !mas_slot_locked(r_mas, r_w=
r_mas->slots, r_mas->offset + 1)) {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r_mas->last =3D mas_safe_pi=
vot(r_mas, r_wr_mas->pivots,
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r_wr_=
mas->type, r_mas->offset + 1);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r_mas=
->offset + 1, r_wr_mas->type);
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 r_mas->offset++;
>>>> =C2=A0=C2=A0=C2=A0 }
>>>
>>> Whoops.=C2=A0 How come nobody has noticed after 4+ years?
>>>
>>> I'll add
>>>
>>> =C2=A0=C2=A0=C2=A0 Fixes: 54a611b60590 ("Maple Tree: add new data struc=
ture")
>>>
>>> and maybe cc:stable if we have a reason to do so.
>>
>> Hi Andrew, on thought, I'd like to add Cc: stable@vger.kernel.org to thi=
s.
>> Even though it's been 4 years, a swapped argument in a core data structu=
re like Maple Tree is a silent bug that could cause rare corruption. Better=
 to defuse it in the LTS kernels.
>
>> Seems appropriate.=C2=A0 But not as a hotfix, given the 3+ year thing.
>>
>> I was hoping to hear some thoughts on why this has proven to be so benig=
n.=C2=A0

I suspect it has proven benign because, in most common workloads, the maple=
_type enum and the offset happen to be small, overlapping integers. mas_saf=
e_pivot likely returned a 'plausible' boundary that didn't trigger an immed=
iate OOB access, and the tree's walking logic is resilient enough to handle=
 a slightly miscalculated pivot during a spanning-null extension without cr=
ashing. It was a silent logic error rather than a loud memory error.

V/R

V/R


Josh law

