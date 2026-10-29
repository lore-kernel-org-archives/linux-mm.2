Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10BBB606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MdU1Vu82
Received: by kanga.kvack.org (Postfix)
	id 2253A6B00EF; Thu, 29 Oct 2026 09:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5F66B05B1; Thu, 29 Oct 2026 09:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6686B05B2; Thu, 29 Oct 2026 09:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8C186B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:00:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4778CC03BA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:00:45 +0000 (UTC)
X-FDA: 85375673250.22.CB997C9
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 389DB140017
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:00:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MdU1Vu82;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793278843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ganH4EWpICXirAxibAD+5YRIHmRwYY6kvCGrRyrhM1Y=;
	b=kUHMrJrXK0Pyz/Xoh2fCqzyK/Jiotf0lRHxL+zz7/ZsYeJkDeDAGM5YRhSZKgGc3NRD1BQ
	o/W7vJw+9E5zggZb34McKY6tI7tLY8x39Mu5kNYPWhyoDn+Fm4jiprNuhQs/4LLFBSkZQ3
	FEIbc1wjy0w2NOA5yr0Z+I9Kb6ljvp0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MdU1Vu82;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793278843;
	b=vuvci0vLxb4Toe2nsVsr+4K0NUsNP5TW6Xlr2Ok94uJ+ZdFaF8UDjNFXXMJ0mFl4i/FuY3
	ffleaCnszu8iB8lrfMU1zRvrbcYij3A9tir3wBfUhkYffKRvjJ6bpGb0r2WiN8LrZ3hLB2
	Rxx4rICGSgzRBP5xpbRRCsEQflncpiY=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-33bb5afa736so362964eec.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:00:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793278842; cv=none;
        d=google.com; s=arc-20260327;
        b=XsHjXjRChHBe3LVJv/os6EOZBMAEn0QwX0IOJIjB21+bESsJcBD1jauo5fyEWcRAvz
         14LDfs3d7usCaHBsBj7yDfa3FBCmgAzuR7DUchfze9v6xjrFawvBED9i9VWY2HS4Acq0
         w4G7d42lupthLmb7+XzgLCH3vT9OGaNGQUTeH8GgjZSA0Q7VA8Sns2tgj0TGEMUWWCkN
         6mYj0mNijsOWAD3Y+qW3OJoxbNnEkMkGaTGINqd7IC334nQ765NNcRGu2YEs7+cKHAIk
         6gdHJoIMbdUtQMupppCet5+O1PqKwuwO1OBNIZDjz/KL8KIn1DI4I64IAQZAFeZ4xEyL
         3bwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ganH4EWpICXirAxibAD+5YRIHmRwYY6kvCGrRyrhM1Y=;
        fh=CcwFK1E7gYvFTNkFvQ/7TPPG3cNdrZGmBWn8Ld4S2wg=;
        b=clULHN2WG8l5ILsaYwnoG3OKzgaSkSXI4dij2W2b09fDVXr7drpkJRKvc0UUUPNJ55
         06r/TJEkoI5213lzw/c3YhxiTpXbCdIuPYBt8vuduNWW0Geq+wmNZ5fnYhLf5OQIPC7C
         TQeluF7+ynm0oDK1cEzk3AoomVoIYQHgwlFyuZwip8KPUOYSyIsKAWmiZ2AOFMO5Xb70
         wsZPjvHar6Ok2OxbtdQursHyb7YCCCfQDhvmrypOwx1hQa5EySWFkYyxYe27q+wT8U3H
         F4QjcgQyDaje0ijclIYuoKTS3+sQnCYpGeF94pGPzM5rsBmJCXQBP1SHF4auGVpqgwYi
         I/Jg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793278842; x=1793883642; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ganH4EWpICXirAxibAD+5YRIHmRwYY6kvCGrRyrhM1Y=;
        b=MdU1Vu824PRj9QRGDaTjrUThDhcerVNWvlktl+QAEMjyfQ9HGnSVfunuqDb9p9x/KC
         tAZScWpguV9tJEpfPRDhu6xcRBxoukwaCL2KgRchz02YEARQsvfZUqlqyafuGPUSXkQR
         iNHTw3RjTpMDpkchx1ohtnETRuUr33KS0VSzO5dxodsIFm8X5yNFF/l2pVG6mZnsUdiV
         owyKBnQ+tyAdYw8aYEGNkdv8jAu/FmdC0KWlzrD27b53xwdIYgHjLNinrptQpL1ViWrQ
         6xwcqxMpk4iq03IcnRUsLoIX00o2CEkzZ0K4MAO3DtqHKX8NbHgyNUTH3nqnLnks60bU
         lU9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793278842; x=1793883642;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ganH4EWpICXirAxibAD+5YRIHmRwYY6kvCGrRyrhM1Y=;
        b=l1/pZbHrjQGktAgvl8KSdh7tGAhVTS4QRn8IiqtkZTDIRTngm+Cv83vBFTs/gtCTH0
         WBgky+AbGG7llN+iSE/qu9+k42vcQ1r1OGHEBQuOF8ip0XKFf8vwjjBRqSpX7UmhBm8Z
         DTU7Wao5dp87/mrxxviIlVmVe2UedZdu3n3zmCNq6UZkj21gMD/n11pa54iIqBLeOeCu
         XwtohrcbJ8Qu8/dC3UayWjCe6d5quHNLpixyUKUZ66L/i2Ngax6VN1hkseEk7HHxB1+/
         r/8bGAIS35K2/xWKL2NuHd6+Eaq3i64/E+xXXZhG48rwN/AmbdXxAIlfmqZTLBYkUzrW
         Wb8w==
