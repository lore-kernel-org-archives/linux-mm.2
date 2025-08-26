Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FF43CA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B574E8E0101; Tue, 26 Aug 2025 15:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08748E00FB; Tue, 26 Aug 2025 15:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D0208E0101; Tue, 26 Aug 2025 15:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81B018E00FB
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:34:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E51358057
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:34:07 +0000 (UTC)
X-FDA: 83819909334.21.66629D1
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4FE31C0005
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:34:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HxidbnxD;
	spf=pass (imf10.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756236845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UgrS4RlDzmuPVEoYRuL5n3FdVX6RzYDiuXN16UyzzCo=;
	b=su2J3HV7hRb4757LX0YSm5rMuEQLTUKmUoWQKnEn6v5YpWk24Eoa6HQ8d8Kiq6OZgWjG3G
	Sw9ydHRBBab6ml/uhgDttyIHhcbXHNexgl+fxD962loOcXrBb804dAxd7n20yCF3dreq9i
	xrj9IfLUK6dWb0XakFoh3Mb2/90pbnQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HxidbnxD;
	spf=pass (imf10.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756236845; a=rsa-sha256;
	cv=none;
	b=MpGQ1X6SwEm4nc0B7IH+AEOE0+AG0gL01nW62n5crihIjRqQQawtcYDnLPuuLFLM2xXxeN
	fwyLR/ilocp82Gi1sGiD6bb8/un+2z8qXFHBW7JZ3zSsImIdOMHd1NNU8GdIKkZeDUKZ6l
	Hv6TsSHxzlsjfOvtGkTqnaWazoBxLDY=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-770522b34d1so209580b3a.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756236844; x=1756841644; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UgrS4RlDzmuPVEoYRuL5n3FdVX6RzYDiuXN16UyzzCo=;
        b=HxidbnxD66b6woC8hVjxx6l9/zZ+03RigwuthMUDHSan5fbLq80EZz2LOPPpf4eiCd
         ZKGaARNFWFBi9KVAmAX9hiVDv352QuRS57/o7RjdmejGhpTifTiwgRO4zrPJter+8wtc
         GNv/TC8rS1YfUDXZ17lLdLV9WUG2JvVa05hwR3fWWFh8flGfzMkCygxTVBo+QbMCpbao
         FY2PaCz4mKLa+GZvcJci9mMAfRsiW08A6eM7cvkXKMaldHthqiJNBgOd9JErXBCBL3mi
         54JWkyCsn8fceXOh/QcOgxRQwXWxHI5W/mPdBjxD9MtSCctbjwwlEVj39LtG2zV03HX2
         HuNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756236844; x=1756841644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UgrS4RlDzmuPVEoYRuL5n3FdVX6RzYDiuXN16UyzzCo=;
        b=Tx5PEnP5F0mAjteLCEcrT9ozSD75c/DfN76TzoBTaxr2ljYd6TvMqqadf93VS+8fww
         8UDCWGiHbjx5mIw6nIaG4h41yyZsDAZzDOUAt/es3H2NcG8FTO14qWZs/vHQzgJt/f9a
         0WTJH22l5bP/JwlvoxroiWsB6+yaSAS0hf7Ek00cSaJUdUVoL7Hg3NK98lct9THsHdeu
         F3HGgo9ndJNx6X2ZhGbwNX52OO5/UPlt5Fn72YwRGonwI3WulAOwcsdESiIo9WzjZA53
         8tcqeJhxRI2Kq2yrEq5z6Z2TeS+rcbrmtJGe5UY6vD1SgbEH9ZtmVRulyMMjhAdPegkf
         HeFg==
X-Gm-Message-State: AOJu0Yys+ZnEHw4Qj0NYs/B1WQ4j7Zumeq8De+TdJQM+wsIlSgpbIuu5
	6W3g735nUfi2OxCyD3mXAfCHsw7l8QCbWZJ0lLwoiobQ9gbhLVSvuCmJPhq18w==
X-Gm-Gg: ASbGncs06pFAmk6BXnFuE05lRZlSrY18ZUpCqDGMap7l3eGf/CktnzeRgJjnOvqYNg7
	h3J3lhbr2N1jnsMsnxwLvIXfx/na4o0RKGJWgEBOCfG3BhV3FsDDtUW2OXRwJbdQ/yw3Nq1qGxt
	pOL13N4kJcUCFVOqj+1djghsInAcOBRDT4B2A9ckEYEerPGrNjYtziUD+sHFaIMNIIdyRwL/wkf
	gIKHbLlDOvpvSLGMJAq5x7NWNg5phpSSDty2f97xPJmzNRd0VOmW1nF61K41zSEwV2M9BVOAtk3
	bhuPqMiNMLdiG6EfESmxNxw8IfHNYyg+q5eeEBqNeINHthQTDofx8s2579vSKvYKHA1ipL8yIK2
	5rQTp+qFf68ExQN5CAffmtZMR66x2MakC27ptk8SLa8GjiHD+QMZEiA==
X-Google-Smtp-Source: AGHT+IH/E8LX9DdP14eamZ2LRF4BG3tJOFJ+GpntOt1nypltTCHQQ8wSzlJBqbosmyTo6axuqcj0Nw==
X-Received: by 2002:a05:6a20:a12c:b0:240:d246:dacc with SMTP id adf61e73a8af0-2438fad3083mr3720822637.10.1756236843741;
        Tue, 26 Aug 2025 12:34:03 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7705647e03esm8054053b3a.59.2025.08.26.12.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 12:34:02 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH 7/7] virtio_balloon: Stop calling page_address() in free_pages()
Date: Tue, 26 Aug 2025 12:32:58 -0700
Message-ID: <20250826193258.902608-8-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826193258.902608-1-vishal.moola@gmail.com>
References: <20250826193258.902608-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4FE31C0005
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ir388ggzj7b6uj1n3qewpx3sghmz5rpf
X-HE-Tag: 1756236845-789693
X-HE-Meta: U2FsdGVkX19hVt+lpliVBeGbA8+vxSoh1DFCv6jTY/AxF72B7Mqj8gePatOuRGAe/NvMr7uazS61g3nm0fyYF9zVnr+eyCYfuP7ZM7rUkALG6Mw6peCxJcNKbcr7UmlnOM/Z7/xzxAOjEJWTBzcRRDPU+nordQw54DZ0hQawkYZPAJ5dmWzf3uIFQ1ZFqANIOJzdmIXSSpHVt4oSPQ5nJR2G89o5y94qTAbVVTLlmDd9YKTS0yxcC+iyL/6u9+s5CzoC8BoUmgLLb8B/B+w5mrTAx1v5h6yDGcg/bd8vjAMeF0c6izL3k8HZePy5CT0nE9Uzip/FqkJaDhEKk8RPkQlLcUzc8C89KG8UWh/DHr30td+b5PTsllu8cC9sfI8XtNo8buU8KoAAVcgtqxu54kjiBu+kQvBdXAZNT3ogPtfASSFIETBXN/yBgUgO+BrCK20/0LCazVByQZ+8YJXpBCSe8mYpcVpTP7f49beL4WDJ8kq4TW58KtI3KS+BXHJpxxp1KmsQHkwfru1GyHbLAS8qMf0owrTBPfgxxZ8/62r8mw+emSlCUvmFa5uiCX63qqcphV56ZJqW5jXyiHsaxiyo5OHtWURi7/IFeri+C+RSoGqVsMS3/X0VmEZ2JblboZ8A/Hpe04c9C2dbgtW+G8HotlBrCROycG+KB/uzQVh72cAGJf4SuEXJp1W/wmhzQYjGI6d+nVmAsdn4yXj0quiocvRkqRqkiGXgo4wo4a4sQSJIRUtXWG0b/noJj5ARB/k0gYS/3+6iK4jG2CD9PH7zhfEoAY8DIegEmQ93Rmbj2hJRmLo7WLNfv31YBdWXPdmJkqObS3HyLYcx8qxS4MNqdJd6YYf4QHUR6LJv79ilqS/8ZpptS8ALgXW7HEaRj8ZMxUYElKTDYgghfjeswNvqLeSFhwUcO2IlcdX0xKhye0d73NFDIYMOlG3uX0Fpsod9GnAk8Ax6reVrv3t
 q4Le3+d9
 YM51a3er6KzOqUXqBhMFSnaK+O45psDu7vAPrXFLC1L8GWJfVvh0ifAKguwS6eFfeYU6H2HI1omoMjYiccn3o4e6X8UkQqic8NxaO8InpHenaFxvrVqQbrlyXKAkdKwuxFTwJ22Ke3qTU6ufP44TXCz+C3L8zzrjterpLaOhjtN4vGkkES4QJQ6FeR1KckcmWoqGHDcUKys2/7vp58QqvmSrpqcxe0DBg0RpQ9lXRcV6Mwx05taB+gFsMhg6Pr6b8ykXZfyWoXMqSrtfVKQhpr7D/OcYm+sQU8mn9/ejavfMPRbVmvLYbaJfCjT0YJcRbZ6Uj6pgafxud97wqbTNDY6HLZ13qJwiQVX7GudDtR3NlVfm9hPOUNibxvBV90O+E8iE1oSQB4C/C1yKg7gHF7msoUptEJjZmPD4Gzn0l4BHerXt9rrVjC/lj7sCVgZI40vmMW6FzTVq7mbrqVNNizOvbDX7YZM/ozAOCeFwbsVK2bulQb+b3oTTF0F2Yc7G6FUWU1Vf2pjErxOs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages() should be used when we only have a virtual address. We
should call __free_pages() directly on our page instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 drivers/virtio/virtio_balloon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index eae65136cdfb..d4e6865ce355 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -488,8 +488,7 @@ static unsigned long return_free_pages_to_mm(struct virtio_balloon *vb,
 		page = balloon_page_pop(&vb->free_page_list);
 		if (!page)
 			break;
-		free_pages((unsigned long)page_address(page),
-			   VIRTIO_BALLOON_HINT_BLOCK_ORDER);
+		__free_pages(page, VIRTIO_BALLOON_HINT_BLOCK_ORDER);
 	}
 	vb->num_free_page_blocks -= num_returned;
 	spin_unlock_irq(&vb->free_page_list_lock);
-- 
2.51.0


