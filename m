Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28573CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835866B00A2; Wed, 27 May 2026 10:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80CB36B00A5; Wed, 27 May 2026 10:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7227A6B00A6; Wed, 27 May 2026 10:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 612B26B00A2
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:13:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03889161A37
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:13:45 +0000 (UTC)
X-FDA: 84813393252.15.3513B3A
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF05C14000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:13:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Se6w9Equ;
	spf=pass (imf26.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779891224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5fXQaASvIzd3Xl5ViHRaAzTexLFKYxxm1JbU0Z645Tk=;
	b=hyIQqg1Zs9u8QBe3UqxlV6XI+f4NyVe5H1V9XCXpRxrliG5JeuPzLYRy2aB9Fqk7sYaQQf
	UyXq468QVPBdW1/Nfnc9z8+iXPRiqsPGra1q5bwBmSSzzr0Lv7a6XeIp/bJrldTnFcvH+L
	br4uDQMmqUgd4VcP6CzsbbAgPuJ35fw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Se6w9Equ;
	spf=pass (imf26.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779891224; a=rsa-sha256;
	cv=none;
	b=NETqUP6kyYEa8/5uRijkpwsJk7izJeOFfIJ5WgbhkMWqERrxHhl2xxXk4ATtTJoTMUigCx
	2ymW5wafVP8FQooWvPBRFNTFd5B/wFSBcVEePfzHH4S9cjKydSIjir1qxhfq0WsQ3SfTMS
	SNhPsWPrhk9uVwFG/cNeF5MnVoRTDHA=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2bd80b3aa13so78933295ad.0
        for <linux-mm@kvack.org>; Wed, 27 May 2026 07:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779891223; x=1780496023; darn=kvack.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :mail-followup-to:references:in-reply-to:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5fXQaASvIzd3Xl5ViHRaAzTexLFKYxxm1JbU0Z645Tk=;
        b=Se6w9Equ/NazrhCoxWt/a//mTiVSrchMFXFcCYsKCfBBLJGreKJE9BPT122FvEpH0Z
         2CRhfgj48NtcTeg9Lbs1DJLrS2UVc6b9InZU7St9ZFGtqzyIzRguVx0Zmtn6FRN/eFSg
         MKbwCRFqMa2R4G4fVIDTiE8TqoUTnQAtlgqE1pbQm+D4Qc6j8L6x5ZRNFEVBv0P1XXtE
         K3QL654BFtos21N8PGT5PQhAKLXKgsaMxAieEsRulLynH+qoNNVjmGwmZuHHG3CFT7IS
         RGqckW8noc1NLrdVwT9X59tzF75Ly9P5Ib+rk2bdJUXMoIPVLDaDPnsVze2ITDnM6rBN
         Mj8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779891223; x=1780496023;
        h=content-transfer-encoding:content-disposition:mime-version
         :mail-followup-to:references:in-reply-to:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5fXQaASvIzd3Xl5ViHRaAzTexLFKYxxm1JbU0Z645Tk=;
        b=g0zlMRcaZU954WVn9Wc2ccryOSGjLfpJhizEdM4m99i6PdC/ZU5DLHVJCyawJc1Mq0
         /Sl+PWofmDgyfCWwzAnaR6340siFn68WTQtqT/MlNdNTXn8ze+UV6rTvxQIkoQm2PECX
         /ExTF4iCyUN6izgvv0G5sk2OEtJAaNjQRzffl0HxQzZtilp4nNYS6t3A3roLRY0LIiLa
         Z+0RE/xYCCXorHDlqX4GjDCkhCIgLBb+03VQumj4f4Q5p8f78/ADLgZmAQ882IuCmOuS
         1+xNXQBnNXl8FoqTbdFtt9ECfmhkFZVsqqBOEPBir7GXs1Jg0FNKLlyzwHCmrihJvw29
         MMLg==
X-Forwarded-Encrypted: i=1; AFNElJ/ZYdm2AKFddZP77KPl+kUbZJyPNV7ikApUpAEo102TlMq88Iz/02DDbPMUVdZXpDm5u238sqxycQ==@kvack.org
X-Gm-Message-State: AOJu0YxZE20WeULCQ7GRrGET8GXBGtjQypJj8A8C3++VyzGn6IFRf/od
	+kVIWud8KLyOvUqRDMt7Vq5v1J4NLTjejUXmdlIaRPPS2q/N8Ek8ngIa
X-Gm-Gg: Acq92OFWQrxbyiE5pqmKalIgBVzaKZ6W8cS7BYC9qGv0WjKNPHiQZaIhNZ3pW9C622L
	umIbKHCe08EA5L498PNZA+4XkVt9Tu49+eeIZ4bm8A6dZDw6LO+6rscyRC0Iczc9JiWPRuTDn9+
	74NETmU4r81GlNsO+Ka2lAdzTW1vhJWYW/E+t5sbGjsaXY/o7HROnDPNB92Mp5n6jvcUD8iHwDU
	E0bx+RcixY2qmtmqjeLb1RcOvokPonjg3y2QF+WELy/OeDbB0C4rc0/o2V7HLlC1IcKcU7dS0DR
	7q5sreCxt5HjImbuVQiN9VD+jR6ugyWUKN/OARbLOoVGudwZic0wa3HH4mfU4zDg/ZvOq5s0TT9
	VmXb3ghCeL6sr1fuC1/vAwf1hLuZiQUUzkHZJkV9vD1eJR1l/xhTKKheghhkyxhW4Jj2URCiqha
	Xh35dZPupAoRXtlOWFaIcwNKAjHvd2qEGgPqJTgeZ4CEh1OKg=
X-Received: by 2002:a17:903:198c:b0:2bd:2de3:519a with SMTP id d9443c01a7336-2beb06ea5e1mr257189885ad.7.1779891222695;
        Wed, 27 May 2026 07:13:42 -0700 (PDT)
Received: from localhost.localdomain ([116.80.91.208])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58c31a3sm155458115ad.55.2026.05.27.07.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 07:13:42 -0700 (PDT)
From: Cunlong Li <shenxiaogll@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] zram: fix use-after-free in zram_bvec_write_partial()
Date: Wed, 27 May 2026 22:13:36 +0800
Message-Id: <ahb8ELI3FxoMalaX@debian>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20260527072414.GA17856@lst.de>
References: <20260527-zram-v2-0-2fb84b054b5c@gmail.com> <20260527-zram-v2-1-2fb84b054b5c@gmail.com> <20260527072414.GA17856@lst.de>
Mail-Followup-To: Cunlong Li <shenxiaogll@gmail.com>, Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EF05C14000C
X-Stat-Signature: yi46c6jbtisojmq65mpjt3ctgqni9iab
X-HE-Tag: 1779891223-57970
X-HE-Meta: U2FsdGVkX194RWwhT67ukuzn+8+EyYMJ10qldptcpFzUHd9uzjNtRMkOk+/RsN2TsCj5wXGnMoBYzytKDIJtpGA3uk41DH/O6rCS1uUpeLOg49GxyEX28X8asCJy/TakQHf3Jxf+5MauynGqPgmCIDNEquZVWfLPm/p2VlC5Q55f60b9y9cPJ55a/qNLp0PPPdHNNUr56hscKUseZ+EkeUF3BhoMxgHPSmTxEhotkXHSuszjBXhptTCkULkSP2SulWAnftPQTqmnRukEUoLjTL6ta+kQYq6HekxDV08z2HFqF+Kq8BFHQWQ82XVfbSlWLsx9VCv9yRyaQTOaMhhlcpEWuvlBCiFwz3yjlJ7HGoTx8joF4faYsLYSMHWR/M6u0uFHX8upsQEg7pTOzVFSH60v+sBjqDhsGHbC845NPi0Bm+JH36fLG2QrpRxn7yvIOFQp6R0K9GDjZAXlP/ECmxK2aqq60dLj/UR8po0fn7VDgaYmrh3xOETN+hlf5tS6Kd7UDmAX/dFUFINzSLydSZCoJh8FTO5m5Q86WjAODZRfAHvJ9eNfm2o8b/Ky7n9dnr+QODC/+snmJm4dhrpsCATWmuy2T5WOXpxVffLrDvWNPeQcHrbmZN1POSszr2CKV4WhQmYMpJgc6TtM4RQKOGBrQo3Or4NfMSgvr6Qf08gARqna+15BFFGpfVaFQj4XbIFh5+W7LyrtytCT5Fgq5DZ6GaiEb+dpxldu0THTOXc+BIb5TueOq1OyjZiAnR9SW724G1i5xjCaIUI9Rg9zIQSHJIEm3zCPcrER5lnw88Yc0gMdAezu1Gd1ljBP0Tz7w2FYSjOwrCdhBVX4XlPWkB8Gx35uLN16MBI6Mn10bO+AzAu8T+jxyXc9uTGNMMnfoYxMYagIzkwvznJ8DOoa8BKm3j8EyFGq4CwjLtoNCGdOIfNr+dWRYdUJjXygaz+0Hs6tmY+JHvfSXEPKyYu
 8+SnERS0
 jMOu2flpTnyLlE47VFBqtIB1AtLXfXomD2gTA3yLaQfOhGG3sEheyjTQtTGmB/G6rA33muL9uI3iwgYqztpYy5sYB+ED9C9WqNLq/zUFk4h7JdS9qI+J6twxEhIi3yGG+nHKfSlhe0PG8m1DpdF5SkY93OWOo+nD59peQwCCB8tyzkuZ4MB+01K2k7Yf+moVCGhdXpRUg8o5/0gjymm163BQdbzRGpOPy7ocwF28kpCdnfjWEUaqu3vqwkYV1iIdJr1Xos/GsaQwKauLr3F6GppLMOd/w0g5DGCW9VUswxdAXnIqTFZQQZkDfGyzsEP6xDYh0JDiCPNveIfFPZGiFlddKbQNOXSiNREQCYOdEi5TKggQHis7XjTtwR/zaE/DMYwABE6RK13Q9GoFzqqLUj47s5xpKwkFY4XRli49vDSiPxIedmtzshXtwz6M/ks19O0v0X5m0DMREoBIkphau+OMt71GBuZRR99m5mZRJpLoaxTjewPRuXwyZRrnt6CjpcbVJzBrmav4fYuldVNz5YQ16ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 09:24:14AM +0200, Christoph Hellwig wrote:
> On Wed, May 27, 2026 at 12:49:24PM +0800, Cunlong Li wrote:
> > zram_read_page() picks the sync or async backing device read path
> > based on whether the parent bio is NULL.  zram_bvec_write_partial()
> > passes its parent bio down, so for ZRAM_WB slots the read is
> > dispatched asynchronously and zram_read_page() returns 0 while the
> > bio is still in flight.  The caller then runs memcpy_from_bvec(),
> > zram_write_page() and __free_page() on the buffer, leaving the
> > async read to write into a freed page.
> > 
> > zram_bvec_read_partial() was switched to NULL in commit 4e3c87b9421d
> > ("zram: fix synchronous reads") for the same reason; the
> > write_partial counterpart was missed.
> > 
> > Fixes: 4e3c87b9421d ("zram: fix synchronous reads")
> 
> That's just the last patch touching the line.  This bio chaining goes
> further back.  AFAICS all the way to introducing backing device support
> in: 8e654f8fbff5 ("zram: read page from backing device")

You're right, thanks for catching this -- will fix in v3 with:

Fixes: 8e654f8fbff5 ("zram: read page from backing device")

> 
> The patch itself looks good, though:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

