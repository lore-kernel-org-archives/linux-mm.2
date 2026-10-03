Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B806CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 14:55:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D8926B008C; Sat,  3 Oct 2026 10:55:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B22C6B0092; Sat,  3 Oct 2026 10:55:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30796B0093; Sat,  3 Oct 2026 10:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAFD66B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:55:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B5ACA7802
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:55:52 +0000 (UTC)
X-FDA: 85281614544.23.CAE7B75
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7B8C740005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:55:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CF3kLGwD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791039350;
	b=FlryryZR9leWlh/VkbZuktig3s9ave72pCxnyrZF1lh87WAb4G0XhqTJID5hZEEX0vdOGb
	u5SY5XRNnSgSuNURCZ42vSzpSgNjQqOP7O/jJAgWGEKHYnWeMQqsWw2jZHkzwBMEJE9gRA
	M/38QJLavILc5F6i0/YX3c5uCFmdl20=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CF3kLGwD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791039350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+Aejwp62NAjE670ErqLzn8fectXSGBwtu7EOzdsFnY=;
	b=PJjvP9sPs/Qa5JbohNCpMs01EZ2AZI2Cr1jsO2PcdIDFMuJto0k8bANW58ABvLbpsPqv7C
	fOpIG3k0dlVnbZe7/3HxulDQYPnxVGLSuLPMQi4wIqDvaKs7Wb+ZsG/nmbSmQFrCLYbMtL
	UxKAldm7XSMlqkc1xON1L2hiwB1jKac=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c264788fd58so115805766b.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 07:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791039349; x=1791644149; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=o+Aejwp62NAjE670ErqLzn8fectXSGBwtu7EOzdsFnY=;
        b=CF3kLGwDTu7liyeuKZxn8wAlk1DzkEEkr0EPeNHiLaYpQVStBs8cFTWw/26uz4TxSb
         twRmwXhziUEZxl2OnCMUxth+XbXKitBG2n9J3x1CDvRw4yXbe2+atgBRn1rydB63kQil
         mINnpmoDxv6sbYNwd+3icMQJLom6yigNH2PqmU6m9kgmeRA2k14uURdINtAa/6cjeN/+
         18dJT7G07wXMNQ8QZrLk+Z0622IJeGLA3puCy/6b9Vjt5QKKOREC3iyqTAjZuz0Pq01A
         Ed13o1RYKOal+NmPfXLDJJy8z98RJiaZl0jiyKLbM8W/rM1zg6FcJRV9TzVzD1Ub4bDg
         7uDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791039349; x=1791644149;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=o+Aejwp62NAjE670ErqLzn8fectXSGBwtu7EOzdsFnY=;
        b=L72Qx78MpOiQZtPtIbs08B4zRHinFYPAC1UJkXWilTsazvMi7GupyjYNP7FuIjmpsN
         dw24RGQk/l8S1TM2LBSNbbS8/eU9YkKAKfjtrlF2mzfrn7QbTB+h7VrEqPNQFjY9LZ6/
         mIkY+wyzVkJTQ9cjLsqv6SQUDXG7ZD63xC7q5QaFPLzD7DK/gEDs0BJA4N6zvPrJGn9+
         XjVqVJyMFISGnePfd/eeA9+N2Yz383jpvrLhAAlFkDFbGvu9nNFfrRQsTu1eAh/b5veL
         nH8ey0sRS38uYxEjoSe7ij7jHSagojZJ2lyavHn1dVmPcnFDwxleqZiAIze/kajHMRa0
         MDlQ==
X-Forwarded-Encrypted: i=1; AKwUvByiS/if6KXYe51TyLNDmCJtS1LJY+m3FJOfDxGtQpy+XZkDI32zxrD7RH/PLJQplyn2iih6CRhFQg==@kvack.org
X-Gm-Message-State: AFuF++kwngL7hC1xUMUkcs6CpBqbq84uby8qM9x/DMWsUQ7df25adxkI
	VAC2t8Pw0946kwbB2dJlSPNaWxZj6fC0D3Utz8Cr0TUVO7s8YGNP2Qt4
X-Gm-Gg: AYBFou0IViM4gjByWlr/sdNe1Vs/7qvInGvhsVAVzZReBTpZf+T5pK9n1KSa9FASI7z
	k4+pGnoxYkhtSuUqJ/6oKBZPtD7OuMf1y1SEHTiFfWBZAdGznbmx2yVRbJDfwqXzh1ZLmT4m0x+
	cOyug6jHFxFLDqlRCBNNvja1raw0gohBZVVbG676LFQrspfwH2pH9uqUcrvuIF2GNtM83ZB3oPG
	U7ivpHnQ5ShbzarnyZnKnnQ13ti5YSVdtxbIpx8dnEj7ZIPgXHye48q+VSaQt4BeICp7f9duCjP
	6771c3oqdiYi6m6nAe48DLm4ZsXRBRqIaNYHPuU7yQ4Bwil1hok6iLTjuzMyRCvUhU/V2DLGU4a
	1uXA72MdswNoWPkXtjpCEQHJyrBah/ZyozQ+6AX24zZsiy7FKW+VmIFwYZTaC+GEdJP03V/3PdU
	qSb8Qg1EmrUQXdQkBnuO+RdjxtlD6j07AG32QEuHcsthEFAQg=
X-Received: by 2002:a17:907:7fa8:b0:c2e:4292:d26b with SMTP id a640c23a62f3a-c2e4aac022dmr509937366b.17.1791039348809;
        Sat, 03 Oct 2026 07:55:48 -0700 (PDT)
