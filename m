Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D97CE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 02:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6D458E0006; Mon, 17 Nov 2025 21:08:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E138E0002; Mon, 17 Nov 2025 21:08:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90D138E0006; Mon, 17 Nov 2025 21:08:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79B8E8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:08:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B3B2C0320
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:08:28 +0000 (UTC)
X-FDA: 84122093496.18.1A5878A
Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	by imf01.hostedemail.com (Postfix) with ESMTP id 51F9B40009
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:08:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=G4V+koqE;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf01.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.252 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763431706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tquW+VVde6gvKkA0FAYyMhS9e7bJNzAzEzLm9Bg7uxA=;
	b=Rb1pJUjFK4eTMHOc//rn+PCJwezT2B1Zqy+jKhpvMGKADXWCFxWSyV7VdlhGrQp9W3tnx4
	weWhrsp+f7Ml2JPoQqh5RNPIXH8EL/KETrQaIvyaiYUR+2K3cV28KbTi8z9So/Iu6VXurW
	tZpnWgI8xwJE8JCe/w8acCDRxz1CL9Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763431706; a=rsa-sha256;
	cv=none;
	b=8PLpPpUHt39jCCxjQ2WycuO/+MTXvS9RD8sZm7Hve0Bs4rBjab2gwov82m7g9EhfK5fN1h
	1avWh+gr10oyWAItHUGvv7s+EH1FbYTaZv88fh1ZM8BuhLmiTC3wmMvFn7IdjPNSUAaDj/
	2KvOu7LL3nT4cHg+eq45Eh8R+lEIHSc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=G4V+koqE;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf01.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.252 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763431699;
	bh=tquW+VVde6gvKkA0FAYyMhS9e7bJNzAzEzLm9Bg7uxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4V+koqEqCZ86BKR5iEQI28wO1mzk7gV5n/yzoSRsUW3v/3iyUzV897moBGV1ChK4
	 3RDC6fsJPUJMS5k9MYwR+uu2gTVrExvVsQNmHBHpDbH3G47PZXlHW8VRVkM8qD67WM
	 8TDwEdsbaAud/UPiaaeAwQmjuoT5hx5vlPRh+lZw=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.152])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 210A36C0; Tue, 18 Nov 2025 10:08:16 +0800
X-QQ-mid: xmsmtpt1763431696t0p1kel6a
Message-ID: <tencent_547137D7C2F3EDBCD52FB12EE2A202EEE307@qq.com>
X-QQ-XMAILINFO: MZtEYADUG4AgmNtjQgJUQ3DtPLGHhkYi3xEiIs9A3ceN4XrokDbFIxMS7U8Ou8
	 EXwCyPeuqsIfkoi2vMqlSknKrOIw2pCrgG0Bq5WA2hNBLwOT2YSXlmeL5TN21B/SBhgYTfA9JR8H
	 sMKoSAbnQzgo/+4ZMSTRLHMBbHMcNriTdaNeGP3Vq3RUDDxp8I3rgqzbxpN5fKTuEMf/143Ra689
	 obsLBbj+SoMkkuCgS9TKKCnTBd+Mhe6moGG8qTy8SlR/AwENm8oZpyVqpz8qSWF9aWF7HlQFFhxp
	 UdBhbGhrouHxhEYpunSblA0pV0X2iL6fPLNB0qccEaYw4tiJ57SWP7C7oKYVZ/Le1nJGUuG2NbUO
	 C24/u+PgDpdT4omNmFB853gPUXFIuTsnhky6g9GIWIuwrFJbeRAHwPVS8gs3RUHNkUDYIl0uDi/a
	 T1PxSm7lAotxSBLHEj8SHnVVbLGlvMsa3PwzOJxawQtreC+u1+jwfxDmmBOkMd/kuez7E9w6YtzG
	 veRvAQM6C7k82XeU5ehPcFdMZO3eAA+qJzkl8l6xrnU3o7hsRwazXBYNFsEPMSA2vDiSXXxnvPpu
	 SJVEBPpnOgXy19OfG//EhGodDU0qFLBEa0/6pKCZlOGr+1lNpSFMfKzdk7G+NE3afTZ6vpZUNc+Z
	 YizBBaOtHdQr7YAe/+bGqERTZNhmh5F3jVxpEYna8G/WZn3Zu6s6l+ttVD8JjZ2d5u+1Lvw4W5qC
	 EIqjKZ9ZHLu3KNzCit4DJYixlhBJbYRDhjKNeJxLNrGKTghTLco3gIOiOEZJv9wr+jMGjc+Rqx5g
	 CCBpze9rzqPp1ULpXexRAhF+XrUVjJab0TWiBJgZvXypYSsXY9E5gIkWDPzlQfR5H/Cvj1Bv9FxB
	 Qbf9vDJhO3/V0KfUOICYp6F8hsqt1jnaJXyb+uMhvQjymqmSkjoa1L7ueBPTF0CINnqISoGokLqk
	 GCHRPuozEK++C5EjPMuppMgRIIr4j87LBOoBsOnHmhM7KoJEmkLUmOA0ih7hPdBkqvLbVMw406DI
	 iF+IUu9zmlXgaTs9ehfVcq7e2q7gNrPeuEQRAR9A==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: bgeffon@google.com
