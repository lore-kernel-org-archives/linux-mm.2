Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2174C606A219
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fdDoWSfJ
Received: by kanga.kvack.org (Postfix)
	id 306A56B00EF; Tue, 10 Nov 2026 12:57:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8006B05B2; Tue, 10 Nov 2026 12:57:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180496B05B3; Tue, 10 Nov 2026 12:57:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA8226B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:57:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8ACBCC0994
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:57:43 +0000 (UTC)
X-FDA: 85419967206.11.E477493
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9C72B1C000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:57:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fdDoWSfJ;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794333461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9He/fnvIveKiIdStskM2jtFd2W+NnS+TFAR9JUlqKA=;
	b=toZOntWkCStuv5rgcchCm6gZMtqjdUlmRNJYxNMeuBO/kU42goo/liGTZQtcD1xKJxVCEM
	qJAWN+rRgyAoqJrzHuNzF46u0kb4lw3S2zkE7achvsOx/p79j4tf93lsdlMmvMM1OPKKcB
	MjT2nOsaaSVkyNHGxqRUClsHIwhGLro=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794333461;
	b=swq53r2WpyogS2IHhIXMV41flDZucauuAdNoBhm9l9osJ8uwKNqRJ0llBxSdvGPiWNKIOc
	Q2Wd4H6WA4kKRU5mggwiCz109NInPeEzT+xNpe9LbCdpudfLaYI4UjsXBcf6RISKx3uF3D
	2PYBTi0JG+AuxIDR3uXFCAIF78sxFwM=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fdDoWSfJ;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3acd239776cso17182351fa.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:57:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794333460; cv=none;
        d=google.com; s=arc-20260327;
        b=T1dWzVyaXPIEz3ShqmDwX3L5/Jm1Uv0ACOl5sFP/KVQBoPb5HNcPrTCMspEhyNVo72
         qFR85UuqHu9OhBI+Pbg950e4zDoTKVSH1h3+W6VU8/hAiSIqqM5Gi5iH6zNrbwbMOFL/
         5Hy5QHE3NzJwwDz7XYmMEEUMuQZnDbb8/MOqv5n4LboqX0laJLx8oJDsiM6j1xVmCT2Y
         5IGA7GF3w8COtHJAH/ng2aQ+CjLTL5h9JyMxalOiYphskPqhT/yAuGPTtT93k9+4WzKB
         UP5HtKRL/lmwd4HZtX1YnZ58RDMpHNd3HZle0hRbPZdYzU8s+bmsqXgj3JupT4yyQnOu
         P0Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I9He/fnvIveKiIdStskM2jtFd2W+NnS+TFAR9JUlqKA=;
        fh=n4C5mzEIiqlo2Y5aAuomFYSuf4qj5+WkaN8lHFDh7hU=;
        b=VeNdsr1LfhmPnM8HvVZVY629yuQy6338wOdjlMSdx2tQLRVVRkCjKrJSU89yXSAP4A
         JPg4gxwTWmQTCV11hhpryhOz6NVtArEAQl32HCHecb9UZD9AavYL/NWpvTwpPeipHQVB
         cJX6lXjzMAMpcVSKfDeELpPTfCNLwm1AmW+dVkj7Hq7rUl29LB5o/DOVh+bmmXv8KWIX
         BWOF7xGe608MVVMqShP2RA2AFGRJZsdQdh6AD5SRaaHEPUW0pm9B6RBKhA8NZKJ8Crub
         5HJxNKpraFy8Vemql/rYqG4G+oBFPFdkJNufHW1DH22py+3FXqaiynlQ23Ze8DVXi6TU
         7LwQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794333460; x=1794938260; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I9He/fnvIveKiIdStskM2jtFd2W+NnS+TFAR9JUlqKA=;
        b=fdDoWSfJk+OAJLGA8NIV41ZATCcpTuXrme8Gn/rTi/nVuwGkegGYnthlwl8MyQf0qR
         1Xc9lcGYD1AGM8r9r/UKJDJyVGCSfaC49YP04AWNKvQ4ZZ2xATETyk4VImN85BnjbREf
         9qzholWTLIBHT9HwGSgqQd5S8/BR0b/hNUydOzraOe9wtuX1SYUuxKYP06jw5VS7wHVo
         S53mSbOSoZfTbs0FTr2j3a8eptn+geX1HNNjISuUUFax03eTJ9AI8p1BnARqWZ3e2AED
         0EDrrKndMNP92Cuz6gV8L/gm3B1cVT41F580AsWzfLA6pYP8SRoLmDQev1+EYhdq6bpd
         Qz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794333460; x=1794938260;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I9He/fnvIveKiIdStskM2jtFd2W+NnS+TFAR9JUlqKA=;
        b=htHD3FGy5H1biYWL8dHQ1IUykY9Z4+RoaRxL3o7aJGzrAIbYMydgA171JeGIo4SzIo
         qnb3kUBLH+n2L3gkL7aI/l3V/8OjW8sW3nf65T1FsSFt5UjNz9YqOTOY76uTySLJ24yh
         1IXr0Kp5TetehaoNp/nvi10eKDqZs6gKKi0AUANBK46yZybf1pUCxThKXZpsCBlHyXxB
         eD5y66sgushwAgOPDGTdIVWahA07J8vbMD7LmLzm2WwfJoH/A3QhddZKOQWkfLQEpSq9
         C3DNFKTqp9UHpzUTvDhb5plqgl7Lv/a+Iy8ExRuUo/eqx1+shS0VmmYNke8d4wGu6BNG
         VUsA==
