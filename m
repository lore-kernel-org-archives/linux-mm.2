Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 489C4606A328
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 10:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=FRgIUM7R
Received: by kanga.kvack.org (Postfix)
	id 3ECA86B05B0; Sun, 25 Oct 2026 06:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39DCB6B05B2; Sun, 25 Oct 2026 06:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3A06B05B3; Sun, 25 Oct 2026 06:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 093646B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 06:55:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 786C812027A
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:55:02 +0000 (UTC)
X-FDA: 85360841244.06.14DA10C
Received: from smtp153-165.sina.com.cn (smtp153-165.sina.com.cn [61.135.153.165])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5F21C0003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:54:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=FRgIUM7R;
	spf=pass (imf10.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.165 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792925700;
	b=FiMzbL8npY7QkUOS88izBY6pOfqgk0cA9qPHyZN3ERRxc1cF9d0o+OKl5ySRpUjWBBNXpk
	G4t6xicy3EdUQsWi8HDQZ7+NCdQNPLrXlmgAb7L/TG7jxO41decEuY2/QRKSkAGM4oFyHl
	Ng/h45EemCxWt8d/vDc+IVmQ1MSwneU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=FRgIUM7R;
	spf=pass (imf10.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.165 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792925700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ddGAYAtB79F7wRhnGkW+ljKWe8FQH+MNDzT857Yhzs=;
	b=bhKNZcs/cSNDfIZxVXNV94s/PXHNPP42RQ4YAOW91WMPnjzQIxdmqWqvc6Po5tHXnSMASr
	s7Uc2C5ZXQOBebONf8mFYB26h8ENuFBFNf075KvVJmkKw4SAg0FDl5SS+PVXYiYqHEJXAV
	yu2RyuM9vmilEpehqMmPGIilxAIARaM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1792925699;
	bh=4ddGAYAtB79F7wRhnGkW+ljKWe8FQH+MNDzT857Yhzs=;
	h=From:Subject:Date:Message-ID;
	b=FRgIUM7R9HnHCxdjvfk8HtKFJPNpWkLiknMOgKjGXAESGx+h1FqRbfhJmWrQSi4mg
	 r9b5wBp6jIAFn+TspFjDxcCVjebsVQkpewZv9f1X9x70pgNnk+mMPHCp1BTPfWgAvm
	 NPZUzHPKLrt/Jtj3fND8iiTZdG6eaFxdmNhWs07E=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.246.238.232])
	by sina.com (10.54.253.32) with ESMTP
	id 6ADDDFFB00000221; Sun, 25 Oct 2026 18:54:54 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 6351494456771
