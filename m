Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACAF606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 05:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J8yft5+e
Received: by kanga.kvack.org (Postfix)
	id B39EC6B00EF; Fri, 30 Oct 2026 01:15:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9CFD6B05B1; Fri, 30 Oct 2026 01:15:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9652C6B05B2; Fri, 30 Oct 2026 01:15:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA2A6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 01:15:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3A18EC05AB
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:15:33 +0000 (UTC)
X-FDA: 85378129746.30.F3BB260
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4CB04100008
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:15:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=J8yft5+e;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793337331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QLAGb+5fV+Rq1OYzQXAZqcvS3JWFeskumWJFRjZQ3oI=;
	b=eKW+qEWZ6Vbsf07ZpBhalqKKdIq92NKFMLtT8XILYtIKL+nQD49TlY/DMbMwuk/kZ7bpII
	YOh2OExeC9xj4lM/71MGchqjRZSkqIm6xAArCGKY9bHAI4SoEj93vpAIokcpekIoqNuiDK
	t1amfRPPrNQi9blC8sfRAOYvDiDDMqo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=J8yft5+e;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793337331;
	b=iGRgp81tVpzbCsrMBIvGm+iVL26HDz0QOv1DOF6CcSWxOATd0GJLT341pJVD2+HmCR6o92
	y9lYXVWrep8QVH0tz/3rbcfNLzLS+cJ1NJBS+i/WhpNaYAhNHO16oooyGz5zMMBDTZZToU
	7ifyYBNJtDfuTN8gHKFsUX0vf7F0zho=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5be4c78e8caso393730e87.1
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:15:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793337329; cv=none;
        d=google.com; s=arc-20260327;
        b=dRONEe8eIT9VffC9FhzdaZFSzCbAS1o0KcD1eibVids5q+eIo1wgeu9hbIB0CTuC9F
         CQvjV6C08n3xafSzyKDk4bD7g8j/GjrdTipwX2M5rJNhnhHVlULqd+dNHzfhHjJQeeEb
         1b+fUqOAzIM6lH9N0cyE4wawTnsRSPr/8q8JSV7FI10J9dDE6Hpk4xfrg32u04eXzHrE
         YBvh56N+557rKwlrmXYbv1aw0s1I7VrBupE7MP/wqcmgXxis3xILz7Sj7l4P1ojoRnyW
         +4iaz3iKRdGKYteYALajuPXzwZ8h3XUXgCcFzwEkQP88CC2r/dyXxtxl2I88ipOzCodh
         FSJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QLAGb+5fV+Rq1OYzQXAZqcvS3JWFeskumWJFRjZQ3oI=;
        fh=T+Pux3MViU8vmcyArABbQTXrV41rNy8BRK8qRI5ETWE=;
        b=U5ExHHtizyCIdCePM4EecGOnJRRND2USi0GHS742FxNk1YMn1C0EJJrLyHNMcRFFVI
         8doPiPynOIUlvh/1uqKGwTJDzVVXiequXAVoeeshf/t2LCHNJHfLL1pyDIPbAYn3Ntd/
         GxcSsMcOg/tt6da/sOuCD4voPvyQLlS763Ionz+krd/UYJHht0GVQoaF12Y3Zf6fhI8H
         b1Ybh0vBA0stWrvAZI3AlYrMZVXg961QE4tacxUP+KXcKWcMZSf9+lXIXOVntEFk//tU
         pC7PvSb3dynwBuXQssnwVp4ROahHSSvlD0XEeNrLeK2CGzBs5BDBM64F50k/cCoeSV7e
         Swog==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793337329; x=1793942129; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QLAGb+5fV+Rq1OYzQXAZqcvS3JWFeskumWJFRjZQ3oI=;
        b=J8yft5+eZ+XaMjwIgf0ejQSwapYxl9MLf6+ZJ37X+OYNJaMpPZB1Ysx1VBSV/HMmlC
         YfzRCZHfhakuyU9xT7yOHtM1m1eu2RwlVsZQEE5tokGDUcgy10M9L+/78+BUCkL1MiQC
         uAuVAYNrABjXazC20aIl/o2J4+Nf26Y6YUb+x9YwohLgW6ixBp0nh1oesGr2p9r2xIpw
         AUryWVtTuWEc98/I43xZ3FbY0bunNoKJKJeZAttzBAxVUsUbvBmftcnMmKBC0TQGVQyB
         oVkYakLcwq9IFp4jydl/pd7WP7YVaFw3PkNRxFcf8Q21B5dEm+HEunaXQ/ZFqIUODSpK
         8sWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793337329; x=1793942129;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QLAGb+5fV+Rq1OYzQXAZqcvS3JWFeskumWJFRjZQ3oI=;
        b=rNR+nk5PjYCBBMzDWfgpwaTJL/NLsnh5AVoBPCMTfdjo8zg/sYqvCgskwKAPa1D1UO
         RdcMmkhNJiGLQ8jtRV2YlxoJ+nSZ5T/9uZs5TXDqavhfelp6sDpAURWPek12Q9Jp9zz4
         Q7h19PEwHxJWX7cNilLRLusms1+S171uqdG/kKkUxqkQZEIthqOkvJA8IivO9io2xsnd
         o/o7Cvz44F8sCi88AuV4ME80v+yIOfat7+StoDHGcubRV9Mce0dru0u1YNCH2183sWvU
         mYcMfqDHAY1FfMxZqhMG0IyaKQVhKdYxlLmrK18OWcdgiVz40dbkAu+lHkV+E0o2IAFU
         S8oQ==
