Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4403B103A9A0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 07:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9822B6B0005; Thu, 26 Mar 2026 03:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9337D6B0088; Thu, 26 Mar 2026 03:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848E66B0089; Thu, 26 Mar 2026 03:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72D266B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:14:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DD6B13C07C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:14:41 +0000 (UTC)
X-FDA: 84587351562.07.B3DA83D
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5CF3E2000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:14:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VPGtndNf;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VPGtndNf;
	spf=pass (imf13.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774509279; a=rsa-sha256;
	cv=none;
	b=2qm+Z64M01Jdakd+JEEh6sxLCPDqbZJHF/53yi53eIrToJM4OlDsoXG/pGriaasyP7pMXC
	9Uz9s57N2n0m4D2iMtUNGnlDwF8xT6JdyYDMDGqj4CRKAslkMBV69+1oOfvOt3iCdOpbE7
	15lG6TRoHddYUdnWyqp3+LOrvaR73hs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774509279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7GTqNCxZz+temTmIa0TXKM73KUwCVOSRtjD1pGUBU8k=;
	b=Ixv51sYrXE3irHt87PBStbz4YXjN2gYe2s+1heNSzZwLXFQc2WfVqeiINYLA1koLAQLIn8
	XwPaKYBRtZeEIrOdW/+iq2GjyziCNLKEdRaXmFdb+Pn+9u6O011566Lx29ysshM5DYnxvH
	SQumMfiQSiGHOFVwlboF+k09ZyFeOG8=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-483487335c2so6631535e9.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774509278; x=1775114078; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7GTqNCxZz+temTmIa0TXKM73KUwCVOSRtjD1pGUBU8k=;
        b=VPGtndNfbWupcr44aZLDJdTCKN3hJ+5rjC7VjUBwvJnINrMDI1GCIGeGTgQOFx1xHS
         NocFz8fd+e5KhBvon0dNEXzOYMvBMAlzI9KokHv+M3gV9TlGGCdW4AD1MSgqGuUms5nv
         79/93qEzt1ZF1bgScmN8TDCrVPMoLeSFJEBZ4Zlpbnlsa8FVzRvYdDGr72NOn9psahrW
         aZ3jHdt+fEQC+Q/u3uMDsbUlgXArV4/GTPTGgX3Hy2g9itDVS4/rMs6/2WnIdO/YKO1e
         Qb1xs6O/ignpwNRluRNOMhD/xt9dHfWAlUE+jO+X8adBsw96KhHVKUk2DsYvnj1dBzV9
         Rfww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774509278; x=1775114078;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7GTqNCxZz+temTmIa0TXKM73KUwCVOSRtjD1pGUBU8k=;
        b=bGdQEDj94/qjAalZgkdqIjymEPYKPUUIp/CM9UIfDKpWAhMY3/4L4ZVQ5sppCQdjai
         eRSEZexuH2OQfgqbg1oGk7TNutHZqUHWt4lIROkei52Xpl7dLjKbEyLgHzfFxb58J1iQ
         S+2lzu5QTc3IO3mI8BjS1beJAt8JzbmpCyW9zN66XmM+1ARue4Iw3rfvdBSr8qG+Iffi
         K55FwZH9cDaDXgmKtJzAjawMw8iJSwVmr+t4zIDW9WAoKijNxLCg+T274U7nM7GOFpK0
         wqQfFeOpCexw7H+1k1K4Y/dSSRmRQAnxCkjs4zJJqJi7ny5PMZJEXz7amW+KntiztMwK
         yrtw==
X-Forwarded-Encrypted: i=1; AJvYcCVGAOODRRJ1kWFxR3feOCb3oBOVNe+taFm1IK+igL3mJMrIne9+gnZ7LCOfecHZqQmRRA+aa1XD4g==@kvack.org
X-Gm-Message-State: AOJu0YycZnmdpk3gY/iZQFob9pge04WHwtSXmh88xYCZm+rcGB86AcSt
	ZWU9D3SEcBivRJh66n0lCFuSBQ+O0XevHC8w3Tm/krb5ZtcXgZtg5PTLpdufwDSftq0=
X-Gm-Gg: ATEYQzxa0zqiL0O8pEW0c/KgF0ENbYfSI0sLsD7bfJndZ6UjDrU/YKHuW2LvcbakMfw
	Dx29cgmhAKoqYA7Tl7ODPJrEliCzwRe2q74nyJq0ZPHkp0XR/xKp8QTmEjApfq7jucBhtThuLjD
	PDbfsZMuXR42sycsubQAN2Pq6k6WCswPSJ2TmmWXdZeg4vWhDX4zdxZBC2KY6yjZSMn+8l1XAV5
	HzZsbY13+GcHRHEzDvXPsWWiAytGVxA7K/sSbQ2HSjD/GV0EzUsot1uDl3o/GFW0zzpunYzBn6H
	AZxLdS7osNMUGQrsUoRw5/QXMgnb8hGDAH0+MPYdo+Lx4bwclHRSCSa5JaFL5qjycgQs3lBArIF
	c4RC4b+m0VQbx6feMOcgU85GLWJVkvEMQNf2oGdt8ulTxlHlMENYqVr4IuKKMDxb1R2/e1g2iNA
	BG7HzcZi2exhnPqDr5NpNmwpJW+ziQ3qH4ROJU
X-Received: by 2002:a05:600c:8489:b0:485:b6dd:5066 with SMTP id 5b1f17b1804b1-48715fc366cmr91509995e9.7.1774509277961;
        Thu, 26 Mar 2026 00:14:37 -0700 (PDT)
Received: from localhost (109-81-31-149.rct.o2.cz. [109.81.31.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b919e7372sm7234784f8f.34.2026.03.26.00.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 00:14:37 -0700 (PDT)
Date: Thu, 26 Mar 2026 08:14:36 +0100
From: Michal Hocko <mhocko@suse.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	ljs@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com,
	yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
	mkoutny@suse.com, akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 0/4] fix unexpected type conversions and potential
 overflows
Message-ID: <acTc3JugF71I9Eep@tiehlicka>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1774447069.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5CF3E2000B
X-Stat-Signature: ob6s1qk3ikm1t6mch9cammy85spiei6s
X-Rspam-User: 
X-HE-Tag: 1774509279-98381
X-HE-Meta: U2FsdGVkX19yea/4havUVKOf2AeOVb1JYiDYVEXf+srflzlbkUJUrDgwiiL9T7hnkTtm+daWvCiB/1stdjxiFaEDw6ONFCk5atmqFtObzUGaSVHzUumIgfx0BgGXJvyS8VzgxAd49qB/IffdHepdAIWfr5Ak7cjzRFyIdhq4faQg9s/RWlT85xKzoctkuVp+FXNS36/Im1jZhe381w9AYTrb6Srj3Fb1Nv512ZONHJm/lXkHLbxhv85bfkCfIpkxSYQ+AXvNjtgnD8jgbcderOixVjoitqBDG9SwynSrJGQy7Zl5pHvFBvzvWwEjy+eXLni0OhkvHMg4Pp8UDNy8Kl9MLSKWnsyDuJkPe9RhT58/+fL5zf7O7T+wyt45/YJLMtmWAYJoxhsjjda/fi1mZvCTI6mzlPQ/W0D6wKEv62sdNXOffJUIUqOUfn3NHHtMLbExvvEB6QteGG4WpCKjwvm13csYfsmllKCCZmKLtH3d/RpzQfLT3T1o+RPWJKjyg0pTIzqDo85Ik8xCqVm4/5LZe7uGfE6FMON/0XZigtEb/nALN30OnsjpJlwdLBGeLEpC8Q8SpmODiQ9a0DJUxO/optzwq0hvmH2T2TUiamyLR5D9m9lcDw6xQpB3SvGNepfyGF10q93eS3v8DaQUj/5eftuth/8/JwS+h8R8hWR0xmWxZ7FXuRql4V3JTKp8PuoMruIqknhP4m0gseYyTMOgnjqtCps4zE/vkakQTpQ8wz+/FyEPBgwwjbwte2E/hK2Y2+Y7ZBs60ulvvFsn6v09M+9loKowgtNejRr1OZZ2FCkAJ7npdPLOQPhEw8yhystIK5p7nSRwgRCPOUDvgSTWEkZkGDIsw7m1NIo4jqIe7NX0TnLxycfpQgCrR7zoYAs5V6igjoIqJf9ISQbEYeASCrZRyjQJxlgkDob2OfnQ5vLtCVw/t+O8tJtHf0O0K8kTBo686unQANCmpWs
 yMybmQcg
 GIrWp4Wj1ndh7Kn1vO30iyR0h3SPhtYNxECBsFIz+3UXKrqX+dcsmOHshdOAhdqoFap6TsZnWYjNLtVlFrWjCj/Zej3A8NHNu7Lb56gbI9nv4ERaFYCGDgZawoNvGWJNwygerQNlPrPcR6N1DLg26hqBMdPP++c4ZiKzDswBUioUQT7+8sNii7Iserz1wywEupeVKimYdThzHrzx/sdt+frIx8EEN02x4dZX+hXOwx+u0Ab7czPAOY2avAAqIArkROhZv4mHWmyjDwFLXMs9Fne+t582aKWvs2LIWTEMpFmFyXkiv6p+pH0VauhBfO0wExldClgBO7pRXolBA2QredYRlp3yc8CslnkN9GQF/gm7Qy2hgPTtun3Q1Fadi6et8B9TL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 25-03-26 22:13:21, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Hi all,
> 
> As Harry Yoo pointed out [1], in scenarios where massive state updates occur
> (e.g., during the reparenting of LRU folios), the values passed to memcg stat
> update functions can accumulate and exceed the upper limit of a 32-bit integer.

Is this a real problem without reparenting? In other words is this a
follow up for that work or something that we need on its own?
-- 
Michal Hocko
SUSE Labs

