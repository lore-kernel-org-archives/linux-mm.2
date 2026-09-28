Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A951CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 13:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCF856B008A; Mon, 28 Sep 2026 09:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80336B008C; Mon, 28 Sep 2026 09:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46EB6B0093; Mon, 28 Sep 2026 09:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD406B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:24:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2590140201
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:24:44 +0000 (UTC)
X-FDA: 85263240888.15.FCA5BC3
Received: from mail-wr2-f42.google.com (mail-wr2-f42.google.com [74.125.225.106])
	by imf25.hostedemail.com (Postfix) with ESMTP id DE4B2A0009
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:24:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ke84dEP2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.106 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790601882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnZRje535Omjq7bTjfZY4Rt+ArD7RwaYq15aIzeRtgo=;
	b=LxI/rWRKzD0AvLqefGODP4J9ttZKsyBrPeqzYHnCqplksZFRR8bf2XhT5n6tWZeKhc2JW0
	kywzpq6xyzKhm70ZqseqbPYwWEYY1zgt5GxupeFCWsGIFirv0EE+0GOWmxiNousdz/RAOy
	Zm7HqQppyrLOQqEm5R3eUeIlgPpthco=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ke84dEP2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.106 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790601882;
	b=AwwOR4Z1+eVgoVPbvQS8xz19xkbOnL0zpIb2CQyZZAdckDVl4u1IX8pLW+TrtW+L2JHOuG
	E7KOGCEpXMeMJT4FG3nTGivFMxUCBGXfUCyTmTGgAm3VkH25PPnCQ9kUCFc0S3Hatmx5WY
	PY3xVxphi2V8fuo7xjYCXHDqNQxq//c=
Received: by mail-wr2-f42.google.com with SMTP id ffacd0b85a97d-4888598e4f9so1770942f8f.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:24:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790601881; cv=none;
        d=google.com; s=arc-20260327;
        b=hoDYRTCwi5V7iagdKB9rjy8aQKa5+4KQUyF686sDB6bJWeY+U51l7slfCM8y8ovNai
         YUm72PLpeWeQocIq1+cAcU1tZa+Uyi2s/V/PHEjuK4/JNE4OrLmtzsQWOyH7ev1ZH9UI
         cX5sj/7G1dT5yq0jRWDAN+vAJTDJh5EgJ3btsz5e+pLE7q+2IrA8ZeYZywEGiH/cfy1b
         tTDz5xHHPkqsk4mtkVsX8aZ+G2OlSAcAaNYtHp5ZizfETVzn3Wp+yoYczel38TR0t7Uu
         DAvjT1wD1vqj2iGLXwcMbqac1TUAcO0A2d7ploT9Ee41O79+ysZ/SaKUOOfJNRCLbJhP
         fcRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GnZRje535Omjq7bTjfZY4Rt+ArD7RwaYq15aIzeRtgo=;
        fh=QCm0k3K13vPeqF2miZv+No6+6HQ/RIJKBPQQcs+fOh8=;
        b=kFiWh+OSHELfBtGuHU59FuEC/4hNOolP5fvxlpaROB/vAHL9LOdd58343NgVlxGgra
         5gh0x8GEz/4uK/QPYwg2nXwuC8o3czodvkFeRLBDP3V+uozsTCB0Gx0X7Q6ZJbjkulbL
         waCbCZjtxUBblTd5kkPige1HyDXfAd4QaSlqst6yS34AQGdCAj5EnELmSV2Ts6k+MY7v
         DjIdBGvgAImJefj7hSHB8VL6LYFM2TnEclAGkGJFnim3vFPqCCY2EabIkus4uGfMlRUc
         +TWSkT5T07rdtPWCf2UgQT7mVRuwTZENu1LY9U711EaLNbjj0fXGEwJi+Vp6azLjB3pH
         yxiQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790601881; x=1791206681; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GnZRje535Omjq7bTjfZY4Rt+ArD7RwaYq15aIzeRtgo=;
        b=Ke84dEP2oOZsoUB49Mcsip5dNLmRjiKK5eLbYSauxbrlwFM4zPIrnjbJxjU2dpsulX
         cuHklAd9TqIgCaCX+0Kp69AqmmQQsU9E24m33iR5yY0oPfDxeG1JfMEi4lnXG4HST6JX
         lUBc0ynqrHsoWEftT3dZqu60HQTSoT8Cy8I0PnKO2m+0+qzdllbBKH52Biumt7/jdIwl
         S76E8WHy8PVi5bFtYv1XxMpuG7VL0nekkM87qPpFj7LMDrU6N0NXFeN2lOiEIMLXkFVZ
         DtQRyO5PS6YmMh2S7n08fwk7vGXIto7ZmuvI6aonL74nlw3IJFGg+4JQggRZCVvD73U3
         fTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790601881; x=1791206681;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GnZRje535Omjq7bTjfZY4Rt+ArD7RwaYq15aIzeRtgo=;
        b=onCpPlTTxXSQZYWi+uZrSpxzJfJ7NiKXYN+YylCCt0SjFzdVOfuyvGFOY5//JH00OK
         y6DfIC2NsWt53HCIGBAjkdFycLJMD2Rp7U07CTZGqNqBlZQtQAZ4K4P4zwdCfzxXd7ic
         hVaWhTkBAtUQX6bAhcdfIoPoNoJ11fV/y6jJtbbIKZgSqJXMMaYCdr0xPUHUHRKqNXK4
         qOYbC2K2xreM1HrUVoIFVSArC1SNftScg8XToF814hH98/wRIjyRvSxHT8ChX29TZD4o
         CtOnEZAWpoDOtyuLsu9sZUcDKkF14zgL38rxn7Rfwnu9usYo8WJDwiiOg7usxKB5AhiL
         S8Vw==
