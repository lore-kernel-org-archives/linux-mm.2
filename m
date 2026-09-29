Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C25ACA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 14:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D7A6B0092; Tue, 29 Sep 2026 10:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F236B0093; Tue, 29 Sep 2026 10:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1901C6B0095; Tue, 29 Sep 2026 10:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8EA66B0092
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:00:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70002A6DB9
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:00:46 +0000 (UTC)
X-FDA: 85266960492.28.2925A48
Received: from mail-dl2-f12.google.com (mail-dl2-f12.google.com [74.125.229.140])
	by imf31.hostedemail.com (Postfix) with ESMTP id 611C82001C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:00:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z6LMQoEO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of glider@google.com designates 74.125.229.140 as permitted sender) smtp.mailfrom=glider@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790690444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QU+DLzGOXpiAxMnq3rRvyxfpPq19yPNpjrIH/ZG4c7Y=;
	b=4wGIF80KHSlfLdGOUWfQT5MYs59Q4MnXGstzVhjyoQ4pVoNBZGxL6+CML1jy7AzMg+ZjMo
	Y8tJFzhYr2u9JmcGE8653zGuWFeJjBlvWbrVRxJVqLLxOPVaPp4wtMhPiFxuH6Nx4AYrLR
	RrYK+N4sGmDmZpAMUDEsqd4Up6fsFeQ=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z6LMQoEO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of glider@google.com designates 74.125.229.140 as permitted sender) smtp.mailfrom=glider@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790690444;
	b=QfPSb8MtN/0mJQUlAkAZy+7G0u31R51Wue0pkdu9insDj6jG6oti/Wf47ZpB7e0VD8ye/Z
	/Ew9g+oggbDR64f5mAxVChNPDeYDSekEBX3MCi7hsgNFHwiORsNae+NTqjYNFpTKPy7YGM
	ASm74TpPZhaGS3mt1b97kXyeWS9fxQQ=
Received: by mail-dl2-f12.google.com with SMTP id a92af1059eb24-142dd04f7f2so2970536c88.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:00:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790690443; cv=none;
        d=google.com; s=arc-20260327;
        b=lw2YT7hlc4PmaPkHPKWtkyoDmGbJKMBcP3Omc5BlqxrkYZVtwjefgvjD9KDHUjK8eG
         kkjcVgp5g0zbteSK6OBwBPEEeJSyCH3kuV6KceF5r6C4muG+hjMVjKByzJ817jyOErs/
         6110HjaqlCWuYy4yOE6A7aeCB8elzVxQKQl+5jcQ6NMsCx60NOKHSQldszps4hFwvgGd
         vRIM9vmojybcXqTUlqGS05tRlyoGorwbmFYsfayPj+9oUg4jIqgTIiZxuiPeZHPPBc9L
         s7QFlkftojteze0R8Zz3GZZJhNWYSOoj9HDxk1Y6YgRBj2EhxhA5DtpjEHZQ2rd1AKJ8
         qRqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QU+DLzGOXpiAxMnq3rRvyxfpPq19yPNpjrIH/ZG4c7Y=;
        fh=spu2UWxJZkwwH8Ghs1g7GvCp9VoDoC2WEQp0SBTKwqI=;
        b=gVzyK8QB/lTvoTalY9qMZVpYwxr0XmOCTOKhdf7BBv7QTETjzQDoucWtL/2TUAXl5t
         kjYBEqzOvWGg5nNhWuAMI3DGey8eJ/HpvYTrHCoCz/q4NcdN6XWQCVo5DV1DsytDIIX5
         /OYZ9A42rF/6F8ZHjTj4hbb0XnfgrzRut2GGyhwiubxZaCS7YmjS9PyXJdBOO7TBaWOm
         h+xixdwqCpQ76QId3gRffSSJ7VEzOajqyPVMzhrwZoW+7BIGCx2wqXnC2B5EVzLuffqH
         kvNOyDjnPwArgWiSgDAc95Q7gRDBpdzwkzqr22I3GScmNbxFBACNHKtB0Alq1j8wcBM7
         ONlQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790690443; x=1791295243; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QU+DLzGOXpiAxMnq3rRvyxfpPq19yPNpjrIH/ZG4c7Y=;
        b=Z6LMQoEOArx6LNbHtBzWmCOAEeyr9rTrUuEqCdO5u4Szw3RBvS+VjZT8D0vK6N0xm/
         hXBuNJSNMoc04Tqt55Wfm4gf+Y+lXf6zyhSvHkyp4W4ZZYU9PxptSPu4r15ySSJ2Z0Ps
         VrZk+NLgRumYoJBDGPxHQh8WpeuSj5DSGAAHSYngSKUOkwPbtgNQZk8Yr4sflcdCPS2W
         ptHBrzZpqb0qrfmY48wODMFm30DToFsHbdfKsHEwu/sSMUdCHHusiSwCEcvmomWcgpF+
         /thlqMlYn4K8xJ1xtTof26uNMWWXEnG3oIbAxF48YJXIG60MYaOstt2RdGrsBEfDbsW2
         TE4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790690443; x=1791295243;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QU+DLzGOXpiAxMnq3rRvyxfpPq19yPNpjrIH/ZG4c7Y=;
        b=0Ik6xjnmFBa52HJnllhYH+rBeZn6TpF9KswTLKjD+RjtOfDrag5zO6xknvuplilNXb
         byhUu4DOXKDl9jnXP49FDpGPUhJNYI9VZi46nVclM6RVFhvHoJpE1TAWj24sJ9CIVgB6
         +O8BRvHCx3z8kt0j/DNsx470brJnpWVDlOn/QGQtaD4iDI+bwpOcRiHfDG8xauDbkp5K
         QWQO7EivX6Tm3wI+l4ve1P2ZuIcZjbplVKY3RF199qT8gW7PsJRCKVSwihc+auJA2x3s
         qxlJ1SYhFwRc8RmsxhWDrPr5zvCs7l2fqPwscvWkk8OtFn02RKEifeYzIRm7SaiwvzLA
         awGw==
