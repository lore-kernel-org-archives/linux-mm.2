Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C5ADD2169D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F095F6B00A3; Thu,  4 Dec 2025 10:29:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1056B00D7; Thu,  4 Dec 2025 10:29:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6A46B00D8; Thu,  4 Dec 2025 10:29:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB8A86B00A3
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:29:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7BCE956FBE
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:29:01 +0000 (UTC)
X-FDA: 84182171682.03.60723DD
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7D8AAC0011
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:28:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CEjB2Vkj;
	spf=pass (imf10.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764862139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MI5aTy+R1SqmI1yzGL1uAuu8o2FFOs1gD1ZnAhB164=;
	b=vIprXxm1QGLTFjkIBg9iMtcKjqcib9xA73BvUzC8q/lnqsPaMFo3CClpxds6KSKQvHWzQk
	Xh5+sBDeGpt2I7jmiY3ezmX61DTx0IBlgiSFGum2Kh9g+gsvzkJjXyDEZ89+NzKkA9LH3i
	89f1UCTEYPtDM7P76Cf9b8ZaTtg1PF0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764862139; a=rsa-sha256;
	cv=none;
	b=kn85v3AQclfcK8Y8XzAfPWgBkXG50hCKr9O7IJugW//0CVY3w/iVsCBJLJJSlnM2MgBvuQ
	KPDUDFmnZ9LUjGcm/SUwz0ieruuqdm74ZzkVR4FIbtDPJXyZMt5xG4x5wMSSUTXskXHYiL
	If1sfORSIhUUOVH5yTDKfdZI/pnfh7M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CEjB2Vkj;
	spf=pass (imf10.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b7633027cb2so176113566b.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764862138; x=1765466938; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1MI5aTy+R1SqmI1yzGL1uAuu8o2FFOs1gD1ZnAhB164=;
        b=CEjB2VkjEAAogIhskOW89GBZi2kZBNH/7FNZveqJaGvRgVui6maGKzP37gXtLMggKY
         omth4pVqtZ3+THVnPCa/mhtRVktPOR5BsJqizRPpRyXdLkiGUsUCpN7z9hjiu25WHr9i
         dljzO8nK/Z8c7cBcFmpWd9OAvsGlTiyckXWzZqVC5MYd4x+tHkYucmQB08NJ5dAgCNa4
         7QgeMU070ABJfrFtnAZ1jFij3/04j53qKo+MowIH3GBKToV99VeF0oMyvMod+LTHX7J/
         w3qJPlIE6XO9I6vfdRT343uPqFrpdPwrfPUrp4lZ0bEwnNzZf7+fA6YdtbQrS7UzX1of
         mLlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862138; x=1765466938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1MI5aTy+R1SqmI1yzGL1uAuu8o2FFOs1gD1ZnAhB164=;
        b=aZ0nTHbG9jzFYU/IZCmrrUsBIXK6aRNaFvENRT5vfKZUVHQ2IrVksfhSunn635cGDK
         jvEbC4qqJwADoGzPNvy0Y1bVr9NMOIjd0rSVI3GWhGsQLYWnoS2gNGVibjBFsxRUb8G/
         3bcrOGsu9JAZgBCCQBBhtwNye4kcw/vV0555z9VbF855vvseog81BLoDQlK0ooUEfDzj
         VJMxouP6zvUgDHAcnmP7Jom+zwpFzUP1fA1fsqD7lLhRDimiyy4wp5iQS12NHkRRo621
         r0vw91aLEkhtRLEgzYyyeMlaucCS+jv40ttOmizKpetlPOdTigRu0hvnL5MwzEGH6pPo
         pJwA==
X-Forwarded-Encrypted: i=1; AJvYcCWjB1zGE4zI6ANgb7ry1tcs7yNv8Byry+VYDmf8SKyB611US9xT1+FDx2/3bA8Z48hO99vi7JYKKQ==@kvack.org
X-Gm-Message-State: AOJu0YzQywZ+eF43iubCMo7hp8XO0zyLFReqKbNL6YGtyFzpFmE8n7bh
	SfAS3EhNIeq+4S+a/E/0i4Vi56Asa9T+l2Bi0uJT+Q/hFgIobf64EkuoyZ1sIqfXaZF7J/EXW75
	jzHj5TWWAJVpbLRojYEs/btAIe9eaLAc=
X-Gm-Gg: ASbGncslriRW8iN9ys+iZtLGrqjHUX1ATZcCUKV/gwhJLbLKnQx2dAWZxD9CR/Y2On3
	pTuRO4KQI0j4JRXzyyfpPtNkfxgbBr5A2gWmgF8cHKmN9IpyzIBLj5qNxzRGb0GTx01XkQa8Y/q
	0iFnscXgBdyLY9jJoA8qJAuiTqrifAfBdkz8KQpraX1LIvIXkOMS5wcfOTcivq/V9NhWxJu3lxC
	t2rdv1wzySfOP+IFA5c8Iroi9h1KEo7IwdP70LkkFi+kCaVNLu+WOaDUdbnRL1xoS4w+uYbIXxD
	llNYgepv5HV9EG6IFL+2l85EbAWeiCA+TZTw40y5DSNrP7Qg1xuI/jz02NdS5edMFuV+oAKlkIV
	hc6+ofQ==
X-Google-Smtp-Source: AGHT+IH6eUYV4d+UfitIHpvZN9b37gSPLRdlm7zTBgPDJFCsNGp7+lPPZkPWyRsTwe+8SSCyA0Xqdo2giH7fy6Ln9N4=
X-Received: by 2002:a17:907:7b85:b0:b73:8792:c3ca with SMTP id
 a640c23a62f3a-b79dc51af8cmr691284766b.32.1764862137818; Thu, 04 Dec 2025
 07:28:57 -0800 (PST)
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
In-Reply-To: <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 4 Dec 2025 17:28:21 +0200
X-Gm-Features: AWmQ_bneRNOGjAW4jDt5halz319V6V9HvLuc9jLOtFFaLshPIC4KOutQs5--etw
Message-ID: <CAHp75VfgETRHgGkJdVezraFDogtB-KQT1UDWn2RyWeNZ6hCU=A@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: glider@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7D8AAC0011
X-Stat-Signature: ritx9n5g44mej394bsartqwizaih4kqb
X-Rspam-User: 
X-HE-Tag: 1764862139-473675
X-HE-Meta: U2FsdGVkX1/plYXvFKCrOJympb5hoiFL8duP4eSGYdLo66kjO6lHivCvtfDPJyhX89Sluoi+mOxBZJ2DPqKzwDvSasTuxR4AZsbYJxSZStM7ldaDC2Oqdt4rY6Oouy6YiBpWJkgf2vfceSZjrb8/lsmuC5r7S0QpyqfbmR7xKKrj4nefFn64yRtD4HcO+KyJ6MkiEDAsW/5fiO2zqboiIwMs+NDazsNkSGH4LM1jgtujtGYAhkRwI9pV0LMwmgvso0aqzsI7XDvISZVhtaGhiU+HmCNKyvY7OixnL+QYYJgQhLMeT/wWZXy5dBq4ynMNVJi9gHoVC9gKa/Ny4chtKS08Y4xxN8FSRrD2MG2fhZQAywXwiyvEk2VIo0A7kTugmmtkBAlBQ75l+reLys4CCohTrOQ7KtuvTN1Lm5V0In5KFaPgY/437RxoH2pRNHILS6GITj2ncicZ/xNXb5YUXVXbf4pNXacefz8dACTEcTlB8eV80VdXXKASYVkS15XSPhUbn3uLF8Z6dP2u+DRDKYJqz0iTcS0Kgsliywhfti++oXK07AW7+OYXZvJ5+8z0g9H5gwhBc5NM3tg8K09EJqv+V4qm0IoeFbgO1d7U2hhPHbx34ESl/RYY874uPp/RejGFh1hYVk9qBzYZkVHbtZxAtOkkXHf8ImMC8V6UfSlHTo0qPRT8qNZ+0mmzmBS+SJCWvy5YSpqVYvPpwV7QVixy2rTa/+kN9b+9FxKmJBw+spOXSSgmvt+QRAj4RvaVTF3ArxnUAXsmCQMz3Z0AnaLgEMjdpQbAENI+5DDt3fUpLmY2G64C3sAEDgx8LKgRt6MLprQTgnn0KR5BMjGb9EST6CmYwrcrP5BedqqoFKc6jPha6haXZLCDcUT6rpibKP+LdIsZCUdebAGClxrvvMedAp2WUFbTSaanF5OQBvrR7ecKS+q3mIqCCPmGzrqj2B5Rs0VUCJoC313moyy
 9g0+YIet
 1VGRFGjqGvuF1NNyfy4r9N/Hj9kVhIIuRiLlnr6cZEUU3yRwzOnXxYXoQ/3Nvg8XPRB3UHPeUZhcKdAUUtx6ScQ/OnX3CNGEZgcmdI6F6BN4BowZNF9YWZETtc9JTPtajgLYquwRX0zzkGrAwv2qv1IxoOll6QeHnRO8BXAidIvslBNPGvflSrCQRwYttO0b+crm0haMEoZkBeYBDCNsaSu7/WiD6FWqlgPqxATEoTxS3O5OskQokTdjA171iJDY4JNXaMvz2h/YfsZxh1VYXqk2sWwQSNv6UH2ObL7ycPYYI0OmYBJcBQw96k8k7G73G99ewsB1Ron5GKga7rWQRlC2/580cuoPTo6ulPnWYkFeGjdxRP6Mhzz84t306oA+p5l4eCiH1wFU1sCf4Lp7EwMgyqD+FFVq+qcNz466EtGaNPuko6WWy+6ToYMQ9sVsNFtj59Ie/6/a2MmTp3XzKzXl5ErurulgcFkHVK8B4DNVdaI/DzlQNnADFUPGo5j+QoiqvauaacTMi8413HuvON9EHd/CiN02a6iQAgbcVD2G2CHA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 5:26=E2=80=AFPM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Thu, Dec 4, 2025 at 4:13=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gma=
il.com> wrote:

> > From: Ethan Graham <ethangraham@google.com>

OK, this bounces. Please update the series to make sure you have no
dead addresses in it.

--=20
With Best Regards,
Andy Shevchenko