X-Forwarded-Encrypted: i=1; AKwUvBxuHLavhzwiX0syY/zrxHlfeaQPCeV2xQPCOO3DNIP843WJfpRFzy3VzbeQOojtXIbkAdW6XGlc5g==@kvack.org
X-Gm-Message-State: AFq9FYJnmENAEW0btkrEkAN0Yc9ekiWTo/82cCd9tNPjUiIsTXoJXxE/
	Gd9ibbSV77KPuPcJEt84/buZWkZ/jdYYc7QWuHqi5mhSw4Aej0+WIzSHA5CX77CghG8Ch348hv5
	aARACpyuAlEaz1Vba0bZelS+e5BVOKnI=
X-Gm-Gg: AYBFou0gTuILkKA92aKZzMXlSm4qwkYewiZQhArMLTY0jeggeVFxvrb3rXmrco0k/q0
	rjt2U9RmC4KXNKICENLKR8GczFfJTlVpYxZcakkyruwN4tdQJdcCPwvmEovey8QqL55K6da67jh
	/LRM++sR+N6NmlkONzrDTtQ06XoDwI3sbpwhRD/uHhfstXnFfN+6/vlbtOWRcbuLk4n0Nwrageu
	2ezmbj4+Mk3hNDmuUn/YT9zRlzkl3V0vxEDGvp3mv1T36WfW0oKPKz5ygtVKxqvi2eM22iQFfiv
	uW0RqevHACIbEqAFc0jmmsxiOHObv8Zv0Sf6mf3m9GRgfrukIBNIlnwfC/y6JR/IgTOTbL9kEID
	3uvLitycm2bsxzwf7ThBofkh9NT0lRRQ2Pb2W
X-Received: by 2002:a05:6512:6c4:b0:5bf:6c4c:62ce with SMTP id
 2adb3069b0e04-5bfd957e727mr296888e87.55.1793337329304; Thu, 29 Oct 2026
 22:15:29 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188658@kernel.org>
 <auQhULh1VTh6lWoe@gondor.apana.org.au>
In-Reply-To: <auQhULh1VTh6lWoe@gondor.apana.org.au>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 29 Oct 2026 22:15:15 -0700
X-Gm-Features: AclHuK_aVAvKy7VDR9aeCsm3QjdEtQQMz0IwVOpBUfBcF46N-aien0GXVvgDMaA
Message-ID: <CACpmpodWMtmE0yNVN656K-8fPZgTj_DSZ0J7qxou+5Asoht+4A@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, yosry@kernel.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, 
	linux-mm@kvack.org, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4CB04100008
