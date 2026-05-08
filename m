Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4412CD3445
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 21:21:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE33E6B0299; Fri,  8 May 2026 17:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93B56B029B; Fri,  8 May 2026 17:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35D96B029C; Fri,  8 May 2026 17:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8C16B0299
	for <linux-mm@kvack.org>; Fri,  8 May 2026 17:21:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28DF4A02B4
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:21:42 +0000 (UTC)
X-FDA: 84745524444.01.1B78186
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 31E7180008
	for <linux-mm@kvack.org>; Fri,  8 May 2026 21:21:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=phzlvt0r;
	spf=pass (imf30.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778275300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwVpQtg2nQbOTA132JfDdSVfFAB6KCJ3Mceieu5x3bI=;
	b=pxSaOny81eGKodX1T59SY7ise7Qg4IXVi7Xza1JheIqM3WERWg5EV3XjKlOqNMGiG5l9GY
	xehhSOme81FVzKzPXTrhwo3B4hE1PXbb4jRxl6bZRexmleThSFUl9WnyLpur6XD2hrECPH
	T5aSs1e5fyOlEg2GitgrgZ6x4nrJ/xw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=phzlvt0r;
	spf=pass (imf30.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.46 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778275300; a=rsa-sha256;
	cv=pass;
	b=fyhfeWUsPBXBNvlmphRuSbUTiNke48E63+20l72o7LXQRwx2sASA6LX5Mu6SUI6VhtM7/K
	qj4juTkHDQWmIBR1m57TnRlJY1Z2rS830j8H6LeZz52CFpD8rEHlVIEjnZSR+9WgBMrXhU
	ntbagrB9rH9FcsID6jeKzTLI7/Siizg=
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-94de68feaf4so1456647241.0
        for <linux-mm@kvack.org>; Fri, 08 May 2026 14:21:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778275299; cv=none;
        d=google.com; s=arc-20240605;
        b=hN581VpamjL27NKZ8lEYBiJnheAl7abhqh3OQUJGRxzQf65yC4F7tardxwRt0/YohQ
         IDP15XT3WnXsWLfE0d8zdpr/vS/ukFvhvTQ8uxddmlQTqNm48FhufZptvUaN/HYSxu9T
         tQC/XOa6NeiypQ/vCVKyoeNGg/xlpCnRKbNFgM4p1EtT90+DupY96bcYUyHYmmyv5ygP
         n+XASwPH9YvhgEcuiB+ng5lsSrcq6ONFuMA0W9lNFzwCDUlHSi3epG5gTbMpgVSLhQP9
         lm07htXKZpw7qnC89YUzQeSfP5SRGhnIMrkSLP5W1uWL1MPJdcAgfQzM85r1Km+IyNtO
         /rqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=DwVpQtg2nQbOTA132JfDdSVfFAB6KCJ3Mceieu5x3bI=;
        fh=5ld/DpOPk0sa55ee9hu1Z+HSk1m+qMDsbk6jREFkMTs=;
        b=h+cBF6uQDH+5tZkLQflM/fS8/jmCvUNNvpbV8sqMIHXZxBwb4W1TRWFcTp3l0J5nz5
         aSWsVhhs3NCSFWj8AF4fssmCG9sApnVdjnAFx0J79g48s+HkI1qAKA9NXaaPWMOxWye+
         O2O/Omh8OvqwBW0hHqTIUtBBfRjWCj9dGXbRDvWAcyV/k3sPiS8brqq4oK9EgXV/uAjm
         mtFcN2m+wyx3gtg6mw1a3UJg+VyiTR4NsBKaYZlEI6s2ded7He0qglOptNKNMr3ZiIJs
         vj2ZsIQnC73L3tO0jUtP0CLshtQX8Y6E32Dv64AO59j6chIr9TsVOunyyT/oRtrRh7VT
         qRCA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778275299; x=1778880099; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=DwVpQtg2nQbOTA132JfDdSVfFAB6KCJ3Mceieu5x3bI=;
        b=phzlvt0r1bwXEFSndnsFC4bruLBC7N1vkbsQ5lx+ealGx6lrc2sRT3Vx7NispqWEYa
         CvR0NpbK4e96fOhgtzLDJrCB81sKBI+gSLwM5BBOfCQEOxftm6BDDCmeg1G3alaChJRX
         P2PwRy41kPEjj/AvuQTSvZGArm8VLUpixyeyX9CZrXvEjuTdv6dgTGeidQAgV0lUUPAZ
         AwB8LRXJm17FS1llvdqOXsKFmBULh6bvSSTGrABOGSoj1+efRx1cp/GVdsvxgNwhnr5I
         1IRFvYnVGTFqqElvm4gSIawQF6xIKc4iVw42Yt9KPJL84zoD5cXpo85xuyzZZPCfw+NK
         heKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778275299; x=1778880099;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DwVpQtg2nQbOTA132JfDdSVfFAB6KCJ3Mceieu5x3bI=;
        b=RkzaqWtguCKmK8Vf/TZASads3NVAYRp1O4Ohm4CAtijZn+k/XrMTKyy6INlmf4sLYM
         JvpbuI01mKLDo0Yya6EXvFeJ+E9UBOhse3t+zgeWnsXVkSaImXbI1SDA0XPNmR38yXnU
         Z/YjEuTxZcodnnQ8UjGuBJhO+FNPbZ3Eg9rILTcGbjC9w5AAhJntsb1yGot48WzZYbXv
         7U5tIpQ+/xV49Q6Y5P3HslpXRZO5CYgoSFFitCYrt1w35q4Yzq5xvLjkojkIEYI0P8lA
         c4o8APZS65Pn9UT/zX51N1c9/tNZYmcJgt6BbIoTtNBE3zkiVePVjON5Uf+wULEvDzpj
         LauA==
X-Forwarded-Encrypted: i=1; AFNElJ98HCGDXpMZNAVlXF/gco7+OUKWuY5VwU+opvMca4Z2Hu+Qa/Bh9GaGpIa25uZ5pcEbDwJ3QvWXhA==@kvack.org
X-Gm-Message-State: AOJu0YwATz/7nqCW4S1sUfMDTg9BjuvM6E5jyHxjWLYDtCMwn3/zqes6
	OypxDFlq3H638qbTjZS20PKkk5fkoA+W/u2skNWBheyGfyrEM2z+wFkjMOkfWgF0VgGbkWrfY8l
	3L+AmbmwbrM/U8yg+3WppnUlXv4fwnDOivUiG8SHY
X-Gm-Gg: Acq92OHhavdC659P+kED4pQdzBuW407+v+LUjFHJQtt+sxa67xuxaFzZ+7JsWD0/ks8
	1y1rgYKQLY8ZuVoo+c9AAV9sRR81FicntMI9SINrRSNGdHseTkXyyYZ4LfSO/a/VG/9kvAeFRV1
	OaT9ZTBK+eR1GkLh21SR55cMGOGcHVuSW/YlrYTXPXtt6MgoIYogdeqhfrf7VOmsMCaB7jP3Jh3
	Pk80lDcgIgSRAYfETwKVHC+eQSO0FSA5AD2SFOs3bYuyZbzwDSKFOeMm//SCVFnpGpmxw/7H124
	5d3V4ITvSvRcy3ZdSZ4Ozn6ZKXb2BB65hCBTXHVhGx0UJzhZyDJkf+aefo/G431MhLAApGfcZkm
	bLeAnpMC6B9rF/Lw=
X-Received: by 2002:a05:6102:2ac7:b0:631:8bae:f74d with SMTP id
 ada2fe7eead31-6318baf205amr901736137.28.1778275298534; Fri, 08 May 2026
 14:21:38 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 8 May 2026 14:21:37 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 8 May 2026 14:21:37 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <af4gJ6xZ3e7UXOuO@google.com>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <eiiecl7jvywvqb4drq7cchmcabcrdka25wxr77uavxqineeedm@rfcnhdz6xoxf>
 <3blpenhpvysb2ig7efegedx4v3flppl5ftnz6vhpqlatfk3ycn@vmmhs7mvjieg>
 <CAEvNRgGbMhkX310CkFY_M5x-zod=BDTiuznrZ0XvFPUK7weL1A@mail.gmail.com>
 <foi2zvv5qrfdcspnx4fstrvzl74m6xp6zrsw5omlbprxh4jrhx@vxnwk7fr46gu> <af4gJ6xZ3e7UXOuO@google.com>
MIME-Version: 1.0
Date: Fri, 8 May 2026 14:21:37 -0700
X-Gm-Features: AVHnY4KoLAXwUd272WSq8KkXYOzbLX3Fym78BjF7-ccyQZ1fkjgts947Mu_AiDo
Message-ID: <CAEvNRgGOCUL-MzBmXZNZHYEiFdVmeL_K0itPrSRex2f+FazGGQ@mail.gmail.com>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for KVM_SET_MEMORY_ATTRIBUTES2
To: Sean Christopherson <seanjc@google.com>, Michael Roth <michael.roth@amd.com>
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
	oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
	rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
	steven.price@arm.com, tabba@google.com, willy@infradead.org, 
	wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
	pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 31E7180008
X-Rspam-User: 
X-Stat-Signature: iju5rei8f7stp8t6iqiwu8np85ccx51b
X-HE-Tag: 1778275299-467333
X-HE-Meta: U2FsdGVkX19KHRsRu2YJVYywnD3/JSg6Kh/NSWIBXpkGACpUSQ2bQliERrs5ggEPRtwvxvC6IyFYf7q898vAvBDdi1uffOPfMC6kWdnBgyP9rZjbd0phRZvGx88at7q7juCKW3CkyU8N2HSJ6sxI5DxwsY6EahSMpNALGqcIVUzA1E2z85Z5DgZ5Rhg5hrpdCkFAZfqsyGthJkQQKWK+g5KOCDlylWN4nAN1av49BR6Wgd2W+XgCg6C5/mHz14VDZpuVwxun3wKuVa1NGj9j1YTwE8cDz1zaMsLe0453l89ydXN2PBCDDV5dEtYgC4c/mfapaCCjlczxYdy4VQ3FuOq0yFAn28+If74CconRPrE/y4Nv67QV230Kt3WGFxlEDmcA54NXr6H0V7ZKeGyuC2EYiY5aXUbs7aCEVAq6cYQvpF5Shqy+IASVnxw4xRw6P1Pz1zCpfeeEO0tu+ZodvLQfxgreOYZ5DRjB3nl9X+A8gyf/x3p/1tizwSnitYBJT30EeRXQzKtYrn53fjbBjdTIKKtx90DWGvOKbx+XLV/WaBSqXOl8KtforRny1X0a50vYYiVMd7QjrTiLSqa3yT2zmMWECQFa34LiQOAoZzVHvNW4X3Xe+AY0pUIPQ1QKlT35EM71OBXiikXSpr1HrFs0CUkTNlpcMvkVlvIuIAq0nHvP1Zf0WVMfrWG+U/AaW5POc5f/sQW1cKAahkh1/NLwf938zhoN6b4VFEJXCkXXvnqsakj6zn88pnCylbWiPR0nix+90ne+ZDBmzGMiNmxYdyG5jvRnedgtUbu5b4kg2jHDeOyu/cM8dukA++YPAxsYy9bg45Ndu+vuTm15YT1nkH9nZpa8TrnMLl4kaBH8aeyzApGo9d13TRdw90hXLNU3c9ZTqdRsMBQy5hddUBjax8HZkgZ+pKI5S2XfA4qrzZVdF2jk+ncq/z5mnZf76MHIBMcgNjlGhmheoAK
 LE9McP0V
 fqPjAkZxfryWmCsNK103xXVEr+UFOxMZwetTvtOQm6PUcPGkrj8pwpfMy8TjemosRm1pDJ+1NLbj7UOLmLwUPfnehEjA5g918fi14AglIsSHdDdBKFOg3kdIX2a2Rwvmojabf7tqtmvtbn9jUt6g9KrJuqGFHXOmoVw5OlUhpSitmXd0Cssleupi82B7PqXqqX76zh5yyyhrQkuHqscK/dNibc3g2R05W0oZkBz57NqGZcSt/o0KNojMtr2Gs6rFP6gBvlhUqohjXm/upCY1Ha7XuOfKr1B9uvP1B/DjJhMP9PUbIDgisXM8RS4daiHgy85kkaCx2ATymOTvQl6dpaTdJamBlmMLY/3sHU61iqz/0XMT60hT+MmSX0GdG7WCsvG3maQItq2HQX8A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sean Christopherson <seanjc@google.com> writes:

>
> [...snip...]
>
>
> Summarizing this week's PUCK call[*]:
>
> Scrap PRESERVE and ZERO, and simply rely on vendor specific semantics.
>
>
> [...snip...]
>

Thanks for the summary! Please see v6 here:

https://lore.kernel.org/all/20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com/T/

