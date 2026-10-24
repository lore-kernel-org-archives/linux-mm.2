Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA04F606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 10:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=sina.com header.i=@sina.com header.a=rsa-sha256 header.s=201208 header.b=Iu916t/g
Received: by kanga.kvack.org (Postfix)
	id B648F6B00D5; Sat, 24 Oct 2026 06:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15066B0195; Sat, 24 Oct 2026 06:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08486B0562; Sat, 24 Oct 2026 06:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CC166B00D5
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 06:14:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DCFD8A02EB
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 10:14:20 +0000 (UTC)
X-FDA: 85357109880.12.0CDF9E4
Received: from r3-22.sinamail.sina.com.cn (r3-22.sinamail.sina.com.cn [202.108.3.22])
	by imf14.hostedemail.com (Postfix) with ESMTP id 400CF100006
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 10:14:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="Iu916t/g";
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf14.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.22 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792836859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHWFq5avGv6klXPzFSL6fYOnL7TOVnTa30eJ0p38zXo=;
	b=dMdw1hNe2KhcuiGTm56WpMtVxvaj9CZS9Xf/ajlPeVepo77Vm8DpyflBKtYpejrWgOslDU
	j2S/sp8eNXmY5VbCY/Y1BdlFLAy1m+ms23oz5Paii5d6K78auvnsyP5awtervB3oE9Rdg9
	bbMHcvv4d53KLQsaWzMaUwh4tnLEilM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="Iu916t/g";
	dmarc=pass (policy=none) header.from=sina.com;
	spf=pass (imf14.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.22 as permitted sender) smtp.mailfrom=hdanton@sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792836859;
	b=zvuPczwbavOKszWnIi0vOAbnCNq+t4BIv7fSUGzCZFnH+QOPk5eKKascHNLN0ZppJsKSNx
	5aMvQuaOKTZ0Mv4hkw80+p7fm5JVPcBctWZU4RaNstHp5JTiW7ieb34lxotzHgdCKf7DAC
	b2HV4p+0Lh0HeOUi/lJDIMWPz0/bb1w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1792836858;
	bh=mHWFq5avGv6klXPzFSL6fYOnL7TOVnTa30eJ0p38zXo=;
	h=From:Subject:Date:Message-ID;
	b=Iu916t/gA1gco/GHCyHhJy8LlfimdqEhWr5OTrlOt1iJ6eLOm/8QtSocxlUAXVbZf
	 SKeyYl9RH9FpbfzM1Ut8bL5kSZoFsXSR0fQ3CUDvPibSpiLrWxFOi2+/ERTcs5zqAc
	 RjKaLU8Ogygi5gqtb3YCTyZEQl1sF9LXQM3q0Abo=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.244.128.131])
	by sina.com (10.54.253.33) with ESMTP
	id 6ADC84EE00006143; Sat, 24 Oct 2026 18:14:12 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 8747526685218
