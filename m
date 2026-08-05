Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F23C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:01:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01AB6B0092; Wed,  5 Aug 2026 05:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1E06B00A7; Wed,  5 Aug 2026 05:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C79B6B00AA; Wed,  5 Aug 2026 05:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67E466B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:01:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB197140400
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:01:30 +0000 (UTC)
X-FDA: 85066622340.12.37C7D51
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id F05791A000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:01:28 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MnT5aHI0;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785920489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=006EpaNdFPLDBxr2UIddQMK/UW47PHMTajDC95OOpTM=;
	b=ANoqeJCh9ZrMZLhrXbCkyMlj4FcV12znpUnv6MA2fKGHNk6wpjXZw7+fJTRmMShTbYUPuL
	yx9mx96BZYVlVljl/aP1DEcGj41VuXIDnEBH+YzEDmbQRLcitVWijpXoW+hZeZqlX2MxHw
	fgiOuT8mfFzPTEwOMwJL5rWkEIcae5Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785920489;
	b=ej8HHbP+5x9I3KdCQRbATuq42xlzIfBB27m7bSekCGNcj5ohYYmoxQzMsKVmGiQMhlyZJt
	AidNo+uSiJuCgv9xZWBhN6HbDRYCPK9kY2Hh+GKcRiv/16IHmeHldkhnUCizNulE9wIro3
	2OOup5+mehz6UOTuObIaFs4wJzomoU4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=MnT5aHI0;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38f0f132f56so1464925a91.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 02:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1785920488; x=1786525288; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=006EpaNdFPLDBxr2UIddQMK/UW47PHMTajDC95OOpTM=;
        b=MnT5aHI0mRtdFa0z3HsmZ4urthbPilK+rL48s/KaI04q3gbs4yODFo8H8EE9CAf1Kf
         1DhK7C7y9EjRNPubYNnSjV9cXld1SSh+2fBrFGXgySi/DAAQxJmX0pAICPnIXKfhOpsy
         6N89+4WByd9J2kJcizKb5bJmMYoxUvC3DxApE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785920488; x=1786525288;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=006EpaNdFPLDBxr2UIddQMK/UW47PHMTajDC95OOpTM=;
        b=XUGssfUwc7OwY+DTjLN/bOXUmWb0Zl5ocSdc9LA4tdf4oy/IRPlcQ+7ekOxBUfp4pN
         PlyoMqlw/mQt6SJxexvd5zc68tIRj6/8mUs0dhmQMaj2+J6YLT0FoC4PkeuCWqrugbve
         lVwBW0YSbTrTFyGyJTLHzBelBsFwNnO4Fz94Owdis/EWTXo3hIa90IZL80vZezeUXLHv
         YqLBGuBx4/oXAfGe2GvmlVcecb+EJ2xWuvnEEV2vrmF6PWwgFJPF9HojZDuPvqxkuXE0
         MkPNj6p4G157btfSJuZWs8APdT+wojgQjfRJBGbbdIp2B45ZJZFCWYG+RdTrLNWoVWTW
         kEVg==
X-Forwarded-Encrypted: i=1; AHgh+RqEEu6M58IwamKcQ3WGfA/xCp9p0cAUPIxIjyxNnSdPQaVMfSMEjNoXyPqfiD6iP1h5cwxw21nBeQ==@kvack.org
X-Gm-Message-State: AOJu0YxclBOHD7zSrCDdH0DOwRRde3wWK6x6wTfLNSYUVkEcwNmv4tov
	vn6RTQtbQxVDFcazRTD4HkH+KZ52F+FGaNXF8zHkgvxIniOZPIQZ1oPDEZeg6SpYyw==
X-Gm-Gg: AR+sD13YdJf/XQXyvzMioW1b/cgNv2er3YQX5kmP3J77CizOCOtYZx7kzNIh3dc/XR2
	Mc1PfXWhAMPlEQ+TeDfKT5qBiKXnVeoTo2nF1dGswQ3MlJPIyDkPp0XljBjrqXEd7rHm1nhk87F
	owWM3LNcd4Ds3gsRqrqqedAZSLaMkb4XFVvwDDwCq8eSQaRd4A0T0bvcHfU9X5weyy0tl4fCt5r
	KWj7kTNYDX4uxEvwwMaIU+JcBsl79i62xC6K52LoHStoN3QmP2a/daOIBlJ8UOs5HAYu7WvmJWc
	BLqVBqZY/a3KpjfFIi/BJf+GiCuTUqD7xr89HLVBPuMWVF6LmrdqlGo9hpQlTNyz1rAMhYxYRq+
	2lrry5jQN8yzmDAoKlUeVH/JKll0BpUMqEa0xb99ocT91wkfYwG0le17XbQubY/FIMcl4xFjAQE
	Kp/nMSht5cKv9pqCeihPAw2oa7gz3p/OLrXn2Gm5Jm2W5HxFe5/MkKH75QggUk40fv2nIYhAae9
	ViRfQLFi/d0Vbb6VbYKPauhzJ30
X-Received: by 2002:a17:90a:d44f:b0:37f:9e21:91d6 with SMTP id 98e67ed59e1d1-3903c6287bbmr2193012a91.13.1785920479816;
        Wed, 05 Aug 2026 02:01:19 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8002:2a47:a704:5a58])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fedc650a0sm3967542a91.14.2026.08.05.02.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 02:01:19 -0700 (PDT)