X-Forwarded-Encrypted: i=1; AL+hErHMF+Nyg3eaKq26bfmfRAT5yCR8O12woMOY23Gl+QuE2iSFejyMUvJkLHE6KUJt+ItGazjAupXP5Q==@kvack.org
X-Gm-Message-State: APuU4Z/zy/64E+bqZsuPKIYVJaSK6VN/SD76CldY/duUzlpTDsIeX3VV
	zNDPxbRLLpPXuUiASpcO4bEjv1nyL4TwCKdsb7IT3uPCcONcm1Istm3Zt/zKruWj62Ov/F5ujLD
	QNqBRfmuG0S/4RXkhK138z8qUjwGSUMNBc2reuBg=
X-Gm-Gg: AYBFou1yOJ03CluOjWYbCSdhOf8ZqdDiBidOtbX7w07gqYVWvKPC6XMZUZEt4GX46uf
	BdGFsY/5b4VMFPbhPVy07QWFjz8hDsMnglpx51XOtYBJ9PXm8a2zUCHnH/dgArZPKqQ/czTU9Ig
	UzC73OndjTwWsy7gk5XJJ9N/xzBJfwC9IvWbViqb9qBGMEyrprNPUEwWjhdWUBTGJIQfA/kMS1K
	SJCx9tCwynZdgfmKucTt5TEIyLhbuybb6lxYn7YcykXYX5A/N3WG7YaT80Rbzd/l24hgbLFeYcp
	wclMiM15KZSxatZlafROizGmti6teYCdwvz4RbnbkZTczP7w+OFdLGv+V0q/FP+xcVLHryRHcHX
	3qnUcM53llI0IC5FPjjrRMNzjEc6ofIMb0+tbxHBRdspVVmiGQBckDi/st7RCKhcKQe+UGQ7nOb
	pvndtuQ5ohet72bvzoOiY1u1Fa5c5Xw/ytL04461ZuyTZ5tl3FKp2j
X-Received: by 2002:a05:651c:158e:b0:3ad:f0bb:344c with SMTP id
 38308e7fff4ca-3ae0961f342mr5818461fa.10.1794333460012; Tue, 10 Nov 2026
 09:57:40 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110054836.1515030-1-senozhatsky@chromium.org> <20261110054836.1515030-9-senozhatsky@chromium.org>
