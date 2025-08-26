Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88EABCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E3E6B0203; Tue, 26 Aug 2025 08:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF026B0204; Tue, 26 Aug 2025 08:48:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F426B0205; Tue, 26 Aug 2025 08:48:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80D416B0203
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:48:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2F7B311901A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:48:52 +0000 (UTC)
X-FDA: 83818888104.24.A8CE4BD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id A0A6F40014
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:48:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NOAeMPJb;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WzXAZ7DFQn5tEjgSe5zwh5V1BGLVH0hi4yYzCVLl8IM=;
	b=NTrJQqASq/ERnLfu5sP9q9au9yRraSyribS78dK0zOei+qjBetKxPjv6M5EH7R8OiDNkdR
	ZiIbSIQoV4bzGxTCpo7e9ths142AwZFkyd2czjW7cI0HoUyBbPkdCArdpSNvLtFSvRrU6R
	7KeG3GnQ+MkU++f52ILUeqGirC2gREY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NOAeMPJb;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756212529; a=rsa-sha256;
	cv=none;
	b=FoBgEa0UZ9hmiRpWeTPYl63U7e1+qdel0NUQ2EA7sq5IPC2ZWkJ2ODXFthKeGtYYPG+SR2
	MLegfht1hHyvUmJYDSAT5vhClomdF3zsPcY5Xl+60YJJgI7gwwNk+Nnchf33iVeDrIVKCu
	2rRakL0GrfLdT8nIILbpx0I8+RGgpvk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756212529;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WzXAZ7DFQn5tEjgSe5zwh5V1BGLVH0hi4yYzCVLl8IM=;
	b=NOAeMPJbktZXLe9HmqtkuXXZu+L6D1pijeG3q2hWFcQ40H5j8rZtedVFPVvAWzkHM8+Kce
	He6kfyg/oayS6syccvFtAmUf5gnuDngxdmRMZDMHcIqtwaan9xxFVj2okPupaZWOI/F1iA
	WSgBGPJSjMzKCchemzeur48rJbvvs+Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-dcWhbUq2OHG8AacOlvDlDw-1; Tue, 26 Aug 2025 08:48:45 -0400
X-MC-Unique: dcWhbUq2OHG8AacOlvDlDw-1
X-Mimecast-MFC-AGG-ID: dcWhbUq2OHG8AacOlvDlDw_1756212524
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0071c1so29509185e9.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:48:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756212524; x=1756817324;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WzXAZ7DFQn5tEjgSe5zwh5V1BGLVH0hi4yYzCVLl8IM=;
        b=JRQXkyzGVkmEFEmgXbvbtot3MTpyFGHT2HNWjCqeskyDKenM0uD2w3AuvRWWqstIWu
         WkG2cQTLVHS7UQGf8K0Jx6XlQnvHFMhf9rSbrARIP+lJ0YOD8WPlQG51bvhl6LtimbbS
         OAkTmy3ZsoHDcWG1ljgTEZ/nKN0QILlKTWtTI3yOgw6Wuoh5WOloLIsfyVMakRVhXCJw
         HQj6yiEYDx+UiWOvYX3dKiLFJ19/198ecyY3qWmaCyM9uMZwVx42HYQPdXVHYZmseVG5
         D4/jEyFvykdodoc3DHtk+Hs/gy06YcINIpA6+8S29tSDufFBa3EOIH06rOl3kppeVEux
         vn9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWFkPjdmYIvLm+g3D7k4NGcVOdjWpy9Lpz9QnlAK2y4EHgPtIbkhmxwe9U2ue5BY9W+FLb3NiAswA==@kvack.org
X-Gm-Message-State: AOJu0Yy0tWq7ewAzg6VR906em/hVR68IkmeIg9/KlIGmpTcM/8zvpg9g
	fXYJ6brK/l9w3A7QV+Cr5aucUgrFH6F8VAawg0WeYGxuq6Lbsw3gA+0ZKVPkOsyyVDJnyfbBhYR
	BkpD25VBUInMDGYIKtc20EPnWhDtjLNIupCTyunpacDWlNgw/sjaM
X-Gm-Gg: ASbGncsQT32gtCYdk06CCHtL03n0vyR6RWXfWIo50kQjflWAgrH6MZhkNBUK5RiuCX/
	Tazd9rs951xgSQr1ARcu/pvZKIhU2F+tjlqr+MB29u23kXFuyVMboYZH0bu9QWXMRZEHHOLcDbN
	Dvr4UrE1PsCpWDTE11pXh2bqC2cuQi+JfK+RVifOMHq1SvSAvaQjvWh4aFLiCfbPRk1PCPjo17r
	pZ3dDzN0s7koHgD6FSfNcp+BQIRPefNO9qr14uKdKpYG5iDU2LxvLyxRG1ISChg+xXlH6SKvyqo
	L0tjUZs4YVVxi39QcnMBOAduV46jsaJHLRnp0eiuQg89JIuN7+WOP6Vgq8lif6B4V8gz6ZzXAg=
	=
X-Received: by 2002:a05:600c:198f:b0:459:db7b:988e with SMTP id 5b1f17b1804b1-45b517a0878mr130096405e9.13.1756212524174;
        Tue, 26 Aug 2025 05:48:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2YoOcVF2P973BH13lOX6E+LS8uY2syMjE17Nq71FWv2KBY3X93wWZAQgPt8EZXrsVzrU55Q==
X-Received: by 2002:a05:600c:198f:b0:459:db7b:988e with SMTP id 5b1f17b1804b1-45b517a0878mr130095885e9.13.1756212523643;
        Tue, 26 Aug 2025 05:48:43 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b57492878sm149364615e9.19.2025.08.26.05.48.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 05:48:43 -0700 (PDT)