X-Forwarded-Encrypted: i=1; AKwUvBxlt777xNMJVNoz0X8WFPWA9F0ZTyAp0YYqgSyTwhhrj7EPbREr8ZogkDdG/E2vHHSF0DlndLxFRg==@kvack.org
X-Gm-Message-State: AFq9FYIAlmw5/OJEsTrMTDut4n3m71F3o+uxcaETUMK9zazKEuQuv+yl
	+/BABHnkODfHZ2LITeoGv12jzV+zENRAArBkDBsB3Kmf5tWsDQAoo1OlH4YdbriJGkpe/wsuLPY
	KTGqkYRevxVP0HhdenzKJU8l3NhiLCFM=
X-Gm-Gg: AYBFou3Io55LndlFe4tDj3ESQugxd7Ky/I5S27SM1f24OtIomPaDrAFTeLE6q5rvCcI
	P+Jtr3M+8EitDkBODX5unNQKubxsnc75uFMWWwd2QhoR4V+G5eYyyCkL6JTVWDLCuVVNMYOlQSM
	QY+PN8BZq1RFzzoY30FkmpPjFxKlvGVG1dV2kfxlIH3JKcMgO9/SvtTe3BA/Ie11pm0Z9zqbtn2
	fhU1zACRr18UDBAK9BZ3JTzMS+38ljBUTByE4/ynpLzv97vp0+NddNWMPF6UFGL+a5qmtMD2ApY
	SZjIAiBZLNp5Ve63CPS9vBb01PCa2VZWoAKuujeGUZhYudjqiVy7g1kErAT7nDFZbwMGjTDXvbk
	/h7vH31ZZZCF+wSKHnH4NtAFr/PQ=
X-Received: by 2002:a5d:59c9:0:b0:488:8232:d159 with SMTP id
 ffacd0b85a97d-4888232d348mr16059474f8f.13.1790601881245; Mon, 28 Sep 2026
 06:24:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260918180241.3424851-1-nphamcs@gmail.com> <20260918180241.3424851-2-nphamcs@gmail.com>
 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
 <CAKEwX=OP3Gb9sVOvch+p4j7quzgy-rUY=UTZau5ztMj7heJJoA@mail.gmail.com>
 <CACePvbVQsHXt4=+qfKz-KTar9CG+3OiAfLd1EZgnRE-1gyoKOQ@mail.gmail.com>
 <CAKEwX=M8pJUYhmADfvdk+09O53EROyDRC+_b05vtimQE5VN=qQ@mail.gmail.com>
 <CACePvbWTZgbL7U-hrgV=V0egHZ13EqMCOsUbnKTcLvqnv85zUA@mail.gmail.com> <CAKEwX=M1tc5fLSgxbq9S9TU1AKJWtRZA0AwGQZgNXJ_76hThFg@mail.gmail.com>
In-Reply-To: <CAKEwX=M1tc5fLSgxbq9S9TU1AKJWtRZA0AwGQZgNXJ_76hThFg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 28 Sep 2026 14:24:28 +0100
X-Gm-Features: AclHuK-U3fLTMhHK0pk3rONO7wDcH81pPs_iHjZbfq38GiuI5bJWs1UPQRmTG2g
Message-ID: <CAKEwX=M0afcz+b1pBd+R9Ddwqwcf2MuC0XUpC6seL=yU-cn57A@mail.gmail.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
To: Chris Li <chrisl@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	yosry@kernel.org, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
	baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
	skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: w4dhj8p7kc1rmzxoz56axz3mnyy53po9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DE4B2A0009
