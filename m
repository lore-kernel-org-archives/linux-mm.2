Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3CD9C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49066B00CC; Mon, 21 Sep 2026 09:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA9D6B00CF; Mon, 21 Sep 2026 09:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F206B00D1; Mon, 21 Sep 2026 09:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE626B00CC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:28:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 850791A019A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:28:12 +0000 (UTC)
X-FDA: 85237848024.07.1521EB8
Received: from mail-ed2-f34.google.com (mail-ed2-f34.google.com [74.125.228.98])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8CB6E180009
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:28:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fybomgpD;
	spf=pass (imf16.hostedemail.com: domain of nsd.project.dev@gmail.com designates 74.125.228.98 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789997290;
	b=saE9mbsq0+NSZnOWjv4fIthVyFwjpPwdvgNN+U9SRUHKnYv8xYrXp8DkJ3sD9njlPt8pR9
	ecwi+N7kPTlWMZ861uA5AGD52cf6RyPMkb3Sga9WOd7S6lfp+G1SFbKreQUKnc8yljBs9b
	pI+yvoazZ9InnA8jGQm96JIFSz38AwE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fybomgpD;
	spf=pass (imf16.hostedemail.com: domain of nsd.project.dev@gmail.com designates 74.125.228.98 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789997290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ayinjUi8Pgp9G+S1LnRNG4EOwgo3RpV/l+nq7MHooFw=;
	b=HStNYFXDUA9unr907Qs1FQL4zJbpc/jZv1SOftp+DkyTrDL97WgNYyoV1myvRVQ/M7ao01
	RTqhi5W68d3Zbcx3II0hMWuikruzlI1HBkdFkSyfALMpKtclGlczfVh427HJYh3/hq10EP
	uVgLte/wiaeprWe+S/z/BWwh109LZNc=
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6a9dfe4dfc0so4325500a12.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:28:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789997289; cv=none;
        d=google.com; s=arc-20260327;
        b=gNfQb6fNO0ipyIzwy2Rv3yOjchkWH9b8AeYmQ9ce4S+TbG4qP0X9V+u6wRmyc57ihz
         f4a1qvq7afq9PNxUYlprbGVjs5T5dJRYZyR1nQTdbbOBV/ZT1VpszF7Hx3RPd/43MGSu
         Xd9cyK6mw7hTY+Wv+KgQe4eTzUqYiBO7+Hx4QB21IBMmUtOTN9u2mESNnZYfNTeukEcJ
         gKC3td0YLarACSrvoEpo4PoulFCBqHaSsFfj70bXq4hTrjnw5UbSuyudBRRZhRz/tp4D
         1o2vQae/+Cq2sOJCxzmbk5BXCxgWKPwlCzJOWP2VB6Z/kLDe6H+4rVoSCwmHm+jiLcEY
         +mYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:dkim-signature;
        bh=ayinjUi8Pgp9G+S1LnRNG4EOwgo3RpV/l+nq7MHooFw=;
        fh=ess4YNZGnb0jiIlxWlNdBG3yxs32yO7SDq1qleHt0Uw=;
        b=LRamv9ib+pelC3BEpRKwX1lOv64sM5jpOaNxJ17LDI9JQuvAzmb1f8UPP97aI3nBik
         4MlzFcbZM8HE1VcyFoAYaOJrCorli9KUfONKXIZGfGUc6Cjz5xjA9jsg42qkIiGE6Ngf
         YmH58eQOm5Jq7iLtq+mNhCKc5mzvetuTukD1jxrryMPT6E2PjoLdB0fA+uiJH/Yz//wQ
         WEtKbHSKR1/hdzx1yg9vvL/NBKEewtJF7ajhVUHzlY5GCzLj8YjJ4ZKC/PZCOfxX+6+2
         L8X1A2TI7bXZoqS/IWLCh5Z0FyvckYKr3v4lAm3aSiqKwVrpMwnR1uoEbKjR714RULy7
         z9vg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997289; x=1790602089; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ayinjUi8Pgp9G+S1LnRNG4EOwgo3RpV/l+nq7MHooFw=;
        b=fybomgpDT36b/Yqy+d+an2akbgFX5vgdk1kiAJ1LhwPhIff7rXNI37UlQh0OPPnu73
         SR14lifbtmATACVy+Phid270yQueu86UBjqhzblN0hgdDjg9nxOHtCJ5OlEZr13Rho3M
         w0NMFfey4gLh6nraZn/1uvV8Q0wJSz4HsvSQe5rKaTkv54WKven5HxkfOO7XdjPvIL+g
         M4mZyiIZa23wLskHItb5Zhzz8k/thMn7+WpNHIggmVVMc/kauhBn3wRluKRotjxNecfd
         PBwt4Eg/KqUSIfa/pOgBM5EcXUl7XWm4eBhGWhQ23zFEv0Kl2O/J/pMqxT79YmmJcUe/
         MCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997289; x=1790602089;
        h=content-type:cc:to:subject:message-id:date:from:references
         :in-reply-to:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ayinjUi8Pgp9G+S1LnRNG4EOwgo3RpV/l+nq7MHooFw=;
        b=EEfsXCHQu02bESZ6tVUHdgHTA0zrRlFhy5L+gryUy+UBWnVCImfu34yqzBxdBJG0hN
         RQ//drl7lvAKxCNRoJyIcpOJ2qlJkRDf9lmdqJrMc0IrKHFYxEeqgn97P5oSi1mavyPz
         csh2D4on9F0TehcVDhHlkYID2sqMt9rsQJe32jRR6GPoj5ou+D7TGcakTBikgGTKxxq6
         iwuycJAzpKRvsXXra1sPV9XZ84L31mlWTuHQ6vIqBWiW839nEgVwsWHKoatyEwUU+uDG
         JbMJz2H3JNZi8YLaiQ/tgy3HYFlSjmd3Bk6jNalGcDnV/nt95F0tpuDFEm/9d3W8zu/9
         7CKg==
X-Forwarded-Encrypted: i=1; AKwUvBw8bw4WmL3Oe1tnNE3L1X1qM9EUKCt1JwyNw3VqARlLxGYALKWL9WtXMSxUNKy5iZqD4b+zc+2NBA==@kvack.org
X-Gm-Message-State: AFuF++nCz6mU6rEInFgu4NnW29vtO/qDObQjgrpRDNbYLJIBqsrO5AgA
	EhvME680ChOqbB44vnL3GwG3P+onpg79QkYqlBn4CHNAQ0VhgkRUpc8r370XbH3tA7ZxqZv2qZs
	+Atqb85x/BtNoq0seqisC1zzF5LBSPrk=
X-Gm-Gg: AYBFou1ZZpqn4Qfe6N4JfsptmsRw7rYXF8fcvVnnn0oDgIfaApMFfyzJAcU6ZKKKEkL
	mnorRfzPwWsfPR8lFO4wZpDgHjochpQDe87+23+y4X5dcmYPBnsB/EFBZGBdWGnUNhWYZUZzrLj
	ErYD0acOSC2VOWDx9FYXALCZONV6D7msu2olX6JQegc/uwq9+ot0n3kpOBsoNoBXG8cSWMe+DlE
	BMIHlKxc6i0H94LPJNTqIRhkTHKbupbX8Emn3jXMMfy2/+KrDX89ph/OtB6hNea3J4mCC7iwRMG
	WeL6r0TrMFEKnqBj2iXc/ciINVA9GThVFsYZ64A80FB3OBgu6K0Lm7uceg==
MIME-Version: 1.0
X-Received: by 2002:a05:6402:324d:b0:6aa:4d8d:a08b with SMTP id
 4fb4d7f45d1cf-6aa5316a711mr6298513a12.14.1789997288686; Mon, 21 Sep 2026
 06:28:08 -0700 (PDT)
Received: from 292895732794 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 21 Sep 2026 06:28:08 -0700
Received: from 292895732794 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 21 Sep 2026 06:28:08 -0700
In-Reply-To: <<arEkgM15qewERAOJ@pedro-suse.tail5790ac.ts.net>>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
 <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com>
 <anlByPDZmvEhWeXI@casper.infradead.org> <ffcij36vnozf3rginqd2opd2dwqyki7xhtdo4veuty734hhgba@utjav2k263o6>
 <nsd.1787001235.35928@mail.gmail.com> <w7vte4itudtkw2yf4vbmuofiumfffmp2y52dpu2bqvqtdgjvpd@5femyiozss3e>
 <CAFLp9PGkVYZcQT5qAx-RKFOF-urZ92m417zpAeF7ZQempbS1HQ@mail.gmail.com> <arEkgM15qewERAOJ@pedro-suse.tail5790ac.ts.net>
From: =?UTF-8?B?YXloYW4gYXlkxLFu?= <nsd.project.dev@gmail.com>
Date: Mon, 21 Sep 2026 06:28:08 -0700
X-Gm-Features: AcwNN1WBEO2eUe_0S1kQSTFGaynIVHRfEIP-ijo60mrzoXWfLkGAo2lMMObTUKE
Message-ID: <CAFLp9PGgfLJtqeSaTqrG0jcFAu4stP0og4Txy=ewCw0ZxFdCMQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Neural Storage Driver - learning page cache prefetcher
To: Pedro Falcato <pfalcato@suse.de>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8CB6E180009
X-Stat-Signature: 9e3uagro4k34u94pzwimi46zkxksdhmm
X-HE-Tag: 1789997290-583793
X-HE-Meta: U2FsdGVkX1/VeZmjLoJOGZX9eUeSqEKK7zkQDp4V7upbzya49rcj3AU4sEXsgGq+xONisc3+qtOKRBwKkFko1s0m4xW8MtTBzDoqt+qlDQR6aoivOULJCUUXXIBsN/n7SIQGvyPUFDI4XVTekhlF2KLjgOE5KVt1HLM91gDApafSd9ljan1WOJm+a3wL97n7FNwUXukiYbCqGbYbndpKTQUsiraRDTtqot1gvMBKh33LFlaOlFVehADNbelJXq5+0tDa/wUBj8nHoMbAOlLTQ/j97J1Z+Jb58mymKRl3nFKnKQXey8NfXb1Oi0SLYkQM8EGaBetLpKLMF/vNAJ6Y830G8HhV5bSwZjiGSjf8mW4CO/ny5noSyBKgQ5nFewJprzgx9sY8oC1jLgrsCeYNPEuBY3JrA3ocxLxVbWDFh85Js7PcJEceYDx0nRDYcFpbMQiVFipIfWFlPtxE9PWjbo8oBxyPDfYj19TgB5t6BOBLW3FzK9MwVaoc8NBex1Rskd+mO9a+gAnR2PFzmMj3rfpT1Zy/dEyC12rKs7xkWcRNGnEmTy1mcrfO2WjMY/G1l4Es8Yf/OCGyQgKg8by5z832NOHLVCK+j+iQwh5Uz+m4KSdeRA/BQVJrHf/yZmfZ4nUMOPZixcrNaL7mYpZeFKLQQyFiYdmYurIi7QysAG0x4iMPZQfdkxpYxHUiWK/qf2YoGICbC7rHJp0mmLtn7e+icrJn5JEKIaH4nE66YjXmLfhXdC+Y/9PEWA2k/c6vRtsqmt81QJzLAuoTRGSa2eUBGouifnd7xCNB1xvnUO06Ksq8d/de4mGG9myVoHweFC9DVXvDZIkJJLOYssU1bOS4pWIFrDKx4FM4ei6tDPah5M9cLYshqqFtricHquUNvKWts9wzeOWfZVY4IWekmh/zl0vnDLU/i0smmGvLh+BpcieN0dNPS3+JKHcmkBjb7a+gNv4XSy8HmCXgKo5
 0eWBBSQg
 RNMto21xkAoYOTT69uYd5DDA8HHDX6YEeWjH9+/ZqKxFOKhrW3HbJ5AxN3d2QWp20IEP9AYZ6nJtz5Cw9C5/cHDy3Vo2VB2KTtaOHfCZnN8I1nlgoaMmpA1kLVMGupeVOVQzXc9wjrRyZe6xwQkE1GH1biiyPyKPbalaEDlXGLm9U3JAwzwSXdGKqc7Pbl5hFxvPehqw8cV3NmDW3QippAZQMTVb1FZLJZsDdOoNLA5WIaL7BC02BWRkZ36/mfBhpFZjmADbVYai5FPUU6Ut1FXYc/F6LiLj4295fh1TqDYowFXPRTqZpvP+H2cywlCzTek/GF0Y2/b2e4lyq1oDmot0K8/Scqw/mvGhynqr6kk6MvNOKDHZOP6JDCioUxFCpDWxdOmtxcITznIdd8uJdhfNN+e78v9XA1VjC85Wnyif7XvLddOgXEdDYTatoOp02+JUk6OywfVaav3zN106SoxEHKxLYxSKNCl1F80aorb20SV+lLALy50KYNnOvPUCknR4t+ohVhHzGARU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the heads up, Pedro, fair point. I had an LLM help draft
these mails and it shows. I will write them myself from here on, and
noted on Assisted by, will add it wherever one was involved.

