Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14CA3EF36FC
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 07:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDD9F6B0088; Mon,  9 Mar 2026 03:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83C46B0089; Mon,  9 Mar 2026 03:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65776B008A; Mon,  9 Mar 2026 03:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B14856B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 03:57:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 51EEC13BA23
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:57:42 +0000 (UTC)
X-FDA: 84525770364.28.14AF614
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id 43C798000C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:57:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pZ2VLPVc;
	spf=pass (imf02.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773043060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G9secbmrLeczpRPZ42gZHzPMJ4soIG7S5n6DXzNQl4Q=;
	b=1ApbKXHrSlJ57lya1c8e0Ryr9VrlwQsyBnAw/vvUgJN+x6hZ4A3DtyAGZSpa5DHyjedtSx
	xHigFbfaH+L3LY9VBd548mVFI4+/Ideh0z0JqdrepQ55tSeR9VES1d7CtAAehYgmrDWFmw
	UMxKVw/hQJcSg430S9qA81maau2GItI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773043060; a=rsa-sha256;
	cv=pass;
	b=kRoNkKeOVsaz8ULJyjjMYjtSbxWt7JVG02fwRaD91tIxD40y9lFrJhnntOflfVjMQoWyB2
	PC4rxiO19GIKlQXp0wYGKMAbxk8VjWvKRlVLbKZFsSGhnwMaeM1Zl3G4nf2+4mXTV6KzJt
	0Yao5t17+wYxUwzB6vtfK4U8W8AZB48=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pZ2VLPVc;
	spf=pass (imf02.hostedemail.com: domain of ackerleytng@google.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-56af4aad3e5so1406819e0c.3
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 00:57:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773043059; cv=none;
        d=google.com; s=arc-20240605;
        b=NnboyHGwA6xYceG7floJmbX0rV/s3UgTAwLh+Y9rtdPuSAZmctmsMqH8wh5+KojNv3
         sAGNuEvCFUmeye3VOe0ZqeEG8XKQN0AOqBTBN2m47+uWSUjLj1CxULS8YAsOorwssHU9
         s0Y8Z8MUl5o0DDEoerWAXh94RMajN8HjgFd8MOxbiYbv7HcuMaoDSlmhC17gTaez9wIV
         6xr7eVl8JkRc3VeGygs0rUTpO2TX+kYxFZS1BqdRWPJOs1rPhklXxFjjiVtSBCGXULxs
         2Amie4Pn6iFkLr18DDZDDk7yosrn6NQVA2HPk8YjFsOSGwAMBiV+RddisfLZgI0Upgg9
         JwiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=G9secbmrLeczpRPZ42gZHzPMJ4soIG7S5n6DXzNQl4Q=;
        fh=DlgzisYxZstF+Bw1fjUWkiR4pe1O5svyJ2Mpy/RX38o=;
        b=EBPCB6KyCcEh1XQpok33lD8q49ThG9LDlle3sQpZyw7mTxtGGAsoeXfL86CxJmDLq/
         QnA99XRP/JD4Ys0KlIh0OCLkibXTtW4LRTHCCWB4hT3LKGhM9kgg+Kkm+5wpH4g5P9oc
         hLmq6UpDW3fqsOfi3QhxN2SxyWcE8wLGB9YI9r7StAHb83lwBzVndxhwmubea6Di6DUZ
         xsG9UpPcORJIHrx+O0UEDpSwGsiwYgLs3tIu1w2kzF/tFHikmVxa8n5PaE8RNskqzVUH
         R+e/Q7q22CA9rI2237VkI3tEiweyQ/VlAoCVHsKI1W1a626abA8kXB1HLdyJQBULiRkK
         pEPg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773043059; x=1773647859; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=G9secbmrLeczpRPZ42gZHzPMJ4soIG7S5n6DXzNQl4Q=;
        b=pZ2VLPVcaqr5EOA55SWlKIhFnQkdKPF2YxCTGMmPoYV+gHxJVyww0RnkQuw/dNNvtK
         35Oi00J73WuTRtGM+eJGI8mzv082wtCCUR/WjGMb5iybkNzO/w1jKx5uhjVObLS3/94v
         e5KaJ+HghbVzRIlUBJfVCoD0z1YU/kIrWN2tAxdKRiJsxNrUq1SVjI5Mn+w05eGuwiSD
         stwGoytf7yYXNoT8FuS1FIBLWzMaVOqYS2J96jo5Ruo/1zqWjm6etxjSyc9O+oO/ur2b
         I7BCBe4/01P1926LR8yFDVEj/cRjnz8RVbJxH/776VOKB1RlOKN40bqDWTlJ8t8M3vDV
         RF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773043059; x=1773647859;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G9secbmrLeczpRPZ42gZHzPMJ4soIG7S5n6DXzNQl4Q=;
        b=vmZS5ZjPs/T29sciKJozgwogtfRShGWTh6p8uMuqZr31wmoOa/kLKLBiAmyN/9+xwF
         eJQLUrJfACgO9daKZzDCRyFN0nBjGNpE2xixO2JjcgCj+53I7+ybR85atxDsnc2oTy/D
         zfB0Z6aArSAR4z5yUj8LfOK8hsBtMgUDQ0Dt+Y/X5H/m9iBi2yByhOsqEdUsTv9dnj+k
         o0G25Ee4y+Zpad77Vw9/J/7Jp4tMkDG4r2VRj0+oAZnW+tXkuHAbJbtZ4sY/kj33fF2+
         t7tZTFSZI1Lz2ZPCTiVQln+HgrzAprrd/45vYNX8RXNL1G4F9hETixWBPIzs2/4amxx7
         TKJw==
X-Forwarded-Encrypted: i=1; AJvYcCWYEXAioKQ4IL5WoVbrM0j+asfr1THTxxzwWwPFsEP1UPemS05U/mPwaaB0yhjxZy7K6HXNtl3LDA==@kvack.org
X-Gm-Message-State: AOJu0Yzlv79K0RtJJi6P9SilGc58ODJ2H7ShTxmKD2w3vr/tfTTK1585
	84y/rVV2hkfPom4s2qmG55JDS5oyVSwNDw2oPKp+CaCpj39xPLVf4g1nbAgJP7ZNUFOmc6onql7
	fv0Uk6/4G9ntpgVQ2/9R0bUWj7JUaNbnL3hZKUU4E
X-Gm-Gg: ATEYQzxw0sKS/uYEKR2vktwke5gMQ3QczOOezcfQzSFY4xBNDieBEfvGVLwzwLKqleV
	vxrKDvqT8dkajTG7PIs5PJ7CicIpg2ILfm/GOHqllZL4f8Upy2i7cgvhA5DASM/lyxgDL8JqnN8
	IiwerOH1Q4HALpMgGYLrsOBjk7Jvq0flO1ZJIggaJJ1Slf2YqJSKyk7hSxesNjTLVGx6svBPq9S
	AQJTHuXNpooPooHpsjc2IUHHKF0UAiEn1Uz6DFLjwheKJsrmbMCAEYrVM8arPTmDw3MRCTgMXVV
	fPHS57GQN8fJaPZ1hdu1JtrXl5urt4vVKiy5a/aLLY95FG639T7qgwka4NqiVJi/XVuygA==
X-Received: by 2002:a05:6102:d8c:b0:5ff:d192:ff2c with SMTP id
 ada2fe7eead31-5ffe6213645mr3556252137.34.1773043058690; Mon, 09 Mar 2026
 00:57:38 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 00:57:38 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Mar 2026 00:57:38 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <2s33j7wg6ehizvdoz5fggc6kfa5byrs4yg2hk4fvwvfjp7nigo@se7fhyaknqqm>
References: <20260225-gmem-st-blocks-v2-0-87d7098119a9@google.com>
 <20260225-gmem-st-blocks-v2-3-87d7098119a9@google.com> <2s33j7wg6ehizvdoz5fggc6kfa5byrs4yg2hk4fvwvfjp7nigo@se7fhyaknqqm>
MIME-Version: 1.0
Date: Mon, 9 Mar 2026 00:57:38 -0700
X-Gm-Features: AaiRm539ncfsVFw5AP9VoOkialmaGifm5bQJ7k_NAlY4DMAWUCQTSVmir1fUcmo
Message-ID: <CAEvNRgEH5X79zwFr8t4EayDccED8i5__-oFyBZ4nb_RkX8826A@mail.gmail.com>
Subject: Re: [PATCH RFC v2 3/6] fs: Add .unaccount_folio callback
To: Jan Kara <jack@suse.cz>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, seanjc@google.com, 
	rientjes@google.com, rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	shivankg@amd.com, michael.roth@amd.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 43C798000C
X-Stat-Signature: wbcix4hdwwhzptqa8r31obu8xhdpmsx8
X-Rspam-User: 
X-HE-Tag: 1773043060-60434
X-HE-Meta: U2FsdGVkX19swoah8PL6HK8d//tN3+1hGVEfI+8j3CL2X61TqPfvs4rlwmP27rCDBUIz1N1AAZ64OJcq4nDrEiL1u4Jy/U1bgIwIuOKc2b416/SR1WLqTKjZ49WNRj3+ljK3AN7y4ZRw0s/vSKFLXa60vFxSBGuGRpHbDhCvXoZEwDaD+oY0Q4NdZfZ8DWXtK4XlYsEXiioHX0icxEJkoB4YGMFKuzTydFqloHpKPfKUXf5NY9/f/bCHz9piSEp33RJN90fzR5nbmJdT+kGFabP8EXeZUQ+DTyu8paGPA9LoUFtZXc6+9tPMv3hpOMF5r8pRIvefvG62rO2F/jmk/Hg8B1WhV6KB2UjRjMduGU+cpU0k4BKFdch0xxOmNfDI8Slhaj1AoQx1ovVqrpkfhyRw5KvGRWtM1CsFm8d+yLhMbYX1K+P4fiwt5CmAeig9xBdk00mwkpvFQJelQlhlTOl/sbrw18H+cTBphV9Xb++ommtt3bNSQ6+nNpphlgPCRRG8WtAVqwx38RKtRL7itLehylzPmdPS0dDy3UgibBtnb/de0lqGqbLI6fJ9GwHnlUgHB1hVVTRkO48LTwyhdxuASsnamENPRFpaaxhnpjPeQR3aAtpjmCHvWrPXs4wSDh54x2LWVB36AyWnXHobj/2+9Bp/A0fXrHw8Q9+T73LH19ze4pfdcZDXLb2UDCeuaXlJ/VO7Lz4Ac+4cJxMUxr3HZZGGYwdkprYlf4hecF8+mcfpkMLjFY2+vGTfztMWsBwaMzqEkF1fi+Z+AobBEdMorNLI/SAA+jcNDTVHyXdiKUU5l5Dag7vqWR4TMLSsnfSwa1spLOrXWcDwQM2Q/mfaEOiXg/w2puYNzBYkEMw5Osppwha5ke0/h93ZyWh2EvQzgbGKDCauQ+TnseaWYnaiPDG9uv/CYhjmN8ec+Y9ur8lFcQ5cQXUejyfwPpLq0F1vVgi6wdSsNhVkZ5R
 f28LWtuY
 3QND8YEPcHwLTRPFFQbclw3HCjnBxhCBgOEOpx8DhdsB8Nda6tOUQO1TmcncUQZZVFiZF7PJyqtYbWqUQpoHU1DHbkFrrJJn/EozCbHIkePfGyZjz2GmfZLkHevmel2Jy3XjhDibxNBL0v8GyKAwPCZDaz4FjJH20brD1UuYEazqahyuV9sfFLXdR9fwfikiytdi5G7zllUuCFGgOZrJ0uWT/2CE5H+yjIM+wsTMupuMgI3q5GMtww7EkaSmNhbb4JKQYnPmdNFnsru+9zR1AqsIkkahBeYNf7L/ydaj7dEpbbyTg2KwR69gK7B5NSGa/umAKTkMpRRzkZiX4a3r/2brmg+9rtfnfS0DNK0fugrSrA9nmx4NoaE33NBqCOlQ5hw+/iiyxoupnWUw45jJ5XHDSaem0nR9Pk57H5Z/VqbTnjE7F94nPupTSjIXp11P8QGKB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jan Kara <jack@suse.cz> writes:

> On Wed 25-02-26 07:20:38, Ackerley Tng wrote:
>> Add .unaccount_folio callback to allow filesystems to do accounting-related
>> updates to the inode or struct address_space mapping, when the folio is
>> about to be removed from the filemap/page_cache.
>>
>> .free_folio cannot be used since .free_folio cannot assume that struct
>> address_space mapping still exists.
>
> I agree .free_folio isn't the right place.
>
>> From the name, .invalidate_folio and .release_folio seem suitable, but
>> those are meant only to handle freeing of a folio's private
>> data. .release_folio is also not called in the truncation path.
>
> But this I don't quite understand. .invalidate_folio is called when
> the file is truncated (or when the whole inode is being evicted from
> memory). Filesystem can do whatever it wishes there, not just free folio
> private data. Are you pointing at folio_needs_release() check? But you can
> mark your mappings with mapping_release_always() - it's there exactly for
> such usecases... Am I missing something?
>

Looking at it again, mapping_release_always() gates both
.release_folio() in filemap_release_folio() and .invalidate_folio() in
truncate_cleanup_folio() and truncate_inode_partial_folio().

Let me try that out in the next revision. Thanks for pointing this out!

> 								Honza
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

