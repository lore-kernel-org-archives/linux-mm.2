Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27CB6CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779006B020E; Tue, 26 Aug 2025 08:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72A136B0213; Tue, 26 Aug 2025 08:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB386B0246; Tue, 26 Aug 2025 08:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7CF6B020E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:50:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01089C079C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:50:55 +0000 (UTC)
X-FDA: 83818893312.28.83EF326
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id AC746C000A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:50:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X2kLJEe5;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssn/jpuXTRjbOLCPQ6KT3z7CgPD8X2cfIkgpAEmxoSg=;
	b=4dUgRUHgS0FctkJek9uI4l0huCr9OjfxsPahpfVYZp1CwmwysJX8fvO8xmuXjUxF0fdb78
	4lEZE2Fmz5ZcAiefH7QicFK5RzhILHt7/B57Lpiq3qDlL3AToYaor0ZPQO5UBdPmVZXafD
	S46vcWDDFydH7vb70p2pipVQQxKDd0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756212653; a=rsa-sha256;
	cv=none;
	b=NAaOxss7kFMNf6oCVhrnD5DHv3E46VOVe7q4rEKon2hI0KH2kGVONJgZU8x8CUIU1RS0zg
	iq0UBA2ca1hAt+76xRqYaXaH1E2yg4CcfIZ455DfLKlYWYqUJgOMCsyz0AQMZj/MQqQZnO
	VZFGC+KaqaLVBPXrmQt1XKudPK5Ki3g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X2kLJEe5;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756212653;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ssn/jpuXTRjbOLCPQ6KT3z7CgPD8X2cfIkgpAEmxoSg=;
	b=X2kLJEe5ezaVjbPj0FiyFs/pkXdYyQnDw+roKzHSviPbVeNAytISbLDnVyJfk7LqU+z1ha
	cTIP8OXRUqJFT7BbQsyJbmvW9VgCGPpYHV0+b0RaSTgTMvHrpm4m4A7AMiA0MSy48e6YO1
	qjI0xaJINUNsD24UcbTDqRYgZ4fgLs8=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-oa45uJtbO6qwHNnEumAGsw-1; Tue, 26 Aug 2025 08:50:49 -0400
X-MC-Unique: oa45uJtbO6qwHNnEumAGsw-1
X-Mimecast-MFC-AGG-ID: oa45uJtbO6qwHNnEumAGsw_1756212649
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3c8406fb4b4so2305265f8f.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:50:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756212648; x=1756817448;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ssn/jpuXTRjbOLCPQ6KT3z7CgPD8X2cfIkgpAEmxoSg=;
        b=HpdQ9U06R6dreZV5sbNUcfEyXdPcX3YdpQixjPu5Y9xMg3gSsXoqDT+OCzx/edFLhx
         Bf0+9lWZ/deVe59LnoFA0RYsJphhktfYj5zjZ72Y9CfTHBNmx1qiRZxUCBYWY9C8Hmdf
         j1sMr5fuUnBRLxcGs46/xqWI8kcq9Su8OtHDoyLEoTImOQhCRV2zah/rcN0Uyl/WV+gy
         bHanjXVYQrBHez3BVEwFMBQtnfwFCoiF3qmRN5Uspbn3TOJTxfk5OrzK7srMXbExhyXg
         kUPv0d4NiwO8F1vQ4uWEi7Aucv4fx7u6GZA/+R8pTa4FBmqQAITQXAPtCLnC0O0jPYhn
         GKoA==
X-Forwarded-Encrypted: i=1; AJvYcCVa2rq0qeRyNurvAvirORYZwoAj5ILT3StR/Wi135TQLIRznpA69BClejdwSO5IYsWg6iJEpImDSg==@kvack.org
X-Gm-Message-State: AOJu0YzKLfSFhQ708+IRQgvjZaS6RKYHxxMAtbldPSpZoiELxXKqJFSp
	Kn2DmsxJW0CL2GyV3YrkfDRrYS4T9k8Wh6DrIu4u2w6jRBqPkLaD76/zKVxRKQQRlg1Bpu3ftGn
	FHEkbG+CKx1U2KklqLZVk8Z6I3MmKYK2jlPwxDlEyXYU8W4S72iVO
X-Gm-Gg: ASbGncv1orJLEIz8DQ5Ud0dML+nT47mY0DNsDs7yEzDR25JOyxatuq8++lBicLc9Z27
	pXon4XCrb8O4qH7EGwYlkba4g7Z+DglZuGMBGClA8q6kRhRUri/3Hz1e8Yed2JNLrJUwguWybmi
	fHMSa553tLVcTPJ3K3FUWeLh3ooSuLyDthCWbrg01IcYK/SKbaKRi8FkNr6Hvzve5khvsKI9wp+
	vyRmjKFTLa29qggDYY8lgHD/RZSonxR/2pafnLS+bFqLH+b9rEjhoIBowkLsbSsb5vFIcZIEBwB
	LQal7R7EfiVc5etUzIIUqit/MhFis6U6hofS4X+NdhSR33WLt05GdrGcB6nVsNzEi+YAJynHQA=
	=
