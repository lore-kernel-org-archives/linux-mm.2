Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A1BE606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 02:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ViHFEAqt
Received: by kanga.kvack.org (Postfix)
	id 8602F6B05B0; Mon,  9 Nov 2026 21:44:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812286B05B2; Mon,  9 Nov 2026 21:44:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FFE86B05B3; Mon,  9 Nov 2026 21:44:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C35A6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 21:44:26 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B90F61A0839
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:44:25 +0000 (UTC)
X-FDA: 85417665690.18.3DDFA86
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id EA86D40006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:44:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ViHFEAqt;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794278664;
	b=N629/3yhUbPQKA2PeB2Kieo41wX2KhqSDQJyikY0Lbxzy625NP6FmMF6j85ftjVz6AcfAj
	hbPDoMdYR4ITxgE1jxpPcVjnTTxPM57KEiYWBKMpahTsP05f2eYQayvuFAmmX6Q0r/lVjS
	ei3BWHwsoOvt0ukUtKHA6T/wBF12oLA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ViHFEAqt;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794278664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tGrXQabJRkW1FbhmS9p0Mif8T7WdwJdeDHCgDEbxScA=;
	b=yD8ew/UsJ/K1QjCkEtKG+en4mgvpcrlOZ37ZJDc8f5kpBvZm9eootq1auAbZawhtpiauSv
	y4Ro2QofcKKuUPTs3IW+GhJZVh3M8BcYMLgsgNNS2IvsCqaOZxUXUKBxe0JNvAaMf+SOnt
	XeqtCDtlzuWXQoz+OjHy6e055kVtoG0=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8a070755c8cso755482b3a.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 18:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794278663; x=1794883463; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tGrXQabJRkW1FbhmS9p0Mif8T7WdwJdeDHCgDEbxScA=;
        b=ViHFEAqtzAhA4NRaOguxgS9CAt5fyh12USYttI98xDwxPwkaz4MGHUAsbRKhqGc8n2
         h/2bhC3tGDeJ2VJmeA/mnMf/rmBddCVbr1Zx4RSJjH9fbheDlbWi1UJDVAC8JK8DYNNx
         Zb0S6GqpMIQl+iwwPoycJVQkrkKlZVgsLo1Vw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794278663; x=1794883463;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tGrXQabJRkW1FbhmS9p0Mif8T7WdwJdeDHCgDEbxScA=;
        b=KCQ8p5h1hMNp7NemE9d9848Sqjs6B9rhqLHii514/pL2DrFh/BFxz8XR1ojvZIcAdN
         B0q5saUD1+HvFnZ+mX37jYDM2lfZ6jAB4EET3m8eR7lxKxvi8jpsRQS9WInlOumShV9j
         GAGUKJsLDTsiVg5H5LcWB0HS38NQWRDDCwGXf/b9cmUW/eIPPxkXH7nrKrGwD96nJ+O1
         VHBTNsSE2zrhQRrOXxs104iL1oflkLhv8xspQPxYZ10qdeFWVFCl4HGKYVIOCcYy80pW
         GsSjlf5TkZrF9/6lJJpMCGs9zPWZu/POuy/1P2TAWK8P+U5hFcN2ldf9U9PEKWwoOJXo
         hQUA==
X-Forwarded-Encrypted: i=1; AL+hErE4dNVVf6PCI/RdRoIS5EcTNJHk78VncQtXeV4qV4N9++qPzVXxSZEdQtbUFrTm/Rk9Znf/XO55Yw==@kvack.org
X-Gm-Message-State: APuU4Z9LC6GPY/j35T48xN63M4xYbiouTU06t4E0nSXz+NcQfyoJuBBU
	nfM+PKL5/hovKMbetkJTvX/9JlYk5tHQx4dW4ThjK0ZRdfO7Zj3FWMob2oacCwD5cw==
X-Gm-Gg: AYBFou3hY7V5pvvwmIJ3PRtqp1vSBRJuASbdRohAXIKYe3pSj7RkOe1Nfb5AAATXO3O
	tFosA6FDkJaUkGBDFAgjMT1HxuJgg0NXJ2wRCbIFK4LaxhSil//Row8by58rx+xoVom/OmVTUM6
	qztuG4TfBwBu9gy1+yEVA7jm/7aq2LmKB0U5XzYS9KT6qaZFUOTdv+K3UQqi2RZ6hr+EWcK3wth
	X4Oys1I8cZJTa3ZE46dW+FklVItRNwmTDsrEfg8MrQ6Vlyrghx3BN0walnHiPqCScqi068NFe4O
	QeK9ydj9yqr73NA+6o+PkYznuW0rlqesHrkQNedmsWgtAjc+DG6tqoxkLj3F/qBIKCfVO6eVm8z
	xGRlHLfpMjX373cBLfFtIgM4C6uqIY9FS87NcMg0X8mCgt5Ee8/yO3n5TUBrGN9c2Zvh3tQ89s7
	AlHfSDM2xuqOADNrfG7Apt+OgfJrkkQQC6x0WwtJg3/SC8jThUCEg9FdA1FZVeBK+J8J43UhChG
	PEGm8Ur+0jVU0Atwn2dpFvDGO8Nfr4rA8OyyhwDb2WAKXhMx0yElSh+p17Od34HkuX6ae49auno
	eLoeFHeJFlo810b4HRMm8KSYBnlog2na/LC9yyCqlADO8LCIFInEvw6kKCEqNHPgG7eXbg==
