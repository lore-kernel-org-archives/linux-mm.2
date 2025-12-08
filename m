Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E49BD3B7F3
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7286B000D; Mon,  8 Dec 2025 09:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5875B6B000E; Mon,  8 Dec 2025 09:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 476D56B0010; Mon,  8 Dec 2025 09:36:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC7C6B000D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:36:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E764F566FF
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:39 +0000 (UTC)
X-FDA: 84196554918.06.BC87F09
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1BBAA40019
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XyaayiYn;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204598; a=rsa-sha256;
	cv=none;
	b=Dy4S5vEzs4V8vhYuu228df1UThxbCJbH78mEtRbtihqTHjcpgo9uCjsAnb0TcmXrP0ZNS+
	0sXwzlHNT2C0iklMRNbV+xyeKVOl0jGof/o0xOSGeGFnPToUamdxP24VtWK+z6K+8zDAb3
	V43WmwtGcb+2GnxzINQS5VOyhcT3GOI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=cjFYu/hEh9TmD0iasH9RVCyheGtQkZkQJKIdNG3QaD8=;
	b=GXOug4zDORdYmL9IrD5juzhKvFFfiTLGuRxVtKwadw8FO3KE7oEq8st8z8dWaksVonQRkD
	H8dpVwPKubq7lg9rgvn7utioYL2tMBBiUM0GyKzWG8+aCShajVC5lH49NxUyL/68v/5j2y
	I7o7ve0kZDQ015LJFHCe+lu48/VV8CY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XyaayiYn;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b7370698a8eso615988966b.0
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 06:36:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765204597; x=1765809397; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cjFYu/hEh9TmD0iasH9RVCyheGtQkZkQJKIdNG3QaD8=;
        b=XyaayiYnXt3nHI1VWUolkUaV2UpC4FUdPMgo+3U/cRqzZEqiXDBHu9Er+wEhcNDxU5
         BUCv6CfLVejvSzTqMEA5+mHNztEKpyepYu41dqhim4jLxtOSUQ3rF0cVi6y8yTzym+0v
         RNonIE4D/y7HUTKu8DBGPJMb4p+LrH4RyqzgEYrXYEmeX4+HK39tmXMo0THeCsTchv7C
         ZwUVfvfKjf24bo/hV+znBO25OqLF5tiwTKBew5pk9G2emrZ9e0jJUDcLH+JnTSgXt3Jv
         TaKD1u+zn27VNyYl34yih4+dEPnarUtG+vNPg238Wply+K3VX4h1kadQ59AbbPtbX7MB
         8/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765204597; x=1765809397;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cjFYu/hEh9TmD0iasH9RVCyheGtQkZkQJKIdNG3QaD8=;
        b=Zjz8zx211QHQCOoJ0A0B2CoakyA6KeGTwIUPMIs3DfaQRYJOCAnf6J9C8ax6sL1U0X
         ymUIbh/kI8HS0iP95LMNYrXi1PQSImkKgC+XUy3vSqJw+swLThQBNhdk8H7kQi2cXHXz
         R6ieC6vqZQ3JkkuB1/AeUS97Y+LjoBxHpzBGXlGjvPbIGylyU4hSoQ8wi3TAHgWJ9nJg
         RN2IE+fN+t4Wo2RN3J4w4pwWiu0Ubc7QIaL5EMGVy5uV40LFPtLw8f5tXwEeZ1V2LU4M
         +npjnWpCVLgTiGLP8E/xEIf4w5Y1tI/GnWaZOvbO34UIM1TODQO5P/lAbrhTCR9+eE7K
         fWvA==
X-Gm-Message-State: AOJu0YzzhlDB54T9dIpgA8VlysSb5Ruy8ZcTdzsUbX1qKIQNxf9Kx3ER
	82qM9f11GSMmT6TYs/VoY8cLDARXHLb/ZNSHGgwnMFx8ahVr6Sd8XTfM
X-Gm-Gg: ASbGncshf2O2FI7NuhtudEkclDvPU8QlUeGhEiU8lcDzJb6SlqFFUJz0atYeGk6EC/i
	sHjoWg5YJ7+oNf7aRuyPkFccfua5bHeFPoY1wzsn4+1YaAErHucuEuzfLheB0RLfvOJBMI/D/bB
	SNOK9AZhzjPD6a3Di3XQnzXfnS1YEYRv+xBpozcnBzVHCjlkkF8uqucDPY6DQCu7FZ+AW4JwwfC
	OhE7K68H7AcQ7eFmkX4BWrJ5xb+tiIc96HQvuf4C7M8y3mx6cYK/VaNoASsCiTNhELM6B+fFimL
	ThyHnggbR6pCTuZDJKiaCTH9XnCIZX5BsNjnbJJh5j4az+xtCRSrFW77608EIsqL8CywqnZ9q9w
	5EAmAmfAt0VQG8328a3dFXpZMOg5tcNSwMDeRqpJQB5JMlY3WlerlzZtAYLgW2zX9J456B33Vui
	Z+L7qxAoFlfQ==
X-Google-Smtp-Source: AGHT+IGkmQNhp21/HamwRub55zQheMGRBDgtYifzzhtaLBx0hYjCF9TivuYFCSfKD1b4SaByQtRRqA==
X-Received: by 2002:a17:907:7f9e:b0:b73:6998:7bcd with SMTP id a640c23a62f3a-b7a2430479fmr808492566b.23.1765204596436;
        Mon, 08 Dec 2025 06:36:36 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f4976003sm1082306166b.36.2025.12.08.06.36.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Dec 2025 06:36:36 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch  05/11] mm/huge_memory: remove unused function split_huge_page_to_order()
