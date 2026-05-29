Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13AE1CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 20:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4902C6B00A7; Fri, 29 May 2026 16:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A2E6B00A9; Fri, 29 May 2026 16:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328C56B00AA; Fri, 29 May 2026 16:03:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21D876B00A7
	for <linux-mm@kvack.org>; Fri, 29 May 2026 16:03:15 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA4E68CE25
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:03:14 +0000 (UTC)
X-FDA: 84821531508.05.D87B8DB
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id D1B9280003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 20:03:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mEAkcaM2;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780084992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vV7V3CMoBNjkJhOUfmZqE5k0G0M3MxFKAVMCFWrXI0=;
	b=mrlwvKJg5WnrTvDe3nHW+k/C4VkEW7eMz7TCArCL03gr2bTpK3sWq2Mm5jghhoz1Cb55GJ
	AFDQIQ06mzGZ77RKY8KH0oXueFJ0IuqMQKs4xWXuVzZjt/4EZLu95Do8W6MsABFIs9aR2l
	1qevhdfBHNQ2o4o4MoOH3qdkYB1qM3Y=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mEAkcaM2;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780084992; a=rsa-sha256;
	cv=pass;
	b=e1Cnj9OHPgZp0PCw1FM+MdfzKtoYvAP69fzFsIvYyr0ERMpT3eIgNWbO9CLozzcGWyfLXI
	YJexSiQBOWiFTv+5mO3Cw52XA0oI44gkCDvZi4HbQuGScJgqpZlx5BFIiqN/HPG9FKq2DY
	MPFrO3067KcVAnYrBn81gF5vvBV2V9g=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-45ee1a56328so2479370f8f.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 13:03:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780084991; cv=none;
        d=google.com; s=arc-20240605;
        b=Plm5QyOGbruK7b6Kz6XCkGrl/Q7Twqz1B7TgDUe+u1z2HL0mKt4+X+h3UfsYdrFUKv
         McCgZPP1/eEgSDadjKuBFOi/Lv3dDJW5zQqMGZ42HYTAoG1wqaUU4SYh3UICIiRwL4wH
         09P7FmupzgOpWFCABI7LE01qubfGqsk/u5RfWZjLasGe7ty6KRUg9AWCSs342BmWIE9Z
         CH6OLaOabaMA7ie0x11saWRljXdVbJR/ZsT0kDiOwkhaeGV+IdrSTXugyGMl0twBRwB1
         CENwqsdzaM+T0hUiSeS3qTGoWj90mveRvogWL+sTrFQOWngwtu2632AzcyLNsl8wWkMB
         zcww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8vV7V3CMoBNjkJhOUfmZqE5k0G0M3MxFKAVMCFWrXI0=;
        fh=t+0WUGun87AmQHFmDMbH5svJCGvlQvVQQY1z6n7B40w=;
        b=VxtZysYi10WiTOBfHNSAmL929gQW9ht6O8dPwUAajFLEXfnDhYaKybjDLwmLlheH3S
         9dR8FIy1mHeNheh304lLZ4zR1oDFTsDo/HX7XyEHxrJpOU/uschsNy49bnavfVCMcPLN
         u0+qwyyTqv9+sqdYSdl589Qx5DXKDba2Zq7PKpt65i+5OA3/j6C5o6lkXM716YkSVuD/
         vMbKnLDJTHn1lx4y4KacrxSqbSdduTz26uE2EF7ZxND9DQnYUIroc/NBRQ3lCpn3vxWh
         XBLIuQ96O5Iblnb01I2hdNFPgeGqQ6aAu3UpqOrDZQ13tPADjKhrVDf+o9l86Mc0KhEm
         +0Kw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780084991; x=1780689791; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8vV7V3CMoBNjkJhOUfmZqE5k0G0M3MxFKAVMCFWrXI0=;
        b=mEAkcaM22oKi9NMXpfz1xl7vEw8ohK3qbldSMEIv0puUWAbMCzRU8iLQzp6/Yd7o3Y
         8CccHKIIwgkuY8g+JWd9V2Ycm4gjFMoEnuXEJRQOG5gHr0FjR8U5XoBNV+Ply3RM0Apv
         uKXfbLJvCD+nRnseNvyn27i3zB2LABxt7iAO3529VJonGA2ZEaOOSdwJ7FGE+HXqSqvs
         4mPoqp53K//Yxk0/W1lAMTwfrpsVtJJNJk2CVmp4PZcycvcEsVh3K4JLkWTBRnXCrzAR
         ZGiJCidQg5wwOni2Wf8SrjMSMy/VvDmIGgEQc3OuQZlCgRox9+nBkuEsQc0KSo/pn+lR
         NKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780084991; x=1780689791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8vV7V3CMoBNjkJhOUfmZqE5k0G0M3MxFKAVMCFWrXI0=;
        b=XViAdaNT4MBXETtkMyNmDSNAUkxVRIlQA8s54ih+H29aP6m3M41ubXtwUCk24gXMzn
         lUrSjKGGgzvUUM+7jUhMPBL+6ch2D5HQyiEEhuE0w0p4lWy0/A2EAsrx6NH7AJQiOc9v
         JWYpFpT7AYNH+TA6JCqBa/Gazm0kE7PEjrfsVJRu7FDg8T5ZzpkI98jh4SoRp3REWn1t
         jhJaAiPRUUpD9q6/EscFZBMZ3zHbLKjAQM517eOV+dsHWNs64iYlBk2i7u3mxCnp+F1X
         C43BWgKtbtvUmtcmGfNOSkEzfeg1+jrCRMjsxYnitbXu1Xr83U8mCI++I5BWdijb62Ha
         3cZw==