In-Reply-To: <20261110054836.1515030-9-senozhatsky@chromium.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Nov 2026 10:57:27 -0700
X-Gm-Features: AclHuK8pPFE0hpuvuz_PzsjrrD8lcbAsp3pcgD0h8PmRUyeyRyhQq1XIFPx1444
Message-ID: <CAKEwX=OhvH80f-6emK0fBhbm2d4Er0rQ8oXX=FmfG0vrTdvZdA@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] zsmalloc: encode 1-based obj_idx so valid obj is
 never 0
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: 7uxbw58mwkcyh5f5wr5gttkbya4tqx4e
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9C72B1C000C
X-Rspam-User: 
X-HE-Tag: 1794333461-855156
X-HE-Meta: U2FsdGVkX1/ZHr4FQkisPV/P65J7mwQ4gmjxUWhEBB7t/AxqzmLeH19mjabNHhXeTdjgPwPFvensEa5hlTHDrR63zD8fLAXgcb5Yc37Uzcl2Tn/lscTKgKjXPqoxogEizzVPGgG/Qz5L3+QVD1xYQAwBkOlPQFfJmJZIQ+21u+BknZAy8jXPY7s3lXUevb4B5btAp8c7/cXbR7iihnS+Z4i2kqK3wCrNo0NniRqnNqvorIPWWsbdlwFi8fUpoyH4V3zqSCzwdmhPNnBKuzlLmqgamMVUg5uYtsorx81czE8rPzE+ZKrS+neLjdZcfyiXJKLQ8LwpnE7At+5gbWXf15/JSjQfcIClk/53rZXy1bJV+TOqJTSVvhiK47xVDFF8rE/2xzDwVMWup44aKsEiS6lf9vUv8u2WNRi8DCS1IV76lCpa90WAlnlr9KmJJ6jk3XnATllbkCiCQKoSjbfKNw930cRC/G4GR8bmy+3ntYFP99Ul3eToYupkxVpoJ90XYLeIMTklsAq+DWZtdEOcS5PoIBuoGtQXCMuz332eFA7LWrIThRmrfD+wkXUZBGqGJy1L7N1yq6rXpXbt1VSaWYnWkc/4XSihVvBgz+PBZWhPa7udnlNb0lFwLy8K47ih23zOtCys2siXNDiys6mvBBIzEheG8J1dkOr2FxYfAk2SKYvTzyneINxHv5nWPYsm/ZzktWNLDzFJbuqPzviV2FC/wMDyYZthwj137De6VnYVIj4ozS2tB9gbTN9z+TzdaduBI7eFzhRT9/VuKe8NmCyMV+OxfaWHu1L3Acn+dKlhTaLEE3uRFYSL5CdP7yqkSy/V0J+XzU4rwz5SvhJTSbO6obraBLrlA1EwIJ/uGbwuFWpcnjs0RDz99QkqcwXtXDJndNCgLANsLJFiJdsp21Avdw2JFmQlRO/qENW43nG0HItwtWrgOFE/PMeWjKVHQGudUNv9DTMQlHCZCEe
 r0etRbSM
 8OEvBpBhcrzXF0//X9cywEIz+cbrDeNukp9URIzEtW7vT3ITIP673hbzMbbAxxP2x0K62YxveNgbxJ//ejFuWknwf72gNZn0r20yEpdZ0dWPNH+Rwz8JQBtMpPi7TlQb0FbI4p6+TjfBLActI4NnX04tdnELWRPMMWjsjfzFGnCfVu2dQkfnJaOQ6u9OsWkETYWS2kEQ4oxVzKD8h8oAm0/FS7hgX9w4CvRGDFxHthQRl2eHYcFj74mgiLsoSz2AhuJ//ibQb24SvMq999rNYxFOzfrJ8MsOmb7SX2RfdmXj7Q0etOgR5oMRK/3eJos3/t4Kbnw3t0RdSmOFVydq84FqCEAdxND41uwyU0B0JXNtts/yh3ZTzs9z8BRMUIMxDLFswLJtNW63K0dsSKjvyeoKaP8oJOcsgE6ZA0O2EvgZk4UIstsApola/jZ1PYRMF9Y+wUD1a6gPSCUaTmViDuLYgDDZV8d5nl0dgSWFXiX+jFFG70SdLJ1Z+OA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 10:49=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> The next patch embeds struct zs_handle into zram and zswap entries,
> and a handle is considered allocated when its obj is not 0.  But obj
> can be 0: object 0 of a zspage whose first page is PFN 0 encodes to
> 0, and some platforms do give PFN 0 to the page allocator.
>
> Store obj_idx + 1 in obj, so that a valid obj is never 0, and adjust
> ZS_MIN_ALLOC_SIZE so that the largest index still fits.  Unlike a
> separate tag bit, this doesn't take any bits from obj.  zsmalloc did
> the same before handles moved to handle_cachep, see
> commit 67296874eb1c ("staging: zsmalloc: Ensure handle is never 0 on
> success").
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Bit convoluted, I assume the this is so that we can use obj's 0 value
to mark unallocated state?

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

