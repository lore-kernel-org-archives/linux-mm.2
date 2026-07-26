Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3ED2C531D0
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 01:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44CA76B007B; Sat, 25 Jul 2026 21:29:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FCD56B0088; Sat, 25 Jul 2026 21:29:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313726B008A; Sat, 25 Jul 2026 21:29:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8DB26B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:29:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5693D1A042E
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:29:55 +0000 (UTC)
X-FDA: 85029196350.27.8C1BCD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BF75A40002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 01:29:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dHNgdxP2;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785029393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O9tElxXqoXPZ1eIrYOOiaQHWsLrWbEbHR+ywtN4lvFs=;
	b=WDPuVehOmAx91pDK/JiInD4TAeVx0/geW3h9jSWpgTjz0SMSSII51hmWxl1YYGGuWPLZ7K
	SALPxMmE4RyJeJMw25nbSS8w33JVeqCQofOKDtA9ssTILwbxpc3hcmqNtayFCvnlw0DnMp
	xT/OaoDP2VgZG+s0fqAnq3TWYPOrtVQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dHNgdxP2;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785029393;
	b=b5xiTyth9h3ziWzAfjYYXyXMQKuwW4vIb6z9jL7175Sd3MbXIv/oi4pFPiVw1MWDiKbjw6
	2dPraj4LRiadDtFJ1Uq5Qtwzvjt57ZUEt7/uD7IkZ5gJqKNZRZuGp4954L6JqKpCzaoy/u
	vP6Bt4sbiUrEXtQSRZ8TbHW083NralA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA7F3439FF;
	Sun, 26 Jul 2026 01:29:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063011F000E9;
	Sun, 26 Jul 2026 01:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785029392;
	bh=O9tElxXqoXPZ1eIrYOOiaQHWsLrWbEbHR+ywtN4lvFs=;
	h=From:To:Cc:Subject:Date;
	b=dHNgdxP2I0ZswobmOIljQLxhmqG4928d1j9qeY00/7PHWy4bhIWrDfaGF8iTpWCEI
	 gQpC6uqinbbkqeqEv8aciM7NboEQbtBJNgnjxOML7RE1bqFsjCmXgox208txo28dKc
	 VnSaOvHpg4CqhGOIJQBcnql9ck00zS8YiHEoopSEpbXU+lnj9P6SRYcixQ0BhW0UG2
	 fRTen0JMHFYoFyR1qN9kQks5h57eKHZZwlOAcVUxbfT+uMjYxDaWnvkd2yzfhbq6kW
	 5k1dqo2UaCZhK0RkMgcaLraTuB1X0jaFasYX0lJv8xokz1XIxrrsBfNafOQyrnSysh
	 yurfYBY4DKfpg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-kernel@vger.kernel.org,
	lyugaofei@xiaomi.com,
	stevensd@chromium.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 0/4] mm: mglru: fix swappiness behavior
Date: Sun, 26 Jul 2026 09:29:42 +0800
Message-Id: <20260726012946.18684-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BF75A40002
X-Stat-Signature: mp76sxqm1hj3q8gughkg3ybkkf5nc8xd
X-HE-Tag: 1785029393-682514
X-HE-Meta: U2FsdGVkX18jOKiQdAwMNI/3r8wk88i2Gj2c/6/WclmfkDoD6rnkG2Ft8hOH1cnNUP5hUvtTCR2K3EwHDM0pQMq1TgBjiGCLcveMfmSn2JLAXDp3Otpixs3cWXzGZ0/iyjuEP66ozo98Xl7YlH40UxbP+tOHWJX2HKabPEju412fYLoBKVxgHMcEU1tbXHB/C7BvVAO1bTu3BFW+8fRrX7ovrQRr74KFrJ0tLUkUdPEbxIOmba5XYZLCD4SerXxYcnjLC/6cixkem0IMLPZ4UwzRKdN8fd2qFCYUv7i0X4tJSFyTCdLW13imKc735IWWrY8XvdQTkOcl4AupK/UakAMFBl3J731kK65Zly4Uu5fFkjTvoPeO4SPWIK2ywXuOHbCh7ZpVOlB/spGWzXVfX/PzTXLNWlMZ4+PdGIEBqCls6XwC9/cIlLsw37VBnr3ZIQ9c4DYGq/NbKIXE3KsRSkMf5LsJBTPVTSh8TObbfNNlTHe5nV7oJfwLsYnV2G3yub9PVmsGhW8VWQoz+iy2QFLE3oJgdXJRKD2Te/UxSyZfcreGiWFz7TZImgVAwL3Zb28wiN7QexfKIOiIYLrsB6e3q1XoZKlfLP6pHM7VeIpheAlI8b8P6J0/QB91k3ot/9xUt7xQdIO+bW/1YPs/daCPFFWH+Ul7/9PwT7X7OvWIcYTxSndN3eu/91q8rj6pQ9zU5anc3gARoJt5vbzV5G0VgTH2cTEUi0JlWjwiSj164KHTbtp58kTYeNxLVFXf9hfeVTQ7c13RhmqT5LtorSwSQGLb9coDB2yslgYorlUpIw+mBPN4sWsnvpZiGraMbQUiAmNbRb5NuQTROv1xRaE+2B07yB6bSkA3UJBpro1tzwU8GsVr1SCwa7ObBqGLP+Fb7Dq2OcVveNkPleNVvh9beMS6pyV4nW3N44Jf81xvGBCHI3GfimsR9MvmerJ6JFkqgWMOhG+kNdApYOD
 3WIn0EDP
 lUktunzwb+X0QkOFHObfmpXigHPHNG6dDHr4V5Y0f5hb9uWYY57URuEGVLpvJQs2WreiwXQa1Z7gYvNTrQJu+mqRaZ2HvlcVTIZ2ci+MxxSfnv86u19kHiOkfDHkDa/d1X4jIRySKZjiB+i5FJBrsRyt1bzIftWYIjx/EEiWBpk43ZDAjj7Ed1lJeyUfmZEXMCXaFpPtvqTjVOoumDj22E+3KeWR69ypOyEVWR4+Ck98MidlX5bdgIOsM9yp894iUmLznDRTLNRaKEAeaZZyCPtIn88r15VbmV6GnpZCYKFmU3yQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The active/inactive LRU respects swappiness well. Anonymous page
