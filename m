Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05982D116F3
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 09:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3278A6B000A; Sat, 29 Nov 2025 04:55:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE736B0022; Sat, 29 Nov 2025 04:55:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23B626B0023; Sat, 29 Nov 2025 04:55:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1337F6B000A
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 04:55:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD21A1324E7
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:55:48 +0000 (UTC)
X-FDA: 84163187976.15.FEBD536
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id DA04CC000D
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:55:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dw+wzh8Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764410146; a=rsa-sha256;
	cv=none;
	b=hDXLMgRPItGQpeVappMfEGFS/NasWL9NYXy5ElSrEqMKdMxRC6cU4EJA/Fvsd69FmMZyZb
	4uEvKevsyuzz4ofdP4Az9plwzajBPrLG681PB8mpeGkArhE3d9rbGeKeWaxKUgyYp9Rigm
	wrmbrh7wLQBaMyYaLFu/3Akp5F2b96w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dw+wzh8Z;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.182 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764410146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/iI/7t6PfyA3Rj5l4epnBiBSTkgBrMrR31O4MqJqbk=;
	b=bAv+t/Q5bI6KlNhoJ2+NVqZXUDkHG/mTmLufI+88+79tfLgTparhNLuMxmQ/KolBe0j+Ur
	s5BfAAWY/qBCFUAWud2KAOVquOSOhekoSGLWZLn/TyjIbQBZJVkdjRSTOC080afF31SXSr
	yEMb5u6teVt85Eqr3oOqmzC0lZiIK8A=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8b29ff9d18cso234733385a.3
        for <linux-mm@kvack.org>; Sat, 29 Nov 2025 01:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764410146; x=1765014946; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A/iI/7t6PfyA3Rj5l4epnBiBSTkgBrMrR31O4MqJqbk=;
        b=Dw+wzh8ZTbZvjqYbTAEYtAYT4jUevx8Lu2DIhOBnM2nuI27riK5+egDpqm94F7azHm
         F001sZIrh+8JsNWJKMhtkDTqSnNg6s+hS/Upbj9Ptki2S5PER+16++dyfZbaiNe9FKdZ
         NnMz3DMKmXVLbAVCQZYR2tjKnIrnxZXE96IUhuta51Z+GMIwpDQ+xuzRQSgSiBT5yh3U
         Ei1/CuclkU7tKAlCGHmzmzkpwF5fiHQJ4BA0QKQz2H5/y0RXJ5uZW0PFSurOjpwSvkGy
         Z4xESRvuqlK+maEJaWenPRuIsgydvyoQOCwOMrD8e4DpUoIK92d95jKmxdIw4ia34Tdx
         Pnww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764410146; x=1765014946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A/iI/7t6PfyA3Rj5l4epnBiBSTkgBrMrR31O4MqJqbk=;
        b=eHP3BllmsH9t9Co3GR0cmOKpM9Etg5/ZzK/ptr1FWlU6YmFU/40kmHPF3MsT4KNSld
         zFKsOKsKS/0FFklaNzfdXKZMMin8oNhxf+Qg/v2cq6nWvP39ND2gikSVropuEh2SJfzG
         B1KVbWE3gQbUKvjTI59S6rWIgTt5X1k4uLSPpF6n0n5S3CpYuxDwOfUWejCSs9n+VHNY
         3eyQVbCxYkiLz0JYcYGs7sBtXw33Nje9Lyp/9xqJhDbZX5dBHJgdHvOFT2z5S20DLQpM
         mAjlakbbLRyEyAGKaV1Dxm1/Tspb3mwuXlJvLREX4Iq2B34PMxGeMQLNiJPpBwGJqXFk
         X1Vw==
X-Forwarded-Encrypted: i=1; AJvYcCUaQk168fDPvlH03UU4OuKytKqomarZv0bhf9GXv7L/YJ+SyM4az7M+GNtFlNU2+Y1fSTw+SFl3hQ==@kvack.org
X-Gm-Message-State: AOJu0YzOv08v+Dvtj9eZ9s5o4AMDHpG0C+/+gNyaQn0aEFh1CIStLN5t
	zNSsxHTnXkRojBaU6rIe+xIkkOEiJYm6g589RK4qSvmY3ElaNRdnwg4TDx2W55HQEGiswFp/RXn
	nLFbvN0AsdjHYZgWKhHhhLPqHe+EICtU=
X-Gm-Gg: ASbGncvHUBpNics3WXNtoUwq3Mz8ZubfPe+sEG418ziMzz3jiAcx496LljOxKxr1bO/
	PorAB2Ls2qIhwITHZBjtIfYbns1bIt7mPH0IQQ4ynElzeZ1sydgTyeigXcgdWOX7+2EuHU4wMnV
	B0E8cj9ScvnkZoysR2ZB01SurfbcqYIM9w/uWO7MddOBrKAIFh+cpT5+YH2/hn38R9ImBkwRfZT
	hCoTq/n71vKYj4aDRlqHL8SPM/6u9AwHNFKAq+RTyMg83JLpF4go7VvVdXmDEg8R9Bj+g==
X-Google-Smtp-Source: AGHT+IEx5FnoQSqVYE5HkJ4qekuzm872dkwjAjVY0fHIWVwgKTd65EFg6KIctq8t+ydqSEQkx43JpdHpLLiwggx8mXM=
X-Received: by 2002:a05:620a:19a7:b0:8b3:36d5:7544 with SMTP id
 af79cd13be357-8b33d4873e4mr4187792385a.82.1764410145912; Sat, 29 Nov 2025
 01:55:45 -0800 (PST)