Date: Mon,  8 Dec 2025 14:36:10 +0000
Message-Id: <20251208143616.20797-6-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251208143616.20797-1-richard.weiyang@gmail.com>
References: <20251208143616.20797-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: 1BBAA40019
X-Stat-Signature: umabqxogtnzuzd1fhegfadjgwzqgy49t
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765204597-542250
X-HE-Meta: U2FsdGVkX1/3x7ElB2d+Jf0ecGg+Fv0b1Tp8T5KDL5ryKkc36K4OGCk/XogWmaQbFxyelG17H2lP+iPfmxUy3qqYiFbWFmet9gvwO513FShCLLGUVYY9TA3+hYrRMZsaksG3u3+gXzQxpWDgqBuloMBJpXtEdc3xEmu2RlldY562++lIZmHX+OeZ3nW3rQ0HiElNVBzAMSdXPM99/SV/onGLfKSvGzrQ5HGriBnCYnWZxaTvndbQvgXUEFzd8+KHEPBZbe6jEX4DUAqNRxbAGbpElXrQyMXM1/YKcC+bkPXx8oleRE7M/8XAbZ6jC19fWLn1xgjWhzLev7f12lp/2sY069Dey0TMTa+afWJPFMNMDQQ/V9iX1wJVfRepePAQg9f+6+MRH4A7q5wfSjlnSnIVtXwhXCEANwEyEGH3ND4BAckrGX6Bt2f2ccCxPUMa2JJ/QwEW144dEwRgywBoNshv4gljxYAdvN0f3H6tsFivkuPMsytof80IcApEGUYAk6AZ6jOh2nNpjMA1rb16dmqbM6IpyE45H60tLFF41diIdSphMIwACnXJfoU+n3fJ4SfSD18q+2oApKe6bhg///q/7EHzYdef6jVuZqcSytNuY1x3vwsYPZ04UYqW6pJ/LZqxnKnzSIpE21A8Pr5KVVKm0Yd+Zu9T1D6eHtw+Ez6mupnRKNWgvATAZWYQ13Np3ZRi88AdFcvzTjQKOaKS/N1IkPuiP7zGuDB+PkiOjNovr2eEv0cKlvmZbF4Dc7MqIjKD48sJ2Sj4TV0Z4Ee0pBgZJCpWzhAUHcJL8C6fxcdfJQIW2pSlwxzopLBqJR0AlPiA42viimGsyrtWzVbypYyBKOuzyDbw1Ay9cXQXF8t4e0Z0P5wLi4PM9WpidsDpc1qx0Sj/uFzDxV7SOC7GzwfvDmkAoFRqtpZipjW+WZe+rd2m93nyA+wfHSiEQsc543OXGoW2EKs85g+Lr+T
 qwhajNNv
 70ggHXkOrlRDVnu8DYXUUlamhGGXAU5PjSE4RJhSY/+pHHyqTjBTLy0b9DA9XGgfOCWFhxsPh4mEKp+uRz93UsPboR+24++xDQTLslJXtjpWCOQpxearUe0JY9yisknTfpoh8olgsneGX8vqENQXGZPy+tQAys634UmuMpHamy5bFhIeWGvnXynu/80qQM0zmgNrVvnzfK2YJiJ78osDki0k133dsKBYCGA/1XvwBViRNJhOYzsCgz7dDHhGkZg0lifjFbfvTvjVwu0uQG5p0zlGBzu1zbWK88vinzCzWgsRL1Oxc8qd0JGaGtdlmeJCNIGibO4A69hAWLBvhURzoq5wgyVOKNIiT2nI2/sLOTLvyA6WfAUE6KXwhMACKrAvyHltMlNITH1UjQbwj2hWKRKLgfe0FgOilncJhpeAMCBrDfahAmcNT9zvlEzIgqSv8M9IdvhZ9Dc93ZwX8bUWVDoxoQqK0+4j6xdcyHtxrb7BTTLXzxogQxVjrTNlhMgisFRF4avlA1gWmqjA85l/Ea67PHM6dkuNjdRNzfn4p0EJC2Zk0d1DJAu3E0cnLe188KN6llYjoBs5rdnwvGTLD0JPJ02/Ycp6p5bpZiqC2d4hGxSM4EOSEkQFSrrPsLkXQ0gXr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function split_huge_page_to_order() is no longer called by any part
of the codebase.

This commit removes the function entirely, cleaning up the code and
eliminating dead API.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 include/linux/huge_mm.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 872b4ed2a477..cf38ed6b9835 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -384,10 +384,6 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
 {
 	return __split_huge_page_to_list_to_order(page, list, new_order);
 }
-static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
-{
-	return split_huge_page_to_list_to_order(page, NULL, new_order);
-}
 
 static inline int split_folio_to_order(struct folio *folio, int new_order)
 {
@@ -624,11 +620,6 @@ split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 	VM_WARN_ON_ONCE_PAGE(1, page);
 	return -EINVAL;
 }
-static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
-{
-	VM_WARN_ON_ONCE_PAGE(1, page);
-	return -EINVAL;
-}
 static inline int split_huge_page(struct page *page)
 {
 	VM_WARN_ON_ONCE_PAGE(1, page);
-- 
2.34.1


