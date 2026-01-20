Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 480B7D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A26636B0399; Tue, 20 Jan 2026 04:47:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7CB6B03A4; Tue, 20 Jan 2026 04:47:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3386B03A5; Tue, 20 Jan 2026 04:47:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DCBD6B0399
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:47:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 380FA58F91
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:47:50 +0000 (UTC)
X-FDA: 84351865500.09.4E7506C
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3B9F7140003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:47:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WMCz7MiS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768902468; a=rsa-sha256;
	cv=none;
	b=AUoBaHl2pG9tKKQgApJrwd4j/wsE42JE0Lm0ksWHyjRtpyFJsw1Z7g2da4eYrb5s+IQ5c8
	Wo5c+YzhKthJecRQhm5gwyBU2Efx03VL/kCugj+tCaoiXMPw4SMsMGFEq+MscTiQ6dDqtB
	JtX/4wFoANCJ5BETla+fCOgBLVcOFEY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WMCz7MiS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768902468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DJHYoC13I7WYQTapdGtLXxIS4a/VdsM1Ai6iJFeIdCU=;
	b=oecTpb7Xa9Iksu5fi/s3GWwvzuNlJjhhftH/bz9GfdcdQPyKFf3RFaMEyiC9ah9fHNmZ/z
	MZyd+iLbqejlS5emlSsKwX5fwyGBha/fEN2acbA+iHECZAXyXeRL5Vm7P9mIve+sDu/kBF
	pLJWUCNW3VMk8gegVdV82oERYBihYv0=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4801d1daf53so35533455e9.2
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768902467; x=1769507267; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DJHYoC13I7WYQTapdGtLXxIS4a/VdsM1Ai6iJFeIdCU=;
        b=WMCz7MiS3y/1CgGjQ0QpOjhSNGFGcDWblSR2YNak8IMXW19GB8lL/u52EIa87vYbPR
         HHXJy9j4S8CMNFUppkHFgAxBeSSK6PLEhouC6G5P7+5l3n/ZQsQSX/OmMq3RjJO4a154
         SFtU4mVLpsDLr+oh6EAqWoB3QwquP7S7pSXIGfExeXEaMw6t8nHFaf/zuMXjrkVtA6cX
         EmKA/D4ZCg8vBtEd1zbXU/Be/dnLO7KW05B48PsiSSMtXhm7Op6GMKU9o7aHa+a5gdRk
         iwAAnMPcGQP4AXZ+cflOvRMAorUYvun8IS2LEWZ2iV0kG48aTr18m4bRbKcfvfhKIJ0e
         aVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768902467; x=1769507267;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DJHYoC13I7WYQTapdGtLXxIS4a/VdsM1Ai6iJFeIdCU=;
        b=I+3Q1X7E1N79y6dxlgoMh0S9L3xQcG4VKRx91QbrZ9P/ecv7AKdrJJEv8X8FfQEn/e
         44XgxT15Ss5XPNTqvMay8Z+agvfdSVJelRwhUzxXMInUNFQQruzjrYwNALivvlWJ5awa
         8WBFepJ4PnT5uitP7F8v9G7bSiGWkrYHzn4K+Zi/6/GXa5waB6B1RvgFh0r1C8niZrkw
         iETW0bBLdMwB2wliphP75hh/4sxx0RcCv1fD41NyaOxJ/oww0+POWR0NB3eCjaEJ2A8V
         EKuAAUw2w3aH6M8MVDb7KVDEdQkHAemAYFsfgdWibDde2BRRrCWp3nCKFqhZi1XUkzcA
         Pk+g==
X-Forwarded-Encrypted: i=1; AJvYcCXrE0YkrwJXvO4ybT9kiqDS6jnevZTXEaCXCatA/PhCvKsnykKheAVExbeEAqOuE0Uz1ceT2exWZA==@kvack.org
X-Gm-Message-State: AOJu0Yx8ZEheX+RrcjmrfZvQ75qVp338TWw8Rco+sk7vW6uNXGoEk26i
	FYHmxI/NI1L7sb44oYsfZtkfcDXyfMXgzwWzZEz0/y9qXrcq/Q2CE0Pd
X-Gm-Gg: AY/fxX6EnRQ7G/oVzoGZgkqlnnx+4mI4diRj6xT/u1SlDeDIYdVCKj9PxLFuhQJFowc
	Ejw/xaO3PV6ZpWUgceR31Ph6FxOxtEiEaNq5qdBPAUcPNmhrNW8Gm0L+iAbGmayMOFd0g3i95+x
	WKlvxs7olabZXjXfdSmuTSHcNuureL7vqVrvPNKl6eLUGbofopHe8jRJg3KtoQ6IRInKisUDRiY
	giLoPVxtWSRyCzB9lgHVjcqOd2C93xutdEOiSYvweHviOchuJgDuoRdPklYXVmvLP0bC26wO9nP
	JJvQjK3aXn7q5x0NCEaxpHHmjTeJKt6TvjjnsEXiY7DXOFRWJomYHYM/WbuFLrjIS0mD4V/6dZx
	4ymDy1M9ZQpicqdYQZTq5gwyTji0HMTZLrA3MkRIhBfd18H96T8okVDt3tJcH1Mmm+b509VKo5m
	fryCHnvcUBvDStzZTGWeLmo7KQVg+A49Dg177FdZqWuIDH4Ml00dIk
X-Received: by 2002:a05:600c:8b8c:b0:46f:c55a:5a8d with SMTP id 5b1f17b1804b1-4801e2efd61mr177221835e9.4.1768902466290;
        Tue, 20 Jan 2026 01:47:46 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f429071a2sm292458445e9.11.2026.01.20.01.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 01:47:46 -0800 (PST)
