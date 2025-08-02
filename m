Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D05C87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 02:22:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C15536B007B; Fri,  1 Aug 2025 22:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F0B6B0089; Fri,  1 Aug 2025 22:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66866B008A; Fri,  1 Aug 2025 22:22:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92EF46B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 22:22:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15E9211472A
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 02:22:28 +0000 (UTC)
X-FDA: 83730218376.15.D49FEEF
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0D94B40004
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 02:22:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FXOV0KA+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754101346; a=rsa-sha256;
	cv=none;
	b=60JfQhRnS3incGAPa8UQbKN4mEdagdZE/++5j9IV7XJDZvLVe+BifhuB7ti8zHZL6vpoom
	6IPu56z+wum3qBXf/y9kJsQtouo43GPjKANP/zNyqsKP75tDthJ+/m+GfrUaHz9/CcCWpz
	kRr5cS/GdK8v6+BxfGS4k/t76rpCA5A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FXOV0KA+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754101346;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSG1LeV3cVwQV3wuVeNb8LQrAKUqxETgJKTWaJErw04=;
	b=UVnpMHgUEICc7VvQxw+NavjwsOE/wxKgrZNpHC5bGS/aIsBf3osBs8OUJmc90JDRPvekUC
	gdE1WA5l2DaLtqMuNYmpPkI9pjfh/ZvvR9I1rggElVcJs1U6pJFvaWOShFgMNM1dhUjYM/
	ON5Zw3pF5ZgzJNjyMTEF9Ro5RZfnUJE=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ae361e8ec32so498893666b.3
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 19:22:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754101344; x=1754706144; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hSG1LeV3cVwQV3wuVeNb8LQrAKUqxETgJKTWaJErw04=;
        b=FXOV0KA+xRETmR86qmW1EZE2XNJps+j7sAuLTAZkAxu6D6enVgcBmWQqohUqc3SI95
         Q/TWYUjFGMM+JPc9ZPLMQREH6EhZ+TowwgOe+UlMTVdNN1WeB0YhahkV8D3dSCnripVp
         iD26dTea6fdLCOySxk7vJTzvBADZUWWHzLW1WhpEHiqZrziEqRptEIWV7Jqubmj9v5zU
         HjaVMo2vuBkv+1lfOHqTLIRUwgxFjVNnL9TALHAT84zOj7qQr9HOr5vr/+kQcr4IxQDG
         DSuqZP9pWGd9Fk7bMYEfrGYAyfKHy33Y1qv7Ad3NTGC8M4iv5/z14+ttBECVT2S8zsMG
         i2aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754101344; x=1754706144;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hSG1LeV3cVwQV3wuVeNb8LQrAKUqxETgJKTWaJErw04=;
        b=ga0ZogAbJAsGJX0ekwBGAFKjcBR9mCHo+nQSRFoYeFTxfx+rFdE8m1J2C/Xbsk5K0u
         qeJvO3zxwIk4/GG2eLK4EiFL6arZHWCAfW5OSI2PslDaaa46jro3tQfG2Obv1965jgkS
         YTgydhgG+KDkzBBDMi1Xn4jGM+05HJuA3s2zKmg2Gou35y0PoKbv8FPDLE9GHO7oXBXE
         2XPxIMKDhoJZmq8koGXcxDF+CSUj2c0Nn3yc6x0im/fc4SJ+fgr7BNfpe10nwxueZn5e
         zj9C1dtUAsp125979qxTwApITZUsWb0Kz0GSDNTswszl/46h77T43wPZDSO9IkbsW/Mb
         tayQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2aE+0rilI44wA0dASeTo2PvKzS+NkkpizmsWUsaypo2OslteUkb5hjy7449Z1IVrURh420TM1RQ==@kvack.org
X-Gm-Message-State: AOJu0Yz8G7P+LcU0FAKDnXQfJdFZi5adbLEyWxkrmejhsa5ED2jcuVXc
	Kn+pxoeo5Ki9ADZxae7IRhdqCTT+7SXsiHTMqlGKITonIgjDjKK8qJKn
X-Gm-Gg: ASbGncvn5+ttcVlwUG0GyAfsRseJb4lOtyKRuRga++i9R4MAnVJBY4WcqQAe72BxEVH
	VtH1D7DoATL4DYKQeCKoUz0FRD4DPdXUatQmWB24rwe6bUL9msYfpJM3J+s8FhHyzVXjqQYaLJS
	DjgGoYQSdptH8tMqt+KaXxMdH3O6M4x//FFGSYQJ4bBrY51PdI/7GWMCJ5p1tKoiRvknKr+l9F/
	T4aLjnRX9QLESpYng21XN7egAmduRbm4qe7snfHqtQvblTvbO2DqFqAxTvncm0vCSnKJiv1K8YY
	eFvBVIC32EkXh/R8mQJPoG7BKcvizjp4ZWeq1zdbjUNHUcSI+09yFs5mcIDDO6233lEgDyC9yEe
	2ocU3O/+PvToSI3ZecKkJhw==
X-Google-Smtp-Source: AGHT+IHDiFo+GXkK3xhr9Jlv8TPjtoUbMQljTtFnbkUlqH0I7+/3roo41mHr6kloA0aNXAxwf4/OXg==
X-Received: by 2002:a17:907:3d90:b0:ad5:3a97:8438 with SMTP id a640c23a62f3a-af9401c3e49mr199013266b.41.1754101344137;
        Fri, 01 Aug 2025 19:22:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a2436c2sm361389366b.141.2025.08.01.19.22.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Aug 2025 19:22:23 -0700 (PDT)
