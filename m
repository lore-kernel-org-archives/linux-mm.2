Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D04FCC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 21:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A418E000A; Tue,  5 Aug 2025 17:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4110D8E0010; Tue,  5 Aug 2025 17:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8778E000A; Tue,  5 Aug 2025 17:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BB528E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 17:40:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEDA8C022F
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 21:40:24 +0000 (UTC)
X-FDA: 83744022768.30.15FE081
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf17.hostedemail.com (Postfix) with ESMTP id D085940008
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 21:40:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CqwfD3S6;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754430023; a=rsa-sha256;
	cv=none;
	b=DJdB7R/EJg9R5hTIeR+mEDxZKn9kGm9UzFD2DHax6ZMNHVvTZLTRtJU9cI1Jnks1tjYdmD
	pR6pVPieRzgts3KFCrJ/HDEKfvRnaYTiyVHRGcfq5rrYtWxOzfIruBDh75k1R9swdiUa3h
	vPvZz1/UD9mLUqvasUd6OmQpj1OvjOE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CqwfD3S6;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754430023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0sK+IRMmvZIS5b70Mvj+/wyunkLl7MeuveXvjL5t+tM=;
	b=fyvP84cttbTSn2KSpZf5P1Cq2D4MMRBtQ2Q32rCCiL5CyRwALGv6uuGFa43pzRQdPrraFD
	zP5VngSfnXCdW8uyoMkEYtdwyipa48i/LFID6kle1VnjWRuNUFMK+H4ZAPuUn1MfTcGCMp
	FH+L/eMac8AVotkxseSgbBeVHflEoA4=
Date: Tue, 5 Aug 2025 14:40:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754430020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0sK+IRMmvZIS5b70Mvj+/wyunkLl7MeuveXvjL5t+tM=;
	b=CqwfD3S6gGowJ8s6DVTQR9M3Gx4llCn/q64AP5zNMpdSvChWDj9Bqp7ID2/vdJaFD4KUJA
	sdufj1XTebgHmxbb6WCJFK1ZnRcSqE5uJo9nf6BaXN82z4Kxtw6JrKgsFS/ys/+3SoSfIT
	/wj0MDmlxnBoj8zYeH21zvSRQwVDPDs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 00/11] Add and use memdesc_flags_t
Message-ID: <kj2ram3biys2ew6thxq5dlbfl3h6g3pyhwat3yzm5wo4pahe32@266jiri3eokk>
References: <20250805172307.1302730-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805172307.1302730-1-willy@infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D085940008
X-Stat-Signature: 4kzy6zg5e5k57h9xxcptn3arhrob947n
X-HE-Tag: 1754430022-469431
X-HE-Meta: U2FsdGVkX19Q+6oGx9kJQRhCGalP4uQ/x170Ysc/QqB9LJ4WwlTakJmBSoxAmmyGIavgPUrSuWSlFKaMB8r77ggk/sjvmocXGPH4ChlCp5dK+TAMMl29owsD7FHjyfSWbfdmbe91ld7S/Cs9QhmNLn7BdvlWQtfKYyBup+oPzgxQvnrUNuPFGkZgv6JMJsJPg96Cs9ZG0MwT8TY485d4mThKvLS3fCUVldkShxA8+4S3YgP890okgRC4aUTUk2nDG6qRoCAl+UhGk3ejfy+uSLRQEWhYpGLfeCzfn27LAOGOmrDJth3Q8QNrSUSQYmGByqlOIHkf6nC6pdu4Ui22WflZVazcpg1AdOoDFMtQ5rKCAiVUQpS/y4UyREFHYcaPnRFrLZtwP8lxrqTF4ACd3WIQpxPDFLEkVaD9mIp3kg9WTC/HL0a8wTggywlo/Jc4nzZ4qbJ4IxcQRfus7RbV0ZgLagt0vXC08UTC5W93WX3cQU9mG2iShsvniD8BuzPpY2ZJItHe4OCdQQO5J6fY+bp0A+iEY5+jaAXMo8CGnSWGDlN0X4jdfSdNBDt3MxRwC4hS/d9JSa1GbtoPCVgJMuMmEOPuSjpvY3d+iylNkHtxqQ4OkEYLhWIsBuCVd2+pfRzbBQ+ukVhPzXJp1+WrqrHWNpYnG22YordqabR/sO1fBnEDdUaLqsLyKr9JJ3YtR11ImLcbAV+rzPLGREqHEeoeQtRUxtY+L3+lCk+HvkAn+nxxJibqhzbl4dP2dW8G9upChUcsPvySWKdEQzAqhVsnsmMxTTjZ2aRhzHF84ekR5EnU7xkbG6/XV4qlkx3UWC2KZAH+tZ3nV2F1vZyouVEscttp8Nfnqnm8fMe92IFFklQJ+8y7JHKiYH+h/T4ZqDxJyZuVAjoldIuVX5ms036r0/gbjxMiK64bzNRgYL1S6NKxErytyw9h9hk4r8LaeYF8QojM1Rg43fQ2RnV
 3k+1QVoN
 AuoDgFvwFYlu/GSFI38EsRLJWEfF7j+qY4GxStHqHltn9Ebx0kk6SmKU7jtkOFx6UWfOWiYbW/TUD4gcOafMWC4MBdHcv4pRah2I9F7rLcE/JV0QrvGjzJgqtUBYgjpKyuCSmWir2FmWkWXRjnL7XI4eSrLGiQm/va2apkxrS6jgILPQbx9URqJvuJmT/bV/FGwJR6PMhXkm38BMWQv8hqmLJU8is9YNkori9qJJzscBCqc1qjYrNzqe192NThHe3icfs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 06:22:50PM +0100, Matthew Wilcox (Oracle) wrote:
>   mm: Introduce memdesc_nid()
...
>   slab: Use memdesc_flags_t
>   slab: Use memdesc_nid()

The above three patches are missing in the email chain. Though I do see
them in your pagecache.git repo.


