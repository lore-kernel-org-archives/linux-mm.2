Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1AA8C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14EF16B009E; Tue,  8 Sep 2026 07:37:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100186B009F; Tue,  8 Sep 2026 07:37:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0184D6B00A0; Tue,  8 Sep 2026 07:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4B686B009E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:37:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C619114051C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:37:20 +0000 (UTC)
X-FDA: 85190394240.18.0BFE6CB
Received: from out-93wp-a21.jellyfish.systems (out-93wp-a21.jellyfish.systems [104.207.68.21])
	by imf07.hostedemail.com (Postfix) with ESMTP id CCE6B40008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:37:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=Nxl9mdJ8;
	spf=pass (imf07.hostedemail.com: domain of hi@tychen.cc designates 104.207.68.21 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788867439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DYtkG5eG6DoTS3vTisVjA24TxwzME87b4xPkQ0ZQa6Q=;
	b=Dl8ELItwxFuIuM3nvhqO9kCtkqsmb9vCvUsfW5hlbnk7/eLKuWLVR7a5sMDQT5RUwJ/6iN
	fGaSPPJZrDY7xdkfyem53u3cyTs2BOEDgVb5eReUI6yXxx72Fg/am6E6EYrnHY1U4C0ElB
	m0wlMmyvgTzVOEmF8dkrTBJ49i9p91c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=Nxl9mdJ8;
	spf=pass (imf07.hostedemail.com: domain of hi@tychen.cc designates 104.207.68.21 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788867439;
	b=8r0jCEnr/hkf3fmCM6mYMmweCyWyXZCb26OxDk+lfTMBqpFMbZBuE2PyzdnUJSoAwk/kg6
	gNY3EXsp8iYerXCEpng3YVioyhQC1tbBUKsl4ON+83VjSS2iIzStQu6JMFykyqpcOc3dnO
	zrW68YUyWu70xm4rU52nWSjmyRJEHRU=
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hfMNd6h7rz8sWb;
	Tue, 08 Sep 2026 11:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788867428;
	bh=DYtkG5eG6DoTS3vTisVjA24TxwzME87b4xPkQ0ZQa6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nxl9mdJ8jj7TM+N0k/QYmn/qoJ+tCm6pofdYlKsBv+OBfhAT2nczd8KUwocLO1ab2
	 fYCtIjinhPCCJRzHLcOxm1gSyZII7F/v8dZk94HU3ZM7Ouju6dODQemqZb3TxLw31s
	 7uZmT2CRCFyM7NDnH58uvtsz8DaJ6LoPq9nonKtW1NzS3V0vb05EmvB97dy/Ggn8E6
	 0GLQ9UFUOm2FsJX2VEK+LuAd8ej+BX3y8s6sw+b/pyb/7t9lrdNjxEarM5+UthfQRr
	 Bp777HhDBru+l2sU6Z6jrM5wDMtzvWEdo9RaB5vvTnmT2nuahVb1Lztor+h/7/9lJD
	 wLmo+SDfO7ERw==
From: Tianyi Chen <hi@tychen.cc>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jsavitz@redhat.com,
	hi@tychen.cc
Subject: Re: [PATCH v2 1/2] selftests/mm: Reject invalid test selections before running tests
Date: Tue,  8 Sep 2026 19:36:54 +0800
Message-ID: <178886714090.169611.12955654246896994486.mm-v2-review-reply@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <d6ca7f47-39bb-43b4-92d6-63ccc148ebdd@kernel.org>
References: <20260906135444.749144-1-hi@tychen.cc> <178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc> <178886112560.138404.14562368683011041790.mm-cli-v2-1@tychen.cc> <d6ca7f47-39bb-43b4-92d6-63ccc148ebdd@kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CCE6B40008
X-Stat-Signature: na3jcmdfi6d58pnu4idspmenrbog8ej5
X-Rspam-User: 
X-HE-Tag: 1788867438-224230
X-HE-Meta: U2FsdGVkX1+BCKS+65HEK9W5uNoiVlXK4Lzrw6P/ZqP4Hdp6wxNUqIg2jHsccLbQPffy3sTf2Mdy4ByGo15rSuDXi1Zs2dyzX47EilPmzw9uFkbHux/BZ3f7rqSywcFWOopN60p28ux1KWGWNN2OELCqUnh5Fyv7WJ/jsqfw06rR4Lt6FPAoCkEl6OZBc+0HGozR7srH4U1xpdp3GXkmgemP3wg6O0gp9DAJUtzdYSUc4uMVlcY+o93Fhu/L48cMUn4mSHFiFUub0fNWK1AG8ZhDEtyGeEl7pDxk4DU58JrMppH4ee5HhiHkehgT+t2lKAGjUeAQ6cw5VAUH8MXuubZ2T7wymqRazBY2CPr9EWD41i7oe0aSrecXsRYPymhttvGOeMCiQ5O83yN3GqU2ecRpeReXzGdfbH0s+G9R+CZQYjwyvbGfFMfKc0pqedoDKp9stY05Ov7BpMXIn4HPQxa2bUiTd1npaVkK2kojJHJwU8S8mkPUDsYjQMtggEeJONJk1RrMQguTa6yUmWKr47CHnNicqebK4OIKPQwyESSsHwnCBbIdLXlTNsySkjr791DkuUTPkMRNowIegJ2EYGwi/73ifqLB0EPChqOaC/5xd2HjMfVan7m6/YdemMrsws71mY1FdPKbsc4pvJV6kPtBNRbj5gewUfov8ZxW3sOFqUFfTKj2B+g2QlH+Ug5KKFq8zaZcc+YRj0eEOpU22PH88yyPtSRDnoBfj5JVnCCdGqueCwadVnP4aVE8qwHbkEbmpf4esMamwz5Uij/E86/NgkM7Q2rUBksxqUU8hHSWfZco3Gc3WM+kl69wyan0ib/QuGbpHyNxlRslafZR29sjZhMTn7WJeXzFvKHpfJcFNelM1DFh8qGgSqG0YpZ7SLCnBSrT+aTw/42WGICt+m26lRlnUw5lF95g9/FYaBL2KMFtbfN/hxiP1ISYrhETWTldCThbaN56eyQr7Ka
 yO3cq0k/
 adj2gySnjspZQ9vwcnz3cV8vGamiGD6EOxG3/V6tVpAAB8kKQlPdTktzjyTXxFYbwGW/QJrDlSzZbse5axtrMi4AIsgaUHF3WGFSE8hBcpehWu6xO2AX4d5P7k6Q0ku3/9+i+hC2fiYXtNRfwdIhp1i6Yaeh7E/Ex7ZwnUq8DRTfHDe7b4kVcrur33VTe11SE9KCj4RxcPI8QPn4GUSyxdGthVUD/FSAeY1IQ2sXF5QExMDaZch+r9Ms9qDQy43B0r6T/UuzdYbsYXfyeCRLsDKt8wtkBT25TjPFKiOrYCWmc8ftNvNEIXUmulNyX+PAzRtmzoAPpg3pkfxHCLXxu7XYivdq5EJvq4nsxLTwvOBB5vaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

> Who would set it at this point?
> Can't this just be
> VM_SELFTEST_ITEMS="default"

I kept the expansion to preserve the old script's implicit environment
override. I could not find an in-tree caller relying on it; the wrappers
use -t, which is also the documented interface. I have made the change
you suggested in v3. An explicit empty -t still fails validation.

I have also changed both trailers to Assisted-by: LLM and added your
Acked-by to patch 2. Thanks for the review and the ack.

Sorry about threading v2 under v1. V3 starts a new thread, and I will
keep future revisions separate as well:
https://lore.kernel.org/r/178886714088.169611.14957244271354428473.mm-cli-v3-0@tychen.cc

Thanks,
Tianyi

