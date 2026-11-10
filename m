Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E04A6606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J0Eub9As
Received: by kanga.kvack.org (Postfix)
	id 06F7E6B00EF; Tue, 10 Nov 2026 12:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020446B05B9; Tue, 10 Nov 2026 12:37:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB4AA6B05CF; Tue, 10 Nov 2026 12:37:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1F8B6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:37:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3AF67140A2F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:37:20 +0000 (UTC)
X-FDA: 85419915840.09.7075131
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4BCC640003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:37:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=J0Eub9As;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794332238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTj3qd6Vt1MRZaASDWxaes19J99UpofFOdzQAHbhsTI=;
	b=3qDNloGjfGhWDQV8ttvmX3snO0qWoG1jGgQZWqMiM4P1n1CPoh3cl3PMzloC8q5EvRrKWs
	Y8jLzMYH5l3iPA7T3ZzsPIYTRbc7xbxpVUdGgwspWSeWeEfs4Jo1sfvC+7EUzyjb1g4KR2
	4SwbYvZLXKLBYP0CWBAxKRzRVQ/EiOc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=J0Eub9As;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794332238;
	b=xKSiFkSXXxkzANEdWOVdOTA2+jSwJMQ6SrP8hEGhGn83ASFGJTx3yT/s/rjUTOEU3Rs4Lw
	Yz4mo/axgDepH6t7/QwTCSxnsYjMbYqmi3BmWDttUPKinzogd5G9+AiABictMGcUcRXAeu
	/eJ1pw7Ibe6cCzXISEo+9c0/u7WnuNY=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5bccb867d6fso2873600e87.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:37:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794332237; cv=none;
        d=google.com; s=arc-20260327;
        b=EPC8MUWgw3TYb1OnBHek7IIt6zezdSp83qgGXQDvWSnUgkiZrp5XxeEcZvzYauOcxV
         p02KbNFIGMz6E5GPeLGTavoK0Le2AzrZVqtXF6IlarKbUefTmZ14sxrJ0M8vrv1gQ5Ak
         xz7qFWG1FWEEAHS3pulE6CjGZr6i2v6kvhDhH5gWeGb2a5+MQ+Ze4e/vWRFMkKW7Q1bi
         xGUGYZKqwXDN5tIPfIgir6xCqfbLjbfErTYWZW90UNeMed3eC4gqw73lPrYLjLuA3Jkn
         7X6KcnzUGArmXxdu3WizYCpspbMl1v7oUN5SR9QJf5MDSzOMXCyJR6nW7v8O0h2tCeiR
         75SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aTj3qd6Vt1MRZaASDWxaes19J99UpofFOdzQAHbhsTI=;
        fh=RnC/lCUaG5jmjsZ3EiXFrQ3XYpcKC9aJSBcs/EuC5sE=;
        b=TC/ek1pnLupO0dq9Z+90YQ16yfLaLyew62Q0JzsuRKJT+gORcC6HBxyeFlNcQrnXlT
         MRMdgQl0BE751x2gMM2xM8W1LZObrhkdIrOgGAvggJkwYNT1F0Vw1UvDXK6q55wT28vB
         HUuHkjKBe5SzQPfJb7e+W4r3vTSq7NSbeA1kb/YhI3tO5FTuURlsq5phiDsdPDpil+6s
         LUWfb24Oc/BcntGJFSWxbn6IX36iSq+AGqpV6y6xwQDX96fR4Y7XeEdNPNIZh/0wHZN9
         UVsNbG6XSD/5yP0T9CFqZSUk5ChnZk4ygg3NgGer1dNVBrm5UezrTjXzfJfAvJZqXGOl
         /frg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794332237; x=1794937037; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aTj3qd6Vt1MRZaASDWxaes19J99UpofFOdzQAHbhsTI=;
        b=J0Eub9AsYatl4PbCc2r+FfiuRum4rK87318N5PA7Gs7cJbylxBWDB3Ki1/Q6Na9bys
         rOmobz3JTk1WrJpiwUmvGcyAXzeC+B4N/aJ08yK+ZUpS7xPsMg0AEpfV7+px8s4U7AnW
         Su7kxfkZawpPOGe6DbIOJ4v0liIJe0CgkF7HjzzYgOXUHxZ2E+74fyitJgKeRtZllSSr
         xhqv1VFLjQD2icIi4PwjWkGxafJnUrDoPjLt63BhkdPpSWD4vjBv38I5E1EbfYz+txzM
         7VfzoQQ4XhXQ81rJ/3SXO40/UEkE6HMLsvsP8MvpE7iIQw1yvRHwEyAyvMd7Nn0m97lf
         GMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794332237; x=1794937037;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aTj3qd6Vt1MRZaASDWxaes19J99UpofFOdzQAHbhsTI=;
        b=pAUFRBmjbho6R+JXVnp5l/xAxuoRb1CQ+9R7kPhSzL/fH0jgHmqKPKWxVUyhpIroKV
         DMfqZZNjMjX9UGI15n7irYDDRyU8709WNZ3ZOqMbnAyFi/gcTnFc5GqGxvzZTPZ8Je1Y
         OQgP/yyZ1mQOH/yau0Zz+GYDuv8XiwXP4TNh84cFNCynB3EpMWcJd58k9yEdrYL7mE7R
         JkY2V21gESTC//RwuiMeFF0YRDVU3wS1LCY6G1iXMVMJNvKXr7aD8mgY5mKABAU/IaAE
         Zoqb6KUwPGDtob4lZeUL4s98GXbtxg45Um2hhclSJVmWAa81i6RATjtMxxVmoBClTW7W
         PQBg==