X-SMAIL-UIID: 9557747A4C984AC9AE3E1418D8FD2278-20261025-185454-1
From: Hillf Danton <hdanton@sina.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Barry Song <21cnbao@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Date: Sun, 25 Oct 2026 18:54:40 +0800
Message-ID: <20261025105441.1148-1-hdanton@sina.com>
In-Reply-To: <at1cSbfBXdYIAIyT@google.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D5F21C0003
X-Stat-Signature: 9rsfkssux6p43naxfzpy75afaqgtezzu
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792925698-704000
X-HE-Meta: U2FsdGVkX18Z+1NjuHRl0WWXcpj7d1Rhe3PxEkRAy/OXv9BZdNyEB7jphdLNGqc5IM8J1p2LsPvG4FtXxSar2YVtOS7usllQ5JfQlP3iI44jKFxdXzxpKnMHpENyMk8LM8Kiq0ymEwx3843458snZuJPIg3B6LOXH0XpmYrwwDxdhIIo8/hLh0Dxd9dABIOrchrMhKnbnlT8H3szofM25rRJw1Vc8GYoCmTwtK/qZ3c4GkrpNUd5QrSggOlY4esDCBJXS5fS+6Xz3zlnksX46hfpoOmoc0Bje89voNHVAabvM5pSuvK2nIq58GyzuxICwkb+pHBX7vnn8fiEqNLUizG+FWSFpzb9BtJdGCygB766Y7k8E4GrNVOUNsZwKYNWhyeVh5oO1MpbRx/h9dNtD49QhfWrQpKoajkLQg67ALnMSkfOVkD6lJZpXnSmEJRKQfTQ/ZCl1+39jWgyXJnp+U2vwKXvA37bwR9aoxwCLBvERDD4wA6AnOO7149C398ZOOqlMUw8GqLnC3XI9bPGzzaI8yV6ZQtrGHu1bpkA7pfwVaCtzKCJHiw6pPFFtcEwZ1mJzNRCzS941VwB4YVLlG6YyJcIaRhetuUNDnxYlnHud6fuxC3oK5iHiRT+oLUEiRFs+251ugNiDzbw6006kCRSKU3xj4AzMRjWAFtwPn5jvQ2k0OZ3hQfcQQoTpNse0Hz4PvITmO6fPBnPlA5z8NDCzphc2m2MQFFe/FI6foh8RILUMAGjSn5xD/omKbvPO6Xo8kFwszY+hVHczZkCr81VsRUshHo08jX8HvJ7Hxb1YiuNnNh8shHasXqEcnqpFk4EanLanKTRAgyIMahgGeDDlIWNmOkd8ZCx8fps/oXiGHXwAUVKLKOVkzVMd1fZ1GR9ZVuowvhh0/jTOjGSjfj0L5TFu6q2oV6QC4kMGFv7A1QVeUAvav6ymtJic+D+buD+P36nxdzxuFLzajC
 1QRkJXIf
 QLErVarujXWBdaszTyFTtQpKiwOgrlleHgD7uBxtYQuwl0Tjhsf2gokR4a7f+99PeiFoc43KbwiDEuXYA0YupU13i5vHuyj2/KRnBm3+NCUehEP776r1wjzMvrE2vRRgVBJqp4Fh+wWR+BZO8lPcLua/yZp6h/Q7IvWHJlBmt6RdnyywAn4vp3NuOQ0CWUdUiX5SeGPb+EuHxpgcSGnCEJ/MxCCJPHPcnFdpK0gfvwONjQ7xo/SjqhAeqzPrSkzWCgT2R5umbMf/dj8n1ti9ltYSzDFqbZPMSxoS56+hrDC3rRT66T5ZLmXXlwuraKRT0RSso34snYpPBSJHyXo8dPWr3fi/vKc0qlR2M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 25 Oct 2026 10:38:47 +0900 Sergey Senozhatsky wrote:
