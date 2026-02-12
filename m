Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BB4FEE3698
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 17:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77696B0088; Thu, 12 Feb 2026 12:29:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24B46B0089; Thu, 12 Feb 2026 12:29:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB7B6B008A; Thu, 12 Feb 2026 12:29:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E54B6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:29:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3071B1C13A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:29:51 +0000 (UTC)
X-FDA: 84436492182.11.361C6D4
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3427CC000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 17:29:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jDRBB7ep;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770917389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DyST9RsDa8+RJbGkxLnNeDzfcMCn5YRH5YsSqjoA3lM=;
	b=SRwRgpngNVMjjUH5dakn6waP0klHasLZdBvL5HAET09dUHPHiB+OCPW6dzjVFjHrOIj+Tx
	VE7gu6cmWJeukx1ux/FKsN1kNLLZgd990VR19q1Ees0631ezFln4ZpSoJqYq0IqPCTOI1W
	X6KKTYjJyNEZsTMxbmHWOdcr8BFjoN8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jDRBB7ep;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770917389; a=rsa-sha256;
	cv=pass;
	b=hVr/pJzfiMDF7URZOXYT39j0oe5JYgGWGELRlJ7lGpuHQhh9MLcOT+s5e9qVdBAAZARTPw
	y65dH2jvTxhXKwkRhH6bhbtNirLK1BECkSu8DZiGBGBfC2pLuVsStMeTQngO/W6p/0W0y8
	ovdSUrcCsrOTdGOkAqO3CXo+jwh45+k=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so686965e9.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:29:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770917387; cv=none;
        d=google.com; s=arc-20240605;
        b=FhZ5CE7bmxKmFSx9HSpsNWsY8TdIauPShcBx2xq4BDUyrEbXIRZEf0S/kafJ+yJp7z
         9bifcvjaNS1ZuQ4pWxfBH/1pNhSCv2IKibzhTBDhL/0OlVWql0UUFP6mEcmLSqk7BrKn
         m7hglO1nnYzxkdXNs9OmW27fDeNAl3nMiQgI8+T2ZzhSb8A4XjPSNgP+0tPndZkrUr3S
         1+XCPEio/C3Ia0yibV3/y3NgxzJ1/zZSEy98pZ+9Pn7MtVdFNJSJ2NdpNjjOp4IrMDl2
         RZ0mVdgRmrmdnBu0ryS2VSNO94l7fVCB0RwVgK9EN2Nf6bdLfx2QF8eOeEB6BRUl7Y3E
         yTzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DyST9RsDa8+RJbGkxLnNeDzfcMCn5YRH5YsSqjoA3lM=;
        fh=BunrjKy5p+HOXa1v1BhdB83GBr1Pco1u4QHhWR15jOM=;
        b=GISFqAPX//09shfFCjZei9wgZwYM2OfoIWlpZqEKPN+YM4LqD1sOQAzQT/MueNUenO
         b/9i2EMWbg8HzziizG32w/AU6Q5nAN2pfoeRim9vAJNl5hMeypX+dRPXyihLx9l2wzBq
         Ke4oQSWzb19C35hycIowhdBXRojfH6snrBG//CIWZAI5/6jyZRmWGX/+/jjrqOLWdV/5
         giYzajUbGWVIEWjvovYJdbE3FJdNs1TgTBOWsQ2n3X7IkHsKeH/W6bEN3xsPp7T3n5oe
         L8DZvIUZchGys9zdgFMAbYPfF2XOM+ZAhWbFe1ozAFe+pp8XNFywIrptZEyXiVzhg+Mt
         ZgUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770917387; x=1771522187; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DyST9RsDa8+RJbGkxLnNeDzfcMCn5YRH5YsSqjoA3lM=;
        b=jDRBB7ep8r/sczBdRUlhx0LQNT8YDh4AJGAV8TEaYca2HwHxlJXVDQcwo5hUMtdolm
         I/XA4/fTeYynUirb82dr6fsZjpbZsGpSJjtJ6xFS1OFmQoDFryT2gD4HRX9gHTPZTT2g
         86mYSMD2jGIsrCv98pxsuBqUul79QExIkDW+8aR6hrUbfLCmt4GYD9Mya+kO7OJwMxZM
         LzO7ynJklL9MSwMQJPV41VWPI5qGM5z4TEyyYgglXELjYBKCzyWGTC82homG9Ot8LUlH
         WD9+m8YfZKipFBJbF/BP8az9CvvnrcNZJcoqllVYX0dULM8UwfhWJgtie57scD0qQ1Lo
         5ulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770917387; x=1771522187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DyST9RsDa8+RJbGkxLnNeDzfcMCn5YRH5YsSqjoA3lM=;
        b=IxU+XAkvHCiIF+qRIKjcPYwEeABVX4hrtFDuX3CA2pjcbZ3AoNXzJZa9f2dJUf0THv
         9pN3fNgB9QuHfTtdALEEByHr+Cj/C75IYCuSaMYz8EmXGPg8R6XV54PSJm4Gv1wQZXjh
         nnHgbHm+Jqgy0nz3kjO5R9L7Ut0sFHTWW4ipLlBc3ZeWGA6JnGgv9dLFESALBgstLhx/
         sxY0TxNsUCoq4smlnf32Iu0X3qxqac3gBQyWtj3AmjF9ZJMQPWJ6JVCcn7YN6QDLGXr8
         MZ0af0XE6lfyQWHeC24IVJz3NtgyiFuXrtmfTw9xXQnKb3+yRKoHLunjIPT5vojtqacy
         DAJA==
