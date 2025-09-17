Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42D85CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 20:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98D408E0070; Wed, 17 Sep 2025 16:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E478E006B; Wed, 17 Sep 2025 16:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8059A8E0070; Wed, 17 Sep 2025 16:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1E78E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:39:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3003D1DF9C7
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:39:38 +0000 (UTC)
X-FDA: 83899908036.27.32A1C44
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4344680016
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:39:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J0wNnCjO;
	spf=pass (imf30.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758141576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2kzkQ4aOmc8N9K5jIReO5F0CstRjbfQHaSb2cVdK+0=;
	b=2vcvRGz37BKR0kfH2EOjXd3fL7v6GXfe2D02LRVduvm8zeLgMVFREDnJAQB3SgpsSpvY7E
	chR6WEUE4iLY48wj6LIIToUBcgZ91Ujp7YUH1NwmiHOgOUwaNebJue0Bbv7NLdPXNS9v4h
	hm6qJPurO6Tvi3m8UNXmqp0xNSP+P4o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758141576; a=rsa-sha256;
	cv=none;
	b=GgXhitWPNzItHQdKAt61whAew1r5yX9SNXaVkXpgjuR5SSvBmjU5YDM5FkPSUcIQeWRGox
	6yyjX9TalRA5m/De7vTRSblG8u+EWu6IBP3MPhz8/ve1k9AGxtTx1VjSss1jQmS3WI+kr/
	r/3ItJp/rddZ9jz2rFIKi9DpRGp6CHo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=J0wNnCjO;
	spf=pass (imf30.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b0787fa12e2so38047366b.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758141575; x=1758746375; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v2kzkQ4aOmc8N9K5jIReO5F0CstRjbfQHaSb2cVdK+0=;
        b=J0wNnCjOw0Tf4PL3OTynVvwzDeSPRJYlFoolmhiqvd+IYQXvTLNryt/1Ro5vfyP3BE
         8iKTb+tVA3vlCZYQBYQC/OhMP0uaSKQ4lj5ukwRiR4OydVCCyD8Htq4+L+69zLWK+7Mq
         00Po6+X8Q4heCmRLpOn6cOsvhqdOlYexv9EQugqw5eyVu1dISywF+Pk2AC3Ls1LjiN7l
         Zo5FoU3+JdK8GvTuqC3XUwmrTrqyqu8UM9coA3FG/CUUwpAg5YqJW8r4vJMWRwwcn9oN
         lwNZkE4YNr8gcuAnVNtMTFobqTT6K1uFPwjukLN01LyH+jzOcDbxKOQNOhz1MDn/B+wg
         eZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758141575; x=1758746375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v2kzkQ4aOmc8N9K5jIReO5F0CstRjbfQHaSb2cVdK+0=;
        b=P+JXiOJmbf32Qj/xG0NnLr4wnWIpz9EvN46Fq0s5dZENNvRzOiAsgpjlpY60RYGrPR
         tV+GX8EzyymX3WXVEGhZAOgKcLIN6l5mQl+KRbachWGTduxBv+/yx417sOKM0VCh5j4e
         0tG1xyr7qZv07WIMjtWibsLXE8RHtoJcANZkAbDj6YqciFD/VS2QrczLmAzCNuBbvwuM
         RMWCvWyFFc0SKvizTduzasBazxI888K6eIhFhlgotpZopnpX64naa3BOw4mJtwgac4E6
         ePTkqArTmTySwyv2d6+2xPge6VUKgO9sIbkm1nf86i3eo5EchqEOnDqYCsRirQIBXkDG
         7OXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGlAXTYjJfwyjCriHmQqESV/Evosa/YzhjGwL/ng2viI1bONNOmmGjGYYVvmvgTtbVGoevibu0jA==@kvack.org
X-Gm-Message-State: AOJu0Yzts0WrNpGLYMwpVo+3oODO2+UYYuwx1OFpICobbfniHUG2fVQt
	f8xO9r0/yaNZOO+pgCnAsmzQddRddzxVoQq4fOkd7qg4utQn5Sdc9lfsr1i9UBVmEf1uxyCmDJK
	JsnjvvHKwR683krtNZIOreGTIZgqfpEw=
X-Gm-Gg: ASbGncsMO7RwD8F5VsFbAUw7qYPAiAuMBCcsX5Cyjk4yug8PLNc2BWP+bX90DQoTema
	F92x+SauNlremYlRPH3thYPWxX+bknTt8ndowbU5LMcF+soO1vZNERvTefKTsWvrvdWre6fQGrC
	tm/zpOHv01eq/uuN5leNv0LlHZpll45kcve2FOfZ+ans/+DAd0C56G2yuvGsatylZDRgVVqHnyv
	qCghcDEBRPkGhj4BVr9/1pJGf1sgMdmAOrJWZM=
X-Google-Smtp-Source: AGHT+IFrI9fhyiOasqs7aFU5vuu3zzSapgEYvzTIhik4QC4sPMRAXmiqTqntHyu9WssGZGcjsazcwAN0AhwUJFXW33A=
X-Received: by 2002:a17:907:6d11:b0:b07:cf04:8a43 with SMTP id
 a640c23a62f3a-b1bb7d41abemr393772266b.41.1758141574464; Wed, 17 Sep 2025
 13:39:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV> <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV>
In-Reply-To: <20250917203435.GA39973@ZenIV>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 17 Sep 2025 22:39:22 +0200
X-Gm-Features: AS18NWAETzz-YcBQYRqakGPsgrcnxDdpvhBGhjX9-5GcpAybEJQMsj_xDszE9Ik
Message-ID: <CAGudoHGDW9yiROidHio8Ow-yZb8uY7wMBjx94fJ7zTkL+rVAFg@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Max Kellermann <max.kellermann@ionos.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4344680016
X-Stat-Signature: d3mfr64pb3shz6rsptmmuw4g1exjymo7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758141576-727062
X-HE-Meta: U2FsdGVkX1/FFV+HbS0eBmQ3siOt6eVyWkExQg+KMd1WJFXndsUo+LakpnZDQudRCRzt/hTG1V71zCby3/rPFanldrasQD6NFFJ6L0UsrRa6MhCSaOhR9oaVtOWyBxi/bz88SZFG2mFWnRCyDfzy4qdHLt5g9AJHuf4cC+5zcZjnKRVBADgdSEkiWc2LhMm3wg4uLa37ZLkSqlrnLs+AALCDeigDJ+7Bj5qyOnCeaft4NK4b8pdwiaUofaxZGh2Z9GCxndqgCPTks4hHcSy2EHtc6D2+MFFqsEiksVQyzf8g4RbuNKpX5mmhlrUNIvWwuF8zWTK6U/YBwCfpuv1rR5zaPbyFaU+pgCINfOm1shQ5TrnweDvZk5Fyqno4rSUIKnGuAGOijvajYC4dT0wVIAF4MhaL4yRRDSS5YHcrhq4//9+kDNPonL8WDXULRHG3PpNDJQdpStkNtIrG/4Priv3bqskVJirzfkVp+8Tbfegn01mCnZt8gbXlGe+18OJq5THsiBaJk6v0hnjNqcOWvPPTpqfuC2dajyCUqoGB9bHdAx3fOqPi2aOLCzW99IL9tOmCVYQGtLVGgLihOspS45khj1yyRrAyzc/QhwZ5LhYrkb5sJLn2kQlXC3DtfT020/ZtUEJKCi40VUGEzSEjRGkVTe5OrYDJw9KNE2Si05R730pHx1irHRBMuiXTfQ09z0XxEA8PbGwvzd+W+OXnKKggQPCJa4CwDYeSASDWADatg2MkhqG/Yfogmg9ld8P7Kkr24D4RTwRvgs2RF6lvydaMQbPsULvCSuchs4dcYoNDB6yqmc00h6ozXP3ic9RCA+xUzpCoI1Mkoo7G845vA9+ZE9xhTUfiXMtbrgFT8dEio6Ygsjl37ZuNIWyuYnKuLKA+OZjikifRBpI24bHmX3FWhmIkOXN9Oc1Z2D+d3xEM/KFFJ4pOy6vUoupWAi60YMY6Zpl6VcjGJPOYCWM
 uK2982cn
 umLygMMlz211ATJrzS0ZlMJwDClQZp6lFwm36ds1cb15wVt9PmZORRxTHmO3WECpQpaBj8NGed2TiQf0jfr5ar562jg/RWXpiPmDGgfHezJSu0Z1e1FuOP4Jo1YoVMjKegTfZ6y4an+O/cM+83YVFfJQnyKppQANVNIGO26y+RrOfPhXynPMCqZNd1jOziktwXKD4L/hFfLFrr8xjXrxBcelLzFZ0zNaa4QLy96nejgldyk0WrQlcGHvQnlruCnzufWS8w6dFQuN09BssI1z/EED2iSvgsEB1OPBm/2LKWAuMiD2m3rAsJpfhnUS2/HM2Aam3y8iglljas3EEJJY3vsU5sJOaMD+nam+NWCKStWqAwex2cAddgoHBbyo6OGTLUhBaBTDcu5USPZWXGIdfzEj+UER+9GBv3gx8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:34=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
>
> On Wed, Sep 17, 2025 at 10:23:00PM +0200, Mateusz Guzik wrote:
>
> > This should be equivalent to some random piece of code holding onto a
> > reference for a time.
>
> As in "Busy inodes after unmount"?
>

Where I'm from (the BSD land) vnodes (the "inode" equivalent) are the
base object if you will.

If there are busy inodes and you want to unmount, it fails. If you
force an unmount, there is some shenanigans, but it ultimately waits
for inodes to disappear.

Linux has to have something of the sort for dentries, otherwise the
current fput stuff would not be safe. I find it surprising to learn
inodes are treated differently.

> > I would expect whatever unmount/other teardown would proceed after it
> > gets rid of it.
>
> Gets rid of it how, exactly?
>

In this context I mean whatever code holding onto it stopped.

> > Although for the queue at hand something can force flush it.
>
> Suppose two threads do umount() on two different filesystems.  The first
> one to flush picks *everything* you've delayed and starts handling that.
> The second sees nothing to do and proceeds to taking the filesystem
> it's unmounting apart, right under the nose of the first thread doing
> work on both filesystems...

Per the above, the assumption was unmount would stall waiting for
these inodes to get processed.