Message-ID: <84ae113c-3bf0-47cb-913b-45c75241a805@redhat.com>
Date: Tue, 26 Aug 2025 14:48:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] mm: add bitmap mm->flags field
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
 <9de8dfd9de8c95cd31622d6e52051ba0d1848f5a.1755012943.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <9de8dfd9de8c95cd31622d6e52051ba0d1848f5a.1755012943.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: foViE7jHHnsgaTgKP-Xm7izkMf8aGPHB5bxoZfRgls4_1756212524
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7tfehs437ngr75f3z97d1kt5kowfoa4i
X-Rspam-User: 
X-Rspamd-Queue-Id: A0A6F40014
X-Rspamd-Server: rspam05
X-HE-Tag: 1756212529-866129
X-HE-Meta: U2FsdGVkX18EXTHFmxPjH4CCr1BaxDU0B+AJDWfGZkXB8sdkTSKd7Qx3FGzzNX+bluRNoH9qcZvwk3NOq9lX6CKriUPp6CVweSd1G5z1Yvy7H9s5QwxBIbxbl6GUeMCtUyARrsuVaJAHzxlAlkH8/vRGrc85Lurv61ZCoZ0pZSYJYTu67b2QgDGQcIvERV8xtanW0BdI5wb3X3FRtS3+CtObKh+M0sjyqwfj2ycBplroczYpPyqf8StAKYlE3066V45xZD+HKAkI2A3CwZMFXQHjh6Cc3FFn2SWnRTAl4+GeIRCRK0FkB8vJRMUuaRhTFstz8jH9S5YliJi1oLpLOonExCyGBQVgJ5RuFXFu0KR9Jdd6fpk5ihoUzMjZDR0jGGQvek/tX9D6nvabDaRnA9SBCV7FbtpfOWQRqVMlhEKACrJXtfsDtWgg09rXk/u3QvuswoNxy8rICCKveNFRttwoGS4gq2WMeXNdAxu6jleJ0fNytaMcQAxS9vgaullWK1bkqcAECuM3WQMQl9Og7IMK7sWzcrgJMyQWJAvI8ec1DS/zAf3Xie41gdpf04u9VUc8puP6uasCcoj4gKghXWT+M/nUAKBzfBrLIfXynijVysEmZeX2LKhxrLLjfesJFNmaSErVYUoFB/3yDHq+SIbciHLZuFDTIY7/Q6zuczX0oNYoV+9Xf2PB+vYO+iT36cDSSCohrHpXFSsnrdzG4cvk3ZCo+xKRadWHvj+1fytme19bbZY4a38twjkHcQTnvV4S/MLLOSSEJQ/uIBZAlNdmF7gE+Xgqfjq8MgRZW2yhrClhyMDU0uYI63RaJRbewmWs8UEOmP3YXS3LHnYzANcrmsTGAIHSkPWiUBpM7v4706ruw0emzHdcGIpoe8jyTQCGjWKlvapX/Pb2r+g2kTDksdE/rjqxK3j8wsXDsNYzjhLGLMbpPndeJItZFniVEAFNoYFosx7iAwgZ+Ec
 UESarYtD
 4c4PUpRm9K855eASuH5LGTkHdIAdH+vKqsCyeJpow1yWABCZfWVxktSiJ8fBjgJ6Q0Wpy8urIcT1mnJq3DpA+ClGjIvQqs2WcQ1IMXUeQ9Gf0zHW3g2de3PurQW49YBtdiagBfsxYTje3GkJnIcHdrSJhTzBbuhQiJ4hURonWIifZq9mdhM2dVmu2IHeabmLORvTPrhuN/gtOMZDyb1ZrL4h64fuklkOF4+S/e8kLEeHHd5IfdJ0DZhKFZgzDnLKbfArWfEao7rQ/K/u8zYw66ZG1gULgiw3lUXl671MWogumH+SHyu4xmOy0sIu4DydpR0ipeTsKiSIlOnKG8OM1LMc+vgZg7P+1YFepIavYWt95Q0CKSUDGpeUPF4q9F5wcfJD4nohG4ZUqbYGQliYDd5HcpwPVnO62MEo9s4jcXzmLG2sD1KPT0JhIWWSvvb8jQeUi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.08.25 17:44, Lorenzo Stoakes wrote:
> We are currently in the bizarre situation where we are constrained on the
> number of flags we can set in an mm_struct based on whether this is a
> 32-bit or 64-bit kernel.
> 
> This is because mm->flags is an unsigned long field, which is 32-bits on a
> 32-bit system and 64-bits on a 64-bit system.
> 
> In order to keep things functional across both architectures, we do not
> permit mm flag bits to be set above flag 31 (i.e. the 32nd bit).
> 
> This is a silly situation, especially given how profligate we are in
> storing metadata in mm_struct, so let's convert mm->flags into a bitmap and
> allow ourselves as many bits as we like.
> 
> To keep things manageable, firstly we introduce the bitmap at a system word
> system as a new field mm->_flags, in union.
> 
> This means the new bitmap mm->_flags is bitwise exactly identical to the
> existing mm->flags field.
> 
> We have an opportunity to also introduce some type safety here, so let's
> wrap the mm flags field as a struct and declare it as an mm_flags_t typedef
> to keep it consistent with vm_flags_t for VMAs.
> 
> We make the internal field privately accessible, in order to force the use
> of helper functions so we can enforce that accesses are bitwise as
> required.
> 
> We therefore introduce accessors prefixed with mm_flags_*() for callers to
> use. We place the bit parameter first so as to match the parameter ordering
> of the *_bit() functions.
> 
> Having this temporary union arrangement allows us to incrementally swap
> over users of mm->flags patch-by-patch rather than having to do everything
> in one fell swoop.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Incl. fixup LGTM

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


