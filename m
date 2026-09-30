Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C22CA5FC1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 09:11:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D94A6B0088; Wed, 30 Sep 2026 05:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489D16B0092; Wed, 30 Sep 2026 05:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FD26B0093; Wed, 30 Sep 2026 05:11:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B37E6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 05:11:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F5C8C06CC
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:11:34 +0000 (UTC)
X-FDA: 85269860508.07.450184C
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7F1768000C
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 09:11:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lOKiLwlV;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790759492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjNSxVYXKX8qPd2UHTWRIDsJB7UEqZyaJzAT3xKsOKI=;
	b=p+H/pJw2tsAii4YxncoHzZFprc7vRu94RiGw2D7tpA3UE9aN2PfqoKuscOZ0HVcfPKwpel
	XIMzK3Rb9MUoWJaaIjpFk2HVvbB+8Ekon7bIqln3sXhn9zWIMIppm5M4Da4eg0Zy00qqCe
	yK1UtF4OAnTuhnkkBRc2vqiYl3yM5nE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lOKiLwlV;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790759492;
	b=eUpVsnIoyahUaAChWAqs3qIE68C1lDRUl52hhiAufkZJXm4cOc4xv+F8lEJTkiqJ6qHd4T
	daichds3Ah7w/zZXsaNAoPsR30eOhbKjLi9w+CwUcaY96srxbcKTJZOcMW4kCXA4cbVufg
	TBVUTK+UvqkZyy0o0A+mqCEyTNMnCgM=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffed768deso10517895e9.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790759491; x=1791364291; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jjNSxVYXKX8qPd2UHTWRIDsJB7UEqZyaJzAT3xKsOKI=;
        b=lOKiLwlV2A/+KT5a4SfUTJZumVSafDCiQIOqPGMpioF+DurDga0oMN4uz3XyJuI9Gb
         Rv0wY/Ph5lxTQ8qIinOGQ1bOynzTPMSSmCf7RVd0+zJ0+m/tPBnJv4kA7AdB40T6Mbvb
         n/ndpFdxwhXLDP5ulpM5cfaUa9GQPb2yH2KnYhfYGnUsOO8XtuJbZRfsoj3V+t35v6Rq
         N96lVMBpjqhXrET0wbDqlDzyNatcVIawP0Cg7kQ2NUVkz6cqi/j4WuAC8Hsz32KFszCL
         I0pTBdwmJ8MqlLui/esBNh5ER84UNA6OwzReYZC1+4Tqxz7aHSbHbp5Zmh//JDYrWA+Y
         0CXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790759491; x=1791364291;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jjNSxVYXKX8qPd2UHTWRIDsJB7UEqZyaJzAT3xKsOKI=;
        b=X+DHroivxQMBTV4uuTCVFqTxedZYAkJEY9WKpYJjb4tbflexdRXqjytOIp9oRuKeoo
         J5Dghk17S/aCr755mPTLb7GMM4evGmF20sOn/Bm4J9PQbkZfYW7exrurYRuyPgFnSHS3
         kq49YjDRbyWCWBQQ4r8HYFq+9waLtbmOiMBqKTN9272fklsvcP0TXEsUVYlqWul6zKLT
         iv43y4tCgtGM6OfFPk8XuNNVC4vW5zf3Zv9295m5vU0a5E/1CUMlf03O6VpBDlMGIPWB
         AMgHepqblC1vhNWyb7O5uYVo/6CwbU70PiSu/zQle6L53KJ8ev8+1udmVEK3z/E9TjbR
         qxKA==
X-Forwarded-Encrypted: i=1; AKwUvBzS3kaBhX4K6WEg04wYxj8HQwaWUwLLDLySMVHcCr9OJKc6am3Oq9Fq7a6VljtFs0zelvxWFDmv3A==@kvack.org
X-Gm-Message-State: AFuF++lLb0/xuicArGs3PDRdiLnXB3mXe14fBtg3mu8NdqUO71pMkOul
	7ucfYKLytNjpuy9ka7VH2Ta/RSd60rQO64z9YITdvzp10eLqfoWzD1OgsMJPe83cplU=
