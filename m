Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2BC7CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 21:14:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 140E08E005E; Thu, 21 Aug 2025 17:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8198E0056; Thu, 21 Aug 2025 17:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3F98E005E; Thu, 21 Aug 2025 17:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D63118E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:14:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97E5C597F1
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:14:32 +0000 (UTC)
X-FDA: 83802018384.15.C350C21
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2195E1A0002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:14:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hQ/2jRBd";
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755810870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ioUI8cmcz7ygE2zmwR75HDYpcdV9VBKvl5HcXVuFUxA=;
	b=vwT/EdHwCepYGQ6xqjPIvjWv72ny/OPa39RQRyaFq/nXgKlVfsZeOy8x7zW713Yxc4U8Hi
	0VBiErfh65O3OoRfTVhnAT9c7Xf9HraPmp5touqes04l3rVQ3DITOS3ynx7Iq5GSwivIm6
	VYyN0doMJvkDMt9U01VnnyuUV2gkpqI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755810870; a=rsa-sha256;
	cv=none;
	b=QKZoU1l/ppdP0IlRsCZQ3p5467fzBmDUuBEZhJmOS2vFuNqWA3MkOW5sm4tG4ohihxHQqo
	Jcd/3zEvhN2+SmHoYMBIC1Iwc0qtB+QD/8oplmN1myKgAiFyukHlx5RpQatAHoH/3sbKHF
	plBxtRU44ZYDAPpAzvTyzfTyZmzgFic=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hQ/2jRBd";
	spf=pass (imf19.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755810869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ioUI8cmcz7ygE2zmwR75HDYpcdV9VBKvl5HcXVuFUxA=;
	b=hQ/2jRBdvbTYBZhBfLXxIs8d3naNfM3P5T4mbMn4Q4DZtd2UrwqAeblbOPa00EhD5l1kTS
	QqUvOVKMMADJ3oW3nD8VwaORCsRwjsuGrsRVnm4IwUn5mOh7L3nA13AIt1FaRzxX2dVjHl
	axw4zlLVBE9XF+rzhrHvQEoy0/+nV+Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-Bj3-WuPJOCqM8AmrEZ71FQ-1; Thu, 21 Aug 2025 17:14:27 -0400
X-MC-Unique: Bj3-WuPJOCqM8AmrEZ71FQ-1
X-Mimecast-MFC-AGG-ID: Bj3-WuPJOCqM8AmrEZ71FQ_1755810866
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9edf41d07so668944f8f.3
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:14:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810866; x=1756415666;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ioUI8cmcz7ygE2zmwR75HDYpcdV9VBKvl5HcXVuFUxA=;
        b=u1RiwlwGZhJWBr0c8IJmlvO8BInGT+peQSX49T8d1mpI57AcBHBPk+vWZ/1qxVamra
         acb3/qyq19Iy+yVaW+7EihESBCZHB/iTOPwr1T+zqb0N4jE7OnKaFIq55t+ySfIKutiG
         xqV/OTTPeXwg86Ggcb5x7NQU2+JhvToLsELYfEfzUqbjei6RHHVy6B9byyMi7AHZnNe5
         6px0nh2AAKTbnuCigfdDBCHh//oT16mERMoU9Smjl/y5vdsxEaN78E65PqzUoQcJh+pH
         ZIKir61rKN6i4vCZ4aEVKnOrG3m/vxJgZCf/UzumcXFXxE9PThW/Vya+R+Iw+wq9Uzn5
         gBPA==
X-Gm-Message-State: AOJu0YyEHbwVxy69Ntfk6iSjxrcAJEH9m9cgoN/GzgxRttHZE0rDBI82
	bIB57C2AsoOZmJriS1Fgrt/uubAziADPRZQ223DGUliiT/z4aPZq6gVdl4G9IPIkDfe9VfnnYbW
	ZibHaIGgG9n7w6IVrGQA9baYnKO3WLcLad+fW7Fv/UDkLSUB6f1MU
X-Gm-Gg: ASbGncsE6QmmCJCBZvufARwrbdti0LlCj7UjUbZlfl3jXjwbxmhngrOZf+abClkUUSv
	I5NSiSs7VG3U9/JUx+v0/DTdk54wgpeORyB40uTqmPIQu3e25gVHfMflJXxTesUfUO0tNifBOV5
	sv4omQ+ZIm+utCI3DjdUfjrMaU5nGYxM1QSmevYK8QfECw7jrcHq/A7ATOdKEP7nVilAvCxXxxN
	0mHrQBlQk0dpJC9bfFqTIkB6eA51iNoJlGEyuVmleQfwcy/kHaeMRlJmSm1bVY2HQO5kqOKUREP
	hD1kh8enSlbgA8b4gR/5Q/jE/lWixJ39eVPPux8j04rqSayYTSJokigMzMAt/1TDl5k2dXKxdD9
	B0gkKITr9ve3+EbUPvy6J/8LdeSi3LnN6ElIeJZ7MBmU+J4aLMQec0NfyVtNGxQ==
X-Received: by 2002:a05:6000:2509:b0:3a4:d6ed:8e2e with SMTP id ffacd0b85a97d-3c5dc72c93bmr238262f8f.41.1755810865924;
        Thu, 21 Aug 2025 14:14:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfZR3J8xcLuL0M0XeCzgOw7Ipe4LAMzvYBMQKYFmYgqujJYVfH9z4RtyGRgLllHkn6SQCfAA==
X-Received: by 2002:a05:6000:2509:b0:3a4:d6ed:8e2e with SMTP id ffacd0b85a97d-3c5dc72c93bmr238225f8f.41.1755810865412;
        Thu, 21 Aug 2025 14:14:25 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f26:ba00:803:6ec5:9918:6fd? (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c4c218c599sm3610221f8f.67.2025.08.21.14.14.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 14:14:24 -0700 (PDT)
Message-ID: <8c6239a9-8414-469c-9b94-a43735b4e882@redhat.com>
Date: Thu, 21 Aug 2025 23:14:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] copy_process: Handle architectures where
 sizeof(unsigned long) < sizeof(u64)
To: schuster.simon@siemens-energy.com, Dinh Nguyen <dinguyen@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250821-nios2-implement-clone3-v1-0-1bb24017376a@siemens-energy.com>
 <20250821-nios2-implement-clone3-v1-1-1bb24017376a@siemens-energy.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250821-nios2-implement-clone3-v1-1-1bb24017376a@siemens-energy.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7_g8gJbWU2GOH6fZkeI3fcCHH9neLCeSj_ijCAbAitQ_1755810866
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2195E1A0002
X-Stat-Signature: a69n66x4stkdo7xsykrowkh6kmsr7ymy
X-HE-Tag: 1755810869-281852
X-HE-Meta: U2FsdGVkX1/nVAm/j3N7icdI5Tn5Zgy91XqO/7YhYCNioZDtKarjOcj2eZKD4rDcwiTextB3eOMyEWDIE7U0MT1P1YzjJJdVZhpVn4HH5fh1dlw4WvIbrBejySe5WnZlqT+HQ/2/ENgPG+21VQR5lE6kNdXtkk5C3X5RJx8Hv0iMpSQ2IrvzBw96fvr3K1bgdIS0ACJdGGNENlI7XdpUB6wvjhqwaLFe++g5sfkNtALhRO8BhdgTI6CBe++rZ1FZPmRRuTQ2+pPFgB3wvHNNftSmRWIoeCl4bq5imrBFeyK31v+V6fsyY+oNZFrXboSgZ9KIIcx+xd/BOvhxyBpCnXhyQLpHtpcS9jn3UtDO5+JNixl5CycpwP2W5Ji+pub7CGy1yj/lC3Z1FYzRwk6Dm/x69nckkQYpRfzXEuI/s+GE46oSVpPdWxnCOcGiVDeM69d1fkygyTbhB33zt345m5lUDFvNwRBUHl3OFrzXNQxc3fsXdj/arxqWjCJAtWU57tkcxAgCNqBmxbmfBbRw7QymTrJbDs2J9a7SHWNOMEB6hiG5ICNQY0JGDYsMy9mejMowuUc3b0H0EE3wwpJX2Zh/m6+2UgQfcrQGB3wD8z+gvDoXLYOqnc+pMSbyEaGgeyggmvqUjcSioeURN8OE3oyQwMeJZhZMFNuA9C86TZh3jf3ul9fFrkSy9tHCimUVTZxOj1E2rSkp6jGyvLOY3J0ulcfB8kTNl01Yr3uZ4rDgvfscCRNZUaah53AxP1dpIW6ywsWfUDtHzbhdNA6BUDuVf3qgDKywWd8woYiIi0OxBNL/onwuydEyI6eLVgmVDjZcWT4tIFQjq8WQd4n+22nRDYKA5b/E4gvSmEGblR6B8qePHNIyHmtfbEe8gctcFzckOLHd1idjOWuaJ+bPBBKKY2PvcMV69up/QxhJh+hGXTPP7zACgF9LYVTAkEEF+PmzQpXtO9v/F5Y4WDG
 aPJwoAGS
 4VzkFVaAXWevWfgm2t6c03I0QZLIBGLiHPqpJzd+yaHfWY2373FCFo5UPS3MEKEGJaArioAEx8bxxkFYoXCwybSFTUwijiR1/1VTzK89hK32yrfd3dm5WJz2PXt1fsf71tOtrBm0kRdMrUepB7RkXu8EcxDZZcMN3U5hvW5+po/k4nfePn6Ss3NJ8SjBcZ18e6CHV32jAovazbiPArfZVcTBRiH+CwTLk/SzGkHFBeA7wpo7GRc42aNtCcy8E/YRuyLzDjA6AiFzv80pAZ6j1DEWzx2STmFlZgZLtJF/RaKLLLO25OX+Kh2Y/RGLB11tf0QShnutGPv7GIYiFEKxdfuu4RNbxxrVgiwYIkUvkeVmopWhDEeCb844MXPsATE+EAqwdNFb08nSpfeFd2Ao14U6oU9IMpWCwHmsqqUMAsqgM9TVKo6H/1q6yUfPjlHEu15g4hnfkUhki7T507HRJ9wk7HT+Z7bN3j18+5j5pHihYSaswHSxu26uCwKwCYU31QgsUWnZjyx+YzVKrwAxk6wc8dn11conis0Rq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.25 13:27, Simon Schuster via B4 Relay wrote:
> From: Simon Schuster <schuster.simon@siemens-energy.com>
> 
> With the introduction of clone3 in commit 7f192e3cd316 ("fork: add
> clone3") the effective bit width of clone_flags on all architectures was
> increased from 32bit to 64bit. However, the signature of the copy_*
> helper functions (e.g., copy_sighand) used by copy_process was not
> adapted, as such, they potentially truncate the flags on architectures
> such as nios2, where unsigned long is a 32bit unsigned integer type.
> 
> This can, for instance, be observed via failures of kernel selftest
> clone3_clear_sighand, which attempts to trigger the conditional
> 
> 	if (clone_flags & CLONE_CLEAR_SIGHAND)
> 
> in function copy_sighand within fork.c that will always fail given:
> 
> 	unsigned long /* == uint32_t */ clone_flags
> 	#define CLONE_CLEAR_SIGHAND 0x100000000ULL
> 
> This commit fixes the bug by always passing clone_flags via their
> declared u64 type, invariant of architecture-dependent integer sizes.

Sounds reasonable.

But is this actually something that is already exposed before patch#2 on 
other architectures?

(I assume above output is with patch #2 but without patch #1)

If so, we need a Fixes:. If not, we're good.

-- 
Cheers

David / dhildenb


