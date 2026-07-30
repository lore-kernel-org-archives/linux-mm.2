Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB3DC5516E
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 18:16:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 484A16B008C; Thu, 30 Jul 2026 14:16:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4357A6B0095; Thu, 30 Jul 2026 14:16:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3242E6B0096; Thu, 30 Jul 2026 14:16:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFC7C6B008C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:16:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 814871C03A9
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:16:08 +0000 (UTC)
X-FDA: 85046247216.19.C2664AF
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8837F40013
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 18:16:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rVe8q6mh;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785435366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jeT5JD84OLDwdMghWHFJO3a32W5zB/0PvPjAX4B/43g=;
	b=yfjz2lm3uomt1GnC8kQzcSDX5lKuxhOEWB6vKQP1/1OKDX9aVf1bF4Uz1Mx++d3QU7JTid
	tScXN3xsTslkh0SvGNnvEbDQpKYMDB37kW5y00J5m/zpTqUcmI5GRVCILwMY0roHmfG44x
	iCMHsyjshUKUw7kPNfTjiwtXuVNuD5Q=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rVe8q6mh;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of ackerleytng@google.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ackerleytng@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785435366;
	b=MTV6Fw+AJoxA7k6neI0Kp4Ywm+bMBtxVnpxk0fgAwJocLWoGMO0MUw5TOoFv9uonqyhNfN
	khZTrS8TSZRbdGtfUAynxDh7SSoasZpDpemILLZcS+sYFV9jPtRUB9Tp1PUvdUFdrq70s+
	BOJVRnwSya9Xq1ZOU+u0kmBseeqLybc=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca7c1176317so95413a12.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:16:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785435365; cv=none;
        d=google.com; s=arc-20260327;
        b=WaCv+p9DfxMAsQBG1XUx8/kw/1aHF1hfyZcDoUmIYyIqgI1jVO36gtDRFihyQ6InJ1
         p7XEDWIOb/8F9BDq26jIlsjAetOCX0dHk7li0B8VCaItSFyv5lk8ZK6K+j13Mq4oyAmZ
         2S+3NVx5wBb6qHDdlfTXcW5Sd3wkZYZkyhXsVKBV1PAY8PeZSh8uTCtpf0CdBx+LRuyE
         VlIVTWmboai/MXvmAsMpjcqykEns4xh17Rn5io1cy0G68fFS9HiYhQ3bsXxlLWYSqKFu
         2C2W3qAN2FcnQ+iXbW/tqegi/FvZ3uQbczp/mZUdHJG6sGqwJS0Mc9aBJexjCZG5bH9W
         Ajiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=jeT5JD84OLDwdMghWHFJO3a32W5zB/0PvPjAX4B/43g=;
        fh=loUOqKrvV6OK7lAjAx0TCz5/zvoA5EOnTiMNeGI1iyo=;
        b=YHPLDcgWTNoLiH50kcFMe3GusNECbqTEuulEUqMCJBVbmxUwxAU1ut1uuocpx2oM9Z
         MA3fF1dJ6VKz9yC9Xhx7GG/LogNKRx6jFsXkwXZ/AW61nhn8yHMRqI8zlayW/XM1i+FD
         GmSvU9qbLYiZD/i+ES1/JS9NBSb7TC4L96th5VeW1rqE3JQEfYHSWMIb40FULDRZDzVH
         I/eTjozoCDj3J3TV/Kx18jbzjL9NHzrT1quJB8tjR4SFjkU4WrMsF0R/z0BGojgylHt6
         6Pob9fTmS4bhaLlzudSgU9ZAHYt7hMCc8DTSkuod3gXkE69/IVCV82V82Og33lqwq5yi
         qczw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785435365; x=1786040165; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jeT5JD84OLDwdMghWHFJO3a32W5zB/0PvPjAX4B/43g=;
        b=rVe8q6mhKECF29JGPmroIsS4xLAc292j+q2ZWBouZKR0jAkdVZmeBzfR2TKbDrYz/O
         mrYuADASjNVdok9L867Pvcsiq3U2v6xlVTPM5m5v0nnHyVy79mtUFnuiJ5/rc/G3HMNe
         sNywqjblCF6I9V0KBPKQ98iBKAS/fiXV/4NGRo9ufuaOB/kvnDKFCAH8qseA0d9zr0Rc
         6RGlNQjHoXCVtxcQSt9yQXHXMchamvTAEuzGWZGE/ORrqgX7HXl4LYbkpN4MataAc9RT
         LuMoNgaYgs2XxiWVFGxdzyTUSP4O7W7OolkYqn+JUXSDVw4WxGhsYGPyPiqsoYz1zYAj
         jzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785435365; x=1786040165;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jeT5JD84OLDwdMghWHFJO3a32W5zB/0PvPjAX4B/43g=;
        b=G9Ezm7FpPT4u0Je6gHGVVroMX6bd4FKngmv2CvGSkEZRMbNtpCijRx0auJDpa0DdLw
         3d9BLaRbH2cdLxrK3qTOsJKzL8aFRwmybjB5vRpcE0wRDRq2MUnCkD7NiuN+M6pTIriP
         NDqxvfZjmT+D7KEueZkrIo1z+WcJnR1NRncF5QkTljZ+pSoWqq1ew+keQevtEeZPWRto
         zYqyeSn88oc10D6zi3Uhxhmm2oG9Dud5dO83jX1wcCAARR7lPAu51tZddCivbfsUTiGk
         zbl8ZQ9LIukxy40uUJ1bPohmy37DAsPCS7AtIxMZS8u5FoNz4MXE949ZQBaUPpTOhR2l
         ox8w==
