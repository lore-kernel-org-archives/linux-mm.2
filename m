Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D24CCD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 14:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2676B0099; Fri, 22 May 2026 10:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A73496B009D; Fri, 22 May 2026 10:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988D66B00A5; Fri, 22 May 2026 10:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8690E6B0099
	for <linux-mm@kvack.org>; Fri, 22 May 2026 10:23:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F7F54024D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:23:41 +0000 (UTC)
X-FDA: 84795274242.10.A937481
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 67C9918000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 14:23:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Grwb9ZZz;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779459819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PA+/blMkYTjQ98chq75R1IGwiAuFCUXm1eh6O/BkY8A=;
	b=pTHARJBdJAp5I1dDk4ca6C3bk2aWxgRxP6Cg5+Hb+B3knhJvQgX3/Dv0yL3wqpyd5BHapo
	kdDTfOLSCLOFV0zD72mXg5zJxTmH36eTgNbLXUwJKCrSBMxChdqkZm+VJO1U1vYDZFVcqk
	TiLiv4Na/7ciYadxlGeLimXvcEn4ivA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Grwb9ZZz;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779459819; a=rsa-sha256;
	cv=none;
	b=HAZy/zaCvd3RpaBzsr54Kfgxf18+qbu1xf8EXarQplfcnaTiRBlQeW3ueyhvD++gwWJJmA
	6tlFQSW3FpxmF3DZGskHt5zQJ17T7+ABH56Zx5oRhPe1WGyH4ZG4T+t3jTnP1q2bgkuflO
	vj5pyoy1/mnnqiOIUmnH/Q9BquvXmr0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB9AF60138;
	Fri, 22 May 2026 14:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB001F000E9;
	Fri, 22 May 2026 14:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779459818;
	bh=PA+/blMkYTjQ98chq75R1IGwiAuFCUXm1eh6O/BkY8A=;
	h=From:Subject:Date:To:Cc;
	b=Grwb9ZZzC4e/MtQ5KbqtrL7rffvSZ8FgEzOZNJRaM/+26381GobXpC6qFcT8H9UmD
	 LLhfw6IlHWSOCatoW0yGg+xsXGEudmXTRw4/9Q628hHL63Yianic89DZoRQI9PXR8I
	 INO8eVku/sJCOHoMQKLyRDySnCDQIW1nHURzAEpqKd8xWAoPDYs45oSjNYgmGVCC/c
	 wSKLgR4hYbQ1MVsepXFqOA3K+vG9LgsX7NYIhz8/2Huu2EvxiXV+vA5zO18HfZA133
	 CXOOcQblQ0UsCxhErnfg64+jTpQqLlJ96R/+sYkHV1EsTqmArqyvU6cmJE3aAJS0vg
	 ZL3yXwNaBKCHQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH v3 0/2] mm, slab: optimize returning objects after a
 partial refill
Date: Fri, 22 May 2026 16:23:19 +0200
Message-Id: <20260522-b4-refill-optimistic-return-v3-0-2ba78ec1c6ed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANdmEGoC/43NQQ7CIBAF0KsY1mLKlJTUlfcwLgqFdrSWBijRN
 L27UDe6MS7/5M/7C/HaofbkuFuI0xE92jGFcr8jqm/GTlNsUyZQQFVwYFRy6rTBYaB2CnhHH1C
 lS5jdSA3nbSkFV4rXJAlTbj42/Xx5Zz/Lq1Yhk7nRp3/rntt8ZLn331JklFHgppBGsUYZc7ppN
 +rhYF1H8lSET0z8xiBhrBLAK9GIGtovbF3XF28IsGcmAQAA
X-Change-ID: 20260421-b4-refill-optimistic-return-f44d3b74cc49
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, hu.shengming@zte.com.cn, 
 Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1925; i=vbabka@kernel.org;
 h=from:subject:message-id; bh=hfAVekw+BItDLJq5R9jvDeugZpHK9EW7c6DISULUHZc=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWQJpN2f1tz61U71Z9+zmAy2DZfLb+7uvO6yxO9Kl/gjF
 oWOdlnJTkZ/FgZGDgZLMUWW6t0nHEVnKntM8/D9CDOIlQlkirRIAwMQsDDw5SbmlRrpGOmZahvq
 GQIZOkYMXJwCMNVcFez/DD84Bom8fhGZ0/Unq/h8iGH5FkFO3mzBvzLcSSlLrvPPFle+fy5aY5q
 T8brcx4tCl/ZVuH+7pZLw7juH2B92ty7T3dqyp2suvv40p19BbEnhjgLePSJzT/hzL1d8bvhm3Y
 4k/k2eXocLlA2+s3Wri0Sknxf9LX3skOXckGsNMmxniyzsXVQ+cgnfT7dYs8w/bPmXD5qMitpXr
 rNdTl631erf2tmXBWTFervOeHNdsJjaN7VzT6+V6Jrf0WuNHYP/ubL6Hruj8jCftfXAL2Xt69J/
 YjJeif248ZS15uJJzp+P30su0VTmygk5c2mWlk3MbYnNu+bx7fg6xXzT1iCv+9v+cHsYcOx0ndS
 Ud/4VAA==