X-Gm-Message-State: AOJu0Yy9roKI6wAbWzQzMjsLy6Mgsp++PY/pNB4psIc0q6G/90iCndOL
	ii4njFqVx9LLKjvhQbsr/9EDQ86eABkuevNif+uGOS6hUnnisPw1iVNaRaCF3GaW9q7u1XZoQoa
	xqTLais53avzEdIgWJBFIDg00Rk3yKzg=
X-Gm-Gg: AZuq6aLCFA+oAOo53YJJQTjqMQ+UULJ+ntcTC1XQHjNt9m5/i7SWX5BT8+hMFxX5uce
	DHVxSiqIZs0oCUp91ql+QVEo5fCsr3RvN5aDPpTox3e5SChvE5ZS5qssLyYz4bXS71E06hadL2m
	9ORuJkrJySxGtjvSszIAdUw+Uj/khdLto0Otx2WAWTK3xOPoVwVRa4OJXc1zJyEP0augsEE3xrQ
	ylBkMqrc82aroqircRjDVrQSlsunc4jc2VUJSFQGAKvGBjDCG39tXeynMWJLGEK6WlD3QTEJ/na
	FFZDdSUFqqGxfNhxQWk8OHjz+jcffLTNhMr9qeI=
X-Received: by 2002:a05:600c:a010:b0:483:709e:f227 with SMTP id
 5b1f17b1804b1-483709ef2c0mr717625e9.31.1770917387264; Thu, 12 Feb 2026
 09:29:47 -0800 (PST)
MIME-Version: 1.0
References: <20260208215839.87595-1-nphamcs@gmail.com> <CAKEwX=OvuVPJzQsSQm8F+zsRgJFnbMmW2JMJbGebp=U8+jMRYA@mail.gmail.com>
 <13e3cada-60a3-4451-ab7e-16dfbab3c352@kernel.org>
In-Reply-To: <13e3cada-60a3-4451-ab7e-16dfbab3c352@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 12 Feb 2026 09:29:36 -0800
X-Gm-Features: AZwV_QhhzDWUucMWctDXYEld-DEFpbH6uyQvlM9NhhkkV4HCEsfeHDqKgPzh2sk
Message-ID: <CAKEwX=Pww3ZNw=VGZBa46NhKuvefRM7wnVuZy0aADoCoE1KSzA@mail.gmail.com>
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	hughd@google.com, yosry.ahmed@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	len.brown@intel.com, chengming.zhou@linux.dev, kasong@tencent.com, 
	chrisl@kernel.org, huang.ying.caritas@gmail.com, ryan.roberts@arm.com, 
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk, baohua@kernel.org, 
	bhe@redhat.com, osalvador@suse.de, lorenzo.stoakes@oracle.com, 
	christophe.leroy@csgroup.eu, pavel@kernel.org, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com, 
	joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	rafael@kernel.org, jannh@google.com, pfalcato@suse.de, 
	zhengqi.arch@bytedance.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3427CC000D
