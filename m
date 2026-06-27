Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5100BC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 08:24:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26BF66B00C3; Sat, 27 Jun 2026 04:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244A76B00C4; Sat, 27 Jun 2026 04:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134F96B00C5; Sat, 27 Jun 2026 04:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E3C316B00C3
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 04:24:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A5FE1A067E
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 08:24:00 +0000 (UTC)
X-FDA: 84925004640.13.848A764
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id A74C2C0002
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 08:23:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uGkVmwfl;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782548638;
	b=QUwEJqKg4PM6Zlsr0MEoZuofwbfz04VoXZOUPzNwioogr1eBLzLBb0Yc7osaWwXHq2sF57
	riueXSZZczMpsFOBOrEV+gcd01wEvqidK1hvxIA8D5XDbCb6u9YIZQGG1BDqqVQsMJ+8YX
	ql56phrnikSG8BEVvhKxiJQsVQI6Xh8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782548638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcCGwXLwtMV8RI4Wg+2Z1TCVKqOFak4eb3FLVCz7QhM=;
	b=tCVPmyEde1V4AbE6Hq/eJcnlgsNzHJWZoI6Hka86E1rX+wDFgeTpu5hol4QLtWhqOysnPw
	9tbupFRsUTLKJJUCekiekmKhv/DcYTlFn+e4q6dHRn08HXIpbaOEI4qoiCdSXsANZt71O+
	sjEq8ijuCNrb91kbYTm+J9FARXTOU4U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=uGkVmwfl;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92120eb916aso183576785a.1
        for <linux-mm@kvack.org>; Sat, 27 Jun 2026 01:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782548638; x=1783153438; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qcCGwXLwtMV8RI4Wg+2Z1TCVKqOFak4eb3FLVCz7QhM=;
        b=uGkVmwfl2zeaHtBUVgcSiMNaCCt2NEXt1dl/V+/fvI40jWB3Vp63DeQ2hMVoNM+XBb
         0CZBYNvUdmLQAroHNuXf9VPypBoNZVE4y0lYXoPv2P8yyrt/H2LbN/SMGLI7xH2eyzTM
         B+aLdgzwKcYWEh1qOLI9AUFrUZF/S7P6jdPK6eGLY1e4UhWJqUfKu0jqvpTLEBl3uUs4
         vqCF4uum7S4N8fv54OrsR3tqDalo9oxUDBjYWIF0UnowtIXbTwxZDI/ErlMbeBcYLND+
         prqUoFc/2QvxCLi2n6HmNUaLDeZnNx3AGmyBbpJkyj131ET6K6cZ8pVoNB+308blvYh5
         kxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782548638; x=1783153438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qcCGwXLwtMV8RI4Wg+2Z1TCVKqOFak4eb3FLVCz7QhM=;
        b=UWSQNZfjUJ+IGkD5Z5v17HMInJxhq67dmtjBLjvKaSLoLaK0geJuF9JnhC5WX+dIUq
         g/WNQcFvCq8o+EsyJum1rns3/lG4WDb8Ts4Oa8jxktSfghvCt7CzyPedMWwuXX9o8XUR
         VRzI6v5/DHUaDG8ccrqDOIVoeizCBOZoPub77Pqn7LKH6HtT1/kDpkfqLJe1kfJZ8G35
         GGvsmESdgHjIVUHCWLDg/igeGa9a8yjDQXN3R5aEa1PnlheOuA2vRAtmkJ+7Rn1aWj7e
         6IYF49P/Lmrn+NNxswvtE+kX4Id7kMF7wA5G/ieqgfQCCs0gdCZQv9jKSgnmH/dm6suL
         kyCg==
X-Gm-Message-State: AOJu0YyqQI2Y5fLvc7KCdXxKGVShSKQuo4/LuRawtu75DeyyuUX28+nA
	GdysLkq6sA/kttpdjLPrEDg9Yy6fhv85HyryoRIfKr8b5U72eaGpp9fseKJGDT3MfJVKf/qXSwF
	9wyb0
X-Gm-Gg: AfdE7cncLEsRtfg6EJOkGHadCqPOmmWS2r+/D3bl/fKEIf+eGVovvXXKmp32TabaJuw
	YZBjny9eY7me96SLkaqSmhnzrlh/HxokoSSZFS80IY+MVH1ff6ydrodby1CgGdV062qsih1d1cA
	VIr4UrthL0zeoYdVfvEJGU305yxcwG/zIgt5afAGy02otBeNrvGXpU494SqjuDk6gVsYud0N9y2
	4HZAzerG3xEPpmeWvxpLyuevQrqWnvNsmZgPKg8iwmd1pe9/eDy1dv305e1pJSnoxeRKs1lzOv0
	BVrmzmwXt4vp2MOKS3mxp/dDURb98zdtOQoJCkkclnrNfQSOTkW3wWqxaXoD2c9Dv7jdo0ScPgN
	BkQPc6QObUyJbt91B4E/MJ3FGA1lkXJ+u7ZCUkPSEKpNAt8rDfYEpPJXwx+KXBAmaacrfodt8cf
	5PzWYLzN6mVRqL8gldDO4l4NegQ66/22NVd5X6lxOc/srWXLUBYGMwCMLUVZtvKlwMxo9ZA4TQP
	14a9XU=
