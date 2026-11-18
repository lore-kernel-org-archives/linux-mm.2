Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD5AA606A336
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 20:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=modal.com header.i=@modal.com header.a=rsa-sha256 header.s=google header.b=Lrkh8xV9
Received: by kanga.kvack.org (Postfix)
	id CF3A66B05B3; Wed, 18 Nov 2026 15:33:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB0B6B05B4; Wed, 18 Nov 2026 15:33:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE25C6B05B5; Wed, 18 Nov 2026 15:33:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92C586B05B3
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:33:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15B7D80668
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:33:43 +0000 (UTC)
X-FDA: 85449390726.29.A0A6232
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id DB98A140007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 20:33:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=Lrkh8xV9;
	spf=pass (imf09.hostedemail.com: domain of samridh@modal.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=samridh@modal.com;
	dmarc=pass (policy=reject) header.from=modal.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795034021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JBDgcXoBihqhNdiox9gDms8Y3lprFgo5MslXuD+SoQ=;
	b=BxS0TBlcyUDdmd+MpgEnyQxtGza4+cT7M5C8fXnty1nzp4PDWtTUfox2g10nZNLloBRGN/
	r5cKMa3+2bF6dHACP4l2vAiw9UTpYGf6RJk3M3Z8uMqLzK+Va2rlonbB3XDgOOy/Q1+B70
	0tH55Fwvcq/iinn4Hx6YiYaNo0eY79w=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795034021;
	b=cvNWU8mZI45iczh8Li5//5UxWAnpYRXGl2eNcqkz5mH4QQ+y+WDIihFeDBcdK4nrTQ/p2a
	y0zIUWo+z6p6kgmHKflw81jgvgDd9wqXKAfJtGnK+tkvGKzwzea4Z7YsFAFpuDWl/FSQ/z
	AXnK59RqkG/pqHXjZaYSDXHdBdsoVLE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b=Lrkh8xV9;
	spf=pass (imf09.hostedemail.com: domain of samridh@modal.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=samridh@modal.com;
	dmarc=pass (policy=reject) header.from=modal.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8b4d07494b0so2970017b3.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:33:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795034020; cv=none;
        d=google.com; s=arc-20260327;
        b=B+PC+TKbPN1PPMPP9Yehie4XELgx7B4/URECFZSMzHBuP4PeAgYHN7h96/you80e7S
         DZVGApavYQVaRWANTJPXVnN8MbTIya+OhgX4qqH88/5n3X3m5GNFynJ8At7r81FJXVcl
         i7hg8alFTYQUuhFSpjVb6E0AluhqhdMG6hs4MuHpAaypqGu6llGwk7Y3sq1uBxlHKKAS
         TO4ZiAFJ0YzHaa0Tvb6hAKvugTIFAimu9ldhmCD7DE97+ePGw0M1WTLxX7zc3GPh8Yoz
         0lQJDIbvRsrPOIGBJTJgOfNYhVYfg3CwC5I9JVT2C7tRgD7vZoK2pPVi6mK97U8cXLrg
         6p8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=2JBDgcXoBihqhNdiox9gDms8Y3lprFgo5MslXuD+SoQ=;
        fh=q9Y004soaZwRvyZfMjW0Ni9W2sbyToRISpyG1XQHCQ8=;
        b=rA+j4v15ij2+qp48O/Wi3h4SqS1zsGCpaQkpKW9JMFKHP28dmUHzO05pS2362tPDzj
         e3YGRn/+oTda4Lbxrduev4U7HiN62NuRNg5+vwmTo4ixI2N0XGV9cR4Zo3+yVM+fUVGt
         gcsB5Ozv5v3lFQ/J83LPI2xQ0gRnV6QAodx9PoNYVTgjW5b9M9Iq6P/TdDYazrvCHJM/
         3/41l32pa07XCWKfye59U2A/+r4uaj7Hh/JQUFj5vX1uiMm1UCZpoetamzqtc0xOCg1w
         ZPpK12uqHVSFAxzacE1ER05tx4dhpZCZN3vxGWTx+7kloO3Jv/ZPIzSaxOGjtV7y/A6a
         LYJA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=modal.com; s=google; t=1795034020; x=1795638820; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2JBDgcXoBihqhNdiox9gDms8Y3lprFgo5MslXuD+SoQ=;
        b=Lrkh8xV9g4DypIYPd5X+6NXclbDAyvG0JvofR1MLccHy4OE1Aeig/SC2Weejh73L2F
         IhTufiJWlC2xCPzGVbhDxnewJhiNQmhUtehCMcSWwNi6Jv7iOAPQEntyWUJET3LG5YUE
         Aly6p+reeYvfv/dVo5pxDCAF7xnxX81QU2nPYCd78mhSQMBDTv1raaHrdPPY1SRH9QHT
         esNSYDJPHTbR0+S0LgwwRHpboRZVhKT8GAlmEyQFZQlLZmiJv2b71+RxnSx8BZTmTLFe
         Uqnb2mNKrozk46AqQpxsYg+zA8NkzSP17fKfNSN0xLw4RWh34YGaEcocOkEQtx81SD+6
         fVhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795034020; x=1795638820;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=2JBDgcXoBihqhNdiox9gDms8Y3lprFgo5MslXuD+SoQ=;
        b=vdRTswUqZdgDnHl9u//rhke9FMjvNd6KvrZlSOy3a8SghPslroymFTh1Lzo9UtsyJk
         YknSD9oRp5AZjcQ7zhwAKBqn+4m1Xnz9usOcfOsDgnYulkuc6xFsxlssB8LYeuQFQFxj
         mxb+jtA/dcbi5x5KgR+zeqML/y/kdzCpTJ4O94oVa8jn/2lPP9WxurjJuhwKnJSQ9wE9
         wfzs1uWcuYxfZ+TzvvGHEYHHlks/yej7dn91BJceWBpyzU3AvWm1Ka988+tzuYbTMOzk
         +7z6rLVRKWPkwzoQxgdu8flOmmxCrL5ypZ9NKUO3YA2i6EjtyMP7GtyyNYkhpwhyrEOU
         l/ew==
X-Forwarded-Encrypted: i=1; AL+hErHKkz0PbD/impJR1gQM2lH2nq7D/fqP5vbvM1nsPTGKpjucDHRm9aOxRsVCo8qV5pP+2Jn2z5fI1A==@kvack.org
X-Gm-Message-State: APuU4Z9ZZdLbdgCUg4cTBBQJj+5fINqh6xrk7SuoErFAcisvoC3OcpGh
	bQsvPlLhzhskUTRoethRRjoMshHOIdAi86fRVLoCSJ2ZjHw39LgBVP3NSlU7M4r8FxyvjyhgAav
	1mMd795RdDLIb4cOynyKT55MBOdpX25HbecS/atyXIw==
X-Gm-Gg: AZFdTZffl9wCUpAo2KdqBgVDqz4utkNuJOreDH62hc68MPl439JpmmXq6Kvn+zSpdUI
	Gmm8gyFZY60P3i/QfabuG5vW3TmJcgcT67jBOmjyVRKcF1XMOHUxaZfU5oFRqrBjC5YwIThNLKu
	gS7CqFYrXdhI9V8xPt+lln8nxuJsFL7OP4hxJXQWnVTefGcKgJHsjrQN1fSTXHQPDPcUWoMxyUZ
	DSyQFkO6nsCN56pu0tdXLCNeA0Q491KmE1XFAsTIMBADr4UpkoyqdWuTlwe7k8dzXuPDrBkHsjH
	gh7doUPi6wAs8yPKyFEf3hZycKlSUuBxq0HoBx+Vm8KVF5SlxvZIZLlnKyFVdZKtEaKj+Fjk2Dr
	BmOPo7LTg/WI6Vg852J1H2JNTFr+wBtPzb2TRYGk=
X-Received: by 2002:a05:690c:6c85:b0:8b1:46a1:28c7 with SMTP id
 00721157ae682-8b5104a80c6mr2755737b3.12.1795034019636; Wed, 18 Nov 2026
 12:33:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261117-samridh-shmem-send-v1-1-1b897ff562d9@modal.com> <sashiko-outbox-221869@kernel.org>
In-Reply-To: <sashiko-outbox-221869@kernel.org>
From: Fnu Samridh <samridh@modal.com>
Date: Wed, 18 Nov 2026 15:33:28 -0500
X-Gm-Features: AclHuK92GPlB-BaoG60PNu1dFdToy99_DyMmXEi-kkHfbJG6FybfjpWLGEdqxro
Message-ID: <CAKyepcTqbbo__mVm+yybwA2+ruQOrYk=tZdUEPQBTiK+P4ZzYw@mail.gmail.com>
Subject: Re: [PATCH] mm/shmem: avoid zeroing new folios twice with init_on_alloc=1
To: sashiko-reviews@lists.linux.dev
Cc: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org
Content-Type: multipart/alternative; boundary="00000000000019bb99066092ed9b"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DB98A140007
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: h3n5bwze74eqho1d6b8djxhr4tbdrspx
X-HE-Tag: 1795034020-757201
X-HE-Meta: U2FsdGVkX180vUBRpJnWozGtOJVEyJj3US+Nevh1u2Vz+HYP6eOLvxVR3iRH1g37Q2u4I6QhHcT5wSRlYjMg0RVnE3gBmjFu26QkKdZ1sNfFB9Xw2f87th8648jKoUHGaAQeq9UbGlLLxmnbO1ifNMNaGrQSo0XakB3cX3U55i9OytOn3ljtnPH+DAXdUAEFZed41SVSuffTlrPfIPJdlYa3Z5UAmzfDl0yrrbM8qNtZPC0xg7ybKU0qj9AuthUpGibD9pJE2MyebanFXM5Y0gSsQOcMKszeuvNSZCu5b/REPdMQJmxhZHegd0M3mi2ptbWvrXDWAYT68dC7tNH1kvrzd39DZJfQGqSofwsY+BkjlJgPBCwMOg+2rySKIZAZimSctHzw/PYWR8lyQrWglfeSyS63t35t23UHj45Xo4DgmzGvodlFDBrqDF+ST2yw25xpQyyYHqX6ShG6PdFwU3KQpG7ix2tsdcxTeeXYz7yyGvbugWB2zC91Hfmt89UTYgb+29eHbmvmyeJb38yZ7zr8i/0QpKUABBxiCTqYEt0ghEwppZr7opFi1QP9ZwdPjeqQNwbHKU4vHGD4+o/rdErsNmWlPMTA/ZYKi/kJzqjG8txyG6MCJznArptcquZW+uy2krAFqTT1eUhdHRl3Uozx/av99BJ9pOD+CYVxfk5Xe9Ujvi2dq4qhg1iSCcVgns6TUGhC3NqDFIj86XGQ8n9NSVpn2w05nKPZeQB7nZiL4dQ1mgW/lkaPIz9bLPjIcHmaKZ5r0YjsFAHMn2oEitKg8nZIt23qc1woKmh9tkJ/cedElw+SoWFEzbd7SKr2ijv/0GAnD+PQwbC+uqbFJGmOp5Sb+gU2y43CDqA5/Fu05fkDr1k73ub2UdN/ZZ1B4CG2OyKYvKidimXh0CDxv4thqc+ljp4yIST0MD61BAH4dLb3v+J2vEeu2Xjwl7SY16m/k58fl/sTAC1ggoI
 XPEDpGzI
 LhYtgKFQZ+JOkCQ7WyqUZK8V8uQD5Ixi/PjtTbA1j1e+UI2/fQRnu3vj7zefkUjnpYbiqmYClLzwVqC6x6gL4ojsAIxnhlRpOmaFjl3HjaROWabe6V8/fCoFBHKvlSJMbTD2Qs5IoPhiFtanH1VF+K/XwdLtuRgFun1msXVa548kqeVV5nInEnCZmn4trxpg9sbSIJS+hT2DxMmIaInm6b56OLS2COQLwxq6SRJib1j+dHkaKf4J0WwqcWQRJJSCPlldzckXndMRknzN+wCrJqSOM/ZJkVaKV017lEHXcBMZmxGchlDHxBh0MbKq4p5XGz/wgV5DagnCFrOcPDerHcA2sw56+DyK3OmBuo3IoNW1maKiLBtKmP8G2uZwuqpv3SpgQ3ekNJcq2AlmTcE2nIIax9TnGnlIrJgmHCCGth4mBzKcOjkKqsff/4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--00000000000019bb99066092ed9b
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 18, 2026 at 2:32 PM <sashiko-bot@kernel.org> wrote:
> Can skipping clear_highpage() here cause flush_dcache_folio(folio) to run
> on a different CPU from the one that zeroed the folio?

Fixed in v2, which uses user_alloc_needs_zeroing() as Baolin suggested:
https://lore.kernel.org/all/20261118-samridh-shmem-send-v2-1-f2ea01bfc178@modal.com/

--00000000000019bb99066092ed9b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On Wed, Nov 18, 2026 at 2:32 PM &lt;<a href=3D"mailto:sash=
iko-bot@kernel.org">sashiko-bot@kernel.org</a>&gt; wrote:<br>&gt; Can skipp=
ing clear_highpage() here cause flush_dcache_folio(folio) to run<br>&gt; on=
 a different CPU from the one that zeroed the folio?<br><br>Fixed in v2, wh=
ich uses user_alloc_needs_zeroing() as Baolin suggested:<br><a href=3D"http=
s://lore.kernel.org/all/20261118-samridh-shmem-send-v2-1-f2ea01bfc178@modal=
.com/">https://lore.kernel.org/all/20261118-samridh-shmem-send-v2-1-f2ea01b=
fc178@modal.com/</a></div>

--00000000000019bb99066092ed9b--

