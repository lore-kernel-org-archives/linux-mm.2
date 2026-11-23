Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC581606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NyeYpXUt
Received: by kanga.kvack.org (Postfix)
	id D12956B05B1; Mon, 23 Nov 2026 06:54:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9BAB6B05B5; Mon, 23 Nov 2026 06:54:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C036B05C0; Mon, 23 Nov 2026 06:54:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F6426B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:54:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33166A84EA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:54:22 +0000 (UTC)
X-FDA: 85466225964.10.E83841D
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E9921C0006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:54:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NyeYpXUt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795434860;
	b=FSFQ1UcWp/ucttATS419R2aYP63KKoK0lB8Xvk5dXNoruPb99/Z01IjbklYL0GP1/sH76V
	i5AjjE+9oU2n39YkoPlKhu9cJVk9NjikOaDkRtTr0tuhpt4dZMGYYElcfgF46YVaYAG2TR
	zqjwEvLDXCVJC+GiBdQ8sj5/3VzSHrE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795434860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4oNKX9YSaQ7zR9YQ0CZmPGolVckVsLjzNRd1vRsTh0=;
	b=5F3x7NPEJ41PkvZhLSSWUqhkizVbU/9G+og5vtDfUYyR8QWy3d4plVtrn26NJwCC6g1fh6
	LcbFEgnGdGXJsrMBuz6D49XIDs1vbhmXeNWp0Tmik6qFwwnB6Q8c3KrIOTknrdSkQ+aEbw
	OT3NBq4bynv8S7lQIG6CTNiR6EgR57g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NyeYpXUt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-382f4710a17so5433854eec.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795434859; x=1796039659; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o4oNKX9YSaQ7zR9YQ0CZmPGolVckVsLjzNRd1vRsTh0=;
        b=NyeYpXUtls1xJDhHh+89BGPd0Pl4FAZwmTM1AqNILl/eGbCI61ynr9PlacUK5L0DDQ
         QWe08sxvKMSsqaeDlNvcOBKq0I7wxmQn3/odgDaig6o2mEao8C7NIxsid/pbrf/RUFbp
         H3TQNSnaGNZe6GdxHcddnv4UsWCpu0bBIvEK50tdeQ5rWGHzVSkfN5Y1wiu91GKibLLI
         +eaQvxTYoHB28kCQeyOkFEQxJTxhKEK97Cp9TPCu9H88tba96Cxec6F+NKFK2FteWmXd
         8YbL6SnDon9Klp9wQPpSujGehEQ9Uceoe5+ZMXOCLPx5r2/Vw1898I7TOJOUBGExoUzm
         JGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795434859; x=1796039659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o4oNKX9YSaQ7zR9YQ0CZmPGolVckVsLjzNRd1vRsTh0=;
        b=j3etexIJXJseRcZd5ak4M/pArSif5xIE4CYlSEh85d13ahyExMmfYQJsUnpAKe/ykq
         jq7gpHqhYWo2ZPqKd8z9/4uInBT5BfH3NLT+zfoeoYUfG68AcZ1hs4PrF5fa5u0AAW6a
         Lf1AuY1pvuf8l1N33t8aQoEtPa5btbYKVHt96yb2NvfTE9FHPyXWLkM8oghH/aF5Vvp0
         fLDSyXEgrCwtq7yzoNhHOAwIUMye+DmEfOl+u7bF6IlNRiOtMmIKAcUUwGU8rvoTKC9l
         ECMy1zdk57prkUsbt2qhLGakTmwkVqACjGuqTkzpv62sIhfZInekzOX1Gn7Z+NynTHeL
         KAvg==
X-Forwarded-Encrypted: i=1; AL+hErHhXzVHtchW85avLptSyywp6mxM/0vZaJyCwXAws27n+O/maeeFNoWxmHGnfITMEr1635yPRYqBlQ==@kvack.org
X-Gm-Message-State: APuU4Z9a8h6FH6liyO7JHPh5pPwhUQdmDHxiquS4e+zDQMbim4G8CQeM
	PffuH8GA9jdl5mTKO1NSu2vzpphl+CxkA9KRH/3jIk8ubdIeVGMhmiK+
X-Gm-Gg: AZFdTZcswD+hHLHJfpbiTvwumg5veGbUtCi3RDaw0disWxoZXv7Ps2cKF3VPZZ4G6jS
	nA+f1nug6CWhZg98IOq3kHnpjU8bGm4I8oBedLMcNa+40zwvAkQ3osn3wUQDce7mkC5SRdd/6jo
	C3x4ULhEfVBBl7PheUK3nuJKOXpsh/h7nD+ei4tFgfaNIeZXVRwIAdtp5UZRL6J2vgmCtpt2Fe5
	xX3ok/Ay43pxvU1Qh1Iq1yIRFg+I6xBidfhgLxSljPMVnWMd1m3ft8jy88zLOT8CyPODJ1wkqvp
	oR9DMJCU4eLVvMSz4Qr7EPTQhhBBciiFYqylLnO+FtpM7jQokd6at1HwSVMwTgVSvuOs9AnMC3H
	dTPQKDwcpTn8TPcCTpLNuu/L3xmJ40xxglAHjKJ3WjIuS4Jr2tUHh7hPwa+o0QtnB2LR9SSAhYy
	Me31V+fRBJCQ3FS8LDpaXHPd0hF9lJjdoFBXJv1rmA0/8N8kSMOGwHQfvreVeWwqKTeaQvJLIzu
	OCvy+prSGYs8CH1cUMoQNo1f2gTUDutvjOiu9vtMjW6v3EgV3fsoMx2sUcQGPPepSqkmrCNQCuz
	bXI64id43DVzT4IHK7W0KAw+c0MKq7jHu7lmu+O7l+OxEffpiMaIXuXjLC3I6d94mzg0
