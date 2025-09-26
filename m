Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22955CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 23:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559D18E000C; Fri, 26 Sep 2025 19:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5085F8E0001; Fri, 26 Sep 2025 19:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E228E000C; Fri, 26 Sep 2025 19:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C9E78E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:45:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C27C61407F9
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 23:45:44 +0000 (UTC)
X-FDA: 83933036208.16.FDC7EE7
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id E28F940007
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 23:45:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IDzXZKNN;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758930342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2v6l/fjiZwwbxRv7L9dB6Gm8kHK4dyhIGUYaK+C169s=;
	b=2b9os6/tEyw7VG8RRihk3saxmwokofwijXV0/smtwZAE1RmNSXU/L0zAZLHAs/sUIffEF9
	9rmiLfOOp7SJGjanDY5LvTNrp58J0UDqDEzPGZXNpbgna7+VfZVOxOcYJGndDyS4A2tAAE
	S5faICdmuxmi9AKdU9GH3FemvL5s0Sw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IDzXZKNN;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758930343; a=rsa-sha256;
	cv=none;
	b=FSVaXRDy2f6WggTvZVBqBNRB5Why38e/OE4KGDE0gQqOiyWGHv169metqFJWRAyexsz5zI
	cQ43wXV9aLwH8skvumPTpT+0lziqgn60Blnvo5yCwyN5ZO4KommYWS87tCbWysQuw7i3YS
	4yjfYckXeMuFbC2w8F5f9aDF2ooaN2s=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4de66881569so142561cf.0
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758930342; x=1759535142; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2v6l/fjiZwwbxRv7L9dB6Gm8kHK4dyhIGUYaK+C169s=;
        b=IDzXZKNNs2zSZhF+mLUq3rrxj8/Bm5kd+MB2iBEaSnvU8ywpVLuqSggTF0GsSudj5I
         ig+t/yvaCecnRuY8PTL4ukKO1i3rHCmtMqz1w9NQrf5IRi37EkeFwUTTUWmLmu9CRIrH
         TaRxi1c76OTp1YN6xasqfaV/TuiUKjjG76G+sl/MWxpMIFvCTUO/yYeqPb8lSDVBoNxA
         OveYiJIRR5eHyfoNnzaGiUCNPPJkzhz2Tr6bPjH7rcDo+dyj3O2PgrqfJ/FQd10sB9bx
         IPjBeNjnoD4/adLQjnhW2VVset05FSvGeY/UDrR3TcMxoojErYXv+vD6ZFTh6ZAmU5nC
         5cwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758930342; x=1759535142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2v6l/fjiZwwbxRv7L9dB6Gm8kHK4dyhIGUYaK+C169s=;
        b=d2byWmDZFC1Y4OgDXXH4kX3/zu+qhMvk85gLIpvbRJuSM8Dy+l0QIq7gtJaazcY9ht
         u/1fcgt/wtFWCJla/9t9RkeFyA7E6rpceOvmFP6v6eAAxRHNfefCqvElyYEGRm/hMvrg
         oF+KUOQNu5bFHaki79snoXFP/VAycLWnO6Meg/z8YdXIttc02BMTVI19dKzCZuXpTvGW
         1FToFY2UkcBcY2XsADOeCz5w7x255TG0ME8wqq1K0A48IJO5wzJSzvYo385JXPCf8Xke
         QZVjZ8zWuRx1YdssZ6Ih5/j3jPo1JoGoZHEDVHeZZ6AONDv7yTpVgS5T4PqN4WSPvLow
         CGFA==
X-Forwarded-Encrypted: i=1; AJvYcCU4fQy7J6fJ5LVwjVGYA++2yfGvPNroOvsRDkXXKxnzsKdk6f6kvFErXd/POXtMuoHbyPd4TizzYA==@kvack.org
X-Gm-Message-State: AOJu0YzYQpIX37xRqpDve0OlnGb11LIDsScrHPQXsK7MybHEuiRvoql0
	8LnRfmexYiTKfEfWad9BY7zN+KmF7RQB5u34kmz0fQ82mEIzq1G3wuHr3wynrt5HsF7MA8+NeA3
	I5PUji/cKSfFImMwmtCKG3SyqQeXvTxEr32fMucNM
X-Gm-Gg: ASbGncvNMlF83yxLZfNpKpD0OykJz1RpOTSecoRrEyv2rfnlICkIvWOrixR3e8kisiN
	/cB9BfJLrzzeginDTWGCFLLjPfwCuFPg9EclVA553uzsn3vOSInmcMqfoMwk2CK3Ranlm6f7Xfi
	n7gN/WOqia1sDDY2CTeo0ohaRr7W6OixQaWBqhUcaQd1LFfVMT9wfBVzyoCFSXulJlTdJvP7krg
	h8Bsy+MT+nz
X-Google-Smtp-Source: AGHT+IFXlGPNT84MM6UDMyxHqowIC+dEanCYd/TyBPjybtAKnhlvS2IM+5MVQP+4ScKwabi2zbY1N6OMYsUijzd9Dt4=
X-Received: by 2002:a05:622a:5286:b0:4b7:a72f:55d9 with SMTP id
 d75a77b69052e-4dec710b632mr2671331cf.13.1758930341409; Fri, 26 Sep 2025
 16:45:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz> <20250910-slub-percpu-caches-v8-16-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-16-ca3099d8352c@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 26 Sep 2025 16:45:30 -0700
