Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71A1DFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCF516B0088; Mon, 27 Apr 2026 07:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6E56B008A; Mon, 27 Apr 2026 07:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96426B008C; Mon, 27 Apr 2026 07:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 961396B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:03:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EA0616014C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:03:12 +0000 (UTC)
X-FDA: 84704049024.15.027D9EB
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id 439E140009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:03:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ui5nvfCJ;
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777287790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDTOE0AeM4nDcsZ3wtt1ZPjecLOWz83LVoC2/26egb8=;
	b=I4zVbGDzBTP4aR/77IjUoCW4myzTFxAgGmx54NTu6B9mel9v9f07qMZgA6FwCkmAkFoJCi
	ZnzNzhq1Rbx3QTFc9KTaar1QfbjJ23WIbxb/A6BTnwZ9fDJvzgzUf/pWV3tdkCds+6p1UF
	p/26l0fJEqR9S3n8miiv3v3LGFe7rWM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ui5nvfCJ;
	spf=pass (imf27.hostedemail.com: domain of elver@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777287790; a=rsa-sha256;
	cv=pass;
	b=zkl72Pj+rLc7UGGtoJzhev/vosNg3hxRUnrZP/oN8z6ur6gJNV1xYgZsYxUPWHPydz11XD
	dtVkZF563YNEVXDBXj1uR86q65ASVkC60CMeTS3nuXeIsuezI5v7I1/nYv0Bi3KWjaYksk
	nwSHH4rE/D03dPzBV4ZmOC7a/GbtQg8=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-12dca45ca21so2698903c88.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:03:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777287789; cv=none;
        d=google.com; s=arc-20240605;
        b=PmxqXxtBHCzCLDJ3w+8kOrmhKR+JMUUjzeidZxN3aGclc9EzZaw9MDXvA1gh62B72q
         9gzYk9IqFj/pR969PsueUNDvf7XVJh8aKH1zzq+Sz4TYE2pUG1JHzH6B2WaB/hAm8eoX
         vIpAeyWF3TMxiswOOFnke2mB71+JcwFp7LhSZu8FL3BpNLXqU3+w0WFxjDcriT6mKEc6
         wMQVc0FRnOzaOLRDV8eLwB4Fq1E9VG0LCOnf0AzZTTew2sQhCMPuEEOacz0qmYj9Klrz
         L3TN1LVMYtgWewynnjASPEGHf/bki12I/uZCwL159eMCTzxbiFYpEmi/hFr577s3U9kR
         SESw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=hDTOE0AeM4nDcsZ3wtt1ZPjecLOWz83LVoC2/26egb8=;
        fh=dpaRF7l5KizxLVbtwD8DHPVD4qDxDit9gW9oJcNQpFs=;
        b=kECQkBDnJUfKtaZcQQq9M7kMvAbcWg2wJI2PzJyuicj/CTqnshZu5EeOxlriKeJe65
         Nk1tSbPV7hUOK0rQd+q80+E1pXl+VAXqwp5/fiz104ynK078/2Yjm/J2RHvfHtWS8JZ8
         yJi4+7dCcSgiuSwtbJeoajuVCFIk9LPbo+/Y1434PLAQqggyc8jK6eIA7Ds2wsROaqsq
         q9ofi1x8QsrRM35fUiS4fMYWrKm9fQHnYRz4ZQ4gHeXE7JCmkcKaoyVCLswDV/AiJ2co
         Ya7PHIp2wBh146hlWQrgereuP8HiArM8pKBU6tCvcHMafx/CLvZoiQBVVaKamZZaYdr9
         F6Vg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777287789; x=1777892589; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hDTOE0AeM4nDcsZ3wtt1ZPjecLOWz83LVoC2/26egb8=;
        b=Ui5nvfCJjm1ElqDs03mp/XKMkcdLEfnK7wX8Om8xrC5L6htczl5mq9BVxVY4gx20Us
         bc7LIiDtPhhjj9UgyQ/MYZjUuUN7og6y1OUPIXtAFp5O8fSdsiwJjtT2nOGm3TBo0xQG
         S2wSVWUnxxnm8HbAlL4qDroX0nKWFYo+DC9LtUhWZ1Om6xjzs9UWAo35n4i83dpiv1fW
         nuPYtmp4p5OUTCCpwNW/Ul31WKfSR4VCOQ6F9V1QRLg39bV71kAQTCDznBdfJgIQYMzH
         4waYcand2GJ8HCrFam+M9wbWiyiuw5ZhHaZ7CcBdgbnjc5hbt+YqPeF7ZoYRBz3QYZXN
         Y+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777287789; x=1777892589;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hDTOE0AeM4nDcsZ3wtt1ZPjecLOWz83LVoC2/26egb8=;
        b=CkTqWvWmdxnI6xnhDX1/xTJlFD3LEvONswWWmZaftyQAPjPRR99LHBohY1urAQiaxm
         erd0vDHr4GSN1pbdCzed3BDyiEZ37u8BqJy1DuvS9fuFgJU5dFS6uXL8CB92nfxyxJ/Q
         Ni/UDNfHyjyhZ6sZHX+wMtPNpu125tyZ+dwO+lD88yIyCGqVlO5RrQXKuANy2sffCFz8
         KBfXTlz/9EhM4z9FVSsPUDJ3A3pxpBkTT9BzLGhyGvl64eIWA+Ya4CmZjoSF0GoOu8wh
         3yhH+iH8YVHciHw1roOrIPiB9Fw2Ae0X44DSL7wtf5zl9uXg3wqVYf5bGNgBridfxBU2
         YtYQ==
X-Forwarded-Encrypted: i=1; AFNElJ85vDndA4MZjvjF+lhcPRqZeNsNKV/Ag242vtPotdCnt/Yv37f8laWSo8WFI0GXj87i67y94OYlZQ==@kvack.org
X-Gm-Message-State: AOJu0YxOMA8oxDQw2UbwtzyXGluFmeIx0b0ujVSD4C9WyjgjQniSI48n
	jKnse6ez1GLYUEYtHQ3FDeO6/Qea5v5s2qJH0KsyS+E111E4Qbd1j/Hu++UumoA2j9tFk46nvX9
	1JHO9FQA1ebt1tJOIFtN6CB0e4sL82ajZojnwOK4K
X-Gm-Gg: AeBDieviN07Wqhqj+XzHCGjJ8RB0KNEy/suJjSO2lABCUHButyPTanjPql0YAd1TcnO
	Vw/VALIpFzDc9GYiUprTM5QO43ETUhWndYQivEqAKrSSIJG8uBAKpM4rY8wG5E6ViZd4GFZS5PN
	G4oFkJ5HSVjt72O/tn0ELAX/Fu2lwZ4shkXrmP4c7NMg2ruyVAqDVh/MHKJjK64KPN23hyg6Nww
	iM5gzm8pG2v492Jv+wGDWYOu6dT7cteQHO0L2i0jlnWyaDYnHyUNA19Bm5+aBwcWbpaWhE2Ki8u
	dw5jHXWbruFmpk0SprhESKvyhrhqt6KYya8/yOI3z2mT4ik3AUbXfIUdUGo=
X-Received: by 2002:a05:7022:2213:b0:128:cf80:deea with SMTP id
 a92af1059eb24-12c73f697edmr20663248c88.1.1777287788342; Mon, 27 Apr 2026
 04:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260420114805.3572606-2-elver@google.com> <20260424065617.5de5751ec5a5c91910d45a28@linux-foundation.org>
In-Reply-To: <20260424065617.5de5751ec5a5c91910d45a28@linux-foundation.org>
From: Marco Elver <elver@google.com>
Date: Mon, 27 Apr 2026 13:02:30 +0200
X-Gm-Features: AVHnY4JKLU6q39dCKyB4plPncNdXg88yW_ofsZa5rRywUQJ7hms373eIegh-620
Message-ID: <CANpmjNPEUAQD5Nf7bnBwd4sQPT3Dn_QZy_Ae2nv3rkX0jK=z-g@mail.gmail.com>
Subject: Re: [PATCH] vmalloc: fix buffer overflow in vrealloc_node_align()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	Vitaly Wool <vitaly.wool@konsulko.se>, stable@vger.kernel.org, 
	"Harry Yoo (Oracle)" <harry@kernel.org>, Roman Gushchin <kfree@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 439E140009
X-Stat-Signature: u3eikbdeheipw9npp1y3zcxsure6t6ym
X-HE-Tag: 1777287790-792691
X-HE-Meta: U2FsdGVkX1/tlaCE09xVheAfAfwBq88nXin8Q5FXhTLDxSqoyquOBpIvZPQg33N5EKBuOM/ehTk+3/1fm0GgvBEjKFFhitwVvsp28QEy7eMpqTmwiUmoZ5Sy1RM4VIOot6are5OON74aeNxoBE33bkryr055U252yn6bdFShsvZJm9FOAB+AH3/AAfL9/TNmqk6yLdhEBsnSL728zODLwynTWofv0Wrn5LdMANC5a5LWNLxIGa94WGPmR4pK02lYgVzDsZa7nNr4ucLRzPdnKslR5rZRdLHonv/5q32g+SXE8hydEvqQUp7Oohq6H4SfYVSjHQNDeOAxhh85IFK8YH+15Fept4e+bl8hH3Id3XQNJdF95Eunzp8W/O3mDrc/EFItAatG/71RchWv2r4fySEgkfnzs6gFoqVgJExTU5uKClUavb14bd3lFCDUPwnLTNpmX9wzDtSL972a3eyixHQXhlzNiwvRaws3Y1OB6aPkMdVszo+Uec2vQb60maOEUGmhLZF3TYae2cXTpJv65RtzUtRdVApCLjsyX3CGLkhzX20RJyQ5kSgg9Cs4rrvZ6XHVBH3AQJX2xg+hml3Tg0XghyQXKMAnSztbGWWScdLIY3VeJbea4y88QVFC3clIhRLrndfc0OKnCPSZEA4fZAbVwc2Ou/dsw4/qkGKOzIXZPBBMcMtCg4USzS6Osn1G46owtK7HuXHVK0u7tCQoV01wCVxvfvphf/GcTc/l+zNhv5SAE+/3Lup350sZW6VNiW9kUe8Ov6IWfjNdYXoTLcfXO4hPJbyzGaadS/gFWmo0PPetqCcyD3prH09GY9xw2c9kgtmBSbf0zO2H1JsCs2U/8NNx2l9k+qp9ytk7BsbU1Paue8HvfWvNkby03HaIx4YRlxPlEzZKeSDuVSt9iFDwF8A62tuxzCN9oIThITvqqOXLp/o3WQJzWx4jZ4cdVllf1ni6jksKDdVRD3x
 TBctqIhl
 cNupJ0walYEwZL5x025z3hl9ffYelg7JuwgM7Zn3KcD2HHEysxH2rMNH74vNPG8pk/yhLlhceEnFZhsjvuW2ucd4ugQBVVtDRwKbCJxdHvBMmKfo6vjpwoxIcdg20Mi0mYqfuqEISXk8o/ugOr4H8+O5RfH/9N/gl/HqinZ5pEosTV5OWXGkKvN8LT3lUHbhY5xmO+SxbDgb0QyKFhGM0varDy2XUO3teIHx0OI0WSdSHzIulaQK+hnt+TRXVanuHBISdj/v1Gvcd+JoWdaIy56dTJ7mmYPtaH4skUbfR5M4y7yXYGtFBMEIO74K4nXvJKI+ilM6tOLkyyLqYHUL4o2QfDz8Uq6x37vAiZXBgOg+XDtU+qygc8t1xeWziohoS74rn+/Bmt9RLvK3TNS6vZgr3+Vkhp8aqvHaasZaJg1bte7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 at 15:56, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Mon, 20 Apr 2026 13:47:26 +0200 Marco Elver <elver@google.com> wrote:
>
> > Commit 4c5d3365882d ("mm/vmalloc: allow to set node and align in
> > vrealloc") added the ability to force a new allocation if the current
> > pointer is on the wrong NUMA node, or if an alignment constraint is not
> > met, even if the user is shrinking the allocation.
> >
> > On this path (need_realloc), the code allocates a new object of 'size'
> > bytes and then memcpy()s 'old_size' bytes into it. If the request is to
> > shrink the object (size < old_size), this results in an out-of-bounds
> > write on the new buffer.
> >
> > Fix this by bounding the copy length by the new allocation size.
>
> AI review is asking questions about the nearby code:
>         https://sashiko.dev/#/patchset/20260420114805.3572606-2-elver@google.com

There's kernel-doc wording for this function:

* If __GFP_ZERO logic is requested, callers must ensure that, starting with the
* initial memory allocation, every subsequent call to this API for the same
* memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
* __GFP_ZERO is not fully honored by this API.

So while Sashiko is technically right, the API contract says this is
by design. Sashiko should ingest available kernel-doc API contracts if
available.

