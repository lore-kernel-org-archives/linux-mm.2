Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56583EE36B4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:59:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9BCB6B008A; Thu, 12 Feb 2026 12:59:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62F26B008C; Thu, 12 Feb 2026 12:59:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5BB26B0092; Thu, 12 Feb 2026 12:59:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94ED46B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:59:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FCEC574ED
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:59:00 +0000 (UTC)
X-FDA: 84436565640.08.CD0CEB5
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5F6E9120014
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:58:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IomJOmsk;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770919138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZOSg8873/nBL2kKHGdV86nA4vq2hCCWr9PveWQR+ZQ=;
	b=sX5rZkvZCtqYfaG/uUEYMWP9bnq9drXLCOQsArZEg3OWjsaFaqf3CL1ic7vbKeIpv/+I+2
	4id8PNbCXS38xeXMQLJHfdwcnLElkQ5fmW+LJ9FRFYh6AlDtErdcJbz0tBMUeCtqtn8BaZ
	LUypLkah5iwkj5wxPOdGCNOhv+mJHqY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IomJOmsk;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770919138; a=rsa-sha256;
	cv=pass;
	b=Hmyfy63Iw99uuCmVTGsn4Z6GkHuJBybH8X7ZnazkrJ8xjFpkk/CMk7RkLfBulHemS7NSi9
	sHDBHpIzUjKtQa4aSWJEkttY45tjCEKJLVRdUkM8AV8wv46kR5sN+S/LVpKd9ur0g/aQHQ
	ut8cMS7VrF3ZbqoeQZExMkZ0MMCpzgM=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4359a16a400so130444f8f.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:58:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770919137; cv=none;
        d=google.com; s=arc-20240605;
        b=a4iP/HdKHZ6IRk4WEc2KdHzjKHWJFEooJmWggwyLqP8M46gRL/z8JP421IZy1mjcaA
         7ma78mmIioBahKrN5IyGgJ8r2ibwAaQCyfdPWxMgE1p2FUT2VahtcHEPcFuaBwgMjNCw
         al7hX0Rz1lEUo1QyxETZJmyInC0LdpYH0hEJSQCn0cWsMc8B8ZqJBcWZBMnGO8ckXsDi
         ZWj5yk0ewD0NjEM6zq/vuox8JzgcIWPTb9EHPxIpO3GGtE59tXLArD1dPd2fIERGS5+G
         hH2Ow+JI9W5fmoU464/gLs/r5CoPJbfVPBb+6obbLPK0sq9T5HQfHVkwNXQ/RClWbpr0
         M4uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GZOSg8873/nBL2kKHGdV86nA4vq2hCCWr9PveWQR+ZQ=;
        fh=iUJqVu8FLoYGXztkaA7ZjSSrV6ucfN0npsVrCgxMlf4=;
        b=aMFnCI1CyorkHv2m91vMoK0iGvwfRUIleA8pA1IfZfrGqXjjggxSt+ZYThVY5rced5
         jmNdfUglLJ3fKfosK4M6HdCeIe90u1VQ92ukvMu0Y3cqj9qJuqLDWRdQboIS69yvQBDI
         aQtcOvhVuH14eEmSltdJDXehlhpeFY1xBI2s2jHKedzUQ/jVWGFK1IM1zhf6ymKranQO
         0FTuSXK3B2Dk0Dw2Sx0HUSq9x+Plg4g1z9Y776WaYKLgG3Y5WLl6LmyVzQNMVHaEws4Y
         B9wkTBdG8btHvn2UDygBzwAVMjba1ax/G2NWn4Q0DQGymeuGprMU32ApBvYsiTFAjCJU
         R0fA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770919137; x=1771523937; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZOSg8873/nBL2kKHGdV86nA4vq2hCCWr9PveWQR+ZQ=;
        b=IomJOmskP0a5EvRkv/iW7xBGCE/A+Vvb8+8FP8mdac3tk8kGz+iKnIxLk5lz7wfGPe
         KxBKnNtjo+q26XpvY9Bo4goOTJLb7keDP/nbvp9yj66tPC1QvgsWn4ztMg1lbFfmq7PU
         6eMwaCAl9oH4RYcCvhHt2wPA/lqwa+loUtf0YvaJbabcieUlLFqzMDSwAiT7efwEddDn
         dhhNPmvRjCszCSDmuYcNlB1ZIZxl82m2csiR0u5+vm1jKCUU/LIswBdd+Rd1TtHEb6GQ
         91Xj4BxDTZtl4BSSR/g17Wv7/2MHWfWJONCcrbP6JKRZYOz4b+RWKQnMsc21EKT3KuKw
         jLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770919137; x=1771523937;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GZOSg8873/nBL2kKHGdV86nA4vq2hCCWr9PveWQR+ZQ=;
        b=XR2VhH+BqTwDLxwQZH52LldODr9cRQPkQozqjIHvBFOHvoXGg6/cer6i9eZNA81iYT
         huns3guBPyLVT7fq2zxurf8n377shtJorRJSxi1LjZiPU9ZSR61+KhoUX+63q4t/MSW4
         pW8xo1mF9f1z6V94ZwzFsx6Je91p8rmFLigYaS0DEF+DDNHyomSx7bF9+rxf1RylWXsu
         hrDJ07YmPRtmFci+BftNkyYE5GWOPHWHWM7hfJCMY/CcD5IvIr6l09U3VnuJAhjTGIKr
         UDoZ9pyFChI9mkY2vMdR+rmpDt1syWrSSsgBkhmYa0hRkj4b9wdk1Og0NnGJwhmALePS
         zkWw==