X-Forwarded-Encrypted: i=1; AFNElJ/zxDJShqaSMeORDWf8B6DrsDj55RpYd7p81YI86zIvEvdf+L7cKdVsPBF6gn5uxlHotuP4gFkkug==@kvack.org
X-Gm-Message-State: AOJu0YzLFH2DIlFe9I4OBUwUzezkIh5tpchCcZa7agNkYT8Z/grhq8T2
	t6RjqRvQsSUnBrCJ/9irwmk6KwMuphpYJnjo/rZK7UHNABkm4LTH1gRdsapoWx7yFZ8x91EM14P
	+Coyb85iArQvR/SVpD918dV96ecOeGVE=
X-Gm-Gg: Acq92OEYgS1kWSoghjIKBHZsWXImu+DLOYjqjIigMCsO+Ap8yz16BCUB4NjoVWuLRJ0
	iXmZF060nA7nZDC64VSsthyFriR3SmvaegnfmIjRTHOEuPP4yl9HeG5cxEJYoOZnkxHf99EknKV
	ToKhhj/dK+CAdwzHvt0dCVAAjBM4MD0x/bWcvA/vvpIrhNUhz0SbkggNkK5Vg4G+kNvB8uWjn+l
	JniB6buEv1313awHDoCyqdAb8gDxDoHQ9lXp9L9I3MVwRBg5D2jeLv6/iusm8rVEjg+7MAOsYtO
	lPTMyNf2h8dygNo663Rz3RB7FkZjd+VSxe6lTERhFIzk2zR5Kg==
X-Received: by 2002:adf:e510:0:b0:45e:ef4a:819a with SMTP id
 ffacd0b85a97d-45ef6b1fb03mr1966464f8f.17.1780084991071; Fri, 29 May 2026
 13:03:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260526114601.67041-1-jiahao.kernel@gmail.com> <20260526114601.67041-5-jiahao.kernel@gmail.com>