X-Gm-Gg: AYBFou0tcnkrfoLZR3HqDBkbcbUa1jYS9o24S1VsSfbZxkEjDhyYdx+2QiN7aTQbxs8
	yNdbU1+gvQquT4wQ/GOFCUKbkOkAqv2tdMryvNf+FhWyuePX40asIhq0VHFxpWtNm0rZwlUPr+5
	MneLSwoasbJLIuk9EwhEIYrT88Ds5VnAr+Ol2K39qO+8nm5eGclpDeJTFKq7Z8m/Ovj0kiomwl9
	RN11UO/OcQMEoauXyy/qSd7h9NnhjsWHDiA//vkNXW+gtD8vIbIN4/pyK5u1ROv4KuMwaqRj9a0
	nW/noL/o7hx7FgzN4TWmr+mu8kntl0O85DEKJv9LKrZA6fqbvi8bNLq80tUt8c82TlM3aYsVMKV
	1vAV6YxC6qvO1UzxG1kNK/NsxgvnCk6Le+7AzlnRBMF0Y0MzOcREtbl3s7/LzPQdJAACsZSdT+c
	kdME6TI3I1GogfuL1TTc4/Q8QfqpX8oM2os/+Vm5U04jmU7c9JI1VkUBvsseChZmPtI7s=
X-Received: by 2002:a05:600c:a09:b0:49f:fc4f:9efb with SMTP id 5b1f17b1804b1-4a01b1a2029mr10750085e9.7.1790759490766;
        Wed, 30 Sep 2026 02:11:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c092:500::6:13b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0174d5191sm41627435e9.3.2026.09.30.02.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 02:11:30 -0700 (PDT)
Date: Wed, 30 Sep 2026 05:11:28 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, ziy@nvidia.com, joshua.hahnjy@gmail.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
Message-ID: <arzR_QtoMPtM5kUB@gourry-fedora-PF4VCD3F>
References: <20260930072617.64665-1-lizhe.67@bytedance.com>
 <arzLw18RiTN6Hmey@fedora>
 <7df34f77-2c52-47a3-a495-d782009ab543@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7df34f77-2c52-47a3-a495-d782009ab543@bytedance.com>
