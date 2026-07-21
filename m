Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE728C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 17:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 951106B00A0; Tue, 21 Jul 2026 13:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902C16B00A3; Tue, 21 Jul 2026 13:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA8C6B00A6; Tue, 21 Jul 2026 13:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4846B00A0
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:18:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D900780250
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:18:26 +0000 (UTC)
X-FDA: 85013442612.12.4333ADA
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id 04AF140010
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:18:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IMNANpi5;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784654305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiPzgqRnSOFoo7wTJovboHrNHjQGCGe0NFhohlpad+8=;
	b=1bWha/J6rF59p3NSgJdU4x5F2gcXeg+9G6dECffhsG4LhmnKLGOMcFdhDZL10HfWgGi57f
	PT5EW4hQ232VzT0vGtmEyRcT0fCrvI5jj7t2IVPilsAxZ15LUK6TC/MFQ6TJswmkmxNxlr
	a0ZrMFgRSgnLJGHtHh69/ldSjt9jvwQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784654305;
	b=XMsIabWaNmtBRrQYPpknpyevVduwjJNV6Bnx4iMuLhIIVIgdGTom9i5BPV1LAlpcvY8ctS
	HPbjAXoPhZWjx1J2uZKy1WM6InIDEHTdClUod9pmxW0A+jErVCS7W2836k5URDBpvSwYzn
	k31qkCEKEHJdgmAPkJMHYULwyOgQpMc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IMNANpi5;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c0006ea8eso89837651cf.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:18:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784654304; x=1785259104; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SiPzgqRnSOFoo7wTJovboHrNHjQGCGe0NFhohlpad+8=;
        b=IMNANpi5MuXwwNi32IasGZ2jEl4v287W7x5rrCkZGSRJ9jh7SE4orOiymnFy2sxMja
         Z6YathVhxo38lxN9R7fhtUYIe1VMvrIEUK0Mh/LTe3m02MwTNopSy00vS+KYOrjvMMH/
         RtQzl6pKN8BKuvso8PrFjxl+shWW2vS1bsPYW4vbfIokKc636hhXeGNIKcQ3qntc/rQZ
         CBvUtNJTobeXXNcQYSFGNcZxyQFPpQNV6WwVPrM9ISCtiSLxSoxfsxgCAoASt/IAlv1f
         Nnoj1OIPtS9p/JPlrsV8Rj2XQSi+oGyDKtQK8JH5hRZYwlmBuHW3IZoYSG+SFsMMkbXQ
         84MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784654304; x=1785259104;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SiPzgqRnSOFoo7wTJovboHrNHjQGCGe0NFhohlpad+8=;
        b=ovEKSd/SFMltNEzhtLbPyjJ3m3gSgfJBdIbIX3rzpnREGP2+4YswA3ctRSjgqKKYQh
         yAISyFW51kRFUvAAcm2zg2HqGEn9N0Zx3ch+/VXsZQDRDvcXwFecojh7CXBj/UNPHQuu
         Zx5RzejTrDA/DIhRO2+jTffTLlm+pFBMy8EUvb40TWjSBwwsWIS7qHuRkcdAWA5Ncqbj
         Kjr92W9L3t8/LXhbSw05qe1nTZV+xe/mb0r5Hdrh0Y/No1MQgE/eAgTAGP0ASqjZ8KDd
         42nUxssPktND3istMi0FoL5ecFyPhAXiF+pn4cKymTVunKHj0Mtauh/0t1zqiMatWUSu
         5dMw==
X-Gm-Message-State: AOJu0Yy+QZr0CJbdVhWskuav9io7AIxQ6rhX53Tepv3Q8jZla9lXsXqy
	MMaOWdl1TVPytp9OFowneuLnM+Io68Sv1SEALx/oOc8UTuu6ye9odfJ99BlitZfUfvw=
X-Gm-Gg: AfdE7cmRoTc9piItuyxQPr3UTXg/D1ANwzdJVoJ0xBEL5FxIi/giwm9vip88JNGSgKD
	2rjQrKiCF+Hb/OKpmnhgnOn4KlzyeWkJXTH/KDOL0P116zlIOHrA3Mi0nAGj4++FFUg/zfoDk4i
	V/CwJff58Zl28idgQBwKhEky8gcQofDELNfzg/WVl1MUcIC6eFpRgHvpj+/VkFF2Ga3XE+GW5Pf
	QZv7b8Ypt7PIgzigPh0yfQFOM/+oqTkRZibonmRQp6JerQJkal4SHtbrubcExVAd4cs6ZD0q+aQ
	isuOHbkUCP1Gfd6sqRW8+qOkQRGWkz2TXp+2x6xci9QIuusCZFrWpzNLldgx1uJcNebrCkpXk+k
	YqRGM2HTHqN80bu70bVB7IEqgM3dI+1hBsqnpa2g/3iVXZ3NbEZvdG+Qe6O5MgpmKytX9KE89ts
	q0/Hx2Gcc3DjadS3Wh890hq63Bwluk1jrZLJ4LTiRodnJ5T+XS9YnPOAtndQ==