X-Forwarded-Encrypted: i=1; AJvYcCXORfApL1ogmD5RJFMMhC46ssRtTpLxeXfg4TZzepTW5Whs3DaJ1fSJCDfnWKxz4ahOOslmIWQZvA==@kvack.org
X-Gm-Message-State: AOJu0Yzd/CAo1rH1b7nsQkCJbHU1GIoZoe4+Yanw+3v6htoleGv9Ty9U
	yFefpOgN9dBA7aRABAN1R7sAxh7i7edta7+xdZBI5mdeCLLYAa72dx7RIHvkz/2GlNLNBd58ApO
	WmhrqZACeMKEm28BycOcGATMB45b1Umw=
X-Gm-Gg: AZuq6aKCH4IzKGJ6MvZuYkpADmz3Kl6ot8+afV/33RXFqhaGbKSHXuQiNM6dycppjCl
	NKkGT/G8ArrZltYAMRh2js+dSA7OUVgKIangGulqyNW8yPs6r3CFDP9t1T8GNrBGrIvYElH0cNF
	iLNw6K01WNIkYSwBbMgCdpP3C+pS7rfrZNJlr0oGSzQhVB7uGoV3sYUcTZteyJPksK6p1A+4+4R
	eajeLYHDbfB2YzmQmBujxHkwc/sY2c37D7MzxVAGsSaPky+ifpxpe52SlTkbDhfjKG/Z4eoVgGF
	NOV2wZj9j4sgKnz00j8MqkApEEeKDdXGiYlvBkE=
X-Received: by 2002:a05:6000:1848:b0:437:6b73:ffc8 with SMTP id
 ffacd0b85a97d-4378f1069d1mr5258942f8f.2.1770919136700; Thu, 12 Feb 2026
 09:58:56 -0800 (PST)
MIME-Version: 1.0
References: <20260126065242.1221862-1-youngjun.park@lge.com> <CAKEwX=M5nH3=aqSLybCfLrtScpYKz+jRWt3JYG7im70DCoyjJg@mail.gmail.com>
In-Reply-To: <CAKEwX=M5nH3=aqSLybCfLrtScpYKz+jRWt3JYG7im70DCoyjJg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 12 Feb 2026 09:58:44 -0800
X-Gm-Features: AZwV_QgcskLGDZ0cxqOCobFTw5foptSrR7UE-fRtklh_9BEelgLMdF8lgW97IBk
Message-ID: <CAKEwX=OSQi8wzC0vtFnBa_yGcf0AzHk0Z5oguWdSHUDFuh9KQA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, 
	austin.kim@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: w9e1en4nqhcpydbmtw6h7tpeysb1mnp1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5F6E9120014
