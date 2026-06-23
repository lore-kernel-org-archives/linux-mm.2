Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1079CDB479
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 14:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94496B008C; Tue, 23 Jun 2026 10:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B5F6B0092; Tue, 23 Jun 2026 10:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9806B0093; Tue, 23 Jun 2026 10:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93EB46B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:36:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 272E21A0547
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:36:28 +0000 (UTC)
X-FDA: 84911428056.25.85E0915
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id A5DA54000C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:36:18 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782225378;
	b=XsriXmQwmkEuYq7MElSSfvEd6K0ymTPEWghfieP+gwmOi6HbIc8Hy3vJqosfPZtileJyfO
	wC+JrY3u/+6qzamAl9eARZlgenpY0zxHjPV7S23FAFeVelTobytnYAlSMSv7XyNxjNt2tw
	MIjiF2j/6yFhffvHzcAM4WtEfHC92Rg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782225378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZXZwKtoljMf9sP4FScDU2dpLN9WIG287qbX6i42q1U=;
	b=WRTMjL2t4/mHuLhTL2tlkGFrkRuv2vdjPRdmhjaUPCSb7CTYl10VKXD5aBM1umaVcJQnwc
	RNSXVJQrdNgkp7J5ubuDeAi/ioVb+/rzqkww65b+w6R2D+aA+5AkBtUju3i7N8h8huC2+5
	hswp0AYYJUjaraTWmqY57TxAaplzcpo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gB3bFMDa;
	spf=pass (imf12.hostedemail.com: domain of 34Jk6agkKCFcIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=34Jk6agkKCFcIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-69763fd5cbcso4902586a12.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782225377; x=1782830177; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OZXZwKtoljMf9sP4FScDU2dpLN9WIG287qbX6i42q1U=;
        b=gB3bFMDaAVuRb1VzgZiNY5YOaHxZtn8ceZzMK15+vL+p6evWDhIulgVB9fIYwEWWtq
         Zv+3+vbobjfhzDeo5BRgCK88ezka5ubM32YTJwK47cKjD7MZEf/6fohi6EZDzy8gBFwT
         FXMRPJE+0vbfeOvJoarPBEmWIsScgsAaPh3uVKAzDL9mwcz2aVbqEqV/bA12JrJ37N/Q
         j+Q6+GTtPfhtw7AR8K2r6z4+U5ZRw8XiaT8/5OU1F85fNJMgTHPqbNtTEofPdOLUaE9Q
         WftMSMThuW1oEMrOb6aUs9IbZZ+h1YIHKDdHxcb14Co9f/dbCgcOzQuZyX9vQbdmzO+w
         t3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782225377; x=1782830177;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OZXZwKtoljMf9sP4FScDU2dpLN9WIG287qbX6i42q1U=;
        b=ZszdLZb/nKM6hCDRPXA/WtvSGwrbQqJpZgJHN+V5wI73eiTZxgmIrQ9SFoP2HBPIM+
         sBDlNh7uwgtBIkqs54KXaW9vd3JiBe/uvOdLgYOXkpVdiEK4hscwhUeQDkDmxE+BGiTg
         gz9sWaq4Ot/Wq4/5L82zC3EHSbTx3dE3ha40jo+cGMhsHuSH0kvncdUTfxBKRs6ySwSS
         AoSjCDB/eShO+gXpCDsYrhRVEC0SkP1UWUrgwbp2OTloFly3YnG0ZTqHAr/1SUbBVtu6
         qmQdXc2F6rztBWWISXt37HiuHtThbMWm44WZOp8zzJ+wsdteREwyeEsIHeLLg1ThHixo
         L2kQ==
X-Forwarded-Encrypted: i=1; AFNElJ8X+Y6hrlmifWbxNYFVgBYTFLkovRcf/zRpv1x2BkRuKKouj9+YqIAkwoPSZCNRIB7Otv1mer3rgw==@kvack.org
X-Gm-Message-State: AOJu0YwzPxvSbsga766GofvtC6izyqVIoXrQwAnHP1LxuwxQktjzB3BL
	Cf9LowN2x8vOVebi5FaSA52xJZpEjb3wrhw4Y3pQILbYzhdarwgQGtfUCY/5dGDtPbLnONQcTOs
	rxVOce9UU+Ifd9mHU6w==
X-Received: from edaa1.prod.google.com ([2002:a05:6402:24c1:b0:695:df16:96c6])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:510a:b0:697:e953:d14d with SMTP id 4fb4d7f45d1cf-697e953d492mr604080a12.17.1782225376632;
 Tue, 23 Jun 2026 07:36:16 -0700 (PDT)
Date: Tue, 23 Jun 2026 14:36:15 +0000
In-Reply-To: <CAEvNRgFEHciT3T9y+qEYRvXhDwfrggoU7Rm=f9hT3OrV+wgpNQ@mail.gmail.com>
Mime-Version: 1.0
References: <cover.1780676742.git.tarunsahu@google.com> <48777f4749fa43d5648085dbb2037aa99c144a88.1780676742.git.tarunsahu@google.com>
 <CAEvNRgFEHciT3T9y+qEYRvXhDwfrggoU7Rm=f9hT3OrV+wgpNQ@mail.gmail.com>
Message-ID: <9huztsqtmihs.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH v2 06/10] kvm: guest_memfd: Add support for freezing
 and unfreezing mappings
