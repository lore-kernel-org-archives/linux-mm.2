Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B180BD4A604
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 07:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CEF6B0088; Fri, 16 Jan 2026 02:00:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B2C6B0089; Fri, 16 Jan 2026 02:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1C6F6B008A; Fri, 16 Jan 2026 02:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD53F6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 02:00:47 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FA7EC216F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:00:47 +0000 (UTC)
X-FDA: 84336929334.09.74F45D0
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 27B864000E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:00:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=a4fG7qxS;
	spf=pass (imf01.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768546845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yjk/HuTCyBmTrKEgW/VvGyUH8+Hoy04Wh+N75d7lrKA=;
	b=fUXr+QzDJJouKNoGWur+fqVc+FX4wYmkoFOg0ZFXppu/pnHc1KOH7RQ1dOqabkWIDsULRZ
	Tj9o/qJVZfTqA5ytuMwYers+LeVkrJ2f/gr/yl41KBzJQlMEyX9S+DS1YkN65BoeKknlwE
	neLfdIW4B2aQ9+Ww3MiXo2nBzEXLmYI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=a4fG7qxS;
	spf=pass (imf01.hostedemail.com: domain of bingjiao@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bingjiao@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768546845; a=rsa-sha256;
	cv=none;
	b=nq1dTC3sa76nzHjp4/chSyqdxbxyiPzfVBIxUkyyNIQXYn2J1y7TmZA9e5wDJ2W2F9C6IL
	2YEiu0UAF2WS1xY27LSuwFAnws+i9xXeVWDGK1Tjo4qso1btnusaA9EVCN+Fvm12TnnT9r
	fJF9KDCaVjZPaJEG2id/oeG54VgKcgM=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a35ae38bdfso36305ad.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768546844; x=1769151644; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Yjk/HuTCyBmTrKEgW/VvGyUH8+Hoy04Wh+N75d7lrKA=;
        b=a4fG7qxS/hmri2EVyQmnUiCCrlXY9FT4+hIr3UuWDhrBS1wX00WE6vv9NjopVA7EBv
         qga3iE+GaRp9wcyVzf6kkwLgz3q9ehgBnIMOoepBHMpSWYRNiPX+/TeoLDgo8Y+EcrI8
         pk3INGXDsZfX23HM0py9mNEo6i5DYpJeuRXpDMEOITMZHV6MV6Wq66eIRGdk2kwJHZou
         7jRa07ism3ODfFjVEpAmp9yrzQFkUeJoxFZcXoaPRQivTO01x7sxtZ/s8k6JR9utDwHJ
         UTiqViAC1kfwm3hrMaQ2E8UshPNSw4jpS2eZQvzrP7VVrdZ++Isa3EpKNcU5e5YO5Zmy
         Hlqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768546844; x=1769151644;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yjk/HuTCyBmTrKEgW/VvGyUH8+Hoy04Wh+N75d7lrKA=;
        b=AiyrY2NuJKskZgKQhXDhIzx3vZ/yT/m7Dz2BYkv+1IG8c8jrhr3q/EX0XD1K48Eeuj
         LiGHdRm8T4XSpuSFhxnK5szYHBQBq6Oq3U7rVWEEGm7xZlQC6Rs8TqkGwg8Uj7doESUM
         Jsp5ybAGoww2EdtJ97rmsqj2wgCWSvTYcEZpjFh7ao3edZKgRZ8YfbALxpnOr9fr+G22
         oBpNyzHQ2DnijzMFvbBkh+45obrEZtPU9jdAbiKdToCeAUNlpavY2VWvLvgJPlo9bHlJ
         momtjne2Fm6vfPkCoJDNNdPySS/s0X1KcPoFNjMpBVu8zla9SWSiarUXgpd/JRFzSPtK
         0oYw==
X-Forwarded-Encrypted: i=1; AJvYcCWoA3ZLU8nbgvBScg+hHrcDG6Bbkz6xkdErhyRF8euOzfj3FHaB5vFbhkRrOPBpLkHD7E6lNgxWqw==@kvack.org
X-Gm-Message-State: AOJu0YxfBXFhisC8ZCB/UP0AWYsmNvE0Tex16xDnP8axUI9K2ZzZPHlG
	VPHH+mNQYx6TCd2X+ahysbc0jmMENEL0/clx3+g1LC72760VTP2KGombVCsz23UjvQ==
X-Gm-Gg: AY/fxX4iUGwPz/7ta13eSWYbX1OynsXp/LcS2WDy/4a4/1DRKarATi9IhXS03I5rHAT
	NFJm+nw6uda6aUl92KjZ8R4+roIJuZcWJf7xUwMW0meKhn0vPpHSyZ7OWm7kjHQgFpRouOIwCGD
	lDTx7K234GBV7+86yL4wdn3W+n5CFvFdotMG8JhRFaDZIS8VEgvlvh485sHym13TJeGS3p1utUn
	afZnMXOVnmN05WEykQIv6K/MPH64s0LVo6W5AXBBia4Uoc05yTVIHLG+3hW4YTOvQUymb44ORWA
	TSDwGNznXTQhScNERUKR4lY5Ayt22U+bDGLfR2Z146gUKogDHp58PmnRJy2twws26FkwVNhotiK
	XwxddXptOsLzX62r6fBhSE37KCQCmmiGrx3B+3KBgbKL6gW5O7+UB1bnB9amXUGVeZ/MrsVdiWa
	9eVX1E1ykLh4G5KR+Ec8MFay4pyfNH9cVCKX6+riKmioSPbF8LMA==
X-Received: by 2002:a17:902:ecc9:b0:2a3:ccfa:c41f with SMTP id d9443c01a7336-2a71a96bcf1mr1526965ad.1.1768546843624;
        Thu, 15 Jan 2026 23:00:43 -0800 (PST)
Received: from google.com (130.15.125.34.bc.googleusercontent.com. [34.125.15.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa1094e23sm1195803b3a.4.2026.01.15.23.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 23:00:43 -0800 (PST)
Date: Fri, 16 Jan 2026 07:00:37 +0000
From: Bing Jiao <bingjiao@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, muchun.song@linux.dev,
	roman.gushchin@linux.dev, tj@kernel.org, longman@redhat.com,
	chenridong@huaweicloud.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v9 0/2] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-ID: <aWniFUZgiuNEDe9O@google.com>
References: <20260114070053.2446770-1-bingjiao@google.com>
 <20260114205305.2869796-1-bingjiao@google.com>
 <20260115160011.29dca1c262ab1fb887857508@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260115160011.29dca1c262ab1fb887857508@linux-foundation.org>
X-Stat-Signature: 5n74i4x74sich4d5o5d46fnwdrjpu8mw
X-Rspam-User: 
X-Rspamd-Queue-Id: 27B864000E
X-Rspamd-Server: rspam08
X-HE-Tag: 1768546844-505402
X-HE-Meta: U2FsdGVkX1+1It9InvXFhfi/gWEeCvEmZJOW0+ktPXEiVt2BJpj9NKo8+eQh+ID44XnaYZAtZeKw2PmrmPZS7xO8qYcHekpo5oxKM0oMYEAb/nOY02KJF7T8CLl0km7MI9GhNlIvNZ96SRFpGwxMFDaqLb7FQF89ysHAExQ9hAmSlbGMh9OvHOvK8s78CsGpR8osnPBkHfWSH8gTiITejpttabXw9jH1dYXPIPFXFRSG+sVl9TasJTTYkKgtAdLu0pW8qn+D/IbhoZA6dtxFN6aQgMfHIIaGGSS45L3mxYakXCj5b5/aXYx66dVqfgi7b/05+YyExWR1dV5XwokDZ6VUSvZxtscS+ne/zjrfEUDgxH5lub0b8aBBHMvdtbg4f2drHXyFfkICGh0to0l5OOQgVrPoiYxcefD8KuqjV9paNY6wb4qAW7hc/QcZ1NXBaJ211zy1BhvkrmClHkvvVxZBSF8cdm2BwYF60qcuPaB72WycEg4YQSyX1Gr93n8bIkv2gz0vPoBAgu4B/C0ML9Qm06v3Hg9dFZWsaSBHW3CV/8MPeOZEE2dbafa9hdD1udpzZ+AxHPNOMKoirYX+LIDkm/VHkigx5eZnJsgRO2Pz/mVxicQ4cUS8eoMznMunI5QCNtY/1hiveIqMqyJux82XjWyZIPp8S2O4RPvxowvsu1rQzDco3LqXaQyekkp6ghTYYbN6aS5XLfsuU4SgnclraAWp85bzB0AmmelalYO5hWlCLfO6eJ4RvuVfZJQUyVp9Vqc8geaak4/R6IVuzb9g+BwrNfX7lt8NnjFSobWOD8LfW8zl/V5QsMtENEzKhXeEOcqkRBdyiT5M+/KBqwnPsgU2pSpX+PH9bY1M5VEhYtsgqqAjT5B6zTYAKH3E/lan28EPBl/5ta8720vaz2VUDw2OMJJ55oYLeTCjetD85kU7lEpUf+/rzYBQxfxFPzl2Zz2ETA2P+G/GG4h
 pXd4d6+f
 jLZmPW2lpgZRD74Sr3mBYgV0O0yOIfk/ksHXlWw+nXw0Ojs1BoJweEIbopGNGHioCiitudxMD8mUbuu1Hcw4CwGi3EXWWQwUO4IvLEjPs7GkUZWNGiSTfXxPWJuOMnpr6dTz0KQ/oY2nm8sSOvW3cJeBz0BRuCphipNj/ePt4AV6v55zxqK32yrO+vD9cXD9SBn14xosuKcdozrC/PtUzFd7tmkoiNL7c7J/xvtzXZqtGr32VTlI+VNTHQfeTKFORO6wM1EDM/R+S2S4/K9IoyAX+FRP+ad15XSiG+u0a01X1DO0u+THlqVLY8pW6WIfJvHtxyNnlGg8oOL42cAhTXa42jFhChIgj/svblOC6A4+Re4yE7j4nug/zVrqcx7XenmRhWTrbGwBqsS4+p0Mb/2epckxBTwzhmV2C7w35y9OizdccSpY0yuranW0LcJ9S4TTo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 04:00:11PM -0800, Andrew Morton wrote:
> On Wed, 14 Jan 2026 20:53:01 +0000 Bing Jiao <bingjiao@google.com> wrote:
>
> > I’m resubmitting the full refreshed patch series together this time.
> > I just realized it is better to include the unmodified patches alongside
> > the modified ones to ensure compatibility with upstream automated tools
> > and to simplify your review process.
>
> No probs.
>
> [1/2] is cc:stable whereas [2/2] is not.  Ordinarily that means I must
> split the series apart (they take different routes) and often discard
> the [0/n].

Hi Andrew,

Thank you for the explanation. I appreciate the insight into the upstream
process and the time you have taken to review this series. I wish I had
known this earlier so as not to add to your workload.

> In this case I think I'll leave things as-is, so [1/2]'s entry into the
> -stable pipeline will occur a few weeks later.  I don't think the
> problem is serious enough to need super-fast-tracking?
>
> Hopefully this approach means we'll get some Reviewed-bys ;)

I agree that the issue does not require urgent fast-tracking, so leaving
the series as-is for the standard pipeline is appropriate.

Best regards,
Bing

