Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1851D39418
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 12:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268FD6B0089; Thu,  2 Apr 2026 08:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2806B008A; Thu,  2 Apr 2026 08:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0935B6B008C; Thu,  2 Apr 2026 08:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E741D6B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:11:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18D921B83ED
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:11:21 +0000 (UTC)
X-FDA: 84613500762.29.60CEB5B
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2C75880013
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:11:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=heoeK0lD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of davidhildenbrand@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=davidhildenbrand@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775131879; a=rsa-sha256;
	cv=none;
	b=g0rvbO1zd7RTzdJSuMA+TRWZEhak6OS+k6jEF18BoxPc8D9Q2qWr+4QF54TiYlrAS/7++K
	bUnB4BiVJR6DgOzmoX0yZHRlzsLYu6FtNigu+PPeEmWRFFZdA9KKhl8q+IeTWZ9bTmKaxc
	qiKQx2chxDGRECbAU+MpKQncCG+sbXs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=heoeK0lD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of davidhildenbrand@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=davidhildenbrand@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775131879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=k4hZG7y9nhhpMB94WMMqADvRYY9jN17jXDR7WBkRebk=;
	b=R01d/EKCtkrXfNjVa/qF23/udoDzsLfeDwfFbg0b9ch/lgMxa1EMUXnjo/ewQPrmQcnJaP
	eotWT0Ri4Yj3pHZOTZIyBtCwAigB6I0Loxz6kNaDddssZy0xiyu3D4tywLluqQ5m5SAeBV
	LuvL4JUrVKQgX6tok1LjWuAR4tpW6AY=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4887ca8e529so5812175e9.0
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 05:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775131877; x=1775736677; darn=kvack.org;
        h=content-transfer-encoding:to:autocrypt:subject:content-language
         :from:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=k4hZG7y9nhhpMB94WMMqADvRYY9jN17jXDR7WBkRebk=;
        b=heoeK0lDbmQLWtfguEcsw+100ojcOkVT4QydkoLh4DU/z+yVvzVwbj0AQ7IaM5Ii7N
         COTZmZG1exXng6hBtZY5qlCgqwbrbW/brxG0VOWXHC8xWLH1Y1ouuNfcbGtvm3yYD4My
         zWmCAtXublwGcouZp6A7xgw60+rrpNRJHBChHI8Qn1ctoaYi6jYhVVs5Vli37ptet76Y
         LSxeSczvEzB/PDW8EqbRfNiHjrtNESDS9Tw4RIgU8B+f9O6qkzsKCZd8aRYRq224hFuy
         AibJ5qfsHIE6cnJIx49pFVy7wY1I7jZyQhfjA9sAt/zkljS1KJykXdiiSgDmcvfxS2l3
         nvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775131877; x=1775736677;
        h=content-transfer-encoding:to:autocrypt:subject:content-language
         :from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k4hZG7y9nhhpMB94WMMqADvRYY9jN17jXDR7WBkRebk=;
        b=p8DxZOZG826NjNoV92bxExs0oE7QI9cqAklbLoK27AAPjHsOLehdCEr2+ctYT82sna
         0Ka2tJOlejHOTRD6z+aVx5CGPR6xW9uI4luG+un7kmzhu43UpI7Er0ch7Gt8s35HSXWv
         dH+oQuKJHgT6bXryY/2abY+grOFkkuqsTZxqqxLJ9J+6z/DUuOIYzsVWvrHr2ysKafVy
         cqR1iorAQcG4nclesi/WMC90cOPYP1TTUkvqt8UMGlSCToqfk3fbqfL6y/W56c/5iPDJ
         pT1s3z3HdHW1rJ+osOHscZkvjaQAOyoS6uUeoEIIry97Rye8BMZxP0ha3Ms+/LrB3s3H
         60RA==
X-Forwarded-Encrypted: i=1; AJvYcCXTdhDnasVC4dPJtEjDYl9mhpln+mI+6WC5ZIFB3MWTwja1YpI6VW4KRKq3e3m9CX3zm8SkZ22dUw==@kvack.org
X-Gm-Message-State: AOJu0YyWSlBToxlDfZaAMnRK0DJjiaqptE9SmpSHRRfLuotf0JlrdCSz
	xEjs1vXSl+SN3rHuU5xaVtlc+u27LSpD1JH4s/yZvBkHYCGhfm8ivMXE
X-Gm-Gg: ATEYQzwN5CezLKTjuhu+5cHJqXUXiGFQVKkhdS5ch9riKJfcMDfjjj2BUlKQi1t/jp+
	5ScDH5acR0iRwFS/y0XpaVa78aIY96NmDmf7I++OJhegkHBQXZo+vCRH/o7PKdIe2c8ooh61uoh
	+D/WKaCyePCHGHO0SXsAattSUOZo2vfwM9IU6U15VPeZo2gaWHEY4/CTRKazAyeztTOI0j6aQrY
	jwPRUG0393i5/84zAzVWZmimsPw6WUWE9LPe4QJ3DsOuYwwbYdw31up39xy7RW8iN9sTlBwG+3M
	SNZPOZr1jIDhFY8ljoHI/IDuJEm0eQwn87bAR6mMQnvUMtonpzEDBwVQaM4rTa4btjOYmRu9DK7
	f3EBC3Avb7GgM8Srd46rWUUShUhVYweST10TSuj9MghUZL4PNrjgg2JMpqxYKtLkBjO0fD8sSME
	D9b8jfJahiNwuAKRvg8SHOO5rnjYIoagey/Pm3UnYALj8FgWA6DBlQYxYk0ZrySj0ppnNZrt6sQ
	SHUloIdOPuf0fakTvLWWIPKwt+0zu+gnIFiAmWrAVRu7fFcLIFN+Ua48rsasuVrcwfWFbbUoUQb
