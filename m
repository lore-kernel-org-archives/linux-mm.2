Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B281AC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CCAF6B00A5; Wed,  9 Sep 2026 10:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168416B00A6; Wed,  9 Sep 2026 10:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39416B00A7; Wed,  9 Sep 2026 10:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D12596B00A5
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:54:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34C50160245
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:54:31 +0000 (UTC)
X-FDA: 85194519942.29.FA77AEA
Received: from mail-qv2-f2.google.com (mail-qv2-f2.google.com [74.125.230.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2ED5C40005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:54:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ICEPjR3z;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.130 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788965669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4xAGJJ70mlqdEm3Xz/8BQ6RoQZ90L8GHwhRK9Ys25cI=;
	b=WuCuLcuzxPjCHllf1SPjCfqa7G7Dzbr9YIqBdo/M70+dRkwOD7KR7HFky7AbhnBjUDW9No
	9Q9fHySxcJWykE7tZpYktpmkL6HqRe7EsitzvR6q/WO1YFoNFQS/swpA9ft3HOv6Gv5LAU
	hx1H3sTJ8prlTWcoiV+29+nWvQSaINo=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ICEPjR3z;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.230.130 as permitted sender) smtp.mailfrom=diannaaav@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788965669;
	b=qaqtlxxQcY7jD8Utq7OGTBrTrZdmX9l2nKEEuIpiE8TfoxiFM1pWWB/ufftjFOr6twNUF6
	BeB+VAP8IrA82qz3S2WYxOKvvZbIoFw6TDhPT78u2KOLxk7R9Qdcta//Mz3tM0/kfEDdr/
	hymwTXJ3jFvPe21jiBohiSGVgRRDNeo=
Received: by mail-qv2-f2.google.com with SMTP id 6a1803df08f44-90cbfa89a42so39380556d6.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 07:54:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788965668; cv=none;
        d=google.com; s=arc-20260327;
        b=rjiBPlZmj152aVzMdUzV7MOLC8hDR9QlA3fOpQI5poJvbqsGFgJg2qk2CgAVq6YDBS
         uYhsroglOIDVPo/mVPtF6zzgXdjHWp19PhCgu+19Iu1bVcLmiQHpde/d0kGgdNk3YjcO
         3p+wfkPpuiySBCjGH6rmAVkY0ijOMs+bk4CXpHidvHPv+CT7yp+C57c5/sjEXg7Oo21k
         nMrHHY54ac1y8uoAKSub3wpW8nSOa5iSa0DT/sI04oGR1kEbvLVjDyKZ+iRbMAWnTNCl
         Em0/mJg1XQWxYakUNmB92oE/zJxFKMUs7RHOhMLRQJLi7DeV55Ow6dkN4NFcNNHUni/1
         8qtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=4xAGJJ70mlqdEm3Xz/8BQ6RoQZ90L8GHwhRK9Ys25cI=;
        fh=Ga6GTn0TgWsIpcJ0/v2qfUV8IBqfz0Gp0gWf6yk2hWw=;
        b=JIcjVZr+lPnp6Qd7Y+0gfcbg3SjWvVh5s4drlqfPRZQA5psw0hyTelBsh+W2aNuyYJ
         swGg4oYPmfuMTOflc81UG/erEc7vqtlLJPaSPM9v0dT0KSEZD+bmPTHYtFrkhdKU4nMA
         pAPQPkKltSt1Ma6VZdJNhbnjMIJGBlNuTiTZI5naeDx9b9D6WDsB6SIwHH3UjZB6lcY0
         jheroJHvUJ/KkUIysIkE4TcUPnlCmWBeDv5mZSqps+vBYNSsqhl9h64dhf/btCzN7Plg
         2Hk7leBE8P+D5DIrAltPy+dKhIRXjHftbo/iDFMff1GcrafW3TWOcqJ6xYVEN2cNMfMm
         Kwww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788965668; x=1789570468; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4xAGJJ70mlqdEm3Xz/8BQ6RoQZ90L8GHwhRK9Ys25cI=;
        b=ICEPjR3zmZlT7jk4HkFAHg+vsS7dpt6YTPUacpdxecUZ3Mb11fhgnOrziEyleSH03b
         KKSGlGJnTwoC7Sp9k78yixhEUiuUrvbAWjRJDsd7dCakTlIB60r2YVNHfu76EdPx5sHt
         eZk8pxQY33ZfqYC9Phx9CJU/CXnhTImplv4DGEXmfJxjlugL1wsoxD7Gskgtrspq1O/N
         3tAk7nTKRXiqVSTtMgWNc5j3ZOHXW90pk8Gey/9NZKp5M3XRZr0bVApDg7JF6H6RQ7yk
         6Sf4ESkL5Teb3JPPrMZVB2UK6sdiL0AfvoTL1+1byaB3MnWxtIKWPOlei8N3yBhSnvc4
         eK8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788965668; x=1789570468;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4xAGJJ70mlqdEm3Xz/8BQ6RoQZ90L8GHwhRK9Ys25cI=;
        b=BpyPYUeuLtsN0S9PLv28efBykrZxRNZVIvaGlvM1J+PSJ3QN6F+bo9Y2HZLTd/Hjl6
         cNTHClcKZezZlXQQXIi4edfcqPKFUviV4umsSADzcK9btTeOvWR4rF3XNfFPJ04kmL0C
         kWENUGH++ipexZr7r2i3t08CuSQwhdDuBJk9bpiFsUUnPFYEttI8GMnlfXnbkZsVxC6w
         Z+X4si9xLCS7TlZuYXTZSA5IksPpDkaPQ7G1g+6u8iHOA/q+xZiJGQgzBDLCAGgKZ0Ag
         mKbOUHis9cGSa31Dsju5+OhFkORN85MV7dqLhOQGT8DyBCvCodXhUzwJs+N9wZ7LTQYw
         geQA==
X-Forwarded-Encrypted: i=1; AKwUvBz1WJfFNnLuCHmgjf23lUTr+AMjD2nct/CUJRsJbSacWQJ1VJ+vu6vCGhA9B2t2yhyjH174nhm9bw==@kvack.org
X-Gm-Message-State: AFuF++mfWyNQ9IZaqZxnx2k9sgZ4vkl3s8c9hVW9PO513UDUUHg5Cw+e
	kdM70UG9BO9VrkGhRXOFPgJrKDQci67qqT09T8Z5K80K1zWHBxfl2LCgZ1nJueRcJgxZALMnhs9
	Y/nrw/EuU0/i6skT6KsiGERVWk0aXcWY=
X-Gm-Gg: AYBFou3PpqTrwqBvB6fDLgHSIZTTqRMnnJQqSOexY705cQf1CBBvHskyC5EJdpstR21
	7xDcSw0LxLmsCd+FaNK3s/9+RlkjJXzc5gWfVpKrljmC4/rvfxSiGJH3P1+vrjciyuxxjbbNE7x
	fcD4OXVD7BHSxsTC8p+Z6Hbww6p2Lzwp3sSWtTBlK3LmcPik49dcFo3qwKI0BlNquSYtVu3hqUa
	hZ2FqMfJViK4gLG3/W+DKtTu6NHQYAIFuGpvb395WTSRvu/el4/h+oUX7mUMeHoQpihkMZa1mBk
	ln51iGat5A4Mg/gkt9zg509ZEme4m3i9tTUv7+fiFElHOniRIW/nMQ==
X-Received: by 2002:a05:6214:4e82:b0:90c:4422:84d1 with SMTP id
 6a1803df08f44-9103f043439mr445579496d6.30.1788965668174; Wed, 09 Sep 2026
 07:54:28 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 07:54:26 -0700
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Wed, 9 Sep 2026 07:54:26 -0700
MIME-Version: 1.0
From: Tianyi Chen <diannaaav@gmail.com>
In-Reply-To: <CACGbirSdR30=YTPQGN-=202jZqiF8gBSewhq+K_fTSNpq=DMhQ@mail.gmail.com>
References: <CACGbirSdR30=YTPQGN-=202jZqiF8gBSewhq+K_fTSNpq=DMhQ@mail.gmail.com>
Date: Wed, 9 Sep 2026 07:54:26 -0700
X-Gm-Features: AcwNN1UWv2D_GKiUaOtOtW1R2NBCj6J4Tg_MXEtj1RtMJ4y8_q8aYCl2gqilq0A
Message-ID: <CACGbirTZFsyQhOszpfiHhrd7Red-L_Z_=ke7DbRDe5SQfzi9Pw@mail.gmail.com>
Subject: Re: [PATCH v3 RESEND 0/2] selftests/mm: Validate selections and scope
 memfd_secret setup
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Joel Savitz <jsavitz@redhat.com>, 
	Tianyi Chen <diannaaav@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: wk556fp64dkpcg75e1skkrpyduywit1s
X-Rspamd-Queue-Id: 2ED5C40005
X-Rspamd-Server: rspam07
X-HE-Tag: 1788965669-567572
X-HE-Meta: U2FsdGVkX1/hT0j578fd98nbXGp8ruWQcFizfyO32OI/Q6Kh4TJHDAwvb+v2D2NuHMQIorXD+QG7xaWZAYRS0ShNZ1IwPUc6SC8xcpMMcL/qKuclR4I7k5gxr9BlMRLyRkUosJANPVRyHksGkA5N3jimN2XuVq6Y9WxVQe4rDSi1pctCQibztO6zxOyOsGhxzjpozz1FMCkOmApvkQKfhz+MperqMwIk1j1vT9E4C5s/IP0Igrj+iV7Y5DzLr3luATT3r/gamGHOA2H/7IP1qa2+NZvPQ/JWJ3u0FzqpcFEx7WdemPl903M2SskFkGqrRQ27AzsCrV768C1j3/oum/PL4BFm+JDFCuUs7wCuOc+uZy9PuuMrNjRsWdSiCmBWzzmuRKIOch0tTUIbhinPqifRLth3R38zLkucTKpqSh3nc828Gq/CAsIYiObkkg2f+y2bqWMYMdrkiJnC4DRiRablRQF2Kf2a2YuvIv5ZWb2vq02JwJjk3Nl5pq5nxFv6VbfpjHybbImiEb6fPC8EsBDhAl3wyR/1N/TgCE8Y9PRFTteOrxh+sEcTlmJ/QL6TcRuPKOdZEWVSAltnm8Ozzvws9E43UePz+2NH+BEw5LEM9ci7KvIRpy5p1eoI1k24Zym4ochvTVCkdtG1KHbLwxQFq/vNqWgXTa3kUCx8bwZB8d/X+c418TrS5ZvKmMSwdTIJ8eTA2k+dumNuhk3qXmgJ3UKxH4gP0L7B6DkrJtjcUhNP9bCeXfkhiROpsl+xScXImi/em5F5KZ4M34VM6F559FcdUICh4Jd6Agp1iXcCYNgsfqyKM6ICFXKvb3ZXTCmUeauGrg2zGA3vzzV3diBnLmL3rIbzWxsEEGeVamAzsCvDeW4+YnNEmgMobK/u/Akzw3Ud9KjQxcfVF6qrdnA/l3/+o8n1+u5dKuQjI5RhJne4gpVRwgbvkidHbvxauFZ3GoUIgC82WHXZr5K
 jA5iElqi
 sM95Z202GIbPi11EV/u+2nMiiGHJFeni0PN0HRhwrC/QchCz2O847W7IrtV602xRa5HTR7NUC+TjyIwpCXofqFdvpMFmESZPXm5ICR/4DnmeAmUHMfkeVJ2MMqTVUEZGIs2kHj0Dt2G03N23Oac5QABYg/RNUljTWJQMjEW3qnlhmr4d8ofMJNQicD3yo9fJkzvlD0SP59V0qeFmbfrYfMmEL5uca5IoqcgcKfNRmsh4Zo6v8NW8407AlXso9u6Y3T3K4CCBUZEAQF6A0UawwCrvcphyVOG4gj0SqyzfozJnxCkWUHAbNHzsV5Wblq3R1RWG267G+lOzmdd9Gz1LrbEtAJd/Y7WETj5ztEE2xIrxyeHIHz4p2YeSewV0O6XjECImmx+0N13IItb3JMy3gdssamDh0kWtKe24UhNYH7eHeXsHMQl2KikcOj2ToGA5AxInLsvrqCPeffU8vJNdglFvkORUB3Us1pybOnnjLZ75B7bsILYkjyImLy9xWdtiOaNVTrFzrzMU2H71XnIn1lAK7EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

Following up on your review:
https://lore.kernel.org/r/d6ca7f47-39bb-43b4-92d6-63ccc148ebdd@kernel.org

> Who would set it at this point?
> Can't this just be
> VM_SELFTEST_ITEMS="default"

V3 makes that change: the default is initialized before getopts, and only
-t changes the selection. An explicit empty -t still fails validation.
Both patches use Assisted-by: LLM, and patch 2 carries your Acked-by.

I have resent v3 at the start of this new thread from my Gmail address
after delivery problems with my previous address. The patches are rebased
onto current mm-unstable without changes, and the focused parser and VM
selection tests passed again.

Thanks for the review and the ack.

Tianyi

