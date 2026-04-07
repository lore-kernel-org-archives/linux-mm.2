Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10801FF512E
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 17:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4781C6B0088; Tue,  7 Apr 2026 13:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F0A6B0089; Tue,  7 Apr 2026 13:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365436B008A; Tue,  7 Apr 2026 13:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 274166B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:52:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D744A160924
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:52:17 +0000 (UTC)
X-FDA: 84632503914.11.C9FD4F1
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id A387BA0017
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:52:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YL9nkxQa;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775584336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0ZTt7KTo1Z5++sDXYYTj6JcPbx8mSVmg26ovVl8fYI=;
	b=1CfkR6AXHZwZjJfR/y1MhKK293ydNIt2Da2S3nZih3a+bkgYMEMJ9TdFS1oXWcNWcAKAEG
	tI9oB71OnCZQO5dKmMiZlKqwRweh+ixQYnIGM4xzBsORJk/JJ5otVDGwSJon9i7gY/X0Ow
	Hyq/GlQu9daslZmsDcHQCP0MgNdfUIo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775584336; a=rsa-sha256;
	cv=none;
	b=iKILay6+LAbQ3k/djmVDn5e4pokzicFQy/ZEaQ8QlHjqAdN2L8rSexfrHaYVJZdkAxcSKp
	FhXDQ3H39yeOiGweyAu9uLayCYubMAEjrSQ+tOU7wtE4a2uZOUXlqPllbgsWnwPcWuIvwL
	KPtqtyouIDOvOKCfkzPQVt53jafjxF4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=YL9nkxQa;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf15.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.177 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8cfd44fa075so675064985a.0
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 10:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1775584334; x=1776189134; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=f0ZTt7KTo1Z5++sDXYYTj6JcPbx8mSVmg26ovVl8fYI=;
        b=YL9nkxQa3l1KJtA/PVZcl4Ak8y/HsPo+Dm9t7znZMlbp6uSF5VreVzMG1MuPP1zqsc
         GkVhnexz87AKY8/yqMkzVL6EM2g5eay1BrcrqHisVWyndOc5IFuhabuQ+/PNkQSnAzCI
         Jqw8pJOZPmlTNQHmcGrc5cHGcchkkWk1+ZkrlNeLiRBBdyuGaHU8aJzO0N1veKz4+lgY
         MF9TvD32M2hpD4FzBvpIaUxVLCRZozvsp1nAsBGaUQ4RSztWb8gda0pyOmLd0I1S/j0i
         QJfOqGjgyk9yznJaqHRir7nD5e1yie2si0swZsVwc0FVQMdX3j9tvukpuAf6WyFOqkDZ
         D8EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775584334; x=1776189134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f0ZTt7KTo1Z5++sDXYYTj6JcPbx8mSVmg26ovVl8fYI=;
        b=f1mLflz/6rBiG3iC3Ot467u3ZgpbUmt1UASSECkwZDHoMrPANEWzNmtPiqox2L+Q0P
         85ia7Vb1ddaAVGbOqN8c4S1K0RqYVbP3Tcy9lpcPLZc1EbZlavhTBFe07VO6JCixdBOM
         uN8tL/+sivwlLnNhmHpjB4bGgtXLZ6DbdJpGuvDZ227+f3dTi2tyjXwLBAlYZ2qE8QFp
         q8MBcWEMPrF9hSV6ZpdQE46to15utKAEvkbvkFy4sVMhdLBaDEwdKckiStZRVZwouJhd
         KSsp8n/XSp/6rZeVPb2v6o+Qt7iWXbJrnp95krW+cw62ag6DbBXYSPpyCYGxwgtd1DkP
         gCTA==
X-Forwarded-Encrypted: i=1; AJvYcCXiO5QG3gR7ZnUVrfzyFl0u4ten2RVrORi0H7L/BR6quLK8f64IjYJaylIFSX4jFXtLvIpSlAn7jg==@kvack.org
X-Gm-Message-State: AOJu0YyxBK9ITqxZ+VzF6+614lpLTA1/BUPuc0AL56oJyef5H7YI2COe
	v5vu1jmuXKXM+B0mfdjSlOy5a9aOE5CdvU5/+d7nJJ4QyXbkdP9srsXMciDTZkUpqtU=
X-Gm-Gg: AeBDieu2a72kl2Bb7zYy5cRIFLsQD1MzR6nMu6DbCzToRa+efZoaKlRuSywvQ0Qa3un
	wumCKQAfwIevGvK7cMZgIfvDPWUUlc05Gfm2FapAxNSpI5gs8aPbEV9LfJnvlEIh4/PKdCjdHD4
	34kpbwj6/rwnbg3L7erxuWyOSkx9xZTsBu9WLP8wCWV2JlcNg3fhQ5U82qoUJTvKzaOzM/f6OJa
	FWbkfxM5AsuJfhqV9FYQjxtjp+tMO6H1UrzsIKbQPxQ+wzg0gOyRriPx0tlHH6mypro+lwyGjMo
	pO3wWPSCdNLxH/3mzXRYGrShkf/LVnJ3O++rmVPKe8fWJXfCI6HID9dHzR95LPtcw6BOhRsZtTq
	2nrR/FyUF+aVt3vnmLIoPkeSFCR75WisyuDQWI4jLou3moGVx2I7lh3LbpJ1kGjTHcrvwXbAgbc
	CWPgmCE1oUgPdejI2F2tM15Q==