X-Received: by 2002:a5d:5f44:0:b0:3b7:905e:2a32 with SMTP id ffacd0b85a97d-3c5db8aae79mr12764871f8f.12.1756212648423;
        Tue, 26 Aug 2025 05:50:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKaRbfwxW3ofi9sdc0bDyu+R3TROfU/xLFmTL44QoTju6QRPdZzLwxIbs9zh9UfnJLKt9uZA==
X-Received: by 2002:a5d:5f44:0:b0:3b7:905e:2a32 with SMTP id ffacd0b85a97d-3c5db8aae79mr12764790f8f.12.1756212647793;
        Tue, 26 Aug 2025 05:50:47 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b5757477dsm150256885e9.16.2025.08.26.05.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 05:50:47 -0700 (PDT)
Message-ID: <01fc5c69-b1fb-459e-a96a-3098829f20d8@redhat.com>
Date: Tue, 26 Aug 2025 14:50:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] mm: convert prctl to mm_flags_*() accessors
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, "David S . Miller"
 <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, "H . Peter Anvin" <hpa@zytor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 Kan Liang <kan.liang@linux.intel.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Matthew Wilcox <willy@infradead.org>,
 Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <b64f07b94822d02beb88d0d21a6a85f9ee45fc69.1755012943.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <b64f07b94822d02beb88d0d21a6a85f9ee45fc69.1755012943.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SoU7Rg0BsiFKY8v_SHr--11BKWdgPMBXMgu6Mddlf4s_1756212649
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AC746C000A
X-Stat-Signature: mtr53woo51b5e4fy7kqbk3ckttae3dft
X-Rspam-User: 
X-HE-Tag: 1756212653-298743
X-HE-Meta: U2FsdGVkX19BcS1Twr/UsgOgvLkY+P4h415kO5wUV81Rj3rBrz352zmzBGAprVjRRPJwm3L6+FXXh8fDYX1mMjRHdzhEB8oo4lTJUdCTi7RyWv1Cwvxb0vfEhkMr0s2Sx1gQnuVLYQ+6o84GA3ft54U1FQGnqItvng4e5izCOE5WK9c52EXKklWdfknOVWhEIPgorUmg2G6D0ZnDYi++LiaBSApOUiSWFggQdT3EbQKBhcAL579BOSsxXdtjj0dCjNQi1Gz1zamszAsUXHwokzJsSYM4YBh/Hlm0CSKZsIYCVCkxoDX0EAlmJGlmceeb7hX8CKSzO17iO4T5AhqsCvp4oULR240ptvXi1dDCm8HHl3bVXJmbS4SsqmxQBMYRruqNZ2O4k6De5IBKbgn705LkSmDq03+IMiE79VoIpLAMlA6GHWkxJD7bbzVV8JvmfLbmZ2MibGCf25x6X6eCx2400niG8XP6jDkFrDmRrkxrsMyzS6AxEsUFrBIzigQyl2JCep1/op2gZFJnOYgAAtTNR8SpvaZbrV0YQppyKslhp2Fw8R2QvBWvZiCFNZQXe8kvLcHAxi2IEGc4p+A1T9RkdHfIyXYEWTi8Z8v1Y5OSBknzMRoA4XxqOun8bbjobacvcctLf9D3EsHrtGqSIMvXMPUPKKTgwiLUjx01++SS9P64XqtmM9bpcEs253rvx1sPKUfWHfPztM5naggqiKbIq0elsA3IttXnM6fmaz+N7YuT1dvwb9yipd6VGDm2Z0M+C7EK6Wy9UDfbI/9k94mKpH2QNDEzgbwLPavT/v6mOrK4ys6fHh17T9XcW5IKbpYqHhBm72s1hZFNzk6aPlvWEUKygI7LA1y7Dd1mbC0gUFIxi8/m1NAH1w9/K7nNAQ3wYCjvs9U9VdRrdyZViBQ1f43kTaQ7MYLe7XSuvdz0s9eL6044TvdAo3OINnPgymloRKLC0Lo4NleR3A5
 MX64x0PD
 s+UnqrgLWaLkl6gIpqsqLcxUQQtj8L6aOkVcfFKai4kJN1ZQrvldrVN2wYuINj0ai86lLg0VhVZDzsXnlWsHA+w/i+J8smfZ5LF/D8vXwfDJUp4vWD/oxS2u/7r73h7/EhfSXaXXWMzD/Tr1yp7VuQT0hcHH0WtgUw9SJgRGz3EU42QVJlhrYdoUzzJk27w+osS0scFzzOSGnxot2w7B1S6CBQzdkTKtXFfKOp8gpzJe0+b17ltyh9scMuBde1ciOrI5csEN/HUwLG0WtjWp7WSvYLC8m0t10UlwtHaVHU5BYBgiBrrkGrOTdIvb16Ma6uaDB1tBPL9hA6yOmlXl87/9lx80dTig4wcP5IunImeEndDOV38A6YuXdnXnXHy70aKCk1PTx+nnR5OxX6bIIdAHKO18hQVSsxHD1oGp9d4qPeIr7YXp3ARvLuQVnwYf5+2AHCWHnrdWBoQnY1Rx9sRIAyTMUJEAxT2vwZokhGgN12Pk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 17:44, Lorenzo Stoakes wrote:
> As part of the effort to move to mm->flags becoming a bitmap field, convert
> existing users to making use of the mm_flags_*() accessors which will, when
> the conversion is complete, be the only means of accessing mm_struct flags.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