In-Reply-To: <20260526114601.67041-5-jiahao.kernel@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 13:02:59 -0700
X-Gm-Features: AVHnY4IOqjjiOdCG6Ozo0C_CJ8lU_HS1P7B7pgVtIcaK6gtGQOhL7OfGo5YfYKU
Message-ID: <CAKEwX=Mj8hxSma0DN4zvCgRo3HMs7cbB145+s2=LbTjiKUXh1w@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] selftests/cgroup: Add tests for zswap proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 477ywtaixduehcje4b3ax5wb3nxakyhg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D1B9280003
X-HE-Tag: 1780084992-403038
X-HE-Meta: U2FsdGVkX18a+tR64g90zneKBaEJ8b+qJxHOUVzS3m8v6C5D/5BQAoFCwj8qTi/4KPOtj34Pt31Q8QupRaYmY5ETOGlGNbhOIcArewLgS8jYvckBZDK01QqiyvB2sAI8hFwQ8iRbyoOtOMvl/tQCeARiSQUPEjj8Cuvs+g+D+iT6WIU+yuG8YzdhS9LlRwlYS5Zabe5QKovToD56MFfNinmrHC7My9BfsQ0wVW+3Asby133ZzD8r8erXijU0I13FwgcYM7dPed2WZ2B+mraNGBfMXUALx6OR4gTWQjCxSvttNgdF7RaK13DK/3o0hYhCSIQ2KoY20D0my4fntXg8FIsPmQHV0dOqKOb/o1+DNyqZj0tuaaWdK7lqiLiV3Cg8jack5UbhQIC5LXDDHKLRlXOF8nMVNdYEqJ2cxl6kk1VSwI/gMPM1V99+U5vItH41IYA0mPke/bik2Nqf++e7VEIzBwRRTiLACTHYBJnMxvtzBS70IDXd4TfNZoGT/sxCea9urmNoCeyebcPpFrWrmJEDxq+rbQuitO5R6TI/hNnG96xntjqL2tjZIdteLsYLZxuBf0xnJxPNOBoxTIZrLd7wEc9/40xkcNz8GZEyEaBzTLEec0XqNO8LbIU31LYcefr5r57UtypdOz40tNNxizUpParRwB2NTNTqHsUY1KASiQopkSoxFSkuxYMWnGGnzc58oJtFF9mDzNOWvtAnkoro+5mZuCFmw5O93yH7xdg7lKK29Juuqyrke12clrB1+Pwq5aDNpjatKWQMi+3TOFh3BfDPjspYxDiRekMFvkzFPKZrVE+v6qbfoW3tF6iEp6cHdG9aMOCp79v3M78YztV+uHrCYjntQdVYmmQo8j4ouo+ht5GzlnZgP7ACKrL9UZBXoaue6fntaEAlk32zJkZaqhkvDuo5MEiI41TdtAG7YwEHwrFCOTXJbmtv02wkARmrkzYBDkYzysYO7vd
 m9PDoUSI
 AlCVl8hrWTtxUyuwN/Ga2+o6uxJV7Ss4NmKMC6evnK2ljdTkBmx9BK3SuPeW/LinfsvzWwpFHqEjIm4qa8Wcps2yXv09f1AU1FI2N3HOtqJ4scTsy8zWPs9WBmseEkMlIgs7aHnUEEVHT5dVmcRZCZleM+LQP6jBfFF9awGIW+BvlWKINfuEvDjipsskOOQkkCLMzryS1YDQujTcn0XAgMr59wb7DK+NYgSja9ZrXxDoOQO/EPX9CkkPxnZPTqK0zP9QAnF1+EY8ksFITrv3EQ8sOoKTEhoBY27Svu4pCFETVsw5WbOBhSiVXYScRNQZJwEQ7H0tzUTHGPQehU0T3e5uj955kU8156FFTAgmTddgzeYG6rd1NeXOkOOYH7jpkiE1rmPCrNEABKqQZq17gQVmGv7SXH/hklldGw10EB+CLf+5iX7ULM57R07sve3R+mY+jzuJAoaX6dTmu0ORAZKU4tcUzYA/GHEOLR+KJ+c+yRRGk+cmdqXqRU8LPY36kuFGKdYRrYq/ZA7eIQJrVkcUpMM4H+9bRvrQqhGzghrHBWnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 4:46=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
> From: Hao Jia <jiahao1@lixiang.com>
>
> Add test_zswap_proactive_writeback() to cover the new memory.reclaim
> "zswap_writeback_only" key. The test populates a memory cgroup zswap
> pool, triggers proactive writeback, and verifies the behavior by
> observing the change in zswpwb_proactive. Invalid input combinations
> are also covered.
>
> Extend test_zswap_writeback_one() to assert that the existing
> non-proactive writeback path leaves zswpwb_proactive at zero.
>
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>

LGTM.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

