Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C087CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3CE56B0005; Tue,  2 Sep 2025 16:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED426B0006; Tue,  2 Sep 2025 16:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D036F6B0007; Tue,  2 Sep 2025 16:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE3AC6B0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:00:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8991B1A0382
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:00:40 +0000 (UTC)
X-FDA: 83845377840.07.C796F3F
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7970D180017
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:00:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SieHwVU+;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756843238; a=rsa-sha256;
	cv=none;
	b=R32IJOu1IOmcewZDv94IoU5UAA2HYuwJDDF0Vt5S0sjWwrvJns/odU670GeTX3TLID36Io
	X2JAz+/mYnhG/C8x/CTEH0uiXV41kgZf7rtcOz0C/YT6e46O9MF2CcuDvdnvHXozTfE5f5
	xB2SL5AYY7wWxz3ViLPh6t1T7b2KaJU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SieHwVU+;
	spf=pass (imf06.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756843238;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vnwn8oz3u8ERteNvGUGXeU59pUXRW/r8woC2acqZVsg=;
	b=OewYPk4YKKiq039tyYcMlvLgzpnu0GD9a2ViL0u7IpVbyzBCUm7Pf4HCbcVSC5zMOpdaEm
	uAVW6buih8DET8AJm/aoFi/OXD9+0hzxS9JRf6ssuoX95THTEXYaxYFmdxDBeik2T/n/Gb
	3dZN4kOwIbGWi9dm7mqrmLDEGXhRUGw=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45b7d87b90fso2589715e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 13:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756843237; x=1757448037; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vnwn8oz3u8ERteNvGUGXeU59pUXRW/r8woC2acqZVsg=;
        b=SieHwVU+DFNHRuY/9BnXIramaryoSqKw9jgM2gop3JyAb9DVkt2YO0fn9xczmM7eV5
         TFuTkI86QioINipQcb2xFWMaLthfmxf1pB7Px0ScPvf3//3Q2jizWb67InfvKfvH4CG9
         Wmz48pFaCfAb0Iq7PL9YGcD42Wu2cnJdae6ndBrSdBqLy+nWt5ImW25hcRX60tlV1L0D
         KdlYHsyvp190QDipzfIpWG6jdnp5smsMlN/UZmf4HEEtbBJ4Y4wI0qC1qc8hN8bGP4pG
         VyPpQl3GyUFIi+03/qmf5fI9Rp8A+PYy57BLd12aN/I8L9RZN95Z7oEAQDsm8Xp7Gxwj
         +fPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756843237; x=1757448037;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vnwn8oz3u8ERteNvGUGXeU59pUXRW/r8woC2acqZVsg=;
        b=DRX2a4CQhndVaNq0N1BH+LIRednk3fatfJycgu8f1GYx2Gy6jZnIDfDOG5aurC/EsK
         k3JxR8ieoLXPEdWa4GYZ1olsLUiDxVm+Hs9Jfz9k2/DwXdyEI0HL1g7qErlapE8ncGJs
         W0Y1npbpDtc3cOEWPpodWsuhLwZa6NGkJq8GwRVA6wUw+/9XjRc9hBMXd3RJr9g4CtWF
         j3urvcmbKjftTFBJG56fZvU9hhVD6UUpaWJOyghz8gJurVwMv+F5OZ1U9gPjKWfHaE0m
         2TqiesiwxyiXYr9vhWh89Ci28cnKZaz9irPclLpI/enJwMZ6wPVotU/+409V6uCfBzbs
         xfxg==
X-Forwarded-Encrypted: i=1; AJvYcCVY3orISdYyCsqtX6WPNFJLH3RH4RJlN0uatUKNc65Omh64K9ZxFAKNF3Q9zbpI4KyIIn71NMaGfA==@kvack.org
X-Gm-Message-State: AOJu0YxrIXdP96oDvsbWPdYQt2MDUHEICwyA+xko2dzzJ8+5AkXzWgBa
	OFKWk+zdLLVA4+d8qWmUIOSWebHFwV+91/SujP1pWNwQCV3EgYyhN1W9KCk7rA==
X-Gm-Gg: ASbGncsjhS082A50mpm5t9hOE5YE8OXXzWOH4Lrf3+terkJwxRcmGRuuqlUMI7kHmQI
	6fiG014Dmg6wjNbnTavroJ0ZhxEh86OnI409q6wxPdYrOa/8lpQrCAvoLEGKtN84rqMZYWL55lr
	7l0Li8Nrf9zIBWnltxv1jW9KGQ1yaHFuwaTnB7b9NjjRr/YvI//amhQHwvvXnD5wFEZO0ibVBlK
	WqHdPsdbOv5zveZAAKJ5DJZahguHXxYtMiLONX+dKvAqQ48G7JzSt5wo72ozlK1t2MmkFbuyU5p
	HtAJADT8CKeLUCbXjFyiGRci2QhtbKXpWS1kmXianXC5ZM7GqWU4aHLqYJGQN+OukdgXbtde1Qb
	7ZiCuTsxuBeeODRgPx9p6u+C7Hg==
X-Google-Smtp-Source: AGHT+IHEgm0JQcczqL6qbChvbVinJC0mTKPGSa9ic1yc/g9tqv/HdFawzpA/UHa8PWGwns9G5GWJOA==
X-Received: by 2002:a05:600c:6210:b0:45b:8d2a:cd07 with SMTP id 5b1f17b1804b1-45b8d2acf12mr60904505e9.5.1756843236735;
        Tue, 02 Sep 2025 13:00:36 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b8525a94bsm162489725e9.15.2025.09.02.13.00.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Sep 2025 13:00:36 -0700 (PDT)
Date: Tue, 2 Sep 2025 20:00:36 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 2/2] selftests/mm: split_huge_page_test: cleanups for
 split_pte_mapped_thp test