X-Forwarded-Encrypted: i=1; AKwUvBwrbG/Oa8nYZGFkW9IIkVoqPdbUhT9X8xVVCTkBRvfqfyCsNHEsjoSWlDzLn2WjH+AB5nOQFckD/w==@kvack.org
X-Gm-Message-State: AFq9FYK7W6KumRGdv5oDAa/xTtMnrSRyRM4rA1OxKCILc6aUnIxn0DyM
	d75POlwqwytBSwuJoqnlOQRK/KLL2s0e7yLVBRGZPfSiCCIMPku8ALKyG05qOCz/Tvfwk6c+bmL
	rxMrtHcMaI5BZ4an2HH4LOmR4GGrqass=
X-Gm-Gg: AYBFou12OIcQaiIs4B6Wre01BJ/RYfFfY3kNt6lKtBFqc+8MtxI0fk1mrKhpCTQvr6T
	EgcGFH50FRdsAivqqfhSg+o2AxB2d9EnHH3VDkOJUR6pW8pw5NZwcAcwyLFtSyp3N7E130Mz2MD
	wiWck63sUrukOvbgd8JEtuYMAhVRAAokRjUZrty/lezBsGKCtlFN5StRXlQRu3yaqf6aPbbxdIq
	cLJDAQHBCuEojTEUSdHCtF2agHSw4k/J5LLHEvtRdVeXhokYKiaeK9JIvHfSvERzszAx2V9GLb0
	JRVM89m9UH7y1TlbuG+OyrsdPr8RWCGVcMvpVAw8Rpu6YM2aSYVXITmAFkkO2YoeZ1t6xl5uDRU
	NOS10ZRHF/27YQtSjSQkUKpGvayGvVjtqtQVOy7VfjfZIDAJjoPYYPxeMKxA9P3hxHoOCApNIJD
	5KKroxo0VBfeymKXbZuvGwOl+XKtSXCtwJ9DiR/S9Rk4Vt0+14K8w46rtfd1q+crKzdZhyulFCI
	rnM1VQIVym5ptPAB5vfYEJfa7L+aOyD6sJJAw==
X-Received: by 2002:a05:693c:4196:20b0:36a:e7a:e89 with SMTP id
 5a478bee46e88-36a202cb0e4mr12034617eec.2.1793278841146; Thu, 29 Oct 2026
 06:00:41 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1793027261.git.d@ilvokhin.com> <5bfdc1491d297b5e98cf42322c790f06481c28c7.1793027261.git.d@ilvokhin.com>
 <fb3b6a24-74ca-4da8-8593-352afd515313@suse.de>
In-Reply-To: <fb3b6a24-74ca-4da8-8593-352afd515313@suse.de>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 29 Oct 2026 14:00:28 +0100
X-Gm-Features: AclHuK_VOCF7u599iESvOsHhN0DoC1VeK-LagvEMwpUC6WNOUUTl411X-macJoc
Message-ID: <CANiq72mMm75svCqevd8fHtVoczDpvpo4NwL0SC8=bWy030vQuQ@mail.gmail.com>
Subject: Re: [PATCH 07/10] drm/gem: Switch to __nonnull_args() macro
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Dmitry Ilvokhin <d@ilvokhin.com>, Alex Deucher <alexander.deucher@amd.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>, 
	Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai <billy_tsai@aspeedtech.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Kees Cook <kees@kernel.org>, Andy Shevchenko <andy@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Whitcroft <apw@canonical.com>, 
	Joe Perches <joe@perches.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, linux-leds@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org, 
	linux-hardening@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 389DB140017