Date: Sat, 2 Aug 2025 02:22:23 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] selftests/mm: link with thp_settings when necessary
Message-ID: <20250802022223.qjzvuuhwm43hprpl@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250801085444.27182-1-richard.weiyang@gmail.com>
 <566ff1f0-e6f4-4888-a901-4995a84d15b7@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <566ff1f0-e6f4-4888-a901-4995a84d15b7@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 0D94B40004
X-Stat-Signature: qrm1cp4gedkiueaj9j919bykpac8hnfp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754101345-957700
X-HE-Meta: U2FsdGVkX1//ZWNOluAx0iRL650kSLUKtwDn65DT7t/2WX6RQmbHW1QigPL6d2u+erLsbuqisjiPunv0HMv5o4o8J9cshU3rSTNGd9aw3BiZB6ibLP2U+fdvjt5cOkS75Y+SoenD0jZvJ9kuIYzY85W/1dSY6DTmlBxWWV6veXlSnEFao9J1a8OgauZKhg4utz1S2EmL5xTZbVK2ot7YA1Qxye4WrJcSzcqONQovD99RARgkjjLF5m5q9aUHcsHyefm5cA4sGlnuWlx8KxXfnDGzfUKsCY+cFxU5rE6v/T/pfnbShZ69WTL36q2E1b2dSkQoIr2dSQzrQchIt5fYFyuIREH/XknSo3gDjR1oZOVyRsRUkZDfgQVeLLVwcLvhK7FAXWErocjz7n5qeSgQwdKx5ekq08VUX/OdN2Ywj+ikaOlh5+HgvLHnTFIM54FiaW3dFtMKViE8cwj2ZPqKjEr8pOuR3GCaN13DBUiP1jZku/lF1m32SXiFYTNh2bKwuxNfSf+IeCEl1wH9Leii2cCjCBOg8hWXUAiuc31bNs1edvdj7wtuMDfuZXGqUvbjueqkpJtpDDXH4h64SVD+nohKEaIwpcHj7fGMa+Q/8pv0a78FyYuGtaPDrPUc75uFntvVyPvcR5wAbl60WfoLJeUBn4JT0lzdptho3MhHCFg+5hZjRHdsIg0qywATg+mY3aBGfomv79fQ0AY6+g+yNxt7YDge+NlGkyNZ9rkuB/CGr9gtVgElFphOWrtGDLCRnbW+xGmyFjviLoFSIfNW+mi4gEQJvjz4C8hE9ljtzqtFR8cEkfi659L8v/LF/xxMucLBi0bM7ErfEQVq9IflWCP9E/IqPIQ1apx64SNPg/EWRZl7a5n5RhMEPCJrD6HP+DlvEvMO/TKqXU/Esaz93hO9aImO+89PHQW4jDv63iYRKyghpHiBNsldvfFyEB558vV/DLtLfo/5SVkOib3
 1WQv3y1D
 MBmhpUzqVkt3F/e9/arV7czzJJlhFE8qTkXb6ZEIKm2xOeK1MQuewJGh9LzczE9+MIs4JGFj7zu2UJ9sCkGaHhKGxI8Bbbnm166J7IaXCHFPH3cRNBfOGtjAkuihwqGvgviTUt6oCKR350+d/TDGaz9io6IaEu7ZlSWStzveXCOFacid0f6JNR3f6dzJ/WJkC446Eb6Iaew/SHQA1dcwGVap//sovLdjqZKgpMcxG/WKckwR4xr+3yy31NIoZjxn5/EwG6Vlxwe4i7mYOr9/A0VSo4+SzHGiu3t64zKkuxIAXAAWFMVnLslUN2/oc3+AgtX8vsU9mKjDLD1nQQcXPqmjeBsVZjxP61NkaRsZXi63k9dMs+9iOa9wdfk99AmS5VXlfg125rmeYmZQjfqmlhb/DTJCQirKdd8ghGjnQPGg5j60vjLnUlNTwnsOUt5fO8D4sXXCZp5WQVzpq7cudccphuwc4S6bZsqZ02OebmxlwSEWxtVGljb/Z3nCyGCvxf6NShoZlzYiA74STJH3rvBmDhT3uqBqHoZQJoJccG6dDExH0rsJSgYNTZ5Ettppq7r2OhCFkwv7Y2c3sRlyKc716kVyquebK9KYLCCoYWy6iP3vM60MoXLiLWi3LnJUkSx01m9dFJN8QuJZNTQ2BoFMGe3MZsj888peim3VVdqAM5MuzCVyV1QwTqPMwXwQpIFeFeBK+g6jlfeDqJGVBNwKEzObR23v4g1SzQoOEVLuIDaMlkGoLGWnbzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 11:02:35AM +0200, David Hildenbrand wrote:
>On 01.08.25 10:54, Wei Yang wrote:
>> Currently all test cases are linked with thp_settings, while only 6
>> out of 50+ targets rely on it.
>> 
>> Instead of making thp_settings as a common dependency, link it only
>> when necessary.
>
>
>You don't state why we should care about that? I don't see how binary size is
>a problem, why do you think it is?
>

Yes, it doesn't help on the binary size perspective.

I come up with this when doing some test. Each time a change in thp_settings
would rebuild all the tests. My intent is to speed up the build during coding.

Not sure it worth a change.

>Cheers,
>
>David / dhildenb

-- 
Wei Yang
Help you, Help me