X-Forwarded-Encrypted: i=1; AHgh+Rre+/GSqdTQDIBNAlwnNTMVe4KQZDHMlxIi1MaYqMrcq1QtDdJ2dXh2LexxDTJti85091FujCSM9g==@kvack.org
X-Gm-Message-State: AOJu0YyDQWXtw1Er/m8WBfDpIZYqNBf72yMh/oKtKttEsSRZ1GWf3dQr
	j5NaC8yulo6MwTOxR5kF2eCRItpCL/pIGSuXMTQPRU2b7Y7wETdFQaOPRChbA5XvmxrkMc0xprG
	JkvT1pqgnHk/n6UHyCXWwBU3fia5u2F28RdfAJuSr
X-Gm-Gg: AR+sD10gB3jZ7j33KU31jIUkquNGN3lxA9fFEdJTCOwZW1bkAsSU6XQBfyb4+T0EJBT
	VUPyH6o0RTmvIr93I6GQiuP8MJ23ni7G3B/Qx1M1dEzUrQRC91wwWIGVIdgQSdWv+R0laxPlnsn
	hPfDInCAwCb3X1jgyFY8+UkNIzfVwuVexbvN2Lq16Dc5XsTjGG+j5wCFex9MjR6bfbPjvNVasoV
	4zk3nBhfhimXr6T4045rnpEBWbFD0uUOMcSK6G4oHFY/dir6Sr9hTlDoDazuToLe9punb+9+GXQ
	spvWU0NMN8SbMuh2YwdtBMCzP96aUnyFypzTFt7GL/VCmZIKV6JgqChufc0XzN2n1wHa9uj0fPr
	pIoQzYQS73Rw3Xc/MXeSaOpu3WioXxTq9ZQ==
X-Received: by 2002:a05:6a21:699:b0:3c3:a948:e2dc with SMTP id
 adf61e73a8af0-3c900759828mr3817647637.27.1785435364789; Thu, 30 Jul 2026
 11:16:04 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:16:03 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 11:16:03 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260728121138.1103610-9-tarunsahu@google.com>
References: <20260728121138.1103610-1-tarunsahu@google.com> <20260728121138.1103610-9-tarunsahu@google.com>
MIME-Version: 1.0
Date: Thu, 30 Jul 2026 11:16:03 -0700
X-Gm-Features: AUfX_mwuYQlBmJdhbZSf7MRgmwyNG_KfxbR45Duou2tcQqjIodL3cnnQ31aoSzA
Message-ID: <CAEvNRgGJ0s5Vu8xRvfPmA39p2Bmkr-U7JFFkshM9Dyk9j+t-YA@mail.gmail.com>
Subject: Re: [PATCH v4 08/11] KVM: guest_memfd: Add support for preservation
 via LUO
To: Tarun Sahu <tarunsahu@google.com>, fuad.tabba@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, seanjc@google.com, dmatlack@google.com, 
	Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, david@redhat.com, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, sagis@google.com, 
	Paolo Bonzini <pbonzini@redhat.com>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: linux-kselftest@vger.kernel.org, andre.przywara@arm.com, 
	michael.roth@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	will@kernel.org, vannapurve@google.com, maz@kernel.org, fvdl@google.com, 
	kvm@vger.kernel.org, oliver.upton@linux.dev, kvmarm@lists.linux.dev, 
	alexandru.elisei@arm.com, skhawaja@google.com, aneesh.kumar@kernel.org, 
	linux-doc@vger.kernel.org, David Hildenbrand <david@kernel.org>, yan.y.zhao@intel.com, 
	kexec@lists.infradead.org, suzuki.poulose@arm.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8837F40013
