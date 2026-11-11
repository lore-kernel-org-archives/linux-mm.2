Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A615606A880
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 21:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=glOhsnIV
Received: by kanga.kvack.org (Postfix)
	id 345BF6B05B3; Wed, 11 Nov 2026 16:59:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F7546B05B4; Wed, 11 Nov 2026 16:59:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1F96B05B5; Wed, 11 Nov 2026 16:59:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E716D6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 16:59:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71FF21C3B71
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:59:48 +0000 (UTC)
X-FDA: 85424206056.24.2FE199C
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3A441140007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 21:59:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=glOhsnIV;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794434386;
	b=j6aEqT7Ay59HX3xjbdjhJM8LTq6/mGejR/uTHrfB2boYDQvNVErbKylyRfB1cWjif5CZMg
	yjqxMEkANZRoOXldH/TC479tdEpphXzSGv/BXV2lBJsGCLc4uzlYDXhP88+rfeOJFZ0qeJ
	njGPdXTH8pJLlqrWyHO0Lg8yMZSqKfg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794434386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BaTRt15ApUolDeSrcLBJmuIxxr7ecXkh8ZK/IMhuYFw=;
	b=OPBE9naWtMWEXlPnA2XzKmKjQfhP4IbS0tAmsrfBj704j8lONPPZm/HEApcGjsCnJB3SF1
	OqN7Nid/i88bCqzcU4UtE5UJS8TEi6aiKs6/JDYfDmSP57J6VSHeXpGCfhwz5hB/QOoqo2
	X/5EUV8OeUQoxIl+sftJtkWT4b6g70Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=glOhsnIV;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.41 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b7221c0f2cso3353736a12.3
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1794434384; x=1795039184; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BaTRt15ApUolDeSrcLBJmuIxxr7ecXkh8ZK/IMhuYFw=;
        b=glOhsnIVTzuMRWqnsTCRLlxevcizsoDH/7Cgqt9xgAUezCerXjNN7FeO2dmAGBmInD
         o2+8tG8VPDpAWnRTNKojkiKiRKe4P/tBAF5Z+iwMAq6bSFIkE2RSDuMmOo3AVevPZi13
         iPg1P37hVIWofFhP6p+RbnapNQe/Zd+51ephQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794434384; x=1795039184;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BaTRt15ApUolDeSrcLBJmuIxxr7ecXkh8ZK/IMhuYFw=;
        b=OTHtaGsd82dUNa+hnJWX/ioJI4LADHUd4K7zzgV1uQIaU/HM0npAqtk3zDBEphZ38G
         Zev+GDZXDwcoScROs8tVe4Sc3MsBI6++ODVE40bmvE2CeiJ+EbxQfzw5lBO02U8CSERo
         ZMZlawuRZ9t5m670qUpsE2yt0XhcPTRnaSge87qxLLZY4sIRmWdcmiSaRCDQPdaL/Ui3
         /cODqhXs+TqzSVY5oeeeBMeq1e5bwAo/wSdBJVKINu2PL0mSlnOOg4vhT8HgKRoRhWY3
         PQCHl3YkT3PnWG3pDTF+UihlNfAKz35LoMsiHyydfokxmawlPGPl/pshYpduqgcoZfLu
         kjtA==
X-Forwarded-Encrypted: i=1; AL+hErEfLnw7Xr8CnAddu906MskSiWrw4DDEdkYHFoA93A9gYCVaz0uYVTGMg4MXb0IKB5P/NlZpDp+CYA==@kvack.org
X-Gm-Message-State: APuU4Z/s3z3mfpcWlNk9pT+M/j7wNTxe1XpKMXbMg2l8K7LWGuP6+Qh8
	eURQPC9YdORrAmK6MhMMqR3QiAHkdeXYNZ50PruZBWQZbeTW3IdaOOxhZNWGqNpv1myIhgFNAKP
	9uCelLjpIeA==