X-HE-Tag: 1790601882-466791
X-HE-Meta: U2FsdGVkX1/8Cc4FXqm3pQkxhpW3jLDKVp7TO2llSq4FzPNbYg3AWnh+QXMW13D4Zp12YxuL5ga4rxqbmosuqGTNAQ9kBj1AzKqFITLYlMO+tEO119D52lz9BCSmAzElITqe4PrqC/jav4DxN0GcDtVeTbKOAYW5XTBK6W8yc92wgJvnAFFobQ/+aHvq+Wz92W32tCUwggbRCofhSqM7vsJl9FsIEKk4gyIq8WMX46JZc5KwZCrJs6US6urC5JEUdHLlW/wx+YqoziUvsW+YeBzqkTQ8vF8xrrv6jdR/2rlVzDBexq1FDN3yT+QuaaS2ND0Styvmy2OA21GhbKeJtT0J/AzA1+pNonuDLN2X6PeMFff3G7x3nwmsplO/22yWwQvO77fjVDbE7xkwIpcv22c2Mk4Se/VFo6Qvu2GVWkki/IFVGepw7Zrc2sohqoZWwXXistkC0dFuM9kn3KcRFq9qfEBWN8GfOBo5KuVR6uKMfp0/IM/nVpo03dzTbTQ0nww4Cd/jZXJUbFv87t1Y8gPx1FhKwbhOrVceUjhFZHlxb4irlEIMYhqvuaBkzRm/bTx37rTxhuaZdzzHHsQJU5llnV50g8JiTb/1DmMYb/0gBBaqsO5P80QfXjA+VG4SyVX8c6zEDNCXKuM+YxAN8eDRH6ZHY6PNJruB5iON2EIHZC2cGC0WPDqoIEqkmS2wmiYxQlZvZ4hDNSv40ZW6gVPF7mgDd/tAEvQe3vhdD02hUiYHT/z6iU7IdDlsxUfOMV99O8S0mksipe8yGXIStW10Xn/vkOMDe4rsyl1H+RRst7OMwCO2UmA2/O5+OSfD4QKZLCyudUZMu+rjCf8MyRCkE6XLcuKuIWNqocm4OIjzoAL67ZPfuWqV19ggDiDtYPr48CaaFpFiKOrh5yikdS1TEiDUECTfqrafn5aGEpTQORGi5R3QzXa4Tws0tKdAckn0raBouMpil3CAY6p
 pujJofoJ
 1MBqJgRPrnnFgmw/59kqUzijv6A41qO9deF1uivDbV35IJgaeV8zqAhPLiTRdQNsG7XlUQrOXjiClOsDKdi5LuufWMlqE3XjWGsAS+tSNdb2EyEmH48W/uWZ59VL1ZXDph2cWT/KJxVI5vVdTuBpXAQCyWBZHiY0zS3fd6iLoCNaDGkSp/IQyIkI6StQB4wJjIaGR9jGPXVfY/Mm3f+2sbhfv8hPHuBWTae2JZ2lsGF/X6PpecsUeecleq4X+HCpDI8bbgvqVZebzpHY+yx/VJFAGi5/2t0IO2QSuKmcfTBQLWUI5Q1tHvZFbe8GcbK3AjOdD2b61OUQCjP7guxe0imBZrNcEBLLS7MHCK1rWYGkdiCVGqN24gEOHLGS7AMVZuGC6dJtu4oc5mR5tasSHbmG8CDFOEt/NJAgJs9fvPzgBRCuJA6fD3OLEU/hnucMtjld1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 2:14=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> Vswap does not have that, because vswap is not an ordinary swap
> device. It's implementing the concept of virtualization (the "V" in
> VFS, if you want to make that analogy), made optional to reduce
> overhead when indirection is not needed. That gives you all the
> machinery you need for backend transfer:

... for zswap/compression backend.

It's a necessary condition for non-zswap inter-tier transfer, but not
sufficient. So it's not a solved problem quite there yet (and I don't
know if it can become worth the squeeze, as the data becomes
increasingly colder as you move down the tier).

> layer, where you can update the backend, without having to go and
> chase down all the external references - no PTE walk needed.