X-Rspam-User: 
X-Stat-Signature: pcaozom76pumuxso786qy36hw8cwxiww
X-HE-Tag: 1785435366-623604
X-HE-Meta: U2FsdGVkX1/oGSk7/3+BPBxWDhyiYvIDCNnhRPXW15W1B/VTFZjDzAln6yCOfKS+VC4RMxmHkrultdIYaB6+tmANdyq1O+lZGAmYM8IkYXSBzSW7D0opdD8YD6ej7TWJIBsbCH6Rpqhs/W+qzpu5uvapQhJsKDFY5OyKeQIvCk97eJjvdje4ATNi3L9NtR4tFuzFn532DT2bBYHLe114vECWO+YX9N+659jxCQrh/rZV3nJSIn0JnPST7kcIE5LHiKjzFmNmlqCx6oso+nKNxXbrST3tJWkGj0UZJiSTY++trRae2zf3JLSETuDZEe7L2ndZj8xvw//YNjydNpEecx7fr1Uexm6bTTUBk5GcMvrDMUc/E8E97IFxYh/dGw7knTi9UeqLdxLOzpgaRED5wwcOC1fwl42VodAEMH+jvE8eiGt/ebb9FjejuyZK4VeEiAIlrkt4LhiQrICMPFlwr3aDVZiRNIlx3grv9tI2VfuB98yv+Fkk5L1cCdDrXJPLJ0WpRjM63ACPyJbyLNGoqdWjZVzCCr9ZQnAeXVAm6QGYcpHvKoAS9wIsMoEEjQ4PZkKUlgWV5OPoLMJzfRMDdqkrZgZrLvnWP/8XOxPyZM00x7wmHsMu+MOrBvhRKXrdG7n30/tmnKa2gKdm8c91ycTEfZKH0sQR3wMmwMyqifoxONBVcIGhJtKSJinXFUwKfCcLttUmErLrw/OY2YnzgBtYWA5xIR0g839Q4jJUH7rs3Ki8V8HU85fxSzVwPzRtK6DbkoBfwAvdPQ/gBGRSBk3V2GSdbsn3vZQw5TUVqCkbc1dbF/A2WyuoHlEoSGlhc+U9cnxhrzA+Flh5jP2VTolcCPjADTv3vOQeWWvTSbJIdcs0oBDdglZXK1W6T2fzmX4Ur3ar9s9MVgTDvK2gMrqNcpCWhwtdPm77yLb/6jBdGfilx5ZkcV5hgiihaTbXYfipb6bObrmGyW5Ff20
 mscs3qNb
 2/uKFRvVYDBMGpb5zQJp0F2h484zm9a++xM5c99Vc5IyGGWwAlfVRyFhLdn9mu7wHKHb4q5Uj91gOqWF/aBF7IyXzTcE6cBhbGgG6zd9Du74+WwD3OlzCIbK2JyMePA9VlDzDmUqhZzYYynNDd1fK3AVnYJHDwgP6wMMLgI0Jbh0gShf00ZS6CKLJk0J6a749mgicViKx4eFZiWNAn3SL+42QE5QaMrdbkCq6ns+K1LyNNSoi+ycF0hCJ63dGyO/Z9Ujb74NRiSztxaU4AayiLjzydpOapJaYa3Cw07nsUqwcry5etBZBFki+aVQqXljqWYc6V6I3PDY4fs/GDBAHmG2/nvmK/AzLnsRRMc0URR6VBqAzpkUlVei0lA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tarun Sahu <tarunsahu@google.com> writes:

>
> [...snip...]
>
> +static bool kvm_gmem_luo_can_preserve(struct liveupdate_file_handler *handler, struct file *file)
> +{
> +	struct inode *inode = file_inode(file);
> +	struct gmem_file *gmem_file;
> +	struct kvm *kvm;
> +
> +	if (inode->i_sb->s_magic != GUEST_MEMFD_MAGIC)
> +		return false;
> +
> +	gmem_file = file->private_data;
> +	if (!gmem_file)
> +		return false;
> +
> +	/*
> +	 * Only Fully-shared guest_memfd preservation is supported
> +	 */
> +	if (!(GMEM_I(inode)->flags & GUEST_MEMFD_FLAG_INIT_SHARED))
> +		return false;
> +

The above check can probably be removed. I think the core thing about
this series is "we can preserve any memory that doesn't have any
encryption state that goes along with it", and so the check for
kvm_arch_has_private_mem() below would be sufficient to gate that.

> +	/*
> +	 * It makes sure that no memory can be converted to private
> +	 * even if it was initially fully shared (in-place conversions are
> +	 * prevented).
> +	 */
> +	kvm = gmem_file->kvm;
> +	if (kvm_arch_has_private_mem(kvm))
> +		return false;
> +

For now, has_private_mem == has some encryption state that we can't
preserve yet.

This also gates off KVM_X86_SW_PROTECTED_VM, but I guess that is
intended, since when work is done for preserving encryption state, we
can then test using KVM_X86_SW_PROTECTED_VM, and only then, remove this
check?

> +	if (mapping_large_folio_support(inode->i_mapping))
> +		return false;
> +
> +	return true;
> +}
> +
>
> [...snip...]
>

