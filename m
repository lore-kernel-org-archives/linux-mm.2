Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9EECD343F
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 00:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C796B0005; Tue, 12 May 2026 20:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E45A6B008A; Tue, 12 May 2026 20:27:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921E06B008C; Tue, 12 May 2026 20:27:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8130C6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:27:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D5F88D61F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:27:46 +0000 (UTC)
X-FDA: 84760508532.11.7143211
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1ACAEA000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:27:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vB8Bu9f2;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778632064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DdZihvm9MJ9Gc+ksx2sBgRFmplptb/2j1HatZmvLQLk=;
	b=2qq1BWerGMg2xdGxUIxznkiFmUMfxmC7Cy/KWbwNOX4icHyeO2aqKp3W2oPFSWYJ6v2EN7
	h5VnYG8QV7l9j+wyohlkdGlUXqkO2zKeUTUM3f3mjZsZoR1dVpQ3ACWubRYUvN7XoWRdFZ
	10aCYh8smO+U7YlQxOKXjLxT6UgyilM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vB8Bu9f2;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778632064; a=rsa-sha256;
	cv=none;
	b=yjGbe+GbFA4rv5q9jAdpUQblkzwHy3Qey0GR1siLlvIXeBMebguEDO/ooarlFpEWrU+x/m
	goefxUXz7eqPTTgcFj52mhDR6jI+Sp2wXcjKlv3YBsYiLEYU1KQI9qJn15j5NwbO+KdFWH
	luEpEbA96+F8cWMrjTVkFSqcizT9RaM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EEDF1440FE
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5C0C2BCF5
	for <linux-mm@kvack.org>; Wed, 13 May 2026 00:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778632062;
	bh=DdZihvm9MJ9Gc+ksx2sBgRFmplptb/2j1HatZmvLQLk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vB8Bu9f2kuY+UgwcTw1sudO8AHhyO/KAWmjgqm8Yi6kvXFGNUOA3DhuyKk8Bd6WYL
	 J3ym3W+xMI0J13+M3TZ7ruJP44Lhi7cxlpx4GmPUNoUDrS69XQ5LHJ6HU75qpOis1g
	 IWgRtOcz72F1K58zQFAKOLRKQKEd6O8Ax/JhOJRAcRzLwPbfhGN2iXAgfd2+MO+SWy
	 mf6qjI+sIR7p8tKmUFtcbhjtTHNOHihjsAFc4tMgPSWmqN/cB4PEyUMnIIfODWweAg
	 2W0oLhMFOp4iNO2cO1APoQBpDbXJunsHCguE5ibUhJlyfHEmFDO9y2jVFyQmyKKnbK
	 +x7gMG7BAh8SQ==
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-65d071aac6eso5656744d50.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 17:27:42 -0700 (PDT)
X-Gm-Message-State: AOJu0YzchR3eZYic4dkGwA3D+8SR6dqqO7S/Zg3WPf+jyzD7G73+3BTw
	J8QbQ3b9olaTgcU2O7+CAQPxC1dI14DjZTY3jlByOd6dPkuOo24Y6fDAv0lPXbmKftWq8cRVO4r
	f/3ZIdPpRmuCPtkdtesjQ+pH2bNPEnIzZFGyoqY/DUg==
X-Received: by 2002:a05:690e:c4b:b0:654:53f3:8cc0 with SMTP id
 956f58d0204a3-65df82fcf35mr515850d50.56.1778632062185; Tue, 12 May 2026
 17:27:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260512104201.716213-1-baoquan.he@linux.dev> <20260512104201.716213-2-baoquan.he@linux.dev>
