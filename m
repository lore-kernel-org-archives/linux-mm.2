Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92CF0C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 07:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 482FF6B0088; Mon, 28 Sep 2026 03:07:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433E06B008A; Mon, 28 Sep 2026 03:07:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321C86B008C; Mon, 28 Sep 2026 03:07:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 072A96B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:07:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7FAE81A0B46
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:07:44 +0000 (UTC)
X-FDA: 85262290848.12.1DB42C6
Received: from mail-qk2-f38.google.com (mail-qk2-f38.google.com [74.125.230.230])
	by imf16.hostedemail.com (Postfix) with ESMTP id ACAF7180003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:07:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cMzAjSV1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.230 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790579262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=I+r4UsyqICfyWYrYGf3Z5Y+xllxggueQsNYbHXj5tk8=;
	b=eTaGI4WD0m0idBED96JPZy07yUbUem++rjG1s/lStrHZv1L9mFirKzUR3HF+k3i9Rv7KLs
	SEmOpfX/Bgfl9badPAw8tjPgHWEOmgwX/xDZaGP58ZdaYdnhS/1NOUxh89jLVmFnXd6XK9
	N/hqt+T1puiI7ZVCReIxexRYK5E8454=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cMzAjSV1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of rockeet@gmail.com designates 74.125.230.230 as permitted sender) smtp.mailfrom=rockeet@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790579262;
	b=ujGZoBFgruGldTzeNfev3ef3Zen8xbeWbxgopKmCFIynsaAXBQ7C5Kr0L8ygxD6MgTKy0A
	opNDAdTB+R5n+hIdgiTj7oAzjnNAf/xq1NHv5EGz2/QBMVXzhpEGii8bs/LM9pbwIr8FeI
	JxQA3fnKXNlclKx4H/wQmuCnsQ1GSIk=
Received: by mail-qk2-f38.google.com with SMTP id d75a77b69052e-5333729ca3dso13706011cf.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 00:07:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790579262; cv=none;
        d=google.com; s=arc-20260327;
        b=ogdnEMEtwX0jVmmeWSzQbXU7ZBc39M411Qf0DHLep9RycUzT1j/E1fZWCraFWv0Wkt
         3lEb4lKJAOw1dXAKxnUaAKJN8Uk9EuxPD0Qb5lw9DYsm6yeQvwkv1A5nLCzW40FXL5qW
         1PaZxNLTR0Y1IvTu7Dq2GCcLvw4wfOfyeCzAUbDQ249skRYMBytcyjcUNDczlyYdIAyC
         EtCR5Gzh7m4lr/HFZfqJQ5OY/vwf8R6v5WgLJSE4ZNIeeA7VHkRiGIvU65vgVATFHjF8
         D/CnXlUXBuuRWXntSuaY4K/wL5CTV/kbtajxv0qf54mYwsrqNR0ZxMreAdr0k+q9ZEQ0
         Pw+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=I+r4UsyqICfyWYrYGf3Z5Y+xllxggueQsNYbHXj5tk8=;
        fh=vLbkg4fLvTEQqhJk+PrLrfBdso3R2OEKAAZ6Ojs3pMI=;
        b=Al8klPrkvBhdl6mqgg49K43RqblqOELuyULJ426wTw+X7F/Us0VhFFGBdUfP6fjS6k
         HZz8uiFOw18XgSGFd4/KfpsI+3Viz8c5+pyQHO4WhtaB1ukZXeiVXN2W1bdpxQmhfLWA
         jHQWypm/fMDPCImvBwFedp5ZpIM9jkdPz/+/TzK/TCHpzHoet0lJEEHF2WEo4jtyo55g
         +c8+NOBXZbystQ1RWzGVmZnwCoiZJQI8pAv0Syxt/yFvclKUaY1WsDJX25WEoc8r1pGf
         i4QnparxKmh8BSg1elgCm/9W+i6proPul+Nc2Q+w4ZBiI1ZuyKfXaoy8d9W9PZpVbn5M
         EM4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790579262; x=1791184062; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I+r4UsyqICfyWYrYGf3Z5Y+xllxggueQsNYbHXj5tk8=;
        b=cMzAjSV1Sz9VJ3XwRpYs3yjMIY2vgPw6C8sNrChJ3fFK6kfFOCCuknLpwU6wMv4mhR
         005UNNK/9E4ZSHd7UwhTM1LdIp5vupK8OPc4RJ7EIHE97vluy3GbbvNkN04bv7BgxWqi
         vNFj4IMemwYwTJl/n40TQKBOt5qJ7WGhTlKNV5MmobNJ8Bd6Muu3wpS/3nmCjMW63HG3
         avcbbCVJlXx2oF0SOM8BJW+gxf7zPIeUDS8i878FgHo2DvWkTJ2TMQfM1PExNnCPifd6
         U/dt80cUJKv4xAYVnFSJyQJrQuGj6gLMh9MbJRhusLmuhlxCN5HNpT17c6I9occENq2v
         lUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790579262; x=1791184062;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=I+r4UsyqICfyWYrYGf3Z5Y+xllxggueQsNYbHXj5tk8=;
        b=QAdVpKxkZyBNKcwyso8xXi55flEKGbUoQgEzF4xCPb1K/kFx24H81/PxScNGcEYYtS
         PUUmYYLlOAn/tWWbSwdUs+Gxdiq6H2Rg3ms7slfOvfKX+y2gr00GwuyxdGXulKoyQ6je
         7DMQlew9TrZ1klU6a3in1zUnBgoYliKT9s4MaImYozVPtTxcrCU+H/kBO0xk8dN2Bi/5
         08ZLSJfF1E727p6dcZBk59gohNtUnQKdfc/nPkdbC7SuvNqokPwjumeIpO+emYhVvVWQ
         Kf4YuWh5p9cl3UykVHB10yUfnFbynxuA83az4odmV1a8EPdLiWPnQTAcl1gRXYS+aYQO
         z+/w==