X-Gm-Features: AS18NWDlkUCiWuVTsoik1lE1b7RxpxL96KRj-TH3et2oYHZB4-tROqStc3p33LE
Message-ID: <CAJuCfpF8TDS0bjksssRJyvxnr1Rbb2SpgRfRAxJmPS5oQz88dg@mail.gmail.com>
Subject: Re: [PATCH v8 16/23] tools/testing: include maple-shim.c in maple.c
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E28F940007
X-Rspamd-Server: rspam05
X-Stat-Signature: o65g61usf1dwy8rbhiknq16j8z1pfdnt
X-Rspam-User: 
X-HE-Tag: 1758930342-763809
X-HE-Meta: U2FsdGVkX19HWdvfdVmDJAQVOT7e8x8ZPTAxIsvgUn8AooJmU3C4L7uCNyjgBNYUwu/rWTNp8+Mc6qjPzwO3gv23g8HZzd67TSM6K6XbZ95wn6ZFVJ3+oyXT3nUBX1mAEI5wzwFaVPykRYw2j9QYzadNxZL9JNDiSq0YdlbJpLYznO9mbr0o2ApwWbzqwtm3rLEGGmZiZIBZGR8/iKYtRjgrTetE6H/IKREMUYxtZbIdFGyN3dEpMK6W5vlOV9wbVi5OZNvFdW3V1p9ty5VtkDjovsf3U5njYhoO+y6jkemSMIPVzu+jtZV3s7AS1i1epigbtohNE2YrptWrdfcTKn0+BVolcKn4l2c6n8MijVRWeMKgFyHkHhilDtSSOdWJ0gkTuT6Oqwn9OxLqUhmQTCvdAZQQL6YAlPl0MGrJWfYla9MkcM3EL39Sqqe/Dhzz+fO9hULnelcjEFqbLK1N+eIot8JNtiCUfIk7qrGphJ2wYJdyS+zcPIvogOpFb8LGxgd2MJXXRIvxioEQ4NiPd4Rk/YLoZDp5j93frMYLCyUBOauDvDezF4pIcRmgXmkoo21/xwv8JJNeKmZBx7P6h4GKSl67oAkhHhkrHiXai/sIPUnuPvOO4ZWU6UNtsKqG8Tl8jp8KBNcbeA04IGUPWWzppkO38FpppH9twYsn905vpXGRwWUfDYHLFHMr4Cd4QN0Ll9PzYAoSUQE9UKtjUrwuRZ+BCLvU7InnB24Ahsbp4OivPH66BFUxEY6QghuH3AaOUo8o8Im870RVCg9uanI3wOo4yrLdRHmllTIabW7u6oGgxrWwRct9sJlQSxisbvxcC8xLklV20ZrkDJM0O6mmLoz/y3zqYOT4v28Kif7zl8/8cwcUOLn3RwuGY3AtjOaNRFEH9eZCry945zU0lD1g5onEm7N3EuNqqkneo8U9ypoXtvZnK54tsTXf5Oy7u1YoVE0HJ0qQU1Tu6i4
 0AEuXNAB
 1JybUmCQB0z6bv73TeKmi/vjpDN7Z8sZGzRoc12/z88w4l60o7Jl/z9ercX2ivHgK7lM72wXuo+QlHp9ueEGMyg7IFK9qdCzztg0ul61eDT0dZMfPl8bwho09x+msb3F3gwotbAYIcFqf51o2gnpJSneK3YRI0/5+lnU3qJfqz1egkhipPHknQY32i5rHJj9A01IkqEI8zBXntgmznFzCuKhBVzV2gHK638DTWkqhMrLed7SvCoOmneGS2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:01=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> There's some duplicated code and we are about to add more functionality
> in maple-shared.h that we will need in the userspace maple test to be
> available, so include it via maple-shim.c
>
> Co-developed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  tools/testing/radix-tree/maple.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
>
> diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/=
maple.c
> index c0543060dae2510477963331fb0ccdffd78ea965..4a35e1e7c64b7ce347cbd1693=
beeaacb0c4c330e 100644
> --- a/tools/testing/radix-tree/maple.c
> +++ b/tools/testing/radix-tree/maple.c
> @@ -8,14 +8,6 @@
>   * difficult to handle in kernel tests.
>   */
>
> -#define CONFIG_DEBUG_MAPLE_TREE
> -#define CONFIG_MAPLE_SEARCH
> -#define MAPLE_32BIT (MAPLE_NODE_SLOTS > 31)
> -#include "test.h"
> -#include <stdlib.h>
> -#include <time.h>
> -#include <linux/init.h>
> -
>  #define module_init(x)
>  #define module_exit(x)
>  #define MODULE_AUTHOR(x)
> @@ -23,7 +15,9 @@
>  #define MODULE_LICENSE(x)
>  #define dump_stack()   assert(0)
>
> -#include "../../../lib/maple_tree.c"
> +#include "test.h"
> +
> +#include "../shared/maple-shim.c"
>  #include "../../../lib/test_maple_tree.c"
>
>  #define RCU_RANGE_COUNT 1000
>
> --
> 2.51.0
>

