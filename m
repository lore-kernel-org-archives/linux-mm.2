Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5395CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29A926B0144; Tue, 26 Aug 2025 08:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A076B0145; Tue, 26 Aug 2025 08:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA726B0146; Tue, 26 Aug 2025 08:51:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED0AC6B0144
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:51:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B14B0C0799
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:51:43 +0000 (UTC)
X-FDA: 83818895286.06.BC47225
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5E9734000B
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:51:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fsCb1jux;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756212701; a=rsa-sha256;
	cv=none;
	b=FcSm03LdQOlOHT1J6x/VsxllgI8gga+oVWY36TNlP4YJpRNT+cK8JCel57VucXsLBX7wAI
	aMJBH9R0/lZAC9n6XmPNHJALHO6jxO+LkscD75trriqaJBJAhhqj2c/k/bwvYey6xKzuU5
	rX90Cdiu1A44MGacUNn/+rBW1SNNPZU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fsCb1jux;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ssn/jpuXTRjbOLCPQ6KT3z7CgPD8X2cfIkgpAEmxoSg=;
	b=VCGXCDzrqSI+8MZJ3vTvxxTcOijiN+Nky5exJ+OehXAvuJVeCe6z8Bfyepnb6zqBVy+1l5
	1SM4paOwibHDw58jMrA/3PGYyvD2JDKG24yKkIvS3UsghJP6QoFNZqakVa0uiES0J5dPO2
	Z1iNhEV9hEFXKdaMTSI8EFA3iFKpFTg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756212700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ssn/jpuXTRjbOLCPQ6KT3z7CgPD8X2cfIkgpAEmxoSg=;
	b=fsCb1juxS05jfkSN7jIQS1E6Xo2DFEe1au7x30LOKZj9/Fo+uVPUOfLGZg2zAmZW14HAE5
	lpSf+bp/fryfv9BkHb+8W/e5oPSaS0MKKmpf0G7LbJEYkNfueHp4cP2AsAjWt9Xb3Jcr/n
	niAPLEed5AgO++qQ/Uz/pbmZMKDVhiA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-l5MLiGoeMpOK3rsdWqDeWg-1; Tue, 26 Aug 2025 08:51:39 -0400
X-MC-Unique: l5MLiGoeMpOK3rsdWqDeWg-1
X-Mimecast-MFC-AGG-ID: l5MLiGoeMpOK3rsdWqDeWg_1756212698
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3c68ee43c76so2796538f8f.0
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:51:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756212698; x=1756817498;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ssn/jpuXTRjbOLCPQ6KT3z7CgPD8X2cfIkgpAEmxoSg=;
        b=KTmHr3do7GBd15nFmwjq/IW7J7KnhIUiBF53QKDUPxrTKkR84CWIeeJm4uoWN18zgu
         PuT7RgCrmlCkvi9eEpGf5yPNfSti2jiEwNO3fwfQqoZzxkZueAz6PLIuI4a/ydq6l8/n
         VFA53aPTbWiX3lneeOhrQsUNCLUj4FTR8zDecsVtd4w/Z36LzhtJ8wyluUFDU03X+ck1
         JUAzF9LFazMuCODzGAswwKHmyJ2fBaUbtz3gm/zR/4qMTdDTgaJ30A9EpxGx3ioy8IeR
         pbBna+Typ1kRLHnXe/Ozn+mOzQ6hKnZvP9EAglPnIW5GcdrVKrZUigckrjjBR1SDS4xv
         kajQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwhz1B5HtfZ56379l16HPeTc7PPz22Js66u8wTgfUhnjyILi6ZQ9qVKNNAcEkhbRCTr3SGm4jK2A==@kvack.org
X-Gm-Message-State: AOJu0YyFbW6JritYXl2eAdJ209l1+MpO6nuxTSVBRF/N/bAS9/kbJRNU
	nplSI9xP3sv04ooPRT2ZN0n4NzxotZybFDKZijHzCucA9rE7eSIR1topBoy0wlYzuL/6bMUAh4t
	JN3tUXJGkLNY5VViwSgDvorqPPTLXnJgt6ip6WbwJ5LdHYKy2Zvf5
X-Gm-Gg: ASbGncvgnhnw5fTkpJ5iXYRbvcO2ihf1swdwwby1PvPPdi+F24oW1tPHRsQKTpYm3ja
	mJhFrAct6/UJREPo+oyujx8tlkp78PjYcWLdKvrI3YDHpB+OSAMtB0MOjXoYIX6Zd5gmCbE34lp
	A1yx+Dc+VUxn2vMAod49NOwOHLOXZGV03N4qCATRXuvGz7WTAXuHMfMBXghjFn5jzBUgJfA9tIe
	KYYim0apck1JTydbDVqnFyPwU5tHM9IjKEZgyMoDA/ZVfClq/F3uKBtx+xfr2js+ObJvEU5769d
	/fL5lCu5f5O+iz4fqZugI169v/QrhaVsHyJPUwlmkdCB22pJ4w38wqukOmPrUdERpGO6x3Eztw=
	=
