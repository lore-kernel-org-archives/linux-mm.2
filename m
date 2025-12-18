Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDC67D6D22A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 14:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422166B0089; Thu, 18 Dec 2025 09:07:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DFF46B008A; Thu, 18 Dec 2025 09:07:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DC2C6B008C; Thu, 18 Dec 2025 09:07:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4DE6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:07:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7AA21401CF
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:07:24 +0000 (UTC)
X-FDA: 84232769208.28.E2EA1CC
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf14.hostedemail.com (Postfix) with ESMTP id E2F7910000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:07:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=tx8mu3ZS;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766066842; a=rsa-sha256;
	cv=none;
	b=ZVdZu39XSU34YtvWbmwSTB3gM//HHlGGJL7jHyCr+ZLEUV4ozvaCSo//z6T+esOgDdapzE
	4iARcJth8NDw0M4pTK9JGjYaBFIM2Vh7HPKSSrTXoz0cWQvxOFZGJpSJuMEiEyX8ScTRZm
	g8+FMTnPgGU/EVJCHyw+z7cBufbgy/c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=tx8mu3ZS;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766066842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3Yk/IRp6Zp7DBqOloMlN8iycWBryyxsjXHj1unL15o=;
	b=Gz4/tY01isjiaKhalsUGXUI3wZUoNN6CheR9UTYiQkegMbnob041/S2BbB76ZILsUmIEGX
	vwJHLkUdmwIvk9MAGlOVfOiB6bxfZW867oaLUfNtgOWax8cudSqomDglg//Owv/XHdNbEp
	9GxftWHWG7zbA9aSFd3+VQ0MAy6uqlI=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ed9c19248bso5321581cf.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766066842; x=1766671642; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o3Yk/IRp6Zp7DBqOloMlN8iycWBryyxsjXHj1unL15o=;
        b=tx8mu3ZSbKsfNg0sDxAF9j9L6MATEbrpbM0q5xyG+l1eQ1ghfJJHPChOFnq3OFkpKh
         0WpKVq15bxihajAcZ07hDhQmNabviiRO6zCtDXNfc+3cbeU0lo2JJ0Kigh5OwRQDIGUq
         uTuVNCEAt82KyoJKRPNNsusLws9q9vgpN61xgQPOZnpt6lom7g/jDw+Orx2wOytRSOEs
         lJGX9+QFqJHkep7r1qE4EtIk+rqWeILHDIqUhE9LyIoNFR4YTmYfLbP1G7nTCMayU4ot
         RDwt4OWfRv9/TFkGN4hkyfaOBn4l/1sZ+RIe324f+ET/dXltWoaKiacYYysb/ur56M45
         UixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766066842; x=1766671642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o3Yk/IRp6Zp7DBqOloMlN8iycWBryyxsjXHj1unL15o=;
        b=MT0QN5QdkoiiRy00B9w/ve2QKAF624ux0/BibFcc4+dE1HFG3U3EKL3YUi24pEDFU+
         TT4WPxQxzO3zpyCG+oG6nNsUnM6fSQT1MEawA+eJj0QsLaQ7hVOMG/XXBCn6UzwcZJPh
         89ITUJszvpJQSu1e95HRRO3LbnUBqhfWU1/cxb/T3rP4jHNgmcXP04uEKgBr0hRq0MTC
         ZScX0GpK9LXezkDg3Gm2rs8jqcZTiAU8rndvEqlWmRTujd9a0lKmRZGN84EGiA7YfJnP
         on+VWGGQ9uLSLFjD4m4TBgz/51NigarnXGvMZm14knuxWPYhT/pXQ0F9W5D+k3xT5IUP
         +s9A==
X-Forwarded-Encrypted: i=1; AJvYcCVRvoz134F1CrIDQ9dN0uFBxlDex3XzWZcO50h19SIpRiBcIVohQsWuAMbe3g1R9OZ4gfEJyCee3Q==@kvack.org
X-Gm-Message-State: AOJu0YxDR/NU5pdoXSVVYEdLBtGoF1SqsQ5z9sZ4r49bY5sQ85PJaups
	7a1EBJqFSyinqVwvN6AocH1OTSWkeD5pfO7H191f0dq681wEpVUT4HglYqAVeW1/Wfg=
X-Gm-Gg: AY/fxX62Ailuok8ixHgKmtQFJOt1fTTpwPLgDZZiCXF3mwmF8sJ+/o6DS5omsIxsIzM
	qMsGORSolPMjuCJLcZhDI4MXKLK+yvfvWyxWa9LCBERJYf31wDaAQ7vPe+U6j1Opng9A1EKlgEE
	OsZZ7AHxx2FiszEx2y64CP3TM+EQUPgyw1K4NnINJms9OAOhVOjFJcPknTMqKHDVVGKcDuu2yyR
	3YFk8jTtrL31MerKw8PNO/xNEu2n7yG3EMGhFH8zR5IkT3CpepCJdIzShreAzIBEJzClwuqBVHZ
	JYWYGDkYc1569Y4St6YCCfjSIeYsDfozptuDGaoOmZehD90spfMvrS0agbvTxXyhVH/F+3W0HbN
	01fRmdSe3y240TaaLAPAiyhjKn1xwLpkjfpfIH2ZQOCroK6D+UnGpXr1WIUddxJNGY24jG4Golj
	EV0oX0mQhkXw==