X-Developer-Key: i=vbabka@kernel.org; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Stat-Signature: 9pcbq5i4o8ca9rsohx1qrfssaj5tgnux
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 67C9918000A
X-HE-Tag: 1779459819-550358
X-HE-Meta: U2FsdGVkX18NKvXYCvE0oSmg97NDLvSfPa63P+DrQxmNg9d2/j0mkvX/r9jazK1UYIxANznkoOFm26fTjk3qGqvNF8167XbDyMq4AVU1YrQ1/NtBhtpYI//iT2x8euOZLwYvgtcNnYpaeOUmgYEno9Hpb6kAPhvWXah4TFEnXFlbnjzEH38WOyZeYsin7gek/IcZukDiommoDjflyw4BhcquH9ZwSnhZaFwGVyXVckCacZOliGhhXYLvJ8go8Oke2sPAvjV7ZIk3y3AcqPSBvlJ8EUZNvkeUgBIfWhxEP6jaEkuQa7No9F3Ck5spSvLcrdz6eIWvlAmH5/lzVEBNZIUoRzhYv1bTErs/AREfb5wVuy56xcmDEDeP50Pkm2kScG+P0/aOOD3ByZTMyKWSY4X9jzgHHBnVQRfJ+TAG9H2XC366trgjqh4dFvW/IWqxTiWv4AhnCtgdgoqD2MVp4oAZmKCGerrzPuKRfDBtL86ampFYJqtz7YzVMHfgEoZQasw/SLgCGM0SheyWGKCTmO0gvac9yEXJrZ3YJxPPJyYT4dzVHsWDGZqvbD+y4zD9YpA6DH5CkgbEepwIQVEQ0pQM6ZTxrax3+fwJyP0nDrLEnUFXVlosypU+rdHYzMVTXnWUygaywolIl6Xx59muJxT28ywrJ+jm3sh7RZqkVIrnxyS0T43wksGJzesK7UBOJFFxuxxVT39I2jztli0LC1gW/jSkYSjOj28iFEKr8NYXduJeAkaXog7uWw5F7LHSEqBX/NSCJEiehJJiV9O2LQYVxwb38i2EdcSSTh5LgdoH8hxEOeZesVQ4hcrFPchtCJjLvMuQTm2YinyCvGdXjS5CODM52fOSo2kJqcVNSdVf7kYOX8Ket+dO8Ff4+8liurSki5WWY3z8dVmU9lRjkxG8Dz1UwqjWbS76SHG35W4IhaD5mKfbnA/ZF0lFMpn5TEEdfNiuvZ1JueYLBIz
 oDtwEHSQ
 oQwLHzjRjB1iSesFUyG74CjGRkkftPcw5BtDL5nn8c/HkliLhDl3QDwmyDMEctdKZ/aUuTcwxHJYjFcRehWr7qWtb59BSqqhWLHManjCIeWsVSKciMQ/TCbkwCPKbQjA+lbXUV0MGeN55MBgVCzRPq3I99IJLMuRm0w7oBV+aIXflIZCdXzqnsTuBdc4zZR+u1fl+lb1ii/qGYZxdfZkYqt+w9ZLDnr9jZmHzdTchrnZkbqDQYp2Ngs7MMQPlIdDGCEFCeBdhlIBDG9n4jX6L7l6DsviGu+uSBmLL79xX+Nu88ozQ6gbQZ5FQOw++swpk+Y8v/9cI6/wjO8K5indCpVTQnYvPTG0VzCP+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Optimizes the current refill leftover handling in a way that should have
no downsides, so we have a better baseline for any further changes (e.g.
spilling or caching the leftover) that involve some tradeoffs.

It's based on slab/for-7.2/perf without the previous version of the
first patch. Sending a new version due to accumulated fixups to the
first patch that resolve a perf regression, and a new cleanup patch on
top.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Changes in v3:
- Fixup patch 1 to resolve lkp regression https://lore.kernel.org/all/202605112204.9382cecf-lkp@intel.com/
  - Return slabs to tail of the partial list - this resolved the
    regression.
  - Remove an unlikely() - this had no effect but it's factually
    correct.
- Add patch 2 wich further changes created by trying to resolve the
  regression. Those had no effect but still makes sense as a code
  simplification.
- Link to v2: https://patch.msgid.link/20260427-b4-refill-optimistic-return-v2-1-1672467a792d@kernel.org

Changes in v2:
- rebase to slab/for-7.2/perf, drop RFC
- simplify to reuse the existing reattaching to partial list (Hao Li)
- Add R-b from Hao Li, thanks!
- drop the stat items - they serverd to verify the optimistic path was
  succeeding, but are too detailed for mainline
- Link to v1: https://patch.msgid.link/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org

---
Vlastimil Babka (SUSE) (2):
      mm, slab: add an optimistic __slab_try_return_freelist()
      mm, slab: simplify returning slab in __refill_objects_node()

 mm/slub.c | 69 ++++++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 48 insertions(+), 21 deletions(-)
---
base-commit: dc795d4c0282a4fbfbcd76a70c09ca0888678443
change-id: 20260421-b4-refill-optimistic-return-f44d3b74cc49

Best regards,
--  
Vlastimil Babka (SUSE) <vbabka@kernel.org>