X-Forwarded-Encrypted: i=1; AKwUvByG9Ks/CRukdxNxMQfEYpYHIt2c50rfxwoKwo5cX6ptCcrGZGb/EuWiXZ1BsWTCBaMLAtpoRHe/UA==@kvack.org
X-Gm-Message-State: AFuF++lQ8mYhosicCqsqZsfE5tOw46Mf+8kxcYLR1TjwPTBU+JtfNPjt
	Yo7GUD+FePrC2GNLl04CZB+oj+Zw1toZtkdhcyEVH4PeqcGA31WTBBWXU6DRCrDLku17T3pcO5b
	iDpY/kBnPbeLahfrr89GqoTKtHNMPENH3vVlQrOrx
X-Gm-Gg: AYBFou0u31eRyEgL1v81U0g15TY9VvTo4ceWLz8t4uKPK0j+ywU1nxEh0jvMrhyOIl5
	S2mzgmarhBzw97zQgSb+VFiB42G/0QQ+6y75oSoBJfzM6IMz+lL3yqSJl1Ls7eA16Yp4JUjEnBg
	xFOykBq1BAtpUNspq1Jeym0fphH526yRVFi6ygkCaxy7lIkjcoNcwwhU1qh8ynY7vBgzwhsK+hR
	4f7ZW4J2GicGfCz2k6FgWKAt2aVf1j9DQJlxEHFZrObx3H7dFCApLMXNiPjpOkcmau0RZhxMxLS
	Dfg6b3iCAePvU4/FwCODWQRIoyE9Y/d7BIWX2nLeQxCCahMQG5goZHvlCwk045MALifNLNP7Z0O
	CWVLYavMJjg==
X-Received: by 2002:a05:701b:4203:10b0:144:e246:a0b5 with SMTP id
 a92af1059eb24-146d077bc5amr12816455c88.40.1790690441906; Tue, 29 Sep 2026
 07:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260915160207.2952-1-dmytrokoziuk68@gmail.com> <20260915160207.2952-2-dmytrokoziuk68@gmail.com>
