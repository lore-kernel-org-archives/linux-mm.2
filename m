Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6723CCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 05:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2A08E0005; Wed,  1 Oct 2025 01:33:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BA3A8E0002; Wed,  1 Oct 2025 01:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8EF8E0005; Wed,  1 Oct 2025 01:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 525798E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:33:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EFDDB13BF53
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:33:56 +0000 (UTC)
X-FDA: 83948428872.15.613F689
Received: from mail-yw1-f196.google.com (mail-yw1-f196.google.com [209.85.128.196])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0DCE24000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:33:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AVQhhREy;
	spf=pass (imf11.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.196 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759296835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjOu/lv0o+hRPXMJw3S9SLujHR3dZi7a3b+OL+YSGcI=;
	b=VIGZGMbrloKeqpdaLj6KcybyDj50QL8HOjM/jlLxALlKhGV1ABQqWXQpZp5WR6evRNsmr7
	HIRY2m0JqDGtTH2EdHH5KJCZ8HqOBB9WkjDFIPSwdcFfJjzAVNSNX3G+mayQowqZBQ6CGK
	tIBP5d1LgupTrYt4eHgxj4VgFS77vzA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AVQhhREy;
	spf=pass (imf11.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.196 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759296835; a=rsa-sha256;
	cv=none;
	b=u0Fw1WVEjldvHiW7lzVGpYJKrMtaXnqxMyB9DyA3T7kenFLZqC4TlcHcznhVQk4QDk11BU
	NU9OsrtTbfKlAZV8v1y+i6DvRUgVxm7lAbfP13oMvSocaOmOVCE0HasfAHMLDw03Lh9EUf
	PXFBbTjKA3T5FsIex6ib4d6r0fbAGXU=
Received: by mail-yw1-f196.google.com with SMTP id 00721157ae682-71d60528734so76410587b3.2
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 22:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759296834; x=1759901634; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vjOu/lv0o+hRPXMJw3S9SLujHR3dZi7a3b+OL+YSGcI=;
        b=AVQhhREyZmc4vHQcU3GMlpAt5c9ng5HPGjsQigUxxNAGk6x/6zED+u6ouU3PWRbfxL
         1zGkmpyVnuUPJoVA2VQW+WNWqQBapmDdsrjuKMxMeKZex/DPrFLwu2oF6M8OdfAEwoyv
         VhzHwYPbpWZfgDeu/9R9FRlu6v8PhJ++efGolUTkbQYff4JWGzaDcNAW4t2io2K1CqnK
         K3zh7eZIRS35ijqimyVh6JqDknLc319bTk7bcsz+FpDX1JUcJtOtTmR2NCGpjKXVth9n
         yFkGj3WAOaf4yzuVRC4ryuMBLFJCFHtNhodM9MJCG0TFfp9e0eGw/wtcSvWX2hMs6VxQ
         +IGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759296834; x=1759901634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vjOu/lv0o+hRPXMJw3S9SLujHR3dZi7a3b+OL+YSGcI=;
        b=ANQFkMMd9ePFSTE4VqNgXJGWETID3VY+fF6vAKjYNfG2+FUBZDiEUyaLACLaASlJOm
         YU5Z+wL9tjTsqrqCCQ8FOdfHTLh5oq514txGe1Fqy+/gxY9gv6603jrhM76rXbbT2kaB
         skbXnFm+nECTMZBUbOUtZ3UtM3XOFpN4Axz4KEECYYEe+2CebQhPvG0nlUzJQ8gPG2cW
         2tiewpCyDKs9TdVTudDu1AD2efHshuMSmlrG9baOrHq1ixgB4YCyyfIanxlTxGtZ7qs1
         5P4yv8BRms778JLSJ+eL/RVnh17/52HMqmBfSnmVXjSrAFMmm+MlZMhGUjNx67LnazkA
         P8Yw==
X-Forwarded-Encrypted: i=1; AJvYcCW8AtzKW/9eg7Y4r8xYn7C0vS6TAY6udEjOBnsEVk3Nt4Hj82vSjetDMu+HIRtmuN/nl4AOzk7VaQ==@kvack.org
X-Gm-Message-State: AOJu0YzFELHATiEv9Kf8MDYeywopmfDZSutosnyUK3nSzNAr1SZ8lnJb
	e/U5cGQTnry32wNJxjZnQxEuWx0yWYD+HyzwLD+EaVfp5FBgw+AAK3Y=
X-Gm-Gg: ASbGncsHT3XYK/KFzmTgDO2hoyNa7ZQlVHRatpAuYA9P0+9EjYkiTw0LLZinEt1D6tD
	MC3uMBhOiT5l2uKXscLUA0+TPPWfniV2cfmnuv63uJiJt/EEaiE+oVnRIQ2IFjWwd6WMQuhCWeQ
	JtJWDTDXQGI4tbIeP0mWWTosiiwG7kHqj6Sc5lSDs+0oDnb7ymquSjibPj4vlL+nw0SxZDkP70z
	41Gikq+phKxuadil5uhVxkFNvINrN1oKTbcUyb406J1pAkPSnOTOge5Sket7rvrG3E7QZ6crsZy
	Qt/ocRWtcqaDvx1uhSfaV6jBmqtaoaRRYYJy2T4QcK+INZS4RiKzuVwrKrivtt9R8qZOw2I3Ro9
	KaKKYZp6yxitJ1RPETU/xbhW9nJqELtDGJk+/tmR6n/VpYX11jOeve6Xggr4ipwEsO6zS6kzf6X
	n0SbMIPde3adjaQRs9e97H1g==
X-Google-Smtp-Source: AGHT+IE9x+m5qq+92GplIA8/TKoNYGYahEk+CsxIr1Mz6FhWtoR9oLrhckW7wvH3frCT3+NsBuEyyA==
X-Received: by 2002:a05:690c:a089:10b0:76f:d03b:de5f with SMTP id 00721157ae682-77f6f30b886mr30654667b3.48.1759296834076;
        Tue, 30 Sep 2025 22:33:54 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-765c7ac70desm43043007b3.54.2025.09.30.22.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 22:33:52 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: rientjes@google.com
Cc: Jonathan.Cameron@huawei.com,
	bharata@amd.com,
	dave@stgolabs.net,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	linux-mm@kvack.org,
	nifan.cxl@gmail.com,
	rkodsara@amd.com,
	sj@kernel.org,
	weixugc@google.com,
	xuezhengchu@huawei.com,
	yiannis@zptcorp.com,
	ziy@nvidia.com
Subject: Re: [Linux Memory Hotness and Promotion] Notes from September 25, 2025
Date: Tue, 30 Sep 2025 22:33:51 -0700
Message-ID: <20251001053351.43902-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <98d72dc3-c2cc-b636-8a26-495870ae0f95@google.com>
References: <98d72dc3-c2cc-b636-8a26-495870ae0f95@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0DCE24000B
X-Rspamd-Server: rspam05
X-Stat-Signature: 84iknafkdbo6r9bo9d89pbh79qs16dj3
X-Rspam-User: 
X-HE-Tag: 1759296834-236144
X-HE-Meta: U2FsdGVkX1+5JenJvuY/4Re8U1j7Tl7ETRueH6ICoEYCIHsKZ4BcJUogcYqEEBLIxI7MdmNrupoQi7v6/iwtoPZYXZbJNJgDMEQecVcaLjDI3uu1tLLTixgkDyh8BaUnvq9AYLY4GaYO+i/CkqawXC92+PUlsLvFGNtgnkrSXDzEsMZMXvivip9YotFmOwyCKNmZYn6sD/0bkzp79Ou9RV0GEZXbVTrFdHirB59JG5xVrghPHQEvdkf14cOSIdNS+dQn4NairlW5Itm7zGT5Xc/og1LQgn53CuzJzyff0lXLz5+X+SAM63WM9G5oBOCniE9SanoY8UbdeB5pNSO+Ef8w6ZhhkkwoJjEd9yWrVv3Ntz8YkLq74de9lZ7x/a3A5b/Dv5ZkoITmrBwJn/+kScngPap36nuetvrU9ozu8tb0kEck6WKSG9QG0KmlqD21hV7DKsFXD/dfJjyI/NxZR1/i6J0UGtzzbCRxwenf2WpY3HEoVLFMfcOSbrEXswJnQiCkf6zF71goHtrs3cFhddZyGP3sVtul1RxtpPYjAIUo9GEjSTM48LJj3Ui12Zy75zuULEtnfOJ9frvOiCpX+Xz0lo42hISisjlqqRNvLIaMBLZclGfspYucJGTtulWXa4hkHUXsZcBvkhQHebcU9POYbefq3ovJuTCw4FiKRo9wksAYY2lMmXgC4BvxMUF30XMWvhMVzF9qAXwoOTx0u2pCKF4uzRds/jxPKnYfrLs8iswxdIMA5AJdh8twe8eUlp1wuLJcfibL6vM0J16uPXvG+Sd4rRWvPFSFaaMYrkVyrL6Oz0+ejuvi2thzXpz7VIyz/jsTH5zsTywK6DlI79L1GitQOXUa4yQY/5+RZWgX+Qky2v0jew+YIGnHd17DQeJiemH8pm2J62gzeiH2XYzbGyypjQuATpUEc22cGUbaQuXklaRfT6BQQM/6KB5z038/OjY5nWJLSc/72PX
 eRfp1F4d
 zY5lDuQwNRhCg9CVhH8TNSZsk98ltY/VNfnLG7E7RrXU8IKLRzix57kgg5ZuhcoKmf+FN6ntsd4uOe0w/r9apQgZy3+rhw/DheIgNO9bYOZOA2PuQuXwVSULxqkTgnd5QbbKCEWnJ8sQ7BHzS7B99VCK+FMiePssLdGfGXl5QVuCtQmhL6ea6I0nIMqg0RsEop9GJ9dE1+Ta0HtJ355DU/63KbPS1V480s7mlHSq9DEeq1SjxsF+FY08R2HEAP1Qy1wbC9ItkEJMSyifqSKzikPGotUTFjEg8/HeI6qWf6I17N9b/OGso7yNariopkjtE4l/VqwixaKMUTdNR0z796bWPo/9ozQTxdQqf/tofRN0pYsfTGFWmTn3I5NrDf2Su+vCDrl/qJQODLQz4EqaTcqhxJMXtW4u7BwBOOoeKre9rmxALStUhiF9Pwops4hSfPWdTaZm68ceD+ziwhwnkUbacZf9h30C7w3XOmmwzNSPIuKnndE2bzelE9Y3EZrt89h0cEdVEZnp8jlLU0WuivkmWgRDTRBu5StnE2w2Q7Q/kK0ZT4CbOTpAyQOmTXcrZVO9E2v5ImlypbXqA0wOMrWFYlaymz1iCUCk0t4qYUE+mV/ATM7TupxH4mN5aqqtsSaU73pWWY8HIVtjUBZb0EnxJleqga2YOwhirwOgl0DMEjU0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.028123, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David, all,

I'm writing to correct the reference mentioned in the notes from the last meeting.

> Ravi Shankar noted a recent patch series[1] was recently pushed for
> interleaving of hot pages and not for the entire memory allocation.

I must have mistakenly provided the wrong reference during the discussion.

The correct link is here:
https://lore.kernel.org/all/20250709005952.17776-14-bijan311@gmail.com/T/#m374b66a5195cbd24a848665ce214d0c248a4efea

This functionality is already merged in mainline.
Apologies for the mix-up and any confusion this may have caused.

Best regards,
Ravi Jonnalagadda