X-Forwarded-Encrypted: i=1; AL+hErFv/VJrOCPv120+FPFPFcfmC2PaDBGt5PQMbZVMkG/jrzTRtnaTpbgqCxwRTO51P0qavXIk8wmsSw==@kvack.org
X-Gm-Message-State: APuU4Z9qAY34M8kBfxc3Re6CSPgi34a9PEP/nammsy+7AMm6oK7jtG/h
	oRz7WBjIw+TaGs7iTMKXt4KRFjDz4YHT2l2QlXReD/DUhrnLDw4ZqtbO5I+Yc60iGaU80FP44+9
	lHqRu5FLnJCv7ck2TdZg9Tn87J4hJhhyKW6lo5Oo=
X-Gm-Gg: AYBFou1L5/rz62ub2AbJ9vHfCl8nbQo82sG6LtpKm3r5t+rTDlifz3FVWsRkMYZQvKN
	7mAscgg7UdMswfz9rQHM/cueP6lzXXGL3dcaxLWtXoioewmBsMp1ya0M0M2VlaIM578JhxgsiIJ
	p7k9YRMPugshkKuTb/bz0CBNaP7OHSfheOfFD04Pojci9mCb5m1fb04m8qc5tDoSieMDubZ75fJ
	97Bq/yoG3zqmu/42RUwnyT5FxtNWDMhrBfPBgepmBCPkprsj1eiJSavRADNJFKGV/FtmXRqMQtY
	e38Me6KTbg3oy9rFB9iwDxc2aTeNo6m0YoP0uNxPD8W4SuDHmQXBo+kIPzl/MCw3MoxuY1ZE0X+
	FHVGlZ8UnrL3TPNpeXZT5wKCQwrqNm+IeEgK/Tt+IvRA722H9ExMKty+hus3TAKQaIhravTm++C
	+b1W93KRHeUOCOqBP2W5g/OkLMJvIT17HGU0JaKvilSWTvCpR5YE0M
X-Received: by 2002:a05:6512:3d1a:b0:5be:5dfc:864f with SMTP id
 2adb3069b0e04-5c156edbe56mr956551e87.50.1794332236347; Tue, 10 Nov 2026
 09:37:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110054836.1515030-1-senozhatsky@chromium.org> <20261110054836.1515030-4-senozhatsky@chromium.org>