Received: from pc636 ([2001:9b1:d5a0:a500::800])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e4cd26bf8sm198418566b.35.2026.10.03.07.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 07:55:48 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Sat, 3 Oct 2026 16:55:45 +0200
To: Barry Song <baohua@kernel.org>, Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
	urezki@gmail.com, dev.jain@arm.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Wen Jiang <jiangwen6@xiaomi.com>
Subject: Re: [PATCH] mm/vmalloc: bail out early on invalid page_shift in
 __vmap_pages_range_noflush()
Message-ID: <asEXcVSK1XL-tIa3@pc636>
References: <20261003090430.91664-1-jiangwenxiaomi@gmail.com>
 <CAGsJ_4xWAd=VHPdGhS2AHKag2WhFA=_3MSOPuyt3ksKH9ezQ7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xWAd=VHPdGhS2AHKag2WhFA=_3MSOPuyt3ksKH9ezQ7g@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: chedo8dnccftjhn7bunj5a6q415n8b9g
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B8C740005
X-HE-Tag: 1791039350-624017
X-HE-Meta: U2FsdGVkX18gB4E7FepGvjat1g0zgxjiXN2i/FDp8NlqN/hlfHiskveUKieDdEojtS5ORPrfzW0QNHMSM8weqenEU1oubObg9QLZz2csvI7caOdPGHqE7off9UK4UKU74xzwsg1VN0tL+3X+w4Z6oU+aCKbAMFdSDZ0IjuzOW/9ydKX+RTUW9R06OcR6++f3N9Bz4ff408x2NxyUi+aT0Z3dDEKK1CXXdlMHKKYPKKBA0+hFXR5l4m9uzKw9IOzy/J4Jzv8RiAFNEgIhryVHLsnBHKVL5cfSBf5Xk6ph0209+huEzkcSM61TfZGvqTICDdy10VkZF88o0z27xfMsjr7GSZa9a4wzC5f8Ye2BNwNLS72ckUoyRhs59vg5+oX0kzmpU7QOB/uejI4QICc7FkyDktPGDjvCZohrgYLWLclxJHJ3frjKRbPPBUaxvjLDmsOQCRgy/5XmsqCknmUz3nBqPuR39zcoZJrDt+AV4y93uaDPcfG2U9v6LBxbz97vb3PiDg/EKLlIzIIM7tIciaWWvqnqBsmp64WXoSfMpzAxIeycJkXlk++C4pBt4foVeuxG4T8Ac3f/gb9CYeb6VHbkUbBJff+G22T6shk1EWzB7G/slmx4b5088WQ/+Ewh1DYdXEwair/7Qcfay+lleDBZyR9HO0wMPA/hQrWycaDwDBO2jJfzNKbzV1n3Tk6OwNyVQ3lCoSg669RzrctHbwdrcMqMQlIaLa3iDo5Rs7TKvAF0fXsN+9EMG3AqpIQHubxUKxnn00iA4GN9gwcazJ18vZ7996ybf8MVQT86Oj5xwON0auwmcr0oyhyhanpaIwxUrZrI0SPwIhyKLUdjZHRuseNq1veUchLgbWRTPA71fTYi1cWXTDz+Z29tJv/mLY6Dq+E22DTQtmqLabYpCCGkWB8TkE6TvWfWMblvRRT5AmJEUzC5yfEeXWtDVzPuZ+P7aKbHt5ECZ9bDiMc
 gY2XU6fP
 7Cxo2i7gAMNxJnq4DT120syUJttrsVJyySBdU6DfORbQ4oGG1vhzIqEThUpIm0sDNUtaELMhjeGkZ6Sbd9oxYOLy8abrwh5Aqc5oR9bLzUxDJjTjZr7VlvSQP71Kb9DGKviVgJGMylTJTqp+M7rsVedxg0kp9WNLlzxqv7QJjb3O1GBrpFBhSqCEgE7ijOJh+TKZTsARdO66oAo2osDUT9rvxMH+KBugDK9iuBfgdMCZMHT1tiNVKax3ytgx7mghVap8SwW9yh0zwbM2zL852jdtqGHRBxzZnM1eF7L1+3F05rVwOil30RPWkPu72DND8qcYPW7zCG1lq6KcD1NMM+mIe+hIP9B0t4dA/LcM997K0a1TNgCz/4m5Er1TfBAXcl8MLba4Tp5u1/D531IcS00ANXMt6r/G/HnrpAEolTk19UiuqVFaqBbiejLJrXXpyhLDty5XTrRIetOjmDrXp5mzSKaTaxDFiBRr9w8H1rsYQmMfTy9g+a5fDvPTMo/mG1IhvCpz0LGjn7vJ2p+lnJsru8M0RnUkfnTnI8PQkhm4tTcNgfcrQ25JopduCcG6cz5YvelOsQFLTES4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 06:02:37PM +0800, Barry Song wrote:
> On Sat, Oct 3, 2026 at 5:05 PM Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
> >
> > __vmap_pages_range_noflush() currently only warns when page_shift is
> > smaller than PAGE_SHIFT, then continues with the invalid shift. Return
> > -EINVAL instead so the bogus argument is caught immediately.
> >
> > Suggested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> 
> I have checked this carefully and confirmed that this is a correct cleanup.
> 
> However, when I applied your patch, I noticed that the author and
> Signed-off-by do not match.
> 
> Author: Wen Jiang <jiangwenxiaomi@gmail.com>
> Date:   Sat Oct 3 17:04:30 2026 +0800
> 
>     mm/vmalloc: bail out early on invalid page_shift in
> __vmap_pages_range_noflush()
>     ...
>     Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> 
> 
> So please send a v2 to fix this, and feel free to include:
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> 
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