In-Reply-To: <20260915160207.2952-2-dmytrokoziuk68@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 29 Sep 2026 16:00:05 +0200
X-Gm-Features: AclHuK-0nrksZ7YEGRoxYPzzxSAUz-0Dn6NeWJoWfkNhrjPIZe7YkKonvpSq2vA
Message-ID: <CAG_fn=Wx-SPUH+wyTnihtjTKAp+4fF_H8LT-mbyj9kUCe1i1oQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: kmsan: fix ioremap error cleanup
To: Dima Koziuk <dmytrokoziuk68@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8b6nh6ziqoaukhxb4h79sjnkosq5nhz7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 611C82001C
X-HE-Tag: 1790690444-796756
X-HE-Meta: U2FsdGVkX196bGCPgCVxKial0NQ4mpGH22a7q9s62ZGV/9CMjPia2Mj8kxEQx8xxkP8BTWgwb1eVuo8ZZlN/ms3r14RHXJko5pCB/xnLqOkOIQxk8BGckKqSmoORNN7v/rVVfcx56bLFoczkaqh7dGNMueQQCGR1i7Bk6ckE7g0d4dp/p2sUoKuX11bOmfaxApnqPRO4DWU6/kxpSM7T2P2bajVQVgFLb5Va10ciR+xzdX1ogJ7ZzaxlTZKK2SCTVzdO6gJ5mLvr13AarU+pDTLEw3vDgZcsPYoximYIDkysbQ7OZiz0PqgJinRsJ+WreNDvnl8HDx8VBNqCZMWj4tFFkq/K/hjFV1CKQChfhor7mqv6R6ROW/RiClYEBXi4KYE9tkqSc1c5EIpOSKl27fmJQTMR40esyDr+DstH2HNNTkTEEfaBdl4bv2FWCf16jMOH7Fpc913HZOJ5j5LX9j1+XyoKwCYaSIEbaJCW15g4LD3Wj3HdTRl1rcfkg/9RbI6KGmMU4/ZGTStudttO2BEuxF7otUtDLN20XX7CeXMgTKIDSXiGPfEinAWgFBUB9H/AaSs2q9EO7hhirMd13osOuwmxGQLxs4CGuUIz6bQQSW7WzdBJiZve2CMZia8OmHbiTBYGMENI2RSf6FUEsRJeF3ptJ1DFqqZCSXfg+m+Cj/uay18L9Y2oYPrzfOfv2rKY35LJJu7ksHhthw/KYn+6dXHq2TxcnYl8IaiiwXYDAhGji6YH8VIzFhUAnLJ88vh4PpEVl6vs982wOPt0sQ9u1pLhni3C794xH0wLDHb6euVr6Xo3O2ErXs4e7bfVyLjZeSZTYW8uMIDoDczyZ6y4GFJKH/+1GOcRv0HznCWS1+rOyAvh37OqchyEC8nr4W5zYadV76FUhx6X4NzaIgxsLEUswS9f7ysLpdpJGKy/EfE9e6j54VcnRtkdAdZIeNnF8kTOnqm0YNTHjtM
 ABlh9Wl9
 YDaqq+OhXCRDKQdXu0ZBObY7DyhFc5c/so9vzgXIrHz5geCBBHqY0OZbJGycCxIt5Sy2Dacj138RAZt4CugW+ruvCOo3e8sSw/d06I2TRTJa1x6DhafgXcTAzmX3uTuOTBUGPHyJgJhHg5bXZb4MZXQs7Kso+g5UiI4T0nRE6UVxGLh3VU61xSOuV3QSh5amRX7nrueS0P+uyf6YIuRbyUFgfa/GDtEL2NRgC4WU7DS39sIy/6HmgiUSNgpLBMP1lmwnwHI2kKrksAnLCGwwtEZ1zcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 9:02=E2=80=AFPM Dima Koziuk <dmytrokoziuk68@gmail.c=
om> wrote:
>
> Looking further at kmsan_ioremap_page_range(), I found three cases where
> error cleanup leaks metadata blocks. Fault-injection testing confirmed
> all three:
>
> 1. If the first iteration fails, clean is zero and cleanup is skipped,
>    leaking any allocations that succeeded in that iteration.
>
> 2. If shadow mapping succeeds but origin mapping fails, the shadow
>    pointer has already been cleared. Removing its mapping loses the
>    backing block.
>
> 3. On failures after completed iterations, cleanup removes the earlier
>    metadata mappings without freeing their backing blocks.
>
> The cleanup needed here is the same as for iounmap, so it makes sense to
> reuse kmsan_iounmap_pages(). Track the end of installed mappings with
> mapped_end and advance it after each successful shadow mapping. This
> includes the current shadow block if origin mapping subsequently fails,
> while the PTE walk skips the missing origin mapping.
>
> Run cleanup whenever err is non-zero. Free allocations that have not been
> mapped directly, and use the shared helper to unmap and free the installe=
d
> metadata, including blocks from completed iterations.
>
> Fixes: fdea03e12aa2 ("mm: kmsan: handle alloc failures in kmsan_ioremap_p=
age_range()")
> Signed-off-by: Dima Koziuk <dmytrokoziuk68@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

Note that I'd rework patch 1/2 to use a non-checked version of
vmalloc_to_page() (see the other email)