X-Received: by 2002:a05:6a21:7303:b0:3eb:a104:f30a with SMTP id adf61e73a8af0-3f18e1df821mr1008561637.12.1794278662747;
        Mon, 09 Nov 2026 18:44:22 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baaa963bd1sm305882b3a.29.2026.11.09.18.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 18:44:22 -0800 (PST)
Date: Tue, 10 Nov 2026 11:44:18 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 5/7] zsmalloc: embed struct zs_handle into zram and zswap
 entries
Message-ID: <avKE9cp35cn5pAMD@google.com>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
 <20261105044752.1997895-6-senozhatsky@chromium.org>
 <auy8-5SW9sCfCCbc@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auy8-5SW9sCfCCbc@google.com>
X-Stat-Signature: 5mitp33rbjxsffx6s5hct9wn9ygexzc6
X-Rspamd-Queue-Id: EA86D40006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794278663-638186
X-HE-Meta: U2FsdGVkX19HO74Mpa+3xsu7BWLFdD/zCIim/M4UjSeOcMUfLghF03zq/Pz1hU7HupQW9rc08/Qz+FdAyD3Zjz/dTelMEBr2gG6i5vEkZUov6gd32Ys8SGzDsXe2IjJC9d3xFM+W6O0HbGpq/R6nYw5lT6/t5bao2dcLOKJJ5P9ih4HbX+xe9ki9P4icr41t1DOCKmvYkfQ6nP5GSr/jaaXM25NAWSrW0+4wNfAGKosdapjofxPf87+OYZ7NPk1F4ujbKSe+k1vF4/2OvFfgObNgzxA41ZBY/acbJ3kPUL0cncSexMIOKgNO/6+Rt0JyhEW6L7iIxFB33AEm5oRKWjpIq/joLLYqgYPHN05/FwEUmKiAeqGnU87YhuMksGIiJYleGgFk+8M/IKFovh5cvPToQ+Ud9TGSmgeB8mY9cCS1KD7Jx7DgI/LtXaXGs84PDPAOSNbHgM29z9N1TbxSrd7tGULlagW5c6xnc6Q5MDceMUUN3RKaJNj8MMNPP0v9wA3pfOnPvr91HgXQXUg2hD9OuiJHkZ/58Yps5Z9gnN/QgCpxqVtTdDyXGjfpIwW4LvVkNUbI4dXeVDBs7ebOSdJBaLKx021vRIWrx79sDKnr/2Y2uF6K+/PC8OAZWNTQcMbtcBm7XydFsjAyDaaAg/RrztRvEBvWo1XjrEnf/3jTnv73IWvdvYJHJAHkwGTxlaLEqD60aCrK3gZXYT0BxgMK7tRTqtvqqv9GnTTpuIQaaP0kzGPGkn33PuLDwly8R7OFWnpKO5dTrpGmTxnbuJSXUpmQhfEPVU65mOAb7TGueX7jNNrM7eGH+6mCB6dVopodkcYtBP5oEsGDK/QgOymr/98CgBCZA+C3ehW1gjSJCES/ZqY0OBNGcjH03mHxgFpZeYAE+Kdkhf5eplzFKV6XI/WXTjM62LZr7hEqm5hHZxS6XKLKAp+1dpJjoST25HtM+2lRjPXJ8AKXM48
 ESO716r/
 fFc+jC/b2/EmKec1GSpqMy3OQHVEalJUQcxLyvceIbvCfRLDc5i2s+bqe32xevy7TjnhtklDbRdK2D5oyfepO5NqImZ5kZ+dFsfepipItKG3fnCu0E7/xNW5bNuiyJ6BOBUrgu/KiHJn2x8veKG/knX9k6BUi13RZ3wVsqQ+oUYSUuEwvcmaRXf4oKtWzn55CSehBtXELjQKByOf4GWYppjm87vlCvSgxf1FrYtE0idmTTzcvzeMkGzORIJ3JIv1RvUpkQdtYFhAw5PFD+iRm5717GhyJ7QW1ZiVQN2HFyukJP+7G1AZHeg2ckgS0bXwBiivE7x02GOUXgqEQCdpdHOfeENu/FSSFbka6b4MlQmnqX/RzkPu1TRU6Z1ACJ2R7EUVRyMv7j4UVTL+akRdxvjV2Cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/05 17:30), Yosry Ahmed wrote:
> > +#ifdef CONFIG_ZSMALLOC_REBIND_HANDLE
> > +/**
> > + * zs_rebind_handle() - Rebind an allocated object to a new handle.
> > + * @pool: pool the object belongs to
> > + * @dst: unallocated destination handle (must not be on the stack)
> > + * @src: source handle that currently owns the object
> > + *
> > + * Rebinds the object from @src to @dst, updating the object header so
> > + * compaction and page migration update @dst instead of @src, and resets
> > + * @src.
> > + */
> > +void zs_rebind_handle(struct zs_pool *pool, struct zs_handle *dst,
> > +		      struct zs_handle *src)
> > +{
> > +	struct size_class *class;
> > +	struct zspage *zspage;
> > +	unsigned long obj;
> > +
> > +	if (WARN_ON_ONCE(object_is_on_stack(dst) ||
> > +			 zs_handle_is_allocated(dst) ||
> > +			 !zs_handle_is_allocated(src)))
> > +		return;
> > +
> > +	obj_class_get_and_lock(pool, src, &obj, &zspage, &class);
> > +
> > +	if (likely(!ZsHugePage(zspage))) {
> > +		struct zpdesc *zpdesc;
> > +		struct link_free *link;
> > +		unsigned int obj_idx;
> > +		unsigned long off;
> > +		void *vaddr;
> 
> I think this would be easier to read if you move the declarations to the
> top of the function, so that the different logic in the branches is more
> obvious.

Ack.