In-Reply-To: <20260512104201.716213-2-baoquan.he@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 12 May 2026 17:27:31 -0700
X-Gmail-Original-Message-ID: <CACePvbWoz_swtPr9=ipEt3a7xVmrV9+G4BXhQ_7fZ=M+XZ7UCQ@mail.gmail.com>
X-Gm-Features: AVHnY4IfGNcHt6lC73OqzQ_RMFrCAathCMTlA-lWhmf-Q4LKINvAWBbf5KYzLDA
Message-ID: <CACePvbWoz_swtPr9=ipEt3a7xVmrV9+G4BXhQ_7fZ=M+XZ7UCQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] mm/swap: rename mm/page_io.c to mm/swap_io.c
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, usama.arif@linux.dev, 
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 93os9o47pgfnijazydfrb5gkesehox81
X-Rspamd-Queue-Id: 1ACAEA000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778632063-333208
X-HE-Meta: U2FsdGVkX1+Swxp9kjPKLjGv41VPiilneIWt93ncCaBNcZNMXWmW7C/MR+67gH0+DCL1+X3/QZaa75ci/387Eh7QuHBgnFkT5ZOQafPJAk9Q1RE6avt5OfIO6iI/Lkt6XCzwK4BdIMpvwLu2tcLGpZIO2JJkHU6KVndlSVS0rkPF0JT7YhNzaboqE4XNZaZcg19jUuaLtV+Ehw434DDUAdJZJ9O+f3Gm9IYxOdtyIOjNA7+fj1B8hPFdskSubI4GjTngq4RZtvIJpi/uaUq/nMqo1EnkQgFEJ37VNAmCQN2LcPWLChlqyOh0OoxazkCflShzG7xb3Ru0XikVH+KrCh8Z0e4x4aajDNn5m3Wp0MeK5CfQYfY7ceeRkV8ik6Bcki9SdhAfVNlgMYbccUfSUoiZz/SoYeL+M6ZamFWq9iztmP5FCUlrGbiCPD4UHf9Tvx0DT7pOFfWHEsZRcMv9i9zX6dxcR8CMBtKDF1F8KNS9Lm/LulX4MAihRK6d0VgpDePFSplKB9FYkJgU84+ym4EuR0roScek9NeCRU2qEA14hCF1MVc2qgBx3GmHTKTvSzylQdQZz/ulTseFfI02z4se2K2aiqT9oR3/kLGjLCu7UPVUxSKYZgK1+OVnoD/uw9OjsgdZVTrva2O0y1KZs8oNvAI9qJYU80llBbnPI0X7S3FJPyzfSzAzv7EJdFwX7eDUAyHipn64dm1GlAw2KA3g7pIAB4NN8LrkLMOwRA9djf1NDdf9JsVJ8ggD/h2s2qJRgpZ3csWPq3kntu6GKbKptBw3NnfcFq86C5JoxbxFhKAgHR7dR9wa7rzZFaIgSrlOOMRdlT8RkJiyIzcstwWpI5m/y139DZAdjJmboEC+GwGe/LqaXPesjKqgUb0IohaS0Az4BjjAhXR12RO81JIp4j/f3RHbbal7iDmUex4JwMhIWf7xHr4Z3GlAlrrlaxvz13UjKBUDc6gzDU9
 Dpk5WvSe
 wDcz/qgWwDO9YS4qKJTfotB38IN+iY5YCUudxr5l+NEuD5othEqhzNJEkS9tuIs5/JAHLDOTZIRQoHBggqXg1Ln9Gj32/CNiPoyCGqX+jNMqdDLg4maQZvcQ90DOKkllR0bot7q2JTJb3o024XHn6RCE7AfhvzME59aYDg8L4bzzey/XEmxnphDRx0G1ZHjp80N4ZMhMrXQtVx4ObVmBKFXtS9QQhFlzerGFvWFuS7u7/UyvoFmnJmM0+5BwmF9VtZ5xw29/27F93POOScGcqnw08HlM4WV5g8FjJLHXQO0AWpSD9QjYAg1DwqrSy5+PJ8fecGu/u814xM/GcKaKnrazWrJhXBJQwuOh8TDzU4MsN6TdLn3QvrbR8iKOPzbFQBFFZHZb38gRBjzTI/f/BSC6HPjOW1Lp115WZ4qJSuL3hXeA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 3:42=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> Codes in mm/page_io.c are only related to swap io, it has
> nothing to do with other page io.
>
> Rename it to avoid confusion.
>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