X-SMAIL-UIID: ADCBD3CDD2B14D43A83493204A501CC4-20261024-181412-1
From: Hillf Danton <hdanton@sina.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Barry Song <21cnbao@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v6 09/13] zram: split zcomp into separate R/W streams
Date: Sat, 24 Oct 2026 18:14:00 +0800
Message-ID: <20261024101401.1035-1-hdanton@sina.com>
In-Reply-To: <atxFgutP-N3UZex2@google.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 400CF100006
X-Stat-Signature: 94wqw4n9e671tpbgynjjk9foya4e5zh8
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792836856-716683
X-HE-Meta: U2FsdGVkX19Qb7MTD7LcDU6yATOyUU1SRQDbmX/crbrmQCUyNY7oDrDn39Ow1A94s0MMtI7a5Nj6C5jLnGHURJT/l5jnC08/0bUZyRg5NyZFxA4q47IRYRv7QoPEctqiQqCGSUR5bS6DcPRXj3AZNn4TJWVGIATJeooLwnH7b2wf8Ekxq1eJ33pxM3ML70fRzZ+qs+FgLXVvQxEXmozu8FBkqV1ZDz5Wo28y9ed1tSKb9D43+LGUfXAThqh6LvWztGqOtW0xSjuKY3dwMgklNybUZ4uDP+J6C5rb4WnEU+SlpRZjl7GGvZ4EBP09VHR4JlBMoyzv/4aKM4LESLw5dbKfVZiVQDWMtTiQiVC6DiTRDMfFe/QqWYJKlmD4digPrAcPCWHo9DvrQurM1fFJJ2n3Im5d0e4hQg91mrGKFpB4VodCSwQnt1IrM48LoAtW4akhbbDcy5o9j1ptsjb5Yr3VUzF+6TroMg7M7rJozoD0gpY9V9Bt3d4sxmFOoRe7+nx8MoyS4IzVDGVC/qcTNEg//VOd4HSUYvm5c4G5lPNVefbxd9sigyI7OBM0eFyqydSTwKK5fiJoUsut9aOrYIVCM9Yh6fb85EYhQWk+LHFk97oU1Z+oS7bW8u5/QUAa+Y6mSr3rEn25FNi+/Bepl/98BUxA0BK4NmokJ9DLOoLuBm734DJmsHwMv82/Hq57DasuJud3awZ7BxYi498zGXTcmc2vYnMeEtUf7AUcWtPIcTPGmhVcCP6ZkW16tLlQM8SXEFjbIjSlL4bzfrLDz1QnimTnP05qSVYE+7JlSY9nu9lRCkP76LfmIDLpaL7v1UuTOXzuv9LvGPhg3qqJs7MQYpH7O4Y62TRSgMYgcSXJdjgVYcOciPgxuv5PDCWw7w0AtvwbPZ05ohnVcfSrhz1iZUmmhU3jbwNsU19pl+xWy7Hm4bDQr1PcZtL4OWm2V0Jn81D5pcMHU6YFwKY
 et5MlIQJ
 LvfsuzUz79h3Aobp/A1oHcdoJ4bJ61bLvXu52pcc28JUxfE+oj6YYXqLbTNhqxPWQVYvTPHcfqaWQlQl1mLNM+XzGlSO5NDVcOraFAM8szd5yzWM7RTV9rdCc8nh3wAzdsbzPUMy2Oku+1C6bcm5/V+DR3iZLdTqnUMk/4U6NO2PFFQorsoPL5GuUAdwIr/stteXsOh8cNUen88z9UT8Wvsl39d+SgcNXwBbSWZjRI3VGi6Syi4DLg2d9ajPVwX+s+kgQ40fwuokCS4kBDWLizl5x0nNkmpLxyKCm9jwBot3Ampj5Fa+7hbEZvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 24 Oct 2026 14:48:32 +0900 Sergey Senozhatsky wrote:
> On (26/10/23 19:40), Hillf Danton wrote:
> [..]
> > > writers vs readers 3 runs
> > > 
> > >     BASE+PE     IOPS 1,271k  avg 5.57us  sd 1,393us  p99.99 27.5us  max 1,581,800us
> > >                 IOPS 1,461k  avg 3.43us  sd    78us  p99.99 23.9us  max   227,015us
> > >                 IOPS 1,444k  avg 3.48us  sd   222us  p99.99 23.9us  max   592,628us
> > >     PATCHED+PE  IOPS 1,457k  avg 3.32us  sd    18us  p99.99 27.5us  max     5,620us
> > >                 IOPS 1,464k  avg 3.31us  sd    17us  p99.99 24.2us  max     5,621us
> > >                 IOPS 1,475k  avg 3.29us  sd    16us  p99.99 26.5us  max     5,620us
> 
> BASE+PE looked noisy, so I sat down and tested properly (also tested
> zstd and various compression levels).
> 
Thanks again for sharing data.