X-Stat-Signature: cjz1d3sypf5p6useggs1oab6yez5i96d
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793337331-276897
X-HE-Meta: U2FsdGVkX19VilDLDtN8OOUk0Wk4jNj+0givqncS1QK5OsP7z00zJWUPNOezBA2QtqoLHZwcwrAk94ytwL4RjzvWNrVr1/xUNi3x+16BnCziISC20fKeiq0y1+RJFsWEDldBnG5mFCKuc0lULBhTt+5SwytVhDx6stdnZZLuwO7A0hw/H8CLYSIazLfH2d/bkbWvqVrVYjEowDhDtcCc70GfcslIQFKVYmdzS3BOuA/aTDCrjaJv7ceUKpTeuS2rbcZhJUMsUVT/N9yHpG3nAT/rnAvY2l0ipYxkOWh0L/fwr7k32o+Vgdas8CTogU25GhKURx5/eYBSztN7p+FdehVIUJ3ZP94JkxBwHeKkxVRyiUyVty4hS/vtWg3cW3C0ryWyB16mjdlQlaqHoI9fW5cjNSsTGEqYFCZg2iVWOf6vgVJxwrxVtfHPUHM4MzMvr0TiwoSmZrc3IOLajfzVDnNpyecRxHa0le7JrD/3/EKom/f7FeXrB5gCpe7wbVijR7x7I1YpWUieLTIppf6WKe6pnqMsx7JRbzEGu4F+ly3tFqWQQJKY2OqgWxuAgCoEHCIifpOSioSTOmGGCsdvTjaB5mV62e5bPUXwwiHd23GB4xl622DtmbOyrSrzwkwjWU3jyi3upSX24ahUX0v/KdpKrxF2uKEOM09qYom2V1avupcGbiuqcnrcbCwN3waK8a28Gw2h69+xI4LH2/lbhoXrWO4R7BZvVSbnej2QUxr+hmYX7w46CQXvzZBbMK7zgJv9zB9tMyb8j/h7PelB/D0Rl7u69FweZGgN6e33xMOHFJ86T6NBOBrK0KHzOg5gkF85LDE0Es40EF6cFNPa8wSRuiv2fcSe0lSHa/IQ45BxooFnFdGuI6VxWvUgX4DQkvi7J6l7sVlzfCMZzVQ/suuCWgZdM7DuySHtmqaPp2ndJPssWpeTIJwyv9XNgMqXx0rZAwI8OIQtY+yL320
 n4SuGlTy
 bV1R6V4egp3uvCd1n18g3CiCrXgAg20MqSXNGtT5lUGFunRqzpwiNGM/m3jLVHiVEChp9yQFTKLaIAa08KJrZC4lhDktQ3l7xBRx+QPh3+QeAWmToNZyDpaWCi30UzL0WGXQMhoJua8285NvX001IU54pZx3j/rIewdjWL3qGROCkpitpIBJF96SN7gSmSawfbIKwLA1Z3vjMabrkTTjovsTupOX/pN9CPhrlFavnOFHfjQxW3IjFCaJeJ+Hbqot5k7ClUmotCNcA6fUBkqvGXOjmpIucTocTkggvw42iumvtyXuN5PdO1TUSu94cCw+6rAGLQP8jsMs78+DBq/jD+ZqNtTBGs7o0cO7UpQiNjzG+UqJlEH8MqE/EozpFvKmxKYZOh7ImT8ly68d+rgU6S5WKCwqq82qu+9YH1jsmtHLi9QE0/JHnA+6jJVcq/dZTkvMT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 9:47=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Thu, Oct 29, 2026 at 03:06:03AM +0000, sashiko-bot@kernel.org wrote:
> >
> > Additionally, because each CPU independently calls crypto_alloc_acomp_n=
ode()
>
> Why do we allocate a tfm for each CPU? The tfm object is meant to be
> reusable and you only need one for a given algorithm.

This is how it is in the current mainline, and has been for as long as
I can remember.. I assumed it was because we need a per-CPU acomp_req
to be allocated for the tfm. Can this be done with a single
crypto_acomp for a given algorithm?

Thanks,
Kanchana

>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

