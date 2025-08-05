Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3A3C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 18:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C88E6B00AB; Tue,  5 Aug 2025 14:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A10C6B00AC; Tue,  5 Aug 2025 14:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B69B6B00AD; Tue,  5 Aug 2025 14:24:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCF16B00AB
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:24:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9902656C9B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:24:46 +0000 (UTC)
X-FDA: 83743529772.24.0ACC1E9
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id C738F80004
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:24:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Is1ZkkQV;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754418284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKVLqHIWmibana5VQZUJL0qfjT6gFJPBTJLNVk0SJRY=;
	b=Dsvvm7VLULNZ0E9rEui5sUTmyZLPy9qr6NfQAGYDSegjqHrc1o1WVuC3YqVRa+OEgTb2+K
	xM7oEpRwiuWQjBcZeuN1VYRpc+6pG33mycawMj/Dena0LN+3o2CNgzgQDd9oxGgosbdUHV
	9smFDFO8sFkfDJv7DnQXSUcAngaQwpk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Is1ZkkQV;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754418284; a=rsa-sha256;
	cv=none;
	b=zHkisAbepwhMBN6cWKwIJ1fD3zfOCONTRtgnOLwI+VKpKIn8vehXIcpkL6FrExFAlxlebG
	LuHyuJw5iaYLb2CgZyHl/5ihU8rk/N9JydOjtsn04+Mcc7GzsAoAhcLE6qwriY8HGP0bqD
	zFjSCDtcFq9Yz0AcHBZwEo2XkZqXQiY=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b06d162789so25664161cf.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 11:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754418284; x=1755023084; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OKVLqHIWmibana5VQZUJL0qfjT6gFJPBTJLNVk0SJRY=;
        b=Is1ZkkQV4RRdtqEDxF5ZW5Kxv7lM/4xEjbVK5/O8bOaMYxq/FCvP0nVEIRsS7FngyX
         XRksvB+z3seJoD7pvS4xwLW5j5WtpxvY9i1x68drDfL36WeWvN6gwQiIHmrVztmdSQ9Q
         1Ng1jnfVD6CZZ7Mm4hLnXU7XxodVlePYKXV0qAb1C36ftVsrkqBG+T/pVoWGyQWFxTUP
         1jQMrfYHi62qoOTU85y9L1+DHyJdMFz/5+Fu82+1InKK6+uaTRzOFMy6k4iptzK01Jmm
         gU87PXRy/3oR2e84sxrQEDS3prsJhMHCOTBUjEFU9Vn0XoPOLzlk+bFwT2MCXkMvFPJV
         jJxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754418284; x=1755023084;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OKVLqHIWmibana5VQZUJL0qfjT6gFJPBTJLNVk0SJRY=;
        b=STiMM2xcnVrj5UcVRXwmrsrHvEc1ljt+QeXsQADB5tmTBoxNKP7iyZqa9w7zLUvMMT
         fTq0RjuGh8SJqaanF23sxjJqUx5RKjwXeh3nAFLNh/XhnIMa63rXk9M6HH2T3roc3u4G
         rRb6jREA2Whmc4ptd4xTc2ZHcw+CT5c0lE9h9RjzYz/WIGoJ6O1T4KTPifdIpX7zd/QF
         weCTKRwrQop58EmAh8kCEhMY/a/3vFVYPVCtifGC6JL9oYK25q/wSwxgOBMewRcxsYkZ
         E0UqOo+TLWAnhd9TshHHvVeo+pfa4RIAk+inRyylB62m11izOh8zDo6jCYBOv+Y6Zf9Y
         wqFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUT/vxarFFKpKcEYeUfA1CPyG7DScclBUs+zlSvCFqcuyM+pwxaH6Lfs0ws8EVtn9e/MD2ufCy+rA==@kvack.org
X-Gm-Message-State: AOJu0Yy4xnasGImLnv3yto+it728P5Y4mSgTfOIlQgvFuVEYFA7Sutcl
	xYOn2+bYlTUlrLGBwlDc1ONhO8eI/aLtVgRk9Dhqts05zGEqJONMO/v5V1tY43AruYmNBhmmPBy
	3w7p2Ej4OFE+hNlrrykppifSw/Dn+PdIxVoDepjaIeg==
X-Gm-Gg: ASbGncur9tOl6J/VdceMUFlLS4+nboyyfwTqTbIpfrFULAXEHo8F2c3BcNq35erVD0R
	LGbn16inks9SvgrguoEhSOvGoTOFtmFWI5eT598pcfit+1xESOLBDt7JzOdzeYlMLfPHNG3wU/a
	xHWaM9zASUmcr2SGJkCx4UJzKrRrLLkPw2D08oA4GA/thvte0L6Cq4VCdWIXxRr9KOjKns5MIIK
	AjP
