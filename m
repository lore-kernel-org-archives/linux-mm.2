Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24653C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7E86B009E; Tue,  8 Sep 2026 05:56:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068C46B009F; Tue,  8 Sep 2026 05:56:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E986E6B00A0; Tue,  8 Sep 2026 05:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4D996B009E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:56:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E23C1204AE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:56:20 +0000 (UTC)
X-FDA: 85190139720.26.4FAFC9B
Received: from out-utut-a194.jellyfish.systems (out-utut-a194.jellyfish.systems [198.177.127.194])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6EDD014000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:56:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=DOSSsjQb;
	spf=pass (imf23.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.194 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788861378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vex2Z7sk6yPXZz+/u0iVKmqeypvzt3JwnfHpdqCuCKE=;
	b=4C6+CwDMDdOA/3nF5NabTdIHYQ0G/rHt1IQfwZJ8LWBx1C0yTketNiB4wlsxEI3mj/PyCa
	2LLzCFCls0gV9H+beROZqNGq3gYO9/yBCg8rNezhFlrYKb9XFvl2aOsqtptoBlgDB/B7Ig
	FIlJn4OfSQQnLjRT2USVCsO3y9VUbzY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788861378;
	b=QjhbEDey5oDEP3kGeAF6yDep7ELANblrnyeuSjMP78ht76s+yGXpOQebSo54KMGbzFXp/i
	S9Qea/jgy6y9K4NkmlK4GBNyRMvvF6sfBsSmvCV/r1L6X31w36dcFQqvd3qWr3KLMGybFz
	MCPaFQTPHeflLmIqYTOGeQE+mfMgS40=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=DOSSsjQb;
	spf=pass (imf23.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.194 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hfK820ZX1z2xMb;
	Tue, 08 Sep 2026 09:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788861366;
	bh=vex2Z7sk6yPXZz+/u0iVKmqeypvzt3JwnfHpdqCuCKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOSSsjQbdN/z7OIrg9U4fpJf+gF27UzsoJU7SIiwOhePNsP9hOIH86Lq+YwzYyOIO
	 V4KfB4V+Bhll4ZQO1ogTvJvzoT7ZRHwTNgsI86SQhrBeDapcQmGAMyKMMBCqrvS007
	 amy3q1tRlGoCXBWnrXRjUSYw7g/Zq9c8c3aY2RWt/NSgOiouCO635eY8gtr+1N9odD
	 iPNSteugwez7jHnBRGzfz9sg8BJ5oiiXmfqdJrXrrvj8qED0IiwG2skeCve5hi43+p
	 RXs4wFCE0Tvi3R9zXQJCq6dWQwq6U+7moCHBlAvOhDNS1cVKBM7go4U3cqVXOfbNel
	 TVdyyeY3r9rcw==
From: Tianyi Chen <hi@tychen.cc>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jsavitz@redhat.com,
	hi@tychen.cc
Subject: Re: [PATCH RESEND] selftests/mm: Exit on invalid command-line options
Date: Tue,  8 Sep 2026 17:55:34 +0800
Message-ID: <178886112560.138404.1757557703285138272.mm-cli-review-reply@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <519ef70a-679c-455f-ba5f-3841730873a4@kernel.org>
References: <20260906135444.749144-1-hi@tychen.cc> <519ef70a-679c-455f-ba5f-3841730873a4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6EDD014000B
X-Stat-Signature: 6w1rdezjj4ep9s435d4sfipbsepc8xqb
X-HE-Tag: 1788861378-236097
X-HE-Meta: U2FsdGVkX1/mJxDdu2qm1NLlgJFDkMH9bM0Z7VMWCrxs72fPvtpkAXnmnwSN4YAT/7nIqWVJLYq4GiX//kn01TQaC8WJ32fXjMODQzVUJWAgGbDtCamtwi8LPcmRGpS+AGsjtELpZZhH0mmMZTplELVtv+86dkqOQWrbP2kSncu3jZ+cCY52SRJq4LgGmy9HZS9dBDZosJd2PQBpNgaXZq8H6JXzBIe5vlBCMAX2FWOOl76pQZ9Aj2RtpPhVp06JoqQSYoU63RoS/3Rr+F5uqCwDNZbr+nvJcr5K16OC56LQOSb/44XUYCSpG/cZtFezEKhbo0Cj15kI5NK7Ioc3Ayhe051ars6uFjztoUf4NPjK5U+eJOhzXgi4M1uSsKFA8w7wFmSYP+o1Blv39Hd2kak4Rq4eKGHH+nca67Uccq0P3ubLp6vX0URiSAMV6IQ8f/QvfEj5iaJK9y3egThIJt1VHjELJKRD4NEVCHvlDjWBDMcoKrtdbMHvQWvmUW1ah8m0GiPxgPZFT7mKVlsGX7CBTo0ZyATnKjcXrOldWa21X0as573cuZ0XXCPMRZrb06b8ZG7E7amloGFTffeVJwamj/+GCf9w/qOgJ1JZZej+UXHQsd4LPkLJZIeJk8YZrR8qTnvVu/QfZCMt7hfeDkMq2pFMm1nhXTK9jYN0ZcP34+NV1J0ya5+ErGiy9tNzEnAuLQ246ZVAe8DopXREXPc/nqB6fGKdO99RidipNQkpIU0SxJdaHoeJVLnS8tn5Ht3P4UVoa2pkp7OXrLo/V3Ph42XJ+Ue+WkEOn7NUzdVQf6s7gX1OBj8Ub/hFjfxjtVg/Z5qwMB2eIM3gP4bG/y1I1HTfkvVJSB6XwMonjbHytxO+nIpDwd8YiLmx1Fc3Ag0Ve/DEnZDGVVtJk0LWdgPdAQssL+fCJYFhJvvyvbqDwzgGPnDd4DmXHi/6II4RaIEcp4u5INeWfdkr6N4
 JytcZ9fX
 11aqpZKFrFy2ULChlQC7fH4mf+qkWohwmfqJqYTJ+PGjY/WBtHH6jGCn0aHAlo9csVVTKT5AXBbeVf+ZhEyywaEm4U4hOmSqrIbZ1DxYWZsCPDxrV/ngHgHLlQpXCejkzg6xbwooXARoj/0q31ajdtagj1M4oZLIXh6vy3+N578ydcUjEN/2U1ruoeiEZ+KV+xhAMgZwh+IY4xtuJGseDlq8vJwXKMRnxKmvCl5TT5BnTQZakvHNEQ3u+HkUqbAq9M9sJUdNvh3bCo93GXhClETs5Hw5ynUZlDH/kiDmoh1Xdsw/Gbvo54AU5ZoeKhxw0UG6WGLXcy1whEiVgeFhI+Dsg7OQ2PNK1HcGuc9Ajk0CEQK/jpwxNAhZSew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for pointing these out.

Unknown categories were not validated, and an explicitly empty -t
argument fell back to the default selection. A missing -t argument is
covered by getopts error handling. I have extended the first patch to
reject empty and unknown selections before setup, while preserving the
default behavior when -t is omitted. Validation uses the existing category
list in usage(), so there is no second category list to keep synchronized.

The ptrace_scope setup was indeed outside the category check. I have added
a separate patch to run it only when memfd_secret is selected and its
executable is present. The behavior when that test is selected is unchanged.

The v2 two-patch series and focused validation details are here:
https://lore.kernel.org/r/178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc

The real mmap and memfd_secret tests passed in the guest. The configuration
write check used a disposable file at the sysctl path because that kernel
does not enable Yama; it verifies the script's gating, not Yama enforcement.

Thanks,
Tianyi