X-Received: by 2002:a05:620a:28d3:b0:915:f163:a8 with SMTP id af79cd13be357-9293d0ba9a5mr1471270785a.53.1782548637840;
        Sat, 27 Jun 2026 01:23:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-926004ac1b8sm1375302685a.36.2026.06.27.01.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 01:23:56 -0700 (PDT)
Date: Sat, 27 Jun 2026 04:23:52 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	kernel-team@meta.com, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, hannes@cmpxchg.org, mgorman@techsingularity.net,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: flush per-cpu node stats when a node goes
 offline
Message-ID: <aj-ImLdFnKk7K6Fc@gourry-fedora-PF4VCD3F>
References: <20260627073107.523499-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627073107.523499-1-gourry@gourry.net>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A74C2C0002
X-Rspam-User: 
X-Stat-Signature: 83b4g3forowzttzd5tisfhxpj1m8ythz
X-HE-Tag: 1782548638-215008
X-HE-Meta: U2FsdGVkX1+VP8M4PiBhjGvkawKKoTMZralAT9AUP6Gvq/sO1dQ0ksbvtnu0aEZrsQyJnKBkhBD5j89KpyoAuPqdNWgoF2XBFVLHDWpPYF02TfBtXbMzdCVIfDaPFhoLzLr4OPC2RNAv0tsjmB7w2EYPIflao4jjaablfuf+7dxFy4JqiILfIZxnODYTFXcemos408pz1igKicgcdYllppXeXWutvxJjovHCSb0J4c+NkgbFhaibuWB2kDzP6P1eQuCWyIcdZfeDw/unDFtRgPZyAId8t6vsrJGuwnfeFV7FS1QKnPxcK0eMqncNX7/773jnDqdUUpKJN4LjibyAN2tPZpjMd3b8vHUzb0AEy7vkyS4fOXmv8xbYZXQ5SqcbZijGoq0pWwvDuvdXivuPClmytqUyXa7NNbAwNOm2vSFA29Lv68CItV60ITGazdwaqyHjcxCm+CE1zwLwC1F2h9IPJmqRd/XGBCO1sB9Ak7hd1Bp68p6JGuTksyMX9uW0G2WLY2VZLobitKs+q7Z3N6mS7lC68FclYqKN9qoPBM50C/lG/T9Xht6WDAVWzX3xVs7QdlUbalBvlBKud8qWCr3aJbDdM8DPziwLUCRCD4XnOFIn9yMtbnvIoqpKR3budZdO80xknNk1VAqAmOQepOF9U/GkbBhFsbdsaWQWTn6xf3R1oAeh+7ZnI6BFvVItz8/oRj4PE/3jwef+g6UzS5TQCALv1FU6DvnUcoRG/Wfniw1ieaFCvQEBBNi60hQihVt2LASYKk4bUFt85whVqyX5qCbvcQxr1/RNXvJSTJ1AfosrPgDOUV1EBOKQpPBE/pP6qLyOYrwNaa8OXDYSmZCzUuhsMOR7Z30BhPUbWKkA/TD9EXIAJ76oa4Hx2waJHwvlkoGElRJf17p9kRzDOFhHi5g8ht9QBJIDghSIjjMv5Ce8zfxbJduVjBEtT8dGlNXtdTkQPPJ/0mQGRrw
 FzfKpljP
 d6HhWK1wfEW4wCvK8cpdjSBtTh9RPY5NiqL2jbMYAJ4svv8E91OYMiXvJXAho0VQ/MC4bqvLXgm0aGRtkpDmIK4sM+aQ1aoS29WQeUka6dW0MUWZTcQm8SgW9GlRus1mh9i/12/n3NeuBy5bx8vNnp2ataBLupONx5pSvXxKIEdfzPr13j9siPlOjeyqEeF4rOvgiNvRrlmjkw8EaNIXHN5CO7NeKWfUzpyJ+kdMolU+AKet1vmRb00zF2cGL1GuBqvGZ3TcUuVFPzS+PCfY3x2BZQuNAYFOOmufjP/pb/loNq9dFNMYyXnUXBVr+CAzqUfaLRDqhd5wXR7A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 03:31:07AM -0400, Gregory Price wrote:
>  
>  	/*
>  	 * all memory/cpu of this node are removed, we can offline this
> -	 * node now.
> +	 * node now.  Fold any pending per-cpu vmstat diffs into the global
> +	 * counters first: once the node leaves the online set the periodic
> +	 * fold skips it, orphaning the residual on a later online.
>  	 */
> +	sync_vm_stats();

Sashiko points out this can deadlock on concurrent cpu hotplug, which
after a quick look seems accurate.

Has also made me realize the sync code is also racy with cpu hotplug
as well as it iterates per-online-cpu.

There are probably more races like this out there.

Will need to give this a little more thought.

>  	node_set_offline(nid);
>  	unregister_node(nid);
>  }