X-Received: by 2002:a05:6000:26c1:b0:3ca:a190:c45f with SMTP id ffacd0b85a97d-3caa190c7e5mr3558068f8f.16.1756212697941;
        Tue, 26 Aug 2025 05:51:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyjBgPsOULlt/GMGVomIiEKxcepINJfoXSLaYtklo9AIJ7LYUfR1QNVtypvSUKbPxSGG+sYQ==
X-Received: by 2002:a05:6000:26c1:b0:3ca:a190:c45f with SMTP id ffacd0b85a97d-3caa190c7e5mr3558017f8f.16.1756212697472;
        Tue, 26 Aug 2025 05:51:37 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c70e4ba046sm17461806f8f.1.2025.08.26.05.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 05:51:36 -0700 (PDT)
Message-ID: <d74caa51-6bf7-4f76-b681-cf60826b139d@redhat.com>
Date: Tue, 26 Aug 2025 14:51:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/10] mm: convert uprobes to mm_flags_*() accessors
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
 <1d4fe5963904cc0c707da1f53fbfe6471d3eff10.1755012943.git.lorenzo.stoakes@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <1d4fe5963904cc0c707da1f53fbfe6471d3eff10.1755012943.git.lorenzo.stoakes@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jMKa0x-bnMx1eOkXsZiwZOhnqmtZmMLNVrqRHyTyTKs_1756212698
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5E9734000B
X-Stat-Signature: y54c6s8nj6kaeser6gfg49o7un4xqdnh
X-Rspam-User: 
X-HE-Tag: 1756212701-789488
X-HE-Meta: U2FsdGVkX1/lZDwqPlDdMwwtM4bDz/6RUsa213CAJdxxyLa5gqHLRRxQR8u2hAIAobrzMdQh+jXALQXXIWseCojajwYz/7I/ZHUK0SquK1Z5WjR+2CgYipBlLH+SSunLc9okXD0mMbJ9CJtwXwcqL7yDllYD4mh9YaF4YY485jTQEVel2P6g4Tq7Us0IvwfjRVRyz3rU4iFobqrRU82Z84CqmE75tUKX2RWZBDvqQB1jSNxp9xvdqDCYjljNC6iK+mq3AeL6ZbhOZp1MsVxb7ZLG2QwsQZbMIDOWU2QTjbsccrcki7RMraHcbF9WSUaMsWPxb6inlqAZm+Xew+e3JW8AjsYjRjNgWXbqIsQsZys59FfAobvzeTpJeutKpAhk+pErmy89cVaExg039Vod6uE6nOHJ2CupKCCiafNr9yBk0e5h45O6tNlPSK4ZgNxtnWI/huFFDkAD8bKwLV2jJpesbizTx3GEMhvK8s3gKwE15dFaTI0xdTWZekRgDC4BSkpUHiiA6NhXqmB5JsF1kYC6SbAIUDC+kaV7PwJJWSqIveJH8fCiIwALO2Sr9KWRb7qi1UBLTyXw8TJxJcvkuLxfT/ojsUdOlYPqd7epQA/fU9HDD39xc5ckuawDf8SG2zatNWNBesVl+5a1/zTR8Tsgw/cm2EVdJ73WkTAKTF3JCJblQgnMHWyhwYp+ysfk19YqvPqqP8f67aTUZiAs54ZxxfKV203QUhY0T00q1CdObLvUS9KQ33ZO0aNrvviCWqn5KJCtdEaqytQ8UlX5jacvRNNxDIRhKdMR8hxuhHm/opiT8KsWl5ngomNPFIM4u2lvesJcyB+wnwnmcJtYniTUi7usf1z2wNAmPq0zCHuCL95mFaadZx3HxpBwTZvKH/crPCSvmptY7ASTodwzNVbUH6FI1Kywg5mra2NZ51IkbEYkDBmFnU5lrkWNuhPRpSLFZlcQIeu0KAYlB/U
 Xyq63Qzg
 XlZHqZyQmWLTmcnrqJT5tDFqth0BT6jhXqD25pPscU4fVMMSM1nxo1MzWNBuTfC5X+q4yjgWy4oEqc+HMdWFFvia7FpphYXfehHlKxtTcI9SdiTUgsBzWuQML0iJoSfNPayyo7MSw5dLjY+YHaOUuo81omDTTmxFR9qKCB4769dY23VL1Ns8G/eSw1J+ctfhnYEbvhCgI5t2Ew2o8MJHKdusNQ5Hz9AFYmjXhcvGSHfCUlZlpvi8VRRDpgq06nVmGN4lYC6Cs+ti0Sg+AAwNAT4m4l00+bW31xQwSlQgSKwD1xWpwWBjMgc7KGmxcAoql59OQQVY5dGeDjOGximuvqqR5YCYhXqhbQ438N8kvClLDr1mdmg5YHHt6TrNiwlb/vNJWzez66SVVs3apMsvdzK2VT1eJmb8oekDHwtxsYvsxVAkfdETjRk34kpFGorVmoxrwpZGiA0uWmoDPTeFUKC61OG80CdD0JgfKV5sxFPI3jUY=
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


