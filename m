Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8867810D14A6
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE366B009F; Mon, 30 Mar 2026 08:03:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95C36B00A0; Mon, 30 Mar 2026 08:03:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BABCE6B00A2; Mon, 30 Mar 2026 08:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8B646B009F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:03:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 306B316076B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:03:35 +0000 (UTC)
X-FDA: 84602594790.06.7D0E4C5
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf27.hostedemail.com (Postfix) with ESMTP id 07E024000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:03:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Q5te9fK6;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774872213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/pCkZp0kOo5osdLzRpybPSjj/VyMtaU3zoXyQksTzs=;
	b=BU4hT0wV2G+GeYnCQJPOcPKajsb5DtfqgfosDJLUq3QFEUl+SZtcuiEAS0JmWwPBuxw/3Q
	YUyDQmhVFdik+6t3QdeZywXMTpy4bvvskvwREBP6wNJZX6E/LCCeT/ePAmzkkRzKuO+r2b
	b/B0xK16h38VNHPftYbtG8Qi7BT3s4c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774872213; a=rsa-sha256;
	cv=none;
	b=FFgMazeBiiYHAarJrRb4vGpqArn2swguYbEpUoro1Io0BaoVp3829suyDEtxJ9Wdete7Wc
	EcgRe3/iJ87ajsh1lsrYH5rFpppKTQJlHZvFy4N/6HrmV3bJ1iRyojrvwHPpraRq5T2b9l
	rqGXkHDk5do5rEseL/5sB+nvv+uHeIE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Q5te9fK6;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-486fba7ce4cso44173585e9.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774872211; x=1775477011; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=h/pCkZp0kOo5osdLzRpybPSjj/VyMtaU3zoXyQksTzs=;
        b=Q5te9fK6m2bX9xE8HLNyq3FXH4XCtHl4ENCM3uKl+P6DGKawpYIbJSTcohH3YPUDKA
         YCiyNwziXDoOBJY2H6ZPRHXsi8Aq8DpD99cNNaGralRIMPLozdLgGxBwSMlrvvi3fHfb
         LXB1hvgk5B2acJjD+vR6pnxYJGbyMH5bR3Tt7iHjRIct/nSGvhbECmDCLCQ2K0m0iCWw
         ow7fj3euCMWEEbJpiTGiRjsy0NE6DzN914cCeXsBh6IcUi9u1VL5kLk12G2Pu6qzXWrW
         1LC+ycMi80nqBiTz7AbP5bp/rONcJ1G49EnE8V8GfvTqSs3kRYcvVYYTbaxOp3b/6Mkx
         YRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774872211; x=1775477011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h/pCkZp0kOo5osdLzRpybPSjj/VyMtaU3zoXyQksTzs=;
        b=VinU2be6Zvan/pwt1lmuGgTjCfxyJQkVXm1G1Cnt8cZPwPgJzloQyHZGzpkmpOR3w/
         XGIbLxvouwoQaB54zbXnfT9KS/5ZdPZd7q8KBysc1kHEXogh9FFkbX55f5F/8SCxmCUU
         rDLW/7ezMU+Set56ARcNWyjPCJhqljtkOsk4VPAArJVIXCcjRolmAdfq4qDoQr4c8r/s
         joyWM47BCyNfAaxCemFTuP7QbZ87e0gaxbKNtFJwuSpb/TVEJwjxZvD1ocqkMENRJLzH
         He1NAg3zFFKcAvtADJ+QVJJWIvkevdDfDY3bhIs95MyYoAzV2Qy6ukkNU7k52DbEHVd6
         utng==
X-Forwarded-Encrypted: i=1; AJvYcCWGSACqsz6EQtG36P0mp3MltLnu2p/yjZgr+i1t2zwpbysjS5NFuI2WkdwR++y4C/5JMkBXhAFAXQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4Z5ZOs6TaU+BUJ45gIbLnRSKjDuyCmFMa6bVS1fGrj/kbhwUF
	Y2qwcgpyqm1wivDPWRRGx5k+iIzxXk39Oji/Zy3mK5PEpt5EP6QaoBNWH/sxIVUrvcU=
X-Gm-Gg: ATEYQzwQBMqqVlKSvoUjqxh3CiE5OCj9m1pFgBPdDMOF2D7mMB0mYb7Mcsf2Maiddpd
	uCU4Dtmr3ts/ixKvgcjqoQ0fkFTaxm7N2LnUdysqjNkevn13eIDIqZ0HJXI6M2FFVCNMkJeLxw3
	y66TGQ88dyExbobtmVp7rHEx0QYBy1PIAXxBTyeoMFoAMqV4+hpxLuGQhxk84F+HWPp/MpSJZFi
	g5rmEw16NKldcKaT9rZb+LoqRIAuNwdtDjmFSYsyRYSzbyUjrD99bjxjs0jT3P3+Jrv/MTvIFo2
	ho9cS7/mdAasoiXGIVp/fiiQy9Vujor/6xwXg9yngLjT/jycmIEALmSSuVGhRHequXV/Ol7R2Tq
	NuL80sr46y1/SH/PTeMSpEZKb87QYypR5Wc3n/ndQhGYkG1GECUT3aH1hZBjqOD/CerNdc877XC
	UcIZQ5Fliser0hEIEiq8EvOQZwdp2Ap5m3OiyC