X-Gm-Gg: AYBFou3qhoG3IOORNcgtg/CuFdHR7KeFtOj+3e9o4Nz/S/Aoih1z6lKOPadG8ipo8E5
	NWJ47WJ5e8evBJhDlk90xPbvb7NObfn4fFc34RfTzydNdP8rqw7RPbotIdyeo+ZCy18TmUKIeJE
	k/eIWlGIZC3PEevna9ah4VX4xwEtwZCrtoEEJ3JfFJAkiuXj3BUISrE/dEGM4swXXrcCsI+fuE9
	TiIZtCwOKCQur7vW+Jl6rEFbnYTswe0cgrrICUmKRSrqp4cYCa1vhFuiEye2OOQ+Ch3cMRtJGMT
	XywGzUx5kfyKDihOERWK7sYyphfKaztpybEJw6ZzXrR3hFrIqHUMJX/B4N+H72n++lQOODmobye
	SyoyW5VBvZ1gAwWJBWpi2KctgofoKzJXTuaZnj0uesKve+iYxor/qq/EeI6BevPpYrOyD/Ajr/a
	VxhatZNJB8ohlaO1mSjc2hAqqt+DeFAH4IhyS4eX5NQNTw5gArglye1dtB9Z7fx25Z2nx+lESKG
	pFlNBHia3MVeirKyzUGRERRCCEgOR7TM+7lYZJpew0xIzugvkZjP6MhKkuJbitycT/Y1R7OSQqq
	ZTFqabZ4PuwIeCS3CdiUtI3dY/4NARnwDxVJQzwQIxDVyOgdVm9D+S7Dhgry8JaUGb9ORqIWf/F
	6XQ==
X-Received: by 2002:a05:6402:1358:b0:6b5:47d6:a8b0 with SMTP id 4fb4d7f45d1cf-6b77782e006mr1842303a12.37.1794434384422;
        Wed, 11 Nov 2026 13:59:44 -0800 (PST)
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com. [209.85.208.46])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b757823737sm2830158a12.3.2026.11.11.13.59.43
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Nov 2026 13:59:43 -0800 (PST)
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b581b6b0e9so2481076a12.2
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:59:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEoVarWaHK/QRF+7JkZstz9yq1ATA2Ql/8Sm3jM8Qxu/5im7zHvFKv46DFkUBGWgAV8jzs3c/Z6tQ==@kvack.org
X-Received: by 2002:a05:6402:22d9:b0:6b5:962e:e017 with SMTP id
 4fb4d7f45d1cf-6b777702145mr2015975a12.23.1794434383079; Wed, 11 Nov 2026
 13:59:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <606cae9e.bbec5.1a1c54f4f9f.Coremail.18670333770@163.com>
 <60541e98-b1f0-4f92-a155-8a29c0bb17dc@kernel.org> <44abb8ef-7711-4ad0-be9f-ca47206892a3@columbia.edu>
 <856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org> <avS5QcRj85yAm9ll@thinkstation>
 <71e24630-4c71-4518-a9b7-68cf3597ce80@kernel.org> <CAHk-=wh=cVrn+xs3fZiPW=kJbFQLwf_C+c-YBCR2K9s9aNE_1Q@mail.gmail.com>
 <72f286d5-3f1d-4350-b463-09f7b320cacf@kernel.org>
In-Reply-To: <72f286d5-3f1d-4350-b463-09f7b320cacf@kernel.org>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Wed, 11 Nov 2026 13:59:26 -0800
X-Gmail-Original-Message-ID: <CAHk-=wirmEK8a9M+pGP=zdQFkw8zfZuswnZnC9zF6tjVSnqNLg@mail.gmail.com>
X-Gm-Features: AclHuK_wv_2wxvj6t-2tq88pSMUsjoVj5lgIf450fMFrxt9uf1-VCJJrV8dZfLw
Message-ID: <CAHk-=wirmEK8a9M+pGP=zdQFkw8zfZuswnZnC9zF6tjVSnqNLg@mail.gmail.com>
Subject: Re: [SECURITY] mm: khugepaged collapse_file() drops RWP PTE markers
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Tal Zussman <tz2294@columbia.edu>, n3rd <18670333770@163.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "ljs@kernel.org" <ljs@kernel.org>, 
	"ziy@nvidia.com" <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	"peterx@redhat.com" <peterx@redhat.com>, "security@kernel.org" <security@kernel.org>, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3A441140007
