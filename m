Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 939C0CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 04:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7A546B0096; Mon, 25 May 2026 00:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B509C6B0098; Mon, 25 May 2026 00:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2346B0099; Mon, 25 May 2026 00:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 917E66B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 00:46:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F5771A0142
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:46:59 +0000 (UTC)
X-FDA: 84804707358.27.E0E5CC5
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8CEB81A0003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:46:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=J+n2ZNaz;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779684417; a=rsa-sha256;
	cv=none;
	b=x0WD8ObP4pm8+Z9H+H3J3idAGRnVaGmTNBM8LGZE5qEWPeE7OIfVuevxOcCREvNfJrl37o
	qSeZHTH6XusQ69W1zTCmWuURkqBYRt10rALaosK215AEl5pix1tJr4PIAK2J3sE8J53Y2J
	kDNfx1e3nTpqtXCUMlCzhhQBw/5p4iE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=J+n2ZNaz;
	spf=pass (imf19.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.49 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779684417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gGF9YBn6GpTIO4fVhvrESIFDicPNTrXWsdQuH+NBxo=;
	b=B3hri9YcsK2EIC4+vhdMM2Zl32vwdtG4sSia5rfZ3/m60UBsydMyADy8GQvlTgLNcCSTGY
	wfn/j0s+Gc9Zrno4/5kA2hLgDEAQFJSnhAO0/XloTruOPiZmZJ0RgH+v7kLxW4fqTSzIzq
	9x2Narx+/s7qD0j1CkZj6OKmyeFtMgs=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-36622412e97so6977228a91.2
        for <linux-mm@kvack.org>; Sun, 24 May 2026 21:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1779684416; x=1780289216; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9gGF9YBn6GpTIO4fVhvrESIFDicPNTrXWsdQuH+NBxo=;
        b=J+n2ZNaz88O2o5hLh/Q5LgJOoAcLTrK7xLFUAPmbnLRsGNVFyI95q5Lz2FGg2+CjGD
         intF2zuexyPWW6an6s+v+jiy+/BHHCPaV2YdQ1VQD1nJb6OXX8vrOqcSKwYkJVgr3x1I
         +dHwKzfZW4bNf4Ew66Wbkdzg+dWbWARtSTJzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779684416; x=1780289216;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9gGF9YBn6GpTIO4fVhvrESIFDicPNTrXWsdQuH+NBxo=;
        b=qnK5Ks8rJw6BEqoT2cTsO3z8sxfiXPkJwwpzRBBRyEnotJ3k+HEtg2kWygLgXqx20B
         aB8pE6nXfkspoh5SPMyUzRSREXRrOhqRCjKDv0cJh8ckXAD2gmvHjljisvUuWKSJyClT
         XzbV25eFgerZv8oTyfGmAVSJDtvtMeaxw3i9Ev2JOBS5Byewh7xbJuRqC1UdXv3eEwQs
         lgyKjtBl4+I7BYbKp++UVCSy/218PVPsSLVWb+mQrgF2++uh63zztkufo7gRkCRfLN4C
         eESyxE1wJ3r1pfrlw+oSOe3gCJeYhYtPlVkbSKUQRykeTN9dXCu1rkD/o+0amz/UsDx7
         huiA==
X-Forwarded-Encrypted: i=1; AFNElJ+/DdW7V2NJ7n8XtRwyBMnWRkz8Q04xQ/Cm1udYzetiuCpeH2Y0RyMrKeZSj6LxFbRkoCvE6bV5cw==@kvack.org
X-Gm-Message-State: AOJu0Yzkzv9SCvFvZ6MktE/0SOVor47AL/s5Iaq+HnV7Dc8QWUdvHr9Y
	svEa/XEjvUn++Sc4bmL9fGkn7+9XTNn9oS/Z2UIX858TM+dK2hEw3U6puHGcZVVJ5g==
X-Gm-Gg: Acq92OFCWkNU5jy74fqq2KXOB5yraGchKtlWexcuXe8eRFIvAThYU8xeevrvKWrpXjb
	xzKBdzMsW8rrJxAW8qxNw0h6yweYt6XZWj8TC/6ZXlQ0bDVOKULt61NCdSQu1xegPZsK+lEYE0a
	CqjfBBw+HxRNJXS+cLX28j4zZG0FrDdeZEoVSqFQy67pPvaxHSXSHaEPLzLhpiz8aYhGQQ8rRKb
	Dt2u9BsNOm2ueEENHe7Zd6QWVv/kv7U/wMENmE+mTBu0AjMsc6KZMgpGZopQDqHJWpqkBXUomGH
	WrR+RuD7BTbnOF8+9QwJkvzsiUDdGr4vvI7tg4coq2NqKOCiodIWCTDQ32/cbyYwI3DF1sK5G/h
	Hy4ZKUqXb16hrh8XFX0eg4jVaLB/z4otY/ouHpDRCv3WESUoGr8msvAfzAOpJQaV8WdJ19Reqgs
	qf+yChw9I9ZMYyN6sn6FfG9AeuEWF/IHDy7Ye1dPZ5N+BVprGHa3jNnaglS8BifiUmtKR6p8n2C
	7f9HXacgnZk
X-Received: by 2002:a17:90a:c106:b0:369:7003:4e2d with SMTP id 98e67ed59e1d1-36a676090bemr12015986a91.17.1779684416408;
        Sun, 24 May 2026 21:46:56 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:8f7:7157:3ea6:a126])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a6c680110sm4361447a91.4.2026.05.24.21.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 21:46:56 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 2/2] zram: clear trailing bytes of compressed writeback pages