X-Rspam-User: 
X-Stat-Signature: 95dgqok8kjuerxqorhobmh1ghjqdhjkg
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793278843-884364
X-HE-Meta: U2FsdGVkX1/J9Y307CtsWHgv7loQAVAr9/EOGRC8QztUOCnPVbN5HXPf46EL/HGufHkWqF0O+RphCxRs73iM+Gx9Tciy8SWZkFmEBecF3krtshgrvqw2lf0enx6wkn+Ep4G7nNSpfD+JuJSPFxyH/ABC7F2O7a/5/xF5QtSKm8leZeCgcHXDneKhKBTVtefRVvWZsYaIhbLJHuRPJlmso0op+XozoWeal2GmcHInI6QuUUeg+hV69Jj4e5gboQS16tx3BTylUimc/Y7bYi7hTKoQ2CsNjuHseQ/2js8J0wDpvZy2tZnabQhZum94HDmRcrmEG9SYoDIOfo5qEAUF86+4sk0Cr+VNgDzigrzH9ujFU0k5H9WjnaeXgdCwKPoERsXsfY3O5yZYbLoy8HMOfiObfN6p2JPmjLDPtutMPUZ1DgTpcukr7dH25NRsAloaxXf15TgtGJpxFMoXkatsF2uCXcotsvxUIvfMldv0fDyAnteGoVe7Q2bICZ4PWz4UztCt0su3R/5kPSjNihNh2uzv37/o7MtTo3cX1Q5ux3snjs6yEDpErZeFeqZbshEX0CJaTt8JwRNkAmM/SnvstaLnhu3Tq8ICWY91g2EegTirPx/tKy21corsCT8yIckjQsVDEpXjTDhY/N52i9e9yjVj4gx+kBisz/GTQ3Ats9TqQ7LaWW1pmCJLLJw+n2AERHQflsMxlpwf4koKH/zmEFz9SN7zWGUj5Ww4hul5wuj+dXKZ6hxS5JhiqT9tWJAmPeF2h8JOBCq46CgsNrv8pvptTfHkylQe23PvP/uDkvaTKyYMh8enHMdtzOeUKwTAYqr08uql9iohDW8DBNoixAtV9rVPELhIww10IoTv1qRJCHVIYBhR1whB80RpkxKBIsF5GqG3wbYUT/YjbutyFqv/yTX7faKx0dB6WYCFk82ggDTPH7KlbDHBfbWWBoZal1QVn7Le3lnmv+N/1Xq
 9MsrIsh/
 agD7PA3XCLu2tp+lPoRprI2l0s1+c+bmoBMiLqDaDv04heFSMv8A5hpu0rzzSO/yyYL/UTZMWgsywzvRYJLhuM1wTfXtZxVYM0VMONhmsGfAIpdNqqBSomY2OuTu15eUL6dDC0t7EsbdOKbS70x2NywTpj3wRXqcfhznAWvNT80UcY8IRuHhUuiHLUACjORh6V3A9m1UP9R42hGMayXMWG0MmnFu7qUrDA98lRZf/ggjwOs6CmzDhwA/2ij0TBqCsZnUPF5o+/4gNFNp2j86f1lkoCK+pWb/1L8HXP7suugrwO38qXmDNP8UCyBU1Dd0VPBIYOoM246UKIjxwppE6fdSLyD/P3AZF7HfgFBj05b9mxnCUhUDvTp4bPWiC3PEDRfzTyk8EA3MULjeU5nwRv1ErMlZztOePIxyhoJAnpPDJ9ywSyPna500Wm0qlpriZ6WEVxceAOBwpAcX2jrlXCI/UTynVKHuiGK7sHj9bnTdARb+2sTknvzj+G4zypV/Sd2R36uEtkDlwDcYoqWEl6D+3hZ2DBnZhmYzH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 8:32=E2=80=AFAM Thomas Zimmermann <tzimmermann@suse=
.de> wrote:
>
> Should gem.h now include <linux/compiler_attributes.h> ?

No, it should be included for you (unless you are doing something
custom with the compiler flags etc.).

I hope that helps!

Cheers,
Miguel