Cc: akpm@linux-foundation.org,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	senozhatsky@chromium.org,
	ywen.chen@foxmail.com
Subject: Re: [PATCHv3 1/4] zram: introduce writeback bio batching support
Date: Tue, 18 Nov 2025 10:08:16 +0800
X-OQ-MSGID: <20251118020816.2789928-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CADyq12zxzi+t727B5sm5z-z3SmRQyMDOmr_tTG1GaMVh6VTWbw@mail.gmail.com>
References: <CADyq12zxzi+t727B5sm5z-z3SmRQyMDOmr_tTG1GaMVh6VTWbw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h7iacyieipfqc3t33881tmcitwykjxcz
X-Rspam-User: 
X-Rspamd-Queue-Id: 51F9B40009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763431704-565538
X-HE-Meta: U2FsdGVkX1+nDU7gOgh3Pt0UlIKRZVuXbAWHFoqfUvYVJzq4jTzlAVzx4KbPnxCyNHQdbNsTF9TnO0r7VBmTuHjlXnyKip8EZgkoaFVGg836E9u9ZA+DrfQBpcmi76SB1URYESyAaxkLreJupMhZ2kfaRHmDlcPvMPhWYwQSKCjnHubTTStSrJaARkqGeJkomy2pUa9josplyUPtwWbqka0jio+rPj7JfZ8yUH+xQ3i+mT2MCQvLxKfwTNG0+oKX1Mm3Xxs8xRQzj7Mq+Gc5nyE41rTO5HSDf2NSAMr0e20utQI04hDfnEFWu2/dN5MG8rugKAEOzLYS1z2E8r2Nt+uIcC9RkCYfAAGeVj2FdincBeW0A2E9TsqsOtOMyURJKi7g3VkI5y0OQDgNc7hdrHBcnvs8FHjDUspUKDyqy7zBwlnTbw3EMSGRNOMJbLq8Krjmz+FVmYdSwQmrrmmRDz8G3i/30t1+Yms+Enu7WB/kohHEdN1mL4qHIEb5RvFADfruKrcwig4bcHqld/VXpmNPxNBVxhDwiFBiteUaGcYnzA11dQ/LAwm9mhc03+bCH38FVLTxliVHdBCk2CP3y3JtM9ILawaljUHw+uqjcEYV0xzCozTzPI4ksdy/tptNf7YfHvfveB6ScbIwg8CgAk+U/Xlz5/dsSMO+o46XX3Ih5ZMdDtdDzAHTFAhLG1APtyD6Ir70HQ/MuM9K2zwkUdR+OggyJZ6ot5w5q3V4xUWVkan1WogW2mC17oHyINcmiDdZo3yG+U9fWV3+NILpHBSBlf1SDWnY8DkOM8WdwpxhZzBvbiVkeSaVMkAjit3TOpAAY2tmorhs05UtZtWzS8T4CAahEeHP9AXKoqTGoLNs4/3jer2s9dl5Scz6v5MXkCC60kgj1ln0pOzfNPjKhvdwVGN9tiDOdyMPIV0f5GfHrt6Y0OoCh+c3R+XC/QWCU4NKzw1g5HFt3acDU4z
 I16rFau2
 bJKK9IiM88clWFH13f+Et1iL0ygSn1vTT/K1ea75xIkroB0LSlcWHAiMGgkaIt0CF7LtmnpHbSNOVGqIaezlV4Uq0mihsunG+oK2NHUhhf2fP5N+bWFuUqjz9JWzLv7SqHl4icun+qXTZRLW7aDSU3fNNdLw9pqwO1LZ6H+D2/86jHOA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 10:19:22 -0500, Sergey Senozhatsky wrote:
- index = pps->index;
  zram_slot_lock(zram, index);
  /*
   * scan_slots() sets ZRAM_PP_SLOT and relases slot lock, so
@@ -775,67 +999,46 @@ static int zram_writeback_slots(struct z
   */
  if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
  goto next;
- if (zram_read_from_zspool(zram, page, index))
+ if (zram_read_from_zspool(zram, req->page, index))
  goto next;
  zram_slot_unlock(zram, index);

I tested the reorganized patch on my end and found that it didn't work
properly. Currently, it has been found that this index is uninitialized.