X-Received: by 2002:a05:622a:5789:b0:527:7521:3f8 with SMTP id d75a77b69052e-52775210a4dmr13363251cf.44.1784654304162;
        Tue, 21 Jul 2026 10:18:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5214f504892sm98076131cf.20.2026.07.21.10.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:18:23 -0700 (PDT)
Date: Tue, 21 Jul 2026 13:18:17 -0400
From: Gregory Price <gourry@gourry.net>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, apopple@nvidia.com, alucerop@amd.com, 
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <al-pkvmgIxGu3LzM@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <a9c52bb6-5e04-1d41-913a-685a7be3fad4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a9c52bb6-5e04-1d41-913a-685a7be3fad4@huawei.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 04AF140010
X-Stat-Signature: k4dxcim1ugm8jm7wztjx1u3hx68c4oe4
X-Rspam-User: 
X-HE-Tag: 1784654304-11639
X-HE-Meta: U2FsdGVkX18yswJgle8lHc87gK75qxsvuwdBgdY/xfT7zcV07M5hPX202CftseDKJrY0K1C9YxbvC0/4iaY2sTaTOuA1ntBhtqkDBqtdlCxB94yRjhZyWoYwySBf2MZnIsclPyYuhJ47fdXpU5c+7TtWzKs2YCq2f6wKctGcwt/pEeKpBn5czxPqJxwenfsBViIbjIMhZotzx6md+mE4rfloM3FV2XKqYOW1QuVKRAv/3L9cAdgIYbi541kvMlna7iNyPD+Z64lgkiY5aiIt6Q8yFUqNYlkMynI8sCra68jeuQIP1U4oDcxa7lEZzwHvB4trzs3lvozktRoa29R+9UdfZENVwzCi0D2k8UCfEjX/yxJen9BN0DGbcd0p9+BfrfcZafSZru/ZOhevs6ejqOHSmyML+fehU6L5cPMrRt5hn4kgyeB9BQG/enBcdPG/T2EEGoKAAsn3ZkZ0Xfmk4xQdVHrzUBf8g4Af2VTNmKJrPZzyH9aYQUndBY95/uzi5QPIsvj9PtIEd6Ng+13faotq5FJHkjvq/MiCIO5F/1K2wxdmyLXczN4AlwdcyPnHnyPSZKapPAnlCuAGoodLBz4PKkAf/qp3GtHWOLKWA5gC6Exk/19yjbstjpil510wFAOD4sBczNLTWtZlKQvEovE3tQtvjbbIQ8M93E4t2Xurboqsd9YSWNae8yc03azNyo/h6RpjnqVnAbFFfQwlBqhQN3RUDyVNWPgXLq44vb2pkRhqegu4wXj58bdUl8pWm9d+wBCBxkXWhTFL1RkoMD7kx40qT76tH94v+cqnJgIel6n5cEWtimTRr8ECiJ+RqaxmMvxfiionioWJQqYmBdRzCJ4dtflmINQn5j6ADSL35ZmQqSzeGL1AMMhMUFa/v4PCLG4K6U6cTcsRHvPPE1dd+ShVJDC1xMPnwBFWTMEmiHWcfcQDXfWayw1BYA1VcP9B70Irl33J2pqdAsV
 XeP0ScVf
 wJ0quH4KLqb5BBlHyzkxA6Uvg/YOB9Xu6eAP+cJMalV5DsOAD8qepCX13gIieOu26f2EFdhrC3YY35gG9bG8ND3wZj3DipVRIRAdCJraTDHh8TD9i3lSDpQ9olEDiHZgqUzWKQJYUOcrpwVXsGGwFO6QDksxTCqHCPMUGCso7ffLRNzMwHO7C5gtQSTl/+ZBRTuJt5gAoAoUiHog+BLN2xih/ExD/1m9nEs3Teg+KMjmL0RGLqN2+vJNl0IBYra/ovkVmWDP8FbYSxvPsi9ruxgzUyjQcXb530HaI13TBQ8OfxLX+YTsRJNg8iIZmBcDd5OI7fSnEq3f5hCwSEpvkSN7GHYdHjjRPDaijrE8Ae4ylzxz7O545pus9H9Vy/YAinhInLtBX6N9a3DeRA59fldOOl36jiPWrFEaKWP6ONl687HX56Qq4/YGflGQdkiz4CFvmH0KTNQHcuVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 09:26:09PM +0800, Zenghui Yu wrote:
> On 2026/7/21 3:33, Gregory Price wrote:
> >   KVM: guest_memfd: bind backing memory to a NUMA node at creation
> >   KVM: selftests: add a guest_memfd FLAG_BIND_NODE test
> 
> I can't find the last patch in my inbox or on the lore. Not sure what went
> wrong.
> 
> Thanks,
> Zenghui

Apologies, my email account got rate-limited to the number of recipients.

It should be in everyone's box shortly.

~Gregory

