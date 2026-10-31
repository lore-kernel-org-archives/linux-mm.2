Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC7B4606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 10:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=icloud.com header.i=@icloud.com header.a=rsa-sha256 header.s=1a1hai header.b=HqYB3oEY
Received: by kanga.kvack.org (Postfix)
	id B81266B00EF; Sat, 31 Oct 2026 06:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B321A6B05B1; Sat, 31 Oct 2026 06:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A20886B05B2; Sat, 31 Oct 2026 06:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7747A6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 06:35:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D0C640969
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:35:26 +0000 (UTC)
X-FDA: 85382564652.08.23CC761
Received: from outbound.st.icloud.com (st-2006i-snip4-11.eps.apple.com [57.103.76.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1BE341C0004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 10:35:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=HqYB3oEY;
	spf=pass (imf20.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.76.201 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793442924;
	b=DZakvOvFb+zDLE1HofvqSRRYAv506T6NNxtz82JNdmVXJ1HyOEzyrDt5qDXJqWF87DNzo9
	MhUx7Wc/58qTfpzngCQjTKzgwObK6vaPTB/bjfiMpGlmcM6ogvlpcRCINd9Qyj2Fmm598M
	uUAGqYduVQwxL07FKkwquEa3KOvJixQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=HqYB3oEY;
	spf=pass (imf20.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.76.201 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793442924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TF9wjAhk19qujT+sypenru2/VpLrnSRDil9zbXRDolI=;
	b=qAyle+bIxX/ov5sMlv8QmDe4kP1j4+p2gTAZn2zEr5LovEGi3Okkey0fFmFESEua/YY7I3
	j0Cab0IwMX4YlIIh9Q5OjRv58/bT3yWPOPuWJGEOgw7gt2RjKnROnbEZQ87K3ZQW3aFsLL
	H000H+Tw3/3c29ex+BSH0YzTKSHVeGs=
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPS id 836F518002AC;
	Sat, 31 Oct 2026 10:35:18 +0000 (UTC)
X-ICL-RepId: 01a19187-2ffe-7f37-83e6-650ace3cdb46
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQtJCkMGXwFeCEADQwZbC1BcHA4XXhtCFUsVXANcDkswUBtfAkIPHBNWFRMLU1ZbE1UXRgkZCF0dGQpQUAZcEhhcFFxQWB5GElYNXQkZGEZeUBtfAkIPHBNWFRMdQxkPKwhKBEMHRQJeCyUTCVNWWxNVF0YJGQhdHRkVWgkKVwBAC04CXQRaHxJYDFAFGh9eEhQeXxhEAx8GD1UDQAZSAkUKQQteDg5XE3kMVgNUDlwEFxtcAAlLRglJHQ4EVAddBV0=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1793442923; x=1824978923; bh=TF9wjAhk19qujT+sypenru2/VpLrnSRDil9zbXRDolI=; h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:x-icloud-hme; b=HqYB3oEYQlIiyoG6tZT7m4zY4rDz4ZEzfzFbboOdWvf7GInevj4AoiuGX1AqlrQ9naJ3pPGtgtYi9MSD/04HCKfoWWoiRJi+6S9zuEBKeUxonmQSxQJ4ha1X2OoNW8usw0Jnyg3E7ZuPTF/njmG/ghyEPoZ3u2IskaEuf9c3tA1JPe26up2+s9QXwprQLH3gMOqoYFeqfm+VL81W+beUqiEAyER/7iPrhZWZaI6zZ19Ib98Z3o3be3x5csGorM+TOLiKtwr26VLn21GRYCUPHBmHjuSPKT6PTL/OjOe9RVv4untoTeleCCQtUTAC8v903j7W3cGDUa00eJPxmixp0w==
Received: from [192.168.5.15] (unknown [17.156.216.30])
	by p00-icloudmta-asmtp-us-east-1a-60-percent-7 (Postfix) with ESMTPSA id 1E979180028E;
	Sat, 31 Oct 2026 10:35:11 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Subject: [PATCH v6 0/5] mm: batch TLB flushing for dirty folios in vmscan
Date: Sat, 31 Oct 2026 18:35:07 +0800
Message-Id: <20261031-batch-tlb-flush-v6-0-190539839eec@tencent.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3XOzW7DIAzA8VepOJfJYCBhp73HtAMfpkFKmymk0
 aYq7z7aSzaxHv+W/LNvrNCcqbDXw43NtOaSp0sNczywMLjLiXiOtZkEaQDBcu+WMPBl9DyN1zL
 w3mIC0sYra1jd+pwp5a+H+P5Re8hlmebvx4FV3KfPrVVw4OT7RLGLwll6y2GcrvElTGd2x1b5C
 5CmBWQFFCBpiSh1UA2AO6AEtABWICXwNqJDLVwDqB3QUreAqkCPXW+jcT4ANIDegU7+84GuQPR
 WoYMI0fg/wLZtP/31W92zAQAA
X-Change-ID: 20260309-batch-tlb-flush-893f0e56b496
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Authority-Info-Out: v=2.4 cv=aLf9aL9m c=1 sm=1 tr=0 ts=6ae5c469
 cx=c_apl:c_pps:t_out a=oyWFxbOnq+dmhQrAPgaJYA==:117
 a=oyWFxbOnq+dmhQrAPgaJYA==:17 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bC-a23v3AAAA:8 a=v3ZZPjhaAAAA:8 a=VwQbUJbxAAAA:8 a=GvQkQWPkAAAA:8
 a=x62JkHqQUASQIWwaIBUA:9 a=QEXdDO2ut3YA:10 a=FO4_E8m0qiDe52t0p3_H:22
X-Proofpoint-ORIG-GUID: MJG8eOUb2qqdo1XdSKXTDwaXd0_yVlYE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDMxMDA0MiBTYWx0ZWRfX/hNeDvXzs0rC
 tRA9r8J60psOSPuRiKIESZ+yFT5iU4plrz7jlKDYt1lAqYUHgP6LyfqK9ddk5kR5Sl5zfZFM22s
 EQ6XdNFDlg5NS/qhedHGCNKv5WGy6RsG0In172qVyE0M94jbYIV0gJ1YFoOjEsENTjKQ25ZMNzU
 gHJ5YnHKNeqImknme8vcQtG0Ds2L5aye5E2hVgz83RPY71zZOwTz0bPFZOohwcvrUgx0tWybcIy
 2GlEl9+MPYuf+SLuRYFTonWoIXmvIBabvgObvIsoTFIZ3aVKnD2l4K1M2BixqlT+IIso9ZYGhz0
 S/APTJQZOeS+BkcOEtsnTuCM0evP9GIUIaNcRbTt5oSO1oBdkfxeUtY6WHKs9Q=
X-Proofpoint-GUID: MJG8eOUb2qqdo1XdSKXTDwaXd0_yVlYE
X-JNJ: AAAAAAABgGMsqP/5mGRIJkz2S58inUAsI3AyWrVwe8N+RFPHspy383DCUgk+FRFTFWoXuy
 lo3OgNu/KWhQi9Vn9zf+ZN2XyQRhhrY6iAgy3/kPkbNqXR97NTYHyvDMbH4EaWiKeZTLQv
 RVUXE3bn7mt9FNDKSd9hI52uS6ottHMt/XAtz7Sbb0Vp1vhvbB2cG/YimUn72zIsYXtGEG
 zQH1B0HZM/ZBokexrUTk3TKDN3fJDxAZtip9/HHjSpiCXOz/0/n6bYtVWSRIe4HwyEpR/F
 IdZ4HuK4lPE95kTVBpy7UyYsa1TTJ68qFWwWTnk8keC3cFa5qTaBhdbZ43cZD8TiOrg7d7
 GBkK93kgi5KnzPdzFgNyz8MJe/z657dwQ3OLpwame0sRBxNE6+C6BdJ8sgmWiFXpGNL+Yf
 6m5taK94rPk/OIQs7BKcjKFw1CDFSd79PuCc5hEyP4QyZOhNCNt5ZUCN/yVo97dUIiMUNf
 U5VCm92oC/0NGgbcoyfOae6kiwm5uitZNEzJaS0PcQP7ra4U+4imxti0feByUIPIL9ZT6r
 PwIjlGEPja5G9pAuac+kes2DVIMmItXH+jXvU5jt5LGSRcMAASUFj2/TU8Bnszin5DEJTI
 T7HXG92PEtEE5W5OgeOhZALdjHtDZ7c2bGZEVQoCBLOVheavgRbpO+v0tVje4LV29VLwJ6
 o0axOOb7IqTaSBns5cwAB/+TJzGmQU69r0N9XZDcBjpx7kK1I1XLv7CKpyXhR3YDzMOkmL
 87IJJRPTezVRPflTJeGuygneOT9JfLPF50sR3ay1lJW6Gn9bGeJ4GAhOwyJU/RybQYcquV
 q0W7vW/3Xffdz+y8jMQOW+L7snNTjKdEEnSo0rsSgdcyyhleyuR6MhrSarMhbdEPV/zw46
 ms60ePetRW8pxovLU5h7soQfQv964y26yeIelJJ70ogSlMUZaTKUrdL5OnWwKNNjnzYkzP
 Nzd5yuatzirzCCahviXOfKu+/vTVjVhE1UviyWDlWsEWchAEYFI/xzt3Tu9DxXXwewY2cd
 FiE0KczhyOBw1xrqZ4j5gHOTzy+LHYB+1BoOKzpoYJw+OdP8YPMzJbNJUW0Az3869y2yyZ
 8n1ysp55eYGE7Fbg8opkmwLXPqgMkbwe+SMU9lzGVPXGIXuU8ifYcpj+HhkflaquLYIx+o
 iyd0MXBOwqy1oXlMam6LS7LIYQWSsrXXvHnGY8/pbJ9umnImy2U3juRAlgl9HL57S0DXMW
 s8CYU834FtQVEO8jKpgvys71EoDXBDh2+J/Aw6DN6o+kofCquqHOd+n8wlS9ndvBsyNq+z
 dTDdP0bwX8f/ExBNChwzjHqCdUtJTjPMj/v5Tm/huGBiKiY+cMkaXDacZnF6nlBOGcAG3R
 Uj8yIRCpk6negzVZT6jJ/+6mZTGDY218I04nooRq+sZXTOEO5ooHI8lneavdhs5y8nssai
 AgF8SyUZUjQNo=
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BE341C0004
X-Stat-Signature: syjoso69u4cn3db8iesqhjgahkywsikx
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793442923-846991
X-HE-Meta: U2FsdGVkX1+Xg43o1qz2jU6AhTRayReFp231aP5e7V+nNPsH+2uP6Z7cj6WzcZVh35rB7kbzs7GkLN0giE2zHJZcVQStukd8PeEeRlFWP62QIlVoojdp+bjPDfn/ICfxWC526e9WiJ6CBtR9bgFjOf/yq/J/Ykm7lXKQHlfooGbpsGMdrm8llarYVWJFErMHump8FSY+qY0a6u3Xk0Iix+y7sF/uHCB/QTPUHyLwdBVQMPKDDxj8hyCyYmzxfynIhSmmVI9Gxitasdgw7+0XUZd14hUiV5irLwesfboyPLphj53cU97XHx/MbL7at3jm2v2e3/xUS9kqKmT3GDGzFPmd8XBTfIqytDPfBc0vHz3fOYzYtKZ25inNCfGF6hGj+u9SqCpo9dND7rqk59cOdrHbeDzmIdv4QwJd/PIsdpVx47A7RFE8MLLZsmRQ0qDhuhJLAT8ERpKELOe05f7BsW7DiCYsCX2Qf+xilkuGUWW0Xrov0Od9RAMtEfhYHPj7NQUvnwIG3tatvYR8d6WIDoGYamL98wO/cfQ4Q3XWqVtQtya56kwmF0J3n5E22HyQxDaxM46IoYv8M6geFE9ESfAw3+Ux5TgfBbseZTiDYZXO+BZSmK6PXWLOXSLQOLVLJhDhc3GmJ4TWtdEBOOM9+2AUqxa9j+HZlQZy/kVwA34HRqzlqyweRJOALbPeUe3fl1B6fxEwZuA042YpsKvzDiTlRBqYpwc9oQqaIFTxF9QbIp7b9uinszaFKz/b0YQExbbDp21MXb5C4yHe+lGc80x2xTvVP1sPITGLYjOIQOVt0PJMmL3y/20NXwAvpByM3UKT36zAf5rbSaFBsyGH1OURH27mV+ip+zoNXkgUSX3hQJCMtnJwIeUj4CcQn1sw529bUDtafrHcdVYBiKowKeq78J2rKvLG62GXU2ZiuwAKaNEqrc5cWl8KzF6QxnHSjsIvTq0xv1F9bmy6FJI
 xEbAs9x7
 osg7HsJzi8tf/Jnq0uJ5XkmYX5yL8ke7yQRM2n8x8TqlQBE87dpeJpBiVpJFjyxV3X4ccEcUdXT4FkOc2Yv+UFeFGaPnYc+DMe9gK00OBb2yQg+IeCSufpcr24xUsBA+VG5fXHvi+FDe1/s1PTQmnuLgANfmgPyj2jnyTF0gMzLIED4iIo0Isbwd5e2icRN8nS8oIKwL8vwbgEVo9zIGVqDMS4RW2sNz8K80/8S13U5IQC7EOt5KR3nffMAyzuKVK+BW2uWLFG24yl78CZpO0yf3rhwqaM29xtb/dOMguKGFgfYMe+FvntDr5YmDT21DPHRBjmMm3nn7Wtwo0Mx8vnDW3pOWp/HiF41n6jclYDNuDd7GdOnvD3mkeU0uYQ3+7R6fgvvvRyuUpjzRSyZ16MvrRD7OYdrbYqsAW4l3unRYPkOW9nIScDjadTnEW31IzcVjN5sPSfa4zjNaZhJnvbka+lQL1xaY+yPLMKbhoP7R5iQbyj25z0gViqXAldvoYIEni
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series introduces batch TLB flushing optimization for dirty folios
during memory reclaim, aiming to reduce IPI overhead on multi-core systems.

Background
----------
Reclaim calls try_to_unmap_flush_dirty() before writing out each dirty
folio. When writable TLB entries are pending, this triggers a flush.
On systems that use IPIs for TLB shootdowns, frequent flushes can add
significant overhead.

Approach
--------
Collect dirty folios into a folio_batch, releasing their locks while
collecting the batch so swap faults can progress. Before writeout, try
locking each folio again and recheck writeback, mappings and DMA pins.
Keep eligible folios locked, flush pending writable TLB entries once,
then page them out. Process a final partial batch at the end of the scan.

Changes
-------
Patch 1: Extract the folio activation block at activate_locked into
         folio_activate_locked().
Patch 2: Extract the folio-freeing path (buffer release, lazyfree,
         __remove_mapping, folio_batch drain) into folio_try_reclaim_free().
         Group retained folios, deferred frees and the reclaimed count
         in reclaim_folio_state, local to each shrink_folio_list() call.
Patch 3: Extract the pageout() dispatch state machine into folio_try_pageout().
Patch 4: Extract the TTU setup and try_to_unmap() block into folio_try_unmap().
Patch 5: Implement batch TLB flushing logic. Dirty folios are accumulated in
         batches and a single TLB flush is performed for each batch before
         calling pageout.

Testing
-------
The benchmark script uses stress-ng to compare TLB shootdown behavior before and
after this patch. It constrains a stress-ng workload via memcg to force reclaim
through shrink_folio_list(), reporting TLB shootdowns and IPIs.

Core benchmark command: stress-ng --vm 16 --vm-bytes 2G --vm-keep --timeout 60

==========================================================================
                 batch_dirty_tlb_flush Benchmark Results
==========================================================================
  Kernel: 7.0.0-rc1+   CPUs: 16
  MemTotal: 31834M   SwapTotal: 8191M
  memcg limit: 512M   alloc: 2G   workers: 16   duration: 60s
--------------------------------------------------------------------------
Metric                 Before        After             Delta (abs / %)
--------------------------------------------------------------------------
bogo ops/s             28238.63      35833.97          +7595.34 (+26.9%)
TLB shootdowns         55428953      17621697          -37807256 (-68.2%)
Function call IPIs     34073695      14498768          -19574927 (-57.4%)
pgscan_anon (pages)    52856224      60252894          7396670 (+14.0%)
pgsteal_anon (pages)   29004962      34054753          5049791 (+17.4%)
--------------------------------------------------------------------------

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
Changes in v6:
- Keep the four preparatory patches and the batching patch in one series,
  as requested by Barry.
- Patch 1: Clarify the folio_activate_locked() comment and retain Barry's
  Reviewed-by. Document the BUG-to-WARN change in the commit message.
- Patch 2: Return KEEP, ACTIVATE or DONE explicitly, leaving activation
  visible in the caller as requested by Barry. Group retained folios,
  deferred frees and the reclaimed count in reclaim_folio_state.
- Patch 3: Return explicit pageout outcomes, including separate locked
  and unlocked keep results. Leave activation and the subsequent reclaim
  attempt in the caller. Document lock and ownership contracts and make
  the mapping pointer and saved page count const.
- Patch 4: Retain Barry's Reviewed-by.
- Patch 5: Use the explicit helper results and reclaim_folio_state,
  reducing the batch helper from eight arguments to six in response to
  David's suggestion.
- Patch 5: Replace v5's temporary pointer array with batch reuse. Save
  the original count, reinitialize the batch, and use folio_batch_add()
  to collect folios that pass validation. Document that reinitialization
  preserves the array and additions cannot overwrite unread entries.
- Patch 5: Explain the writeback, mapping and DMA-pin rechecks, including
  why the folio lock alone does not exclude GUP. Rename the batch and
  helper around pageout and remove the redundant next label.
- Link to v5:
  https://patch.msgid.link/20260720-batch-tlb-flush-v5-0-db943a0d0d6b@icloud.com

Changes in v5 (addressing David Hildenbrand's review on v4):
- Patch 1: Drop the nr_pages parameter; use folio_nr_pages() inside
  folio_activate_locked(). Add VM_WARN_ON_ONCE_FOLIO(!folio_test_locked)
  at the top of the function. Turn the VM_BUG_ON_FOLIO(folio_test_active)
  into VM_WARN_ON_ONCE_FOLIO and move it to the top.
- Patch 2: Rename folio_free() to folio_try_reclaim_free() to make the
  reclaim-specific role clear and justify the bool return. Make nr_pages
  const. Add VM_WARN_ON_ONCE_FOLIO(folio_ref_count, folio) at the free_it:
  label. Drop the now-redundant "swapped out as a whole" comment and the
  "else continue" after goto keep_locked.
- Patch 3: Rename pageout_one() to folio_try_pageout() for consistency
  with the other helpers. Fix continuation-line alignment.
- Patch 4: Fix continuation-line alignment.
- Patch 5: Replace the in-place folio_batch_reinit() + walk pattern
  with a plain local array; @fbatch is now only read during the walk
  and cleared once afterwards, so its invariant is never temporarily
  broken. Add a comment documenting why each recheck (writeback, mapped,
  dma_pinned) is required.
- Link to v4: https://lore.kernel.org/r/20260525-batch-tlb-flush-v4-0-83789d6abc00@icloud.com

Changes in v4 (addressing Barry Song's review on v3):
- Drop the "track reclaimed pages in reclaim_stat" patch; keep
  shrink_folio_list() returning nr_reclaimed directly. Avoids touching
  the function signature and its MGLRU evict_folios() and
  reclaim_clean_pages_from_list() callers in this series.
- Rename folio_active_bounce() to folio_activate_locked(). The new name
  reflects the precondition (the folio is locked) that callers care about.
- Split the folio_free()/pageout_one() extraction into two patches;
  make pageout_one() return bool so shrink_folio_list() can see whether
  the folio was reclaimed or kept.
- Move the !folio_mapped() check out of folio_try_unmap() into the
  caller, so folio_try_unmap() is only invoked for mapped folios.
- Link to v3: https://lore.kernel.org/r/20260410-batch-tlb-flush-v3-0-ff0b9d3a351a@icloud.com

Changes in v3:
- Patch 5: Replace folio_test_lru() condition check with
  VM_WARN_ON_FOLIO assertion, as PG_lru should never be set for
  isolated folios
- Patch 5: Add comment explaining folio_batch reuse-in-place
  technique in pageout_batch()
- Patch 5: Rewrite comment above folio_unlock() to explain why the
  folio is unlocked while batching
- Link to v2: https://lore.kernel.org/r/20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com

Changes in v2:
- Fix incorrect comment about page_ref_freeze
- Add folio_maybe_dma_pinned() check in pageout_batch()
- Link to v1: https://lore.kernel.org/r/20260309-batch-tlb-flush-v1-0-eb8fed7d1a9e@icloud.com

---
Zhang Peng (5):
      mm/vmscan: introduce folio_activate_locked() helper
      mm/vmscan: extract folio reclaim freeing from shrink_folio_list()
      mm/vmscan: extract folio pageout from shrink_folio_list()
      mm/vmscan: extract folio unmap logic into folio_try_unmap()
      mm/vmscan: batch dirty TLB flushes before pageout

 mm/vmscan.c | 510 +++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 335 insertions(+), 175 deletions(-)
---
base-commit: 9c449f885765cf8d80b2c60b1971e774bba51a3f
change-id: 20260309-batch-tlb-flush-893f0e56b496

Best regards,
-- 
Zhang Peng <bruzzhang@tencent.com>