X-Received: by 2002:a05:693c:8803:20b0:386:9b9c:ef1b with SMTP id 5a478bee46e88-3869b9cf99amr7284369eec.3.1795434859156;
        Mon, 23 Nov 2026 03:54:19 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-385677c371esm35476837eec.23.2026.11.23.03.54.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 03:54:18 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 08/27] mm/damon/sysfs: implement report producer type and state files
Date: Mon, 23 Nov 2026 19:54:04 +0800
Message-ID: <20261123115411.8607-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-9-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-9-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8fd9fndag5cogcmwz6ebmiiuxnk5stm1
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5E9921C0006
X-HE-Tag: 1795434860-779401
X-HE-Meta: U2FsdGVkX19+RJDgd3OpPFBKhbxBf7kWzcowPPaGTeHbWVuVjE5Kw5w08FHbwhphOTcb8KnnojwXJGFfqyYrPIc8nCEPykWfPEZ189m6NyIKAcfoSQ2qXXZ+/UFDQ/IBs0ivs5wXVXmS9uLUyn2RSI9nsdrvhCCnhsVy52yU6ZK4wdawgcwkRk80JrMnb7UphmBuLgWvigSNed6dX8denNz6ViYpgsO0v/2Z8kYR5A3G74IWygKAONuDayRFizoayFFb95Zs3BwwiVSbI5NuDgCcmS+w+22F82jB8q6agvuUvTyK4XrSSll6MxnR5HD9qpt/nLB10YcXDX+ZEmLqbjRNfHQOh2o8ym3W7+kNufgOmkQRkoH62II7xOFQlvirbNalNjTxCky52ApX1b6Yy7paei1LY/djaCsR9QJVx2AgcRZXfRldwAWKsjK6Eympco/z4m+ZpSrEbmyaO/p8SZhxj5bQ27lqgpdPZuQaaseA5srGKTXFp9OXESXsvMaHdCEj83rqQkPXHDy5lCjgTlR0aFZQUSh9seBCiaQR2EhI50xvwRD7vMBPOPS4YiY1XFMqMV55WZXspPLfedam6nKb2vUW2Cx3X3Q8yyKJfEV+MkLugU5orWf6abVBkEKl/Psic4pXhOV53fvkWJ4qZFvLKC3A4//f7eFFeK/3s0/eBXDScXMc0fQIE2y9CjI8vdSWPQw+gQc3uTIKKRdGhtNbb7gEN8VfWHrNu/nYoaHmfQJd9sV9+jvX+1qTb6VYAqGGGsJCOVCKevuuhsWuTkbFuF45fBgNYUdclwIo8WA5tXGCEmbbD62Ri8ARKzSDjOHmv9TRlROXaGmVXbA22BNn94ivQBEmF7JHXdgfUSdv0F/gLVI2UymQGnl2dU0/GLCp/4q06V7xJ43WzPrynrqkjUo/IQOF8VgKK0uvlIs1I5jlknm1zefkSGLlqnGkDF486XiArHXY0FeQKHu
 tvIB70sF
 Zei+5zHylq1KAtFTq4oTGqEMbmEVh8d0OP0wlVa4uWjpIphYy8rDj9NauXcr7Yb9s3WpD7KtzW6bLGcZYYOHL8Ny2PbHA9FNaICg6K8Pu/fM2rnr4C+tyDPQykvz9XNzGqVJwJ7l/toGplNJlB0YkP8Bnnag9TTMeuyR7Qa6D/b5rlc8tKLTNo4wIZdPG4b73CfdhvGrB2K+ROCB1Do4rCIGVumCS0ETUag7jtM7qx57jD5WwilebPv2+wAbTwlJoDTR1ReGmtCX8GQBm8iIqhndpkq7gIP2fKtkSL5wWP7zS/g22FdlTZQp2c0Z9vix4pgF/vWGZcURXizd9VBDLKM94ts7UwCOUmuHFKItkBqRzg4BNwHsqgfoiFthqDkQtDNqL9OJSYuZh66rHynZI6vJmdtItRVJHV66ewvgDTjfnWNThwk8eWG9zCQo/y1EXpcuLmXCC29d4Kj0e17NYN3kijt/iZtSeatQdyR1w2EfPdqPuFRdNoIzdTNTWoXOfQoacCHA5g2UKsOkjH856ygmheJdp/evxjU3YlOIAmRKnu2KTaSzwgUqXRSFW6wKeXimTtx6+DOtPRFcvnrrp1F50sy4eAQhYnmoXQEGooluEpVXjr8LO0QB4A6tyY2FmxzkJFjBB/JrhrxRx5f59+GGZgm+l5TSpVZ7AzdyA0oIXvXOEUsLvXramow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 12:59:52 -0800 SJ Park <sj@kernel.org> wrote:

> Implement report_type and producer_state files under the report producer
> directory.  The type file receives the type of the reports that the
> producer will generate and submit to DAMON.  The producer_state file
> enables and disables the producer.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