X-Stat-Signature: n8ou31ynjn7ugsjf4ktfjo1idchhp5ou
X-Rspam-User: 
X-HE-Tag: 1770917388-603325
X-HE-Meta: U2FsdGVkX18SpJUCuqbiu06DEqlyWPKcceN0S9Hbu6jW5lZtdY4YJFKcCxDlhwOq1ohEP2eAQ1iRcJMXj3vf7FrNbe2Qq0AKIWopSpgvHh8wzDNbdaKrBJEu0v0QLqPxTNDmECHpdbBtMlkgmQi5i268nSWBV3+RlIv+Vc9kXIQhrjB309TKPejVomafzfHANQWYsiIcWqvDNyNim3zKC+d/l3H5EjFBP2aVoFew10nFQM9ceQJfy9JJdCbJjTTrMyIc39f77mmCOCm2x1A3DKDRoaVCJ8cWppeLq2L9T5HSSp7rEj/VoWKmrUNKSxEqW1y3rI35InQwraXBq+e+eoyOMtv9niXMPyzAIykzq7Suo2K0n6NgZGfFqhWRjaXTO5iukTRVzk461iDDx2gTcv5WsUzsvNy5fd+gnMwwRJCzD2LDlexY3a2wilTqXtggetoMuZoTbVtFnYwN4ZBwkLZCxdubEXNBEp2IIZY/0hMC1Pl6rsNVdquzGQvMJnb2ZiA1BQS9Fa/6bGIjgfjCeYk0MHnYMSFyD0d+/r8md6Cl7W+y7bnVR5lshPW5Ifw2l/C7g3+5TIYxFkthGq3ETofftvo8csirFWpwVZEAhq9AEkMSo0VuDuD+sXoMcsc8hqzczWUFV0z0fxg1kcGTWdftc2nPIKIcLvClUTRMPG1CaPB5uJJjJ2/6IsdRtzbKUx8e71oU7tiNQ9dvfQ7EpkGEatOCQkEoNfTESZ8OIJy0VnbXSRtTXmulgTV+5rKToYU6HrWOyXAoU8pE3M/CFw+iFcEtjNrmILWOV22od+uDDpD4NKfwdM7vpVYvBXrLz+uqD73t7OjH/BhiRXBEhkalnSdQtReMWwSxcLJdYhTchJ1k2ogSyiSFWegQwBa5n9rBy2WcPIwq3yFHc+L2sNcnSwpDa88dVhC2ujEo1thuKUnQ2Wdt4GVTiobIjh8jSmSobgOFgG5005X1tiA
 25m3raRB
 zVpSZC28e7xsh63MSHbTVp6svJiR1O/AfNVT4aqYGLLTtFNwvKvPbZ+IDqAhLmeCsLuU0nYESYz1n2U5c6JdTc4wgf5dP3HfxyInL4cRhE+b5tBiK/+SKkMbUZiME/LdsXgja6TargbcZz1LM/u52A1QNyL/S7m1sMbPa8QwUXzc2f1g083rjnYAtljU4KI+WI7H5jFEFPXdaTFgFDtImo0xiNpys7BZzxKu6Kjuf+opBKBIpJQyyN2SjYQi5oQIe2l3LAOOHs9FSwzFlozDpeFE0Jt/U9eCs3OWPHjpy3YGxMxOepl0z+VAPt/jLOj48ayhKB6eyVJx3apZHv/d+9NZQ+RdjpLEhGylqKTSvD+Wx9x0SN78GGBo6dtqgcyyy6w+GSeF7rR18ha/snnMqdhOwtjWo7PymRin3CsmoSB0CShe09/9yemACfLlwkaGAQzhXOGs/0RKV5WPl9TihUrcasdudI5ng5CzMR2CBrwrauDpGE4/4llb4Qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 4:23=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>>
> Are you CCing all maintainers that get_maintainers.pl suggests you to cc?
>
> --
> Cheers,
>
> David

I hope so... did I miss someone? If so, my apologies - I manually add
them one at a time to be completely honest. The list is huge...

I'll probably use a script to convert that huge output next time into "--cc=
".

(Or are you suggesting I should not send it out to everyone? I can try
to trim the list, but tbh it touches areas that I'm not familiar with,
so I figure I should just cc everyone).