X-Received: by 2002:a05:600c:1d8c:b0:480:69b6:dfed with SMTP id 5b1f17b1804b1-48727efabf6mr230701685e9.24.1774872211429;
        Mon, 30 Mar 2026 05:03:31 -0700 (PDT)
Received: from localhost (109-81-17-175.rct.o2.cz. [109.81.17.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48727192012sm79669865e9.32.2026.03.30.05.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 05:03:31 -0700 (PDT)
Date: Mon, 30 Mar 2026 14:03:29 +0200
From: Michal Hocko <mhocko@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/percpu, memcontrol: Per-memcg-lruvec percpu accounting
Message-ID: <acpmkY6_gWLdtJCB@tiehlicka>
References: <20260327191936.1980054-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327191936.1980054-1-joshua.hahnjy@gmail.com>
X-Rspamd-Queue-Id: 07E024000B
X-Stat-Signature: s6b9pxwzn88xmgyfm73z7bywo88h5hd8
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774872212-625854
X-HE-Meta: U2FsdGVkX1+ayz7IqsTmCOJ+uJ6Hrt18SVMss0Yj1F2l5TQgg/2C02jiAN5LqKGx6/+L5RE1eo7NILa6kisbdO9RkdKoAl/eDOxwwzvF5h6wTovN9LkHggi6nXQrgwBGwMVJJbHWf2xYyqVP3Z4Yba0CmPMR8dNlkT8lCZzH5jgBlL6GDYf+VGd4t0Y+1em2gmzAzX5D4pb+yQ4f4pM/Gr/dOUlFLtk2xBu5OQKu5a8PSSI7SXLS2KF7ewSmP+3pkTygFF/NWFs1Ws5A+3cSadLLJtL7lucBebu4W8irBGVDwIK1/BgRzEaxCQF2mp6G2nD1kCFQNQdBa/oKAhXt4C+Qx/hX48ULq6cVzwAKCVCpvXKpx9Uvc5ZdPvpAMaeIqwDv2zU3VuuG5Fc9Nyc38iVuQ2kfoB9bOlWpyhvQ/xvz6Fy6Lmkbh2REWzQYZ+uWKjTEpJD8HejFFPPPyiL2GC5LJj8kKlHlKs3xGqzJIQd7Msficognps6HYkZof6HcWyzsTb8tTq7P4Jqsqcm/lBBiMnyRbCpY7xA5dy4S3kHPAw+b4fohY2c4Mk7y4xOIonEAll1rYEzuUm4teF9PMNuemIgWz/rZxyoOmJMzHB0n06Pqc3dJx31ViIgiaG3ksGboTAUaPGtWZGdvwr/vXbKcNufXKUVNOt6Y0PX49kKdPZv4UEB8UeO77rwBOBN0op/2goHXzmykvdEBpwSKiHI9WZMzaJxlFVxynvqOxSzPXD7vxAR7+vqf0thTsqmYJTADWFxjebgA1EZV2w3xGhCs7CNfns+hQ9N8I2KRyNSU5CEkCiLnhPPfrjJVjgX0Pkkucsgy8sliv0UCurc1SZOD1vpHhm9B4qNA8qqkYWdLUfKvV7Yfyz2Abh6kWEM5iWsWSDqWzE5BIze8D/QRolzV/54tVfwNlTfQQ/ptVckIEQgaO5+jRi00uA2d8xzm8tbBrCiJ0rZWUrlsLFN
 gxyYTzex
 mHNklvcn1prt7T8jt86dPGH0iDGFKVjuRfOjVw3LAIWlH8cTRuY/YemSTTrlcbZIgBV9AwYAq7+9ToCa2fkjGmjWLzjmdIe2WmGd2/Wm2jOZHV64dcVYYjpdrmb9ZHrDPFf6b0alcB2HX80At1Whfi0tL+DiSTofuBSoDXYsuF6n2wi6BJc3cKTPBlQu2Wb43W+B5LeS9mLaLDcLFbJC86FQie9QgOpZRwz/jZGzoBUtNG78Bf6quP6qNed5CwoTmkSDcZglY1/bcAHL53giyuyW79HzYLdEWIwxSNeVMh7UzaYpjbCueaAXn8059pWFZPmxaoJKZF/ImSfw3Z24nQ4N0mRXQhqzAlFtlAEUPdTJcMSTVz+fCMsJMkTdEXaiikpJt3FCM5FNnxNnslwIPLrNm5e5FGcxP/P/Xpm7e5chxZOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 27-03-26 12:19:35, Joshua Hahn wrote:
> Convert MEMCG_PERCPU_B from a memcg_stat_item to a memcg_node_stat_item
> to give visibility into per-node breakdowns for percpu allocations and
> turn it into NR_PERCPU_B.

Why do we need/want this?
-- 
Michal Hocko
SUSE Labs

