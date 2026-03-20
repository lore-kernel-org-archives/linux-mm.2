Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7489E1093170
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 05:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A4B6B0005; Sat, 21 Mar 2026 01:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94B496B0088; Sat, 21 Mar 2026 01:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83A006B0089; Sat, 21 Mar 2026 01:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4A26B0005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:11:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 279B81604E4
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:11:16 +0000 (UTC)
X-FDA: 84568896552.04.7955E73
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 748CF1C000C
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:11:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bkggv2X6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774069874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=7QxDv7wA5vy2wx/iALi99txiEfbwQ3ENlpnWZYhHz0A=;
	b=2zsG98m2Jz1qlwnFrClOpXeCVOcReeHoljHx+osAx1AYPxZfnOIG+jYWEAN2dXr/r0NFV7
	/iGsL2mSOe2SKVTjnbYQUEPwIkb6vlry3BnYbTzbXfCozSVGnAmsCx7AQV+jQUfR/B3gop
	hjNYLlVj1QqZpAao+31h2QtAyRehpQ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774069874; a=rsa-sha256;
	cv=none;
	b=lRK6/HQioPoEgZ0SBJCcoMbfoYSHtTdkDOic01ettUk4cL1+4S933wtjplZJTRPiWpgwXI
	P1TXoWXJSg57QDsJfIhOr5ypg7ghyLMhqr7xxcoeTYmShETt06LXmYYubdyD3PGiP5rr5N
	myv/vdpvp9J+tSy2gvZ/bq5qi19UvOs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bkggv2X6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c742d4df00cso1069275a12.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774069873; x=1774674673; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7QxDv7wA5vy2wx/iALi99txiEfbwQ3ENlpnWZYhHz0A=;
        b=Bkggv2X67Um1H84GGUxlVAtfpmqF1H+YmE6k9PF1VLSeDwPqn8UlQ5lFOKr74q5J2P
         7lxngUsSaLKypScNZZLg/pMjxUUO3CNRncVRDO9cPQoApfUMUL/CLla7Yai/doIEIbkm
         R0ptOpPHsmBdIZPUI2BZhgsMUMVIkOvRh8atQLJosZjG0E6ssvmU5n1OxWaEuTG9OWew
         dFSSy+AFbbKwj4y2HwXTTjCpxM/+xH3EkmJ1qASEVHZcS+AGKhVRRRC2XOmoUsaGgm+2
         XMHHKgPX7/NK2urHVKyp++dsKI6szvNzsEMTozkD7nsy3V1WczjdXxitPxy6kKGkp74I
         XgZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774069873; x=1774674673;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7QxDv7wA5vy2wx/iALi99txiEfbwQ3ENlpnWZYhHz0A=;
        b=FxZVEpw1/BKBwdcVRTSXas+7wf7rkfAynKK4N/eRwU4aKDAPuSBz5MM6lFSa2KpCkQ
         3KMkdz8yVQi5zqb/52DaF92Zwm4+U+0DKGbubqvzRcIp6o+Y7dO2NJTd+LpNyAN8bdBS
         NaA62hGhRmZTtvS/lk56AiEaryyNGnqHXiWNzabS07KwWHHuUri/Pe7WiUsyiGPjOEqA
         LeHUaBcyc2+nucIrw1SVheRyAu1xnanXBEJmpP1P5RN7O5AEgbWo5qLRc4aByUsJOOCJ
         T8S0cisT9zy+f/GKbmX5YSKd4lea8aI2mhkrzndb7R78E/jqUkeEeZQ+8EIOgaxU67ML
         Fg4g==
X-Forwarded-Encrypted: i=1; AJvYcCWifoD3k3rZbWVx9oTi60znorzuMcioWH5Km5D4yj6iFHaqRSu+yXxxf47pzgDIba9p08q+4KFNrQ==@kvack.org
X-Gm-Message-State: AOJu0YyaxMoU1hkwtGn+IsbKTM6PnnjpMKnQ5VsR2SeWRCS24rjLooS5
	nEuMXR0K0n2+czRJJjr5Mv27KP2sMBFEah0SX54apgBxUHLYhBst+BTA
X-Gm-Gg: ATEYQzwFCFFxJuswSi+f0n7Kcl4zu54i6Knrv0xghDHZajauFut4zna7je4ePXDZIYG
	O6pQhIBZbReQ1OumPgJ31GfjMGCaeYSxJa2Beyy5PrXxlvvl6OE0vyJ00BhZrtDKbnjOSJ6r5sj
	RGuiuRUDyuucga0X682EPMIcRRRgGDgrlCEDzdyInPtT3HnyPNbmNJt5VlTm8/VB9lSoAh8230N
	mZbZdhjjrVn6AaKytW4+Jmc0vQZ9dbg073o8akt3ry2vnkksnG1i5Qs4NUtD4c1HESoMDSJ/8L8
	f0PqUhHFTpR2I62MWkh1rlr4/xRX7UY1sSj6NgyLYoveGx2sMIxdoPAPxBsRFJLUxgOnXLSKNx9
	0Iv8rsmjMtA5CaBL2Ulw/HjYkw+jDZi6/wNBZbUcSTz1nYpSvm8Vltcuhhoy6lj88laqpd4AkIh
	Q3+Ihr6EXAEw95zkZbBjSALQ==