MIME-Version: 1.0
References: <20251128170442.2988502-1-senozhatsky@chromium.org> <20251128170442.2988502-2-senozhatsky@chromium.org>
In-Reply-To: <20251128170442.2988502-2-senozhatsky@chromium.org>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 29 Nov 2025 17:55:34 +0800
X-Gm-Features: AWmQ_bm_Hlx6yp0bfipy7ZUUjseiYqdoZMYw-HX6eiK9JohZ6_rLqyBX_3QwRGM
Message-ID: <CAGsJ_4yUAw_tzX7z8iizToMB8SDJPNOhFRZNXva_ae46q5vRwg@mail.gmail.com>
Subject: Re: [PATCH 1/2] zram: introduce compressed data writeback
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Richard Chang <richardycc@google.com>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-block@vger.kernel.org, 
	Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA04CC000D
X-Stat-Signature: dyraaguw48rs411967kyxpef4xmd1pwg
X-Rspam-User: 
X-HE-Tag: 1764410146-211236
X-HE-Meta: U2FsdGVkX19BL/yliOFfc80Kfy91pbEjwqM9Tq/9RMcpwcOx44h/E8iCdEEz3lNd0NrPq5uoL3YiOv9AJt3kKZkO/zT/HAm0xkWBGQCZWhhIlhVdgO3ghFNzry7pdhrCKIVgLqLJP7UfnidNJcwyzA6U1+avClosGsHBf/LsxUr1nMjGMk6h5L6e92v8AUoxM9nc35cs66sgc3Snnn9LlLr6CG4xgeZItognc2yK19jKaI8PW/tSQ4wXdSVS+F9Gt5UAaM9dL/wSFv1kRkkCHM0rZKBPeLUB3utsCSjVjxg48h+/3GH2KLtnbJziTby0dgu/QSzBSInlCxihSaMJGu1IpgrAM5r671sMgDTho0uiEiHlxu5cy8MJz4pchil5LPGL5UxC8YXGXnxe5MJUCUOq8Q7SdOkmyaTnECkqIj4IKHWWb3Jq2dvzoy1hiY8MeFbRPeOlZQkb7RGVBUBNF2uRXoiRQ+48RnUCgueGUNIK8W9OUFSsgTFfIqzokCY5LTKdRVbUqr3ENIBkBVK7c9muZP1McjZcrfGNUQMNfypeny62/UbnUT737WmZetwsQKNXTxsqA/hSWidGJnvASCxLroUWiNYFTCdIx3cYCvVUIZVtHUAIvgtk0JEz4fhnUcsEFAszl8IiCc6b4YiyRgRLYHUWCOkSY9au28h0VTKyfk0sXj2tVvM8S/O/gWL2UjjxKfm0hOOQv9AJ3wwfntu4dp2KnpcI9ish8fZ5VByrDr7ohTZU9EDe82l/wl/BXKtcF7c5y7yiAEe+P8FLTWrwmnwS4LnUeCvKD6obj0BZx5zsB53lUcK79ZfDhoc8MUHAN1wAEOxKi7emBVPEqVj2p3qxjuT4jLBFg06mV42xplT7B1tHSbNF4hgAcUzKE1N71ckHr9MiEw4gS6Ng1E6lpizRJkqx13ywUyy1vMSB/cGMJzMW2sTA9FhVldgPQTgb0TFMczGFuJo1C+Q
 4Q7CQKMC
 9nx8RMKxNCKZ9WrlwuPGrxedcFjaDrysRc1s7D+4OVYbzqIVJxOVypSdBnvT6skSS4wDDM56Vna29wWtMK5b1UjX9FGw7sm0/ZUys8LYph5fL8OW9d2KQpcvA/qGOiQCU3y+cHJzbCeOnNAycukrMed++APTe6uvHc+qzVs+MV72aQslXHGWGAqxt3dHv//lwneM7kX7RVrrnPfcfA7+hgNvxRXpJvEXIJz0f9E59i9PN9f/A3fQOAJZfMKkO9cySPfo1Ip5xIdhcrtDosVlOVgUSKt8b+w7jP3yonsA7ISw3WxDebex58GtBwurzDv70KmgVSe7FQUobOaoj4bG3x+CFzfHBVUQDzZpWcrMpvEidRLinx4tR8QOUOsirgntFQ2qFXjypS6xDOxRZ/TQsAZmL7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 1:06=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> From: Richard Chang <richardycc@google.com>
>

Hi Richard, Sergey,

Thanks a lot for developing this. For years, people have been looking for
compressed data writeback to reduce I/O, such as compacting multiple compre=
ssed
blocks into a single page on block devices. I guess this patchset hasn=E2=
=80=99t reached
that point yet, right?

> zram stores all written back slots raw, which implies that
> during writeback zram first has to decompress slots (except
> for ZRAM_HUGE slots, which are raw already).  The problem
> with this approach is that not every written back page gets
> read back (either via read() or via page-fault), which means
> that zram basically wastes CPU cycles and battery decompressing
> such slots.  This changes with introduction of decompression

If a page is swapped out and never read again, does that actually indicate
a memory leak in userspace?

So the main benefit of this patch so far is actually avoiding decompression
for "leaked" anon pages, which might still have a pointer but are
never accessed again?

> on demand, in other words decompression on read()/page-fault.

Thanks
Barry

