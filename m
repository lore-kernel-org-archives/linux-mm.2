Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA0A606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iXs/eYLq
Received: by kanga.kvack.org (Postfix)
	id AC1C86B0688; Tue, 24 Nov 2026 06:42:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A72DF6B0689; Tue, 24 Nov 2026 06:42:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9612F6B068A; Tue, 24 Nov 2026 06:42:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC5D6B0688
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:42:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63778120AD0
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:42:53 +0000 (UTC)
X-FDA: 85469825826.16.F22289C
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F14F140007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:42:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="iXs/eYLq";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of xavier.qyxia@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=xavier.qyxia@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795520571;
	b=wqFsMXAjy01rcVrS8tF9/iVAIz1PInbrbgomnvzya9WQsbVOrp9tq6jhKBmgL+ZTIsogg/
	mZZWkU8h7wRQ08/jETk6ZYRN7vJT6zY/U7+7/xQuX4VdbkbiXo9VR88MdgifgevaQLK5mi
	TvLr00QZB6e2Nb+tbYYF4N3fcSwE2Wc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795520571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/z5ch5pLpPdbk1BmHD/hwwHu03qByQafwYZQeBV/lWk=;
	b=GHAPoJN4HLwqCRwMWwIndgQlk/bNM1xzYYp1XXh1GJ5nMPXPnWacb2YhwpkOozvEZjbODH
	2X0URJPCBwgsfh8esx16crjqSKJeIUmhFYmZFkXPUTyNwPrfm5I/9qbCzBUQlAnPEqK38j
	QJy3b0z6lQZUthAoVNJF03SJvhlUuM4=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="iXs/eYLq";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of xavier.qyxia@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=xavier.qyxia@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c518cb79197so183298066b.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:42:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795520570; cv=none;
        d=google.com; s=arc-20260327;
        b=cTQs+MUNblwYPh7VsLyAPt72BLijzSNEoIt+P0R0OLz9UQWT2D4a3IbDKwk0wK1Q7x
         fXNNMrmq+4kd2GOYSFEbDnmBBIP9ECBLEwq320iDDPbVqDqErpV4GnARW2ttwHoaQjFa
         6zyrWGklHJtIO64qg+RYbh/gEEVJTAUBgNAdblVqOq4QaC0bm9wCxZAKYzLmkJQpDddX
         DOy1Qe/az8S8Ydl3JzPy9jqWIgXHExBiOOSbcWYSp2Op6o1n5qKwoChAiMdU9fv+xBpK
         hTqjO2L/B90xUqP8ZHMaW658i/FAWzFZUMKOu1YpPZIDkWrynTk7LxCd8zgK5rnfLt+9
         NlLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/z5ch5pLpPdbk1BmHD/hwwHu03qByQafwYZQeBV/lWk=;
        fh=kGBimTsoJCNEiC0WNEiixgJTn+HuBkr3AChlVOLNmuQ=;
        b=cyAzQYGLBWuGU8xHZNGe1zzpFW2m8FzC/HoXRXYLL4VH4habvuPn+vcXil13wQo/LG
         xpZkVXpqniLmZ0pvTKRUXtEaEcTgDtsGIPE2EDx9vQqApv0G0Mf5FUDM1uUdZJbMjLKl
         mXuw8kp0FaLr6//IpO2+NONRf+Iy8OKkTyCWD5a+CFLVMd5z0Oxc5Hm1g1mLsZlyD1H9
         DxlsUPvuEeSXysIhORjdag87krkPwO7wO1Y3Jph6eHG7rOm7l4Ag5Ow4io2eG9MxCppe
         815cqn6RwgTs1iRg2efultrRZ69uEfXxHLZcykAap2F0AOZHC5+n1yh7OWcsBfhIC6Sp
         RQjQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795520570; x=1796125370; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/z5ch5pLpPdbk1BmHD/hwwHu03qByQafwYZQeBV/lWk=;
        b=iXs/eYLqAbjXWSeCEP96RszP2LcprV/aS0PsXDd+Bq3fhx9LEL/SHfEO+1elmJ9ker
         0Oikj4GdbCCMrB8sGGVfk5ggIZgnnnIgF+KjAYwbeC4jh0hajSvsIiY/hBDk9FCWDvlV
         HrF77T9qdtvUlZ8rge/5uIES4yUuECnvhmagKIt0nfeHLstrDK/e+k6A4nTCZDe43E5Y
         X4954V+1iyCZNIgyY0LEmhOEm7m6cmnlH3PRTdsdgLVZYmspMrylCszuH8+SvTL7ZVeL
         mpzKRtvXRAVEOeMnBOBmLjENxQ8fIfvLQSqg+WbACAVah/sbVYZMmX5QnCd7iI0aDbhr
         +VsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795520570; x=1796125370;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/z5ch5pLpPdbk1BmHD/hwwHu03qByQafwYZQeBV/lWk=;
        b=ZARqlOIReBYbh1/xRFBaYy8Ux37Q4HH+eErnfOZHVaXUdQ0vMSk98VW31wAlIjAJ1g
         mGI+mWdzeUuT6i1wdSK946rc86CAlx0vbybZXaPquJveuMA1ym9KnQXvsW+hHm2m7I8r
         KHJiEopVRlUZro9oM4bWQV72cy9AqttJyncW471HBGW5WjzK8Uh76CECooY4xyTwW7ua
         hjeAG2C0Nx2eHFPOQ5bfWWM/LZS3mVA9tK2st/HA4mhS6EzTV9QJgbn4ciToFGTeLxHB
         bpoYf1Vgg/kLcnyJ464hj9xIVPXicQQIaNz14/i6q4/pFmRuvP1zL1oygwfBUGSThi2n
         j50g==
