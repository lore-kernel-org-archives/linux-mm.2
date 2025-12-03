Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56B61D1BDCC
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 18:41:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82FAE6B000D; Wed,  3 Dec 2025 13:41:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B9EB6B0028; Wed,  3 Dec 2025 13:41:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A87A6B0029; Wed,  3 Dec 2025 13:41:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 557306B000D
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 13:41:23 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3B7616070C
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:41:22 +0000 (UTC)
X-FDA: 84179027604.03.6580140
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7B20E18000F
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 18:41:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HI8O52D4;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764787280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t0QGRVrIlSEjO30p0s2Ug7VF2cMCxVOEvhbYGM0fVAs=;
	b=70aIx7MugHMIdy3/2uX8BlFSYwYd+jtjys7U2yIEwneB5+PRKD5vYbfBZFZuJTHIwFheGy
	RCFEXsbphcWmQCvMf4xmanbKz+61MqqO4zbG+Ww7+yYnhysh7r5TjWfudc0IpZMxPhLK4g
	hoW8pDQlPPvaYWAF059R2DDuzrmXzVw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764787280; a=rsa-sha256;
	cv=none;
	b=H1ekRN0R9pzsw/povKNuay13Q511tgfhQ+t/0/gqffx8p7GL2rcC2QwAMMzTo8722Gq6Dk
	GQ6oCyVqadwC2DHtXP+nD99aPMoqkdnYjUxQUmppamOQdTuNBrevQd0Km3ioDmM1Svd+JH
	c8sDNcgMraYEn9+Mw3QYaXMR9yDbziA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HI8O52D4;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764787279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0QGRVrIlSEjO30p0s2Ug7VF2cMCxVOEvhbYGM0fVAs=;
	b=HI8O52D4S93FpAgCgCst6lxDmjRK3Wz/qXleBC0FRK/eyQ4Zr7ywfxoQQFK4a8TvQpY+0i
	TTulnmmzoGgYaUo4CI/ZQmwl311oIX1hTKq4+XgzWbyAcOpua10dVVp+aWWKqvkfI8BMIJ
	4EUtqMRPeJiQ4Vu2/AK5XqN1r6FXyCs=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-127-OQMtm9sfMUe-WvCY_b_KdA-1; Wed, 03 Dec 2025 13:41:18 -0500
X-MC-Unique: OQMtm9sfMUe-WvCY_b_KdA-1
X-Mimecast-MFC-AGG-ID: OQMtm9sfMUe-WvCY_b_KdA_1764787278
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-787c89305a2so934727b3.3
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 10:41:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764787278; x=1765392078;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t0QGRVrIlSEjO30p0s2Ug7VF2cMCxVOEvhbYGM0fVAs=;
        b=kqbl+yzBodiAQUdfSSmXz4Rv7N43+7cCfcDCL5KLrhxxCseK4PD4mKeE7Ar6OWsPmC
         2QUPbOXRFCC8AekEAQaWckNF0YdeEEYpoJKdSFoOVJ5lT4pYTFp6sR6r6OfMDcST7wwg
         BExhXSTDO/vBOi8LXMVYFZ7lFgg8WQwbPhf43lOpXDOhkDJKRW7UQC4nSptDGOpfQiGG
         b/YExyfA5BHIsZ5mJxd5GFOW5OZNslFSqM2To9U9AGzXZcqhewVrRFdjzzfbOmcoI44l
         S1TDg+YeCj3V4d0hLxRJbN0mUV3Gef0RKaaYRL+ZGA+BpKC4OeRgG1zFeGmLiFt4+xZ2
         WbwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsZ6eX9PZmUZ7LYnErGbp8CaY1p+tlSNhptd7ogyaffCXD/+7imlxgVFJg1I1yUN3BQDz6emy28g==@kvack.org
X-Gm-Message-State: AOJu0YyBtDJ8dN6GYqradFkgDQ9IYz8WAuerTx3gR4KsAty+8UfXnV2J
	xSYtTkIXg9n5fkFURe6/V3jNcTYESeFe6pPLnICAGjlPuQgBL1mrfUn8NltXO8KLSBjzgHV8cXJ
	jA+twuEekroG6WJh+it1iTntLgh2tWzmU5X8ls82jnMEfdcx9wbo5
X-Gm-Gg: ASbGnctZfiUCTk6tUAoTNLQJEohTHDHtRvXtUYHGBf4kFUDbM2ZAHzEDKCoMYoQ2+zF
	OrSUYciF6sYs5IaDRf1mjbBnaQBrySUK92NjRXq5ypxpZBNQVGmlfMpC5ZxKgNCFn6NsoSRn05Z
	F2tQP+2v2ZngWwK1b8wM5a/MLD9ZcQe8B8pZkm8Of97Lucw2ztgz2LaIggukwqSY9s9i5Qm6jtl
	kCKpXzhbO1oyvvyPYM5afnpVcM/ubmhN5IBY5xvnjlYaEJyQsQk6U3y2bm+GCNCU9Gld9Af/aEV
	7DT1x6wwnC+dvxsqtNfA5Ze3YHTdxt8HXi2UcdOrfVLHQ49PEG7X1DI0QaH0DLOpBZ9yyVzvqSg
	y/qK56YIJmHU=