X-Gm-Message-State: AFuF++lxFaYfgSFYX/5oBHyYaandKDxxLaq3Qcj6eR0HyHJU+U6fF6yy
	j3Ubu5UiX/EYVqxHAkKNk688dJyBx34BsaojLEi42Fz29IS5mhJ5pYudYnT+DLXV9SRdCSzhisw
	iuRqTyZKBZPNfZQe5CRDlowWbMR3K/6M0mlF/
X-Gm-Gg: AYBFou3HnFJmpYI74IAVJHWIwAfWAIcQmZkz5EdAk5PWuDmRZU9Vb0kpr1XOxg7piMT
	lpt7sOwkcBa1v1jU1moXPnF+YDSv2E3RR/qxoHfND6egRZ4V255zMFD+F/7WngD3iK8SfP+dS3/
	A/j4SWmgQOTP+GTby1HS7Sjhnj4/50pArYj7cQoZ5oZCq/Dx/XtboyWdYopPeOvOpjxvRqbRaHT
	mZXKiIiVUiT+5QcuPYaQe2JqWx158EwT4z/osoEj+DYtPdB5RYKorhXxyxjfrSmcEMTPYsrO8KP
	TrEwE/tSuocUENq4ncWWgwWbokdxLO6uxZ4/SDp3801OCBLBtAiNntw4shuWYoAY+4rkXZxlNKw
	cjPH+YpVNd45yGU3496N0PfTABnYxGRUtqZXp
X-Received: by 2002:ac8:5984:0:b0:533:3f82:3b80 with SMTP id
 d75a77b69052e-5333f82434dmr56559711cf.39.1790579261761; Mon, 28 Sep 2026
 00:07:41 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?5aSp54u8?= <rockeet@gmail.com>