Date: Tue, 20 Jan 2026 09:47:44 +0000
From: David Laight <david.laight.linux@gmail.com>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <david@kernel.org>, <akpm@linux-foundation.org>,
 <dan.j.williams@intel.com>, <dave@stgolabs.net>,
 <ankur.a.arora@oracle.com>, <fvdl@google.com>, <gourry@gourry.net>,
 <joao.m.martins@oracle.com>, <jonathan.cameron@huawei.com>,
 <linux-cxl@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <mhocko@suse.com>, <mjguzik@gmail.com>,
 <muchun.song@linux.dev>, <osalvador@suse.de>, <raghavendra.kt@amd.com>,
 <wangzhou1@hisilicon.com>, <zhanjie9@hisilicon.com>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
Message-ID: <20260120094744.5d92e34a@pumpkin>
In-Reply-To: <20260120062706.91078-1-lizhe.67@bytedance.com>
References: <87wm1ih5kb.fsf@oracle.com>
	<20260120062706.91078-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3B9F7140003
X-Rspamd-Server: rspam06
X-Stat-Signature: c8e7b4qb71s5afp9p1oxqhcnuwjb4d9e
X-Rspam-User: 
X-HE-Tag: 1768902467-796565
X-HE-Meta: U2FsdGVkX1/kLEmaqRQaPIC3TaSpQW2w0MrJgPy/urh192jYIF6d4vAt13Ud9xfgsLqjYkAoPNxrVZ7FvpuYDtYnPCtA7ydreyfF+ewfsWkOLPMb1xCjV637gLrTO8DoNPa0tQIl10w3iOw1hHWE3cEgUp3DIb2eXZpK11mY9lAdlXGuQhS56q/JJ0ADlPVLmc76JaTRcFM3JSi9ehL3qy0nKXuUzQidf0K4Crta+32n9Y900RzrIS5BvPIxy0KTZeyCP8cUsaG50j1NKSeLrvpdqTx2UZz0GbZnvOh3a69CRQHL8gDXW5ScPZydgeewkN+4Gapzjc8pSgDq0kfYcfkuBgvtIZGjiQQYI+dGBg0z7Za11tSHfLiuC4pelNSofqxwvp5lz7ElCzaDmLGe7Xtx9YYP7vCZweU7gOZyGpMrf7H9m47ccx5fX+DXTgrFKuMyR60pHeGRy/6b91H3F+bXTfiS+FK+ntIOY80utsLWKTCSc2thSgcPipgormybF8pxT4CtcC8V/KmbSgdNnDDilOPV0mLV/G5tpKdcDd3Blb/xSkvGT3J0JIjlC2lag9geDEk8AR1zvEviC4y7TQxZhVC5L20Wehxy347GgGViP8fjMO0We32DEt+9wZiCXJ1N963qFB2rSqUeqXsro++tlenyAH9TA12++MkXEzV1hfPgtTmfUBKf6LODQMEvihcYZDbEYf5V5b+Rjs2fRi0Sa0cxCLKemUMzzmYdAl2JuCaBbCCvbNZyrINV2E5IbLKeYVfhnoJu3cIubes6MR+PceigxVXam9OQC3Kz22zAtlXF894FOb7DB+x7I6Xu/BTo7AxewjaWwG5NM0YvxOjlX6jWn8qB2QuHq/6OrtlOrzpsoYpsSM/KfqI4YOeEs3d1Lnb5jtbvJLlr47U0O2O38ePlLyCPhnFMcXEl5l1tTL+Dg6CA0cJOw8JLLQgDZ/TqV3SZ6zuw0KJC/ru
 PT4PU6cI
 NJqGGUJPaeY1fAnL4SsNt1woWzFApo87hl4+Qs9lRtT5wccem7xGg2QPqhlSXSxxnnEQRlcaj50luzlR+RKN6mZ9bXgGetVg/IIcEQ04ggo/wmWahhEPaxCUfc2ZQT/ZImU15d/einnCDp3B1uI558QMIYCFd6zFSmr/0PzfJ1WEMio9qfdFZ2NLfInAXEzCMdw2usf/B4aHIdonwamY/TCuPOdZIw/wQdmjfV9YVa8euVFHim9lsuJLmn6K2/iXxI9LhyoaeXzS2Fo7C0Sls4OpYXdcnLGtUfBCH5WcQvfmTailKsCtevwAIlD2oYJRY7GnlFS3fcicl39PkcdA+AYk/c+rEGN7/kdxpOzBAw0y9vPkxp7xBUkureZBlPMu1VTP7UIqx6HehiqKimq6+qjYTC0NNBJK0DcTZupMz8+BqgDjDrP7qw0vLcPhHgp9NJj7NkaNSmoYUrmo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026 14:27:06 +0800
"Li Zhe" <lizhe.67@bytedance.com> wrote:

> In light of the preceding discussion, we appear to have reached the
> following understanding:
> 
> (1) At present we prefer to mitigate slow application startup (e.g.,
> VM creation) by zeroing huge pages at the moment they are freed
> (init_on_free). The principal benefit is that user space gains the
> performance improvement without deploying any additional user space
> daemon.

Am I missing something?
If userspace does:
$ program_a; program_b
and pages used by program_a are zeroed when it exits you get the delay
for zeroing all the pages it used before program_b starts.
OTOH if the zeroing is deferred program_b only needs to zero the pages
it needs to start (and there may be some lurking).

The only real gain has to come from zeroing pages when the system is idle.
That will give plenty of zeroed pages needed for starting a web browser
from the desktop and also speed up single-threaded things like 'make -j1'.

	David