>On (26/10/24 18:14), Hillf Danton wrote:
>> > (PE enabled for all tests)
>> > 
>> > ######## zstd compression level 3 W-vs-R
>> >     BASE     IOPS 1,154k  avg 7.84us  sd   444us  max   697,634us
>> >              IOPS 881k  avg 14.16us  sd 2,242us  max 1,387,000us
>> >              IOPS 704k  avg 20.43us  sd 3,499us  max 2,058,300us
>> >              IOPS 563k  avg 29.02us  sd 3,910us  max 1,649,800us
>> >              IOPS 626k  avg 24.79us  sd 4,013us  max 2,085,800us
>> >              IOPS 976k  avg 11.54us  sd 1,518us  max 1,165,800us
>> >              IOPS 1,178k  avg 7.44us  sd    22us  max     3,103us
>> >              IOPS 1,120k  avg 7.39us  sd    21us  max     7,222us
>> >              IOPS 522k  avg 32.51us  sd 4,311us  max 1,598,300us
>> >              IOPS 581k  avg 27.54us  sd 3,626us  max 1,448,600us
>> >              IOPS 1,160k  avg 7.69us  sd   352us  max   702,099us
>> >              IOPS 1,169k  avg 7.52us  sd   129us  max   281,428us
>> >              IOPS 954k  avg 12.06us  sd 1,705us  max 1,545,600us
>> >              IOPS 1,029k  avg 10.24us  sd 1,156us  max   976,065us
>> >              IOPS 1,169k  avg 7.48us  sd    24us  max     4,305us
>> >              IOPS 1,177k  avg 7.45us  sd    53us  max   118,777us
>> >              IOPS 579k  avg 27.43us  sd 3,661us  max 1,615,800us
>> >              IOPS 1,169k  avg 7.52us  sd   115us  max   228,074us
>> >              IOPS 1,110k  avg 8.59us  sd   985us  max 1,288,000us
>> >              IOPS 1,177k  avg 7.45us  sd    29us  max    72,245us
>> >              IOPS 580k  avg 27.74us  sd 3,755us  max 1,507,000us
>> >     PATCHED  IOPS 1,179k  avg 7.40us  sd    23us  max     7,404us
>> >              IOPS 1,179k  avg 7.41us  sd    22us  max     2,857us
>> >              IOPS 1,176k  avg 7.40us  sd    22us  max     6,615us
>> >              IOPS 1,175k  avg 7.44us  sd    23us  max     5,623us
>> >              IOPS 1,176k  avg 7.42us  sd    24us  max     5,625us
>> >              IOPS 1,173k  avg 7.42us  sd    24us  max     5,632us
>> >              IOPS 1,172k  avg 7.41us  sd    23us  max     6,223us
>> >              IOPS 1,173k  avg 7.40us  sd    25us  max     5,848us
>> >              IOPS 1,173k  avg 7.40us  sd    24us  max     7,563us
>> >              IOPS 1,172k  avg 7.42us  sd    24us  max     5,625us
>> >              IOPS 1,175k  avg 7.42us  sd    23us  max     5,626us
>> >              IOPS 1,177k  avg 7.42us  sd    23us  max     4,243us
>> >              IOPS 1,170k  avg 7.46us  sd    25us  max     5,622us
>> >              IOPS 1,178k  avg 7.40us  sd    22us  max     3,213us
>> >              IOPS 1,167k  avg 7.43us  sd    25us  max     7,593us
>> >              IOPS 1,174k  avg 7.44us  sd    23us  max     6,971us
>> >              IOPS 1,179k  avg 7.38us  sd    23us  max     3,477us
>> >              IOPS 1,180k  avg 7.39us  sd    23us  max     2,894us
>> >              IOPS 1,145k  avg 7.37us  sd    21us  max     4,048us
>> >              IOPS 1,177k  avg 7.38us  sd    22us  max     5,620us
>> >              IOPS 1,177k  avg 7.40us  sd    23us  max     5,623us
>> > 
>> >     IOPS: BASE 932k (+-260k), PATCHED 1,174k (+-7k), 21 runs each.
>> >           significant difference at 95% confidence: PATCHED is 241k (25.9%) higher; 95% CI [+136k, +353k], Welch's t-test p = 0.000
>> >     max latency: BASE 3.1..2,085.8 ms, PATCHED 2.9..7.6 ms
>> >           runs with max over 100 ms: BASE 17 of 21, PATCHED 0 of 21; over 1 s: BASE 11 of 21, PATCHED 0 of 21
>> > 
>> > ######## zstd compression level 12 W-vs-R
>> >     BASE     IOPS 690k  avg 21.53us  sd 3,088us  max 1,635,500us
>> >              IOPS 478k  avg 36.51us  sd 4,385us  max 1,941,300us
>> >              IOPS 822k  avg 16.13us  sd 2,865us  max 2,263,800us
>> >              IOPS 1,161k  avg 7.73us  sd   114us  max   190,307us
>> >              IOPS 780k  avg 17.56us  sd 2,717us  max 1,550,500us
>> >              IOPS 1,166k  avg 7.66us  sd    40us  max    94,522us
>> >              IOPS 585k  avg 27.51us  sd 3,847us  max 1,550,600us
>> >              IOPS 1,147k  avg 7.97us  sd   344us  max   496,483us
>> >              IOPS 1,166k  avg 7.64us  sd    49us  max   115,243us
>> >              IOPS 1,163k  avg 7.66us  sd    23us  max     7,006us
>> >              IOPS 1,071k  avg 9.42us  sd 1,489us  max 1,915,500us
>> >              IOPS 962k  avg 11.88us  sd 2,168us  max 1,904,500us
>> >              IOPS 607k  avg 26.05us  sd 3,538us  max 1,591,100us
>> >              IOPS 1,167k  avg 7.63us  sd    23us  max     2,903us
>> >              IOPS 1,157k  avg 7.78us  sd   198us  max   418,930us
>> >              IOPS 1,163k  avg 7.66us  sd    40us  max   100,346us
>> >              IOPS 1,162k  avg 7.70us  sd    32us  max    82,602us
>> >              IOPS 488k  avg 35.43us  sd 4,340us  max 1,786,400us
>> >              IOPS 563k  avg 28.85us  sd 3,989us  max 2,209,500us
>> >              IOPS 843k  avg 15.43us  sd 2,490us  max 1,572,100us
>> >              IOPS 604k  avg 26.30us  sd 3,560us  max 1,555,700us
>> >     PATCHED  IOPS 1,166k  avg 7.60us  sd    23us  max     5,623us
>> >              IOPS 1,169k  avg 7.58us  sd    23us  max     5,629us
>> >              IOPS 1,157k  avg 7.67us  sd    27us  max     5,639us
>> >              IOPS 1,166k  avg 7.61us  sd    24us  max     5,644us
>> >              IOPS 1,160k  avg 7.64us  sd    26us  max     7,543us
>> >              IOPS 1,167k  avg 7.60us  sd    24us  max     7,514us
>> >              IOPS 1,160k  avg 7.61us  sd    25us  max     6,643us
>> >              IOPS 1,162k  avg 7.65us  sd    25us  max     7,315us
>> >              IOPS 1,161k  avg 7.66us  sd    24us  max     6,237us
>> >              IOPS 1,158k  avg 7.62us  sd    27us  max     7,688us
>> >              IOPS 1,167k  avg 7.58us  sd    24us  max     5,637us
>> >              IOPS 1,165k  avg 7.59us  sd    24us  max     7,098us
>> >              IOPS 948k  avg 7.58us  sd    23us  max     7,808us
>> >              IOPS 1,166k  avg 7.60us  sd    24us  max     5,621us
>> >              IOPS 1,166k  avg 7.58us  sd    24us  max     5,672us
>> >              IOPS 1,162k  avg 7.65us  sd    25us  max     6,824us
>> >              IOPS 1,165k  avg 7.59us  sd    24us  max     7,078us
>> >              IOPS 1,168k  avg 7.58us  sd    23us  max     6,191us
>> >              IOPS 1,170k  avg 7.56us  sd    22us  max     2,851us
>> >              IOPS 1,171k  avg 7.55us  sd    22us  max     2,834us
>> >              IOPS 1,166k  avg 7.59us  sd    24us  max     5,627us
>> > 
>> >     IOPS: BASE 902k (+-269k), PATCHED 1,154k (+-47k), 21 runs each.
>> >           significant difference at 95% confidence: PATCHED is 252k (27.9%) higher; 95% CI [+142k, +367k], Welch's t-test p = 0.000
>> >     max latency: BASE 2.9..2,263.8 ms, PATCHED 2.8..7.8 ms
>> >           runs with max over 100 ms: BASE 17 of 21, PATCHED 0 of 21; over 1 s: BASE 12 of 21, PATCHED 0 of 21
>> > 
>> > ######## lz4 W-vs-R
>> >     BASE     IOPS 1,422k  avg 3.84us  sd   418us  max   619,495us
>> >              IOPS 1,450k  avg 3.57us  sd   326us  max   609,723us
>> >              IOPS 1,414k  avg 3.92us  sd   543us  max   879,815us
>> >              IOPS 1,451k  avg 3.56us  sd   253us  max   503,428us
>> >              IOPS 1,460k  avg 3.40us  sd    68us  max   135,825us
>> >              IOPS 1,413k  avg 3.31us  sd    44us  max   188,450us
>> >              IOPS 1,432k  avg 3.73us  sd   503us  max   844,228us
>> >              IOPS 1,387k  avg 4.20us  sd   719us  max   961,827us
>> >              IOPS 1,464k  avg 3.38us  sd    44us  max   133,675us
>> >              IOPS 1,469k  avg 3.38us  sd    22us  max    65,812us
>> >              IOPS 1,465k  avg 3.40us  sd    49us  max   111,788us
>> >              IOPS 1,465k  avg 3.39us  sd    64us  max   174,040us
>> >              IOPS 1,467k  avg 3.38us  sd    36us  max    97,821us
>> >              IOPS 1,445k  avg 3.63us  sd   343us  max   671,026us
>> >              IOPS 1,472k  avg 3.35us  sd    27us  max    86,795us
>> >              IOPS 1,473k  avg 3.33us  sd    44us  max   138,096us
>> >              IOPS 1,439k  avg 3.71us  sd   353us  max   619,815us
>> >              IOPS 1,398k  avg 3.36us  sd    54us  max   206,815us
>> >              IOPS 1,471k  avg 3.36us  sd    15us  max     2,832us
>> >              IOPS 1,407k  avg 4.02us  sd   629us  max 1,074,800us
>> >              IOPS 1,465k  avg 3.40us  sd    63us  max   158,779us
>> >     PATCHED  IOPS 1,471k  avg 3.30us  sd    15us  max     6,946us
>> >              IOPS 1,473k  avg 3.29us  sd    16us  max     5,618us
>> >              IOPS 1,474k  avg 3.29us  sd    15us  max     5,615us
>> >              IOPS 1,473k  avg 3.29us  sd    15us  max     5,625us
>> >              IOPS 1,440k  avg 3.26us  sd    13us  max     2,829us
>> >              IOPS 1,456k  avg 3.30us  sd    15us  max     5,623us
>> >              IOPS 1,476k  avg 3.29us  sd    15us  max     2,835us
>> >              IOPS 1,464k  avg 3.28us  sd    16us  max     6,063us
>> >              IOPS 1,468k  avg 3.32us  sd    19us  max     6,692us
>> >              IOPS 1,465k  avg 3.30us  sd    17us  max     6,834us
>> >              IOPS 1,468k  avg 3.28us  sd    16us  max     7,268us
>> >              IOPS 1,463k  avg 3.31us  sd    17us  max     6,480us
>> >              IOPS 1,454k  avg 3.33us  sd    20us  max     8,418us
>> >              IOPS 1,452k  avg 3.32us  sd    19us  max     5,621us
>> >              IOPS 1,477k  avg 3.27us  sd    14us  max     2,834us
>> >              IOPS 1,468k  avg 3.30us  sd    16us  max     5,617us
>> >              IOPS 1,475k  avg 3.30us  sd    16us  max     3,884us
>> >              IOPS 1,475k  avg 3.30us  sd    16us  max     5,692us
>> >              IOPS 1,471k  avg 3.30us  sd    15us  max     5,616us
>> >              IOPS 1,473k  avg 3.28us  sd    16us  max     7,014us
>> >              IOPS 1,475k  avg 3.28us  sd    15us  max     5,616us
>> > 
>> >     IOPS: BASE 1,444k (+-27k), PATCHED 1,467k (+-10k), 21 runs each.
>> >           significant difference at 95% confidence: PATCHED is 23k (1.6%) higher; 95% CI [+11k, +35k], Welch's t-test p = 0.001
>> >     max latency: BASE 2.8..1,074.8 ms, PATCHED 2.8..8.4 ms
>> >           runs with max over 100 ms: BASE 17 of 21, PATCHED 0 of 21; over 1 s: BASE 1 of 21, PATCHED 0 of 21
>> 
>> 
>> Lets see the data from another pov (feel free to disagree) -- in the android
>> phone/car cockpit environment, the render frequence is required above 60HZ,
>> IOW a frame rendered within 16ms, so what share of the 16ms does the IOPS
>> account for after this patchset, for example when an app in background is
>> brought foreground?
>
> A single 500 ms read stall is 30 dropped frames.  Across 126 runs that
> I ran, base+PE had read stalls over 100 ms in 108 runs and over 1 s in 47.
> The worst read with the series+PE, in all 126 runs, was 8.4 ms, i.e. within
> one frame.
>
Good work from the 2026 most valuable baker, MVB.

Hillf