> (PE enabled for all tests)
> 
> ######## zstd compression level 3 W-vs-R
>     BASE     IOPS 1,154k  avg 7.84us  sd   444us  max   697,634us
>              IOPS 881k  avg 14.16us  sd 2,242us  max 1,387,000us
>              IOPS 704k  avg 20.43us  sd 3,499us  max 2,058,300us
>              IOPS 563k  avg 29.02us  sd 3,910us  max 1,649,800us
>              IOPS 626k  avg 24.79us  sd 4,013us  max 2,085,800us
>              IOPS 976k  avg 11.54us  sd 1,518us  max 1,165,800us
>              IOPS 1,178k  avg 7.44us  sd    22us  max     3,103us
>              IOPS 1,120k  avg 7.39us  sd    21us  max     7,222us
>              IOPS 522k  avg 32.51us  sd 4,311us  max 1,598,300us
>              IOPS 581k  avg 27.54us  sd 3,626us  max 1,448,600us
>              IOPS 1,160k  avg 7.69us  sd   352us  max   702,099us
>              IOPS 1,169k  avg 7.52us  sd   129us  max   281,428us
>              IOPS 954k  avg 12.06us  sd 1,705us  max 1,545,600us
>              IOPS 1,029k  avg 10.24us  sd 1,156us  max   976,065us
>              IOPS 1,169k  avg 7.48us  sd    24us  max     4,305us
>              IOPS 1,177k  avg 7.45us  sd    53us  max   118,777us
>              IOPS 579k  avg 27.43us  sd 3,661us  max 1,615,800us
>              IOPS 1,169k  avg 7.52us  sd   115us  max   228,074us
>              IOPS 1,110k  avg 8.59us  sd   985us  max 1,288,000us
>              IOPS 1,177k  avg 7.45us  sd    29us  max    72,245us
>              IOPS 580k  avg 27.74us  sd 3,755us  max 1,507,000us
>     PATCHED  IOPS 1,179k  avg 7.40us  sd    23us  max     7,404us
>              IOPS 1,179k  avg 7.41us  sd    22us  max     2,857us
>              IOPS 1,176k  avg 7.40us  sd    22us  max     6,615us
>              IOPS 1,175k  avg 7.44us  sd    23us  max     5,623us
>              IOPS 1,176k  avg 7.42us  sd    24us  max     5,625us
>              IOPS 1,173k  avg 7.42us  sd    24us  max     5,632us
>              IOPS 1,172k  avg 7.41us  sd    23us  max     6,223us
>              IOPS 1,173k  avg 7.40us  sd    25us  max     5,848us
>              IOPS 1,173k  avg 7.40us  sd    24us  max     7,563us
>              IOPS 1,172k  avg 7.42us  sd    24us  max     5,625us
>              IOPS 1,175k  avg 7.42us  sd    23us  max     5,626us
>              IOPS 1,177k  avg 7.42us  sd    23us  max     4,243us
>              IOPS 1,170k  avg 7.46us  sd    25us  max     5,622us
>              IOPS 1,178k  avg 7.40us  sd    22us  max     3,213us
>              IOPS 1,167k  avg 7.43us  sd    25us  max     7,593us
>              IOPS 1,174k  avg 7.44us  sd    23us  max     6,971us
>              IOPS 1,179k  avg 7.38us  sd    23us  max     3,477us
>              IOPS 1,180k  avg 7.39us  sd    23us  max     2,894us
>              IOPS 1,145k  avg 7.37us  sd    21us  max     4,048us
>              IOPS 1,177k  avg 7.38us  sd    22us  max     5,620us
>              IOPS 1,177k  avg 7.40us  sd    23us  max     5,623us
> 
>     IOPS: BASE 932k (+-260k), PATCHED 1,174k (+-7k), 21 runs each.
>           significant difference at 95% confidence: PATCHED is 241k (25.9%) higher; 95% CI [+136k, +353k], Welch's t-test p = 0.000
>     max latency: BASE 3.1..2,085.8 ms, PATCHED 2.9..7.6 ms
>           runs with max over 100 ms: BASE 17 of 21, PATCHED 0 of 21; over 1 s: BASE 11 of 21, PATCHED 0 of 21
> 
> ######## zstd compression level 12 W-vs-R
>     BASE     IOPS 690k  avg 21.53us  sd 3,088us  max 1,635,500us
>              IOPS 478k  avg 36.51us  sd 4,385us  max 1,941,300us
>              IOPS 822k  avg 16.13us  sd 2,865us  max 2,263,800us
>              IOPS 1,161k  avg 7.73us  sd   114us  max   190,307us
>              IOPS 780k  avg 17.56us  sd 2,717us  max 1,550,500us
>              IOPS 1,166k  avg 7.66us  sd    40us  max    94,522us
>              IOPS 585k  avg 27.51us  sd 3,847us  max 1,550,600us
>              IOPS 1,147k  avg 7.97us  sd   344us  max   496,483us
>              IOPS 1,166k  avg 7.64us  sd    49us  max   115,243us
>              IOPS 1,163k  avg 7.66us  sd    23us  max     7,006us
>              IOPS 1,071k  avg 9.42us  sd 1,489us  max 1,915,500us
>              IOPS 962k  avg 11.88us  sd 2,168us  max 1,904,500us
>              IOPS 607k  avg 26.05us  sd 3,538us  max 1,591,100us
>              IOPS 1,167k  avg 7.63us  sd    23us  max     2,903us
>              IOPS 1,157k  avg 7.78us  sd   198us  max   418,930us
>              IOPS 1,163k  avg 7.66us  sd    40us  max   100,346us
>              IOPS 1,162k  avg 7.70us  sd    32us  max    82,602us
>              IOPS 488k  avg 35.43us  sd 4,340us  max 1,786,400us
>              IOPS 563k  avg 28.85us  sd 3,989us  max 2,209,500us
>              IOPS 843k  avg 15.43us  sd 2,490us  max 1,572,100us
>              IOPS 604k  avg 26.30us  sd 3,560us  max 1,555,700us
>     PATCHED  IOPS 1,166k  avg 7.60us  sd    23us  max     5,623us
>              IOPS 1,169k  avg 7.58us  sd    23us  max     5,629us
>              IOPS 1,157k  avg 7.67us  sd    27us  max     5,639us
>              IOPS 1,166k  avg 7.61us  sd    24us  max     5,644us
>              IOPS 1,160k  avg 7.64us  sd    26us  max     7,543us
>              IOPS 1,167k  avg 7.60us  sd    24us  max     7,514us
>              IOPS 1,160k  avg 7.61us  sd    25us  max     6,643us
>              IOPS 1,162k  avg 7.65us  sd    25us  max     7,315us
>              IOPS 1,161k  avg 7.66us  sd    24us  max     6,237us
>              IOPS 1,158k  avg 7.62us  sd    27us  max     7,688us
>              IOPS 1,167k  avg 7.58us  sd    24us  max     5,637us
>              IOPS 1,165k  avg 7.59us  sd    24us  max     7,098us
>              IOPS 948k  avg 7.58us  sd    23us  max     7,808us
>              IOPS 1,166k  avg 7.60us  sd    24us  max     5,621us
>              IOPS 1,166k  avg 7.58us  sd    24us  max     5,672us
>              IOPS 1,162k  avg 7.65us  sd    25us  max     6,824us
>              IOPS 1,165k  avg 7.59us  sd    24us  max     7,078us
>              IOPS 1,168k  avg 7.58us  sd    23us  max     6,191us
>              IOPS 1,170k  avg 7.56us  sd    22us  max     2,851us
>              IOPS 1,171k  avg 7.55us  sd    22us  max     2,834us
>              IOPS 1,166k  avg 7.59us  sd    24us  max     5,627us
> 
>     IOPS: BASE 902k (+-269k), PATCHED 1,154k (+-47k), 21 runs each.
>           significant difference at 95% confidence: PATCHED is 252k (27.9%) higher; 95% CI [+142k, +367k], Welch's t-test p = 0.000
>     max latency: BASE 2.9..2,263.8 ms, PATCHED 2.8..7.8 ms
>           runs with max over 100 ms: BASE 17 of 21, PATCHED 0 of 21; over 1 s: BASE 12 of 21, PATCHED 0 of 21
> 
> ######## lz4 W-vs-R
>     BASE     IOPS 1,422k  avg 3.84us  sd   418us  max   619,495us
>              IOPS 1,450k  avg 3.57us  sd   326us  max   609,723us
>              IOPS 1,414k  avg 3.92us  sd   543us  max   879,815us
>              IOPS 1,451k  avg 3.56us  sd   253us  max   503,428us
>              IOPS 1,460k  avg 3.40us  sd    68us  max   135,825us
>              IOPS 1,413k  avg 3.31us  sd    44us  max   188,450us
>              IOPS 1,432k  avg 3.73us  sd   503us  max   844,228us
>              IOPS 1,387k  avg 4.20us  sd   719us  max   961,827us
>              IOPS 1,464k  avg 3.38us  sd    44us  max   133,675us
>              IOPS 1,469k  avg 3.38us  sd    22us  max    65,812us
>              IOPS 1,465k  avg 3.40us  sd    49us  max   111,788us
>              IOPS 1,465k  avg 3.39us  sd    64us  max   174,040us
>              IOPS 1,467k  avg 3.38us  sd    36us  max    97,821us
>              IOPS 1,445k  avg 3.63us  sd   343us  max   671,026us
>              IOPS 1,472k  avg 3.35us  sd    27us  max    86,795us
>              IOPS 1,473k  avg 3.33us  sd    44us  max   138,096us
>              IOPS 1,439k  avg 3.71us  sd   353us  max   619,815us
>              IOPS 1,398k  avg 3.36us  sd    54us  max   206,815us
>              IOPS 1,471k  avg 3.36us  sd    15us  max     2,832us
>              IOPS 1,407k  avg 4.02us  sd   629us  max 1,074,800us
>              IOPS 1,465k  avg 3.40us  sd    63us  max   158,779us
>     PATCHED  IOPS 1,471k  avg 3.30us  sd    15us  max     6,946us
>              IOPS 1,473k  avg 3.29us  sd    16us  max     5,618us
>              IOPS 1,474k  avg 3.29us  sd    15us  max     5,615us
>              IOPS 1,473k  avg 3.29us  sd    15us  max     5,625us
>              IOPS 1,440k  avg 3.26us  sd    13us  max     2,829us
>              IOPS 1,456k  avg 3.30us  sd    15us  max     5,623us
>              IOPS 1,476k  avg 3.29us  sd    15us  max     2,835us
>              IOPS 1,464k  avg 3.28us  sd    16us  max     6,063us
>              IOPS 1,468k  avg 3.32us  sd    19us  max     6,692us
>              IOPS 1,465k  avg 3.30us  sd    17us  max     6,834us
>              IOPS 1,468k  avg 3.28us  sd    16us  max     7,268us
>              IOPS 1,463k  avg 3.31us  sd    17us  max     6,480us
>              IOPS 1,454k  avg 3.33us  sd    20us  max     8,418us
>              IOPS 1,452k  avg 3.32us  sd    19us  max     5,621us
>              IOPS 1,477k  avg 3.27us  sd    14us  max     2,834us
>              IOPS 1,468k  avg 3.30us  sd    16us  max     5,617us
>              IOPS 1,475k  avg 3.30us  sd    16us  max     3,884us
>              IOPS 1,475k  avg 3.30us  sd    16us  max     5,692us
>              IOPS 1,471k  avg 3.30us  sd    15us  max     5,616us
>              IOPS 1,473k  avg 3.28us  sd    16us  max     7,014us
>              IOPS 1,475k  avg 3.28us  sd    15us  max     5,616us
> 
>     IOPS: BASE 1,444k (+-27k), PATCHED 1,467k (+-10k), 21 runs each.
>           significant difference at 95% confidence: PATCHED is 23k (1.6%) higher; 95% CI [+11k, +35k], Welch's t-test p = 0.001
>     max latency: BASE 2.8..1,074.8 ms, PATCHED 2.8..8.4 ms
>           runs with max over 100 ms: BASE 17 of 21, PATCHED 0 of 21; over 1 s: BASE 1 of 21, PATCHED 0 of 21


Lets see the data from another pov (feel free to disagree) -- in the android
phone/car cockpit environment, the render frequence is required above 60HZ,
IOW a frame rendered within 16ms, so what share of the 16ms does the IOPS
account for after this patchset, for example when an app in background is
brought foreground?