X-Received: by 2002:a05:600c:3496:b0:486:fbc4:8fe2 with SMTP id 5b1f17b1804b1-4888e0e47damr33863715e9.15.1775131876870;
        Thu, 02 Apr 2026 05:11:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:4f00:540e:67e6:b14f:9ac5? (p200300d82f4f4f00540e67e6b14f9ac5.dip0.t-ipconnect.de. [2003:d8:2f4f:4f00:540e:67e6:b14f:9ac5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887c884b8asm62838455e9.15.2026.04.02.05.11.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Apr 2026 05:11:16 -0700 (PDT)
Message-ID: <39aade54-b81f-4fa4-abcd-615885ca131d@gmail.com>
Date: Thu, 2 Apr 2026 14:11:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <davidhildenbrand@gmail.com>
Content-Language: en-US
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2026-04-02
Autocrypt: addr=davidhildenbrand@gmail.com; keydata=
 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
 /Xn6oe5jmKiMLPx9rQ==
To: KVM <kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2C75880013
X-Stat-Signature: s9a6p6b3kaf93nu67k16swx39mjsikmr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775131878-740521
X-HE-Meta: U2FsdGVkX1/skFE89vkftPhMu5FFS7ko/mO8qhaVTKjl5BzRQ65MdVBIKHBZEiA2hWyY0sXs1W2YlPgA93eMXxMP5Kqn57MBJ//iUip2ePzJ2YOuIDaILoDvLCTmBNaJA5vWCjc4YY6g3t4AAzm3I0U5pGuRi6Pr8yHuCl6RoxVUT3fkjQ2EiwmfqvFmBFIGX3EkyVr9T5xKYB5Kl04M9CEBQXlDlrC1FSfqvIC+W1DGdYpf3nJtH4u67vuYxpKy4wpCc7kV6PVF4Eu+vyE24Oj5S3AOqo8cfckZYQzpNye+OFdJUdxsBcjZBp3ToF2ICFWkZTgVdDSlU77/orfMvjtlPDsTfkQFpc3meYHBl8YyHtQk72MMK7AW57+ec4daiCaW1Z8POceThDKG/a8Vzx9J6bSG8FINr9W4CsBk4cXPc9BhZrxpOJoDGOJa8kAx6BtUue66CcW8Wyeo6hfrq8bB5k3DPPgSS2vIjsW88UI8SAGK9f5aJzvDEKHhKpNESRwJ9p/2abs1zgo8paUgu7D13YTh+lQFZQ/zSIx1D8F4oGx4uldh8n7+eKzBvGmFG04SLWkla4LuqRJF1kVZZo4aPjklEjaCnqgeAAPBhVIzL5P+Deb3FlBwscm24aYmbcAZOmWFKgNVK76Ti/DSR6mfsNVcWbZprhe3nkSo9sCIKEeNyv9BJqixcaVor82qyO1FSJzIWLuv9DkDz4TEF6sA/vQi1IGAtrHB31tfCoX3hcnxJz8xW9MHwevjyKwYY6KI7ZxYJWrwIqqAyz5/Q86p2a+Dpb0MyHioQ7/+v3NsqXAxk2U1Nm0nhlc1Qz7TeD/o2V51beQdPslZ1mFYwHdkcw31eZf1QNJVRE/YFg8o3ydlRxeCXvx/Bxq3t6LYZvv4qZNniNo1PcBsWmZfqM3tvjDJ+OPY37JxHuh8kkFV/jG8LaoDUaMGyNJstzwJVLYtWqBh7waEUeGY8/R
 x6ajWE3+
 MqDioJsNH2b+1jgzE7tty51uOa1we58uN/C9qg3MN/+5xlXqPNqPIYeaaLzecPSO3p0GR8dyac+maiiseMuixqeYGFHdh5dkY+2fZ/NnHuSso1QHARWtNoe9UmX6DDCLz4oYO849bRZiHbW1dFp1A8mHbBRO3nnc2AzB6Ru4hLUAzeI/ZlL0wac776VxG2BMGH3MOheulEFzM+2OObeogcfkS6n/1jrMSoMRYeI8HruNZ2UTZ9MnDPZktSSQbrM7HCtDdijR7CGMnb8Lob0kTMFw/DonuayDMvW29hsGokFayIuNPXeUQe3iiBqnUTQZmyRiSomwGUfMeJkloA//cDPdyIAYAhq1/Fc0RXwG6vA0bOjeCrejbNWp6YaVAxDrJwQGE7Kv9tj/DZthKQ47JvhTtO4D2HCXcX+CJvcBXneLq37ESXDBhnrKwaPW9fq2ojLMJo2teFQmt2lMX+hHFrbAURAHIgTDwAZzKfnu1Tubz3wskYbjpfBixRK3PRZDT6g+/smBzuqxBOTursPZ+2EisrirPmp6QIGO6xdGHpq4bFTPqJf+dKFvitDe0c3lPo36OGDnyTVD5nBNV27X3JfG3Z5PJyGvzPUt0muavtxNvu4A0hl0fk17aBxnr9uggxm5MZnxGRsMCEs6n2Arc3NY9oTuN1E1+nItQJIBSq7N4Tubpnuzaj+D3usYYY0W8XSe6XMA6adTyLg4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Late reminder :)

Our next guest_memfd upstream call is scheduled for today, Thursday,
2026-04-02 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
or Ackerley a mail.

There is not a lot on the agenda: interaction with guest_memfd and
VM_DONTDUMP. So let's see what else comes up!

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers,

David


