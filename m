Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA21606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 11:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=peRuJpOy
Received: by kanga.kvack.org (Postfix)
	id A7BC76B05B7; Tue, 17 Nov 2026 06:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52996B05B8; Tue, 17 Nov 2026 06:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969576B05B9; Tue, 17 Nov 2026 06:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFCE6B05B7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:00:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CD27F1C3AD1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:00:25 +0000 (UTC)
X-FDA: 85444317210.03.3217021
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id E1156100011
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:00:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=peRuJpOy;
	spf=pass (imf14.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794913224;
	b=4inxxoVQa1XS9SnPWzkOjMK8p51oj5toFM469rz7wzHXBzdOlhDxXU05Ho4Nd7ZyNWAiy4
	UVDoC2PcLKRH5ztLnOJNPDG1eoE+iakAJg6Ig8eLdx4a1/mas7mC6mXDfxpF8Gn7JmPvSd
	DmJasdmM8usgJT1QyruWGfGtKVrjhqE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=peRuJpOy;
	spf=pass (imf14.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794913224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3AXZBYyaaLha1235Jifs6+NRua5WAqO1ulZoEtAElw=;
	b=lWxWz6zhoxSkwwIsVWFICT/1YeuNqzuZHhKsOi5Xb/P7H/0Njt74DGix6yCCz+iCTpwdec
	FTm7I7OeaEvBVOGx3uUPgLk6G8CkQOT+3clvbnKShd4v0ZsFzwCs1NattvcmBO9qEpgsM8
	bF6zktzzx5R2yRYnpx8uA83jBIWOepc=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-380c17707ddso176094eec.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794913223; x=1795518023; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+3AXZBYyaaLha1235Jifs6+NRua5WAqO1ulZoEtAElw=;
        b=peRuJpOyPHXgydm8TEITMq3BCrrhlHKuNTqlFULqQ+11OQa9HtGh+GEaK7BG9ihgWd
         5Em3iWUa9yj0ytUBsgyzx0mHKRm4ACDOXfCNZ04FFJyJ9Xz8YbsUX8UY55tgNjWMVACo
         gXamSKRWE+qcmiPbOjoY9/lZfNKn1XL7Jq4KvmNlCSrgNlKdbkxXSRvCZSIfizlxaXf7
         s1v1XCtQQilotfrqoM3mWlX1iCnuBszT24uOvWaXoUH2PuKIW+B+01VDlcyoh+o+pMgA
         9tBDnAIejlVqE/NE/7FRWIhg0UTV4S2fQegiZ56kIkyHJzYbGu/vM26qHs9a5AUsmf5U
         s5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794913223; x=1795518023;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+3AXZBYyaaLha1235Jifs6+NRua5WAqO1ulZoEtAElw=;
        b=BkYzZRJKtLfZNW2mY46SjD+JMdCnHte731Zy5voGlu9yxCuVhG/Gqd7Za0uZU5Yg6q
         FLjnA1ChF7HETxFHeUyyHQ6ns5NzoRy1M2bvrTZeeUGptEqi4ww8GiNT/daaV8EYaaj2
         RcclFaqM6CQ4Eon82EVeIIQVPc36WZBatjc3abPrSTNUau/XzqzG21HDKcU2yXtkR+hL
         kWwK0dBUm05UOFs+E+Tmpdi+OE6udcXWykChjIgDJHwWjg2IGjHY2LV+hx8x7YAPQUBn
         u2FrpK7pbf460v9LQX28xbIfg+BDYtvwXmhJe7BlV9kqvnHptsfwRDNpunbWPesA1Tf4
         tbwg==
X-Forwarded-Encrypted: i=1; AL+hErGFyipkhLcHPxmceEbjjyTbNIFHHNNjPwaNFP95OMCAPwn2cUlzlXggbCKFwxpgfpFgXnMZfyoiDQ==@kvack.org
X-Gm-Message-State: APuU4Z+e8yq362ETvXh63IB3smri53F6pcDusWWw1h0ZTVMHy/sKjroE
	8ZEqJPqAbhO82g5tVT5stfZYsjVLCwOnm3FD4uxAJYTRB/brUIRaUZ6z
X-Gm-Gg: AYBFou3LCYFU8+EXaPxz6cfqlTFnpQYV1/S+ARNaYbEMbUi+i3TOazau0d9dVIGKmzD
	3XTf3XTrXLEm8qjJ3/zw6HAOCUVvDSVvx5kuIgDMoIRyaz6IT3T2qX1tiX5R88bEu9JTms+VWqb
	w0GIlJJEdvWWXz2hHfNQoxaMLIDWvpPQbbpg4mYKhPpbt4oLQ77vYKL7igQBubi3Xe7e6y0LlsA
	A7RKV2Wl6mf4aglMA6DqLmCLlwqLuFfkU+oivVsBEBXvNU3/SMWppyAPmQFyi2jF2S6fQWxMjVW
	3jzpZA98XM7cHqlb2HwHJ6ibIqfKMfQ9I6Kc67TSo1XPe0Xh6+pha/hedJCdeo2nOmPxLcHW0ym
	tv75XXXS89lXXzvcGVoEuzS0qEaVMMMyAfhTXodYjF6zghbryChDYeOMQr3ayfERXcb08QFDTMp
	yRfJ8nGVrmK8fUs8mDe0hFzmOmM/BuTjHU/bW0yWdvWzn8h6NJvt8WNRs3Kt/X0v1rxeVpuHc3F
	WupULKqZXSLTm83oEpzwLscX8BFBKF1aIqAn4Il7Px/XNeuIIjlR8nySmuXMzTZ/vOzl8bPP6hX
	Nur4zrhBCD1HnzODQfuMESa7GU3d3j/ARUksN8x5H0DVLEGn51Z0nVulQ2ErvgsKCK8=
X-Received: by 2002:a05:7300:7481:b0:36d:cd5d:d809 with SMTP id 5a478bee46e88-37964ff2d6emr27080643eec.1.1794913222375;
        Tue, 17 Nov 2026 03:00:22 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37956bb0c40sm44844871eec.28.2026.11.17.03.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 03:00:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 10/11] zsmalloc: fold zs_obj_write() into zs_store()
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
 Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
 linux-mm@kvack.org, Yosry Ahmed <yosry@kernel.org>
In-Reply-To: <20261111064707.2568433-11-senozhatsky@chromium.org>
References: <20261111064707.2568433-1-senozhatsky@chromium.org>
 <20261111064707.2568433-11-senozhatsky@chromium.org>
Date: Tue, 17 Nov 2026 19:00:12 +0800
Message-Id: <179491321252.964041.5043408594966028356.b4-review@b4>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E1156100011
X-Stat-Signature: jqftjn6ucfgh11rboj9qzbiqcy7jckwe
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794913223-963507
X-HE-Meta: U2FsdGVkX191GHK01mCsDDbLEs9VftCAJabHMOspRivhOP9sjybexUC927aEOcnNvRlbPChX2ZyT73hGJBfdV1kqDkzUtnSwBGjCdIZFV7Qno1IU3PTzAXBcQyZnAugVL5sB/4n07QEBQJE2eyR+zB2+rZ9arOvwUBu5rW9W8ueqUKcatvWIK7AHXXDXeGotxaVVbz4JnyyZ1chBVA33q0docxrHfIdNZQZQ2t3oUNbXNo/NzIFFOrMKtauPYedxSvyPDc1SvWyxPxIwAIS8R9NzBktveo49FyzorxIyx9CEEN6FMWgR0f27T4GdJxQ3Yv5bpLZWdFGGMgXAbmV2lI/McTPa+8gYr5lKjHqVT/g+PSLK54Ubk9POSzWI5zr9yrlqzdFqONg1d1w9OIlngalOz9Kkhjedx8/YKq6Uw7kXvY6biCKS9SK35PuyFrODyTWCNynjmLQVxFG69vbQ29CwS78H7mnrsCrtPmvJZdftfKxmwa5zcpLoOB6F8vH4jP/ln1tohZAjKEb+Afylvb1AHF3rVLRfuD/4+P/DX99VsaAv4XdEg22AB4JsWmr0XuSMI3TW8kh/Sb6c9QIBq52UFBH+Azrfkvgr+ELSgRyK/iHCvwTIpuBMaSGDAsXi4zTQwaZMrVA3w8rj0elwmMV8VtAefphHUSsFJktXTTp1s792t5ygJEJV41VYghSQRW/+sQHlDD6RwxkZzwd4GZuJkAvmfq0YshjFrAjQyae1ZMJnLQJ8MKUy2/JgdA3VoIRhDBJBYBcXoSJm2Vqxl24kkqDBKa7bWr9BWopQXpH7Lf01Dj8byrkB9OYZxKoBiXaUDiZgO2GwnOf/tyg6fBBXv0CiVy7flBRMtxFSdlOpyGYw1FhD+HHl2yylCxsnEeHvcxTfCmvSak1ZogLGRpbt+jkH5LtjR36ZBYEB86KSjm3FrslVE/OIOzBhK5Re28dfyMqHUI2VZJk2SFk
 w8KKK7QL
 1oNnpai+4verCju1zHHyWn77BHB7hB2IJ+TwjMYYmBxLgmzA6ecs8Pw5UAooQzad2V0JogFGTcmnBt90W55aEs+4XrAr6P38zx+BwXLfhXlI2vPXjp9E4k6RbrNCjE2OBHkMMHSgBx6A2Hz5SZJd4Yh0kVAfJ5mh+TaNKdtpR3go8I5uQpQZEbJE2nrSbml3pFZfBGdA5aly0rYOWnT6ewtFAtwh8tBHjp4LHOuapJcZGnR/EtQitV6wy/f7h53oD1l4nC+M+YsL6ytMEIqQuOCmOow1UAJdWW8FeB8xe6aadrivjTx6WN/F235Cj74PAqQITrsR6QLgkbIr0Ot74HLihSEqfVuTbQKisTvGzLir5KIdqRjRHKTJ9xVsG5uTLQNr6lHiNghBveVDZl6aUMu5FBzV17GD+4jvcMI1CXtv0iLXqnhiQkp0M/z8AWYMKgoPu215y76cTPXcGkOKHx4X5ia1x0eQbEw/4G1oJQ6XaW/7sHShLNqm0l6f+rZ2+r2dzNS/7/ltvKBHvDo0SfwN/WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 15:46:33 +0900, Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> zram and zswap always call zs_obj_write() right after zs_malloc(), and
> zs_obj_write() has to take pool->lock and look up object location
> again, which zs_malloc() just did.
> 
> Replace zs_malloc() and zs_obj_write() with one single zs_store()
> call.
> 
> [...]

Reviewed-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

-- 
Best regards,
Xueyuan


