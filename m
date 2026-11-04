Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F7CE606B2DD
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 22:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Oxi50B5v
Received: by kanga.kvack.org (Postfix)
	id 895ED6B05B2; Wed,  4 Nov 2026 17:17:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846F36B05B4; Wed,  4 Nov 2026 17:17:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7359E6B05B5; Wed,  4 Nov 2026 17:17:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1AA6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 17:17:05 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D8D69140863
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:17:04 +0000 (UTC)
X-FDA: 85398847968.11.2CFCA9C
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0AC2BC0003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:17:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Oxi50B5v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793830623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AoRyT2gWGztVgBxsNZy1AlqhQ+YolidchQOTos+xRqQ=;
	b=IaW3IPvqmKU8u/AxNOsG3mmVsv8jckygHVSGZg4QGtLPi41XbRYXSXB0sCN8GMP+L8hdf8
	2efv3MTPaNnwKab8rLMnrtrVifZzYI1v//jxrjVq+RlaOZ3Exavi1a9iHsKbeR5IA0RLYD
	+Q0OeToRnUIGNMXTSokDCBgaNjFj74Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Oxi50B5v;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793830623;
	b=TxhWnBSqvkq69bwG3MU1z0rpkzwTUqONxTYBuHboo5IBdAkcd6hxCoDqqdxqQaWGgtTV+H
	trxBLhxFEh+gUl2WGcTPjyUMYir6KfErk2iCmhfK4wuv8CaD/H48R+BCPbdwxyCN7HMZw/
	acsm0OE9DFAaJ4UlS+XBVr7yVA/d9Yo=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso8206425e9.2
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 14:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793830622; x=1794435422; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AoRyT2gWGztVgBxsNZy1AlqhQ+YolidchQOTos+xRqQ=;
        b=Oxi50B5voRYOx/wHro1B2OluJLKCqIpp48J9X/EqVo7nTIykoGVuUS908EzDrKjpEH
         //M3DrY7c6N6dV1YFKI5TaN4+UFDAT6RL469YblQttPp6nwet9Bh/2UCgCdvrHZn430u
         2nukUKvfNfl6oiKlGp/hK5lkEYEXi2EdHbm8k72M16EI3sTHEvtUeYpkioVaQu2r59q5
         pelJWKfXhSxTBJr9smGsJLA1V1nsIIoCcouJg+kSW/uj/fJVfZd4CHvzpioEmQVKfqg4
         C6sCogapGMlN2lPivV601W/jBFzUYxed3LiCH3NNbcZHD97scCYkRPFJ2K2EmXh+eJE+
         D6uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793830622; x=1794435422;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AoRyT2gWGztVgBxsNZy1AlqhQ+YolidchQOTos+xRqQ=;
        b=Iw6f0qXxvAtXLfizPE7uVnbEauTD4nbSj9qUyhFS22wNxY73sFrUk03ltkSHHyJQgC
         +LfjgGKpfrxGgDp8giBvxtf3cGcWZ4JalrFCf56I7YCh/xra/+/Kzha285TFVNSfrqQE
         xcldUecvwSAhPOPqU9AB5OiXea9+kf83jv4uxRNKims+6uM5kYiNdIdklm+2fdXjhPSH
         k2RRgKaThAT81Th+fwFpU0gc46dzspw2UEfupPIeUbzJ/FBDpdbNS5iDQW1Hj+1UvuBW
         wqaA91tOEJemFCVbVTY5ES/2HaOUBK5mCyItbgmugpwje0s5SnSK92HTuV4G0G4L9oJq
         7M+g==
X-Forwarded-Encrypted: i=1; AKwUvBzVjJUH2dqwVJuYwYarEMTVWkYjTPNtn1IuiaWqrQB5xUU8buReRt4Wyg8t4ADnr6HdA/7noe/guQ==@kvack.org
X-Gm-Message-State: APuU4Z9hcwxAOxYKuXqGtUQk6pGeSfPH3QBt75wkG7t1XcJulZNVEO5S
	hlEL1DigOaMH4m/nAV88GuGxEcNWS0d9G6obusAs3RJXnBcoLnsVBeZ1ZCeOUOBVyrY=
X-Gm-Gg: AYBFou3yhP4qIHnT5spo1RbjHAgP0w8i4YBoz/IyHrZy+EG04t39eZs0cvM9is1Fs7A
	6FnuUa71rsDjb3th2OZwur9Z1DG7wqj8GDHoaHjOrhZizmWxwJV3CNG/niy8qTlvTCisVldOr29
	GJGGLrG/3cpLZ+7Q5fy06MAHbD0fSWERdeRSceaFs+3ciMy+S9P/Gzc50YEkhFFkHnhyHrvQkEt
	4vQfK0qvmlrQditFS5fdQnv1fPe+TTxe9yxNt/+nMevNZwOX50oKUhOP+Zc3Ow5aJgvGXnU/9Vr
	79BH/2HXTo7maqu4OyvdSx4GSjQ1D4NmErjJL1wNtjMaXLrWb9EJaz+VTgNensHZplH0vhGECvH
	i1ujKNK14qv/7JysJ9Y03NL5XEjl/GMxvqKHY3H87UM0yWkzOnRNP0IaHRte0J4fOmWlhw/GZQU
	z/mHVAnQG4JlELmOHH5atYRYfQy4QPGuUNrPaokW7b0fsd+gl6VneXtJHkWFQW7ARFGFhtGf0C7
	Qb9+G1d5Ui0PP3qB0pmMPNwPOHZDqIERJXLRhNaCQorDHNAOl+gvXiG5mTk/grWg961HQy8uDCb
	5UYaTg/0Qgj0kmmXOezxf+I=