In-Reply-To: <20261110054836.1515030-4-senozhatsky@chromium.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 10 Nov 2026 10:37:03 -0700
X-Gm-Features: AclHuK9LQ0vxiDk2KIYMiT7GhqA-_skur47RligP3Oz7EqQzE4-EQhLXbRXuiB0
Message-ID: <CAKEwX=N44K-0d1KMV_iURtJU+xSuv-X_x2R=g1tBUt_QBEx1Fw@mail.gmail.com>
Subject: Re: [PATCH v2 03/11] zsmalloc: return handle from obj_allocated()
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4BCC640003
X-Stat-Signature: zmd9qohpgkh4qajzwujkmtr1kptp8opu
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794332238-91942
X-HE-Meta: U2FsdGVkX19R87T+sIOvO3cZuob8rFZNI3g2pE7UUvQ3EC5lvbPKk8p8Ma4Vt/ZnTjpd3LfMlkDTHDzkQnFs6ABzINvyZrgefY1BVzi1LLyU4IpyKZ0+fVyU1GZNVNd+RPdlAPDNUMTUo3hpWBv0cwkywsoHGmO89JA+v0mHMQHy/SMhSHSQDlJ/xfEeZrNFZ91W3aM7q+n93BAT8C/EXSVW3y1JMlgrQyGmxMVwPq60icphVH/VRDau1YsLP+/NREWG/R/SoPiQiQx9Un4vr/wjg9tmLmjZTbylYt8Ol7B5rrYBIWOvTSv1WJD4laCLUkGIgWt8F+5RmBFJUboKoY10C7h20ZhzMDm3MRGbpYD3dDWlIhUk/2J8HRCHw4bCb/GcrbL9FfcwPAo7kdJFVI8qW9c1Z5NWBSALayNmddz6JeFYQxmw6K2orxKYxY81y3+kuWymMxAfMvbtQO6CUoLHZOcQatJchogOmZrXCM8D4bRxhRnDyXzOzMVCKMeL2ZVBKn8VQuHEpp2iXX8aICoOLPhSLOLHzKAK3bOxBn10PZbY1NcRs+Hv7QoAMTfu7wZT6saiLHU/snSSfXT1EHRbi84iRTyZ/Bs10PdTBEWr+2ptkhCAjG9XLvyGc1N+38kd1yxzUocCjACMUr3d+Z3Bs6fPu4qBUpvPxMP2EYPGxhGc0nWg37kHmLszFAZ23ql9bCCcXvIdxVkUIbfrfPCJIeIarrq0GWY7kjGGTyq7EACgXBNMsvouhhMSDN6ryr/4Tkf33wP6fZ8gKqPnRW2Bru2m8L+6b7Oydc9PfkTcbTawrvdYFftCDfHf4O7rBhzRnrNurN0UE3gW8cQPzbo1SRpT3b7oTcgV8ybtC1WhuqJk7c+0DqqW3K7szdmY5T18yejupeaVkOdJYE9dLdD6h6kCr2RSe3RzGSCIeV0S0KwlVIWdn46gPlK6ZXxNjwrS2zCoFihxq4Hp4ZA
 AICQngtc
 993biyYtdROnLBIYUmDsFyqeKCFmlqxYx6m873BmUSjVJic8tWJiRos8Accm2p7zflfPrklTBuR/qJy44vROGaQATeVMmxRKpwEO9gSIWI3X1inxw5E+gvASkQ3kuDvJmobNVXP8pahc9EYr9bBEK/E/IAF/UML9O36W84Kdq6PlTgcAEjIBURBk7FF9BkkrGeaLh/VJjd27HllrIl0dEBYcTcVThSyy2sujms5xVze8BN5P387HEOB9VybPGrYjHrUBA5nf5un0DISPRvZFs3Q0XW/9k3rSfESudT8gAxPnnJA2jy9+Yda29YnH/cSOwActfGOPwJOpeBGGhc6WtV/2uTnAyrn6i8cg9QOEKTtsqyOCF5LSEcl7dL4L61/jzwlaqTiVmtravfZVG94HXGr5FzgtN2hWoIaoB7rvx5cskW8MkazwIH6r48FGvwQ2OigDX61DZXMp4X5ck8F27buRL8Ul7KuR0AvwSRW8bRPnYY6AOlwsYd0QxLMvht8aFiMD1oP4nJ93V0IM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 10:48=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Allocated handles are valid kernel addresses and never 0, so let
> obj_allocated() return the handle directly (or 0 if unallocated)
> instead of returning a bool.
>
> No functional change.
>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