X-Received: by 2002:a05:620a:171f:b0:8c6:ff8f:58af with SMTP id af79cd13be357-8d41e244447mr2488312085a.51.1775584334577;
        Tue, 07 Apr 2026 10:52:14 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d2a5c5fe8esm1376946685a.16.2026.04.07.10.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 10:52:11 -0700 (PDT)
Date: Tue, 7 Apr 2026 13:52:09 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Gregory Price <gourry@gourry.net>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	lsf-pc@lists.linux-foundation.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>,
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <adVESVyz11NMa7Lp@cmpxchg.org>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <42e26dbb-0180-4408-b8a8-be0cafb75ad9@lucifer.local>
 <acVPrEyfcE4Naz5b@gourry-fedora-PF4VCD3F>
 <248a126c-43e7-4320-b4bb-282e0b6da9c4@lucifer.local>
 <acbgIKuwDsPvPjdF@cmpxchg.org>
 <adTonuzmUc2AzUhp@lucifer>
 <adU3P9fk8h-AmEp4@gourry-fedora-PF4VCD3F>
 <adU8VnzlLw9JUHB3@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adU8VnzlLw9JUHB3@lucifer>
X-Rspamd-Queue-Id: A387BA0017
X-Stat-Signature: 1ebsca3hwkrt6i89x5ys4hg7dndohwfn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775584335-947938
X-HE-Meta: U2FsdGVkX19QV5U9aER/LVZvyRy9XRwLg95F4vHc815OQrQYJ4ZdZoPBaq1WG+2L9JN8ztDX50uxeXlkZZR7TM2JWfgOVwpWRYB7i0O6f+raP4ijyA1Kr+9dH9h1hkt1L4iz0I3qJWNN1PQbfmbkk05w/CV0ne0YSMTIAqEaiFAuVoC5tG5558D5nn7vhahGKF+98MK6Wf8+z///FH5tgVb0HFYt+R5jHU1YnOMMgFPIFlPlIxV4bX12ijALUUGBLhZ58mM4VmMFIOjuKjSJum7IjsEXs9cqKvUAxy8d/pdaH6pbhEClS2+w0MjSuZdC51vFOv0fXl4rT1lbCaxIbeZweL7SHsBMJyrdEMwLRWR8PtfZUpUG8QgDFt8f/LemdYejivQWn4Yz0iZSHtdm3iiE4kggyPuXVtqK8UfqFyzXQIjHxVg5S/otj2jJiacYNNrnahkd3nxmlulcu3ozPiE6lr1YSby3BjLOhPCh9Zd2XGoLmwixEFfU3ii8+j83wKQL6+uUb1GUS0kjfSbIBVqen++D/8/hv1hmpYMFEVEKGbwzS5yaVhhR1r7H0E57ZYZvYCO8IPNMzlxGrFga2S4vc9jXWIKxWL0x+srAU/jR9lRShF+rsgl3lcecH3wZ7MK4nLfSQfIVu/A5u7QBvjmAD3LFSuVlC+1o5x4ZK1VleSXRkYBjAPuKvH8wBaIGA1AeWW5dv+R1lNwTs7uS1S0YVJQ+LhKJatfbwoTWTLlbmTrZIvWxnFRoTpuBCU6SjkVu7dpH8dzxCHuyT0JWxsmzrwnNhQdcVOp7BsijeJCqOmUuVma+EURqgqx7rI6G/zeiDhzySVDi/ybTKp7sexkpP/Nk1FZVfh/N5vIE6Rtq1lUN/g3ddrsigqIsVhIRadIoumVq8bXLFlpyFTQL8Q+PGEDQGnOsyXy3nB8WwLuSw+WDgvc/3RL4Fn9fZQh5AQCoQqqBMSgnuxhVRGO
 iVW+Q4We
 M1j6IFUO2wNdRnRLyHbe9fg6n1rknk9EzXlQVaXAD8Rs5OscH6c0ZwB8Mzu35b0p5IYQrcdNXlCPR6W52oJQky87hBqoyFBsMYFSJAO3fC+FbZVf8pVBlXV3v9dJJcxqqrNfs3seekSyn6MgbNbNz/QBr/oelDwI8UBVK65OP78mjDv6NpLH/F+w2sUbatDHJEfOAwoJ5h77p9PsjpJi4WRZjxuOwLUk4jJw0jDMvecLsbfc0/RwAVxg2EPWYOXo9YznpSWPSnubPRW9SmoM7AG8mg6z/iVHaoXdCr6BkBMFyVGmXrumVp0Iyr6DVTPpQnuIZwXCw72sCFoKVtfoj8x7EqQmZbY8I12GPTPMAYGzx5Q6Y+FpezANUpvZRxnQq3gwBIb+aF8zd8q5n9Rg60FoTFb40wVqPkJQMs2ca49D0z5IZHUIyto/VK1mhbeBdA83sBqFq2UtAhXA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 06:30:55PM +0100, Lorenzo Stoakes wrote:
> On Tue, Apr 07, 2026 at 12:56:31PM -0400, Gregory Price wrote:
> > Might as well consider the functional testing question as well as we
> > decide what those interfaces look like anyway.
> 
> Yes, adding unit-level tests would be hugely useful.

Do I know just the tool for generating these...