X-Received: by 2002:a05:690c:67c4:b0:789:33a3:a638 with SMTP id 00721157ae682-78c1889ce59mr615577b3.62.1764787278039;
        Wed, 03 Dec 2025 10:41:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHSwWA9VANqgVHDjjlZVWG9HL2J37DK4lW6C6TGHbaGNe8DSQZ1ftZxbEkmwZt7rC5uJ6Njqg==
X-Received: by 2002:a05:690c:67c4:b0:789:33a3:a638 with SMTP id 00721157ae682-78c1889ce59mr615407b3.62.1764787277699;
        Wed, 03 Dec 2025 10:41:17 -0800 (PST)
Received: from [192.168.2.110] ([76.65.77.217])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78ad0d5fe10sm76378277b3.14.2025.12.03.10.41.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 10:41:17 -0800 (PST)
Message-ID: <88f7674b-7c25-494a-a41f-d16121cf9490@redhat.com>
Date: Wed, 3 Dec 2025 13:41:06 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/10] mm: thp: always enable mTHP support
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: david@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ryan.roberts@arm.com, akpm@linux-foundation.org
References: <cover.1762464515.git.luizcap@redhat.com>
 <54744fad-daf4-4248-8690-93b39fd6c97d@lucifer.local>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <54744fad-daf4-4248-8690-93b39fd6c97d@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mKJAYw6kkCteT5rJKoMyCnPcMqqq4mo04UGDAOOAxz8_1764787278
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7B20E18000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: kkgtadqwif635srxumdiura3wfo7eszy
X-HE-Tag: 1764787280-795396
X-HE-Meta: U2FsdGVkX1+lPak/Z0/vOtMZTQzTcvgskE/sKxVOgi7yO1vVGCNBbWTVfUnHMfs9INZ1dH7/ogiJKtxOjfycnd/huLxsoWwS/DpCqzVl4XQPEfQ0wwVaLYqaUINBd506yUoidMxyGecPQY4wEx0pEyFIttLUy9IoGndP9TsM03HFRGkkLf6cvJWAyE5Ast7digLg3tPSDwIakxKetAsQmlLeW6c3huHhNDYEbD3cB2t4D/W7N2EWGSugODAYhQLFWvaf1YaPTaxNwB01RDlMqnXnN/us0IdbClrayJPZSyTn47sOAsprnuhorvqjjUOeS09LCZD9WliVNaVLgPb9DeGpZHUz7/jpt3OKvg4bszbZ3ZEUI3jeogBfxiIz8cfjNDFhjVqiZ1J6J77HEmMF2TCkl6eelhKysKbJG81pekMEuy3Ej2ksH0Mif9luktyimn3Es4k0RG2lMUFw2d7++ZgmeSOIkgOQig08jhE26AmVHk+hJv9cvMlAkg7goTRInjizF93CcsNrbYzC41TGvRXQZa4kfhM5fxMYimzbtnHEnLUWAHCk+aX2SlX7Pl6GcYV4q72qZNBtX/lZwjQsM4scubFk3X6zrVGzkqU7VJ69kaWRxKLW5gr4J80owR8b840QLDRUZZucFQsszOkVclbBDG48kVezZpL6m5trmdytcNV+O05nIctLd4NAb7e86eIkzK3xWSJRD9fDbMBSfxVBkor0R4ygBS/O8uiOKn9FhM/frwniJrhSRmdUYfMpQY0Nspi6rbP8l/EpmlT3Zsd0qrZWIq8qr7ry81zJvmqlk4NhLcFeE0sZc1Gbopn5XkAtWwVA5DAY+HT2bzLFOEMYA9be5GUhuR2XNsougVEBalXjexnT1hJ3dWwcz2SJHWAA2GNjjzRd/W5UYQn0k85DnKyMlXM4Maz/YJKvrbFKrTWkL8bEuA3gAXHSJPTQfiJ3+DQM3pK97y3Ft6Q
 1V7ZTZlz
 8y+ebdg/Pc/JUrZUlm0c2W1rr0YwUKml3nlZxGKWprHkzCg5M4dNuRcyPRVOkjiiXDLVzA3qFpz6Qkeyo5AbNFxqrY0f1jL+iYq5LFgGqudRShWPT6RXQI7oSkXLHEWeGTo0PsDlr2Torx1N5CTVj1/EmXuffntuGCI60n1TC73WTq+Nq2kbC/2zvX08/iii9p4w22Qy9I53btulUmKJidQgq+ckVm1Nl4/eD/+e7Xpr3Dk2NJ3LWpOqSGrpBX65lVynJbYCT8XdrhKV/NFfdqveEUT+kSAPFjSTFck0HhqZ/5Wr1GdVMwb1Tuc6jL6Qox6POSegl0J2UWTUYaqlRfGLFLWhv0MSNII84GVNzvIi9XSBb9YY5AyG7rxx0JsIQL/h6q9nM+KWtLvUZKpxLfe/yBKDQDlBHkqrQ02T8T2oigi37qOvrbpHepnlDYymoPq/exS5xQYfGCHW0yVt6BniAl6TTrRHaYL2is2nxxDMv2RH6DrmpzkqRUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-03 08:58, Lorenzo Stoakes wrote:
> Sorry I didn't say at the time - thanks, I do plan to look through this at
> some point :)

Oh, thanks for letting me know. I appreciate that!

I assumed reviewers are waiting for v1, esp. after David's review.

PS: I hope I'll be able to send v1 in the next few weeks, but I can't
guarantee it.