Date: Wed, 5 Aug 2026 18:01:14 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Barry Song <baohua@kernel.org>, akpm@linux-foundation.org, 
	bigeasy@linutronix.de, hdanton@sina.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, minchan@kernel.org, ryncsn@gmail.com, yosry.ahmed@linux.dev, 
	surenb@google.com, Dongdong Zhang <zhangdongdong5@xiaomi.com>, 
	Suleiman Souhlal <suleiman@google.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression
 backends
Message-ID: <anL7bK6lbp5qTqQy@google.com>
References: <20260805005545.66112-1-baohua@kernel.org>
 <anKQ_qZ1-Q6FchZ9@google.com>
 <CAGsJ_4wD+KNL0yMkuS4GijbHaiyPxgTmqKzkr0DErC0XH30w4A@mail.gmail.com>
 <anKaU6VStrW8zaQo@google.com>
 <CAGsJ_4wQ=mDXuxxTdAZkicN5pJK3SsNTOxHt5oNYrq7CgCVObw@mail.gmail.com>
 <anLGxk3iShEfCB30@google.com>
 <CAGsJ_4xU5VN3abCPzACZoS92MqaUrMHn9EQ1FCJD+wy=upbbMA@mail.gmail.com>
 <anL0utxGYeGOGwjt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anL0utxGYeGOGwjt@google.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: a5eueus7rjko7cjbxsk1csk3xg7yekwf
X-Rspamd-Queue-Id: F05791A000B
X-HE-Tag: 1785920488-710239
X-HE-Meta: U2FsdGVkX1+N/tcqB2MHqjUhZzR6FrQD0RENG73c8UPVXObQfsv6pdM+SqK60lRGPmUoN3xJSBr9CFpq1hCkQTmvXlm6uQQ7zxzpQ/fnifyaKnZsXyzK4QxqjGbaVEkP86zmFTPLutpAgIRmnFFHGJqwr2E4E7RTa0+v6Px2F2jRUdjlCn7F4FrpV6Ws17Jgj7nA8Xd/GtIXFDkh74p8v4uLgom5lKClW0vvBx65zhPL44r+NKcL7i5Ho76ELfBgG7SKoMM4hVCVMFpXrHSEBQsX8Ch80yFXUfo1bNSuaS91t6uLLyNjhTuFB2hoxgC6DBA/NCYbL8c/MlRX5Lm0MIIVZd2ZLWek2NI6rwcmj+0kNn0itW/sZzWXUGB0NLeYJDwp1F5pNNJBO3bGq13S4TJ/AsSOpiHFoCLbHy13mrwfLyLkSdkVNxTFbRlhv3gTRv9dP76fbv7VlbA2gPrVAvDUYEFsZ/U3NpY4DiEOuIuLAWhT9CuOuLXxjJWrTr4RvO2LkfpBezNaLt0lXCGX5KFt+NK7QR1tYrpyydchGlPwG1YKDHOv+k5ISZyeHnQKKQJ5ePaMuc12X6he5t9uvIi6Uz3OKTQLYKviG1rtucXt3yGN7X9dFFnodA5CNOojwMgM4mHWgbYqUgHKIJDro4QNSbZsatiAd2lybJ3Oc69sb2D9E3STgJLELvhBeinCCtfM7gDk1W+NVlrNQWHu4xi9R+jXGfojfpcYjXZBwDLrNmmGZ1Rgn0SWXZiJfZbhKzqDTSLuRSVgk8vxTaT5cfSeqPMdWrAT3Il0n8+T/A0LnXiS267X3vBRGeYC/MFpYeKnc0Ml9nkCdaWUfGMG7V2TFT8cEMGurSBi1CIyIFjZtwYVJ1dB9AWS/tIfG4mz7wDBlgoK9YdWUF4vYaPbjzm1pRE/cO+5wFHsEMnrM3y3iQIyMAs7rA0OaPlEdY/tm8DqPSgP9NHt01k9sqt
 x5jePHqc
 11pgWOaoeTy51UVoaLEKYbvgilidXZd9tZjTFD/9w+4N0nX+iolOrt+ONPe65kYevW70qMt1Kk6S27SGmYbdGkkICLpNBEdr3Hc7P8PxfKHU4Cnw6Lwe81K/8WG4sp1PhEgXfbaUguxkJCzvSeae+ZMf82nvl7liqwYpY1CRfXlx78tVYkMVp/wenMTMGU5qTaKhN8iClPi9r4GCsiUTI8ptR7xwDXMaNBj1EzOfaHIFkhayTpTJwdwP5GPQyO1rcg++C0jgNKjPp9h6H/GVVy/gY1afgfbuShQr2QBXK4kvDpB8zX4Z7IMmxPJVyA+8+PstsGSNUhdxDgR6tlfH0Zt3s82XepbQLrmq2Iizc873/eTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/08/05 17:46), Sergey Senozhatsky wrote:
> On (26/08/05 15:50), Barry Song wrote:


> This sounds interesting. I think all of the S/W backends that we use
> have stateless decompression

OK, that doesn't seem to be true, but just for initial testing
on lzo/lz4 we can simply split the lock.  zstd/deflate need
context for decompression, this doesn't look stateless.