X-Forwarded-Encrypted: i=1; AL+hErHibQG5mZZ65cYrk/IJ/9/aUmepON8T5+86egCaVqujlCD7eonG4QZUq9lO9Ueu3s6mi9LrOsy3VQ==@kvack.org
X-Gm-Message-State: APuU4Z8+NwrBdZK/7dLDOFMcCXOx36NL4MglnVRZ0+WHuIo+UWteDt5K
	vmEtPBTIcrnxgS8VXdywucoHz1GYuRj8/PnLTMkl33fiE5JOe/8BIC8ZujmxmRuL6lBEG34slDx
	rWxRG30CBd0e5l0QQx5fyswD7wGYsoBE=
X-Gm-Gg: AZFdTZfwvNl1eM1vriXd88M7nFgtP9+8mjSZpe4mqBz877xGvOZPs3W2wzQxyVgkB96
	KNVjMAhwHa40ab028ivxf9/JZOBKMrcPoxLpLumFejwcl+oJ4EumTowWn9QaS0QHITCRjhMNAJT
	y3vUpVnE3V74DgyKkfGm2Q37YeAMqfsjMWoeXpXoUAxlvHRcR1Nyiiq4x6cd8K+jYqYqBrviawx
	5qyvC/UXzkRsI0NS5zFZgoo2l4plZg25MXr3xcOkygvSvA2wLxx7fAT5H5IBhypmWw1Oh+Z2vdB
	EuOW/nze0pHzxNFqZGdtXtrB4Y6mwC779UX+MQZ3Wg/lb+I6WEQeqUA97msbrNwPj2AQfCmQYXm
	yihmhz08WSY7IhMlWHY4b+99oMWKfY0yOt7Bv
X-Received: by 2002:a17:906:1255:b0:c2e:378c:8ceb with SMTP id
 a640c23a62f3a-c513ab2f292mr893283466b.36.1795520569665; Tue, 24 Nov 2026
 03:42:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120095559.429515-1-xavier.qyxia@gmail.com> <awBN9VvV6yM6Cjut@casper.infradead.org>
