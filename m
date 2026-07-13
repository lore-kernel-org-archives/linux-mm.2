Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C3BCC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 20:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB896B0005; Mon, 13 Jul 2026 16:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6CC96B0093; Mon, 13 Jul 2026 16:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34C86B0095; Mon, 13 Jul 2026 16:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 780F26B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:58:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 084AD1201A7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:58:02 +0000 (UTC)
X-FDA: 84984965604.11.0F7CA00
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 32F171C0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 20:58:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nvLUzCTP;
	spf=pass (imf21.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783976280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNqruOZIzwruIpGvkzB4DJORZxeTGWU0clCn+vXfCzI=;
	b=HMbyz8+LgpVyvb5PDTkRqltHY15gMohmHoOlFQ15QXRc0jgOqY0gxAlQJkl8phebfY8q7A
	7rPAROYU6TYhRuQgXBZvZHtNhWm14uEC8R/I0hspYUNdr5IBFe0Ud5Px/+7DNjR1URG/Qv
	J+8Yem48pdf6QkyRQ2/jBxbAnNFbEsg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nvLUzCTP;
	spf=pass (imf21.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783976280;
	b=r2KRpMj2UJiG8DQIC29iadYe2p85m5NsA6/lvKEhFsTN3Zq3tAvpokc0GMr0hobUVpJUON
	Dir+VVFUCmNST1Qo6pLyhglRwVshuV8X7Gaf3jTOZzpQiV9glgfcMmTDoE/bwpmJ+wWe/w
	2wFV1VhajOBJbK0TQALM0BfmSjKoA10=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38e07ebd263so242065a91.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783976279; x=1784581079; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=oNqruOZIzwruIpGvkzB4DJORZxeTGWU0clCn+vXfCzI=;
        b=nvLUzCTPGrPD/wGFJesHW8XnVugBsEBVGhVblvsNF7ruvDkFDcvfRztHNvarK9+afK
         lLLTwxy2tMkgDLkUPMrRDq2ZZvIXUIW9gE2Axo0ZLSQYBGCO82mCM+m6J78P40hsqDss
         p4vO2O67uBS6RI1ORuD+Hpy6k+HCA4qODKCncxac44KJUumntmhPr1JpXTeg85SP0vsl
         +FeCcLJ8w42Y44IUur78mK6H/tgWkSaLVO/S+ubANNpqc2/R9gZgQtPhe5BcRyhKsJtV
         ak1n/gBlVM+x/+ThWJvzkxPtyiFndfpYsJmqo75KWVJiKRy4lfvaor5fIri7x7v5WYUB
         DztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783976279; x=1784581079;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=oNqruOZIzwruIpGvkzB4DJORZxeTGWU0clCn+vXfCzI=;
        b=CIy46c40lGaF7oIfyQCAt5QTwvBpJ3EQbP2v4pOMkgYpLgWdCPnJLpNePR01dfKUk2
         CF8D7gOU+NRKTf2lodQK5lrIUGyTdG/JIvIE/GpERZA89RGdsBlGPbifPe610LPMv11X
         1ZKI5W1nv9Lp9o2RURpCIaomvdeZwa9vKeBVNEVx+5Z7+L+KRhk5CuHTaeJOryB+3HE2
         dt6hIqa/PHiJDuIn00nHDEOU8mRy/lv3D5U4nEsUbzt0Ft2MElKSSccXYjq8miK1rXD9
         y+jNiEZ6yENcxd2HBDx1FFL4HxDNgShifG6tbU08IkKlh2VaMa8EOXonvCo6M3x7Opjz
         LoNw==
X-Forwarded-Encrypted: i=1; AHgh+Rqm6opOjZOM30EM16Fk6dTbgCS+7DRztm1pd1ocpbk+3j+cEytHTt6xI/odowe0B+8K96Am0iw0/g==@kvack.org
X-Gm-Message-State: AOJu0YydPhSSmv/RUhrHCGu/hh20mJS1WsxKjp/KXQ1dHfmDaN0KISVW
	K0OarP1HkKsJfr+8xsRydDVj+ZZQ/DYok2Fa1jXXQ2ur7vRwuMVwbIvS
X-Gm-Gg: AfdE7cnk/J2r+55ddmYrCTzw1Vx1HYPey7keVDzxmksdWcdp+3WsWdsqkMoDItpj5yH
	/D76PYutEAXKHUWxlbhV0piAOdcUW3VJkhFLcYymFUKIdCG6bCoUA8QzPC8H7Z9RegyFWH5mn7B
	colmQA4hfEk0POFdXqlWdPn+vsE22JDAHZXdcyRAsgZbzdmJ7HzLNKqphsTAI4DSxNtnl+yBjR9
	86iKX67jTOqNy3/XJPS9e6hxD9TUk4+ELbhI8C3yF5ijVG0c+DZ9t7ns321Zw5AmAWF2VRl6vLb
	mRHh7RU7k8TLFD4uEk4XQQDbLrqxa/llkLoBDm1txk8fXWnAeUu9uCeievbGfuDXBAj8JbhXPPw
	1rkkAy4f/HPbcPE7hMSQFhf6j8Rx7FBC057YpVdcY8OaC4+hITWPbAiQydvnjYStYmME0bLlnok
	6FLGj+dUW/O8imBan23TtAfxUBAqVEFZTUinXO2E7BRngV1fU76SLddZep2C81m1rTQw==
X-Received: by 2002:a17:90a:d88b:b0:381:528a:808c with SMTP id 98e67ed59e1d1-38dc75e3d4fmr9572711a91.12.1783976279067;
        Mon, 13 Jul 2026 13:57:59 -0700 (PDT)
Received: from skinsburskii (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e172b6ce6sm403816a91.1.2026.07.13.13.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 13:57:58 -0700 (PDT)
Date: Mon, 13 Jul 2026 13:57:55 -0700
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
	dakr@kernel.org, david@kernel.org, decui@microsoft.com,
	haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org,
	kys@microsoft.com, leon@kernel.org, liam@infradead.org,
	lizhi.hou@amd.com, ljs@kernel.org, longli@microsoft.com,
	lyude@redhat.com, maarten.lankhorst@linux.intel.com,
	mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
	nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
	rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
	skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
	vbabka@kernel.org, wei.liu@kernel.org,
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-ID: <alVRU38lMfvmUFqJ@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <20260710151151.1e193eedd0cf2591ae392f76@linux-foundation.org>
 <alG2-RSitzPWClAX@skinsburskii>
 <20260710224950.53bcb43ce7e564f07a1f6a8c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260710224950.53bcb43ce7e564f07a1f6a8c@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 32F171C0005
X-Stat-Signature: rs8qdoocgzc43xua7ugxzgg57toiazkm
X-HE-Tag: 1783976280-632255
X-HE-Meta: U2FsdGVkX1+JFmKXWertZWaMt4aahvDLH6HFmSmXA2RxWDC79d0BTKT74IL5+Wufzzh736k3JRVRaTFFb0X4Xni+JCgibRA+oMsDhNcjL5IlDdqzB1pNkoryqGy02vYI/Ty8Wd7HGUlhBMIVug5cK9/q912hqLyudq3t4sue22GPju94hhfm8MOJvmgdSzUyOMjRa+cPsC07jVypzB4FnMVbUlu1dFceYTzP89qujuClcdEbG+BsC+xmmQmynZK1F5Ln3/YNwMmw00QYH5EpFFjV9Vqomd7qKfe94XK1Om6vXGoE9M7XZZIPWJxnPqT5O1P8/qj00uDeTd/YoAl/VL23rpJ1DaLE/roawBoAaSgr/PkjRFpVt2gK1f2GbU064IlafTCUZ2fcVsLagV+k0fpSduXOOLB9JG5iAVVsddFmSLLDwikGRHVeYzxh5+ioPX/xmQrk05cL5tVrAq4XNZ4Ge+iD71BNmcmRiX5+Pc/51TfEskiwG+lzKZjotHRKffu3zbWX9Q0ItBJCYj276SJxlwrzQwiphrTp+7r6SLp1ZgCtdLDrw+NnJCei/leYK3uJ7MPeI1IQllozp3Ylj5FYeE+4NLcAY/te8s0ihv4uF/Lpm8NGcvFgtmpZd6F4zq9hjOFWgVzB96p7ubfHY92hzGHIoPR+rShDTaaaN1P9vM2FL3hlKJ4IgqZi+M4yvoDoSDMn7nMwBIacJNoX14RI9Kw+zeAUZjlmckaVZxm1RwySORomvXvmD4DPAp4ZDA+S0p+iHUYvpJtLK9KYYwkmFgRUV/hAqUi5hcYIRe1qQQ/RXYK8F5FLJXYOh+eWkTFvHZ67ClM2UwfIxI4opVZUMYfmUKjDXvy/yvYgpGUNbH7xIc0jxRgC3wagwJHnFswyC7gvZJEheY7Fl5aoYEm8jGrSFsCWxxUpIZRrv49285m6GPRiYTJpO29XGc/UBy5B8h4Kken2tGpVhdd
 SdW2p2Q7
 13zS61agc8LzMmsOADJEjTMPMObU6Vw18UV6ikgpF6eMgoJ7yugT1yxab+UGwUq/iSYTDf143RQJyA8EbOGcvbZ83sYbLDh5Ej6r3FJaDLJklECvkrv9UegkayLQRPgrPDKDWaSDNYdkT6bcb3gq7VFgaO2Ley3c1LOsBnF16k50ietv+2e4FjUtzjPwQxdpMm3V/Ta63dqEk/33rz+dHVcWRqUz//L68SY4nhEeYcf88C77o1lLCjJB5EwWuMfbhAd9WSTs5PFdIhj3uCoAjXE1iwX0Y9v9JIEBowouSIqXtZ4wn572VZTz4WNNL3cX0l5dvePvl40e7zQtEBYA9CDiDHHsUWxSVCaB4jbDm3bt5BQMV1F/dt0x6wClZVT9ScWJHmgU367gzFZzzHRCEBD+YEPjZ96Hr1yh6JkjxwHWiZOZdtx/2vUwspKixIjjbd4SKGmCk0YHw+eURd3lAX/s/WUCw6yK8srBZcbNge2PET/L9UuOBr0BnoZqRkKuqk+Xj5O4T+c/f0tA+K5r5fRE+FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 10:49:50PM -0700, Andrew Morton wrote:
> On Fri, 10 Jul 2026 20:22:33 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> 
> > On Fri, Jul 10, 2026 at 03:11:51PM -0700, Andrew Morton wrote:
> > > On Fri, 10 Jul 2026 14:26:20 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:
> > > 
> > > > This series extends the HMM framework to support userfaultfd-backed memory
> > > > by allowing the mmap read lock to be dropped during hmm_range_fault().
> > > 
> > > Thanks.  This seems fairly mature and mostly-reviewed so I'll give it a
> > > spin in mm.git's mm-new branch.
> > > 
> > > Unfortunately Sashiko wasn't able to apply this or v7.  I'm not sure
> > > what base you were using.  Hopefully there's a reason for a v9 so we
> > > can retry this.
> > > 
> > 
> > I rebased this series on top of mm-new right before sending it out.
> > Should I have used a different branch?
> 
> mm-new is good - Sashiko attempts that.  But it's changing rapidly at
> this point in the development cycle.
> 

I’d like to send another revision addressing a few comments and also
replace the `max/max_t` check with something simpler.

Which branch should I base it on so that Sashiko can apply it
successfully?

Or would it be better to send fixups against `mm-new`?

Thanks, Stanislav

