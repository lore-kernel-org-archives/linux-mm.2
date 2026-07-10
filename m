Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E760CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 23:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC3AF6B009F; Fri, 10 Jul 2026 19:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E747E6B00A0; Fri, 10 Jul 2026 19:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8AA06B00A2; Fri, 10 Jul 2026 19:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5BCD6B009F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:43:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D72C1A04DD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:43:11 +0000 (UTC)
X-FDA: 84974495382.15.EEA392B
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2295580005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:43:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ioMLT4jY;
	spf=pass (imf02.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783726989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLGg130yIZeslHGPCdPPMzyX+FW2ovnKWvKdYHLDFy8=;
	b=B2oVw+YCAC4HXcPTVc1PWy+moJRE0fCJOPkRzY6X63oh0b7Vw6N4maAI3XC0E3Nwat2jif
	J6SnUymQkm27pAu8wun+GeqUnEX5BJoc++8XYqa6J3Y3+ZhcbRRRwKbc5Kg8TP/sWhnNm0
	wzbx6fa+Fy4CjwTtchyiR+NU2zWvkok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783726989;
	b=RM6O1rkY6BYv5gn4RgUk0gox395vykHU2erIZQ91qy7g2cxhiXm+lmCEkzG4E6PrAIAYip
	DPKC7vilOu6r5DHPFSnCfnJ3DL4Uxzx1s/u7TP6eSm48Pza3B+VyCEhAfVpen1GvFIX6le
	Hp/aubAde8kKKS6/SHTI12EaSzCEmhE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ioMLT4jY;
	spf=pass (imf02.hostedemail.com: domain of yahia.a.abdrabou@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=yahia.a.abdrabou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493bb510ce4so10306865e9.1
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:43:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783726988; x=1784331788; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hLGg130yIZeslHGPCdPPMzyX+FW2ovnKWvKdYHLDFy8=;
        b=ioMLT4jYcyKHapMDCisEk/Zfg4mdBo2KFEp25GsOdpDw0z+l6b7xRKFgDEtRAgQRYR
         wwBVOKKtwnliJqgJs2q9Mg6r//fxs+fzzcR5g0ahkG42cO8w2/0an2zuWRXYO8Sg3vto
         3uimhjfQSX3KElpO0hUNrTzgBiqa+BZ1OK6/ES7kVTozp9Rn8xNZ49pa++wAZICOy4YX
         XLybOBwTFbBjqS0ytR5LJt/l34oIGa/ARD5EBVNll5mFByL2lwcXi1fqzmRkJ7KpnYFf
         h72qNLr9L1TcyW7w4Yr94DsMWzIfHqhwWpniKBEFUF0kb9/V9+41Vt7B5xamn2ESl5Ue
         /vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783726988; x=1784331788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hLGg130yIZeslHGPCdPPMzyX+FW2ovnKWvKdYHLDFy8=;
        b=pSoLoyondTVdCSVoC0dL63NAx/eOdgh56ZubCZ1Bw9TE5fjN70c6lamcoM7buWV1w4
         x7wYl2tvxnySuOi9wR4QSlQhSlnIq5KyOoIffkOVSjea8UmSTd5LHG8KdW0rMwygscoj
         z5temdlZRTT1miGiCkJ0DVhPlmz7qBc6+Zt92s2FnOcTrEFLOjU+SKHgnJH1mR5jtDMH
         N0PmfGdZPM4ojGjD1kyBzUR4hSWmPsh49jDelgccxFKRC+/bl/T8rA/mZKqDKkbpdY7U
         gMIx1+zMMZG3mZxJDCm3w9rrTPsSyl1B5IqutryaCWl9VaKAjDxrLspX6NOpM4KDhUSi
         /wKQ==
X-Forwarded-Encrypted: i=1; AHgh+RqY3WpZkgae8ueSimoKvEC4O0Lup9ZZHyI+Ma7JIPHeHDeeH3Se7tVGAkGRUwSfjnJGzP8C3Mw37A==@kvack.org
X-Gm-Message-State: AOJu0Yz6no20Whc94Gep9IzQwZjNrQTIB3J4FQ4qrmuobJ17LJ6wv5rZ
	X35GNic4lssbcsmahO7VrPhYEpT4FnNS5pVrvJLONqAOgsst8UrzBENd
X-Gm-Gg: AfdE7cnxgOis8+xWNzj+EP3UuKtKEWsfmabeQzVIMALBR6V7Xjf7vbfmbbcbxhsiZ3b
	iknovDU5+ziHg6V63R620djo1BCkV7h/rR06RONbTX+aOfVzSSVda5oLAi/fKPTFIcmXf0IABbB
	IABSAB9E08irzOtj+S/Fes/eUr0UM/gZIAlcdXEUy7RK3vCPEUDHHKoUBd/R1B7Icntm44YNb/5
	FZf/is1H3lBe01TUHnIwCciZVmEIXKJqnozIKxQ4MN3sbbkigqL/pT/UVXwmUpuDVWQy3VpbmLp
	NsEBetyj1jzEorAtQtKq1upVtGV9wcNZFc2aRJAtib7ABrnNiQfXiOkUHjE6onvlKIXEyTekuM0
	t5YkzkqYTfL7YERH/aBMFjRw6cW28UBlCyirjZ4uwTQ8M3V7mq7xsOmX/uR5/Xs5ogUVeaXubb+
	agycLXMUqpTzU=
X-Received: by 2002:a05:600c:8211:b0:493:a5da:e5d2 with SMTP id 5b1f17b1804b1-493f8826f64mr6756675e9.26.1783726987770;
        Fri, 10 Jul 2026 16:43:07 -0700 (PDT)
Received: from user ([197.46.176.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb6df6d9sm189342285e9.7.2026.07.10.16.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 16:43:07 -0700 (PDT)
From: yahia <yahia.a.abdrabou@gmail.com>
To: willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm: truncate: exit on empty batches in truncate_folio_batch_exceptionals()
Date: Sat, 11 Jul 2026 02:43:05 +0300
Message-ID: <20260710234305.99362-1-yahia.a.abdrabou@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260710231930.93427-1-yahia.a.abdrabou@gmail.com>
References: <20260710231930.93427-1-yahia.a.abdrabou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2295580005
X-Stat-Signature: cwbhih431x59b6hc3brxqzqfwtziyh39
X-HE-Tag: 1783726988-316857
X-HE-Meta: U2FsdGVkX18oqqmFFRbZxBlGJCQmuvcgOYObVpARjIuYcYqfmzv2VYEPHJlxJwD/fDfApVIU4b0Z7VmFCq9MucOym5lPj5Gny51MWbj9u+GXYnBWDTxT0XcnVq103azy8qyPmofAN04/t/pO2LmdCyfdtHYhY9c8M9gEI/DgAgBzKkA1wf/spzDYaDoyYIVcEpbsYZo5gB4f1MxTAWff6F87VqdTQJhNYBcaQFdh0/5Hq5GvXKUK2Q3dhawZPZrxaMpqhBCEBxzas4+PkHNsyKUgtLJ+w+RxUiSEcQYdiD6LIKy0vEd+rZSlKEAQSjNQhs5gWBUuwvghLoTYxzt4NTEPE7HTF7reQZVrYfg9FUEC2FbKCKj+eReT0ombQL2+QNaJijFZ07XfEj9AmH3LlCHPslLKGyjGfGE8e9ZjVahTmjFiroTmcZbxk0BiQepmzp1N5lXThtZUUEwRZ0lBGmzrty5mL0QDinPlyzqV3K1sQeMI+m7Bz1RnexbKD2hegV2xOFB3U9RMY40sTcHmVbwVtBVrKDXsx96Aju1bMiSxQ7DIOIH1L/S12MZyPP0taXfRnr1dVE7R0V9daspVi1TrVRbq3RnpojT+vR1qMoRPsWqn5Zg1MVyWxNWco4pgUD7omLC7WVNNpeIf4tReQ9dKzF24V3wOYPZeqR8ptg4QOcki/1Nc/ydNWYQxMoJmEoEQLMJlWSw2TgR5eToD0G7gPldcck+b3covuPAjdZKjHIJCl4MyS4VbaDa8NE4MEN0orh+TwHC3z51ZfBJicghinTfm2GcANpFPBK/qRVEwwzpU+fiTVslUz32HspbsbThOaUOFRKQ9UKGGz7Wng7MOchTbagoBAYaLVsaT9/CfctQp95yGAAaqCab9ySpTtlzfvKUvVktytfrbQ9aDd2tm8lBvqvI49ZXwDbjotRFE08jyNHoYwrczGhBjTcs7MOLPis8bnzgGgp698Vh
 pQUui/yg
 yNWhVH7Y6mYvadsqP6gMGoZdG4NsFT/AP/AUdzwQ3u8mK7jL/Cx7GXlUnjeed+fk4nRsoTY8jOK60/+24Vp6i0vSL4A+D3CGGg98i9XV0DbIbuQYN0FhiM/qfT7tOxOpgA40CCyZzQcM+4Vt2RwdWg4yD/fPksTl3ebhP+OTQIyuj4S9s7yrTbKHW1/iLZvk5jidXiNUyfEbkrEZAb+t+yFSTre/Ir2Ybo2V1A+JtWY51KbrvS8a+RQoDwuCc2AMAo0IShezlSItbe9ZJQLZHB1pKTRAmBkm16QsA1xwIMQfIQu6vBae2LV4rfYn00JSG8ao/DPFXQ0zye4ZNHZaFeim2e8IGcC18kH+IyB+wYuuToHpbmvPz2+IHAh5ftVmvqaIRUX4FzHTnp6Ow+5QSNDR2UsQuVNEmA4NHV0mHSS8e4QFE/xTD9APyR9ecoYUdfVQx5xD4cX7IOtXJq3WlaS/aVIZ9KYiGr1eXmaF8+XjWvKaQkGuZ3welxpbbkclZlvS9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Please drop this patch as the condition
i was evaluating can't occur.

Best regards,
yahia