Date: Mon, 28 Sep 2026 15:07:30 +0800
X-Gm-Features: AclHuK-URrHmhApGmTC_eE0sCs90t8I1v1YfjciG5WiKRhbdAvEXlzFVRK9XjuU
Message-ID: <CAAE3jtcL_CZJdcattCwe0RraKnHcZO=UknxEUQVG858ouZCUQA@mail.gmail.com>
Subject: [RFC] madvise: best-effort deferred writeback for shared file mappings
To: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: ACAF7180003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: jn7dqyyzasbktnfkqgzxryc3a36qodgb
X-HE-Tag: 1790579262-524385
X-HE-Meta: U2FsdGVkX1/+UZMqEMOiQeX3y6XKxD0H9JLiV2Y6iYdHy+5jxuLFTB59hHUiQbGfjyZ/P4uo3aF7xpYY1k8pbBOnqTifGb4ZqzX+08Sr2vQXz5KoyHe2MjFryVpujO6BCEz6OhPhwDRFBTfMeYQdbs/mMr/w1+5xWtt35C8gV0k6JmqR5B6XRUEF8Ks7CODrCxAS5Iji/+lYMd/euOp53nysgkPalx3z2thR2kwRUzlaLVDxlI+jskyFFvsNR/HK7Zci0txFVoOip7yJ2GU1qdIsYEMyT8rriqh3ik1mXFhnFOEhy83j6/MTmcISH1zoXoxVN2k/8YUM3PdOK+Tt3D2ia+yxHpIA/rOQK1Rk0trc62dvGcV9IkJuZVE0Wn33z2tJn4xiDWhZPLYitFhwDP792QVgct3kEvXny8cxFVFEozrSK0XiwnJLTmacXXX+N0vMBfU9riMPwK6Yy4Fu+4OIsjvsSOeRy645/q6E++yl/AHdytBF0JIk0sXWxUTP+SX5q9KCt+Z6EWYZUcWxL8VfxoECg0SkkygQst4y8Ud0l+cCkGRnNtJk1bF19OzMC7aVQe+44oBmPT4BNXTpkmSSxDLYlUZ3B+UXZCFdiNr7FWe5Org8xvMV4IxBAy/vijzHY/k/GFUGhzu7xE3pcLdP6CFYx68JHBcJ7SO6cuQWUzbwyUTkn7GdNd/uF//XBJTgZESygf6d0tTiWVaTEwnzmWBMHV2km9rmdaZEMC/OVnmfAXRXNpe9xw6GLEuw2BHmiawNPJDqQWPakVrRjzYIIXVpicqy7huEUD5iHAB7PjtTjLeBVHPZgWr5ouWqUGSybO6/S6KY231vBj3BXBXGceRCoxS/su1UQ7QVRDMVx4AXlE63k6kMh3TvLerbYw+JbDtqG6i25iKPsZMTvWPXJFfXo8YhZpleEBX/D7hogUdRtnf/nG9FqXC5TiMtfaoOcp/Su47ZZVlJ9ae
 M2+QoXet
 yGCKqOkqb0zRdgidrwhb5Agx2VTV6bPoy+0eujD74gEpKpEPVH/NT32D+aNE2Sgw4qRkEJakwsvvE6aw7Xv6TCRCRqE2r1TKYimAuGrraz91SIbayPCJXnMOzBBMlhLzqZjKZq4H2oL3hqj2jGCJZvbEP4J51QAP4TJfFiNUdLHG6JWm5zA5+Wuk0M93l7EtDMPB/mraoTuPv1WrEfEElTj4uIj78XTyn1xSTo48WVyLyipQx9+OOLhmZeBGuHqM2I1hiDqeA7L5hAtYx3NxndC36MM2+gbIfv7wXQp2QzOOEb+wqgRoE7FYSkRvnvw/Qkc4uEnVQnpd5QsJiGiJgjLoOZUyRSfP/GCSSX4nVDlrLN15GpdVvkAyU183TWB7Oa9u4SabvEr/t3Ep8V5TZlVbBOdsq1EdHQscE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

I would like to request feedback on a mapping-scoped, best-effort hint
to defer background writeback while an application is still constructing
data in a writable MAP_SHARED mapping of a regular disk-backed file.
This is a feature request, not a patch submission or a benchmark report.