From: tarunsahu@google.com
To: Ackerley Tng <ackerleytng@google.com>, Jonathan Corbet <corbet@lwn.net>, vannapurve@google.com, 
	fvdl@google.com, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, sagis@google.com, aneesh.kumar@kernel.org, 
	skhawaja@google.com, vipinsh@google.com, Pratyush Yadav <pratyush@kernel.org>, 
	david@redhat.com, dmatlack@google.com, mark.rutland@arm.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, 
	seanjc@google.com, axelrasmussen@google.com
Cc: linux-kselftest@vger.kernel.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-HE-Tag: 1782225378-930595
X-HE-Meta: U2FsdGVkX18JAORWAVNv26gZG8Rt2snuGWv6/Y9al/YG/kt6OOPyUqVJcqb0LtYJamNXHZRyV1ACa4bCD/YMCrBAdm7yCYrYI3hBCk8hJ/Kv2PoOaBIul1X6Jwzp2S3goUrYB2Gm+mRpk577kYEHJ9N//VvmDM6p9Srh8xlUjo8RKNI9AW0ChwZWQf0u4EDrzAzfxsbVEz/gELrBFKthU4+DuXPzwKo8qFVy+S4n8bzLWGM4qML1R7ku+UO+NaWk51fW0STE8zMg/54IsA6fTip9MF2/lvYnhYSczLzF6EEgxI26ETglXRK1t46QrCp7+/kddSGy6lD0LRnYcuE5j27GVM08BSja
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ackerley Tng <ackerleytng@google.com> writes:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>>  static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
>>  			       loff_t len)
>>  {
>> +	struct inode *inode = file_inode(file);
>>  	int ret;
>> +	int idx;
>>
>> -	if (!(mode & FALLOC_FL_KEEP_SIZE))
>> -		return -EOPNOTSUPP;
>> +	idx = srcu_read_lock(&kvm_gmem_freeze_srcu);
>> +	if (kvm_gmem_is_frozen(inode)) {
>> +		srcu_read_unlock(&kvm_gmem_freeze_srcu, idx);
>> +		return -EPERM;
>> +	}
>
> fallocate may eventually go to kvm_gmem_get_folio(), so that would check
> kvm_gmem_is_frozen() twice. Is this meant to catch the punch hole case?
>
>>
>> -	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
>> -		return -EOPNOTSUPP;
>> +	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
>> +		ret = -EOPNOTSUPP;
>> +		goto out;
>> +	}
>>
>> -	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
>> -		return -EINVAL;
>> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE)) {
>> +		ret = -EOPNOTSUPP;
>> +		goto out;
>> +	}
>> +
>> +	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len)) {
>> +		ret = -EINVAL;
>> +		goto out;
>> +	}
>
> There's some reordering here. Why not let the validation happen like
> before, then check kvm_gmem_is_frozen()?

To align with design. "stop the fallocate call if inode is frozen, No
need to go further". I dont have strict opinion on this. I am fine with
taking it across punch hole as well to make it more fine grained. But it
will no longer claims stop the fallocate call (allocation one is stopped
in separate path: fault path) , though functionally it does the same
thing.

WDYT?

~Tarun

