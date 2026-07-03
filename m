Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B793EC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 16:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 993E46B00B9; Fri,  3 Jul 2026 12:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9449F6B00BA; Fri,  3 Jul 2026 12:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80BD56B00BB; Fri,  3 Jul 2026 12:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 579146B00B9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:47:06 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0C518C7E5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:47:05 +0000 (UTC)
X-FDA: 84948045210.18.CB21C65
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 837BBC0006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:47:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z8w5uoDd;
	spf=pass (imf10.hostedemail.com: domain of chaithco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783097223;
	b=rt5POT+wZOCO6dZz2AjoWiFETO3r5mJalLQ0w3kMgbTJTtTjd1empCSbK0FsXYYqgTLNZP
	NmBVmfLJvW1+7XsT4dfBw9e+vbqbtLW55TS8p0QTAxOPDd6yULalZgBenlhSgw178On69V
	44IsrD6Oxk7t86SVF0Yek1/UiDWIkYU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783097223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=My8NhjBNdUPEVagtdtMiXRRc+30LyGFX/swf02+/mGc=;
	b=GG4KN9S5T1KMAhLCSF4yKwMuuw6RH1aD7vt1cV3a8LL+ESLfIBDVtb6vZldqoezTduF+O+
	AdrIuI3x3aPO7I3Too5qo9RPTxL7Z5HyAQZN9+mql6MnbFVl14t0gihsbupdo5j8NoQEAM
	2Bn8n3gsXEyy0p205kx9j7vQ23rZen8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Z8w5uoDd;
	spf=pass (imf10.hostedemail.com: domain of chaithco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chaithco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783097222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=My8NhjBNdUPEVagtdtMiXRRc+30LyGFX/swf02+/mGc=;
	b=Z8w5uoDdeOtMhQ/DwIXb2TcdSy4zPkAQQY8FNdHKs6f4oQXk7pZcgrRxhMzG4iH3rFfbQD
	eWEFKA0Cu0VRRbRDDjpY2UZkvtDZQHwqreEIakkOIV3yERvl30tqfilf3siBhqsoleqSX6
	//zXr1vgcHDhFV5dmLgeevc5ckEqhBA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-CbWp58FdN4O0riWS8RRF4w-1; Fri, 03 Jul 2026 12:47:01 -0400
X-MC-Unique: CbWp58FdN4O0riWS8RRF4w-1
X-Mimecast-MFC-AGG-ID: CbWp58FdN4O0riWS8RRF4w_1783097221
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8eeba1d9e47so8209116d6.2
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 09:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783097221; x=1783702021;
        h=mime-version:references:in-reply-to:message-id:cc:to:subject:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=My8NhjBNdUPEVagtdtMiXRRc+30LyGFX/swf02+/mGc=;
        b=ONSTFQRoXrbniQQwDVBjBu5Qz7qGg2YN9elWBDnzVivSLTXifddIxctTUI1zUncMd1
         34OWToEjta7gTZkEc97JIEcNkGLWQLXPxjog8kIhSfMG+DxMtinP0FIHSd9hqPsuX8Qe
         Wvewh6ICDo2vgOwSUqVNRab3LTGCqmhe8DhMcuNoZ8yryXOcgRF8qAUWfn7xLqxkUi9J
         t7ejXbUx6ZE25W9wBlFtr5sYFDPGvBWKIkvQcyxa8Ud+c0SHkB/SSnYm0VlMo2GLnJwN
         xrtmLkBAqnHdnceW9R+uV9hX9V/n8In8H4X8hge2GZQTrXBC04RCZl+uXAjTbwsQQXVe
         dK/w==
X-Forwarded-Encrypted: i=1; AHgh+Rp+1GUJwPkhdpsg3CNLYNaNU+LNS/91j3pPYVUdAh1ERPScDlqpi0aygEYJu4RADpoX0NaB3PTG1g==@kvack.org
X-Gm-Message-State: AOJu0YzWcjNtMbI4EaubhUTf/xFAucb+h+c7eJWZppxjZVvDcmPi6fqS
	YyMSltsR/GWpabteh0pnPoic+LvBphdijim/J9Y/wZcpB2ihpivgEGNdGSj0nkrxlrWaBIE+2BP
	lGxUH8RZR0M7hDGXyN1AZsaT7eAuiWari8+TO3C64QWCOZLbwaSQH
X-Gm-Gg: AfdE7cm3VSPgXbMWotC5QVCCsDeaXyqR68FLNaYTQf+7i+Bw7IZHOun6ImCkyMExm7x
	e6wnp5i+1DdQDBm4YpbEZc4hH/40C+8LhpAfspHJwQb+cvb1Gywvb8HjbE/qzJHUg4ySVukBqQS
	X44qo/oLksyi9ZphS+KsY3S0Uv1tGGdLkHjagu2Rqfg7IeTDaOFGEflEP8ld2LV51VLoKyUx9wm
	1UMmSLJStw7cdfN8CIzuxqByQmO8vKnk7RIZNY+xhJB6Y8e8DXAlXj1ZmH+3F5WBBvzQ1PHY/G0
	yKYI6LW1+FbrqKyY/aIFsUQh/MBDaeSR9MF7spKKhqcnD34t1CR3gHajlCsR0+s36yYvrAf1m49
	oO6ILU2XP0JyI9oxEh+F/mHZlCwUZzXv9MtYEwwre49U=
X-Received: by 2002:ad4:5cce:0:b0:8f0:6a92:b90e with SMTP id 6a1803df08f44-8f74a8fb957mr286636d6.25.1783097220945;
        Fri, 03 Jul 2026 09:47:00 -0700 (PDT)
X-Received: by 2002:ad4:5cce:0:b0:8f0:6a92:b90e with SMTP id 6a1803df08f44-8f74a8fb957mr286116d6.25.1783097220510;
        Fri, 03 Jul 2026 09:47:00 -0700 (PDT)
Received: from [192.168.1.59] (184-96-191-56.hlrn.qwest.net. [184.96.191.56])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f471813d33sm59278616d6.29.2026.07.03.09.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 09:47:00 -0700 (PDT)
Date: Fri, 03 Jul 2026 10:46:53 -0600
From: chaithco@redhat.com
Subject: Re: [PATCH v2] Respect mempolicy when calculating surplus huge pages.
To: Usama Arif <usama.arif@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	arozansk@redhat.com
Message-Id: <5MYLHT.GMWUJM8EWIEO3@redhat.com>
In-Reply-To: <20260624144600.8159-1-usama.arif@linux.dev>
References: <20260623184548.1245488-1-chaithco@redhat.com>
	<20260624144600.8159-1-usama.arif@linux.dev>
X-Mailer: geary/46.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nMoCuh40RCQqTbERxMfGBzs2o4kfAF6hcdVCbwvA7HE_1783097221
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii; format=flowed
X-Stat-Signature: apa1gkgk14aid83c1xykaxb3wtbtdgtm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 837BBC0006
X-HE-Tag: 1783097223-758481
X-HE-Meta: U2FsdGVkX1/P6tv7U1vJuXhLSr3zQlsjFm1Xp4AUX0MChft0HDaSVJs/atGG7gsuODsYStUD2SAyXzvq35GI+YS+54Wd9Bfq4G9wg/7zz9tuah38LY5RcSdKn/kY3FxuT3QHYsf3kSuRlMaMuqJNbylEau2CxegdQC2ak7OWhgDTHv9Y74IuIdILCUYQgqg/us/B92IFZLylYJAPCQLqe/E2clvJv/zzgoUv3ckTgr6naouu02VpeCbl4LuV3EPwvkMS8An2ZJaM3P+Na/Pz8ergbRhuWSl06yyPCKAQw5jE7/w/y9Ivf+6HzGb07iGdOAoeFF4Btf8//2RU79wkEclTBLTLf4qo7jOjsC5iIJDMHmizfqVeeLZm+dsc3dNj4PK8YGthpLJ7hx5enZyctexPj9TGNUG9IQM1er/G69t0sy27IieEj5FOtus9Efdrj7HZ4iK78C4OJISI3y6kRRpDjrqVDxgcN/103+VGPoEF7FBey7DyaBWCdAYHmrx8iAFR7lm6DME32IBvb6rQ9Dd1fwKryA7Pf9OyQHIgM3eG7l+ExuC1q2MqPKUVJTwDatls/H0n4tOJC5vzpZi2xYkZswYi25oiBsTZgdaxCk4fqTyOsngLCqEIR7Ba1FHRVM23ea1VhCk5o4UtcDbCVqOs0zqN91X3AF11+bG+bW0lHjGasmP27gaMowy62cjdQ40LaYNs4/vkEhx8jNqCechV+eFtPqjsgrVjJxJrzDFe3oDmvsji9ihkxMhPB88loLQMaX+obv2ssIWqRDtG9VmWM3zgxX1Uh9dA1HDf80s9fu70+ZEAMC+wEz0Qv+Zly6O99XmlbMyPiVylfku+TqECLHe8BJvbKYph3YmpbaIw5RQXKgM0eTGZSdWs+9Euxw0RFqiTSoXC8KQAE1mw9Bno/xBBdaDuncdGosZCON22GBX6/R1RbSBWIkM4svXLBNJ+sqxw47eDd2mJ2nR
 Yef9X/g7
 gIOuF82DE5BxZclT9wqJkK1DXwu7bAFyl/4GBvPxHhSd93Fn4Mf3SOrb5ile2SJAtwtWinwnwyotd63kzuatNn0NQHthzYhSIAvgBsOisd5Oxx1wpHG61L8Dx6RhgmEooyx5TpgQW22rkJyXqXudpdopoyF7yWMMmpf2pWVFdiHUciHuvoMu9vZ1Cr911BznpzzyIe0W75NLMHbvL4XgZ9EowFlLU8mq0tx1w3GAYCZfPtRYY4ExLzbI9bWUQp1bWokly8095JEuiFVA1VSdLrurUYptLSYJ7sr69LFB4Q1D6xBbMcJs+8WD02gHxlq3QWqwK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24 2026 at 07:45:59 AM -07:00:00, Usama Arif 
<usama.arif@linux.dev> wrote:
 > > +static void setup_threads(void) {
 > > +	per_thread_args = calloc(2, sizeof(per_thread_args));
 >
 > Should we do calloc(2, sizeof(*per_thread_args)) here?

Yes! My apologies; my intent is to allocate two thread_args here not 
allocate pointers. I can fix that up.