Message-ID: <20250902200036.6mv4wqenbnjir277@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250902162536.956465-1-david@redhat.com>
 <20250902162536.956465-3-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902162536.956465-3-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7970D180017
X-Stat-Signature: q4d5tx63rm7iq7bh7purumefxmc7dztu
X-Rspam-User: 
X-HE-Tag: 1756843238-770021
X-HE-Meta: U2FsdGVkX1+z1z/becX7mwzk4I346n7IsKEHrEV93q/j1mymzb65MTlewrrV+Oph9o3ZP+cRYS+GxAEIa8XV//jzlFvBznIwLc+bZ0PogvYVgwCOLwup6pMujX8DOon1uI/Pr3siMETabJq6ZNXlcjN15uF4XtW20aKnr3SDHzbStgJ53gOqjMUy71PwWIET1TP9jO3O5/mTtdkd9gg6Xq83SgbSCbFyZbhCj2kDaLjahfMs0oEX+jusanaCxq/mQIqxfThEEtoprs2PDR2nLBPOoSMedOiK5fkMLXICHqRoSjI4ZCH5B17xeL+DY+cmSrtjK05O7EkFE+zncullN9w3R4mPpon2CLH/ZSY78BhICDh3As3XdI5C9YXjXblAm4McVcHrqcmMY/b74JzlC2pw+3WqrVhO7l99CATqigxr1yL9C/lxhPBFnAsA2z//9ZBF7QtaILRaJx0uiipFdvviStVwnMytbIvB9CqT81ayaCsVWTwkJZWJm6IePCDBmZomTh9OyIoBkRo6LSnmm9ejwjiX/QN77utasO9rqCYg2Yifk7uL3n9C/n7QkFf60zeqoTAZ11WUvi36pWDbcQIiUnTeqNDDZ+Q2VhHVkxYTWNcFK9fmgnDCqjhwy5M8RVcGIDwvahumzbTc5OvuCtXeUD2dSzCuo/N2HxiXA4RLM00thG3iFjYbAoIcyLgqFutBMYPkkAfqvRlfpK0DOt6H4rCDCJO6IqhEsuCItA2+bAioiKu4SNAOh7GI1TxwODthmlTsBbnuCGr2JxHpFsrcf9e1/X+qTwXAllW5B5sfQewXEBazCpQ11MNdM0uenL4BwO/cvivDFBnJiqD/urwbJuBNAEKXr2aSbZ5SSi4/gmohnRDLIyYgtDqNY6ZaH6BNic6uQtb812vYJhBDOP7WQ1SQA5/tr7oBDTwJDYLigNKh9iu7OH69E1DBJlYZW0lpG6ZOPOFop3/Zh2t
 /W24GJ0q
 3k3jyusCde21onjMD2KqROZcOMkdrGXLg0BKD3kHQcXcgGS3hVwpXR1DWvmaQJM2169gRCMnzmFQc9QHH9XZ7g4xuxguufFto6K2HYjxXOi3NG21kNOEuU5t3ZuYH4mbGZDZYLdclHAv1CI2mro0pMKLKJz8WAgaxJJE7L68sk4+I4iTO7TJc/ao1GOmj7xCSmM/tAiiiH0oAyZI7La1vJ+7ncIihUbYU+3t3iSIaUwQG7pyX1OHbmcfECPU2S7SsZ6XhP3i0shCPPQYxfbavQRH68mo7nwJCN97rfzadgnz80Fl8YTcAfQ4zfASBCWdL/z/uqwo8wQW3XnUV9bYMcYwQN/0sE7JHwb4tjhCeouEhuEcYOQvdyqYkgUuD5mXti7brVcfHb6N6jf3VyOTMe+RZn/d/c8KOhEq+6Uz1KKXVZ01xE7GDpDJnWDK1DxdcPM/TbbuR15gT/6BwFOdHd2BabmjvLhPpnYOCXWil+W3xorL8lzABet3l5mjVDFdruApdxlD0IStm6pfVFwss+XVvvy2PNQrym7p8wyu2j9LIgmJtVMpMrMntCoZmdf1flBo9mdslLm2O81kJjVP1xQMuhZdKxaiA882DwtIKP6Q2H7NXB6JLQrC535vL5P7rAQaGY1mjdhPWfVT4FxlB8+pAjwoYsjr+xYdP+vimYY2wdhcBqZ+5kw2ms7tbGjIqET9J5luRGJAXMhXXZm3yYsszRhvOnEQNgIZ3FB9CkZOYC8zAXm9PzerMOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 06:25:36PM +0200, David Hildenbrand wrote:
>There is room for improvement, so let's clean up a bit:
>
>(1) Define "4" as a constant.
>
>(2) SKIP if we fail to allocate all THPs (e.g., fragmented) and add
>    recovery code for all other failure cases: no need to exit the test.
>
>(3) Rename "len" to thp_area_size, and "one_page" to "thp_area".
>
>(4) Allocate a new area "page_area" into which we will mremap the
>    pages; add "page_area_size". Now we can easily merge the two
>    mremap instances into a single one.
>
>(5) Iterate THPs instead of bytes when checking for missed THPs after
>    mremap.
>
>(6) Rename "pte_mapped2" to "tmp", used to verify mremap(MAP_FIXED)
>    result.
>
>(7) Split the corruption test from the failed-split test, so we can just
>    iterate bytes vs. thps naturally.
>
>(8) Extend comments and clarify why we are using mremap in the first
>    place.
>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