X-Rspam-User: 
X-Stat-Signature: gqifgebahcyemxj1crikcajca63ioo5y
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7F1768000C
X-HE-Tag: 1790759492-349318
X-HE-Meta: U2FsdGVkX1+mxaKIJCDHMwiuQv64wNWMQ6Xn2Oay2jM3yHqHFXLv9KEfI/nItTZL38UWH9Ao3w6V1aDhE9MvGq7pr8x2vHoTetF1Ow/GgWgKFk8cmcUpU7SS2YYoa32nIc3dhr171Lndxcfr7e/Xqn91+0Jd0zpdwE0L+B555C0jQBQgB7AFNb4DtSK3BoXJs+kCuIGMOGeW/10KKr1cojFJOxfR8FeIwy1W34tjKb1F1o65B3QfJ0UVFl8Kfycxds8SIlalcPfXJnval/1QGApJO69dbZOE9RaRN62RhJUnlleIaCsM8OkkgBlS4SqhAIpqAa9+35jYO32+HdmqQRSgBqL5GC0+ZIHH5qQoDH4B2MbTE90Eeg0/kODxyrr8S7qprMukBvJ4QncnVGLRKYC7sLv13sR91Ekd+ZkEkKn8WTTBn1WzHK6M/u/sspvNbXzg4C40TPHKFvU+fq2kKQPn/z6VaFW9KCTEt/N4LHPpHQCEYfjY5ghldx6h8+UU6pwjgKNnVnJmNZ20znw0HIXVhPaRGx+ik2og2qBMTBQHBjGCU0rNVU+LqnL799Rewz9jNfDfwZy2+Xsd4H2khNY9vGbTRbIXc9T6c8g/HnKW/XNDj0G6nymFTh1q6lQQpATQWfVJPRTYScMAxKWJGofj3gS0d5Ty5C6yboFHtVCMQVvQKjfs/BxivVvgAu6KmuilVbcG0wXOnqoy6VrclcAVHDllIxpN174E2NArQO7nEwGqKr93jvofxMLnL/gbQhq0MK4hVHyHmhOBN10xgoYD4Z17hE9f8cacvN1gN0cImn9Isd952g5v6Qs+DcL59c/2eTzvZgMqJCJDi1FNzVphfIPOCYuhPc9mTZ4gENPNPRP0WnebKKGScOXWNhR7Hsu+4/KAHtE/O6WakLjEB2XxiSME3mmXqPwQpALWqxU5/BZ3vz8MzDiZCoRbozRuuCSiyHkqYruoULf/7oN
 THyql2hh
 9jI5T2BJzU6BTXYJdOVTBAz7+lcYMFzbsINZw8GixHHsJJUwUKZ9F7Fd6stpRdvkhomBbFGP4LCUUvUiuI+G3sBAcqX1mWcgA+ptgNQCPeNi4T5uQxXfR34PKnmlSSSQzHfSF285KzzcHoM2/D0bxHIM6WA19GbmA2zEnxYMoYeeIeOlXWNp0MrZuT9mIMoo+zzUnpjWGElpYpR1jl5rxm70sTDqPXh5zgnCmsIa+R7U/t+45MGq9ScXQ7fU8tELkOuTQywSmONHouetGb7AwxtWv9wjTkW71dTvH9IlL6Rr4Kcoil74Kr7T/+1ajY5UzuJTlEwVMhlFXO97EvezNBEyakrDRDTFfe2Lu9OkuRsGfRbY7XD1RQx7k26zwo1IlyjM32ieTwpKMHsgwE14NTSNeSgoUxKYlTAukQNr0zyYu/kwZJWiXBX3UWOBY92DFIEF0za0LWwLGIRaFWtKjwLO1gZwYFW0D3mQv0DhuZZYT/FA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 04:59:50PM +0800, Li Zhe wrote:
> On 9/30/26 4:43 PM, Gregory Price wrote:
> > On Wed, Sep 30, 2026 at 03:26:17PM +0800, Li Zhe wrote:
> >> Allow MPOL_F_NUMA_BALANCING for MPOL_WEIGHTED_INTERLEAVE.  As with
> >> MPOL_BIND and MPOL_PREFERRED_MANY, keep migration constrained by the
> >> policy nodemask: if the CPU's node is outside the nodemask, do not
> >> migrate the folio there.
> >>
> > Why for WEIGHTED_INTERLEAVE and not INTERLEAVE as well?
> 
> 
> Thanks for pointing this out.
> 
> I focused on MPOL_WEIGHTED_INTERLEAVE in v1 because the motivating use
> case is to seed memory across tiers with a configurable ratio at
> allocation time, and then let NUMA balancing/memory tiering adjust the
> placement based on access patterns. With equal weights,
> MPOL_WEIGHTED_INTERLEAVE can also cover the regular interleave
> allocation pattern.
> 
> That said, I agree that MPOL_INTERLEAVE can be handled consistently as
> well. Since this is still an explicit opt-in via MPOL_F_NUMA_BALANCING,
> unless others see a reason to keep MPOL_INTERLEAVE out, I will extend
> this in v2 to cover both MPOL_INTERLEAVE and MPOL_WEIGHTED_INTERLEAVE
> with the same nodemask constraint.
> 

Looking at it, is there an actual reason to limit F_MORON at all? Or
should we just lift

                if (pol->flags & MPOL_F_MORON) {
                        /*
                         * Optimize placement among multiple nodes
                         * via NUMA balancing
                         */
                        if (node_isset(thisnid, pol->nodes))
                                break;
                        goto out;
                }

Out ahead of everything?

~Gregory