X-Rspamd-Server: rspam12
X-Stat-Signature: 8ar5hwujtrz15teysxp5c87r33r11k4o
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794434386-2565
X-HE-Meta: U2FsdGVkX1/m/BEqMIFBc+Zia3YP6K+PBab8++FKusfbzFb8qtpbecMyN3Psqzr0t04X3lOeQSn7slW6pDg0o2Pr2/bSKYyoSSH1NO9J/6q2DCLP61+63HWgiGY+w/i8mJzVuUSm41WUtzjynjxw20zjt8UunHXkG2zdYo0h7fGcgnrZDfxNp29h/odPjUWTsmZNwXNTFFleamqvQ1JzPrJnoxetC5Hg6CY4PxYYarPfgxT5vzgqnrt6XLBVgSjQ6t5iYxE5r+eOuPW+qejKcFAIcnohMv6EmALjCdYuKK3STAwKQ1UUxvIZQajWv/+G/4Fby6a4uWrz0sr8nBVfUH5wpYW5xs+5SKvDlpsiwZ3SL/jpGOAHsbz4tIfUtuP11oklcs3YqTy+Juvyph7mfBlHSdfTQDgMBChJvZaBzLF8HmVF7hjn5NkMQN6756Qls6MNUxVg0twTXCZ81o3u8phEP0v+eSF4vkdekCwAHEq4ZM7onOvTXNu3KFtZij6vPAgO0p8DKbqS+D3VFJU6AhBLOMGlEuftV86pa3p2LOl7XMnQQmig3mBPeQ7+0PoTUxjAwo5Oq+b/QHkOedD4p4/OueK/uPvqHJMDt5G5V3r/IW00+oNi5o67JyGr7RD6I5rNANe88u0qccsAjrh5xcHt7sKGAo8l+WLQ4p+t+YAPsgPLUgLfXzmX4U8tR4zeW9xFe5QYDLoqkBfOHA5+kkLqn7+7/kD07eAuTA+XrygwLA1RTLBmrT0RXcH1gECe+j00Kd0xn+qf3DSuhHpYwuznxVv3AXOJSws+WBOnXTrYwbRn/oOOkjIsJ+w3Nh4sJ29M+n7tRNAFiqc+dMiChKwwo2oQ1nerYOak/c6T9u25+7+pAMsULRx4LKRJsD8aIeBZs5/4hZCWwhMr+JMxpXbTKPF/rj8AVwh9OTXiQj35ed2Vz5OGyiPys7NzrxRe+T5U5HRQAXfkAVy/FOz
 G6vb1jL4
 h03f6KiAnGc/mrK+gyemBLoGnGLj3yYYeB+2Ovvax6h83piwTwv4K5b+gUft3/eZkM6OH3b34R7jITflyY5GyyGsQ1tDGiciw6Bu+HtAreq+9bznFYplFE7RlFZs60qCVUNpsE0Qz9QpilmzdhliWMa1/v47Y0CqInFO7MVU9HMlCls54DUHJRuS+25sgP6FVLk5jA4BKPekEgHoGHhofjkMG6U0BOZqGkkpyU21keYyuTQCh3w0sLhDH+R56ii3Hs/8ilGERC4iDTLwTP9ZiCCUnpJNR4aXDYjhNLfi8btUGeiUURvEn1+VnlLoz8EBfk11CN5YMQ4PjGPu+aD+NAvHRYNffGMk9wPC7TjJF9eBHYzM5NHTGoMhh1fobzneHszAJlJFzJojBemh0pVQyFhIZD+fw46HSt90JMc27lABLFMrOjMLEVy2NaoGVT96yc+6I3NDQHxNnZPxLA6l1P2mwaentrRqFbLlppsR+6NlRf/KKWBxbo4rNDSPXlSPyZCRMTNOfUJPRAWSZJPK6vpJ6KzaK1H0egxLdN4ddcLNj2XmKgFVmdJ/68k2QigODsA7YDBmGllBK1Gc5QB7BLIWoY6fur43UrI6y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 at 13:35, David Hildenbrand (Arm) <david@kernel.org> wrote:
>
> So yes, no new uffd features.

The one uffd feature I'd actually like is "no kernel faults".

Because damn it, that has been useful mostly yo people who want to
open up arbitrary kernel timing channels across user accesses.

            Linus