X-Google-Smtp-Source: AGHT+IE662eUXVCxzedx+R7CP6z1+RBNmbFjm/pj4Sw6Hxp9pdtcZdIHfK528VnH65h3sOZ1zf3hCg==
X-Received: by 2002:a05:622a:1650:b0:4f1:c66a:f36d with SMTP id d75a77b69052e-4f1d059c8cemr279117411cf.42.1766066841750;
        Thu, 18 Dec 2025 06:07:21 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f35fca94e9sm15687941cf.11.2025.12.18.06.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 06:07:21 -0800 (PST)
Date: Thu, 18 Dec 2025 09:07:20 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 28/28] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru
 maintenance helpers
Message-ID: <aUQKmOvR1uVfXqgc@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <a3ee89c663fd0f5b0f0c5579a1a2a39a0563727d.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a3ee89c663fd0f5b0f0c5579a1a2a39a0563727d.1765956026.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E2F7910000A
X-Stat-Signature: i69rue88texg78d7ekrhark9hwuhic5i
X-Rspam-User: 
X-HE-Tag: 1766066842-56678
X-HE-Meta: U2FsdGVkX1/HPb2FpIjfq5QOeFQ44JVVY3pUxfdcz3f8vyNsrc/hFSaU7KooQGeK/K63okUhJ+1c1R9Xc0JTwzSkClDlhz2HKqkE58wJ7y/4Nm5epEHbqgU8jcKdXrkcZZ3QWNN/qcfpZsknduggK373VkEsdXgBQKTRu7IHvqITHXh16aIXifKJtBXTh2/pI6/F02d9uGwjmWjzRk9ziufJZJhOQmKJ4nRMFn5w0JTPu8tgBY4aiKvEI5//4AH9Aqy6ZXQOs0CwILyNyymwjHpAReV5rb7lBttMqiLMLzGdWYD/hWi5jVnwXrryl/4IqD+Q5bmx06Zq7mw8/+a0+FUUl9igRWqcJmXpZ4Mifm/4PT1qXbznUB88QUOwIrI54EPvT6ZJE7RLQoE0plV13Pb9Hfly1/RPk35LiW2LF+ZSQ17WqSuY4YQqJ2Z9PTFCS09eK/f/OLFsfwNTIp0hn/iBzwokmdHqt8CyzJumyVZMbpHazdui0Nxk6dvvssenq3Zyw7NBNtVgyCTT0IfDEgm7DXdXob+NgtArB0t+vJAnCosrXApvAjw7M/WVv1SRgW3BIQxz6bR0MhbHKtGx1ksB76QlrDE9sUxTeRsrm/DtPF3Hmu4thrFdoIj5ZvYvV0Ic0j0C48I//RxmQujarW19A2G26uUzDs8a7HZR+QqLha4CpgYqjHidG0OrKyuIdmiDwK+WbjCbHz493r1VhHJ5hirAYyMsIptxr+ctEoGHs9yXirOkRLWcn8RMOTd5OJGynT73IWekZwVU4UnF/PIJs6slbfwpsJnR6yJ0GenupCOCArCJUcDP5dBEyzgq9QaDq6en3WufGkVwb10Gp8AETRyaabASwGT8kKI1eh1O2XQSuAojtPXGvmAAnCiEEQVPa+SumflXFgMjeulV4m60ayjRwewtvAy8x+wNLitTzPuVbvCUGhRvxRXX5f+0mgsX+K1H0Kk3r2V7CgG
 qbvFTjB/
 Ri8xD80OxsR/3AiaBTHhQgbeNm7kiCQWeclHE1b1Aft7yZuayXuoLOkwPtn8Bp6NxBwduypW3kSy6OQ/Q8vFk2O8OgT5dfxLRZ92jTMFFf4hU7W2o5oPDzcps7N60IYFYsPbZtfyjwXP14r9j0gD64B4VM42eu1P+p/P5Br+dTy+im5t+XnUAHBVGpDknES6t+YYwdkOlyIoXXemOCIbNkqLjD5hZpbc6Z4U3tmanE4aULQDbXOchPCiodf3WiCVCKmO2vFg19f6mzKQfQ9+FVmQHRj8+hVA3DgeSbPNoYyH7pujikdfOM3uyT+CerNARfk/ziDrhzcoUf9BLY2Y5YGCSPzWoAauV+MtoXhHOEV3/0cS6lnqGrMj3km37qziDkgWuo2bXg21Uk/YVX+Xekft4H48jscoRnTrA1yppUSEp78DFM3ZGLnf++vmBggf//VMmsrw14O1dF8P06i7nJ7nUeAsidZwwIDgGskkzQTWXeiyiDXcmjiztvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:52PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> We must ensure the folio is deleted from or added to the correct lruvec
> list. So, add VM_WARN_ON_ONCE_FOLIO() to catch invalid users. The
> VM_BUG_ON_PAGE() in move_pages_to_lru() can be removed as
> add_page_to_lru_list() will perform the necessary check.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

