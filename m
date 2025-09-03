Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88DE4CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 10:16:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3BF48E0003; Wed,  3 Sep 2025 06:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B13998E0001; Wed,  3 Sep 2025 06:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50E98E0003; Wed,  3 Sep 2025 06:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 921108E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:16:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A8961605FB
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:16:32 +0000 (UTC)
X-FDA: 83847534624.08.5EC8292
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 563FEA000E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:16:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rqADUmZd;
	spf=pass (imf15.hostedemail.com: domain of glider@google.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756894590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vysyoass8/7fXChxkNXCAvtsZyl5TuEWzgR+DsRg3BA=;
	b=aC7A40GEfbsjt8WYLWVC/7cZFCKPJBHbcuzOZu4vyhCQ2IFgDOXArA/1WcsrP19xlgvkHL
	N1DoC73MxAO/VlFriWDOpRBpcYNUqYoPa/VThSAXH/ocgbnH9m9e2UDIBwhDfK5MqNXpvr
	Pev10WPqTDQfsjnKGjSBB2rAKNXyOFo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rqADUmZd;
	spf=pass (imf15.hostedemail.com: domain of glider@google.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756894590; a=rsa-sha256;
	cv=none;
	b=Azs6yjHKaDegbVcMHaRtwDgvMzca1admwKi426N1XtriWwRvHJsmfbuD89M71cv97Ea8nb
	D+rPfvSHYi22hZE4JeJ2ybNeMOdKpDtNiilfpKg9fmPqlTRbly54KdREibSgL9sTG/Ntyb
	OGWq+y903GSuZMmYsMAYFmImGQaUxJ8=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-726dec342bbso783786d6.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 03:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756894589; x=1757499389; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Vysyoass8/7fXChxkNXCAvtsZyl5TuEWzgR+DsRg3BA=;
        b=rqADUmZdi3XNixEvpiLEKaUUl/mHtsgoPF12TS/frvxqErk2od/T+8VdY3lh72fRZH
         ePdSCB390fFIjuTpn9s15dflguyupop50pJExYfcOenHnlDn8PZFnvKAvymuIEs94YhK
         k4nyCILcEVgJqSdbdx9vYDR9IvNcftLO3XfnP+G3nE5lF5YcYqzfe8CyjgkYTaEtRZeo
         oXpxw2egymKoeD+AKxKPphn5EfthxR+0tG0VmM5rO6HnIhVcKDV/9jzVNaxsQV7Boq6q
         WyxAiA3VK/ZwGyCWzA0LhFDiH9kZfnQ3Hcjq+hIirc/0wZsJpUpOYdK640FfSXm6pC6e
         cs3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756894589; x=1757499389;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vysyoass8/7fXChxkNXCAvtsZyl5TuEWzgR+DsRg3BA=;
        b=jNPRI6B2TreEJ1+4ENrKmC6jPMzsuVZl72FUDrIbQ1ZLnIbWYpGoIrs5OxyNv9u82g
         T3nzROFIEV1p0WRUbV2JOhMOnckajKUtJF/nuPfDgWw3HnP2gPUW0VG2gI+FZgcec3L/
         EIikdXh7emTQREvNlpsjqRwuAP3WmHlHIg8PjXVgsh9r1VH3omyIEwaDRhI+V9GBBTqk
         4YK/icvC53l9hOX9zZaTdnOLXea9J3mmBDfe2gVsCTXIXWLLltCqulmu3j8LSbS9qvfX
         /lZrP+YiTHZtrw3rMA8QOiFSp+m53ituFljWPfvytiwbSjyAeLAmJRsJwcB4MNLg4aKM
         jDCw==
X-Forwarded-Encrypted: i=1; AJvYcCXAFz64FAOzk+IoN+RqQMZ6XE3xskzi1oVemJ57fWaoFrPkMcSVbqWUk3vgOWUI4fZA/SoP9w1+gA==@kvack.org
X-Gm-Message-State: AOJu0YwPFIOn9NYDvtG6oQDnyXolE95laWGcpDiiCl229bWNpXFkV6Wf
	F27vV/5Be/C4PGbKNBTaIVU4FO08hHPKUooYAlZvAmsskd+gf/E0IwUsQAYxB46Ox2412O1MYDx
	wcVzBoi+ANl10iLdfy1DX9sJ2i6J0QvXTu0MM0av4
X-Gm-Gg: ASbGncvANCQ430zVWaklIOZtaF5rhbXheJWnALZK60vyCLFlAgZ3rM6igntrIgfex50
	S3UvU2BiVT0ZYsaEdrEC6voiQhYQuCSS2B66akv9iCDyd1ksdTYSzseE1L3bV0B1Mp0Wrs2UL+6
	h7x/bkUgHzQwybu8xYux8IRv6z7OYMzTR88Hoouwu7Aub9SUrSc5rWQT/YXPeYYHRPFIvJizQjB
	GmvJl3DcMtOVd+fNYy+DSXmuanKgIaJBgObFDyTVlg=
X-Google-Smtp-Source: AGHT+IHwBiV9LKyHeujCf++SDvt/C0wOTrdrnbCdEByYNIzOd4yKfC34b8rjHF/8NpB89aPcS9hAgwqlaAjIQWQUY38=
X-Received: by 2002:a05:6214:1316:b0:720:4a66:d3e7 with SMTP id
 6a1803df08f44-7204a66de85mr63437046d6.26.1756894589045; Wed, 03 Sep 2025
 03:16:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <20250901164212.460229-3-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250901164212.460229-3-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 3 Sep 2025 12:15:52 +0200
X-Gm-Features: Ac12FXymppW_352dPk8Sx6ooy74nYo3Wzf5MB3L6oworaHp6lw6JSbbxp82YL4k
Message-ID: <CAG_fn=WNHYR0J2oehz4gO8TB2HADb8qG0q++y153Jg1d2GLfYA@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 2/7] kfuzztest: add user-facing API and data structures
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: wxx1t6rstdeiwjga8htg1uq5scdwpcy8
X-Rspam-User: 
X-Rspamd-Queue-Id: 563FEA000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1756894590-810751
X-HE-Meta: U2FsdGVkX1/ECTuEO7J3mdViFqBqxjnCxw9QckewFFOgvEghnHmL2zamUFTO1XvSXuZg5Pr2ztuo/35MHFM3EiM8+B2XjJEU5CoTrNxpR6V0C6/r+bKTLQ/gs1Y7PIsHz6zeQop/awu/sypOMHzAdOv3VhQSUV+lhMuEO80EStJJU0Col4d+9Zv0fnVKVvn7x1pksvzekDLydM8bmz5Z0THu3yK3nJ+u64mp/hvqtDrMKcC73vvzwYqm2uLK+dpMtI6svL39lmt82R2Ir40RN5YBS0Ntcj7W/8EuIwWJwdARINjMEVXrq0b1GnNU+8K6IY8lTUc34ACbpzabPbdwe3FoksMl1L6Ai/fRcKdaCzvXxP645uNxjNkGV+mwkr7qCexLI2E1g9OArrFOE7InbiiyFQc7WJG+5QiSgHx+6LtRCnfNjXHw2vOXnfzaj+Sq2XJPYNsOucmNPaA310UkC9SGx/DGy5rXdO/7Fzqlsbdqr9IewEbhOaDLH95RuXqhIM0bGpj9uIQyO6cOJbj9F34iRTandyQHo1CG43u//KNV9l9YUhDQXyEH9us5sLpopJ0fS3b9ZBtzfZtp+S64QWlVOwCRyTMPM00dem1f3VMt2aDCqUasyAiK2ZQoYbYE3uvuP0csXreQCQd197UkhpOs6s3gJalgsXjgueizSxKWEs/Na16JQ0hqmbY6X2ATuQ7l3g3ksmpl8F8aP7wFaPHIjz2Ols4SzT8YeofmH8WmZFMJJmQmqCI1H4jDbiXK+hjNkSDpHnHKlivVD+oBK/cQwKmWEvprvMhC4ACh4VPa7K/mR6xjgGAJtZ3sLIeH0rN59wj7zQNBiI/CObuQQ6j186cTZ72PhJs7l5MP4hB4icKfX0hWPzuRAe9Dw5unONi3bdF0a5PSITD7KtNghXcRMKD8178Mfm5ZlIsbbaf3Efhh5tjyN93G9Xmuk6jymE/maTbuFBjLwGyMM8P
 dScpJ2M2
 PEI+W9HywEPwKYzqh/S35+Urgu2j6PxdARQx0XCkTvbjJnnDhqjuirrkVti+Q8ZQQjdcCgNAQAr4pT4HEUANfO26E4eI93I6cgceNPReD5OMu4JMmPBhR0K2jt/Z3y4I9KgFZoPQQTKUew5qVZ2V3ZYRu9OR2C9I2xYX0upwLZeV00tUoPumXdZLd7/jOLDw01vQlIxRXvRczr08VjnKx/GmKz/rCDwT+Z7Z+qEoloKIFPQrCr4Q8MIYQH+BBnho1F1K4KB6F4m+CpjI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> + * kfuzztest_parse_and_relocate - validate and relocate a KFuzzTest input
> + *
> + * @input: A buffer containing the serialized input for a fuzz target.
> + * @input_size: the size in bytes of the @input buffer.
> + * @arg_ret: return pointer for the test case's input structure.
> + */
> +int kfuzztest_parse_and_relocate(void *input, size_t input_size, void **arg_ret);

Given that this function is declared in "kfuzztest: implement core
module and input processing", maybe swap the order of the two patches?

