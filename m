Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91E6DC98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88A926B009E; Thu, 24 Sep 2026 02:23:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 814206B009F; Thu, 24 Sep 2026 02:23:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DAA06B00A0; Thu, 24 Sep 2026 02:23:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4718A6B009E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:23:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1661A5ADF
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:23:29 +0000 (UTC)
X-FDA: 85247664138.01.F02041E
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf05.hostedemail.com (Postfix) with ESMTP id 03D4C100003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:23:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RGIkzqXw;
	spf=pass (imf05.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790231008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uapzxMEthDJO/bmR1HA0Vq28uQP+GCz1/k3zL0gE+FU=;
	b=T6clGYIbce/Qw9X6yA9vCOLNRKQ0RYdqrnVrn06UFBro+2fp8fSSrkwULSe0/Im1bECwDZ
	nSjnhoTOO4wIASH5z8d2TlKotgebyS2eU/WXX2z3pxhnnVRHLafFDhWdbhKTeqYXNhEp6J
	GwLCwNcJkK2oKmSKiFY7GE9GWLQ2BPQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RGIkzqXw;
	spf=pass (imf05.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790231008;
	b=64LWHRaFitjDaiXdEonoJuGqK3lBMuHJkQPsfQbm8+70PXlTrFWzaTcW0sCTshuFsUh37Y
	nFUGNESqQhQl1z+K7TtRDpMdm5iKCva1ehqVNSgcFG6nlbYjoaxQ3AwwvKvn99ndKDdTWI
	13Xd/U5OY0/yN5jhPZKlB49GUYcDNgQ=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485b1d2874fso651625f8f.0
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790231006; x=1790835806; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uapzxMEthDJO/bmR1HA0Vq28uQP+GCz1/k3zL0gE+FU=;
        b=RGIkzqXwsRr288ojWmplOpzdYtlgGBZ6PzBaJrA7dhMb5xIgfPRcrDdCJBPdSAeVD7
         TZxKCxTRxJTI6sFFPu5Y6dWFQVKTyglhV5++C3rseB9SGyzqHaENPwoxufgTOdSggf4b
         XZgo9cSXsXtRh9hze3YtU8KgjGnGsIg4V4BEMsRh78dPBTBfuiCruKhpOzpNnNWsLR9Z
         ymUCDD59phcrPumrtLSXZSr3G8+96saCcS7xmLywBVF1xMlcmos9hl6d1wVkRTGQfBsU
         rApExzC/fnTHNZ7M07sbaDopYDaiM9lcuCxqw/U0p/MTFR70WMEZNXNLCrjdUCnpvaJW
         nBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790231006; x=1790835806;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uapzxMEthDJO/bmR1HA0Vq28uQP+GCz1/k3zL0gE+FU=;
        b=J70XweYVxlkFlHAGxE9RwDGo4CRQt/jBNZcCAHOIw2Ftz0XEByZWya2Wr/RXKTKpMk
         KC5BqD32PKPoTl2Mk7Fw1AamcP57aws5r05Vx4DUSUhkzHjMz1VuQwMNQJzZ6k1X2F0R
         Q8r4dWVSLes6G63mnNFPAiPwSpl3EfU7BfCnzqxIwPn2/+j+zXbqpoa89nDhRDAdDnmH
         sLwOKetPhb00br0Xm2ZbDaOPLn9AuKkphADUKO5P8hKY8LNjFUd1yOwJUhKL+gKqWwno
         VUb1AHCdmUD8+m61RtdwXScNcmR34UKpK2jjvJh3KjwoOLlZFdPizGdLEj3yxD0SOjIQ
         uaog==
X-Forwarded-Encrypted: i=1; AKwUvBxAOz4BmVCDr0xvBwGb2X9oFEYuoKq1v3szl63dmla1HVuVMIRJAB9X9BJWhM2mYZR4CxZh7k62mg==@kvack.org
X-Gm-Message-State: AFuF++kU5SEyWSdJoSClPjASCz+S73tyfxf4th/1621z3JETCG+BGM/R
	od2D1i2CCOD05LcMX+6oKd0PckouI9/J4zbXDEptkoib/nKUhHjkvbpm
X-Gm-Gg: AYBFou24HY9au4UIkJ/qBAisEtEPfE+N8xQ+hkAr4/9eXsMkUBx6MfIYPrVoE4fhcpI
	eOFLyc37VkbNygDdduJrS0asqS8ijdKkavZHgKsmXRg2TPq7Xy3BVmsCNEns06xhhQM0TxH7TRO
	UDa2oM+F922YisMBUWckmDC23bRZgCDTPOgoW4EfLMEyNd3LrWAjDDOQspFxZGgDuwmwXMjmezo
	sR1IGCRxCvOBEcP0OBpxr+OaYGUQyOmaPoTuLV0d1xxE/3JKdAS+ar9TxK8gx9d6qUJREi6m/6f
	AkyyDEH7jFH+TCzTmRvQpLNd/+7MNWp4xskW7s8gxmeLwdpZBpK6tKu8tz/7zhEBbWNYtzC2oix
	mOBk52ryVoGQ7QkI39GV5e7rA3i/QogbA52DJDvV70Da/Vbj6gE+YuuLPOp1SSNXhZXfmiqXgMS
	vruBZhF158igeA5oczNAHkeBTtngZTr+sZhPC2lNP06QcXSRoJ+e3E2+gaVQrFoBFKgtLni8vjE
	qtI78bSTViHmzTQr5rZSqr/QPPpvMu2CiUWm9/Gs5XCGWI2KjdAqRtyqdC0J/VfJAvCUhNeNhjk
	By/Hgb3u5C2tRwXh3k9MW4Vz+mTVsh75kqhsv1WwR0GkMhVvXveeO4m4Vau+kmsFf4EGj08FR1Q
	WK8jxDVWUyFgv3ahczK9WKL4=
X-Received: by 2002:a5d:5e03:0:b0:488:63f2:8779 with SMTP id ffacd0b85a97d-488716d236emr2306396f8f.21.1790231006325;
        Wed, 23 Sep 2026 23:23:26 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-adbf-6901-6c54-85ea-c6d5-a48d.310.pool.telefonica.de. [2a02:3100:adbf:6901:6c54:85ea:c6d5:a48d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48868889376sm9713823f8f.33.2026.09.23.23.23.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 23 Sep 2026 23:23:25 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mm: align hugetlb mappings to the huge page size
Date: Thu, 24 Sep 2026 08:23:23 +0200
Message-Id: <20260924062323.55651-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260901085740.66283-1-kmehltretter@gmail.com>
References: <20260901085740.66283-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4xrroxuuhxqxmumog7ujon4jacs5xeii
X-Rspamd-Queue-Id: 03D4C100003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790231007-926522
X-HE-Meta: U2FsdGVkX1/oGvTaleW3MOJkBYufhp8S2flvSoRufDIAxxMFM8lrdSbntBUhtBTPwObt1MtzSZ8TfDoVarfpz9diCS8m6Fv4+Y3L2Za4FMqbg9F6mSsBQfePKQx3rXqQC4frNWjCXQhSJUAeoIsRROZPoWOi7PjxtvhXgi4KRT9hOcQXX9RytJfb2HSwK1pBl0iwBKd4kkLf4pqM6gGn5H/b1TqEF5H2hdKYLw774AgQfXXSG3XaNp8e5H9jV/Oxf88EaETM1Q4dSwl8N59meQJTTria/TRZLfjZBnxdxSRPOrfSgpCQ5mSgAdIsdiSIBSjlVPaafMoKBh11INFzRT/0qVP39Q2RBFf/7BFZ7czd8ZJealt4LUnog+Pl2r2YwfyGOSUd4vhqwd99IvNk7VJKjub9lslKr8IJFBlmsprUzxkEektVk9yQSgHAAVJQv57Vvfl0+3NSy6WQ7c7sMzMP3ww3vPLu3pfoGVDXvD7dhJBT/tYwbCF15bO28lcxcEc0z5PfrVqt/ZDYuUGIIBDIBpQmEml4/Sqxme39buM0XebaiEZatktq0lLGXPnOaxewN+hx44Is3wGdUojKs3Z2M5n174S2P2kqXV/jUnH/uM4U/M0j6LD1sTQOy88DMoyJvUSSDyRNaCrbRXgLO+eQomFLLXjAawLuwZdVP/P+CG4uH/zaA6+ZeRW0ZlNR0c01r2FANVGqkG52CD8cBu9FBwUPIroses7OcxS1YGQzEJpeGPQeUr813QJU+uRdqriWxrF18HNRnHi95sfEk/jfcDtngo+m+kkgY98lDT6GEzprOCF0GQptCjiv49Y12hGHWd1JU7TJ0zP5LVAe8K/shb31kh7upjlc8BPyNK7f3mAOOM/PFpF6hdCZWeq0/qJ0xvfVl5M2QPCdP6pRQXVukL8wiA7bvdbrynyH2leUqaZvmKD8uZ9U1XjOisN9wwZgxOzSRRSsnljcUW7
 89bCtJDk
 e0GhoCNPVpko+xMfnuDUVTZ/NgO+8mNsAogG0rSEoHQ0x8B9UrTpyDu2oAMsHiD6dY3dD5e2WmVV4LGaeCk8V5tlSW07eXAIK4ZqK+/K13MAKoGyEDstbuxo031zrHThrCUGM39AvbMaL32+2BtQgX8nTJELKKkFU2POPaimRaDxGQba4b+dq48Nyzc+ivR2hMaFUpI9YRKfP/4klfTeyMtSpp08rqrXBp1iN4tOBTKmdAp0BX+auWtSm5EmkPij+/sGhpNjYnNw/B9VruCvoSokkKjK7ZzklKehVKc0k0xu2g4xT/0icW0s6DYSytvpajTFmV4ynYgckvav5+g5ycqWRiW9IifRLgtAYNmchFKBHG/1+QL50Ok17tL5JxMuCS+VZkqh8z4+OfXD6iKkCpQguqvHaWmNlPGNGRjMYmmToSWNj7hb2/Ihw/bmCWicnmgnMVVceb9moGXRK0Sv/MYNN0bPKF4oXB9lo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

A friendly ping on this patch. I came across the ARM32 alignment
issue again while testing Ackerley's HugeTLB subpool series [1]
on v7.3-rc3 in QEMU (Cortex-A15, LPAE).

I've now retested with this alignment fix applied on top of the
full series, keeping the kernel configuration and test image
unchanged. All six ordinary HugeTLB mapping and cleanup tests
pass with both one and four virtual CPUs, without the previously
observed panic.

Would someone have a chance to take a look? Happy to provide the
configuration and logs if useful.

[1] https://lore.kernel.org/r/20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com/

Thanks,
Karl