Motivation
----------

Consider an application building a large data structure, for example
10 GiB, through multiple passes that repeatedly modify the same pages.
After construction, it persists the file and publishes it for other
processes to mmap and read.

Building directly in MAP_SHARED keeps the data in the file's page cache,
which also serves the consumers. However, background writeback can write
intermediate contents that subsequent construction passes dirty again.
The application knows when construction ends, but cannot express that
knowledge as a mapping-local writeback scheduling hint.

Building in private memory and then doing buffered writes adds a bulk
copy into the file's page cache. Direct I/O does not itself populate that
cache for subsequent file-mapped consumers. A memfd can share the build
buffer, but requires a separate object for persistence and changes the
consumer interface. Global dirty/writeback tuning is broader than this
particular mapping and construction phase.

Proposed interface and behavior
-------------------------------

Tentatively, a pair of madvise operations could express this:

    madvise(addr, len, MADV_DEFER_WRITEBACK);
    /* Construct and repeatedly update the shared file mapping. */
    madvise(addr, len, MADV_ALLOW_WRITEBACK);
    /* Use existing synchronization calls if durability is required. */

The names are placeholders for discussion, not existing constants.

The requested behavior is deliberately advisory:

* Prefer to defer ordinary background writeback for the corresponding
  file pages while the hint is active, including pages faulted in later
  within the advised range.
* The kernel may override or ignore the hint for memory pressure, dirty
  limits, fairness, filesystem constraints, or forward progress. It must
  not reserve or pin memory, exempt pages from dirty accounting, or
  promise that intermediate data will never reach storage.
* Explicit synchronization, including msync(MS_SYNC), fsync, fdatasync,
  syncfs, and sync, retains its existing semantics and must not wait for
  the application to revoke the hint. In-flight I/O need not be canceled.
* Shared-memory visibility, data contents, and existing durability
  guarantees remain unchanged. This is not an atomic publication,
  transaction, or crash-consistency mechanism.
* Revoking the hint restores normal scheduling; it does not itself
  require an immediate writeback or imply durability.

Automatic lifetime cleanup is an important part of the request:

* munmap removes this mapping's hint for the unmapped portion.
* Mapping teardown on process exit, including abnormal termination,
  automatically removes its hints. No application cleanup handler is
  required, and no persistent per-file setting should remain behind.
* Independently advised mappings may refer to the same file pages.
  Removing one mapping must not remove another mapping's own hint.
  Once no applicable hints remain, the pages have normal policy.

An initial scope could be ordinary page-cache-backed regular files with
writable MAP_SHARED mappings. Unsupported mappings could be rejected.
Details such as fork inheritance, VMA splits/merges, mremap, and interaction
with unadvised aliases would need explicit definitions; the lifetime rule
should apply consistently to every mapping that actually owns a hint.

Implementation and evaluation questions
---------------------------------------

Although the proposed API is mapping-scoped, writeback acts on file-cache
folios shared by mappings. An implementation would need an inexpensive
way to connect those scopes and retire the hint without leaving stale
writeback state. This request does not assume that adding a VMA flag
alone is sufficient, or mandate a particular accounting mechanism.

Useful evaluation would compare repeated-update construction with and
without the hint, followed by explicit synchronization and a consumer
mmap/read pass. Metrics should include device bytes written, total time
through final synchronization, dirty throttling, peak memory, and consumer
read I/O. Memory-pressure cases, competing writers, partial unmap, and
process termination should also be covered. There are no measured results
attached to this request; the expected benefit is a hypothesis to test.

Is there an existing per-mapping or per-range mechanism that already
provides this behavior? If not, would a best-effort madvise extension be
an appropriate interface, or would an fd/range advisory API fit the
writeback subsystem better while retaining automatic lifetime cleanup?

Pointers to prior discussions and feedback on whether this is worth
prototyping would be appreciated.

This proposal was developed with AI assistance from an application-use
case discussion; no implementation or performance results are claimed.

Regards,
Peng Lei