X-Received: by 2002:a05:600c:e548:20b0:4ac:86c9:b09c with SMTP id 5b1f17b1804b1-4ac86c9b146mr248866895e9.13.1793830621562;
        Wed, 04 Nov 2026 14:17:01 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56ef2e968sm16301645e9.8.2026.11.04.14.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 14:17:01 -0800 (PST)
Message-ID: <be34e0ca-4706-44a8-8264-3b9827829e9b@gmail.com>
Date: Wed, 4 Nov 2026 23:17:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] kho: skip zero-sized lowmem and global bootmem
 areas
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>,
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>,
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-2-b0d1a834780f@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261104-kho-bootmem-sizing-v2-2-b0d1a834780f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0AC2BC0003
X-Stat-Signature: 64jabn7uwrium891uneio4py87uujnee
X-Rspam-User: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793830622-139344
X-HE-Meta: U2FsdGVkX18lenxP9rVs2Am8RYYWW4OyET6nqDS45NlaRRS2Yp0U2sLAkEFshls2muPaIlseLc1Y+c2zwDzNcFic9XBb0L4icNR2inS73ePuRk4fWutl4FhzMj1PUCmYZYb9Kqn4GUIy6eG1kIIlorVGtptofQvXcq0qJumC+fWaqb07dGUxYM6JKG/Rahgh8sQAM44TLtpJLynkR1dzvRHdGwyFlnCgdSMONH4zezQ/jWGAN+2rO+hFJubeqrq5k189HIxEc2+U9n5Hh/8Ymra+du21gDZ4kgdZ+sjMdmjkQXxeBdRlnvg9/uCwSPvnExnNXv8rvrR9qE5Q3Jhce9x+oG5Ou1m33L2qvnjvRlx0uyT/DvRB3fv37Nohcp/VLVw+cd044WnWpXxu2QLEXbigl4IGi+7lUB+/8xOzbe+La4UILpgmc1V1u3TZE9k9fjXOt0XmwznIolkTMcGdUCe3xlfMdVo/H8itXKgqLr0rql/dO3iWYRR9VI+v9hsiLcU/9PZSDGnRT3JPeYSn4FaJgkZW33V5vR1ZJZzzYVmK8CqQ6rdD+oHeCsuReNAU6MWLd0vmpkGJ9y9UjeDLKmUqQedAMw2Nw8NAe913Vnrm56/iUlVPssst0NULAljCGT+ypMUXtL5HMUiZG5TElDuWVfFNl9kzpLNgJrtvaKIXVgdHe0g9cIn2A8hKVYoxTiBF3XmfrcoQ/Br2DuS/P0Z4S75PuWtd6EmVJLkAIkNrX0RDGtloHCmxbFm9hJxRDYWfvfqWv1fd6IAg6xBlVLOZhQleA3dmAJHDFYtl3Iu8jCq0AfzPFJPS2XApHRp5cmm6wCQSzUDP76PElq6uqRQKuDLiUwYQFiqUiAa9aaO4WjvN0jbwQOq6UiDlzhfypeW2Xyxb4FrJhzF4r4MyAOwXoqCOc0eYyRiSD3MQ129fvgEDBoom9IxfC5m2h784nTyftUfHlfu4DPB+/oO
 syf1lq8/
 6INs2h0rlUt32qPt2aSzruXOnCZrmCpb7vvi36dE8ts5XuDAZpvYnU5iXgDezCwhGZnEu+NOX4RQE3qqU2XT8DZXdzcK1VEu3fr7hSnTa7DvUsGOaxw03gfqfDsEfVr1INLN4g9Q7JJpjgrH342RrxpkRkQepKSFYhEQB51nrxzmdjKY8tLxzB9FrdrBzpQEoVbqMDKm1qOkb6sUePeokvgXXV+D6X/Xf3i4L1dA9npFEb0lM3y4g8SHkaSPUlgyZ3ouvDWcY859uJyIY3mrLz+6NhXByMYpBA89woCRnw1kki3uZz41S1oRFSN6x3XO8b2rlwAG9cxAE64WsdWeqGvzbV/HbjD3v2tOASz+tUpmUimy9+oeGV9wM3ScOOpg/MbRO+tC03DqlWgUOzaPKLtqV2uTZhRj733iBak1VQTmotFCFrRptFw3toMq/1h+Ni2DG0HS/ePTHOFxmyPFfc6iEY8uSb1mt9ToWpeu58wG1a5Zmmc8rN5CBhVDVCgQQ0H0J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 5:50 PM, Mike Rapoport (Microsoft) wrote:
> The lowmem and the global bootmem areas can have zero size, for example
> when none or all of the memory is below ARCH_LOW_ADDRESS_LIMIT, or when
> either of those areas is explicitly set to zero with kho_bootmem=.
> 
> For a zero-sized allocation memblock returns an address without reserving
> anything, and that empty area is recorded in kho_bootmem. If there is no
> memory below ARCH_LOW_ADDRESS_LIMIT, allocation of the empty lowmem area
> fails and KHO gets disabled.
> 
> Extract a helper that checks for zero size and allocates memory from
> memblock, and use it to skip empty areas the same way as empty per-node
> areas are skipped.
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Reported-by: Chen Pei <cp0613@linux.alibaba.com>
> Closes: https://lore.kernel.org/all/20261026131851.9942-1-cp0613@linux.alibaba.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

