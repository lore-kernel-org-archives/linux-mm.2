Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C81C531D1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 15:33:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954B56B00A2; Thu, 23 Jul 2026 11:33:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D106B00A4; Thu, 23 Jul 2026 11:33:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8438E6B00A7; Thu, 23 Jul 2026 11:33:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53C2C6B00A2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:33:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBC04120529
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:33:25 +0000 (UTC)
X-FDA: 85020435570.19.606BB7F
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C6F22000D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:33:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kZ4mWATy;
	spf=pass (imf03.hostedemail.com: domain of 3QjRiagkKCI0Ar8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3QjRiagkKCI0Ar8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784820804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0qWoxbum+mc2LRSxBlzJpjmKPNemz4JvYfhVDhJ98E=;
	b=kRaxigjbmpCIGZhDcOm1pzT2IBeq6NjkUpZfPAhzBMGlgKrBO+LHeRUC3cVdb/pNRle8Up
	U9rBx64tatl8Y5W/caUsylgtlpVSfOgJJx/wQ2MNv3ff0tIR/ZaByFcTHASmCPzfgONBPm
	9fLHFj3Fxk+WCMRKCM4mavQWfeIiB7k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kZ4mWATy;
	spf=pass (imf03.hostedemail.com: domain of 3QjRiagkKCI0Ar8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3QjRiagkKCI0Ar8B49ryBx55x2v.t532z4BE-331Crt1.58x@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784820804;
	b=vYQd5Acy+zRJRB/T/tsdImKdFA4gb8fAKjcgPgKR5cAdGzTCrhwS6CrTpaVZnJjObHaWX/
	hek6fD7su5KFCdq+U4hTP1UR6AUOuLIhkQiRbE4YYV454KoQqDvA7wu5ZoE/CzL+jV7ujU
	wzhRUBPWVil30vZJONVrg66JG5fA/GQ=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-69ebdb9390cso1493889a12.3
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784820802; x=1785425602; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v0qWoxbum+mc2LRSxBlzJpjmKPNemz4JvYfhVDhJ98E=;
        b=kZ4mWATyQscOILiMERUGyzOpGcTYAtLxf3e2MLuLDklQZYOnZaaRSlnRJ1hFbfn9ue
         PsEkF/P/tD2cIiF/sXj9i3OxKjl8bNG5swnnn/0d8/euFnk3PP7XcdzO6tgGwNi/FCem
         U7g1Sv7dGMTU4edS5bbrTwX19qESOXLS0EY9S7/N+vwdzWpIwm1DK4XXjWnJZaWK1DkN
         saQ2IdQ5hsb3WwuMQpGRSyqgg5qdAy793lmTaoLiRFmu3oX0LPJZdB+j2smFEXG85HQj
         6CnFaa31ZUkNj2MwnhYg5UXJNDVUCRcpGX1zqtKa7rzIWpOcjgtFloKmeL+zYVaNWoEL
         P4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784820802; x=1785425602;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v0qWoxbum+mc2LRSxBlzJpjmKPNemz4JvYfhVDhJ98E=;
        b=KKyQ/kAN28mVePe/2mJ3Nju1KLgBhoQALdTMB32JRsys46FghoInN9co7qQ0HGm0jI
         e2JcdRjIwJ24McF28cHJ1qfNAfL7Ku3M1x2fwdoUvha/4biw9e5zSvu/Z7CqEXVLNrZV
         8GuZQfD1tHWN9o38DXWtUlJm/7kp1S6KDDuDxxcSNRne5NVZoKvPrmr2GpKe/taMpsRR
         LW0xvXX4Lbyv18TwwdgDk6N5TgnJ3ANzTlh8q2kqcsM7jk6omNQA8NKd6ypebjYFaIAP
         /LawzM63EZBFLvKrxfmSmpBtTrfLc2cemvDsY3THYczHkwLeJ4INWRkRMPU1NuR6ixvK
         GOhA==
X-Forwarded-Encrypted: i=1; AHgh+Rpkd6rMuuJ3WOMW8ktZHjzuvYDLfeWMh1c9Hyo7Cuko+wBsNNLFU+iXEAzjE38O5ZtsjBa5lurANQ==@kvack.org
X-Gm-Message-State: AOJu0YyJbGLgvyXxOdlwYfyuTPaYmyCzHqgiZAqj6yTzXx0UmHdPXUPi
	zcM0bz0M7vnEgI1yx7i881kjB1+Dc589ZZagihvX+cW4RWlZSGn8qul/jEq7dU3iIf82L+BPFRc
	0a/+RYJpAStihvJwxWw==
X-Received: from edbbf4.prod.google.com ([2002:a05:6402:1a44:b0:69a:9f30:4b29])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:34cd:b0:699:2448:be63 with SMTP id 4fb4d7f45d1cf-69f6b63060emr1442487a12.16.1784820802174;
 Thu, 23 Jul 2026 08:33:22 -0700 (PDT)
Date: Thu, 23 Jul 2026 15:33:21 +0000
In-Reply-To: <2vxzldbklb18.fsf@kernel.org>
Mime-Version: 1.0
References: <20260628001114.1869564-1-tarunsahu@google.com>
 <20260628001114.1869564-4-tarunsahu@google.com> <178271651966.13502.2620034351625890943.b4-review@b4>
 <2vxzldbklb18.fsf@kernel.org>
Message-ID: <9huzbjbx201q.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH v6 3/3] luo: Update serialized data to use KHOSER_PTR
From: tarunsahu@google.com
To: Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, skhawaja@google.com, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0C6F22000D
X-Rspam-User: 
X-Stat-Signature: mgg5xxue6sd8qqr3sd1t6mm9ah1nxko5
X-Rspamd-Server: rspam04
X-HE-Tag: 1784820803-402715
X-HE-Meta: U2FsdGVkX1/etQ+/l6Btn3t11D9lH8ecFPmDsZJZAXccsxafr/VZ12H4cQ+OacZff/xAefdHaePqhAmtqI8I232CXkTNTJ5Tcj6kz9gX4FESeohXj57F8VTvCHDnfXkPpbzhnz/uROJ6sHGWBEKi+YKx1ZyuFVVZyR5TqEpBqA4v4XWa4Eytdqv6f5RCpZ9OiqRxohSLzlWSDLdOsFQVYm6FCYdjP2LAHmriPyXPy0WVjbMmgSfjOjmeMdN/GNKaQwrUuInbXAVbwKljXx9sNB+iDznOBI8d5E1BzDZAZXb6Nw3SZLgtcsXbQK3yC0irc4hOY7q6gEAvE9zOHYN9ngUTpzeyjEAq8x6V8evTcsHGCpqF+ePbenS7/SWJ55gmXxzhTEyijS3XGgHKf61J5qFi5NB1FZwLd282dH4b5fB3whtd4m3eufZ/Nkjx4fTicLgcDnIidZ29BG/OHIu+wzc7CMFnuN37KRuHLfttd0RFBMhXFL4Dus7ALGIHA7IfcH/wX2ODC7FLGuqBD4dVDVsErroKA13/y1IDOEGSTMpKY9CPnLwlZ0CRdNAAMkzhd3tZ8lMoJLb1qS+Uy7NrT9xf7h7mRKB2R64u8MSuMslLvmryPSBydnKbF/PW5C7ayjD/ds27Okt4j2+gDccrYUCuPyXihs8owVO8miKIXL9sNVEvWGZY/IX7Q5jcn93et8r57m2/TNIkJS4eS0KODmUFmFEENCbLYQR+8raZ+0lM1VS2B0WYOr0pHDyVy3M3FFmFso+6/i/XE5MDqVYeU9ZvD/nB0CYODpKjqcvs2EDis4M5XEjej0Ipm4fB4WT+RIwRrvOyuVy9F8aY+iVwdRXukqXMwycInYeQRN3hlQVn3mjmXEKRbjFhv4KbjmuNUv4ZZFKUR3N7qGNViJutxnxQnVA8ki0BFvmdoUkXU4kx8QhRLCWR2HQNU+EAk0f7skuyDmWLCNd3PGEaxQB
 bFOwJ4gv
 9m7jZPpj3Nyy9GXSADez3YSVGmN8LrN+CwopmYFv4aPL0DkRiQnOXQkzH1EC6jwoZd8CzUZ5fekYNtXkMMWotdQ4sfuoPQUmyXy14k9gHOWNPDeSqFQO8gmzsJoQTZpB1F0Uf0MFkh6CTZXe0re7q1VH9LFmVnRFGj24SsVRTt90/fp+Aq1C3JJYxCIgnkFjsLlkW3DdOeZgPwoJgbyEE8AJHQs7+eMdtPzvOGCFF2flh3cv6Lgu/dEhwkjdA4wC5mo8PxmbwH0vu1BnlybmjjyqKUOujp2gEm5OH71SIjXFijV5sHIzf/+UtywhcndPqv3+ngZCoRKKr2n9lUMwUZs8JBTxtnQNshie2ek5XOJzjWalNs1mDcbJmmn8MC24ujlFoaJ53Kd9vh4t9jE8fjwyfOyOPUz9RNf7kdLA7SyzjEmxChzQJZd7FcztBeplNcPVfSFKAla3P5zyW4R5hJca7ZE9xXbxXoYtR+C5iejBy5lN8dAU4O5fML/LPRj7i3bfwG+00HyoiPoxdxkNHBU4u5SzjB1PjwyW0OWyI0ikiX9KtptM83MnBr2f5Y13F38FpMxJ04DrIS1q18vB4/Yy6amw721C3PUlEIPHsqLNNGXlEespoQtLDGAQLMw3Y1BC5V4hx77rt9ioudYF7KK2c+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello,

I dont have much opinion here. I am writing this as a
gentle reminder to the open discussion below.

~Tarun

Pratyush Yadav <pratyush@kernel.org> writes:

> Hi Pasha,
>
> On Mon, Jun 29 2026, Pasha Tatashin wrote:
>
>> On Sun, 28 Jun 2026 00:11:14 +0000, Tarun Sahu <tarunsahu@google.com> wrote:
>>> diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
>>> index 288076de6d4a..9e78625cfdc1 100644
>>> --- a/include/linux/kho/abi/luo.h
>>> +++ b/include/linux/kho/abi/luo.h
>>> @@ -89,14 +90,14 @@ struct luo_ser {
>>>  /**
>>>   * struct luo_file_ser - Represents the serialized preserves files.
>>>   * @compatible:  File handler compatible string.
>>> - * @data:        Private data
>>> + * @serialized_data:  The serialized KHO pointer for this file
>>
>> I am concerned about layring violation here.
>>
>> LUO is designed as  a generic, opaque transport layer that promises to 
>> preserve 64 bits of raw data. How those 64 bits are interpreted is 
>> entirely up to individual clients.
>>
>> While some clients like memfd_luo will use those 64 bits as a physical 
>> address pointing to KHO-preserved structures, other clients may store a 
>> generic token, cookie, index, or non-pointer status. By
>> changing u64 data to DECLARE_KHOSER_PTR(serialized_data, void *) in 
>> struct luo_file_ser, we force KHO pointer semantics and layout 
>> constraints on all generic LUO files.
>
> That makes sense theory, but in practice, no file handler is going to
> need only 8 bytes for its metadata. It is always going to need more, and
> to store more information, it needs to store a pointer to that
> information with the 64 bits it gets.
>
> Do you have any examples of something else one might store here?
>
> At least looking at the current file handlers merged and in flight,
> memfd, iommufd, vfio, pci, hugetlb, guest_memfd, all of them store a
> pointer here.
>
> And if everyone is only storing pointers in this field, might as well
> give them a bit of type safety.
>
>>
>> Clients that need KHO pointer serialization must cast that opaque 64-bit 
>> value to/from a  KHOSER_PTR  within their own callbacks.
>>
>> Also, the field descriptions in  struct luo_file_ser  are no longer 
>> aligned due to the length of the new variable name, I believe it will 
>> cause warning when making docs.
>
> -- 
> Regards,
> Pratyush Yadav