Date: Mon, 25 May 2026 13:46:02 +0900
Message-ID: <20260525044639.1888561-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
In-Reply-To: <20260525044639.1888561-1-senozhatsky@chromium.org>
References: <20260525044639.1888561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CEB81A0003
X-Rspamd-Server: rspam03
X-Stat-Signature: ikshttiu9g3dfestsc5i3r3na86otpkr
X-HE-Tag: 1779684417-77870
X-HE-Meta: U2FsdGVkX19Yo7BEb8ohHsWU7QBH5lqYyly3q5j416TQs1SxDwhSRgl0nshdutjTtXxTZZ1HzKWGPD8rJNjAJB6hVbIFWIXkBF9PEyY+62tunUyiXOWtUAZZgF0a5jdF9MSSY/M6ZfZweNezhqsbr4ZF9Z3mttYr9kWMFkudz38gXe4qyESUyVm1j43JlxG9dZO5G15/BzXZvezOexZf9g/DvdgulW72hxuyagBzJ+u6cVuAN6N9j5SGFLV/WQ/J7WIhv5OeKKR9EtX4VxKQP58LOnd4q/YdD0iojnxmRUli2IxFgikXUJaV324tUs1LVl7Of6giJv722df6NxxHlioNEjjgaJBrqrzBo30YaVSVoPdxM0k/jzX1yFuAp80zFmBs1Xmug9WnuGUlFJZnbwA30k59ldUqEymNONtBCjq6rC3q+1ggsVqhRT+Z/7N/CWfCfn+vLDgV3IguTP/W6MwjBHQNbiL0fTlzjfe3r0zdJtFJSznY3oKNoh6r7PxArz7pZd+nxtOX53s60zKULHtgcNgyyNNRw9aPpWGSzPARasdRhpa3k2VxaLi7hns7WWTcsC1TKU0ixrM3Y25+2zBkn/73/JO/uOoUJQC69UfUSSzkU801yK54MZfse0lM+gGwnU62Obsw9HwIw+6PkRIKP2jjxqHPMjnX9W1nMRCvz/n4+JBeXAv7jCnrpOVkU0kOjvhgnI1Do6eORPH0JJYRm1jP3l3q1us8OWAvv0cDzUSKIXOOZuybE5N7l0nAfLZ/UhuZ8POXwFPEfa2TOXl1vRwDP1l1pxonGNihMREbJULht2RRzK1/gf02zN7eYzGVPphr/5ZWKhYiTKoqZ4IeB8XMzR0+Wlp232SippIXJ0S3FkmisUeprHmrgApZf8Lih8N6adi8UloqKDEmM3WSXmt5HpUirgzO3VUaI3BLhnLbbRLe2/jAcOxysgFNwW/wF65qdscoclSG+IB
 qPY3e/aQ
 cPW1SPwO+fdt4OFM6IhDX1LjpmY9XK65a0m9BrrtMxWDqnbhigtX85S+ZKwNAaPZFWUfZdTYmSehTTOZqDWsylnsR6tBG/FPk9cvx9zsh6S5WppWNQUJj3n7c3NFFstvNyo2KqShFla3JSERXTKE/jS6AzxA+268jWsuE8WggYtbnCIhv4Xd4LWzK2CDqfTBxENvsIpfC08jV84NtepteXpReQrJRza0koTcXO5Wh8k2fkagDn6Nuh5oHQTAy6OPVlYsbanTLgHgZX4u8XM7RaDcbgm/eSK33FfklwVGJN6IEkz1Irmcmw4p+BCC+xzjT2H7/nSK6dW2oiu8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When compressed writeback is available writtenback pages
contain garbage PAGE_SIZE - obj_size trailing bytes. Zero
out those trailing bytes before writeback to a backing
device.

Suggested-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 602abfe23797..7917fc7a2a29 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2134,6 +2134,8 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page, u32 index)
 	zs_obj_read_end(zram->mem_pool, handle, size, src);
 	zcomp_stream_put(zstrm);
 
+	memzero_page(page, size, PAGE_SIZE - size);
+
 	return 0;
 }
 #endif
-- 
2.54.0.746.g67dd491aae-goog