X-HE-Tag: 1770919138-463610
X-HE-Meta: U2FsdGVkX1/8cr1m6dXnzLqaswDRmY1IvtMVg8AxSZTdwqMp7pfA/+4Ulau+S0ZJ/j80amWYprfo0CHgrajAZAxNX6pPdRuAR0hE1kLQdViXAXf6bhG1NBPoYMq+OePT+WBIdBGUsY+zU19QD5DIqGvw3lUxidyYLRxb//WHgE9PVUtth6WeoRVpN2xsRw8BPTr6xryKxxHDWtlICQQCS/+jdmEuV8DVw4K5vNE4UBkCOcZ1HPahlUZzjo0CHDnSurMlDU5+vdJ0C6ubgyZsNHT/RdH7Jhrf/r1FHRHUCoa8mg9tN25D61LgmgmGhOqhe/wfPJZfaiJk0bORj6c0bLn0rsjVCJHqVaUkmKMJOD23AC5QJp8BXLASdHB8CaGBkuE6hhxMmHjrnNJRGazlm8NuzI3xtov/4M9IcGchm2wvdmqT/fFnLJnzwHn4sK1Z+AUWdE1HKNE5vUr43gZPf3Ys/rK0fRaoTHAZE3MBlJS9B7r7XBXvmit0RkUV+BETQeme1n0uzLhW+MrEG95vf1TNJXbVyDtCKH+6X3U0TB6KS1/ZZrfu3HlQ4j1u7Xtqvqibp33AUg82Apx0P5kwi75U7AZdDCfAQvA3DBHvUXqJkLDBEHUehq2P34t6bOLITGRKsRaU/6qghAArPCA7L2kz33crmldkxT75FQDQq5OZLCO6T5SVMYxNSGXQYkhXgcEsuhoStRw7uc9+X92bcrnd3LtehRFW3oIKvmwdLfqT7AZKEeNyj/30DE9mXXkGa0ee9qCvKNS5cmBV5GFDNj31VkgwkPdDactpaoELFRfy0aEI9Lliji4E973NYwE1A3ZTNpeGrNEXlGX5YieTtALtz/WwO7rghPp/QsZUKgKuO7EgzAyyl+eHUdI/rYJdWsLa5zPogbcjTk5BGpUI8RAhHCTkiyVq1G/qV0JWVuvvcgE+mRoU2b+YCsXTXAJXsKNBTBWRJZIdwzMKNr4
 9fi4dBos
 tCepBt6DOnSElunRehExuja01gHCyxzeXqc1/YLFk2V2AMrPEzEZTinDEOrDCk+a7rJ6oK+tA3dAVo+jf8lkCj4pWTabZiltyd3OlGFSMGvqJ8oeQslXhIUoomTpgjbCKcS8NlbOvwetGQL3ojfyJPbrVhVynxMGUbK0fe+MH7AdRYK6rQRYWG2Zj4+kdkkEPCRj2ND1CkDd4pjxbiRu497WnOMoWF602URuC9wqwHmZg0gCUoTHIB6c7d+u0L2TziJeIWCv+Ko3OaRCcunUPO5vFdV6QZkHaMUxjDCPXdkNekU3sek1N5nYi6hooZ333BKAEnktgOfvRW1BQUOK8rQMN+6SToS0qlKK81cdsOv66ewqQV6ueGFQrUsBEu7WnUCAI+6p8e1MUJVoSoY3c0BBVBsieoleGr+0nfT2sJ8KCirpTmaHoTPfmoHKqBz/OCmZ0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 9:57=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
>
> But otherwise, I assume you mean to restrict child's allowed swap
> tiers to be a subset of children and its ancestors? That seems more

s/children/parent


> straightforward to me than the last system :)