X-Google-Smtp-Source: AGHT+IECP/Qxkxwml/cf3BCEf7Q2B4NHOjK/2NaPxdggrpfuJmAft+1jLFMG+N7JFiUAXv2wscgyaif0s26EEgdezVo=
X-Received: by 2002:a05:622a:191a:b0:4b0:86b4:251a with SMTP id
 d75a77b69052e-4b086b42b17mr42712121cf.25.1754418283817; Tue, 05 Aug 2025
 11:24:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
 <20250723144649.1696299-32-pasha.tatashin@soleen.com> <20250729161450.GM36037@nvidia.com>
 <877bzqkc38.ffs@tglx> <20250729222157.GT36037@nvidia.com> <20250729183548.49d6c2dc@gandalf.local.home>
 <mafs07bzqeg3x.fsf@kernel.org>
In-Reply-To: <mafs07bzqeg3x.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 5 Aug 2025 18:24:05 +0000
X-Gm-Features: Ac12FXzHvHvpYHaqyT4n7r9UBwaTJ5dSsQkeIlx-mzYjpvX_Sd5MnNPi6FTtCG4
Message-ID: <CA+CK2bA=pmEtNWc5nN2hWcepq_+8HtbH2mTP2UUgabZ8ERaROw@mail.gmail.com>
Subject: Re: [PATCH v2 31/32] libluo: introduce luoctl
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Thomas Gleixner <tglx@linutronix.de>, jasonmiu@google.com, graf@amazon.com, 
	changyuanl@google.com, rppt@kernel.org, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, anna.schumaker@oracle.com, song@kernel.org, 
	zhangguopeng@kylinos.cn, linux@weissschuh.net, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, gregkh@linuxfoundation.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 3fce6d55g4fixgpjk4z1dcfddkzg9xfu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C738F80004
X-Rspam-User: 
X-HE-Tag: 1754418284-525980
X-HE-Meta: U2FsdGVkX1+0HZhqiZA97lu4k6Us/4nisxySWboE4z8nY+8dYE6ggtKU5vSQ0n5NP4Zk3Z8iLVULtGxVI0bv9nOKJhXnyjr6EqOJvDLM5Pqbd+DUoqpbQnOzUB4lUCWvjQOfOiziN4PxBLlHWfexqqhvhLi/Ks+ZZn3YKiBzjm/IsBE7oQGjUMosmB2Z7xTGBAooHuvdaDAdEWhVog3H1OFdY0PETvFBLgVwvSlxM1yI0Ny4mnEbdVfkPhEBGFRLY6rfVwa9kSMVmzp7P9syQVmxiNa5QYsNmDt1z1x24102xpxvUiyOeJ6PJckeDizhLwItcmNyUZVGfRJoea02nYLi4Nmv7soa/VPCtXF7LkhY20qm158GZ0pVnoa/ahgGID4IuK79pjWhpxwFeURUJYofhvu1C2+JF8r3q5oNg1z8ZXN4PBoTmVk3KuLfZNc8ybVP5uLGrP+hNenOja/IUEkMavDWuculYwAxOyr8hVErEvyTzdCV/gqRKwzD1QkBmLP4BIbip64y8QVG+oujP5C/avb400krJ7uTd+pT8RfEOfu1G74pyB7oXHqszIfTWUFqzGmL5INHXCdQv/8ie/2OwCFqB4fNlFb8Nr609CMYKJ4Yg4/lDzV6zXwdbVYE8Qaj0doqYWJhkeaFZsvF7LLabnRfBBZdpEAQruLuVCgR3kOxIoBxKgO7RTXLVpkpUMOGYkW16Fm1bxqnFOdOs09Nb1++kpvAdhx/Jg5vjOpjT9i7WrIA/CcI3hFumsvec0GOo4pzVV9hGiRH8iw/vNCbnZoT5iLG/plVyIFWFfkh3TnADOsSbFIjTjrPztJKMEv1U0P/Hr7pYTsWt/1eeq1vshBuRiinwGnmJMpFolsAxU8oKWZnXR7LhhC2D+llfK4uMb3Dmle6x0IdfjmNt3ppeAkX+Lm5FzaASlx05oj/Rc/0Wa/sXR47FkyFkmleRD7LW2ci1dAGZEkgIaY
 DmJBmVT5
 ofR9HcEcSh4kFcp8Keze+cOOJDIxUrq8nJu1H635w28TLN50KCKQ6IgPMel+DcdVYH6hxfKtqkyRl8mHFSpAtYrRU2kvXAgmMJN4x24p3ai6PJBLuGn9ZcBz+GIgrV2hXOAQ6O3x42MCUkEQJ7gHvSfTzH01M4VYDiWVtxr8myjOlKivkreoKPG7l8M+fafy8ksXZyjSeNhWVjqIxwfvkACnt7b134FOgyKHf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> To add some context: one of the reasons to include it in the series as
> an RFC at the end was to showcase the userspace side of the API and have
> a way for people to see how it can be used. Seeing an API in action
> provides useful context for reviewing patches.
>
> I think Pasha forgot to add the RFC tags when he created v2, since it is
> only meant to be RFC right now and not proper patches.

Correct, I accidently removed RFC from memfd patches in the version. I
will include memfd preservation as RFCv1 in v3 submission.

>
> The point of moving out of tree was also brought up in the live update
> call and I agree with Jason's feedback on it. The plan is to drop it
> from the series in the next revision, and just leave a reference to it
> in the cover letter instead.

 I will drop libluo/luoctl and will add a pointer to an external repo
where they can be accessed from.

Pasha