In-Reply-To: <awBN9VvV6yM6Cjut@casper.infradead.org>
From: Xavier Xia <xavier.qyxia@gmail.com>
Date: Tue, 24 Nov 2026 19:42:38 +0800
X-Gm-Features: Aa3M54qQ26PffOi-ROWCmcVbedXfEWG_6O8l67P-4AZYWdcQV7atuYSopUWOUaU
Message-ID: <CAEmg6AVjtaiq9Q8rC_V5TcgAxQ386CsDtiXO7A6UzC+FzNdGTw@mail.gmail.com>
Subject: Re: [PATCH] mm: batch per-task lruvec stat updates on the writeback path
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, shakeel.butt@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	jack@suse.cz, david@kernel.org, brauner@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6F14F140007
X-Stat-Signature: q6j3oh93eu4h5mfgk9674bdry4trbpp9
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795520571-842211
X-HE-Meta: U2FsdGVkX19pWaMoGy5SXZjJsAs4PoBqkt9AKD0AlXuyBeLPWT1bB+OpIXZ2BwTBgrsrBDfPYG7C67aGwHh8uDGst7GDn0asQpzj6mHcr04nVmBBJS1SHan5xA91bWb1fbEyeK5NUq+EsF5hdGJmOdkeR4+PIxLRk36xOJFBP2ASVwN8E0OVsH+lZsgan5xY7LN7wPwmG6rmd1P1xp4VoYkCSxiMAAzWUS7JXmdOKWyyQ7eq/K+FEQXEyDy2Y25YkodVEUIbQnJPZ/mHRQUwGMuktGuSo9+GEp71zl8OXbVVyReNvqdvAmTm64kuy3XdxDP+vUFy/RcTveWc05ohyx0Ym+Puqu7/pRWsilo6fFtr6lk2MXFd7aFRWONoP4U41wIoYXX32Dv8Ym0f+9riozboBCVp7bOz/vOF83OyMVXvJAxg9v7pTmT5i4rL826+yKOaVlULkMpgxsjudauOX3cQ71GR2oGrK57qwwaxtcMDrziDVgTk63ApbGp7MLZhkEWEbFrjbBzVjwWW5UC09rIq6tR4mDwYRQjgkKxqGOOTJ6SVfBi/v1W3OT2OqjJA9zUrBYSOhdl0PDbCSkPr3g8M+XeLgdXIYVQY5m9Juif0ayOTWtNfGlBbK8KxbhUOxGcJCVNIGx22Qc2L6EZvZ4r8ejW3YEDua4E+7HyobN+I9wcRl73Nqy2p0bmJYW9eQrQNNfBN7jEKW8Oeo0pOcX9TobB88bWPg7X7dFXcTZE5VOmxALQd2IBq4i4lwc+0c+9NAAt0FY2/tYVk2zxHZcQYDVNiwXBc3EBBPr9USLaHXiiaLVNpo+iVD3dM7JpkXPO27oA+wwO2sXWru4Y/73fNBjf615BK9XNSdZ5G2pPJolC7m7V1mySogqChZRgn1CrrKkQwmWGvG9io9j8A0OmiVAzveiXh6Jr3wzCBzVVxRZpr547ZMAGkqxPd6/TsWM+gafHt+7Qr2r29jY4
 16NdVguK
 4gAYKwDyjW1V11wdWTwoBb6oFqD0FmHqK9ucKkZ6T1Je72IawbjQo8Al/Yil9KTVWYFbesVJWB3NzBw3QK0udHMFtcFbqNNsLH4wkJ8qXTvh3KpfwqQAyxWHzNQx4Y19FGVh5G2QYQdX3qT98/Dba01YW684DfKLH9Cu1hed7tOBo+nf7cxVExjda4Ml1vCBE4lPo6RTMqBAQxjwmbYpevTANO15KhQg20bJYs8Xof+IFl5xP1Wx4RQjNfCi1OREMi3uspicMER+PNJ2yy8Lk80sEK3e5QUUbwQXzJpz5tH0sB3uAEsrxYtRIOhgWu/7ri+CXRXse+6d7t5XCLxvBtg4xiA4QkWK8oBfKaHel+5efRSbTrY+AQ/IABMwfOiG8m33eRfdOSqfA3ZdVlUAH3IL/7+H3kO0o7nJts1EkKSKmDLNtbj8ILY0PI8D1Z0bveQUmOVSASe0aqe07M+XuwySiHGi2gRnLGrVDNhTJ2QYiKf9gSTFQIMY39mtYdPdOu9lud2/qVcTOxCzdRnzzW1m0vPjmGI59S8BnmfjidhPeADUBWI320anmkx563z3x1teguf8rReZmEFJeeIgw4DemDC/SquSqOjOUB3iDc8HzIdiZHub2xvAGY3SqZeYgUztMjwaK1cWZSo8bXMDJXe0aWkLu13x7nOfasSPOKDgjegy7mR1es0bmry/9kiLhw0zgE/x8hCElnyAKNwCGs2ApWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Willy,

Thanks for the feedback. That's a fair concern.

The original fio benchmark uses 4K buffered writes with fsync at
the end of each job, rather than after every write. The improvement
is reproducible in that setup, but it is a synthetic workload.

I also tested extracting a tar archive and copying a tree of small
files on ext4 backed by a ramdisk. Initial runs showed 4.3% and 3.5%
reductions in wall time, respectively. However, these improvements
were not consistent across independent boots, so I don't have
convincing evidence of a real-world benefit that justifies the
added complexity.

Further testing also uncovered correctness issues in the patch.
Deferred NR_WRITEBACK increments can temporarily be missing from
the counters while completion decrements are applied immediately,
potentially affecting dirty throttling. I also reproduced 8-12 KiB
of stale file_dirty accounting after fsync in a non-root memcg with
periodic writeback disabled.

I explored a writeback-local alternative without modifying
task_struct. Although it passed the correctness tests I ran, it
did not demonstrate a reproducible end-to-end performance
improvement.

Given these findings, I don't think the current patch is suitable
for merging. Please consider it withdrawn.

Thanks,
Xavier



On Fri, Nov 20, 2026 at 9:41=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Fri, Nov 20, 2026 at 05:55:58PM +0800, Xavier Xia wrote:
> > The writeback path updates two lruvec stats per folio through the memcg
> > rstat machinery: NR_FILE_DIRTY when a folio is dirtied and again when
> > writeback clears it, and NR_WRITEBACK when writeback starts on it.
> > Consecutive folios almost always share a lruvec, so the same counters
> > are updated over and over.  On a 4k buffered write + fsync workload
> > __mod_memcg_lruvec_state() is about 8% of the profile.
>
> Is this a realistic benchmark?  Does it represent some real life workload=
,
> or did you just choose it because it shows the best benefit of this patch=
?
> This is a fairly significant chunk of extra code, and it'd be nice to
> know that it benefits a real-world use-case before applying it.
>
> If the real world usecase is more "there's some pretty high overhead
> when flushing accumulated megabytes of dirtied page cache", then there
> are simpler solutions that don't involve messing with task_struct.