scanning and reclamation increase roughly linearly with
swappiness, while file page scanning and reclamation decrease
accordingly.
For example, when swappiness reaches 200, both pgsteal_file and
pgscan_file drop to zero while building the kernel in a 1 GB
memcg. In contrast, MGLRU shows almost no change across different
swappiness values.

                   pgsteal_file

Swappiness    LRU         MGLRU
--------------------------------
1             10567455      763612
36              990706      480205
71              688170      415848
106             446294      386164
141             286307      359196
176             201733      351686
200                  0      330093


                   pgsteal_anon

Swappiness    LRU         MGLRU
--------------------------------
1              4410548     2726362
36             2465268     2762859
71             2677908     2885124
106            2737227     2841796
141            2984276     3035015
176            3381338     2938302
200           13116359     3113499


                   pgscan_file

Swappiness    LRU         MGLRU
--------------------------------
1             17997223      923094
36             1325674      539571
71              852345      464222
106             538207      464477
141             357253      412277
176             217536      399446
200                  0      375902


                   pgscan_anon

Swappiness    LRU         MGLRU
--------------------------------
1             31639423     5987136
36            23441521     5753224
71            26067110     6101780
106           25619448     5782919
141           26842088     6234264
176           29200021     5980292
200           62193924     6413125

This patchset respects the type selected by positive_ctrl_err(),
which uses swappiness as its gain. It does so by:

1. Avoiding premature fallback to the other type. Only fall back
   when reclaim is running at high priority.

2. Running aging when the preferred type has few or no
   reclaimable folios, so more folios of that type become
   reclaimable.

With this patchset, swappiness starts to behave similarly to the
active/inactive LRU.

                         pgsteal_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             10567455      763612        3507619
36              990706      480205         528781
71              688170      415848         478478
106             446294      386164         411632
141             286307      359196         375137
176             201733      351686         298586
200                  0      330093              0


                         pgsteal_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1              4410548     2726362        2876888
36             2465268     2762859        3022062
71             2677908     2885124        3129555
106            2737227     2841796        2974192
141            2984276     3035015        3092280
176            3381338     2938302        3353395
200           13116359     3113499       14348518


                         pgscan_file

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             17997223      923094        5842416
36             1325674      539571         648111
71              852345      464222         569930
106             538207      464477         480767
141             357253      412277         431911
176             217536      399446         337768
200                  0      375902              0


                         pgscan_anon

Swappiness      LRU        MGLRU      MGLRU+Patch
-------------------------------------------------
1             31639423     5987136        4658593
36            23441521     5753224        5444726
71            26067110     6101780        5755804
106           25619448     5782919        5872415
141           26842088     6234264        6144096
176           29200021     5980292        6615500
200           62193924     6413125       22984986

Another possible approach is to decouple anonymous and file-backed
aging by maintaining separate max_seq values for each type. This
allows anonymous and file-backed memory to age and be reclaimed
independently, enabling the swappiness-preferred type to be reclaimed
more aggressively while allowing the other type to lag behind. This
approach has already been adopted by projects such as CachyOS [1] and
Chromium [2].

However, this approach requires substantial changes to MGLRU and
fundamentally alters its design by breaking the shared aging timeline
between anonymous and file-backed memory. This timeline is the
foundation for mechanisms such as the PID controller and the
min_ttl_ms thrashing protection.

That is why this patchset aims to fix the swappiness behavior
without fundamentally changing MGLRU's design, with minimal changes.

[1] https://github.com/firelzrd/re-swappiness
[2] https://chromium.googlesource.com/chromiumos/third_party/kernel/+log/929932351492d01f0aee37a0ac3be8c7bd88f80d

Barry Song (Xiaomi) (3):
  mm: mglru: only fall back when reclaim is running at high priority
  mm: mglru: do try_to_inc_min_seq if scanned==0
  mm: mglru: run aging if the preferred type has no folios in
    reclaimable gens

lyugaofei (1):
  mm: mglru: run aging when pages are severely imbalanced across gens

 mm/vmscan.c | 46 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

-- 
2.39.3 (Apple Git-146)