X-Received: by 2002:a05:6a21:4cca:b0:39b:9c3a:f54f with SMTP id adf61e73a8af0-39bb25e7511mr8216718637.32.1774069873215;
        Fri, 20 Mar 2026 22:11:13 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c743a939af0sm2729778a12.16.2026.03.20.22.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 22:11:12 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, david@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, baolin.wang@linux.alibaba.com, linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm: change to return bool for ptep_test_and_clear_young()
In-Reply-To: <3fa94c3c89fd93fe22c8cb59967f064787d686aa.1773890510.git.baolin.wang@linux.alibaba.com>
Date: Fri, 20 Mar 2026 11:27:48 +0530
Message-ID: <ikarxctf.ritesh.list@gmail.com>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com> <3fa94c3c89fd93fe22c8cb59967f064787d686aa.1773890510.git.baolin.wang@linux.alibaba.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 748CF1C000C
X-Stat-Signature: adfjcjt5zmykbb8apcf46tqj8cndk59s
X-Rspam-User: 
X-HE-Tag: 1774069874-452997
X-HE-Meta: U2FsdGVkX1/03fAE8TP+xgUKPDrVhBLDPGld4vyACFn8iTzSwYH01G5fiAE85P0z6w4Ac7rzLA+ttsDnYtMpU+3Wiy7tfDH59u0riG9UUHJI30CufGVlHKzNpZ7Iek+HcSrNCZgEIT+aoYI/+/8nIMjp8ajDpLwjXag2JxjviTu7rPIjxcLcrUa2iFVu7Ig55n5Vpfe37IT5excSi1zoO5EhGTATZHBSGErjoBUv3LosZQIaLPopEp40nzNRx4JItokjMMa3za6FmlIZbKZ8HNtLM0hBwAQjg4CfAcJF4Ba1ahc0PFhBI1oCgxKjuFeSxARlfUkZ+K7E/JWPkvZ3W3cGcLWA1kc5QQQ9p1XffXrXTpDeOpKFkcaErk6iYIRlIF90jxzxx9Bt/xe55JrybwmgF8AxP9PSF6YZz9Z8EFTqWADZ8uHucdckVzYE4CAweVnButt+SFhN9gUTTHeYJDGdcKZjoxyH0dFUbfxWryi5M0ErwsCP1EdNuMznF+S4VZoQlJNezssu7uZskVsfU8SLGmtdJUlmO4HMUifxsOIMg+Fvo6hX/tdiEPhSpCe9WhDroz7Gcdau29kmWng6cRs+4IPRaFLgfKiYYiEFIM49+4QlT7gJIqe2NCXsRG/7/MwohsHXEmA9wX4Vwu3nf+iVe3AWYiqwviu3Su/fUtciyjcmuLOs9ComGOPd8tYFqJ1drdDN8s/w/DRz1I3exFlUcEXENkNgyFcK2opI5lw1EEh3RIVP0lZGvssRIjMaNo5ClTvgFPyRI9RrJq72/2u/yd6Q+dkL758KtkVH8aNUC7N+mjCtMMHbcOJCUi8qvDS/aDwkKPDLQYEp/8B/DVUbNH60XKq8yeziKHYS9xE8lll1UxVT99b5PHJXL6iT8RobPTF3pM/iIx4LOebMgKJERw1HfY5i+BgAZ3/m8sdDaBm7nVaYn+wSBjT/yabNndDZKS9cbQVCQN1GdEa
 /+dHbR8I
 c4zjP2UQIlPiR12A8XDnuu7RtgQCCl6YuMp5JQFa3C3DlcTQOCCUy/RAX82es1v6rirHNH3O62qv9LKORjTEZtHrzCQWu4UgyUMfVg3YLDyD56k0DC8wPDeHyL/vrKodbHs3CSy7BKB0w5F5gMcJ0TudJq/z68IUAMn5CcT1Asv0WmvoGVi58yT9cNBTxHGLb5kuysH50FQtRVryALS/j9e7Z7rQtqUJRzrBKAo9e+GXBbEDJN8B0lEP7VMF6l8b04tYx5oUR2w2dWR3VXer7P5JNQZYzbjANgLXW3Xi1qG8W0SjUZ1OzdoiHqCaLdCbIu+as9jJnFUpxx2VLBEd7y5E/gpjYaAiIqnQhy3vsPX9NLFKE2u9DkhyKIyW9F0nIbR+l1poqoAD6RYW7MJt+Q6tBQMvw1gUoROAWlx8JeEXcKygQI53Hf7RANEaypMKlCNvdiltgIFhyQDyZKhjjkC91JCRry885FYc9snioupFx38jhJ06/KFE0iBmdXi0soEvy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Baolin Wang <baolin.wang@linux.alibaba.com> writes:

> Callers use ptep_test_and_clear_young() to clear the young flag and check
> whether it was set. Change the return type to bool to make the intention
> clearer.
>

Right I checked all callers of ptep_test_and_clear_young(). I agree, we
only need bool here. 

> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  arch/arm64/include/asm/pgtable.h             |  8 ++++----
>  arch/arm64/mm/contpte.c                      |  4 ++--
>  arch/microblaze/include/asm/pgtable.h        |  2 +-
>  arch/parisc/include/asm/pgtable.h            |  6 +++---
>  arch/powerpc/include/asm/book3s/32/pgtable.h |  4 ++--
>  arch/powerpc/include/asm/book3s/64/pgtable.h |  6 +++---
>  arch/powerpc/include/asm/nohash/pgtable.h    |  4 ++--

I looked at it because of powerpc changes, but ended up looking into all
call sites anyways. So overall it LGTM (and I agree that we can remove
the unnecessary externs from function declarations)

With that please feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

