Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC51109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:08:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87FDA6B0530; Thu, 19 Mar 2026 12:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 856F56B0532; Thu, 19 Mar 2026 12:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7942D6B0533; Thu, 19 Mar 2026 12:08:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 624986B0530
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:08:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2ADE21B8604
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:23 +0000 (UTC)
X-FDA: 84563294886.25.BB148AB
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0A97D18000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vD3KZPJC;
	spf=pass (imf06.hostedemail.com: domain of 3ch-8aQgKCPUgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ch-8aQgKCPUgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I83H7LOQRTTShg4dUTvQZW36KKHx3Zyf+FuXAIrcoEk=;
	b=bD/wLTo6vBT6V8n2L7+X/hKzSVH/7Sl/hrSDl5BIyeX3685Iv9T7NF9UkzFDnJgFFs5CeI
	32iTJih4pIETdcEV35SvQd6clMrhdMuxYI9CaCkx+k7GBK00I5Dbrv/kwFW+ogCAz56Maj
	TkAmyIWJm5zr/xoPIEo3p7Pn/7z+gqw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vD3KZPJC;
	spf=pass (imf06.hostedemail.com: domain of 3ch-8aQgKCPUgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3ch-8aQgKCPUgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936501; a=rsa-sha256;
	cv=none;
	b=mSOR9vLYcuNBC60YFz+0RC+LfLAig2xmPNzhzORliSqiQUiZ37azSXAyxKkF1y61pyFpmu
	IeaXxNbY5T2daB6iW5xsiUTmNcInlek5xyjcbBvdtG9Xq6qWlXlNIFXPndPuzHGJufnses
	jhTB+OgmuJlUKFR8rQq7kHML5qLUurE=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-486f830f4e4so11321205e9.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773936499; x=1774541299; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=I83H7LOQRTTShg4dUTvQZW36KKHx3Zyf+FuXAIrcoEk=;
        b=vD3KZPJCfDus3+jUE3hmk6cw/57BCTHHhzLPbhdmJDzFlBT2wGQ8sJDmmgSvB1lAkb
         P1arsioECC8h+PzJQ/tHyq9EAB1AoFYJZ3o5i0fgXqqdoGpZN2CMjJto6FTpG+YPPYjl
         4yY1f+cFQ7aau2O/VCmLixtI810W7Ar+/bt6BJ4vSwFRB+3uemDI7ZKgLfEIdEmTy818
         gr9GIPfj0c8Aa2XXLM6felyaTpOFbCpciHOIijUUW7f2wciCL8cV+XWj4ugY719SDK4Q
         nnupT3n6j8o5zTvbJoMHMKfgJIjz30CKZU7G1uhWUHbsg09SPrt7RNfkE76IUb104bWe
         z3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773936499; x=1774541299;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I83H7LOQRTTShg4dUTvQZW36KKHx3Zyf+FuXAIrcoEk=;
        b=E3HdNmFfWsVVjVYQjYduvHzL6z/sI2bkahrhjtCIVfoNYvqPdX223pTB73TmQ5tPeP
         sP5C0nfXluXaBnE39RWk7ZE5Fx8DHSJT+WP+P+rxUIY3BMtBiTbHBGA+GtZuDrP/UIiy
         rPbsUBT15/N3iG2sbzVxdYmti2kT2KLcr5qhi+clbhw2M42eBY1B4yz1tzh3YUYpUqmN
         OoqgJvYNX8f3RjF2tTqVcvsELsOieYb9yPLe/aJVolkoAY6mpB1iHp1mfaeV2bTVHXF1
         c2m+UIAz3RCVjZuHfVNMkFjj9XtSt3O/bSo+1+l9UkBumItC+hmjvn5ks2RFP8QSWVAs
         l1+A==
X-Forwarded-Encrypted: i=1; AJvYcCUIp94hmGsyxRfxZ52XdlPCZNTGqcYwfjy6M+pPT5soOVvO9eWU2CLzMewU+LAH+Cd6omz1RRb4rA==@kvack.org
X-Gm-Message-State: AOJu0Yyyz54Tqh1/pcmltXusfuBKc/FumxGcc5Ex2RbAQfYJ+oJGCISo
	nLhGOfLKO9oqT7aC0X/p9RRmVp5u88i4RLF+1XvsxilMoBtazGdYNqxYziWwpHZTnPyC54um2Xj
	1LuMUg5Sde6o0Bw==
X-Received: from wmdd10.prod.google.com ([2002:a05:600c:a20a:b0:485:29a1:bfbb])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8183:b0:486:f634:ef1 with SMTP id 5b1f17b1804b1-486f634100dmr112320615e9.17.1773936498983;
 Thu, 19 Mar 2026 09:08:18 -0700 (PDT)
Date: Thu, 19 Mar 2026 16:03:23 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAEsevGkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDY0NL3fS0AjMTXfNES3ODRAuDpESTVCWg2oKi1LTMCrA50bG1tQDBqVS 3VwAAAA==
X-Change-Id: 20260319-gfp64-7a970a80ba4e
X-Mailer: b4 0.14.3
Message-ID: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
Subject: [PATCH 0/5] mm: Switch gfp_t to unsigned long
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 0A97D18000E
X-Stat-Signature: hat6i4xmenw5d1y3m1mpeni5ze67dsub
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773936500-349530
X-HE-Meta: U2FsdGVkX1+AR6CLsABsJlQHyH2keqV00H0QcPl4kkUkjrUdbSsnEgYOE85HkGJrIKD0QtEZKUPdTJYXTK5eW5U5RZYLfZze3GEDz81gJDDeotZzEBQqbwyB/0aR4Rwg6f+UqqNYH+TqrsNoyB8vigfoaEB7VLqA3OpalgzRWHcxtGU7c+PWi/MONxwmNHerTyN2L8T+XaZgGnhoru6daHJ4m0OmUoT+IUKFGR62ml36IXOsKHwNdm8W3mLjM5fNNTJdyVdO/psezqFIPDS7+1EusEKHLr1ak3t1P/c4oQbY2qdH6JtkQyW4frOvJpXhJFo5wiaKR1V8F08+MplZbJoo88PbzbBcFpXdQuX98XRhTuQaUaRBjFu8w9/ENrAL5xeu8szUDPiPKlYoYZ4z4W3Iw7ZyJS87MSVVaD2tXn++1MdVJLhg/vX78zULYdK03mK9cwS6wxKKNpl4NRG5XDbqfmkEVDll23rDRb4dhLftH7Fo+fwoh0V9cla8wpmGhR8MINgRFBnpVUNj/MsYDv60dEa9V0bKH+wN7kyB1nl296PEoxU0n2V0maKNXhYr7UAxP0EPEn/ankAWZs0FOlV9OVFkDEtsGgAqnrzYRKRFZcYnIgzzD0D+DLSSayq5cr/OVElXc07TtEKN6ECvCoGLNP7CU4qrjDIToHLwZjeubWVpmHFPEzWuw3GnFmSXG9nJZ773fYcwEIBmraT09eUuP4cGPbTfOhpi7bZWDcA/AvgOzz6kHZ1yzMjkP7maim1X9WwUF2rttvhKzT7RNjTZsekYCYOTwGMt+WLUJWs7rWeM7s6Xn9yYTSmnSASzjPj1ppai03BfBjDXmuSIgwEDNmkurL3dAP00AW922zAtayqMWMU9vTDNOFb7frZQs5COlEUNWPDkctNjedykvbBCaXXgFjDs6UZFzAJAsQtgJkddmL3D/yzr/uKuqtOOK3OHwDyUUZ9qay1nVlW
 zvpqGp58
 rz+ueC9cdoeobHuBOkdeuhkBdbfs3jgPlHRWXb2C0Q47jaicrBzW1ON+fpFzAHylW3zJ5g5wsFrQcBitB0nLYbPF47FiAaZcVv/XQ5rbz+9b2HChlhBRqwnYomn4zKUMrA1Ll/lUzkS06QwdFQ4uOV59bUpaLTI2HCPn2JYE4udQHWXP9FOhf5teHSMeaajy4aHAV5PsXO/SMlEQ+pwEi0JBYGCqKArARbw6RY7AcNZsJUL5f3PXtdk8VlI9lmaf7MXbXJ/pAOkpctkz7U5ECxj+T8Xt0Nk68y4gRh9NIIzO9w2rgmleWzfQCM/baXwy7qDe34OoI3OA0B27CnjWDjhkyZXDxkzdEyQ5qvv8pHJ4DHpeAcXlyybVUrLp4EK2yQUFuG6IXnByQ+ZTcHhVBQ//tyW48Ti2/tPcgmgLvnNeKpt1k0HMQZm4ulk6kEzfrKOhpe7FR5S2UbWZ32ewC1tqqs7/ChsBGU1T9RHt8V0hmmXm9E/3wahWtwmIqDFj7+S982YqslDAF+aPoL3QkAvng07wKh48tPHvy3Fq/r4GnFM1JVBPd+1VILTHJrEt/uhpugJ15u9hY0AvjCLbaEqcpCss5dTNrfKltf/nC5cvEiSQhz5qv1oNTGg9GRXYXpJu0G4tkfxRAlRlt+ULSb85j54OACMQlUm2Tardp83bav7x792aeZxJt+cR/3fmoCn8zGo4a7YsXz8Hu7DOufxM54Lw+mCVsvnJ8Fvfd060u9xZuca34JzS9T3rGjWd7bysFMi2N9uEMxxsqggUoqU7fXggeUvThIFgX7yqgI/ha+4g5+UvLHbBNyX2vSzjn60a27Vl5l7yolGZPu2T/bFCTakyrKvNPzGINYYK+ON7Lm081LIYfFwW18WjWkcNM2gm9TK/eTO8TdqrNjpuKZ+yIvL4ymWDyJSAFM7HwfJn58vTNiB7esEJiaUg5eMkIZ9zmBQAQpumZ8zAG3duUDnzE7ZJW
 CMZjn+1O
 ID8+EMkyLy0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As pointed out by Vlastimil in [0], my proposal for __GFP_UNMAPPED is
probably not needed for 32-bit. This offers a way out of the GFP flag
scarcity so in preparation for this, flip gfp_t to be 64-bit on 64-bit
machines, while leaving it 32-bit on 32-bit machines.

For mm-internal code that prints raw GFP flags as hex, this just updates
the format specifier to %lx. Presumably developers have a reason for
wanting to see the whole flags word as a number in the log. For printks
outside of mm/, I assume they are only using %x because the authors
didn't know about %pGg, so they are converted to the latter as prep
patches.

Stuff I've done to try and find issues with this:

- Built x86 allmodconfig and arm64 defconfig. Hopefully the 0-day bot
  will alert me to the important builds I'm missing (I briefly tried to
  build s390 and sparc64 but ran into tooling issues and gave up).

- Ran some selftests on a x86 VM.

- Poked around at stuff that refers to ___GFP_LAST_BIT to see if
  anything looks wrong.

- Ran this Coccinelle script to look for explicit casts to plain int:

---
virtual report

@r@
gfp_t x;
position p;
@@

(
  (unsigned int)x@p
|
  (int)x@p
)

@script:python depends on report@
p << r.p;
@@
msg = "WARNING: Explicit integer cast of gfp_t"
coccilib.report.print_report(p[0], msg)
---

Obviously this series doesn't "do anything" so maybe it doesn't make
sense to merge it unless it goes in alongside __GFP_UNMAPPED, but it
does seem to make sense to review it independently so I'm posting it as
a separate series.

[0] https://lore.kernel.org/all/6206d021-e6c2-4899-b426-cacd71ebd5ef@kernel.org/

To: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
To: David Rientjes <rientjes@google.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: Vlastimil Babka <vbabka@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Brendan Jackman <jackmanb@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
To: Harry Yoo <harry.yoo@oracle.com>
To: Hao Li <hao.li@linux.dev>
To: Christoph Lameter <cl@gentwo.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

Signed-off-by: Brendan Jackman <jackmanb@google.com>

---
Brendan Jackman (5):
      drm/managed: Use special gfp_t format specifier
      iwlegacy: 3945-mac: Use special gfp_t format specifier
      mm/kfence: Use special gfp_t format specifier
      net/rds: Use special gfp_t format specifier
      mm: Change gfp_t to unsigned long

 drivers/gpu/drm/drm_managed.c                  | 4 ++--
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 4 ++--
 include/linux/types.h                          | 2 +-
 lib/test_lockup.c                              | 2 +-
 mm/kfence/kfence_test.c                        | 2 +-
 mm/oom_kill.c                                  | 2 +-
 mm/page_alloc.c                                | 5 ++++-
 mm/page_owner.c                                | 4 ++--
 mm/slab_common.c                               | 2 +-
 mm/slub.c                                      | 2 +-
 mm/vmalloc.c                                   | 2 +-
 net/rds/tcp_recv.c                             | 2 +-
 12 files changed, 18 insertions(+), 15 deletions(-)
---
base-commit: 8a30aeb0d1b4e4aaf7f7bae72f20f2ae75385ccb
change-id: 20260319-gfp64-7a970a80ba4e

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


